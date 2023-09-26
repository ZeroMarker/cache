/// Creator: wang ying
/// CreatDate: 2010-11-19
/// Description: 区间kpi指标值设置
Class dhc.pa.udata.uUnitSchemDist Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-11-19
/// Description: 根据传过来的方案以及极值获取KPI的相关信息
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效KPI字符串
/// Others：w ##class(dhc.pa.udata.uUnitSchemDist).GetKPIInfo("1||1","H")
ClassMethod GetKPIInfo(schemDr, trend) As %String
{
	n (start, limit, schemDr,trend)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y' and KPIIndex1_extreMum='"_trend_"'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef='"_schemDr_"')"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s kpiDrAll=""
	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s tmp=rowid //_"^"_name
		i kpiDrAll="" d
		.s kpiDrAll = tmp
		e  s kpiDrAll=kpiDrAll_"$"_tmp
	
	}
	q kpiDrAll
}

/// Creator：wang ying
/// CreatDate：2010-8-31
/// Description: 根据传过来的方案以及极值获取KPI
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效KPI字符串
/// Others：w ##class(dhc.pa.udata.uUnitSchemDist).GetKPI(0,25,"1||1","H")
ClassMethod GetKPI(start, limit, schemDr, trend) As %String
{
	n (start, limit, schemDr,trend)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y' and KPIIndex1_extreMum='"_trend_"'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef='"_schemDr_"')"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s kpiDrAll=""
	s count=0
	s resultString=""
	s end=start+limit
		
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s tmp=rowid_"^"_name
		s count=count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
			
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

///  Creator：wang ying
///  CreatDate：2010-09-01
///  Description: 根据传过来的方案以及极值获取的kpi得到绩效单元区间设置内容
///  Table：dhc_pa_data.KPIIndex1
///  Input： kpi-单条kpidr, unit-绩效单元dr,start:开始记录位置;limit:单页记录条数;schemDr-方案ID
///  Output：
///  Return：有效KPI字符串
///  Others：w ##class(dhc.pa.udata.uUnitSchemDist).ListRec(0,10,"1||1",24,10)
ClassMethod ListRec(start, limit, schemDr, kpi, unit) As %String
{
	n (start,limit,schemDr,kpi,unit)
	s stratagem = $p(schemDr,"||",1)
	
	s count=0
	s resultString=""
	s end=start+limit
    s json=##class(dhc.pa.comm.JsonObj).%New()
    s jsonTitle="rowid^unitSchem^KPIName^calUnitName^baseValue^trageValue^bestValue^baseup^trageup"
     
	s unitschem = 0
	f  s unitschem=$o(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem)) q:unitschem=""  d
	.s unitschemdist = 0
	.f  s unitschemdist=$o(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdist)) q:unitschemdist=""  d
	..s unitschemdistId = stratagem_"||"_unitschem_"||"_unitschemdist
	..s unitschemAll = $g(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem))
	..s schemId = $p(unitschemAll,"^",1)
	..i schemId=schemDr { 
	..s unitschemdistAll = $g(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdist))
	..s KPIName="",calUnitName="",baseValue="",trageValue="",bestValue="",baseup="",trageup=""
	..s period = $p(unitschemAll,"^",4)
	..s str = $e(period,5,$l(period))
	..i str="00" d
	...s jxunit = $p(unitschemAll,"^",3)
	...i (jxunit'="")&&(jxunit=unit) d
	....i $d(^DHCCJXPAJXUNIT(jxunit)) d
	.....s jxunitAll = $g(^DHCCJXPAJXUNIT(jxunit))
	.....s jxunitName = $p(jxunitAll,"^",3)
	.....s unitkpi = $p(unitschemdistAll,"^",2)
	.....i (unitkpi'="")&&(unitkpi=kpi) d
	......i $d(^DHCCJXPAKPIINDEX1(unitkpi))  d
	.......s unitkpiAll = $g(^DHCCJXPAKPIINDEX1(unitkpi))
	.......s KPIName = $p(unitkpiAll,"^",2)
	.......s calUnit = $p(unitkpiAll,"^",8)
	.......i calUnit'=""  d
	........i $d(^DHCCJXPACALUNIT(calUnit)) d
	.........s calUnitName = $p($g(^DHCCJXPACALUNIT(calUnit)),"^",2)
	.......s baseValue = $p(unitschemdistAll,"^",5)
	.......s trageValue = $p(unitschemdistAll,"^",6)
	.......s bestValue = $p(unitschemdistAll,"^",7)
	.......s baseup = $p(unitschemdistAll,"^",9)
	.......s trageup = $p(unitschemdistAll,"^",8)
	.......s tmp = unitschemdistId_"^"_jxunitName_"^"_KPIName_"^"_calUnitName_"^"_$fn(baseValue,"",2)_"^"_$fn(trageValue,"",2)_"^"_$fn(bestValue,"",2)_"^"_$fn(baseup,"",2)_"^"_$fn(trageup,"",2)
	.......s count=count+1
	.......i (count>start)&(count<=end) d
	........d json.InsertRowData(tmp)
	..}
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

///  Creator：wang ying
///  CreatDate：2010-11-19
///  Description: 根据传过来的方案以及极值获取KPI的集合得到绩效单元区间设置内容
///  Table：
///  Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID;KPIDr-KPI指标集合, unit-绩效单元id
///  Output：
///  Return：有效KPI字符串
///  Others：w ##class(dhc.pa.udata.uUnitSchemDist).List(0,10,"1||1",7,"H")
ClassMethod List(start, limit, schemDr, unit, trend) As %String
{
	n (start,limit,schemDr,unit,trend)
	s stratagem = $p(schemDr,"||",1)
	//$8^实收收入$9^人均收益$13^药品收入;8$9$13
	s KPIDr = ..GetKPIInfo(schemDr,trend)
	s kpiList=##class(%Library.ListOfDataTypes).%New()
	s kpiInfo = ""
	i KPIDr'="" d
	.s len = $l(KPIDr,"$")
	.f i=1:1:len d
	..d kpiList.Insert($p(KPIDr,"$",i))
	s count=0
	s resultString=""
	s end=start+limit
    s json=##class(dhc.pa.comm.JsonObj).%New()
    s jsonTitle="rowid^unitSchem^KPIName^calUnitName^baseValue^trageValue^bestValue^baseup^trageup"
     
	s unitschem = 0
	f  s unitschem=$o(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem)) q:unitschem=""  d
	.s unitschemdist = 0
	.f  s unitschemdist=$o(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdist)) q:unitschemdist=""  d
	..s unitschemdistId = stratagem_"||"_unitschem_"||"_unitschemdist
	..s unitschemAll = $g(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem))
	..s schemId = $p(unitschemAll,"^",1)
	..i schemId=schemDr { 
	..s unitschemdistAll = $g(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdist))
	..s KPIName="",calUnitName="",baseValue="",trageValue="",bestValue="",baseup="",trageup=""
	..s parent = $p(unitschemdistAll,"^",25)
	..i parent'=0 d
	...s period = $p(unitschemAll,"^",4)
	...s str = $e(period,5,$l(period))
	...i str="00" d
	....s jxunit = $p(unitschemAll,"^",3)
	....i (jxunit'="")&&(jxunit=unit) d
	.....i $d(^DHCCJXPAJXUNIT(jxunit)) d
	......s jxunitAll = $g(^DHCCJXPAJXUNIT(jxunit))
	......s jxunitName = $p(jxunitAll,"^",3)
	......s unitkpi = $p(unitschemdistAll,"^",2)
	......s str = kpiList.Find(unitkpi)
	......i (unitkpi'="")&&(str'="") d
	.......i $d(^DHCCJXPAKPIINDEX1(unitkpi))  d
	........s unitkpiAll = $g(^DHCCJXPAKPIINDEX1(unitkpi))
	........s KPIName = $p(unitkpiAll,"^",2)
	........s calUnit = $p(unitkpiAll,"^",8)
	........i calUnit'=""  d
	.........i $d(^DHCCJXPACALUNIT(calUnit)) d
	..........s calUnitName = $p($g(^DHCCJXPACALUNIT(calUnit)),"^",2)
	........s baseValue = $p(unitschemdistAll,"^",5)
	........s trageValue = $p(unitschemdistAll,"^",6)
	........s bestValue = $p(unitschemdistAll,"^",7)
	........s baseup = $p(unitschemdistAll,"^",9)
	........s trageup = $p(unitschemdistAll,"^",8)
	........s tmp = unitschemdistId_"^"_jxunitName_"^"_KPIName_"^"_calUnitName_"^"_$fn(baseValue,"",2)_"^"_$fn(trageValue,"",2)_"^"_$fn(bestValue,"",2)_"^"_$fn(baseup,"",2)_"^"_$fn(trageup,"",2)
	........s count=count+1
	........i (count>start)&(count<=end) d
	.........d json.InsertRowData(tmp)
	..}
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate:  2010-09-13
/// Description: 插入新记录
/// Table: dhc.pa.data.Schem
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uUnitSchemDist).update("1||3||6","11^20^10")
ClassMethod update(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s baseValue=$p(data,"^",1)
		s trageValue=$p(data,"^",2)
		s bestValue = $p(data,"^",3)
 		s baseup = $p(data,"^",4)
 		s trageup = $p(data,"^",5)
 		
		;i curreStratagemDr'="" s PLIST(0)=curreStratagemDr
		 s PLIST(7)=baseValue
		 s PLIST(8)=trageValue
		 s PLIST(9)=bestValue
		 s PLIST(11)=baseup
		 s PLIST(10)=trageup
	
		&sql(update dhc_pa_data.UnitResultDetail values PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate:  2010-09-13
/// Description: 插入新记录
/// Table: dhc.pa.data.Schem
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uUnitSchemDist).update("1||1||9","10^20^15^1^5")
ClassMethod insert(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s period = $p(data,"^",1)
		s baseValue=$p(data,"^",2)
		s trageValue=$p(data,"^",3)
		s bestValue = $p(data,"^",4)
 		s baseup = $p(data,"^",5)
 		s trageup = $p(data,"^",6)
 		
 		
		;i curreStratagemDr'="" s PLIST(0)=curreStratagemDr
		 s PLIST(7)=baseValue
		 s PLIST(8)=trageValue
		 s PLIST(9)=bestValue
		 s PLIST(11)=baseup
		 s PLIST(10)=trageup
	
		&sql(update dhc_pa_data.UnitResultDetail values PLIST() where %ID=:rowid)
		q SQLCODE
}

///  Creator：wang ying
///  CreatDate：2010-09-13
///  Description: 根据传过来的方案以及极值获取KPI需要设置的绩效单元明细
///  Table：dhc_pa_data.KPIIndex1
///  Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID,unitResult-绩效单元dr
///  Output：
///  Return：有效KPI字符串
///  Others：w ##class(dhc.pa.udata.uUnitSchemDist).ListPeriod(0,10,"1||1","1||1||9")
ClassMethod ListPeriod(start, limit, schemDr, unitResult) As %String
{
	n (start,limit,schemDr,unitResult)
	s stratagem = $p(unitResult,"||",1)
	s unitschem = $p(unitResult,"||",2)
	s unitschemdetail = $p(unitResult,"||",3)
	
	s count=0
	s resultString=""
	s end=start+limit
    s json=##class(dhc.pa.comm.JsonObj).%New()
    s jsonTitle="rowid^period^KPIName^calUnitName^baseValue^trageValue^bestValue^baseup^trageup"
    	
    s unitAll = $g(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem))
    s unit = $p(unitAll,"^",3)
    s unitschemdetailAll = $g(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdetail))
    s kpi =  $p(unitschemdetailAll,"^",2)
    
	s unitschem = 0
	f  s unitschem=$o(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem)) q:unitschem=""  d
	.s unitschemdist = 0
	.f  s unitschemdist=$o(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdist)) q:unitschemdist=""  d
	..s unitschemdistId = stratagem_"||"_unitschem_"||"_unitschemdist
	..s unitschemAll = $g(^DHCCJXPASTRATAGEM(stratagem,"UnitResult",unitschem))
	..s schemId = $p(unitschemAll,"^",1)
	..i schemId=schemDr { 
	..s unitschemdistAll = $g(^DHCCJXPASTRATAGEM(stratagem,"URDetail",unitschem,unitschemdist))
	..s KPIName="",calUnitName="",baseValue="",trageValue="",bestValue="",baseup="",trageup=""
	..s period = $p(unitschemAll,"^",4)
	..s str = $e(period,5,$l(period))
	..i str'="00" d
	...s jxunit = $p(unitschemAll,"^",3)
	...i (jxunit'="")&&(jxunit=unit) d
	....i $d(^DHCCJXPAJXUNIT(jxunit)) d
	.....s jxunitAll = $g(^DHCCJXPAJXUNIT(jxunit))
	.....s jxunitName = $p(jxunitAll,"^",3)
	.....s unitkpi = $p(unitschemdistAll,"^",2)
	.....i (unitkpi'="")&&(unitkpi=kpi) d
	......i $d(^DHCCJXPAKPIINDEX1(unitkpi))  d
	.......s unitkpiAll = $g(^DHCCJXPAKPIINDEX1(unitkpi))
	.......s KPIName = $p(unitkpiAll,"^",2)
	.......s calUnit = $p(unitkpiAll,"^",8)
	.......i calUnit'=""  d
	........i $d(^DHCCJXPACALUNIT(calUnit)) d
	.........s calUnitName = $p($g(^DHCCJXPACALUNIT(calUnit)),"^",2)
	.......s baseValue = $p(unitschemdistAll,"^",5)
	.......s trageValue = $p(unitschemdistAll,"^",6)
	.......s bestValue = $p(unitschemdistAll,"^",7)
	.......s baseup = $p(unitschemdistAll,"^",9)
	.......s trageup = $p(unitschemdistAll,"^",8)
	.......s tmp = unitschemdistId_"^"_period_"^"_KPIName_"^"_calUnitName_"^"_$fn(baseValue,"",2)_"^"_$fn(trageValue,"",2)_"^"_$fn(bestValue,"",2)_"^"_$fn(baseup,"",2)_"^"_$fn(trageup,"",2)
	.......s count=count+1
	.......i (count>start)&(count<=end) d
	........d json.InsertRowData(tmp)
	..}
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUnitSchemDistS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
