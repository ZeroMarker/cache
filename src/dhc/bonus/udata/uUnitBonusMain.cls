/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-16
/// Description: 科室奖金核算主表
Class dhc.bonus.udata.uUnitBonusMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

///  Creator: zhao liguo
///  CreatDate: 2011-01-13
///  Description: 查询奖金核算情况
///  Table: dhc.bonus.data.UnitBonusPay
///  Input: bonusYear-核算年度； bonusPeriod-核算期间；Start-起始行;Limit-行数;
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.bonus.udata.uUnitBonusMain).BonusSchemeCalc("a0063","2013","M03",8,0,25)
ClassMethod BonusSchemeCalc(empCode, bonusYear, bonusPeriod, schemeType, start, limit) As %String
{
	n (empCode,bonusYear,bonusPeriod,schemeType,start,limit)
	s sqlStr=""
	s sqlStr=sqlStr_" select distinct a.UnitBonusMainID,a.IssuedPerson,a.IssuedDate,a.IsPay,b.BonusSchemeID,b.BonusSchemeCode,b.BonusSchemeName,'"_bonusYear_"' as BonusYear"
	s sqlStr=sqlStr_" ,Case when Left('"_bonusPeriod_"',1)='M' then right('"_bonusPeriod_"',2)_'月份'  when Left('"_bonusPeriod_"',1)='Q' then right('"_bonusPeriod_"',2)_'季度'   when'H01'='"_bonusPeriod_"' then  '上半年'"
	s sqlStr=sqlStr_"  when'"_bonusPeriod_"'='H02' then  '下半年' when Left('"_bonusPeriod_"',1)='Y' then '' end as BonusPeriod"
	s sqlStr=sqlStr_" ,Case a.CalcFlag when null then '未核算' else '已核算'  end as CalcFlag ,a.CalcDate "
	s sqlStr=sqlStr_" ,Case when a.AuditingFlag=0 or a.AuditingFlag= null then '未审核' else '已审核'  end as  AuditingFlag ,a.AuditingDate"
	//s sqlStr=sqlStr_" ,Case when a.IsPay = 0 or a.IsPay = null then '未发放' else '已发放' end as IsPay ,PayDate"
	s sqlStr=sqlStr_" from dhc_bonus_data.UnitBonusMain  a  right join dhc_bonus_data.BonusScheme b on a.BonusSchemeID = b.BonusSchemeID"
	s sqlStr=sqlStr_" and a.BonusYear='"_bonusYear_"' and BonusPeriod='"_bonusPeriod_"'"
	s sqlStr=sqlStr_"  join dhc_bonus_data.BonusSchemeItem c  on b.BonusSchemeID = c.BonusSchemeID "
	s sqlStr=sqlStr_"  join dhc_bonus_data.BonusSchemeUnit d  on b.BonusSchemeID = d.BonusSchemeID  "
	s sqlStr=sqlStr_"  join dhc_bonus_data.BonusEmpScheme e  on b.BonusSchemeID = e.BonusSchemeID  "
	s sqlStr=sqlStr_" where b. IsValid=1 and b.SchemeState=1 and b.SchemeType= "_schemeType
	s sqlStr=sqlStr_" and UPPER(e.BonusEmpID->EmployeeCode)=UPPER('"_empCode_"')"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	;w sqlStr,!
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusSchemeCode^BonusSchemeName^BonusYear^BonusPeriod^CalcFlag^CalcDate^AuditingFlag^AuditingDate^person^IsDate^IsPay"
	
	While(result.Next()){
		
		s rowid=result.Data("UnitBonusMainID")
		
		s BonusSchemeID=result.Data("BonusSchemeID")
		
		s BonusSchemeCode=result.Data("BonusSchemeCode")	
		s BonusSchemeName=result.Data("BonusSchemeName")
		s BonusYear=result.Data("BonusYear")
		s BonusPeriod=result.Data("BonusPeriod")
		s CalcFlag=result.Data("CalcFlag")
		s CalcDate=result.Data("CalcDate")
		if (CalcDate'="")  d
		.s CalcDate = $zd(CalcDate,3)
		
		s AuditingFlag=result.Data("AuditingFlag")
		s AuditingDate=result.Data("AuditingDate")
		
		s person=result.Data("IssuedPerson")
		s IsDate=result.Data("IssuedDate")
		s IsPay=result.Data("IsPay")
		
		if (AuditingDate'="")  d
		.s AuditingDate = $zd(AuditingDate,3)
		
		i (AuditingDate="")&(AuditingFlag="已审核")  d
		.s AuditingDate=$zd(($list(^dhcbsBonusSchemeD(BonusSchemeID),11)),3)
		
		s tmp=rowid_"^"_BonusSchemeCode_"^"_BonusSchemeName_"^"_BonusYear_"^"_BonusPeriod_"^"_CalcFlag_"^"_CalcDate_"^"_AuditingFlag_"^"_AuditingDate_"^"_person_"^"_IsDate_"^"_IsPay
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-17
/// Description: 奖金核算审核
/// Table: dhc.bonus.data.UnitBonusPay
/// Input: rowid-主键;IsPay-是否审核，0:不审核，1:审核;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uUnitBonusMain).UnitBonusMainAuditing(124,0)
ClassMethod UnitBonusMainAuditing(rowid, IsAuditing) As %String
{
		
	n (rowid,IsAuditing)
	;w rowid_":"_IsAuditing,!
	k PLIST
	q:rowid="" "EmptyRecData"
	q:IsAuditing="" "EmptyRecData"
	
	s PLIST(7)=IsAuditing
	s PLIST(8)=$P($H,",",1)
	&SQL(update dhc_bonus_data.UnitBonusMain  VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-17
/// Description: 保存奖金核算主表
/// Table: dhc.bonus.data.UnitBonusMain
/// Input: sData格式：BonusSchemeID^BonusYear^BonusPeriod 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uUnitBonusMain).SetUnitBonusMain("1^2010^M03")       
ClassMethod SetUnitBonusMain(sdata) As %String
{
	n (sdata)
	
	k PLIST,dList
	q:sdata="" "EmptyRecData"

	
	s BonusSchemeID=$p(sdata,"^",1) 
	s BonusYear=$p(sdata,"^",2)
	s BonusPeriod=$p(sdata,"^",3)
	
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	i BonusYear'="" s PLIST(3)=BonusYear
	i BonusPeriod'="" s PLIST(4)=BonusPeriod
	
	s PLIST(5)=1 		
	s PLIST(6)=	$p($H,",",1) 		
	;s PLIST(11)=0  

	s PLIST(7)=0 		
	
	s PLIST(9)=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
    
	s rtn = 0
	&sql(delete from dhc_bonus_data.UnitBonusMain where BonusSchemeID=:BonusSchemeID  and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod)
	s rtnNo =SQLCODE
	if rtnNo '= 0 s rtn = rtnNo
	
	&sql(insert into  dhc_bonus_data.UnitBonusMain values PLIST())
	s rtnNo = SQLCODE
	if rtnNo '= 0 s rtn = rtnNo
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.ud5C1.uUnitBonusMainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
