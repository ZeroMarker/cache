Class web.DHCEMImpSym Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:预检分级症状导入
/// w ##Class(web.DHCEMImpTools).ImportSymptom("d:\symptom.txt")
ClassMethod ImportSymptom(filepath As %String) As %String
{
	N (filepath)

	S pid=##class(web.DHCADVCOMMON).NewPid()
	S hCount=0,succ=0,conCount=0
	s Err=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	s symptomLevelOne=""
	s symptomLevelTwo=""
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s ImpDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.//s ^ZXZX("data",hCount)=ImpDataList
	.//q
	.s Symptom1=$p(ImpDataList,"^",1)       /// 症状分级1
	.s Symptom2=$p(ImpDataList,"^",2)       /// 症状分级2
	.s Symptom=$p(ImpDataList,"^",3)        /// 症状
	.s level=$p(ImpDataList,"^",4)          /// 等级
	.s:Symptom1'="" symptomLevelOne=Symptom1
	.s:Symptom2'="" symptomLevelTwo=Symptom2
	.
	.q:symptomLevelOne=""
	.q:symptomLevelTwo=""
	.q:Symptom=""
	.
	.//一级症状分级
	.//##class(web.DHCAdvAction).ALPHAUP()
	.s expCode=symptomLevelOne_":"_symptomLevelTwo_":"_Symptom
	.s escapeExpCode=$REPLACE(expCode,".and.","")
	.s escapeExpCode=$REPLACE(escapeExpCode,".or.","")
	.s escapeExpCode=$REPLACE(escapeExpCode,".not","")
	.s escapeExpCode=$TR(escapeExpCode,$c(34),"") //双引号
	.s escapeExpCode=$TR(escapeExpCode,$c(40),"") //(
	.s escapeExpCode=$TR(escapeExpCode,$c(41),"") //)
	.s escapeExpCode=$TR(escapeExpCode,$c(91),"") //[
	.s escapeExpCode=$TR(escapeExpCode,$c(93),"") //]

	.s Symptom1Id=$o(^User.DHCSymptomLevI("DescIndex"," "_symptomLevelOne,""))
	.i +Symptom1Id=0 d
	..s Symptom1Id=$o(^User.DHCSymptomLevI("CodeIndex"," "_symptomLevelOne,""))
	..i +Symptom1Id=0 d
	...s tmpOneObj=##class(User.DHCSymptomLev).%New()
	...s tmpOneObj.SYLCode=symptomLevelOne
	...s tmpOneObj.SYLDesc=symptomLevelOne
	...s sc=tmpOneObj.%Save()
	...s:$$$ISERR(sc) ^ZXZX(1,expCode)=$System.Status.GetErrorText(sc)
	...s Symptom1Id=tmpOneObj.%Id()
	.
	.//二级症状分级
	.s Symptom2Id=$o(^User.DHCSymptomLevI("DescIndex"," "_$$ALPHAUP^SSUTIL4(symptomLevelTwo),""))
	.i +Symptom2Id=0 d
	..s Symptom2Id=$o(^User.DHCSymptomLevI("CodeIndex"," "_$$ALPHAUP^SSUTIL4(symptomLevelTwo),""))
	..i +Symptom2Id=0 d
	...s tmpTwoObj=##class(User.DHCSymptomLev).%New()
	...s tmpTwoObj.SYLCode=symptomLevelTwo
	...s tmpTwoObj.SYLDesc=symptomLevelTwo
	...d tmpTwoObj.SYLLastRowidSetObjectId(Symptom1Id)
	...s sc=tmpTwoObj.%Save()
	...s:$$$ISERR(sc) ^ZXZX(2,expCode)=$System.Status.GetErrorText(sc)
	...s Symptom2Id=tmpTwoObj.%Id()
	.
	.
	.//症状
	.s SymptomId=$o(^DHCSYMFEI("0","Code",expCode,"")) 
	.i +SymptomId=0 d
	..s tmpSymObj=##class(User.DHCSymptomFeild).%New()
	.e  d
	..s tmpSymObj=##class(User.DHCSymptomFeild).%OpenId(+SymptomId)
	.s tmpSymObj.SYFDesc=escapeExpCode
	.s tmpSymObj.SYFActiveFlag="Y"
	.s tmpSymObj.SYFCode=expCode
	.s sc=tmpSymObj.%Save()
	.s:$$$ISERR(sc) ^ZXZX(3,expCode)=$System.Status.GetErrorText(sc)
	.s SymptomId=tmpSymObj.%Id()
	.//症状分级和症状关联
	.s ConId=$o(^DHCSYMCONi(0,Symptom2Id,SymptomId,""))
	.i +ConId=0 d
	..s conObj=##class(User.DHCSymptomCon).%New()
	..d conObj.SYCFieldDrSetObjectId(SymptomId)
	..d conObj.SYCLevDrSetObjectId(Symptom2Id)
	..d conObj.%Save()
	..s conCount=conCount+1
	.
	.
	.s themeId=1
	.s expId=$o(^DHCEMLEX("0","Code",expCode,""))
	.
	.i +expId=0 d
	..s expObj=##class(User.DHCEmLevExpress).%New()
	.e  d
	..s expObj=##class(User.DHCEmLevExpress).%OpenId(expId)
	.s expObj.LEXActiveFlag="Y"
	.s expObj.LEXCode=expCode
	.s expObj.LEXDesc=expCode
	.s expObj.LEXText="(#Sym.checkSym(["_escapeExpCode_"]))"
	.s sc=expObj.%Save()
	.If $$$ISERR(sc) d $System.Status.DisplayError(sc)
	.s expId=expObj.%Id()
	.
	.s themItmId=$o(^DHCEMLTH(0,"LTIDesc",expId,themeId,""))
	.i +themItmId=0 d
	..s themItmObj=##class(User.DHCEmLevTheItm).%New()
	..s themItmObj.LTIChildSub=+$o(^DHCEMLTH(themeId,"L",""),-1)+1
	..d themItmObj.LTITheParRefSetObjectId(themeId)
	.e  d
	..s themItmObj=##class(User.DHCEmLevTheItm).%OpenId(themeId_"||"_+themItmId)
	.s themItmObj.LTIActiveFlag="Y"
	.s themItmObj.LTILev=level
	.d themItmObj.LTIDescSetObjectId(expId)
	.s sc=themItmObj.%Save()
	.If $$$ISERR(sc) d $System.Status.DisplayError(sc)
	.s succ=succ+1
	c filepath 
	s ^ZXZX=hCount_"^"_succ_"^"_conCount
	Q Err
}

}
