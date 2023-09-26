/// Class dhc.bonus.usubs.uBonusSubExpendDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
Class dhc.bonus.usubs.uBonusSubExpendDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhao liguo
/// CreatDate: 2011-6-16
/// Description: 查询符合条件的记录
/// Table: dhc_bonus_subs.BonusSubMain
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.usubs.uBonusSubExpendDetail).ListRec(20,"","2011","M04","","",0,25)
ClassMethod ListRec(InterLocSetDr, InterMethodDr, BonusYear, BonusPeriod, sortField, sortDir, start, limit) As %String
{
		n (InterLocSetDr,InterMethodDr,BonusYear, BonusPeriod, sortField, sortDir, start, limit)
			
		s sqlStr="SELECT BonusSubExpendDetailID,BonusUnitID->BonusUnitName,BonusTargetID->BonusTargetName,BonusYear,BonusPeriod"
			_",ExecuteUnitID->BonusUnitName ExcuteUnitName,CalculateUnit,ItemValue,ItemRate,ItemResult,"
			_" case State when 0 then '计提成功' when 1 then '导入成功' end as  State,UpdateDate,UnitType,"
			_" InterLocMethodID->InterLocSet_rowid->InterLocSet_shortcut,InterLocMethodID->InterLocMethod_methodDesc"
		
			_" FROM dhc_bonus_subs.BonusSubExpendDetail "
 			_" where   InterLocMethodID->InterLocSet_rowid ="_InterLocSetDr
			_" and BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
			
			//	_" ,case UnitType when 1 '开单科室' else '执行科室' end as UnitType "
		i InterMethodDr'="" d
		 .s sqlStr=sqlStr_ " and InterLocMethodID = "_InterMethodDr
		
 		;w sqlStr,!
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="BonusUnitName" s sortField1="BonusUnitID->BonusUnitName"
		.i sortField="BonusTargetName" s sortField1="BonusTargetID->BonusTargetName"
		.i sortField="BonusYear" s sortField1="BonusYear"
		.i sortField="BonusPeriod" s sortField1="BonusPeriod"
		
		.i sortField="ItemValue" s sortField1="ItemValue"
		.i sortField="BonusUnitName" s sortField1="ExecuteUnitID->BonusUnitName"
		.i sortField="CalculateUnit" s sortField1="CalculateUnit"
		.i sortField="ItemRate" s sortField1="ItemRate"
		.i sortField="ItemResult" s sortField1="ItemResult"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		
		s sqlStr=sqlStr_sortStr
		

		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
			
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		
		s jsonTitle="rowID^BonusUnitName^BonusTargetName^BonusYear^BonusPeriod^ExcuteUnitName^CalculateUnit^ItemValue^ItemRate^ItemResult^State^InterLocSet^InterLocMethod^UpdateDate^UnitType"

		While(result.Next())
		{
							
			s rowid=result.Data("BonusSubExpendDetailID")
          
            s BonusUnitName = result.Data("BonusUnitName")
            s BonusTargetName     =result.Data("BonusTargetName")  
			  
			s BonusYear          =result.Data("BonusYear")         
			s BonusPeriod        =result.Data("BonusPeriod") 
			      
			s ExcuteUnitName   =result.Data("ExcuteUnitName")  
			s CalculateUnit   =result.Data("CalculateUnit")
		
			s ItemValue    =result.Data("ItemValue")
			s ItemRate    =result.Data("ItemRate")
			s ItemResult    =result.Data("ItemResult")
			s State    =result.Data("State")
			s InterLocSet    =result.Data("InterLocSet_shortcut")
			s InterLocMethod  =result.Data("InterLocMethod_methodDesc")
			s UpdateDate   = result.Data("UpdateDate") 
			
			s UnitType = result.Data("UnitType") 
			
			;w "---------UnitType----------"_UnitType,!
			i UnitType=1 d
			.s UnitType = "开单科室"
			e  i UnitType=2 d
			..s UnitType = "执行科室" 
									 
			s ptype =$E(BonusPeriod,1,1)
		
			
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s BonusPeriod =$E(BonusPeriod,2,10)
	
			
			s BonusPeriod = BonusPeriod_periodType
			
			s tmp=rowid_"^"_BonusUnitName_"^"_BonusTargetName_"^"_BonusYear_"^"_BonusPeriod_"^"_ExcuteUnitName_"^"_CalculateUnit_"^"_ItemValue_"^"_ItemRate_"^"_ItemResult_"^"_State_"^"_InterLocSet_"^"_InterLocMethod_"^"_UpdateDate_"^"_UnitType

			s count=count+1
			
		
			i (count>start)&(count<=end) d
			.d json.InsertRowData(tmp)
		}
		
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-6-27
/// Description: 工作量项目提取明细表
/// Table：dhc.bonus.data.BonusItemType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uBonusSubExpendDetail).DealExpendData(20,29,"2011","M04")
ClassMethod DealExpendData(InterLocSetDr, InterMethodDr, BonusYear, BonusPeriod) As %String
{
	n (InterLocSetDr, InterMethodDr, BonusYear, BonusPeriod)
	
	s sqlStr ="  select  a.ExpendItemCode , b.InterLoc_jxUnitDr BonusUnitID, d.BonusTargetID, BonusYear, BonusPeriod,"
 	_" c.InterLoc_jxUnitDr ExecuteUnitID, CalculateUnit, ItemValue,'' ItemRate,'' ItemResult,0 State,InterLocMethodID,getdate() as UpdateDate,d.BonusSubItemID,a.UnitType "
  	_" FROM dhc_bonus_subs.BonusSubExpendCollect a  ,dhc_bonus_inter.InterLoc b,dhc_bonus_inter.InterLoc c,dhc_bonus_subs.BonusSubTargetFilter d"
 	_" where a.BonusUnitCode = b.InterLoc_code and a.ExecuteDeptCode = c.InterLoc_code"
	_" and a.ExpendItemCode = d.BonusSubItemID->SubItemCode"
   	_" and InterLocMethodID->InterLocSet_rowid ='"_InterLocSetDr_"'"
	_" and BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
		
	i InterMethodDr'="" d
	.s sqlStr=sqlStr_" and InterLocMethodID = "_InterMethodDr

	// BonusUnitID                                                          
    //
    //w sqlStr,!
	d ..Delete(InterLocSetDr, InterMethodDr, BonusYear, BonusPeriod)
	s result=##class(%Library.ResultSet).%New()
	k PLIST
	d result.Prepare(sqlStr)
	d result.Execute()	
	While(result.Next())
	{
	  s ExpendItemCode = result.Data("ExpendItemCode")
	  s BonusUnitID= result.Data("BonusUnitID")
	  s UnitType = result.Data("UnitType")

	  
	  s PLIST(2)=result.Data("BonusUnitID")
	  s PLIST(3)=result.Data("BonusTargetID")
	  s PLIST(4)=result.Data("BonusYear")
	  s PLIST(5)=result.Data("BonusPeriod")
	  s PLIST(6)=result.Data("ExecuteUnitID")
	  s PLIST(7)=result.Data("CalculateUnit")
	  s PLIST(8)=result.Data("ItemValue")
	  
	  s sRate= ..GetExpendRate(BonusUnitID,ExpendItemCode,UnitType)
	  
	  s PLIST(9)=sRate
	  s PLIST(10)=PLIST(9)*PLIST(8)
	  
	  s PLIST(11)=result.Data("State")
	  s PLIST(12)=result.Data("InterLocMethodID")
	  s PLIST(13)=result.Data("UpdateDate")
	  s PLIST(14)=result.Data("BonusSubItemID")
	  s PLIST(15)=result.Data("UnitType")
	  
	  &sql(insert into  dhc_bonus_subs.BonusSubExpendDetail values PLIST())
	  
	 /*
	  s num=0 
	  f  s num = num+1 q:num>$l(sRate,"^")  d
	  .s PLIST(9)=$p(sRate,"^",num) 
	  .s PLIST(10)=PLIST(9)*PLIST(8)
	  .;w PLIST(9)_":"_PLIST(10),!
	  . &sql(insert into  dhc_bonus_subs.BonusSubExpendDetail values PLIST())
	  */
	  
	}
	q 0
}

/// Creator: zhao liguo
/// CreatDate: 2011-6-27
/// Description: 工作量项目提取明细表
/// Table：dhc.bonus.data.BonusItemType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回 param:121:W0216010002
/// Others: w ##class(dhc.bonus.usubs.uBonusSubExpendDetail).GetExpendRate(325,"W0216010002")
ClassMethod GetExpendRate(BonusUnitID, SubItemCode, UnitType) As %String
{
	n (BonusUnitID, SubItemCode,UnitType)
	
	s selectSql ="   SELECT b.BonusUnit,SubItemCode,CalculateRate,ExecuteRate"
	  _" FROM dhc_bonus_subs.BonusSubExpendRate a,"
	  _" ( SELECT 'G' _ cast(BonusDeptGroupID as varchar(10)) as rowid,BonusUnit,BonusUnit->BonusUnitName"
	  _" FROM dhc_bonus_subs.BonusSubDeptGroupMap"
	  _" union all SELECT 'D' _ BonusUnitID,BonusUnitID,BonusUnitName FROM dhc_bonus_data.bonusUnit "
	  _" ) as b,"
	  _" (  SELECT 'G' _ BonusSubItemGroupID rowID ,BonusSubItemID,BonusSubItemID->SubItemCode,BonusSubItemID->SubItemName"
	  _" FROM dhc_bonus_subs.BonusSubItemGroupMap"
	  _" UNION ALL"
	  _" SELECT 'D' _ BonusSubItemID,BonusSubItemID,SubItemCode,SubItemName"
	  _" FROM dhc_bonus_subs.BonusSubItem WHERE LastStage=1 "
	  _" ) as c"
	  _" where a.BonusUnit = b.rowid and a.BonusSubItem = c.rowID"
	  _" and b.BonusUnit ='"_BonusUnitID_"' and SubItemCode='"_SubItemCode_"'"
	  
	  //查询 核算项目为全部
	  i SubItemCode="0" d
	  .s selectSql = " SELECT b.BonusUnit,'' SubItemCode,CalculateRate,ExecuteRate FROM dhc_bonus_subs.BonusSubExpendRate a, ("
 	  .s selectSql = selectSql_ " SELECT 'G' _ cast(BonusDeptGroupID as varchar(10)) as rowid,BonusUnit,BonusUnit->BonusUnitName  FROM dhc_bonus_subs.BonusSubDeptGroupMap"
  	  .s selectSql = selectSql_" union all SELECT 'D' _ BonusUnitID,BonusUnitID,BonusUnitName   FROM dhc_bonus_data.bonusUnit ) as b  where a.BonusUnit = b.rowid and a.BonusSubItem = '0'"
      .s selectSql = selectSql_" and b.BonusUnit ='"_BonusUnitID_"'"
	 
	  
	  //查询 核算科室为全部
	  i BonusUnitID="0" d
	  .s selectSql =" SELECT '' BonusUnit,SubItemCode,CalculateRate,ExecuteRate FROM dhc_bonus_subs.BonusSubExpendRate a,"
      .s selectSql = selectSql_ " (SELECT 'G' _ BonusSubItemGroupID rowID ,BonusSubItemID,BonusSubItemID->SubItemCode,BonusSubItemID->SubItemName FROM dhc_bonus_subs.BonusSubItemGroupMap"
      .s selectSql = selectSql_ " UNION ALL SELECT 'D' _ BonusSubItemID,BonusSubItemID,SubItemCode,SubItemName   FROM dhc_bonus_subs.BonusSubItem WHERE LastStage=1  ) as c  where a.BonusUnit = '0' and (a.BonusSubItem = c.rowID )"
 	  .s selectSql = selectSql_ " and SubItemCode='"_SubItemCode_"'"
	
   // w selectSql,!
	s result=##class(%Library.ResultSet).%New()
	s rate=1	
	d result.Prepare(selectSql)
	d result.Execute()	
	While(result.Next())
	{
		//s rate=result.Data("CalculateRate")_"^"_result.Data("ExecuteRate")
		i UnitType=1 d
		.s rate = result.Data("CalculateRate")
		e  d
		.i UnitType=2 d
		..s rate = result.Data("ExecuteRate")
		
	}
	
	q rate
}

/// Creator: 赵立国
/// CreatDate: 2011-6-27
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusItemType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.usubs.uBonusSubExpendDetail).Delete(14,51,"2011","M02")
ClassMethod Delete(InterLocSetDr, InterMethodDr, BonusYear, BonusPeriod) As %String
{
	i InterMethodDr'="" d
	.&sql(delete from  dhc_bonus_subs.BonusSubExpendDetail  where %ID>0 and  InterLocMethodID=:InterMethodDr and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod )
	e  d
	.&sql(delete from  dhc_bonus_subs.BonusSubExpendDetail  where %ID>0 and  InterLocMethodID->InterLocSet_rowid=:InterLocSetDr and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod )
	
	q SQLCODE
}

/// Others: w ##class(dhc.bonus.usubs.uBonusSubExpendDetail.test()
ClassMethod test(str) As %String
{
	n (str)
	s num =0
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5E4.uBonusSubExp85DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
