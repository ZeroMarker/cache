Class web.DHCEQ.EM.BUSBuyRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).GetOneBuyRequest(2,9,"BuyReq_Decision",4)
ClassMethod GetOneBuyRequest(RowID As %Library.String = "", ApproveRoleDR As %Library.String = "", action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneBuyRequest"
	s ObjBuyRequest=##Class(User.DHCEQBuyRequest).%OpenId(RowID)
	s BuyRequest=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBuyRequest)
	d BuyRequest.%Set("BRRowID",RowID)
	d BuyRequest.%Set("BRManageLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjBuyRequest.BRManageLocDR))	//modified by zy 20191025 ZY0194
	d BuyRequest.%Set("BRRequestLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjBuyRequest.BRRequestLocDR))
	d BuyRequest.%Set("BRUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjBuyRequest.BRUseLocDR))
	d BuyRequest.%Set("BREquipTypeDR_ETDesc",ObjBuyRequest.BREquipTypeDR.ETDesc)
	d BuyRequest.%Set("BRPurchaseTypeDR_PTDesc",ObjBuyRequest.BRPurchaseTypeDR.PTDesc)
	d BuyRequest.%Set("BRPurposeTypeDR_PTDesc",ObjBuyRequest.BRPurposeTypeDR.PTDesc)
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("1",RowID,ApproveRoleDR)
	d BuyRequest.%Set("AIRowID",$p(AppInfo,"^",1))
	d BuyRequest.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d BuyRequest.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d BuyRequest.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d BuyRequest.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d BuyRequest.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d BuyRequest.%Set("CancelFlag",$p(AppInfo,"^",7))
	d BuyRequest.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d BuyRequest.%Set("ApproveRole",$p(AppInfo,"^",9))
	d BuyRequest.%Set("NextRole",$p(AppInfo,"^",10))
	s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("1",action,RowID,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.s MultipleRoleFlag=1
	
	d BuyRequest.%Set("MultipleRoleFlag",MultipleRoleFlag)
	
	s AuditOpinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(1,RowID)
	d BuyRequest.%Set("OpinionRecords",AuditOpinion)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BuyRequest)
ERRORGetOneBuyRequest
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).GetOneBuyRequestList(17)
ClassMethod GetOneBuyRequestList(BRRowID As %Library.String = "")
{
	Set BRLRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,""))
	Quit:BRLRowID="" 0	//modofied by zy ZY0206
	s $ZT="ERRORGetOneBuyRequestList"
	s ObjBuyRequestList=##Class(User.DHCEQBuyRequestList).%OpenId(BRLRowID)
	s BuyRequestList=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBuyRequestList)
	d BuyRequestList.%Set("BRLRowID",BRLRowID)
	d BuyRequestList.%Set("BRLModelDR_MDesc",ObjBuyRequestList.BRLModelDR.MDesc)
	d BuyRequestList.%Set("BRLManuFacDR_MDesc",ObjBuyRequestList.BRLManuFacDR.MFName)
	d BuyRequestList.%Set("BRLEquipCatDR_ECDesc",ObjBuyRequestList.BRLEquipCatDR.ECDesc)
	d BuyRequestList.%Set("BRLItemDR_MIDesc",ObjBuyRequestList.BRLItemDR.MIDesc)
	d BuyRequestList.%Set("BRLUnitDR_UOMDesc",ObjBuyRequestList.BRLUnitDR.UOMDesc)
	d BuyRequestList.%Set("BRLStatCatDR_SCDesc",ObjBuyRequestList.BRLStatCatDR.SCDesc)
	d BuyRequestList.%Set("BRLFundsOriginDR_FTDesc",ObjBuyRequestList.BRLFundsOriginDR.FTDesc)
	d BuyRequestList.%Set("BRLPurchaseTypeDR_PTDesc",ObjBuyRequestList.BRLPurchaseTypeDR.PTDesc)
	d BuyRequestList.%Set("BRLPurposeTypeDR_PTDesc",ObjBuyRequestList.BRLPurposeTypeDR.PTDesc)
	// MZY0041	1427330		2020-7-22
	d BuyRequestList.%Set("BRLHold1_SSUSRName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyRequestList.BRLHold1))
	d BuyRequestList.%Set("BRLHold3_SSUSRName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyRequestList.BRLHold3))
	d BuyRequestList.%Set("BRLHold5_FTDesc",##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",ObjBuyRequestList.BRLHold5))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BuyRequestList)
ERRORGetOneBuyRequestList
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).GetOneBuyRequestDetail(16)
ClassMethod GetOneBuyRequestDetail(BRLRowID As %Library.String = "")
{
	Set BRDRowID=$Order(^DHCEQBuyRequestDetail(0,"BuyRequestList",BRLRowID,""))
	Quit:BRDRowID="" 0	//modofied by zy ZY0206
	s $ZT="ERRORGetOneBuyRequestDetail"
	s ObjBuyRequestDetail=##Class(User.DHCEQBuyRequestDetail).%OpenId(BRDRowID)
	s BuyRequestDetail=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBuyRequestDetail)
	d BuyRequestDetail.%Set("BRDRowID",BRDRowID)
	//add by zx 2019-09-11
	if BuyRequestDetail.BRDMedicalItem="true" d BuyRequestDetail.%Set("BRDMedicalItem",1)
	if BuyRequestDetail.BRDConsumption="true" d BuyRequestDetail.%Set("BRDConsumption",1)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BuyRequestDetail)
ERRORGetOneBuyRequestDetail
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// add by zy ZY0206 
/// 论证表的信息输出
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).GetOneArgumentation(37)
ClassMethod GetOneArgumentation(BRLRowID As %Library.String = "")
{
	Set ARRowID=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLRowID,""))
	Quit:ARRowID="" 0
	s $ZT="ERRORGetOneArgumentation"
	s ObjArgumentation=##Class(User.DHCEQArgumentation).%OpenId(ARRowID)
	s Argumentation=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjArgumentation)
	d Argumentation.%Set("ARRowID",ARRowID)
	if Argumentation.ARPlaceConditionFlag="true" d Argumentation.%Set("ARPlaceConditionFlag",1)
	if Argumentation.ARPlaceReformFlag="true" d Argumentation.%Set("ARPlaceReformFlag",1)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,Argumentation)
ERRORGetOneArgumentation
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// DHC_EQBuyReqAuditInfo  输出
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).GetOneBuyReqAuditInfo(21,4)
ClassMethod GetOneBuyReqAuditInfo(BRLRowID As %Library.String = "", Step As %Library.String = "")
{
	s BuyReqAuditInfo=""
	s $ZT="ERRORGetOneBuyReqAuditInfo"
	
	s BRAIRowID=$Order(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,Step,0))
	i BRAIRowID="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson("",BuyReqAuditInfo)
	s ObjBuyReqAuditInfo=##Class(User.DHCEQBuyReqAuditInfo).%OpenId(BRAIRowID)
	s BuyReqAuditInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBuyReqAuditInfo)
	d BuyReqAuditInfo.%Set("BRAIRowID",BRAIRowID)
	d BuyReqAuditInfo.%Set("BRAIActionDR_ACode",ObjBuyReqAuditInfo.BRAIActionDR.ACode)
	d BuyReqAuditInfo.%Set("BRAIActionDR_ADesc",ObjBuyReqAuditInfo.BRAIActionDR.ADesc)
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BuyReqAuditInfo)
ERRORGetOneBuyReqAuditInfo
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

