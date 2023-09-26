Import SQLUser

Class web.DHCEQDisuseRequestList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 172;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DRL_RowID";

Parameter SQLDESCRIPTION = "DRL_RowID";

Parameter SQLROWID = "DRL_RowID";

Parameter GlobalLen = 33;

ClassMethod UpdateDisuseRequestItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, AppType)
{
	;+AppType=0 新增
	;+AppType=1 更新
	;+AppType=2 删除
	k PLIST
	s RowID=$p(val,"^",1)	;RowID
 	s PLIST(2) = $p(val,"^",2)	;DisuseRequestDR
 	s PLIST(3) = $p(val,"^",3)	;EquipDR
 	s PLIST(4) = $p(val,"^",4)	;UseState
 	s PLIST(5) = $p(val,"^",5)	;DisuseTypeDR
 	s PLIST(6) = $p(val,"^",6)	;ChangeReason 	
 	s PLIST(7) = $p(val,"^",7)	;DisureDate
 	i $p(val,"^",7)'=""  s PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")	;TestFlag
 	s PLIST(8) = $p(val,"^",8)	;Remark
 	s PLIST(9) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;UpdateUserDR
 	s PLIST(10) = +$H	;UpdateDate
 	s PLIST(11) = $P($H,",",2)	;UpdateTime
 	s PLIST(12) = $p(val,"^",11)	;Hold1
 	s PLIST(13) = $p(val,"^",12)	;Hold2
 	s PLIST(14) = $p(val,"^",13)	;Hold3
 	TSTART
 	if +AppType=0
 	{
	 	&sql(insert into sqluser.DHC_EQDisuseRequestList values :PLIST())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=1
 	{
	 	&sql(update sqluser.DHC_EQDisuseRequestList values :PLIST() where DRL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=2
 	{
	 	&sql(delete from sqluser.DHC_EQDisuseRequestList where DRL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	TCOMMIT
 	q SQLCODE
}

ClassMethod GetOneDisuseRequestList(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	if rowid="" q ""
	s (result,resultex)=""
	s result= $g(^DHCEQDisuseRequestList(rowid))
	s resultex=resultex_"^"	;DisuseRequestDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQDisuseRequest($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	.s resultex=resultex_"^"	;EquipNo
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",71)
	.s resultex=resultex_"^"	;EquipInstockDate
	.s resultex=resultex_##class(web.DHCEQEquip).GetInStockDate($p(result,"^",2),0)
	s resultex=resultex_"^"	;DisuseTypeDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDisuseType",$p(result,"^",4))),"^",1)
	s $p(result,"^",6)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;DisureDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;UpdateDate
	
	s EquipDR=$p(result,"^",2)
	s Model=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	i Model'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_Model_"^"_OriginalFee
}

Query GetDisuseRequestList(DisuseRequestDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TDisuseRequestDR:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TUseState:%String,TDisuseTypeDR:%String,TDisuseTypeDesc:%String,TChangeReason:%String,TDisureDate:%String,TRemark:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,THold1:%String,THold2:%String,THold3:%String,TInStockDate:%String")
{
SELECT 	DRL_RowID TRowID ,
	DRL_DisuseRequestDR TDisuseRequestDR ,
	DRL_EquipDR TEquipDR ,
	DRL_EquipDR->EQ_Name TEquipName ,
	DRL_EquipDR->EQ_No TEquipNo ,
	DRL_UseState TUseState ,
	DRL_DisuseTypeDR TDisuseTypeDR ,
	DRL_DisuseTypeDR->DR_Desc TDisuseTypeDesc ,
	DRL_ChangeReason TChangeReason ,
	DRL_DisureDate TDisureDate ,
	DRL_Remark TRemark ,
	DRL_UpdateUserDR TUpdateUserDR ,
	DRL_UpdateDate TUpdateDate ,
	DRL_UpdateTime TUpdateTime ,
	DRL_Hold1 THold1 ,
	DRL_Hold2 THold2 ,
	DRL_Hold3 THold3 ,
	DRL_EquipDR->EQ_InStockListDR->ISL_InStockDR->IS_BillAuditDate TInStockDate
FROM sqluser.DHC_EQDisuseRequestList
where DRL_DisuseRequestDR=:DisuseRequestDR
}

/// Mozy0074 2011-12-21
/// 报废明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQDisuseRequestList","GetDisuseRequestDetail","^RequestNo=^InStockNo=^Equip=电^No=^MinPrice=^MaxPrice=^Status=^RequestLoc=^RequestLocDR=^UserLoc=^UserLocDR=^StartDate=^EndDate=^EquipType=^EquipTypeDR=","")
/// 增加输出列TKindFlag
/// Modified By QW20200218 begin BUG:QW0041 测试需求:报废权限限制
Query GetDisuseRequestDetail(vData As %String = "", QXType As %String = "", RecoverFlag As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TDRRowID:%String,TRequestNo:%String,TRequestDate:%String,TRequestLoc:%String,TUserLoc:%String,TEquip:%String,TNo:%String,TOriginalFee:%String,TQuantityNum:%String,TEquipType:%String,TStatus:%String,TQuantityNum:%String,TUnit:%String,TInStockNo,TJob:%String,PNum:%String,TKindFlag:%String,TRow:%String,TModel:%String,TTransAssetDate:%String,TStartDate:%String,TDepreTotalFee:%String,TNetFee:%String,TDepreMethod:%String,TLimitYearsNum:%String,TProvider:%String,TManufactory:%String,TLeaveFacNo:%String,TStatCat:%String,TEquipCat:%String,TDisuseDate:%String,TAuditDate:%String")
{
}

ClassMethod GetDisuseRequestDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "", RecoverFlag As %Library.String = "") As %Status
{
 	new repid, index, rowid ,PNum ;,Total,TotalFee,EQID,StoreLocID,CheckFlag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("DisuseRequestDetail",User)
    k ^DHCEQTemp("DisuseRequestApproveDate",User)
 	
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set RequestNo=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestNo")
	Set InStockNo=##Class(web.DHCEQCommon).GetDataByName(vData,"InStockNo")
	Set Equip=##Class(web.DHCEQCommon).GetDataByName(vData,"Equip")
	Set No=##Class(web.DHCEQCommon).GetDataByName(vData,"No")
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set RequestLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestLocDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set UserLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UserLocDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	Set ApproveRoleDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ApproveRoleDR")
	Set ApproveDate=##Class(web.DHCEQCommon).GetDataByName(vData,"ApproveDate")
	Set ApproveEndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"ApproveEndDate")
	Set IsPrintDR=##Class(web.DHCEQCommon).GetDataByName(vData,"IsPrintDR")   ;Add By QW20210429 BUG:QW0102
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	If StartDate="" Set StartDate=0
 	If EndDate="" Set EndDate=+$H
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set ApproveDate= ##class(web.DHCEQCommon).TransValueFromPage(ApproveDate,"date")
	Set ApproveEndDate= ##class(web.DHCEQCommon).TransValueFromPage(ApproveEndDate,"date")
 	//Add By QW2021518 BUG:QW0111 Begin
	Set ActionItemString=##class(web.DHCEQCommon).GetDataByName(vData,"ActionItemString") 
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
	// MZY0157	3412820		2023-03-29
	Set SAuditDate=##Class(web.DHCEQCommon).GetDataByName(vData,"SAuditDate")
	Set EAuditDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EAuditDate")
	Set SAuditDate=##class(web.DHCEQCommon).TransValueFromPage(SAuditDate,"date")
	Set EAuditDate=##class(web.DHCEQCommon).TransValueFromPage(EAuditDate,"date")
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	Set index=2
	Set PNum=1
	Set TJob=$J
	Set Total=0
	Set TotalFee=0
	Do BuildDataGetDisuseRequestDetail
	
 	Quit $$$OK
BuildDataGetDisuseRequestDetail
	Quit:vData=""
	Quit:StartDate>EndDate
    ///modified by ZY 2738278 20220817
    Set sortFlag=+##class(web.DHCEQCommon).GetSysInfo("990089") 
	
	Set DRLRowID=0
	For  Set DRLRowID=$Order(^DHCEQDisuseRequestList(DRLRowID)) Quit:DRLRowID=""  Do
	.Do ResetVariablesGetDisuseRequestDetail
	.Set TDRRowID=$Piece($Get(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
	.Set TEquipDR=$Piece($Get(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.Set TRequestNo=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",33)
	.s TKindFlag=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",44)  //Modefied by zc 2015-03-30   zc0021
	.Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",63)
	.Quit:(EquipTypeDR'="")&(TEquipTypeDR'=EquipTypeDR)
	.Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	.Quit:(RequestNo'="")&(TRequestNo'[RequestNo)
	.Set TInStockNo=""
	.Set TInStockListDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",70)
	.If TInStockListDR'="" Do
	..Set TISRowID=$Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",1)
	..Set TInStockNo=$Piece($Get(^DHCEQInStock(TISRowID)),"^",14)
	.Quit:(InStockNo'="")&(TInStockNo'[InStockNo)
	.Set TEquip=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	.Quit:(Equip'="")&(TEquip'[$ZCONVERT(Equip,"U"))
	.Set TNo=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	.Quit:(No'="")&(TNo'[$ZCONVERT(No,"U"))
	.Set TOriginalFee=+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	.Quit:(MinPrice="")&(MaxPrice'="")&(TOriginalFee>MaxPrice)
	.Quit:(MinPrice'="")&(MaxPrice="")&(TOriginalFee<MinPrice)
	.Quit:(MinPrice'="")&(MaxPrice'="")&((TOriginalFee<MinPrice)||(TOriginalFee>MaxPrice))
	.Set TStatus=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",10)
	.Quit:(Status'="")&&(TStatus'=Status)
	.Set TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.Set TRequestLocDR=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",3)
	.Quit:(RequestLocDR'="")&&(TRequestLocDR'=RequestLocDR)
	.If TRequestLocDR'="" Set TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.If TRequestLoc'="" Set TRequestLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TRequestLoc,"-")
	.Set TUserLocDR=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",34)
	.Quit:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TUserLocDR)))
	.Quit:(UserLocDR'="")&&(TUserLocDR'=UserLocDR)
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TUserLocDR) ;Add QW20210629 BUG:QW0131
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	.s TPrintNum=##class(web.DHCEQ.Plat.BUSOperateLog).GetOperateTimes("34",TDRRowID) ;Modified By QW20210913 BUG:QW0147 修改打印次数
	.q:(IsPrintDR="1")&&(+TPrintNum=0) 
	.q:(IsPrintDR="0")&&(+TPrintNum'=0) 
	.If TUserLocDR'="" Set TUserLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUserLocDR)
	.If TUserLoc'="" Set TUserLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUserLoc,"-")
	.Set TEquipTypeDR=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",43)
	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))	;Mozy0104	2013-8-24
	.Set TRequestDate=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",4)
	.Quit:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	.Set TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	.Set TUnitDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",5)
	.If TUnitDR'="" Set TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.//Modify by zx 2021-05-08 1897082
	.Set TModelDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",3)
	.Set TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.//Add ByQW2021518 BUG:QW0111 begin
	.;Quit:(##class(web.DHCEQApprove).CheckApproveRole("5",TDRRowID,ApproveRoleDR,ApproveDate,ApproveEndDate)'=0)	;20140409  Mozy0125
	.q:(+ActionItemString'=0)&&((","_$p($g(^DHCEQDisuseRequest(TDRRowID)),"^",31)_",")'[(","_ActionItemString_","))
	.s ActionInfo=##Class(web.DHCEQCommon).ActionFilter(TDRRowID,"34","0")
    .///modified by ZY 2738278 20220817
    .s TLastApproveDate=$p(ActionInfo,",",2)
    .s TLastApproveTime=$p(ActionInfo,",",3)
	.q:(ApproveDate'="")&&(ApproveDate>$p(ActionInfo,",",2))
	.q:(ApproveEndDate'="")&&(ApproveEndDate<$p(ActionInfo,",",2))
	.//Add By QW2021518 BUG:QW0111 end
	.Set TQuantityNum=1
	.//Modify by zx 2021-05-08 1897082
	.Set TTransAssetDate=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",45)
	.Set TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	.Set TStartDate=##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQEquip(TEquipDR)),"^",44),"date")
	.Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQEquip(TEquipDR)),"^",35),"",2)
	.Set TNetFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQEquip(TEquipDR)),"^",28),"",2)
	.Set TDepreMethod=##Class(web.DHCEQCommon).GetTrakNameByID("depremethod",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",33))
	.Set TLimitYearsNum=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",31)
	.Set TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",25))
	.Set TManufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",26))
	.Set TLeaveFacNo=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",10)
	.Set TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",75))
	.Set TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",4))
	.Set TDisuseDate=##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",21),"date")
	.// MZY0157	3412820		2023-03-29
	.s TAuditDate=""
	.s auditflag=0
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,TDRRowID,0))
	.i AIRowID'="" d
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRole'="" d
	...s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)
	...i TApproveRole=ApproveRoleDR d
	....s ALRowID=$o(^DHCEQApproveList("0","ApproveRole",ApproveType,TDRRowID,TApproveRole,""),-1)
	....i ALRowID'="" d
	.....i (SAuditDate'="")&&($p($g(^DHCEQApproveList(ALRowID)),"^",7)<SAuditDate) s auditflag=1
	.....i (EAuditDate'="")&&($p($g(^DHCEQApproveList(ALRowID)),"^",7)>EAuditDate) s auditflag=1
	.....s TAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(ALRowID)),"^",7),"date")
	.....s TAuditDate=TAuditDate_"  "_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(ALRowID)),"^",8),"time")
	.q:auditflag'=0
	.q:((SAuditDate'="")||(EAuditDate'=""))&&(TAuditDate="")
	.Set TotalFee=TotalFee+TOriginalFee
	.Set Total=Total+TQuantityNum
    .///modified by ZY 2738278 20220817
    .i sortFlag=0 d
    ..Do OutputRowGetDisuseRequestDetail
    .e  d
    ..Set ^DHCEQTemp("DisuseRequestApproveDate",User,TJob,+TLastApproveDate,+TLastApproveTime,DRLRowID)=TRowID_"^"_TDRRowID_"^"_TRequestNo_"^"_TRequestDate_"^"_TRequestLoc_"^"_TUserLoc_"^"_TEquip_"^"_TNo_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TEquipType_"^"_TStatus_"^"_TQuantityNum_"^"_TUnit_"^"_TInStockNo_"^"_TJob_"^"_PNum_"^"_TKindFlag_"^"_TRow_"^"_TModel_"^"_TTransAssetDate_"^"_TStartDate_"^"_TDepreTotalFee_"^"_TNetFee_"^"_TDepreMethod_"^"_TLimitYearsNum_"^"_TProvider_"^"_TManufactory_"^"_TLeaveFacNo_"^"_TStatCat_"^"_TEquipCat_"^"_TDisuseDate
    
    ///modified by ZY 2738278 20220817
    if sortFlag'=0
    {
        s LastApproveDate=""
        if sortFlag=1  d
        .For  Set LastApproveDate=$Order(^DHCEQTemp("DisuseRequestApproveDate",User,TJob,LastApproveDate)) Quit:LastApproveDate=""  Do
        ..s LastApproveTime=""
        ..For  Set LastApproveTime=$Order(^DHCEQTemp("DisuseRequestApproveDate",User,TJob,LastApproveDate,LastApproveTime)) Quit:LastApproveTime=""  Do
        ...d BuildDisuseRequestDetail
        e  d
        .For  Set LastApproveDate=$Order(^DHCEQTemp("DisuseRequestApproveDate",User,TJob,LastApproveDate),-1) Quit:LastApproveDate=""  Do
        ..s LastApproveTime=""
        ..For  Set LastApproveTime=$Order(^DHCEQTemp("DisuseRequestApproveDate",User,TJob,LastApproveDate,LastApproveTime),-1) Quit:LastApproveTime=""  Do
        ...d BuildDisuseRequestDetail
    }
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")		//Modify DJ 2017-03-16
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" Set TotalLoc=1
		i TotalFlag="2" Set TotalLoc=index+1
		i TotalFlag="3" Set TotalLoc=0
		Do ResetVariablesGetDisuseRequestDetail
		Set TQuantityNum=Total
		Set TOriginalFee=TotalFee
		Set TRow="合计:"
		Set Data=$lb(TRowID,TDRRowID,TRequestNo,TRequestDate,TRequestLoc,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TEquipType,TStatus,TQuantityNum,TUnit,TInStockNo,TJob,PNum,TKindFlag,TRow,TModel,TTransAssetDate,TStartDate,TDepreTotalFee,TNetFee,TDepreMethod,TLimitYearsNum,TProvider,TManufactory,TLeaveFacNo,TStatCat,TEquipCat,TDisuseDate,TAuditDate)
		Set ^CacheTemp(repid,TotalLoc)=Data
		Set ^DHCEQTemp("DisuseRequestDetail",User,TJob,PNum)=TRequestNo_"^"_TRequestDate_"^"_TRequestLoc_"^"_TUserLoc_"^"_TEquip_"^"_TNo_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TEquipType_"^"_TStatus_"^"_TUnit_"^"_TInStockNo_"^"_TModel_"^"_TTransAssetDate_"^"_TStartDate_"^"_TDepreTotalFee_"^"_TNetFee_"^"_TDepreMethod_"^"_TLimitYearsNum_"^"_TProvider_"^"_TManufactory_"^"_TLeaveFacNo_"^"_TStatCat_"^"_TEquipCat_"^"_TDisuseDate_"^"_TAuditDate
	}
	Quit
OutputRowGetDisuseRequestDetail
	s TRow=PNum
	Set Data=$lb(TRowID,TDRRowID,TRequestNo,TRequestDate,TRequestLoc,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TEquipType,TStatus,TQuantityNum,TUnit,TInStockNo,TJob,PNum,TKindFlag,TRow,TModel,TTransAssetDate,TStartDate,TDepreTotalFee,TNetFee,TDepreMethod,TLimitYearsNum,TProvider,TManufactory,TLeaveFacNo,TStatCat,TEquipCat,TDisuseDate,TAuditDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("DisuseRequestDetail",User,TJob,PNum)=TRequestNo_"^"_TRequestDate_"^"_TRequestLoc_"^"_TUserLoc_"^"_TEquip_"^"_TNo_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TEquipType_"^"_TStatus_"^"_TUnit_"^"_TInStockNo_"^"_TModel_"^"_TTransAssetDate_"^"_TStartDate_"^"_TDepreTotalFee_"^"_TNetFee_"^"_TDepreMethod_"^"_TLimitYearsNum_"^"_TProvider_"^"_TManufactory_"^"_TLeaveFacNo_"^"_TStatCat_"^"_TEquipCat_"^"_TDisuseDate_"^"_TAuditDate
	Set PNum=PNum+1
	
	Quit
ResetVariablesGetDisuseRequestDetail
    Set (TRowID,TDRRowID,TRequestNo,TRequestDate,TRequestLoc,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TEquipType,TStatus,TQuantityNum,TUnit,TInStockNo,TKindFlag,TRow,TModelDR,TModel,TTransAssetDate)=""
    s (TStartDate,TDepreTotalFee,TNetFee,TDepreMethod,TLimitYearsNum,TProvider,TManufactory,TLeaveFacNo,TStatCat,TEquipCat,TDisuseDate)=""
    Quit
    
    ///modified by ZY 2738278 20220817
BuildDisuseRequestDetail
    s DRLRowID=0
    For  Set DRLRowID=$Order(^DHCEQTemp("DisuseRequestApproveDate",User,TJob,LastApproveDate,LastApproveTime,DRLRowID)) Quit:DRLRowID=""  Do
    .s DataList=$g(^DHCEQTemp("DisuseRequestApproveDate",User,TJob,LastApproveDate,LastApproveTime,DRLRowID))
    .s TRowID=$p(DataList,"^",1)
    .s TDRRowID=$p(DataList,"^",2)
    .s TRequestNo=$p(DataList,"^",3)
    .s TRequestDate=$p(DataList,"^",4)
    .s TRequestLoc=$p(DataList,"^",5)
    .s TUserLoc=$p(DataList,"^",6)
    .s TEquip=$p(DataList,"^",7)
    .s TNo=$p(DataList,"^",8)
    .s TOriginalFee=$p(DataList,"^",9)
    .s TQuantityNum=$p(DataList,"^",10)
    .s TEquipType=$p(DataList,"^",11)
    .s TStatus=$p(DataList,"^",12)
    .s TQuantityNum=$p(DataList,"^",13)
    .s TUnit=$p(DataList,"^",14)
    .s TInStockNo=$p(DataList,"^",15)
    .s TJob=$p(DataList,"^",16)
    .;s PNum=$p(DataList,"^",17)
    .s TKindFlag=$p(DataList,"^",18)
    .s TRow=$p(DataList,"^",19)
    .s TModel=$p(DataList,"^",20)
    .s TTransAssetDate=$p(DataList,"^",21)
    .s TStartDate=$p(DataList,"^",22)
    .s TDepreTotalFee=$p(DataList,"^",23)
    .s TNetFee=$p(DataList,"^",24)
    .s TDepreMethod=$p(DataList,"^",25)
    .s TLimitYearsNum=$p(DataList,"^",26)
    .s TProvider=$p(DataList,"^",27)
    .s TManufactory=$p(DataList,"^",28)
    .s TLeaveFacNo=$p(DataList,"^",29)
    .s TStatCat=$p(DataList,"^",30)
    .s TEquipCat=$p(DataList,"^",31)
    .s TDisuseDate=$p(DataList,"^",32)
    .d OutputRowGetDisuseRequestDetail
    Quit
}

ClassMethod GetDisuseRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
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

ClassMethod GetDisuseRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 add by CZF 20180827
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	;i (Type="")||(Type="0")||(Type="4") w "<option value=0>"_..GetInStockStatus(0)_"</option>"
	i Type'="2" w "<option value=1>"_..GetInStockStatus(1)_"</option>"
	w "<option value=2>"_..GetInStockStatus(2)_"</option>"
	w "</select>",!
}

