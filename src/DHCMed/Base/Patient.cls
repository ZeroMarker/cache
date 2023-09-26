/// 名称：DHCMed.Base.Patient
/// 描述：病人基本信息Pa_PatMas/Pa_Person
/// 编写者：李阳
/// 编写日期：2010-04-04
Class DHCMed.Base.Patient Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 病人ID
/// Pa_PatMas.PAPMI_RowId
Property Papmi As %String(TRUNCATE = 1);

/// 病人就诊卡号码
/// Pa_PatMas.PAPMI_No
Property PapmiNo As %String(TRUNCATE = 1);

/// 病人姓名
/// Pa_PatMas.PAPMI_Name
Property PatientName As %String(TRUNCATE = 1);

/// 性别
/// Pa_PatMas.PAPMI_Sex_DR
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
/// Pa_person.PAPER_Dob
Property Birthday As %String(TRUNCATE = 1);

/// 年龄(年)
/// Pa_person.PAPER_AgeYr
Property Age As %Numeric;

/// 年龄(月)
/// Pa_person.PAPER_AgeMth
Property AgeMonth As %Numeric;

/// 年龄(日)
/// Pa_person.PAPER_AgeDay
Property AgeDay As %Numeric;

/// 身份证号码
/// Pa_person.PAPER_ID
Property PersonalID As %String(TRUNCATE = 1);

/// 证件类型
Property PersonalIDType As %String(TRUNCATE = 1);

/// 证件类型ID add by zhangqy 2020-08-4
Property PersonalIDCode As %String(TRUNCATE = 1);

/// 证件号码
Property PAPMIDVAnumber As %String(TRUNCATE = 1);

/// 省
Property Province As %String(TRUNCATE = 1);

/// 市
Property City As %String(TRUNCATE = 1);

/// 婚姻
Property Marital As %String(TRUNCATE = 1);

/// 民族
Property Nation As %String(TRUNCATE = 1);

/// 联系电话
Property Telephone As %String(TRUNCATE = 1);

/// 学历
Property Education As %String(TRUNCATE = 1);

/// 工作单位
Property WorkAddress As %String(TRUNCATE = 1);

/// 与联系人的关系
Property Relation As %String(TRUNCATE = 1);

/// 联系人地址
Property RelativeAddress As %String(TRUNCATE = 1);

/// 联系人姓名
Property RelativeName As %String(TRUNCATE = 1);

/// 联系人电话
Property RelativeTelephone As %String(TRUNCATE = 1);

/// 住址
Property Address As %String(TRUNCATE = 1);

/// 国籍
Property Country As %String(TRUNCATE = 1);

/// 住院病案号
Property InPatMrNo As %String(TRUNCATE = 1);

/// 门诊病案号
Property OpPatMrNo As %String(TRUNCATE = 1);

/// 手机号（工作电话）
Property MobileTel As %String(TRUNCATE = 1);

/// 住院病案号
Property InPatientMrNo As %String(TRUNCATE = 1);

/// 门诊病案号
Property OutPatientMrNo As %String(TRUNCATE = 1);

/// add by pylian 2015-07-15
/// 死亡日期
Property DeathDate As %String(TRUNCATE = 1);

/// 死亡时间
Property DeathTime As %String(TRUNCATE = 1);

/// s objPatient=##class(DHCMed.Base.Patient).GetPatientByRegNo(140270)
/// 通过病人登记号获取病人信息
ClassMethod GetPatientByRegNo(RegNo As %String) As DHCMed.Base.Patient
{
	q:RegNo="" ""
	s RegNo=$$RegNoCon(RegNo)
	//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	s patientID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	s objPatient=##class(DHCMed.Base.Patient).GetObjById(patientID)
	q objPatient
}

