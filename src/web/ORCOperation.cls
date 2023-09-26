Include webimport

IncludeGenerator webimport

Class web.ORCOperation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 333;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "OPER_ActiveDateTo";

Parameter SQLCODE = "OPER_Code";

Parameter SQLDESCRIPTION = "OPER_Desc";

Parameter SQLROWID = "OPER_RowId";

Property dummy As %String(TRUNCATE = 1);

/// KM 27-Sept-2001: Called from RBAppointment.websysSaveApptStatus
/// Once the LookUpBroker method works for this class then should only need method GetCodeFromDescription
ClassMethod GetCodeFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

/// Author - JH
/// This method was put in to get exact matches for codes like A01.1 so they ingored to A011 due to the 
/// $$ALPHAUP in the index global 
ClassMethod GetIdFromCode(code As %Library.String)
{
}

/// KK 29/jan/2004 L:41950 Used in MRProcedures.websysSaveDRG and PAAdmCoding.websysSaveMappedICD Methods
ClassMethod GetIdFromCodeandDate(code As %Library.String = "", Activedate As %Library.String = "") As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// 
/// this differs from the generic LookUpBroker method, in that the javascript methods are always called
///  even for invalid matches so that other scripts can be run
ClassMethod LookUpBrokerJS(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// CS 14/1/04 Log 41685
ClassMethod LookUpBrokerEstTime(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "", dischdate As %Library.String = "", bookdate As %Library.Date = "", reqdate As %Library.Date = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerOperation(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerOperation2(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/*
/// KK 15/May/2003 Log 33703 LookUpBroker with Edition validation
/// cjb 18/08/2006 58987 - commented out - LookUpBrokerOperationKeyWord now used from MRProcedures.EditDRG
ClassMethod LookUpOnDischDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", dischdate As %Library.String = "") As %Library.Boolean
{
 n retval,ICDEDId
 n Desc,ID,Code,MechVentilCode,Blocknumber,AGECHKCode,AgeFrom,AgeTo,AGECHKCode2,Age2From,Age2To,SEXCHKCode,AREACRCode,ADDCRCode,CODPRCode,ProcDateMandatory,SexRestrict
 
 s (Desc,ID,Code,MechVentilCode,Blocknumber,AGECHKCode,AgeFrom,AgeTo,AGECHKCode2,Age2From,Age2To,SEXCHKCode,AREACRCode,ADDCRCode,CODPRCode,ProcDateMandatory,SexRestrict)=""
 s Desc=val
 s ICDEDId=""
 i dischdate'="" s dischdate=##Class(websys.Conversions).DateHtmlToLogical(dischdate)
 i dischdate="" s dischdate=+$h
 &sql(	SELECT  ICDED_RowId 
 	INTO 	:ICDEDId
 	FROM 	SQLUser.MRC_ICDEdition
 	WHERE	(ICDED_DateFrom <= :dischdate)
 	AND	((ICDED_DateTo >= :dischdate) OR (ICDED_DateTo IS NULL))
 )	
 
 ; cjb 09/12/2004 48023 - changed CTSEX_Code to CTSEX_Desc
 i ICDEDId'="" {
 	&sql(	SELECT	OPER_Desc,OPER_RowID,OPER_Code,OPER_MechVentilCode,OPER_BlockNumber,
 			OPER_AgeCheckType_DR->AGECHK_Code, OPER_AgeFrom, OPER_AgeTo,
 			OPER_Age2CheckType_DR->AGECHK_Code, OPER_Age2From, OPER_Age2To,
 			OPER_SexCheckType_DR->SEXCHK_Code, OPER_AreaCodeRestraints_DR->AREACR_Code,
 			OPER_AddCodReq_DR->ADDCR_Code, OPER_CodPractices_DR->CODPR_Code,
 			OPER_ProcDateMandatory, OPER_Sex_DR->CTSEX_Desc
 		INTO :Desc,:ID,:Code,:MechVentilCode,:Blocknumber,:AGECHKCode,:AgeFrom,:AgeTo,:AGECHKCode2,:Age2From,:Age2To,:SEXCHKCode,:AREACRCode,:ADDCRCode,:CODPRCode,:ProcDateMandatory,:SexRestrict
 		FROM	SQLUser.ORC_Operation
 		WHERE	((%ALPHAUP OPER_Desc= %ALPHAUP :val) OR ( %ALPHAUP OPER_Code= %ALPHAUP :val))
 		AND     (OPER_DateActiveFrom <= :dischdate) 
 		AND 	((OPER_ActiveDateTo >= :dischdate) OR (OPER_ActiveDateTo IS NULL))
 		AND		(OPER_RowId=ANY (SELECT ED_ParRef FROM SQLUser.ORC_OperationEdition WHERE ED_Edition_DR=:ICDEDId))
 	)
 	i SQLCODE s ID="",Code="",Desc=val
 } else {	
 	if val'="" {
 	  &sql(SELECT	OPER_Desc,OPER_RowID,OPER_Code,OPER_MechVentilCode,OPER_BlockNumber,
 			OPER_AgeCheckType_DR->AGECHK_Code, OPER_AgeFrom, OPER_AgeTo,
 			OPER_Age2CheckType_DR->AGECHK_Code, OPER_Age2From, OPER_Age2To,
 			OPER_SexCheckType_DR->SEXCHK_Code, OPER_AreaCodeRestraints_DR->AREACR_Code,
 			OPER_AddCodReq_DR->ADDCR_Code, OPER_CodPractices_DR->CODPR_Code,
 			OPER_ProcDateMandatory, OPER_Sex_DR->CTSEX_Code
 		INTO :Desc,:ID,:Code,:MechVentilCode,:Blocknumber,:AGECHKCode,:AgeFrom,:AgeTo,:AGECHKCode2,:Age2From,:Age2To,:SEXCHKCode,:AREACRCode,:ADDCRCode,:CODPRCode,:ProcDateMandatory,:SexRestrict
 		FROM	SQLUser.ORC_Operation
 		WHERE	((%ALPHAUP OPER_Desc=%ALPHAUP :val) OR (%ALPHAUP OPER_Code= %ALPHAUP :val))
 		AND     (OPER_DateActiveFrom <= :dischdate) 
 		AND 	((OPER_ActiveDateTo >= :dischdate) OR (OPER_ActiveDateTo IS NULL))
 	  )
 	  i SQLCODE {
 		//do something to check aliases
 	  }
 	  i SQLCODE s ID="",Code="",Desc=val
 	}
 }
 //call javascript even if invalid
 s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"');"
 i itmjsex'="" s retval=retval_itmjsex_"('"_$ZCVT(Desc,"O","JS")_"^"_ID_"^"_$ZCVT(Code,"O","JS")_"^"_MechVentilCode_"^"_Blocknumber_"^"_AGECHKCode_"^"_AgeFrom_"^"_AgeTo_"^"_AGECHKCode2_"^"_Age2From_"^"_Age2To_"^"_SEXCHKCode_"^"_AREACRCode_"^"_ADDCRCode_"^"_CODPRCode_"^"_ProcDateMandatory_"^"_SexRestrict_"^"_"');"
 &javascript<#(retval)#>
 
 i SQLCODE,val'="" QUIT 0
 QUIT 1
}
*/

/*
/// cjb 18/08/2006 58987 - commented out - LookUpOperationKeyWord now used from MRProcedures.EditDRG
ClassMethod LookUpOnDischDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOnDischDateFetch ]
{
 n user,work,rowid
 
 s QHandle=""
 
 Quit $$$OK
}

/// KK 14/May/2003 Log 33703 LookUp with ICD Edition and active date validation
ClassMethod LookUpOnDischDateExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", dischdate As %Library.Date) As %Library.Status
{
 ; 'user' search values, current 'work' values, 
 n user,work
 n rowid,datefr,dateto,icdcode,icdrowid,editioncode
 
 s (rowid,datefr,dateto)=""
 s (icdcode,icdrowid,editioncode)=""
 i dischdate'="" s dischdate=##Class(websys.Conversions).DateHtmlToLogical(dischdate)
 i dischdate="" s dischdate=+$h
 ;nextICD
 ;s icdcode=$o(^MRC("ICDED",0,"Code",icdcode))
 ;i icdcode="" g exitICD
 ;s icdrowid=$o(^MRC("ICDED",0,"Code",icdcode,icdrowid))
 ;i (icdrowid'="") {
 ;	s editioncode=$p($g(^MRC("ICDED",+icdrowid)),"^",1)
 ;	s datefr=$p($g(^MRC("ICDED",+icdrowid)),"^",3)
 ;	s dateto=$p($g(^MRC("ICDED",+icdrowid)),"^",4)
 ;	i (editioncode=icdcode)&(datefr<dischdate)&((dateto>dischdate)!(dateto="")) {
 ;		s rowid=icdrowid
 ;	}
 ;}
 ;i rowid="" g nextICD
 ;exitICD
 &sql(	SELECT  ICDED_RowId 
 	INTO 	:rowid
 	FROM 	SQLUser.MRC_ICDEdition
 	WHERE	(ICDED_DateFrom <= :dischdate)
 	AND	((ICDED_DateTo >= :dischdate) OR (ICDED_DateTo IS NULL))
 )	
 ; cjb 09/12/2004 48023 - changed CTSEX_Code to CTSEX_Desc
 i rowid'=""{
 	&sql(	
 		DECLARE PROCCursor CURSOR FOR 
 		SELECT	OPER_Desc,OPER_RowID,OPER_Code,OPER_MechVentilCode,OPER_BlockNumber,
 			OPER_AgeCheckType_DR->AGECHK_Code, OPER_AgeFrom, OPER_AgeTo,
 			OPER_Age2CheckType_DR->AGECHK_Code, OPER_Age2From, OPER_Age2To,
 			OPER_SexCheckType_DR->SEXCHK_Code, OPER_AreaCodeRestraints_DR->AREACR_Code,
 			OPER_AddCodReq_DR->ADDCR_Code, OPER_CodPractices_DR->CODPR_Code,
 			OPER_ProcDateMandatory, OPER_Sex_DR->CTSEX_Desc
 		FROM	SQLUser.ORC_Operation
 		WHERE	(OPER_RowId=ANY
 				(SELECT ED_ParRef 
 				FROM SQLUser.ORC_OperationEdition 
 				WHERE ED_Edition_DR=:rowid))
 		AND	((%UPPER OPER_Desc %STARTSWITH %UPPER :val) OR (%UPPER OPER_Code %STARTSWITH %UPPER :val))
 		AND     (OPER_DateActiveFrom <= :dischdate) 
 		AND 	((OPER_ActiveDateTo >= :dischdate) OR (OPER_ActiveDateTo IS NULL))
 		ORDER	BY OPER_Desc
 	)
 	&sql(OPEN PROCCursor)
 }else{
 	&sql(
 		DECLARE PROCedureCursor CURSOR FOR 
 		SELECT	OPER_Desc,OPER_RowID,OPER_Code,OPER_MechVentilCode,OPER_BlockNumber,
 			OPER_AgeCheckType_DR->AGECHK_Code, OPER_AgeFrom, OPER_AgeTo,
 			OPER_Age2CheckType_DR->AGECHK_Code, OPER_Age2From, OPER_Age2To,
 			OPER_SexCheckType_DR->SEXCHK_Code, OPER_AreaCodeRestraints_DR->AREACR_Code,
 			OPER_AddCodReq_DR->ADDCR_Code, OPER_CodPractices_DR->CODPR_Code,
 			OPER_ProcDateMandatory, OPER_Sex_DR->CTSEX_Desc
 		FROM	SQLUser.ORC_Operation
 		WHERE	((%UPPER OPER_Desc %STARTSWITH %UPPER :val) OR (%UPPER OPER_Code %STARTSWITH %UPPER :val))
 		AND     (OPER_DateActiveFrom <= :dischdate) 
 		AND 	((OPER_ActiveDateTo >= :dischdate) OR (OPER_ActiveDateTo IS NULL))
 		ORDER	BY OPER_Desc
 	)
 	&sql(OPEN PROCedureCursor)
 }
 
 s user=$lb(val,rowid)
 s work=$lb("")
 s QHandle=$lb(0,user,work)
 Q $$$OK
}

ClassMethod LookUpOnDischDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOnDischDateExecute ]
{
 n AtEnd,user,work,rowid
 n Desc,ID,Code,MechVentilCode,Blocknumber,AGECHKCode,AgeFrom,AgeTo,AGECHKCode2,Age2From,Age2To,SEXCHKCode,AREACRCode,ADDCRCode,CODPRCode,ProcDateMandatory,SexRestrict
 s (Desc,ID,Code,MechVentilCode,Blocknumber,AGECHKCode,AgeFrom,AgeTo,AGECHKCode2,Age2From,Age2To,SEXCHKCode,AREACRCode,ADDCRCode,CODPRCode,ProcDateMandatory,SexRestrict)=""
 
 s AtEnd=$li(QHandle,1)
 s user=$li(QHandle,2)
 s work=$li(QHandle,3)
 
 s rowid = $li(user,2)
 
 i rowid'=""{
 	&sql(FETCH PROCCursor INTO  :Desc,:ID,:Code,:MechVentilCode,:Blocknumber,:AGECHKCode,:AgeFrom,:AgeTo,:AGECHKCode2,:Age2From,:Age2To,:SEXCHKCode,:AREACRCode,:ADDCRCode,:CODPRCode,:ProcDateMandatory,:SexRestrict)
 }else{
 	&sql(FETCH PROCedureCursor INTO  :Desc,:ID,:Code,:MechVentilCode,:Blocknumber,:AGECHKCode,:AgeFrom,:AgeTo,:AGECHKCode2,:Age2From,:Age2To,:SEXCHKCode,:AREACRCode,:ADDCRCode,:CODPRCode,:ProcDateMandatory,:SexRestrict)
 }
 s Row=""
 i SQLCODE s AtEnd=1
 i 'AtEnd {
 	s Row=$lb(Desc,ID,Code,MechVentilCode,Blocknumber,AGECHKCode,AgeFrom,AgeTo,AGECHKCode2,Age2From,Age2To,SEXCHKCode,AREACRCode,ADDCRCode,CODPRCode,ProcDateMandatory,SexRestrict)
 }
 
 s QHandle=$lb(AtEnd,user,work)
 
 q $$$OK
}
*/
ClassMethod LookUpBrokerOperationKeyWord(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", surgeon As %Library.String = "", dischdate As %Library.String = "", bookdate As %Library.Date = "", reqdate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpOperationKeyWordClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOperationKeyWordFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// wanghc operationdesc
ClassMethod LookUpOperationKeyWordExecute(ByRef QHandle As %Library.Binary, operationdesc As %Library.String, surgeon As %Library.String = "", dischdate As %Library.Date = "", bookdate As %Library.Date = "", reqdate As %Library.Date = "") As %Library.Status
{
	;operationdesc, surgeon, dischdate, bookdate, reqdate
	;dischdate bookdate,reqdate ??????
	s (OPERDesc ,rowid ,OPERCode ,HIDDEN ,OPERBlockNumber,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,OPERMechVentilCode,HIDDEN)=""
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s len=$l(operationdesc)
	f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
	.s obj=##class(User.ORCOperation).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s OPERDesc=obj.OPERDesc
	.q:(operationdesc'="")&&($e(OPERDesc,1,len)'=operationdesc)
	.s OPERDaySurgery=obj.OPERDaySurgery
	.q:(surgeon'="")&&(surgeon'=OPERDaySurgery)	;不知道是不是=
	.s OPERCod=obj.OPERCode
	.s OPERBlockNumber=obj.OPERBlockNumber
	.s OPERMechVentilCode=obj.OPERMechVentilCode
	.s ^CacheTemp(repid,ind)=$lb(OPERDesc,rowid,OPERCode,"",OPERBlockNumber,"","","","","","","","","","","","",OPERMechVentilCode,"")
	.s ind=ind+1
	.d obj.%Close()
	quit $$$OK
}

ClassMethod LookUpOperationKeyWordFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOperationKeyWordExecute ]
{
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

/*
/// cjb - how the query used to look before 58987
ClassMethod LookUpOperationKeyWordClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOperationKeyWordFetch ]
{
 n user,work
 
 k ^TMP("O",$j)
 s QHandle=""
 
 Quit $$$OK
}

ClassMethod LookUpOperationKeyWordExecute(ByRef QHandle As %Library.Binary, operationdesc As %Library.String, surgeon As %Library.String) As %Library.Status
{
 k ^TMP("O",$j)
 s user=$lb()
 s work=$lb(operationdesc,surgeon) 
 s text=##Class(%Library.Collation).Upper(operationdesc) d words
 
 s text0=text,typerow=0
 
 s QHandle=$lb(0,user,work)
 
 Quit $$$OK
words 
 	n j
         k words,maxindex s len=0
         i $l(text),text'[" " s words(1)=text,maxindex=1
         e  f j=1:1:$l(text," ") s words(j)=$p(text," ",j) s:$l(words(j))>len len=$l(words(j)),maxindex=j
         i $d(maxindex) s text=words(maxindex)
 q
}

ClassMethod LookUpOperationKeyWordFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOperationKeyWordExecute ]
{
 n user,work
 n desc,Typedesc,Typecode,orp,estimtime
 
 s (desc,Typedesc,Typecode,orp,estimtime)=""
 
 s AtEnd=$li(QHandle,1)
 s user=$li(QHandle,2)
 s work=$li(QHandle,3)
 
 s desc=$li(work,1)
 s surg=##Class(web.CTCareProv).GetIdFromCodeOrUserDesc($li(work,2))
 s Row=""
 i AtEnd q $$$OK
 g type2
type1
 i text0'="" s text=$o(^ORC("OPER-Name",text)),typerow=0
 i text0="" s text=$o(^ORC("OPER",0,"Desc",text)),typerow=0
 i text="" s AtEnd=1,Row="" Q $$$OK
 i text0'="",$e(text,1,$l(text0))'[text0 s AtEnd=1,Row="" Q $$$OK
type2
 g:text="" type1
 i text0'="" s typerow=$o(^ORC("OPER-Name",text,typerow))
 i text0="" s typerow=$o(^ORC("OPER",0,"Desc",text,typerow))
 i typerow="" g type1
 i $d(^TMP("O",$j,typerow)) g type2
 s ^TMP("O",$j,typerow)=""

 s s=$g(^ORC("OPER",typerow)),desc=$p(s,"^",2)_" "_$p(s,"^")
 i '$$valid() g type2
 s Typecode=$p(s,"^")
 s Typedesc=$p(s,"^",2)
 s estimtime=$p(s,"^",8)
 ; LOG 53428 RC 18/08/05 Checking new preference screen for avg procedure times.
 i surg s orp=$o(^CTPCP(surg,"ORP",0,"Oper",typerow,""))
 i orp'="" d 
 . i $p($g(^CTPCP(surg,"ORP",orp)),"^",6)'="" s estimtime=$p($g(^CTPCP(surg,"ORP",orp)),"^",6)
 
 s Row=$lb(Typedesc,typerow,Typecode,estimtime)
 
 s QHandle=$lb(AtEnd,user,work)
 
 q $$$OK

valid()  ;check if diagnosis description contain other words
         n good,desc1,j s good=1,desc1=" "_##Class(%Library.Collation).Upper(desc)_" "
         f j=1:1 q:'$d(words(j))  i desc1'[(" "_words(j)) s good=0 q
         q good
}
*/
ClassMethod LookUpFreeAliasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFreeAliasFetch ]
{
}

ClassMethod LookUpFreeAliasExecute(ByRef QHandle As %Library.Binary, code As %Library.String, desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpFreeAliasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFreeAliasExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// 
/// this differs from the generic LookUpBroker method, in that the javascript methods are always called
///  even for invalid matches so that other scripts can be run
ClassMethod xxxLookUpBrokerJS(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/*
/// KK 14/May/2003 Log 33703
/// cjb 15/09/2006 58987 - don't think this is used any longer
Query LookUpOnDischDate(val As %String, dischdate As %Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "OPERDesc,HIDDEN,OPERCode,OPERMechVentilCode,OPERBlockNumber,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
}
*/
/// md 29/06/2005 Log 53228
Query LookUpFreeAlias(code As %String, desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Alias Text ")
{
}

/// A query to find the operation description from a partial description or code
Query LookUpOperation(val As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "OPERDesc:%String,OPERCode:%String")
{
SELECT OPER_Desc,OPER_Code
FROM SQLUser.ORC_Operation
WHERE (OPER_Desc %STARTSWITH :val) OR (OPER_Code %STARTSWITH :val)
AND (OPER_ActiveDateTo >= CURRENT_DATE ) OR (OPER_ActiveDateTo is null)
ORDER BY OPER_Desc
}

/// CS 14/1/04 Log 41685 - query finds description,code,estimate time based on a code or description
Query LookUpOpEstTime(val As %Library.String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OPERDesc:%String,Hidden:%String,OPERCode:%String,OPERDefaultEstimTime:%String")
{
SELECT OPER_Desc,OPER_RowId,OPER_Code,OPER_DefaultEstimTime
FROM SQLUser.ORC_Operation
Where ((%ALPHAUP(OPER_Desc) %STARTSWITH %ALPHAUP(:val)) OR (%ALPHAUP(OPER_Code) %STARTSWITH %ALPHAUP(:val)))
Order by OPER_Desc
}

/// A query to find the operation description from a partial description or code.
/// 
Query LookUpOperation2(val As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "OPERDesc:%String,HIDDEN:%String,OPERCode:%String,OPERMechVentilCode:%String")
{
SELECT OPER_Desc,OPER_RowID,OPER_Code,OPER_MechVentilCode
FROM SQLUser.ORC_Operation
WHERE ((%ALPHAUP OPER_Desc %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP OPER_Code = %ALPHAUP :val))
AND ((OPER_ActiveDateTo >= CURRENT_DATE ) OR (OPER_ActiveDateTo is null))
AND (OPER_DateActiveFrom <= CURRENT_DATE )
ORDER BY OPER_Desc
}

/*
/// A query to find the operation description from a partial description or code.
/// KK 18/jun/2002 Log 24569 lookup query also to return block number for austin  
Query LookUpOperationAUSTIN(val As %Library.String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OPERDesc,HIDDEN,OPERCode,OPERMechVentilCode,OPERBlockNumber,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
SELECT OPER_Desc,OPER_RowID,OPER_Code,OPER_MechVentilCode,OPER_BlockNumber,
 OPER_AgeCheckType_DR->AGECHK_Code, OPER_AgeFrom, OPER_AgeTo,
 OPER_Age2CheckType_DR->AGECHK_Code, OPER_Age2From, OPER_Age2To,
 OPER_SexCheckType_DR->SEXCHK_Code, OPER_AreaCodeRestraints_DR->AREACR_Code,
 OPER_AddCodReq_DR->ADDCR_Code, OPER_CodPractices_DR->CODPR_Code,
 OPER_ProcDateMandatory
FROM SQLUser.ORC_Operation
WHERE (%UPPER OPER_Desc %STARTSWITH %UPPER :val) OR (%UPPER OPER_Code %STARTSWITH %UPPER :val)
ORDER BY OPER_Desc
}
*/
/// 手术处理
/// searchs for any part of the description
/// wanghc
Query LookUpOperationKeyWord(operationdesc, surgeon, dischdate, bookdate As %Library.Date, reqdate As %Library.Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "OPERDesc:%String,HIDDEN:%String,OPERCode:%String,HIDDEN:%String,OPERBlockNumber,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,OPERMechVentilCode,HIDDEN")
{
}

}
