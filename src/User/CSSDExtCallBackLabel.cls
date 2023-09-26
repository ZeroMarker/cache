Class User.CSSDExtCallBackLabel Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDECL_Rowid, SqlTableName = CSSD_ExtCallBackLabel ]
{

/// 外来器械表id
Property CSSDECLParrefDr As User.CSSDExtDevBind [ SqlColumnNumber = 2, SqlFieldName = CSSDECL_Parref_DR ];

/// 回收数量
Property CSSDECLQty As %Numeric [ InitialExpression = "0", SqlColumnNumber = 3, SqlFieldName = CSSDECL_Qty ];

/// 外来器械具体标签
Property CSSDECLLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDECL_Label ];

/// 'B':绑定、'W'清洗'、'P'：打包、'S'、灭菌、D'：发放、'R'：接收、'U'：过期 、'TC':过期处理、'C':回收、'SW':二次清洗、'SS':二次消毒、
Property CSSDECLStatus As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDECL_Status ];

/// 日期
Property CSSDECLDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = CSSDECL_Date ];

/// 回收明细表id
Property CSSDECLCallBackDetailDr As User.CSSDCallbackDetailNew [ SqlColumnNumber = 7, SqlFieldName = CSSDECL_CallBackDetailDr ];

Index CSSDECLLabelCallBackDrIndex On (CSSDECLLabel As Exact, CSSDECLCallBackDetailDr As Exact);

Index CSSDECLParrefDrIndex On CSSDECLParrefDr As Exact;

Index CSSDECLParrefDrStatusIndex On (CSSDECLParrefDr As Exact, CSSDECLStatus As Exact);

Index CSSDECLDateIndex On CSSDECLDate As Exact;

Index CSSDECLCallBackDrIndex On CSSDECLCallBackDetailDr As Exact;

Storage Default
{
<Data name="CSSDExtCallBackLabelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDECLParrefDr</Value>
</Value>
<Value name="3">
<Value>CSSDECLQty</Value>
</Value>
<Value name="4">
<Value>CSSDECLLabel</Value>
</Value>
<Value name="5">
<Value>CSSDECLStatus</Value>
</Value>
<Value name="6">
<Value>CSSDECLCallBackDetailDr</Value>
</Value>
<Value name="7">
<Value>CSSDECLDate</Value>
</Value>
</Data>
<DataLocation>^User.CSSDExtCallBackLabelD</DataLocation>
<DefaultData>CSSDExtCallBackLabelDefaultData</DefaultData>
<IdLocation>^User.CSSDExtCallBackLabelD</IdLocation>
<IndexLocation>^User.CSSDExtCallBackLabelI</IndexLocation>
<SqlRowIdName>CSSDECL_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDExtCallBackLabelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
