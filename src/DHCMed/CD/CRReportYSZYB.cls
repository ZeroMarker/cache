/// 名称: DHCMed.CD.CRReportYSZYB
/// 描述: 疑似职业病报卡信息
/// 编写者：zhufei
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportYSZYB Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildYSZYB ];

/// 卡片编号
Property CRKPBH As %String;

/// 用人单位名称
Property CRYRDWMC As %String;

/// 用人单位地址
Property CRYRDWDZ As %String;

/// 用人单位邮编
Property CRYRDWYB As %String;

/// 用人单位联系人
Property CRYRDWLXR As %String;

/// 联系人电话
Property CRYRDWLXRDH As %String;

/// 经济类型
Property CRJJLX As %String;

/// 行业
Property CRDWHY As %String;

/// 企业规模
Property CRQYGM As DHCMed.SS.Dictionary;

/// 病人来源
Property CRBRLY As DHCMed.SS.Dictionary;

/// 职业病种类
Property CRZYBZL As %String;

/// 具体病名
Property CRJTBM As %String;

/// 中毒事故编码
Property CRZDSGBM As %String;

/// 同时中毒人数
Property CRTSZDRS As %String;

/// 统计工种
Property CRTJGZ As DHCMed.SS.Dictionary;

/// 专业工龄年
Property CRZYGLN As %String;

/// 专业工龄月
Property CRZYGLY As %String;

/// 接触时间天
Property CRJCSJT As %String;

/// 接触时间时
Property CRJCSJS As %String;

/// 接触时间分
Property CRJCSJF As %String;

/// 发生日期
Property CRFSRQ As %Date;

/// 诊断日期
Property CRZDRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ParRef取疑似职业病信息
/// Table：       DHCMed.CD.CRReportYSZYB
/// Input：       ID:    DHCMed.CD.CRReportYSZYB.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportYSZYB
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"YSZYB",0))
	Set obj=##class(DHCMed.CD.CRReportYSZYB).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return=..CRKPBH_separete
	Set return=return_..CRYRDWMC_separete	//1
	Set return=return_..CRYRDWDZ_separete
	Set return=return_..CRYRDWYB_separete
	Set return=return_..CRYRDWLXR_separete	//4
	Set return=return_..CRYRDWLXRDH_separete
	Set return=return_..CRJJLX_separete
	Set return=return_..CRDWHY_separete		//7
	Set return=return_..GetDicByObj(..CRQYGM,Languages)_separete
	Set return=return_..GetDicByObj(..CRBRLY,Languages)_separete
	Set return=return_..CRZYBZL_separete	//10
	Set return=return_..CRJTBM_separete
	Set return=return_..CRZDSGBM_separete
	Set return=return_..CRTSZDRS_separete	//13
	Set return=return_..GetDicByObj(..CRTJGZ,Languages)_separete
	Set return=return_..CRZYGLN_separete
	Set return=return_..CRZYGLY_separete	//16
	Set return=return_..CRJCSJT_separete
	Set return=return_..CRJCSJS_separete
	Set return=return_..CRJCSJF_separete	//19
	Set FSRQ=..CRFSRQ
	;Set:FSRQ'="" FSRQ=$zd(FSRQ,3)
	Set:FSRQ'="" FSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FSRQ)
	Set return=return_FSRQ_separete
	Set ZDRQ=..CRZDRQ
	;Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set return=return_ZDRQ_separete
	Set SWRQ=..CRSWRQ
	;Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set return=return_SWRQ_separete
	
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

