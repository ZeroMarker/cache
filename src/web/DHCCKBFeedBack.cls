Import SQLUser

/// Creator: 		qunianpeng
/// CreateDate: 	2021-03-28
/// Descript: 		安全用药医生、药方信息交互
Class web.DHCCKBFeedBack Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2021-03-28
/// Descript: 		获取医生备注信息(明细)
/// Input:			日志id
/// w ##Class(web.DHCCKBFeedBack).GetDocNotes(msgID)
ClassMethod GetDocNotes(msgID) As %String
{
	n (msgID)
	
	s noteArr = ##class(DHCNewPro.COM.Array).%New()	

	// 使用日志id找到医生评论的备注信息
	q:'$d(^CKB.PDSS.FeedBackI("MsgIDType",+msgID)) noteArr.ToJSON()	

	s userType = "Doc"
	s feedID = ""
	f  s feedID = $o(^CKB.PDSS.FeedBackI("MsgIDType",+msgID,userType,feedID))	q:feedID=""  d
	.s feedData = $g(^CKB.PDSS.FeedBackD(feedID))
	.s status = $lg(feedData,7)
	.q:status'="R"	// 强制审核标记
	.s noteObj = ##class(DHCNewPro.COM.Object).%New()
	.s noteObj.note = $lg(feedData,9) 
	.s noteObj.reasons = $lg(feedData,10)
	.s unique = $lg(feedData,12)
	.s unique = $replace(unique,"||","_")
	.s noteObj.unique = unique
	.d noteArr.Push(noteObj)
	q noteArr.ToJSON()
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-03-28
/// Descript: 		获取医生备注信息
/// Input:			日志id
/// w ##Class(web.DHCCKBFeedBack).GetMonMasterDocNotes(msgID)
ClassMethod GetMonMasterDocNotes(msgID) As %String
{
	n (msgID)
	q:'$d(^CKB.PDSS.MonMasterD(msgID)) ""
	s noteObj = ##class(DHCNewPro.COM.Object).%New()
	s monData = $g(^CKB.PDSS.MonMasterD(msgID))
	s noteObj.notes = $lg(monData,19)
	s noteObj.reasons = $lg(monData,17)
	
	q noteObj.ToJSON()
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript: 		修改强制审核的备注信息和备注原因(一个备注框)
/// Input:			日志id
/// w ##Class(web.DHCCKBFeedBack).UpdateNotesMonMaster(msgID)
ClassMethod UpdateNotesMonMaster(msgID, notes, reason, status) As %String
{
	n (msgID,notes,reason,status)
	
	&SQL(Update CKB_PDSS.MonMaster set CM_AduitNotes=:notes,CM_AduitReason=:reason,CM_PassType=:status Where CM_RowID=:msgID)
	
	q SQLCODE
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript: 		修改反馈信息记录表的备注信息和备注原因(明细多条)
/// Input:			日志id
/// w ##Class(web.DHCCKBFeedBack).UpdateNotesFeedBack(msgID)
ClassMethod UpdateNotesFeedBack(msgID, reasonsArr, status, drugUniqueStr) As %String
{
	n (msgID,reasonsArr,status,drugUniqueStr)
	q:(msgID="")||(reasonsArr="")||(drugUniqueStr="") ""
	
	Ts
	
	s ret = 0
	s len = $length(drugUniqueStr,"!!")
	f i=1:1:len  q:ret'=0  d
	.s uniqueStr = $p(drugUniqueStr,"!!",i)
	.s fbRowID = $p(uniqueStr,"^",1)
	.s arciId = $p(uniqueStr,"^",2)
	.s seqno = $p(uniqueStr,"^",3)
	.s passFlag = $p(uniqueStr,"^",4)
	.s status = $case(passFlag="Y",1:"P",:"R")
	.s linkMsgID = $lg(^CKB.PDSS.FeedBackD(+fbRowID),2)
	.b //1
	.q:msgID'=linkMsgID
	.s unique = $replace(arciId,"||","_")_"_"_seqno
	.s reviewFlag = 0
	.s reasonObjArr = ##class(DHCNewPro.COM.Object).FromJSON(reasonsArr)
	.f k=0:1:reasonObjArr.Size()-1  q:ret'=0  d
	..s reasonObj = reasonObjArr.Get(k)
	..s reason = reasonObj.selectReason
	..s notes = reasonObj.val
	..s reviewUnique = reasonObj.unique
	..;s reasoncomb = reasonObj.reasoncomb
	..b //2
	..q:unique'=reviewUnique 
	..s reviewFlag = 1
	..;&SQL(Update CKB_PDSS.FeedBack set FB_Notes=:notes,FB_Reason=:reason,FB_Status=:status,FB_ReasonCombo=:reasoncomb Where FB_RowID=:fbRowID)
	..&SQL(Update CKB_PDSS.FeedBack set FB_Notes=:notes,FB_Reason=:reason,FB_Status=:status Where FB_RowID=:fbRowID)
	..s ret = SQLCODE
	.
	.i reviewFlag=0 d
	..&SQL(Update CKB_PDSS.FeedBack set FB_Status=:status Where FB_RowID=:fbRowID)
	..s ret = SQLCODE
	
	
	i ret=0 tc
	e  tro
	
	q ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-21
/// Descript: 		修改反馈信息记录表的医嘱id
/// Input:			日志id
/// w ##Class(web.DHCCKBFeedBack).UpdateOeordFeedBack(msgID)
ClassMethod UpdateOeordFeedBack(fbRowID, oeordItemDr, passStatus) As %String
{
	n (fbRowID,oeordItemDr,passStatus)
	
	&SQL(Update CKB_PDSS.FeedBack set FB_OrdItem_Dr=:oeordItemDr, FB_Status=:passStatus Where FB_RowID=:fbRowID)
	
	q SQLCODE
}

/// Creator: 		Shy
/// CreateDate: 	2022-5-11
/// Descript: 		获取强制审核标志
/// Input:			日志id
/// Return:         强制审核：Y  ,未强制审核：N  ,不存在日志：""
/// w ##Class(web.DHCCKBFeedBack).GetPassAuditFlag("8416782")
ClassMethod GetPassAuditFlag(MsgID) As %String
{
	n (MsgID)
	q:MsgID="" ""
	q:'$d(^CKB.PDSS.FeedBackI("MsgIDType",+MsgID)) ""
	s UserType=$o(^CKB.PDSS.FeedBackI("MsgIDType",+MsgID,""))
	s ID=$o(^CKB.PDSS.FeedBackI("MsgIDType",+MsgID,UserType,""))
	s Res="N"
	s:$lg(^CKB.PDSS.FeedBackD(ID),7)="R" Res="Y"
	q Res
}

}
