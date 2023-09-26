Import SQLUser

/// Modified By HZY 2012-05-04 HZY0032
/// 修改函数:CreatePlan()
/// 描述:把自动提交计划时调用的函数由##class(web.DHCEQBuyPlan).UpdateData()改为##Class(web.DHCEQBuyPlanNew).SubmitData()
/// -------------------------------------------------------
/// Modified By HZY 2011-07-14
/// 修改函数：GetBuyRequest 、 GetBuyRequestExecute
/// 描述：Bug号：HZY0001  --增加参数 RequestNO ，以实现在设备采购申请菜单下按申请单号查询的功能。
/// 新增人： Mozy 2011-02-14
/// 描述:设备新采购申请
/// -------------------------------------------------------
/// modified by GR 2014-09-15 判断审批数量过程从web中提前到js中 缺陷号3118，3211，3215 3194
/// 修改位置：AuditData() 注释掉部分内容
/// ----------------------------------------------------------------
/// modified by GR 2014-09-30  
/// 缺陷号3415 设备采购计划-日常采购计划-在采购申请时,【审核数量】不等于【申请数量】的记录,【计划数量】与【计划总价】不对应
/// 修改位置：CreatePlan
/// 修改sql语句BPL_TotalFee字段的获取方式
/// ----------------------------------------------------------------------------
Class web.DHCEQBuyRequestNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:Mozy 2011-2-15
/// 描述:新增,更新,删除采购申请,采购明细,采购设备信息以及设备的论证信息数据记录
/// w ##class(web.DHCEQBuyRequestNew).SaveData("^wefqwefqwe^410^false^^^15/02/2011^false^^^^^^^^^^^^1^^^^false^","","0","")
ClassMethod SaveData(RequestValue As %Library.String = "", ListValue As %Library.String = "", DetailValue As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,PL,rowid,Rowid,id,No
	Set $ZT="ERRORSaveData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	;Set Hosp=%session.Get("LOGON.HOSPDESC")
 	;Set ^DHCEQTemp("jdl")="HospitalDesc:"_Hosp_",HospitalID:"_%session.Data("LOGON.HOSPID")
	Set rowid=$Piece(RequestValue,"^",1)
	If (+OperateType=1)	//删除
	{
		TStart
		//2011-10-31 DJ DJ0098
	 	&SQL(Update SQLUSER.DHC_EQBuyRequest set BR_InvalidFlag='Y',BR_CancelUser=:User,BR_CancelDate=:updDate,BR_CancelTime=:updTime Where BR_RowID=:rowid)
	 	If (SQLCODE)
		{
			TROLLBACK
			Quit rowid_"^"_SQLCODE
		}
	 	TCOMMIT
	 	Quit rowid_"^"_SQLCODE
 	}
 	
 	i rowid'=""  //2011-10-31 DJ DJ0098
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQBuyRequest(rowid)),"^",45)
	 	i InvalidFlag="Y" q "^无效单据"
 	}
	
 	If (+OperateType=0) //新增,更新
 	{
	 	// 采购申请
	 	Set BRRowID=rowid
	 	Set LIST(2)=$Piece(RequestValue,"^",2)	//	BR_PrjName
		Set LIST(3)=$Piece(RequestValue,"^",3)	//	BR_RequestLocDR
		Set LIST(4)=$Piece(RequestValue,"^",4)	//	BR_YearFlag
		If LIST(4)'="" Set LIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(RequestValue,"^",4),"bool")
		Set LIST(5)=$Piece(RequestValue,"^",5)	//	BR_UseLocDR
		Set LIST(6)=$Piece(RequestValue,"^",6)	//	BR_Year
		Set LIST(7)=$Piece(RequestValue,"^",7)	//	BR_RequestDate
		If LIST(7)'="" Set LIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(RequestValue,"^",7),"date")
		//Set LIST(8)=$Piece(RequestValue,"^",8)	//	BR_GatherFlag
		//If LIST(8)'="" Set LIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(RequestValue,"^",8),"bool")
		Set LIST(9)=$Piece(RequestValue,"^",9)		//	BR_QuantityNum
		Set LIST(10)=$Piece(RequestValue,"^",10)	//	BR_TotalFee
		Set LIST(18)=$Piece(RequestValue,"^",11)	//	BR_Hold1
		Set LIST(19)=$Piece(RequestValue,"^",12)	//	BR_Hold2
		Set LIST(20)=$Piece(RequestValue,"^",13)	//	BR_Hold3
		Set LIST(21)=$Piece(RequestValue,"^",14)	//	BR_Hold4
		Set LIST(22)=$Piece(RequestValue,"^",15)	//	BR_Hold5
		Set LIST(23)=$Piece(RequestValue,"^",16)	//	BR_Hold6
		Set LIST(24)=$Piece(RequestValue,"^",17)	//	BR_Hold7
		Set LIST(25)=$Piece(RequestValue,"^",18)	//	BR_Hold8
		Set LIST(26)=$Piece(RequestValue,"^",19)	//	BR_EquipTypeDR
		Set LIST(27)=$Piece(RequestValue,"^",20)	//	BR_PurchaseTypeDR
		Set LIST(28)=$Piece(RequestValue,"^",21)	//	BR_Remark
		Set LIST(35)=$Piece(RequestValue,"^",22)	//	BR_LocOpinion
		Set LIST(36)=$Piece(RequestValue,"^",23)	//	BR_RequestNo
		Set LIST(37)=$Piece(RequestValue,"^",24)	//	BR_UrgencyFlag
		If LIST(37)'="" Set LIST(37) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(RequestValue,"^",24),"bool")
		Set LIST(42)=$Piece(RequestValue,"^",25)	//	BR_PurposeTypeDR
		Set LIST(29)=$Piece(RequestValue,"^",26)	//  BR_AddUserDR  //2011-10-26 DJ DJ0097
		Set LIST(46)="N" //InvalidFlag //2011-10-31 DJ DJ0098
		Set LIST(38)=$Piece(RequestValue,"^",27)	// 	BR_RejectReason //2013-06-24 DJ0118
		// 采购明细
		Set PLIST(3)=$Piece(ListValue,"^",22)	//	BRL_Name //2013-11-11  Mozy0112
		Set PLIST(4)=$Piece(ListValue,"^",2)	//	BRL_ModelDR
		Set PLIST(5)=$Piece(ListValue,"^",3)	//	BRL_ManuFacDR
		Set PLIST(6)=$Piece(ListValue,"^",4)	//	BRL_TestFlag
		If PLIST(6)'="" Set PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(ListValue,"^",4),"bool")
		Set PLIST(7)=$Piece(ListValue,"^",5)	//	BRL_PriceFee
		Set PLIST(8)=$Piece(ListValue,"^",6)	//	BRL_QuantityNum
		Set PLIST(9)=$Piece(ListValue,"^",7)	//	BRL_TotalFee
		Set PLIST(10)=$Piece(ListValue,"^",8) 	//	BRL_Remark
		Set PLIST(11)=User		//	BRL_UpdateUserDR
		Set PLIST(12)=updDate	//	BRL_UpdateDate
		Set PLIST(13)=updTime	//	BRL_UpdateTime
		Set PLIST(14)=$Piece(ListValue,"^",9)	//	BRL_BuyPlanDR
		Set PLIST(15)=$Piece(ListValue,"^",10)	//	BRL_CurrencyDR
		Set PLIST(16)=$Piece(ListValue,"^",11)	//	BRL_EquipCatDR
		Set PLIST(17)=$Piece(ListValue,"^",12)	//	
		Set PLIST(18)=$Piece(ListValue,"^",13)	//	BRL_ItemDR
		Set PLIST(19)=$Piece(ListValue,"^",14)	//	BRL_RequestReason
		Set PLIST(20)=$Piece(ListValue,"^",15)	//	BRL_ArriveDate
		If PLIST(20)'="" Set PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(ListValue,"^",15),"date")
		Set PLIST(21)=$Piece(ListValue,"^",16)	//	BRL_RequestNum	2013-11-01 DJ begin
		Set PLIST(28)=$Piece(ListValue,"^",17)	//	BRL_Hold1
		Set PLIST(29)=$Piece(ListValue,"^",18)	//	BRL_Hold2
		Set PLIST(30)=$Piece(ListValue,"^",19)	//	BRL_Hold3
		Set PLIST(31)=$Piece(ListValue,"^",20)	//	BRL_Hold4
		Set PLIST(32)=$Piece(ListValue,"^",21)	//	BRL_Hold5	2013-11-01 DJ end
		
		// 采购申请设备详细信息
		///	Mozy0045	2011-3-11
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDMaterial")=1 Set PL(3) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDMaterial")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDOperatorCount")=1 Set PL(4) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDOperatorCount")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDMedicalItem")=1 Set PL(5) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDMedicalItem")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDConsumption")=1 Set PL(6) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDConsumption")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDYearRunTime")=1 Set PL(7) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDYearRunTime")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDRatingPower")=1 Set PL(8) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDRatingPower")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDCountInLoc")=1 Set PL(9) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDCountInLoc")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDDepreLimitYear")=1 Set PL(10) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDDepreLimitYear")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDFeeOfEmployee")=1 Set PL(11) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDFeeOfEmployee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDFeeOfDepre")=1 Set PL(12) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDFeeOfDepre")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDFeeOfMaterial")=1 Set PL(13) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDFeeOfMaterial")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUsePerWeekNum")=1 Set PL(14) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUsePerWeekNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDWorkLoadPerWeekNum")=1 Set PL(15) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDWorkLoadPerWeekNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUsePriceFee")=1 Set PL(16) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUsePriceFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUseYearsNum")=1 Set PL(17) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUseYearsNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDReclaimYearsNum")=1 Set PL(18) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDReclaimYearsNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDCountNum")=1 Set PL(19) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDCountNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUseRate")=1 Set PL(20) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUseRate")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDGoodRate")=1 Set PL(21) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDGoodRate")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDYearIncomeFee")=1 Set PL(22) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDYearIncomeFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDCostFee")=1 Set PL(23) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDCostFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDYearMaintFee")=1 Set PL(24) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDYearMaintFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDAdviseModel")=1 Set PL(25) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDAdviseModel")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold1")=1 Set PL(26) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold1")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold2")=1 Set PL(27) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold2")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold3")=1 Set PL(28) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold3")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold4")=1 Set PL(29) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold4")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold5")=1 Set PL(30) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold5")
		
		TStart
	 	If (rowid="")  //新增按钮操作
	 	{
		 	Set LIST(17)=	0		// BR_Status
		 	//Set LIST(29)=	User	// BR_AddUserDR
			Set LIST(30)=	updDate	// BR_AddDate
			Set LIST(31)=	updTime	// BR_AddTime
		 	If LIST(36)="" Set LIST(36)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyRequest",updDate)
		 	&SQL(Insert Into SQLUSER.DHC_EQBuyRequest Values :LIST())
		 	Set rowid=$Get(%ROWID)
		 	If SQLCODE
			{
				TROLLBACK
				Quit rowid_"^"_SQLCODE
			}
		 	Set BRRowID=rowid
		 	Set PLIST(2)=BRRowID	//	BRL_BuyRequestDR
		 	&SQL(Insert Into SQLUSER.DHC_EQBuyRequestList Values :PLIST())
		 	Set BRLRowID=$Get(%ROWID)
		 	If SQLCODE
			{
				TROLLBACK
				Quit rowid_"^"_SQLCODE
			}
		 	Set PL(2)=BRLRowID		//	BRL_BuyRequestListDR
		 	&SQL(Insert Into SQLUSER.DHC_EQBuyRequestDetail Values :PL())
	 	}
	 	Else  //更新按钮操作
	 	{
		 	Set LIST(32)=	User	// BR_UpdateUserDR
			Set LIST(33)=	updDate	// BR_UpdateDate
			Set LIST(34)=	updTime	// BR_UpdateTime
			&SQL(Update SQLUSER.DHC_EQBuyRequest Values :LIST() where BR_RowID = :BRRowID)
			If SQLCODE
			{
				TROLLBACK
				Quit rowid_"^"_SQLCODE
			}
			&SQL(Update SQLUSER.DHC_EQBuyRequestList Values :PLIST() where BRL_BuyRequestDR = :BRRowID)
			If SQLCODE
			{
				TROLLBACK
				Quit rowid_"^"_SQLCODE
			}
			Set BRLRowID=$Get(%ROWID)
			&SQL(Update SQLUSER.DHC_EQBuyRequestDetail Values :PL() where BRD_BuyRequestListDR = :BRLRowID)
	 	}
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

