/// 数据项大类
Class DHCWMR.MQ.DataCat Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildCat As DHCWMR.MQ.DataSubCat [ Cardinality = children, Inverse = ParRef ];

/// 描述
Property DCDesc As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexDesc On DCDesc [ Unique ];

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  取数据项大类
/// Table：       DHCWMR.MQ.DataCat
/// Input：       ID : DHCWMR.MQ.DataCat.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.DataCat).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.DataCat
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.DataCat).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.DataCat).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-03-31
/// Description:  更新数据项大类
/// Table：       DHCWMR.MQ.DataCat
/// Input：       InputStr ：首页数据项大类内容
///               Separate : 分隔符（不允许带"^"）
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataCat).Update("^患者信息","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set DCDesc=$p(aInputStr,aSeparate,2)
	Quit:DCDesc="" return
	if $d(^DHCWMR.MQ.DataCatI("IndexDesc"," "_$ZCVT(DCDesc,"U"))){
		Set ID=$o(^DHCWMR.MQ.DataCatI("IndexDesc"," "_$ZCVT(DCDesc,"U"),""))
		Quit ID 
	}
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.DataCat).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.DataCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.DCDesc=DCDesc
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
/// Description:  删除数据项大类
/// Table：       DHCWMR.MQ.DataCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataCat).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.DataCat).%DeleteId(aId)
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
<Value>DCDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MQ.DataCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCWMR.MQ.DataCatD</IdLocation>
<IndexLocation>^DHCWMR.MQ.DataCatI</IndexLocation>
<StreamLocation>^DHCWMR.MQ.DataCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
