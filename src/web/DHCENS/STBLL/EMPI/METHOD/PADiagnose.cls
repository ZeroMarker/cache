Class web.DHCENS.STBLL.EMPI.METHOD.PADiagnose Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PADiagnose).GetDiagnoses("1")
/// Desc:	所有诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述!诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述
ClassMethod GetDiagnoses(argAdmId As %String) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	
	set diagListObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PADiagnoseList).%New()
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	s admDiagTypeCode="",admDiagTypeDesc="",MRDIAUpdateDate="",MRDIAUpdateTime=""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		if (mrdiachildsub'=0) {
		    s admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
	        s:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	        s:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
		    s themrdiachildsub = mrdiachildsub
		    s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
	        if (mricdid="") {
		        set mricdCode=""
		        set mricdDesc=""
		    }
		    else {
		        s mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
		        s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		    }
		    
		    set docId=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",12)
		    s mricdRemark=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1)),"^")
		    set diagObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PADiagnose).%New()
			if docId'="" {
				set diagObj.PADDiagDocCode=$p($g(^SSU("SSUSR",docId)),"^",1)
			}
		    set diagObj.PADDiagId=mainmradmdr_"||"_themrdiachildsub
		    set diagObj.PADDiagCode=mricdCode
		    // MR_Diagnos  表的 MRDIA_DiagStat_DR
		    set diagObj.PADDiagDesc=mricdDesc
		    set diagObj.PADDiagTypeCode=admDiagTypeCode
		    set diagObj.PADRemarks=mricdRemark
		    if admDiagTypeId'="" {
			    set diagObj.PADDiagTypeCode=admDiagTypeCode
		    	set diagObj.PADDiagTypeDesc=admDiagTypeDesc
		    }
		    else {
			    set diagObj.PADDiagTypeCode="-"
		    	set diagObj.PADDiagTypeDesc="-"
		    }
		    set diagObj.PADDiagCategory="1"
		    set MRDIADate=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",7)
		    set MRDIATime=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",8)
		    set:MRDIADate'="" diagObj.PADDiagDate=$zd(MRDIADate,3)
		    set:MRDIATime'="" diagObj.PADDiagTime=$zt(MRDIATime)
		    set MRDIAUpdateDate=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",19)
		    set MRDIAUpdateTime=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",20)
		    d diagListObj.diagnoses.Insert(diagObj)
		}
	}
	if diagListObj.diagnoses.Count()>0 {
		set diagListObj.PAADMVisitNumber=argAdmId
		set patId=$p(^PAADM(argAdmId),"^",1)
		set AdmTypeCode=$p($g(^PAADM(argAdmId)),"^",2)
		set diagListObj.PAADMEncounterTypeCode=AdmTypeCode
		set diagListObj.PATPatientID=$p($g(^PAPER(patId,"PAT",1)),"^",1)
		set diagListObj.UpdateUserCode="-"
		set:MRDIAUpdateDate'="" diagListObj.UpdateDate=$zd(MRDIAUpdateDate,3)
		set:MRDIAUpdateTime'="" diagListObj.UpdateTime=$zt(MRDIAUpdateTime)
		//就诊科室
		set AdmDeptRowID=$p($g(^PAADM(argAdmId)),"^",4)	
		if AdmDeptRowID'=""  {		
			set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
			set:hopitalId'="" diagListObj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
		}
	}
	set body.diagnoseList=diagListObj
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
SendMessageET
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod SaveDiagnoses(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"

	set Response=##class(web.DHCENS.STBLL.EMPI.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	
	set responseBody=##class(web.DHCENS.STBLL.EMPI.MODEL.Respbody).%New()	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{	
		set PAADMVisitNumber="",DiagInfos="",UpdateUserCode="",UpdateUserRowId=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		if PAADMVisitNumber=""  {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent="病人就诊号为空"
			set Response.Respbody=responseBody
			Quit Response
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
			set:UpdateUserCode'="" UpdateUserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList","count(PAADMDiagnose)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if hsCount="0" {
				set responseBody.ResultCode="-1"
				set responseBody.ResultContent="信息为空"
				set Response.Respbody=responseBody
				Quit Response
			}
			for i=1:1:hsCount {
				set (PADDiagCode,PADDiagDesc,PADDiagType,PADDiagDocCode,PADDiagDate,PADDiagTime)=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList/PAADMDiagnose["_i_"]/PADDiagCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PADDiagCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList/PAADMDiagnose["_i_"]/PADDiagDesc","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PADDiagDesc=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList/PAADMDiagnose["_i_"]/PADDiagType","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PADDiagType=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList/PAADMDiagnose["_i_"]/PADDiagDocCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PADDiagDocCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList/PAADMDiagnose["_i_"]/PADDiagDate","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PADDiagDate=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddDiagnosisRt/PAADMDiagnoseList/PAADMDiagnose["_i_"]/PADDiagTime","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PADDiagTime=$tr(fieldValue,$c(0),"")
				}
				if DiagInfos="" {
					set DiagInfos=PADDiagCode_"^"_PADDiagDesc_"^"_PADDiagType_"^"_PADDiagDocCode_"^"_PADDiagDate_"^"_PADDiagTime
				}
				else {
					set DiagInfos=DiagInfos_"|"_PADDiagCode_"^"_PADDiagDesc_"^"_PADDiagType_"^"_PADDiagDocCode_"^"_PADDiagDate_"^"_PADDiagTime
				}
			}
		}		
	}
	ts
	set DeleteDiaResult="0"
	set MRAdmRowid=$p($g(^PAADM(PAADMVisitNumber)),"^",61)
	if MRAdmRowid="" 
	{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent="就诊无对应病案Adm"
		set Response.Respbody=responseBody
		Quit Response
	}
	set Childsub="0"  f  set Childsub=$o(^MR(MRAdmRowid,"DIA",Childsub)) q:Childsub=""  d
	.set MrDiaRowId=MRAdmRowid_"||"_Childsub
	.set DeleteSQLCode=##class(web.DHCMRDiagnos).DeleteMRDiagnos(MrDiaRowId,1)
	.if DeleteSQLCode'="0" d
	..set DeleteDiaResult="-1"	
	if DeleteDiaResult="-1"{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent="删除已存在诊断失败"
		set Response.Respbody=responseBody
		Quit Response
	}
	set LocId=$p($g(^PAADM(PAADMVisitNumber)),"^",4)
	set Length=$l(DiagInfos,"|")
	set ResultStatus="True",errorMessage=""
	for i=1:1:Length {
		set TmpDiag=$p(DiagInfos,"|",i)
		set PADDiagDocCode=$p(TmpDiag,"^",4)
		set UserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(PADDiagDocCode),""))
		if UserRowId="" {
			set ResultStatus="False"
			set errorMessage="医护人员信息输入错误"
			Quit 
		}
		set DiagnosiCode=$p(TmpDiag,"^",1)
		set ICDCodeRowid=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(DiagnosiCode),""))
		set DiagnosiDesc=$p(TmpDiag,"^",2)
		set DiagnosiType=$p(TmpDiag,"^",3)
		set MrDiaDr=##class(web.DHCMRDiagnos).InsertMRDiagnos("",MRAdmRowid,ICDCodeRowid,UserRowId,DiagnosiDesc,DiagnosiType,"03","","","")
		if ('MrDiaDr["||") {	
			set ResultStatus="False"
			set errorMessage=MrDiaDr
			Quit 
		}
	}
	s DocRowId=""
	s:PADDiagDocCode'="" DocRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(PADDiagDocCode),""))
	
	if ResultStatus="False" {
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=errorMessage
	}
	else {
		tc
		s aa= ##class(web.DHCDocOrderEntry).SetArrivedStatus(PAADMVisitNumber,DocRowId,LocId,UpdateUserRowId)  //改变状态为到达
		set responseBody.ResultCode="0"
		set responseBody.ResultContent="插入成功"
	}
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
SendMessageET
	tro
	set Response=##class(web.DHCENS.STBLL.EMPI.MODEL.Response).%New()
	set responseBody=##class(web.DHCENS.STBLL.EMPI.MODEL.Respbody).%New()	
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
}

