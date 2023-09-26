Class dhc.pa.udata.uSchemDetailDist Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-08-12
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.SchemDetailDist
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSchem).ListRec("","","","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, schemDetail, trend) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit,schemDetail,trend)
		
		
		s sqlStr="SELECT SchemDetailDist_rowid,SchemDetailDist_parRef,SchemDetailDist_rangeDr,SchemDetailDist_scoreUp,SchemDetailDist_scoreLower FROM dhc_pa_data.SchemDetailDist WHERE SchemDetailDist_childSub>0 and Schem_parRef="_schemDetail
	
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="SchemDetailDist_parRef"
		.i sortField="parRef" s sortField1="SchemDetailDist_parRef"
	
			
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
		i (trend=1)||(trend=2) d
		.s jsonTitle="rowid^parRef^code^name^range1^range2^range3^range4^scorelower1^scoreup1^scorelower2^scoreup2^scorelower3^scoreup3^scorelower4^scoreup4"
		i (trend=3) d
		.s jsonTitle="rowid^parRef^code^name^range1^range2^range3^range4^range5^range6^scorelower1^scoreup1^scorelower2^scoreup2^scorelower3^scoreup3^scorelower4^scoreup4^scorelower5^scoreup5^scorelower6^scoreup6"
		
	    
		//f i=1:1:len {
		While(result.Next())
		{
			s rowid=result.Data("SchemDetailDist_rowid")
			s parRef=result.Data("SchemDetailDist_parRef")
			s ranger=result.Data("SchemDetailDist_rangeDr")
			s scoreUp=result.Data("SchemDetailDist_scoreUp")
			s scoreLower=result.Data("SchemDetailDist_scoreLower")

			s appSys = appSysDr
			i appSysDr="1" s appSysDr="全院"
			i appSysDr="2" s appSysDr="科室"
			i appSysDr="3" s appSysDr="护理"
			i appSysDr="4" s appSysDr="医疗"
			i appSysDr="5" s appSysDr="个人"
			s frequency=result.Data("Schem_frequency")
			s quency = frequency
			i frequency="M" s frequency="月"
			i frequency="Q" s frequency="季"
			i frequency="Y" s frequency="年"
			i frequency="H" s frequency="半年"
			s KPIDr=result.Data("Schem_KPIDr")
			s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
		//}
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-08-12
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.SchemDetailDist
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).List("","","","","",0,25,"1||1","H")
ClassMethod List(active, searchField, searchValue, sortField, sortDir, start, limit, schem, trend) As %String
{
     n (active, searchField, searchValue, sortField, sortDir, start, limit,schem,trend)
     s schem = $g(schem)
     s schenpar = $p(schem,"||",1)
     s schemId = $p(schem,"||",2)
     
    
     
     //集体初始化
     s data=""
     s schemdetail = 0
     i (schenpar'="")&&(schemId'="") d
     .f  s schemdetail=$o(^DHCCJXPASTRATAGEM(schenpar,"SchemDetail",schemId,schemdetail)) q:schemdetail=""  d
     ..q:'$d(^DHCCJXPASTRATAGEM(schenpar,"SchemDetail",schemId,schemdetail))||(($g(^DHCCJXPASTRATAGEM(schenpar,"SchemDetail",schemId,schemdetail)))="") 
     ..s schemdetailAll = $g(^DHCCJXPASTRATAGEM(schenpar,"SchemDetail",schemId,schemdetail))
     ..s schemdetaildist = 0
     ..s detail=""
     ..s flag = ""
     ..s rang1="",rang2="",rang3="",rang4="",rang5="",rang6="",scorelower1="",scorelower2="",scorelower3="",scorelower4="",scorelower5="",scorelower6="",scoreup1="",scoreup2="",scoreup3="",scoreup4="",scoreup5="",scoreup6=""
     ..s schemdetailRowid = schem_"||"_schemdetail
     ..f  s schemdetaildist=$o(^DHCCJXPASTRATAGEM(schenpar,"SchemDetailDist",schemId,schemdetail,schemdetaildist)) q:schemdetaildist=""  d
     ...;q:$d(^DHCCJXPASTRATAGEM(schenpar,"SchemDetailDist",schemId,schemdetail,schemdetaildist))||(($g(^DHCCJXPASTRATAGEM(schenpar,"SchemDetailDist",schemId,schemdetail,schemdetaildist)))="")
     ...s schemdetaildistAll = $g(^DHCCJXPASTRATAGEM(schenpar,"SchemDetailDist",schemId,schemdetail,schemdetaildist))
     ...s kpi = $p(schemdetailAll,"^",2)
     ...i kpi'="" {
     	...s kpiAll = $g(^DHCCJXPAKPIINDEX1(kpi))
     	...s kpiTrend = $p(kpiAll,"^",9)
     	...i kpiTrend = trend {
    		...s detail = schem_"||"_schemdetail
    		...s BSC = $p(kpiAll,"^",5)
    		...s BSCName = ""
    		...s BSCCode = ""
    		...i BSC'="" d
    		....s BSCName = $p($g(^DHCCJXPADIMENSTYPE(BSC)),"^",2)
    		....s BSCCode = $p($g(^DHCCJXPADIMENSTYPE(BSC)),"^",1)
    		...s code = $p(kpiAll,"^",1)
    		...s name = $p(kpiAll,"^",2)
    		...s calUnit = $p(kpiAll,"^",8)
    		...s calUnitName = ""
    		...i calUnit'="" d
    		....s calUnitName=$P($g(^DHCCJXPACALUNIT(calUnit)),"^",2)
    		...s BSCData = schemdetailRowid_"^"_BSCCode_"^"_BSCName
    		...;w "flag="_flag,"BSCCode="_BSCCode
    		...i '$d(^TMPDHCPASCHEMDETAILDIST(schenpar,schemId,"-"_BSC)) d
    		....s ^TMPDHCPASCHEMDETAILDIST(schenpar,schemId,"-"_BSC,schemdetail) = BSCData
    		...s parentAll = "-"_BSC_"^"_..getParent(kpi) 
    		...d ..getParentData(detail,parentAll)
    		...s name = ..getSpace($l(parentAll,"^"))_name
    		...s parent = $p(schemdetailAll,"^",5)
     		...s rang = $p(schemdetaildistAll,"^",6)
    		...s scorelower = $p(schemdetaildistAll,"^",4)
     		...s scoreup = $p(schemdetaildistAll,"^",5)
     		...i rang=1 d
     		....s rang1="区间1"
     		....s scorelower1 = scorelower
     		....s scoreup1 = scoreup
     		...e  i rang=2 d
     		....s rang2="区间2"
     		....s scoreup2 = scoreup
     		....s scorelower2 = scorelower
    		...e  i rang=3 d
     		....s rang3="区间3"
     		....s scoreup3 = scoreup
     		....s scorelower3 = scorelower
     		...e  i rang=4 d
     		....s rang4="区间4"
     		....s scoreup4 = scoreup
     		....s scorelower4 = scorelower
     		...e  i rang=5 d
     		....s rang5="区间5"
     		....s scoreup5 = scoreup
     		....s scorelower5 = scorelower
     		...e  i rang=6 d
     		....s rang6="区间6"
     		....s scoreup6 = scoreup
     		....s scorelower6 = scorelower
     		...;s data = schemdetailRowid_"^"_code_"^"_name_"^"_calUnitName_"^"_rang1_"^"_$fn(scoreup1,"^",2)_"^"_$fn(scorelower1,"",2)_"^"_rang2_"^"_$fn(scoreup2,"^",2)_"^"_$fn(scorelower2,"",2)_"^"_rang3_"^"_$fn(scoreup3,"",2)_"^"_$fn(scorelower3,"",2)_"^"_rang4_"^"_$fn(scoreup4,"",2)_"^"_$fn(scorelower4,"",2)_"^"_rang5_"^"_$fn(scoreup5,"",2)_"^"_$fn(scorelower5,"",2)_"^"_rang6_"^"_$fn(scoreup6,"",2)_"^"_$fn(scorelower6,"",2)
     		...s data = schemdetailRowid_"^"_code_"^"_name_"^"_calUnitName_"^"_rang1_"^"_scoreup1_"^"_scorelower1_"^"_rang2_"^"_scoreup2_"^"_scorelower2_"^"_rang3_"^"_scoreup3_"^"_scorelower3_"^"_rang4_"^"_scoreup4_"^"_scorelower4_"^"_rang5_"^"_scoreup5_"^"_scorelower5_"^"_rang6_"^"_scoreup6_"^"_scorelower6
     		...;s ^TMPDHCPASCHEMDETAILDIST(schenpar,schemId,schemdetail,parentAll)=data
     		...s flag =  BSCCode
     		...}
     	...}
     ..;w "data="_data,"schemdetailRowid="_schemdetailRowid,"dist="_detail,!
     ..i (data'="")&&(schemdetailRowid = detail) d
     ...s ^TMPDHCPASCHEMDETAILDIST(schenpar,schemId,parentAll,schemdetail)=data
}

/// Creator: wang ying
/// CreatDate:  2010-08-13
/// Description: 查找kpi父节点
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).getParent(24)
ClassMethod getParent(KPI) As %String
{
	
	n (KPI)
	s parent = KPI
	s parentAll = KPI
	f  s parent = $p($g(^DHCCJXPAKPIINDEX1(parent)),"^",21) q:(parent=0)||(parent="")  d
	.s parentAll = parent_"^"_parentAll
    q parentAll
}

