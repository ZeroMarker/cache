/// creator:郭荣勇
/// date:2010-10-30
/// desc:上线支持类
Class web.DHCDocOnlineSupport Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// 导入,导出病人基本信息
/// 导入病人信息
/// 导入保存病人语言,证件类型,有效标志为写死部分,详见注释
/// 将导出的PatInfo.txt文件放到导入服务器的D:\根目录下
/// 导出病人信息
ClassMethod ExportPatInfo()
{
	//d ##class(web.test).ExportPatInfo()
	;n (EndPapmiNo)
	;if EndPapmiNo="" s EndPapmiNo="00000001"
	;if $l(EndPapmiNo<8) s EndPapmiNo=$e("00000000",1,8-$l(EndPapmiNo))_EndPapmiNo
	
	//set EndPAPERRowId="1791935"
	//写日志文件
	Set file=##class(%File).%New("/PatInfo.txt")
	set ExistsFlag=##class(%File).Exists("/PatInfo.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/PatInfo.txt"
	d stream.Clear()
	
	w !,"导出中..."
	set PAPERRowId=0
	;set PAPERRowId=EndPAPERRowId
	for {
		;quit:PAPERRowId>"1891935"
		set PAPERRowId=$O(^PAPER(PAPERRowId)) quit:PAPERRowId=""
		set paperdob=$p($g(^PAPER(PAPERRowId,"ALL")),"^",6)
		set papername=$p($g(^PAPER(PAPERRowId,"ALL")),"^",1)
		if (papername="未用")||(papername="无") continue
		
		set papersexdr=$p($g(^PAPER(PAPERRowId,"ALL")),"^",7)
		s papersexCode=""
		if papersexdr'="" s papersexCode=$p(^CT("SEX",papersexdr),"^",1)
		set paperuserupdate=$p($g(^PAPER(PAPERRowId,"PER",4)),"^",7)
		set paperid=$p($g(^PAPER(PAPERRowId,"ALL")),"^",9)
		set papergoverncardno=$p($g(^PAPER(PAPERRowId,"PER",4)),"^",4)
		set papersocialstatusdr=$p($g(^PAPER(PAPERRowId,"PER",1)),"^",10)
		set papersocialstatusdesc=""
		if papersocialstatusdr'="" s papersocialstatusdesc=$p(^CT("SS",papersocialstatusdr),"^",2)
		set papercountrydr=$p($g(^PAPER(PAPERRowId,"PER",1)),"^",8)
		set paperctprovincedr=$p($g(^PAPER(PAPERRowId,"PER",4)),"^",2)
		set papercitycodedr=$p($g(^PAPER(PAPERRowId,"PER",1)),"^",5)
		set paperzipdr=$p($g(^PAPER(PAPERRowId,"PER",1)),"^",7)
		set papernationdr=$p($g(^PAPER(PAPERRowId,"PER",2)),"^",1)
		set papertelh=$p($g(^PAPER(PAPERRowId,"PER",1)),"^",11)
		set papersecondphone=$p($g(^PAPER(PAPERRowId,"PER",4)),"^",18)
		set papersecondphone=$tr(papersecondphone,$C(13),"")
		set papersecondphone=$tr(papersecondphone,$C(10),"")
		set paperCompany=$g(^PAPER(PAPERRowId,"PER","ADD",1))  
		set paperCompany=$tr(paperCompany,$C(13),"")
		set paperCompany=$tr(paperCompany,$C(10),"")             
		set papmimedicare=$p($g(^PAPER(PAPERRowId,"PAT",1)),"^",22)           ;门诊病历号
		set papmimedicarecode=$p($g(^PAPER(PAPERRowId,"PAT",2)),"^",6)        ;医保号
		set PAPERStName=""
		set paperlangprimdr=$p($g(^PAPER(PAPERRowId,"ALL")),"^",10)
		set papmiopno=$p($g(^PAPER(PAPERRowId,"PAT",1)),"^",2)
		set papmiipno=$p($g(^PAPER(PAPERRowId,"PAT",1)),"^",1)
		
		s WriteStr=papername_"^"_paperdob_"^"_papersexCode_"^"_paperuserupdate_"^"_paperid_"^"_papergoverncardno
		s WriteStr=WriteStr_"^"_papersocialstatusdesc_"^"_papercountrydr_"^"_paperctprovincedr_"^"_papercitycodedr
		s WriteStr=WriteStr_"^"_paperzipdr_"^"_papernationdr_"^"_papertelh_"^"_papersecondphone_"^"_paperCompany_"^"_papmimedicare_"^"_papmimedicarecode
		s WriteStr=WriteStr_"^"_paperlangprimdr_"^"_papmiopno_"^"_papmiipno
		d stream.MoveToEnd()
		d stream.WriteLine(WriteStr)
		;d stream.SaveStream()
	}
	d stream.SaveStream()
	
	w !,"导出完成!"
}

