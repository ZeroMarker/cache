/// 解析间接操作符表达式
Class web.DHCWMRQuality.BOSystemData Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod GetSystemDateValue(strExpress As %String) As %String
{
	s outstr=""
	s outstr="Result="_strExpress 
	s @outstr
	q @"Result"
}

ClassMethod GetEPRData(Parameter As %String, EpisodeID As %String)
{
	n (Parameter,EpisodeID)
	Set Ret=##class(EPRservice.Quality.BOQuaExpExplain).GetEPRData(Parameter,EpisodeID)
	;w !,"EpisodeID="_EpisodeID_"    "_Parameter_"="_Ret,!
	;Set Ret=$h
	Quit Ret
}

/*
ClassMethod GetMetDataByTemplateID(TemplateID) As %String
{
	;Set Ret=##class(Test.test).GetMetDataByTemplateID(TemplateID)
	Set Ret=""
	Quit Ret
}

ClassMethod GetTemplateList() As %String
{
	;Set Ret=##class(Test.test).GetTemplateList()
	Set Ret=""
	Quit Ret
}

ClassMethod TmpCate() As %String
{
	;Set Ret=##class(Test.test).TestTemplateCategory()
	Set Ret=""
	Set Ret="^^^"_$c(1)
	Quit Ret
}
*/
ClassMethod GetMData(TemplateID) As %String
{
	;Set Ret=##class(Test.test).GetMetDataByTemplateID(TemplateID)
	;Set Ret=""
	Set Ret=##class(EPRservice.Quality.BOQuaExpExplain).GetMetDataByTemplateID(TemplateID)
	Quit Ret
}

ClassMethod GetTempList() As %String
{
	;Set Ret=##class(Test.test).GetTemplateList()
	;Set Ret=""
	Set Ret=##class(EPRservice.Quality.BOQuaExpExplain).GetTemplateList()
	Quit Ret
}

ClassMethod GetTmpCate() As %String
{
	;Set Ret=##class(Test.test).TestTemplateCategory()
	Set Ret=##class(EPRservice.Quality.BOQuaExpExplain).GetTemplateCategory()
	Quit Ret
}

}
