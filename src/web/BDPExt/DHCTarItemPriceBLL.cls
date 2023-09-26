/// Description：收费项价格导入程序
/// Creator：陈莹
/// CreatDate: 2018-1-2
Class web.BDPExt.DHCTarItemPriceBLL Extends %RegisteredObject
{

/// Description：收费项价格导入保存接口，如果医院为空就保存当前登陆医院
/// Creator：陈莹
/// CreatDate: 2018-1-2
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'TPRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.DHCTarItemPriceBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.DHCTarItemPriceEntity) As %String
{
	s ImportResult=""
	s taripriceeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItemPrice")
	s taripriceeobj.TPTARIParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Ceobj.TARICode,Ceobj.TPHospitalDR)
	s SaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(taripriceeobj)
	q SaveResult
}

}
