/// 数据项子类
Class DHCWMR.MQ.DataSubCat Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCWMR.MQ.DataCat [ Cardinality = parent, Inverse = ChildCat ];

/// 描述
Property DSCDesc As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexDesc On DSCDesc [ Unique ];

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  取数据项子类
/// Table：       DHCWMR.MQ.DataSubCat
/// Input：       ID : DHCWMR.MQ.DataSubCatt.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.DataSubCat).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.DataSubCat
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.DataSubCat).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.DataSubCat).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  更新数据项子类
/// Table：       DHCWMR.MQ.DataSubCat
/// Input：       InputStr ：首页数据项子类内容
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataSubCat).Update("2^^主要诊断","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set ParRef=$p(aInputStr,aSeparate,1)
	Set ID=$p(aInputStr,aSeparate,2)
	Set DSCDesc=$p(aInputStr,aSeparate,3)
	Quit:(DSCDesc="")||(ParRef="") return

	Set objParRef=##class(DHCWMR.MQ.DataCat).GetObjById(ParRef)
	Quit:'$isobject(objParRef) return
	if $d(^DHCWMR.MQ.DataCatI("Sub","IndexDesc"," "_$ZCVT(DSCDesc,"U")))
	{
		Set ID=$o(^DHCWMR.MQ.DataCatI("Sub","IndexDesc"," "_$ZCVT(DSCDesc,"U"),ParRef,""))
		Set return=ParRef_"||"_ID
		Quit return 
	}
	
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.DataSubCat).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.DataSubCat).%OpenId(ParRef_"||"_ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ParRef =objParRef
	Set obj.DSCDesc=DSCDesc
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1_"^"_sc
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  删除数据项子类
/// Table：       DHCWMR.MQ.DataSubCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataSubCat).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.DataSubCat).%DeleteId(aId)
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
<Value>DSCDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Sub")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Sub")</IdLocation>
<IndexLocation>^DHCWMR.MQ.DataCatI("Sub")</IndexLocation>
<StreamLocation>^DHCWMR.MQ.DataSubCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
