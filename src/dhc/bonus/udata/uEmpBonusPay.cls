Class dhc.bonus.udata.uEmpBonusPay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2016-09-08
/// Description: 查询符合条件的记录
/// Table: dhc_bonus_data.EmpBonusPay
/// Input: sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.bonus.udata.uEmpBonusPay).EmpBonuslist(0,25,"","","demo","","","2015-01","2015-12")
/// others:w ##class(dhc.bonus.udata.uEmpBonusPay).EmpBonuslist(0,25,"","","","","","2016-01","2016-12")
ClassMethod EmpBonuslist(start, limit, sortField, sortDir, CNDr, EmpFieldDr, PayFieldDr, SDDr, EDDr) As %String
{
    n (start, limit,sortField, sortDir, CNDr, EmpFieldDr, PayFieldDr, SDDr, EDDr)
    
    s sDate=$p(SDDr,"-",1)_$p(SDDr,"-",2)
    s eDate=$p(EDDr,"-",1)_$p(EDDr,"-",2)
    
	s sqlStr="SELECT EmpBonusPayID, BonusYear, BonusPeriod, EmpCode, EmpName,c.BonusUnitName  EmpUnit,d.BonusUnitName  PayUnit"
	_", a.DataSource DataType, ItemCode,b.BonusTargetName  ItemName, ItemValue as DataValue,a.UpdateDate"
	_" FROM dhc_bonus_data.EmpBonusPay a,dhc_bonus_data.BonusTarget b,dhc_bonus_data.BonusUnit c,dhc_bonus_data.BonusUnit d"
	_" WHERE a.ItemCode=b.BonusTargetCode  AND a.EmpUnit=*c.BonusUnitCode AND a.PayUnit=*d.BonusUnitCode"
	
    s whereStr=""
	i CNDr'="" d
	.s whereStr = whereStr_" and (EmpName like '%"_CNDr_"%' or EmpCode like '%"_CNDr_"%')" 
	i EmpFieldDr'="" d 
	.s whereStr = whereStr_" and c.%ID = '"_EmpFieldDr_"'" 
	i PayFieldDr'="" d 
	.s whereStr = whereStr_" and d.%ID = '"_PayFieldDr_"'" 
  
    i SDDr'="" d 
	.s whereStr = whereStr_" and BonusYear _ RIGHT(BonusPeriod,2)>="_sDate_""
	i EDDr'="" d 
	.s whereStr = whereStr_" and BonusYear _ RIGHT(BonusPeriod,2)<="_eDate_""     
	
    
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="EmpCode" s sortField1="EmpCode"
	.i sortField="EmpName" s sortField1="EmpName"
	.i sortField="EmpUnitID" s sortField1="c.BonusUnitName"
	.i sortField="PayUnitID" s sortField1="d.BonusUnitName"
	.i sortField="BonusYear" s sortField1="a.BonusYear"
	.i sortField="BonusPeriod" s sortField1="a.BonusPeriod"
	.i sortField="DataType" s sortField1="a.DataSource"
	.i sortField="DataValue" s sortField1="a.ItemValue"
	.i sortField="UpdateDate" s sortField1="a.UpdateDate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY c.BonusUnitName,a.EmpCode"
	s sqlStr=sqlStr_whereStr_sortStr

    ;w sqlStr ,!

    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="EmpBonusPayID^EmpCode^EmpName^EmpUnitID^PayUnitID^BonusYear^BonusPeriod^DataType^DataValue^UpdateDate^ItemName"
	While (result.Next())
	{   
	    s EmpBonusPayID=result.Data("EmpBonusPayID")
		s EmpCode= result.Data("EmpCode")
		s EmpName= result.Data("EmpName")
		s EmpUnitID= result.Data("EmpUnit")
		s PayUnitID= result.Data("PayUnit")
		s BonusYear= result.Data("BonusYear")
		s BonusPeriod= result.Data("BonusPeriod")
		i $l(BonusPeriod)=3 d
		.s BonusPeriod=$e(BonusPeriod,2,3)

		s DataType= result.Data("DataType")
		i DataType'="" d
		.i DataType=1 s DataType="核算分配"
		.i DataType=2 s DataType="文件导入"
		s DataValue= result.Data("DataValue")
		s DataValue=$fn(DataValue,"",2)
		s ItemName= result.Data("ItemName")
		s UpdateDate= result.Data("UpdateDate")
		
		s tmp=EmpBonusPayID_"^"_EmpCode_"^"_EmpName_"^"_EmpUnitID_"^"_PayUnitID_"^"_BonusYear_"^"_BonusPeriod_"^"_DataType_"^"_DataValue_"^"_UpdateDate_"^"_ItemName
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 陈明
/// Description: 下拉框选择核算单元
/// Table：dhc_bonus_data.BonusUnit
/// others:w ##class(dhc.bonus.udata.uEmpBonusPay).getUnitList(0,10,"")
ClassMethod getUnitList(start, limit, str) As %String
{
    n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	
	;k ^ceshi
	;s ^ceshi=str
	s sqlStr = "SELECT distinct BonusUnitID , BonusUnitName FROM dhc_bonus_data.BonusUnit"
	s whereStr=" WHERE UnitFlag=1  AND IsValid=1 "
	i str'="" s whereStr = whereStr_" and (BonusUnitName LIKE '%"_str_"%')"
	
	s sqlStr=sqlStr_whereStr
	
	//w sqlStr,!
	;b ;009
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	
	d json.InsertRowData("^全部")
	
	While(result.Next()){	
	s rowid = result.Data("BonusUnitID")
	s name = result.Data("BonusUnitName")
	
	
	s tmp=rowid_"^"_name
	
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	;w tmp
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uEmpBonusPayS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
