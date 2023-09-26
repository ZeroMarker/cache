Import SQLUser

/// 电子票据交易明细对账
Class BILL.EINV.BL.COM.EInvBalanceCtl Extends %RegisteredObject
{

/// date   ：       2020 09 14 
/// Creator：	    徐保保
/// Description:    电子票据交易明细对账
/// Input：         busBgnDate ->开始时间    
/// 				busEndDate ->结束时间   
/// 				placeCode  ->开票点
/// Output：        0 ；对账成功，<0：对账失败
/// Debug:	d ##class(BILL.EINV.BL.COM.EInvBalanceCtl).EInvDetailBalance("2020-09-25","2020-09-25","","1")
ClassMethod EInvDetailBalance(busBgnDate As %String, busEndDate As %String, placeCode As %String, Exstr As %String) As %String
{
	q:(busBgnDate="")||(busEndDate="") "-1"
	
	s busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    s busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
    
    s iBlanceUserDr=$p(Exstr,"^",1)	;对账人
    q:iBlanceUserDr="" "-1"
    
    s ErrNum="0"
    //遍历中心端数据
	f date=busBgnDate:1:busEndDate  d
	.s CenterID=""
	.f  s CenterID=$o(^BILL.EINV.PO.CenterEInvInfoI("IdxBusDate",date,CenterID)) q:CenterID=""  d
	..s CenterObj=##class(BILL.EINV.PO.CenterEInvInfo).%OpenId(CenterID)
	..s BlanceFlg="2",CommonInfo="中心异常"		;对账标识(0:对账成功,1:HIS有中心没有,2:中心有HIS没有,3:金额对不上)
	..s CTBusNo=CenterObj.BusNo					;业务流水号
	..s CTPlaceCode=CenterObj.PlaceCode			;开票点编码
	..q:(CTPlaceCode'=placeCode)&&(placeCode'="")	;过滤非本操作员数据
	..s CTBillBatchCode=CenterObj.BillBatchCode	;票据代码
	..s CTBillNo=CenterObj.BillNo				;票据号码
	..s CTRondom=CenterObj.Random				;校验码
	..s CTTotalAmt=+CenterObj.TotalAmt			;金额
	..s CTDataType=CenterObj.DataType			;数据类型
	..s CTBusDate=CenterObj.BusDate
	..s CTBusTime=CenterObj.BusTime
	..s CTIvcDate=CenterObj.IvcDate
	..s CTIvcTime=CenterObj.IvcTime
	..s CTHospitalNo=CenterObj.HospitalNo
	
	..//根据票据代码和票据号码获取HIS电子票据数据
	..s MedicalID="",HISTotalAmt=""
	..i $d(^BILL.EINV.PO.MedicalEInvInfoI("IDataKey",CTBillBatchCode,CTBillNo)) d
	...s BlanceFlg="3",CommonInfo="金额不一致"
	...s MedicalID=$o(^BILL.EINV.PO.MedicalEInvInfoI("IDataKey",CTBillBatchCode,CTBillNo,""))
	...s MedicalObj=##class(BILL.EINV.PO.MedicalEInvInfo).%OpenId(MedicalID)
	...s HISTotalAmt=+MedicalObj.TotalAmt
	...i CTTotalAmt=HISTotalAmt d
	....s BlanceFlg="0",CommonInfo="对账成功"	;对账成功
	..;保存对账结果
	..s InStr=CTPlaceCode_"^"_MedicalID_"^"_CenterID_"^"_CTBillBatchCode_"^"_CTBillNo_"^"_CTRondom_"^"_CTTotalAmt_"^"_HISTotalAmt	;1--8
	..s InStr=InStr_"^"_CTDataType_"^"_CTBusDate_"^"_CTBusTime_"^"_CTIvcDate_"^"_CTIvcTime_"^"_CTHospitalNo_"^"_BlanceFlg_"^"_iBlanceUserDr_"^"_CommonInfo	;9--17
	..b ;1
	..s SaveInt=..SaveBalanceDetails(InStr)
	..i +SaveInt<0 d
	...s ErrNum=ErrNum+1
    
    
	//遍历HIS数据
	f date=busBgnDate:1:busEndDate  d
	.s MedicalID=""
	.f  s MedicalID=$o(^BILL.EINV.PO.MedicalEInvInfoI("IdxBusDate",date,MedicalID)) q:MedicalID=""  d
	..s MedicalObj=##class(BILL.EINV.PO.MedicalEInvInfo).%OpenId(MedicalID)
	..s BlanceFlg="1",CommonInfo="HIS异常"			;对账标识(0:对账成功,1:HIS有中心没有,2:中心有HIS没有,3:金额对不上)
	..s HISBusNo=MedicalObj.BusNo					;业务流水号
	..s HISPlaceCode=MedicalObj.PlaceCode			;开票点编码
	..q:(HISPlaceCode'=placeCode)&&(placeCode'="")	;过滤非本操作员数据
	..s HISBillBatchCode=MedicalObj.BillBatchCode	;票据代码
	..s HISBillNo=MedicalObj.BillNo				;票据号码
	..s HISRondom=MedicalObj.Random				;校验码
	..s HISTotalAmt=+MedicalObj.TotalAmt			;金额
	..s HISDataType=MedicalObj.DataType			;数据类型
	..s HISBusDate=MedicalObj.BusDate
	..s HISBusTime=MedicalObj.BusTime
	..s HISIvcDate=MedicalObj.IvcDate
	..s HISIvcTime=MedicalObj.IvcTime
	..s HISHospitalNo=MedicalObj.HospitalNo
	
	..//根据票据代码和票据号码获取中心的电子票据数据
	..s CenterID="",CTTotalAmt=""
	..i $d(^BILL.EINV.PO.CenterEInvInfoI("IDataKey",HISBillBatchCode,HISBillNo)) d
	...s BalanceFlag="3",CommonInfo="金额不一致"
	...s CenterID=$o(^BILL.EINV.PO.CenterEInvInfoI("IDataKey",HISBillBatchCode,HISBillNo,""))
	...s CenterObj=##class(BILL.EINV.PO.CenterEInvInfo).%OpenId(CenterID)
	...s CTTotalAmt=+CenterObj.TotalAmt
	...i CTTotalAmt=HISTotalAmt d
	....s BlanceFlg="0",CommonInfo="对账成功"	;对账成功
	..;保存对账结果
	..s InStr=HISPlaceCode_"^"_MedicalID_"^"_CenterID_"^"_HISBillBatchCode_"^"_HISBillNo_"^"_HISRondom_"^"_CTTotalAmt_"^"_HISTotalAmt	;1--8
	..s InStr=InStr_"^"_HISDataType_"^"_HISBusDate_"^"_HISBusTime_"^"_HISIvcDate_"^"_HISIvcTime_"^"_HISHospitalNo_"^"_BlanceFlg_"^"_iBlanceUserDr_"^"_CommonInfo	;9--17
	..s SaveInt=..SaveBalanceDetails(InStr)
	..i +SaveInt<0 d
	...s ErrNum=ErrNum+1
	
	q "0"
}

/// 保存对账结果
ClassMethod SaveBalanceDetails(InStr) As %String
{
	
	;		1				2			3				4				5				6			  7				8
	;HISPlaceCode_"^"_MedicalID_"^"_CenterID_"^"_HISBillBatchCode_"^"_HISBillNo_"^"_HISRondom_"^"_CTTotalAmt_"^"_HISTotalAmt	;1--8
	;		9				10			11				12				13				14				15			16					17
	;HISDataType_"^"_HISBusDate_"^"_HISBusTime_"^"_HISIvcDate_"^"_HISIvcTime_"^"_HISHospitalNo_"^"_BlanceFlg_"^"_iBlanceUserDr_"^"_CommonInfo	;9--17
	
	s BalanceID=""
	s BillBatchCode=$p(InStr,"^",4)
	s BillNo=$p(InStr,"^",5)
	s BlanceFlgTmp=$p(InStr,"^",15)
	q:(InStr="")||(BillBatchCode="")||(BillNo="")||(BlanceFlgTmp="") "-1001"
	
	i $d(^BILL.EINV.PO.BalanceDetailsI("IDataKey",BillBatchCode,BillNo,0)){
		q "0"		;如果已经对账成功,返回成功
	}
	
	s BlanceFlg=""
	f  s BlanceFlg=$o(^BILL.EINV.PO.BalanceDetailsI("IDataKey",BillBatchCode,BillNo,BlanceFlg)) q:(BlanceFlg="")  d
	.s BalanceID=$o(^BILL.EINV.PO.BalanceDetailsI("IDataKey",BillBatchCode,BillNo,BlanceFlg,BalanceID))
	
	i BalanceID="" d
	.s BalanceDetailObj=##class(BILL.EINV.PO.BalanceDetails).%New()
	e  d
	.s BalanceDetailObj=##class(BILL.EINV.PO.BalanceDetails).%OpenId(BalanceID)
	
	s BalanceDetailObj.PlaceCode=$p(InStr,"^",1)		;开票点编码
	s BalanceDetailObj.MedicalDr=$p(InStr,"^",2)		;HIS对账明细ID
	s BalanceDetailObj.CenterDr=$p(InStr,"^",3)			;第三方对账明细ID
	s BalanceDetailObj.BillBatchCode=$p(InStr,"^",4)	;票据代码
	s BalanceDetailObj.BillNo=$p(InStr,"^",5)			;票据号码
	s BalanceDetailObj.Random=$p(InStr,"^",6)			;校验码
	s BalanceDetailObj.CTTotalAmt=$p(InStr,"^",7)		;第三方总金额
	s BalanceDetailObj.HISTotalAmt=$p(InStr,"^",8)		;HIS总金额
	s BalanceDetailObj.DataType=$p(InStr,"^",9)			;数据类型
	s BalanceDetailObj.BusDate=$p(InStr,"^",10)			;业务日期
	s BalanceDetailObj.BusTime=$p(InStr,"^",11)			;业务时间
	s BalanceDetailObj.IvcDate=$p(InStr,"^",12)			;开票日期
	s BalanceDetailObj.IvcTime=$p(InStr,"^",13)			;开票时间
	s BalanceDetailObj.BlanceFlg=$p(InStr,"^",15)		;对账标志
	s BalanceDetailObj.CommonInfo=$p(InStr,"^",17)		;对账备注信息
	s BalanceDetailObj.iBlanceDate=+$h
	s BalanceDetailObj.iBlanceTime=$p($h,",",2)
	s BalanceDetailObj.iBlanceUserDr=$p(InStr,"^",16)	;对账人
	s BalanceDetailObj.HospitalNo=$p(InStr,"^",14)		;医院id
	s BalanceDetailObj.XStr1=""
	s BalanceDetailObj.XStr2=""
	s BalanceDetailObj.XStr3=""
	s BalanceDetailObj.XStr4=""
	s BalanceDetailObj.XStr5=""
	b ;00
	s sc=BalanceDetailObj.%Save()
    i ($$$ISOK(sc)) d
    .s rtn="0"
    e  d
    .s rtn="-1"

	q rtn
}

/// 将HIS交易数据同步到HIS对账明细表中
/// w ##class(BILL.EINV.BL.COM.EInvBalanceCtl).DLMedicalEInvInfo("2020-09-25","2020-09-25")
ClassMethod DLMedicalEInvInfoOld(busBgnDate, busEndDate) As %String
{
	s rtn="0"
	q:(busBgnDate="")||(busEndDate="") "-1"
	
	s busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    s busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
	q:(busEndDate-busBgnDate)>1 "-1"
	
	TSTART
	
	s ALLTotalAmt=0		;总开票额
	s ALLTotalNum=0		;总开票数
	k PlaceList
	k PayAdmTypeList
	k PlaceTypeList
	
	//将交易表数据保存到HIS对账明细表中(BILL.EINV.PO.MedicalEInvInfo)
	f date=busBgnDate:1:busEndDate d
   	.s IUDID=""
	.f  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxPrtDate",date,IUDID)) q:(IUDID="")||(rtn'="0")  d
	..s EInvObj=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	..q:(EInvObj.EInvFlg="")||(EInvObj.IUDUplodeFlag'="Y")	;过滤未开具成功数据
    ..;b ;00
    ..s BusNo=EInvObj.IUDBusNo		 					 ;业务流水号
    ..s InvUserID=EInvObj.IUDUser	 					 ;开票点编码
    ..s PlaceCode=$p($g(^SSU("SSUSR",InvUserID)),"^",1) 
    ..s BillName=EInvObj.IUDBillBatchName			 ;票据种类名称
    ..s BillBatchCode=EInvObj.IUDBillBatchCode		 ;票据代码
    ..s BillNo=EInvObj.IUDBillBatchNo				 ;票据号码
    ..s Random=EInvObj.IUDCheckCode      			 ;校验码
    ..s TotalAmt=+EInvObj.IUDCreatAmt				 ;总金额
    ..s BusDate=EInvObj.IUDPrtDate					 ;业务时间
    ..s BusTime=EInvObj.IUDPrtTime
    ..s IvcDate=EInvObj.IUDCreatDate				 ;开票时间
    ..s IvcTime=EInvObj.IUDCreatTime
    ..s PrintType=EInvObj.IUDPrintType				 ;票据类型(E:电子,P纸质)
    ..s PayAdmType=EInvObj.IUDPayAdmType			 ;业务类型
    ..s PrtRowid=EInvObj.IUDInvDr					 ;发票ID
    ..s DataType=""
    ..i PrintType="E" d				;1 正常电子、2 电子红票、3 换开纸质、4 换开纸质红票、5空白纸质
    ...s DataType=$Case(EInvObj.EInvFlg,"I":"1","B":"1","H":"1","S":"2",:"")
    ..i PrintType="P" d
    ...s DataType=$Case(EInvObj.EInvFlg,"I":"3","A":"4","B":"4","S":"4",:"")
    ..s HospitalNo=EInvObj.IUDHospDr				;医院指针
    ..;给HIS对账明细表存储数据
    ..s InStr=BusNo_"^"_PlaceCode_"^"_BillName_"^"_BillBatchCode_"^"_BillNo_"^"_Random_"^"_TotalAmt_"^"_BusDate_"^"_BusTime	;1--9
	..s InStr=InStr_"^"_IvcDate_"^"_IvcTime_"^"_DataType_"^"_HospitalNo_"^"_PrintType_"^"_PayAdmType_"^"_PrtRowid	;10--16
	..s rtn=..SaveMedicalEInvInfo(InStr)
	
    ..;add by xubaobao 2020 09 18 start 增加汇总信息(只统计电票)----------------------------------------------------
    ..i PrintType="E" d
    ...s ALLTotalAmt=ALLTotalAmt+TotalAmt	;总开票额
    ...s ALLTotalNum=ALLTotalNum+1			;总开票数
    ...s PlaceList("TotalAmt",PlaceCode)=+$g(PlaceList("TotalAmt",PlaceCode))+TotalAmt	;按开票点汇总
    ...s PlaceList("TotalNum",PlaceCode)=+$g(PlaceList("TotalNum",PlaceCode))+1
    ...s PayAdmTypeList("TotalAmt",PayAdmType)=+$g(PayAdmTypeList("TotalAmt",PayAdmType))+TotalAmt	;按业务类型汇总
    ...s PayAdmTypeList("TotalNum",PayAdmType)=+$g(PayAdmTypeList("TotalNum",PayAdmType))+1
    ...s PlaceTypeList("TotalAmt",PayAdmType_"||"_PlaceCode)=+$g(PlaceTypeList("TotalAmt",PayAdmType_"||"_PlaceCode))+TotalAmt	;按开票点下的业务类型汇总
    ...s PlaceTypeList("TotalNum",PayAdmType_"||"_PlaceCode)=+$g(PlaceTypeList("TotalNum",PayAdmType_"||"_PlaceCode))+1
    ..;add by xubaobao 2020 09 18 end 增加汇总信息(只统计电票)----------------------------------------------------
    
    //将跳号表数据保存到HIS对账明细表中
    .s Void=""
	.f  s Void=$o(^DHCVoidInv(0,"Date",date,Void)) q:(Void="")||(rtn'="0")  d
	..s BillBatchCode=$p(^DHCVoidInv(Void),"^",12)		 ;票据代码
    ..s BillNo=$p(^DHCVoidInv(Void),"^",3)				 ;票据号码
    ..s UserID=$p(^DHCVoidInv(Void),"^",5)	 			 ;开票点编码
    ..s PlaceCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
    ..s DataType="5" 
    ..s BusDate=$p(^DHCVoidInv(Void),"^",1)				 ;业务时间
    ..s BusTime=$p(^DHCVoidInv(Void),"^",2)	
    ..s PrintType="P"
    ..s PayAdmType="TT"
    ..s TotalAmt="0"
    ..s HospitalNo=""
    ..;给HIS对账明细表存储数据
    ..s InStr="^"_PlaceCode_"^^"_BillBatchCode_"^"_BillNo_"^^"_TotalAmt_"^"_BusDate_"^"_BusTime	;1--9
	..s InStr=InStr_"^^^"_DataType_"^"_HospitalNo_"^"_PrintType_"^"_PayAdmType_"^"	;10--16
	..i '$d(^BILL.EINV.PO.MedicalEInvInfoI("IDataKey",BillBatchCode,BillNo)) d
	...s rtn=..SaveMedicalEInvInfo(InStr)
    
    if (rtn="0") {
	    //1:所有开票点汇总
	   	s InStr=busBgnDate_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^^^^1"	
	    s resultcode1=..SaveMedicalBalanceDay(InStr)
	    if (resultcode1="0"){
		    //2:按照开票点汇总
			s PlaceCode=""
			f  s PlaceCode=$o(PlaceList("TotalAmt",PlaceCode)) q:(PlaceCode="")||(rtn'="0")  d
			.s ALLTotalAmt=$g(PlaceList("TotalAmt",PlaceCode))
			.s ALLTotalNum=$g(PlaceList("TotalNum",PlaceCode))
			.s InStr=busBgnDate_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^"_PlaceCode_"^^^2"
			.s resultcode2=..SaveMedicalBalanceDay(InStr)
			.s:resultcode2'="0" rtn="-1"
			
			//3:按照业务类型汇总
			s PayAdmType=""
			f  s PayAdmType=$o(PayAdmTypeList("TotalAmt",PayAdmType)) q:(PayAdmType="")||(rtn'="0")  d
			.s ALLTotalAmt=$g(PayAdmTypeList("TotalAmt",PayAdmType))
			.s ALLTotalNum=$g(PayAdmTypeList("TotalNum",PayAdmType))
			.s InStr=busBgnDate_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^^^"_PayAdmType_"^3"
			.s resultcode3=..SaveMedicalBalanceDay(InStr)
			.s:resultcode3'="0" rtn="-1"
			
			//4:按开票点下的业务类型汇总
			s PlaceAndType=""
			f  s PlaceAndType=$o(PlaceTypeList("TotalAmt",PlaceAndType)) q:(PlaceAndType="")||(rtn'="0")  d
			.s ALLTotalAmt=$g(PlaceTypeList("TotalAmt",PlaceAndType))
			.s ALLTotalNum=$g(PlaceTypeList("TotalNum",PlaceAndType))
			.s PayAdmType=$p(PlaceAndType,"||",1)
			.s PlaceCode=$p(PlaceAndType,"||",2)
			.s InStr=busBgnDate_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^"_PlaceCode_"^^"_PayAdmType_"^4"	
			.s resultcode4=..SaveMedicalBalanceDay(InStr)
			.s:resultcode4'="0" rtn="-1"
	    }
    }
    
   	if (rtn'="0"){
		TROLLBACK
	}
   
	TCOMMIT
	
	q rtn
}

/// 将HIS交易数据同步到HIS对账明细表中
/// w ##class(BILL.EINV.BL.COM.EInvBalanceCtl).DLMedicalEInvInfo("2020-07-13","2020-09-28")
ClassMethod DLMedicalEInvInfo(busBgnDate, busEndDate) As %String
{
	s rtn="0"
	q:(busBgnDate="")||(busEndDate="") "-1"
	
	s busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    s busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
	;q:(busEndDate-busBgnDate)>1 "-1"
	
	TSTART
	
	;add xubaobao 2020 12 10 保存未上传成功的数据
	s SaveFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","SaveNotUploadFlag",5)  ;是否保存未上传成功的数据
	i SaveFlag="1" d
	.s NotInvStr=##class(BILL.EINV.BL.EInvoiceLogic).GetNotINVInfo(busBgnDate,busEndDate)
	.s PIDKey=$p(NotInvStr,"^",1)
	.s PayAdmType=""
	.f  s PayAdmType=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType)) q:(PayAdmType="")  d
	..s PrtRowid="0",IUDID=""
	..f  s PrtRowid=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,PrtRowid))  q:(PrtRowid="")  do
	...s outInfo=$g(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType, PrtRowid))
	...s ExpStrTmp=$p(outInfo, "&", 1)  ;1操作员ID^2安全组ID^3院区ID^4科室ID^5发票金额^6收费日期^7收费时间
	...s InitRowid=$p(outInfo, "&", 2)  		;原发票Dr
	...s TotalAmt=+$p(ExpStrTmp, "^", 5)		;发票金额
	...s BusDate=$p(ExpStrTmp, "^", 6)                       ;收费日期
	...s BusTime=$p(ExpStrTmp, "^", 7)                       ;收费时间 
	...s:(BusDate'="") BusDate=$zdh(BusDate,3)
	...s:(BusTime'="") BusTime=$zth(BusTime,1) 
	...s HospitalNo=$p(ExpStrTmp, "^", 3) 
	...s UserID=$p(ExpStrTmp, "^", 1)
	...s PlaceCode=""
	...s:UserID'="" PlaceCode=$p($g(^SSU("SSUSR",UserID)),"^",1) 
	...s InStr="^"_PlaceCode_"^^^^^"_TotalAmt_"^"_BusDate_"^"_BusTime	;1--9
	...s InStr=InStr_"^^^^"_HospitalNo_"^^"_PayAdmType_"^"_UserID_"^"_PrtRowid	;10--15
	...s rtn=..SaveMedicalEInvInfo(InStr)  
	
	k ^TMPERREINV("NotSuccssUpdetails",PIDKey)
	;k PlaceList
	;k PayAdmTypeList
	;k PlaceTypeList
	
	//将交易表数据保存到HIS对账明细表中(BILL.EINV.PO.MedicalEInvInfo)
	s Idx="IdxPrtDate"
	;是否按照开票日期统计数据
	s IsIvcDateFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IsIvcDateFlag",5)  ;是否按照开票日期统计
	s:IsIvcDateFlag="1" Idx="IdxIvcDate"
	;开票总金额是否按照绝对值统计
	s IsAmtAbsFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IsAmtAbsFlag",5)  ;开具金额是否按照绝对值统计
	f date=busBgnDate:1:busEndDate q:rtn'="0"  d
	.s ALLTotalAmt=0		;总开票额
	.s ALLTotalNum=0		;总开票数
	.k PlaceList
	.k PayAdmTypeList
	.k PlaceTypeList
   	.s IUDID=""
	.;f  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxPrtDate",date,IUDID)) q:(IUDID="")||(rtn'="0")  d
	.f  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI(Idx,date,IUDID)) q:(IUDID="")||(rtn'="0")  d
	..s EInvObj=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	..q:(EInvObj.EInvFlg="")||(EInvObj.IUDUplodeFlag'="Y")	;过滤未开具成功数据
    ..s BusNo=EInvObj.IUDBusNo		 					 ;业务流水号
    ..s InvUserID=EInvObj.IUDUser	 					 ;开票点编码
    ..s PlaceCode=$p($g(^SSU("SSUSR",InvUserID)),"^",1) 
    ..s BillName=EInvObj.IUDBillBatchName			 ;票据种类名称
    ..s BillBatchCode=EInvObj.IUDBillBatchCode		 ;票据代码
    ..s BillNo=EInvObj.IUDBillBatchNo				 ;票据号码
    ..s Random=EInvObj.IUDCheckCode      			 ;校验码
    ..s TotalAmt=+EInvObj.IUDCreatAmt				 ;总金额
    ..s:IsAmtAbsFlag="1" TotalAmt=$zabs(TotalAmt)
    ..s BusDate=EInvObj.IUDPrtDate					 ;业务时间
    ..s BusTime=EInvObj.IUDPrtTime
    ..s IvcDate=EInvObj.IUDCreatDate				 ;开票时间
    ..s IvcTime=EInvObj.IUDCreatTime
    ..s PrintType=EInvObj.IUDPrintType				 ;票据类型(E:电子,P纸质)
    ..s PayAdmType=EInvObj.IUDPayAdmType			 ;业务类型
    ..s PrtRowid=EInvObj.IUDInvDr					 ;发票ID
    ..s DataType=""
    ..i PrintType="E" d				;1 正常电子、2 电子红票、3 换开纸质、4 换开纸质红票、5空白纸质
    ...s DataType=$Case(EInvObj.EInvFlg,"I":"1","B":"1","H":"1","S":"2",:"")
    ..i PrintType="P" d
    ...s DataType=$Case(EInvObj.EInvFlg,"I":"3","A":"4","B":"4","S":"4",:"")
    ..s HospitalNo=EInvObj.IUDHospDr				;医院指针
    ..;给HIS对账明细表存储数据
    ..s InStr=BusNo_"^"_PlaceCode_"^"_BillName_"^"_BillBatchCode_"^"_BillNo_"^"_Random_"^"_TotalAmt_"^"_BusDate_"^"_BusTime	;1--9
	..s InStr=InStr_"^"_IvcDate_"^"_IvcTime_"^"_DataType_"^"_HospitalNo_"^"_PrintType_"^"_PayAdmType_"^"_PrtRowid	;10--16
	..s rtn=..SaveMedicalEInvInfo(InStr)
	
    ..;add by xubaobao 2020 09 18 start 增加汇总信息(只统计电票)----------------------------------------------------
    ..i PrintType="E" d
    ...s ALLTotalAmt=ALLTotalAmt+TotalAmt	;总开票额
    ...s ALLTotalNum=ALLTotalNum+1			;总开票数
    ...s PlaceList("TotalAmt",PlaceCode)=+$g(PlaceList("TotalAmt",PlaceCode))+TotalAmt	;按开票点汇总
    ...s PlaceList("TotalNum",PlaceCode)=+$g(PlaceList("TotalNum",PlaceCode))+1
    ...s PayAdmTypeList("TotalAmt",PayAdmType)=+$g(PayAdmTypeList("TotalAmt",PayAdmType))+TotalAmt	;按业务类型汇总
    ...s PayAdmTypeList("TotalNum",PayAdmType)=+$g(PayAdmTypeList("TotalNum",PayAdmType))+1
    ...s PlaceTypeList("TotalAmt",PayAdmType_"||"_PlaceCode)=+$g(PlaceTypeList("TotalAmt",PayAdmType_"||"_PlaceCode))+TotalAmt	;按开票点下的业务类型汇总
    ...s PlaceTypeList("TotalNum",PayAdmType_"||"_PlaceCode)=+$g(PlaceTypeList("TotalNum",PayAdmType_"||"_PlaceCode))+1
    ...;s PlaceList("TotalAmt",BusDate)=+$g(PlaceList("TotalAmt",BusDate))+TotalAmt	;按开票点汇总
    ...;s PlaceList("TotalNum",BusDate)=+$g(PlaceList("TotalNum",BusDate))+1
    ...;s PlaceList("TotalAmt",BusDate,PlaceCode)=+$g(PlaceList("TotalAmt",BusDate,PlaceCode))+TotalAmt	;按开票点汇总
    ...;s PlaceList("TotalNum",BusDate,PlaceCode)=+$g(PlaceList("TotalNum",BusDate,PlaceCode))+1
    ...;s PayAdmTypeList("TotalAmt",BusDate,PayAdmType)=+$g(PayAdmTypeList("TotalAmt",BusDate,PayAdmType))+TotalAmt	;按业务类型汇总
    ...;s PayAdmTypeList("TotalNum",BusDate,PayAdmType)=+$g(PayAdmTypeList("TotalNum",BusDate,PayAdmType))+1
    ...;s PlaceTypeList("TotalAmt",BusDate,PayAdmType_"||"_PlaceCode)=+$g(PlaceTypeList("TotalAmt",BusDate,PayAdmType_"||"_PlaceCode))+TotalAmt	;按开票点下的业务类型汇总
    ...;s PlaceTypeList("TotalNum",BusDate,PayAdmType_"||"_PlaceCode)=+$g(PlaceTypeList("TotalNum",BusDate,PayAdmType_"||"_PlaceCode))+1
    ..;add by xubaobao 2020 09 18 end 增加汇总信息(只统计电票)----------------------------------------------------
    
    .//将跳号表数据保存到HIS对账明细表中
    .s Void=""
	.f  s Void=$o(^DHCVoidInv(0,"Date",date,Void)) q:(Void="")||(rtn'="0")  d
	..s BillBatchCode=$p(^DHCVoidInv(Void),"^",12)		 ;票据代码
	..q:BillBatchCode=""
    ..s BillNo=$p(^DHCVoidInv(Void),"^",3)				 ;票据号码
    ..s UserID=$p(^DHCVoidInv(Void),"^",5)	 			 ;开票点编码
    ..s PlaceCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
    ..s DataType="5" 
    ..s BusDate=$p(^DHCVoidInv(Void),"^",1)				 ;业务时间
    ..s BusTime=$p(^DHCVoidInv(Void),"^",2)	
    ..s PrintType="P"
    ..s PayAdmType="TT"
    ..s TotalAmt="0"
    ..s HospitalNo=""
    ..;给HIS对账明细表存储数据
    ..s InStr="^"_PlaceCode_"^^"_BillBatchCode_"^"_BillNo_"^^"_TotalAmt_"^"_BusDate_"^"_BusTime	;1--9
	..s InStr=InStr_"^^^"_DataType_"^"_HospitalNo_"^"_PrintType_"^"_PayAdmType_"^"	;10--16
	..i '$d(^BILL.EINV.PO.MedicalEInvInfoI("IDataKey",BillBatchCode,BillNo)) d
	...s rtn=..SaveMedicalEInvInfo(InStr)
	
    .if (rtn="0") d
	..//1:所有开票点汇总
	..s InStr=date_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^^^^1"	
	..q:+ALLTotalAmt=0
	..s resultcode1=..SaveMedicalBalanceDay(InStr)
	..if (resultcode1="0") d
	...//2:按照开票点汇总
	...s PlaceCode=""
	...f  s PlaceCode=$o(PlaceList("TotalAmt",PlaceCode)) q:(PlaceCode="")||(rtn'="0")  d
	....s ALLTotalAmt=$g(PlaceList("TotalAmt",PlaceCode))
	....s ALLTotalNum=$g(PlaceList("TotalNum",PlaceCode))
	....s InStr=date_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^"_PlaceCode_"^^^2"
	....s resultcode2=..SaveMedicalBalanceDay(InStr)
	....s:resultcode2'="0" rtn="-1"
			
	...//3:按照业务类型汇总
	...s PayAdmType=""
	...f  s PayAdmType=$o(PayAdmTypeList("TotalAmt",PayAdmType)) q:(PayAdmType="")||(rtn'="0")  d
	....s ALLTotalAmt=$g(PayAdmTypeList("TotalAmt",PayAdmType))
	....s ALLTotalNum=$g(PayAdmTypeList("TotalNum",PayAdmType))
	....s InStr=date_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^^^"_PayAdmType_"^3"
	....s resultcode3=..SaveMedicalBalanceDay(InStr)
	....s:resultcode3'="0" rtn="-1"
			
	...//4:按开票点下的业务类型汇总
	...s PlaceAndType=""
	...f  s PlaceAndType=$o(PlaceTypeList("TotalAmt",PlaceAndType)) q:(PlaceAndType="")||(rtn'="0")  d
	....s ALLTotalAmt=$g(PlaceTypeList("TotalAmt",PlaceAndType))
	....s ALLTotalNum=$g(PlaceTypeList("TotalNum",PlaceAndType))
	....s PayAdmType=$p(PlaceAndType,"||",1)
	....s PlaceCode=$p(PlaceAndType,"||",2)
	....s InStr=date_"^^"_ALLTotalAmt_"^"_ALLTotalNum_"^"_PlaceCode_"^^"_PayAdmType_"^4"	
	....s resultcode4=..SaveMedicalBalanceDay(InStr)
	....s:resultcode4'="0" rtn="-1"
	
   	if (rtn'="0"){
		TROLLBACK
	}
   
	TCOMMIT
	
	q rtn
}

/// 保存HIS对账明细数据
ClassMethod SaveMedicalEInvInfo(InStr) As %String
{
	
	s BillBatchCode=$p(InStr,"^",4)
	s BillNo=$p(InStr,"^",5)
	s PayAdmType=$p(InStr,"^",15)
	s PrtRowid=$p(InStr,"^",16)
	;q:(InStr="")||(BillBatchCode="")||(BillNo="") "-1"
	q:(InStr="")||(PayAdmType="")||(PrtRowid="") "-1"
	
	i (BillBatchCode="")||(BillNo="") d
	.s MedicalID=$o(^BILL.EINV.PO.MedicalEInvInfoI("IdxInvDr",PayAdmType,PrtRowid,""))
	e  d
	.s MedicalID=$o(^BILL.EINV.PO.MedicalEInvInfoI("IDataKey",BillBatchCode,BillNo,""))
    i MedicalID="" d
    .s MedicalObj=##class(BILL.EINV.PO.MedicalEInvInfo).%New()
    e  d
    .s MedicalObj=##class(BILL.EINV.PO.MedicalEInvInfo).%OpenId(MedicalID)
    s MedicalObj.BusNo=$p(InStr,"^",1)						;业务流水号
    s MedicalObj.PlaceCode=$p(InStr,"^",2)					;开票点编码
    s MedicalObj.BillName=$p(InStr,"^",3)					;票据种类名称
    s MedicalObj.BillBatchCode=$p(InStr,"^",4)				;票据代码
    s MedicalObj.BillNo=$p(InStr,"^",5)						;票据号码
    s MedicalObj.Random=$p(InStr,"^",6)						;校验码
    s MedicalObj.TotalAmt=$p(InStr,"^",7)					;总金额
    s MedicalObj.iDate=+$h									;创建日期
    s MedicalObj.iTime=$p($h,",",2)							;创建时间
    s MedicalObj.BusDate=$p(InStr,"^",8)					;业务日期
    s MedicalObj.BusTime=$p(InStr,"^",9)					;业务时间
    s MedicalObj.IvcDate=$p(InStr,"^",10)					;开票日期
    s MedicalObj.IvcTime=$p(InStr,"^",11)					;开票时间
    s MedicalObj.DataType=$p(InStr,"^",12)					;数据类型
    s MedicalObj.HospitalNo=$p(InStr,"^",13)				;医院id
    s MedicalObj.PrintType=$p(InStr,"^",14)					;票据模式	;add by xubaobao 2020 09 18 保存票据模式与业务类型
    s MedicalObj.PayAdmType=$p(InStr,"^",15)				;业务类型
    s MedicalObj.PrtRowid=$p(InStr,"^",16)					;发票id
    s MedicalObj.XStr1=""
	s MedicalObj.XStr2=""
	s MedicalObj.XStr3=""
	s MedicalObj.XStr4=""
	s MedicalObj.XStr5=""
    s sc=MedicalObj.%Save()
    i ($$$ISOK(sc)) d
    .s rtn="0"
    e  d
    .s rtn="-1"

	q rtn
}

/// 保存HIS对账汇总数据
ClassMethod SaveMedicalBalanceDay(InStr) As %String
{
	s BusDate=$p(InStr,"^",1)
	s ALLTotalAmt=$p(InStr,"^",3)
	s ALLTotalNum=$p(InStr,"^",4)
	s PlaceCode=$p(InStr,"^",5)
	s PayAdmType=$p(InStr,"^",7)
	s Type=$p(InStr,"^",8)	;1:所有开票点汇总 2:按照开票点汇总 3:按照业务类型汇总 4:按开票点下的业务类型汇总
	q:(InStr="")||(BusDate="")||(ALLTotalAmt="")||(ALLTotalNum="")||(Type="") "-1"
	
	s ID=""
	if (Type="1") {
		s ID=$o(^BILL.EINV.PO.HISBalanceDayI("IdxDateAndType",BusDate,Type,""),-1)
	}elseIf (Type="2"){
		s ID=$o(^BILL.EINV.PO.HISBalanceDayI("IdxDateAndPlace",BusDate,Type,PlaceCode,""),-1)
	}elseIf (Type="3"){
		s ID=$o(^BILL.EINV.PO.HISBalanceDayI("IdxDateAndPayAdmType",BusDate,Type,PayAdmType,""),-1)
	}elseIf (Type="4"){
		s ID=$o(^BILL.EINV.PO.HISBalanceDayI("IDataKey",BusDate,Type,PlaceCode,PayAdmType,""),-1)
	}
	
	i ID="" d
    .s MedicalBalanceDayObj=##class(BILL.EINV.PO.HISBalanceDay).%New()
    e  d
    .s MedicalBalanceDayObj=##class(BILL.EINV.PO.HISBalanceDay).%OpenId(ID)
    s MedicalBalanceDayObj.BusDate=$p(InStr,"^",1)					;业务日期
    s MedicalBalanceDayObj.CopyNum=$p(InStr,"^",2)					;总笔数
    s MedicalBalanceDayObj.ALLTotalAmt=$p(InStr,"^",3)				;总金额
    s MedicalBalanceDayObj.ALLTotalNum=$p(InStr,"^",4)				;总开票数
    s MedicalBalanceDayObj.PlaceCode=$p(InStr,"^",5)				;开票点编码
    s MedicalBalanceDayObj.HospitalNo=$p(InStr,"^",6)				;医院id
    s MedicalBalanceDayObj.PayAdmType=$p(InStr,"^",7)				;业务类型
    s MedicalBalanceDayObj.Type=$p(InStr,"^",8)						;汇总类型
    s MedicalBalanceDayObj.iDate=+$h								;创建日期
    s MedicalBalanceDayObj.iTime=$p($h,",",2)						;创建时间
    s MedicalBalanceDayObj.XStr1=""
	s MedicalBalanceDayObj.XStr2=""
	s MedicalBalanceDayObj.XStr3=""
	s MedicalBalanceDayObj.XStr4=""
	s MedicalBalanceDayObj.XStr5=""
    s sc=MedicalBalanceDayObj.%Save()
    i ($$$ISOK(sc)) d
    .s rtn="0"
    e  d
    .s rtn="-1"

	q rtn
}

/// 根据业务时间查询第三方开票信息
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.EInvBalanceCtl","QueryCenterEInvInfo","2020-09-25","2020-09-25","")
Query QueryCenterEInvInfo(busBgnDate As %String, busEndDate As %String, placeCode As %String, BalanceFlag As %String = "") As %Query(ROWSPEC = "CTBalanceFlag,CTBusNo,CTPlaceCode,CTBillBatchCode,CTBillNo,CTRandom,CTTotalAmt,CTBusDate,CTBillName") [ SqlProc ]
{
}

ClassMethod QueryCenterEInvInfoExecute(ByRef qHandle As %Binary, busBgnDate As %String, busEndDate As %String, placeCode As %String, BalanceFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    i (busBgnDate="")||(busEndDate="") s qHandle=$lb(0,repid,0) q $$$OK
    
    set busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    set busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
   
    f date=busBgnDate:1:busEndDate d
    .s ID=""
    .f  s ID=$o(^BILL.EINV.PO.CenterEInvInfoI("IdxBusDate",date,ID)) q:ID=""  d
    ..s CenterEInvObj=##class(BILL.EINV.PO.CenterEInvInfo).%OpenId(ID)
    ..s CTBusNo=CenterEInvObj.BusNo		 				;业务流水号
    ..s CTPlaceCode=CenterEInvObj.PlaceCode	 			;开票点编码
    ..q:(CTPlaceCode'=placeCode)&&(placeCode'="")
    ..s CTBillName=CenterEInvObj.BillName			 	 ;票据种类名称
    ..s CTBillBatchCode=CenterEInvObj.BillBatchCode		 ;票据代码
    ..s CTBillNo=CenterEInvObj.BillNo					 ;票据号码
    ..s CTRandom=CenterEInvObj.Random      				 ;校验码
    ..s CTTotalAmt=CenterEInvObj.TotalAmt				 ;总金额
    ..s CTBusDate=$zd(CenterEInvObj.BusDate,3)_" "_$zt(CenterEInvObj.BusTime)      ;业务日期
	..s CTBalanceFlag="N"   
    ..s:$d(^BILL.EINV.PO.BalanceDetailsI("IDataKey",CTBillBatchCode,CTBillNo,0)) CTBalanceFlag="Y"
 	..q:(CTBalanceFlag'=BalanceFlag)&&(BalanceFlag'="")
    ..d CenterEInvOutput
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
CenterEInvOutput
	//需要输出的列
	set Data=$lb(CTBalanceFlag,CTBusNo,CTPlaceCode,CTBillBatchCode,CTBillNo,CTRandom,CTTotalAmt,CTBusDate,CTBillName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryCenterEInvInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCenterEInvInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCenterEInvInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCenterEInvInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据业务时间查询HIS开票信息
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.EInvBalanceCtl","QueryHISEInvInfo","2020-09-25","2020-09-25","")
Query QueryHISEInvInfo(busBgnDate As %String, busEndDate As %String, placeCode As %String, BalanceFlag As %String = "") As %Query(ROWSPEC = "HISBalanceFlag,HISBusNo,HISPlaceCode,HISBillBatchCode,HISBillNo,HISRandom,HISTotalAmt,HISBusDate,HISBillName") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.EInvBalanceCtl","QueryHISEInvInfo","12/05/2020","13/05/2020","")
ClassMethod QueryHISEInvInfoExecute(ByRef qHandle As %Binary, busBgnDate As %String, busEndDate As %String, placeCode As %String, BalanceFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    s ^CacheTemp("BILL.EINV.BL.COM.EInvBalanceCtl","QueryHISEInvInfo")=busBgnDate_"^"_busEndDate_"^"_placeCode_"^"_BalanceFlag
    i (busBgnDate="")||(busEndDate="") s qHandle=$lb(0,repid,0) q $$$OK
   
    set busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    set busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
    
    //将交易表数据保存到对账HIS明细表
    ;s result=..SaveMedicalEInvInfo(busBgnDate,busEndDate)
    ;q:result'="0" $$$OK
    
    //将交易表数据保存到HIS对账明细表中(BILL.EINV.PO.MedicalEInvInfo)
	s Idx="IdxBusDate"
	;是否按照开票日期统计数据
	s IsIvcDateFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IsIvcDateFlag",5)  ;是否按照开票日期统计
	s:IsIvcDateFlag="1" Idx="IdxIvcDate"
   
    f date=busBgnDate:1:busEndDate d
   	.s MedicalID=""
	.f  s MedicalID=$o(^BILL.EINV.PO.MedicalEInvInfoI(Idx,date,MedicalID),-1) q:MedicalID=""  d
	..s MedicalObj=##class(BILL.EINV.PO.MedicalEInvInfo).%OpenId(MedicalID)
    ..s HISBusNo=MedicalObj.BusNo		 					;业务流水号
    ..s HISPlaceCode=MedicalObj.PlaceCode	 				;开票点编码\
    ..q:(HISPlaceCode'=placeCode)&&(placeCode'="")
    ..s HISBillName=MedicalObj.BillName			 			;票据种类名称
    ..s HISBillBatchCode=MedicalObj.BillBatchCode			;票据代码
    ..s HISBillNo=MedicalObj.BillNo						   	;票据号码
    ..s HISRandom=MedicalObj.Random      					;校验码
    ..s HISTotalAmt=MedicalObj.TotalAmt						;总金额
    ..s HISBusDate=$zd(MedicalObj.BusDate,3)_" "_$zt(MedicalObj.BusTime)	;业务日期
    ..s HISBalanceFlag="N"
    ..s:$d(^BILL.EINV.PO.BalanceDetailsI("IDataKey",HISBillBatchCode,HISBillNo,0)) HISBalanceFlag="Y"
 	..q:(HISBalanceFlag'=BalanceFlag)&&(BalanceFlag'="")
    ..d HISEInvOutput
    //以下不用动
    s qHandle=$lb(0,repid,0)
    q $$$OK
HISEInvOutput
	//需要输出的列
	s Data=$lb(HISBalanceFlag,HISBusNo,HISPlaceCode,HISBillBatchCode,HISBillNo,HISRandom,HISTotalAmt,HISBusDate,HISBillName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryHISEInvInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHISEInvInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryHISEInvInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHISEInvInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据业务时间查询第三方(异常)开票信息
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.EInvBalanceCtl","QueryCTBalanceListErr","2020-09-24","2020-09-24","")
Query QueryCTBalanceListErr(busBgnDate As %String, busEndDate As %String, placeCode As %String) As %Query(ROWSPEC = "CTPlaceCodeErr,CTMedicalDrErr,CTCenterDrErr,CTBillBatchCodeErr,CTBillNoErr,CTRandomErr,CTTotalAmtErr,CTDataTypeErr,CTiBlanceDateErr,CTiBlanceUserDrErr") [ SqlProc ]
{
}

ClassMethod QueryCTBalanceListErrExecute(ByRef qHandle As %Binary, busBgnDate As %String, busEndDate As %String, placeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    i (busBgnDate="")||(busEndDate="") s qHandle=$lb(0,repid,0) q $$$OK
    
    set busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    set busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
   
    f date=busBgnDate:1:busEndDate d
    .s ID=""
    .f  s ID=$o(^BILL.EINV.PO.BalanceDetailsI("IdxBusDate",date,ID)) q:ID=""  d
    ..s BalanceDetailObj=##class(BILL.EINV.PO.BalanceDetails).%OpenId(ID)
    ..s BalanceFlg=BalanceDetailObj.BlanceFlg
    ..q:(BalanceFlg="0")||((BalanceFlg="1"))
    ..s PlaceCodeErr=BalanceDetailObj.PlaceCode	 		 ;开票点编码
    ..q:(PlaceCodeErr'=placeCode)&&(placeCode'="")
    ..s MedicalDrErr=BalanceDetailObj.MedicalDr			 ;HIS对账明细表ID
    ..s CenterDrErr=BalanceDetailObj.CenterDr			 ;第三方对账明细表ID
    ..s BillBatchCodeErr=BalanceDetailObj.BillBatchCode	 ;票据代码
    ..s BillNoErr=BalanceDetailObj.BillNo				 ;票据号码
    ..s RandomErr=BalanceDetailObj.Random      			 ;校验码
    ..s TotalAmtErr=BalanceDetailObj.TotalAmt				 ;总金额
    ..s DataTypeErr=BalanceDetailObj.DataType				 ;数据类型
    ..s iBlanceDateErr=$zd(BalanceDetailObj.iBlanceDate,3)_" "_$zt(BalanceDetailObj.iBlanceTime)      ;对账时间
	..s iBlanceUserDr=BalanceDetailObj.iBlanceUserDr	 	 ;对账人ID
	..s iBlanceUserDrErr=$p($g(^SSU("SSUSR",iBlanceUserDr)),"^",2)	;对账人
	..d CTBalanceListErrOutput
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
CTBalanceListErrOutput
	//需要输出的列
	set Data=$lb(PlaceCodeErr,MedicalDrErr,CenterDrErr,BillBatchCodeErr,BillNoErr,RandomErr,TotalAmtErr,DataTypeErr,iBlanceDateErr,iBlanceUserDrErr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryCTBalanceListErrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCTBalanceListErrErrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCTBalanceListErrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCTBalanceListErrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据业务时间查询HIS(异常)开票信息
Query QueryHISBalanceListErr(busBgnDate As %String, busEndDate As %String, placeCode As %String) As %Query(ROWSPEC = "HISPlaceCodeErr,HISMedicalDrErr,HISCenterDrErr,HISBillBatchCodeErr,HISBillNoErr,HISRandomErr,HISTotalAmtErr,HISDataTypeErr,HISiBlanceDateErr,HISiBlanceUserDrErr") [ SqlProc ]
{
}

ClassMethod QueryHISBalanceListErrExecute(ByRef qHandle As %Binary, busBgnDate As %String, busEndDate As %String, placeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    i (busBgnDate="")||(busEndDate="") s qHandle=$lb(0,repid,0) q $$$OK
    
    set busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    set busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
   
    f date=busBgnDate:1:busEndDate d
    .s ID=""
    .f  s ID=$o(^BILL.EINV.PO.BalanceDetailsI("IdxBusDate",date,ID)) q:ID=""  d
    ..s BalanceDetailObj=##class(BILL.EINV.PO.BalanceDetails).%OpenId(ID)
    ..s BalanceFlg=BalanceDetailObj.BlanceFlg
    ..q:(BalanceFlg="0")||((BalanceFlg="2"))
    ..s PlaceCodeErr=BalanceDetailObj.PlaceCode	 		 ;开票点编码
    ..q:(PlaceCodeErr'=placeCode)&&(placeCode'="")
    ..s MedicalDrErr=BalanceDetailObj.MedicalDr			 ;HIS对账明细表ID
    ..s CenterDrErr=BalanceDetailObj.CenterDr			 	 ;第三方对账明细表ID
    ..s BillBatchCodeErr=BalanceDetailObj.BillBatchCode	 ;票据代码
    ..s BillNoErr=BalanceDetailObj.BillNo					 ;票据号码
    ..s RandomErr=BalanceDetailObj.Random      			 ;校验码
    ..s TotalAmtErr=BalanceDetailObj.TotalAmt				 ;总金额
    ..s DataTypeErr=BalanceDetailObj.DataType				 ;数据类型
    ..s iBlanceDateErr=$zd(BalanceDetailObj.iBlanceDate,3)_" "_$zt(BalanceDetailObj.iBlanceTime)      ;对账时间
	..s iBlanceUserDr=BalanceDetailObj.iBlanceUserDr	 	 ;对账人ID
	..s iBlanceUserDrErr=$p($g(^SSU("SSUSR",iBlanceUserDr)),"^",2)	;对账人
	..d HISBalanceListErrOutput
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
HISBalanceListErrOutput
	//需要输出的列
	set Data=$lb(PlaceCodeErr,MedicalDrErr,CenterDrErr,BillBatchCodeErr,BillNoErr,RandomErr,TotalAmtErr,DataTypeErr,iBlanceDateErr,iBlanceUserDrErr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryHISBalanceListErrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHISBalanceListErrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryHISBalanceListErrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHISBalanceListErrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 同时显示第三方/HIS异常数据
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.EInvBalanceCtl","QueryBalanceListErr","2020-09-24","2020-09-24","")
Query QueryBalanceListErr(busBgnDate As %String, busEndDate As %String, placeCode As %String) As %Query(ROWSPEC = "PlaceCodeErr,MedicalDrErr,CenterDrErr,BillBatchCodeErr,BillNoErr,RandomErr,CTTotalAmtErr,HISTotalAmtErr,CommonInfoErr,DataTypeErr,iBlanceDateErr,iBlanceUserDrErr") [ SqlProc ]
{
}

ClassMethod QueryBalanceListErrExecute(ByRef qHandle As %Binary, busBgnDate As %String, busEndDate As %String, placeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    ;s ^XBB("EINVBalanceCtl","QueryBalanceListErr")=busBgnDate_"^"_busEndDate_"^"_placeCode
    i (busBgnDate="")||(busEndDate="") s qHandle=$lb(0,repid,0) q $$$OK
    
    set busBgnDate=##class(websys.Conversions).DateHtmlToLogical(busBgnDate)
    set busEndDate=##class(websys.Conversions).DateHtmlToLogical(busEndDate)
    f date=busBgnDate:1:busEndDate d
    .s ID=""
    .f  s ID=$o(^BILL.EINV.PO.BalanceDetailsI("IdxBusDate",date,ID)) q:ID=""  d
    ..s BalanceDetailObj=##class(BILL.EINV.PO.BalanceDetails).%OpenId(ID)
    ..s BalanceFlg=BalanceDetailObj.BlanceFlg
    ..q:(BalanceFlg="0")
    ..s CommonInfoErr=BalanceDetailObj.CommonInfo			 ;对账结果信息
    ..s PlaceCodeErr=BalanceDetailObj.PlaceCode	 		 ;开票点编码
    ..q:(PlaceCodeErr'=placeCode)&&(placeCode'="")
    ..s MedicalDrErr=BalanceDetailObj.MedicalDr			 ;HIS对账明细表ID
    ..s CenterDrErr=BalanceDetailObj.CenterDr			 ;第三方对账明细表ID
    ..s BillBatchCodeErr=BalanceDetailObj.BillBatchCode	 ;票据代码
    ..s BillNoErr=BalanceDetailObj.BillNo				 ;票据号码
    ..s RandomErr=BalanceDetailObj.Random      			 ;校验码
    ..s CTTotalAmtErr=BalanceDetailObj.CTTotalAmt		 ;第三方总金额
    ..s HISTotalAmtErr=BalanceDetailObj.HISTotalAmt		 ;HIS总金额
    ..s DataTypeErr=BalanceDetailObj.DataType				 ;数据类型
    ..s DataTypeErr=$Case(DataTypeErr,"1":"正常电票","2":"电子红票","3":"换开纸质","4":"换开纸质红票","5":"空白纸质",:"")
    ..s iBlanceDateErr=$zd(BalanceDetailObj.iBlanceDate,3)_" "_$zt(BalanceDetailObj.iBlanceTime)      ;对账时间
	..s iBlanceUserDr=BalanceDetailObj.iBlanceUserDr	 	 ;对账人ID
	..s iBlanceUserDrErr=$p($g(^SSU("SSUSR",iBlanceUserDr)),"^",2)	;对账人
	..d BalanceListErrOutput
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
BalanceListErrOutput
	//需要输出的列
	set Data=$lb(PlaceCodeErr,MedicalDrErr,CenterDrErr,BillBatchCodeErr,BillNoErr,RandomErr,CTTotalAmtErr,HISTotalAmtErr,CommonInfoErr,DataTypeErr,iBlanceDateErr,iBlanceUserDrErr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryBalanceListErrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBalanceListErrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBalanceListErrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBalanceListErrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
