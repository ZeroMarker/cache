Class dhc.pa.udata.test Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property arrayKPIMax As %List;

/// w ##class(dhc.pa.udata.test).ComputeKPIScore(1,1,"201002","Q",100,1)
/// , unitResultChildSub
ClassMethod ComputeKPIScore(currStratagemDr, unitResultChildSub, period, PType, fullScore, isTop)
{
  	 TSTART	
  	 
  		new (currStratagemDr,unitResultChildSub,period,PType,fullScore, isTop)
  		 
	    ....;//if maxActValue'=0 do 
		.....;//set ScoreValue = fullScore*actValue/maxActValue
		...;//if (KPIExtreMum="L") do 
		....;//set minActValue=0
		....;//&sql(SELECT  min(l.UnitResultDetail_actValue ) into :minActValue	FROM dhc_pa_data.UnitResult m,dhc_pa_data.UnitResultDetail l where UnitResult_childSub>0 and m.UnitResult_rowid=l.UnitResultDetail_parRef and l.UnitResultDetail_KPIDr=:KPIDr and  m.UnitResult_period=:period and m.UnitResult_schemDr->Schem_frequency=:PType and UnitResult_parRef=:currStratagemDr)
		....;//write "CCC-f-m-a2-",fullScore,"-",minActValue,"-",actValue,!
	
  	    set URDSub=0
  	    set ScoreValue  = 0  
  	    Set MaxLevel=0
  		for  set URDSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)) q:URDSub=""  d
		. set ScoreValue  = 0
		.set Curr =""
		.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub))
		.if Curr'="" do 
		..set KPIDr 	 = $P(Curr,"^",2) 
		..set baseValue	 = $P(Curr,"^",5)   //	基准值
		..set tValue	 = $P(Curr,"^",6)   //	目标值
		..set bValue	 = $P(Curr,"^",7)   //	最佳值
		..set tValueUp	 = $P(Curr,"^",8)   //	目标值上限
		..set bValueUp	 = $P(Curr,"^",9)   //	基准值上限
		..set rate		 = $P(Curr,"^",10)  //	权重
		..set actValue	 = $P(Curr,"^",11)  //	实际值
	   	..set KPIMethod	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
		..set KPIExtreMum= $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",9)   //获得极值
		..set mlevel 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",22) 
		..if (mlevel> MaxLevel ) do
		...set MaxLevel= mlevel  //记录指标最大级别
		
		..;/// 'A':加分法\ 'D':扣分法 ------------------------------------
		..if ( KPIMethod ="A")||(KPIMethod ="D")  do
		...set URDAddSub=""
		...for  set URDAddSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub)) q:URDAddSub=""  d
	   
	    ....set KPIAddRec=0
		....set KPIAddRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub))
	    ....if KPIAddRec'="" do
	    .....set addChangeValue  = $p(KPIAddRec,"^",2)   // 获得增减值
	    .....set addScore		 = $p(KPIAddRec,"^",3)   // 获得增减分
	    .....;///趋高趋低分别计算
	 	.....if (KPIExtreMum="H") && (addChangeValue'=0) do 
	 	......set ScoreValue = (actValue-tValue)*addScore/addChangeValue 
	    .....if (KPIExtreMum="L") && (addChangeValue'=0 ) do
 		......set ScoreValue = (tValue-actValue)*addScore/addChangeValue 

 		...if KPIMethod ="D" do 
 		....set ScoreValue = fullScore + ScoreValue 
 		
 		...if ((KPIMethod ="D") && (KPIExtreMum="H")&& (actValue>tValue))|| (( KPIMethod ="D") && (KPIExtreMum="L") && (actValue<tValue )) ||(( KPIMethod ="D") && (ScoreValue<0) )  do 
 		....set ScoreValue=0 
 			
 		..;///'M'目标参照法’ ---------------------------------------
		..if (KPIMethod ="M") && (tValue'=0) do 
	    ...set ScoreValue = actValue*fullScore/tValue   // 目标值/实际值
	    ...if (KPIExtreMum="L") do 
	    ....set ScoreValue= 2*fullScore-ScoreValue
	    
		..;//'I':区间法---------------------------------------------------------
		..if (KPIMethod ="I")  do
		...set URDDistSub=""
		...for  set URDDistSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub)) q:URDDistSub=""  d
	    ....set KPIDistRec=0
		....set KPIDistRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub))
	    ....quit:KPIDistRec=""   //记录为空返回
	    ....set valueLower = $p(KPIDistRec,"^",2)
	    ....set valueUp	   = $p(KPIDistRec,"^",3)
	    ....set scoreLower = $p(KPIDistRec,"^",4)
	    ....set scoreUp    = $p(KPIDistRec,"^",5)  
	    ....set rangeDr    = $p(KPIDistRec,"^",6)
	    ....set valuePice  = valueUp - valueLower
	    ....set scorePice  = scoreUp - scoreLower
	    ....q:valuePice=0  // 分母=0 返回
	    ....set sRate = (scoreUp - scoreLower)/valuePice
	   
	    ....;// 趋高H ----------------------
		....if (KPIExtreMum="H")  do
		.....write "HRate = ",sRate,!
		.....;//区间法I 趋高H : 在区间2和3之间 
		.....if (actValue>= valueLower) &&(actValue<=valueUp) do 
		......set ScoreValue = scoreLower + ((actValue-valueLower)*sRate)
		......write "IH = ",ScoreValue," sc-",scoreLower,"-",scoreUp," acv-vl",actValue,"-",valueLower,!
		.....;//区间法I 趋高H :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
		.....if (actValue < baseValue) && (rangeDr=1)&&(tValue-baseValue)'=0 do 
		......set ScoreValue = scoreLower + ((actValue-valueLower)*scorePice/(tValue-baseValue)) 
		......if (ScoreValue < scoreLower) do 
		.......set ScoreValue = scoreLower
		.....;//区间法I 趋高H :在区间4, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
		.....if (actValue > bValue) && (rangeDr=4) && (bValue-tValue)'=0 do 
		......set ScoreValue = (actValue-valueLower)*scorePice/(bValue-tValue)  
		......if ( ScoreValue > scoreUp) do 
		.......set ScoreValue = scoreUp
		....;//趋中M--------------------------
		....if (KPIExtreMum="M") do 
		.....;//区间法I 趋中M : 在区间2和3之间 
		.....if (actValue >= valueLower) &&(actValue <= valueUp) do 
		......set ScoreValue = scoreLower + ((actValue-valueLower)*sRate)
		.....;//区间法I 趋中M :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
		.....if (actValue < bValueUp) && (rangeDr=1) && (baseValue-bValueUp)'=0 do 
		......set ScoreValue = scoreUp - ((bValueUp-actValue)*scorePice/(baseValue-bValueUp) )
		......if ( ScoreValue < scoreLower) do 
		.......set ScoreValue = scoreLower
		.....;//区间法I 趋中M :在区间6, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
		.....if (actValue > tValueUp) && (rangeDr=6) && (tValueUp-tValue)'=0 do 
		......set ScoreValue = scoreLower - ((tValueUp-actValue)*scorePice/(tValueUp-tValue)) 
		......if ( ScoreValue < scoreUp) do 
		.......set ScoreValue = scoreUp
		....;//趋低L----------------- 
		....if (KPIExtreMum="L") do 
		.....;//区间法I 趋低L : 在区间2和3之间 
		.....if (actValue <= valueLower) &&(actValue >= valueUp) do 
		......set ScoreValue = scoreLower + ((actValue-valueLower)*sRate)
		.....;//区间法I 趋低L :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
		.....if (actValue > baseValue) && (rangeDr=1) && (baseValue-tValue)'=0 do 
		......set ScoreValue = scoreLower + ((actValue-valueLower)*scorePice/(tValue-baseValue)) 
		......if ( ScoreValue < scoreLower) do 
		.......set ScoreValue = scoreLower
		.....;//区间法I 趋低L :在区间4, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
		.....if (actValue < bValue) && (rangeDr=4) && (bValue-tValue)'=0 do 
		......set ScoreValue = scoreLower +( (actValue-valueLower)*scorePice/(bValue-tValue)) 
		......if ( ScoreValue > scoreUp) do 
		.......set ScoreValue = scoreUp
		
		
		..;//'C':比较法  暂时不用 由于计算最大值、最小值出现耗资源太多----------------------
		..if (KPIMethod ="Not C") do
		..
		...if (KPIExtreMum="H") do 
		....set maxActValue=0
		....write "CCC-f-m-a1-",fullScore,"-",maxActValue,"-",actValue,!
		....&sql(SELECT  max(l.UnitResultDetail_actValue ) into :maxActValue	FROM dhc_pa_data.UnitResult m,dhc_pa_data.UnitResultDetail l where UnitResult_childSub>0 and m.UnitResult_rowid=l.UnitResultDetail_parRef and l.UnitResultDetail_KPIDr=:KPIDr and  m.UnitResult_period=:period and m.UnitResult_schemDr->Schem_frequency=:PType and UnitResult_parRef=:currStratagemDr)
	    ....if maxActValue'=0 do 
		.....set ScoreValue = fullScore*actValue/maxActValue
		...if (KPIExtreMum="L") do 
		....set minActValue=0
		....&sql(SELECT  min(l.UnitResultDetail_actValue ) into :minActValue	FROM dhc_pa_data.UnitResult m,dhc_pa_data.UnitResultDetail l where UnitResult_childSub>0 and m.UnitResult_rowid=l.UnitResultDetail_parRef and l.UnitResultDetail_KPIDr=:KPIDr and  m.UnitResult_period=:period and m.UnitResult_schemDr->Schem_frequency=:PType and UnitResult_parRef=:currStratagemDr)
		....write "CCC-f-m-a2-",fullScore,"-",minActValue,"-",actValue,!
		....if (actValue'=0) do 
		.....set ScoreValue = fullScore*minActValue/actValue
		
	
	    ..;/// save score-----------------------------------------	
	    ..if (ScoreValue'="")  do
	    ...if (isTop=1) && (ScoreValue>fullScore) do  
		....set ScoreValue = fullScore   // 如果分数封顶，超过满分的为满分:scoreVlaue
		...set unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_URDSub 
		...Set URDetail = ##class(dhc.pa.data.UnitResultDetail).%OpenId(unitResultDetailRowid)
		...set URDetail.UnitResultDetailscore= $num(ScoreValue,2)
		...set dd=URDetail.%Save()	
		
		;//-----------------------------计算权重
	//	&sql(SELECT  max(l.UnitResultDetail_KPIDr->KPIIndex1_level ) into :MaxLevel	FROM dhc_pa_data.UnitResultDetail l where UnitResult_childSub>0 and m.UnitResult_rowid=l.UnitResultDetail_parRef  and UnitResult_parRef=:currStratagemDr)
	
	
	
	
		
	TCOMMIT
}

/// w ##class(dhc.pa.udata.test).CalAuditScoreMain(1,1,2)
ClassMethod CalAuditScoreMain(currStratagemDr, unitResultChildSub, MaxLevel)
{
 new (currStratagemDr,unitResultChildSub,MaxLevel)
 set curLevel=MaxLevel+1
 set unitResulRowid=currStratagemDr_"||"_unitResultChildSub	
 for  set curLevel = curLevel-1  q:curLevel=0  do
  .;write "curLevel-", curLevel,!
  .d ..CalAuditScore(currStratagemDr,unitResultChildSub,curLevel)
  
 
 set rootScore = 0
 &sql(select sum(UnitResultDetail_rate*UnitResultDetail_score)  into :rootScore from dhc_pa_data.UnitResultDetail where UnitResultDetail_parRef = :unitResulRowid  and  UnitResultDetail_isTarget= 1 )
 &sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:rootScore where UnitResultDetail_parRef = :unitResulRowid  and  UnitResultDetail_isTarget= 0 )
}

