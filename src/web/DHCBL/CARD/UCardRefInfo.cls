Class web.DHCBL.CARD.UCardRefInfo Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 174;

/// Description:: 判断病人类型默认的费别是否是医保类型(用于判断是否需要医保卡号)
/// Input:        PatypeDr:病人类型id
/// Return:       医保标志(0代表非医保) 
ClassMethod GetInsurFlag(PatypeDr As %String) As %String
{
	s rtn=0
	i PatypeDr="" q rtn
	s AdmReason=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatypeDr)
	s rtn=##class(web.DHCDocOrderCommon).GetInsurFlag(AdmReason,"")
	q rtn
}

/// 建卡时需要的验证关系
ClassMethod CreateCardCheckData(IDNo As %String = "", CredTypeDR As %String, CredNo As %String = "", CardTypeDR As %String = "", ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardRefInfo).CreateCardCheckData("",20,1,"","14小时")
	;如果这个证件号码已经办过此类卡， 决不让办理下一个  返回 -365
	;对于集团办就诊卡，  需要补充 把患者归到集团中
	;如果这个证件号码办过同是 IDU 的卡 一定要办理绑定
	;绑定时,  返回此卡对照的基本信息
	;同时要求 此类卡的基本信息是否能够 覆盖当前的基本信息
	;如果不能覆盖， 返回
	;IDNo   身份证号码
	;CredTypeDR  证件类型
	;CredNo    证件号码   
	;CardTypeDR   卡类型
	n (IDNo, CredTypeDR, CardTypeDR, CredNo, ExpStr,%session)
	s ^TMPCardCHEKCDTATA=(IDNo_","_CredTypeDR_","_CardTypeDR_","_CredNo_","_ExpStr)
	
	s Age=$P(ExpStr,"^",1)
	s HospitalID=$P(ExpStr,"^",2)
	s TemporaryCard=$P(ExpStr,"^",3)
	i ($g(HospitalID)="")&&($d(%session)) s HospitalID=%session.Get("LOGON.HOSPID")
	s myrtn=0
	s CredNoRequire=..CheckCardNoRequired(CredTypeDR)
	i (CardTypeDR=""){
		s myrtn=-366
	}else{
		;此时要求证件号码<>""
		s mySameFind=0
		s myIDUFind=0			;唯一标示发现
		
		s myPAPMIDR=0
		s myRtnPAPMIRowID=""
		s myCardTypeValidateFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^", 30)		;CTD_ValidateMode
		///身份证类型验证  ID Unqiue
		///证件类型唯一性验证
		if (myCardTypeValidateFlag="IDU"){
			i (IDNo="")&(CredNo="") d
			.s myrtn=-367
			
			;Q:((+$G(^DHCDocCardConfig("NOCREAD"))=1)&&(myrtn="-367")) 0 ;如果全局参数允许为空为空时不校验
			q:(TemporaryCard="Y")&&(myrtn="-367") 0 ;临时卡不必填时不校检
			q:(CredNoRequire'="Y")&&(myrtn="-367") 0   ;证件类型不必填时不校检
			s AllowAge=##class(web.DHCDocConfig).GetDHCDocCardConfig("AllowAgeNoCreadCard",HospitalID) //$G(^DHCDocCardConfig("AllowAgeNoCreadCard"))
			if (AllowAge'=""){
				if ((Age["小时")||(Age["分钟")||(Age["分"))&&(Age'["岁") s Age=0
				Q:((AllowAge'="")&&(Age<=AllowAge)&&(myrtn="-367")) 0 ;符合定义无卡建卡年龄的可以不要身份证
			}
			
			q:(myrtn) myrtn
			
			s myPAID=$ZConvert(IDNo,"U")
			i $l(myPAID)=15{
				s myPAID15=$ZConvert(myPAID_"Z", "U")
				s myPAID18=$e(myPAID,1,6)_"19"_$e(myPAID,7,15)_" "
				s myPAID18=$ZConvert(myPAID18_"Z","U")
				
			}elseif($l(myPAID)=18){
				s myPAID18=$ZConvert(myPAID_"Z", "U")
				s myPAID15=$e(myPAID,1,6)_$e(myPAID,9,17)
				s myPAID15=$ZConvert(myPAID15_"Z","U")
			}else
			{
				s myPAID18="ZX"
				s myPAID15="ZX"
			}
			
			;^DHCCARDi("CF",0,"PAPMICTDR",{CF_PAPMI_DR},{CF_CardType_DR},      x
			;分成  15 位和 18位区别
			f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID18,myPAPMIDR))  q:((myPAPMIDR="")!(+mySameFind))  d
			.s PAPMIActive=$P(^PAPER(myPAPMIDR,"PAT",1),"^",6)
			.Q:PAPMIActive="N"
			.s myCardTypeDR=0
			.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			..s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
			..i (myIDUniqueFlag="IDU") d
			...s myIDUFind=1
			...s myRtnPAPMIRowID=myPAPMIDR
			..s myCardRowid=0
			..f  s myCardRowid=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,myCardRowid)) q:(myCardRowid="")!(+mySameFind)  d
			...s myCardActive=$p(^DHCCARD("CF",myCardRowid),"^",10)
			...q:myCardActive'="N"
			...i CardTypeDR=myCardTypeDR d
			....s mySameFind=1
			
			b	;18
			s myPAPMIDR=0
			f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID15,myPAPMIDR))  q:((myPAPMIDR="")!(+mySameFind))  d
			.s PAPMIActive=$P(^PAPER(myPAPMIDR,"PAT",1),"^",6)
			.Q:PAPMIActive="N"
			.s myCardTypeDR=0
			.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			..s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
			..i (myIDUniqueFlag="IDU") d
			...s myIDUFind=1
			...s myRtnPAPMIRowID=myPAPMIDR
			..s myCardRowid=0
			..f  s myCardRowid=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,myCardRowid)) q:(myCardRowid="")!(+mySameFind)  d
			...s myCardActive=$p(^DHCCARD("CF",myCardRowid),"^",10)
			...q:myCardActive'="N"
			...i CardTypeDR=myCardTypeDR d
			....s mySameFind=1
			..
			b	;15
			;唯一表示被发现，建立卡时需要绑定
			i +myIDUFind d
			.s myrtn=-368
			
			i +mySameFind d
			.s myrtn=-365
			
			s myPAID=$ZConvert(CredNo, "U")
			;验证证件类型和证件号码
			;没有发现身份证号重复
			i (+mySameFind=0)&(+myIDUFind=0) d
			.;^PAPERi("DVA",$$ALPHAUP({PAPMI_DVAnumber}),{PAPMI_RowId})
			.s myPAPMIDR=0
			.f  s myPAPMIDR=$o(^PAPERi("DVA",myPAID,myPAPMIDR))  q:(myPAPMIDR="")  d
			..s PAPMIActive=$P(^PAPER(myPAPMIDR,"PAT",1),"^",6)
			..Q:PAPMIActive="N"
			..;同一证件类型才成
			..s myCredTypeDR=$p(^PAPER(myPAPMIDR,"PAT",3),"^",7)	;CardType_DR
			..b	;
			..i CredTypeDR=myCredTypeDR d
			...s myCardTypeDR=0
			...f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			....s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
			....i (myIDUniqueFlag="IDU") d
			.....s myIDUFind=1
			.....s myRtnPAPMIRowID=myPAPMIDR
			....s myCardRowid=0
			....f  s myCardRowid=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,myCardRowid)) q:(myCardRowid="")!(+mySameFind)  d
			.....s myCardActive=$p(^DHCCARD("CF",myCardRowid),"^",10)
			.....q:myCardActive'="N"
			.....i CardTypeDR=myCardTypeDR d
			......s mySameFind=1
			
			;唯一表示被发现，建立卡时需要绑定
			i +myIDUFind d
			.s myrtn=-368
			
			i +mySameFind d
			.s myrtn=-365
		}
	}
	
	q myrtn_"^"_myRtnPAPMIRowID
}

