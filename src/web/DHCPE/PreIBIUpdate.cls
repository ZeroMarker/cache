Import SQLUser

Class web.DHCPE.PreIBIUpdate Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 235;

ClassMethod GetPhoto(RegNo, Type As %String = "RegNo")
{
	s PhotoInfo=""
	i Type="RegNo" d
	.i RegNo'="" d
	..s PAPMIID=$O(^PAPERi("PAPMI_PatNo",RegNo,""))
	..q:PAPMIID=""
	..d GetPhotoInfo
	e  i Type="PAPMIID" d
	.s PAPMIID=RegNo
	.q:PAPMIID=""
	.d GetPhotoInfo
	q $Replace(PhotoInfo,$C(13,10),"")
GetPhotoInfo
	s PhotoInfo=$P($G(^PAPER(PAPMIID,"PER",6)),"^",5)
	q
}

ClassMethod SavePhotoStr(RegNo, PhotoStr As %String)
{
	q:RegNo="" -1
	s PAPMIID=$O(^PAPERi("PAPMI_PatNo",RegNo,""))
	i ##class(web.DHCPE.Utils.StreamUtil).IsStream(PhotoStr){
		s Length=PhotoStr.SizeGet()
		s PhotoStr=PhotoStr.Read(Length)
	}
	i PAPMIID'="" d
	.s $P(^PAPER(PAPMIID,"PER",6),"^",5)=PhotoStr
	q 0
}

ClassMethod SavePhoto(RegNo, PhotoInfo As %GlobalCharacterStream)
{
	s falg=""
	s falg=$isobject(PhotoInfo)
	q:falg'="1" "0"
	s Length=PhotoInfo.SizeGet()
	s PhotoStr=PhotoInfo.Read(Length)
	i RegNo'="" d
	.s PAPMIID=$O(^PAPERi("PAPMI_PatNo",RegNo,""))
	.i PAPMIID'="" d
	..s $P(^PAPER(PAPMIID,"PER",6),"^",5)=PhotoStr
	q ""
}

/// w ##class(web.DHCPE.PreIBIUpdate).Save("","","^01700001^11^10^05/02/1980^19^^^^^^^^^^^^1^^^3565;Gen")
/// w ##class(web.DHCPE.PreIBIUpdate).Save("","","^00001564^袁立本^10^31/12/1840^17^^^111^^^^^^^^^6^^^3565;Gen")
/// 
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	k PLIST
	d ..HandelPrePersonInfor(InString)
    s ret=..ISave()
    s ^DHCPETempHPNo(PLIST(2))=YYHPNo
    //s ^DHCPECBVIPLevel("PIBI",PLIST(2))=viplevel
    s ^DHCPECBSpecial("PIBI",PLIST(2))= SpecialType //特殊客户类型
    q ret_"^"_$G(PLIST(2))
}

