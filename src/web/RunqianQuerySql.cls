Class web.RunqianQuerySql Extends %RegisteredObject [ ProcedureBlock ]
{

//按日期和数据操作类别查询财务支出数据

Query OutPutVouchDatas(stdate As %Integer, endate As %Integer, intype As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select vouchdatas_deptcode as deptCode,vouchdatas_deptname as deptName,vouchdatas_subjcode as subjCode,vouchdatas_subjname as subjName,sum(vouchdatas_debit) as debit from dhc_ca_cache_data.vouchdatas 
 where vouchdatas_intervaldr between :stdate and :endate and vouchdatas_intype=:intype
}

/// Creator:张金旺
/// CreatDate:2014.9.28
/// Description: 取基本成本数据 --广西医大
/// Table:dhc_ca_cache_data.BaseDatas  
/// Input:核算周期   核算科室Dr
/// Output:核算科室Dr 核算科室代码 核算科室名称 人事号 人名  核算项目Dr 项目名称 费用 导入类型 导入时间  操作人 
/// Return:
/// Remark:
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQuerySql","GetBaseDatas","1","2,3,4")
ClassMethod GetBaseDatasExecute(ByRef qHandle As %Binary, stdate As %String, DeptDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	;q:DeptDr="" $$$OK
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s desc=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s Year=$p(desc,"-",1)
    .s month=$p(desc,"-",2)
    .s monthname=Year_""_"年"_""_month_""_"月"
	 
 
    s sqlStr="SELECT BaseData_servedDeptDr,BaseData_servedDeptDr->UnitDepts_code,BaseData_servedDeptDr->UnitDepts_name, "
    		 _" BaseData_servedDeptCode,BaseData_servedDeptName,BaseData_itemDr,BaseData_itemDr->AllDataItems_name,BaseData_itemName,BaseData_fee, "
    		 _" BaseData_operType, BaseData_operDate, BaseData_operDr->UnitPersons_name "
   			 _" FROM dhc_ca_cache_data.BaseData WHERE BaseData_intervalDr='"_stdate_"'"
    

    i DeptDr'="" s sqlStr=sqlStr_" AND BaseData_servedDeptDr IN ("_DeptDr_")"

	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
 While(result.Next()){
	  
      s DeptDR=result.Data("BaseData_servedDeptDr")
      s DeptCode=result.Data("UnitDepts_code")
      s DeptName=result.Data("UnitDepts_name")
      s PersonCode=result.Data("BaseData_servedDeptCode")
      s PersonName=result.Data("BaseData_servedDeptName")
      s ItemDr=result.Data("BaseData_itemDr")
      s ItemName=result.Data("AllDataItems_name")
      s BaseItem=result.Data("BaseData_itemName")
      s Fee=result.Data("BaseData_fee")
      s inType=result.Data("BaseData_operType")
      i inType="load" s inType="导入"
      i inType="input" s inType="手工录入"
      s Date=result.Data("BaseData_operDate")
      s OperPerson=result.Data("UnitPersons_name")
     
	 d OutputRow1
	  
	}
 
  	q $$$OK
OutputRow1
     s Deptlayers="" f  s Deptlayers=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,Deptlayers)) q:Deptlayers=""  d   //1 全成本分摊顶层ID
   	.i $d(^DHCCADEPTLEVELSETS(0,"Dept",Deptlayers,DeptDR))  d     // only one
    .s Deptlayer=Deptlayers
    s Data=$lb(monthname,Deptlayer,DeptDR,DeptCode,DeptName,PersonCode,PersonName,ItemDr,ItemName,BaseItem,$fn(Fee,"",2),inType,Date,OperPerson)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetBaseDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBaseDatasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBaseDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBaseDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetBaseDatas(stdate As %String, DeptDr As %String) As %Query(ROWSPEC = "monthname:%String,Deptlayer:%String,DeptDR:%String,DeptCode:%String,DeptName:%String,PersonCode:%String,PersonName:%String,ItemDr:%String,ItemName:%String,BaseItem:%String,Fee:%Float,inType:%String,Date:%String,OperPerson:%String") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.9.28
