Include webimport

IncludeGenerator webimport

Class web.PACAllergy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 559;

Parameter SQLCODE = "ALG_Code";

Parameter SQLDATEFROM = "ALG_DateFrom";

Parameter SQLDESCRIPTION = "ALG_Desc";

Parameter SQLDATETO = "ALG_DateTo";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ALG_DateFrom <= CURRENT_DATE OR ALG_DateFrom IS NULL) AND (ALG_DateTo >= CURRENT_DATE OR ALG_DateTo IS NULL))";

Parameter SQLROWID = "ALG_RowId";

Property dummy As %String(TRUNCATE = 1);

/// cjb 05/05/2005 51228 - 
/// queries each code table in turn
/// after each query, if the query has returned a row, increment the count variable and set the ret* variables (the ones that are returned)
/// after all the queries quit if count>1 - ie more than one of the queries returned somethig and is therefore not unique over many tables (each code table can have an entry with the same name
ClassMethod LookUpAllBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Allergen As %Library.String = "", cat As %Library.String = "", tag As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAllFetch ]
{
 s user=$li(QHandle,2)
 s Category=$li(user,2)
 s allegenTag=$li(user,3)
  
 ;i (Category'=""),(allegenTag="") {
   &sql(CLOSE AllerCat)
 ;}
 i (allegenTag="P") {
   &sql(CLOSE PhmItm)
 }
 i (allegenTag="G") {
   &sql(CLOSE GenDrg)
 }

 i (allegenTag="I") {
   &sql(CLOSE Ingrd)
 }
 
 i (Category="")&&(allegenTag="") {
   &sql(CLOSE AllerCatGenDrg)
   &sql(CLOSE AllerCatPhmItm)
   &sql(CLOSE AllerCatIngr)
   ;&sql(CLOSE AllerCatOther)
 }
 s QHandle=""
 Quit $$$OK
}

