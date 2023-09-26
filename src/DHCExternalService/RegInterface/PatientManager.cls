Class DHCExternalService.RegInterface.PatientManager Extends (%RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 日期检查
ClassMethod ValidDate(para As %String) As %String
{
	n (para)
	s $ZT="DateErr"
	q $ZDH(para,3)
DateErr
	q -1
}

ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String, CardTypeDR As %String, AdmStr As %String, CheckSecurityFlag As %String, ExpStr As %String) As %Library.String
{
	;AdmStr  患者的就诊 Adm号码
	;此处要区别对待一个索引问题
	;1. 按照卡号索引为主 检索患者信息和患者帐户信息
	;2. 以卡类型索引为主 检索患者的信息和账户信息	
	;CheckSecurityFlag    验证校验码标志
	;=  "PatInfo"		只获取患者信息不获取账户信息
	;=  "ALL"			表示要求有验证
	;=  ""
	
	;w ##class(web.UDHCAccManageCLS7).getaccinfofromcardno("100000007893","6191340506","2","","","")
	;w ##class(DHCExternalService.RegInterface.PatientManager).getaccinfofromcardno("1000000000000000535","","2","","","")
	n (cardno, securityno, CardTypeDR, AdmStr, CheckSecurityFlag, ExpStr)	
	s ^TMPFDFDD=cardno_","_securityno_","_CardTypeDR_","_AdmStr_","_CheckSecurityFlag_","_ExpStr
	
	q:((cardno="")) "-200^^^^^^^^"		;;无效卡标志
	
	s rtn=0
	
	d ..KillTMP()
	
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
	i CardTypeDR="" d
	.s mySCMode="PC"
	e  d
	.s mySCMode=$p(^DHCCARDTYPEDef(CardTypeDR),"^",28)		;SearchCardNoMode
	i mySCMode="PC" d
	.;优先 卡号
	.;在不指定卡类型的情况下的优先级别
	.;如果数据有多条， 需要验证卡类型的RowID
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,mycardid)) q:((mycardid=""))  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..q:ActiveFlag'="N"
	..s SecurityNO=$p(^DHCCARD("CF",mycardid),"^",3)
	..i SecurityNO=$c(0) s SecurityNO=""
	..q:((SecurityNO'="")&&(SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo")&&(mySecNoEncrypt'=""))			;securityno
	..s ^TMPAccCardIdx($j)=+$g(^TMPAccCardIdx($j))+1
	..s ^TMPAccCardIdx($j,"CardRowID",mycardid)=""
	e  d
	.; 默认方式
	.; 指定卡号和卡类型
	.; 此时要求必须唯一才成， 
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDR, cardno, mycardid)) q:(mycardid="")  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..q:ActiveFlag'="N"
	..s SecurityNO=$p(^DHCCARD("CF",mycardid),"^",3)
	..i SecurityNO=$c(0) s SecurityNO=""
	..q:((SecurityNO'="")&&(SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	..s ^TMPAccCardIdx($j)=+$g(^TMPAccCardIdx($j))+1
	..s ^TMPAccCardIdx($j,"CardRowID",mycardid)=""
	
	;以下都是有效卡记录
	s cardid=0
	f  s cardid=$o(^TMPAccCardIdx($j,"CardRowID",cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.i SecurityNO=$c(0) s SecurityNO=""
	.q:((SecurityNO'="")&&(SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo")&&(mySecNoEncrypt'=""))			;securityno
	.s myRtnCardTypeDR=$p(^DHCCARD("CF",cardid),"^", 16)		;CF_CardType_DR
	.q:(mySCMode'="PC")&&(+$g(^TMPAccCardIdx($j))>1)	;如果卡类型与卡号同时比较 而出现两张卡,一定无效
	.;如果 卡号优先 同时只检索一个卡号 , 这个卡号一定有效
	.;如果 卡号优先 但是检索多个卡号  ,需要对比当前的卡类型,如果不一致就退出, 
	.q:((mySCMode="PC")&&(+$g(^TMPAccCardIdx($j))>1)&&(myRtnCardTypeDR'=CardTypeDR))
	.;判断有效卡标志
	.s myACFlag=0		;此卡有效
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s myCardRowID=cardid
	.s PAPMINo=##Class(web.PAPatMas).GetRegistration(Papmi)
	.;前面是患者基本信息
	.q:(CheckSecurityFlag="PatInfo")			;如果强调 只获取患者信息， 而不要账户信息
	.;后面是账户信息
	.s myAccRowID=$p(^DHCCARD("CF",cardid),"^",1)	;myAccRowID
	.q:myAccRowID=""
	.s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
	.q:AccStatus'="N"
	.s AccID=myAccRowID
	.s AccNo=$p(^DHCACD("AccM",myAccRowID),"^",1)
	.s Balance=$p(^DHCACD("AccM",myAccRowID),"^",8)
	.s Pass=$p(^DHCACD("AccM",myAccRowID),"^",12)
	.s DepPrice=$p(^DHCACD("AccM",myAccRowID),"^",14)
	.s DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myAccRowID, AdmStr,"")
	.s left=Balance-DepPrice
	.s myAccType=$p(^DHCACD("AccM",myAccRowID),"^",16)
	s rtn=myACFlag
	
	;卡有效，而账户无效返回-201
	i ((myACFlag=0)&&(AccID="")) s rtn=-201
	
	i ((mySCMode="PC")&&(+$g(^TMPAccCardIdx($j))>1)&&(+rtn'=0)) d
	.s mySelectCardTypeTip="请选择卡类型!"
	.s myRtnCardTypeDR=""
	
	;如果 卡号优先 但是检索多个卡号  ,需要对比当前的卡类型,如果不一致就退出, 
	;在界面上提示患者选择 卡类型
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	s str=str_"^"_mySCMode_"^"_myRtnCardTypeDR_"^"_mySelectCardTypeTip
	
	;add by zhouzq 2010.09.08 for the cardno is not exist bug
	s ReturnInfo=str
	
    s GrpStr=str
	if (rtn="-201")!(rtn=0){
		s myGAInfo=""
		s myGAInfo=##class(web.UDHCAccManageCLS7).GetGroupAccInfoByCardNo(Papmi, AdmStr, CheckSecurityFlag)
	    s ReturnInfo=str_"^"_GrpStr
		if (+$p(myGAInfo,"^",1)=0){
		    if ($p(myGAInfo,"^",12)="G")
			{	
			   s $p(GrpStr,"^",1)=$p(myGAInfo,"^",1)
			   s $p(GrpStr,"^",2)=$p(myGAInfo,"^",2)
			   s $p(GrpStr,"^",3)=$p(myGAInfo,"^",3)
			   s $p(GrpStr,"^",4)=$p(myGAInfo,"^",4)
			   s $p(GrpStr,"^",5)=$p(myGAInfo,"^",5)
			   s $p(GrpStr,"^",6)=$p(myGAInfo,"^",6)
			   s $p(GrpStr,"^",7)=$p(myGAInfo,"^",7)
			   s $p(GrpStr,"^",11)=$p(myGAInfo,"^",11)
			   s ReturnInfo=GrpStr_"^"_str
			}
		}
	}
	
	d ..KillTMP()
	q $g(ReturnInfo)
}

ClassMethod KillTMP() As %String
{
	
	k ^TMPAccCardIdx($j)
}

ClassMethod GetPatientHadFlag(IDCardType, IDNo, PatientName, ALLFlag As %String = "") As %String
{
	s ^tmp("GetPatientHadFlag")=$lb(IDCardType, IDNo, PatientName, ALLFlag)
	s myHadFlag=""
	s IDTypeID=$O(^PAC("CARD",0,"Code","01",0))
	if IDNo=""{
		q "-1^证件号码不能为空"
	}
	if PatientName=""{
		q "-1^姓名不能为空"
	}
	if (IDTypeID=IDCardType)
	{
		if ($length(IDNo)=18)
		{
			set myIDCardNo18=IDNo
			set myIDCardNo15=##class(DHCExternalService.CardInterface.CardManager).ID18to15(IDNo)
		}
		else
		{
			set myIDCardNo15=InfoObj.IDNo
			set myIDCardNo18=##class(DHCExternalService.CardInterface.CardManager).ID15to18(IDNo)
		}
		if (ALLFlag'="GETALL"){
			set myHadFlag=..GetPatIDByIDCardAndName(myIDCardNo18,PatientName,ALLFlag,IDCardType)
			if (myHadFlag="") set myHadFlag=..GetPatIDByIDCardAndName(myIDCardNo15,PatientName,ALLFlag,IDCardType)
		}else{
			set myHadFlag=..GetAllPatIDByIDCardAndName(myIDCardNo18,PatientName,IDCardType)
			if (myHadFlag="") set myHadFlag=..GetAllPatIDByIDCardAndName(myIDCardNo15,PatientName,IDCardType)
		}
	}
	else
	{
		if (ALLFlag'="GETALL"){
			set myHadFlag=..GetPatIDByIDCardAndName(IDNo,PatientName,ALLFlag,IDCardType)
		}else{
			set myHadFlag=..GetAllPatIDByIDCardAndName(IDNo,PatientName,IDCardType)	
		}
	}
	
	quit myHadFlag
}

/// 根据证件号和姓名得到病人id，如果没有医保卡记录则取最新的一条记录，否则取医保卡对应记录
/// w ##class(DHCExternalService.RegInterface.PatientManager).GetPatIDByIDCardAndName("","")
ClassMethod GetPatIDByIDCardAndName(IDCard As %String = "", Name As %String = "", ALLFlag As %String = "", IDCardType As %String = "") As %String
{
	n (IDCard,Name,ALLFlag,IDCardType)
	set PatientID=""
	quit:IDCard="" PatientID
	set YBPatientID="",FindPatientID=""
	s IDCard=$zcvt(IDCard,"U")
	for {
		s PatientID=$O(^PAPERi("DVA",IDCard,PatientID)) q:PatientID=""
		s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
		continue:ActiveFlag="N"
		set CurName=$P(^PAPER(PatientID,"ALL"),"^",1)
		continue:(Name'="")&&(CurName'=Name)
		s myCredType=""
		s myCredTypeID=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
		s:myCredTypeID'="" myCredType=$p($g(^PAC("CARD",myCredTypeID)),"^",1)
		continue:(IDCardType'="")&&(IDCardType'=myCredTypeID)
		set PatYBCode=$p($g(^PAPER(PatientID,"ALL")),"^",19)
		;新版医保号存储位置有改动
		;PAPMI_HealthFundNo字段的存储位置与索引为：
		set PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)

		s FindPatientID=PatientID
		if (PatYBCode'="")&&(ALLFlag="GETNEWINSU") {
			set YBPatientID=PatientID	
		}
	}
	i YBPatientID'="" s FindPatientID=YBPatientID
	quit FindPatientID
}

/// 根据证件号和姓名得到所有病人id
/// w ##class(DHCExternalService.RegInterface.PatientManager).GetAllPatIDByIDCardAndName("","")
ClassMethod GetAllPatIDByIDCardAndName(IDCardNo As %String = "", PatientName As %String = "", IDCardType As %String = "") As %String
{
	n (IDCardNo,PatientName,IDCardType)
	set PatientIDStr=""
	quit:IDCardNo="" PatientIDStr
	set PatientID=""
	
	Set IDCardNo=$ZCVT(IDCardNo,"U")
	Set RecordCount=0
	Set PatientId=0
	for  Set PatientId=$o(^PAPERi("PAPMI_ICPPBC",IDCardNo_"Z",PatientId)) Quit:PatientId=""  do
	.s PAPMIDVAnumber=$P($G(^PAPER(PatientId,"ALL")),"^",9 )  ;身份证 证件类型
	.if PAPMIDVAnumber=""  d
	..s myCredType=""
	..s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
	..s:myCredTypeID'="" myCredType=$p($g(^PAC("CARD",myCredTypeID)),"^",1)
	..if (IDCardType="")!((IDCardType'="") && (myCredTypeID=IDCardType))  d
	...s PAPMIDVAnumber=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)
	.Q:PAPMIDVAnumber'=IDCardNo
	.if PatientIDStr=""  s PatientIDStr=PatientId
	.else  s PatientIDStr=PatientIDStr_"^"_PatientId
 		
	//证件信息位数不足,可以用以下作为补充查询
	Set PatientId=0
	f  s PatientId=$O(^PAPERi("DVA",IDCardNo,PatientId)) q:PatientId=""  do
    .s ActiveFlag=$P(^PAPER(PatientId,"PAT",1),"^",6)
    .Q:ActiveFlag="N"
    .s myCredType=""
	.s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
	.s:myCredTypeID'="" myCredType=$p($g(^PAC("CARD",myCredTypeID)),"^",1)
	.Q:(IDCardType'="")&&(IDCardType'=myCredTypeID)
    .s CurName=$P(^PAPER(PatientId,"ALL"),"^",1)
    .Q:(PatientName'="")&&(CurName'=PatientName)
    .Q:("^"_PatientIDStr_"^")[("^"_PatientId_"^")
    .if PatientIDStr=""  s PatientIDStr=PatientId
	.else  s PatientIDStr=PatientIDStr_"^"_PatientId
 		
	quit PatientIDStr
}

}
