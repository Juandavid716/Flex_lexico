tokens	if|else|for|while|double|int|String|new|public|class|static|void

let	[A-Za-z]
dig	[0-9]
digs	{dig}+
id	({let}|"_")({let}|{dig}|"_")*

%{   
 #include<stdio.h>
 #include <string.h>
 #include <stdbool.h>
 void upper_string();
 void process_keyword();
 void insert_id();
 void process();
 int cont_id=0; int n=0;
 char ids[9999][9999];
 char buffer[100];
%}

%%
{tokens}	{process_keyword(yytext);}
{id}	{insert_id(yytext);}

"+" {printf("signo suma");}
%%
int main()
{
    yyin = fopen( "texto.txt", "r" );
    yylex();
    return 0;
}

void process_keyword(char keyword[]) {
  upper_string(keyword);
  fprintf(yyout, "%s ", keyword);
}

void insert_id(char text[]) {
  bool new_id = true;
	for(int i = 0; i < cont_id; i++){
		if(strcmp(text, ids[i]) == 0) {
			new_id = false;
            n = i;
		}
	}
  if (new_id){
    strcpy(ids[cont_id], text);
    n = cont_id;
    cont_id++;
  }
  sprintf(buffer, "ID%d", n);
  process(buffer,text);
}

void process(char rule_name[], char value[]) {
  
    fprintf(yyout, "%s=%s ", rule_name, yytext);
  
  
}

void upper_string(char s[]) {
   int c = 0;
   while (s[c] != '\0') {
      if (s[c] >= 'a' && s[c] <= 'z') {
         s[c] = s[c] - 32;
      }
      c++;
   }
}