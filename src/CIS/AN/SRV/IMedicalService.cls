Class CIS.AN.SRV.IMedicalService Extends %RegisteredObject
{

/// 导入HIS基础数据
/// w ##class(CIS.AN.SRV.IMedicalService).ImportHisData()
ClassMethod ImportHisData() As %String
{
	set saveRet=..ImportSex()
	w "Import Sex Result: "_saveRet,!
	set saveRet=..ImportDiagnosis()
	w "Import Diagnosis Result: "_saveRet,!
	set saveRet=..ImportInstruction()
	w "Import Instruction Result: "_saveRet,!
	set saveRet=..ImportOperClass()
	w "Import OperClass Result: "_saveRet,!
	set saveRet=..ImportBladeType()
	w "Import BladeType Result: "_saveRet,!
	set saveRet=..ImportBodySite()
	w "Import BodySite Result: "_saveRet,!
	set saveRet=..ImportOperPosition()
	w "Import OperPosition Result: "_saveRet,!
	set saveRet=..ImportOperation()
	w "Import Operation Result: "_saveRet,!
	set saveRet=..ImportAnaestType()
	w "Import AnaestType Result: "_saveRet,!
	set saveRet=..ImportAnaestMethod()
	w "Import AnaestMethod Result: "_saveRet,!
	set saveRet=..ImportASAClass()
	w "Import ASAClass Result: "_saveRet,!
	set saveRet=..ImportHospital()
	w "Import Hopspital Result: "_saveRet,!
	set saveRet=..ImportDepartment()
	w "Import Department Result: "_saveRet,!
	set saveRet=..ImportWard()
	w "Import Ward Result: "_saveRet,!
	set saveRet=..ImportBed()
	w "Import Bed Result: "_saveRet,!
	set saveRet=..ImportGroup()
	w "Import Group Result: "_saveRet,!
	set saveRet=..ImportCareProvType()
	w "Import CareProvType Result: "_saveRet,!
	set saveRet=..ImportCareProv()
	w "Import CareProv Result: "_saveRet,!
	set saveRet=..ImportUser()
	w "Import User Result: "_saveRet,!	
	set saveRet=..ImportUserCertInfo()
	w "Import UserCertInfo Result: "_saveRet,!
	set saveRet=..ImportUserLogonDept()
	w "Import UserLogonDept Result: "_saveRet,!
	set saveRet=..ImportResource()
	w "Import Resource Result: "_saveRet,!
	set saveRet=..ImportDeptLinkDept()
	w "Import DeptLinkDept Result: "_saveRet,!	
	set saveRet=..ImportDeptList()
	w "Import DeptList Result: "_saveRet,!
	set saveRet=..ImportDeptListDept()
	w "Import DeptListDept Result: "_saveRet,!
	set saveRet=..SendOperRoom("N")
	w "Send OperRoom Result: "_saveRet,!
}

/// 导入HIS数据
/// 请谨慎使用！！！initHisData="Y"和initRelatedData="Y"会清除HIS导入的数据和相关联数据。
/// 一般适合首次导入数据使用
/// w ##class(CIS.AN.SRV.IMedicalService).ImportHISDataNew()
ClassMethod ImportHISDataNew(initHisData As %String = "Y", initRelatedData As %String = "Y") As %String
{
	// 导入前清除原有数据
	if (initHisData="Y")
	{
		do ##class(CIS.AN.SRV.InitialService).InitHISData()	
	}	
	// 导入前清除与HIS相关联的数据
	if (initRelatedData="Y")
	{
		do ##class(CIS.AN.SRV.InitialService).InitHISLinkedData()	
	}
	
	do ..ImportHisData()
}

/// 导入性别
/// w ##class(CIS.AN.SRV.IMedicalService).ImportSex()	
ClassMethod ImportSex() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare SexCursor cursor for select %ID,CTSEX_Code,CTSEX_Desc,CTSEX_DateFrom,CTSEX_DateTo,CTSEX_Gender
		into :RowId,:Code,:Description,:ActiveDate,:ExpireDate,:Gender from SQLUser.CT_Sex)
	&sql(open SexCursor)
	for
	{
		&sql(fetch SexCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.Sex where ExternalID=:RowId)
		if (##class(CT.AN.Sex).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.Sex).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.Sex).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set:(+ActiveDate>0) operObj.ActiveDate=ActiveDate
		set:(+ExpireDate>0) operObj.ExpireDate=ExpireDate
		set operObj.Gender=Gender
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close SexCursor)
		quit saveResult	
	}
	tcommit
	&sql(close SexCursor)
	quit saveResult
Error
	trollback
	&sql(close SexCursor)
	quit "E^"_$ze
}

/// 导入用药途径
/// w ##class(CIS.AN.SRV.IMedicalService).ImportInstruction()
ClassMethod ImportInstruction() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare InstructionCursor cursor for select %ID,PHCIN_Code,PHCIN_Desc1,PHCIN_Desc2,PHCIN_ActiveFlag 
		into :RowId,:Code,:Description,:Alias,:Active from SQLUser.PHC_Instruc)
	&sql(open InstructionCursor)
	for
	{
		&sql(fetch InstructionCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.Instruction where ExternalID=:RowId)
		if (##class(CT.AN.Instruction).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.Instruction).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.Instruction).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.Abbreviation=Alias
		set:(Active'="") operObj.Active=Active
		
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close InstructionCursor)
		quit saveResult	
	}
	tcommit
	&sql(close InstructionCursor)
	quit saveResult
Error
	trollback
	&sql(close InstructionCursor)
	quit "E^"_$ze
}

