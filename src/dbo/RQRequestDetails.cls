/// 申请明细
Class dbo.RQRequestDetails Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_RequestDetails, StorageStrategy = Default ]
{

/// Foreign Key FKRequestDetails created via DDL
ForeignKey FKRequestDetails(RequestDR) References dbo.RQRequest(PKRQREQUEST) [ SqlName = FK_RequestDetails ];

/// Foreign Key FKRequestDetailsContainer created via DDL
ForeignKey FKRequestDetailsContainer(ContainerDR) References dbo.BTContainer(PKBTCONTAINER) [ SqlName = FK_RequestDetailsContainer ];

/// Foreign Key FKRequestDetailsSite created via DDL
ForeignKey FKRequestDetailsSite(AnatomicalSiteDR) References dbo.BTAnatomicalSite(PKBTANATOMICALSITE) [ SqlName = FK_RequestDetailsSite ];

/// Foreign Key FKRequestDetailsSpecimen created via DDL
ForeignKey FKRequestDetailsSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_RequestDetailsSpecimen ];

/// Foreign Key FKRequestDetailsTs created via DDL
ForeignKey FKRequestDetailsTs(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_RequestDetailsTs ];

Index IndexInvoiceNo On InvoiceNo [ SqlName = Index_InvoiceNo, Type = index ];

Index IndexMaster On (RequestDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRQREQUESTDETAILS On RowID [ PrimaryKey, SqlName = PK_RQ_REQUESTDETAILS, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单  
Property RequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 采集部位  
Property AnatomicalSiteDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 采集部位描述  
Property AnatomicalSiteDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

/// 采集容器  
Property ContainerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否加急  {1:true,0:false}
Property Urgent As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 状态  {1:登记,2:执行,3:取消,O:其他}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 10 ];

/// 是否收费  {1:true,0:false}
Property Payed As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 发票号  
Property InvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

/// 项目列表  
Property TestSetList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RQRequestDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>SpecimenDR</Value>
</Value>
<Value name="5">
<Value>AnatomicalSiteDR</Value>
</Value>
<Value name="6">
<Value>AnatomicalSiteDesc</Value>
</Value>
<Value name="7">
<Value>ContainerDR</Value>
</Value>
<Value name="8">
<Value>Urgent</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>Payed</Value>
</Value>
<Value name="11">
<Value>InvoiceNo</Value>
</Value>
<Value name="12">
<Value>TestSetList</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RQRequestDetailsD</DataLocation>
<DefaultData>RQRequestDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQRequestDetailsD</IdLocation>
<IndexLocation>^dbo.RQRequestDetailsI</IndexLocation>
<StreamLocation>^dbo.RQRequestDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
