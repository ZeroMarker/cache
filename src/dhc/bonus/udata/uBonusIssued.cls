/// Creator:李明忠 
/// CreatDate:2012-3-31
/// Description:奖金下发
Class dhc.bonus.udata.uBonusIssued Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2012-3-31
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
	s sql =" select SchemeItemID from dhc_bonus_data.BonusIssuedMain where BonusYear="_year_" and BonusPeriod='"_period_"' and SupBonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusEmployeeUnit where BonusEmployeeID="_userId_")"
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

/// Creator:李明忠
/// CreatDate:2012-3-31
/// Description:查询科室下发奖金项目
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:year-年度;period-期间;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).getUnit("2016","M05","demo")
ClassMethod getUnit(sYear, sMonth, userCode) As %String
{
	n (sYear,sMonth,userCode)
	
	q:userCode="" ""
	
	;s userId=0
	;s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	;&sql(select * from dhc_bonus_data.BonusEmployee WHERE UPPER(EmployeeCode)=UPPER(:userCode))
	;q:userId="" ""
	
	s sql ="  select distinct a.BonusUnitID,a.BonusUnitID->BonusUnitName "
	_" from  dhc_bonus_data.BonusIssuedMain a,dhc_bonus_data.BonusEmployeeUnit b"
	_" where a.BonusUnitID=b.BonusUnitID AND   BonusYear='"_sYear_"' and BonusPeriod='"_sMonth_"' "
	_" and UPPER(BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"')"
	_" order by a.BonusUnitID->BonusUnitTypeID,a.BonusUnitID->BonusUnitCode"

	s result=##class(%Library.ResultSet).%New()
	;w sql,!
	d result.Prepare(sql)
	d result.Execute()
		
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	d json.InsertRowData("-1^全部")
	
	s count=0
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

/// Creator:李明忠
/// CreatDate:2012-3-31
/// Description:查询科室下发金额记录
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:year-年度;period-期间;userCode-用户代码;itemId-项目ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).LocInfo("2016","M04","demo","","","","","",0,25)
ClassMethod LocInfo(year, period, userCode, UnitID, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (year,period,userCode,UnitID,searchField,searchValue,sortField,sortDir,start,limit)
	
	s sqlStr=""
	
	i UnitID>0 d
	.s sqlStr="select BonusYear,BonusPeriod,BonusIssuedMainID,BonusUnitID,SupBonusUnitID,SchemeItemID"
	.s sqlStr=sqlStr_",BonusSchemeID->BonusSchemeName,ResultBonus,PayBonus,DataStatus,DeptUpDate,DeptUpPerson,PayBalance "
	.s sqlStr=sqlStr_" from dhc_bonus_data.BonusIssuedMain where  BonusYear="_year 
	.s sqlStr=sqlStr_" and BonusPeriod='"_period_"' and BonusUnitID="_UnitID
	e  d
	.s sqlStr=" select BonusYear,BonusPeriod,BonusIssuedMainID,BonusUnitID,SupBonusUnitID,SchemeItemID,"
	.s sqlStr=sqlStr_" BonusSchemeID->BonusSchemeName,ResultBonus,PayBonus,DataStatus,DeptUpDate,DeptUpPerson,PayBalance "
	.s sqlStr=sqlStr_" from dhc_bonus_data.BonusIssuedMain where  BonusYear="_year_" and BonusPeriod='"_period_"'"
	.s sqlStr=sqlStr_" and BonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusEmployeeUnit where UPPER(BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"'))"
	
	q:sqlStr="" ""
	s sqlStr=sqlStr_" order by BonusUnitID->BonusUnitCode"
	
	;w sqlStr,!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^locId^locName^itemId^schemeName^itemName^downmoeny^upStatus^upTime^upPersonId"
	  _"^upPersonName^bonusYear^bonusPeriod^PayBonus^Payye^PayBalance"
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
		s bonusPeriod=$E( result.Data("BonusPeriod"),2,4)
		s schemeName= result.Data("BonusSchemeName")
		s PayBonus= $fn(result.Data("PayBonus"),"",2)
		s PayBalance=$fn(result.Data("PayBalance"),"",2)
		s Payyee=PayBalance+downmoeny-PayBonus
		
		s upStatus = result.Data("DataStatus")
		i upStatus=0 s upStatus="已下发"
		i upStatus=1 s upStatus="已下发"
		i upStatus=2 s upStatus="已上报"
		i upStatus=3 s upStatus="已接收"
		i upStatus=4 s upStatus="已拒绝"
		
		
		s upTime = result.Data("DeptUpDate")
		s upPersonId = result.Data("DeptUpPerson")
		i upPersonId'="" d
		.s upPersonName=$List(^dhcbsBonusEmployeeD(upPersonId),3)
		
		s Payye=downmoeny-PayBonus
		s tmp=rowid_"^"_locId_"^"_locName_"^"_itemId_"^"_schemeName_"^"_itemName_"^"_downmoeny
		_"^"_upStatus_"^"_upTime_"^"_upPersonId_"^"_upPersonName_"^"_bonusYear_"^"_bonusPeriod
		_"^"_PayBonus_"^"_Payyee_"^"_PayBalance
		
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

/// Creator:李明忠
/// CreatDate:2012-3-31
/// Description:查询科室下发明细金额记录
/// Table:dhc_bonus_data.BonusIssuedDetail
/// Input:parent-主表ID;year-年度;period-期间;itemId-项目ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output:
/// Return:返回查询到的记录的Json串 ddddd
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).DetailList(343,"2012","M05",126,"","","","desc",0,25)
ClassMethod DetailList(supUnitID, year, period, itemId, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (supUnitID,year,period,itemId,searchField,searchValue,sortField,sortDir,start,limit)
	
	s result=##class(%Library.ResultSet).%New()
	s sql = "select BonusIssuedDetailID,BonusUnitID,BonusUnitCode,BonusUnitName,IssuedBonus,"
	_" AdjustBonus,ResultBonus,AdjustDate,AdjustPerson,SchemeItemID->SchemeItemName ItemName,IsNewEmp,Remark" 
		_" from dhc_bonus_data.BonusIssuedDetail "
       _" WHERE BonusYear='"_year_"' AND BonusPeriod='"_period_"' AND SchemeItemID='"_itemId_"' AND SuperiorUnitID='"_supUnitID_"'"
	
	//s ^zlgtem=sql
	d result.Prepare(sql)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^year^period^personId^personName^downmoeny^tzmoeny^upmoney^itemId^itemName^adjustDate^adjustPersonId^adjustPersonName^UnitCode^NewEmp^adjRate^Remark"
	//取结构
	While(result.Next()){
		s personName="",adjustPersonName=""
		
		s rowid = result.Data("BonusIssuedDetailID")
		s personId = result.Data("BonusUnitID")
		s IsNewEmp = result.Data("IsNewEmp")
		s NewEmp=""
		i IsNewEmp=1 d 
		.s NewEmp="新增"
		
		s personName=""
		s personName = result.Data("BonusUnitName")
		
		s UnitCode= result.Data("BonusUnitCode")
		s remark= result.Data("Remark")
		
		s downmoeny = $fn(result.Data("IssuedBonus"),"",2)
		s tzmoeny = $fn(result.Data("AdjustBonus"),"",2)
		s upmoney = $fn(result.Data("ResultBonus"),"",2)
		s itemName= result.Data("ItemName")
		
		s adjRate=""
		//w tzmoeny_":"_downmoeny,!
		i ((downmoeny>0) || (downmoeny<0)) d
		.s adjRate=$fn((tzmoeny/downmoeny)*100,"",2)_"%"
		
		
		s adjustDate = result.Data("AdjustDate")
		s adjustPersonId = result.Data("AdjustPerson")
		i adjustPersonId'="" d
		.s adjustPersonName = $List(^dhcbsBonusEmployeeD(adjustPersonId),3)
		
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

/// Creator:李明忠
/// CreatDate:2012-3-31
/// Description:修改明细
/// Table:dhc_bonus_data.BonusIssuedDetail
/// Input:rowid-明细数据ID;userCode-用户代码;tzmoney-调整值;downmoney-下发值
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Update(119205,"fhq",1,1)
ClassMethod Update(rowid, userCode, tzmoney, downmoney, Remark) As %String
{
	n (rowid,userCode,tzmoney,downmoney,Remark)
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	s adjustDate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	
	s upmoney = tzmoney+downmoney
	;w upmoney,!
	//&sql(update dhc_bonus_data.BonusIssuedDetail set AdjustBonus=:tzmoney,ResultBonus=:upmoney,AdjustPerson=:userId,AdjustDate=:adjustDate where %ID=:rowid)
	&sql(update dhc_bonus_data.BonusIssuedDetail set AdjustBonus=:tzmoney,ResultBonus=:upmoney,AdjustPerson=:userId,AdjustDate=:adjustDate,Remark=:Remark where %ID=:rowid)

	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2012-3-31
/// Description:验证
/// Table:dhc_bonus_data.BonusIssuedDetail
/// Input:rowid-明细数据ID;total-总值
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Juge(2131,2425.6)
ClassMethod Juge(rowid, total) As %String
{
	n (rowid,total)
	
	s Total=""
	s flag = 0
	s issued=0
	s ResultBonus =0
    s syear=""
    s smonth=""
    s sitem=""
    s sUnit=""

    
	&sql(SELECT ResultBonus,BonusUnitID, BonusYear , BonusPeriod , SchemeItemID
		 into:issued ,:sUnit,:syear,:smonth,:sitem
	 FROM dhc_bonus_data.BonusIssuedMain a 
	 where  BonusIssuedMainID=:rowid)
	  
	&sql(	select SUM(a.ResultBonus) into :ResultBonus 
	   from dhc_bonus_data.BonusIssuedDetail a
		where SuperiorUnitID=:sUnit AND BonusYear=:syear AND BonusPeriod=:smonth
		 AND SchemeItemID=:sitem)
		
	&sql(update dhc_bonus_data.BonusIssuedMain SET PayBonus= :ResultBonus
	  where  BonusIssuedMainID=:rowid)
	  
    s ResultBonus=$fn(ResultBonus,"",1)
    s issued=$fn(issued,"",1)
    
	s df=0
	//s issued=1110
	s df=issued-ResultBonus
		
	i df'=""  d
	.s flag=""_ issued_" -"_ResultBonus_"="_df

	;i issued'=total s flag=1
	
	;s flag = 0
	q flag
}

/// Description:下发总金额与分配总金额的差额
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Juge(5,2425.6)
ClassMethod BonusJuge(rowid, total) As %String
{
	n (rowid,total)
	
	s Total=""
	s flag = 0
	s issued=0
	s ResultBonus =0
	/*
	s result=##class(%Library.ResultSet).%New()
	s sql = "select SUM(IssuedBonus) as Total,SUM(a.ResultBonus) as ResultBonus"
			_" from dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BonusIssuedMain b"
			_" where a.BonusYear= b.BonusYear and a.BonusPeriod= b.BonusPeriod and a.SuperiorUnitID= b.BonusUnitID"
			_" and a.SchemeItemID= b.SchemeItemID and b.BonusIssuedMainID="_rowid
	
	;w sql,!
	d result.Prepare(sql)
	d result.Execute()
	
	While(result.Next()){	
		s issued = $fn(result.Data("Total"),"",0)
		s ResultBonus = $fn(result.Data("ResultBonus"),"",0)
		
	}*/
	
	&sql(	select SUM(a.ResultBonus) into :ResultBonus from dhc_bonus_data.BonusIssuedDetail a
		where  BonusIssuedMainID=:rowid)

	&sql(SELECT ResultBonus into:issued FROM dhc_bonus_data.BonusIssuedMain a where  BonusIssuedMainID=:rowid)
    s ResultBonus=$fn(ResultBonus,"",1)
    s issued=$fn(issued,"",1)
    
	s df=0
	//s issued=1110
	s df=issued-ResultBonus
		
	i (df>0) ||(df<0) d
	.s difference=issued-ResultBonus
	.s difference=$fn(difference,"",1)
	.s flag=issued_"-"_ResultBonus_"="_difference

	;i issued'=total s flag=1
	
	;s flag = 0
	q flag
}

/// Creator:李明忠
/// CreatDate:2012-3-31
/// Description:数据上报
/// Table:dhc_bonus_data.BonusIssuedMain
/// Input:rowid-主表数据ID;userCode-用户代码
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusIssued).Up(20584,"fhq")
ClassMethod Up(rowid, userCode) As %String
{
	n (rowid,userCode)
	
	s DeptUpDate = $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	
	s userId=0
	s userId = $O(^dhcbsBonusEmployeeI("Code",userCode,userId))
	
	s DataStatus=2
	
	&sql(update dhc_bonus_data.BonusIssuedMain set DataStatus=:DataStatus,DeptUpDate=:DeptUpDate,DeptUpPerson=:userId where BonusIssuedMainID=:rowid)
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2012-3-31
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
		&sql(delete from dhc_bonus_data.BonusIssuedDetail where %ID=:rowID)
	q SQLCODE
}

/// Creator：guojing
/// CreatDate：2016-9-23
/// 添加时判断是否重复,表里存在该条数据,返回id,不存在返回0
/// Table：dhc_bonus_data.BonusIssuedDetail
/// w ##class(dhc.bonus.udata.uBonusIssued).RepCode("2038","295")
ClassMethod RepCode(BonusIssuedMainID, bonusUnitID) As %String
{
	n (BonusIssuedMainID, bonusUnitID)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusIssuedDetail WHERE BonusIssuedMainID='"_BonusIssuedMainID_"' AND BonusUnitID ='"_bonusUnitID_"' "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusIssuedDetailID")
	}
	q rowid
}