ClassMethod SaveData(data, DelIs)
{
	s $ZT="ERRORBuyRequest"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQBuyRequest set BR_InvalidFlag='Y' where BR_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyRequest",JsonData,.PLIST)
	    s LPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyRequestList",JsonData,.LPLIST)
	    s DPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyRequestDetail",JsonData,.DPLIST)
	    //modified by zy 20191025 ZY0194
	    s IFBPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQIFBList",JsonData,.IFBPLIST)
	    //modofied by zy ZY0206
	    s APLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQArgumentation",JsonData,.APLIST)
	    //modofied by zy ZY0218 2020-04-10
	    s ECPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEconCalc",JsonData,.ECPLIST)
		s RowID = JsonData.BRRowID
		s PLIST(17) = "0"	;Status
		s PLIST(18) = "N"	;Hold1  批量标志 czf 2021-05-18 1837956
	    if RowID'=""
	    {
		 	s PLIST(32) = User	;UpdateUserDR
		 	s PLIST(33) = Date	;UpdateDate
			s PLIST(34) = Time	;UpdateTime
			s PLIST(46) = "N"	;InvalidFlag	//modified by ZY0196
			&SQL(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID = :RowID)
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			&SQL(Update SQLUSER.DHC_EQBuyRequestList Values :LPLIST() where BRL_BuyRequestDR = :RowID)
			i SQLCODE=100 s SQLCODE=0	//modofied by zy ZY0206
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			Set BRLRowID=$Get(%ROWID)
			&SQL(Update SQLUSER.DHC_EQBuyRequestDetail Values :DPLIST() where BRD_BuyRequestListDR = :BRLRowID)
			//modofied by zy ZY0206 begin
			i SQLCODE=100 s SQLCODE=0
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			&SQL(Update SQLUSER.DHC_EQArgumentation Values :APLIST() where AR_BuyRequestListDR = :BRLRowID)
			i SQLCODE=100 s SQLCODE=0
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			//modofied by zy ZY0206 end
			//modified by zy 20191025 ZY0194
			s IFBPLIST(2)="1"
			s IFBPLIST(3)=BRLRowID
			s IFBLRowID=$Order(^DHCEQIFBList(0,"Source",1,BRLRowID,0))
			///modified by ZY0197  型号为空的时候不存记录
			if (IFBPLIST(8)'="")
			{
				if IFBLRowID'=""
				{
					&SQL(Update SQLUSER.DHC_EQIFBList Values :IFBPLIST() where IFBL_RowID = :IFBLRowID)
				}
				else
				{
					&SQL(Insert Into SQLUSER.DHC_EQIFBList Values :IFBPLIST())
				}
			}
			//modofied by zy ZY0218 2020-04-10
			s ECPLIST(2)="1"
			s ECPLIST(3)=BRLRowID
			s CalcFlag="Y"
			s ECPLIST(5)=CalcFlag	//CalcFlag
			s ECRowID=$Order(^DHCEQEconCalc(0,"Source",1,BRLRowID,CalcFlag,0))
			if ECRowID'=""
			{
				&SQL(Update SQLUSER.DHC_EQEconCalc Values :ECPLIST() where EC_RowID = :ECRowID)
			}
			else
			{
				&SQL(Insert Into SQLUSER.DHC_EQEconCalc Values :ECPLIST())
			}
			//end by ZY0218 2020-04-10
		}
		else
		{
			i PLIST(36)="" s PLIST(36)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyRequest",Date,JsonData.BRRequestLocDR,JsonData.BREquipTypeDR)
			//add by zx 2019-09-10 位置错位修正
		 	s PLIST(29) = User	;addUserDR
		 	s PLIST(30) = Date	;addDate
			s PLIST(31) = Time	;addTime
			s PLIST(46) = "N"	;InvalidFlag	//modified by ZY0196
			&SQL(insert into SQLUSER.DHC_EQBuyRequest Values :PLIST())
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			s RowID=$g(%ROWID)
		 	Set LPLIST(2)=RowID	//	BRL_BuyRequestDR
		 	
		 	Set LPLIST(8)=LPLIST(21)
		 	Set LPLIST(9)=LPLIST(37)*LPLIST(21)
		 	&SQL(Insert Into SQLUSER.DHC_EQBuyRequestList Values :LPLIST())
		 	Set BRLRowID=$Get(%ROWID)
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			/////
		 	Set DPLIST(2)=BRLRowID		//	BRL_BuyRequestListDR
		 	&SQL(Insert Into SQLUSER.DHC_EQBuyRequestDetail Values :DPLIST())
			//modofied by zy ZY0206 begin
			i SQLCODE=100 s SQLCODE=0
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		 	Set APLIST(2)=BRLRowID		//	AR_BuyRequestListDR
		 	&SQL(Insert Into SQLUSER.DHC_EQArgumentation Values :APLIST())
			i SQLCODE=100 s SQLCODE=0
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			//modofied by zy ZY0206 end
			//modified by zy 20191025 ZY0194
			s IFBPLIST(2)="1"
			s IFBPLIST(3)=BRLRowID
			///modified by ZY0197  型号为空的时候不存记录
			if (IFBPLIST(8)'="")
			{
				&SQL(Insert Into SQLUSER.DHC_EQIFBList Values :IFBPLIST())
			}
			
			//modofied by zy ZY0218 2020-04-10
			s ECPLIST(2)="1"
			s ECPLIST(3)=BRLRowID
			s CalcFlag="Y"
			s ECPLIST(5)=CalcFlag	//CalcFlag
			&SQL(Insert Into SQLUSER.DHC_EQEconCalc Values :ECPLIST())
			//end by zy ZY0218 2020-04-10
            s TmpSourceID = JsonData.TmpSourceID
            i TmpSourceID'=""
            {
                &SQL(Update SQLUSER.DHC_EQMultipleApproveInfo set MA_BusID=:RowID where MA_ApproveTypeDR ='1'  and MA_BusID = :TmpSourceID)
                
                i SQLCODE=100 s SQLCODE=0
                If SQLCODE
                {
                    TROLLBACK
                    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
                }
                &SQL(Update SQLUSER.DHC_EQIFBList set IFBL_SourceID=:BRLRowID where IFBL_SourceType ='1'  and IFBL_SourceID = :TmpSourceID)
                
                i SQLCODE=100 s SQLCODE=0
                If SQLCODE
                {
                    TROLLBACK
                    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
                }
                &SQL(Update SQLUSER.DHC_EQResearch set R_SourceID=:BRLRowID where R_BussType='1' and R_SourceType ='1'  and R_SourceID = :TmpSourceID)
                
                i SQLCODE=100 s SQLCODE=0
                If SQLCODE
                {
                    TROLLBACK
                    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
                }
                &SQL(Update SQLUSER.DHC_EQEconCalc set EC_SourceID=:BRLRowID where EC_SourceType ='1'  and EC_SourceID = :TmpSourceID)
                
                i SQLCODE=100 s SQLCODE=0
                If SQLCODE
                {
                    TROLLBACK
                    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
                }
                &SQL(Update SQLUSER.DHC_EQEquipService set ES_SourceID=:BRLRowID where ES_BussType='1' and ES_SourceType ='3'  and ES_SourceID = :TmpSourceID)
                
                i SQLCODE=100 s SQLCODE=0
                If SQLCODE
                {
                    TROLLBACK
                    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
                } 
            }
            
		}
		///modified by ZY0196 计算申请单的总金额和数据
		///待处理的逻辑
		s (Quantity,Total)=0
	 	&SQL(select sum(BRL_RequestNum) into :Quantity from  SQLUSER.DHC_EQBuyRequestList where BRL_BuyRequestDR=:RowID)
	 	&SQL(select sum(BRL_TotalFee) into:Total from  SQLUSER.DHC_EQBuyRequestList where BRL_BuyRequestDR=:RowID)
	 	&SQL(update SQLUSER.DHC_EQBuyRequest set BR_QuantityNum=:Quantity,BR_TotalFee=:Total where BR_RowID=:RowID)
	 	If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
			
	}
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORBuyRequest
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// 创建:Mozy 2011-2-18
/// 描述:提交
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).SubmitData("2^1^")
ClassMethod SubmitData(RowID)
{
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQBuyRequest(RowID)),"^",16)
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","状态不是新增!")   //该记录状态不符合,不能执行操作!
	
	s InvalidFlag=$Piece($G(^DHCEQBuyRequest(RowID)),"^",45) //2011-10-31 DJ DJ0098
	if InvalidFlag="Y" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","单据已经无效!")  //2011-10-31 DJ DJ0098
	
	s LimitTotalFee=##class(web.DHCEQCommon).GetSysInfo("101005") //2014-9-17 HZY0065
	
	///add by ZY0209 判断设备项信息填写情况
	i ##Class(web.DHCEQ.Con.BUSContract).CheckMasterItem("91",RowID)=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","'通用名称'信息为空!")
	Set $ZT="ERRORSubmitData"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
 	
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
 	i ((YearFlag'="Y")&&(TotalFee>LimitTotalFee))  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","总金额大于日常限制的金额!")  //总金额大于日常限制的金额! 2014-9-17 HZY0065
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")

	//modified by ZY0196 增加管理科室的条件限制
	s ApproveCondition="ManageLocDR,DHCEQBuyRequest,"_$Piece(^DHCEQBuyRequest(RowID),"^",18)
	//modified by czf 增加批量申请的条件限制 2021-05-18 begin 1837956
	s BatchApproveCondition="BatchFlag,DHCEQBuyRequest,"_$Piece($G(^DHCEQBuyRequest(RowID)),"^",17)
	s ApproveCondition=ApproveCondition_"^"_BatchApproveCondition
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, "", MaxPrice, YearFlag, ApproveCondition)
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","-4007无审批设置!")
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
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除ApproveList信息失败!")
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存ApproveInfo信息失败!")
	}
	Set PLIST(17)=	1		// BR_Status
 	Set PLIST(11)=	User	// BR_SubmitUserDR
	Set PLIST(12)=	Date	// BR_SubmitDate
	Set PLIST(13)=	Time	// BR_SubmitTime
	If AuditFlag=1 Set PLIST(17)=	2		// BR_Status
	&SQL(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存申请单信息失败!")
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).LastAuditAction(RowID_"^"_User_"^")
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"写最后一步审核信息失败!")
		}		
	}
	///Modified by QW 2019-08-31 多方审批
	s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","BuyReq_Loc",0))
	s LimitLocDRs=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleApproveLoc(RowID,ApproveType)
	;Modified by jdl 2011-3-17  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag,"","","",vLimitLocActions,LimitLocDRs)
 	///End  by QW 2019-08-31 多方审批
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"写消息信息失败!")
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// Modified by ZY 2019-10-22 ZY0193
/// 有其他方法使用了相同名称的变量,把变量重新赋值。同时修改批量处理单据时的返回值逻辑
/// Add By DJ 2012-02-06 DJ0104
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).BatchCancelSubmitData("12","8^5^^^测试^")
ClassMethod BatchCancelSubmitData(RowIDs As %Library.String = "", AuditInfo As %Library.String = "")
{
	new j
	s SQLCODE=0
	s Num=$L(RowIDs,",")
	s CurRole=$p(AuditInfo,"^",1)
	s RoleStep=$p(AuditInfo,"^",2)
	s EditOpinion=$p(AuditInfo,"^",3)
	s OpinionRemark=$p(AuditInfo,"^",4)
	s RejectReason=$p(AuditInfo,"^",5)
	s BuyUserDR=$p(AuditInfo,"^",6)
	Set $ZT="BatchCancelSubmitData"
	s ErrorMsg=""
	TSTART
	for j=1:1:Num
	{
		q:ErrorMsg'=""
		s RowID=$p(RowIDs,",",j)
		q:RowID=""
		s BuyRequestNo=$p($g(^DHCEQBuyRequest(RowID)),"^",35)
		s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("1",RowID,CurRole)
		s CancelToFlowDR=$p(AppInfo,"^",8)
		s val=RowID
		s val=val_"^"_CancelToFlowDR
		s val=val_"^"_EditOpinion
		s val=val_"^"_OpinionRemark
		s val=val_"^"_RejectReason
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
		s SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).CancelSubmitData(val,CurRole,"Y")
		//s result=##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
		//s SQLCODE=result.SQLCODE
		i SQLCODE'=0
		{
			s ErrorMsg=BuyRequestNo_":"_SQLCODE
		}
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
BatchCancelSubmitData
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1003",ErrorMsg)
}

/// 创建:Mozy 2011-2-18
/// 描述:取消提交
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).CancelSubmitData("8^1^")
ClassMethod CancelSubmitData(val As %Library.String = "", CurRole, BatchOperFlag As %String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	i BatchOperFlag="" Set $ZT="ERRORCancelSubmitData"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",2)
	Set RejectReason=$Piece(val,"^",5)
	
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
	
	i BatchOperFlag="" TSTART
	//2015-09-28 ZY0144   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("1", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			Quit SQLCODE
		}
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			Quit SQLCODE
		}
	}
	Set PLIST(17)=	Status	// BR_Status
	&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
	If SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			Quit SQLCODE
		}
	}
	;Modified by jdl 2011-3-17  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	///add by QW 2019-08-31 多方审批
	s MultipleDefineDR=##Class(web.DHCEQ.EM.CTMultipleDefine).GetMultipleDefineDRByApproveType(ApproveType)
	i MultipleDefineDR'="" 
	{
		s ClearFlag=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",MultipleDefineDR)),"^",5)
		if ClearFlag="Y"
		{
			s SQLCODE=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).ClearMultipleApproveInfo(RowID,ApproveType)
			i SQLCODE
			{
				//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
			 	i BatchOperFlag=""
			 	{
					TROLLBACK
					Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
				else
				{
					Quit SQLCODE
				}
			}
		}
	}
	///End by QW 2019-08-31 多方审批
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			Quit SQLCODE
		}
	}
	//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
 	i BatchOperFlag=""
 	{
		TCOMMIT
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	}
	else
	{
		Quit SQLCODE
	}
