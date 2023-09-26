/// 名称: DHCMed.CR.BO.FormQry
/// 描述: 表单报告查询
/// 编写者：maxp
/// 编写日期: 2013-01-10
Class DHCMed.CR.BO.FormQry Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CR.BO.FormQry).BuildCRReportHeader(1)
ClassMethod BuildCRReportHeader(formId As %String) As %String
{
	New (formId)
	Set return=""
	
	Set $ZT="BuildCRReportHeaderErr"
	
	Set gridColumn=""
	Set gridColumn=gridColumn_"var gridColumn=["
	Set gridColumn=gridColumn_"	{header: '报告日期',width: 80,align: 'center',sortable: false,dataIndex: 'CreateDate'}"
	Set gridColumn=gridColumn_"	,{header: '报告人',width: 80,align: 'center',sortable: false,dataIndex: 'CreateUserName'}"
	Set gridColumn=gridColumn_"	,{header: '报告科室',width: 80,align: 'center',sortable: false,dataIndex: 'CreateCTLocDesc'}"
	Set gridColumn=gridColumn_"	,{header: '报告状态',width: 80,align: 'center',sortable: false,dataIndex: 'CurrentStatus'}"
	Set gridColumn=gridColumn_"	,{header: '链接',width: 80,align: 'center',sortable: false,dataIndex: 'RepLink'}"
	;Set gridColumn=gridColumn_"];"
	
	Set storeFields=""
	Set storeFields=storeFields_"var storeFields=["
	Set storeFields=storeFields_"	{name: 'DataId', mapping: 'DataId'}"
	Set storeFields=storeFields_"	,{name: 'CurrentStatus', mapping: 'CurrentStatus'}"
	Set storeFields=storeFields_"	,{name: 'CreateCTLocDesc', mapping: 'CreateCTLocDesc'}"
	Set storeFields=storeFields_"	,{name: 'CreateUserName', mapping: 'CreateUserName'}"
	Set storeFields=storeFields_"	,{name: 'CreateDate', mapping: 'CreateDate'}"
	Set storeFields=storeFields_"	,{name: 'RepLink', mapping: 'RepLink'}"
	Set storeFields=storeFields_"	,{name: 'PatientID', mapping: 'PatientID'}"
	Set storeFields=storeFields_"	,{name: 'EpisodeID', mapping: 'EpisodeID'}"
	Set storeFields=storeFields_"	,{name: 'FormVerDR', mapping: 'FormVerDR'}"
	Set storeFields=storeFields_"	,{name: 'FormName', mapping: 'FormName'}"
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+formId) return
	set obj=##Class(DHCMed.CR.PO.Form).%OpenId(+formId)
    s business=obj.Business
    if business="01"{
	    Set gridColumn=gridColumn_"	,{header: '登记号',width: 80,align: 'center',sortable: false,dataIndex: 'patientNo'}"
	    Set gridColumn=gridColumn_"	,{header: '姓名',width: 80,align: 'center',sortable: false,dataIndex: 'patientName'}"
	    Set gridColumn=gridColumn_"	,{header: '性别',width: 80,align: 'center',sortable: false,dataIndex: 'patientSex'}"
	    Set gridColumn=gridColumn_"	,{header: '年龄',width: 80,align: 'center',sortable: false,dataIndex: 'patientAge'}"
	    Set storeFields=storeFields_"	,{name: 'patientNo', mapping: 'patientNo'}"
	    Set storeFields=storeFields_"	,{name: 'patientName', mapping: 'patientName'}"
	    Set storeFields=storeFields_"	,{name: 'patientSex', mapping: 'patientSex'}"
    	Set storeFields=storeFields_"	,{name: 'patientAge', mapping: 'patientAge'}"
    } 
    elseif business="02"
    {
	    Set gridColumn=gridColumn_"	,{header: '登记号',width: 80,align: 'center',sortable: false,dataIndex: 'patientNo'}"
	    Set gridColumn=gridColumn_"	,{header: '姓名',width: 80,align: 'center',sortable: false,dataIndex: 'patientName'}"
	    Set gridColumn=gridColumn_"	,{header: '性别',width: 80,align: 'center',sortable: false,dataIndex: 'patientSex'}"
	    Set gridColumn=gridColumn_"	,{header: '年龄',width: 80,align: 'center',sortable: false,dataIndex: 'patientAge'}"
		Set gridColumn=gridColumn_"	,{header: '就诊日期',width: 80,align: 'center',sortable: false,dataIndex: 'AdmitDate'}"
	    Set gridColumn=gridColumn_"	,{header: '就诊类型',width: 80,align: 'center',sortable: false,dataIndex: 'AdmType'}"
	    Set gridColumn=gridColumn_"	,{header: '就诊科室',width: 80,align: 'center',sortable: false,dataIndex: 'Department'}"
	    Set storeFields=storeFields_"	,{name: 'patientNo', mapping: 'patientNo'}"
	    Set storeFields=storeFields_"	,{name: 'patientName', mapping: 'patientName'}"
	    Set storeFields=storeFields_"	,{name: 'patientSex', mapping: 'patientSex'}"
    	Set storeFields=storeFields_"	,{name: 'patientAge', mapping: 'patientAge'}"
	    Set storeFields=storeFields_"	,{name: 'AdmitDate', mapping: 'AdmitDate'}"
	    Set storeFields=storeFields_"	,{name: 'AdmType', mapping: 'AdmType'}"
	    Set storeFields=storeFields_"	,{name: 'Department', mapping: 'Department'}"
    }
    elseif business="03"{
	    Set gridColumn=gridColumn_"	,{header: '用户代码',width: 80,align: 'center',sortable: false,dataIndex: 'GoalUserCode'}"
	    Set gridColumn=gridColumn_"	,{header: '用户姓名',width: 80,align: 'center',sortable: false,dataIndex: 'GoalUserName'}"
	    Set gridColumn=gridColumn_"	,{header: '所属科室',width: 80,align: 'center',sortable: false,dataIndex: 'GoalUserLoc'}"
	    Set storeFields=storeFields_"	,{name: 'GoalUserCode', mapping: 'GoalUserCode'}"
	    Set storeFields=storeFields_"	,{name: 'GoalUserName', mapping: 'GoalUserName'}"
	    Set storeFields=storeFields_"	,{name: 'GoalUserLoc', mapping: 'GoalUserLoc'}"
    } 
    else
    {}
	Set storeFields=storeFields_"];"
	Set gridColumn=gridColumn_"];"
	Set return=gridColumn_" "_storeFields
	Quit return
	
