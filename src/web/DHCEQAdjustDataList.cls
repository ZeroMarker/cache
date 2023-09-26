/// ------------------------------------------------
/// Create By HZY 2011-09-21 HZY0012
/// Description：查询调整数据明细
/// -------------------------------------------------
Class web.DHCEQAdjustDataList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetAdjustDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdjustDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdjustDataListExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
	new repid,index,rowid,TotalNum,TotalOriginalFee,TotalNetFee,TotalDepreFee,TJob
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)

	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set FromLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"FromLocDR")
	Set StatusDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatusDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")	
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")	
	Set EquipDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
	Set FromEquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"FromEquipTypeDR")
	Set RequestUser=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestUser")
	Set FromStatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"FromStatCatDR")
	Set ReportFlagDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ReportFlagDR")
	Set AdjustTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"AdjustTypeDR")
	Set ToLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ToLocDR")
	Set ToEquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ToEquipTypeDR")
	Set ToStatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ToStatCatDR")
	if (ReportFlagDR="1")
	{
		s ReportFlagDR="Y"
	}
	elseif (ReportFlagDR="2")
	{
		s ReportFlagDR="N"
	}
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s index=2
	s TRow=0  ///add by lmm 2017-06-27 397026
	s rowid=0
	s (TotalNum,TotalOriginalFee,TotalNetFee,TotalDepreFee)=0
	s TJob=$J
		
	Set rowid=0
	For  Set rowid=$Order(^DHCEQAdjustData(rowid))  Quit:rowid=""  Do
	.d ResetVariablesGetAdjustData
	.s TStatus=$p($g(^DHCEQAdjustData(rowid)),"^",11)
	.q:(StatusDR'="")&&(StatusDR'=TStatus)
	.s TStatus=..GetStatus(TStatus)	
	.s TAdjustType=$p($g(^DHCEQAdjustData(rowid)),"^",1)
	.q:(AdjustTypeDR'="")&&(AdjustTypeDR'=TAdjustType)
	.s TAdjustType=..GetAdjustType(TAdjustType)
	.s TReportFlag=$p($g(^DHCEQAdjustData(rowid)),"^",2)
	.q:(ReportFlagDR'="")&&(ReportFlagDR'=TReportFlag)
	.s TDate=$p($g(^DHCEQAdjustData(rowid)),"^",3) 
	.q:((TDate>EndDate)||(TDate<StartDate))
	.i TDate'="" s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.s TRequestUser=$p($g(^DHCEQAdjustData(rowid)),"^",8)
	.q:(RequestUser'="")&&(RequestUser'=TRequestUser)
	.s TDisplayFlag=$p($g(^DHCEQAdjustData(rowid)),"^",12)
	.q:(TDisplayFlag="N")
	.s TTime=$p($g(^DHCEQAdjustData(rowid)),"^",4)
	.i TTime'="" s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time")
	.s TSQL=$p($g(^DHCEQAdjustData(rowid)),"^",5)
	.s TSourceFile=$p($g(^DHCEQAdjustData(rowid)),"^",6)
	.s TContent=$p($g(^DHCEQAdjustData(rowid)),"^",7)
	.s TUser=$p($g(^DHCEQAdjustData(rowid)),"^",9)
	.i TUser'="" s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUser)
	.s TRemark=$p($g(^DHCEQAdjustData(rowid)),"^",10)	
	.s TUpdateUserDR=$p($g(^DHCEQAdjustData(rowid)),"^",13)
	.s TUpdateUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate=$p($g(^DHCEQAdjustData(rowid)),"^",14)
	.i TUpdateDate'="" s TUpdateDate=##class(web.DHCEQCommon).TransValueToPage(TUpdateDate,"date") 
	.s TUpdateTime=$p($g(^DHCEQAdjustData(rowid)),"^",15)
	.i TUpdateTime'="" s TUpdateTime=##Class(web.DHCEQCommon).TransValueToPage(TUpdateTime,"time")
	.s TInvalidUser=$p($g(^DHCEQAdjustData(rowid)),"^",16)
	.s TInvalidDate=$p($g(^DHCEQAdjustData(rowid)),"^",17)
	.i TInvalidDate'="" s TInvalidDate=##class(web.DHCEQCommon).TransValueToPage(TInvalidDate,"date") 
	.s TInvalidTime=$p($g(^DHCEQAdjustData(rowid)),"^",18)
	.i TInvalidTime'="" s TInvalidTime=##Class(web.DHCEQCommon).TransValueToPage(TInvalidTime,"time")
	.s TInvalidReason=$p($g(^DHCEQAdjustData(rowid)),"^",19)
	.
	.s ALrowid=0
	.f  s ALrowid=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,ALrowid)) q:ALrowid=""  d
	..d BuildDataGetAdjustData
	
	d ResetVariablesGetAdjustData
	s TQuantity=TotalNum
	s TOriginalFee=TotalOriginalFee
	s TNetFee=TotalNetFee
	s TDepreTotal=TotalDepreFee
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	i TDepreTotal'="" s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TEquip="合计:"
	s Data=$lb(TRowID,TStatus,TDisplayFlag,TUpdateUser,TUpdateDate,TUpdateTime,TInvalidUser,TInvalidDate,TInvalidTime,TInvalidReason,TQuantity,TAdjustType,TReportFlag,TDate,TTime,TSQL,TSourceFile,TContent,TRequestUser,TUser,TRemark,TAdjustDataDR,TEquip,TFromLoc,TFromEquipType,TFromStatCat,TFromOrigin,TFromInfo,TToLoc,TToEquipType,TToStatCat,TToOrigin,TToInfo,TEQStatus,TOriginalFee,TDepreTotal,TNetFee,TJob,THold1,THold2,THold3,THold4,THold5,THold6)
	Set ^CacheTemp(repid,1)=Data
	
	Quit $$$OK	
