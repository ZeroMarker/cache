Class dhc.bonus.usubs.uBonusSubMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhao liguo
/// CreatDate: 2011-6-16
/// Description: 查询符合条件的记录
/// Table: dhc_bonus_subs.BonusSubMain
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.usubs.uBonusSubMain).ListRec("2011","01","M","1","","",0,25)
ClassMethod ListRec(CycleDr, period, frequency, dataType, sortField, sortDir, start, limit) As %String
{
		n (CycleDr, period, frequency,dataType, sortField, sortDir,start,limit)
			
		s sqlStr="select BonusSubMainID,BonusUnitID,BonusUnitID->BonusUnitName, BonusTargetID,BonusTargetID->BonusTargetName, BonusYear, BonusPeriod,BonusValue,UpadeDate "
			_" ,case DataType when 1 then '收入项目' when 2 then '工作量项目' when 3 then '支出项目' end as DataType "
			_" from dhc_bonus_subs.BonusSubMain "
 			_" where  DataType='"_dataType_"' and BonusYear='"_CycleDr_"' and BonusPeriod='"_frequency_period_"'"
		
 		//w sqlStr,!
		s sortStr=""
		s sortField1=""
		
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusSubMainID"
		.i sortField="BonusUnitName" s sortField1="BonusUnitID->BonusUnitName"
		.i sortField="BonusTargetName" s sortField1="BonusTargetID->BonusTargetName"
		.i sortField="BonusYear" s sortField1="BonusYear"
		.i sortField="BonusPeriod" s sortField1="BonusPeriod"
		
		.i sortField="BonusValue" s sortField1="BonusValue"
		.i sortField="DataType" s sortField1="DataType"
		.i sortField="UpadeDate" s sortField1="UpadeDate"
		
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
		
		s jsonTitle="rowid^BonusUnitID^BonusUnitName^BonusTargetID^BonusTargetName^BonusYear^BonusPeriod^BonusValue^DataType^UpadeDate"

		While(result.Next())
		{
							
			s rowid=result.Data("BonusSubMainID")
          
            s BonusTargetID = result.Data("BonusTargetID")
            s BonusTargetName = result.Data("BonusTargetName")
       
            s BonusUnitID     =result.Data("BonusUnitID")  
			s BonusUnitName     =result.Data("BonusUnitName")    
			  
			s BonusYear          =result.Data("BonusYear")         
			s BonusPeriod        =result.Data("BonusPeriod")       
			s BonusValue   =result.Data("BonusValue")  
			s DataType   =result.Data("DataType")
		
			s UpadeDate    =result.Data("UpadeDate")
						 
			s ptype =$E(BonusPeriod,1,1)
		
			
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s BonusPeriod =$E(BonusPeriod,2,10)
	
			
			s BonusPeriod = BonusPeriod_periodType
			
			s tmp=rowid_"^"_BonusUnitID_"^"_BonusUnitName_"^"_BonusTargetID_"^"_BonusTargetName_"^"_BonusYear_"^"_BonusPeriod_"^"_BonusValue_"^"_DataType_"^"_UpadeDate

			s count=count+1
			
		
			i (count>start)&(count<=end) d
			.d json.InsertRowData(tmp)
		}
		
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-6-20
/// Description: 查询
/// Table：dhc_bonus_subs.BonusSubTargetFilter
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.usubs.uBonusSubMain).Delete("2011","M04","1","")
ClassMethod Delete(BonusYear, BonusPeriod, TargetType, TargetID) As %String
{
	n (BonusYear, BonusPeriod, TargetType, TargetID)
	
	//w BonusYear_":"_ BonusPeriod_":"_TargetType_":"_TargetID,!
	s delmain="delete FROM dhc_bonus_subs.BonusSubMain "
		_" Where BonusYear ='"_BonusYear_"'  and BonusPeriod='"_BonusPeriod_"' and DataType='"_TargetType_"'"
	
    s delMainDetail ="delete FROM dhc_bonus_subs.BonusSubIncomeMap where BonusSubMainID in ( "
    	_" select BonusSubMainID FROM dhc_bonus_subs.BonusSubMain "
    	_" Where BonusYear ='"_BonusYear_"'  and BonusPeriod='"_BonusPeriod_"' and DataType='"_TargetType_"')"
    
	//w delmain,! 
	//w delMainDetail,! 
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(delMainDetail)
	d result.Execute()
	d result.Close()
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(delmain)
	d result.Execute()
	d result.Close()
	
	q 0
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-6-20
/// Description: 查询
/// Table：dhc_bonus_subs.BonusSubTargetFilter
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.usubs.uBonusSubMain).subTargetTypeList(0,10,"1")
ClassMethod subTargetTypeList(start, limit, ItemTypeID) As %String
{
	n (start, limit,ItemTypeID)

	s sqlStr="SELECT distinct BonusTargetID ,BonusTargetID->BonusTargetName"
		_" FROM dhc_bonus_subs.BonusSubTargetFilter"
		_" WHERE BonusSubItemID->SubItemType= '"_ItemTypeID_"'"
	

	;w sqlStr,! 
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	

	//取结构 
	While(result.Next()){
		
		s rowid = result.Data("BonusTargetID")
		s name = result.Data("BonusTargetName")
					
		s tmp=rowid_"^"_name

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：zhaoliguo
/// CreatDate：2011-6-20
/// Description: 查询
/// Table：dhc.bonus.data.BonusItemType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.usubs.uBonusSubMain).subSumData("2011","M04",1,"")
ClassMethod subSumData(BonusYear, BonusPeriod, TargetType, TargetID) As %String
{
	n (BonusYear,BonusPeriod,TargetType,TargetID)
	
	//分解前先删除存在的数据
	d ..Delete(BonusYear,BonusPeriod,TargetType,TargetID)
	
	i TargetType=1 d 
	 .s sqlStr="SELECT distinct BonusSubIncomeDetailID rowid,BonusUnitID,a.BonusTargetID,BonusYear,BonusPeriod,ResultMoney"
	 .s sqlStr= sqlStr_" FROM dhc_bonus_subs.BonusSubIncomeDetail a ,dhc_bonus_subs.BonusSubTargetFilter b"
     .s sqlStr= sqlStr_ " where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
	 .s sqlStr= sqlStr_ " and a.BonusTargetID= b.BonusTargetID  and b.BonusSubItemID->SubItemType='"_TargetType_"'"
	 e  d
	 .s sqlStr="SELECT distinct BonusSubExpendDetailID rowid,BonusUnitID,a.BonusTargetID,BonusYear,BonusPeriod,ItemResult ResultMoney"
	 .s sqlStr= sqlStr_" FROM dhc_bonus_subs.BonusSubExpendDetail a ,dhc_bonus_subs.BonusSubTargetFilter b"
     .s sqlStr= sqlStr_ " where BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
	 .s sqlStr= sqlStr_ " and a.BonusTargetID= b.BonusTargetID  and b.BonusSubItemID->SubItemType='"_TargetType_"'"

			
	//q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	k ^SubIncomeMapTemp($j)
	k ^BonusSubMainTemp($j)
	s num =0
	//取结构 
	While(result.Next()){
		
		s IncomeDetailID = result.Data("rowid")
		
		s BonusYear = result.Data("BonusYear")
		s BonusPeriod = result.Data("BonusPeriod")
		
		s BonusUnitID = result.Data("BonusUnitID")
		s BonusTargetID = result.Data("BonusTargetID")
		s ResultMoney = result.Data("ResultMoney")
			
		//w ResultMoney,!
		s ^SubIncomeMapTemp($j,BonusUnitID,BonusTargetID,IncomeDetailID) = ResultMoney+$g(^SubIncomeMap($j,BonusUnitID,BonusTargetID,IncomeDetailID))
		s ^BonusSubMainTemp($j,BonusUnitID,BonusTargetID) = ResultMoney+$g(^BonusSubMainTemp($j,BonusUnitID,BonusTargetID))
		s num =num+1

	}
		
	s unitID = ""
	
	f  s unitID=$o(^BonusSubMainTemp($j,unitID)) q:unitID=""  d
	.s targetid = ""
	.f  s targetid=$o(^BonusSubMainTemp($j,unitID,targetid)) q:targetid=""  d
	..s sumValue = $g(^BonusSubMainTemp($j,unitID,targetid))
	..s mainID=..InsertSubMain(unitID,targetid,BonusYear,BonusPeriod,sumValue,TargetType)
	..s DetailID=""
	..f  s DetailID=$o(^SubIncomeMapTemp($j,unitID,targetid,DetailID)) q:DetailID=""  d
	...d ..InsertSubIncomeMap(mainID,DetailID)
	
	d result.Close()
	k ^SubIncomeMapTemp($j)
	k ^BonusSubMainTemp($j)
	q 0
}

/// Creator: zhao liguo
/// CreatDate: 2011-6-20
/// Description: 增加奖金辅助指标汇总表
/// Table：dhc.bonus.data.BonusItemType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uBonusItemType).Delete(1)
ClassMethod InsertSubMain(BonusUnitID, BonusTargetID, BonusYear, BonusPeriod, BonusValue, dataType) As %String
{
	s sdate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),3)
	&sql(insert into  dhc_bonus_subs.BonusSubMain(BonusUnitID,BonusTargetID,BonusYear,BonusPeriod ,BonusValue, DataType,UpadeDate) values( :BonusUnitID,:BonusTargetID,:BonusYear,:BonusPeriod ,:BonusValue,:dataType,:sdate))
	
	q %ROWID
}

/// Creator: zhao liguo
/// CreatDate: 2011-6-20
/// Description: 增加奖金辅助指标汇总表
/// Table：dhc.bonus.data.BonusItemType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.udata.uBonusItemType).Delete(1)
ClassMethod InsertSubIncomeMap(MainID, DetailID) As %String
{
	&sql(insert into  dhc_bonus_subs.BonusSubIncomeMap(BonusSubMainID,BonusSubIncomeDetailID) values(:MainID,:DetailID))
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.usubs.uBonusSubMainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