/// 导入病人信息
ClassMethod InportPatInfo()
{
	//w ##class(web.test).InportPatInfo()
	//写日志文件
	Set file=##class(%File).%New("D:\PatInfo.txt")
	set ExistsFlag=##class(%File).Exists("D:\PatInfo.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="D:\PatInfo.txt"
	
	;KILL ^PAPER
	
	w !,"导入中..."
	
	set myrtn=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		for i=1:1:$l(line,"^") {
			Set PatList(i)=$p(line,"^",i)
		}
		TS
		set paperdob=PatList(2)                 ;出生日期
		set papername=PatList(1)                ;姓名     
		set papersexCode=PatList(3)             ;性别      按代码导
		set paperuserupdate=PatList(4)          ;更新用户
		set paperid=PatList(5)                  ;身份证
		set papergoverncardno=PatList(6)        ;住院病历号
		set papersocialstatusdesc=PatList(7)    ;病人类型  按名称导
		set papercountrydr=PatList(8)           ;国籍
		set paperctprovincedr=PatList(9)        ;所在省份
		set papercitycodedr=PatList(10)         ;所在城市
		set paperzipdr=PatList(11)              ;邮编
		set papernationdr=PatList(12)           ;名族
		set papertelh=PatList(13)               ;联系电话
		set papersecondphone=PatList(14)        ;病人住址
		set paperCompany=PatList(15)            ;工作单位        
		set papmimedicare=PatList(16)           ;门诊病历号
		set papmimedicarecode=PatList(17)       ;医保号
		set paperlangprimdr=PatList(18)         ;语言
		set papmiopno=PatList(19)
		set papmiipno=PatList(20)
		;set PAPERStName=""                      ;新系统的病人地址
		
		set PersonObj=##class(User.PAPerson).%New()
		set PersonObj.PAPERDob=paperdob
		set PersonObj.PAPERName=papername
		if papersexCode'="" {
			s papersexCode=$ZCVT(papersexCode,"U")
			if papersexCode="N" s papersexCode="0"
			s papersexdr=$o(^CT("SEX",0,"Code",papersexCode,0))
			if papersexdr'="" do PersonObj.PAPERSexDRSetObjectId(papersexdr)
		}
		if paperuserupdate'="" {
			do PersonObj.PAPERUserAddedDRSetObjectId(paperuserupdate)
			do PersonObj.PAPERUserUpdateSetObjectId(paperuserupdate)
		}
		
		set PersonObj.PAPERID=paperid
		set PersonObj.PAPERGovernCardNo=papmimedicare
		if papersocialstatusdesc'="" {
			s papersocialstatusdesc=$ZCVT(papersocialstatusdesc,"U")
			s papersocialstatusdr=$o(^CT("SS",0,"Desc",papersocialstatusdesc,0))
			if papersocialstatusdr'="" do PersonObj.PAPERSocialStatusDRSetObjectId(papersocialstatusdr)
		}
		if papercountrydr'="" do PersonObj.PAPERCountryDRSetObjectId(papercountrydr)
		if paperctprovincedr'="" do PersonObj.PAPERCTProvinceDRSetObjectId(paperctprovincedr)
		if papercitycodedr'="" do PersonObj.PAPERCityCodeDRSetObjectId(papercitycodedr)
		if paperzipdr'="" do PersonObj.PAPERZipDRSetObjectId(paperzipdr)
		if papernationdr'="" do PersonObj.PAPERNationDRSetObjectId(papernationdr)
		set PersonObj.PAPERTelH=papertelh
		d PersonObj.PAPERStName.Insert(papersecondphone)
		
		if paperlangprimdr'="" do PersonObj.PAPERLangPrimDRSetObjectId(20)   ;写死语言- -中文
		
		;日期和时间
		S PersonObj.PAPERDateAdded = ..%SysDate()
		s PersonObj.PAPERUpdateDate=..%SysDate()            ;老系统没有更新日期和时间，取当前
		s PersonObj.PAPERUpdateTime=..%SysTime()
		;特定值
		s PersonObj.PAPEREstDOB="N"	;
		s PersonObj.PAPERIncompleteRegistration="N"
		
		Set sc = PersonObj.%Save()
		If ($System.Status.IsError(sc))
		{
			tro
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
		}
		;b	;Save PaPerson
		;PatMas
		Set PAPMIRowID = PersonObj.%Id()
		If (PAPMIRowID'="")&&(myrtn=0) 
		{
			Set patmas = ##class(User.PAPatMas).%OpenId(PAPMIRowID)
			/*
			if (+myNewFlag'=0){
				s myMAXNo=0
				i $d(^PAPER(0,"CNT","I")) d
				.;s myMAXNo=^PAPER(0,"CNT","I") //最大登记号
				e  d
				.s myMAXNo=0
				;s ^PAPER(0,"CNT","I")=myMAXNo+1
				s myMAXNo=$i(^PAPER(0,"CNT","I"))
				;s myMAXNo=myMAXNo+1
				s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
				s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
				
				s patmas.PAPMINo=myMAXNo
				s patmas.PAPMIIPNo=myMAXNo
				s patmas.PAPMIOPNo=myMAXNo
			}
			*/
			;s patmas.PAPMINo=myMAXNo
			s patmas.PAPMIIPNo=papmiipno
			s patmas.PAPMIOPNo=papmiopno
			s patmas.PAPMIMedicare=papergoverncardno	;InMedicare
			s patmas.PAPMIName3=papmimedicarecode
			s patmas.PAPMISecondPhone=paperCompany
			;证件类型,此处写死,老系统只存身份证号
			if paperid'="" d patmas.PAPMICardTypeDRSetObjectId(1)
			;PatObj.CredType
			;i (PatObj.CredType'=""){
			;	d patmas.PAPMICardTypeDRSetObjectId(PatObj.CredType)
			;}
			;PAPMI_MobPhone   移动电话
			;s patmas.PAPMIMobPhone=PatObj.MobPhone
			;过敏史
			;d patmas.PAPMIAllergy.Insert(PatObj.Allergy)
			
			;证件号码  有索引
			s patmas.PAPMIDVAnumber=paperid
			;有效
			s patmas.PAPMIActive="Y"
			
			Set sc = patmas.%Save()
			If ($System.Status.IsError(sc))
			{
				TRO
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-101"
			}
			;&&(PatObj.IDCardNo1)
			;if ((+myrtn=0)){
				;s myrtn=+..UpdatePAPMSID(PAPMIRowID,paperid)
			;}
		}
		Else
		{
			Set myrtn = "-102"
		}
		if myrtn=0 {
			TC
		}else {
			TRO
		}
		
	}
	w !,"导入完成!"
	
	Q myrtn
}

