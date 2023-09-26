Class User.uACCTSubj Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTSubj).Insert(1,1,"111111","adasd","asdasda",1,2,0,1,0,0,0,0,"","","","","","","","","qweq","ys",0,0,0,0,"asdf")
ClassMethod Insert(acctYearDr, acctSubjTypeDr, acctSubjCode, aCCTSubjName, aCCTSubjNameAll, superSubj, subjLevel, isLast, direction, isCash, isNum, isFc, isCheck, checkType1, checkType2, checkType3, checkType4, checkType5, checkType6, checkType7, checkType8, define, spell, isStop, isCbcs, isZero, subjDefine, isBudge) As %String
{
	n (acctYearDr, acctSubjTypeDr, acctSubjCode, aCCTSubjName, aCCTSubjNameAll, superSubj, subjLevel, isLast, direction, isCash, isNum, isFc, isCheck, checkType1, checkType2, checkType3, checkType4, checkType5, checkType6, checkType7, checkType8, define, spell, isStop, isCbcs, isZero, subjDefine, isBudge)
	&sql(insert into ACCT_Subj (ACCT_Year_Dr,ACCT_SubjTypeDr,acct_subj_code,acct_subj_name,acct_subj_name_all,acct_SuperSubj,subj_level,is_last,direction,is_cash,is_num,is_fc,is_check,check_type1,check_type2,check_type3,check_type4,check_type5,check_type6,check_type7,check_type8,define,spell,is_stop,is_cbcs,is_zero,subj_define,is_budge) values(:acctYearDr, :acctSubjTypeDr, :acctSubjCode, :aCCTSubjName, :aCCTSubjNameAll, :superSubj, :subjLevel, :isLast, :direction, :isCash, :isNum, :isFc, :isCheck, :checkType1, :checkType2, :checkType3, :checkType4, :checkType5, :checkType6, :checkType7, :checkType8, :define, :spell, :isStop, :isCbcs, :isZero, :subjDefine, :isBudge))
	q SQLCODE
}

/// w ##class(User.uACCTSubj).Update(8,1,1,"111111","adasd","asdasda",1,2,0,1,0,0,0,0,"1","2","3","4","5","6","7","8","qweq","ys",0,0,0,0,"asdf" )
ClassMethod Update(rowid, acctYearDr, acctSubjTypeDr, acctSubjCode, aCCTSubjName, aCCTSubjNameAll, superSubj, subjLevel, isLast, direction, isCash, isNum, isFc, isCheck, checkType1, checkType2, checkType3, checkType4, checkType5, checkType6, checkType7, checkType8, define, spell, isStop, isCbcs, isZero, subjDefine, isBudge) As %String
{
	n (rowid,acctYearDr, acctSubjTypeDr, acctSubjCode, aCCTSubjName, aCCTSubjNameAll, superSubj, subjLevel, isLast, direction, isCash, isNum, isFc, isCheck, checkType1, checkType2, checkType3, checkType4, checkType5, checkType6, checkType7, checkType8, define, spell, isStop, isCbcs, isZero, subjDefine, isBudge)
	&sql(update ACCT_Subj set ACCT_Year_Dr =:acctYearDr,ACCT_SubjTypeDr=:acctSubjTypeDr,acct_subj_code=:acctSubjCode,acct_subj_name=:aCCTSubjName,acct_subj_name_all=:aCCTSubjNameAll,acct_SuperSubj=:superSubj,subj_level=:subjLevel,is_last=:isLast,direction=:direction,is_cash=:isCash,is_num=:isNum,is_fc=:isFc,is_check=:isCheck,check_type1=:checkType1,check_type2=:checkType2,check_type3=:checkType3,check_type4=:checkType4,check_type5=:checkType5,check_type6=:checkType6,check_type7=:checkType7,check_type8=:checkType8,define=:define,spell=:spell,is_stop=:isStop,is_cbcs=:isCbcs,is_zero=:isZero,subj_define=:subjDefine,is_budge=:isBudge where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSubj).Delete(8)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_Subj WHERE %ID=:rowid)
	q SQLCODE
}

