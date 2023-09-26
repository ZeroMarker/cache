///     
Class dbo.BTMCGenusFeature Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_GenusFeature, StorageStrategy = Default ]
{

/// Foreign Key FKMCGenusFeatureBT created via DDL
ForeignKey FKMCGenusFeatureBT(FeatrueBTDR) References dbo.BTBaseTable(PKBTBASETABLE) [ SqlName = FK_MC_GenusFeatureBT ];

/// Foreign Key FKMCGenusFeatureGenus created via DDL
ForeignKey FKMCGenusFeatureGenus(GenusDR) References dbo.BTGenus(PKBTGENUS) [ SqlName = FK_MC_GenusFeature_Genus ];

/// Foreign Key FKMCGenusFeatureHospital created via DDL
ForeignKey FKMCGenusFeatureHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_MC_GenusFeature_Hospital ];

Index IndexDataMaster On (GenusDR, HospitalDR, FeatrueBTDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexHospital On (HospitalDR, GenusDR) [ SqlName = Index_Hospital, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCGENUSFEATURE On RowID [ PrimaryKey, SqlName = PK_BTMC_GENUSFEATURE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property GenusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property FeatrueBTDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property FeatrueResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTMCGenusFeatureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GenusDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>FeatrueBTDR</Value>
</Value>
<Value name="5">
<Value>FeatrueResult</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCGenusFeatureD</DataLocation>
<DefaultData>BTMCGenusFeatureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMCGenusFeatureD</IdLocation>
<IndexLocation>^dbo.BTMCGenusFeatureI</IndexLocation>
<StreamLocation>^dbo.BTMCGenusFeatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