/// 导入卡信息根据卡类型(单独的卡记录文本)
/// 参数:CardTypeRowId 卡类型Rowid
ClassMethod InportCardInfo(CardTypeRowId) As %String
{
	Q:CardTypeRowId="" 0
	//读文件
	Set file=##class(%File).%New("/PatInfo-Card.txt")
	set ExistsFlag=##class(%File).Exists("/PatInfo-Card.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()

	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="/PatInfo-Card.txt"
	
	;
	k ^InportPatInfoErrorLog("LOGINSU")
	
	w !,"导入中..."
	s num=0
	set papmiopno=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		for i=1:1:$l(line,"^") {
			Set List(i)=$p(line,"^",i)
		}
		;CardNo^PAPMIDR^PAPMINO^CARDTYPE^DATE^TIME^USERDR^USEFLAG
		TS
		set CardNo=List(1)
		set PAPMIDR=List(2)
		set PAPMINO=List(3)
		set CARDTYPE=List(4)
		set DATE=List(5)
		set TIME=List(6)
		set USERDR=List(7)
		set USEFLAG=List(8)
		
		;登记号补位
		i $l(PAPMINO)<8 {
			s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
			s PAPMINO=$e("0000000000",1,myPatLen-$l(PAPMINO))_PAPMINO
		}
		
		s myCardINVRowID=""
		s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
		s myCardObj.PAPMIRowID = PAPMIDR
		s myCardObj.CardINVPRTDR=""
		s myCardObj.CFAccNoDR =""
		;NP,PC,CC
		i myCardINVRowID="" d
		.s myCardObj.FareType="NP"
		e  d
		.s myCardObj.FareType="PC"
		
		s UserDR=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4("demo"),0))
		
		s myCardObj.ActiveFlag="N"		;正常状态
		s myCardObj.CredNo=$p(^PAPER(PAPMIDR,"PAT",3),"^",6)
		s myCardObj.PAPMINo=PAPMINO
		s myCardObj.CFDate=DATE
		s myCardObj.CFTime=TIME
		s myCardObj.UserDR=UserDR
		s myCardObj.CardTypeDefine=CardTypeRowId
		s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
		s myCardRowID=$p(myrtn, "^", 2)
		i +myrtn'=0 {
			s ^InportPatInfoErrorLog("LOGINSU",PAPMINO)=line
		}else{
			s num=num+1
		}
	}
	
	Q num
}

