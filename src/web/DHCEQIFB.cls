Import SQLUser

/// -----------------------------------------------
/// Modified By HZY 2011-10-18 HZY0015 
/// 修改函数: AuditData 
/// -----------------------------------------------
/// 修改人： Mozy 2011-01-06
/// 描述:招标表
Class web.DHCEQIFB Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified ZY0197  增加管理部门参数
/// 设备招标记录查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQIFB","IFB","","","checked",1,3,"","","04/12/2018")
Query IFB(PrjName As %String = "", No As %String = "", WaitAD As %String = "", Status As %String = "", ApproveRole As %String = "", ModeDR As %String = "", StartDate As %String = "", EndDate As %String = "", ManageLocDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TPrjName:%String,TPrjIntro:%String,TNo:%String,TModeDR:%String,TMode:%String,TTenderee:%String,TendereeAddress:%String,TConPerson:%String,TTel:%String,TFax:%String,TBuyFilePrice:%String,TBuyFileFromDate:%String,TBuyFileFromTime:%String,TBuyFileToDate:%String,TBuyFileToTime:%String,TBuyFilePlace:%String,AgencyConPerson:%String,TAgencyDR:%String,TAgency:%String,TAgencyTel:%String,TAgencyFax:%String,TAgencyConPerson:%String,TAnnouncementDate:%String,TAnnouncementMedia:%String,TReservePrice:%String,TDisabuseDate:%String,TDeadlineDate:%String,TDeadlineTime:%String,TSubmissionPlace:%String,TOpenDate:%String,TOpenTime:%String,TOpenPlace:%String,TEvaluationCommittee:%String,TDeterminationDate:%String,TCondition:%String,TManageLocDR:%String,TManageLoc:%String,TBuyTypeDR:%String,TRemark:%String,TAddUserDR:%String,TUpdateUser:%String,TAddUser:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TStatus:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,TApproveRole:%String,TRow:%String,TApprovals:%String")
{
}

ClassMethod IFBExecute(ByRef qHandle As %Binary, PrjName As %String = "", No As %String = "", WaitAD As %String = "", Status As %String = "", ApproveRole As %String = "", ModeDR As %String = "", StartDate As %String = "", EndDate As %String = "", ManageLocDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set CurRole=""  
 	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	Set index=1
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	//hisui改造 add by wy 2018-12-6
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	Set rowid=0
	For  Set rowid=$Order(^DHCEQIFB(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesIFB
	.Set TRowID = rowid
	.Set TPrjName=$Piece($Get(^DHCEQIFB(TRowID)),"^",1)
	.Quit:(PrjName'="")&&(TPrjName'[PrjName)
	.Set TPrjIntro=$Piece($Get(^DHCEQIFB(TRowID)),"^",2)
	.Set TNo=$Piece($Get(^DHCEQIFB(TRowID)),"^",3)
	.Quit:(No'="")&&(TNo'[No)
	.Set TModeDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",4)
	.Quit:(ModeDR'="")&&(ModeDR'=TModeDR)
	.If TModeDR'="" Set TMode=$Piece($Get(^DHCEQCCode("DHCEQCIFBMode",TModeDR)),"^",2)
	.Set TTenderee=$Piece($Get(^DHCEQIFB(TRowID)),"^",5)
	.Set TendereeAddress=$Piece($Get(^DHCEQIFB(TRowID)),"^",6)
	.Set TConPerson=$Piece($Get(^DHCEQIFB(TRowID)),"^",7)
	.Set TTel=$Piece($Get(^DHCEQIFB(TRowID)),"^",8)
	.Set TFax=$Piece($Get(^DHCEQIFB(TRowID)),"^",9)
	.Set TBuyFilePrice=$Piece($Get(^DHCEQIFB(TRowID)),"^",10)
	.Set TBuyFileFromDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",11)
	.If TBuyFileFromDate'="" Set TBuyFileFromDate=##class(web.DHCEQCommon).TransValueToPage(TBuyFileFromDate,"date")
	.Set TBuyFileFromTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",12)
	.Set TBuyFileToDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",13)
	.If TBuyFileToDate'="" Set TBuyFileToDate=##class(web.DHCEQCommon).TransValueToPage(TBuyFileToDate,"date")
	.Set TBuyFileToTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",14)
	.Set TBuyFilePlace=$Piece($Get(^DHCEQIFB(TRowID)),"^",15)
	.Set TDeposit=$Piece($Get(^DHCEQIFB(TRowID)),"^",16)
	.Set TAgencyDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",17)
	.If TAgencyDR'="" Set TAgency=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TAgencyDR)),"^",2)
	.Set TAgencyTel=$Piece($Get(^DHCEQIFB(TRowID)),"^",18)
	.Set TAgencyFax=$Piece($Get(^DHCEQIFB(TRowID)),"^",19)
	.Set TAgencyConPerson=$Piece($Get(^DHCEQIFB(TRowID)),"^",20)
	.Set TAnnouncementDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",21)
	.If TAnnouncementDate'="" Set TAnnouncementDate=##class(web.DHCEQCommon).TransValueToPage(TAnnouncementDate,"date")
	.Set TAnnouncementMedia=$Piece($Get(^DHCEQIFB(TRowID)),"^",22)
	.Set TReservePrice=$Piece($Get(^DHCEQIFB(TRowID)),"^",23)
	.Set TDisabuseDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",24)
	.If TDisabuseDate'="" Set TDisabuseDate=##class(web.DHCEQCommon).TransValueToPage(TDisabuseDate,"date")
	.Set TDeadlineDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",25)
	.If TDeadlineDate'="" Set TDeadlineDate=##class(web.DHCEQCommon).TransValueToPage(TDeadlineDate,"date")
	.Set TDeadlineTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",26)
	.Set TSubmissionPlace=$Piece($Get(^DHCEQIFB(TRowID)),"^",27)
	.Set TOpenDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",28)
	.If TOpenDate'="" Set TOpenDate=##class(web.DHCEQCommon).TransValueToPage(TOpenDate,"date")
	.Set TOpenTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",29)
	.Set TOpenPlace=$Piece($Get(^DHCEQIFB(TRowID)),"^",30)
	.Set TEvaluationCommittee=$Piece($Get(^DHCEQIFB(TRowID)),"^",31)
	.Set TDeterminationDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",32)
	.If TDeterminationDate'="" Set TDeterminationDate=##class(web.DHCEQCommon).TransValueToPage(TDeterminationDate,"date")
	.Set TCondition=$Piece($Get(^DHCEQIFB(TRowID)),"^",33)
	.Set TManageLocDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",34)
	.Quit:(ManageLocDR'="")&&(ManageLocDR'=TManageLocDR)  //add by zy0197  增加管理部门限制
	.q:(TManageLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TManageLocDR)))	//czf 2021-09-02
	.s THospitalDR = ##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TManageLocDR)
	.If TManageLocDR'="" Set TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.Set TBuyTypeDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",35)
	.If TBuyTypeDR'="" Set TBuyType=$Piece($Get(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	.Set TRemark=$Piece($Get(^DHCEQIFB(TRowID)),"^",36)
	.Set TAddUserDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",37)
	.If TAddUserDR'="" Set TAddUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.Set TAddDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",38)
	.Quit:(TAddDate>EndDate)||(TAddDate<StartDate)
	.If TAddDate'="" Set TAddDate=##class(web.DHCEQCommon).TransValueToPage(TAddDate,"date")
	.Set TAddTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",39)
	.Set TUpdateUserDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",40)
	.If TUpdateUserDR'="" Set TUpdateUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.Set TUpdateDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",41)
	.If TUpdateDate'="" Set TUpdateDate=##class(web.DHCEQCommon).TransValueToPage(TUpdateDate,"date")
	.Set TUpdateTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",42)
	.Set TStatus=$Piece($Get(^DHCEQIFB(TRowID)),"^",43)
	.Quit:(Status'="")&&(Status'=TStatus)
	.Quit:(WaitAD="checked")&&(TStatus="2")  	//add by wy hisui改造 界面传参WaitAD 改为0和1，界面显示为checked
	.Set TStatus=##class(web.DHCEQIFB).GetIFBStatus(TStatus)
	.Set TSubmitUserDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",44)
	.If TSubmitUserDR'="" Set TSubmitUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUser)
	.Set TSubmitDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",45)
	.If TSubmitDate'="" Set TSubmitDate=##class(web.DHCEQCommon).TransValueToPage(TSubmitDate,"date")
	.Set TSubmitTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",46)
	.Set TAuditUserDR=$Piece($Get(^DHCEQIFB(TRowID)),"^",47)
	.If TAuditUserDR'="" Set TAuditUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.Set TAuditDate=$Piece($Get(^DHCEQIFB(TRowID)),"^",48)
	.If TAuditDate'="" Set TAuditDate=##class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	.Set TAuditTime=$Piece($Get(^DHCEQIFB(TRowID)),"^",49)
	.Set AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s TApprovals="无"
	.s (AppSetDR,NextStepID)=""
	.If AIRowID'="" Do
	..s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)		//czf 2021-09-01
	..s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)
	..Set CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	..Set TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	..;modifed by wy 2019-1-4 791496
	.i $Piece($Get(^DHCEQIFB(TRowID)),"^",43)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.If TApproveRole'="" Set TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TApproveRole)	;Mozy0047	2011-3-22
	.q:(WaitAD="checked")&&(CurRole'="")&&(CurRole'=ApproveRole) //add by wy hisui改造 界面传参WaitAD 改为0和1，界面显示为checked
	.s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	.i (AppSetDR'="")&&(NextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	..i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	.q:(WaitAD="checked")&&(ApproveRole=CurRole)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	.Do OutputRowIFB
	Quit $$$OK
OutputRowIFB
	Set TRow=index	// 20150914  Mozy0165 序号
	Set Data=$lb(TRowID,TPrjName,TPrjIntro,TNo,TModeDR,TMode,TTenderee,TendereeAddress,TConPerson,TTel,TFax,TBuyFilePrice,TBuyFileFromDate,TBuyFileFromTime,TBuyFileToDate,TBuyFileToTime,TBuyFilePlace,AgencyConPerson,TAgencyDR,TAgency,TAgencyTel,TAgencyFax,TAgencyConPerson,TAnnouncementDate,TAnnouncementMedia,TReservePrice,TDisabuseDate,TDeadlineDate,TDeadlineTime,TSubmissionPlace,TOpenDate,TOpenTime,TOpenPlace,TEvaluationCommittee,TDeterminationDate,TCondition,TManageLocDR,TManageLoc,TBuyTypeDR,TRemark,TAddUserDR,TUpdateUser,TAddUser,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TStatus,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TApproveRole,TRow,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesIFB
	Set (TRowID,TPrjName,TPrjIntro,TNo,TModeDR,TMode,TTenderee,TendereeAddress,TConPerson,TTel,TFax,TBuyFilePrice,TBuyFileFromDate,TBuyFileFromTime,TBuyFileToDate,TBuyFileToTime,TBuyFilePlac,AgencyConPerson,TAgencyDR,TAgency,TAgencyTel,TAgencyFax,TAgencyConPerson,TAnnouncementDate,TAnnouncementMedia,TReservePrice,TDisabuseDate,TDeadlineDate,TDeadlineTime,TSubmissionPlace,TOpenDate,TOpenTime,TOpenPlace,TEvaluationCommittee,TDeterminationDate,TCondition,TManageLocDR,TManageLoc,TBuyTypeDR,TRemark,TAddUserDR,TUpdateUser,TAddUser,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TStatus,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TApproveRole,TRow,TApprovals)=""
	Quit
}

ClassMethod IFBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod IFBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Mozy	2011-01-07
/// modify by WY hisui改造 添加默认
ClassMethod StatusList(name, width, Type, value As %String = "") As %String
{
	s selectfir=$case(value,0:"selected",:"")
	s selectsec=$case(value,1:"selected",:"")
	s selectthi=$case(value,2:"selected",:"")
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //by kdf
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (Type="")||(Type="0")||(Type="4") w "<option value=0 "_selectfir_">"_..GetIFBStatus(0)_"</option>"
	i Type'="2" w "<option value=1 "_selectsec_">"_..GetIFBStatus(1)_"</option>"
	w "<option value=2 "_selectthi_">"_..GetIFBStatus(2)_"</option>"
	;w "<option value=3>"_..GetInStockStatus(3)_"</option>"
	w "</select>",!
}

ClassMethod GetIFBStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核",:"没有定义")
}

ClassMethod GetIFBExtendType(ExtendType)
{
	Quit $CASE(ExtendType,"0":"设备项","1":"采购申请","2":"采购计划",:"")
}

/// w ##class(web.DHCEQIFB).GetIFBByID(1)
ClassMethod GetIFBByID(rowid As %Library.String = "")
{
	Quit:rowid="" ""
	new result,resultex
	Set result= $Get(^DHCEQIFB(rowid))
	Set resultex=""
	Set $Piece(result,"^",10)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",10),"")
	Set $Piece(result,"^",23)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",23),"")
	If $Piece(result,"^",11)'="" Set $Piece(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",11),"date")
	If $Piece(result,"^",12)'="" Set $Piece(result,"^",12)=$ZTIME($Piece(result,"^",12))
	If $Piece(result,"^",13)'="" Set $Piece(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",13),"date")
	If $Piece(result,"^",14)'="" Set $Piece(result,"^",14)=$ZTIME($Piece(result,"^",14))
	If $Piece(result,"^",21)'="" Set $Piece(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",21),"date")
	If $Piece(result,"^",24)'="" Set $Piece(result,"^",24)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",24),"date")
	If $Piece(result,"^",25)'="" Set $Piece(result,"^",25)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",25),"date")
	If $Piece(result,"^",26)'="" Set $Piece(result,"^",26)=$ZTIME($Piece(result,"^",26))
	If $Piece(result,"^",28)'="" Set $Piece(result,"^",28)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",28),"date")
	If $Piece(result,"^",29)'="" Set $Piece(result,"^",29)=$ZTIME($Piece(result,"^",29))
	If $Piece(result,"^",32)'="" Set $Piece(result,"^",32)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",32),"date")
	
	Set resultex=resultex_"^"	;ModelDR	1
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCIFBMode",$Piece(result,"^",4))),"^",2)
	Set resultex=resultex_"^"	;AgencyDR	2
	If $Piece(result,"^",17)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",$Piece(result,"^",17))),"^",2)
	Set resultex=resultex_"^"	;ManageLocDR	3
	If $Piece(result,"^",34)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID($Piece(result,"^",34),"dept")
	Set resultex=resultex_"^"	;BuyTypeDR	4
	If $Piece(result,"^",35)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCBuyType",$Piece(result,"^",35))),"^",2)
	Set resultex=resultex_"^"	;CurrencyDR	5
	If $Piece(result,"^",58)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCCurrency",$Piece(result,"^",58))),"^",2)
	
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("17",rowid)
	Set resultex=resultex_"^"_AppInfo
	Set result=##class(web.DHCEQCommon).Replace(result_resultex,$C(13,10),"\n") //回车符转换为"\n"
	
	Quit rowid_"^"_result
}

/// 创建:Mozy 2011-1-8
/// 描述:新增、更新、删除数据记录
/// w ##class(web.DHCEQIFB).SaveData("","","机构名称1^代理资质1^地址1^电话1^传真1^联系人1^^","1^2^3^4^5","2")
/// w ##class(web.DHCEQIFB).SaveData("2^^^","","3","")
ClassMethod SaveData(val As %Library.String = "", list As %Library.String = "", OperateType As %Library.String = "", DelRowid As %Library.String = "")
{
	Kill PLIST,LIST,rowid,Rowid,No
	Set $ZT="ERRORSaveData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set rowid=$Piece(val,"^",1)
	If (+OperateType=1)
	{
		TStart
	 	&SQL(delete from sqluser.DHC_EQIFBBag where IFBB_IFBDR=:rowid)
	 	&SQL(delete from sqluser.DHC_EQIFB where IFB_RowID=:rowid)
	 	If SQLCODE
		{
			TROLLBACK
			Quit rowid_"^"_SQLCODE
		}
	 	
	 	TCOMMIT
	 	Quit rowid_"^"_SQLCODE
 	}
 	If (+OperateType=0) //新增,更新
 	{
	 	Set IFBRowID=rowid
	 	Set PLIST(2)=	$Piece(val,"^",2)	// IFB_PrjName	2
		Set PLIST(3)=	$Piece(val,"^",3)	// IFB_PrjIntro	3
		Set PLIST(4)=	$Piece(val,"^",4)	// IFB_No	4
		Set No=$Piece(val,"^",4)
		&SQL(select IFB_RowID into :Rowid from SQLUSER.DHC_EQIFB where IFB_No=:No)
		Quit:(Rowid'="")&(Rowid'=IFBRowID) Rowid_"^招标编号重复:"_No
		Set PLIST(5)=	$Piece(val,"^",5)	// IFB_ModeDR	5
		Set PLIST(6)=	$Piece(val,"^",6)	// IFB_Tenderee	6
		Set PLIST(7)=	$Piece(val,"^",7)	// IFB_TendereeAddress	7
		Set PLIST(8)=	$Piece(val,"^",8)	// IFB_ConPerson	8
		Set PLIST(9)=	$Piece(val,"^",9)	// IFB_Tel	9
		Set PLIST(10)=	$Piece(val,"^",10)	// IFB_Fax	10
		Set PLIST(11)=	$Piece(val,"^",11)	// IFB_BuyFilePrice	11
		Set PLIST(12)=	$Piece(val,"^",12)	// IFB_BuyFileFromDate	12
		If PLIST(12)'="" Set PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",12),"date")
		Set PLIST(13)=	$Piece(val,"^",13)	// IFB_BuyFileFromTime	13
		If PLIST(13)'="" Set PLIST(13) = $ZTIMEH(PLIST(13))
		Set PLIST(14)=	$Piece(val,"^",14)	// IFB_BuyFileToDate	14
		If PLIST(14)'="" Set PLIST(14) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",14),"date")
		Set PLIST(15)=	$Piece(val,"^",15)	// IFB_BuyFileToTime	15
		If PLIST(15)'="" Set PLIST(15) = $ZTIMEH(PLIST(15))
		Set PLIST(16)=	$Piece(val,"^",16)	// IFB_BuyFilePlace	16
		Set PLIST(17)=	$Piece(val,"^",17)	// IFB_Deposit	17
		Set PLIST(18)=	$Piece(val,"^",18)	// IFB_AgencyDR	18
		Set PLIST(19)=	$Piece(val,"^",19)	// IFB_AgencyTel	19
		Set PLIST(20)=	$Piece(val,"^",20)	// IFB_AgencyFax	20
		Set PLIST(21)=	$Piece(val,"^",21)	// IFB_AgencyConPerson	21
		Set PLIST(22)=	$Piece(val,"^",22)	// IFB_AnnouncementDate	22
		If PLIST(22)'="" Set PLIST(22) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",22),"date")
		Set PLIST(23)=	$Piece(val,"^",23)	// IFB_AnnouncementMedia	23
		Set PLIST(24)=	$Piece(val,"^",24)	// IFB_ReservePrice	24
		Set PLIST(25)=	$Piece(val,"^",25)	// IFB_DisabuseDate	25
		If PLIST(25)'="" Set PLIST(25) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",25),"date")
		Set PLIST(26)=	$Piece(val,"^",26)	// IFB_DeadlineDate	26
		If PLIST(26)'="" Set PLIST(26) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",26),"date")
		Set PLIST(27)=	$Piece(val,"^",27)	// IFB_DeadlineTime	27
		If PLIST(27)'="" Set PLIST(27) = $ZTIMEH(PLIST(27))
		Set PLIST(28)=	$Piece(val,"^",28)	// IFB_SubmissionPlace	28
		Set PLIST(29)=	$Piece(val,"^",29)	// IFB_OpenDate	29
		If PLIST(29)'="" Set PLIST(29) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",29),"date")
		Set PLIST(30)=	$Piece(val,"^",30)	// IFB_OpenTime	30
		If PLIST(30)'="" Set PLIST(30) = $ZTIMEH(PLIST(30))
		Set PLIST(31)=	$Piece(val,"^",31)	// IFB_OpenPlace	31
		Set PLIST(32)=	$Piece(val,"^",32)	// IFB_EvaluationCommittee	32
		Set PLIST(33)=	$Piece(val,"^",33)	// IFB_DeterminationDate	33
		If PLIST(33)'="" Set PLIST(33) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",33),"date")
		Set PLIST(34)=	$Piece(val,"^",34)	// IFB_Condition	34
		Set PLIST(35)=	$Piece(val,"^",35)	// IFB_ManageLocDR	35
		Set PLIST(36)=	$Piece(val,"^",36)	// IFB_BuyTypeDR	36
		Set PLIST(37)=	$Piece(val,"^",37)	// IFB_Remark	37
		Set PLIST(51)=	$Piece(val,"^",38)	// IFB_Hold1	51
		Set PLIST(52)=	$Piece(val,"^",39)	// IFB_Hold2	52
		Set PLIST(53)=	$Piece(val,"^",40)	// IFB_Hold3	53
		Set PLIST(54)=	$Piece(val,"^",41)	// IFB_Hold4	54
		Set PLIST(55)=	$Piece(val,"^",42)	// IFB_Hold5	55
		Set PLIST(59)=	$Piece(val,"^",43)	// IFB_Currency	59
		
		TStart
	 	If (rowid="")  //新增按钮操作
	 	{
		 	Set PLIST(38)=	User	// IFB_AddUserDR	38
			Set PLIST(39)=	updDate	// IFB_AddDate	39
			Set PLIST(40)=	updTime	// IFB_AddTime	40
		 	Set PLIST(44)=	0		// IFB_Status	44
		 	
		 	&SQL(Insert Into SQLUSER.DHC_EQIFB Values :PLIST())
	 	}
	 	Else  //更新按钮操作
	 	{
		 	Set PLIST(41)=	User	// IFB_UpdateUserDR	41
			Set PLIST(42)=	updDate	// IFB_UpdateDate	42
			Set PLIST(43)=	updTime	// IFB_UpdateTime	43
			&SQL(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID = :IFBRowID)
	 	}
	 	Set rowid=$Get(%ROWID)
	 	
	 	Set Length=$Length(list,"&")
	 	For i=1:1:Length
		{
			Set valList= $Piece(list,"&",i)
			
		 	// 设备招标包号表
		 	Set IFBBrowid=	$Piece(valList,"^",1)
		 	Set LIST(2)=rowid							//	IFBB_IFBDR	2
		 	Set LIST(3)=	$Piece(valList,"^",2)		//	IFBB_BagNo	3
			Set LIST(4)=	$Piece(valList,"^",3)		//	IFBB_ItemDR	4
			Set LIST(5)=	$Piece(valList,"^",4)		//	IFBB_UnitDR	5
			Set LIST(6)=	$Piece(valList,"^",5)		//	IFBB_Quantity	6
			Set LIST(7)=	$Piece(valList,"^",6)		//	IFBB_ManuFactoryDR	7
			Set LIST(8)=	$Piece(valList,"^",7)		//	IFBB_ModelDR	8
			Set LIST(9)=	$Piece(valList,"^",8)		//	IFBB_Arg	9
			Set LIST(10)=	$Piece(valList,"^",9)		//	IFBB_ExtendType	10
			Set LIST(11)=	$Piece(valList,"^",10)		//	IFBB_ExtendID	11
			Set LIST(12)=	$Piece(valList,"^",11)		//	IFBB_WinPrice	12
			Set LIST(13)=	$Piece(valList,"^",12)		//	IFBB_Remark	13
			Set LIST(14)=	$Piece(valList,"^",23)		//	IFBB_Hold1/CommonName 2013-11-11  Mozy0112
		 	If (IFBBrowid="")  //新增按钮操作
		 	{
			 	&SQL(Insert Into SQLUSER.DHC_EQIFBBag Values :LIST())
		 	}
		 	Else  //更新按钮操作
		 	{
				&SQL(Update SQLUSER.DHC_EQIFBBag Values :LIST() where IFBB_RowID = :IFBBrowid)
		 	}
		 	Set BagID=$Get(%ROWID)
		 	
		 	// 设备供应商应标记录
		 	If $Piece(valList,"^",14)'=""
		 	{
			 	Kill LIST
			 	Set IFBLrowid=$Piece(valList,"^",13)
			 	Set LIST(2)=BagID							//	IFBL_IFBBagDR	2
			 	Set LIST(3)=	$Piece(valList,"^",14)		//	IFBL_VendorDR	3
				Set LIST(4)=	$Piece(valList,"^",15)		//	IFBL_ManuFactoryDR	4
				Set LIST(5)=	$Piece(valList,"^",16)		//	IFBL_ModelDR	5
				Set LIST(6)=	$Piece(valList,"^",17)		//	IFBL_Arg	6
				Set LIST(7)=	$Piece(valList,"^",18)		//	IFBL_Price	7
				;Set LIST(8)=	$Piece(valList,"^",19)		//	IFBL_Amount	8
				Set LIST(9)="Y"								//	IFBL_WinFlag	9
				;;编辑行无以下字段
				;Set LIST(12)=	$Piece(valList,"^",20)		//	IFBL_CandidacySeq	12
				;Set LIST(13)=	$Piece(valList,"^",21)		//	IFBL_Score	13
				;Set LIST(14)=	$Piece(valList,"^",22)		//	IFBL_Remark	14
				If (IFBLrowid="")  //新增按钮操作
			 	{
				 	&SQL(Insert Into SQLUSER.DHC_EQIFBList Values :LIST())
			 	}
			 	Else  //更新按钮操作
			 	{
				 	//&SQL(Update SQLUSER.DHC_EQIFBList Set IFBL_WinFlag='N' where IFBL_IFBBagDR = :BagID)
					&SQL(Update SQLUSER.DHC_EQIFBList Values :LIST() where IFBL_RowID = :IFBLrowid)
			 	}
		 	}
		}
		Set SQLCODE=##Class(web.DHCEQIFB).DeleteIFBBag(DelRowid)
	 	If SQLCODE
		{
			TROLLBACK
			Quit rowid_"^"_SQLCODE
		}
	 	
	 	TCOMMIT
	 	Quit rowid_"^"_SQLCODE
 	}
 	
ERRORSaveData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSaveData"_ErrorMsg     	//返回错误消息
}

/// 创建:Mozy 2011-1-18
/// 描述:提交
/// w ##Class(web.DHCEQIFB).SubmitData("8^1^")
ClassMethod SubmitData(val)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($Get(^DHCEQIFB(RowID)),"^",43)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	Quit:##Class(web.DHCEQIFB).CheckWinVendor(RowID) -3001
	
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
 	// Mozy0042	2011-2-21
 	Set MaxPrice=0
 	Set ListRowID=0
 	For  Set ListRowID=$Order(^DHCEQIFBBag(0,"IFB",RowID,ListRowID))  Quit:ListRowID=""  Do
 	.If +$Piece(^DHCEQIFBBag(ListRowID),"^",11)>MaxPrice  Do
 	..Set MaxPrice=+$Piece(^DHCEQIFBBag(ListRowID),"^",11)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", MaxPrice,"")
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;Status
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="") 
	{
		Set AppInfoStatus="2"
		Set AuditFlag=1
	}
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"17",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(44)=	1		// IFB_Status	44
 	Set PLIST(45)=	User	// IFB_SubmitUserDR	45
	Set PLIST(46)=	updDate	// IFB_SubmitDate	46
	Set PLIST(47)=	updTime	// IFB_SubmitTime	47
	&SQL(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit SQLCODE
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQIFB).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}		
	}
	;Modified by jdl 2011-3-17  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("93", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	Quit RowID
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSubmitData"_ErrorMsg     //返回错误消息
}

