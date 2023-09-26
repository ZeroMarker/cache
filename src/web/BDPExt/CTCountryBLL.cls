/// 国籍地区导入
/// 2023-05-04
/// 基础数据平台 陈莹
Class web.BDPExt.CTCountryBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 国籍地区导入方法
/// chenying
ClassMethod SaveEntity(Ceobj As web.Entity.CT.CTCountry) As %String
{
	n (%session,Ceobj)
	s ImportResult=""	
	
	///默认值
	s:Ceobj.CTCOUActive="" Ceobj.CTCOUActive="Y" //有效标志
	s SaveResult=##class(web.DHCBL.CT.CTCountry).SaveEntity(Ceobj)  
	q SaveResult
}

}