/// 根据病人记录建就诊卡记录
/// 参数:CardTypeRowId 新系统中需建立的卡类型rowid
ClassMethod AutoCreateCard(CardTypeRowId) As %String
{
	Q:CardTypeRowId="" 0
	k ^InportPatInfoErrorLog("LOGCreateCard")
	
	;创建用户,如果病人记录的PAPERUserAddedDR不存在,则取此用户
	s DefaultUserDR=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4("demo"),0))
	
	s Count=0
	s PAPMIId=0
	for {
		s PAPMIId=$O(^PAPER(PAPMIId)) q:PAPMIId=""
		s PAPMINO=$p($g(^PAPER(PAPMIId,"PAT",1)),"^",2)
		s UserAddedDR=$p($g(^PAPER(PAPMIId,"PER",5)),"^",18)
		
		s myCardINVRowID=""
		s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
		s myCardObj.PAPMIRowID = PAPMIId
		s myCardObj.CardINVPRTDR=""
		s myCardObj.CFAccNoDR =""
		;NP,PC,CC
		i myCardINVRowID="" d
		.s myCardObj.FareType="NP"
		e  d
		.s myCardObj.FareType="PC"
		
		s myCardObj.ActiveFlag="N"		;正常状态
		s myCardObj.CredNo=$p(^PAPER(PAPMIId,"PAT",3),"^",6)
		s myCardObj.PAPMINo=PAPMINO
		s myCardObj.CFDate=..%SysDate()
		s myCardObj.CFTime=..%SysTime()
		i UserAddedDR'="" {
			s myCardObj.UserDR=UserAddedDR
		}else{
			s myCardObj.UserDR=DefaultUserDR
		}
		s myCardObj.CardTypeDefine=CardTypeRowId
		s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
		s myCardRowID=$p(myrtn, "^", 2)
		i +myrtn'=0 {
			s ^InportPatInfoErrorLog("LOGCreateCard",PAPMINO)=line
		}else{
			s Count=Count+1
		}
	}
	
	Q Count
}

/// /修改身份证号码
ClassMethod UpdatePAPMSID(PAPMIRowID As %String, PAID As %String) As %String
{
	;##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PAPMIRowID, PAID)
	q:(PAPMIRowID="") 0
	
	s myPAID=$ZConvert(PAID,"U")
	
	s $p(^PAPER(PAPMIRowID,"ALL"),"^",9)=myPAID
	
	s myPAID=$ZConvert(PAID_"Z","U")
	s ^PAPERi("PAPMI_ICPPBC",myPAID,PAPMIRowID)=""
	
	q 0
}

/// 导出国家
ClassMethod ExportCountry() As %String
{
	;//d ##class(web.test).ExportCountry()
	;s CountryObj=##class(User.CTCountry)
	s count=1
	s CountryRowId=0
	for {
		s CountryRowId=$O(^CT("COU",CountryRowId)) q:CountryRowId=""
		s CTCOUCode=$p(^CT("COU",CountryRowId),"^",1)
		s CTCOUDesc=$p(^CT("COU",CountryRowId),"^",2)
		s CTCOUActive=$p(^CT("COU",CountryRowId),"^",3)
		s CTCOUDateActiveFrom=$p(^CT("COU",CountryRowId),"^",4)
		s CTCOUDateActiveTo=$p(^CT("COU",CountryRowId),"^",5)
		
		if (count<CountryRowId) {
			for i=count:1:CountryRowId {
		    	s ^TMPCTCountry(i)=""_"1^1^Y^^"_""
			}
		}
		s ^TMPCTCountry(CountryRowId)=CTCOUCode_"^"_CTCOUDesc_"^"_CTCOUActive_"^"_CTCOUDateActiveFrom_"^"_CTCOUDateActiveTo
		s count=+count+(CountryRowId-count)+1
	}
}

