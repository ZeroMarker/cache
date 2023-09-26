Class dhc.bonus.udata.uUnitBonusDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//奖金录入

/// Creator: 王宏宇
/// CreatDate: 2011-1-6
/// Description: 查询符合条件的记录
/// Table: dhc_bonus_data.UnitBonusDetail
/// Input: BonusYear-核算年度,BonusPeriod-核算期间,ItemID-奖金核算项id,UnitID-核算单元Id,BonusSchemeID-奖金方案ID,searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others: w ##class(dhc.bonus.udata.uUnitBonusDetail).ListRec("2010","M02","","","1","fhq","","","","",0,10)
ClassMethod ListRec(BonusYear, BonusPeriod, ItemID, UnitID, BonusSchemeID, userCode, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (BonusYear,BonusPeriod,ItemID, UnitID,BonusSchemeID,userCode, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select  case a.BonusYear when null then '"_BonusYear_"' else a.BonusYear end  as BonusYear,case a.BonusPeriod when null then '"_BonusPeriod_"' else a.BonusPeriod end as BonusPeriod,d.BonusUnitID, d.BonusUnitName,d.BonusSchemeItemID,d.SchemeItemName,d.DataSource,a.BonusValue,a.UpdateDate "
	s sqlStr= sqlStr_ " from  dhc_bonus_data.UnitBonusDetail a right join(select b.BonusUnitID, b.BonusUnitName ,d.BonusSchemeItemID,d.SchemeItemName,d.DataSource "
	s sqlStr= sqlStr_ " from  dhc_bonus_data.BonusUnit b, dhc_bonus_data.BonusSchemeItem d ,dhc_bonus_data.BonusSchemeUnit e where  d.BonusSchemeID='"_BonusSchemeID_"' "
	s sqlStr= sqlStr_ " and  b.BonusUnitID = e.BonusUnitID and d.DataSource=1 and d.IsValid=1 and e.BonusSchemeID='"_BonusSchemeID_"'  and (b.BonusUnitID='"_UnitID_"' or '"_UnitID_"'='') and (d.BonusSchemeItemID='"_ItemID_"' or '"_ItemID_"'='')) d "
	s sqlStr= sqlStr_ " on a.BonusUnitID =d.BonusUnitID and   a.BonusSchemeItemID =d.BonusSchemeItemID and a.BonusYear='"_BonusYear_"' and a.BonusPeriod='"_BonusPeriod_"'"
	s sqlStr= sqlStr_ " join dhc_bonus_data.BonusEmployeeUnit e on  d.BonusUnitID =e.BonusUnitID"
	s sqlStr= sqlStr_ " join dhc_bonus_data.BonusEmployee f on  e.BonusEmployeeID =f.BonusEmployeeID and f.EmployeeCode='"_userCode_"'"
	

	s whereStr="where %ID>0"
	
	;w sqlStr,!	
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="UnitBonusDetailID"
	.i sortField="BonusYear" s sortField1="BonusYear"
	.i sortField="PeriodName" s sortField1="BonusPeriod"
	.i sortField="ItemName" s sortField1="BonusSchemeItemID"
	.i sortField="UnitName" s sortField1="BonusUnitID"
	.i sortField="BonusValue" s sortField1="BonusValue"
	.i sortField="UpdateDate" s sortField1="UpdateDate"
	
   i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	
	
	s sqlStr=sqlStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
  
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="ItemID^ItemName^UnitID^UnitName^BonusYear^BonusPeriod^PeriodName^BonusValue^UpdateDate"
	;w jsonTitle,!
	
	While(result.Next()){
	    s ItemName="",UnitName="",PeriodName=""
	    ;s rowid=result.Data("BonusTargetCollectID")
		
		s ItemID=result.Data("BonusSchemeItemID")
		i ItemID'="" d
		.i $D(^dhcbsBonusSchemeItemD(ItemID)) d
		..i $G(^dhcbsBonusSchemeItemD(ItemID))'="" d
		...s ItemName=$List(^dhcbsBonusSchemeItemD(ItemID),4)
		
		s UnitID=result.Data("BonusUnitID")
		
		i UnitID'="" d
		.i $D(^dhcbsBonusUnitD(UnitID)) d
		..i $G(^dhcbsBonusUnitD(UnitID))'="" d
		...s UnitName=$LIST(^dhcbsBonusUnitD(UnitID),3)
	
		s BonusYear=result.Data("BonusYear")
		s BonusPeriod=result.Data("BonusPeriod")
	
		s BonusValue=result.Data("BonusValue")
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
										
		s tmp=ItemID_"^"_ItemName_"^"_UnitID_"^"_UnitName_"^"_BonusYear_"^"_BonusPeriod_"^"_PeriodName_"^"_BonusValue_"^"_UpdateDate
		;w tmp,!
		s count=count+1
			i searchValue'="" d
			.q:(searchField="ItemName")&(ItemName'[searchValue)
			.q:(searchField="UnitName")&(UnitName'[searchValue)
			.q:(searchField="BonusYear")&(BonusYear'[searchValue)
			.q:(searchField="PeriodName")&(PeriodName'[searchValue)
			.q:(searchField="BonusValue")&(BonusValue'[searchValue)
			.q:(searchField="UpdateDate")&(UpdateDate'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
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
/// Others: w ##class(dhc.bonus.udata.uBonusTargetCollect).GetScheme(0,10,"")
ClassMethod GetScheme(start, limit, str) As %String
{
    n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0 and SchemeState=1 and IsValid=1"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeName LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		s name = result.Data("BonusSchemeName")
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

/// Creator：王宏宇
/// CreatDate：2011-1-16
/// Description: 根据奖金方案查询奖金核算项
/// Table：dhc_bonus_data.BonusSchemeItem
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uUnitBonusDetail).SIList(0,10,"险","1")
ClassMethod SIList(start, limit, str, SchemeID) As %String
{
    n (start, limit, str, SchemeID)

	s result = ##class(%Library.ResultSet).%New()
	
	s whereStr=""
	s sqlStr = "select BonusSchemeItemID, BonusSchemeID,SchemeItemName from dhc_bonus_data.BonusSchemeItem where DataSource=1 and IsValid=1 "
	i SchemeID'="" s whereStr=" and  BonusSchemeID='"_SchemeID_"'"
	i str'="" s sqlStr = sqlStr_" and SchemeItemName LIKE '%"_str_"%'"
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
	
	
	s BonusSchemeID = result.Data("BonusSchemeItemID")
	s SchemeItemName = result.Data("SchemeItemName")
	
	
	
	s tmp=BonusSchemeID_"^"_SchemeItemName
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
/// CreatDate：2011-1-16
/// Description: 根据奖金方案查询核算单元
/// Table：dhc_bonus_data.SchemeTarget
/// Input：start:开始记录位置;limit:记录条数;SchemeID:奖金方案ID
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uUnitBonusDetail).SUList(0,10,"","1","fhq")
ClassMethod SUList(start, limit, str, SchemeID, userCode) As %String
{
    n (start, limit, str, SchemeID ,userCode)

	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select BonusSchemeUnitID, BonusSchemeID,a.BonusUnitID,a.BonusUnitID->BonusUnitName from dhc_bonus_data.BonusSchemeUnit a,dhc_bonus_data.BonusEmployeeUnit b,dhc_bonus_data.BonusEmployee c where c.BonusEmployeeID = b.BonusEmployeeID and a.BonusUnitID = b.BonusUnitID  and c.EmployeeCode='"_userCode_"'"
	s whereStr=""
	i SchemeID'="" s whereStr=whereStr_" and  a.BonusSchemeID='"_SchemeID_"'"
	i str'="" s whereStr = whereStr_" and a.BonusUnitID->BonusUnitName LIKE '%"_str_"%'"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
	
	
	s BonusUnitID = result.Data("BonusUnitID")
	i BonusUnitID'="" d
	.i $D(^dhcbsBonusUnitD(BonusUnitID)) d
	..i $G(^dhcbsBonusUnitD(BonusUnitID))'="" d
	...s UnitName=$LIST(^dhcbsBonusUnitD(BonusUnitID),3)
	...;w UnitName,!
	
	
	
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
/// others:w ##class(dhc.bonus.udata.uUnitBonusDetail).Insert1(1,"2008","M11",1,"22.3","")
ClassMethod Insert1(UnitID, BonusYear, BonusPeriod, ItemID, BonusValue, UpdateDate, BonusSchemeID) As %String
{
    n (UnitID,BonusYear,BonusPeriod,ItemID,BonusValue,UpdateDate,BonusSchemeID)
    s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
    s DataSource=1
    s BonusType=2
    TSTART
    &sql(delete from dhc_bonus_data.UnitBonusDetail where BonusUnitID=:UnitID and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod and BonusSchemeItemID=:ItemID and BonusSchemeID=:BonusSchemeID)
	&sql(Insert into dhc_bonus_data.UnitBonusDetail(BonusUnitID,BonusYear,BonusPeriod,BonusSchemeItemID,BonusValue,UpdateDate,DataSource,BonusType,BonusSchemeID)values(:UnitID,:BonusYear,:BonusPeriod,:ItemID,:BonusValue,:UpdateDate,:DataSource,:BonusType,:BonusSchemeID))
	If SQLCODE TROLLBACK  q SQLCODE
		TCOMMIT	

ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit SQLCODE     //返回错误消息 ;
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uUnitBonusDe66FS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
