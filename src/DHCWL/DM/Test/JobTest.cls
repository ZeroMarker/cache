Class DHCWL.DM.Test.JobTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.JobTest).Test("JOB")

ClassMethod Test(type = "")
{
	s t1=$p($zts,",",2)
	s size=1000
	k ^lhh
	s list=$lb(1,2,3,4,5,6)
	if (type="JOB"){
		job ..WorkloadTask(size,list)
		job ..WorkloadTask(size,list)
		job ..WorkloadTask(size,list)
		;job RoutineTask
		;job RoutineTask
		;job RoutineTask
	}else{
		d ..WorkloadTask(1000)
		d ..WorkloadTask(1000)
		d ..WorkloadTask(1000)
	}
	
	while ($g(^lhh,0)'=3){
		h 1
	}
	w "finish! using time:"_($p($zts,",",2)-t1),!
	q
RoutineTask
	f i=1:1:size{
		s rowId=$$RandomRowId^WorkloadTestData()
	}
	s cnt=$i(^lhh)
	q
}

ClassMethod WorkloadTask(size, list As %List)
{
	f i=1:1:size{
		s rowId=$$RandomRowId^WorkloadTestData()
	}
	s cnt=$i(^lhh)
	s ^lhh(cnt)=$lts(list,",",1)
}

}
