Class dbo.BTMixPlace Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMix_Place, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index PKBTMIXPLACE On RowID [ PrimaryKey, SqlName = PK_BTMIX_PLACE, Type = index, Unique ];

/// Foreign Key FKBTMixPlaceHospital created via DDL
ForeignKey FKBTMixPlaceHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTMixPlaceHospital ];

/// Foreign Key FKBTMixPlaceCollType created via DDL
ForeignKey FKBTMixPlaceCollType(CollTypeDR) References dbo.BTMixCollType(PKBTMIXCOllTYPE) [ SqlName = FK_BTMixPlaceCollType ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 采集类型
Property CollTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTMixPlaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>CollTypeDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMixPlaceD</DataLocation>
<DefaultData>BTMixPlaceDefaultData</DefaultData>
<IdLocation>^dbo.BTMixPlaceD</IdLocation>
<IndexLocation>^dbo.BTMixPlaceI</IndexLocation>
<StreamLocation>^dbo.BTMixPlaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
