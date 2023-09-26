/// 查询输出列
Class DHCWMR.MQ.CondColConfig Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCWMR.MQ.CondConfig [ Cardinality = parent, Inverse = ChildCol ];

/// 输出子类
Property ColSubCat As DHCWMR.MQ.DataSubCat;

/// 输出数据项
Property ColDataItem As DHCWMR.MQ.DataItems;

Index IndexDataItem On ColDataItem;

Index IndexColSubCat On ColSubCat;

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  取输出列
/// Table：       DHCWMR.MQ.CondColConfig
/// Input：       ID : DHCWMR.MQ.CondColConfigt.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.CondColConfig).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.CondColConfig
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.CondColConfig).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.CondColConfig).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  更新输出列
/// Table：       DHCWMR.MQ.CondColConfig
/// Input：       InputStr ：首页数据项子类内容
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.CondColConfig).Update("1^^^1||1","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set ParRef=$p(aInputStr,aSeparate,1)
	Set ID=$p(aInputStr,aSeparate,2)
	Set ColSubCat=$p(aInputStr,aSeparate,3)
	Set DataItemID=$p(aInputStr,aSeparate,4)
	Quit:((ColSubCat="")&&(DataItemID=""))||((ColSubCat'="")&&(DataItemID'="")) return
	Quit:ParRef="" return
	
	Set objParRef = ##class(DHCWMR.MQ.CondConfig).GetObjById(ParRef)
	Quit:'$isobject(objParRef) return
	
	Set:ColSubCat'="" ID =$o(^DHCWMR.MQ.CondConfigI("Col","IndexColSubCat",ColSubCat,ParRef,""))
	Set:DataItemID'="" ID =$o(^DHCWMR.MQ.CondConfigI("Col","IndexDataItem",DataItemID,ParRef,""))
	Set objDataItem=##class(DHCWMR.MQ.DataItems).GetObjById(DataItemID)
	Set objColSubCat=##class(DHCWMR.MQ.DataSubCat).GetObjById(ColSubCat)
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.CondColConfig).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.CondColConfig).%OpenId(ParRef_"||"_ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ParRef = objParRef
	Set obj.ColDataItem = objDataItem
	Set obj.ColSubCat= objColSubCat
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
/// Description:  删除输出列
/// Table：       DHCWMR.MQ.CondColConfig
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.CondColConfig).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.CondColConfig).%DeleteId(aId)
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
<Value>ColSubCat</Value>
</Value>
<Value name="3">
<Value>ColDataItem</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Col")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Col")</IdLocation>
<IndexLocation>^DHCWMR.MQ.CondConfigI("Col")</IndexLocation>
<StreamLocation>^DHCWMR.MQ.CondColConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
