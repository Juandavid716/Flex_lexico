/* Declaración palabras claves*/
tokens	if|else|for|while|double|int|String|new|public|class|static|void|char

letra	[A-Za-z]
dig	[0-9]
digs	{dig}+
id	({letra}({letra}|{dig})*)
sig	("-")
nent	{sig}?{digs}
id_inv ({dig}|"_")({letra}|{dig}|"_")*
pent	{digs}?
pdec	("."({digs}?))?
pexp	("e"(({sig})?){digs})?
ndec	{pent}{pdec}{pexp}
nlong	{digs}("L"|"l")
str	    (("'")([^']*)("'"))|(("\"")([^"]*)("\""))
comment "//".*
err \=\?|{id_inv}

%{   
/* importación de librerias , metodos y variables globales*/
  #include <stdio.h>
  #include <string.h>
  #include <stdbool.h>
  void process();
  void upper_string();
  void process_keyword();
  void insert_id();
  void show_ids();
  int cont_id=0;
  int n=0;
  int cont_err = 0;
  char ids[9999][9999];
  char buffer[100];
%}

%%

{tokens}	{process_keyword(yytext);}
"+"               {process("Op-sum", yytext);}
"-"               {process("Op-sust", yytext);}
"*"               {process("Op-mult", yytext);}
"/"               {process("Op-div", yytext);}
"%"               {process("Op-mod", yytext);}
"&&"               {process("Op-y", yytext);}
"="			      {process("Op-asig", yytext);}
"||"               {process("Op-o", yytext);}
">"				  {process("Op-Mayor", yytext);}
"<"		          {process("Op-Menor", yytext);}
"<="	          {process("Op-Menor-igual", yytext);}
">="		      {process("Op-Mayor-igual", yytext);}
"<>"               {process("Op-Diferente", yytext);}
"!="	       	  {process("Op-Diferente", yytext);}
"=="			  {process("Op-Igual", yytext);}
"("			      {process("Parent-a", yytext);}
")"			      {process("Parent-c", yytext);}
";"			      {process("Punto-coma", yytext);}
"["			      {process("Corchete-a", yytext);}
"]"			      {process("Corchete-c", yytext);}
"*="              {process("Op-PorAsig", yytext);}
"/="			  {process("Op-DivAsig", yytext);}
"-="              {process("Op-SustAsig", yytext);}
"+="              {process("Op-MasAsig", yytext);}
"++"              {process("Op-MasMas", yytext);}
"--"              {process("Op-SustSust", yytext);}
"{"               {process("Llave-a", yytext);}
"}"               {process("Llave-c", yytext);}
"!"               {process("Op-no", yytext);}

{id}	{insert_id(yytext);}
{nent}	{process("Cte-ent", yytext);}
{ndec}	{process("Cte-real", yytext);}
{nlong}	{process("Cte-long", yytext);}
{str}	{process("Cte-cadena", yytext);}
{comment}         {process("COMENTARIO", yytext);}
{err}         {process("ERROR", yytext);cont_err++;}


%%

int main(int argc, char *argv[])
{
    yyin = fopen("texto.java", "r");
    FILE *out_file = fopen("salida.txt", "w");
    yyout = out_file;
    yylex();
    fclose(yyin);
    fprintf(yyout, "\n");
    show_ids();
    fprintf(yyout, "\n");
    fprintf(yyout, "Se encontraron %d errores\n", cont_err);
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
  sprintf(buffer, "Id", n);
  process(buffer,text);
}

void process(char rule_name[], char value[]) {

  if(rule_name!="COMENTARIO"){
    printf(rule_name[0]);
    fprintf(yyout, " %s= %s ", rule_name, yytext);
  }
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

void show_ids() {
  if(cont_id == 0) {
    fprintf(yyout, "No se detectaron identificadores\n");
  }
  else {
    fprintf(yyout, "Hay %d identificadores:\n", cont_id);
    for(int i = 0; i < cont_id; i++) {
      fprintf(yyout, "Id%d=%s; ", i, ids[i]);
    }
    fprintf(yyout, "\n");
	}
}