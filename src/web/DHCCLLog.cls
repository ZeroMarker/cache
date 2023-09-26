Import SQLUser

Class web.DHCCLLog Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindCLCLog() As %Query(ROWSPEC = "tClclogId:%String,tClclogCode:%String,tClclogDesc:%String,tClclogType:%String,tClclogValueList:%String,tClclogValueListDesc:%String,tClclogIfAddInfo:%String,tClclogDefault:%String,tClclogSortNo:%String,tClclogTypeDesc:%String,tClclogIfAddInfoDesc:%String")
{
}

ClassMethod FindCLCLogExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tClclogId=0
	f  s tClclogId=$o(^DHCCLC("Log",tClclogId)) q:tClclogId=""  d
	    .s tClclogCode=$li(^DHCCLC("Log",tClclogId),1)
	    .s tClclogDesc=$li(^DHCCLC("Log",tClclogId),2)
	    .s tClclogType=$li(^DHCCLC("Log",tClclogId),3)
	    .s tClclogTypeDesc=""
	    .i tClclogType="I" s tClclogTypeDesc="重症"
	    .i tClclogType="A" s tClclogTypeDesc="手术"
	    .s tClclogValueList=$li(^DHCCLC("Log",tClclogId),4)
	    .s tClclogValueListDesc=$li(^DHCCLC("Log",tClclogId),5)
	    .s tClclogIfAddInfo=$li(^DHCCLC("Log",tClclogId),6)
	    .s tClclogIfAddInfoDesc=""
	    .i tClclogIfAddInfo=1 s tClclogIfAddInfoDesc="是"
	    .e  s tClclogIfAddInfoDesc="否"
	    .s tClclogDefault=$li(^DHCCLC("Log",tClclogId),7)
	    .s tClclogSortNo=$li(^DHCCLC("Log",tClclogId),8)
	    .d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tClclogId,tClclogCode,tClclogDesc,tClclogType,tClclogValueList,tClclogValueListDesc,tClclogIfAddInfo,tClclogDefault,tClclogSortNo,tClclogTypeDesc,tClclogIfAddInfoDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCLCLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCLogExecute ]
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

ClassMethod FindCLCLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCLogExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod InsertCLCLog(clclogCode, clclogDesc, clclogType, clclogValueList, clclogValueListDesc, clclogIfAddInfo, clclogDefault, clclogSortNo) As %String
{
	q:clclogCode="" "代码不能为空!"
	q:clclogDesc="" "描述不能为空!"
	q:clclogType="" "类型不能为空!"
	s objClclog = ##class(User.DHCCLCLog).%New()
	s objClclog.CLCLOGCode=clclogCode
	s objClclog.CLCLOGDesc=clclogDesc
	s objClclog.CLCLOGType=clclogType
	s objClclog.CLCLOGValueList=clclogValueList
	s objClclog.CLCLOGValueListDesc=clclogValueListDesc
	s objClclog.CLCLOGIfAddInfo=clclogIfAddInfo
	s objClclog.CLCLOGDefault=clclogDefault
	s objClclog.CLCLOGSortNo=clclogSortNo
	s saveStatus=objClclog.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s cllogId=objClclog.%Id()
	d objClclog.%Close()
	q 0
}

ClassMethod UpdateCLCLog(clclogId, clclogCode, clclogDesc, clclogType, clclogValueList, clclogValueListDesc, clclogIfAddInfo, clclogDefault, clclogSortNo) As %String
{
	q:clclogId="" "RowId不能为空!"
	q:clclogCode="" "代码不能为空!"
	q:clclogDesc="" "描述不能为空!"
	q:clclogType="" "类型不能为空!"
	q:'##class(User.DHCCLCLog).%ExistsId(clclogId) "日志码表指针无对应记录!"
	s objClclog = ##class(User.DHCCLCLog).%OpenId(clclogId)
	s objClclog.CLCLOGCode=clclogCode
	s objClclog.CLCLOGDesc=clclogDesc
	s objClclog.CLCLOGType=clclogType
	s objClclog.CLCLOGValueList=clclogValueList
	s objClclog.CLCLOGValueListDesc=clclogValueListDesc
	s objClclog.CLCLOGIfAddInfo=clclogIfAddInfo
	s objClclog.CLCLOGDefault=clclogDefault
	s objClclog.CLCLOGSortNo=clclogSortNo
	s updateStatus=objClclog.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s cllogId=objClclog.%Id()
	d objClclog.%Close()
	q 0
}

