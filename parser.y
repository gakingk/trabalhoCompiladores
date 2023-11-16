%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int linhas;
extern int erros;
%}

%token NUM SIGN DSIGN VAR INV 
%token INT FLOAT DOUBLE LONG
%token ATRIB SC COMP EOU COMM
%token ABREPAR FECHAPAR ABRECOL FECHACOL ABRECHAVE FECHACHAVE
%token MAIN FOR IF ELSE
%start Programa_principal

//boa parte do codigo da seção abaixo foi reaproveitado dos slides

%%
Programa_principal: 
    MAIN ABREPAR FECHAPAR ABRECHAVE Comandos FECHACHAVE | 
    error{yyerror("",linhas); return 1;};
Comandos : Comando Comandos | Comando;
Comando : 
    DECLARACAO | ATRIBUICAO | FUNCAOFOR | FUNCAOIF | 
    error{yyerror("",linhas); return 1;};
DECLARACAO : Tipo Decl COMM;
Tipo : INT | FLOAT | DOUBLE | LONG;
Decl : Lista_var;
Atribui_valor : ATRIB NUM | ;
Atribuicao : VAR ATRIB Exp COMM;
Exp : INT x | FLOAT x | NUM x | VAR x ;
x : SIGN Exp | ;
Lista_var : 
    VAR ATRIBUICAO COMM Lista_var | VAR ATRIBUICAO;
ATRIBUICAO: 
    VAR ATRIB Exp COMM;
FUNCAOFOR: 
    FOR ABREPAR VAR ATRIB NUM SC VAR COMP VAR SC VAR DSIGN FECHAPAR;
FUNCAOIF: 
    IF ABREPAR VAR COMP VAR FECHAPAR | 
    IF ABREPAR VAR COMP NUM FECHAPAR ;


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
	if(argc <= 1)
	{
		yyin = stdin;
	}
	else if(argc > 2)
	{
		printf("Argumentos demais");
		return 1;
	}
	else
		yyin = fopen(argv[1], "r");

	if(yyin == NULL)
	{
		printf("erro ao abrir o arquivo!!\n");
		return 1;
	}
	do{
		yyparse();
	}while(!feof(yyin));

	if(!errors)
		printf("Análise concluída com sucesso!\n");
}
