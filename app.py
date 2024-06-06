from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api, Resource, fields, Namespace
from sqlalchemy.orm import validates
from sqlalchemy import func

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5432/shop'
db = SQLAlchemy(app)
api = Api(app, title='Shop API', version='1.0', description='API для управления магазином', doc='/swagger/')

# Создание пространств имен
ns_users = Namespace('users', description='Операции с пользователями')
ns_products = Namespace('products', description='Операции с товарами')
ns_orders = Namespace('orders', description='Операции с заказами')
ns_order_details = Namespace('order_details', description='Операции с деталями заказов')

# Модель пользователя
user_model = ns_users.model('User', {
    'username': fields.String(required=True, description='Имя пользователя'),
    'email': fields.String(required=True, description='Email пользователя'),
    'password': fields.String(required=True, description='Пароль пользователя')
})

# Модель товара
product_model = ns_products.model('Product', {
    'product_name': fields.String(required=True, description='Название товара'),
    'price': fields.Float(required=True, description='Цена товара'),
    'stock': fields.Integer(required=True, description='Количество товара на складе')
})

# Модель заказа
order_model = ns_orders.model('Order', {
    'user_id': fields.Integer(required=True, description='ID пользователя')
})

# Модель детали заказа
order_detail_model = ns_order_details.model('OrderDetail', {
    'order_id': fields.Integer(required=True, description='ID заказа'),
    'product_id': fields.Integer(required=True, description='ID товара'),
    'quantity': fields.Integer(required=True, description='Количество')
})

# Таблица пользователей
class User(db.Model):
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(100), nullable=False, unique=True)
    password = db.Column(db.String(50), nullable=False)

# Таблица товаров
class Product(db.Model):
    product_id = db.Column(db.Integer, primary_key=True)
    product_name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    stock = db.Column(db.Integer, nullable=False)

    @validates('price', 'stock')
    def validate_positive(self, key, value):
        if value < 0:
            raise ValueError(f"{key} must be positive.")
        return value

# Таблица заказов
class Order(db.Model):
    order_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable=False)
    order_date = db.Column(db.DateTime, default=func.current_timestamp(), nullable=False)

