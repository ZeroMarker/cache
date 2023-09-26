Class DHCWL.MDRService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 对于多院区的项目，获取码表对应的院区信息
ClassMethod GetHospital(tableName As %String, BDPMPHDataReference As %String, Type As %String = "") As %String [ SqlProc ]
{
	n (tableName,BDPMPHDataReference,Type)
	s HospId=##class(web.DHCBL.BDP.BDPDataExport).GetHospital(tableName,BDPMPHDataReference,Type)
	q HospId
}

}
