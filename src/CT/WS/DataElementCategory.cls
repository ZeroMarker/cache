Class CT.WS.DataElementCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 数据元目录名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元范畴描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 数据元目录范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		查找所有目录数据
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementCategoryDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("CT.WS.DataElementCategory","SelectAll")
Query SelectAll() As %SQLQuery(CONTAINID = 2)
{
SELECT ID,Description,Name,ParentID,InternalID
 FROM CT_WS.DataElementCategory
 ORDER BY ID
}

Storage Default
{
<Data name="DataElementCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>InternalID</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.DataElementCategoryD</DataLocation>
<DefaultData>DataElementCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.DataElementCategoryD</IdLocation>
<IndexLocation>^DHCCTWS.DataElementCategoryI</IndexLocation>
<StreamLocation>^DHCCTWS.DataElementCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
