Class DWR.NUR.BL.DemoData Extends %RegisteredObject
{

// w ##Class(DWR.NUR.BL.DemoData).AddDemoData("46245","2010-12-01","2011-01-19")

ClassMethod AddDemoData(MRAdm As %String, myStartdate As %String, myEndDate As %String) As %String
{
	set $ZT="AddDemoDataET"
	
	do ..SetDemoData()
	
	set myStartdate=$ZDateH(myStartdate,3)
	set myEndDate=$ZDateH(myEndDate,3)
	
	set rtn="0"
	TStart
	for myDate=myStartdate:1:myEndDate
	{
		if (rtn'="0") quit
		for mytime=2:1:4
		{
			if (rtn'="0") quit
			set mytimeT=$get(^DHCDWRSET("NUR","ThreeSTTime",mytime))
			set mytimeH=$ZTimeH(mytimeT,2)
			for i=1:1:3
			{
				if (rtn'="0") quit
				set myItemCode=$get(^DHCDWRSET("NUR","ThreeSTItemCode",i))
				set myItemID=$order(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(myItemCode),""))
				if (myItemID="") continue
				set myindex=$Random(10)+1
				set myVal=+$get(^DHCWRDEMO("OBS",i,myindex))
				if (myVal=0) continue
				set rtn=..SaveMRObservations(MRAdm,myDate,mytimeH,myItemID,myVal)
				
			}
		}
		
	}
	if (rtn="0")
	{
		TCommit
	}
	else
	{
		TRollback
	}
	
	quit rtn
AddDemoDataET
	TRollback
	quit "-1^系统错误："_$ZError
}

ClassMethod SetDemoData()
{
	// 体温
	set ^DHCWRDEMO("OBS",1,1)="38.9"
	set ^DHCWRDEMO("OBS",1,2)="36.8"
	set ^DHCWRDEMO("OBS",1,3)="35.9"
	set ^DHCWRDEMO("OBS",1,4)="37.4"
	set ^DHCWRDEMO("OBS",1,5)="38.5"
	set ^DHCWRDEMO("OBS",1,6)="39.1"
	set ^DHCWRDEMO("OBS",1,7)="36.3"
	set ^DHCWRDEMO("OBS",1,8)="37.1"
	set ^DHCWRDEMO("OBS",1,9)="36.5"
	set ^DHCWRDEMO("OBS",1,10)="38"
	// 脉搏
	set ^DHCWRDEMO("OBS",2,1)="150"
	set ^DHCWRDEMO("OBS",2,2)="87"
	set ^DHCWRDEMO("OBS",2,3)="90"
	set ^DHCWRDEMO("OBS",2,4)="95"
	set ^DHCWRDEMO("OBS",2,5)="100"
	set ^DHCWRDEMO("OBS",2,6)="105"
	set ^DHCWRDEMO("OBS",2,7)="110"
	set ^DHCWRDEMO("OBS",2,8)="125"
	set ^DHCWRDEMO("OBS",2,9)="145"
	set ^DHCWRDEMO("OBS",2,10)="160"
	// 呼吸
	set ^DHCWRDEMO("OBS",3,1)="17"
	set ^DHCWRDEMO("OBS",3,2)="18"
	set ^DHCWRDEMO("OBS",3,3)="19"
	set ^DHCWRDEMO("OBS",3,4)="20"
	set ^DHCWRDEMO("OBS",3,5)="21"
	set ^DHCWRDEMO("OBS",3,6)="22"
	set ^DHCWRDEMO("OBS",3,7)="23"
	set ^DHCWRDEMO("OBS",3,8)="24"
	set ^DHCWRDEMO("OBS",3,9)="25"
	set ^DHCWRDEMO("OBS",3,10)="26"
}

ClassMethod SaveMRObservations(MRAdm As %String, myDate As %String, mytimeH As %String, myItemID As %String, myVal As %String) As %String
{
	set myrtn="-1"
	set myObj=##Class(User.MRObservations).%New(MRAdm)
	
	if (MRAdm'="") do myObj.OBSParRefSetObjectId(MRAdm)
	if (myItemID'="") do myObj.OBSItemDRSetObjectId(myItemID)
	set myObj.OBSValue=myVal
	set myObj.OBSDate=myDate
	set myObj.OBSTime=mytimeH
	set sc=myObj.%Save()
	if $$$ISERR(sc)
	{
		set myrtn=sc
	}
	else
	{
		set myrtn="0"
	}
	quit myrtn
}

}