/// Creator：赵立国
/// CreatDate：2012-7-7
/// Description: 插入一条新数据
/// Table：dhc_bonus_data.BonusIssuedDetail
/// Input：data :mID^AdjustBonus^AdjustPerson^SchemeItemID^SuperiorUnitID^SupUnitName^BonusUnitCode^BonusUnitName^BonusYear^BonusPeriod
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusIssued).InsertDetail("3456^500^fhq^126^343^信息中心^444^生死符^2012^05")
ClassMethod InsertDetail(data) As %String
{
	
	n (data)
	;s ^zlgtemp=data
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
	
	s BonusUnitCode  = $P(data,"^",7)
	s BonusUnitName  = $P(data,"^",8)
	s BonusYear  = $P(data,"^",9)
	s BonusPeriod ="M"_ $P(data,"^",10)
	s IsNewEmp=1
	//w "BonusPeriod:"_BonusPeriod,!
	
	s AdjustDate= $ZD($h,3)_" "_$ZT($P($h,",",2),3)
	s UpdateDate =AdjustDate
	s bonusUnitID=""
	s bonusUnitID=$O(^dhcbsBonusUnitI("BonusUnitCode",BonusUnitCode,bonusUnitID))
	
	s tmpRowid=..RepCode(mID,bonusUnitID)
	q:tmpRowid "RepCode"
	
	&sql(insert into dhc_bonus_data.BonusIssuedDetail(BonusIssuedMainID, IssuedBonus, AdjustBonus
	, ResultBonus, AdjustDate, AdjustPerson,SchemeItemID,SuperiorUnitID,
 	SupUnitName, BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,IsNewEmp,UpdateDate,bonusUnitID)
 	values(:mID, 0,:AdjustBonus	,:ResultBonus, :AdjustDate, :AdjustPerson,:SchemeItemID,:SuperiorUnitID,
 	:SupUnitNam, :BonusUnitCode,:BonusUnitName,:BonusYear,:BonusPeriod,:IsNewEmp,:UpdateDate,:bonusUnitID))
 	
	q SQLCODE
}

