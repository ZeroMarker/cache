Import SQLUser

Class web.DHCANOPArrange Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 得到手术间按次序应安排的台次
ClassMethod GetOpRoomOrder(opDate As %String = "", roomId As %String = "", opaId As %String = "", maxNo As %String = "")
{
      //s ^TMPzt("testStr")=opDate_"/"_roomId_"/"_opaId_"/"_maxNo
      q:roomId="" ""
      q:opaId="" ""
      k ^TMPOPArr
      k ^TMPOPSort
      ;i opDate'="" s nowDate=$ZDH(opDate,3)
      i opDate'="" s nowDate=##Class(web.DHCANOPCom).ConvertToDateH(opDate)
	  e  s nowDate=+$H
	  s cacheOpDate=$P(^DHCANOPArrange(opaId),"^",14)
	  q:nowDate'=cacheOpDate "前台时间和后台时间不一致"
	  f i=1:1:maxNo d
	  .s ^TMPOPArr(i)=i
      s rowId=""
	  f  s rowId=$O(^DHCANOPArrange(0,"SDate",nowDate,rowId)) q:(rowId="")  d
	    .q:rowId=opaId
	    .s status=$P(^DHCANOPArrange(rowId),"^",27)
	    .q:status="D"
		.s opRoomId=$P($G(^DHCANOPArrange(rowId)),"^",20)
        .q:(opRoomId="")!(opRoomId'=roomId)
        .s ordNo=$P(^DHCANOPArrange(rowId),"^",26)
        .q:ordNo=""
        .s ^TMPOPArr(ordNo)=0
      s n=""
      f  s n=$o(^TMPOPArr(n)) q:n=""  d
      .s r=+$g(^TMPOPArr(n))
      .q:r=0
      .s ^TMPOPSort(r)=r
      s min=$o(^TMPOPSort(""))
      q min
}

/// 更新手术申请的手术间和台次
ClassMethod UpdateOpRoomAndOrdNo(opaId As %String = "", roomId As %String = "", maxNo As %String = "", opDate As %String = "") As %String
{
	s opaId=+opaId
	q:(opaId=0)!(opaId="") "手术申请不存在!"
	q:roomId="" "未安排手术间!"
    s ordNo=..GetOpRoomOrder(opDate,roomId,opaId,maxNo)
    s ordNo=+ordNo
    q:ordNo=0 "自动计算台次错误"
	s retStr=""
	s userId=%session.Data("LOGON.USERID")
	TSTART
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_OpRoom_dr=:roomId,OPA_seq=:ordNo where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="更新手术间和台次失败!"
	i SQLCODE'=0 TROLLBACK  q retStr
	s opaRoom="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opstTime=""
	s opId=opaId
	s opaRoom=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	i opaRoom="" q "无此手术间"
	i ordNo'="" d
		.s retStr=..UpdateAnOpStatus(opId,"R")
		.i retStr="-1" s retStr="更新状态失败!" TROLLBACK
		.e  d
			..		//20181207+dyl
			..s anaId=$p(^DHCANOPArrange(opaId),"^",2)
			..s ordId=$o(^OEORDi(0,"Ana",anaId,""))
			..s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
			..s orderret=##class(appcom.OEOrdItem).Execute(ordId_"||"_ordSubId,userId)
			..s arrangeDate=+$h,arrangeTime=$p($h,",",2)
		    ..&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ArrangeUser_Dr=:userId,OPA_ArrangeDate=:arrangeDate,OPA_ArrangeTime=:arrangeTime where opa_rowid=:opaId)
	q:retStr'="0" retStr
	i retStr="0" TCOMMIT
    ;s retSameRoom=..SameRoomOrderAndSort(opaId,roomId,ordNo)
	;不再使用
	;s retStr=##class(web.DHCANArrange).SendMessage(opId,opaRoom,ordNo,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime)
	;i retStr="-1" TROLLBACK  q "发送消息失败!"
	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONSCHEDULEINFO",opaId)
		.;s ^tmpDYL("ANOPARRR",opaId)=OAret
	q ordNo
}

/// 清空手术间和台次
ClassMethod ClearOpRoom(opaIdStr As %String = "", userId As %String) As %String
{
	q:opaIdStr="" "无手术申请记录"
	s strLen=$L(opaIdStr,"^")
	q:strLen=0
	s retStr=""
	TSTART
	f i=1:1:strLen
	{
	s opaId=$p(opaIdStr,"^",i)
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_OpRoom_dr=:null,OPA_seq=:null where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="更新手术间和台次失败!"
	i SQLCODE'=0 TROLLBACK  q 
	s opaRoom="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opstTime=""
	s opId=opaId
    s ordNo=""
	s retStr=..UpdateAnOpStatus(opId,"A")
	i retStr="-1" s retStr="更新状态失败!" TROLLBACK
	q:retStr'="0" 
		s anaId=$p(^DHCANOPArrange(opId),"^",2)
	s ordId=$o(^OEORDi(0,"Ana",anaId,""))
	s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
	
	s cancelret=##class(appcom.OEOrdItem).Verify(ordId_"||"_ordSubId,userId)
	}
	i retStr="0" TCOMMIT 
	q retStr
}

/// 更新手术申请的台次
ClassMethod UpdateOpaSeqNo(opaId As %String = "", opaSeqNo As %String = "", opDate As %String = "") As %String
{
	s opaId=+opaId
	q:(opaId=0)!(opaId="") "手术申请不存在!"
	s opaSeqNo=+opaSeqNo
	q:opaSeqNo=0 "台次输入不合法!"
	s roomId=$P($G(^DHCANOPArrange(opaId)),"^",20)
	q:roomId="" "未安排手术间!"
	s flag=..GetFlagRoomSeqNo(roomId,opaSeqNo,opDate)
	q:flag=1 "手术间台次重复!"
	s retStr=""
	TSTART
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_seq=:opaSeqNo where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="更新台次失败!"
	i SQLCODE'=0 TROLLBACK
	
	s opaRoom="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opstTime=""
	s opId=opaId
	s opaRoom=$p(^DHCANC("OPRoom",roomId),"^",2)
	i opaSeqNo'="" d
		.s retStr=..UpdateAnOpStatus(opId,"R")
		.i retStr="-1" s retStr="更新状态失败!" TROLLBACK
	q:retStr'="0" retStr
	i retStr="0" TCOMMIT
	q retStr
}