ClassMethod DeleteCLCLog(clclogId) As %String
{
	q:clclogId="" "RowId不能为空!"
	q:'##class(User.DHCCLCLog).%ExistsId(clclogId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCCLCLog).%DeleteId(clclogId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

// 获取手术医生

ClassMethod GetOPDOC(opaId) As %String
{
	q:opaId="" ""
	;q ""
	s opd="",docdr=""	
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	i EpisodeID="" q ""
	i anaSub="" q ""
	s i=0
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")!(i=1)  d
	  .s i=i+1   
	  .s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)
	  .i docdr'="" s opd=##class(web.UDHCANOPArrange).GetNameById(docdr)
	q opd
}

ClassMethod GetClcLogId(Id) As %String
{
	q:Id'="" Id
	s tclogId=0,newList=""
	f  s tclogId=$o(^DHCCLC("Log",tclogId)) q:tclogId=""  d
	.i newList'="" s newList=newList_"^"_tclogId
	.e  s newList=tclogId
	q newList
}

/// 以下为日志查询程序
Query FindCLLog(clclogId, fromDate, toDate, logRecordId, tcpip, preValue, postValue) As %Query(ROWSPEC = "tCllogId:%String,tClclogId:%String,tClclogDesc:%String,tLogRecordId:%String,tPreValue:%String,tPreNote:%String,tPostValue:%String,tPostNote:%String,tUpdateUser:%String,tPostQT:%String,tPostYY:%String,tMedCareNo:%String,tPatname:%String,tUpdateDate:%String,tUpdateTime:%String,tUpdateTcpip:%String,tLocdes:%String,tOPDOC:%String,tOpRoom:%String,tOpaSeq:%String,topdate:%String,tCllogIfReceive:%String,opStat:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLLog","FindCLLog","","2017-02-09","2018-03-09","","","","")
ClassMethod FindCLLogExecute(ByRef qHandle As %Binary, clclogId, fromDate, toDate, logRecordId, tcpip, preValue, postValue) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	;s ^TmpDyl("logInput")=clclogId_","_fromDate_","_toDate
 	s admId="",papmiId="",tMedCareNo="",tPatname="",tLocdes="",tOPDOC="",oproomdr="",tOpRoom="",opStat=""
 	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
 	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)
 	s clclogIdList=clclogId
 	i clclogId="" s clclogIdList=..GetClcLogId("")
	f i=1:1:$l(clclogIdList,"^") d
	    .s tClclogId=$p(clclogIdList,"^",i)
	    .q:tClclogId=""
	    .f date=fromDate:1:toDate d
	        ..s tLogRecordId=0
	        ..f  s tLogRecordId=$o(^DHCCLLogI("ClclogDate",tClclogId,date,tLogRecordId)) q:tLogRecordId=""  d
	            ...q:(logRecordId'="")&(logRecordId'=tLogRecordId)
	            ...s tCllogId=0
	            ...f  s tCllogId=$o(^DHCCLLogI("ClclogDate",tClclogId,date,tLogRecordId,tCllogId)) q:tCllogId=""  d
	                ....s tClclogDesc=$li(^DHCCLC("Log",tClclogId),2)
	                ....s tPreValue=$li(^DHCCLLogD(tCllogId),3)
	                ....q:(preValue'="")&(preValue'=tPreValue)
	                ....s tPreNote=$li(^DHCCLLogD(tCllogId),4)
	                ....s tPostValue=$li(^DHCCLLogD(tCllogId),5)
	                ....q:(postValue'="")&(postValue'=tPostValue)
	                ....s tPostJG=""
	                ....s tPostNote=$li(^DHCCLLogD(tCllogId),6)	
	                ....s tClclogCode= $li(^DHCCLC("Log",tClclogId),1)              	       
	                ....i tPostNote'="" s tPostJG=$p(tPostNote,"|",1) //改后结果
	                ....s tPostYYId=""
	                ....i (tClclogId="SubstationAPP")  d	//手术分台申请
		                .....i tPostNote'="" s tPostQT=$p(tPostNote,"|",2) //原因
		                .....i tPostNote'="" s tPostYY=$p(tPostNote,"|",3) //其他
	                ....e  d              
		                .....i tPostNote'="" s tPostYYId=$p(tPostNote,"|",2) //原因
		                .....i tPostYYId'="" s tPostQT=$p($g(^ORC("SUSP",tPostYYId)),"^",2)
		                .....i tPostNote'="" s tPostYY=$p(tPostNote,"|",3) //其他
	                ....s tPostNote=tPostJG
	                ....s tUpdateUserId=$li(^DHCCLLogD(tCllogId),7)
	                ....i tUpdateUserId'="" s tUpdateUser=$p($g(^SSU("SSUSR",tUpdateUserId)),"^",2)
	                ....s tUpdateDatestr=$li(^DHCCLLogD(tCllogId),8)
	                ....i tUpdateDatestr'="" s tUpdateDate=##Class(web.DHCANOPCom).ConvertToDate(tUpdateDatestr)
	                ....s tUpdateTimestr=$li(^DHCCLLogD(tCllogId),9)
	                ....i tUpdateTimestr'="" s tUpdateTime=$zt(tUpdateTimestr,2)
	                ....s tUpdateTcpip=$li(^DHCCLLogD(tCllogId),10)
	                ....q:(tcpip'="")&(tcpip'=tUpdateTcpip)
	                ....;s tCllogIfReceive=$li(^DHCCLLogD(tCllogId),11)
	                ....s tCllogIfReceive=""
	                ....i ((tClclogCode="RefuseOper")||(tClclogCode="CancelOper")||(tClclogCode="SubstationAPP"))  d  //手术ID  手术取消/分台申请
		                .....s admId=$P(^DHCANOPArrange(tLogRecordId),"^",1)
		                .....s stat=$P(^DHCANOPArrange(tLogRecordId),"^",27)
		                .....i stat="F" s opStat="完成"
		                .....i stat="D" s opStat="拒绝"	 
		                .....i stat="C" s opStat="撤销"	 
		                .....i stat="R" s opStat="安排"	             
		                .....i admId'="" s papmiId=$p(^PAADM(admId),"^",1)
		                .....i admId'="" s paadmtype=$p($g(^PAADM(admId)),"^",2)
		                .....i papmiId'="" s tMedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		                .....;i papmiId'="" s tMedCareNo=$p(^PAPER(papmiId,"PAT",1),"^",22) //病案号
		                .....i papmiId'="" s tPatname=$p(^PAPER(papmiId,"ALL"),"^",1)  //病人姓名
		                .....s loc=$p($g(^DHCANOPArrange(tLogRecordId)),"^",54)  
		                .....i loc'="" s tLocdes=$P($g(^CTLOC(loc)),"^",2)  //所在科室
		                .....s tOPDOC=..GetOPDOC(tLogRecordId)  //主刀
		                .....s oproomdr=$P(^DHCANOPArrange(tLogRecordId),"^",20)
		                .....i oproomdr'="" s tOpRoom=$p(^DHCANC("OPRoom",oproomdr),"^",2)  //手术间
		                .....s tOpaSeq=$P(^DHCANOPArrange(tLogRecordId),"^",26)
		                .....s opstdate=$P(^DHCANOPArrange(tLogRecordId),"^",14)  //手术时间
		                .....s opsttime=$P(^DHCANOPArrange(tLogRecordId),"^",15)
		                .....i opsttime'=""  s opsttime=$ZT(opsttime,2)
		                .....s arrTime=$P(^DHCANOPArrange(tLogRecordId),"^",8)
			            .....s arrDate=$P(^DHCANOPArrange(tLogRecordId),"^",7)
			            .....i arrTime'="" s topdate=##Class(web.DHCANOPCom).ConvertToDate(arrDate)_" "_$ZT(arrTime,2) 	//安排时间不为空		      
			            .....e  s topdate=##Class(web.DHCANOPCom).ConvertToDate(opstdate)_" "_opsttime
	                ....i (tClclogCode="DelayOper")   d  //就诊号
		                .....i tLogRecordId'="" s papmiId=$p($g(^PAADM(tLogRecordId)),"^",1) 
		                .....i tLogRecordId'="" s paadmtype=$p($g(^PAADM(tLogRecordId)),"^",2)
		                .....i papmiId'="" s tMedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(tLogRecordId,paadmtype,.ErrMsg)
		                .....;i papmiId'="" s tMedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)  //病案号
		                .....i papmiId'="" s tPatname=$p($g(^PAPER(papmiId,"ALL")),"^",1)  //病人姓名
		                .....s admLocId=$p($g(^PAADM(tLogRecordId)),"^",4)
		                .....i admLocId'="" s tLocdes=$P($g(^CTLOC(admLocId)),"^",2)  //所在科室
		                .....s tOPDOC=""
		                .....s tOpRoom=""
		                .....s tOpaSeq=""
		                .....s topdate=""
	                ....d OutputRow11
	                
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow11
	s Data=$lb(tCllogId,tClclogId,tClclogDesc,tLogRecordId,tPreValue,tPreNote,tPostValue,tPostNote,tUpdateUser,tPostYY,tPostQT,tMedCareNo,tPatname,tUpdateDate,tUpdateTime,tUpdateTcpip,tLocdes,tOPDOC,tOpRoom,tOpaSeq,topdate,tCllogIfReceive,opStat)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCLLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLLogExecute ]
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

