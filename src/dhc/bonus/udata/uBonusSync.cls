Class dhc.bonus.udata.uBonusSync Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：zlg
/// CreatDate：2013-8-12
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusUnit
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusSync).BonusUnitSync("3288","眼科1","0","1","1","2")
ClassMethod BonusUnitSync(Deptcode, Deptname, SupDeptCode, lastStage, level, DataFlag) As %String
{
	n (Deptcode, Deptname,SupDeptCode,lastStage, level,DataFlag)

	s sdate=$zd($p($h,",",1),3)
	;w Deptcode_"^"_Deptname_"^"_SupDeptCode_"^"_lastStage_"^"_ level_"^"_DataFlag _"^"_sdate,!
	
	;s str="insert into dhc_bonus_data.BonusUnit(BonusUnitCode,BonusUnitName,UnitFlag,SuperiorUnitID,UnitLevel, LastStage,UpdateDate, IsValid)"_" values("_Deptcode_","_Deptname_",'1','0',"_level_","_lastStage_","_sdate_",'1')"
	 s UnitFlag=1
	 s SuperiorUnitID=0
	 s IsValid=1


	i DataFlag=1 d
	.d ##class(dhc.bonus.udata.uBonusUnit).InsertRec(Deptcode,Deptname,"","1","1",lastStage,"0",level)
	.;&sql(insert into dhc_bonus_data.BonusUnit (BonusUnitCode,BonusUnitName,EmployeeNo,UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID) 	values(:Deptcode,:Deptname,'','1','0',:level,:lastStage,:sdate,'1','1'))
    
	 
	 i DataFlag=2 d
	.&sql(update dhc_bonus_data.BonusUnit set BonusUnitCode=:Deptcode,BonusUnitName=:Deptname,UnitLevel=:level
	,LastStage=:lastStage,UpdateDate=:sdate where BonusUnitCode=:Deptcode)
	.s rtn=SQLCODE
	
	i DataFlag=3 d
	.&sql(delete from  dhc_bonus_data.BonusUnit where BonusUnitCode=:Deptcode)
	.s rtn=SQLCODE
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uBonusSyncS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
