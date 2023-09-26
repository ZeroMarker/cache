/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 医生站交班本公共类
Class web.DHCDocPassWorkC1 Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 获取上一个班次填写过交班信息得病人
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).GetPrevBCHasFillPatient("N","2019-05-22","95")
ClassMethod GetPrevBCHasFillPatient(BCode As %String, SelectDate As %String, CurrentLoc As %String) As %String
{
	n (BCode,SelectDate,CurrentLoc)
	s mRtn = ""
	
	q:(BCode="")||(SelectDate="")||(CurrentLoc="") mRtn
	s SelectDate = ..%ZDH(SelectDate)
	s CPwid = $o(^DDPW(0,"LocDateType",CurrentLoc,SelectDate,BCode,""))
	;q:CPwid="" mRtn
	if (CPwid'="") {
		s SlectSeqno = $p(^DDPW(CPwid),"^",16)
	} else {
		s bcid=$o(^CF.Doc.PWBCI("BCCode",BCode,""))
		q:bcid=""
		s SlectSeqno = $p(^CF.Doc.PWBC(bcid),"^",8)
	}
	s PrevDate = SelectDate
	s PrevSeqno = $o(^CF.Doc.PWBCI("Seqno",SlectSeqno),-1)
	i PrevSeqno = "" s PrevSeqno = $o(^CF.Doc.PWBCI("Seqno",""),-1),PrevDate=PrevDate-1
	s PrevBCId = $o(^CF.Doc.PWBCI("Seqno",PrevSeqno,""))
	q:PrevBCId="" mRtn
	s PrevBCode = $p(^CF.Doc.PWBC(PrevBCId),"^",1)
	s Pwid = $o(^DDPW(0,"LocDateType",CurrentLoc,PrevDate,PrevBCode,""))
	q:Pwid="" mRtn
	
	s Admid = ""
	f  s Admid = $o(^DDPW(0,"AdmLocDate",Admid)) q:Admid=""  d
	.s Itemid = "", findFlag=0
	.f  s Itemid = $o(^DDPW(0,"AdmLocDate",Admid,CurrentLoc,PrevDate,Pwid,Itemid)) q:(Itemid="")||(findFlag=1)  d
	..s itemType = $p(^DDPW(Pwid,"Detail",Itemid),"^",1)
	..s isNeedDisplay = $p(^CF.OPDoc.PW("WKType",itemType),"^",2)
	..q:isNeedDisplay'=1
	..s itemPatType = $p(^CF.OPDoc.PW("WKType",itemType),"^",1)
	..s itemBCUser = $p(^DDPW(Pwid,"Detail",Itemid),"^",8)
	..s itemBContent = $p(^DDPW(Pwid,"Detail",Itemid),"^",5)
	..i itemBContent'="" d
	...i mRtn="" s mRtn = Admid
	...e  s mRtn=mRtn_","_Admid
	...s findFlag=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 判断病重
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).IsSeriouslyIll("243")
ClassMethod IsSeriouslyIll(EpisodeID) As %String [ ProcedureBlock = 1 ]
{
	//n (EpisodeID)
	Quit:EpisodeID="" ""
	set val = ..%IsValidMethod("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"SERIOUSLY")
	}
	Quit img
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 判断病危
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).IsCriticallyIll(7)
ClassMethod IsCriticallyIll(EpisodeID) As %String [ ProcedureBlock = 1 ]
{
	//n (EpisodeID)
	Quit:EpisodeID="" ""
	Set val = ..%IsValidMethod("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"CRITICALLY")
	}
	Quit img
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 交班本内容显示特殊字符处理
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).ShowContentHtml()
ClassMethod ShowContentHtml(value) As %String [ ProcedureBlock = 1 ]
{
	//n (EpisodeID)
	s value=##class(web.DHCDocPassWork).ReplaceStr(value,",","，")
	//解析回车符
	s value=##class(web.DHCDocPassWork).ReplaceStr(value,$C(10),"&#13;")
	q value
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 交班本内容显示特殊字符处理
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).GetOperNameByAdmid()
ClassMethod GetOperNameByAdmid(EpisodeID) As %String
{
	n (EpisodeID)
	s mRtn=""
	Set opaAdmDr=EpisodeID
	s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	.s OPAStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:((OPAStatus="D"))
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0 
	.Set opName="",operCut="" 
	.Set operLocId=""
	.f  s anaopSub=$O(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	..s curOperId=$P(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub),"^",6)
	..q:curOperId=""
	..if $D(^ORC("OPER",curOperId)) d
	...i opName="" s opName=$P(^ORC("OPER",curOperId),"^",2)
	...e  s opName=$G(opName)_","_$P(^ORC("OPER",curOperId),"^",2)
	.i mRtn="" s mRtn=opName
	.e  s mRtn=mRtn_","_opName
   	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 获取所有有效的病人类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).GetAllPatType()
