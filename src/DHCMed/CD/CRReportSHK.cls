/// 名称: DHCMed.CD.CRReportSHK
/// 描述: 伤害卡信息
/// 编写者：zhufei
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportSHK Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildSHK ];

/// 医院编号
Property CRYYBH As %String;

/// 卡片编号
Property CRKPBH As %String;

/// 伤害发生日期
Property CRSHFSRQ As %Date;

/// 伤害发生时间(h)
Property CRSHFSSJ As %String;

/// 患者就诊日期
Property CRHZJZRQ As %Date;

/// 患者就诊时间(h)
Property CRHZJZSJ As %String;

/// 伤害发生原因
Property CRSHFSYY As DHCMed.SS.Dictionary;

/// 伤害发生地点
Property CRSHFSDD As DHCMed.SS.Dictionary;

/// 伤害发生时活动
Property CRSHFSSHD As DHCMed.SS.Dictionary;

/// 伤害是否故意
Property CRSHSFGY As DHCMed.SS.Dictionary;

/// 伤害性质
Property CRSHXZ As DHCMed.SS.Dictionary;

/// 伤害部位
Property CRSHBW As DHCMed.SS.Dictionary;

/// 伤害严重程度
Property CRSHYZCD As DHCMed.SS.Dictionary;

/// 伤害诊断
Property CRSHZD As %String;

/// 伤害结局
Property CRSHJJ As DHCMed.SS.Dictionary;

/// 产品名称1
Property CRCPMC1 As %String;

/// 产品型号1
Property CRCPXH1 As %String;

/// 产品分类1
Property CRCPFL1 As DHCMed.SS.Dictionary;

/// 产品名称2
Property CRCPMC2 As %String;

/// 产品型号2
Property CRCPXH2 As %String;

/// 产品分类2
Property CRCPFL2 As DHCMed.SS.Dictionary;