/// Creator:ZhangXinying
/// Desc:	通过诊断rowid取相应诊断
/// Input:	MR_Diagnos表rowid
/// Debug:w ##class(web.DHCENS.STBLL.EMPI.METHOD.PADiagnose).GetMrDiagnoses("101||10").Read()
ClassMethod GetMrDiagnoses(mrdiagDr As %String) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set diagListObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PADiagnoseList).%New()
	s retValue = ""
	q:(mrdiagDr = "") ""
	if (mrdiagDr '[ "||") 
	{
		do stream.Write("<Request><Header><SourceSystem>02</SourceSystem><MessageID>14610</MessageID></Header><Body><AddDiagnosisRt><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode>DHSZHYYZY</HospitalCode><PATPatientID></PATPatientID><PAADMVisitNumber></PAADMVisitNumber><PAADMEncounterTypeCode></PAADMEncounterTypeCode><PAADMDiagnoseList><PAADMDiagnose><PADDiagId></PADDiagId><PADDiagCode></PADDiagCode><PADDiagDesc></PADDiagDesc><PADDiagTypeCode></PADDiagTypeCode><PADDiagTypeDesc></PADDiagTypeDesc><PADDiagStatus></PADDiagStatus><PADDiagDocCode></PADDiagDocCode><PADDiagDocDesc></PADDiagDocDesc><PADDiagCategory></PADDiagCategory><PADDiagDate></PADDiagDate><PADDiagTime></PADDiagTime><PADRemarks>入参非诊断表rowid</PADRemarks></PAADMDiagnose></PAADMDiagnoseList><UpdateUserCode>-</UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime></AddDiagnosisRt></Body></Request>")
		q stream
	}
	s mainmradmdr=$p(mrdiagDr,"||",1)
	s mrdiachildsub=$p(mrdiagDr,"||",2)
	s themrdiachildsub = ""
	s admDiagTypeCode="",admDiagTypeDesc=""
	if (mrdiachildsub'=0) {
		    s admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
	        s:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	        s:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
		    s themrdiachildsub = mrdiachildsub
		    s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
	        if (mricdid="") {
		        set mricdCode=""
		        set mricdDesc=""
		    }
		    else {
		        s mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
		        s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		    }
		    
		    set docId=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",12)
		    s mricdRemark=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1)),"^")
		    set diagObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PADiagnose).%New()
			if docId'="" {
				set diagObj.PADDiagDocCode=$p($g(^SSU("SSUSR",docId)),"^",1)
			}
		    set diagObj.PADDiagId=mainmradmdr_"||"_themrdiachildsub
		    set diagObj.PADDiagCode=mricdCode
		    // MR_Diagnos  表的 MRDIA_DiagStat_DR
		    set diagObj.PADDiagDesc=mricdDesc
		    set diagObj.PADDiagTypeCode=admDiagTypeCode
		    set diagObj.PADRemarks=mricdRemark
		    if admDiagTypeId'="" {
			    set diagObj.PADDiagTypeCode=admDiagTypeCode
		    	set diagObj.PADDiagTypeDesc=admDiagTypeDesc
		    }
		    else {
			    set diagObj.PADDiagTypeCode="-"
		    	set diagObj.PADDiagTypeDesc="-"
		    }
		    set diagObj.PADDiagCategory="1"
		    set MRDIADate=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",7)
		    set MRDIATime=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",8)
		    set diagObj.PADDiagDate=$zd(MRDIADate,3)
		    set diagObj.PADDiagTime=$zt(MRDIATime,1)
		    d diagListObj.diagnoses.Insert(diagObj)
		}
	
		set argAdmId=$p($g(^MR(mainmradmdr,"PRO",1)),"^",9)
		set diagListObj.PAADMVisitNumber=argAdmId
		set patId=$p(^PAADM(argAdmId),"^",1)
		set AdmTypeCode=$p($g(^PAADM(argAdmId)),"^",2)
		set diagListObj.PAADMEncounterTypeCode=AdmTypeCode
		set diagListObj.PATPatientID=$p($g(^PAPER(patId,"PAT",1)),"^",1)
		set diagListObj.UpdateUserCode="-"
		
		//就诊科室
		set AdmDeptRowID=$p($g(^PAADM(argAdmId)),"^",4)	
		if AdmDeptRowID'=""  {		
			set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
			set:hopitalId'="" diagListObj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
			set:hopitalId="" diagListObj.HospitalCode=$p($g(^CT("HOSP",$g(^CT("HOSP",0)))),"^",1)
		}
	set body.diagnoseList=diagListObj
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
SendMessageET
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Desc: 获取删除诊断信息
/// Input: 登记号^就诊号^诊断id@诊断id
/// Debug：w ##class(web.DHCENS.STBLL.EMPI.METHOD.PADiagnose).DeleteDiagnoses("0000000001^1633^1633||1")
/// Output:
ClassMethod DeleteDiagnoses(Input As %String) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.DeleteDiagnosList).%New()
	set PATPatientID=$p(Input,"^",1)
	set PAADMVisitNumber=$p(Input,"^",2)
	set PAADMDiagnose=$p(Input,"^",3)
	set len=$l(PAADMDiagnose,"@")
	set Obj.PATPatientID=PATPatientID
	set Obj.PAADMVisitNumber=PAADMVisitNumber
	for i=1:1:len
	{
		set PAADMDiagnoses=##class(web.DHCENS.STBLL.EMPI.MODEL.PAADMDiagnoses).%New()
		set PAADMDiagnoses.PADDiagId=$p(PAADMDiagnose,"@",i)
		do Obj.PAADMDiagnoses.Insert(PAADMDiagnoses)
	}
	set body.DeleteDiagnosisRt=Obj
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
SendMessageET
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