BuildDataGetAdjustData
	s (TRowID,TQuantity,TAdjustDataDR,TEquip,TFromLoc,TFromEquipType,TFromStatCat,TFromOrigin,TFromInfo,TToLoc,TToEquipType,TToStatCat,TToOrigin,TToInfo,TEQStatus,TOriginalFee,TDepreTotal,TNetFee,TJob,THold1,THold2,THold3,THold4,THold5,THold6)=""			
	s TRowID=ALrowid
	s TEquipDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",2)
	q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	s TFromLocDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",3)
	q:(FromLocDR'="")&&(FromLocDR'=TFromLocDR)
	i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)  //2014-2-26 HZY0053
	s TFromEquipTypeDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",4)
	q:(FromEquipTypeDR'="")&&(FromEquipTypeDR'=TFromEquipTypeDR)
	i TFromEquipTypeDR'="" s TFromEquipType=$P($g(^DHCEQCCode("DHCEQCEquipType",TFromEquipTypeDR)),"^",2)  //2014-2-26 HZY0053
	
	s TFromStatCatDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",5)
	q:(FromStatCatDR'="")&&(FromStatCatDR'=TFromStatCatDR)
	i TFromStatCatDR'="" s TFromStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TFromStatCatDR)),"^",2)  //2014-2-26 HZY0053
	s TToLocDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",8)
	q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
	i TToLocDR'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)  //2014-2-26 HZY0053
	s TToEquipTypeDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",9)
	q:(ToEquipTypeDR'="")&&(ToEquipTypeDR'=TToEquipTypeDR)
	i TToEquipTypeDR'="" s TToEquipType=$P($g(^DHCEQCCode("DHCEQCEquipType",TToEquipTypeDR)),"^",2)  //2014-2-26 HZY0053
	s TToStatCatDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",10)
	q:(ToStatCatDR'="")&&(ToStatCatDR'=TToStatCatDR)
	i TToStatCatDR'="" s TToStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TToStatCatDR)),"^",2)  //2014-2-26 HZY0053
	s TFromOriginDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",6)
	i TFromOriginDR'="" s TFromOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TFromOriginDR)),"^",2)  //2014-2-26 HZY0053
	s TFromInfo=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",7)
	
	s TToOriginDR=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",11)
	i TToOriginDR'="" s TToOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TToOriginDR)),"^",2)  //2014-2-26 HZY0053
	s TToInfo=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",12)
	s TEQStatus=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",13)
	s TEQStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TEQStatus)	
	s TOriginalFee=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",14)
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreTotal=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",15)
	i TDepreTotal'="" s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TNetFee=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",16)
	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)	
	s THold1=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",17)
	s THold2=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",18)
	s THold3=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",19)
	s THold4=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",20)
	s THold5=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",21)
	s THold6=$p($g(^DHCEQAdjustDataList(ALrowid)),"^",22)
	s TQuantity=1
	s TotalNum=TotalNum+1			//总数
	s TotalOriginalFee=TotalOriginalFee+TOriginalFee	//总金额
	s TotalNetFee=TotalNetFee+TNetFee
	s TotalDepreFee=TotalDepreFee+TDepreTotal
	s TRow=TRow+1  ///add by lmm 2017-06-27 397026			
	d OutputRowGetAdjustData	
	quit
