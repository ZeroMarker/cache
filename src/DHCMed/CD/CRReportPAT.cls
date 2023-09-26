/// 名称: DHCMed.CD.CRReportPAT
/// 描述: 病人基本信息
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-19
Class DHCMed.CD.CRReportPAT Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildPAT ];

/// 病人ID
Property CRPatientID As %String;

/// 门诊号
Property CRMZH As %String;

/// 住院号
Property CRZYH As %String;

/// 登记号
Property CRDJH As %String;

/// 姓名
Property CRXM As %String;

/// 家长姓名
Property CRJZXM As %String;

/// 性别
Property CRXB As %String;

/// 出生日期
Property CRCSRQ As %Date;

/// 年龄-周岁
Property CRNLS As %String;

/// 年龄-月份
Property CRNLY As %String;

/// 年龄-天数
Property CRNLT As %String;

/// 身份证号
Property CRSFZH As %String;

/// 家庭电话
Property CRJTDH As %String;

/// 民族
Property CRMZ As DHCMed.SS.Dictionary;

/// 婚姻状况
Property CRHYZK As DHCMed.SS.Dictionary;

/// 文化程度
Property CRWHCD As DHCMed.SS.Dictionary;

/// 职业
Property CRZY As DHCMed.SS.Dictionary;

/// 职业备注
Property CRZYTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// fix bug 191716工种不显示
/// 工种
Property CRGZ As DHCMed.SS.Dictionary;

/// 联系人
Property CRLXR As %String;

/// 与病人关系
Property CRYBRGX As DHCMed.SS.Dictionary;

/// 联系电话
Property CRLXDH As %String;

/// 工作单位
Property CRGZDW As %String;

/// 户籍
Property CRHJ As DHCMed.SS.Dictionary;

/// 户籍地址-省
Property CRHJDZS As DHCMed.SS.AreaDic;

/// 户籍地址-市
Property CRHJDZS2 As DHCMed.SS.AreaDic;

/// 户籍地址-县
Property CRHJDZX As DHCMed.SS.AreaDic;

/// 户籍地址-乡
Property CRHJDZX2 As DHCMed.SS.AreaDic;

/// 户籍地址-村(小区)
Property CRHJDZC As %String;

/// 户籍地址详细地址
Property CRHJDZXX As %String(MAXLEN = 500, TRUNCATE = 1);

/// 常住地址-省
Property CRCZDZS As DHCMed.SS.AreaDic;

/// 常住地址-市
Property CRCZDZS2 As DHCMed.SS.AreaDic;

/// 常住地址-县
Property CRCZDZX As DHCMed.SS.AreaDic;

/// 常住地址-乡
Property CRCZDZX2 As DHCMed.SS.AreaDic;

/// 常住地址-村(小区)
Property CRCZDZC As %String;

/// 常住地址详细地址
Property CRCZDZXX As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexPatID On CRPatientID;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取肿瘤卡信息
/// Table：       DHCMed.CD.CRReportPAT
/// Input：       ID:    DHCMed.CD.CRReportPAT.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportPAT).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportPAT
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"PAT",0))
	Set obj=##class(DHCMed.CD.CRReportPAT).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return=..CRPatientID_separete
	Set return=return_..CRMZH_separete
	Set return=return_..CRZYH_separete
	Set return=return_..CRDJH_separete  //3
	Set return=return_..CRXM_separete
	Set return=return_..CRJZXM_separete
	if (Languages="EN"){
		Set CRXB = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,..CRXB)
	}else{
		Set CRXB = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTSex","CTSEXDesc","EN",..CRXB)
	}
	Set return=return_CRXB_separete
	Set CSRQ=..CRCSRQ
	;Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	Set:CSRQ'="" CSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CSRQ)
	Set return=return_CSRQ_separete		//7
	Set return=return_..CRNLS_separete
	Set return=return_..CRNLY_separete
	Set return=return_..CRNLT_separete
	Set return=return_..CRSFZH_separete	//11
	Set return=return_..CRJTDH_separete
	Set return=return_..GetDicByObj(..CRMZ,Languages)_separete
	Set return=return_..GetDicByObj(..CRHYZK,Languages)_separete
	Set return=return_..GetDicByObj(..CRWHCD,Languages)_separete
	Set return=return_..GetDicByObj(..CRZY,Languages)_separete	//16
	//Set return=return_..CRGZ_separete
	Set return=return_..GetDicByObj(..CRGZ,Languages)_separete   //fix bug 191716 工种不显示
	Set return=return_..CRLXR_separete
	Set return=return_..GetDicByObj(..CRYBRGX,Languages)_separete
	Set return=return_..CRLXDH_separete
	Set return=return_..CRGZDW_separete	//21
	Set return=return_..GetDicByObj(..CRHJ,Languages)_separete
	Set return=return_..GetAreaByObj(..CRHJDZS,Languages,1)_separete	//23
	Set return=return_..GetAreaByObj(..CRHJDZS2,Languages,2)_separete
	Set return=return_..GetAreaByObj(..CRHJDZX,Languages,3)_separete
	Set return=return_..GetAreaByObj(..CRHJDZX2,Languages,4)_separete
	Set return=return_..CRHJDZC_separete
	Set return=return_..CRHJDZXX_separete
	Set return=return_..GetAreaByObj(..CRCZDZS,Languages,1)_separete	//29
	Set return=return_..GetAreaByObj(..CRCZDZS2,Languages,2)_separete
	Set return=return_..GetAreaByObj(..CRCZDZX,Languages,3)_separete
	Set return=return_..GetAreaByObj(..CRCZDZX2,Languages,4)_separete
	Set return=return_..CRCZDZC_separete
	Set return=return_..CRCZDZXX_separete
	quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	quit return
}