/// 根据PatientID传出基本信息的json串
/// by wuqk 
/// 2011-07-21
/// w ##class(DHCMed.Base.Patient).GetJsonById(142709)
ClassMethod GetJsonById(PAPMIRowId As %String) As %String
{
	set obj=..GetObjById(PAPMIRowId)
	
	quit:'$IsObject(obj) ""
	set json=""
	set cls=##class(%ClassDefinition).%OpenId("DHCMed.Base.Patient")
	for i=1:1:cls.Properties.Count() {
		set strPropertyName=cls.Properties.GetAt(i).Name
		set expression="set strValue=obj."_strPropertyName
		x expression
		set json=json_strPropertyName
		set json=json_":'"_strValue_"',"
	}
	if json'=""{
		set json=$e(json,1,$l(json)-1)
	}
	s json="{"_json_"}"
	quit json
}

/// s objPatient=##class(DHCMed.Base.Patient).GetObjById(356)
ClassMethod GetObjById(PAPMIRowId As %String) As DHCMed.Base.Patient
{
	n (PAPMIRowId,%session)
	Set Languages = "CH"
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
		Set:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set Unkonwn = "未知"
	Set Unkonwn = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Unkonwn)
	Set AgeYearInfo = "岁"
	Set AgeYearInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,AgeYearInfo)
	Set AgeMonthInfo= "月"
	Set AgeMonthInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,AgeMonthInfo)
	Set AgeDayInfo  = "天"
	Set AgeDayInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,AgeDayInfo)
	
	q:PAPMIRowId="" ""
	q:$d(^PAPER(PAPMIRowId))=0 ""
	s obj=##class(DHCMed.Base.Patient).%New()
	s obj.Papmi=PAPMIRowId
	s obj.PapmiNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	s obj.PatientName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	Set Sex = $p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
	Set:Sex'="" Sex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,Sex)
	s obj.Sex=Sex
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	;s:birth'="" obj.Birthday=$zd(birth,3)
	s:birth'="" obj.Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(birth)
	
	//update by zf 20150228 统一调用年龄计算方法
	s ageData=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PAPMIRowId,"","","")	//返回值为“*岁*月*天”
	
	set AgeYear=0,AgeMonth=0,AgeDay=0
	if (ageData=Unkonwn){
		s obj.Age="999"
		s obj.AgeMonth="0"
		s obj.AgeDay="0"
	}
	else{
		if ageData[AgeYearInfo {
			set AgeYear=+ageData
		} else {
			if ageData[AgeMonthInfo {
				set AgeMonth=+ageData
				set AgeDay=+$p(ageData,AgeMonth,2)
			}elseif ageData[AgeDayInfo{
				set AgeDay=+ageData
			}else{
				set AgeDay=0
			}
		}
		s obj.Age=AgeYear
		s obj.AgeMonth=AgeMonth
		s obj.AgeDay=AgeDay
	}
	s PersonalIDTypeID = $p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	s obj.PersonalIDType = $p($g(^PAC("CARD",+PersonalIDTypeID)),"^",2)
	//add by zhangqiy 2020-08-4
	s PersonalIDCode=$O(^DHCMed.SS.DictionaryI("IndexTypeDesc"," FBDSUSCARDTYPE"," "_obj.PersonalIDType,""))
	s obj.PersonalIDCode=PersonalIDCode
	//******************************************************
	//update by yjf 20140618
	//更改身份证号字段PAPMIID为PAPMIDVAnumber
	s obj.PersonalID=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
	s PAPMIDVAnumber=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",6)
	s obj.PAPMIDVAnumber=PAPMIDVAnumber
	Set:(obj.PersonalID="")&&(obj.PersonalIDType["身份证") obj.PersonalID=PAPMIDVAnumber
	// ******************************************************
	// FixBug By PanLei 2014-07-29
	// 修正获取患者省份的Bug
    s ProvinceDR = $p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
    s ProvinceDR = +ProvinceDR
    If (ProvinceDR '= 0) {
	    Set ProvinceDesc = $p($g(^CT("PROV",ProvinceDR)),"^",2)
	}
	// ******************************************************
	
    i $g(ProvinceDesc)["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s obj.Province=$g(ProvinceDesc)
    s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
    s CityBirthDR=+CityBirthDR
    i CityBirthDR'=0 s CityBirthDesc=$p($g(^CT("CIT",CityBirthDR)),"^",2)
    i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)	
	s obj.City=$g(CityBirthDesc)
    s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
    s MaritalDesc=""      ;add by wuqk 2008-07-01
    i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2) 	
	s obj.Marital=$g(MaritalDesc)
    s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
    i nationdr'="" s nationInfo=^CT("NAT",+nationdr) 
	i $g(nationInfo)'="" s nationDesc=$p(nationInfo,"^",2) 
    i $g(nationDesc)'="" d
    .i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)	
    .s nationDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,nationDesc)	
	s obj.Nation=$g(nationDesc)
	s obj.Telephone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
	i obj.Telephone="" d
	.s obj.Telephone =..xGetMobPhone(PAPMIRowId)
	s obj.Telephone=$zstrip(obj.Telephone, "*E'N","","-")		//获取字符串中的数字和-号
    s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
    s educationDesc=""
    i educationdr'="" s educationDesc=$p(^CT("EDU",+educationdr),"^",2)	
	s obj.Education=$g(educationDesc)
	s obj.WorkAddress=..xGetCompany(PAPMIRowId)
	s obj.Relation=..xGetGX(PAPMIRowId)
	s obj.RelativeAddress=..xGetGXAddress(PAPMIRowId)
	s obj.RelativeName=..xGetGXMan(PAPMIRowId)
	s obj.RelativeTelephone=..xGetGXTel(PAPMIRowId)
	s obj.Address=..xGetHomeAddress(PAPMIRowId)
	s obj.InPatientMrNo=..xGetInPatMedicareNo(PAPMIRowId)
	s obj.InPatMrNo=obj.InPatientMrNo
	s obj.OutPatientMrNo=..xGetOutPatMedicareNo(PAPMIRowId)
	s obj.OpPatMrNo=obj.OutPatientMrNo
    s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
    s countryDesc=""
    i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
    s countryDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCountry","CTCOUDesc",Languages,countryDesc)	
	
	s obj.Country=countryDesc
	//add  by pylian 2015-07-15

	Set DeathDate=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",13)
	;Set:DeathDate'="" obj.DeathDate=$zd(DeathDate,3)
	Set:DeathDate'="" obj.DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	Set DeathTime=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",8)
	Set:DeathTime'="" obj.DeathTime=$zt(DeathTime,2)
	q obj
	
RegNoCon(PAPMINo)
	n (PAPMINo)
	q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..Papmi_separete
	set return=return_..PapmiNo_separete
	set return=return_..PatientName_separete
	set return=return_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,..Sex)_separete
	set return=return_..Birthday_separete
	set return=return_..Age_separete
	set return=return_..AgeMonth_separete
	set return=return_..AgeDay_separete
	set return=return_..PersonalID_separete
	set return=return_..Province_separete  //10
	set return=return_..City_separete
	set return=return_..Marital_separete
	set return=return_..Nation_separete
	set return=return_..Telephone_separete
	set return=return_..Education_separete
	set return=return_..WorkAddress_separete
	set return=return_..Relation_separete
	set return=return_..RelativeAddress_separete
	set return=return_..RelativeName_separete
	set return=return_..RelativeTelephone_separete  //20
	set return=return_..Address_separete
	set return=return_..Country_separete
	set return=return_..InPatientMrNo_separete
	set return=return_..OutPatientMrNo_separete	
	set return=return_..PersonalIDType_separete
	//add  by pylian 2015-07-15
	set return=return_..DeathDate_separete	
	set return=return_..DeathTime_separete
	Set returns=return_..PAPMIDVAnumber //证件号码
	quit return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据Pa_PatMas.PAPMI_RowId取用户信息
