/// 名称:     web.DHCLabPanicReportTrans
/// 描述:     危急报告处理查询
/// 编写者：  huhm
/// 编写日期: 20120710
Class web.DHCLabPanicReportTrans Extends %RegisteredObject
{

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 保存危急报告处理记录
/// Table：        DHC_PanicReport,DHC_PanicReportTrans
/// Input：        危急报告ID,用户,处理,说明,状态
/// Output：       
/// Return：        
/// Others：        其它说明
ClassMethod SaveTransBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RepIdStr As %Library.String = "", User As %Library.String = "", TransStr As %Library.String = "", Status As %Library.String = "")
{
 
  s ^TMPTrans(1)=RepIdStr
  s ^TMPTrans(2)=User
  s ^TMPTrans(3)=TransStr
  s ^TMPTrans(4)=Status
  s ReportType="1"
 s Ret=..SaveTrans(RepIdStr,User,TransStr,Status,ReportType)
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

//增加处理报告类型 20131009 huhm

ClassMethod SaveTrans(RepIdStr As %String, User As %String, TransStr As %String, Status As %String, ReportType As %String) As %String
{
	//New (RepIdStr,User,TransStr,Status)
	s ^TMPSATRAN=RepIdStr_","_User_","_TransStr_","_Status_","_ReportType
	//Set Config=##Class(websys.Configuration).%OpenId(1)
 	Set MEDDATA="DHC-DATA" //Config.DataNamespace
 	Set LABDATA="LABDATA" //Config.LabDataNamespace
 	Set CurrentNS=$ZNSPACE
 	Set Ret="",retStr=""
 	ZN LABDATA
 	Set Ret=$$save^DHCLABPanicReportTrans(RepIdStr,User,TransStr,Status,ReportType)
 	ZN CurrentNS
 	Quit Ret
}

ClassMethod SaveIPTransBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RepIdStr As %Library.String = "", User As %Library.String = "", DocStr As %Library.String = "", TransMemo As %Library.String = "")
{
 
  s ^TMPIPTrans(1)=RepIdStr
  s ^TMPIPTrans(2)=User
  s ^TMPIPTrans(3)=DocStr
  s ^TMPIPTrans(4)=TransMemo
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 Set Ret="",retStr=""
 ZN LABDATA
 Set Ret=$$save^DHCLABPanicReportTrans(RepIdStr,User,DocStr,TransMemo)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

ClassMethod SaveOPTransBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RepIdStr As %Library.String = "", User As %Library.String = "", MobPhone As %Library.String = "", TransMemo As %Library.String = "")
{
 
  s ^TMPOPTrans(1)=RepIdStr
  s ^TMPOPTrans(2)=User
  s ^TMPOPTrans(3)=MobPhone
  s ^TMPOPTrans(4)=TransMemo
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 Set Ret="",retStr=""
 ZN LABDATA
 Set Ret=$$save^DHCLABPanicReportTrans(RepIdStr,User,"",TransMemo,MobPhone)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 核对用户名密码
/// Table：        SS_User
/// Input：        用户名,密码
/// Output：       
/// Return：        
/// Others：        其它说明
ClassMethod CheckPwdBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserCode As %Library.String = "", Pwd As %Library.String = "")
{
  	S Ret=..CheckPwd(UserCode,Pwd)
 	s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 	i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 	&javascript<#(retval)#>
  	q Ret
}

ClassMethod CheckPwd(UserCode As %String, Pwd As %String) As %String
{
	//New (UserCode,Pwd)
 	Set Config=##Class(websys.Configuration).%OpenId(1)
 	Set MEDDATA=Config.DataNamespace
 	Set LABDATA=Config.LabDataNamespace
 	Set CurrentNS=$ZNSPACE
 	Set Ret="",retStr=""
 	Set UserCode=$zcvt(UserCode,"U")
 	Set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
 	ZN MEDDATA
 	Set Ret=$$pin^MVBSSUSR(UserId,Pwd)
 	ZN CurrentNS
 	Quit Ret
}

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 查询危急报告处理记录
/// Table：        DHC_PanicReport,DHC_PanicReportTrans
/// Input：        检验号
/// Output：       处理                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             时间,处理用户,通知人,联系电话,联系结果
/// Return：         
/// Others：        其它说明
/// 增加报告类型ReportType 20131007 huhm
Query GetTransItem(LabEpis As %String, ReportType As %String) As %Query(ROWSPEC = "TransDT:%String,TransUser:%String,NoticePerson:%String,PhoneNo:%String,Comment:%String")
{
}

