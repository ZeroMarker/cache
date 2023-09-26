Class web.DHCEQ.EM.LIBFind Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetEmergencyLevel(EmergencyLevel) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
	 SELECT EL_Desc,
	        EL_RowID,
	        EL_Code
	 FROM sqluser.DHC_EQMCEmergencyLevel
     where EL_InvalidFlag = 'N' and EL_Desc like nvl(:EmergencyLevel,'')||'%'
}

/*Query GetMaintMode(MaintMode) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
	 SELECT MM_Desc,
	        MM_RowID,
	        MM_Code
	 FROM sqluser.DHC_EQMCMaintMode
     where MM_InvalidFlag = 'N' and MM_Desc like nvl(:MaintMode,'')||'%'
}*/
/// Creator：      Mozy
/// CreatDate：    2020-3-3			826989
/// Description:   重写维修类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.LIBFind","GetMaintMode")
Query GetMaintMode(MaintMode As %String = "", Type As %String = "3") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetMaintModeExecute(ByRef qHandle As %Binary, MaintMode As %String = "", Type As %String = "3") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=""
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintMode",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",5)'="N")
	.q:($p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",4)'=+Type)
	.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",2)
	.Quit:(MaintMode'="")&&(Desc'[MaintMode)
	.s Code=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",1)
	.d OutputRowContractTypeList

	Quit $$$OK
OutputRowContractTypeList
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintModeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSeverityLevel(SeverityLevel) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
	 SELECT SL_Desc,
	        SL_RowID,
	        SL_Code
	 FROM sqluser.DHC_EQMCSeverityLevel
     where SL_InvalidFlag = 'N' and SL_Desc like nvl(:SeverityLevel,'')||'%'
}

Query GetEquipStatus(EquipStatus) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT ES_Desc,
	   ES_RowID,
	   ES_Code
FROM sqluser.DHC_EQEquipStatus
where ES_InvalidFlag = 'N' and ES_Desc like nvl(:EquipStatus,'')||'%'
}

/// zc 2022-11-17 增加入參VGroupType 
/// zyq 2022-12-04 增加入参VEquipTypeDR 根据维修大类获取维修组信息
/// modified by wy 2023-2-10 3265996 临时^Temp增加一个序列节点Num
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.LIBFind","MaintGroup","","","","","9")
Query MaintGroup(VType As %String = "", VDesc As %String = "", VUserDR As %String = "", VGroupType As %String = "", VEquipTypeDR As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod MaintGroupExecute(ByRef qHandle As %Binary, VType As %String = "", VDesc As %String = "", VUserDR As %String = "", VGroupType As %String = "", VEquipTypeDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Num=2
	K ^Temp("DHCEQMCMaintGroup",$J)
	s VDesc=$ZCONVERT(VDesc,"U")
	;i VUserDR="" s VUserDR=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //modify by zyq 2022-12-04 begin
	if VGroupType=""
	{
		s MGRowID=0
		;f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",VType,VUserDR,MGRowID))  q:MGRowID=""  d 
		f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID))  q:MGRowID=""  d
		.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
		.q:InvalidFlag="Y"
		.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
		.s Code=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",3)
		.q:(VDesc'="")&&($ZCONVERT(Desc,"U")'[VDesc)&&($ZCONVERT(Code,"U")'[VDesc)
		.s Type=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",1) 
		.q:(VType'="")&&(Type'=VType)
		.s EquipType=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",12)
		.if (VEquipTypeDR=EquipType) d
		..s ^Temp("DHCEQMCMaintGroup",$J,"1",MGRowID)=""  
		.e  d
		..s ^Temp("DHCEQMCMaintGroup",$J,Num,MGRowID)=""
		..s Num=Num+1
	
	}
	else 
	{
		s MGRowID=0
		f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID))  quit:MGRowID=""  d
		.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)="Y"
		.s Type=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",1)
		.q:(VType'="")&&(Type'=VType)
		.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
		.s Code=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",3)
		.q:(VDesc'="")&&($ZCONVERT(Desc,"U")'[VDesc)&&($ZCONVERT(Code,"U")'[VDesc)
		.;add by wy 2023-4-12 3450423增加权限过滤,维修组做区分
		.s EquipType=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",12)
		.q:(EquipType'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,VGroupType,"","2")'=0)   
		.if (VEquipTypeDR=EquipType) d
		..s ^Temp("DHCEQMCMaintGroup",$J,"1",MGRowID)=""  
		.e  d
		..s ^Temp("DHCEQMCMaintGroup",$J,Num,MGRowID)=""
		..s Num=Num+1
	}
	s Num=0
	f  s Num=$o(^Temp("DHCEQMCMaintGroup",$J,Num))  q:Num=""  d
	.s MGRowID=0
	.f  s MGRowID=$o(^Temp("DHCEQMCMaintGroup",$J,Num,MGRowID))  q:MGRowID=""  d
	..s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
	..s Code=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",3)
	..s rowid=MGRowID
	..d OutputRowMaintGroup
	
	k ^Temp("DHCEQMCMaintGroup",$J)
	
	Quit $$$OK
OutputRowMaintGroup
	s Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MaintGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