BuildCRReportHeaderErr
	Quit ""
}

/// w ##Class(DHCMed.CR.BO.FormQry).BuildCRReportStoreTest(29,"2011-12-01","2013-12-27","","*00*01*02*")
ClassMethod BuildCRReportStoreTest(formId As %String, argargDateFrom As %String, argargDateTo As %String, argLocID As %String, argStatus As %String, argHospID As %String) As %String
{
	New (formId,argargDateFrom, argargDateTo, argLocID, argStatus,argHospID)
	Set return=0,Count=0
	
	Set $ZT="BuildCRReportStoreTestErr"
	
	Write "{record:[",!
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "DHCMed.CR.BO.FormQry"
	Set rset.QueryName = "QueryCRFReport"
	Do rset.Execute(argargDateFrom, argargDateTo, argLocID, argStatus, formId,argHospID)
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
			Set Count=Count+1
			Write:Count>1 ","
			Set json=""
			Set json=json_"{"
			Set json=json_"DataId:'"_rset.Data("DataId")_"'"
			Set json=json_",PatientID:'"_rset.Data("PatientID")_"'"
			Set json=json_",patientNo:'"_rset.Data("patientNo")_"'"
			Set json=json_",patientName:'"_rset.Data("patientName")_"'"
			Set json=json_",patientSex:'"_rset.Data("patientSex")_"'"
			Set json=json_",patientAge:'"_rset.Data("patientAge")_"'"
			Set json=json_",EpisodeID:'"_rset.Data("EpisodeID")_"'"
			Set json=json_",AdmitDate:'"_rset.Data("AdmitDate")_"'"
			Set json=json_",DepartmentID:'"_rset.Data("DepartmentID")_"'"
			Set json=json_",Department:'"_rset.Data("Department")_"'"
			Set json=json_",AdmType:'"_rset.Data("AdmType")_"'"
			Set json=json_",GoalUserID:'"_rset.Data("GoalUserID")_"'"
			Set json=json_",GoalUserCode:'"_rset.Data("GoalUserCode")_"'"
			Set json=json_",GoalUserName:'"_rset.Data("GoalUserName")_"'"
			Set json=json_",GoalUserLoc:'"_rset.Data("GoalUserLoc")_"'"
			Set json=json_",CreateUserID:'"_rset.Data("CreateUserID")_"'"
			Set json=json_",CreateUserCode:'"_rset.Data("CreateUserCode")_"'"
			Set json=json_",CreateUserName:'"_rset.Data("CreateUserName")_"'"
			Set json=json_",CreateDate:'"_rset.Data("CreateDate")_"'"
			Set json=json_",CreateTime:'"_rset.Data("CreateTime")_"'"
			Set json=json_",CreateCTLocID:'"_rset.Data("CreateCTLocID")_"'"
			Set json=json_",CreateCTLocCode:'"_rset.Data("CreateCTLocCode")_"'"
			Set json=json_",CreateCTLocDesc:'"_rset.Data("CreateCTLocDesc")_"'"
			Set json=json_",CurrentStatusCode:'"_rset.Data("CurrentStatusCode")_"'"
			Set json=json_",CurrentStatus:'"_rset.Data("CurrentStatus")_"'"
			Set json=json_",FormVerDR:'"_rset.Data("FormVerDR")_"'"
			Set json=json_",FormName:'"_rset.Data("FormName")_"'"
			;Set json=json_",FormType:'"_+rset.Data("FormVerDR")_"'"
			;Set json=json_",FormNameDesc:'"_rset.Data("FormName")_"'"
				
			Set json=json_"}"
			Write json,!
		}Else{ Quit }
	}
	Write "],total : "_Count_"}"
	
	Set return=1
	Quit return
	
