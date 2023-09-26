Import SQLUser

/// 住院临床公共程序
Class web.DHCConsultOrder Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 3;

/// OrderARCIMRowid:医嘱项指针
/// OrderPriorRowid:优先级
/// OrderRecDepRowid:接收科室
ClassMethod InsertOrdItemNew(userId, oeordId, OrderARCIMRowid, OrderPriorRowid, OrderPackQty, userDeptId, anaId, anaOpId, billDesc, notes, OrderRecDepRowid, ifRetRowID = "N") As %String
{
 quit:(userId="")!(oeordId="")!(OrderARCIMRowid="")!(OrderPriorRowid="")!(userDeptId="") 100
 set (OrderType,OrderStartDate,OrderStartTime,OrderPrice,BillTypeRowid,OrderDrugFormRowid,OrderDepProcNotes,OrderDoseQty,OrderDoseUOMRowid,OrderQtySum,OrderDurRowid,OrderInstrRowid,OrderFreqRowid,PHPrescType,OrderMasterSeqNo,OrderSeqNo,OrderSkinTest,OrderPhSpecInstr,OrderCoverMainIns,OrderActionRowid,OrderARCOSRowid,OrderEndDate,OrderEndTime,OrderLabSpecRowid)=""	
 set ARCIMItemCatDR=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
 if ARCIMItemCatDR'="" s OrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
 s OrderStartDate=$zd(+$h,4),OrderStartTime=$zt($p($h,",",2),2) ///开始日期时间
 
 s admId=+^OEORD(oeordId)
 s patientStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(admId)
 i patientStatus="B" d
 .s dateRet=##class(web.DHCDischargeHistory).GetDischargeDateTime(admId)
 .s date=+dateRet
 .s time=$p(dateRet,"^",2)
 .i (date'="")&&(time'="") d
 ..s OrderStartDate=$zd(date,4)
 ..s OrderStartTime=$zt(time,2)
 //20170330取医生出院时间配置
 s DischSet=$g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
 i (patientStatus="E")&&(DischSet="Y")  d
 .s dateRet=##class(web.DHCDischargeHistory).GetDischargeDateTime(admId)
 .s date=+dateRet
 .s time=$p(dateRet,"^",2)
 .i (date'="")&&(time'="") d
 ..s OrderStartDate=$zd(date,4)
 ..s OrderStartTime=$zt(time,2)
 
 s BillTypeRowid=$p($g(^PAADM(admId,1)),"^",7)  //费别指针
 Set InsuFlag=$$GetInsurFlag(BillTypeRowid) 
 i InsuFlag'=1 {
	Set OrderCoverMainIns="N"
 }else {
	Set OrderCoverMainIns="Y"
 }

 s OrderSeqNo=$$GetSeqNoNew(oeordId,+$h)
 s AnaesthesiaID=anaId
 s OrderDepProcNotes=notes
 s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
 s OrderSkinTest="N" //皮试
 ;s OrderCoverMainIns="Y" //医保标示 OEORI_CoverMainIns（住院）
 s OrderQtySum=OrderPackQty
 s phcdfDr=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",12)
 i phcdfDr'="" d
 .s OrderDoseQty=$p($g(^PHCD(+phcdfDr,"DF",$p(phcdfDr,"||",2),2)),"^",5)
 .s OrderQtySum=OrderPackQty
 .s OrderDoseUOMRowid=$p($g(^PHCD(+phcdfDr,"DF",$p(phcdfDr,"||",2),2)),"^",4)
 Set OrderItemStr=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate  //4
 Set OrderItemStr=OrderItemStr_"^"_OrderStartTime_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid //10
 Set OrderItemStr=OrderItemStr_"^"_OrderDepProcNotes_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid //16
 Set OrderItemStr=OrderItemStr_"^"_OrderInstrRowid_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr  //22
 Set OrderItemStr=OrderItemStr_"^"_OrderCoverMainIns_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid //28
 Set OrderItemStr=OrderItemStr_"^^^^^^^^^"_AnaesthesiaID ///37
 s ret=##class(web.DHCOEOrdItem).SaveOrderItems(admId,OrderItemStr,userId,userDeptId,ctcpId)
 q ret
