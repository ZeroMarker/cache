Class dhc.bonus.usubs.uBonusSubIncomeRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

// BonusSubItemID MakeBillDept ExecuteDept SickDept ChiefDoctor MakeBillDoctor ExecuteDoctor SubItemName ExpensesType SickType MakeBillDeptRate ExecuteDeptRate SickDeptRate

/// w ##class(dhc.bonus.usubs.uBonusSubIncomeRate).Insert("G9^G1^G1^G1^^G1^G1^^1^1^2^2^2")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpty"
	
	k PLIST
	
	s BonusSubItemID=$p(data,"^",1)
	i BonusSubItemID'="" s PLIST(2)=BonusSubItemID
	
	s MakeBillDept=$p(data,"^",2)
	i MakeBillDept'="" s PLIST(3)=MakeBillDept

	s ExecuteDept=$p(data,"^",3)
	i ExecuteDept'="" s PLIST(4)=ExecuteDept
	
	s SickDept=$p(data,"^",4)
	i SickDept'="" s PLIST(5)=SickDept

	s ChiefDoctor=$p(data,"^",5)
	i ChiefDoctor'="" s PLIST(6)=ChiefDoctor
	
	s MakeBillDoctor=$p(data,"^",6)
	i MakeBillDoctor'="" s PLIST(7)=MakeBillDoctor

	s ExecuteDoctor=$p(data,"^",7)
	i ExecuteDoctor'="" s PLIST(8)=ExecuteDoctor
	
	s SubItemName=$p(data,"^",8)
	i SubItemName'="" s PLIST(9)=SubItemName

	s ExpensesType=$p(data,"^",9)
	i ExpensesType'="" s PLIST(10)=ExpensesType
	
	s SickType=$p(data,"^",10)
	i SickType'="" s PLIST(11)=SickType

	s MakeBillDeptRate=$p(data,"^",11)
	i MakeBillDeptRate'="" s PLIST(12)=MakeBillDeptRate

	s ExecuteDeptRate=$p(data,"^",12)
	i ExecuteDeptRate'="" s PLIST(13)=ExecuteDeptRate
	
	s SickDeptRate=$p(data,"^",13)
	i SickDeptRate'="" s PLIST(14)=SickDeptRate
	
	
	&SQL(INSERT INTO dhc_bonus_subs.BonusSubIncomeRate VALUES PLIST())
	
	s IncomeDataAssignment = ##class(dhc.bonus.usubs.uIncomeDataAssignment).%New()
	s rateID= %ROWID
	d IncomeDataAssignment.SetSubIncomeRateGlobal(rateID)
	
	q SQLCODE
}

/// Creator：zhao li guo 
/// CreatDate：2011-7-1
/// Description: 生成临时Global
/// Table：
/// Input：YearCode:核算年度代码;newPeriod:组合期间(如:"M01")
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).SetSubIncomeRateGlobal("2011")
ClassMethod SetSubIncomeRateGlobal(SubIncomeRateID) As %String
{
	n (SubIncomeRateID)
	s num=""
	// ^dhcbsSubIncomeRateD
	f  s num=$O(^dhcbsSubIncomeRateD(num)) q:num=""  d
	.;w "zlg:"_^dhcbsSubIncomeRateD(num),!
	.;w $LIST(^dhcbsSubIncomeRateD(num),2),!
	
	s ^dhcbsSubIncomeRateAll(num)=""
	
	q 0
}

