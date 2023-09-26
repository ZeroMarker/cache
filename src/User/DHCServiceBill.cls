/// 物资管理系统-接口对接单据信息
Class User.DHCServiceBill Extends (%Persistent, User.Abstract) [ SqlRowIdName = BILL_RowId, SqlTableName = DHC_ServiceBill, StorageStrategy = Storage ]
{

/// 接口类型,对应DHC_ServiceConfig
Property BILLServiceCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = BILL_ServiceCode ];

/// DHC单据类型(使用台账类型)
Property BILLType As %Library.String [ SqlColumnNumber = 3, SqlFieldName = BILL_Type ];

/// DHC-单据字表rowid
Property BILLPointer As %Library.String [ SqlColumnNumber = 4, SqlFieldName = BILL_Pointer ];

/// 第三方单据号
Property BILLThirdNo As %Library.String [ SqlColumnNumber = 5, SqlFieldName = BILL_ThirdNo ];

/// 第三方单据明细id
Property BILLThirdId As %Library.String [ SqlColumnNumber = 6, SqlFieldName = BILL_ThirdId ];

Property BILLDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = BILL_Date ];

Property BILLTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = BILL_Time ];

Index TypePointer On (BILLServiceCode As Exact, BILLType As Exact, BILLPointer As Exact);

Index ThirdNo On (BILLServiceCode As Exact, BILLThirdNo As Exact, BILLType As Exact);

Index ThirdId On (BILLServiceCode As Exact, BILLThirdId As Exact, BILLType As Exact);

Storage Storage
{
<Data name="DHCServiceBillDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BILLServiceCode</Value>
</Value>
<Value name="3">
<Value>BILLType</Value>
</Value>
<Value name="4">
<Value>BILLPointer</Value>
</Value>
<Value name="5">
<Value>BILLThirdNo</Value>
</Value>
<Value name="6">
<Value>BILLThirdId</Value>
</Value>
<Value name="7">
<Value>BILLDate</Value>
</Value>
<Value name="8">
<Value>BILLTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCServiceBillD</DataLocation>
<DefaultData>DHCServiceBillDefaultData</DefaultData>
<IdLocation>^User.DHCServiceBillD</IdLocation>
<IndexLocation>^User.DHCServiceBillI</IndexLocation>
<SqlRowIdName>BILL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCServiceBillS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