/// 创建:Mozy 2011-1-18
/// 描述:取消提交
/// w ##Class(web.DHCEQIFB).CancelSubmitData("8^1^")
ClassMethod CancelSubmitData(val, CurRole)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}
	
	TSTART
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("17", RowID)
	Set PLIST(44)=	Status	// IFB_Status	44
	Set PLIST(56)=	User	// IFB_RejectUserDR	55
	Set PLIST(57)=	updDate	// IFB_RejectDate	56
	Set PLIST(58)=	updTime	// IFB_RejectTime	57
	&sql(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	;Modified by jdl 2011-3-17  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("93", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	Quit RowID
ERRORCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// 创建:Mozy 2011-1-18
/// 描述:审核
/// w ##Class(web.DHCEQIFB).AuditData("19^1^","3","2","")
/// w ##Class(web.DHCEQIFB).AuditData("42^1^","3","2","DHC_EQIFB&41^12312312,25^项目联系人,30@DHC_EQIFBBag&112^21,29")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($Get(^DHCEQIFB(RowID)),"^",43)
	if Status'="1" q -2015   //Modified By HZY 2011-10-18 HZY0015 .该记录状态不符合,不能执行操作!
	
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("17", RowID)	
	If ApproveSet="" Quit -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)

	Set AppInfoStatus="1"	;Status	
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		
		Set PLIST(48)=	User	// IFB_AuditUserDR	48
		Set PLIST(49)=	updDate	// IFB_AuditDate	49
		Set PLIST(50)=	updTime	// IFB_AuditTime	50
		&sql(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
		If SQLCODE
		{
		 	TROLLBACK
			Quit SQLCODE
		}
		Set AppInfoStatus="2"	;Status
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	;执行当前角色要执行的动作
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""
	{
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQIFB).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	;Modified by jdl 2011-3-9  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("93", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	
	Quit RowID
ERRORAuditData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORAuditData"_ErrorMsg		//返回错误消息
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQIFB).LastAuditAction(5)
/// ----------------------------------
ClassMethod LastAuditAction(RowID)
{
	Set PLIST(44)=	2		// IFB_Status	44
	&sql(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
	Quit SQLCODE
}

/// Mozy	2011-1-13
/// 招标包查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQIFB","IFBBagDetail","36")
Query IFBBagDetail(RowID As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TIFBDR:%String,TBagNo:%String,TItemDR:%String,TItem:%String,TUnitDR:%String,TUnit:%String,TQuantity:%String,TManuFactoryDR:%String,TManuFactory:%String,TModelDR:%String,TModel:%String,TArg:%String,TExtendTypeDR:%String,TExtendType:%String,TExtendID:%String,TExtendName:%String,TWinPrice:%String,TRemark:%String,TListRowID:%String,TListIFBBagDR:%String,TListVendorDR:%String,TListVendor:%String:%String,TListManuFactoryDR:%String,TListManuFactory:%String,TListModelDR:%String,TListModel:%String,TListArg:%String,TListPrice:%String,TAmount:%String,TWinQty:%String,TCommonName:%String")
{
}

ClassMethod IFBBagDetailExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index, rowid, flag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=0
	Set TotalNum=0
 	Set TotalFee=0
 	Kill ^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j)
 	
	If RowID'=""
	{
		Set rowid=0
		For  Set rowid=$Order(^DHCEQIFBBag(0,"IFB",RowID,rowid))  Quit:rowid=""  Do
		.Set TBagNo = $Piece($Get(^DHCEQIFBBag(rowid)),"^",2)
		.Set ^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j,RowID,TBagNo,rowid)=""
		
		Set TBagNo=""
		For  Set TBagNo=$Order(^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j,RowID,TBagNo))  Quit:TBagNo=""  Do
		.Set rowid=0
		.For  Set rowid=$Order(^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j,RowID,TBagNo,rowid))  Quit:rowid=""  Do
		..Do ResetVariablesIFBBagDetail
		..Set TRowID = rowid
		..Set TIFBDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",1)
		..Set TBagNo = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",2)
		..Set TItemDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",3)
		..If TItemDR '="" Set TItem = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
		..Set TUnitDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",4)
		..If TUnitDR'="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..Set TQuantity = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",5)
		..Set TManuFactoryDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",6)
		..If TManuFactoryDR '="" Set TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
		..Set TModelDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",7)
		..If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		..Set TArg = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",8)
		..Set TExtendTypeDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",9)
		..Set TExtendID = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",10)
		..
		..If TExtendTypeDR'="" Do
		...Set TExtendType=##class(web.DHCEQIFB).GetIFBExtendType(TExtendTypeDR)
		...If TExtendTypeDR=1 Do
		....Set TExtendName=$Piece($Get(^DHCEQBuyRequestList(TExtendID)),"^",1)	;采购申请
		....Set TExtendName=$Piece($Get(^DHCEQBuyRequest(TExtendName)),"^",1)
		...
		...If TExtendTypeDR=2 Do
		....Set TExtendName=$Piece($Get(^DHCEQBuyPlanList(TExtendID)),"^",1)	;采购计划
		....Set TExtendName=$Piece($Get(^DHCEQBuyPlan(TExtendName)),"^",1)
		...
		..Set TWinPrice = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQIFBBag(TRowID)),"^",11),"")
		..Set TRemark = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",12)
		..Set TCommonName=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",13) //2013-06-24 DJ0118
		..Set flag=0
		..Set IFBLDR=0
		..For  Set IFBLDR=$Order(^DHCEQIFBList(0,"IFBBag",TRowID,IFBLDR))  Quit:(IFBLDR="")||(flag'=0)  Do
		...Set WinFlag = $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",8)
		...;中标供应商
		...If WinFlag="Y" Do
		....Set TListRowID = IFBLDR
		....Set flag=1
		....Set TListVendorDR = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",2)
		....If TListVendorDR'="" Do
		.....Set TListVendor = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TListVendorDR)
		.....Set TListVendor = ##class(web.DHCEQCommon).GetSplitDataByFlag(TListVendor,"-")
		....Set TListManuFactoryDR = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",3)
		....If TListManuFactoryDR '="" Set TListManuFactory =##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TListManuFactoryDR)  //$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TListManuFactoryDR)),"^",1) //CZF0093
		....Set TListModelDR = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",4)
		....If TListModelDR '="" Set TListModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TListModelDR)),"^",2)
		....Set TListArg = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",5)
		....Set TListPrice = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQIFBList(TListRowID)),"^",6),"")
		....Set TWinQty = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",9)
		..
		..Set TotalNum = TotalNum+TQuantity
		..Set TAmount = TWinPrice*TQuantity
		..Set TotalFee=TotalFee+TAmount
		..Set TRow=TRow+1
		..
		..Do OutputRowIFBBagDetail
	}
	
	If TRow=0
	{
		Do ResetVariablesIFBBagDetail
		Set TRow=1
		Do OutputRowIFBBagDetail
	}
	// 设备台帐查询合计显示方式
	// 0：不显示 1：显示在首行 2：显示在末行  3：显示在其它元素上
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If (TotalFlag'="")&&(TotalFlag'="0")
	{
		If TotalFlag="1" Set TotalLoc=1
		If TotalFlag="2" Set TotalLoc=index+1
		Do ResetVariablesIFBBagDetail
		Set TRowID=-1
		Set TBagNo="合计:"
		Set TQuantity=TotalNum
		Set TAmount=TotalFee
		Do OutputRowIFBBagDetail
	}
	
	Quit $$$OK