ClassMethod HISUISave(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	k PLIST
	d ..HandelPrePersonInfor(InString)
    s ret=..ISave()
    s ^DHCPETempHPNo(PLIST(2))=YYHPNo
    //s ^DHCPECBVIPLevel("PIBI",PLIST(2))=viplevel
    
    q "{""code"":"""_$p(ret,"^",1)_""",""rowid"":"""_$p(ret,"^",2)_""",""regno"":"""_$G(PLIST(2))_"""}"
}

/*
ClassMethod GetVIPLevel()
{
	s VIPLevel=""
	s VIPID=0
	f  s VIPID=$o(^DHCPEVIPLevel("VIP",VIPID)) q:VIPID=""  d
	.s IsUse=$p(^DHCPEVIPLevel("VIP",VIPID),"^",4)
	.q:IsUse="N"
	.s IsApprove=$p(^DHCPEVIPLevel("VIP",VIPID),"^",5)
	.q:IsApprove="N"
	.s VIPLevel=VIPID
	q VIPLevel
}
*/
/// Creator： 	  xy 
/// CreatDate：   20210822
/// Description:  获取客户默认VIP等级
/// Table： 	  科室VIP等级维护（DHC_PE_LocVIPLevel）
/// Input:        LocID(登陆科室ID)
/// Return：      return=默认VIPID
/// debug: w ##class(web.DHCPE.PreIBIUpdate).GetVIPLevel(152)
ClassMethod GetVIPLevel(LocID As %String = "")
{
	s VIPLevel=""
	s VIPID=0
	f  s VIPID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPID))   q:(VIPID="")||(VIPLevel'="")  d
	.s ID=0
	.f  s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPID,ID))   q:(ID="")||(VIPLevel'="")  d
	..s Active=$lg($g(^CF.PE.LocVIPLevelD(ID)),15)
	..q:Active="N" 
	..s Default=$lg($g(^CF.PE.LocVIPLevelD(ID)),5)
	..i Default="Y" s VIPLevel=VIPID
	q VIPLevel
}

/// 整理要保存的预约的患者信息
/// ##class(web.DHCPE.PreIBIUpdate).HandelPersonInfor()
ClassMethod HandelPrePersonInfor(InString As %Library.String)
{
	s HISData=""
	s InString=##class(web.DHCPE.Public.Setting).Replace(InString," ","")
	s OldInString=InString
	
	i 1<$l(InString,";") d
	.s InString=$p(InString,";",1)
	.s IBIUpdateModel=$p(InString,";",2)
	.
	
	// 1	PIBI_RowId
	s iLLoop=1
	s value=$p(InString,"^",iLLoop)
	i (""'=value)&&(0'=value) s PLIST(1)=value	
	
	// 2	PIBI_PAPMINo	登记号
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	//不能为空
	i ""'=value s PLIST(2)=value
	
	// 3	PIBI_Name	姓名
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	//不能为空
	i ""'=value s PLIST(3)=value
	
	// 4	PIBI_SexPIBI_DR	性别
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	//不能为空
	i ""'=value s PLIST(4)=value
	
	// 5	PIBI_DOB	生日
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	//不能为空
	i ""'=value d
	.s PLIST(5)=value
	.i (""'=PLIST(5)) s PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
	
	// 6	PIBI_PatType_DR	客人类型
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	//不能为空
	i ""'=value s PLIST(6)=value
	
	// 7	PIBI_Tel1	电话号码1
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(7)=value
	
	// 8	PIBI_Tel2	电话号码2
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(8)=value
	
	// 9	PIBI_MobilePhone	移动电话
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(9)=value
	/*
	s Tel=PLIST(7)
	s PLIST(7)=PLIST(9)
	s PLIST(9)=Tel
	*/
	// 10	PIBI_IDCard	身份证号
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s ^wrz=value
	s PLIST(10)=value
	
	// 11	PIBI_Vocation	职业
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(11)=value
	
	// 12	PIBI_Position	职位
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(12)=value
	
	// 13	PIBI_Company	公司
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(13)=value
	
	// 14	PIBI_Postalcode	邮编
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(14)=value
	
	// 15 	PIBI_Address	联系地址
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(15)=value
	
	// 16	PIBI_Nation	民族
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(16)=value
	
	// 17	PIBI_Email	电子邮件
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(17)=value
	
	// 18	PIBI_Married	婚姻状况
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	//不能为空
	i ""'=value s PLIST(18)=value
	
	// 19	PIBI_Blood	血型
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(19)=value

	// 20	PIBI_UpdateDate	日期
	s iLLoop=iLLoop+1
	//s value=$p(InString,"^",iLLoop)
	//i ""'=value s PLIST(20)=value
	s PLIST(20)=+$H
	
	// 21	PIBI_UpdateUser_DR	更新人
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s PLIST(21)=value
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
	s YYHPNo=value
	
	//HPNo  体检号
	s iLLoop=iLLoop+1
	s hcpdr=$p(InString,"^",iLLoop)
	s iLLoop=iLLoop+1
	s hcadr=$p(InString,"^",iLLoop)
	
	s iLLoop=iLLoop+1
	s cardno=$p(InString,"^",iLLoop)  //CardNo  32
	s iLLoop=iLLoop+1
	s viplevel=$p(InString,"^",iLLoop)
	s iLLoop=iLLoop+1
	s MedicareCode=$p(InString,"^",iLLoop)
	s iLLoop=iLLoop+1
	s PAPMICardType=$p(InString,"^",iLLoop) //证件类型
	s iLLoop=iLLoop+1
	S SpecialType=$p(InString,"^",iLLoop) //特殊客户类型
}

/// ##class(web.DHCPE.PreIBIUpdate).ISave()
ClassMethod ISave()
{
	
	s ret="No Update"
	// 现插入 PA_Patmas 记录 
	i "NoGen"=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel() d
	.;b // NoGen
	.s ret=..IHISSaveNoGen()

	
	i "Gen"=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel() d
	.b // Gen
	.s ret=..IHISSaveGen()
	
	i "FreeCreate"=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel() d
	.s ret=..IHISSaveFreeCreate()
	
	i ""=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel() d
	.// 由预先分配的登记号段中获取登记号
	.//s ret=..IPreSave()
	.s ret="no valid Update mode"
	
	Q ret
}

/// 取得当前最大的登记号	
/// 前提：登记号全部由系统生成	
/// 规则：当前表中没有记录，生成 00000001 否则，最大登记号(最大 RowId记录的登记号)加一
/// w ##class(web.DHCPE.PreIBIUpdate).GetNewRegNo()
ClassMethod GetNewRegNo()
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
	s CurNo=##class(web.DHCPE.DHCPECommon).RegNoMask(CurNo)
	q CurNo
}

// ////////////////////////////////////////////////////////////////////////////////

/// 
/// 不牵涉HIS的操作, 取登记号码段的号
/// 保存数据
/// 
ClassMethod IPreSave()
{
	i ""=RowId d
	.s PLIST(2)=..GetNewRegNo()
	.s ReturnFlag=..Insert()
	e  d
	.s ReturnFlag=..Update()
	s ^DHCPETempHPNo(PLIST(2))=value
	q ReturnFlag
}

/// 由HIS生成登记号,牵涉HIS PA_PatMas
/// 保存数据
/// ##class(web.DHCPE.PreIBIUpdate)
ClassMethod IHISSaveGen()
{
	s ReturnFlag=""
	TSTART
	s HRowId=""
	s HRowId=$O(^PAPERi("PAPMI_PatNo",PLIST(2),HRowId))
	s:(""=HRowId) ReturnFlag="HIS No Patient"
	s Info=..GetInserHISPersonData()
	s ReturnFlag=..upperson1(Info,HRowId)
	goto:ReturnFlag'=0 IHISSaveGenErr
	
	// ///////////////////////////////////////////////////////////////////////////
	
	// 更新 DHC_PE_PreIBaseInfo 
	i ""=$G(PLIST(1)) d
	.s ReturnFlag=..Insert()
	.i ("0"'=$P(ReturnFlag,"^",1)) goto IHISSaveGenErr
	e  d
	.s ReturnFlag=..Update()
	.i ("0"'=$P(ReturnFlag,"^",1)) goto IHISSaveGenErr
	
	TCOMMIT
	Q ReturnFlag
IHISSaveGenErr
	TROLLBACK
	q ReturnFlag
}

/// 不事先分配登记号，登记号现由插入PA_PatMas表时获取
/// 
ClassMethod IHISSaveNoGen()
{
	s Info=..GetInserHISPersonData()
	
	;TSTART
	i 1=$D(PLIST(1)) d
	.i (""'=$G(PLIST(2)))&(1=$d(PLIST(2))) d
	..s HRowId=""
	..s HRowId=$O(^PAPERi("PAPMI_PatNo",PLIST(2),HRowId))
	.e  d 
	..s PLIST(2)=$p($g(^DHCPEPreIBI(PLIST(1))),"^",1)
	..s HRowId=""
	..s HRowId=$O(^PAPERi("PAPMI_PatNo",PLIST(2),HRowId))
	.i ""=HRowId d
	..s ReturnFlag="HIS No Patient"
	..goto IHISSaveNoGenErr
	.s ^xwmTemp("web.DHCPE.PreIBIUpdate","IHISSaveNoGen","Info")=Info
	.s ^xwmTemp("web.DHCPE.PreIBIUpdate","IHISSaveNoGen","HRowId")=HRowId
	.s OldInfo=##class(web.DHCPE.ModifyRecord).GetInfo(PLIST(1),"IBaseInfo")
	.s ReturnFlag=..upperson1(Info,HRowId)
	.goto:ReturnFlag'=0 IHISSaveNoGenErr
	.;s ReturnFlag=..Update()
	.s ReturnFlag=..Update(OldInfo)
	e  d
	.i (""'=$G(PLIST(2)))&(1=$d(PLIST(2))) d
	..s HRowId=""
	..s HRowId=$O(^PAPERi("PAPMI_PatNo",PLIST(2),HRowId))
	..i ""=HRowId d
	...s ReturnFlag="HIS No Patient"
	...goto IHISSaveNoGenErr
	..e  d
	...s ReturnFlag=..upperson1(Info,HRowId)
	...goto:ReturnFlag'=0 IHISSaveNoGenErr
	.e  d
	..;s ReturnFlag=..Insertperson(Info,"1",$G(PLIST(11)))
	..s ReturnFlag=..Insertperson(Info,PAPMICardType,$G(PLIST(11)))
	..goto:ReturnFlag'=0 IHISSaveNoGenErr
	..s PLIST(2)=P5
	..
	.s ReturnFlag=..Insert()
	i ("0"'=$P(ReturnFlag,"^",1)) goto IHISSaveNoGenErr
	;TCOMMIT
	q ReturnFlag
IHISSaveNoGenErr
	TROLLBACK
	Q ReturnFlag
}

ClassMethod IHISSaveFreeCreate()
{
	s Info=..GetInserHISPersonData()
	//i PLIST(1)=0 k PLIST(1)
	TSTART
	i 1=$D(PLIST(1)) d
	.s HRowId=""
	.s HRowId=$O(^PAPERi("PAPMI_PatNo",PLIST(2),HRowId))
	.
	.i ""=HRowId d
	..s ReturnFlag="HIS No Patient"
	..goto IHISSaveFreeCreateErr
	.s ReturnFlag=..upperson1(Info,HRowId)
	.;b ;upperson1
	.goto:(ReturnFlag'=0) IHISSaveFreeCreateErr
	.s ReturnFlag=..Update()
	.;b ;ss
	e  d
	.i ""'=$G(PLIST(2)) d
	..
	..s HRowId=""
	..s HRowId=$O(^PAPERi("PAPMI_PatNo",PLIST(2),HRowId))
	..;s ^sxt("ppp")=PLIST(2)
	..i ""=HRowId d
	...s ReturnFlag=..Insertperson(Info,"1",$G(PLIST(11)))
	...;b ;ReturnFlag1
	...goto:ReturnFlag'=0 IHISSaveFreeCreateErr
	..e  d
	...;s ^sxt("czxas")=HRowId
	...s ReturnFlag=..upperson1(Info,HRowId)
	...;b ;ReturnFlag2
	...goto:ReturnFlag'=0 IHISSaveFreeCreateErr
	.e  d
	..s ReturnFlag="No RegNo"
	..b ;noregnos
	..goto IHISSaveFreeCreateErr
	.s ReturnFlag=..Insert()
	i ("0"'=$P(ReturnFlag,"^",1)) goto IHISSaveFreeCreateErr
	;b ;aaa
	TCOMMIT
	q ReturnFlag
IHISSaveFreeCreateErr
	TROLLBACK
	b ;bbbb
	Q ReturnFlag
}

ClassMethod GetInserHISPersonData()
{
	s info=""
	i ""=$G(PLIST(5)) d
	.s Age=""
	e  d
	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(PLIST(5),+$h)
	
	i ("0"'=Age)&&(""'=Age) d
	.s AgeDay=+$P($P(Age," ",3),"D",1)
	.s value=AgeDay
	e  d
	.s AgeDay=""
	.s value=""
	//s InString=InString_""_value	// 1	AgeDay		paper_ageday
	s info=info_""_value
	i ("0"'=Age)&&(""'=Age) d
	.s AgeMoth=+$P($P(Age," ",2),"M",1)
	.s value=AgeMoth
	e  d
	.s AgeMoth=""
	.s value=""
	s info=info_"^"_value	// 2	AgeMoth		paper_agemth
	
	i ("0"'=Age)&&(""'=Age) d
	.s AgeYear=+$P($P(Age," ",1),"Y",1)
	.s value=AgeYear
	e  d
	.s AgeYear=""
	.s value=""
	s info=info_"^"_value	// 3	AgeYear		paper_ageyr
	
	s value=""
	s info=info_"^"_value	// 4	国家			paper_langprim_dr
	
	s value=$G(PLIST(5))
	s info=info_"^"_value	// 5	出生日期		paper_dob
	
	s value=$G(PLIST(3))
	s info=info_"^"_value	// 6	姓名			paper_name
	
	s value=$G(PLIST(4))
	s info=info_"^"_value	// 7	性别			paper_sex_dr
	
	s value="|||||||||||"_AgeYear_"|"_AgeMoth_"|"_AgeDay
	s info=info_"^"_value	// 8				paper_age
	
	s value=$G(PLIST(21))
	s info=info_"^"_value	// 9				paper_userupdate
	
	s value=""
	s info=info_"^"_value	// 10	国家			paper_country_dr
	
	s value=""
	s info=info_"^"_value	// 11	省			paper_ct_province_dr
	
	s value=""
	s info=info_"^"_value	// 12	城市			paper_citycode_dr
	
	s value=""
	s info=info_"^"_value	// 13	语言			paper_langprim_dr
	
	s value=$G(PLIST(16))
	//s value=""
	s info=info_"^"_value	// 14	民族			paper_nation_dr
	
	s value=""
	s info=info_"^"_value	// 15				
	
	s value=""
	s info=info_"^"_value	// 16	宗教			paper_religion_dr
	
	s value=$G(PLIST(18))
	s info=info_"^"_value	// 17	婚姻			paper_marital_dr
	
	s value=""
	s info=info_"^"_value	// 18	学历			paper_education_dr
	
	s value=$G(PLIST(6))
	s info=info_"^"_value	// 19	患者类型		paper_socialstatus_dr
	
	i ""=$G(PLIST(19)) d
	.s value=""
	e  d
	.s value=$p($G(^PAC("BLDT",PLIST(19))),"^",2)
	.
	s info=info_"^"_value	// 20	血型			paper_foreignid
	
	s value=$G(PLIST(14))
	s info=info_"^"_value	// 21	邮编			paper_zip_dr
	
	//s value=$G(PLIST(7))
	s value=$G(PLIST(9))
	s info=info_"^"_value	// 22	电话			paper_telh
	
	s value=$G(PLIST(8))
	s info=info_"^"_value	// 23	单位电话		paper_telo
	
	s value=$G(PLIST(15))
	s info=info_"^"_value	// 24	地址			paper_secondphone
	
	s value=$G(PLIST(13))
	s info=info_"^"_value	// 25	工作单位		PAPER_NokAddress2
	s value=$G(PLIST(10))
	
	s info=info_"^"_value	// 26	身份证		paper_id
	s value=""
	s info=info_"^"_value	// 27	人名助记符	paper_name2		
	
	s value=""
	s info=info_"^"_value	// 28				PAPER_EmplType_DR
	
	s value=""
	s info=info_"^"_value	// 29				PAPER_EmployeeNo
	
	s value=hcpdr
	s info=info_"^"_value   //30                PAPER_HCP_DR
	
	s value=hcadr
	s info=info_"^"_value   //31                PAPER_HCA_DR
	
	s value=cardno
	s info=info_"^"_value   //32                //就诊卡的卡号 
	
	s value=PAPMICardType
	s info=info_"^"_value   //33 //证件类型 
    
    s value=$G(PLIST(7))
	s info=info_"^"_value	// 34 电话1 paper_mobPhone

	s value=$G(PLIST(11))
	s info=info_"^"_value	// 35 职业 PAPER_Occupation_DR

	Q info
}

/// 录入新的患者时，不在PA_PatMas事先插入记录
/// 现在在安贞使用
/// 参考 Insertperson^CDHCFactCon （安贞库有此M）
/// 	mywork	职业
/// 	mytype 证件类型 默认为 1 （身份证）
ClassMethod Insertperson(info As %String, mytype As %String, mywork As %String)
{
	//s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate"))
	s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$D(%session) LocID="105"
	s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate",LocID))
	
	k P6
	k P5
	s ageday="",agemth="",ageyr="",langprim="",dob=""
	s name="",sex="",age="",userup=""
	s mobPhone=""
	s stline="",telh="",company="",telo="",idcard=""
	s ageday=$P(info,"^",1),agemth=$P(info,"^",2)
	s ageyr=$P(info,"^",3),langprim=$P(info,"^",4)
	//s dob=$ZDH($P(info,"^",5),3)
	s dob=$P(info,"^",5)
	s name=$P(info,"^",6),sex=$P(info,"^",7)
	s age=$P(info,"^",8),userup=$P(info,"^",9)
	;
	s country=$P(info,"^",10),ct=$P(info,"^",11),city=$P(info,"^",12)
	s lang=$P(info,"^",13),nat=$P(info,"^",14)
	s status=$P(info,"^",15)
	s rel=$P(info,"^",16),mar=$P(info,"^",17),edu=$P(info,"^",18)
	s soc=$P(info,"^",19)
	s forei=$P(info,"^",20),zip=$P(info,"^",21)
	;
	s telh=$P(info,"^",22),telo=$P(info,"^",23)
	s stline1=$P(info,"^",24),stline2=$P(info,"^",25),cid=$P(info,"^",26)
	s myName2=$P(info,"^",27)
	s myEmplTypeDR=$P(info,"^",28)
	s myEmployeeNo=$P(info,"^",29)
	s hcpdr=$P(info,"^",30)
	s hcadr=$P(info,"^",31)
	s CardNo=$P(info,"^",32)  //对照的卡号
	s mobPhone=$P(info,"^",34)
	s CardTypeDesc="",DVAnumber=cid
	i mytype'="" s CardTypeDesc=##class(web.DHCPE.DHCPECommon).GetICardTypeDescByID(mytype)
	if (CardTypeDesc'["身份证") s DVAnumber=cid,cid=""

	&sql(
		insert into pa_person
		(
		paper_ageday,paper_agemth,paper_ageyr,
		paper_dob,paper_name,paper_sex_dr,paper_age,
		paper_userupdate,
		paper_country_dr,paper_ct_province_dr,paper_citycode_dr,
		paper_langprim_dr,paper_nation_dr,
		paper_religion_dr,paper_marital_dr,paper_education_dr,
		paper_socialstatus_dr,paper_zip_dr,
		paper_telh,paper_telo,
		paper_secondphone,PAPER_NokAddress2,paper_id,PAPER_EmplType_DR,
		PAPER_EmployeeNo,PAPER_HCP_DR,PAPER_CT_HCA_DR,paper_mobPhone
		)
     	values(
     	:ageday,:agemth,:ageyr,
     	:dob,:name,:sex,:age,
     	:userup,
     	:country,:ct,:city,
     	:lang,:nat,
		:rel,:mar,:edu,
		:soc,:zip,
		:telh,:telo,
		:stline2,:stline1,:cid,:myEmplTypeDR,
		:myEmployeeNo,:hcpdr,:hcadr,:mobPhone
		)
	) 
	q:("0"'=SQLCODE) SQLCODE

	i SQLCODE="0"
	{
		s P6=$p(%ROWID,$c(1),1)
		s myrowid=P6
		//s ^zl("INSERT",1)=$G(^PAPER(myrowid,"PER",2))
		///增加索引
		s Oldcid=$p($G(^PAPER(myrowid,"ALL")),"^",9)
		s $p(^PAPER(myrowid,"ALL"),"^",9)=cid
		i Oldcid="" s Oldcid="000000000000000"
		s Oldcid=$ZCVT(Oldcid,"U")
		k ^PAPERi("PAPMI_ICPPBC",Oldcid_"Z",myrowid)
		
		i cid=""{
			s cidstr="000000000000000"}
		else{
			s cidstr=cid	
		}
		s cidstr=$ZCVT(cidstr,"U")
		s ^PAPERi("PAPMI_ICPPBC",cidstr_"Z",myrowid)=""
		
		
		s mytype=$g(mytype)
	    s PIModel=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
	    i PIModel'="FreeCreate"
	    {
			lock ^PAPER(0,"CNT","I")
			s CurRegNo=$g(^PAPER(0,"CNT","I"))
			s ^PAPER(0,"CNT","I")=CurRegNo+1
			lock -^PAPER(0,"CNT","I")
	    	 
			s mypano=$g(CurRegNo)    ;8位的登记号
			s mypano=mypano+1
	    }
	    else
	    {
		    s mypano=PLIST(2)
	    }
		s mypano=##class(web.DHCPE.DHCPECommon).RegNoMask(mypano)
		
		&sql(update pa_patmas
					set papmi_No=:mypano,
					papmi_ipno=:mypano,
					papmi_opno=:mypano,
					PAPMI_CardType_DR=:mytype,
					PAPMI_HealthFundNo=:MedicareCode,
					PAPMI_DVAnumber=:DVAnumber,
					PAPMI_Active="Y"
					where papmi_rowid=:myrowid
	)      
	 
	 	;lock ^PAPER(myrowid,"PAT",1)       
	 	//s $p(^PAPER(myrowid,"PAT",1),"^",8)=mywork
	 	s $p(^PAPER(myrowid,"PER",2),"^",6)=mywork //职位
	 	;lock	  
	 
		i SQLCODE=0 d
		.s tmp=$g(^PAPER(myrowid,"PER","ADD"))
		.i tmp="" d
		..s ^PAPER(myrowid,"PER","ADD",0)=1    
		.s ^PAPER(myrowid,"PER","ADD",1)=$g(stline1)  //地址
		.s Name3=##class(web.DHCINSUPort).GetCNCODE(name,3,"") 
        .s $p(^PAPER(myrowid,"ALL"),"^",19)=Name3

	}	     
	s P5=mypano
	q:SQLCODE'=0 SQLCODE
	
	i (CardRelate="Yes")&&(CardNo'="") d
	.s SQLCODE=..UpdateCardInfo(myrowid, CardNo)
	q SQLCODE
}

ClassMethod upperson1(info As %String, rowid As %String)
{
    //s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate"))
	s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$D(%session) LocID="105"
	s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate",LocID))
	
	k P5
	s ageday="",agemth="",ageyr="",langprim="",dob="",name="",sex="",age="",userup=""
	s stline="",telh="",company="",telo="",idcard=""
	s mobPhone=""
	s ageday=$P(info,"^",1),agemth=$P(info,"^",2)
	s ageyr=$P(info,"^",3),langprim=$P(info,"^",4)
	s dob=$P(info,"^",5)
	s name=$P(info,"^",6),sex=$P(info,"^",7),age=$P(info,"^",8),userup=$P(info,"^",9)
	
	s country=$P(info,"^",10),ct=$P(info,"^",11),city=$P(info,"^",12)
	s lang=$P(info,"^",13),nat=$P(info,"^",14)
	s status=$P(info,"^",15)
	s rel=$P(info,"^",16),mar=$P(info,"^",17),edu=$P(info,"^",18),soc=$P(info,"^",19)
	s forei=$P(info,"^",20),zip=$P(info,"^",21)
	
	s telh=$P(info,"^",22),telo=$P(info,"^",23)
	s stline1=$P(info,"^",24),stline2=$P(info,"^",25),cid=$P(info,"^",26)
	s myName2=$P(info,"^",27)
	s myEmplTypeDR=$P(info,"^",28)
	s myEmployeeNo=$P(info,"^",29)
	s Oldcid=$p($G(^PAPER(rowid,"ALL")),"^",9)
	s hcpdr=$P(info,"^",30)
	s hcadr=$P(info,"^",31)
	s CardNo=$P(info,"^",32)  //对照的卡号
	
	S PAPMICardType=$P(info,"^",33) //证件类型
	S mobPhone=$P(info,"^",34) //移动电话
	S Occupation=$P(info,"^",35) //职业

	
	s OldPatInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(rowid)
	
	s CardTypeDesc="",DVAnumber=cid
	i PAPMICardType'="" s CardTypeDesc=##class(web.DHCPE.DHCPECommon).GetICardTypeDescByID(PAPMICardType)
	if (CardTypeDesc'["身份证") s DVAnumber=cid,cid=""

	&sql(update pa_person
			set paper_dob=:dob,paper_name=:name,paper_sex_dr=:sex,paper_age=:age,
			paper_marital_dr=:mar,
			paper_userupdate=:userup,
			paper_telh=:telh,paper_telo=:telo,
			paper_secondphone=:stline2,
			PAPER_NokAddress2=:stline1,
			paper_socialstatus_dr=:soc,
			paper_nation_dr=:nat,
			paper_mobPhone=:mobPhone,
			PAPER_Occupation_DR=:Occupation
			where paper_rowid=:rowid
	)
	//i cid'=""
	i PAPMICardType'=""
    {
      &sql(update pa_patmas set PAPMI_DVAnumber=:DVAnumber,PAPMI_CardType_DR=:PAPMICardType where papmi_rowid=:rowid)
    }
  i SQLCODE=0 d
    .s $p(^PAPER(rowid,"PAT",1),"^",6)="Y"  //PAPMI_Active

   //更新门诊新生儿出生日期
    If $d(^PAPER("DHC",rowid,1)) {
		s $p(^PAPER("DHC",rowid,1),"^",1)=dob
	}

	s Oldcid=$ZCVT(Oldcid,"U")
	s $p(^PAPER(rowid,"ALL"),"^",9)=cid
	
	///增加索引
	i Oldcid=""{
		s Oldcid="000000000000000"
	}
	k ^PAPERi("PAPMI_ICPPBC",Oldcid_"Z",rowid)
	i cid=""{
		s cidstr="000000000000000"}
	else{
		s cidstr=cid	
		}
	s cidstr=$ZCVT(cidstr,"U")
	s ^PAPERi("PAPMI_ICPPBC",cidstr_"Z",rowid)=""

	s P5=SQLCODE
	
	//如果门诊有联系地址，不更新；如果门诊没有联系地址，则更新
	i SQLCODE=0 d
	.s tmp=$g(^PAPER(rowid,"PER","ADD",1))  
	.i tmp="" d
	..s ^PAPER(rowid,"PER","ADD",0)=1    
	..s ^PAPER(rowid,"PER","ADD",1)=stline1 //联系地址 
	  
	q:SQLCODE'=0 SQLCODE

	i MedicareCode'=""
	{
		&sql(update pa_patmas
					set PAPMI_HealthFundNo=:MedicareCode
					where papmi_rowid=:rowid
		)
	}
	q:SQLCODE'=0 SQLCODE
    s NewPatInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(rowid)
	s logInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).CheckPatInfoUpdate(OldPatInfo,NewPatInfo)
	d ##class(web.DHCBL.Patient.DHCPatientBuilder).AddDHCPatientUpdateLog(logInfo)
    i (CardRelate="Yes")&&(CardNo'="") d
	.s SQLCODE=..UpdateCardInfo(rowid, CardNo)
	
	s PAPMINo=$p($g(^PAPER(rowid,"PAT",1)),"^",1)
	i SQLCODE=0 d
    .s Name3=##class(web.DHCINSUPort).GetCNCODE(name,3,"") //调用该方法会修改rowid值，因此将该方法放到最后
    .s $p(^PAPER($o(^PAPERi("PAPMI_PatNo",PAPMINo,0)),"ALL"),"^",19)=Name3

	q SQLCODE
}

ClassMethod Update(OldInfo)
{
	s RowId=PLIST(1)
	k PLIST(1)	// PIBI_RowId
	//s OldInfo=##class(web.DHCPE.ModifyRecord).GetInfo(RowId,"IBaseInfo")
	s CurRegNo=PLIST(2)
	k PLIST(2)	// PIBI_PAPMINo
	&SQL(Update SQLUSER.DHC_PE_PreIBaseInfo Values :PLIST() 
		where PIBI_RowId = :RowId)
	s PLIST(2)=CurRegNo
	s ^DHCPECBSpecial("PIBI",PLIST(2))= SpecialType //特殊客户类型
	i SQLCODE=0 d
	.s NewInfo=##class(web.DHCPE.ModifyRecord).GetInfo(RowId,"IBaseInfo")
	.//记录修改记录
	.d ##class(web.DHCPE.ModifyRecord).Save(RowId,"IBaseInfo",OldInfo,NewInfo, %session.Get("LOGON.USERID"))
	.;d ##class(web.DHCPE.CRM.Gateway).ReSendForHH(RowId)
	Q SQLCODE_"^"_RowId
}

ClassMethod Insert()
{
	k PLIST(1) // PIBI_RowId
	&SQL(Insert Into SQLUSER.DHC_PE_PreIBaseInfo Values :PLIST())
	;b // w SQLCODE_"^"_%ROWID
	s userId=""
	s:$D(%session) userId=%session.Get("LOGON.USERID")
	s:userId="" userId=1
	i "0"=SQLCODE d
	.s ret=SQLCODE_"^"_%ROWID
	.S PLIST(2)=$P($g(^DHCPEPreIBI(%ROWID)),"^",1)
	.s ^DHCPECBSpecial("PIBI",PLIST(2))= SpecialType //特殊客户类型
	.;记录修改记录
	.s NewInfo=##class(web.DHCPE.ModifyRecord).GetInfo(%ROWID,"IBaseInfo")
	.d ##class(web.DHCPE.ModifyRecord).Save(%ROWID,"IBaseInfo","",NewInfo, userId)
	e  d
	.s ret=SQLCODE_"^"_""
	q ret
}

/// Description:  根据院区获取默认科室
/// Input:        HospID(院区ID)
/// Return：      默认科室ID
/// Debug:w ##class(web.DHCPE.PreIBIUpdate).GetDefaultLoc(2)
ClassMethod GetDefaultLoc(HospID As %String = "")
{
	s LocList=$g(^DHCPESetting("DHCPE","PELoc"))
	s LocFlag=0,DefaultLoc=""
    s Length=$l(LocList,"^")
    f LocNum=1:1:Length d
    .s Loc=$p(LocList,"^",LocNum)
    .q:Loc=""
    .s CurHospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(Loc)
    .q:LocFlag=1
    .i HospID=CurHospID d
    ..s LocFlag=1
    ..s DefaultLoc=Loc
    q DefaultLoc
}

/// Description:  门诊更新体检的基本信息
/// Input:        RegNo(登记号),UserID(用户ID),HospID(院区ID)
/// Return：      0
/// Debug:w ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis()
ClassMethod UpdatePEInfoByHis(RegNo, UserID As %String = "", HospID As %String = "")
{
	
	s ^tempdhcpe("UpdatePEInfoByHis")=$lb(RegNo,UserID,HospID)
	q:$g(RegNo)="" ""
	s LocID=##class(web.DHCPE.PreIBIUpdate).GetDefaultLoc(HospID)
	q:LocID="" 0
	new PREIBaseInfoId,Strings,IBFLIST
	s PREIBaseInfoId=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	;q:PREIBaseInfoId="" ""
	
	s Strings=##class(web.DHCPE.PreIBaseInfo).GetHISIBaseInfo("","","^"_RegNo_"^^"_"$"_"$"_HospID_"$"_LocID_"$"_UserID,"1")
	s IBFLIST(2)=$p(Strings,"^",2)  //RegNo
	s IBFLIST(3)=$p(Strings,"^",3)  //Name
	s IBFLIST(4)=$p(Strings,"^",4)  //Sex
	
	s birth=$p(Strings,"^",6)
	s IBFLIST(5)=""
	i birth'="" s IBFLIST(5)=##class(websys.Conversions).DateHtmlToLogical(birth)
	
	s IBFLIST(6)=$p(Strings,"^",7)  //pattype
	s IBFLIST(9)=$p(Strings,"^",11)  //mobile
	s IBFLIST(8)=$p(Strings,"^",10)  //tel2
	s IBFLIST(7)=$p(Strings,"^",9)  //tel1
	s IBFLIST(10)=$p(Strings,"^",12)  //IDCard
	//s IBFLIST(11)=$p(Strings,"^",13)  //vocation
	//s IBFLIST(12)=$p(Strings,"^",14)  //position
	s IBFLIST(13)=$p(Strings,"^",17)  //company  公司
	//s IBFLIST(14)=$p(Strings,"^",16)  //postcode
	s IBFLIST(15)=$p(Strings,"^",15)  //address  联系地址
	//s IBFLIST(16)=$p(Strings,"^",18)  //nation
	//s IBFLIST(17)=$p(Strings,"^",19)  //email
	s IBFLIST(18)=$p(Strings,"^",20)  //marry
	//s IBFLIST(19)=$p(Strings,"^",22)  //blood
	
	s OldInfo=##class(web.DHCPE.ModifyRecord).GetInfo(PREIBaseInfoId,"IBaseInfo")
	i PREIBaseInfoId'="" d	
	.&sql(update sqluser.DHC_PE_PreIBaseInfo values :IBFLIST() where PIBI_RowId=:PREIBaseInfoId)
	e  d
	.&sql(insert into sqluser.DHC_PE_PreIBaseInfo values :IBFLIST())
	i SQLCODE=0 d
	.s PREIBaseInfoId=%ROWID
	.s NewInfo=##class(web.DHCPE.ModifyRecord).GetInfo(PREIBaseInfoId,"IBaseInfo")
	.d ##class(web.DHCPE.ModifyRecord).Save(PREIBaseInfoId,"IBaseInfo",OldInfo,NewInfo,UserID)
	
	q 0
}

/// 功能：更新卡表DHC_CardRef校验码字段CF_SecurityNO
/// w ##class(web.DHCPE.PreIBIUpdate).UpdateCardSecurityNo("000001036758$2","6547938126")
ClassMethod UpdateCardSecurityNo(CardNo, SecurityNo)
{
	 Q:CardNo="" "0"
    s CardTypeDR=$P(CardNo,"$",2)
    s CardNo=$P(CardNo,"$",1)
    s CFRowID=""
	s mySecurityFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^", 18) ;CTD_SecurityNoFlag
	;数据转换
	i mySecurityFlag="Y" d
	.s SecurityNo=##class(web.UDHCAccEnrypt).Encrypt(SecurityNo)
	e  d
	.s SecurityNo=""
	s CardCardRef=""
	s CardRef=""
	f  s CardRef=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRef)) q:(CardRef="")||(CardCardRef'="")  d
	.s CFRowID=CardRef
	.s CurCardTypeDR=$p(^DHCCARD("CF",CardRef),"^",16)
	.q:CurCardTypeDR'=CardTypeDR
	.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
	.s CurCardNo=$p(^DHCCARD("CF",CardRef),"^",2)
	.i ActiveFlag="N" s CardCardRef=CurCardNo
	
	&SQL(update sqluser.DHC_CardRef set CF_SecurityNo=:SecurityNo where CF_RowID=:CFRowID)
	q SQLCODE
}

/// w ##class(web.DHCPE.PreIBIUpdate).UpdateCardInfo("84415","000000111111111")
ClassMethod UpdateCardInfo(PAPMIDR, CardNo)
{
    Q:CardNo="" "0"
    s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
    s:'$D(%session) LocID="105"
    s:$D(%session) HOSPID=%session.Get("LOGON.HOSPID")
    s:'$D(%session) HOSPID="2"
    s CardTypeDR=$P(CardNo,"$",2)
    s CardNo=$P(CardNo,"$",1)
    ;if CardNo="" s CardNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	S CardLength=$G(^DHCPESetting("DHCPE","CardNoLength"))
	s:CardTypeDR="" CardTypeDR=$G(^DHCPESetting("DHCPE","CardType",LocID))   //卡类型ID DHC_CardTypeDef
	s CardLength=+$P(^DHCCARDTYPEDef(CardTypeDR),"^",17)
	i CardLength'=0 d
	.s CardNo=$E("00000000000000000000",1,CardLength-$l(CardNo))_CardNo
	s CardCardRef=""
	s CardRef=""
	f  s CardRef=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRef)) q:(CardRef="")||(CardCardRef'="")  d
	.s CurCardTypeDR=$p(^DHCCARD("CF",CardRef),"^",16)
	.q:CurCardTypeDR'=CardTypeDR
	.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
	.s CurCardNo=$p(^DHCCARD("CF",CardRef),"^",2)
	.
	.i ActiveFlag="N" s CardCardRef=CurCardNo
	s PAPMICardRef=""
	s CardRef=""
	f  s CardRef=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,CardRef)) q:(CardRef="")||(PAPMICardRef'="")  d
	.s CurCardTypeDR=$p(^DHCCARD("CF",CardRef),"^",16)
	.s CFRowID=CardRef
	.q:CurCardTypeDR'=CardTypeDR
	.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
	.s CurCardNo=$p(^DHCCARD("CF",CardRef),"^",2)
	.i ActiveFlag="N" s PAPMICardRef=CurCardNo
	q:(PAPMICardRef'=CardCardRef) "卡号已经对照并且不一致"_PAPMIDR_CardNo
	q:((PAPMICardRef'="")&&(PAPMICardRef'=CardNo)) "卡号已经对照并且和现在不一致"
	s CurCardRef=PAPMICardRef
	i CurCardRef=""
	{
		s ActiveFlag="N"
		s SecurityNo=""
		s FareType="PC"
		s PAPMINo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
		s IDCardNo=$p(^PAPER(PAPMIDR,"ALL"),"^",9)
		s Date=+$H
		s Time=$p($H,",",2)
		s:($d(%session)) UserDR=%session.Get("LOGON.USERID")
		s:'$d(%session) UserDR=1
		&SQL(insert into sqluser.DHC_CardRef (CF_CardNo,CF_SecurityNo,CF_PAPMI_DR,CF_IDCardNo,CF_PAPMINo,CF_Date,CF_Time,CF_User_DR,CF_ActiveFlag,CF_CardType_DR,CF_DateFrom) values (:CardNo,:SecurityNo,:PAPMIDR,:IDCardNo,:PAPMINo,:Date,:Time,:UserDR,:ActiveFlag,:CardTypeDR,:Date))  //  ,CF_FareType   ,:FareType
		q:SQLCODE'=0 "插入卡对照错误"
		s CFParRef=%ROWID
		s ComputerIP=$ZUTIL(67,15,$JOB)
		&SQL(insert into sqluser.DHC_CardStatusChange (CSC_CF_ParRef,CSC_Date,CSC_Time,CSC_CurStatus,CSC_User_DR,CSC_ComputerIP) values (:CFParRef,:Date,:Time,:ActiveFlag,:UserDR,:ComputerIP))
		q:SQLCODE'=0 "插入卡对照子表错误"
		d ..InsertAccInfo(PAPMIDR, CardNo,CFParRef,CardTypeDR,HOSPID)  //门诊账户表插入数据
		q SQLCODE
	}
	else
	{
		//q 0
		//s IDCardNo=$p(^PAPER(PAPMIDR,"ALL"),"^",9)
		//&SQL(update sqluser.DHC_CardRef set CF_IDCardNo=:IDCardNo where CF_RowID=:CurCardRef)
		s PACCardDesc=""
		S PACCardTypeDR=$P($G(^PAPER(PAPMIDR,"PAT",3)),"^",7)
	    I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
		s IDCardNo=$P($G(^PAPER(PAPMIDR,"PAT",3)),"^",6)
		if (PACCardDesc["身份证"){
			&SQL(update sqluser.DHC_CardRef set CF_IDCardNo=:IDCardNo where CF_RowID=:CFRowID)
		}

		q SQLCODE
	}
}

ClassMethod CardTypeToDesc(TypeID)
{
	q:TypeID="" ""
	s TypeDesc=""
	s TypeDesc=$P($G(^DHCCARDTYPEDef(TypeID)),"^",2)
	q TypeDesc
}

/// w ##class(web.DHCPE.PreIBIUpdate).CardTypeByRegNo("0000000002")
ClassMethod CardTypeByRegNo(RegNo)
{
	    s PAPMIID=""
	    s PAPMIID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	    q:PAPMIID="" ""
	    s CurCardTypeDR="",TypeDesc=""
		s CardRef=0
		f  s CardRef=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIID,CardRef)) q:(CardRef="")  d
		.//q:CurCardTypeDR'=CardTypeDR
		.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
		.s CurCardNo=$p(^DHCCARD("CF",CardRef),"^",2)
		.//Q:ActiveFlag="N"
		.s CurCardTypeDR=$p(^DHCCARD("CF",CardRef),"^",16)
		.i CurCardTypeDR'="" d
		..s TypeDesc=""
	    ..s TypeDesc=$P($G(^DHCCARDTYPEDef(CurCardTypeDR)),"^",2)
        q CurCardTypeDR_"^"_TypeDesc
}

/// Debug: w ##class(web.DHCPE.PreIBIUpdate).GetRelate("36$2","P")
/// Type:  R--RegNo,P--PAPMIID,C--CardNo(4733520%%P)
ClassMethod GetRelate(ID, Type, LocID As %String = "")
{
	i (LocID="") {
		s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
	}
    s CardLength=10   //卡长度
	s CardTypeDR=$P(ID,"$",2)
	s ID=$P(ID,"$",1)
	S CardLength=$G(^DHCPESetting("DHCPE","CardNoLength"))
	
	//卡类型ID DHC_CardTypeDef
	s:CardTypeDR="" CardTypeDR=$G(^DHCPESetting("DHCPE","CardType",LocID)) 
    q:CardTypeDR="" ""
	s CardLength=+$P($g(^DHCCARDTYPEDef(CardTypeDR)),"^",17)
	i Type="R"
	{
		s ID=##class(web.DHCPE.DHCPECommon).RegNoMask(ID,LocID)
		s PAPMIID=$O(^PAPERi("PAPMI_PatNo",ID,0))
		q:PAPMIID="" ""
		q ..GetRelate(PAPMIID_"$"_CardTypeDR,"P",LocID)
	}
	i Type="P"
	{
		s PAPMICardRef="",CurCardTypeDR=""
		s CardRef=0
		f  s CardRef=$o(^DHCCARDi("CF",0,"PAPMIDR",ID,CardRef)) q:(CardRef="")||(PAPMICardRef'="")  d
		.s CurCardTypeDR=$p(^DHCCARD("CF",CardRef),"^",16)
		.//q:CurCardTypeDR'=CardTypeDR
		.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
		.s CurCardNo=$p(^DHCCARD("CF",CardRef),"^",2)
		.i ActiveFlag="N" s PAPMICardRef=CurCardNo
		q PAPMICardRef
	}
	i Type="C"
	{
		i CardLength'=0 d
		.s ID=$E("00000000000000000000",1,CardLength-$l(ID))_ID
		s CardCardRef=""
		s CardRef=0
		f  s CardRef=$o(^DHCCARDi("CF",0,"CardNo",ID,CardRef)) q:(CardRef="")||(CardCardRef'="")  d
		.s CurCardTypeDR=$p(^DHCCARD("CF",CardRef),"^",16)
		.q:CurCardTypeDR'=CardTypeDR
		.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
		.s CurCardNo=$p(^DHCCARD("CF",CardRef),"^",6)
		.i ActiveFlag="N" s CardCardRef=CurCardNo
		q CardCardRef   //返回登记号
	}
}

/// Debug: w ##class(web.DHCPE.PreIBIUpdate).InsertAccInfo(2,"00001001",2)
ClassMethod InsertAccInfo(PAPMIDR, CardNo, CFRowID, CardTypeDR, HOSPID)
{
	;i $G(^DHCPESetting("DHCPE","HospitalCode"))'="" q "0^"
	s AccObj=..GetAccObj(PAPMIDR,CardNo)
	s myrtn=0
	s myAccRowID=""
	Set myAccM = ##class(User.DHCAccManager).%New()
	If (myAccM)
	{
		s AccountNo=##class(web.UDHCAccManageCLS).getAccountNo(AccObj.PAPMINo)
		;此帐户号码存在
		q:$d(^DHCACDi("AccM",0,"AccountNo",AccountNo)) "-211^^"		;此帐户号码存在
		s myAccM.AccMAccountNo = AccountNo		;AccountNo
		//Set myAccM.AccMPAPMIDR = AccObj.PAPMIRowID		;_papmi_  门诊表结构修改
		d myAccM.AccMPAPMIDRSetObjectId(AccObj.PAPMIRowID)	
		Set myAccM.AccMPAPMINo = AccObj.PAPMINo			;_RegNo_
		s myAccM.AccMCardNo= AccObj.CardNo				;_CardNo_
		d myAccM.AccMCUserDRSetObjectId(UserDR)		;_user_
		Set myAccM.AccMOCDate = AccObj.OCDate
		Set myAccM.AccMOCTime = AccObj.OCTime
		s myAccM.AccMPassWord = AccObj.PassWord			;_Password_
		s myAccM.AccMAccStatus = "N"			;
		s myAccM.AccMDepPrice = AccObj.Depprice			;_Depprice_
		Set myAccM.AccMType = AccObj.AccountType			;_AccountType_
		//Set myAccM.AccMCredTypeDR = AccObj.CredType			;_CredType_
		d myAccM.AccMCredTypeDRSetObjectId(AccObj.CredType)	    ;_CredType门诊账户表结构修改 20230407
		
		d myAccM.AccMCardTypeDRSetObjectId(CardTypeDR)	        ;_AccMCardTypeDR门诊账户表表结构新增 就诊卡类型 20230407	 
		Set myAccM.AccMCreatMode = "P"                            ;_AccMCreatMode门诊账户表表结构新增  账户创建模式(Person:按患者主索引建账户, Card:按卡建账户) 20230407	 
		d myAccM.AccMHospDRSetObjectId(HOSPID)	                ;_AccMHospDR门诊账户表表结构新增  院区 20230407	 
		
		Set myAccM.AccMCredNo = AccObj.CredNo				;_IDCardNo_
		i (myAccM.AccMCredNo=""){
			s myAccM.AccMCredNo="1"
		}
		b		;Save AccManager
		Set sc = myAccM.%Save()
		If ($System.Status.IsError(sc))	
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-212"
		}else{
			s myAccRowID = myAccM.%Id()
		}
		q:(+myrtn) myrtn_"^"
		
	}
	d myAccM.%Close()
	&SQL(update sqluser.DHC_CardRef set CF_ACCNo_DR=:myAccRowID where CF_RowID=:CFRowID)
	q myrtn_"^"_myAccRowID
}

// s obj=##class(web.DHCPE.PreIBIUpdate).GetAccObj(1,"2009")

ClassMethod GetAccObj(PAPMIRowID, CardNo) As web.DHCEntity.PCA.AccManager
{
	set obj=##class(web.DHCEntity.PCA.AccManager).%New()
	if (obj)
	{
		s obj.AccountType=""
		s obj.CardNo=CardNo
		s obj.CredNo=$p(^PAPER(PAPMIRowID,"ALL"),"^",9)
		s obj.PAPMINo=##Class(web.PAPatMas).GetRegistration(PAPMIRowID)
		//s obj.CredType=""
		//i obj.CredNo'="" s obj.CredType="1"
		s obj.CredType=$P($G(^PAPER(PAPMIRowID,"PAT",3)),"^",7)
		
		s obj.Depprice=0
		s obj.PAPMIRowID=PAPMIRowID
		s obj.OCDate=+$H
		s obj.PassWord=""
		s obj.OCTime=$p($H,",",2)
		s:$d(%session) obj.UserDR=%session.Get("LOGON.USERID")
		s:'$d(%session) obj.UserDR=5918
		s obj.amt=0
	}
	q obj
}

// 

ClassMethod UpdateTel(RegNo, Tel)
{
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s RegNoIndex=RegNo
	s RegNoIndex=$ZCVT(RegNoIndex,"U")
	s PaPatID=$O(^PAPERi("PAPMI_PatNo",RegNoIndex,0))
	q:PaPatID="" "登记号不存在"
	TSTART
	&sql(Update Sqluser.PA_PatMas set PAPMI_MobPhone=:Tel where PAPMI_RowID=:PaPatID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新his信息失败"
	}
	&sql(Update Sqluser.DHC_PE_PreIBaseInfo set PIBI_MobilePhone=:Tel where PIBI_PAPMINo=:RegNo)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新体检信息失败"
	}
	TCOMMIT
	q "更新成功"
}

}
