/// 名称: DHCMed.CD.CRReportNYZD
/// 描述: 农药中毒报卡信息
/// 编写者：zhufei
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportNYZD Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildNYZD ];

/// 卡片编号
Property CRKPBH As %String;

/// 中毒农药名称
Property CRZDNYMC As %String;

/// 农药种类数量
Property CRNYZLSL As DHCMed.SS.Dictionary;

/// 中毒原因
Property CRZDYY As DHCMed.SS.Dictionary;

/// 知识培训
Property CRZSPX As DHCMed.SS.Dictionary;

/// 施药方式
Property CRSYFS As DHCMed.SS.Dictionary;

/// 危险行为
Property CRWXXW As list Of DHCMed.SS.Dictionary;

/// 转归
Property CRZDZG As DHCMed.SS.Dictionary;

/// 诊断日期
Property CRZDRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ParRef取农药中毒信息
/// Table：       DHCMed.CD.CRReportNYZD
/// Input：       ID:    DHCMed.CD.CRReportNYZD.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportNYZD
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"NYZD",0))
	Set obj=##class(DHCMed.CD.CRReportNYZD).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String) As %String
{
	Set return=..CRKPBH_separete
	Set return=return_..CRZDNYMC_separete
	Set return=return_..GetDicByObj(..CRNYZLSL)_separete
	Set return=return_..GetDicByObj(..CRZDYY)_separete
	Set return=return_..GetDicByObj(..CRZSPX)_separete
	Set return=return_..GetDicByObj(..CRSYFS)_separete
	Set WXXW=..CRWXXW
	Set WXXWstr=""
	For ind=1:1:WXXW.Count() {
		Set objDic=WXXW.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set WXXWstr=WXXWstr_","_objDic.%Id()
	}
	Set:WXXWstr'="" WXXWstr=$e(WXXWstr,2,$l(WXXWstr))
	Set return=return_WXXWstr_separete
	
	Set return=return_..GetDicByObj(..CRZDZG)_separete
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
/// CreatDate：   2015-09-16
/// Description:  根据ParRef取农药中毒信息
/// Table：       DHCMed.CD.CRReportNYZD
/// Input：       ID:    DHCMed.CD.CRReportNYZD.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportNYZD).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ID取农药中毒信息
/// Table：       DHCMed.CD.CRReportNYZD
/// Input：       ID:    DHCMed.CD.CRReportNYZD.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportNYZD).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportNYZD
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportNYZD).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportNYZD).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportNYZD
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportNYZD).Update("31^2015050002^qqqq^8842^8845^8855^8859^8863,8867,8871,8864,8868^8853^2015-09-15^2015-09-07","^")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"NYZD",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportNYZD).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportNYZD).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("NYZD")
	}
	Set obj.CRKPBH=CardNo
	Set obj.CRZDNYMC=$p(aInput,separete,3)
	Set NYZLSLID=$p(aInput,separete,4)
	Set obj.CRNYZLSL=##class(DHCMed.SS.Dictionary).GetObjById(NYZLSLID)
	Set ZDYYID=$p(aInput,separete,5)
	Set obj.CRZDYY=##class(DHCMed.SS.Dictionary).GetObjById(ZDYYID)
	Set ZSPXID=$p(aInput,separete,6)
	Set obj.CRZSPX=##class(DHCMed.SS.Dictionary).GetObjById(ZSPXID)
	Set SYFSID=$p(aInput,separete,7)
	Set obj.CRSYFS=##class(DHCMed.SS.Dictionary).GetObjById(SYFSID)
	Set WXXWIDs=$p(aInput,separete,8)
	
	While (obj.CRWXXW.Count()>0) {
		Do obj.CRWXXW.RemoveAt(1)
	}
	Set WXXWIDLB=""
	For ind=1:1:$length(WXXWIDs,",") {
		Set WXXWID=$p(WXXWIDs,",",ind)
		Continue:($listfind(WXXWIDLB,WXXWID)>0)
		Set WXXWIDLB=WXXWIDLB_$lb(WXXWID)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(WXXWID)
		Continue:'$IsObject(objDic)
		Do obj.CRWXXW.Insert(objDic)
	}
	
	Set ZDZGID=$p(aInput,separete,9)
	Set obj.CRZDZG=##class(DHCMed.SS.Dictionary).GetObjById(ZDZGID)
	Set ZDRQ=$p(aInput,separete,10)
	;Set:ZDRQ'="" ZDRQ=$zdh(ZDRQ,3)
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ZDRQ)
	Set obj.CRZDRQ=ZDRQ
	Set SWRQ=$p(aInput,separete,11)
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
<Value>CRZDNYMC</Value>
</Value>
<Value name="4">
<Value>CRZDNYZL</Value>
</Value>
<Value name="5">
<Value>CRNYZLSL</Value>
</Value>
<Value name="6">
<Value>CRZDLX</Value>
</Value>
<Value name="7">
<Value>CRZDZG</Value>
</Value>
<Value name="8">
<Value>CRZDRQ</Value>
</Value>
<Value name="9">
<Value>CRSWRQ</Value>
</Value>
<Value name="10">
<Value>CRZDYY</Value>
</Value>
<Value name="11">
<Value>CRZSPX</Value>
</Value>
<Value name="12">
<Value>CRSYFS</Value>
</Value>
<Value name="13">
<Value>CRWXXW</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NYZD")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("NYZD")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("NYZD")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportNYZDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