/// Creator: wang ying
/// CreatDate:  2010-08-13
/// Description: 插入父节点数据
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).getParent(24)
ClassMethod getParentData(detailDr, parAll) As %String
{
	
	n (detailDr,parAll)
	s schemDr = $p(detailDr,"||",1)
	s schemSub = $p(detailDr,"||",2)
	s detailSub = $p(detailDr,"||",3)
	s BSCPar = $p(parAll,"^",1)
	s parLen = $l(parAll,"^")
	f j=parLen-1:-1:2 {
	  s parKPI = $P(parAll,"^",j)
	  s parKPIAll = $g(^DHCCJXPAKPIINDEX1(parKPI))
	  i parKPIAll'="" d
	  .s parKPICode = $p(parKPIAll,"^",1)
	  .s parKPIName = $p(parKPIAll,"^",2)
	  .s KPIParRef = BSCPar_"^"_..getParent(parKPI)
	  .s parKPIName = ..getSpace($l(KPIParRef,"^"))_parKPIName
	  .i '$d(^TMPDHCPASCHEMDETAILDIST(schemDr,schemSub,KPIParRef)) d
	  ..s ^TMPDHCPASCHEMDETAILDIST(schemDr,schemSub,KPIParRef,detailSub)=detailDr_"^"_parKPICode_"^"_parKPIName
	}
}

