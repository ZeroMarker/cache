Class web.DHCCKBProblemsPresc Extends %RegisteredObject
{

/// Description:	问题处方查询
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-25
/// Input:			开始时间,结束时间,管理级别,科室
/// return:			字符串
/// w ##Class(web.DHCCKBProblemsPresc).QueryProblemsPresc("2022-04-21^2022-04-21^forbid^")
ClassMethod QueryProblemsPresc(params) As %String
{
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	s level = $p(params,"^",3)
	s ctLoc = $p(params,"^",4)
	
	s outArr = []
	
	s stDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(stDate)
	s endDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(endDate)
	
	s passFlag = 0 
	f date = stDate:1:endDate  d
	.q:'$d(^CKB.PDSS.MonMasterI("DatePass",date))
	.s cmRowID = ""
	.f  s cmRowID = $o(^CKB.PDSS.MonMasterI("DatePass",date,passFlag,cmRowID))  q:cmRowID=""  d
	..s outObj = {}
	..q:'$d(^CKB.PDSS.MonMasterD(+cmRowID))
	..q:'$D(^CKB.PDSS.FeedBackI("MsgIDType",cmRowID)) // 只统计生成医嘱的
	..s monData = $g(^CKB.PDSS.MonMasterD(cmRowID))
	..s manLevel = $lg(monData,8)
	..q:(level'="")&&(level'=manLevel)
	..s fbRowID = "",oeorFlag = 0,oeorItemId = ""
	..f  s fbRowID = $o(^CKB.PDSS.FeedBackI("MsgIDType",cmRowID,"Doc",fbRowID))  q:(fbRowID="")||(oeorFlag=1)  d
	...s oeorItem = $lg(^CKB.PDSS.FeedBackD(+fbRowID),6)
	...q:oeorItem=""
	...s oeorFlag=1
	...s oeorItemId=oeorItem
	..
	..q:oeorFlag=0	
	..s patLoc = $lg(monData,6)	// 科室
	..// 科室应该是描述,传的都是code -蚌埠一院
	..i (patLoc'="")&&($d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(patLoc)))) d
	...s ctLocId = $o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(patLoc),""))
	...s patLoc = $p($g(^CTLOC(+ctLocId)),"^",2)
	
	..q:(ctLoc'="")&&(patLoc'=ctLoc)
	..s levelDesc = $s(manLevel="normal":"提示",manLevel="tips":"提醒",manLevel="warn":"警示",manLevel="forbid":"禁止",1:"")
	..s adm = $lg(monData,2)
	..//q:adm=""
	..s papmiNo = 0 //$p($g(^PAADM(+adm)),"^",1)
	..s patNo = 0 //$p(^PAPER(papmiNo,"PAT",1),"^",1)	// 登记号
	..s patInfo = $lg(monData,9) 
	..q:patInfo["程序发生错误"
	..q:patInfo["错误详情"	
	..s patObj = {}.%FromJSON(patInfo)
	..s patName = patObj.%Get("PatName")	
	..s patSex = patObj.%Get("SexProp")
	..s patAge = patObj.%Get("AgeProp")
	..s patDoc = $lg(monData,5)	
	..// 疾病 
	..s disease = patObj.%Get("Disease")
	..s patDis = ""
	..f i=0:1:disease.%Size()-1  d
	...s diseaseObj = disease.%Get(i)
	...s tmpDis = diseaseObj.item
	...q:$lf(patDis,tmpDis)'=0
	...s $list(patDis,*+1)=tmpDis
	..s patDis = $lts(patDis,"、")
	..// 提示消息	
	..s outmsgstr = ..OutPutMsg(cmRowID)
	..s notes = $lg(monData,19)  // 备注信息
	..s:notes="" notes = ..GetDocNotes(cmRowID)
	..s prescNo = "" 
	..i oeorItemId'="" d
	...s oeorsub = $P(oeorItemId,"||",2) // 839017||34
	...s prescNo = $p($g(^OEORD(+oeorItemId,"I",oeorsub,1)),"^",14)
	..d outObj.%Set("patname",patName)
	..d outObj.%Set("patsex",patSex)
	..d outObj.%Set("patage",patAge)
	..d outObj.%Set("patloc",patLoc)
	..d outObj.%Set("patdoc",patDoc)
	..d outObj.%Set("patdis",patDis)
	..d outObj.%Set("manlevel",levelDesc)
	..d outObj.%Set("warnmsg",outmsgstr)
	..d outObj.%Set("reason",notes)
	..d outObj.%Set("cmrowId",cmRowID)
	..d outObj.%Set("prescNo",prescNo)
	..d outObj.%Set("stDate",$zd(date,3))
	..d outArr.%Push(outObj)
	..b:cmRowID=606055
	w outArr.%ToJSON()
	
	q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2022-05-25
/// Description:  审核输出消息整理
/// Input:		 
/// Other:        药品a:相互作用(警示):消息,禁忌症(警示):消息;药品b:用法用量(警示):消息,重复用药(警示):消息;
/// w ##Class(web.DHCCKBProblemsPresc).OutPutMsg(8956669)
ClassMethod OutPutMsg(cmRowID As %String)
{
	q:cmRowID="" ""
	s msgInfo = $lg(^CKB.PDSS.MonMasterD(+cmRowID),10)
	q:msgInfo="" ""

	s outmsgstr=""
	s msgObj = {}.%FromJSON(msgInfo)	
	s itemsObj = msgObj.items		// 多个药品obj
	f j=0:1:itemsObj.%Size()-1 d
	.s tmpItmObj = itemsObj.%Get(j)
	.s drugOutMsg=""
	.s checkDrug = tmpItmObj.item
	.s warnObj = tmpItmObj.warns
	.s warnmsg = ""
	.f m=0:1:warnObj.%Size()-1 d	// 多个目录obj
	..s tmpWarmObj = warnObj.%Get(m)
	..s keyname = tmpWarmObj.keyname
	..s keyLevel = tmpWarmObj.manLev
	..s rulemsg = ""
	..s rulemsgObj = tmpWarmObj.itms
	..f n=0:1:rulemsgObj.%Size()-1 d
	...s tmpruleObj = rulemsgObj.%Get(n)
	...s outmsgObj = tmpruleObj.itms
	...s outmsg = ""
	...f x=0:1:outmsgObj.%Size()-1 d	// 多个项目obj
	....s tmpOutObj = outmsgObj.%Get(x)
	....s outstr = tmpOutObj.val	// 项目提醒消息
	....q:outstr=""
	....s outstr = $replace(outstr,","," ")
	....s outmsg =$case(outmsg'="",1:outmsg_". "_outstr,:outstr)
	...
	...q:outmsg=""
	...s rulemsg = $case(rulemsg'="",1:rulemsg_"& "_outmsg,:outmsg) 
	..
	..q:rulemsg=""
	..s keymsg = keyname_"("_keyLevel_"):"_outmsg
	..s warnmsg = $case(warnmsg'="",1:warnmsg_$c(11)_keymsg,:keymsg) 
	.
	.q:warnmsg=""
	.s drugOutMsg = checkDrug_":"_warnmsg
	.s outmsgstr = $case(outmsgstr'="",1:outmsgstr_"; "_$c(11)_"    "_drugOutMsg,:drugOutMsg) 
	.s outmsgstr = $replace(outmsgstr,","," ")
	q outmsgstr
}

/// Creator:      qunianpeng
/// CreatDate:    2022-05-25
/// Description:  审核输出消息整理
/// Input:		 
/// Other:        药品a:相互作用(警示):消息,禁忌症(警示):消息;药品b:用法用量(警示):消息,重复用药(警示):消息;
/// w ##Class(web.DHCCKBProblemsPresc).GetDocNotes(8956669)
ClassMethod GetDocNotes(cmRowID As %String)
{
	q:cmRowID="" ""
	q:'$d(^CKB.PDSS.FeedBackI("MsgIDType",cmRowID)) ""
	
	s notelist = ""
	s userType = "Doc"
	s fbRowID = ""
	f  s fbRowID = $o(^CKB.PDSS.FeedBackI("MsgIDType",cmRowID,userType,fbRowID)) q:fbRowID=""  d
	.s feedData = $g(^CKB.PDSS.FeedBackD(fbRowID))
	.s notes = $lg(feedData,10) 
	.s:notes="otherVal" notes="其他"
	.i $lf(notelist,notes)=0 s $list(notelist,*+1)=notes
		
	q $lts(notelist)
}

/// Description:	获取病人信息
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-25
/// Input:			审核日志id
/// return:			字符串
/// w ##Class(web.DHCCKBProblemsPresc).GetPatInfo(530)
ClassMethod GetPatInfo(cmRowID) As %String
{
	q:+cmRowID=0 "{}"
	s monData = $g(^CKB.PDSS.MonMasterD(cmRowID))
	s adm = $lg(monData,2)
	//q:adm=""
	s papmiNo = 0 //$p($g(^PAADM(+adm)),"^",1)
	s patNo = 0 //$p(^PAPER(papmiNo,"PAT",1),"^",1)	// 登记号
	s patInfo = $lg(monData,9) 
	q:patInfo["程序发生错误" "{}"
	q:patInfo["错误详情" "{}"
	s patObj = {}.%FromJSON(patInfo)
	s patName = patObj.%Get("PatName")	
	s patSex = patObj.%Get("SexProp")
	s patAge = patObj.%Get("AgeProp")
	s patDoc = $lg(monData,5)
	s patLoc = $lg(monData,6) // 科室
	// 科室应该是描述,传的都是code -蚌埠一院
	i (patLoc'="")&&($d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(patLoc)))) d
	.s ctLocId = $o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(patLoc),""))
	.s patLoc = $p($g(^CTLOC(+ctLocId)),"^",2)
	s patHeight = patObj.%Get("Height")	// 身高
	s patWeight = patObj.%Get("Weight")	// 体重
	// 疾病 
	s disease = patObj.%Get("Disease")
	s patDis = ""
	f i=0:1:disease.%Size()-1  d
	.s diseaseObj = disease.%Get(i)
	.s tmpDis = diseaseObj.item
	.q:$lf(patDis,tmpDis)'=0
	.s $list(patDis,*+1)=tmpDis
	
	s patDis = $lts(patDis,"、")
	
	set prescObj = {}
	set prescObj.cmRowID = cmRowID
	set prescObj.patNo = patNo
	set prescObj.admNo = adm
	set prescObj.patName = patName
	set prescObj.patSex = patSex
	set prescObj.patAge = patAge
	set prescObj.diagnos = patDis
	set prescObj.docDesc = patDoc
	set prescObj.locDesc = patLoc
	set prescObj.patHeight = patHeight
	set prescObj.patWeight = patWeight

	w prescObj.%ToJSON()
	
	q ""
}

/// Description:	获取处方药品信息
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-26
/// Input:			审核日志id
/// return:			字符串
/// w ##Class(web.DHCCKBProblemsPresc).QueryProPrescList(530)
ClassMethod QueryProPrescList(cmRowID) As %String
{
	s drugArr = []
	q:cmRowID="" drugArr.%ToJSON()
	s paramsInfo = $lg(^CKB.PDSS.MonMasterD(+cmRowID),9)
	q:(paramsInfo["程序发生错误")||(paramsInfo["错误详情") drugArr.%ToJSON()
	q:paramsInfo="" drugArr.%ToJSON()

	s outmsgstr=""
	s paramsObj = {}.%FromJSON(paramsInfo)	
	s itemsObj = paramsObj.Drug		// 多个药品obj
	f j=0:1:itemsObj.%Size()-1 d
	.s tmpItmObj = itemsObj.%Get(j)
	.s drugDesc = tmpItmObj.item
	.s drugObj = {}
	.s drugObj.arciId =  ""	// his的编码和描述
	.s drugObj.drugCode = drugDesc	
	.s drugObj.drugDesc = drugDesc
	.s libDrugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugDesc)
	.s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libDrugId)),2)
	.s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugId)),3)
	.s drugObj.libDrugId = libDrugId	 // 知识库的编码和描述
	.s drugObj.libDrugCode = libCode	
	.s drugObj.libDrugDesc = libDesc
	.s drugObj.onceDose = tmpItmObj.OnceDose_tmpItmObj.Unit
	.s drugObj.preMet = tmpItmObj.DrugPreMet
	.s drugObj.freq = tmpItmObj.DrugFreq
	.s drugObj.treatment = tmpItmObj.Treatment
	.d drugArr.%Push(drugObj)
	
	q drugArr.%ToJSON()
}

/// Description:	获取药品审核信息
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-26
/// Input:			审核日志id
/// return:			字符串
/// w ##Class(web.DHCCKBProblemsPresc).GetProMsgInfo(8956893)
ClassMethod GetProMsgInfo(cmRowID)
{
	Q:cmRowID="" "[]"
	s msg = $lg(^CKB.PDSS.MonMasterD(+cmRowID),10)
	q:msg="" "[]"
	q:(msg["程序发生错误")||(msg["错误详情") "[]"
	s msgObj = ##class(%DynamicArray).%FromJSON(msg)	
	q msgObj.%ToJSON()

	Q ""
}

}