/// Mozy0041	2011-2-15
/// w ##class(web.DHCEQBuyRequestNew).GetOneBuyRequest("","",3)
ClassMethod GetOneBuyRequest(itms As %Library.String = "", itmsex As %Library.String = "", rowid, CurRole As %Library.String = "")
{
	new result,resultex,id,AppInfo,Opinion,role,flag,AIRowID,Request,List,Detail,Argumentation
	Set (result,resultex,id,AppInfo,Opinion,role)=""
	// DHC_EQBuyRequest		采购申请	41
	Set result= ^DHCEQBuyRequest(rowid)
	Set resultex=resultex_"^"	;RequestLocDR
	If $Piece(result,"^",2)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",2))
	Set $Piece(result,"^",3)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",3),"bool")	;YearFlag
	Set resultex=resultex_"^"	;UseLocDR
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",4))
	Set $Piece(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",6),"date")	;RequestDate
	// Set $Piece(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"bool")	;GatherFlag
	Set $Piece(result,"^",9)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",9),"")
	Set resultex=resultex_"^"	;SubmitUserDR
	If $Piece(result,"^",10)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",10))
	Set $Piece(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",11),"date")	;SubmitDate
	Set resultex=resultex_"^"	;AuditUserDR
	If $Piece(result,"^",13)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",13))
	Set $Piece(result,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",14),"date")	;AuditDate
	Set resultex=resultex_"^"	;EquipTypeDR
	If $Piece(result,"^",25)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCEquipType",$Piece(result,"^",25))),"^",2)
	Set resultex=resultex_"^"	;PurchaseTypeDR
	If $Piece(result,"^",26)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",$Piece(result,"^",26))),"^",2)
	Set resultex=resultex_"^"	;AddUserDR
	If $Piece(result,"^",28)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",28))
	Set $Piece(result,"^",29)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",29),"date")	;AddDate
	Set resultex=resultex_"^"	;UpdateUserDR
	If $Piece(result,"^",31)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",31))
	Set $Piece(result,"^",32)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",32),"date")	;UpdateDate
	Set $Piece(result,"^",36)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",36),"bool")	;UrgencyFlag
	Set resultex=resultex_"^"	;RejectUserDR
	If $Piece(result,"^",38)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",38))
	Set $Piece(result,"^",39)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",39),"date")	;RejectDate
	Set resultex=resultex_"^"	;PurposeTypeDR
	If $Piece(result,"^",41)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",$Piece(result,"^",41))),"^",2)
	
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("1",rowid)
	Set resultex=resultex_"^"_AppInfo
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	Set NextFlowStep=+$Piece(AppInfo,"^",4)
	Set ApproveRole=+$Piece(AppInfo,"^",6)
	Set Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(ApproveType, rowid)
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Set Request=result_resultex_"^"_Opinion
	
	Set List=##class(web.DHCEQBuyRequestNew).GetOneBuyRequestList(rowid)
	Set Detail=##class(web.DHCEQBuyRequestNew).GetOneBuyRequestDetail($Piece(List,"^",1))
	Set Argumentation=##class(web.DHCEQBuyRequestNew).GetOneArgumentation($Piece(List,"^",1))
	
	Quit Request_"@"_List_"@"_Detail_"@"_Argumentation
}

ClassMethod GetOneBuyRequestList(BRRowID)
{
	new result,resultex,BRLRowID
	Set (result,resultex,BRLRowID)=""
	// DHC_EQBuyRequestList		申请明细设备	24
	Set resultex=""
	Set BRLRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,""))
	Quit:BRLRowID="" ""
	Set result= ^DHCEQBuyRequestList(BRLRowID)
	Set resultex=resultex_"^"	;ModelDR
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("model",$Piece(result,"^",3))
	Set resultex=resultex_"^"	;ManuFacDR
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",$Piece(result,"^",4))),"^",1)
	Set $Piece(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",5),"bool")	;TestFlag
	Set $Piece(result,"^",6)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",6),"")
	Set $Piece(result,"^",8)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",8),"")
	Set resultex=resultex_"^"	;UpdateUserDR
	If $Piece(result,"^",10)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",10))
	Set $Piece(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",11),"date")	;AddDate
	Set resultex=resultex_"^"	;BuyPlanDR
	If $Piece(result,"^",13)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQBuyPlan($Piece(result,"^",13))),"^",1)
	Set resultex=resultex_"^"	;CurrencyDR
	If $Piece(result,"^",14)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCCurrency",$Piece(result,"^",14))),"^",2)
	Set resultex=resultex_"^"	;EquipCatDR
	If $Piece(result,"^",15)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$Piece(result,"^",15))
	Set $Piece(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",19),"date")	;ArriveDate
	Set resultex=resultex_"^"	;StatCatDR
	If $Piece(result,"^",17)'=""  Do
	.Set StatCatDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",$Piece(result,"^",17))),"^",5)
	.If StatCatDR'=""  Do
	..Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	Set resultex=resultex_"^"	;UnitDR
	If $Piece(result,"^",17)'=""  Do
	.Set UnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",$Piece(result,"^",17))),"^",7)
	.If UnitDR'=""  Do
	..Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	Set resultex=resultex_"^"	;ItemName 2013-06-24 DJ0118
	If $Piece(result,"^",17)'=""  Do
	.Set resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$Piece(result,"^",17))),"^",1)
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit BRLRowID_"^"_result_resultex
}

