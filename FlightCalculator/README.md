Salesforce LWC component/app that allows the users to create a Flight between two airports, calculate the flight
distance and save the flight in the database. 

Deploy instructions:
1. Clone repository from: https://github.com/jakubdutkiewiczAB/Flight-Calculator.git
2. Deploy repository to your org.
3. From Home Page (Service or Sales) on your org click Edit Page on gear icon (upper right corner).
4. From Pages picklist values choose 'Flight Calculator', click Activate and Save.
5. Go back to home page.
6. On org you can find Flights and Airports tabs to see records.
7. If you haven't got any airport for tests on your org you can run in Developer Console in Anonymous Window this script: TestUtils.addAirports(true);
