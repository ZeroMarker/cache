Include webimport

IncludeGenerator webimport

Class web.DHCOPChgAdmreason Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

Query UFindAdmReason() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ss_rowid:%String,ss_desc:%String")
{
select ss_rowid,ss_desc from ct_socialstatus
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(%CSP.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod SetPattype(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatTypeRowid As %Library.String = "", AdmRowid As %Library.String = "", InsuranceNo As %Library.String = "", ExpStr As %Library.String = "")
{
 ;n id,code,desc
 
 //s ^DHCXPTest("InsuranceNo")=InsuranceNo_"^"_PatTypeRowid

 s desc=0
 //修改病人类别
 &SQL(select paadm_papmi_dr into :PatRowid from pa_adm
 where paadm_rowid=:AdmRowid)
 //s ^DHCApp("0")=AdmRowid_"^"_PatRowid_"^"_PatTypeRowid
 s desc=desc+SQLCODE
 &sql(update sqluser.pa_person set  paper_socialstatus_dr =:PatTypeRowid
           where paper_rowid=:PatRowid)
 s desc=desc+SQLCODE
 s InsuranceNo=$ZCVT(InsuranceNo,"U")
 &sql(Update SQLUser.PA_PatMas Set 
		   PAPMI_HealthFundNo=:InsuranceNo where PAPMI_Rowid=:PatRowid )	
 s desc=desc+SQLCODE
 //修改病人就诊费别
 set AdmReason=""
 if $g(PatTypeRowid)'="" Do
 .set PatAdmDr=$o(^DHCPACADM(0,"Social",PatTypeRowid,0))
 .set:PatAdmDr'="" AdmReason=$p(^DHCPACADM(PatAdmDr),"^",2)
 
 If AdmReason'="" Do
 .&SQL(Update SQLUser.PA_Adm Set PAADM_AdmReason_DR=:AdmReason
        Where PAAdm_RowId=:AdmRowid)
 if (itmjs=""){
	 Q SQLCODE
 }else{
	 s desc=desc+SQLCODE
	 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }
}

ClassMethod FindPatInfo(FID As %String)
{
 s InsuranceNo=""
 s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),PapmiRowid)) q:PapmiRowid=""  d
	.s RName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
	.s InsuranceNo=$p(^PAPER(PapmiRowid,"PAT",3),"^",12)  ;医保号
	.s RPatType=""
	.s socialstatus=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10) 
	.i socialstatus'="" d
	..s RPatType=$p($g(^CT("SS",socialstatus)),"^",2)      ;paper_socialstatus_dr->ss_desc
  ;Quit "登记号:"_FID_", "_RName_", "_RPatType     ; xp modify,2008-05-10,不显示病人基本类型,改为在就诊信息栏中显示病人就诊类型
  Quit "登记号:"_FID_", "_RName_","_InsuranceNo
}

// 不显示病人基本类型,改为在就诊信息栏中显示病人就诊类型_"^"_xp modify,2008-05-10

ClassMethod FindAdmInfo(AdmId As %String)
{
 ; 取就诊费别
  s ReasonDesc=""
  q:AdmId="" ReasonDesc
  q:'$d(^PAADM(AdmId,1)) ReasonDesc 
  s PacId=$p(^PAADM(AdmId,1),"^",7)
  q:PacId="" ReasonDesc
  q:'$d(^PAC("ADMREA",PacId)) ReasonDesc 
  s ReasonDesc=$p(^PAC("ADMREA",PacId),"^",2)
  q ReasonDesc
}

ClassMethod GetPatOtherInfo(PapmiNo As %String)
{
 ; 取病人类型
  s PapmiTypeDesc="^"
  q:PapmiNo="" PapmiTypeDesc
  s PapmiNo=$ZConvert(PapmiNo,"U")	
  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
  q:PapmiRowid="" PapmiTypeDesc
  q:'$d(^PAPER(PapmiRowid,"PER",1)) PapmiTypeDesc 
  q:'$d(^PAPER(PapmiRowid,"ALL")) PapmiTypeDesc 
  s socialstatus=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10) 
  q:socialstatus="" PapmiTypeDesc
  q:'$d(^CT("SS",socialstatus)) PapmiTypeDesc
  s PapmiTypeDesc=$p($g(^CT("SS",socialstatus)),"^",2) 
  s InsuranceNo=$p(^PAPER(PapmiRowid,"ALL"),"^",19)  ;医保号
  s PatOtherInfo=PapmiTypeDesc_"^"_InsuranceNo 
  q PatOtherInfo
}

