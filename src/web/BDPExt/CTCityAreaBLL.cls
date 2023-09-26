/// 城市区域导入
/// 2023-05-04
/// 基础数据平台 陈莹
Class web.BDPExt.CTCityAreaBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 城市区域导入方法
/// chenying
ClassMethod SaveEntity(Ceobj As web.Entity.CT.CTCityArea) As %String
{
	n (%session,Ceobj)
	s ImportResult=""	
	
	///默认值
	s:Ceobj.CITAREAActivity="" Ceobj.CITAREAActivity="Y" //有效标志
	s SaveResult=##class(web.DHCBL.CT.CTCityArea).SaveEntity(Ceobj)  
	q SaveResult
}

}