OutputRowIFBBagDetail
	Set Data=$lb(TRow,TRowID,TIFBDR,TBagNo,TItemDR,TItem,TUnitDR,TUnit,TQuantity,TManuFactoryDR,TManuFactory,TModelDR,TModel,TArg,TExtendTypeDR,TExtendType,TExtendID,TExtendName,TWinPrice,TRemark,TListRowID,TListIFBBagDR,TListVendorDR,TListVendor,TListManuFactoryDR,TListManuFactory,TListModelDR,TListModel,TListArg,TListPrice,TAmount,TWinQty,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesIFBBagDetail
	Set (TRowID,TIFBDR,TItemDR,TItem,TUnitDR,TUnit,TQuantity,TManuFactoryDR,TManuFactory,TModelDR,TModel,TArg,TExtendTypeDR,TExtendType,TExtendID,TExtendName,TWinPrice,TRemark,TListRowID,TListIFBBagDR,TListVendorDR,TListVendor,TListManuFactoryDR,TListManuFactory,TListModelDR,TListModel,TListArg,TListPrice,TAmount,TWinQty,TCommonName)=""
	Quit
}

ClassMethod IFBBagDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBBagDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod IFBBagDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBBagDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建:Mozy 2011-1-17
/// 描述:删除招标包明细
/// w ##Class(web.DHCEQIFB).DeleteIFBBag(",0,0,0")
ClassMethod DeleteIFBBag(DelRowIDs)
{
	new Length,IFBBRowID,Flag,i
	If DelRowIDs="" Quit 0
	
	Set Flag=0
	Set Length=$Length(DelRowIDs,",")
	for i=1:1:Length
	{
		Quit:Flag'=0
		Set IFBBRowID=$Piece(DelRowIDs,",",i)
		If (IFBBRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQIFBBag where IFBB_RowID=:IFBBRowID)
			If SQLCODE Set Flag=SQLCODE
		}
	}
	Quit Flag
}