/// Table：       Pa_PatMas,Pa_Person
/// Input：       id:    Pa_PatMas.PAPMI_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.Patient).GetStringById("","^",10940787)
ClassMethod GetStringById(aPatientID As %String, aSeparete As %String, aEpisodeID As %String = "") As %String
{
	new (aPatientID,aSeparete,aEpisodeID,%session)
	Set Languages = "CH"
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
		Set:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:(aPatientID="")&&(aEpisodeID="") return
	
	set:aEpisodeID'="" aPatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	set obj=..GetObjById(aPatientID)
	if $IsObject(obj){
		set return=obj.ToString($g(aSeparete),Languages)
	}
	
	quit return
}

/// 家庭住址
/// w ##class(DHCMed.Base.Patient).xGetHomeAddress(140)
ClassMethod xGetHomeAddress(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATADDR","",xPapmi)
    i (+configValue=0) {
	    s ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    }
    q ret
}

/// 工作单位
/// w ##class(DHCMed.Base.Patient).xGetCompany(140)
ClassMethod xGetCompany(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATCOMPANY","",xPapmi)
    i (+configValue=0) {
	    s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    }
    i configValue=1 {
    	s ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    }
    q ret
}

/// 住院病历号
/// w ##class(DHCMed.Base.Patient).xGetInPatMedicareNo(140)
ClassMethod xGetInPatMedicareNo(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    
	//病案系统接口调用：病人ID取病案号接口
	Set return=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(xPapmi,"I","","")
	Quit:return'="" return
	
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("INPATIENTMRNO","",xPapmi)
    i (+configValue=0) {
	    ;s ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)   //update 20200511 按产品部要求修改
	   s ret=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(xPapmi,"I","")
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",4)
    }
    q ret
}

