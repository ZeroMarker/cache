/// HIS字典同步
Class DHCMed.DPCustom.Meta.HIS.DIC Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDicMapping(DicName As %String, Code As %String) As %String
{
		n (DicName,Code)
		Set ret=""
		Set:DicName="DEP" ret=$$CtlocMapping(Code)
		Quit ret
	
	
	
	//对照科室CT_LOC表
CtlocMapping(Code)
	n (Code)
	Quit Code
}

}