/// 根据PMI获取一个默认的卡号码，如果患者有多个卡号，不准确
ClassMethod GetDefaultCardNoByPMI(PAPMI As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardRefInfo).GetDefaultCardNoByPMI(427940)
	s myrtn=0
	
	q:PAPMI="" "-301^"
	
	;没有找到有效的卡号
	s myrtn=-372
	s myDefCardNo=""
	s myDefCardTypeDR=""
	s cfrowid=0
	f  s cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMI,cfrowid))  q:(cfrowid="")||(myDefCardNo'="")  d
	.s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
	.q:(ActiveFlag'="N")&(ActiveFlag'="S")
	.s myDefCardNo=$p(^DHCCARD("CF",cfrowid),"^",2)			;CF_CardNo
	.s myDefCardTypeDR=$p(^DHCCARD("CF",cfrowid),"^",16)			;
	.s myrtn=0
	
	q myrtn_"^"_myDefCardNo_"^"_myDefCardTypeDR
}

/// 根据卡号模糊查询PAPMI串
ClassMethod GetPAPMIBunchByCardNo(CardNo As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardRefInfo).GetPAPMIBunchByCardNo("000100000887")
	n (CardNo)
	s myPAPMIStr=""
	
	q:(CardNo="") myPAPMIStr
	
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	s myCFRowID=0
	f  s myCFRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo, myCFRowID)) q:(myCFRowID="")  d
	.q:($d(^DHCCARD("CF",myCFRowID))=10)
	.s myActiveFLag=$p(^DHCCARD("CF",myCFRowID),"^",10)
	.q:(myActiveFLag'="N")
	.s myPAPMIDR=$p(^DHCCARD("CF",myCFRowID),"^",4)
	.s myPAPMIStr=myPAPMIStr_"^"_myPAPMIDR
	
	q myPAPMIStr
}

