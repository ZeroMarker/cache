///     
Class dbo.BBPackStoWarning Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_PackStoWarning, StorageStrategy = Default ]
{

/// Foreign Key FKBBBCQBProduct created via DDL
ForeignKey FKBBPSWComponent(BloodComponentDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BB_PSW_Component ];

/// Foreign Key FKBBBCQQualityItem created via DDL
ForeignKey FKBBPSWBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BB_PSW_BloodGroup ];

Index IndexMaster On (BloodComponentDR, BloodGroupDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBBPACKSTOWARNING On RowID [ PrimaryKey, SqlName = PK_BB_PACKSTOWARNING, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodComponentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property FirstPackVol As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property FirstPackWarningColor As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property SecPackVol As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property SecPackWarningColor As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property ThirdPackVol As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property ThirdPackWarningColor As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Property HospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BBPackStoWarningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodComponentDR</Value>
</Value>
<Value name="3">
<Value>BloodGroupDR</Value>
</Value>
<Value name="4">
<Value>FirstPackVol</Value>
</Value>
<Value name="5">
<Value>FirstPackWarningColor</Value>
</Value>
<Value name="6">
<Value>SecPackVol</Value>
</Value>
<Value name="7">
<Value>SecPackWarningColor</Value>
</Value>
<Value name="8">
<Value>ThirdPackVol</Value>
</Value>
<Value name="9">
<Value>ThirdPackWarningColor</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBPackStoWarningD</DataLocation>
<DefaultData>BBPackStoWarningDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBPackStoWarningD</IdLocation>
<IndexLocation>^dbo.BBPackStoWarningI</IndexLocation>
<StreamLocation>^dbo.BBPackStoWarningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
