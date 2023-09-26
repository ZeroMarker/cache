/// Creator: 李明忠
/// CreatDate: 2010-9-1
/// Description: 考评计算
Class dhc.pa.udata.uCalculator Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:直接处理非计算性的指标
/// Table:
/// Input:jxUnitDr-绩效单位;newPeriod-考核期间(如:201001);schemDr-绩效方案Dr;KPIDr-KPI指标Dr;exp-用于计算的表达式
/// Output:
/// Return:返回正确或错误的处理结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).DealNotCalWithExp(1,"201001","M",27,"0")
ClassMethod DealNotCalWithExp(jxUnitDr, newPeriod, schemDr, KPIDr, value) As %String
{
	n (jxUnitDr,newPeriod,schemDr,KPIDr,value)
	
	q:jxUnitDr="" "true"
	q:newPeriod="" "true"
	;q:frequency="" "true"
	q:schemDr="" "true"
	q:KPIDr="" "true"
	q:value="" "true"
	
	//操作绩效单元考核表
	s URDr=..GetURRcords(jxUnitDr,newPeriod,schemDr)
	q:URDr="" "true"
	
	//添加到绩效单元考核明细表
	s rs=0,flag="true"
	
	s sqlCode=..SetActValue(URDr,KPIDr,value,"")
	i sqlCode'=0 s rs=1
	
	i rs'=0 d
	.d ##class(dhc.pa.udata.uPALogger).Insert("DealNotCalWithExp",newPeriod_"^"_schemDr_"^"_jxUnitDr_"^"_KPIDr_"^"_value,sqlCode,"")
	.s flag="false"

	q flag
}

/// Creator：李明忠
/// CreatDate：2011-3-2
/// Description: 将公式中的大括弧、中括弧全部转换成小括弧
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：返回新的计算表达式
/// Others:w ##class(dhc.pa.udata.uCalculator).TransStr2("[(<8>-<4>)]/<5>")
ClassMethod TransStr2(string) As %String
{
	n (string)
	
	s newStr=""
	
	s len=$L(string)
	f k=1:1:len d
	.s str=$E(string,k)
	.i (str="[")||(str="{") d
	..s str="("
	.i (str="]")||(str="}") d
	..s str=")"
	.i newStr="" d
	..s newStr=str
	.e  d
	..s newStr=newStr_str
	
	q newStr
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:查询当前战略
/// Table:dhc_pa_data.Stratagem
/// Input:
/// Output:
/// Return:返回当前战略Dr
/// Others:w ##class(dhc.pa.udata.uCalculator).GetCurrStratagemDr()
ClassMethod GetCurrStratagemDr() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Stratagem_rowid from dhc_pa_data.Stratagem where %ID>0 and Stratagem_currStratagem='Y'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s CurrStratagemDr=""
	s count=0

	While(result.Next()){
		s rowid = result.Data("Stratagem_rowid")
		s CurrStratagemDr = rowid
		s count=count+1
	}
	
	//主要是限制错误处理,因为如果存在多个当前战略的话,说明战略记录是有问题的
	i count>1 d
	.s CurrStratagemDr=""
	
	q CurrStratagemDr
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:查询当前战略的绩效考核方案
/// Table:dhc_pa_data.Schem
/// Input:CurrStratagemDr-当前战略
/// Output:
/// Return:返回当前战略的绩效考核方案Dr字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).GetSchemOfCurrStratagemDr(1)
ClassMethod GetSchemOfCurrStratagemDr(CurrStratagemDr) As %String
{
	n (CurrStratagemDr)
	
	s SchemDrStr=""
	q:CurrStratagemDr="" SchemDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Schem_rowid from dhc_pa_data.Schem where Schem_childSub>0 and Schem_appSysDr=2 and Schem_active='Y' and Schem_parRef="_CurrStratagemDr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("Schem_rowid")
		i rowid'="" d
		.s SchemDr = rowid
		.i SchemDrStr="" s SchemDrStr=SchemDr
		.e  s SchemDrStr=SchemDrStr_"^"_SchemDr
	}
	
	q SchemDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).GetJXUnitOfSchem("1||2")
ClassMethod GetJXUnitOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s jxUnitDrStr=""
	q:schemDr="" jxUnitDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0"
	s whereStr=" and UnitSchem_schemDr='"_schemDr_"'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s parRef = result.Data("UnitSchem_parRef")
		i parRef'="" d
		.s jxUnitDr = parRef
		.i jxUnitDrStr="" s jxUnitDrStr=jxUnitDr
		.e  s jxUnitDrStr=jxUnitDrStr_"^"_jxUnitDr
	}
	
	q jxUnitDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:查询绩效考核方案下的指标Dr字符串
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).GetKPIOfSchem("1||1")
ClassMethod GetKPIOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s KPIDrStr=""
	q:schemDr="" KPIDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_isTarget=2 and SchemDetail_parRef='"_schemDr_"')"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		i rowid'="" d
		.s KPIDr=rowid
		.i KPIDrStr="" s KPIDrStr=KPIDr
		.e  s KPIDrStr=KPIDrStr_"^"_KPIDr
	}
	
	q KPIDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-1
