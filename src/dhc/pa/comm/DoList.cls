Class dhc.pa.comm.DoList Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.pa.comm.DoList).DoALLlist()
ClassMethod DoALLlist() As %String
{

 w ##class(dhc.pa.udata.uKPIIndex).GetDimType(0,10,"")
 w ##class(dhc.pa.udata.uKPIIndex).GetKPIs2(0,10,"")
 
 w ##class(dhc.pa.udata.uInterLocSet).List("","","rowid","ASC",0,25)
 w ##class(dhc.pa.udata.uOutKpiRule).LocSetList("","","rowid","ASC",0,25)
 w ##class(dhc.pa.udata.uOutKpiRule).OutKpiList(1,"","","rowid","asc","","")
 w ##class(dhc.pa.udata.uInterPeriod).GetLocSet(0,10,"")
 w ##class(dhc.pa.udata.uInterPeriod).List(1,"","","rowid","ASC",0,25)
 
 w ##class(dhc.pa.udata.uInterKPI).GetKPIs("","",0,10,"")
 w ##class(dhc.pa.udata.uInterKPI).ListRec("Y","","","rowid","ASC",0,25,5)
 w ##class(dhc.pa.udata.uInterLoc).ListRec("Y","","","","DESC",0,25,1)
 w ##class(dhc.pa.udata.uJXBaseData).GetPeriod(0,10,"")
 w ##class(dhc.pa.udata.uJXBaseData).List("","","KPIName","DESC",0,25,"201301","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","KPIName","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","KPIName","ASC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","parRefName","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","parRefName","ASC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","auditUserName","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","auditUserName","ASC",0,25,"","M",1)
 
 w ##class(dhc.pa.udata.uJXBaseData).List("","","dataStateName","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","dataStateName","ASC",0,25,"","M",1)
 
 w ##class(dhc.pa.udata.uJXBaseData).List("","","period","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","period","ASC",0,25,"","M",1)

 w ##class(dhc.pa.udata.uKPIAudit).findUser(0,25,"沈")
 w ##class(dhc.pa.udata.uSchem).ListRec("","","","","",0,25)

 w ##class(dhc.pa.udata.uStratagem).List("Y",1,"1","","","rowid","DESC",0,25)
 w ##class(dhc.pa.udata.uSchemDetail).List("","","","",0,25,"1||1","roo")
 w ##class(dhc.pa.udata.uUnitSchem).SchemList("Y","","","rowid","DESC",0,25,"M")
 w ##class(dhc.pa.udata.uUnitSchem).JXUnitList("","","rowid","DESC",0,25,"1||28")
 w ##class(dhc.pa.udata.uUnitSchem).GetSchemDetail("roo","1||6","","","","")
 w ##class(dhc.pa.udata.uUnitSchem).GetJXUnit("Demo")
 w ##class(dhc.pa.udata.uDistTarget).GetKPI(0,10,"1||6","demo")
 w ##class(dhc.pa.udata.uDistTarget).GetDept(0,10,"1||6")
 w ##class(dhc.pa.udata.uKPITargetSet).Period(0,10,"")
 w ##class(dhc.pa.udata.uUserSchemAudit).List("","","","","0","25")
 w ##class(dhc.pa.udata.uUserSchemAudit).GetJXSchem("","","","",0,25)
 w ##class(dhc.pa.udata.uAdjust).UnitList(0,25,"")
 w ##class(dhc.pa.udata.uPAAudit).GetSchem2("Y","","M","demo")
 w ##class(dhc.pa.udata.uResultQuery).GetDeptTreeRoo("1||4","","","","",0,25)
 w ##class(dhc.pa.udata.uResultQuery).GetDeptTreeList("1||4","deptRoo","","","","",0,25)
 w ##class(dhc.pa.udata.uResultQuery).GetKPITreeList(1,1,"roo","1||2",25,"","","","")
 w ##class(dhc.pa.udata.uJXFeedback).GetDept(0,10,"1||1")
 w ##class(dhc.pa.udata.uJXFeedback).List("","","","",0,25,"1||1","roo",1,1,6)
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitCode","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitCode","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitName","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitName","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitLocCode","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitLocCode","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitLocName","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outUnitLocName","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","unitType","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","unitType","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outKpiCode","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outKpiCode","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outKpiName","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","outKpiName","DESC",0,25,"1","1","M","1")

 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","period","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","period","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","periodType","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","periodType","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","actValue","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","actValue","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","active","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","active","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","handFlag","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","handFlag","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","kpiCode","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","kpiCode","DESC",0,25,"1","1","M","1")
 
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","kpiName","ASC",0,25,"1","1","M","1")
 w ##class(dhc.pa.udata.uOutKPIData).ListRec("","","","kpiName","DESC",0,25,"1","1","M","1")

 w ##class(dhc.pa.udata.uJXBaseData).List("","","periodTypeName","DESC",0,25,"201305","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","periodTypeName","ASC",0,25,"201305","M",1)

 w ##class(dhc.pa.udata.uJXBaseData).List("","","actualValue","DESC",0,25,"201305","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","actualValue","ASC",0,25,"201305","M",1)

 w ##class(dhc.pa.udata.uJXBaseData).List("","","auditDate","DESC",0,25,"201305","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","auditDate","ASC",0,25,"201305","M",1)
 
 
 
  w ##class(dhc.pa.udata.uJXBaseData).List("","","periodTypeName","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","periodTypeName","ASC",0,25,"","M",1)

 w ##class(dhc.pa.udata.uJXBaseData).List("","","actualValue","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","actualValue","ASC",0,25,"","M",1)

 w ##class(dhc.pa.udata.uJXBaseData).List("","","auditDate","DESC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uJXBaseData).List("","","auditDate","ASC",0,25,"","M",1)
 w ##class(dhc.pa.udata.uKPITargetSet).GetKPIs("","",0,10,"出")
 w ##class(dhc.pa.udata.uKPITargetSet).getTargetInfo("", "","rowid","DESC",0,25,"201302", "M", 5)

 w ##class(dhc.pa.udata.uKPITargetSet).GetSchemDetailOfUnit("1","1||23",49,"","","","")
 w ##class(dhc.pa.udata.uKPITargetSet).GetSchemDetailOfUnit("-1","1||23",49,"","","","")
 w ##class(dhc.pa.udata.uCycle).ListRec("","","","code","DESC",0,25)
 w ##class(dhc.pa.udata.uCycle).ListRec("","","","code","ASC",0,25)
 w ##class(dhc.pa.udata.uKPIIndex).GetCalUnit(0,10,"")
 
 w ##class(dhc.pa.udata.uJXUnit).GetStratagem(0,10,"")
 w ##class(dhc.pa.udata.uJXUnit).GetLocType(0,10,"")
 w ##class(dhc.pa.udata.uJXUnitAudit).GetJXUnit(0,10,"")
 w ##class(dhc.pa.udata.uJXGroup).GetJXUnit(1)
 w ##class(dhc.pa.udata.uJXGroup).GetEndKPI("demo")
 w ##class(dhc.pa.udata.uStratagem).List("Y",1,"1","","","rowid","DESC",0,25)
 w ##class(dhc.pa.udata.uStratagem).List("Y","","","","","rowid","DESC",0,25)
 w ##class(dhc.pa.udata.uPAAudit).GetCycle2("Y",1)
 w ##class(dhc.pa.udata.uDistTarget).GetSchemOfRowid("Y","1||1")
 w ##class(dhc.pa.udata.uDistTarget).GetDept2(5)
 w ##class(dhc.pa.udata.uDistTarget).GetKPI2(34)
 w ##class(dhc.pa.udata.uDistTarget).GetData(1,"1||1","7","5",0,30)
 w ##class(dhc.pa.udata.uAdjust).UnitList(0,10,"1")
 w ##class(dhc.pa.udata.uAdjust).ListRec("1","","","rowid","DESC",0,10)
 
 w ##class(dhc.pa.udata.uResultQuery).GetDeptTreeRoo("1||1","","","","","","")
 w ##class(dhc.pa.udata.uOutKpiRule).OutKpiList(1,"","","","",0,10)
 
 





 q 0
}

Storage Default
{
<StreamLocation>^dhc.pa.comm.DoListS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
