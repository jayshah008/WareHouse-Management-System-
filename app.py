from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector

app = Flask(__name__)
app.secret_key = 'secret_key'  

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="pass",
    database="warehouse_management"
)
cursor = db.cursor()

users = {
    'Jay': 'pass',  
}

customer_names = {
    'Bharadwaj' : 'pass',
}

@app.route('/')
def index():
    cursor.execute("""
        SELECT Product.Product_id, Product.Product_name, Product.Unit_size, 
               Product.Unit_weight, Product.Discount, Product.Price, 
               Product.In_stock, Category.Category_name, Supplier.ContactPerson
        FROM Product
        LEFT JOIN Category ON Product.Category_id = Category.Category_id
        LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id
    """)
    products = cursor.fetchall()
    return render_template('index.html', products=products)

@app.route('/customer')
def index_user():
    cursor.execute("""
        SELECT Product.Product_id, Product.Product_name, Product.Unit_size, 
               Product.Unit_weight, Product.Discount, Product.Price, 
               Product.In_stock, Category.Category_name, Supplier.ContactPerson
        FROM Product
        LEFT JOIN Category ON Product.Category_id = Category.Category_id
        LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id
    """)
    products = cursor.fetchall()
    return render_template('index_user.html', products=products)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['uname']
        password = request.form['psw']
        if users.get(username) == password:
            session['username'] = username 
            return redirect(url_for('index'))
        elif customer_names.get(username) == password:
            session['username'] = username
            return redirect(url_for('index_user'))
        else:
            flash('Invalid username or password', 'danger')
    return render_template('login.html')

@app.route('/add_product', methods=['POST'])
def add_product():
    if 'Jay' not in session:
        flash('You must be logged in to add products', 'danger')
        return redirect(url_for('login'))

    product_name = request.form.get('product_name')
    unit_size = request.form.get('unit_size')
    unit_weight = request.form.get('unit_weight')
    discount = request.form.get('discount')
    price = request.form.get('price')
    in_stock = request.form.get('in_stock')
    supplier_id = request.form.get('supplier_id')
    category_id = request.form.get('category_id')
    
    cursor.execute("""
        INSERT INTO Product 
            (Product_name, Unit_size, Unit_weight, Discount, Price, In_stock, Supplier_id, Category_id) 
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """, (product_name, unit_size, unit_weight, discount, price, in_stock, supplier_id, category_id))
    db.commit()
    if 'Jay' not in session:
        flash('You must be logged in to add products', 'danger')
        return redirect(url_for('login'))


    flash('Product added successfully', 'success')
    return redirect(url_for('index'))

@app.route('/edit_product/<int:product_id>', methods=['GET', 'POST'])
def edit_product(product_id):
    if request.method == 'POST':
        product_name = request.form.get('product_name')
        unit_size = request.form.get('unit_size')
        unit_weight = request.form.get('unit_weight')
        discount = request.form.get('discount')
        price = request.form.get('price')
        in_stock = request.form.get('in_stock')
        supplier_id = request.form.get('supplier_id')
        category_id = request.form.get('category_id')
        
        cursor.execute("""
            UPDATE Product 
            SET Product_name=%s, Unit_size=%s, Unit_weight=%s, Discount=%s, 
                Price=%s, In_stock=%s, Supplier_id=%s, Category_id=%s
            WHERE Product_id=%s
        """, (product_name, unit_size, unit_weight, discount, price, in_stock, supplier_id, category_id, product_id))
        db.commit()

        flash('Product updated successfully', 'success')
        return redirect(url_for('index'))

    cursor.execute("""
        SELECT * FROM Product
        LEFT JOIN Category ON Product.Category_id = Category.Category_id
        LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id
        WHERE Product_id = %s
    """, (product_id,))
    product = cursor.fetchone()

    cursor.execute("SELECT * FROM Category")
    categories = cursor.fetchall()

    cursor.execute("SELECT * FROM Supplier")
    suppliers = cursor.fetchall()

    return render_template('edit_product.html', product=product, categories=categories, suppliers=suppliers)

@app.route('/delete_product/<int:product_id>')
def delete_product(product_id):
    cursor.execute("DELETE FROM Product WHERE Product_id = %s", (product_id,))
    db.commit()
    flash('Product deleted successfully', 'success')
    return redirect(url_for('index'))

@app.route('/orders')
def orders():
    cursor.execute("""
        SELECT 
            Order1.order_id, 
            Order1.order_date, 
            Customer.first_name as customer_first_name, 
            Customer.last_name as customer_last_name, 
            Employee.first_name as employee_first_name, 
            Employee.last_name as employee_last_name, 
            Order1.TotalAmount
        FROM 
            Order1 
        JOIN 
            Customer ON Order1.customer_id = Customer.customer_id
        JOIN 
            Employee ON Order1.staff_id = Employee.Employee_id
    """)
    orders = cursor.fetchall() 
    return render_template('orders.html', orders=orders)

@app.route('/customers')
def customers():
    cursor.execute("""
        SELECT 
            Customer.customer_id, 
            Customer.first_name, 
            Customer.last_name, 
            Customer.phone, 
            Customer.address, 
            Customer.email, 
            Employee.first_name as employee_first_name, 
            Employee.last_name as employee_last_name, 
            Customer.MembershipLevel, 
            Customer.MembershipExpiryDate
        FROM 
            Customer 
        JOIN 
            Employee ON Customer.staff_id = Employee.Employee_id
    """)
    customers = cursor.fetchall() 
    return render_template('customers.html', customers=customers)

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))

@app.route('/search_products', methods=['POST'])
def search_products():
    search_term = request.form.get('search_term')
    if search_term:
        cursor.execute("""
            SELECT Product.Product_id, Product.Product_name, Product.Unit_size, 
                   Product.Unit_weight, Product.Discount, Product.Price, 
                   Product.In_stock, Category.Category_name, Supplier.ContactPerson
            FROM Product
            LEFT JOIN Category ON Product.Category_id = Category.Category_id
            LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id 
            WHERE Category.category_name = %s
        """, (search_term,))
    else:
        cursor.execute("""
            SELECT Product.Product_id, Product.Product_name, Product.Unit_size, 
                   Product.Unit_weight, Product.Discount, Product.Price, 
                   Product.In_stock, Category.Category_name, Supplier.ContactPerson
            FROM Product
            LEFT JOIN Category ON Product.Category_id = Category.Category_id
            LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id
        """)

    products = cursor.fetchall()
    return render_template('index.html', products=products)

@app.route('/CustomerSearch_products', methods=['POST'])
def customer_search_products():
    search_term = request.form.get('search_term')
    if search_term:
        cursor.execute("""
            SELECT Product.Product_id, Product.Product_name, Product.Unit_size, 
                   Product.Unit_weight, Product.Discount, Product.Price, 
                   Product.In_stock, Category.Category_name, Supplier.ContactPerson
            FROM Product
            LEFT JOIN Category ON Product.Category_id = Category.Category_id
            LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id 
            WHERE Category.category_name = %s
        """, (search_term,))
    else:
        cursor.execute("""
            SELECT Product.Product_id, Product.Product_name, Product.Unit_size, 
                   Product.Unit_weight, Product.Discount, Product.Price, 
                   Product.In_stock, Category.Category_name, Supplier.ContactPerson
            FROM Product
            LEFT JOIN Category ON Product.Category_id = Category.Category_id
            LEFT JOIN Supplier ON Product.Supplier_id = Supplier.Supplier_id
        """)

    products = cursor.fetchall()
    return render_template('index_user.html', products=products)




if __name__ == '__main__':
    app.run(debug=True)