/// Description:根据KPIDr查询该指标的计算公式
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-KPI指标的Dr
/// Output:
/// Return:返回KPI指标的计算公式
/// Others:w ##class(dhc.pa.udata.uCalculator).GetKPIExpression(21)
ClassMethod GetKPIExpression(KPIDr) As %String
{
	n (KPIDr)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIIndex1_expression from dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_colTypeDr=2 and KPIIndex1_rowid="_KPIDr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s expression=""

	While(result.Next()){
		s expression = result.Data("KPIIndex1_expression")
		s expression=$E(expression,2,$L(expression)-1)
	}
	
	q expression
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.udata.uCalculator).GetCycle(1,1)
ClassMethod GetCycle(cycleDr, period) As %String
{
	n (cycleDr,period)
	
	q:cycleDr="" "UnCycle" //不计算
	q:period="" "UnPeriod" //不计算
	s newPeriod=""
	
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'=""  d
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "UnCycleCode" //不计算
	
	i period<10 s period="0"_period
	s newPeriod=cycleCode_period
	
	q newPeriod
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:根据条件获取累计的实际值
/// Table:dhc_pa_data.JXBaseData
/// Input:jxUnitDr-绩效单元Dr;period-期间(201001);KPIDr-KPI指标Dr;frequency-期间类型
/// Output:
/// Return:返回实际值
/// Others:w ##class(dhc.pa.udata.uCalculator).GetActValueOfUKP(4,"201501",39,"Q")
ClassMethod GetActValueOfUKP(jxUnitDr, period, KPIDr, frequency) As %String
{
	n (jxUnitDr,period,KPIDr,frequency)
	
	;w jxUnitDr_"^"_period_"^"_KPIDr_"^"_frequency

	q:jxUnitDr="" "NoDeal"
	q:period="" "NoDeal"
	q:KPIDr="" "NoDeal"
	q:frequency="" "NoDeal"
	
	//初始化一个0值
	s ActValue=0
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXBaseData_actualValue,JXBaseData_desc from dhc_pa_data.JXBaseData where JXBaseData_childSub>0 and JXBaseData_dataState=1"
	s whereStr=" and JXBaseData_parRef='"_jxUnitDr_"'"
	s whereStr=whereStr_" and JXBaseData_period='"_period_"'"
	s whereStr=whereStr_" and JXBaseData_KPIDr='"_KPIDr_"'"
	s whereStr=whereStr_" and JXBaseData_periodType='"_frequency_"'"
	
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s desc=""
	While(result.Next()){
		s actualValue = result.Data("JXBaseData_actualValue")
		s ActValue=ActValue+actualValue
		s desc=desc_result.Data("JXBaseData_desc")
	}
	
	q $fn(ActValue,"",2)_"^"_desc
}

/// Creator：李明忠
/// CreatDate：2010-9-2
/// Description: 获取特定字符串并装入字符串集合
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：字符串集合
/// Others:w ##class(dhc.pa.udata.uCalculator).GetStrList("{[(<21>+<51>)*0.5]/25}")
ClassMethod GetStrList(string) As %Library.ListOfDataTypes
{
	n (string)
	
	s StrList=##class(%Library.ListOfDataTypes).%New()
	f i=1:1:$L(string) d
	.i $E(string,i)="<" d
	..s k=..GetNextLocation(string,i)
	..d StrList.Insert($E(string,i,k))
	
	q StrList
}

/// Creator：李明忠
/// CreatDate：2010-9-2
/// Description: 转换给定的计算表达式(用于计算)
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：返回新的计算表达式
/// Others:w ##class(dhc.pa.udata.uCalculator).TransStr("<40>/<39>",4,"201602","Q")
ClassMethod TransStr(string, jxUnitDr, period, frequency) As %String
{
	n (string, jxUnitDr, period, frequency)
	
	s newStr=""
	
	s StrList=..GetStrList(string)
	;w StrList.Count(),!
	q:StrList.Count()=0 string
	
	//遍历StrList
	s str=StrList.GetAt(1)
	s strLength=$L(str)
	s ActValue=0 //默认初始化
	
	//"<45>"情况
	i strLength>2 d
	.s KPIDr=$E(str,2,strLength-1)
	.i KPIDr'="" d 
	..s ActValue=$p(..GetActValueOfUKP(jxUnitDr,period,KPIDr,frequency),"^",1)
	s length=$L(string,str)
	f m=1:1:length d
	.i m<length d
	..i newStr="" s newStr=$P(string,str,m)_ActValue
	..e  s newStr=newStr_$P(string,str,m)_ActValue
	.e  d
	..i newStr="" s newStr=$P(string,str,m)
	..e  s newStr=newStr_$P(string,str,m)
	
	
	s newStr=..TransStr(newStr,jxUnitDr,period,frequency)
	
	q newStr
}

/// Creator：李明忠
/// CreatDate：2010-9-2
/// Description: 根据给定的字符串和字符位置查询指定字符的位置
/// Table：
/// Input：string-指定字符的位置;num-"<"的占位位置
/// Output：
/// Return：返回指定字符的位置
/// Others:w ##class(dhc.pa.udata.uCalculator).GetNextLocation("{[(<21>+<51>)*0.5]/25}",2)
ClassMethod GetNextLocation(string, num) As %String
{
	s flag="false"
	//定义">"位置
	s k=0 

	i $E(string,num+1)=">" d
	.s flag="true"
	.s k=num+1
	.q:flag="true"
	e  d
	.s k=..GetNextLocation(string,num+1)
	
	q k
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:处理KPI指标的计算公式
/// Table:
/// Input:expression-计算公式;jxUnitDr-绩效单元Dr;period-期间(201001);frequency-期间类型
/// Output:
/// Return:返回处理后的新公式
/// Others:w ##class(dhc.pa.udata.uCalculator).DealFormula("{[(<3>+<18>)*0.5]/25}",16,"201301","Q")
ClassMethod DealFormula(expression, jxUnitDr, period, frequency) As %String
{
	n (expression,jxUnitDr,period,frequency)
	
	s newExpression=..TransStr(expression,jxUnitDr,period,frequency)
	
	q newExpression
}

/// Creator:wang ying
/// CreatDate:2014-8-1
/// Description:按方案级别计算指标值
/// Table:dhc_pa_data.BaseData
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间;schemDr-方案
/// Output:
/// Return:返回KPI指标信息字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).actValueBySchemLevel(2,"M",1,1,2,"true")
ClassMethod actValueBySchemLevel(cycleDr, frequency, period, CurrStratagemDr, schemLevel, flag, userCode) As %String
{
	n (cycleDr, frequency, period,CurrStratagemDr, schemLevel,flag,userCode)
	s schem=0,aduit=""
	f  s schem=$o(^DHCCJXPASTRATAGEM(0,"SchemFrequency",CurrStratagemDr,frequency,schem)) q:schem=""  d
	.q:'$d(^DHCCJXPASTRATAGEM(CurrStratagemDr,"Schem",schem))
	.s schemStr=$g(^DHCCJXPASTRATAGEM(CurrStratagemDr,"Schem",schem))
	.q:schemStr=""
	.s level=$p(schemStr,"^",9)
	.i level=schemLevel d
	..s aduit= ##class(dhc.pa.udata.uComm).SchemByAduit(CurrStratagemDr_"||"_schem,userCode)
	..q:aduit=0
	..i flag="true" d
	...s flag=..GetAllInfo(cycleDr, frequency, period, CurrStratagemDr_"||"_schem)
	..e  s flag=$p(..GetAllInfo(cycleDr, frequency, period, CurrStratagemDr_"||"_schem),"%",1)_"!"_flag
    
    q flag
}

/// Creator:wang ying
/// CreatDate:2014-8-1
/// Description:按方案级别计算指标值
/// Table:dhc_pa_data.BaseData
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间;schemDr-方案
/// Output:
/// Return:返回KPI指标信息字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).actValueBySchemLevel(1,"M",01,1,2,"true")
ClassMethod scoreBySchemLevel(cycleDr, frequency, period, CurrStratagemDr, schemLevel, flag, userCode) As %String
{
	n (cycleDr, frequency, period,CurrStratagemDr, schemLevel,flag,userCode)
	s schem=0
	f  s schem=$o(^DHCCJXPASTRATAGEM(0,"SchemFrequency",CurrStratagemDr,frequency,schem)) q:schem=""  d
	.q:'$d(^DHCCJXPASTRATAGEM(CurrStratagemDr,"Schem",schem))
	.s schemStr=$g(^DHCCJXPASTRATAGEM(CurrStratagemDr,"Schem",schem))
	.q:schemStr=""
	.s level=$p(schemStr,"^",9)
	.i level=schemLevel d
	..s aduit= ##class(dhc.pa.udata.uComm).SchemByAduit(CurrStratagemDr_"||"_schem,userCode)
	..q:aduit=0
	..s flag=..AssScoreCal(cycleDr, frequency, period, CurrStratagemDr_"||"_schem)
    
    q flag
}

/// Creator:wang ying
/// CreatDate:2014-8-1
/// Description:选择方案按照方案计算，不选择方案计算全部指标
/// Table:dhc_pa_data.BaseData
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间;schemDr-方案
/// Output:
/// Return:返回KPI指标信息字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).setAllActValue(6,"Q","2","","demo")
/// 2-Inpatient,3-innurse,4-pharmacy,5-cashier,6-doctor
ClassMethod setAllActValue(cycleDr, frequency, period, schemDr, userCode) As %String
{
	;w $zt($p($h,",",2)),!
    n (cycleDr, frequency, period, schemDr,userCode)
	q:cycleDr="" "UnCycle" //不计算
	q:frequency="" "UnFrequency" //不计算
	q:period="" "UnPeriod" //不计算
	q:userCode="" "UnuserCode" //不计算
	;i userCode="" s userCode=1
	s currStratagemDr=..GetCurrStratagemDr()
	q:currStratagemDr="" "NoCurrStratagem"
	s flag="true",aduit=""
	i ((schemDr'="1")&&(schemDr'="")) d
	.s aduit= ##class(dhc.pa.udata.uComm).SchemByAduit(schemDr,userCode)
	.q:aduit=0
	.s flag=..GetAllInfo(cycleDr, frequency, period, schemDr)
	e  d
	.s flag=..actValueBySchemLevel(cycleDr, frequency, period,currStratagemDr,2,flag,userCode)
	.s flag=..actValueBySchemLevel(cycleDr, frequency, period,currStratagemDr,1,flag,userCode)
		
	;w $zt($p($h,",",2)),!
	i flag="true" s flag="%true"
	q flag
}

/// Creator:李明忠
/// CreatDate:2010-9-1
/// Description:根据所传参数条件计算公式
/// Table:dhc_pa_data.BaseData
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间;schemDr-方案
/// Output:
/// Return:返回KPI指标信息字符串
/// Others:w ##class(dhc.pa.udata.uCalculator).GetAllInfo(6,"Q",2,"1||1")
ClassMethod GetAllInfo(cycleDr, frequency, period, schemDr) As %String
{
	n (cycleDr,frequency,period,schemDr)

	q:cycleDr="" "UnCycle" //不计算
	q:frequency="" "UnFrequency" //不计算
	q:period="" "UnPeriod" //不计算
	q:schemDr="" "NoSchem" //不计算
	
	s newPeriod=..GetCycle(cycleDr,period) //获取新考核期间
	s flag="true",allInfoStr=""
	
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr) //根据方案获取绩效单位
	s jxUnitDrLen=$L(jxUnitDrStr,"^")
	f m=1:1:jxUnitDrLen d
	.s jxUnitDr=$P(jxUnitDrStr,"^",m)
	.s jxUnitName=""
	.i jxUnitDr'="" d
	..s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	..s KPIDrStr=..GetKPIOfSchem(schemDr) //根据方案获取KPI指标
	..;w KPIDrStr,!
	..s KPIDrLen=$L(KPIDrStr,"^")
	..f n=1:1:KPIDrLen d
	...s KPIDr=$P(KPIDrStr,"^",n)
	...;w KPIDr,!
	...i KPIDr'="" d //绩效单元、KPI指标都不为空,可以处理业务流程
	....s KPIName="" //获取指标名称、收集方式
	....s colTypeDr=""
	....i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.....i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	......s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	
	......s extremum=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",9)  //极值
	
	......;w KPIName,!
	......s colTypeDr=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",12)
	....i (colTypeDr=1)||(colTypeDr=3)||(colTypeDr=4) d  //判断指标的收集方式:1-录入、2-计算、3-无实际值、4-采集	
	.....s Flag=..DealNotCal(jxUnitDr,newPeriod,frequency,schemDr,KPIDr) //非计算类指标直接处理

	.....i Flag'="true" d

	......s flag="false"
	......s tmp=newPeriod_"^"_jxUnitName_"^"_KPIName
	......i allInfoStr="" s allInfoStr=tmp
	......e  s allInfoStr=allInfoStr_"!"_tmp
	....i colTypeDr=2  d  //计算类指标先计算该指标值再处理
	.....s calUnitName=""
    .....s calUnitName=$P(^DHCCJXPACALUNIT($p(^DHCCJXPAKPIINDEX1(KPIDr),"^",8)),"^",2)
    .....;w "this is ->"_KPIDr_"<-"
	.....s expression=..GetKPIExpression(KPIDr) //获取该指标的计算公式
    .....;w "this is ->"_expression_"<-"
	.....;w newPeriod_"^"_schemDr_"^"_jxUnitDr_"^"_KPIDr_"^"_KPIName_"^"_colTypeDr_"^"_expression,!
	.....i expression'="" d
	......s expression=..TransStr2(..TransStr(expression,jxUnitDr,newPeriod,frequency)) //调用公式转换方法
	......s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	......;w mark_"^"_expression,!
	......i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	.......s actValue=100 
	......i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	.......s actValue=0
	.......i $fn(mark,"",2)="" d
	........s actValue=0
	.......;e  s actValue=$fn(mark,"",2)
	.......e  s actValue=mark
	.......i calUnitName="百分比" s actValue=actValue*100
	.......;w mark_"^"_expression_"^"_calUnitName_"^"_jxUnitName_"^"_KPIName_"^"_actValue,!
	.......s Flag=..DealNotCalWithExp(jxUnitDr,newPeriod,schemDr,KPIDr,actValue)
	......;b
	.......i Flag'="true" d
	........s flag="false"
	........s tmp=newPeriod_"^"_jxUnitName_"^"_KPIName
	........i allInfoStr="" s allInfoStr=tmp
	........e  s allInfoStr=allInfoStr_"!"_tmp
	......e  d
	.......s tmp=newPeriod_"^"_jxUnitName_"^"_KPIName
	.......;w tmp,!
	.......i allInfoStr="" s allInfoStr=tmp
	.......e  s allInfoStr=allInfoStr_"!"_tmp
	
	;do ..NuserScoreCompute(newPeriod, frequency) 
	
	;w allInfoStr_"%"_flag,!
	
	q allInfoStr_"%"_flag
	q flag
}

/// Creator:zxy
/// CreatDate:2012-2-16
/// Description:护理扣分按病区统计计算
/// Table:
/// Input:newPeriod-考核期间(如:201001);frequency-期间类型(M、Q、H、Y);schemDr-绩效方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回正确或错误的处理结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).NuserScoreCompute("201201","M")
ClassMethod NuserScoreCompute(newPeriod, frequency) As %String
{
	n (newPeriod,frequency)
	
  

    s sqlStr = " select re.DNR_DeptDr,re.JXBaseData_periodType,re.JXBaseData_period,re.JXBaseData_KPIDr, sum(re.JXBaseData_actualValue)/count(*) as actValue  from  "
    s sqlStr = sqlStr_" (SELECT r.DNR_DeptDr, r.DNR_RoomDr,  b.JXBaseData_period, b.JXBaseData_periodType,b.JXBaseData_KPIDr, b.JXBaseData_actualValue " 
    s sqlStr = sqlStr_" FROM dhc_pa_data.JXBaseData b INNER JOIN dhc_pa_data.DeptNurseRoom r ON b.JXBaseData_parRef = r.DNR_RoomDr   "
     s sqlStr = sqlStr_"  where b.JXBaseData_period='"_newPeriod_"' and b.JXBaseData_periodType='"_frequency_"') re "
	 s sqlStr = sqlStr_" group by  re.DNR_DeptDr,re.JXBaseData_periodType,re.JXBaseData_period,re.JXBaseData_KPIDr"
     //w sqlStr,!
  	s result = ##class(%Library.ResultSet).%New()
	s KPITy  = 2
	d result.Prepare(sqlStr)
	d result.Execute()
	
	

	While(result.Next()){
		s UnitDr = result.Data("DNR_DeptDr")
		s mValue = result.Data("actValue")
		s KPIDr = result.Data("JXBaseData_KPIDr")
		//w UnitDr_"//"_mValue_"//"_KPIDr_"//",!
		&sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_actValue=:mValue where UnitResultDetail_isTarget=:KPITy and   UnitResultDetail_KPIDr = :KPIDr and UnitResultDetail_parRef in (select UnitResult_rowid  from  dhc_pa_data.UnitResult where  UnitResult_jxUnitDr=:UnitDr and UnitResult_period=:newPeriod) )

		
	}
  
   do result.Close()
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:直接处理非计算性的指标
/// Table:
/// Input:jxUnitDr-绩效单位;newPeriod-考核期间(如:201001);frequency-期间类型(M、Q、H、Y);schemDr-绩效方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回正确或错误的处理结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).DealNotCal(18,"201201","M","2||2",23)  
ClassMethod DealNotCal(jxUnitDr, newPeriod, frequency, schemDr, KPIDr) As %String
{
	n (jxUnitDr,newPeriod,frequency,schemDr,KPIDr)
	
	;w jxUnitDr_"^"_newPeriod_"^"_frequency_"^"_schemDr_"^"_KPIDr_"^"_$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2),!
	
	q:jxUnitDr="" "true"
	q:newPeriod="" "true"
	q:frequency="" "true"
	q:schemDr="" "true"
	q:KPIDr="" "true"
	
	//从基础数据管理表中获取指标实际值
	s baseDate=..GetActValueOfUKP(jxUnitDr,newPeriod,KPIDr,frequency) //2016-01-11 wy update
	s actValue=$p(baseDate,"^",1)
	s desc=$p(baseDate,"^",2)
	//操作绩效单元考核表
	s URDr=..GetURRcords(jxUnitDr,newPeriod,schemDr)
	;w URDr,!
	
	q:URDr="" "true"
	
	//添加到绩效单元考核明细表
	s rs=0,flag="true"
	
	s sqlCode=..SetActValue(URDr,KPIDr,actValue,desc)

	i sqlCode'=0 s rs=1
	
	i rs'=0 d
	.d ##class(dhc.pa.udata.uPALogger).Insert("DealNotCal",newPeriod_"^"_frequency_"^"_KPIDr_"^"_actValue_"^"_desc,sqlCode,"")
	.s flag="false"
	
	
	q flag
}

