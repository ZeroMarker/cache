Class web.DHCEQ.EM.CTFaultReason Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdFaultReason(data)
{
	n frrowid,OperMethod,code,desc
	Set frrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	s EQRowID=$p(data,"^",3)
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503002")
	if (OperMethod=0)||(desc="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select FR_RowID Into :frrowid from SQLUSER.DHC_EQMCFaultReason Where FR_InvalidFlag='N' and FR_Desc=:desc)
	if frrowid=""
	{
		if code=""
		{
			Set frrowid=$Order(^DHCEQCCode("DHCEQMCFaultReason",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",frrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultReason(FR_Code, FR_Desc, FR_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-1601)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		Set frrowid=$Get(%ROWID)
	}
		//add by wy 2023-4-20 新增故障原因时，生成设备对照故障原因
	if EQRowID'="" 
	 {
			s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
		   	s valList="^2^"_frrowid_"^2^"_ItemDR_"^^^Y^^^^^"
			s Reslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(valList)
	        s Reslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(Reslut)
			i Reslut.SQLCODE
			{
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
	  }

	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,frrowid)
}

/*
Query GetFaultReason(FaultReason) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
	SELECT FR_Desc,
		   FR_RowID,
		   FR_Code
	FROM sqluser.DHC_EQMCFaultReason
	where FR_InvalidFlag = 'N' and FR_Desc like nvl(:FaultReason,'')||'%'
}*/
/// /add by wy 2022-4-18 3450429重新写故障原因放大镜取值
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.CTFaultReason","GetFaultReason","","2991")
Query GetFaultReason(FaultReason As %String = "", Equip As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetFaultReasonExecute(ByRef qHandle As %Binary, FaultReason As %String = "", Equip As %String = "") As %Status
{
	new repid, index,rowid,tmp
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s FaultReason=$ZCONVERT(FaultReason,"U")
	s index=1
	s FRRowID=0
	s TRows=0	
	f  s FRRowID=$o(^DHCEQCCode("DHCEQMCFaultReason",FRRowID)) q:FRRowID=""  d
	.s FRDesc=$p($g(^DHCEQCCode("DHCEQMCFaultReason",FRRowID)),"^",2)
	.q:(FaultReason'="")&&(FRDesc'[FaultReason)
	.s FRCode=$p($g(^DHCEQCCode("DHCEQMCFaultReason",FRRowID)),"^",1)
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultReason",FRRowID)),"^",4)
	.q:InvalidFlag="Y"
	.s Pass=0 
	.if Equip'="" d
	..s ItemDR=$p($g(^DHCEQEquip(Equip)),"^",7)
	..s EquiCatDR=$p($g(^DHCEQEquip(Equip)),"^",4)
	..if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",2,FRRowID,2,ItemDR))  d
	...if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",2,FRRowID,1,EquiCatDR)) d
	....s Pass=1 
	.q:Pass=1
	.d OutputRowGetFaultReason
	
	
	quit $$$OK
OutputRowGetFaultReason
	Set Data=$lb(FRDesc,FRRowID,FRCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFaultReason
	Set (FRDesc,FRRowID,FRCode)=""
	quit
}

ClassMethod GetFaultReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultReasonExecute ]
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

ClassMethod GetFaultReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
