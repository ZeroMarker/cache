Include webimport

IncludeGenerator webimport

Class web.PHCFreq Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 144;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PHCFR_Code";

Parameter SQLDESCRIPTION = "PHCFR_Desc1";

Parameter SQLROWID = "PHCFR_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetDipensingTime(FreqRowID As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerFrequency(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpFreqClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFreqFetch ]
{
}

ClassMethod LookUpFreqExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpFreqFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFreqExecute ]
{
}

Query FindDipensingTime(FreqRowID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PHCDTRowId:%String,PHCDTTime:%String")
{
SELECT PHCDT_RowId,PHCDT_Time
FROM PHC_DispensingTime
where PHCDT_PHCFR_ParRef=:FreqRowID
}

Query LookUpFreq(Desc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "FreqDesc,FreqCode,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpFrequency(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "PHCFRDesc,PHCFRCode,HIDDEN:%String,HIDDEN:%String")
{
SELECT PHCFR_Desc1, PHCFR_Code, PHCFR_Factor,PHCFR_Days
FROM PHC_Freq
WHERE   PHCFR_Desc1  %STARTSWITH  :desc
ORDER   BY PHCFR_Desc1
}

/// log 63684
ClassMethod GetFreqLookupResult(PHCFRDesc As %Library.String = "") As %Library.String
{
}

ClassMethod GetFrequence(desc) As %String
{
 /*	
 set PHCFRRowId=0,FrequenceCombox=""
 f  set PHCFRRowId=$o(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""  d
 .set PHCFDesc=$p(^PHCFR(PHCFRRowId),"^",3)
 .set FrequenceCombox=FrequenceCombox_PHCFRRowId_$c(1)_PHCFDesc_"-"
 
 s FrequenceCombox=$e(FrequenceCombox,1,$l(FrequenceCombox)-1)
 q FrequenceCombox 
 */
  s (FrequencDesc,Code,ret,TRData)=""
  Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpFrequence")
  set ret=""_$C(1)_"-"
  do rset.Execute(desc)
  	While (rset.Next()) {
		s RowId=rset.GetData(1)
		s Code=rset.GetData(3)
		s:$f(Code,"-")'=0 Code=$Replace(Code,"-","***")
		s:$f(Code,"1ONCE")'=0 Code=$Replace(Code,"1ONCE","ONCE")
		s:$e(Code,1)="I" Code=$e(Code,2,$l(Code))
		s FrequencDesc=rset.GetData(2)
		s:$f(FrequencDesc,"-")'=0 FrequencDesc=$Replace(FrequencDesc,"-","***")
		s TRData=RowId_$C(1)_FrequencDesc        ;_"-"_Code
		i ret="" s ret=TRData
		e  s ret=ret_"^"_TRData
		
	}
	q ret
}

}