ClassMethod CalAuditScore(currStratagemDr, unitResultChildSub, curLevel)
{
 new (currStratagemDr,unitResultChildSub,curLevel)
 set unitResulRowid=currStratagemDr_"||"_unitResultChildSub

 set strSQL ="SELECT UnitResultDetail_parRef,  UnitResultDetail_KPIDr->KPIIndex1_level, "
 set strSQL = strSQL_" UnitResultDetail_isTarget, UnitResultDetail_rate,UnitResultDetail_score , UnitResultDetail_parent "
 set strSQL = strSQL_" FROM dhc_pa_data.UnitResultDetail "
 set strSQL = strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulRowid_"'"
 set strSQL = strSQL_" and  UnitResultDetail_KPIDr->KPIIndex1_level="_curLevel 
 set strSQL = strSQL_" and UnitResultDetail_isTarget=2 "
 set strSQL = strSQL_" order by UnitResultDetail_parent "
 set result=##class(%Library.ResultSet).%New()

 do result.Prepare(strSQL)
 do result.Execute()
 set parentID = 0  
 set RScore   = 0
 set num=0
 
 if curLevel>1 {
  set TarLevel=2
 }
 else {		
  set TarLevel=1
 }

 While(result.Next()){
	 if num=0 
	 { 
	 	set parentID = result.Data("UnitResultDetail_parent")
	 	set num = 1 
	 }
	 
	if parentID =result.Data("UnitResultDetail_parent") 
	{
		
		set rate  = result.Data("UnitResultDetail_rate")
		set score = result.Data("UnitResultDetail_score")
		set RScore = RScore + (rate*score)
		
		
	}
	else 
	{
		
		&sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:RScore  where UnitResultDetail_parRef = :unitResulRowid  and UnitResultDetail_KPIDr =:parentID and  UnitResultDetail_isTarget= :TarLevel )
		
		set parentID = result.Data("UnitResultDetail_parent")
		set RScore   = (rate*score)
			
	}
	
 }
 &sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:RScore  where UnitResultDetail_parRef = :unitResulRowid  and UnitResultDetail_KPIDr =:parentID and  UnitResultDetail_isTarget= :TarLevel )

 do result.Close()
}

