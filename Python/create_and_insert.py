import pandas as pd

# this function is creating, inserting the data into the products tables
def create_products(cursor, connection, unique_products: list[str]) -> dict:
    
    # deleting the table if it exsists and replacing with the below
    cursor.execute("DROP TABLE IF EXISTS products;")
    
    create_table_products = """
        CREATE TABLE `products` (
            `product_id` INT AUTO_INCREMENT PRIMARY KEY,
            `product_name` TEXT
        );
    """
    cursor.execute(create_table_products)

    insert_query_products = """
        INSERT INTO products (product_name)
        VALUES (%s);
    """
    # appending the data from the product_name trough a for loop 
    secured_data_products: list[tuple] = []
    for product_name in unique_products:
        secured_data_products.append((product_name,))
        
    cursor.executemany(insert_query_products, secured_data_products)
    connection.commit()
    
    # sending the sql query to MySQL - read all rows from table product
    cursor.execute("SELECT product_id, product_name FROM products")
    # creating an empty dictionary that will hold the results
    product_map:dict = {}
    # for loop to iterate through all rows returned by the sql query
    # fetchall() - cases from the active dataset - in this case from the above query
    for product_id, product_name in cursor.fetchall():
        # constructing the dictionary so later we can use it to create the product_id clolumn for the production/shipments table
        product_map[product_name] = product_id
        # product_map["Radial Bearings"] = 1

    return product_map

def create_production(cursor, connection, df: pd.DataFrame, product_map: dict) -> None:

    # map(product_map) replaces each product_name with the corresponding product_id from the dictionary
    df["product_id"] = df["product_name"].map(product_map)
    # removes the column "product_id" and stores it temporarily in col
    col = df.pop("product_id")
    # inserts the column "product_id" at the first position (index 0)
    df.insert(0, "product_id", col)
    # removing the "product_name" column as we don't need it anymore
    df = df.drop(columns=["product_name"])

    cursor.execute("DROP TABLE IF EXISTS production;")

    create_table_production = """
        CREATE TABLE `production` (
            `production_id` int AUTO_INCREMENT PRIMARY KEY,
            `product_id` int,
            `month` TEXT,
            `value_ron` float,
            `quantity_kg` float,
            `quantity_pcs` float,
            `quantity_tons` float
        );
    """
    cursor.execute(create_table_production)

    insert_query_production = """
        INSERT INTO production (product_id, month, value_ron, quantity_kg, quantity_pcs, quantity_tons)
        VALUES (%s, %s, %s, %s, %s, %s);
    """

    secured_data_production: list[tuple] = []
    for row in df.to_numpy():
        secured_data_production.append(tuple(row))

    cursor.executemany(insert_query_production, secured_data_production)
    connection.commit()
    
def create_shipments(cursor, connection, df: pd.DataFrame, product_map: dict) -> None:

    df["product_id"] = df["product_name"].map(product_map)
    col = df.pop("product_id")
    df.insert(0, "product_id", col)
    df = df.drop(columns=["product_name"])

    cursor.execute("DROP TABLE IF EXISTS shipments;")

    create_table_shipments = """
        CREATE TABLE `shipments` (
            `shipment_id` int AUTO_INCREMENT PRIMARY KEY,
            `product_id` int,
            `month` TEXT,
            `value_ron` float,
            `quantity_kg` float,
            `quantity_pcs` float,
            `quantity_tons` float
        );
    """
    cursor.execute(create_table_shipments)

    insert_query_shipments = """
        INSERT INTO shipments (product_id, month, value_ron, quantity_kg, quantity_pcs, quantity_tons)
        VALUES (%s, %s, %s, %s, %s, %s);
    """

    secured_data_shipments: list[tuple] = []
    for row in df.to_numpy():
        secured_data_shipments.append(tuple(row))

    cursor.executemany(insert_query_shipments, secured_data_shipments)
    connection.commit()
    