/// 根据卡号和卡类型得到病人Id和登记号
ClassMethod GetPAPMIInfoByCardNo(CardNo As %String, CardType As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardRefInfo).GetPAPMIInfoByCardNo("000000000963",1)
	n (CardNo,CardType)
	s myPAPMIStr=""
	
	q:(CardNo="")||(CardType="") myPAPMIStr
	
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	s myCFRowID=0
	f  s myCFRowID=$o(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo, myCFRowID)) q:(myCFRowID="")||(myPAPMIStr'="")  d
	.s myActiveFLag=$p(^DHCCARD("CF",myCFRowID),"^",10)
	.q:(myActiveFLag'="N")
	.s PAPMIRowid=$p($g(^DHCCARD("CF",myCFRowID)),"^",4)
	.s PAPMINo=$p($g(^DHCCARD("CF",myCFRowID)),"^",6)
	.s myPAPMIStr=PAPMIRowid_"^"_PAPMINo
	/*if +myCFRowID'=0 {
		s myActiveFLag=$p(^DHCCARD("CF",myCFRowID),"^",10)
	    q:(myActiveFLag'="N")
		s PAPMIRowid=$p($g(^DHCCARD("CF",myCFRowID)),"^",4)
		s PAPMINo=$p($g(^DHCCARD("CF",myCFRowID)),"^",6)
		s myPAPMIStr=PAPMIRowid_"^"_PAPMINo
	}*/
	
	q myPAPMIStr
}

ClassMethod ReadPatValidateInfoByCardNo(CardNO As %Library.String = "", SecurityNo As %String = "", CardTypeDR As %String = "") As %String
{
	;w ##class(web.DHCBL.CARD.UCardRefInfo).ReadPatValidateInfoByCardNo("0000008118","",1)
	;通过 卡号(登记号码也为卡号码) 获取患者基本信息
	;输入卡号， 和卡类型的RowID
	
	n (CardNO, SecurityNo, CardTypeDR)
	
	q:(CardTypeDR="") ""
	
	s myRegNo="",myPapmi="",name="",myCardNo="",mySecurityNO="", myCardID=""
	
	s rtn="0"		;此卡没有对应的病人信息
	
	;获取卡类型的配置 用来检验信息初始化
	s myCardObj=##class(User.DHCCardTypeDef).%OpenId(CardTypeDR)
	
	;决定表PatMas表 Update或者Insert
	s mySearchFlag=myCardObj.CTDSearchMasFlag
	s myPreCardFlag = myCardObj.CTDPreCardFlag
	;标明此类卡是否回收
	s myReclaimFlag= myCardObj.CTDReclaimFlag
	
	d myCardObj.%Close()
	
	;1. 判断此卡号在数据表中的 状态
	;1.1同一种类型的，同一个卡号 的卡不能重复发卡
	;
		;;根据卡号查找 基本信息
		;;这种情况 是预先生成登记号或者卡号
		;;表 DHC_CardRef 中一定要有数据的 否则就会没有数据
		i CardNO'=""  d
		.s cfrowid="" f  s cfrowid=$o(^DHCCARDi("CF",0,"CardNo",CardNO,cfrowid),-1) q:(cfrowid="")!rtn  d
		..;同一种类型卡 才能比较
		..s myCardTypeDR=$p(^DHCCARD("CF",cfrowid),"^",16)		;
		..q:(CardTypeDR'=myCardTypeDR)
		..s mySecurityNO=$p(^DHCCARD("CF",cfrowid),"^",3)
		..i mySecurityNO'="" s rtn="-341"
		..;q:mySecurityNO'=""
		..s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
		..i ActiveFlag'="" s rtn="-341"
		..; 只有被回收的卡才能使用
		..i ((myReclaimFlag="Y")&(ActiveFlag="R"))  s rtn=0
		..b	;;
		..i (ActiveFlag="S")  s rtn=-351
		..i (ActiveFlag="D")  s rtn=-352
		..i ("NDSR"'[ActiveFlag) s rtn=-299
		..q:ActiveFlag'=""
		..s myCardID=cfrowid
		..s myCardNo=$p(^DHCCARD("CF",cfrowid),"^",2)
		..s myPapmi=$p(^DHCCARD("CF",cfrowid),"^",4)
		..s myRegNo=$p(^DHCCARD("CF",cfrowid),"^",6)
		..b		;
		..if ((mySearchFlag="Y")&((myPapmi="")||myRegNo="")) d
		...s rtn="-340"
		..q:myPapmi=""
		..q:myRegNo=""
		..s rtn=0
		..s name=$p(^PAPER(myPapmi,"ALL"),"^",1)
		..i name="未用" s name=""
		..s mySecurityNO=##Class(web.UDHCAccCardManage).GetCardCheckNo(myRegNo)
	
	;不检索卡， 要求强制把CardRowID = ""
	;目的是： 要Insert
	;要求：
	i ((myPreCardFlag="Y")&&(myCardID="")&&(+rtn=0)) d
	.;配置要求预先生成卡表，但是RowID=""
	.;卡的数据设置错误
	.;发卡时，配置要求更新卡记录，但是此卡数据没有预先生成
	.s rtn=-357
	
	i ((myPreCardFlag'="Y")&&(myCardID'="")&&(+rtn=0)) d
	.;不预先生成 Card表，但是已经有数据错误
	.;配置要求新增卡记录，但是此卡数据被预先生成错误
	.s rtn=-356
	b	;
	;不检索PatMas 表要求 把 PAPMI=""
	;目的是： 要Insert
	i ((+rtn=0)&&(mySearchFlag="Y")&&(myPapmi="")) d
	.;要求预先生成登记号码，但是没有生成错误
	.s rtn=-340		;此卡没有对应相应的患者信息
	
	i ((+rtn=0)&&(mySearchFlag'="Y")&&(myPapmi'="")) d
	.;此卡已经对应登记号了，不能在办理
	.s rtn=-358
	
	;s ren=rtn_"^"_myRegNo_"^"_myPapmi_"^"_name_"^"_myCardNo_"^"_mySecurityNO_"^"_myCardID
	
	s myregobj=##class(web.DHCEntity.PCA.CardPatInfoReg).%New()
	
	s myregobj.Name=$g(name)
	s myregobj.PAPMINo= $g(myRegNo)
	s myregobj.CardRowID= $g(myCardID)
	s myregobj.PAPMIRowID=$g(myPapmi)
	s myregobj.Birth= $g(myBirth)
	s myregobj.Sex = $g(mySex)
	
	d myregobj.XMLExportToString(.myXMLStr)
	
	s myrtn=rtn_"^"_myXMLStr
	
	q myrtn
}

ClassMethod SaveCardInfo(CardObj As web.DHCEntity.PCA.CardRef) As %String
{
	;保存的类： DHCCardRef 和 DHCCardStatusChange
	;5. 保存患者的卡信息到数据库
	;5.1	根据卡类型配置 保存票据信息和费用信息
	
	s $ZT="ERROR^DHCSSERR"
	n (CardObj)
	s myrtn=0
	s myCardRowID=""
	
	;CardObj.CardTypeDefine		;CTD_SecurityNoFlag
	s mySecurityFlag=$p($g(^DHCCARDTYPEDef(CardObj.CardTypeDefine)),"^", 18)		;CTD_SecurityNoFlag
	;数据转换
	s CardObj.PAPMINo = ##Class(web.PAPatMas).GetRegistration(CardObj.PAPMIRowID)
	i mySecurityFlag="Y" d
	.s CardObj.SecurityNo=##class(web.UDHCAccEnrypt).Encrypt(CardObj.SecurityNo)
	e  d
	.s CardObj.SecurityNo=""
	
	;加一步验证
	s myCardRtn=..ReadPatValidateInfoByCardNo(CardObj.CardNo, CardObj.SecurityNo, CardObj.CardTypeDefine)
	s myrtn=+$p(myCardRtn,"^",1)
	q:(+myrtn) myrtn
	
	;卡是否有效 在前面已经处理了， 此处只负责 Update 或者 Insert 保存数据
	;
	;逻辑是：  =""  标志 新增 卡记录
	;			<>""  标志 建立此卡记录的更新(部分对照关系已经手工处理完毕)
	If ((CardObj.CardRowID= "")||(CardObj.CardRowID= $c(0)))
	{
		Set cf = ##class(User.DHCCardRef).%New()
	}else{
		Set cf = ##class(User.DHCCardRef).%OpenId(CardObj.CardRowID)
	}
	
	Set cf.CFCardNo = CardObj.CardNo
	Set cf.CFSecurityNO = CardObj.SecurityNo
	If (CardObj.CardTypeDefine '= "")
	{
		d cf.CFCardTypeDRSetObjectId(CardObj.CardTypeDefine)
	}
	If (CardObj.PAPMIRowID '= "")
	{
		s cf.CFPAPMIDR = CardObj.PAPMIRowID
	}
	s cf.CFIDCardNo=CardObj.CredNo		;证件号码
	s cf.CFPAPMINo=CardObj.PAPMINo			;登记号码
	if (CardObj.CFAccNoDR'=""){
		d cf.CFAccNoDRSetObjectId(CardObj.CFAccNoDR)
	}
	s cf.CFActiveFlag=CardObj.ActiveFlag
	Set cf.CFDate = CardObj.CFDate
	Set cf.CFTime = CardObj.CFTime
	s cf.CFUserDR = CardObj.UserDR
	s cf.CFDateFrom = +$h
	i (CardObj.CardINVPRTDR'=""){
		d cf.CFCardINVPRTDRSetObjectId(CardObj.CardINVPRTDR)
	}
	s cf.CFFareType = CardObj.FareType
	//医院
	/*If (CardObj.LogonHospDR '= "")
	{
		d cf.CFCardHospDRSetObjectId(CardObj.LogonHospDR)
	}*/
	s:CardObj.TemporaryCard'="" cf.CFIsTemporaryCard=CardObj.TemporaryCard
	Set sc = cf.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-200"	;卡信息保存失败
	}
	Set myCardRowID = cf.%Id()
	
	;Create a CardStatusChange
	Set csc = ##class(User.DHCCardStatusChange).%New(myCardRowID)
	s csc.CSCCFParRef = cf
	Set csc.CSCDate = CardObj.CFDate
	Set csc.CSCTime = CardObj.CFTime
	Set csc.CSCCurStatus = CardObj.ActiveFlag
	Set csc.CSCUserDR = CardObj.UserDR
	s csc.CSCComputerIP = CardObj.ComputerIP
	//医院
	If (CardObj.LogonHospDR '= "")
	{
		d csc.CSCHospDRSetObjectId(CardObj.LogonHospDR)
	}
	Set sc = csc.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-201"	;卡状态信息保存失败
	}
	
	b	;;;Card Ref
	q myrtn_"^"_myCardRowID
}

/// 更新原来原卡中的发票指向
ClassMethod UpdateCardINVInfo(CardRowID As %String, NewINVRowID As %String) As %String
{
	q:((CardRowID="")||(NewINVRowID="")) 0
	
	s myrtn=0
	s myobj=##class(User.DHCCardRef).%OpenId(CardRowID)
	if $IsObject(myobj.CFCardINVPRTDR){
		d myobj.CFCardINVPRTDRSetObjectId(NewINVRowID)
	}else{
		s myobj.CFCardINVPRTDR=NewINVRowID
	}
	s sc=myobj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-100"	;卡状态信息保存失败
	}
	
	q myrtn
}

/// 根据卡RowID获取病人及卡信息
ClassMethod getpatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", CardID As %Library.String = "", HospId As %Library.String = "")
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	;w ##class(web.DHCBL.CARD.UCardRefInfo).getpatinfo("","",1)
	s RegNo="",Papmi="",name="",IDCardNo="",CardNo="",SecurityNO="",ActiveFlag="",DateFrom="",DateTo="",FlagName=""
 	s Balance="",CredTypeID="",CredType="",CredNo="",cardverify1="",cardverify2=""
	set RowID=CardID
	set accrowid=$p(^DHCCARD("CF",RowID),"^",1)
	set CardNo=$p(^DHCCARD("CF",RowID),"^",2)
	set SecurityNO=$p(^DHCCARD("CF",RowID),"^",3)
	s cardverify2=##class(web.UDHCAccEnrypt).Decrypt(SecurityNO)
	set Papmi=$p(^DHCCARD("CF",RowID),"^",4)
	
	
	set RegNo=$p(^DHCCARD("CF",RowID),"^",6)
 	set ActiveFlag=$p(^DHCCARD("CF",RowID),"^",10)
 	S:ActiveFlag="" ActiveFlag="N"
 	set DateFrom=$p(^DHCCARD("CF",RowID),"^",11)
 	set DateTo=$p(^DHCCARD("CF",RowID),"^",12)
 	set CardTypeDr=$p(^DHCCARD("CF",RowID),"^",16)
 	set CardTypeDesc=$p(^DHCCARDTYPEDef(CardTypeDr),"^",2)
 	//set ^ozrtest(100)="aaa1:"_RowID_"bbb:"_accrowid
 	if accrowid'=""
 	{
	 	set Balance=$p(^DHCACD("AccM",accrowid),"^",8)
	 	set AccStatus=$p(^DHCACD("AccM",accrowid),"^",13) 	
	 	set AccType=$p(^DHCACD("AccM",accrowid),"^",16)
	 	set CredTypeID=$p(^DHCACD("AccM",accrowid),"^",17)
	 	set CredNo=$p(^DHCACD("AccM",accrowid),"^",18)
	 	set IDCardNo=CredNo
	 	;set CardTypeDr=CredTypeID
 	}	
 	else
 	{
	 	set IDCardNo=$p(^PAPER(Papmi,"ALL"),"^",9)
	 	;set CardTypeDr=""
 	}
 	if (IDCardNo="") s IDCardNo=$p($g(^PAPER(Papmi,"PAT",3)),"^",6)
 	//if (CredTypeID=""){
       s CredTypeID=$p($g(^PAPER(Papmi,"PAT",3)),"^",7)
	//}
	s CredNo=$p($g(^PAPER(Papmi,"PAT",3)),"^",6)
 	s IDCardNo=$TR(IDCardNo,$char(0),"")
 	set name=$p(^PAPER(Papmi,"ALL"),"^",1)
 	
 	//set ^ozrtest(100)=IDCardNo
 	set address=$G(^PAPER(Papmi,"PER","ADD",1))

 	set phone=$p(^PAPER(Papmi,"PER",1),"^",11)
	s sexid=$p($g(^PAPER(Papmi,"ALL")),"^",7)
	s RSex=$p($g(^CT("SEX",sexid)),"^",2)
	s PatCharge=##class(web.DHCBillInterface).IGetAccMDeposit(Papmi,HospId)  
	s RBirth=..%ZD($p($g(^PAPER(Papmi,"ALL")),"^",6)) //$ZD($p($g(^PAPER(Papmi,"ALL")),"^",6),3)
 	
 	s myCardINVRowID=$p(^DHCCARD("CF",RowID),"^", 17)		;CF_CardINVPRT_DR
 	s myCardAmount=0
 	s myCardINVNo=""
 	i myCardINVRowID'="" d
 	.s myCardAmount=$p(^DHCCARDINVPRT(myCardINVRowID),"^", 3)
 	.s myCardINVNo=$p(^DHCCARDINVPRT(myCardINVRowID),"^", 7)
		
	i DateFrom'=""  s DateFrom=$zd(DateFrom,4)
 	i DateTo'=""  s DateTo=$zd(DateTo,4)
	i ((ActiveFlag="N")||(ActiveFlag="")) s FlagName="正常"
 	i ActiveFlag="S" s FlagName="挂失"
 	i ActiveFlag="D" s FlagName="作废"
 	i ActiveFlag="R" s FlagName="回收"
	s str=RegNo_"^"_Papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_cardverify2_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo_"^"_CardID_"^"_FlagName_"^"_Balance_"^"_CredNo_"^"_CredType_"^"_CredTypeID_"^"_address_"^"_phone_"^"_CardTypeDr
	b
	s str=str_"^"_myCardAmount_"^"_myCardINVNo_"^"_RSex_"^"_RBirth_"^"_CardTypeDesc_"^"_PatCharge		;JS  18  -23
	if (itmjs'=""){
		//set str="00126155^427868^史殿毅^^08888888^001261556093336941^N^30/10/2007^^855743^正常^^^^"
	 	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
	 	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
	 	&javascript<#(retval)#>
	 	q 1
 	}else{
	 	q str
	}
}

/// 修改病人基本信息时同步更新卡号的身份证号字段
/// w ##class(web.DHCBL.CARD.UCardRefInfo).UpdateDHCCardIDNo()
ClassMethod UpdateDHCCardIDNo(PatientID As %String, IDCardNO As %String, CredTypeId As %String) As %String
{
	s ret=0
	q:(PatientID="")||(IDCardNO="") ret //||(CredTypeId'=1)
	s CFRowId=0 f  s CFRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowId)) q:CFRowId=""  d
	.s CFActiveFlag=$p($g(^DHCCARD("CF",CFRowId)),"^",10)
	.Q:(CFActiveFlag'="")&&(CFActiveFlag'="N")
	.s IDCardNO=$ZConvert(IDCardNO,"U")	
	.&sql(update SQLUser.DHC_CardRef set CF_IDCardNo=:IDCardNO where CF_RowID=:CFRowId)
	.q:SQLCODE
	
	q ret
}

