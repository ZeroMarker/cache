/// Function:数据对照的存储表
/// CreateDate:2020-01-02
/// Creator: sunfengchao
Class User.BDPBaseDataMapDetail Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_BaseDataMapDetail ]
{

/// 东华基础码表名称  非空
Property BDPMapDBaseTabNameDR As BDPBaseDataMap [ Required, SqlColumnNumber = 2, SqlFieldName = BDPMapD_BaseTabName_DR ];

/// HIS表数据代码  
Property BDPMapDHisDicCode As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = BDPMapD_HisDicCode ];

/// HIS表数据描述
Property BDPMapDHisDicDesc As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = BDPMapD_DHisDicDesc ];

/// 外部代码  
Property BDPMapDExtDicCode As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = BDPMapD_ExtDicCode ];

/// 外部名称
Property BDPMapDExtDicDesc As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = BDPMapD_ExtDicDesc ];

/// 有效
Property BDPMapDActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = BDPMapD_Active ];

/// 开始日期
Property BDPMapDDateFrom As %Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = BDPMapD_DateFrom ];

/// 结束日期
Property BDPMapDDateTo As %Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = BDPMapD_DateTo ];

/// 是否外部到His对照
Property BDPMapDHisFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = BDPMapD_HisFlag ];

/// 字典或者文本的代码
Property BDPMapDTableCode As %String [ SqlColumnNumber = 11, SqlFieldName = BDPMapD_TableCode ];

/// 所属系统
Property BDPMapDSystemCode As %String [ SqlColumnNumber = 12, SqlFieldName = BDPMapD_SystemCode ];

/// 字典或者 文本 所属系统 检索数据 
Index BDPMapDTableCodeIdx On (BDPMapDSystemCode As Exact, BDPMapDTableCode As Exact);

/// 通过表名称检索数据 
Index BaseTabNameDRIdx On BDPMapDBaseTabNameDR As Exact;

/// HIS表的 "代码" 索引  
Index HisCodeIdx On (BDPMapDSystemCode As Exact, BDPMapDTableCode As Exact, BDPMapDHisDicCode As Exact);

/// HIS表的 "描述" 索引  
Index HisDescIdx On (BDPMapDSystemCode As Exact, BDPMapDTableCode As Exact, BDPMapDHisDicDesc As Exact);

/// 针对第三方表的 "代码" 索引   
Index ExtCodeIdx On (BDPMapDSystemCode As Exact, BDPMapDTableCode As Exact, BDPMapDExtDicCode As Exact);

/// 针对第三方表的 "描述" 索引
Index ExtDescIdx On (BDPMapDSystemCode As Exact, BDPMapDTableCode As Exact, BDPMapDExtDicDesc As Exact);

Storage Default
{
<Data name="BDPBaseDataMapDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPMapDBaseTabNameDR</Value>
</Value>
<Value name="3">
<Value>BDPMapDHisDicCode</Value>
</Value>
<Value name="4">
<Value>BDPMapDHisDicDesc</Value>
</Value>
<Value name="5">
<Value>BDPMapDExtDicCode</Value>
</Value>
<Value name="6">
<Value>BDPMapDExtDicDesc</Value>
</Value>
<Value name="7">
<Value>BDPMapDDateFrom</Value>
</Value>
<Value name="8">
<Value>BDPMapDDateTo</Value>
</Value>
<Value name="9">
<Value>BDPMapDHisFlag</Value>
</Value>
<Value name="10">
<Value>BDPMapDActive</Value>
</Value>
<Value name="11">
<Value>BDPMapDTableCode</Value>
</Value>
<Value name="12">
<Value>BDPMapDSystemCode</Value>
</Value>
</Data>
<DataLocation>^User.BDPBaseDataMapDetailD</DataLocation>
<DefaultData>BDPBaseDataMapDetailDefaultData</DefaultData>
<IdLocation>^User.BDPBaseDataMapDetailD</IdLocation>
<IndexLocation>^User.BDPBaseDataMapDetailI</IndexLocation>
<StreamLocation>^User.BDPBaseDataMapDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
