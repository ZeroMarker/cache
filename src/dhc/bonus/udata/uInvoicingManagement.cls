/// Creator: 侯勃
/// CreatDate: 2013-3-26
/// Description: 财务结账管理
Class dhc.bonus.udata.uInvoicingManagement Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：侯勃
/// CreatDate：2013-3-26
/// Description: 查询
/// Table：dhc.bonus.data.SchemePeriod
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uInvoicingManagement).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT SchemePeriodID,BonusYear,BonusPeriod,Flag, UpdateDate  from dhc_bonus_data.SchemePeriod where BonusPeriod like 'M%' "
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="SchemePeriodID"
	.i sortField="bonusYear" s sortField1="BonusYear"
	.i sortField="bonusPeriod" s sortField1="BonusPeriod"
	.i sortField="flag" s sortField1="Flag"
	.i sortField="updateDate" s sortField1="UpdateDate"
	.i sortField="flag1" s sortField1="Flag"
	
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
	s jsonTitle="rowid^bonusYear^bonusPeriod^flag^updateDate^type^flag1"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("SchemePeriodID")
		s bonusYear = result.Data("BonusYear")
		s bonusPeriod = result.Data("BonusPeriod")
		s flag = result.Data("Flag")
		i flag'="" d
		.i flag=0 s flag="数据采集"
		.i flag=1 s flag="奖金核算"
		.i flag=2 s flag="财务记账"
		
		s updateDate = result.Data("UpdateDate")
		i updateDate'=""  d
		.s updateDate = $zd(updateDate,3)
		e  s updateDate=""
		s flag1 = result.Data("Flag")
		//s type=$EXTRACT(bonusPeriod,1)
		
		;w $EXTRACT(bonusPeriod,2,3),!
		i $EXTRACT(bonusPeriod,1)="M" d
		.s bonusPeriod=$EXTRACT(bonusPeriod,2,3)_"月"
		.s type="月"
					
		s tmp=rowid_"^"_bonusYear_"^"_bonusPeriod_"^"_flag_"^"_updateDate_"^"_type_"^"_flag1
		
		i searchValue'="" d
		.q:(searchField = "bonusYear")&(bonusYear'[searchValue)
		.q:(searchField = "bonusPeriod")&(bonusPeriod'[searchValue)
		.q:(searchField = "flag")&(flag'[searchValue)
		.q:(searchField = "updateDate")&(updateDate'[searchValue)
		.q:(searchField = "flag1")&(flag1'[searchValue)
		
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

/// Creator：侯勃
/// CreatDate：2013-3-26
/// Description: 财务核算
/// Table：dhc.bonus.data.SchemePeriod
/// Input：
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.udata.uInvoicingManagement).Accounting("1")
ClassMethod Accounting(rowid) As %String
{
	n (rowid)
	s time=+$p($h,",",1)
	
	&sql(update dhc_bonus_data.SchemePeriod set Flag='1',UpdateDate=:time where SchemePeriodID=:rowid)

	q SQLCODE
}

/// Creator：侯勃
/// CreatDate：2013-3-26
/// Description: 取消核算
/// Table：dhc.bonus.data.SchemePeriod
/// Input：
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.udata.uInvoicingManagement).CancelAccounting("2")
ClassMethod CancelAccounting(rowid) As %String
{
	n (rowid)
	s time=""   ;+$p($h,",",1)
	
	&sql(update dhc_bonus_data.SchemePeriod set Flag='0',UpdateDate=:time where SchemePeriodID=:rowid)

	q SQLCODE
}

/// Creator：侯勃
/// CreatDate：2013-3-26
/// Description: 财务结账
/// Table：dhc.bonus.data.SchemePeriod
/// Input：
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.udata.uInvoicingManagement).Invoicing("1")
ClassMethod Invoicing(rowid) As %String
{
	n (rowid)
	s time=+$p($h,",",1)
	
	&sql(update dhc_bonus_data.SchemePeriod set Flag='2',UpdateDate=:time where SchemePeriodID=:rowid)

	q SQLCODE
}

/// Creator：侯勃
/// CreatDate：2013-3-26
/// Description: 取消结账
/// Table：dhc.bonus.data.SchemePeriod
/// Input：
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.udata.uInvoicingManagement).CancelInvoicing("1")
ClassMethod CancelInvoicing(rowid) As %String
{
	n (rowid)
	s time=+$p($h,",",1)
	
	&sql(update dhc_bonus_data.SchemePeriod set Flag='1',UpdateDate=:time where SchemePeriodID=:rowid)

	q SQLCODE
}

/// Creator：侯勃
/// CreatDate：2013-3-26
/// Description: 状态判断
/// Table：dhc.bonus.data.SchemePeriod
/// Input：
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.udata.uInvoicingManagement).StateJudgement("2016","M01")
ClassMethod StateJudgement(year, month) As %String
{
	n (year,month)
	;s month="M"_month
	s flag=999
	&sql(select Flag into:flag from dhc_bonus_data.SchemePeriod where BonusYear=:year and
	     BonusPeriod=:month)
    i flag ="" d
	.s flag=-1

	q flag
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uInvoicingMa818S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
