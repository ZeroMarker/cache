Class dhc.bonus.udata.uBonusTargetCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//指标录入

/// Creator: 王宏宇
/// CreatDate: 2011-1-6
/// Description: 查询符合条件的记录
/// Table: dhc.bonus.data.BonusTargetCollect
/// Input: BonusYear-核算年度,BonusPeriod-核算期间,TargetID-奖金指标id,UnitID-核算单元Id,BonusSchemeID-奖金方案ID,searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others: w ##class(dhc.bonus.udata.uBonusTargetCollect).ListRec("2016","M01","","","259","DEMO","","","rowid","Desc",0,10)
ClassMethod ListRec(BonusYear, BonusPeriod, TargetID, UnitID, BonusSchemeID, userCode, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (BonusYear,BonusPeriod,TargetID, UnitID,BonusSchemeID,userCode, searchField, searchValue, sortField, sortDir, start, limit)
	s userCode= $ZCONVERT(userCode,"u")
	s supUnitID=BonusSchemeID
	
	s sqlStr="select   '"_BonusYear_"'  BonusYear,'"_BonusPeriod_"'  BonusPeriod,d.BonusUnitID, d.BonusUnitName"
	_" ,d.BonusTargetID,d.BonusTargetCode,d.BonusTargetName,d.DataSource,a.TargetValue,a.UpdateDate"
	 _ " from  dhc_bonus_data.BonusTargetCollect a "
	 _" right join(select b.BonusUnitID, b.BonusUnitName ,c.BonusTargetID,c.BonusTargetName,c.DataSource,c.BonusTargetCode from  dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusTarget c ,dhc_bonus_data.SchemeTarget d ,dhc_bonus_data.BonusSchemeUnit e ,dhc_bonus_data.BonusEmployeeUnit f"
	 _" where c.BonusTargetID =d.BonusTargetID and b.BonusUnitID = f.BonusUnitID and upper(f.BonusEmployeeID->EmployeeCode)='"_userCode_"'"
	 _" and d.BonusSchemeID='"_BonusSchemeID_"' and b.BonusUnitID = e.BonusUnitID and e.BonusSchemeID='"_BonusSchemeID_"' and c.DataSource=1 and c.IsValid=1 and (b.BonusUnitID='"_UnitID_"' or '"_UnitID_"'='') and (c.BonusTargetID='"_TargetID_"' or '"_TargetID_"'='')) d "
	 _" on a.BonusUnitID =d.BonusUnitID and   a.BonusTargetID =d.BonusTargetID and a.BonusYear='"_BonusYear_"' and a.BonusPeriod='"_BonusPeriod_"'" 
	 _" join dhc_bonus_data.BonusEmployeeTarget e on d.BonusTargetID = e.BonusTargetID"
     _ " join dhc_bonus_data.BonusEmployee f on e.BonusEmployeeID = f.BonusEmployeeID and  upper(f.EmployeeCode)=upper('"_userCode_"')"
	 
	;s sqlStr=sqlStr
	
	s sqlStr="select   '"_BonusYear_"'  BonusYear, '"_BonusPeriod_"'  BonusPeriod"
	_" ,a.%ID rowid,e.BonusUnitID, e.BonusUnitName,e.BonusTargetID,e.BonusTargetCode,e.BonusTargetName,e.DataSource,a.TargetValue,a.UpdateDate,MaxValue,TargetDesc"
	_" from   dhc_bonus_data.BonusTargetCollect a"
	_" right join (  select BonusTargetID,BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName,BonusTargetID->DataSource"
	_" ,BonusTargetID->MaxValue,BonusTargetID->TargetDesc,c.BonusUnitID,c.BonusUnitName"
	_" from dhc_bonus_data.BonusEmployeeTarget a,dhc_bonus_data.BonusEmployeeUnit b,dhc_bonus_data.BonusUnit c"
	_" where a.BonusEmployeeID=b.BonusEmployeeID  and b.BonusUnitID=c.BonusUnitID and c.BonusUnitCode not like 'H%'  and   upper(a.BonusEmployeeID->EmployeeCode)='"_userCode_"'"
	/*
	i supUnitID'="" d
	.s sqlStr=sqlStr_"  and b.BonusUnitID=c.SuperiorUnitID and (c.SuperiorUnitID='"_supUnitID_"' or '"_supUnitID_"'='')"
	e  d
	.s sqlStr=sqlStr_"  and b.BonusUnitID=c.BonusUnitID and (c.SuperiorUnitID='"_supUnitID_"' or '"_supUnitID_"'='')"
	*/
	s sqlStr=sqlStr_"  and (c.SuperiorUnitID='"_supUnitID_"' or '"_supUnitID_"'='')"
	s sqlStr=sqlStr_"  and (c.BonusUnitID='"_UnitID_"' or '"_UnitID_"'='') and (a.BonusTargetID='"_TargetID_"' or '"_TargetID_"'='')) e"
 	_" on  a.BonusTargetID = e.BonusTargetID  and a.BonusUnitID = E.BonusUnitID  and  a.BonusYear='"_BonusYear_"' and a.BonusPeriod='"_BonusPeriod_"'" 
	
	/*
	s sortStr=""
	s sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusTargetCollectID"
	.i sortField="BonusYear" s sortField1="BonusYear"
	.i sortField="PeriodName" s sortField1="BonusPeriod"
	.i sortField="TargetName" s sortField1="BonusTargetID"
	.i sortField="UnitName" s sortField1="BonusUnitID"
	.i sortField="TargetValue" s sortField1="TargetValue"
	.i sortField="UpdateDate" s sortField1="UpdateDate"
	
   i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	
	
	s sqlStr=sqlStr_sortStr
	*/
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		 
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="TargetID^TargetName^UnitID^UnitName^BonusYear^BonusPeriod^PeriodName^TargetValue^MaxValue^TargetDesc^UpdateDate"
	;w jsonTitle,!
	
	While(result.Next()){
	    s TargetName="",UnitName="",PeriodName=""
	    ;s rowid=result.Data("BonusTargetCollectID")
		
		s TargetID=result.Data("BonusTargetID")
		i TargetID'="" d
		.i $D(^dhcbsBonusTargetD(TargetID)) d
		..i $G(^dhcbsBonusTargetD(TargetID))'="" d
		...s TargetName=$List(^dhcbsBonusTargetD(TargetID),3)
		
		s UnitID=result.Data("BonusUnitID")
		
		i UnitID'="" d
		.i $D(^dhcbsBonusUnitD(UnitID)) d
		..i $G(^dhcbsBonusUnitD(UnitID))'="" d
		...s UnitName=$LIST(^dhcbsBonusUnitD(UnitID),3)
	
		s BonusYear=result.Data("BonusYear")
		s BonusPeriod=result.Data("BonusPeriod")
	
		s TargetValue=result.Data("TargetValue")
		;s TargetValue=$fn(TargetValue,"",3)
		;s st=$p(TargetValue,".",2)
		i TargetValue'="" d
		.s TargetValue=$fn(TargetValue,",",2)
		
		s MaxValue=result.Data("MaxValue")
		i MaxValue'="" d
		.s MaxValue=$fn(MaxValue,",",2)
		s TargetDesc=result.Data("TargetDesc")
		
		s targetCode=result.Data("BonusTargetCode")
		
		s UpdateDate=result.Data("UpdateDate")
		;s PLIST(11)=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		;s UdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
		
		i BonusPeriod="M01" s PeriodName="1月"
		i BonusPeriod="M02" s PeriodName="2月"
		i BonusPeriod="M03" s PeriodName="3月"
		i BonusPeriod="M04" s PeriodName="4月"
		i BonusPeriod="M05" s PeriodName="5月"
		i BonusPeriod="M06" s PeriodName="6月"
		i BonusPeriod="M07" s PeriodName="7月"
		i BonusPeriod="M08" s PeriodName="8月"
		i BonusPeriod="M09" s PeriodName="9月"
		i BonusPeriod="M10" s PeriodName="10月"
		i BonusPeriod="M11" s PeriodName="11月"
		i BonusPeriod="M12" s PeriodName="12月"
		i BonusPeriod="Q01" s PeriodName="第一季度"
		i BonusPeriod="Q02" s PeriodName="第二季度"
		i BonusPeriod="Q03" s PeriodName="第三季度"
		i BonusPeriod="Q04" s PeriodName="第四季度"
		i BonusPeriod="H01" s PeriodName="上半年"
		i BonusPeriod="H02" s PeriodName="下半年"
										
		s tmp=TargetID_"^"_targetCode_":"_TargetName_"^"_UnitID_"^"_UnitName_"^"_BonusYear_"^"_BonusPeriod_"^"_PeriodName_"^"_TargetValue_"^"_MaxValue_"^"_TargetDesc_"^"_UpdateDate
			i searchValue'="" d
			.q:(searchField="TargetName")&(TargetName'[searchValue)
			.q:(searchField="UnitName")&(UnitName'[searchValue)
			.q:(searchField="BonusYear")&(BonusYear'[searchValue)
			.q:(searchField="PeriodName")&(PeriodName'[searchValue)
			.q:(searchField="TargetValue")&(TargetValue'[searchValue)
			.q:(searchField="MaxValue")&(MaxValue'[searchValue)
			.q:(searchField="TargetDesc")&(TargetDesc'[searchValue)
			.q:(searchField="UpdateDate")&(UpdateDate'[searchValue)
			.i (count>=start)&(count<=end) d
			..d json.InsertRowData(tmp)
			.s count=count+1
			e  d
			.i (count>=start)&(count<=end) d
			..d json.InsertRowData(tmp)
			.s count=count+1
		//插入到表里
	
	/**	
	.i $o(^dhcbsBonusTargetCollectI("TC",UnitID,TargetID,BonusYear,""))'="" d //什么也不做
    .e  d
    //&SQL(Insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,BonusYear,BonusPeriod,TargetValue,UdateDate) VALUES(:TargetID,:UnitID,:BonusYear,:BonusPeriod,:TargetValue,:UdateDate))
   **/
		}
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator：王宏宇
/// CreatDate：2011-1-12
/// Description: 取出Combobox所需要的年度
/// Table：dhc_bonus_data.SchemePeriod
/// Input：start:开始记录位置;limit:记录条数;
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uBonusTargetCollect).GetYear(0,10)
ClassMethod GetYear(start, limit) As %String
{
    n (start, limit)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'"
	;i str'="" s sqlStr = sqlStr_" and WorkType_name LIKE '"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SchemePeriodID")
		s name = result.Data("BonusYear")
		s tmp=name_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json 	
 	q resultString
}

/// Creator：王宏宇
/// CreatDate：2011-1-12
/// Description: 取出Combobox所许要的奖金方案
/// Table：dhc_bonus_data.BonusScheme
/// Input：start:开始记录位置;limit:记录条数;str:模糊查询字段
/// Output：
/// Return：有效单位字符串
/// Others: w ##class(dhc.bonus.udata.uBonusTargetCollect).GetScheme(0,10,"","admin")
ClassMethod GetScheme(start, limit, str, userCode) As %String
{
    n (start, limit, str,userCode)
	
	s result = ##class(%Library.ResultSet).%New()
	;s sqlStr = "select BonusSchemeID,BonusSchemeCode,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0  and IsValid=1"
	s sqlStr=" select BonusSchemeID,BonusSchemeID->BonusSchemeCode,BonusSchemeID->BonusSchemeName from dhc_bonus_data.BonusEmpScheme a"
	  _" where %ID>0  and BonusSchemeID->IsValid=1 and upper(BonusEmpID->EmployeeCode)=upper('"_userCode_"')"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeID->BonusSchemeName LIKE '%"_str_"%'"
	
	s sqlStr = sqlStr_"  order by BonusSchemeID->SchemeType,BonusSchemeID->BonusSchemeCode "
	
	d result.Prepare(sqlStr)
	d result.Execute()
    ;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s code = result.Data("BonusSchemeCode")
		s name = result.Data("BonusSchemeName")
		s tmp=rowid_"^"_code_":"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json 	
 	q resultString
}

/// Creator：王宏宇
/// CreatDate：2010-11-16
/// Description: 根据奖金方案查询奖金指标
/// Table：dhc_bonus_data.SchemeTarget
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).STList(0,10,"","","wangying")
ClassMethod STList(start, limit, str, SchemeID, userCode) As %String
{
    n (start, limit, str, SchemeID,userCode)
	s userCode= $ZCONVERT(userCode,"u")
	s result = ##class(%Library.ResultSet).%New()
	
	s whereStr=""
	s sqlStr = "select a.SchemeTargetID,a.BonusTargetID,a.BonusSchemeID,b.BonusTargetName from dhc_bonus_data.SchemeTarget a,dhc_bonus_data.BonusTarget b,dhc_bonus_data.BonusEmployee c,dhc_bonus_data.BonusEmployeeTarget d where a.BonusTargetID=b.BonusTargetID and b.BonusTargetID=d.BonusTargetID and c.BonusEmployeeID = d.BonusEmployeeID and b.DataSource=1 and b.IsValid=1 and upper(c.EmployeeCode)='"_userCode_"'"
	i SchemeID'="" s whereStr="and a.BonusSchemeID='"_SchemeID_"'"
	i str'="" s whereStr = whereStr_" and b.BonusTargetName LIKE '%"_str_"%'"

	s sqlStr="select BonusTargetID,BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName"
	_" from dhc_bonus_data.BonusEmployeeTarget "
    _" where   BonusTargetID->DataSource=1  and  upper(BonusEmployeeID->EmployeeCode)='"_userCode_"'"
    i str'="" d
    .s sqlStr=sqlStr_" and (BonusTargetID->BonusTargetCode like '%"_str_"%' or BonusTargetID->BonusTargetName like '%"_str_"%')"
 

	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	
	s tmp="^全部"
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	
	While(result.Next()){
	
	
	s BonusTargetID = result.Data("BonusTargetID")
	s TargetCode = result.Data("BonusTargetCode")
	s TargetName = result.Data("BonusTargetName")
	
	s tmp=BonusTargetID_"^"_TargetCode_":"_TargetName
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	k json
	q resultString
}

/// Creator：王宏宇
/// CreatDate：2010-11-16
/// Description: 根据奖金方案查询核算单元
/// Table：dhc_bonus_data.SchemeTarget
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).SUList(0,10,"","900","N0159")
ClassMethod SUList(start, limit, str, SchemeID, userCode) As %String
{
    n (start, limit, str, SchemeID,userCode)

	s result = ##class(%Library.ResultSet).%New()
	
	
	s sqlStr = "select  distinct BonusUnitID,BonusUnitID->BonusUnitName from dhc_bonus_data.BonusEmployeeUnit "
		_" Where %ID>0  "
	s sqlStr =sqlStr_" and  UPPER(BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"')"
	i str'="" d
	.s sqlStr =sqlStr_" and (BonusUnitID->BonusUnitName like  '%"_str_"%' or BonusUnitID->BonusUnitCode like '%"_str_"%') "
	
	
	i SchemeID'="" d
	.s sqlStr =" select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit  where superiorUnitID='"_SchemeID_"' and BonusUnitCode not like 'H%' "
	.i str'="" d
	..s sqlStr =sqlStr_" and BonusUnitName like  '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	;w sqlStr,!
	;s ^zlgtemp=sqlStr
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	s UnitName=""
	
	s tmp="^全部"
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	
	While(result.Next()){
	
	s BonusUnitID = result.Data("BonusUnitID")
	s UnitName = result.Data("BonusUnitName")

	
	s tmp=BonusUnitID_"^"_UnitName
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	k json
	q resultString
}

/// Creator：zhao liguo
/// CreatDate：2013-3-28
/// Description: 根据当前用户查询核算单元
/// Table：dhc_bonus_data.SchemeTarget
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).SUList(0,10,"",18,"admin")
ClassMethod GetSupUnit(start, limit, str, userCode) As %String
{
    n (start, limit, str, userCode)

	s result = ##class(%Library.ResultSet).%New()
		
	s sqlStr = "select  BonusUnitID,BonusUnitID->BonusUnitName"
	_" from dhc_bonus_data.BonusEmployeeUnit Where  BonusUnitID->LastStage=0 "
	_" AND upper(BonusEmployeeID->EmployeeCode)=upper('"_userCode_"')"
	
	 i str'="" s sqlStr = sqlStr_" and (BonusUnitID->BonusUnitName like '%"_str_"%' or UPPER(BonusUnitID->BonusUnitCode) like  UPPER('%"_str_"%'))"
 	s sqlStr =sqlStr_" order by BonusUnitID->UnitFlag"
 	
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	s UnitName=""
	
	s tmp="^全部"
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	
	While(result.Next()){
	
	s BonusUnitID = result.Data("BonusUnitID")
	i BonusUnitID'="" d
	.i $D(^dhcbsBonusUnitD(BonusUnitID)) d
	..i $G(^dhcbsBonusUnitD(BonusUnitID))'="" d
	...s UnitName=$LIST(^dhcbsBonusUnitD(BonusUnitID),3)
	...;w UnitName,!
	;w BonusUnitID_"^"_UnitName,!
	
	s tmp=BonusUnitID_"^"_UnitName
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	k json
	q resultString
}

/// Creator：王宏宇
/// CreatDate：2011-01-13
/// Description:插入数据
/// Table：dhc.bonus.data.BonusTargetCollect
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).SUList(0,10,"","")
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).Insert1(1,"2008","M11",1,"22.3","")
ClassMethod Insert1(UnitID, BonusYear, BonusPeriod, TargetID, TargetValue, UpdateDate) As %String
{
    n (UnitID,BonusYear,BonusPeriod,TargetID,TargetValue,UpdateDate)
    s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
    s DataSource=1
    TSTART
    &sql(delete from dhc_bonus_data.BonusTargetCollect where BonusUnitID=:UnitID and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod and BonusTargetID=:TargetID)
	&sql(Insert into dhc_bonus_data.BonusTargetCollect(BonusUnitID,BonusYear,BonusPeriod,BonusTargetID,TargetValue,UpdateDate,DataSource)values(:UnitID,:BonusYear,:BonusPeriod,:TargetID,:TargetValue,:UpdateDate,:DataSource))
	i SQLCODE'=0 TRO  Q "Error"
		TCOMMIT	

ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

/// Creator：赵立国
/// CreatDate：2012-07-18
/// Description:插入数据
/// Table：dhc.bonus.data.BonusTargetCollect
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).SUList(0,10,"","")
/// others:w ##class(dhc.bonus.udata.uBonusTargetCollect).batchInsert(17,"2012","M02",155,"7500")
ClassMethod batchInsert(schemeID, BonusYear, BonusPeriod, TargetID, TargetValue) As %String
{
    n (schemeID,BonusYear,BonusPeriod,TargetID,TargetValue)
    s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
    s DataSource=1

    &sql(delete from dhc_bonus_data.BonusTargetCollect where BonusYear=:BonusYear and BonusPeriod=:BonusPeriod and BonusTargetID=:TargetID
   	AND BonusUnitID IN ( select BonusUnitID from dhc_bonus_data.BonusSchemeUnit   where BonusSchemeID=:schemeID))
	
	&sql(Insert into dhc_bonus_data.BonusTargetCollect(BonusUnitID,BonusYear,BonusPeriod,BonusTargetID,TargetValue,UpdateDate,DataSource)
	 select BonusUnitID,:BonusYear,:BonusPeriod,:TargetID,:TargetValue,:UpdateDate,1 DataSource
 	 from dhc_bonus_data.BonusSchemeUnit   where BonusSchemeID=:schemeID)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusTarget7A9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
