Class web.DHCEQ.EM.CTFaultType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdFaultType(data)
{
	n ftrowid,OperMethod,code,desc
	Set ftrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	s EQRowID=$p(data,"^",3)
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503001")
	if (OperMethod=0)||(desc="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select FT_RowID Into:ftrowid from SQLUSER.DHC_EQMCFaultType Where FT_InvalidFlag='N' and FT_Desc=:desc)
	if ftrowid=""
	{
		if code=""
		{
			Set ftrowid=$Order(^DHCEQCCode("DHCEQMCFaultType",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCFaultType",ftrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultType(FT_Code, FT_Desc, FT_InvalidFlag,FT_Type) Values(:code,:desc,'N','0')) ;Modified By QW20211224
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-200499)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		Set ftrowid=$Get(%ROWID)
	}
		//add by wy 2023-4-20 新增故障类型时，生成设备对照类型
	if EQRowID'="" 
	 {
			s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
		   	s valList="^4^"_ftrowid_"^2^"_ItemDR_"^^^Y^^^^^"
			s Reslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(valList)
	        s Reslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(Reslut)
			i Reslut.SQLCODE
			{
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
	  }

	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ftrowid)
}

/*
/// Modified By QW20211224
Query GetFaultType(FaultType, type As %Library.String = "0") As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT FT_Desc,
	   FT_RowID,
	   FT_Code
FROM sqluser.DHC_EQMCFaultType
where FT_InvalidFlag = 'N' and FT_Type=:type and FT_Desc like nvl(:FaultType,'')||'%'
}*/
/// /add by wy 2023-4-13 3450429重新故障类型放大镜取值
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.CTFaultType","GetFaultType","","","","","22")
Query GetFaultType(Code As %String = "", Desc As %String = "", Remark As %String = "", type As %Library.String = "0", Equip As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod GetFaultTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", type As %Library.String = "0", Equip As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	s TRow=1
	d BuildDataGetFaultType	
	Quit $$$OK
BuildDataGetFaultType
	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFaultType
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",2) //描述
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",4) //无符号标志
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.s FType=$p($g(^DHCEQCCode("DHCEQMCFaultType",rowid)),"^",5)
	.q:(type'="")&&(type'=FType)
	.s Pass=0  //add by wy 2023-4-13 检测设备是否存在对照故障类型
	.if Equip'="" d
	..s ItemDR=$p($g(^DHCEQEquip(Equip)),"^",7)
	..s EquiCatDR=$p($g(^DHCEQEquip(Equip)),"^",4)
	..if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",4,rowid,2,ItemDR))  d
	...if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",4,rowid,1,EquiCatDR)) d
	....s Pass=1 
	.q:Pass=1

	.d OutputRowGetFaultType
	quit
OutputRowGetFaultType
   	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetFaultType
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod GetFaultTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultTypeExecute ]
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

ClassMethod GetFaultTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