/// 判断手术间内台次是否重复
ClassMethod GetFlagRoomSeqNo(roomId As %String = "", opaSeqNo As %String = "", opDate As %String = "") As %String
{
	s retFlag=0
	q:roomId="" 2
	q:opaSeqNo="" 3
	s dateformatnum=##class(websys.Conversions).DateFormat()
	i opDate'="" s nowDate=$ZDH(opDate,dateformatnum)
	e  s nowDate=+$H
	s rowId=""
	f  s rowId=$O(^DHCANOPArrange(0,"SDate",nowDate,rowId)) q:(rowId="")  d
		.s opRoomId=$P($G(^DHCANOPArrange(rowId)),"^",20)
		.q:(opRoomId="")!(opRoomId'=roomId)
		.s seqNo=$P($G(^DHCANOPArrange(rowId)),"^",26)
		.i (seqNo'="")&(opaSeqNo=seqNo) s retFlag=1
	q retFlag
}

ClassMethod UpdateAnOpStatus(opaId, status) As %String
{
	q:(opaId="")||(status="") "手术申请Id和手术状态必须非空"
	s SQLCODE=-1
	TSTART
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	s PLIST(20)=status
	i status="D" d
		.s PLIST(22)="C"
	    .s PLIST(5)=""
	    .s PLIST(6)=""
    i (status="A")&(PLIST(22)="G") s PLIST(22)="M"
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE'=0  TROLLBACK
	i SQLCODE=0 TCOMMIT
	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.;20161229+dyl+向电子病历发送消息
		.s adm=$p(^DHCANOPArrange(opaId),"^",1)
		.;s retEMR=""
		.;s retEMR=##class(EMRservice.BIEMRService).SetOperation(adm,opaId)
		.i status="R" d
			..;获取用户
			..s userId=%session.Data("LOGON.USERID")
			..s admId=$p(^DHCANOPArrange(opaId),"^",1)
			..s anaId=$p(^DHCANOPArrange(opaId),"^",2)
			..s ordId=$o(^OEORDi(0,"Ana",anaId,""))
			..s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
			..Set rtnMes =##class(websys.DHCMessageInterface).Send("手术通知", "1039", userId, admId , ordId_"||"_ordSubId , "" , "opaId:"_opaId)

	q SQLCODE
}

ClassMethod ChangeAnopStat(status, opaIdStr) As %String
{
	q:(opaIdStr="")||(status="") "手术申请Id和手术状态必须非空!"
	s strLen=$L(opaIdStr,"^")
	s refROPGroup=$g(^DHCCLSet("AnOp","OpDirAuditlist"))
	s groupId=%session.Data("LOGON.GROUPID")
	s userId=%session.Data("LOGON.USERID")
	s retStr=0
	TSTART
    f i=1:1:strLen 
    {
	 s opaId=$p(opaIdStr,"^",i)
	 q:opaId=""
     s opId=opaId
	 s originalStatus=$P(^DHCANOPArrange(opaId),"^",27)
     i (originalStatus="R")&(("^"_refROPGroup_"^")'[("^"_groupId_"^"))&(refROPGroup'="")&(status="D") s retStr="没有权限拒绝状态为安排的手术，请重新勾选!" q
	s admId=$p(^DHCANOPArrange(opId),"^",1)
	s anaId=$p(^DHCANOPArrange(opId),"^",2)
	s ordId=$o(^OEORDi(0,"Ana",anaId,""))
	s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
	s appLocId=$p($g(^DHCANOPArrange(opId)),"^",54)
	
	s orderId=ordId_"||"_ordSubId
	s ordStat=""
	
	s ordEctStatCode=""
	s ordStatId=$p($g(^OEORD(ordId,"I",ordSubId,"X",1)),"^",16)
	i ordStatId'="" d
		.s ordEctStatCode=$p(^OEC("STAT",ordStatId),"^",1)
	i (status="A")&&((ordEctStatCode="D")||(ordEctStatCode="U")||(ordEctStatCode="C")) d
	.s retStr="该医嘱已撤销或者作废,无法恢复为申请状态"
	i (status="D")&&((ordEctStatCode="F")) d
		.s retStr="该医嘱已执行,无法取消"
	q:retStr'=0
     s retStr=..UpdateAnOpStatus(opId,status)
	 i retStr="-1" s retStr="更新状态失败!" TROLLBACK
	 q:retStr'="0"  
	 ;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
	 	.;20161229+dyl+向电子病历发送消息
		.s adm=$p(^DHCANOPArrange(opaId),"^",1)
		.;s retEMR=""
		.;
		 .i status="D" d 
			  ..s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONSCHEDULEINFO",opaId)
			  ..s userId=%session.Data("LOGON.USERID")
			  ..;获取用户
			  ..Set rtnMes =##class(websys.DHCMessageInterface).Send("手术拒绝", "1054", userId, admId, ordId_"||"_ordSubId , "To用户Id", "opaId为"_opId,appLocId)
			  ..s retEMR=##class(EMRservice.BIEMRService).SetOperation(admId,opId)
			  ..;20181207+dyl
			  ..s orderret=##class(appcom.OEOrdItem).Verify(ordId_"||"_ordSubId,userId)

    }
	i retStr="0" TCOMMIT
	q retStr
}

ClassMethod GetGroupId(type)
{
	i type="DirAudit" d
	.s groupIdStr=^DHCCLSet("AnOp","DirAudit")
	i type="AnDirAudit" d
	.s groupIdStr=^DHCCLSet("AnOp","AnDirAuditlist")
	q groupIdStr
}

ClassMethod SetAnOpDirAudit(opaIdStr As %String, groupId As %String) As %String
{
	i opaIdStr="" q "病人Id不能为空!"
	s dirAuditGroupIdStr=^DHCCLSet("AnOp","DirAudit")
	i dirAuditGroupIdStr="" q "没有设置审核的安全组"
	;i ("^"_dirAuditGroupIdStr_"^")'[("^"_groupId_"^") q "没有审核的权限"
	s dirAuditTime=$p($g(^DHCCLSet("AnOp","DirAuditTime")),"^")
	i dirAuditTime'="" d
	.s dirAuditTime=$zth($p(dirAuditTime,"!"),3)
	s retStr=""
	i (dirAuditTime<$p($h,",",2))&(dirAuditTime'="") s retStr="已过审核时间，不能审核"
	;s retStrExtra=0
	;i (retStr'=0) d
	.;s ctlocId=%session.Data("LOGON.CTLOCID")
	.;s retStrExtra=##class(web.DHCANOPCom).IfExceedExtraLimit(ctlocId,"Y")
	;q:(retStr'=0)&(retStrExtra<0) retStr
	;q:(retStr'=0)&(retStrExtra'=0) retStrExtra
    s userId=%session.Data("LOGON.USERID")
   	s strLen=$L(opaIdStr,"^")	
    f i=1:1:strLen d
	.s opaId=$p(opaIdStr,"^",i)
	.q:opaId=""
	.s originalStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.s opAppDate=$P(^DHCANOPArrange(opaId),"^",3)
 	.;i (opAppDate=+$h)&(originalStatus="") s retStr="当天不能审核申请在当天的手术!" q
 	.s weekDay=$zd(opAppDate,10)
 	.i ((weekDay=6)!(weekDay=0)&&($d(^DHCANCAPPDATE(opAppDate))=0)) s retStr="不能审核申请在周六日的手术" q
 	.i ('((weekDay=6)!(weekDay=0))&&($d(^DHCANCAPPDATE(opAppDate))>0)) s retStr="不能审核申请在节假日的手术" q
    .s opId=opaId
    .s retStr=..UpdateAnOpStatus(opId,"A")
    .i retStr="0" d
	..s $p(^DHCANOPArrange(opaId,"Ext"),"^",14)=userId
	..s $p(^DHCANOPArrange(opaId,"Ext"),"^",15)=+$h
	..s $p(^DHCANOPArrange(opaId,"Ext"),"^",16)=+$p($h,",",2)
	q retStr
}

// d ##class(%ResultSet).RunQuery("web.DHCANOPArrange","SSGROUP","")

Query SSGROUP(desc As %String) As %Query(ROWSPEC = "Group:%String,ID:%String")
{
}

ClassMethod SSGROUPExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rw=""  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
 	.q:rw=0
 	.s GrpDesc=$P(^SSU("SSGRP",rw),"^",1)
 	.q:(GrpDesc'[desc)&(desc'="")
    .d Output4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4
	s Data=$lb(GrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod SSGROUPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSGROUPExecute ]
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

ClassMethod SSGROUPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSGROUPExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query GetAllCaption(typeCode As %String = "") As %Query(ROWSPEC = "code:%String,desc:%String,type:%String")
{
}

ClassMethod GetAllCaptionExecute(ByRef qHandle As %Binary, typeCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rw=""  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
 	.q:rw=0
 	.s GrpDesc=$P(^SSU("SSGRP",rw),"^",1)
 	.q:(GrpDesc'[desc)&(desc'="")
    .d Output4d2
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4d2
	s Data=$lb(GrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAllCaptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllCaptionExecute ]
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

ClassMethod GetAllCaptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllCaptionExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query GetCurCaption(typeCode As %String = "", groupId As %String = "") As %Query(ROWSPEC = "code:%String,desc:%String,type:%String")
{
}

ClassMethod GetCurCaptionExecute(ByRef qHandle As %Binary, typeCode As %String = "", groupId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rw=""  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
 	.q:rw=0
 	.s GrpDesc=$P(^SSU("SSGRP",rw),"^",1)
 	.q:(GrpDesc'[desc)&(desc'="")
    .d Output4d
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4d
	s Data=$lb(GrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCurCaptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCurCaptionExecute ]
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

ClassMethod GetCurCaptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCurCaptionExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCANOPArrange","GetGroupConfig","","")

Query GetGroupConfig(typeCode As %String = "", groupId As %String = "") As %Query(ROWSPEC = "rowId:%String,groupId:%String,groupDesc:%String,name:%String,caption:%String,typeCode:%String,type:%String")
{
}

ClassMethod GetGroupConfigExecute(ByRef qHandle As %Binary, typeCode As %String = "", groupId As %String = "") As %Status
{
 	 Set repid=$I(^CacheTemp)
 	 If $g(ind)="" Set ind=1
 	 ;k ^tmpDyl
	 s tmpGroupId=0
	 f  s tmpGroupId=$o(^DHCClinicGroupConfig(tmpGroupId))  q:tmpGroupId=""  d
	 	.;s ^tmpDyl("Gr")=groupId
		 .q:(tmpGroupId'=groupId)&(groupId'="")
		 .s tmpTypeCode=""  f  s tmpTypeCode=$o(^DHCClinicGroupConfig(tmpGroupId,tmpTypeCode)) q:tmpTypeCode=""  d
			 ..q:(tmpTypeCode'=typeCode)&(typeCode'="")
			 ..s id="" f  s id=$o(^DHCClinicGroupConfig(tmpGroupId,tmpTypeCode,id)) q:id=""  d
				 ...s name=$p($g(^DHCClinicGroupConfig(tmpGroupId,tmpTypeCode,id)),"^",1)
				 ...s caption=$p($g(^DHCClinicGroupConfig(tmpGroupId,tmpTypeCode,id)),"^",2)
				 ...q:'$d(^SSU("SSGRP",tmpGroupId))	
				 ...s groupDesc=$P(^SSU("SSGRP",tmpGroupId),"^",1)
				 ...i tmpTypeCode="MENU" s type="菜单"
				 ...i tmpTypeCode="BUTTON" s type="按钮"
				 ...i tmpTypeCode="COLUMN" s type="可激活列"
			 	 ...;s ^tmpDyl("Gr2",tmpTypeCode,id)=caption_"/"_name
			 	 ...Do OutputRow3	 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(id,tmpGroupId,groupDesc,name,caption,tmpTypeCode,type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGroupConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupConfigExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGroupConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getEditColumn(groupId) As %String
{
	s retStr=""
	s id=""
	f  s id=$o(^DHCClinicGroupConfig(groupId,"COLUMN",id)) q:id=""  d
	.s columnName=$p(^DHCClinicGroupConfig(groupId,"COLUMN",id),"^",1)
	.i retStr="" s retStr=columnName
	.e  s retStr=retStr_"^"_columnName
	q retStr
}

ClassMethod InsertGroupConfig(groupId, typeCode, rowId, str) As %String
{
	
	q:(groupId="") -4
	q:(typeCode="") -3
	q:(rowId="") -2
	i $d(^DHCClinicGroupConfig(groupId,typeCode,rowId))>0 q -1
  	s name=$p(str,"^",1)
  	s caption=$p(str,"^",2)
  	s qFlag=0
  	s id=0  f  s id=$o(^DHCClinicGroupConfig(groupId,typeCode,id))  q:id=""  d
  	.s iName=$p(^DHCClinicGroupConfig(groupId,typeCode,id),"^",1)
  	.i name=iName  s qFlag=1
  	q:qFlag=1 "name重复"
  	s ^DHCClinicGroupConfig(groupId,typeCode,rowId)=str
  	q 0
}

ClassMethod UpdateGroupConfig(groupId, typeCode, oriRowId, rowId, str) As %String
{
    q:(groupId="") -4
	q:(typeCode="") -3
	q:(oriRowId="") -2
	q:(rowId="") -1
  	s name=$p(str,"^",1)
  	s caption=$p(str,"^",2)
  	s qFlag=0
  	s id=0  f  s id=$o(^DHCClinicGroupConfig(groupId,typeCode,id))  q:id=""  d
  	.q:id=oriRowId
  	.s iName=$p(^DHCClinicGroupConfig(groupId,typeCode,id),"^",1)
  	.i name=iName  s qFlag=1
  	q:qFlag=1 "name重复"
  	i oriRowId'=rowId  d
	.m ^DHCClinicGroupConfig(groupId,typeCode,rowId)=^DHCClinicGroupConfig(groupId,typeCode,oriRowId)
	.k ^DHCClinicGroupConfig(groupId,typeCode,oriRowId)
  	s ^DHCClinicGroupConfig(groupId,typeCode,rowId)=str
  	q 0
}

ClassMethod DeleteGroupConfig(groupId, typeCode, rowId) As %String
{
	q:groupId="" -3
	q:typeCode="" -2
	q:rowId="" -1
	k ^DHCClinicGroupConfig(groupId,typeCode,rowId)
	q 0
}

// 判断手术间是否开放权限，沈阳医大用

ClassMethod GetOpDirAuditStatus() As %String
{
	s opDirAuditStatus=$g(^DHCCLSet("AnOp","OpDirAuditStatus"))
	q opDirAuditStatus
}

// 更改护士长审核状态,每次更新为相反状态

ClassMethod UpDateOpDirAuditStatus() As %String
{
	  s oriOpDirAuditStatus=$G(^DHCCLSet("AnOp","OpDirAuditStatus"))
	  i (oriOpDirAuditStatus="N")!(oriOpDirAuditStatus="") d
	  .s ^DHCCLSet("AnOp","OpDirAuditStatus")="Y"
	  i oriOpDirAuditStatus="Y" d
	  .s ^DHCCLSet("AnOp","OpDirAuditStatus")="N"
	  q $g(^DHCCLSet("AnOp","OpDirAuditStatus"))
}

ClassMethod GetIco(EpisodeID) As %String
{
 
   s imgShow="",imgShow1="",imgShow2="",img=""
   ;s img=##class(web.DHCSETIMAGE).ifAdmit($g(EpisodeID))
   s code="ifadmit"
   s src="../images/webemr/regalert.gif"
   s desc="病人基本信息"
   s lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurPatDetail&EpisodeID="_EpisodeID
   s nwin="dialogHeight: 500px; dialogWidth: 600px"
   s imgShow1=code_"#"_1_"#"_src_"#"_desc_"#"_lnk_"!"_nwin
   s img=##class(web.DHCPisApplicationSheet).GetIsExeByAdmNo($g(EpisodeID))
   s code="DHCPisReg"
   s desc="病理标本登记提示"
   s src="../images/webemr/prossuppcontact.gif"
   s lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPisReg&EpisodeID="_EpisodeID
   s nwin="dialogHeight: 500px; dialogWidth: 710px"
   s imgShow2=code_"#"_img_"#"_src_"#"_desc_"#"_lnk_"!"_nwin
   s imgShow=imgShow1_"^"_imgShow2
   q imgShow
}

ClassMethod GetLabInfo(admId = "")
{

	q:admId=""
	s admId=$p(admId,"^",2)
	s labInfoStr=""
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s TCSync0="ABO",TCSync1="RH",TCSync6="ALT",TCSync8="HBSAG",TCSync12="ANTIHCV",TCSync13="ANTIHIV",TCSync14="TPHA"
	S BloodTypeStr=##class(LabService.TCResult).GetTCResultByRegNo(regNo,TCSync0)
	s BloodType=$p(BloodTypeStr,$c(2),3)
	s RHBloodTypeStr=##class(LabService.TCResult).GetTCResultByRegNo(regNo,TCSync1)
	s RHBloodType=$p(RHBloodTypeStr,$c(2),3)
	s LabALTStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,TCSync6)
	s LabALT=$p(LabALTStr,$c(2),3)
	s LabHBSAG="",LabHCVAB=""
	s LabHIVABStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,TCSync13)
	s LabHIVAB=$p(LabHIVABStr,$c(2),3)
	s LabchmdStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,TCSync14)
	s Labchmd=$p(LabchmdStr,$c(2),3)
	s labInfoStr=BloodType_"^"_RHBloodType_"^"_""_"^"_""_"^"_""_"^"_""_"^"_LabALT_"^"_""_"^"_LabHBSAG_"^"_""_"^"_""_"^"_""_"^"_LabHCVAB_"^"_LabHIVAB_"^"_Labchmd
	q labInfoStr
}

ClassMethod UpdateAnArrForNurse(opDate, opaIdStr, nurStr, nurType)
{
 //AnNurse,ScrubNurse,ExScrubNurse,CirculNurse,ExCirculNurse   A,D,J,T,X
 //麻醉护士，器械护士，交器械护士，巡回护士，交巡回护士
 i opDate'="" s nowDate=##Class(web.DHCClinicCom).ConvertToDateH(opDate)
 e  s nowDate=+$H
 s nowTime=$P($H,",",2)
 s upDate=+$H  
 s userId=%session.Data("LOGON.USERID")
 s retStr=""
 s nurStr=$tr(nurStr,",","^")
 s SQLCODE=-1
 TSTART 
 f i=1:1:$l(opaIdStr,"^") d
	 .s opaId=$p(opaIdStr,"^",i)
	 .q:opaId=""
	 .s roomId=$P($G(^DHCANOPArrange(opaId)),"^",20)
	 .i roomId="" s retStr="未安排手术间"
	 .q:roomId=""
	 .s arrId="" f  s arrId=$O(^DHCANArr(0,"AnArrDate",nowDate,arrId)) q:arrId=""  d
		 ..s arrOpDr=$P($G(^DHCANArr(arrId)),"^",4)
		 ..q:arrOpDr'=opaId
		 ..s arrNurDoc=$P($G(^DHCANArr(arrId)),"^",6)
		 ..q:arrNurDoc'="N"
		 ..s nurCat=$P($G(^DHCANArr(arrId)),"^",8)
		 ..q:nurCat'=nurType
		 ..&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:arrId)
		 ..i SQLCODE'=0  TROLLBACK  s retStr="删除护士失败!" q
	 .q:retStr'=""
	 .s num=$L(nurStr,"^")
	 .f j=1:1:num d
		 ..s ctcpDr=$P(nurStr,"^",j)
		 ..q:ctcpDr=""
		 ..s arrNurDoc="N"
		 ..s docCat=""
		 ..s nurCat=nurType
		 ..s ctcpNum=j
		 ..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opaId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
		 ..i SQLCODE'=0 TROLLBACK  s retStr="护士插入失败!" q
 i retStr="" TCOMMIT
 q retStr
}

ClassMethod UpdateAllAnOpArr(opDate As %Library.String = "", opaIdStr As %String = "", nurType As %String = "")
{
	s retStr=""
	s nowDate=##Class(web.DHCClinicCom).ConvertToDateH(opDate)
	f i=1:1:$L(opaIdStr,"^") d
	.s opaId=$p(opaIdStr,"^",i)
	.q:opaId="" 
	.s retStr=..UpdateAnOpArr(nowDate,opaId,nurType)
	q retStr
}

ClassMethod UpdateAnOpArr(nowDate, opaId, nurType)
{
	q:opaId="" ""
    s retStr=""
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,mzsupdoc)=""
	s roomId=$P($G(^DHCANOPArrange(opaId)),"^",20)
    q:roomId="" "未安排手术间!"
	s anaId=$P($G(^DHCANOPArrange(opaId)),"^",2)
	q:anaId="" "手术申请不存在!"
	s admId=+anaId
    s anaSub=$p(anaId,"||",2)
    s anDocNote=""
    s anOpArrangeDate=$P(^DHCANOPArrange(opaId),"^",14)
    s ctcpDr=""
    f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
		..s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
		..q:arrOpDr'=opaId
		..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
		..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
		..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
		..s arrNote=$P($G(^DHCANArr(anArrRowId)),"^",10)
			..i (arrNurDoc="D")&(docCat="A") d
			...s ctcpAnDoc=ctcpDr
		..i (arrNurDoc="D")&(docCat="O") d
			...i ctcpAnDocO="" s ctcpAnDocO=ctcpDr
			...e  s ctcpAnDocO=ctcpAnDocO_"^"_ctcpDr
		..i (arrNurDoc="D")&(docCat="S") d
			...s mzsupdoc=ctcpDr
		..i arrNote'="" s anDocNote=arrNote
		..i (arrNurDoc="D")&(docCat="J") d
			...i ctcpAnDocJ="" s ctcpAnDocJ=ctcpDr
			...e  s ctcpAnDocJ=ctcpAnDocJ_"^"_ctcpDr
		..i (arrNurDoc="N")&(nurCat="A") d
			...s ctcpAnNur=ctcpDr
		..i (arrNurDoc="N")&(nurCat="D") d
			...i ctcpDevNur="" s ctcpDevNur=ctcpDr
			...e  s ctcpDevNur=ctcpDevNur_"^"_ctcpDr
		..i (arrNurDoc="N")&(nurCat="J") d
			...i ctcpDevNurJ="" s ctcpDevNurJ=ctcpDr
			...e  s ctcpDevNurJ=ctcpDevNurJ_"^"_ctcpDr
		..i (arrNurDoc="N")&(nurCat="T") d
			...i ctcpTourNur="" s ctcpTourNur=ctcpDr
			...e  s ctcpTourNur=ctcpTourNur_"^"_ctcpDr
		..i (arrNurDoc="N")&(nurCat="X") d
			...i ctcpTourNurJ="" s ctcpTourNurJ=ctcpDr
			...e  s ctcpTourNurJ=ctcpTourNurJ_"^"_ctcpDr
	//w ctcpAnDoc_"/"_ctcpAnDocO_"/"_ctcpAnDocJ_"/"_ctcpAnNur_"/"_ctcpDevNur_"/"_ctcpDevNurJ_"/"_ctcpTourNur_"/"_ctcpTourNurJ_"/"_mzsupdoc
   // TSTART
	//i (ctcpAnDoc'="")!(ctcpAnNur'="")!(mzsupdoc'="") d
	//&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:ctcpAnDoc,ANA_ORAnaNurse_DR=:ctcpAnNur,ANA_Supervisor_DR=:mzsupdoc where ana_rowid=:anaId)
	//i SQLCODE'=0 s retStr="更新麻醉表失败!"
	//i SQLCODE'=0 TROLLBACK 
	s anaopSub=0
    f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	    .q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
		.i ctcpAnDocO'="" d
			..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS")
			..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=100
		    ..f i1=1:1:$L(ctcpAnDocO,"^")  d
		    ...q:$P(ctcpAnDocO,"^",i1)=""
		    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",i1)=$P(ctcpAnDocO,"^",i1)
	    .e  d
		    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS")
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=""
	    .i ctcpAnDocJ'="" d
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=200
		    ..f i2=1:1:$L(ctcpAnDocJ,"^")  d
		    ...q:$P(ctcpAnDocJ,"^",i2)=""
		    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",20+i2)=$P(ctcpAnDocJ,"^",i2)
	    .;器械护士
	    .i ctcpDevNur'="" d
		    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=100
		    ..f i3=1:1:$L(ctcpDevNur,"^") d
		    ...q:$P(ctcpDevNur,"^",i3)=""
		    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",i3)=$P(ctcpDevNur,"^",i3)
	    .e  d
	    	..i nurType="D" d
		    ...k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
		    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=""
	    .
	    .i ctcpDevNurJ'="" d
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=200
		    ..f i4=1:1:$L(ctcpDevNurJ,"^") d
		    	...q:$P(ctcpDevNurJ,"^",i4)=""
		    	...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",20+i4)=$P(ctcpDevNurJ,"^",i4)
	    .;巡回护士
	    .i ctcpTourNur'="" d
		    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
		    ..f i5=1:1:$L(ctcpTourNur,"^") d
		    	...q:$P(ctcpTourNur,"^",i5)=""
		    	...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",i5)=$P(ctcpTourNur,"^",i5)
		 .e  d
		 	..i nurType="T" d
		    	...k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
		    	...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=""
	    .
	    .i ctcpTourNurJ'="" d
	    	..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=200
	    	..f i6=1:1:$L(ctcpTourNurJ,"^") d
	    		...q:$P(ctcpTourNurJ,"^",i6)=""
	    		...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",20+i6)=$P(ctcpTourNurJ,"^",i6)
	q retStr
}

ClassMethod SameRoomOrderAndSort(opaId, roomId, ordNo)
{
	q:ordNo=1 ""
	s nowDate=$P(^DHCANOPArrange(opaId),"^",14)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$p(anaId,"||",2)
	s admId=$p(anaId,"||",1)
	s ctcpDr="",ctcpDevNur="",ctcpTourNur=""
    f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
		.s anArrRowId=""
		.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
			..s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
			..q:arrOpDr=opaId
			..s oproomdr=$P(^DHCANOPArrange(arrOpDr),"^",20)
			..s opordno=$P(^DHCANOPArrange(arrOpDr),"^",26)
			..q:opordno'=1
			..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
			..q:(nurCat'="D")&(nurCat'="T")
			..i nurCat="D" d
				...i ctcpDevNur="" s ctcpDevNur=ctcpDr
				...e  s ctcpDevNur=ctcpDevNur_"^"_ctcpDr
			..i nurCat="T" d
				...i ctcpTourNur="" s ctcpTourNur=ctcpDr
				...e  s ctcpTourNur=ctcpTourNur_"^"_ctcpDr
	
	s anaopSub=0
    f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	    .q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
	    .q:$d(^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN"))	;已经有数据的不再变化，只能手工改
	    .q:$d(^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN"))
	    .i ctcpTourNur'="" d
		    ..;k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
		    ..f i=1:1:$L(ctcpTourNur,"^") d
		    	...q:$P(ctcpTourNur,"^",i)=""
		    	...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",i)=$P(ctcpTourNur,"^",i)
		.i ctcpDevNur'="" d
		    ..;k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
		    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=100
		    ..f i=1:1:$L(ctcpDevNur,"^") d
		    ...q:$P(ctcpDevNur,"^",i)=""
		    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",i)=$P(ctcpDevNur,"^",i)
	q ""
}

/// w ##class(web.DHCANOPArrange).GetRoomFirstOrd(161)
ClassMethod GetRoomFirstOrd(opaId)
{
	s nowDate=$P(^DHCANOPArrange(opaId),"^",14)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s chl=$p(anaId,"||",2)
	s adm=$p(anaId,"||",1)
	s ctcpDr="",ctcpDevNur="",ctcpTourNur=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
		.s p=0
		.s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",subchl,"SCN",xs)) q:(xs="")!(p=3)  d
			..q:xs>20
			..s xsdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"SCN",xs),"^",1)
			..q:xsdr=""
			..s p=p+1
			..i ctcpDevNur'="" s ctcpDevNur=ctcpDevNur_"^"_xsdr
			..e  s ctcpDevNur=xsdr
		.s qc=0  ;巡回
		.s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",subchl,"CIRN",xc)) q:(xc="")!(qc=3)   d
			..q:xc>20
			..s xchdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"CIRN",xc),"^",1)
			..q:xchdr=""
			..s qc=qc+1
			..i ctcpTourNur'="" s ctcpTourNur=ctcpTourNur_"^"_xchdr
			..e  s ctcpTourNur=xchdr
	q ctcpDevNur_"#"_ctcpTourNur
}

/// 自动同步麻醉医师
ClassMethod AnDocAutoArr(firstOpaId)
{
	s ret=0
	s nowDate=$P(^DHCANOPArrange(firstOpaId),"^",14)
	s opfroomdr=$P(^DHCANOPArrange(firstOpaId),"^",20)
    s opordno=$P(^DHCANOPArrange(firstOpaId),"^",26)
    s anafId=$P(^DHCANOPArrange(firstOpaId),"^",2)
    s admfId=$p(anafId,"||",1)
    s chlf=$p(anafId,"||",2)
    s mzfdr=$P(^OR(admfId,"ANA",chlf),"^",6) 
    s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,"SDate",nowDate,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.q:oproomdr'=opfroomdr
		.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		.s admId=$p(anaId,"||",1)
    	.s chl=$p(anaId,"||",2)
		.s mzdr=$P(^OR(admId,"ANA",chl),"^",6) 
		.q:mzdr'=""
	   	.&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:mzfdr where ana_rowid=:anaId)
	   	.i SQLCODE'=0 s ret=SQLCODE
	   	.q:SQLCODE'=0
	   	
	q ret
}

// 

/// d ##class(web.DHCANOPArrange).NurseAutoArr(161)
ClassMethod NurseAutoArr(firstOpaId)
{
	s ret=0
	s nowDate=$P(^DHCANOPArrange(firstOpaId),"^",14)
	s opfroomdr=$P(^DHCANOPArrange(firstOpaId),"^",20)
    s opordno=$P(^DHCANOPArrange(firstOpaId),"^",26)
    s anafId=$P(^DHCANOPArrange(firstOpaId),"^",2)
    s admfId=$p(anafId,"||",1)
    s chlf=$p(anafId,"||",2)
   s nursestr=..GetRoomFirstOrd(firstOpaId)
	s ctcpDevNur=$p(nursestr,"#",1)
	s ctcpTourNur=$p(nursestr,"#",2)
    s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,"SDate",nowDate,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.q:oproomdr'=opfroomdr
		.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		.s admId=$p(anaId,"||",1)
    	.s anaSub=$p(anaId,"||",2)
		.s anaopSub=0
    	.f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
		    ..q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
		    ..q:$d(^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN"))&&(^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)>1)	;已经有数据的不再变化，只能手工改
		    ..q:$d(^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN"))&&(^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)>1)
		    ..i ctcpTourNur'="" d
			    ...;k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
			    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
			    ...f i=1:1:$L(ctcpTourNur,"^") d
			    	....q:$P(ctcpTourNur,"^",i)=""
			    	....s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",i)=$P(ctcpTourNur,"^",i)
			..i ctcpDevNur'="" d
			    ...;k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
			    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=100
			    ...f i=1:1:$L(ctcpDevNur,"^") d
			    ....q:$P(ctcpDevNur,"^",i)=""
			    ....s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",i)=$P(ctcpDevNur,"^",i)
	   	
	q ret
}

ClassMethod GetOpaIdByEp(EpisodeID)
{
  q:EpisodeID="" "未选中病人"
  s opaId=""
  //s opaIdStr=$o(^DHCANOPArrange(0,"Adm",EpisodeID,""),-1)
  s opaIdStr=""
  f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1)  q:opaId=""  d
	  .i opaIdStr="" s opaIdStr=opaId
	  .e  s opaIdStr=opaIdStr_"^"_opaId
  q opaIdStr
}

ClassMethod GetStatus(opaId) As %String
{
	s status=$P($g(^DHCANOPArrange(opaId)),"^",27)
	q status
}

ClassMethod GetLocIdByDesc(ctlocDesc)
{
	s ctlocDesc=$$ALPHAUP^SSUTIL4(ctlocDesc),ctlocId="" //ypz 070316
	i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
	i ctlocId="",ctlocDesc=+ctlocDesc s ctlocId=ctlocDesc
	q ctlocId
}

Query GetAnOpList(adm As %String = "", statusStr As %String = "") As %Query(ROWSPEC = "tLocDes,tRegNo,tPatName,tSex,tAge,tDiag,tOpName,tOpDateStr,tOpAppDateStr,tOpDoc,tStatus,opaId")
{
}

ClassMethod GetAnOpListExecute(ByRef qHandle As %Binary, adm As %String = "", statusStr As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
    //i adm="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    s dateformatnum=##class(websys.Conversions).DateFormat()
	s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",adm,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s tLocation="",tRegNo="",tPatName="",tSex="",tAge="",tDiag="",tOpName="",tOpDateStr="",tOpAppDateStr="",tOpDoc=""
	.s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
	.s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
	.s opEndDate=$P(^DHCANOPArrange(opaId),"^",16)
	.s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
	.i opEndDate<=opStDate s opEndDate=""
	.i opEndDate'=""  s opEndDate=$ZD(opEndDate,dateformatnum)_" "
	.i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
	.i opStTime'=""  s opStTime=$ZT(opStTime,2)
	.s tOpDateStr=$ZD(opStDate,dateformatnum)_" "_opStTime_"~"_opEndDate_opEndTime
	.s opAppDate=$P(^DHCANOPArrange(opaId),"^",3)       
	.s opAppTime=$P(^DHCANOPArrange(opaId),"^",5)
	.i opAppDate'=""  s opAppDate=$ZD(opAppDate,dateformatnum)
	.i opAppTime'=""  s opAppTime=$ZT(opAppTime,2)
	.s tOpAppDateStr=$G(opAppDate)_"  "_$G(opAppTime)
	.s papmiId=$p($g(^PAADM(adm)),"^",1)
	.s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.s tPatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	.s tAge=##class(web.UDHCANOPArrange).CalAge(birth,opStDate)
	.s tSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s paAdmType=$p($g(^PAADM(adm)),"^",2)
	.s bedCode="",inPatNo=""
	.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
	.s curWardId=$p($g(^PAADM(adm)),"^",70)  
	.i curWardId'="" s wardDes=$P(^PAWARD(curWardId),"^",1)
	.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	.s admLocId=$p($g(^PAADM(adm)),"^",4)
	.q:admLocId=""
	.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	.i +appLocId=0 s appLocId=admLocId
	.i +appLocId=0 s tLocDes=""
	.e  s tLocDes=$P($g(^CTLOC(appLocId)),"^",2)
	.i (appLocId'="")&(admLocId'=appLocId)&(paAdmType'="O") s tLocDes=tLocDes_"(借)"
	.i $l(tLocDes,"-")>1 s tLocDes=$p(tLocDes,"-",2)
	.i paAdmType="O" s tLocDes=tLocDes_"(门)"
	.e  s tLocDes=tLocDes_"/"_bedCode
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.s tStatus=""
	.i opaStatus="A" s tStatus="申请"
	.i opaStatus="D" s tStatus="拒绝"
	.i opaStatus="R" s tStatus="安排"
	.i opaStatus="N" s tStatus="非预约"
	.i opaStatus="I" s tStatus="术中"
	.i opaStatus="P" s tStatus="恢复室"
	.i opaStatus="L" s tStatus="术毕"
	.i opaStatus="F" s tStatus="完成"
	.q:opaStatus=""
	.q:(statusStr'[opaStatus)&(statusStr'="")
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s i=0
	.s prediag="",diamen=""
	.s opDes=""
	.s sub=0 f  s sub=$O(^OR(adm,"ANA",chl,"OP",sub)) q:(sub="")  d 
	..s opDr=$P(^OR(adm,"ANA",chl,"OP",sub),"^",6)       		;ANAOP_Type_DR     ；手术名称
	..i opDr'=""  d   
	...i $P($g(^ORC("OPER",+opDr)),"^",2)'="" d   
	....i opDes'="" s opDes=opDes_";"   
	....s opDes=opDes_$P($g(^ORC("OPER",+opDr)),"^",2)  
	..e  d
	...i $g(^OR(adm,"ANA",chl,"OP",sub,"REM",2))'="" d
	....i opDes'="" s opDes=opDes_";"
	....s opDes=opDes_$G(^OR(adm,"ANA",chl,"OP",sub,"REM",2))  
	..s i=i+1
	..q:i>1 
	..s subChl=sub
	..s docDr=$P(^OR(adm,"ANA",chl,"OP",sub),"^",8)      		;ANAOP_Surgeon_DR   手术医师
	..s docDes=""
	..i docDr'="" s docDes=##class(web.DHCANOPCom).GetNameById(docDr)
	..e  s docDes=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  // 手术医生备注(外来手术医生)
	..s surgeonDesc=docDes   
	..s predigdrS=$P(^OR(adm,"ANA",chl,"OP",sub),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
	..s num=$l(predigdrS,"|")
	..f pi=1:1:num d
	...s predigdr=$p(predigdrS,"|",pi)
	...i predigdr'=""  d
	....s prediag=$P(^MRC("ID",predigdr),"^",2)
	...s $p(diag,",",pi)=$G(prediag)
	...e  d
	....i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
	.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)  	//ck091210 麻醉表存放诊断备注ANA_Notes
	.....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
	.s tDiag=diag
	.s tOpName=opDes  
	.q:subChl=""
	.s ash=""
	.s assDocNum=2 //最多显示的助手人数
	.i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
	.s p=0
	.s list=0,asName=""
	.s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
	.s len=$l(opaDocNote,"|")
	.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",subChl,"ASS",as)) q:(as="")!(p'<assDocNum)  d
	..s asDr=$P(^OR(adm,"ANA",chl,"OP",subChl,"ASS",as),"^",1)
	..s p=p+1
	..q:asDr=""
	..s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asDr)
	.i len>assDocNum+2 s len=assDocNum+2
	.f getLen=3:1:len  d
	..i $p(opaDocNote,"|",getLen)'=""  d
	...s getName=$p(opaDocNote,"|",getLen)
	..e  d
	...s list=list+1
	...s getName=$p(asName,"^",list+1)
	..s ash=ash_" "_getName
	.s docDes=docDes_","_$G(ash)
	.s tOpDoc=docDes
	.d OutRowOPList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowOPList
	set Data=$lb(tLocDes,tRegNo,tPatName,tSex,tAge,tDiag,tOpName,tOpDateStr,tOpAppDateStr,tOpDoc,tStatus,opaId)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetAnOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAnOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	k ^tmpCk
    q $$$OK
}

/// 查找grouId是否在^DHCCLSet("AnOp","OpDirAuditlist")
/// 
ClassMethod GetCountIfEnable(opaId) As %String
{
	// 1^2^3
	s res="N"
	s groupId=$g(%session.Data("LOGON.GROUPID"))
	s userId=$g(%session.Data("LOGON.USERID"))
	s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:groupId="" "N"
	
	s adm=$P(^DHCANOPArrange(opaId),"^",1)
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s sub=0,i=0,p=0
	f  s sub=$o(^OR(adm,"ANA",chl,"OP",sub)) q:sub=""  d
	.s i=i+1
	.q:i>1
	.;s cirId=0 f  s cirId=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",cirId)) q:(cirId="")!(p=3)!(res="Y")   d
	..;q:cirId>20
	.s cirId=0 f  s cirId=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",cirId)) q:(cirId="")!(res="Y")   d
	..s cirDr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",cirId),"^",1)
	..q:cirDr=""
	..i cirDr=ctcpId s res="Y"
	..s p=p+1
	
	s ifEm=$P(^OR(adm,"ANA",chl),"^",32)
	s EmOpArrNurseGroup=$g(^DHCCLSet("AnOp","EmOpArrNurseGroup")) 
	i (("^"_EmOpArrNurseGroup_"^")[("^"_groupId_"^"))&&(ifEm="E") s res="Y"
	set groupList = ^DHCCLSet("AnOp","OpDirAuditlist")	
	i (("^"_groupList_"^")[("^"_groupId_"^"))'=0 s res="Y"
	q res
}

ClassMethod UpdateAnOpFinishStatus(opaIdStr) As %String
{
	s sessLoc=$g(%session.Data("LOGON.CTLOCID"))
	s anOrOp=##class(web.UDHCANOPSET).ifloc(sessLoc)
	s retStr=0
  	s strLen=$L(opaIdStr,"^")
  	TSTART
    f i=1:1:strLen 
    {
	 s opaId=$p(opaIdStr,"^",i)
	 q:opaId=""
	 s admId=$P(^DHCANOPArrange(opaId),"^",1)
	 s papmiId=$p($g(^PAADM(admId)),"^",1)
	 s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	 &sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	 s status=$P(^DHCANOPArrange(opaId),"^",27) 
	 if anOrOp=1 d
	 .i status="L" d 
	 ..s PLIST(51)="Y"
	 ..s PLIST(20)="F"
	 .i status="P" d
	 ..s PLIST(51)="Y"
     i anOrOp=2 d
     .;i PLIST(51)'="Y" d 
     ..;s retStr="病人"_patName_"的手术护士未登记" 
     .;e  d
     ..;i status="P" d
     ...;s PLIST(20)="F"
     .i status="P" d        //新修改的如果规则变回去把从这到下面那一行
     ..s PLIST(20)="F"     //删掉把上面用";"注释的解开即可。
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE'=0  TROLLBACK
    }
    i SQLCODE=0  TCOMMIT
    i SQLCODE'=0 s retStr="更新失败"
	q retStr
}

ClassMethod GetLocDesc(id) As %String
{
	q:id=""
	s ctLocDesc=$p(^CTLOC(id),"^",2)
	q ctLocDesc
}

/// Creater:zhangtao
/// CreatDate:2013.3.20
/// Description:判断手术间是否在进行手术
/// Input:opaIdStr,opRoomIdStr
/// Return:retStr
ClassMethod GetEditStat(opaId, opRoomId) As %String
{
	s dateformatnum=##class(websys.Conversions).DateFormat()
	q:(opaId="")||(opRoomId="") "输入为空"
	s retStr="1"
        s opRoomDesc=$p(^DHCANC("OPRoom",opRoomId),"^",2)
	s inRoomOpaId=0
	f  s inRoomOpaId=$O(^DHCANOPArrange(0,"RoomStatus",opRoomId,"I",inRoomOpaId)) q:(inRoomOpaId="")  d
	.q:inRoomOpaId=opaId
	.i $d(^DHCANOPArrange(0,"RoomStatus",opRoomId,"I",inRoomOpaId))>0  d
	..s papmiId=$p(^PAADM($p(^DHCANOPArrange(inRoomOpaId),"^",1)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s opaStartDate=$p(^DHCANOPArrange(inRoomOpaId),"^",14)
	..s retStr=opRoomDesc_"术间，"_"病人"_patName_"(手术Id:"_inRoomOpaId_")正在手术!请选择"_$zd(opaStartDate,dateformatnum)_"查询，结束手术，退出后方可继续操作!"
	q retStr
}

ClassMethod UpdateOpNurseNote(opaId, note)
{
  q:opaId="" "未选中记录"
  s ^DHCANARRAGE("opreq",opaId)=note
  q "0"
}

/// w ##class(web.DHCANOPArrange).GetAnSingle("175","","","")
ClassMethod GetAnSingle(opaId As %String, EpisodeID As %String = "", userId As %String = "", type As %String = "") As %String
{
	//n (itmjs,itmjsex,opaId,EpisodeID,userId)
	i EpisodeID="",opaId'="" s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID="" ""
	s anaesRowId=""
	
	//s transferMeans="",transferMeansCode="",docAnMethod="",IsPapEstimDS="N"
	
	s admReason="",bedCode="",ward="",regNo="",patName="",age="",sex="",infection="",locId="",locDes="",secretCode="",patLevel="",opDocGroup="",IsPapEstimDS=""
	s opDate="",operLocId="",operLocDesc="",appDocId="",appDocDesc=""
	s appLocId="",appLocDesc="",transferMeans="",opMem="",bloodType=""
	s arrDateTime="",isAddInstrument="",instrumentDr="",instrument="",surgeonDr=""
	s surgeonDesc="",surgeon="",opCategory="",postDiag="",assistants=""
	s opDocNote="",opSeqNote="",bodsList="",operPosition=""
	s anDoc="",anSupDoc="",anNurse="",anAssStr="",shiftAnAssStr=""
	s anMethodStr="",anaLevel="",anDocNote="",anDocMethodStr=""
	s opRoom="",opaSeq="",scNurStr="",sScNurStr="",cirNurStr="",sCirNurStr="",scnShiftTime="",cirShiftTime="",scNurNote="",cirNurNote="" 
	s opStDate="",opStTime="",opArrDate="",opArrTime="",opEndDate="",opEndTime="",preDiscussDate="",estiOperDuration="",anaTheatreInDate="",anaTheatreInTime="",anaTheatreOutDate="",anaTheatreOutTime=""
	s selfReport="",operResource="",telId="",queueNo="",patNotice="",operStock="",operStockNote="",comeTime="",surgeonLoc="",patDiseaseHis="" //lyn add 门诊扩展项 主诉，资源，病人电话，号源，病人须知
	s dateformatnum=##class(websys.Conversions).DateFormat()	//20170302+dyl
	//s timeformatnum=##class(websys.Conversion).TimeFormat()
	s timeformatnum=2
	s admReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i admReasonDr'="" s admReason=$P(^PAC("ADMREA",admReasonDr),"^",2) //费别
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	i $l(ward,"-")>1 s ward=$p(ward,"-",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s SecretLevel=""	;病人密级级别
	s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(EpisodeID)
	;secretCode:密级,patLevel:级别
	i SecretLevel'="" s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	;s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s telId=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //手机
	s infection=##class(web.UDHCANOPArrange).GetQueryInfPyObjDrugByPaadmStr(EpisodeID)
	s locId=$P($g(^PAADM(EpisodeID)),"^",4)
	s locDes=$P(^CTLOC(locId),"^",2)
	i $l(locDes,"-")>1 s locDes=$p(locDes,"-",2)
	;s papEstimDCDate=$p($g(^PAADM(EpisodeID)),"^",59)
	;PAADM_DischgDate
	s IsPatDisCharFlag=""
	;s papDisCharDate=$p($g(^PAADM(EpisodeID)),"^",17)
	;s papVStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	;i ((papDisCharDate'="")) d
    ;.s IsPatDisCharFlag="Y"
	;病人出院时间
	s patDisDate=""
	s patDisCharDate=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	i patDisCharDate'="" s patDisDate=$p(patDisCharDate,"^",1)
	;病人出院状态
	s patOutStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	i (patDisDate'="")&(patOutStatus'="B") s IsPatDisCharFlag="Y"
    //获取手术日期
    s opStDate=##class(web.DHCANOPCom).GetOperDate()
    
    s opStDate=$ZD(opStDate,dateformatnum)	//20170302+dyl
    s opDate=opStDate
    s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode("OP^OUTOP^EMOP",EpisodeID)
	s ctLocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	i ctLocIdList'="" d
		.s operLocId=$p(ctLocIdList,"^",1)
		.q:operLocId=""
		.q:'$d(^CTLOC(operLocId))
		.s operLocDesc=$p(^CTLOC(operLocId),"^",2)
		;20170628+dyl+默认的住院或门诊手术室按照手术申请配置走
	i type="In" d
		.s IPDefOpLocId=$g(^DHCCLSet("AnOp","IPDefOpLoc"))
		.i IPDefOpLocId'="" d
			..s operLocId=IPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	i type="Out" d
		.s OPDefOpLocId=$g(^DHCCLSet("AnOp","OPDefOpLoc"))
		.i OPDefOpLocId'="" d
			..s operLocId=OPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	i locId'="" d
		.s curOPRoomId=$o(^DHCANC("OPRoom",0,"DefDep",locId,""))
		.q:curOPRoomId=""
		.s operLocId=$p(^DHCANC("OPRoom",curOPRoomId),"^",3)
		.q:operLocId=""
		.q:'$d(^CTLOC(operLocId))
		.s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	s operLoc=operLocId_"!"_operLocDesc
	i userId'="" d
		.s appDocId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:appDocId=""
		.s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s appLoc=locId_"!"_locDes
	////术前诊断
	s mainDiag=..GetMainDiagnos(EpisodeID)
	;s mainDiag=$tr(mainDiag,"^","!")
	s retSlaveDiag=##class(web.DHCANOPPREDIAG).GetAllMDiagnos(EpisodeID)	
	s slaveDiag=$p(retSlaveDiag,"$",1)
	s slaveDiag=$tr(slaveDiag,"|",",")	
	;s diagNotes=$p(retSlaveDiag,"$",2)
	s diagNotes=..GetMainDiagNote(EpisodeID)	;诊断备注取主诊断的备注
	s preDiag=mainDiag   //medify mfc 20140117获取诊断记录
	i diagNotes="" s preDiagAndNotes=preDiag_"#"_slaveDiag
	e  s preDiagAndNotes=preDiag_"#"_slaveDiag_","_diagNotes
	s preDiagAndNotes=$tr(preDiagAndNotes,"^","")
	i appDocId'="" d  //门诊手术排班-病人须知  add by lyn
    	.s appSetInfo=$g(^DHCANOP("APPSET","DOC",appDocId))
    	.i appSetInfo="" s appSetInfo=$g(^DHCANOP("APPSET","LOC",locId))
    	.s patNotice=$p(appSetInfo,"^",1)
	i opaId="" d SetRetData q retStr
	s appDocId=$P(^DHCANOPArrange(opaId),"^",6)
	i appDocId'="" s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	i appLocId'="" s appLocDesc=$P($g(^CTLOC(appLocId)),"^",2)
	i $l(appLocDesc,"-")>1 s appLocDesc=$p(appLocDesc,"-",2)
	s appLoc=appLocId_"!"_appLocDesc
	s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
	s opDocGroup=""	
	/*
	单条对单独医生以后不再保存手术医师组：20180122+dyl
	s retStrC=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperMedUnitId")
	i retStrC'="" s opDocGroup=$p(retStrC,$c(3),1)
	*/
	;s age=##class(web.UDHCANOPArrange).CalAge(birth,opStDate)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	i opStDate'="" s opStDate=$zd(opStDate,dateformatnum)
	s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
	s opArrDate=$P(^DHCANOPArrange(opaId),"^",7)
	s opArrTime=$P(^DHCANOPArrange(opaId),"^",8)
	s opEndDate=$P(^DHCANOPArrange(opaId),"^",16)
	s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
	i opStTime'="" s opStTime=$ZT(opStTime,2)
	i opArrDate'="" s opArrDate=$ZD(opArrDate,dateformatnum)	//20170302+dyl
	i opArrTime'="" s opArrTime=$ZT(opArrTime,timeformatnum)
	s arrDateTime=opArrDate_" "_opArrTime
	i opEndDate'=""  s opEndDate=$ZD(opEndDate,dateformatnum)	
	i opEndTime'=""  s opEndTime=$ZT(opEndTime,timeformatnum)
	b 
	s preDiscussDate=$P(^DHCANOPArrange(opaId),"^",38)
	i preDiscussDate'="" s preDiscussDate=$zd(preDiscussDate,dateformatnum)
	s estiOperDuration=$P(^DHCANOPArrange(opaId),"^",37)
	;20161214+dyl
	;i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
	s transferMeansCode=$p(^DHCANOPArrange(opaId),"^",39)  
	i transferMeansCode="W" s transferMeans="自行" 
	i transferMeansCode="C" s transferMeans="轮椅"
	i transferMeansCode="S" s transferMeans="平车"
	s opMem=$P(^DHCANOPArrange(opaId),"^",19)
	s bldTypId=$P(^DHCANOPArrange(opaId),"^",11)
	i bldTypId'="" s bldTypDesc=$P($G(^PAC("BLDT",bldTypId)),"^",2)
	e  s bldTypDesc="未知"
	s bloodType=bldTypId_"!"_bldTypDesc
	s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30) 
	i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)  	//DHC_ANC_Instrument	器械
	e  s instrument=""
	s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31) 			//OPA_AddInstrument		是否补充器械
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s assDocNum=5
	i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)>0 s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
	s i=0
	s opSub=0 f  s opSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:(opSub="")!(i=1)  d
	.s i=i+1
	.;s anaopSub=opSub
	.;s oprdate=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",13)  ;ANAOP_OpStartDate  手术日期
	.s surgeonDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",8)        ;ANAOP_Surgeon_DR  ；手术医师
	.i surgeonDr'="" s surgeonDesc=##class(web.DHCANOPCom).GetNameById(surgeonDr)
	.s surgeon=surgeonDr_"!"_surgeonDesc
	.;e  s surgeon=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //自填写手术医生
	.s opDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",6)         ;ANAOP_Type_DR     ；手术名称
	.s opDes=""
	.i opDr'="" d
	..i $D(^ORC("OPER",opDr)) d
	...s opDes=$P(^ORC("OPER",opDr),"^",2)
	...s opCategoryId=$p(^ORC("OPER",opDr),"^",7)  					 // 手术分类
    ...i opCategoryId'=""  s opCategory=$p($g(^ORC("CATEG",opCategoryId)),"^",2)
    ...s opStatName=$P(^ORC("OPER",opDr),"^",35) 						 //手术统计名称
    .s operation=opDr_"!"_opDes
	.s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",10) 
	.s operLocDesc="" 
	.i operLocId'="" s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	.s operLoc=operLocId_"!"_operLocDesc
	.s bodsIdList=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",24) 	 //手术部位
	.s bodsList=""
	.i bodsIdList'="" d
		..s bodsIdNum=$l(bodsIdList,"|")
		..f j=1:1:bodsIdNum d
			...s bodsId=$p(bodsIdList,"|",j)
			...q:bodsId=""
			...s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2)
			...i bodsList="" s bodsList=bodsId_"!"_bodsDesc
			...e  s bodsList=bodsList_","_bodsId_"!"_bodsDesc	   
	.s preDiagStr=""
	.s preDigDrStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",4)     ;ANAOP_PreopDiag_DR 术前诊断S //zhangtao add
	.s num=$l(preDigDrStr,"|")
	.f di=1:1:num d
	..s dr=$p(preDigDrStr,"|",di)
	..q:dr=""
	..s desc=$P(^MRC("ID",dr),"^",2)
	..s item=dr_"!"_desc
	..i preDiagStr="" s preDiagStr=item
	..e  s preDiagStr=preDiagStr_","_item
	.s diaMem=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))
	.s preDiagAndNotes=preDiagStr_"#"_diaMem
	.s preDiagAndNotes=$tr(preDiagAndNotes,"^","")
	.s postDigDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",5)   ;ANAOP_PostDiag_DR 术后诊断
	.i postDigDr'="" d
	..s postDiag=postDigDr_"!"_$P(^MRC("ID",postDigDr),"^",2)    
	.s p=0  ;助手	
	.s asId=0 f  s asId=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ASS",asId)) q:(asId="")!(p'<assDocNum)  d
	..s assistantDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ASS",asId),"^",1)
	..q:assistantDr=""
	..s p=p+1
	..i assistants="" s assistants=assistantDr_"!"_##class(web.DHCANOPCom).GetNameById(assistantDr)
	..e  s assistants=assistants_"#"_assistantDr_"!"_##class(web.DHCANOPCom).GetNameById(assistantDr)
    .s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"POS",1)),"^")
	.i operPositionId'=""  d
	..s operPositionDesc=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
	.e  s operPositionDesc=""
	.s operPosition=operPositionId_"!"_operPositionDesc
	s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41) //手术编号
	s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
	s opMem=$P(^DHCANOPArrange(opaId),"^",19) //手术要求
	//麻醉////////////////////////////////
	
	s anDocDr=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",6)        		//ANA_Anaesthetist_Dr	麻醉医师
	i anDocDr'="" d			 	;麻醉医师
	.s anDocDesc=##class(web.DHCANOPCom).GetNameById(anDocDr) 
	e  s anDocDesc=""
	s anDoc=anDocDr_"!"_anDocDesc
	s anSupDr=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",7)        		//ANA_Supervisor_Dr ///ck091203
	i anSupDr'="" d 	 	;麻醉辅导医师
	.s anSupDesc=##class(web.DHCANOPCom).GetNameById(anSupDr)
	e  s anSupDesc=""
	s anSupDoc=anSupDr_"!"_anSupDesc
	s anNurseDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",8)			//ANA_ORAnaNurse_DR		麻醉护士
	i anNurseDr'="" d
	.s anNurseDesc=##class(web.DHCANOPCom).GetNameById(anNurseDr)
	e  s anNurseDesc="" 
	s anNurse=anNurseDr_"!"_anNurseDesc 
    s opSub=0,anAssDesc="",shiftAnAssDesc=""
    f  s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:opSub=""  d
    .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",12)'="M" 
    .s anAssStr=""
    .s anassSub=0
    .f  s anassSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub))  q:(anassSub="")||(anassSub>20)  d
    ..s anAssDr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub))
    ..i anAssDr'="" s anAssDesc=##class(web.DHCANOPCom).GetNameById(anAssDr)
    ..i anAssStr="" s anAssStr=anAssDr_"!"_anAssDesc
    ..e  s anAssStr=anAssStr_","_anAssDr_"!"_anAssDesc
    .s shiftAnAssStr=""
    .s anassSub=20
    .f  s anassSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub)) q:(anassSub="")  d
    ..s shiftAnAssDr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub))
    ..i shiftAnAssDr'="" s shiftAnAssDesc=##class(web.DHCANOPCom).GetNameById(shiftAnAssDr)
    ..i shiftAnAssStr="" s shiftAnAssStr=shiftAnAssDr_"!"_shiftAnAssDesc
    ..e  s shiftAnAssStr=shiftAnAssStr_","_shiftAnAssDr_"!"_shiftAnAssDesc
    
    s anMethodStr=""
	s anMethDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method	麻醉方法
	i anMethDr'="" d
		.s anMethNum=$l(anMethDr,"|")
		.f i=1:1:anMethNum d
		..s anMethId=$p(anMethDr,"|",i)
		..q:anMethId=""
		..s anMethDesc=$p($g(^ORC("ANMET",anMethId)),"^",2)
		..i $P(anMethDesc,"-",2)'="" s anMethDesc=$P(anMethDesc,"-",2)
		..i anMethodStr="" s anMethodStr=anMethId_"!"_anMethDesc
		..e  s anMethodStr=anMethodStr_","_anMethId_"!"_anMethDesc	
	s anDocMethodStr=""
	s anDocMethDr=$P(^DHCANOPArrange(opaId,"PA"),"^",89)
	i anDocMethDr'="" d
		.s anDocMethNum=$l(anDocMethDr,"|")
		.f i=1:1:anDocMethNum d
			..s anDocMethId=$p(anDocMethDr,"|",i)
			..q:anDocMethId=""
			..s anDocMethDesc=$p($g(^ORC("ANMET",anDocMethId)),"^",2)
			..i $P(anDocMethDesc,"-",2)'="" s anDocMethDesc=$P(anDocMethDesc,"-",2)
			..i anDocMethodStr="" s anDocMethodStr=anDocMethId_"!"_anDocMethDesc
			..e  s anDocMethodStr=anDocMethodStr_","_anDocMethId_"!"_anDocMethDesc	
	
	
	s anaLevelDr=""
	s anaLevelDr=$P(^DHCANOPArrange(opaId),"^",28)
	i anaLevelDr'="" s anaLevelDesc=$P($g(^DHCANC("OPLevel",anaLevelDr)),"^",2)
	e  s anaLevelDesc=""
	s anaLevel=anaLevelDr_"!"_anaLevelDesc
	s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
	s anaTheatreInDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",39)
	i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,dateformatnum)	//20170302+dyl
	e  s anaTheatreInDate=opStDate
	s anaTheatreInTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",40)
	i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,timeformatnum)
	e  s anaTheatreInTime=opStTime
	s anaTheatreOutDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",41)
	i anaTheatreOutDate'="" s anaTheatreOutDate=$zd(anaTheatreOutDate,dateformatnum)
	e  s anaTheatreOutDate=opEndDate
	s anaTheatreOutTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",42)
	i anaTheatreOutTime'="" s anaTheatreOutTime=$zt(anaTheatreOutTime,timeformatnum)
	e  s anaTheatreOutTime=opEndTime
	///手术室
	s opRoomDr=$P($g(^DHCANOPArrange(opaId)),"^",20)
	s opRoomDesc=""
	i opRoomDr'="" s opRoomDesc=$P($G(^DHCANC("OPRoom",opRoomDr)),"^",2)
	s opRoom=opRoomDr_"!"_opRoomDesc
	s opaSeq=$P(^DHCANOPArrange(opaId),"^",26) 							//OPA_seq	台次               
	s sub=0 f  s sub=$o(^DHCANOPArrange(opaId,"Shift",sub)) q:sub=""  d
	.i $p(^DHCANOPArrange(opaId,"Shift",sub),"^",39)="SN" d 
	..s scnShiftTime=$zt($p(^DHCANOPArrange(opaId,"Shift",sub),"^",19),2)
	.i $p(^DHCANOPArrange(opaId,"Shift",sub),"^",39)="CN" d
	..s cirShiftTime=$zt($p(^DHCANOPArrange(opaId,"Shift",sub),"^",19),2) 
	
	s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
	s scNurStr="",sScNurStr=""    ;洗手(器械)
	s id=0 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id)) q:(id="")!(id>20)  d
	   .s scnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id),"^",1)
	   .q:scnDr=""
	   .i scNurStr="" s scNurStr=scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	   .e  s scNurStr=scNurStr_","_scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	s id=20 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id)) q:(id="")  d
	   .s scnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id),"^",1)
	   .q:scnDr=""
	   .i sScNurStr="" s sScNurStr=scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	   .e  s sScNurStr=sScNurStr_","_scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	
	s cirNurStr="",sCirNurStr=""  ;巡床
	s id=0 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id)) q:(id="")!(id>20)   d
	.s cirDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id),"^",1)
	.q:cirDr=""
	.i cirNurStr=""  s cirNurStr=cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	.e  s cirNurStr=cirNurStr_","_cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	s id=20 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id)) q:(id="")   d
	   .s cirDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id),"^",1)
	   .q:cirDr=""
	   .i sCirNurStr=""  s sCirNurStr=cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	   .e  s sCirNurStr=sCirNurStr_","_cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)			//OPA_ScrubNurseNote 	器械护士,手术录入
	s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)			//OPA_CirculNurseNote	巡回护士,手工录入
	
	/************************start门诊手术排班信息*************************/
    ;获取主诉
	s selfReport=""  ; OPA.SelfReport (扩展字段) 主诉
	s retSe=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.SelfReport")
	i retSe'="" s selfReport=$p(retSe,$c(3),1)
	
	;获取门诊手术排班资源(暂时未使用)
	s operResource="",resourceDesc="",asTimeRangeDr="",operResourceId=""  ; OPA.OperResource (扩展字段门诊手术预约资源)
	s retOR=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperResource")
	i retOR'="" s operResourceId=$p(retOR,$c(3),1)
	i operResourceId'="" d
	.s reRowid=$p(operResourceId,"||",1)
	.s reSubId=$p(operResourceId,"||",2)
	.i reRowid'="" d
		..s resourceDesc=$p(^RB("RES",reRowid),"^",17) //资源描述
		..s asTimeRangeDr=$P($g(^RBAS(reRowid,reSubId,"DHC")),"^",17) //排班时段
		..s asTimeRangeDesc=$p($g(^DHCTimeRange(asTimeRangeDr)),"^",2) //排班时段描述
		..s resourceDesc=resourceDesc_"  "_asTimeRangeDesc
		..S operResource=operResourceId_"!"_resourceDesc
	
	;获取号源信息 OPA.QueueNo (扩展字段门诊手术预约号) (暂时未使用)
	s queueNo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.QueueNo")
	s queueNo=$p(queueNo,$c(3),1)
	;病人须知 ;OPA.PatNotice(扩展字段病人须知) 
	//s patNotice=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatNotice")
	s patNotice=$g(^DHCANOPArrange("PatNotice",opaId))
	
	;手术耗材 OPA.OperStock(扩展字段病人须知) 
	s retOS=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperStock")
	s operStockStr=$p(retOS,$c(3),1)
	i operStockStr'="" d
	.f i=1:1:$l(operStockStr,",") D
		..s operStId=$p(operStockStr,",",i)
		..q:'$d(^DHCANOPLOCStock(appLocId,operStId))
		..s ancDesc=$p($g(^DHCANOPLOCStock(appLocId,operStId)),"^",2)
		..i operStock="" s operStock=operStId_"!"_ancDesc
		..e  s operStock=operStock_","_operStId_"!"_ancDesc
	
	;患者电话 OPA.PatTel(扩展字段患者电话) 
	s telId=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatTel")
	s telId=$p(telId,$c(3),1)
	;备用耗材备注 ;OPA.OperStockNote(扩展字段耗材备注) 
	s operStockNote=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperStockNote")
	s operStockNote=$p(operStockNote,$c(3),1)
	;来院时间 ;OPA.PatComeHosTime(扩展字段来院时间) 
	s comeDTime=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatComeHosTime")
	s comeDTime=$p(comeDTime,$c(3),1)
	s comeDTime=$p(comeDTime,",",2)
	i comeDTime'="" s comeTime=##class(web.DHCClinicCom).ConvertToTime(comeDTime)
	i comeTime'="" s comeTime=$e(comeTime,1,5)
	/************************end门诊手术排班信息*************************/
	d SetRetData
	q retStr