ClassMethod GetOneBuyRequestDetail(BRLRowID)
{
	new result,resultex,BRDRowID
	Set (result,resultex,BRDRowID)=""
	// DHC_EQBuyRequestDetail		采购申请设备详细信息	29
	Set resultex=""
	Set BRDRowID=$Order(^DHCEQBuyRequestDetail(0,"BuyRequestList",BRLRowID,""))
	Quit:BRDRowID="" ""
	Set result=^DHCEQBuyRequestDetail(BRDRowID)
	Set $Piece(result,"^",2)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",2),"")		//Add By DJ 2015-08-21 DJ0157
	Set $Piece(result,"^",10)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",10),"")
	Set $Piece(result,"^",11)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",11),"")
	Set $Piece(result,"^",12)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",12),"")
	Set $Piece(result,"^",15)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",15),"")
	Set $Piece(result,"^",17)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",17),"")	//Add By DJ 2015-08-21 DJ0157
	Set $Piece(result,"^",21)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",21),"")
	Set $Piece(result,"^",22)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",22),"")
	Set $Piece(result,"^",23)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",23),"")
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit BRDRowID_"^"_result_resultex
}

ClassMethod GetOneArgumentation(BRLRowID)
{
	new result,resultex,ARRowID
	Set (result,resultex,ARRowID)=""
	// DHC_EQArgumentation			设备论证		35
	Set resultex=""
	Set ARRowID=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLRowID,""))
	Quit:ARRowID="" ""
	Set result=^DHCEQArgumentation(ARRowID)
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit ARRowID_"^"_result_resultex
}

ClassMethod IsVaildYear(Str As %Library.String = "")
{
	If ('(Str?4N)) Quit 1
	If (+Str > 2100) Quit 1
	If (+Str < 1900) Quit 1
	Quit 0
}

/// Mozy0041	2011-2-18
/// w ##class(web.DHCEQBuyRequestNew).GetOneArgumentationData(5)
ClassMethod GetOneArgumentationData(BRLDR)
{
	new result,resultex,rowid
	Set (result,resultex,rowid)=""
	Set rowid=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLDR,""))
	Quit:rowid="" "@"_##class(web.DHCEQBuyRequestNew).GetOneBuyRequestDetail(BRLDR)
	Set result=^DHCEQArgumentation(rowid)
	Set resultex=resultex_"^"		;RejectUserDR
	If $Piece(result,"^",9)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",9))
	Set $Piece(result,"^",10)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",10),"date")	;RejectUserDate
	Set resultex=resultex_"^"		;AddUserDR
	If $Piece(result,"^",14)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",14))
	Set $Piece(result,"^",15)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",15),"date")	;AddDate
	Set resultex=resultex_"^"		;SubmitUserDR
	If $Piece(result,"^",17)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",17))
	Set $Piece(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",18),"date")	;SubmitDate
	Set resultex=resultex_"^"		;AuditUserDR
	If $Piece(result,"^",20)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",20))
	Set $Piece(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",21),"date")	;AuditDate
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit rowid_"^"_result_resultex_"@"_##class(web.DHCEQBuyRequestNew).GetOneBuyRequestDetail(BRLDR)
}

/// Mozy0041	2011-2-18
/// 描述:更新及删除论证信息
/// w ##Class(web.DHCEQBuyRequestNew).UpdateData("^2^^^^^^^^^^^^^^111^222^^^^^",0)
ClassMethod UpdateData(val As %Library.String = "", DetailValue As %Library.String = "", AppType As %Library.String = "")
{
	new User,Date,Time,BRLRowID,BRRowID,EquipType,PurchaseType
	new YearFlag,MaxPrice,EquipCat,SpecialType
	Kill PLIST, LIST, BRDRowID
	Set ARRowID=$Piece(val,"^",1)
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	If +AppType=1	//删除
	{
	 	&SQL(delete from sqluser.DHC_EQArgumentation where AR_RowID=:ARRowID)
	 	Quit SQLCODE
	}
	If +AppType=0	 //新增,更新
	{
		Set PLIST(2)=$Piece(val,"^",2)	//	BuyRequestListDR
		Set PLIST(3)=$Piece(val,"^",3)	//	ProductIntroduce
		Set PLIST(4)=$Piece(val,"^",4)	//	Actuality
		Set PLIST(5)=$Piece(val,"^",5)	//	BuyReason
		Set PLIST(6)=$Piece(val,"^",6)	//	AffectAnalyse
		Set PLIST(7)=$Piece(val,"^",7)	//	Condition
		Set PLIST(8)=$Piece(val,"^",8)	//	Service
		Set PLIST(13)=$Piece(val,"^",9)	//	Remark
		Set PLIST(24)=$Piece(val,"^",10)	//	ClinicEffect
		Set PLIST(25)=$Piece(val,"^",11)	//	SettleState
		Set PLIST(26)=$Piece(val,"^",12)	//	ResourceState
		Set PLIST(27)=$Piece(val,"^",13)	//	PolluteState
		Set PLIST(28)=$Piece(val,"^",14)	//	OtherState
		Set PLIST(29)=$Piece(val,"^",15)	//	PersonnelState
		Set PLIST(30)=$Piece(val,"^",16)	//	Income
		Set PLIST(31)=$Piece(val,"^",17)	//	Effect
		Set PLIST(32)=$Piece(val,"^",18)	//	Hold1
		Set PLIST(33)=$Piece(val,"^",19)	//	Hold2
		Set PLIST(34)=$Piece(val,"^",20)	//	Hold3
		Set PLIST(35)=$Piece(val,"^",21)	//	Hold4
		Set PLIST(36)=$Piece(val,"^",22)	//	Hold5
		/// Mozy0045	2011-3-11
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDRowID")=1 Set BRDRowID = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDRowID")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRLRowID")=1 Set LIST(2) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRLRowID")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDMaterial")=1 Set LIST(3) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDMaterial")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDOperatorCount")=1 Set LIST(4) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDOperatorCount")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDMedicalItem")=1 Set LIST(5) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDMedicalItem")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDConsumption")=1 Set LIST(6) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDConsumption")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDYearRunTime")=1 Set LIST(7) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDYearRunTime")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDRatingPower")=1 Set LIST(8) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDRatingPower")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDCountInLoc")=1 Set LIST(9) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDCountInLoc")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDDepreLimitYear")=1 Set LIST(10) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDDepreLimitYear")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDFeeOfEmployee")=1 Set LIST(11) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDFeeOfEmployee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDFeeOfDepre")=1 Set LIST(12) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDFeeOfDepre")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDFeeOfMaterial")=1 Set LIST(13) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDFeeOfMaterial")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUsePerWeekNum")=1 Set LIST(14) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUsePerWeekNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDWorkLoadPerWeekNum")=1 Set LIST(15) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDWorkLoadPerWeekNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUsePriceFee")=1 Set LIST(16) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUsePriceFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUseYearsNum")=1 Set LIST(17) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUseYearsNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDReclaimYearsNum")=1 Set LIST(18) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDReclaimYearsNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDCountNum")=1 Set LIST(19) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDCountNum")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDUseRate")=1 Set LIST(20) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDUseRate")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDGoodRate")=1 Set LIST(21) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDGoodRate")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDYearIncomeFee")=1 Set LIST(22) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDYearIncomeFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDCostFee")=1 Set LIST(23) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDCostFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDYearMaintFee")=1 Set LIST(24) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDYearMaintFee")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDAdviseModel")=1 Set LIST(25) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDAdviseModel")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold1")=1 Set LIST(26) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold1")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold2")=1 Set LIST(27) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold2")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold3")=1 Set LIST(28) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold3")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold4")=1 Set LIST(29) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold4")
		If ##Class(web.DHCEQCommon).ExistsElement(DetailValue,"BRDHold5")=1 Set LIST(30) = ##Class(web.DHCEQCommon).GetDataByName(DetailValue,"BRDHold5")
		TStart
 		If BRDRowID=""
 		{
	 		&SQL(insert into sqluser.DHC_EQBuyRequestDetail values :LIST())
 		}
 		Else
 		{
	 		&SQL(update sqluser.DHC_EQBuyRequestDetail values :LIST() where BRD_RowID=:BRDRowID)
 		}
 		If SQLCODE=100 Set SQLCODE=0
 		If SQLCODE
		{
			TROLLBACK
			Quit "^"_SQLCODE
		}
 		If ARRowID=""
 		{
	 		Set PLIST(14)=	0		//	Status
			Set PLIST(15)=	User	//	AddUserDR
			Set PLIST(16)=	Date	//	AddDate
			Set PLIST(17)=	Time	//	AddTime
			
	 		&SQL(insert into sqluser.DHC_EQArgumentation values :PLIST())
 			Set ARRowID=$Get(%ROWID)
 		}
 		Else
 		{
	 		&SQL(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:ARRowID)
 		}
 		If SQLCODE
		{
			TROLLBACK
			Quit ARRowID_"^"_SQLCODE
		}
	 	
	 	TCOMMIT
 		Quit ARRowID
	}
}