BuildCRReportStoreTestErr
	Write "],total : "_Count_"}"
	Quit -1
}

/// Creator：     mxp
/// CreatDate：   2012-6-5
/// Description:  获取表单报告状态
/// Table：       DHCMed.CR.PO.FormStatus
/// Input：       formId
/// Return：      返回报告状态信息，按照<$C1>分隔行，^分隔字段
/// w ##class(DHCMed.CR.BO.FormQry).GetStatusList(1)
ClassMethod GetStatusList(formId As %String) As %String
{
	new (formId)
	s return=""
	set aType="CRFDataStatus"
 	Set aType=$ZCVT($g(aType),"U")
 	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+formId) return
 	s ChildSub=0
 	f {
	 	s data=""
	 	s ChildSub=$o(^DHCMed.CR.PO.FormD(formId,"StatusList",ChildSub))
 	 	q:ChildSub=""
 		s objFormStatus=##class(DHCMed.CR.PO.FormStatus).%OpenId(formId_"||"_ChildSub)
 		i $IsObject(objFormStatus){
	 		s objStasue=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRFViewDataStatus",objFormStatus.StatusCode,1)
			s CurrentStatus=objStasue.Description
	 		s data=data_objFormStatus.StatusCode_"^"_CurrentStatus
			s:return'="" return=return_"<$C1>"
			s return=return_data
 		}
 	}
	q return
}

