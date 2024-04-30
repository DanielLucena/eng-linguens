<program>	->	<stmts>
<stmts>		->	<stmt>	|	
																									 <stmt>	;	<stmts>
<stmt>		->	<var>	=	<expr>
<var>					->	a	|	b	|	c	|	d
<expr>		->	<term>	+	<term>	|	
																								<term>	- <term>
<term>	->	<var>	|	const