/// Creator:李明忠
/// CreatDate:2010-9-2
/// Description:查询条件下的绩效单元考核表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-绩效方案Dr;jxUnitDr-绩效单位;newPeriod-考核期间(如:201001)
/// Output:
/// Return:返回绩效单元考核表记录
/// Others:w ##class(dhc.pa.udata.uCalculator).GetURRcords(12,"201401","1||11") 
ClassMethod GetURRcords(jxUnitDr, newPeriod, schemDr) As %String
{
	n (jxUnitDr,newPeriod,schemDr)
	;w jxUnitDr_"^"_newPeriod_"^"_schemDr
	//绩效单元考核表记录Dr
	s URDr=""
	
	q:jxUnitDr="" URDr
	q:newPeriod="" URDr
	q:schemDr="" URDr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_rowid from dhc_pa_data.UnitResult where UnitResult_childSub>0 and UnitResult_appSysDr=2"
	s whereStr=" and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr='"_jxUnitDr_"'"
	s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	
	s sqlStr=sqlStr_whereStr
	;W sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s URDr = result.Data("UnitResult_rowid")
	}
	;w URDr,!
	q URDr
}

/// Creator：李明忠
/// CreatDate：2010-9-2
/// Description:设置相关条件下的绩效单元考核明细表记录的实际值
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-绩效单元考核主表Dr;KPIDr-KPI指标Dr;actValue-实际值
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.pa.udata.uCalculator).SetActValue("1||2",5,42556.00)
ClassMethod SetActValue(urRowid, KPIDr, actValue, desc) As %String
{
	n (urRowid,KPIDr,actValue,desc)
	
	
	i actValue="" s actValue=""
	
	i actValue="Infinity" s actValue=""
	
	i actValue="NaN" s actValue=""
	
	;s desc=$REPLACE($REPLACE(desc,$char(10),""),$char(0),"")
	
	s isTarget=2

	&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_actValue=:actValue,UnitResultDetail_estDesc=:desc where UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_parRef=:urRowid and UnitResultDetail_isTarget=:isTarget)
	
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-9-3
/// Description:处理计算性指标
/// Table:
/// Input:allInfo-所有计算性指标的信息
/// Output:
/// Return:返回正确或错误的处理结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).DealCal("200912^1||1^9^9^人均收益^(10000-5000)/20^250!200912^1||1^14^9^人均收益^(0-0) /0^NaN!200912^1||1^19^9^人均收益^(0-0)/0^NaN!200912^1||1^20^9^人均收益^(180000- 160080)/20^996!200912^1||4^15^9^人均收益^(0-0)/0^NaN!200912^1||5^20^9^人均收益^(180000-160080)/20^996")
ClassMethod DealCal(allInfo) As %String
{
	n (allInfo)
	
	q:allInfo="" "NoDeal"
	
	TSTART
	s rs=0,flag="true"
	
	s infoLen=$L(allInfo,"!")
	f k=1:1:infoLen d
	.s info=$P(allInfo,"!",k)
	.s newPeriod=$P(info,"^",1)
	.s schemDr=$P(info,"^",2)
	.s jxUnitDr=$P(info,"^",3)
	.s KPIDr=$P(info,"^",4)
	.s actValue=$P(info,"^",7)
	.s urRowid=..GetURRcords(jxUnitDr, newPeriod, schemDr)
	.i urRowid'="" d
	..s sqlCode=..SetActValue(urRowid, KPIDr, actValue)
	..i sqlCode'=0 s rs=1
	
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator:wang ying
/// CreatDate:2014-8-1
/// Description:考核分计算
/// Table:
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// 2-Inpatient,3-innurse,4-pharmacy,5-cashier,6-doctor
/// Others:w ##class(dhc.pa.udata.uCalculator).AssScoreCalAll(3,"Q",1,"","Inpatient")
ClassMethod AssScoreCalAll(cycleDr, frequency, period, schemDr, userCode) As %String
{
	
	;w $zt($p($h,",",2)),!
	q:cycleDr="" "UnCycle" //不计算
	q:frequency="" "UnFrequency" //不计算
	q:period="" "UnPeriod" //不计算
	
	s currStratagemDr=..GetCurrStratagemDr()
	q:currStratagemDr="" "NoCurrStratagem"
	s flag="true"
	s aduit=""

	i schemDr'="" d
	.s aduit= ##class(dhc.pa.udata.uComm).SchemByAduit(schemDr,userCode)
	q:aduit=0 "NoAduit"
	i ((schemDr'="")&&(schemDr'="1")) d
	.s flag=..AssScoreCal(cycleDr, frequency, period, schemDr)
	e  d
	.s flag=..scoreBySchemLevel(cycleDr, frequency, period,currStratagemDr,2,flag,userCode)
	.s flag=..scoreBySchemLevel(cycleDr, frequency, period,currStratagemDr,1,flag,userCode)
		
	;w $zt($p($h,",",2)),!
	q flag
}

/// Creator:wang ying
/// CreatDate:2015-4-28
/// Description:判断方案是否有权限
/// Table:
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).AssScoreCalAll(4,"M",1,"")
ClassMethod SchemByAduit(schemDr) As %String
{
	
	;w $zt($p($h,",",2)),!
	q:schemDr="" "UnCycle" //不计算
	q:frequency="" "UnFrequency" //不计算
	q:period="" "UnPeriod" //不计算
	
	s currStratagemDr=..GetCurrStratagemDr()
	q:currStratagemDr="" "NoCurrStratagem"
	s flag="true"
	i ((schemDr'="")&&(schemDr'="1")) d
	.s flag=..AssScoreCal(cycleDr, frequency, period, schemDr)
	e  d
	.s flag=..scoreBySchemLevel(cycleDr, frequency, period,currStratagemDr,2,flag)
	.s flag=..scoreBySchemLevel(cycleDr, frequency, period,currStratagemDr,1,flag)
		
	;w $zt($p($h,",",2)),!
	q flag
}

/// Creator:李明忠
/// CreatDate:2010-9-3
/// Description:考核分计算
/// Table:
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).AssScoreCal(6,"Q",02,"1||1")
ClassMethod AssScoreCal(cycleDr, frequency, period, schemDr) As %String
{
	n (cycleDr,frequency,period,schemDr)
	
	;w "开始执行:"_$ZT($P($H,",",2)),! 
	
	q:cycleDr="" "NoCycle"
	q:frequency="" "NoFreq"
	q:period="" "NoPeriod"
	q:schemDr="" "NoSchemDr"
	
	//获取新考核期间
	s newPeriod=..GetCycle(cycleDr,period)
	q:newPeriod="" "NoPeriod"
    
    ;b 
	//获取当前战略
	s currStratagemDr=..GetCurrStratagemDr()
	q:CurrStratagemDr="" "NoCurrStratagem"
	s flag="true"
	
	//初始化变量
	set fullScore = 100
	set isTop = 0
	set ComMethodAudit=0   
	&sql(SELECT Param_value INTO :pValue FROM dhc_pa_data.Param WHERE Param_Code='0201' )
	if (pValue = 0) d
	.set fullScore = 100
	else  d
	.set fullScore = 1000
	///获得是否分数限制标志,分数是否封顶
	&sql(SELECT Param_value INTO :isTop FROM dhc_pa_data.Param WHERE Param_Code='0202' )
	///是否是 权重全表设置 如果ComMethodAudit=1 则表示考核分为加权后的分
	&sql(SELECT Param_value INTO :ComMethodAudit FROM dhc_pa_data.Param WHERE Param_Code='0203' )
	
	&sql(SELECT MAX(KPIIndex1_level) INTO :KPIMaxLevel FROM dhc_pa_data.KPIIndex1)

	s level=""
	s computeType=""
	s UpSchem=""
	s UpKPIDrs=""
  
	i $d(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2))) d
	.s level=$p(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2)),"^",9)
	.s computeType=$p(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2)),"^",10)
	.s UpSchem=$p(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2)),"^",11)
	.s UpKPIDrs=$p(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2)),"^",6)
   
	
	 set strSQL =" SELECT  UnitResult_childSub, UnitResult_jxUnitDr FROM dhc_pa_data.UnitResult "
	 set strSQL = strSQL_" where UnitResult_schemDr='"_schemDr_"' "
	 set strSQL = strSQL_"  and UnitResult_period='"_newPeriod_"' and UnitResult_parRef= "_currStratagemDr
	
	//循环绩效单元考核主表
	
	set result=##class(%Library.ResultSet).%New()
    do result.Prepare(strSQL)
    do result.Execute()
    While(result.Next()){
	  
	set UnitDr  = result.Data("UnitResult_jxUnitDr")
	set urChild  = result.Data("UnitResult_childSub")
	set unitResulparRef=currStratagemDr_"||"_urChild
	
	i (computeType =3) {
		&SQL(Update  dhc_pa_data.UnitResultDetail set UnitResultDetail_score = UnitResultDetail_actValue where  UnitResultDetail_parRef =:unitResulparRef)
		&SQL(Update  dhc_pa_data.UnitResultDetail set UnitResultDetail_score = (UnitResultDetail_tValue+UnitResultDetail_actValue)/UnitResultDetail_rate*100 where  UnitResultDetail_parRef =:unitResulparRef AND UnitResultDetail_tValue!=100)
		d ..ComputeKPIScoreMinusLevel(currStratagemDr, urChild,computeType)
	}
	/*
	i (computeType =2) {
		
		&SQL(Update  dhc_pa_data.UnitResultDetail set UnitResultDetail_score = UnitResultDetail_actValue where  UnitResultDetail_parRef =:unitResulparRef)
		d ..ComputeKPIScoreMinusLevel(currStratagemDr, urChild,2)
	}
	*/
	i (computeType '=3) {
		
		s flag=##class(dhc.pa.udata.uCalculatorNew).ComputeKPIScore(currStratagemDr,urChild,newPeriod,frequency,fullScore,isTop,ComMethodAudit,KPIMaxLevel)
		;s flag=##class(dhc.pa.udata.uCalculator).ComputeKPIScore(currStratagemDr,urChild,newPeriod,frequency,fullScore,isTop,ComMethodAudit)
		;s flag=..ComputeKPIScorePY(currStratagemDr,urChild,newPeriod,frequency,fullScore,isTop,ComMethodAudit)
		;s flag=..ComputeKPIScoreWHYY(currStratagemDr,urChild,newPeriod,frequency,fullScore,isTop,ComMethodAudit)
	}
	
	
	i (level'=1) && (UpSchem'="" )&&(UpKPIDrs'=""){
		
        d ..ComputeScoreToUpSchem(currStratagemDr, urChild, newPeriod, schemDr, UnitDr, UpKPIDrs, UpSchem)
	}
	
	
  }
  
  do result.Close()
	
	q flag
}

