/// 科室导管分类
Class User.DHCICUCDeptCatheterCat Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICUC_DeptCatheterCat ]
{

Property DeptID As %String [ SqlColumnNumber = 2 ];

Property CatheterCategory As User.DHCICUCCatheterCategory [ SqlColumnNumber = 3 ];

Property UserDefinedItemID As User.DHCICUCCatheter [ SqlColumnNumber = 4 ];

Index IDeptID On DeptID;

Storage Default
{
<Data name="DHCICUCDeptCatheterCatDefaultData">
<Value name="1">
<Value>DeptID</Value>
</Value>
<Value name="2">
<Value>CatheterCategory</Value>
</Value>
<Value name="3">
<Value>UserDefinedItemID</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCDeptCatheterCatD</DataLocation>
<DefaultData>DHCICUCDeptCatheterCatDefaultData</DefaultData>
<IdLocation>^User.DHCICUCDeptCatheterCatD</IdLocation>
<IndexLocation>^User.DHCICUCDeptCatheterCatI</IndexLocation>
<StreamLocation>^User.DHCICUCDeptCatheterCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
