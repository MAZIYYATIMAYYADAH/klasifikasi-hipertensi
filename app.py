from flask import Flask, request, jsonify, render_template, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
import pandas as pd
from twilio.rest import Client
import joblib
from dotenv import load_dotenv
import os


app = Flask(__name__)
app.secret_key = 'ae91326eb459e4b0cb9c81dda264db6c252b6b1fde90fef2'

# Konfigurasi MySQL
app.config['MYSQL_HOST'] = '212.2.245.34'
app.config['MYSQL_USER'] = 'hipertensi'
app.config['MYSQL_PASSWORD'] = '123456789'
app.config['MYSQL_DB'] = 'hipertensi'

mysql = MySQL(app)

# Muat variabel dari file .env
load_dotenv()

# Ambil variabel dari environment
TWILIO_ACCOUNT_SID = os.getenv('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN = os.getenv('TWILIO_AUTH_TOKEN')
TWILIO_PHONE_NUMBER = os.getenv('TWILIO_PHONE_NUMBER')

client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

# Load model
model = joblib.load('static/model/niv.pkl')

def predict_blood_pressure(model, input_data):
    y_pred = model.predict(input_data)
    return y_pred

@app.route('/')
def index():
    session.clear()
    return render_template ('index.html')

@app.route('/klasifikasi', methods=['GET', 'POST'])
def klasifikasi():
    if request.method == 'POST':
        try:
            # Ambil data dari form
            age = int(request.form['age'])
            Smoker = int(request.form['Smoker'])
            cigsPerDay = int(request.form['cigsPerDay'])
            BPMeds = int(request.form['BPMeds'])
            diabetes = int(request.form['diabetes'])
            totChol = int(request.form['totChol'])
            SysBP = int(request.form['SysBP'])
            DiaBP = int(request.form['DiaBP'])
            heartRate = int(request.form['heartRate'])
            BMI = float(request.form['BMI'])
            glucose = int(request.form['glucose'])

            # Buat input data frame
            input_data = {
                'age': [age],
                'Smoker': [Smoker],
                'cigsPerDay': [cigsPerDay],
                'BPMeds': [BPMeds],
                'diabetes': [diabetes],
                'totChol': [totChol],
                'SysBP': [SysBP],
                'DiaBP': [DiaBP],
                'heartRate': [heartRate],
                'BMI': [BMI],
                'glucose': [glucose]
            }
            input_df = pd.DataFrame(input_data)

            # Prediksi
            predicted_class = predict_blood_pressure(model, input_df)
            grade_id = int(predicted_class[0])

            # Ambil grade label dari database
            cursor = mysql.connection.cursor()
            query = "SELECT cgrade FROM grade WHERE id = %s"
            cursor.execute(query, (grade_id,))
            grade_label = cursor.fetchone()[0]

            # Ambil semua solusi dan saran dari database
            query_detail = "SELECT saran, solusi FROM detail WHERE grade_id = %s"
            cursor.execute(query_detail, (grade_id,))
            results = cursor.fetchall()

            saran_list = [result[0] for result in results]
            solusi_list = [result[1] for result in results]

            # Simpan hasil ke database
            insert_query = """
            INSERT INTO hasil_klasifikasi (age, Smoker, cigsPerDay, BPMeds, diabetes, totChol, SysBP, DiaBP, heartRate, BMI, glucose, grade_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(insert_query, (age, Smoker, cigsPerDay, BPMeds, diabetes, totChol, SysBP, DiaBP, heartRate, BMI, glucose, grade_id))
            mysql.connection.commit()

            response = {
                'prediction': grade_id,
                'grade_label': grade_label,
                'saran': saran_list,
                'solusi': solusi_list
            }

        except Exception as e:
            response = {'error': str(e)}

        return jsonify(response)

    return render_template('index.html', prediction=None)

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'message': 'Username and password are required'}), 400

    hashed_password = generate_password_hash(password, method='pbkdf2:sha256')

    cursor = mysql.connection.cursor()
    cursor.execute("INSERT INTO admin (username, password) VALUES (%s, %s)", (username, hashed_password))
    mysql.connection.commit()
    cursor.close()

    return jsonify({'message': 'Registration successful!'}), 201

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM admin WHERE username=%s", (username,))
    user = cursor.fetchone()
    cursor.close()
    
    if user and check_password_hash(user[2], password):
        session['loggedin'] = True
        session['id'] = user[0]
        session['username'] = user[1]
        return jsonify({'status': 'success', 'message': 'Login successful!'}), 200
    else:
        return jsonify({'status': 'error', 'message': 'Invalid credentials, please try again.'}), 401

@app.route('/logout')
def logout():
    # Clear all session data
    session.clear()
    return jsonify({'status': 'success', 'message': 'Logged out successfully!'}), 200

@app.route('/dashboard')
def dashboard():
    if 'username' not in session:
        return redirect(url_for('index'))  # Redirect to the index page if not logged in

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM grade")
    grades = cur.fetchall()

    cur.execute("SELECT detail.id, grade.cgrade, detail.saran, detail.solusi FROM detail INNER JOIN grade ON detail.grade_id = grade.id")
    details = cur.fetchall()

    cur.close()

    return render_template('dashboard/dashboard.html', details=details, grades=grades, username=session['username'])

# Route untuk menambahkan detail
@app.route('/add_detail', methods=['POST'])
def add_detail():
    if request.method == 'POST':
        grade_id = request.form['grade']
        saran = request.form['saran']
        solusi = request.form['solusi']
        # Lakukan insert data ke database
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO detail (grade_id, saran, solusi) VALUES (%s, %s, %s)", (grade_id, saran, solusi))
        mysql.connection.commit()
        cur.close()

        flash('Data berhasil ditambahkan', 'success')
        return redirect(url_for('dashboard'))

    return render_template('dashboard/dashboard.html')

@app.route('/edit_detail/<int:id>', methods=['POST', 'GET'])
def edit_detail(id):
    cur = mysql.connection.cursor()

    # Ambil data grade untuk dropdown
    cur.execute("SELECT * FROM grade")
    grades = cur.fetchall()

    # Ambil data detail berdasarkan id untuk ditampilkan di form edit
    cur.execute("SELECT id, grade_id, saran, solusi FROM detail WHERE id = %s", [id])
    detail = cur.fetchone()

    if request.method == 'POST':
        saran = request.form['saran']
        solusi = request.form['solusi']
        grade_id = request.form['grade']
        # Lakukan update data di database
        cur.execute("UPDATE detail SET grade_id=%s, saran=%s, solusi=%s WHERE id=%s", (grade_id, saran, solusi, id))
        mysql.connection.commit()
        cur.close()

        flash('Data berhasil diubah', 'success')
        return redirect(url_for('dashboard2'))  # Redirect ke halaman utama setelah berhasil

    cur.close()
    return render_template('dashboard/dashboard.html', detail=detail, grades=grades)  # Tampilkan form edit detail dengan opsi grade

@app.route('/delete_detail/<int:id>', methods=['POST', 'DELETE'])
def delete_detail(id):
    cur = mysql.connection.cursor()

    # Ambil data grade untuk dropdown
    cur.execute("SELECT * FROM grade")
    grades = cur.fetchall()

    # Ambil data detail berdasarkan id untuk ditampilkan di form edit
    cur.execute("SELECT id, grade_id, saran, solusi FROM detail WHERE id = %s", [id])
    detail = cur.fetchone()

    if request.method == 'POST':
        cur.execute("DELETE FROM detail WHERE id = %s", [id])
        mysql.connection.commit()
        cur.close()
        flash('Data berhasil dihapus', 'success')
        return redirect(url_for('dashboard'))

    cur.close()
    return render_template('dashboard/dashboard.html', detail=detail, grades=grades)

@app.route('/send_whatsapp', methods=['POST'])
def send_whatsapp():
    try:
        whatsapp_number = request.form['whatsappNumber']
        prediction = request.form['prediction']
        grade_label = request.form['grade_label']
        saran_list = request.form.getlist('saran[]')
        solusi_list = request.form.getlist('solusi[]')

        message_body = f"Berdasarkan Hasil Diagnosa Sistem, Pasien Menderita Penyakit Hipertensi : {grade_label} ({prediction})\n\n"
        message_body += "Saran:\n" + "\n".join(saran_list) + "\n\n"
        message_body += "Solusi:\n" + "\n".join(solusi_list)

        message = client.messages.create(
            body=message_body,
            from_='whatsapp:' + TWILIO_PHONE_NUMBER,
            to='whatsapp:' + whatsapp_number
        )

        response = {'message': 'Hasil berhasil dikirim ke WhatsApp'}
    except Exception as e:
        response = {'error': str(e)}

    return jsonify(response)

@app.route('/chart')
def chart():
    return render_template('dashboard/chart.html')

@app.route('/get_chart_data', methods=['GET'])
def get_chart_data():
    start_date = request.args.get('startDate')
    end_date = request.args.get('endDate')

    cur = mysql.connection.cursor()
    
    if start_date and end_date:
        query = """
            SELECT grade_id, COUNT(*) as count 
            FROM hasil_klasifikasi 
            WHERE created_at BETWEEN %s AND %s 
            GROUP BY grade_id
        """
        cur.execute(query, (start_date, end_date))
    else:
        cur.execute("SELECT grade_id, COUNT(*) as count FROM hasil_klasifikasi GROUP BY grade_id")
    
    results = cur.fetchall()
    
    data = [0] * 7
    for row in results:
        data[row[0] - 1] = row[1]

    return jsonify(data)

@app.route('/artikel1')
def artikel1():
    return render_template('artikel1.html')

@app.route('/artikel2')
def artikel2():
    return render_template('artikel2.html')

@app.route('/artikel3')
def artikel3():
    return render_template('artikel3.html')

@app.route('/artikel4')
def artikel4():
    return render_template('artikel4.html')

@app.route('/artikel5')
def artikel5():
    return render_template('artikel5.html')

@app.route('/artikel6')
def artikel6():
    return render_template('artikel6.html')

if __name__ == '__main__':
    app.run(debug=True)