/// Creator: wang ying
/// CreatDate:  2010-08-17
/// Description: 遍历有层次关系的数据
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).getLevel(0,25,"1||1")
ClassMethod getLevel(start, limit, schem) As %String
{
	n (start,limit,schem)
	
	s schemDr = $p(schem,"||",1)
	s schemSub = $p(schem,"||",2)
	;s detailSub = $p(schem,"||",3)
	
	//集体初始化
   
	
	 s count=0
	 s resultString=""
	 s end=start+limit
     s json=##class(dhc.pa.comm.JsonObj).%New()
     s jsonTitle="rowid^code^name^calUnite^range1^range2^range3^range4^range5^range6^scorelower1^scoreup1^scorelower2^scoreup2^scorelower3^scoreup3^scorelower4^scoreup4^scorelower5^scoreup5^scorelower6^scoreup6"
	 
	 q:schemDr="" resultString
	 q:schemSub="" resultString
	
	s parentAll=""
	f  s parentAll=$o(^TMPDHCPASCHEMDETAILDIST(schemDr,schemSub,parentAll)) q:parentAll=""  d
	.s detailSub=""
	.f  s detailSub=$o(^TMPDHCPASCHEMDETAILDIST(schemDr,schemSub,parentAll,detailSub)) q:detailSub=""  d
	..s data="",rang1="",rang2="",rang3="",rang4="",rang5="",rang6="",scorelower1="",scorelower2="",scorelower3="",scorelower4="",scorelower5="",scorelower6="",scoreup1="",scoreup2="",scoreup3="",scoreup4="",scoreup5="",scoreup6=""
	..s detailAdd = $g(^TMPDHCPASCHEMDETAILDIST(schemDr,schemSub,parentAll,detailSub))
	..s rowid = $p(detailAdd,"^",1)
	..s code = $p(detailAdd,"^",2)
	..s name = $p(detailAdd,"^",3)
	..s calUnite = $p(detailAdd,"^",4)
	..s range1 = $p(detailAdd,"^",5)
	..s scoreup1 = $fn($p(detailAdd,"^",6),"",2)
	..s scorelower1 = $fn($p(detailAdd,"^",7),"",2)
	..s range2 = $p(detailAdd,"^",8)
	..s scoreup2 = $fn($p(detailAdd,"^",9),"",2)
	..s scorelower2 = $fn($p(detailAdd,"^",10),"",2)
	..s range3 = $p(detailAdd,"^",11)
	..s scoreup3 = $fn($p(detailAdd,"^",12),"",2)
	..s scorelower3 = $fn($p(detailAdd,"^",13),"",2)
	..s range4 = $p(detailAdd,"^",14)
	..s scoreup4 = $fn($p(detailAdd,"^",15),"",2)
	..s scorelower4 = $fn($p(detailAdd,"^",16),"",2)
	..s range5 = $p(detailAdd,"^",17)
	..s scoreup5 = $fn($p(detailAdd,"^",18),"",2)
	..s scorelower5 = $fn($p(detailAdd,"^",19),"",2)
	..s range6 = $p(detailAdd,"^",20)
	..s scoreup6 = $fn($p(detailAdd,"^",21),"",2)
	..s scorelower6 = $fn($p(detailAdd,"^",22),"",2)
	..s tmp = rowid_"^"_code_"^"_name_"^"_calUnite_"^"_range1_"^"_range2_"^"_range3_"^"_range4_"^"_range5_"^"_range6_"^"_scorelower1_"^"_scoreup1_"^"_scorelower2_"^"_scoreup2_"^"_scorelower3_"^"_scoreup3_"^"_scorelower4_"^"_scoreup4_"^"_scorelower5_"^"_scoreup5_"^"_scorelower6_"^"_scoreup6
	..s count=count+1
	..i (count>start)&(count<=end) d
	...d json.InsertRowData(tmp)
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	k ^TMPDHCPASCHEMDETAILDIST
	q resultString
}

