Class web.DHCHM.OEvaluationRecord Extends web.DHCHM.Abstract [ ClassType = "", Not ProcedureBlock ]
{

Parameter QuestionnaireId = 7;

// d ##class(%ResultSet).RunQuery("web.DHCHM.OEvaluationRecord","OEvaluationRecord","","","","陈","","")

Query OEvaluationRecord(StartDate As %String = "", EndDate As %String = "", RegNo As %String = "", Name As %String = "", Code As %String = "", Type As %String = "Q") As %Query(ROWSPEC = "ID:%String:ID,QAddDate:%String:QAddDate,QAddTime:%String:QAddTime,QAddUserDR:%String:QAddUserDR,SSUSRName:%String:SSUSRName,QCEducationDR:%String:QCEducationDR,EducationDesc:%String:EducationDesc,QCMaritalDR:%String:QCMaritalDR,MaritalDesc:%String:MaritalDesc,QCOccupationDR:%String:QCOccupationDR,OccupationDesc:%String:OccupationDesc,QDocDR:%String:QDocDR,DocName:%String:DocName,QHMDR:%String:QHMDR,SSUSRName:%String:SSUSRName,QOBaseInfoDR:%String:QOBaseInfoDR,BIName:%String:BIName,SexDesc:%String:SexDesc,RegNo:%String:RegNo,BICode:%String:BICode,QPostCode:%String:QPostCode,QRemark:%String:QRemark")
{
}

ClassMethod OEvaluationRecordExecute(ByRef qHandle As %Binary, VStartDate As %String = "", VEndDate As %String = "", VRegNo As %String = "", VName As %String = "", VCode As %String = "", VType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s VStartDate=..TransDateToDB(VStartDate)
	s VEndDate=..TransDateToDB(VEndDate)
	if VCode'="" d
	.s VCode=$ZCVT(VCode,"U")
	.s baseId=0
	.f  s baseId=$o(^User.DHCHMOBaseInfoI("BICodeIndex"," "_VCode,baseId)) q:baseId=""  d
	..s ID=""
	..f  s ID=$o(^User.DHCHMOEvaluationRecordI("QOBaseInfoDRIndex",baseId,ID),-1) q:ID=""  d
	...d BuildDataOEvaluationRecord
	else  if VRegNo'=""  d
	.s VRegNo=$ZCVT(VRegNo,"U")
	.s VRegNo=##class(web.DHCHM.Tools).RegNoMask(VRegNo)
	.s baseId=0
	.f  s baseId=$o(^User.DHCHMOBaseInfoI("BIPAPMINoIndex"," "_VRegNo,baseId)) q:baseId=""  d
	..s ID=""
	..f  s ID=$o(^User.DHCHMOEvaluationRecordI("QOBaseInfoDRIndex",baseId,ID),-1) q:ID=""  d
	...d BuildDataOEvaluationRecord
	else  if VName'=""  d
	.s VName=$ZCVT(VName,"U")
	.s Name=$O(^User.DHCHMOBaseInfoI("BINameIndex"," "_VName),-1)
	.f  s Name=$O(^User.DHCHMOBaseInfoI("BINameIndex",Name)) q:(Name="")||(Name'[VName)  d
	..s baseId=0
	..f  s baseId=$o(^User.DHCHMOBaseInfoI("BINameIndex",Name,baseId)) q:baseId=""  d
	...s ID=""
	...f  s ID=$o(^User.DHCHMOEvaluationRecordI("QOBaseInfoDRIndex",baseId,ID),-1) q:ID=""  d
	....d BuildDataOEvaluationRecord
 	e  d
	.i (VStartDate="")&&(VEndDate="") d
	..s VStartDate=+$H-15
	..s VEndDate=+$H
	.i VStartDate="" s VStartDate=0
	.i VEndDate="" s VEndDate=+$H
	.s Date=VEndDate+1
	.f  s Date=$O(^User.DHCHMOEvaluationRecordI("QAddDate",Date),-1) q:(Date="")||(Date<VStartDate)  d
	..s ID=""
	..f  s ID=$o(^User.DHCHMOEvaluationRecordI("QAddDate",Date,ID),-1) q:ID=""  d
	...d BuildDataOEvaluationRecord
	Quit $$$OK
BuildDataOEvaluationRecord
	d ResetVariablesOEvaluationRecord
	s Flag=..EvaluationRecordStatus(ID,VType)
	q:(Flag=0)  //评估必须有已经提交过的问卷才显示
				//问卷必须有未提交过的问卷才显示
	s obj=##class(User.DHCHMOEvaluationRecord).%OpenId(ID)
	s QAddDate = ..TransDateToPage(obj.QAddDate,3)
	s QAddTime = obj.QAddTime
	i $ISOBJECT(obj.QAddUserDR) d
	.s QAddUserDR = obj.QAddUserDR.%Id()
	.i QAddUserDR '= "" d
	..s SSUSRName=obj.QAddUserDR.SSUSRName
	i $ISOBJECT(obj.QCEducationDR) d
	.s QCEducationDR = obj.QCEducationDR.%Id()
	.i QCEducationDR '= "" d
	..s EducationDesc=obj.QCEducationDR.CTDesc
	i $ISOBJECT(obj.QCMaritalDR) d
	.s QCMaritalDR = obj.QCMaritalDR.%Id()
	.i QCMaritalDR '= "" d
	..s MaritalDesc=obj.QCMaritalDR.CTDesc
	i $ISOBJECT(obj.QCOccupationDR) d
	.s QCOccupationDR = obj.QCOccupationDR.%Id()
	.i QCOccupationDR '= "" d
	..s OccupationDesc=obj.QCOccupationDR.CTDesc
	i $ISOBJECT(obj.QDocDR) d
	.s QDocDR = obj.QDocDR.%Id()
	.i QDocDR '= "" d
	..s DocName=obj.QDocDR.SSUSRName
	i $ISOBJECT(obj.QHMDR) d
	.s QHMDR = obj.QHMDR.%Id()
	.i QHMDR '= "" d
	..s SSUSRName=obj.QHMDR.SSUSRName
	i $ISOBJECT(obj.QOBaseInfoDR) d
	.s QOBaseInfoDR = obj.QOBaseInfoDR.%Id()
	.i QOBaseInfoDR '= "" d
	..s BIName=obj.QOBaseInfoDR.BIName
	..s RegNo=obj.QOBaseInfoDR.BIPAPMINo
	..s BICode=obj.QOBaseInfoDR.BICode
	..i $ISOBJECT(obj.QOBaseInfoDR.BICSexDR) d
	...s SexDR=obj.QOBaseInfoDR.BICSexDR.%Id()
	...i SexDR'="" d
	....s SexDesc=obj.QOBaseInfoDR.BICSexDR.CTDesc
	s QPostCode = obj.QPostCode
	s QRemark = obj.QRemark
	d OutputRowOEvaluationRecord
	quit
OutputRowOEvaluationRecord
	
	s Data=$lb(ID,QAddDate,QAddTime,QAddUserDR,SSUSRName,QCEducationDR,EducationDesc,QCMaritalDR,MaritalDesc,QCOccupationDR,OccupationDesc,QDocDR,DocName,QHMDR,SSUSRName,QOBaseInfoDR,BIName,SexDesc,RegNo,BICode,QPostCode,QRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesOEvaluationRecord
	s (QAddDate,QAddTime,QAddUserDR,SSUSRName,QCEducationDR,EducationDesc,QCMaritalDR,MaritalDesc,QCOccupationDR,OccupationDesc,QDocDR,DocName,QHMDR,SSUSRName,QOBaseInfoDR,BIName,SexDesc,RegNo,BICode,QPostCode,QRemark)=""
	quit
}

ClassMethod OEvaluationRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OEvaluationRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OEvaluationRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OEvaluationRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCHM.OEvaluationRecord","MedicalTips","74||112")

Query MedicalTips(questionID As %String = "") As %Query(ROWSPEC = "QMTID:%String,QMTCMedicalTipsDR:%String:QMTCMedicalTipsDR,QMTCMedicalTipsDesc:%String,QMTDesc:%String:QMTDesc,QMTDetail:%String:QMTDetail,QMTRemark:%String:QMTRemark,QMTType:%String:QMTType,QMTUpdateDate:%String:QMTUpdateDate,QMTUpdateTime:%String:QMTUpdateTime,QMTUpdateUsr:%String:QMTUpdateUsr,SSUSRName:%String:SSUSRName")
{
}

ClassMethod MedicalTipsExecute(ByRef qHandle As %Binary, questionID) As %Status
{
	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s eID=+questionID
	s qSub=$p(questionID,"||",2)
	
	s sub=""
	f  s sub=$o(^User.DHCHMOQEQuestionD(eID,qSub,"DHCHMOQMedicalTips",sub),-1)  quit:sub=""  d
	.s ID=questionID_"||"_sub
	
	.d BuildDataMedicalTips
	Quit $$$OK
BuildDataMedicalTips
	d ResetVariablesMedicalTips
	s obj=##class(User.DHCHMOQMedicalTips).%OpenId(ID)
	s EDDesc=""
	i $ISOBJECT(obj.QMTCMedicalTipsDR) d
	.s QMTCMedicalTipsDR = obj.QMTCMedicalTipsDR.%Id()
	.i QMTCMedicalTipsDR '= "" d
	..s EDDesc=obj.QMTCMedicalTipsDR.MTDesc
	s QMTDesc = obj.QMTDesc
	s length=$G(^User.DHCHMOQMedicalTipsS($P(ID,"||",3),0))
	//w length_"^"_$P(ID,"||",3),!
	s QMTDetail = obj.QMTDetail.Read(length)
	s QMTRemark = obj.QMTRemark
	s QMTType = obj.QMTType
	s QMTUpdateDate = ..TransDateToPage(obj.QMTUpdateDate,3)
	s QMTUpdateTime = obj.QMTUpdateTime
	i $ISOBJECT(obj.QMTUpdateUsr) d
	.s QMTUpdateUsr = obj.QMTUpdateUsr.%Id()
	.i QMTUpdateUsr '= "" d
	..s SSUSRName=obj.QMTUpdateUsr.SSUSRName
	d OutputRowMedicalTips
	quit
OutputRowMedicalTips
	s Data=$lb(ID,QMTCMedicalTipsDR,EDDesc,QMTDesc,QMTDetail,QMTRemark,QMTType,QMTUpdateDate,QMTUpdateTime,QMTUpdateUsr,SSUSRName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMedicalTips
	s (QMTCMedicalTipsDR,QMTDesc,QMTDetail,QMTRemark,QMTType,QMTUpdateDate,QMTUpdateTime,QMTUpdateUsr,SSUSRName)=""
	quit
}

ClassMethod MedicalTipsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedicalTipsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MedicalTipsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedicalTipsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCHM.OEvaluationRecord","CMedicalTips","")

Query CMedicalTips(vdesc As %String = "", QueID As %String = "") As %Query(ROWSPEC = "ID:%String:MTID,MTActive:%String:MTActive,MTCode:%String:MTCode,MTDesc:%String:MTDesc,MTDetail:%String:MTDetail,MTRemark:%String:MTRemark")
{
}

ClassMethod CMedicalTipsExecute(ByRef qHandle As %Binary, vdesc, QueID) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i vdesc'=""{
		s vdesc=$ZCVT(vdesc,"U")
		s desc=$O(^User.DHCHMCMedicalTipsI("MTCodeIndex"," "_vdesc),-1)
		/*f  s desc=$O(^User.DHCHMCMedicalTipsI("MTCodeIndex",desc)) q:(desc="")||(desc'[vdesc)  d
		.s ID=0
		.f  s ID=$O(^User.DHCHMCMedicalTipsI("MTCodeIndex",desc,ID)) q:(ID="")  d
		..d BuildDataCMedicalTips*/
		s desc=$O(^User.DHCHMCMedicalTipsI("MTDescIndex"," "_vdesc),-1)
		f  s desc=$O(^User.DHCHMCMedicalTipsI("MTDescIndex",desc)) q:(desc="")||(desc'[vdesc)  d
		.s ID=0
		.f  s ID=$O(^User.DHCHMCMedicalTipsI("MTDescIndex",desc,ID)) q:(ID="")  d
		..d BuildDataCMedicalTips
		/*s desc=$O(^User.DHCHMCAliasI("AValueIndex"," 50011006"," "_vdesc),-1)
		f  s desc=$O(^User.DHCHMCAliasI("AValueIndex"," 50011006",desc)) q:(desc="")||(desc'[vdesc)  d
		.s aID=0
		.f  s aID=$O(^User.DHCHMCAliasI("AValueIndex"," 50011006",desc,aID)) q:(aID="")  d
		..s obj=##class(User.DHCHMCAlias).GetObj(aID)
		..s ID=obj.ASourceID
		..d BuildDataCMedicalTips*/
	}else{  //初始是空的时候
	
		/*
	    //begin cxr
	    //w QueID
	    s obj=##class(User.DHCHMOQEQuestion).%OpenId(QueID)
	    s Quetype=obj.QEQCQuestionnaireDR.%Id()
	    //w Quetype
	    s ID="" 
	    s OID=""
	    f  s OID=$o(^User.DHCHMCExpressionI("QTSIndex",Quetype," 20011006",OID))  q:OID=""  d
	   
	    .s ID=$zstrip(OID,"*"," ")
	    .//w ID,!
	    .//end cxr*/
	    
	    
		s ID=0
		f  s ID=$o(^User.DHCHMCMedicalTipsD(ID))  quit:ID=""  d
		
		.d BuildDataCMedicalTips
	}
	Quit $$$OK
BuildDataCMedicalTips
	d ResetVariablesCMedicalTips
	s obj=##class(User.DHCHMCMedicalTips).%OpenId(ID)
	s MTActive = obj.MTActive
	q:MTActive'="Y"
	s MTCode = obj.MTCode
	s MTDesc = obj.MTDesc
	s length=$G(^User.DHCHMCMedicalTipsS(ID,0))
	s MTDetail = obj.MTDetail.Read(length)
	s MTRemark = obj.MTRemark
	d OutputRowCMedicalTips
	quit 
OutputRowCMedicalTips
	s Data=$lb(ID,MTActive,MTCode,MTDesc,MTDetail,MTRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesCMedicalTips
	s (MTActive,MTCode,MTDesc,MTDetail,MTRemark)=""
	quit
}

ClassMethod CMedicalTipsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CMedicalTipsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CMedicalTipsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CMedicalTipsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 判断EvaluationRecord是否在评估记录(E)问卷录入(Q)中需要显示  0  不显示

ClassMethod EvaluationRecordStatus(ERID, Type As %String = "E")
{
	n (ERID,Type)
	q:Type="" 1
	s sub=0
	s Flag=0
	f  s sub=$O(^User.DHCHMOQEQuestionD(ERID,sub)) q:(sub="")||(Flag=1)  d
	.s obj=##class(User.DHCHMOQEQuestion).GetObj(ERID_"||"_sub)
	.s status=obj.QEQStatus
	.i Type="E" d
	..s:status="S" Flag=1
	..s:status="ES" Flag=1
	..s:status="TS" Flag=1
	..s:status="P" Flag=1
	.e  d
	..s:status="N" Flag=1
	..s:status="R" Flag=1
	q Flag
}

// 根据DHC_HM_OQEQuestion的ID得到问卷主题

// ID^Desc_$C(1)_ID2^Desc2

// w ##class(web.DHCHM.OEvaluationRecord).GetQuestionInfoById("21||24")

ClassMethod GetQuestionInfoById(Id)
{
	//q Id_"||1^aaaa"_Id_$C(1)_Id_"||2^bbbb"_Id_$C(1)_Id_"||3^ccc"_Id
	n (Id)
	q:Id="" ""
	s RStr=""
	s sub=0
	s OEID=+Id
	s OESub=$p(Id,"||",2)
	k ^TempDHCHM("OERSubject",$J)
	f  s sub=$o(^User.DHCHMOQEQuestionD(OEID,OESub,"DHCHMOQResult",sub)) q:sub=""  d
	.s QRID=Id_"||"_sub
	.s QRObj=##class(User.DHCHMOQResult).GetObj(QRID)
	.s subjectID=QRObj.QRQuestionSubjectDR.%Id()
	.q:$D(^TempDHCHM("OERSubject",$J,subjectID))
	.s subjectDesc=QRObj.QRQuestionSubjectDR.QSDesc
	.s OneStr=subjectID_"^"_subjectDesc
	.i RStr=""  d
	..s RStr=OneStr
	.e  d
	..s RStr=RStr_$C(1)_OneStr
	.s ^TempDHCHM("OERSubject",$J,subjectID)=""
	k ^TempDHCHM("OERSubject",$J)
	q RStr
}

// 根据DHC_HM_OQEQuestion、DHC_HM_CQuestionSubject的ID得到问卷细项

// w ##class(web.DHCHM.OEvaluationRecord).GetDetailInfoById("21||24","6||19")

ClassMethod GetDetailInfoById(Id, SubjectId)
{
	//q "1^多项选择^M^^^4"_$C(1)_"2^单项选择^S^^^4"_$C(1)_"3^说明型^T^^Y^"_$C(1)_"4^数值型^N^cm^^"_$C(1)_"5^日期型^D^^^"
	n (Id,SubjectId)
	s RStr=""
	s sub=0
	k ^TempDHCHM("OERDetail",$J)
	f  s sub=$o(^User.DHCHMOQResultI("Subject",+Id,$P(Id,"||",2),SubjectId,sub)) q:sub=""  d
	.s QRID=Id_"||"_sub
	.s QRObj=##class(User.DHCHMOQResult).GetObj(QRID)
	.s DetailID=QRObj.QRCQuestionsDetailDR.%Id()
	.q:$D(^TempDHCHM("OERDetail",$J,DetailID))
	.s DetailDesc=QRObj.QRCQuestionsDetailDR.QDDesc
	.s DetailType=QRObj.QRCQuestionsDetailDR.QDType
	.s DetailUnit=QRObj.QRCQuestionsDetailDR.QDUnit
	.s DetailRequired=QRObj.QRCQuestionsDetailDR.QDRequired
	.S DetailNum=+QRObj.QRCQuestionsDetailDR.QDElementNum
	.i ((DetailType="T")||(DetailType="N")||(DetailType="D")) d
	..s DetailID=QRID
	.s value=QRObj.QRResult
	.s OneStr=DetailID_"^"_DetailDesc_"^"_DetailType_"^"_DetailUnit_"^"_DetailRequired_"^"_DetailNum_"^"_value
	.i RStr=""  d
	..s RStr=OneStr
	.e  d
	..s RStr=RStr_$C(1)_OneStr
	.s ^TempDHCHM("OERDetail",$J,DetailID)=""
	k ^TempDHCHM("OERDetail",$J)
	q RStr
}

// 根据评估ID、主题、问卷得到对应的选择项

// w ##class(web.DHCHM.OEvaluationRecord).GetDetailInfoById("21||24","6||19")

ClassMethod GetOptionsById(ID, SubjectID, DetailID)
{
	//q "1||1^好^Y"_$C(1)_"1||2^较好^N"_$C(1)_"1||3^差^N"
	n (ID,SubjectID,DetailID)
	s RStr=""
	s sub=0
	f  s sub=$o(^User.DHCHMOQResultI("Detail",+ID,$P(ID,"||",2),SubjectID,DetailID,sub)) q:sub=""  d
	.s QRID=ID_"||"_sub
	.s QRObj=##class(User.DHCHMOQResult).GetObj(QRID)
	.q:'$ISOBJECT(QRObj.QRCQDOptionsDR)
	.s OID=QRObj.QRCQDOptionsDR.%Id()
	.s Desc=QRObj.QRCQDOptionsDR.QDODesc
	.s Sex=QRObj.QRCQDOptionsDR.QDOSex
	.s Active=QRObj.QRCQDOptionsDR.QDOActive
	.s Default=QRObj.QRResult
	.s OneStr=QRID_"^"_Desc_"^"_Default
	.i RStr=""  d
	..s RStr=OneStr
	.e  d
	..s RStr=RStr_$C(1)_OneStr
	q RStr
}

// 根据评估ID得到评估内容

// w ##class(web.DHCHM.OEvaluationRecord).GetOEvaluationInfo("21||24")

ClassMethod GetOEvaluationInfo(Id)
{
	//q "1||1^人群分类^C^web.DHCHM.GetComboxInfo,GetHumanClass,^"_$C(1)_"1||2^吸烟得分^N^^"_$C(1)_"1||3^医生评价^T^^"_$C(1)_"1||4^评价日期^D^^"
	n (Id)
	q:Id="" ""
	s RStr=""
	s sub=0
	s OEID=+Id
	s OESub=$p(Id,"||",2)
	f  s sub=$o(^User.DHCHMOQEQuestionD(OEID,OESub,"DHCHMOQEvaluation",sub)) q:sub=""  d
	.s QEID=Id_"||"_sub
	.s QEObj=##class(User.DHCHMOQEvaluation).GetObj(QEID)
	.s EDesc=QEObj.QECEvaluationDetailDR.EDDesc
	.s EType=QEObj.QECEvaluationDetailDR.EDType
	.s ESource=QEObj.QECEvaluationDetailDR.EDDataSource
	.s Value=QEObj.QEResult
	.s OneStr=QEID_"^"_EDesc_"^"_EType_"^"_ESource_"^"_Value
	.i RStr=""  d
	..s RStr=OneStr
	.e  d
	..s RStr=RStr_$C(1)_OneStr
	q RStr
}

// w ##class(web.DHCHM.OEvaluationRecord).GetBaseInfoByCode("1000110001100010001")

// 根据代码得到一个信息的json串

ClassMethod GetBaseInfo(argStr, Type As %String = "BICode")
{
	n (argStr,Type)
	s char2="^"
	s str=""
	s argStr=$ZCVT(argStr,"U")
	i Type="BICode" d
	.s baseID=$o(^User.DHCHMOBaseInfoI("BICodeIndex"," "_argStr,0))
	e  i Type="BIPAPMINo" d
	.s argStr=##class(web.DHCHM.Tools).RegNoMask(argStr)
	.s baseID=$o(^User.DHCHMOBaseInfoI("BIPAPMINoIndex"," "_argStr,0))
	e  d
	.s baseID=$o(^User.DHCHMOBaseInfoI("BIIDCardIndex"," "_argStr,0))
	q:baseID="" ""
	s obj=##class(User.DHCHMOBaseInfo).GetObj(baseID)
	s str=str_char2_baseID
	s str=str_char2_obj.BICode
	s str=str_char2_obj.BIName
	s str=str_char2_obj.BIMobilePhone
	s Occupation=obj.BICOccupationDR
	s OccupationDR=""
	i $ISOBJECT(Occupation) s OccupationDR=Occupation.%Id()
	s str=str_char2_OccupationDR
	s QDoc=obj.BIDocDR
	s QDocDR=""
	i $ISOBJECT(QDoc) s QDocDR=QDoc.%Id()
	s str=str_char2_QDocDR
	s str=str_char2_obj.BIPAPMINo
	s Sex=obj.BICSexDR
	s BICSexDR=""
	i $ISOBJECT(Sex) s BICSexDR=Sex.%Id()
	s str=str_char2_BICSexDR
	s UserType=obj.BICUserTypeDR
	s BICUserTypeDR=""
	i $ISOBJECT(UserType) s BICUserTypeDR=UserType.%Id()
	s str=str_char2_BICUserTypeDR
	s Education=obj.BICEducationDR
	s QCEducationDR=""
	i $ISOBJECT(Education) s QCEducationDR=Education.%Id()
	s str=str_char2_QCEducationDR
	s HM=obj.BIHMDR
	s QHMDR=""
	i $ISOBJECT(HM) s QHMDR=HM.%Id()
	s str=str_char2_QHMDR
	s str=str_char2_obj.BIIDCard
	s str=str_char2_..TransDateToPage(obj.BIDOB)
	s ServiceClass=obj.BICServiceClassDR
	s QCServiceClassDR=""
	i $ISOBJECT(ServiceClass) s QCServiceClassDR=ServiceClass.%Id()
	s str=str_char2_QCServiceClassDR
	s Marital=obj.BICMaritalDR
	s QCMaritalDR=""
	i $ISOBJECT(Marital) s QCMaritalDR=Marital.%Id()
	s str=str_char2_QCMaritalDR
	s str=str_char2_obj.BIPostCode
	s str=str_char2
	s titleStr="ID^QOBaseInfoDR^BICode^BIName^BIMobilePhone^QCOccupationDR^QDocDR^BIPAPMINo^BICSexDR^BICUserTypeDR^QCEducationDR^QHMDR^BIIDCard^BIDOB^QCServiceClassDR^QCMaritalDR^QPostCode^QRemark"
	q ##class(web.DHCHM.Json.JsonObj).GetJsonStr(titleStr,str,"^")
}

ClassMethod GetEvaluationInfoByID(ID)
{
	n (ID)
	s char2="^"
	s str=""
	s obj=##class(User.DHCHMOEvaluationRecord).GetObj(ID)
	s baseID=obj.QOBaseInfoDR.%Id()
	q:baseID="" ""
	s str=ID
	s str=str_char2_baseID
	s str=str_char2_obj.QOBaseInfoDR.BICode
	s str=str_char2_obj.QOBaseInfoDR.BIName
	s str=str_char2_obj.QOBaseInfoDR.BIMobilePhone
	s Occupation=obj.QCOccupationDR
	s OccupationDR=""
	i $ISOBJECT(Occupation) s OccupationDR=Occupation.%Id()
	s str=str_char2_OccupationDR
	s QDoc=obj.QDocDR
	s QDocDR=""
	i $ISOBJECT(QDoc) s QDocDR=QDoc.%Id()
	s str=str_char2_QDocDR
	s str=str_char2_obj.QOBaseInfoDR.BIPAPMINo
	s Sex=obj.QOBaseInfoDR.BICSexDR
	s BICSexDR=""
	i $ISOBJECT(Sex) s BICSexDR=Sex.%Id()
	s str=str_char2_BICSexDR
	s UserType=obj.QOBaseInfoDR.BICUserTypeDR
	s BICUserTypeDR=""
	i $ISOBJECT(UserType) s BICUserTypeDR=UserType.%Id()
	s str=str_char2_BICUserTypeDR
	s Education=obj.QCEducationDR
	s QCEducationDR=""
	i $ISOBJECT(Education) s QCEducationDR=Education.%Id()
	s str=str_char2_QCEducationDR
	s HM=obj.QHMDR
	s QHMDR=""
	i $ISOBJECT(HM) s QHMDR=HM.%Id()
	s str=str_char2_QHMDR
	s str=str_char2_obj.QOBaseInfoDR.BIIDCard
	s str=str_char2_..TransDateToPage(obj.QOBaseInfoDR.BIDOB)
	s ServiceClass=obj.QCServiceClassDR
	s QCServiceClassDR=""
	i $ISOBJECT(ServiceClass) s QCServiceClassDR=ServiceClass.%Id()
	s str=str_char2_QCServiceClassDR
	s Marital=obj.QCMaritalDR
	s QCMaritalDR=""
	i $ISOBJECT(Marital) s QCMaritalDR=Marital.%Id()
	s str=str_char2_QCMaritalDR
	s str=str_char2_obj.QPostCode
	s str=str_char2_obj.QRemark
	s titleStr="ID^QOBaseInfoDR^BICode^BIName^BIMobilePhone^QCOccupationDR^QDocDR^BIPAPMINo^BICSexDR^BICUserTypeDR^QCEducationDR^QHMDR^BIIDCard^BIDOB^QCServiceClassDR^QCMaritalDR^QPostCode^QRemark"
	q ##class(web.DHCHM.Json.JsonObj).GetJsonStr(titleStr,str,"^")
}

// qID：User.DHCHMOQEQuestion的ID  Type：Q(问卷)、E(评估)、T(提示)  AType：U(Update)、S(Submit)

ClassMethod GetQuestionStatus(qID, Type, AType)
{
	n (qID,Type,AType)
	s obj=##class(User.DHCHMOQEQuestion).GetObj(qID)
	s status=obj.QEQStatus
	i Type="Q"
	{
		i AType="U"
		{
			q:(status'="N")&&(status'="R") ..GetStatusDesc(status)
		}else{
			q:(status'="R") ..GetStatusDesc(status)
		}	
	}
	i Type="E"
	{
		q:(status'="S") ..GetStatusDesc(status)	
	}
	i Type="T"
	{
		q:(status'="ES") ..GetStatusDesc(status)	
	}
	q ""
}

ClassMethod GetStatusDesc(status)
{
	n (status)
	q:status="NU" "问卷处于没有使用状态"
	q:status="N" "问卷处于新建状态"
	q:status="R" "问卷处于录入结果状态"
	q:status="S" "问卷处于内容已经提交状态"
	q:status="ES" "问卷处于评估已经提交状态"
	q:status="TS" "问卷处于提示已经提交状态"
	q:status="P" "问卷处于已经打印状态"
	q "没有定义的状态"
}

// 评估各种结果保存

/// w ##class(web.DHCHM.OEvaluationRecord).UpdateResult()
ClassMethod UpdateResult(Type, Str, User)
{
	n (Type,Str,User)
	
	s Date=+$H
	s Time=$p($H,",",2)
	s char2=$C(2)
	s char1=$C(1)
	s:Type="Q" propertyStr="QRResult^QRUpdateUsr^QRUpdateDate^QRUpdateTime"
	S:Type="E" propertyStr="QEParRef^QECEvaluationDetailDR^QEResult^QEUpdateUsr^QEUpdateDate^QEUpdateTime"
	S:Type="T" propertyStr="QMTCMedicalTipsDR^QMTDesc^QMTDetail^QMTType^QMTRemark^QMTParRef^QMTUpdateUsr^QMTUpdateDate^QMTUpdateTime"
	s:Type="Q" className="User.DHCHMOQResult"
	s:Type="E" className="User.DHCHMOQEvaluation"
	s:Type="T" className="User.DHCHMOQMedicalTips"
	s strLength=$l(Str,$C(1))	
	TSTART
	f i=1:1:strLength
	{
		s oneStr=$p(Str,char1,i)
		s oneLength=$l(oneStr,char2)
		s id=$p(oneStr,char2,1)
		i (i=1)&&(Type="Q")
		{
			s rStr=##class(User.DHCHMOQEQuestion).SaveData($p(id,"||",1,2),"R","QEQStatus")
			if +rStr<0 goto Err
		}
		
		s result=$p(oneStr,char2,2,oneLength)
		b ;1
		s result=##class(web.DHCHM.Tools).Replace(result,char2,"^")
		s resultStr=result_"^"_User_"^"_Date_"^"_Time
		i (Type="E")&&(id'="")&&($L(result)=4)
		{
			s EDObj=##class(User.DHCHMOQEvaluation).%OpenId(id)
			s EQDR=EDObj.QEParRef
			s EDDR=EDObj.QECEvaluationDetailDR
			
			s result=EQDR_"^"_EDDR_"^"_result
		}
		s rStr=$ZOBJCLASSMETHOD(className,"SaveData",id,resultStr,propertyStr)
		if +rStr<0 goto Err
	}
	TCOMMIT
	q ""
Err
	TROLLBACK
	q rStr
}

// 评估各种提交保存

ClassMethod SubmitQuestion(Type, id, User)
{
	n (Type,id,User)
	s Date=+$H
	s Time=$p($H,",",2)
	s resultStr="^"_User_"^"_Date_"^"_Time
	s:Type="Q" propertyStr="QEQStatus^QEQSubmitUserType^QEQSubmitUserDR^QEQSubmitDate^QEQSubmitTime"
	S:Type="E" propertyStr="QEQStatus^QEQESubmitUserDR^QEQESubmitDate^QEQESubmitTime"
	S:Type="T" propertyStr="QEQStatus^QEQTipsSubmitUserDR^QEQTipsSubmitDate^QEQTipsSubmitTime"
	s:Type="Q" rStr="S^U"
	S:Type="E" rStr="ES"
	S:Type="T" rStr="TS"
	s resultStr=rStr_resultStr
	TSTART
	s rStr=##class(User.DHCHMOQEQuestion).SaveData(id,rStr,propertyStr)
	i +rStr<0 goto SubmitErr
	i Type="Q"
	{
		s rStr=##class(web.DHCHM.OEvaluationRecordEx).GetEvaluation(id,User)
	}
	i Type="E"
	{
		s rStr=##class(web.DHCHM.OEvaluationRecordEx).GetTips(id,User)
		i +rStr<0 goto SubmitErr
		s ret=##class(web.DHCHM.OEvaluationRecordEx).UpdateHumanClass(id)
		i +rStr<0 goto SubmitErr
		
	}
	i +rStr<0 goto SubmitErr
	TCOMMIT
	q ""
	
SubmitErr
	TROLLBACK
	q rStr
}

// 评估各种取消提交

ClassMethod CanelSubmit(Type, id)
{
	n (Type,id)
	s obj=##class(User.DHCHMOQEQuestion).GetObj(id)
	s status=obj.QEQStatus
	q:(Type="Q")&&(status'="S") " 问卷不是提交状态"
	q:(Type="T")&&((status'="TS")&&(status'="P")) " 提示不是提交状态"
	q:(Type="E")&&(status'="ES") " 评估不是提交状态"
	s:Type="Q" rStr="R"
	S:Type="E" rStr="S"
	S:Type="T" rStr="ES"
	s obj.QEQStatus=rStr
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q $System.Status.GetErrorText(sc)
	}else{
		q ""
	}
}

// 更新人员评估记录表DHC_HM_OEvaluationRecord

// w ##class(web.DHCHM.OEvaluationRecord).SaveEvaluationRecord("","2^0098876^备注^8^6^3^4^11^3","QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR","9^N$6^N","908")

ClassMethod SaveEvaluationRecord(id, valueStr, propertyStr, questionStr, user)
{
	n (id,valueStr,propertyStr,questionStr,user)
	s Date=+$H
	s Time=$p($H,",",2)
	if id="" d
	.s propertyStr=propertyStr_"^QAddUserDR^QAddDate^QAddTime"
	.s valueStr=valueStr_"^"_user_"^"_Date_"^"_Time
	TSTART
	s rStr=##class(User.DHCHMOEvaluationRecord).SaveData(id,valueStr,propertyStr)
	i +rStr<0 goto EvaluationErr
	s eID=+rStr
	s rStr=..SaveEvaluationQuestion(eID,questionStr,user)
	i +rStr<0 goto EvaluationErr
	TCOMMIT
	q eID
EvaluationErr
	TROLLBACK
	q rStr
}

// 更新评估问卷表DHC_HM_OQEQuestion

// 

ClassMethod SaveEvaluationQuestion(eID, questionStr, user)
{
	n (eID,questionStr,user)
	s rStr=0
	q:questionStr="" rStr
	s Date=+$H
	s Time=$p($H,",",2)
	s i=$l(questionStr,"$")
	f j=1:1:i
	{
		s oneQuestion=$P(questionStr,"$",j)
		s qID=$p(oneQuestion,"^",1)
		s status=$p(oneQuestion,"^",2)
		s EQsub=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",qID,eID,0))
		i EQsub=""
		{
			s ID=""
			s propertyStr="QEQParRef^QEQCQuestionnaireDR^QEQStatus^QEQAddUserDR^QEQAddDate^QEQAddTime"
			s valueStr=eID_"^"_qID_"^"_status_"^"_user_"^"_Date_"^"_Time
			s rStr=##class(User.DHCHMOQEQuestion).SaveData(ID,valueStr,propertyStr)
		}
		else
		{
			s ID=eID_"||"_EQsub
			s obj=##class(User.DHCHMOQEQuestion).GetObj(ID)
			s oldStatus=obj.QEQStatus
			i (oldStatus="N")||(oldStatus="NU")
			{
				s propertyStr="QEQStatus"
				s valueStr=status
				s rStr=##class(User.DHCHMOQEQuestion).SaveData(ID,valueStr,propertyStr)
			}
			else
			{
				s rStr=ID
			}
		}
		i +rStr<0 goto EvaluationQuestionErr
		s ID=$p(rStr,"^",1)
		i status="N"
		{
			s rStr=..SaveQuestionChildInfo(ID)
		}
		i +rStr<0 goto EvaluationQuestionErr
	}
	q rStr
EvaluationQuestionErr
	q rStr
}

// 插入评估问卷表DHC_HM_OQEQuestion的子表中记录

// w ##class(web.DHCHM.OEvaluationRecord).SaveQuestionChildInfo("11||5")

ClassMethod SaveQuestionChildInfo(ID)
{
	n (ID,user)
	s rStr=0
	s eID=+ID
	s qsub=$p(ID,"||",2)
	s obj=##class(User.DHCHMOQEQuestion).GetObj(ID)
	s qID=obj.QEQCQuestionnaireDR.%Id()
	//问卷结果
	s sub=$o(^User.DHCHMOQEQuestionD(+ID,qsub,"DHCHMOQResult",0))
	i sub=""
	{
		s Flag=0
		s Order=0
		f  s Order=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",qID,Order)) q:(Order="")||(Flag=1)  d
		.s Sub=0
		.f  s Sub=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",qID,Order,Sub)) q:(Sub="")||(Flag=1)  d
		..s SID=qID_"||"_Sub
		..s SObj=##class(User.DHCHMCQuestionSubject).GetObj(SID)
		..s SActive=SObj.QSActive
		..q:SActive="N"
		..s rStr=..SaveSubject(ID,SID)
		..s:+rStr<0 Flag=1
		i +rStr<0 goto SaveQuestionChildInfoErr
	}
	//评估结果
	s sub=$o(^User.DHCHMOQEQuestionD(eID,qsub,"DHCHMOQEvaluation",0))
	i sub=""
	{
		s Flag=0
		s Order=0
		f  s Order=$o(^User.DHCHMCQEDLinkI("QEDLOrderIndex",qID,Order)) q:(Order="")||(Flag=1)  d
		.s Sub=0
		.f  s Sub=$o(^User.DHCHMCQEDLinkI("QEDLOrderIndex",qID,Order,Sub)) q:(Sub="")||(Flag=1)  d
		..s QEDLID=qID_"||"_Sub
		..s QEDLObj=##class(User.DHCHMCQEDLink).GetObj(QEDLID)
		..s EID=QEDLObj.QEDLEvaluationDetailDR.%Id()
		..s CalculateOrder=QEDLObj.QEDLCalculateOrder
		..s EActive=QEDLObj.QEDLEvaluationDetailDR.EDActive
		..q:EActive="N"
		..s propertyStr="QEParRef^QECEvaluationDetailDR^QECalculateOrder"
		..s valueStr=ID_"^"_EID_"^"_CalculateOrder
		..s rStr=##class(User.DHCHMOQEvaluation).SaveData("",valueStr,propertyStr)
		..s:+rStr<0 Flag=1
		i +rStr<0 goto SaveQuestionChildInfoErr
	}
	q rStr
SaveQuestionChildInfoErr
	q rStr
}

ClassMethod SaveSubject(ID, SubjectId)
{
	n (ID,SubjectId)
	s rObj=##class(User.DHCHMOEvaluationRecord).GetObj(+ID)
	s Sex=rObj.QOBaseInfoDR.BICSexDR.CTCode
	s rStr=0
	s Flag=0
	s SDLOrder=0
	f  s SDLOrder=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",+SubjectId,$p(SubjectId,"||",2),SDLOrder)) q:(SDLOrder="")||(Flag=1)  d
	.s SDLSub=0
	.f  s SDLSub=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",+SubjectId,$p(SubjectId,"||",2),SDLOrder,SDLSub)) q:(SDLSub="")||(Flag=1)  d
	..s DLID=SubjectId_"||"_SDLSub
	..s DLObj=##class(User.DHCHMCSDLink).GetObj(DLID)
	..s DetailID=DLObj.SDLQuestionsDetailDR.%Id()
	..s ActiveFlag=DLObj.SDLActive
	..q:ActiveFlag="N"
	..s DActiveFlag=DLObj.SDLQuestionsDetailDR.QDActive
	..q:DActiveFlag="N"
	..s DSex=DLObj.SDLQuestionsDetailDR.QDSex
	..s:DSex="" DSex="N"
	..q:(DSex'="N")&&(DSex'=Sex)
	..s DetailType=DLObj.SDLQuestionsDetailDR.QDType
	..i (DetailType="S")||(DetailType="M") d
	...s rStr=..SaveOpetions(ID,SubjectId,DetailID)
	..e  d
	...s propertyStr="QRParRef^QRQuestionSubjectDR^QRCQuestionsDetailDR"
	...s valueStr=ID_"^"_SubjectId_"^"_DetailID
	...s rStr=##class(User.DHCHMOQResult).SaveData("",valueStr,propertyStr)
	..s:+rStr<0 Flag=1
	q rStr
}

ClassMethod SaveOpetions(ID, SubjectId, DetailID)
{
	n (ID,SubjectId,DetailID)
	s rObj=##class(User.DHCHMOEvaluationRecord).GetObj(+ID)
	s Sex=rObj.QOBaseInfoDR.BICSexDR.CTCode
	s rStr=0
	s Flag=0
	s QDOOrder=0
	f  s QDOOrder=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailID,QDOOrder)) q:(QDOOrder="")||(Flag=1)  d
	.s QDOSub=0
	.f  s QDOSub=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailID,QDOOrder,QDOSub)) q:(QDOSub="")||(Flag=1)  d
	..s OID=DetailID_"||"_QDOSub
	..s OObj=##class(User.DHCHMCQDOptions).GetObj(OID)
	..s Active=OObj.QDOActive
	..q:Active="N"
	..s OSex=OObj.QDOSex
	..s:OSex="" OSex="N"
	..q:(OSex'="N")&&(OSex'=Sex)
	..s Default=OObj.QDODefault
	..s value="N"
	..s:Default="Y" value="Y"
	..s propertyStr="QRParRef^QRQuestionSubjectDR^QRCQuestionsDetailDR^QRCQDOptionsDR^QRResult"
	..s valueStr=ID_"^"_SubjectId_"^"_DetailID_"^"_OID_"^"_value
	..s rStr=##class(User.DHCHMOQResult).SaveData("",valueStr,propertyStr)
	..s:+rStr<0 Flag=1
	q rStr
}

// 根据DHC_HM_OQEQuestion的ID得到His中的结果

ClassMethod GetHisResult(qID)
{
	q ##class(web.DHCHM.Service.GetInfo).GetHisResult(qID)
}

// 删除提示记录

ClassMethod DeleteTipsByID(ID)
{
	q ##class(User.DHCHMOQMedicalTips).Delete(ID)
}

// d ##class(%ResultSet).RunQuery("web.DHCHM.OEvaluationRecord","OEvaluationRecordNew","","","","","","","201-04-21")

Query OEvaluationRecordNew(StartDate As %String = "", EndDate As %String = "", RegNo As %String = "", Name As %String = "", Code As %String = "", Type As %String = "Q", AStartDate As %String = "", AEndDate As %String = "", Doctor As %String = "") As %Query(ROWSPEC = "ID:%String,BIRegNo:%String,BIName::%String,SexDesc:%String,TBICode:%String,QAddDate:%String,EducationDesc:%String,MaritalDesc:%String,OccupationDesc:%String,QPostCode:%String,QRemark:%String,TAge:%String,TIDCardNo:%String,AdmDate:%String,SubmitUserID:%String,SubmitUserName:%String,SubmitDate:%String,SubmitTime:%String,THPNo:%String,TExamSurveyFlag:%String,TEQStatus:%String")
{
}

ClassMethod OEvaluationRecordNewExecute(ByRef qHandle As %Binary, VStartDate As %String = "", VEndDate As %String = "", VRegNo As %String = "", VName As %String = "", VCode As %String = "", VType As %String = "Q", AStartDate As %String = "", AEndDate As %String = "", Doctor As %String = "") As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ^tmpwgy("OEvaluationRecordNewExecute")=$lb(StartDate, EndDate, RegNo, Name, Code , Type)
	s index=1
	s VStartDate=##class(websys.Conversions).DateHtmlToLogical(VStartDate)
	s VEndDate=##class(websys.Conversions).DateHtmlToLogical(VEndDate)
	s AStartDate=##class(websys.Conversions).DateHtmlToLogical(AStartDate)
	s AEndDate=##class(websys.Conversions).DateHtmlToLogical(AEndDate)
	if VCode'="" d
	.s VCode=$ZCVT(VCode,"U")
	.s baseId=0
	.f  s baseId=$o(^User.DHCHMOBaseInfoI("BICodeIndex"," "_VCode,baseId)) q:baseId=""  d
	..s ID=""
	..f  s ID=$o(^User.DHCHMOEvaluationRecordI("QOBaseInfoDRIndex",baseId,ID),-1) q:ID=""  d
	...d BuildDataOEvaluationRecordNew
	else  if VRegNo'=""  d
	.s preIadm=$O(^DHCPEPreIADM(0,"HPNo",VRegNo,""))
	.i preIadm'=""  d
	..s ID = $G(^DHCPEDataNewEx("PreIADMToHM",preIadm))
	..i ID'="" d
	...d BuildDataOEvaluationRecordNew
	.e  d	
	..s VRegNo=$ZCVT(VRegNo,"U")
	..//s VRegNo=##class(web.DHCHM.Tools).RegNoMask(VRegNo)
	..s baseId=0
	..f  s baseId=$o(^User.DHCHMOBaseInfoI("BIPAPMINoIndex"," "_VRegNo,baseId)) q:baseId=""  d
	...s ID=""
	...f  s ID=$o(^User.DHCHMOEvaluationRecordI("QOBaseInfoDRIndex",baseId,ID),-1) q:ID=""  d
	....d BuildDataOEvaluationRecordNew
	else  if VName'=""  d
	.s VName=$ZCVT(VName,"U")
	.s Name=$O(^User.DHCHMOBaseInfoI("BINameIndex"," "_VName),-1)
	.f  s Name=$O(^User.DHCHMOBaseInfoI("BINameIndex",Name)) q:(Name="")||(Name'[VName)  d
	..s baseId=0
	..f  s baseId=$o(^User.DHCHMOBaseInfoI("BINameIndex",Name,baseId)) q:baseId=""  d
	...s ID=""
	...f  s ID=$o(^User.DHCHMOEvaluationRecordI("QOBaseInfoDRIndex",baseId,ID),-1) q:ID=""  d
	....d BuildDataOEvaluationRecordNew
	e  d
	.i (AStartDate="")&&(AEndDate="") d
	..s AStartDate=+$H-100
	..s AEndDate=+$H
	.i AStartDate="" s AStartDate=0
	.i AEndDate="" s AEndDate=+$H
	.s Date=AEndDate+1
	.f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date),-1)  q:(Date="")||(Date<AStartDate)  d
	..s Time = ""
	..f  s Time = $O(^DHCPEIADM(0,"AdmDateTime",Date,Time))  q:Time=""  d
	...s IADM = ""
	...f  s IADM = $O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM))  q:IADM=""  d
	....s status = $P(^DHCPEIADM(IADM),"^",8)
	....q:status="CANCELPE"
	....s PIADM = $P(^DHCPEIADM(IADM),"^",4)
	....s ID = $G(^DHCPEDataNewEx("PreIADMToHM",PIADM))
	....d:ID'="" BuildDataOEvaluationRecordNew
 	/*
 	e  d
	.i (VStartDate="")&&(VEndDate="") d
	..s VStartDate=+$H
	..s VEndDate=+$H
	.i VStartDate="" s VStartDate=0
	.i VEndDate="" s VEndDate=+$H
	.s Date=VEndDate+1
	.f  s Date=$O(^User.DHCHMOEvaluationRecordI("QAddDate",Date),-1) q:(Date="")||(Date<VStartDate)  d
	..s ID=""
	..f  s ID=$o(^User.DHCHMOEvaluationRecordI("QAddDate",Date,ID),-1) q:ID=""  d
	...d BuildDataOEvaluationRecordNew*/
	Quit $$$OK
BuildDataOEvaluationRecordNew
	d ResetPara
	s Flag=..EvaluationRecordStatus(ID,VType)
	//q:(Flag=0)  //评估必须有已经提交过的问卷才显示
				//问卷必须有未提交过的问卷才显示
	q:('$D(^DHCPEDataNewEx("HMToPreIADM",ID)))||(^DHCPEDataNewEx("HMToPreIADM",ID)=0)
	s PreIADM = ^DHCPEDataNewEx("HMToPreIADM",ID)
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM)         //Add by 090702
  	//q:LocFlag=1 
  	//s itemInfo = ##class(HS.BL.PECommon).GetPEOrdItemByPreIADM(PreIADM,"32348||1")
  	//q:itemInfo=""
  	s ExamSurveyFlag=0
  	i $D(^DHCPEDataEx("SaveSurveyResult",PreIADM)) s ExamSurveyFlag=1
  	s PIBI = $P(^DHCPEPreIADM(PreIADM),"^",1)
	s HPNo = $P(^DHCPEPreIADM(PreIADM),"^",27)
	s iadm = $O(^DHCPEIADM(0,"CRMADM",PreIADM,""))
	s AdmDate = $P(^DHCPEIADM(iadm),"^",5)
	s AdmDate = ##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	s obj=##class(User.DHCHMOEvaluationRecord).%OpenId(ID)
	s QAddDate = ..TransDateToPage(obj.QAddDate,3)
	s QAddTime = obj.QAddTime
	i $ISOBJECT(obj.QAddUserDR) d
	.s QAddUserDR = obj.QAddUserDR.%Id()
	.i QAddUserDR '= "" d
	..s SSUSRName=obj.QAddUserDR.SSUSRName
	i $ISOBJECT(obj.QCEducationDR) d
	.s QCEducationDR = obj.QCEducationDR.%Id()
	.i QCEducationDR '= "" d
	..s EducationDesc=obj.QCEducationDR.CTDesc
	i $ISOBJECT(obj.QCMaritalDR) d
	.s QCMaritalDR = obj.QCMaritalDR.%Id()
	.i QCMaritalDR '= "" d
	..s MaritalDesc=obj.QCMaritalDR.CTDesc
	i $ISOBJECT(obj.QCOccupationDR) d
	.s QCOccupationDR = obj.QCOccupationDR.%Id()
	.i QCOccupationDR '= "" d
	..s OccupationDesc=obj.QCOccupationDR.CTDesc
	i $ISOBJECT(obj.QDocDR) d
	.s QDocDR = obj.QDocDR.%Id()
	.i QDocDR '= "" d
	..s DocName=obj.QDocDR.SSUSRName
	i $ISOBJECT(obj.QHMDR) d
	.s QHMDR = obj.QHMDR.%Id()
	.i QHMDR '= "" d
	..s SSUSRName=obj.QHMDR.SSUSRName
	i PIBI'=""  d
	.s RegNo=$p(^DHCPEPreIBI(PIBI),"^",1)
	.s IDCardNo=$p(^DHCPEPreIBI(PIBI),"^",9)
	.s SexDR = $p(^DHCPEPreIBI(PIBI),"^",3)
	.s SexDesc = $P(^CT("SEX",SexDR),"^",2)
	.s patId = $O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
	.i patId'=""  d
	..s Age=+##class(web.DHCBillInterface).GetPapmiAge(patId,"",2)
	
	
	..s BICode=obj.QOBaseInfoDR.BICode
	..;i $ISOBJECT(obj.QOBaseInfoDR.BICSexDR) d
	..;.s SexDR=obj.QOBaseInfoDR.BICSexDR.%Id()
	..;.i SexDR'="" d
	..;..s SexDesc=obj.QOBaseInfoDR.BICSexDR.CTDesc
	s QPostCode = obj.QPostCode
	s QRemark = obj.QRemark
	
	s submitUser = "",summitUserName="",submitDate="",submitTime=""
	s questionChl="" // $o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",..#QuestionnaireId,ID,""),-1)
	//q:(questionChl="")&&(Doctor'="") 
	s eqStatus=0
	i questionChl'=""
	{
		s eqStatus = ..GetSurveyStatus(ID_"||"_questionChl)
		s qeqsStatus = $lg(^User.DHCHMOQEQuestionD(ID,questionChl),15)
		q:(qeqsStatus'="ES")&&(Doctor'="")  //护士未提交
		s submitDate = $lg(^User.DHCHMOQEQuestionD(ID,questionChl),7)
		s:submitDate'="" submitDate = ##class(websys.Conversions).DateLogicalToHtml(submitDate)
		s submitTime = $lg(^User.DHCHMOQEQuestionD(ID,questionChl),8)
		s:submitTime'="" submitTime = ##class(websys.Conversions).TimeLogicalToHtml(submitTime)
		s submitUser = $lg(^User.DHCHMOQEQuestionD(ID,questionChl),9)
		q:(Doctor'="")&&(submitUser'=Doctor)
		s:submitUser'="" summitUserName = $P(^SSU("SSUSR",submitUser),"^",2)
	}
	
	d OutputRowOEvaluationRecordNew
	quit
OutputRowOEvaluationRecordNew
	i RegNo'="" d
	.s PatientID=$O(^PAPERi("PAPMI_PatNo",RegNo,""))
	.i PatientID'="" d
	..s BIName=$P(^PAPER(PatientID,"ALL"),"^",1)

	s Data=$lb(ID,RegNo,BIName,SexDesc,BICode,QAddDate,EducationDesc,MaritalDesc,OccupationDesc,QPostCode,QRemark,Age,IDCardNo,AdmDate,submitUser,summitUserName,submitDate,submitTime,HPNo,$G(ExamSurveyFlag),eqStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetPara
	s (QAddDate,AdmDate,QAddTime,QAddUserDR,SSUSRName,QCEducationDR,EducationDesc,QCMaritalDR,MaritalDesc,QCOccupationDR,OccupationDesc,QDocDR,DocName,QHMDR,SSUSRName,QOBaseInfoDR,BIName,SexDesc,RegNo,BICode,QPostCode,QRemark,Age,IDCardNo)=""
	quit
}

ClassMethod OEvaluationRecordNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OEvaluationRecordNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OEvaluationRecordNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OEvaluationRecordNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Descript:	获取评估记录的状态
/// Input:			
/// 			QEQID：DHC_HM_OQEQuestion			
/// Return: 	0：未保存 1：部分保存 2：全部保存  3：已提交
/// Creater:	wangguoying
/// CreateDate:	2021-05-23
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).SubmitSurvey(2680)
ClassMethod GetSurveyStatus(EQID)
{
	s ret = 0
	s QEQStatus = $lg(^User.DHCHMOQEQuestionD(+EQID,$P(EQID,"||",2)),15)
	q:QEQStatus="ES" 3
	s QuesID = $lg(^User.DHCHMOQEQuestionD(+EQID,$P(EQID,"||",2)),6)
	
	s piadm = $G(^DHCPEDataNewEx("HMToPreIADM",+EQID))
	q:piadm="" 0
	
	s pibi = $P(^DHCPEPreIADM(piadm),"^",1)
	s SexCode="N"
	s PatientRegNo= $P(^DHCPEPreIBI(pibi),"^",1)
	s sexDr = $P(^DHCPEPreIBI(pibi),"^",3)
	s:sexDr=1 SexCode="M"
	s:sexDr=2 SexCode="F"
	s Age=""
	s patId = $O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientRegNo),""))
	i patId'=""  d
	.s Age=+##class(web.DHCBillInterface).GetPapmiAge(patId,"",2)
	
	s flag = 0 //存在未保存的数据
	
	s Order=""
	f  s Order=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",QuesID,Order)) q:Order=""  d
	.s Child=0
	.f  s Child=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",QuesID,Order,Child)) q:Child=""  d
	..s SubjectActive=$lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),2)
	..q:SubjectActive'="Y"
	..s SubjectSex=$lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),7)
	..s:SubjectSex="" SubjectSex="N"
	..q:(SubjectSex'="N")&&(SexCode'="N")&&(SubjectSex'=SexCode)
	..s minAge = $lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),9)
	..s maxAge = $lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),10)
	..q:(Age'="")&&(((minAge'="")&&(Age<minAge))||((maxAge'="")&&(Age>maxAge)))
	..s SubjectID=QuesID_"||"_Child
	..i $D(^DHCPEDataEx("SaveSurveyResult",piadm,SubjectID))  s ret=1
	..e  s flag=1
	
	i (ret=1)&&(flag=0) s ret=2
	q ret
}

}
