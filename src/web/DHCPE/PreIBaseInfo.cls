Import SQLUser

Class web.DHCPE.PreIBaseInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 219;

/// MastGlobal 's field Map, 因为有其它地方对此名字引用,不可修改各字段的名称,但可调整顺序
Parameter GlobalSpec = "PAPMINo^Name^Sex_DR^DOB^PatType_DR^Tel1^Tel2^MobilePhone^IDCard^Vocation^Position^Company^Postalcode^Address^Nation^Email^Married_DR^Blood_DR^UpdateDate^UpdateUser_DR";

/// 功能:个人基本信息修改记录
/// 创建:2018.08.31
/// 创建人:xy
Query SearchPreIBModifyRecord(SourceType As %Library.String = "", SourceID As %Library.String = "") As %Query(ROWSPEC = "User:%String,Date:%String,Time:%String,OldInfo:%String,NewInfo:%String")
{
}

ClassMethod SearchPreIBModifyRecordExecute(ByRef qHandle As %Binary, SourceType As %Library.String = "", SourceID As %Library.String = "") As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
    s ID=""
	f  s ID=$O(^User.DHCPEModifyRecordI("SourceIndex",SourceType,SourceID,ID)) q:ID=""  d
	.s obj=##class(User.DHCPEModifyRecord).%OpenId(ID)
	.s Date=obj.MRDate
	.s:Date'="" Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	.s Time=obj.MRTime
	.s:Time'="" Time=$ZT(Time)
	.s User=obj.MRUserDR.SSUSRName
	.s OldInfo=obj.MROldInfo
	.s NewInfo=obj.MRNewInfo
    .d OutPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	set Data=$lb(User,Date,Time,OldInfo,NewInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreIBModifyRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreIBModifyRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPreIBModifyRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreIBModifyRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 搜索（预登记）个人基本信息表																																																																																		个人信息编码				登记号				姓名					性别编码				性别							生日				客人类型编码					客人类型						电话号码1				电话号码2				移动电话					身份证号				职业						职位						公司						邮编						联系地址					民族					电子邮件				婚姻状况代码					婚姻状况						血型代码					血型							日期						更新人编码					更新人
Query SearchPreIBaseInfo(RegNo As %Library.String = "", PatName As %Library.String = "", PatType As %Library.String = "", PatSex As %Library.String = "", PatDOB As %Library.String = "", PatCompany As %Library.String = "", PatAddress As %Library.String = "", PatIDCard As %Library.String = "", PAPMICardType As %Library.String = "", PatMarried As %Library.String = "", CTLocID As %Library.String = "", HospID As %Library.String = "") As %Query(ROWSPEC = "PIBI_RowId:%String, PIBI_PAPMINo:%String, PIBI_Name:%String, PIBI_Sex_DR:%String, PIBI_Sex_DR_Name:%String, PIBI_DOB:%String, PIBI_PatType_DR:%String, PIBI_PatType_DR_Name:%String, PIBI_Tel1:%String, PIBI_Tel2:%String, PIBI_MobilePhone:%String, PIBI_IDCard:%String,PACCardDesc,PIBI_Vocation:%String, PIBI_Position:%String, PIBI_Company:%String, PIBI_Postalcode:%String, PIBI_Address:%String, PIBI_Nation:%String, PIBI_Email:%String, PIBI_Married_DR:%String, PIBI_Married_DR_Name:%String, PIBI_Blood_DR:%String, PIBI_Blood_DR_Name:%String, PIBI_UpdateDate:%String, PIBI_UpdateUser_DR:%String, PIBI_UpdateUser_DR_Name:%String,PIBI_Age:%String,Position")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreIBaseInfo","SearchPreIBaseInfo","","lll","","","","","","","")
ClassMethod SearchPreIBaseInfoExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", PatName As %Library.String = "", PatType As %Library.String = "", PatSex As %Library.String = "", PatDOB As %Library.String = "", PatCompany As %Library.String = "", PatAddress As %Library.String = "", PatIDCard As %Library.String = "", PAPMICardType As %Library.String = "", PatMarried As %Library.String = "", CTLocID As %Library.String = "", HospID As %Library.String = "") As %Status
{
	s ^TMP("DHCPE","SearchPreIBaseInfo")=$LB(RegNo,PatName,PatType,PatSex,PatDOB,PatCompany,PatAddress,PatIDCard,PAPMICardType,PatAddress,CTLocID,HospID)
	Set repid=$I(^CacheTemp)
	i HospID="" s HospID=%session.Get("LOGON.HOSPID")
	i CTLocID="" s CTLocID=%session.Get("LOGON.CTLOCID")
 	s ind=1
 	s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
 	s PatSex=##class(web.DHCPE.DHCPECommon).UnEscape(PatSex)
 	s PatType=##class(web.DHCPE.DHCPECommon).UnEscape(PatType)
 	
 	if ((""=RegNo) && (""=PatName) && (""=PatType) && (""=PatSex) && (""=PatDOB) && (""=PatCompany) && (""=PatAddress) && (""=PatIDCard) &&(""=PAPMICardType)&& (""=PatMarried)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	if PatDOB'="" d
 	.s PatDOB=##class(websys.Conversions).DateHtmlToLogical(PatDOB)

	If ""'=RegNo Do
	.Set RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,CTLocID)
	.Set PAPMIRowId=0
	.For  Set PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId)) Quit:PAPMIRowId=""  Do
	..Do GetBaseInfo(PAPMIRowId)
	..Quit:$g(Data)=""
	..Do PreIBaseInfoOutPut

	E  If ((""'=PatName)&((""=RegNo)&(""=PatIDCard))) Do
	.s PatNameU=$$ALPHAUP^SSUTIL4(PatName)
	.s PatNameIndex=$O(^DHCPEPreIBI(0,"Name",PatNameU),-1)
	.f  s PatNameIndex=$O(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[PatNameU)  d
	..Set PIBIRowIdIndex=0
	..For  Set PIBIRowIdIndex=$O(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIRowIdIndex)) Quit:(PIBIRowIdIndex="")  Do
	...Set PAPMINoIndex=$p(^DHCPEPreIBI(PIBIRowIdIndex),"^",1)
	...Quit:$g(PAPMINoIndex)=""
	...Set PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PAPMINoIndex,""))
	...Quit:$g(PAPMIRowId)=""
	...Do GetBaseInfo(PAPMIRowId)
	...Quit:$g(Data)=""
	...Do PreIBaseInfoOutPut

	e  If ((""'=PatIDCard)&(""=RegNo)) Do
	.Set PIBIRowIdIndex=0
	.For  Set PIBIRowIdIndex=$O(^DHCPEPreIBI(0,"IDCard",PatIDCard,PIBIRowIdIndex)) Quit:PIBIRowIdIndex=""  Do
	..Set PAPMIRowId="",PAPMINo=""
	..Set PAPMINo=$p(^DHCPEPreIBI(PIBIRowIdIndex),"^",1)
	..Quit:$g(PAPMINo)=""
	..Set PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
	..Quit:$g(PAPMIRowId)=""
	..Do GetBaseInfo(PAPMIRowId)
	..Quit:$g(Data)=""
	..Do PreIBaseInfoOutPut
	e  d
	.s PIBIRowIdIndex=0
	.f  s PIBIRowIdIndex=$O(^DHCPEPreIBI(PIBIRowIdIndex)) Quit:PIBIRowIdIndex=""  Do
	..Set PAPMIRowId="",PAPMINo=""
	..Set PAPMINo=$p(^DHCPEPreIBI(PIBIRowIdIndex),"^",1)
	..Quit:$g(PAPMINo)=""
	..Set PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
	..Quit:$g(PAPMIRowId)=""
	..Do GetBaseInfo(PAPMIRowId)
	..Quit:$g(Data)=""
	..Do PreIBaseInfoOutPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetBaseInfo(PAPMIRowId)
	
	Set Data=""
	Set id=PAPMIRowId
	Quit:$g(id)=""
	Set CurData=$g(^PAPER(PAPMIRowId,"ALL"))  
	Quit:CurData=""
	Set PAPMINo=""
	Set PAPMINo=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	If PAPMINo="" Set PAPMINo=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",2)
	Quit:$g(PAPMINo)=""
	Set PIBIRowId=$o(^DHCPEPreIBI(0,"PAPMINo",PAPMINo,""))
	Quit:$g(PIBIRowId)=""
	//PIBI_Name	姓名
	Set PIBIName=$p(CurData,"^",1)
	Quit:(""'=PatName)&('(PIBIName[PatName))
	//PIBI_Sex_DR	性别
	Set PIBISexDR=$p(CurData,"^",7)  
	If (""'=PIBISexDR)  Do  		
	.Set PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	Else  Do
	.Set PIBISexDRName=""
	//Quit:(""'=PatSex)&(PatSex'=PIBISexDRName)
	Quit:(""'=PatSex)&(PatSex'=PIBISexDR)
	//PIBI_DOB	生日
	Set PIBIDOB=$p(CurData,"^",6)       
	Quit:(""'=PatDOB)&(PIBIDOB'=PatDOB) 
	If (""'=PIBIDOB) Set PIBIDob=##class(websys.Conversions).DateLogicalToHtml(PIBIDOB)        
	If (""'=PIBIDOB) Set PIBIDOB=##class(websys.Conversions).DateLogicalToHtml(PIBIDOB)
	If (""'=PIBIDOB) d                             
	.;s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	.s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,CTLocID)
	//	PIBI_Tel1	电话号码1
	Set PIBITel1=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",6)
	//	PIBI_Tel2	电话号码2
	Set PIBITel2=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",7)
	//	PIBI_MobilePhone	移动电话
	Set PIBIMobilePhone=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",8)
	i PIBIMobilePhone="" s PIBIMobilePhone=PIBITel1
	i PIBIMobilePhone="" s PIBIMobilePhone=PIBITel2
	s PIBIMobilePhone=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIBIRowId)
	//	PIBI_IDCard	身份证号
	Set PIBIIDCard=$p(CurData,"^",9)
	S PACCardDesc="",PIBIIDCard=""
	S PACCardTypeDR=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	q:(PAPMICardType'="")&&(PACCardTypeDR'="")&&(PACCardTypeDR'=PAPMICardType)
    s PIBIIDCard=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",6)
	//	PIBI_Vocation	职业
	Set PIBIVocation=""
	//	PIBI_Position	职位
	Set PIBIPosition=""
	//	PIBI_Company	公司
	Set PIBICompany=""
	Set PIBICompany=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",12) //add by zhouli
	Quit:(""'=PatCompany)&('(PIBICompany[PatCompany))
	
	//部门
	s Position=##class(web.DHCPE.PreCommon).GetPosition("IBI",PIBIRowId)
	//	PIBI_Postalcode	邮编
	Set PIBIPostalcode=""
	//	PIBI_Address	联系地址
	Set PIBIAddress=""
	Set PIBIAddress=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",14) //add by zhouli
	Quit:(""'=PatAddress)&('(PIBIAddress[PatAddress))
	
	//PIBI_PatType_DR_ 受检人类型   add by zhouli
	Set PIBIPatTypeDR=""  
	Set PIBIPatTypeDRName="" 
	Set PIBIPatTypeDR=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",5) 
	i (""'=PIBIPatTypeDR)  d  		                //CT_SocialStatus	SS_Desc
	.s PIBIPatTypeDRName=$p($G(^CT("SS",PIBIPatTypeDR)),"^",2)
	//Quit:(""'=PatType)&(PatType'=PIBIPatTypeDRName)
	q:(""'=PatType)&(PatType'=PIBIPatTypeDR)
	//	PIBI_Nation	民族
	Set PIBINation=""
	//	PIBI_Email	电子邮件
	Set PIBIEmail=""
	//	PIBI_Married	婚姻状况
	Set PIBIMarriedDRName=""
	Set PIBIMarriedDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	If ""'=PIBIMarriedDR  Do  	//CT_Marital	CTMAR_Desc
	.Set PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	Else  Do
	.s PIBIMarriedDR=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",17)
	.If ""'=PIBIMarriedDR  Do  	//CT_Marital CTMAR_Desc
	..Set PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	.//Set PIBIMarriedDRName=""
	Quit:(""'=PatMarried)&(PatMarried'=PIBIMarriedDRName)
	//	PIBI_Blood	血型
	Set PIBIBloodDR=$p($g(^PAPER(PAPMIRowId,"PER",5)),"^",32)
	If (""'=PIBIBloodDR)  Do  		//PAC_BloodType	BLDT_Desc
	.Set PIBIBloodDRName=$p($G(^PAC("BLDT",PIBIBloodDR)),"^",2)
	Else  Do
	.Set PIBIBloodDRName=""
	//	PIBI_UpdateDate	日期
	Set PIBIUpdateDate=$p($g(^PAPER(PAPMIRowId,"PER",5)),"^",2)
	If (""'=PIBIUpdateDate) Set PIBIUpdateDate=$ZD(PIBIUpdateDate,4)
	//	PIBI_UpdateUser_DR	更新人
	Set PIBIUpdateUserDR=$p(CurData,"^",20)
	If ""'=PIBIUpdateUserDR  Do  	//SS_User	SSUSR_Name
	.Set PIBIUpdateUserDRName=$p($G(^SSU("SSUSR",PIBIUpdateUserDR)),"^",2)
	Else  Do
	.Set PIBIUpdateUserDRName="" 
	//翻译
	s PIBISexDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PIBISexDRName,"CTSEXDesc","cls")
	s PIBIPatTypeDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSocialStatus",PIBIPatTypeDRName,"SSDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
	s PIBIMarriedDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTMarital",PIBIMarriedDRName,"CTMARDesc","cls")
             //登记号    姓名   性别编码		性别	 生日	客人类型编码    客人类型	    电话号码1	电话号码2	移动电话		身份证号	职业			职位		公司			邮编		联系地址	  民族		电子邮件	婚姻状况代码		婚姻状况	   血型代码		  血型				日期			更新人编码		更新人	
    Set Data=$lb($g(PIBIRowId),PAPMINo,PIBIName,PIBISexDR,PIBISexDRName,PIBIDOB,PIBIPatTypeDR,PIBIPatTypeDRName, PIBITel1, PIBITel2, PIBIMobilePhone, PIBIIDCard,PACCardDesc, PIBIVocation, PIBIPosition, PIBICompany, PIBIPostalcode, PIBIAddress, PIBINation, PIBIEmail, PIBIMarriedDR, PIBIMarriedDRName, PIBIBloodDR, PIBIBloodDRName, PIBIUpdateDate, PIBIUpdateUserDR, PIBIUpdateUserDRName,TAge,Position)
	q
PreIBaseInfoOutPut

 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreIBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreIBaseInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPreIBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreIBaseInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
// ///////////////////////////////////////////////////////////////////

// ///////////////////////////////////////////////////////////////////

/// 由HIS生成登记号,牵涉HIS PA_PatMas
/// 保存数据
/// 
ClassMethod IHISSave(HISRowId As %String, RowId As %String, PAPMINo As %String, Name As %String, SexDR As %String, DOB As %String, PatTypeDR As %String, Tel1 As %String, Tel2 As %String, MobilePhone As %String, IDCard As %String, Vocation As %String, Position As %String, Company As %String, Postalcode As %String, Address As %String, Nation As %String, Email As %String, MarriedDR As %String, BloodDR As %String, UpdateDate As %String, UpdateUserDR As %String)
{

	TSTART
	// 更新 PA_PatMas 表
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace            
	Set LABDATA=Config.LabDataNamespace         
	Set CurrentNS=$ZNSPACE                     
	ZN MEDDATA
	//									IDrowid			Namepar	SexDr	Birthpar	IDCardNo1	OpMedicare	PatTypeDr	TelNopar	Company
	//									1 PAPMI_RowId	2 姓名	3 性别	4 生日		5 身份证		6			7			8			9
	d UpdatePatInfo^DHCOPUpdatePatInfo(HISRowId,		Name,SexDR,	DOB,		IDCard,		"",			"",			"",			Company)
	s ReturnFlag=SQLCODE
	ZN CurrentNS
	
	// 更新 DHC_PE_PreIBaseInfo 
	i ("0"'=ReturnFlag) goto IHISSaveErr
	i ""=RowId d
	.s iSucc=..Insert(RowId, PAPMINo, Name, SexDR, DOB, PatTypeDR, Tel1, Tel2, MobilePhone, IDCard, Vocation, Position, Company, Postalcode, Address, Nation, Email, MarriedDR, BloodDR, UpdateDate, UpdateUserDR)
	.s ReturnFlag=""_iSucc
	.i ("0"'=iSucc) goto IHISSaveErr
	.s ReturnFlag=ReturnFlag_"^"_%ROWID
	e  d
	.s ReturnFlag=..Update(RowId, PAPMINo, Name, SexDR, DOB, PatTypeDR, Tel1, Tel2, MobilePhone, IDCard, Vocation, Position, Company, Postalcode, Address, Nation, Email, MarriedDR, BloodDR, UpdateDate, UpdateUserDR)
	.i ("0"'=ReturnFlag) goto IHISSaveErr
	TCOMMIT
	Q ReturnFlag
IHISSaveErr
	TROLLBACK
	q ReturnFlag
}

/// 由HIS生成登记号,牵涉HIS PA_PatMas
/// 保存数据
/// 
ClassMethod IHISSave2(HISRowId As %String)
{
	
	TSTART
	// 更新 PA_PatMas 表
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace            
	Set LABDATA=Config.LabDataNamespace         
	Set CurrentNS=$ZNSPACE                     
	ZN MEDDATA
	//									IDrowid			Namepar	SexDr	Birthpar	IDCardNo1	OpMedicare	PatTypeDr	TelNopar	Company
	//									1 PAPMI_RowId	2 姓名	3 性别	4 生日		5 身份证		6			7			8			9
	d UpdatePatInfo^DHCOPUpdatePatInfo(HISRowId,		Name,SexDR,	DOB,		IDCard,		"",			"",			"",			Company)
	s ReturnFlag=SQLCODE
	ZN CurrentNS
	
	// 更新 DHC_PE_PreIBaseInfo 
	i ("0"'=ReturnFlag) goto IHISSaveErr2
	i ""=RowId d
	.s iSucc=..Insert2()
	.s ReturnFlag=""_iSucc
	.i ("0"'=iSucc) goto IHISSaveErr2
	.s ReturnFlag=ReturnFlag_"^"_%ROWID
	e  d
	.s ReturnFlag=..Update2()
	.i ("0"'=ReturnFlag) goto IHISSaveErr2
	TCOMMIT
	Q ReturnFlag
IHISSaveErr2
	TROLLBACK
	q ReturnFlag
}

/// 自动生成登记号,不牵涉HIS的操作
/// 保存数据
/// 
ClassMethod IPreSave(RowId As %String, PAPMINo As %String, Name As %String, SexDR As %String, DOB As %String, PatTypeDR As %String, Tel1 As %String, Tel2 As %String, MobilePhone As %String, IDCard As %String, Vocation As %String, Position As %String, Company As %String, Postalcode As %String, Address As %String, Nation As %String, Email As %String, MarriedDR As %String, BloodDR As %String, UpdateDate As %String, UpdateUserDR As %String)
{
	i ""=RowId d
	.s PAPMINo=..GetMaxRegNo()
	.s ReturnFlag=..Insert(RowId, PAPMINo, Name, SexDR, DOB, PatTypeDR, Tel1, Tel2, MobilePhone, IDCard, Vocation, Position, Company, Postalcode, Address, Nation, Email, MarriedDR, BloodDR, UpdateDate, UpdateUserDR)
	.s ReturnFlag=ReturnFlag_"^"_%ROWID
	e  d
	.s ReturnFlag=..Update(RowId, PAPMINo, Name, SexDR, DOB, PatTypeDR, Tel1, Tel2, MobilePhone, IDCard, Vocation, Position, Company, Postalcode, Address, Nation, Email, MarriedDR, BloodDR, UpdateDate, UpdateUserDR)
	q ReturnFlag
}

/// 自动生成登记号,不牵涉HIS的操作
/// 保存数据
/// 
ClassMethod IPreSave2()
{
	i ""=RowId d
	.s PLIST(2)=..GetMaxRegNo()
	.s ReturnFlag=..Insert2()
	e  d
	.s ReturnFlag=..Update2()
	q ReturnFlag
}

/// 更新
ClassMethod Update(RowId As %String, PAPMINo As %String, Name As %String, SexDR As %String, DOB As %String, PatTypeDR As %String, Tel1 As %String, Tel2 As %String, MobilePhone As %String, IDCard As %String, Vocation As %String, Position As %String, Company As %String, Postalcode As %String, Address As %String, Nation As %String, Email As %String, MarriedDR As %String, BloodDR As %String, UpdateDate As %String, UpdateUserDR As %String)
{
	//不容许修改 登记号

	&sql(update DHC_PE_PreIBaseInfo
	    set  PIBI_Name = :Name
			,PIBI_Sex_DR = :SexDR
			,PIBI_DOB = :DOB
			,PIBI_PatType_DR = :PatTypeDR
			,PIBI_Tel1 = :Tel1
			,PIBI_Tel2 = :Tel2
			,PIBI_MobilePhone = :MobilePhone
			,PIBI_IDCard = :IDCard
			,PIBI_Vocation = :Vocation
			,PIBI_Position = :Position
			,PIBI_Company = :Company
			,PIBI_Postalcode = :Postalcode
			,PIBI_Address = :Address
			,PIBI_Nation = :Nation
			,PIBI_Email = :Email
			,PIBI_Married_DR = :MarriedDR
			,PIBI_Blood_DR = :BloodDR
			,PIBI_UpdateDate = :UpdateDate
			,PIBI_UpdateUser_DR = :UpdateUserDR
	     where PIBI_RowId = :RowId
	     )
	 q SQLCODE
}

/// 取得当前最大的登记号	
/// 前提：登记号全部由系统生成	
/// 规则：当前表中没有记录，生成 00000001 否则，最大登记号(最大 RowId记录的登记号)加一
/// s RegNo=##class(web.DHCPE.PreIBaseInfo).GetMaxRegNo()
ClassMethod GetMaxRegNo()
{
	// 获取当前登记号
	i 1=$D(^DHCPESetting("DHCPE","PatNO_CurNo")) d
	.s CurNo=+$G(^DHCPESetting("DHCPE","PatNO_CurNo"))
	e  d
	.s CurNo=+$G(^DHCPESetting("DHCPE","PatNO_Begin"))
	.
	
	// 登记号超出范围
	i (+$G(^DHCPESetting("DHCPE","PatNO_End")))<(+CurNo) d
	.
	.	
	
	// 更新当前登记号
	lock ^DHCPESetting("DHCPE","PatNO_CurNo")
	s ^DHCPESetting("DHCPE","PatNO_CurNo")=+CurNo+1
	lock -^DHCPESetting("DHCPE","PatNO_CurNo")
	
	// 格式化登记号
	s CurNo=$Extract("00000000",1,8-$LENGTH(CurNo))_CurNo
	q CurNo
}

/// 插入
ClassMethod Insert(RowId As %String, PAPMINo As %String, Name As %String, SexDR As %String, DOB As %String, PatTypeDR As %String, Tel1 As %String, Tel2 As %String, MobilePhone As %String, IDCard As %String, Vocation As %String, Position As %String, Company As %String, Postalcode As %String, Address As %String, Nation As %String, Email As %String, MarriedDR As %String, BloodDR As %String, UpdateDate As %String, UpdateUserDR As %String)
{
	&sql(insert into DHC_PE_PreIBaseInfo(PIBI_PAPMINo, PIBI_Name, PIBI_Sex_DR, PIBI_DOB, PIBI_PatType_DR, PIBI_Tel1, PIBI_Tel2, PIBI_MobilePhone, PIBI_IDCard, PIBI_Vocation, PIBI_Position, PIBI_Company, PIBI_Postalcode, PIBI_Address, PIBI_Nation, PIBI_Email, PIBI_Married_DR, PIBI_Blood_DR, PIBI_UpdateDate, PIBI_UpdateUser_DR)
	     values (:PAPMINo, :Name, :SexDR, :DOB, :PatTypeDR, :Tel1, :Tel2, :MobilePhone, :IDCard, :Vocation, :Position, :Company, :Postalcode, :Address, :Nation, :Email, :MarriedDR, :BloodDR, :UpdateDate, :UpdateUserDR)
	     )
	q SQLCODE(sn)
}

/// 使用 PLIST 插入
ClassMethod Insert2()
{
	k PLIST(1) // PIBI_RowId
	&SQL(Insert Into SQLUSER.DHC_PE_PreIBaseInfo Values :PLIST())
	i "0"=SQLCODE d
	.s ret=SQLCODE_"^"_%ROWID
	e  d
	.s ret=SQLCODE_"^"_""
	q ret
}

ClassMethod Update2()
{
	s RowId=PLIST(1)
	k PLIST(1)	// PIBI_RowId
	k PLIST(2)	// PIBI_PAPMINo
	&SQL(Update SQLUSER.DHC_PE_PreIBaseInfo Values :PLIST() 
		where PIBI_RowId = :RowId)
	Q SQLCODE_"^"_RowId
}
*/
/// 根据指定条件 获取个人信息  使用：个人登记(HDCPEPreIADM)
/// 使用组件：DHCPEPreIADM.Team
/// test: w ##Class(web.DHCPE.PreIBaseInfo).GetPreIBaseInfo("^00000038^^")
ClassMethod GetPreIBaseInfo(InString As %Library.String = "")
{
    /*
	s id=$P($g(InString),"^",1)
	s RegNo=$p($g(InString),"^",2)
	s Name=$p($g(InString),"^",3)
	Set IDCard=$p($g(InString),"^",4)
	*/
	s InStringOne=$p($g(InString),"$",1)
	s id=$P($g(InStringOne),"^",1)
	s RegNo=$p($g(InStringOne),"^",2)
	s Name=$p($g(InStringOne),"^",3)
	S IDCard=$p($g(InStringOne),"^",4)
    s CardTypeDR=$p($g(InString),"$",2)
     s HospID=$p($g(InString),"$",3)

	s CurData=""
	s Age=""
	i (""'=id) s CurData=$g(^DHCPEPreIBI(id))
	
	i (""'=RegNo)&&(""=CurData)  d
	.s id="0"
	.s id=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,id))
	.i ""'=id s CurData=$g(^DHCPEPreIBI(id))
	
	
	i (""=RegNo)&&(""'=Name)&&(""=CurData)  d
	.s id="0"
	.s id=$O(^DHCPEPreIBI(0,"Name",Name,id))
	.i ""'=id s CurData=$g(^DHCPEPreIBI(id))
	//Add By MLH 20071213 新增身份证查询
	If (""=RegNo)&&(""'=IDCard)&&(""=CurData) Do
	.Set id="0"
	.Set id=$O(^DHCPEPreIBI(0,"IDCard",IDCard,id))
	.If ""'=id d
	..s CurData=$g(^DHCPEPreIBI(id))
	
	
	
	//////////////////////////////////
	i (""'=CurData) d
	.
	.//	PIBI_PAPMINo	登记号
	.s PIBIPAPMINo=$p(CurData,"^",1)
	.s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,"")) 
	.//	PIBI_Name	姓名
	.S PIBIName=$p(CurData,"^",2)
	.
	.//	PIBI_Sex_DR	性别
		.// PIBI_Sex_DR 性别
	.I PAPMIRowId'="" d
	..s PIBISexDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7)
	.e  s PIBISexDR=$p(CurData,"^",3)
	.i (""'=PIBISexDR)  d  		//CT_Sex	CTSEX_Desc
	..s PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	.e  d
	..s PIBISexDRName=""
	.
	.//	PIBI_DOB	生日
	.s PIBIDOB=$p(CurData,"^",4)
	.
	.;i PIBIDOB'="" s Age=##class(web.DHCDocCommon).GetAgeDescNew($zd(PIBIDOB,3),"")
	.//i PIBIDOB'="" s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$H)
	.i PIBIDOB'="" d
	..;s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	..s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID)
	.i (""'=PIBIDOB) s PIBIDOB=##class(websys.Conversions).DateLogicalToHtml(PIBIDOB)
	.
	.//	PIBI_PatType_DR	客人类型
	.I PAPMIRowId'="" d
	..s PIBIPatTypeDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
	.e  s PIBIPatTypeDR=$p(CurData,"^",5)
	.i (""'=PIBIPatTypeDR)  d  		//CT_SocialStatus	SS_Desc
	..s PIBIPatTypeDRName=$p($G(^CT("SS",PIBIPatTypeDR)),"^",2)
	.e  d
	..s PIBIPatTypeDRName=""
	.	
	.//	PIBI_Tel1	电话号码1
	.S PIBITel1=$p(CurData,"^",6)
	.
	.//	PIBI_Tel2	电话号码2
	.s PIBITel2=$p(CurData,"^",7)
	.
	.//	PIBI_MobilePhone	移动电话
	.s PIBIMobilePhone=$p(CurData,"^",8)
	.
	.//	PIBI_IDCard	身份证号
	.s PIBIIDCard=$p(CurData,"^",9)
	.
	.//	PIBI_Vocation	职业
	.s PIBIVocation=$p(CurData,"^",10)
	.
	.//	PIBI_Position	职位
	.s PIBIPosition=$p(CurData,"^",11)
	.
	.//	PIBI_Company	公司
	.s PIBICompany=$p(CurData,"^",12)
	.
	.//	PIBI_Postalcode	邮编
	.s PIBIPostalcode=$p(CurData,"^",13)
	.
	.//	PIBI_Address	联系地址
	.s PIBIAddress=$p(CurData,"^",14)
	.
	.//	PIBI_Nation_DR	民族
	.s PIBINationDR="",PIBINationDesc=""
	.i PAPMIRowId'="" d
	..S PIBINationDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
    .e  s PIBINationDR=$p(CurData,"^",15)
    .i PIBINationDR'="" s PIBINationDesc=$p($g(^CT("NAT",PIBINationDR)),"^",2)

	.
	.//	PIBI_Email	电子邮件
	.s PIBIEmail=$p(CurData,"^",16)
	.
	.//	PIBI_Married_DR	婚姻状况
	.I PAPMIRowId'="" d
	..s PIBIMarriedDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	.e  s PIBIMarriedDR=$p(CurData,"^",17)
	.i ""'=PIBIMarriedDR  d  	//CT_Marital	CTMAR_Desc
	..s PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	.e  d
	..s PIBIMarriedDRName=""
	.
	.//	PIBI_Blood_DR	血型
	.s PIBIBloodDR=$p(CurData,"^",18)
	.i (""'=PIBIBloodDR)  d  		//PAC_BloodType	BLDT_Desc
	..s PIBIBloodDRName=$p($G(^PAC("BLDT",PIBIBloodDR)),"^",2)
	.e  d
	..s PIBIBloodDRName=""
	.
	.//	PIBI_UpdateDate	日期
	.s PIBIUpdateDate=$p(CurData,"^",19)
	.i (""'=PIBIUpdateDate) s PIBIUpdateDate=##class(websys.Conversions).DateLogicalToHtml(PIBIUpdateDate)
	.
	.//	PIBI_UpdateUser_DR	更新人
	.s PIBIUpdateUserDR=$p(CurData,"^",20)
	.i ""'=PIBIUpdateUserDR  d  	//SS_User	SSUSR_Name
	..s PIBIUpdateUserDRName=$p($G(^SSU("SSUSR",PIBIUpdateUserDR)),"^",2)
	.e  d
	..s PIBIUpdateUserDRName=""
	.s HPNo=$G(^DHCPETempHPNo(PIBIPAPMINo))
	.s PAPMIRowId=""
	.s PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,PAPMIRowId))
	.s HCPDR=""
	.i PAPMIRowId'="" s HCPDR=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",17) 
	.s HCADR=""
	.i PAPMIRowId'="" s HCADR=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",3)
	.s (HCRDR,HCADesc)=""
	.i HCADR'="" d
	..s HCADesc=$P($G(^CT("HCA",HCADR)),"^",2)
	..s HCRDR=$P($G(^CT("HCA",HCADR)),"^",3)
	.;s CardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(PAPMIRowId, "P")
	.s CardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(PAPMIRowId_"$"_CardTypeDR, "P")
	.s PAPMICardTypeDR=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",7) //证件类型
	.s PAPMICardType=""
	.i PAPMICardTypeDR'="" s PAPMICardType=$P($G(^PAC("CARD",PAPMICardTypeDR)),"^",2)
	.;s VIPLevel=$g(^DHCPECBVIPLevel("PIBI",PIBIPAPMINo))
	.s VIPLevel=""
	.s:$d(%session) UserID=%session.Get("LOGON.USERID")
	.s:VIPLevel="" VIPLevel=$G(^DHCPEDataEx("DefaultVIPLevel",UserID))
	.;s:VIPLevel="" VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
	.s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	.s:VIPLevel="" VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID) //获取科室默认的VIP等级
	.s MedicareCode=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",12)
	.S SpecialType=$g(^DHCPECBSpecial("PIBI",PIBIPAPMINo)) //特殊客户类型
	.//		0			登记号 1			姓名 2		性别编码 3		性别 3.1			生日 4		客人类型编码 5		 客人类型 5.1				电话号码1 6	电话号码2 7		移动电话 8		身份证号 9		职业 10				职位 11			公司 12				邮编 13			联系地址 14		民族 15		电子邮件 16		婚姻状况 17				17.1			血型 18			18.1				日期 19				更新人编码 20				更新人 20.1  体检号   年龄    健康区域
	.s Data=$g(id)_"^"_PIBIPAPMINo_"^"_PIBIName_"^"_PIBISexDR_"^"_PIBISexDRName_"^"_PIBIDOB_"^"_PIBIPatTypeDR_"^"_PIBIPatTypeDRName_"^"_PIBITel1_"^"_PIBITel2_"^"_PIBIMobilePhone_"^"_PIBIIDCard_"^"_PIBIVocation_"^"_PIBIPosition_"^"_PIBICompany_"^"_PIBIPostalcode_"^"_PIBIAddress_"^"_PIBINationDesc_"^"_PIBIEmail_"^"_PIBIMarriedDR_"^"_PIBIMarriedDRName_"^"_PIBIBloodDR_"^"_PIBIBloodDRName_"^"_PIBIUpdateDate_"^"_PIBIUpdateUserDR_"^"_PIBIUpdateUserDRName_"^"_HPNo_"^"_Age_"^"_HCPDR_"^"_HCRDR_"^"_HCADR_"^"_HCADesc_"^"_CardNo_"^"_VIPLevel_"^"_MedicareCode_"^"_PAPMICardTypeDR_"^"_PAPMICardType_"^"_PIBINationDR_"^"_SpecialType
	e  d
	.s HisInfo=..GetHISIBaseInfo("","",InString)
	.i HisInfo="" d
	..s Data="0"_"^"_RegNo_"^"_"未找到记录"
	.e  d
	..s Data=";"_HisInfo
	Q Data
}

// w ##class(web.DHCPE.PreIBaseInfo).DocListBroker("","",^0000100137^)

ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ModelType=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
	// 标本号在登记时获取 只在体检系统里查找客户信息
	i "NoGen"=ModelType {
		s Data=""
		i (""'=InString) s Data=..GetPreIBaseInfo(InString)
		i ""'=itmjs d
		.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
		.&javascript<#(retval)#>
		q Data
	}
	
	// 事先生成登记号 如果在体检系统里没有客户信息，则向HIS查找
	i "Gen"=ModelType {
		q ..HISDocListBroker(itmjs,itmjsex,InString)
	}
	i "FreeCreate"=ModelType {
		s Data=""
		i (""'=InString) s Data=..GetPreIBaseInfo(InString)
		i ""'=itmjs d
		.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
		.&javascript<#(retval)#>
		q Data
	}
}

/// Description: 输入登记号 从HIS获取患者信息
/// Debug:  w ##class(web.DHCPE.PreIBaseInfo).GetHISIBaseInfo("","","017")
ClassMethod GetHISIBaseInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", UpdatePEInfoFlag As %String = "0")
{
	//s id=$P($g(InString),"^",1)
	//s RegNo=$p($g(InString),"^",2)
	//s Name=$p($g(InString),"^",3)
	//s IDCard=$p($g(InString),"^",4)
	s InStringOne=$p($g(InString),"$",1)
	s RegNo=$p($g(InStringOne),"^",2)
	s Name=$p($g(InStringOne),"^",3)
	S IDCard=$p($g(InStringOne),"^",4)
    s CardTypeDR=$p($g(InString),"$",2)
	s HospID=$p($g(InString),"$",3)
	s LocID=$p($g(InString),"$",4)
	s UserID=$p($g(InString),"$",5)
	s:$D(%session) UserID = %session.Get("LOGON.USERID")

	Q:(""=RegNo)&&(IDCard="") ""
	s PAPMIRowId=""
	i RegNo'="" d
	.s PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId))
	e  i IDCard'="" d
	.s PAPMIRowId=$O(^PAPERi("PAPMI_ICPPBC",IDCard_"Z",PAPMIRowId))
	//S:(""=PAPMIRowId) Data="^"_RegNo_"^"_"无此记录"
	Q:(""=PAPMIRowId) ""

    
    // 登记号 PA_PatMas.{PAPMI_IPNo}
    //s PAPMIIPNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)

    // 患者姓名 PA_PatMas.{PAPMI_Name}
    s PAPMIName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
    s RegNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
    // 性别 PA_PatMas.{PAPMI_Sex_DR}(CT_Sex)
    s PAPMISexDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7)
    
    i ((PAPMISexDR="")&&(UpdatePEInfoFlag="0")) s PAPMISexDR=$p($g(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",2)
    
    i (""'=PAPMISexDR)  d  		
	.s PAPMISexDRName=$p($G(^CT("SEX",PAPMISexDR)),"^",2)
	e  d
	.s PAPMISexDRName=""
	
	// 身份证号 PA_PatMas.{PAPMI_ID}
	S PACCardDesc="",PAPMIID=""
	S PACCardTypeDR=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	s PAPMIID=""
	s PAPMIID=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",6)
	//s PAPMIID=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",6)
	// 身份证号 PA_PatMas.{PAPMI_ID}
	//i PAPMIID="" s PAPMIID=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
    // 生日 PA_PatMas.{PAPMI_DOB}
	s PAPMIDOB=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	s Age=""
	//i PAPMIDOB'="" s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPMIDOB,+$H)
	//i PAPMIDOB'="" s Age=##class(web.DHCDocCommon).GetAgeDescNew($zd(PAPMIDOB,3),"")
	i ((PAPMIDOB'="")&&(UpdatePEInfoFlag="0")) d
	.;s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	.s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,LocID)
	i (""'=PAPMIDOB) s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)	
	
	
	
	//移动电话 PA_Person.{PAPER_TelH}
	s PAPERTelH=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
    
    
    //地址 PA_PatMas.{PAPMI_secondphone}	(公司)
	s PAPMIsecondphone=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)
	
	// 客户类型  PA_Person.{PAPER_SocialStatus_DR}
	s PAPERSocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
	// 客户类型  CT_SocialStatus.{SS_Desc}
	
	
	//i PAPERSocialStatusDR="" s PAPERSocialStatusDR=+$g(^DHCPESetting("DHCPE","DefPatientType"))
	
	
	s PAPERSocialStatusDRName="" 
	s:(""'=PAPERSocialStatusDR) PAPERSocialStatusDRName=$p($g(^CT("SS",PAPERSocialStatusDR)),"^",2)
	
	// 单位 PA_Person.{ PAPER_StName }
	s PAPERStName=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
	
	// 民族 PA_Person.{ PAPER_Nation_DR }
	s PAPERNationDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
	// 民族 CT_Nation.{ CTNAT_Desc }
	s PAPERNationDRName=""
	s:(""'=PAPERNationDR) PAPERNationDRName=$p($g(^CT("NAT",PAPERNationDR)),"^",2)
	
	// 婚姻状况 PA_Person.{ PAPER_Marital_DR }
	s PAPERMaritalDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	// 婚姻状况 CT_Marital.{ CTMAR_Desc }
	s PAPERMaritalDRName=""
	s:(""'=PAPERMaritalDR) PAPERMaritalDRName=$p($g(^CT("MAR",PAPERMaritalDR)),"^",2)
	
	// 邮编 PA_Person.{ PAPER_Zip_DR }
	s PAPERZipDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",7)
	// 邮编 CT_Zip.{ CTZIP_Code }
	s PAPERZipDRName=""
	s:(""'=PAPERZipDR) PAPERZipDRName=$p($g(^CT("ZIP",PAPERZipDR)),"^",1)
	
	// 电子邮件 PA_Person.{ PAPER_Email }
	s PAPEREmail=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",19)
	
	// 血型 PA_Person.{ PAPER_BloodType_DR }
	s PAPERBloodTypeDR=$p($g(^PAPER(PAPMIRowId,"PER",5)),"^",32)
	// 血型 PAC_BloodType.{ BLDT_Desc }
	s PAPERBloodTypeDRName=""
	s:(""'=PAPERBloodTypeDR) PAPERBloodTypeDRName=$p($g(^PAC("BLDT",PAPERBloodTypeDR)),"^",2)
	/*
	// 职业 PA_PatMas.{ PAPMI_PatCategory_DR }
	s PAPMIPatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8)
	// 职业  PAC_PatientCategory.{ PCAT_Desc }
	s PAPMIPatCategoryDRName=""
	s:(""'=PAPMIPatCategoryDR) PAPMIPatCategoryDRName=$p($g(^PAC("PCAT",PAPMIPatCategoryDR)),"^",2)
	*/
	// 职业 PA_Person.{ PAPER_Occupation_DR }
	s PAPMIPatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",6)
	// 职业 CT_Occupation.{CTOCC_Desc}
	s PAPMIPatCategoryDRName=""
	s:(""'=PAPMIPatCategoryDR) PAPMIPatCategoryDRName=$p($g(^CT("OCC",PAPMIPatCategoryDR)),"^",2)


	// 家庭电话
    //s hometel=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
	
	//工作电话
    //s worktel=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",9)
	
	// 手机 PA_PatMas.{PAPMI_MobPhone}
	s PAPMIMobPhone=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",21)  
	s HCPDR=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",17)
	s HCADR=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",3)
	s (HCRDR,HCADesc)=""
	i HCADR'="" d
	.s HCADesc=$P($G(^CT("HCA",HCADR)),"^",2)
	.s HCRDR=$P($G(^CT("HCA",HCADR)),"^",3)
	
	s CardNo=""
	i (UpdatePEInfoFlag="0") s CardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(PAPMIRowId_"$"_CardTypeDR,"P",LocID)
	
	s VIPLevel=""
	i (UpdatePEInfoFlag="0") s VIPLevel=##class(web.DHCPE.HISUICommon).GetVIP(UserID,LocID)
	/*
	s:$d(%session) UserID=%session.Get("LOGON.USERID")
	s:VIPLevel="" VIPLevel=$G(^DHCPEDataEx("DefaultVIPLevel",UserID))
    i VIPLevel="" d
	.s VIPID=0
	.f  s VIPID=$o(^DHCPEVIPLevel("VIP",VIPID)) q:VIPID=""  d
	..s IsUse=$p(^DHCPEVIPLevel("VIP",VIPID),"^",4)
	..q:IsUse="N"
	..s IsApprove=$p(^DHCPEVIPLevel("VIP",VIPID),"^",5)
	..q:IsApprove="N"
	..s VIPLevel=VIPID
	*/
	s MedicareCode=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",12)
	//			0				登记号 1		姓名 2		性别编码 3			性别 3.1		生日 4			客人类型编码 5		 	客人类型 5.1				电话号码1 6		电话号码2 7			移动电话 8			身份证号 9			职业 10						职位 11			公司 12				邮编 13			联系地址 14				民族 15				电子邮件 16			婚姻状况 17				17.1				血型 18			18.1						日期 19				更新人编码 20				更新人 20.1
	//s Data=$g(id)		_"^"_PIBIPAPMINo_"^"_PIBIName	_"^"_PIBISexDR	_"^"_PIBISexDRName	_"^"_PIBIDOB	_"^"_PIBIPatTypeDR	_"^"_	PIBIPatTypeDRName		_"^"_PIBITel1	_"^"_PIBITel2	_"^"_PIBIMobilePhone	_"^"_PIBIIDCard	_"^"_PIBIVocation			_"^"_PIBIPosition_"^"_PIBICompany	 _"^"_PIBIPostalcode_"^"_PIBIAddress     _"^"_PIBINation		_"^"_PIBIEmail	_"^"_PIBIMarriedDR	_"^"_PIBIMarriedDRName	_"^"_PIBIBloodDR	_"^"_PIBIBloodDRName		_"^"_PIBIUpdateDate	_"^"_PIBIUpdateUserDR	_"^"_PIBIUpdateUserDRName_"^"_HPNO_"^"_Age_"^"_HCPDR_"^"_HCRDR_"^"_HCADR_"^"_HCADesc
	s Data=PAPMIRowId	_"^"_RegNo		_"^"_PAPMIName	_"^"_PAPMISexDR	_"^"_PAPMISexDRName	_"^"_PAPMIDOB_"^"_PAPERSocialStatusDR_"^"_PAPERSocialStatusDRName	_"^"_""_		"^"_""			_"^"_PAPERTelH			_"^"_PAPMIID	_"^"_PAPMIPatCategoryDR_"^"_""			 _"^"_PAPERStName	 _"^"_PAPERZipDRName_"^"_PAPMIsecondphone_"^"_PAPERNationDRName	_"^"_PAPEREmail	_"^"_PAPERMaritalDR	_"^"_PAPERMaritalDRName	_"^"_PAPERBloodTypeDR_"^"_PAPERBloodTypeDRName	_"^"_""				_"^"_""					_"^"_""_"^"_""_"^"_Age_"^"_HCPDR_"^"_HCRDR_"^"_HCADR_"^"_HCADesc_"^"_CardNo_"^"_VIPLevel_"^"_MedicareCode_"^"_PACCardTypeDR_"^"_PACCardDesc_"^"_PAPERNationDR
	
	q Data
}

/// 不要直接使用,请使用 DocListBroker
/// 与门诊挂号兼容
/// 使用登记号查询患者信息，先查找PA_PatMas表
/// w ##class(web.DHCPE.PreIBaseInfo).HISDocListBroker("","","^00060021^")
/// w ##class(web.DHCPE.PreIBaseInfo).HISDocListBroker("","","^01700001^")
/// w ##class(web.DHCPE.PreIBaseInfo).HISDocListBroker("","","3127^^")
ClassMethod HISDocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	s PreIBaseInfodata=""
	s PatMasInfoData=""
	d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis($p($g(InString),"^",2))
	s Data=""
	i (""'=InString) s PreIBaseInfodata=..GetPreIBaseInfo(InString)
	
	s iSucc=$P(Data,"^",1)
	i "0"=iSucc s PreIBaseInfodata=""
	s InString="^"_$P(Data,"^",2)_"^"
	s PatMasInfodata=..GetHISIBaseInfo("","",InString)
	s Data=PreIBaseInfodata_";"_PatMasInfodata
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	q Data
}

/// 查询　患者列表
Query PreIBaseInfoList(Name As %String = "", RegNo As %String = "") As %Query(ROWSPEC = "姓名:%String, 登记号:%String, 编码:%String")
{
}

ClassMethod PreIBaseInfoListExecute(ByRef qHandle As %Binary, Name As %String = "", RegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	
	i ""'=RegNo s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	
	f  s id=$O(^DHCPEPreIBI(id)) q:id=""  d
	.s CurData=$g(^DHCPEPreIBI(id))  
	.
	.//	PIBI_PAPMINo	登记号
	.s PIBIPAPMINo=$p(CurData,"^",1)
	.q:(""'=RegNo)&(PIBIPAPMINo'=RegNo)
	.
	.//	PIBI_Name	姓名
	.S PIBIName=$p(CurData,"^",2)
	.q:(""'=Name)&('(PIBIName[Name))
	.
	.//				姓名		登记号	
    .set Data=$lb(	PIBIName, PIBIPAPMINo, $g(id))
    .
    .d PreIBaseInfoList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PreIBaseInfoList
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PreIBaseInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PreIBaseInfoListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PreIBaseInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PreIBaseInfoListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Created by SongDeBo 2006/6/15
/// Description: 根据查询条件取PreIBAseInfo的ResultSet
/// Paremeter:
/// 		QueryType: “HISCARDID”/“CERTID”/ “MOBILE”/ "PATNAME"/"REGID"
/// 		QueryValue: 对就QueryType的值
/// Return: A %ResultSet object
ClassMethod QueryRST(QueryType, QueryValue) As %ResultSet
{
	//s ^lisatest("0313","QueryRST")=QueryType_"@"_QueryValue
	s sqlCondition=""
	b //QueryRST-222-0718
	if (QueryType="REGID"){
		s sqlStr="select distinct piadm_pibi_dr as RowId from dhc_pe_preiadm where piadm_rowid="_QueryValue
	}
	else {
		s sqlCondition=$select(
			QueryType="HISCARDID":" PIBI_PAPMINo='"_QueryValue_"'",
			QueryType="CERTID":" PIBI_IDCard='"_QueryValue_"'",
			QueryType="MOBILE":" PIBI_MobilePhone='"_QueryValue_"'",
			QueryType="PATNAME":" PIBI_Name like '"_QueryValue_"%'",
			1:"")
		q:sqlCondition="" "Error: Arguments is wrong, in "_$zn	
		s sqlStr="select PIBI_RowId as RowId from dhc_pe_preibaseinfo where "_sqlCondition
		b //QueryRST-333-0718
	}
	b //QueryRST-111-0718
	s retRST=##class(%ResultSet).%New()
	d retRST.Prepare(sqlStr)
	d retRST.Execute()
	b ////QueryRST-444-0718
	q retRST
}

ClassMethod GetIBaseInfoIDByADM(ADMID)
{
	new IBaseInfoID
	i ADMID="" q ""
	s IBaseInfoID=$o(^DHCPEPreIBI(0,"PAPMINo",ADMID,""))
	q IBaseInfoID
}

/*Query GetPAPerson(Desc As %String) As %SQLQuery(ROWSPEC = "PAPMI_Name:%String:姓名, papmi_No:%String:登记号,PAPMI_ID:%String:身份证号,PAPMI_Dob:%String:生日, PAPMI_RowID:%String:ID")
{
	select PAPMI_Name,papmi_No,PAPMI_ID,PAPMI_Dob,papmi_RowId  
	From sqluser.pa_patmas 
	where PAPMI_Name[:Desc or PAPMI_Name2[:Desc
}*/
Query GetPAPerson(Desc As %String) As %Query(ROWSPEC = "PAPMI_Name:%String:姓名,papmi_No:%String:登记号,PAPMI_ID:%String:证件号,PAPMI_Dob:%String:生日,PAPMI_RowID:%String:ID")
{
}

ClassMethod GetPAPersonExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s id=0
	f  s id=$o(^PAPER(id)) q:id=""  d
	.S Name=$p($g(^PAPER(id,"ALL")),"^",1)
	.s Name2=$p($g(^PAPER(id,"ALL")),"^",2)
	.q:((Desc'="")&&(Name'[Desc)&&(Name2'[Desc))
	.s No=$p($g(^PAPER(id,"PAT",1)),"^",1)
	.q:$d(^DHCPEPreGBI(0,"PAPAMINo",No))
	.;s ID=$p($g(^PAPER(id,"ALL")),"^",9)
	.s ID=$P($G(^PAPER(id,"PAT",3)),"^",6)
	.s Dob=$p($g(^PAPER(id,"ALL")),"^",6)  
	.i Dob'="" s Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
	.d FindBuildGetPAPersonExecute
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuildGetPAPersonExecute
	set Data=$lb(Name,No,ID,Dob,$g(id))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetPAPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAPersonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPAPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(web.DHCPE.PreIBaseInfo).GetMaxRegNo()

ClassMethod GetMaxRegNo()
{
	s RetStr=""
	s MaxRegNo=""
	&SQL(Select max(PIBI_PAPMINo) into :MaxRegNo from DHC_PE_PreIBaseInfo where PIBI_PAPMINo>9999999 and PIBI_PAPMINo<20000000)
	i MaxRegNo'="" s RetStr=MaxRegNo
	s MaxRegNo=""
	&SQL(Select max(PIBI_PAPMINo) into :MaxRegNo from DHC_PE_PreIBaseInfo where PIBI_PAPMINo>29999999 and PIBI_PAPMINo<40000000)
	i MaxRegNo'="" s RetStr=RetStr_","_MaxRegNo
	s MaxRegNo=""
	&SQL(Select max(PIBI_PAPMINo) into :MaxRegNo from DHC_PE_PreIBaseInfo where PIBI_PAPMINo>49999999 and PIBI_PAPMINo<60000000)
	i MaxRegNo'="" s RetStr=RetStr_","_MaxRegNo
	q RetStr
}

ClassMethod GetPersonInfo(Name)
{
	//s Name=$ZCVT(Name,"U")
	s Name=$$ALPHAUP^SSUTIL4(Name)
	s id=+$O(^DHCPEPreIBI(0,"Name",Name,0))
	q:id>0 1
	q 0
}

ClassMethod GetRegNoByIDCard(IDCard)
{
	n (IDCard)
	q:IDCard="" ""
	s HadFlag=0
	s RegNo=""
	s IDCard=$ZCVT(IDCard,"U")
	s PatientID=""
	f  s PatientID=$O(^PAPERi("DVA",IDCard,PatientID),-1) q:(PatientID="")||(HadFlag=1)  d
	.s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s HadFlag=1
	.s RegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	q:RegNo'="" RegNo
	s ChangeIDCard=""
	i $L(IDCard)=15 d
	.s ChangeIDCard=..ID15to18(IDCard)
	e  i $L(IDCard)=18 d
	.s ChangeIDCard=..ID18to15(IDCard)
	q:ChangeIDCard="" RegNo
	s PatientID=""
	f  s PatientID=$O(^PAPERi("DVA",ChangeIDCard,PatientID),-1) q:(PatientID="")||(HadFlag=1)  d
	.s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s HadFlag=1
	.s RegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	q RegNo
}

ClassMethod ID15to18(IDCardNo15 As %String = "") As %String
{

	if $length(IDCardNo15)'=15 quit IDCardNo15
	set IDCardNo17=$extract(IDCardNo15,1,6)_"19"_$extract(IDCardNo15,7,15)

	set W(1)=1,W(2)=2,W(3)=4,W(4)=8,W(5)=5,W(6)=10,W(7)=9,W(8)=7,W(9)=3,W(10)=6
	set W(11)=1,W(12)=2,W(13)=4,W(14)=8,W(15)=5,W(16)=10,W(17)=9,W(18)=7
	set Y(0)="1",Y(1)="0",Y(2)="X",Y(3)="9",Y(4)="8",Y(5)="7",Y(6)="6",Y(7)="5",Y(8)="4",Y(9)="3",Y(10)="2"

	set snum=0
	for i=18:-1:2
	{
		set snum=snum+($extract(IDCardNo17,19-i,19-i)*W(i))
	}

	set ynum=snum#11

	set IDCardNo18=IDCardNo17_Y(ynum)
	quit IDCardNo18
}

/// 身份证号18位转15位
ClassMethod ID18to15(IDCardNo18 As %String = "") As %String
{
	if $length(IDCardNo18)'=18 quit IDCardNo18
	set IDCardNo15=$extract(IDCardNo18,1,6)_$extract(IDCardNo18,9,17)

	quit IDCardNo15
}

// w ##class(web.DHCPE.PreIBaseInfo).text()

ClassMethod text()
{
	s id=0
	f  s id=$o(^DHCPEPreIBI(id))  q:id=""  d
	.s RegNo=$p(^DHCPEPreIBI(id),"^",1)
	.q:$l(RegNo)="8"
	.s RegNo=$E(RegNo,1,8-$l(RegNo))_RegNo
	.&sql(update DHC_PE_PreIBaseInfo
	     set PIBI_PAPMINo =:RegNo
	     where PIBI_RowId=:id
	     )
}

ClassMethod GetRegNoByHpNo(HpNo)
{
	n (HpNo)
	q:HpNo="" ""
	s RegNo=""
	s HpNo=$ZCVT(HpNo,"U")
	s PreIADM=$o(^DHCPEPreIADM(0,"HPNo",HpNo,0))
	q:PreIADM="" ""
	s preIbase=$p(^DHCPEPreIADM(PreIADM),"^",1)
	s RegNo=$p(^DHCPEPreIBI(preIbase),"^",1)
	q RegNo
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreIBaseInfo","SearchPreIBaseInfoNew","ttt1","2","152")
Query SearchPreIBaseInfoNew(PatName As %Library.String = "", HospID As %Library.String = "", CTLocID As %Library.String = "") As websys.Query(ROWSPEC = "PIBI_RowId:%String, PIBI_PAPMINo:%String, PIBI_Name:%String, PIBI_Sex_DR:%String, PIBI_Sex_DR_Name:%String, PIBI_DOB:%String, PIBI_PatType_DR:%String, PIBI_PatType_DR_Name:%String, PIBI_Tel1:%String, PIBI_Tel2:%String, PIBI_MobilePhone:%String, PIBI_IDCard:%String, PIBI_Vocation:%String, PIBI_Position:%String, PIBI_Company:%String, PIBI_Postalcode:%String, PIBI_Address:%String, PIBI_Nation:%String, PIBI_Email:%String, PIBI_Married_DR:%String, PIBI_Married_DR_Name:%String, PIBI_Blood_DR:%String, PIBI_Blood_DR_Name:%String, PIBI_UpdateDate:%String, PIBI_UpdateUser_DR:%String, PIBI_UpdateUser_DR_Name:%String,PIBI_Age:%String")
{
}

ClassMethod SearchPreIBaseInfoNewExecute(ByRef qHandle As %Binary, PatName As %Library.String = "", HospID As %Library.String = "", CTLocID As %Library.String = "") As %Status
{
	
	s ^tempdhcpe("PreIBaseInfo")=$lb(PatName,HospID,CTLocID)
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 
 	if (""=PatName) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 

    If (""'=PatName) Do
	.s PatNameU=$$ALPHAUP^SSUTIL4(PatName)
	.s PatNameIndex=$O(^DHCPEPreIBI(0,"Name",PatNameU),-1)
	.f  s PatNameIndex=$O(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[PatNameU)  d
	..Set PIBIRowIdIndex=0
	..For  Set PIBIRowIdIndex=$O(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIRowIdIndex)) Quit:(PIBIRowIdIndex="")  Do
	...Set PAPMINoIndex=$p(^DHCPEPreIBI(PIBIRowIdIndex),"^",1)
	...Quit:$g(PAPMINoIndex)=""
	...Set PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PAPMINoIndex,""))
	...Quit:$g(PAPMIRowId)=""
	...Do GetBaseInfoNew(PAPMIRowId)
	...Quit:$g(Data)=""
	...Do PreIBaseInfoNewOutPut

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetBaseInfoNew(PAPMIRowId)
	
	Set Data=""
	Set id=PAPMIRowId
	Quit:$g(id)=""
	Set CurData=$g(^PAPER(PAPMIRowId,"ALL"))  
	Quit:CurData=""
	Set PAPMINo=""
	Set PAPMINo=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	If PAPMINo="" Set PAPMINo=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",2)
	Quit:$g(PAPMINo)=""
	Set PIBIRowId=$o(^DHCPEPreIBI(0,"PAPMINo",PAPMINo,""))
	Quit:$g(PIBIRowId)=""
	//	姓名
	Set PIBIName=$p(CurData,"^",1)
	s PIBINameU=$$ALPHAUP^SSUTIL4(PIBIName)
	Quit:(""'=PatName)&(PIBINameU'=PatNameU)
	//性别
	Set PIBISexDR=$p(CurData,"^",7)  
	If (""'=PIBISexDR)  Do  		//CT_Sex	
	.Set PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	Else  Do
	.Set PIBISexDRName=""

	//PIBI_DOB	生日
	Set PIBIDOB=$p(CurData,"^",6)       
	If (""'=PIBIDOB) Set PIBIDob=##class(websys.Conversions).DateLogicalToHtml(PIBIDOB)        
	If (""'=PIBIDOB) Set PIBIDOB=##class(websys.Conversions).DateLogicalToHtml(PIBIDOB)
	If (""'=PIBIDOB) d                             
	.s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,CTLocID)
	
	//电话号码1
	Set PIBITel1=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",6)
	//电话号码2
	Set PIBITel2=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",7)
	//移动电话
	Set PIBIMobilePhone=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",8)
	i PIBIMobilePhone="" s PIBIMobilePhone=PIBITel1
	i PIBIMobilePhone="" s PIBIMobilePhone=PIBITel2
	s PIBIMobilePhone=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIBIRowId)
	
	//身份证号
	Set PIBIIDCard=$p(CurData,"^",9)
	S PACCardDesc="",PIBIIDCard=""
	S PACCardTypeDR=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	i PACCardDesc["身份证" s PIBIIDCard=$p(CurData,"^",9)
	
	
	//职业
	Set PIBIVocation=""
	//职位
	Set PIBIPosition=""
	//公司
	Set PIBICompany=""
	Set PIBICompany=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",12) 

	//邮编
	Set PIBIPostalcode=""
	//联系地址
	Set PIBIAddress=""
	Set PIBIAddress=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",14) 
	
	//PIBI_PatType_DR_ 受检人类型  
	Set PIBIPatTypeDR=""  
	Set PIBIPatTypeDRName="" 
	Set PIBIPatTypeDR=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",5) 
	i (""'=PIBIPatTypeDR)  d  		       //CT_SocialStatus
	.s PIBIPatTypeDRName=$p($G(^CT("SS",PIBIPatTypeDR)),"^",2)
	
	//民族
	Set PIBINation=""
	
	//电子邮件
	Set PIBIEmail=""
	
	//婚姻状况
	Set PIBIMarriedDRName=""
	Set PIBIMarriedDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	If ""'=PIBIMarriedDR  Do  	//CT_Marital	
	.Set PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	Else  Do
	.s PIBIMarriedDR=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",17)
	.If ""'=PIBIMarriedDR  Do  	//CT_Marital 
	..Set PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	
	//血型
	Set PIBIBloodDR=$p($g(^PAPER(PAPMIRowId,"PER",5)),"^",32)
	If (""'=PIBIBloodDR)  Do  		//PAC_BloodType	
	.Set PIBIBloodDRName=$p($G(^PAC("BLDT",PIBIBloodDR)),"^",2)
	Else  Do
	.Set PIBIBloodDRName=""
	//日期
	Set PIBIUpdateDate=$p($g(^PAPER(PAPMIRowId,"PER",5)),"^",2)
	If (""'=PIBIUpdateDate) Set PIBIUpdateDate=$ZD(PIBIUpdateDate,4)
	//	PIBI_UpdateUser_DR	更新人
	Set PIBIUpdateUserDR=$p(CurData,"^",20)
	If ""'=PIBIUpdateUserDR  Do  	//SS_User	
	.Set PIBIUpdateUserDRName=$p($G(^SSU("SSUSR",PIBIUpdateUserDR)),"^",2)
	Else  Do
	.Set PIBIUpdateUserDRName="" 

    Set Data=$lb($g(PIBIRowId),PAPMINo,PIBIName,PIBISexDR,PIBISexDRName,PIBIDOB,PIBIPatTypeDR,PIBIPatTypeDRName, PIBITel1, PIBITel2, PIBIMobilePhone, PIBIIDCard, PIBIVocation, PIBIPosition, PIBICompany, PIBIPostalcode, PIBIAddress, PIBINation, PIBIEmail, PIBIMarriedDR, PIBIMarriedDRName, PIBIBloodDR, PIBIBloodDRName, PIBIUpdateDate, PIBIUpdateUserDR, PIBIUpdateUserDRName,TAge)
	q
PreIBaseInfoNewOutPut

 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
