Include webimport

IncludeGenerator webimport

Class web.ARCInsurAssociation Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 296;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "INSAS_DateTo";

Parameter SQLCODE = "INSAS_Code";

Parameter SQLDESCRIPTION = "INSAS_Desc";

Parameter SQLROWID = "INSAS_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", payor As %String = "", date As %Date = "") As %Boolean
{
}

ClassMethod LookUpBrokerPlan(itmjs As %Library.String = "", itmjsex As %Library.String = "", planDesc As %Library.String = "", payorDesc As %Library.String = "")
{
}

Query LookUpByPayor(desc As %String, payor As %String, date As %Date = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Office:%String,Payor:%String")
{
	SELECT INSAS_Desc, INSAS_InsType_DR->INST_Desc
	FROM ARC_InsurAssociation
	WHERE (INSAS_Desc %STARTSWITH :desc) AND (INSAS_InsType_DR->INST_Desc %STARTSWITH :payor)
	AND	((:date IS NULL) OR (INSAS_StartDate IS NULL) OR (INSAS_StartDate<= :date))
	AND	((:date IS NULL) OR (INSAS_DateTo IS NULL) OR (INSAS_DateTo>= :date))
}

ClassMethod LookUpByPayorBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", payor As %String = "", date As %Date = "") As %Boolean
{
}

//Eliot log 64427 Start

/*ClassMethod FindByPayor(payor As %String = "", hospital As %String = "") As %Library.String
{
	n office,ID,payorID,HospitalID,Hospital
	s (office,ID,payorID,HospitalID,Hospital)=""
	
	i payor="" q office=""
	
    ;s ^zeliot($zn,"FindByPayorPlan")=payor_"^"_hospital_"^"_office
    s payor=##Class(%Collation).AlphaUp(payor)
    s payorID=$o(^ARC("INST",0,"Desc",payor,""))
    
    f  s ID=$o(^ARC("DEFINS",0,"InsType",payorID,ID)) q:'ID  q:office'=""  d
    . ;s ^zeliot($zn,"ID"_ID)=ID
    . s (HospitalID,Hospital)=""
    . s HospitalID=$p($g(^ARC("DEFINS",ID)),"^",4)    
    . i HospitalID'="" s Hospital=$P($g(^CT("HOSP",HospitalID)),"^",2)
    . i (hospital=Hospital) d
    . . s office=$p(^ARC("INSAS",$p($g(^ARC("DEFINS",ID)),"^",3)),"^",2) 
    
    i office'="" q office
    
     f  s ID=$o(^ARC("DEFINS",0,"InsType",payorID,ID)) q:'ID  q:office'=""  d
    . ;s ^zeliot($zn,"ID"_ID)=ID
    . s office=$p(^ARC("INSAS",$p($g(^ARC("DEFINS",ID)),"^",3)),"^",2) 
   
	
	q office
}
*/
ClassMethod FindByPayorPlan(payor As %String = "", plan As %String = "", hospital As %String = "") As %Library.String
{
}

//Eliot log 64427 End

/// Log 64705 - 06.11.2007
ClassMethod LookUpOfficeDetailsExecute(ByRef QHandle As %Binary, desc As %String, payor As %String, date As %Date = "") As %Status
{
}

ClassMethod LookUpOfficeDetailsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOfficeDetailsExecute ]
{
}

ClassMethod LookUpOfficeDetailsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpOfficeDetailsExecute ]
{
}

/// Log 64705 - 06.11.2007
Query LookUpOfficeDetails(desc As %String, payor As %String, date As %Date = "") As %Query(ROWSPEC = "Office:%String,Payor:%String,Address:%String,Billing Address:%String,Phone:%String,Fax:%String,Date From:%String,Date To:%String,Government No:%String,State:%String,Zip:%String")
{
}

}