/// 导入国家
ClassMethod InportCountry()
{
	;//d ##class(web.test).InportCountry()
	;s CountryObj=##class(User.CTCountry)
	s CountryRowId=0
	for {
		s mytrn=0
		s CountryRowId=$O(^TMPCTCountry(CountryRowId)) q:CountryRowId=""
		
		TS
		s CountryObj=##class(User.CTCountry).%New()
		s CountryObj.CTCOUCode=$p(^TMPCTCountry(CountryRowId),"^",1)
		s CountryObj.CTCOUDesc=$p(^TMPCTCountry(CountryRowId),"^",2)
		s CountryObj.CTCOUActive=$p(^TMPCTCountry(CountryRowId),"^",3)
		s CountryObj.CTCOUDateActiveFrom=$p(^TMPCTCountry(CountryRowId),"^",4)
		s CountryObj.CTCOUDateActiveTo=$p(^TMPCTCountry(CountryRowId),"^",5)
		
		s sc=CountryObj.%Save()
		If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-101"
		}
		if mytrn=0 {
			TC
		}else {
			TRO
		}
		
		TS
		if (mytrn=0)&&($g(^TMPCTCountry(CountryRowId))="1^1^Y^^") {
			s sc=CountryObj.%Delete(CountryObj.%Id())
			If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-102"
			}
		}
		TC	
	}
	KILL ^TMPCTCountry
	
	Q
}

/// 导出名族
ClassMethod ExportNation() As %String
{
	;//d ##class(web.test).ExportNation()
	s count=1
	s RowId=0
	for {
		s RowId=$O(^CT("NAT",RowId)) q:RowId=""
		s CTNATCode=$p(^CT("NAT",RowId),"^",1)
		s CTNATDesc=$p(^CT("NAT",RowId),"^",2)
		
		if (count<RowId) {
			for i=count:1:RowId {
		    	s ^TMPCTNation(i)="1"_"^"_"1"
			}
		}
		s ^TMPCTNation(RowId)=CTNATCode_"^"_CTNATDesc
		s count=+count+(RowId-count)+1
	}
}

/// 导入名族
ClassMethod InportNation()
{
	;//w ##class(web.test).InportNation()
	;s CountryObj=##class(User.CTCountry)
	s RowId=0
	for {
		s mytrn=0
		s RowId=$O(^TMPCTNation(RowId)) q:RowId=""
		
		TS
		s Obj=##class(User.CTNation).%New()
		s Obj.CTNATCode=$p(^TMPCTNation(RowId),"^",1)
		s Obj.CTNATDesc=$p(^TMPCTNation(RowId),"^",2)
		
		s sc=Obj.%Save()
		If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-101"
		}
		if mytrn=0 {
			TC
		}else {
			TRO
		}
		
		TS
		if (mytrn=0)&&($g(^TMPCTNation(RowId))="1^1") {
			s sc=Obj.%Delete(Obj.%Id())
			If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-102"
			}
		}
		TC	
	}
	KILL ^TMPCTNation
	
	Q
}

/// 导出Region 已经处理，不导
ClassMethod ExportRegion() As %String
{
	;//w ##class(web.test).InportCountry()
	;s CountryObj=##class(User.CTCountry)
	s count=1
	s RowId=0
	for {
		s RowId=$O(^CT("RG",RowId)) q:RowId=""
		s CTRGCode=$p(^CT("RG",RowId),"^",1)
		s CTRGDesc=$p(^CT("RG",RowId),"^",2)
		s CTRGRcFlag=$p(^CT("RG",RowId),"^",3)
		s CTRGCountryDR=$p(^CT("RG",RowId),"^",4)
		
		if (count<RowId) {
			for i=count:1:RowId {
		    	s ^TMPCTRegion(i)="1^1^^1"
			}
		}
		s ^TMPCTRegion(RowId)=CTRGCode_"^"_CTRGDesc_"^"_CTRGRcFlag_"^"_CTRGCountryDR
		s count=+count+(RowId-count)+1
	}
}

