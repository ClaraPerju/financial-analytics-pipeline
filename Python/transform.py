import pandas as pd


# the function takes one parameter "sheet_name" and return a DataFrame
# this will clean the sheets from the "Production_and_Delivered" excel
# i will needt to transform the table form a wide format in a long one and fix the NaN values
def transform_production_excel(sheet_name: str) -> pd.DataFrame:
    # reading the excel file and the sheet name
    production:pd.DataFrame = pd.read_excel("Production_and_Delivered.xlsx",
                        sheet_name=sheet_name)

    # is accesing the column "Tip" and is filling the NaN values with the above value
    production["Tip"] = production["Tip"].ffill()
    # renaming the column "Tip" to "Product"
    production = production.rename(columns={"Tip": "product_name"})

    # excluding some columns as they can be calculated when necessary
    to_exclude = ["TOTAL", "Total Groups", "Total Bearings", "Export Amount Within Total Sales"]
    production = production[~production["product_name"].isin(to_exclude)]

    # melt function converts the data from a wide format into a long one
    # this is used so you can transform the data into a more computer-frenldy format

    production_melt = production.melt(
        # the below columns will stay the same
        id_vars=["product_name", "Unit of Measure"], 
        # every column with the month will become a row
        var_name="month",
        # this will hold the remaining values  
        value_name="Value"
    )
    # pivot function converst the date from a long format in a wide one
    # every unique value in "Unit of Measure" column will become a separate column  
    # (RON, kg, pcs, tons)
    production_pivot:pd.DataFrame = production_melt.pivot_table(
        # the below columns will stay the same
        index=["product_name", "month"],
        # every row with the month will become a column
        columns="Unit of Measure",
        # the actual numeric values (RON amounts, kg, pcs, tons)
        values="Value"
    ).reset_index()

    # to get rid of the residual name left after the pivot
    production_pivot.columns.name = None

    # renaming the columns
    production_pivot = production_pivot.rename(columns={
        "RON"         : "value_ron",
        "kg"          : "quantity_kg",
        "pcs (pieces)": "quantity_pcs",
        "tons"        : "quantity_tons"
    })
    # transforming the NaN values to None Values so they can be later recognize by SQL
    production_pivot:pd.DataFrame = production_pivot.astype(object).where(pd.notnull(production_pivot), None)
    
    return production_pivot

def transform_customers_sales(sheet_name: str) -> tuple[pd.DataFrame,pd.DataFrame]:
    
    customers:pd.DataFrame = pd.read_excel("Buget_cash_flow.xlsx",
                sheet_name=sheet_name)
    customers:pd.DataFrame = customers.astype(object).where(pd.notnull(customers), None)

    customers = customers.drop(columns = customers.columns[0])

    customers = customers.rename(columns={
        "Customer_id"       : "customer_id",
        "CUSTOMER"        : "customer_name",
        "Country"          : "customer_country",
        "BUDGET 2026"      : "budget_usd",
        "URB PRODUCTION %" : "pct_manufactured_inhouse",
        "COMPONENTS OUTSOURCED + URB ASSEMBLY %" : "pct_assembled_inhouse",
        "CSB FINISHED OUTSOURCED %" : "pct_fully_outsourced",
        "TOTAL PRODUCTION SALES USD" : "total_production_sales_usd",
        "TOTAL OUTSOURCED SALES USD" : "total_outsourced_sales_usd"
    })

    #creating the table customers
    customers_table:pd.DataFrame = customers[["customer_id",
                                            "customer_name",
                                            "customer_country"]]

    # creating the table sales_target
    sales_targets_table:pd.DataFrame = customers[["customer_id", 
                                                "budget_usd", 
                                                "pct_manufactured_inhouse", 
                                                "pct_assembled_inhouse",
                                                "pct_fully_outsourced",
                                                "total_production_sales_usd",
                                                "total_outsourced_sales_usd"]]
    
     
     
    return customers_table, sales_targets_table

def transform_cash_flow(sheet_name:str) -> pd.DataFrame:
    cash_flow:pd.DataFrame = pd.read_excel("Buget_cash_flow.xlsx",
                    sheet_name=sheet_name)

   
        
    cash_flow = cash_flow.set_index("Cash Flow")  
    # you need to rename before the transpose, also the rename() function is not working beacuse the first colum is an index column not a normal one
    cash_flow.index.name = "Index" 
    # switch between rows and columns
    cash_flow  = cash_flow.transpose() 

    # the function is creating a series of dates
    months: pd.Index = pd.date_range( 
                                    start="2025-01", # starting with 2025-01
                                    periods=18, # for of period of 18 date
                                    freq="MS" # the frequevcy is Month Start -> python sees the dates as the first day of the month
                                            ).strftime("%b %Y") # throught this the dates are transformed in foarmated text %b = month %Y = year
    cash_flow.index = months # we assign months as the index of the DataFrame
    
    cash_flow = cash_flow.reset_index()
    cash_flow = cash_flow.rename(columns={"index": "Month"})
    
    cash_flow = cash_flow.rename(columns={
                "Month"                         : "month",
                "Beginning Cash Balance"        : "opening_cash_balance",
                "CASH INPUTS (+)"               : "cash_inputs",
                "Receivables Collection"        : "collections_receivables",
                "Cash Sales"                    : "collections_cash_sales",
                "Forward Sales Collection"      : "collections_forward_sales",
                "Capital Collections"           : "collections_capital",
                "Bank Loans"                    : "inflows_bank_loans",
                "Other Inflows & Liabilities"   : "inflows_other",
                "Group & Holding Trusts"        : "inflows_group_trusts",
                "Total Cash Available"          : "total_cash_available"
            })
     # transforming the NaN values to None Values so they can be later recognize by SQL
    cash_flow:pd.DataFrame = cash_flow.astype(object).where(pd.notnull(cash_flow), None)
    return cash_flow

