/// 名称: DHCMed.CD.CRReportGWZS
/// 描述: 高温中暑报卡信息
/// 编写者：zhufei
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportGWZS Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildGWZS ];

/// 卡片编号
Property CRKPBH As %String;

/// 中暑性质
Property CRZSXZ As DHCMed.SS.Dictionary;

/// 中暑地点
Property CRZSDD As %String;

/// 中暑临床表现
Property CRZSLCBX As %String(MAXLEN = 300);

/// 中暑诊断
Property CRZSZD As DHCMed.SS.Dictionary;

/// 治疗概要
Property CRZLGY As %String(MAXLEN = 500);

/// 转归
Property CRZSZG As DHCMed.SS.Dictionary;

/// 诊断日期
Property CRZDRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-17
/// Description:  根据ParRef取高温中暑信息
/// Table：       DHCMed.CD.CRReportGWZS
/// Input：       ID:    DHCMed.CD.CRReportGWZS.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportGWZS
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"GWZS",0))
	Set obj=##class(DHCMed.CD.CRReportGWZS).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String) As %String
{
	Set return=..CRKPBH_separete
	Set return=return_..GetDicByObj(..CRZSXZ)_separete
	Set return=return_..CRZSDD_separete
	Set return=return_..CRZSLCBX_separete
	Set return=return_..GetDicByObj(..CRZSZD)_separete
	Set return=return_..CRZLGY_separete
	Set return=return_..GetDicByObj(..CRZSZG)_separete
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

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.Description
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
/// CreatDate：   2015-09-17
/// Description:  根据ParRef取高温中暑信息
/// Table：       DHCMed.CD.CRReportGWZS
/// Input：       ID:    DHCMed.CD.CRReportGWZS.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportGWZS).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-17
/// Description:  根据ID取高温中暑信息
/// Table：       DHCMed.CD.CRReportGWZS
/// Input：       ID:    DHCMed.CD.CRReportGWZS.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportGWZS).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportGWZS
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportGWZS).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportGWZS).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-17
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportGWZS
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportGWZS).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"GWZS",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportGWZS).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportGWZS).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("GWZS")
	}
	Set obj.CRKPBH=CardNo
	Set ZSXZID=$p(aInput,separete,3)
	Set obj.CRZSXZ=##class(DHCMed.SS.Dictionary).GetObjById(ZSXZID)
	Set obj.CRZSDD=$p(aInput,separete,4)
	Set obj.CRZSLCBX=$p(aInput,separete,5)
	Set ZSZDID=$p(aInput,separete,6)
	Set obj.CRZSZD=##class(DHCMed.SS.Dictionary).GetObjById(ZSZDID)
	Set obj.CRZLGY=$p(aInput,separete,7)
	Set ZSZGID=$p(aInput,separete,8)
	Set obj.CRZSZG=##class(DHCMed.SS.Dictionary).GetObjById(ZSZGID)
	Set ZDRQ=$p(aInput,separete,9)
	;Set:ZDRQ'="" ZDRQ=$zdh(ZDRQ,3)
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ZDRQ)
	Set obj.CRZDRQ=ZDRQ
	Set SWRQ=$p(aInput,separete,10)
	;Set:SWRQ'="" SWRQ=$zdh(SWRQ,3)
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SWRQ)
	Set obj.CRSWRQ=SWRQ
	
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
<Value>CRKPBH</Value>
</Value>
<Value name="3">
<Value>CRZSXZ</Value>
</Value>
<Value name="4">
<Value>CRZSDD</Value>
</Value>
<Value name="5">
<Value>CRZSLCBX</Value>
</Value>
<Value name="6">
<Value>CRZSZD</Value>
</Value>
<Value name="7">
<Value>CRZLGY</Value>
</Value>
<Value name="8">
<Value>CRZSZG</Value>
</Value>
<Value name="9">
<Value>CRZDRQ</Value>
</Value>
<Value name="10">
<Value>CRSWRQ</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GWZS")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("GWZS")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("GWZS")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportGWZSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
