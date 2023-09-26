/// Creator: wang ying
/// CreatDate: 2015-04-16
/// Description: 考评计算
Class dhc.pa.udata.uCalculatorNew Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2015-04-16
/// Description:指标分数计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculatorNew).ComputeKPIScore(1,4304,"201602","Q",100,1,1,3)
ClassMethod ComputeKPIScore(currStratagemDr, unitResultChildSub, period, PType, fullScore, isTop, ComMethodAudit, KPIMaxLevel) As %String
{
  	new (currStratagemDr,unitResultChildSub,period,PType,fullScore, isTop,ComMethodAudit,KPIMaxLevel)
  	;write ComMethodAudit,!

  	;w currStratagemDr_"^"_unitResultChildSub_"^"_period_"^"_PType_"^"_fullScore_"^"_isTop_"^"_ComMethodAudit,! 	 
  	TSTART	
  		
  	set URDSub=0
  	set ScoreValue  = 0  
   
  	Set MaxLevel=0
  	for  set URDSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)) q:URDSub=""  d
	.set ScoreValue  = 0
	.set Curr =""
	.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub))
	.;w Curr,!
	.if Curr'="" do 
	..set isTarget 	 = $P(Curr,"^",4) //判断是维度还是指标
	..;i isTarget=2 d
	..set KPIDr 	 = $P(Curr,"^",2) 
	..set baseValue	 = $P(Curr,"^",5)   //	基准值
	..set tValue	 = $P(Curr,"^",6)   //	目标值
	..set bValue	 = $P(Curr,"^",7)   //	最佳值
	..set tValueUp	 = $P(Curr,"^",8)   //	目标值上限
	..set bValueUp	 = $P(Curr,"^",9)   //	基准值上限
	..set rate		 = $P(Curr,"^",10)  //	权重
	..set actValue	 = $P(Curr,"^",11)  //	实际值
	..set KPIMethod	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
	..;w KPIDr,!
	..set KPIExtreMum= $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",9)   //获得极值
	..set mlevel 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",22) 
	..set mTAddRate 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",6)
	..set calculationDr 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",28)  //扣分法计算方式
	..if (mlevel> MaxLevel ) do
	...;//记录指标最大级别
	...set MaxLevel= mlevel  
	..;/// 'A':加分法\ 'D':扣分法 ------------------------------------
	..if (( KPIMethod ="A")||(KPIMethod ="D"))&&(isTarget=2)  do  //调用加、扣分法方法
	...s ScoreValue=..AddScoreMethod(currStratagemDr, unitResultChildSub, URDSub,KPIMethod,calculationDr,tValue,actValue,KPIExtreMum,rate)
 	..;///'M'目标参照法’ ---------------------------------------
	..if (KPIMethod ="M") && (tValue'=0)&&(tValue'="") do
	...set ScoreValue = actValue*fullScore/tValue   // 目标值/实际值
	...;"L" 趋低
	...if (KPIExtreMum="L") do 
	....set ScoreValue= 2*fullScore-ScoreValue
	..;//'I':区间法---------------------------------------------------------
	..if (KPIMethod ="I")&&(isTarget=2)  do
	...s ScoreValue=..DistMethod(currStratagemDr,unitResultChildSub, URDSub,KPIMethod,calculationDr,tValue,bValue,baseValue,actValue,KPIExtreMum,rate)
	..;//直接扣分处理 20140623  ["K",'实际值法']
	..if KPIMethod="K" do
	...set ScoreValue=actValue
	..if KPIMethod="MI" do
	...s ScoreValue=..MDistScore(currStratagemDr, unitResultChildSub, URDSub,KPIMethod,calculationDr,tValue,actValue,KPIExtreMum,rate)
	..;/// save score-----------------------------------------	
	..if (ScoreValue'="")  do
	...if (isTop=1) && (ScoreValue>fullScore) do  
	....set ScoreValue = fullScore   // 如果分数封顶，超过满分的为满分:scoreVlaue
	...if (ScoreValue<0)&&(KPIMethod'="K")&&(KPIMethod'="D")&&(calculationDr=3) do
	....set ScoreValue = 0
	...if ComMethodAudit=1 do  // add 2012-0-09 zxy 
	....;set ScoreValue=ScoreValue*rate/100
	...;w $P(Curr,"^",12),!
	...set $P(Curr,"^",12) = ScoreValue
	 
	...;if KPIMethod'="K" do
	...set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)=Curr
	..;//-----------------------------计算权重
	..;w currStratagemDr_"^"_unitResultChildSub_"^"_MaxLevel,!
	..if ComMethodAudit=0 do
	...d ##class(dhc.pa.udata.uCalculator).CalAuditScoreMain(currStratagemDr,unitResultChildSub,MaxLevel)
	..if ComMethodAudit=1 do // 权重，全表所有 add 2012-02-09  zxy
	...d ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreMinusLevel(currStratagemDr, unitResultChildSub,1,KPIMaxLevel)
		
	TCOMMIT
	
	q "true"
}

