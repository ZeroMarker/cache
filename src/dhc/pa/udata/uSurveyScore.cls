/// Creator: 李明忠
/// CreatDate: 2011-05-26
/// Description: 调查问卷明细
Class dhc.pa.udata.uSurveyScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2011-05-26
/// Description: 获取方案层级深度
/// Table：dhc_pa_data.Schem、dhc_pa_data.SchemDetail
/// Input：schemDr-方案Dr
/// Output：
/// Return：方案层级深度
/// Others：w ##class(dhc.pa.udata.uSurveyScore).GetDepthInfo("1||5")
ClassMethod GetDepthInfo(schemDr) As %String
{
	n (schemDr)
	
	k ^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j)
	
	s stratagemDr=$P(schemDr,"||",1)
	s schemSub=$P(schemDr,"||",2)
	
	s schemDetailSub=0
	f  s schemDetailSub=$O(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",stratagemDr,0,schemSub,schemDetailSub)) q:schemDetailSub=""  d
	.s curr=$G(^DHCCJXPASTRATAGEM(stratagemDr,"SchemDetail",schemSub,schemDetailSub))
	.s dimenDr=$P(curr,"^",2) //维度(第一层)
	.s dimenDr=-dimenDr,sDetailSub=0
	.f  s sDetailSub=$O(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",stratagemDr,dimenDr,schemSub,sDetailSub)) q:sDetailSub=""  d
	..s curr=$G(^DHCCJXPASTRATAGEM(stratagemDr,"SchemDetail",schemSub,sDetailSub))
	..s KpiTypeDr=$P(curr,"^",2) //指标分类(第二层)
	..s detailSub=0,count=0
	..f  s detailSub=$O(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",stratagemDr,KpiTypeDr,schemSub,detailSub)) q:detailSub=""  d
	...s curr=$G(^DHCCJXPASTRATAGEM(stratagemDr,"SchemDetail",schemSub,detailSub))
	...s KpiDr=$P(curr,"^",2) //指标(第三层)
	...s rate=$P(curr,"^",4) //指标权重(第三层)
	...s count=count+1
	...s ^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j,-dimenDr,KpiTypeDr,count)=KpiDr_"^"_rate
}

/// Creator:李明忠
/// CreatDate:2011-05-30
/// Description:查询问卷调查指标
/// Table：
/// Input:schemDr-方案Dr
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSurveyScore).List("1||30",1,"01","M",1,5)
/// wang ying 2011-06-09 修改
ClassMethod List(schemDr, cycleDr, period, periodType, scoreUserDr, acceptUnitDr) As %String
{
	n (schemDr,cycleDr,period,periodType,scoreUserDr,acceptUnitDr)
	
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'=""  d
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	s newPeriod=cycleCode_period
	
	d ..GetDepthInfo(schemDr)
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="kpiDr^kpiName^score^level^desc^rate^submit^patName^patDr"
	s resultString=""
	
	s kpiDr=0,kpiName=0,count=0,level=0,patName="",patDr=""
	i $D(^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j)) d
	.s dimenDr=0
	.f  s dimenDr=$O(^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j,dimenDr)) q:dimenDr=""  d
	..s kpiDr=-dimenDr
	..i $D(^DHCCJXPADIMENSTYPE(dimenDr)) d
	...s kpiName=$P(^DHCCJXPADIMENSTYPE(dimenDr),"^",2)
	...s level=1
	...s rate="",score="",desc=""
	...s tmp=kpiDr_"^"_kpiName_"^"_score_"^"_level_"^"_desc_"^"_rate_"^"_patName_"^"_patDr
	...s count=count+1
	...d json.InsertRowData(tmp)
	...s kpiType=0
	...f  s kpiType=$O(^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j,dimenDr,kpiType)) q:kpiType=""  d
	....s kpiDr=kpiType
	....i $D(^DHCCJXPAKPIINDEX1(kpiType)) d
	.....s kpiName="+"_$P(^DHCCJXPAKPIINDEX1(kpiType),"^",2)
	.....s level=2
	.....s rate="",score="",desc=""
	.....s tmp=kpiDr_"^"_kpiName_"^"_score_"^"_level_"^"_desc_"^"_rate_"^"_patName_"^"_patDr
	.....s count=count+1
	.....d json.InsertRowData(tmp)
	.....s Num=0
	.....f  s Num=$O(^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j,dimenDr,kpiType,Num)) q:Num=""  d
	......s curr=^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j,dimenDr,kpiType,Num)
	......s kpiDr=$P(curr,"^",1)
	......i $D(^DHCCJXPAKPIINDEX1(kpiDr)) d
	.......s kpiName="++"_$P(^DHCCJXPAKPIINDEX1(kpiDr),"^",2)
	.......;IfRecord(period, periodType, ScoreUserDr, AcceptUnitDr, SchemDr, KpiDr, patDr)
	.......s patDr=0
	.......;b
	.......f  s patDr=$o(^DHCCJXPASURVEYSCORE(0,"RepRecord",newPeriod,periodType,scoreUserDr,patDr)) q:patDr=""  d
	........;b
	........s surverScoreRowid=..IfRecord(newPeriod, periodType, scoreUserDr, acceptUnitDr, schemDr, kpiDr,patDr)
	........s rate=$P(curr,"^",2),score=0,desc="",submit="N"
	........i surverScoreRowid'=0 d
	.........;w "hhh",!
	.........i $d(^DHCCJXPASURVEYSCORE(surverScoreRowid)) d
	..........;w "surverScoreRowid="_surverScoreRowid,!
	..........s score=+$p($g(^DHCCJXPASURVEYSCORE(surverScoreRowid)),"^",8)
	..........s desc=$p($g(^DHCCJXPASURVEYSCORE(surverScoreRowid)),"^",13)
	..........s submit=$p($g(^DHCCJXPASURVEYSCORE(surverScoreRowid)),"^",14)
	..........s patName=$p($g(^DHCCJXPASURVEYSCORE(surverScoreRowid)),"^",16)
	..........;w score,"  desc="_desc,!
	..........s tmp=kpiDr_"^"_kpiName_"^"_score_"^"_level_"^"_desc_"^"_rate_"^"_submit_"^"_patName_"^"_patDr
	..........s count=count+1
	..........d json.InsertRowData(tmp)
	
	s resultString = json.getJsonData(jsonTitle,count)
	k ^DHCCJXPASurveyScoreTmp("dhc","pa","surveyscore","depthInfo",$j)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-5-31
