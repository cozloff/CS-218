// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  NOTE: To compile this program, and produce an object file
//	must use the "g++" compiler with the "-c" option.
//	Thus, the command "g++ -c main.c" will produce
//	an object file named "main.o" for linking.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>

using namespace std;

#define MAXLENGTH 1000
#define MINLENGTH 3

#define SUCCESS 0
#define NOSUCCESS 1
#define OUTOFRANGEMIN 2
#define OUTOFRANGEMAX 3
#define INPUTOVERFLOW 4
#define ENDOFINPUT 5


// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the C/C++ style calling convention.

extern "C" int readSeptNum(int *);
extern "C" void shellSort(int[], int);
extern "C" void basicStats(int[], int, int *, int *, int *, int *, int *);
extern "C" void linearRegression(int[], int[], int, int, int, int *, int *);


// ***************************************************************
//  Begin a basic C++ program.
//	Notes, does not use any objects.

int main()
{

// --------------------------------------------------------------------
//  Declare variables and simple display header
//	By default, C++ integers are doublewords (32-bits).

	string	bars;
	bars.append(50,'-');

	int	i, status, newNumber;
	int	xList[MAXLENGTH], yList[MAXLENGTH];
	int	len = 0;
	int	xMin, xMax, xMed, xSum, xAve;
	int	yMin, yMax, yMed, ySum, yAve;
	int	b0, b1;
	bool	endOfNumbers = false;
	bool	readX = true;

	cout << bars << endl;
	cout << "CS 218 - Assignment #9" << endl << endl;

// --------------------------------------------------------------------
//  Loops to read numbers from user.

	// while (!endOfNumbers && len<MAXLENGTH) {

	// 	if (readX)
	// 		printf ("Enter X Value (+/-septenary): " );
	// 	else
	// 		printf ("Enter Y Value (+/-septenary): " );

	// 	fflush(stdout);
	// 	status = readSeptNum(&newNumber);
	// 	cout<<status<<endl;
	// 	cout<<newNumber<<endl;

	// 	switch (status) {
	// 		case SUCCESS:
	// 			if (readX)
	// 				xList[len] = newNumber;
	// 			else
	// 				yList[len++] = newNumber;
	// 			readX = !readX;
	// 			break;
	// 		case NOSUCCESS:
	// 			cout << "Error, invalid number. ";
	// 			cout << "Please re-enter." << endl;
	// 			break;
	// 		case OUTOFRANGEMIN:
	// 			cout << "Error, number below minimum value. ";
	// 			cout << "Please re-enter." << endl;
	// 			break;
	// 		case OUTOFRANGEMAX:
	// 			cout << "Error, number above maximum value. ";
	// 			cout << "Please re-enter." << endl;
	// 			break;
	// 		case INPUTOVERFLOW:
	// 			cout << "Error, user input exceeded " <<
	// 				"length, input ignored. ";
	// 			cout << "Please re-enter." << endl;
	// 			break;
	// 		case ENDOFINPUT:
	// 			if (readX)
	// 				endOfNumbers = true;
	// 			else
	// 				cout << "Must enter a matching" <<
	// 					" Y value (septenary)." << endl;
	// 			break;
	// 		default:
	// 			cout << "Error, invalid return status. ";
	// 			cout << "Program terminated" << endl;
	// 			exit(EXIT_FAILURE);
	// 			break;
	// 	}
	// 	if (len > MAXLENGTH)
	// 		break;
	// }

// --------------------------------------------------------------------
//  Ensure some numbers were read and, if so, display results.

	xList [0] = 343;
	xList [1] = -24;
	xList [2] = 725;
	xList [3] = -1795;
	xList [4] = 49;
	xList [5] = 51;
	xList [6] = 53;
	xList [7] = 55;
	xList [8] = 57;
	xList [9] = 59;
	xList [10] = 61;
	xList [11] = 63;
	xList [12] = 65;
	xList [13] = 67;
	xList [14] = 69;
	xList [15] = 71;
	xList [16] = 73;
	xList [17] = 75;
	xList [18] = 77;
	xList [19] = 79;
	xList [20] = 81;
	xList [21] = 83;
	xList [22] = 85;

	yList [0] = 8;
	yList [1] = 30;
	yList [2] = -1034;
	yList [3] = 41;
	yList [4] = -2794;
	yList [5] = -395;
	yList [6] = -740;
	yList [7] = -1771;
	yList [8] = -2116;
	yList [9] = -2118;
	yList [10] = -15840;
	yList [11] = -1779;
	yList [12] = -1438;
	yList [13] = -1097;
	yList [14] = -1099;
	yList [15] = -1787;
	yList [16] = -1446;
	yList [17] = -1448;
	yList [18] = -2136;
	yList [19] = -1795;
	yList [20] = -768;
	yList [21] = -427;
	yList [22] = -86;

	len = 23;

	if (len < MINLENGTH) {
		cout << "Error, not enough numbers entered." << endl;
		cout << "Program terminated." << endl;
	} else {
		cout << bars << endl;
		cout << endl << "Program Results" << endl << endl;

		 shellSort(xList, len);
		 shellSort(yList, len);

		basicStats(xList, len, &xMin, &xMed, &xMax, &xSum, &xAve);
		cout<<"FUCK"<<endl;
		basicStats(yList, len, &yMin, &yMed, &yMax, &ySum, &yAve);

		linearRegression(xList, yList, len, xAve, yAve, &b0, &b1);


		cout << "Sorted X List: " << endl;
		for ( i = 0; i < len; i++) {
			cout << xList[i] << "  ";
			if ( (i%10)==9 || i==(len-1) ) cout << endl;
		}
		cout << endl;
		cout << "   X Minimum =  " << setw(12) << xMin << endl;
		cout << "    X Median =  " << setw(12) << xMed << endl;
		cout << "   X Maximum =  " << setw(12) << xMax << endl;
		cout << "       X Sum =  " << setw(12) << xSum << endl;
		cout << "   X Average =  " << setw(12) << xAve << endl;

		cout << endl << "Sorted Y List: " << endl;
		for ( i = 0; i < len; i++) {
			cout << yList[i] << "  ";
			if ( (i%10)==9 || i==(len-1) ) cout << endl;
		}
		cout << endl;
		cout << "   Y Minimum =  " << setw(12) << yMin << endl;
		cout << "    Y Median =  " << setw(12) << yMed << endl;
		cout << "   Y Maximum =  " << setw(12) << yMax << endl;
		cout << "       Y Sum =  " << setw(12) << ySum << endl;
		cout << "   Y Average =  " << setw(12) << yAve << endl;

		cout << endl;
		cout << "Linear Regression Values " << endl <<
			" b0 =  " << b0 << endl <<
			" b1 =  " << b1 << endl;
		cout << endl;
	}

// --------------------------------------------------------------------
//  All done...

	return 0;

}

