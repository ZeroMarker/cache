/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-20
/// Description: 人员奖金发放
Class dhc.bonus.udata.uEmployeeBonusPay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2011-01-20
/// Description: 查询人员奖金核算
/// Table: dhc.bonus.data.EmployeeBonusPay
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uEmployeeBonusPay).ListRec("2011","M01","","rowID","desc",0,25)
ClassMethod ListRec(bonusYear, bonusPeriod, bonusUnit, sortField, sortDir, start, limit) As %String
{
		new (bonusYear,bonusPeriod, bonusUnit,sortField,sortDir, start, limit)
		
		s sqlStr=""
		s sqlStr=sqlStr_" select a.EmployeeBonusPayID rowID,a.BonusUnitID as BonusEmployeeID,c.BonusUnitID,c.BonusUnitName,b.BonusUnitName as EmployeeName,BonusValue,BonusYear,a.UpdateDate"	
		s sqlStr=sqlStr_" ,Case when Left('"_bonusPeriod_"',1)='M' then right('"_bonusPeriod_"',2)_'月份'  when Left('"_bonusPeriod_"',1)='Q' then right('"_bonusPeriod_"',2)_'季度'   when'H01'='"_bonusPeriod_"' then  '上半年'"
		s sqlStr=sqlStr_"  when'"_bonusPeriod_"'='H02' then  '下半年' when Left('"_bonusPeriod_"',1)='Y' then '' end as BonusPeriod ,'"_bonusPeriod_"' as PeriodCode "
		s sqlStr=sqlStr_" from dhc_bonus_data.EmployeeBonusPay a"
		s sqlStr=sqlStr_" join dhc_bonus_data.BonusUnit b on a.BonusUnitID = b.BonusUnitID"
		s sqlStr=sqlStr_" join dhc_bonus_data.BonusUnit c on b.SuperiorUnitID = c.BonusUnitID"
		s sqlStr=sqlStr_" where a.BonusYear ='"_bonusYear_"' and a.BonusPeriod= '"_bonusPeriod_"'"
		if bonusUnit'="" {
			s sqlStr=sqlStr_" and c.BonusUnitID="_bonusUnit
			}
			
			s sortStr=""
		s sortField1=""
		i sortField'="" d
		.i sortField="rowid" s sortField1="a.EmployeeBonusPayID"
		.i sortField="EmployeeName" s sortField1="b.BonusUnitName"
		
		.i sortField="BonusYear" s sortField1="BonusYear"
		.i sortField="PeriodCode" s sortField1="PeriodCode"
		
		.i sortField="BonusUnitName" s sortField1="c.BonusUnitName"
		
		.i sortField="BonusValue" s sortField1="BonusValue"
		.i sortField="UpdateDate" s sortField1="a.UpdateDate"
	
   		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
		.e  s sortStr=" order by "_sortField1_" asc"
		
		s sqlStr=sqlStr_sortStr		
			
			
		//w sqlStr,!
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowID^BonusEmployeeID^EmployeeName^BonusUnitID^BonusUnitName^BonusValue^BonusYear^BonusPeriod^PeriodCode^UpdateDate"
		
		While(result.Next())
		{
			s rowid=result.Data("rowID")
			s BonusEmployeeID=result.Data("BonusEmployeeID")
			s EmployeeName=result.Data("EmployeeName")
			s BonusUnitID=result.Data("BonusUnitID")
			s BonusUnitName=result.Data("BonusUnitName")
			s BonusValue=result.Data("BonusValue")
			s BonusYear=result.Data("BonusYear")
			s BonusPeriod=result.Data("BonusPeriod")
			s PeriodCode = result.Data("PeriodCode")
			s UpdateDate=result.Data("UpdateDate")
	
			
			s tmp=rowid_"^"_BonusEmployeeID_"^"_EmployeeName_"^"_BonusUnitID_"^"_BonusUnitName_"^"_BonusValue_"^"_BonusYear_"^"_BonusPeriod_"^"_PeriodCode_"^"_UpdateDate
			s count=count+1
			i (count>start)&(count<=end) d
			.d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: zhao liguo
/// CreatDate:  2011-01-21
/// Description: 插入新记录
/// Table: dhc_bonus_data.EmployeeBonusPay
/// Input: data-待插入的数据( BonusEmployeeID^BonusYear^BonusPeriod^BonusValue)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.bonus.udata.uEmployeeBonusPay).InsertRec("1^2010^M02^346")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s BonusEmployeeID=$p(data,"^",1)
		s BonusYear=$p(data,"^",2)
		s BonusPeriod = $p(data,"^",3)
		s BonusValue = $p(data,"^",4)
		s UpdateDate = $ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		s isexist = ..IfExitRec(BonusEmployeeID,BonusYear,BonusPeriod)
		
		IF isexist'=0{
			q "exist"
			}
		
		i BonusEmployeeID'="" s PLIST(2)=BonusEmployeeID
		i BonusYear'="" s PLIST(3)=BonusYear
		i BonusPeriod'="" s PLIST(4)=BonusPeriod
		i BonusValue'="" s PLIST(5)=BonusValue
		s PLIST(6)=UpdateDate
	
		
		&sql(insert into dhc_bonus_data.EmployeeBonusPay  VALUES PLIST())
		q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-01-20
/// Description: 查询人员奖金核算
/// Table: dhc.bonus.data.EmployeeBonusPay
/// Input:empID-人员ID;bonusYear-核算年度；bonusPeriod-核算期间
/// Output: 
/// Return: 0:没有重复值，>0：要添加的值已经存在
/// Others: w ##class(dhc.bonus.udata.uEmployeeBonusPay).IfExitRec(1,"2010","M02")
ClassMethod IfExitRec(empID, bonusYear, bonusPeriod) As %String
{
		new (empID,bonusYear,bonusPeriod)
		

		s sqlStr="select * from dhc_bonus_data.EmployeeBonusPay"
		s sqlStr=sqlStr_" where BonusUnitID ="_empID_" and BonusYear ='"_bonusYear_"'  and  BonusPeriod='"_bonusPeriod_"'"	

		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0

		While(result.Next())
		{
			s rowid=result.Data("EmployeeBonusPayID")
			s count=count+1
		
		}
	
		d result.Close()

		q count
}

/// Creator: zhaoliguo
/// CreatDate: 2011-1-26
/// Description: 删除记录
/// Table：dhc_bonus_data.EmployeeBonusPay
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uEmployeeBonusPay).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.EmployeeBonusPay WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhao liguo
/// CreatDate:  2011-01-26
/// Description: 修改记录
/// Table: dhc_bonus_data.EmployeeBonusPay
/// Input: data-待修改的数据( rowid^BonusEmployeeID^BonusYear^BonusPeriod^BonusValue)
/// Output: 
/// Return: 0:成功，！=0：失败
/// Others: w ##class(dhc.bonus.udata.uEmployeeBonusPay).EditRec("49^1^2010^M02^346")
ClassMethod EditRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s rowid=$p(data,"^",1)
		s BonusEmployeeID=$p(data,"^",2)
		s BonusYear=$p(data,"^",3)
		s BonusPeriod = $p(data,"^",4)
		s BonusValue = $p(data,"^",5)
		s UpdateDate = $ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	
		&sql(update dhc_bonus_data.EmployeeBonusPay  set BonusUnitID=:BonusEmployeeID,BonusYear=:BonusYear,BonusValue=:BonusValue,UpdateDate=:UpdateDate  where EmployeeBonusPayID=:rowid)
		q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uEmployeeBon6E6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