/// Description: 取科室人员
/// Table: unitdepts   indepts  outdepts
/// Input: 核算科室Dr
/// Output:核算科室Dr 核算科室代码 核算科室名称 人事号 人名  
/// Return:
/// Remark:
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQuerySql","GetDeptPerson","2,3,4")
ClassMethod GetDeptPersonExecute(ByRef qHandle As %Binary, DeptDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	 
 
    s sqlStr="SELECT InDepts_deptDr,InDepts_deptDr->UnitDepts_code,InDepts_deptDr->UnitDepts_name,OutDepts_code, OutDepts_name "
    		_" FROM dhc_ca_cache_data.Indepts LEFT JOIN  dhc_ca_cache_data.OutDepts on InDepts_rowid=OutDepts_parRef "
 			_" WHERE InDepts_childSub>0 AND OutDepts_childSub>0 AND OutDepts_remark='人员-科室' AND OutDepts_code NOT LIKE '%-%' "
    

    i DeptDr'="" s sqlStr=sqlStr_" AND InDepts_deptDr IN ("_DeptDr_")"

	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
 While(result.Next()){
	  
      s DeptDR=result.Data("InDepts_deptDr")
      s DeptCode=result.Data("UnitDepts_code")
      s DeptName=result.Data("UnitDepts_name")
      s PersonCode=result.Data("OutDepts_code")
      s PersonName=result.Data("OutDepts_name")
     
	 d OutputRow2
	  
	}
 
  	q $$$OK
OutputRow2
	s Deptlayers="" f  s Deptlayers=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,Deptlayers)) q:Deptlayers=""  d   //1 全成本分摊顶层ID
   	.i $d(^DHCCADEPTLEVELSETS(0,"Dept",Deptlayers,DeptDR))  d     // only one
    .s Deptlayer=Deptlayers
    s Data=$lb(Deptlayer,DeptDR,DeptCode,DeptName,PersonCode,PersonName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDeptPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptPersonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeptPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptPerson(DeptDr As %String) As %Query(ROWSPEC = "Deptlayer:%String,DeptDR:%String,DeptCode:%String,DeptName:%String,PersonCode:%String,PersonName:%String") [ SqlProc ]
{
}

//查询年月

/// Creator:shap
/// CreatDate:2014年5月27日
/// Description:成本项目结构分析表
Query GetAccountMonths() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select AccountMonths_name from dhc_ca_cache_data.AccountMonths where AccountMonths_name is not null  ORDER BY  AccountMonths_rowid DESC
}

