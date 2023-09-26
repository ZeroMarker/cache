/// Creator:bianshuai
/// CreateDate：2014-12-29
/// Descript:不良反应接口类
Class web.DHCST.SoapMethod.AdrReportService Extends %Persistent
{

/// Descript:发送不良反应报告到OA,供页面调用
/// Result:  处理结果^处理结果的描述
ClassMethod SendAdrReportToOASystem() As %String
{
	S adrReportXmlStr=##class(web.DHCST.SoapMethod.AdrReportService).getAdrReportXML(7437)
}

/// Descript:修改不良反应报告状态,供OA调用
ClassMethod ModifyAdrReport(Input As %String) As %String
{
	
	///解析OA调用XML串
	s retval=..analysisAdrRepXml(Input)
	i $p(retval,"^",1)'="-1" d
	.///更新报表报表状态
	.s retval=..auditAdrReport(retval)
	
	///回传结果给OA
	s retObj=##class(web.DHCST.SoapModel.AdrRepRetModel).%New()
	s retObj.statusCode=$p(retval,"^",1)   ///处理结果
	s retObj.statusDesc=$p(retval,"^",2)   ///处理结果的描述

	q ""
}

/// Descript:解析XML
ClassMethod analysisAdrRepXml(Input As %String) As %String
{
	S $zt="ErrorMsg1"
	S ret=""
	Q:Input="" "-1^Empty String!"
	S reader=##class(%XML.Reader).%New()
	S sc=reader.OpenString(Input)   //字符串
	 
	if $$$ISERR(sc) do $System.Status.DisplayError(sc) Quit "-2^OpenString Error!"
	
    Do reader.Correlate("Modify","web.DHCST.SoapModel.AdrRepModifyModel")

    While reader.Next(.Modify,.sc) 
    {
   		S mainstr=Modify.iFlowFlag_"^"_Modify.sThirdBusinessId()_"^"_Modify.sOperationTime()
    }
    Quit mainstr
ErrorMsg1
 	Set RetStr="-1^程序异常"_$ze
 	q RetStr
}

/// Descript:不良反应报告
/// w ##class(web.DHCST.SoapMethod.AdrReportService).getAdrReportXML(85)
ClassMethod getAdrReportXML(adrrRepID As %String) As %String
{
	//S $zt="ErrorMsg"
	S Xml=""
	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S adrReportStr=##class(web.DHCST.SoapMethod.AdrReportService).getAdrRepInfo(pid,adrrRepID)
	Q:adrReportStr="" "-1^取数据错误"
	
	S adrReportObj=##class(web.DHCST.SoapModel.Adr.data).%New()
	//
	s objProp=..GetObjProp("ADRRID",$p(adrReportStr,"^",1))		///报告ID
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCode",$p(adrReportStr,"^",2))	///报告编码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDate",$p(adrReportStr,"^",3))         ///报告日期
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPriority",$p(adrReportStr,"^",4))     ///首次报告
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPriority_Code",$p(adrReportStr,"^",5)) ///首次报告代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRRepType",$p(adrReportStr,"^",6))      ///报告类型
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRRepType_Code",$p(adrReportStr,"^",7))  ///报告类型代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptType",$p(adrReportStr,"^",8))     ///报告单位类型
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptType_Code",$p(adrReportStr,"^",9)) ///报告单位类型代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptElse",$p(adrReportStr,"^",10))     ///报告单位其它类型描述
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatName",$p(adrReportStr,"^",11))      ///患者姓名
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatSex",$p(adrReportStr,"^",12))       ///性别
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatSex_Code",$p(adrReportStr,"^",13))   ///性别代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatAge",$p(adrReportStr,"^",14))       ///年龄
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatDOB",$p(adrReportStr,"^",15))       ///出生日期
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatNation",$p(adrReportStr,"^",16))    ///民族
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatNation_Code",$p(adrReportStr,"^",17)) ///民族代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatWeight",$p(adrReportStr,"^",18))     ///体重
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatContact",$p(adrReportStr,"^",19))    ///联系方式
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPatMedNo",$p(adrReportStr,"^",20))      ///病历号
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREventHistory",$p(adrReportStr,"^",21))  ///既往药品不良反应事件
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREventHistory_Code",$p(adrReportStr,"^",22))  ///既往药品不良反应事件代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREventHistDesc",$p(adrReportStr,"^",23))     ///既往药品不良反应事件
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREventFamily",$p(adrReportStr,"^",24))       ///家族药品不良反应事件
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREventFamily_Code",$p(adrReportStr,"^",25))   ///家族药品不良反应事件代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREventFamiDesc",$p(adrReportStr,"^",26))     ///家族药品不良反应事件
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDateOccu",$P(adrReportStr,"^",27))          ///事件发生日期
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRResult",$P(adrReportStr,"^",28))            ///事件的结果
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRResult_Code",$P(adrReportStr,"^",29))    ///事件的结果代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRResultDesc",$P(adrReportStr,"^",30))    ///事件的结果描述
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDateResult",$P(adrReportStr,"^",31))    ///好转(死亡))日期
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRTimeResult",$P(adrReportStr,"^",32))    ///好转(死亡))时间
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRStopResult",$P(adrReportStr,"^",33))    ///停药后是否减轻
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRStopResult_Code",$P(adrReportStr,"^",34))    ///停药后是否减轻代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRTakingAgain",$P(adrReportStr,"^",35))       ///再次使用时是否再次出现同样反应
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRTakingAgain_Code",$P(adrReportStr,"^",36))   ///再次使用时是否再次出现同样反应代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREffectOfTreatment",$P(adrReportStr,"^",37))       ///对原疾病的影响
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREffectOfTreatment_Code",$P(adrReportStr,"^",38))   ///对原疾病的影响代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCommentOfUser",$P(adrReportStr,"^",39))     	  ///关联性评价之报告人评价
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCommentOfUser_Code",$P(adrReportStr,"^",40))       ///关联性评价之报告人评价代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRUserOfReport",$P(adrReportStr,"^",41))      ///报告人评价签字
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRUserOfReport_Code",$P(adrReportStr,"^",42))  ///报告人评价签字代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCommentOfDept",$P(adrReportStr,"^",43))     ///关联性评价之报告单位评价
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCommentOfDept_Code",$P(adrReportStr,"^",44)) ///关联性评价之报告单位评价代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptOfReport",$P(adrReportStr,"^",45))      ///报告单位评价签字
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRTelephone",$P(adrReportStr,"^",46))         ///报告人联系电话
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCareerOfRepUser",$P(adrReportStr,"^",47))   ///报告人职业
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCareerOfRepUser_Code",$P(adrReportStr,"^",48))    	///报告人职业代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRCareerOfRepElse",$P(adrReportStr,"^",49))   		///报告人职业
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRREmailOfRepUser",$P(adrReportStr,"^",50))   	     	///报告人邮箱
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRLocOfReporter",$P(adrReportStr,"^",51))          	///报告人所属科室
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRLocOfReporter_Code",$P(adrReportStr,"^",52)) 		///报告人所属科室代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRProTitleOfReporter",$P(adrReportStr,"^",53))        ///报告人职称
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRProTitleOfReporter_Code",$P(adrReportStr,"^",54))    ///报告人职称代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRPosOfReporter",$P(adrReportStr,"^",55))             ///报告人职务
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRWishes",$P(adrReportStr,"^",56))                    ///填报意愿
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRWishes_Code",$P(adrReportStr,"^",57))                ///填报意愿代码
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptName",$P(adrReportStr,"^",58))                  ///报告单位名称
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptContacts",$P(adrReportStr,"^",59))              ///报告单位联系人
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRDeptTel",$P(adrReportStr,"^",60))                   ///报告单位联系电话
	d adrReportObj.data.Insert(objProp)
	s objProp=..GetObjProp("ADRRRemark",$P(adrReportStr,"^",61))                    ///备注
	d adrReportObj.data.Insert(objProp)
	///患者相关重要信息
	S objchildren=##class(web.DHCST.SoapModel.Adr.children).%New()
	S objchildren.name="PatImpo"
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepImpInfo",pid,sub)) Q:sub=""  D
	.S adrRepImpDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepImpInfo",pid,sub))
	.s objchild=##Class(web.DHCST.SoapModel.Adr.child).%New()
	.s objProp=..GetObjProp("ADRRIADRII",$p(adrRepImpDataList,"^",1))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRIADRII_CODE",$p(adrRepImpDataList,"^",1))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRIADRIIElse",$p(adrRepImpDataList,"^",2))
	.d objchild.prop.Insert(objProp)
	.d objchildren.child.Insert(objchild)
	d adrReportObj.children.Insert(objchildren)
	///不良反应事件/名称
	S objchildren=##class(web.DHCST.SoapModel.Adr.children).%New()
	S objchildren.name="Event"
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepEvent",pid,sub)) Q:sub=""  D
	.S adrRepEvtDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepEvent",pid,sub))
	.s objchild=##Class(web.DHCST.SoapModel.Adr.child).%New()
	.s objProp=..GetObjProp("ADDREVENT",$p(adrRepEvtDataList,"^",2))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADDREVENT_CODE",$p(adrRepEvtDataList,"^",1))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADDREVENTElse",$p(adrRepEvtDataList,"^",3))
	.d objchild.prop.Insert(objProp)
	.d objchildren.child.Insert(objchild)
	d adrReportObj.children.Insert(objchildren)
	///原患疾病
	S objchildren=##class(web.DHCST.SoapModel.Adr.children).%New()
	S objchildren.name="Diag"
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDiag",pid,sub)) Q:sub=""  D
	.S adrRepDiagDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDiag",pid,sub))
	.s objchild=##Class(web.DHCST.SoapModel.Adr.child).%New()
	.s objProp=..GetObjProp("ADDRDICD",$p(adrRepDiagDataList,"^",2))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADDRDICD_CODE",$p(adrRepDiagDataList,"^",1))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADDRDICDElse",$p(adrRepDiagDataList,"^",3))
	.d objchild.prop.Insert(objProp)
	.d objchildren.child.Insert(objchild)
	d adrReportObj.children.Insert(objchildren)
	///反应过程
	S objchildren=##class(web.DHCST.SoapModel.Adr.children).%New()
	S objchildren.name="Proc"
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepProc",pid,sub)) Q:sub=""  D
	.S adrRepProcDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepProc",pid,sub))
	.s objchild=##Class(web.DHCST.SoapModel.Adr.child).%New()
	.s objProp=..GetObjProp("ADRRPTherapMeas",$p(adrRepProcDataList,"^",1))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRPSymptom",$p(adrRepProcDataList,"^",2))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRPOtherExplanation",$p(adrRepProcDataList,"^",3))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRPProcessDesc",$p(adrRepProcDataList,"^",4))
	.d objchild.prop.Insert(objProp)
	.d objchildren.child.Insert(objchild)
	d adrReportObj.children.Insert(objchildren)
	///药品信息
	S objchildren=##class(web.DHCST.SoapModel.Adr.children).%New()
	S objchildren.name="Drugs"
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDrgItm",pid,sub)) Q:sub=""  D
	.S adrRepDrgItmDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDrgItm",pid,sub))
	.s objchild=##Class(web.DHCST.SoapModel.Adr.child).%New()
	.s objProp=..GetObjProp("ADRRDIType",$p(adrRepDrgItmDataList,"^",1))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIType_CODE",$p(adrRepDrgItmDataList,"^",2))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIApprDocu",$p(adrRepDrgItmDataList,"^",3))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIGoodsName",$p(adrRepDrgItmDataList,"^",4))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIGeneric",$p(adrRepDrgItmDataList,"^",6))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIGeneric_CODE",$p(adrRepDrgItmDataList,"^",5))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIPhForm",$p(adrRepDrgItmDataList,"^",8))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIPhForm_CODE",$p(adrRepDrgItmDataList,"^",7))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIManf",$p(adrRepDrgItmDataList,"^",10))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIManf_CODE",$p(adrRepDrgItmDataList,"^",9))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIProductNo",$p(adrRepDrgItmDataList,"^",11))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIDosage",$p(adrRepDrgItmDataList,"^",12))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIDosUom",$p(adrRepDrgItmDataList,"^",14))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIDosUom_CODE",$p(adrRepDrgItmDataList,"^",13))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIInstruc",$p(adrRepDrgItmDataList,"^",16))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIInstruc_CODE",$p(adrRepDrgItmDataList,"^",15))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIFreq",$p(adrRepDrgItmDataList,"^",18))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIFreq_CODE",$p(adrRepDrgItmDataList,"^",17))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIStartDate",$p(adrRepDrgItmDataList,"^",19))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIStartTime",$p(adrRepDrgItmDataList,"^",20))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIEndDate",$p(adrRepDrgItmDataList,"^",21))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIEndTime",$p(adrRepDrgItmDataList,"^",22))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIReason",$p(adrRepDrgItmDataList,"^",23))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIReason_CODE",$p(adrRepDrgItmDataList,"^",24))
	.d objchild.prop.Insert(objProp)
	.s objProp=..GetObjProp("ADRRDIReasonElse",$p(adrRepDrgItmDataList,"^",25))
	.d objchild.prop.Insert(objProp)
	.d objchildren.child.Insert(objchild)
	d adrReportObj.children.Insert(objchildren)	
	S Status=adrReportObj.XMLExportToString(.Xml)
	d ..killTmpGlobal(pid)
	Q Xml
	
