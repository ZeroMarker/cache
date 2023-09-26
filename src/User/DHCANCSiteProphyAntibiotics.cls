Class User.DHCANCSiteProphyAntibiotics Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCSPA_RowId, SqlTableName = DHC_ANC_SiteProphyAntibiotics, StorageStrategy = CacheStorage ]
{

Property ANCSPABodySiteDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ANCSPA_BodySite_Dr ];

Property ANCSPAArcimDr As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCSPA_Arcim_Dr ];

Property ANCSPAActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ANCSPA_Active ];

Index BodySite On ANCSPABodySiteDr As Exact;

Storage CacheStorage
{
<Data name="DHCANCSiteProphyAntibioticsDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>ANCSPABodySiteDr</Value>
</Value>
<Value name="2">
<Value>ANCSPAArcimDr</Value>
</Value>
<Value name="3">
<Value>ANCSPAActive</Value>
</Value>
</Data>
<DataLocation>^DHCANC("SPA")</DataLocation>
<DefaultData>DHCANCSiteProphyAntibioticsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("SPA")</IdLocation>
<IndexLocation>^DHCANC("SPA",0)</IndexLocation>
<StreamLocation>^User.DHCANCSPAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
