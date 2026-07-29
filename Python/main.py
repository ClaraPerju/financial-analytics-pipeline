from transform import transform_production_excel,transform_customers_sales, transform_cash_flow,transform_cash_outflow,transform_expenses_revenue,tarnsform_profit_and_loss, transform_balance_sheet,transform_profit_loss_annual
import db 
from create_and_insert import create_products, create_production, create_shipments, create_customers,create_sales_targets, create_cash_flow,create_cash_outflows,create_expenses,create_revenue,create_profit_and_loss,create_balance_sheet,create_profit_loss_annual

# calling the functions to read the corespondg sheets from excel
production = transform_production_excel("Production_Made")
shipments = transform_production_excel("Delivered_Production")
customers_table, sales_targets_table = transform_customers_sales("Sales_Distribution_(Custome")
cash_flow = transform_cash_flow("Cash_Flow")
cash_outflow = transform_cash_outflow("Cash_Outflows")
expenses = transform_expenses_revenue("Total Expenses")
revenue = transform_expenses_revenue("Total Revenue")
profit_and_loss = tarnsform_profit_and_loss("P&L 2024-2025")
balance_sheet = transform_balance_sheet("F10_Balance_Sheet")
profit_anual_loss = transform_profit_loss_annual("F20_Profit_Loss_Annual")

# this variable hold the unique values from the column "product_name" so we can use them for the table products
# as the product from productio and shipments are the same just one call is suficent
unique_products = sorted(production["product_name"].unique())

#calling the function get_connection() so we can open the connection for MySQL
connection = db.get_connection()
cursor = connection.cursor(buffered=True)

# insert_products() inserts the unique products into the products table
# and returns a dictionary {product_name: product_id} 
# which will be used to map the product_id in production and shipments
product_map = create_products(cursor, connection, unique_products)

# creating the needed tables
try:
    create_production(cursor, connection, production,product_map )
except Exception as e:
    print(e)
    print("create_production failed!")
    raise e
try:
    create_shipments(cursor, connection, shipments,product_map )
except Exception as e:
    print(e)
    print("create_shipments failed!")
    raise e
try:
    create_customers(cursor, connection, customers_table)
except Exception as e:
    print(e)
    print("create_customers failed!")
    raise e
try:
    create_sales_targets(cursor, connection, sales_targets_table)
except Exception as e:
    print(e)
    print("create_sales_targets failed!")
    raise e
try:
    create_cash_flow(cursor, connection, cash_flow)
except Exception as e:
    print(e)
    print("create_cash_flow failed!")
    raise e
try:
    create_cash_outflows(cursor, connection, cash_outflow)
except Exception as e:
    print(e)
    print("create_cash_outflows failed!")
    raise e
try:
    create_expenses(cursor, connection, expenses)
except Exception as e:
    print(e)
    print("create_expenses failed!")
    raise e
try:
    create_revenue(cursor, connection, revenue)
except Exception as e:
    print(e)
    print("create_revenue failed!")
    raise e
try:
    create_profit_and_loss(cursor, connection, profit_and_loss)
except Exception as e:
    print(e)
    print("profit_and_loss failed!")
    raise e
try:
    create_balance_sheet(cursor, connection, balance_sheet)
except Exception as e:
    print(e)
    print("balance_sheet failed!")
    raise e

try:
    create_profit_loss_annual(cursor, connection, profit_anual_loss)
except Exception as e:
    print(e)
    print("profit_loss_annual failed!")
    raise e
#closing the cursor and connection
db.close_connection(cursor, connection)

print("DONE!")
