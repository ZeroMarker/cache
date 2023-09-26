Class web.UDHCJFinfro Extends BILL.COM.Abstract
{

/// currFlag: billed=未结算; paid=结算历史; tobill=新入院, disch=最终结算
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFinfro","QryPatientList","","","","","","","","","2")
Query QryPatientList(stDate As %String, endDate As %String, insTypeId As %String, userId As %String, patientNo As %String, patientName As %String, wardId As %String, currFlag As %String, hospId As %String, langId As %String = "", medicareNo As %String = "") As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAge:%String:年龄,TCompany:%String:单位,TAddress:%String:家庭住址,TDept:%String:科室,TInsType:%String:费别,TAdmDate:%String:入院时间,TUpdtUser:%String:操作员,TWard:%String:病区,TAdmStatus:%String:就诊状态,TBed:%String:床号,TAdmId:%String,TDischgDate:%String:出院时间,TTotalSum:%Float:总费用,TRemark:%String:备注,TMRCIDDesc:%String:诊断,TDeposit:%Float:押金,TBillFlag:%String:结算标志,TTelNo:%String:联系电话,THomePlace:%String:籍贯,TAdmInPatNo:%String:住院次数,TEncryptLevel:%String:密级,TPatLevel:%String:级别,TFinalDate:%String:财务结算时间,TFinalUser:%String:收费员,TIDNo:%String:身份证号,TActiveFlag:%String:医保登记状态,TAdmSeriNo:%String:登记流水号") [ SqlProc ]
{
}

ClassMethod QryPatientListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, insTypeId As %String, userId As %String, patientNo As %String, patientName As %String, wardId As %String, currFlag As %String, hospId As %String, langId As %String = "", medicareNo As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryPatientList")=$lb(stDate, endDate, insTypeId, userId, patientNo, patientName, wardId, currFlag, hospId, langId, medicareNo)
	
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
 	kill patIdAry
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set papmi=$o(^PAPERi("PAPMI_PatNo",$zcvt(patientNo,"U"),""))
		if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (medicareNo'="") { //+gongxin 2023-05-08 增加病案号查询
		set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId)
	 	if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (patientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(patientName, .patIdAry)
	}
	
	//当前在院
	if (currFlag="A") {
		set adm=0
		while($o(^PAADMi("AdmTypeCurr","I",adm))) {
			set adm=$o(^PAADMi("AdmTypeCurr","I",adm))
			set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		    continue:(admHospDR'=hospId)
			do patinfro(adm)
		}
		quit $$$OK
	}
    
    //出院
    if (currFlag="D") {
	    for date=stDate:1:endDate {
			set adm=0
			while($o(^PAADMi("DischDate",date,adm))) {
				set adm=$o(^PAADMi("DischDate",date,adm))
				set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
			    continue:(admHospDR'=hospId)
			    set admType=$p($g(^PAADM(adm)),"^",2)
				continue:(admType'="I")
				do patinfro(adm)
			}
		}
		quit $$$OK
	}
	
	if ((patientNo'="")||(patientName'="")||(medicareNo'="")) {
		set papmi=0
		while($o(patIdAry(papmi))) {
			set papmi=$o(patIdAry(papmi))
			set adm=0
			while($o(^PAPERdr(papmi,"ADM","I",adm))) {
				set adm=$o(^PAPERdr(papmi,"ADM","I",adm))
				set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
			    continue:(admHospDR'=hospId)
				set admDate=$p($g(^PAADM(adm)),"^",6)
				continue:((admDate<stDate)||(admDate>endDate))
				do patinfro(adm)
			}
		}
		quit $$$OK
	}
	
	for date=stDate:1:endDate {
		set adm=0
		while($o(^PAADMi("PAADM_AdmDate",date,adm))) {
			set adm=$o(^PAADMi("PAADM_AdmDate",date,adm))
			set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		    continue:(admHospDR'=hospId)
			set admType=$p($g(^PAADM(adm)),"^",2)
			continue:(admType'="I")
			set admDate=$p($g(^PAADM(adm)),"^",6)
			continue:((admDate<stDate)||(admDate>endDate))
			do patinfro(adm)
		}
	}
		
	quit $$$OK
	
patinfro(adm)
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	quit:(visitStatus="P")     //过滤预住院记录
	quit:((currFlag'="P")&&(currFlag'=visitStatus))
	set admStatus=$case(visitStatus,"A":"在院","C":"退院","D":"出院","P":"预约",:"")
	set admStatus=##class(websys.Translation).Get("", admStatus, langId)
	set papmi=$p($g(^PAADM(adm)),"^",1)
	quit:((patientNo'="")&&('$d(patIdAry(papmi))))
	quit:((patientName'="")&&('$d(patIdAry(papmi))))
	quit:((medicareNo'="")&&('$d(patIdAry(papmi))))  //+gongxin 2023-05-08 病案号过滤
	
	set deptDR=$p($g(^PAADM(adm)),"^",4)
    set admDept=$s((deptDR'=""):$p($g(^CTLOC(deptDR)),"^",2),1:"")
    set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	set wardDR=$p($g(^PAADM(adm)),"^",70)
	quit:((wardId'="")&&(("^"_wardId_"^")'[("^"_wardDR_"^")))
	set ward=$s((wardDR'=""):$p($g(^PAWARD(+wardDR)),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
	quit:((insTypeId'="")&&(admReaDR'=insTypeId))
	set insType=$s((admReaDR'=""):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
    set admBillFlag=$p(^PAADM(adm),"^",45)
	quit:((currFlag="P")&&(admBillFlag'="Y"))
	set billFlag="", finalDate="", finalUser=""
	if (admBillFlag="Y") {
		set billFlag="结算"
		set finalInfo=##class(web.UDHCJFBaseCommon).GetFinalDateAndUser(adm)
		set finalDate=$p(finalInfo,"^",1)
		set finalUser=$p(finalInfo,"^",2)
	}
	set updtUserDR=$p($g(^PAADM(adm)),"^",43)
	quit:((userId'="")&&(("^"_userId_"^")'[("^"_updtUserDR_"^")))
	set updtUser=$s((+updtUserDR'=0):$p($g(^SSU("SSUSR",updtUserDR)),"^",2),1:"")
	set updtUser=##class(User.SSUser).GetTranByDesc("SSUSRName", updtUser, langId)
   	set diagDesc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(adm)   //诊断
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set totalFeeInfo=##class(BILL.IP.COM.Method).GetTotalFeeInfo(adm)
	set totalSum=$p(totalFeeInfo,"^",1)
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	set admDate=$p(admInOutDateInfo,"^",1)
	set disDate=$p(admInOutDateInfo,"^",2)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
    set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)
	set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set homeTel=$p($g(^PAPER(papmi,"PER",1)),"^",11)      //联系电话
	set mobPhone=$p($g(^PAPER(papmi,"PER",4)),"^",21)     //手机号
	set telNo=$s((homeTel=""):mobPhone,1:homeTel_$s((mobPhone'=""):", "_mobPhone,1:""))
	//add by lml 2015-01-15 增加病人密级和级别
	set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set EncryptLevel=$p(PatEncryptLevel,"^",1)
	set PatLevel=$p(PatEncryptLevel,"^",2)
	set remark=$g(^PAPER(papmi,"PER","RMK",1))     //PAPER_Remark 备注
	set company=$p($g(^PAPER(papmi,"PER",4)),"^",18)
	set address=$g(^PAPER(papmi,"PER","ADD",1))
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	//取籍贯PAPER_Province_Birth_DR, PAPER_CityBirth_DR
	set PAPERProvinceDR=$p($g(^PAPER(papmi,"PER",2)),"^",11)
	set PAPERProvince=$s((PAPERProvinceDR'=""):$p(^CT("PROV",PAPERProvinceDR),"^",2),1:"")
	set PAPERProvince=##class(User.CTProvince).GetTranByDesc("PROVDesc", PAPERProvince, langId)
	set PAPERCityDR=$p(^PAPER(papmi,"ALL"),"^",18)
	set PAPERCity=$s((PAPERCityDR'=""):$p(^CT("CIT",PAPERCityDR),"^",2),1:"")
	set PAPERCity=##class(User.CTCity).GetTranByDesc("CTCITDesc", PAPERCity, langId)
	set HomePlace=PAPERProvince_" "_PAPERCity
    set IDNo=$p($g(^PAPER(papmi,"ALL")),"^",9)	 //身份证号
    set insuAdmInfo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(adm)
    set ActiveFlag=$p(insuAdmInfo,"^",12)
	set AdmSeriNo=$s(((" A O ")[(" "_ActiveFlag_" ")):$p(insuAdmInfo,"^",11),1:"")
    set AdmInPatNo=##class(EMRservice.DAL.GetPaAdmDetail).InTimes(adm, "")    //住院次数
    do OutputPatList
	quit
	
OutputPatList
	set Data=$lb(regNo,mrNo,patName,sex,age,company,address,admDept,insType,admDate,updtUser,ward,admStatus,bed,adm,disDate,totalSum,remark,diagDesc,deposit,billFlag,telNo,HomePlace,AdmInPatNo,EncryptLevel,PatLevel,finalDate,finalUser,IDNo,ActiveFlag,AdmSeriNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
