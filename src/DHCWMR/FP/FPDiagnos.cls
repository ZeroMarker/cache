/// 病案编目诊断信息
Class DHCWMR.FP.FPDiagnos Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.FrontPage [ Cardinality = parent, Inverse = ChildDiagnos ];

/// 诊断库版本
Property FPDVCode As DHCWMR.FP.ICDVersion;

/// 顺序号
Property FPDIndex As %Integer;

/// 诊断ICD
Property FPDICDDr As DHCWMR.FP.ICDDx;

/// 诊断类型("FPICDType")
Property FPDType As DHCWMR.SS.Dictionary;

/// 入院病情("DiseaseResult")
Property FPDAdmitCond As DHCWMR.SS.Dictionary;

/// 出院情况("Prognosis")
Property FPDDischCond As DHCWMR.SS.Dictionary;

/// 确诊/未确诊("QuestionDiagnose")
Property FPDIsDefinite As DHCWMR.SS.Dictionary;

/// 首页数据（"#"分隔）
Property FPDDataSource As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 暂存数据（"^"分隔）
Property FPDTempData As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 顺序号 索引
Index IndexFPDIndex On (Parref, FPDIndex);

/// 类型、顺序号 索引
Index IndexTypeIndex On (Parref, FPDType, FPDIndex);

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  根据ID取编目诊断信息
/// Table：       DHCWMR.FP.FPDiagnos
/// Input：       Id : DHCWMR.FP.FPDiagnos.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.FPDiagnos).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.FPDiagnos
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.FPDiagnos).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.FPDiagnos).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  更新编目诊断信息
/// Table：       DHCWMR.FP.FPDiagnos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.FPDiagnos).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set VCode=$p(aInputStr,aSeparate,3)
	Set RowIndex=+$p(aInputStr,aSeparate,4)
	Set ICDDr=$p(aInputStr,aSeparate,5)
	Set Type=$p(aInputStr,aSeparate,6)
	Set AdmitCond=$p(aInputStr,aSeparate,7)
	Set DischCond=$p(aInputStr,aSeparate,8)
	Set IsDefinite=$p(aInputStr,aSeparate,9)
	Set DataSource=$p(aInputStr,aSeparate,10)
	Set TempData=$p(aInputStr,aSeparate,11)
	Quit:(Parref="") return
	
	Set objICD=##class(DHCWMR.FP.ICDDx).GetObjById(ICDDr)
	If $IsObject(objICD){
		Set objVersion=objICD.IDVCode
	} Else {
		Set objVersion=""
	}
	
	Set objParref=##class(DHCWMR.FP.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.FP.FPDiagnos).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.FPDiagnos).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref        = objParref
	Set obj.FPDVCode      = objVersion
	Set obj.FPDIndex      = RowIndex
	Set obj.FPDICDDr      = objICD
	Set obj.FPDType       = ##class(DHCWMR.SS.Dictionary).GetObjById(Type)
	Set obj.FPDAdmitCond  = ##class(DHCWMR.SS.Dictionary).GetObjById(AdmitCond)
	Set obj.FPDDischCond  = ##class(DHCWMR.SS.Dictionary).GetObjById(DischCond)
	Set obj.FPDIsDefinite = ##class(DHCWMR.SS.Dictionary).GetObjById(IsDefinite)
	Set obj.FPDDataSource = DataSource
	Set obj.FPDTempData   = TempData
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  删除编目诊断信息
/// Table：       DHCWMR.FP.FPDiagnos
/// Input：       Id : DHCWMR.FP.FPDiagnos.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.FPDiagnos).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FPDVCode</Value>
</Value>
<Value name="3">
<Value>FPDIndex</Value>
</Value>
<Value name="4">
<Value>FPDICDDr</Value>
</Value>
<Value name="5">
<Value>FPDType</Value>
</Value>
<Value name="6">
<Value>FPDAdmitCond</Value>
</Value>
<Value name="7">
<Value>FPDDischCond</Value>
</Value>
<Value name="8">
<Value>FPDIsDefinite</Value>
</Value>
<Value name="9">
<Value>FPDDataSource</Value>
</Value>
<Value name="10">
<Value>FPDTempData</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("D")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("D")</IdLocation>
<IndexLocation>^DHCWMR.FP.FrontPageI("FPD")</IndexLocation>
<StreamLocation>^DHCWMR.FP.FPDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
