/// 名称: DHCMed.CR.BO.Design
/// 描述: 表单设计器服务
/// 编写者：wuqk
/// 编写日期: 2012-12-06
Class DHCMed.CR.BO.DataService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2012-12-06
/// Description:  保存表单示例数据
/// Table：       DHCMed.CR.PO.Data 和 表单对应的存储结构
/// Input：       %request,%session
/// Return：      Result
/// w ##class(DHCMed.CR.BO.DataService).SaveData()
ClassMethod SaveData() As %String
{
	
	new (%request,%session)
	
	m ^tmpcrf("SaveData",$j,$h,"SaveDate","%request")=%request.Data
	
	//Set $ZT="SaveDataErr"
	
	//表单
	set FormId = %request.Get("FormId",1)
	set FormVerId = %request.Get("formVerId",1)
	//数据
	set keyId = +%request.Get("keyId",1)
	set DataStr = %request.Get("DataStr",1)
	
	;set ClassName=$classmethod("DHCMed.CR.PO.Form","%OpenId",+FormVerId).GetClassName()
	set ClassName=##class(DHCMed.CR.PO.Form).%OpenId(+FormVerId).GetClassName() //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
	set objData=##class(DHCMed.CR.Util.JsonObject).ObjectFromJSON(DataStr,ClassName)
	
	//s objForm=##class(DHCMed.CR.Util.JsonObject).ObjectFromJSON(FormInfo,"DHCMed.CR.Form")
	//set ClassName="DHCMed."_objForm.Type_"."_objForm.EName
	//s ^tmp($h,1)=ClassName
	//set objData.FormVerDR = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	//d $System.OBJ.Dump(objData)
	
	set sc=objData.%Save()
	s ^tmpcrf($j,$h,"SaveDate","sc")=sc

	if $$$ISERR(sc) {  
                             //检查Save是否成功
   		set error = $System.Status.GetErrorText(sc)
   		set $ECODE="<Save Error>"_error
   		quit "{Result:false, Message:'"_error_"'}"
	}
	else{
		set id=objData.%Id()
	}
	
	quit "{keyid:"_id_"}"  //"{Result:true,keyid:"_id_"}"
	
	//SaveDataErr
	//quit "{Result:false, Message:'"_$ZE_"'}"
}

/// Creator：     wuqk
/// CreatDate：   2012-12-06
/// Description:  获取表单示例数据
/// Table：       DHCMed.CR.PO.Data 和 表单对应的存储结构
/// Input：       %request,%session
/// Return：      Result
/// w ##class(DHCMed.CR.BO.DataService).GetInstanceData()
ClassMethod GetInstanceData() As %String
{
	
	new (%request,%session)
	
	//Set $ZT="GetInstanceDataErr"
	//表单
	//set formId = %request.Get("formId")
	//set objForm=##class(ext.util.JsonObject).ObjectFromJSON(FormInfo,"Entity.Form")
	//set ClassName="DHCMed."_objForm.Type_"."_objForm.EName
	//set ClassName=$classmethod("DHCMed.CR.PO.Form","%OpenId",formId).GetClassName()
	
	//数据
	set ID = +%request.Get("keyId")
	w:ID<1 "{}" //"{Result:true}"
	
	set objData =##class(DHCMed.CR.PO.Data).%OpenId(+ID) //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
	w:'$IsObject(objData) "{}" //"{Result:true}"
	
	set ClassName = objData.%ClassName(1)
	s ^tmpcrf("GetInstanceData",$j,$h,"ClassName")=ClassName
	
	//Modified By LiYang 2014-05-13 为老版本数据库提供兼容
	Set arg="Set obj=##class("_ClassName_").%OpenId(+ID)"
	X arg
	;set obj=$classmethod(ClassName,"%OpenId",+ID)
	w:'$IsObject(obj) "{}" //"{Result:true}"
	
	quit obj
	
	set JsonObject = ##class(DHCMed.CR.Util.JsonObject).%New()
	do JsonObject.FromObject(obj)
	set data=JsonObject.Json()

	quit "{Result:true,data:"_data_"}"
}

