Class dhc.bonus.urbrvs.rvsTemplate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.urbrvs.rvsTemplate).List(0,10)
ClassMethod List(start, limit, template)
{
	n (start, limit,template)
	s ^gjtem1=start_","_limit
	;s sqlStr="SELECT rvsTemplateMainID,templateCode,templateName,useMinuteRate,techDifficultyRate,workCostRate,workRiskRate,tempDesc,createUser,createDate from dhc_bonus_rbrvs.rvsTemplateMain"
	s sqlStr="SELECT * FROM dhc_bonus_rbrvs.rvsTemplateMain"
	s whereStr=" WHERE %ID>0"
	s sqlStr=sqlStr_whereStr
	;w sqlStr
	;b ; 001
	s ^gjtem=sqlStr

	;w "begin....",!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	;s jsonTitle="rvsTemplateMainID^templateCode^templateName^useMinuteRate^workRiskRate^techDifficultyRate^workCostRate^tempDesc^createUser^createDate"
	s jsonTitle="rowid^templateCode^templateName^useMinuteRate^workRiskRate^techDifficultyRate^workCostRate^tempDesc^createUser^createDate"
	While(result.Next())
	{
		s rvsTemplateMainID    =result.Data("rvsTemplateMainID")
	    s templateCode         =result.Data("templateCode")
	    s templateName         =result.Data("templateName")
	    s useMinuteRate        =result.Data("useMinuteRate")
	    s workRiskRate         =result.Data("workRiskRate")
	    s techDifficultyRate   =result.Data("techDifficultyRate")
	    s workCostRate         =result.Data("workCostRate")
	    s tempDesc             =result.Data("tempDesc")
	    s createUser           =result.Data("createUser")
	    s createDate           =result.Data("createDate")
	    
	    
	    s tmp=rvsTemplateMainID_"^"_templateCode_"^"_templateName_"^"_useMinuteRate_"^"_workRiskRate_"^"_techDifficultyRate_"^"_workCostRate_"^"_tempDesc_"^"_createUser_"^"_createDate
	    
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
		
	    ;w "1111",!
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.urbrvs.rvsTemplate).IfRepCode(code)
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s sqlStr="SELECT * FROM dhc_bonus_rbrvs.rvsTemplateMain where templateCode'"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("rvsTemplateMainID")
	}
	q rowid
}

/// w ##class(dhc.bonus.urbrvs.rvsTemplate).Insert(data)
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).Insert("0003^ceshi^45^32^55^47^ceshi^demo^2016-05-09")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	
	k PLIST
	
	s Code=$p(data,"^",1)           
	s tmpDr=..IfRepCode(Code)
	q:tmpDr'=0 "1"     
	i Code'="" s PLIST(2)=Code
	
	s Name=$p(data,"^",2)
	i Name'="" s PLIST(3)=Name
	
	s MinuteRate=$p(data,"^",3)
	i MinuteRate'="" s PLIST(4)=MinuteRate
	
	s RiskRate=$p(data,"^",4)
	i RiskRate'="" s PLIST(5)=RiskRate
	
	s DifficultyRate=$p(data,"^",5)
	i DifficultyRate'="" s PLIST(6)=DifficultyRate
	
	s CostRate=$p(data,"^",6)
	i CostRate'="" s PLIST(7)=CostRate
	
	s tempDesc=$p(data,"^",7)
	i tempDesc'="" s PLIST(8)=tempDesc
	
	s createUser=$p(data,"^",8)
	i createUser'="" s PLIST(9)=createUser
	
	s createDate=$p(data,"^",9)	
	i createDate'="" d
	.;s createDate=$zdh(createDate,3)
	.;s createDate=$zd(createDate,3)
	.;s createDate=$zd($P($H,",",1),3)
	.s createDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	.s PLIST(10)=createDate
	;s createDate = $h
	;s PLIST(10)=createDate
	
	&SQL(INSERT INTO dhc_bonus_rbrvs.rvsTemplateMain VALUES PLIST())
	q SQLCODE
}