ERRORCancelSubmitData 
	i BatchOperFlag="" TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1003",ErrorMsg)
}

/// Modified by ZY 2019-10-22 ZY0193
/// 有其他方法使用了相同名称的变量,把变量重新赋值。同时修改批量处理单据时的返回值逻辑
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).BatchAuditData("37,38","2^1^111^^^","")
ClassMethod BatchAuditData(RowIDs As %Library.String = "", AuditInfo As %Library.String = "", editFieldsInfo As %Library.String = "")
{
	//modified by ZY0292 2022-01-21
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s SQLCODE=0
	s Num=$L(RowIDs,",")
	s CurRole=$p(AuditInfo,"^",1)
	s RoleStep=$p(AuditInfo,"^",2)
	s EditOpinion=$p(AuditInfo,"^",3)
	s OpinionRemark=$p(AuditInfo,"^",4)
	s RejectReason=$p(AuditInfo,"^",5)
	s BuyUserDR=$p(AuditInfo,"^",6)
	s Action=$p(AuditInfo,"^",7)
	Set $ZT="ERRORBatchAuditData"
	s ErrorMsg=""
	TSTART
	for j=1:1:Num
	{
		q:ErrorMsg'=""
		s RowID=$p(RowIDs,",",j)
		q:RowID=""
		s BuyRequestNo=$p($g(^DHCEQBuyRequest(RowID)),"^",35)
		s val=RowID
		s val=val_"^"
		s val=val_"^"_EditOpinion
		s val=val_"^"_OpinionRemark
		s val=val_"^"_RejectReason
		//modified by ZY0292 2022-01-21
		i Action="BuyReq_Assign"
		{
			;采购申请审核后是否自动生成计划
			//Set CreatePlanFlag=##class(web.DHCEQCommon).GetSysInfo("101002")
			//If (CreatePlanFlag="1")
			//{
				Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).CreatePlan(RowID_"^"_User_"^"_BuyUserDR,"N")
			//}
		}
		else
		{
			//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
			s SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).AuditData(val,CurRole,RoleStep,editFieldsInfo,"Y",BuyUserDR)
			//s a=result
			//s result=##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
			//s SQLCODE=result.SQLCODE
		}
		
		i SQLCODE'=0
		{
			s ErrorMsg=BuyRequestNo_":"_SQLCODE
		}
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORBatchAuditData
	TRollBack
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// 创建:Mozy 2011-2-18
/// 描述:审核
/// Input:BatchOperFlag:批量审核标志
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).AuditData("11^185^同意^^^77^2^20$CHAR(4)^14^1^1500^1500^^^^^^14^1^1500^1500^^^^^$CHAR(3)^15^1^4500^4500^^^^^^15^1^4500^4500^^^^^$CHAR(3)^16^1^2389^2389^^^^^^16^1^2389^2389^^^^^$CHAR(3)","18","2","DHC_EQBuyReqAuditInfo&^1,164^1500,165&^1,164^4500,165&^1,164^2389,165","","77")
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "", BatchOperFlag As %String = "", BuyUserDR As %String = "")
{
	k PLIST
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s SQLCODE=0		//czf 2021-05-17 1837956
	s SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	s SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s BatchFlag=$Piece($G(^DHCEQBuyRequest(RowID)),"^",17)		;批量采购申请标志 czf 2021-07-07
	s Status=$Piece($G(^DHCEQBuyRequest(RowID)),"^",16)
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","状态不是提交!")   //该记录状态不符合,不能执行操作!
	/* //Modified by ZY 2019-10-22 ZY0193 批量处理先不需要这段逻辑
	//批量审核时判断实际明细记录数与选择明细记录数不一致	Modify DJ 2017-07-21 DJ0191
	i BatchOperFlag="Y"
	{
		&SQL(Select Count(*) Into :BRLRowCount From SQLUSER.DHC_EQBuyRequestList Where BRL_BuyRequestDR=:RowID)		//Modify DJ 2015-09-07 DJ0160
		s CheckCount=$L(editFieldsInfo,"@")
		if (CheckCount'=BRLRowCount)	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","实际明细记录数与选择明细记录数不一致!")		//实际明细记录数与选择明细记录数不一致
	}
	*/
	i BatchOperFlag="" Set $ZT="ERRORAuditData"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
 	Set Opinion=$Piece(val,"^",3)
	Set Remark=$Piece(val,"^",4)
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("1", RowID)	
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","-4007无审批设置!")
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"
	
	i BatchOperFlag="" TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		
		Set PLIST(14)=	User	// BR_AuditUserDR
		Set PLIST(15)=	Date	// BR_AuditDate
		Set PLIST(16)=	Time	// BR_AuditTime
		Set PLIST(17)=	2		// BR_Status
		&sql(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID=:RowID)
		If SQLCODE
		{
		 	i BatchOperFlag=""
		 	{
			 	TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			else
			{
				 Quit SQLCODE
			}
		}
		Set AppInfoStatus="2"
	}
	///add by QW 2019-08-31 多方审批
	s returnflag=0
	s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","BuyReq_Loc",0))
	s returnflag=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleApproveInfo(RowID, CurRole, RoleStep, Opinion, Remark, ApproveType, ApproveSet,vLimitLocActions)
	if returnflag<0
	{
	 	i BatchOperFlag=""
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(returnflag)
		}
		else
		{
			Quit returnflag
		}
	}
	;s ^TMP("AuditData",RowID)=returnflag
	//不可提交单据需再发送消息给未审核的指定科室
	if returnflag=1
	{		
		s LimitLocDRs=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleApproveLoc(RowID,ApproveType)
		//给其他科室发消息需要获取前一步审批信息
		s MultipleApproveInfo=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetPreApprovreInfo(RowID, ApproveType, ApproveSet, RoleStep, CurRole)
		s MultiplePreRole=$p(MultipleApproveInfo,"$",2)   ;
		s MultiplePreApproveFlow=$p(MultipleApproveInfo,"$",1)  ;N^1^2^2^RequestLoc^19^N^0^^^2^^2
		;s ^TMP("AuditData")=vLimitLocActions_"$"_LimitLocDRs_"$"_MultipleApproveInfo
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, MultiplePreApproveFlow, "N",MultiplePreRole,AuditFlag,"","","",vLimitLocActions,LimitLocDRs)
		i SQLCODE
		{
			//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
		 	i BatchOperFlag=""
		 	{
			 	TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			else
			{
				 Quit SQLCODE
			}
		}
	}
	///End by QW 2019-08-31 多方审批
	///处理审核中的数量金额信息
	s BAAppInfo=$p(val,SplitNumCode,1)		//czf 2021-05-17 begin 1837956
	s BRAList=$p(val,SplitNumCode,2)
	s length=$l(BRAList,SplitRowCode)
	s i=0
	///modified by ZY0269 20210615
	while ((i<length)&&(SQLCODE=0))
	{
		s i=i+1
		s BRAInfo=$p(BRAList,SplitRowCode,i)
		q:BRAInfo=""
		s BRAIRowID=$Piece(BRAInfo,"^",1)
		k BRAILIST
		s BRAILIST(3)=$Piece(val,"^",7)	//RoleStep		
		s BRAILIST(4)=$Piece(val,"^",8)	//actionid
		s BRAILIST(2)=$Piece(BRAInfo,"^",2)
		s BRAILIST(5)=$Piece(BRAInfo,"^",3)	//quantity
		s BRAILIST(6)=$Piece(BRAInfo,"^",4)	//price
		s BRAILIST(7)=$Piece(BRAInfo,"^",5)	//total
		s BRAILIST(8)=$Piece(BRAInfo,"^",6)	//hold1
		s BRAILIST(9)=$Piece(BRAInfo,"^",7)
		s BRAILIST(10)=$Piece(BRAInfo,"^",8)
		s BRAILIST(11)=$Piece(BRAInfo,"^",9)
		s BRAILIST(12)=$Piece(BRAInfo,"^",10)
		if ((+BRAILIST(5)>0)&(+BRAILIST(6)>0))
		{
			if BRAIRowID=""
			{
				&sql(insert into SQLUSER.DHC_EQBuyReqAuditInfo Values :BRAILIST())
			}
			else
			{
				&sql(Update SQLUSER.DHC_EQBuyReqAuditInfo Values :BRAILIST() where BRAI_RowID=:BRAIRowID)
				i SQLCODE=100 s SQLCODE=0
			}
		}
		q:SQLCODE'=0
	}
	
	//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	i SQLCODE
	{
	 	i BatchOperFlag=""
	 	{
		 	TROLLBACK
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			 Quit SQLCODE
		}
	}									//czf 2021-05-17 end 1837956
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep,User)
	If SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
		 	TROLLBACK
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			 Quit SQLCODE
		}
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
		 	TROLLBACK
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			 Quit SQLCODE
		}
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
		 	i BatchOperFlag=""
		 	{
			 	TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			else
			{
				 Quit SQLCODE
			}
		}
	}
	
	;执行当前角色要执行的动作
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""
	{
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
		 	i BatchOperFlag=""
		 	{
			 	TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			else
			{
				 Quit SQLCODE
			}
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).LastAuditAction(RowID_"^"_User_"^"_BuyUserDR)
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
		If SQLCODE	//Modified By HZY 2012-04-25
		{
		 	i BatchOperFlag=""
		 	{
			 	TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			else
			{
				 Quit SQLCODE
			}
		}
	}
	
	;Modified by jdl 2011-3-17  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("91", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
	 	i BatchOperFlag=""
	 	{
		 	TROLLBACK
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		else
		{
			 Quit SQLCODE
		}
	}
	//Modified by ZY 2019-10-22 ZY0193 修改批量处理单据时的返回值逻辑
 	i BatchOperFlag=""
 	{
	 	TCOMMIT
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	}
	else
	{
		 Quit SQLCODE
	}
ERRORAuditData 
	i BatchOperFlag="" TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处,需调用
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).LastAuditAction(14)
/// ----------------------------------
/// modified by czf 2021-05-18 1837956 修改为批量采购申请也支持
ClassMethod LastAuditAction(val, BuyUserDR As %Library.String = "")
{
	s BRRowID=$p(val,"^",1)
	s flag=0
	
	;更新采购申请明细审批数量、审批单价、审批金额
	s BRLRowID=0
	f  s BRLRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,BRLRowID)) q:(BRLRowID="")||(flag'=0)  d
	.s BRAIStep=$Order(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,""),-1)
	.q:BRAIStep=""
	.s BRAIRowID=$Order(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,BRAIStep,""),-1)
	.q:BRAIRowID=""
	.s ObjBuyReqAuditInfo=##Class(User.DHCEQBuyReqAuditInfo).%OpenId(BRAIRowID)
	.s BRAIAuditQuantity=+ObjBuyReqAuditInfo.BRAIAuditQuantity
	.s BRAIAuditPrice=+ObjBuyReqAuditInfo.BRAIAuditPrice
	.s BRAIAuditTotalFee=+ObjBuyReqAuditInfo.BRAIAuditTotalFee
	.i (BRAIAuditPrice>0)&&(BRAIAuditQuantity>0) d
	..&sql(Update SQLUSER.DHC_EQBuyRequestList set BRL_PriceFee=:BRAIAuditPrice,BRL_QuantityNum=:BRAIAuditQuantity,BRL_TotalFee=:BRAIAuditTotalFee where BRL_RowID=:BRLRowID)
	..i SQLCODE=100 s SQLCODE=0
	..i SQLCODE s flag=SQLCODE
	..q:flag'=0
	i flag q flag
	
	;更新采购申请单总数量、总金额
	s (totalNum,totalFee)=0
	&sql(select sum(BRL_QuantityNum),sum(BRL_TotalFee) into :totalNum,:totalFee from SQLUSER.DHC_EQBuyRequestList where BRL_BuyRequestDR=:BRRowID)
	&sql(Update SQLUSER.DHC_EQBuyRequest set BR_QuantityNum=:totalNum,BR_TotalFee=:totalFee where BR_RowID=:BRRowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q SQLCODE
	
	//modified by ZY0292 2022-01-21
	//审核完毕不自动生成,改成在派单那步生成计划单
	;采购申请审核后是否自动生成计划
	/*
	Set CreatePlanFlag=##class(web.DHCEQCommon).GetSysInfo("101002")
	If (CreatePlanFlag="1")
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).CreatePlan(val,"N")
	}
	*/
	Quit SQLCODE
}

