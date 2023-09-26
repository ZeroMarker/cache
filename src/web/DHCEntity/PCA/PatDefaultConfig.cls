/// 患者注册中，默认配置界面
Class web.DHCEntity.PCA.PatDefaultConfig Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property IEType As %String(TRUNCATE = 1);

Property CityDesc As %String(TRUNCATE = 1);

Property CityDescLookUpRowID As %String(TRUNCATE = 1);

Property CountryDesc As %String(TRUNCATE = 1);

Property CountryDescLookUpRowID As %String(TRUNCATE = 1);

Property NationDesc As %String(TRUNCATE = 1);

Property NationDescLookUpRowID As %String(TRUNCATE = 1);

Property ProvinceInfo As %String(TRUNCATE = 1);

Property ProvinceInfoLookUpRowID As %String(TRUNCATE = 1);

Property Zip As %String(TRUNCATE = 1);

Property ZipLookUpRowID As %String(TRUNCATE = 1);

Property CardRegMustFillIn As %String(TRUNCATE = 1);

Property CardRegJumpSeq As %String(TRUNCATE = 1);

}
