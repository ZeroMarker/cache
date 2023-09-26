Class User.DHCEmPatGreenRecAudit Extends %Persistent [ SqlRowIdName = PGRA_RowID, SqlTableName = DHC_EmPatGreenRecAudit ]
{

/// 绿色通道记录表
Property PGRAParRef As User.DHCEmPatGreenRec [ SqlColumnNumber = 2, SqlFieldName = PGRA_ParRef ];

/// 审核人
Property PGRACreator As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PGRA_Creator ];

/// 审核日期
Property PGRACreateDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = PGRA_CreateDate ];

/// 审核时间
Property PGRACreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PGRA_CreateTime ];

/// 审核状态 [审核拒绝（R）、审核通过（P）、撤销审核(C)]
Property PGRAStatus As %Library.String(MAXLEN = 3, VALUELIST = ",R,P,C") [ SqlColumnNumber = 6, SqlFieldName = PGRA_Status ];

Index IndexParref On PGRAParRef;

Storage Default
{
<Data name="DHCEmPatGreenRecAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PGRAParRef</Value>
</Value>
<Value name="3">
<Value>PGRACreator</Value>
</Value>
<Value name="4">
<Value>PGRACreateDate</Value>
</Value>
<Value name="5">
<Value>PGRACreateTime</Value>
</Value>
<Value name="6">
<Value>PGRAStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPatGreenRecAuditD</DataLocation>
<DefaultData>DHCEmPatGreenRecAuditDefaultData</DefaultData>
<IdLocation>^User.DHCEmPatGreenRecAuditD</IdLocation>
<IndexLocation>^User.DHCEmPatGreenRecAuditI</IndexLocation>
<StreamLocation>^User.DHCEmPatGreenRecAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
