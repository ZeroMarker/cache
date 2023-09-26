Class DtPortal.OD.OD10DocSchedule Extends %RegisteredObject [ ProcedureBlock ]
{

// 门诊医生出诊统计

// OD10.01.01

// 入参:

// StartDate		开始日期  (2019-01-01)

// EndDate			结束日期  (2019-01-01)

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD10DocSchedule","OD100101","2018-01-01","2019-01-01")

Query OD100101(StartDate As %String, EndDate As %String, ifOPEPConf As %String = "", hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,loc,locdesc,valueN,valueS,valueR,valueA") [ SqlProc ]
{
}

ClassMethod OD100101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, ifOPEPConf As %String = "", hospitalId As %String = "") As %Status
{

	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalOD100101
	
	quit:((StartDate="")||(EndDate="")) $$$OK
	set StartDate=$zdh(StartDate,3)
	set EndDate=$zdh(EndDate,3)
	
	for Date=StartDate:1:EndDate
	{
		set ResRowId=0
		for
		{
			set ResRowId=$o(^RBAS(ResRowId)) 
			quit:ResRowId=""
			
			set loc=$P($G(^RB("RES",ResRowId)),"^",1)
			set RbScRowId=""
			for
			{
				set RbScRowId=$o(^RBAS(ResRowId,0,"DateSTime",Date,RbScRowId)) 
				quit:RbScRowId=""
				
				set RbScRowIdsub=""
				for
				{
					set RbScRowIdsub=$o(^RBAS(ResRowId,0,"DateSTime",Date,RbScRowId,RbScRowIdsub)) 
					quit:RbScRowIdsub=""
					
					set ASStatusDr=$p(^RBAS(ResRowId,RbScRowIdsub,"DHC"),"^",10) 		//排班状态
					set statsCode=$p(^DHCRBCASStatus(ASStatusDr),"^",1)
					set statsDesc=$p(^DHCRBCASStatus(ASStatusDr),"^",2)
					
					set ^||TMPPortalOD100101(loc,statsCode)=$g(^||TMPPortalOD100101(loc,statsCode))+1
				}
			}
			
		}
	}
	
	
	set loc=0
	for
	{
		set loc=$o(^||TMPPortalOD100101(loc))
		quit:loc=""
		
		set hospID=$p($g(^CTLOC(loc)),"^",22)
		i hospitalId'=""  continue:hospID'=hospitalId
		
		if ((ifOPEPConf'="")){
			if (ifOPEPConf'["E"){
				set ifEm=##class(DtPortal.Common.PublicService).ifEmDept(loc)
				continue:ifEm=1
			}
			
		}
		set locDesc=$p(^CTLOC(loc),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		set valueN=+$g(^||TMPPortalOD100101(loc,"N"))		//正常
		set valueS=+$g(^||TMPPortalOD100101(loc,"S"))		//停诊
		set valueR=+$g(^||TMPPortalOD100101(loc,"R"))		//替诊
		set valueA=+$g(^||TMPPortalOD100101(loc,"A"))		//加诊
		
		set ^||CacheTemp(repid,ind)=$lb(ind,loc,locDesc,valueN,valueS,valueR,valueA)
 		set ind=ind+1
	}
	
	k ^||TMPPortalOD100101
	Quit $$$OK
}

// 门诊医生出诊统计弹出层

// OD10.01.02

// 入参:

// StartDate		开始日期  (2019-01-01)

// EndDate			结束日期  (2019-01-01)

// Loc				科室

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD10DocSchedule","OD100102","2020-04-01","2020-04-01","51")

Query OD100102(StartDate As %String, EndDate As %String, Loc As %String) As DtPortal.Query(ROWSPEC = "ind,Cpid,CpDecs,valueN,valueS,valueR,valueA") [ SqlProc ]
{
}

ClassMethod OD100102Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String) As %Status
{

	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalOD100102($j)
	
	quit:((StartDate="")||(EndDate="")||(Loc="")) $$$OK
	set StartDate=$zdh(StartDate,3)
	set EndDate=$zdh(EndDate,3)
	//
	//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  //获取排版资源表id
	for Date=StartDate:1:EndDate
	{
		s RowId=""
		for
		{
			s RowId=$o(^RB("RES",0,"CTLOC",Loc,RowId))
			quit:RowId=""  
			s Cpid=$p(^RB("RES",RowId),"^",2)
			
			
			;w "CpDecs="_CpDecs,!
			;b ;CpDecs
			set RbScRowId=""
			for{
				set RbScRowId=$o(^RBAS(RowId,0,"DateSTime",Date,RbScRowId)) 
				quit:RbScRowId=""
				set RbScRowIdsub=""
				for
				{
					set RbScRowIdsub=$o(^RBAS(RowId,0,"DateSTime",Date,RbScRowId,RbScRowIdsub)) 
					quit:RbScRowIdsub=""
					
					set ASStatusDr=$p(^RBAS(RowId,RbScRowIdsub,"DHC"),"^",10) 		//排班状态
					set statsCode=$p(^DHCRBCASStatus(ASStatusDr),"^",1)
					;set statsDesc=$p(^DHCRBCASStatus(ASStatusDr),"^",2)
					
					set ^||TMPPortalOD100102($j,Cpid,statsCode)=$g(^||TMPPortalOD100102($j,Cpid,statsCode))+1
				}
			}
		}
	 
	}
	
    set Cpid=""
	for
	{
		set Cpid=$o(^||TMPPortalOD100102($j,Cpid))
		quit:Cpid=""
		s CpDecs=$p(^CTPCP(Cpid,"1"),"^",2)
		;set locDesc=$p(^CTLOC(loc),"^",2)
		;set:locDesc["-" locDesc=$p(locDesc,"-",2)
		set valueN=+$g(^||TMPPortalOD100102($j,Cpid,"N"))		//正常
		set valueS=+$g(^||TMPPortalOD100102($j,Cpid,"S"))		//停诊
		set valueR=+$g(^||TMPPortalOD100102($j,Cpid,"R"))		//替诊
		set valueA=+$g(^||TMPPortalOD100102($j,Cpid,"A"))		//加诊
		set ^||CacheTemp(repid,ind)=$lb(ind,Cpid,CpDecs,valueN,valueS,valueR,valueA)
 		set ind=ind+1
	}
	
	k ^||TMPPortalOD100102($j)
	Quit $$$OK
}

}
