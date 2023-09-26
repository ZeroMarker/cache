Class dhc.bonus.udata.DeptManager Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod InsertRec(code, name, EmployeeNo, unitFlag, unitType, lastStage, parent, level, sumunit, startDate) As %String
{
	
	n (code,name,EmployeeNo,unitFlag,unitType,lastStage,parent, level,sumunit,startDate)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	//s rowid=..IfRepName(name)
	//q:rowid>0 "RepName"
	
	s EmployeeNo=code
	
	s level=level+1
	s IsValid=1
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s UpdateDate=$zdh(UpdateDate,3)

	&sql(insert into dhc_bonus_data.BonusUnit (BonusUnitCode,BonusUnitName,EmployeeNo,UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID,sumUnitID,startDate) values(:code,:name,:EmployeeNo,:unitFlag,:parent,:level,:lastStage,:UpdateDate,:IsValid,:unitType,:sumunit,:startDate))
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.DeptManagerS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
