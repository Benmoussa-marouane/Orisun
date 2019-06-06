#gcc -o bigfamily.o -I /usr/pgsql-10/include -L /usr/pgsql-10/lib 	-lpq 	-lpqxx   bigfamily.c 

LDLIBS=-L /usr/pgsql-10/lib -L /usr/local/lib -lpqxx -lpq -lstdc++
CXXFLAGS=-g -Wall -MMD -std=c++11 -I /usr/pgsql-10/include -I /usr/local/include 

bigfamily : bigfamily.o
bigfamily.o : bigfamily.cc

clean:
	$(RM) bigfamily.o bigfamily

