/// Creator: zhang chao
/// CreatDate:  2015-05-12
/// Description: 自查科室设置
Class dhc.pa.udata.uUnitDeptSchem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhang chao
/// CreatDate:  2015-05-12
/// Description: 显示自查定义记录
/// Table:dhc.pa.data.DeptSchem
/// Others: w ##class(dhc.pa.udata.uUnitDeptSchem).SchemList("0","10","M")
ClassMethod SchemList(start, limit, frequency) As %String
{
	n (start,limit,frequency)
	s sqlStr = "SELECT DSC_rowid, DSC_code, DSC_name FROM dhc_pa_data.DeptSchem where  %ID > 0 and DSC_frequency = '"_frequency_"'"
	s count = 0
 	s result=##class(%Library.ResultSet).%New()
 	d result.Prepare(sqlStr)
 	d result.Execute()
 	s resultString = ""
 	s json = ##class(dhc.pa.comm.JsonObj).%New()
 	s jsonTitle = "rowid^code^name"
 	While(result.Next())
 	{
 	s rowid = result.Data("DSC_rowid")
 	s code = result.Data("DSC_code")
 	s name = result.Data("DSC_name")
 	s tmp = rowid_"^"_code_"^"_name
 	s count=count+1
 	d json.InsertRowData(tmp)
 	;w tmp,!
	}
 	d result.Close()
 	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	q resultString
}

