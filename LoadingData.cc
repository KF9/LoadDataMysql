// Author :  Khaula Fathima
//Purpose : Load the data from the given data file to the mysql database
//Notes   : Used Queue as the container for loading data


#include<iostream>
#include<fstream>
#include<sstream>
#include <queue>
#include <stdlib.h>
#include <mysql.h>
using namespace std;
void UseMeToInsertIntoDB(string InsertStatement);
int main()
{ 
	//variables;
	string readingLine, readingValue, printingValues, PoppedValue, NextStart, currentTable, InsertMe, MyEmployeeId, fullline;
	int lastword, counter, twoline, columnCounter = 0, rowCounter = 0, SecondCollection, subrowCount = 0;
	bool newline, flag;
	char next;
	//queue 
	queue<string> ColumnCollection;
	//ifstream object for reading from .csv file
	ifstream CSVFile("DATA.csv"); 
	//reading the lines from the given data file
	while(getline(CSVFile, fullline) && rowCounter < 23)
	{
	columnCounter = 8;
	rowCounter++;
	//data for farm table
	if(rowCounter < 10)
	{	
		istringstream myline(fullline);
		for(int x = 0; x < columnCounter; x++)
		{ //get line using the tokenizer ,
			getline(myline, readingValue, ',');
			if(rowCounter != 1)
			{
				ColumnCollection.push(readingValue);
			}
		}
		//creating the insert statements to put data in table FARM
		InsertMe = "insert into FARM (FarmID, FarmSpeciality, FarmName, FarmStreetAddr, FarmCity, FarmState, FarmZip, FarmPhone, Emp_ID) values ("; 
		for(int y = 0; y < columnCounter; y++)
		{
			if(rowCounter != 1)
			{
				if(y != 0)
				{
					InsertMe += ", ";
				}
				PoppedValue = ColumnCollection.front();
				InsertMe += "'" + PoppedValue + "'";
				ColumnCollection.pop();
				ColumnCollection.push(readingValue);
			}
		}
		//popping 
		while(!ColumnCollection.empty())
		{
			ColumnCollection.pop();	
		}
		//calling insert function
		if(rowCounter != 1)
		{
			InsertMe += ", NULL)";
			UseMeToInsertIntoDB(InsertMe);
		}
	}
	//data for employee and works_on table
	else
	{	//creating the insert statements to put data in table EMPLOYEE
		istringstream myline(fullline);
		columnCounter = 10;
		for(int x = 0; x < columnCounter; x++)
		{
			getline(myline, readingValue, ',');
			//push values to queue
			if(rowCounter != 10)
			{
				ColumnCollection.push(readingValue);
			}
		}
		InsertMe = "insert into EMPLOYEE(Emp_ID, EmpFName, EmpLName, EmpStreetAddress, EmpCity, EmpState, EmpZip, EmpPhone, EmpBirthdate, Type, NumberDependents) values (";
		for(int y = 0; y < columnCounter; y++)
		{
			if(rowCounter != 10)
			{ // pop the front element from the queue
				PoppedValue = ColumnCollection.front();
				if(y != 0)
				{
					InsertMe += ", ";
					if(y == 8)
					{
						PoppedValue = PoppedValue.substr(6,4) + "/" + PoppedValue.substr(0,2) + "/" + PoppedValue.substr(3,2); 
						cout << PoppedValue << endl;
					}
				}
				else
				{
					MyEmployeeId = PoppedValue;
				}
				InsertMe += "'" + PoppedValue + "'";
				ColumnCollection.pop();
				ColumnCollection.push(readingValue);
			}
		}
		//pop the queue
		while(!ColumnCollection.empty())
		{
			ColumnCollection.pop();	
		}
		if(rowCounter != 10)
		{
			InsertMe += ", NULL)";
			UseMeToInsertIntoDB(InsertMe);
			cout << InsertMe << endl << endl;
		}
		getline(myline, readingValue, ',');
		subrowCount = atoi(readingValue.c_str());
		cout << subrowCount << endl;
		
		for(int k = 0; k < subrowCount; k++)
		{
			for(int x = 0; x < 3; x++)
			{
				getline(myline, readingValue, ',');
				if(rowCounter != 10)
				{
					ColumnCollection.push(readingValue);
				}
			}
			//creating the insert statements to put data in table WORKS_ON
			InsertMe = "insert into WORKS_ON(Emp_ID, FarmID, EmpStartDate, EmpEndDate) values ('" + MyEmployeeId + "',";
			for(int y = 0; y < 3; y++)
			{
				PoppedValue = ColumnCollection.front();
				if(rowCounter != 10)
				{
					if(y != 0)
					{
						InsertMe += ", ";
						 if(PoppedValue.length() == 10)
						 {
						 	cout << "inside date formatting" << endl;
						 	PoppedValue = PoppedValue.substr(6,4) + "/" + PoppedValue.substr(0,2) + "/" + PoppedValue.substr(3,2); 
							cout << PoppedValue << endl;
						 }
					}
					InsertMe += "'" + PoppedValue + "'";
					ColumnCollection.pop();
					ColumnCollection.push(readingValue);
				}
			}
			while(!ColumnCollection.empty())
			{
				ColumnCollection.pop();	
			}
			if(rowCounter != 10)
			{
				InsertMe += ")";
				UseMeToInsertIntoDB(InsertMe);
				cout << InsertMe << endl << endl;
			}
		}		
	}
}
	return 0;
}
void UseMeToInsertIntoDB(string InsertStatement)
{
	MYSQL *conn, mysql;
	char server[] = "students";
	char user[] = “username”;
	char password[] = “password”;
	char database[] = “database”;
					// Connect to the database 
	mysql_init (&mysql);
	conn = mysql_real_connect(&mysql, server, user, password, database, 0, 0, 0);
					// Check for Error 
	if(!conn)
	{
		cout << "connection failed!\n";
	}
	else
	{		//execute the query
		mysql_query(conn, InsertStatement.c_str());
		mysql_close(conn);
	}
}