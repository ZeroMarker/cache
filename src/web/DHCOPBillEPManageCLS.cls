Import SQLUser

Class web.DHCOPBillEPManageCLS Extends BILL.COM.Abstract
{

/// str=adm_"^"_patientId_"^"_cardNo_"^"_userId_"^"_credType_"^"_credNo
/// Debug: w ##class(web.DHCOPBillEPManageCLS).AddNewAccount()
ClassMethod AddNewAccount(str As %String) As %String
{
	set $zt="ERROR"
	
 	set adm=$p(str,"^",1)
	set patientId=$p(str,"^",2)
	set cardNo=$p(str,"^",3)
	set userId=$p(str,"^",4)
	set credTypeId=$p(str,"^",5)
	set credNo=$p(str,"^",6)
 	set patientNo=$p($g(^PAPER(patientId,"PAT",1)),"^",1)
 	
 	set accountNo=..getAccountNo(adm)
 	quit:($d(^DHCEPMi("EPM",0,"AccountNO",accountNo))) -1_"^"_"账户号重复"
 	
 	set rtn=..CheckAccByAdm(adm)
 	quit:(+rtn) rtn
 	
 	&SQL(
 		INSERT INTO DHC_EPManager (
	 		EPM_AccountNo, EPM_Adm_DR, EPM_PAPMI_DR, EPM_PAPMINo, EPM_CardNo,
	 		EPM_OCDate, EPM_OCTime, EPM_CUser_DR, EPM_Balance, EPM_Status,
	 		EPM_CredType_DR, EPM_CredNo
 		)
 		VALUES (
 			:accountNo, :adm, :patientId, :patientNo, :cardNo,
 			CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :userId, 0, 'N',
 			:credTypeId, :credNo
 		)
 	)
 	set rtn=SQLCODE
 	quit:(+rtn) rtn_"^"_$g(%msg)
 	
	set accMRowId=$g(%ROWID)
	
	quit rtn_"^"_accMRowId_"^"_accountNo_"^N"

ERROR
	quit ..AppException()
}

/// 获得有效的卡标志和DHC_CardRef表的RowID
ClassMethod getActiveCard(cardno As %String, securityno As %String) As %String
{
	q:(cardno="") "-200^^^^"		;无效卡标志
	
	s myACFlag=-200		;无效卡
	
	s myACRowID=""
	
	d ##class(web.UDHCCardInfoResume).AutoRepairSec(cardno,securityno)
	
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s cardid=0, Papmi=""
 	f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:((cardid="")||(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:(ActiveFlag'="N")
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.q:(SecurityNO'=mySecNoEncrypt)	 //securityno
	.s myACRowID=cardid
	.s myACFlag=0
 	
 	s rtn=myACFlag
 	
 	q rtn_"^"_myACRowID
}

/// w ##class(web.DHCOPBillEPManageCLS).getpapmifromcardno("4848945","00000001123456789123456789")
ClassMethod getpapmifromcardno(cardno As %String, securityno As %String) As %String
{
	q:(cardno="") "-200^^^^"	//无效卡标志
	
	s myACFlag=-200		;无效卡
	
	d ##class(web.UDHCCardInfoResume).AutoRepairSec(cardno, securityno)
	
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s cardid=0, Papmi=""
 	f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:((cardid="")||(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:(ActiveFlag'="N")
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.q:(SecurityNO'=mySecNoEncrypt)			//securityno
	.s myACFlag=0
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
 	
 	s rtn=myACFlag
 	
 	q rtn_"^"_Papmi
}

/// Creator: hujunbin
/// CreatDate: 2015-07-02
/// Description: 保持与账户dhc_accmanager读卡函数一致
/// Input: cardno,securityno,CardTypeDR,AdmStr,CheckSecurityFlag,ExpStr
/// Debug: w ##class(web.DHCOPBillEPManageCLS).getaccinfofromcardno("","","")
ClassMethod getaccinfofromcardno(cardno As %String, securityno As %String, CardTypeDR As %String, AdmStr As %String, CheckSecurityFlag As %String, ExpStr As %String) As %String
{
	;AdmStr  患者的就诊 Adm号码
	;此处要区别对待一个索引问题
	;1. 按照卡号索引为主 检索患者信息和患者帐户信息
	;2. 以卡类型索引为主 检索患者的信息和账户信息
	
	;CheckSecurityFlag    验证校验码标志
	;=  "PatInfo"		只获取患者信息不获取账户信息
	;=  "ALL"			表示要求有验证
	;=  ""	
	s ^TMP("getaccinfofromcardno")=$lb(cardno, securityno, CardTypeDR, AdmStr, CheckSecurityFlag, ExpStr)
	
	q:((cardno="")) "-200^^^^^^^^"		//无效卡标志
	
	s rtn=0
	
	k ^||TMP($j)
	
	s AccID="",AccNo="",left=0,Balance=0,DepPrice=0
	s Papmi=""
	s Pass=""
	s PAPMINo=""
	s myCardRowID=""
	s myRtnCardTypeDR = ""
	s myACFlag=-200		;无效卡
	s mySelectCardTypeTip=""		;选择卡类型提示
	
	s myAccType="P"
	
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	
	i (CardTypeDR="") d
	.s mySCMode="PC"
	e  d
	.s mySCMode=$p(^DHCCARDTYPEDef(CardTypeDR),"^",28)		;SearchCardNoMode
	
	i (mySCMode="PC") d
	.;优先 卡号
	.;在不指定卡类型的情况下的优先级别
	.;如果数据有多条， 需要验证卡类型的RowID
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,mycardid)) q:(mycardid="")  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..q:ActiveFlag'="N"
	..s SecurityNO=$p(^DHCCARD("CF",mycardid),"^",3)
	..i SecurityNO=$c(0) s SecurityNO=""
	..q:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))		//securityno
	..s ^||TMP($j)=+$g(^||TMP($j))+1
	..s ^||TMP($j,"CardRowID",mycardid)=""
	e  d
	.;默认方式
	.;指定卡号和卡类型
	.;此时要求必须唯一才成， 
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDR,cardno,mycardid)) q:(mycardid="")  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..q:ActiveFlag'="N"
	..s SecurityNO=$p(^DHCCARD("CF",mycardid),"^",3)
	..i SecurityNO=$c(0) s SecurityNO=""
	..q:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))	  //securityno
	..s ^||TMP($j)=$i(^||TMP($j))
	..s ^||TMP($j,"CardRowID",mycardid)=""
	
	//以下都是有效卡记录
	s cardid=0
	f  s cardid=$o(^||TMP($j,"CardRowID",cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.i SecurityNO=$c(0) s SecurityNO=""
	.q:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	.s myRtnCardTypeDR=$p(^DHCCARD("CF",cardid),"^", 16)		;CF_CardType_DR
	.q:(mySCMode'="PC")&&(+$g(^||TMP($j))>1)	;如果卡类型与卡号同时比较 而出现两张卡,一定无效
	.;如果 卡号优先 同时只检索一个卡号 , 这个卡号一定有效
	.;如果 卡号优先 但是检索多个卡号  ,需要对比当前的卡类型,如果不一致就退出, 
	.q:((mySCMode="PC")&&(+$g(^||TMP($j))>1)&&(myRtnCardTypeDR'=CardTypeDR))
	.;判断有效卡标志
	.s myACFlag=0		;此卡有效
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s myCardRowID=cardid
	.s PAPMINo=##class(web.PAPatMas).GetRegistration(Papmi)
	.;前面是患者基本信息
	.q:(CheckSecurityFlag="PatInfo")			;如果强调 只获取患者信息， 而不要账户信息
	.;后面是账户信息
	.s (AccNo,Balance,DepPrice,Pass,left,myAccType)=""
	.s EpmId="",AccID=""
	.f  s EpmId=$o(^DHCEPMi("EPM",0,"EPMPapmi",Papmi,EpmId),-1) q:(EpmId="")||(+AccID'=0)  d
	..s AccStatus=$p(^DHCEPM("EPM",EpmId),"^",13)
	..q:(AccStatus'="N")
	..s AccID=EpmId
	.i (AccID'="") d
	..s AccNo=$p(^DHCEPM("EPM",AccID),"^",1)
	..s Balance=$p(^DHCEPM("EPM",AccID),"^",9)
	..s DepPrice=0 ;急诊留观账户没有透支金额字段
	..s Pass=""
	..s left=Balance-DepPrice
	..s myAccType=""
	
	s rtn=myACFlag
	
	//卡有效，而账户无效返回-201
	i ((myACFlag=0)&&(AccID="")) s rtn=-201
	
	i ((mySCMode="PC")&&(+$g(^||TMP($j))>1)&&(+rtn)) d
	.s mySelectCardTypeTip="请选择卡类型!"
	.s myRtnCardTypeDR=""
	
	//如果 卡号优先 但是检索多个卡号, 需要对比当前的卡类型,如果不一致就退出
	//在界面上提示患者选择 卡类型
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	s str=str_"^"_mySCMode_"^"_myRtnCardTypeDR_"^"_mySelectCardTypeTip
	
	k ^||TMP($j)
	
	q str
}

/// 可以通过PAPMINo来查
/// 或利用卡来查；
ClassMethod ReadPatAccInfo(PAPMINO As %String, CardNo As %String, SecurityNo As %String) As %String
{
	q:((PAPMINO="")&&(CardNo="")) "-299^^^^^^"
	
	s rtn=0
	
	;可以利用登记号来查询卡号与验证码
	i (CardNo="")&&(SecurityNo="") d
	.;利用登记号来查询有效的账户号码，这个只为了结帐使用；
	.;为了操作简单化
	.
	
	s (myPAPMINO, myPatName, mySexDesc, myPatBD)=""
	s (myCredDesc, myCredNo, myLeft)=""
	s (myASDesc,myAccNo, myCDT, BadPrice, DepPrice)=""
	s myCardRowID=""
	s myAccRowID=""
	s myPDSum=""
	s myPLSum=""
	s myPatType=""
	s myRegFlag="N"
	s rtn=0
	if (CardNo'="")&&(SecurityNo'="") d
	.s myrtn=..getaccinfofromcardno(CardNo, SecurityNo)
	.s rtn=$p(myrtn,"^",1)
	.q:rtn
	.s myPAPMINO=$p(myrtn,"^",9)
	.s myPAPMIDR=$p(myrtn,"^",8)
	.s myPatType=$p(^PAPER(myPAPMIDR,"PER", 1),"^",10)
	.s myPatName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
	.s mySexDR=$p(^PAPER(myPAPMIDR,"ALL"),"^",7)
	.s:(mySexDR'="") mySexDesc=$p(^CT("SEX",mySexDR),"^",2)
	.s myPatBD=$p(^PAPER(myPAPMIDR,"ALL"),"^",6)
	.s myPatBD=##class(websys.Conversions).DateLogicalToHtml(myPatBD)
	.s myAccRowID=$p(myrtn,"^",2)
	.s myCardRowID=$p(myrtn,"^",10)
	.s myCredDR=$p(^DHCEPM("EPM",myAccRowID),"^",17)	;EPM_CredType_DR
	.s:(myCredDR'="") myCredDesc=$p($g(^DHCACCCredType(myCredDR)),"^",2)
	.s myCredNo=$p(^DHCEPM("EPM",myAccRowID),"^",18)	;EPM_CredNo
	.s myLeft=$p(myrtn,"^",4)
	.s myAccStatus=$p(^DHCEPM("EPM",myAccRowID),"^",13)	;EPM_CredNo
	.i myAccStatus="N" s myASDesc="正常"
	.s:(myAccStatus'="N") rtn=-201
	.q:(myAccStatus'="N")
	.s myAccNo=$p(^DHCEPM("EPM",myAccRowID),"^",1)	;EPM_AccountNo
	.s myCDate=$p(^DHCEPM("EPM",myAccRowID),"^",5)	;Date
	.s myCTime=$p(^DHCEPM("EPM",myAccRowID),"^",6)	;Date
	.s myCDT=##class(websys.Conversions).DateLogicalToHtml(myCDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(myCTime,1)
	.s myLeft=$p(^DHCEPM("EPM",myAccRowID),"^",8)
	.s DepPrice=$p(^DHCEPM("EPM",myAccRowID),"^",14)
	.s BadPrice=$p(^DHCEPM("EPM",myAccRowID),"^",15)
	.s myPDSum=##class(web.UDHCAccAddDeposit).ReadPreDepositSum(myAccRowID)
	.s myPLSum=##class(web.UDHCACPayList).ReadPatAccPaySum(myAccRowID)
	.s myRegFlag=..getAccRegFlag(myAccRowID)
	
	s myLeft=$fn(+myLeft,"",2)
	s BadPrice=$fn(+BadPrice,"",2)
	s DepPrice=$fn(+DepPrice,"",2)
	s myPDSum=$fn(+myPDSum,"",2)
	s myPLSum=$fn(+myPLSum, "",2)
	s myPAInfo=myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	s myPAInfo=myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	s myPAInfo=myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	s myPAInfo=myPAInfo_"^"_myAccRowID
	s myPAInfo=myPAInfo_"^"_myPDSum_"^"_myPLSum_"^"_myPatType
	s myPAInfo=myPAInfo_"^"_myCardRowID_"^"_myRegFlag
	
	q rtn_"^"_myPAInfo
}

ClassMethod getAccRegFlag(AccRowID As %String) As %String
{
	s myrtn="N"
	q:$g(AccRowID)="" myrtn
	s myrtn="Y"
	s myRegSum=0
	s mysub=0
	f  s mysub=$o(^DHCEPM("EPM",AccRowID,"EPPL",mysub)) q:(mysub="")||(myrtn="N")  d
	.s myINVID=$p(^DHCEPM("EPM",AccRowID,"EPPL",mysub),"^",2)
	.q:(myINVID="")
	.s myFairType=$p($g(^DHCINVPRT(myINVID)),"^",34)
	.s myamt=+$p(^DHCEPM("EPM",AccRowID,"EPPL",mysub),"^",9)
	.i (myFairType="R") s myRegSum=myRegSum+myamt
	.q:(myFairType="R")
	.s myrtn="N"
	i (myrtn="Y")&&(myRegSum=0) s myrtn="N"
	q myrtn
}

ClassMethod getAccBalance(Accid As %String) As %String
{
	q:(Accid="") ""
	q:'$d(^DHCEPM("EPM",Accid)) ""
	s Balance=$p(^DHCEPM("EPM",Accid),"^",9)
	q $fn(Balance,"",2)
}

/// Debug: w ##class(web.DHCOPBillEPManageCLS).GetPatInfo("156","2")
ClassMethod GetPatInfo(patientNo As %String, hospId As %String = "") As %String
{
	set ^TMP("GetPatInfo")=$lb(patientNo, hospId)
	
	if (hospId="")&&($d(%session)) {
		set hospId=%session.Get("LOGON.HOSPID")
	}
	
	set obj={}
	if (patientNo="") {
		quit obj.%ToJSON()
	}
	set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
	set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
	if (patientId="") {
		quit obj.%ToJSON()
	}
	quit ##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospId)
}

ClassMethod getAccountNo(AccountNo As %String) As %String
{
	set tmpNo=""
	
	set len=8
	set PATCFid=$o(^CF("PATCF",""))
	if (PATCFid'="") set len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	
	//判断节点是否存在
	if $d(^DHCEPMi("EPM",0,"AccountNo")) {
		if '$d(^DHCEPMi("EPM",0,"AccountNO",AccountNo_"0001")) {
			set AccountNo=AccountNo_"0001"
		} else {
			set tmpNo=AccountNo_"0000",AccountNo1=AccountNo
			for  set tmpNo=$o(^DHCEPMi("EPM",0,"AccountNO",tmpNo)) quit:(tmpNo="")||(AccountNo1'=$e(tmpNo,1,len))  do
			.set AccountNo=tmpNo
			set tmpNo=$e(AccountNo,len+1,len+4)+1
			set tmpNo=$e("0000",1,4-$l(tmpNo))_tmpNo
			set AccountNo=$e(AccountNo,1,len)_tmpNo
		}
	} else {
		set AccountNo=AccountNo_"0001"
	}
	
	quit AccountNo
}

/// Debug: w ##class(web.DHCOPBillEPManageCLS).CheckAccByAdm()
ClassMethod CheckAccByAdm(adm As %String) As %String
{
	quit:(adm="") -301
	set rtn=0
	set cfrowid=0
	while($o(^DHCEPMi("EPM",0,"EPAdm",adm,cfrowid))) {
		set cfrowid=$o(^DHCEPMi("EPM",0,"EPAdm",adm,cfrowid))
		set data=$g(^DHCEPM("EPM",cfrowid))
		set activeFlag=$p(data,"^",13)
 		continue:(" N S "'[(" "_activeFlag_" "))
 		set rtn=-306
 		quit
	}
	quit rtn
}

/// Debug: w ##class(web.DHCOPBillEPManageCLS).AccountWriteoff()
ClassMethod AccountWriteoff(AccountID As %String, user As %String, IP As %String) As %String
{
	set oldstatus=$p($g(^DHCEPM("EPM",AccountID)),"^",13)
	
	&SQL(UPDATE DHC_EPManager
		SET EPM_OCDate = CONVERT(DATE, NOW()), EPM_OCTime = CONVERT(TIME, NOW()), EPM_DUser_DR = :user, EPM_Status = 'F'
		WHERE %ID = :AccountID
	)
	set rtn=SQLCODE
 	quit:(+rtn) rtn_"^"_$g(%msg)
	set rtn=..AccountStatusRecord(AccountID, oldstatus, "F", user, IP, "")
 	quit rtn
}

/// Debug: w ##class(web.DHCOPBillEPManageCLS).AccountStatusChange()
ClassMethod AccountStatusChange(accid As %String, oldstatus As %String, newstatus As %String, userid As %String, IP As %String, RLinfo As %String) As %String
{
	&SQL(UPDATE DHC_EPManager
		SET EPM_Status = :newstatus
		WHERE %ID = :accid
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
 	set rtn=..AccountStatusRecord(accid, oldstatus, newstatus, userid, IP, RLinfo)
 	quit rtn
}

/// 还没建状态改变表DHC_EPStatusChange
ClassMethod AccountStatusRecord(accid As %String, oldstatus As %String, newstatus As %String, userid As %String, IP As %String, RLinfo As %String) As %String
{
	k PLIST
	s PLIST(0)=accid
	s PLIST(3)=oldstatus
	s PLIST(4)=newstatus
	s PLIST(6)=+$h
	s PLIST(7)=$p($h,",",2)
	s PLIST(8)=userid
	s PLIST(9)=IP
	i (RLinfo'="") d
	.s PLIST(14)=$p(RLinfo,"^",1)
	.s PLIST(15)=$p(RLinfo,"^",2)
	.s PLIST(16)=$p(RLinfo,"^",3)
	.s PLIST(17)=$p(RLinfo,"^",4)
	.s PLIST(18)=$p(RLinfo,"^",5)
	.s PLIST(19)=$p(RLinfo,"^",6)
	.s PLIST(20)=$p(RLinfo,"^",7)
	s ren=##class(web.UDHCEPStatusChange).INSERT()
	q ren
}

Query ReadAccMList(AccNo As %String, PAPMINo As %String, BUserCode As %String, CardNo As %String, AccStatus As %String, AccType As %String, StDate As %String, EndDate As %String, BUserCodeA As %String, PatNameA As %String, TMPGID As %String) As websys.Query(ROWSPEC = "TAdmRowID,TStayState,TAdmLocDesc,TAdmWardDesc,TAdmBedDesc,TAdmDate,TAdmTime,TDisDate,TDisTime,TAdmInsType")
{
}

ClassMethod ReadAccMListExecute(ByRef qHandle As %Binary, AccNo As %String, PAPMINo As %String, BUserCode As %String, CardNo As %String, AccStatus As %String, AccType As %String, StDate As %String, EndDate As %String, BUserCodeA As %String, PatNameA As %String, TMPGID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1	
	;条件：登记号，用户代码，卡号，帐户状态，帐户类型， 开户 开始，截止日期
	;
	;根据条件查询记录集
	;医院的账户信息
	;PatNameA

	i (TMPGID'="") d
	.k ^TMPOPPrintOut(TMPGID)
	
	s myTMPGID=$i(^TMPOPPrintOut)
	
	i (StDate="") set StDate=+$h
	i (EndDate="") Set EndDate=+$h
		
	s (myPreTSum, myRefPreTSum, myAccPayTSum, myAccLeftTSum)=""
	
	i PAPMINo'="" d
	.s mylen=$l(PAPMINo)
	.s myPANo=$e("0000000000",1,8-mylen)_PAPMINo
	.s PAPMINo=myPANo
	
	d ValidateData
	
	f myDate=StDate:1:EndDate  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCEPMi("EPM",0,"CreateDate",myDate,myAccRowID))  q:(myAccRowID="")  d
	..q:($d(^DHCEPM("EPM",myAccRowID))=10)
	..s myAccountNo=$p($g(^DHCEPM("EPM",myAccRowID)),"^",1)				;EPM_AccountNo
	..q:((AccNo'="")&&(myAccountNo'=AccNo))
	..s myPAPMIDR=$p($g(^DHCEPM("EPM",myAccRowID)),"^",3)				;EPM_PAPMI_DR
	..s myPatName=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 1)
	..q:(PatNameA'="")&&(PatNameA'=myPatName)
	..s myDOB=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 6)
	..s mySexDR=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 7)
	..s mySexN=$p($g(^CT("SEX",mySexDR)),"^",2)
	..s myPAPMINo=$p($g(^DHCEPM("EPM",myAccRowID)),"^",3)				;EPM_PAPMINo
	..q:((PAPMINo'="")&&(PAPMINo'=myPAPMINo))
	..s myCardNo=$p($g(^DHCEPM("EPM",myAccRowID)),"^",5)				;EPM_CardNo
	..q:((CardNo'="")&&(CardNo'=myCardNo))
	..s myOCDate=$p($g(^DHCEPM("EPM",myAccRowID)),"^",6)				;EPM_OCDate
	..s myOCTime=$p($g(^DHCEPM("EPM",myAccRowID)),"^",7)	;EPM_OCTime
	..s myCDate=##class(websys.Conversions).DateLogicalToHtml(myOCDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(myOCTime,1)
	..s myCUseDR=$p($g(^DHCEPM("EPM",myAccRowID)),"^",8)	;EPM_CUser_DR
	..s myCUCode=$p($g(^SSU("SSUSR",myCUseDR)),"^",1)
	..q:((BUserCode'="")&&(BUserCode'=myCUCode))
	..q:((BUserCodeA'="")&&(BUserCodeA'=myCUCode))
	..s myCUseName=$p($g(^SSU("SSUSR",myCUseDR)),"^",2)
	..s myAccLeftSum=$p($g(^DHCEPM("EPM",myAccRowID)),"^",9)	;EPM_Balance
	..s myAccLeftSum=$fn(myAccLeftSum,"",2)
	..s myWFDate=$p($g(^DHCEPM("EPM",myAccRowID)),"^",10)	;EPM_WoffDate
	..s myWFTime=$p($g(^DHCEPM("EPM",myAccRowID)),"^",11)	;EPM_WoffTime
	..s myWODate=""
	..i (myWFDate'="")&&(myWFTime) d
	...s myWODate=##class(websys.Conversions).DateLogicalToHtml(myWFDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(myWFTime,1)
	..s myDUseDR=$p($g(^DHCEPM("EPM",myAccRowID)),"^",12)	;EPM_DUser_DR
	..s myWOUserName=$s((+myDUseDR'=0):$p($g(^SSU("SSUSR",myDUseDR)),"^",2),1:"")
	..s myAccStatus=$p($g(^DHCEPM("EPM",myAccRowID)),"^",13)	;EPM_AccStatus
	..q:((AccStatus'="")&&(AccStatus'=myAccStatus))
	..s myAccStatusName=$case(myAccStatus,"N":"正常","S":"挂起","F":"结算",:"")
	..s myCredTDR=$p($g(^DHCEPM("EPM",myAccRowID)),"^",15)	  ;EPM_CredType_DR 证件类型
	..s myCredName=$s((+myCredTDR'=0):$p($g(^DHCACCCredType(myCredTDR)),"^",2),1:"")
	..;不显示证件号码AccStatus
	..;预交金
	..s mySub=0
	..s myPreSum=0
	..s myRefPreSum=0
	..f  s mySub=$o(^DHCEPM("EPM",myAccRowID,"EPMD",mySub)) q:(mySub="")  d
	...s myTmpSum=$p($g(^DHCEPM("EPM",myAccRowID,"EPMD",mySub)),"^",2)
	...i (+myTmpSum>0) d
	....s myPreSum=+myPreSum+myTmpSum
	...e  d
	....s myRefPreSum=+myRefPreSum+myTmpSum
	..s myPreSum=$fn(myPreSum,"",2)
	..s myRefPreSum=$fn(myRefPreSum,"",2)
	..;卡支付
	..s mySub=0
	..s myPayNum=0
	..f  s mySub=$o(^DHCEPM("EPM",myAccRowID,"EPPL",mySub)) q:(mySub="")  d
	...s myPayNum=+myPayNum+$p($g(^DHCEPM("EPM",myAccRowID,"EPPL",mySub)),"^",9)
	..s myAccPaySum=$fn(myPayNum,"",2)
	..;取出卡号
	..s myCardNo=""
	..s myCFRowID=0
	..f  s myCFRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccRowID,myCFRowID))  q:(myCFRowID="")  d
	...s myCardFlag=$p(^DHCCARD("CF",myCFRowID),"^",10)
	...q:(myCardFlag'="N")
	...s myCardNo=$p(^DHCCARD("CF",myCFRowID),"^",2)
	..s myPreTSum=+myPreTSum+myPreSum
	..s myRefPreTSum=+myRefPreTSum+myRefPreSum
	..s myAccPayTSum=+myAccPayTSum+myAccPaySum
	..s myAccLeftTSum=+myAccLeftTSum+myAccLeftSum
	..d OutputRow
	
	//合计
	d ValidateData
	s myPatName="合计"
	s myPreSum=$fn(+myPreTSum,"",2)
	s myRefPreSum=$fn(+myRefPreTSum,"",2)
	s myAccPaySum=$fn(+myAccPayTSum,"",2)
	s myAccLeftSum=$fn(+myAccLeftTSum,"",2)
	i ((+myPreSum'=0)||(+myRefPreSum'=0)||(+myAccPaySum'=0)||(+myAccLeftSum'=0)) d
	.do OutputRow
	
	quit $$$OK
OutputRow
	set Data=$lb(ind,myAccountNo,myPatName,mySexN,myPreSum,myRefPreSum,myAccPaySum,myAccLeftSum,myAccStatusName,myCDate,myWOUserName,myWODate,myPAPMINo,myCredName,myCUseName,myTMPGID,myCardNo,myAccRowID)
	set ^CacheTemp(repid,ind)=Data
	set myTMPData=##class(web.DHCOPConfig).TransLBToStr(Data)
	set ^TMPOPPrintOut(myTMPGID,ind)=myTMPData
	set ind=ind+1
	quit
ValidateData
	set (myAccountNo,myPatName,mySexN,myPreSum,myRefPreSum,myAccPaySum,myAccLeftSum,myAccStatusName,myCDate,myWOUserName,myWODate,myPAPMINo,myCredName)=""
	set myCardNo=""
	quit
}

ClassMethod UpAccFoot(AccRowID As %String, UserDR As %String, BadPrice As %String) As %String
{
	set $zt="ERROR"
	
	set AccMLeft=$p($g(^DHCEPM("EPM",AccRowID)),"^",9)
	quit:(+AccMLeft'=0) -207
	
	&SQL(
		UPDATE DHC_EPManager
		SET EPM_WoffDate = CONVERT(DATE, NOW()), EPM_WoffTime = CONVERT(TIME, NOW()), EPM_DUser_DR = :UserDR, EPM_Status = 'F', EPM_BadPrice = :BadPrice
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
 	quit:(+rtn) rtn_"^"_$g(%msg)
 	quit rtn
 
ERROR
	quit ..AppException()
}

/// Debug: w ##class(web.DHCOPBillEPManageCLS).CheckAccByAdm()
ClassMethod AccCallBack(AccRowID As %String, UserDR As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set AccMLeft=$p($g(^DHCEPM("EPM",AccRowID)),"^",9)
	quit:(+AccMLeft'=0) -207
	
	&SQL(UPDATE DHC_EPManager
		SET EPM_WoffDate = NULL, EPM_WoffTime = NULL, EPM_DUser_DR = NULL, EPM_Status = 'N'
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
 	quit:(+rtn) rtn_"^"_$g(%msg)
 	quit rtn
 	
ERROR
	quit ..AppException()
}

/// Creator: hujunbin  
/// CreatDate: 2015.01.07
/// Description: 根据就诊获取当前急诊留观账户ID
/// Debug: w ##class(web.DHCOPBillEPManageCLS).getCurrAcountID()
ClassMethod getCurrAcountID(adm As %String) As %String
{
	quit:(+adm=0) -1_"^^"
	
	set accId=""
	set epmId=0
	while($o(^DHCEPMi("EPM",0,"EPAdm",adm,epmId))) {
		set epmId=$o(^DHCEPMi("EPM",0,"EPAdm",adm,epmId))
		set status=$p(^DHCEPM("EPM",epmId),"^",13)
		continue:(" N S "'[(" "_status_" "))
		set accId=epmId
		quit
	}
	quit:(+accId=0) -2_"^^"
	
	set balance=$p(^DHCEPM("EPM",accId),"^",9)
	set balance=$fn(balance,"",2)
	
	quit 0_"^"_accId_"^"_balance
}

/// Creator: Lid
/// CreatDate: 2015-01-13
/// Description: 验证留观账户的押金余额
/// Debug: w ##class(web.DHCOPBillEPManageCLS).CheckEPMLeft(2, 270, 1)
ClassMethod CheckEPMLeft(accMRowId As %String, paySum As %String, insType As %String = "")
{
	set PNum=$fn(paySum,"",2)
	set AccMLeft=$p(^DHCEPM("EPM",accMRowId),"^",9)
	set DepNum=0	         //可透支额，先设为0
	set CNum=AccMLeft-DepNum	 //减去下限
	set CNum=$fn(CNum,"",2)
	
	set AdmSource=$s((+insType'=0):$p($g(^PAC("ADMREA",insType)),"^",9),1:"")
	quit:((+PNum<0)&&(+$zabs(PNum)>+CNum)&&(+AdmSource=0)) 125_"^"_"留观账户余额不足"
	//quit:((+PNum<0)&&(+$zabs(PNum)>+CNum)) 125_"^"_"留观账户余额不足"
	
	quit 0
}

/// Creator: Lid
/// CreatDate: 2015-01-13
/// Description: 留观押金支付
/// Debug: w ##class(web.DHCOPBillEPManageCLS).INSPayInfo("","")
ClassMethod INSPayInfo(accMRowId As %String, payInfo As %String) As %String
{
	set $zt="ERROR"
	set myParRef=$p(payInfo,"^",1)
	set PAPMIDR=$p(payInfo,"^",2)
	set InvPrtDR=$p(payInfo,"^",3)
	set PAPMI=$p(payInfo,"^",4)
	set BillNo=$p(payInfo,"^",5)
	set UserDR=$p(payInfo,"^",6)
	set PayDate=$p(payInfo,"^",7)
	set PayTime=$p(payInfo,"^",8)
	set PayNum=$p(payInfo,"^",9) 
	set RecLocDR=$p(payInfo,"^",10)		     //登陆科室
	set InsType=$p(payInfo,"^",11)           //增加费别
	set hospDR=$p(payInfo,"^",13)            //PRT_Hospital_DR
	quit:((myParRef="")||('$d(^DHCEPM("EPM",myParRef)))) 117_"^"_"留观账户不存在"
		
	lock +^DHCEPM("EPM",myParRef):0  else  quit "-110^留观账户被锁定（账户Id："_myParRef_")."
	set rtnValue=..UpdateAM(myParRef, -PayNum, InsType)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		lock -^DHCEPM("EPM",myParRef)
		quit rtnValue    //表示账户更新失败
	}
	set myLeft=$p(rtnValue,"^",2)
	
	&SQL(
 		INSERT INTO DHC_EPPayList (
	 		EPPL_Parref, EPPL_PAPMI_DR, EPPL_InvPrt_DR, EPPL_BillNo, EPPL_User_DR,
	 		EPPL_PayDate, EPPL_PayTime, EPPL_PayNum, EPPL_Left, EPPL_PayRecLoc_DR,
	 		EPPL_Hosp_DR
 		)
 		VALUES (
 			:myParRef, :PAPMIDR, :InvPrtDR, :BillNo, :UserDR,
 			CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :PayNum, :myLeft, :RecLocDR,
 			:hospDR
 		)
 	)
 	set rtn=SQLCODE
 	lock -^DHCEPM("EPM",myParRef)
 	quit:(+rtn) rtn_"^"_$g(%msg)
 	
 	set myPLRowID=$g(%ROWID)
	
	quit rtn_"^"_myPLRowID_"^"_myLeft

ERROR
	quit ..AppException()
}

/// AccRowID: 激活账户的RowID, PNum:需要更新的钱数, InsType: 结算费别
ClassMethod UpdateAM(AccRowID As %String, PNum As %String, InsType As %String = "") As %String
{
	set $zt="ERROR"
	set AccMLeft=$p(^DHCEPM("EPM",AccRowID),"^",9)
	set DepNum=0
	set CNum=AccMLeft-DepNum	//减去下限
	
	set AdmSource=$s((+InsType'=0):$p($g(^PAC("ADMREA",InsType)),"^",9),1:"")
	//quit:((PNum<0)&&($zabs(PNum)>CNum)&&(+AdmSource=0)) 125_"^"_"留观账户余额不足"
	quit:((PNum<0)&&($zabs(PNum)>CNum)) 125_"^"_"留观账户余额不足"
	
	set AccMLeft=$i(AccMLeft,PNum)
	&SQL(
		UPDATE DHC_EPManager
		SET EPM_Balance = :AccMLeft
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn_"^"_AccMLeft

ERROR
	quit ..AppException()
}

/// Creator: hujunbin
/// Modify: ZhYW 2021-11-12
/// CreatDate: 2015-2-14
/// Description: 查询患者留观就诊
/// Input: PatientID:PA_PatMas.RowId, SessionStr:用户Id^安全组Id^科室Id^医院Id
/// Output:	
/// Debug:	do ##class(%ResultSet).RunQuery("web.DHCOPBillEPManageCLS","SearchStayAdm","156","5^122^49^2^1")
Query SearchStayAdm(PatientID As %String, SessionStr As %String) As websys.Query(ROWSPEC = "TAdmRowID:%String:就诊ID,TStayStatus:%String:留观状态,TAdmLoc:%String:科室,TAdmWard:%String:病区,TBedCode:%String:床号,TAdmDate:%String:入院日期,TAdmTime:%String:入院时间,TDisDate:%String:出院日期,TDisTime:%String:出院时间,TAdmInsType:%String:就诊费别,TAccMRowId:%String:账户ID,TAccMLeft:%Float:余额")
{
}

ClassMethod SearchStayAdmExecute(ByRef qHandle As %Binary, PatientID As %String, SessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("SearchSatyAdm")=$lb(PatientID, SessionStr)
    if (PatientID="") quit $$$OK
	
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set AdmRowID=""
	while($o(^PAPERdr(PatientID,"ADM","E",AdmRowID),-1)) {
		set AdmRowID=$o(^PAPERdr(PatientID,"ADM","E",AdmRowID),-1)
		set VisitStatus=$p(^PAADM(AdmRowID),"^",20)
		continue:(VisitStatus="C")
		set AdmLocID=$p(^PAADM(AdmRowID),"^",4)
		set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmLocID)
		continue:(AdmHospDR'=HospId)
		set AdmLoc=$s((+AdmLocID'=0):$p($g(^CTLOC(AdmLocID)),"^",2),1:"")
		set AdmLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", AdmLoc, LangId)
		set StayStatus=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(AdmRowID)   //1:留观出院, 2:正在留观, -1:非留观
		continue:(+StayStatus'>0)
		set AdmWardID=$p(^PAADM(AdmRowID),"^",70)
		set AdmWard=$s((+AdmWardID'=0):$p($g(^PAWARD(AdmWardID)),"^",2),1:"")
		set AdmWard=##class(User.PACWard).GetTranByDesc("WARDDesc", AdmWard, LangId)
		set AdmBedID=$p(^PAADM(AdmRowID),"^",73)
		set BedCode=$s((AdmBedID'=""):$p($g(^PAWARD(+AdmBedID,"BED",+$p(AdmBedID,"||",2))),"^",1),1:"")
		set AdmReaDR=$p($g(^PAADM(AdmRowID,1)),"^",7)
		set AdmInsType=$s((+AdmReaDR'=0):$p($g(^PAC("ADMREA",AdmReaDR)),"^",2),1:"")
		set AdmInsType=##class(User.PACAdmReason).GetTranByDesc("READesc", AdmInsType, LangId)
		set AdmDate=$p(^PAADM(AdmRowID),"^",6)
		set DisDate=$p(^PAADM(AdmRowID),"^",17)
		set AdmTime=$p(^PAADM(AdmRowID),"^",7)
		set DisTime=$p(^PAADM(AdmRowID),"^",18)
		set AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)	
		set DisDate=##class(websys.Conversions).DateLogicalToHtml(DisDate)
		set AdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime, 1)
		set DisTime=##class(websys.Conversions).TimeLogicalToHtml(DisTime, 1)
		//取留观押金账户rowid
		set AccInfo=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(AdmRowID)
		set AccMRowId=$p(AccInfo,"^",2)
		set AccMLeft=$p(AccInfo,"^",3)
		set AccMLeft=$fn(AccMLeft,"",2)
		do OutputAdmStayList
	}
	quit $$$OK
OutputAdmStayList
	set Data=$lb(AdmRowID,StayStatus,AdmLoc,AdmWard,BedCode,AdmDate,AdmTime,DisDate,DisTime,AdmInsType,AccMRowId,AccMLeft)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: hujunbin
/// CreatDate: 2015-04-23
/// Modify: 2016-05-13 Lid 修改，不根据pa_adm表的paadm_billflag来判断，根据此次就诊是否还有B状态的账单
/// Debug:	w ##class(web.DHCOPBillEPManageCLS).GetAdmBillStatus(821)
ClassMethod GetAdmBillStatus(Adm As %String) As %String
{
	set BillFlag="N"
	quit:(Adm="") BillFlag
	
	set flag=0
	set pb=0
	while($o(^DHCPB(0,"ADM",Adm,pb))&&(flag=0)) {
		set pb=$o(^DHCPB(0,"ADM",Adm,pb))
		set payedFlag=$p(^DHCPB(pb),"^",16)
		set pbAmt=$p(^DHCPB(pb),"^",8)
		if ((payedFlag="B")&&(+pbAmt>0)) {
			set flag=1
		}
	}
	if (flag=0) {
		set BillFlag="Y"
	}
	
	quit BillFlag
}

ClassMethod GetBillFlag(adm As %String) As %String
{
	set billFlag="N"
	quit:(+adm=0) billFlag
	set billFlag=$p($g(^PAADM(adm)),"^",45)
	quit billFlag
}

/// Creator: ZhYW
/// CreatDate: 2021-11-12
/// Description: 根据就诊获取押金评估金额
/// Input: adm: PA_Adm.RowId
/// Debug: w ##class(web.DHCOPBillEPManageCLS).GetAdvPayAmt(1062)
ClassMethod GetAdvPayAmt(adm As %String) As %String
{
	quit:(+adm=0) ""
	set accMInfo=..getCurrAcountID(adm)
	set accMRowId=$p(accMInfo,"^",2)
	set advPayInfo=##class(web.DHCEMInterfaceCom).GetAdvPayassInfo(adm)    //调用新产品组接口获取押金评估信息
	set advDate=$p(advPayInfo,"^",1)
	set advTime=$p(advPayInfo,"^",2)
	set advAmt=$p(advPayInfo,"^",3)    //评估金额
	if (+accMRowId=0) {      //无账户时，按评估金额充值
		quit $s((+advAmt'=0):$fn(advAmt,"",2),1:"")
	}
	set advDate=##class(websys.Conversions).DateHtmlToLogical(advDate)
	set advTime=##class(websys.Conversions).TimeHtmlToLogical(advTime, 1)
	if (advDate'="") {
		set sub=""
		while ($o(^DHCEPM("EPM",accMRowId,"EPMD",sub),-1)) {
			set sub=$o(^DHCEPM("EPM",accMRowId,"EPMD",sub),-1)
			set myPDData=$g(^DHCEPM("EPM",accMRowId,"EPMD",sub))
			continue:(myPDData="")
			set myType=$p(myPDData,"^",1)
			continue:(myType'="P")
			set myDate=$p(myPDData,"^",3)
			set myTime=$p(myPDData,"^",4)
			continue:($SYSTEM.SQL.DATEDIFF("ss", myDate_","_myTime, advDate_","_advTime)>0)
			set advAmt=""   //若评估时间之后有充值记录，则该评估记录无效
			quit
		}
	}
			
	quit $s((+advAmt'=0):$fn(advAmt,"",2),1:"")
}

}
