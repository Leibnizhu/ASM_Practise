#include <stdio.h> 
main() 
{ 
int year[21]={1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1997,1992,1993,1994,1995}; 
int income[21]={16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000}; 
int number[21]={ 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542,14430,15257,17800}; 
int i; 
printf("            Data of Power Idea Company\n"); 
printf("--------------------------------------------------\n"); 
printf("      year     Income       Number    Average\n"); 
for(i=0;i<21;i++) 
   printf("      %d\t%d\t%d\t%d\t\n",year[i],income[i],number[i],income[i]/number[i]); 
} 