/// 导入^TMPCTRegion  已经处理，不导
ClassMethod InportRegion()
{
	;//w ##class(web.test).ExportCountry()
	;s CountryObj=##class(User.CTCountry)
	s RowId=0
	for {
		s mytrn=0
		s RowId=$O(^TMPCTRegion(RowId)) q:RowId=""
		
		TS
		s Obj=##class(User.CTRegion).%New()
		s Obj.CTRGCode=$p(^TMPCTRegion(RowId),"^",1)
		s Obj.CTRGDesc=$p(^TMPCTRegion(RowId),"^",2)
		s Obj.CTRGRcFlag=$p(^TMPCTRegion(RowId),"^",3)
		if $p(^TMPCTRegion(RowId),"^",4)'="" d Obj.CTRGCountryDRSetObjectId($p(^TMPCTRegion(RowId),"^",4))
		
		s sc=Obj.%Save()
		If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-101"
		}
		if mytrn=0 {
			TC
		}else {
			TRO
		}
		
		TS
		if (mytrn=0)&&($g(^TMPCTRegion(RowId))="1^1^^1") {
			s sc=Obj.%Delete(Obj.%Id())
			If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-102"
			}
		}
		TC	
	}
	KILL ^TMPCTRegion
	
	Q
}

/// 导出省份
ClassMethod ExportProvince() As %String
{
	;//d ##class(web.test).ExportProvince()
	;s CountryObj=##class(User.CTCountry)
	s count=1
	s RowId=0
	for {
		s RowId=$O(^CT("PROV",RowId)) q:RowId=""
		s PROVCode=$p(^CT("PROV",RowId),"^",1)
		s PROVDesc=$p(^CT("PROV",RowId),"^",2)
		s PROVRegionDR=$p(^CT("PROV",RowId),"^",3)
		if (count<RowId) {
			for i=count:1:RowId {
		    	s ^TMPCTProvince(i)="1^1^1"
			}
		}
		s ^TMPCTProvince(RowId)=PROVCode_"^"_PROVDesc_"^"_PROVRegionDR
		s count=+count+(RowId-count)+1
	}
	;s RowIdStartNum=$o(^TMPCTProvince(""))
	;for i=1:1:(+RowIdStartNum-1) {
		;s ^TMPCTProvince(i)="^^"
	;}
}

/// 导入省份
ClassMethod InportProvince()
{
	;//w ##class(web.test).ExportCountry()
	;s CountryObj=##class(User.CTCountry)
	s RowId=0
	for {
		s mytrn=0
		s RowId=$O(^TMPCTProvince(RowId)) q:RowId=""
		
		TS
		s Obj=##class(User.CTProvince).%New()
		s Obj.PROVCode=$p(^TMPCTProvince(RowId),"^",1)
		s Obj.PROVDesc=$p(^TMPCTProvince(RowId),"^",2)
		if $p(^TMPCTProvince(RowId),"^",3)'="" {
			if $p(^TMPCTProvince(RowId),"^",3)=2 {
				d Obj.PROVRegionDRSetObjectId(1)
			}else{
				d Obj.PROVRegionDRSetObjectId(2)
			}
		}
		
		s sc=Obj.%Save()
		If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-101"
		}
		if mytrn=0 {
			TC
		}else {
			TRO
		}
		
		TS
		if (mytrn=0)&&($g(^TMPCTProvince(RowId))="1^1^1") {
			s sc=Obj.%Delete(Obj.%Id())
			If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-102"
			}
		}
		TC		
	}
	KILL ^TMPCTProvince
	
	Q
}

/// 导出城市
ClassMethod ExportCity() As %String
{
	;//d ##class(web.test).ExportCity()
	;s CountryObj=##class(User.CTCountry)
	s count=1
	s RowId=0
	for {
		s RowId=$O(^CT("CIT",RowId)) q:RowId=""
		s CTCITCode=$p(^CT("CIT",RowId),"^",1)
		s CTCITDesc=$p(^CT("CIT",RowId),"^",2)
		s CTCITProvinceDR=$p(^CT("CIT",RowId),"^",4)
		
		if (count<RowId) {
			for i=count:1:RowId {
		    	s ^TMPCTCity(i)="1^1^^1"
			}
		}
		s ^TMPCTCity(RowId)=CTCITCode_"^"_CTCITDesc_"^"_CTCITProvinceDR
		s count=+count+(RowId-count)+1
	}
}

