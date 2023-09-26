/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:奖金下发
Class dhc.bonus.udata.uBonusIssuedCheck Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:查询科室下发奖金项目
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:year-年度;period-期间;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).getItem("2011","M11","fhq")
ClassMethod getItem(year, period, userCode) As %String
{
	n (year,period,userCode)
	
	q:userCode="" ""
	q:year="" ""
	q:period="" ""
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	q:userId="" ""
	s sql =" select SchemeItemID from dhc_bonus_data.BonusIssuedMain "
	_" where BonusYear="_year_" and BonusPeriod='"_period_"' and  and SupBonusUnitID  "
	_" in (select BonusUnitID from dhc_bonus_data.BonusEmployeeUnit where BonusEmployeeID="_userId_")"
	s result=##class(%Library.ResultSet).%New()
	//w sql,!
	d result.Prepare(sql)
	d result.Execute()
		
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	s count=0
	While(result.Next()){
		s rowid = result.Data("SchemeItemID")
		s name = $List(^dhcbsBonusSchemeItemD(rowid),4)
		s tmp=rowid_"^"_name
		d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:查询科室下发奖金项目
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:year-年度;period-期间;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).getUnit("fhq")
ClassMethod getUnit(userCode) As %String
{
	n (userCode)
	
	q:userCode="" ""
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	q:userId="" ""
	s sql =" select BonusUnitID,BonusUnitID->BonusUnitName BonusUnitName from dhc_bonus_data.BonusEmployeeUnit where BonusEmployeeID="_userId
	s result=##class(%Library.ResultSet).%New()
	//w sql,!
	d result.Prepare(sql)
	d result.Execute()
		
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	s count=0
	d json.InsertRowData("-1^全部")
	
	While(result.Next()){
		s rowid = result.Data("BonusUnitID")
		s name = result.Data("BonusUnitName")
		s tmp=rowid_"^"_name
		d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:查询科室下发金额记录
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:year-年度;period-期间;userCode-用户代码;itemId-项目ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssuedCheck).LocInfo("2016","M05","demo","-1","","","","",0,25)
ClassMethod LocInfo(year, period, userCode, UnitID, DataStatus, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (year,period,userCode,UnitID,DataStatus,searchField,searchValue,sortField,sortDir,start,limit)
	
	s sqlStr=""
	
	i UnitID>0 d
	.s sqlStr="select BonusYear,BonusPeriod,BonusIssuedMainID,BonusUnitID,SupBonusUnitID,SchemeItemID,ResultBonus,DataStatus,DeptUpDate,DeptUpPerson,CheckDate,CheckPerson,PayBonus, PayBalance"
	.s sqlStr=sqlStr _" from dhc_bonus_data.BonusIssuedMain where ResultBonus>0  and DataStatus>1 and BonusYear="_year_" and BonusPeriod='"_period_"' and BonusUnitID="_UnitID
	e  d
	.s userId=0
	.s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	.q:userId=""
	.s sqlStr="select BonusYear,BonusPeriod,BonusIssuedMainID,BonusUnitID,SupBonusUnitID,SchemeItemID,ResultBonus,DataStatus,DeptUpDate,DeptUpPerson,CheckDate,CheckPerson,PayBonus, PayBalance"
	.s sqlStr=sqlStr _" from dhc_bonus_data.BonusIssuedMain where ResultBonus>0 and DataStatus>1 and BonusYear="_year_" and BonusPeriod='"_period_"' and BonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusEmployeeUnit where BonusEmployeeID="_userId_")"
	//w sqlStr,!
	i DataStatus>0 d
	.s sqlStr=sqlStr _"  and DataStatus= "_DataStatus
	s sqlStr=sqlStr_" order by BonusUnitID->BonusUnitCode"
	
	s ^zlgtemp3=sqlStr
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^locId^locName^itemId^itemName^downmoeny^upStatus^upTime^upPersonId^upPersonName^bonusYear^bonusPeriod^CheckDate^CheckPerson^PayBonus^PayBalance^Payye"
	//取结构
	While(result.Next()){
		s locName="未知科室",itemName="未知项目",upPersonName=""
		
		s rowid = result.Data("BonusIssuedMainID")
		s locId = result.Data("BonusUnitID")
		i locId'="" d
		.s locName = $List(^dhcbsBonusUnitD(locId),3)
		s itemId = result.Data("SchemeItemID")
		i itemId'="" d
		.s itemName = $List(^dhcbsBonusSchemeItemD(itemId),4)
		s downmoeny = $fn(result.Data("ResultBonus"),"",2)
		s bonusYear= result.Data("BonusYear")
		
		s PayBonus= $fn(result.Data("PayBonus"),"",2) 
		s PayBalance= $fn(result.Data("PayBalance"),"",2)
		s Payye =PayBalance+downmoeny-PayBonus
		//PayBonus^PayBalance^Payye
		s CheckDate= result.Data("CheckDate")
		s CheckPerson= result.Data("CheckPerson")
		
		s ckPersonName=""
		i CheckPerson'="" d
		.s ckPersonName=$List(^dhcbsBonusEmployeeD(CheckPerson),3)
		
		s bonusPeriod=$E( result.Data("BonusPeriod"),2,4)
		s upStatus = result.Data("DataStatus")
		i upStatus=0 s upStatus="未分配"
		i upStatus=1 s upStatus=""
		i upStatus=2 s upStatus="已上报"
		i upStatus=3 s upStatus="已接收"
		i upStatus=4 s upStatus="已拒绝"
		
		s upTime = result.Data("DeptUpDate")
		s upPersonId = result.Data("DeptUpPerson")
		i upPersonId'="" d
		.s upPersonName=$List(^dhcbsBonusEmployeeD(upPersonId),3)
		
		s tmp=rowid_"^"_locId_"^"_locName_"^"_itemId_"^"_itemName_"^"_downmoeny_"^"_upStatus_"^"_upTime
		_"^"_upPersonId_"^"_upPersonName_"^"_bonusYear_"^"_bonusPeriod_"^"_CheckDate_"^"_ckPersonName
		_"^"_PayBonus_"^"_PayBalance_"^"_Payye
		
		i searchValue'="" d
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

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:查询科室下发明细金额记录
/// Table:dhc_bonus_data.BonusIssuedDetail
/// Input:parent-主表ID;year-年度;period-期间;itemId-项目ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output:
/// Return:返回查询到的记录的Json串 zlg20141218
/// Others:w ##class(dhc.bonus.udata.uBonusIssuedCheck).DetailList(11,"2014","M01",34,"","","","desc",0,25)
ClassMethod DetailList(supUnitID, year, period, itemId, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (supUnitID,year,period,itemId,searchField,searchValue,sortField,sortDir,start,limit)
	
	//s itemName = $List(^dhcbsBonusSchemeItemD(itemId),4)
	s result=##class(%Library.ResultSet).%New()
	s sql = "select BonusIssuedDetailID,BonusUnitID,BonusUnitCode,BonusUnitName,IssuedBonus,"
	_" AdjustBonus,ResultBonus,AdjustDate,AdjustPerson,SchemeItemID->SchemeItemName ItemName,IsNewEmp,Remark" 
		_" from dhc_bonus_data.BonusIssuedDetail "
		_" WHERE (ResultBonus>0 or ResultBonus<0 ) and  SuperiorUnitID='"_supUnitID_"'  and BonusYear = '"_year_"' "
		_" and  BonusPeriod ='"_period_"' and SchemeItemID='"_itemId_"'"
		_" union all "
		_" select 1 BonusIssuedDetailID,0 BonusUnitID,null BonusUnitCode,null BonusUnitName,sum(IssuedBonus) j0,"
	_" sum(AdjustBonus) j1,sum(ResultBonus) j2, null AdjustDate,'0' AdjustPerson,"
	_" '金额合计:' ItemName,0 IsNewEmp,null Remark" 
		_" from dhc_bonus_data.BonusIssuedDetail "
		_" WHERE (ResultBonus>0 or ResultBonus<0 ) and  SuperiorUnitID='"_supUnitID_"'  and BonusYear = '"_year_"' "
		_" and  BonusPeriod ='"_period_"' and SchemeItemID='"_itemId_"'"

	//w sql,!
	k ^zlgtmp
	s ^zlgtmp=sql
	d result.Prepare(sql)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^year^period^personId^personName^downmoeny^tzmoeny^upmoney^itemId^itemName^adjustDate^adjustPersonId^adjustPersonName^UnitCode^NewEmp^adjRate^remark"
	//取结构
	While(result.Next()){
		s personName="",adjustPersonName=""
		
		s rowid = result.Data("BonusIssuedDetailID")
		s personId = result.Data("BonusUnitID")
		s remark = result.Data("Remark")
		
		s IsNewEmp = result.Data("IsNewEmp")
				s NewEmp=""
		i IsNewEmp=1 d 
		.s NewEmp="新增"
		
		s personName=""
		s personName = result.Data("BonusUnitName")
		
		s UnitCode= result.Data("BonusUnitCode")
		
		s downmoeny = $fn(result.Data("IssuedBonus"),"",2)
		s tzmoeny = $fn(result.Data("AdjustBonus"),"",2)
		s upmoney = $fn(result.Data("ResultBonus"),"",2)
		s itemName= result.Data("ItemName")
		
		s adjRate=""
		//w tzmoeny_":"_downmoeny,!
		i ((downmoeny>0) || (downmoeny<0)) d
		.s adjRate=$fn((tzmoeny/downmoeny)*100,"",2)_"%"
		
		s adjustPersonName=""
		s adjustDate = result.Data("AdjustDate")
		s adjustPersonId = result.Data("AdjustPerson")
	
		i adjustPersonId>0 d
		.s adjustPersonName = $List($g(^dhcbsBonusEmployeeD(adjustPersonId),3))
		
		s period1= $E(period,2,3)_"月"
		s tmp=rowid_"^"_year_"^"_period1_"^"_personId_"^"_personName_"^"_downmoeny_"^"_tzmoeny_"^"_upmoney_"^"
			_itemId_"^"_itemName_"^"_adjustDate_"^"_adjustPersonId_"^"_adjustPersonName_"^"_UnitCode_"^"_NewEmp_"^"_adjRate_"^"_remark
		
		i searchValue'="" d
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

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:修改明细
/// Table:dhc_bonus_data.BonusIssuedDetail
/// Input:rowid-明细数据ID;userCode-用户代码;tzmoney-调整值;downmoney-下发值
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Update(119205,"fhq",1,1)
ClassMethod Update(rowid, remark) As %String
{
	n (rowid,remark)
	
	q:rowid=1 "11"
	
	&sql(update dhc_bonus_data.BonusIssuedDetail set Remark=:remark where %ID=:rowid)

	q SQLCODE
}

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:验证
/// Table:dhc_bonus_data.BonusIssuedDetail
/// Input:rowid-明细数据ID;total-总值
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Juge(3456,112700)
ClassMethod Juge(rowid, total) As %String
{
	n (rowid,total)
	
	s Total=""
	s flag = 0
	s issued=0
	s ResultBonus =0
	
	s result=##class(%Library.ResultSet).%New()
	s sql = "select SUM(IssuedBonus) as Total,SUM(a.ResultBonus) as ResultBonus"
			_" from dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BonusIssuedMain b"
			_" where a.BonusYear= b.BonusYear and a.BonusPeriod= b.BonusPeriod and a.SuperiorUnitID= b.BonusUnitID"
			_" and a.SchemeItemID= b.SchemeItemID and b.BonusIssuedMainID="_rowid
	
	//w sql,!
	d result.Prepare(sql)
	d result.Execute()
	
	While(result.Next()){	
		s issued = $fn(result.Data("Total"),"",2)
		s ResultBonus = $fn(result.Data("ResultBonus"),"",2)
		
	}
	s df=0
	//s issued=1110
	s df=issued-ResultBonus
		
	i (df>0) ||(df<0) d
	.s flag="下发总金额:"_ issued_" 与 上报总金额:"_ResultBonus_" 数据不等!"

	;i issued'=total s flag=1
	
	q flag
}

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:数据上报
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:rowid-主表数据ID;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Check(20584,"fhq")
ClassMethod Check(rowid, userCode) As %String
{
	n (rowid,userCode)
	
	s DeptUpDate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	
	s DataStatus=3 //3：上报数据接收，4：上报数据返回
	
	&sql(update dhc_bonus_data.BonusIssuedMain set DataStatus=:DataStatus,CheckDate=:DeptUpDate,CheckPerson=:userId where BonusIssuedMainID=:rowid)
	q SQLCODE
}

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:数据上报
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:rowid-主表数据ID;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).CacleCheck(20584,"fhq")
ClassMethod CacleCheck(rowid, userCode) As %String
{
	n (rowid,userCode)
	
	s DeptUpDate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	
	s DataStatus=4 //3：上报数据接收，4：上报数据返回
	
	&sql(update dhc_bonus_data.BonusIssuedMain set DataStatus=:DataStatus,CheckDate=:DeptUpDate,CheckPerson=:userId where BonusIssuedMainID=:rowid)
	q SQLCODE
}

/// Creator:Zhao LiGuo
/// CreatDate:2012-7-31
/// Description:数据上报
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:rowid-主表数据ID;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Up(20584,"fhq")
ClassMethod CacelUp(rowid, userCode) As %String
{
	n (rowid,userCode)
	
	s DeptUpDate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	
	s DataStatus=1
	
	&sql(update dhc_bonus_data.BonusIssuedMain set DataStatus=:DataStatus,DeptUpDate=null,DeptUpPerson=null where BonusIssuedMainID=:rowid)
	q SQLCODE
}

/// Creator：赵立国
/// CreatDate：2012-7-7
/// Description: 插入一条新数据
/// Table：dhc_bonus_data.BonusIssuedDetail
/// Input：data :mID^AdjustBonus^AdjustPerson^SchemeItemID^SuperiorUnitID^SupUnitName^BonusUnitCode^BonusUnitName^BonusYear^BonusPeriod
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusIssued).Delete(31884)
ClassMethod Delete(rowID) As %String
{
	
	n (rowID)
	k ^zlgtemp(4)
	 s ^zlgtemp(4)=rowID
		&sql(delete from dhc_bonus_data.BonusIssuedDetail where %ID=:rowID)
	q SQLCODE
}

/// Creator：赵立国
/// CreatDate：2012-7-7
/// Description: 插入一条新数据
/// Table：dhc_bonus_data.BonusIssuedDetail
/// Input：data :mID^AdjustBonus^AdjustPerson^SchemeItemID^SuperiorUnitID^SupUnitName^BonusUnitCode^BonusUnitName^BonusYear^BonusPeriod
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusIssued).InsertDetail("90^777^demo^94^6^消化内科^A00479^郑丽芳-神经内科^2016^05")
ClassMethod InsertDetail(data) As %String
{
	
	n (data)
	
	k ^zlgtemp
	s ^zlgtemp=data
	s mID  = $P(data,"^",1)
	s AdjustBonus  = $P(data,"^",2)
	s ResultBonus  = $P(data,"^",2)
	s AdjustPerson = $P(data,"^",3)
	s empid=""
	s empid=$O(^dhcbsBonusEmployeeI("Code",AdjustPerson,empid))
	s AdjustPerson = empid
	
	s SchemeItemID  = $P(data,"^",4)
	s SuperiorUnitID  = $P(data,"^",5)
	s SupUnitNam  = $P(data,"^",6)
	//w "SupUnitNam:"_SupUnitNam,!
	//

	s BonusUnitCode  = $P(data,"^",7)
	s BonusUnitName  = $P(data,"^",8)
	s BonusYear  = $P(data,"^",9)
	s BonusPeriod ="M"_ $P(data,"^",10)
	s IsNewEmp=1
	s AdjustDate= $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	s UpdateDate =AdjustDate
	
	s bonusUnitID=""
	s bonusUnitID=$O(^dhcbsBonusUnitI("BonusUnitCode",BonusUnitCode,bonusUnitID))
	
	;w BonusUnitCode_","_bonusUnitID,!
	//w mID_"^"_AdjustBonus_"^"_SchemeItemID_"^"_BonusUnitCode_"^"_BonusUnitName_"^"_BonusYear_"^"_BonusPeriod,!
	/*
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	*/
	
	&sql(insert into dhc_bonus_data.BonusIssuedDetail(BonusIssuedMainID, IssuedBonus, AdjustBonus
	, ResultBonus, AdjustDate, AdjustPerson,SchemeItemID,SuperiorUnitID,
 	SupUnitName, BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,IsNewEmp,UpdateDate,BonusUnitID)
 	values(:mID, 0,:AdjustBonus	,:ResultBonus, :AdjustDate, :AdjustPerson,:SchemeItemID,:SuperiorUnitID,
 	:SupUnitNam, :BonusUnitCode,:BonusUnitName,:BonusYear,:BonusPeriod,:IsNewEmp,:UpdateDate,:BonusUnitID))
 	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusIssued6C7S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
