Class dhc.bonus.udata.uUnitBonusDetailEdit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others: w ##Class(dhc.bonus.udata.uUnitBonusDetailEdit).List(0,25,"2014","M03","","","")
ClassMethod List(start, limit, sYear, sPeriod, BonusScheme, BonusUnit, SchemeItem) As %String
{
 n (start,limit,sYear,sPeriod,BonusScheme,BonusUnit,SchemeItem)
 s Sqlstr = " select %ID RowID,BonusSchemeID->BonusSchemeCode,BonusSchemeID->BonusSchemeName,BonusYear,"
 			_" BonusPeriod,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName, "
            _" BonusSchemeItemID->SchemeItemCode,BonusSchemeItemID->SchemeItemName,BonusValue, "
			_" BonusSchemeItemID->BonusFormula as Formula,BonusSchemeItemID->BonusFormulaDesc as FormulaDesc,BonusFormula as FormulaValue, "
			_" BonusSchemeItemID->BonusItemTypeID->BonusItemTypeName as ItemTypeName"
 			_" from dhc_bonus_data.UnitBonusDetail where BonusYear='"_sYear_"' and BonusPeriod='"_sPeriod_"'"
 
 
 i BonusScheme '=""  s Sqlstr = Sqlstr_" and (BonusSchemeID->BonusSchemeCode LIKE '%"_BonusScheme_"%' OR BonusSchemeID->BonusSchemeName LIKE '%"_BonusScheme_"%' )"        
 i BonusUnit   '=""  s Sqlstr = Sqlstr_" and (BonusUnitID->BonusUnitCode LIKE '%"_BonusUnit_"%' OR  BonusUnitID->BonusUnitName LIKE '%"_BonusUnit_"%')"
 i SchemeItem  '=""  s Sqlstr = Sqlstr_" and (BonusSchemeItemID->SchemeItemCode LIKE '%"_SchemeItem_"%' OR  BonusSchemeItemID->SchemeItemName LIKE '%"_SchemeItem_"%')"
 

 s result=##Class(%Library.ResultSet).%New()
 d result.Prepare(Sqlstr)
 d result.Execute(Sqlstr)
 s count=0
 s resultString=""
 s end=start+limit-1
 
 s json=##Class(dhc.bonus.comm.JsonObj).%New()
 s jsonTitle="RowID^BonusSchemeCodeName^BonusYear^BonusPeriod^BonusUnitCodeName"
 			_"^SchemeItemCode^SchemeItemName^BonusValue^BonusFormulaDesc^BonusFormulaValue^BonusItemTypeName^BonusFormula"
 
 while(result.Next()){
	 s RowID = result.Data("RowID")
	 s BonusSchemeCode = result.Data("BonusSchemeCode")
	 s BonusSchemeName = result.Data("BonusSchemeName")
	 s BonusYear = result.Data("BonusYear")
	 s BonusPeriod = result.Data("BonusPeriod")
	 s BonusUnitCode = result.Data("BonusUnitCode")
	 s BonusUnitName = result.Data("BonusUnitName")
	 s SchemeItemCode = result.Data("SchemeItemCode")
	 s SchemeItemName = result.Data("SchemeItemName")
	 s BonusValue = result.Data("BonusValue")
	 
	 s Formula = result.Data("Formula")
	 s BonusFormula=$TRanslate(Formula,"^","&")
	 s BonusFormulaDesc = result.Data("FormulaDesc")
	 s BonusFormulaValue = result.Data("FormulaValue")
	 s BonusItemTypeName = result.Data("ItemTypeName")
	 
	 s BonusSchemeCodeName=BonusSchemeCode_"_"_BonusSchemeName
	 s BonusUnitCodeName=BonusUnitCode_"_"_BonusUnitName
	 
	 s tmp=RowID_"^"_BonusSchemeCodeName_"^"_BonusYear_"^"_BonusPeriod_"^"_
	 	   BonusUnitCodeName_"^"_SchemeItemCode_"^"_SchemeItemName_"^"_BonusValue
	 	   _"^"_BonusFormulaDesc_"^"_BonusFormulaValue_"^"_BonusItemTypeName_"^"_BonusFormula
	 i (count>=start)&(count<=end) d
	 .d json.InsertRowData(tmp)
	 s count=count+1
 }
 
 d result.Close()
 s resultString = json.getJsonData(jsonTitle,count)
 k json
 q resultString
}

/// others: w ##Class(dhc.bonus.udata.uUnitBonusDetailEdit).UpdateBonusValue(1,"","","")
ClassMethod UpdateBonusValue(rowid, oldBonusValue, BonusValue, userCode, ItemCode, ItemName, detailData, YearMonth) As %String
{
 n (rowid,oldBonusValue,BonusValue,userCode,ItemCode,ItemName,detailData,YearMonth)
 &SQL(update dhc_bonus_data.UnitBonusDetail set BonusValue=:BonusValue where %ID=:rowid )
 s ModiDate=$ZD($H,3)
 &SQL(insert into dhc_bonus_logs.BonusModiLog(ModiDate,ModiPerson,TableName,ItemCode,ItemName,OldValue,NewValue,ReMark) values(:ModiDate,:userCode,:detailData,:ItemCode,:ItemName,:oldBonusValue,:BonusValue,:YearMonth) )
 q SQLCODE
}