def create_customers(cursor, connection, customers_table:pd.DataFrame) -> None:
    
    cursor.execute("DROP TABLE IF EXISTS customers;")
    
    create_table_customers = """
        CREATE TABLE `customers` (
            `customer_id` int PRIMARY KEY,
            `customer_name` text,
            `customer_country` text);
    """
    cursor.execute(create_table_customers)
    
    insert_query_customers = """
        INSERT INTO customers (customer_id, customer_name, customer_country) 
        VALUES (%s, %s, %s)
    """
    secured_data_customers: list[tuple] = []
    for row in customers_table.to_numpy():
        secured_data_customers.append(tuple(row))
    
    cursor.executemany(insert_query_customers,secured_data_customers)
    connection.commit()
    
def create_sales_targets(cursor, connection, sales_targets_table:pd.DataFrame) -> None:
    
    cursor.execute("DROP TABLE IF EXISTS sales_targets;")
    
    create_table_sales_targets = """
        CREATE TABLE `sales_targets` (
            `customer_id` int PRIMARY KEY,
            `budget_usd` float,
            `pct_manufactured_inhouse` float,
            `pct_assembled_inhouse` float,
            `pct_fully_outsourced` float,
            `total_production_sales_usd` float,
            `total_outsourced_sales_usd` float);
    """
    cursor.execute(create_table_sales_targets)
    
    insert_query_sales_targets = """
        INSERT INTO sales_targets (customer_id,
                                    budget_usd,
                                    pct_manufactured_inhouse,
                                    pct_assembled_inhouse,
                                    pct_fully_outsourced,
                                    total_production_sales_usd,
                                    total_outsourced_sales_usd)
        VALUES(%s, %s, %s,%s, %s, %s,%s)
    """
    
    secured_data_sales_targets: list[tuple] = []
    for row in sales_targets_table.to_numpy():
        secured_data_sales_targets.append(tuple(row))
    
    cursor.executemany(insert_query_sales_targets,secured_data_sales_targets)
    connection.commit()
        
def create_cash_flow(cursor, connection, cash_flow:pd.DataFrame) -> None:
    
    cursor.execute("DROP TABLE IF EXISTS cash_flow;")
    
    create_table_cash_flow = """
        CREATE TABLE `cash_flow` (
            `month` varchar(50) PRIMARY KEY,
            `opening_cash_balance` float,
            `cash_inputs` float,
            `collections_receivables` float,
            `collections_cash_sales` float,
            `collections_forward_sales` float,
            `collections_capital` float,
            `inflows_bank_loans` float,
            `inflows_other` float,
            `inflows_group_trusts` float,
            `total_cash_available` float
            );
    """
    cursor.execute(create_table_cash_flow)
    
    insert_query_cash_flow = """
    INSERT INTO cash_flow (month,
                            opening_cash_balance,
                            cash_inputs,
                            collections_receivables,
                            collections_cash_sales,
                            collections_forward_sales,
                            collections_capital,
                            inflows_bank_loans,
                            inflows_other,
                            inflows_group_trusts,
                            total_cash_available)
    VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

    secured_data_cash_flow: list[tuple] = []
    for row in cash_flow.to_numpy():
        secured_data_cash_flow.append(tuple(row))
    cursor.executemany(insert_query_cash_flow, secured_data_cash_flow)
    connection.commit()

def create_cash_outflows(cursor, connection, cash_outflow: pd.DataFrame) -> None:

    cursor.execute("DROP TABLE IF EXISTS cash_outflows;")

    create_table_cash_outflows = """
        CREATE TABLE `cash_outflows` (
            `month` varchar(50) PRIMARY KEY,
            `outflows_rm_advance` float,
            `outflows_rm_forward` float,
            `outflows_direct_labor` float,
            `outflows_manufacturing_expenses` float,
            `outflows_operating_expenses` float,
            `outflows_debt_repayments` float,
            `outflows_investments` float,
            `outflows_financing_costs` float,
            `outflows_other` float,
            `total_cash_outflows` float
            );
    """
    cursor.execute(create_table_cash_outflows)

    insert_query_cash_outflows = """
        INSERT INTO cash_outflows (month,
                                    outflows_rm_advance,
                                    outflows_rm_forward,
                                    outflows_direct_labor,
                                    outflows_manufacturing_expenses,
                                    outflows_operating_expenses,
                                    outflows_debt_repayments,
                                    outflows_investments,
                                    outflows_financing_costs,
                                    outflows_other,
                                    total_cash_outflows)
        VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    secured_data_cash_outflows: list[tuple] = []
    for row in cash_outflow.to_numpy():
        secured_data_cash_outflows.append(tuple(row))
    cursor.executemany(insert_query_cash_outflows, secured_data_cash_outflows)
    connection.commit()
    
