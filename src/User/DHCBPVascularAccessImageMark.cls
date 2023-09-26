Class User.DHCBPVascularAccessImageMark Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPVAIM_RowId, SqlTableName = DHC_BP_VascularAccessImageMark, StorageStrategy = CacheStorage ]
{

Index Arrange On BPVAIMBPArrangeDr As Exact;

Index VascularAccess On BPVAIMBPVascularAccessDr As Exact;

Index Date On BPVAIMUpdateDate As Exact;

Property BPVAIMBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPVAIM_BPArrange_Dr ];

Property BPVAIMBPVascularAccessDr As User.DHCBPVascularAccess [ SqlColumnNumber = 3, SqlFieldName = BPVAIM_BPVascularAccess_Dr ];

Property BPVAIMPointX As %Float [ SqlColumnNumber = 4, SqlFieldName = BPVAIM_PointX ];

Property BPVAIMPointY As %Float [ SqlColumnNumber = 5, SqlFieldName = BPVAIM_PointY ];

Property BPVAIMSizeWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = BPVAIM_SizeWidth ];

Property BPVAIMSizeHeight As %Float [ SqlColumnNumber = 7, SqlFieldName = BPVAIM_SizeHeight ];

/// N正常，D删除
Property BPVAIMStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 8, SqlFieldName = BPVAIM_Status ];

Property BPVAIMUpdateUserDr As %String [ SqlColumnNumber = 9, SqlFieldName = BPVAIM_UpdateUser_Dr ];

Property BPVAIMUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BPVAIM_UpdateDate ];

Property BPVAIMUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BPVAIM_UpdateTime ];

/// V端，A端
Property BPVAIMPointType As %String(DISPLAYLIST = ",Vein,Art", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",V,A") [ SqlColumnNumber = 12, SqlFieldName = BPVAIM_PointType ];

/// 穿刺点位
Property BPVAIMPointNum As %String [ SqlColumnNumber = 13, SqlFieldName = BPVAIM_PointNum ];

/// 备注
Property BPVAIMNote As %String [ SqlColumnNumber = 14, SqlFieldName = BPVAIM_Note ];

Storage CacheStorage
{
<Data name="DHCBPVascularAccessImageMark">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPVascularAccessImageMarkDefaultData">
<Value name="1">
<Value>BPVAIMBPArrangeDr</Value>
</Value>
<Value name="2">
<Value>BPVAIMBPVascularAccessDr</Value>
</Value>
<Value name="3">
<Value>BPVAIMPointX</Value>
</Value>
<Value name="4">
<Value>BPVAIMPointY</Value>
</Value>
<Value name="5">
<Value>BPVAIMSizeWidth</Value>
</Value>
<Value name="6">
<Value>BPVAIMSizeHeight</Value>
</Value>
<Value name="7">
<Value>BPVAIMStatus</Value>
</Value>
<Value name="8">
<Value>BPVAIMUpdateUserDr</Value>
</Value>
<Value name="9">
<Value>BPVAIMUpdateDate</Value>
</Value>
<Value name="10">
<Value>BPVAIMUpdateTime</Value>
</Value>
<Value name="11">
<Value>BPVAIMPointType</Value>
</Value>
<Value name="12">
<Value>BPVAIMPointNum</Value>
</Value>
<Value name="13">
<Value>BPVAIMNote</Value>
</Value>
</Data>
<DataLocation>^DHCBPVascularAccessImageMark</DataLocation>
<DefaultData>DHCBPVascularAccessImageMarkDefaultData</DefaultData>
<IdLocation>^DHCBPVascularAccessImageMark</IdLocation>
<IndexLocation>^DHCBPVascularAccessImageMark(0)</IndexLocation>
<StreamLocation>^User.DHCBPVAImageMarkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
