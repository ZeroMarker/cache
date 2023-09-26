/// Creator: zhaoliguo
/// CreatDate: 2013-08-13
/// Description:绩效、奖金同集成平台数据同步
Class dhc.bonus.udata.uDataSync Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：zlg
/// CreatDate：2013-8-12
/// Description: 插入新数据
/// Table：dhc.bonus.data.BonusUnit
/// Input：code-代码;name-名称;
/// Output：data=Code_”^”_Name_”^”_LocLevel_”^”_Super_”^”_State_”^”_IsLast  
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uDataSync).BonusUnitSync("y1234^眼科77^3^0^2^1")
ClassMethod BonusUnitSync(sData) As %String
{
	n (sData)
	
	s Deptcode=$p(sData,"^",1)
	s Deptname=$p(sData,"^",2)
	s SupDeptCode=$p(sData,"^",4)
	s lastStage=$p(sData,"^",6)
	s level=$p(sData,"^",3)
	s DataFlag=$p(sData,"^",5)
	
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s UpdateDate=$zdh(UpdateDate,3)
		
	s UnitFlag=1
	s SuperiorUnitID=0
	s IsValid=1
	i lastStage=1 d
	.s isend="Y"
	e  d
	.s isend="N"

	i DataFlag=1 d
	.&sql(insert into dhc_bonus_data.BonusUnit (BonusUnitCode,BonusUnitName,EmployeeNo,UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID) 	values(:Deptcode,:Deptname,'','1','0',:level,:lastStage,:UpdateDate,'1','1'))
	.&sql(insert into dhc_pa_data.JXUnit(JXUnit_code, JXUnit_name,JXUnit_isEnd,JXUnit_level,JXUnit_parent ) values(:Deptcode,:Deptname,:isend,:level,'0'))
    .s rtn=SQLCODE
	 
	 i DataFlag=3 d
	.&sql(update dhc_bonus_data.BonusUnit set BonusUnitCode=:Deptcode,BonusUnitName=:Deptname,UnitLevel=:level,LastStage=:lastStage,UpdateDate=:UpdateDate where BonusUnitCode=:Deptcode)
	.&sql(update dhc_pa_data.JXUnit set JXUnit_code=:Deptcode, JXUnit_name=:Deptname,JXUnit_isEnd=:isend,JXUnit_level=:level where JXUnit_code=:Deptcode)

	.s rtn=SQLCODE
	
	i DataFlag=2 d
	.&sql(delete from  dhc_bonus_data.BonusUnit where BonusUnitCode=:Deptcode)
	.&sql(delete from  dhc_pa_data.JXUnit where JXUnit_code=:Deptcode)
	.s rtn=SQLCODE
	
	q rtn
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uDataSyncS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
