/// 名称: DHCMed.CR.BO.FormShow
/// 描述: 表单展现
/// 编写者：wuqk
/// 编写日期: 2013-1-9
Class DHCMed.CR.BO.FormShow Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2013-1-9
/// Description:  运行表单
/// Table：       DHCMed.CR.PO.FormVer
/// Input：       %request
/// Return：      
/// w ##class(DHCMed.CR.BO.FormShow).WriteHtmlLayout()
ClassMethod WriteHtmlLayout() As %Status
{
	
	//表单的相关参数
	set formCode = %request.Get("formCode")        //表单代码
	set formId = %request.Get("formId")            //表单Id
	set keyId = %request.Get("keyId")              //实例数据Id
	set formVerId = %request.Get("formVerId")      //表单版本Id
	
	set design = +%request.Get("design")      	   //设计态标记
	
	//业务参数
	set PatientID = %request.Get("PatientID")        //PatientID
	set EpisodeID = %request.Get("EpisodeID")        //EpisodeID
	set GoalUserID = %request.Get("GoalUserID")      //GoalUserID
	
	set flag = ..CheckFormInfo(formCode,formId,keyId,formVerId,design,PatientID,EpisodeID,GoalUserID)
	
	w:+flag<0 "<html><body>"_$p(flag,"^",2)_"</body></html>"
	quit:+flag<0
	
	set formVerId = $p(flag,"^",1)
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	set htmlLayout=objFormVer.htmlLayout
	w htmlLayout.ReadLine()
	
	set keys = "LOGON.TIMEOUT,LOGON.SITECODE,LOGON.REGION,LOGON.USERID,LOGON.USERCODE,LOGON.USERNAME,LOGON.GROUPID,LOGON.GROUPDESC,LOGON.LANGID,LOGON.CTLOCID,LOGON.WARDID,LOGON.HOSPID"
	w !,"<!-- form version "_formVerId_" --",!
	w "// formCode = "_formCode,!
	w "// formId = "_formId,!
	w "// keyId = "_keyId,!
	w "// formVerId = "_formVerId,!
	w "// design = "_design,!
	w "// PatientID = "_PatientID,!
	w "// EpisodeID = "_EpisodeID,!
	w "// GoalUserID = "_GoalUserID,!
	w "------------------------------------>",!!
	w "<script language='javascript'>",!
	w "var session=new Array();",!
	set key=""
	for i=1:1:$l(keys,",") {
		//set k = $o(%session.Data(k))
		//quit:k=""
		//w "session['"_k_"']='"_%session.Data(k)_"'; "
		set key = $p(keys,",",i)
		quit:key=""
		w "session['"_key_"']='"_%session.Get(key)_"'; ",!
	}
	//w:printed "  window.print();"
	w "</"_"script>"
	w "<script type='text/javascript' src='../scripts/dhcmed/crf/js/event.js' ></script>"
	for {
		set layout=htmlLayout.ReadLine()
		quit:layout=""
		w layout
	}
	set objForm=""
	set htmlLayout=""
	quit $$$OK
}

/// Creator：     wuqk
/// CreatDate：   2013-1-9
/// Description:  检查运行时表单参数
/// Table：       DHCMed.CR.PO.FormVer
/// Input：       %request
/// Return：      
/// w ##class(DHCMed.CR.BO.FormShow).CheckFormInfo()
ClassMethod CheckFormInfo(formCode, formId, keyId, formVerId, design, PatientID, EpisodeID, GoalUserID) As %String
{
	new (formCode,formId,keyId,formVerId,design,PatientID,EpisodeID,GoalUserID)
	set errFlag=0,errMSG=""
	
	set formCode = $g(formCode)
	set formId = $g(formId)
	set keyId = +$g(keyId)
	set formVerId = $g(formVerId)
	set design = +$g(design)
	set PatientID = +$g(PatientID)
	set EpisodeID = +$g(EpisodeID)
	set GoalUserID = +$g(GoalUserID)
	
	s ^tmpcrf("CheckFormInfo",$j,$h)=$lb(formCode,formId,keyId,formVerId,design,PatientID,EpisodeID,GoalUserID)
	if (keyId="")&(formVerId="")&(formId="")&(formCode="") {
		set errFlag = -100
		set errMSG = "Form Argument is null."
		quit errFlag_"^"_errMSG
	}
	

	/*********判断调阅表单版本的逻辑********/
	//1、如果传入了keyId，按照keyId。此时应非设计态
	if keyId>0 {
		set objData = ##class(DHCMed.CR.PO.Data).GetObjById(keyId)
		if $IsObject(objData) {
			set formVerId = objData.FormVerDR  //.%Id()
			do GetByVerId
		}
		else {
			set errFlag=-1
			set errMSG="Data not Found, keyId="_keyId_"."
		}
	}
	//2、判断是否传入了表单版本Id
	elseif formVerId'="" {
		do GetByVerId
	}
	//3、判断是否传入了表单Id，取当前发布版本
	elseif formId '= "" {
		do GetByFormId
	}
	//4、判断是否传入了表单代码，取当前发布版本
	else {
		do GetByCode
	}
	
	if errFlag<0 {
		quit errFlag_"^"_errMSG
	}
	quit formVerId
	

