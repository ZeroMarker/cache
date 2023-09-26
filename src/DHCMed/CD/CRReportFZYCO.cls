/// 名称: DHCMed.CD.CRReportFZYCO
/// 描述: 非职业CO信息
/// 编写者：zhufei
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportFZYCO Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildFZYCO ];

/// 卡片编号
Property CRKPBH As %String;

/// 中毒日期
Property CRCOZDRQ As %Date;

/// 中毒时间
Property CRCOZDSJ As %Time;

/// 中毒原因
Property CRZDYY As DHCMed.SS.Dictionary;

/// 中毒场所
Property CRZDCS As DHCMed.SS.Dictionary;

/// 中毒因素
Property CRZDYS As DHCMed.SS.Dictionary;

/// 主要症状
Property CRZYZZ As list Of DHCMed.SS.Dictionary;

/// 中毒诊断
Property CRZDZD As DHCMed.SS.Dictionary;

/// 救治措施
Property CRJZCS As list Of DHCMed.SS.Dictionary;

/// 转归
Property CRCOZG As DHCMed.SS.Dictionary;

/// 诊断日期
Property CRZDRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ParRef取非职业CO信息
/// Table：       DHCMed.CD.CRReportFZYCO
/// Input：       ID:    DHCMed.CD.CRReportFZYCO.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportFZYCO
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"FZYCO",0))
	Set obj=##class(DHCMed.CD.CRReportFZYCO).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String) As %String
{
	Set return=..CRKPBH_separete
	Set COZDRQ=..CRCOZDRQ
	;Set:COZDRQ'="" COZDRQ=$zd(COZDRQ,3)
	Set:COZDRQ'="" COZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(COZDRQ)
	Set return=return_COZDRQ_separete	//1
	Set COZDSJ=..CRCOZDSJ
	Set:COZDSJ'="" COZDSJ=$zt(COZDSJ,2)
	Set return=return_COZDSJ_separete
	Set return=return_..GetDicByObj(..CRZDYY)_separete	//3
	Set return=return_..GetDicByObj(..CRZDCS)_separete
	Set return=return_..GetDicByObj(..CRZDYS)_separete
	
	Set ZYZZ=..CRZYZZ
	Set ZYZZstr=""
	For ind=1:1:ZYZZ.Count() {
		Set objDic=ZYZZ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set ZYZZstr=ZYZZstr_","_objDic.%Id()
	}
	Set:ZYZZstr'="" ZYZZstr=$e(ZYZZstr,2,$l(ZYZZstr))
	Set return=return_ZYZZstr_separete	//6
	
	Set return=return_..GetDicByObj(..CRZDZD)_separete
	
	Set JZCS=..CRJZCS
	Set JZCSstr=""
	For ind=1:1:JZCS.Count() {
		Set objDic=JZCS.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set JZCSstr=JZCSstr_","_objDic.%Id()
	}
	Set:JZCSstr'="" JZCSstr=$e(JZCSstr,2,$l(JZCSstr))
	Set return=return_JZCSstr_separete
	
	Set return=return_..GetDicByObj(..CRCOZG)_separete	//9
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
/// Description:  根据ParRef取非职业CO信息
/// Table：       DHCMed.CD.CRReportFZYCO
/// Input：       ID:    DHCMed.CD.CRReportFZYCO.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportFZYCO).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  根据ID取非职业CO信息
/// Table：       DHCMed.CD.CRReportFZYCO
/// Input：       ID:    DHCMed.CD.CRReportFZYCO.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportFZYCO).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportFZYCO
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportFZYCO).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportFZYCO).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportFZYCO
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportFZYCO).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"FZYCO",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportFZYCO).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportFZYCO).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("FZYCO")
	}
	Set obj.CRKPBH=CardNo
	Set COZDRQ=$p(aInput,separete,3)
	;Set:COZDRQ'="" COZDRQ=$zdh(COZDRQ,3)
	Set:COZDRQ'="" COZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(COZDRQ)
	Set obj.CRCOZDRQ=COZDRQ
	Set COZDSJ=$p(aInput,separete,4)
	Set:COZDSJ'="" COZDSJ=$zth(COZDSJ,2)
	Set obj.CRCOZDSJ=COZDSJ
	Set ZDYYID=$p(aInput,separete,5)
	Set obj.CRZDYY=##class(DHCMed.SS.Dictionary).GetObjById(ZDYYID)
	Set ZDCSID=$p(aInput,separete,6)
	Set obj.CRZDCS=##class(DHCMed.SS.Dictionary).GetObjById(ZDCSID)
	Set ZDYSID=$p(aInput,separete,7)
	Set obj.CRZDYS=##class(DHCMed.SS.Dictionary).GetObjById(ZDYSID)
	Set ZYZZIDs=$p(aInput,separete,8)
	
	While (obj.CRZYZZ.Count()>0) {
		Do obj.CRZYZZ.RemoveAt(1)
	}
	Set ZYZZIDLB=""
	For ind=1:1:$length(ZYZZIDs,",") {
		Set ZYZZID=$p(ZYZZIDs,",",ind)
		Continue:($listfind(ZYZZIDLB,ZYZZID)>0)
		Set ZYZZIDLB=ZYZZIDLB_$lb(ZYZZID)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(ZYZZID)
		Continue:'$IsObject(objDic)
		Do obj.CRZYZZ.Insert(objDic)
	}
	
	Set ZDZDID=$p(aInput,separete,9)
	Set obj.CRZDZD=##class(DHCMed.SS.Dictionary).GetObjById(ZDZDID)
	Set JZCSIDs=$p(aInput,separete,10)
	
	While (obj.CRJZCS.Count()>0) {
		Do obj.CRJZCS.RemoveAt(1)
	}
	Set JZCSIDLB=""
	For ind=1:1:$length(JZCSIDs,",") {
		Set JZCSID=$p(JZCSIDs,",",ind)
		Continue:($listfind(JZCSIDLB,JZCSID)>0)
		Set JZCSIDLB=JZCSIDLB_$lb(JZCSID)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(JZCSID)
		Continue:'$IsObject(objDic)
		Do obj.CRJZCS.Insert(objDic)
	}
	
	Set COZGID=$p(aInput,separete,11)
	Set obj.CRCOZG=##class(DHCMed.SS.Dictionary).GetObjById(COZGID)
	Set ZDRQ=$p(aInput,separete,12)
	;Set:ZDRQ'="" ZDRQ=$zdh(ZDRQ,3)
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ZDRQ)
	Set obj.CRZDRQ=ZDRQ
	Set SWRQ=$p(aInput,separete,13)
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
<Value>CRCOZDRQ</Value>
</Value>
<Value name="3">
<Value>CRCOZDSJ</Value>
</Value>
<Value name="4">
<Value>CRZDYY</Value>
</Value>
<Value name="5">
<Value>CRZDCS</Value>
</Value>
<Value name="6">
<Value>CRZDYS</Value>
</Value>
<Value name="7">
<Value>CRZYZZ</Value>
</Value>
<Value name="8">
<Value>CRZDZD</Value>
</Value>
<Value name="9">
<Value>CRJZCS</Value>
</Value>
<Value name="10">
<Value>CRZDZG</Value>
</Value>
<Value name="11">
<Value>CRZDRQ</Value>
</Value>
<Value name="12">
<Value>CRSWRQ</Value>
</Value>
<Value name="13">
<Value>CRCOZG</Value>
</Value>
<Value name="14">
<Value>CRKPBH</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FZYCO")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FZYCO")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("FZYCO")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportFZYCOS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