/// 创建:Mozy 2011-2-18
/// 描述:提交
/// w ##Class(web.DHCEQBuyRequestNew).SubmitData("2^1^")
ClassMethod SubmitData(val)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQBuyRequest(RowID)),"^",16)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	
	s InvalidFlag=$Piece($G(^DHCEQBuyRequest(RowID)),"^",45) //2011-10-31 DJ DJ0098
	if InvalidFlag="Y" q -1015  //2011-10-31 DJ DJ0098
	
	s LimitTotalFee=##class(web.DHCEQCommon).GetSysInfo("101005") //2014-9-17 HZY0065
	
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
 	Set EquipType=$Piece(^DHCEQBuyRequest(RowID),"^",25)
	Set PurchaseType=$Piece(^DHCEQBuyRequest(RowID),"^",26)
	Set YearFlag=$Piece(^DHCEQBuyRequest(RowID),"^",3)
	Set MaxPrice=0
 	Set ListRowID=0
 	s TotalFee=0 //2014-9-17 HZY0065
 	For  Set ListRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",RowID,ListRowID))  Quit:ListRowID=""  Do
 	.If +$p(^DHCEQBuyRequestList(ListRowID),"^",6)>MaxPrice  Do
 	..Set MaxPrice=+$p(^DHCEQBuyRequestList(ListRowID),"^",6)	;BRL_PriceFee
 	.s TotalFee=+$p(^DHCEQBuyRequestList(ListRowID),"^",8)+TotalFee //2014-9-17 HZY0065
 	i ((YearFlag'="Y")&&(TotalFee>LimitTotalFee))  q -1004  //总金额大于日常限制的金额! 2014-9-17 HZY0065
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, "", MaxPrice, YearFlag, "")
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="") 
	{
		Set AuditFlag=1
	    Set AppInfoStatus="2"
	}
	
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"1",User)
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
	Set PLIST(17)=	1		// BR_Status
 	Set PLIST(11)=	User	// BR_SubmitUserDR
	Set PLIST(12)=	updDate	// BR_SubmitDate
	Set PLIST(13)=	updTime	// BR_SubmitTime
	If AuditFlag=1 Set PLIST(17)=	2		// BR_Status
	&SQL(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit SQLCODE
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQBuyRequestNew).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}		
	}
	;Modified by jdl 2011-3-17  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
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

/// 创建:Mozy 2011-2-18
/// 描述:取消提交
/// w ##Class(web.DHCEQIFB).CancelSubmitData("8^1^")
ClassMethod CancelSubmitData(val As %Library.String = "", CurRole)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set RejectReason=$Piece(val,"^",6)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}
	
	TSTART
	//2015-09-28 ZY0144   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("1", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,RoleStep,User,"1")
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
	Set PLIST(17)=	Status	// BR_Status
	// BR_RejectReason
	//Set PLIST(38)=	RejectReason	;_"  "_##class(web.DHCEQCommon).GetTrakNameByID("user",User)_"  "_$ZD(updDate,3)	;取消人及取消日期
	//Set PLIST(39)=	User	// BR_RejectUserDR
	//Set PLIST(40)=	updDate	// BR_RejectDate
	//Set PLIST(41)=	updTime	// BR_RejectTime	
	&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&sql(Update SQLUSER.DHC_EQBuyRequestList Set BRL_QuantityNum = NULL where BRL_BuyRequestDR=:RowID)	//add by csj 20190906 取消提交后将审批数量置空
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
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow, "Y",CurRole)
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

/// 创建:Mozy 2011-2-18
/// 描述:审核
/// w ##Class(web.DHCEQBuyRequestNew).AuditData("1^1^126","10","3","")
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "", BatchOperFlag As %String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQBuyRequest(RowID)),"^",16)
	if Status'="1" q -2015   //该记录状态不符合,不能执行操作!
	//批量审核时判断实际明细记录数与选择明细记录数不一致	Modify DJ 2017-07-21 DJ0191
	i BatchOperFlag="Y"
	{
		&SQL(Select Count(*) Into :BRLRowCount From SQLUSER.DHC_EQBuyRequestList Where BRL_BuyRequestDR=:RowID)		//Modify DJ 2015-09-07 DJ0160
		s CheckCount=$L(editFieldsInfo,"@")
		if (CheckCount'=BRLRowCount)	q -2016		//实际明细记录数与选择明细记录数不一致
	}
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set Opinion=$Piece(val,"^",4)
	Set Remark=$Piece(val,"^",5)
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("1", RowID)	
	If ApproveSet="" Quit -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		
		Set PLIST(14)=	User	// BR_AuditUserDR
		Set PLIST(15)=	updDate	// BR_AuditDate
		Set PLIST(16)=	updTime	// BR_AuditTime
		Set PLIST(17)=	2		// BR_Status
		&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
		If SQLCODE
		{
		 	TROLLBACK
			Quit SQLCODE
		}
		Set AppInfoStatus="2"
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep)
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
		/*modified by GR 2014-09-15 begin  判断审批数量过程从web中提前到js中 缺陷号3118，3211，3215 
		//判断审批数量是否有效	2013-11-11  Mozy0112
		Set BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",RowID,0))
		If BRLRowID'=""
		{
			s BRLQuantityNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",7)
			i +BRLQuantityNum<=0
			{
				TROLLBACK
				Quit -1002
			}
		}*/
		Set SQLCODE=##Class(web.DHCEQBuyRequestNew).LastAuditAction(RowID)
		If SQLCODE<0	//Modified By HZY 2012-04-25
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	;Modified by jdl 2011-3-17  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
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
/// 	在此处,需调用
/// w ##Class(web.DHCEQBuyRequestNew).LastAuditAction(5)
/// ----------------------------------
ClassMethod LastAuditAction(RowID)
{
	// 采购申请审核后是否自动生成计划
	Set CreatePlanFlag=##class(web.DHCEQCommon).GetSysInfo("101002")
	If (CreatePlanFlag="1")		;&&(PLIST(17)="2")&&(YearFlag="N")
	{
		Set SQLCODE=##Class(web.DHCEQBuyRequestNew).CreatePlan(RowID_"^"_User,"N")
	}
	
	;&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	Quit SQLCODE
}

/// ReplacesAD, QXType, ApproveRole, WaitAD, Type, RequestLocDR, YearFlag, StartDate, EndDate, StatusDR
/// d ##class(%ResultSet).RunQuery("web.DHCEQBuyRequestNew","GetBuyRequest","","18","on","2","","","62145","1")
Query GetBuyRequest(QXType As %Library.String = "", ApproveRole As %Library.String = "", WaitAD As %Library.String = "", Type As %Library.String = "", RequestLocDR As %Library.String = "", YearFlag As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", StatusDR As %Library.String = "", RequestNo As %Library.String = "", InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRowID:%String,TPrjName:%String,TRequestLocDR:%String,TYearFlag:%String,TUseLocDR:%String,TYear:%String,TRequestDate:%String,TGatherFlag:%String,TQuantityNum:%String,TTotalFee:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,THold6:%String,THold7:%String,THold8:%String,TEquipTypeDR:%String,TPurchaseTypeDR:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TLocOpinion:%String,TRequestNo:%String,TUrgencyFlag:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TRequestLoc:%String,TUseLoc:%String,TSubmitUser:%String,TAuditUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TEquipType:%String,TPurchaseType:%String,TAddUser:%String,TUpdateUser:%String,TRejectUser:%String,TPurposeTypeDR:%String,TPurposeType:%String,TRow:%String,TAduitNum:%String,TProcess:%String")
{
}

