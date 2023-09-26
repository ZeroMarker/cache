Class dhc.pa.udata.uSchemDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-08-06
/// Description: 查询符合条件的指标记录
/// Table：dhc_pa_data.SchemDetail
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSchemDetail).List("","","","","","","1||1","roo")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parRef, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,parRef, parent)
	;w "123",!
	s schem = $p(parRef,"||",1)
	s schemSub = $p(parRef,"||",2)
	s parRef = "'"_parRef_"'"
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	s tmpID = ""
	i (parent'="")&&(parRef'="") d
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
	.b
	.s sqlStr="SELECT SchemDetail_rowid,SchemDetail_parRef,SchemDetail_order,SchemDetail_KPIDr,SchemDetail_isTarget,SchemDetail_rate,SchemDetail_parent FROM dhc_pa_data.SchemDetail,dhc_pa_data.KPIIndex1"
	.s whereStr=" WHERE SchemDetail_KPIDr=KPIIndex1_rowid and SchemDetail_parRef="_parRef
	.s whereStr=whereStr_" AND SchemDetail_parent ='"_parent_"'"

	s sortStr="",sortField1=""
	i sortField'="" d
	.;i sortField="rowid" s sortField1="SchemDetail_rowid"
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
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	;i (tmpEnd'="N")||(parent=0) d
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
		//集体初始化
		s KPIIndexName="", KPICode="",method="",Flag="",methodeCode="",calUnitDr="",calUnitName="",expName="",expression="",colDeptDr="",colDeptName="",target="",isEnd="",parName=""
		
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
		...i $g(^DHCCJXPAKPIINDEX1(KPI))'="" d
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
		.i parent'="" d
		..s par=$p(parent,"-",2)
		..i par="" d 
		...i $d(^DHCCJXPAKPIINDEX1(parent)) d
		....i $g(^DHCCJXPAKPIINDEX1(parent))'="" d
		.....s parName=$P(^DHCCJXPAKPIINDEX1(parent),"^",2)
		..e  d
		...i $d(^DHCCJXPADIMENSTYPE(par)) d
		....i $g(^DHCCJXPADIMENSTYPE(par))'="" d
		.....s parName=$P(^DHCCJXPADIMENSTYPE(par),"^",2)
		
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
		
		//收集单位
		i colDeptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(colDeptDr)) d
		..i $G(^DHCCJXPAJXUNIT(colDeptDr))'="" d
		...s colDeptName=$P(^DHCCJXPAJXUNIT(colDeptDr),"^",3)

		i rate="" s rate=0
		;w "rowid="_rowid,"order="_order," KPICode="_KPICode," KPIIndexName="_KPIIndexName,"method="_method,"rate="_rate,"isTarget="_isTarget,"colDeptName="_colDeptName,!
		s resultString=resultString_"{id:'"_KPI_"',detailid:'"_rowid_"',code:'"_KPICode_"',name:'"_KPIIndexName_"',method:'"_method_"',order:'"_order_"',rate:'"_$fn(rate,"",2)_"%',isEnd:'"_isEnd_"',isTarget:'"_isTarget_"',colDeptName:'"_colDeptName_"',par:'"_parent_"',target:'"_target_"',expName:'"_expName_"',calUnitName:'"_calUnitName_"',parName:'"_parName_"',leaf:"_Flag_",uiProvider:'col'},"
	}
		
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator: wang ying
/// CreatDate:  2010-08-02
/// Description: 插入新记录
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetail).Insert("1||1^4")
/// w ##class(dhc.pa.udata.uSchemDetail).Insert("1||1^284")
ClassMethod Insert(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s BSC = ""
		s parRef=$p(data,"^",1)
		s KPIID=$p(data,"^",2)
		s len = $l(KPIID,"-")
		
		s $ZT="ERRO"
		TSTART
		f i=1:1:len d
		  .s KPI = $P(KPIID,"-",i)
		  
		  .s parentAll= ..getParent(KPI)
		  .s par=""
		  .i parentAll'="" d
		  ..s par = $P(parentAll,"^",2)
		  .;w "parentAll="_parentAll,!
		  .i KPI'="" d
		  
		  ..s BSC = $p($g(^DHCCJXPAKPIINDEX1(KPI)),"^",5)
		 
		  .i par ="" d
		  ..s par = "-"_BSC
		  .s data = parRef_"^"_KPI_"^"_2_"^"_par
		  
 		  .s isTarget = $p(data,"^",3)
 		
          .s BSCData = parRef_"^"_BSC_"^"_1_"^"_0
		 
		  .s rowid=0
		 
		  .s rowid=..IfRepKPI(parRef,BSC,1)
		  
		  .i rowid =0 d
		  ..s SQLCODE= ..InsertBSC(BSCData)
		  .s len = $l(parentAll,"^")
		  
		  .f j=2:1:len d
		    ..s parent = $p(parentAll,"^",j)
		    ..s parKPI = $p(parentAll,"^",j+1)
		    ..i j=len d
		    ...s parentData =  parRef_"^"_parent_"^"_2_"^"_"-"_BSC
		    ..e  d
		    ...s parentData =  parRef_"^"_parent_"^"_2_"^"_parKPI
		    ..;w "parentData="_parentData,! 
		    ..s id = 0
		    ..;w parRef,parent,!
		    ..s id = ..IfRepKPI(parRef,parent,2)
		    ..i id = 0 d
		    ...;w "hello"
		    ...s SQLCODE= ..InsertBSC(parentData)
		 .;w "data="_data,!
		 .s endRowid = ..IfRepKPI(parRef,KPI,2)
		 .i endRowid = 0 d
		 ..s SQLCODE= ..InsertBSC(data)
		If SQLCODE TROLLBACK
		TCOMMIT	
		q SQLCODE

ERRO
    Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator: wang ying
/// CreatDate:  2010-08-03
/// Description: 插入单条记录
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetail).InsertBSC("2||5^3^1^0")
ClassMethod InsertBSC(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		//parRef_"^"_par_"^2^-"_dim 
		s parRef=$p(data,"^",1)
		s KPI=$p(data,"^",2)
 		s isTarget = $p(data,"^",3)
 		s par = $p(data,"^",4)

		
		i parRef'="" s PLIST(0)=parRef
		i KPI'="" s PLIST(4)=KPI
		i isTarget'="" s PLIST(5)=isTarget
		i par'="" s PLIST(7)=par
		s PLIST(6)=100
	
		&sql(INSERT INTO dhc_pa_data.SchemDetail VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate:  2010-08-02
/// Description: 插入新记录
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetail).getParent(24)
ClassMethod getParent(KPI) As %String
{
	
	n (KPI)
	s parent = KPI
	s parentAll = KPI
	f  s parent = $p($g(^DHCCJXPAKPIINDEX1(parent)),"^",21) q:(parent=0)||(parent="")  d
	.s parentAll = parentAll_"^"_parent
    q parentAll
}

/// Creator: wang ying
/// CreatDate: 2010-08-03
/// Description: KPI指标是否存在
/// Table: dhc.pa.data.SchemDetail
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uSchemDetail).IfRepKPI("1||18",26,2)
ClassMethod IfRepKPI(parRef, KPI, flag) As %String
{
	
	n (parRef,KPI,flag)
	
	s schem = $p(parRef,"||",1)
	s schemsub = $p(parRef,"||",2)
	s rowid=0
	;w 0,"SchemDetailTarget",schem,flag,KPI,schemsub,rowid,!
	s rowid=$o(^DHCCJXPASTRATAGEM(0,"SchemDetailTarget",schem,flag,KPI,schemsub,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：wang ying
/// CreatDate：2010-08-04
/// Description: 获取末层KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uSchemDetail).GetKPIs(0,10,"","1||1")
ClassMethod GetKPIs(start, limit, str, schem) As %String
{
	n (start, limit, str,schem)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'"
	i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '"_str_"%'"
	s sqlStr = sqlStr_"and NOT EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid = dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef="_"'"_schem_"')"
	//%ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2011-04-19
/// Description: 获取末层KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uSchemDetail).GetNotEndKPI(0,10,"","35")
ClassMethod GetNotEndKPI(start, limit, str, par) As %String
{
	n (start, limit, str,par)
	s result = ##class(%Library.ResultSet).%New()
	s parent=$p(par,"-",2)
	i parent="" d
	.s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='N'"
	.i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '"_str_"%'"
	e  d
	.s sqlStr = "SELECT DimensType_rowid,DimensType_name FROM dhc_pa_data.DimensType where %ID>0 "
	..i str'="" s sqlStr = sqlStr_" and DimensType_shortcut LIKE '"_str_"%'"
	;s sqlStr = sqlStr_"and NOT EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid = dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef="_"'"_schem_"')"
	//%ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='N'
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		i parent="" d
		.s rowid = result.Data("KPIIndex1_rowid")
		.s name = result.Data("KPIIndex1_name")
		e  d
		.s rowid = result.Data("DimensType_rowid")
		.s name = result.Data("DimensType_name")
		
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-08-09
/// Description: 更新权重记录
/// Table: dhc.pa.data.SchemDetail
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetail).UpdateRate(1,"0101^指标级别^3-2-2-2^2")
ClassMethod UpdateRate(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		s rateStr=$p(data,"%",1)		
		s rate=$p(rateStr,"^",1)
				
		s PLIST(6)=rateStr
				
		&SQL(UPDATE dhc_pa_data.SchemDetail VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-08-09
/// Description: 更新顺序记录
/// Table: dhc.pa.data.SchemDetail
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetail).UpdateOrder(1,"0101^指标级别^3-2-2-2^2")
ClassMethod UpdateOrder(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
				
		s order=$p(data,"^",1)
				
		s PLIST(3)=order
				
		&SQL(UPDATE dhc_pa_data.SchemDetail VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2011-04-19
/// Description: 更新父级关系
/// Table: dhc.pa.data.SchemDetail
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchemDetail).UpdatePar("2||1||27","79^79")
ClassMethod UpdatePar(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		s stragem = $p(rowid,"||",1)
		s schem = $p(rowid,"||",2)
		s schemDetail = $p(rowid,"||",3) 
		s par=$p(data,"^",1)
		s supPar=$p(data,"^",2)
		s parent=$p(supPar,"-",2)
		
        s $ZT="ERROPAR"
		TSTART
		s data=""
		s parRef=""
		i parent="" d
		.i (stragem'="")&&(schem'="")&&(schemDetail'="")	d
		..s parRef=stragem_"||"_schem
		..i $d(^DHCCJXPASTRATAGEM(stragem,"SchemDetail",schem,schemDetail)) d
		...s kpiDr=$p($g(^DHCCJXPASTRATAGEM(stragem,"SchemDetail",schem,schemDetail)),"^",2)
		...i kpiDr'="" d
		....;w "kpiDr="_kpiDr,!
		....i $d(^DHCCJXPAKPIINDEX1(kpiDr)) d
		.....s dim=$p($g(^DHCCJXPAKPIINDEX1(kpiDr)),"^",5)
		.....i '$d(^DHCCJXPASTRATAGEM(0,"SchemDetailTarget",stragem,1,dim,schem)) d
		......s BSCData=parRef_"^"_dim_"^1^0" 
		......;w BSCData,!
		......d ..InsertBSC(BSCData)
		.....i '$d(^DHCCJXPASTRATAGEM(0,"SchemDetailTarget",stragem,2,par,schem)) d
		......s data=parRef_"^"_par_"^2^-"_dim 
		......;w "data="_data,!
		......d ..InsertBSC(data)
		.s KPIPar=par
		e  d
		.i (stragem'="")&&(schem'="")&&(schemDetail'="")	d
		..s parRef=stragem_"||"_schem
		..i '$d(^DHCCJXPASTRATAGEM(0,"SchemDetailTarget",stragem,1,par,schem)) d
		...s BSCData=parRef_"^"_par_"^1^0"
		...d ..InsertBSC(BSCData) 
		.s KPIPar="-"_par
		;s KPIPar=79
		;w rowid,KPIPar,!
		&SQL(UPDATE dhc_pa_data.SchemDetail set SchemDetail_parent=:KPIPar where %ID=:rowid)
		
		d ..deletePar(parRef,supPar)
		If SQLCODE TROLLBACK
		TCOMMIT	
		q SQLCODE
ERROPAR
    Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

ClassMethod deletePar(parRef, supPar) As %String
{
  	s flag=0
  	w supPar,!
  	i '$D(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",stragem,supPar,schem)) d
	.i $p(supPar,"-",2)'="" d
	..s supPar=$p(supPar,"-",2)
	..s flag=1
	.;w supPar,!
	.&SQL(delete from dhc_pa_data.SchemDetail where SchemDetail_parRef=:parRef and SchemDetail_KPIDr=:supPar)
	.i flag'=1 d
	..i $D(^DHCCJXPAKPIINDEX1(supPar))  d
	...s par=$p($G(^DHCCJXPAKPIINDEX1(supPar)),"^",21)
	...d ..deletePar(parRef,par)
}

/// Creator: wang ying
/// CreatDate:  2010-08-02
/// Description: 插入新记录
/// Table: dhc.pa.data.SchemDetail
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchemDetail).Insert("1||4^21,24^2")
/// w ##class(dhc.pa.udata.uSchemDetail).InsertTest("1||2^4,5,6,7,9^2")
ClassMethod InsertTest(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s BSC = ""
		s parRef=$p(data,"^",1)
		s KPIID=$p(data,"^",2)
		s len = $l(KPIID,",")
		s $ZT="InsetERRO"
		TSTART
		f i=1:1:len d
		  .s KPI = $P(KPIID,",",i)
		  .;w i,"KPI="_KPI,!
		  .s parentAll= ..getParent(KPI)
		  .s par=""
		  .i parentAll'="" d
		  ..s par = $P(parentAll,"^",2)
		  .;w "parentAll="_parentAll,!
		  .i KPI'="" d
		  ..s BSC = $p($g(^DHCCJXPAKPIINDEX1(KPI)),"^",5)
		  .i par ="" d
		  ..s par = "-"_BSC
		  .s data = parRef_"^"_KPI_"^"_2_"^"_par
		  
 		  .s isTarget = $p(data,"^",3)
 		
          .s BSCData = parRef_"^"_BSC_"^"_1_"^"_0
		
		  . s rowid=0
		  .s rowid=..IfRepKPI(parRef,BSC,1)
		  .i rowid =0 d
		  ..s SQLCODE= ..InsertBSC(BSCData)
		  .s len = $l(parentAll,"^")
		  .f j=2:1:len d
		    ..s parent = $p(parentAll,"^",j)
		    ..s parKPI = $p(parentAll,"^",j+1)
		    ..i j=len d
		    ...s parentData =  parRef_"^"_parent_"^"_2_"^"_"-"_BSC
		    ..e  d
		    ...s parentData =  parRef_"^"_parent_"^"_2_"^"_parKPI
		    ..;w "parentData="_parentData,! 
		    ..s id = 0
		    ..;w parRef,parent,!
		    ..s id = ..IfRepKPI(parRef,parent,2)
		    ..i id = 0 d
		    ...;w "hello"
		    ...s SQLCODE= ..InsertBSC(parentData)
		 .;w "data="_data,!
		 .s endRowid = ..IfRepKPI(parRef,KPI,2)
		 .i endRowid = 0 d
		 ..s SQLCODE= ..InsertBSC(data)
		If SQLCODE TROLLBACK
		TCOMMIT	
		q SQLCODE

InsetERRO
    Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator:wang ying
/// CreatDate:2010-11-30
/// Description:删除方案明细记录
/// Table:dhc_pa_data.SchemDetail
/// Input:rowid-方案明细记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uSchemDetail).Delete("1||32||13")
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	q:rowid="" "NoData"
	
	s stratagem = $p(rowid,"||",1)
	s schemSub = $p(rowid,"||",2)
	s schemDetailSub = $p(rowid,"||",3)
	q:stratagem="" "Nostratagem"
	q:schemSub="" "NoschemSub"
	q:schemDetailSub="" "NoData"
	
	
	s KPIDr="",parentID="",isTarget=""
	i $d(^DHCCJXPASTRATAGEM(stratagem,"SchemDetail",schemSub,schemDetailSub)) d
	.s KPIDr = $p($g(^DHCCJXPASTRATAGEM(stratagem,"SchemDetail",schemSub,schemDetailSub)),"^",2)
	.s parentID = $p($g(^DHCCJXPASTRATAGEM(stratagem,"SchemDetail",schemSub,schemDetailSub)),"^",5)
	.i parentID=0 d
	..s KPIDr="-"_KPIDr
	..s isTarget=1
	.e  s isTarget=2
	
	q:KPIDr="" "NoKPIDr"
	q:isTarget="" "NoisTarget"
	
	q:$D(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",stratagem,KPIDr,schemSub)) "childNode"
	s str=""
	//寻找上级节点的ID
	;s parentID=$p($g(^DHCCJXPASTRATAGEM(stratagem,"SchemDetail",schemSub,schemDetailSub)),"^",5)
	
	//1.删除本条记录
	&SQL(delete from dhc_pa_data.SchemDetail where %ID=:rowid)
	s str=SQLCODE
	
	//2.如果该条记录的上级没有其他子节点,则将上级节点删除
	/*
	i $D(^DHCCJXPASTRATAGEM(0,"SchemDetailParent",stratagem,parentID,schemSub)) d
	.;w "noparent"
	e  d
	.;w stratagem,"KPIDr="_KPIDr,"schemSub="_schemSub,!
	.i parentID'=0 d
	..i $d(^DHCCJXPASTRATAGEM(0,"SchemDetailTarget",stratagem,isTarget,parentID,schemSub)) d
	...s detailSub=""
	...s detailSub= $o(^DHCCJXPASTRATAGEM(0,"SchemDetailTarget",stratagem,isTarget,parentID,schemSub,detailSub))
	...s parentRowid = stratagem_"||"_schemSub_"||"_detailSub
	...&SQL(delete from dhc_pa_data.SchemDetail where %ID=:parentRowid)
	...s str=SQLCODE
	*/
	q str
}

/// Creator：wang ying
/// CreatDate：2010-12-01
/// Description: 获取在方案明细中没有的末端KPI记录
/// Table：dhc_pa_data.KPIIndex1
/// Input：userCode-用户代码
/// Output：
/// Return：有效末端KPI记录字符串
/// Others：w ##class(dhc.pa.udata.uSchemDetail).GetEndKPI("demo","1||1")
ClassMethod GetEndKPI(userCode, schem) As %String
{
	n (userCode,schem)
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIAudit_KPIDr from dhc_pa_data.KPIAudit where %ID>0  and KPIAudit_userDr="_userId
    s sqlStr = sqlStr_" and NOT EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIAudit.KPIAudit_KPIDr = dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_isTarget!=1 and SchemDetail_parRef="_"'"_schem_"')"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KPIAudit_KPIDr")
		i KPIDr'="" d 
		.i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
		..i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
		...s KPIName=$P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
		...s tmp=KPIDr_"^"_KPIName
		...s count=count+1
		...d json.InsertRowData(tmp)
		
	}
	d result.Close()
	s resultString = json.getJsonData("KPIDr^KPIName",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemDetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
