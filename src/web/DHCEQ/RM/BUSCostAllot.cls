/// 名称: web.DHCEQ.RM.BUSCostAllot
/// 描述: 设备租赁费用分摊设置
/// 编写者：ZC
/// 编写日期: 2020-04-21
/// 产品组：设备管理
Class web.DHCEQ.RM.BUSCostAllot Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2019-12-17
/// Description:   上架设置数据保存
/// Input：        data:前台获取字符串 {"field":"value","field":"value",...}  Type 操作类型：(1：删除),(2：新增),(其他:保存)
/// Return：       Json数据 {"SQLCODE":SQLCODE,"RowID":RowID或错误码}
ClassMethod SaveData(Data, Type As %String = "")
{
	s $ZT="ERRORRentCostAllot"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($h,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSRentCostAllot",JsonData,.PLIST)
	s RowID = JsonData.RALRowID
	TSTART
	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQSRentCostAllot set RAL_InvalidFlag='Y' where RAL_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	ELSE
	{
		s PLIST(16)="N"  //状态默认提交
		s PutOnSetDR=JsonData.RALPutOnSetDR
		s AllotType=JsonData.RALAllotType
		s AllotSourceDR=JsonData.RALAllotSourceDR
		s TmpID=""
		&SQL(Select RAL_RowID Into :TmpID from SQLUSER.DHC_EQSRentCostAllot Where RAL_PutOnSetDR=:PutOnSetDR and RAL_AllotType=:AllotType and RAL_AllotSourceDR=:AllotSourceDR and RAL_InvalidFlag<>'Y')
		
		i (RowID'="")&&(TmpID'="")&&(TmpID'=RowID) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
		i TmpID'="" s RowID=TmpID
	    if RowID'=""
	    {
		    s PLIST(10)=User
		    s PLIST(11)=Date 
		    s PLIST(12)=Time 
			&SQL(Update SQLUSER.DHC_EQSRentCostAllot Values :PLIST() where RAL_RowID = :RowID)
		}
		else
		{	
			s PLIST(7)=User
		    s PLIST(8)=Date 
		    s PLIST(9)=Time 
			&SQL(insert into SQLUSER.DHC_EQSRentCostAllot Values :PLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s RowID=$g(%ROWID)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORRentCostAllot
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-12-17
/// Description:   解析单条上架设置信息
/// Table：        DHC_EQSPutOnSet
/// Input：        RowID:上架设置表ID
/// Return：       表数据解析 json返回{"field":"value","field":"value",...}
/// w ##Class(web.DHCEQ.RM.BUSCostAllot).GetOneCostAllot(1)
ClassMethod GetOneCostAllot(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneCostAllot"
	s ObjCostAllot=##Class(User.DHCEQSRentCostAllot).%OpenId(RowID)
	s CostAllotInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjCostAllot)
	i ObjCostAllot.RALAllotType="0" d 
	.d CostAllotInfo.%Set("RALAllotSourceDR_Desc",$Piece($Get(^CT("HOSP",ObjCostAllot.RALAllotSourceDR)),"^",2))
	e  d
	.d CostAllotInfo.%Set("RALAllotSourceDR_Desc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjCostAllot.RALAllotSourceDR))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,CostAllotInfo)
ERRORGetOneCostAllot
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSCostAllot","GetCostAllot","1","","")
Query GetCostAllot(PutOnSetDR As %String = "", AllotType As %String = "", AllotSourceDR As %String = "") As %Query(ROWSPEC = "RALRowID:%String,RALPutOnSetDR:%String,RALAllotType:%String,RALAllotTypeDesc:%String,RALAllotSourceDR:%String,RALAllotSourceDR_Desc:%String,RALAllotPercentNum:%String,RALRemark:%String")
{
}

ClassMethod GetCostAllotExecute(ByRef qHandle As %Binary, PutOnSetDR As %String = "", AllotType As %String = "", AllotSourceDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i PutOnSetDR="" Quit $$$OK
	
	f  s rowid=$o(^DHCEQSRentCostAllot(0,"PutOnSet",PutOnSetDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetCostAllot
	.q:$p($g(^DHCEQSRentCostAllot(rowid)),"^",15)="Y"
	.s TRowID = rowid
	.s TAllotType = $p($g(^DHCEQSRentCostAllot(rowid)),"^",2)
	.q:(AllotType'="")&&(AllotType'=TAllotType)
	.s TAllotTypeDesc =$CASE(TAllotType,"0":"医院", "1":"共享平台中心", "2":"借出部门","":"")
	.s TAllotSourceDR = $p($g(^DHCEQSRentCostAllot(rowid)),"^",3)
	.q:(AllotSourceDR'="")&&(AllotSourceDR'=TAllotSourceDR)
	.i TAllotSourceDR'="" d
	..i TAllotType=0 d
	...s TAllotSourceDRDesc = $Piece($Get(^CT("HOSP",TAllotSourceDR)),"^",2)
	..e  d
	...s TAllotSourceDRDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TAllotSourceDR)
	.s TAllotPercentNum = $p($g(^DHCEQSRentCostAllot(rowid)),"^",4)
	.s TRemark = $p($g(^DHCEQSRentCostAllot(rowid)),"^",5)
	.d OutputRowGetCostAllot
	Quit $$$OK
OutputRowGetCostAllot
	s Data=$lb(TRowID,PutOnSetDR,TAllotType,TAllotTypeDesc,TAllotSourceDR,TAllotSourceDRDesc,TAllotPercentNum,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCostAllot
	s (TRowID,TAllotType,TAllotTypeDesc,TAllotSourceDR,TAllotSourceDRDesc,TAllotPercentNum,TRemark)=""
	quit
}

ClassMethod GetCostAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostAllotExecute ]
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

ClassMethod GetCostAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.RM.BUSCostAllot).GetHosptailInfo(1)
ClassMethod GetHosptailInfo(PutOnSetDR)
{
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (HosptailDR,Hospital)=""
	s HosptailDR=$p($g(^DHCEQSPutOnSet(PutOnSetDR)),"^",6)
	i HosptailDR'="" s Hospital=$Piece($Get(^CT("HOSP",HosptailDR)),"^",2)
	d ReturnInfo.%Set("RALAllotSourceDR",HosptailDR)
	d ReturnInfo.%Set("RALAllotSourceDR_Desc",Hospital)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
}

}