ClassMethod GetICDDescByID(ICDRowID As %String) As %String
{
	new (ICDRowID)
	set return=""
	Quit:ICDRowID="" return
	
	Set tmp=$g(^MRC("ID",ICDRowID))
	Quit:tmp="" return
	Set ICDDesc=$p(tmp,"^",2)
	
	set return=ICDRowID_$c(1)_ICDDesc
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ParRef取疑似职业病信息
/// Table：       DHCMed.CD.CRReportYSZYB
/// Input：       ID:    DHCMed.CD.CRReportYSZYB.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportYSZYB).GetStringByParRef(13)
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
	
	Set obj=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ID取疑似职业病信息
/// Table：       DHCMed.CD.CRReportYSZYB
/// Input：       ID:    DHCMed.CD.CRReportYSZYB.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportYSZYB).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportYSZYB
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportYSZYB).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportYSZYB).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportYSZYB
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportYSZYB).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"YSZYB",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportYSZYB).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportYSZYB).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("YSZYB")
	}
	Set obj.CRKPBH=CardNo
	Set obj.CRYRDWMC=$p(aInput,separete,3)
	Set obj.CRYRDWDZ=$p(aInput,separete,4)
	Set obj.CRYRDWYB=$p(aInput,separete,5)
	Set obj.CRYRDWLXR=$p(aInput,separete,6)
	Set obj.CRYRDWLXRDH=$p(aInput,separete,7)
	Set obj.CRJJLX=$p(aInput,separete,8)
	Set obj.CRDWHY=$p(aInput,separete,9)
	Set CRQYGMID=$p(aInput,separete,10)
	Set obj.CRQYGM=##class(DHCMed.SS.Dictionary).GetObjById(CRQYGMID)
	Set CRBRLYID=$p(aInput,separete,11)
	Set obj.CRBRLY=##class(DHCMed.SS.Dictionary).GetObjById(CRBRLYID)
	Set obj.CRZYBZL=$p(aInput,separete,12)
	Set obj.CRJTBM=$p(aInput,separete,13)
	Set obj.CRZDSGBM=$p(aInput,separete,14)
	Set obj.CRTSZDRS=$p(aInput,separete,15)
	Set CRTJGZID=$p(aInput,separete,16)
	Set obj.CRTJGZ=##class(DHCMed.SS.Dictionary).GetObjById(CRTJGZID)
	Set obj.CRZYGLN=$p(aInput,separete,17)
	Set obj.CRZYGLY=$p(aInput,separete,18)
	Set obj.CRJCSJT=$p(aInput,separete,19)
	Set obj.CRJCSJS=$p(aInput,separete,20)
	Set obj.CRJCSJF=$p(aInput,separete,21)
	Set CRFSRQ=$p(aInput,separete,22)
	;Set:CRFSRQ'="" CRFSRQ=$zdh(CRFSRQ,3)
	Set:CRFSRQ'="" CRFSRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRFSRQ)
	Set obj.CRFSRQ=CRFSRQ
	Set CRZDRQ=$p(aInput,separete,23)
	;Set:CRZDRQ'="" CRZDRQ=$zdh(CRZDRQ,3)
	Set:CRZDRQ'="" CRZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRZDRQ)
	Set obj.CRZDRQ=CRZDRQ
	Set CRSWRQ=$p(aInput,separete,24)
	;Set:CRSWRQ'="" CRSWRQ=$zdh(CRSWRQ,3)
	Set:CRSWRQ'="" CRSWRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRSWRQ)
	Set obj.CRSWRQ=CRSWRQ
	
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

/// Creator:		zhouruimeng
/// CreatDate:		2015-12-28
/// Description:	取报告的状态
/// Input:			ReportID
/// Return:			StatusCode
/// w ##class(DHCMed.CD.CRReportYSZYB).GetReportStatus(1)
ClassMethod GetReportStatus(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(+aReportID)
	Quit:'$IsObject(objRep) return

	Set RepStatusID=objRep.CRReportStatus.%Id()
	Set RepStatusCode=objRep.CRReportStatus.Code
	
	Set return=RepStatusCode
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRKPBH</Value>
</Value>
<Value name="3">
<Value>CRYRDWMC</Value>
</Value>
<Value name="4">
<Value>CRYRDWDZ</Value>
</Value>
<Value name="5">
<Value>CRYRDWYB</Value>
</Value>
<Value name="6">
<Value>CRYRDWLXR</Value>
</Value>
<Value name="7">
<Value>CRYRDWLXRDH</Value>
</Value>
<Value name="8">
<Value>CRJJLX</Value>
</Value>
<Value name="9">
<Value>CRDWHY</Value>
</Value>
<Value name="10">
<Value>CRQYGM</Value>
</Value>
<Value name="11">
<Value>CRBRLY</Value>
</Value>
<Value name="12">
<Value>CRZYBZL</Value>
</Value>
<Value name="13">
<Value>CRJTBM</Value>
</Value>
<Value name="14">
<Value>CRZDSGBM</Value>
</Value>
<Value name="15">
<Value>CRTSZDRS</Value>
</Value>
<Value name="16">
<Value>CRTJGZ</Value>
</Value>
<Value name="17">
<Value>CRZYGLN</Value>
</Value>
<Value name="18">
<Value>CRZYGLY</Value>
</Value>
<Value name="19">
<Value>CRJCSJT</Value>
</Value>
<Value name="20">
<Value>CRJCSJS</Value>
</Value>
<Value name="21">
<Value>CRJCSJF</Value>
</Value>
<Value name="22">
<Value>CRFSRQ</Value>
</Value>
<Value name="23">
<Value>CRZDRQ</Value>
</Value>
<Value name="24">
<Value>CRSWRQ</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("YSZYB")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("YSZYB")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("YSZYB")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportYSZYBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