ClassMethod GetAllPatType() As %String
{
	n 
	k ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j)
	s mRtn=""
	s code=""
	f  s code=$o(^CF.OPDoc.PW("WKType",code)) q:code=""  d
	.s desc=$p(^CF.OPDoc.PW("WKType",code),"^",1)
	.s isDisplay=$p(^CF.OPDoc.PW("WKType",code),"^",2)
	.q:isDisplay'=1
	.s disNo=$p(^CF.OPDoc.PW("WKType",code),"^",3)
	.i disNo="" s disNo="999"
	.s tplURL=$p(^CF.OPDoc.PW("WKType",code),"^",4)
	.s wh=$p(^CF.OPDoc.PW("WKType",code),"^",5)
	.s ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)=$lb(code,desc,isDisplay,disNo,tplURL,wh)
	
	s disNo=""
	f  s disNo=$o(^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo)) q:disNo=""  d
	.s code=""
	.f  s code=$o(^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)) q:code=""  d
	..i mRtn="" s mRtn=code
	..e  s mRtn=mRtn_"^"_code
	
	k ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-01-21
/// DESC: 交班本内容显示特殊字符处理
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).ShowContentHtml()
ClassMethod PrintContentHtml(value) As %String [ ProcedureBlock = 1 ]
{
	//n (EpisodeID)
	s value=##class(web.DHCDocPassWork).ReplaceStr(value,",","，")
	//解析回车符
	s value=##class(web.DHCDocPassWork).ReplaceStr(value,$C(10),"<br/>")
	q value
}

/// CTOR: QP
/// DATE: 2020-10-28
/// DESC: 将XML指定节点+1
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).PlusXML("CritiNum","<PW><CritiNum>1</CritiNum></PW>")
ClassMethod PlusXML(Node, XML) As %String
{
	n (Node,XML)
	s sNode="<"_Node_">"
	s eNode="</"_Node_">"
	s preSub=$p(XML,sNode,1)
	s afterStr=$p(XML,sNode,2)
	s num=$p(afterStr,eNode,1)
	s afterSub=$p(afterStr,eNode,2)
	i num="" s num=1
	e  s num=num+1
	s centerSub=sNode_num_eNode
	s mRtn=preSub_centerSub_afterSub
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-28
/// DESC: 将XML指定节点-1
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkC1).SubXML("CritiNum","<PW><CritiNum></CritiNum></PW>")
ClassMethod SubXML(Node, XML) As %String
{
	n (Node,XML)
	s sNode="<"_Node_">"
	s eNode="</"_Node_">"
	s preSub=$p(XML,sNode,1)
	s afterStr=$p(XML,sNode,2)
	s num=$p(afterStr,eNode,1)
	s afterSub=$p(afterStr,eNode,2)
	i (num="")||(num=0) s num=0
	e  s num=num-1
	s centerSub=sNode_num_eNode
	s mRtn=preSub_centerSub_afterSub
	
	Q mRtn
}

}
