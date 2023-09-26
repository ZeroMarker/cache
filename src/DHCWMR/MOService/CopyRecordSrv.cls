/// 名称: DHCWMR.MOService.CopyRecordSrv
/// 描述: 病案复印相关服务
/// 编写者：liyi
/// 编写日期: 2015-08-10
Class DHCWMR.MOService.CopyRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-11-13
/// Description:  保存病历复印收费信息
/// Input：       aCopyID  ：复印ID
/// 			  aFeeInfo ：收费信息
/// Return：      返回String
/// w ##class(DHCWMR.MOService.CopyRecordSrv).SaveCopyFee(1,"1^9^117^12")
ClassMethod SaveCopyFee(aCopyID As %String, aFeeInfo As %String) As %String
{
	New (aCopyID,aFeeInfo)
	Set return=0
	Quit:(aCopyID="")||(aFeeInfo="") return
	
	Set PayModeID=$p(aFeeInfo,"^",1)   //支付方式
	Set UserID=$p(aFeeInfo,"^",2)      //用户ID
	Set LocID=$p(aFeeInfo,"^",3)       //科室ID
	Set GroupID=$p(aFeeInfo,"^",4)     //安全组ID
	Quit:(PayModeID="")||(UserID="")||(LocID="")||(GroupID="") return
	
	Set objCopy = ##class(DHCWMR.MO.CopyRecord).GetObjById(aCopyID)
	Quit:'$IsObject(objCopy) return
	Set PaperNumber = objCopy.CRPaperNumber
	Quit:PaperNumber="" return
	Quit:'$IsObject(objCopy.CRMainDr) return
	Quit:'$IsObject(objCopy.CRMrType) return
	Set MainID=objCopy.CRMainDr.%Id()
	Set MrTypeID=objCopy.CRMrType.%Id()
	
	Set objMFItem=##Class(DHCWMR.MF.FeeItem).GetObjByCode("FY")  //取病案复印收费项目
	Quit:'$IsObject(objMFItem) return
	Set MFItemID=objMFItem.%Id()
	
	//复印收费参数设置（0不收费、1病案收费、2计费收费）
	Set HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LocID)
	Set CopyFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByCopy",HospID)
	Set CopyFeeType=+CopyFeeType
	If CopyFeeType=0 {  //不收费
		Set return=1
		Quit return
	} ElseIf CopyFeeType=1 {  //病案收费
		Set MFPrice=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MrCopyPrice",HospID)
		Quit:MFPrice="" return
		Set MFAmount= $fn(MFPrice*PaperNumber,"",2)
		Set DtlInfo = "$^"_MFAmount_"^"_1
	} ElseIf CopyFeeType=2 {  //计费收费
		Set MFPrice=##class(DHCWMR.MF.FeeItem).GetMFPrice(MFItemID,MrTypeID,HospID)
		Quit:MFPrice="" return
		Set MFAmount=0
		Set DtlInfo=""
		For indT=1:1:$l(MFPrice,"$") {
			Set TariInfo=$p(MFPrice,"$",indT)
			Continue:TariInfo=""
			Set TarItemID=$p(MFPrice,"^",1)
			Set TarItemCode=$p(MFPrice,"^",2)
			Set TarItemDesc=$p(MFPrice,"^",3)
			Set TarItemPrice=+$p(MFPrice,"^",4)
			Set MFAmount=MFAmount+TarItemPrice*PaperNumber
			Set TarItemPrice=$fn(TarItemPrice,"",2)
			Set DtlInfo=DtlInfo_"$"_TarItemID_"^"_TarItemPrice_"^"_PaperNumber
		}
		Set:DtlInfo'="" DtlInfo=$e(DtlInfo,2,$l(DtlInfo))
		Set MFAmount=$fn(MFAmount,"",2)
	}
	
	Set MainInfo=""
	Set $p(MainInfo,"^",1)=MainID    //病案ID
	Set $p(MainInfo,"^",2)=MFItemID  //收费项
	Set $p(MainInfo,"^",3)=MFAmount  //总金额
	Set $p(MainInfo,"^",4)=PayModeID //支付方式
	Set $p(MainInfo,"^",5)=UserID    //用户ID
	Set $p(MainInfo,"^",6)=LocID     //科室ID
	Set $p(MainInfo,"^",7)=GroupID   //安全组ID
	Set flg=##class(DHCWMR.MFService.FeeRecordSrv).SaveFeeInfo(MainInfo,DtlInfo)
	If (+flg)>0 {
		Set MFFeeID=+flg
		Set MOFeeID=$o(^DHCWMR.MO.CopyRecordI("FEE","IndexRecordDr",MFFeeID,0))
		Set InputStr =MOFeeID_"^"_aCopyID_"^"_MFFeeID
		Set flg=##class(DHCWMR.MO.CopyRecordFee).Update(InputStr,"^")
		If (+flg)>0{
			Set return=+flg  //DHCWMR.MO.CopyRecord.ID
		} Else {
			Set return=-2
		}
	} Else {
		Set return=-1
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-13
/// Description:  退病历复印费
/// Input：       aCopyID ：复印ID
///               aUserID ：用户ID
///               aLocID ：科室ID
/// Return：      返回String
/// w ##class(DHCWMR.MOService.CopyRecordSrv).RetCopyFee(1,9,117)
ClassMethod RetCopyFee(aCopyID As %String, aUserID As %String, aLocID As %String) As %String
{
	New (aCopyID,aUserID,aLocID)
	Set return=0
	Quit:(aCopyID="")||(aUserID="")||(aLocID="") return
	
	Set objCopy=##class(DHCWMR.MO.CopyRecord).GetObjById(aCopyID)
	Quit:'$IsObject(objCopy) return
	
	Set return=1
	Set xFeeSub="",RecordID=""
	For {
		Set xFeeSub=$o(^DHCWMR.MO.CopyRecordD(aCopyID,"FEE",xFeeSub))
		Quit:xFeeSub=""
		
		Set objCRFee=##class(DHCWMR.MO.CopyRecordFee).GetObjById(aCopyID_"||"_xFeeSub)
		Continue:'$IsObject(objCRFee)
		Continue:'$IsObject(objCRFee.CRFRecordDr)
		Set FeeStatus=objCRFee.CRFRecordDr.FRStatus
		Continue:FeeStatus'="N" //检查是否正常收费记录
		Set RecordID=objCRFee.CRFRecordDr.%Id()
		
		Set flg=##class(DHCWMR.MFService.FeeRecordSrv).RetFeeInfo(RecordID,aUserID,aLocID)
		If (+flg)<1 {
			Set return=-1  //退费失败
			Quit
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-12
/// Description:  北京同仁病案复印入口 （收费登记装订合并一步完成）
/// Input：		  aOperType:操作类型
/// 			  aCopyInfo:复印信息
/// 			  aFeeInfo:收费信息
/// 			  aSeparate:分隔符
/// Return：      成功：DHCWMR.MO.CopyRecord.ID,失败<1
/// w ##class(DHCWMR.MOService.CopyRecordSrv).CopyOper01("CH","^1^1^123^81^89^123^123^123^4#14^4^^45","1^9^117^118^2","^")
ClassMethod CopyOper01(aOperType As %String, aCopyInfo As %String, aFeeInfo As %String, aSeparate As %String)
{
	New (aOperType,aCopyInfo,aFeeInfo,aSeparate)
	Set return = 0
	Quit:(aOperType="")||(aCopyInfo="")||(aFeeInfo="")||(aSeparate="") return
	
	//Set ^LIYI=$lb(aOperType,aCopyInfo,aFeeInfo,aSeparate)
	
	//add by mxp 2016-05-04 收费前检查用户是否有可用发票
	Set return="-99"
	Set Flag=##class(DHCWMR.MFService.FeeRecordSrv).CheckInsertMedical("FY",aFeeInfo)
	Quit:+Flag=0 Flag
	
    Set CopyID 			= $p(aCopyInfo,aSeparate,1)
	Set MainID 			= $p(aCopyInfo,aSeparate,2)
	Set VolumeIDs 		= $p(aCopyInfo,aSeparate,3)
	Set ClientName 		= $p(aCopyInfo,aSeparate,4)
	Set ClientRelation 	= $p(aCopyInfo,aSeparate,5)
	Set CardType 		= $p(aCopyInfo,aSeparate,6)
	Set PersonalID 		= $p(aCopyInfo,aSeparate,7)
	Set Telephone 		= $p(aCopyInfo,aSeparate,8)
	Set Address 		= $p(aCopyInfo,aSeparate,9)
	Set Content 		= $p(aCopyInfo,aSeparate,10)
	Set Purpose 		= $p(aCopyInfo,aSeparate,11)
	Set CopyResume 		= $p(aCopyInfo,aSeparate,12)
	Set PaperNumber		= $p(aCopyInfo,aSeparate,13)
	Quit:(MainID="")||(VolumeIDs)="" return
	
	Set PayModeID 	= $p(aFeeInfo,aSeparate,1)
	Set UserID 		= $p(aFeeInfo,aSeparate,2)
	Set LocID 		= $p(aFeeInfo,aSeparate,3)
	Set GroupID 	= $p(aFeeInfo,aSeparate,4)
	Set HospID 		= $p(aFeeInfo,aSeparate,5)
	Quit:(UserID="")||(LocID="")||(GroupID="")||(HospID="") return
	
	Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	
	Set MrNo = objMain.SMMrNo
	Set MrTypeID  = objMain.SMMrType.%Id()
	Set SerialNumber = ##class(DHCWMR.MO.CopyRecord).GetSerialNumber()
	Quit:SerialNumber<1 return
	
	Set BatchNumber = ##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"CF")
	Quit:'$IsObject(objWFItem) return
	
	Set WorkItemID=objWFItem.WFIItem.%Id()
	Set WFItemID=objWFItem.%Id()
	Quit:(WFItemID="")||(WorkItemID="") return
	
	Tstart
	Set return="-1^保存病案复印表失败"
	Set InputStr=""
	Set $p(InputStr,"^",1)=CopyID
	Set $p(InputStr,"^",2)=MrTypeID
	Set $p(InputStr,"^",3)=MainID
	Set $p(InputStr,"^",4)=aOperType
	Set $p(InputStr,"^",5)=+$h
	Set $p(InputStr,"^",6)=+($p($h,",",2))
	Set $p(InputStr,"^",7)=UserID
	Set $p(InputStr,"^",8)=+$h
	Set $p(InputStr,"^",9)=+($p($h,",",2))
	Set $p(InputStr,"^",10)=UserID
	Set $p(InputStr,"^",11)=ClientName
	Set $p(InputStr,"^",12)=ClientRelation
	Set $p(InputStr,"^",13)=CardType
	Set $p(InputStr,"^",14)=PersonalID
	Set $p(InputStr,"^",15)=Telephone
	Set $p(InputStr,"^",16)=Address
	Set $p(InputStr,"^",17)=PaperNumber
	Set $p(InputStr,"^",18)=Content
	Set $p(InputStr,"^",19)=Purpose
	Set $p(InputStr,"^",20)=CopyResume
	Set $p(InputStr,"^",21)=+$h
	Set $p(InputStr,"^",22)=+($p($h,",",2))
	Set $p(InputStr,"^",23)=UserID
	Set $p(InputStr,"^",24)=+$h
	Set $p(InputStr,"^",25)=+($p($h,",",2))
	Set $p(InputStr,"^",26)=UserID
	Set $p(InputStr,"^",27)=SerialNumber
	Set flg = ##class(DHCWMR.MO.CopyRecord).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return

	Set CopyID = +flg
	
	Set return="-2^保存病案复印卷失败"
	Set ErrorFlg = 1
	For xInd = 1:1:$l(VolumeIDs,"#"){
		Set VolumeID = $p(VolumeIDs,"#",xInd)
		Continue:VolumeID=""
		Set InputStr=""
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=CopyID
		Set $p(InputStr,"^",3)=VolumeID
		Set flg = ##class(DHCWMR.MO.CopyRecordVol).Update(InputStr,"^")
		Set:(+flg)<1 ErrorFlg=0
		Quit:ErrorFlg<1
	}
	If (+ErrorFlg)<1 Trollback
	Quit:(+ErrorFlg)<1 return
	
	Set return="-3^保存病案复印日志失败"
	Set InputStr=""
	Set $p(InputStr,"^",1)=CopyID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=WorkItemID      //操作项目
	Set $p(InputStr,"^",4)=UserID     	   //操作员
	Set $p(InputStr,"^",5)=+$h             //操作日期
	Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
	Set $p(InputStr,"^",7)=""       	   //验证用户
	Set $p(InputStr,"^",8)=BatchNumber     //批次号
	Set $p(InputStr,"^",9)=""              //撤销标记
	Set $p(InputStr,"^",10)=""             //撤销日期
	Set $p(InputStr,"^",11)=""             //撤销时间
	Set $p(InputStr,"^",12)=""             //撤销人
	Set $p(InputStr,"^",13)=""             //撤销原因
	Set $p(InputStr,"^",14)=""             //备注信息
	Set flg=##class(DHCWMR.MO.CopyRecordStatus).Update(InputStr,"^")
	If (+flg)<1 TRollback
	Quit:(+flg)<1 return
	
	Set return="-4^保存病案操作记录失败"
	Set InputStr=""
	Set $p(InputStr,"^",1)=""
	Set $p(InputStr,"^",2)=MrTypeID        //病案类型
	Set $p(InputStr,"^",3)=WorkItemID      //操作项目
	Set $p(InputStr,"^",4)=UserID		   //操作员
	Set $p(InputStr,"^",5)=+$h             //操作日期
	Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
	Set $p(InputStr,"^",7)=""	           //验证用户
	Set $p(InputStr,"^",8)=BatchNumber     //批次号
	Set $p(InputStr,"^",9)=1               //是否有效
	Set $p(InputStr,"^",10)=""             //备注
	Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
	
	Set return="-5^保存卷操作记录失败"
	Set ErrorFlg = 1
	For xInd = 1:1:$l(VolumeIDs,"#"){
		Set VolumeID = $p(VolumeIDs,"#",xInd)
		Continue:VolumeID=""
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=VolumeID
		Set $p(InputStr,"^",2)="" 
		Set $p(InputStr,"^",3)=WorkItemID
		Set $p(InputStr,"^",4)=UserID
		Set $p(InputStr,"^",5)=+$h
		Set $p(InputStr,"^",6)=$p($h,",",2)
		Set $p(InputStr,"^",7)=""
		Set $p(InputStr,"^",8)=BatchNumber
		Set $p(InputStr,"^",9)=""
		Set $p(InputStr,"^",10)=""
		Set $p(InputStr,"^",11)=""
		Set $p(InputStr,"^",12)=""
		Set $p(InputStr,"^",13)=""
		Set $p(InputStr,"^",14)=""
		Set $p(InputStr,"^",15)=""
		Set $p(InputStr,"^",16)=""
		Set $p(InputStr,"^",17)=""
		Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
		Set:(+flg)<1 ErrorFlg=0
		Quit:ErrorFlg<1	
	}
	If (+ErrorFlg)<1 Trollback
	Quit:(+ErrorFlg)<1 return
		
	Set return="-6^病案复印收费失败"
	Set FeeInfo=""
	Set $p(FeeInfo,"^",1)=PayModeID    	//支付方式
	Set $p(FeeInfo,"^",2)=UserID
	Set $p(FeeInfo,"^",3)=LocID
	Set $p(FeeInfo,"^",4)=GroupID
	Set flg=##class(DHCWMR.MOService.CopyRecordSrv).SaveCopyFee(CopyID,FeeInfo)
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	
	Tcommit
	Set return = CopyID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-08-10
/// Description:  病案复印流程操作入口
/// Input：		  aOperType：操作代码
/// 				  aCopyInfo：录入信息
/// 				  aFeeInfo：用户信息、费用信息
/// 				  aSeparate：分隔符
/// Return：      成功：DHCWMR.MO.CopyRecord.ID,失败<1
/// w ##class(DHCWMR.MOService.CopyRecordSrv).CopyOper("BO","2^11","^9^117^12^3","^")
ClassMethod CopyOper(aOperType As %String, aCopyInfo As %String, aFeeInfo As %String, aSeparate As %String)
{
	New (aOperType,aCopyInfo,aFeeInfo,aSeparate)
	Set return = 0
	Quit:(aOperType="")||(aCopyInfo="")||(aFeeInfo="")||(aSeparate="") return
	
	//Set ^LIYI=$lb(aOperType,aCopyInfo,aFeeInfo,aSeparate)
	
	Set PayModeID 	= $p(aFeeInfo,aSeparate,1)
	Set UserID 		= $p(aFeeInfo,aSeparate,2)
	Set LocID 		= $p(aFeeInfo,aSeparate,3)
	Set GroupID 	= $p(aFeeInfo,aSeparate,4)
	Set HospID 		= $p(aFeeInfo,aSeparate,5)
	Quit:(UserID="")||(LocID="")||(GroupID="") return
	
	//add by mxp 2016-05-04 收费前检查用户是否有可用发票
	Set return="-99"
	Set Flag=##class(DHCWMR.MFService.FeeRecordSrv).CheckInsertMedical("FY",aFeeInfo)
	Quit:+Flag=0 Flag
	
	Set:HospID="" HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LocID)
	
	Set BatchNumber = ##class(DHCWMR.SSService.OperationSrv).GetBatchNumber()
	
	Set CopyInputStr=""
	Set CopyID=$p(aCopyInfo,aSeparate,1)
	If CopyID'="" {
		Set objCopy=##class(DHCWMR.MO.CopyRecord).GetObjById(CopyID)
		Quit:'$IsObject(objCopy) return
		Set MrTypeID=objCopy.CRMrType.%Id()
		
		Set $p(CopyInputStr,"^",1)=objCopy.%Id()
		Set $p(CopyInputStr,"^",2)=objCopy.CRMrType.%Id()
		Set $p(CopyInputStr,"^",3)=objCopy.CRMainDr.%Id()
		Set $p(CopyInputStr,"^",4)=objCopy.CRStatus
		Set $p(CopyInputStr,"^",5)=objCopy.CRRegDate
		Set $p(CopyInputStr,"^",6)=objCopy.CRRegTime
		Set $p(CopyInputStr,"^",7)=objCopy.CRRegUser
		Set $p(CopyInputStr,"^",8)=objCopy.CRBookDate
		Set $p(CopyInputStr,"^",9)=objCopy.CRBookTime
		Set $p(CopyInputStr,"^",10)=objCopy.CRBookUser
		Set $p(CopyInputStr,"^",11)=objCopy.CRClientName
		Set $p(CopyInputStr,"^",12)=objCopy.CRClientRelation
		Set $p(CopyInputStr,"^",13)=objCopy.CRCardTypeDr
		Set $p(CopyInputStr,"^",14)=objCopy.CRPersonalID
		Set $p(CopyInputStr,"^",15)=objCopy.CRTelephone
		Set $p(CopyInputStr,"^",16)=objCopy.CRAddress
		Set $p(CopyInputStr,"^",17)=objCopy.CRPaperNumber
		Set $p(CopyInputStr,"^",18)=objCopy.CRContent
		Set $p(CopyInputStr,"^",19)=objCopy.CRPurpose
		Set $p(CopyInputStr,"^",20)=objCopy.CRNote
		Set $p(CopyInputStr,"^",21)=objCopy.CRCreateDate
		Set $p(CopyInputStr,"^",22)=objCopy.CRCreateTime
		Set $p(CopyInputStr,"^",23)=objCopy.CRCreateUser
		Set $p(CopyInputStr,"^",24)=+$h
		Set $p(CopyInputStr,"^",25)=+($p($h,",",2))
		Set $p(CopyInputStr,"^",26)=UserID
		Set $p(CopyInputStr,"^",27)=objCopy.CRSerialNumber
	}
	
	TStart
	
	If (aOperType="RE") {  //登记
		Set MainID 			= $p(aCopyInfo,aSeparate,2)
		Set VolumeIDs 		= $p(aCopyInfo,aSeparate,3)
		Set ClientName 		= $p(aCopyInfo,aSeparate,4)
		Set ClientRelation 	= $p(aCopyInfo,aSeparate,5)
		Set CardType 		= $p(aCopyInfo,aSeparate,6)
		Set PersonalID 		= $p(aCopyInfo,aSeparate,7)
		Set Telephone 		= $p(aCopyInfo,aSeparate,8)
		Set Address 		= $p(aCopyInfo,aSeparate,9)
		Set Content 		= $p(aCopyInfo,aSeparate,10)
		Set Purpose 		= $p(aCopyInfo,aSeparate,11)
		Set CopyResume 		= $p(aCopyInfo,aSeparate,12)
		Quit:(MainID="")||(VolumeIDs)="" return
		
		Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
		Quit:'$IsObject(objMain) return
		Quit:'$IsObject(objMain.SMMrType) return
		Set MainID=objMain.%Id()
		Set MrTypeID=objMain.SMMrType.%Id()
		
		Set SysOperaCode="CR"  //复印登记系统操作
		
		If CopyID'="" {
			Set SerialNumber=objCopy.CRSerialNumber
		} Else {
			Set SerialNumber=##class(DHCWMR.MO.CopyRecord).GetSerialNumber()
		}
		
		Set return="-1^保存病案复印表失败"
		Set $p(InputStr,"^",1)=CopyID
		Set $p(InputStr,"^",2)=MrTypeID
		Set $p(InputStr,"^",3)=MainID
		Set $p(InputStr,"^",4)=aOperType
		Set $p(InputStr,"^",5)=+$h
		Set $p(InputStr,"^",6)=+($p($h,",",2))
		Set $p(InputStr,"^",7)=UserID
		Set $p(InputStr,"^",8)=""
		Set $p(InputStr,"^",9)=""
		Set $p(InputStr,"^",10)=""
		Set $p(InputStr,"^",11)=ClientName
		Set $p(InputStr,"^",12)=ClientRelation
		Set $p(InputStr,"^",13)=CardType
		Set $p(InputStr,"^",14)=PersonalID
		Set $p(InputStr,"^",15)=Telephone
		Set $p(InputStr,"^",16)=Address
		Set $p(InputStr,"^",17)=""
		Set $p(InputStr,"^",18)=Content
		Set $p(InputStr,"^",19)=Purpose
		Set $p(InputStr,"^",20)=CopyResume
		Set $p(InputStr,"^",21)=+$h
		Set $p(InputStr,"^",22)=+($p($h,",",2))
		Set $p(InputStr,"^",23)=UserID
		Set $p(InputStr,"^",24)=+$h
		Set $p(InputStr,"^",25)=+($p($h,",",2))
		Set $p(InputStr,"^",26)=UserID
		Set $p(InputStr,"^",27)=SerialNumber
		Set flg = ##class(DHCWMR.MO.CopyRecord).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		Set CopyID = +flg
		
		Set return="-1.1^保存病案复印卷失败"
		Set ErrorFlg = 1
		For xInd = 1:1:$l(VolumeIDs,","){
			Set VolumeID = $p(VolumeIDs,",",xInd)
			Continue:VolumeID=""
			Set InputStr=""
			Set $p(InputStr,"^",1)=""
			Set $p(InputStr,"^",2)=CopyID
			Set $p(InputStr,"^",3)=VolumeID
			Set flg = ##class(DHCWMR.MO.CopyRecordVol).Update(InputStr,"^")
			Set:(+flg)<1 ErrorFlg=0
			Quit:ErrorFlg<1
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1 return
		
	} ElseIf (aOperType="BO") {  //装订
		Quit:CopyID="" return
		Set PaperNumber = $p(aCopyInfo,aSeparate,2)
		
		Set SysOperaCode="CB"  //复印装订系统操作
		
		Set return="-1^保存病案复印表失败"
		Set InputStr=CopyInputStr
		Set $p(InputStr,"^",4)=aOperType
		Set $p(InputStr,"^",8)=+$h
		Set $p(InputStr,"^",9)=+($p($h,",",2))
		Set $p(InputStr,"^",10)=UserID
		Set $p(InputStr,"^",17)=PaperNumber
		Set flg = ##class(DHCWMR.MO.CopyRecord).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		
	} ElseIf (aOperType="CH") {  //收费
		Quit:CopyID="" return
		
		Set SysOperaCode="CF"  //复印收费系统操作
		
		Set return="-1^保存病案复印表失败"
		Set InputStr=CopyInputStr
		Set $p(InputStr,"^",4)=aOperType
		Set flg = ##class(DHCWMR.MO.CopyRecord).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		
		Set return="-1.2^病案复印收费失败"
		Set FeeInfo=""
		Set $p(FeeInfo,"^",1)=PayModeID    	//支付方式
		Set $p(FeeInfo,"^",2)=UserID
		Set $p(FeeInfo,"^",3)=LocID
		Set $p(FeeInfo,"^",4)=GroupID 
		Set flg=##class(DHCWMR.MOService.CopyRecordSrv).SaveCopyFee(CopyID,FeeInfo)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		
	} ElseIf (aOperType="RF") {  //退费
		Quit:CopyID="" return
		
		Set SysOperaCode="CT"  //复印退费系统操作
		
		Set return="-1^保存病案复印表失败"
		Set InputStr=CopyInputStr
		Set $p(InputStr,"^",4)=aOperType
		Set flg = ##class(DHCWMR.MO.CopyRecord).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		
		Set return="-1.3^退费失败"
		Set flg = ##class(DHCWMR.MOService.CopyRecordSrv).RetCopyFee(CopyID, UserID, LocID)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		
	} ElseIf (aOperType="U") {   //作废
		Quit:CopyID="" return
		
		Set SysOperaCode=""  //复印记录作废无系统操作
		
		Set return="-1^保存病案复印表失败"
		Set InputStr=CopyInputStr
		Set $p(InputStr,"^",4)=aOperType
		Set flg = ##class(DHCWMR.MO.CopyRecord).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
	}
	
	If SysOperaCode'="" {
		Set return="-2^无对应操作项目"
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,SysOperaCode)
		If '$IsObject(objWFItem) TRollback
		Quit:'$IsObject(objWFItem) return
		Set WorkItemID=objWFItem.WFIItem.%Id()
		
		Set return="-3^保存病案复印日志失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=CopyID
		Set $p(InputStr,"^",2)=""
		Set $p(InputStr,"^",3)=WorkItemID      //操作项目
		Set $p(InputStr,"^",4)=UserID     	   //操作员
		Set $p(InputStr,"^",5)=+$h             //操作日期
		Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
		Set $p(InputStr,"^",7)=""       	   //验证用户
		Set $p(InputStr,"^",8)=BatchNumber     //批次号
		Set $p(InputStr,"^",9)=""              //撤销标记
		Set $p(InputStr,"^",10)=""             //撤销日期
		Set $p(InputStr,"^",11)=""             //撤销时间
		Set $p(InputStr,"^",12)=""             //撤销人
		Set $p(InputStr,"^",13)=""             //撤销原因
		Set $p(InputStr,"^",14)=""             //备注信息
		Set flg=##class(DHCWMR.MO.CopyRecordStatus).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		
		Set return="-4^保存病案操作记录失败"
		Set InputStr=""
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=MrTypeID        //病案类型
		Set $p(InputStr,"^",3)=WorkItemID      //操作项目
		Set $p(InputStr,"^",4)=UserID		   //操作员
		Set $p(InputStr,"^",5)=+$h             //操作日期
		Set $p(InputStr,"^",6)=$p($h,",",2)    //操作时间
		Set $p(InputStr,"^",7)=""	           //验证用户
		Set $p(InputStr,"^",8)=BatchNumber     //批次号
		Set $p(InputStr,"^",9)=1               //是否有效
		Set $p(InputStr,"^",10)=""             //备注
		Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
		If (+flg)<1 TRollback
		Quit:(+flg)<1 return
		
		Set return="-5^保存卷操作记录失败"
		Set objCopy = ##class(DHCWMR.MO.CopyRecord).GetObjById(CopyID)
		If '$IsObject(objCopy) TRollback
		Quit:'$IsObject(objCopy) return
		
		Set ErrorFlg = 1
		For indVol=1:1:objCopy.ChildVol.Count() {
			Set objCopyVol=objCopy.ChildVol.GetAt(indVol)
			Continue:'$IsObject(objCopyVol)
			Set VolumeID = objCopyVol.RVolumeDr.%Id()
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=VolumeID
			Set $p(InputStr,"^",2)="" 
			Set $p(InputStr,"^",3)=WorkItemID
			Set $p(InputStr,"^",4)=UserID
			Set $p(InputStr,"^",5)=+$h
			Set $p(InputStr,"^",6)=$p($h,",",2)
			Set $p(InputStr,"^",7)=""
			Set $p(InputStr,"^",8)=BatchNumber
			Set $p(InputStr,"^",9)=""
			Set $p(InputStr,"^",10)=""
			Set $p(InputStr,"^",11)=""
			Set $p(InputStr,"^",12)=""
			Set $p(InputStr,"^",13)=""
			Set $p(InputStr,"^",14)=""
			Set $p(InputStr,"^",15)=""
			Set $p(InputStr,"^",16)=""
			Set $p(InputStr,"^",17)=""
			Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
			Set:(+flg)<1 ErrorFlg=0
			Quit:ErrorFlg<1
		}
		If (+ErrorFlg)<1 Trollback
		Quit:(+ErrorFlg)<1 return

	}
	
	TCommit
	
	Set return=CopyID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-08-12
/// Description:  查询病案复印记录
/// Table：       DHCWMR.MO.CopyRecord
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.CopyRecordSrv","QryCopyRecord","2",7,"2015-11-09","2015-11-28","","","","","")
Query QryCopyRecord(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aMrNo As %String, aPapmiNo As %String, aBarCode As %String, aStatus As %String = "", aInvNo As %String = "") As %Query(ROWSPEC = "MrType:%String,CopyRecordID:%String,PatName:%String,PapmiNo:%String,MrNo:%String,Status:%String,StatusDesc:%String,RegDate:%String,RegTime:%String,ClientName:%String,ClientRelation:%String,ClientRelationDesc:%String,CardType:%String,CardTypeDesc:%String,PersonalID:%String,Telephone:%String,Address:%String,PaperNumber:%String,Purpose:%String,PurposeDescs:%String,Content:%String,ContentDescs:%String,SerialNumber:%String,Note:%String,AdmInfos:%String,InvNo:%String,Money:%String")
{
}

ClassMethod QryCopyRecordExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aMrNo As %String, aPapmiNo As %String, aBarCode As %String, aStatus As %String = "", aInvNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aMrNo,aPapmiNo,aBarCode,aStatus,aInvNo)
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="") $$$OK
	
	Set:aHospID'="" aHospID=","_aHospID_","
	If aInvNo'="" {
		Set aStatus=""
		Set PRTRowid=$o(^DHCINVPRTMEDICAL(0,"INV",aInvNo,""))
		Set xFeeRecordID = ""
		For {
			Set xFeeRecordID = $o(^DHCWMR.MF.FeeRecordI("IndexInvprtDr"," "_PRTRowid,xFeeRecordID))
			Quit:xFeeRecordID=""
			
			Set xCopyRecordID=""
			For {
				Set xCopyRecordID=$o(^DHCWMR.MO.CopyRecordI("FEE","IndexRecordDr",xFeeRecordID,xCopyRecordID))
				Quit:xCopyRecordID=""
				
				Set Data = ..BuildCopyRecordData(xCopyRecordID)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		Quit $$$OK
	}
	
	If (aBarCode'="")||(aMrNo'="")||(aPapmiNo'=""){
		If (aBarCode'=""){
			Set xCopyRecordID=$o(^DHCWMR.MO.CopyRecordI("IndexSerialNumber"," "_aBarCode,0))
			Set Data = ..BuildCopyRecordData(xCopyRecordID)
			Quit:Data="" $$$OK
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		If (aMrNo'=""){
			Set aStatus=""
			Set aMrNo=$zcvt(aMrNo,"U")
			Quit:aMrNo="" $$$OK
			Set xMrTypeID=""
			For {
				Set xMrTypeID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID))
				Quit:xMrTypeID=""
				
				Set xMainID=0
				For {
					Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_aMrNo,1,xMainID))
					Quit:xMainID=""
					
					//处理修改病案号之后的历史数据
					Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(xMainID)
					If HisMainIDs'="" {
						Set flg=##Class(DHCWMR.MO.CopyRecord).UpdateErrorMainDr(HisMainIDs)
					}
					
					Set xCopyRecordID=""
					For {
						Set xCopyRecordID = $o(^DHCWMR.MO.CopyRecordI("IndexMainDr",xMainID,xCopyRecordID))
						Quit:xCopyRecordID=""
						
						Set Data = ..BuildCopyRecordData(xCopyRecordID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
					
				}
			}
		}
		If (aPapmiNo'=""){
			Set aStatus=""
			Set aPapmiNo=##Class(DHCWMR.SSService.CommonSrv).RegNoCon(aPapmiNo)
			Quit:aPapmiNo="" $$$OK
			
			Set PatientID=$o(^PAPERi("PAPMI_PatNo",aPapmiNo,0))
			Set xVolID = ""
			For {
				Set xVolID = $o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_PatientID,xVolID))
				Quit:xVolID=""
				
				Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:objVol.SVIsActive=0
				Continue:objVol.SVMainDr.SMIsActive=0
				
				Set MainID  = objVol.SVMainDr.%Id()
				
				//处理修改病案号之后的历史数据
				Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(MainID)
				If HisMainIDs'="" {
					Set flg=##Class(DHCWMR.MO.CopyRecord).UpdateErrorMainDr(HisMainIDs)
				}
				
				Set xCopyRecordID=""
				For {
					Set xCopyRecordID = $o(^DHCWMR.MO.CopyRecordI("IndexMainDr",MainID,xCopyRecordID))
					Quit:xCopyRecordID=""
					
					Set Data = ..BuildCopyRecordData(xCopyRecordID)
					Continue:Data=""
					
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
			
		}
	}else{
		For TempDate = aDateFrom:1:aDateTo{
			Set xMrType=""
			For {
				Set xMrType = $o(^DHCWMR.MO.CopyRecordI("IndexMrTypeRegDate",xMrType))
				Quit:xMrType=""
				
				Set xCopyRecordID =""
				For {
					Set xCopyRecordID=$o(^DHCWMR.MO.CopyRecordI("IndexMrTypeRegDate",xMrType,TempDate,xCopyRecordID))
					Quit:xCopyRecordID=""
					
					Set Data = ..BuildCopyRecordData(xCopyRecordID)
					Continue:Data=""
				
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCopyRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCopyRecordExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCopyRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCopyRecordExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildCopyRecordData(aCopyRecordID As %String) As %List
{
	Set return=""
	Quit:aCopyRecordID="" return
	
	Set objCopy= ##class(DHCWMR.MO.CopyRecord).GetObjById(aCopyRecordID)
	Quit:'$IsObject(objCopy) return
	
	Set MainID        	= objCopy.CRMainDr
	Set MrNo 			= objCopy.CRMainDr.SMMrNo
	Set Status		 	= objCopy.CRStatus
	Set MrTypeID		= objCopy.CRMrType.%Id()
	
	Quit:(aMrTypeID'="")&&(MrTypeID'=aMrTypeID) return
	Quit:(aStatus'="")&(aStatus'[Status) return
	
	Set RegDate			=objCopy.CRRegDate
	Set:RegDate'="" RegDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RegDate)
	Set RegTime			=objCopy.CRRegTime
	Set:RegTime'="" RegTime=$zt(RegTime)
	Set RegUser			=objCopy.CRRegUser
	Set BookDate		=objCopy.CRBookDate
	Set:BookDate'="" BookDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BookDate)
	Set BookTime		=objCopy.CRBookTime
	Set:BookTime'="" BookTime=$zt(BookTime)
	Set BookUser		=objCopy.CRBookUser
	Set ClientName		=objCopy.CRClientName
	Set ClientRelation	=objCopy.CRClientRelation
	Set CardType		=objCopy.CRCardTypeDr
	Set PersonalID		=objCopy.CRPersonalID
	Set Telephone		=objCopy.CRTelephone
	Set Address			=objCopy.CRAddress
	Set PaperNumber		=objCopy.CRPaperNumber
	Set Content			=objCopy.CRContent
	Set Purpose			=objCopy.CRPurpose
	Set Note			=objCopy.CRNote
	Set SerialNumber	=objCopy.CRSerialNumber
	
	Set InvNo="",Money="",ChildFeeLen = objCopy.ChildFee.Count()
	If ChildFeeLen>0{
		Set objCopyRecordFee = objCopy.ChildFee.GetAt(ChildFeeLen)
		Set InvprtDr = objCopyRecordFee.CRFRecordDr.FRInvprtDr
		Set:+InvprtDr'=0 InvNo=$p($g(^DHCINVPRTMEDICAL(InvprtDr)),"^",3) 	//发票号
		Set Money = objCopyRecordFee.CRFRecordDr.FRMoney
	}
	Set StatusDesc=""
	Set:Status="RE" StatusDesc="登记"
	Set:Status="BO" StatusDesc="装订"
	Set:Status="CH" StatusDesc="收费"
	Set:Status="RF" StatusDesc="退费"
	Set:Status="U" StatusDesc="作废"
	
	Set ClientRelationDesc = ""
	If (ClientRelation'=""){
		Set objDic = ##class(DHCWMR.SS.Dictionary).GetObjById(ClientRelation)
		Set ClientRelationDesc = objDic.SDDesc
	}
	Set CardTypeDesc  = ""
	If (CardType'=""){
		Set objDic = ##class(DHCWMR.SS.Dictionary).GetObjById(CardType)
		Set CardTypeDesc = objDic.SDDesc
	}
	
	Set PurposeDescs=""
	For index = 1:1:$l(Purpose,"#")
	{
		Set PurposeId = $p(Purpose,"#",index)
		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("CopyAim",PurposeId)
		continue:'$IsObject(objDic)
		Set PurposeDesc = objDic.SDDesc
		Set PurposeDescs = PurposeDescs_","_PurposeDesc
	}
	Set:PurposeDescs'="" PurposeDescs=$e(PurposeDescs,2,$l(PurposeDescs))
	
	Set ContentDescs=""
	For index = 1:1:$l(Content,"#")
	{
		Set ContentId = $p(Content,"#",index)
		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("MrCopyInfo",ContentId)
		continue:'$IsObject(objDic)
		Set ContentDesc = objDic.SDDesc
		Set ContentDescs = ContentDescs_","_ContentDesc
	}
	Set:ContentDescs'="" ContentDescs=$e(ContentDescs,2,$l(ContentDescs))

	Set xRecordVolID="",AdmInfos=""
	For {
		Set xRecordVolID=$o(^DHCWMR.MO.CopyRecordD(aCopyRecordID,"VOL",xRecordVolID))
		Quit:xRecordVolID=""
		Set objRecordVol = ##class(DHCWMR.MO.CopyRecordVol).GetObjById(aCopyRecordID_"||"_xRecordVolID)
		Continue:'$IsObject(objRecordVol)
		Set objVolume = objRecordVol.RVolumeDr
		Continue:'$IsObject(objVolume)
		Set VolumeID = objVolume.%Id()
		Set xSubID=$o(^DHCWMR.SS.VolumeD(VolumeID,"P",0))
		Continue:xSubID=""
		Set objVolPaadm=##class(DHCWMR.SS.VolPaadm).GetObjById(VolumeID_"||"_xSubID)
		Continue:'$IsObject(objVolPaadm)
		Set PatName = objVolPaadm.VPPatName
		Set Papmi   = objVolPaadm.VPPatientID
		Set PapmiNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",1)
		Set AdmDate = objVolPaadm.VPAdmitDate
		Set DischDate = objVolPaadm.VPDischDate
		Set AdmitDeptDesc = objVolPaadm.VPAdmitDeptDesc
		Set AdmInfo = ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)_" "_AdmitDeptDesc_"<br>"
		Set AdmInfos = AdmInfo_AdmInfos
	}
	Set Money		= $fn(Money,"",2)
	Set return = $lb(MrTypeID,aCopyRecordID,PatName,PapmiNo,MrNo,Status,StatusDesc,RegDate,RegTime,ClientName,ClientRelation,ClientRelationDesc,CardType,CardTypeDesc,PersonalID,Telephone,Address,PaperNumber,Purpose,PurposeDescs,Content,ContentDescs,SerialNumber,Note,AdmInfos,InvNo,Money)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-12
/// Description:  查询复印卷
/// Table：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.CopyRecordSrv","QryCopyVolume","6","D000005")
Query QryCopyVolume(aMrTypeID As %String, aMrNo As %String) As %Query(ROWSPEC = "VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String")
{
}

ClassMethod QryCopyVolumeExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xMainID=""
	For{
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_$ZCVT(aMrNo,"U"),1,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""
			
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCopyVolumeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCopyVolumeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCopyVolumeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCopyVolumeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildVolume(aVolID As %String) As %List
{
	Set return=""
	Quit:aVolID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return  //卷无效
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Quit:objMain.SMIsActive'=1 return  //病案无效
	Quit:'$IsObject(objMain.SMMrType) return
	Quit:objMain.SMMrType.%Id()'=aMrTypeID return  //病案类型不一致
	Quit:'$IsObject(objMain.SMMrType.MTMrClass) return
	Set MainID=objMain.%Id()
	Set MrClass=objMain.SMMrType.MTMrClass.MCCode
	
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时") //fix bug 6537 by pylian 2015-01-21
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Set AdmLoc=$p(VolAdmStr,",",3)
	Set AdmWard=$p(VolAdmStr,",",4)
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	Set Age=objVolAdm.VPAge
	
    Set AdmLoc=objVolAdm.VPAdmitDept
	Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
    Set AdmWard=objVolAdm.VPAdmitWard
	Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
    Set DischDept=objVolAdm.VPDischDept
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
    Set DischWard=objVolAdm.VPDischWard
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDept'="" AdmLoc=DischDept
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWard'="" AdmWard=DischWard
	Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	Set AdmDate=objVolAdm.VPAdmitDate
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	If (MrClass="O")  //门诊就诊科室和日期为初诊科室和初诊日期
	{
		Set FirstLoc=objMain.SMFirstLoc
		Set AdmLocDesc=$p($g(^CTLOC(+FirstLoc)),"^",2)
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set FirstDate=objMain.SMFirstDate
		Set AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FirstDate)
	}
	Set return=$lb(aVolID,MainID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,IdentityCode)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-08-10
/// Description:  病案复印打印信息
/// Input：       DHCWMR.MO.CopyRecord.ID
/// Return：      需要打印的复印信息
/// w ##class(DHCWMR.MOService.CopyRecordSrv).GetPrintInfo("1")
ClassMethod GetPrintInfo(aRecordID As %String) As %String
{
	New (aRecordID)
	Set return = ""
	Quit:aRecordID="" return
	
	Set objCopyRecord = ##class(DHCWMR.MO.CopyRecord).GetObjById(aRecordID)
	Quit:'$IsObject(objCopyRecord) return
	
	Set MrTypeID   = objCopyRecord.CRMrType.%Id()
	Set MrTypeDesc = objCopyRecord.CRMrType.MTDesc
	Set MrNo = objCopyRecord.CRMainDr.SMMrNo
	Set PatientID = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(MrNo,MrTypeID)
	Set PatientName = ""
	If PatientID'=""{
 		Set objPat = ##class(DHCWMR.Base.Patient).GetObjById(PatientID)
 		Set:$IsObject(objPat) PatientName=objPat.PatientName
 	}
	Set SerialNumber= objCopyRecord.CRSerialNumber
	Set RegditDate  = $zd(objCopyRecord.CRRegDate,3)
	Set Number		= +$e(SerialNumber,$l(SerialNumber)-2,$l(SerialNumber))
	
	Set return = MrTypeDesc_"^"_MrNo_"^"_PatientName_"^"_SerialNumber_"^"_RegditDate_"^"_Number
	Quit return
}

ClassMethod GetCopyInfo(aRecordID As %String) As %String
{
	New (aRecordID)
	Set return=""
	Quit:aRecordID="" return
	
	Set objCopyRecord = ##class(DHCWMR.MO.CopyRecord).GetObjById(aRecordID)
	Quit:'$IsObject(objCopyRecord) return
	Quit:'$IsObject(objCopyRecord.CRMrType) return
	Quit:'$IsObject(objCopyRecord.CRMainDr) return
	
	Set MrTypeID=objCopyRecord.CRMrType.%Id()
	Set MrNo=objCopyRecord.CRMainDr.SMMrNo
	Set StatusCode=objCopyRecord.CRStatus
	Set ClientName=objCopyRecord.CRClientName
	Set RelationID=objCopyRecord.CRClientRelation
	Set RelationDesc=""
	If RelationID'="" {
		Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(RelationID)
		If $IsObject(objDic){
			Set RelationDesc=objDic.SDDesc
		}
	}
	Set CardTypeID=objCopyRecord.CRCardTypeDr
	Set CardTypeDesc=""
	If CardTypeID'="" {
		Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(CardTypeID)
		If $IsObject(objDic){
			Set CardTypeDesc=objDic.SDDesc
		}
	}
	Set PersonalID=objCopyRecord.CRPersonalID
	Set Telephone=objCopyRecord.CRTelephone
	Set Address=objCopyRecord.CRAddress
	Set PurposeIDs=objCopyRecord.CRPurpose
	Set PurposeIDs=$tr(PurposeIDs,"#",",")
	Set ContentIDs=objCopyRecord.CRContent
	Set ContentIDs=$tr(ContentIDs,"#",",")
	Set Resume=objCopyRecord.CRNote
	Set PaperNumber=objCopyRecord.CRPaperNumber
	
	Set PurposeDescs=""
	For indP=1:1:$l(PurposeIDs,",") {
		Set PurposeID=$p(PurposeIDs,",",indP)
		Continue:PurposeID=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("CopyAim",PurposeID)
		continue:'$IsObject(objDic)
		Set PurposeDesc=objDic.SDDesc
		Set PurposeDescs=PurposeDescs_"、"_PurposeDesc
	}
	Set:PurposeDescs'="" PurposeDescs=$e(PurposeDescs,2,$l(PurposeDescs))
	
	Set ContentDescs=""
	For indC=1:1:$l(ContentIDs,",") {
		Set ContentID=$p(ContentIDs,",",indC)
		Continue:ContentID=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("MrCopyInfo",ContentID)
		continue:'$IsObject(objDic)
		Set ContentDesc=objDic.SDDesc
		Set ContentDescs=ContentDescs_"、"_ContentDesc
	}
	Set:ContentDescs'="" ContentDescs=$e(ContentDescs,2,$l(ContentDescs))
	
	Set VolumeIDs=""
	For indV=1:1:objCopyRecord.ChildVol.Count() {
		Set objCopyVol=objCopyRecord.ChildVol.GetAt(indV)
		Continue:'$IsObject(objCopyVol)
		Continue:'$IsObject(objCopyVol.RVolumeDr)
		Set VolumeIDs=VolumeIDs_","_objCopyVol.RVolumeDr.%Id()
	}
	Set:VolumeIDs'="" VolumeIDs=$e(VolumeIDs,2,$l(VolumeIDs))
	
	Set CopyMoney=0
	For indF=1:1:objCopyRecord.ChildFee.Count() {
		Set objCopyFee=objCopyRecord.ChildFee.GetAt(indF)
		Continue:'$IsObject(objCopyFee)
		Continue:'$IsObject(objCopyFee.CRFRecordDr)
		Continue:'$IsObject(objCopyFee.CRFRecordDr.FRStatus'="N")
		Set Money=objCopyFee.CRFRecordDr.FRMoney
		Set CopyMoney=CopyMoney+Money
	}
	
	Set return=aRecordID
	Set return=return_"^"_MrTypeID
	Set return=return_"^"_MrNo
	Set return=return_"^"_VolumeIDs
	Set return=return_"^"_StatusCode
	Set return=return_"^"_ClientName
	Set return=return_"^"_RelationID_"^"_RelationDesc
	Set return=return_"^"_CardTypeID_"^"_CardTypeDesc
	Set return=return_"^"_PersonalID
	Set return=return_"^"_Telephone
	Set return=return_"^"_Address
	Set return=return_"^"_PurposeIDs
	Set return=return_"^"_PurposeDescs
	Set return=return_"^"_ContentIDs
	Set return=return_"^"_ContentDescs
	Set return=return_"^"_Resume
	Set return=return_"^"_PaperNumber
	Set return=return_"^"_CopyMoney
	Quit return
}

/// 批量复印登记
/// w ##class(DHCWMR.MOService.CopyRecordSrv).BatchCopy("RE","1^11,21|2^32","^183^178,182^wtr^75^90^111^222^23^1#2#3#8^1^","^9^400^118^2","^")
ClassMethod BatchCopy(aOperType As %String, aRecords As %String, aCopyInfo As %String, aFeeInfo As %String, aSeparate As %String = "^")
{
	New (aOperType,aRecords,aCopyInfo,aFeeInfo,aSeparate)
	Set return=0
	Quit:aOperType="" return
	Quit:aRecords="" return
	
	Set RecordLen = $length(aRecords,"|")
	Set ErrorLog="",RetLog=""
	For xInd=1:1:RecordLen {
		Set tmpRecord=$p(aRecords,"|",xInd)
		Continue:tmpRecord=""
		Set tmpCopyInfo=aCopyInfo
		Set $p(tmpCopyInfo,"^",1)="^"_tmpRecord
		Set ret=..CopyOper(aOperType,tmpCopyInfo,aFeeInfo,aSeparate)
		if ret<=0{
			Set ErrorLog=1
		}else{
			If (RetLog="") { 
				Set RetLog=aRecords
			}else{
				Set RetLog=RetLog_"|"_aRecords
			}
		}
	}
	if ErrorLog=""{
		Quit 1
	}else{
		Quit RetLog
	}
}

}
