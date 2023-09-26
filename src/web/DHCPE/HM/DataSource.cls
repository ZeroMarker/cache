/// 数据源输出类  Final 用于前段筛选
/// Creator:	wangguoying
/// CreateDate:	2021-04-22
Class web.DHCPE.HM.DataSource Extends %RegisteredObject [ Final ]
{

/// Description:后台实体树
/// Input:   
/// 			PackName：包名
/// 			CLass   : 类名 模糊匹配
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2020-12-22
/// Debug: w ##class(web.DHCPE.HM.DataSource).GetPackageTree("")
ClassMethod GetPackageTree(PackName, Class = "")
{
	s:PackName="" PackName="web.DHCPE"
	s obj=..GetPackageTreeObj(PackName,Class)
	s json=##class(ext.util.JsonObject).ObjToJson(obj)
	q "["_json_"]"
}

/// Description:后台实体树对象
/// Input:   
/// 			PackName：包名
/// 			CLass   : 类名 模糊匹配
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2020-12-22
/// Debug: w ##class(web.DHCPE.HM.DataSource).GetPackageTreeObj("web.DHCPE.CA")
ClassMethod GetPackageTreeObj(PackName, Class = "")
{
	s rootObj=##class(web.DHCPE.ThirdParty.Entity.TreeNode).%New()
	s rootObj.id=PackName
	s rootObj.text=$P(PackName,".",$L(PackName,"."))
	s PackList="",Errorlog="",TraversalList=""
	Do $system.OBJ.GetPackageList(.PackList,PackName,.Errorlog)
	s pack="" 
	f  s pack=$o(PackList(pack)) q:pack=""  d
	.i $L(pack,".")=($L(PackName,".")+1) d 
	..q:(Class'="")&&(pack'[Class)
	..s clsDef=##class(%Library.ClassDefinition).%OpenId(pack)
	..q:clsDef.Final=0   //非Final修饰的过滤掉
	..q:clsDef.Description'["数据源"
 	..s nodeObj=##class(web.DHCPE.ThirdParty.Entity.TreeNode).%New()
	..s nodeObj.id=pack
	..s nodeObj.text=$P(pack,".",$L(pack,"."))_".cls"
	..d rootObj.children.Insert(nodeObj)
	.e  d
	..s nextLevle=$P(pack,".",1,$L(PackName,".")+1)
	..i '$D(TraversalList(nextLevle))  d
	...s TraversalList(nextLevle)=""
	...s children = ..GetPackageTreeObj(nextLevle,Class)
	...s clsDef = ##class(%Library.ClassDefinition).%OpenId(children.id)
	...b //:nextLevle="web.DHCPE.HM"
	...q:(clsDef="")&&(children.children.Count()=0)
	...q:(clsDef'="")&&((clsDef.Final=0)||(clsDef.Description'["数据源"))
	...d rootObj.children.Insert(children)
	
	q rootObj
}

/// Description:后台方法集合
/// Input:   
/// 			ClsName : 类名
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-04-22
/// Debug: w ##class(web.DHCPE.HM.DataSource).GetMethods("web.DHCPE.HM.DataSource")
ClassMethod GetMethods(ClsName)
{
	s clsDef=##class(%Library.ClassDefinition).%OpenId(ClsName)
	s methods = clsDef.Methods
	s arr = []
	f i=1:1:methods.Count()
	{
		s method = methods.GetAt(i)
		continue:method.Final=0
		s obj = {}
		s obj.id = method.Name
		s obj.text = method.Name_"("_method.Description _")"
		d arr.%Push(obj)
	}
	q arr.%ToJSON()
}

// Debug: w ##class(web.DHCPE.HM.DataSource).GetAlcohol("125||125")

/// 酒精单位
ClassMethod GetAlcohol(EQID) [ Final ]
{
	s ret = 0
	s detailId = 277  //问题：酒类
	s optionId = ""
	f  s optionId = $O(^User.DHCHMOQResultI("DetailOption",+EQID,$P(EQID,"||",2),detailId,optionId))  q:optionId=""  d
	.s linkDetails = ##class(HS.BL.ExamSurvey).GetOptionLinkedQuestion(optionId)
	.i linkDetails'=""  d
	..s optionScore = ""
	..f i=1:1:$L(linkDetails,",")  d
	...s linkDetailId = $P(linkDetails,",",i) 
	...s detailCode = $lg(^User.DHCHMCQuestionsDetailD(linkDetailId),3)
	...s detaiType = $lg(^User.DHCHMCQuestionsDetailD(linkDetailId),11)
	...q:detaiType'="N"  //数值型
	...s result = ..GetQuestionResult(EQID,detailCode)
	...q:result=""
	...s result = $P(result,"~",2)
	...i optionScore = ""  s optionScore = result
	...e   s optionScore = optionScore*result
	..s ret = ret + optionScore
	q:ret=0 ""
	q ret/1000
}

// Debug: w ##class(web.DHCPE.HM.DataSource).GetSmokeIndex("125||125")

/// 吸烟指数
ClassMethod GetSmokeIndex(EQID) [ Final ]
{
	s ret = 0
	s detailId = 242  //问题：吸烟
	s optionId = ""
	f  s optionId = $O(^User.DHCHMOQResultI("DetailOption",+EQID,$P(EQID,"||",2),detailId,optionId))  q:optionId=""  d
	.s linkDetails = ##class(HS.BL.ExamSurvey).GetOptionLinkedQuestion(optionId)
	.i linkDetails'=""  d
	..s optionScore = ""
	..f i=1:1:$L(linkDetails,",")  d
	...s linkDetailId = $P(linkDetails,",",i) 
	...s detailCode = $lg(^User.DHCHMCQuestionsDetailD(linkDetailId),3)
	...s detaiType = $lg(^User.DHCHMCQuestionsDetailD(linkDetailId),11)
	...q:detaiType'="N"  //数值型
	...s result = ..GetQuestionResult(EQID,detailCode)
	...q:result=""
	...s result = $P(result,"~",2)
	...i optionScore = ""  s optionScore = result
	...e   s optionScore = optionScore*result
	..s ret = ret + optionScore
	q ret
}

/// 运动情况
ClassMethod GetSport(EQID) [ Final ]
{
	s result = ..GetQuestionResult(EQID,"gd0027")
	q:result="" ""
	s result = ..GetQuestionResult(EQID,"gd0027-1")
	q:result="" "运动少"
	s result=$P(result,"~",2)
	i result>150  q "经常运动"
	q "运动少"
}

/// 尿失禁
ClassMethod GetNSJ(EQID) [ Final ]
{
	s result = ..GetQuestionResult(EQID,"gd0022-1")
	q:(result="")||(result["没有") "没有"
	s result = ..GetQuestionResult(EQID,"gd0022")
	q:result["咳嗽、打喷嚏、举重" "单纯或主要为压力性尿失禁"
	q:result["出现急迫性尿意" "单纯或主要为急迫性尿失禁"
	q:result["无腹压增高和急迫性尿意" "单纯或主要为其他原因引起的尿失禁"
	q:result["腹压增高和急迫性尿意导致" "混合型尿失禁"
	q ""
}

/// Descript:根据问题编码获取结果
/// Input:
/// 				EQID：DHC_HM_OQEQuestion
/// 				QuestionCode: 问题编码
/// Return: 	选项ID~选项描述（录入型问题为录入值）~备注@
/// Creater:	wangguoying
/// CreateDate:	2021-03-06
/// Debug: w ##class(web.DHCPE.HM.DataSource).GetQuestionResult("140||140","gd0063")
ClassMethod GetQuestionResult(EQID, QuestionCode)
{
	s evaluationID=+EQID
	s questionChl= $P(EQID,"||",2)
	s QuestionnaireId = $lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl),6)
	s resultList=""
	s quesDetailId=""
	f  s quesDetailId=$O(^User.DHCHMCQuestionsDetailI("QDCodeIndex",$C(32)_$ZCVT(QuestionCode,"U"),quesDetailId))  q:quesDetailId=""  d
	.s detailActive=$lg(^User.DHCHMCQuestionsDetailD(quesDetailId),2)
	.q:detailActive'="Y"  //问题不激活的  不再取值
	.s subjectSub=""
	.f  s subjectSub=$O(^User.DHCHMCSDLinkI("SDLDetailIndex",quesDetailId,QuestionnaireId,subjectSub))  q:subjectSub=""  d
	..s subjectActive=$lg(^User.DHCHMCQuestionnaireD(QuestionnaireId,"QSubject",subjectSub),2)
	..q:subjectActive'="Y"	//主题未激活
	..s subjectId=QuestionnaireId_"||"_subjectSub
	..s sdlSub=""
	..f  s sdlSub=$O(^User.DHCHMCSDLinkI("SDLDetailIndex",quesDetailId,QuestionnaireId,subjectSub,sdlSub))  q:sdlSub=""  d
	...s sdlActive=$lg(^User.DHCHMCQuestionnaireD(QuestionnaireId,"QSubject",subjectSub,"QSDLink",sdlSub),2)
	...q:sdlActive'="Y"	//关联关系未激活
	...s resultSub=""
	...f  s resultSub=$O(^User.DHCHMOQResultI("Detail",evaluationID,questionChl,subjectId,quesDetailId,resultSub))  q:resultSub=""  d
	....s optionId=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),2)
	....s result=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),5)
	....s remark=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),4)
	....i resultList'=""  s resultList=resultList_"@"_optionId_"~"_result_"~"_remark
	....e  s resultList=optionId_"~"_result_"~"_remark
	q resultList
}

/// w ##class(web.DHCPE.HM.DataSource).GetTZZS("1303||1303")
/// 体重指数
ClassMethod GetTZZS(EQID) [ Final ]
{
	s sg = ..GetQuestionResult(EQID,"gd0063")

	q:sg="" ""
	s sg = +$P(sg,"~",2)
	s tz = ..GetQuestionResult(EQID,"gd0064")

	q:tz="" ""
	s tz = +$P(tz,"~",2)
	q:(sg=0)||(tz=0) ""
	s result=(tz*10000)/(sg*sg)
	s ^tmpwgy("result")=result
	q $J(result,"",2)
}

}
