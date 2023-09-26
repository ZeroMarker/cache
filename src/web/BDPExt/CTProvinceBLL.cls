/// 省份导入
/// 2023-05-04
/// 基础数据平台 陈莹
Class web.BDPExt.CTProvinceBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 省份导入方法
/// chenying
ClassMethod SaveEntity(Ceobj As web.Entity.CT.CTProvince) As %String
{
	n (%session,Ceobj)
	s ImportResult=""	
	
	///默认值  
	s:Ceobj.PROVActivity="" Ceobj.PROVActivity="Y" //有效标志
	s SaveResult=##class(web.DHCBL.CT.CTProvince).SaveEntity(Ceobj)  
	q SaveResult
}

}
