/// DHCWL_MKPI.DHCWLMKPIData
Class DHCWL.MKPI.MKPIData Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPIData ]
{

/// 区间
Property MKDMondr As DHCWL.MKPI.Months [ SqlColumnNumber = 2, SqlFieldName = MKD_Mon_dr ];

/// 指标
Property MKDKPIdr As DHCWL.MKPI.MKPI [ SqlColumnNumber = 3, SqlFieldName = MKD_KPI_dr ];

/// 用户
Property MKDUser As %String [ SqlColumnNumber = 4, SqlFieldName = MKD_User ];

/// 创建日期
Property MKDUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MKD_UpdateDate ];

/// 备注
Property MKDRemark As %String [ SqlColumnNumber = 6, SqlFieldName = MKD_Remark ];

Index MKDMondr On MKDMondr;

Index MKDKPIdr On MKDKPIdr;

Index MONKPI On (MKDMondr, MKDKPIdr);

Storage Default
{
<Data name="MKPIDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKDKPIdr</Value>
</Value>
<Value name="3">
<Value>MKDMondr</Value>
</Value>
<Value name="4">
<Value>MKDRemark</Value>
</Value>
<Value name="5">
<Value>MKDUpdateDate</Value>
</Value>
<Value name="6">
<Value>MKDUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPIDataD</DataLocation>
<DefaultData>MKPIDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MKPIDataD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPIDataI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPIDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
