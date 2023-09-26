/// 名称:	EMR.IP.DTO.PatientInfo
/// 描述:	患者信息
/// 编写者：yejian(lifengbo)
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.IP.DTO.PatientInfo Extends EMR.IP.COM.ActionBase
{

/// 就诊号
Property AdmId As %String(TRUNCATE = 1);

/// 用户ID
Property UserId As %String(TRUNCATE = 1);

/// 取患者指针(PatientID)
Property PapmiDR As %String(TRUNCATE = 1) [ ReadOnly ];

/// 性别
Property PatSex As %String(TRUNCATE = 1) [ ReadOnly ];

/// 当前科室
Property PatDept As %String(TRUNCATE = 1) [ ReadOnly ];

/// 当前病区
Property PatWard As %String(TRUNCATE = 1) [ ReadOnly ];

// Property PatType As %String(TRUNCATE = 1) [ ReadOnly ];

/// 病人类型
/// 所有权限
Property PatPriv As %String(TRUNCATE = 1) [ ReadOnly ];

/// 用户级别
Property PatULevel As %String(TRUNCATE = 1) [ ReadOnly ];

/// 用户语言
Property SSLAN As %String(TRUNCATE = 1) [ ReadOnly ];

Parameter PATSEXTYPE = "PATSEX";

Parameter PATDEPTTYPE = "PATDEPT";

Parameter PATWARDTYPE = "PATWARD";

// Parameter PATTYPETYPE = "PATTYPE";

Parameter PATPRIVTYPE = "PATPRIV";

Parameter PATULEVELTYPE = "PATULEVEL";

Parameter SSLANTYPE = "SSLAN";

Parameter ProductCode = "IP";

Method PatSexGet() As %String
{
	s papmidr = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(..AdmId)
	s sex = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Gender(papmidr)
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
	&sql(select DicCodeCol into :codeCol from CF_EMR_DOC.StdDictionary where %SQLUPPER(TableName) = ' SQLUSER.CT_LOC')
	if $zcvt(codeCol,"U") = "CTLOC_ROWID"
	{	s dept = $p(dept,"^",1)}
	elseif $zcvt(codeCol,"U") = "CTLOC_CODE"
	{	s dept = $p(dept,"^",2)}
	else
	{	s dept = $p(dept,"^",1)}
	
	s resultDept = ..#PATDEPTTYPE_$c(2)_dept
	q resultDept
}

Method PatWardGet() As %String
{
 	s careUnit = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CareUnit(..AdmId)
 	//modified on 2009-07-17 by houj -- 兼容各医院数据
 	s codeCol = ""
	&sql(select DicCodeCol into :codeCol from CF_EMR_DOC.StdDictionary where %SQLUPPER(TableName) = ' SQLUSER.PAC_WARD')
 	if $zcvt(codeCol,"U")="WARD_ROWID"
 	{	s careUnit = $p(careUnit,"^",1)}
 	elseif $zcvt(codeCol,"U")="WARD_CODE"
 	{	s careUnit = $p(careUnit,"^",2)}
 	else
 	{	s careUnit = $p(careUnit,"^",1)}
 	
 	s resultUnit = ..#PATWARDTYPE_$c(2)_careUnit 
 	q resultUnit
}

Method PatPrivGet() As %String
{
	s PatPriv =""
	s PatPriv = ##class(EMR.DOC.HISInterface.PatientInfoAssist).InterfgetPrivAll()
	
	s resultPatPriv = ..#PATPRIVTYPE_$c(2)_PatPriv

	q resultPatPriv
}

Method PatULevelGet() As %String
{
	s PatULevel =""
	s strRowID =""
	s struserid = ..UserId
	s Level=""
	//&sql(SELECT UserLevel into :Level FROM EMRmeta.PowerUser WHERE (UserID = :struserid))
	s resultPatULevel = ..#PATULEVELTYPE_$c(2)_Level

	q resultPatULevel
}

ClassMethod GetDept(argAdmID As %String, aCTLocID As %String) As %String
{
	s dept = ""
	
	//先取电子病历转科科室
	s appointDeptID = ##class(EMR.DOC.BL.PrivLogic).GetAppointDept(argAdmID)
	if (appointDeptID '= "")
	{
		s DeptDesc=$p($g(^CTLOC(appointDeptID)),"^",2)
		s DeptCode=$p($g(^CTLOC(appointDeptID)),"^",1)
		s dept = appointDeptID_"^"_DeptCode_"^"_DeptDesc	
	}
	//登录科室非转移科室，将清空转移科室信息。
	//按患者当前科室执行
	if ((appointDeptID'="")&&(aCTLocID '= appointDeptID))
	{
		s dept=""
	}
	if (dept = "")
	{	
		//再取当前科室
		//s dept = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(argAdmID)
		
		//最后取临时科室
		//s tempDept = $$GetTempDept($p(dept,"^",1))
		//s:(tempDept'="") dept = tempDept
		s dept = aCTLocID
	}
	
	q dept
	
GetTempDept(curDeptId)
	q:(curDeptId="") ""
	
	//临时科室功能是否开启
	s TPrivTempDept = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("TPrivTempDept",..#ProductCode,"")
	q:((TPrivTempDept="")||($zcvt(TPrivTempDept,"U")="NULL")) ""
	
	//临时科室是否存在		
	s tmpDept = ##class(EMR.DOC.HISInterface.PatientInfoAssist).TempDept(argAdmID)
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

Method SSLANGet() As %String
{
	s struserid = ..UserId
	s LANCODE = "CH"
	S LAN = $P($G(^SSU("SSUSR",struserid)),"^",13)
	S:(LAN '="") LANCODE = $P($G(^SS("LAN",LAN)),"^",1)
	s resultSSLAN = ..#SSLANTYPE_$c(2)_LANCODE
	q resultSSLAN
}

}
