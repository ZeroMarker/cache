Class web.DHCHM.GetTreeInfo Extends web.DHCHM.Abstract [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.DHCHM.GetTreeInfo","QuestionTree","1")

Query QuestionTree(RecordID As %String = "", Type As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String")
{
}

ClassMethod QuestionTreeExecute(ByRef qHandle As %Binary, RecordID As %String, Type) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	i RecordID="" Quit $$$OK
	s leaf="true"
	s checked="null"
	s sub=0
	f  s sub=$o(^User.DHCHMOQEQuestionD(RecordID,sub)) q:sub=""  d
	.s QID=RecordID_"||"_sub
	.s obj=##class(User.DHCHMOQEQuestion).GetObj(QID)
	.s Status=obj.QEQStatus
	.q:Status="NU"
	.q:((Status="N")||(Status="R"))&&(Type="E")  //评估问卷没有提交的不显示
	.q:((Status'="N")&&(Status'="R"))&&(Type="Q") //问卷录入不是新建或者录入结果的问卷不显示
	.s QDesc=obj.QEQCQuestionnaireDR.QDesc
	.s ID=##class(web.DHCHM.Tools).AddSQM("Q"_QID)
	.s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc_"(内容)")
	.Set Data=$lb(ID,Desc,leaf,checked)
	.Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
	.q:Type="Q"
	.s ID=##class(web.DHCHM.Tools).AddSQM("E"_QID)
	.s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc_"(评估)")
	.Set Data=$lb(ID,Desc,leaf,checked)
	.Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
    .s ID=##class(web.DHCHM.Tools).AddSQM("T"_QID)
	.s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc_"(提示)")
	.Set Data=$lb(ID,Desc,leaf,checked)
	.Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
	quit $$$OK
}

ClassMethod QuestionTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuestionTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuestionTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuestionTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCHM.GetTreeInfo","SQuestionTree","","")

Query SQuestionTree(EvaluationID As %String = "", ServiceClassID As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String")
{
}

ClassMethod SQuestionTreeExecute(ByRef qHandle As %Binary, EvaluationID As %String, ServiceClassID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(EvaluationID="")&&(ServiceClassID="") $$$OK
	s leaf="true"
	s checked="false"
	/*
	s ID=##class(web.DHCHM.Tools).AddSQM(1)
	s Desc=##class(web.DHCHM.Tools).AddSQM("问卷1")
	Set Data=$lb(ID,Desc,leaf,checked)
	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    s ID=##class(web.DHCHM.Tools).AddSQM(2)
	s Desc=##class(web.DHCHM.Tools).AddSQM("问卷2")
	Set Data=$lb(ID,Desc,leaf,checked)
	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    */
	
	i EvaluationID="" d
	.s order=0
	.f  s order=$o(^User.DHCHMCSCQLinkI("SCQLOrderIndex",ServiceClassID,order)) q:order=""  d
	..s sub=0
	..f  s sub=$o(^User.DHCHMCSCQLinkI("SCQLOrderIndex",ServiceClassID,order,sub)) q:sub=""  d
	...s SLID=ServiceClassID_"||"_sub
	...s obj=##class(User.DHCHMCSCQLink).GetObj(SLID)
	...s ID=obj.SCQLCQuestionnaireDR.%Id()
	...s QDesc=obj.SCQLCQuestionnaireDR.QDesc
	...s ID=##class(web.DHCHM.Tools).AddSQM(ID)
	...s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc)
	...Set Data=$lb(ID,Desc,leaf,checked)
	...s ^CacheTemp(repid,ind)=Data
	...Set ind=ind+1
	e  d
	.s sub=0
	.f  s sub=$o(^User.DHCHMOQEQuestionD(EvaluationID,sub)) q:sub=""  d
	..s QID=EvaluationID_"||"_sub
	..s obj=##class(User.DHCHMOQEQuestion).GetObj(QID)
	..s Status=obj.QEQStatus
	..s checked="false"
	..s:Status'="NU" checked="true"
	..s QDesc=obj.QEQCQuestionnaireDR.QDesc
	..s ID=obj.QEQCQuestionnaireDR.%Id()
	..s ID=##class(web.DHCHM.Tools).AddSQM(ID)
	..s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc)
	..Set Data=$lb(ID,Desc,leaf,checked)
	..s ^CacheTemp(repid,ind)=Data
	..Set ind=ind+1
	quit $$$OK
}

