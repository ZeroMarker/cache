/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-14
/// Description: 奖金核算发放
Class dhc.bonus.udata.uUnitBonusPay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhao liguo
/// CreatDate: 2011-01-13
/// Description: 查询奖金核算情况
/// Table: dhc.bonus.data.UnitBonusPay
/// Input: sData格式：BonusSchemeID^BonusUnitID^BonusYear^BonusPeriod^RealBonusID^RealBonus^DeptPersonNumber 
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uUnitBonusPay).SetUnitBonusPay("1^2^2010^M02^8^650^2")       
ClassMethod SetUnitBonusPay(sdata) As %String
{
	n (sdata)
	k PLIST,dList
	q:sdata="" "EmptyRecData"
	
	s BonusSchemeID=$p(sdata,"^",1) 
	s BonusUnitID=$p(sdata,"^",2)
	s BonusYear=$p(sdata,"^",3)
	s BonusPeriod=$p(sdata,"^",4)
	s RealBonusID=$p(sdata,"^",5)
	s RealBonus=$p(sdata,"^",6)
	s DeptPersonNumber=$p(sdata,"^",7)
	
	i BonusSchemeID'="" s PLIST(2)=BonusSchemeID
	i BonusUnitID'="" s PLIST(3)=BonusUnitID
	i BonusYear'="" s PLIST(4)=BonusYear
	i BonusPeriod'="" s PLIST(5)=BonusPeriod
	i RealBonusID'="" s PLIST(6)=RealBonusID
	i RealBonus'="" s PLIST(7)=RealBonus
	i DeptPersonNumber'="" s PLIST(8)=DeptPersonNumber
	s PLIST(9)=0 		
	s PLIST(11)=0 	
	s PLIST(13)=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
    
	s rtn =0 
	&sql(delete from dhc_bonus_data.UnitBonusPay where BonusSchemeID=:BonusSchemeID and BonusUnitID=:BonusUnitID and BonusYear=:BonusYear and BonusPeriod=:BonusPeriod)
	s rtnNo =SQLCODE
	if (rtnNo '=0) || (rtnNo '=100) s rtn = SQLCODE
	
	&sql(insert into  dhc_bonus_data.UnitBonusPay values PLIST())
	s rtnNo = SQLCODE
	if rtnNo '=0 s rtn = SQLCODE
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uUnitBonusPayS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