/// Creator:
/// CreatDate:2014年5月27日
/// Description:查询各项目成本金额
/// Table: dhc.ca.cache.data.vouchdatas     
/// others:d ##class(%ResultSet).RunQuery("web.RunqianQuerySql","ProjectsCost","2014-01")
/// 主报表
ClassMethod ProjectsCostExecute(ByRef qHandle As %Binary, currentMonth As %String) As %Status
{
	
	;n (qHandle,currentMonth)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    ;如果需要在页面登陆的时候就查询本月的数据可放开下面一行注释
    ;i currentMonth=""  s currentMonth=$zd($h,3)
    s year=$p(currentMonth,"-",1) ;取年
    ;w year,!
    s month=$p(currentMonth,"-",2) ;取月
    s currentname=year_"年"_month_"月"
    ;w month,!
    s lastMonth=""
    i month="01" d
    .s month="12",year=year-1
    e  d 
    .s month=month-1,year=year
    .i month<=9  s month="0"_month  //保持月份是两位数
    s lastMonth=year_"-"_month ;取得上一个月的年度
    ;s firstMonth=year_"-01"  ;本年的第一个月   //zjw 20150924 屏蔽，修改见下
    s firstMonth=$p(currentMonth,"-",1)_"-01"  ;本年的第一个月  
    ;w lastMonth,!
    
	s strSql="select DataLevelSets_rowid from  dhc_ca_cache_data.DataLevelSets where datalevelsets_parent=(select datalevelsets_rowid from dhc_ca_cache_data.DataLevelSets where datalevelsets_name='新会计制度分类')"
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	;w strSql,!
	d result.Execute()	
	s datasetIds=""
    While(result.Next()){
       s datasetId=result.Data("DataLevelSets_rowid")
       i datasetIds="" d
       .s datasetIds=datasetId
       e  d
       .s datasetIds=datasetIds_","_datasetId
    }
    k strSql,result
    /* zjw 20150925 屏蔽，修改见下
    ;下面SQL中的"成本项目类别" 正式上项目时应改为对应的名称
     s strSql="select li.LevelItems_parRef->DataLevelSets_name, "
            _"sum(vd.VouchDatas_debit)as current_VouchDatas_debit, "
            _"(select sum(vd1.VouchDatas_debit) from dhc_ca_cache_data.vouchdatas vd1,dhc_ca_cache_data.AllDataItems adi1,dhc_ca_cache_data.LevelItems li1 "
            _"where vd1.VouchDatas_itemDr=li1.levelItems_itemDr  and adi1.alldataitems_remark='核算成本项目' and li1.levelItems_childSub>0 and adi1.alldataitems_active='Y' "
            _"and adi1.AllDataItems_rowid=vd1.VouchDatas_itemDr and vd1.VouchDatas_intervalDr->AccountMonths_name='"_lastMonth_"' and li1.levelItems_parRef=li.levelItems_parRef)as last_VouchDatas_debit, "
            _"(select sum(vd2.VouchDatas_debit) from dhc_ca_cache_data.vouchdatas vd2,dhc_ca_cache_data.AllDataItems adi2,dhc_ca_cache_data.LevelItems li2 "
            _"where vd2.VouchDatas_itemDr=li2.levelItems_itemDr  and adi2.alldataitems_remark='核算成本项目' and adi2.alldataitems_active='Y' and adi2.AllDataItems_rowid=vd2.VouchDatas_itemDr and li2.levelItems_childSub>0 "
            _"and vd2.VouchDatas_intervalDr->AccountMonths_name>='"_firstMonth_"' and vd2.VouchDatas_intervalDr->AccountMonths_name<='"_currentMonth_"' and li2.levelItems_parRef=li.levelItems_parRef)as sum_VouchDatas_debit "
            _"from dhc_ca_cache_data.vouchdatas vd "
            _"inner join dhc_ca_cache_data.AllDataItems adi on adi.AllDataItems_rowid=vd.VouchDatas_itemDr and adi.alldataitems_remark='核算成本项目' and adi.alldataitems_active='Y' "
            _"inner join dhc_ca_cache_data.LevelItems li on li.levelItems_itemDr = vd.VouchDatas_itemDr and li.levelItems_childSub>0 "
            _"where li.levelItems_parRef in("_datasetIds_") "
            _"and vd.VouchDatas_intervalDr->AccountMonths_name='"_currentMonth_"' "
            _"group by li.levelItems_parRef "
     */
      s strSql="select li.LevelItems_parRef->DataLevelSets_name, sum(vd.VouchDatas_debit)as current_VouchDatas_debit, "
            _"(select sum(vd1.VouchDatas_debit) from dhc_ca_cache_data.vouchdatas vd1,dhc_ca_cache_data.LevelItems li1 where vd1.VouchDatas_itemDr=li1.levelItems_itemDr  and li1.levelItems_childSub>0  "
            _" and vd1.VouchDatas_intervalDr->AccountMonths_name='"_lastMonth_"' and li1.levelItems_parRef=li.levelItems_parRef)as last_VouchDatas_debit, "
            _"(select sum(vd2.VouchDatas_debit) from dhc_ca_cache_data.vouchdatas vd2,dhc_ca_cache_data.LevelItems li2 where vd2.VouchDatas_itemDr=li2.levelItems_itemDr  and li2.levelItems_childSub>0 "
            _" and vd2.VouchDatas_intervalDr->AccountMonths_name>='"_firstMonth_"' and vd2.VouchDatas_intervalDr->AccountMonths_name<='"_currentMonth_"' and li2.levelItems_parRef=li.levelItems_parRef)as sum_VouchDatas_debit "
            _"from dhc_ca_cache_data.vouchdatas vd inner join dhc_ca_cache_data.LevelItems li on li.levelItems_itemDr = vd.VouchDatas_itemDr and li.levelItems_childSub>0 "
            _"where li.levelItems_parRef in("_datasetIds_") and vd.VouchDatas_intervalDr->AccountMonths_name='"_currentMonth_"' "
            _"group by li.levelItems_parRef "
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	;w strSql,!
	d result.Execute()
	s num=0
	While(result.Next()){
       s num=num+1
       s datasetName=result.Data("DataLevelSets_name")
       s datasetName2=num_"."_datasetName
       s currentDebit=result.Data("current_VouchDatas_debit")
       s lastDebit=result.Data("last_VouchDatas_debit")
       s SumMoney=result.Data("sum_VouchDatas_debit")
     d OutputRow3
	}
  	q $$$OK
OutputRow3
    s Data=$lb(currentname,num,datasetName,datasetName2,currentDebit,lastDebit,SumMoney)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod ProjectsCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProjectsCostExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ProjectsCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProjectsCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query ProjectsCost(currentMonth As %String) As %Query(ROWSPEC = "currentname:%String,num:%Integer,datasetName:%String,datasetName2:%String,currentDebit:%Float,lastDebit:%Float,SumMoney:%Float") [ SqlProc ]
{
}

/// Creator:
/// CreatDate:2014年5月30日
/// Description:查询按功能分类各项目成本金额
/// Table: dhc.ca.cache.data.vouchdatas     
/// others:d ##class(%ResultSet).RunQuery("web.RunqianQuerySql","DeptsCost","2014-01")
Query DeptsCost(currentMonth As %String) As %Query(ROWSPEC = "num:%Integer,deptlevel:%Integer,datasetName:%String,currentDebit:%Float,lastDebit:%Float,SumMoney:%Float") [ SqlProc ]
{
}

/// 主报表
ClassMethod DeptsCostExecute(ByRef qHandle As %Binary, currentMonth As %String) As %Status
{
	
	;n (qHandle,currentMonth)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    ;如果需要在页面登陆的时候就查询本月的数据可放开下面一行注释，不需要则注释掉
    ;62502正式上项目时改为$h
    ;i currentMonth=""  s currentMonth=$zd($h,3)
    s year=$p(currentMonth,"-",1) ;取年
    s month=$p(currentMonth,"-",2) ;取月
    s currentMonth = year_"-"_month
    s firstMonth=year_"-01"  ;本年的第一个月
    s lastMonth=""
    i month="01" d
    .s month="12",year=year-1
    e  d 
    .s month=month-1,year=year
    .i month<=9  s month="0"_month  //保持月份是两位数
    s lastMonth=year_"-"_month ;取得上一个月的年度
    ;w currentMonth,!
     /* zjw 20150925 屏蔽，修改见下
    ;该SQL中的"全成本分摊【报表设置】"正式上项目时应改为对应的名称
	s strSql="select DeptLevelSets_rowid from dhc_ca_cache_data.DeptLevelSets "
            _"where  DeptLevelSets_parent = "
            _"(select DeptLevelSets_rowid from dhc_ca_cache_data.DeptLevelSets where DeptLevelSets_name='全成本分摊') "
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	;w strSql,!
	d result.Execute()	
	s datasetIds=""
    While(result.Next()){
       s datasetId=result.Data("DeptLevelSets_rowid")
       i datasetIds="" d
       .s datasetIds=datasetId
       e  d
       .s datasetIds=datasetIds_","_datasetId
    }
    k strSql,result
   
    ;下面SQL中的"成本项目类别" 正式上项目时应改为对应的名称
    s strSql="select sum(VouchDatas_debit)current_VouchDatas_debit, "
            _"(select sum(vd2.VouchDatas_debit)from dhc_ca_cache_data.vouchdatas vd2,dhc_ca_cache_data.LevelDepts ld2, dhc_ca_cache_data.AllDataItems adi2 "
            _"where adi2.AllDataItems_rowid=vd2.VouchDatas_itemDr and adi2.alldataitems_remark='核算成本项目' and adi2.alldataitems_active='Y'  and vd2.VouchDatas_deptDr=ld2.LevelDepts_deptDr "
            _"and ld2.LevelDepts_childSub>0 and ld2.LevelDepts_parRef=ld.LevelDepts_parRef and vd2.VouchDatas_intervalDr->AccountMonths_name>='"_firstMonth_"' and vd2.VouchDatas_intervalDr->AccountMonths_name<='"_currentMonth_"') as sum_VouchDatas_debit, "
            _"LevelDepts_parRef->DeptLevelSets_name as DeptLevelSets_name "
            _"from dhc_ca_cache_data.vouchdatas vd "
            _"inner join dhc_ca_cache_data.AllDataItems adi on adi.AllDataItems_rowid=vd.VouchDatas_itemDr and adi.alldataitems_remark='核算成本项目' and adi.alldataitems_active='Y' "
            _"inner join dhc_ca_cache_data.LevelDepts ld on vd.VouchDatas_deptDr=ld.LevelDepts_deptDr and ld.LevelDepts_childSub>0 "
            _"where ld.LevelDepts_parRef in ("_datasetIds_") "
            _"and vd.VouchDatas_intervalDr->AccountMonths_name='"_currentMonth_"' "
            _"group by LevelDepts_parRef "
            _"order by LevelDepts_parRef desc"
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	;w strSql,!
	d result.Execute()
	While(result.Next()){
       s datasetName=result.Data("DeptLevelSets_name")
       i datasetName="行政后勤科室" d  s datasetName="2.管理费用",num=0
       i datasetName="公用部门" d  s datasetName="3.其他支出",num=0
       i datasetName="临床医疗科室" d  s datasetName=" 其中:临床医疗成本",num=1
       i datasetName="医疗技术科室" d  s datasetName="      医疗技术成本",num=1
       i datasetName="医疗辅助科室" d  s datasetName="      医疗辅助成本",num=1
       s currentDebit=result.Data("current_VouchDatas_debit")
       s SumMoney=result.Data("sum_VouchDatas_debit")
     */
     s strSql="SELECT CostResultSum_blDr , CostResultSum_self AS currentDebit "
			_",(SELECT b.CostResultSum_self FROM dhc_ca_cache_data.CostResultSum b WHERE b.CostResultSum_blDr=a.CostResultSum_blDr and b.CostResultSum_parRef=1 "
			_" AND b.CostResultSum_intervalDr->AccountMonths_name='"_lastMonth_"' AND b.CostResultSum_branchFlag='branch') AS lastDebit "
			_",(SELECT sum(c.CostResultSum_self) FROM dhc_ca_cache_data.CostResultSum c WHERE c.CostResultSum_blDr=a.CostResultSum_blDr and c.CostResultSum_parRef=1 "
			_" AND c.CostResultSum_intervalDr->AccountMonths_name between '"_firstMonth_"' AND '"_currentMonth_"' AND c.CostResultSum_branchFlag='branch') AS SumMoney "
			_" FROM dhc_ca_cache_data.CostResultSum a "
			_" WHERE a.CostResultSum_parRef=1 AND a.CostResultSum_intervalDr->AccountMonths_name='"_currentMonth_"' AND a.CostResultSum_branchFlag='branch' AND a.CostResultSum_blDr>1 "
	//CostResultSum_parRef=1   全成本分摊方法
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	;w strSql,!
	d result.Execute()
	While(result.Next()){
       s deptlevel=result.Data("CostResultSum_blDr")
       i deptlevel=3 d  s datasetName="2.管理费用",num=0
       i deptlevel=2 d  s datasetName="3.其他支出",num=0
       i deptlevel=6 d  s datasetName=" 其中:临床医疗成本",num=1
       i deptlevel=5 d  s datasetName="      医疗技术成本",num=1
       i deptlevel=4 d  s datasetName="      医疗辅助成本",num=1
       s currentDebit=result.Data("currentDebit")
       s lastDebit=result.Data("lastDebit")
       s SumMoney=result.Data("SumMoney")
     d OutputRow4
	}
  	q $$$OK
OutputRow4
    s Data=$lb(num,deptlevel,datasetName,currentDebit,lastDebit,SumMoney)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod DeptsCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptsCostExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptsCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptsCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//d ##Class(%ResultSet).RunQuery("web.HRReports.HRTimeDataTR","GetDeptPerNum","201403")

// others:d ##class(%ResultSet).RunQuery("web.RunqianQuerySql","GetDeptPerNum","201503")

/// Creator:
/// CreatDate:2015年10月27日
/// Description:查询HR科室归属人数、总考勤天数、总请假天数（PerCount, ApplealDays, LeaveDays）
/// Table: hishr.TimeLeaveInfo    hishr.DeptInfo
ClassMethod GetDeptPerNumExecute(ByRef qHandle As %Binary, sStartMonth As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	q:sStartMonth="" $$$OK
 	
 	s (sYear,sMonth)=""

	/*
	//zjw 改写，展示HR科室同unitdepts的对应关系
	s sqlStr="select a.DeptCode,b.DeptName,count(a.EmpCardID) as PerCount,  "
			_" sum(a.ApplealDays) as ApplealDays,sum(a.LeaveDays) as LeaveDays, b.FinanceStatName, "
			_" b.FlexStrField4,c.UnitDepts_name,c.UnitDepts_remark,c.UnitDepts_active  "
  			_" from hishr.TimeLeaveInfo as a  "
  			_" LEFT JOIN hishr.DeptInfo as b ON a.DeptCode=b.DeptCode  "  
  			_" LEFT JOIN dhc_ca_cache_data.unitdepts  as c ON b.FinanceStatName=c.UnitDepts_code  "
  			_" where a.Year='2015' and a.month='5'  "  
  			_" group by a.deptCode  "
	
	*/
 	s sqlStr=" select a.DeptCode,b.DeptName,count(a.EmpCardID) as PerCount, "
 			_" sum(a.ApplealDays) as ApplealDays,sum(a.LeaveDays) as LeaveDays, "
 			_" b.FinanceStatName,b.FlexStrField4 "
			_" from hishr.TimeLeaveInfo as a left join hishr.DeptInfo as b on a.DeptCode=b.DeptCode "
						
	
	s (sYear,sMonth)=""
	i sStartMonth'="" {
 		s sYear       =   $E(sStartMonth,1,4)
		s sMonth      =   $E(sStartMonth,6,$L(sStartMonth))
		s sqlStr=sqlStr_" where a.Year='"_sYear_"' and a.month='"_sMonth_"'  "
		s sqlStr=sqlStr_" group by a.deptCode "

		w !,sqlStr
	
		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()	
		While(result.Next()){
		  s DeptCode=result.Data("DeptCode")
		  s FlexStrField4=result.Data("FlexStrField4")
	      s FinanceStatName=result.Data("FinanceStatName")
	      s DeptName=result.Data("DeptName")
	      s PerCount=result.Data("PerCount")
		  s ApplealDays=result.Data("ApplealDays")
		  s LeaveDays=result.Data("LeaveDays")
      
	      d OutputRow7
		}
	}	
 	q $$$OK	
  	
OutputRow7

  	s Data=$lb(DeptCode,FlexStrField4,FinanceStatName,DeptName,PerCount,ApplealDays,LeaveDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDeptPerNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptPerNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeptPerNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptPerNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptPerNum(sStartMonth As %String) As %Query(ROWSPEC = "DeptCode:%String,FlexStrField4:%String,FinanceStatName:%String,DeptName:%String,PerCount:%Integer,ApplealDays:%Float,LeaveDays:%Float") [ SqlProc ]
{
}

}