/// 导入诊断字典
/// w ##class(CIS.AN.SRV.IMedicalService).ImportDiagnosis()
ClassMethod ImportDiagnosis() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare DiagnosisCursor cursor for select %ID,MRCID_Code,MRCID_Desc,MRCID_ShortDesc,MRCID_ICD9CM_Code,
		 MRCID_DateActiveFrom,MRCID_DateActiveTo,MRCID_AgeFrom,MRCID_AgeTo,MRCID_Sex_DR,MRCID_Valid
		 into :RowId,:Code,:Description,:ShortDesc,:ICD9CMCode,:ActiveDate,:ExpireDate,:AgeFrom,:AgeTo,:Gender,:Active from SQLUser.MRC_ICDDx)
	&sql(open DiagnosisCursor)
	for
	{
		&sql(fetch DiagnosisCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.Diagnosis where ExternalID=:RowId)
		if (##class(CT.AN.Diagnosis).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.Diagnosis).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.Diagnosis).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.Active=Active
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set operObj.ICD9CMCode=ICD9CMCode
		set operObj.ShortDesc=ShortDesc
		set operObj.AgeFrom=AgeFrom
		set operObj.AgeTo=AgeTo
		set operObj.Gender=Gender
		set operObj.Alias=..GetDiagnosisAlias(RowId)
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close DiagnosisCursor)
		quit saveResult	
	}
	tcommit
	&sql(close DiagnosisCursor)
	quit saveResult
Error
	trollback
	&sql(close DiagnosisCursor)
	quit "E^"_$ze
}

ClassMethod GetDiagnosisAlias(diagnosisId As %String) As %String
{
	set aliasStr="",splitChar=";"
	&sql(declare DiagnosisAliasCursor cursor for select ALIAS_Text
		into :Alias from SQLUser.MRC_ICDAlias where ALIAS_ParRef=:diagnosisId)
	&sql(open DiagnosisAliasCursor)	
	for
	{
		&sql(fetch DiagnosisAliasCursor)
		quit:(SQLCODE'=0)
		set:(aliasStr'="")&(Alias'="") aliasStr=aliasStr_splitChar
		set aliasStr=aliasStr_Alias
	}
	&sql(close DiagnosisAliasCursor)
	quit aliasStr
}

/// 导入手术分级
/// w ##class(CIS.AN.SRV.IMedicalService).ImportOperClass()
ClassMethod ImportOperClass() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare OCCursor cursor for select %ID,CATEG_Code,CATEG_Desc,CATEG_DateFrom,CATEG_DateTo 
		into :RowId,:Code,:Description,:ActiveDate,:ExpireDate from SQLUser.ORC_OperationCategory)
	&sql(open OCCursor)
	for
	{
		&sql(fetch OCCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.OperClass where ExternalID=:RowId)
		if (##class(CT.AN.OperClass).%ExistsId(newRowId))
		{
			set operClass=##class(CT.AN.OperClass).%OpenId(newRowId)	
		}	
		else
		{
			set operClass=##class(CT.AN.OperClass).%New()	
		}
		set operClass.Code=Code
		set operClass.Description=Description
		set operClass.ExternalID=RowId
		set:(+ActiveDate>0) operClass.ActiveDate=ActiveDate
		set:(+ExpireDate>0) operClass.ExpireDate=ExpireDate
		//set operClass.Active="Y"
		
		set sc=operClass.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close OCCursor)
		quit saveResult	
	}
	tcommit
	&sql(close OCCursor)
	quit saveResult
Error
	trollback
	&sql(close OCCursor)
	quit "E^"_$ze
}

/// 导入切口类型
/// w ##class(CIS.AN.SRV.IMedicalService).ImportBladeType()
ClassMethod ImportBladeType() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare OperCursor cursor for select %ID,BLDTP_Code,BLDTP_Desc
		into :RowId,:Code,:Description from SQLUser.ORC_BladeType)
	&sql(open OperCursor)
	for
	{
		&sql(fetch OperCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.BladeType where ExternalID=:RowId)
		if (##class(CT.AN.BladeType).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.BladeType).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.BladeType).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		//set operObj.Active="Y"
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close OperCursor)
		quit saveResult	
	}
	tcommit
	&sql(close OperCursor)
	quit saveResult
Error
	trollback
	&sql(close OperCursor)
	quit "E^"_$ze
}

/// 导入手术部位
/// w ##class(CIS.AN.SRV.IMedicalService).ImportBodySite()
ClassMethod ImportBodySite() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare BodySiteCursor cursor for select %ID,BODS_Code,BODS_Desc
		into :RowId,:Code,:Description from SQLUser.OEC_BodySite)
	&sql(open BodySiteCursor)
	for
	{
		&sql(fetch BodySiteCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.BodySite where ExternalID=:RowId)
		if (##class(CT.AN.BodySite).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.BodySite).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.BodySite).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		//set operObj.Active="Y"
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close BodySiteCursor)
		quit saveResult	
	}
	tcommit
	&sql(close BodySiteCursor)
	quit saveResult
Error
	trollback
	&sql(close BodySiteCursor)
	quit "E^"_$ze
}

