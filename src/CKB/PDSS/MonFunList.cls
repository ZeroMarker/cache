Class CKB.PDSS.MonFunList Extends (%Persistent, User.Abstract) [ SqlRowIdName = CM_RowID, SqlTableName = MonFunList ]
{

/// 监测问题表ID  CM_Parrf_Dr
Property CMParrfDr As CKB.PDSS.MonQueList [ SqlColumnNumber = 2, SqlFieldName = CM_Parrf_Dr ];

/// 函数项  CM_Fun_Dr
Property CMFunDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = CM_Fun_Dr ];

Index Parrf On CMParrfDr As Exact;

/// ^DHCCKBMFL(0,"Parrf",{CM_Parrf_Dr},{CM_RowID})
Storage Default
{
<Data name="MonFunListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMParrfDr</Value>
</Value>
<Value name="3">
<Value>CMFunDr</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.MonFunListD</DataLocation>
<DefaultData>MonFunListDefaultData</DefaultData>
<Description>
<![CDATA[^DHCCKBMFL(0,"Parrf",{CM_Parrf_Dr},{CM_RowID})]]></Description>
<IdLocation>^CKB.PDSS.MonFunListD</IdLocation>
<IndexLocation>^CKB.PDSS.MonFunListI</IndexLocation>
<StreamLocation>^CKB.PDSS.MonFunListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
