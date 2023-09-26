/// DHCWL_MKPI.DHCWLDeptKPIData
Class DHCWL.MKPI.DeptKPIData Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLDeptKPIData ]
{

/// 指标关联
Property DKPIKPIDr As DHCWL.MKPI.MKPIData [ SqlColumnNumber = 2, SqlFieldName = DKPI_KPI_Dr ];

/// 维度
Property DKPIDeptDr As %String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = DKPI_Dept_Dr ];

/// 值
Property DKPIValue As %Float [ SqlColumnNumber = 4, SqlFieldName = DKPI_Value ];

Index DKPIKPIDrIndex On DKPIKPIDr;

// Index DKPIDeptDrIndex On DKPIDeptDr; modify by wk on 20220707 for 该索引严重影响效率，需要删除

Index MONDeptData On (DKPIKPIDr, DKPIDeptDr);

Storage Default
{
<Data name="DeptKPIDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DKPIDeptDr</Value>
</Value>
<Value name="3">
<Value>DKPIKPIDr</Value>
</Value>
<Value name="4">
<Value>DKPIValue</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.DeptKPIDataD</DataLocation>
<DefaultData>DeptKPIDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.DeptKPIDataD</IdLocation>
<IndexLocation>^DHCWL.MKPI.DeptKPIDataI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.DeptKPIDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