/// 导入手术体位
/// w ##class(CIS.AN.SRV.IMedicalService).ImportOperPosition()
ClassMethod ImportOperPosition() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare OperPosCursor cursor for select %ID,OPPOS_Code,OPPOS_Desc
		into :RowId,:Code,:Description from SQLUser.ORC_OperPosition)
	&sql(open OperPosCursor)
	for
	{
		&sql(fetch OperPosCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.OperPosition where ExternalID=:RowId)
		if (##class(CT.AN.OperPosition).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.OperPosition).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.OperPosition).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		//set operObj.Active="Y"
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close OperPosCursor)
		quit saveResult	
	}
	tcommit
	&sql(close OperPosCursor)
	quit saveResult
Error
	trollback
	&sql(close OperPosCursor)
	quit "E^"_$ze
}

/// 导入手术名称
/// w ##class(CIS.AN.SRV.IMedicalService).ImportOperation()
ClassMethod ImportOperation() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare OperationCursor cursor for select %ID,OPER_Code,OPER_Desc,OPER_DateActiveFrom,OPER_ActiveDateTo,
		 OPER_DefaultCategory_DR,OPER_DaySurgery,OPER_AgeFrom,OPER_AgeTo,OPER_Sex_DR,OPER_ICD10,OPER_ICD9Map,OPER_Valid
		 into :RowId,:Code,:Description,:ActiveDate,:ExpireDate,:OperClass,:DaySurgery,:AgeFrom,:AgeTo,:Gender,:ICD10,:ICD9,:Active from SQLUser.ORC_Operation)
	&sql(open OperationCursor)
	for
	{
		&sql(fetch OperationCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.Operation where ExternalID=:RowId)
		if (##class(CT.AN.Operation).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.Operation).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.Operation).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.Active=Active
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set operObj.ICD10=ICD10
		set operObj.ICD9=ICD9
		set operObj.OperType=""
		set operObj.AgeFrom=AgeFrom
		set operObj.AgeTo=AgeTo
		set operObj.Gender=Gender
		set operObj.DaySurgery=DaySurgery
		set operObj.Alias=..GetOperAlias(RowId)
		set operClassId=..GetRowIdByExt("CT_AN.OperClass",OperClass)
		set:(##class(CT.AN.OperClass).%ExistsId(operClassId)) operObj.OperClass=##class(CT.AN.OperClass).%OpenId(operClassId)
		
		set operExtend=##class(User.ORCOperationExtend).%OpenId(RowId)
		if (operExtend'="")
		{
			if (operExtend.OPERBodySiteDr'="")
			{
				set bodySiteId=..GetRowIdByExt("CT_AN.BodySite",operExtend.OPERBodySiteDr.%Id())
				set:(##class(CT.AN.BodySite).%ExistsId(bodySiteId)) operObj.BodySite=##class(CT.AN.BodySite).%OpenId(bodySiteId)
			}
			if (operExtend.OPERBladeDr'="")
			{
				set bladeTypeId=..GetRowIdByExt("CT_AN.BladeType",operExtend.OPERBladeDr.%Id())
				set:(##class(CT.AN.BladeType).%ExistsId(bladeTypeId)) operObj.BladeType=##class(CT.AN.BladeType).%OpenId(bladeTypeId)
			}
			if (operExtend.OPEROperPositionDr'="")
			{
				set operPosId=..GetRowIdByExt("CT_AN.OperPosition",operExtend.OPEROperPositionDr.%Id())
				set:(##class(CT.AN.OperPosition).%ExistsId(operPosId)) operObj.OperPosition=##class(CT.AN.OperPosition).%OpenId(operPosId)
			}	
			set operObj.OperType=operExtend.OPERType
		}
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close OperationCursor)
		quit saveResult	
	}
	tcommit
	&sql(close OperationCursor)
	quit saveResult
Error
	trollback
	&sql(close OperationCursor)
	quit "E^"_$ze
}

/// 获取手术名称别名
ClassMethod GetOperAlias(operId As %String) As %String
{
	set aliasStr="",splitChar=";"
	&sql(declare OperAliasCursor cursor for select ALIAS_Text
		into :Alias from SQLUser.ORC_OperationAlias where ALIAS_ParRef=:operId)
	&sql(open OperAliasCursor)	
	for
	{
		&sql(fetch OperAliasCursor)
		quit:(SQLCODE'=0)
		set:(aliasStr'="")&(Alias'="") aliasStr=aliasStr_splitChar
		set aliasStr=aliasStr_Alias
	}
	&sql(close OperAliasCursor)
	quit aliasStr
}

/// 导入麻醉类型
/// w ##class(CIS.AN.SRV.IMedicalService).ImportAnaestType()
ClassMethod ImportAnaestType() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare AnaestTypeCursor cursor for select %ID,ANTYPE_Code,ANTYPE_Desc,ANTYPE_DateFrom,ANTYPE_DateTo
		into :RowId,:Code,:Description,:ActiveDate,:ExpireDate from SQLUser.ORC_AnaestType)
	&sql(open AnaestTypeCursor)
	for
	{
		&sql(fetch AnaestTypeCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.AnaType where ExternalID=:RowId)
		if (##class(CT.AN.AnaType).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.AnaType).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.AnaType).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close AnaestTypeCursor)
		quit saveResult	
	}
	tcommit
	&sql(close AnaestTypeCursor)
	quit saveResult
Error
	trollback
	&sql(close AnaestTypeCursor)
	quit "E^"_$ze
}

/// 导入麻醉方法
/// w ##class(CIS.AN.SRV.IMedicalService).ImportAnaestMethod()
ClassMethod ImportAnaestMethod() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare AnaestMethodCursor cursor for select %ID,ANMET_Code,ANMET_Desc,ANMET_DateFrom,ANMET_DateTo,ANMET_Type_DR
		into :RowId,:Code,:Description,:ActiveDate,:ExpireDate,:AnaestType from SQLUser.ORC_AnaestMethod)
	&sql(open AnaestMethodCursor)
	for
	{
		&sql(fetch AnaestMethodCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.AnaMethod where ExternalID=:RowId)
		set operObj=""
		if (##class(CT.AN.AnaMethod).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.AnaMethod).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.AnaMethod).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set anaTypeId=..GetRowIdByExt("CT_AN.AnaType",AnaestType)
		set:(##class(CT.AN.AnaType).%ExistsId(anaTypeId)) operObj.AnaType=##class(CT.AN.AnaType).%OpenId(anaTypeId)
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close AnaestMethodCursor)
		quit saveResult	
	}
	tcommit
	&sql(close AnaestMethodCursor)
	quit saveResult
Error
	trollback
	&sql(close AnaestMethodCursor)
	quit "E^"_$ze
}

/// 导入ASA分级
/// w ##class(CIS.AN.SRV.IMedicalService).ImportASAClass()
ClassMethod ImportASAClass() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare ASAClassCursor cursor for select %ID,ORASA_Code,ORASA_Desc
		into :RowId,:Code,:Description from SQLUser.ORC_ASA_ClassPhActiv)
	&sql(open ASAClassCursor)
	for
	{
		&sql(fetch ASAClassCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.AnaType where ExternalID=:RowId)
		if (##class(CT.AN.ASAClass).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.ASAClass).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.ASAClass).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close ASAClassCursor)
		quit saveResult	
	}
	tcommit
	&sql(close ASAClassCursor)
	quit saveResult
Error
	trollback
	&sql(close ASAClassCursor)
	quit "E^"_$ze
}

ClassMethod GetRowIdByExt(tableName As %String, extId As %String) As %String [ SqlProc ]
{
	set result=""
	set sql="select %ID as result from "_tableName_" where ExternalID="_extId
	set tStatement=##class(%SQL.Statement).%New()
	set tStatus=tStatement.%Prepare(sql)
	set rs=tStatement.%Execute()
	while(rs.%Next())
	{
		set result=rs.result
	}
	
	quit result
}

/// 导入医院信息
/// w ##class(CIS.AN.SRV.IMedicalService).ImportHospital()
ClassMethod ImportHospital() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare HospitalCursor cursor for select %ID,HOSP_Code,HOSP_Desc,HOSP_DateFrom,HOSP_DateTo
		into :RowId,:Code,:Description,:ActiveDate,:ExpireDate from SQLUser.CT_Hospital)
	&sql(open HospitalCursor)
	for
	{
		&sql(fetch HospitalCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.Hospital where ExternalID=:RowId)
		if (##class(CF.AN.Hospital).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.Hospital).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.Hospital).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close HospitalCursor)
		quit saveResult	
	}
	tcommit
	&sql(close HospitalCursor)
	quit saveResult
Error
	trollback
	&sql(close HospitalCursor)
	quit "E^"_$ze
}

/// 导入科室
/// w ##class(CIS.AN.SRV.IMedicalService).ImportDepartment()
ClassMethod ImportDepartment() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare DeptCursor cursor for select %ID,CTLOC_Code,CTLOC_Desc,CTLOC_WardFlag,CTLOC_ActiveFlag,CTLOC_Type,CTLOC_Hospital_DR,CTLOC_DateActiveFrom,CTLOC_DateActiveTo,CTLOC_ContactName
		into :RowId,:Code,:Description,:WardFlag,:ActiveFlag,:DeptType,:Hospital,:ActiveDate,:ExpireDate,:Alias from SQLUser.CT_Loc)
	&sql(open DeptCursor)
	for
	{
		&sql(fetch DeptCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.Department where ExternalID=:RowId)
		if (##class(CF.AN.Department).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.Department).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.Department).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set operObj.WardFlag=WardFlag
		set operObj.DeptType=DeptType
		set operObj.Alias=Alias
		set hospitalId=..GetRowIdByExt("CF_AN.Hospital",Hospital)
		set:(##class(CF.AN.Hospital).%ExistsId(hospitalId)) operObj.Hospital=##class(CF.AN.Hospital).%OpenId(hospitalId)
		set operObj.ActiveFlag="Y"
		set operObj.AdmType=##class(CIS.AN.BL.Admission).GetDeptAdmType(RowId)
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close DeptCursor)
		quit saveResult	
	}
	tcommit
	&sql(close DeptCursor)
	quit saveResult
Error
	trollback
	&sql(close DeptCursor)
	quit "E^"_$ze
}

/// 导入病区数据
/// w ##class(CIS.AN.SRV.IMedicalService).ImportWard()
ClassMethod ImportWard() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare WardCursor cursor for select %ID,WARD_Code,WARD_Desc,WARD_LocationDR,WARD_Active
		into :RowId,:Code,:Description,:Department,:Active from SQLUser.PAC_Ward)
	&sql(open WardCursor)
	for
	{
		&sql(fetch WardCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.Ward where ExternalID=:RowId)
		if (##class(CF.AN.Ward).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.Ward).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.Ward).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set operObj.Active=Active
		set deptId=..GetRowIdByExt("CF_AN.Department",Department)
		set:(##class(CF.AN.Department).%ExistsId(deptId)) operObj.Department=##class(CF.AN.Department).%OpenId(deptId)
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close WardCursor)
		quit saveResult	
	}
	tcommit
	&sql(close WardCursor)
	quit saveResult
Error
	trollback
	&sql(close WardCursor)
	quit "E^"_$ze
}

/// 导入床位
/// w ##class(CIS.AN.SRV.IMedicalService).ImportBed()
ClassMethod ImportBed() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare BedCursor cursor for select %ID,BED_Code,BED_WARD_ParRef,BED_DateFrom,BED_DateTo,BED_Available
		into :RowId,:Code,:Ward,:ActiveDate,:ExpireDate,:Active from SQLUser.PAC_Bed)
	&sql(open BedCursor)
	for
	{
		&sql(fetch BedCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.Bed where ExternalID=:RowId)
		if (##class(CF.AN.Bed).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.Bed).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.Bed).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Code
		set operObj.ExternalID=RowId
		set operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set wardId=..GetRowIdByExt("CF_AN.Bed",Ward)
		set:(##class(CF.AN.Ward).%ExistsId(wardId)) operObj.Ward=##class(CF.AN.Ward).%OpenId(wardId)
		set operObj.Active=Active
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close BedCursor)
		quit saveResult	
	}
	tcommit
	&sql(close BedCursor)
	quit saveResult
Error
	trollback
	&sql(close BedCursor)
	quit "E^"_$ze
}

/// 导入安全组
/// w ##class(CIS.AN.SRV.IMedicalService).ImportGroup()
ClassMethod ImportGroup() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare GroupCursor cursor for select %ID,SSGRP_Desc,SSGRP_Desc
		into :RowId,:Code,:Description from SQLUser.SS_Group)
	&sql(open GroupCursor)
	for
	{
		&sql(fetch GroupCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.SSGroup where ExternalID=:RowId)
		if (##class(CF.AN.SSGroup).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.SSGroup).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.SSGroup).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close GroupCursor)
		quit saveResult	
	}
	tcommit
	&sql(close GroupCursor)
	quit saveResult
Error
	trollback
	&sql(close GroupCursor)
	quit "E^"_$ze
}