/// Description: 获取表头信息
/// Table：dhc_pa_data.SurveyScore
/// Input：
/// Output：
/// Return：表头信息字符串
/// Others：w ##class(dhc.pa.udata.uSurveyScore).GetGridTitle()
/// wang ying 2013-06-09 修改
ClassMethod GetGridTitle() As %String
{
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s rowid=1,title="指标Dr",name="kpiDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=2,title="指标名称",name="kpiName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=3,title="描述",name="desc"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=4,title="分数",name="score"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=5,title="权重",name="rate"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=6,title="深度级别",name="level"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=7,title="是否提交",name="submit"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=8,title="打分人",name="patName"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=9,title="打分id",name="patDr"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	
	s resultString=json.getJsonData("rowid^title^name",rowid)
 	k json
 	
 	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-5-31
/// Description: 处理分数信息
/// Table：
/// Input：cycleDr-年度Dr,periodType-期间类别,period-期间,scoreUserDr-评分人,scoreUnitDr-评分人单元,unitType-评分单元类别,acceptUnitDr-接受单元,acceptUnitType-接受单元类别,schemDr-方案,data-数据(格式:data+"||"+kpiDr+"^"+score)
/// Output：
/// Return：0或1
/// Others：w ##class(dhc.pa.udata.uSurveyScore).Save(2,"M","05",888,131,"L",7,"L","1||1","1^^||6^^80||7^^0||8^^30||9^^0||2^^||11^^70||12^^0||13^^0||3^^||14^^100||15^^0||16^^80||17^^100||18^^0||4^^||21^^0||22^^0||23^^0||5^^||29^^0||30^^0||31^^0||32^^0||33^^0||34^^0||35^^0||36^^0||37^^0||38^^")
ClassMethod Save(cycleDr, periodType, period, scoreUserDr, scoreUnitDr, unitType, acceptUnitDr, acceptUnitType, schemDr, data, patDr) As %String
{
	
	n (cycleDr,periodType,period,scoreUserDr,scoreUnitDr,unitType,acceptUnitDr,acceptUnitType,schemDr,data,patDr)
	
	s active="Y"
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" 
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	s newPeriod=cycleCode_period
	
	TSTART
	s rs=0,flag="Y"
	
	s Len=$L(data,"||")
	f i=1:1:Len d
	.s oneData=$P(data,"||",i)
	.s kpiDr=$P(oneData,"^",1)
	.s desc=$p(oneData,"^",2)
	.s score=$P(oneData,"^",3)
	.s newData=scoreUserDr_"^"_scoreUnitDr_"^"_unitType_"^"_acceptUnitDr_"^"_acceptUnitType_"^"_kpiDr_"^"_score_"^"_newPeriod_"^"_periodType_"^"_schemDr_"^"_active_"^"_desc
	.s rs=..InsertOrUpdate(newData,patDr)
	.i rs'=0 d
	..s flag="N"
	
	i flag'="Y" d
	.s rs=1
	.TRollBack
	e  d
	.TCOMMIT
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2011-5-31
/// Description: 保存或者更新分数数据
/// Table：dhc_pa_data.SurveyScore
/// Input：scoreUserDr:评分人;scoreUnitDr:评分人所属单位;unitType:评分单元类别;acceptUnitDr:接受单位;acceptUnitType:接受单元类别;kpiDr:指标ID;score:分数;newPeriod:期间;periodType:期间类型;schemDr:方案;active:有效标志
/// Output：
/// Return：0或1
/// Others：w ##class(dhc.pa.udata.uSurveyScore).Save("")
ClassMethod InsertOrUpdate(newData, patDr) As %String
{
	
	n (newData,patDr)
	
	s rs=0
	s Len=$L(newData,"^")
	f i=1:1:Len d
	.s scoreUserDr=$P(newData,"^",1)
	.s scoreUnitDr=$P(newData,"^",2)
	.s unitType=$P(newData,"^",3)
	.s acceptUnitDr=$P(newData,"^",4)
	.s acceptUnitType=$P(newData,"^",5)
	.s kpiDr=$P(newData,"^",6)
	.s score=$P(newData,"^",7)
	.s newPeriod=$P(newData,"^",8)
	.s periodType=$P(newData,"^",9)
	.s schemDr=$P(newData,"^",10)
	.s active=$P(newData,"^",11)
	.s desc=$P(newData,"^",12)
	
	s RowId=""
	s RowId=..IfRecord(newPeriod,periodType,scoreUserDr,acceptUnitDr,schemDr,kpiDr,patDr)
	;w "RowId="_RowId,!
	i (RowId'=0) d //更新
	.&SQL(update dhc_pa_data.SurveyScore set SurveyScore_DirectScore=:score,SurveyScore_desc=:desc where SurveyScore_ScoreUserDr=:scoreUserDr and SurveyScore_ScoreUnitDr=:scoreUnitDr and SurveyScore_unitType=:unitType and SurveyScore_AcceptUnitDr=:acceptUnitDr and SurveyScore_AcceptUnitType=:acceptUnitType and SurveyScore_KpiDr=:kpiDr and SurveyScore_period=:newPeriod and SurveyScore_periodType=:periodType and SurveyScore_SchemDr=:schemDr and SurveyScore_Active=:active)
	e  d //添加
	.&SQL(Insert Into dhc_pa_data.SurveyScore(SurveyScore_ScoreUserDr,SurveyScore_ScoreUnitDr,SurveyScore_unitType,SurveyScore_AcceptUnitDr,SurveyScore_AcceptUnitType,SurveyScore_KpiDr,SurveyScore_DirectScore,SurveyScore_period,SurveyScore_periodType,SurveyScore_SchemDr,SurveyScore_Active,SurveyScore_desc) VAlUES(:scoreUserDr,:scoreUnitDr,:unitType,:acceptUnitDr,:acceptUnitType,:kpiDr,:score,:newPeriod,:periodType,:schemDr,:active,:desc))
	s rs=SQLCODE
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2011-5-31
/// Description: 判断重复记录
/// Table：dhc_pa_data.SurveyScore
/// Input：scoreUserDr:评分人;acceptUnitDr:接受单位;kpiDr:指标ID;period:期间;periodType:期间类型;schemDr:方案
/// Output：
/// Return：RowId
/// Others：w ##class(dhc.pa.udata.uSurveyScore).IfRecord("")
ClassMethod IfRecord(period, periodType, ScoreUserDr, AcceptUnitDr, SchemDr, KpiDr, patDr) As %String
{
	
	n (period,periodType,ScoreUserDr,AcceptUnitDr,SchemDr,KpiDr,patDr)
	s RowId=0
	s RowId=$o(^DHCCJXPASURVEYSCORE(0,"RepRecord",period,periodType,ScoreUserDr,patDr,AcceptUnitDr,SchemDr,KpiDr,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：wang ying
/// CreatDate：2011-06-09
/// Description: 提交方案
/// Table：dhc_pa_data.SurveyScore
/// Input：scoreUserDr:评分人;scoreUnitDr:评分人所属单位;unitType:评分单元类别;acceptUnitDr:接受单位;acceptUnitType:接受单元类别;kpiDr:指标ID;score:分数;newPeriod:期间;periodType:期间类型;schemDr:方案;active:有效标志
/// Output：
/// Return：0或1
/// Others：w ##class(dhc.pa.udata.uSurveyScore).submit("2||5")
ClassMethod submit(schemDr) As %String
{
	
	n (schemDr)
	s submit="Y"
	&SQL(update dhc_pa_data.SurveyScore set SurveyScore_submit=:submit where SurveyScore_SchemDr=:schemDr)

	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2013-07-19
/// Description: 提交明细
/// Table：dhc_pa_data.SurveyScore
/// Input：scoreUserDr:评分人;scoreUnitDr:评分人所属单位;unitType:评分单元类别;acceptUnitDr:接受单位;acceptUnitType:接受单元类别;kpiDr:指标ID;score:分数;newPeriod:期间;periodType:期间类型;schemDr:方案;active:有效标志
/// Output：
/// Return：0或1
/// Others：w ##class(dhc.pa.udata.uSurveyScore).insert("234@r@3||16@7@201301@M@177^2^!178^7^!179^3^!180^^4!181^^7@1")
ClassMethod insert(data) As %String
{
	
	n (data)
	q:data="" "NoData"
	
	
	
	/*
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoUserId"
	*/
	k PLIST
	s schemDr=$p(data,"@",3)
	s unitDr=$p(data,"@",4)
	s userCode=$p(data,"@",8)
	q:userCode="" "NoUserCode"
	
	q:schemDr="" "NoSchem"
	q:unitDr="" "NoUnit"
	
	s SQLCODE=0
	s patDr=$p(data,"@",1)
	s patName=$p(data,"@",2)
	s period=$p(data,"@",5)
	s periodType=$p(data,"@",6)
	
	i patDr="" s patDr=1
	s KPIStrs=$p(data,"@",7)
	s len=$l(KPIStrs,"!")
	TSTART
	f i=1:1:len d
	.s score=""
	.s survey=$p(KPIStrs,"!",i)
	.s KPIDr=$p(survey,"^",1)
	.s disScore=$p(survey,"^",3)
	.s levelScore=$p(survey,"^",2)
	.i userCode'="" s PLIST(2)=userCode 
	.i patDr'="" s PLIST(17)=patDr 
	.i patName'="" s PLIST(18)=patName 
	.i schemDr'="" s PLIST(13)=schemDr 
	.i unitDr'=""  s PLIST(6)=unitDr 
	.i period'=""   s PLIST(11)=period
	.i periodType'=""  s PLIST(12)=periodType
	.i KPIDr'=""  s PLIST(8)=KPIDr
	.i disScore'="" s PLIST(10)=disScore
	.i levelScore="" s PLIST(9)=""
	.i levelScore'="" d
	..s PLIST(9)=levelScore
	..s score=..getScore(KPIDr,levelScore)
	..i score'="" d
    ...s PLIST(10)=score
	.s PLIST(7)="L"
	.s PLIST(14)="Y"
	.s PLIST(19)=$p($h,",",1)
	.s RowId=..IfRecord(period,periodType,userCode,unitDr,schemDr,KPIDr,patDr)	
	.i RowId'=0 d
	..s SQLCODE=1
	.e  d
	..&SQL(insert into dhc_pa_data.SurveyScore VALUES PLIST())
   	
    i SQLCODE'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2011-06-28
/// Description:指标权重计算
/// Table:
/// Input:
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uSurveyScore).CalAuditScoreMain("3||16",3,"01","M",102,1)
ClassMethod CalAuditScoreMain(schemDr, unitDr, period, periodType, locDr, scoreUserDr, cycleDr) As %String
{
 new (schemDr, unitDr,period,periodType,locDr,scoreUserDr,cycleDr)
 q:schemDr="" "NoSchemDr"
 q:unitDr="" "NounitDr"
 q:period="" "Noperiod"
 q:periodType="" "NoperiodType"
 q:locDr="" "NolocDr"
 q:scoreUserDr="" "NoscoreUserDr"
 q:cycleDr="" "Nocycle"
  i $d(^DHCCJXPACYCLE(cycleDr)) d
  .s cycleCode=$p($g(^DHCCJXPACYCLE(cycleDr)),"^",1)
  s period=cycleCode_period
  s type="L"
  s active="Y"
  set rootScore = 0
  &sql(select sum(score)/count(SurveyScore_patDr) into :rootScore from (SELECT Sum(SurveyScore_DirectScore*SchemDetail_rate/100) as score,SurveyScore_patDr FROM dhc_pa_data.SurveyScore INNER JOIN dhc_pa_data.SchemDetail ON SchemDetail_KPIDr = SurveyScore_KpiDr and SurveyScore_SchemDr = SchemDetail_parRef WHERE SurveyScore_AcceptUnitDr=:unitDr AND SurveyScore_SchemDr=:schemDr and SurveyScore_ScoreUserDr=:scoreUserDr and SurveyScore_period=:period and SurveyScore_periodType=:periodType group by SurveyScore_patDr))
  ;&sql(SELECT Sum(SurveyScore_DirectScore*SchemDetail_rate/100) into :rootScore FROM dhc_pa_data.SurveyScore INNER JOIN dhc_pa_data.SchemDetail ON SchemDetail_KPIDr = SurveyScore_KpiDr and SurveyScore_SchemDr = SchemDetail_parRef WHERE SurveyScore_AcceptUnitDr=:unitDr AND SurveyScore_SchemDr=:schemDr and SurveyScore_ScoreUserDr=:scoreUserDr and SurveyScore_period=:period and SurveyScore_periodType=:periodType group by SurveyScore_patDr)
 
  i $d(^DHCCJXPASURVEYSCORETOTAL(0,"PPAS",period,periodType,schemDr,unitDr,scoreUserDr)) d
  .s scoreTotalDr=0
  .s scoreTotalDr=$o(^DHCCJXPASURVEYSCORETOTAL(0,"PPAS",period,periodType,schemDr,unitDr,locDr,scoreTotalDr)) 
  .&sql(Update dhc_pa_data.SurveyScoreTotal set SurveyScoreTotal_TotalScore=:rootScore,SurveyScoreTotal_userDr=:scoreUserDr where SurveyScoreTotal_Rowid=:scoreTotalDr)
  e  d
  .&sql(Insert Into dhc_pa_data.SurveyScoreTotal (SurveyScoreTotal_AcceptUnitDr,SurveyScoreTotal_unitType,SurveyScoreTotal_ScoreDr,SurveyScoreTotal_TotalScore,SurveyScoreTotal_Active,SurveyScoreTotal_period,SurveyScoreTotal_periodType,SurveyScoreTotal_SchemDr,SurveyScoreTotal_userDr) values (:unitDr,:type,:locDr,:rootScore,:active,:period,:periodType,:schemDr,:scoreUserDr))
 
  q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2013-08-7
/// Description:指标权重计算
/// Table:
/// Input:
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uSurveyScore).CalDetailScoreMain("3||16",3,"01","M",3)
ClassMethod CalDetailScoreMain(schemDr, period, periodType, cycleDr) As %String
{

 new (schemDr,period,periodType,cycleDr)
 k ^TMPDHCJXPAUNITREUSLTDETAIL($j)
 q:schemDr="" "NoSchemDr"
 ;q:unitDr="" "NounitDr"
 q:period="" "Noperiod"
 q:periodType="" "NoperiodType"
 q:cycleDr="" "Nocycle"
  i $d(^DHCCJXPACYCLE(cycleDr)) d
  .s cycleCode=$p($g(^DHCCJXPACYCLE(cycleDr)),"^",1)
  s period=cycleCode_period
  s type="L"
  s active="Y"
  s SQLCODE=0
  TSTART
  set rootScore = 0
  s unitDr=0
  f  s unitDr=$o(^DHCCJXPASURVEYSCORE(0,"Repcord",period,periodType,unitDr)) q:unitDr=""  d
  .s userDr=0,userNum=0,userTatolScore=0,userScore=0
  .f  s userDr=$o(^DHCCJXPASURVEYSCORE(0,"Repcord",period,periodType,unitDr,schemDr,userDr)) q:userDr=""  d
  ..s patDr=0,patNume=0,patTatoScore=0,patScore=0
  ..f  s patDr=$o(^DHCCJXPASURVEYSCORE(0,"Repcord",period,periodType,unitDr,schemDr,userDr,patDr)) q:patDr=""  d
  ...;s patNume=patNume+1
  ...;s userNum=userNum+1
  ...s rowid=0,score=0,tmpscore=0,patName="",rate=100,detailInfo="",detailRowid=""
  ...f  s rowid=$o(^DHCCJXPASURVEYSCORE(0,"Repcord",period,periodType,unitDr,schemDr,userDr,patDr,rowid)) q:rowid=""  d
  ....i $d(^DHCCJXPASURVEYSCORE(rowid)) d
  .....s tmpscore=$p($g(^DHCCJXPASURVEYSCORE(rowid)),"^",8)
  .....s patName=$p($g(^DHCCJXPASURVEYSCORE(rowid)),"^",16)
  .....s KPIDr=$p($g(^DHCCJXPASURVEYSCORE(rowid)),"^",6)
  .....i KPIDr'="" d
  ......s detailInfo=..getRate(period,unitDr,schemDr,KPIDr)
  ......s rate=$p(detailInfo,"^",1)
  ......s detailRowid=$p(detailInfo,"^",2)
  .....s tmpscore=rate*tmpscore/100
  .....s score=score+tmpscore
  .....i detailRowid'="" d
  ......i $d(^TMPDHCJXPAUNITREUSLTDETAIL($j,detailRowid)) d
  .......s detailScore=..getAvgScore(period,periodType,unitDr,schemDr,KPIDr)
  .......&sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:detailScore,UnitResultDetail_actValue=:detailScore where UnitResultDetail_rowid=:detailRowid)
  ......s ^TMPDHCJXPAUNITREUSLTDETAIL($j,detailRowid)=1
  ....;s patTatoScore=patTatoScore+score
  ...;s patScore=patTatoScore/patNume
  ...i $d(^DHCCJXPASURVEYSCORETOTAL(0,"PPAS",period,periodType,schemDr,unitDr,userDr,patDr)) d
  ....s scoreTotalDr=0
  ....s scoreTotalDr=$o(^DHCCJXPASURVEYSCORETOTAL(0,"PPAS",period,periodType,schemDr,unitDr,userDr,patDr,scoreTotalDr))
  ....&sql(Update dhc_pa_data.SurveyScoreTotal set SurveyScoreTotal_TotalScore=:score,SurveyScoreTotal_patName=:patName where SurveyScoreTotal_Rowid=:scoreTotalDr)
  ...e  d
  ....&sql(Insert Into dhc_pa_data.SurveyScoreTotal (SurveyScoreTotal_AcceptUnitDr,SurveyScoreTotal_unitType,SurveyScoreTotal_ScoreDr,SurveyScoreTotal_TotalScore,SurveyScoreTotal_Active,SurveyScoreTotal_period,SurveyScoreTotal_periodType,SurveyScoreTotal_SchemDr,SurveyScoreTotal_userDr,SurveyScoreTotal_patDr,SurveyScoreTotal_patName) values (:unitDr,:type,:userDr,:score,:active,:period,:periodType,:schemDr,:userDr,:patDr,:patName)) 
  i SQLCODE'=0 d
  .TRollBack
  e  d
  .TCOMMIT
  
  k ^TMPDHCJXPAUNITREUSLTDETAIL($j)
  q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2013-08-20
/// Description: 查询等级id
/// Table: dhc_pa_data.KPILevel
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyScore).getLevelDr("183",5)
ClassMethod getLevelDr(KPIDr, score) As %String
{
	    n (KPIDr,score)
	   
	    q:KPIDr="" "NoKPIDr"
	    q:score="" "NoScore"
	    
	    s sqlStr="select * from dhc_pa_data.KPILevel,dhc_pa_data.KpiScoreType,dhc_pa_data.ScoreLevel where KPILvel_KPIDr=KpiScoreType_Rowid and KPILevel_LevelDr=ScoreLevel_Rowid"
	    i KPIDr'="" s sqlStr=sqlStr_" and KpiScoreType_KpiDr='"_KPIDr_"'"
	    i score'="" s sqlStr=sqlStr_" and ScoreLevel_Score='"_score_"'"
				
		s result=##class(%Library.ResultSet).%New()
		
		s rowid=""
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s rowid=result.Data("ScoreLevel_Rowid")
			
		}
	  
		d result.Close()
		q rowid
}

/// Creator: wang ying
/// CreatDate: 2014-04-11
/// Description: 查询等级id
/// Table: dhc_pa_data.UnitResultDetail
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyScore).getRate("201301",5,"1||32",175)
ClassMethod getRate(period, unitDr, schemDr, KPIDr) As %String
{
	    n (period,unitDr,schemDr,KPIDr)
	   
	    q:KPIDr="" "NoKPIDr"
	    q:period="" "Noperiod"
	    q:schemDr="" "NoschemDr"
	    q:unitDr="" "NounitDr"
	    
	    s sqlStr="select UnitResultDetail_rate,UnitResultDetail_rowid from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail where UnitResult_rowid=UnitResultDetail_parRef and UnitResultDetail_isTarget=2"
	    i KPIDr'="" s sqlStr=sqlStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	    i period'="" s sqlStr=sqlStr_" and UnitResult_period='"_period_"'"
	    i schemDr'="" s sqlStr=sqlStr_" and UnitResult_schemDr='"_schemDr_"'"
	    i unitDr'="" s sqlStr=sqlStr_" and UnitResult_jxUnitDr='"_unitDr_"'"

				
		s result=##class(%Library.ResultSet).%New()
		
		s rate=100,rowid=""
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s rate=result.Data("UnitResultDetail_rate")
			s rowid=result.Data("UnitResultDetail_rowid") 
		}
	  
		d result.Close()
		q rate_"^"_rowid
}

/// Creator: wang ying
/// CreatDate: 2014-04-11
/// Description: 查询等级id
/// Table: dhc_pa_data.UnitResultDetail
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyScore).getAvgScore("201301","M",5,"1||30",163)
ClassMethod getAvgScore(period, periodType, unitDr, schemDr, KPIDr) As %String
{
	    n (period,periodType,unitDr,schemDr,KPIDr)
	   
	    q:KPIDr="" "NoKPIDr"
	    q:period="" "Noperiod"
	    q:schemDr="" "NoschemDr"
	    q:unitDr="" "NounitDr"
	    q:periodType="" "NoperiodType"
	    
	    s sqlStr="select avg(SurveyScore_DirectScore) as score from dhc_pa_data.SurveyScore where %ID>0"
	    i KPIDr'="" s sqlStr=sqlStr_" and SurveyScore_KpiDr='"_KPIDr_"'"
	    i period'="" s sqlStr=sqlStr_" and SurveyScore_period='"_period_"'"
	    i schemDr'="" s sqlStr=sqlStr_" and SurveyScore_SchemDr='"_schemDr_"'"
	    i unitDr'="" s sqlStr=sqlStr_" and SurveyScore_AcceptUnitDr='"_unitDr_"'"
        i periodType'="" s sqlStr=sqlStr_" and SurveyScore_periodType='"_periodType_"'"
				
		s result=##class(%Library.ResultSet).%New()
		s score=0
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s score=result.Data("score")
		}
	  
		d result.Close()
		q score
}

/// Creator: wang ying
/// CreatDate: 2013-08-20
/// Description: 查询等级id
/// Table: dhc_pa_data.KPILevel
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyScore).getLevelDr("179",1)
ClassMethod getScore(KPIDr, levelDr) As %String
{
	    n (KPIDr,levelDr)
	   
	    q:KPIDr="" "NoKPIDr"
	    q:levelDr="" "NoScore"
	    
	    s sqlStr="select * from dhc_pa_data.KPILevel,dhc_pa_data.KpiScoreType,dhc_pa_data.ScoreLevel where KPILvel_KPIDr=KpiScoreType_Rowid and KPILevel_LevelDr=ScoreLevel_Rowid"
	    i KPIDr'="" s sqlStr=sqlStr_" and KpiScoreType_KpiDr='"_KPIDr_"'"
	    i levelDr'="" s sqlStr=sqlStr_" and ScoreLevel_Rowid='"_levelDr_"'"
				
		s result=##class(%Library.ResultSet).%New()
		
		s rowid=""
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s rowid=result.Data("ScoreLevel_Score")
			
		}
	  
		d result.Close()
		q rowid
}

