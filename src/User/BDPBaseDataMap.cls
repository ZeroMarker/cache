/// Function:定义第三方系统、字典
/// Creator: sunfengchao
/// CreateDate:2019-12-26
Class User.BDPBaseDataMap Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_BaseDataMap ]
{

///  代码 
Property BDPBaseDMCode As %String(MAXLEN = "") [ Required, SqlColumnNumber = 2, SqlFieldName = BDP_BaseDMCode ];

///  描述
Property BDPBaseDMDesc As %String(MAXLEN = "") [ Required, SqlColumnNumber = 3, SqlFieldName = BDP_BaseDMDesc ];

/// 上一级
Property BDPBaseDMParentDR As BDPBaseDataMap [ SqlColumnNumber = 4, SqlFieldName = BDP_BaseDMParent_DR ];

/// 开始日期
Property BDPBaseDMDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = BDP_BaseDMDateFrom ];

/// 结束日期
Property BDPBaseDMDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = BDP_BaseDMDateTo ];

/// 表结构
Property BDPBaseDMTableDR As BDPTableList [ SqlColumnNumber = 7, SqlFieldName = BDP_BaseDMTable_DR ];

/// 对照类型 (字段型对照、文本型对照)
Property DPBaseDMType As %String(DISPLAYLIST = ",DIC,TEXT", VALUELIST = ",D,T") [ SqlColumnNumber = 8, SqlFieldName = DPBaseDM_Type ];

Index CodeI On BDPBaseDMCode As Exact;

Index DescI On BDPBaseDMDesc As Exact;

Index BDPParentMenuDrI On BDPBaseDMParentDR;

/// 对字典的代码 做索引
Index BDPDicCodeI On (BDPBaseDMParentDR As Exact, BDPBaseDMCode As Exact);

/// 对字典的描述 做索引
Index BDPDicDescI On (BDPBaseDMParentDR As Exact, BDPBaseDMDesc As Exact);

Index BDPCodeParentIdx On (BDPBaseDMCode As Exact, BDPBaseDMParentDR As Exact);

Index BDPDescParentIdx On (BDPBaseDMDesc As Exact, BDPBaseDMParentDR As Exact);

Storage Default
{
<Data name="BDPBaseDataMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPBaseDMCode</Value>
</Value>
<Value name="3">
<Value>BDPBaseDMDesc</Value>
</Value>
<Value name="4">
<Value>BDPBaseDMParentDR</Value>
</Value>
<Value name="5">
<Value>BDPBaseDMDateFrom</Value>
</Value>
<Value name="6">
<Value>BDPBaseDMDateTo</Value>
</Value>
<Value name="7">
<Value>BDPBaseDMTableDR</Value>
</Value>
<Value name="8">
<Value>DPBaseDMType</Value>
</Value>
</Data>
<DataLocation>^User.BDPBaseDataMapD</DataLocation>
<DefaultData>BDPBaseDataMapDefaultData</DefaultData>
<IdLocation>^User.BDPBaseDataMapD</IdLocation>
<IndexLocation>^User.BDPBaseDataMapI</IndexLocation>
<SqlRowIdName>BDPBaseDMRowId</SqlRowIdName>
<StreamLocation>^User.BDPBaseDataMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