/// 导入城市
ClassMethod InportCity()
{
	;//w ##class(web.test).ExportCountry()
	;s CountryObj=##class(User.CTCountry)
	s RowId=0
	for {
		s mytrn=0
		s RowId=$O(^TMPCTCity(RowId)) q:RowId=""
		
		TS
		s Obj=##class(User.CTCity).%New()
		s Obj.CTCITCode=$p(^TMPCTCity(RowId),"^",1)
		s Obj.CTCITDesc=$p(^TMPCTCity(RowId),"^",2)
		if $p(^TMPCTCity(RowId),"^",3)'="" do Obj.CTCITProvinceDRSetObjectId($p(^TMPCTCity(RowId),"^",3))
		
		s sc=Obj.%Save()
		If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-101"
		}
		if mytrn=0 {
			TC
		}else {
			TRO
		}
		
		TS
		if (mytrn=0)&&($g(^TMPCTCity(RowId))="1^1^^1") {
			s sc=Obj.%Delete(Obj.%Id())
			If ($System.Status.IsError(sc)) {
				TRO
				set mytrn="-102"
			}
		}
		TC	
	}
	KILL ^TMPCTCity
	
	Q
}

/// 更新替诊出诊记录没有AS_Date的数据
ClassMethod UpdateTestData1() As %String
{
	s count=0
	s ResRowid=0
	for {
		s ResRowid=$O(^RBAS(ResRowid))
		Q:ResRowid=""
		s ASDate=..%SysDate()
		for {
			s ASDate=$O(^RBAS(ResRowid,0,"DateSTime",ASDate))
			Q:ASDate=""
			s ASSessStartTime=0
			for {
				s ASSessStartTime=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,ASSessStartTime))
				Q:ASSessStartTime=""
				s ASChildSub=0
				for {
					s ASChildSub=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub))
					Q:ASChildSub=""
					if '$d(^RBAS(ResRowid,ASChildSub,"DHC")) continue
					s DHCASDate=$P(^RBAS(ResRowid,ASChildSub,"DHC"),"^",14)
					if DHCASDate="" {
						s TempRowId=ResRowid_"||"_ASChildSub
						TS
						&SQL(update SqlUser.DHC_RBApptSchedule set AS_Date=:ASDate where AS_RowId=:TempRowId)
						if SQLCODE {
							TRO
						}else{
							TC
							s count=count+1
						}
					}
				}
			}
		}
	}
	
	Q count
}

/// 沈阳医嘱扩展表记录是否配液的标志,更新原数据到配液中心,在院病人的核实医嘱的此标记
ClassMethod UpdatePIVAFlag() As %String
{
	s count=0
	s AdmRowid=0
	for {
		s AdmRowid=$O(^PAADMi("PAADM_Type","I",AdmRowid))
		Q:AdmRowid=""
		s VisitStatus=$P($g(^PAADM(AdmRowid)),"^",20)
		s AdmType=$P($G(^PAADM(AdmRowid)),"^",2)
		s PaadmDate=$P($G(^PAADM(AdmRowid)),"^",6)
		if VisitStatus'="A" continue
		s OrderRowid=$O(^OEORD(0,"Adm",AdmRowid,0))
		if OrderRowid="" continue
		s ItemSub=0
		for {
			s ItemSub=$O(^OEORD(OrderRowid,"I",ItemSub))
			Q:ItemSub=""
			if '$D(^OEORD(OrderRowid,"I",ItemSub,1)) continue
			;s PayStatus=$p(^OEORD(OrderRowid,"I",ItemSub,3),"^",5)
			s ItemStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ItemSub,1),"^",13)),"^",1)
			if ItemStatus'="V" continue
			s replocdesc=""
			s Itemreploc=$p(^OEORD(OrderRowid,"I",ItemSub,3),"^",6)
			if Itemreploc'="" {
				s replocdesc=$p(^CTLOC(Itemreploc),"^",2)
				i $f(replocdesc,"-")  s replocdesc=$p(replocdesc,"-",2)
			}
			if Itemreploc'="配液中心接收科室的RowId" continue   ;需要写死"配液中心"的RowId
			
			s $p(^OEORD(OrderRowid,"I",ItemSub,"DHC"),"^",16)=1
			s count=count+1
		}
		
	}
	
	Q count
}

