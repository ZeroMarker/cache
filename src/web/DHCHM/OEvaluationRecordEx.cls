Class web.DHCHM.OEvaluationRecordEx Extends web.DHCHM.Abstract [ ClassType = "", Not ProcedureBlock ]
{

//根据问卷ID得到评估结果，问卷提交时调用

//d ##class(web.DHCHM.OEvaluationRecordEx).GetEvaluation("5||5")

ClassMethod GetEvaluation(id, user As %String = "")
{
	n (id,user)
	s Date=+$H
	s Time=$P($H,",",2)
	s rID=+id
	s qSub=$p(id,"||",2)
	s qObj=##class(User.DHCHMOQEQuestion).GetObj(id)
	s cQusetionID=qObj.QEQCQuestionnaireDR.%Id()
	s rObj=##class(User.DHCHMOEvaluationRecord).GetObj(rID)
	s bID=rObj.QOBaseInfoDR.%Id()
	k ^TempDHCHM($J,"EvaluationCalculate")
	s sub=0
	f  s sub=$O(^User.DHCHMOQEQuestionD(rID,qSub,"DHCHMOQEvaluation",sub)) q:sub=""  d
	.s reObj=##class(User.DHCHMOQEvaluation).GetObj(id_"||"_sub)
	.s eID=reObj.QECEvaluationDetailDR.%Id()
	.s CalculateOrder=reObj.QECalculateOrder
	.Q:CalculateOrder=""
	.s:CalculateOrder="" CalculateOrder="9999999999"
	.s ^TempDHCHM($J,"EvaluationCalculate",CalculateOrder)=eID_"^"_id_"||"_sub  //评估ID^评估结果ID
	s corder=0
	f  s corder=$O(^TempDHCHM($J,"EvaluationCalculate",corder)) q:corder=""  d
	.s str=$G(^TempDHCHM($J,"EvaluationCalculate",corder))
	.s eid=$p(str,"^",1)  //评估ID
	.s erid=$p(str,"^",2)  //评估结果ID
	.s express=..GetExpress(cQusetionID,"20011005",eid,bID)
	.q:express=""
	.s result=..GetExpressResult(id,express)
	.d ##class(User.DHCHMOQEvaluation).SaveData(erid,result_"^"_user_"^"_Date_"^"_Time,"QEResult^QRUpdateUsr^QRUpdateDate^QRUpdateTime")
	q 0
}

//根据问卷ID得到提示记录，评估提交时调用

ClassMethod GetTips(id, user As %String = "")
{
	n (id,user)
	s Date=+$H
	s Time=$P($H,",",2)
	s rID=+id
	s qsub=$p(id,"||",2)
	//User.DHCHMCExpression
	s qObj=##class(User.DHCHMOQEQuestion).GetObj(id)
	s cQusetionID=qObj.QEQCQuestionnaireDR.%Id()
	s rObj=##class(User.DHCHMOEvaluationRecord).GetObj(rID)
	s sex=rObj.QOBaseInfoDR.BICSexDR.CTCode
	s Dob=rObj.QOBaseInfoDR.BIDOB
	s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
	s sourceID=""
	f  s sourceID=$O(^User.DHCHMCExpressionI("QTSIndex",cQusetionID," 20011006",sourceID)) q:sourceID=""  d
	.s expressid=0
	.s express=""
	.f  s expressid=$O(^User.DHCHMCExpressionI("QTSIndex",cQusetionID," 20011006",sourceID,expressid)) q:(expressid="")||(express'="")  d
	..s eObj=##class(User.DHCHMCExpression).GetObj(expressid)
	..s ESex=eObj.ESex
	..q:(ESex'="N")&&(ESex'=sex)
	..s MinAge=+eObj.EAgeMin
	..s MaxAge=+eObj.EAgeMax
	..s:MaxAge=0 MaxAge=200
	..q:(Age>MaxAge)||(Age<MinAge)
	..s express=eObj.EExpression
	..s expressType=eObj.EExpressionType
	..s Parameters=eObj.EParameters
	.q:express=""
	.s express=expressType_"^"_express_"^"_Parameters
	.s result=..GetExpressResult(id, express)
	.i result="1" d
	..s sID=$p(sourceID," ",2)
	..q:$D(^User.DHCHMOQMedicalTipsI("QMTCMedicalTipsDRIndex",sID,rID,qsub))
	..s tObj=##class(User.DHCHMCMedicalTips).GetObj(sID)
	..s activeFlag=tObj.MTActive
	..q:activeFlag="N"
	..s desc=tObj.MTDesc
	..s length=$G(^User.DHCHMCMedicalTipsS(sID,0))
	..s detail=tObj.MTDetail.Read(length)
	..s propertyStr="QMTCMedicalTipsDR^QMTDesc^QMTDetail^QMTType^QMTRemark^QMTParRef^QMTUpdateUsr^QMTUpdateDate^QMTUpdateTime"
	..s valueStr=sID_"^"_desc_"^"_detail_"^"_"A"_"^"_""_"^"_id_"^"_user_"^"_Date_"^"_Time
	..d ##class(User.DHCHMOQMedicalTips).SaveData("",valueStr,propertyStr)
	q 0
}

/// 根据评估问卷得到评估出来的人员分类
ClassMethod GetHumanClass(id)
{
}

//问卷ID、表达式类型、源ID、病人信息ID

//d ##class(web.DHCHM.OEvaluationRecordEx).GetExpress("1","20011005","7","2")

ClassMethod GetExpress(QID, Type, sourceID, bID)
{
	n (QID,Type,sourceID,bID)
	s bObj=##class(User.DHCHMOBaseInfo).GetObj(bID)
	s sex=bObj.BICSexDR.CTCode
	s Dob=bObj.BIDOB
	s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
	s express=""
	s expressid=0
	f  s expressid=$O(^User.DHCHMCExpressionI("QTSIndex",QID," "_Type," "_sourceID,expressid)) q:(expressid="")||(express'="")  d
	.s eObj=##class(User.DHCHMCExpression).GetObj(expressid)
	.s ESex=eObj.ESex
	.q:(ESex'="N")&&(ESex'=sex)
	.s MinAge=+eObj.EAgeMin
	.s MaxAge=+eObj.EAgeMax
	.s:MaxAge=0 MaxAge=200
	.q:(Age>MaxAge)||(Age<MinAge)
	.s express=eObj.EExpression
	.s expressType=eObj.EExpressionType
	.s Parameters=eObj.EParameters
	q:express'="" expressType_"^"_express_"^"_Parameters
	q ""
}

//得到表达式结果

//DHC_HM_OQEQuestionID,express格式为Type^express^Parameters

//表达式((([30011008.Zy03001]+ [30011008.Zy03002]+ [30011008.Zy03003]+ [30011008.Zy03004])-4)/(4*4))*100

//d ##class(web.DHCHM.OEvaluationRecordEx).GetExpressResult("14||23","E^$S([30011008.cdc01020]<85:[300110030006.1],1:[300110030006.2])^")

ClassMethod GetExpressResult(OEQID, express)
{
	n (OEQID,express)
	s $ZT="Error"
	s rID=+OEQID
	s qsub=$p(OEQID,"||",2)
	s type=$p(express,"^",1)
	i type="E" d  //表达式
	.s express=$p(express,"^",2)
	.s rStr=express
	.s i=$l(express,"]")
	.f j=1:1:i  d
	..s one=$p(express,"]",j)
	..s one=$p(one,"[",2)
	..s codeType=$p(one,".",1)
	..s code=$ZCVT($p(one,".",2),"U")
	..i codeType="30011008"  d  //问卷结果
	...s sID=$O(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_code,0))
	...s result=0
	...i sID'="" d
	....s sObj=##class(User.DHCHMCQuestionsDetail).GetObj(sID)
	....s stype=sObj.QDType
	....i (stype="M")||(stype="S") d  //选择型
	.....s subject=""
	.....f  s subject=$O(^User.DHCHMOQResultI("Detail",rID,qsub,subject)) q:subject=""  d
	......s sub=0
	......f  s sub=$O(^User.DHCHMOQResultI("Detail",rID,qsub,subject,sID,sub)) q:sub=""  d
	.......s rObj=##class(User.DHCHMOQResult).GetObj(OEQID_"||"_sub)
	.......s resultFlag=rObj.QRResult
	.......i resultFlag="Y" d
	........s result=result+rObj.QRCQDOptionsDR.QDOClass
	....e  d
	.....s subject=""
	.....f  s subject=$O(^User.DHCHMOQResultI("Detail",rID,qsub,subject)) q:subject=""  d
	......s sub=$O(^User.DHCHMOQResultI("Detail",rID,qsub,subject,sID,0))
	......q:sub=""
	......s rObj=##class(User.DHCHMOQResult).GetObj(OEQID_"||"_sub)
	......s result=rObj.QRResult
	..e  i codeType="30011005"  d //评估结果
	...s sID=$O(^User.DHCHMCEvaluationDetailI("EDCodeIndex"," "_code,0))
	...s result=0
	...i sID'="" d
	....s sub=$O(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",rID,qsub,sID,0))
	....q:sub=""
	....s rObj=##class(User.DHCHMOQEvaluation).GetObj(OEQID_"||"_sub)
	....s result=rObj.QEResult
	..e  i ($E(codeType,1,8)="30011003")  d  //分级类别
	...s vType=$E(codeType,5,$L(codeType))
	...s sID=$O(^User.DHCHMCClassLevelI("TypeCodeIndex"," "_vType," "_code,0))
	...q:sID=""
	...s result=sID
	..e  i ($E(codeType,1,8)="30011004")  d  //人员分类
	...s vType=$E(codeType,5,$L(codeType))
	...s sID=$O(^User.DHCHMCHumanClassI("TypeCodeIndex"," "_vType," "_code,0))
	...q:sID=""
	...s result=sID
	..e  i ($E(codeType,1,8)="30011002")  d  //知晓情况
	...s vType=$E(codeType,5,$L(codeType))
	...s sID=$O(^User.DHCHMCPlainnessI("TypeCodeIndex"," "_vType," "_code,0))
	...q:sID=""
	...s result=sID
	..s rStr=##class(web.DHCHM.Tools).Replace(rStr,"["_one_"]",result)
	e  d //函数
	.s express=$p(express,"^",2)
	.s rStr=express_"("_OEQID_")"
	s rStr="s rStr="_rStr
    xecute rStr  //执行上面的M
    q rStr
Error
	q ""
}

//w ##class(web.DHCHM.OEvaluationRecordEx).UpdateHumanClass("1||1")

ClassMethod UpdateHumanClass(id)
{
	n (id)
	s ret=0
	s rID=+id
	s qsub=$p(id,"||",2)
	
	s qObj=##class(User.DHCHMOQEQuestion).GetObj(id)
	s cQusetionID=qObj.QEQCQuestionnaireDR.%Id()
	s eCode=""
	//根据问卷ID得到对应的评估代码
	if cQusetionID=1 d
	.s eCode="ZY21"
	if cQusetionID=2 d
	.s eCode="CDC08"
	//
	//根据评估Code得到评估ID以及对应的值
	s sID=$O(^User.DHCHMCEvaluationDetailI("EDCodeIndex"," "_eCode,0))
	s result=0
	i sID'="" d
	.s sub=$O(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",rID,qsub,sID,0))
	.q:sub=""
	.s rObj=##class(User.DHCHMOQEvaluation).GetObj(id_"||"_sub)
	.s result=rObj.QEResult
	.s ret=##class(User.DHCHMOQEQuestion).SaveData(id,result,"QEQCHumanClassDR","N")
	
	q +ret
}

}