/// Modified by czf 2021-05-18 1837956 修改使支持批量采购申请
/// Desc:把自动提交计划时调用的函数由##class(web.DHCEQBuyPlan).UpdateData()改为##Class(web.DHCEQBuyPlanNew).SubmitData()
/// -------------------------------------------------------
/// Mozy	2011-2-28
/// 生成采购计划
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).CreatePlan("11^77^77","N")
ClassMethod CreatePlan(val, TransFlag)
{
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set BRRowID=$Piece(val,"^",1)
	Set User=$Piece(val,"^",2)
	Set BuyUserDR=$Piece(val,"^",3)
	
	;生成采购单
	k PLIST
	Set PLIST(2)=$Piece(^DHCEQBuyRequest(BRRowID),"^",1) 	//计划名称
	Set PLIST(6)=Date
	Set PLIST(7)="0"
	Set PLIST(8)=BuyUserDR	//记录采购人
	Set PLIST(9)=User	//记录派单人
	Set PLIST(10)=Date	//记录派单日期
	Set PLIST(11)=Time	//记录派单时间
	Set PLIST(12)=Date+##class(web.DHCEQCommon).GetSysInfo("101003")
	Set PLIST(13)=$Piece(^DHCEQBuyRequest(BRRowID),"^",25) 	//设备类组
	Set PLIST(29)=$Piece(^DHCEQBuyRequest(BRRowID),"^",26) 	//申购类别
	Set PLIST(34)=$Piece(^DHCEQBuyRequest(BRRowID),"^",36) 	//急购
	Set PLIST(40)=$Piece(^DHCEQBuyRequest(BRRowID),"^",18) 	//管理部门 //modified by ZY0196 增加管理科室的条件限制
	Set PLIST(43)=$Piece(^DHCEQBuyRequest(BRRowID),"^",41) 	//设备用途
	if (PLIST(43)="")
	{
		s BRLRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,""))
		i BRLRowID'="" s PLIST(43)=$Piece(^DHCEQBuyRequestList(BRLRowID),"^",23)
	}
	Set PLIST(20)=User
	Set PLIST(21)=Date
	Set PLIST(22)=Time
	Set PLIST(26)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyPlan",+$H) //计划单号
	Set PLIST(27)="0"
	Set PLIST(47)="N"
	
	If TransFlag'="N" TSTART
	&SQL(Insert into sqluser.DHC_EQBuyPlan values :PLIST())
	If SQLCODE
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	Set BPRowID=$Get(%ROWID)
	
	;生成采购计划明细及招标明细 add by czf 2021-05-18 1837956 begin
	s SQLCODE=0
	s BRLRowID=0
	f  s BRLRowID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,BRLRowID)) q:(BRLRowID="")||(SQLCODE'=0)  d
	.s BRLInfo=$g(^DHCEQBuyRequestList(BRLRowID))
	.s BRLName=$p(BRLInfo,"^",2)
	.s BRLModelDR=$p(BRLInfo,"^",3)
	.s BRLManuFacDR=$p(BRLInfo,"^",4)
	.s BRLTestFlag=$p(BRLInfo,"^",5)
	.s BRLPriceFee=$p(BRLInfo,"^",6)
	.s BRLQuantityNum=$p(BRLInfo,"^",7)
	.s BRLTotalFee=$p(BRLInfo,"^",8)
	.s BRLCurrencyDR=$p(BRLInfo,"^",14)
	.s BRLEquipCatDR=$p(BRLInfo,"^",15)
	.s BRLItemDR=$p(BRLInfo,"^",17)
	.///modified by ZY0269 20210615
	.i BRLEquipCatDR=""  d
	..i BRLItemDR'="" s BRLEquipCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",BRLItemDR)),"^",4)
	.s BRLArriveDate=$p(BRLInfo,"^",19)
	.s BRLHold2=$p(BRLInfo,"^",28)
	.k BPLLIST
	.s BPLLIST(2) =BPRowID
	.s BPLLIST(3) =BRLName
	.s BPLLIST(4) =BRLModelDR
	.s BPLLIST(5) =BRLManuFacDR
	.s BPLLIST(6) =BRLTestFlag
	.s BPLLIST(7) =BRLPriceFee
	.s BPLLIST(8) =BRLQuantityNum
	.s BPLLIST(9) =BRLTotalFee
	.s BPLLIST(11)=BRLRowID
	.s BPLLIST(13)=User
	.s BPLLIST(14)=Date
	.s BPLLIST(15)=Time
	.s BPLLIST(16)=BRLCurrencyDR
	.s BPLLIST(17)=BRLEquipCatDR
	.s BPLLIST(19)=BRLItemDR
	.s BPLLIST(20)=BRLArriveDate
	.s BPLLIST(21)=BRLHold2
	.s BPLLIST(22)="N"
	.&sql(Insert Into SQLUser.DHC_EQBuyPlanList Values :BPLLIST())
	.q:SQLCODE
	.s BPLRowID=$Get(%ROWID)
	.s IFBLRowID=0
	.f  s IFBLRowID=$o(^DHCEQIFBList(0,"Source","1",BRLRowID,IFBLRowID)) q:(IFBLRowID="")||(SQLCODE'=0)  d
	..s IFBListInfo=$g(^DHCEQIFBList(IFBLRowID))
	..k IFBLPLIST
	..s IFBLPLIST(2) ="2"
	..s IFBLPLIST(3) =BPLRowID
	..s IFBLPLIST(4) =$p(IFBListInfo,"^",3)
	..s IFBLPLIST(5) =$p(IFBListInfo,"^",4)
	..s IFBLPLIST(6) =$p(IFBListInfo,"^",5)
	..s IFBLPLIST(7) =$p(IFBListInfo,"^",6)
	..s IFBLPLIST(8) =$p(IFBListInfo,"^",7)
	..s IFBLPLIST(9) =$p(IFBListInfo,"^",8)
	..s IFBLPLIST(10)=$p(IFBListInfo,"^",9)
	..s IFBLPLIST(11)=$p(IFBListInfo,"^",10)
	..s IFBLPLIST(12)=$p(IFBListInfo,"^",11)
	..s IFBLPLIST(13)=$p(IFBListInfo,"^",12)
	..s IFBLPLIST(14)=$p(IFBListInfo,"^",13)
	..s IFBLPLIST(16)=$p(IFBListInfo,"^",15)
	..s IFBLPLIST(17)=$p(IFBListInfo,"^",16)
	..s IFBLPLIST(18)=$p(IFBListInfo,"^",17)
	..s IFBLPLIST(19)=$p(IFBListInfo,"^",18)
	..s IFBLPLIST(20)=$p(IFBListInfo,"^",19)
	..s IFBLPLIST(21)=$p(IFBListInfo,"^",20)
	..s IFBLPLIST(22)=$p(IFBListInfo,"^",21)
	..s IFBLPLIST(23)=$p(IFBListInfo,"^",22)
	..s IFBLPLIST(24)=$p(IFBListInfo,"^",23)
	..s IFBLPLIST(25)=$p(IFBListInfo,"^",24)
	..s IFBLPLIST(26)=$p(IFBListInfo,"^",25)
	..s IFBLPLIST(27)=$p(IFBListInfo,"^",26)
	..s IFBLPLIST(28)=$p(IFBListInfo,"^",27)
	..s IFBLPLIST(29)=$p(IFBListInfo,"^",28)
	..s IFBLPLIST(30)=$p(IFBListInfo,"^",29)
	..s IFBLPLIST(31)=$p(IFBListInfo,"^",30)
	..s IFBLPLIST(32)=$p(IFBListInfo,"^",31)
	..s IFBLPLIST(33)=$p(IFBListInfo,"^",32)
	..s IFBLPLIST(34)=$p(IFBListInfo,"^",33)
	..&sql(Insert Into SQLUser.DHC_EQIFBList Values :IFBLPLIST())
	..q:SQLCODE
	
	If SQLCODE'=0
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	//modified by ZY0306 2766254
	;自动生成采购计划设备项必填的业务检测点控制 add by csj 2020-04-08 
	i (##Class(web.DHCEQ.Con.BUSContract).CheckMasterItem("92",BPRowID)=0)&&(+##class(web.DHCEQCommon).GetSysInfo("109002")=0)
	{
		TROLLBACK
		Set SQLCODE=-1002		//设备项信息为空
		Quit SQLCODE
	}
	
	;更新采购申请明细计划单ID
	&SQL(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR=:BPRowID where BRL_BuyRequestDR=:BRRowID and (BRL_BuyPlanDR is null or {fn LENGTH(BRL_BuyPlanDR)}=0))
	If SQLCODE
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	
	;更新采购计划单价、金额、数量
	Set SQLCODE=##class(web.DHCEQBuyPlanList).UpdateBuyPlan("","",BPRowID,1)
	If SQLCODE
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	
	;生成计划时是否自动提交计划	0:否1:是
	Set SubFlag=##class(web.DHCEQCommon).GetSysInfo("102001")
	If SubFlag="1"
	{
		Set SQLCODE=##class(web.DHCEQ.Plat.JsonObject).FromJSON(##Class(web.DHCEQ.EM.BUSBuyPlan).SubmitData(BPRowID_"^"_User)).SQLCODE
	}
	If (SQLCODE<0)
	{
		If TransFlag'="N" TROLLBACK
		Quit SQLCODE
	}
	If TransFlag'="N" TCOMMIT
	
	Quit SQLCODE
}

/// 检查是否有需要填写论证表但没有填写,填写的论证还需已通过审核
/// ReturnValue为0不需要或者已有论证 为1没?新壑?
/// ##class(web.DHCEQCommon).GetSysInfo("101001")	;设备单价超过设定需要论证表
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).CheckArgumentation(21)
ClassMethod CheckArgumentation(reqid, ActionCode As %Library.String = "")
{
	//New BRLID,flag,argvalue,desc
	s ReturnValue=0
	s flag=##class(web.DHCEQCommon).GetSysInfo("101003")	;论证是否必须	0：不限制  1：提示,  2：限制死
	//Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnValue,"")
	i flag=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnValue,"")
	s rowid=$Order(^DHCEQCCode("DHCEQCSysSet",0,"Code","101001",0))
	i rowid="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnValue,"")
	s argvalue=$Piece($Get(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2)
	s desc=$Piece($Get(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",3)
	i argvalue="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnValue,"")
	
	///modified by zy 20181031 ZY0174  根据采购指标模版来判断采购论证是否填报.
	Set BRLID=0
	For  Set BRLID=$Order(^DHCEQBuyRequestList(0,"BuyRequest",reqid,BRLID)) Quit:(BRLID="")||(ReturnValue'=0)  Do
	.Set Price=$Piece(^DHCEQBuyRequestList(BRLID),"^",6)
	.Quit:Price<argvalue
	.Set ARID=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLID,0))
	.If ARID="" Set ReturnValue=1
	.//s ReturnValue=##Class(web.DHCEQTemplate).CheckTemplate(3,BRLID,ActionCode)
	
	/*
	///友谊的临时采购申请不需要论证
	s YeatFlag=$Piece(^DHCEQBuyRequest(reqid),"^",3)
	Quit:YeatFlag="N" ReturnValue
	s desc=##Class(web.DHCEQTemplate).CheckTemplate(3,reqid,ActionCode)
	i desc'=0 q desc
	*/
	
	//i (ReturnValue=1)&&(flag>0) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1001",ReturnValue)
	;Quit:(ReturnValue=1)&&(flag=2) desc
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnValue,ReturnValue)
}

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

/// 增加输出信息modified by ZY20230106 bug:2971151
/// Creator：      WL
/// CreatDate：    2019-10-25
/// Description:   润乾打印(申购单)
/// Input：        BRRowid:设备采购ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyRequest","GetBuyRequestPrint","20")
Query GetBuyRequestPrint(BRRowid As %String = "") As %Query(ROWSPEC = "BRRequestNo:%String,BRRequestDate:%String,BRRequestLoc:%String,BRAddUser:%String,BRLHold1:%String,BRPrjName:%String,BRLHold2:%String,BRModel1:%String,BRModel2:%String,BRModel3:%String,BRManuFactory1:%String,BRManuFactory2:%String,BRManuFactory3:%String,BRQuantityNum:%String,BRPriceFee:%String,BRAmountFee:%String,BRLRequestReason:%String,BRLPurposeType:%String,BRLLimitYearsNum:%String,BRLHold5:%String,BRDRowID:%String,BRDCountNum:%String,BRDHold1:%String,ECRowID:%String,ECServiceIncome:%String,ECWorkLoadNum:%String,ECIncome:%String,ECOutFee:%String,ARRowID:%String,ARPolluteState:%String,AROtherState:%String,ARPersonnelState:%String,ARPlaceReform:%String") [ SqlProc ]
{
}

ClassMethod GetBuyRequestPrintExecute(ByRef qHandle As %Binary, BRRowid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	s (BRRequestNo,BRRequestDate,BRRequestLoc,BRAddUser,BRLHold1,BRPrjName,BRLHold2,BRManuFactoryStr,BRModelStr,BRModel1,BRModel2,BRModel3,BRManuFactory1,BRManuFactory2,BRManuFactory3,BRQuantityNum,BRPriceFee,BRAmountFee)=""
 	if (BRRowid'=""){
 	Set BRPrjName = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",1)
	Set BRRequestLocDR = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",2)
	If BRRequestLocDR '=""  Do
	.Set BRRequestLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", BRRequestLocDR)
	Set BRUseLocDR = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",4)
	If BRUseLocDR '=""  Do
	.Set BRUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", BRUseLocDR)
	Set BRYear = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",5)
	Set BRRequestDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",6),"date")
	Set BRQuantityNum = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",8)
	Set BRBTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",9),"")
	Set BRAddUserDR = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",28)
	If BRAddUserDR '=""  Do
	.Set BRAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", BRAddUserDR)
	Set BRAddDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",29),"date")
	Set BRUpdateUserDR = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",31)
	If BRUpdateUserDR '=""  Do
	Set BRRequestNo = $Piece($Get(^DHCEQBuyRequest(BRRowid)),"^",35)
	s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRRowid,0))
	s BRLName=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",2)		//modify by wl 2019-11-18  WL0012 begin 修正错误取值			
	s BRAduitNum=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",7)
	s BRLHold10=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",36) //预算单价			
	i BRLHold10'="" s BRLHold10=##class(web.DHCEQCommon).FormatNumber(BRLHold10,"")
	s BRAmountFee=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",8) 					
	i BRAmountFee'="" s BRAmountFee=##class(web.DHCEQCommon).FormatNumber(BRAmountFee,"")
	s BRLHold1=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",27)  //项目联系人
	///modified by ZY0301 20220523
	s BRLHold1 = ##Class(web.DHCEQCommon).GetTrakNameByID("user", BRLHold1)	//根据ID进行解析
	s BRLHold2=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",28) //联系电话
	s IFBLRowID=0
	For  Set IFBLRowID=$Order(^DHCEQIFBList(0,"Source",1,BRLRowID,IFBLRowID))  Quit:IFBLRowID=""  Do
	.s BRManuFactory=$Piece($Get(^DHCEQIFBList(IFBLRowID)),"^",5)	
	.s BRModel=$Piece($Get(^DHCEQIFBList(IFBLRowID)),"^",7)
	.i (BRModel'="")||(BRManuFactory'="") d 
	..s BRManuFactoryStr=BRManuFactory_"^"_BRManuFactoryStr  
	..s BRModelStr=BRModel_"^"_BRModelStr 							//modify by wl 2019-11-18 end  WL0012	修正错误
	s BRManuFactory1=$Piece(BRManuFactoryStr,"^",1)
	s BRManuFactory2=$Piece(BRManuFactoryStr,"^",2)
	s BRManuFactory3=$Piece(BRManuFactoryStr,"^",3)
	s BRModel1=$Piece(BRModelStr,"^",1)
	s BRModel2=$Piece(BRModelStr,"^",2)
	s BRModel3=$Piece(BRModelStr,"^",3)
	/// 增加输出信息modified by ZY20230106 bug:2971151
    s (BRLRequestReason,BRLPurposeType,BRLLimitYearsNum,BRLHold5,BRDRowID,BRDCountNum,BRDHold1,ECRowID,ECServiceIncome,ECWorkLoadNum,ECIncome,ECOutFee,ARRowID,ARPolluteState,AROtherState,ARPersonnelState,ARPlaceReform)=""
    s BRLRequestReason = $Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",18)    //申购理由
    s BRLPurposeTypeDR = $Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",23)
    s BRLPurposeType = ##Class(web.DHCEQCommon).GetTrakNameByID("purposetype", BRLPurposeTypeDR) //用途
    s BRLLimitYearsNum = $Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",26)+"年"    //使用年限
    s BRLHold5=$Piece($Get(^DHCEQBuyRequestList(BRLRowID)),"^",31) //设备功能(概要)
    s BRDRowID=$Order(^DHCEQBuyRequestDetail(0,"BuyRequestList",BRLRowID,""))
    i BRDRowID'=""
    {
        s BRDCountNum=$Piece($Get(^DHCEQBuyRequestDetail(BRDRowID)),"^",18)
        s BRDCountNum=##class(web.DHCEQCommon).FormatNumber(BRDCountNum,"",0)   //同类数量
        s BRDHold1=$Piece($Get(^DHCEQBuyRequestDetail(BRDRowID)),"^",25)        //使用状态
    }
    s ECRowID=$Order(^DHCEQEconCalc(0,"Source",1,BRLRowID,"Y",0))
    i ECRowID'=""
    {
        s ECServiceIncome=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",6)   //人次费用
        s ECWorkLoadNum=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",15)   //年工作量
        s ECIncome=ECServiceIncome*ECWorkLoadNum
        s ECIncome=##class(web.DHCEQCommon).FormatNumber(ECIncome,"",2)   //年收入
        
        s ECMaintFee=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",8)   //维修费
        s ECFeeOfEmployee=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",9)   //人员费
        s ECMaterialFee=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",10)   //耗材费
        s ECDepreFee=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",11)   //折旧费
        s ECBuildingFee=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",12)   //房屋折旧
        s ECEnergyFee=$Piece($Get(^DHCEQEconCalc(ECRowID)),"^",13)   //能源费
        s ECOutFee=ECMaintFee+ECFeeOfEmployee+ECMaterialFee+ECDepreFee+ECBuildingFee+ECEnergyFee
        s ECOutFee=##class(web.DHCEQCommon).FormatNumber(ECOutFee,"",2)   //年成本
    }
    //
    s ARRowID=$Order(^DHCEQArgumentation(0,"BuyRequestList",BRLRowID,0))
    i ARRowID'=""
    {
        s ARPolluteState=$Piece($Get(^DHCEQArgumentation(ARRowID)),"^",25)
        s AROtherState=$Piece($Get(^DHCEQArgumentation(ARRowID)),"^",26)
        s ARPersonnelState=$Piece($Get(^DHCEQArgumentation(ARRowID)),"^",27)
        s ARPlaceReform=$Piece($Get(^DHCEQArgumentation(ARRowID)),"^",39)
    }
    
    d OutputRowGetBuyRequestPrint
} 
    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK  
