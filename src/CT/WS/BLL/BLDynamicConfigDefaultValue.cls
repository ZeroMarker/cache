Class CT.WS.BLL.BLDynamicConfigDefaultValue Extends %Persistent
{

/// Creator：      dujinrong
/// CreatDate：    2013-12-26
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        属性TableName：ClassName,TableName：morenzhi 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigDefaultValue).AddRecord("CT.WS.CustomDictionary", "ID=,CtmDictAlias=1111,CtmDictDesc=1111,EndDate=#*#$2013-05-30,EndTime=@##@00:00,StartDate=txtValueText5,StartTime=@##@")    
ClassMethod AddRecord(ClassName As %String, morenzhi As %String) As %String [ WebMethod ]
{
	s obj=##class(CT.WS.DynamicConfigDefaultValue).%New()
	s obj.DefaultRow=morenzhi
	s obj.TableName=ClassName
	d obj.%Save()
	d obj.%Close()
	s cmdID=obj.%Id()
	q @cmdID
}

/// Creator：      dujinrong
/// CreatDate：    2013-12-26
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        属性TableName：ClassName,TableName：morenzhi 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigDefaultValue).DelRecord(CT.WS.testdu)    
ClassMethod DelRecord(ClassName As %String) As %String [ WebMethod ]
{
	s tableNames=""
	s tableNames=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(ClassName, "U"),tableNames))
	if (tableNames'="")
	{
		d ##class(CT.WS.DynamicConfigDefaultValue).%DeleteId(tableNames)		
	}
}

Storage Default
{
<Data name="BLDynamicConfigDefaultValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.BLL.BLDynamicCoE552D</DataLocation>
<DefaultData>BLDynamicConfigDefaultValueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CT.WS.BLL.BLDynamicCoE552D</IdLocation>
<IndexLocation>^CT.WS.BLL.BLDynamicCoE552I</IndexLocation>
<StreamLocation>^CT.WS.BLL.BLDynamicCoE552S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
