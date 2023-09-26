/// 城市导入
/// 2023-05-04
/// 基础数据平台 陈莹
Class web.BDPExt.CTCityBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 城市导入方法
/// chenying
ClassMethod SaveEntity(Ceobj As web.Entity.CT.CTCity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""	
	
	///默认值
	s:Ceobj.CTCITActivity="" Ceobj.CTCITActivity="Y" //有效标志
	s SaveResult=##class(web.DHCBL.CT.CTCity).SaveEntity(Ceobj)  
	q SaveResult
}

}