/// Creator: wang ying
/// CreatDate:  2010-08-16
/// Description: 遍历有层次关系
/// Table: dhc.pa.data.SchemDetail
/// Input: 父级的长度
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).getSpace(1)
ClassMethod getSpace(len) As %String
{
	n (len)
	s space=""
	f i=2:1:len {
		s space = "+"_space
		}
	q space
}

/// Creator: wang ying
/// CreatDate:  2010-08-23
/// Description: 插入新记录
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).InsertRec("^^^1||1||4")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s range=$p(data,"^",1)
		s scorelower=$p(data,"^",2)
		s scoreup = $p(data,"^",3)
		s par = $p(data,"^",4)
		s rowid=0
		s rowid=..IfRepRange(par,range)
		q:rowid'=0 "RepRange"
		
			
		i par'="" s PLIST(0)=par
		i range'="" s PLIST(8)=range
		i scorelower'="" s PLIST(4)=scorelower
		i scoreup'="" s PLIST(5)=scoreup
			
		&sql(INSERT INTO dhc_pa_data.SchemDetailDist VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-23
/// Description: 周期是否存在
/// Table: dhc.pa.data.SchemDetailDist
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).IfRepCode("201006")
ClassMethod IfRepRange(schemdetail, range) As %String
{
	n (schemdetail,range)
	s schem = $p(schemdetail,"||",1)
	s schemSub = $p(schemdetail,"||",2)
	s schemDetail = $p(schemdetail,"||",3)
	q:schem="" "NoData"
	q:schemSub="" "NoData" 
	q:schemDetail="" "NoData"  
	
	s rowid=0
	s rowid=$o(^DHCCJXPASTRATAGEM(0,"SchemDetailDistRanger",schem,schemSub,range,schemDetail,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2010-08-25
/// Description: 查找相对应的极值的末层方案明细
/// Table: dhc.pa.data.SchemDetail
/// Input: schem-方案,trend-极值
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uSchemDetailDist).findDetail(0,25,"1||1","H")
ClassMethod findDetail(start, limit, schem, trend) As %String
{
	n (start,limit,schem,trend)
	s schemId = $p(schem,"||",1)
	s schemSub = $p(schem,"||",2)
	
	 s count=0
	 s resultString=""
	 s end=start+limit
     s json=##class(dhc.pa.comm.JsonObj).%New()
     s jsonTitle="rowid^name"
	
	s schemDetail = 0
	f  s schemDetail=$o(^DHCCJXPASTRATAGEM(schemId,"SchemDetail",schemSub,schemDetail)) q:schemDetail=""  d
	.s schemDetailAll = $g(^DHCCJXPASTRATAGEM(schemId,"SchemDetail",schemSub,schemDetail))
	.s KPI = $p(schemDetailAll,"^",2)
	.s trage = $p(schemDetailAll,"^",3)
	.i (trage=2)&&(KPI'="") d
	..s kpiAll = $g(^DHCCJXPAKPIINDEX1(KPI))
	..s kpiName = $p(kpiAll,"^",2)
	..s isEnd = $p(kpiAll,"^",24)
	..s extreMum = $p(kpiAll,"^",9)
	..i (isEnd="Y")&&(extreMum=trend)  d
	...s rowid = schemId_"||"_schemSub_"||"_schemDetail
	...s tmp = rowid_"^"_kpiName
	...s count=count+1
	...i (count>start)&(count<=end) d
	....d json.InsertRowData(tmp)
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-08-25
/// Description: 更新记录
/// Table: dhc.pa.data.SchemDetailDist
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailDist).UpdateRec("1||1||4||5","40^60")
ClassMethod UpdateRec(schem, data) As %String
{
		n (schem,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		s SQLCODE =1
	    s schemId = $p(schem,"||",1)
	    s schemSub = $p(schem,"||",2)
	    s schemDetail = $p(schem,"||",3)
	    s par = schemId_"||"_schemSub_"||"_schemDetail
	    ;s schem = "'"_schem_"'"
		;w schem,!
		s lower=$p(data,"^",1)
		s up = $p(data,"^",2)
 		
 		;w par,lower,up,!
 		s PLIST(0) = par
 		s PLIST(6)=lower
 		s PLIST(7)=up
		&SQL(UPDATE dhc_pa_data.SchemDetailDist VALUES PLIST() where %ID=:schem)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-08-25
/// Description: 更新记录
/// Table: dhc.pa.data.SchemDetailDist
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailDist).Update("1||1||8","11^12^23^24^34^35^44^45")
ClassMethod Update(schem, data) As %String
{
		n (schem,data)
	
		q:data="" "EmptyRecData"
	
		s lower1=$p(data,"^",1)
		s up1 = $p(data,"^",2)
		s lower2=$p(data,"^",3)
		s up2 = $p(data,"^",4)
		s lower3=$p(data,"^",5)
		s up3 = $p(data,"^",6)
		s lower4=$p(data,"^",7)
		s up4 = $p(data,"^",8)
		s lower5=$p(data,"^",9)
		s up5 = $p(data,"^",10)
		s lower6=$p(data,"^",11)
		s up6 = $p(data,"^",12)
 		
 	    s $ZT="ERRO"
		TSTART
 		i (lower1'="")||(up1'="") d
 		.s range1=1
 		.s detailDist1 = ..getDetailDist(schem,range1)
 		.i $p(detailDist1,"||",4)'="" d
 		..s SQLCODE = ..UpdateRec(detailDist1,lower1_"^"_up1)
 		..If SQLCODE TROLLBACK
 		.e  d
 		..s SQLCODE = ..InsertRec(range1_"^"_lower1_"^"_up1_"^"_schem)
 		..If SQLCODE TROLLBACK		
 		i (lower2'="")||(up2'="") d
 		.s range2=2
 		.s detailDist2 = ..getDetailDist(schem,range2)
 		.i $p(detailDist2,"||",4)'="" d
 		..s SQLCODE = ..UpdateRec(detailDist2,lower2_"^"_up2)
 		..If SQLCODE TROLLBACK
 		.e  d
 		..s SQLCODE = ..InsertRec(range2_"^"_lower2_"^"_up2_"^"_schem)
 		..If SQLCODE TROLLBACK	
 		i (lower3'="")||(up3'="") d
 		.s range3=3
 		.s detailDist3 = ..getDetailDist(schem,range3)
 		.i $p(detailDist3,"||",4)'="" d
 		..s SQLCODE = ..UpdateRec(detailDist3,lower3_"^"_up3)
 		..If SQLCODE TROLLBACK
 		.e  d
 		..s SQLCODE = ..InsertRec(range3_"^"_lower3_"^"_up3_"^"_schem)
 		..If SQLCODE TROLLBACK	
 		i (lower4'="")||(up4'="") d
 		.s range4=4
 		.s detailDist4 = ..getDetailDist(schem,range4)
 		.i $p(detailDist4,"||",4)'="" d
 		..s SQLCODE = ..UpdateRec(detailDist4,lower4_"^"_up4)
 		..If SQLCODE TROLLBACK
 		.e  d
 		..s SQLCODE = ..InsertRec(range4_"^"_lower4_"^"_up4_"^"_schem)
 		..If SQLCODE TROLLBACK
 		i (lower5'="")||(up5'="") d
 		.s range5=5
 		.s detailDist5 = ..getDetailDist(schem,range5)
 		.i $p(detailDist5,"||",4)'="" d
 		..s SQLCODE = ..UpdateRec(detailDist5,lower5_"^"_up5)
 		..If SQLCODE TROLLBACK
 		.e  d
 		..s SQLCODE = ..InsertRec(range5_"^"_lower5_"^"_up5_"^"_schem)
 		..If SQLCODE TROLLBACK
 		i (lower6'="")||(up6'="") d
 		.s range6=6
 		.s detailDist6 = ..getDetailDist(schem,range6)
 		.i $p(detailDist6,"||",4)'="" d
 		..s SQLCODE = ..UpdateRec(detailDist6,lower6_"^"_up6)
 		..If SQLCODE TROLLBACK
 		.e  d
 		..s SQLCODE = ..InsertRec(range6_"^"_lower6_"^"_up6_"^"_schem)
 		..If SQLCODE TROLLBACK
 		TCOMMIT
 		q SQLCODE
 		
ERRO
    Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator: wang ying
/// CreatDate: 2010-08-25
/// Description: 根据区间找id
/// Table: dhc.pa.data.SchemDetailDist
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailDist).getDetailDist("1||1||4","2")
ClassMethod getDetailDist(schem, range) As %String
{
	
        n (schem, range)	
	    s schemId = $p(schem,"||",1)
	    s schemSub = $p(schem,"||",2)
	    s schemDetail = $p(schem,"||",3)
	    
	    s detailDist = 0
	    s schemDetailDist=""
 		s detailDist = $o(^DHCCJXPASTRATAGEM(0,"SchemDetailDistRanger",schemId,schemSub,range,schemDetail,detailDist))
 		i (detailDist '="")&&(detailDist '=0) d
 		.s schemDetailDist = schem_"||"_detailDist
 		q schemDetailDist
}

ClassMethod Update1(schem, data) As %String
{
		n (schem,data)
		;w $zt($p($h,",",2))
		k PLIST
		q:data="" "EmptyRecData"
		;w schem, data,!
		;s schem = "'"_schem_"'"	
		s lower1=$p(data,"^",1)
		s up1 = $p(data,"^",2)
		s lower2=$p(data,"^",3)
		s up2 = $p(data,"^",4)
		s lower3=$p(data,"^",5)
		s up3 = $p(data,"^",6)
		s lower4=$p(data,"^",7)
		s up4 = $p(data,"^",8)
		s lower5=$p(data,"^",9)
		s up5 = $p(data,"^",10)
		s lower6=$p(data,"^",11)
		s up6 = $p(data,"^",12)
 		
 		;w "1="_$zt($p($h,",",2)),!
 		s $ZT="ERRO1"
		TSTART
 		
 		i (lower1'="")||(up1'="") d
 		.s range1=1
 		.s detailDist1 = ..getDetailDist(schem,range1)
 		.i detailDist1'="" d
 		..s SQLCODE = ..UpdateRec(detailDist1,lower1_"^"_up1)
 		..If SQLCODE TROLLBACK
 		i (lower2'="")||(up2'="") d
 		.s range2=2
 		.s detailDist2 = ..getDetailDist(schem,range2)
 		.i detailDist2'="" d
 		..s SQLCODE = ..UpdateRec(detailDist2,lower2_"^"_up2)
 		..If SQLCODE TROLLBACK		
 		i (lower3'="")||(up3'="") d
 		.s range3=3
 		.s detailDist3 = ..getDetailDist(schem,range3)
 		.i detailDist3'="" d
 		..s SQLCODE = ..UpdateRec(detailDist3,lower3_"^"_up3)
 		..If SQLCODE TROLLBACK
 		i (lower4'="")||(up4'="") d
 		.s range4=4
 		.s detailDist4 = ..getDetailDist(schem,range4)
 		.;w "4de="_$zt($p($h,",",2)),!
 		.i detailDist4'="" d
 		..;w detailDist4,lower4_"^"_up4,!
 		..s SQLCODE = ..UpdateRec(detailDist4,lower4_"^"_up4)
 		..If SQLCODE TROLLBACK
 		i (lower5'="")||(up5'="") d
 		.s range5=5
 		.s detailDist5 = ..getDetailDist(schem,range5)
 		.i detailDist5'="" d
 		..s SQLCODE = ..UpdateRec(detailDist5,lower5_"^"_up5)
 		..If SQLCODE TROLLBACK
 		i (lower6'="")||(up6'="") d
 		.s range6=6
 		.s detailDist6 = ..getDetailDist(schem,range6)
 		.i detailDist6'="" d
 		..s SQLCODE = ..UpdateRec(detailDist6,lower6_"^"_up6)
 		..If SQLCODE TROLLBACK
		TCOMMIT
 		;w "7="_$zt($p($h,",",2)),!
 		q SQLCODE
 
 		;w $zt($p($h,",",2))

ERRO1
    Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator: wang ying
/// CreatDate: 2010-09-15
/// Description: 初始化方案区间表数据
/// Table: dhc.pa.data.SchemDetailDist
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailDist).init()
ClassMethod init() As %String
{
	
	;w $zt($p($h,",",2)),!
	
	s $ZT="initERRO"
	s SQLCODE=0
	TSTART
	s Stratagem = 0
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.s curreStratagem = $p($g(^DHCCJXPASTRATAGEM(Stratagem)),"^",14)
	.if curreStratagem="Y" d
	..s schem = 0
	..f  s schem=$o(^DHCCJXPASTRATAGEM(Stratagem,"SchemDetail",schem)) q:schem=""  d
	...s schemdetail = 0
	...f  s schemdetail=$o(^DHCCJXPASTRATAGEM(Stratagem,"SchemDetail",schem,schemdetail)) q:schemdetail=""  d
	....s schemdetailAll = $g(^DHCCJXPASTRATAGEM(Stratagem,"SchemDetail",schem,schemdetail))
	....w "schemdetail="_schemdetail,!
	....s kpiDr = $p(schemdetailAll,"^",2)
	....s isTarget = $p(schemdetailAll,"^",3)
	....i $d(^DHCCJXPAKPIINDEX1(kpiDr))&&(isTarget=2) d
	.....s method=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",13)
	.....s extreMum = $p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",9)
	.....s schemDetailDr = Stratagem_"||"_schem_"||"_schemdetail
	.....w "schemDetailDr="_schemDetailDr,!
	.....b
	.....i method="I"  d
	......s rowid=0
	......s rowid =..getDetailDist(schemDetailDr,1)
	......i rowid="" d
	.......s SQLCODE = ..InsertRec("1^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	.......s SQLCODE = ..InsertRec("2^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	.......s SQLCODE = ..InsertRec("3^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	.......s SQLCODE = ..InsertRec("4^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	......e  d
	.......s distRowid = 0
	.......s distRowid =..getDetailDist(schemDetailDr,5)
	.......i distRowid="" d
	........i extreMum="M" d
	.........s SQLCODE = ..InsertRec("5^^^"_schemDetailDr)
	.........i SQLCODE TROLLBACK
	.........s SQLCODE = ..InsertRec("6^^^"_schemDetailDr)
	.........i SQLCODE TROLLBACK
	........e  d
	.........s id5=0,id6=0
	.........s id5=..getDetailDist(schemDetailDr,5)
	.........i id5'="" d
	..........&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:id5)
	..........i SQLCODE TROLLBACK
	.........s id6=..getDetailDist(schemDetailDr,6)
	.........i id6'=""  d
	..........&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:id6)
	..........i SQLCODE TROLLBACK
	.....e  d
	......w schemDetailDr,!
	......b
	......s id = 0
	......s id =..getDetailDist(schemDetailDr,1)
	......i id'=""  d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:id)
	.......i SQLCODE TROLLBACK
	......s rang2=0
	......s rang2=..getDetailDist(schemDetailDr,2)
	......i rang2'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang2)
	.......i SQLCODE TROLLBACK
	......s rang3=0
	......s rang3=..getDetailDist(schemDetailDr,3)
	......i rang3'="" d 
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang3)
	.......i SQLCODE TROLLBACK
	......i rang4=0
	......s rang4=..getDetailDist(schemDetailDr,4)
	......i rang4'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang4)
	.......w "SQLCODE="_SQLCODE,!
	.......i SQLCODE TROLLBACK
	......s rang5=0
	......s rang5=..getDetailDist(schemDetailDr,5)
	......i rang5'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang5)
	.......i SQLCODE TROLLBACK
	......s rang6=0
	......s rang6=..getDetailDist(schemDetailDr,6)
	......i rang6'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang6)
	.......i SQLCODE TROLLBACK
    TCOMMIT
    ;w $zt($p($h,",",2)),!
    q SQLCODE

initERRO
    Set ErrorMsg=$ZE	//得到系统返回的错误消息
 	TROLLBACK		    //回滚事务
 	Quit SQLCODE       //返回错误消息 ;
}

/// Creator: wang ying
/// CreatDate: 2010-09-15
/// Description: 初始化方案区间表数据
/// Table: dhc.pa.data.SchemDetailDist
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailDist).init1()
ClassMethod init1() As %String
{
	
	;w $zt($p($h,",",2)),!
	
	s $ZT="initERRO1"
	s SQLCODE=0
	TSTART
	s Stratagem = 0
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.s curreStratagem = $p($g(^DHCCJXPASTRATAGEM(Stratagem)),"^",14)
	.if curreStratagem="Y" d
	..s schem = 0
	..f  s schem=$o(^DHCCJXPASTRATAGEM(Stratagem,"SchemDetail",schem)) q:schem=""  d
	...s schemdetail = 0
	...f  s schemdetail=$o(^DHCCJXPASTRATAGEM(Stratagem,"SchemDetail",schem,schemdetail)) q:schemdetail=""  d
	....s schemdetailAll = $g(^DHCCJXPASTRATAGEM(Stratagem,"SchemDetail",schem,schemdetail))
	....;w "schemdetail="_schemdetail,!
	....s kpiDr = $p(schemdetailAll,"^",2)
	....s isTarget = $p(schemdetailAll,"^",3)
	....i $d(^DHCCJXPAKPIINDEX1(kpiDr))&&(isTarget=2) d
	.....s method=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",13)
	.....s extreMum = $p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",9)
	.....s schemDetailDr = Stratagem_"||"_schem_"||"_schemdetail
	.....;w "schemDetailDr="_schemDetailDr,!
	.....i method="I"  d
	......s rowid=0
	......s rowid =..getDetailDist(schemDetailDr,1)
	......i rowid="" d
	.......s SQLCODE = ..InsertRec("1^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	.......s SQLCODE = ..InsertRec("2^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	.......s SQLCODE = ..InsertRec("3^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	.......s SQLCODE = ..InsertRec("4^^^"_schemDetailDr)
	.......i SQLCODE TROLLBACK
	......e  d
	.......s distRowid = 0
	.......s distRowid =..getDetailDist(schemDetailDr,5)
	.......i distRowid="" d
	........i extreMum="M" d
	.........s SQLCODE = ..InsertRec("5^^^"_schemDetailDr)
	.........i SQLCODE TROLLBACK
	.........s SQLCODE = ..InsertRec("6^^^"_schemDetailDr)
	.........i SQLCODE TROLLBACK
	........e  d
	.........s id5=0,id6=0
	.........s id5=..getDetailDist(schemDetailDr,5)
	.........i id5'="" d
	..........&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:id5)
	..........i SQLCODE TROLLBACK
	.........s id6=..getDetailDist(schemDetailDr,6)
	.........i id6'=""  d
	..........&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:id6)
	..........i SQLCODE TROLLBACK
    .....e  d
	......s id = 0
	......s id =..getDetailDist(schemDetailDr,1)
	......;w "id",!
	......i id'=""  d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:id)
	.......;w "id="
	.......;b
	.......i SQLCODE TROLLBACK
	......s rang2=0
	......s rang2=..getDetailDist(schemDetailDr,2)
	......i rang2'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang2)
	.......i SQLCODE TROLLBACK
    ......s rang3=0
	......s rang3=..getDetailDist(schemDetailDr,3)
	......i rang3'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang3)
	.......i SQLCODE TROLLBACK
    ......s rang4=0
	......s rang4=..getDetailDist(schemDetailDr,4)
	......i rang4'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang4)
	.......i SQLCODE TROLLBACK
    ......s rang5=0
	......s rang5=..getDetailDist(schemDetailDr,5)
	......i rang5'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang5)
	.......i SQLCODE TROLLBACK
     ......s rang6=0
	......s rang6=..getDetailDist(schemDetailDr,6)
	......i rang6'="" d
	.......&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE %ID=:rang6)
	.......i SQLCODE TROLLBACK
    TCOMMIT
    ;w $zt($p($h,",",2)),!
    q SQLCODE

initERRO1
    Set ErrorMsg=$ZE	//得到系统返回的错误消息
 	TROLLBACK		    //回滚事务
 	Quit SQLCODE       //返回错误消息 ;
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemDetailDistS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