ClassMethod p6()
{



	// clear ^Data in case it has data
	Kill ^Data
	// fill in ^Data with sample data
	For i = 1:1:100 {
	// Set each node to a random person's name
	Set ^Data(i) =  ##class(%PopulateUtils).Name()
	}
	// loop over every node
	// Find first node
	Set key = $Order(^Data(""))
	While (key '= "") {
	// Write out contents
	Write "#", key, " ", ^Data(key),!
	// Find next node
	Set key = $Order(^Data(key))
	}
}

ClassMethod GetDept(start, limit, schemDr) As %String
{
	n (start, limit, schemDr)
	;// 计算最大值最小值
	// ....&sql(SELECT l.UnitResultDetail_KPIDr, max(l.UnitResultDetail_actValue ) into :maxActValue	
 	//	 FROM dhc_pa_data.UnitResult m,dhc_pa_data.UnitResultDetail l 
 	////	 where UnitResult_childSub>0 and m.UnitResult_rowid=l.UnitResultDetail_parRef 
 	//	 and  m.UnitResult_period=:period 
 	//	 and m.UnitResult_schemDr->Schem_frequency=:PType 
 	//	 and UnitResult_parRef=:currStratagemDr 
 	//	 and l.UnitResultDetail_KPIDr->KPIIndex1_extreMum="H"
 	//	 and l.UnitResultDetail_KPIDr->KPIIndex1_extreMum="C"
 	//	 group by l.UnitResultDetail_KPIDr )
}

