/// 名称: DHCMed.CD.CRReportGXY
/// 描述: 高血压报卡信息
/// 编写者：chenrui
/// 编写日期: 2022-06-21
Class DHCMed.CD.CRReportGXY Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildGXY ];

/// 卡片编号
Property CRKPBH As %String;

/// 患者类型（PAPER_SocialStatus_DR）
Property CRPatStatus As %String;

/// 家族史 有___多少父母兄弟姐妹
Property CRFamilyConut As %String;

/// 有高血压的是什么关系（可多选）【父、母、兄弟、姐妹】
Property CRRelationDrs As list Of DHCMed.SS.Dictionary;

/// 高血压诊断
Property CRGXYZD As %String;

/// 诊断ICD-10
Property CRGXYZDICD As %String;

/// 体重（公斤）
Property CRWeight As %String;

/// 身高（厘米）
Property CRHeight As %String;

/// 症状(可多选)
Property CRSymptomDrs As list Of DHCMed.SS.Dictionary;

/// 收缩压
Property CRSSY As %String;

/// 舒张压
Property CRSZY As %String;

/// 心率（次/分钟）
Property CRHeartRate As %String;

/// 其他
Property CRResume As %String;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-20
/// Description:  根据ParRef取高血压报卡信息
/// Table：       DHCMed.CD.CRReportGXY
/// Input：       ID:    DHCMed.CD.CRReportGXY.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportGXY).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportGXY
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"GXY",0))
	Set obj=##class(DHCMed.CD.CRReportGXY).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	Set return=..CRKPBH_separete
	Set return=return_..CRPatStatus_separete
	Set return=return_..CRFamilyConut_separete
	Set CRRelationDrs=..CRRelationDrs                   
	Set CRRelationList=""
	For ind=1:1:CRRelationDrs.Count() {
		Set objDic=CRRelationDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set CRRelationList=CRRelationList_","_objDic.%Id()
	}
	Set:CRRelationList'="" CRRelationList=$e(CRRelationList,2,$l(CRRelationList))
	Set return=return_CRRelationList_separete 
	Set return=return_..GetICDDescByID(..CRGXYZD,Languages)_separete
	Set return=return_..CRGXYZDICD_separete
	Set return=return_..CRWeight_separete
	Set return=return_..CRHeight_separete
	Set SymptomDrs=..CRSymptomDrs                   
	Set SymptomList=""
	For ind=1:1:SymptomDrs.Count() {
		Set objDic=SymptomDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set SymptomList=SymptomList_","_objDic.%Id()
	}
	Set:SymptomList'="" SymptomList=$e(SymptomList,2,$l(SymptomList))
	Set return=return_SymptomList_separete 
	Set return=return_..CRSSY_separete
	Set return=return_..CRSZY_separete
	Set return=return_..CRHeartRate_separete
	Set return=return_..CRResume_separete
	
	quit return
}

ClassMethod GetICDDescByID(ICDRowID As %String, Languages As %String = "") As %String
{
	new (ICDRowID,Languages)
	set return=""
	Quit:ICDRowID="" return
	
	Set tmp=$g(^MRC("ID",ICDRowID))
	Quit:tmp="" return
	Set ICDDesc=$p(tmp,"^",2)
	Set ICDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,ICDDesc)
	set return=ICDRowID_$c(1)_ICDDesc
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-20
/// Description:  根据ParRef取高血压报卡信息
/// Table：       DHCMed.CD.CRReportGXY
/// Input：       ID:    DHCMed.CD.CRReportGXY.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportGXY).GetStringByParRef(13)
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
	
	Set obj=##class(DHCMed.CD.CRReportGXY).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-20
/// Description:  根据ID取高血压报卡信息
/// Table：       DHCMed.CD.CRReportGXY
/// Input：       ID:    DHCMed.CD.CRReportGXY.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportGXY).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportGXY
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportGXY).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportGXY).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-20
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportGXY
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportGXY).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"GXY",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportGXY).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportGXY).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("GXY")
	}
	Set obj.CRKPBH=CardNo
	Set obj.CRPatStatus=$p(aInput,separete,3)
	Set obj.CRFamilyConut=$p(aInput,separete,4)
	Set RelationDrs =$p(aInput,separete,5)
	While (obj.CRRelationDrs.Count()>0) {
		Do obj.CRRelationDrs.RemoveAt(1)
	}
	Set RelationList=""
	For ind=1:1:$length(RelationDrs,",") {
		Set RelationDr=$p(RelationDrs,",",ind)
		Continue:($listfind(RelationList,RelationDr)>0)
		Set RelationList=RelationList_$lb(RelationDr)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(RelationDr)
		Continue:'$IsObject(objDic)
		Do obj.CRRelationDrs.Insert(objDic)
	}
	Set obj.CRGXYZD		= $p(aInput,separete,6)
	Set obj.CRGXYZDICD	= $p(aInput,separete,7)
	Set obj.CRWeight	= $p(aInput,separete,8)
	Set obj.CRHeight	= $p(aInput,separete,9)
	Set SymptomDrs		= $p(aInput,separete,10)
	While (obj.CRSymptomDrs.Count()>0) {
		Do obj.CRSymptomDrs.RemoveAt(1)
	}
	Set SymptomList=""
	For ind=1:1:$length(SymptomDrs,",") {
		Set SymptomDr=$p(SymptomDrs,",",ind)
		Continue:($listfind(SymptomList,SymptomDr)>0)
		Set SymptomList=SymptomList_$lb(SymptomDr)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(SymptomDr)
		Continue:'$IsObject(objDic)
		Do obj.CRSymptomDrs.Insert(objDic)
	}
	Set obj.CRSSY		= $p(aInput,separete,11)
	Set obj.CRSZY		= $p(aInput,separete,12)
	Set obj.CRHeartRate	= $p(aInput,separete,13)
	Set obj.CRResume	= $p(aInput,separete,14)
	
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

ClassMethod GetPatStatusByPaadm(aPatientID As %String) As %String
{
	new (aPatientID)
	set return=""
	Quit:aPatientID="" return
	Set xStatusID=+$p($g(^PAPER(aPatientID,"PER",1)),"^",10)
	Set StatusInfo = $g(^CT("SS",xStatusID))
	set return=$p(StatusInfo,"^",2)
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
<Value>CRPatStatus</Value>
</Value>
<Value name="4">
<Value>CRFamilyConut</Value>
</Value>
<Value name="5">
<Value>CRRelationDrs</Value>
</Value>
<Value name="6">
<Value>CRGXYZD</Value>
</Value>
<Value name="7">
<Value>CRGXYZDICD</Value>
</Value>
<Value name="8">
<Value>CRWeight</Value>
</Value>
<Value name="9">
<Value>CRHeight</Value>
</Value>
<Value name="10">
<Value>CRSymptomDrs</Value>
</Value>
<Value name="11">
<Value>CRSSY</Value>
</Value>
<Value name="12">
<Value>CRSZY</Value>
</Value>
<Value name="13">
<Value>CRHeartRate</Value>
</Value>
<Value name="14">
<Value>CRResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GXY")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("GXY")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("GXY")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportGXYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