/// 检测招标包是否有中标供应商
/// 返回： -1	异常			""	正常		其他	招标包异常
/// w ##class(web.DHCEQIFB).CheckWinVendor(27)
ClassMethod CheckWinVendor(IFBDR As %Library.String = "")
{
	Quit:IFBDR="" -1
	New flag,id,rowid,IFBLDR,CountWinFlag
	Set flag=""
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQIFBBag(0,"IFB",IFBDR,rowid))  Quit:rowid=""  Do
	.Set CountWinFlag = 0
	.Set IFBLDR=0
	.For  Set IFBLDR=$Order(^DHCEQIFBList(0,"IFBBag",rowid,IFBLDR))  Quit:(IFBLDR="")  Do
	..If $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",8)="Y" Set CountWinFlag = CountWinFlag+1
	.
	.If CountWinFlag'=1 Do
	..If flag'="" Set flag=flag_"^"
	..Set flag=flag_rowid
	
	Quit flag
}

/// modified ZY0197  增加管理部门参数
/// 设备招标包查询
/// Mozy	2011-2-11
/// d ##class(%ResultSet).RunQuery("web.DHCEQIFB","IFBBag","","124578","","","03/12/2018","06/12/2018","","")
/// modified by czf 414636
Query IFBBag(PrjName As %String = "", No As %String = "", Status As %String = "", ModeDR As %String = "", StartDate As %String = "", EndDate As %String = "", Name As %String = "", VendorDR As %String = "", ManageLocDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TIFBDR:%String,TPrjName:%String,TPrjIntro:%String,TNo:%String,TModeDR:%String,TMode:%String,TTenderee:%String,TConPerson:%String,TBuyFilePrice:%String,TDeposit:%String,TReservePrice:%String,TSubmissionPlace:%String,TOpenDate:%String,TOpenTime:%String,TOpenPlace:%String,TDeterminationDate:%String,TManageLocDR:%String,TManageLoc:%String,TBuyTypeDR:%String,TBuyType:%String,TStatus:%String,TCurrencyDR:%String,TCurrency:%String,TBagNo:%String,TItemDR:%String,TName:%String,TUnitDR:%String,TUnit:%String,TQuantity:%String,TManuFactoryDR:%String,TManuFactory:%String,TModelDR:%String,TModel:%String,TArg:%String,TExtendType:%String,TExtendID:%String,TWinPrice:%String,TRemark:%String,TVendorDR:%String,TVendor:%String,TAddDate:%String,TRow:%String")
{
}

ClassMethod IFBBagExecute(ByRef qHandle As %Binary, PrjName As %String = "", No As %String = "", Status As %String = "", ModeDR As %String = "", StartDate As %String = "", EndDate As %String = "", Name As %String = "", VendorDR As %String = "", ManageLocDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=1
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	//hisui改造 add by wy 2018-12-6
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	Set rowid=0
	For  Set rowid=$Order(^DHCEQIFBBag(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesIFBBag
	.Set TRowID = rowid
	.Set TIFBDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",1)
	.Quit:TIFBDR=""
	.Set TPrjName=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",1)
	.Quit:(PrjName'="")&&(TPrjName'[PrjName)
	.Set TPrjIntro=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",2)
	.Set TNo=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",3)
	.Quit:(No'="")&&(TNo'[No)
	.Set TModeDR=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",4)	;招标方式
	.Quit:(ModeDR'="")&&(ModeDR'=TModeDR)
	.If TModeDR'="" Set TMode=$Piece($Get(^DHCEQCCode("DHCEQCIFBMode",TModeDR)),"^",2)
	.Set TTenderee=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",5)
	.Set TTendereeAddress=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",6)
	.Set TConPerson=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",7)
	.Set TBuyFilePrice=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",10)
	.Set TDeposit=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",16)
	.Set TReservePrice=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",23)
	.Set TSubmissionPlace=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",27)
	.Set TOpenDate=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",28)
	.If TOpenDate'="" Set TOpenDate=##class(web.DHCEQCommon).TransValueToPage(TOpenDate,"date")
	.Set TOpenTime=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",29)
	.If TOpenTime'="" Set TOpenTime=$ZTIME(TOpenTime)
	.Set TOpenPlace=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",30)
	.Set TDeterminationDate=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",32)
	.If TDeterminationDate'="" Set TDeterminationDate=##class(web.DHCEQCommon).TransValueToPage(TDeterminationDate,"date")
	.Set TManageLocDR=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",34)
	.Quit:(ManageLocDR'="")&&(ManageLocDR'=TManageLocDR)  //add by zy0197
	.q:(TManageLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TManageLocDR)))	//czf 2021-09-02
	.If TManageLocDR'="" Set TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.Set TBuyTypeDR=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",35)
	.If TBuyTypeDR'="" Set TBuyType=$Piece($Get(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	.Set TStatus=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",43)
	.Quit:(Status'="")&&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQIFB).GetIFBStatus(TStatus)
	.Set TCurrencyDR=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",58)
	.If TCurrencyDR'="" Set TCurrency=$Piece($Get(^DHCEQCCode("DHCEQCCurrency",TCurrencyDR)),"^",2)
	.Set TAddDate=$Piece($Get(^DHCEQIFB(TIFBDR)),"^",38)
	.Quit:(TAddDate>EndDate)||(TAddDate<StartDate)
	.If TAddDate'="" Set TAddDate=##class(web.DHCEQCommon).TransValueToPage(TAddDate,"date")
	.
	.Set TBagNo=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",2)
	.Set TItemDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",3)
	.If TItemDR'="" Set TName=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
	.Quit:(Name'="")&&(TName'[Name)
	.Set TUnitDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",4)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.Set TQuantity=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",5)
	.Set TManuFactoryDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",6)
	.If TManuFactoryDR'="" Set TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //modified by CZF0093
	.Set TModelDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",7)
	.If TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Set TArg=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",8)
	.Set TExtendTypeDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",9)
	.If TExtendTypeDR'="" Set TExtendType=##class(web.DHCEQIFB).GetIFBExtendType(TExtendTypeDR)
	.Set TExtendID=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",10)
	.Set TWinPrice=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",11)
	.Set TRemark=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",12)
	.;中标供应商 通过招标明细ID过滤中标供应商 modified by wy 2018-12-6
	.Set IFBLDR=0
	.For  Set IFBLDR=$Order(^DHCEQIFBList(0,"Source","3",TRowID,IFBLDR))  Quit:IFBLDR=""  Do	//modified by csj 2020-05-25 需求号：1331982
	..Set THold1 = $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",29)    //
	..q:(THold1'="")&&(THold1'[TRowID)
	..Set WinFlag = $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",14)
	..Quit:WinFlag'="Y"
	..Set TVendorDR=$Piece($Get(^DHCEQIFBList(IFBLDR)),"^",4)
	..Quit:(VendorDR'="")&&(TVendorDR'=VendorDR)
	..If TVendorDR'="" Do
	...Set TVendor = $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",3)
	..;modified by wy 2019-07-22 设备招标包
	..Do OutputRowIFBBag
	Quit $$$OK
OutputRowIFBBag
	Set Data=$lb(TRowID,TIFBDR,TPrjName,TPrjIntro,TNo,TModeDR,TMode,TTenderee,TConPerson,TBuyFilePrice,TDeposit,TReservePrice,TSubmissionPlace,TOpenDate,TOpenTime,TOpenPlace,TDeterminationDate,TManageLocDR,TManageLoc,TBuyTypeDR,TBuyType,TStatus,TCurrencyDR,TCurrency,TBagNo,TItemDR,TName,TUnitDR,TUnit,TQuantity,TManuFactoryDR,TManuFactory,TModelDR,TModel,TArg,TExtendType,TExtendID,TWinPrice,TRemark,TVendorDR,TVendor,TAddDate,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesIFBBag
	Set (TRowID,TIFBDR,TPrjName,TPrjIntro,TNo,TModeDR,TMode,TTenderee,TConPerson,TBuyFilePrice,TDeposit,TReservePrice,TSubmissionPlace,TOpenDate,TOpenTime,TOpenPlace,TDeterminationDate,TManageLocDR,TManageLoc,TBuyTypeDR,TBuyType,TStatus,TCurrencyDR,TCurrency,TBagNo,TItemDR,TName,TUnitDR,TUnit,TQuantity,TManuFactoryDR,TManuFactory,TModelDR,TModel,TArg,TExtendType,TExtendID,TWinPrice,TRemark,TVendorDR,TVendor,TAddDate)=""
	Quit
}

ClassMethod IFBBagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBBagExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod IFBBagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBBagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
