Class DHCEPRFS.BL.BLTest Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(DHCEPRFS.BL.BLTest).TestTask()
ClassMethod TestTask() As %String
{
	s date = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2),3)
	
	s obj = ##class(DHCEPRFS.INST.Test).%New()
	s obj.Test = date_" "_time
	d obj.%Save()
}

}