/// Others: w ##class(User.uACCTSubj).List("","","","","","")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n ( searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM ACCT_Subj"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	
	s jsonTitle="rowid^acctYearDr^acctYearName^acctSubjTypeDr^acctSubjTypeName^acctSubjCode^aCCTSubjName^aCCTSubjNameAll^superSubj^superSubjName^subjLevel^isLast^direction^isCash^isNum^isFc^isCheck^checkType1^checkType2^checkType3^checkType4^checkType5^checkType6^checkType7^checkType8^define^spell^isStop^isCbcs^isZero^subjDefine^isBudge"
	
	While(result.Next())
	{
		//ACCT_Year_Dr,ACCT_SubjTypeDr,acct_subj_code,acct_subj_name,acct_subj_name_all,acct_SuperSubj,subj_level,
		//is_last,direction,is_cash,is_num,is_fc,is_check,check_type1,check_type2,check_type3,check_type4,
		//check_type5,check_type6,check_type7,check_type8,define,spell,is_stop,is_cbcs,is_zero,subj_define,is_budge
		s rowid = result.Data("ID")
		s acctYearDr = result.Data("ACCT_Year_Dr") 
		s acctYearName=""
		i (acctYearDr'="")&&($g(^User.ACCTYearD(acctYearDr))'="") d
		.s acctYearName = $LIST(^User.ACCTYearD(acctYearDr),13)
		s acctSubjTypeDr = result.Data("ACCT_SubjTypeDr") 
		s acctSubjTypeName=""
		i (acctSubjTypeDr'="")&&($g(^User.ACCTSubjTypeD(acctSubjTypeDr))'="") d
		.s acctSubjTypeName = $LIST(^User.ACCTSubjTypeD(acctSubjTypeDr),6)
		s acctSubjCode = result.Data("acct_subj_code") 
		s aCCTSubjName = result.Data("acct_subj_name") 
		s aCCTSubjNameAll = result.Data("acct_subj_name_all") 
		s superSubj = result.Data("acct_SuperSubj") 
		s superSubjName=""
		i (superSubj'="")&&($g(^User.ACCTSubjD(superSubj))'="") d
		.s superSubjName = $LIST(^User.ACCTSubjD(superSubj),2)
		s subjLevel = result.Data("subj_level") 
		s isLast = result.Data("is_last") 
		s direction = result.Data("direction") 
		s isCash = result.Data("is_cash") 
		s isNum = result.Data("is_num") 
		s isFc = result.Data("is_fc") 
		s isCheck = result.Data("is_check") 
		s checkType1 = result.Data("check_type1") 
		s checkType2 = result.Data("check_type2") 
		s checkType3 = result.Data("check_type3") 
		s checkType4 = result.Data("check_type4") 
		s checkType5 = result.Data("check_type5") 
		s checkType6 = result.Data("check_type6") 
		s checkType7 = result.Data("check_type7") 
		s checkType8 = result.Data("check_type8") 
		s define = result.Data("define") 
		s spell = result.Data("spell") 
		s isStop = result.Data("is_stop") 
		s isCbcs = result.Data("is_cbcs") 
		s isZero = result.Data("is_zero") 
		s subjDefine = result.Data("subj_define") 
		s isBudge = result.Data("is_budge")
		
		s tmp=rowid_"^"_acctYearDr_"^"_acctYearName_"^"_acctSubjTypeDr_"^"_acctSubjTypeName_"^"_acctSubjCode_"^"_aCCTSubjName_"^"_aCCTSubjNameAll_"^"_superSubj_"^"_superSubjName_"^"_subjLevel_"^"_isLast_"^"_direction_"^"_isCash_"^"_isNum_"^"_isFc_"^"_isCheck_"^"_checkType1_"^"_checkType2_"^"_checkType3_"^"_checkType4_"^"_checkType5_"^"_checkType6_"^"_checkType7_"^"_checkType8_"^"_define_"^"_spell_"^"_isStop_"^"_isCbcs_"^"_isZero_"^"_subjDefine_"^"_isBudge
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^User.uACCTSubjS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
