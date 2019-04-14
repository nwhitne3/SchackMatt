import java.sql.*;

public class MySQLDemo
{
    public static void main (String[] args)
    {

        /*
	 * Step 1: Allocate a database connection object
         * name of the object chosen is "Connection".
         * Driver Manager is a class included in the Java standard library.
         * and it has a getConnection method:
         * - Connection conn = Driver.Manager.getConnection();
         * It has to specify the driver being used and the address of the
	 * database server.
	 * Example:
         * Connection conn = Driver.Manager.getConnection(
         *        "jdbc:mysql://localhost:3306/chapter8", );
         * The driver and the address of the database server.
         * For purposes of this project, the address is just localhost. IP
	 * addresses should also work.
         * 3306 is the default MySQL Server port.
         * SSL certificates are not yet set up, but should be.
	 * We ran into errors when serverTimeZone was not specified.
         * Set it to UTC.
         * Also have to specify a username and a super-secret password.
         * Best practice is to never, ever use root. Typically a user with
	 * minimal privileges is used.
         * Tips:
         * (1) Confirm the server is actually running. Otherwise get a
	 * cannot make a connection to the server type error.
         * (2) If a user doesn't exist: Will get:
         * Error: Access denied for user 'username'@'localhost' using
	 * password: PASSWD)
         * (3) If try to access a database that doesn't exist on the
	 * server, will get:
	 * Error: Unknown database 'name'
	 * For example, trying to access 'chapter' instead of 'chapter8'
	 */
        try
        {
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/chapter8?ssl=false&serverTimezone=UTC", "root", "password" );
            // Just for debugging
            System.out.println("Connection made");

            // Step 2: Allocate a Statement object
            /*
             * Going to use a statement object to create a SQL statement
             */
            Statement stmnt = conn.createStatement();

            // Step 3: Create a SQL statement
            /*
             * Exactly the same as what would get typed into the SQL Server.
             * Need two ;'s one that ends the SQL statement, one that ends
	     * the Java statement.
             *
             */
            String strSelect = "select CUS_CODE, CUS_LNAME, CUS_FNAME from customer;";

            /*
             * Result Set will be in the form of a table:
             * [----------------------------------]
             * [ CUS_CODE | Cus_LNAME | CUS_FNAME ]
             * [----------------------------------]
             * [          |           |           ]
             * etc.
             */
            // System.out.println("debug: Before execute query");
            ResultSet rset = stmnt.executeQuery(strSelect);

            // Step 4: Process result set
            /*
             * Going sequentially, so just going to go row by row.
             * Important: You need to know the data type. Is it a string
	     * or an integer? etc.
             * For int, use getInt()...
             * Here, "CUS_CODE" is case sensitive even though is not on
	     * SQL Server.
	     * The following generates an error.
             int cusCode = rset.getInt("CUS_CODE");
             System.out.println(cusCode);
             * We thinks the problem is he getting a result set before we
	     * have moved the pointer to the first row.
	     *
             System.out.println("debug: Before execute query");
             int cusCode = rset.getInt("CUS_CODE");
             System.out.println(cusCode);

             * Adding reset.next() before and it works.
             * After more testing, is not case-sensitive.
             * Tried int cusCode = rset.getInt("cus_CODE");

             * Try this next batch of code. Get an error. because the last
	     * d should be an s.
             * This works:
	     *
            rset.next();
            System.out.println("debug: Before execute query");
            int cusCode = rset.getInt("CUS_CODE");
            String fName = rset.getString("CUS_FNAME");
            String lName = rset.getString("CUS_LNAME");
            // Customer code is 11 digits, and first and last name are 15 and 11
	    System.out.printf("%-11d      %-15s     %-15s\n", cusCode, fName, lName);

             * All of that should be in a while loop
             *
             * rset.next(); //no longer needed
             * runs until there are no more lines
	     */
            while (rset.next()) {
                System.out.println("debug: Before execute query");
                int cusCode = rset.getInt("CUS_CODE");
                String fName = rset.getString("CUS_FNAME");
                String lName = rset.getString("CUS_LNAME");
                System.out.printf("%-11d      %-15s     %-15s\n", cusCode, fName, lName);
            }
            /*
             * Can also do an insert.
             * So would change strSelect to something like this to insert values
             * Insert into Customer value ( ... )

             * The main difference is here we only have to execute the query,
	     * whereas with select we have to process the result of the query.
             */

        }
        catch (SQLException ex)
        {
            System.out.println("Error: " + ex.getMessage());
        }

    }
}
