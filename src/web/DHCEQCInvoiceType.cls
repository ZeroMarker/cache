Class web.DHCEQCInvoiceType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetInvoiceType() As %SQLQuery(ROWSPEC = "TDesc:%String,Hidden:%String,TCode:%String")
{
SELECT IT_Desc TDesc,
	   IT_RowID TRowID,	
	   IT_Code TCode
	   
FROM sqluser.DHC_EQCInvoiceType
where IT_InvalidFlag='N'
}

}
