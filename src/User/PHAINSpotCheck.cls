Class User.PHAINSpotCheck Extends %Persistent [ SqlRowIdName = INSC_RowId, SqlTableName = PHAIN_SpotCheck ]
{

Relationship ChildPHAINSpotCheckItm As User.PHAINSpotCheckItm [ Cardinality = children, Inverse = INSCIItmParRef ];

Index INSCLocDate On (INSCLocDR, INSCDate);

/// 抽检科室id
Property INSCLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = INSC_Loc_DR ];

/// 抽检人员id
Property INSCUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = INSC_User_DR ];

/// 抽检单号
Property INSCNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = 1, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INSC_No ];

/// 抽检日期
Property INSCDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = INSC_Date ];

/// 抽检时间
Property INSCTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = INSC_Time ];

/// 抽检是否完成
Property INSCComplet As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INSC_Complet ];

Storage Default
{
<Data name="PHAINSpotCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INSCLocDR</Value>
</Value>
<Value name="3">
<Value>INSCUserDR</Value>
</Value>
<Value name="4">
<Value>INSCNo</Value>
</Value>
<Value name="5">
<Value>INSCDate</Value>
</Value>
<Value name="6">
<Value>INSCTime</Value>
</Value>
<Value name="7">
<Value>INSCComplet</Value>
</Value>
</Data>
<DataLocation>^BS.PHA.IN.SpotCheck</DataLocation>
<DefaultData>PHAINSpotCheckDefaultData</DefaultData>
<IdLocation>^BS.PHA.IN.SpotCheck</IdLocation>
<IndexLocation>^BS.PHA.IN.SpotChecki</IndexLocation>
<StreamLocation>^BS.PHA.IN.SpotChecks</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
