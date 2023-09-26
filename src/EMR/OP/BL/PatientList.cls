/// 名称：EMR.OP.BL.PatientList
/// 描述：门急诊患者列表业务相关
/// 编写者：huhao
/// 编写日期：2021-7-19
/// 产品组：电子病历产品组
Class EMR.OP.BL.PatientList Extends EMR.OP.COM.ActionBase [ Not ProcedureBlock ]
{

/// Creator:    huhao
/// CreateDate: 2021-07-19
/// Desc:       获取患者列表
/// Input:      argInJson  	命令参数 {"action":"GET_PATIENTLIST_BYUSERID","params":{"locID":"6","userCode":"YS01","startDate":"2019-04-01","endDate":"2020-04-01"},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 成功 1 失败 -1
///            	argOutData 	返回json格式数据 
/// Debug:		w ##class(EMR.OP.BL.PatientList).OutPatientlist("6",userId,"","","","","2019-04-01","2020-04-01","","","","","RegQue",1,20)
ClassMethod GetPatientList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s docId = argInJson.params.locID
	s userCode = argInJson.params.userCode
	s userId = $o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(userCode,"U"),""))
	s startTime = argInJson.params.startDate
	s endTime = argInJson.params.endDate
	s current = argInJson.params.current
	s pageSize = argInJson.params.pageSize
	s strRes = ..OutPatientlist("6",userId,"","","","",startTime,endTime,"","","","","RegQue",current,pageSize,.argOutData)
	//s sreRes= ##class(DHCDoc.OPDoc.PatientList).OutPatientList(docId,userId,"","","","",startTime,endTime,"","","","","RegQue")
	if (strRes = "1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-1")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未查询到相关数据",2)	
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}	
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:		得到门诊已处理的业务数据
/// Creator:	huhao
/// CreateDate: 2021-07-19
/// input: 		LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, CheckName
/// output: 	Json数据格式
/// output: 	argoutData:Json格式流数据
/// 			argoutmessage:成功返回 1  失败返回 -1
/// debug： 	w ##class(DHCDoc.OPDoc.PatientList).OutPatientList(docId,userId,"","","","",startTime,endTime,"","","","","RegQue")
ClassMethod OutPatientlist(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "", argCurrent As %String, argPageSize As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resultJson = ##class(%DynamicObject).%New()

	s res = "-1"
	s:argCurrent="" argCurrent=1
	s:argPageSize="" argPageSize=20
	s startIndex = (argCurrent-1)*argPageSize+1
	s endIndex = startIndex+argPageSize-1

	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	s ^tempscl("OutPatientList12")=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue_","_RegQue_","_Consultation_","_MarkID_","_CheckName
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, CheckName)
	s colDefine=##class(DHCDoc.Common.MapIndex).%New()
	s len=rs.GetColumnCount()
	f i=1:1:len {
		d colDefine.add(rs.GetColumnName(i))
		s colDefine.map(rs.GetColumnName(i),"Type")=rs.GetColumnType(i)
	}
	d colDefine.add("DrugsStatus")
	s colDefine.map("DrugsStatus","Type")=10 //varchar
	d colDefine.add("LaboratoryStatus")
	d colDefine.add("InspectStatus")
	d colDefine.add("TreatmentStatus")
	
	s epIndex=colDefine.index("EpisodeID")
	s jsonArr = ##class(%DynamicArray).%New()
	s count=0
	s res =""
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s list=$lb()
		s index=0
		f index=1:1:len{
			s $list(list,index)=rs.GetData(index)
		}
		s EpisodeID=$lg(list,epIndex)
		if EpisodeID'="" {
			d ##class(DHCDoc.OPDoc.PatientList).GetOPHandleStatusData(EpisodeID,"",.list2)
			s $list(list,len+1,len+$ll(list2))=list2
		}
		s count=count+1
		s resF= ##class(EMR.OP.BL.PatientList).Jsonlist(colDefine,list)
		d jsonArr.%Push(resF)
		
	}
	d rs.Close()
	s resultJson.list = jsonArr
	s resultJson.current = argCurrent
	s resultJson.pageSize = argPageSize
	s resultJson.total= count
	d resultJson.%ToJSON(argOutData)
	q "1"
}

