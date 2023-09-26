Import SQLUser

Class web.DHCINSUFunCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

ClassMethod GetTarItemCate(CateType As %String, SubCateDr As %String) As %String
{
	s GetTarItemCate=$$QueryByCode^DHCINSUFacade(CateType,SubCateDr)
	q GetTarItemCate
}

}
