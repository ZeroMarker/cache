Class dhc.pa.udata.uSchemList Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-09-09
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSchemList).ListRec(0,25,2,1)
ClassMethod ListRec(start, limit, cycle, str) As %String
{
	n (start,limit,cycle,str)
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	
	s stratagem = 0
	f  s stratagem=$o(^DHCCJXPASTRATAGEM(0,"Cycle",cycle,stratagem)) q:stratagem=""  d
	.s schem=0
	.f  s schem=$o(^DHCCJXPASTRATAGEM(stratagem,"Schem",schem)) q:schem=""  d
	..s schemAll = $g(^DHCCJXPASTRATAGEM(stratagem,"Schem",schem))
	..s rowid = stratagem_"||"_schem
	..s name = $p(schemAll,"^",2)
	..s tmp = rowid_"^"_name
	..s count = count+1
	..i (count>start)&(count<=end) d
	...d json.InsertRowData(tmp)
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

//w ##class(dhc.pa.udata.uSchemList).T()

ClassMethod T() As %String
{
	M ^DHCCJXPACYCLE=^DHCPACYCLE
	k ^DHCPACYCLE
	M ^DHCCJXPACALUNIT=^DHCPACALUNIT
	k ^DHCPACALUNIT
	M ^DHCCJXPADIMENSTYPE=^DHCPADIMENSTYPE
	k ^DHCPADIMENSTYPE
	M ^DHCCJXPAJXGROUP=^DHCPAJXGROUP
	k ^DHCPAJXGROUP
	M ^DHCCJXPAJXLOCTYPE=^DHCPAJXLOCTYPE
	k ^DHCPAJXLOCTYPE
	M ^DHCCJXPAJXUNIT=^DHCPAJXUNIT
	k ^DHCPAJXUNIT
	M ^DHCCJXPAJXUNITAUDIT=^DHCPAJXUNITAUDIT
	k ^DHCPAJXUNITAUDIT
	M ^DHCCJXPAKPIAUDIT=^DHCPAKPIAUDIT
	k ^DHCPAKPIAUDIT
	M ^DHCCJXPAKPIINDEX1=^DHCPAKPIINDEX1
	k ^DHCPAKPIINDEX1
	M ^DHCCJXPAPARAM=^DHCPAPARAM
	k ^DHCPAPARAM
	M ^DHCCJXPASTRATAGEM=^DHCPASTRATAGEM
	k ^DHCPASTRATAGEM
}

/// Creator：李明忠
/// CreatDate：2010-8-10
/// Description: 获取绩效单位
/// Table：dhc_pa_data.UnitSchem
/// Input：start:开始记录位置;limit:单页记录条数;schemDr-方案ID
/// Output：
/// Return：有效绩效单位字符串
/// Others：w ##class(dhc.pa.udata.uSchemList).List(0,25,1,"")
ClassMethod List(start, limit, cycle, str) As %String
{
	n (start, limit, cycle, str)
	q:cycle="" "NoCycle"
	
	s cycleCode=""
	i $d(^DHCCJXPACYCLE(cycle)) d
	.q:$g(^DHCCJXPACYCLE(cycle))=""
	.s cycleCode=$p(^DHCCJXPACYCLE(cycle),"^",1)
	q:cycleCode="" "NocycleCode"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct(UnitResult_schemDr),Schem_Name from dhc_pa_data.UnitResult,dhc_pa_data.Schem"
	s whereStr=" where UnitResult_schemDr=Schem_rowid and UnitResult_period like '"_cycleCode_"%'"
	i str'="" s whereStr=whereStr_" and Schem_Name like '%"_str_"%'"
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		//集体初始化
		s rowid = result.Data("UnitResult_schemDr")
		s name = result.Data("Schem_name")
		s tmp = rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemListS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