ClassMethod GetTransItemExecute(ByRef qHandle As %Binary, LabEpis As %String, ReportType As %String) As %Status
{
 	Set LabEpis=$Get(LabEpis),ReportType=$g(ReportType)
 	i '$l(ReportType) s ReportType=1
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	If '$Length(LabEpis) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	B
	//
	s ord="" f  s ord=$o(^[LabData]DHCPanicReport(ReportType,LabEpis,ord)) q:ord=""  d
	.s TranOrd="" f  s TranOrd=$o(^[LabData]DHCPanicReport(ReportType,LabEpis,ord,"TR",TranOrd)) q:TranOrd=""  d
	..s str=^[LabData]DHCPanicReport(ReportType,LabEpis,ord,"TR",TranOrd)
	..i '$l(str) q
	..s TDate=$p(str,"\",1)
	..s TTime=$p(str,"\",2)
	..s TUser=$p(str,"\",3)
	..s TransDT=""
	..s TransUser=""
	..i $l(TDate),$l(TTime) s TransDT=$zd(TDate,3)_" "_$zt(TTime)
	..i $l(TUser) d
	...s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(TUser,"U"),""))
	...i '$l(UserId) q
	...s TransUser=$p(^SSU("SSUSR",UserId),"^",2)
	..s NoticePerson=$p(str,"\",5)
	..s PhoneNo=$p(str,"\",6)
	..s Comment=$p(str,"\",7)
	..d OutputRow
	//
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow
	set Data=$lb(TransDT,TransUser,NoticePerson,PhoneNo,Comment)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTransItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTransItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTransItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTransItemExecute ]
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

/// CREATOR：  SHP
/// DATE   :   20131215
/// DESCRIPITON: 保存处理结果。
/// DEBUGGER  :W ##CLASS(web.DHCLabPanicReportTrans).SaveTransNew("234||1","059","^123^123^已通知","F",1)
ClassMethod SaveTransNew(RepId As %String, User As %String, TransStr As %String = "", Status As %String = "", ReportType As %String = "") As %String
{
	S ^TEMPTRANSREPORTS(1)=RepId
	S ^TEMPTRANSREPORTS(2)=User
	S ^TEMPTRANSREPORTS(3)=TransStr
	S ^TEMPTRANSREPORTS(4)=Status
	S ^TEMPTRANSREPORTS(5)=ReportType
	S ret=""
	s reportID=ReportType_"||"_RepId
  	s ret=$$updateTrans(reportID,User,TransStr,Status)
  	q ret
insertTrans(reportID,User,TransStr,Status)
	I Status=""  S Status="C"
	s NoticeTime=$p(TransStr,"^",1)
  	s NoticeName=$p(TransStr,"^",2)
  	s PhoneNo=$p(TransStr,"^",3)
  	s TransMemo=$p(TransStr,"^",4)
  	k PLIST
  	S PLIST(0)=reportID
  	s PLIST(3)=+$h
  	s PLIST(4)=$p($h,",",2)
  	s PLIST(5)=User
  	s PLIST(6)=NoticeTime
  	s PLIST(7)=NoticeName
  	s PLIST(8)=PhoneNo
  	s PLIST(9)=TransMemo
  	s PLIST(10)=Status
	i '$l($g(PLIST(2))) s PLIST(2)=$o(^DHCPanicReport($p(PLIST(0),"||",1),$p(PLIST(0),"||",2),$p(PLIST(0),"||",3),"TR",""),-1)+1
	&SQL(insert into lab.DHC_PanicReportTrans values :PLIST())
	q SQLCODE
updateTrans(reportID,User,TransStr,Status)
	;s TransID=$o(^DHCPanicReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3),"TR",""),-1)
	;s TransID=reportID_"||"_TransID
	s NoticeTime=$p(TransStr,"^",1)
  	s NoticeName=$p(TransStr,"^",2)
  	s PhoneNo=$p(TransStr,"^",3)
  	s TransMemo=$p(TransStr,"^",4)
	k PLIST
  	S PLIST(0)=reportID
  	s PLIST(3)=+$h
  	s PLIST(4)=$p($h,",",2)
  	s PLIST(5)=User
  	s PLIST(6)=NoticeTime
  	s PLIST(7)=NoticeName
  	s PLIST(8)=PhoneNo
  	s PLIST(9)=TransMemo
  	s PLIST(10)=Status
  	s PLIST(2)=$o(^DHCPanicReport($p(PLIST(0),"||",1),$p(PLIST(0),"||",2),$p(PLIST(0),"||",3),"TR",""),-1)+1
  	TS
  	&SQL(insert into lab.DHC_PanicReportTrans values :PLIST())
 	I SQLCODE TRO
 	&sql(update lab.DHC_PanicReport set DPRP_Status=:Status where DPRP_RowID=:reportID)
 	I SQLCODE TRO
 	TC
  	q SQLCODE
}

}
