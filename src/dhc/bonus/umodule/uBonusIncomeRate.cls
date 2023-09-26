Class dhc.bonus.umodule.uBonusIncomeRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.bonus.umodule.uBonusIncomeRate).IfRepIncItemCodeSickType("1","2")
ClassMethod IfRepIncItemCodeSickType(IncItemCode, DeptGroupID) As %String
{
	new (IncItemCode,DeptGroupID)
	s rowid=0 
	s rowid=$o(^dhcbsmdBonusIncomeRateI("IncItemCodeSickType",IncItemCode,DeptGroupID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).List("","",0,10,"8","")
ClassMethod List(sortField, sortDir, start, limit, tartype, deptgrouptype) As %String
{
	n (sortField,sortDir,start,limit,tartype,deptgrouptype)
	s sqlStr="SELECT BonusSubIncomeRateID,BonusIncItemID->ItemName as IncItemCode, "
	_" MakeBillDeptRate, ExecuteDeptRate, SickDeptRate, CheckMan, CheckDate, UpdateDate, State, "
	_" CASE DeptGroupID WHEN -1 THEN '通用科室' ELSE DeptGroupID->DeptGroupName END AS DeptGroupName"
	_" FROM dhc_bonus_module.BonusIncomeRate  where 1=1  "
	
	i tartype'="" s sqlStr= sqlStr_" and BonusIncItemID ="_tartype
	//i (sicktype '="")&&(sicktype '=0) s whereStr=whereStr_" and SickType="_sicktype
	
	i deptgrouptype'="" s sqlStr= sqlStr_" and DeptGroupID="_deptgrouptype
	//k ^cwtemp
	//s ^cwtemp=sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^IncItemCode^makebilldeptrate^executedeptrate^sickdeptrate^checkman^checkdate^updatedate^state^DeptGroupName"
	While(result.Next())
	{
	s BonusIncItemID= result.Data("BonusSubIncomeRateID")
	s ItemName= result.Data("IncItemCode")

	s makebilldeptrate= result.Data("MakeBillDeptRate")
	s makebilldeptrate=$fn(makebilldeptrate,",","2")
	s executedeptrate= result.Data("ExecuteDeptRate")
	s executedeptrate=$fn(executedeptrate,",","2")
	s sickdeptrate= result.Data("SickDeptRate")
	s sickdeptrate=$fn(sickdeptrate,",","2")
	s checkman= result.Data("CheckMan")
	
	s checkdate= result.Data("CheckDate")
	if checkdate'="" { s checkdate=$zd(checkdate,3)}
	s updatedate= result.Data("UpdateDate")
	s updatedate=$zd(updatedate,3)
	s state= result.Data("State")
	i state=0 s state="新增"
	i state=1 s state="审核"
	s DeptGroupName= result.Data("DeptGroupName")

	s temp=BonusIncItemID_"^"_ ItemName_"^"_makebilldeptrate_"^"_executedeptrate_"^"_sickdeptrate_"^"_checkman_"^"_checkdate_"^"_updatedate_"^"_state_"^"_DeptGroupName
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).InsertRec("3","3","3","3","3","3","63225","66999","1")
ClassMethod InsertRec(IncItemCode, MakeBillDeptRate, ExecuteDeptRate, SickDeptRate, CheckMan, CheckDate, UpdateDate, State, DeptGroupName) As %String
{
	n (IncItemCode,MakeBillDeptRate,ExecuteDeptRate,SickDeptRate,CheckMan,CheckDate,UpdateDate,State,DeptGroupName)
	
	s UpdateDate=$p($h,",",1)
	s rowid=0
	;s rowid=..IfRepIncItemCodeSickType(IncItemCode,DeptGroupName)
	;q:rowid>0 "RepCode"

	&sql(INSERT INTO dhc_bonus_module.BonusIncomeRate(BonusIncItemID, MakeBillDeptRate, ExecuteDeptRate, SickDeptRate, CheckMan, UpdateDate, State,DeptGroupID)
	 VALUES (:IncItemCode,:MakeBillDeptRate,:ExecuteDeptRate,:SickDeptRate,:CheckMan,:UpdateDate,0,:DeptGroupName ))

	q SQLCODE
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).UpdateRec(10,"","5","","","","","","","")
ClassMethod UpdateRec(rowid, incitemcode, makebilldeptrate, executedeptrate, sickdeptrate, checkman, checkdate, updatedate, state, DeptGroupName) As %String
{
	n (rowid,incitemcode,makebilldeptrate,executedeptrate,sickdeptrate,checkman,checkdate,updatedate,state,DeptGroupName)

	s checkdate=""
	s updatedate=$p($h,",",1)
	i incitemcode =""  s Plist(2) = $list(^dhcbsmdBonusIncomeRateD(rowid),2)
	;s Plist(3)=""
 	i makebilldeptrate =""  s Plist(4) = $list(^dhcbsmdBonusIncomeRateD(rowid),4)
 	i executedeptrate =""  s Plist(5) = $list(^dhcbsmdBonusIncomeRateD(rowid),5)
 	i sickdeptrate =""  s Plist(6) = $list(^dhcbsmdBonusIncomeRateD(rowid),6)
 	i checkman =""  s Plist(7) = $list(^dhcbsmdBonusIncomeRateD(rowid),7)
 	i checkdate =""  s Plist(8) = $list(^dhcbsmdBonusIncomeRateD(rowid),8)
 	i updatedate =""  s Plist(9) = $list(^dhcbsmdBonusIncomeRateD(rowid),9)
 	i state =""  s Plist(10) = $list(^dhcbsmdBonusIncomeRateD(rowid),10)
 	i DeptGroupName="" s Plist(11) = $list(^dhcbsmdBonusIncomeRateD(rowid),11)
	
 	i incitemcode '=""  s Plist(2) = incitemcode
 
 	i makebilldeptrate '=""  s Plist(4) = makebilldeptrate
 	i executedeptrate '=""  s Plist(5) = executedeptrate
 	i sickdeptrate '=""  s Plist(6) = sickdeptrate
 	i checkman '=""  s Plist(7) = checkman
 	i checkdate '=""  s Plist(8) = checkdate
 	i updatedate '=""  s Plist(9) = updatedate
 	//i state '=""  s Plist(10) = state
 	i DeptGroupName'="" s Plist(11) = DeptGroupName
 	s tmpRowid=0
	s tmpRowid=..IfRepIncItemCodeSickType(Plist(2), Plist(11))
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	
	&sql(UPDATE dhc_bonus_module.BonusIncomeRate VALUES Plist() where %ID=:rowid)
	q SQLCODE
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).Delete(4)
ClassMethod Delete(rowid) As %String
{
	&sql( DELETE FROM dhc_bonus_module.BonusIncomeRate WHERE %ID=:rowid)

	q SQLCODE
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).Delete(4)
ClassMethod Audit(rowid, checker) As %String
{
	n (rowid,checker)
	s updatedate=$p($h,",",1)
	&sql( update dhc_bonus_module.BonusIncomeRate set state=1 ,CheckDate=:updatedate,CheckMan=:checker WHERE %ID=:rowid)

	q SQLCODE
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).Delete(4)
ClassMethod unAudit(rowid, checker) As %String
{
	n (rowid,checker)
	s updatedate=$p($h,",",1)
	&sql( update dhc_bonus_module.BonusIncomeRate set state=0,CheckDate=:updatedate,CheckMan=:checker WHERE %ID=:rowid)
     
	q SQLCODE
}

//w ##class(dhc.bonus.umodule.uBonusIncomeRate).getDeptName(0,25,"工作量")

ClassMethod getDeptName(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusSubDeptGroupID, DeptGroupName FROM dhc_bonus_subs.BonusSubDeptGroup "
	i str'="" s sqlStr = sqlStr_" where DeptGroupName LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
    //w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	d json.InsertRowData("-1^通用科室")
	s count=count+1
	While(result.Next()){
		s rowid = result.Data("BonusSubDeptGroupID")
		s name = result.Data("DeptGroupName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

//w ##class(dhc.bonus.umodule.uBonusIncomeRate).getItem(0,25,"体检")

ClassMethod getItem(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BonusIncItemID,ItemName FROM dhc_bonus_module.BonusIncItem WHERE IsValid=1 "
	i str'="" s sqlStr = sqlStr_" and  ItemName LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
    //w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()

	While(result.Next()){
		s rowid = result.Data("BonusIncItemID")
		s name = result.Data("ItemName")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uBonusIncom6B39S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
