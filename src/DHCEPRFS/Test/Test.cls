Class DHCEPRFS.Test.Test Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// debug: d ##class(DHCEPRFS.Test.Test).AddData()
ClassMethod AddData()
{
	s ServerDiskID = "2"
	s DiskSize = "100000"
		
	s DiskUsed = "40000"
	s DiskFree = (+DiskSize)-(+DiskUsed)
	//10/19/2009  61653
	s Date = 61653
	s Time = 0
	s count = 0
	for index = 1:1:10000
	{
		//b
		d ..AddServerDiskStatus(Date,Time,ServerDiskID,DiskSize,DiskFree,DiskUsed)
		w !,index_" "_$zd(Date)_" "_$zt(Time)
		s DiskUsed = +DiskUsed+ 5
		s DiskFree = (+DiskSize)-(+DiskUsed)
		s count = count + 1
		if (count = 5 )
		{
			s Date = Date + 1	
			s Time = 0
			s count = 0
		}
		else
		{
			s Time = Time + 7200	
		}
	}
}

ClassMethod AddServerDiskStatus(ADate As %Date, ATime As %Time, AServerDiskID As %String, ADiskSize As %String, ADiskFreeSpace As %String, ADiskUsed As %String)
{
	s sequence = ""
	s sequence = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_AServerDiskID,sequence),-1)
	s:(sequence = "") sequence = 0
	
	s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%New()
	s obj.RecordDate = ADate
	s obj.RecordTime = ATime	
	s obj.ServerDiskID = AServerDiskID
	s obj.DiskSize = ADiskSize
	s obj.DiskFreeSpace = ADiskFreeSpace
	s obj.DiskUsed = ADiskUsed
	s obj.Sequence = (+sequence)+1
	s status = obj.%Save()
	q:($$$ISOK(status)) obj.%Id()
	q "-1"
}

}
