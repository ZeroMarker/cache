/// 名称：		EMRservice.BOCaseGrammarFormula
/// 描述：		语法公式B0层
/// 编写者：	yejian
/// 编写时间：	2016-1-20
Class EMRservice.BOCaseGrammarFormula Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CaseGrammarFormulaInfo";

ClassMethod SelectCaseGrammarFormula() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLCaseGrammarFormula:SelectCaseGrammarFormula")
	d result.SetArgs()
	q result
}

/// 根据编码获取语法
ClassMethod GetCaseGrammarFormulaByCode(aECaseGrammarFCode As %String) As EMRservice.entity.ECaseGrammarFormula [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCaseGrammarFormula).GetCaseGrammarFormulaByCode(aECaseGrammarFCode)
}

/// 增加一个语法
ClassMethod CreateCaseGrammarFormula(aECaseGrammarFormulaInfo As EMRservice.entity.ECaseGrammarFormula) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCaseGrammarFormula).CreateCaseGrammarFormula(aECaseGrammarFormulaInfo)
}

/// 删除一个语法
ClassMethod DeleteCaseGrammarFormulaByID(aCaseGrammarFormulaId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCaseGrammarFormula).DeleteCaseGrammarFormulaByID(aCaseGrammarFormulaId)
}

/// 更新一个语法
ClassMethod UpdateCaseGrammarFormula(aECaseGrammarFormulaInfo As EMRservice.entity.ECaseGrammarFormula) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCaseGrammarFormula).UpdateCaseGrammarFormula(aECaseGrammarFormulaInfo)
}

/// 更新语法顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCaseGrammarFormula).UpdateSequences(argStr)
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCaseGrammarFormula).CheckCodeExist(Acode)
}

}