/// 典型案例
Property CRDXAL As list Of DHCMed.SS.Dictionary;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-14
/// Description:  根据ParRef取伤害卡信息
/// Table：       DHCMed.CD.CRReportSHK
/// Input：       ID:    DHCMed.CD.CRReportSHK.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportSHK).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportSHK
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"SHK",0))
	Set obj=##class(DHCMed.CD.CRReportSHK).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String) As %String
{
	Set return=..CRYYBH_separete
	Set return=return_..CRKPBH_separete	//1
	;Set return=return_$zd(..CRSHFSRQ,3)_separete
	Set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..CRSHFSRQ)_separete
	Set return=return_..CRSHFSSJ_separete
	;Set return=return_$zd(..CRHZJZRQ,3)_separete	//4
	Set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..CRHZJZRQ)_separete	//4
	Set return=return_..CRHZJZSJ_separete
	Set return=return_..GetDicByObj(..CRSHFSYY)_separete
	Set return=return_..GetDicByObj(..CRSHFSDD)_separete	//7
	Set return=return_..GetDicByObj(..CRSHFSSHD)_separete
	Set return=return_..GetDicByObj(..CRSHSFGY)_separete
	Set return=return_..GetDicByObj(..CRSHXZ)_separete	//10
	Set return=return_..GetDicByObj(..CRSHBW)_separete
	Set return=return_..GetDicByObj(..CRSHYZCD)_separete
	Set return=return_..GetICDDescByID(..CRSHZD)_separete	//13
	Set return=return_..GetDicByObj(..CRSHJJ)_separete
	Set return=return_..CRCPMC1_separete
	Set return=return_..CRCPXH1_separete		//16
	Set return=return_..GetDicByObj(..CRCPFL1)_separete
	Set return=return_..CRCPMC2_separete
	Set return=return_..CRCPXH2_separete	//19
	Set return=return_..GetDicByObj(..CRCPFL2)_separete
	Set DXALs=..CRDXAL
	Set DXALstr=""
	For ind=1:1:DXALs.Count() {
		Set objDic=DXALs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set DXALstr=DXALstr_","_objDic.%Id()
	}
	Set:DXALstr'="" DXALstr=$e(DXALstr,2,$l(DXALstr))
	Set return=return_DXALstr_separete	//21
	
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
	Set ICDCode=$p(tmp,"^",1)
	
	set return=ICDRowID_$c(1)_ICDDesc_$c(1)_ICDCode
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-14
/// Description:  根据ParRef取伤害卡信息
/// Table：       DHCMed.CD.CRReportSHK
/// Input：       ID:    DHCMed.CD.CRReportSHK.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportSHK).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-14
/// Description:  根据ID取伤害卡信息
/// Table：       DHCMed.CD.CRReportSHK
/// Input：       ID:    DHCMed.CD.CRReportSHK.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportSHK).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportSHK
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportSHK).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportSHK).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-14
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportSHK
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportSHK).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"SHK",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportSHK).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportSHK).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set obj.CRYYBH=$p(aInput,separete,2)
	Set CardNo=$p(aInput,separete,3)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("SHK")
	}
	Set obj.CRKPBH=CardNo
	Set SHFSRQ=$p(aInput,separete,4)
	;Set:SHFSRQ'="" SHFSRQ=$zdh(SHFSRQ,3)
	Set:SHFSRQ'="" SHFSRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SHFSRQ)
	Set obj.CRSHFSRQ=SHFSRQ
	Set obj.CRSHFSSJ=$p(aInput,separete,5)
	Set HZJZRQ=$p(aInput,separete,6)
	;Set:HZJZRQ'="" HZJZRQ=$zdh(HZJZRQ,3)
	Set:HZJZRQ'="" HZJZRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(HZJZRQ)
	Set obj.CRHZJZRQ=HZJZRQ
	Set obj.CRHZJZSJ=$p(aInput,separete,7)
	Set SHFSYY=$p(aInput,separete,8)
	Set obj.CRSHFSYY=##class(DHCMed.SS.Dictionary).GetObjById(SHFSYY)
	Set SHFSDD=$p(aInput,separete,9)
	Set obj.CRSHFSDD=##class(DHCMed.SS.Dictionary).GetObjById(SHFSDD)
	Set SHFSSHD=$p(aInput,separete,10)
	Set obj.CRSHFSSHD=##class(DHCMed.SS.Dictionary).GetObjById(SHFSSHD)
	Set SHSFGY=$p(aInput,separete,11)
	Set obj.CRSHSFGY=##class(DHCMed.SS.Dictionary).GetObjById(SHSFGY)
	Set SHXZ=$p(aInput,separete,12)
	Set obj.CRSHXZ=##class(DHCMed.SS.Dictionary).GetObjById(SHXZ)
	Set SHBW=$p(aInput,separete,13)
	Set obj.CRSHBW=##class(DHCMed.SS.Dictionary).GetObjById(SHBW)
	Set SHYZCD=$p(aInput,separete,14)
	Set obj.CRSHYZCD=##class(DHCMed.SS.Dictionary).GetObjById(SHYZCD)
	Set obj.CRSHZD=$p(aInput,separete,15)
	Set SHJJ=$p(aInput,separete,16)
	Set obj.CRSHJJ=##class(DHCMed.SS.Dictionary).GetObjById(SHJJ)
	Set obj.CRCPMC1=$p(aInput,separete,17)
	Set obj.CRCPXH1=$p(aInput,separete,18)
	Set CPFL1=$p(aInput,separete,19)
	Set obj.CRCPFL1=##class(DHCMed.SS.Dictionary).GetObjById(CPFL1)
	Set obj.CRCPMC2=$p(aInput,separete,20)
	Set obj.CRCPXH2=$p(aInput,separete,21)
	Set CPFL2=$p(aInput,separete,22)
	Set obj.CRCPFL2=##class(DHCMed.SS.Dictionary).GetObjById(CPFL2)
	Set DXALs=$p(aInput,separete,23)
	
	While (obj.CRDXAL.Count()>0) {
		Do obj.CRDXAL.RemoveAt(1)
	}
	Set DXALLB=""
	For ind=1:1:$length(DXALs,",") {
		Set DXAL=$p(DXALs,",",ind)
		Continue:($listfind(DXALLB,DXAL)>0)
		Set DXALLB=DXALLB_$lb(DXAL)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DXAL)
		Continue:'$IsObject(objDic)
		Do obj.CRDXAL.Insert(objDic)
	}
	
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
<Value>CRYYBH</Value>
</Value>
<Value name="3">
<Value>CRCPBH</Value>
</Value>
<Value name="4">
<Value>CRSHFSRQ</Value>
</Value>
<Value name="5">
<Value>CRSHFSSJ</Value>
</Value>
<Value name="6">
<Value>CRHZJZRQ</Value>
</Value>
<Value name="7">
<Value>CRHZJZSJ</Value>
</Value>
<Value name="8">
<Value>CRSHFSYY</Value>
</Value>
<Value name="9">
<Value>CRSHFSDD</Value>
</Value>
<Value name="10">
<Value>CRSHFSSHD</Value>
</Value>
<Value name="11">
<Value>CRSHSFGY</Value>
</Value>
<Value name="12">
<Value>CRSHXZ</Value>
</Value>
<Value name="13">
<Value>CRSHBW</Value>
</Value>
<Value name="14">
<Value>CRSHYZCD</Value>
</Value>
<Value name="15">
<Value>CRSHZD</Value>
</Value>
<Value name="16">
<Value>CRSHJJ</Value>
</Value>
<Value name="17">
<Value>CRCPMC1</Value>
</Value>
<Value name="18">
<Value>CRCPXH1</Value>
</Value>
<Value name="19">
<Value>CRCPFL1</Value>
</Value>
<Value name="20">
<Value>CRCPMC2</Value>
</Value>
<Value name="21">
<Value>CRCPXH2</Value>
</Value>
<Value name="22">
<Value>CRCPFL2</Value>
</Value>
<Value name="23">
<Value>CRDXAL</Value>
</Value>
<Value name="24">
<Value>CRKPBH</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SHK")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SHK")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("SHK")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportSHKS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
