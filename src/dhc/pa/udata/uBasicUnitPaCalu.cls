/// 基层科室绩效考核计算
/// creator:胡苗
/// date：2015-05
Class dhc.pa.udata.uBasicUnitPaCalu Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//主页面上半部分list--显示有审核权限的方案，和是否末级方案没关系

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).ListMainRec("","","","demo",0,25)
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).ListMainRec("2016","Q","02","demo","","",0,25)
ClassMethod ListMainRec(year, periodType, period, userCode, schemDr, state, start, limit) As %String
{
    n (year,periodType,period,userCode,schemDr,state,start, limit)
    
    //获取当前战略
	s Stratagem = ""
	s curreStratagemDr = ""
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...if curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	
	i (year'="")&&(period'="") d
	.s yearperiod=$e(year,1,4)_period
	
	s result = ##class(%Library.ResultSet).%New()
	//b ;1
	s sqlStr = "select Schem_rowid,Schem_frequency,Schem_code,Schem_name,Schem_appSysDr,Schem_KPIDr,Schem_active,"
	           _"Schem_level,Schem_UpSchemDr,Schem_flag,Schem_shortcut,SPR_rowid,SPR_auditDr,SPR_auditDate,SPR_auditState,SPR_Desc,SPR_period,SCM_DeptDr"
	           _" from dhc_pa_data.Schem,dhc_pa_data.SchemAudit,dhc_pa_data.Schem_Perid_Rec,dhc_pa_data.schem_MDept where Schem_rowid>0 and Schem_active='Y' and  SAudit_SchemDr=Schem_rowid  and  SAudit_userDr ="_userId_""
               _" and SPR_appSysDr = Schem_appSysDr and SPR_schemDr = Schem_rowid  and SPR_parRef = Schem_parRef AND SCM_UserDR=SAudit_userDr"
               _" and SCM_SchemDR = Schem_rowid "
               _" and Schem_childSub>0 and Schem_parRef = '"_curreStratagemDr_"' "
               _" and (Schem_UpSchemDr IS NOT NULL OR Schem_UpSchemDr!='') "
    i periodType'="" d
    .s sqlStr=sqlStr_" and Schem_frequency='"_periodType_"' "
    i period'="" d
    .s sqlStr=sqlStr_" and SPR_period = '"_yearperiod_"' "
    i schemDr'="" d
    .s sqlStr=sqlStr_" and Schem_rowid = '"_schemDr_"' "
   	i state=0 {
    s sqlStr=sqlStr_" and (SPR_auditState = '"_state_"' or SPR_auditState is null) "}
    elseif state'="" {
    s sqlStr=sqlStr_" and SPR_auditState = '"_state_"' "
    }
	d result.Prepare(sqlStr)
	d result.Execute()
	
	;s ^hjghkhkgban =sqlStr
    //b ;2
	s count=0
	s resultString=""
	s end=start+limit-1
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="schemrowid^sprrowid^yearid^schemcode^schemname^checkperiodType^checkperiodTypeName^checkperiod^auditor^auditstateid^auditdate^auditstate^auditdesc^maininfo^GroupDr^changedperiod"
	
	While(result.Next()){
		s (auditor,auditstate,yearperiod,yearid,changedperiod,checkperiodTypeName)=""
		s maininfo="考核汇总表"

		s schemrowid = result.Data("Schem_rowid")
		s sprrowid = result.Data("SPR_rowid")
		s schemcode = result.Data("Schem_code")
		s schemname = result.Data("Schem_name")
		s checkperiodType = result.Data("Schem_frequency")
	
		i checkperiodType="M" s checkperiodTypeName="月"
		i checkperiodType="Q" s checkperiodTypeName="季"
		i checkperiodType="Y" s checkperiodTypeName="年"
		i checkperiodType="H" s checkperiodTypeName="半年"
	
	    s checkperiod = result.Data("SPR_period")
	    i checkperiod'="" d
	    .s yearperiod=$e(checkperiod,1,4)
	    .&sql(select Cycle_rowid into :yearid from dhc_pa_data.Cycle where Cycle_active='Y' and Cycle_code=:yearperiod)
	    .i checkperiodType = "M" d
	    ..s m =$e(checkperiod,5,5)
	    ..i m="0" s changedperiod=$e(checkperiod,6,6)
	    ..else  s changedperiod=$e(checkperiod,5,6)
	    .i checkperiodType = "Q" d
	    ..s l =$e(checkperiod,5,5)
	    ..i l="0" s changedperiod=$e(checkperiod,6,6)
	    ..else  s changedperiod=$e(checkperiod,5,6)
	    .i checkperiodType = "H" d
	    ..s n =$e(checkperiod,5,5)
	    ..i n="0" s changedperiod=$e(checkperiod,6,6)
	    ..else  s changedperiod=$e(checkperiod,5,6)
	    .i checkperiodType = "Y" d
	    ..s k =$e(checkperiod,5,5)
	    ..i k="0" s changedperiod=$e(checkperiod,6,6)
	    ..else  s changedperiod=$e(checkperiod,5,6)
    
		s auditordr = result.Data("SPR_auditDr")
		i auditordr'="" d
		.i $d(^SSU("SSUSR",auditordr)) d
		..s auditor=$P(^SSU("SSUSR",auditordr),"^",2)
	
		s auditdate = result.Data("SPR_auditDate")
		i auditdate'="" s auditdate=$zdt(auditdate,8)
	
		s auditstateid = result.Data("SPR_auditState")
		i ((auditstateid=0)||(auditstateid=""))  s auditstate="未提交"
		i auditstateid=10 s auditstate="审核未通过"
		i auditstateid=20 s auditstate="已提交"
		i auditstateid=30 s auditstate="审核通过"
		i auditstateid=60 s auditstate="发布"
	
		s auditdesc = result.Data("SPR_Desc")
	
		s GroupDr = result.Data("SCM_DeptDr")
	
		s tmp=schemrowid_"^"_sprrowid_"^"_yearid_"^"_schemcode_"^"_schemname_"^"_checkperiodType_"^"_checkperiodTypeName_"^"_checkperiod_"^"_auditor_"^"_auditstateid_"^"_auditdate_"^"_auditstate_"^"_auditdesc_"^"_maininfo_"^"_GroupDr_"^"_changedperiod
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

//主页面上半部分状态链接

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).ListStates("121",0,25)
ClassMethod ListStates(schemrowid, start, limit) As %String
{
    n (schemrowid,start,limit)
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select SPRC_Rowid,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType "
	           _" from dhc_pa_data.Schem_Perid_RecChkProc "
               _" where SPRC_ShemPeridRecDR = '"_schemrowid_"' "
    
    ;w sqlStr ,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end=start+limit-1
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="periodchkrowid^chercker^cherckdate^chkresult^chkprocdesc^desc^chkdeptname"
	
	While(result.Next()){
	s (chercker,chkresult,chkdeptname)=""
	
	s periodchkrowid = result.Data("SPRC_Rowid")
	s cherckerdr = result.Data("SPRC_Chercker")
	i cherckerdr'="" d
	.i $d(^SSU("SSUSR",cherckerdr)) d
	..s chercker=$P(^SSU("SSUSR",cherckerdr),"^",2)
	
	s cherckdate = result.Data("SPRC_DateTime")
	i cherckdate'="" s cherckdate=$ZDATETIME(cherckdate,1)
	
	s chkresultid = result.Data("SPRC_ChkResult")
	i chkresultid=0  s chkresult="未提交"
	i chkresultid=10 s chkresult="审核未通过"
	i chkresultid=20 s chkresult="已提交"
	i chkresultid=30 s chkresult="审核通过"
	i chkresultid=60 s chkresult="发布"
	
	s chkprocdesc = result.Data("SPRC_ChkProcDesc")
	s desc = result.Data("SPRC_Desc")

	s chkdeptrowid = result.Data("SPRC_DeptDR")
	i chkdeptrowid'="" d
	.i $d(^DHCCJXPAJXUNIT(chkdeptrowid)) d
	..s chkdeptname=$p($g(^DHCCJXPAJXUNIT(chkdeptrowid)),"^",3)
	
	s tmp=periodchkrowid_"^"_chercker_"^"_cherckdate_"^"_chkresult_"^"_chkprocdesc_"^"_desc_"^"_chkdeptname
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

//提交按钮

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Submit("1||9","1","","","345","345","102")
ClassMethod Submit(schemrowid, sprrowid, userid, date, result, procdesc, desc, deptdr) As %String
{
    n (schemrowid,sprrowid,userid,date,result,procdesc,desc,deptdr)
    s state="20"
    s result="20"
    //s date=$ZDATETIME($h,1)
    s date = $p($h,",",1)
    s deptdr = ""
    &sql(update dhc_pa_data.Schem_Perid_Rec set SPR_auditDr=:userid,SPR_auditDate =:date,SPR_auditState=:result,SPR_Desc=:desc where SPR_rowid = :sprrowid )
    &sql(select SCM_DeptDr into :deptdr from dhc_pa_data.schem_MDept where SCM_SchemDR=:schemrowid and SCM_UserDR =:userid)
    &sql(insert into dhc_pa_data.Schem_Perid_RecChkProc (SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR) values (:schemrowid,:userid,:date,:result,:procdesc,:desc,:deptdr))
    
    q SQLCODE
}

//取消提交按钮

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).ListMainRec("","","","","","",0,25)
ClassMethod CancelSubmit(schemrowid, sprrowid, period, userid, date, result, procdesc, desc, deptdr) As %String
{
    n (schemrowid,sprrowid,userid,date,result,procdesc,desc,deptdr)
    s state="0"
    s result="0"
    s date=$p($h,",",1)
    s deptdr=""
    
    &sql(update dhc_pa_data.Schem_Perid_Rec set SPR_auditDr=:userid,SPR_auditDate =:date,SPR_auditState=:result,SPR_Desc=:desc where SPR_rowid = :sprrowid )
    &sql(select SCM_DeptDr into :deptdr from dhc_pa_data.schem_MDept where SCM_SchemDR=:schemrowid and SCM_UserDR =:userid)
    &sql(insert into dhc_pa_data.Schem_Perid_RecChkProc (SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR) values (:schemrowid,:userid,:date,:result,:procdesc,:desc,:deptdr))
    
    q SQLCODE
}

//计算

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Calu("6","Q","2","1||6","demo")
ClassMethod Calu(cycleDr, frequency, period, schemDr, userCode) As %String
{
   n (cycleDr, frequency, period, schemDr,userCode)
   d ##class(dhc.pa.udata.uCalculator).setAllActValue(cycleDr, frequency, period, schemDr,userCode)
   d ##class(dhc.pa.udata.uCalculator).AssScoreCalAll(cycleDr, frequency, period, schemDr, userCode)
   q 0
}

//方案对应KPI List

/// Creator：wang ying
/// CreatDate：2010-08-06
/// Description: 查询符合条件的指标记录
/// Table：dhc_pa_data.SchemDetail
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSchemDetail).List("","","","","","","1||1","roo")
ClassMethod ListKPI(searchField, searchValue, sortField, sortDir, start, limit, parRef, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,parRef, parent)

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

	s resultString="["

	s result=##class(%Library.ResultSet).%New()

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

