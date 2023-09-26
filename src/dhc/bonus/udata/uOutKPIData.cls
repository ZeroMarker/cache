Class dhc.bonus.udata.uOutKPIData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-11-08
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.data.Cycle
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).ListRec("8","","","","","",0,25,"2011","09","M")
ClassMethod ListRec(InterLocSetDr, InterMethodDr, searchField, searchValue, sortField, sortDir, start, limit, CycleDr, period, frequency) As %String
{
		n (InterLocSetDr,InterMethodDr,searchField, searchValue, sortField, sortDir, start, limit,CycleDr,period,frequency)
		
			
		s sqlStr1="select BonusCollectTempID,b.InterLoc_code,InterLoc_name,"
			_" InterLoc_jxUnitDr->BonusUnitCode,InterLoc_jxUnitDr->BonusUnitName,InterLoc_jxUnitDr->BonusUnitTypeID->UnitTypeName,"
			_"  c.InterKPI_kpiDr->BonusTargetCode,c.InterKPI_kpiDr->BonusTargetName,BonusYear,BonusPeriod,TargetValue,a.InterLocMethodID->InterLocMethod_methodDesc"
			_" ,case when status=0 then '采集成功'  when status=1 then '导入成功' end as status"
			_" from  dhc_bonus_data.BonusCollectTemp a,dhc_bonus_inter.InterLoc b,  dhc_bonus_inter.InterKPI  c"
			_" where TargetValue !=0 and b.InterLoc_code = a.BonusUnitCode and a.BonusTargetCode = InterKPI_okrDr->OutKpiRule_outKpiCode "
			_" and c.InterKPI_okrDr->OutKpiRule_inLocSetDr= a.InterLocMethodID->InterLocSet_rowid   and b.InterLoc_active='Y'"
			_" and a.InterLocMethodID->InterLocSet_rowid="_InterLocSetDr_" and BonusYear='"_CycleDr_"' and BonusPeriod='"_frequency_period_"'"
		
		s sqlStr=" select BonusCollectTempID,b.InterLoc_code,InterLoc_name, d.BonusUnitCode,d.BonusUnitName,"
				_" e.UnitTypeName,  f.BonusTargetCode,f.BonusTargetName,BonusYear,BonusPeriod,TargetValue,j.InterLocMethod_methodDesc ,"
				_" case when status=0 then '采集成功'  when status=1 then '导入成功' end as status"

				_" from  dhc_bonus_data.BonusCollectTemp a,dhc_bonus_inter.InterLoc b,dhc_bonus_inter.InterKPI  c"
				_" ,dhc_bonus_data.BonusUnit  d,dhc_bonus_data.BonusUnitType e,dhc_bonus_data.BonusTarget f,dhc_bonus_inter.InterLocMethod j,dhc_bonus_inter.OutKpiRule h"
				_" where TargetValue !=0 and b.InterLoc_code = a.BonusUnitCode and a.BonusTargetCode = h.OutKpiRule_outKpiCode and h.OutKpiRule_interMethodDr= a.InterLocMethodID"
				_" and InterLoc_jxUnitDr=d.BonusUnitID and d.BonusUnitTypeID = e.BonusUnitTypeID and c.InterKPI_kpiDr=f.BonusTargetID and a.InterLocMethodID=j.InterLocMethod_rowid and InterKPI_okrDr = h.outKpiRule_rowid and b.InterLoc_active='Y'"
				_" and h.OutKpiRule_inLocSetDr="_InterLocSetDr_" and BonusYear='"_CycleDr_"' and BonusPeriod='"_frequency_period_"'"
				
		
		i InterMethodDr'="" d
		.s sqlStr =sqlStr_" and a.InterLocMethodID= "_InterMethodDr

		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusCollectTempID"
		.i sortField="outUnitCode" s sortField1="b.InterLoc_code"
		.i sortField="outUnitName" s sortField1="InterLoc_name"
		.i sortField="outUnitLocCode" s sortField1="d.BonusUnitCode"
		.i sortField="outUnitLocName" s sortField1="d.BonusUnitName"
		
		.i sortField="unitType" s sortField1="e.UnitTypeName"
		.i sortField="outKpiCode" s sortField1="c.BonusTargetCode"
		.i sortField="outKpiName" s sortField1="c.BonusTargetName"
		
		.i sortField="period" s sortField1="BonusYear"
		.i sortField="periodType" s sortField1="BonusPeriod"
		.i sortField="actValue" s sortField1="TargetValue"
		.i sortField="methodDesc" s sortField1="j.InterLocMethod_methodDesc"
		.i sortField="status" s sortField1="a.status"
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		
		s sqlStr=sqlStr_sortStr
		
		//w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		//w "zlg1:"_count_"/"_start_"/"_end
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		
		s jsonTitle="rowid^outUnitCode^outUnitName^outUnitLocCode^outUnitLocName^unitType^outKpiCode^outKpiName^period^periodType^actValue^methodDesc^handFlag^status"
		
		While(result.Next())
		{
							
			s rowid=result.Data("BonusCollectTempID")
			s outUnitCode=result.Data("InterLoc_code")
			s outUnitName=result.Data("InterLoc_name")
			s outUnitLocCode=result.Data("BonusUnitCode")
			s outUnitLocName=result.Data("BonusUnitName")
			
			s unitType=result.Data("UnitTypeName")
			//i Type="L" s unitType="科室"
			//i Type="P" s unitType="个人"
			
			s outKpiCode=result.Data("BonusTargetCode")
			s outKpiName=result.Data("BonusTargetName")
			s period=result.Data("BonusYear")
			s ptype=result.Data("BonusPeriod")
			
			s ptype =$E(ptype,1,1)
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s actValue=result.Data("TargetValue")
			s status=result.Data("status")
			
			s methodDesc=result.Data("InterLocMethod_methodDesc")
			s handFlag=1 // 
			
			s tmp=rowid_"^"_outUnitCode_"^"_outUnitName_"^"_outUnitLocCode_"^"_outUnitLocName_"^"_unitType_"^"_outKpiCode_"^"_outKpiName_"^"_period_"^"_periodType_"^"_actValue_"^"_methodDesc_"^"_handFlag_"^"_status
			s count=count+1
			
			//w "tmp:"_searchValue_"/"_tmp,!
			
			i searchValue'="" d
			.;w searchField, searchValue," "_outKpiCode,!
			.q:(searchField="outUnitCode")&(outUnitCode'[searchValue)
			.q:(searchField="outUnitName")&(outUnitName'[searchValue)
			.q:(searchField="outUnitLocCode")&(outUnitLocCode'[searchValue)
			.q:(searchField="outUnitLocName")&(outUnitLocName'[searchValue)
			.q:(searchField="unitType")&(unitType'[searchValue)
			.q:(searchField="outKpiCode")&(outKpiCode'[searchValue)
			.q:(searchField="outKpiName")&(outKpiName'[searchValue)
			.q:(searchField="period")&(period'[searchValue)
			.q:(searchField="periodType")&(periodType'[searchValue)
			.q:(searchField="actValue")&(actValue'[searchValue)
			.q:(searchField="handFlag")&(handFlag'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
		
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-2
/// Description: 删除期间类型对应的期间的数据
/// Table：dhc.bonus.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).ImportData("2011","M01",5,21)
ClassMethod ImportData(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	n (sYear, sPeriod, interLocSetDr,interMethodDr)
 	//删除重复数据
 	d ..DeleteCollectData(sYear, sPeriod, interLocSetDr,interMethodDr)
	//插入采集的数据
	d ..InsertCollectData(sYear, sPeriod, interLocSetDr,interMethodDr)
	//更改导入标识
	d ..UpdateCollectStatus(sYear, sPeriod, interLocSetDr,interMethodDr)
	
	q 0
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-2
/// Description: 删除期间类型对应的期间的数据
/// Table：dhc.bonus.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).ImportData("2011","M01",5,21)
ClassMethod InsertCollectData(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	n (sYear, sPeriod, interLocSetDr,interMethodDr)
	s insertSql ="insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID, BonusYear ,BonusPeriod, DataSource ,TargetValue ,AuditingState, UpdateDate)"
		_" select c.InterKPI_kpiDr->BonusTargetID,InterLoc_jxUnitDr->BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod,5 DataSource,TargetValue,0 AuditingState,getdate() as updateDate"
		_" from  dhc_bonus_data.BonusCollectTemp a,dhc_bonus_inter.InterLoc b, dhc_bonus_inter.InterKPI c"
		_" where  b.InterLoc_active='Y' and b.InterLoc_code = a.BonusUnitCode and a.BonusTargetCode = InterKPI_okrDr->OutKpiRule_outKpiCode and"
		_" a.InterLocMethodID->InterLocSet_rowid="_interLocSetDr
 		_" and BonusYear='"_sYear_"' and BonusPeriod='"_sPeriod_"'"	
 	i interMethodDr'="" d 
 	.s insertSql=insertSql_" and a.InterLocMethodID="_interMethodDr
 	
 
 	d ..DeleteCollectData(sYear, sPeriod, interLocSetDr,interMethodDr)
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(insertSql)
	d result.Execute()
	d result.Close()
	
	
	q 0
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-2
/// Description: 删除期间类型对应的期间的数据
/// Table：dhc.bonus.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).DeleteCollectData("2011","M01",5,21)
ClassMethod DeleteCollectData(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	n (sYear, sPeriod, interLocSetDr,interMethodDr)
 	
 	s deleteStr="delete from  dhc_bonus_data.BonusTargetCollect"
		_" where BonusYear='"_sYear_"' and BonusPeriod='"_sPeriod_"'"	
		_" and InterLocMethodID->InterLocSet_rowid="_interLocSetDr
		
	 i interMethodDr'="" d 
 		.s deleteStr=deleteStr_" and InterLocMethodID="_interMethodDr	
	 	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(deleteStr)
	d result.Execute()
	d result.Close()
	q 0
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-2
/// Description: 删除期间类型对应的期间的导入及采集数据
/// Table：dhc.bonus.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).DeleteCollectData("2011","M01",5,21)
ClassMethod DeleteData(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	d ..DeleteCollectData(sYear, sPeriod, interLocSetDr, interMethodDr)
	d ..DeleteTempData(sYear, sPeriod, interLocSetDr, interMethodDr)
	q 0
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-2
/// Description: 更新数据导入标识
/// Table：dhc_bonus_inter.InterLog dhc_bonus_data.BonusCollectTemp
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).UpdateCollectStatus("2011","M01",5,21)
ClassMethod UpdateCollectStatus(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	n (sYear, sPeriod, interLocSetDr,interMethodDr)
 	
 	s uInterLog=" update dhc_bonus_inter.InterLog set InterLog_status=1"
 	    _" where InterLog_Year='"_sYear_"'  and InterLog_Period='"_sPeriod_"'"	
		 _" and InterLog_MethodDr->InterLocSet_rowid="_interLocSetDr 
	 i interMethodDr'="" d 
 	.s uInterLog=uInterLog_" and InterLog_MethodDr="_interMethodDr	
 
  	s updateStr="update dhc_bonus_data.BonusCollectTemp set status=1 "
 	    _" where BonusYear='"_sYear_"'  and BonusPeriod='"_sPeriod_"'"	
		_" and InterLocMethodID->InterLocSet_rowid="_interLocSetDr 
	 i interMethodDr'="" d 
 	.s updateStr=updateStr_" and InterLocMethodID="_interMethodDr	
 	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(uInterLog)
	d result.Execute()
	d result.Close()
	
	s result1=##class(%Library.ResultSet).%New()
	d result1.Prepare(updateStr)
	d result1.Execute()	
	d result1.Close()
	q 0
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-2
/// Description: 删除期间类型对应的期间的数据
/// Table：dhc.bonus.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).DeleteTempData("2011","M01",5,"")
ClassMethod DeleteTempData(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	n (sYear, sPeriod, interLocSetDr,interMethodDr)
 	
 	s deleteStr="delete from  dhc_bonus_data.BonusCollectTemp"
		_" where BonusYear='"_sYear_"' and BonusPeriod='"_sPeriod_"'"	
		_" and InterLocMethodID->InterLocSet_rowid="_interLocSetDr
		
	 i interMethodDr'="" d 
 		.s deleteStr=deleteStr_" and InterLocMethodID="_interMethodDr	
	 	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(deleteStr)
	d result.Execute()
	d result.Close()
	q 0
}

/// Creator: zhaoliguo
/// CreatDate: 2011-5-3
/// Description: 得到奖金数据导入的状态
/// Table：dhc.bonus.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uOutKPIData).GetImportStatus("2011","M01",5,21)
ClassMethod GetImportStatus(sYear, sPeriod, interLocSetDr, interMethodDr) As %String
{
	n (sYear, sPeriod, interLocSetDr,interMethodDr)
	s strSql ="SELECT top 1 InterLog_status FROM dhc_bonus_inter.InterLog"
         _" where InterLog_Year='"_sYear_"' and InterLog_Period='"_sPeriod_"' "
         _" and  InterLog_MethodDr->InterLocSet_rowid="_interLocSetDr
         
   	i interMethodDr'="" d 
 	.s strSql=strSql_" and InterLog_MethodDr="_interMethodDr
 	
 	//w strSql,!
 	s Status=-1
 
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	
	While(result.Next())
	{
		s Status=result.Data("InterLog_status")
	
	}
	d result.Close()
	q Status
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uOutKPIDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