/// Creator:wang ying
/// CreatDate:2015-04-16
/// Description:加、减分法计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculatorNew).AddScoreMethod(1,4304,10,"D",4,0,"72.13","L","100")
ClassMethod AddScoreMethod(currStratagemDr, unitResultChildSub, URDSub, KPIMethod, calculationDr, tValue, actValue, KPIExtreMum, rate) As %Float
{
	
	n (currStratagemDr,unitResultChildSub,URDSub,KPIMethod,calculationDr,tValue,actValue,KPIExtreMum,rate)
	set URDAddSub=0
	;w currStratagemDr," UnitResultDetailAdd ",","_unitResultChildSub,","_URDSub,","_URDAddSub,!
	for  set URDAddSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub)) q:URDAddSub=""  d
	.;w "1="_currStratagemDr," UnitResultDetailAdd ",","_unitResultChildSub,","_URDSub,","_URDAddSub,!
	.set KPIAddRec=0
	.set ScoreValue=0
	.set addChangeValue=0
	.set addScore=0
	.set fm=1  
	.set KPIAddRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub))
	.if KPIAddRec'="" do
	..set addChangeValue  = $p(KPIAddRec,"^",2)   // 获得增减值
	..set addScore		 = $fn($p(KPIAddRec,"^",3),"",2)   // 获得增减分
	..set baseScore = $p(KPIAddRec,"^",4)         // 获得基础分
	..set baseValue = $p(KPIAddRec,"^",5)         //获得基础值
    ..i baseScore="" s baseScore=0
	..if (calculationDr=1) && (tValue '=0) && (addChangeValue'="") do 
	...set fm=(tValue/100)
	
	...if fm=0 set fm=1
	...;write "FM" = fm,!
	..else
	...set fm=1 
	..;write "calculationDr = ",calculationDr,"--kpi-",KPIDr, "--///",fm,“//”,addChangeValue,"//",addScore!
	..;///趋高趋低分别计算
	..if (KPIExtreMum="H") && (addChangeValue'=0) &&  (addChangeValue'="") do 
	...if ((actValue-tValue)>0) && (fm <0) do  
	....set fm= fm*-1
	...if baseValue'=""  set ScoreValue = (actValue-tValue-baseValue)*addScore/(addChangeValue*fm)
	...else  set ScoreValue = (actValue-tValue)*addScore/(addChangeValue*fm)
	...;w "ScoreValue="_actValue_"-"_tValue_"*"_addScore_"/"_addChangeValue_"*"_fm,!
	..if (KPIExtreMum="L") && (addChangeValue'=0 )&&(addChangeValue'="") do
	...if ((tValue-actValue)>0) && (fm <0) do  
	....set fm= fm*-1
	...if baseValue'=""  set ScoreValue = (baseValue+tValue-actValue)*addScore/(addChangeValue*fm)
 	...else  set ScoreValue = (tValue-actValue)*addScore/(addChangeValue*fm) 
 	..;write "123 = ",KPIDr,"-",KPIExtreMum,"-",ScoreValue, !
 	set mflag=1
 	;set baseScore=90
 	if KPIMethod ="D" do
 	.set mflag=-1
 	.;set baseScore=fullScore
 	set ScoreValue = baseScore + (ScoreValue*mflag)
 	;write "888 = ",ScoreValue, !
 	;if ((KPIMethod ="D")&&(KPIExtreMum="H")&&(actValue>tValue))||(( KPIMethod ="D")&&(KPIExtreMum="L")&&(actValue<tValue))||((KPIMethod="D")&&(ScoreValue<0))  do 
 	;.set ScoreValue=0
    i (ScoreValue<0)&&(calculationDr<3) d  ;增长率和增长量计算， 最低得分为0
    .s ScoreValue=0
    i (ScoreValue>0)&&(calculationDr>3) d  ;基础值上计算  最高得分为0
    .s ScoreValue=0
    q ScoreValue*100/rate                  ;rate 为指标权重
}