GetSeqNoNew(oeordId,sttdate)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
	
GetInsurFlag(AdmReason)
  	n (AdmReason)
  	Q:(AdmReason="") 0
  	s InsurFlag=+$p($g(^PAC("ADMREA",AdmReason)),"^",9)
  	if InsurFlag>0 s InsurFlag=1
  	Q InsurFlag
}

ClassMethod InsertOrdItem(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes, ConDepID, ifRetRowID = "N") As %String
{
	q:(userId="")!(oeordId="")!(arcimId="")!(oecprId="")!(userDeptId="") -1
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	//zn dataNameSpace
    //w $zn,!
    //w userId_","_oeordId_","_arcimId_","_userDeptId_","_notes
	k PLIST
	s PLIST(4)=arcimId
	s PLIST(6)=userDeptId  ;OEORI_OrdDept_DR
	s PLIST(10)=1   ;OEC_OrderStatus：1核4停6执
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s PLIST(14)=ctcpId  //careProvId ;OEORI_Doctor_DR:
	s PLIST(17)=+$h ;  OEORI_SttDat
	s PLIST(18)=$p($h,",",2)  ;OEORI_SttTim
	s PLIST(23)=oecprId   ;OEORI_Priority_DR:OEC_Priority：3临时，5长期
	s PLIST(29)=qty ;OEORI_PhQtyOrd
	s PLIST(45)=billDesc //OEORI_BillDesc
	s PLIST(55)="Y"  ;OEORI_CoverMainIns  Y
	s PLIST(56)="N"  ;OEORI_PortEquipReq  N
	s PLIST(57)="N"  ;OEORI_AdministerSkinTest N
	s PLIST(75)=ConDepID  //OEORI_RecDep_DR
	s PLIST(76)="TB" //OEORI_Billed

	s PLIST(77)=$$GetSeqNo(oeordId,+$h)  ;OEORI_SeqNo，每天排序//
	  
	s PLIST(81)=+$h    ;OEORI_Date
	s PLIST(90)=$p($h,",",2)    ;OEORI_TimeOrd
	s PLIST(106)=anaId
	s PLIST(107)=anaOpId
	s PLIST(111)="A" ;OEORI_ResultFlag A
	s PLIST(120)=userId ;OEORI_UserAdd
	s PLIST(121)=userDeptId  ;OEORI_UserDepartment_DR
	s PLIST(141)=userId ;OEORI_UserUpdate！
	s admId=+^OEORD(oeordId)
	s PLIST(161)=$p(^PAADM(admId),"^",4) //OEORI_AdmLoc_DR：病人科室
	s PLIST(53)=notes //OEORI_DepProcNotes
	//s res=$$insert^MVBOEIT0(oeordId,"Y")
	s PLIST(206)=$p($g(^PAADM(admId,1)),"^",7) //费别2015-03-11
	s res1=##class(appcom.OEOrdItem).Insert(oeordId,"Y",.PLIST)
	s res=$P(res1,"^") 
	
	s oeitm=""
	i res=0 s oeitm=$P(res1,"^",2)  //%ROWID
	//zn oldNameSpace  ; Restore the namespace
	//s ^ypzTmp("app","in")=res_"/"_oeordId_"/"_%ROWID
	i ifRetRowID="Y" q res_"^"_$G(oeitm)
	q res
GetSeqNo(oeordId,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
}

/// 停医嘱
ClassMethod DisconOrdItem(oeoriId, userId = "") As %String
{
	q:oeoriId="" 0
	i userId="" s userId=%session.Data("LOGON.USERID")
	s err=0
	s err=##class(appcom.OEOrdItem).Verifye(oeoriId,userId)
	q err
}

/// 停医嘱
ClassMethod DisconOrdItem20150317(oeoriId) As %String
{
	//w ##class(web.DHCConsultOrder).DisconOrdItem("26508||2")
	q:oeoriId="" 0
	s err=0
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s err=$$discon^DHCCLDiscon(oeoriId,"","")
	zn oldnamespace
	q err
}

}