def transform_cash_outflow(sheet_name:str) -> pd.DataFrame:
    cash_outflow:pd.DataFrame  = pd.read_excel("Buget_cash_flow.xlsx",
                  sheet_name= sheet_name)

    

    cash_outflow = cash_outflow.set_index("CASH OUTFLOWS (-)")  
    # you need to rename before the transpose, also the rename() function is not working beacuse the first colum is an index column not a normal one
    cash_outflow.index.name = "Index" 
    # switch between rows and columns
    cash_outflow  = cash_outflow.transpose() 

    months: pd.Index = pd.date_range( 
                                        start="2025-01", # starting with 2025-01
                                        periods=18, # for of period of 18 date
                                        freq="MS" # the frequevcy is Month Start -> python sees the dates as the first day of the month
                                                ).strftime("%b %Y") # throught this the dates are transformed in foarmated text %b = month %Y = year
    cash_outflow.index = months # we assign months as the index of the DataFrame

    cash_outflow = cash_outflow.reset_index()
    cash_outflow = cash_outflow.rename(columns={"index": "Month"})

    cash_outflow = cash_outflow.rename(columns={
        "Month"                     : "month",
        "Advance RM Purchases"      : "outflows_rm_advance",
        "Forward RM Purchases"      : "outflows_rm_forward",
        "Direct Labor"              : "outflows_direct_labor",
        "Mfg. Expenses (ex. Depr.)" : "outflows_manufacturing_expenses",
        "Operating Expenses"        : "outflows_operating_expenses",
        "Debt Repayments"           : "outflows_debt_repayments",
        "Investment Payments"       : "outflows_investments",
        "Financing Costs"           : "outflows_financing_costs",
        "Other Outflows"            : "outflows_other",
        "Total Cash Outflows"       : "total_cash_outflows"
    })
    cash_outflow:pd.DataFrame = cash_outflow.astype(object).where(pd.notnull(cash_outflow), None)
    return cash_outflow

def transform_expenses_revenue(sheet_name:str) -> pd.DataFrame:
    df:pd.DataFrame  = pd.read_excel("Indicators.xlsx",
                 sheet_name = sheet_name)
    df:pd.DataFrame = df.astype(object).where(pd.notnull(df), None)
    # deleting the last column
    df = df.dropna(axis=1, how="all")

    # we need to have the column month - currentlly we have the months as columns
    new_columns = ["account_code", "account_name_en"]
    months = ["ian", "feb", "mar", "apr", "may", "jun", "jul","aug","sep", "oct", "nov", "dec"]
    for month in months:
        new_columns.append(f"{month}_ron")
        new_columns.append(f"{month}_usd")
    # we modify the old columns to the new columns
    df.columns = new_columns
    
    # Remove rows that are not real accounts
    df = df[df["account_code"].notna()].reset_index(drop=True)
    #now we have to use melt to transorm the df from wide into long 
    df_long = df.melt(
        id_vars=["account_code", "account_name_en"],
        var_name="month_currency",
        value_name="amount"

    )
    # we are separating the month and the currency
    df_long[["month", "currency"]] = df_long["month_currency"].str.rsplit(
        "_",
        n=1,
        expand=True
    )
    df_long = df_long.drop(columns=["month_currency"])
    df_long["currency"] = df_long["currency"].str.upper()
    
    print(df_long)
    return df_long

def tarnsform_profit_and_loss(sheet_name:str) -> pd.DataFrame:
    df:pd.DataFrame  = pd.read_excel("Indicators.xlsx",
                 sheet_name = "P&L 2024-2025")

    # Remove empty columns
    df = df.dropna(axis=1, how="all")

    # Keep only the English account name
    df = df.drop(columns=df.columns[0])

    # Rename the remaining first column
    df = df.rename(columns={df.columns[0]: "account_name_en"})

    # Wide -> Long
    df_long = df.melt(
        id_vars=["account_name_en"],
        var_name="period_scenario",
        value_name="amount"
    )
    # Split into period and scenario
    df_long[["period", "scenario"]] = (
        df_long["period_scenario"]
        .str.rsplit(" ", n=1, expand=True)
    )
    # Remove temporary column
    df_long.drop(columns="period_scenario", inplace=True)

    # Remove empty rows
    df_long = df_long.dropna(subset=["amount"]).reset_index(drop=True)
    return df_long

def transform_balance_sheet(sheet_name: str) -> pd.DataFrame:
    df = pd.read_excel("Bilant_Rulmenti_2025.xlsx", sheet_name=sheet_name)
    
    df = df.rename(columns={
        df.columns[0]: "item_description",
        df.columns[1]: "balance_01_01_2025",
        df.columns[2]: "balance_31_12_2025"
    })
    
    df = df.astype(object).where(pd.notnull(df), None)
    
    return df


def transform_profit_loss_annual(sheet_name: str) -> pd.DataFrame:
    df = pd.read_excel("Bilant_Rulmenti_2025.xlsx", sheet_name=sheet_name)
    
    df = df.rename(columns={
        df.columns[0]: "item_description",
        df.columns[1]: "financial_year_2024",
        df.columns[2]: "financial_year_2025"
    })
    
    df = df.astype(object).where(pd.notnull(df), None)
    
    return df
