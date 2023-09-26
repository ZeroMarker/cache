/// 监控中心核心函数库
/// 创建者：李阳
Class DHCMed.CCService.AutoProcess.CoreLib Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>功能：运行监控表达式</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>Expression</B>：监控表达式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// $List()
/// <OL>
/// <LI>状态：OK--运行成功，Error--错误</LI>
/// <LI>详细错误信息</LI>
/// <LI>运行的表达式</LI>
/// </OL>
ClassMethod RunExpression(Expression)
{
	SET $ZTRAP="ERR"
	q:Expression="" $lb("OK",1)
	s Expression=$tr(Expression,"[",$c(34))
	s Expression=$tr(Expression,"]",$c(34))
	s runExp="s RunExpressionResult="_Expression
	x runExp
	s data=$lb("")
	s $li(data,1)="OK"
	s $li(data,2)=RunExpressionResult
	;w "RunExpression:运行表达式："_Expression,!
	;w "结果："_RunExpressionResult,!
	;b:RunExpressionResult>0
	Set $li(data,3)=""
	q data
ERR
	s $li(data,1)="Error"
	s $li(data,2)=$ZError
	s $li(data,3)=runExp
	q data
}

/// <H3>功能：运行监控表达式</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>Expression</B>：监控表达式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 运行成功返回字符串 OK，运行错误就返回错误详情
ClassMethod RunConfigExpression(exp)
{
	Set $ZT="RunConfigExpressionErr"
	Set exp="s ret="_exp
	X exp
	Quit ret
	
RunConfigExpressionErr
	Set tmpRet="ERROR"_$c(1)_$ZError
	Quit tmpRet
}

}