/// w ##class(dhc.bonus.urbrvs.rvsTemplate).Update()
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).Update(14,"0004^测试^35^66^17^88^测试^demo^2015-0512")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	k PLIST
	q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	s Code=$p(data,"^",1)           
	s tmpDr=..IfRepCode(Code)
	q:tmpDr'=0 "1"     
	i Code'="" s PLIST(2)=Code
	
	s Name=$p(data,"^",2)
	i Name'="" s PLIST(3)=Name
	
	s MinuteRate=$p(data,"^",3)
	i MinuteRate'="" s PLIST(4)=MinuteRate
	
	s RiskRate=$p(data,"^",4)
	i RiskRate'="" s PLIST(5)=RiskRate
	
	s DifficultyRate=$p(data,"^",5)
	i DifficultyRate'="" s PLIST(6)=DifficultyRate
	
	s CostRate=$p(data,"^",6)
	i CostRate'="" s PLIST(7)=CostRate
	
	s tempDesc=$p(data,"^",7)
	i tempDesc'="" s PLIST(8)=tempDesc
	
	s createUser=$p(data,"^",8)
	i createUser'="" s PLIST(9)=createUser
	
	s createDate=$p(data,"^",9)	
	i createDate'="" d
	.;s createDate=$zdh(createDate,3)
	.;s createDate=$zd(createDate,3)
	.;s createDate=$zd(64047,3)
	.s createDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	.s PLIST(10)=createDate
	;s createDate = $h
	;s PLIST(10)=createDate
	
	
	&SQL(UPDATE dhc_bonus_rbrvs.rvsTemplateMain VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

ClassMethod Del(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_bonus_rbrvs.rvsTemplateMain WHERE %ID=:rowid)
	k PLIST
	s PLIST(10)=0
	//&SQL(UPDATE dhc_bonus_rbrvs.rvsTemplateMain VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

ClassMethod DetailList(start, limit, template)
{
	n (start, limit,template)
	s ^gjtem1=start_","_limit
	;s sqlStr="SELECT * FROM  dhc_bonus_rbrvs.rvsTemplateDetail"
	s sqlStr="SELECT a.rvsTemplateDetailID,a.rvsTemplateMainID ,b.SubItemName AS BonusSubItemID,a.useMinuteValue ,a.workRiskValue,a.techDifficultyValue,a.workCostValue,a.makeRate,a.execRate,a.makeItemScore,a.execItemScore FROM dhc_bonus_rbrvs.rvsTemplateDetail a, dhc_bonus_subs.BonusSubItem b WHERE a.BonusSubItemID =b.BonusSubItemID"
	s whereStr=" and rvsTemplateMainID="_template
	s sqlStr=sqlStr_whereStr
	s ^gjtem=sqlStr

	;w "begin....",!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^rvsTemplateMainID^BonusSubItemID^useMinuteValue^workRiskValue^techDifficultyValue^workCostValue^makeRate^execRate^makeItemScore^execItemScore"
	
	While(result.Next())
	{
		s rvsTemplateDetailID    =result.Data("rvsTemplateDetailID")
	    s rvsTemplateMainID       =result.Data("rvsTemplateMainID")
	    s BonusSubItemID         =result.Data("BonusSubItemID")
	    s useMinuteValue        =result.Data("useMinuteValue")
	    i useMinuteValue="5" d
	    .s useMinuteValue="0-20分钟"
	    i useMinuteValue="4" d
	    .s useMinuteValue="20-40分钟"
	    i useMinuteValue="3" d
	    .s useMinuteValue="40-60分钟"
	    i useMinuteValue="2" d
	    .s useMinuteValue="60-90分钟"
	    i useMinuteValue="1" d
	    .s useMinuteValue="90分钟以上"
	    
	    s workRiskValue         =result.Data("workRiskValue")
	    i workRiskValue="6" d
	    .s workRiskValue="极高"
	    i workRiskValue="5" d
	    .s workRiskValue="较高"
	    i workRiskValue="4" d
	    .s workRiskValue="一般"
	    i workRiskValue="3" d
	    .s workRiskValue="极低"
	    i workRiskValue="2" d
	    .s workRiskValue="极低"
	     i workRiskValue="1" d
	    .s workRiskValue="无"
	    
	    s techDifficultyValue   =result.Data("techDifficultyValue")
	    i techDifficultyValue="6" d
	    .s techDifficultyValue="高难"
	    i techDifficultyValue="5" d
	    .s techDifficultyValue="较难"
	    i techDifficultyValue="4" d
	    .s techDifficultyValue="一般"
	    i techDifficultyValue="3" d
	    .s techDifficultyValue="低难"
	    i techDifficultyValue="2" d
	    .s techDifficultyValue="较易"
	    i techDifficultyValue="1" d
	    .s techDifficultyValue="无"
	    
	    s workCostValue         =result.Data("workCostValue")
	    i workCostValue="6" d
	    .s workCostValue="最高"
	    i workCostValue="5" d
	    .s workCostValue="较高"
	    i workCostValue="4" d
	    .s workCostValue="一般"
	    i workCostValue="3" d
	    .s workCostValue="较低"
	    i workCostValue="2" d
	    .s workCostValue="最低"
	    i workCostValue="1" d
	    .s workCostValue="无"
	     
	     s makeRate             =result.Data("makeRate")
	    i makeRate'="" d
	    .s makeRate=$fn(makeRate,"",2)
	    
	    s execRate            =result.Data("execRate")
	    i execRate'="" d
	    .s execRate=$fn(execRate,"",2)
	    
	    s makeItemScore             =result.Data("makeItemScore")
	    i makeItemScore'="" d
	    .s makeItemScore=$fn(makeItemScore,"",2)
	    
	    s execItemScore            =result.Data("execItemScore")
	    i execItemScore'="" d
	    .s execItemScore=$fn(execItemScore,"",2)

	    
	    s tmp=rvsTemplateDetailID_"^"_rvsTemplateMainID_"^"_BonusSubItemID_"^"_useMinuteValue_"^"_workRiskValue_"^"_techDifficultyValue_"^"_workCostValue_"^"_makeRate_"^"_execRate_"^"_makeItemScore_"^"_execItemScore
	    
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
		
	    ;w "1111",!
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.urbrvs.rvsTemplate).IfRepBSID(83,58371)
ClassMethod IfRepBSID(tmpSelectedTemplate, subsItemNameCombo) As %String
{
	n (tmpSelectedTemplate,subsItemNameCombo)
	s rowid=0	
	s sdr=0
	s udr=0
	s pre=0	
	f  s rowid=$o(^dhcbsrvsTemplateDetailD(rowid)) q:(rowid="")||((sdr=tmpSelectedTemplate)&&(udr=subsItemNameCombo))  d
	.s sdr=$list(^dhcbsrvsTemplateDetailD(rowid),2)
	.s udr=$list(^dhcbsrvsTemplateDetailD(rowid),7)
	.i ((sdr=tmpSelectedTemplate)&&(udr=subsItemNameCombo)) s pre=rowid
	.e  s pre=0
	q pre
}

/// w ##class(dhc.bonus.urbrvs.rvsTemplate).DetailInsert(data)
ClassMethod DetailInsert(data) As %String
{
	n (data)
	q:data="" "dataEmpt"      //准备插入的数据为空,退出并返回dataEmpt
	k PLIST
		
	s rvsTemplateMainID=$p(data,"^",1)             
	i rvsTemplateMainID'="" s PLIST(2)=rvsTemplateMainID
	
	s BonusSubItemID=$p(data,"^",2)
	s tmpDr=..IfRepBSID(rvsTemplateMainID,BonusSubItemID)
	q:tmpDr'=0 "1"
	i BonusSubItemID'="" s PLIST(3)=BonusSubItemID
	
	s useMinuteValue=$p(data,"^",3)
	i useMinuteValue'="" s PLIST(4)=useMinuteValue
	
	s workRiskValue=$p(data,"^",4)
	i workRiskValue'="" s PLIST(5)=workRiskValue
	
	s techDifficultyValue=$p(data,"^",5)
	i techDifficultyValue'="" s PLIST(6)=techDifficultyValue
	
	s workCostValue=$p(data,"^",6)
	i workCostValue'="" s PLIST(7)=workCostValue
	
	s makeRate=$p(data,"^",7)
	i makeRate'="" s PLIST(8)=makeRate
	
	s execRate=$p(data,"^",8)
	i execRate'="" s PLIST(9)=execRate
	
	s minuteRate=$p(data,"^",9)
	s riskRate=$p(data,"^",10)
	s difficultyRate=$p(data,"^",11)
	s costRate=$p(data,"^",12)
	
	s makeItemScore=(minuteRate*useMinuteValue+riskRate*workRiskValue+difficultyRate*techDifficultyValue+costRate*workCostValue)*makeRate
	i makeItemScore'="" s PLIST(10)=makeItemScore
	
	s execItemScore=(minuteRate*useMinuteValue+riskRate*workRiskValue+difficultyRate*techDifficultyValue+costRate*workCostValue)*execRate
	i execItemScore'="" s PLIST(11)=execItemScore

	
		
	&SQL(INSERT INTO dhc_bonus_rbrvs.rvsTemplateDetail VALUES PLIST())
	q SQLCODE
}

/// 8^14^0^0-20分钟^一般^一般^一般^1^1
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).DetailUpdate("981913^15^58375^2^4^4^4^4^9^8^9^10^11")
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).DetailUpdate("981842^14^5837^0-20分钟^4^4^4^4^9^^")
ClassMethod DetailUpdate(data) As %String
{
	n (data)
	
	k PLIST
	
	;q:rowid="" "EmptyRowid"
	q:data="" "EmptyData"
	
	s rvsTemplateDetailID=$p(data,"^",1)
	s:rvsTemplateDetailID'="" PLIST(1)=rvsTemplateDetailID
	
	s rvsTemplateMainID=$p(data,"^",2)             
	i rvsTemplateMainID'="" s PLIST(2)=rvsTemplateMainID
	
	s BonusSubItemID=$p(data,"^",3)
	i BonusSubItemID'="" d
	.s BonusSubItemID=$list(^dhcbsrvsTemplateDetailD(rvsTemplateDetailID),7)
	.s PLIST(3)=BonusSubItemID
	
	s useMinuteValue=$p(data,"^",4)
	i useMinuteValue="0-20分钟" d
	.s useMinuteValue="5"
	.s PLIST(4)=useMinuteValue
	i useMinuteValue="20-40分钟" d
	.s useMinuteValue="4"
	.s PLIST(4)=useMinuteValue
	i useMinuteValue="40-60分钟" d
	.s useMinuteValue="3"
	.s PLIST(4)=useMinuteValue
	i useMinuteValue="60-90分钟" d
	.s useMinuteValue="2"
	.s PLIST(4)=useMinuteValue
	i useMinuteValue="90分钟以上" d
	.s useMinuteValue="1"
	.s PLIST(4)=useMinuteValue
	e  d
	s PLIST(4)=useMinuteValue
	;i useMinuteValue'="" s PLIST(4)=useMinuteValue
	
	s workRiskValue=$p(data,"^",5)
	i workRiskValue="极高" d
	.s workRiskValue="6"
	.s PLIST(5)=workRiskValue
	i workRiskValue="较高" d
	.s workRiskValue="5"
	.s PLIST(5)=workRiskValue
	i workRiskValue="一般" d
	.s workRiskValue="4"
	.s PLIST(5)=workRiskValue
	i workRiskValue="较低" d
	.s workRiskValue="3"
	.s PLIST(5)=workRiskValue
	i workRiskValue="极低" d
	.s workRiskValue="2"
	.s PLIST(5)=workRiskValue
	i workRiskValue="无" d
	.s workRiskValue="1"
	.s PLIST(5)=workRiskValue
	e  d
	.s PLIST(5)=workRiskValue
	;i workRiskValue'="" s PLIST(5)=workRiskValue
	
	s techDifficultyValue=$p(data,"^",6)
	i techDifficultyValue="高难" d
	.s techDifficultyValue="6"
	. s PLIST(6)=techDifficultyValue
	i techDifficultyValue="较难" d
	.s techDifficultyValue="5"
	. s PLIST(6)=techDifficultyValue
	i techDifficultyValue="一般" d
	.s techDifficultyValue="4"
	. s PLIST(6)=techDifficultyValue
	i techDifficultyValue="低难" d
	.s techDifficultyValue="3"
	. s PLIST(6)=techDifficultyValue
	i techDifficultyValue="较易" d
	.s techDifficultyValue="2"
	. s PLIST(6)=techDifficultyValue
	i techDifficultyValue="无" d
	.s techDifficultyValue="1"
	. s PLIST(6)=techDifficultyValue
	e  d
	.s PLIST(6)=techDifficultyValue
	;i techDifficultyValue'="" s PLIST(6)=techDifficultyValue
	
	s workCostValue=$p(data,"^",7)
	i workCostValue="最高" d
	.s workCostValue="6"
	.s PLIST(7)=workCostValue
	i workCostValue="较高" d
	.s workCostValue="5"
	.s PLIST(7)=workCostValue
	i workCostValue="一般" d
	.s workCostValue="4"
	.s PLIST(7)=workCostValue
	i workCostValue="较低" d
	.s workCostValue="3"
	.s PLIST(7)=workCostValue
	i workCostValue="最低" d
	.s workCostValue="2"
	.s PLIST(7)=workCostValue
	i workCostValue="无" d
	.s workCostValue="1"
	.s PLIST(7)=workCostValue
	e  d
	.s PLIST(7)=workCostValue
	;i workCostValue'="" s PLIST(7)=workCostValue
	
	s makeRate=$p(data,"^",8)
	i makeRate'="" s PLIST(8)=makeRate
	
	s execRate=$p(data,"^",9)
	i execRate'="" s PLIST(9)=execRate
	
	s minuteRate=$p(data,"^",10)
	s riskRate=$p(data,"^",11)
	s difficultyRate=$p(data,"^",12)
	s costRate=$p(data,"^",13)
	
	s makeItemScore=(minuteRate*useMinuteValue+riskRate*workRiskValue+difficultyRate*techDifficultyValue+costRate*workCostValue)*makeRate
	i makeItemScore'="" s PLIST(10)=makeItemScore
	
	s execItemScore=(minuteRate*useMinuteValue+riskRate*workRiskValue+difficultyRate*techDifficultyValue+costRate*workCostValue)*execRate
	i execItemScore'="" s PLIST(11)=execItemScore

	
	
	//&SQL(UPDATE dhc_bonus_rbrvs.rvsTemplateDetail VALUES PLIST() where rvsTemplateDetailID=:rowid)
	&SQL(UPDATE dhc_bonus_rbrvs.rvsTemplateDetail VALUES PLIST() where %ID=:rvsTemplateDetailID)
	q SQLCODE
}

