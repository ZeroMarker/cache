Class web.DHCEQ.EM.CTDealMethod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdDealMethod(data)
{
	n dmrowid,OperMethod,code,desc
	Set dmrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	s EQRowID=$p(data,"^",3)
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503003")
	if (OperMethod=0)||(desc="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select DM_RowID Into :dmrowid from SQLUSER.DHC_EQMCDealMethod Where DM_InvalidFlag='N' and DM_Desc=:desc)
	if dmrowid=""
	{
		if code=""
		{
			Set dmrowid=$Order(^DHCEQCCode("DHCEQMCDealMethod",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",dmrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCDealMethod(DM_Code, DM_Desc, DM_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-1602)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		Set dmrowid=$Get(%ROWID)
	}
	//add by wy 2023-4-20 新增解决方法时，生成设备对照解决方法
	if EQRowID'="" 
	 {
			s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
		   	s valList="^3^"_dmrowid_"^2^"_ItemDR_"^^^Y^^^^^"
			s Reslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(valList)
	        s Reslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(Reslut)
			i Reslut.SQLCODE
			{
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
	  }

	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,dmrowid)
}

/*
Query GetDealMethod(DealMethod) As %SQLQuery(ROWSPEC = "TDescription:%String,TRowID:%String,TCode:%String")
{
SELECT DM_Desc,
	   DM_RowID,
	   DM_Code
FROM sqluser.DHC_EQMCDealMethod
where DM_InvalidFlag = 'N' and DM_Desc like nvl(:DealMethod,'')||'%'
}*/
/// /add by wy 2023-4-13 3450429重新解决方法放大镜取值
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.CTDealMethod","GetDealMethod","","")
Query GetDealMethod(DealMethod As %String = "", Equip As %String = "") As %Query(ROWSPEC = "TDescription:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetDealMethodExecute(ByRef qHandle As %Binary, DealMethod As %String = "", Equip As %String = "") As %Status
{
	new repid, index,rowid,tmp
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s DealMethod=$ZCONVERT(DealMethod,"U")
	s index=1
	s DMRowID=0
	s TRows=0	
	f  s DMRowID=$o(^DHCEQCCode("DHCEQMCDealMethod",DMRowID)) q:DMRowID=""  d
	.s DMDesc=$p($g(^DHCEQCCode("DHCEQMCDealMethod",DMRowID)),"^",2)
	.q:(DealMethod'="")&&(DMDesc'[DealMethod)
	.s DMCode=$p($g(^DHCEQCCode("DHCEQMCDealMethod",DMRowID)),"^",1)
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCDealMethod",DMRowID)),"^",4)
	.q:InvalidFlag="Y"
	.s Pass=0 //modified by zyq begin 2023-03-14 ÓÐ¶ÔÕÕ±íÔòÅÐ¶Ï¶ÔÕÕ±íÊÇ·ñ¿ÉÓÃ£¬Ã»¶ÔÕÕ±íÔòÏÔÊ¾È«²¿¹ÊÕÏÏÖÏó
	.if Equip'="" d
	..s ItemDR=$p($g(^DHCEQEquip(Equip)),"^",7)
	..s EquiCatDR=$p($g(^DHCEQEquip(Equip)),"^",4) 
	..if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",3,DMRowID,2,ItemDR))&&'$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",3,DMRowID,1,EquiCatDR))  d
	...s Pass=1 
	.q:Pass=1 
	.d OutputRowGetDealMethod	
	quit $$$OK
OutputRowGetDealMethod
	Set Data=$lb(DMDesc,DMRowID,DMCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDealMethod
	Set (DMDesc,DMRowID,DMCode)=""
	quit
}

ClassMethod GetDealMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDealMethodExecute ]
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

ClassMethod GetDealMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDealMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
