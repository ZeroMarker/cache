///     
Class dbo.BDReqFormCheckItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormCheckItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFCheckICheckItem created via DDL
ForeignKey FKBDRFCheckICheckItem(CheckItemDR) References dbo.BBCheckItem(PKBBCHECKITEM) [ SqlName = FK_BD_RFCheckI_CheckItem ];

/// Foreign Key FKBDRFCheckICheckUser created via DDL
ForeignKey FKBDRFCheckICheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCheckI_CheckUser ];

/// Foreign Key FKBDRFCheckIReqForm created via DDL
ForeignKey FKBDRFCheckIReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFCheckI_ReqForm ];

Index IndexMaster On (ReqFormDR, CheckItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQFORMCHECKITEM On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMCHECKITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDReqFormCheckItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>CheckItemDR</Value>
</Value>
<Value name="4">
<Value>CheckDate</Value>
</Value>
<Value name="5">
<Value>CheckTime</Value>
</Value>
<Value name="6">
<Value>CheckUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormCheckItemD</DataLocation>
<DefaultData>BDReqFormCheckItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormCheckItemD</IdLocation>
<IndexLocation>^dbo.BDReqFormCheckItemI</IndexLocation>
<StreamLocation>^dbo.BDReqFormCheckItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