/// 门诊病历号
/// w ##class(DHCMed.Base.Patient).xGetOutPatMedicareNo(140)
ClassMethod xGetOutPatMedicareNo(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("OUTPATIENTMRNO","",xPapmi)
    i (+configValue=0) {
	    s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",4)
    }
    i configValue=1 {
    	;s ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)  //update 20200511 按产品部要求修改
    	s ret=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(xPapmi,"O","")
    }
    q ret
}

/// 通过病人的ID取得其联系人的信息 
/// w ##class(DHCMed.Base.Patient).xGetGXMan(140)
ClassMethod xGetGXMan(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATRELNAME","",xPapmi)
    i (+configValue=0) {
	    s ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",13)
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1)
    }
    q ret
}

/// 通过病人的ID取得其联系人地址
/// w ##class(DHCMed.Base.Patient).xGetGXAddress(140)
ClassMethod xGetGXAddress(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATRELADDR","",xPapmi)
    i (+configValue=0) {
	    s ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1)
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"ALL")),"^",5)
    }
    q ret
}

/// 通过病人的ID取得其联系人电话
/// w ##class(DHCMed.Base.Patient).xGetGXTel(140)
ClassMethod xGetGXTel(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATRELTEL","",xPapmi)
    i (+configValue=0) {
	    s ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",11)
	    
	    // 如果PAPER_TelH为空, 电话号码取值改为PAPMI_MobPhone
	    i (ret = "") {
			s ret = $p($g(^PAPER(xPapmi,"PER",4)),"^",21)
	    }
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",8)
    }
    q ret
}

/// 通过病人的ID取得病人与联系人关系
/// w ##class(DHCMed.Base.Patient).xGetGX(140)
ClassMethod xGetGX(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATRELATION","",xPapmi)
    i (+configValue=0) {
	    s GXRowId=$p($g(^PAPER(xPapmi,"EMP")),"^",4) ;字段：PAPER_CTRLT_DR 指向表CT_Relation
	    q:GXRowId="" ret
	    s CTRLTDesc=$p($g(^CT("RLT",GXRowId)),"^",2) ;关系描述对应字段CTRLT_Desc
	    s ret=CTRLTDesc
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"ALL")),"^",4)
    }
    q ret
}

