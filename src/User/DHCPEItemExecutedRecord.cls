Class User.DHCPEItemExecutedRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ItemExecutedRecord ]
{

Parameter ClassName = "User.DHCPEItemExecutedRecord";

/// 医嘱ID
Property IEROEORIDR As User.OEOrdItem [ Required, SqlFieldName = IER_OEORI_DR ];

/// 类型  E：执行  D：撤销
Property IERType As %String(MAXLEN = 1) [ Required, SqlFieldName = IER_Type ];

/// 操作类型  
Property IEROperType As %String(MAXLEN = 10) [ Required, SqlFieldName = IER_Oper_Type ];

/// 发生日期
Property IERDate As %Library.Date [ Required, SqlFieldName = IER_Date ];

/// 发生时间
Property IERTime As %Library.Time [ Required, SqlFieldName = IER_Time ];

/// 操作员
Property IERUserDR As User.SSUser [ Required, SqlFieldName = IER_User_DR ];

/// 日期索引
Index IERDateIndex On IERDate;

Storage Default
{
<Data name="DHCPEItemExecutedRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IEROEORIDR</Value>
</Value>
<Value name="3">
<Value>IERType</Value>
</Value>
<Value name="4">
<Value>IEROperType</Value>
</Value>
<Value name="5">
<Value>IERDate</Value>
</Value>
<Value name="6">
<Value>IERTime</Value>
</Value>
<Value name="7">
<Value>IERUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEItemExecutedRecordD</DataLocation>
<DefaultData>DHCPEItemExecutedRecordDefaultData</DefaultData>
<IdLocation>^User.DHCPEItemExecutedRecordD</IdLocation>
<IndexLocation>^User.DHCPEItemExecutedRecordI</IndexLocation>
<StreamLocation>^User.DHCPEItemExecutedRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
