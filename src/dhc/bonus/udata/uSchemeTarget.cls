/// Description:方案指标维护
Class dhc.bonus.udata.uSchemeTarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.udata.uSchemeTarget).IfRep(4,96)
ClassMethod IfRep(BonusTargetID, BonusSchemeID) As %String
{
	n (BonusTargetID,BonusSchemeID)
	s sqlStr="SELECT *  from dhc_bonus_data.SchemeTarget where BonusTargetID ='"_BonusTargetID_"' and BonusSchemeID ='"_BonusSchemeID_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid = result.Data("SchemeTargetID")
	}
	q rowid
}

/// w ##class(dhc.bonus.udata.uSchemeTarget).List(0,25,"2","28","006")
ClassMethod List(start, limit, schemeTypeDr, schemeDr, targetDr) As %String
{
	n (start,limit,schemeTypeDr,schemeDr,targetDr)
	
	s sqlStr="SELECT *, BonusTargetID->BonusTargetCode as BonusTargetCode, BonusTargetID->BonusTargetName as BonusTargetName, BonusSchemeID->BonusSchemeCode as BonusSchemeCode, BonusSchemeID->BonusSchemeName as BonusSchemeName,BonusSchemeID->SchemeType as SchemeType from dhc_bonus_data.SchemeTarget where SchemeTargetID>0 "
	
	s whereStr=""
	i schemeTypeDr'="" d
	.s whereStr=" and BonusSchemeID->SchemeType ='"_schemeTypeDr_"' "
	
	i schemeDr'="" d
	.s whereStr=" and BonusSchemeID ='"_schemeDr_"' "
	i targetDr'="" d
	.s whereStr=whereStr_" and (BonusTargetID->BonusTargetName like '%"_targetDr_"%' or BonusTargetID->BonusTargetCode like '%"_targetDr_"%') "
	
	s sortStr=" ORDER BY SchemeTargetID desc"
	s sqlStr=sqlStr_whereStr_sortStr
	
	s ^TMPWYY(1)=":::"_sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusTargetID^BonusSchemeID^UpdateDate^BonusTargetCode^BonusTargetName^BonusSchemeCode^BonusSchemeName^SchemeType"
	
	While(result.Next()){
		
		s rowid = result.Data("SchemeTargetID")
		s BonusTargetID = result.Data("BonusTargetID")
		s BonusSchemeID = result.Data("BonusSchemeID")
		s UpdateDate = result.Data("UpdateDate")
		s BonusTargetCode = result.Data("BonusTargetCode")
		s BonusTargetName = result.Data("BonusTargetName")
		s BonusSchemeCode = result.Data("BonusSchemeCode")
		s BonusSchemeName = result.Data("BonusSchemeName")
		s SchemeType = result.Data("SchemeType")
		i UpdateDate'="" d
		.s UpdateDate = $ZDATETIME(UpdateDate,3)
		
		s tmp=rowid_"^"_BonusTargetID_"^"_BonusSchemeID_"^"_UpdateDate_"^"_BonusTargetCode_"^"_BonusTargetName_"^"_BonusSchemeCode_"^"_BonusSchemeName_"^"_SchemeType

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uSchemeTarget).InsertRec(1,2)
ClassMethod InsertRec(BonusTargetID, BonusSchemeID) As %String
{
	
	n (BonusTargetID,BonusSchemeID)
	;s ^chenming1234567=date
	s rowid=0
	s rowid=..IfRep(BonusTargetID,BonusSchemeID)
	q:rowid>0 "RepCode"
	;s date=$zdh(date,3)
	
	&sql(insert into dhc_bonus_data.SchemeTarget (BonusTargetID,BonusSchemeID) values(:BonusTargetID,:BonusSchemeID))
	q SQLCODE
}

/*
/// w ##class(dhc.bonus.udata.uSchemeTarget).UpdateRec(965,2,1)
ClassMethod UpdateRec(rowid, BonusTargetID,BonusSchemeID) As %String
{
	n (rowid,BonusTargetID,BonusSchemeID)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s tmpDate = $H
	&sql(update dhc_bonus_data.SchemeTarget set BonusTargetID=:BonusTargetID,BonusSchemeID=:BonusSchemeID,UpdateDate=:tmpDate where %ID=:rowid)
	q SQLCODE
}
 */
/// w ##class(dhc.bonus.udata.uSchemeTarget).Delete(965)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&sql(delete from dhc_bonus_data.SchemeTarget where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uSchemeTargetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
