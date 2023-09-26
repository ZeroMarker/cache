/// Desc:		图库树
/// Creator:	yejian
/// CreateDate:	2012-09-11
Class EMRmeta.ImageTree Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 图库RowID
Property ImageLibID As %Integer;

/// 父节点RowID
Property ParentID As %Integer;

/// 所属个人用户RowID
Property UserID As %String(TRUNCATE = 1);

/// 顺序号
Property Sequence As %Integer;

Index IdxImageLibID On ImageLibID;

Index IdxParentID On ParentID;

Storage Default
{
<Data name="ImageTreeDefaultData">
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
<Value>ImageLibID</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ImageTreeD</DataLocation>
<DefaultData>ImageTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.ImageTreeD</IdLocation>
<IndexLocation>^DHCEMRM.ImageTreeI</IndexLocation>
<StreamLocation>^DHCEMRM.ImageTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
