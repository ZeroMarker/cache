Class dhc.pa.udata.uSchemDetailAdd Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-08-10
/// Description: 查询符合条件的指标记录
/// Table：dhc.pa.data.SchemDetailAdd
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSchemDetailAdd).List("","","","",0,25,"13||1","roo")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parRef, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,parRef, parent)
	
	s schem = $p(parRef,"||",1)
	s schemSub = $p(parRef,"||",2)
	s parRef = "'"_parRef_"'"
	
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	s tmpID = ""
	i parent'="" d
	.i $D(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",schem,parent,schemSub)) d
	..s tmpID = $o(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",schem,parent,schemSub,tmpID))
	..i $G(^DHCCJXPASTRATAGEM(schem,"SchemDetail",schemSub,tmpID))'="" s tmpEnd=$P(^DHCCJXPASTRATAGEM(schem,"SchemDetail",schemSub,tmpID),"^",5)
	..e  s tmpEnd="N"
	
	//SQL
	i parent=0 d
	.s sqlStr="SELECT SchemDetail_rowid,SchemDetail_parRef,SchemDetail_order,SchemDetail_KPIDr,SchemDetail_isTarget,SchemDetail_rate,SchemDetail_parent FROM dhc_pa_data.SchemDetail,dhc_pa_data.DimensType "
	.s whereStr=" WHERE SchemDetail_KPIDr=DimensType_rowid  and SchemDetail_parRef="_parRef
	.s whereStr=whereStr_" AND SchemDetail_parent ='"_parent_"'"
	e  d
	.s sqlStr="SELECT SchemDetail_rowid,SchemDetail_parRef,SchemDetail_order,SchemDetail_KPIDr,SchemDetail_isTarget,SchemDetail_rate,SchemDetail_parent FROM dhc_pa_data.SchemDetail,dhc_pa_data.KPIIndex1"
	.s whereStr=" WHERE SchemDetail_KPIDr=KPIIndex1_rowid and SchemDetail_parRef="_parRef
	.s whereStr=whereStr_" AND SchemDetail_parent ='"_parent_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="SchemDetail_rowid"
	.i sortField="order" s sortField1="SchemDetail_order"
	.i sortField="name" s sortField1="SchemDetail_KPIDr"
	.i sortField="isTarget" s sortField1="SchemDetail_isTarget"
	.i sortField="rate" s sortField1="SchemDetail_rate"
	.i sortField="parent" s sortField1="SchemDetail_parent"
	
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  i parent'=0  s sortStr=" ORDER BY KPIIndex1_code ASC"
	e  s sortStr=" ORDER BY DimensType_code ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,"tmpEnd="_tmpEnd,!
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	i (tmpEnd'="N")||(parent=0) d
	.d result.Prepare(sqlStr)
	.d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s KPIIndexName="", KPICode="",method="",Flag="",methodeCode="",calUnitDr="",calUnitName="",expName="",expression="",colDeptDr="",colDeptName="",target="",detailAdd="",addflag="",changeValue="",score="",addRowid="",colTypeDr="",baseValue="",base=""
		
		s rowid = result.Data("SchemDetail_rowid")
		s order = result.Data("SchemDetail_order")
		s isTarget = result.Data("SchemDetail_isTarget")
		s KPI = result.Data("SchemDetail_KPIDr")
		s rate = result.Data("SchemDetail_rate")
		s parent = result.Data("SchemDetail_parent")
		
		i isTarget=1 d
		.i KPI'="" d
		..i $d(^DHCCJXPADIMENSTYPE(KPI)) d
		...i $g(^DHCCJXPADIMENSTYPE(KPI)) d
		....s KPIIndexName = $P(^DHCCJXPADIMENSTYPE(KPI),"^",2)
		....s KPICode = $P(^DHCCJXPADIMENSTYPE(KPI),"^",1)
		....s KPI = "-"_KPI
		....s Flag = "false"
		
		i isTarget=2 d
		.i KPI'="" d
		..i $d(^DHCCJXPAKPIINDEX1(KPI)) d
		...i $g(^DHCCJXPAKPIINDEX1(KPI)) d
		....s KPIIndexName = $P(^DHCCJXPAKPIINDEX1(KPI),"^",2)
		....s KPICode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",1)
		....s methodeCode = $P(^DHCCJXPAKPIINDEX1(KPI),"^",13)
		....s expression = $P(^DHCCJXPAKPIINDEX1(KPI),"^",10)
		....s calUnitDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",8)
		....s target =  $P(^DHCCJXPAKPIINDEX1(KPI),"^",6)
		....s colDeptDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",14)
		....s isEnd = $P(^DHCCJXPAKPIINDEX1(KPI),"^",24)
		....i isEnd = "Y" s Flag = "true"
		....i isEnd = "N" s Flag = "false"
		....s calculationDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",28)  //计算方式(扣分法)
		....s colTypeDr = $P(^DHCCJXPAKPIINDEX1(KPI),"^",12)  //收集方式
		
		s detailSub = $p(rowid,"||",3)
		s schemDetailAdd = ""
		s schemDetailAdd = $o(^DHCCJXPASTRATAGEM(schem,"SchemDetailAdd",schemSub,detailSub,schemDetailAdd))
		i (schemDetailAdd="")&&((methodeCode="D")||(methodeCode="A")) d
		.s sqlcode = ..Insert(rowid,methodeCode)
		.s schemDetailAdd=1
		i schemDetailAdd'="" d
		.;w "schemDetailAdd="_schemDetailAdd,!
		.;w $g(^DHCCJXPASTRATAGEM(schem,"SchemDetailAdd",schemSub,detailSub,schemDetailAdd)),!
		.;w "schemDetailAdd="_schemDetailAdd,!
		.s detailAdd = $g(^DHCCJXPASTRATAGEM(schem,"SchemDetailAdd",schemSub,detailSub,schemDetailAdd))
		.;w "schem="_schem,"schemSub="_schemSub,"detailSub="_detailSub,!
		.i detailAdd'="" d
		..s addRowid = schem_"||"_schemSub_"||"_detailSub_"||"_schemDetailAdd
		..i ((methodeCode'="D")&&(methodeCode'="A")) d
		...;w "methodeCode="_methodeCode,!
		...k ^DHCCJXPASTRATAGEM(0,"SchemDetailAddFlag",schemSub,methodeCode)
		...k ^DHCCJXPASTRATAGEM(schem,"SchemDetailAdd",schemSub,detailSub,schemDetailAdd)
		...;w "DHCPASTRATAGEM(0,'SchemDetailAddFlag',"_schemSub_","_methodeCode_")",!
		...s detailAdd=$g(^DHCCJXPASTRATAGEM(schem,"SchemDetailAdd",schemSub,detailSub,schemDetailAdd))
		..;w detailAdd,!
		..s addflag = $p(detailAdd,"^",1)
		..s changeValue = $p(detailAdd,"^",2)
		..s score = $p(detailAdd,"^",3)
		..s baseValue = $p(detailAdd,"^",4)
		..s base =  $p(detailAdd,"^",5)
		
		
		//评分方法
		i methodeCode = "I" s method = "区间法"
		i methodeCode = "C" s method = "比较法"
		i methodeCode = "D" s method = "扣分法"
	    i methodeCode = "A" s method = "加分法"
		i methodeCode = "M" s method = "目标参照法"
		i methodeCode = "K" s method = "实际值法"
		
		//表达式解析
		i expression'="" d
		.s expression=$E(expression,2,$L(expression)-1)
		.s expName=##class(dhc.pa.udata.uKPIIndex).TransStr(expression) //解析表达式(用于显示)

        //计量单位
		i calUnitDr'="" d
		.i $D(^DHCCJXPACALUNIT(calUnitDr)) d
		..i $G(^DHCCJXPACALUNIT(calUnitDr)) d
		...s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
		
		
		//计算方式(扣分法)
	
		s calculationName=""
		
	
		i calUnitDr'="" d 
		.i calculationDr=1 s calculationName="增长率计算"
		.i calculationDr=2 s calculationName="差额计算"
		
		
		s colTypeName=""
		//收集方式
		
		i colTypeDr'="" d 
		.i colTypeDr=1 s colTypeName="录入"
		.i colTypeDr=2 s colTypeName="计算"
		.i colTypeDr=3 s colTypeName="无实际值"
		.i colTypeDr=4 s colTypeName="采集"
		
		//收集单位
		//收集单位
		i colDeptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(colDeptDr)) d
		..i $G(^DHCCJXPAJXUNIT(colDeptDr))'="" d
		...s colDeptName=$P(^DHCCJXPAJXUNIT(colDeptDr),"^",3)
		i rate="" s rate=0
		;w "rowid="_rowid,"order="_order," KPICode="_KPICode," KPIIndexName="_KPIIndexName,"method="_method,"rate="_rate,"isTarget="_isTarget,"colDeptName="_colDeptName,!
		s resultString=resultString_"{id:'"_KPI_"',detailid:'"_addRowid_"',code:'"_KPICode_"',name:'"_KPIIndexName_"',method:'"_method_"',changeValue:'"_$fn(changeValue,"",2)_"',score:'"_$fn(score,"",2)_"',baseValue:'"_baseValue_"',base:'"_base_"',methodeCode:'"_methodeCode_"',order:'"_order_"',rate:'"_rate_"%',isTarget:'"_isTarget_"',colDeptName:'"_colDeptName_"',par:'"_parent_"',target:'"_target_"',expName:'"_expName_"',calUnitName:'"_calUnitName_"',leaf:"_Flag_",uiProvider:'col',calculationName:'"_calculationName_"',colTypeName:'"_colTypeName_"'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-08-10
/// Description: 更新加减记录
/// Table: dhc.pa.data.SchemDetailAdd
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailAdd).Update("1||4||6||1","D^5.00^1.00")
ClassMethod Update(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
	    s schem = $p(rowid,"||",1)
	    s schemsub = $p(rowid,"||",2)
	    s schemdetail = $p(rowid,"||",3)
	    s par = schem_"||"_schemsub_"||"_schemdetail
	    
				
		s addflag=$p(data,"^",1)
		s changeValue = $p(data,"^",3)
		s score = $p(data,"^",2)
		s base = $p(data,"^",4)	
		s baseValue = $p(data,"^",5)
		;w addflag_"^"_changeValue_"^"_score,!
		s PLIST(0)=par
		s PLIST(3)=addflag
		s PLIST(4)=changeValue
		s PLIST(5)=score
		s PLIST(6)=base
		s PLIST(7)=baseValue
				
		&SQL(UPDATE dhc_pa_data.SchemDetailAdd VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-08-10
/// Description: 更新加减记录
/// Table: dhc.pa.data.SchemDetailAdd
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetailAdd).Insert("1||6||3","D^20^2")
ClassMethod Insert(par, data) As %String
{
		n (par,data)
		
		k PLIST
		q:data="" "EmptyRecData"
				
		s addflag=$p(data,"^",1)
		s changeValue = $p(data,"^",2)
		s score = $p(data,"^",3)
		s base = $p(data,"^",4)	
		s baseValue = $p(data,"^",5)	
		
		s PLIST(0)=par
		s PLIST(3)=addflag
		s PLIST(4)=changeValue
		s PLIST(5)=score
		s PLIST(6)=base
		s PLIST(7)=baseValue
				
		&sql(INSERT INTO dhc_pa_data.SchemDetailAdd VALUES PLIST())
		q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemDetailAddS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
