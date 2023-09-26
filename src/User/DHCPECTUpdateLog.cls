/// 基础表公用更新日志表
Class User.DHCPECTUpdateLog Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_CTUpdateLog ]
{

Parameter ClassName = "User.DHCPECTUpdateLog";

/// 表名称
Property CTULTableDR As User.DHCPEPowerTableList [ Required, SqlFieldName = CTUL_TableDR ];

/// 表记录ID
Property CTULRecordID As %String [ Required, SqlFieldName = CTUL_RecordID ];

/// 操作状态
Property CTULStatus As %String(DISPLAYLIST = ",Insert,Update,Delete", TRUNCATE = 1, VALUELIST = ",I,U,D") [ SqlFieldName = CTUL_Status ];

/// 原始记录
Property CTULOldRecord As %String(MAXLEN = 1000) [ SqlFieldName = CTUL_OldRecord ];

/// 更新记录
Property CTULNewRecord As %String(MAXLEN = 1000) [ SqlFieldName = CTUL_NewRecord ];

/// 更新日期
Property CTULUpdateDate As %Date [ SqlFieldName = CTUL_UpdateDate ];

/// 更新时间
Property CTULUpdateTime As %Time [ SqlFieldName = CTUL_UpdateTime ];

/// 更新人 
Property CTULUpdateUserDR As %String [ SqlFieldName = CTUL_UpdateUserDR ];

/// 表+更新日期 索引
Index IdxOfTabUpdateDate On (CTULTableDR, CTULUpdateDate);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTULTableDR</Value>
</Value>
<Value name="3">
<Value>CTULRecordID</Value>
</Value>
<Value name="4">
<Value>CTULStatus</Value>
</Value>
<Value name="5">
<Value>CTULOldRecord</Value>
</Value>
<Value name="6">
<Value>CTULNewRecord</Value>
</Value>
<Value name="7">
<Value>CTULUpdateDate</Value>
</Value>
<Value name="8">
<Value>CTULUpdateTime</Value>
</Value>
<Value name="9">
<Value>CTULUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.CTUpdateLogD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.CTUpdateLogD</IdLocation>
<IndexLocation>^CF.PE.CTUpdateLogI</IndexLocation>
<StreamLocation>^User.DHCPECTUpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