/// Creator：     maxp
/// CreatDate：   2012-04-27
/// Description:  根据综合条件查询临床表单报告
/// Table：       DHCMed.CR.PO.Data
/// Input：       argDateFrom 开始时间
///               argDateTo   结束时间
///               argLocID    科室
///               argStatus   状态
///               argFormID 临床上报表单IDs
/// Return：      $lb(临床上报表单相关信息)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CR.BO.FormQry","QueryCRFReport","2013-05-17","2013-12-27","","00^01",1)
Query QueryCRFReport(argDateFrom As %String, argDateTo As %String, argLocID As %String, argStatus As %String, argFormID As %String, argHospID As %String) As %Query(ROWSPEC = "DataId:%String,PatientID:%String,patientNo:%String,patientName:%String,patientSex:%String,patientAge:%String,EpisodeID:%String,AdmitDate:%String,DepartmentID:%String,Department:%String,AdmType:%String,GoalUserID:%String,GoalUserCode:%String,GoalUserName:%String,GoalUserLoc:%String,CreateUserID:%String,CreateUserCode:%String,CreateUserName:%String,CreateDate:%String,CreateTime:%String,CreateCTLocID:%String,CreateCTLocCode:%String,CreateCTLocDesc:%String,CurrentStatusCode:%String,CurrentStatus:%String,FormVerDR:%String,FormName:%String")
{
}