OutputRowGetAdjustData
	s Data=$lb(TRowID,TStatus,TDisplayFlag,TUpdateUser,TUpdateDate,TUpdateTime,TInvalidUser,TInvalidDate,TInvalidTime,TInvalidReason,TQuantity,TAdjustType,TReportFlag,TDate,TTime,TSQL,TSourceFile,TContent,TRequestUser,TUser,TRemark,TAdjustDataDR,TEquip,TFromLoc,TFromEquipType,TFromStatCat,TFromOrigin,TFromInfo,TToLoc,TToEquipType,TToStatCat,TToOrigin,TToInfo,TEQStatus,TOriginalFee,TDepreTotal,TNetFee,TJob,THold1,THold2,THold3,THold4,THold5,THold6,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAdjustData
	s (TRowID,TStatus,TDisplayFlag,TUpdateUser,TUpdateDate,TUpdateTime,TInvalidUser,TInvalidDate,TInvalidTime,TInvalidReason,TQuantity,TAdjustType,TReportFlag,TDate,TTime,TSQL,TSourceFile,TContent,TRequestUser,TUser,TRemark,TAdjustDataDR,TEquip,TFromLoc,TFromEquipType,TFromStatCat,TFromOrigin,TFromInfo,TToLoc,TToEquipType,TToStatCat,TToOrigin,TToInfo,TEQStatus,TOriginalFee,TDepreTotal,TNetFee,TJob,THold1,THold2,THold3,THold4,THold5,THold6)=""
	quit
}

ClassMethod GetAdjustDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdjustDataListExecute ]
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

/// Add By HZY 2011-09-21 HZY0012
/// Description：查询调整数据明细
/// -------------------------------
Query GetAdjustDataList(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStatus:%String,TDisplayFlag:%String,TUpdateUser:%String,TUpdateDate:%String,TUpdateTime:%String,TInvalidUser:%String,TInvalidDate:%String,TInvalidTime:%String,TInvalidReason:%String,TQuantity:%String,TAdjustType:%String,TReportFlag:%String,TDate:%String,TTime:%String,TSQL:%String,TSourceFile:%String,TContent:%String,TRequestUser:%String,TUser:%String,TRemark:%String,TAdjustDataDR:%String,TEquip:%String,TFromLoc:%String,TFromEquipType:%String,TFromStatCat:%String,TFromOrigin:%String,TFromInfo:%String,TToLoc:%String,TToEquipType:%String,TToStatCat:%String,TToOrigin:%String,TToInfo:%String,TEQStatus:%String,TOriginalFee:%String,TDepreTotal:%String,TNetFee:%String,TJob:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,THold6:%String,TRow:%String")
{
}

/// Add By HZY 2011-09-22 HZY0012
/// Desc：调整类型的下拉列表
/// -------------------------------
ClassMethod GetAdjustTypeDiplay(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 add wy 2019-10-28
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>调整数据</option>"
	w "<option value=2>新增数据</option>"
	w "<option value=3>删除数据</option>"
	w "<option value=4>取消报废</option>"
	w "<option value=5>合并数据</option>"
	w "<option value=9>其他调整</option>"
	w "</select>",!
}

/// Add By HZY 2011-09-23 HZY0012
/// Desc：是否影响报表的下拉列表
/// -------------------------------
ClassMethod GetReportFlagDiplay(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 add wy 2019-10-28
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>影响报表</option>"
	w "<option value=2>不影响报表</option>"
	w "</select>",!
}

/// Add By HZY 2011-09-23 HZY0012
/// Desc：调整数据状态的下拉列表
/// -------------------------------
ClassMethod GetStatusDiplay(name, width) As %String
{
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>新增</option>"
	w "<option value=1>执行</option>"
	w "<option value=2>作废</option>"
	w "</select>",!
}

/// Add By HZY 2011-09-23 HZY0012
/// Desc：调整数据状态的下拉列表
/// -------------------------------
ClassMethod GetAdjustType(Type)
{
	q $CASE(Type,"1":"调整数据","2":"新增数据","3":"删除数据","4":"取消报废","5":"数据合并","9":"其他调整","":"")
}

ClassMethod GetStatus(Type)
{
	q $CASE(Type,"0":"新增","1":"执行","2":"作废","":"")
}

}
