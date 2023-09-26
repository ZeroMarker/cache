/// 方法运行
/// 创建者：李阳
/// 创建日期：2010-09-13
Class DHCMed.CCService.System.MethodRunner Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod RunExpression(Expression)
{
	SET $ZTRAP="ERR"
	q:Expression="" $lb("OK",1)
	s Expression=$tr(Expression,"[",$c(34))
	s Expression=$tr(Expression,"]",$c(34))
	s runExp="s RunExpressionResult="_Expression
	;w "RunExpression:运行表达式："_Expression,!
	x runExp
	s data=$lb("")
	s $li(data,1)="OK"
	s $li(data,2)=RunExpressionResult
	q data
ERR
	s $li(data,1)="Error"
	s $li(data,2)=$ZError
	s $li(data,3)=runExp
	q data
}

}
