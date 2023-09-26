/// 解决部分一致性问题
Class web.UDHCAccManageCLS7 Extends DHCDoc.Util.RegisteredObject
{

/// AdmStr  患者的就诊 Adm号码
/// 此处要区别对待一个索引问题
///   1. 按照卡号索引为主 检索患者信息和患者帐户信息
///   2. 以卡类型索引为主 检索患者的信息和账户信息
/// CheckSecurityFlag    验证校验码标志
///   =  "PatInfo"  只获取患者信息不获取账户信息
///   =  "ALL"      表示要求有验证
///   =  ""	
/// Debug: w ##class(web.UDHCAccManageCLS7).getaccinfofromcardno("100000007893","6191340506","2","","","")
///        w ##class(web.UDHCAccManageCLS7).getaccinfofromcardno("0000000123","","1","","PatInfo","")
///        w ##class(web.UDHCAccManageCLS7).getaccinfofromcardno("0000000123","","1","","","")
ClassMethod getaccinfofromcardno(cardno As %String, securityno As %String, CardTypeDR As %String, AdmStr As %String, CheckSecurityFlag As %String, ExpStr As %String) As %String
{
	set ^TMP("getaccinfofromcardno")=$lb(cardno, securityno, CardTypeDR, AdmStr, CheckSecurityFlag, ExpStr)
	
	quit:(cardno="") -200_"^^^^^^^^"		//无效卡标志
	
	//+2022-03-14 ZhYW 取院区
	set hospId=$p(ExpStr,"^",1)
	if ((hospId="")&&($d(%session))) {
		set hospId=%session.Get("LOGON.HOSPID")
	}
	
	set rtn=0
	
	do ..KillTMP()
	
	set AccID="", AccNo="", left=0, Balance=0, DepPrice=0
	set Papmi=""
	set Password=""
	set PAPMINo=""
	set myCardRowID=""
	set myCardTypeDR=""
	set myACFlag=-200		;无效卡
	set mySelectCardTypeTip=""		;选择卡类型提示
	
	set myAccType="P"
	
	set mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	
	set AccMCreatMode=$s((+CardTypeDR'=0):$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",45),1:"")   //+2023-04-07 ZhYW 获取卡类型配置的账户创建模式
	
	;^TMPAccCardIdx
	;^DHCCARDi("CF",0,"CardTypeNo",{CF_CardType_DR},{CF_CardNo},{CF_RowID})
	if (CardTypeDR="") {
		set mySCMode="PC"
	}else  {
		//set mySCMode=$p(^DHCCARDTYPEDef(CardTypeDR),"^",28)		;SearchCardNoMode
		set mySCMode=..%GetConfig("SearchCardNoModeConfig")
	}
	
	if (mySCMode="PC") do
	.;优先 卡号
	.;在不指定卡类型的情况下的优先级别
	.;如果数据有多条， 需要验证卡类型的RowID
	.set CardId=0
	.for  set CardId=$o(^DHCCARDi("CF",0,"CardNo",cardno,CardId)) quit:(CardId="")  do
	..set CardData=$g(^DHCCARD("CF",CardId))
	..set ActiveFlag=$p(CardData,"^",10)
	..quit:(ActiveFlag'="N")
	..set myCardTypeDR=$p(CardData,"^",16)		//CF_CardType_DR
	..set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef", myCardTypeDR, hospId)
	..quit:(ShowFlag'="Y")   //2022-03-14 ZhYW 判断卡类型是否给该院区授权
	..set SecurityNO=$p(CardData,"^",3)
	..if (SecurityNO=$c(0)) set SecurityNO=""
	..quit:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	..set ^TMPAccCardIdx($j)=+$g(^TMPAccCardIdx($j))+1
	..set ^TMPAccCardIdx($j,"CardRowID",CardId)=""
	else  do
	.;默认方式
	.;指定卡号和卡类型
	.;此时要求必须唯一才成
	.set CardId=0
	.for  set CardId=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDR,cardno,CardId)) quit:(CardId="")  do
	..set CardData=$g(^DHCCARD("CF",CardId))
	..set ActiveFlag=$p(CardData,"^",10)
	..quit:(ActiveFlag'="N")
	..set SecurityNO=$p(CardData,"^",3)
	..if (SecurityNO=$c(0)) set SecurityNO=""
	..quit:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	..set ^TMPAccCardIdx($j)=+$g(^TMPAccCardIdx($j))+1
	..set ^TMPAccCardIdx($j,"CardRowID",CardId)=""
	
	;以下都是有效卡记录
	set CardId=0
	for  set CardId=$o(^TMPAccCardIdx($j,"CardRowID",CardId)) quit:((CardId="")||(myACFlag=0))  do
	.set CardData=$g(^DHCCARD("CF",CardId))
	.set ActiveFlag=$p(CardData,"^",10)
	.quit:(ActiveFlag'="N")
	.set SecurityNO=$p(CardData,"^",3)
	.if (SecurityNO=$c(0)) set SecurityNO=""
	.quit:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	.set myCardTypeDR=$p(CardData,"^",16)		//CF_CardType_DR
	.quit:(mySCMode'="PC")&&(+$g(^TMPAccCardIdx($j))>1)	;如果卡类型与卡号同时比较 而出现两张卡,一定无效
	.;如果 卡号优先 同时只检索一个卡号 , 这个卡号一定有效
	.;如果 卡号优先 但是检索多个卡号,需要对比当前的卡类型,如果不一致就退出, 
	.quit:((mySCMode="PC")&&(+$g(^TMPAccCardIdx($j))>1)&&(myCardTypeDR'=CardTypeDR))
	.;判断有效卡标志
	.set myACFlag=0		;此卡有效
	.set Papmi=$p(CardData,"^",4)
	.set myCardRowID=CardId
	.set PAPMINo=##class(web.PAPatMas).GetRegistration(Papmi)
	.;前面是患者基本信息
	.quit:(CheckSecurityFlag="PatInfo")			;如果强调 只获取患者信息， 而不要账户信息
	.//后面是账户信息
	.//set myAccRowID=$p(CardData,"^",1)
	.//+2022-12-06 ZhYW 根据账户创建模式和院区取账户
	.if (AccMCreatMode="C") do
	..set myAccRowID=##class(web.UDHCAccManageCLS).GetAccMRowIDByCard(Papmi, cardno, myCardTypeDR, hospId)  //根据卡号获取账户ID
	.else  do
	..set myAccRowID=##class(web.UDHCAccManageCLS).GetAccMRowIDByPAPMI(Papmi, hospId)    //根据患者主索引获取账户信息ID
	.quit:(myAccRowID="")
	.set AccMData=$g(^DHCACD("AccM",myAccRowID))
	.set AccStatus=$p(AccMData,"^",13)
	.quit:(AccStatus'="N")
	.set AccID=myAccRowID
	.set AccNo=$p(AccMData,"^",1)
	.set Balance=$p(AccMData,"^",8)
	.set Password=$p(AccMData,"^",12)
	.set DepPrice=$p(AccMData,"^",14)
	.set DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myAccRowID, AdmStr, "")
	.set left=Balance-DepPrice
	.set myAccType=$p(AccMData,"^",16)
	
	set rtn=myACFlag
	
	;卡有效，而账户无效返回-201
	if ((myACFlag=0)&&(AccID="")) set rtn=-201
	
	if ((mySCMode="PC")&&(+$g(^TMPAccCardIdx($j))>1)&&(+rtn)) {
		set mySelectCardTypeTip="请选择卡类型"
		set myCardTypeDR=""
	}
	
	;如果 卡号优先 但是检索多个卡号,需要对比当前的卡类型,如果不一致就退出
	;在界面上提示患者选择 卡类型
	set str=rtn_"^"_AccID_"^"_AccNo_"^"_$fn(left,"",2)_"^"_$fn(Balance,"",2)_"^"_DepPrice_"^"_Password
	set str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	set str=str_"^"_mySCMode_"^"_myCardTypeDR_"^"_mySelectCardTypeTip
	
	;add by zhouzq 2010.09.08 for the cardno is not exist bug
	set ReturnInfo=str
	
    set GrpStr=str
	if ((rtn="-201")||(rtn=0)) {
		set myGAInfo=""
		set myGAInfo=..GetGroupAccInfoByCardNo(Papmi, AdmStr, CheckSecurityFlag)
	    set ReturnInfo=str_"^"_GrpStr
		if (+$p(myGAInfo,"^",1)=0){
		    if ($p(myGAInfo,"^",12)="G") {
			   set $p(GrpStr,"^",1)=$p(myGAInfo,"^",1)
			   set $p(GrpStr,"^",2)=$p(myGAInfo,"^",2)
			   set $p(GrpStr,"^",3)=$p(myGAInfo,"^",3)
			   set $p(GrpStr,"^",4)=$p(myGAInfo,"^",4)
			   set $p(GrpStr,"^",5)=$p(myGAInfo,"^",5)
			   set $p(GrpStr,"^",6)=$p(myGAInfo,"^",6)
			   set $p(GrpStr,"^",7)=$p(myGAInfo,"^",7)
			   set $p(GrpStr,"^",11)=$p(myGAInfo,"^",11)
			   set ReturnInfo=GrpStr_"^"_str
			}
		}
	}
	
	do ..KillTMP()
	
	quit ReturnInfo
}

ClassMethod GetAccMDepPrice(AccRowID As %String, AdmStrInfo As %String) As %String
{
	s DepPrice=+$p($g(^DHCACD("AccM",AccRowID)),"^",14)
	q DepPrice
}

/// 根据卡号获取对应的集体账户信息
/// 根据PAPMI获取集体账户信息
ClassMethod GetGroupAccInfoByCardNo(PAPMIDR As %Library.String, AdmStr As %String, CheckSecurityFlag As %String) As %String
{
	s myrtn="-220"
	s myGroupInfo=""
	
	;集体账户结算后，还可以办理账户
	
	s myAAccRowID=""
	s myAAccAccNo=""
	s myAAccleft=""
	s myAAccBalance=""
	s myAAccDepPrice=""
	s myAAccPass=""
	s myAAccType="C"
	
	;^DHCACDi("AccM",0,"GA","PAPMI",{AGA_PAPMI_DR},{DHC_AccManager.AccM_RowID},"A",{AGA_Sub})
	q:(PAPMIDR="") myGroupInfo
	s myGARowID=0
	f  s myGARowID=$o(^DHCACDi("AccM",0,"GA","PAPMI",PAPMIDR,myGARowID)) q:((myGARowID="")!(myAAccRowID'=""))  d
	.;^DHCACD("AccM",{AccM_RowID})
	.s AccStatus=$p(^DHCACD("AccM",myGARowID),"^",13)
	.q:(AccStatus'="N")
	.s myAAccRowID=myGARowID
	.s myAAccAccNo=$p(^DHCACD("AccM",myGARowID),"^",1)
	.s myAAccBalance=$p(^DHCACD("AccM",myGARowID),"^",8)
	.s myAAccPass=$p(^DHCACD("AccM",myGARowID),"^",12)
	.s myAAccDepPrice=$p(^DHCACD("AccM",myGARowID),"^",14)
	.s myAAccDepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myGARowID, "","")
	.s myAAccleft=myAAccBalance-myAAccDepPrice
	.s myAAccType=$p(^DHCACD("AccM",myGARowID),"^",16)
	
	q:(myAAccRowID="") myrtn_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	
	s mysub=$o(^DHCACDi("AccM",0,"GA","PAPMI",PAPMIDR,myAAccRowID,"A",0))
	
	s myrtn="-221"
	
	s myFlag=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",1)
	s myBeginDate=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",2)
	s myBeginTime=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",3)
	s myEndDate=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",4)
	s myEndTime=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",5)
	s myCurrentLimit=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",8)		;本次限额
	s myPrior=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",7)  ; 优先级
	
	if (myFlag="Y"){
		if ((myBeginDate="")!((myBeginDate'="")&&(myBeginDate<=..%SysDate()))){
			if ((myEndDate="")!((myEndDate'="")&&(+myEndDate>=..%SysDate()))){
				s myrtn=0
				if (+myCurrentLimit>0){
					s myAAccleft=+myCurrentLimit
				}
			}
		}
	}
	;s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Password
	;s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	;s str=str_"^"_mySCMode_"^"_myCardTypeDR_"^"_mySelectCardTypeTip
	s myGroupInfo=myrtn_"^"_myAAccRowID_"^"_myAAccAccNo_"^"_myAAccleft_"^"_myAAccBalance
	s myGroupInfo=myGroupInfo_"^"_myAAccDepPrice_"^"_myAAccPass_"^^^^"_myAAccType_"^"_myPrior_"^^"

	q myGroupInfo
}

ClassMethod KillTMP() As %String
{
	k ^TMPAccCardIdx($j)
}

/// Debug: w ##class(web.UDHCAccManageCLS7).GetAccInfoByPAPMI("0000143567","")
ClassMethod GetAccInfoByPAPMI(PAPMINO As %String, AdmStr As %String, HospId As %String = "") As %String
{
	;得到帐户信息，通过卡号，登记号，还有AdmStr
	;此处的前提是卡已经有效，此处不在判断卡是否有效
	set rtn=0
	
	quit:(PAPMINO="") "0^^^^"
	
	;账户无效，返回-201
	set rtn=-201
	set myAccType=""
	set myAccTypeDesc=""
	set myAccUsePrice=0			;账户的可用款
	set AccRowID=""
	;账户的余额
	;账户的限额
	
	set myPAPMIDR=$o(^PAPERi("PAPMI_PatNo",PAPMINO,0))
	quit:(myPAPMIDR="") "0^^^^"
	
	set AccRowID=##class(web.UDHCAccManageCLS).GetAccMRowIDByPAPMI(myPAPMIDR, HospId)   //+2023-02-08 ZhYW
	if (AccRowID>0) {
		set rtn=0
		set myAccData=$g(^DHCACD("AccM",AccRowID))
		set Balance=$p(myAccData,"^",8)
		set DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(AccRowID, AdmStr, "")
		set left=Balance-DepPrice
		set myAccUsePrice=left
		set myAccType=$p(myAccData,"^",16)
		if (+DepPrice<0) {
			set myAccType="S"		//处于担保状态
		}
	}
	
	set myAccUsePrice=$fn(myAccUsePrice,"",2)
	if (myAccType="P") {
		set myAccTypeDesc="账户"
	}elseif(myAccType="S") {
		set myAccTypeDesc="担保"
	}else{
		set myAccTypeDesc="集体"
	}
	set myAccInfo=rtn_"^"_AccRowID_"^"_myAccUsePrice_"^"_myAccTypeDesc_"^"_myAccType
	
	quit myAccInfo
}

/// add by xz
/// 取挂失人  挂失原因
/// Debug: w ##class(web.UDHCAccManageCLS7).GetCancenlInfo("0002019317","")
ClassMethod GetCancenlInfo(cardno As %String, CardTypeDR As %String) As %String
{
	s CancelInfo=""
	i CardTypeDR="" d
	.s mySCMode="PC" 
	e  d
	.s mySCMode=$p(^DHCCARDTYPEDef(CardTypeDR),"^",28)
	i mySCMode="PC" d
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,mycardid)) q:((mycardid=""))  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..q:(ActiveFlag'="S")
	..s CSCSub=0 
	..f  s CSCSub=$o(^DHCCARD("CF",mycardid,"CSC",CSCSub)) q:CSCSub=""  d
	...s CSCStatus=$p(^DHCCARD("CF",mycardid,"CSC",CSCSub),"^",3)
	...q:(CSCStatus'="S")
	...s CSCUserDR=$p(^DHCCARD("CF",mycardid,"CSC",CSCSub),"^",4)
	...s SSUSerDesc=$p(^SSU("SSUSR",CSCUserDR),"^",2)
	...s CSCReMark=$p(^DHCCARD("CF",mycardid,"CSC",CSCSub),"^",16)
	...s CancelInfo=""
	...s CancelInfo=SSUSerDesc_"^"_CSCReMark
	e  d
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDR,cardno,mycardid)) q:(mycardid="")  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..q:(ActiveFlag'="S")
	..s CSCSub=0 
	..f  s CSCSub=$o(^DHCCARD("CF",mycardid,"CSC",CSCSub)) q:(CSCSub="")  d
	...s CSCStatus=$p(^DHCCARD("CF",mycardid,"CSC",CSCSub),"^",3)
	...q:(CSCStatus'="S")
	...s CSCUserDR=$p(^DHCCARD("CF",mycardid,"CSC",CSCSub),"^",4)
	...s SSUSerDesc=$p(^SSU("SSUSR",CSCUserDR),"^",2)
	...s CSCReMark=$p(^DHCCARD("CF",mycardid,"CSC",CSCSub),"^",16)
	...s CancelInfo=""
	...s CancelInfo=SSUSerDesc_"^"_CSCReMark
	q CancelInfo
}

}
