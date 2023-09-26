Class web.BBPPackDetails Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod BloodResultsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = BloodResultsFetch ]
{
}

ClassMethod BloodResultsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", hospitallist As %Library.String = "", statuslist As %Library.String = "", bloodproductlist As %Library.String = "") As %Library.Status
{
}

ClassMethod BloodResultsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = BloodResultsExecute ]
{
}

Query BloodResults(PatientID As %String, hospitallist As %String, statuslist As %String, bloodproductlist As %String) As %Query(CONTAINID = 0, ROWSPEC = "ID:%String,pack:%String,sequence:%String,transaction:%String,tdate:%Date,ttime:%Time,userdesc:%String,comments:%String,status:%String,autologous:%String,bloodgroup:%String,bloodproduct:%String,expirydate:%Date,collectiondate:%Date,receiveddate:%Date,statusreserve:%String,genotype:%String,packvolume:%String,collectiontime:%Time,receivedtime:%Time,userreceived:%String,bblocation:%String")
{
}

}