ClassMethod GetBuyRequestExecute(ByRef qHandle As %Binary, QXType, ApproveRole, WaitAD, Type, RequestLocDR, YearFlag, StartDate, EndDate, StatusDR, RequestNo, InvalidFlag As %String = "N") As %Status
{
 	new repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	///modified by zy0174  hisui改造
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	
	//2011-07-13 HZY --添加按申请单号查询功能。Bug号：HZY0001
	if RequestNo'="" do
	.Set FindRequestNo=$Order(^DHCEQBuyRequest(0,"RequestNo"," "_RequestNo),-1)
	.;Set ^DHCEQTemp("hzy")=FindRequestNo
	.For  Set FindRequestNo=$Order(^DHCEQBuyRequest(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0
	..;Set ^DHCEQTemp("h")=FindRequestNo
    ..For  Set rowid=$Order(^DHCEQBuyRequest(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
    ...//d FillDataGetBuyRequest
    ...//modified by ZY0212
	...s mxrowid=0
	...f  s mxrowid=$Order(^DHCEQBuyRequestList(0,"BuyRequest",rowid,mxrowid)) q:mxrowid=""  d
	....d FillDataGetBuyRequest
	e  do
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQBuyRequest(rowid))  Quit:rowid=""  Do
	..//modified by ZY0212
	..s mxrowid=0
	..f  s mxrowid=$Order(^DHCEQBuyRequestList(0,"BuyRequest",rowid,mxrowid))  q:mxrowid=""  d
	...d FillDataGetBuyRequest
	Quit $$$OK

	
	//Set rowid=0
	//For  Set rowid=$Order(^DHCEQBuyRequest(rowid))  Quit:rowid=""  Do
FillDataGetBuyRequest	
	Do ResetVariablesGetBuyRequest
	Set TRowID = rowid
	Set TInvalidFlag=$p($g(^DHCEQBuyRequest(rowid)),"^",45) //2011-10-31 DJ DJ0098
	Quit:(InvalidFlag'="")&&(TInvalidFlag'=InvalidFlag) //2011-10-31 DJ DJ0098
	//注释quit条件  需求号278168  modify by mwz 2016-11-10
	;Quit:(RequestLocDR="")&&(YearFlag="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")&&(WaitAD'="on")&&(RequestNo="")
	Set TPrjName = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",1)
	Set TRequestLocDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",2)
	If TRequestLocDR '=""  Do
	.Set TRequestLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLocDR)
	Quit:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
	Set TYearFlag = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",3)
	Quit:(YearFlag'="")&&(YearFlag'=TYearFlag)	//2012-02-06 DJ DJ0104
	s TYearFlag=$CASE(TYearFlag,"Y":"年度计划","N":"日常计划",:"")  //add by lmm 2020-05-18 UI调整
	Set TUseLocDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",4)
	If TUseLocDR '=""  Do
	.Set TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	Set TYear = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",5)
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	Quit:($Piece($Get(^DHCEQBuyRequest(rowid)),"^",6)>EndDate)||($Piece($Get(^DHCEQBuyRequest(rowid)),"^",6)<StartDate)
	Set TRequestDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(rowid)),"^",6),"date")
	Set TGatherFlag = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",7)
	Set TQuantityNum = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",8)
	Set TTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyRequest(rowid)),"^",9),"")
	Set TSubmitUserDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",10)
	If TSubmitUserDR '=""  Do
	.Set TSubmitUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TSubmitUserDR)
	Set TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(rowid)),"^",11),"date")
	Set TSubmitTime = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",12)
	Set TAuditUserDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",13)
	If TAuditUserDR '=""  Do
	.Set TAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
	Set TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(rowid)),"^",14),"date")
	Set TAuditTime = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",15)
	Set TStatus = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",16)
	Quit:(StatusDR'="")&&(StatusDR'=TStatus)
	Quit:((Type'="0")&&(StatusDR=""))&&(TStatus="0")
	Set TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	Set THold1 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",17)
	Set THold2 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",18)
	Set THold3 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",19)
	Set THold4 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",20)
	Set THold5 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",21)
	Set THold6 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",22)
	Set THold7 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",23)
	Set THold8 = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",24)
	Set TEquipTypeDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",25)
	Quit:((TEquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)))
	If TEquipTypeDR '=""  Do
	.Set TEquipType = $Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	Set TPurchaseTypeDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",26)
	If TPurchaseTypeDR '=""  Do
	.Set TPurchaseType = $Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	Set TRemark = $Piece($Get(^DHCEQBuyRequestList(mxrowid)),"^",9)	//modified by ZY0212
	Set TAddUserDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",28)
	If TAddUserDR '=""  Do
	.Set TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAddUserDR)
	Set TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(rowid)),"^",29),"date")
	Set TAddTime = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",30)
	Set TUpdateUserDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",31)
	If TUpdateUserDR '=""  Do
	.Set TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TUpdateUserDR)
	Set TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(rowid)),"^",32),"date")
	Set TUpdateTime = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",33)
	Set TLocOpinion = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",34)
	Set TRequestNo = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",35)
	Set TUrgencyFlag = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",36)
	Set TRejectReason = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",37)
	Set TRejectUserDR = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",38)
	If TRejectUserDR '=""  Do
	.Set TRejectUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TRejectUserDR)
	Set TRejectDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(rowid)),"^",39),"date")
	Set TRejectTime = $Piece($Get(^DHCEQBuyRequest(rowid)),"^",40)
	Set TPurposeTypeDR =$Piece($Get(^DHCEQBuyRequestList(mxrowid)),"^",23)	////modified by ZY0212
	If TPurposeTypeDR '="" Do
	.Set TPurposeType = $Piece($Get(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	Quit:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))&&("N"=..GetUserLoc(User,TRequestLocDR,TPurposeTypeDR))	;Mozy0045	2011-3-10 
	Set AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	s TProcess="无"
	If AIRowID'="" Do
	.Set CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	.Set TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	.i TApproveRole'="" s TProcess=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	If TApproveRole'="" Set TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TApproveRole)	;Mozy0047	2011-3-22
	i $Piece($Get(^DHCEQBuyRequest(rowid)),"^",16)=0 s TProcess="" //modified by czf 1214221 2020-03-05
	///modified by zy 20181102 ZY0176 菜单参数WaitAD  改为 0和1 对应界面的checked
	///add by jyp 2019-03-12
	s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",rowid,0))
	///modified by ZY0197  修改审批数量的显示逻辑
	//s TAduitNum=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",7)
	s (BRAIRowID,TAduitNum)=""
	///modified by ZY0276 20210720 变量值改变
	if ($Piece($Get(^DHCEQBuyRequest(rowid)),"^",16)>0)
	{
		s BRAIStep=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,""),-1)
		i BRAIStep'="" s BRAIRowID=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,BRAIStep,0))
		i BRAIRowID'="" d
		.s TAduitNum=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",4)
		.//s BRAIAuditPrice=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",5)
		.//s BRAITotalFee=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",6)
	}
	Quit:((WaitAD="checked")&&(CurRole'=ApproveRole))
	Do OutputRowGetBuyRequest
	Quit 
OutputRowGetBuyRequest
	Set TRow=index	// 20150914  Mozy0165 序号
	Set Data=$lb(TRowID,TPrjName,TRequestLocDR,TYearFlag,TUseLocDR,TYear,TRequestDate,TGatherFlag,TQuantityNum,TTotalFee,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,THold4,THold5,THold6,THold7,THold8,TEquipTypeDR,TPurchaseTypeDR,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TLocOpinion,TRequestNo,TUrgencyFlag,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TRequestLoc,TUseLoc,TSubmitUser,TAuditUser,TApproveSet,TNextRole,TApproveRole,TEquipType,TPurchaseType,TAddUser,TUpdateUser,TRejectUser,TPurposeTypeDR,TPurposeType,TRow,TAduitNum,TProcess)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuyRequest
	Set (TRowID,TPrjName,TRequestLocDR,TYearFlag,TUseLocDR,TYear,TRequestDate,TGatherFlag,TQuantityNum,TTotalFee,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,THold4,THold5,THold6,THold7,THold8,TEquipTypeDR,TPurchaseTypeDR,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TLocOpinion,TRequestNo,TUrgencyFlag,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TRequestLoc,TUseLoc,TSubmitUser,TAuditUser,TApproveSet,TNextRole,TApproveRole,TEquipType,TPurchaseType,TAddUser,TUpdateUser,TRejectUser,TPurposeTypeDR,TPurposeType,CurRole,TRow,BRLRowID,TAduitNum,TApproveRole,TProcess)=""
	Quit
}

ClassMethod GetBuyRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestExecute ]
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

ClassMethod GetBuyRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// N不可用  Y可用
ClassMethod GetUserLoc(UserID, LocID, PurposeTypeID)
{
	new Flag,UMLID
	i LocID="" q "Y"
	Set Flag="N"
	Set UMLID=0
	f  Set UMLID=$o(^DHCEQCCode("DHCEQCUserManagerLoc",0,"UserLoc",UserID,LocID,UMLID)) Quit:(UMLID="")||(Flag="Y")  Do
	.Set PurposeTypes=$p(^DHCEQCCode("DHCEQCUserManagerLoc",UMLID),"^",3)
	.Set Flag=..StringIsIn(PurposeTypes,PurposeTypeID)
	Quit Flag
}

/// Mozy	2011-2-25
/// Y在里面  N不在里面
ClassMethod StringIsIn(Strings, String)
{
	new i,Flag
	If Strings="" Quit "Y"
	Set If=$Length(Strings,",")
	Set Flag="N"
	for j=1:1:i
	{
		Set Str=$Piece(Strings,",",j)
		If Str=String Set Flag="Y"
		Quit:Flag="Y"
	}
	Quit Flag
}