def create_expenses(cursor, connection,df_long:pd.DataFrame) -> None:
    cursor.execute("DROP TABLE IF EXISTS expenses;")
    
    create_table_expenses = """
        CREATE TABLE `expenses` (
            `account_code` varchar(255),
            `account_name_en` text,
            `amount` float,
            `month` text,
            `currency` text
        );
    """
    cursor.execute(create_table_expenses)
    
    insert_query_expenses = """ 
        INSERT INTO expenses (account_code,account_name_en,amount,month,currency)
        VALUES(%s, %s, %s, %s, %s)
    """
    
    secured_data_expenses:list[tuple] = []
    for row in df_long.to_numpy():
        secured_data_expenses.append(tuple(row))
    print(secured_data_expenses[58])
    cursor.executemany(insert_query_expenses, secured_data_expenses)
    connection.commit()
    
def create_revenue(cursor, connection,df_long:pd.DataFrame) -> None:
    cursor.execute("DROP TABLE IF EXISTS revenue;")
    
    create_table_revenue = """
        CREATE TABLE `revenue` (
            `account_code` varchar(255),
            `account_name_en` text,
            `amount` float,
            `month` text,
            `currency` text
        );
    """
    cursor.execute(create_table_revenue)
    
    insert_query_revenue = """ 
        INSERT INTO revenue (account_code,account_name_en,amount,month,currency)
        VALUES(%s, %s, %s, %s, %s)
    """
    
    secured_data_revenue:list[tuple] = []
    for row in df_long.to_numpy():
        secured_data_revenue.append(tuple(row))

    cursor.executemany(insert_query_revenue, secured_data_revenue)
    connection.commit()
    
def create_profit_and_loss(cursor, connection,df_long:pd.DataFrame) -> None:
    cursor.execute("DROP TABLE IF EXISTS profit_and_loss;")

    create_table_pl = """
        CREATE TABLE `profit_and_loss` (
            `account_name_en` text,
            `amount` float,
            `period` text,
            `scenario` text
        );
    """
    cursor.execute(create_table_pl)

    insert_query_pl = """ 
        INSERT INTO profit_and_loss (account_name_en, amount, period, scenario)
        VALUES(%s, %s, %s, %s)
    """

    secured_data_pl: list[tuple] = []
    for row in df_long.to_numpy():
        secured_data_pl.append(tuple(row))

    cursor.executemany(insert_query_pl, secured_data_pl)
    connection.commit()
    
def create_balance_sheet(cursor, connection, df: pd.DataFrame) -> None:

    cursor.execute("DROP TABLE IF EXISTS balance_sheet;")

    create_table_bs = """
        CREATE TABLE `balance_sheet` (
            `item_description` TEXT,
            `balance_01_01_2025` FLOAT,
            `balance_31_12_2025` FLOAT
        );
    """
    cursor.execute(create_table_bs)

    insert_query_bs = """
        INSERT INTO balance_sheet (item_description, balance_01_01_2025, balance_31_12_2025)
        VALUES(%s, %s, %s)
    """

    secured_data_bs: list[tuple] = []
    for row in df.to_numpy():
        secured_data_bs.append(tuple(row))

    cursor.executemany(insert_query_bs, secured_data_bs)
    connection.commit()


def create_profit_loss_annual(cursor, connection, df: pd.DataFrame) -> None:

    cursor.execute("DROP TABLE IF EXISTS profit_loss_annual;")

    create_table_pla = """
        CREATE TABLE `profit_loss_annual` (
            `item_description` TEXT,
            `financial_year_2024` FLOAT,
            `financial_year_2025` FLOAT
        );
    """
    cursor.execute(create_table_pla)

    insert_query_pla = """
        INSERT INTO profit_loss_annual (item_description, financial_year_2024, financial_year_2025)
        VALUES(%s, %s, %s)
    """

    secured_data_pla: list[tuple] = []
    for row in df.to_numpy():
        secured_data_pla.append(tuple(row))

    cursor.executemany(insert_query_pla, secured_data_pla)
    connection.commit()
