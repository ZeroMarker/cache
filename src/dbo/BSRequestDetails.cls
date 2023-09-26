/// 申请单汇总明细
Class dbo.BSRequestDetails Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_RequestDetails ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BLDRequestDR) References dbo.BSRequest(PKRequestTAT) [ SqlName = FK_BLD_CT_REQ_Detalis_BLDRequestDR ];

Index IndexMaster On (BLDRequestDR, ProductDR, BloodGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BLDRequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  血液制品
Property ProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///  申请单血型
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

///  输血目的
Property PorposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

///  申请量
Property Volume As %Library.Float [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BSRequestDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BLDRequestDR</Value>
</Value>
<Value name="3">
<Value>Product</Value>
</Value>
<Value name="4">
<Value>BloodGroupABO</Value>
</Value>
<Value name="5">
<Value>Volume</Value>
</Value>
<Value name="6">
<Value>ProductDR</Value>
</Value>
<Value name="7">
<Value>BloodGroupDR</Value>
</Value>
<Value name="8">
<Value>PorposeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSRequestDetailsD</DataLocation>
<DefaultData>BSRequestDetailsDefaultData</DefaultData>
<IdLocation>^dbo.BSRequestDetailsD</IdLocation>
<IndexLocation>^dbo.BSRequestDetailsI</IndexLocation>
<StreamLocation>^dbo.BSRequestDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