/// Creator:张学燕
/// CreatDate:2010-9-3
/// Description:指标分数计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScore(1,7634,"201602","Q",100,1,1)
ClassMethod ComputeKPIScore(currStratagemDr, unitResultChildSub, period, PType, fullScore, isTop, ComMethodAudit) As %String
{
  	new (currStratagemDr,unitResultChildSub,period,PType,fullScore, isTop,ComMethodAudit)
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
	..;set isTarget 	 = $P(Curr,"^",4) //判断是维度还是指标
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
	..if ( KPIMethod ="A")||(KPIMethod ="D")  do
	...set URDAddSub=""
	...for  set URDAddSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub)) q:URDAddSub=""  d
	....set KPIAddRec=0
	....set ScoreValue=0
	....set addChangeValue=0
	....set addScore=0
	....set fm=1  
	....set KPIAddRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub))
	....if KPIAddRec'="" do
	.....set addChangeValue  = $p(KPIAddRec,"^",2)   // 获得增减值
	.....set addScore		 = $p(KPIAddRec,"^",3)   // 获得增减分
	.....set baseScore = $p(KPIAddRec,"^",4)         // 获得基础值

	.....if (calculationDr=1) && (tValue '=0) && (addChangeValue'="") do 
	......set fm=(tValue/100)
	
	......if fm=0 set fm=1
	......;write "FM" = fm,!
	.....else
	......set fm=1 
	.....;write "calculationDr = ",calculationDr,"--kpi-",KPIDr, "--///",fm,“//”,addChangeValue,"//",addScore!
	.....;///趋高趋低分别计算
	.....if (KPIExtreMum="H") && (addChangeValue'=0) &&  (addChangeValue'="") do 
	......if ((actValue-tValue)>0) && (fm <0) do  
	.......set fm= fm*-1
	......set ScoreValue = (actValue-tValue)*addScore/(addChangeValue*fm) 
	
	.....if (KPIExtreMum="L") && (addChangeValue'=0 )&&(addChangeValue'="") do
	......if ((tValue-actValue)>0) && (fm <0) do  
	.......set fm= fm*-1
 	......set ScoreValue = (tValue-actValue)*addScore/(addChangeValue*fm) 
 	.....;write "123 = ",KPIDr,"-",KPIExtreMum,"-",ScoreValue, !
 	...set mflag=1
 	...;set baseScore=90
 	...if KPIMethod ="D" do
 	....set mflag=-1
 	....;set baseScore=fullScore
 	...set ScoreValue = baseScore + (ScoreValue*mflag) 
 	...;write "888 = ",ScoreValue, !
 	...;if ((KPIMethod ="D")&&(KPIExtreMum="H")&&(actValue>tValue))||(( KPIMethod ="D")&&(KPIExtreMum="L")&&(actValue<tValue))||((KPIMethod="D")&&(ScoreValue<0))  do 
 	...;.set ScoreValue=0 
 	..;///'M'目标参照法’ ---------------------------------------
	..if (KPIMethod ="M") && (tValue'=0)&&(tValue'="") do
	...set ScoreValue = actValue*fullScore/tValue   // 目标值/实际值
	...;w "目标参照法-",ScoreValue,!
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
	....set valueUp	= $p(KPIDistRec,"^",3)
	....set scoreLower = $p(KPIDistRec,"^",4)
	....set scoreUp    = $p(KPIDistRec,"^",5)  
	....set rangeDr    = $p(KPIDistRec,"^",6)
	....set valuePice  = valueUp - valueLower
	....set scorePice  = scoreUp - scoreLower
	....;q:valuePice=0  // 分母=0 返回
	....set sRate = (scoreUp - scoreLower)/valuePice
	....;// 趋高H ----------------------
	....if (KPIExtreMum="H")  do
	.....;write "HRate = ",sRate,!
	.....;//区间法I 趋高H : 在区间2和3之间 
	.....if (actValue>= valueLower) &&(actValue<=valueUp) do 
	......set ScoreValue = scoreLower + ((actValue-valueLower)*sRate)
	......;write "IH = ",ScoreValue," sc=",scoreLower,"scp=",scoreUp," acvvl=",actValue,"valueLower=",valueLower,!
	.....;//区间法I 趋高H :在区间1, 和按区间2的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	.....if (actValue < baseValue) && (rangeDr=1)&&(tValue-baseValue)'=0 do 
	......set ScoreValue = scoreLower + ((actValue-valueLower)*scorePice/(tValue-baseValue)) 
	......if (ScoreValue < scoreLower) do 
	.......set ScoreValue = scoreLower
	.....;//区间法I 趋高H :在区间4, 和按区间3的数值增幅和区间1的分数形成的斜率计算，低于最低分，结果为最低分。
	.....if (actValue > bValue) && (rangeDr=4) && (bValue-tValue)'=0 do 
	......set ScoreValue = ((actValue-valueLower)*scorePice)/(bValue-tValue)  
	......if ( ScoreValue > scoreUp) do 
	.......set ScoreValue = scoreUp
	....;//趋中M--------------------------
	....if (KPIExtreMum="M") do 
	.....;//区间法I 趋中M : 在区间2和3之间 
	.....if (actValue >= valueLower) &&(actValue <= valueUp) do 
	......set ScoreValue = scoreLower +((actValue-valueLower)*sRate)
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
	..;//直接扣分处理 20140623
	..if KPIMethod="K" do
	...set ScoreValue=actValue
	..;/// save score-----------------------------------------	
	..if (ScoreValue'="")  do
	...if (isTop=1) && (ScoreValue>fullScore) do  
	....set ScoreValue = fullScore   // 如果分数封顶，超过满分的为满分:scoreVlaue
	...if ScoreValue<0 do
	....set ScoreValue = 0
	...;if ComMethodAudit=1 do  // add 2012-0-09 zxy 
	....;set ScoreValue=ScoreValue*rate/100
	...;w $P(Curr,"^",12),!
	...set $P(Curr,"^",12) = ScoreValue
	 
	
	...;if KPIMethod'="K" do
	...set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)=Curr
	..;//-----------------------------计算权重
	..;w currStratagemDr_"^"_unitResultChildSub_"^"_MaxLevel,!
	..if ComMethodAudit=0 do
	...d ..CalAuditScoreMain(currStratagemDr,unitResultChildSub,MaxLevel)
	..if ComMethodAudit=1 do // 权重，全表所有 add 2012-02-09  zxy
	...d ..ComputeKPIScoreMinusLevel(currStratagemDr, unitResultChildSub,1)
		
	TCOMMIT
	
	q "true"
}

