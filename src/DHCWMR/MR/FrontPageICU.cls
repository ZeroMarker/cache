/// 名称 : DHCWMR.MR.FrontPageICU
/// 说明 : 住院病案首页重症监护表【P5】
Class DHCWMR.MR.FrontPageICU Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FrontPage [ Cardinality = parent, Inverse = ChildICU ];

/// 类型
Property PIType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 顺序号
Property PIIndex As %Integer;

/// 流水号
Property PISerialNumber As %Integer;

/// 重症监护室名称
Property PI0100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 重症监护室代码
Property PI0101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进入日期
Property PI0200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进入时间
Property PI0201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 退出日期
Property PI0300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 退出时间
Property PI0301 As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexTypeIndex On (Parref, PIType, PIIndex);

Index IndexSerialNumber On (Parref, PISerialNumber);

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  取重症监护信息
/// Table：       DHCWMR.MR.FrontPageICU
/// Input：       Id : DHCWMR.MR.FrontPageICU.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPageICU).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPageICU
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPageICU).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPageICU).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存重症监护信息
/// Table：       DHCWMR.MR.FrontPageICU
/// Input：       InputStr ：重症监护信息="..."
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPageICU).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set PIType=$p(aInputStr,aSeparate,3)
	Set PIIndex=+$p(aInputStr,aSeparate,4)
	Set PISerialNumber=+$p(aInputStr,aSeparate,5)
	
	Set objParref=##class(DHCWMR.MR.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FrontPageICU).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPageICU).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.PIType         = PIType
	Set obj.PIIndex        = PIIndex
	Set obj.PISerialNumber = PISerialNumber
	Set obj.PI0100         = $p(aInputStr,aSeparate,6)   //重症监护室名称
	Set obj.PI0101         = $p(aInputStr,aSeparate,7)   //重症监护室代码
	Set obj.PI0200         = $p(aInputStr,aSeparate,8)   //进入时间
	Set obj.PI0201         = $p(aInputStr,aSeparate,9)   //进入时间
	Set obj.PI0300         = $p(aInputStr,aSeparate,10)   //退出时间
	Set obj.PI0301         = $p(aInputStr,aSeparate,11)  //退出时间
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
/// Description:  删除重症监护记录
/// Table：       DHCWMR.MR.FrontPageICU
/// Input：       Id : DHCWMR.MR.FrontPageICU.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FrontPageICU).%DeleteId(aId)
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
<Value>PIType</Value>
</Value>
<Value name="3">
<Value>PIIndex</Value>
</Value>
<Value name="4">
<Value>PISerialNumber</Value>
</Value>
<Value name="5">
<Value>PI0100</Value>
</Value>
<Value name="6">
<Value>PI0101</Value>
</Value>
<Value name="7">
<Value>PI0200</Value>
</Value>
<Value name="8">
<Value>PI0201</Value>
</Value>
<Value name="9">
<Value>PI0300</Value>
</Value>
<Value name="10">
<Value>PI0301</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ICU")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ICU")</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageICUI</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageICUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