ErrorMsg
	i $g(pid)'="" d ..killTmpGlobal(pid)
	q "-99^"_"程序异常"
}

/// Descript: 	取属性类
/// Input：		属性名称，属性值
/// Output：	web.DHCST.SoapModel.Adr.DataProperty
ClassMethod GetObjProp(sName As %String, value As %String, obj As web.DHCST.SoapModel.Adr.data) As web.DHCST.SoapModel.Adr.DataProperty
{
	s objProp=##Class(web.DHCST.SoapModel.Adr.DataProperty).%New()
	s objProp.name=sName
	s objProp.value=value
	q objProp
}

/// Descript:不良反应报告
/// w ##class(web.DHCST.SoapMethod.AdrReportService).getAdrReportXML(85)
ClassMethod getAdrReportXMLOLD(adrrRepID As %String) As %String
{
	//S $zt="ErrorMsg"
	S Xml=""
	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S adrReportObj=##class(web.DHCST.SoapModel.AdrReport).%New()
	S adrReportStr=##class(web.DHCST.SoapMethod.AdrReportService).getAdrRepInfo(pid,adrrRepID)
	Q:adrReportStr="" "-1^取数据错误"

	S adrReportObj.ADRRID=$p(adrReportStr,"^",1)		   ///报告ID
	S adrReportObj.ADRRCode=$p(adrReportStr,"^",2)         ///报告编码
	S adrReportObj.ADRRDate=$p(adrReportStr,"^",3)         ///报告日期
	S adrReportObj.ADRRPriority=$p(adrReportStr,"^",4)     ///首次报告
	S adrReportObj.ADRRPriorityCode=$p(adrReportStr,"^",5) ///首次报告代码
	S adrReportObj.ADRRRepType=$p(adrReportStr,"^",6)      ///报告类型
	S adrReportObj.ADRRRepTypeCode=$p(adrReportStr,"^",7)  ///报告类型代码
	S adrReportObj.ADRRDeptType=$p(adrReportStr,"^",8)     ///报告单位类型
	S adrReportObj.ADRRDeptTypeCode=$p(adrReportStr,"^",9) ///报告单位类型代码
	S adrReportObj.ADRRDeptElse=$p(adrReportStr,"^",10)     ///报告单位其它类型描述
	S adrReportObj.ADRRPatName=$p(adrReportStr,"^",11)      ///患者姓名
	S adrReportObj.ADRRPatSex=$p(adrReportStr,"^",12)       ///性别
	S adrReportObj.ADRRPatSexCode=$p(adrReportStr,"^",13)   ///性别代码
	S adrReportObj.ADRRPatAge=$p(adrReportStr,"^",14)       ///年龄
	S adrReportObj.ADRRPatDOB=$p(adrReportStr,"^",15)       ///出生日期
	S adrReportObj.ADRRPatNation=$p(adrReportStr,"^",16)    ///民族
	S adrReportObj.ADRRPatNationCode=$p(adrReportStr,"^",17) ///民族代码
	S adrReportObj.ADRRPatWeight=$p(adrReportStr,"^",18)     ///体重
	S adrReportObj.ADRRPatContact=$p(adrReportStr,"^",19)    ///联系方式
	S adrReportObj.ADRRPatMedNo=$p(adrReportStr,"^",20)      ///病历号
	S adrReportObj.ADRREventHistory=$p(adrReportStr,"^",21)  ///既往药品不良反应事件
	S adrReportObj.ADRREventHistoryCode=$p(adrReportStr,"^",22)  ///既往药品不良反应事件代码
	S adrReportObj.ADRREventHistDesc=$p(adrReportStr,"^",23)     ///既往药品不良反应事件
	S adrReportObj.ADRREventFamily=$p(adrReportStr,"^",24)       ///家族药品不良反应事件
	S adrReportObj.ADRREventFamilyCode=$p(adrReportStr,"^",25)   ///家族药品不良反应事件代码
	S adrReportObj.ADRREventFamiDesc=$p(adrReportStr,"^",26)     ///家族药品不良反应事件
	S adrReportObj.ADRRDateOccu=$P(adrReportStr,"^",27)          ///事件发生日期
	S adrReportObj.ADRRResult=$P(adrReportStr,"^",28)            ///事件的结果
	S adrReportObj.ADRRResultCode=$P(adrReportStr,"^",29)    ///事件的结果代码
	S adrReportObj.ADRRResultDesc=$P(adrReportStr,"^",30)    ///事件的结果描述
	S adrReportObj.ADRRDateResult=$P(adrReportStr,"^",31)    ///好转(死亡)日期
	S adrReportObj.ADRRTimeResult=$P(adrReportStr,"^",32)    ///好转(死亡)时间
	S adrReportObj.ADRRStopResult=$P(adrReportStr,"^",33)    ///停药后是否减轻
	S adrReportObj.ADRRStopResultCode=$P(adrReportStr,"^",34)    ///停药后是否减轻代码
	S adrReportObj.ADRRTakingAgain=$P(adrReportStr,"^",35)       ///再次使用时是否再次出现同样反应
	S adrReportObj.ADRRTakingAgainCode=$P(adrReportStr,"^",36)   ///再次使用时是否再次出现同样反应代码
	S adrReportObj.ADRREffectOfTreatment=$P(adrReportStr,"^",37)       ///对原疾病的影响
	S adrReportObj.ADRREffectOfTreatmentCode=$P(adrReportStr,"^",38)   ///对原疾病的影响代码
	S adrReportObj.ADRRCommentOfUser=$P(adrReportStr,"^",39)     	  ///关联性评价之报告人评价
	S adrReportObj.ADRRCommentOfUserCode=$P(adrReportStr,"^",40)       ///关联性评价之报告人评价代码
	S adrReportObj.ADRRUserOfReport=$P(adrReportStr,"^",41)      ///报告人评价签字
	S adrReportObj.ADRRUserOfReportCode=$P(adrReportStr,"^",42)  ///报告人评价签字代码
	S adrReportObj.ADRRCommentOfDept=$P(adrReportStr,"^",43)     ///关联性评价之报告单位评价
	S adrReportObj.ADRRCommentOfDeptCode=$P(adrReportStr,"^",44) ///关联性评价之报告单位评价代码
	S adrReportObj.ADRRDeptOfReport=$P(adrReportStr,"^",45)      ///报告单位评价签字
	S adrReportObj.ADRRTelephone=$P(adrReportStr,"^",46)         ///报告人联系电话
	S adrReportObj.ADRRCareerOfRepUser=$P(adrReportStr,"^",47)   ///报告人职业
	S adrReportObj.ADRRCareerOfRepUserCode=$P(adrReportStr,"^",48)    	///报告人职业代码
	S adrReportObj.ADRRCareerOfRepElse=$P(adrReportStr,"^",49)   		///报告人职业
	S adrReportObj.ADRREmailOfRepUser=$P(adrReportStr,"^",50)   	     	///报告人邮箱
	S adrReportObj.ADRRLocOfReporter=$P(adrReportStr,"^",51)          	///报告人所属科室
	S adrReportObj.ADRRLocOfReporterCode=$P(adrReportStr,"^",52) 		///报告人所属科室代码
	S adrReportObj.ADRRProTitleOfReporter=$P(adrReportStr,"^",53)        ///报告人职称
	S adrReportObj.ADRRProTitleOfReporterCode=$P(adrReportStr,"^",54)    ///报告人职称代码
	S adrReportObj.ADRRPosOfReporter=$P(adrReportStr,"^",55)             ///报告人职务
	S adrReportObj.ADRRWishes=$P(adrReportStr,"^",56)                    ///填报意愿
	S adrReportObj.ADRRWishesCode=$P(adrReportStr,"^",57)                ///填报意愿代码
	S adrReportObj.ADRRDeptName=$P(adrReportStr,"^",58)                  ///报告单位名称
	S adrReportObj.ADRRDeptContacts=$P(adrReportStr,"^",59)              ///报告单位联系人
	S adrReportObj.ADRRDeptTel=$P(adrReportStr,"^",60)                   ///报告单位联系电话
	S adrReportObj.ADRRRemark=$P(adrReportStr,"^",61)                    ///备注

	///患者相关重要信息
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepImpInfo",pid,sub)) Q:sub=""  D
	.S adrRepImpDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepImpInfo",pid,sub))
	.S adrRepImpInfoObj=##class(web.DHCST.SoapModel.AdrRepImpInfo).%New()
	.S adrRepImpInfoObj.ADRRIADRII=$p(adrRepImpDataList,"^",1)
	.S adrRepImpInfoObj.ADRRIADRIICODE=$p(adrRepImpDataList,"^",2)
	.S adrRepImpInfoObj.ADRRIADRIIElse=$p(adrRepImpDataList,"^",3)
	.D adrReportObj.PatImpo.Insert(adrRepImpInfoObj)

	///不良反应事件
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepEvent",pid,sub)) Q:sub=""  D
	.S adrRepEvtDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepEvent",pid,sub))
	.S adrRepEvtObj=##class(web.DHCST.SoapModel.AdrRepEvent).%New()
	.S adrRepEvtObj.ADDREVENT=$p(adrRepEvtDataList,"^",1)
	.S adrRepEvtObj.ADDREVENTCODE=$p(adrRepEvtDataList,"^",2)
	.S adrRepEvtObj.ADDREVENTElse=$p(adrRepEvtDataList,"^",3)
	.B  ////XXX
	.//D adrReportObj.Event.Insert(adrRepEvtObj)

	///原患疾病
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDiag",pid,sub)) Q:sub=""  D
	.S adrRepDiagDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDiag",pid,sub))
	.S adrRepDiagObj=##class(web.DHCST.SoapModel.AdrRepDiag).%New()
	.S adrRepDiagObj.ADDRDICD=$p(adrRepDiagDataList,"^",1)
	.S adrRepDiagObj.ADDRDICDCODE=$p(adrRepDiagDataList,"^",2)
	.S adrRepDiagObj.ADDRDICDElse=$p(adrRepDiagDataList,"^",3)
	.D adrReportObj.Diag.Insert(adrRepDiagObj)

	///反应过程
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepProc",pid,sub)) Q:sub=""  D
	.S adrRepProcDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepProc",pid,sub))
	.S adrRepProcObj=##class(web.DHCST.SoapModel.AdrRepProc).%New()
	.S adrRepProcObj.ADRRPTherapMeas=$p(adrRepProcDataList,"^",1)
	.S adrRepProcObj.ADRRPSymptom=$p(adrRepProcDataList,"^",2)
	.S adrRepProcObj.ADRRPOtherExplanation=$p(adrRepProcDataList,"^",3)
	.S adrRepProcObj.ADRRPProcessDesc=$p(adrRepProcDataList,"^",4)
	.//D adrReportObj.Proc.Insert(adrRepProcObj)

	///药品信息
	S sub=""
	F  S sub=$o(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDrgItm",pid,sub)) Q:sub=""  D
	.S adrRepDrgItmDataList=$g(^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDrgItm",pid,sub))
	.S adrRepDrgItmObj=##class(web.DHCST.SoapModel.AdrRepDrugItm).%New()
	.S adrRepDrgItmObj.ADRRDIType=$p(adrRepDrgItmDataList,"^",1)
	.S adrRepDrgItmObj.ADRRDITypeCODE=$p(adrRepDrgItmDataList,"^",2)
	.S adrRepDrgItmObj.ADRRDIApprDocu=$p(adrRepDrgItmDataList,"^",3)
	.S adrRepDrgItmObj.ADRRDIGoodsName=$p(adrRepDrgItmDataList,"^",4)
	.S adrRepDrgItmObj.ADRRDIGeneric=$p(adrRepDrgItmDataList,"^",5)
	.S adrRepDrgItmObj.ADRRDIGenericCODE=$p(adrRepDrgItmDataList,"^",6)
	.S adrRepDrgItmObj.ADRRDIPhForm=$p(adrRepDrgItmDataList,"^",7)
	.S adrRepDrgItmObj.ADRRDIPhFormCODE=$p(adrRepDrgItmDataList,"^",8)
	.S adrRepDrgItmObj.ADRRDIManf=$p(adrRepDrgItmDataList,"^",9)
	.S adrRepDrgItmObj.ADRRDIManfCODE=$p(adrRepDrgItmDataList,"^",10)
	.S adrRepDrgItmObj.ADRRDIProductNo=$p(adrRepDrgItmDataList,"^",11)
	.S adrRepDrgItmObj.ADRRDIDosage=$p(adrRepDrgItmDataList,"^",12)
	.S adrRepDrgItmObj.ADRRDIDosUom=$p(adrRepDrgItmDataList,"^",13)
	.S adrRepDrgItmObj.ADRRDIDosUomCODE=$p(adrRepDrgItmDataList,"^",14)
	.S adrRepDrgItmObj.ADRRDIInstruc=$p(adrRepDrgItmDataList,"^",15)
	.S adrRepDrgItmObj.ADRRDIInstrucCODE=$p(adrRepDrgItmDataList,"^",16)
	.S adrRepDrgItmObj.ADRRDIFreq=$p(adrRepDrgItmDataList,"^",17)
	.S adrRepDrgItmObj.ADRRDIFreqCODE=$p(adrRepDrgItmDataList,"^",18)
	.S adrRepDrgItmObj.ADRRDIStartDate=$p(adrRepDrgItmDataList,"^",19)
	.S adrRepDrgItmObj.ADRRDIStartTime=$p(adrRepDrgItmDataList,"^",20)
	.S adrRepDrgItmObj.ADRRDIEndDate=$p(adrRepDrgItmDataList,"^",21)
	.S adrRepDrgItmObj.ADRRDIEndTime=$p(adrRepDrgItmDataList,"^",22)
	.S adrRepDrgItmObj.ADRRDIReason=$p(adrRepDrgItmDataList,"^",23)
	.S adrRepDrgItmObj.ADRRDIReasonCODE=$p(adrRepDrgItmDataList,"^",24)
	.S adrRepDrgItmObj.ADRRDIReasonElse=$p(adrRepDrgItmDataList,"^",25)
	.D adrReportObj.Drugs.Insert(adrRepDrgItmObj)

	S Status=adrReportObj.XMLExportToString(.Xml)
	d ..killTmpGlobal(pid)
	Q Xml
	
ErrorMsg
	i $g(pid)'="" d ..killTmpGlobal(pid)
	q "-99^"_"程序异常"
}

/// Descript:获取报告信息
ClassMethod getAdrRepInfo(pid As %String, adrRepID As %String) As %String
{
	//N (pid,adrRepID)
	//S pid=..NewPid()
	Q:'$d(^DHCPHADRR(adrRepID)) ""
	S adrRepNo=$p(^DHCPHADRR(adrRepID),"^",1)       //编号
	S adrRepDate=$p(^DHCPHADRR(adrRepID),"^",2) 	//日期
	S:adrRepDate'="" adrRepDate=$zd(adrRepDate,3)
	S adrRepPriCode=$p(^DHCPHADRR(adrRepID),"^",3)      //优先级
	S adrRepPri=$S(adrRepPriCode="10":"首次报告",adrRepPriCode="11":"跟踪报告")
	S adrRepTypeCode=$p(^DHCPHADRR(adrRepID),"^",4)     //报告类型
	S adrRepType=$S(adrRepTypeCode="10":"新的",adrRepTypeCode="11":"严重",adrRepTypeCode="12":"一般")
	S adrrDeptTypeCode=$p(^DHCPHADRR(adrRepID),"^",5)   //科室类型
	S adrrDeptType=$S(adrrDeptTypeCode="10":"医疗机构",adrrDeptTypeCode="11":"经营企业",adrrDeptTypeCode="12":"生产企业",adrrDeptTypeCode="13":"个人",adrrDeptTypeCode="99":"其它")
	S adrrDeptElse=$p(^DHCPHADRR(adrRepID),"^",6)   //科室描述
	
	S adrrPatID=$p(^DHCPHADRR(adrRepID),"^",7)      //病人ID
	S adrrPatName=$p(^DHCPHADRR(adrRepID),"^",8)    //姓名
	S adrrPatSexID=$p(^DHCPHADRR(adrRepID),"^",9)   //性别
	S adrrPatSex=$p(^CT("SEX",adrrPatSexID),"^",2)
	S adrrPatSexCode=$p(^CT("SEX",adrrPatSexID),"^",1)                     //性别代码
	S adrrPatAge=$p(^DHCPHADRR(adrRepID),"^",10)    //年龄
	S adrrPatDOB=$p(^DHCPHADRR(adrRepID),"^",11)    //出生日期
	i adrrPatDOB'="" s adrrPatDOB=$zd(adrrPatDOB,3)
	S adrrPatNation=$p(^DHCPHADRR(adrRepID),"^",12) //民族
	s adrrPatNationCode=""
	i adrrPatNation'="" d
	.s adrrPatNationCode=$p($g(^CT("NAT",adrrPatNation)),"^",1)
	.S adrrPatNation=$p($g(^CT("NAT",adrrPatNation)),"^",2)               //民族代码
	S adrrPatWeight=$p(^DHCPHADRR(adrRepID),"^",13) //体重
	S adrrPatContact=$p(^DHCPHADRR(adrRepID),"^",14) //联系方式
	S adrrPatMedNo=$p(^DHCPHADRR(adrRepID),"^",15)   //病历号
	
	S adrrEvtHisCode=$p(^DHCPHADRR(adrRepID),"^",16)     //既往药品不良反应/事件
	S adrrEvtHis=$S(adrrEvtHisCode="10":"有",adrrEvtHisCode="11":"无",adrrEvtHisCode="99":"不详",1:"不详")
	S adrrEvtHisDesc=$p(^DHCPHADRR(adrRepID),"^",17) //既往药品不良反应/事件描述
	S adrrEvtFamCode=$p(^DHCPHADRR(adrRepID),"^",18)     //家族药品不良反应/事件
	S adrrEvtFam=$S(adrrEvtFamCode="10":"有",adrrEvtFamCode="11":"无",adrrEvtFamCode="99":"不详",1:"不详")
	S adrrEvtFamDesc=$p(^DHCPHADRR(adrRepID),"^",19) //家族药品不良反应/事件描述
	S adrrEvtDateOcc=$p(^DHCPHADRR(adrRepID),"^",21) //事件发生日期
	i adrrEvtDateOcc'="" s adrrEvtDateOcc=$zd(adrrEvtDateOcc,3)
	S adrrEvtResCode=$p(^DHCPHADRR(adrRepID),"^",22)     //事件结果
	S adrrEvtRes=$S(adrrEvtResCode="10":"痊愈",adrrEvtResCode="11":"好转",adrrEvtResCode="12":"未好转",adrrEvtResCode="12":"未好转",adrrEvtResCode="13":"有后疑症",adrrEvtResCode="14":"死亡",adrrEvtResCode="99":"不详",1:"不详")
	S adrrEvtResDesc=$p(^DHCPHADRR(adrRepID),"^",23) //事件结果描述
	
	S adrrEvtDRes=$p(^DHCPHADRR(adrRepID),"^",24)      //死亡/好转 日期
	S adrrEvtTRes=$p(^DHCPHADRR(adrRepID),"^",25) 	   //死亡/好转 时间
	S adrrEvtSResCode=$p(^DHCPHADRR(adrRepID),"^",26)      //是否停止使用
	S adrrEvtSRes=$S(adrrEvtSResCode="10":"是",adrrEvtSResCode="11":"否",adrrEvtSResCode="99":"不详",adrrEvtSResCode="12":"未停药或未减量",1:"不详")
	S adrrEvtTakAgCode=$p(^DHCPHADRR(adrRepID),"^",27)     //是否再次使用
	S adrrEvtTakAg=$S(adrrEvtTakAgCode="10":"是",adrrEvtTakAgCode="11":"否",adrrEvtTakAgCode="99":"不详",adrrEvtTakAgCode="12":"未再使用",1:"不详")
	S adrrEvtEffCode=$p(^DHCPHADRR(adrRepID),"^",28)       //对原患疾病的影响
	S adrrEvtEff=$S(adrrEvtEffCode="10":"不明显",adrrEvtEffCode="11":"病程延长",adrrEvtEffCode="12":"病情加重",adrrEvtEffCode="13":"导致后疑症",adrrEvtEffCode="14":"导致死亡",1:"不详")
	S adrrEvtCUserCode=$p(^DHCPHADRR(adrRepID),"^",29)     //报告人评价
	S adrrEvtCUser=$S(adrrEvtCUserCode="10":"肯定",adrrEvtCUserCode="11":"很可能",adrrEvtCUserCode="12":"可能",adrrEvtCUserCode="13":"可能无关",adrrEvtCUserCode="14":"可能无关",adrrEvtCUserCode="15":"无法评价",1:"不详")
	S adrrEvtRepUser=$p(^DHCPHADRR(adrRepID),"^",30)   //报告人
	S adrrEvtRepUserCode=adrrEvtRepUser
	S adrrEvtCDeptCode=$p(^DHCPHADRR(adrRepID),"^",31)     //报告单位评价
	S adrrEvtCDept=$S(adrrEvtCDeptCode="10":"肯定",adrrEvtCDeptCode="11":"很可能",adrrEvtCDeptCode="12":"可能",adrrEvtCDeptCode="13":"可能无关",adrrEvtCDeptCode="14":"可能无关",adrrEvtCDeptCode="15":"无法评价",1:"不详")
	S adrrEvtRepDept=$p(^DHCPHADRR(adrRepID),"^",32)   //单位签字
	S adrrEvtRepDeptCode=adrrEvtRepDept
	
	S adrrEvtUserOfRepTel=$p(^DHCPHADRR(adrRepID),"^",33) //电话
	S adrrEvtCarOfRepUserCode=$p(^DHCPHADRR(adrRepID),"^",34) //职业
	S adrrEvtCarOfRepUser=$S(adrrEvtCarOfRepUserCode="10":"医生",adrrEvtCarOfRepUserCode="11":"药师",adrrEvtCarOfRepUserCode="12":"护士",adrrEvtCarOfRepUserCode="99":"其它",1:"其它")
	S adrrEvtCarOfRepElse=$p(^DHCPHADRR(adrRepID),"^",35) //其他
	S adrrEvtEOfRepUser=$p(^DHCPHADRR(adrRepID),"^",36)   //E-mail
	S adrrEvtProDeptName=$p(^DHCPHADRR(adrRepID),"^",41)  //报告单位
	S adrrEvtProDeptCon=$p(^DHCPHADRR(adrRepID),"^",42)   //单位联系人
	S adrrEvtProDeptTel=$p(^DHCPHADRR(adrRepID),"^",43)   //单位电话
	S adrrEvtRemark=$p(^DHCPHADRR(adrRepID),"^",44) //备注

	S adrRepNew=$p(^DHCPHADRR(adrRepID),"^",46)     //是否新的
	S adrrRepTSDesc=$p(^DHCPHADRR(adrRepID),"^",47) //严重情形描述
	
	d ..getAdrRepDrgItm(pid,adrRepID)    //药品信息
	d ..getAdrRepDiag(pid,adrRepID)      //原患疾病
	d ..getAdrRepEvent(pid,adrRepID)     //不良反应事件
	d ..getAdrRepImpInfo(pid,adrRepID)   //相关重要信息
	d ..getAdrRepProc(pid,adrRepID)      //相关重要信息
	
	S adrRepDataList=adrRepID_"^"_adrRepNo_"^"_adrRepDate_"^"_adrRepPri_"^"_adrRepPriCode_"^"_adrRepType_"^"_adrRepTypeCode_"^"_adrrDeptType_"^"_adrrDeptTypeCode_"^"_adrrDeptElse
	S adrRepDataList=adrRepDataList_"^"_adrrPatName_"^"_adrrPatSex_"^"_adrrPatSexCode_"^"_adrrPatAge_"^"_adrrPatDOB_"^"_adrrPatNation_"^"_adrrPatNationCode_"^"_adrrPatWeight_"^"_adrrPatContact_"^"_adrrPatMedNo
	S adrRepDataList=adrRepDataList_"^"_adrrEvtHis_"^"_adrrEvtHisCode_"^"_adrrEvtHisDesc_"^"_adrrEvtFam_"^"_adrrEvtFamCode_"^"_adrrEvtFamDesc_"^"_adrrEvtDateOcc_"^"_adrrEvtRes_"^"_adrrEvtResCode_"^"_adrrEvtResDesc
	S adrRepDataList=adrRepDataList_"^"_adrrEvtDRes_"^"_adrrEvtTRes_"^"_adrrEvtSRes_"^"_adrrEvtSResCode_"^"_adrrEvtTakAg_"^"_adrrEvtTakAgCode_"^"_adrrEvtEff_"^"_adrrEvtEffCode_"^"_adrrEvtCUser_"^"_adrrEvtCUserCode_"^"_adrrEvtRepUser_"^"_adrrEvtRepUserCode
	S adrRepDataList=adrRepDataList_"^"_adrrEvtCDept_"^"_adrrEvtCDeptCode_"^"_adrrEvtRepDept_"^"_adrrEvtUserOfRepTel_"^"_adrrEvtCarOfRepUser_"^"_adrrEvtCarOfRepUserCode_"^"_adrrEvtCarOfRepElse
	S adrRepDataList=adrRepDataList_"^"_adrrEvtEOfRepUser_"^"_adrrEvtProDeptName_"^"_adrrEvtProDeptCon_"^"_adrrEvtProDeptTel_"^"_adrrEvtRemark_"^"_adrRepNew_"^"_adrrRepTSDesc


 Q adrRepDataList
}

/// Descript:获取原患疾病
ClassMethod getAdrRepDiag(pid, adrRepID) As %String
{
	//N (pid,adrRepID)
	S num="0"
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRD",ch)) Q:ch=""  D
	.S adrEvtDiagDr=$p(^DHCPHADRR(adrRepID,"ADRRD",ch),"^",1)
	.S adrEvtDiagDesc=$p(^DHCPHADRR(adrRepID,"ADRRD",ch),"^",2) //描述
	.S num=num+1
	.S ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDiag",pid,num)=adrEvtDiagDr_"^"_adrEvtDiagDesc
	Q ""
}

/// Descript:获取不良反应事件
ClassMethod getAdrRepEvent(pid, adrRepID) As %String
{
	//N (pid,adrRepID)
	S num="0"
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRE",ch)) Q:ch=""  D
	.S adrEvtDr=$p(^DHCPHADRR(adrRepID,"ADRRE",ch),"^",1)
	.S adrEvtRepDesc=$p(^DHCPHADRR(adrRepID,"ADRRE",ch),"^",2) //描述
	.
	.S num=num+1
	.S ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepEvent",pid,num)=adrEvtDr_"^"_adrEvtRepDesc
	Q ""
}

/// Descript:获取不良反应过程描述
ClassMethod getAdrRepProc(pid, adrRepID) As %String
{
	//N (pid,adrRepID)
	S num="0"
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRP",ch)) Q:ch=""  D
	.S TherapMeas=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",1)  //治疗措施
	.S Symptom=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",2)     //症状、体征、临床检验
	.S OtherExplanation=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",3) //其它说明内容
	.S ProcessDesc=$p(^DHCPHADRR(adrRepID,"ADRRP",ch),"^",4) //过程描述
	.
	.S num=num+1
	.S ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepProc",pid,num)=TherapMeas_"^"_Symptom_"^"_OtherExplanation_"^"_ProcessDesc
	Q ""
}

/// Descript:获取相关重要信息
ClassMethod getAdrRepImpInfo(pid, adrRepID) As %String
{
	//N (pid,adrRepID)
	S num="0"
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRII",ch)) Q:ch=""  D
	.S adrRepIIDr=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",1)
	.S adrRepIIDesc=$p(^DHCPHADRR(adrRepID,"ADRRII",ch),"^",2) //描述
	.
	.S num=num+1
	.S ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepImpInfo",pid,num)=adrRepIIDr_"^"_adrRepIIDesc

	Q ""
}

/// Descript:获取药品信息
/// w ##class(web.DHCSTPHCMADRREPORT).getAdrRepDrgItm("30","1")
ClassMethod getAdrRepDrgItm(pid As %String, adrRepID As %String) As %String
{
	//N (pid,adrRepID)
	d ..killTmpGlobal(pid)

	S num=0
	S ch=""
	F  S ch=$o(^DHCPHADRR(adrRepID,"ADRRDI",ch)) Q:ch=""  D
	.S type=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",1)     //类型
	.S typeCode=$S(type="10":"怀疑",type="11":"并用",1:"")
	.S apprdocu=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",3)  //批准文号
	.S phcddr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",4)    //药学项ID
	.S goodsname=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",5) //商品名
	.S genericdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",6) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",7)    //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S manfdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",8)    //产地
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S productno=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",9) //批号
	.S dosage=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",10)   //剂量
	.S dosageuomdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",11) //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.S instrucdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",12)   //用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.S freqdr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",13)      //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.S startdate=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",14)   //开始日期
	.S:startdate'="" startdate=$zd(startdate,3)
	.S starttime=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",15)  //开始时间
	.S:starttime'="" starttime=$zt(starttime,1)
	.S enddate=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",16)    //结束日期
	.S:enddate'="" enddate=$zd(enddate,3)
	.S endtime=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",17)    //结束时间
	.S:endtime'="" endtime=$zt(endtime,1)
	.S reasondr=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",18)   //原因ID
	.S reasonCode="",reason=""
	.i reasondr'="" S reasonCode=$p(^DHCPHADRRM(reasondr),"^",1) 
	.i reasondr'="" S reason=$p(^DHCPHADRRM(reasondr),"^",2) 
	.S reasonElse=$p(^DHCPHADRR(adrRepID,"ADRRDI",ch),"^",19)   //手写原因
	.S ListData=type_"^"_typeCode_"^"_apprdocu_"^"_goodsname_"^"_genericdr_"^"_$g(genenic)_"^"_formdr_"^"_$g(form)_"^"_manfdr_"^"_$g(manf)_"^"_productno
	.S ListData=ListData_"^"_dosage_"^"_dosageuomdr_"^"_$g(doseuom)_"^"_instrucdr_"^"_instru_"^"_freqdr_"^"_freq
	.S ListData=ListData_"^"_startdate_"^"_starttime_"^"_enddate_"^"_endtime_"^"_reason_"^"_reasonCode_"^"_reasonElse
	.
	.S num=num+1
	.S ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDrgItm",pid,num)=ListData
	Q ""
}

