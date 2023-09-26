Import SQLUser

/// 名称: web.DHCIPBillDeposit.cls
/// 描述: 住院押金管理业务类
/// 编写者: ZhYW
/// 编写日期: 2019-06-03
Class web.DHCIPBillDeposit Extends BILL.COM.Abstract
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDeposit","FindBed",11, "")
Query FindBed(wardId As %String, bedCode As %String) As websys.Query(ROWSPEC = "regNo:%String,patName:%String,bed:%String")
{
}

ClassMethod FindBedExecute(ByRef qHandle As %Binary, wardId As %String, bedCode As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
 	if (wardId="") quit $$$OK
 	
	set roomId=""
	while($o(^PAADMi("CurrWard",wardId,roomId))'="") {
		set roomId=$o(^PAADMi("CurrWard",wardId,roomId))
		set rowId=0
		while($o(^PAADMi("CurrWard",wardId,roomId,rowId))) {
			set rowId=$o(^PAADMi("CurrWard",wardId,roomId,rowId))
			set visitStatus=$p($g(^PAADM(rowId)),"^",20)
			continue:(visitStatus'="A")
			set bed=##class(web.DHCBillCommon).GetPatBedCode(rowId)
 			continue:((bedCode'="")&&(bed'[bedCode))
   			set papmi=$p($g(^PAADM(rowId)),"^",1)
   			set patNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
   			set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
   			do OutputBed
		}
	}

    quit $$$OK
OutputBed
	set Data=$lb(patNo,patName,bed)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDeposit","FindAdmInfo","","0000000010","","","","2")
Query FindAdmInfo(patientName As %String, patientNo As %String, wardId As %String, medicareNo As %String, admType As %String, sessionStr As %String) As websys.Query(ROWSPEC = "TPatientId:%String:患者基本信息ID,TPatNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TDept:%String:科室,TWard:%String:病区,TBed:%String:床号,TAdmReason:%String:就诊费别,TAdmDate:%String:入院日期,TAdmTime:%String:入院时间,TDischDate:%String:出院日期,TDischTime:%String:出院时间,TEncryptLevel:%String:密级,TPatLevel:%String:级别,TAdmType:%String:就诊类型")
{
}

ClassMethod FindAdmInfoExecute(ByRef qHandle As %Binary, patientName As %String, patientNo As %String, wardId As %String, medicareNo As %String, admType As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindAdmInfo")=$lb(patientName, patientNo, wardId, medicareNo, admType, sessionStr)
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	kill patIdAry
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set papmi=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
		if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (medicareNo'="") {
		set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
		if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (patientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(patientName, .patIdAry)
	}

	if ($d(patIdAry)) {
		set papmi=0
		while($o(patIdAry(papmi))) {
			set papmi=$o(patIdAry(papmi))
			do GetPatInfo(papmi)
		}
		quit $$$OK
	}
	
	if (wardId'="") {
		set roomId=""
		while($o(^PAADMi("CurrWard",wardId,roomId))'="") {
			set roomId=$o(^PAADMi("CurrWard",wardId,roomId))
			set adm=0
			while($o(^PAADMi("CurrWard",wardId,roomId,adm))) {
				set adm=$o(^PAADMi("CurrWard",wardId,roomId,adm))
				set visitStatus=$p($g(^PAADM(adm)),"^",20)
				continue:(visitStatus="C")
				set billFlag=$p($g(^PAADM(adm)),"^",45)
	  			continue:(billFlag="Y")
				do GetAdmInfo(adm)
			}
		}
	}
	
    quit $$$OK
    
GetPatInfo(papmi)
 	set type=""
 	while($o(^PAPERdr(papmi,"ADM",type))'="") {
	 	set type=$o(^PAPERdr(papmi,"ADM",type))
	 	set adm=0
	 	while($o(^PAPERdr(papmi,"ADM",type,adm))) {
		 	set adm=$o(^PAPERdr(papmi,"ADM",type,adm))
		 	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
			continue:(admHospDR'=hospId)
			set visitStatus=$p($g(^PAADM(adm)),"^",20)
			continue:(visitStatus="C")
			continue:((admType="P")&&(visitStatus'="P"))
			continue:((admType="I")&&((visitStatus="P")||(type'="I")))
			set billFlag=$p($g(^PAADM(adm)),"^",45)
  			continue:(billFlag="Y")
			set transLogDR=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",adm,""),-1)
			set transUserDR=$s((+transLogDR'=0):$p(^DHCBillPreIPAdmTransLog(transLogDR),"^",3),1:"")
			continue:((type'="I")&&(+transUserDR=0))
			do GetAdmInfo(adm)
		}
	}
	
	quit
GetAdmInfo(adm)
	set papmi=$p($g(^PAADM(adm)),"^",1)
	set patNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
    set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
    set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
 	set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)
 	set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
 	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	//患者密级和级别
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
	
    set visitStatus=$p($g(^PAADM(adm)),"^",20)
    set myAdmType=$p($g(^PAADM(adm)),"^",2)
	set transLogDR=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",adm,""),-1)
	set transUserDR=$s((+transLogDR'=0):$p(^DHCBillPreIPAdmTransLog(transLogDR),"^",3),1:"")
    set admTypeDesc=$case(myAdmType,"I":"住院","O":"门诊",:"")
    if (visitStatus="P") {
	    set admTypeDesc="预住院"
	}
    if (+transUserDR'=0) {
	    set admTypeDesc=admTypeDesc_" (预住院转入)"
	}
	set admTypeDesc=##class(websys.Translation).Get("dhcbill.ipbill.deposit.main.csp", admTypeDesc, langId)
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	set admDate=$p(admInOutDateInfo,"^",5)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(admInOutDateInfo,"^",6)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set dischDate=$p(admInOutDateInfo,"^",7)
	set dischDate=##class(websys.Conversions).DateLogicalToHtml(dischDate)
	set dischTime=$p(admInOutDateInfo,"^",8)
	set dischTime=##class(websys.Conversions).TimeLogicalToHtml(dischTime)
	set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
	set admReaDesc=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set deptDR=$p($g(^PAADM(adm)),"^",4)
	set dept=$p($g(^CTLOC(deptDR)),"^",2)
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
    set wardDR=$p(^PAADM(adm),"^",70)
    set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
    set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
	
	do outputAdmInfo
	quit
outputAdmInfo
	set Data=$lb(papmi,patNo,mrNo,patName,sex,adm,dept,ward,bed,admReaDesc,admDate,admTime,dischDate,dischTime,EncryptLevel,PatLevel,admTypeDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDeposit","FindDeposit","18","1")
Query FindDeposit(adm As %String, depositType As %String, langId As %String = "") As websys.Query(ROWSPEC = "TPrtDate:%String:收款日期,TPrtTime:%String:收款时间,TPayAmt:%Float:金额,TPaymodeDR:%String:支付方式ID,TPaymode:%String:支付方式,TPrtStatus:%String,TStatus:%String:收据状态,TRecepitNo:%String:收据号,TUserDR:%String:操作员ID,TUserName:%String:收款员,TPayAccNo:%String:账户号,TCompany:%String:单位,TBank:%String:银行,TDepRowId:%String,TFootId:%String:结账ID,TFootFlag:%String:是否结账,TPayedFlag:%String:结算状态,TStrikeInvPrtId:%String,Tbbackflag:%String:是否到账,Tbbackdate:%String:到账日期,Tbbacktime:%String:到账时间,Tbbackuser:%String:到账操作员,TRefreason:%String:退款原因,TChequeNo:%String:支票号,TChequeDate:%String:支票日期,TRemark:%String:备注,TDepositTypeDR:%String,TDepositTypeCode:%String,TDepositType:%String:押金类型,TInitPrtRowId:%String,TAutoFlag:%String,TReRcptNo:%String,TLeftAmt:%Float:可退金额,TLostRegistDR:%String,TLostRegUser:%String:挂失操作员,TLostRegDate:%String:挂失日期,TLostRegTime:%String:挂失时间,TLostRegReason:%String:挂失原因")
{
}

ClassMethod FindDepositExecute(ByRef qHandle As %Binary, adm As %String, depositType As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (adm="")  quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set sum=0

 	set depId=""
 	while($o(^DHCSFPRINTDETAIL(0,"adm",adm,depId),-1)) {
	 	set depId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,depId),-1)
	 	set depData=$g(^DHCSFPRINTDETAIL(depId))
		//zhho 第三方支付补打发票
		set reRcptNo=""
		set rcptInv=0
		while($o(^DHCRcptInvi(0,"RcpNo",depId,rcptInv))&&(reRcptNo="")) {
			set rcptInv=$o(^DHCRcptInvi(0,"RcpNo",depId,rcptInv))
			set flag=$p(^DHCRcptInv(rcptInv),"^",2)
			continue:(flag="A")
			set reRcptNo=$p(^DHCRcptInv(rcptInv),"^",6)
		}
		//
		set depTypeDR=$p(depData,"^",13)
		continue:((depositType'="")&&(depositType'=depTypeDR))
		set depTypeCode=$s((+depTypeDR'=0):$p($g(^ARC("ARCDT",depTypeDR)),"^",1),1:"")
		set depType=$s((+depTypeDR'=0):$p($g(^ARC("ARCDT",depTypeDR)),"^",2),1:"")
		set depType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", depType, langId)
		set rcptNo=$p(depData,"^",1)
		set prtDate=$p(depData,"^",2)
		set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
		set prtTime=$p(depData,"^",3)
		set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
		set payAmt=$p(depData,"^",6)
		set payAmt=$fn(payAmt,"",2)
		set sum=$i(sum, payAmt)
		set prtStatus=$p(depData,"^",8)
		set status=$case(prtStatus,1:"正常",2:"作废",3:"冲红",4:"已冲红",:"")
		set status=##class(websys.Translation).Get("", status, langId)
		set paymSub=$o(^DHCSFPRINTDETAIL(depId,"P",0))
		set paymSubData=$g(^DHCSFPRINTDETAIL(depId,"P",+paymSub))
		set paymDR=$p(paymSubData,"^",1)
		set paymCode=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",1),1:"")
	 	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	 	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
		set bankDR=$p(paymSubData,"^",2)
		set bank=$s((+bankDR'=0):$p($g(^CMC("CMCBM",bankDR)),"^",2),1:"")
 		set bank=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", bank, langId)
		set paymAmt=-$p(paymSubData,"^",3)
		set chequeNo=$p(paymSubData,"^",4)         //卡号/支票号
		set bankCardTypeId=$p(paymSubData,"^",5)
		set payAccNo=$p(paymSubData,"^",6)
		set chequeDate=$p(paymSubData,"^",7)
		set chequeDate=##class(websys.Conversions).DateLogicalToHtml(chequeDate)
		set unitDR=$p(paymSubData,"^",8)
		set company=$s((+unitDR'=0):$p($g(^CT("HCP",unitDR)),"^",2),1:"")
		set company=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", company, langId)
	 	set leftAmt=$p(depData,"^",29)    //可退金额
		set leftAmt=$fn(leftAmt,"",2)
		set userDR=$p(depData,"^",14)
		set userName=$p($g(^SSU("SSUSR",userDR)),"^",2)
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		set group=$p(^SSU("SSUSR",userDR),"^",5)
		set autoFlag=""
		//set autoFlag=$s((group="284"):"Y",1:"")      //第三方支付，根据安全组区分是否需补打标识
	 	set payedFlag=$p(depData,"^",38)
		set jkflag=$p(depData,"^",23)
		set strikeInvPrtId=$p(depData,"^",40)   //prt_refinvprtzy_dr
		set bbackdate="", bbacktime="", bbackuser=""
		set bbackflag=$s(($zcvt(paymCode,"U")="ZP"):"N",1:"")
		set bbackdr=$o(^DHCJFBankBack(0,"Yjrowid",depId,""),-1)
		if (bbackdr'="") {
			set bbackData=$g(^DHCJFBankBack(bbackdr))
			set bbackflag1=$p(bbackData,"^",4)
			set bbackflag=$s((+bbackflag1=0):"Y",1:"N")
			if (bbackflag1=0) {                              //bbackflag1为0表示"到账"
				set bbackuserDR=$p(bbackData,"^",5)
				set bbackuser=$s((+bbackuserDR'=0):$p($g(^SSU("SSUSR",bbackuserDR)),"^",2),1:"")
				set bbackuser=##class(User.SSUser).GetTranByDesc("SSUSRName", bbackuser, langId)
				set bbackdate=$p(bbackData,"^",6)
				set bbackdate=##class(websys.Conversions).DateLogicalToHtml(bbackdate)
				set bbacktime=$p(bbackData,"^",7)
				set bbacktime=##class(websys.Conversions).TimeLogicalToHtml(bbacktime)
			}
		}
		set jkDR=$p(depData,"^",30)
		set yjrefdr=$p(depData,"^",31)
		set refreason=$s((+yjrefdr'=0):$p($g(^DHCJFYJRREASON(yjrefdr)),"^",2),1:"")
		set refreason=##class(User.dhcjfyjrefreason).GetTranByDesc("yjrreadesc", refreason, langId)
		set remark=$p(depData,"^",33)
		set initPrtRowId=$p(depData,"^",43)
	 	set lostRegistDR=$p(depData,"^",34)   //->BILL.IP.DepLostRegist
	 	set lostRegData=$s((+lostRegistDR'=0):$g(^BILL.IP.DepLostRegist(lostRegistDR)),1:"")
		set lostRegUserDR=$p(lostRegData,"^",4)
		set lostRegUser=$s((+lostRegUserDR'=0):$p($g(^SSU("SSUSR",lostRegUserDR)),"^",2),1:"")
		set lostRegUser=##class(User.SSUser).GetTranByDesc("SSUSRName", lostRegUser, langId)
		set lostRegDate=$p(lostRegData,"^",5)
		set lostRegDate=##class(websys.Conversions).DateLogicalToHtml(lostRegDate)
		set lostRegTime=$p(lostRegData,"^",6)
		set lostRegTime=##class(websys.Conversions).TimeLogicalToHtml(lostRegTime)
		set lostRegReason=$p(lostRegData,"^",7)
		do OutputDepList
	}
	
	do InitDepList
	set prtDate=##class(websys.Translation).Get("", "合计", langId)
	set payAmt=$fn(sum,"",2)
	do OutputDepList

	quit $$$OK
	
InitDepList
	set (prtDate,prtTime,payAmt,paymDR,paymDesc,prtStatus,status,rcptNo,userDR,userName,payAccNo,company,bank,depId,jkDR,jkflag,payedFlag,strikeInvPrtId,bbackflag,bbackdate,bbacktime,bbackuser,refreason,chequeNo,chequeDate,remark,depTypeDR,depTypeCode,depType,initPrtRowId,autoFlag,reRcptNo,leftAmt,lostRegistDR,lostRegUser,lostRegDate,lostRegTime,lostRegReason)=""
	quit
	
OutputDepList
	set Data=$lb(prtDate,prtTime,payAmt,paymDR,paymDesc,prtStatus,status,rcptNo,userDR,userName,payAccNo,company,bank,depId,jkDR,jkflag,payedFlag,strikeInvPrtId,bbackflag,bbackdate,bbacktime,bbackuser,refreason,chequeNo,chequeDate,remark,depTypeDR,depTypeCode,depType,initPrtRowId,autoFlag,reRcptNo,leftAmt,lostRegistDR,lostRegUser,lostRegDate,lostRegTime,lostRegReason)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-07-11
/// Description: 获取安全组配置的默认押金类型描述
/// Input: group:SS_Group.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDeposit).GetDefaultDepTyped()
ClassMethod GetDefaultDepType(group As %String, langId As %String) As %String
{
    set depType=""
    quit:(+group=0) depType
    if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set rowId=0
	while($o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",group,rowId))) {
		set rowId=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",group,rowId))
		set cfgData=$g(^DHCJFSSGRPDEPTYPECONFIG(rowId))
		set isDefault=$p(cfgData,"^",3)
		continue:(isDefault="N")
  		set depTypeDR=$p(cfgData,"^",2)
		continue:(+depTypeDR=0)
		set depType=$p($g(^ARC("ARCDT",depTypeDR)),"^",2)
		set depType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", depType, langId)
		quit
	}
    quit depType
}

/// Creator: ZhYW
/// CreatDate: 2019-06-03
/// Description: 交押金
/// Input: depStr:押金信息串, paymStr:支付方式串, sessionStr:收费员Id^安全组Id^登陆科室Id^院区Id
/// Return: 
/// Debug: w ##class(web.DHCIPBillDeposit).InsertDeposit("1^100.00^3^^","1^^^^^^^100.00^^^^","17275^241^2^2^20")
ClassMethod InsertDeposit(depStr As %String, paymStr As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("InsertDeposit")=$lb(depStr, paymStr, sessionStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	quit:(+userId=0) -1_"^"_"操作员不能为空"

    set depTypeId=$p(depStr,"^",1)
    set payAmt=$p(depStr,"^",2)
    set adm=$p(depStr,"^",3)
    set remark=$p(depStr,"^",4)
    set transfer=$p(depStr,"^",5)        //中途结算转过来的押金
	set strikeInvPrtId=$p(depStr,"^",6)  //住院取消结算对冲押金时对应的负记录指针
	set initDepId=$p(depStr,"^",7)       //部分退时原押金记录RowId
	set isSerial=$p(depStr,"^",8)        //<>1时走票据，=1时生成系统流水号
	set refReasonId=$p(depStr,"^",9)     //+2022-10-09 ZhYW 退款原因，用于部分退费
	
	set papmi=$p(^PAADM(adm),"^",1)
	set curDeptDR=$p(^PAADM(adm),"^",4)
	set curWardDR=$p(^PAADM(adm),"^",70)
    set visitStatus=$p(^PAADM(adm),"^",20)
	quit:(visitStatus="C") -1_"^"_"患者已退院，不能交押金"
	
	set receiptType=..GetReceiptType(hospId)   //+2022-07-19 ZhYW 押金收据号是否自动生成
	if (receiptType=1) {
		set isSerial=1    //不需要分发票据时，按规则自动生成流水号
	}
	set receiptId="", curNo="", endNo="", receiptNo=""
	if (isSerial=1) {
		//不走分配的收据号时，生成流水号
		set rtnValue=..GetBuildBillNo(userId, $s((payAmt>0):"P",1:"R"))   //交押金:P，退押金:R
		set rtn=$p(rtnValue,"^",1)
		quit:(rtn) rtnValue
		set receiptNo=$p(rtnValue,"^",2)
	}else {
		set receiptNoStr=##class(web.UDHCJFBaseCommon).GetRcptNo(userId, hospId)
		set receiptId=$p(receiptNoStr,"^",1)
		quit:(+receiptId=0) -1_"^"_"可用押金票据不足，请先领取"
		set endNo=$p(receiptNoStr,"^",2)
		set curNo=$p(receiptNoStr,"^",3)
	    set title=$p(receiptNoStr,"^",4)
		set receiptNo=title_curNo
	}
    
    if (receiptNo'="") {
	    set rtn=..CheckRcptNoIsRepeat(receiptNo, hospId)    //判断待插入的收据号是否被使用
		quit:(+rtn) rtn
	}
	
	set left=$s((payAmt>0):payAmt,1:0)     //2020-12-01 ZhYW 剩余可退金额

	ts
    
	set clientIPAddress=$system.Process.ClientIPAddress()    //客户端IP
	
	&SQL(
    	INSERT INTO dhc_sfprintdetail (
    		prt_rcptno, prt_adm_dr, prt_payamount, prt_papmi_dr, prt_status,
    		prt_deptype_dr, prt_adduser_dr, prt_jkflag, prt_left, prt_yjrefreason_dr,
    		prt_remark, prt_currward_dr, prt_currdept_dr, prt_paidflag, prt_transfer,
    		prt_refinvprtzy_dr, prt_initdep_dr, prt_hospital_dr, prt_ipaddress
    	)
    	VALUES (
    		:receiptNo, :adm, :payAmt, :papmi, 1,
    		:depTypeId, :userId, 'N', :left, :refReasonId,
    		:remark, :curWardDR, :curDeptDR, 'N', :transfer,
    		:strikeInvPrtId, :initDepId, :hospId, :clientIPAddress
		)
    )
    set rtn=SQLCODE
    if (rtn) tro  quit rtn_"^"_$g(%msg)
    set depRowId=$g(%ROWID)
    
    //+2022-12-20 ZhYW 保存支付方式信息
    set rtnValue=..SavePayMode(depRowId, paymStr, userId)
    set rtn=$p(rtnValue,"^",1)
    if (rtn) tro  quit rtnValue
    
    if (+receiptId'=0) {
		set rtnValue=..Ok(curNo, endNo, userId, receiptId)
	    set rtn=$p(rtnValue,"^",1)
		if (rtn) tro  quit rtnValue
	}
	
	//更新原押金数据(initDepId存在时说明是部分退费)
	if (+initDepId'=0) {
		set initLeftAmt=$p($g(^DHCSFPRINTDETAIL(initDepId)),"^",29)
		set leftAmt=initLeftAmt+payAmt
	 	&SQL(
	 		UPDATE dhc_sfprintdetail
	 		SET prt_left = :leftAmt
	 		WHERE %ID = :initDepId
	 	)
	 	set rtn=SQLCODE
	 	if (rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
    if (transfer="Y") {
	    set invRowID=$o(^DHCINVPRTZY(0,"ADM",adm,""),-1)
	    if (+invRowID'=0) {
		    &SQL(
		    	UPDATE DHC_INVPRTZY
		    	SET PRT_TransferFlag = 'Y'
		    	WHERE %ID = :invRowID
		    )
		    set rtn=SQLCODE
		 	if (rtn) tro  quit rtn_"^"_$g(%msg)
		}
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_depRowId
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-12-20
/// Description: 保存支付方式信息
/// Input: depRowId:dhc_sfprintdetail.RowId, paymStr:支付方式串, userId:SS_User.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDeposit).SavePayMode(1, "P")
ClassMethod SavePayMode(depRowId As %String, paymStr As %String, userId As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set depData=$g(^DHCSFPRINTDETAIL(depRowId))
	set payAmt=$p(depData,"^",6)
	set strikeInvPrtId=$p(depData,"^",40)  //prt_refinvprtzy_dr 住院取消结算对冲押金时对应的负记录指针
	set initDepId=$p(depData,"^",43)    //prt_initdep_dr
	
	set paymSum=0
	for i=1:1:$l(paymStr,$c(2)) {
		set myPayMStr=$p(paymStr,$c(2),i)
		continue:(myPayMStr="")
		set paymId=$p(myPayMStr,"^",1)
		set bankId=$p(myPayMStr,"^",2)
		set chequeNo=$p(myPayMStr,"^",3)
		set bankCardTypeId=$p(myPayMStr,"^",4)
		set unitId=$p(myPayMStr,"^",5)
		set chequeDate=$p(myPayMStr,"^",6)
		set chequeDate=##class(websys.Conversions).DateHtmlToLogical(chequeDate)
		set payAccNo=$p(myPayMStr,"^",7)
		set paymAmt=$p(myPayMStr,"^",8)
		set paymSum=$i(paymSum, paymAmt)
		set ETPRowID=$p(myPayMStr,"^",12)
		if (paymAmt>0) {
			set hardComFlag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(paymId)
			if ((+strikeInvPrtId=0)&&(+hardComFlag'=0)&&(+ETPRowID=0)) {  //2023-03-24 ZhYW 正常交押金控制，取消结算回冲押金记录不控制
				set rtn=-1_"^"_"第三方支付，订单表ID不应为空"
				quit
			}
			/*
			//+2022-07-08 ZhYW 自助机现金交押金时会生成订单
			if ((+hardComFlag=0)&&(+ETPRowID'=0)) {
				set rtn=-1_"^"_"非第三方支付，订单表ID不应有值"
				quit
			}
			*/
		}
		//+2022-10-31 ZhYW 判断第三方支付的住院押金是否允许原路退
		if (initDepId>0) {
			set rtn=..IsAllowedInitModeToRefund(initDepId, paymId)
			quit:(+rtn)
		}
		&SQL(
			INSERT INTO dhc_sfprintdetailpaymode (
				dpm_prt_parref, dpm_paymode_dr, dpm_bank_dr, dpm_amt, dpm_cardchequeno,
				dpm_bankcardtype_dr, dpm_payaccno, dpm_chequedate, dpm_unit_dr, dpm_etp_dr,
				dpm_optuser_dr
			)
			VALUES (
				:depRowId, :paymId, :bankId, :paymAmt, :chequeNo,
				:bankCardTypeId, :payAccNo, :chequeDate, :unitId, :ETPRowID,
				:userId
			)
		)
		set rtn=SQLCODE
		if (rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		
		//第三方支付创建关联
		if (+ETPRowID'=0) {
			set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(ETPRowID, depRowId, "DEP")
			set rtn=$p(rtnValue,"^",1)
			if (rtn) {
				set rtn=rtnValue
				quit
			}
		}
	}
	
	quit:(+paymSum'=+payAmt) -1_"^"_"金额不平"
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-12-28
/// Description: 生成票据流水号
/// Input: userId:SS_User.RowId, preType:收退押金标识(P:收, R:退)
/// Return: 
/// Debug: w ##class(web.DHCIPBillDeposit).GetBuildBillNo(1, "P")
ClassMethod GetBuildBillNo(userId As %String, preType As %String = "") As %String
{
	quit:(userId="") -1_"^"_"参数错误"
	//交押金0, 退押金1
	set myFlag=$s((preType="P"):0,1:1)
	set userCode=$p(^SSU("SSUSR",userId),"^",1)
	
	lock +^BILL.IP.RCPT.PID(userId):0 else  quit -110_"^"_"生成票据流水号的计数器被锁定"
	
	set serialNo=$seq(^BILL.IP.RCPT.PID(userId,+$h))
	set serialNo=##class(BILL.Util.Tools).FormatNO(serialNo, 5)
	set myBillNo=userCode_myFlag_$zd(+$h,8)_serialNo
	
	lock -^BILL.IP.RCPT.PID(userId)
	
	quit 0_"^"_myBillNo
}

/// Description: 全退押金
/// Debug: w ##class(web.DHCIPBillDeposit).RefundDeposit("16183","10207","1","2","240^237^2")
ClassMethod RefundDeposit(initDepId As %String, refModeId As %String, sessionStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("RefundDeposit")=$lb(initDepId, refModeId, sessionStr, expStr)

	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set refReasonId=$p(expStr,"^",1)
	set remark=$p(expStr,"^",2)
	
    set rtn=0
    set newDepId=""
    
	quit:(+userId=0) -1_"^"_"操作员不能为空"
	
	set initDepData=$g(^DHCSFPRINTDETAIL(initDepId))
	set prtStatus=$p(initDepData,"^",8)
	quit:(+prtStatus'=1) -1_"^"_"该收据已退费"
	set payedFlag=$p(initDepData,"^",38)
 	quit:(payedFlag="Y") -1_"^"_"该笔押金已结算，不能退费"
	set strikeInvPrtId=$p(initDepData,"^",40)   //prt_refinvprtzy_dr
	quit:(+strikeInvPrtId'=0) -1_"^"_"该笔押金为取消结算回冲押金，不能退费"
	set lostRegDR=$p($g(initDepData),"^",34)
	quit:(+lostRegDR'=0) -1_"^"_"该笔押金已挂失，不允许退费"
	set initDepDR=$p($g(initDepData),"^",43)
	quit:(+initDepDR'=0) -1_"^"_"该笔押金是退费记录，不允许退费"
	if ($d(^DHCSFPRINTDETAIL(0,"InitDepDR",initDepId))) {
		quit -1_"^"_"该笔押金已退过费，不能再退费"
	}
	
	set userDR=$p(initDepData,"^",14)
	set jkdr=$p(initDepData,"^",30)
	if ((+jkdr=0)&&(userDR=userId)) {
		set refFlag=2
	}else {
		set refFlag=3
	}
	
	set depTypeDR=$p(initDepData,"^",13)

	set receiptType=..GetReceiptType(hospId)   //+2022-07-19 ZhYW 押金收据号是否自动生成
	set isSerial=(receiptType=1)   //不需要分发票据时，按规则自动生成流水号
	
	set receiptId="", curNo="", endNo="", receiptNo=""
    if (refFlag'=2)&&(depTypeDR=..GetIPDepositTypeId()) {
	    if (isSerial=1) {
			//不走分配的收据号时，生成流水号
			set rtnValue=..GetBuildBillNo(userId, "R")
			set rtn=$p(rtnValue,"^",1)
			quit:(rtn) rtnValue
			set receiptNo=$p(rtnValue,"^",2)
		}else {
			set prtRcptFlag=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "StrikeDepRequireRcpt")
			if (prtRcptFlag="Y") {
				set receiptNoStr=##class(web.UDHCJFBaseCommon).GetRcptNo(userId, hospId)
				set receiptId=$p(receiptNoStr,"^",1)
				if (receiptId="") quit -1_"^"_"没有可用的票据，请先领取"
				set endNo=$p(receiptNoStr,"^",2)
				set curNo=$p(receiptNoStr,"^",3)
				set title=$p(receiptNoStr,"^",4)
				set receiptNo=title_curNo
			}
		}
	}
	
	if (receiptNo'="") {
	    set rtn=..CheckRcptNoIsRepeat(receiptNo, hospId)    //判断待插入的收据号是否被使用
		quit:(+rtn) rtn
	}
	
    set adm=$p(initDepData,"^",4)
	set payAmt=-$p(initDepData,"^",6)
	set papmi=$p(initDepData,"^",7)
	set depTypeId=$p(initDepData,"^",13)
	set transfer=$p(initDepData,"^",39)
	set curDeptDR=$p($g(^PAADM(adm)),"^",4)
	set curWardDR=$p($g(^PAADM(adm)),"^",70)
	
	set clientIPAddress=$system.Process.ClientIPAddress()    //客户端IP
	
	ts
	
	&SQL(
    	INSERT INTO dhc_sfprintdetail (
    		prt_rcptno, prt_adm_dr, prt_payamount, prt_papmi_dr, prt_status,
    		prt_deptype_dr, prt_adduser_dr, prt_jkflag, prt_left, prt_yjrefreason_dr,
    		prt_remark, prt_currward_dr, prt_currdept_dr, prt_paidflag, prt_transfer,
    		prt_initdep_dr, prt_hospital_dr, prt_ipaddress
    	)
    	VALUES (
    		:receiptNo, :adm, :payAmt, :papmi, :refFlag,
    		:depTypeId, :userId, 'N', 0, :refReasonId,
    		:remark, :curWardDR, :curDeptDR, 'N', :transfer,
    		:initDepId, :hospId, :clientIPAddress
		)
    )
    set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set newDepId=$g(%ROWID)
	
	set paymStr=""
	set initPMSub=0
	while($o(^DHCSFPRINTDETAIL(initDepId,"P",initPMSub))) {
		set initPMSub=$o(^DHCSFPRINTDETAIL(initDepId,"P",initPMSub))
		set initPMData=$g(^DHCSFPRINTDETAIL(initDepId,"P",initPMSub))
		continue:(initPMData="")
		set initPMDR=$p(initPMData,"^",1)
		set paymId=$s((refModeId'=""):refModeId, 1:initPMDR)
		set bankId=$p(initPMData,"^",2)
		set paymAmt=-$p(initPMData,"^",3)
		set chequeNo=$p(initPMData,"^",4)
		set bankCardTypeId=$p(initPMData,"^",5)
		set payAccNo=$p(initPMData,"^",6)
		set chequeDate=$p(initPMData,"^",7)
		set unitId=$p(initPMData,"^",8)
		set myStr=paymId_"^"_bankId_"^"_chequeNo_"^"_bankCardTypeId_"^"_unitId_"^"_chequeDate_"^"_payAccNo_"^"_paymAmt
		set paymStr=$s((paymStr=""):myStr,1:(paymStr_$c(2)_myStr))
	}
	//+2022-12-20 ZhYW 保存支付方式信息
    set rtnValue=..SavePayMode(newDepId, paymStr, userId)
    set rtn=$p(rtnValue,"^",1)
    if (rtn) tro  quit rtnValue
	
	//更新原押金数据
	set leftAmt=0
    set abortDate="", abortTime=""
    set up2Status=4
    if (refFlag=2) {
    	set up2Status=2
    	set abortDate=+$h
   	 	set abortTime=$p($h,"",2)
 	}
 	&SQL(
		UPDATE dhc_sfprintdetail
		SET prt_status = :up2Status, prt_left = :leftAmt, prt_abortdate = :abortDate, prt_aborttime = :abortTime
		WHERE %ID = :initDepId
	)
	set rtn=SQLCODE
  	if (+rtn) tro  quit rtn_"^"_$g(%msg)
  	    
    if (+receiptId'=0) {   //走收据号时，更新收据表
    	set rtn=..Ok(curNo, endNo, userId, receiptId)
    	if (+rtn) tro  quit rtn
	}
    
 	if ($tl>0) tc
   
    quit rtn_"^"_newDepId

ERROR
	quit ..AppException()
}

ClassMethod Ok(rcptNo As %String, endNo As %String, userId As %String, receiptId As %String) As %String
{
	set rtn=0
 	quit:(receiptId="") -1_"^"_"参数错误"
	
	lock +^DHCSFRECEIPT(receiptId):0  else  quit "-110^收据被锁定（收据Id："_receiptId_")"
	
    if (rcptNo=endNo) {
    	set hospDR=$p(^DHCSFRECEIPT(receiptId),"^",22)
    	&SQL(
    		UPDATE dhc_sfreceipt
    		SET rcpt_currentno = :rcptNo, rcpt_useflag = '2'
    		WHERE %ID = :receiptId)
    	set rtn=SQLCODE
    	if (+rtn)  quit rtn_"^"_$g(%msg)
    	
    	&SQL(
    		SELECT TOP 1 %ID, rcpt_startno INTO :rcptId, :startno
    		FROM dhc_sfreceipt
	     	WHERE rcpt_useflag IS NULL AND rcpt_lquser = :userId AND rcpt_hospital = :hospDR
	     	ORDER BY %ID
		)
	    if (+rcptId>0) {
		    &SQL(
		    	UPDATE dhc_sfreceipt
		    	SET rcpt_currentno = :startno, rcpt_useflag = '1'
		    	WHERE %ID = :rcptId
		    )
		    set rtn=SQLCODE
		    if (+rtn)  quit rtn_"^"_$g(%msg)
		}
	}else {
		set rcptNo=##class(web.UDHCJFBaseCommon).incre(rcptNo)
		&SQL(
			UPDATE dhc_sfreceipt
			SET rcpt_currentno = :rcptNo
			WHERE %ID = :receiptId
		)
		set rtn=SQLCODE
		if (+rtn)  quit rtn_"^"_$g(%msg)
	}
	
	lock -^DHCSFRECEIPT(receiptId)
	
	quit rtn
}

/// Description: 判断患者是否办理财务结算，如果办了财务结算，则不能交押金
/// Debug: w ##class(web.DHCIPBillDeposit).GetBillFlag(1944)
ClassMethod GetBillFlag(adm As %String) As %String
{
	set billFlag=$p(^PAADM(adm),"^",45)
	//如果做了财务结算，但还有未结算的金额不为0的账单则允许交押金
	set pb=""
	while($o(^DHCPB(0,"ADM",adm,pb),-1)) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb),-1)
		set pbData=$g(^DHCPB(pb))
		set totalAmt=$p(pbData,"^",8)
		continue:(+totalAmt=0)
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag="P")
		set billFlag="N"
		quit
	}
	
	quit billFlag
}

/// Description: 获取收据打印所需要的数据
/// Debug: w ##class(web.DHCIPBillDeposit).GetPrintInfo("", 1, "")
ClassMethod GetPrintInfo(JSFunName As %String, depositId As %String, reprtFlag As %String = "") As %String
{
    quit:(+depositId=0) ""
    set depData=$g(^DHCSFPRINTDETAIL(depositId))
    quit:(depData="") ""
    set status=$p(depData,"^",8)
    quit:(status=2) ""
	set rcptNo=$p(depData,"^",1)
	quit:(rcptNo="") ""
	set prtDate=$p(depData,"^",2)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set prtTime=$p(depData,"^",3)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
	set payDateTime=prtDate_" "_prtTime
   	set adm=$p(depData,"^",4)
	set payAmt=$p(depData,"^",6)
	set payAmt=$fn(payAmt,"",2)
	set payAmtUP=##class(web.UDHCJFBaseCommon).RMBDXXZH(payAmt)
	
	set paymSub=$o(^DHCSFPRINTDETAIL(depositId,"P",0))
	set paymSubData=$g(^DHCSFPRINTDETAIL(depositId,"P",+paymSub))
	set paymDR=$p(paymSubData,"^",1)
 	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	set userDR=$p(depData,"^",14)
	set userCode=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",1),1:"")
	set userName=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2),1:"")
	set refReasonDR=$p(depData,"^",31)    //+2018-06-07 ZhYW 退款原因
	set refReason=$s((+refReasonDR'=0):$p($g(^DHCJFYJRREASON(refReasonDR)),"^",2),1:"")
	set rePrint=$s((reprtFlag="Y"):"补打",1:"")
	set remark=$p(depData,"^",33)
	set hospDR=$p(depData,"^",44)
   	set hospital=$s((+hospDR'=0):$p($g(^CT("HOSP",hospDR)),"^",2),1:"")
	
	set curDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	set curTime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
	set curDateTime=curDate_" "_curTime
	
	set patientId=$p(^PAADM(adm),"^",1)
   	//取患者基本信息
   	set patInfo=##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospDR)
   	set patJson=##class(%DynamicObject).%FromJSON(patInfo)
   	
   	//取患者就诊信息
	set admInfo=##class(BILL.COM.PAAdm).GetAdmInfo(adm)
	set admJson=##class(%DynamicObject).%FromJSON(admInfo)

	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("patno",patJson.PatientNo).%Set("patname",patJson.PatName)
	do txtDataParaO.%Set("medicareNo",admJson.MedicareNo).%Set("patward",admJson.Ward)
	do txtDataParaO.%Set("payamt",payAmt).%Set("paymode",paymDesc)
	do txtDataParaO.%Set("amtdx",payAmtUP).%Set("rcptno",rcptNo)
	do txtDataParaO.%Set("payDateTime",payDateTime).%Set("curDateTime",curDateTime)
	do txtDataParaO.%Set("userCode",userCode).%Set("username",userName)
	do txtDataParaO.%Set("hospital",hospital).%Set("rePrintFlag",rePrint)
	if (refReason'="") {
		do txtDataParaO.%Set("refReason","退款原因:"_refReason)
	}
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	set listDataO=##class(%DynamicArray).%New()
	set prtListInfo=""
	set rtnVal=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnVal)#>
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetPrintInfo", "IPDepRcpt", depositId, txtDataParaO, listDataO, $lb(JSFunName, depositId, reprtFlag))

	//add by lml 2015-01-27 增加打印日志
	set myCondition="{depositId:"""_depositId_"""}"
	set myContent="{depositId:"""_depositId_""",rcptno:"""_rcptNo_"""}"
 	set mySecretCode=patJson.SecCode
	set mylog=##class(web.DHCEventLog).EventLog("DHCIPBillDeposit.PrintYJ", myCondition, myContent, mySecretCode)

	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2019-07-11
/// Description: 获取"住院押金"Id
/// Return: ARC_DepType.ARCDT_RowId
/// Debug: w ##class(web.DHCIPBillDeposit).GetIPDepositTypeId()
ClassMethod GetIPDepositTypeId()
{
	quit $o(^ARC("ARCDT",0,"Code","01",0))
}

/// Creator: ZhYW
/// CreatDate: 2020-12-01
/// Description: 住院退押金入口(增加了部分退费功能，通过充负押金实现部分退费功能)
/// Input: initDepId: 原押金RowId, refAmt: 退费金额，refModeId: 退费方式，expStr: 退费原因^备注
/// Return: 
/// Debug: w ##class(web.DHCIPBillDeposit).RefundDepositIF("1903","30.00","4","","12173^241^222^2")
ClassMethod RefundDepositIF(initDepId As %String, refundAmt As %String, refModeId As %String, sessionStr As %String, expStr As %String) As %String
{
	set ^TMP("RefundDepositIF")=$lb(initDepId, refundAmt, refModeId, sessionStr, expStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set refReasonId=$p(expStr,"^",1)   //+2022-10-09 ZhYW 退款原因
	set remark=$p(expStr,"^",2)        //备注
	
	quit:(+initDepId=0) -1_"^"_"原押金记录不能为空"
	
	set initDepData=$g(^DHCSFPRINTDETAIL(initDepId))
	set leftAmt=$p(initDepData,"^",29)
 	quit:(+leftAmt<+refundAmt) -1_"^"_"退费金额不正确"
 	
    set adm=$p(initDepData,"^",4)
	set initAmt=$p(initDepData,"^",6)
	set depTypeDR=$p(initDepData,"^",13)
	
	if (+initAmt=+refundAmt) {
		//相等说明是全退
		set rtnValue=..RefundDeposit(initDepId, refModeId, sessionStr, expStr)
	}else {
		//充负金额
		set transferFlag=""
		set strikeInvPrtId=""        //住院取消结算对冲押金时对应的负记录指针
		set isSerial=0
		
		set paymId=refModeId
		set payAmt=-refundAmt
		set bankId=""
		set chequeNo=""
		set bankCardTypeId=""
		set unitId=""
		set chequeDate=""
		set payAccNo=""

		set depStr=depTypeDR_"^"_payAmt_"^"_adm_"^"_remark_"^"_transferFlag_"^"_strikeInvPrtId_"^"_initDepId_"^"_isSerial_"^"_refReasonId
				
		set paymStr=paymId_"^"_bankId_"^"_chequeNo_"^"_bankCardTypeId_"^"_unitId_"^"_chequeDate_"^"_payAccNo_"^"_payAmt
		
		set rtnValue=..InsertDeposit(depStr, paymStr, sessionStr)
	}
	quit rtnValue
}

/// Creator: ZhYW
/// CreatDate: 2022-03-15
/// Description: 判断待插入的收据号是否被使用
/// Input: receiptNo:发票号, hospId:CT_Hospital.RowId
/// Return: =0:否, <>0:是
/// Debug: w ##class(web.DHCIPBillDeposit).CheckRcptNoIsRepeat("000001","2")
ClassMethod CheckRcptNoIsRepeat(receiptNo As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(receiptNo="") rtn
	
	set depRowId=0
	while($o(^DHCSFPRINTDETAIL(0,"RcptNo",receiptNo,depRowId))) {
		set depRowId=$o(^DHCSFPRINTDETAIL(0,"RcptNo",receiptNo,depRowId))
		set depData=$g(^DHCSFPRINTDETAIL(depRowId))
		set hospDR=$p(depData,"^",44)
		continue:(hospDR'=hospId)
		set rtn=-1_"^"_"收据号"_receiptNo_"已被使用"
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-07-19
/// Description: 押金收据号是否自动生成
/// Input: hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCIPBillDeposit).GetReceiptType(2)
ClassMethod GetReceiptType(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.PyDep.YJSJHSFZDSC", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: LUAN ZhenHui
/// CreatDate: 2022-09-05
/// Description: 住院押金是否允许部分退
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCIPBillDeposit).IsAllowedPartRefund(2)
ClassMethod IsAllowedPartRefund(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.RefdDep.YJSFYXBFT", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2022-10-31
/// Description: 判断第三方支付的住院押金是否允许原路退
/// Input: depRowId:dhc_sfprintdetail.RowId(待退押金RowId), refModeId:CT_PayMode.RowId(退押金支付方式Id)
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillDeposit).IsAllowedInitModeToRefund(936, 47)
ClassMethod IsAllowedInitModeToRefund(depRowId As %String, refModeId As %String, langId As %String = "") As %String
{
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rtn=0
	quit:(+depRowId=0) -1_"^"_"参数错误"
	
	set hardComFlag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(refModeId)
	quit:(+hardComFlag=0) rtn    //非第三方支付退款
	
	set hospId=$p($g(^DHCSFPRINTDETAIL(depRowId)),"^",44)   //prt_hospital_dr
	set depPMSub=$o(^DHCSFPRINTDETAIL(depRowId,"P",0))
	set depPMData=$g(^DHCSFPRINTDETAIL(depRowId,"P",depPMSub))
	set paymId=$p(depPMData,"^",1)
	set orgETPRowId=##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrtMode("DEP", depRowId, paymId)
	if ((+orgETPRowId=0)||(paymId'=refModeId)) {
		set paymDesc=$p($g(^CT("CTPM",paymId)),"^",2)
		set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
		set refmDesc=$s((+refModeId'=0):$p($g(^CT("CTPM",refModeId)),"^",2),1:"")
		set refmDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", refmDesc, langId)
		quit -1_"^"_"原记录为"_paymDesc_"支付，不能选择"_refmDesc_"退费"     //非第三方支付
	}

	set myETPData=$g(^DHCBILLETP(orgETPRowId))
	set myExtDate=$p(myETPData,"^",14)          //ETP_Ext_Date
	set timeoutDays=##class(BILL.Payment.COM.Method).GetRefTimeoutDays(paymId, hospId)  //退款超时天数
	set isTimeout=((+timeoutDays'=0)&&($system.SQL.DATEDIFF("dd", myExtDate, +$h)>timeoutDays))
	quit:(isTimeout=1) -1_"^"_"已经超过可退时限，只能选择现金退费"
	
	quit rtn
}

}