/// Creator: zhang chao
/// CreatDate:  2015-05-13
/// Description: 显示科室信息
/// Table:dhc.pa.data.Unitdeptschem
/// Others: w ##class(dhc.pa.udata.uUnitDeptSchem).JXUnitList("name","心","","","0","10","3")
ClassMethod JXUnitList(searchField, searchValue, sortField, sortDir, start, limit, schemDr) As %String
{
	n (searchField, searchValue, sortField, sortDir,start,limit,schemDr)
	
	s sqlStr = "select UDS_rowid,uds_jxunit->JXUnit_code as JXUnit_code,uds_jxunit->JXUnit_name "
	  		 _"as JXUnit_name,uds_jxunit->JXUnit_jxLocTypeDr->JXLocType_name as JXLocType_name from dhc_pa_data.Unitdeptschem where %ID > 0 and UDS_DSchemDr = '"_schemDr_"'"
	
	s sortStr=""
	s sortField1=""
		
	i sortField'="" d
	.i sortField="rowid" s sortField1="UDS_rowid"
	.i sortField="code" s sortField1="JXUnit_code"
    .i sortField="name" s sortField1="JXUnit_name"
	.i sortField="type" s sortField1="JXLocType_name"
	
    i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr="ORDER BY %ID DESC"
		
	s sqlStr=sqlStr_sortStr
	
	s count = 0
	s end=start+limit
 	s result=##class(%Library.ResultSet).%New()
 	d result.Prepare(sqlStr)
 	d result.Execute()
 	s resultString = ""
 	s json = ##class(dhc.pa.comm.JsonObj).%New()
 	s jsonTitle = "rowid^code^name^type"
 	s code="",name="",type=""
 	While(result.Next())
 	{
 	s rowid = result.Data("UDS_rowid")
 	s code = result.Data("JXUnit_code")
 	s name = result.Data("JXUnit_name")
 	s type = result.Data("JXLocType_name")
 	s tmp = rowid_"^"_code_"^"_name_"^"_type
 	i searchValue'="" d
 	
 	.q:(searchField="code")&(code'[searchValue)
	.q:(searchField="name")&(name'[searchValue)
	.q:(searchField="type")&(type'[searchValue)
    .s count=count+1
	 .d json.InsertRowData(tmp)
	e  d
	.s count=count+1
	.i (count>start)&(count<=end) d
	..d json.InsertRowData(tmp)
	}
 	d result.Close()
 	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	q resultString
}

/// Creator: zhang chao
/// CreatDate:  2015-05-13
/// Description: 判断新插入的记录是否存在
/// Table:
/// Others：w ##class(dhc.pa.udata.uUnitDeptSchem).IfRepRecode("5","10")
ClassMethod IfRepRecode(schemDr, parRef) As %String
{
	n (schemDr,parRef)
	
	s childSub="" 
	s childSub = $O(^DHCCJXPAUnitDeptSchemI("DschemDrJXUnit",schemDr,parRef,childSub))
	q childSub
}

/// Creator: zhang chao
/// CreatDate:  2015-05-13
/// Description: 插入新记录
/// Table:dhc_pa_data.Unitdeptschem
/// Others: w ##class(dhc.pa.udata.uUnitDeptSchem).Insert("10-2","8")
ClassMethod Insert(JXUnit, SchemDr) As %String
{
	n (JXUnit,SchemDr)
    k PLIST
	
	s str1=""
	s str2=""
	s Len=$L(JXUnit,"-")
	f k=1:1:Len d
	.s jxUnitDr=$P(JXUnit,"-",k)
	.i jxUnitDr'="" d
	..s tmpRow=..IfRepRecode(SchemDr,jxUnitDr)
	..i tmpRow'="" d
	...i str1="" s str1=tmpRow
	...e  s str1=str1_"-"_tmpRow
	..e  d
	...i jxUnitDr'="" s PLIST(2)=jxUnitDr  
	...i SchemDr'="" s PLIST(3)=SchemDr   
	...&SQL(insert into dhc_pa_data.Unitdeptschem VALUES PLIST())
	...s str2=SQLCODE
	
	q:str1="" str2
	q:str1'="" str1_"^"_str2

	
	;&sql(INSERT INTO dhc_pa_data.Unitdeptschem(UDS_JXUnit,UDS_DSchemDr)VALUES(:JXUnit,:SchemDr))
	;q SQLCODE
}

/// Creator: zhang chao
/// CreatDate:  2015-05-13
/// Description: 删除数据
/// Table:dhc_pa_data.Unitdeptschem
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.Unitdeptschem where UDS_rowid=:rowid)
	q SQLCODE
}

/// Creator: zhang chao
/// CreatDate:  2015-05-13
/// Description: 点击选择科室按钮弹出的复选框显示出没有添加的科室
/// Table:dhc_pa_data.JXUnit,dhc_pa_data.Unitdeptschem
/// Others: w ##class(dhc.pa.udata.uUnitDeptSchem).JXUnitListNEW("0","10","5")
ClassMethod JXUnitListNEW(start, limit, schemDr, userID) As %String
{
	n (start,limit,schemDr,userID)
	s sqlStr = "select JXUnit_rowid,JXUnit_code,JXUnit_name from dhc_pa_data.JXUnit where JXUnit_rowid  not in (select UDS_rowid from dhc_pa_data.Unitdeptschem where  UDS_DSchemDr = '"_schemDr_"')"
	           _" AND JXUnit_rowid IN (SELECT JXUnitAudit_jxUnitDr FROM dhc_pa_data.JXUnitAudit where JXUnitAudit_userDr='"_userID_"')"
	           
	s getAuditUnitStr=##class(dhc.pa.udata.uComm).GetAuditUnitStr("","") //2016-8-4 cyl
	s sqlStr=sqlStr_getAuditUnitStr
	s count = 0
 	s result=##class(%Library.ResultSet).%New()
 	d result.Prepare(sqlStr)
 	d result.Execute()
 	s resultString = ""
 	s json = ##class(dhc.pa.comm.JsonObj).%New()
 	s jsonTitle = "rowid^code^name"
 	While(result.Next())
 	{
 	s rowid = result.Data("JXUnit_rowid")
 	s code = result.Data("JXUnit_code")
 	s name = result.Data("JXUnit_name")
 	s tmp = rowid_"^"_code_"^"_name
 	s count=count+1
 	d json.InsertRowData(tmp)
 	;w tmp,!
	}
 	d result.Close()
 	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	q resultString
}

/// Creator：liu xiao ming
/// CreatDate：2015-5-8
/// Description: 自查初始化
/// Table：dhc_pa_data.DeptSchem, dhc_pa_data.UnitDeptSchem, 
/// Input：
/// Output：
/// Return：DSNodata-自查定义表中没有维护数据  UDSNodata-该自查定义没有设置对应自查科室  DSDNodatav-自查明细表没有数据    Succeed-信息插入自查科室主表和明细表成功
/// Others：w ##class(dhc.pa.udata.uUnitDeptSchem).InitSelCheked("2015","Y","")
ClassMethod InitSelCheked(year, acuttype, acuttypeitem) As %String
{
	n (year, acuttype, acuttypeitem)
	;W "1="_$ZT($P($H,",",2),1),!
	s RebackResult=3
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	
	;如果自查定义表中的某项被删除后，我们将自查科室主表中与该方案相关的记录删除
	&sql(DELETE FROM dhc_pa_data.UnitDeptResult WHERE UDR_DschemDr=
    (SELECT DISTINCT(UDR_DschemDr) FROM dhc_pa_data.UnitDeptResult 
     WHERE UDR_DschemDr not IN (SELECT DSC_rowid FROM dhc_pa_data.DeptSchem)))
	i SQLCODE'=0 d
	.d ##class(dhc.pa.udata.uPALogger).Insert("InitSelCheked^delete","",SQLCODE,"")
	.s RebackResult="false"
	;W "2="_$ZT($P($H,",",2),1),!
	;如果自查定义表中的某项被删除后，我们将自查科室明细表中与该方案相关的记录删除 
	&sql(DELETE FROM dhc_pa_data.UnitDeptResultDetail WHERE UDRD_UDResult NOT IN (SELECT UDR_rowid FROM dhc_pa_data.UnitDeptResult))
	i SQLCODE'=0 d
	.d ##class(dhc.pa.udata.uPALogger).Insert("InitSelCheked^DELETE","",SQLCODE,"")
	.s RebackResult="false"
	;W "3="_$ZT($P($H,",",2),1),!
	//查找自查定义表中记录
	s sqlStr="select DSC_rowid from dhc_pa_data.DeptSchem where DSC_frequency='"_acuttype_"'"
	
	;W "4="_$ZT($P($H,",",2),1),!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s RebackResult=0	
	
	while(result.Next())
	{
		 
		;(自查定义ID)
		s DSCrowid=result.Data("DSC_rowid")
		
	    //判断自查定义表对应自查科室表是否有数据 不存在退出
	    s RebackResult=1	    
	    q:$d(^DHCCJXPAUnitDeptSchemI("DschemDr",DSCrowid))=0  
	    
		//判断自查定义表对应自查明细表是否有数据
		s RebackResult=2
		q:$d(^DHCCJXPADeptSchemDetailI("Schem",DSCrowid))=0
		
		;根据自查定义ID删除(自查科室主表的科室在自查科室表中已经不存在的)科室信息
		&sql(delete from dhc_pa_data.UnitDeptResult where UDR_jxUnitDr not in (select UDS_JXUnit from dhc_pa_data.UnitDeptSchem where UDS_DSchemDr=:DSCrowid) and UDR_DschemDr=:DSCrowid)
		i SQLCODE'=0 d
		.d ##class(dhc.pa.udata.uPALogger).Insert("InitSelCheked^delete",DSCrowid,SQLCODE,"")
		
		;总而言之,假如我们在自查明细表中删除了某些项目或者删除了某些自查科室后，再一次初始化时，我们将自查科室主表、自查明细表中多余的原来的相关信息删除	
		;根据(自查科室表中某些已经被删除ID)或者(自查明细表中已被删除的ID),删除自查科室明细表中符合条件的信息   
		&sql(DELETE FROM dhc_pa_data.UnitDeptResultDetail
				WHERE UDRD_UDResult NOT IN (SELECT UDR_rowid FROM  dhc_pa_data.UnitDeptResult)
				OR UDRD_DsDetailDr NOT IN (SELECT DSD_rowid FROM dhc_pa_data.DeptSchemDetail)
		)
		i SQLCODE'=0 d
		.d ##class(dhc.pa.udata.uPALogger).Insert("InitSelCheked^DELETE","",SQLCODE,"")
		
		;判断初始化期间是否要精确到某月/某季度/半年/00
		i acuttypeitem'="" d
		.;不为空,只初始化某年+某月/某季度/半年/00
	    .s Period=year_$p(data,"^",acuttypeitem) 	//初始化期间
		.s RebackResult=..InitUDRandUDRD(Period, DSCrowid)
		e  d
		.i acuttype="M" d 										;如果"按月"初始化全年的
		..s len=13
		..f i=1:1:len d  
		...s Period=$p(data,"^",i)
		...s Period=year_Period
		...s RebackResult=..InitUDRandUDRD(Period, DSCrowid)
		.i acuttype="Q" d 										;如果"按季度"初始化全年的 
		..s len=5
		..f i=1:1:len d
		...s Period=$p(data,"^",i)
		...s Period=year_Period
		...s RebackResult=..InitUDRandUDRD(Period, DSCrowid)
		.i acuttype="H" d  										;如果"按半年"初始化全年的
		..s len=3
		..f i=1:1:len d
		...s Period=$p(data,"^",i)
		...s Period=year_Period
		...s RebackResult=..InitUDRandUDRD(Period, DSCrowid)
		.i acuttype="Y" d     									;如果"按年"初始化全年的
		..s Period=$p(data,"^",1)
		..s Period=year_Period
		..s RebackResult=..InitUDRandUDRD(Period, DSCrowid)
	
	}
	d result.Close()
	;W "5="_$ZT($P($H,",",2),1),!
	q:RebackResult="false" "false"	
	q:RebackResult=0 "DSCNodata"
	q:RebackResult=1 "UDSNodata"
	q:RebackResult=2 "DSDNodata"
	q:RebackResult=3 "Succeed"
}

/// Creator：liu xiao ming
/// CreatDate：2015-5-12
/// Description: 将初始化记录插入自查科室主表，自查科室明细表
/// Table：dhc_pa_data.UnitDeptResult, dhc_pa_data.UnitDeptResultDetail
/// Input：
/// Output：
/// Return：3-信息插入自查科室主表和明细表成功
/// Others：w ##class(dhc.pa.udata.uDeptSelChekedSet).InitUDRandUDRD("201501","1")
ClassMethod InitUDRandUDRD(Period, DSCrowid) As %String
{
		n (Period, DSCrowid)
		
		s flag=3
		;可以调试用
		;s UDRflag="UDRstart"
		;s UDRDflag="UDRDstart"
		
		;通过自查定义ID在自查科室表中查找对应UDSrowid(自查科室表ID)(一对多)
		s UDSrowid=0
		f  s UDSrowid=$o(^DHCCJXPAUnitDeptSchemI("DschemDr",DSCrowid,UDSrowid)) q:UDSrowid=""  d	
		.;通过UDSrowid查找UDSJXUnit(绩效单元ID)
		.s UDSJXUnit=$list($g(^DHCCJXPAUnitDeptSchemD(UDSrowid)),2)
		.;根据(自查定义ID,绩效单元ID,自查期间)在"自查科室主表"中判断该记录是否已经存在
		.i '$d(^DHCCJXPAUnitDeptResultI("SchemPeriodJXUnit",DSCrowid,UDSJXUnit,Period)) d
		..;不存在将DSCrowid(自查定义ID),UDSJXUnit(绩效单元ID),Period(考核期间),'0'(提交状态),'0'(审核状态)--插入自查科室主表
		..&sql(insert into dhc_pa_data.UnitDeptResult(UDR_DschemDr,UDR_jxUnitDr,UDR_period,UDR_auditState,UDR_submitState) values(:DSCrowid,:UDSJXUnit,:Period,'0','0')) 
		..i SQLCODE'=0 d
		...d ##class(dhc.pa.udata.uPALogger).Insert("InitUDRandUDRD^insert",DSCrowid_"^"_UDSJXUnit_"^"_Period,SQLCODE,"")
		...s flag="false"
		..;如果自查科室主表信息插入成功，取得UDRid(自查科室主表ID)
		..i SQLCODE=0 d		
		...s UDRrowid=%ROWID
		...;s UDRflag="UDRinsertOk"
		.e  d
		..;自查科室主表中记录存在
		..s UDRrowid=0
		..s UDRrowid=$o(^DHCCJXPAUnitDeptResultI("SchemPeriodJXUnit",DSCrowid,UDSJXUnit,Period,UDRrowid))
		..&sql(update dhc_pa_data.UnitDeptResult set UDR_DschemDr=:DSCrowid,UDR_jxUnitDr=:UDSJXUnit,UDR_period=:Period where UDR_rowid=:UDRrowid)  
		..;s UDRflag="UDRupdateOk"
		..i SQLCODE'=0 d
		...d ##class(dhc.pa.udata.uPALogger).Insert("InitUDRandUDRD^update",DSCrowid_"^"_UDSJXUnit_"^"_Period_"^"_UDRrowid,SQLCODE,"")
		...s flag="false"
		.;根据自查定义表ID取自查明细表ID
		.s flag= ##class(dhc.pa.udata.uDeptSelChekedSet).InitUnDeReDe(DSCrowid, UDRrowid)		
         
	    q flag
}

/// Creator：liu xiao ming
/// CreatDate：2015-5-14
/// Description: 初始化自查科室明细表
/// Table：dhc_pa_data.UnitDeptResultDetail
/// Input：
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uDeptSelChekedSet).InitUnDeReDe("201501","1")
ClassMethod InitUnDeReDe(DSCrowid, UDRrowid) As %String
{
	n (DSCrowid, UDRrowid)
	
	;根据自查定义表ID取自查明细表ID
	s DSDrowid=0		
	f  s DSDrowid=$o(^DHCCJXPADeptSchemDetailI("Schem",DSCrowid,DSDrowid)) q:DSDrowid=""  d  	
	.k DSDList
	.s DSDList(2)=UDRrowid
	.s DSDDKPIDr=$list($g(^DHCCJXPADeptSchemDetailD(DSDrowid)),3)
	.q:DSDDKPIDr=0
	.i DSDDKPIDr'="" s DSDList(4)=DSDDKPIDr
	.s DSDorder=$list($g(^DHCCJXPADeptSchemDetailD(DSDrowid)),2)
	.i DSDorder'="" s DSDList(5)=DSDorder
	.s DSDrate=$list($g(^DHCCJXPADeptSchemDetailD(DSDrowid)),4)
	.i DSDrate'="" s DSDList(6)=DSDrate
	.s DSDparent=$list($g(^DHCCJXPADeptSchemDetailD(DSDrowid)),5)
	.i DSDparent'="" s DSDList(10)=DSDparent
	.;根据UDRrowid(自查科室主表ID),DSDDKPIDr(自查项目ID)在自查科室明细表中判断该记录是否存在
	.i '$d(^DHCCJXPAUnitDepResultDetailI("unitDeptResultDKPI",UDRrowid,DSDDKPIDr)) d
	..;不存在,将UDRD_UDResult(自查科室主表ID),UDRD_DsDetailDr(自查明细表ID),UDRD_DKPIDr(自查项目表ID),UDRD_order(顺序号),UDRD_rate(扣分系数),UDRD_parent(上级项目ID)插入自查科室明细表 	
	..&sql(INSERT into dhc_pa_data.UnitDeptResultDetail(UDRD_UDResult,UDRD_DsDetailDr,UDRD_DKPIDr,UDRD_order,UDRD_rate,UDRD_parent) values(:UDRrowid,:DSDrowid,:DSDDKPIDr,:DSDorder,:DSDrate,:DSDparent))		
	..;s UDRDflag="UDRDinsertOK"
	..i SQLCODE'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("InitUnDeReDe^INSERT",UDRrowid_"^"_DSDrowid_"^"_DSDDKPIDr_"^"_DSDorder_"^"_DSDrate_"^"_DSDparent,SQLCODE,"")
	.e  d
	..s UDRDrowid=0
	..s UDRDrowid=$o(^DHCCJXPAUnitDepResultDetailI("unitDeptResultDKPI",UDRrowid,DSDDKPIDr,UDRDrowid))
	..&sql(UPDATE dhc_pa_data.UnitDeptResultDetail values DSDList() where UDRD_rowid=:UDRDrowid)
	..;s UDRDflag="UDRDupdateOK"
	..i SQLCODE'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("InitUnDeReDe^UPDATE",UDRDrowid,SQLCODE,"")
	;测试该函数用
	;q UDRflag_"^"_UDRDflag 
	;q 0
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUnitDeptSchemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