/// Mozy	2011-2-28
/// 检查是否有需要填写论证表但没有填写,填写的论证还需已通过审核
/// ReturnValue为0不需要或者已有论证 为1没?新壑?
/// ##class(web.DHCEQCommon).GetSysInfo("101001")	;设备单价超过设定需要论证表
/// w ##Class(web.DHCEQBuyRequestNew).CheckArgumentation(14)
ClassMethod CheckArgumentation(reqid, ActionCode As %Library.String = "")
{
	New BRLID,flag,argvalue,desc
	Set ReturnValue=0
	Set flag=##class(web.DHCEQCommon).GetSysInfo("101003")	;论证是否必须	0：不限制  1：提示,  2：限制死
	Quit:flag=0 ReturnValue
	Quit:flag=2 "请填写论证信息!"	//add by csj 20190828 限制死则必填论证信息 
	Set rowid=$Order(^DHCEQCCode("DHCEQCSysSet",0,"Code","101001",0))
	If rowid="" Quit ReturnValue
	Set argvalue=$Piece($Get(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2)
	Set desc=$Piece($Get(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",3)
	Quit:argvalue="" ReturnValue
	
	///modified by zy 20181031 ZY0174  根据采购指标模版来判断采购论证是否填报.
	Set BRLID=0
	For  Set BRLID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",reqid,BRLID)) Quit:(BRLID="")||(ReturnValue=1)  Do
	.Set Price=$Piece(^DHCEQBuyRequestList(BRLID),"^",6)
	.Quit:Price<argvalue
	.Set ARID=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLID,0))
	.If ARID="" Set ReturnValue=1
	/*
	///友谊的临时采购申请不需要论证
	s YeatFlag=$Piece(^DHCEQBuyRequest(reqid),"^",3)
	Quit:YeatFlag="N" ReturnValue
	s desc=##Class(web.DHCEQTemplate).CheckTemplate(3,reqid,ActionCode)
	i desc'=0 q desc
	*/

	Quit:(ReturnValue=1)&&(flag>0) desc
	;Quit:(ReturnValue=1)&&(flag=2) desc
	Quit ReturnValue
}

/// Modified By HZY 2012-05-04 HZY0032
/// Desc:把自动提交计划时调用的函数由##class(web.DHCEQBuyPlan).UpdateData()改为##Class(web.DHCEQBuyPlanNew).SubmitData()
/// -------------------------------------------------------
/// Mozy	2011-2-28
/// 生成采购计划
/// w ##Class(web.DHCEQBuyRequestNew).CreatePlan("3^1","N")
ClassMethod CreatePlan(val, TransFlag)
{
	new PLIST,SubFlag
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set BRRowID=$Piece(val,"^",1)
	Set User=$Piece(val,"^",2)
	
	Set PLIST(2)=$Piece(^DHCEQBuyRequest(BRRowID),"^",1) 	//计划名称
	;Set PLIST(5)="由采购申请自动生成的采购计划"			// Mozy0047
	Set PLIST(6)=Date
	Set PLIST(7)="0"
	Set PLIST(13)=$Piece(^DHCEQBuyRequest(BRRowID),"^",25) 	//设备类组
	Set PLIST(29)=$Piece(^DHCEQBuyRequest(BRRowID),"^",26) 	//申购类别
	Set PLIST(34)=$Piece(^DHCEQBuyRequest(BRRowID),"^",36) 	//急购
	//modified by ZY0197 增加管理科室的条件限制
	Set PLIST(40)=$Piece(^DHCEQBuyRequest(BRRowID),"^",18) 	//管理部门
	Set PLIST(43)=$Piece(^DHCEQBuyRequest(BRRowID),"^",41) 	//设备用途
	//modified by ZY0213
	if (PLIST(43)="")
	{
		s BRLRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,""))
		i BRLRowID'="" s PLIST(43)=$Piece(^DHCEQBuyRequestList(BRLRowID),"^",22)
	}
	
	Set PLIST(20)=User
	Set PLIST(21)=Date
	Set PLIST(22)=Time
	Set PLIST(26)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyPlan",+$H) //计划单号
	Set PLIST(27)="0"
	
	;Modified By JDL JDL0119 2012-3-6
	Set PLIST(47)="N"
	
	If TransFlag'="N" TSTART
	&SQL(Insert into sqluser.DHC_EQBuyPlan values :PLIST())
	If SQLCODE
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	Set BPRowID=$Get(%ROWID)
	&sql(Insert Into SQLUser.DHC_EQBuyPlanList (BPL_ItemDR,BPL_BuyPlanDR,BPL_Name,BPL_ModelDR,BPL_ManuFacDR,BPL_TestFlag,BPL_PriceFee,BPL_QuantityNum,BPL_TotalFee,BPL_BuyRequestListDR,BPL_UpdateUserDR,BPL_UpdateDate,BPL_UpdateTime,BPL_CurrencyDR,BPL_EquipCatDR,BPL_Hold3,BPL_RefuseFlag,BPL_ArriveDate) 
	     select BRL_ItemDR,:BPRowID,BRL_Name,BRL_ModelDR, BRL_ManuFacDR,BRL_TestFlag ,BRL_PriceFee,BRL_QuantityNum,BRL_PriceFee*BRL_QuantityNum,BRL_RowID,:User,:Date,:Time,BRL_CurrencyDR,BRL_EquipCatDR,BRL_Hold2,'N',BRL_ArriveDate from SQLUser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:BRRowID and (BRL_BuyPlanDR is null or {fn LENGTH(BRL_BuyPlanDR)}=0)) 
	     		//modified by GR 2014-09-30 修改sql语句BPL_TotalFee字段的获取方式 缺陷号3415
	
	If SQLCODE'=0
	{
		If TransFlag'="N" TROLLBACK
		If SQLCODE=100 Set SQLCODE=-100
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR=:BPRowID where BRL_BuyRequestDR=:BRRowID and (BRL_BuyPlanDR is null or {fn LENGTH(BRL_BuyPlanDR)}=0))
	If SQLCODE
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	Set SQLCODE=##class(web.DHCEQBuyPlanList).UpdateBuyPlan("","",BPRowID,1)
	If SQLCODE
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	
	Set SubFlag=##class(web.DHCEQCommon).GetSysInfo("102001")	;生成计划时是否自动提交计划	0:否1:是
	If SubFlag="1"
	{
		//Set SQLCODE=##class(web.DHCEQBuyPlan).UpdateData(BPRowID, "1","N")	//(Old) 2012-05-08 HZY0032.这里应该改为:##Class(web.DHCEQBuyPlanNew).SubmitData("2^1^")
		///modified by ZY0212
		Set result=##Class(web.DHCEQ.EM.BUSBuyPlan).SubmitData(BPRowID_"^"_User)	//(New) 2012-05-08 HZY0032.
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
		s SQLCODE=JsonData.SQLCODE
	}
	If (SQLCODE<0)
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	///add 20191012 by zy 生成采购计划
	//把采购申请科室填写的备选信息复制到采购计划明细中.	
	s BPLRowID=0
	f  s BPLRowID=$o(^DHCEQBuyPlanList(0,"BuyPlan",BPRowID,BPLRowID))  Quit:(BPLRowID="")||(SQLCODE'=0)  Do
	.s TemplateID=""
	.s BuyRequestListDR = $p($g(^DHCEQBuyPlanList(BPLRowID)),"^",10)
	.//模版表DHC_EQTemplate SourceType=3  是采购申请明细
	.i BuyRequestListDR'="" s TemplateID=##Class(web.DHCEQTemplate).GetTemplateID(3,BuyRequestListDR)
	.q:TemplateID=""
	.///DHC_EQIFBList SourceType 1:采购申请对应的模版DHC_EQTemplate 的ID   2:采购计划明细ID, 3:招标明细ID
	.s IFBLID=0
	.f  s IFBLID=$o(^DHCEQIFBList(0,"Source",1,TemplateID,IFBLID))  q:IFBLID=""  d
	..k TLIST
	..&SQL(select * into :TLIST() from sqluser.DHC_EQIFBList Where IFBL_RowID=:IFBLID)
	..k TLIST(1)
	..s TLIST(2)="2"
	..s TLIST(3)=BPLRowID 
	..&SQL(Insert Into SQLUSER.DHC_EQIFBList Values :TLIST())
	If (SQLCODE<0)
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	
	If TransFlag'="N" TCOMMIT
	
	Quit SQLCODE
}

/// Mozy	2011-3-3
/// 获取该步骤可以编辑的论证字段信息
/// w ##Class(web.DHCEQBuyRequestNew).GetArgumentation(3)
ClassMethod GetArgumentation(rowid)
{
	new BRLID,ARID,ReturnValue
	Set ARID=""
	Set ReturnValue=0
	Set BRLID=0
	For  Set BRLID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",rowid,BRLID)) Quit:(BRLID="")||(ReturnValue=1)  Do
	.Set ARID=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLID,0))
	.If ARID'="" Set ReturnValue=1
	
	Quit ReturnValue
}

