/// Creator: zhaoliguo
/// CreatDate: 2011-01-12
/// Description: 医院奖金核算周期设置
Class dhc.bonus.comm.SchemePeriod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock, StorageStrategy = "" ]
{

/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-12
/// Description: 得到奖金核算年度
/// Table: dhc.bonus.data.SchemePeriod
/// Input: topCount:显示当前topCount条记录,orderby?排序关键字?取值"Desc" 或"Asc"
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.comm.SchemePeriod).GetBonusYears(3,"Asc")
ClassMethod GetBonusYears(topCount, orderby) As %String
{
		new (topCount,orderby)
		
		s sqlStr=""
		
		i topCount'="" d
		.s sqlStr="select top "_topCount_" SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%' "
		e   d
		.s sqlStr="select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%' "

		
		i (orderby="Desc") || (orderby="Asc") d
		.s sqlStr=sqlStr_" order by BonusYear "_orderby_""
		e   d
		.s sqlStr=sqlStr_" order by BonusYear "
		
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		
		s jsonTitle="RowID^BonusYear"
		While(result.Next())
		{
			s rowid=result.Data("SchemePeriodID")
			s code=result.Data("BonusYear")
			s tmp=rowid_"^"_code
			d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,topCount)
	 	k json
		q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.comm.SchemePeriodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
