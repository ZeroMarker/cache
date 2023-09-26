/// CTOR: QP
/// DATE: 2020-02-26
/// DESC: 抗菌药物院区改造扩展
Class DHCAnt.KSS.Extend.Hosp Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     QP
/// CreatDate：   2020-02-26
/// Description:  查询抗菌药物流程
/// Table：       DHCAnt_Base.MainConfig
/// Input：		  
/// output: 	 
/// d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Extend.Hosp","QryProcessConfig","2")
Query QryProcessConfig(InHosp As %String = "") As %Query(ROWSPEC = "id,ParentCode,ParentDesc,CodeF,CodeH,CodeS,CodeU,ULocID,ULocDesc,MCGType,hosp")
{
}

ClassMethod QryProcessConfigExecute(ByRef qHandle As %Binary, InHosp As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	i InHosp="" {
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
	 		
	}
	s mRtn=##class(DHCAnt.Base.MainConfigExcute).SaveMutiProcess(InHosp)
	s hosp=$p(^CT("HOSP",InHosp),"^",2)
	s id=0
	f  s id=$o(^DHCAntBaseMainConfigI("MCGHospAndType",InHosp,"NEWPROCESS",id)) q:id=""  d
	.s (CodeF,CodeH,CodeS,CodeU)=0
	.s (ParentDesc,ULocDesc)=""
	.s MCGType="NEWPROCESS"
	.s ULocID=$p(^DHCAntBaseMainConfigD(id),"^",8)
	.s mcgValue=$p(^DHCAntBaseMainConfigD(id),"^",9)
	.s ParentCode=$p(^DHCAntBaseMainConfigD(id),"^",3)
	.s ParentDesc=$p(^DHCAntBaseMainConfigD(id),"^",4)	//流程类型描述
	.i mcgValue["F" s CodeF=1
	.i mcgValue["H" s CodeH=1
	.i mcgValue["S" s CodeS=1
	.i mcgValue["U" s CodeU=1
	.i ULocID'="" s ULocDesc=$P(^CTLOC(ULocID),"^",2)
 	.i ULocDesc["-" s ULocDesc=$p(ULocDesc,"-",2)
   	.Do OutwardRow
	Quit $$$OK
OutwardRow
	set Data=$lb(id,ParentCode,ParentDesc,CodeF,CodeH,CodeS,CodeU,ULocID,ULocDesc,MCGType,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryProcessConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProcessConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryProcessConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProcessConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     QP
/// CreatDate：   2020-03-19
/// Description:  根据科室查询所有医生
/// Table：       
/// Input：		  
/// output: 	 
/// d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Extend.Hosp","QryDocByDep","","241")
Query QryDocByDep(InHosp As %String = "", InDep As %String = "") As %Query(ROWSPEC = "SSUSRRowId,SSUSRCareProvDR,SSUSRName")
{
}

ClassMethod QryDocByDepExecute(ByRef qHandle As %Binary, InHosp As %String = "", InDep As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	i InDep="" {
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
	 		
	}
	s SSUSRRowId=0
	for 
	{		
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) 
		q:SSUSRRowId="" 
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		s:SSUSRInitials'="" SSUSRInitialsB=$ZCONVERT(SSUSRInitials,"U")
		s:SSUSRName'="" SSUSRNameB=$ZCONVERT(SSUSRName,"U")
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		continue:SSUSRCareProvDR=""
		s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
		s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
		s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
		s:SSUSRCareProvDR="" CTPCPSpecDR=""
		s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
		
		s Flag=0
		s ChildSub=0
		for {
			//SS_UserOtherLogonLoc
			s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""
			s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)  //登陆科室id
			s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",2)  //安全组id	
			if OTHLLCTLOCDR=InDep s Flag=1
		}
		i (SSUSRDefaultDeptDR=InDep) s Flag=1
		continue:Flag'=1
		
		d OutPut		
	
	}
	
	Quit $$$OK
OutPut
	set Data=$lb(SSUSRRowId,SSUSRCareProvDR,SSUSRName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryDocByDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDocByDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDocByDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDocByDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
