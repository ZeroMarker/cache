Class web.eprajax.orderdata Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s ^aaa(1) = ""
	w "{ root : [{ ordDateTime : 'ordDateTime', excDateTime : 'excDateTime', name : 'name', dosage : 'dosage', unit : 'unit', frequency : 'frequency', period : 'period', category : 'category', status : 'status', prescriptionID : 'prescriptionID', pharmStatus : 'pharmStatus', auditor : 'auditor'}]} "
	q $$$OK
}

}