/// Creator:刘洋
/// CreatDate:2012-11-22
/// Description:指标分数计算(番禺)
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScorePY(1,4,"201204","Q",100,1,1)
ClassMethod ComputeKPIScorePY(currStratagemDr, unitResultChildSub, period, PType, fullScore, isTop, ComMethodAudit) As %String
{
  	new (currStratagemDr,unitResultChildSub,period,PType,fullScore, isTop,ComMethodAudit)

  	TSTART	
  		
  	set URDSub=0
  	set ScoreValue  = 0  
   
  	Set MaxLevel=0
  	for  set URDSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)) q:URDSub=""  d
	.set ScoreValue  = 0
	.set Curr =""
	.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub))
	.if Curr'="" do 
	..;set isTarget 	 = $P(Curr,"^",4) //判断是维度还是指标
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
	..set KPIExtreMum= $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",9)   //获得极值
	..set mlevel 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",22) 
	..set mTAddRate 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",6)
	..set calculationDr 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",28)  //扣分法计算方式
	..if (mlevel> MaxLevel ) do
	...;//记录指标最大级别
	...set MaxLevel= mlevel  
	
	..;/// -----------'D':扣分法 ------------------------------------
	..if (KPIMethod ="D")  do
	...set URDAddSub=""
	...for  set URDAddSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub)) q:URDAddSub=""  d
	....set KPIAddRec=0
	....set fm=1  
	....set KPIAddRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub))
	....if KPIAddRec'="" do
	.....set addChangeValue  = $p(KPIAddRec,"^",2)   // 获得增减值
	.....set addScore		 = $p(KPIAddRec,"^",3)   // 获得增减分


	.....;///增长率计算 （趋高趋低）
	.....if (calculationDr=1)&&(KPIExtreMum="H")||(KPIExtreMum="L") && (addChangeValue'=0) do 
	......set atValue=actValue-tValue
	......if atValue<0 set atValue=atValue*-1
	......set ScoreValue =  atValue*addScore/(addChangeValue)
	......set ScoreValue = rate - ScoreValue
	.....;///差额计算
	.....if (calculationDr=2) do 
	......if actValue>0 set actValue=actValue*-1  //实际值应该是扣分数（负数）
	......set ScoreValue = rate + actValue
	.....if (calculationDr=1)&&(KPIExtreMum="H")&&(actValue>tValue)  do 
	......set ScoreValue = rate
	.....if (calculationDr=1)&&(KPIExtreMum="L") && (actValue<tValue) do 
	......set ScoreValue = rate
	
 	..;///'M'目标参照法’  'A'加分法 ---------------------------------------
	..if (KPIMethod ="M")||(KPIMethod ="A")  do
	...set ScoreValue = actValue  
	
	..;//'I':区间法---------------------------------------------------------
	..if (KPIMethod ="I")  do
	...set URDDistSub=""
	...for  set URDDistSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub)) q:URDDistSub=""  d
	....set KPIDistRec=0
	....set KPIDistRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub))
	....quit:KPIDistRec=""   //记录为空返回
	....set valueLower = $p(KPIDistRec,"^",2)
	....set valueUp	= $p(KPIDistRec,"^",3)
	....set scoreLower = $p(KPIDistRec,"^",4)
	....set scoreUp    = $p(KPIDistRec,"^",5)  
	....set rangeDr    = $p(KPIDistRec,"^",6)
	....set valuePice  = valueUp - valueLower
	....set scorePice  = scoreUp - scoreLower
	....;w "123",!
	....;q:valuePice=0  // 分母=0 返回
	....;s valuePice=1 
	....;w valueLower_"^"_valueUp_"^"_scoreLower_"^"_scoreUp_"^"_rangeDr,!
	....;^DHCCJXPASTRATAGEM(1,UnitResultDetailDist
	....;set sRate = (scoreUp - scoreLower)/valuePice
	....;// 趋高H ----------------------baseValue tValue bValue
	....if (KPIExtreMum="H")  do
	.....;write "HRate = ",sRate,!
	.....;//区间法I 趋高H : 在区间1
	.....if (rangeDr= 1) &&(actValue<baseValue) do 
	......set ScoreValue = 0
	......;write "IH = ",ScoreValue," sc=",scoreLower,"scp=",scoreUp," acvvl=",actValue,"valueLower=",valueLower,!
	.....;//区间法I 趋高H :在区间2
	.....if (actValue < tValue) && (rangeDr=2)&&(actValue >= baseValue) do 
	......set ScoreValue = scoreLower 
	.....;//区间法I 趋高H :在区间3
	.....if (actValue < bValue) && (rangeDr=3)&&(actValue >= tValue) do 
	......set ScoreValue = scoreLower
	.....;//区间法I 趋高H : 在区间4
	.....if (rangeDr= 4) &&(actValue>=bValue) do 
	......set ScoreValue = scoreUp
	
	....;//趋中M--------------------------
	....if (KPIExtreMum="M") do 
	.....;//区间法I 趋中M : 在区间2和3之间 
	.....if (actValue >= valueLower) &&(actValue <= valueUp) do 
	......set ScoreValue = scoreLower +((actValue-valueLower)*sRate)
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

	..;/// save score-----------------------------------------	
	..if (ScoreValue'="")  do
	...if (isTop=1) && (ScoreValue>fullScore) do  
	....;set ScoreValue = fullScore   // 如果分数封顶，超过满分的为满分:scoreVlaue
	...if (ScoreValue<0)&&(rate '=0) do
	....set ScoreValue = 0
	...if ComMethodAudit=1 do  // add 2012-0-09 zxy 
	...set $P(Curr,"^",12) = ScoreValue
	...if KPIMethod'="K" do
	....set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)=Curr
	..;//-----------------------------计算权重
	..;w currStratagemDr_"^"_unitResultChildSub_"^"_MaxLevel,!
	..if ComMethodAudit=0 do
	...d ..CalAuditScoreMain(currStratagemDr,unitResultChildSub,MaxLevel)
	..if ComMethodAudit=1 do // 权重，全表所有 add 2012-02-09  zxy
	...d ..ComputeKPIScoreMinusLevel(currStratagemDr, unitResultChildSub,1)
		
	TCOMMIT
	
	q "true"
}

/// Creator:刘洋
/// CreatDate:2013-5-20
/// Description:指标分数计算(武汉一院)
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScorePY(1,4,"201204","Q",100,1,1)
ClassMethod ComputeKPIScoreWHYY(currStratagemDr, unitResultChildSub, period, PType, fullScore, isTop, ComMethodAudit) As %String
{
  	new (currStratagemDr,unitResultChildSub,period,PType,fullScore, isTop,ComMethodAudit)

  	TSTART	
  		
  	set URDSub=0
  	set ScoreValue  = 0  
   
  	Set MaxLevel=0
  	for  set URDSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)) q:URDSub=""  d
	.set ScoreValue  = 0
	.set Curr =""
	.set Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub))
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
	..set KPIExtreMum= $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",9)   //获得极值
	..set mlevel 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",22) 
	..set mTAddRate 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",6)
	..set calculationDr 	 = $P($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",28)  //扣分法计算方式
	..if (mlevel> MaxLevel ) do
	...;//记录指标最大级别
	...set MaxLevel= mlevel  
	
	..;/// -----------'D':扣分法 ------------------------------------
	..if (KPIMethod ="D")  do
	
	
	...;if (KPIDr=119) d       ///临时添加
	...;.;w calculationDr_"^"_KPIExtreMum ,!  
	...;.if actValue>tValue set ScoreValue=0
	...;.e  s ScoreValue=100
 	
 
 
	...set URDAddSub=""
	...;w currStratagemDr_"^"_unitResultChildSub_"^"_URDSub,!
	...for  set URDAddSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub)) q:URDAddSub=""  d
	
	....set KPIAddRec=0
	....set fm=1  
	....set KPIAddRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailAdd",unitResultChildSub,URDSub,URDAddSub))
	
	....if KPIAddRec'="" do
	.....set addChangeValue  = $p(KPIAddRec,"^",2)   // 获得增减值
	.....set addScore		 = $p(KPIAddRec,"^",3)   // 获得增减分

	
	.....;///增长率计算 （趋高趋低）
	.....if (calculationDr=1)&& (addChangeValue'=0) do 
	
	......i KPIExtreMum="H" d
	.......if actValue>=tValue set ScoreValue=100
	.......else  d 
	........set atValue=tValue-actValue
	........set ScoreValue = 100-( atValue*addScore/(addChangeValue)*100/rate)
	
	......e  d

	.......if actValue<=tValue set ScoreValue=100
	.......else  d 
	........set atValue=actValue-tValue
	........set ScoreValue = 100-( atValue*addScore/(addChangeValue)*100/rate)
	
	
	
	.....;///差额计算
	.....if (calculationDr=2) do 
	......if KPIExtreMum="L" d

	.......if actValue>tValue set ScoreValue=0
	.......e  s ScoreValue=100

	
	......e  d
	.......if actValue<tValue set ScoreValue=0
	.......e  s ScoreValue=100
	
	
 	..;///'M'目标参照法’   ---------------------------------------
	..if (KPIMethod ="M")  do
	...i (KPIExtreMum="H")&&(tValue'="") d
	....i (actValue=0)&&(tValue=0) set ScoreValue=100 
	....e  s ScoreValue=actValue/tValue*100 
	
	...i (KPIExtreMum="L")&&(tValue'="")&&(actValue'="") d
	....i actValue'=0 s ScoreValue=tValue/actValue*100 
	....e  s ScoreValue=100
	
	..;//'I':区间法---------------------------------------------------------
	..if (KPIMethod ="I")  do
	...set URDDistSub=""
	...for  set URDDistSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub)) q:URDDistSub=""  d
	....set KPIDistRec=0
	....set KPIDistRec = $G(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResultDetailDist",unitResultChildSub,URDSub,URDDistSub))
	....quit:KPIDistRec=""   //记录为空返回
	....set valueLower = $p(KPIDistRec,"^",2)
	....set valueUp	= $p(KPIDistRec,"^",3)
	....set scoreLower = $p(KPIDistRec,"^",4)
	....set scoreUp    = $p(KPIDistRec,"^",5)  
	....set rangeDr    = $p(KPIDistRec,"^",6)
	....set valuePice  = valueUp - valueLower
	....set scorePice  = scoreUp - scoreLower
	....;w "123",!
	....;q:valuePice=0  // 分母=0 返回
	....;s valuePice=1 
	....;w valueLower_"^"_valueUp_"^"_scoreLower_"^"_scoreUp_"^"_rangeDr,!
	....;^DHCCJXPASTRATAGEM(1,UnitResultDetailDist
	....;set sRate = (scoreUp - scoreLower)/valuePice
	....;// 趋高H ----------------------baseValue tValue bValue
	....if (KPIExtreMum="H")  do
	.....;write "HRate = ",sRate,!
	.....;//区间法I 趋高H : 在区间1
	.....if (rangeDr= 1) &&(actValue<baseValue) do 
	......set ScoreValue = 0
	......;write "IH = ",ScoreValue," sc=",scoreLower,"scp=",scoreUp," acvvl=",actValue,"valueLower=",valueLower,!
	.....;//区间法I 趋高H :在区间2
	.....if (actValue < tValue) && (rangeDr=2)&&(actValue >= baseValue) do 
	......set ScoreValue = scoreLower 
	.....;//区间法I 趋高H :在区间3
	.....if (actValue < bValue) && (rangeDr=3)&&(actValue >= tValue) do 
	......set ScoreValue = scoreLower
	.....;//区间法I 趋高H : 在区间4
	.....if (rangeDr= 4) &&(actValue>=bValue) do 
	......set ScoreValue = scoreUp
	
	....;//趋中M--------------------------
	....if (KPIExtreMum="M") do 
	.....;//区间法I 趋中M : 在区间2和3之间 
	.....if (actValue >= valueLower) &&(actValue <= valueUp) do 
	......set ScoreValue = scoreLower +((actValue-valueLower)*sRate)
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

	..;/// save score-----------------------------------------	
	..if (ScoreValue'="")  do
	...if (isTop=1) && (ScoreValue>fullScore) do  
	....set ScoreValue = fullScore  // 如果分数封顶，超过满分的为满分:scoreVlaue
	...if (ScoreValue<0)&&(rate '=0) do
	....set ScoreValue = 0
	...if ComMethodAudit=1 do  // add 2012-0-09 zxy 
	...set $P(Curr,"^",12) = ScoreValue
	...if KPIMethod'="K" do
	....set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,URDSub)=Curr
	..;//-----------------------------计算权重
	..;w currStratagemDr_"^"_unitResultChildSub_"^"_MaxLevel,!
	..if ComMethodAudit=0 do
	...d ..CalAuditScoreMain(currStratagemDr,unitResultChildSub,MaxLevel)
	..if ComMethodAudit=1 do // 权重，全表所有 add 2012-02-09  zxy
	...d ..ComputeKPIScoreMinusLevel(currStratagemDr, unitResultChildSub,1)
		
	TCOMMIT
	
	q "true"
}

/// Creator:张学燕
/// CreatDate:2012-02-08
/// Description:指标分数计算  计算护理考核， 扣分处理主程序
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreMinusLevel(1,7474,3)
ClassMethod ComputeKPIScoreMinusLevel(currStratagemDr, unitResultChildSub, computeType, KPIMaxLevel)
{
  new (currStratagemDr,unitResultChildSub,computeType,KPIMaxLevel)
  set unitResulparRef=currStratagemDr_"||"_unitResultChildSub
  set curLevel=5
  s unitResultChild=currStratagemDr_"||"_unitResultChildSub
  ;&sql(SELECT UnitResult_schemDr->Schem_ComputeType into :computeType FROM dhc_pa_data.UnitResult WHERE UnitResult_rowid=:unitResultChild)
 	
  if (computeType=3)||(computeType=2) do
  .d ..ComputeKPIScoreMinusLastLevel(currStratagemDr,unitResultChildSub)
 	
 
  if (computeType=1) do
  .for  set curLevel = curLevel-1  q:curLevel<=1  do
  ..;write currStratagemDr_"^"_unitResultChildSub_"^"_curLevel,!
  ..d ..ComputeKPIScoreMinus(currStratagemDr,unitResultChildSub,curLevel,KPIMaxLevel)  //中间级别分数计算
  
  ;w "ComputeKPIScoreMinusLevel",currStratagemDr, unitResultChildSub,"aa"_ computeType,!
  d ..ComputeKPIScoreTop(currStratagemDr,unitResultChildSub) 
  
  
  set rootScore = 0
  ;&sql(select sum(UnitResultDetail_score)  into :rootScore from dhc_pa_data.UnitResultDetail where UnitResultDetail_parRef = :unitResulparRef  and  UnitResultDetail_IsTarget=1 )
  &sql(select sum(UnitResultDetail_score*UnitResultDetail_rate/100)  into :rootScore from dhc_pa_data.UnitResultDetail where UnitResultDetail_parRef = :unitResulparRef  and  UnitResultDetail_IsTarget=1 )
  &sql(Update dhc_pa_data.UnitResult set UnitResult_totalScore=:rootScore where UnitResult_rowid = :unitResulparRef  )
}

/// Creator:张学燕
/// CreatDate:2012-02-08
/// Description:指标分数计算  上级指标总分-扣分
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreMinusLastLevel(1,7474)
ClassMethod ComputeKPIScoreMinusLastLevel(currStratagemDr, unitResultChildSub)
{
  	new (currStratagemDr,unitResultChildSub)
  		 
  	//write currStratagemDr_"^"_unitResultChildSub,!
  
  	// 计算末级扣分
  	
  set unitResulparRef=currStratagemDr_"||"_unitResultChildSub
  	

  	 
  set strSQL ="select UnitResultDetail_rowid,UnitResultDetail_childSub,(isnull(b.UnitResultDetail_tValue,0)+a.actValue )/UnitResultDetail_rate*100  as resVaue "   //2016-07-11 update wy
  set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull(UnitResultDetail_actValue,0)) as actValue "
  set strSQL =strSQL_" FROM dhc_pa_data.UnitResultDetail " 
  set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulparRef_"'"
  ;set strSQL =strSQL_" and  UnitResultDetail_KPIDr->KPIIndex1_isEnd='Y'" 
  set strSQL =strSQL_" group by UnitResultDetail_parRef,UnitResultDetail_parent) a , dhc_pa_data.UnitResultDetail b "
  set strSQL =strSQL_"where a.UnitResultDetail_parRef =b.UnitResultDetail_parRef  and a.UnitResultDetail_parent=b.UnitResultDetail_KPIDr "
  
 
 
 set result=##class(%Library.ResultSet).%New()

 do result.Prepare(strSQL)
 do result.Execute()
 set childSub = 0  
 set rowid = 0
 set resValue=0
 ;b
 While(result.Next()){
	  
	 d ..ComputeKPIScoreMinusLastLevelT(currStratagemDr,unitResultChildSub) //先把非末级的实际值和分值置0	
	 set rowid  = result.Data("UnitResultDetail_rowid")
	 set resValue  = result.Data("resVaue")
	 set childSub  = result.Data("UnitResultDetail_childSub")
	 set resultDetallrRec =""
	 set resultDetallrRec =$g( ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub))
	 if resultDetallrRec '="" {
	  set $P(resultDetallrRec,"^",11)= resValue
	  set $P(resultDetallrRec,"^",12)= resValue
	  set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub)=resultDetallrRec
	  //write "//childSub//",childSub,"//resValue//",resValue,!
	 }
 }
  	
 do result.Close()
}