ClassMethod PatInformLog(CardNo As %String, PatName As %String, PatOtherInfoOld As %String, PatOtherInfoNew As %String, UPPuserDr As %String, PatientID As %String = "")
{
  ; 修改病人类型,做日志
	s UPPDate=..%SysDate()
	s UPPTime=..%SysTime()
	s PatTypeOld=$p(PatOtherInfoOld,"^",1)
	s InsuranceNoOld=$p(PatOtherInfoOld,"^",2)
	s PatTypeNew=$p(PatOtherInfoNew,"^",1)
	s InsuranceNoNew=$p(PatOtherInfoNew,"^",2)
	if (CardNo'=""){
		s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))   
	    s PapmiDr=$p($g(^DHCCARD("CF",CardRowid)),"^",4)
	}else{
		s PapmiDr=PatientID
		//如果卡号为空,则根据病人ID寻找合适的卡号
		s CFRowID=0
		f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDr,CFRowID)) q:(CFRowID="")||(CardNo'="")  d
		.s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
		.q:CFActiveFlag'="N" 
		.s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
	}
	
	
	s UPPSDob=$p(^PAPER(PapmiDr,"ALL"),"^",6)
	s UPPDob=UPPSDob
	s UPPSbor=""
	s UPPbor=""

	s PNO=$p(^PAPER(PapmiDr,"PAT",1),"^",1)

	s Flag="" s CardInfo=""
	if PatTypeOld'=PatTypeNew  d
	.s CardInfo=CardInfo_";病人类型由"_PatTypeOld_"改成了"_PatTypeNew
	.s Flag="Y"
	s SQLCODE=0
	if InsuranceNoOld'=InsuranceNoNew  d
	.s CardInfo=CardInfo_";医保号由"_InsuranceNoOld_"改成了"_InsuranceNoNew
	.s Flag="Y"
	if (Flag="Y") d
	.&sql(insert into SQLUser.DHCUPPERSON (UP_CardNo,UP_RegistrationNo,UP_PAPERName,UPs_PAPERName,UP_CardInfo,UP_Date,UP_Time,UP_UserDr )
	values(:CardNo,:PNO,:PatName,:PatName,:CardInfo,:UPPDate,:UPPTime,:UPPuserDr))
	q SQLCODE
}