SetRetData
	//病人基本信息
	s patientBaseInfo=EpisodeID_"^"_patName_"^"_regNo_"^"_sex_"^"_age_"^"_locDes_"^"_ward_"^"_bedCode_"^"_admReason_"^"_secretCode_"^"_patLevel_"^"_IsPatDisCharFlag_"^"_telId
    //病区信息
    s patWardInfo=operLoc_"^"_appLoc_"^"_appDoc_"^"_preDiagAndNotes_"^"_postDiag_"^"_surgeon_"^"_assistants_"^"_opDocNote_"^"_opMem_"^"_bodsList_"^"_operPosition_"^"_bloodType_"^"_opSeqNote_"^"_opDocGroup
    s patWardInfo=patWardInfo_"^"_selfReport_"^"_operResource_"^"_queueNo_"^"_patNotice_"^"_operStock_"^"_operStockNote_"^"_comeTime_"^"_surgeonLoc_"^"_patDiseaseHis ;update by lyn 
    //麻醉信息
    s anaesInfo=anDoc_"^"_anSupDoc_"^"_anNurse_"^"_anAssStr_"^"_shiftAnAssStr_"^"_anMethodStr_"^"_anaLevel_"^"_anDocNote_"^"_anDocMethodStr
    //手术室信息
    s opTheatreInfo=opRoom_"^"_opaSeq_"^"_scNurStr_"^"_sScNurStr_"^"_cirNurStr_"^"_sCirNurStr_"^"_scNurNote_"^"_cirNurNote 
    //手术时间
    s opDateTime=opStDate_"^"_opStTime_"^"_opArrDate_"^"_opArrTime_"^"_opEndDate_"^"_opEndTime_"^"_preDiscussDate_"^"_estiOperDuration_"^"_anaTheatreInDate_"^"_anaTheatreInTime_"^"_anaTheatreOutDate_"^"_anaTheatreOutTime_"^"_scnShiftTime_"^"_cirShiftTime
    //
    s retStr=patientBaseInfo_"@"_patWardInfo_"@"_anaesInfo_"@"_opTheatreInfo_"@"_opDateTime
}