//w ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreMinusLastLevelT(1,1211)

ClassMethod ComputeKPIScoreMinusLastLevelT(currStratagemDr, unitResultChildSub)
{
  	new (currStratagemDr,unitResultChildSub)
  		 
  	//write currStratagemDr_"^"_unitResultChildSub,!
  
  	// 计算末级扣分
  	
  set unitResulparRef=currStratagemDr_"||"_unitResultChildSub
  	
  set strSQL ="select UnitResultDetail_rowid,UnitResultDetail_childSub,UnitResultDetail_KPIDr FROM dhc_pa_data.UnitResultDetail "
  set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulparRef_"'"
  set strSQL =strSQL_" and  UnitResultDetail_KPIDr->KPIIndex1_isEnd='N'" 

  set result=##class(%Library.ResultSet).%New()

  do result.Prepare(strSQL)
  do result.Execute()
 
 
 While(result.Next()){
	  
	 	
	 set rowid  = result.Data("UnitResultDetail_rowid")
	 set childSub  = result.Data("UnitResultDetail_childSub")
	 set kpi  = result.Data("UnitResultDetail_KPIDr")
	 
	 &sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_actValue=0 where UnitResultDetail_rowid = :rowid  )

	 
 }
  	
	do result.Close()
}

/// Creator:刘洋
/// CreatDate:2012-02-14
/// Description:指标分数计算  上级指标总分
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreMinusLastLevel(1,1898)
ClassMethod ComputeKPIScoreMinusLastLevelLy(currStratagemDr, unitResultChildSub)
{
  	new (currStratagemDr,unitResultChildSub)
  		 
  	//write currStratagemDr_"^"_unitResultChildSub,!
  
  	// 计算末级分数
  	
  	set unitResulparRef=currStratagemDr_"||"_unitResultChildSub
  	 
 	set strSQL ="select UnitResultDetail_rowid,UnitResultDetail_childSub,(a.actValue ) as resVaue "
  	set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull(UnitResultDetail_actValue,0)) as actValue "
  	set strSQL =strSQL_"FROM dhc_pa_data.UnitResultDetail " 
  	set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulparRef_"'"
 
  	set strSQL =strSQL_" and  UnitResultDetail_KPIDr->KPIIndex1_isEnd='Y'" 
  	set strSQL =strSQL_" group by UnitResultDetail_parRef,UnitResultDetail_parent) a , dhc_pa_data.UnitResultDetail b "
    set strSQL =strSQL_"where a.UnitResultDetail_parRef =b.UnitResultDetail_parRef  and a.UnitResultDetail_parent=b.UnitResultDetail_KPIDr "
  
 
  //write strSQL,!
 	set result=##class(%Library.ResultSet).%New()

 	do result.Prepare(strSQL)
 	do result.Execute()
 	set childSub = 0  
 	set rowid = 0
 	set resValue=0
 
 While(result.Next()){
	  
	 	
	 set rowid  = result.Data("UnitResultDetail_rowid")
	 set resValue  = result.Data("resVaue")
	 set childSub  = result.Data("UnitResultDetail_childSub")
	 set resultDetallrRec =""
	 set resultDetallrRec =$g( ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub))
	 if resultDetallrRec '="" {
	  set $P(resultDetallrRec,"^",11)= resValue
	  set $P(resultDetallrRec,"^",12)= resValue
	  set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub)=resultDetallrRec
	  //write "//childSub//",childSub,"//resValue//",resValue,!
	 }
 }
  	
 	do result.Close()
}

/// Creator:张学燕
/// CreatDate:2012-02-08
/// Description:指标分数计算  上级指标总分-扣分  中间级别分数计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreMinus(1,4303,2,3)
ClassMethod ComputeKPIScoreMinus(currStratagemDr, unitResultChildSub, curLevel, KPIMaxLevel)
{
  	new (currStratagemDr,unitResultChildSub,curLevel,KPIMaxLevel)
  		 
  	;write currStratagemDr_"^"_unitResultChildSub_"^curLevel",curLevel,!
  
  	// 计算末级扣分
  	
  set unitResulparRef=currStratagemDr_"||"_unitResultChildSub
  
  i curLevel'=KPIMaxLevel d	 
  .set strSQL ="select b.UnitResultDetail_rowid,UnitResultDetail_childSub,a.scoreValue  "
  .;set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull(UnitResultDetail_score,0)) as scoreValue "
  .set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull(UnitResultDetail_score*UnitResultDetail_rate/100,0)) as scoreValue,UnitResultDetail_isTarget "
  .set strSQL =strSQL_"FROM dhc_pa_data.UnitResultDetail " 
  .set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulparRef_"'"
  .set strSQL =strSQL_"  and  UnitResultDetail_KPIDr->KPIIndex1_level = "_curLevel
  .;set strSQL =strSQL_"   and   UnitResultDetail_KPIDr->KPIIndex1_isEnd='N'  and UnitResultDetail_isTarget=2" 
  .set strSQL =strSQL_"   and UnitResultDetail_isTarget=2" 
  .set strSQL =strSQL_"  group by UnitResultDetail_parRef,UnitResultDetail_parent) a , dhc_pa_data.UnitResultDetail b "
  .set strSQL =strSQL_"where a.UnitResultDetail_parRef =b.UnitResultDetail_parRef  and a.UnitResultDetail_parent=b.UnitResultDetail_KPIDr"  
  .set strSQL =strSQL_" and a.UnitResultDetail_isTarget=b.UnitResultDetail_isTarget" //验证后修改
  
  e  d //2015-04-29 update by wy
  .set strSQL ="select b.UnitResultDetail_rowid,UnitResultDetail_childSub,(isnull(b.UnitResultDetail_tValue,0)+a.scoreValue ) as  scoreValue"
  .;set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull(UnitResultDetail_score,0)) as scoreValue "
  .set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull((isnull(UnitResultDetail_tValue,0)+UnitResultDetail_score)*UnitResultDetail_rate/100,0)) as scoreValue,UnitResultDetail_isTarget "
  .set strSQL =strSQL_"FROM dhc_pa_data.UnitResultDetail " 
  .set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulparRef_"'"
  .set strSQL =strSQL_"  and  UnitResultDetail_KPIDr->KPIIndex1_level = "_curLevel
  .;set strSQL =strSQL_"   and   UnitResultDetail_KPIDr->KPIIndex1_isEnd='N'  and UnitResultDetail_isTarget=2" 
  .set strSQL =strSQL_"   and UnitResultDetail_isTarget=2" 
  .set strSQL =strSQL_"  group by UnitResultDetail_parRef,UnitResultDetail_parent) a , dhc_pa_data.UnitResultDetail b "
  .set strSQL =strSQL_"where a.UnitResultDetail_parRef =b.UnitResultDetail_parRef  and a.UnitResultDetail_parent=b.UnitResultDetail_KPIDr"  
  .set strSQL =strSQL_" and a.UnitResultDetail_isTarget=b.UnitResultDetail_isTarget" //2015-04-29 update by wy

 	;write strSQL,!
 	set result=##class(%Library.ResultSet).%New()
    ;b
 	do result.Prepare(strSQL)
 	do result.Execute()
	set childSub = 0  
 	set rowid = 0
 	set resValue=0

 While(result.Next()){
	  
	 	
	 set rowid  = result.Data("UnitResultDetail_rowid")
	 set resValue  = result.Data("scoreValue")
	 ;w resValue,!
	 set childSub  = result.Data("UnitResultDetail_childSub")
	 set resultDetallrRec =""
	 set resultDetallrRec =$g( ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub))
	 if resultDetallrRec '="" {
	 
	  ;set $P(resultDetallrRec,"^",12)= resValue
	  
	  s resValueRate=resValue*100/$P(resultDetallrRec,"^",10)
	  i resValueRate>100 s resValueRate=100
	  i resValueRate<0  s resValueRate=0
	  set $P(resultDetallrRec,"^",12)= resValueRate
	  i (currStratagemDr_"||"_unitResultChildSub_"||"_childSub="1||4304||9") b
	  set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub)=resultDetallrRec
	  
	  ;write curLevel,"//childSub//",childSub,"//resValueRate//",resValueRate,"//resultDetallrRec//",resultDetallrRec,"//aa//",$P(resultDetallrRec,"^",10),!
	 }
 }
 do result.Close()
}