OutputRowGetBuyRequestPrint
 set Data=$lb(BRRequestNo,BRRequestDate,BRRequestLoc,BRAddUser,BRLHold1,BRLName,BRLHold2,BRModel1,BRModel2,BRModel3,BRManuFactory1,BRManuFactory2,BRManuFactory3,BRQuantityNum,BRLHold10,BRAmountFee,BRLRequestReason,BRLPurposeType,BRLLimitYearsNum,BRLHold5,BRDRowID,BRDCountNum,BRDHold1,ECRowID,ECServiceIncome,ECWorkLoadNum,ECIncome,ECOutFee,ARRowID,ARPolluteState,AROtherState,ARPersonnelState,ARPlaceReform) ////modify by wl 2019-11-18 end  WL0012   修正错误
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetBuyRequestPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetBuyRequestPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZY0204
/// CreatDate：    2019-12-27
/// Description:   采购明细查找
/// Input：        
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyRequest","GetBuyRequestDetail","","","2019","327","","","")
Query GetBuyRequestDetail(QXType As %String = "", YearFlag As %String = "", Year As %String = "", ManageLocDR As %String = "", RequestNo As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", UseLocDR As %String = "", Name As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYearFlag:%String,TUseLocDR:%String,TUseLoc:%String,TYear:%String,TRequestDate:%String,TStatus:%String,TManageLocDR:%String,TManageLoc:%String,TEquipTypeDR:%String,TEquipType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String,TRequestNo:%String,TBRLRowID:%String,TName:%String,TRequestNum:%String,TApproveNum:%String,TPrice:%String,TAmount:%String,THold1:%String,TRequestLoc:%String")
{
}