/// 导入用户CA签名信息
/// w ##class(CIS.AN.SRV.IMedicalService).ImportUserCertInfo()
ClassMethod ImportUserCertInfo() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	set userId=0
	for
	{
		set userId=$o(^CF.AN.SSUserD(userId))
		quit:(userId="")
		set SSUser=##class(CF.AN.SSUser).%OpenId(userId)
		continue:(SSUser.ExternalID="")
		set CASignInfo=##class(CA.UsrSignatureInfo).GetInUseInfo(SSUser.ExternalID)
		continue:('$isobject(CASignInfo))
		set SSUser.UserCert=CASignInfo.UsrCertCode
		set SSUser.SignImage=CASignInfo.SignImage
		set SSUser.CertNo=CASignInfo.CertificateNo
		set SSUser.Certificate=CASignInfo.Certificate
		set SSUser.CertSN=CASignInfo.CertificateSN
		set SSUser.UKeyNo=CASignInfo.UKeyNo
		set SSUser.IdentityID=CASignInfo.IdentityID
		set sc=SSUser.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))	
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// 导入用户
/// w ##class(CIS.AN.SRV.IMedicalService).ImportUser()
ClassMethod ImportUser() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare UserCursor cursor for 
		select %ID,SSUSR_Initials,SSUSR_Name,SSUSR_Password,SSUSR_DefaultDept_DR,SSUSR_IsThisDoctor,
			   SSUSR_CareProv_DR,SSUSR_Group,SSUSR_ChangeLocation,SSUSR_Pin,SSUSR_Active,SSUSR_DateFrom,SSUSR_DateTo,
			   SSUSR_Hospital_DR,SSUSR_UseDeptAsDefault
			   into :RowId,:Initials,:FullName,:Password,:Dept,:DocFlag,:CareProvider,:SSGroup,:ChangeDept,:Pin,:Active,
			   :ActiveDate,:ExpireDate,:Hospital,:UseDeptAsDefault
			   from SQLUser.SS_User)
	&sql(open UserCursor)
	for
	{
		&sql(fetch UserCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.SSUser where ExternalID=:RowId)
		if (##class(CF.AN.SSUser).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.SSUser).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.SSUser).%New()	
		}
		set operObj.Initials=Initials
		set operObj.ExternalID=RowId
		set:(+ActiveDate>0) operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set operObj.FullName=FullName
		set operObj.DocFlag=DocFlag
		set operObj.Pin=Pin
		set operObj.UseDeptAsDefault=UseDeptAsDefault
		set operObj.Password=Password
		
		set hospitalId=..GetRowIdByExt("CF_AN.Hospital",Hospital)
		set:(##class(CF.AN.Hospital).%ExistsId(hospitalId)) operObj.Hospital=##class(CF.AN.Hospital).%OpenId(hospitalId)
		
		set groupId=..GetRowIdByExt("CF_AN.SSGroup",SSGroup)
		set:(##class(CF.AN.SSGroup).%ExistsId(groupId)) operObj.SSGroup=##class(CF.AN.SSGroup).%OpenId(groupId)
		
		set careProvId=..GetRowIdByExt("CF_AN.CareProvider",CareProvider)
		set:(##class(CF.AN.CareProvider).%ExistsId(careProvId)) operObj.CareProvider=##class(CF.AN.CareProvider).%OpenId(careProvId)
		
		set deptId=..GetRowIdByExt("CF_AN.Department",Dept)
		set:(##class(CF.AN.Department).%ExistsId(deptId)) operObj.Dept=##class(CF.AN.Department).%OpenId(deptId)
		
		set operObj.Active=Active
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close UserCursor)
		quit saveResult	
	}
	tcommit
	&sql(close UserCursor)
	quit saveResult
Error
	trollback
	&sql(close UserCursor)
	quit "E^"_$ze
}

/// 导入医护人员
/// w ##class(CIS.AN.SRV.IMedicalService).ImportCareProv()
ClassMethod ImportCareProv() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare CareProvCursor cursor for select %ID,CTPCP_Code,CTPCP_Desc,CTPCP_CarPrvTp_DR,CTPCP_DateActiveFrom,CTPCP_DateActiveTo,CTPCP_Surgeon,CTPCP_Anaesthetist,CTPCP_OtherName,CTPCP_ActiveFlag
		into :RowId,:Code,:Description,:CareProvType,:ActiveDate,:ExpireDate,:Surgeon,:Anaesthetist,:Alias,:Active from SQLUser.CT_CareProv)
	&sql(open CareProvCursor)
	for
	{
		&sql(fetch CareProvCursor)
		quit:(SQLCODE'=0)
		continue:(Code="")!(Description="")
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.CareProvider where ExternalID=:RowId)
		if (##class(CF.AN.CareProvider).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.CareProvider).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.CareProvider).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.FullName=Description
		set operObj.ExternalID=RowId
		set:(+ActiveDate>0) operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set operObj.Surgeon=Surgeon
		set operObj.Anaesthetist=Anaesthetist
		set operObj.Alias=Alias
		set careProvTypeId=..GetRowIdByExt("CF_AN.CareProvType",CareProvType)
		set:(##class(CF.AN.CareProvType).%ExistsId(careProvTypeId)) operObj.CareProvType=##class(CF.AN.CareProvType).%OpenId(careProvTypeId)
		set operObj.Active=Active
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close CareProvCursor)
		quit saveResult	
	}
	tcommit
	&sql(close CareProvCursor)
	quit saveResult
Error
	trollback
	&sql(close CareProvCursor)
	quit "E^"_$ze
}

/// w ##class(CIS.AN.SRV.IMedicalService).ImportCareProvType()
ClassMethod ImportCareProvType() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare CareProvTypeCursor cursor for select %ID,CTCPT_Code,CTCPT_Desc,CTCPT_ActiveFlag,CTCPT_InternalType,CTCPT_DateFrom,CTCPT_DateTo
		into :RowId,:Code,:Description,:Active,:InternalType,:ActiveDate,:ExpireDate from SQLUser.CT_CarPrvTp)
	&sql(open CareProvTypeCursor)
	for
	{
		&sql(fetch CareProvTypeCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.CareProvType where ExternalID=:RowId)
		if (##class(CF.AN.CareProvType).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.CareProvType).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.CareProvType).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set:(+ActiveDate>0) operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		set operObj.InternalType=InternalType
		set operObj.Active=Active
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close CareProvTypeCursor)
		quit saveResult	
	}
	tcommit
	&sql(close CareProvTypeCursor)
	quit saveResult
