Import SQLUser

Class web.DHCANCOperAudit Extends %Persistent [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCANCOperAudit","FindOperAuditList","","","","",95)
Query FindOperAuditList(frDate As %String = "", toDate As %String = "", fstatu As %String = "", operdesc As %String = "", appOperLocId As %String = "") As %Query(ROWSPEC = "tAuditId,appUserId,appUser,appLocId,appLoc,appDate,appTime,status,auditUserId,auditUser,auditLocId,auditLoc,auditDate,auditDate,auditTime,operCode,operDesc,operClassDr,operClass,operBladeDr,operBlade,ICDCode,operAlias,declineNote,passNote")
{
}

ClassMethod FindOperAuditListExecute(ByRef qHandle As %Binary, frDate As %String = "", toDate As %String = "", fstatu As %String = "", operdesc As %String = "", appOperLocId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s sDate=##class(web.DHCClinicCom).ConvertToDateH(frDate)
 	s tDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
 	s tAuditId=0
	f  s tAuditId=$o(^User.DHCANCOperAuditD(tAuditId)) q:tAuditId=""  d
	    .q:$d(^User.DHCANCOperAuditD(tAuditId))<1
	    .s appUser="",appLoc="",auditUser="",auditLoc=""
	    .s AuditStr=^User.DHCANCOperAuditD(tAuditId)
	    .s appUserId=$li(AuditStr,1)
	    .;s appUser=$p(^SSU("SSUSR",appUserId),"^",2)
	    .i appUserId'="" s appUser=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",appUserId) //多语言改造翻译后台数据 YL 20221104
    	.s appLocId=$li(AuditStr,2)
	    .q:(appOperLocId'="")&(appOperLocId'=appLocId)
	    .;s appLoc=$p(^CTLOC(appLocId),"^",2)
	    .i appLocId'="" s appLoc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",appLocId) //多语言改造翻译后台数据 YL 20221104
	    .s appDateh=$li(AuditStr,3)
	    .q:(appDateh<sDate)&(frDate'="")
	    .q:(appDateh>tDate)&(toDate'="")
	    .s appDate=##class(web.DHCClinicCom).ConvertToDate(appDateh,"")
	    .s appTimeh=$li(AuditStr,4)
	    .s appTime=$zt(appTimeh,2)
	    .s note=$li(AuditStr,5)	//未用
	    .s statusCode=$li(AuditStr,6)
	    .q:(fstatu'="")&(fstatu'=statusCode)
	    .i statusCode="A" set status="申请"
	    .i statusCode="D" set status="拒绝"
	    .i statusCode="C" set status="撤销"
	    .i statusCode="F" set status="完成"
	    .s auditUserId=$li(AuditStr,7)
	    .s auditUser=""
	    .;i auditUserId'="" s auditUser=$p(^SSU("SSUSR",auditUserId),"^",2)
	    .i auditUserId'="" s auditUser=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",auditUserId) //多语言改造翻译后台数据 YL 20221104
	    .s auditLocId=$li(AuditStr,8)
	    .s auditLoc=""
	    .;i auditLocId'="" s auditLoc=$p(^CTLOC(auditLocId),"^",2)
	    .i auditLocId'="" s auditLoc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",auditLocId) //多语言改造翻译后台数据 YL 20221104
	    .s auditDate=""
	    .s auditDateh=$li(AuditStr,9)
	    .i auditDateh'="" s auditDate=##class(web.DHCClinicCom).ConvertToDate(auditDateh,"")
	    .s auditTime=""
	    .s auditTimeh=$li(AuditStr,10)
	    .i auditTimeh'="" s auditTime=##class(web.DHCClinicCom).ConvertToDate(auditDateh,"")
	    .s auditNote=$li(AuditStr,11)	//未用
	    .s operCode=$li(AuditStr,12)
	    .s operDesc=$li(AuditStr,13)
	    .q:(operDesc'[operdesc)&(operdesc'="")
	    .s operClassDr=$li(AuditStr,14)
	    .s operClass=""
	    .;i operClassDr'="" s operClass=$p(^ORC("CATEG",operClassDr),"^",2)
	    .i operClassDr'="" s operClass=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperationCategory","CATEGDesc",operClassDr) //多语言改造翻译后台数据 YL 20221104
	    .s operBladeDr=$li(AuditStr,15)
	    .s operBlade=""
	    .i operBladeDr'="" s operBlade=$p(^ORC("BLDTP",operBladeDr),"^",2)
	    .s ICDCode=$li(AuditStr,16)
	    .s operType=$li(AuditStr,17)	//未用
	    .s operAlias=$li(AuditStr,18)
	    .s daySurgery=$li(AuditStr,19)	//未用
	    .s bodySiteDr=$li(AuditStr,20) //未用
	    .s positionDr=$li(AuditStr,21)  //未用 
	    .s declineNote=$lg(AuditStr,22)
	    .s passNote=$lg(AuditStr,23)
	    .d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s newDeclineNote=auditNote_" "_declineNote
	s Data=$lb(tAuditId,appUserId,appUser,appLocId,appLoc,appDate,appTime,status,auditUserId,auditUser,auditLocId,auditLoc,auditDate,auditDate,auditTime,operCode,operDesc,operClassDr,operClass,operBladeDr,operBlade,ICDCode,operAlias,newDeclineNote,passNote)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindOperAuditListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperAuditListExecute ]
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

ClassMethod FindOperAuditListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperAuditListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query FindORCOperationCategory() As %SQLQuery(CONTAINID = 1, ROWSPEC = "operCategId:%Integer,operCategLDesc:%String")
{
    select CATEG_RowId,CATEG_Desc from SQLUser.ORC_OperationCategory
}

/// w ##class(web.DHCANCOperAudit).InsertOperAudit("10209^95^test3^test3^test3^test3^19")
ClassMethod InsertOperAudit(AuditStr As %String) As %String
{
	s appUserId=$p(AuditStr,"^",1)
	s appLocId=$p(AuditStr,"^",2)
	s operCode=$p(AuditStr,"^",3)
	s operDesc=$p(AuditStr,"^",4)
	s ICDCode=$p(AuditStr,"^",5)
	s operAlias=$p(AuditStr,"^",6)
	s operClassDr=$p(AuditStr,"^",7)	//19
	s operBladeDr=$p(AuditStr,"^",8)
	
	s objClclog = ##class(User.DHCANCOperAudit).%New()
	s objClclog.ANCOAAppCtcpDr=appUserId
	s objClclog.ANCOAAppDeptDr=appLocId
	s objClclog.ANCOAAppDate=+$h
	s objClclog.ANCOAAppTime=$p($h,",",2)
	;s objClclog.ANCOAAppNote=""
	s objClclog.ANCOAStatus="A"
	;s objClclog.ANCOAAuditCtcpDr=""
	;s objClclog.ANCOAAuditDeptDr=""
	;s objClclog.ANCOAAuditDate=""
	;s objClclog.ANCOAAuditTime=""
	;s objClclog.ANCOAAuditNote=""
	s objClclog.ANCOAOperCode=operCode
	s objClclog.ANCOAOperDesc=operDesc
	s objClclog.ANCOAOperClassDr=operClassDr
	s objClclog.ANCOAOperBladeDr=operBladeDr
	s objClclog.ANCOAOperICD10=ICDCode
	;s objClclog.ANCOAOperIType=clclogValueList
	s objClclog.ANCOAOperIAlias=operAlias
	;s objClclog.ANCOADaySurgery=clclogIfAddInfo
	;s objClclog.ANCOABodySiteDr=clclogDefault
	;s objClclog.ANCOAPositionDr=clclogSortNo
	s saveStatus=objClclog.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s cllogId=objClclog.%Id()
	d objClclog.%Close()
	q 0
}

/// w ##class(web.DHCANCOperAudit).UpdateOperAudit("10209^95^test3^test3^test3^test3^19",1)
ClassMethod UpdateOperAudit(AuditStr As %String, AuditId As %String) As %String
{
	s appUserId=$p(AuditStr,"^",1)
	s appLocId=$p(AuditStr,"^",2)
	s operCode=$p(AuditStr,"^",3)
	s operDesc=$p(AuditStr,"^",4)
	s ICDCode=$p(AuditStr,"^",5)
	s operAlias=$p(AuditStr,"^",6)
	s operClassDr=$p(AuditStr,"^",7)	//19
	s operBladeDr=$p(AuditStr,"^",8)
	
	s objClclog = ##class(User.DHCANCOperAudit).%OpenId(AuditId)
	s objClclog.ANCOAAppCtcpDr=appUserId
	s objClclog.ANCOAAppDeptDr=appLocId
	s objClclog.ANCOAAppDate=+$h
	s objClclog.ANCOAAppTime=$p($h,",",2)
	;s objClclog.ANCOAAppNote=""
	s objClclog.ANCOAStatus="A"
	;s objClclog.ANCOAAuditCtcpDr=""
	;s objClclog.ANCOAAuditDeptDr=""
	;s objClclog.ANCOAAuditDate=""
	;s objClclog.ANCOAAuditTime=""
	;s objClclog.ANCOAAuditNote=""
	s objClclog.ANCOAOperCode=operCode
	s objClclog.ANCOAOperDesc=operDesc
	s objClclog.ANCOAOperClassDr=operClassDr
	s objClclog.ANCOAOperBladeDr=operBladeDr
	s objClclog.ANCOAOperICD10=ICDCode
	;s objClclog.ANCOAOperIType=clclogValueList
	s objClclog.ANCOAOperIAlias=operAlias
	;s objClclog.ANCOADaySurgery=clclogIfAddInfo
	;s objClclog.ANCOABodySiteDr=clclogDefault
	;s objClclog.ANCOAPositionDr=clclogSortNo
	s saveStatus=objClclog.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s cllogId=objClclog.%Id()
	d objClclog.%Close()
	q 0
}

/// w ##class(web.DHCANCOperAudit).DeleteOperAudit(1)
ClassMethod DeleteOperAudit(auditId, AuditStr As %String = "") As %String
{
	q:auditId="" "RowId不能为空!"
	q:'##class(User.DHCANCOperAudit).%ExistsId(auditId) "日志码表指针无对应记录!"
	s objAu = ##class(User.DHCANCOperAudit).%OpenId(auditId)
	
	s objAu.ANCOAStatus="C"
		s saveStatus=objAu.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s auId=objAu.%Id()
	d objAu.%Close()
	q 0
}

/// w ##class(web.DHCANCOperAudit).AuditOper("1^10209^95")
/// 医务科同意
ClassMethod AuditOper(AuditStr)
{
	Set $ZT="ERROR"
	s AuditId=$p(AuditStr,"^",1)
	s auditUserId=$p(AuditStr,"^",2)
	s auditLocId=$p(AuditStr,"^",3)
	s passNote=$p(AuditStr,"^",4)
	s curAuditStr=^User.DHCANCOperAuditD(AuditId)
	;s operCode=$li(curAuditStr,12)
	;s operDesc=$li(curAuditStr,13)
	s operCode=$p(AuditStr,"^",5)
	s operDesc=$p(AuditStr,"^",6)
	s ICDCode=$p(AuditStr,"^",7)
	s alias=$p(AuditStr,"^",8)
	s operClassDr=$p(AuditStr,"^",9)
	s $li(^User.DHCANCOperAuditD(AuditId),16)=ICDCode
	s $li(^User.DHCANCOperAuditD(AuditId),18)=alias
	s $li(^User.DHCANCOperAuditD(AuditId),14)=operClassDr
	s lasrDesc=""
	s lastOperId=$o(^ORC("OPER",0,"Desc",$$ALPHAUP^SSUTIL4(operDesc),""))
	i lastOperId>0 s lasrDesc=$p(^ORC("OPER",lastOperId),"^",2)
	q:(lasrDesc=operDesc)&(lasrDesc'="") "该手术已经存在"
	;s operClassDr=$li(curAuditStr,14)
	s operBladeDr=$li(curAuditStr,15)
	;s ICDCode=$li(curAuditStr,16)
	;s alias=$li(curAuditStr,18)
	k PLIST
	TSTART
	s PLIST(2)=operCode
	s PLIST(3)=operDesc
	s PLIST(6)=+$h
	s PLIST(8)=operClassDr
	s PLIST(15)=ICDCode
	s PLIST(23)="Y"
	&sql(INSERT INTO sqluser.ORC_Operation Values :PLIST())
	i SQLCODE'=0  TRollBack  q "手术字典表错误!"_"/"_SQLCODE
	s operdr=%ROWID
	k PLIST 
	i alias'="" d
		.s PLIST(0)=operdr,PLIST(3)=alias
	    .&sql(INSERT INTO SQLUser.ORC_OperationAlias VALUES :PLIST())
	i SQLCODE'=0  TRollBack  q "手术别名表插入错误!"_"/"_SQLCODE
	
	s objAu = ##class(User.DHCANCOperAudit).%OpenId(AuditId)
	s objAu.ANCOAStatus="F"
	s objAu.ANCOAAuditCtcpDr=auditUserId
	s objAu.ANCOAAuditDeptDr=auditLocId
	s objAu.ANCOAAuditDate=+$h
	s objAu.ANCOAAuditTime=$p($h,",",2)
	s objAu.ANCOAPassReason=passNote
	s saveStatus=objAu.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s auditId=objAu.%Id()
	d objAu.%Close()
	TCOMMIT
	
	q 0
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ;
}

/// 医务科拒绝
ClassMethod DeclineAuditOper(AuditStr)
{
	s AuditId=$p(AuditStr,"^",1)
	s auditUserId=$p(AuditStr,"^",2)
	s auditLocId=$p(AuditStr,"^",3)
	s declineNote=$p(AuditStr,"^",4)
	
	s objAu = ##class(User.DHCANCOperAudit).%OpenId(AuditId)
	s objAu.ANCOAStatus="D"
	s objAu.ANCOAAuditCtcpDr=auditUserId
	s objAu.ANCOAAuditDeptDr=auditLocId
	s objAu.ANCOAAuditDate=+$h
	s objAu.ANCOAAuditTime=$p($h,",",2)
	s objAu.ANCOADeclineReason=declineNote
	s saveStatus=objAu.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s cllogId=objAu.%Id()
	d objAu.%Close()
	q 0
}

}