/***************************************************************/
/// Add By DJ 2011-12-29
ClassMethod GetStatusInfo(RequestNo)
{
	s StatusInfo=""
	i RequestNo="" q ""
	s RowID=$o(^DHCEQBuyRequest(0,"RequestNo"," "_RequestNo,0))
	s LRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",RowID,0))
	s Status=$p($g(^DHCEQBuyRequest(RowID)),"^",16)
	s ApproveInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("1",RowID)
	s Role=$p(ApproveInfo,"^",3)
	s StatusInfo="采购申请:"_##Class(web.DHCEQCommon).GetEditStatusDisplay(Status)
	i Role'="" s StatusInfo=StatusInfo_"   [当前审批:"_$p($g(^DHCEQCCode("DHCEQCApproveRole",Role)),"^",2)_"]"
	i Status=2  d
	.s (BPRowID,BPLRowID,BPStatus)=""
	.&SQL(Select BPL_BuyPlanDR->BP_RowID,BPL_RowID,BPL_BuyPlanDR->BP_Status Into :BPRowID,:BPLRowID,:BPStatus From SQLUSER.DHC_EQBuyPlanList Where BPL_BuyRequestListDR=:LRowID and BPL_BuyPlanDR->BP_InvalidFlag<>'Y')
	.i BPRowID'=""  d
	..s ApproveInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("2",BPRowID)
	..s Role=$p(ApproveInfo,"^",3)
	..s StatusInfo="采购计划:"_##Class(web.DHCEQCommon).GetEditStatusDisplay(BPStatus)
	..i Role'="" s StatusInfo=StatusInfo_"   [当前审批:"_$p($g(^DHCEQCCode("DHCEQCApproveRole",Role)),"^",2)_"]"
	..i BPStatus=2  d
	...s (HTRowID,HTLRowID,HTStatus,HTQty,HTArriveQty)=""
	...&SQL(Select CTL_ContractDR->CT_RowID,CTL_RowID,CTL_ContractDR->CT_Status,CTL_QuantityNum,CTL_ArriveQuantityNum Into :HTRowID,:HTLRowID,:HTStatus,:HTQty,:HTArriveQty From SQLUSER.DHC_EQContractList Where CTL_SourceType=1 and CTL_SourceID=:BPLRowID)
	...i HTRowID'=""  d
	....s ApproveInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("8",BPRowID)
	....s Role=$p(ApproveInfo,"^",3)
	....s StatusInfo="采购合同:"_##Class(web.DHCEQCommon).GetEditStatusDisplay(HTStatus)
	....i Role'="" s StatusInfo=StatusInfo_"   [当前审批:"_$p($g(^DHCEQCCode("DHCEQCApproveRole",Role)),"^",2)_"]"
	....i HTStatus=2  d
	.....s (OCLRowID,SHSL,DSSL,Find,AllQty,ISSL,ISSHSL,ISDSSL,ISFind)=0
	.....f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source","1",HTLRowID,OCLRowID))  q:OCLRowID=""  d
	......s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	......s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	......q:InvalidFlag="Y"
	......s Find=Find+1
	......s OCRStatus=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20)
	......s OCLQty=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	......s AllQty=AllQty+OCLQty
	......i OCRStatus=2  d
	.......s SHSL=SHSL+OCLQty
	.......s ISLRowID=0	//入库检测
	.......f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:ISLRowID=""  d
	........s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	........s InvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	........q:InvalidFlag="Y"
	........s ISFind=ISFind+1
	........s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	........s ISLQty=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	........s ISSL=ISSL+ISLQty
	........i ISStatus=2  s ISSHSL=ISSHSL+ISLQty
	........i ISStatus'=2 s ISDSSL=ISDSSL+ISLQty
	......i OCRStatus'=2 s DSSL=DSSL+OCLQty
	.....i Find'=0  d
	......s StatusInfo="设备验收:[到货总数:"_AllQty_"],[已验收:"_SHSL_"],[在途验收:"_DSSL_"]"
	......i ISFind'=0  d
	.......s StatusInfo=StatusInfo_"   设备入库:(入库总数:"_ISSL_", 入库已审:"_ISSHSL_", 入库待审:"_ISDSSL_")"
	s StatusInfo=##class(web.DHCEQCommon).Replace(StatusInfo,$C(13,10),"\n")
	q StatusInfo
}

/********************************************************************************/
ClassMethod RequestEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RequestEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RequestEquipExecute(ByRef qHandle As %Binary, RequestNo As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1  ///Modefied by zc ZC0034 2018-2-12
	s rowid=0
	d BuildDataGetRequestEquip
	Quit $$$OK
BuildDataGetRequestEquip
	i RequestNo="" q
	s BRRowID=$o(^DHCEQBuyRequest(0,"RequestNo"," "_RequestNo,0))
	s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,0))
	s BRStatus=$p($g(^DHCEQBuyRequest(BRRowID)),"^",16)
	s BRLocDR=$p($g(^DHCEQBuyRequest(BRRowID)),"^",2)
	i BRStatus'=2  q
	;采购计划
	s (BPLRowID,HTLRowID)=""
	&SQL(Select BPL_RowID Into :BPLRowID From SQLUSER.DHC_EQBuyPlanList Where BPL_BuyPlanDR->BP_Status='2' and BPL_BuyRequestListDR=:BRLRowID and BPL_BuyPlanDR->BP_InvalidFlag<>'Y')
	i BPLRowID="" q
	;采购合同
	&SQL(Select CTL_RowID Into :HTLRowID From SQLUSER.DHC_EQContractList Where CTL_SourceType=1 and CTL_ContractDR->CT_Status='2' and CTL_SourceID=:BPLRowID)
	i HTLRowID="" q
	s OCLRowID=0
	f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source","1",HTLRowID,OCLRowID))  q:OCLRowID=""  d
	.s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	.s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	.q:InvalidFlag="Y"
	.s OCRStatus=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20)
	.q:OCRStatus'=2
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID))  q:EQRowID=""  d
	..d ResetVariablesGetRequestEquip
	..s TRowID=EQRowID
	..s TEquipNo=$p($g(^DHCEQEquip(TRowID)),"^",71)
	..s TEquipName=$p($g(^DHCEQEquip(TRowID)),"^",1)
	..s LISourceID=0
	..s Find=0
	..f  s LISourceID=$o(^DHCEQLifeInfo(0,"EquipSource","22",TRowID,LISourceID))  q:(LISourceID="")||(Find'=0)  d
	...s LIRowID=0
	...f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSource","22",TRowID,LISourceID,LIRowID))  q:(LIRowID="")||(Find'=0)  d
	....s TLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	....s TDate=$p($g(^DHCEQLifeInfo(LIRowID)),"^",15)
	....q:TLoc'=BRLocDR
	....s Find=Find+1
	..i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLoc)
	..d OutputRowGetRequestEquip
	quit
OutputRowGetRequestEquip
	s Data=$lb(TRowID,TEquipNo,TEquipName,TDate,TLoc,TRow)  ///Modefied by zc ZC0034 2018-2-12
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1 ///Modefied by zc ZC0034 2018-2-12
	quit
ResetVariablesGetRequestEquip
	s (TRowID,TEquipNo,TEquipName,TDate,TLoc)=""
	quit
}

ClassMethod RequestEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RequestEquipExecute ]
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

/// Modefied by zc ZC0034 2018-2-12
/// 添加输出列TRow
Query RequestEquip(RequestNo As %String = "") As %Query(ROWSPEC = "Hidden:%String,TEquipNo:%String,TEquipName:%String,TDate:%String,TLoc:%String,TRow:%String")
{
}

