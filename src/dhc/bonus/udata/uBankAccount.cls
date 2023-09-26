/// Description:人员账户维护
Class dhc.bonus.udata.uBankAccount Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.udata.uBankAccount).List("","","","",0,25,13)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, UnitDr, sName, CardNo) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, UnitDr,sName,CardNo)
	s ^zlg203= UnitDr_","_ sName_","_CardNo
	
	s sqlStr=" select BankAccountID,a.BonusUnitID,BonusUnitCode as EmpCode,BonusUnitName,BankNo,CardNo,BonusRate,a.SuperiorUnitID->SuperiorUnitID->BonusUnitName supUnit  "
	        _" from dhc_bonus_data.BonusUnit a,dhc_bonus_data.BankAccount b "
	        _" where a.BonusUnitID =b.BonusUnitID and a.IsValid = '1' and UnitFlag = '3' AND b.BankAccountID!=''  "
	s whereStr=""
	i UnitDr'="" d
	.s whereStr=" and a.SuperiorUnitID->SuperiorUnitID= "_ UnitDr

	i CardNo'="" d
	.s whereStr=" and (BankNo like '%"_ CardNo _"%' or CardNo like '%"_ CardNo _"%')"
	i sName'="" d
	.s whereStr=" and (a.BonusUnitCode like '%"_ sName _"%' or a.BonusUnitName like '%"_ sName _"%')"


	i searchValue'="" d
	.s whereStr=" and BonusUnitCode like '%"_searchValue_"%' "
	
	s sortStr=" ORDER BY a.SuperiorUnitID->SuperiorUnitID->BonusUnitCode ASC "
	s sqlStr=sqlStr_whereStr_sortStr
	s ^zlg202=sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusUnitID^EmpCode^BonusUnitName^BankNo^CardNo^BonusRate^supUnit"
	
	While(result.Next()){
		
		s rowid = result.Data("BankAccountID")
		s BonusUnitID = result.Data("BonusUnitID")
		s BonusUnitName = result.Data("BonusUnitName")
		s EmpCode = result.Data("EmpCode")
		s BankNo = result.Data("BankNo")
		s CardNo = result.Data("CardNo")
		s BonusRate = result.Data("BonusRate")
		s supUnit = result.Data("supUnit")
		s tmp=rowid_"^"_BonusUnitID_"^"_EmpCode_"^"_BonusUnitName_"^"_BankNo_"^"_CardNo_"^"_BonusRate_"^"_supUnit

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBankAccount).InsertRec(1,1)
ClassMethod InsertRec(unitDr, BankNo, CardNo, BonusRate) As %String
{
	n (unitDr, BankNo,CardNo,BonusRate)
	s EmpCode=$List(^dhcbsBonusUnitD(unitDr),2)
	&sql(select count(*) into:s1 from dhc_bonus_data.BankAccount where EmpCode=:EmpCode and IsValid=1)
	q:s1>0 "RepCode"
	s ^zlg201=unitDr_","_BankNo_","_CardNo_","_BonusRate_","_EmpCode
	&sql(insert into dhc_bonus_data.BankAccount (BonusUnitID,EmpCode,BankNo,CardNo,BonusRate,IsValid) 
	  values(:unitDr,:EmpCode,:BankNo,:CardNo,:BonusRate,1))
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBankAccount).UpdateRec(2,"CardNo",1)
ClassMethod UpdateRec(rowid, sName, sValue) As %String
{
	n (rowid, sName,sValue)
	
	//&sql(update dhc_bonus_data.BankAccount set :sName=:BankNo where %ID=:rowid)
	
	s sqlStr="update dhc_bonus_data.BankAccount set " _ sName_"="
	_ sValue _ " where %ID=" _ rowid
	//s ^zlg20=sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBankAccount).Delete(965)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	;&sql(update  dhc_bonus_data.BankAccount set IsValid=0 where %ID=:rowid)
	&sql(delete from dhc_bonus_data.BankAccount where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uBankAccount).GetUnit(256)
ClassMethod GetUnit(unitDr) As %String
{
	n (unitDr)
	s parUnitDr=$List(^dhcbsBonusUnitD(unitDr),6)
	s parUnitFlag=$List(^dhcbsBonusUnitD(parUnitDr),5)
	s tmpU=unitDr
	i parUnitFlag'=0 d
	.s tmpU= ..GetUnit(parUnitDr)
	q tmpU
}

/// w ##class(dhc.bonus.udata.uBankAccount).UnitList(0,25)
ClassMethod UnitList(start, limit) As %String
{
	n (start, limit)
		
	s sqlStr="SELECT  *  from dhc_bonus_data.BonusUnit where BonusUnitID>0 and UnitFlag=1 and IsValid=1 AND BonusUnitCode LIKE 'D%' "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s name = result.Data("BonusUnitName")
	
		s tmp=rowid_"^"_name
		;i (count>=start)&(count<=end) d
		d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBankAccount).PersonsList(0,25,13)
ClassMethod PersonsList(start, limit, unitDr) As %String
{
	n (start, limit, unitDr)
		
	s sqlStr="SELECT  *  from dhc_bonus_data.BonusUnit where BonusUnitID>0 and UnitFlag=3 and IsValid=1 "
	        _" and BonusUnitCode  like 'A%' and SumUnitID=:unitDr"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s name = result.Data("BonusUnitName")
		//s tmpUnitDr =   ..GetUnit(rowid)
		//i tmpUnitDr=unitDr d
		s tmp=rowid_"^"_name
		d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.udata.uBankAccount).GetPersons(13)
ClassMethod GetPersons(unitDr) As %String
{
	n (unitDr)
		
	s sqlStr="SELECT  *  from dhc_bonus_data.BonusUnit" 
	 _" where BonusUnitID>0 and UnitFlag=3 and IsValid=1 "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString=""
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s tmpUnitDr =   ..GetUnit(rowid)
		i tmpUnitDr=unitDr d
		.i resultString="" d
		..s resultString=rowid
		.e  d
		..s resultString=resultString_","_rowid
	}
		
	d result.Close()
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uBankAccountS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