ClassMethod GetBuyRequestDetailExecute(ByRef qHandle As %Binary, QXType As %String = "", YearFlag As %String = "", Year As %String = "", ManageLocDR As %String = "", RequestNo As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", UseLocDR As %String = "", Name As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//s ^ZY="QXType="_QXType_",YearFlag="_YearFlag_",ManageLocDR="_ManageLocDR_",RequestNo"_RequestNo_",Status"_Status_",StartDate"_StartDate_",EndDate"_EndDate_",UseLocDR"_UseLocDR
	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") ;$ZDH(StartDate,4)
	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") ;$ZDH(EndDate,4)
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	i StartDate>EndDate q
	s index=1
	s RowID=0
	i Year'=""
	{
		f  s RowID=$o(^DHCEQBuyRequest(0,"Year",Year,RowID))  quit:RowID=""  d
		.s DataList=$g(^DHCEQBuyRequest(RowID))
		.d GetOneBuyRequestDetail
	}
	else
	{
		f  s RowID=$o(^DHCEQBuyRequest(RowID))  quit:RowID=""  d
		.s DataList=$g(^DHCEQBuyRequest(RowID))
		.d GetOneBuyRequestDetail
	}
	Quit $$$OK
GetOneBuyRequestDetail
	s (TRowID,TYearFlag,TUseLocDR,TUseLocDR,TYear,TRequestDate,TStatus,TManageLocDR,TManageLoc,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TRequestNo)=""
	q:$p(DataList,"^",45)="Y"
	s TRowID=RowID
	s TYearFlag=$p(DataList,"^",3)
	q:(YearFlag'="")&&(YearFlag'=TYearFlag)
	s TYearFlag=$CASE(TYearFlag,"Y":"年度计划","N":"日常计划",:"")  //add by lmm 2020-05-18 UI调整
	s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TYearFlag,"bool")
	s TUseLocDR=$p(DataList,"^",4)
	s TRequestLocDR=$p(DataList,"^",2)		//czf 2021-09-02
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))
	Set TRequestLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLocDR)
	q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	s TYear=$p(DataList,"^",5)
	q:(Year'="")&&(TYear'=Year)
	s TRequestDate=$p(DataList,"^",6)
	q:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TStatusDR=$p(DataList,"^",16)
	q:(Status'="")&&(TStatusDR'=Status)
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatusDR)
	s TManageLocDR=$p(DataList,"^",18)
	q:(ManageLocDR'="")&&(TManageLocDR'=ManageLocDR)
	s TManageLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TManageLocDR)
	s TEquipTypeDR=$p(DataList,"^",25)
	//q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	//q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	s TPurchaseTypeDR=$p(DataList,"^",26)
	//q:(PurchaseTypeDR'="")&&(TPurchaseTypeDR'=PurchaseTypeDR)
	i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TRequestNo=$p(DataList,"^",35)
	q:(RequestNo'="")&&(RequestNo'[TRequestNo)
	s THold1=$p(DataList,"^",17)			//czf 2021-05-20 1837956
	s BRLRowID=0
	f  s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",TRowID,BRLRowID)) q:BRLRowID=""  d
	.s (TBRLRowID,TName,TRequestNum,TApproveNum,TPrice,TAmount)=""
	.s TBRLRowID=BRLRowID
	.s TName=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)
	.q:(Name'="")&&(Name'[TName)
	.s TModel=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",3)
	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.s TRequestNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",20)
	.s TPrice=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",36)
	.s (BRAIRowID,TApproveNum)=""
	.s BRAIStep=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,""),-1)
	.i BRAIStep'="" s BRAIRowID=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,BRAIStep,0))
	.i BRAIRowID'="" d
	..s TApproveNum=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",4)
	..s TPrice=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",5)
	..s TAmount=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",6)
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"") //add by lmm 2020-05-18 UI调整
	.s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	.d OutputRowGetBuyRequestDetail
	quit
OutputRowGetBuyRequestDetail
	s Data=$lb(TRowID,TYearFlag,TUseLocDR,TUseLoc,TYear,TRequestDate,TStatus,TManageLocDR,TManageLoc,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TRequestNo,TBRLRowID,TName,TRequestNum,TApproveNum,TPrice,TAmount,THold1,TRequestLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBuyRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestDetailExecute ]
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

ClassMethod GetBuyRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY20230307 bug:3287219
/// modified by ZY20230105 bug:3187237
/// add by ZY0260 20210428
/// 论证工作量的80%与符合条件设备的每年工作量比较,小一次计数1，同时统计所有设备效益分析年度次数
/// 最后看符合的次数与总计数的百分比是否大于60%
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).BenefitContrast("2^1^")
ClassMethod BenefitContrast(EquipCatID, UseLocID As %String = "", WorkLoadNum As %String = "", AvgFlag As %String = "")
{
    new Flag,total,totalCount,Num,EquipID,EquipData,EquipCatDR,UseLocDR,UCYear,UCMonth,UseContextData,TPersonTime,TActualWorkLoad,sumYearPersonTime,sumActualWorkLoad
    s WorkLoadNum=WorkLoadNum*0.8
    s (Flag,total,totalCount,Rate,Num,AvgValue)=0
 	s EquipID=0
 	f  s EquipID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID)) q:(EquipID="")  d
 	.s EquipData=$g(^DHCEQEquip(EquipID))
 	.s EquipCatDR=$p(EquipData,"^",4)
	.//modified by ZY20230209 bug:3245479
 	.q:(EquipCatID'="")&&(EquipCatID'=EquipCatDR)&&(##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatID,EquipCatDR)=0)
 	.s UseLocDR=$p(EquipData,"^",18)
 	.q:(UseLocID'="")&&(UseLocID'=UseLocDR)
    .s Num=Num+1
 	.s UCYear=0
	.f  s UCYear=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear)) q:(UCYear="")  d
	..s (sumYearPersonTime,sumActualWorkLoad)=0
	..s UCMonth=""
	..f  s UCMonth=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear,UCMonth)) q:(UCMonth="")  d
	...s UCRowID=0
	...f  s UCRowID=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear,UCMonth,UCRowID)) q:(UCRowID="")  d
	....s UseContextData=$g(^DHCEQUseContext(UCRowID))
	....s TPersonTime=$p(UseContextData,"^",20)  	//检查人次
	....s TActualWorkLoad=$p(UseContextData,"^",21) //实际工作量
	....s sumYearPersonTime=sumYearPersonTime+TPersonTime
	....s sumActualWorkLoad=sumActualWorkLoad+TActualWorkLoad
	..i sumActualWorkLoad>WorkLoadNum s totalCount=totalCount+1
	..s total=total+1
    i AvgFlag=1
    {
        i total>0
        {
            s AvgValue=##Class(web.DHCEQCommon).FormatNumber((sumActualWorkLoad/total),"")
        }
        
        s objInfo=##class(web.DHCEQ.Plat.JsonObject).%New()  
        d objInfo.%Set("Num",Num)
        d objInfo.%Set("AvgValue",AvgValue)
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
    }
    else
    {
        ///modified by ZY0266 20210531
 	i total>0
 	{
	 	s Rate=##Class(web.DHCEQCommon).FormatNumber(((totalCount*100)/total),"")
	 	///modified by ZY0279 20210907
	 	i Rate<60
	 	{
			if (##class(web.DHCEQCommon).GetSysInfo("101003")<2)
			{
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("1","效益预测与效益分析严重不符")
			}
			else
			{
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","效益预测与效益分析严重不符!")
			}
		}
	}
	else
	{
        //modified by ZY 20221213 bug2889172
        s UseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocID)
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("1",UseLoc_"没有同类设备做效益预测")
    }
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Flag)
    }
}

