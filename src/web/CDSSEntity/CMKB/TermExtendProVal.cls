/// Creator:谷雪萍
/// CreatDate:2021-09-08
/// Description：CDSS-医用知识库术语扩展属性明细表
/// Table：CT.WDT.CDSS.TermExtendProVal
Class web.CDSSEntity.CMKB.TermExtendProVal Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TermExtendProVal";

Property MKBTEPVRowId As %String;

Property MKBTEPVDetailDr As %String;

Property MKBTEPVExtendDr As %String;

Property MKBTEPVValue As %String;

}
