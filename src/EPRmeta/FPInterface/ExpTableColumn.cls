Class EPRmeta.FPInterface.ExpTableColumn Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// unit code of interface model or column name of system dataset
Property Code As %String(MAXLEN = 500, TRUNCATE = 1);

Property DataType As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

Property ImportColName As %String(TRUNCATE = 1);

Property Length As %Integer;

Property Name As %String(TRUNCATE = 1);

/// if this column needs to get code, not value
Property IsGetCode As %Boolean;

/// the flag of converted types, format: DEPT|DATE|NULL
Property ConvertFlag As %String(TRUNCATE = 1);

/// parameters for convert data. format: PARAM1|PARAM2|PARAM3. corresponding to ConvertFlag
Property ConvertParam As %String(MAXLEN = 500, TRUNCATE = 1);

/// if this column gets data from system, not from EPR.
/// if this property is true, the code should be a function's name of PatientInfoAssist class. and the
/// IsGetCode property should be false.
Property IsSystemData As %Boolean;

Storage Default
{
<Data name="ExpTableColumnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ConvertFlag</Value>
</Value>
<Value name="4">
<Value>ConvertParam</Value>
</Value>
<Value name="5">
<Value>DataType</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>ImportColName</Value>
</Value>
<Value name="8">
<Value>IsGetCode</Value>
</Value>
<Value name="9">
<Value>IsSystemData</Value>
</Value>
<Value name="10">
<Value>Length</Value>
</Value>
<Value name="11">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.FPIn6E3.ExpTableColumnD</DataLocation>
<DefaultData>ExpTableColumnDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.FPIn6E3.ExpTableColumnD</IdLocation>
<IndexLocation>^EPRmeta.FPIn6E3.ExpTableColumnI</IndexLocation>
<StreamLocation>^EPRmeta.FPIn6E3.ExpTableColumnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
