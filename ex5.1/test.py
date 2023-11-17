import pymysql
from tabulate import tabulate

DATABASE_NAME = 'university'
print("?")
# Connect to MySQL database (or create a new one if it doesn't exist)
conn = pymysql.connect(
    host='localhost',
    user='root',
    password='sesame80',
    port=3306,
    database=DATABASE_NAME
)

cursor = conn.cursor()

# Create database if it doesn't exist
cursor.execute(f'CREATE DATABASE IF NOT EXISTS {DATABASE_NAME}')
cursor.execute(f'USE {DATABASE_NAME}')

# Create tables if they don't exist
cursor.execute('''
    CREATE TABLE IF NOT EXISTS students (
        student_id INT AUTO_INCREMENT PRIMARY KEY,
        student_name VARCHAR(255) NOT NULL
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS courses (
        course_id INT AUTO_INCREMENT PRIMARY KEY,
        course_name VARCHAR(255) NOT NULL,
        schedule VARCHAR(255) NOT NULL
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS enrollments (
        enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
        student_id INT,
        course_id INT,
        FOREIGN KEY (student_id) REFERENCES students (student_id),
        FOREIGN KEY (course_id) REFERENCES courses (course_id)
    )
''')

# Function to enroll a student in a course
def enroll_student(student_id, course_id):
    try:
        cursor.execute('INSERT INTO enrollments (student_id, course_id) VALUES (%s, %s)', (student_id, course_id))
        conn.commit()
        print("Student enrolled successfully.")
    except pymysql.Error as e:
        print(f"Error enrolling student: {e}")

# Function to display students enrolled in a course
def students_in_course(course_id):
    try:
        cursor.execute('''
            SELECT students.student_name
            FROM students
            JOIN enrollments ON students.student_id = enrollments.student_id
            WHERE enrollments.course_id = %s
        ''', (course_id,))
        students = cursor.fetchall()
        return students
    except pymysql.Error as e:
        print(f"Error retrieving students in course: {e}")
        return []

# Function to display courses a student is enrolled in
def courses_for_student(student_id):
    try:
        cursor.execute('''
            SELECT courses.course_name, courses.schedule
            FROM courses
            JOIN enrollments ON courses.course_id = enrollments.course_id
            WHERE enrollments.student_id = %s
        ''', (student_id,))
        courses = cursor.fetchall()
        return courses
    except pymysql.Error as e:
        print(f"Error retrieving courses for student: {e}")
        return []

# Function to display courses and their schedule for a student on a given day
def student_schedule(student_id, day_of_week):
    try:
        cursor.execute('''
            SELECT courses.course_name, courses.schedule
            FROM courses
            JOIN enrollments ON courses.course_id = enrollments.course_id
            WHERE enrollments.student_id = %s AND courses.schedule LIKE %s
        ''', (student_id, f'%{day_of_week}%'))
        schedule = cursor.fetchall()
        return schedule
    except pymysql.Error as e:
        print(f"Error retrieving student schedule: {e}")
        return []

# Main program loop
while True:
    print("\n*** University Management System ***")
    print("1. Enroll a new student")
    print("2. Introduce a new course")
    print("3. Enroll a student in a course")
    print("4. View students in a course")
    print("5. View courses for a student")
    print("6. View courses and schedule for a student on a given day")
    print("7. Exit")

    choice = input("Enter your choice: ")

    if choice == '1':
        student_name = input("Enter the student's name: ")
        try:
            cursor.execute('INSERT INTO students (student_name) VALUES (%s)', (student_name,))
            conn.commit()
            print("Student enrolled successfully.")
        except pymysql.Error as e:
            print(f"Error enrolling student: {e}")

    elif choice == '2':
        course_name = input("Enter the course name: ")
        schedule = input("Enter the course schedule: ")
        try:
            cursor.execute('INSERT INTO courses (course_name, schedule) VALUES (%s, %s)', (course_name, schedule))
            conn.commit()
            print("Course introduced successfully.")
        except pymysql.Error as e:
            print(f"Error introducing course: {e}")

    elif choice == '3':
        student_id = int(input("Enter the student ID: "))
        course_id = int(input("Enter the course ID: "))
        enroll_student(student_id, course_id)

    elif choice == '4':
        course_id = int(input("Enter the course ID: "))
        enrolled_students = students_in_course(course_id)
        print(tabulate(enrolled_students, headers=['Student Name']))

    elif choice == '5':
        student_id = int(input("Enter the student ID: "))
        enrolled_courses = courses_for_student(student_id)
        print(tabulate(enrolled_courses, headers=['Course Name', 'Schedule']))

    elif choice == '6':
        student_id = int(input("Enter the student ID: "))
        day_of_week = input("Enter the day of the week: ")
        student_schedule_info = student_schedule(student_id, day_of_week)
        print(tabulate(student_schedule_info, headers=['Course Name', 'Schedule']))
    elif choice == '7':
        break

    else:
        print("Invalid choice. Please enter a valid option.")

# Close the database connection when exiting the program
conn.close()
