Class web.DHCEQ.Stat.DHCEQRentStat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By MWZ 2016-09-27
/// 描述:获取某一时间段内租赁业务信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQRentMwz","GetEquipRent","","","","","","","","1")
Query GetEquipRent(QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", RequestLocDR As %String = "", FromLocDR As %String = "", EQName As %String = "", EquipDR As %String = "", StatusDR As %String = "", RequestNo As %String = "", vStartDate As %String = "", vEndDate As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEQName:%String,TRequestNo:%String,TRequestLoc:%String,TFromLoc:%String,TRequestUser:%String,TEquipDR:%String,TModelDR:%String,TEQNo:%String,TRentManager:%String,TStartDate:%String,TLocReceiver:%String,TLocReturn:%String,TReturnDate:%String,TReturnManager:%String,TWorkLoad:%String,TRentFee:%String,TTotleFee:%String,TRentDays:%String") [ SqlProc ]
{
}

ClassMethod GetEquipRentExecute(ByRef qHandle As %Binary, QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", RequestLocDR As %String = "", FromLocDR As %String = "", EQName As %String = "", EquipDR As %String = "", StatusDR As %String = "", RequestNo As %String = "", vStartDate As %String = "", vEndDate As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	i vStartDate="" d
	.s BeginDate=0
	e  d
	.s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")  //add by zx 2017-03-02
	i vEndDate="" d
	.s EndDate=+$h
	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  //add by zx 2017-03-02
	
	s rowid=0
    f  s rowid=$o(^DHCEQRent(rowid))  Q:rowid=""  d
    .d ResetVariablesGetEquipRent
    .s TRequestNo=$p($g(^DHCEQRent(rowid)),"^",1)  ///申请单号
    .q:(RequestNo'="")&&(RequestNo'=TRequestNo)
    .s TRequestLocDR=$p($g(^DHCEQRent(rowid)),"^",2)  ///申请科室
    .q:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
    .s TFromLocDR=$p($g(^DHCEQRent(rowid)),"^",3)   ///来源科室
    .q:(FromLocDR'="")&&(FromLocDR'=TFromLocDR)
    .s TStatus=$p($g(^DHCEQRent(rowid)),"^",36)  ///状态
    .q:(StatusDR'="")&&(StatusDR'=TStatus)
    .s TItemDR=$p($g(^DHCEQRent(rowid)),"^",7)		///设备项
    .s TEquipTypeDR=""
    .i TItemDR'="" s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",3)
    .s TEquipDR=$p($g(^DHCEQRent(rowid)),"^",9)   ///设备RowID
    .q:(EquipDR'="")&&(EquipDR'=TEquipDR)
    .i TEquipDR'=""  d
    ..s TEQName=$p($g(^DHCEQEquip(TEquipDR)),"^",1) ///设备名
    ..s TEQNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)  ///设备编号
    ..s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
    .q:(EQName'="")&&(EQName'[TEQName)
    .q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    .s TStartDate=$p($g(^DHCEQRent(rowid)),"^",10)  ///借出日期
    .q:(TStartDate<BeginDate)||(TStartDate>EndDate)  ///日期筛选
    .s TRowID=rowid  ///总单rowid
    .s TRequestUserDR=$p($g(^DHCEQRent(rowid)),"^",4)  ///申请人
    .i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
    .s TModelDR=$p($g(^DHCEQRent(rowid)),"^",8)  ///机型
    .s TRentManagerDR=$p($g(^DHCEQRent(rowid)),"^",14)  ///借出人
    .i TRentManagerDR'="" s TRentManager=##class(web.DHCEQCommon).GetTrakNameByID("user",TRentManagerDR)
    .s TLocReceiverDR=$p($g(^DHCEQRent(rowid)),"^",15)  ///科室领用人
    .i TLocReceiverDR'="" s TLocReceiver=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReceiverDR)
    .s TLocReturnDR=$p($g(^DHCEQRent(rowid)),"^",22)   ///科室归还人
    .i TLocReturnDR'="" s TLocReturn=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReturnDR)
    .s TReturnDate=$p($g(^DHCEQRent(rowid)),"^",23)  ///归还日期
    .s TReturnManagerDR=$p($g(^DHCEQRent(rowid)),"^",21)  ///归还管理人
    .i TReturnManagerDR'="" s TReturnManager=##class(web.DHCEQCommon).GetTrakNameByID("user",TReturnManagerDR)
    .i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
    .i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
    .i TStatusDR'="" s TStatus=$CASE(TStatusDR,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
    .s TWorkLoad=$p($g(^DHCEQRent(rowid)),"^",30)  ///工作量
    .s TRentFee=$p($g(^DHCEQRent(rowid)),"^",32)  ///租赁费用
    .s TTotleFee=$p($g(^DHCEQRent(rowid)),"^",35)  ///总费用
    .s TRentDays=TReturnDate-TStartDate  ///租赁时长
    .d OutputRowGetEquipRent
    Quit $$$OK
OutputRowGetEquipRent
	set Data=$lb(TRowID,TEQName,TRequestNo,TRequestLoc,TFromLoc,TRequestUser,TEquipDR,TModelDR,TEQNo,TRentManager,TStartDate,TLocReceiver,TLocReturn,TReturnDate,TReturnManager,TWorkLoad,TRentFee,TTotleFee,TRentDays)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesGetEquipRent
	s (TRowID,TEQName,TRequestNo,TRequestLoc,TFromLoc,TRequestUser,TEquipDR,TModelDR,TEQNo,TRentManager,TStartDate,TLocReceiver,TLocReturn,TReturnDate,TReturnManager,TWorkLoad,TRentFee,TTotleFee,TRentDays)=""
	quit
}

ClassMethod GetEquipRentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRentExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipRentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
