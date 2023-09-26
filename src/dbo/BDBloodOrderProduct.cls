Class dbo.BDBloodOrderProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BloodOrderProduct, StorageStrategy = Default ]
{

ForeignKey FKBDBOProductBloodOrder(BloodOrderDR) References dbo.BDBloodOrder(PKBDBLOODORDER) [ SqlName = FK_BD_BOProduct_BloodOrder ];

ForeignKey FKBDReqRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BD_Req_RH ];

ForeignKey FKBDBOProductSupProduct(SupplierProductDR) References dbo.BBSupplierProduct(PKBBSUPPLIERPRODUCT) [ SqlName = FK_BD_BOProduct_SupProduct ];

Index IndexMaster On (BloodOrderDR, SupplierProductDR, PackageSize, RHDR) [ SqlName = Index_Master, Type = index ];

Index IndexBloodOrder On (BloodOrderDR, SupplierProductDR, RHDR) [ SqlName = Index_BloodOrder, Type = index ];

Index PKBDBLOODORDERPRODUCT On RowID [ PrimaryKey, SqlName = PK_BD_BLOODORDERPRODUCT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodOrderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SupplierProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackageSize As %Library.Float [ SqlColumnNumber = 5 ];

Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AReqSum As %Library.Float [ SqlColumnNumber = 7 ];

Property AAckSum As %Library.Float [ SqlColumnNumber = 8 ];

Property BReqSum As %Library.Float [ SqlColumnNumber = 9 ];

Property BAckSum As %Library.Float [ SqlColumnNumber = 10 ];

Property ABReqSum As %Library.Float [ SqlColumnNumber = 11 ];

Property ABAckSum As %Library.Float [ SqlColumnNumber = 12 ];

Property OReqSum As %Library.Float [ SqlColumnNumber = 13 ];

Property OAckSum As %Library.Float [ SqlColumnNumber = 14 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BDBloodOrderProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodOrderDR</Value>
</Value>
<Value name="3">
<Value>SupplierProductDR</Value>
</Value>
<Value name="4">
<Value>PackageSize</Value>
</Value>
<Value name="5">
<Value>RHDR</Value>
</Value>
<Value name="6">
<Value>AReqSum</Value>
</Value>
<Value name="7">
<Value>AAckSum</Value>
</Value>
<Value name="8">
<Value>BReqSum</Value>
</Value>
<Value name="9">
<Value>BAckSum</Value>
</Value>
<Value name="10">
<Value>ABReqSum</Value>
</Value>
<Value name="11">
<Value>ABAckSum</Value>
</Value>
<Value name="12">
<Value>OReqSum</Value>
</Value>
<Value name="13">
<Value>OAckSum</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBloodOrderProductD</DataLocation>
<DefaultData>BDBloodOrderProductDefaultData</DefaultData>
<IdLocation>^dbo.BDBloodOrderProductD</IdLocation>
<IndexLocation>^dbo.BDBloodOrderProductI</IndexLocation>
<StreamLocation>^dbo.BDBloodOrderProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