/// Creator:	czf 1837956
/// CreateDate:	2021-05-14
/// Descript:	设备采购申请明细
/// Input:		RowID:BRRowID
/// Output:		
/// Command:	d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyRequest","GetBuyRequestList","1")
Query GetBuyRequestList(RowID As %String, Step As %String = "") As %Query(ROWSPEC = "BRLRow:%String,BRLRowID:%String,BRLBuyRequestDR:%String,BRLName:%String,BRLModelDR:%String,BRLModelDR_MDesc:%String,BRLPriceFee:%String,BRLQuantityNum:%String,BRLTotalFee:%String,BRLRemark:%String,BRLAdviseModel:%String,BRLItemDR:%String,BRLItemDR_MIDesc:%String,BRLRequestReason:%String,BRLRequestNum:%String,BRLFundsOriginDR:%String,BRLFundsOriginDR_FTDesc:%String,BRLPurchaseTypeDR:%String,BRLPurchaseTypeDR_PTDesc:%String,BRLPurposeTypeDR:%String,BRLPurposeTypeDR_PTDesc:%String,BRLUnitDR:%String,BRLUnitDR_UOMDesc:%String,BRLManuFacDR:%String,BRLManuFacDR_MFDesc:%String,BRLHold10:%String,BRAIRowID:%String,BRAIAuditQuantity:%String,BRAIAuditPrice:%String,BRAIAuditTotalFee:%String,BRAIHold1:%String,BRAIHold2:%String,BRAIHold3:%String,BRAIHold4:%String,BRAIHold5:%String")
{
}

ClassMethod GetBuyRequestListExecute(ByRef qHandle As %Binary, RowID As %String, Step As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	
	if RowID'=""  d
	.s rowid=0 
	.f  s rowid=$o(^DHCEQBuyRequestList(0,"BuyRequest",RowID,rowid))  quit:rowid=""  d
	..d ResetGetBuyRequestList
	..s BRLRowID=rowid
	..s BRLBuyRequestDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",1)
	..s BRLName=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)
	..s BRLModelDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",3)
	..s BRLModel=##class(web.DHCEQCommon).GetTrakNameByID("model",BRLModelDR)
	..s BRLManuFacDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",4)
	..s BRLManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",BRLManuFacDR)
	..s BRLTestFlag=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",5)
	..s BRLPriceFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyRequestList(BRLRowID)),"^",6),"",2)
	..s BRLQuantityNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",7)
	..s BRLTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyRequestList(BRLRowID)),"^",8),"",2)
	..s BRLRemark=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",9)
	..s BRLEquipCatDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",15)
	..s BRLEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",BRLEquipCatDR)
	..s BRLAdviseModel=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",16)
	..s BRLItemDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",17)
	..s BRLItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",BRLItemDR)
	..s BRLRequestReason=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",18)
	..s BRLRequestNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",20)
	..s BRLFundsOriginDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",21)
	..s BRLFundsOrigin=##class(web.DHCEQCommon).GetTrakNameByID("fundstype",BRLFundsOriginDR)
	..s BRLPurchaseTypeDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",22)
	..s BRLPurchaseType=##class(web.DHCEQCommon).GetTrakNameByID("purchase",BRLPurchaseTypeDR)
	..s BRLPurposeTypeDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",23)
	..s BRLPurposeType=##class(web.DHCEQCommon).GetTrakNameByID("purposetype",BRLPurposeTypeDR)
	..s BRLUnitDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",24)
	..s BRLUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",BRLUnitDR)
	..s BRLStatCatDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",25)
	..s BRLStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",BRLStatCatDR)
	..s BRLLimitYearsNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",26)
	..s BRLHold1=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",27)	//科室负责人
	..s BRLHold2=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",28)	//科室负责人电话
	..s BRLHold3=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",29)	//经办人
	..s BRLHold4=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",30)	//经办人电话
	..s BRLHold10=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",36)	//申请单价
	..i +Step>0 d
	...s BRAIRowID=$Order(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,Step,0))
	...i BRAIRowID'="" d
	....s BRAIAuditQuantity=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",4)
	....s BRAIAuditPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",5),"",2)
	....s BRAIAuditTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",6),"",2)
	....s BRAIHold1=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",7)
	....s BRAIHold2=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",8)
	....s BRAIHold3=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",9)
	....s BRAIHold4=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",10)
	....s BRAIHold5=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",11)
	...e  d		//当前步骤无审批记录，显示最近一次审批数量信息
	....s FindBRAIRowID=""
	....s ALRowID=0
	....f  s ALRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,RowID,ALRowID)) q:(ALRowID="")||(FindBRAIRowID'="")  d
	.....q:$p($g(^DHCEQApproveList(ALRowID)),"^",10)'="N"
	.....s ALStep=$p($g(^DHCEQApproveList(ALRowID)),"^",9)
	.....s CurBRAIRowID=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,ALStep,0))
	.....q:CurBRAIRowID=""
	.....s FindBRAIRowID=CurBRAIRowID
	....i FindBRAIRowID'="" d
	.....s BRAIAuditQuantity=$p($g(^DHCEQBuyReqAuditInfo(FindBRAIRowID)),"^",4)
	.....s BRAIAuditPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyReqAuditInfo(FindBRAIRowID)),"^",5),"",2)
	.....s BRAIAuditTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyReqAuditInfo(FindBRAIRowID)),"^",6),"",2)
	..e  d
	...i $p($g(^DHCEQBuyRequest(RowID)),"^",16)=2 d		;审核状态显示明细中的审批数量信息
	....s BRAIAuditQuantity=BRLQuantityNum
	....s BRAIAuditPrice=BRLPriceFee
	....s BRAIAuditTotalFee=BRLTotalFee
	..s TRow=TRow+1
	..d OutputGetBuyRequestList
	
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetGetBuyRequestList
	.s TRow=1
	.d OutputGetBuyRequestList
	
	Quit $$$OK
	
OutputGetBuyRequestList
	s Data=$lb(TRow,BRLRowID,BRLBuyRequestDR,BRLName,BRLModelDR,BRLModel,BRLPriceFee,BRLQuantityNum,BRLTotalFee,BRLRemark,BRLAdviseModel,BRLItemDR,BRLItem,BRLRequestReason,BRLRequestNum,BRLFundsOriginDR,BRLFundsOrigin,BRLPurchaseTypeDR,BRLPurchaseType,BRLPurposeTypeDR,BRLPurposeType,BRLUnitDR,BRLUnit,BRLManuFacDR,BRLManuFac,BRLHold10,BRAIRowID,BRAIAuditQuantity,BRAIAuditPrice,BRAIAuditTotalFee,BRAIHold1,BRAIHold2,BRAIHold3,BRAIHold4,BRAIHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetBuyRequestList
	s (BRLRowID,BRLBuyRequestDR,BRLName,BRLModelDR,BRLModel,BRLManuFacDR,BRLManuFac,BRLTestFlag,BRLPriceFee,BRLQuantityNum,BRLTotalFee,BRLRemark,BRLEquipCatDR,BRLEquipCat,BRLAdviseModel)=""
	s (BRLItemDR,BRLItem,BRLRequestReason,BRLRequestNum,BRLFundsOriginDR,BRLFundsOrigin,BRLPurchaseTypeDR,BRLPurchaseType,BRLPurposeTypeDR,BRLPurposeType,BRLUnitDR,BRLUnit,BRLStatCatDR,BRLStatCat,BRLLimitYearsNum,BRLHold1,BRLHold2,BRLHold3,BRLHold4,BRLHold10)=""
	s (BRAIRowID,BRAIAuditQuantity,BRAIAuditPrice,BRAIAuditTotalFee,BRAIHold1,BRAIHold2,BRAIHold3,BRAIHold4,BRAIHold5)=""
	quit
}

ClassMethod GetBuyRequestListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestListExecute ]
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