/// 通过病人的ID取得病人手机号(公司电话)
/// w ##class(DHCMed.Base.Patient).xGetMobPhone(140)
ClassMethod xGetMobPhone(xPapmi)
{
 	n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s configValue=##class(DHCMed.SSService.ConfigSrv).GetGlobalValueByKeyHosp("PATMOBPHONE","",xPapmi)
    i (+configValue=0) {
	    s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",21)
    }
    i configValue=1 {
    	s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    }
    q ret
}

/// Creator：     PanLei
/// CreatDate：   2014-06-20
/// Description:  根据患者ID,获取其职业CT_Occupation表CTOCC_Code字段的值
///               若存在,则职业Code
///               若不存在,则返回空
/// Table：       CT_Occupation
/// Input：       argPatientID:患者ID
/// Return：      
/// W ##class(DHCMed.Base.Patient).xGetOccupationCode(44)
ClassMethod xGetOccupationCode(argPatientID As %String) As %String
{
 	New (argPatientID)
    Set return = ""
    Quit:argPatientID="" return
    
    // 校验患者ID
    Set objPat = ..GetObjById(argPatientID)
    Quit:'$IsObject(objPat) return
    
    // 职业RowID
    Set PatCareerRowID = $p($g(^PAPER(argPatientID,"PER",2)),"^",6)
    Quit:PatCareerRowID="" return
    
    Set CTOccupationData = $g(^CT("OCC",PatCareerRowID))
    Quit:CTOccupationData="" return
    
    Set OccupationCode = $p(CTOccupationData,"^",1)
    Set:OccupationCode'="" return=OccupationCode
    
    Quit return
}

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>AgeDay</Value>
</Value>
<Value name="5">
<Value>AgeMonth</Value>
</Value>
<Value name="6">
<Value>Birthday</Value>
</Value>
<Value name="7">
<Value>City</Value>
</Value>
<Value name="8">
<Value>Country</Value>
</Value>
<Value name="9">
<Value>Education</Value>
</Value>
<Value name="10">
<Value>InPatMrNo</Value>
</Value>
<Value name="11">
<Value>InPatientMrNo</Value>
</Value>
<Value name="12">
<Value>Marital</Value>
</Value>
<Value name="13">
<Value>MobileTel</Value>
</Value>
<Value name="14">
<Value>Nation</Value>
</Value>
<Value name="15">
<Value>OpPatMrNo</Value>
</Value>
<Value name="16">
<Value>OutPatientMrNo</Value>
</Value>
<Value name="17">
<Value>Papmi</Value>
</Value>
<Value name="18">
<Value>PapmiNo</Value>
</Value>
<Value name="19">
<Value>PatientName</Value>
</Value>
<Value name="20">
<Value>PersonalID</Value>
</Value>
<Value name="21">
<Value>Province</Value>
</Value>
<Value name="22">
<Value>Relation</Value>
</Value>
<Value name="23">
<Value>RelativeAddress</Value>
</Value>
<Value name="24">
<Value>RelativeName</Value>
</Value>
<Value name="25">
<Value>RelativeTelephone</Value>
</Value>
<Value name="26">
<Value>Sex</Value>
</Value>
<Value name="27">
<Value>Telephone</Value>
</Value>
<Value name="28">
<Value>WorkAddress</Value>
</Value>
<Value name="29">
<Value>PersonalIDType</Value>
</Value>
<Value name="30">
<Value>PAPMIDVAnumber</Value>
</Value>
</Data>
<DataLocation>^DHCMed.Base.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.Base.PatientD</IdLocation>
<IndexLocation>^DHCMed.Base.PatientI</IndexLocation>
<StreamLocation>^DHCMed.Base.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
