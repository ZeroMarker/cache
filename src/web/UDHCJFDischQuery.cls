Import SQLUser

Class web.UDHCJFDischQuery Extends BILL.COM.Abstract
{

/// Description: 出院患者查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFDischQuery","QryDisChgPatList","2022-11-29","2022-12-14","","","","Nur","!!!!!!N","2")
Query QryDisChgPatList(StDate As %String, EndDate As %String, PatientNo As %String, PatientName As %String, MedicareNo As %String, AdmStatus As %String, ExpStr As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TPatientNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAge:%String:年龄,TDept:%String:科室,TWard:%String:病区,TAdmDate:%String:入院日期,TAdmTime:%String:入院时间,TDischDate:%String:出院日期,TDischTime:%String:出院时间,TDisc:%String:最终结算状态,TMedDischDate:%String:医疗结算日期,TMedDiscTime:%String:医疗结算时间,TBed:%String:床号,TPatFee:%Float:未结算费用,TDeposit:%Float:押金,TRemain:%Float:余额,TRcptNo:%String:收据号,TPayDate:%String:结算日期,TPayTime:%String:结算时间,TInsType:%String:费别,TAddress:%String:现住址,TEpisodeID:%String:就诊ID,TConfirmFlag:%String:审核标志,TMRDiagnos:%String:诊断,TTelephone:%String:联系电话,TDecease:%String:患者状态,TInTimes:%String:住院次数,THomePlace:%String:籍贯,TEncryptLevel:%String:密级,TPatLevel:%String:级别,TAdmDoc:%String:管床医生,TPatientID:%String:患者基本信息ID,TBillID:%String:账单ID,TPatShareAmt:%Float:自付费用,TInsuArea:%String:参保地,TIsInsuReg:%String:是否医保登记,PersonId:%String:身份证号") [ SqlProc ]
{
}

ClassMethod QryDisChgPatListExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, PatientNo As %String, PatientName As %String, MedicareNo As %String, AdmStatus As %String, ExpStr As %String, HospId As %String, LangId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryDisChgPatList")=$lb(StDate, EndDate, PatientNo, PatientName, MedicareNo, AdmStatus, ExpStr, HospId)
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set LocId=$p(ExpStr,"!",1)
	set WardId=$p(ExpStr,"!",2)
	set DocId=$p(ExpStr,"!",3)
	set InsTypeId=$p(ExpStr,"!",4)
	set BedNo=$p(ExpStr,"!",5)
	set DiagDR=$p(ExpStr,"!",6)
	set InsuReg=$p(ExpStr,"!",7)
	set Diagnos=$s((+DiagDR'=0):$p($g(^MRC("ID",DiagDR)),"^",2),1:"")
	
 	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
 	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	
 	kill patIdAry
	if (PatientNo'="") {
		set PatientNo=##class(web.UDHCJFBaseCommon).regnocon(PatientNo)
		set papmi=$o(^PAPERi("PAPMI_PatNo",$zcvt(PatientNo,"U"),""))
		if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (MedicareNo'="") {
	 	set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicareNo, "I", HospId)
	 	if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (PatientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(PatientName, .patIdAry)
	}
 	
 	set patFeeAll=0, depositAll=0, remainAll=0
    set patShareSum=0
    
	//当前在院
    if (AdmStatus="Admit") {
	    set adm=0
	    while($o(^PAADMi("AdmTypeCurr","I",adm))) {
		    set adm=$o(^PAADMi("AdmTypeCurr","I",adm))
		    do InitOutput
		    //set billFlag=$p(^PAADM(adm),"^",45)
			//continue:(billFlag="Y")
			set papmi=$p(^PAADM(adm),"^",1)
			set rtn=$$GetPatInfo(papmi)
			continue:('rtn)
			set rtn=$$GetAdmInfo(adm)
			continue:('rtn)
			do GetAdmFeeInfo(adm)
			do OutputDisChgPatList
		}
	}
	
	//医生确认
	if (AdmStatus="Doc") {
		for date=StDate:1:EndDate {
			set adm=0
		    while($o(^PAADMi("EstDisch",date,adm))) {
			    set adm=$o(^PAADMi("EstDisch",date,adm))
			    do InitOutput
			    //set billFlag=$p(^PAADM(adm),"^",45)
				//continue:(billFlag="Y")
				set papmi=$p(^PAADM(adm),"^",1)
				set rtn=$$GetPatInfo(papmi)
				continue:('rtn)
				set rtn=$$GetAdmInfo(adm)
				continue:('rtn)
				do GetAdmFeeInfo(adm)
				do OutputDisChgPatList
		   	}
		}
	}
	
	//最终结算
	if (AdmStatus="Nur") {
		for date=StDate:1:EndDate {
			set adm=0
		    while($o(^PAADMi("DischDate",date,adm))) {
			    set adm=$o(^PAADMi("DischDate",date,adm))
			    do InitOutput
				//set billFlag=$p(^PAADM(adm),"^",45)
				//continue:(billFlag="Y")
				set papmi=$p(^PAADM(adm),"^",1)
				set rtn=$$GetPatInfo(papmi)
				continue:('rtn)
				set rtn=$$GetAdmInfo(adm)
				continue:('rtn)
				do GetAdmFeeInfo(adm)
				do OutputDisChgPatList
		   	}
		}
	}
	
	//财务结算
	if (AdmStatus="Pay") {
		for date=StDate:1:EndDate {
			set prtRowId=0
			while($o(^DHCINVPRTZY(0,"DATE",date,prtRowId))) {
				set prtRowId=$o(^DHCINVPRTZY(0,"DATE",date,prtRowId))
				set invData=$g(^DHCINVPRTZY(prtRowId))
				do InitOutput
				set prtHospDR=$p(invData,"^",35)
				continue:(prtHospDR'=HospId)
				set initInvDR=$p(invData,"^",13)
				continue:(+initInvDR'=0)   //过滤取消结算的负记录
				continue:($d(^DHCINVPRTZY(0,"InitInv",prtRowId)))   //过滤被取消结算的记录
				set billId=$p(invData,"^",5)
				set adm=$p(invData,"^",4)
				set papmi=$p(invData,"^",18)
				set rtn=$$GetPatInfo(papmi)
				continue:('rtn)
				set rtn=$$GetAdmInfo(adm)
				continue:('rtn)
				set billFlag=$p(^PAADM(adm),"^",45)
				if (billFlag="Y") set disc="财务结算"
				set patShareAmt=$p($g(^DHCPB(billId)),"^",12)   //患者自付费用
				set patShareAmt=$fn(patShareAmt,"",2)
				set patShareSum=patShareSum+patShareAmt
				set prtDate=$p(invData,"^",2)
				set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
				set prtTime=$p(invData,"^",3)
				set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
				set patFee=$p(invData,"^",6)
				set rcptno=$p(invData,"^",1)
				set deposit=##class(web.UDHCJFBaseCommon).arpbldeposit(adm)
				//tangzf 2019-12-19 start
				set patFeeInfo=##class(web.UDHCJFCKD).getPatFeeInfo(adm)
				set patFee=$p(patFeeInfo,"^",1)                 //通过一个接口取数据 未结算费用
				//
				set remain=deposit-patShareAmt        //已结算记录，担保金额不算入
				set remain=$fn(remain,"",2)
				set patFeeAll=patFeeAll+patFee
				set depositAll=depositAll+deposit
				set remainAll=remainAll+remain
				do OutputDisChgPatList
			}
		}
	}
	
	if (ind>1) {
		do InitOutput
		set (adm, papmi)=""
		set regNo=##class(websys.Translation).Get("", "合计", LangId)
		set patFee=$fn(patFeeAll,"",2)
		set deposit=$fn(depositAll,"",2)
		set remain=$fn(remainAll,"",2)
		set patShareAmt=$fn(patShareSum,"",2)
		do OutputDisChgPatList
	}

	quit $$$OK

InitOutput
	set (patName, regNo, sex, age, dept, ward, admDate, admTime, dischDate, dischTime)=""
	set (patFee, deposit, remain, disc, medDischDate, medDiscTime, bed, mrNo, insType, address)=""
	set (confirmFlag, diagDesc, telephone, decease, inTimes, HomePlace, admDoc)=""
	set (rcptno, billId, prtDate, prtTime, insuArea, isInsuReg, EncryptLevel, PatLevel)=""
	quit

GetPatInfo(papmi)
	if ($d(patIdAry)) {
		quit:('$d(patIdAry(papmi))) 0  //根据患者查询，但不是该患者时返回0
	}
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	set sex=$s((sexDR'=""):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, LangId)
	set telephone=$p($g(^PAPER(papmi,"PER",1)),"^",11)
	set personId=$p(^PAPER(papmi,"ALL"),"^",9)  //2023-03-20 LUANZH 身份证号
	//add by lml 2015-01-15 增加病人密级和级别
	set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set EncryptLevel=$p(PatEncryptLevel,"^",1)
	set PatLevel=$p(PatEncryptLevel,"^",2)
	set address=$g(^PAPER(papmi,"PER","ADD",1))      //现住址
	set dobDate=$p($g(^PAPER(papmi,"ALL")),"^",6)
	set dobDate=##class(websys.Conversions).DateLogicalToHtml(dobDate)
	//取籍贯PAPER_Province_Birth_DR,PAPER_CityBirth_DR
 	set PAPERProvDR=$p($g(^PAPER(papmi,"PER",2)),"^",11)
	set PAPERProvince=$s((PAPERProvDR'=""):$p($g(^CT("PROV",PAPERProvDR)),"^",2),1:"")
	set PAPERProvince=##class(User.CTProvince).GetTranByDesc("PROVDesc", PAPERProvince, LangId)
 	set PAPERCityDR=$p($g(^PAPER(papmi,"ALL")),"^",18)
 	set PAPERCity=$s((PAPERCityDR'=""):$p(^CT("CIT",PAPERCityDR),"^",2),1:"")
 	set PAPERCity=##class(User.CTCity).GetTranByDesc("CTCITDesc", PAPERCity, LangId)
  	set HomePlace=PAPERProvince_" "_PAPERCity
	quit 1
	
GetAdmInfo(adm)
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	if (admHospDR'=HospId) {
		quit 0
	}
	set admType=$p(^PAADM(adm),"^",2)
	if (admType'="I") {
		quit 0
	}
	set visitStatus=$p(^PAADM(adm),"^",20)
	if (visitStatus="C") {
		quit 0
	}
	set billFlag=$p(^PAADM(adm),"^",45)
	
   	set diagDesc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(adm, "", "", "", "", ";")  //诊断
	if ((Diagnos'="")&&((";"_diagDesc_";")'[(";"_Diagnos_";"))) {
		quit 0
	}
	
	set decease=..GetDeceaseStatus(papmi, adm, LangId)
	set deptDR=$p(^PAADM(adm),"^",4)
	if ((LocId'="")&&(("^"_LocId_"^")'[("^"_deptDR_"^"))){
		quit 0
	}
	set dept=$s((deptDR'=""):$p(^CTLOC(deptDR),"^",2),1:"")
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, LangId)
	set wardDR=$p(^PAADM(adm),"^",70)
	if ((WardId'="")&&(WardId'=wardDR)) {
		quit 0
	}
	set ward=$s((wardDR'=""):$p(^PAWARD(wardDR),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, LangId)
	set insTypeDR=$p(^PAADM(adm,1),"^",7)
	if ((InsTypeId'="")&&(insTypeDR'=InsTypeId)) {
		quit 0
	}
	set insType=$s((insTypeDR'=""):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, LangId)
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
	if ((BedNo'="")&&(bed'[BedNo)) {
		quit 0
	}
	set admDocDR=$p(^PAADM(adm),"^",9)
	if ((DocId'="")&&(DocId'=admDocDR)) {
		quit 0
	}
	set admDoc=$s((+admDocDR'=0):$p(^CTPCP(admDocDR,1),"^",2),1:"")   //2015-06-18 zhuangna 管床医生
	set admDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", admDoc, LangId)
	
	set insuRegStr=##class(web.DHCINSUPort).CheckRegActFlag(adm,"")
	set isInsuReg=$p(insuRegStr,"!",1)      //是否医保登记标识
	if ((InsuReg'="")&&(InsuReg'=isInsuReg)) {
		quit 0
	}

	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	set disc=$p(admInOutDateInfo,"^",4)
	set admDate=$p(admInOutDateInfo,"^",5)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(admInOutDateInfo,"^",6)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set dischDate=$p(admInOutDateInfo,"^",7)
	set dischDate=##class(websys.Conversions).DateLogicalToHtml(dischDate)
	set dischTime=$p(admInOutDateInfo,"^",8)
	set dischTime=##class(websys.Conversions).TimeLogicalToHtml(dischTime)
	
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	set isConfirm=..GetConfirmFlag(adm)
	set confirmFlag=$case(isConfirm,"Y":"审核通过","N":"审核拒绝","C":"撤销审核","P":"部分账单审核通过",:"未审核")
	set confirmFlag=##class(websys.Translation).Get("", confirmFlag, LangId)
	set medDischDate=$p(^PAADM(adm),"^",59)   //PAADM_EstimDischargeDate
	set medDiscTime=$p(^PAADM(adm),"^",60)    //PAADM_EstimDischargeTime
	set medDischDate=##class(websys.Conversions).DateLogicalToHtml(medDischDate)
	set medDiscTime=##class(websys.Conversions).TimeLogicalToHtml(medDiscTime)
	
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	set inTimes=##class(EMRservice.DAL.GetPaAdmDetail).InTimes(adm, "")
	
	set insuInfo=##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(adm)
	set insuArea=$p(insuInfo,"^",8)   //统筹区
	
	quit 1

GetAdmFeeInfo(adm)
	set deposit=##class(web.UDHCJFCKD).deposit(adm)
	set patFeeInfo=##class(web.UDHCJFCKD).getPatFeeInfo(adm)
	set patFee=$p(patFeeInfo,"^",1)        //通过一个接口取数据 未结算费用
	set patShareAmt=$p(patFeeInfo,"^",2)   //患者自付费用
	set patShareSum=patShareSum+patShareAmt
	set warrantAmt=##class(web.UDHCJFZYDB).GetWarrAmt(adm)
	set warrantAmt=$fn(warrantAmt,"",2)
	set remain=deposit+warrantAmt-patShareAmt
	set remain=$fn(remain,"",2)
	set patFeeAll=patFeeAll+patFee
	set depositAll=depositAll+deposit
	set remainAll=remainAll+remain
	quit
	
OutputDisChgPatList
	set Data=$lb(regNo,mrNo,patName,sex,age,dept,ward,admDate,admTime,dischDate,dischTime,disc,medDischDate,medDiscTime,bed,patFee,deposit,remain,rcptno,prtDate,prtTime,insType,address,adm,confirmFlag,diagDesc,telephone,decease,inTimes,HomePlace,EncryptLevel,PatLevel,admDoc,papmi,billId,patShareAmt,insuArea,isInsuReg,personId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod Cconfirm(adm As %String, userId As %String)
{
	quit:((adm="")||('$d(^PAADM(adm)))) ""
	quit:(userId="") ""
	
	set ConfirmFlag="N"
	set CodingUpdateUser=$p(^PAADM(adm,2),"^",92)
	if (CodingUpdateUser="") set ConfirmFlag="N"
	else  set ConfirmFlag="Y"
	quit:(ConfirmFlag="N") ConfirmFlag
	
	set billFlag=$p(^PAADM(adm),"^",45)
	quit:(billFlag="Y") 100
	
	set rtn=0
	set curDate=+$h
	set curTime=$p($h,",",2)

	ts
	
	&SQL(
		UPDATE PA_Adm
		SET PAADM_CodingUpdateDate = :curDate, PAADM_CodingUpdateTime = :curTime
		WHERE %ID = :adm
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	set $p(^PAADM(adm,2),"^",92)=""
	set ^DHCZYJFConfirm("CConfirm",userId,curDate,curTime,adm)=curDate_"^"_curTime_"^"_adm_"^"_userId
	
	quit rtn
}

/// Creator：陈曦
/// CreatDate: 2009-03-24
/// Description: 根据病人的就诊rowid取病人取病人未结算的账单数量和账单rowid          
/// Input: PAADMRowID:PA_Adm.PAADM_RowID
/// Return: 未结算的帐单数量，账单rowid
/// Debug: w ##class(web.UDHCJFDischQuery).JudgeBillNum()
ClassMethod JudgeBillNum(PAADMRowID As %String) As %String
{
	set billIdStr=""
	set PBNum=0
	quit:(+PAADMRowID=0) PBNum_"^"_billIdStr
	set pb=0
	while($o(^DHCPB(0,"ADM",PAADMRowID,pb))) {
		set pb=$o(^DHCPB(0,"ADM",PAADMRowID,pb))
		set payedflag=$p(^DHCPB(pb),"^",16)
		set PaidCAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
		continue:((payedflag="P")&&(PaidCAcountFlag'="Y"))
		set PBNum=$i(PBNum)
		set billIdStr=$s((billIdStr=""):pb,1:(billIdStr_","_pb))
	}
	quit PBNum_"^"_billIdStr
}

/// Creator: hujunbin
/// CreatDate: 2014-11-30
/// Input: patientId:患者ID, adm:病人本次就诊
/// Return: 出院病人查询中如果病人死亡，则最后一次就诊才显示死亡状态，其他为正常
/// Debug: w ##class(web.UDHCJFDischQuery).GetDeceaseStatus(77, "46")
ClassMethod GetDeceaseStatus(patientId As %String, adm As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set decease=##class(websys.Translation).Get("", "正常", langId)
	quit:(+patientId=0) decease
	
	set endEmAdm=$o(^PAPERdr(patientId,"ADM","E",""),-1)   //急诊最后一次就诊
	set endInAdm=$o(^PAPERdr(patientId,"ADM","I",""),-1)   //住院最后一次就诊
	set endAdm=$s((+endEmAdm>+endInAdm):endEmAdm,1:endInAdm)
	set deceaseFlag=$p(^PAPER(patientId,"ALL"),"^",12)     //死亡状态
	quit:(deceaseFlag'="Y") decease
	if (adm=endAdm) {
		set decease=##class(websys.Translation).Get("", "死亡", langId)
	}
	quit decease
}

/// Debug: w ##class(web.UDHCJFDischQuery).GetConfirmFlag(66)
ClassMethod GetConfirmFlag(adm As %String) As %String
{
	s ConfirmFlag=""
	q:(+adm=0) ConfirmFlag
	s num=0, connum=0
	s pb=0
	f  s pb=$o(^DHCPB(0,"ADM",adm,pb))  q:(pb="")  d
	.s pbData=$g(^DHCPB(pb))
	.q:(pbData="")
	.s payedflag=$p(pbData,"^",16)
	.s PaidCAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
	.//q:((payedflag="P")&&(PaidCAcountFlag'="Y"))	//Lid 2017-03-24 注释，解决已经审核通过，并做了财务结算，但是在出院患者查询界面显示“未审核”的Bug。
    .s ConfirmFlag=##class(web.UDHCJFBillDetailOrder).GetCodingFlag(adm, pb)
    .s num=$i(num)
    .i (ConfirmFlag="Y") s connum=$i(connum)
    
    i ((num=connum)&&(num'=0)) s ConfirmFlag="Y"		;全部账单审核通过
    e  d
    .i (connum=1) s ConfirmFlag="P"		;部分账单审核通过
    
	q ConfirmFlag
}

/// Creator: ZhYW
/// CreatDate: 2023-03-15
/// Description: 取科室是否允许多选配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->出院患者查询->科室是否允许多选
/// Debug: w ##class(web.UDHCJFDischQuery).IsDeptMulti(2)
ClassMethod IsDeptMulti(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.DscgPatQury.KSSFYXDX", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

}