//各绩效单元本期指标编辑

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).ListURRecs("1||10",27,"201601",6,30)
ClassMethod ListURRecs(schemrowid, kpidr, period, start, limit) As %String
{
    n (schemrowid,kpidr,period,start,limit)
    
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select distinct UnitResult_rowid,UnitResult_jxUnitDr,UnitResult_period,UnitResultDetail_rowid,UnitResultDetail_KPIDr,UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_estDesc,UnitResultDetail_rate,UnitResultDetail_Rscore "
	           _" from dhc_pa_data.UnitResult left join dhc_pa_data.UnitResultDetail on UnitResultDetail_parRef = UnitResult_rowid "
               _" where UnitResult_rowid>0 and UnitResultDetail_isTarget=2  "
    i schemrowid'="" d
    .s sqlStr = sqlStr_" and UnitResult_schemDr = '"_schemrowid_"' "
    i kpidr'="" d
    .s sqlStr = sqlStr_ " and UnitResultDetail_KPIDr = '"_kpidr_"' "
    i period'="" d
    .s sqlStr = sqlStr_ " and UnitResult_period = '"_period_"' "
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end=start+limit-1
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="mainrowid^detailrowid^urperiod^urdeptname^kpiname^targetvalue^actvalue^score^Rscore^estdesc^ratedvalue^methodname^detailinfo^iscolType"
	//b ;1
	While(result.Next()){
	s (urdeptname,methodeCode,methodname,ratedvalue,iscolType)=""
	s detailinfo = "明细"
	
	s mainrowid = result.Data("UnitResult_rowid")
	s detailrowid = result.Data("UnitResultDetail_rowid")
	s urperiod = result.Data("UnitResult_period")
	s urdeptdr = result.Data("UnitResult_jxUnitDr")
	i urdeptdr'="" d
	.i $d(^DHCCJXPAJXUNIT(urdeptdr)) d
	..s urdeptname=$p($g(^DHCCJXPAJXUNIT(urdeptdr)),"^",3)
	
	s KPIDR = result.Data("UnitResultDetail_KPIDr")
	i KPIDR'="" d
	.s kpiname = $P(^DHCCJXPAKPIINDEX1(KPIDR),"^",2)
	.s methodeCode = $P(^DHCCJXPAKPIINDEX1(KPIDR),"^",13)
	.s iscolType = $P(^DHCCJXPAKPIINDEX1(KPIDR),"^",12)

	i methodeCode = "I" s methodname = "区间法"
	i methodeCode = "C" s methodname = "比较法"
	i methodeCode = "D" s methodname = "扣分法"
	i methodeCode = "A" s methodname = "加分法"
	i methodeCode = "M" s methodname = "目标参照法"
	i methodeCode = "K" s methodname = "实际值法"
		
	s targetvalue = result.Data("UnitResultDetail_tValue")
	i targetvalue '="" s targetvalue=$fn(targetvalue,"",2)
	s actvalue = result.Data("UnitResultDetail_actValue")
	i actvalue'="" s actvalue=$fn(actvalue,"",2)
	s score = result.Data("UnitResultDetail_score")
	i score'="" s score = $fn(score,"",2)
	s Rscore = result.Data("UnitResultDetail_Rscore")
	i Rscore'="" s Rscore=$fn(Rscore,"",2)
	s estdesc = result.Data("UnitResultDetail_estDesc")
	s rate = result.Data("UnitResultDetail_rate")
	i rate'="" d
	.;s ratedvalue=score*rate/100
	.;s ratedvalue=$fn(ratedvalue,"",2)
	.s ratedvalue=Rscore*rate/100 //2016-06-13  最终考核分加权分 cyl edit
	.s ratedvalue=$fn(ratedvalue,"",2)
	s tmp=mainrowid_"^"_detailrowid_"^"_urperiod_"^"_urdeptname_"^"_kpiname_"^"_targetvalue
	      _"^"_actvalue_"^"_score_"^"_Rscore_"^"_estdesc_"^"_ratedvalue_"^"_methodname_"^"_detailinfo_"^"_iscolType
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

//修改实际值和问题描述

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Update("1||426","1||426||3","12","aa","201501","kpidrs","Q","deptdr",userID)
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Update("1||2","1||2||12","1","aa","201501","","Q","",1)
ClassMethod Update(mainrowid, detailrowid, actvalue, desc, period, kpidrs, periodType, deptdr, userID) As %String
{
	n (mainrowid,detailrowid, actvalue, desc,period,kpidrs, periodType,deptdr,userID)
	
	s (kpidr,schem,jxunitdr,period)=""
	i detailrowid'="" d
    .&sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_actValue=:actvalue,UnitResultDetail_estDesc = :desc where UnitResultDetail_rowid = :detailrowid)
    .&sql(select UnitResultDetail_KPIDr into :kpidr from dhc_pa_data.UnitResultDetail where UnitResultDetail_rowid = :detailrowid)
    i mainrowid'="" d
    .&sql(select UnitResult_schemDr,UnitResult_jxUnitDr,UnitResult_period into :schem,:jxunitdr,:period from dhc_pa_data.UnitResult where UnitResult_rowid=:mainrowid)
    ;w detailrowid_"^"_kpidr,!
    i kpidr'="" d
    .s iscolType = $P(^DHCCJXPAKPIINDEX1(kpidr),"^",12)  //---非计算性指标可以直接修改
    .//b ;2
    .i iscolType = 1 d
    ..//b ;3
    ..s jxbaseRowid=##class(dhc.pa.udata.uJXBaseData).IfRepRecode(jxunitdr,period,kpidr,periodType)
    ..i jxbaseRowid'="" d
    ...&sql(update dhc_pa_data.JXBaseData set JXBaseData_actualValue=:actvalue,JXBaseData_desc = :desc 
    where JXBaseData_KPIDr=:kpidr and JXBaseData_period=:period and JXBaseData_parRef=:jxunitdr)
	..e  d
	...s data=jxunitdr_"^"_period_"^"_periodType_"^"_kpidr_"^"_actvalue_"^1^"_desc
	...;w data,!
	...s SQLCODE=##class(dhc.pa.udata.uJXBaseData).Insert(data)
	//修改jxbasedata方法
	/*
	s deptdr=..Getdeptid(deptdr)
	s kpidrs=..GetSingleKpi(kpidrs)
	//w "deprdr"_deptdr_"kpidrs"_kpidrs,!
	d ..UpdateJXBasedate(actvalue, period,kpidrs, periodType,deptdr,userID)
    */
    q SQLCODE
}

//获取方案对应的归口科室

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).ListDepts("1||11",0,25)
ClassMethod ListDepts(schemrowid, start, limit) As %String
{
    n (schemrowid,start,limit)
    
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select SCM_RowID,SCM_SchemDR,SCM_DeptDr,SCM_UserDR "
	           _" from dhc_pa_data.schem_MDept "
               _" where SCM_SchemDR = '"_schemrowid_"' "
	d result.Prepare(sqlStr)
	d result.Execute()
    b ;1
	s count = 0
	s resultString = ""
	s end=start+limit-1
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="scmrowid^deptdr^deptname"
	
	While(result.Next()){
	s deptname=""
	
	s scmrowid = result.Data("SCM_RowID")
	s deptdr = result.Data("SCM_DeptDr")
	
	i deptdr'="" d
	.i $d(^DHCCJXPAJXUNIT(deptdr)) d
	..s deptname=$p($g(^DHCCJXPAJXUNIT(deptdr)),"^",3)
	
	s tmp=scmrowid_"^"_deptdr_"^"_deptname
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询当前战略下的方案
/// Table:dhc_pa_data.Schem
/// Input:cycleDr-战略年度Dr,frequency-报告频率
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCalu).GetSchems("demo","",0,15)
ClassMethod GetSchems(USERCODE, str, start, limit) As %String
{
	n (USERCODE,str,start,limit)
   
    s result = ##class(%Library.ResultSet).%New()
    
	s active="Y"
	s sqlStr="select Stratagem_cycleDr,Schem_rowid,Schem_shortcut,Schem_name,Schem_frequency,Schem_appSysDr from dhc_pa_data.Schem,dhc_pa_data.Stratagem where Schem_childSub>0 and Stratagem_rowid = Schem_parRef and Schem_active='"_active_"'"
    i str'="" d
    .s sqlStr = sqlStr_" and Schem_name like '%"_str_"%' "
    
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end=start+limit-1
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="cycleDr^frequency^schemDr^shortcut^appSysDr^schemname"
	
	While(result.Next()){
		s schemDr = result.Data("Schem_rowid")
		s shortcut = result.Data("Schem_shortcut")
		s frequency = result.Data("Schem_frequency")
		s appSysDr = result.Data("Schem_appSysDr")
		s cycleDr = result.Data("Stratagem_cycleDr")
		s schemname = result.Data("Schem_name")
		s tmp=cycleDr_"^"_frequency_"^"_schemDr_"^"_shortcut_"^"_appSysDr_"^"_schemname
	
		// 方案权限  20140224 add
		s userCode=""
		s userCode=$$ALPHAUP^SSUTIL4(USERCODE)
	    //根据用户Code查找用户ID
	    s userDr=0
	    s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
		
	  
	    s rowid="" 
	    i userDr'=0  s rowid=$o(^DHCCJXPASCHEMAUDIT(0,"SchemUser",schemDr,userDr,rowid))
		i rowid'="" d
	    .s count = count+1
	    .i (count>start)&(count<=end) d
	    ..d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCaluExtend).Getdeptid("老年病房")
ClassMethod Getdeptid(str) As %String
{
	n ( str)
	s expression=""
	&SQL(SELECT JXUnit_rowid into:expression FROM dhc_pa_data.JXUnit WHERE JXUnit_name LIKE :str)
	q expression
}

//kpiname

/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCaluExtend).GetKpidrs("床均出院病人数")
ClassMethod GetKpidrs(str) As %String
{
	n ( str)
	s expression=""
	&SQL(SELECT KPIIndex1_expression into :expression FROM dhc_pa_data.KPIIndex1 WHERE KPIIndex1_name LIKE :str)
	q ..GetKPIStrList(expression)
}

/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCaluExtend).GetKpidrs("床均出院病人数")
ClassMethod GetSingleKpi(str) As %String
{
	n ( str)
	s expression=""
	&SQL(SELECT %id into :expression FROM dhc_pa_data.KPIIndex1 WHERE KPIIndex1_name LIKE :str)
	q expression
}