# Таблица деталей заказов
class OrderDetail(db.Model):
    order_detail_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('order.order_id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.product_id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)

    @validates('quantity')
    def validate_quantity(self, key, value):
        if value < 0:
            raise ValueError(f"{key} must be positive.")
        return value

    @validates('price')
    def validate_price(self, key, value):
        product = Product.query.get(self.product_id)
        return product.price * self.quantity

# Создание всех таблиц
with app.app_context():
    db.create_all()

# Обработчик корневого URL
@app.route('/')
def home():
    return "Welcome to the API. Use /swagger/ for API documentation."

# Функция для поиска минимального доступного ID
def get_min_available_id(model, column):
    existing_ids = {id_tuple[0] for id_tuple in db.session.query(column).all()}
    min_id = 1
    while min_id in existing_ids:
        min_id += 1
    return min_id

# Маршруты для пользователей
@ns_users.route('/')
class UserList(Resource):
    @ns_users.expect(user_model)
    def post(self):
        data = request.json
        min_user_id = get_min_available_id(User, User.user_id)
        new_user = User(user_id=min_user_id, username=data['username'], email=data['email'], password=data['password'])
        db.session.add(new_user)
        db.session.commit()
        return jsonify({'message': 'User created successfully'}), 201

@ns_users.route('/<int:user_id>')
class UserResource(Resource):
    def get(self, user_id):
        user = User.query.get_or_404(user_id)
        return jsonify({'user_id': user.user_id, 'username': user.username, 'email': user.email})

    @ns_users.expect(user_model)
    def put(self, user_id):
        data = request.json
        user = User.query.get_or_404(user_id)
        user.username = data['username']
        user.email = data['email']
        user.password = data['password']
        db.session.commit()
        return jsonify({'message': 'User updated successfully'})

    def delete(self, user_id):
        user = User.query.get_or_404(user_id)
        db.session.delete(user)
        db.session.commit()
        return jsonify({'message': 'User deleted successfully'})

# Маршруты для товаров
@ns_products.route('/')
class ProductList(Resource):
    @ns_products.expect(product_model)
    def post(self):
        data = request.json
        min_product_id = get_min_available_id(Product, Product.product_id)
        new_product = Product(product_id=min_product_id, product_name=data['product_name'], price=data['price'], stock=data['stock'])
        db.session.add(new_product)
        db.session.commit()
        return jsonify({'message': 'Product created successfully'}), 201

@ns_products.route('/<int:product_id>')
class ProductResource(Resource):
    def get(self, product_id):
        product = Product.query.get_or_404(product_id)
        return jsonify({'product_id': product.product_id, 'product_name': product.product_name, 'price': product.price, 'stock': product.stock})

    @ns_products.expect(product_model)
    def put(self, product_id):
        data = request.json
        product = Product.query.get_or_404(product_id)
        product.product_name = data['product_name']
        product.price = data['price']
        product.stock = data['stock']
        db.session.commit()
        return jsonify({'message': 'Product updated successfully'})

    def delete(self, product_id):
        product = Product.query.get_or_404(product_id)
        db.session.delete(product)
        db.session.commit()
        return jsonify({'message': 'Product deleted successfully'})

# Маршруты для заказов
@ns_orders.route('/')
class OrderList(Resource):
    @ns_orders.expect(order_model)
    def post(self):
        data = request.json
        min_order_id = get_min_available_id(Order, Order.order_id)
        new_order = Order(order_id=min_order_id, user_id=data['user_id'])
        db.session.add(new_order)
        db.session.commit()
        return jsonify({'message': 'Order created successfully'}), 201

@ns_orders.route('/<int:order_id>')
class OrderResource(Resource):
    def get(self, order_id):
        order = Order.query.get_or_404(order_id)
        return jsonify({'order_id': order.order_id, 'user_id': order.user_id, 'order_date': order.order_date})

    @ns_orders.expect(order_model)
    def put(self, order_id):
        data = request.json
        order = Order.query.get_or_404(order_id)
        order.user_id = data['user_id']
        db.session.commit()
        return jsonify({'message': 'Order updated successfully'})

    def delete(self, order_id):
        order = Order.query.get_or_404(order_id)
        db.session.delete(order)
        db.session.commit()
        return jsonify({'message': 'Order deleted successfully'})

# Маршруты для деталей заказов
@ns_order_details.route('/')
class OrderDetailList(Resource):
    @ns_order_details.expect(order_detail_model)
    def post(self):
        data = request.json
        min_order_detail_id = get_min_available_id(OrderDetail, OrderDetail.order_detail_id)
        product = Product.query.get_or_404(data['product_id'])
        total_price = product.price * data['quantity']
        new_order_detail = OrderDetail(order_detail_id=min_order_detail_id, order_id=data['order_id'], product_id=data['product_id'], quantity=data['quantity'], price=total_price)
        db.session.add(new_order_detail)
        db.session.commit()
        return jsonify({'message': 'Order detail created successfully'}), 201

@ns_order_details.route('/<int:order_detail_id>')
class OrderDetailResource(Resource):
    def get(self, order_detail_id):
        order_detail = OrderDetail.query.get_or_404(order_detail_id)
        return jsonify({'order_detail_id': order_detail.order_detail_id, 'order_id': order_detail.order_id, 'product_id': order_detail.product_id, 'quantity': order_detail.quantity, 'price': order_detail.price})

    @ns_order_details.expect(order_detail_model)
    def put(self, order_detail_id):
        data = request.json
        order_detail = OrderDetail.query.get_or_404(order_detail_id)
        order_detail.order_id = data['order_id']
        order_detail.product_id = data['product_id']
        order_detail.quantity = data['quantity']
        product = Product.query.get_or_404(data['product_id'])
        order_detail.price = product.price * data['quantity']
        db.session.commit()
        return jsonify({'message': 'Order detail updated successfully'})

    def delete(self, order_detail_id):
        order_detail = OrderDetail.query.get_or_404(order_detail_id)
        db.session.delete(order_detail)
        db.session.commit()
        return jsonify({'message': 'Order detail deleted successfully'})

# Добавление пространств имен в API
api.add_namespace(ns_users)
api.add_namespace(ns_products)
api.add_namespace(ns_orders)
api.add_namespace(ns_order_details)

# Запуск приложения
if __name__ == '__main__':
    app.run(debug=True)
