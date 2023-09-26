/// 名称 : DHCWMR.MR.FrontPageICD
/// 说明 : 住院病案首页诊断表【P2-P3】
Class DHCWMR.MR.FrontPageICD Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FrontPage [ Cardinality = parent, Inverse = ChildICD ];

/// 类型
Property PDType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 顺序号
Property PDIndex As %Integer;

/// 流水号
Property PDSerialNumber As %Integer;

/// 诊断
Property PD0100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断编码
Property PD0101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院病情
Property PD0200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院病情编码
Property PD0201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院情况
Property PD0300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院情况编码
Property PD0301 As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexTypeIndex On (Parref, PDType, PDIndex);

Index IndexSerialNumber On (Parref, PDSerialNumber);

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  取诊断信息
/// Table：       DHCWMR.MR.FrontPageICD
/// Input：       Id : DHCWMR.MR.FrontPageICD.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPageICD).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPageICD
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPageICD).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPageICD).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存诊断信息
/// Table：       DHCWMR.MR.FrontPageICD
/// Input：       InputStr ：诊断信息="..."
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPageICD).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set PDType=$p(aInputStr,aSeparate,3)
	Set PDIndex=+$p(aInputStr,aSeparate,4)
	Set PDSerialNumber=+$p(aInputStr,aSeparate,5)
	
	Set objParref=##class(DHCWMR.MR.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FrontPageICD).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPageICD).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.PDType         = PDType
	Set obj.PDIndex        = PDIndex
	Set obj.PDSerialNumber = PDSerialNumber
	Set obj.PD0100         = $p(aInputStr,aSeparate,6)   //诊断
	Set obj.PD0101         = $p(aInputStr,aSeparate,7)   //ICD10
	Set obj.PD0200         = $p(aInputStr,aSeparate,8)   //入院病情
	Set obj.PD0201         = $p(aInputStr,aSeparate,9)   //入院病情编码
	Set obj.PD0300         = $p(aInputStr,aSeparate,10)  //出院情况
	Set obj.PD0301         = $p(aInputStr,aSeparate,11)  //出院情况编码
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

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  删除诊断记录
/// Table：       DHCWMR.MR.FrontPageICD
/// Input：       Id : DHCWMR.MR.FrontPageICD.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FrontPageICD).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
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
<Value>PDType</Value>
</Value>
<Value name="3">
<Value>PDIndex</Value>
</Value>
<Value name="4">
<Value>PDSerialNumber</Value>
</Value>
<Value name="5">
<Value>PD0100</Value>
</Value>
<Value name="6">
<Value>PD0101</Value>
</Value>
<Value name="7">
<Value>PD0200</Value>
</Value>
<Value name="8">
<Value>PD0201</Value>
</Value>
<Value name="9">
<Value>PD0300</Value>
</Value>
<Value name="10">
<Value>PD0301</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ICD")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ICD")</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageI("ICD")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
