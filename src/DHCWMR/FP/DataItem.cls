/// 数据项定义
Class DHCWMR.FP.DataItem Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildLnk As DHCWMR.FP.DataItemLnk [ Cardinality = children, Inverse = Parref ];

/// 代码（D01-001、O01-001、E01-001）
Property DICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property DIDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property DIResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On DICode [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  取编目数据项
/// Table：       DHCWMR.FP.DataItem
/// Input：       ID : DHCWMR.FP.DataItem.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.DataItem).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.DataItem
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.DataItem).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.DataItem).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  更新编目数据项
/// Table：       DHCWMR.FP.DataItem
/// Input：       InputStr ：记录信息（1ID、2代码、3描述、4备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.DataItem).Update("^D01-001^ICD10-主要诊断^","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set:$g(aSeparate)="" aSeparate=..#SEPARATE
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID     = $p(aInputStr,aSeparate,1)
	Set DICode = $p(aInputStr,aSeparate,2)
	Set DIDesc = $p(aInputStr,aSeparate,3)
	Set Resume = $p(aInputStr,aSeparate,4)
	Quit:(DICode="")||(DIDesc="") return
	Quit:(ID="")&&($d(^DHCWMR.FP.DataItemI("IndexCode"," "_$ZCVT(DICode,"U")))) -100  //fix bug 6538

	If ID="" {
		Set obj=##class(DHCWMR.FP.DataItem).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.DataItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DICode   = DICode
	Set obj.DIDesc   = DIDesc
	Set obj.DIResume = Resume
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

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  删除编目数据项
/// Table：       DHCWMR.FP.DataItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.FP.DataItem).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.DataItem).%DeleteId(aId)
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
<Value>DICode</Value>
</Value>
<Value name="3">
<Value>DIDesc</Value>
</Value>
<Value name="4">
<Value>DIResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.DataItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.DataItemD</IdLocation>
<IndexLocation>^DHCWMR.FP.DataItemI</IndexLocation>
<StreamLocation>^DHCWMR.FP.DataItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