/// Creator: wang ying
/// CreatDate: 2013-08-20
/// Description: 查询问卷打分明细
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyScore).ListRec("3||16","201301","M",1,23454,3)
ClassMethod ListRec(SchemDr, period, periodType, userDr, patDr, unitDr) As %String
{
		n (SchemDr,period,periodType,userDr,patDr,unitDr)
		q:SchemDr="" "NoSchem"
		q:period="" "NoPeriod"
		q:periodType="" "NoPeriodType"
		q:userDr="" "NoUserDr"
		q:patDr="" "NopatDr"
		q:unitDr="" "NounitDr"
		
		s curr=$p(SchemDr,"||",1)
		s sqlStr="select KpiScoreType_Rowid,SurveyScore_Rowid,SurveyScore_ScoreUserDr,SurveyScore_AcceptUnitDr,SurveyScore_KpiDr,SurveyScore_ScoreLevelDr,SurveyScore_DirectScore,SurveyScore_period,SurveyScore_periodType,SurveyScore_SchemDr,SurveyScore_Active,SurveyScore_desc,SurveyScore_submit,SurveyScore_patDr,SurveyScore_patName,SurveyScore_patDate,KpiScoreType_DirectScore,KpiScoreType_LevelScore from dhc_pa_data.KpiScoreType,dhc_pa_data.SurveyScore where SurveyScore_KpiDr=KpiScoreType_KpiDr"
		i SchemDr'="" s sqlStr=sqlStr_" and SurveyScore_SchemDr='"_SchemDr_"'"		
		i period'=""  s sqlStr=sqlStr_" and SurveyScore_period='"_period_"'"
		i periodType'="" s sqlStr=sqlStr_" and SurveyScore_periodType='"_periodType_"'"
		i userDr'="" s sqlStr=sqlStr_" and SurveyScore_ScoreUserDr='"_userDr_"'"
		i patDr'=""  s sqlStr=sqlStr_" and SurveyScore_patDr='"_patDr_"'"
		i unitDr'="" s sqlStr=sqlStr_" and SurveyScore_AcceptUnitDr='"_unitDr_"'"
		
		s result=##class(%Library.ResultSet).%New()

		s resultString="{""survey"""_":["
		s tmpString=""
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s KPIName="",directScore="",levelScore="",String="",levelString=""
			s rowid=result.Data("KpiScoreType_Rowid")
			s KpiDr = result.Data("SurveyScore_KpiDr")
			i KpiDr'="" d
			i $d(^DHCCJXPAKPIINDEX1(KpiDr)) d
			.s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KpiDr)),"^",2)
			
			s directScore=result.Data("KpiScoreType_DirectScore")
			s levelScore=result.Data("KpiScoreType_LevelScore")
			s score=result.Data("SurveyScore_DirectScore")
			
			i tmpString="" d
			.s tmpString=resultString_"{""KPIDr"":"_KpiDr_","_"""KPIName"""_":"""_KPIName_""","_"""score"""_":"_score_","_"""distScore"""_":"""_directScore_""","_"""levelScore"""_":"""_levelScore_""""
			e  d
			.s tmpString=tmpString_",{""KPIDr"":"_KpiDr_","_"""KPIName"""_":"""_KPIName_""","_"""score"""_":"_score_","_"""distScore"""_":"""_directScore_""","_"""levelScore"""_":"""_levelScore_""""

			i levelScore="Y" d
			.i $d(^DHCCJXPAKPILEVEL(0,"KPILevel",rowid)) d
			..s levelRowid=0
			..s String=",""Level"":["
			..f  s levelRowid=$o(^DHCCJXPAKPILEVEL(0,"KPILevel",rowid,levelRowid)) q:levelRowid=""  d
			...i $d(^DHCCJXPASCORELEVEL(levelRowid)) d
			....s levelName=$p($g(^DHCCJXPASCORELEVEL(levelRowid)),"^",3)
			....s scoreLevel=$p($g(^DHCCJXPASCORELEVEL(levelRowid)),"^",1)
			....s flag="N"
			....i scoreLevel=score s flag="Y"
			....i levelString="" s levelString=String_"{""levelDr"":"_levelRowid_","_"""levelName"":"_""""_levelName_""","_"""flag"":"_""""_flag_""","_"""score"":"_scoreLevel_"}"
			....e  s levelString=levelString_",{""levelDr"":"_levelRowid_","_"""levelName"":"_""""_levelName_""","_"""flag"":"_""""_flag_""","_"""score"":"_scoreLevel_"}"
			..s levelString=levelString_"]"
			i levelString="" s tmpString=tmpString_"}"
			e  s tmpString=tmpString_levelString_"}"
			
		}
	    s tmpString=tmpString_"]}"
		d result.Close()
		q tmpString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSurveyScoreS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
