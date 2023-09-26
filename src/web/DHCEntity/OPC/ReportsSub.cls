/// 报表子分类
Class web.DHCEntity.OPC.ReportsSub Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 发卡时的项目收入分类
Parameter CardSubCat = "Other";

/// 当前的金额
Property Acount As %String(TRUNCATE = 1);

Property CatDR As %String(TRUNCATE = 1);

Property SubAvailHospitlCode As %String(TRUNCATE = 1);

Property SubAvailHospitlDR As %String(TRUNCATE = 1);

Property SubAvailHospitlDesc As %String(TRUNCATE = 1);

Property SubCatDR As %String(TRUNCATE = 1);

/// 子类描述
Property SubCatDesc As %String(TRUNCATE = 1);

Property TarSubjectType As %String(TRUNCATE = 1);

/// 得到 卡类型对应的 项目子类
ClassMethod GetCardINVSubCat() As %String
{
	;w ##class(web.DHCEntity.OPC.ReportsSub).GetCardINVSubCat()
	s mySubCat="6"
	q mySubCat
}

}