ClassMethod GetKPIStrList(string) As %String
{
	n (string)
	s StrList=""   s tmp=""
	f i=1:1:$L(string) d
	.i $E(string,i)="<" d
	..s k=..GetNextLocation(string,i)
	..s StrList=$E(string,i+1,k-1)
	
	..i tmp="" d 
	...s tmp=StrList
	..e  d
	...s tmp=tmp_","_StrList

	q tmp
}

/// 老刘和老刘的程序相遇了
/// Others:w ##class(dhc.pa.report.uKPIDataSources).GetNextLocation("{[(<21>+<51>)*0.5]/25}",2)
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

ClassMethod UpdateJXBasedate(actvalue, period, kpidrs, periodType, deptdr, userID) As %String
{
	n (actvalue, period,kpidrs, periodType,deptdr,userID)
	//w actvalue,"   ", period,"   ",kpidrs,"   ", periodType,"   ",deptdr,"   ",userID,!
	&SQL(UPDATE dhc_pa_data.JXBaseData
	SET JXBaseData_actualValue =:actvalue, JXBaseData_auditUserDr=:userID  WHERE JXBaseData_parRef = :deptdr AND JXBaseData_period = :period AND JXBaseData_periodType=:periodType AND JXBaseData_KPIDr=:kpidrs )
	//w SQLCODE
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2016-04-14
/// Description: 修改最终分数以及说明
/// Table: dhc_pa_data.UnitResultDetail
/// Input: mainrowid-主表id;detailrowid-明细表id;actvalue-最终分数;desc-描述
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Update("1||426","1||426||3","12","aa","201501","kpidrs","Q","deptdr",userID)
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Update("1||2","1||2||12","1","aa","201501","","Q","",1)
ClassMethod UpdateScore(mainrowid, detailrowid, actvalue, desc) As %String
{
	n (mainrowid,detailrowid, actvalue, desc)
	
	s (kpidr,schem,jxunitdr,period)=""
	s SQLCODE=0
	i detailrowid'="" d
    .&sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_Rscore=:actvalue,UnitResultDetail_estDesc = :desc where UnitResultDetail_rowid = :detailrowid)
    
    q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2016-04-19
/// Description: 生成最终分数
/// Table: dhc_pa_data.UnitResultDetail
/// Input: mainrowid-主表id;detailrowid-明细表id;actvalue-最终分数;desc-描述
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Update("1||426","1||426||3","12","aa","201501","kpidrs","Q","deptdr",userID)
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).copyScoreMain("2015","01","Q","demo","1||5")
ClassMethod copyScoreMain(year, period, periodType, userCode, schemDr) As %String
{
	n (year,period, periodType,userCode,schemDr)
		
	;w schemDr,!
	s SQLCODE=0
	
	q:userCode="" "NoUserCode"
	
	s currStratagemDr=""
	s currStratagemDr=##class(dhc.pa.udata.uComm).GetCurrStratagemDr()
	q:currStratagemDr="NoCurrRecord" currStratagemDr //表示没有当前战略记录
	q:currStratagemDr="RepCurrRecord" currStratagemDr //表示有多条当前战略记录
    
    //拼接期间格式：201501
    i (year'="")&&(period'="") d
	.s yearperiod=$e(year,1,4)_period
	q:yearperiod="" "Noyearperiod"
	;s ^wy=yearperiod_"^"_year_"^"_period
	i schemDr="" d
	.s Schem=""
	.f  s Schem=$o(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",Schem)) q:Schem=""  d
	..s SchemDr=currStratagemDr_"||"_Schem
	..s SQLCODE=..copyScore(currStratagemDr,yearperiod,periodType,userCode,SchemDr)
    e  d
    .s SQLCODE=..copyScore(currStratagemDr,yearperiod,periodType,userCode,schemDr)
    
    q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2016-04-19
/// Description: 生成最终分数
/// Table: dhc_pa_data.UnitResultDetail
/// Input: mainrowid-主表id;detailrowid-明细表id;actvalue-最终分数;desc-描述
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).Update("1||426","1||426||3","12","aa","201501","kpidrs","Q","deptdr",userID)
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).copyScore("2015","01","Q","D306")
ClassMethod copyScore(currStratagemDr, yearperiod, periodType, userCode, schemDr) As %String
{
	n (currStratagemDr,yearperiod, periodType,userCode,schemDr)
		
	
	s SQLCODE=0
	
	q:userCode="" "NoUserCode"
	q:yearperiod="" "Noyearperiod"
	
	
	s aduit=""
	i userCode'="" d
	.s aduit= ##class(dhc.pa.udata.uComm).SchemByAduit(schemDr,userCode)
	q:(aduit=0)||(aduit="")
    &sql(UPDATE dhc_pa_data.UnitResultDetail SET UnitResultDetail_Rscore=UnitResultDetail_score 
			WHERE UnitResultDetail_parRef->UnitResult_period=:yearperiod
			AND UnitResultDetail_parRef->UnitResult_schemDr->Schem_frequency=:periodType
			AND UnitResultDetail_parRef->UnitResult_schemDr=:schemDr)
	i (SQLCODE'=0) d
	.d ##class(dhc.pa.udata.uPALogger).Insert("copyScore",yearperiod_"^"_schemDr_"^"_periodType,SQLCODE,"生成最终得分错误")
   
    q SQLCODE
}

/// Creator: chu yali
/// CreatDate: 2016-04-22
/// Description: 考核指标数据调整——修改最终考核分和问题描述
/// Table: dhc_pa_data.UnitResultDetail
/// Input: 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others:2016-06-14 wy update 
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).UpdateNew("1||8194","1||8194||3","100","","201601","","Q","15",3901)
ClassMethod UpdateNew(mainrowid, detailrowid, Rscore, desc, period, kpidrs, periodType, deptdr, userID) As %String
{
	n (mainrowid,detailrowid, Rscore, desc,period,kpidrs, periodType,deptdr,userID)
	
	s ComputeType=1
   &sql(SELECT UnitResult_schemDr->Schem_ComputeType into :ComputeType FROM  dhc_pa_data.UnitResult WHERE UnitResult_rowid='1||4308')
    &sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_Rscore=:Rscore,UnitResultDetail_estDesc = :desc where UnitResultDetail_rowid = :detailrowid)
  	//得到修改的科室id
  	&sql(select UnitResultDetail_parRef->UnitResult_jxUnitDr into:deptdr from dhc_pa_data.UnitResultDetail where UnitResultDetail_rowid = :detailrowid )
   //循环更新上级节点  得到上级节点的parent和kpiID
	;s ^chuchu=mainrowid_"^"_detailrowid_"^"_Rscore_"^"_desc_"^"_period_"^"_kpidrs_"^"_periodType_"^"_deptdr_"^"_userID
   do{
	   //取上级节点id
    &sql(select UnitResultDetail_parent into:parentKPIDr FROM dhc_pa_data.UnitResultDetail where  UnitResultDetail_rowid = :detailrowid )
    //更新父节点的值
    i ComputeType'=3 d
    .&sql(SELECT sum(UnitResultDetail_Rscore*UnitResultDetail_rate/100) into:RscoreSum  FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_parent =:parentKPIDr and UnitResultDetail_parRef=:mainrowid)
    e  d
    .&sql(SELECT UnitResultDetail_tValue into:tValue FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_KPIDr =:parentKPIDr and UnitResultDetail_parRef=:mainrowid)
    .&sql(SELECT UnitResultDetail_rate into:rate FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_KPIDr =:parentKPIDr and UnitResultDetail_parRef=:mainrowid)
    .&sql(SELECT sum(UnitResultDetail_Rscore/100*UnitResultDetail_rate) into:RscoreSum  FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_parent =:parentKPIDr and UnitResultDetail_parRef=:mainrowid)
    .s RscoreSum=(RscoreSum+tValue)*100/rate
    &sql(UPDATE dhc_pa_data.UnitResultDetail SET UnitResultDetail_Rscore =:RscoreSum
		WHERE UnitResultDetail_KPIDr=:parentKPIDr and UnitResultDetail_parRef=:mainrowid )

		if (SQLCODE'=0){
			q:SQLCODE
		}else{
			s detailrowid=%ROWID
		}
		s lala=..UpdateUpSchem(parentKPIDr,RscoreSum,mainrowid,deptdr,period,periodType)
	}while(parentKPIDr>0)
    
    &sql(UPDATE dhc_pa_data.UnitResult SET UnitResult_RScore=:RscoreSum
		WHERE UnitResult_rowid=:mainrowid)
	i SQLCODE'=0 d
	.d ##class(dhc.pa.udata.uPAScoreLogger).Insert(userID,"UDRscore="_Rscore_"^estDesc ="_desc,"基层科室绩效考核计算-考核指标数据调整")
    q SQLCODE
}

