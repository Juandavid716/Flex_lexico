/* Declaración palabras claves*/
tokens	if|else|for|while|double|int|String|new|public|class|static|void|char

/* Expresiones regulares*/
letra	[A-Za-z]
dig	[0-9]
digs	{dig}+
gbajo ("_")
speso ("$")
var (({letra})|({letra}|{dig})*)
variable 	(({gbajo}|{speso})*{letra}({letra}|{dig}|{speso}|{gbajo})*)
nent	{sig}?{digs}
pent	{digs}?
pdec	("."({digs}?))?
pexp	("e"(({sig})?){digs})?
ndec	{pent}{pdec}{pexp}
nlong	{digs}("L"|"l")
cadena	    (("'")([^']*)("'"))|(("\"")([^"]*)("\""))
sig	("-")

/* identificadores */
id {variable}

/* Comentarios */
comment "//".*

/* Manejo de errores */
pdecerr	(","({digs}?))*
ndecerr {pent}{pdecerr}{pexp}
enum ({digs}({letra})+)
errorsimbolos [!"\#$%&'()*+\-./:;<=>?@\[\\\]^_‘{|}~]
variableerrada ([A-Za-z])+(["\#&'\:?@\\\\^‘|~])+([A-Za-z])+
err {enum}|{errorsimbolos}|{ndecerr}|{variableerrada}

%{   
/* importación de librerias , metodos y variables globales*/

  /* Librerías */
  #include <stdio.h>
  #include <string.h>
  #include <stdbool.h>
  #include <ctype.h>

  /* Métodos */
  void convert_to_upper();
  void print_tokens();
  void show_lines();
  void identifier();
  void show_ids();
  void identifierError();
  void show_errores();
  /* Variables globales */
  int num_ids=0; int x=0; int num_errores; int y = 0;
  int num_errores = 0;
  char ids[999][999];
  char errores[999][999];
  char buffer[999]; char bufferErrores[999];
  char c = 'I'; 
  char d = 'd';
%}

%%


"+"               {show_lines("Op-sum", yytext);}
"-"               {show_lines("Op-sust", yytext);}
"*"               {show_lines("Op-mult", yytext);}
"/"               {show_lines("Op-div", yytext);}
"%"               {show_lines("Op-mod", yytext);}
"&&"              {show_lines("Op-y", yytext);}
"="			          {show_lines("Op-asig", yytext);}
"||"              {show_lines("Op-o", yytext);}
">"				        {show_lines("Op-Mayor", yytext);}
"<"		            {show_lines("Op-Menor", yytext);}
"<="	            {show_lines("Op-Menor-igual", yytext);}
">="		          {show_lines("Op-Mayor-igual", yytext);}
"<>"              {show_lines("Op-Diferente", yytext);}
"!="	       	    {show_lines("Op-Diferente", yytext);}
"=="			        {show_lines("Op-Igual", yytext);}
"("			          {show_lines("Parent-a", yytext);}
")"			          {show_lines("Parent-c", yytext);}
";"			          {show_lines("Punto-coma", yytext);}
"["			          {show_lines("Corchete-a", yytext);}
"]"			          {show_lines("Corchete-c", yytext);}
"*="              {show_lines("Op-PorAsig", yytext);}
"/="			        {show_lines("Op-DivAsig", yytext);}
"-="              {show_lines("Op-SustAsig", yytext);}
"+="              {show_lines("Op-MasAsig", yytext);}
"++"              {show_lines("Op-MasMas", yytext);}
"--"              {show_lines("Op-SustSust", yytext);}
"{"               {show_lines("Llave-a", yytext);}
"}"               {show_lines("Llave-c", yytext);}
"!"               {show_lines("Op-no", yytext);}
","               {show_lines("coma", yytext);}

{tokens}	        {print_tokens(yytext);}
{id}	            {identifier(yytext);}
{nent}	          {show_lines("Cte-ent", yytext);}
{ndec}	          {show_lines("Cte-real", yytext);}
{nlong}	          {show_lines("Cte-long", yytext);}
{cadena}	        {show_lines("Cte-cadena", yytext);}
{comment}         {show_lines("COMENTARIO", yytext);}
{err}             {identifierError(yytext);}


%%

/* Método principal */
int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");
    FILE *out_file = fopen("salida.txt", "w");
    yyout = out_file;
    yylex();
    fclose(yyin);
    fprintf(yyout, "\n");
    show_ids();
    fprintf(yyout, "\n");
    show_errores();
    
    return 0;
}

/* Impresión de palabras claves */
void print_tokens(char keyword[]) {
  convert_to_upper(keyword);
  fprintf(yyout, "%s ", keyword);
}

/* Reconocimiento y conteo de identificadores*/
void identifier(char text[]) {
  bool new_id = true;
	for(int i = 0; i < num_ids; i++){
		if(strcmp(text, ids[i]) == 0) {
			new_id = false;
            x = i;
		}
	}
  if (new_id){
    strcpy(ids[num_ids], text);
    x = num_ids;
    num_ids++;
  }
  sprintf(buffer, "Id", x);
  show_lines(buffer,text);
}

void identifierError(char text[]) {
  bool new_error = true;
	for(int i = 0; i < num_errores; i++){
		if(strcmp(text, errores[i]) == 0) {
			new_error = false;
            y = i;
		}
	}
  if (new_error){
    strcpy(errores[num_errores], text);
    y = num_errores;
    num_errores++;
  }
  sprintf(bufferErrores, "ERROR=", x);
  show_lines(bufferErrores,text);
}

/* Imprimir identificadores y variables */
void show_lines(char type[], char value[]) {
 
 
      if(type[0] == c && type[1]==d || type=="STRING"){
          fprintf(yyout, " %s=%s , ", type, yytext);
      } else if (type=="Punto-coma" || type=="Llave-c" || type=="Llave-a"){
          fprintf(yyout, " %s=%s ", type, yytext);
      } else  {
          fprintf(yyout, " %s=%s , ", type, yytext);
      }
  
  
}

/* Conversión a mayuscula */
void convert_to_upper(char s[]) {
   int c = 0;
   while (s[c] != '\0') {
      if (s[c] >= 'a' && s[c] <= 'z') {
         s[c] = s[c] - 32;
      }
      c++;
   }
}

/* Tabla de identificadores */
void show_ids() {
   fprintf(yyout, "TABLA DE IDENTIFICADORES\n");
  if(num_ids == 0) {
    fprintf(yyout, "No se detectaron identificadores\n");
  }
  else {
    if(num_ids==1){
      fprintf(yyout, "Hay %d identificador:\n", num_ids);
    } else {
        fprintf(yyout, "Hay %d identificadores:\n", num_ids);
    }

    for(int i = 0; i < num_ids; i++) {
      fprintf(yyout, "Id=%s; ", ids[i]);
    }
     fprintf(yyout, "\n");
	}
}

void  show_errores(){
    if(num_errores == 0) {
    fprintf(yyout, "No se detectaron errores\n");
  }

  else {
     fprintf(yyout, "TABLA DE ERRORES\n");
    if(num_errores==1){
      fprintf(yyout, "Hay %d error:\n", num_errores);
    } else {
        fprintf(yyout, "Hay %d errores:\n", num_errores);
    }

    for(int i = 0; i < num_errores; i++) {
      fprintf(yyout, "ERROR=%s; ", errores[i]);
    }
     fprintf(yyout, "\n");
	}
}