ClassMethod GetBuyRequestListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by czf 2021-05-16 1837956
/// 描述:批量保存采购申请单
/// w ##class(web.DHCEQ.EM.BUSBuyRequest).SaveBatchData("{""BWProjectNo"":""BW2020110001"",""BWProjectName"":""2367"",""BWTotalFee"":""240000"",""BWManageLocDR_CTLOCDesc"":""医疗设备科"",""BWHandlerDR_SSUSRName"":""Demo Group"",""BWHandlerMobile"":""13006173195"",""BWProjectType"":""1"",""BWProjectProperty"":""3"",""BWEquipTypeDR_ETDesc"":""专用设备"",""BWLocDirectorDR_SSUSRName"":""indoctor"",""BWBuyTypeDR_BTDesc"":""院内招标"",""BWGovItemName"":""88888"",""BWGovItemNo"":""883278"",""BWBuyDirectorDR_SSUSRName"":""nurse"",""BWIssuingDate"":""2020-11-29"",""BWRowID"":""1"",""BWStatus"":""0"",""Job"":"""",""BWEquipTypeDR"":""3"",""BWType"":""1"",""BWQuantityNum"":""2"",""QXType"":"""",""Type"":"""",""flag"":"""",""RoleStep"":""0"",""CurRole"":"""",""NextFlowStep"":"""",""ApproveSetDR"":"""",""NextRoleDR"":"""",""CancelFlag"":"""",""CancelToFlowDR"":"""",""ApproveStatus"":"""",""ApproveTypeCode"":""34"",""ApproveRoleDR"":"""",""WaitAD"":""off"",""SplitNumCode"":""$CHAR(4)"",""SplitRowCode"":""$CHAR(3)"",""PrintFlag"":""1"",""BWLSourceType"":"""",""BWManageLocDR"":""202"",""BWHandlerDR"":""1"",""BWLocDirectorDR"":""10"",""BWBuyDirectorDR"":""9"",""BWBuyTypeDR"":""2"",""GetComponentID"":""262"",""ReadOnly"":"""",""BWRemark"":""6666"",""BWSpecialCase"":""77777"",""BWSameCondition"":""99999"",""BWHold1"":""0989"",""BWPurchasing"":""232323"",""EditOpinion"":"""",""RejectReason"":""""}","{""BWLRow"":""1"",""BWLRowID"":""2"",""BWLBuyWayDR"":""1"",""BWLSourceType"":""1"",""BWLSourceTypeDesc"":""采购申请"",""BWLSourceID"":""3"",""BWLSourceIDDesc"":""便携式彩色超声诊断系统"",""BWLName"":""便携式彩色超声诊断系统"",""BWLModelDR"":"""",""BWLModelDR_MDesc"":"""",""BWLManuFacDR"":""12"",""BWLManuFacDR_MFDesc"":""成都肯格王三氧电器设备有限公司"",""BWLPriceFee"":""120000.00"",""BWLQuantityNum"":""1"",""BWLTotalFee"":120000,""BWLRemark"":""5878"",""BWLHold1"":"""",""BWLHold2"":"""",""BWLHold3"":"""",""BWLHold4"":"""",""BWLHold5"":""""}","3","78")
ClassMethod SaveBatchData(val As %Library.String = "", list As %Library.String = "", DelRowid As %Library.String = "", User As %String = "")
{
	Kill PLIST,LIST,rowid,Rowid
	Set $ZT="ERRORUpdateData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyRequest",JsonData,.PLIST)
	s rowid = JsonData.BRRowID
	Set BRRowID=rowid
	Set PLIST(46)="N"
	Set PLIST(18)="Y"	;批量标志
	
	i rowid'=""
	{
		s InvalidFlag=$p($g(^DHCEQBuyRequest(rowid)),"^",45)
		i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("","无效单据")
	}
	TStart
	If (rowid="")  //新增按钮操作
	{
		i PLIST(6) = "" s PLIST(6)=$p($zd(+$H,3),"-",1)	//BR_Year
	 	Set PLIST(17)=	0		// BR_Status
	 	Set PLIST(29)=	User	// BR_AddUserDR
		Set PLIST(30)=	updDate	// BR_AddDate
		Set PLIST(31)=	updTime	// BR_AddTime
		Set PLIST(32)=	User	// BR_UpdateUserDR
		Set PLIST(33)=	updDate	// BR_UpdateDate
		Set PLIST(34)=	updTime	// BR_UpdateTime
	 	Set PLIST(36)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyRequest",$h,"",JsonData.BREquipTypeDR)
	 	&SQL(Insert Into SQLUSER.DHC_EQBuyRequest Values :PLIST())
	}
	Else  //更新按钮操作
	{
		i PLIST(6) = "" s PLIST(6)=$p($zd(+$H,3),"-",1)	//BR_Year
		Set PLIST(32)=	User	// BR_UpdateUserDR
		Set PLIST(33)=	updDate	// BR_UpdateDate
		Set PLIST(34)=	updTime	// BR_UpdateTime
		&SQL(Update SQLUSER.DHC_EQBuyRequest Values :PLIST() where BR_RowID = :BRRowID)
	}
	
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	}
	Set rowid=$Get(%ROWID)
	
	Set (BRQuantityNum,BRTotalFee)=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$Length(list,SplitRowCode)
	For i=1:1:Length  q:SQLCODE'=0  d
	.K LIST
	.Set valList= $Piece(list,SplitRowCode,i)
	.s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	.s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyRequestList",JsonData,.LIST)
	.s BRLRowid = JsonData.BRLRowID
	.s LIST(2)=rowid
	.s BRQuantityNum=BRQuantityNum+JsonData.BRLRequestNum
	.s BRTotalFee=BRTotalFee+(JsonData.BRLRequestNum*JsonData.BRLHold10)
	.If (BRLRowid="")  d
	..&SQL(Insert Into SQLUSER.DHC_EQBuyRequestList Values :LIST())
	.Else  d
	..&SQL(Update SQLUSER.DHC_EQBuyRequestList Values :LIST() where BRL_RowID = :BRLRowid)
	.q:SQLCODE'=0
	.Set BRLRowid=$Get(%ROWID)
	
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	}
		
	;删除明细
	Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyRequest).DeleteBRList(DelRowid)
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	}
	
	;更新申请单数量、金额
	&SQL(Update SQLUSER.DHC_EQBuyRequest Set BR_QuantityNum=:BRQuantityNum,BR_TotalFee=:BRTotalFee where BR_RowID = :rowid)
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)

ERRORUpdateData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Add by czf 2021-05-16 1837956
/// 描述:删除采购申请明细
/// w ##Class(web.DHCEQ.EM.BUSBuyRequest).DeleteBRList(",0,0,0")
ClassMethod DeleteBRList(DelRowIDs)
{
	new (Length,BPLRowID,Flag,i,DelRowIDs)
	If DelRowIDs="" Quit 0
	
	Set Flag=0
	Set Length=$Length(DelRowIDs,",")
	for i=1:1:Length
	{
		Quit:Flag'=0
		Set BRLRowID=$Piece(DelRowIDs,",",i)
		If (+BRLRowID>0)
		{
			&SQL(delete from sqluser.DHC_EQBuyRequestList where BRL_RowID=:BRLRowID)
			If SQLCODE Set Flag=SQLCODE
		}
	}
	Quit Flag
}

/// Creator:	czf 1837956
/// CreateDate:	2021-05-18 
/// Descript:	采购申请数量价格审批记录
/// Input:		RowID:BRRowID
/// Output:		
/// Command:	d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyRequest","GetBuyReqAuditInfo","14")
Query GetBuyReqAuditInfo(BRLRowID As %String) As %Query(ROWSPEC = "TRow:%String,BRAIRowID:%String,BRAIActionDR:%String,BRAIAction:%String,BRAIAuditQuantity:%String,BRAIAuditPrice:%String,BRAIAuditTotalFee:%String,BRAIHold1:%String,BRAIHold2:%String,BRAIHold3:%String,BRAIHold4:%String,BRAIHold5:%String,ALApproveUser:%String,ALApproveDate:%String")
{
}

ClassMethod GetBuyReqAuditInfoExecute(ByRef qHandle As %Binary, BRLRowID As %String) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	
	i BRLRowID="" Quit $$$OK
	s Step=""
	f  s Step=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,Step)) q:Step=""  d
	.s BRAIRowID=""
	.f  s BRAIRowID=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",BRLRowID,Step,BRAIRowID)) q:BRAIRowID=""  d
	..d ResetGetBuyReqAuditInfo
	..s BRRowID=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",1)
	..s BRAIActionDR=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",3)
	..i BRAIActionDR'="" s BRAIAction=$p($g(^DHCEQCCode("DHCEQCAction",BRAIActionDR)),"^",2)
	..s BRAIAuditQuantity=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",4)
	..s BRAIAuditPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",5),"",2)
	..s BRAIAuditTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",6),"",2)
	..s BRAIHold1=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",7)
	..s BRAIHold2=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",8)
	..s BRAIHold3=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",9)
	..s BRAIHold4=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",10)
	..s BRAIHold5=$p($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",11)
	..s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	..s ALRowID=$o(^DHCEQApproveList(0,"Step",ApproveType,BRRowID,Step,""),-1)	//取最近一次审批信息
	..i ALRowID'="" d
	...s ALApproveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQApproveList(ALRowID)),"^",6))
	...s ALApproveDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(ALRowID)),"^",7),"date")
	...s ALApproveTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(ALRowID)),"^",8),"time")
	...s ALApproveDate=ALApproveDate_" "_ALApproveTime
	..s TRow=TRow+1
	..d OutputGetBuyReqAuditInfo
	
	Quit $$$OK
	
OutputGetBuyReqAuditInfo
	s Data=$lb(TRow,BRAIRowID,BRAIActionDR,BRAIAction,BRAIAuditQuantity,BRAIAuditPrice,BRAIAuditTotalFee,BRAIHold1,BRAIHold2,BRAIHold3,BRAIHold4,BRAIHold5,ALApproveUser,ALApproveDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetBuyReqAuditInfo
	s (BRRowID,BRAIActionDR,BRAIAction,BRAIAuditQuantity,BRAIAuditPrice,BRAIAuditTotalFee,BRAIHold1,BRAIHold2,BRAIHold3,BRAIHold4,BRAIHold5,ALApproveUser,ALApproveDate,ALApproveTime)=""
	quit
}

ClassMethod GetBuyReqAuditInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyReqAuditInfoExecute ]
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

ClassMethod GetBuyReqAuditInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyReqAuditInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      MWZ0051
/// CreatDate：    2021-06-29
/// Description:   提交状态采购单同类数量
/// Input：  UseLocDR 科室ID       Name：设备名称   rowid:申请单RowID
/// w ##class(web.DHCEQ.EM.BUSBuyRequest).GetRequestNum("2","验钞机")
ClassMethod GetRequestNum(UseLocDR As %String = "", Name As %String = "", rowid As %String = "")
{
	i (UseLocDR="")||(Name="") q 0
	s TotalNum=0
	s BRRowID=""
	f  s BRRowID=$o(^DHCEQBuyRequest(BRRowID))  quit:BRRowID=""  d
	.s TUseLocDR=$p(^DHCEQBuyRequest(BRRowID),"^",4)
	.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	.q:(rowid'="")&&(rowid'=BRRowID)  //过滤当前单据
	.s TStatusDR=$p(^DHCEQBuyRequest(BRRowID),"^",16)
	.q:TStatusDR'=1
	.s BRLRowID=0
	.f  s BRLRowID=$o(^DHCEQBuyRequestList(0,"BuyRequest",BRRowID,BRLRowID)) q:BRLRowID=""  d
	..s TName=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)
	..s TNum=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",7)
	..q:(Name'="")&&(Name'=TName)
	..s TotalNum=TotalNum+TNum
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(TotalNum)
}

/// Creator：      ZY0292
/// CreatDate：    2022-01-21
/// Description:   判断采购申请是否已经生成计划单
/// Input：  BRLRowID 采购申请明细ID      Num：申请数量 
/// w ##class(web.DHCEQ.EM.BUSBuyRequest).IsInBuyPlan("1","5")
ClassMethod IsInBuyPlan(BRLRowID As %String = "", Num As %String = "")
{
	i (BRLRowID="") q 0
	s flag=0
	s BPLRowID=""
	f  s BPLRowID=$o(^DHCEQBuyPlanList(0,"BuyRequestList",BRLRowID,BPLRowID))  quit:(BPLRowID="")||(flag=1)  d
	.s BPRowID=$p(^DHCEQBuyPlanList(BPLRowID),"^",1)
	.s InvalidFlag=$p(^DHCEQBuyPlan(BPRowID),"^",46)
	.q:InvalidFlag="Y"
	.s QuantityNum=$p(^DHCEQBuyPlanList(BPLRowID),"^",7)
	.i QuantityNum=Num s flag=1
	Quit flag
}

}