/// Creator: chu yali
/// CreatDate: 2016-05-06
/// Description: 更新上级方案的kpi
/// Table: 
/// Input:RscoreSum（表中的分数）
/// Others: w ##class(dhc.pa.udata.uBasicUnitPaCalu).UpdateUpSchem("7","-0.5","1||638||4","201502")
/// 2016-06-14 wy update
ClassMethod UpdateUpSchem(KPIDr, RscoreSum, mainrowid, deptdr, period, periodType) As %String
{
	n (KPIDr,RscoreSum,mainrowid,deptdr,period,periodType)
	/*判断KPIDr是否为方案的结果指标
	*/
	//1、根据mainRowid找到当前KPIDr的schemDr和该方案的上级方案
	;&sql(SELECT UnitResult_schemDr ,UnitResult_schemDr->Schem_ComputeType  into:schemDr,:computeType FROM dhc_pa_data.UnitResult WHERE UnitResult_rowid=:mainrowid )
	&sql(SELECT UnitResultDetail_parRef->UnitResult_schemDr ,UnitResultDetail_parRef->UnitResult_schemDr->Schem_ComputeType,
		UnitResultDetail_rate into:schemDr,:computeType,:rate
		FROM dhc_pa_data.UnitResultDetail  WHERE UnitResultDetail_parRef=:mainrowid
		AND UnitResultDetail_KPIDr=:KPIDr)
	s computeType=computeType
	/*
	if (computeType=3){ //20160511 cyl add
		//当方案的处理方式为差额处理是，RscoreSum=总分-扣的分数	
		s RscoreSum=rate-$ZABS(RscoreSum)
	}
	*/
	//得到方案的结果指标
	&sql(SELECT $LISTFROMSTRING(Schem_KPIDr,",") into:KPIList FROM dhc_pa_data.Schem WHERE Schem_rowid=:schemDr)
		//2、查找当前KPI是否为结果指标，如果是，则更新上级方案该指标的值
		s findKpi=$LISTFIND(KPIList,KPIDr)	
		if (findKpi'=0){
			//3、获得上级方案
			//&sql(SELECT $LISTFROMSTRING(Schem_UpSchemDr,",") into:upSchemDrList FROM dhc_pa_data.Schem WHERE Schem_rowid=:schemDr)
			&sql(SELECT $LISTFROMSTRING(UnitResult_schemDr) into:upSchemDrList FROM dhc_pa_data.UnitResult WHERE UnitResult_schemDr->Schem_frequency=:periodType and UnitResult_jxUnitDr=:deptdr AND UnitResult_period=:period
                 AND UnitResult_schemDr->Schem_level=1)
			s upSchemDrListLen=$LISTLENGTH(upSchemDrList)
			if (upSchemDrListLen'=0){
				//如果上级方案不为空
				//2、循环上级方案，找到他们结果指标
					;1||1,1||23
				s ptr=0
				while $LISTNEXT(upSchemDrList,ptr,value){
					&sql(update dhc_pa_data.UnitResultDetail  set UnitResultDetail_Rscore=:RscoreSum
							WHERE UnitResultDetail_parRef->UnitResult_schemDr=:value
							AND UnitResultDetail_KPIDr=:KPIDr
							AND UnitResultDetail_parRef->UnitResult_jxUnitDr=:deptdr
							AND UnitResultDetail_parRef->UnitResult_period=:period)
							
					if ((SQLCODE'=0)&&(SQLCODE'=100)){
						q:SQLCODE
					}else{
						s udetailrowid=%ROWID
					
					 do{
						   //取上级节点id
					    &sql(select UnitResultDetail_parent,UnitResultDetail_parRef into:uparentKPIDr,:umainrowid FROM dhc_pa_data.UnitResultDetail where  UnitResultDetail_rowid = :udetailrowid )
					    //更新父节点的值
					    /*
					    if (computeType=3){ //20160511 cyl add
					        &sql(SELECT sum(UnitResultDetail_rate-isnull(UnitResultDetail_Rscore,UnitResultDetail_rate)) into:scoreSum  FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_parent =:uparentKPIDr and UnitResultDetail_parRef=:umainrowid)
						    &sql(SELECT UnitResultDetail_rate into:parentRate  FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_KPIDr =:uparentKPIDr and UnitResultDetail_parRef=:umainrowid)
						    s scoreSum =parentRate-$ZABS(scoreSum)
						 }else{
							&sql(SELECT sum(UnitResultDetail_Rscore) into:scoreSum  FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_parent =:uparentKPIDr and UnitResultDetail_parRef=:umainrowid) 
						}
					    */
					    ;s uprate=0
					    
					    &sql(SELECT sum(UnitResultDetail_Rscore/100*UnitResultDetail_rate) into:scoreSum  FROM  dhc_pa_data.UnitResultDetail WHERE UnitResultDetail_parent =:uparentKPIDr and UnitResultDetail_parRef=:umainrowid) 
					    if (uparentKPIDr>0){
					      &sql(SELECT UnitResultDetail_rate into :uprate from dhc_pa_data.UnitResultDetail
							WHERE UnitResultDetail_KPIDr=:uparentKPIDr and UnitResultDetail_parRef=:umainrowid )
					    }
					    else  {
						    &sql(SELECT UnitResultDetail_rate into :uprate from dhc_pa_data.UnitResultDetail
							WHERE UnitResultDetail_parent=:uparentKPIDr and %ID=:udetailrowid )

					    }	
						 	s scoreSum=scoreSum*100/uprate
					     	&sql(UPDATE dhc_pa_data.UnitResultDetail SET UnitResultDetail_Rscore =:scoreSum
							WHERE UnitResultDetail_KPIDr=:uparentKPIDr and UnitResultDetail_parRef=:umainrowid )

							if ((SQLCODE'=0)&&(SQLCODE'=100)){
								q:SQLCODE
							}else{
								s udetailrowid=%ROWID
							}
					   	
						}while(uparentKPIDr>0)
						
					    &sql(UPDATE dhc_pa_data.UnitResult SET UnitResult_RScore=:scoreSum
							WHERE UnitResult_rowid=:umainrowid)
					}
				}
			}
		}
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uBasicUnitPaCaluS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