/// Creator：zhao li guo
/// CreatDate：2014-12-18
/// Description: 人事中的人员基本信息：工号、名称
/// Table：
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uBonusIssued).GetEmpInfo(0,10,"王")
ClassMethod GetEmpInfo(start, limit, str) As %String
{
    n (start, limit, str,userCode)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = " SELECT EmpCardID,Name FROM  HISHR.PersonInfo"  
	_" WHERE EmpCardID LIKE '%"_str_"%' OR Name  LIKE '%"_str_"%'"

	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
	
		s code = result.Data("EmpCardID")
		s name = result.Data("Name")
		s tmp=code_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json 	
 	q resultString
}

/// Others: w ##class(dhc.bonus.udata.uBonusIssued).GetPerInfo(0,10,"王")
ClassMethod GetPerInfo(start, limit, str) As %String
{
    n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = " SELECT BonusUnitCode,BonusUnitName ,SumUnitID->BonusUnitName AS UnitName FROM  dhc_bonus_data.BonusUnit "  
	s whereStr = " WHERE UnitFlag=3 AND IsValid=1 "
	i str'=""  d
	.s whereStr= whereStr_"AND  BonusUnitCode LIKE '%"_str_"%' OR BonusUnitName  LIKE '%"_str_"%'"
    
    s sqlStr=sqlStr_whereStr
    
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
	
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s UnitName = result.Data("UnitName")
		s tmp=code_"^"_name_"-"_UnitName
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
<StreamLocation>^dhc.bonus.udata.uBonusIssuedS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
