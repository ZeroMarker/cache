Class User.DHCMATPackageTrans Extends (%Persistent, User.Abstract) [ SqlRowIdName = DMPT_RowId, SqlTableName = DHC_MATPackageTrans ]
{

/// Index RowIDBasedIDKeyIndex On INVIChildSub [ IdKey, PrimaryKey, Unique ];
Relationship DMPTParref As User.MATPackage [ Cardinality = parent, Inverse = ChildDHCMATPackageTrans, Required, SqlFieldName = DMPT_Parref ];

/// 业务指针
Property DMPTPointer As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = DMPT_Pointer ];

/// 业务类型
Property DMPTType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = DMPT_Type ];

/// 操作日期
Property DMPTDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DMPT_Date ];

/// 操作时间
Property DMPTTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DMPT_Time ];

/// 操作人
Property DMPTSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DMPT_SSUSR_DR ];

Index Indexpointortype On (DMPTType As Exact, DMPTPointer As Exact);

Storage Default
{
<Data name="DHCMATPackageTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DMPTPointer</Value>
</Value>
<Value name="3">
<Value>DMPTType</Value>
</Value>
<Value name="4">
<Value>DMPTDate</Value>
</Value>
<Value name="5">
<Value>DMPTTime</Value>
</Value>
<Value name="6">
<Value>DMPTSSUSRDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DMPT")</DataLocation>
<DefaultData>DHCMATPackageTransDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DMPT")</IdLocation>
<IndexLocation>^User.DHCMATPackageTransI</IndexLocation>
<SqlRowIdName>DMPT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMATPackageTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
