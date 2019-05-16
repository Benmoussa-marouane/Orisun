#include <iostream>
#include <string>
#include <pqxx/pqxx> 
#include <algorithm>
#include <time.h>
using namespace std;
using namespace pqxx;



int main(int argc, char* argv[]) {
   string sql;
   
   try {
      connection C("dbname=bighouse user=bigbrother password=who?me? host=poc.orisun-iot.com port=15432");
      if (C.is_open()) {
         cout << "Opened database successfully: " << C.dbname() << endl;
      } else {
         cout << "Can't open database" << endl;
         return 1;
      }

      /* Create SQL statement */
      sql = "select * from bs.numerics where topic = 450524 and ts > current_timestamp - interval '2 month' order by ts asc limit 10";

      /* Create a non-transactional object. */
      nontransaction N(C);
      
      /* Execute SQL query */
      result R( N.exec( sql ));
      
	/* date time formatting 2019-05-15 09:16:04.251084+02 */

	string s ;
	
struct tm tm;


      /* List down all the records */
      for (result::const_iterator c = R.begin(); c != R.end(); ++c) {
         /*cout << "TopicID = "    << c[0].as<int>()    << endl;
         cout << "Time stamp = " << std::stoi( c[1].as<string>() )<< endl;
         cout << "value= "       << c[2].as<float>()  << endl;
         cout << "faulty  = "    << c[3].as<string>() << endl;*/
	 s = c[1].as<string>() ;

 std::string myStr = s;
 string st = s;
    myStr.erase(std::remove(myStr.begin(), myStr.end(), ' '), myStr.end());
    myStr.erase(std::remove(myStr.begin(), myStr.end(), '-'), myStr.end());
    myStr.erase(std::remove(myStr.begin(), myStr.end(), ':'), myStr.end());
    long myLong = std::atol(myStr.c_str());   // convert to long

	tm.tm_year = myLong/ 10000000000;
	tm.tm_mon =  (myLong% 10000000000) / 100000000 ;
	tm.tm_mday = (myLong% 100000000) / 1000000;
	tm.tm_hour =(myLong% 1000000) / 10000;
 	tm.tm_min = (myLong% 10000) / 100 ;
	tm.tm_sec = myLong % 100;
	tm.tm_isdst = -1;

    	
	std::cout << "Your number is now " << myLong << std::endl;

	 cout << "Tyear = " << tm.tm_year<< endl;
         cout << "month= "       << tm.tm_mon<< endl;
         cout << "day  = "    << tm.tm_mday << endl;

	 cout << "hour = " << tm.tm_hour<< endl;
         cout << "minute= "       << tm.tm_min<< endl;
         cout << "seconds  = "    << tm.tm_sec << endl;
      }

	/*cout << "size  "<< R.size() <<endl;	*/
      cout << "Operation done successfully" << endl;

      C.disconnect ();
   } catch (const std::exception &e) {
      cerr << e.what() << std::endl;
      return 1;
   }

   return 0;
}