ClassMethod QueryCRFReportExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argStatus As %String, argFormID As %String, argHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s argDateFrom=$zdh(argDateFrom,5)
	s argDateTo=$zdh(argDateTo,5)
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
    Quit:argDateFrom>argDateTo $$$OK
	
	s DataId=""
	for {
		s DataId=$o(^DHCMed.CR.PO.DataD(DataId))
		q:DataId=""
		s objData=##class(DHCMed.CR.PO.Data).GetObjById(+DataId)
		continue:'$IsObject(objData)
		Set formId=+objData.FormVerDR
		s objForm=##class(DHCMed.CR.PO.Form).GetObjById(formId)
		continue:'$IsObject(objForm)
		Set CreateDate=objData.CreateDate
		Set CreateCTLocID=+objData.CreateCTLocID
		Set CurrentStatusCode=objData.CurrentStatusCode

		continue:((argFormID'="")&&(formId'=argFormID))
		continue:((CreateDate'="")&&((CreateDate<argDateFrom)||(CreateDate>argDateTo)))
		continue:((argLocID'="")&&(CreateCTLocID'=argLocID))
		Set HospID=$p($g(^CTLOC(CreateCTLocID)),"^",22) 
		Continue:(argHospID'="")&&(HospID'=argHospID)  //医院过滤
		continue:((argStatus'="")&&(argStatus'[CurrentStatusCode))
		
		set Data=..BuildReportData(objData)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
    Quit $$$OK
}

ClassMethod QueryCRFReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCRFReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCRFReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCRFReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod BuildReportData(objData)
{
	n (objData)
	Set DataId=objData.%Id() 
	//Set formId=+objData.FormVerDR
	Set CreateDate=objData.CreateDate
	Set CreateCTLocID=+objData.CreateCTLocID
	Set CurrentStatusCode=objData.CurrentStatusCode

	s PatientID=objData.PatientID
	s objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){ //PatientID'="" { 
		s objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
		s patientNo=objPatient.PapmiNo
		s patientName=objPatient.PatientName
		s patientSex=objPatient.Sex
		s patientAge=objPatient.Age
	}
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	s EpisodeID=objData.EpisodeID
	s objPatientAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	If $IsObject(objPatientAdm){ //EpisodeID'="" { 
		s objPatientAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		s AdmitDate=objPatientAdm.AdmitDate
		s DepartmentID=objPatientAdm.DepartmentID
		s Department=objPatientAdm.Department
		s AdmType=objPatientAdm.AdmType
	}

	s GoalUserID=objData.GoalUserID
	s objGoalUser=##class(DHCMed.Base.SSUser).GetObjById(GoalUserID)
	If $IsObject(objGoalUser){ //GoalUserID'="" { 
		s objGoalUser=##class(DHCMed.Base.SSUser).GetObjById(GoalUserID)
		s GoalUserCode=objGoalUser.Code 
		s GoalUserName=objGoalUser.Name
		s GoalUserLoc=objGoalUser.CtlocDesc	
	}
 
	s CreateUserID=objData.CreateUserID
	s objUser=##class(DHCMed.Base.SSUser).GetObjById(CreateUserID)
 	s CreateUserCode=objUser.Code //$p(objUser,"^",2) 
	s CreateUserName=objUser.Name //$p(objUser,"^",3) 
	s CreateDate=$zd(CreateDate,3)
	s CreateTime=$zt(objData.CreateTime,1)
	;s CreateCTLocID=objData.CreateCTLocID
	s objCTLoc=##class(DHCMed.Base.Ctloc).GetObjById(CreateCTLocID)
	s CreateCTLocCode=objCTLoc.Code 
	s CreateCTLocDesc=objCTLoc.Descs
	;s CurrentStatusCode=objData.CurrentStatusCode
	s objStasue=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRFViewDataStatus",CurrentStatusCode,1)
	s CurrentStatus=objStasue.Description
 	s FormVerDR=objData.FormVerDR
 	Set objForm=##class(DHCMed.CR.PO.Form).GetObjById(+FormVerDR)
 	Do objForm.%Close()
 	Set FormName=objForm.CName
 	
 	if objForm.Business="03"
 	{
	 	s ClassName=##class(DHCMed.CR.PO.Form).%OpenId(+FormVerDR).GetClassName()
		 set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
		s objIns=##class(DHCMed.CR.PO.Data).%OpenId(DataId)
		S arg="Set value=objIns."_"UserName"
		X arg
	 	s GoalUserName=value
 	}
		
	Set Data=$lb(DataId)
	Set Data=Data_$lb(PatientID,patientNo,patientName,patientSex,patientAge)
	Set Data=Data_$lb(EpisodeID,AdmitDate,DepartmentID,Department,AdmType)
	Set Data=Data_$lb(GoalUserID,GoalUserCode,GoalUserName,GoalUserLoc)
	Set Data=Data_$lb(CreateUserID,CreateUserCode,CreateUserName,CreateDate,CreateTime)
	Set Data=Data_$lb(CreateCTLocID,CreateCTLocCode,CreateCTLocDesc)
	Set Data=Data_$lb(CurrentStatusCode,CurrentStatus)
	Set Data=Data_$lb(FormVerDR,FormName,EncryptLevel,PatLevel)	
	Quit Data
}

/// 功能：通过患者ID查询报告
/// 创建者：李阳
/// 创建时间：2013-10-24
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CR.BO.FormQry","QryByPatientID",6,"")
Query QryByPatientID(PatientID As %String, argFormCode As %String) As %Query(ROWSPEC = "DataId:%String,PatientID:%String,patientNo:%String,patientName:%String,patientSex:%String,patientAge:%String,EpisodeID:%String,AdmitDate:%String,DepartmentID:%String,Department:%String,AdmType:%String,GoalUserID:%String,GoalUserCode:%String,GoalUserName:%String,GoalUserLoc:%String,CreateUserID:%String,CreateUserCode:%String,CreateUserName:%String,CreateDate:%String,CreateTime:%String,CreateCTLocID:%String,CreateCTLocCode:%String,CreateCTLocDesc:%String,CurrentStatusCode:%String,CurrentStatus:%String,FormVerDR:%String,FormName:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryByPatientIDExecute(ByRef qHandle As %Binary, PatientID As %String, argFormCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:((PatientID="")&&(argFormCode="")) $$$OK
	Set ReportID=""
	For {
		Set ReportID=$o(^DHCMed.CR.PO.DataI("IndexPatientID",PatientID,ReportID))
		Quit:ReportID=""
		Set objReport=##class(DHCMed.CR.PO.Data).GetObjById(ReportID)
		Continue:'$IsObject(objReport)
		Do objReport.%Close()
		Set objFrmVer=##class(DHCMed.CR.PO.FormVer).GetObjById(objReport.FormVerDR)
		Continue:'$IsObject(objFrmVer)
		Do objFrmVer.%Close()
		Continue:((argFormCode'=objFrmVer.Form.EName)&&(argFormCode'=""))
		Set data=..BuildReportData(objReport)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryByPatientIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByPatientIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryByPatientIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByPatientIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