/// w ##class(dhc.bonus.usubs.uBonusSubIncomeRate).Update(2,"1^1^1^1^1^1^7^8^9^10^11^12^13")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "rowidEmpty"
	q:data="" "dataEmpty"
	
	s BonusSubItemID=$p(data,"^",1)
	i BonusSubItemID'="" s PLIST(2)=BonusSubItemID
	
	s MakeBillDept=$p(data,"^",2)
	i MakeBillDept'="" s PLIST(3)=MakeBillDept

	s ExecuteDept=$p(data,"^",3)
	i ExecuteDept'="" s PLIST(4)=ExecuteDept
	
	s SickDept=$p(data,"^",4)
	i SickDept'="" s PLIST(5)=SickDept

	s ChiefDoctor=$p(data,"^",5)
	i ChiefDoctor'="" s PLIST(6)=ChiefDoctor
	
	s MakeBillDoctor=$p(data,"^",6)
	i MakeBillDoctor'="" s PLIST(7)=MakeBillDoctor

	s ExecuteDoctor=$p(data,"^",7)
	i ExecuteDoctor'="" s PLIST(8)=ExecuteDoctor
	
	s SubItemName=$p(data,"^",8)
	i SubItemName'="" s PLIST(9)=SubItemName

	s ExpensesType=$p(data,"^",9)
	i ExpensesType'="" s PLIST(10)=ExpensesType
	
	s SickType=$p(data,"^",10)
	i SickType'="" s PLIST(11)=SickType

	s MakeBillDeptRate=$p(data,"^",11)
	i MakeBillDeptRate'="" s PLIST(12)=MakeBillDeptRate

	s ExecuteDeptRate=$p(data,"^",12)
	i ExecuteDeptRate'="" s PLIST(13)=ExecuteDeptRate
	
	s SickDeptRate=$p(data,"^",13)
	i SickDeptRate'="" s PLIST(14)=SickDeptRate

	&SQL(UPDATE dhc_bonus_subs.BonusSubIncomeRate VALUES PLIST() where %ID=:rowid)
	
	s IncomeDataAssignment = ##class(dhc.bonus.usubs.uIncomeDataAssignment).%New()
	s rateID= %ROWID
	d IncomeDataAssignment.SetSubIncomeRateGlobal(rateID)
	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubIncomeRate).Del(2)