ClassMethod FindCLLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLLogExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// 取日志码表

Query LookupCLCLog() As %Query(ROWSPEC = "tClclogId:%String,tClclogDesc:%String")
{
}

ClassMethod LookupCLCLogExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s tClclogId=0
	f  s tClclogId=$o(^DHCCLC("Log",tClclogId)) q:tClclogId=""  d
	    .s tClclogDesc=$li(^DHCCLC("Log",tClclogId),2)
	    .d OutputRow12
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow12
	s Data=$lb(tClclogId,tClclogDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookupCLCLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupCLCLogExecute ]
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

ClassMethod LookupCLCLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupCLCLogExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// 取码表状态

Query LookupCLCLogValue(clclogId) As %Query(ROWSPEC = "tValue:%String,tValueDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLLog","LookupCLCLogValue","5")
ClassMethod LookupCLCLogValueExecute(ByRef qHandle As %Binary, clclogId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s ^TmpDyl("loginid")=clclogId
 	i clclogId'="" d
		.s valueList=$li(^DHCCLC("Log",clclogId),4)
		.s valueListDesc=$li(^DHCCLC("Log",clclogId),5)
		.f i=1:1:$l(valueList,"|")  d
	    	..s tValue=$p(valueList,"|",i)
	    	..q:tValue=""
	    	..s tValueDesc=$p(valueListDesc,"|",i)
	    	..d OutputRow13
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow13
	s Data=$lb(tValue,tValueDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookupCLCLogValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupCLCLogValueExecute ]
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

ClassMethod LookupCLCLogValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupCLCLogValueExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
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
ClassMethod InsertCLLog(clclogId, logRecordId, preValue, preAddNote, postValue, postAddNote, userId, ipAdress) As %String
{
	
	//s ^DHCCLC("Log",1)=$LB("OPAStatus","排班状态","A","A|D|R|F","申请|拒绝|安排|完成","1","","1")
	//w ##class(web.DHCCLLog).InsertCLLog(1,48,"A","申请","D","拒绝",1)
	q:(clclogId="") "日志码表指针不能为空!"
	q:(logRecordId="") "日志记录指针不能为空!"
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

/// Creator：      	mfc
/// CreatDate：    	2013-10-31
/// Description： 	获取日志ID
/// Table：         DHC_CLC_Log
/// Input：        	日志码表clclogCode,日子码表Code 
/// Output：        
/// Return：       	返回表的DHC_CLC_Log的RowId,报错返回具体文字
ClassMethod FindCLCLogForCode(clclogCode) As %String
{
	q:clclogCode="" "代码不能为空!"
	s retStr=""
	s tClclogId=0
	f  s tClclogId=$o(^DHCCLC("Log",tClclogId)) q:tClclogId=""  d
	    .s tClclogCode=$li(^DHCCLC("Log",tClclogId),1)
	    .i tClclogCode=clclogCode s retStr=tClclogId
	q retStr
}

ClassMethod UpdateCLLog(cllogId, cllogIfReceive) As %String
{
	q:cllogId="" "RowId不能为空!"
	q:cllogIfReceive="" "是否处理不能为空"
	q:'##class(User.DHCCLLog).%ExistsId(cllogId) "日志表指针无对应记录!"
	s objCllog = ##class(User.DHCCLLog).%OpenId(cllogId)
	s objCllog.CLLOGIfReceive=cllogIfReceive	
	s updateStatus=objCllog.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	//s cllogId=objCllog.%Id()
	d objCllog.%Close()
	q 0
}

Query FindCLCType() As %Query(ROWSPEC = "Code,Desc")
{
}

ClassMethod FindCLCTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Desc="手术",Code="A"
    d outputCT
    s Desc="重症",Code="I"
    d outputCT
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputCT
 set Data=$lb(Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindCLCTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCLCTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 附加说明

Query FindAddInfo() As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod FindAddInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Desc="是",Id=1
    d outputYN
    s Desc="否",Id=0
    d outputYN
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputYN
 set Data=$lb(Id,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindAddInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAddInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAddInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAddInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