/// cjb 20/04/2005 51228 - new query.  written in cache
/// d ##class(%ResultSet).RunQuery("web.PACAllergy","LookUpAll","","","P")
ClassMethod LookUpAllExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, cat As %Library.String, tag As %Library.String, date As %Library.String = "") As %Library.Status
{
	
 n user,work,index,date
 n allegenTag
 s index=0
 ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
 s date=+$h
 ;
 ; check if category has allergen tag 
 s allegenTag=tag
 i cat'="" s allegenTag=$p(^MRC("AT",cat),"^",6)
 
 s ^zTRAK("cjb","LookUpAllExecute",1)=$g(cat)_"^"_$g(allegenTag)
 
 ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
 ; return all allegens for allegen category if present
 ;如果指定分类,但分类上没有定义过敏源标志,则只查找自定义过敏源表
 //i (cat'=""),(allegenTag="") {
   &sql(
 	  DECLARE AllerCat CURSOR FOR
 	  SELECT	ALG_Desc,ALG_RowId,ALG_Code,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR,ALG_Type_DR->MRCAT_TagDescription,'PACAllergy'
 	  FROM	SQLUser.PAC_Allergy
 	  WHERE	( ((%ALPHAUP ALG_Desc %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL)) AND
 	  		  ((ALG_Type_DR=:cat) OR (:cat IS NULL)) AND
 	  		  ((ALG_Type_DR->MRCAT_TagDescription =:allegenTag) OR (:allegenTag IS NULL)) AND 
 	  		  (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
 	  		   ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
 	  ORDER BY ALG_Desc ASC
   )
   &sql(OPEN AllerCat)
 //}
 if (allegenTag'="")
 
   ;--&sql( 
  	;--  DECLARE AllerTag CURSOR FOR
 	;--  SELECT	ALG_Desc,ALG_RowId,ALG_Code,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR,ALG_Type_DR->MRCAT_TagDescription,'PACAllergy'
 	;--  FROM	SQLUser.PAC_Allergy
 	;--  WHERE	( ((%ALPHAUP ALG_Desc %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL)) AND
 	;--  		  (ALG_Type_DR->MRCAT_TagDescription=:allegenTag) AND 
 	;--  		  ((ALG_Type_DR=:cat) OR (:Category IS NULL)) AND 
 	;--		  (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
 	;--		  ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
 	;--  ORDER BY ALG_Type_DR->MRCAT_Desc ASC, ALG_Desc ASC
   ;--)
  ;-- &sql(OPEN AllerTag)

  
 ; return all allegens from Pharmacy items code table if allegen category equals Pharmacy
 i (allegenTag="P") {
   ; Pharmacy Item
   &sql(
 	  DECLARE PhmItm CURSOR FOR
 	  SELECT	PHCD_Name,PHCD_RowId,PHCD_Code,'P','PHCDrgMast'
 	  FROM	SQLUser.PHC_DrgMast
 	  WHERE	((%ALPHAUP PHCD_Name %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL))
 	  ORDER BY PHCD_Name ASC
   )
   &sql(OPEN PhmItm)
 }
 
 ; return all allegens from Generic drugs code table if allegen category equals Generic
 i (allegenTag="G") {
   ; Generic Drug
   &sql(
 	  DECLARE GenDrg CURSOR FOR
 	  SELECT	PHCGE_Name,PHCGE_RowId,PHCGE_Code,'G','PHCGeneric'
 	  FROM	SQLUser.PHC_Generic
 	  WHERE	((%ALPHAUP PHCGE_Name %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL))
 	  AND ( ((PHCGE_DateFrom <= :date) OR (PHCGE_DateFrom IS NULL)) 
 	  AND ((PHCGE_DateTo >= :date) OR (PHCGE_DateTo IS NULL)) )
 	  ORDER BY PHCGE_Name ASC
   )
   &sql(OPEN GenDrg)
 }
 i (allegenTag="I") {
   ; Ingradient
   &sql(
 	  DECLARE Ingrd CURSOR FOR
 	  SELECT	INGR_Desc,INGR_RowId,INGR_Code,'I','PHCIngredient'
 	  FROM	SQLUser.PHC_Ingredient
 	  WHERE	((%ALPHAUP INGR_Desc %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL))
 	  ORDER BY INGR_Desc ASC
   )
   &sql(OPEN Ingrd)
 }

 ; return all allegens in order of Generic->Pharmacy Items->Rest of allegens
 ;如果没有指定分类,则查找所有过敏源
 
 i (cat="")&&(allegenTag="") {
	 &sql(
 	  DECLARE AllerCatGenDrg CURSOR FOR
 	  SELECT	PHCGE_Name,PHCGE_RowId,PHCGE_Code,'G','PHCGeneric'
 	  FROM	SQLUser.PHC_Generic
 	  WHERE	((%ALPHAUP PHCGE_Name %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL))
 	  AND ( ((PHCGE_DateFrom <= :date) OR (PHCGE_DateFrom IS NULL)) 
 	  AND ((PHCGE_DateTo >= :date) OR (PHCGE_DateTo IS NULL)) )
 	  ORDER BY PHCGE_Name ASC
   )
   &sql(OPEN AllerCatGenDrg)

	 &sql(
 	  DECLARE AllerCatPhmItm CURSOR FOR
 	  SELECT	PHCD_Name,PHCD_RowId,PHCD_Code,'P','PHCDrgMast'
 	  FROM	SQLUser.PHC_DrgMast
 	  WHERE	((%ALPHAUP PHCD_Name %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL))
 	  ORDER BY PHCD_Name ASC
   )
   &sql(OPEN AllerCatPhmItm)
   
   &sql(
 	  DECLARE AllerCatIngr CURSOR FOR
 	  SELECT	INGR_Desc,INGR_RowId,INGR_Code,'I','PHCIngredient'
 	  FROM	SQLUser.PHC_Ingredient
 	  WHERE	((%ALPHAUP INGR_Desc %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL))
 	  ORDER BY INGR_Desc ASC
   )
   &sql(OPEN AllerCatIngr)
 /* 
   ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
   &sql(
 	  DECLARE AllerCatOther CURSOR FOR
 	  SELECT	ALG_Desc,ALG_RowId,ALG_Code,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR,ALG_Type_DR->MRCAT_TagDescription,'PACAllergy'
 	  FROM	SQLUser.PAC_Allergy
 	  WHERE	( ((%ALPHAUP ALG_Desc %STARTSWITH %ALPHAUP :desc) OR (:desc IS NULL)) AND
 			  (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
 			   ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
 	  ORDER BY ALG_Type_DR->MRCAT_Desc ASC, ALG_Desc ASC
   )
   &sql(OPEN AllerCatOther)
*/
 }
 ;
 s curNo=1
 s user=$lb(desc,cat,allegenTag)
 s work=$lb(index,curNo)
 s QHandle=$lb(0,user,work)
 ;
 Quit $$$OK
}

/// cjb 05/05/2005 51228 - this fetch starts with mode=1 and runs the PACAllergy lookup.  When all the Allergens have been returned it closes the rs, sets mode=2 and continues through PHCGeneric,PHCDrgMast,PHCIngredient
ClassMethod LookUpAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAllExecute ]
{
 n user,work,index
 n Descr,Category,allegenTag,Description,RowID,Code,Tag,curNo,TagCode,Table,CategoryDesc,CategoryRowId
 s (Descr,Category,allegenTag,Description,RowID,Code,Tag,curNo,TagCode,Table,CategoryDesc,CategoryRowId)=""
 
 s AtEnd=$li(QHandle,1)
 s user=$li(QHandle,2)
 s work=$li(QHandle,3)
 s Descr=$li(user,1)
 s Category=$li(user,2)
 s allegenTag=$li(user,3)
 s index=$li(work,1)
 s curNo=$li(work,2)
top 
 i (Category'=""),(allegenTag="") {
	 s CategoryRowId=Category 
	 &sql(FETCH AllerCat INTO :Description,:RowID,:Code,:CategoryDesc,:CategoryRowId,:TagCode,:Table)
	 i SQLCODE s AtEnd=1,Row="" q $$$OK
 }
 if allegenTag'="" {
	 i curNo=1 {
	 	&sql(FETCH AllerCat INTO :Description,:RowID,:Code,:CategoryDesc,:CategoryRowId,:TagCode,:Table)
	 	;&sql(FETCH AllerTag INTO :Description,:RowID,:Code,:CategoryDesc,:CategoryRowId,:TagCode,:Table)
	 	i SQLCODE s curNo=curNo+1 g top
	 }
	 i curNo=2 {
		 i (allegenTag="P") {
		   &sql(FETCH PhmItm INTO :Description,:RowID,:Code,:TagCode,:Table)
		   i SQLCODE s AtEnd=1,Row="" q $$$OK
		 }
		 i (allegenTag="G") {
		  	 &sql(FETCH GenDrg INTO :Description,:RowID,:Code,:TagCode,:Table)
		 	 i SQLCODE s AtEnd=1,Row="" q $$$OK
		 }
		 i (allegenTag="I") {
		  	 &sql(FETCH  Ingrd INTO :Description,:RowID,:Code,:TagCode,:Table)
		 	 i SQLCODE s AtEnd=1,Row="" q $$$OK
		 }
	 }
	 
 }
 i (allegenTag="")&&(Category="") {
     ;i curNo=1 &sql(FETCH AllerCatOther INTO :Description,:RowID,:Code,:CategoryDesc,:CategoryRowId,:TagCode,:Table)
 	 i curNo=1 &sql(FETCH AllerCat INTO :Description,:RowID,:Code,:CategoryDesc,:CategoryRowId,:TagCode,:Table)
     i curNo=2 &sql(FETCH AllerCatGenDrg INTO :Description,:RowID,:Code,:TagCode,:Table)
     i curNo=3 &sql(FETCH AllerCatPhmItm INTO :Description,:RowID,:Code,:TagCode,:Table)
 	 i curNo=4 {
 	   &sql(FETCH AllerCatIngr INTO :Description,:RowID,:Code,:TagCode,:Table)
 	   i SQLCODE s AtEnd=1,Row="" q $$$OK
 	 }
     i SQLCODE s curNo=curNo+1 g top
 }
 
 i Description="" g top
 
 s Tag=TagCode
 i (Tag="P")!(Tag="G")!(Tag="I") s Tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",Tag)
 i (allegenTag="P")!(allegenTag="G")!(allegenTag="I") s Tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",allegenTag)
 
 ;Description,HIDDEN,Code,Category,Tag,HIDDEN,HIDDEN,HIDDEN
 ;过敏源描述,过敏源RowId,过敏源代码,分类描述,过敏源标志描述,分类RowId,过敏源标志代码,table 
 s Row=$lb(Description,RowID,Code,CategoryDesc,Tag,CategoryRowId,TagCode,Table)
 s index=index+1
 
 s user=$lb(Descr,Category,allegenTag)
 s work=$lb(index,curNo)
 s QHandle=$lb(AtEnd,user,work)
 
 q $$$OK
}

/*
// cjb 02/05/2005 51228 - this query/broker no longer used.  LookUpAll used instead
// 
/// Log 28554 - AI - 04-03-2003 : Broker for Allergen, given both the Allergen and the Category.
ClassMethod LookUpAllergenByCategoryBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Allergen As %Library.String = "", Category As %Library.String = "") As %Library.Boolean
{
 n id,code,description,catdesc,date
 n match,catCode,catCodeI,allegenTag,TagCode
 s (id,code,description,catdesc)=""
 s (catCode,catCodeI,allegenTag,allegenTag)=""
 s index=0
 ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
 s date=+$h

 ; check if category has allergen tag
 s match=0
 i Category'="" d
 . s catCode="" f  s catCode=$o(^MRC("AT",0,"MRCAA_Desc",catCode)) q:catCode=""  q:match=1  d
 . . s catCodeI=0 f  s catCodeI=$o(^MRC("AT",0,"MRCAA_Desc",catCode,catCodeI)) q:catCodeI=""  q:match=1  d
 . . . s catDesc=$g(^MRC("AT",0,"MRCAA_Desc",catCode,catCodeI))
 . . . i (catDesc=Category) d
 . . . . s allegenTag=$p(^MRC("AT",catCodeI),"^",6),match=1 q
 
 ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
 i (Category'=""),(allegenTag="") {
   &sql(
    SELECT	ALG_RowId,ALG_Code,ALG_Desc,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR->MRCAT_TagDescription
    INTO :id,:code,:description,:catdesc,:TagCode
 	  FROM	SQLUser.PAC_Allergy
 	  WHERE	(((%ALPHAUP ALG_Code = %ALPHAUP :Allergen) OR (%UPPER ALG_Desc = %UPPER :Allergen) OR (:Allergen IS NULL)) AND
 			 ((%UPPER ALG_Type_DR->MRCAT_Desc = %UPPER :Category) OR (:Category IS NULL)) AND
 	  		 (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
 	  		  ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
   )
 }

 i (Category="") {
	 i (description="") {
	  &sql(
	   SELECT	PHCGE_RowId,PHCGE_Code,PHCGE_Name,"Generic Drug","G"
	   INTO :id,:code,:description,:catdesc,:TagCode
 	   FROM	SQLUser.PHC_Generic
 	   WHERE	(%ALPHAUP PHCGE_Code = %ALPHAUP :Allergen) OR (%ALPHAUP PHCGE_Name = %ALPHAUP :Allergen) OR (:Allergen IS NULL)
   	   AND ( ((PHCGE_DateFrom <= :date) OR (PHCGE_DateFrom IS NULL)) 
 	  AND ((PHCGE_DateTo >= :date) OR (PHCGE_DateTo IS NULL)) )
 	  )   
    i SQLCODE s description=""
	 }
	 i (description="") {
	 	&sql(
	  	SELECT	PHCD_RowId,PHCD_Code,PHCD_Name,"Pharmacy Item","P"
	  	INTO :id,:code,:description,:catdesc,:TagCode
 	  	FROM	SQLUser.PHC_DrgMast
 	  	WHERE	(%ALPHAUP PHCD_Code = %ALPHAUP :Allergen) OR (%ALPHAUP PHCD_Name = %ALPHAUP :Allergen) OR (:Allergen IS NULL)
   	)
   	i SQLCODE s description=""
   }
   	i (description="") {
	 	&sql(
	  	SELECT	INGR_RowId,INGR_Code,INGR_Desc,"Ingredient","I"
	  	INTO :id,:code,:description,:catdesc,:TagCode
 	  	FROM	SQLUser.PHC_Ingredient
 	  	WHERE	(%ALPHAUP INGR_Code = %ALPHAUP :Allergen) OR (%ALPHAUP INGR_Desc = %ALPHAUP :Allergen) OR (:Allergen IS NULL)
   	)
   	i SQLCODE s description=""
   }
   ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
   i (description="") {
   	&sql(
    	SELECT	ALG_RowId,ALG_Code,ALG_Desc,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR->MRCAT_TagDescription
    	INTO :id,:code,:description,:catdesc,:TagCode
 	  	FROM	SQLUser.PAC_Allergy
 	  	WHERE	( ((%ALPHAUP ALG_Code = %ALPHAUP :Allergen) OR (%ALPHAUP ALG_Desc = %ALPHAUP :Allergen) OR (:Allergen IS NULL)) AND
 	  			  (ALG_Type_DR->MRCAT_TagDescription IS NULL) AND
	   	  		  (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
				   ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
   	)
   }
}
 
 i (allegenTag="P") {
	 ; Pharmacy Item
   &sql(
    SELECT	PHCD_RowId,PHCD_Code,PHCD_Name,"P"
    INTO :id,:code,:description,:TagCode
 	  FROM	SQLUser.PHC_DrgMast
 	  WHERE	((%ALPHAUP PHCD_Code = %ALPHAUP :Allergen) OR (%UPPER PHCD_Name = %UPPER :Allergen) OR (:Allergen IS NULL))
   )
 }
 
 i (allegenTag="G") {
	 ; Generic Drug
   &sql(
 	  SELECT	PHCGE_RowId,PHCGE_Code,PHCGE_Name,"G"
 	  INTO :id,:code,:description,:TagCode
 	  FROM	SQLUser.PHC_Generic
 	  WHERE	((%ALPHAUP PHCGE_Code = %ALPHAUP :Allergen) OR (%UPPER PHCGE_Name = %UPPER :Allergen) OR (:Allergen IS NULL)
 	  AND ( ((PHCGE_DateFrom <= :date) OR (PHCGE_DateFrom IS NULL)) 
 	  AND ((PHCGE_DateTo >= :date) OR (PHCGE_DateTo IS NULL)) ))
   )
 }
 
 i (allegenTag="I") {
	 ; Ingredient
	&sql(
    SELECT	INGR_RowId,INGR_Code,INGR_Desc,"I"
    INTO :id,:code,:description,:TagCode
 	  FROM	SQLUser.PHC_Ingredient
 	  WHERE	((%ALPHAUP INGR_Code = %ALPHAUP :Allergen) OR (%UPPER INGR_Desc = %UPPER :Allergen) OR (:Allergen IS NULL))
   )
 }
 i SQLCODE q 0
 
 i (allegenTag'="") s catdesc=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",allegenTag)
 s retval=itmjs_"('"_$ZCVT(description,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(description,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"^"_catdesc_"^"_$ZCVT(TagCode,"O","JS")_"');"
 &javascript<#(retval)#>
 
 q 1
}

/// Log 28554 - AI - 03-03-2003 : Look Up the Allergen restricted to the given Category (if any).
ClassMethod LookUpAllergenByCategoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAllergenByCategoryFetch ]
{
 s user=$li(QHandle,2)
 s Category=$li(user,2)
 s allegenTag=$li(user,3)
  
 i (Category'=""),(allegenTag="") {
   &sql(CLOSE AllerCat)
 }
 i (Category="") {
   &sql(CLOSE AllerCatGenDrg)
   &sql(CLOSE AllerCatPhmItm)
   &sql(CLOSE AllerCatOther)
 }
 i (allegenTag="G") {
   &sql(CLOSE PhmItm)
 }
 i (allegenTag="P") {
   &sql(CLOSE GenDrg)
 }
 s QHandle=""
 Quit $$$OK
}

/// Log 28554 - AI - 03-03-2003 : Look Up the Allergen restricted to the given Category (if any).
ClassMethod LookUpAllergenByCategoryExecute(ByRef QHandle As %Library.Binary, Descr As %String, Category As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
 n user,work,index,date
 n match,catCode,catCodeI,allegenTag
 s (catCode,catCodeI,allegenTag,allegenTag)=""
 s index=0
 ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
 s date=+$h
 ;
 ; check if category has allergen tag
 s match=0
 i Category'="" d
 . s catCode="" f  s catCode=$o(^MRC("AT",0,"MRCAA_Desc",catCode)) q:catCode=""  q:match=1  d
 . . s catCodeI=0 f  s catCodeI=$o(^MRC("AT",0,"MRCAA_Desc",catCode,catCodeI)) q:catCodeI=""  q:match=1  d
 . . . s catDesc=$g(^MRC("AT",0,"MRCAA_Desc",catCode,catCodeI))
 . . . i (catDesc=Category) d
 . . . . s allegenTag=$p(^MRC("AT",catCodeI),"^",6),match=1 q
 
 
 s ^zTRAK("cjb","LookUpAllergenByCategoryExecute",1)=$g(Category)_"^"_$g(allegenTag)
 
 ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
 ; return all allegens for allegen category if present
 i (Category'=""),(allegenTag="") {
   &sql(
 	  DECLARE AllerCat CURSOR FOR
 	  SELECT	ALG_Desc,ALG_RowId,ALG_Code,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR->MRCAT_TagDescription
 	  FROM	SQLUser.PAC_Allergy
 	  WHERE	( ((%ALPHAUP ALG_Desc %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL)) AND
 	  		  ((%UPPER ALG_Type_DR->MRCAT_Desc = %UPPER :Category) OR (:Category IS NULL)) AND
 	  		  (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
 	  		   ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
 	  ORDER BY ALG_Desc ASC
   )
   &sql(OPEN AllerCat)
 }
 
 ; return all allegens in order of Generic->Pharmacy Items->Rest of allegens
 i (Category="") {
	 &sql(
 	  DECLARE AllerCatGenDrg CURSOR FOR
 	  SELECT	PHCGE_Name,PHCGE_RowId,PHCGE_Code,"Generic Drug","G"
 	  FROM	SQLUser.PHC_Generic
 	  WHERE	((%ALPHAUP PHCGE_Name %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL))
 	  AND ( ((PHCGE_DateFrom <= :date) OR (PHCGE_DateFrom IS NULL)) 
 	  AND ((PHCGE_DateTo >= :date) OR (PHCGE_DateTo IS NULL)) )
 	  ORDER BY PHCGE_Name ASC
   )
   &sql(OPEN AllerCatGenDrg)

	 &sql(
 	  DECLARE AllerCatPhmItm CURSOR FOR
 	  SELECT	PHCD_Name,PHCD_RowId,PHCD_Code,"Pharmacy Item","P"
 	  FROM	SQLUser.PHC_DrgMast
 	  WHERE	((%ALPHAUP PHCD_Name %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL))
 	  ORDER BY PHCD_Name ASC
   )
   &sql(OPEN AllerCatPhmItm)
   
   &sql(
 	  DECLARE AllerCatIngr CURSOR FOR
 	  SELECT	INGR_Desc,INGR_RowId,INGR_Code,"Ingredient","I"
 	  FROM	SQLUser.PHC_Ingredient
 	  WHERE	((%ALPHAUP INGR_Desc %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL))
 	  ORDER BY INGR_Desc ASC
   )
   &sql(OPEN AllerCatIngr)
	 
   ; Log 40680 - AI - 11-11-2003 : Date is used to validate, using ALGDateFrom and ALGDateTo.
   &sql(
 	  DECLARE AllerCatOther CURSOR FOR
 	  SELECT	ALG_Desc,ALG_RowId,ALG_Code,ALG_Type_DR->MRCAT_Desc,ALG_Type_DR->MRCAT_TagDescription
 	  FROM	SQLUser.PAC_Allergy
 	  WHERE	( ((%ALPHAUP ALG_Desc %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL)) AND
 	  		  (ALG_Type_DR->MRCAT_TagDescription IS NULL) AND
 			  (((ALG_DateFrom <= :date) OR (ALG_DateFrom IS NULL)) AND
 			   ((ALG_DateTo >= :date) OR (ALG_DateTo IS NULL))) )
 	  ORDER BY ALG_Type_DR->MRCAT_Desc ASC, ALG_Desc ASC
   )
   &sql(OPEN AllerCatOther)
 }
 
 ; return all allegens from Pharmacy items code table if allegen category equals Pharmacy
 i (allegenTag="P") {
   ; Pharmacy Item
   &sql(
 	  DECLARE PhmItm CURSOR FOR
 	  SELECT	PHCD_Name,PHCD_RowId,PHCD_Code,"P"
 	  FROM	SQLUser.PHC_DrgMast
 	  WHERE	((%ALPHAUP PHCD_Name %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL))
 	  ORDER BY PHCD_Name ASC
   )
   &sql(OPEN PhmItm)
 }
 
 ; return all allegens from Generic drugs code table if allegen category equals Generic
 i (allegenTag="G") {
   ; Generic Drug
   &sql(
 	  DECLARE GenDrg CURSOR FOR
 	  SELECT	PHCGE_Name,PHCGE_RowId,PHCGE_Code,"G"
 	  FROM	SQLUser.PHC_Generic
 	  WHERE	((%ALPHAUP PHCGE_Name %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL))
 	  AND ( ((PHCGE_DateFrom <= :date) OR (PHCGE_DateFrom IS NULL)) 
 	  AND ((PHCGE_DateTo >= :date) OR (PHCGE_DateTo IS NULL)) )
 	  ORDER BY PHCGE_Name ASC
   )
   &sql(OPEN GenDrg)
 }
 i (allegenTag="I") {
   ; Ingradient
   &sql(
 	  DECLARE Ingrd CURSOR FOR
 	  SELECT	INGR_Desc,INGR_RowId,INGR_Code,"I"
 	  FROM	SQLUser.PHC_Ingredient
 	  WHERE	((%ALPHAUP INGR_Desc %STARTSWITH %ALPHAUP :Descr) OR (:Descr IS NULL))
 	  ORDER BY INGR_Desc ASC
   )
   &sql(OPEN Ingrd)
 }
 ;
 s curNo=1
 s user=$lb(Descr,Category,allegenTag)
 s work=$lb(index,curNo)
 s QHandle=$lb(0,user,work)
 ;
 Quit $$$OK
}

/// Log 28554 - AI - 03-03-2003 : Look Up the Allergen restricted to the given Category (if any).
ClassMethod LookUpAllergenByCategoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAllergenByCategoryExecute ]
{
 n user,work,index
 n Descr,Category,allegenTag,Description,RowID,Code,Tag,curNo,TagCode
 s (Descr,Category,allegenTag,Description,RowID,Code,Tag,curNo,TagCode)=""
 
 s AtEnd=$li(QHandle,1)
 s user=$li(QHandle,2)
 s work=$li(QHandle,3)
 s Descr=$li(user,1)
 s Category=$li(user,2)
 s allegenTag=$li(user,3)
 s index=$li(work,1)
 s curNo=$li(work,2)
top 
 i (Category'=""),(allegenTag="") {
	 &sql(FETCH AllerCat INTO :Description,:RowID,:Code,:Tag,:TagCode)
	 i SQLCODE s AtEnd=1,Row="" q $$$OK
 }
 i (allegenTag="P") {
   &sql(FETCH PhmItm INTO :Description,:RowID,:Code,:TagCode)
   i SQLCODE s AtEnd=1,Row="" q $$$OK
 }
 i (allegenTag="G") {
  	 &sql(FETCH GenDrg INTO :Description,:RowID,:Code,:TagCode)
 	 i SQLCODE s AtEnd=1,Row="" q $$$OK
 }
 i (allegenTag="I") {
  	 &sql(FETCH  Ingrd INTO :Description,:RowID,:Code,:TagCode)
 	 i SQLCODE s AtEnd=1,Row="" q $$$OK
 }
 i (Category="") {
     i curNo=1 &sql(FETCH AllerCatOther INTO :Description,:RowID,:Code,:Tag,:TagCode)
     i curNo=2 &sql(FETCH AllerCatGenDrg INTO :Description,:RowID,:Code,:Tag,:TagCode)
     i curNo=3 &sql(FETCH AllerCatPhmItm INTO :Description,:RowID,:Code,:Tag,:TagCode)
 	 i curNo=4 {
 	   &sql(FETCH AllerCatIngr INTO :Description,:RowID,:Code,:Tag,:TagCode)  
 	   i SQLCODE s AtEnd=1,Row="" q $$$OK
 	 }
     i SQLCODE s curNo=curNo+1 g top		; cjb 10/01/2005 48793 - added goto top
 }
 
 i Description="" g top
 
 //i (Tag="P")!(Tag="G") s Tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",Tag)
 i (Tag="P")!(Tag="G")!(Tag="I") s Tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",Tag)
 //i (allegenTag="P")!(allegenTag="G") s Tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",allegenTag)
 i (allegenTag="P")!(allegenTag="G")!(allegenTag="I") s Tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",allegenTag)
 
 s Row=$lb(Description,RowID,Code,Tag,TagCode)
 s index=index+1
 
 s user=$lb(Descr,Category,allegenTag)
 s work=$lb(index,curNo)
 s QHandle=$lb(AtEnd,user,work)
 
 q $$$OK
}
/// Log 28554 - AI - 03-03-2003 : Look Up the Allergen restricted to the given Category (if any).
Query LookUpAllergenByCategory(Descr As %String, Category As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Tag:%String,HIDDEN:%String")
{
}
*/
Query LookUpAll(desc As %String, cat As %String, tag As %String, date As %Date = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Category:%String,Tag:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// cjb 20/04/2005 51228 - new query.  filter by Category & Tag
Query LookUpAllergen(desc As %String, cat As %String, tag As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Cat:%String,Tag:%String,HIDDEN:%String")
{
	SELECT ALG_Desc, ALG_RowId, ALG_Code, ALG_Type_DR->MRCAT_Desc, ALG_Type_DR->MRCAT_TagDescription, ALG_Type_DR
	FROM PAC_Allergy
	WHERE (%ALPHAUP ALG_Desc %STARTSWITH %ALPHAUP :desc) AND 
		((ALG_Type_DR->MRCAT_TagDescription = :tag) OR (:tag IS NULL)) AND
 	  	((ALG_Type_DR = :cat) OR (:cat IS NULL)) AND
 	  	((ALG_DateFrom<=:date)OR(ALG_DateFrom iS NULL)) AND ((ALG_DateTo>=:date) OR (ALG_DateTo iS NULL))
 	  ORDER BY ALG_Desc ASC
}

}
