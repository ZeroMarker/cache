/// CTOR: QP
/// DATE: 2020-08-24
/// DESC: 化疗医嘱套相关
Class DHCDoc.Chemo.BS.Ext.Arcos Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-24
/// DESC: 获取化疗组医嘱套ID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Arcos).GetArcosID("PRNGM")
ClassMethod GetArcosID(code)
{
	s newCode=code_"-ARCOS"
	s mRtn=##class(DHCDoc.Chemo.BS.Data).GetData("BD",newCode)
	
	Q mRtn
}

}
