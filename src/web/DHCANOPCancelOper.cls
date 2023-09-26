Import SQLUser

Class web.DHCANOPCancelOper Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCANOPCancelOper","FindCancelReason")
Query FindCancelReason() As %Query(ROWSPEC = "Id:%String,Desc:%String,Code:%String")
{
}

ClassMethod FindCancelReasonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s retReasonId=0
	f  s retReasonId=$o(^ORC("SUSP",retReasonId)) q:retReasonId=""  d
		.s Desc=$P(^ORC("SUSP",retReasonId),"^",2)
		.s Code=$P(^ORC("SUSP",retReasonId),"^",1)
		.Do OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow9
	set Data=$lb(retReasonId,Desc,Code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindCancelReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCancelReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCancelReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCancelReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateCancelReason(opaId As %String = "", suspId As %String = "", userId As %String) As %String
{
	q:opaId="" "手术申请Id必须非空!"
	q:suspId="" "手术撤销原因必须非空!"
	s retStr=""
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s newpatstat=$P($g(^DHCANOPArrange(opaId)),"^",27)
	i newpatstat'="S" d
		.
		.s ordId=$o(^OEORDi(0,"Ana",anaId,""))
		.s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
		.s orderId=ordId_"||"_ordSubId
		.s ordStat=""
		.s ordEctStatCode=""
		.s ordEctStatId=$p($g(^OEORD(ordId,"I",ordSubId,"X",1)),"^",16)
		.i ordEctStatId'="" d
			..s ordEctStatCode=$p(^OEC("STAT",ordEctStatId),"^",1)
			..i ordEctStatCode="F" s retStr="该医嘱已执行,无法取消申请"
		.i retStr="" d
			..s ret=##class(appcom.OEOrdItem).CancelMulti(orderId,userId,"","N")
			..i ret'=0 s retStr=ret
			..q:ret'=0
			..s retEMR=""
			..s retEMR=##class(EMRservice.BIEMRService).SetOperation(+anaId,opaId)
			..TSTART
			..&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
			..&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ReturnReason_Dr=:suspId,OPA_Status="C" where opa_rowid=:opaId)
			..i SQLCODE'=0 s retStr="更新手术撤销原因失败!" TROLLBACK
			..i SQLCODE=0 TCOMMIT
	e  d
		.i retStr="" d
			..TSTART
			..&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
			..&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ReturnReason_Dr=:suspId,OPA_Status="C" where opa_rowid=:opaId)
			..i SQLCODE'=0 s retStr="更新手术撤销原因失败!" TROLLBACK
			..i SQLCODE=0 TCOMMIT

	q retStr
}

// w ##class(web.DHCANOPCancelOper).IfInsertLog()

ClassMethod IfInsertLog()
{
	s ret=""
	;暂时设置成N以后可以考虑做到手术申请配置中
	s ret="Y"
	q ret
}

ClassMethod GetCLCLogIdByCode(clclogcode)
{
	s retId=""
	s tClclogId=0
	f  s tClclogId=$o(^DHCCLC("Log",tClclogId)) q:tClclogId=""  d
	    .s tClclogCode=$li(^DHCCLC("Log",tClclogId),1)
	    .q:clclogcode'=tClclogCode
	    .s retId=tClclogId
	  q retId
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-29
/// Description： 	插入日志数据
/// Table：         DHC_CLC_Log,DHC_CL_Log
/// Input：        	日志码表clclogId, 数据记录logRecordId, 改前值preValue(为CLCLOGValueList的代码值), 改前附加信息preAddNote, 
/// 				改后值postValue, 改后附加信息postAddNote, 用户userId
/// 				其中：preValue和postValue为CLCLOGValueList的代码值(以|分割),这样方便检索。
/// 				preAddNote,postValue为CLCLOGValueListDesc对应代码值(以|分割),第一次插入时preValue为空，显示码表CLCLOG_Default值;
/// 				在码表中CLCLOG_IfAddInfo为true时并上附加内容，
/// 				
/// Output：        
/// Return：       	返回表的DHC_CL_Log的RowId,报错返回具体文字
ClassMethod InsertCLLog(clclogcode, logRecordId, preValue, preAddNote, postValue, postAddNote, userId, ipAdress) As %String
{
	
	//s ^DHCCLC("Log",1)=$LB("OPAStatus","排班状态","A","A|D|R|F","申请|拒绝|安排|完成","1","","1")
	//w ##class(web.DHCCLLog).InsertCLLog(1,48,"A","申请","D","拒绝",1)
	//CancelOper
	q:(clclogcode="") "日志码表指针不能为空!"
	s clclogId=..GetCLCLogIdByCode(clclogcode)
	q:(logRecordId="") "手术Id不能为空!"
	i preValue="" s preValue=$P(^DHCANOPArrange(logRecordId),"^",27)
	q:(postValue="") "日志记录当前数据值不能为空!"
	q:(userId="") "操作用户不能为空!"
	q:'##class(User.DHCCLCLog).%ExistsId(clclogId) "日志码表指针无对应记录!"
	s objClclog=##class(User.DHCCLCLog).%OpenId(clclogId)
	s clclogValueList=objClclog.CLCLOGValueList
	s clclogValueListDesc=objClclog.CLCLOGValueListDesc
	s clclogIfAddInfo=objClclog.CLCLOGIfAddInfo
	i 'clclogIfAddInfo s preAddNote="",postAddNote=""
	s preNote=preAddNote,postNote=postAddNote
	
	s pos=0
	i clclogValueList'="" d
	    .i postValue'="" d
	        ..f i=1:1:$l(clclogValueList,"|") d
	            ...i $p(clclogValueList,"|",i)=postValue s pos=i
	        ..i pos>0 s postNote=$p(clclogValueListDesc,"|",pos)
	        ..i postNote'="",postAddNote'="" s postNote=postNote_";"_postAddNote
	    .q:pos=0
	    .i preValue'="" d
	        ..s pos=0
	        ..f i=1:1:$l(clclogValueList,"|") d
	            ...i $p(clclogValueList,"|",i)=preValue s pos=i
	        ..i pos>0 s preNote=$p(clclogValueListDesc,"|",pos)
	        ..i preNote'="",preAddNote'="" s preNote=preNote_";"_preAddNote
	    .e  s preNote=objClclog.CLCLOGDefault
	i (clclogValueList'="")&(pos=0) d objClclog.%Close() q "数值不在日志码表定义列表中!"
	
	s objCllog = ##class(User.DHCCLLog).%New()
	s objCllog.CLLOGCLCLOGDr=objClclog
	s objCllog.CLLOGLogRecordDr=logRecordId
	s objCllog.CLLOGPreValue=preValue
	s objCllog.CLLOGPreNote=preNote
	s objCllog.CLLOGPostValue=postValue
	s objCllog.CLLOGPostNote=postNote
	s objCllog.CLLOGUpdateUserDr=userId
	s objCllog.CLLOGUpdateDate=+$h
	s objCllog.CLLOGUpdateTime=$p($h,",",2)
	s objCllog.CLLOGUpdateTcpip=$zu(67,15,$j)
	s objCllog.CLLOGIfReceive="N"
	s saveStatus=objCllog.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s cllogId=objCllog.%Id()
	d objCllog.%Close()
	d objClclog.%Close()
	q cllogId
}

}
