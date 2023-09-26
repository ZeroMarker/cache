Import SQLUser

/// Medical Record's request
/// by wuqk 2008-2
Class web.DHCWMRRequest Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 115;

/// 更新申请
ClassMethod UpdateRequest(InString)
{
	n (InString)
    
    ;AimDate
    s:$p(InString,"^",6)["-" $p(InString,"^",6)=$zdh($p(InString,"^",6),3)
    s:$p(InString,"^",6)["/" $p(InString,"^",6)=$zdh($p(InString,"^",6),4)
    s:$p(InString,"^",6)="" $p(InString,"^",6)=+$h
    
    ;FirstFlag
    s $p(InString,"^",9)=$s($p(InString,"^",9)["Y":"Y",1:"N")
    
    ;RequestDate
    s:$p(InString,"^",10)["-" $p(InString,"^",10)=$zdh($p(InString,"^",10),3)
    s:$p(InString,"^",10)["/" $p(InString,"^",10)=$zdh($p(InString,"^",10),4)
    s:$p(InString,"^",10)="" $p(InString,"^",10)=+$h
    
    ;RequestTime
    s:$p(InString,"^",11)[":" $p(InString,"^",11)=$zth($p(InString,"^",11))
    s:$p(InString,"^",11)="" $p(InString,"^",11)=$p($h,",",2)
    
    ;IsActive
    s $p(InString,"^",13)=$s($p(InString,"^",13)["Y":"Y",1:"N")
    
    ;PrintFlag
    s $p(InString,"^",20)=$s($p(InString,"^",20)["Y":"Y",1:"N")	
	
	;PrintDate
	s:$p(InString,"^",21)["-" $p(InString,"^",21)=$zdh($p(InString,"^",21),3)
    s:$p(InString,"^",21)["/" $p(InString,"^",21)=$zdh($p(InString,"^",21),4)
	
	;PrintTime
    s:$p(InString,"^",22)[":" $p(InString,"^",22)=$zth($p(InString,"^",22))
    
	s ret=..UpdateM(InString)
	q ret
}

ClassMethod UpdateM(Instring)
{
    n (Instring)
    s RowId=$p(Instring,"^",1)             ;RowId
    s PLIST(2)=+$p(Instring,"^",2)         ;MrType_Dr
    s PLIST(3)=+$p(Instring,"^",3)         ;MrMain_Dr
    s PLIST(4)=+$p(Instring,"^",4)         ;RequestType
    s PLIST(5)=+$p(Instring,"^",5)         ;WorkItem_Dr
    s PLIST(6)=$p(Instring,"^",6)          ;AimDate
    s PLIST(7)=+$p(Instring,"^",7)         ;AimCtLoc_Dr
    s PLIST(8)=$p(Instring,"^",8)          ;AimUser_Dr
    s PLIST(9)=$p(Instring,"^",9)          ;FirstFlag
    s PLIST(10)=$p(Instring,"^",10)         ;RequestDate
    s PLIST(11)=$p(Instring,"^",11)         ;RequestTime
    s PLIST(12)=+$p(Instring,"^",12)        ;RequestUser_Dr
    s PLIST(13)=$p(Instring,"^",13)         ;IsActive
    s PLIST(14)=$p(Instring,"^",14)         ;ResponseDate
    s PLIST(15)=$p(Instring,"^",15)         ;ResponseTime
    s PLIST(16)=$p(Instring,"^",16)        ;ResponseUser_Dr
    s PLIST(17)=$p(Instring,"^",17)         ;MrMainStatus_Dr
    s PLIST(18)=$p(Instring,"^",18)         ;ResumeText
    s PLIST(19)=$p(Instring,"^",19)         ;Paadm_Dr
    //Add By LiYang 2009-07-24 增加打印标志 打印日期、时间
    s PLIST(20)=$p(Instring,"^",20)         ;PrintFlag
    s PLIST(21)=$p(Instring,"^",21)         ;PrintDate
    s PLIST(22)=$p(Instring,"^",22)         ;PrintTime     
    i RowId="" d
    .&sql(Insert into DHC_WMR_Requset values :PLIST())
    e  d
    .&sql(Update DHC_WMR_Requset values :PLIST() where RowId=:RowId)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdatePrintFlag(RowID)
{
	n (RowID)
	s flag="Y"
	s PrintDate=+$h
	s PrintTime=$p($h,",",2)
	i 1  d
	.&sql(Update DHC_WMR_Requset set PrintFlag=:flag, PrintDate=:PrintDate, PrintTime=:PrintTime  where RowId=:RowID)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 响应申请
ClassMethod RespRequest(InString)
{
	n (InString)
	s ret=""
	
	s ReqRowId=+$p(InString,"^",1)
	s:ReqRowId'>0 ret=-1
	;q:ret
	s:'$d(^DHCWMRReq(ReqRowId)) ret=-2
	q:ret<0 ret
	s IsActive=$p($g(^DHCWMRReq(ReqRowId)),"^",12)
	s:IsActive'="Y" ret=-3
	q:ret<0 ret
	
    ;AimDate
    s:$p(InString,"^",6)["-" $p(InString,"^",6)=$zdh($p(InString,"^",6),3)
    s:$p(InString,"^",6)["/" $p(InString,"^",6)=$zdh($p(InString,"^",6),4)
    s:$p(InString,"^",6)="" $p(InString,"^",6)=+$h
    
	;FirstFlag
    s $p(InString,"^",9)="N"
    
    ;RequestDate
    s:$p(InString,"^",10)["-" $p(InString,"^",10)=$zdh($p(InString,"^",10),3)
    s:$p(InString,"^",10)["/" $p(InString,"^",10)=$zdh($p(InString,"^",10),4)
    s:$p(InString,"^",10)="" $p(InString,"^",10)=+$h
    
    ;RequestTime
    s:$p(InString,"^",11)[":" $p(InString,"^",11)=$zth($p(InString,"^",11))
    s:$p(InString,"^",11)="" $p(InString,"^",11)=$p($h,",",2)
    
	;IsActive
    s $p(InString,"^",13)="N"
    
    ;ResponseDate
    s:$p(InString,"^",14)["-" $p(InString,"^",14)=$zdh($p(InString,"^",14),3)
    s:$p(InString,"^",14)["/" $p(InString,"^",14)=$zdh($p(InString,"^",14),4)
    s:$p(InString,"^",14)="" $p(InString,"^",14)=+$h
    
    ;ResponseTime
    s:$p(InString,"^",15)[":" $p(InString,"^",15)=$zth($p(InString,"^",15))
    s:$p(InString,"^",15)="" $p(InString,"^",15)=$p($h,",",2)
    
    ;MrMainStatus_Dr
    s:$p(InString,"^",17)="" ret=-4
    
    q:ret<0 ret
	s ret=..UpdateM(InString)
	q ret
}

ClassMethod GetRequest(RequestRowId)
{
	n (RequestRowId)
	s ret=""
	q:'$d(^DHCWMRReq(+RequestRowId)) ret
	s s=+RequestRowId_"^"_$g(^DHCWMRReq(+RequestRowId))
	s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($p(s,"^",6),3)
	s:$p(s,"^",10)'="" $p(s,"^",10)=$zd($p(s,"^",10),3)
	s:$p(s,"^",14)'="" $p(s,"^",14)=$zd($p(s,"^",14),3)
	s:$p(s,"^",11)'="" $p(s,"^",11)=$zt($p(s,"^",11))
	s:$p(s,"^",15)'="" $p(s,"^",15)=$zt($p(s,"^",15))
	s ret=s
	q ret
}

ClassMethod GetLongRequest(RequestRowId)
{
	n (RequestRowId)
	s ret=""
	q:RequestRowId="" ret
	q:'$d(^DHCWMRReq(+RequestRowId)) ret
	s s=+RequestRowId_"^"_$g(^DHCWMRReq(+RequestRowId))
	s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($p(s,"^",6),3)
	s:$p(s,"^",10)'="" $p(s,"^",10)=$zd($p(s,"^",10),3)
	s:$p(s,"^",14)'="" $p(s,"^",14)=$zd($p(s,"^",14),3)
	s:$p(s,"^",21)'="" $p(s,"^",21)=$zd($p(s,"^",21),3)
	s:$p(s,"^",11)'="" $p(s,"^",11)=$zt($p(s,"^",11))
	s:$p(s,"^",15)'="" $p(s,"^",15)=$zt($p(s,"^",15))
	s:$p(s,"^",22)'="" $p(s,"^",22)=$zt($p(s,"^",22))
	
	
	s:$p(s,"^",8)'="" $p(s,"^",8)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",8))
	s:$p(s,"^",12)'="" $p(s,"^",12)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",12))
	s:$p(s,"^",16)'="" $p(s,"^",16)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",16))
	
	s:$p(s,"^",7)'="" $p(s,"^",7)=##class(web.DHCWMRMedBaseCtl).GetCtlocStr($p(s,"^",7))
	s MrType=""
	s:$p(s,"^",2)'="" MrType=##class(web.DHCWMRDictionaryCtl).GetDataById($p(s,"^",2))
	s MrType=$tr(MrType,"^","/")
	s $p(s,"^",2)=MrType
	s RequestType=""
	s:$p(s,"^",4)'="" RequestType=##class(web.DHCWMRDictionaryCtl).GetDataById($p(s,"^",4))
	s RequestType=$tr(RequestType,"^","/")
	s $p(s,"^",4)=RequestType
	s Item=""
	s:$p(s,"^",5)'="" Item=##class(web.DHCWMRWorkItemCtl).GetDataById($p(s,"^",5))
	s Item=$tr(Item,"^","/")
	s $p(s,"^",5)=Item
	s ret=s
	q ret
}

ClassMethod GetLongReqByMS(MrMainStatus)
{
	n (MrMainStatus)
	;^DHCWMRReq(0,"MainStatus",{MrMainStatus_Dr},{RowId})
	s ret=""
    q:'$d(^DHCWMRReq(0,"MainStatus",MrMainStatus)) ret
    s reqRowId=$o(^DHCWMRReq(0,"MainStatus",MrMainStatus,""))
    s ret=..GetLongRequest(reqRowId)
    q ret
}

ClassMethod GetReqList(MrMainRowId, AimDateFrom, AimDateTo, sIsActive)
{
	n (MrMainRowId,AimDateFrom,AimDateTo,sIsActive)
	s ret=""
	q:'$d(^DHCWMRReq(0,"MainAimDate",MrMainRowId)) ret
	s:AimDateFrom'="" AimDateFrom=$zd(AimDateFrom,3)
	s:AimDateFrom="" AimDateFrom=+$h
	s:AimDateTo'="" AimDateTo=$zd(AimDateTo,3)
	s:AimDateTo="" AimDateTo=+$h
	s tmpDate=AimDateFrom-1
	f  s tmpDate=$o(^DHCWMRReq(0,"MainAimDate",MrMainRowId,tmpDate)) q:(tmpDate="")!(tmpDate>AimDateTo)  d
	.s FirstFlag=""
	.f  s FirstFlag=$o(^DHCWMRReq(0,"MainAimDate",MrMainRowId,tmpDate,FirstFlag),-1) q:FirstFlag=""  d
	..s ReqRowId=""
	..f  s ReqRowId=$o(^DHCWMRReq(0,"MainAimDate",MrMainRowId,tmpDate,FirstFlag,ReqRowId)) q:ReqRowId=""  d
	...s IsActive=$p($g(^DHCWMRReq(+ReqRowId)),"^",12)
	...q:(sIsActive'=IsActive)&(sIsActive'="")
	...s s=..GetLongRequest(+ReqRowId)
	...s ret=ret_s_$c(1)
	q ret
}

ClassMethod NewRequest(InString)
{
	n (InString)
	s MrMainDr=+$p(InString,"^",3)
	
    ;AimDate
    s:$p(InString,"^",6)["-" AimDate=$zdh($p(InString,"^",6),3)
    s:$p(InString,"^",6)["/" AimDate=$zdh($p(InString,"^",6),4)
    s:$p(InString,"^",6)="" AimDate=+$h
    
    s FirstFlag="N"
    s:'$d(^DHCWMRReq(0,"MainAimDate",MrMainDr,AimDate,"Y")) FirstFlag="Y"
    
    ;FirstFlag
    s $p(InString,"^",9)=FirstFlag
    s ret=..UpdateRequest(InString)
    q ret
}

ClassMethod CommitReqIndex(Instring)
{
	n (Instring)
	s ret=1
	Tstart
	s flag=0
	f i=1:1:$l(Instring,"^") q:flag=1  d
	.s ReqRowId=+$p(Instring,"^",i)
	.q:ReqRowId'>0
	.s FirstFlag="N"
	.s:i=1 FirstFlag="Y"
	.s s=..GetRequest(ReqRowId)
	.q:s=""
	.i $p(s,"^",9)'=FirstFlag d
	..s $p(s,"^",9)=FirstFlag
	..s ret=..UpdateRequest(s)
	..s:ret<0 flag=1
	i flag=1 TRollBack
	i flag=0 TCommit
    q ret
}

/// 转移病案
ClassMethod TransferReq(ReqRowId, ItemDr, UserId)
{
	;n (ReqRowId,ItemDr,UserId)
	s ret=-1
	s sRequest=..GetRequest(ReqRowId)
	q:sRequest="" ret
	
	s ret=-2
	;IsActive
	q:$p(sRequest,"^",13)'="Y" ret
	
	s MainRowid=+$p(sRequest,"^",3)
	s sStatus=""
	s ret=-3
	s $p(sStatus,"^",1)=MainRowid        ;ParRef
    ;s $p(sStatus,"^",2)=""        ;Sub
    s $p(sStatus,"^",3)=ItemDr        ;病案操作项目/状态
    s $p(sStatus,"^",4)=UserId        ;转交人   
    ;s $p(sStatus,"^",5)        ;操作日期  
    ;s $p(sStatus,"^",6)        ;操作时间   
    s $p(sStatus,"^",7)=$p(sRequest,"^",8)        ;接收人 
	
	s ret=##class(web.DHCWMROperation).Operation(0, ItemDr, MainRowid, "", sStatus, "", ReqRowId)
	
    q ret
}

ClassMethod GetqryRequestList(aimDateFrom, aimDateTo, MrTypeList, ReqTypeList, WorkItemList, ActiveList, FirstFlag)
{
	n (aimDateFrom, aimDateTo, MrTypeList, ReqTypeList, WorkItemList, ActiveList,FirstFlag)
	s JIndex=$j
	k ^CacheTemp("DHCWMRReqList",$j)
	
    s:aimDateFrom["-" aimDateFrom=$zdh(aimDateFrom,3)
    s:aimDateFrom["/" aimDateFrom=$zdh(aimDateFrom,4)
    
    s:aimDateTo["-" aimDateTo=$zdh(aimDateTo,3)
    s:aimDateTo["/" aimDateTo=$zdh(aimDateTo,4)
    
    s:FirstFlag'="" FirstFlag=$s(FirstFlag["Y":"Y",1:"N")
    
    q:(MrTypeList="")!(ReqTypeList="")!(WorkItemList="") JIndex
    
    s MrTypeList="^"_MrTypeList_"^"
    s ReqTypeList="^"_ReqTypeList_"^"
    s WorkItemList="^"_WorkItemList_"^"
    ;^DHCWMRReq(0,"DateFirst",{AimDate},{IsActive},{FirstFlag},{RowId})
    s tmpDate=aimDateFrom-1
    f  s tmpDate=$o(^DHCWMRReq(0,"DateFirst",tmpDate)) q:(tmpDate="")!(tmpDate>aimDateTo)  d
    .;w !,tmpDate
    .s tmpActive=""
    .f  s tmpActive=$o(^DHCWMRReq(0,"DateFirst",tmpDate,tmpActive)) q:tmpActive=""  d
    ..;w !,tmpActive
    ..q:(ActiveList'="")&(ActiveList'[tmpActive)
    ..s tmpFirstFlag=""
    ..f  s tmpFirstFlag=$o(^DHCWMRReq(0,"DateFirst",tmpDate,tmpActive,tmpFirstFlag)) q:tmpFirstFlag=""  d
    ...q:(FirstFlag'="")&&(FirstFlag'=tmpFirstFlag)
    ...s reqRowId=""
    ...f  s reqRowId=$o(^DHCWMRReq(0,"DateFirst",tmpDate,tmpActive,tmpFirstFlag,reqRowId)) q:reqRowId=""  d
    ....s s=$g(^DHCWMRReq(+reqRowId))
    ....s tmpMrType="^"_$p(s,"^",1)_"^"
    ....s tmpReqType="^"_$p(s,"^",3)_"^"
    ....s tmpWorkItem="^"_$p(s,"^",4)_"^"
    ....s tmpPaadm=$p(s,"^",18)
    ....s tmp=$g(^PAADM(+tmpPaadm))
    ....s VisitStatus=$p(tmp,"^",20)
    ....q:VisitStatus="C"
    ....q:MrTypeList'[tmpMrType
    ....q:ReqTypeList'[tmpReqType
    ....q:WorkItemList'[tmpWorkItem
    ....s tmpMrMain=+$p(s,"^",2)
    ....q:$p($g(^DHCWMRMAIN(+tmpMrMain)),"^",6)'="Y"
    ....s tmpMrNo=$p($g(^DHCWMRMAIN(+tmpMrMain)),"^",2)
    ....q:tmpMrNo=""
    ....s ^CacheTemp("DHCWMRReqList",$j,tmpMrNo,+reqRowId)=""
	
	q JIndex
}

ClassMethod qryRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = qryRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod qryRequestExecute(ByRef qHandle As %Binary, aimDateFrom As %String, aimDateTo As %String, MrTypeList As %String, ReqTypeList As %String, WorkItemList As %String, ActiveList As %String, FirstFlag As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^Wuqk(0)=$lb(aimDateFrom, aimDateTo, MrTypeList, ReqTypeList, WorkItemList, ActiveList,FirstFlag)
	Set JIndex=..GetqryRequestList(aimDateFrom, aimDateTo, MrTypeList, ReqTypeList, WorkItemList, ActiveList,FirstFlag)
	s tmpMrNo=""
	f  s tmpMrNo=$o(^CacheTemp("DHCWMRReqList",$j,tmpMrNo)) q:tmpMrNo=""  d
	.s tmpreqRowId="" f  s tmpreqRowId=$o(^CacheTemp("DHCWMRReqList",$j,tmpMrNo,tmpreqRowId)) q:tmpreqRowId=""  d
	..s ret=$$BuildqryRequset(tmpreqRowId)
	..s ind=ind+1
	
	Quit $$$OK
BuildqryRequset(tmpreqRowId)
	s (reqRowId,MrTypeDesc,MrNo,PatientId,PatNo,PatName,Paadm,AimCtlocDesc,MrMain,MrIsStayIn,EmergencyFlag,FirstFlag,AimDate,AimUserName,ReqTypeDesc,WorkItemDesc,CardNo,RegfeeDocId,RegfeeDoc,RegDate,RegTime,RegTimeRange,AimUpCtlocDesc,RequestDate,RequestTime,RequestUser,PrintFlag,PrintDate,PrintTime)=""
    s sLongRequest=..GetLongRequest(+tmpreqRowId)
    s MrMainRowId=$p(sLongRequest,"^",3)
    s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(+MrMainRowId)
    s tmppapmi=$p(sMrMain,"^",4)
    s tmppaadm=$p(sLongRequest,"^",19)
    s RequestDate=$p(sLongRequest,"^",10)
    s RequestTime=$p(sLongRequest,"^",11)
    s RequestUser=$p(sLongRequest,"^",12)
    
    s sPatInfo=##class(web.DHCWMRMedBaseCtl).GetPatInfo(tmppapmi)
    s sPaadmInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(tmppaadm)
    s reqRowId=+tmpreqRowId
    s MrTypeDesc=$p($p(sLongRequest,"^",2),"/",4)
    s MrNo=$p(sMrMain,"^",3)
    s PatientId=+tmppapmi
    s PatNo=$p(sPatInfo,$c(2),23)
    s PatName=$p(sPatInfo,$c(2),1)
    s Paadm=tmppaadm
    ;User.DHCRegisterationFee
    ;增加卡号,号别,挂号日期,挂号时间,时段
    s CardNo="",RegfeeDoc="",RegfeeDocId="",RegDate="",RegTime="",RegTimeRange=""
    ;^DHCCARDi("CF",0,"PAPMIDR",{CF_PAPMI_DR},{CF_RowID})
    i $d(^DHCCARDi("CF",0,"PAPMIDR",PatientId)) d
    .s CardRefId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientId,0))
    .s tmp=$g(^DHCCARD("CF",CardRefId))
    .q:tmp=""
    .s CardNo=$p(tmp,"^",2)
    i $d(^User.DHCRegistrationFeeI("ADM"," "_Paadm)) d
    .s RegRowid=$o(^User.DHCRegistrationFeeI("ADM"," "_Paadm,0))
    .q:RegRowid=""
    .s tmp=$g(^User.DHCRegistrationFeeD(RegRowid))
    .q:tmp=""
    .s RegfeeDocId=$list(tmp,14)
    .s:RegfeeDocId'="" RegfeeDoc=$p($g(^CTPCP(+RegfeeDocId,1)),"^",2)
    .s RegDate=$list(tmp,15)
    .s:RegDate'="" RegDate=$zd(+RegDate,3)
    .s RegTime=$list(tmp,16)
    .s:RegTime'="" RegTime=$zt(+RegTime,1)
    .s RegTimeRangeId=$list(tmp,21)
    .s:RegTimeRangeId'="" RegTimeRange=$p($g(^DHCTimeRange(+RegTimeRangeId)),"^",2)
    //s PaadmCtlocDesc=$p($p(sPaadmInfo,"^",7),"/",2)
    s AimCtlocDesc=$p($p(sLongRequest,"^",7),"/",2)
    s MrMain=+MrMainRowId
    s MrIsStayIn=$p(sMrMain,"^",8)
    
    s PaadmType=$p($g(^PAADM(+Paadm)),"^",2)
    s EmergencyFlag=$s(PaadmType="E":"Y",1:"N")
    s FirstFlag=$s($p(sLongRequest,"^",9)["Y":"Y",1:"N")
    s AimDate=$p(sLongRequest,"^",6)
    s AimUserName=$p($p(sLongRequest,"^",8),"/",3)
 	s ReqTypeDesc=$p($p(sLongRequest,"^",4),"/",4)
 	s WorkItemDesc=$p($p(sLongRequest,"^",5),"/",3)
 	s PrintFlag=$p(sLongRequest,"^",20)
 	s PrintDate=$p(sLongRequest,"^",21)
 	s PrintTime=$p(sLongRequest,"^",22)
 	;add by zf 2008-04-01
 	;增加上一申请科室（病案所在科室），没有为空。
 	;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{ChildSub})
 	s tmpMainId=+MrMainRowId
 	i $d(^DHCWMRMAIN(tmpMainId,"S")) d
 	.s tmpSubId=$o(^DHCWMRMAIN(tmpMainId,"S",""),-1)
 	.q:+tmpSubId=0
 	.s tmpMSRowId=tmpMainId_"||"_tmpSubId
 	.s tmpRequest=..GetLongReqByMS(tmpMSRowId)
 	.s AimUpCtlocDesc=$p($p(tmpRequest,"^",7),"/",2)
 	;end by zf
 	
    set Data=$lb(reqRowId,MrTypeDesc,MrNo,PatientId,PatNo,PatName,Paadm,AimCtlocDesc,MrMain,MrIsStayIn,EmergencyFlag,FirstFlag,AimDate,AimUserName,ReqTypeDesc,WorkItemDesc,CardNo,RegfeeDocId,RegfeeDoc,RegDate,RegTime,RegTimeRange,AimUpCtlocDesc,RequestDate,RequestTime,RequestUser,PrintFlag,PrintDate,PrintTime)
 	Set ^CacheTemp(repid,ind)=Data
    q 0
}

ClassMethod qryRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = qryRequestExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRRequest","qryRequest","61082","61082","6","87","28","Y","Y")
Query qryRequest(aimDateFrom As %String, aimDateTo As %String, MrTypeList As %String, ReqTypeList As %String, WorkItemList As %String, ActiveList As %String, FirstFlag As %String) As %Query(ROWSPEC = "reqRowId:%String,MrTypeDesc:%String,MrNo:%String,PatientId:%String,PatNo:%String,PatName:%String,Paadm:%String,AimCtlocDesc:%String,MrMain:%String,MrIsStayIn:%String,EmergencyFlag:%String,FirstFlag:%String,AimDate:%String,AimUserName:%String,ReqTypeDesc:%String,WorkItemDesc:%String,CardNo:%String,RegfeeDocId:%String,RegfeeDoc:%String,RegDate:%String,RegTime:%String,RegTimeRange:%String,AimUpCtlocDesc:%String,RequestDate:%String,RequestTime:%String,RequestUser:%String,PrintFlag:%String,PrintDate:%String,PrintTime:%String")
{
}

ClassMethod qryAdmReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = qryAdmReqExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod qryAdmReqExecute(ByRef qHandle As %Binary, AdmDate As %String, Papmi As %String, AdmType As %String, FirstFlg As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(0)=$lb(AdmDate,Papmi)
	s:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	s:AdmDate["/" AdmDate=$zdh(AdmDate,4)
	s AdmDate=+AdmDate
	s:FirstFlg'="" FirstFlg=$s(FirstFlg["Y":"Y",1:"N")
	
	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Quit:Papmi="" $$$OK
	Quit:'$d(^PAPERdr(+Papmi)) $$$OK
	s tmpAdmType=""
	f  s tmpAdmType=$o(^PAPERdr(+Papmi,"ADM",tmpAdmType)) q:tmpAdmType=""  d
	.q:(AdmType'="")&&(AdmType'[tmpAdmType)
	.s Paadm=0
	.f  s Paadm=$o(^PAPERdr(+Papmi,"ADM",tmpAdmType,Paadm)) q:Paadm=""  d
	..s tmp=$g(^PAADM(Paadm))
	..q:tmp=""
	..s tmpAdmDate=$p(tmp,"^",6)
	..q:(AdmDate'=0)&&(AdmDate'=tmpAdmDate)
	..s ret=$$xBuildqryAdmReq(Papmi,Paadm,FirstFlg)
	..q:+ret<0
	..s ind=ind+1
	
	Quit $$$OK
	
xBuildqryAdmReq(Papmi,Paadm,FirstFlg)
	s (reqRowId,AdmNo,MrTypeDesc,MrNo,PatientId,PatNo,PatName,AimCtlocDesc,MrMain,MrIsStayIn,EmergencyFlag,FirstFlag,AimDate,AimUserName,ReqTypeDesc,WorkItemDesc,CardNo,RegfeeDoc,RegfeeDocId,RegDate,RegTime,RegTimeRange,PaadmNo,PaadmType,IsActive,VisitStatus,RequestDate,RequestTime,RequestUser)=""
    
    ;就诊类型,就诊号,病人基本信息
    s PaadmInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(+Paadm)
    s PatInfo=##class(web.DHCWMRMedBaseCtl).GetPatInfo(+Papmi)
    s PatientId=+Papmi
    s PatNo=$p(PatInfo,$c(2),23)
    s PatName=$p(PatInfo,$c(2),1)
    s PaadmType=$p($g(^PAADM(+Paadm)),"^",2)
    s VisitStatus=$p($g(^PAADM(+Paadm)),"^",20)
    q:VisitStatus="C" -1
    s Paadm=+Paadm
    s AdmNo=$p($g(^PAADM(+Paadm)),"^",81)
    s EmergencyFlag=$s(PaadmType="E":"Y",1:"N")
    ;^DHCCARDi("CF",0,"PAPMIDR",{CF_PAPMI_DR},{CF_RowID})
    i $d(^DHCCARDi("CF",0,"PAPMIDR",PatientId)) d
    .s CardRefId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientId,0))
    .s tmp=$g(^DHCCARD("CF",CardRefId))
    .q:tmp=""
    .s CardNo=$p(tmp,"^",2)

    ;User.DHCRegisterationFee
    ;号别,挂号日期,挂号时间,时段
    s tmpPaadm=" "_Paadm
    i $d(^User.DHCRegistrationFeeI("ADM",tmpPaadm)) d
    .s RegRowid=$o(^User.DHCRegistrationFeeI("ADM",tmpPaadm,0))
    .q:RegRowid=""
    .s tmp=$g(^User.DHCRegistrationFeeD(RegRowid))
    .q:tmp=""
    .s RegfeeDocId=$list(tmp,14)
    .s:RegfeeDocId'="" RegfeeDoc=$p($g(^CTPCP(+RegfeeDocId,1)),"^",2)
    .s RegDate=$list(tmp,15)
    .s:RegDate'="" RegDate=$zd(+RegDate,3)
    .s RegTime=$list(tmp,16)
    .s:RegTime'="" RegTime=$zt(+RegTime,1)
    .s RegTimeRangeId=$list(tmp,21)
    .s:RegTimeRangeId'="" RegTimeRange=$p($g(^DHCTimeRange(+RegTimeRangeId)),"^",2)
    
    ;病案申请信息
    ;^DHCWMRReq(0,"Paadm",{Paadm_Dr},{RowId})
    i $d(^DHCWMRReq(0,"Paadm",Paadm)) d
    .s ReqRowid=0
    .f  s ReqRowid=$o(^DHCWMRReq(0,"Paadm",Paadm,ReqRowid)) q:ReqRowid=""  d
    ..q:'$d(^DHCWMRReq(ReqRowid))
    ..s sLongRequest=..GetLongRequest(+ReqRowid)
    ..s MrMainRowId=$p(sLongRequest,"^",3)
    ..s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(+MrMainRowId)
    ..s tmppapmi=$p(sMrMain,"^",4)
    ..s tmppaadm=$p(sLongRequest,"^",19)
    ..s sPatInfo=##class(web.DHCWMRMedBaseCtl).GetPatInfo(tmppapmi)
    ..s sPaadmInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(tmppaadm)
    ..s reqRowId=+ReqRowid
    ..s MrTypeDesc=$p($p(sLongRequest,"^",2),"/",4)
    ..s MrNo=$p(sMrMain,"^",3)
    ..s PatientId=+tmppapmi
    ..s PatNo=$p(sPatInfo,$c(2),23)
    ..s PatName=$p(sPatInfo,$c(2),1)
    ..s Paadm=tmppaadm
    ..;^DHCCARDi("CF",0,"PAPMIDR",{CF_PAPMI_DR},{CF_RowID})
    ..i $d(^DHCCARDi("CF",0,"PAPMIDR",PatientId)) d
    ...s CardRefId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientId,0))
    ...s tmp=$g(^DHCCARD("CF",CardRefId))
    ...q:tmp=""
    ...s CardNo=$p(tmp,"^",2)
    ..//s PaadmCtlocDesc=$p($p(sPaadmInfo,"^",7),"/",2)
    ..s AimCtlocDesc=$p($p(sLongRequest,"^",7),"/",2)
    ..s MrMain=+MrMainRowId
    ..s MrIsStayIn=$p(sMrMain,"^",8)
    ..s FirstFlag=$s($p(sLongRequest,"^",9)["Y":"Y",1:"N")
    ..s AimDate=$p(sLongRequest,"^",6)
    ..s AimUserName=$p($p(sLongRequest,"^",8),"/",3)
 	..s ReqTypeDesc=$p($p(sLongRequest,"^",4),"/",4)
 	..s WorkItemDesc=$p($p(sLongRequest,"^",5),"/",3)
 	..s IsActive=$s($p(sLongRequest,"^",13)["Y":"Y",1:"N")
 	..;添加申请日期,时间,申请人（转换成申请激活日期/时间，在激活时修改申请时间）
 	..s RequestDate=$p(sLongRequest,"^",10)
 	..s RequestTime=$p(sLongRequest,"^",11)
  	..s RequestUser=$p(sLongRequest,"^",12)
 	q:((FirstFlg'="")&&(FirstFlag'="")&&(FirstFlg'=FirstFlag)) -1
 	q:(IsActive="N") -1
 	
    set Data=$lb(reqRowId,MrTypeDesc,MrNo,PatientId,PatNo,PatName,Paadm,AdmNo,AimCtlocDesc,MrMain,MrIsStayIn,EmergencyFlag,FirstFlag,AimDate,AimUserName,ReqTypeDesc,WorkItemDesc,CardNo,RegfeeDocId,RegfeeDoc,RegDate,RegTime,RegTimeRange,PaadmType,VisitStatus,RequestDate,RequestTime,RequestUser)
 	Set ^CacheTemp(repid,ind)=Data
    q 0
}

ClassMethod qryAdmReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = qryAdmReqExecute ]
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

/// add by zf 2008-03-30
/// 查询病人就诊列表和申请信息
/// 参数：
/// AdmDate--就诊日期
/// Papmi--Pa_patmas.Rowid
/// AdmType--就诊类型字符窜,以|分割
/// FirstFlag--是否优先
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRRequest","qryAdmReq","2008-04-28","2","O","N")
Query qryAdmReq(AdmDate As %String, Papmi As %String, AdmType As %String, FirstFlg As %String) As %Query(ROWSPEC = "reqRowId:%String,MrTypeDesc:%String,MrNo:%String,PatientId:%String,PatNo:%String,PatName:%String,Paadm:%String,AdmNo:%String,AimCtlocDesc:%String,MrMain:%String,MrIsStayIn:%String,EmergencyFlag:%String,FirstFlag:%String,AimDate:%String,AimUserName:%String,ReqTypeDesc:%String,WorkItemDesc:%String,CardNo:%String,RegfeeDocId:%String,RegfeeDoc:%String,RegDate:%String,RegTime:%String,RegTimeRange:%String,PaadmType:%String,VisitStatus:%String,RequestDate:%String,RequestTime:%String,RequestUser:%String")
{
}

/// add by zf 20080-03-31
/// 激活申请
/// 修改申请操作日期的优先标记，此条记录的优先状态改为Yes，其他都为No
/// w ##class(web.DHCWMRRequest).SetFirstFlag(66)
ClassMethod SetFirstFlag(ReqRowid)
{
	n (ReqRowid)
	s ret=-1
	q:+ReqRowid=0 ret
	s tmpReq=$g(^DHCWMRReq(+ReqRowid))
	s AimDate=$p(tmpReq,"^",5)
	s MrMainId=$p(tmpReq,"^",2)
	q:AimDate="" ret
	;^DHCWMRReq(0,"MainAimDate",{MrMain_Dr},{AimDate},{FirstFlag},{RowId})
	q:'$d(^DHCWMRReq(0,"MainAimDate",MrMainId,AimDate)) ret
	s FirstFlag=""
	f  s FirstFlag=$o(^DHCWMRReq(0,"MainAimDate",MrMainId,AimDate,FirstFlag)) q:FirstFlag=""  d
	.s tmpRowid=0
	.f  s tmpRowid=$o(^DHCWMRReq(0,"MainAimDate",MrMainId,AimDate,FirstFlag,tmpRowid)) q:tmpRowid=""  d
	..s tmpReq=..GetRequest(tmpRowid)
	..s IsActive=$p(tmpReq,"^",13)
	..q:IsActive="No"
	..s $p(tmpReq,"^",9)="No"
	..s:tmpRowid=ReqRowid $p(tmpReq,"^",9)="Yes"
	..s:tmpRowid=ReqRowid $p(tmpReq,"^",10)=+$h
	..s:tmpRowid=ReqRowid $p(tmpReq,"^",11)=$p($h,",",2)
	..s ret=..UpdateRequest(tmpReq)
	q ret
}

/// add by zf 2008-04-15
/// 用于判断同一病案，同一次就诊当前只能有一条有效申请
/// w ##Class(web.DHCWMRRequest).GetReqByAdm(73139,87,28,324)
ClassMethod GetReqByAdm(MainId, ReqType, ItemId, Paadm)
{
	n (MainId,ReqType,ItemId,Paadm)
	s ret=""
	
	q:(Paadm="")||(MainId="")||(ReqType="")||(ItemId="") ret
	;^DHCWMRReq(0,"Paadm",{Paadm_Dr},{RowId})
	;^DHCWMRReq(0,"MainAimDate",{MrMain_Dr},{AimDate},{FirstFlag},{RowId})
	q:'$d(^DHCWMRReq(0,"Paadm",Paadm)) ret
	s Rowid=0,TMP=""
	f  s Rowid=$o(^DHCWMRReq(0,"Paadm",Paadm,Rowid)) q:Rowid=""  d
	.s tmp=..GetRequest(Rowid)
	.q:tmp=""
	.s tmpActive=$p(tmp,"^",13)
	.q:tmpActive'="Y"
	.s tmpMain=$p(tmp,"^",3)
	.s tmpReqType=$p(tmp,"^",4)
	.s tmpItem=$p(tmp,"^",5)
	.q:(MainId'=tmpMain)||(ReqType'=tmpReqType)||(ItemId'=tmpItem)
	.s TMP=TMP_$c(1)_tmp
	s ret=$e(TMP,2,$l(TMP))
	q ret
}

/// 如果取消了就诊,把此条申请作废。
/// w ##Class(web.DHCWMRRequest).InvalidRequest(97653,"","","Y")
ClassMethod InvalidRequest(MrMainRowId, AimDateFrom, AimDateTo, sIsActive)
{
	n (MrMainRowId,AimDateFrom,AimDateTo,sIsActive)
	s ret=1
	q:'$d(^DHCWMRReq(0,"MainAimDate",MrMainRowId)) ret
	s:AimDateFrom'="" AimDateFrom=$zd(AimDateFrom,3)
	s:AimDateFrom="" AimDateFrom=+$h
	s:AimDateTo'="" AimDateTo=$zd(AimDateTo,3)
	s:AimDateTo="" AimDateTo=+$h
	
	s tmpDate=AimDateFrom-1
	f  s tmpDate=$o(^DHCWMRReq(0,"MainAimDate",MrMainRowId,tmpDate)) q:(tmpDate="")!(tmpDate>AimDateTo)  d
	.s FirstFlag=""
	.f  s FirstFlag=$o(^DHCWMRReq(0,"MainAimDate",MrMainRowId,tmpDate,FirstFlag),-1) q:FirstFlag=""  d
	..s ReqRowId=""
	..f  s ReqRowId=$o(^DHCWMRReq(0,"MainAimDate",MrMainRowId,tmpDate,FirstFlag,ReqRowId)) q:ReqRowId=""  d
    ...s tmpReq=..GetRequest(ReqRowId)
    ...q:tmpReq=""
	...s IsActive=$p(tmpReq,"^",13)
	...q:(sIsActive'=IsActive)&(sIsActive'="")
    ...s tmpPaadm=$p(tmpReq,"^",19)
    ...q:tmpPaadm=""
    ...s tmpAdm=$g(^PAADM(+tmpPaadm))
    ...s VisitStatus=$p(tmpAdm,"^",20)
    ...i VisitStatus="C" d
    ....s $p(tmpReq,"^",9)="N"
    ....s $p(tmpReq,"^",13)="N"
    ....s flg=..UpdateRequest(tmpReq)
    ....s:flg'>0 ret=-1
    
    q ret
}

/// add by zf 2008-04-17
/// 取就诊申请信息
ClassMethod GetAdmReqInfo(ReqRowid)
{
	n (ReqRowid)
	s ret=""
	
	s (reqRowId,AdmNo,MrTypeDesc,MrNo,PatientId,PatNo,PatName,AimCtlocDesc,MrMain,MrIsStayIn,EmergencyFlag,FirstFlag,AimDate,AimUserName,ReqTypeDesc,WorkItemDesc,CardNo,RegfeeDoc,RegfeeDocId,RegDate,RegTime,RegTimeRange,PaadmNo,PaadmType,IsActive,VisitStatus,RequestDate,RequestTime,RequestUser)=""
	
    ;病案申请信息
    s sLongRequest=..GetLongRequest(+ReqRowid)
    s MrMainRowId=$p(sLongRequest,"^",3)
    s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(+MrMainRowId)
    s PatientId=$p(sMrMain,"^",4)
    s Paadm=$p(sLongRequest,"^",19)
    s sPatInfo=##class(web.DHCWMRMedBaseCtl).GetPatInfo(PatientId)
    //s sPaadmInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(Paadm)
    i Paadm'="" d
    .s PaadmType=$p($g(^PAADM(+Paadm)),"^",2)
    .s VisitStatus=$p($g(^PAADM(+Paadm)),"^",20)
    .s VisitStatus=$s(VisitStatus="C":"No",1:"Yes")
    .s EmergencyFlag=$s(PaadmType="E":"Yes",1:"No")
    s MrTypeDesc=$p($p(sLongRequest,"^",2),"/",4)
	s MrNo=$p(sMrMain,"^",3)
    ;^DHCCARDi("CF",0,"PAPMIDR",{CF_PAPMI_DR},{CF_RowID})
    i $d(^DHCCARDi("CF",0,"PAPMIDR",PatientId)) d
    .s CardRefId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientId,0))
    .s tmp=$g(^DHCCARD("CF",CardRefId))
    .q:tmp=""
    .s CardNo=$p(tmp,"^",2)
    s PatNo=$p(sPatInfo,$c(2),23)
    s PatName=$p(sPatInfo,$c(2),1)
    s FirstFlag=$s($p(sLongRequest,"^",9)["Y":"Yes",1:"No")
    s IsActive=$s($p(sLongRequest,"^",13)["Y":"Yes",1:"No")
    s AimCtlocDesc=$p($p(sLongRequest,"^",7),"/",2)
    s AimDate=$p(sLongRequest,"^",6)
    s AimUserName=$p($p(sLongRequest,"^",8),"/",3)
 	s ReqTypeDesc=$p($p(sLongRequest,"^",4),"/",4)
 	s WorkItemDesc=$p($p(sLongRequest,"^",5),"/",3)
 	s RequestDate=$p(sLongRequest,"^",10)
 	s RequestTime=$p(sLongRequest,"^",11)
  	s RequestUser=$p($p(sLongRequest,"^",12),"/",3)

    ;User.DHCRegisterationFee
    ;号别,挂号日期,挂号时间,时段
    s tmpPaadm=" "_Paadm
    i $d(^User.DHCRegistrationFeeI("ADM",tmpPaadm)) d
    .s RegRowid=$o(^User.DHCRegistrationFeeI("ADM",tmpPaadm,0))
    .q:RegRowid=""
    .s tmp=$g(^User.DHCRegistrationFeeD(RegRowid))
    .q:tmp=""
    .s RegfeeDocId=$list(tmp,14)
    .s:RegfeeDocId'="" RegfeeDoc=$p($g(^CTPCP(+RegfeeDocId,1)),"^",2)
    .s RegDate=$list(tmp,15)
    .s:RegDate'="" RegDate=$zd(+RegDate,3)
    .s RegTime=$list(tmp,16)
    .s:RegTime'="" RegTime=$zt(+RegTime,1)
    .s RegTimeRangeId=$list(tmp,21)
    .s:RegTimeRangeId'="" RegTimeRange=$p($g(^DHCTimeRange(+RegTimeRangeId)),"^",2)
    
    s ret=ReqRowid_"^"_Paadm_"^"_PatientId_"^"_MrTypeDesc_"^"_MrNo
    s ret=ret_"^"_CardNo_"^"_PatNo_"^"_PatName_"^"_PaadmType_"^"_VisitStatus
    s ret=ret_"^"_EmergencyFlag_"^"_FirstFlag_"^"_IsActive_"^"_AimCtlocDesc_"^"_AimDate
    s ret=ret_"^"_AimUserName_"^"_ReqTypeDesc_"^"_WorkItemDesc_"^"_RequestDate_"^"_RequestTime
    s ret=ret_"^"_RequestUser_"^"_RegfeeDoc_"^"_RegDate_"^"_RegTime_"^"_RegTimeRange
	q ret
}

/// 退号时取消病案申请
/// w ##Class(web.DHCWMRRequest).InvalidReqByADM(6)
ClassMethod InvalidReqByADM(Paadm)
{
	n (Paadm)
	s ret=0
	
	q:Paadm="" ret
	s tmpAdm=$g(^PAADM(+Paadm))
	s VisitStatus=$p(tmpAdm,"^",20)
    ;q:VisitStatus="C" ret   //update by zf 2008-05-23
	;^DHCWMRReq(0,"Paadm",{Paadm_Dr},{RowId})
	q:'$d(^DHCWMRReq(0,"Paadm",Paadm)) ret
	
	TStart
	
	s ReqRowId="",ret=-1,flg=0
	f  s ReqRowId=$o(^DHCWMRReq(0,"Paadm",Paadm,ReqRowId)) q:(ReqRowId="")||(flg<0)  d
    .s tmpReq=..GetRequest(ReqRowId)
    .q:tmpReq=""
	.s IsActive=$p(tmpReq,"^",13)
	.q:IsActive="N"
    .s $p(tmpReq,"^",9)="N"
    .s $p(tmpReq,"^",13)="N"
    .s flg=..UpdateRequest(tmpReq)
    .i +flg<0 TRollBack
    q:flg<0 ret
    
    TCommit
    
    s ret=1
    q ret
}

}