Error
	trollback
	&sql(close CareProvTypeCursor)
	quit "E^"_$ze
}

/// w ##class(CIS.AN.SRV.IMedicalService).ImportUserLogonDept()
ClassMethod ImportUserLogonDept() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare UserLogonDeptCursor cursor for select %ID,OTHLL_ParRef,OTHLL_CTLOC_DR,OTHLL_UserGroup_DR,OTHLL_Hospital_DR,OTHLL_StartDate,OTHLL_EndDate
		into :RowId,:SSUser,:Dept,:SSGroup,:Hospital,:ActiveDate,:ExpireDate from SQLUser.SS_UserOtherLogonLoc)
	&sql(open UserLogonDeptCursor)
	for
	{
		&sql(fetch UserLogonDeptCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.UserLogonDept where ExternalID=:RowId)
		if (##class(CF.AN.UserLogonDept).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.UserLogonDept).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.UserLogonDept).%New()	
		}
		//set operObj.Code=Code
		//set operObj.Description=Description
		set operObj.ExternalID=RowId
		set:(+ActiveDate>0) operObj.ActiveDate=ActiveDate
		set operObj.ExpireDate=ExpireDate
		
		set userId=..GetRowIdByExt("CF_AN.SSUser",SSUser)
		set:(##class(CF.AN.SSUser).%ExistsId(userId)) operObj.SSUser=##class(CF.AN.SSUser).%OpenId(userId)
		
		set groupId=..GetRowIdByExt("CF_AN.SSGroup",SSGroup)
		set:(##class(CF.AN.SSGroup).%ExistsId(groupId)) operObj.SSGroup=##class(CF.AN.SSGroup).%OpenId(groupId)
		
		set deptId=..GetRowIdByExt("CF_AN.Department",Dept)
		set:(##class(CF.AN.Department).%ExistsId(deptId)) operObj.Dept=##class(CF.AN.Department).%OpenId(deptId)
		
		set hospitalId=..GetRowIdByExt("CF_AN.Hospital",Hospital)
		set:(##class(CF.AN.Hospital).%ExistsId(hospitalId)) operObj.SSUser=##class(CF.AN.Hospital).%OpenId(hospitalId)
		
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close UserLogonDeptCursor)
		quit saveResult	
	}
	tcommit
	&sql(close UserLogonDeptCursor)
	quit saveResult
Error
	trollback
	&sql(close UserLogonDeptCursor)
	quit "E^"_$ze
}

/// 导入科室医护人员
/// w ##class(CIS.AN.SRV.IMedicalService).ImportResource()
ClassMethod ImportResource() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare ResourceCursor cursor for select %ID,RES_Code,RES_Desc,RES_CTLOC_DR,RES_CTPCP_DR,RES_DateActiveFrom,RES_DateActiveTo,RES_Active
		into :RowId,:Code,:Description,:Dept,:CareProvider,:ActiveDate,:ExpireDate,:Active from SQLUser.RB_Resource)
	&sql(open ResourceCursor)
	for
	{
		&sql(fetch ResourceCursor)
		quit:(SQLCODE'=0)
		continue:(Dept="")!(CareProvider="")
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.Resource where ExternalID=:RowId)
		if (##class(CF.AN.Resource).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.Resource).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.Resource).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set:(+ActiveDate>0) operObj.ActiveDate=ActiveDate
		set:(+ExpireDate>0) operObj.ExpireDate=ExpireDate
		
		set deptId=..GetRowIdByExt("CF_AN.Department",Dept)
		set:(##class(CF.AN.Department).%ExistsId(deptId)) operObj.Dept=##class(CF.AN.Department).%OpenId(deptId)
		
		set careId=..GetRowIdByExt("CF_AN.CareProvider",CareProvider)
		set:(##class(CF.AN.CareProvider).%ExistsId(careId)) operObj.CareProvider=##class(CF.AN.CareProvider).%OpenId(careId)
		
		set:(Active'="") operObj.Active=Active
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close ResourceCursor)
		quit saveResult	
	}
	tcommit
	&sql(close ResourceCursor)
	quit saveResult
Error
	trollback
	&sql(close ResourceCursor)
	quit "E^"_$ze
}

/// 导入关联科室
/// w ##class(CIS.AN.SRV.IMedicalService).ImportDeptLinkDept()
ClassMethod ImportDeptLinkDept() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare DeptLinkCursor cursor for select %ID,LINK_ParRef,LINK_CTLOC_DR
		into :RowId,:SourceDept,:TargetDept from SQLUser.CT_LocLinkLocation)
	&sql(open DeptLinkCursor)
	for
	{
		&sql(fetch DeptLinkCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.DeptLinkDept where ExternalID=:RowId)
		if (##class(CF.AN.DeptLinkDept).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.DeptLinkDept).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.DeptLinkDept).%New()	
		}

		set operObj.ExternalID=RowId
		
		set sourceDeptId=..GetRowIdByExt("CF_AN.Department",SourceDept)
		set:(##class(CF.AN.Department).%ExistsId(sourceDeptId)) operObj.SourceDept=##class(CF.AN.Department).%OpenId(sourceDeptId)
		
		set targetDeptId=..GetRowIdByExt("CF_AN.Department",TargetDept)
		set:(##class(CF.AN.Department).%ExistsId(targetDeptId)) operObj.TargetDept=##class(CF.AN.Department).%OpenId(targetDeptId)
		
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close DeptLinkCursor)
		quit saveResult	
	}
	tcommit
	&sql(close DeptLinkCursor)
	quit saveResult
Error
	trollback
	&sql(close DeptLinkCursor)
	quit "E^"_$ze
}

/// 导入科室列表
/// w ##class(CIS.AN.SRV.IMedicalService).ImportDeptList()
ClassMethod ImportDeptList() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare DeptListCursor cursor for select %ID,LL_Code,LL_Desc
		into :RowId,:Code,:Description from SQLUser.CT_LocationList)
	&sql(open DeptListCursor)
	for
	{
		&sql(fetch DeptListCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CT_AN.DeptList where ExternalID=:RowId)
		if (##class(CT.AN.DeptList).%ExistsId(newRowId))
		{
			set operObj=##class(CT.AN.DeptList).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CT.AN.DeptList).%New()	
		}
		set operObj.Code=Code
		set operObj.Description=Description
		set operObj.ExternalID=RowId
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close DeptListCursor)
		quit saveResult	
	}
	tcommit
	&sql(close DeptListCursor)
	quit saveResult
Error
	trollback
	&sql(close DeptListCursor)
	quit "E^"_$ze
}