GetByVerId
	if formVerId="" {
		set errFlag=-2.1
		set errMSG="Form formVerId="_formVerId_",is not Found."
		quit
	}
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	if '$IsObject(objFormVer){
		set errFlag=-2.2
		set errMSG="Form formVerId="_formVerId_", is not Found."
		quit
	}
	elseif (design=0){   //运行态
		quit:keyId>0
		
		//要求1：版本已经发布
		if objFormVer.IsPublished '= 1 {
			set errFlag=-2.3
			set errMSG="Form formVerId="_formVerId_", is not Published."
			quit
		}
		
		//要求2：相关业务参数正确
		set formBusiness = objFormVer.Form.Business
		s ^tmpcrf("CheckFormInfo",$j,$h,"Business")=formBusiness
		set errMSG="Form Business ="_formBusiness_", "
		if (formBusiness = "01") && (+PatientID = 0) {
			set errFlag=-2.4
			set errMSG = errMSG_" please select a PatientID ."
			quit
		}
		elseif (formBusiness = "02") && (+EpisodeID = 0) {
			set errFlag=-2.5
			set errMSG = errMSG_" please select a EpisodeID ."
			quit
		}
		elseif (formBusiness = "03") && (+GoalUserID = 0) {
			set errFlag=-2.6
			set errMSG = errMSG_" please select a GoalUserID ."
			quit
		}
		
	}
	quit
	
GetByFormId
	if formId="" {
		set errFlag=-3.1
		set errMSG="Form formCode="_formCode_",is not Found."
		quit
	}
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(+formId)
	if '$IsObject(objForm){
		set errFlag=-3.2
		set errMSG="Form formId="_formId_", is not Found."
		quit
	}
	else{
		//取当前发布版本
		set formVerId = objForm.CurrentVerID
		do GetByVerId
	}
	quit
	
GetByCode
	set formCode=$ZCVT(formCode,"U")
	set formSchema=$p(formCode,".",1)
	set formType=$p(formCode,".",2)
	set formEName=$p(formCode,".",3)
	if (formSchema="")||(formType="")||(formEName=""){
		set errFlag=-4.1
		set errMSG="Form formCode="_formCode_",is not correct."
		quit
	}
	set formId = $o(^DHCMed.CR.PO.FormI("IndexTypeName"," "_formSchema," "_formType," "_formEName,""))
	do GetByFormId
	quit
}

///  Creator：     wuqk
///  CreatDate：   2013-01-06
///  Description:  根据表单ID获取状态列表
///  Table：       DHCMed.CR.PO.FormStatus
///  Input：       formId
///  Return：      
///  w ##class(DHCMed.CR.BO.FormShow).GetStatusByFormId1(1)
ClassMethod GetStatusByFormId1(formId As %String) As %String
{
	new (formId)
	
	set list=""
	
	set aType="CRFDataStatus"
 	Set aType=$ZCVT($g(aType),"U")
 	Set RowID=0
 	set objJSON = ##class(DHCMed.CR.Util.JsonObject).%New()
 	For {
	 	Set RowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(RowID)
		If $IsObject(objDic){
			Set Active=objDic.Active
			If (Active="1"){
				//do list.Insert(objDic)
				d objJSON.FromObject(objDic)
				//set josnString = objJSON.Json()
				set list = list_","_objJSON.Json()
			}
		}
 	}
 	set:list'="" list="["_$e(list,2,$l(list))_"]"
 	set:list="" list="[]"
 	quit list
}

///  Creator：     mxp
///  CreatDate：   2013-05-09
///  Description:  根据表单ID获取状态列表
///  Table：       DHCMed.CR.PO.FormStatus
///  Input：       formId
///  Return：      
///  w ##class(DHCMed.CR.BO.FormShow).GetStatusByFormId(1)
ClassMethod GetStatusByFormId(formId As %String) As %String
{
	new (formId)
	
	set list=""
	
	set aType="CRFDataStatus"
 	Set aType=$ZCVT($g(aType),"U")
 	set objJSON = ##class(DHCMed.CR.Util.JsonObject).%New()
 	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+formId) "[]"
 	s ChildSub=0
 	f {
	 	s ChildSub=$o(^DHCMed.CR.PO.FormD(formId,"StatusList",ChildSub))
 	 	q:ChildSub=""
 		s objFormStatus=##class(DHCMed.CR.PO.FormStatus).%OpenId(formId_"||"_ChildSub)
 		i $IsObject(objFormStatus){
	 		//do list.Insert(objFormStatus)
	 		d objJSON.FromObject(objFormStatus)
			//set josnString = objJSON.Json()
			set list = list_","_objJSON.Json()
 		}
 	}
 	set:list'="" list="["_$e(list,2,$l(list))_"]"
 	set:list="" list="[]"
 	quit list
}

/// w ##class(DHCMed.CR.BO.FormShow).getJson()
ClassMethod getJson() As %String
{
	s ret="[{"_"""Form"""_":1,ID:"_"""1||7"""_",IsCheckData:"_"""0"""_",IsSubmitData:"_"""0"""_",StatusCode:"_"""00"""_",StatusName:"_"""草稿"""_"}]"
    quit ret
}

/// w ##class(DHCMed.CR.BO.FormShow).getFormTest()
ClassMethod getFormTest(formId As %String) As %String
{
		new (formId)
	
	set list=""
	
	set aType="CRFDataStatus"
 	Set aType=$ZCVT($g(aType),"U")
 	set objJSON = ##class(DHCMed.CR.Util.JsonObject).%New()
 	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+formId) $$$OK
 	s ChildSub=0
 	f {
	 	s ChildSub=$o(^DHCMed.CR.PO.FormD(formId,"StatusList",ChildSub))
 	 	q:ChildSub=""
 		s objFormStatus=##class(DHCMed.CR.PO.FormStatus).%OpenId(formId_"||"_ChildSub)
 		i $IsObject(objFormStatus){
	 		//do list.Insert(objFormStatus)
	 		d objJSON.FromObject(objFormStatus)
			//set josnString = objJSON.Json()
			set list = list_","_objJSON.Json()
 		}
 	}
 	set:list'="" list="["_$e(list,2,$l(list))_"]"
 	set:list="" list="[]"
 	quit list
}

}