/// 沈阳医嘱更新关联主医嘱字段
ClassMethod UpdateOEORI() As %String
{
	s count=0
	s AdmRowid=0
	for {
		s AdmRowid=$O(^PAADMi("PAADM_Type","I",AdmRowid))
		Q:AdmRowid=""
		s VisitStatus=$P($g(^PAADM(AdmRowid)),"^",20)
		s AdmType=$P($G(^PAADM(AdmRowid)),"^",2)
		s PaadmDate=$P($G(^PAADM(AdmRowid)),"^",6)
		if VisitStatus'="A" continue
		s OrderRowid=$O(^OEORD(0,"Adm",AdmRowid,0))
		if OrderRowid="" continue
		s ItemSub=0
		for {
			
			s ItemSub=$O(^OEORDi(0,"StDt",+$H+1,OrderRowid,ItemSub))
			;s ItemSub=$O(^OEORD(OrderRowid,"I",ItemSub))
			Q:ItemSub=""
			if '$D(^OEORD(OrderRowid,"I",ItemSub,1)) continue
			s ItemStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ItemSub,1),"^",13)),"^",1)
			if ItemStatus'="V" continue
			/*
			s replocdesc=""
			s Itemreploc=$p(^OEORD(OrderRowid,"I",ItemSub,3),"^",6)
			if Itemreploc'="" {
				s replocdesc=$p(^CTLOC(Itemreploc),"^",2)
				i $f(replocdesc,"-")  s replocdesc=$p(replocdesc,"-",2)
			}
			if Itemreploc'="配液中心接收科室的RowId" continue   ;需要写死"配液中心"的RowId
			
			s $p(^OEORD(OrderRowid,"I",ItemSub,"DHC"),"^",16)=1
			*/
			s SttDate=$p(^OEORD(OrderRowid,"I",ItemSub,1),"^",9)
			if SttDate'=(+$H+1) continue
			s SeqNo=$p(^OEORD(OrderRowid,"I",ItemSub,3),"^",4)
			if (SeqNo[".") {
				
			}
			
			s count=count+1
		}
		
	}
	
	Q count
}

ClassMethod GetLinkOrd(Ord, Sub, SubSeqNo) As %String
{
	n (Ord,Sub,SubSeqNo)
}

/// 兰大二院导出医嘱模板信息
/// debug: d ##class(web.DHCDocOnlineSupport).ExportOEORITemplates("ORDER","","",15)
ClassMethod ExportOEORITemplates(AppKey As %String = "", SSGroupID As %String = "", SSUserID As %String = "", CTLocID As %String = "")
{
	Set file=##class(%File).%New("C:\temp\TemplatesInfo.txt")
	set ExistsFlag=##class(%File).Exists("C:\temp\TemplatesInfo.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="C:\temp\TemplatesInfo.txt"  ;	C:\temp\TemplatesInfo.txt	/tmp/TemplatesInfo.txt
	d stream.Clear()
	
	s myid="",mydata=""
	if (SSGroupID'="") {
		;s mydata=##Class(websys.Preferences).GetData("User.SSGroup",SSGroupID,"ORDER","OEOrder.PrefTabs.EditList")
	    &sql(SELECT	ID,Data into :myid,:mydata
         FROM	websys.Preferences
         WHERE	(AppKey=:AppKey and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:SSGroupID and ObjectType = 'User.SSGroup'))
	}
	if (CTLocID'="") {
		;s mydata=##Class(websys.Preferences).GetData("User.CTLoc",CTLocID,"ORDER","OEOrder.PrefTabs.EditList")
	    &sql(SELECT	ID,Data into :myid,:mydata
         FROM	websys.Preferences
         WHERE	(AppKey=:AppKey and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:CTLocID and ObjectType = 'User.CTLoc'))
	}
	if (SSUserID'="") {
		;s mydata=##Class(websys.Preferences).GetData("User.SSUser",SSUserID,"ORDER","OEOrder.PrefTabs.EditList")
	    &sql(SELECT	ID,Data into :myid,:mydata
         FROM	websys.Preferences
         WHERE	(AppKey=:AppKey and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:SSUserID and ObjectType = 'User.SSUser'))
	}
	
	s mydatertn=""
	if mydata'="" {
		;s mydata=$List(^websys.PreferencesD(myid),3)
		;d stream.MoveToEnd()
		;d stream.WriteLine(mydata)
		;d stream.WriteLine("")
		;d stream.WriteLine("")
		s mydata=$List(mydata,3)
		s mydataLen=$ListLength(mydata)
		for i=1:1:mydataLen {
			s mydatertn=$List(mydata,i)
			d stream.MoveToEnd()
			d stream.WriteLine(mydatertn)
			d stream.WriteLine("")
			d stream.WriteLine("")
		}
	}
   
	d stream.SaveStream()
	
	q
}

}