/// Desc:		患者信息拼接，json属性字段处理
/// Creator:	huhao
/// CreateDate: 2021-07-19
/// Input: 		单条json格式患者信息
/// Output: 	转化后的json格式患者信息
///  	
/// Debug： 	
ClassMethod Jsonlist(colDef As DHCDoc.Common.MapIndex, list) As %DynamicObject
{
	s len=colDef.count()
	s jsonItem = ##class(%DynamicObject).%New()
	s cou=0
	f i=1:1:len {
		s pro=colDef.get(i)
		s t=$g(colDef.map(pro,"Type"),10)
		s v=$lg(list,i)
		if ( (t=3) ||(t=5)||(t=14)||(t=15)||(t=18) ){
			s:v="" v=0
		}elseif (t=16){
			i ((v=1)||(v="1")||(v="true")) {
				s v="true" 
			}else {
				s v="false"
			}
		}else{
			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,"'","\'")
			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,"""","\""")
 			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,$c(13),"\n")
			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,$c(10),"\r")
			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,$c(2),"<$C2>")
			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,$c(5),"<$C5>")
			s v=##class(DHCDoc.Common.FormatData).ReplaceStr(v,$c(7),"<$C7>")
		}
		if (pro="PatientID")
		{
			s jsonItem.patientID = v
		}
		elseif (pro="EpisodeID")
		{
			s jsonItem.episodeID = v
		}
		elseif (pro="mradm")
		{
			s jsonItem.mradm = v
		}
		elseif (pro="PAPMINO")
		{
			s jsonItem.pAPMINO = v
		}
		elseif (pro="PAPMIName")
		{
			s jsonItem.pAPMIName = v
		}
		elseif (pro="PAPMIDOB")
		{
			s jsonItem.pAPMIDOB = v
		}
		elseif (pro="PAPMISex")
		{
			s jsonItem.pAPMISex = v
		}
		elseif (pro="PAAdmDate")
		{
			s jsonItem.pAAdmDate = v
		}
		elseif (pro="PAAdmTime")
		{
			s jsonItem.pAAdmTime = v
		}
		elseif (pro="PAAdmNo")
		{
			s jsonItem.pAAdmNo = v
		}
		elseif (pro="PAAdmDepCodeDR")
		{
			s jsonItem.pAAdmDepCodeDR = v
		}
		elseif (pro="PAAdmDocCodeDR")
		{
			s jsonItem.pAAdmDocCodeDR = v
		}
		elseif (pro="PAAdmType")
		{
			s jsonItem.pAAdmType = v
		}
		elseif (pro="Hospital")
		{
			s jsonItem.hospital = v
		}
		elseif (pro="PAAdmWard")
		{
			s jsonItem.pAAdmWard = v
		}
		elseif (pro="PAAdmBed")
		{
			s jsonItem.pAAdmBed = v
		}
		elseif (pro="FinancialDischargeFlag")
		{
			s jsonItem.financialDischargeFlag = v
		}
		elseif (pro="MedicalDischargeFlag")
		{
			s jsonItem.medicalDischargeFlag = v
		}
		elseif (pro="FinalDischargeFlag")
		{
			s jsonItem.finalDischargeFlag = v
		}
		elseif (pro="PAAdmReason")
		{
			s jsonItem.pAAdmReason = v
		}
		elseif (pro="DischargeDate")
		{
			s jsonItem.dischargeDate = v
		}
		elseif (pro="RegDoctor")
		{
			s jsonItem.regDoctor = v
		}
		elseif (pro="Diagnosis")
		{
			s jsonItem.diagnosis = v
		}
		elseif (pro="ArrivedDate")
		{
			s jsonItem.arrivedDate = v
		}
		elseif (pro="ArrivedTime")
		{
			s jsonItem.arrivedTime = v
		}
		elseif (pro="LeavedDate")
		{
			s jsonItem.leavedDate = v
		}
		elseif (pro="LeavedTime")
		{
			s jsonItem.leavedTime = v
		}
		elseif (pro="LocSeqNo")
		{
			s jsonItem.locSeqNo = v
		}
		elseif (pro="PAAdmPriority")
		{
			s jsonItem.pAAdmPriority = v
		}
		elseif (pro="WalkStatus")
		{
			s jsonItem.walkStatus = v
		}
		elseif (pro="ConsultRoom")
		{
			s jsonItem.consultRoom = v
		}
		elseif (pro="ConsultArea")
		{
			s jsonItem.consultArea = v
		}
		elseif (pro="PAAdmReasonCode")
		{
			s jsonItem.pAAdmReasonCode = v
		}
		elseif (pro="StatusCode")
		{
			s jsonItem.statusCode = v
		}
		elseif (pro="Age")
		{
			s jsonItem.age = v
		}
		elseif (pro="PriorityCode")
		{
			s jsonItem.priorityCode = v
		}
		elseif (pro="Called")
		{
			s jsonItem.called = v
		}
		elseif (pro="RegDocDr")
		{
			s jsonItem.regDocDr = v
		}
		elseif (pro="TPoliticalLevel")
		{
			s jsonItem.tPoliticalLevel = v
		}
		elseif (pro="TSecretLevel")
		{
			s jsonItem.tSecretLevel = v
		}
		elseif (pro="RegRangeTime")
		{
			s jsonItem.regRangeTime = v
		}
		elseif (pro="RegAdmSource")
		{
			s jsonItem.regAdmSource = v
		}
		elseif (pro="DrugsStatus")
		{
			s jsonItem.drugsStatus = v
		}
		elseif (pro="LaboratoryStatus")
		{
			s jsonItem.laboratoryStatus = v
		}
		elseif (pro="InspectStatus")
		{
			s jsonItem.inspectStatus = v
		}
		elseif (pro="TreatmentStatus")
		{
			s jsonItem.treatmentStatus = v
		}

		s cou=cou+1	

	}
	q jsonItem
}

/// Desc:       获取患者信息
/// Creator:    huhao
/// CreateDate: 2021-07-26
/// Table：     Pa_PatMas
/// Input:      argInJson  	命令参数 {"action":"GET_PATIENTINFO_BYID","params":{"episodeID":"660"},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 成功 1  失败 -1
///            	argOutData 	返回数据 
ClassMethod GetPatientMsg(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorMsg"
    s episodeId=argInJson.params.episodeID
    s current=argInJson.params.current
    s pageSize=argInJson.params.pageSize
    s strRes = ##class(EMR.OP.BL.PatientList).GetOPInfoBar(episodeId,"w50166","",current,pageSize)
   	;s strRes=##class(web.DHCDoc.OP.AjaxInterface).GetOPInfoBar(660,"W50166")
   	d strRes.%ToJSON(argOutData)

	if (strRes '= "")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
ErrorMsg
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:		根据患者列表获取患者信息
/// Creator:	huhao
/// CreateDate:	2021-07-29
/// Input:      EpisodeID(就诊号),CONTEXT,PatientID(住院号),argCurrent(页码),argPageSize(页面大小)
/// OutPut:     Json格式数据
/// Debug：		w ##class(EMR.OP.BL.PatientList).GetOPInfoBar()     
ClassMethod GetOPInfoBar(EpisodeID As %String, CONTEXT As %String, PatientID As %String = "", argCurrent As %String = "", argPageSize As %String = "") As %String
{
	n (EpisodeID,CONTEXT,PatientID,argCurrent,argPageSize)
	s resObj = ##class(%DynamicObject).%New() //最终返回值
	s jsonArrUser = ##class(%DynamicArray).%New()
	s:argCurrent="" argCurrent=1
	s:argPageSize="" argPageSize=20

	s PatInfoBarStr=""
	if (EpisodeID'=""){
		s PAAdmType=$p(^PAADM(EpisodeID),"^",2)
		if PAAdmType="E" {
			;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	 		s StayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
		}
		if PAAdmType="H" s PAAdmType="O" //体检患者按照门诊患者显示
		s PatientID=$p(^PAADM(EpisodeID),"^",1),mradm=$p(^PAADM(EpisodeID),"^",61)
	}else{
		s PAAdmType="O"
		s mradm=""
	}
	s DisplayNum=0
	f  s DisplayNum=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum)) q:DisplayNum=""  d
	.s ID=0,total=DisplayNum
	.f  s ID=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum,ID)) q:ID=""  d
	..s Active=$list(^User.DocCFPatientInfoD(ID),10)
	..q:Active'="1"
	..s paraAdmType=$list(^User.DocCFPatientInfoD(ID),11)
	..i PAAdmType="H" s PAAdmType="O"
	..Q:((PAAdmType="O")||(PAAdmType="I"))&&(PAAdmType'=paraAdmType)
	..Q:(PAAdmType="E")&&(" 1 2 "[(" "_StayStatusFlag_" "))&&(paraAdmType'="IE")
	..Q:(PAAdmType="E")&&(" 1 2 "'[(" "_StayStatusFlag_" "))&&(paraAdmType'="OE")
	..s id=$list(^User.DocCFPatientInfoD(ID),3)
	..s Name=$list(^User.DocCFPatientInfoD(ID),2)
	..s style=$list(^User.DocCFPatientInfoD(ID),6)
	..s Expression=$list(^User.DocCFPatientInfoD(ID),5)
	..s Expression=$tr(Expression,"&","""")
	..s Expression="s result="_Expression
	..X Expression
	..Q:(EpisodeID="")&&(result="") //就诊为空 结果为空 不显示
	..s LinkUrl=$list($g(^User.DocCFPatientInfoD(ID)),7)
	..s LinkUrl=..replaceLinkParams(LinkUrl,EpisodeID,PatientID,mradm)
	..i LinkUrl'="" d
	...s iconHTML="<A HREF=""#"" id='"_id_"' onClick=""websys_lu('"_LinkUrl_"',false,'top=40,left=40');"">"_result_"</A>"
	..e  d
	...if (Name="姓名") d
	....s iconHTML=result,resObj.name=result
	...i (Name="性别") d
	....s iconHTML=result,resObj.sex=result
	...i (Name="年龄") d
	....s iconHTML=result,resObj.age=result
	...i (Name="卡号") d
	....s iconHTML=result,resObj.cardId=result
	...i (Name="费别") d
	....s iconHTML=result,resObj.reason=result
	...i (Name="登记号") d
	....s iconHTML=result,resObj.paadmNo=result
	...i (Name="余额") d
	....s iconHTML=result,resObj.balance=result
	...i (Name="出生日期") d
	....s iconHTML=result,resObj.papBDate=result
	...i (Name="诊断") d
	....s iconHTML=result,resObj.diag=result
	...e  d
	....i Name'="" s iconHTML=Name_":"_result
	..i PatInfoBarStr="" s PatInfoBarStr=iconHTML
	..e  s PatInfoBarStr=PatInfoBarStr_" "_iconHTML
	s resObj.current=argCurrent
	s resObj.pageSize=argPageSize
	s resObj.total=DisplayNum
	q resObj
}

/// Desc:		判断是否处于留观状态
/// Creator:	huhao
/// CreateDate: 2021-7-29
/// Input: 		就诊号
/// Output: 	1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
///  	
/// Debug： 	w ##class(EMR.OP.BL.PatientList).GetStayStatus(467136)
ClassMethod GetStayStatus(Adm) As %String
{
	n (Adm)
	s ii=0
    s rtn=-1
    q:(Adm="") rtn
   
    s Admtype=$p($g(^PAADM(Adm)),"^",2)
    q:(Admtype'="E" ) rtn
    s AdmRea=$p($g(^PAADM(Adm,1)),"^",7)
    q:$g(AdmRea)="" rtn		//PAC_AdmReason收费类型
    s InsurFlag=+$p($g(^PAC("ADMREA",+AdmRea)),"^",9)
	s BedCodeDr=$p($g(^PAADM(Adm)),"^",73)
	;q:(BedCodeDr="")!(BedCodeDr=0) rtn	//	无床位
    s PatAllStatusCode=""
    s PatCurStatusDr=""
	f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",Adm,PatCurStatusDr)) q:(PatCurStatusDr="")  d
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(PatCurStatusDr)),"^",2)
	.q:PatCurStatusCTid=""
	.s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	.s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	.s ii=ii+1
	.i PatAllStatusCode="" d
	..s PatAllStatusCode=PatCurStatusCode
	.e  d
	..s PatAllStatusCode=PatAllStatusCode_"^"_PatCurStatusCode
	
	q:((PatAllStatusCode'["STAY")&&(PatAllStatusCode'["SALVAGE")) rtn  //状态变更中不包含留观或抢救
	
	i (($p(PatAllStatusCode,"^",ii)="STAY")||($p(PatAllStatusCode,"^",ii)="SALVAGE")) s rtn=1   //留观状态,当前为留观或抢救
	e  s rtn=2 //曾经留观	
	q rtn
}

/// Creator:	huhao
/// CreateDate: 2021-07-29
/// Desc:		获取患者性别
/// Debug: 		w ##class(EMR.OP.BL.PatientList).GetPatSex()     
ClassMethod GetPatSex(PatientID As %String) As %String
{
	s PatSex=""
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	if (PatSexDr'="") s PatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
	Q PatSex
}

/// Desc:		字符串替换处理
/// Creator:	huhao
/// CreateDate: 2021-7-29	
/// Debug： 	w ##class(EMR.OP.BL.PatientList).replaceLinkParams(LinkUrl,EpisodeID,PatientID,mradm)
ClassMethod replaceLinkParams(lnk As %String, EpisodeID As %String, PatientID As %String, mradm As %String)
{
	s ret = $replace(lnk,"@patientID",PatientID)
	s ret = $replace(ret,"@episodeID",EpisodeID) 
	s ret = $replace(ret,"@mradm",mradm) 
	Q ret
}

/// Desc:		根据患者列表获取患者信息
/// Creator:	huhao
/// CreateDate:	2021-07-29
/// Input:      EpisodeID(就诊号),CONTEXT,PatientID(住院号),argCurrent(页码),argPageSize(页面大小)
/// OutPut:     Json格式数据
/// Debug：		w ##class(EMR.OP.BL.PatientList).GetOPInfoBar()     
ClassMethod GetOPInfoBar1(EpisodeID As %String, PatientID As %String = "") As %String
{
    s resJson = ##class(%DynamicObject).%New()  //存储信息
	s patientID=""
    if (EpisodeID '= "")
    {
	    s patientID = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	    s resJson.name=##class(EMR.DOC.HISInterface.PatientInfoAssist).Name(patientID)
	    s resJson.sex=##class(EMR.DOC.HISInterface.PatientInfoAssist).Gender(patientID, "")
	    s resJson.age=##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(patientID,EpisodeID,"","")
		s resJson.cardId=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatCardNo(patientID)
		s resJson.reason = ##class(EMR.DOC.HISInterface.PatientInfoAssist).PayType(patientID)
		s resJson.paadmNo=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		s resJson.balance=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetCurrentDeposit(patientID)
		s resJson.papBDate=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatDob(patientID)
		s resJson.diag = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DiagnosInfo(patientID)
		if (resJson.diag '= "")
		{	
			s resJson.diag = $P(resJson.diag,"^",3)
			s resJson.diag = $tr(resJson.diag,"'","\'")
		}
		

	}
	else 
	{
		q "未传入就诊号"
	}
	q resJson
}

}