/// 根据证件类型获取此证件的证件号码是否必填
/// 证件类型中维护，没维护的当必填处理
/// creator:yl 20181026
/// input:证件类型id
/// output:Y：必填   其他：不必填
ClassMethod CheckCardNoRequired(CredTypeDr)
{
	s CardNoRequired="Y"
	q:CredTypeDr="" CardNoRequired
	s CardNoRequired=$p($g(^PAC("CARD",CredTypeDr,"DHC")),"^",3)
	s:CardNoRequired="" CardNoRequired="Y"
	q CardNoRequired
}

/// 判断卡类型是否开启临时卡标识
/// create 20190527 by yl
/// input:卡类型id, 卡号
/// output:Y：开启   其他：未开启
ClassMethod GetTemporaryCardFlag(CardTypeId As %String, CardNo As %String = "") As %String
{
	s ret=""
	q:(CardTypeId="") ret
	if (CardNo'="")&&(CardTypeId'="") {
		s CFRowId=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeId,CardNo,""),-1)
		if CFRowId'="" {
			s IsTemporaryCard=$p(^DHCCARD("CF",CFRowId),"^",29)
			s ret=IsTemporaryCard
		}
	}else {
		s TemporaryCardFlag=$p(^DHCCARDTYPEDef(CardTypeId),"^",38)
		s ret=TemporaryCardFlag
	}
	q ret
}

/// 获取建卡日期
/// create 20190529 by yl
/// input:卡类型id, 卡号
/// output: Date
ClassMethod GetCreateCardDate(CardTypeId As %String, CardNo As %String = "") As %String
{
	s ret=""
	q:(CardTypeId="")!(CardNo="") ret
	s CFRowId=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeId,CardNo,0))
	if CFRowId'="" {
		s CreateDate=$p(^DHCCARD("CF",CFRowId),"^",7)
		s CreateTime=$p(^DHCCARD("CF",CFRowId),"^",8)
		s ret=CreateDate_","_CreateTime
	}
	q ret
}

}