/// 导入关联科室
/// w ##class(CIS.AN.SRV.IMedicalService).ImportDeptListDept()
ClassMethod ImportDeptListDept() As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	&sql(declare DeptListDeptCursor cursor for select %ID,LOC_ParRef,LOC_CTLOC_DR
		into :RowId,:DeptList,:Dept from SQLUser.CT_LocationList_Locations)
	&sql(open DeptListDeptCursor)
	for
	{
		&sql(fetch DeptListDeptCursor)
		quit:(SQLCODE'=0)
		set newRowId=""
		&sql(select %ID into :newRowId from CF_AN.DeptListDept where ExternalID=:RowId)
		if (##class(CF.AN.DeptListDept).%ExistsId(newRowId))
		{
			set operObj=##class(CF.AN.DeptListDept).%OpenId(newRowId)	
		}	
		else
		{
			set operObj=##class(CF.AN.DeptListDept).%New()	
		}

		set operObj.ExternalID=RowId
		
		set deptListId=..GetRowIdByExt("CT_AN.DeptList",DeptList)
		set:(##class(CT.AN.DeptList).%ExistsId(deptListId)) operObj.DeptList=##class(CT.AN.DeptList).%OpenId(deptListId)
		
		set deptId=..GetRowIdByExt("CF_AN.Department",Dept)
		set:(##class(CF.AN.Department).%ExistsId(deptId)) operObj.Dept=##class(CF.AN.Department).%OpenId(deptId)
		
		set sc=operObj.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		&sql(close DeptListDeptCursor)
		quit saveResult	
	}
	tcommit
	&sql(close DeptListDeptCursor)
	quit saveResult
Error
	trollback
	&sql(close DeptListDeptCursor)
	quit "E^"_$ze
}

ClassMethod ImportOperRoom() As %String
{
	set $zt="Error"
	tstart
	&sql(declare OperRoomCursor cursor for select %ID,OPR_Code,OPR_Ctloc_Dr,OPR_Desc,OPR_BedType,OPR_Available 
		 into :RowId,:Code,:OperDeptID,:Description,:LocType,:Active
		 from SQLUser.DHC_ANC_OperRoom where OPR_Available<>'N')
	
	set saveRet="S^"
	&sql(open OperRoomCursor)
	for
	{
		&sql(fetch OperRoomCursor)
		quit:(SQLCODE'=0)
		continue:(Code="")!(Description="")!(OperDeptID="")
		set operRoom=""
		set locId=##class(CIS.AN.SRV.IMedicalService).GetRowIdByExt("CF_AN.Location",RowId)
		if (##class(CF.AN.Location).%ExistsId(locId))
		{
			set operRoom=##class(CF.AN.Location).%OpenId(locId)	
		}	
		else
		{
			set operRoom=##class(CF.AN.Location).%New()	
		}
		set operRoom.Code=Code
		set curOperDeptID=##class(CIS.AN.SRV.IMedicalService).GetRowIdByExt("CF_AN.Department",OperDeptID)
		set operRoom.OperDeptID=##class(CF.AN.Department).%OpenId(curOperDeptID)
		set operRoom.Description=Description
		set:(LocType'="") bedType=$case(LocType,"T":"R","P":"P","I":"O",:"O")
		set operRoom.LocType=bedType
		set operRoom.Active="Y"
		set operRoom.ExternalID=RowId
		
		set sc=operRoom.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		//w "RowId: "_RowId_", BedType: "_bedType_", OperDept: "_OperDeptID,!
	}
	&sql(close OperRoomCursor)
	if ($p(saveRet,"^",1)="E")
	{
		trollback
		quit saveRet
	}
	tcommit
	quit saveRet
Error
	trollback
	&sql(close OperRoomCursor)
	quit "E^"_$ze
}

/// w ##class(CIS.AN.SRV.OperAppService).SendOperRoom("N")
ClassMethod SendOperRoom(clearData As %String = "N") As %String
{
	set $zt="Error"
	tstart
	&sql(declare RoomCursor cursor for select RowId,Code,Description,OperDeptID,ExternalID,LocType 
		 into :RowId,:Code,:Description,:OperDeptID,:ExternalID,:LocType
		 from CF_AN.Location where Active<>'N')
	if (clearData="Y")
	{
		&sql(delete from SQLUser.DHC_ANC_OperRoom)
		if (SQLCODE'=0)&(SQLCODE'=100)
		{
			trollback
			quit "E^"_$System.SQL.SQLCODE(SQLCODE)	
		}	
	}
	set saveRet="S^"
	&sql(open RoomCursor)
	for
	{
		&sql(fetch RoomCursor)
		quit:(SQLCODE'=0)
		set operRoom=""
		if (##class(User.DHCANCOperRoom).%ExistsId(ExternalID))
		{
			set operRoom=##class(User.DHCANCOperRoom).%OpenId(ExternalID)	
		}	
		else
		{
			set operRoom=##class(User.DHCANCOperRoom).%New()	
		}
		set operRoom.OPRCode=Code
		set operRoom.OPRCtlocDr=OperDeptID
		set operRoom.OPRDesc=Description
		set:(LocType'="") bedType=$case(LocType,"R":"T","P":"P","O":"I",:"I")
		set operRoom.OPRBedType=bedType
		set operRoom.OPRAvailable="Y"
		set sc=operRoom.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		set newOperRoom=##class(CF.AN.Location).%OpenId(RowId)
		set newOperRoom.ExternalID=operRoom.%Id()
		set sc=newOperRoom.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		//w "RowId: "_RowId_", BedType: "_bedType_", OperDept: "_OperDeptID,!
	}
	&sql(close RoomCursor)
	if ($p(saveRet,"^",1)="E")
	{
		trollback
		quit saveRet
	}
	tcommit
	quit saveRet
Error
	trollback
	&sql(close RoomCursor)
	quit "E^"_$ze
}

}
