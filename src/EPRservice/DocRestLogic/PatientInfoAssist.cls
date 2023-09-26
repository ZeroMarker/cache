/// Creator: 陈文俊
/// CreatDate: 
/// Description：取出病人在规则项目中的值(新框架模板权限用，如 科室 性别 等)
/// 
Class EPRservice.DocRestLogic.PatientInfoAssist Extends %RegisteredObject [ ProcedureBlock ]
{

Property AdmId As %String(TRUNCATE = 1);

Property PapmiDR As %String(TRUNCATE = 1) [ ReadOnly ];

Property PatSex As %String(TRUNCATE = 1) [ ReadOnly ];

Property PatDept As %String(TRUNCATE = 1) [ ReadOnly ];

Property PatWard As %String(TRUNCATE = 1) [ ReadOnly ];

Property PatType As %String(TRUNCATE = 1) [ ReadOnly ];

Property PatPriv As %String(TRUNCATE = 1) [ ReadOnly ];

Parameter PATSEXTYPE = "PATSEX";

Parameter PATDEPTTYPE = "PATDEPT";

Parameter PATWARDTYPE = "PATWARD";

Parameter PATTYPETYPE = "PATTYPE";

Parameter PATPRIVTYPE = "PATPRIV";

Method PapmiDRGet() As %String
{
	q:(..AdmId="") ""
	s papmidr=""
	s papmidr=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(..AdmId)
	q papmidr
}

Method PatSexGet() As %String
{
	s papmidr=..PapmiDR
	s sex = ##class(EPRservice.HISInterface.PatientInfoAssist).Gender(papmidr)
	s sex = $p(sex,"^",2)
	
	s resultSex = ..#PATSEXTYPE_$c(2)_sex
	
	q resultSex
}

Method PatDeptGet() As %String
{
	s dept = ""
	s dept = ..GetDept(..AdmId)
	
	//根据字典表配置取对应科室信息，兼容各医院数据 -- modified on 2009-07-17 by houj 
	s codeCol = ""
	&sql(select DicCodeCol into :codeCol from EPRmeta.StdDictionary where %SQLUPPER(TableName) = ' SQLUSER.CT_LOC')
	if $zcvt(codeCol,"U") = "CTLOC_ROWID"
	{	s dept = $p(dept,"^",1)}
	elseif $zcvt(codeCol,"U") = "CTLOC_CODE"
	{	s dept = $p(dept,"^",2)}
	else
	{	s dept = $p(dept,"^",1)}
	
	s resultDept = ..#PATDEPTTYPE_$c(2)_dept
	q resultDept

	/*
	//先取出是否具有有效的指定科室，如果有则使用指定科室，如果没有则使用病人当前科室
	//注：由于指定科室时，保存的是科室的ID，所以在配置模板权限时，保存的也需要是科室ID，即在配置字典时，编码那一项应配为ID
	s dept = ##class(EPRservice.DocRestLogic.PrivLogic).GetAppointDept(..AdmId)
	if (dept = "")
	{
		s dept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(..AdmId)
		//modified on 2009-07-17 by houj -- 兼容各医院数据
		s codeCol = ""
		&sql(select DicCodeCol into :codeCol from EPRmeta.StdDictionary where %SQLUPPER(TableName) = ' SQLUSER.CT_LOC')
		if $zcvt(codeCol,"U") = "CTLOC_ROWID"
		{	s dept = $p(dept,"^",1)}
		elseif $zcvt(codeCol,"U") = "CTLOC_CODE"
		{	s dept = $p(dept,"^",2)}
		else
		{	s dept = $p(dept,"^",1)}
	}
	
	s resultDept = ..#PATDEPTTYPE_$c(2)_dept

	q resultDept
	*/
}

Method PatWardGet() As %String
{
 	s careUnit = ##class(EPRservice.HISInterface.PatientInfoAssist).CareUnit(..AdmId)
 	//modified on 2009-07-17 by houj -- 兼容各医院数据
 	s codeCol = ""
	&sql(select DicCodeCol into :codeCol from EPRmeta.StdDictionary where %SQLUPPER(TableName) = ' SQLUSER.PAC_WARD')
 	if $zcvt(codeCol,"U")="WARD_ROWID"
 	{	s careUnit = $p(careUnit,"^",1)}
 	elseif $zcvt(codeCol,"U")="WARD_CODE"
 	{	s careUnit = $p(careUnit,"^",2)}
 	else
 	{	s careUnit = $p(careUnit,"^",1)}
 	
 	s resultUnit = ..#PATWARDTYPE_$c(2)_careUnit 
 	q resultUnit
}

Method PatTypeGet() As %String
{
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	
	s type = ""
	s episodeID = ..AdmId
	&SQL(select PatType into :type from EPRinstance.AdmPatType where EpisodeID=:episodeID)
		
	s resultType = ..#PATTYPETYPE_$c(2)_type

	q resultType
}

Method PatPrivGet() As %String
{
	s PatPriv =""
	s PatPriv = ##class(EPRservice.HISInterface.PatientInfoAssist).InterfgetPrivAll()
	
	s resultPatPriv = ..#PATPRIVTYPE_$c(2)_PatPriv

	q resultPatPriv
}

ClassMethod GetDept(argAdmID As %String) As %String
{
	s dept = ""
	
	//先取电子病历转科科室
	s appointDeptID = ##class(EPRservice.DocRestLogic.PrivLogic).GetAppointDept(argAdmID)
	if (appointDeptID '= "")
	{
		s DeptDesc=$p($g(^CTLOC(appointDeptID)),"^",2)
		s DeptCode=$p($g(^CTLOC(appointDeptID)),"^",1)
		s dept = appointDeptID_"^"_DeptCode_"^"_DeptDesc	
	}
		
	if (dept = "")
	{	
		//再取当前科室
		s dept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(argAdmID)
		
		//最后取临时科室
		s tempDept = $$GetTempDept($p(dept,"^",1))
		s:(tempDept'="") dept = tempDept
	}
	
	q dept
	
GetTempDept(curDeptId)
	q:(curDeptId="") ""
	
	//临时科室功能是否开启
	s TPrivTempDept = ##class(EPRmeta.SysOption).GetOptionValueByName("TPrivTempDept")
	q:((TPrivTempDept="")||($zcvt(TPrivTempDept,"U")="NULL")) ""
	
	//临时科室是否存在		
	s tmpDept = ##class(EPRservice.HISInterface.PatientInfoAssist).TempDept(argAdmID)
	s tmpDeptId = $P(tmpDept,"^",1)
	q:(tmpDeptId="") ""
	
	//是否与母亲绑定
	s isMotherRefExist = $P($g(^PAADM(argAdmID)),"^",75)
	q:(isMotherRefExist="") ""
	
	//若所有科室都启用，直接返回临时科室信息
	q:($zcvt(TPrivTempDept,"U")="ALL") tmpDept
	
	//当前科室是否在启用临时科室列表中
	s TPrivTempDept = "^"_TPrivTempDept_"^"
	q:($f(TPrivTempDept,"^"_curDeptId_"^")>0) tmpDept
	
	q ""
}

}