/***************************************************************/
/// Add By DJ 2012-02-06 DJ0104
/// 描述:年度采购申请查询
/// Modified by zy 20191025 ZY0194  增加管理科室参数
Query YearBuyRequest(PrjName As %String = "", RequestNo As %String = "", StartDate As %String = "", EndDate As %String = "", BRYear As %String = "", RequestLocDR As %String = "", ApproveRole As %String = "", ApproveFlag As %String = "0", Action As %String = "0", ManageLocDR As %String = "", Status As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TOperator:%String,TPrjName:%String,TRequestDate:%String,TRequestNo:%String,TName:%String,TModel:%String,TEquipType:%String,TRequestNum:%String,TPrice:%String,TAmount:%String,TApproveNum:%String,TApproveInfo:%String,TStatus:%String,TRequestLoc:%String,TApproveRole:%String,TJob:%String,TRejectReason:%String,TRoleStep:%String,TCancelToFlow:%String,TBRLRowID:%String,TApproveSet:%String,TRow:%String,TProcess:%String,THold1:%String")
{
}

/// Modified by zy 20191025 ZY0194  增加管理科室参数
/// add 20191012 by zy 增加动作参数传递
/// d ##class(%ResultSet).RunQuery("web.DHCEQBuyRequestNew","YearBuyRequest","")
ClassMethod YearBuyRequestExecute(ByRef qHandle As %Binary, PrjName As %String = "", RequestNo As %String = "", StartDate As %String = "", EndDate As %String = "", BRYear As %String = "", RequestLocDR As %String = "", ApproveRole As %String = "", ApproveFlag As %String = "0", Action As %String = "0", ManageLocDR As %String = "", Status As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	s TJob=$J
	k ^DHCEQTemp("YearBuyRequest",+$H,$J)
	s PrjName=##Class(web.DHCEQCommon).UnEscape(PrjName)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	///modified by ZY0176  hisui改造
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	d BuildDataGetYearBuyRequest
	Quit $$$OK
BuildDataGetYearBuyRequest
	s CurYear=0
	f  s CurYear=$o(^DHCEQBuyRequest(0,"Year",CurYear))  q:CurYear=""  d
	.d ResetVariablesGetYearBuyRequest
	.q:(BRYear'="")&&(CurYear'=BRYear)
	.s TYear=CurYear
	.s BRRowID=0
	.f  s BRRowID=$o(^DHCEQBuyRequest(0,"Year",CurYear,BRRowID)) q:BRRowID=""  d
	../// Modified by zy 20191025 ZY0194  增加管理科室参数
	..s TManageLocDR=$p($g(^DHCEQBuyRequest(BRRowID)),"^",18)
	..//Add by QW 20200114 bengin bug0037:判断当前是否为管理科室
	..s LocFlag=0
	..s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
  	..i (ManageLocDR'="")&&('$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,ManageLocDR))) d
  	...s LocFlag=1
    ..///modified by ZY20230420 bug:3456748
    ..q:(ManageLocDR'="")&&(LocFlag=0)&&(TManageLocDR'=ManageLocDR)
	..//Add by QW 20200114 bengin bug0037:判断当前是否为管理科室
	..s BRStatus=$p($g(^DHCEQBuyRequest(BRRowID)),"^",16)
	..q:(BRStatus=0)||(BRStatus=3)
	..q:(ApproveFlag="0")&&(BRStatus'=1)
	..q:(ApproveFlag="1")&&(BRStatus'=2)
	..s YearFlag=$p($g(^DHCEQBuyRequest(BRRowID)),"^",3)
	..;q:YearFlag'="Y"	//modified by zy 20191025 ZY0194
	..s InvalidFlag=$p($g(^DHCEQBuyRequest(BRRowID)),"^",45)
	..q:InvalidFlag="Y"
	..s TRequestLoc=$p($g(^DHCEQBuyRequest(BRRowID)),"^",2)
	..s THospitalDR = ##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TRequestLoc)
	..q:(RequestLocDR'="")&&(TRequestLoc'=RequestLocDR)
	..q:(TRequestLoc'="")&&(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLoc)))		//czf 2021-09-02
	..i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLoc)
	..s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,BRRowID,0))
	..s TProcess="无"
	..s (AppSetDR,NextStepID)=""
	..i AIRowID'=""  d
	...s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)		//czf 2021-09-01
	...s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)
	...s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	...s TApproveRole=$p(^DHCEQApproveInfo(AIRowID),"^",7)
	...i TApproveRole'="" s TProcess=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	..q:(ApproveFlag="0")&&(CurRole'=ApproveRole)
	..s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	..i (AppSetDR'="")&&(NextStepID'="") d
	...s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	...i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	..q:(ApproveFlag="0")&&(ApproveRole=CurRole)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	..s TRoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("1",BRRowID),ApproveRole)
	..s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("1",BRRowID)
	..s TApproveSet=$p(ApproveInfo,"^",2)
	..s TCancelToFlow=$p(ApproveInfo,"^",8)
	..i TApproveRole'="" s TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TApproveRole)
	..s TRowID=BRRowID
	..//Add by QW 20200114 bengin 需求号:1179793 bug:QW0036 多方审批 判断是否当前科室已审批
	..Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("1", BRRowID)
	..Quit:(BRStatus="1")&&(##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).ISMultipleDone(ApproveSet,BRRowID,CurRole,ApproveType,$Piece(^DHCEQApproveInfo(AIRowID),"^",5))'=0)
	..//End by QW 20200114 end 多方审批
	..s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(BRStatus)
	..s TPrjName=$p($g(^DHCEQBuyRequest(BRRowID)),"^",1)
	..q:(PrjName'="")&&(TPrjName'[PrjName)
	..s TRequestDate=$p($g(^DHCEQBuyRequest(BRRowID)),"^",6)
	..q:(StartDate'="")&&(TRequestDate<StartDate)
	..q:(EndDate'="")&&(TRequestDate>EndDate)
	..i TRequestDate'="" s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	..s TRequestNo=$p($g(^DHCEQBuyRequest(BRRowID)),"^",35)
	..q:(RequestNo'="")&&($E(TRequestNo,1,$l(RequestNo))'=RequestNo)
	..s TEquipType=$p($g(^DHCEQBuyRequest(BRRowID)),"^",25)
	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipType))
	..i TEquipType'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipType)),"^",2)
	..s TRejectReason=$p($g(^DHCEQBuyRequest(BRRowID)),"^",37)
	..s THold1 = $Piece($Get(^DHCEQBuyRequest(BRRowID)),"^",17)	//czf 2021-05-20 1837956
	..i BRStatus=1 s TRejectReason=""
	..s BRLRowID=0
	..f  s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,BRLRowID)) q:BRLRowID=""  d
	...s TBRLRowID=BRLRowID
	...s TName=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)
	...s TModel=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",3)
	...i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	...///modified by ZY0214
	...s IFBLRowID=$Order(^DHCEQIFBList(0,"Source",1,BRLRowID,0))
	...i IFBLRowID'="" s TModel=$p($g(^DHCEQIFBList(IFBLRowID)),"^",7)
	...s TRequestNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",20)
	...;s TPrice=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",6)
	...s TPrice=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",36) //modified by zy 20191025 ZY0194
	...///modified by ZY0197
	...//s TApproveNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",7)
	...///modified by ZY0214
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber((TRequestNum*TPrice),"")
	...s (BRAIRowID,TApproveNum)=""
	...s BRAIStep=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,""),-1)
	...i BRAIStep'="" s BRAIRowID=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,BRAIStep,0))
	...i BRAIRowID'="" d
	....s TApproveNum=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",4)
	....s TPrice=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",5)
	....s TAmount=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",6)
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	...//modified by ZY0292 2022-01-20
	...q:(Action="BuyReq_Assign")&&(##class(web.DHCEQ.EM.BUSBuyRequest).IsInBuyPlan(BRLRowID,TApproveNum)=1)
	...s TApproveInfo=""
	...//modified by ZY0292 2022-01-20
	...i ApproveRole'="" d
	....s ALRowID=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,BRRowID,ApproveRole,0))
	....//modified BY ZY0209
	....i ALRowID'=""  d
	.....s OperatorType=$p($g(^DHCEQApproveList(ALRowID)),"^",12)
	.....i OperatorType=0  d
	......s TApproveInfo=$p($g(^DHCEQApproveList(ALRowID)),"^",3)
	.....e  d
	......s TRejectReason=$p($g(^DHCEQApproveList(ALRowID)),"^",3)
	...d OutputRowGetYearBuyRequest
	quit
OutputRowGetYearBuyRequest
	s Data=$lb(TRowID,TYear,TOperator,TPrjName,TRequestDate,TRequestNo,TName,TModel,TEquipType,TRequestNum,TPrice,TAmount,TApproveNum,TApproveInfo,TStatus,TRequestLoc,TApproveRole,TJob,TRejectReason,TRoleStep,TCancelToFlow,TBRLRowID,TApproveSet,TRow,TProcess,THold1)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("YearBuyRequest",+$H,$J,index)=TRowID_"^"_TYear_"^"_TOperator_"^"_TPrjName_"^"_TRequestDate_"^"_TRequestNo_"^"_TName_"^"_TModel_"^"_TEquipType_"^"_TRequestNum_"^"_TPrice_"^"_TAmount_"^"_TApproveNum_"^"_TApproveInfo_"^"_TStatus_"^"_TRequestLoc_"^"_TApproveRole_"^"_TJob_"^"_TRejectReason_"^"_TRoleStep_"^"_TCancelToFlow_"^"_TBRLRowID_"^"_TApproveSet_"^"_TRow
	Set index=index+1
	set TRow=TRow+1     //add by wy 2017-12-20 需求481740 
	quit
ResetVariablesGetYearBuyRequest
	s (TRowID,TYear,TOperator,TPrjName,TRequestDate,TRequestNo,TName,TModel,TEquipType,TRequestNum,TPrice,TAmount,TApproveNum,TApproveInfo,TStatus,TRequestLoc,TApproveRole,TRejectReason,TRoleStep,TCancelToFlow,TBRLRowID,TApproveSet,TApproveRole,TProcess,THold1)=""
	quit
}

ClassMethod YearBuyRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = YearBuyRequestExecute ]
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

ClassMethod YearBuyRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = YearBuyRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By DJ 2012-02-06 DJ0104
ClassMethod GetOneYearBuyRequest(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("YearBuyRequest",+$H,job,""),-1)
	q $g(^DHCEQTemp("YearBuyRequest",+$H,job,PNum))
}

/// MZY0149	3158550		2023-01-09	修正参数
/// add by wl 2020-06-03 WL0066 界面行数获取
ClassMethod GetNum(node As %Library.String = "", date As %Library.String = "", job)
{
	q ..GetOneYearBuyRequest(0,job)
}

/// add by wl 2020-06-03 WL0066
ClassMethod GetList(node As %Library.String = "", job, gnum)
{
	q ..GetOneYearBuyRequest(gnum,job)
}

/// Add By DJ 2012-02-06 DJ0104
ClassMethod YearBuyRequestAudit(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", vListInfo As %Library.String = "")
{
	s SQLCODE=0
	s BuyRequestID=$p(val,"^",1)
	s BuyRequestNo=$p($g(^DHCEQBuyRequest(BuyRequestID)),"^",35)
	s SQLCODE=..AuditData(val,CurRole,RoleStep,vListInfo,"Y")		//Modify DJ 2017-07-21 DJ0191
	i SQLCODE<0 q "-1^"_BuyRequestNo_"^"_SQLCODE
	q SQLCODE
}

/***************************************************************/
/// Add By DJ 2015-08-21 DJ0157
/// 描述:获取采购申请中科室同类台数,科室为空时获取同类台数
ClassMethod GetBRCountInLoc(vItemDR, vLocDR)
{
	s LocNum=0
	s AllNum=0
	i vLocDR'="" s LocNum=##Class(web.DHCEQCommonEX).GetCountInLoc(vItemDR,vLocDR)
	s AllNum=##Class(web.DHCEQCommonEX).GetCountInLoc(vItemDR,"")
	
	q AllNum_"^"_LocNum
}

}
