/// Creator: 刘洋
/// CreatDate: 2011-1-10
/// Description: 方案周期设置
Class dhc.bonus.udata.uSchemePeriod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：刘洋
/// CreatDate：2011-1-10
/// Description: 查询
/// Table：dhc.bonus.data.SchemePeriod
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uSchemePeriod).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT SchemePeriodID,BonusYear,BonusPeriod,StartDate, EndDate  from dhc_bonus_data.SchemePeriod where %ID>0"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="SchemePeriodID"
	.i sortField="bonusYear" s sortField1="BonusYear"
	.i sortField="bonusPeriod" s sortField1="BonusPeriod"
	.i sortField="startDate" s sortField1="StartDate"
	.i sortField="endDate" s sortField1="EndDate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^bonusYear^bonusPeriod^startDate^endDate^type"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("SchemePeriodID")
		s bonusYear = result.Data("BonusYear")
		s bonusPeriod = result.Data("BonusPeriod")
		s startDate = result.Data("StartDate")
		s startDate = $zd(startDate,3)
		s endDate = result.Data("EndDate")
		s endDate = $zd(endDate,3)
		//s type=$EXTRACT(bonusPeriod,1)
		
		;w $EXTRACT(bonusPeriod,2,3),!
		i $EXTRACT(bonusPeriod,1)="M" d
		.s bonusPeriod=$EXTRACT(bonusPeriod,2,3)_"月"
		.s type="月"
		
		i $EXTRACT(bonusPeriod,1)="H" d
		.s type="半年"
		i $EXTRACT(bonusPeriod,1)="Q" d
		.s type="季"
		i $EXTRACT(bonusPeriod,1)="Y" d
		.s type="年"
		
		
		i bonusPeriod="H01" d
		.s bonusPeriod="上半年"
		i bonusPeriod="H02" d
		.s bonusPeriod="下半年"
		i bonusPeriod="Y00" d
		.s bonusPeriod="全年"
		i bonusPeriod="Q01" d
		.s bonusPeriod="第一季度"
		i bonusPeriod="Q02" d
		.s bonusPeriod="第二季度"
		i bonusPeriod="Q03" d
		.s bonusPeriod="第三季度"
		i bonusPeriod="Q04" d
		.s bonusPeriod="第四季度"
					
		s tmp=rowid_"^"_bonusYear_"^"_bonusPeriod_"^"_startDate_"^"_endDate_"^"_type
		
		i searchValue'="" d
		.q:(searchField = "bonusYear")&(bonusYear'[searchValue)
		.q:(searchField = "bonusPeriod")&(bonusPeriod'[searchValue)
		.q:(searchField = "startDate")&(startDate'[searchValue)
		.q:(searchField = "endDate")&(endDate'[searchValue)
		
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

/// Creator：刘洋
/// CreatDate：2011-1-10
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.SchemePeriod
/// Input：yearDr-年度ID;typeDr-期间类型;periodDr-期间;startDr-开始时间;endDr-结束时间;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uSchemePeriod).InsertRec("2010","M","04","2010-04-01","2010-04-30")
ClassMethod InsertRec(yearDr, typeDr, periodDr, startDr, endDr) As %String
{
	

	n (yearDr, typeDr,periodDr,startDr,endDr)
	s period=typeDr_periodDr
	s sl=0
	&sql(select count(*) into :sl FROM dhc_bonus_data.SchemePeriod WHERE BonusYear=:yearDr AND BonusPeriod=:period )
	i sl="" s sl=0
	q:sl>0 "RepCode"
	
	s startDr=$zdh(startDr,3)
	s endDr=$zdh(endDr,3)
	&sql(insert into dhc_bonus_data.SchemePeriod (BonusYear,BonusPeriod,StartDate,EndDate,Flag) values(:yearDr,:period,:startDr,:endDr,0))

	q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-1-10
/// Description: 更新记录
/// Table：dhc.bonus.data.SchemePeriod
/// Input：Rowid-记录的ID;yearDr-年度ID;typeDr-期间类型;periodDr-期间;startDr-开始时间;endDr-结束时间;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uSchemePeriod).UpdateRec("","","半年","下半年","","")
ClassMethod UpdateRec(Rowid, yearDr, typeDr, periodDr, startDr, endDr) As %String
{
	
	n (Rowid,yearDr, typeDr, periodDr, startDr, endDr)
	
	i typeDr="月" d
	.s typeDr="M"
	i typeDr="季" d
	.s typeDr="Q"
	i typeDr="年" d
	.s typeDr="Y"
	i typeDr="半年" d
	.s typeDr="H"
	
	i $EXTRACT(periodDr,3)="月" d
	.s periodDr=$EXTRACT(periodDr,1,2)
	i periodDr="全年" d
	.s periodDr="00"
	i periodDr="上半年" d
	.s periodDr="01"
	i periodDr="下半年" d
	.s periodDr="02"
	
	i periodDr="第一季度" d
	.s periodDr="01"
	i periodDr="第二季度" d
	.s periodDr="02"
	i periodDr="第三季度" d
	.s periodDr="03"
	i periodDr="第四季度" d
	.s periodDr="02"
	
	s period=typeDr_periodDr
	;w period,!
	s startDr=$zdh(startDr,3)
	s endDr=$zdh(endDr,3)
	
	s sl=0
	&sql(select count(*) into :sl FROM dhc_bonus_data.SchemePeriod 
	WHERE BonusYear=:yearDr AND BonusPeriod=:period and  %ID<>:Rowid )
	i sl="" s sl=0
	q:sl>0 "RepCode"
		
	&SQL(update dhc_bonus_data.SchemePeriod set BonusYear=:yearDr,BonusPeriod=:period,StartDate=:startDr,EndDate=:endDr where %ID=:Rowid)
	q SQLCODE
}

/// Creator: 刘洋
/// CreatDate: 2011-1-10
/// Description: 删除记录
/// Table：dhc.bonus.data.SchemePeriod
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uSchemePeriod).Delete(1)
ClassMethod Delete(rowId) As %String
{
	n (rowId)
	
	&SQL(DELETE FROM dhc_bonus_data.SchemePeriod WHERE %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uSchemePeriodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