ClassMethod GetAreaByObj(obj As DHCMed.SS.AreaDic, Languages As %String = "", aFlag As %String = "") As %String
{
	new (obj,Languages,aFlag)
	set return=""
	quit:'$IsObject(obj) return
	if (aFlag=1){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,obj.ShortDesc)	
	}
	if (aFlag=2){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,obj.ShortDesc)
	}
	if (aFlag=3){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,obj.ShortDesc)
	}
	if (aFlag=4){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,obj.ShortDesc)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取患者信息
/// Table：       DHCMed.CD.CRReportPAT
/// Input：       ID:    DHCMed.CD.CRReportPAT.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportPAT).GetStringByParRef(119)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ID取病人信息
/// Table：       DHCMed.CD.CRReportPAT
/// Input：       ID:    DHCMed.CD.CRReportPAT.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportPAT).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportPAT
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportPAT).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportPAT).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据PatientID取病人信息
/// Table：       DHCMed.CD.CRReportPAT
/// Input：       PatientID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportPAT).GetObjByPatId(1)
ClassMethod GetObjByPatId(PatId As %String) As DHCMed.CD.CRReportPAT
{
	new (PatId)
	set return=""
	quit:PatId="" return
	
	Set ID=$o(^DHCMed.CD.CRReportI("PAT","IndexPatID"," "_PatId,""))
	
	set obj=##Class(DHCMed.CD.CRReportPAT).GetObjById(+ID)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-27
/// Description:  更新病人信息
/// Table：       DHCMed.CD.CRReportPAT
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportPAT).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"PAT",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportPAT).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportPAT).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	
	Set obj.CRPatientID=$p(aInput,separete,2)
	Set obj.CRMZH=$p(aInput,separete,3)
	Set obj.CRZYH=$p(aInput,separete,4)
	Set obj.CRDJH=$p(aInput,separete,5)
	Set obj.CRXM=$p(aInput,separete,6)
	Set obj.CRJZXM=$p(aInput,separete,7)
	Set obj.CRXB=$p(aInput,separete,8)
	Set CSRQ=$p(aInput,separete,9)
	;Set:CSRQ'="" CSRQ=$zdh(CSRQ,3)
	Set:CSRQ'="" CSRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CSRQ)
	Set obj.CRCSRQ=CSRQ
	Set obj.CRNLS=$p(aInput,separete,10)
	Set obj.CRNLY=$p(aInput,separete,11)
	Set obj.CRNLT=$p(aInput,separete,12)
	Set obj.CRSFZH=$p(aInput,separete,13)
	Set obj.CRJTDH=$p(aInput,separete,14)
	Set CRMZID=$p(aInput,separete,15)
	Set obj.CRMZ=##class(DHCMed.SS.Dictionary).GetObjById(CRMZID)
	Set CRHYZKID=$p(aInput,separete,16)
	Set obj.CRHYZK=##class(DHCMed.SS.Dictionary).GetObjById(CRHYZKID)
	Set CRWHCDID=$p(aInput,separete,17)
	Set obj.CRWHCD=##class(DHCMed.SS.Dictionary).GetObjById(CRWHCDID)
	Set CRZYID=$p(aInput,separete,18)
	Set obj.CRZY=##class(DHCMed.SS.Dictionary).GetObjById(CRZYID)
	//fix bug 191716工种不显示
	Set CRGZID=$p(aInput,separete,19)
	//Set obj.CRGZ=$p(aInput,separete,19)	//##class(DHCMed.SS.Dictionary).GetObjById(CRGZID)
	Set obj.CRGZ=##class(DHCMed.SS.Dictionary).GetObjById(CRGZID)
	Set obj.CRLXR=$p(aInput,separete,20)
	Set CRYBRGXID=$p(aInput,separete,21)
	Set obj.CRYBRGX=##class(DHCMed.SS.Dictionary).GetObjById(CRYBRGXID)
	Set obj.CRLXDH=$p(aInput,separete,22)
	Set obj.CRGZDW=$p(aInput,separete,23)
	Set CRHJID=$p(aInput,separete,24)
	Set obj.CRHJ=##class(DHCMed.SS.Dictionary).GetObjById(CRHJID)
	Set CRHJDZSID=$p(aInput,separete,25)
	Set obj.CRHJDZS=##class(DHCMed.SS.AreaDic).GetObjById(CRHJDZSID)
	Set CRHJDZS2ID=$p(aInput,separete,26)
	Set obj.CRHJDZS2=##class(DHCMed.SS.AreaDic).GetObjById(CRHJDZS2ID)
	Set CRHJDZXID=$p(aInput,separete,27)
	Set obj.CRHJDZX=##class(DHCMed.SS.AreaDic).GetObjById(CRHJDZXID)
	Set CRHJDZX2ID=$p(aInput,separete,28)
	Set obj.CRHJDZX2=##class(DHCMed.SS.AreaDic).GetObjById(CRHJDZX2ID)
	Set obj.CRHJDZC=$p(aInput,separete,29)
	Set obj.CRHJDZXX=$p(aInput,separete,30)
	Set CRCZDZSID=$p(aInput,separete,31)
	Set obj.CRCZDZS=##class(DHCMed.SS.AreaDic).GetObjById(CRCZDZSID)
	Set CRCZDZS2ID=$p(aInput,separete,32)
	Set obj.CRCZDZS2=##class(DHCMed.SS.AreaDic).GetObjById(CRCZDZS2ID)
	Set CRCZDZXID=$p(aInput,separete,33)
	Set obj.CRCZDZX=##class(DHCMed.SS.AreaDic).GetObjById(CRCZDZXID)
	Set CRCZDZX2ID=$p(aInput,separete,34)
	Set obj.CRCZDZX2=##class(DHCMed.SS.AreaDic).GetObjById(CRCZDZX2ID)
	Set obj.CRCZDZC=$p(aInput,separete,35)
	Set obj.CRCZDZXX=$p(aInput,separete,36)

	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRPatientID</Value>
