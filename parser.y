%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int linhas;
extern int erros;
int yylex();                                                                 
int yyerror();
%}

%token NUM SIGN DSIGN VAR INV 
%token INT FLOAT DOUBLE
%token ATRIB SC COMP EOU COMM
%token ABREPAR FECHAPAR ABRECOL FECHACOL ABRECHAVE FECHACHAVE
%token MAIN WHILE IF ELSE
%start Programa_principal

//boa parte do codigo da seção abaixo foi reaproveitado dos slides

%%
Programa_principal: 
    MAIN ABREPAR FECHAPAR ABRECHAVE Comandos FECHACHAVE | 
    error{yyerror("",linhas);};
Comandos: 
	Comando Comandos | Comando |;
Comando: 
    Declaracao | Atribuicao | FUNCAOWHILE | FUNCAOIF | 
    error{yyerror("",linhas);};

Declaracao: 
	Tipo Decl SC;

Tipo: 
	INT | FLOAT | DOUBLE;

Decl: 
	LISTA_VAR ;

LISTA_VAR: 
	VAR Atribui_valor COMM LISTA_VAR | VAR Atribui_valor;

Atribui_valor: 
	ATRIB SINAL NUM | ;

Atribuicao: 
	VAR ATRIB SINAL Exp SC ;

Exp: 
	NUM x | VAR x;

//a partir dessa linha nao foi pego dos slides
x: 
	SINAL Exp | ;

SINAL: 
	SIGN|;

FUNCAOWHILE: 
    WHILE ABREPAR IFARG FECHAPAR ABRECHAVE Comandos FECHACHAVE; 

FUNCAOIF: 
    IF ABREPAR IFARG FECHAPAR ABRECHAVE Comandos FECHACHAVE;

IFARG:
	VAR COMP VAR | VAR COMP VAR IFARG2 | VAR COMP NUM | VAR COMP NUM IFARG2| VAR;

IFARG2:
	EOU IFARG;
%%

extern FILE *yyin;

int yyerror(char *str, int num_linha) {
    if(strcmp(str,"syntax error")==0){
        erros++;
        printf("Erro sintático\n");//Exibe mensagem de erro
    }
    else
    {
        printf("O erro aparece próximo à linha %d\n", num_linha);//Exibe a linha do erro
    }
return erros;
}

int main (int argc, char **argv )
{
	yyin = fopen(argv[1], "r");

	if(yyin == NULL){
		printf("\nFalha ao abrir o arquivo\n");
		return 1;
	}
	do{
		yyparse();
	}while(!feof(yyin));

	if(!erros)
		printf("\nAnálise concluída com sucesso\n");
}