/// Creator:张学燕
/// CreatDate:2012-02-08
/// Description:指标分数计算  上级指标总分-扣分  维度分数计算分数计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child;period-考核期间;PType-期间类型;fullScore-满分;isTop-
/// Output:
/// Return:
/// w ##class(dhc.pa.udata.uCalculator).ComputeKPIScoreTop(1,"637")
ClassMethod ComputeKPIScoreTop(currStratagemDr, unitResultChildSub)
{
  	new (currStratagemDr,unitResultChildSub)
  		 
  
  	
  set unitResulparRef=currStratagemDr_"||"_unitResultChildSub
  
 	 
  set strSQL ="select UnitResultDetail_rowid,UnitResultDetail_childSub,(a.scoreValue*100/b.UnitResultDetail_rate) as scoreValue "
  set strSQL =strSQL_" from  (SELECT UnitResultDetail_parRef , UnitResultDetail_parent,sum(isnull(UnitResultDetail_score*UnitResultDetail_rate/100,0)) as scoreValue "
  set strSQL =strSQL_"FROM dhc_pa_data.UnitResultDetail " 
  set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulparRef_"'"
  set strSQL =strSQL_" and UnitResultDetail_KPIDr->KPIIndex1_level = 1 and UnitResultDetail_isTarget=2  "
  set strSQL =strSQL_" group by UnitResultDetail_parRef,UnitResultDetail_parent) a , dhc_pa_data.UnitResultDetail b "
  set strSQL =strSQL_"where a.UnitResultDetail_parRef =b.UnitResultDetail_parRef  and a.UnitResultDetail_parent=-b.UnitResultDetail_KPIDr  and  b.UnitResultDetail_isTarget=1"
  
  ;write strSQL,!
 
  set result=##class(%Library.ResultSet).%New()

 do result.Prepare(strSQL)
 do result.Execute()
 set childSub = 0  
 set rowid = 0
 set resValue=0
 
 While(result.Next()){
	  
	 
	 set rowid  = result.Data("UnitResultDetail_rowid")
	 set resValue  = result.Data("scoreValue")
	 set childSub  = result.Data("UnitResultDetail_childSub")
	 set resultDetallrRec =""
	 set resultDetallrRec =$g( ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub))
	 if resultDetallrRec '="" {
	 	
	 
	  set $P(resultDetallrRec,"^",12)= resValue
	  set ^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,childSub)=resultDetallrRec

	 ;write "unitResultChildSub//childSub//",currStratagemDr,"//",unitResultChildSub,"//",childSub,"//resValue//",resValue,!
	 ;write resultDetallrRec, !
	 }
 }

 do result.Close()
}

/// Creator:张学燕
/// CreatDate:2010-9-14
/// Description:指标权重计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).CalAuditScoreMain(2,2,2)
ClassMethod CalAuditScoreMain(currStratagemDr, unitResultChildSub, MaxLevel)
{
 new (currStratagemDr,unitResultChildSub,MaxLevel)
 set curLevel=MaxLevel+1
 set unitResulRowid=currStratagemDr_"||"_unitResultChildSub	
 for  set curLevel = curLevel-1  q:curLevel=0  do
  .;write currStratagemDr_"^"_unitResultChildSub_"^"_curLevel,!
  .d ..CalAuditScore(currStratagemDr,unitResultChildSub,curLevel)
  
  
 set rootScore = 0
 &sql(select sum(((UnitResultDetail_rate/100)*UnitResultDetail_score))  into :rootScore from dhc_pa_data.UnitResultDetail where UnitResultDetail_parRef = :unitResulRowid  and  UnitResultDetail_IsTarget=1 )
 
 &sql(Update dhc_pa_data.UnitResult set UnitResult_totalScore=:rootScore where UnitResult_rowid = :unitResulRowid  )
}

/// Creator:张学燕
/// CreatDate:2010-9-14
/// Description:指标权重计算
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).CalAuditScore(1,652,3)
ClassMethod CalAuditScore(currStratagemDr, unitResultChildSub, curLevel)
{
 new (currStratagemDr,unitResultChildSub,curLevel)
 set unitResulRowid=currStratagemDr_"||"_unitResultChildSub
 ;w currStratagemDr,unitResultChildSub,curLevel

 set strSQL ="SELECT UnitResultDetail_parRef,  UnitResultDetail_KPIDr->KPIIndex1_level, "
 set strSQL = strSQL_" UnitResultDetail_rowid,UnitResultDetail_isTarget, UnitResultDetail_rate,UnitResultDetail_score , UnitResultDetail_parent "
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
 ;b
 While(result.Next()){
	 if num=0 
	 { 
	 	set parentID = result.Data("UnitResultDetail_parent")
	 	set num = 1 
	 }
	 set rowid  = result.Data("UnitResultDetail_rowid")
	 set rate  = result.Data("UnitResultDetail_rate")
	 set score = result.Data("UnitResultDetail_score")
	 if parentID =result.Data("UnitResultDetail_parent") 
	{		
		
		set RScore = RScore+(rate*score/100)  //
		;w 222_"!"_rowid_"_"_parentID_"_"_rate_"_"_score_"_"_RScore,"_",TarLevel,"_",curLevel,!
	}
	else 
	{
		if parentID<0 
	 	{ 
	 		set parentID = parentID*(-1)
	 	}
	
		&sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:RScore  where UnitResultDetail_parRef = :unitResulRowid  and UnitResultDetail_KPIDr =:parentID and UnitResultDetail_isTarget=:TarLevel)	
		set parentID = result.Data("UnitResultDetail_parent")
		set RScore   = (rate*score/100)
	
	}
 }

 if parentID<0 
{ 
	 set parentID = parentID*(-1)
}
 ;w RScore,"^"_unitResulRowid,"^"_parentID,"^"_TarLevel,!
 &sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:RScore  where UnitResultDetail_parRef = :unitResulRowid  and UnitResultDetail_KPIDr =:parentID and  UnitResultDetail_isTarget= :TarLevel )

 do result.Close()
}

/// Creator:张学燕
/// CreatDate:2012-02-08
/// Description:二级考评表向上级考核结果
/// Table:
/// Input:currStratagemDr-当前战略Dr;unitResultChildSub-绩效单元考核主表Child
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).ComputeScoreToUpSchem(1,242,"201501", "1||6",4,"24,25,26","1||1,1||12")
ClassMethod ComputeScoreToUpSchem(currStratagemDr, urChild, newPeriod, schemDr, UnitDr, UpKPIDrs, UpSchem)
{
 new (currStratagemDr,urChild,newPeriod, schemDr,UnitDr,UpKPIDrs,UpSchem)

 set unitResulPardef=currStratagemDr_"||"_urChild	
 set strSQL = ""
 

  set strSQL =" SELECT  UnitResultDetail_KPIDr,UnitResultDetail_score "
  set strSQL =strSQL_"FROM dhc_pa_data.UnitResultDetail " 
  set strSQL =strSQL_" where UnitResultDetail_parRef = "_"'"_unitResulPardef_"'" 
  set strSQL =strSQL_"  and UnitResultDetail_KPIDr  in ( "_UpKPIDrs _" )"
  set strSQL =strSQL_"   and UnitResultDetail_isTarget=2"
  set KPITy="2"
  set result=##class(%Library.ResultSet).%New()
  do result.Prepare(strSQL)
  do result.Execute()
  While(result.Next()){

	 set KPIDr  = result.Data("UnitResultDetail_KPIDr")
	 set ScoreValue  = result.Data("UnitResultDetail_score")

	s cuSchem = ""
	s ind = 1
	
	for  set cuSchem= $P(UpSchem,",",ind) q:cuSchem=""  do 
	 .&sql(select UnitResult_rowid into :mRowID  from  dhc_pa_data.UnitResult where UnitResult_schemDr=:cuSchem  and UnitResult_jxUnitDr=:UnitDr and UnitResult_period=:newPeriod  )
     .;&sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:ScoreValue,UnitResultDetail_actValue=:ScoreValue where UnitResultDetail_isTarget=:KPITy and   UnitResultDetail_KPIDr = :KPIDr and UnitResultDetail_parRef =:mRowID )
     .&sql(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_actValue=:ScoreValue where UnitResultDetail_isTarget=:KPITy and   UnitResultDetail_KPIDr = :KPIDr and UnitResultDetail_parRef =:mRowID )
   
     .set ind=ind+1
 
  }
  	
  do result.Close()
}

