Class web.PADischargeSummaryRefDoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 135;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REF_RowId";

Parameter SQLDESCRIPTION = "REF_RowId";

Parameter SQLROWID = "REF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 42980 - AI - 28-04-2004 : Created method to return all Discharge Summary Referal Doctors in the one string.
ClassMethod GetStoredDistList(dissumid As %String = "", diseps As %String = "", currdisid As %String = "")
{
}

/*
ClassMethod LookUpForListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxFetch ]
{
 s QHandle=""
 Quit $$$OK
}

ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, DischID As %Library.String = "") As %Library.Status
{
 n user, work	
 s (user,work)=""
 
 &SQL(
  DECLARE	DischList CURSOR FOR
  SELECT	REF_RefDoc_DR,REF_RefDocClinic_DR
  FROM		SQLUser.PA_DischargeSummaryRefDoc
  WHERE		REF_ParRef=:DischID
 )

 &SQL(OPEN DischList)
 ;
 s QHandle=$lb(0,user,work)
 ; 
 QUIT $$$OK
}

ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
 n docid,docdesc,clinid,clindesc
 s (docid,docdesc,clinid,clindesc)=""

 s AtEnd=$li(QHandle,1)
 s user=$li(QHandle,2)
 s work=$li(QHandle,3)
 ;
 &SQL(FETCH DischList INTO :docid,:clinid)
 
 i SQLCODE d
 . s AtEnd=1
 . &SQL(CLOSE DischList)

 i 'SQLCODE,docid d
 . s dist=docid_"^"_clinid
 . ; doctor details
 . s docdata=$g(^PAC("REFD",+docid))
 . s docdesc=""
 . ; title
 . i $p(docdata,"^",51)'="",$d(^CT("TTL",$p(docdata,"^",51))) s docdesc=$p(^CT("TTL",$p(docdata,"^",51)),"^",2)
 . ; forename
 . s docdesc=docdesc_" "_$p(docdata,"^",49)
 . ; middle name
 . s docdesc=docdesc_" "_$p(docdata,"^",52)
 . ; surname
 . s docdesc=docdesc_" "_$p(docdata,"^",2)
 . ;
 . ; s datefrom=$p(docdata,"^",15)
 . ; s dateto=$p(docdata,"^",16)
 . ;
 . ; if doctor is not associated with any clinics
 . i clinid="" d
 . . ; clinic details - for doctor-only, get address details of doctor
 . . s clindesc=""
 . . ; address1
 . . i $d(^PAC("REFD",docid,"ADDR",1)) s clindesc=^PAC("REFD",docid,"ADDR",1)
 . . ; address2
 . . i $d(^PAC("REFD",docid,"ADDR",2)) s clindesc=clindesc=clindesc_", "_^PAC("REFD",docid,"ADDR",2)
 . . i '$d(^PAC("REFD",docid,"ADDR",2)) s clindesc=clindesc=clindesc_", "
 . . ; city
 . . s city=""
 . . i $p(docdata,"^",6)'="",$d(^CT("CIT",$p(docdata,"^",6))) s city=$p(^CT("CIT",$p(docdata,"^",6)),"^",2)
 . . s clindesc=clindesc_", "_city
 . . ; zipcode
 . . s zipcode=""
 . . i $p(docdata,"^",5)'="",$d(^CT("ZIP",$p(docdata,"^",5))) s zipcode=$p(^CT("ZIP",$p(docdata,"^",5)),"^",1)
 . . s clindesc=clindesc_", "_zipcode
 . . ; preferred contact method
 . . s method=""
 . . i $p(docdata,"^",44)'="" s method=##Class(websys.StandardTypeItem).GetDescription("PreferredContact",$p(docdata,"^",44))
 . . s clindesc=clindesc_", "_method
 . ;
 . ; if doctor is associated with a clinic
 . i clinid'="" d
 . . ; clinic details
 . . s clindata=$g(^PAC("REFD",+docid,"CLN",+clinid))
 . . s clindesc=""
 . . ;
 . . s ClinDRId=$p(clindata,"^",16)
 . . i ClinDRId'="" d
 . . . s csdata=$g(^PAC("CLN",ClinDRId))
 . . . ; address1
 . . . s clindesc=$p(csdata,"^",3)
 . . . ; address2
 . . . s clindesc=clindesc_", "_$p(csdata,"^",4)
 . . . ; city
 . . . s city=""
 . . . i $p(csdata,"^",5)'="",$d(^CT("CIT",$p(csdata,"^",5))) s city=$p(^CT("CIT",$p(csdata,"^",5)),"^",2)
 . . . s clindesc=clindesc_", "_city
 . . . ; zipcode
 . . . s zipcode=""
 . . . i $p(csdata,"^",6)'="",$d(^CT("ZIP",$p(csdata,"^",6))) s zipcode=$p(^CT("ZIP",$p(csdata,"^",6)),"^",1)
 . . . s clindesc=clindesc_", "_zipcode
 . . . ;
 . . . ; s clindatefrom=$p(csdata,"^",11)
 . . . ; s clindateto=$p(csdata,"^",12)
 . . ;
 . . i ClinDRId="" d
 . . . ; address1
 . . . s clindesc=$p(clindata,"^",2)
 . . . ; address2
 . . . s clindesc=clindesc_", "_$p(clindata,"^",3)
 . . . ; city
 . . . s city=""
 . . . i $p(clindata,"^",4)'="",$d(^CT("CIT",$p(clindata,"^",4))) s city=$p(^CT("CIT",$p(clindata,"^",4)),"^",2)
 . . . s clindesc=clindesc_", "_city
 . . . ; zipcode
 . . . s zipcode=""
 . . . i $p(clindata,"^",5)'="",$d(^CT("ZIP",$p(clindata,"^",5))) s zipcode=$p(^CT("ZIP",$p(clindata,"^",5)),"^",1)
 . . . s clindesc=clindesc_", "_zipcode
 . . . ;
 . . . ; s clindatefrom=$p(csdata,"^",16)
 . . . ; s clindateto=$p(csdata,"^",17)
 . . ; 
 . . ; preferred contact method
 . . s method=""
 . . i $p(clindata,"^",12)'="" s method=##Class(websys.StandardTypeItem).GetDescription("PreferredContact",$p(clindata,"^",12))
 . . s clindesc=clindesc_", "_method
 . s distdesc=docdesc_", "_clindesc

 s Row=""
 i 'AtEnd {
 	s Row=$lb(dist,distdesc)
 }
 s QHandle=$lb(AtEnd,user,work)
 Quit $$$OK
}
*/
/// Log 42980 - AI - 28-04-2004 : Save off any Referral Doctors for the given Discharge Summary.
ClassMethod websysSaveDisSumRefDocs(dissumid As %String = "")
{
}

Query LookUpForListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "dist,distdesc")
{
}

}