/// others: w ##Class(dhc.bonus.udata.uUnitBonusDetailEdit).UpdateBonusValue(1,"","","")
ClassMethod UpdateTargetValue(srowid, sOldBonusValue, sBonusValue, userCode, sItemCode, sItemName, sdetailData, sYearMonth) As %String
{
 n (srowid,sOldBonusValue,sBonusValue,userCode,sItemCode,sItemName,sdetailData,sYearMonth)
 &SQL(update dhc_bonus_data.BonusTargetCollect set TargetValue=:sBonusValue where %ID=:srowid )
 s ModiDate=$ZD($H,3)
 &SQL(insert into dhc_bonus_logs.BonusModiLog(ModiDate,ModiPerson,TableName,ItemCode,ItemName,OldValue,NewValue,ReMark) values(:ModiDate,:userCode,:sdetailData,:sItemCode,:sItemName,:sOldBonusValue,:sBonusValue,:sYearMonth) )
 q SQLCODE
}

/// others: w ##Class(dhc.bonus.udata.uUnitBonusDetailEdit).FormulaList(1,25,"2014","M03","D0101_呼吸内科","&T01030&*&T01032")
ClassMethod FormulaList(start, limit, year, Period, UnitCodeName, BonusFormula, BonusSchemeCodeName) As %String
{
  n (start,limit,year,Period,UnitCodeName,BonusFormula,BonusSchemeCodeName)
  s BonusFormula = $TRanslate(BonusFormula,"&","'")
  s FormulaCode = ""
  s len = $Length(BonusFormula)
  for a=1:1:len
  {	 
  	 s Formula = ""
	 i ($Extract(BonusFormula,a+1,a+1)="S")||($Extract(BonusFormula,a+1,a+1)="T")  d
	 .s Formula = "'"_$Extract(BonusFormula,a+1,a+6)_"'"
	 .s FormulaCode = Formula_","_FormulaCode	 
  }
  s FormulaCode = FormulaCode_"''"
  s code = $P(UnitCodeName,"_",1)
  s Sqlstr = " select %ID rowid,BonusYear,BonusPeriod,BonusUnitID->BonusUnitCode ,BonusUnitID->BonusUnitName,"
 			_" BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName,TargetValue,InterLocMethodID->InterLocMethod_methodDesc,'"_BonusSchemeCodeName_"' SchemeName"
 			_" from dhc_bonus_data.BonusTargetCollect"
			_" where  BonusYear='"_year_"' and BonusPeriod='"_Period_"'"
			_" AND BonusUnitID->BonusUnitCode='"_code_"' and 'T' _ BonusTargetID->BonusTargetCode IN ("_FormulaCode_")"
			_" UNION ALL"
			_" select a.%ID rowid,'"_year_"' BonusYear,'"_Period_"' BonusPeriod,BonusUnitID->BonusUnitCode ,BonusUnitID->BonusUnitName,"
			_" BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName,TargetRate TargetValue,'' methodDesc,'"_BonusSchemeCodeName_"' SchemeName"
  			_" from dhc_bonus_data.TargetCalculateRate a"
			_" WHERE BonusUnitID->BonusUnitCode='"_code_"' and  'T'_  BonusTargetID->BonusTargetCode IN ("_FormulaCode_")"
			_" UNION ALL"
			_" select %ID rowid,BonusYear, BonusPeriod,BonusUnitID->BonusUnitCode ,BonusUnitID->BonusUnitName,"
			_" BonusSchemeItemID->SchemeItemCode,BonusSchemeItemID->SchemeItemName,BonusValue TargetValue,'' methodDesc,'"_BonusSchemeCodeName_"' SchemeName"
  			_" from dhc_bonus_data.UnitBonusDetail"
			_" WHERE BonusYear='"_year_"' and BonusPeriod='"_Period_"' and"
			_" BonusUnitID->BonusUnitCode='"_code_"' AND 'S' _ BonusSchemeItemID->SchemeItemCode IN ("_FormulaCode_")"
  s result=##Class(%Library.ResultSet).%New()
  d result.Prepare(Sqlstr)
  d result.Execute(Sqlstr)
  s count=0
  s resultString=""
  s end=start+limit-1
  s json=##Class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^fBonusYear^fBonusPeriod^fBonusUnitCode^fBonusUnitName^fBonusTargetCode^fBonusTargetName"
  			  _"^fTargetValue^fInterLocMethod^fSchemeName"
 
  while(result.Next()){
	  s rowid=result.Data("rowid")
	  s fBonusYear=result.Data("BonusYear")
	  s fBonusPeriod=result.Data("BonusPeriod")
	  s fBonusUnitCode=result.Data("BonusUnitCode")
	  s fBonusUnitName=result.Data("BonusUnitName")
	  s fBonusTargetCode=result.Data("BonusTargetCode")
	  
	  s fBonusTargetName=result.Data("BonusTargetName")
	  s fTargetValue=result.Data("TargetValue")
	  s fInterLocMethod=result.Data("InterLocMethod_methodDesc")
	  s fSchemeName=result.Data("SchemeName")
	  
   s tmp = rowid_"^"_fBonusYear_"^"_fBonusPeriod_"^"_fBonusUnitCode_"^"_fBonusUnitName
   		   _"^"_fBonusTargetCode_"^"_fBonusTargetName_"^"_fTargetValue_"^"_fInterLocMethod_"^"_fSchemeName
   
   i (count>=start)&(count<=end) d
   .d json.InsertRowData(tmp)
   s count=count+1	 
  }
  
  d result.Close()
  s resultString = json.getJsonData(jsonTitle,count)
  k json
  q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus8265.uUnitBonusD60ACS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