/// Creator:李明忠
/// CreatDate:2010-9-3
/// Description:全部计算
/// Table:
/// Input:cycleDr-考核周期Dr;frequency-期间类型;period-期间
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).AllCal()
ClassMethod AllCal() As %String
{
	//获取当前战略
	s currStratagemDr=..GetCurrStratagemDr()
	q:currStratagemDr="" "NoStratagem"
	
	//获取当前战略的年度
	s cycleDr="",currMonth=""
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(currStratagemDr))'="" d
	..s cycleDr=$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",2)
	..s currMonth=$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",8)
	q:cycleDr="" "NoCycle"
	q:currMonth="" "NoCurrMonth"
	
	//根据当前战略获取方案
	s schemDrStr=..GetSchemOfCurrStratagemDr(currStratagemDr)
	s Len=$L(schemDrStr,"^")
	
	s allInfoStr="",flag="true"
	
	TSTART
	
	//根据方案处理业务逻辑
	f k=1:1:Len d
	.s schemDr=$P(schemDrStr,"^",k)
	.i schemDr'="" d
	..;根据方案获取报告频率
	..s freq=..GetFreq(schemDr)
	..i freq'="" d
	...;获取期间
	...s newPeriodStr=..GetNewPeriod(cycleDr,currMonth,freq)
	...s Length=$L(newPeriodStr,"^")
	...f m=1:1:Length d
	....s newPeriod=$P(newPeriodStr,"^",m)
	....i newPeriod'="" d
	.....;根据方案查询绩效单元
	.....s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	.....s jxUnitDrLen=$L(jxUnitDrStr,"^")
	.....f n=1:1:jxUnitDrLen d
	......s jxUnitDr=$P(jxUnitDrStr,"^",n)
	......i jxUnitDr'="" d
	.......;根据方案获取KPI指标
	.......s KPIDrStr=..GetKPIOfSchem(schemDr)
	.......s KPIDrLen=$L(KPIDrStr,"^")
	.......f i=1:1:KPIDrLen d
	........s KPIDr=$P(KPIDrStr,"^",i)
	........i KPIDr'="" d
	.........;绩效单元、KPI指标都不为空,可以处理业务流程
	.........;1.获取指标名称、收集方式
	.........s KPIName=""
	.........s colTypeDr=""
	.........i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	..........i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	...........s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	...........s colTypeDr=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",12)
	.........;2.判断指标的收集方式:1-录入、2-计算、3-无实际值、4-采集
	.........;w colTypeDr_"^"_schemDr_"^"_freq_"^"_newPeriod_"^"_jxUnitDr_"^"_KPIDr_"^"_KPIName,!
	.........i (colTypeDr=1)||(colTypeDr=3)||(colTypeDr=4) d
	..........;2.1 非计算类指标直接处理
	..........s Flag=..DealNotCal(jxUnitDr,newPeriod,freq,schemDr,KPIDr)
	..........i Flag'="true" s flag="false"
	.........i colTypeDr=2  d
	..........;2.2 计算类指标先计算该指标值再处理
	..........;2.2.1 获取该指标的计算公式
	..........s expression=..GetKPIExpression(KPIDr)
	..........i expression'="" d
	...........;2.2.2 调用公式转换方法
	...........s expression=..TransStr(expression,jxUnitDr,newPeriod,freq)
	..........s tmp=newPeriod_"^"_schemDr_"^"_jxUnitDr_"^"_KPIDr_"^"_KPIName_"^"_expression
	..........i allInfoStr="" s allInfoStr=tmp
	..........e  s allInfoStr=allInfoStr_"!"_tmp

	i flag="false" d
	.TRollBack
	e  d
	.TCOMMIT
	
	q allInfoStr_"%"_flag
}

/// Creator：李明忠
/// CreatDate：2010-9-3
/// Description:根据方案获取报告频率
/// Table：dhc_pa_data.Schem
/// Input：schemDr-绩效方案Dr
/// Output：
/// Return：绩效方案的报告频率
/// Others：w ##class(dhc.pa.udata.uCalculator).GetFreq("1||2")
ClassMethod GetFreq(schemDr) As %String
{
	n (schemDr)
	
	q:schemDr="" "NoSchem"
	s currStratagemDr=$P(schemDr,"||",1)
	s schemChild=$P(schemDr,"||",2)
	
	//初始化报告频率
	s freq=""
	
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",schemChild)) d
	.i $G(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",schemChild))'="" d
	..s freq=$P(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",schemChild),"^",5)
		
	q freq
}

/// Creator：李明忠
/// CreatDate：2010-9-3
/// Description:根据当前战略的年度、当前月份、报告频率获取新的考核期间
/// Table：dhc_pa_data.Schem
/// Input：cycleDr-当前战略年度;currMonth-当前月份;freq-报告频率
/// Output：
/// Return：考核期间字符串
/// Others：w ##class(dhc.pa.udata.uCalculator).GetNewPeriod(1,1,"M")
ClassMethod GetNewPeriod(cycleDr, currMonth, freq) As %String
{
	n (cycleDr,currMonth,freq)
	
	q:cycleDr="" "NoCycle"
	q:currMonth="" "NoCurrMonth"
	q:freq="" "NoFreq"
	
	//初始化期间字符串
	s newPeriodStr=""
	
	i freq="M" d //月份
	.;生成当前月份至12月数据数量Count
	.s Count=13-currMonth
	.f i=1:1:Count d
	..s period=(currMonth+i-1)
	..s newPeriod=..GetCycle(cycleDr,period)
	..i newPeriodStr="" s newPeriodStr=newPeriod
	..e  s newPeriodStr=newPeriodStr_"^"_newPeriod
	
	i freq="Q" d //季度
	.;获取当前季度至第四季度数据数量Count
	.s Count=..GetCount(currMonth)
	.;根据当前月份获取起始季度
	.s startQuarter=..GetStartQuarter(currMonth)
	.f i=1:1:Count d
	..s period=(startQuarter+i-1)
	..s newPeriod=..GetCycle(cycleDr,period)
	..i newPeriodStr="" s newPeriodStr=newPeriod
	..e  s newPeriodStr=newPeriodStr_"^"_newPeriod
	
	i freq="H" d //半年
	.;生成当前所属半年至下半年数据数量Count
	.i currMonth<7 s Count=2
	.e  s Count=1
	.;根据当前月份获取起始半年期间
	.s startHalfYear=..GetStartHalfYear(currMonth)
	.f i=1:1:Count d
	..s period=(startHalfYear+i-1)
	..s newPeriod=..GetCycle(cycleDr,period)
	..i newPeriodStr="" s newPeriodStr=newPeriod
	..e  s newPeriodStr=newPeriodStr_"^"_newPeriod
	
	i freq="Y" d //年
	.s period="0" 
	.s newPeriod=..GetCycle(cycleDr,period)
	.i newPeriodStr="" s newPeriodStr=newPeriod
	.e  s newPeriodStr=newPeriodStr_"^"_newPeriod
	
	q newPeriodStr
}

/// Creator：李明忠
/// CreatDate：2010-9-3
/// Description: 根据当前月获取生成季度数量的Count
/// Table：
/// Input：currMonth-当前月
/// Output：
/// Return：返回数量Count
/// Others：w ##class(dhc.pa.udata.uCalculator).GetCount(4)
ClassMethod GetCount(currMonth) As %String
{
	n (currMonth)
	
	s Count=0
	
	q:currMonth="" Count
	
	i (currMonth=1)||(currMonth=2)||(currMonth=3) s Count=4
	i (currMonth=4)||(currMonth=5)||(currMonth=6) s Count=3
	i (currMonth=7)||(currMonth=8)||(currMonth=9) s Count=2
	i (currMonth=10)||(currMonth=11)||(currMonth=12) s Count=1
	
	q Count
}

/// Creator：李明忠
/// CreatDate：2010-9-3
/// Description: 获取起始季度
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：起始季度
/// Others：w ##class(dhc.pa.udata.uCalculator).GetStartQuarter(4)
ClassMethod GetStartQuarter(currMonth) As %String
{
	n (currMonth)
	
	i $L(currMonth/3)=1 s startQuarter=currMonth/3
	e  d
	.i $E(currMonth/3,1)="." s startQuarter=1
	.e  s startQuarter=$E(currMonth/3,1)+1
	
	q startQuarter
}

/// Creator：李明忠
/// CreatDate：2010-9-3
/// Description: 获取起始半年期间
/// Table：
/// Input：currMonth-当前月份
/// Output：
/// Return：起始半年期间
/// Others：w ##class(dhc.pa.udata.uCalculator).GetStartHalfYear(4)
ClassMethod GetStartHalfYear(currMonth) As %String
{
	n (currMonth)
	
	i $L(currMonth/6)=1 s startHalfYear=currMonth/6
	e  d
	.i $E(currMonth/6,1)="." s startHalfYear=1
	.e  s startHalfYear=$E(currMonth/6,1)+1
	
	q startHalfYear
}

/// Creator:李明忠
/// CreatDate:2010-9-13
/// Description:全部考核分计算
/// Table:
/// Input:cycleDr-考核周期Dr
/// Output:
/// Return:返回计算后正确或错误的结果标志
/// Others:w ##class(dhc.pa.udata.uCalculator).AllAssScoreCal(1)
ClassMethod AllAssScoreCal(cycleDr) As %String
{
	n (cycleDr)
	
	q:cycleDr="" "NoCycle"
	//获取当前战略
	s currStratagemDr=..GetCurrStratagemDr()
	q:CurrStratagemDr="" "NoCurrStratagem"
	
	s currMonth=""
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(currStratagemDr))'="" d
	..s currMonth=$P(^DHCCJXPASTRATAGEM(currStratagemDr),"^",8)
	q:currMonth="" "NoCurrMonth"
	
	//根据当前战略获取方案
	s schemDrStr=..GetSchemOfCurrStratagemDr(currStratagemDr)
	s Len=$L(schemDrStr,"^")
	
	//初始化变量
	set fullScore = 100
	set isTop = 0
	&sql(SELECT Param_value INTO :pValue FROM dhc_pa_data.Param WHERE Param_Code='0201' )
	if (pValue = 0) d
	.set fullScore = 100
	else  d
	.set fullScore = 1000
	
	///获得是否分数限制标志
	&sql(SELECT Param_value INTO :isTop FROM dhc_pa_data.Param WHERE Param_Code='0202' )
	
	TSTART
	
	s flag="true"
	
	//根据方案处理业务逻辑
	f k=1:1:Len d
	.s schemDr=$P(schemDrStr,"^",k)
	.i schemDr'="" d
	..;根据方案获取报告频率
	..s freq=..GetFreq(schemDr)
	..i freq'="" d
	...;获取期间
	...s newPeriodStr=..GetNewPeriod(cycleDr,currMonth,freq)
	...s Length=$L(newPeriodStr,"^")
	...f m=1:1:Length d
	....s newPeriod=$P(newPeriodStr,"^",m)
	....i newPeriod'="" d
	.....i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult")) d
	......s urChild=0
	......f  s urChild=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",urChild)) q:urChild=""  d
	.......s flag=..ComputeKPIScore(currStratagemDr,urChild,newPeriod,freq,fullScore,isTop)
	
	q flag
}

//w ##class(dhc.pa.udata.uCalculator).AllAssScoreCalWY(22)

ClassMethod AllAssScoreCalWY(cycleDr) As %String
{
	n (cycleDr)
	q $name(cycleDr)
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uCalculatorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