// w ##class(web.DHCANOPArrange).GetMainDiagnos(294)

ClassMethod GetMainDiagnos(Adm) As %String
{
  q:Adm="" ""
  s diagdes=""
  ;业务，考虑到如果加前缀可能把诊断当成自定义，暂时不加，以后再改造
  s mradm=$P(^PAADM(Adm),"^",61)
   s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.q:curDigMainFlag'="Y"
		.s newDiagStr=curDigId_"!"_curDigDesc
		.i diagdes'="" s diagdes=diagdes_","_newDiagStr
		.e  s diagdes=newDiagStr

  /*
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
  	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")  d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp="DIS"
		  ..s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
		  ..s mainNote=$g(^MR(mradm,"DIA",mcl,"DES",1))
		  ..q:$P(^MR(mradm,"DIA",mcl,1),"^",20)'="Y"
		  ..i +icddr>0  d
			  ...i diagdes'="" s diagdes=diagdes_","_icddr_"!"_$P(^MRC("ID",icddr),"^",2)
			  ...e  s diagdes=icddr_"!"_$P(^MRC("ID",icddr),"^",2)
  */
  q diagdes
}

/// w ##class(web.DHCANOPArrange).GetMainDiagNote(4)
ClassMethod GetMainDiagNote(Adm) As %String
{
  q:Adm="" ""
  s diagnote=""
  s mradm=$P(^PAADM(Adm),"^",61)
  s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.q:curDigMainFlag'="Y"
		.s newDiagStr=curDigId_"!"_curDigDesc
		.i diagnote'="" s diagnote=diagnote_","_curDigNote
		.e  s diagnote=curDigNote

  /*
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
  	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")  d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp="DIS"
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .s mainNote=$g(^MR(mradm,"DIA",mcl,"DES",1))
	  .q:$P(^MR(mradm,"DIA",mcl,1),"^",20)'="Y"
	  .i +icddr>0  d
		  ..i diagnote'="" s diagnote=diagnote_","_mainNote
		  ..e  s diagnote=mainNote
		  */
  q diagnote
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrange","GetOpList",182)
Query GetOpList(opaId As %String = "") As %Query(ROWSPEC = "operId,operDesc,opLevelId,opLevelDesc,bldTpId,bldTypeDesc,operNotes,opSub,opdocLoc,opdocLocId,surgeon,surgeonId,Ass1,Ass1Id,Ass2,Ass2Id,Ass3,Ass3Id,Asso,AssoId")
{
}

ClassMethod GetOpListExecute(ByRef qHandle As %Binary, opaId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	i opaId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s adm=$P(anaId,"||",1)
	s anSub=$P(anaId,"||",2)
    s opSub=0 f  s opSub=$O(^OR(adm,"ANA",anSub,"OP",opSub)) q:(opSub="")  d
		.s sub=opSub
	    .s operDr="",operDesc="",opCategory="",opStatName="",opLevelDesc="",operNotes="",bldTypeDesc=""
		.s operDr=$P(^OR(adm,"ANA",anSub,"OP",opSub),"^",6)   ;ANAOP_Type_DR 
		.s operId=operDr
		.i operDr'="" d
			..i $D(^ORC("OPER",operDr)) d
				...s operDesc=$P(^ORC("OPER",operDr),"^",2)									;OPER_Desc			ORC_Operation									
				...s opCategoryId=$p(^ORC("OPER",operDr),"^",7) 							;OPER_DefaultCategory_DR	手术分类 
			    ...i opCategoryId'=""  s opCategory=$p($g(^ORC("CATEG",opCategoryId)),"^",2)
				...s opStatName=$p(^ORC("OPER",operDr),"^",35)
		.e  d	 //add by lyn 标准库bug修正  20160928
			..i $g(^OR(adm,"ANA",anSub,"OP",opSub))'=""  d
			...s operDesc=$g(^OR(adm,"ANA",anSub,"OP",opSub,"REM",2))						;OPER_LongDescription		手术统计名称
		.s opLevelId=$p($g(^OR(adm,"ANA",anSub,"OP",opSub,"DHC")),"^",1)	;手术分类
		.;i opLevelId'="" s opLevelDesc=$p(^DHCANC("OPLevel",opLevelId),"^",2)		;ORC_OperationCategay 
		.i opLevelId'="" s opLevelDesc=$p($g(^ORC("CATEG",opLevelId)),"^",2) ;update by lyn 20160811
		.b	;
		.s operNotes=$g(^OR(adm,"ANA",anSub,"OP",opSub,"REM",1))
		.s bldTpId=$p(^OR(adm,"ANA",anSub,"OP",opSub),"^",9)						;ANAOP_Blade_DR		手术刀口类型
		.i bldTpId'="" s bldTypeDesc=$p(^ORC("BLDTP",bldTpId),"^",2)				;ORC_BladeType	
		.s opdocLoc=""
		.s opdocLocId=$p(^OR(adm,"ANA",anSub,"OP",opSub,"DHC"),"^",7)	;术者科室
		.i +opdocLocId>0 s opdocLoc=$p(^CTLOC(opdocLocId),"^",2)
		.i $l(opdocLoc,"-")>1 s opdocLoc=$p(opdocLoc,"-",2)
		.s surgeon=""
		.s surgeonId=$P(^OR(adm,"ANA",anSub,"OP",opSub),"^",8) ;ANAOP_Surgeon_DR 手术医师
		.i surgeonId'="" d
			..s surgeon=##class(web.DHCANOPCom).GetNameById(surgeonId)
		.s Ass1="",Ass1Id="",Ass2="",Ass2Id="",Ass3="",Ass3Id=""
		.s Asso="",AssoId="",p=0,AssoIdStr=""
		.s as=0 f  s as=$O(^OR(adm,"ANA",anSub,"OP",opSub,"ASS",as)) q:(as="")  d
			..s asdr=$P(^OR(adm,"ANA",anSub,"OP",opSub,"ASS",as),"^",1)
			..q:asdr=""
			..s p=p+1
			..i p=1 s Ass1Id=$g(asdr)  ;一助
			..i Ass1Id'="" s Ass1=##class(web.DHCClinicCom).GetNameById(Ass1Id)
			..i p=2 s Ass2Id=$g(asdr) ;二助
			..i Ass2Id'="" s Ass2=##class(web.DHCClinicCom).GetNameById(Ass2Id)
			..i p=3 s Ass3Id=$g(asdr)  ;三助
			..i Ass3Id'="" s Ass3=##class(web.DHCClinicCom).GetNameById(Ass3Id)
			..i p>3 d
				...s AssoId=$g(asdr)
				...i Asso'="" s Asso=Asso_","_##class(web.DHCClinicCom).GetNameById(AssoId)
				...e  s Asso=##class(web.DHCClinicCom).GetNameById(AssoId)
				...i AssoIdStr'="" s AssoIdStr=AssoIdStr_","_AssoId_"!"_##class(web.DHCClinicCom).GetNameById(AssoId)
				...e  s AssoIdStr=AssoId_"!"_##class(web.DHCClinicCom).GetNameById(AssoId)
			..
		.d OutPutOPList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutOPList
	//operId,operDesc,opLevelId,opLevelDesc,bldTpId,bldTypeDesc,operNotes
	//opSub,opdocLoc,opdocLocId,surgeon,surgeonId,Ass1,Ass1Id,Ass2,Ass2Id,Ass3,Ass3Id,Asso,AssoId")
	set Data=$lb(operId,operDesc,opLevelId,opLevelDesc,bldTpId,bldTypeDesc,operNotes,opSub,opdocLoc,opdocLocId,surgeon,surgeonId,Ass1,Ass1Id,Ass2,Ass2Id,Ass3,Ass3Id,Asso,AssoIdStr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod UpdateAnRecord(opaId As %String, anmthIdStr As %String, anDocId As %String, anNurseId As %String, anAssIdStr As %String, shiftAnAssIdStr As %String, anSupDocId As %String = "", anDocNote As %String = "", anaLevelId As %String = "", ASAId As %String = "") As %String
{
	k PLIST
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    i ($G(^DHCCLSet("AnOp","Arrange"))="AN")&("FILP"'[$P(^DHCANOPArrange(opaId),"^",27)) d
    .&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status='R' where opa_rowid=:opaId)
   	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_AnDocNote=:anDocNote,OPA_OPLevel_Dr=:anaLevelId where opa_rowid=:opaId)
   	i SQLCODE'=0 q "更新手术申请表出错!"
   	&sql(select * into :PLIST() from sqluser.OR_Anaesthesia where ana_rowid=:anaId)
	s PLIST(7)=anDocId 						//ANA_Anaesthetist_DR	麻醉主治医师
	s PLIST(32)=ASAId		//ANA_ASA_DR  
	&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:anDocId,ANA_ORAnaNurse_DR=:anNurseId,
	ana_Supervisor_DR=:anSupDocId where ana_rowid=:anaId)
	i SQLCODE'=0 q 6
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    //保存多个麻醉方法
    s anmthIdStr=$tr(anmthIdStr,",","|")	;20160908+dyl:统一用|
	i anmthIdStr'="" s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=anmthIdStr 
    s opSub=0
    f  s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:opSub=""  d
    .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",12)'="M"
    .k ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS")
    .s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",0)=100				
    .f i=1:1:$L(anAssIdStr,",")  d   //麻醉助手或其它麻醉医师,小于20	
    ..q:$P(anAssIdStr,",",i)=""
    ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",i)=$P(anAssIdStr,",",i)
    .f i=1:1:$L(shiftAnAssIdStr,",")  d    //交麻醉医师,大于20
    ..q:$P(shiftAnAssIdStr,",",i)=""
    ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",0)=200
    ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",20+i)=$P(shiftAnAssIdStr,",",i)
        
   
 q "0"
}

ClassMethod UpdateOpRecordNew(opaId As %String, str1 As %String, scr As %String, cir As %String, strOp As %String, appType As %String = "", AppLocType As %String = "") As %String
{
    //手术室填写
	q:+opaId=0 "手术排班号为空!"_opaId_"/"
	k PLIST
	s arrTime=""
	//logUserId+"^"+opReq+"^"+note+"^"+ifShift+"^"+ordNo+"^"+""+"^"+opDateTime;
	i $p(str1,"^",2)'="" s arrTime=##class(web.DHCANOPCom).ConvertToTimeH($p(str1,"^",2))
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    if $P(strOp,"^",7)'=""
    {
		s opDtStr=$P(strOp,"^",7)
		s opStDate=##class(web.DHCANOPCom).ConvertToDateH($P(opDtStr,"|",1))
		s opStTime=##class(web.DHCANOPCom).ConvertToTimeH($P(opDtStr,"|",2))
		s opEndDate=##class(web.DHCANOPCom).ConvertToDateH($P(opDtStr,"|",3))
		s opEndTime=##class(web.DHCANOPCom).ConvertToTimeH($P(opDtStr,"|",4))
		;20120514+dyl
		i opStDate>+$h q "手术开始日期不能大于系统日期"
		e  i opStDate>opEndDate q "手术开始日期不能大于手术结束日期"
		e  i (opStDate=opEndDate)&((opStTime+300)>opEndTime) q "手术结束时间需要大于手术开始时间"
    }
    ;q $P(opDtStr,"|",1)_"^"_$P(opDtStr,"|",2)_"^"_$P(opDtStr,"|",3)_"^"_$P(opDtStr,"|",4)_"??????"
    ;q opStDate_opEndDate_((opStTime+300)>opEndTime)_"??????"
    s opStartDate=$p(^DHCANOPArrange(opaId),"^",14)
    i AppLocType'="O" {
	    s PLIST(5)=$P(str1,"^",1)  			//OPA_OpRoom_Dr		手术间
	    s PLIST(6)=$P(strOp,"^",5) 		//OPA_Seq			台次
	    ;20120605+dyl+同一天，同一台次，同一手术间
	    s ret=##class(web.UDHCANOPArrange).CheckArrData(opaId,$P(str1,"^",1),$P(strOp,"^",5),opStartDate)
	    i ret'=0 q "本手术间台次重复"_"/"_ret
    }
	s PLIST(16)=$P(strOp,"^",1) 		//OPA_ArrangeUsr_Dr	安排用户
	
	q:(appType="op")&(PLIST(20)'="")&("IPLF"[PLIST(20)) "病人手术状态不对，不能操作!"
	if appType="op"
	{   
		s PLIST(17)=$P($H,",",1)
		i arrTime="" s PLIST(18)=$P($H,",",2)
		e  s PLIST(18)=arrTime
		s PLIST(20)="R"	
		//20181207+dyl
		s anaId=$p(^DHCANOPArrange(opaId),"^",2)
		s ordId=$o(^OEORDi(0,"Ana",anaId,""))
		s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))

		s orderret=##class(appcom.OEOrdItem).Execute(ordId_"||"_ordSubId,$P(strOp,"^",1))
	}
	if appType="RegOp"
	{
		//s PLIST(7)=$g(opStDate)
		//s PLIST(9)=$g(opStTime)
		s PLIST(8)=$G(opEndDate)
		s PLIST(10)=$G(opEndTime)
		q:PLIST(20)="D" "不能对已拒绝手术操作!"
		q:PLIST(20)="I" "不能对未结束手术操作!"
		s PLIST(20)="F" //完成
		//s PLIST(51)="Y" //OPA_OpNurseOrdered
	}
	if ((appType="")!(appType="op"))&($g(^DHCCLSet("AnOp","AuditArrange"))'="Y")&($G(^DHCCLSet("AnOp","Arrange"))'="AN")&($P(str1,"^",7)'="")
	{
		s PLIST(20)="R" 	//安排
	}
	//s ^DHCANARRAGE("note",opaId)=$P(strOp,"^",3)	;注意事项
	s ^DHCANARRAGE("opreq",opaId)=$P(strOp,"^",2)	;备注
	s ^DHCANARRAGE("jb",opaId)=$P(strOp,"^",4)
	s PLIST(31)=$P($P(strOp,"^",6),"|",2)
	s PLIST(32)=$P($P(strOp,"^",6),"|",1)
	i PLIST(22)="G" s PLIST(22)="M"
	i PLIST(20)="F" s PLIST(22)="F"
	s PLIST(52)=$P(scr,"#",3)		//OPA_ScrubNurseNote	器械护士备注
	s PLIST(53)=$P(cir,"#",3)		//OPA_CirculNurseNote	巡回护士备注
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	q:SQLCODE'=0 "更新排班表出错!"
	//登记手术时间
	if (appType="RegOp")
	{
		
		//if (opStDate'="")&(opStTime'="")&(opEndDate'="")&(opEndTime'=""){
		//	&sql(update SQLUSER.OR_Anaesthesia set ANA_TheatreInDate=:opStDate,ANA_TheatreInTime=:opStTime,
		//	ANA_TheatreOutDate=:opEndDate,ANA_TheatreOutTime=:opEndTime where ANA_RowId=:anaId)
		//}
	}
	s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s opSub=0
    f  s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:opSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",12)'="M" 
        .i scr'="" d
            ..k ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN")
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",0)=100
            ..s scr1=$P(scr,"#",1)
            ..s num=$L(scr1,",")
            ..for i=1:1:num d
            ...q:$P(scr1,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",i)=$P(scr1,",",i)
            ..s scr2=$P(scr,"#",2)
            ..s num1=$L(scr2,",")
            ..for i=1:1:num1 d
            ...q:$P(scr2,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",0)=200
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",20+i)=$P(scr2,",",i)
        .i cir'="" d
            ..k ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN")
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",0)=100
            ..s cir1=$P(cir,"#",1)
            ..s num=$L(cir1,",")
            ..for i=1:1:num d
            ...q:$P(cir1,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",i)=$P(cir1,",",i)
            ..s cir2=$P(cir,"#",2)
            ..s num1=$L(cir2,",")
            ..for i=1:1:num1 d
            ...q:$P(cir2,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",0)=200
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",20+i)=$P(cir2,",",i)
   ;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
	    .s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONSCHEDULEINFO",opaId)
		.;s ^tmpDYL("ANOPARR",opaId)=OAret
		.;20161229+dyl+向电子病历发送消息
		.;s retEMR=""
		.;s retEMR=##class(EMRservice.BIEMRService).SetOperation(EpisodeID,opaId)
		.//安排完成的时候向消息平台发送一次信息+20161215+dyl
		.s opStat=$P(^DHCANOPArrange(opaId),"^",27)
		.i opStat="R" d
			..s anaId=$p(^DHCANOPArrange(opaId),"^",2)
			..s ordId=$o(^OEORDi(0,"Ana",anaId,""))
			..s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
			..s appLocId=$p(^DHCANOPArrange(opaId),"^",54)
			..Set rtnMes =##class(websys.DHCMessageInterface).Send("手术通知", "1039", $P(strOp,"^",1), EpisodeID , ordId_"||"_ordSubId , "" , "opaId是"_opaId,appLocId)
  
 q "0"
 //OR_An_Oper_Anaest_Assistant
}

ClassMethod UpdateOpRecord(opaId As %String, str1 As %String, scr As %String, cir As %String, strOp As %String, appType As %String = "", AppLocType As %String = "I", anMethodIdStr As %String = "") As %String
{
    //手术室填写
	//var str1=appLocId+"^"+appDocId+"^"+opaStartDate+"^"+opaStartTime+"^"+appUser+"^"+adm+"^"+oproomid+"^"+opmem+"^"+BloodRowId+"^"+ArrTime
	//str1=str1+"^"+ANCOPLRowId+"^"+PatHeight+"^"+PatWeight+"^"+preDiscussDate+"^"+estiOperDuration+"^"+opDocNote+"^"+opSeqNote+"^"+ordno+"^"+opaAppDate+"^"+opaAppTime
	//	申请科室ID^申请医师^手术日期^手术时间^登陆用户^病人就诊ID^手术间ID^手术要求^血型^安排时间^麻醉规模^身高^体重^术前讨论日期^预计手术时间^手术医师备注^手术编号^台次^申请日期(空)^申请时间(空)
	//var strOp=appUser+"^"+opreq+"^"+note+"^"+chjb+"^"+ordno+"^"+isAddInstrument+"|"+instrumentId+"^"+optime;
	//	登陆用户^备注^注意事项^是否交班^台次^是否增加器材|器材ID^手术开始日期|开始时间|结束日期|结束时间
	//n (opaId , str1 , scr , cir, strOp,appType) add by lyn
	//AppLocType :手术申请类型 住院为I，门诊为O
	//anMethodIdStr  门诊麻醉方法
	q:+opaId=0 "手术排班号为空!"_opaId_"/"
	k PLIST
	s arrTime=""
	i $p(str1,"^",10)'="" s arrTime=##class(web.DHCANOPCom).ConvertToTimeH($p(str1,"^",10))
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    if $P(strOp,"^",7)'=""
    {
		s opDtStr=$P(strOp,"^",7)
		s opStDate=##class(web.DHCANOPCom).ConvertToDateH($P(opDtStr,"|",1))
		s opStTime=##class(web.DHCANOPCom).ConvertToTimeH($P(opDtStr,"|",2))
		s opEndDate=##class(web.DHCANOPCom).ConvertToDateH($P(opDtStr,"|",3))
		s opEndTime=##class(web.DHCANOPCom).ConvertToTimeH($P(opDtStr,"|",4))
		;20120514+dyl
		i opStDate>+$h q "手术开始日期不能大于系统日期"
		e  i opStDate>opEndDate q "手术开始日期不能大于手术结束日期"
		e  i (opStDate=opEndDate)&(opStTime>opEndTime) q "手术开始时间不能大于手术结束时间"
    }
    s opStartDate=$p(str1,"^",3)
	    s PLIST(5)=$P(str1,"^",7)  			//OPA_OpRoom_Dr		手术间
	    s PLIST(6)=$P(strOp,"^",5) 		//OPA_Seq			台次
	    ;20120605+dyl+同一天，同一台次，同一手术间
	    if ($P(strOp,"^",5)'="")
	    {
	    s ret=##class(web.UDHCANOPArrange).CheckArrData(opaId,$P(str1,"^",7),$P(strOp,"^",5),opStartDate)
	    i ret'=0 q "本手术间台次重复"_"/"_ret
	    }
    s opStartDate=$p(str1,"^",3)
	s PLIST(16)=$P(strOp,"^",1) 		//OPA_ArrangeUsr_Dr	安排用户
	s PLIST(17)=PLIST(7)     			//OPA_ArrangeDate	安排日期=OPA_StartDate	手术开始日期
	s PLIST(18)=arrTime					//OPA_ArrangeTime	安排时间
	
	if appType'=""
	{
		//rem//if PLIST(7)="" s PLIST(7)=$G(opstdate)
		s PLIST(8)=$G(opEndDate)
		//rem//i $G(opsttime)'="" s PLIST(9)=$G(opsttime)
		//rem//e  s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4))
		s PLIST(10)=$G(opEndTime)
	}
	q:(appType="op")&(PLIST(20)'="")&("IPLF"[PLIST(20)) "病人手术状态不对，不能操作!"
	if appType="op"
	{   
		//s PLIST(9)=arrTime
		s PLIST(17)=$P($H,",",1)
		i arrTime="" s PLIST(18)=$P($H,",",2)
		e  s PLIST(18)=arrTime
		s PLIST(20)="R"	
	}
	if appType="RegOp"
	{
		q:PLIST(20)="D" "不能对已拒绝手术操作!"
		q:PLIST(20)="I" "不能对未结束手术操作!"
		//q:PLIST(49)'="Y"&($P(^DHCANOPArrange(opaId),"^",44)="Y") "麻醉科未计费!" //OPA_AnaDoctorOrdered
		s PLIST(20)="F" //完成
		//s PLIST(51)="Y" //OPA_OpNurseOrdered
	}
	if appType="RegNotApp"
	{
		s PLIST(20)="N" 	//非预约
	}
	if ((appType="")!(appType="op"))&($g(^DHCCLSet("AnOp","AuditArrange"))'="Y")&($G(^DHCCLSet("AnOp","Arrange"))'="AN")&($P(str1,"^",7)'="")
	{
		s PLIST(20)="R" 	//安排
	}
	//if $P(strOp,"^",8)'="" s PLIST(17)=$ZDH($P(strOp,"^",8),4) ;arrangedate
	//if $P(strOp,"^",9)'=""  s PLIST(18)=$ZTH($P(strOp,"^",9))  //arrangetime
	s ^DHCANARRAGE("note",opaId)=$P(strOp,"^",3)
	s ^DHCANARRAGE("opreq",opaId)=$P(strOp,"^",2)
	s ^DHCANARRAGE("jb",opaId)=$P(strOp,"^",4)
	s ^DHCANARRAGE("Pack",opaId)=$P(strOp,"^",6) //手术包  已不用
	s PLIST(31)=$P($P(strOp,"^",6),"|",2)
	s PLIST(32)=$P($P(strOp,"^",6),"|",1)
	i PLIST(22)="G" s PLIST(22)="M"
	i PLIST(20)="F" s PLIST(22)="F"
	s PLIST(43)=$P(str1,"^",16)   	//OPA_OpDocNote			手术医师备注
	s PLIST(52)=$P(scr,"#",3)		//OPA_ScrubNurseNote	器械护士备注
	s PLIST(53)=$P(cir,"#",3)		//OPA_CirculNurseNote	巡回护士备注
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	q:SQLCODE'=0 "更新排班表出错!"
	//登记手术时间
	if (appType="RegOp")
	{
		
		if (opStDate'="")&(opStTime'="")&(opEndDate'="")&(opEndTime'=""){
			&sql(update SQLUSER.OR_Anaesthesia set ANA_TheatreInDate=:opStDate,ANA_TheatreInTime=:opStTime,
			ANA_TheatreOutDate=:opEndDate,ANA_TheatreOutTime=:opEndTime where ANA_RowId=:anaId)
		}
	}
	s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s opSub=0
    f  s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:opSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",12)'="M" 
        .i AppLocType="O" s $p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",8)=$p(strOp,"^",8)
        .i scr'="" d
            ..k ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN")
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",0)=100
            ..s scr1=$P(scr,"#",1)
            ..s num=$L(scr1,",")
            ..for i=1:1:num d
            ...q:$P(scr1,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",i)=$P(scr1,",",i)
            ..s scr2=$P(scr,"#",2)
            ..s num1=$L(scr2,",")
            ..for i=1:1:num1 d
            ...q:$P(scr2,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",0)=200
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",20+i)=$P(scr2,",",i)
        .i cir'="" d
            ..k ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN")
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",0)=100
            ..s cir1=$P(cir,"#",1)
            ..s num=$L(cir1,",")
            ..for i=1:1:num d
            ...q:$P(cir1,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",i)=$P(cir1,",",i)
            ..s cir2=$P(cir,"#",2)
            ..s num1=$L(cir2,",")
            ..for i=1:1:num1 d
            ...q:$P(cir2,",",i)=""
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",0)=200
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",20+i)=$P(cir2,",",i)
   ;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
	    .s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONSCHEDULEINFO",opaId)
		.;s ^tmpDYL("ANOPARR",opaId)=OAret
		.;20161229+dyl+向电子病历发送消息
		.;s retEMR=""
		.;s retEMR=##class(EMRservice.BIEMRService).SetOperation(EpisodeID,opaId)
		.//安排完成的时候向消息平台发送一次信息+20161215+dyl
		.s opStat=$P(^DHCANOPArrange(opaId),"^",27)
		.i opStat="R" d
			..s anaId=$p(^DHCANOPArrange(opaId),"^",2)
			..s ordId=$o(^OEORDi(0,"Ana",anaId,""))
			..s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
			..s appLocId=$p(^DHCANOPArrange(opaId),"^",54)
			..Set rtnMes =##class(websys.DHCMessageInterface).Send("手术通知", "1039", $P(strOp,"^",1), EpisodeID , ordId_"||"_ordSubId , "" , "opaId是"_opaId,appLocId)
	/*
	i AppLocType="O",appType="RegOp"{ ;门诊手术完成后，将手术预约的号源释放
    	;获取号源信息 OPA.QueueNo (扩展字段门诊手术预约号) 
    	s retBQN=1,opResource=""
		s queueNo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.QueueNo")
		s queueNo=$p(queueNo,$c(3),1)
		s retOR=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperResource")
		i retOR'="" s opResource=$p(retOR,$c(3),1)
		i queueNo'="" s retBQN=##class(web.DHCANOPArrangeClinics).UpdateOpSequenceNoStat(opResource,queueNo,0)
		i +retBQN=0 q "手术完成,但被占用的号源信息没有释放！"
	}*/
	i AppLocType="O" {
		i anMethodIdStr'=""{
			//保存多个麻醉方法
	    	s anmthIdStr=$tr(anMethodIdStr,",","|")
	    	i anmthIdStr'="" s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=anmthIdStr 
		}
	}
	
  
 q "0"
 //OR_An_Oper_Anaest_Assistant
}

Query GetANOPArrange(opaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_OPArrange Where OPA_RowId=:opaId
}

Query GetANAnaestItem(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	
	SELECT * FROM SQLUser.DHC_AN_AnaestItem Where ANI_Parref=:parref
}

ClassMethod InsertAnaestItem(parref) As %String
{
	s chl=$o(^DHCANOPArrange(parref,"ANI",""))

	i chl="" d
	.&sql(insert into DHC_AN_AnaestItem set ANI_Parref=:parref)
	q 0
}

/// Creator：LYN
/// CreatDate：20160803
/// Descripation：保存设置的信息
/// 信息暂时保存到global中，设置到globa中保存数据
/// ^DHCANOP("APPSET","LOC",locId)  ---通过科室保存默认模板
/// ^DHCANOP("APPSET","DOC",ctcptId)  ---通过医生保存默认模板
/// w ##class(web.DHCANOPArrange).SaveSetingInfo("1","2","45678")
/// 病人须知^手术室^常用手术
ClassMethod SaveSetingInfo(LocId As %String, CtcptId As %String, SetingInfo As %String) As %String
{
	b
	i LocId'="" s ^DHCANOP("APPSET","LOC",LocId)=SetingInfo
	i CtcptId'="" s ^DHCANOP("APPSET","DOC",CtcptId)=SetingInfo
	q 1
}

/// Creator:LYN
/// CreatDate:2016/08/03
/// Description:获取手术申请界面控制项信息，
/// 
ClassMethod GetAppSetInfo(LocId As %String, CtcptId As %String) As %String
{
	s ret=""
	i LocId'="" s ret=$g(^DHCANOP("APPSET","LOC",LocId))
	i CtcptId'="" s ret=$g(^DHCANOP("APPSET","DOC",CtcptId))
	q ret
}

/// 更新恢复床位
/// w ##Class(web.DHCANOPArrange).UpdatePacuBed("190670","64")
ClassMethod UpdatePacuBed(opaId As %String = "", PacuBedId As %String = "") As %String
{
	s opaId=+opaId
	q:(opaId=0)!(opaId="") "手术申请不存在"
	s $P(^DHCANOPArrange(opaId),"^",47)=PacuBedId
	q 0
}

/// 手术列表界面更新麻醉医师及麻醉方法
/// 入参：opaId：手术排班表Id，docId：麻醉医生Id，anmId：麻醉方法Id
/// 更新人dingyanli，程序from yangqin
/// 20170314
ClassMethod UpdateAnArrDocAndMethod(opaId, docId, anmId)
{
	i docId'=""
	{
		k PLIST
	    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	   	&sql(select * into :PLIST() from sqluser.OR_Anaesthesia where ana_rowid=:anaId)
		s PLIST(7)=docId
		&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:docId where ana_rowid=:anaId)
		i SQLCODE'=0 q "插入有问题,请联系工程师"
	}
	i anmId'=""
	{
		s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		s EpisodeID=+anaId
	    s anaSub=$p(anaId,"||",2)
	    s anmId=$tr(anmId,",","|")
	    //保存多个麻醉方法
		i anmId'="" s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=anmId 
	}
 q 0
}

ClassMethod CheckInBedFlag(adm) As %String
{
	
	s ret="Y"
	s paadmStatus=$p($g(^PAADM(adm)),"^",20) 
	i paadmStatus="C" s ret="该就诊记录已经取消"
	q:(ret'="Y") ret
	s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
	s curWardId=$p($g(^PAADM(adm)),"^",70) 
	i bedSub="" s ret="患者尚未安排床位"
	q ret
}

/// w ##class(web.DHCANOPArrange).CheckDISFlag(1)
ClassMethod CheckDISFlag(Adm) As %String
{
	s ret="N",flag="N"
	 s mradm=$P(^PAADM(Adm),"^",61)
	s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.q:flag="Y"
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.q:curDigType'="出院诊断"
		.s flag="Y",ret="Y"

	 /*
	s i=0
  	s retIcdId=""
  	s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")!(i=1)  d
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .q:icddr=""
	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")!(i=1)   d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..i diagtyp="DIS" s ret="Y",i=1
	*/
	
	q ret
}

}