//w ##class(dhc.pa.udata.test).InsertDistParaMain(1)

ClassMethod InsertDistParaMain(currStratagemDr)
{
 new (currStratagemDr)
 set unitResultChildSub=""	
 for  set unitResultChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub)) q:unitResultChildSub=""  d
 .set Curr =""
 .set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub))
 .if Curr'="" do ..InsertDistPara(currStratagemDr,unitResultChildSub)
}

//w ##class(dhc.pa.udata.test).InsertDistPara(1,1)

ClassMethod InsertDistPara(currStratagemDr, unitResultChildSub)
{
		new (currStratagemDr,unitResultChildSub)
  	   set URDSub=""
  		for  set URDSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)) q:URDSub=""  d
		.set Curr =""
		.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub))
		.if Curr'="" do 
		..set KPIDr 	 = $P(Curr,"^",2) 
		..set baseValue	 = $P(Curr,"^",5)   //	基准值
		..set tValue	 = $P(Curr,"^",6)   //	目标值
		..set bValue	 = $P(Curr,"^",7)   //	最佳值
		..set tValueUp	 = $P(Curr,"^",8)   //	目标值上限
		..set bValueUp	 = $P(Curr,"^",9)   //	基准值上限
	    ..set KPIMethod	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
		..set KPIExtreMum= $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",9)   //获得极值
		..set unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_URDSub 
		..;//'I':区间法---------------------------------------------------------
		..if (KPIMethod ="I")  do
		...;//趋中M--------------------------
		...if (KPIExtreMum="H")  do
		....set OrderNo=0
		....for  set OrderNo=OrderNo+1 q:OrderNo>4  do 
		.....set valueLower = 0
		.....set valueUp    = 0
		.....Write "1-", KPIDr,"-OrdNO-",OrderNo, "-",baseValue,"-",tValue,"-",bValue,"jz-",KPIExtreMum,"-id-",URDSub,!
		.....if (OrderNo = 1) do
		......set valueLower = 0
		......set valueUp    = baseValue 
		.....if (OrderNo = 2) do
		......set valueLower = baseValue
		......set valueUp    = tValue
		......Write "3-", KPIDr,"-valueLower-",valueLower, ";valueUp-",valueUp,!
		.....if (OrderNo = 3) do
		......set valueLower = tValue
		......set valueUp    = bValue  
		.....if (OrderNo = 4) do
		......set valueLower = bValue
		......set valueUp    = 0
		.....&sql(Update dhc_pa_data.URDetailDist set URDetailDist_valueLower= :valueLower,URDetailDist_valueUp= :valueUp  where URDetailDist_parRef = :unitResultDetailRowid  and URDetailDist_order =:OrderNo )
	
	
		...;//趋中M--------------------------
		...if (KPIExtreMum="M") do 
		....set OrderNo=0
		....for  set OrderNo=OrderNo+1 q:OrderNo>6  do 
		.....set valueLower = 0
		.....set valueUp    = 0
		.....if (OrderNo=1) do
		......set valueLower = 0
		......set valueUp    = baseValue 
		.....if (OrderNo=2) do
		......set valueLower = baseValue
		......set valueUp    = tValue 
		.....if (OrderNo=3) do
		......set valueLower = tValue
		......set valueUp    = bValue
		.....if (OrderNo=4) do
		......set valueLower = bValue
		......set valueUp    = tValueUp  
		.....if (OrderNo=5) do
		......set valueLower = tValueUp
		......set valueUp    = bValueUp
		.....if (OrderNo=6) do
		......set valueLower = bValueUp
		......set valueUp    = 0
	
		.....&sql(Update dhc_pa_data.URDetailDist set  URDetailDist_valueLower= :valueLower,URDetailDist_valueUp= :valueUp  where URDetailDist_parRef = :unitResultDetailRowid  and URDetailDist_order =:OrderNo )

		
		...;//趋低L----------------- 
		...if (KPIExtreMum="L") do 
		....set OrderNo=0
		....for  set OrderNo=OrderNo+1 q:OrderNo>4  do 
		.....set valueLower = 0
		.....set valueUp    = 0 
		.....if (OrderNo=1) do
		......set valueLower = 0
		......set valueUp    = bValue 
		.....if (OrderNo=2) do
		......set valueLower = bValue
		......set valueUp    = tValue
		.....if (OrderNo=3) do
		......set valueLower = tValue
		......set valueUp    = baseValue  
		.....if (OrderNo=4) do
		......set valueLower = baseValue
		......set valueUp    = 0
		.....&sql(Update dhc_pa_data.URDetailDist set  URDetailDist_valueLower= :valueLower,URDetailDist_valueUp= :valueUp  where URDetailDist_parRef = :unitResultDetailRowid  and URDetailDist_order =:OrderNo )
}

Storage Default
{
<Data name="testState">
<Value name="1">
<Value>arrayKPIMax</Value>
</Value>
</Data>
<State>testState</State>
<StreamLocation>^dhc.pa.udata.testS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
