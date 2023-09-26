Class EMRmeta.MedicalConceptCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxOnInternalID On InternalID [ Unique ];

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 父类ID
Property ParentID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalConceptCategoryDefaultData">
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
<Value>ResChildCount</Value>
</Value>
<Value name="5">
<Value>InternalID</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MedConceptCD</DataLocation>
<DefaultData>MedicalConceptCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.MedConceptCD</IdLocation>
<IndexLocation>^DHCEMRM.MedConceptCI</IndexLocation>
<StreamLocation>^DHCEMRM.MedConceptCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