/// 删除明细
ClassMethod DetailDel(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_bonus_rbrvs.rvsTemplateDetail WHERE %ID=:rowid)
	k PLIST
	s PLIST(11)=0
	
	q SQLCODE
}

/// 复制
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).DetailCopy("14^11^11^11^11^11^11^11^11")
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).DetailCopy("")
ClassMethod DetailCopy(data) As %String
{
	n (data)
	s TemplateMainID=$p(data,"^",1)
	&SQL(INSERT INTO dhc_bonus_rbrvs.rvsTemplateMain(
    templateCode,templateName,useMinuteRate,workRiskRate,techDifficultyRate,workCostRate,tempDesc,createUser,createDate )
    SELECT templateCode _ '_FZ', templateName, useMinuteRate ,workRiskRate, techDifficultyRate ,workCostRate, tempDesc, createUser,getdate() createDate  
    FROM dhc_bonus_rbrvs.rvsTemplateMain
    WHERE rvsTemplateMainID=:TemplateMainID)
    
    s rowID2=%ROWID
    &SQL(INSERT INTO dhc_bonus_rbrvs.rvsTemplateDetail(
     rvsTemplateMainID,BonusSubItemID,useMinuteValue,workRiskValue,techDifficultyValue,workCostValue,makeRate,execRate,makeItemScore,execItemScore)
    SELECT :rowID2 rvsTemplateMainID, BonusSubItemID,useMinuteValue,workRiskValue, techDifficultyValue, workCostValue, makeRate, execRate, makeItemScore, execItemScore 
    FROM dhc_bonus_rbrvs.rvsTemplateDetail
    WHERE rvsTemplateMainID =:TemplateMainID)
    
	q SQLCODE
}

/// 获取RVRVS项目编码
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).GetSubsItemCode("0","10")
/// w ##class(dhc.bonus.urbrvs.rvsTemplate).GetSubsItemCode()
ClassMethod GetSubsItemName(start, limit)
{
	n (start, limit)
	;s ^gjtem1=start_","_limit
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="SELECT BonusSubItemID,SubItemName FROM dhc_bonus_subs.BonusSubItem"
	s whereStr=" WHERE %ID>0"
	s sqlStr=sqlStr_whereStr
	;w sqlStr
	;b ; 001
	;s ^gjtem=sqlStr

	;w "begin....",!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="BonusSubItemID^SubItemName"
	While(result.Next())
	{
		s BonusSubItemID    =result.Data("BonusSubItemID")
	    s SubItemName       =result.Data("SubItemName")
	    s tmp=BonusSubItemID_"^"_SubItemName
	    s count=count+1
	    i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
		
	    ;w "1111",!
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.urbrvs.rvsTemplateS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
