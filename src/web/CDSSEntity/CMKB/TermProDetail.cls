/// Creator:谷雪萍
/// CreatDate:2021-09-08
/// Description：CDSS-医用知识库术语属性明细表
/// Table：CT.WDT.CDSS.TermProDetail
Class web.CDSSEntity.CMKB.TermProDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TermProDetail";

Property MKBTPDRowId As %String;

Property MKBTPDCode As %String;

Property MKBTPDDesc As %String;

Property MKBTPDProDR As %String;

Property MKBTPDLastLevel As %String;

Property MKBTPDLevel As %String;

Property MKBTPDRemark As %String;

Property MKBTPDActiveFlag As %String;

Property MKBTPDExtend As %String;

Property MKBTPDSequence As %String;

Property MKBTPDPYCode As %String;

}
