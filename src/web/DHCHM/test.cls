Class web.DHCHM.test Extends %Persistent [ Not ProcedureBlock ]
{

//根据问卷ID得到提示记录，评估提交时调用

//d ##class(web.DHCHM.test).GetTips("15||24",1)

ClassMethod GetTips(id, user)
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
	..s detail=tObj.MTDetail.Read(10000)
	..w detail,!
	..s propertyStr="QMTCMedicalTipsDR^QMTDesc^QMTDetail^QMTType^QMTRemark^QMTParRef^QMTUpdateUsr^QMTUpdateDate^QMTUpdateTime"
	..s valueStr=sID_"^"_desc_"^"_detail_"^"_"A"_"^"_""_"^"_id_"^"_user_"^"_Date_"^"_Time
	..//d ##class(User.DHCHMOQMedicalTips).SaveData("",valueStr,propertyStr)
}

ClassMethod GetExpressResult(OEQID, express)
{
	n (OEQID,express)
	s rID=+OEQID
	s qsub=$p(OEQID,"||",2)
	s type=$p(express,"^",1)
	//i order=7 w express,!
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
	.....s subject=$O(^User.DHCHMOQResultI("Detail",rID,qsub,""))
	.....q:subject=""
	.....s sub=$O(^User.DHCHMOQResultI("Detail",rID,qsub,subject,sID,0))
	.....q:sub=""
	.....s rObj=##class(User.DHCHMOQResult).GetObj(OEQID_"||"_sub)
	.....s result=rObj.QRResult
	..e  i codeType="30011005"  d //评估结果
	...s sID=$O(^User.DHCHMCEvaluationDetailI("EDCodeIndex"," "_code,0))
	...s result=0
	...i sID'="" d
	....s sub=$O(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",rID,qsub,sID,0))
	....q:sub=""
	....s rObj=##class(User.DHCHMOQEvaluation).GetObj(OEQID_"||"_sub)
	....s result=rObj.QEResult
	..s rStr=##class(web.DHCHM.Tools).Replace(rStr,"["_one_"]",result)
	e  d //函数
	.s express=$p(express,"^",2)
	.s rStr=express_"("_OEQID_")"
	
	s rStr="s rStr="_rStr
	w rStr
	xecute rStr  //执行上面的M
    q rStr
}

//d ##class(web.DHCHM.test).Test()

ClassMethod Test()
{
	s clsDef=##class(%Library.ClassDefinition).%OpenId("User.DHCHMCMedicalTips")
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		continue:proName["%"
		continue:clsPro.Cardinality="children"
		continue:clsPro.Cardinality="parent"
		s childPro=""
		s cls=clsPro.Type
		w clsPro.Collection,!
		w cls,!
	}
}

ClassMethod Test2()
{
	 w ##class(User.DHCHMCSetting).SaveData("146","60","SValue")
}

ClassMethod ttt()
{
	w ..%ClassName(1)
	q
}

Storage Default
{
<Data name="testDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCHM.testD</DataLocation>
<DefaultData>testDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCHM.testD</IdLocation>
<IndexLocation>^web.DHCHM.testI</IndexLocation>
<StreamLocation>^web.DHCHM.testS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
