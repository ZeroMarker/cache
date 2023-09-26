Class web.PAPrDelBabyDelMthd Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpDelMthClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDelMthFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// zhouzq 2012.06.04  Used In Compoinet Item:PAPregDelBaby.EditFull1:RESUSEntered 
ClassMethod LookUpDelMthExecute(ByRef QHandle As %Library.Binary, BabyId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid,objMethod
	Set repid=$I(^CacheTemp)
	if BabyId="" {
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ind=1

	s PregnancyId=$P(BabyId,"||",1)
	s DELChildsub=$P(BabyId,"||",2)
	s BABYChildsub=$P(BabyId,"||",3)
	s PDBDMChildsub=0
	f  {
		s PDBDMChildsub=$O(^PAPRG(PregnancyId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBDM",PDBDMChildsub))
		Q:PDBDMChildsub=""
		s rowid=PregnancyId_"||"_DELChildsub_"||"_BABYChildsub_"||"_PDBDMChildsub
		s objMethod=##class(User.PAPrDelBabyDelMthd).%OpenId(rowid)
		s desc=""
		if $IsObject(objMethod) {
			s desc=objMethod.PDBDMDelMthdDR.DLMTHDesc
			s DLMTHRowId=objMethod.PDBDMDelMthdDR.%Id()
			s values=rowid_$C(2)_DLMTHRowId
			Set ^CacheTemp(repid,ind)=$lb(values,desc)
			Set ind=ind+1
		}
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpDelMthFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDelMthExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod websysSaveAll(BabyId As %Library.String, Items As %Library.String)
{
}

Parameter SQLCODE = "PDBDM_RowId";

Parameter SQLDESCRIPTION = "PDBDM_RowId";

Parameter SQLROWID = "PDBDM_RowId";

Query Find(BabyId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,DLMTH_Desc,PDBDM_DelMthd_DR")
{
SELECT 
PDBDM_RowId, 
PDBDM_DelMthd_DR->DLMTH_Desc, 
PDBDM_DelMthd_DR 
FROM SQLUser.PA_PrDelBabyDelMthd
WHERE PDBDM_ParRef = :BabyId
}

Query LookUpDelMth(BabylId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

Query LookUpDelMthCustom(BabylId As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
 select PDBDM_RowId,PDBDM_DelMthd_DR->DLMTH_Desc from SQLUser.PA_PrDelBabyDelMthd where PDBDM_ParRef=:BabylId
}

}