ClassMethod SQuestionTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SQuestionTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SQuestionTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SQuestionTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Descript:基础代码维护 树结构
/// Creater:	王国营
/// CreateDate:	2019-04-30
/// Input:
/// Return：
/// Debug:w ##class(web.DHCHM.GetTreeInfo).GetCTCOdeTreeJson("1001")
ClassMethod GetCTCOdeTreeJson(CodeType)
{
	q:CodeType="" ""
	s TreeObj=##class(web.DHCPE.HM.Entity.TreeRoot).%New()
	s TreeObj.id="AllCode"
	s TreeObj.text="基础代码分类"
	;s TreeObj.iconCls="icon-add"
	s Ordersub="" 
	f  s Ordersub=$o(^User.DHCHMCSettingI("STypeCodeIndex",$C(32)_CodeType,Ordersub)) q:Ordersub=""  d
	.s ID=0
	.f  s ID=$o(^User.DHCHMCSettingI("STypeCodeIndex",$C(32)_CodeType,Ordersub,ID))  quit:ID=""  d
	..s Obj=##class(User.DHCHMCSetting).%OpenId(ID)
	..q:Obj.SValue'="Y"
	..s SCode=Obj.SCode
	..s SCRemark=Obj.SRemark
	..s NodeObj=##class(web.DHCPE.HM.Entity.TreeNode).%New()
	..s NodeObj.id=SCode
	..s NodeObj.text=SCRemark
	..;s NodeObj.iconCls="icon-star-yellow"
	..d TreeObj.children.Insert(NodeObj)
	s RetJson=##class(ext.util.JsonObject).ObjToJson(TreeObj)
	q "["_RetJson_"]"
}

/// Descript: 健康评估 树结构
/// Creater:	王国营
/// CreateDate:	2019-04-30
/// Input:
/// 						RecordID:评估记录ID
/// 						Type: E 评估界面   Q 问卷录入界面
/// Return：
/// Debug:w ##class(web.DHCHM.GetTreeInfo).GetQuestionTreeJson("54","E")
ClassMethod GetQuestionTreeJson(RecordID, Type)
{
	s TreeObj=##class(web.DHCPE.HM.Entity.TreeRoot).%New()
	s TreeObj.id="QuestionRoot"
	s TreeObj.text="问卷信息"
	s TreeObj.iconCls="icon-write-order"
	i RecordID'=""
	{
		s sub=0
		f  s sub=$o(^User.DHCHMOQEQuestionD(RecordID,sub)) q:sub=""  d
		.s QID=RecordID_"||"_sub
		.s obj=##class(User.DHCHMOQEQuestion).GetObj(QID)
		.s Status=obj.QEQStatus
		.q:Status="NU"

		.q:((Status="N")||(Status="R"))&&(Type="E")  //评估问卷没有提交的不显示
		.q:((Status'="N")&&(Status'="R"))&&(Type="Q") //问卷录入不是新建或者录入结果的问卷不显示
		.s QDesc=obj.QEQCQuestionnaireDR.QDesc
		.s ID=##class(web.DHCHM.Tools).AddSQM("Q"_QID)
		.s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc_"(内容)")
		.s NodeObj=##class(web.DHCPE.HM.Entity.TreeNode).%New()
		.s NodeObj.id=ID
		.s NodeObj.text=Desc
		.s NodeObj.iconCls="icon-star-empty"
		.d:Type="Q" TreeObj.children.Insert(NodeObj)
		
		.q:Type="Q"
		.s QuesNodeObj=##class(web.DHCPE.HM.Entity.TreeNode).%New()
		.s QuesNodeObj.id="Question"_QID
		.s QuesNodeObj.text=QDesc

		.s QuesNodeObj.iconCls="icon-paper-table"
		.d QuesNodeObj.children.Insert(NodeObj)
		.s ID=##class(web.DHCHM.Tools).AddSQM("E"_QID)
		.s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc_"(评估)")
		.s NodeObj=##class(web.DHCPE.HM.Entity.TreeNode).%New()
		.s NodeObj.id=ID
		.s NodeObj.text=Desc
		.s NodeObj.iconCls="icon-star-light-yellow"
		.d QuesNodeObj.children.Insert(NodeObj)	
		
    	.s ID=##class(web.DHCHM.Tools).AddSQM("T"_QID)
		.s Desc=##class(web.DHCHM.Tools).AddSQM(QDesc_"(提示)")
		.s NodeObj=##class(web.DHCPE.HM.Entity.TreeNode).%New()
		.s NodeObj.id=ID
		.s NodeObj.text=Desc
		.s NodeObj.iconCls="icon-star-yellow"
		.d QuesNodeObj.children.Insert(NodeObj)
		.d TreeObj.children.Insert(QuesNodeObj)	
		
		
		.//问诊节点
		.s InquiryObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
		.s InquiryObj.id = "I"_QID
		.s InquiryObj.text = QDesc_"(问诊结果)"
		.s InquiryObj.iconCls="icon-star"
		.d QuesNodeObj.children.Insert(InquiryObj)
	}
	
	s RetJson=##class(web.DHCPE.Utils.JsonObject).ObjToJson(TreeObj)	
	q "["_RetJson_"]"
}

}