/// Descript:不良反应报告审批
ClassMethod auditAdrReport(adrRepAuditdataList As %String) As %String
{
	//n (adrRepAuditdataList)
	q:adrRepAuditdataList="" ""
	s adrrRepID=$p(adrRepAuditdataList,"^",1)
	
	ts
	s ret=##class(web.DHCSTPHCMADRREPORT).UpdAdrRep(adrrRepID,adrRepAuditdataList)
	//&SQL(update DHC_PHAdrReport set ADRR_CurStatus_DR=:adrAudStatusDr WHERE ADRR_RowID=:adrrRepID)
	i ret'=0 tro
	q:ret'=0 ret

	s retVal=##class(web.DHCSTPHCMADRREPORT).InsAdrRepAudit(adrrRepID,adrRepAuditdataList)
	i retVal'=0 tro
	q:retVal'=0 retVal
	tc
	
	q 0
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDiag",pid)
	k ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepEvent",pid)
	k ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepImpInfo",pid)
	k ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepProc",pid)
	k ^TMP("DHCST","web.DHCST.SoapMethod.AdrReportService","getAdrRepDrgItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("AdrReportService"))
}

Storage Default
{
<Data name="AdrReportServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCST.S865.AdrReportSeE93ED</DataLocation>
<DefaultData>AdrReportServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCST.S865.AdrReportSeE93ED</IdLocation>
<IndexLocation>^web.DHCST.S865.AdrReportSeE93EI</IndexLocation>
<StreamLocation>^web.DHCST.S865.AdrReportSeE93ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