/// Creator:wang ying
/// CreatDate:2015-04-16
/// Description:区间法计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculatorNew).DistMethod(1,22,27,"I",1,"2.75","3.05","2.75","2.84","H","2.5")
ClassMethod DistMethod(currStratagemDr, unitResultChildSub, URDSub, KPIMethod, calculationDr, tValue, bValue, baseValue, actValue, KPIExtreMum, rate) As %Float
{
	
	n (currStratagemDr,unitResultChildSub,URDSub,KPIMethod,calculationDr,tValue,bValue,baseValue,actValue,KPIExtreMum,rate)
	
	set URDDistSub="",ScoreValue=0
	for  set URDDistSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub)) q:URDDistSub=""  d
	.set KPIDistRec=0
	.set KPIDistRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub))
	.quit:KPIDistRec=""   //记录为空返回
	.set valueLower = +$p(KPIDistRec,"^",2)
	.set valueUp	= +$p(KPIDistRec,"^",3)
	.set scoreLower = +$p(KPIDistRec,"^",4)
	.set scoreUp    = +$p(KPIDistRec,"^",5)  
	.set rangeDr    = +$p(KPIDistRec,"^",6)
	.i rangeDr=1  d
	..s valueLower=0,valueUp=baseValue
	.i rangeDr=2  d
	..s valueLower=baseValue
	..i (tValue="")||(tValue=0)  s valueUp=bValue
	..e  s valueUp=tValue
	.i rangeDr=3  d
	..i (tValue="")||(tValue=0) s valueLower=bValue,valueUp=bValue
	..e  s valueLower=tValue,valueUp=bValue
	.set valuePice  = valueUp - valueLower
	.set scorePice  = scoreUp - scoreLower
	.i rangeDr=4 s valueUp=bValue,valueLower=bValue
	.i scorePice=0 s scorePice=1
	.i valuePice=0 s valuePice=1
	.q:scorePice=0 // 分母=0 返回
	.set sRate = (scoreUp - scoreLower)/valuePice
	.set ScoreValue=0
	.;// 趋高H ----------------------
	.if (KPIExtreMum="H")  do
	..;write "HRate = ",sRate,!
	..;//区间法I 趋高H : 在区间2和3之间 
	..if (actValue>= valueLower) &&(actValue<=valueUp) do
	...set ScoreValue = scoreLower + ((actValue-valueLower)*sRate)
	...;write "IH = ",ScoreValue," sc=",scoreLower,"scp=",scoreUp," acvvl=",actValue,"valueLower=",valueLower,!
	..;//区间法I 趋高H :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	..;if (actValue < baseValue) && (rangeDr=1)&&(tValue-baseValue)'=0 do 
	..if (actValue < baseValue) && (rangeDr=1) d
	...i (tValue-baseValue)=0 set ScoreValue = scoreLower
	...e  set ScoreValue = scoreLower + ((actValue-valueLower)*scorePice/(tValue-baseValue)) 
	...if (ScoreValue < scoreLower) do 
	....set ScoreValue = scoreLower
	..;//区间法I 趋高H :在区间4, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	..;if (actValue > bValue) && (rangeDr=4) && (bValue-tValue)'=0 do 
	..if (actValue > bValue) && (rangeDr=4) d
	...i (tValue-baseValue)=0 set ScoreValue = scoreLower
	...e  set ScoreValue = scoreLower+((actValue-valueLower)*scorePice/(bValue-tValue))  
	...if ( ScoreValue > scoreUp) do 
	....set ScoreValue = scoreUp
	.;//趋中M--------------------------
	.if (KPIExtreMum="M") do 
	..;//区间法I 趋中M : 在区间2和3之间 
	..if (actValue >= valueLower) &&(actValue <= valueUp) do 
	...set ScoreValue = scoreLower +((actValue-valueLower)*sRate)
	..;//区间法I 趋中M :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	..if (actValue < bValueUp) && (rangeDr=1) && (baseValue-bValueUp)'=0 do 
	...set ScoreValue = scoreUp - ((bValueUp-actValue)*scorePice/(baseValue-bValueUp) )
	...if ( ScoreValue < scoreLower) do 
	....set ScoreValue = scoreLower
	..;//区间法I 趋中M :在区间6, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	..if (actValue > tValueUp) && (rangeDr=6) && (tValueUp-tValue)'=0 do 
	...set ScoreValue = scoreLower - ((tValueUp-actValue)*scorePice/(tValueUp-tValue)) 
	...if ( ScoreValue < scoreUp) do 
	....set ScoreValue = scoreUp
	.;//趋低L----------------- 
	.if (KPIExtreMum="L") do
	..;//区间法I 趋低L : 在区间2和3之间 
	..if (actValue <= valueLower) &&(actValue >= valueUp) do 
	...set ScoreValue = scoreLower + ((actValue-valueLower)*sRate)
	..;//区间法I 趋低L :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	..;if (actValue > baseValue) && (rangeDr=1) && (baseValue-tValue)'=0 do 
	..if (actValue > baseValue) && (rangeDr=1)  do
	...i (tValue-baseValue)=0 set ScoreValue = scoreLower
	...e  set ScoreValue = scoreLower + ((actValue-valueLower)*scorePice/(tValue-baseValue)) 
	...if ( ScoreValue < scoreLower) do 
	....set ScoreValue = scoreLower
	..;//区间法I 趋低L :在区间4, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	..;if (actValue < bValue) && (rangeDr=4) && (bValue-tValue)'=0 do 
	..if (actValue < bValue) && (rangeDr=4)  do
	...i (tValue-baseValue)=0 set ScoreValue = scoreLower
	...e  set ScoreValue = scoreLower +( (actValue-valueLower)*scorePice/(bValue-tValue)) 
	...if ( ScoreValue > scoreUp) do 
	....set ScoreValue = scoreUp
	i (ScoreValue<0)&&(calculationDr'=3) d
    .s ScoreValue=0
	q ScoreValue*100/rate
}