ClassMethod GetInStockStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核",:"没有定义")
}

/// Modefied by zc 2015-03-30  zc0021
ClassMethod GetComponent(val As %String = "", Type As %String = "0")
{
	new Component
	
	if ((val=0)||(val=1))
	{
		Set Component="DHCEQBatchDisuseRequest"
	}
	else
	{
		Set Component="DHCEQDisuseRequestSimple"
	}
	Quit Component
}

/// czf 2022-06-06
/// 描述：hisui改造在jQuery页面标签显示合计信息
/// 输入：node：临时global的节点名称
/// w ##Class(web.DHCEQDisuseRequestList).GetSumInfo(61300)
ClassMethod GetSumInfo(Ejob As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	
	s (Count,TotalFee,TotalNetFee,TotalDepreFee)=0
	
	s nrowid=0
	//modified by cjt 2022-08-06 需求号2794182 $h改成curuser
	f  s nrowid=$o(^DHCEQTemp("DisuseRequestDetail",curuser,Ejob,nrowid)) q:nrowid=""  d
	.q:$p($g(^DHCEQTemp("DisuseRequestDetail",curuser,Ejob,nrowid)),"^",1)=""  //合计行
	.s OriginalFee=$p($g(^DHCEQTemp("DisuseRequestDetail",curuser,Ejob,nrowid)),"^",7)
	.s Quantity=$p($g(^DHCEQTemp("DisuseRequestDetail",curuser,Ejob,nrowid)),"^",8)
	.s Count=Count+Quantity
	.s TotalFee=TotalFee+(Quantity*OriginalFee)
	
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
  	s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee
  	
  	q info
}

/// czf 2022-06-24
/// 获取导出明细数量
/// node:"DisuseRequestDetail" 报废明细
ClassMethod GetTempDataRows(node As %Library.String = "", job)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $o(^DHCEQTemp(node,User,job,""),-1)
}

/// czf 2022-06-24
/// 获取行导出明细数据
/// node:"DisuseRequestDetail" 报废明细
ClassMethod GetTempData(node As %Library.String = "", job, gnum)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^DHCEQTemp(node,User,job,PNum))
}

}