/// create 20200915 by yuanlei
/// 修改患者类别、就诊费别、医嘱费别
/// input: AdmId(就诊id), PatTypeRowid(患者类型), InsuranceNo(医保号), ExpStr(UpAdm^UpPat^UpOrd, 修改费别^修改患者类型^修改医嘱费别)
/// output: 0:成功， Other:失败
/// debug: w ##class(web.DHCOPChgAdmreason).UpdatePAOInfo("1889","1","","7","Y^Y^Y")
ClassMethod UpdatePAOInfo(AdmId As %String, PatTypeRowid As %String, InsuranceNo As %String, UserId As %String, ExpStr As %String)
{
	s $zt="UpdatePAOInfoErr"
	s ^tmpyl("UpdatePAOInfo")=$lb(AdmId, PatTypeRowid, InsuranceNo, UserId, ExpStr)
	s UpAdm=$p(ExpStr,"^",1)
	s UpPat=$p(ExpStr,"^",2)
	s UpOrd=$p(ExpStr,"^",3)
	s EmployeeNo=$p(ExpStr,"^",4)
	i UserId="",$d(%session) {
		s UserId=%session.Data("LOGON.USERID")
	}
	q:(AdmId="")!(PatTypeRowid="")!(UserId="") "-101"
	s PatId=$p($g(^PAADM(AdmId)),"^",1)
	s AdmType=$p($g(^PAADM(AdmId)),"^",2)
	s PatNo=##class(web.PAPatMas).GetRegistration(PatId)
	s PatName=$p($g(^PAPER(PatId,"ALL")),"^",1)
	// renyx 增加费别的容错处理
	s AdmReason=""
	s PatAdmDr=$o(^DHCPACADM(0,"Social",PatTypeRowid,0))
	s:PatAdmDr'="" AdmReason=$p(^DHCPACADM(PatAdmDr),"^",2)
	q:AdmReason="" "-107"
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	
	ts
	s ret=0
	;修改就诊费别
	if UpAdm="Y",AdmReason'="" {
		&sql(update SQLUser.PA_Adm set PAADM_AdmReason_DR=:AdmReason where PAAdm_RowId=:AdmId)
		if SQLCODE=0 s ret=0
		else  s ret="-102"
	}
	if ret'=0 {
		tro
		q ret
	}
	
	;修改患者类型
	if UpPat="Y" {
		s OldLogData=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatId_"^"_"User.PAPerson"_$c(2)_PatId)
		
		s desc=0
		&sql(update SQLUser.PA_Person set PAPER_SocialStatus_Dr=:PatTypeRowid,PAPER_EmployeeNo=:EmployeeNo where PAPER_RowID=:PatId)
		s desc=desc+SQLCODE
		s InsuranceNo=$ZCVT(InsuranceNo,"U")
		&sql(update SQLUser.PA_PatMas set PAPMI_HealthFundNo=:InsuranceNo where PAPMI_Rowid=:PatId)	
		s desc=desc+SQLCODE
		if desc=0 s ret=0
		else  s ret="-102"
		
		if ret=0 {
			s NewLogData=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatId_"^"_"User.PAPerson"_$c(2)_PatId)
			s LogRet=##class(web.DHCDocDataChangeLog).SaveLog("PA_PatMas#PA_Person","User.PAPatMas#User.PAPerson","患者基本信息","User.PAPatMas#User.PAPerson_"_PatId,PatName,"U",NewLogData,OldLogData)
			if LogRet'=0 s ret="-105"	;日志添加失败
		}
		s CFMedifyPatTypeSynAdmRea=##class(web.DHCOPRegConfig).GetSpecConfigNode("MedifyPatTypeSynAdmRea")
	    i (CFMedifyPatTypeSynAdmRea=1){
			d ##class(web.DHCBL.Patient.DHCPatient).UpdateAdmedReason(PatId)
	    }
	}
	if ret'=0 {
		tro
		q ret
	}
	
	;修改医嘱费别
	if UpOrd="Y",AdmReason'="" {
		s InsurBillStr=##Class(web.DHCDocOrderCommon).GetInsurBillStr(AdmType)
		s InsurBill=1
		if ("^"_InsurBillStr_"^")'[("^"_AdmReason_"^") {
			s InsurBill=0
		}
		s desc=0
		s OrdId=$o(^OEORD(0,"Adm",AdmId,0))
		if OrdId'="" {
			s OrdSub=0 f {
				s OrdSub=$o(^OEORD(OrdId,"I",OrdSub))
				q:OrdSub=""
				s ArcimID=$p($g(^OEORD(OrdId,"I",OrdSub,1)),"^",2)
				continue:ArcimID=""
				s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
				s OrdStatusDr=$p($g(^OEORD(OrdId,"I",OrdSub,1)),"^",13)
				s OrdStatus=""
				s:OrdStatusDr'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDr),"^",1)

				continue:(OrdStatus'="V")&&(OrdStatus'="E")
				s OldAdmReason=$p($g(^OEORD(OrdId,"I",OrdSub,11)),"^",18)
				continue:OldAdmReason=AdmReason
				s OrderID=OrdId_"||"_OrdSub

				s OldLogData=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.OEOrdItem"_$c(2)_OrderID_"^"_"User.OEOrdItemExt"_$c(2)_OrderID)

				s OrderChronicDiagCode=$P($g(^OEORD(OrdId,"I",OrdSub,"DHC")),"^",66)
				//清空慢病病种
				if (InsurBill=0)&&(OrderChronicDiagCode'=""){
					&sql(update SQLUser.OE_OrdItemExt set OEORI_ChronicDiagCode=null where OEORI_RowId=:OrderID)
					s desc=desc+SQLCODE
				}
				&sql(update SQLUser.OE_OrdItem set OEORI_BBExtCode=:AdmReason where OEORI_RowId=:OrderID)
				s desc=desc+SQLCODE
				
				if desc'=0 {
					s ret="-103"	;修改医嘱数据失败
					q
				}
				s AdmReasonYBType=$p($g(^PAC("ADMREA",AdmReason)),"^",5)
				s CoverMainIns=$P($G(^OEORD(+OrderID,"I",$P(OrderID,"||",2),3)),"^",3)
				i AdmReasonYBType=1{
					s CoverMainInsFlag="Y"
				}else{
					s CoverMainInsFlag="N"
				}
				i CoverMainInsFlag'=CoverMainIns {
					&SQL(Update SQLUser.OE_OrdItem set OEORI_CoverMainIns=:CoverMainInsFlag where OEORI_RowId=:OrderID)
					s desc=desc+SQLCODE
				}
				if desc'=0 {
					s ret="-105"	;修改医嘱数据医保标志
					q
				}
				s NewLogData=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.OEOrdItem"_$c(2)_OrderID_"^"_"User.OEOrdItemExt"_$c(2)_OrderID)
				s LogRet=##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdItem#OE_OrdItemExt","User.OEOrdItem#User.OEOrdItemExt","医嘱信息","User.OEOrdItem#User.OEOrdItemExt_"_OrderID,ArcimDesc,"U",NewLogData,OldLogData)
				if LogRet'=0 {
					s ret="-104"	;日志添加失败
					q 
				}
			}
		}
	}
	if ret'=0 {
		tro
		q ret
	}
	tc
	q ret

UpdatePAOInfoErr
	s $zt=""
	if $TLEVEL>0 tro
	q $ze
}

}