/// Creator:wang ying
/// CreatDate:2016-02-24
/// Description:多区间法计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculatorNew).MDistScore(1,2,26,"MI",1,"90",98.1,"H",100)
ClassMethod MDistScore(currStratagemDr, unitResultChildSub, URDSub, KPIMethod, calculationDr, tValue, actValue, KPIExtreMum, rate) As %Float
{
	
	n (currStratagemDr,unitResultChildSub,URDSub,KPIMethod,calculationDr,tValue,actValue,KPIExtreMum,rate)
	set URDAddSub=0,ScoreValue=0 
	;w currStratagemDr," UnitResultDetailAdd ",","_unitResultChildSub,","_URDSub,","_URDAddSub,!
	for  set URDAddSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub)) q:URDAddSub=""  d
	.;w "1="_currStratagemDr," UnitResultDetailAdd ",","_unitResultChildSub,","_URDSub,","_URDAddSub,!
	.set KPIAddRec=0
	.set ScoreValue=0
	.set addChangeValue=0
	.set addScore=0
	.if actValue<90 set ScoreValue=0
	.if actValue>=90  set ScoreValue=2 
	.if actValue>=92  set ScoreValue=ScoreValue+2  
	.if actValue>=94  set ScoreValue=ScoreValue+2 
	.if actValue>=96  set ScoreValue=ScoreValue+2 
	.if actValue>=98  set ScoreValue=ScoreValue+2 
	.if actValue>=99  set ScoreValue=ScoreValue+1 
    q ScoreValue*100/rate
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uCalculatorNewS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