ClassMethod Del(rowid) As %String
{
	n (rowid)
	&SQL(delete from dhc_bonus_subs.BonusSubIncomeRate where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uBonusSubIncomeRate).getDept(2)
ClassMethod getDept(rowid) As %String
{
	n (rowid)
	s name=""
	i (rowid'="")&&($p(rowid,"G",2)'="") d
	. s tmpDr=$p(rowid,"G",2)
	. s name = $list(^dhcbsSubDeptGroupD(tmpDr),3)
	i (rowid'="")&&($p(rowid,"D",2)'="")  d
	. s tmpDrMap=$p(rowid,"D",2)
	.; s tmpDr = $list(^dhcbsSubDeptGroupMapD(tmpDrMap),3)
	.i $g(^dhcbsBonusUnitD(tmpDrMap))'="" d
	..s name = $list(^dhcbsBonusUnitD(tmpDrMap),3)
	i rowid=0  d
	.s name="全部"
	q name
}

/// w ##class(dhc.bonus.usubs.uBonusSubIncomeRate).getDoctor("G1")
ClassMethod getDoctor(rowid) As %String
{
	n (rowid)
	s name=""
	i (rowid'="")&&($p(rowid,"G",2)'="") d
	. s tmpDr=$p(rowid,"G",2)
	. s name = $list(^dhcbsSubDoctorGroupD(tmpDr),3)
	i (rowid'="")&&($p(rowid,"D",2)'="")  d
	. s tmpDrMap=$p(rowid,"D",2)
	.; s tmpDr = $list(^dhcbsSubDoctorGroupMapD(tmpDrMap),3)
	.i $g(^dhcbsBonusUnitD(tmpDrMap))'="" d
	..s name = $list(^dhcbsBonusUnitD(tmpDrMap),3)
	i rowid=0  d
	.s name="全部"
	q name
}

/// w ##class(dhc.bonus.usubs.uBonusSubIncomeRate).List("","","","",0,25,"^G1^G1^G1")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, filter)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, filter)
	
	s tmp1=$p(filter,"^",1)
	s tmp2=$p(filter,"^",2)
	s tmp3=$p(filter,"^",3)
	s tmp4=$p(filter,"^",4)
	;w tmp1,tmp2,tmp3,tmp4,!
	s sqlStr="SELECT * FROM dhc_bonus_subs.BonusSubIncomeRate"
	s whereStr=" WHERE %ID>0 "
	i tmp1'="" d
	.s whereStr=whereStr_" and BonusSubItemID='"_tmp1_"'"
	i tmp2'="" d
	.s whereStr=whereStr_" and MakeBillDept='"_tmp2_"'"
	i tmp3'="" d
	.s whereStr=whereStr_" and ExecuteDept='"_tmp3_"'"
	i tmp4'="" d
	.s whereStr=whereStr_" and SickDept='"_tmp4_"'"

	s sortStr=""		
	i sortField'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField_" ASC"
	e  d
	.s sortStr=" ORDER BY BonusSubIncomeRateID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="BonusSubIncomeRateID^BonusSubItemID^MakeBillDept^ExecuteDept^SickDept^ChiefDoctor^MakeBillDoctor^ExecuteDoctor^SubItemName^ExpensesType^SickType^MakeBillDeptRate^ExecuteDeptRate^SickDeptRate^BonusSubItemName^MakeBillDeptName^ExecuteDeptName^SickDeptName^ChiefDoctorName^MakeBillDoctorName^ExecuteDoctorName"
	
	While(result.Next())
	{
		s BonusSubIncomeRateID=result.Data("BonusSubIncomeRateID")
		s BonusSubItemID=result.Data("BonusSubItemID")
		s BonusSubItemName=""
		i (BonusSubItemID'="")&&($p(BonusSubItemID,"G",2)'="") d
		. s tmpDr=$p(BonusSubItemID,"G",2)
		. s BonusSubItemName = $list(^dhcbsSubItemGroupD(tmpDr),4)
		e  i (BonusSubItemID'="")&&($p(BonusSubItemID,"D",2)'="")  d
		.s tmpDr=$p(BonusSubItemID,"D",2)
		.; s tmpMap=$list(^dhcbsSubItemGroupMapD(tmpDr),3)
		.s BonusSubItemName = $list(^dhcbsSubItemD(tmpDr),3)
		e   d
		.s BonusSubItemName = "全部"
		s MakeBillDept=result.Data("MakeBillDept")
		s MakeBillDeptName=..getDept(MakeBillDept)
		s ExecuteDept=result.Data("ExecuteDept")
		s ExecuteDeptName=..getDept(ExecuteDept)
		s SickDept=result.Data("SickDept")
		s SickDeptName=..getDept(SickDept)
		s ChiefDoctor=result.Data("ChiefDoctor")
		s ChiefDoctorName=..getDoctor(ChiefDoctor)
		s MakeBillDoctor=result.Data("MakeBillDoctor")
		s MakeBillDoctorName=..getDoctor(MakeBillDoctor)
		s ExecuteDoctor=result.Data("ExecuteDoctor")
		s ExecuteDoctorName=..getDoctor(ExecuteDoctor)
		s SubItemName=result.Data("SubItemName")
		s ExpensesType=result.Data("ExpensesType")
		s SickType=result.Data("SickType")
		s MakeBillDeptRate=result.Data("MakeBillDeptRate")
		s ExecuteDeptRate=result.Data("ExecuteDeptRate")
		s SickDeptRate=result.Data("SickDeptRate")
	
		s tmp=BonusSubIncomeRateID_"^"_BonusSubItemID_"^"_MakeBillDept_"^"_ExecuteDept_"^"_SickDept_"^"_ChiefDoctor_"^"_MakeBillDoctor_"^"_ExecuteDoctor_"^"_SubItemName_"^"_ExpensesType_"^"_SickType_"^"_MakeBillDeptRate_"^"_ExecuteDeptRate_"^"_SickDeptRate_"^"_BonusSubItemName_"^"_MakeBillDeptName_"^"_ExecuteDeptName_"^"_SickDeptName_"^"_ChiefDoctorName_"^"_MakeBillDoctorName_"^"_ExecuteDoctorName
		
		i searchValue'="" d
		.q:(searchField="BonusSubIncomeRateID")&(BonusSubIncomeRateID'[searchValue)
		.q:(searchField="BonusSubItemID")&(BonusSubItemID'[searchValue)
		.q:(searchField="MakeBillDept")&(MakeBillDept'[searchValue)
		.q:(searchField="ExecuteDept")&(ExecuteDept'[searchValue)
		.q:(searchField="SickDept")&(SickDept'[searchValue)
		.q:(searchField="ChiefDoctor")&(ChiefDoctor'[searchValue)
		.q:(searchField="MakeBillDoctor")&(MakeBillDoctor'[searchValue)
		.q:(searchField="ExecuteDoctor")&(ExecuteDoctor'[searchValue)
		.q:(searchField="SubItemName")&(SubItemName'[searchValue)
		.q:(searchField="ExpensesType")&(ExpensesType'[searchValue)
		.q:(searchField="SickType")&(SickType'[searchValue)
		.q:(searchField="MakeBillDeptRate")&(MakeBillDeptRate'[searchValue)
		.q:(searchField="ExecuteDeptRate")&(ExecuteDeptRate'[searchValue)
		.q:(searchField="SickDeptRate")&(SickDeptRate'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5E4.uBonusSubInc78DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
