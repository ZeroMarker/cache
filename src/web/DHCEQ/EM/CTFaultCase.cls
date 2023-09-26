Class web.DHCEQ.EM.CTFaultCase Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
/// w ##class(web.DHCEQ.EM.CTFaultCase).UpdFaultCase("测试故障现象")
ClassMethod UpdFaultCase(data)
{
	n fcrowid,FaultCaseOperMethod,FaultCase,code,desc
	s fcrowid=""
	s code=$ZCONVERT($p(data,"^",1),"U")
	s desc=$ZCONVERT($p(data,"^",2),"U")
	s EQRowID=$p(data,"^",3)
	s SQLCODE=0
	s FaultCaseOperMethod=##class(web.DHCEQCommon).GetSysInfo("503004")
	if (FaultCaseOperMethod=0)||(desc="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select FC_RowID Into:fcrowid from SQLUSER.DHC_EQMCFaultCase Where FC_InvalidFlag='N' and FC_Desc=:desc)
	if fcrowid="" //新增当前故障现象
	{
		//modified by wy 2022-9-2 故障现象FC_Type保存
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultCase (FC_Code,FC_Desc,FC_InvalidFlag,FC_Type) Values(:code,:desc,'N','0'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-1600)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		s fcrowid=$G(%ROWID)
		
	}
	//add by wy 2022-9-1 新增故障现象时，生成设备对照故障现象
	if EQRowID'="" 
	 {
			s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
		   	s valList="^1^"_fcrowid_"^2^"_ItemDR_"^^^Y^^^^^"
			s Reslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(valList)
	        s Reslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(Reslut)
			i Reslut.SQLCODE
			{
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
	  }
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,fcrowid)
}

/*
Query GetFaultCase(FaultCase, type As %Library.String = "0") As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT FC_Desc,
	   FC_RowID,
	   FC_Code
FROM sqluser.DHC_EQMCFaultCase
where FC_InvalidFlag = 'N' and FC_Type=:type and FC_Desc like nvl(:FaultCase,'')||'%' 

}*/
/// /add by wy 2022-4-18 重新写故障现象放大镜取值
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.CTFaultCase","GetFaultCase","","0","53")
Query GetFaultCase(FaultCase As %String = "", type As %Library.String = "0", Equip As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetFaultCaseExecute(ByRef qHandle As %Binary, FaultCase As %String = "", type As %Library.String = "0", Equip As %String = "") As %Status
{
	new repid, index,rowid,tmp
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s FaultCase=$ZCONVERT(FaultCase,"U")   //modified by wy 2023-3-1
	s index=1
	s FCRowID=0
	s ExistFlag=0
	f  s FCRowID=$o(^DHCEQCCode("DHCEQMCFaultCase",FCRowID)) q:FCRowID=""  d
	.s FCDesc=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FCRowID)),"^",2)
	.q:(FaultCase'="")&&(FCDesc'[FaultCase)   //modified by wy 2023-3-1 
	.s FCCode=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FCRowID)),"^",1)
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FCRowID)),"^",4)
	.q:InvalidFlag="Y"
	.s FCType=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FCRowID)),"^",5)
	.q:(type'="")&&(type'=FCType)
	.s Pass=0  //modified by zyq begin 2022-10-13 有对照表则判断对照表是否可用，没对照表则显示全部故障现象
	.if Equip'="" d
	..s ItemDR=$p($g(^DHCEQEquip(Equip)),"^",7)
	..s EquiCatDR=$p($g(^DHCEQEquip(Equip)),"^",4) 
	..s ItemDRRowId=""
	..s ItemDRRowId=$o(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",1,FCRowID,2,ItemDR,0))
	..s InvalidFlag=""
	..i ItemDRRowId'="" d
	...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",ItemDRRowId)),"^",7)
	...s ExistFlag=1 //判断是否存在对照表
	..i InvalidFlag="Y" s Pass=1
	..s EquiCatDRRowId=""
	..s EquiCatDRRowId=$o(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",1,FCRowID,1,EquiCatDR,0))
	..i EquiCatDRRowId'="" d
	...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",EquiCatDRRowId)),"^",7)
	...s ExistFlag=1
	..i InvalidFlag="Y" s Pass=1
	..if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",1,FCRowID,2,ItemDR))  d
	...if '$d(^DHCEQCCode("DHCEQMCFaultEquipMap","0","FaultID",1,FCRowID,1,EquiCatDR)) d
	....;s Pass=1 
	.i (Pass=0)&&(Equip'="")&&(ExistFlag=1) q ////modified by zyq end 2022-10-13
	.d OutputRowGetFaultCase
	
	quit $$$OK
OutputRowGetFaultCase
	Set Data=$lb(FCDesc,FCRowID,FCCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFaultCase
	Set (FCDesc,FCRowID,FCCode)=""
	quit
}

ClassMethod GetFaultCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultCaseExecute ]
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

ClassMethod GetFaultCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultCaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
