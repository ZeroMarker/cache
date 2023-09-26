/// 科主任审核授权业务
Class web.DHCANAduitAccredit Extends %RegisteredObject
{

/// Creator：      	杨勤
/// CreatDate：    	2017-10-31
/// Description： 	查找当前登录科室有效范围内的授权信息
/// Table：        	DHC_AN_AduitAccredit
/// Input:			curLocId：当前登录科室
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANAduitAccredit","FindAduitAccreditList","")
Query FindAduitAccreditList(curLocId As %String) As %Query(ROWSPEC = "ANAARowId,ANAACtlocId,ANAACtlocDesc,ANAACtpcpId,ANAACtpcpDesc,ANAAStartDT,ANAAEndDT,ANAACreateUserName,ANAACreateDT")
{
}

ClassMethod FindAduitAccreditListExecute(ByRef qHandle As %Binary, curLocId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s ANAARowId=0
	f  s ANAARowId=$o(^DHCANAduitAccredit(0,"ANAACtlocIdIndex",curLocId,ANAARowId)) q:ANAARowId=""  d
	.s ANAACtlocDesc="",ANAACtpcpDesc=""
	.s ANAACtlocId=$li(^DHCANAduitAccredit(ANAARowId),1)
	.i ANAACtlocId'="" s ANAACtlocDesc=$p(^CTLOC(ANAACtlocId),"^",2)
	.s ANAACtpcpId=$li(^DHCANAduitAccredit(ANAARowId),2)
	.i ANAACtpcpId'="" s ANAACtpcpDesc=$p(^CTPCP(ANAACtpcpId,1),"^",2)
	.s anaStDate=$li(^DHCANAduitAccredit(ANAARowId),3)
	.s anaStTime=$li(^DHCANAduitAccredit(ANAARowId),4)
	.s ANAAStartDT=##Class(web.DHCANOPCom).ConvertToDate(anaStDate)_" "_##Class(web.DHCANOPCom).ConvertToTime(anaStTime)
	.s anaEndDate=$li(^DHCANAduitAccredit(ANAARowId),5)
	.s anaEndTime=$li(^DHCANAduitAccredit(ANAARowId),6)
	.s ANAAEndDT=##Class(web.DHCANOPCom).ConvertToDate(anaEndDate)_" "_##Class(web.DHCANOPCom).ConvertToTime(anaEndTime)
	.s ANAACreateUserId=$li(^DHCANAduitAccredit(ANAARowId),7)
	.i ANAACreateUserId'="" s ANAACreateUserName=$p(^SSU("SSUSR",ANAACreateUserId),"^",2)
	.s ANAACreateDate=$li(^DHCANAduitAccredit(ANAARowId),8)
	.s ANAACreateTime=$li(^DHCANAduitAccredit(ANAARowId),9)
	.s ANAACreateDT=##Class(web.DHCANOPCom).ConvertToDate(ANAACreateDate)_" "_##Class(web.DHCANOPCom).ConvertToTime(ANAACreateTime)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(ANAARowId,ANAACtlocId,ANAACtlocDesc,ANAACtpcpId,ANAACtpcpDesc,ANAAStartDT,ANAAEndDT,ANAACreateUserName,ANAACreateDT)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAduitAccreditListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAduitAccreditListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAduitAccreditListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAduitAccreditListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SaveAduitAccredit(rowId As %String, ctlocId As %String, ctpcpId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, userId As %String) As %String
{
	//s ^TEMPYQ("Aduit")=rowId_"^"_ctlocId_"^"_ctpcpId_"^"_startDate_"^"_startTime_"^"_endDate_"^"_endTime_"^"_userId
	q:ctlocId=""!ctpcpId="" "授权科室和医护人员不能为空！"
	i rowId'="" d
	.i ##class(User.DHCANAduitAccredit).%ExistsId(rowId) d
	..s ANAduitAccredit=##class(User.DHCANAduitAccredit).%OpenId(rowId)
	e  s ANAduitAccredit=##class(User.DHCANAduitAccredit).%New()
	s ANAduitAccredit.ANAACtlocId=##class(User.CTLoc).%OpenId(ctlocId)
	s ANAduitAccredit.ANAACtpcpId=##class(User.CTCareProv).%OpenId(ctpcpId)
	;s ANAduitAccredit.ANAAStartDate=$ZDH(startDate,3)
	s ANAduitAccredit.ANAAStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s ANAduitAccredit.ANAAStartTime=$ZTH(startTime,2)
	;i endDate'="" s ANAduitAccredit.ANAAEndDate=$ZDH(endDate,3)
	i endDate'="" s ANAduitAccredit.ANAAEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	i endTime'="" s ANAduitAccredit.ANAAEndTime=$ZTH(endTime,2)
	s ANAduitAccredit.ANAACreateUserId=##class(User.SSUser).%OpenId(userId)
	s ANAduitAccredit.ANAACreateDate=+$h
	s ANAduitAccredit.ANAACreateTime=$piece($h,",",2)
	d ANAduitAccredit.%Save()
	s result=ANAduitAccredit.%Id()
	q result
}

ClassMethod DeleteAduitAccredit(RowID As %String) As %String
{
	q:RowID="" "删除不能为空！"
	i RowID'=""  d
	.&SQL(delete from sqluser.DHC_AN_AduitAccredit where ANAA_RowId=:RowID)
	q SQLCODE
	;s ANAduitAccredit=##class(User.DHCANAduitAccredit).%OpenId(rowId)
	;s ANAduitAccredit.ANAAEndDate=+$h
	;s ANAduitAccredit.ANAAEndTime=$piece($h,",",2)
	;d ANAduitAccredit.%Save()
	;s result=ANAduitAccredit.%Id()
	q result
}

/// yq 17-11-01 判断是否被授权
ClassMethod IfDirAudit(ctlocId As %String, ctpcpId As %String) As %String
{
	q:ctlocId=""!ctpcpId="" "-1"
	s result=0
	s locId="",ctcareprovId=""
	s audId=$o(^DHCANAduitAccredit(0,"ANAACtlocIdIndex",ctlocId,""))
	q:audId="" "-1"
	s locId=ctlocId
	q:$d(^DHCANAduitAccredit(0,"ANAACtpcpIdIndex",ctpcpId))<0 -1
	;q:ctcareprovId'=ctpcpId "-1"
	s rowId=0
	f  s rowId=$o(^DHCANAduitAccredit(0,"ANAACtlocIdIndex",locId,rowId)) q:rowId=""  d
	.s ANAAStartDate=$li(^DHCANAduitAccredit(rowId),3)
	.s ANAAStartTime=$li(^DHCANAduitAccredit(rowId),4)
	.q:(+$h<ANAAStartDate)!((+$h=ANAAStartDate)&&($p($h,",",2)<ANAAStartTime))
	.s ANAAEndDate=$li(^DHCANAduitAccredit(rowId),5)
	.s ANAAEndTime=$li(^DHCANAduitAccredit(rowId),6)
	.q:(ANAAEndDate'="")&&((+$h>ANAAEndDate)!((+$h=ANAAEndDate)&&($p($h,",",2)>ANAAEndTime)))
	.s result=1
	q result
}

// 判断是否科主任授权，如是，安全组变为科主任审核安全组

// 我##class(web.DHCANAduitAccredit).GetNewGroupIdbyAudit(110,4634,29)

ClassMethod GetNewGroupIdbyAudit(ctlocId As %String, userId As %String, groupId As %String) As %String
{
	q:(ctlocId="")!(userId="") "-1"
	s nGroupId=groupId
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "-1"
	s ifAduit=..IfDirAudit(ctlocId,ctpcpId)
	;b	;
	i ifAduit=1 d
	.s nGroupId=+$g(^DHCCLSet("AnOp","DirAudit"))
	.i nGroupId=0 s nGroupId=groupId
	q nGroupId
}

}
