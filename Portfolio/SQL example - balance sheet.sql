USE H_Accounting;

DROP PROCEDURE IF EXISTS meow2;

DELIMITER $$
	
    CREATE PROCEDURE meow2(varCalendarYear YEAR)
	BEGIN
		DECLARE varCA DOUBLE;
		DECLARE varFA DOUBLE;
        DECLARE varDA DOUBLE;
        DECLARE varCL DOUBLE;
        DECLARE varLL DOUBLE;
        DECLARE varDL DOUBLE;        
	    DECLARE varE DOUBLE;

# Current assets 
		
        SELECT SUM(ifnull(jeli.debit,0))-sum(ifnull(jeli.credit,0))  INTO varCA
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id
			WHERE ss.statement_section_code = "CA"
				AND balance_sheet_section_id <> 0
                AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;
                
# Fixed Assets
        SELECT SUM(ifnull(jeli.debit,0))-sum(ifnull(jeli.credit,0))  INTO varFA
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id
			WHERE ss.statement_section_code = "FA"
				AND balance_sheet_section_id <> 0
                AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;
                
# Deferred Assets
        SELECT SUM(ifnull(jeli.debit,0))-sum(ifnull(jeli.credit,0)) INTO varDA
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id

			WHERE ss.statement_section_code = "DA"
				AND balance_sheet_section_id <> 0
                AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;

# Current liability
         SELECT SUM(ifnull(jeli.credit,0))-sum(ifnull(jeli.debit,0)) INTO varCL
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id
            WHERE ss.statement_section_code = "CL"
				AND balance_sheet_section_id <> 0
				AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;
                
# Long term liability
         SELECT SUM(ifnull(jeli.credit,0))-sum(ifnull(jeli.debit,0)) INTO varLL
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id
            WHERE ss.statement_section_code = "LLL"
				AND balance_sheet_section_id <> 0
                AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;
                
# Deferred liability
         SELECT SUM(ifnull(jeli.credit,0))-sum(ifnull(jeli.debit,0)) INTO varDL
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id
            WHERE ss.statement_section_code = "DL"
				AND balance_sheet_section_id <> 0
                AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;
                
# Shareholder's equity
		SELECT SUM(ifnull(jeli.credit,0))-sum(ifnull(jeli.debit,0)) INTO varE
		    FROM account AS ac
            INNER JOIN journal_entry_line_item AS jeli ON ac.account_id = jeli.account_id
            INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry 	 AS je ON je.journal_entry_id = jeli.journal_entry_id
            WHERE ss.statement_section_code = "EQ"
				AND balance_sheet_section_id <> 0
                AND debit_credit_balanced  <> 0
                AND cancelled              =  0
				AND YEAR(je.entry_date) = varCalendarYear;

# Create table
		DROP TABLE IF EXISTS tmp_hchi2019_table;

		CREATE TABLE tmp_hchi2019_table
		(  label VARCHAR(50), 
			amount VARCHAR(20));
  
# Insert the the header/space
		INSERT INTO tmp_hchi2019_table
		(label, amount)
		VALUES ('Balance Sheet', "(In thousand of USD)");
		INSERT INTO tmp_hchi2019_table
		(label, amount)
  		VALUES ( '', '');
        
# Insert values
		INSERT INTO tmp_hchi2019_table
		( label, amount)
		VALUES 
        ( 'Current Assets', format(varCA, 2)),
        ( 'Fixed Assets', format(ifnull(varFA,0), 2)),
        ( 'Deferred Assets', format(ifnull(varDA,0), 2)),
        ( 'Total Assets', format((ifnull(varCA,0)+ ifnull(varFA,0)+ ifnull(varDA,0)),2)),
        ( 'Current Liability', format(varCL, 2)),
        ( 'Long Term Liability', format(ifnull(varLL,0), 2)),
        ( 'Deferred Liability', format(ifnull(varDL,0), 2)),
        ( 'Total Liability', format((ifnull(varCL,0)+ ifnull(varLL,0) +ifnull(varDL,0)) ,2)),
        ( 'Equity', format(ifnull(varE,0), 2)),
        ( 'Total liability and Equity', format((ifnull(varCL,0)+ ifnull(varLL,0) +ifnull(varDL,0) + ifnull(varE,0)),2));

	END $$

DELIMITER ;

CALL meow2 (2015);
#CALL meow2 (2016);
#CALL meow2 (2017);
#CALL meow2 (2018);
#CALL meow2 (2019);

SELECT * FROM tmp_hchi2019_table;
