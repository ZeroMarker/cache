/// Creator: wang ying
/// CreatDate: 2013-07-16
/// Description: 指标类别与指标级别对应表
Class dhc.pa.udata.uKPILevel Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2013-07-16
/// Description: 查询符合条件的记录
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPILevel).ListRec("Y","","","","",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT KPILevel_rowid,KPILvel_KPIDr,KPILevel_LevelDr  FROM dhc_pa_data.KPILevel WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="KPILevel_rowid"
		.i sortField="KpiDr" s sortField1="KPILvel_KPIDr"
		.i sortField="levelDr" s sortField1="KPILevel_LevelDr"
		
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^KpiDr^KPIName^levelDr^LevelName^levelScore"
		
		While(result.Next())
		{
			s KPIDr="",KPIName="",LevelName=""
			s rowid=result.Data("KPILevel_rowid")
			s KpiDr = result.Data("KPILvel_KPIDr")
			i KpiDr'="" d
			.i $d(^DHCCJXPAKPISCORETYPE(KpiDr)) d
			..i $g(^DHCCJXPAKPISCORETYPE(KpiDr)) d
			...s KPIDr=$p(^DHCCJXPAKPISCORETYPE(KpiDr),"^",1)
			...i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
			....s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			
			s levelDr=result.Data("KPILevel_LevelDr")
			i levelDr'="" d
			i $d(^DHCCJXPASCORELEVEL(levelDr)) d
			.s LevelName=$p($g(^DHCCJXPASCORELEVEL(levelDr)),"^",3)
			.s score=$p($g(^DHCCJXPASCORELEVEL(levelDr)),"^",1)
			
			
			s tmp=rowid_"^"_KPIDr_"^"_KPIName_"^"_levelDr_"^"_LevelName_"^"_score
			s count=count+1
			i searchValue'="" d
			.q:(searchField="KpiDr")&(KpiDr'[searchValue)
			.q:(searchField="KPIName")&(KPIName'[searchValue)
			.q:(searchField="active")&(active'[searchValue)
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

/// Creator: wang ying
/// CreatDate: 2013-07-16
/// Description: 查询指标类别中的指标
/// Table: dhc_pa_data.KpiScoreType
/// Input: Start-起始行;Limit-行数;str-模糊查询字符串
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPILevel).getKPIType(0,25,"")
ClassMethod getKPIType(start, limit, str) As %String
{
		
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KpiScoreType_Rowid,KpiScoreType_KpiDr,KPIIndex1_name,KPIIndex1_shortcut from dhc_pa_data.KpiScoreType,dhc_pa_data.KPIIndex1 where KpiScoreType_KpiDr=KPIIndex1_rowid and KpiScoreType_LevelScore='Y'"
	s whereStr=""
	;s whereStr=" and not exists (select KPILvel_KPIDr from dhc_pa_data.KPILevel WHERE KpiScoreType_Rowid=KPILvel_KPIDr)"
	i str'="" s whereStr=" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KpiScoreType_Rowid")
		s shortCut=result.Data("KPIIndex1_shortcut")
		s tmp=KPIDr_"^"_shortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("KPIDr^shortCut",count)
 	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate: 2013-07-16
/// Description: 查询指标等级
/// Table: dhc_pa_data.KpiScoreType
/// Input: Start-起始行;Limit-行数;str-模糊查询字符串
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPILevel).getLevel(0,25,"")
ClassMethod getLevel(start, limit, str) As %String
{
		
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ScoreLevel_Rowid,ScoreLevel_Score,ScoreLevel_Code, ScoreLevel_Name,ScoreLevel_ShortCut from dhc_pa_data.ScoreLevel where %ID>0"
	s whereStr=""
	i str'="" s whereStr=" and ScoreLevel_ShortCut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s scoreLevel = result.Data("ScoreLevel_Rowid")
		s shortCut=result.Data("ScoreLevel_ShortCut")
		s score=result.Data("ScoreLevel_Score")
		s shortCut=shortCut_"-"_score
		s tmp=scoreLevel_"^"_shortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("scoreLevel^shortCut",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2013-7-16
/// Description: 为给定的绩效单元添加基本数据记录
/// Table：dhc_pa_data.KPILevel
/// Input：data-待插入数据(jxunitdr^period^periodType^kpidr^actualValue^state);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPILevel).Insert("3^1,2,3,4,5")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	s SQLCODE=0
	s KPIDr=$p(data,"^",1)
	s LevelDrs=$p(data,"^",2)
	TSTART
	s LevelLen=$l(LevelDrs,",")
	i KPIDr'="" s PLIST(2)=KPIDr 
	f i=1:1:LevelLen d
	.s LevelDr=$p(LevelDrs,",",i)
	.i LevelDr'="" s PLIST(3)=LevelDr    
	.i (..IfRepRecode(KPIDr,LevelDr))'=""  s SQLCODE="RepRecode" 
	.e  &SQL(insert into dhc_pa_data.KPILevel VALUES PLIST())
	
	i SQLCODE'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2013-7-17
/// Description: 判断对照表中数据重复
/// Table：dhc_pa_data.KPILevel
/// Input：KPIDr-指标ID;LevelDr-等级id
/// Output：
/// Return：返回rowid
/// Others：w ##class(dhc.pa.udata.uJXBaseData).IfRepRecode(1,"200902",2,"M")
ClassMethod IfRepRecode(KPIDr, LevelDr) As %String
{
	n (KPIDr,LevelDr)
	
	s rowid=""
	s rowid = $O(^DHCCJXPAKPILEVEL(0,"KPILevel",KPIDr,LevelDr,rowid))
	q rowid
}

/// Creator:wang ying
/// CreatDate:2013-7-17
/// Description:删除对照表中数据
/// Table:dhc_pa_data.KPILevel
/// Input:rowid-数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uKPILevel).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.KPILevel where KPILevel_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPILevelS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
