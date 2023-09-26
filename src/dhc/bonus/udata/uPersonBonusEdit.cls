/// 人员奖金填报页面
Class dhc.bonus.udata.uPersonBonusEdit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: LXW 
/// CreatDate: 2015-09-14
/// Description: 人员奖金填报页面数据显示（显示每个核算人员所在科室的全部人员）
/// Table：dhc_bonus_data.BonusEmployeeUnit  dhc_bonus_data.BonusTargetCollect
/// Input: BonusYear 年 BonusPeriod 月  userCode 用户编码
/// Output: 
/// Return: 查询到的数据
/// Others:w ##class(dhc.bonus.udata.uPersonBonusEdit).ListRec("2015","M07","demo","","",0,25) 
ClassMethod ListRec(BonusYear, BonusPeriod, userCode, sortField, sortDir, start, limit) As %String
{
  n (BonusYear,BonusPeriod,userCode,sortField,sortDir,start,limit)
  ;^dhcbsBonusEmployeeI("Code","demo","")
  q:(BonusYear="")||(BonusPeriod="") 0
  s EmployID=""
  s SuperUnitID=""
  //获取核算人员所在科室ID 
  i userCode'="" d
  .s EmployID=$O(^dhcbsBonusEmployeeI("Code",userCode,""))
  .i $G(^dhcbsBonusEmployeeD(EmployID))'="" d
  ..s SuperUnitID=$List(^dhcbsBonusEmployeeD(EmployID),5)
  
  s SqlStr="SELECT a.BonusUnitID ,a.BonusUnitName ,b.TargetValue,b.UpdateDate,b.Remark FROM "
          _"dhc_bonus_data.BonusUnit a LEFT JOIN (SELECT BonusUnitID,TargetValue,UpdateDate,Remark FROM dhc_bonus_data.BonusTargetCollect "
          _"WHERE BonusTargetID=184 AND BonusYear='"_BonusYear_"' AND BonusPeriod='"_BonusPeriod_"') b ON  a.BonusUnitID=b.BonusUnitID "
          _"WHERE a.SuperiorUnitID='"_SuperUnitID_"' AND a.BonusUnitTypeID=5"
  
  ;->SuperiorUnitID->BonusUnitName
  s DeptID= ..GetSuperUnitID(userCode)
  s Value = ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetFormulaItemVale("S106500",DeptID_"^"_BonusYear_"^"_BonusPeriod)
  i Value = 0 s Value = ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetFormulaItemVale("S107500",DeptID_"^"_BonusYear_"^"_BonusPeriod)  
  	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(SqlStr)
	d result.Execute()
		 
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="UnitName^BonusYear^BonusPeriod^TargetName^TargetValue^UnitID^TargetID^MaxValue^TargetDesc^UpdateDate"
	;
	While(result.Next()){
	   
	    s UnitName = result.Data("BonusUnitName")
	    s TargetValue=result.Data("TargetValue")
	    s UnitID =result.Data("BonusUnitID")
	    s TargetDesc=result.Data("Remark")
	    s UpdateDate=result.Data("UpdateDate")
	    s MaxValue=Value
	    s tmp=UnitName_"^"_BonusYear_"^"_BonusPeriod_"^"_"个人分配金额"_"^"_TargetValue_"^"_UnitID_"^"_184_"^"_MaxValue_"^"_TargetDesc_"^"_UpdateDate
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: LXW 
/// CreatDate: 2015-09-14
/// Description: 根据奖金核算人员编码，获取其所在科室ID
/// Table：SELECT * FROM dhc_bonus_data.BonusEmployee
/// Input: Code 人员编码
/// Output: 
/// Return: 人员所在科室ID
/// Others:w ##class(dhc.bonus.udata.uPersonBonusEdit).GetSuperUnitID("demo") 
ClassMethod GetSuperUnitID(Code) As %Integer
{
  n (Code)
  q:Code="" 0
  s EmployeeID=""
  s EmployeeID=$O(^dhcbsBonusEmployeeI("Code",Code,EmployeeID))
  q:EmployeeID="" 0
  s SuperUnitID=$List(^dhcbsBonusEmployeeD(EmployeeID),5)
  q SuperUnitID
}

// w ##class(dhc.bonus.udata.uBonusSchemeCalculate).GetFormulaItemVale("T00052","1096^2011^M11^2")

/// Creator：LXW
/// CreatDate：2015-09-16
/// Description:插入数据
/// Table：dhc.bonus.data.BonusTargetCollect
/// Input：
/// Output：
/// Return：有效单位字符串
/// others:w ##class(dhc.bonus.udata.uPersonBonusEdit).Insert1(1665,"2015","M07",183,"22.3","")
ClassMethod Insert(UnitID, BonusYear, BonusPeriod, TargetID, TargetValue, UpdateDate, userCode) As %String
{
	
	n (UnitID,BonusYear,BonusPeriod,TargetID,TargetValue,UpdateDate,userCode)
    s DataSource=0
    s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
    &sql(delete from dhc_bonus_data.BonusTargetCollect where BonusUnitID=:UnitID and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod and BonusTargetID=:TargetID)
	&sql(Insert into dhc_bonus_data.BonusTargetCollect(BonusUnitID,BonusYear,BonusPeriod,BonusTargetID,TargetValue,UpdateDate,DataSource,Remark)values(:UnitID,:BonusYear,:BonusPeriod,:TargetID,:TargetValue,:UpdateDate,:DataSource,:userCode))
	
    q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus8265.uPersonBonuBE17S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