/// Creator：     mxp
/// CreatDate：   2012-12-27
/// Description:  获取报告状态
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// Return：      返回报告状态信息，按照<$C1>分隔行，^分隔字段
/// w ##class(DHCMed.CR.BO.DataService).GetStatusList()
ClassMethod GetStatusList() As %String
{
	s return=""
	s Rowid=""
	s argType="CRFDataStatus" 
	for {
		s data=""
		s Rowid=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT(argType,"U"),Rowid))
		Quit:Rowid=""
		Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(Rowid)
		if objDic.Active d
		.s data=data_objDic.Code_"^"_objDic.Description
		.s:return'="" return=return_"<$C1>"
		.s return=return_data
		d objDic.%Close()
	}
	q return
}

/// w ##class(DHCMed.CR.BO.DataService).SaveDataTest()
ClassMethod SaveDataTest() As %String
{
	
	;new (%request,%session)
	
	;m ^tmpcrf("SaveData",$j,$h,"SaveDate","%request")=%request.Data
	;set formVerId = %request.Get("formVerId")
	set formVerId ="1||4"
	set keyId ="18" //+%request.Get("keyId")
	;set DataStr = %request.Get("DataStr")
	set DataStr ="{FormVerDR:1||3,EpisodeID:1,PatientID:2,txtPatientNo:0000000001,txtName:小三,textResume:ssaa,numbertext1:25,text6:,text4:男,text7:med,text8:1988-03-24,text9:0000000001,CurrentStatusCode:01}"

	set ClassName=##class(DHCMed.CR.PO.Form).%OpenId(+formVerId).GetClassName() //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
	set objData=##class(DHCMed.CR.Util.JsonObject).ObjectFromJSON(DataStr,ClassName)
	
	//s objForm=##class(DHCMed.CR.Util.JsonObject).ObjectFromJSON(FormInfo,"DHCMed.CR.Form")
	//set ClassName="DHCMed."_objForm.Type_"."_objForm.EName
	//s ^tmp($h,1)=ClassName
	//set objData.FormVerDR = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	//d $System.OBJ.Dump(objData)
	
	set sc=objData.%Save()
	s ^tmpcrf($j,$h,"SaveDate","sc")=sc
	
	if $$$ISERR(sc) {                               //检查Save是否成功
   		set error = $System.Status.GetErrorText(sc)
   		;set $ECODE="<Save Error>"_error
   		quit "{Result:false, Message:'"_error_"'}"
	}
	else{
		set id=objData.%Id()
	}
	
	quit "{keyid:"_id_"}"  //"{Result:true,keyid:"_id_"}"
	
	//SaveDataErr
	//quit "{Result:false, Message:'"_$ZE_"'}"
}

/// w ##class(DHCMed.CR.BO.DataService).checkIsObj()
ClassMethod checkIsObj(formVerId) As %Boolean
{
	set return=false
	set ClassName=##class(DHCMed.CR.PO.Form).%OpenId(+formVerId).GetClassName() //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(ClassName)
	set:'$IsObject(dcd) return=true
	q reurn
}

/// w ##class(DHCMed.CR.BO.DataService).ChangeDataStatus("04",75,"9^ggggjj")
ClassMethod ChangeDataStatus(StatusCode, DataId, str)
{
	n (StatusCode,DataId,str)
	
	set return=0
	q:(DataId="")||(StatusCode="") return
	q:'$d(^DHCMed.CR.PO.DataD(DataId)) return
	set objData = ##class(DHCMed.CR.PO.Data).%OpenId(DataId)
	//q:objData.CurrentStatusCode'="01" return
	
	set objStatus = ##class(DHCMed.CR.PO.StatusList).%New()
	set objStatus.ParRef = objData
	set objStatus.sDate = +$h
	set objStatus.sTime = $p($h,",",2)
	set objStatus.sUserID = $p(str,"^",1)
	set objStatus.sStatusCode = StatusCode
	set objStatus.sResume = $p(str,"^",2)
	set sc=objStatus.%Save()
	
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		&sql(UPDATE DHCMed_CR_PO.Data SET CurrentStatusCode='04' WHERE ID = :DataId)
		Set return=+objStatus.%Id()
	}
	
	//set objData.CurrentStatusCode=StatusCode
	//set sc=objData.%Save()
	Do objStatus.%Close()
	
	q return
}

}