</Value>
<Value name="3">
<Value>CRMZH</Value>
</Value>
<Value name="4">
<Value>CRZYH</Value>
</Value>
<Value name="5">
<Value>CRDJH</Value>
</Value>
<Value name="6">
<Value>CRXM</Value>
</Value>
<Value name="7">
<Value>CRJZXM</Value>
</Value>
<Value name="8">
<Value>CRXB</Value>
</Value>
<Value name="9">
<Value>CRCSRQ</Value>
</Value>
<Value name="10">
<Value>CRNLS</Value>
</Value>
<Value name="11">
<Value>CRNLY</Value>
</Value>
<Value name="12">
<Value>CRNLT</Value>
</Value>
<Value name="13">
<Value>CRSFZH</Value>
</Value>
<Value name="14">
<Value>CRJTDH</Value>
</Value>
<Value name="15">
<Value>CRMZ</Value>
</Value>
<Value name="16">
<Value>CRHYZK</Value>
</Value>
<Value name="17">
<Value>CRWHCD</Value>
</Value>
<Value name="18">
<Value>CRZY</Value>
</Value>
<Value name="19">
<Value>CRGZ</Value>
</Value>
<Value name="20">
<Value>CRLXR</Value>
</Value>
<Value name="21">
<Value>CRYBRGX</Value>
</Value>
<Value name="22">
<Value>CRLXDH</Value>
</Value>
<Value name="23">
<Value>CRGZDW</Value>
</Value>
<Value name="24">
<Value>CRHJ</Value>
</Value>
<Value name="25">
<Value>CRHJDZS</Value>
</Value>
<Value name="26">
<Value>CRHJDZS2</Value>
</Value>
<Value name="27">
<Value>CRHJDZX</Value>
</Value>
<Value name="28">
<Value>CRHJDZX2</Value>
</Value>
<Value name="29">
<Value>CRHJDZC</Value>
</Value>
<Value name="30">
<Value>CRHJDZXX</Value>
</Value>
<Value name="31">
<Value>CRCZDZS</Value>
</Value>
<Value name="32">
<Value>CRCZDZS2</Value>
</Value>
<Value name="33">
<Value>CRCZDZX</Value>
</Value>
<Value name="34">
<Value>CRCZDZX2</Value>
</Value>
<Value name="35">
<Value>CRCZDZC</Value>
</Value>
<Value name="36">
<Value>CRCZDZXX</Value>
</Value>
<Value name="37">
<Value>CRZYTxt</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PAT")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("PAT")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("PAT")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportPATS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
