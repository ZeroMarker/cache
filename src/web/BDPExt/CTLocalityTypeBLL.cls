/// 街道导入
/// 2023-05-04
/// 基础数据平台 陈莹
Class web.BDPExt.CTLocalityTypeBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 街道导入方法
/// chenying
ClassMethod SaveEntity(Ceobj As web.Entity.CT.CTLocalityType) As %String
{
	n (%session,Ceobj)
	s ImportResult=""	
	
	///默认值  
	s:Ceobj.LOCTYPEActiveFlag="" Ceobj.LOCTYPEActiveFlag="Y" //有效标志
	s SaveResult=##class(web.DHCBL.CT.CTLocalityType).SaveEntity(Ceobj)  
	q SaveResult
}

}
