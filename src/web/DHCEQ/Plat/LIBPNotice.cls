Class web.DHCEQ.Plat.LIBPNotice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:新增、更新数据
/// ----------------------------------
/// w ##Class(web.DHCEQ.Plat.LIBPNotice).SaveData("^HospitalDR^NoticeCat^Title^SubTitle^PublishDept^2^2019-01-01^21:00^2019-01-01^11^1^iiii^dtat^11^1^remark^^^^^")
ClassMethod SaveData(val)
{
	new (val,%session)
	Set $ZT="ERRORSave"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$Piece($H,",",2)
	s RowID=$P(val,"^",1)
	s PLIST(2) = $p(val,"^",2)	;HospitalDR
 	s PLIST(3) = $p(val,"^",3)	;NoticeCat
 	
 	s PLIST(4) = $p(val,"^",4)	;Title
 	s PLIST(5) = $p(val,"^",5)	;SubTitle
 	s PLIST(6) = $p(val,"^",6)	;PublishDept
 	s PLIST(7) = $p(val,"^",7)	;PublishUser
 	s PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;PublishDate
 	
 	s PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"time")	;PublishTime
 	s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;EffectiveDate
 	
 	s PLIST(11) = $p(val,"^",11)	;Abstract
 	s PLIST(12) = $p(val,"^",12)	;ContentType
 	s PLIST(13) = $p(val,"^",13)	;Content
 	s PLIST(14) = $p(val,"^",14)	;Standard
 	s PLIST(15) = $p(val,"^",15)	;Source
 	s PLIST(16) = $p(val,"^",16)	;ManageLocDR
 	s PLIST(17) = "0"	;Status
 	s PLIST(18) = $p(val,"^",17)	;Remark
 	s PLIST(19) = "N"	;InvalidFlag
 	s PLIST(20) = $p(val,"^",18)	;Hold1
 	s PLIST(21) = $p(val,"^",19)	;Hold2
 	s PLIST(22) = $p(val,"^",20)	;Hold3
 	s PLIST(23) = $p(val,"^",21)	;Hold4
 	s PLIST(24) = $p(val,"^",22)	;Hold5
 	//add by lmm 2020-04-20 增加查阅范围
 	s PLIST(25) = $p(val,"^",23)	;SourceType
 	s PLIST(26) = $p(val,"^",24)	;SourceID
 	
	TSTART	
 	if RowID=""
 	{
		&SQL(insert into sqluser.DHC_EQPNotice values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQPNotice values :PLIST() where N_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
	
	s OperateInfo="^67^"_RowID_"^"_User_"^^0"

 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
 	
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// 描述:提交
/// w ##Class(web.DHCEQ.Plat.LIBPNotice).SubmitData("8")
ClassMethod SubmitData(RowID)
{
	new (RowID,%session) 
	i RowID="" q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set $ZT="ERRORSubmit"
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPNotice Set N_Status='1' where N_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}

	s OperateInfo="^67^"_RowID_"^"_User_"^^1"

 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 描述:审核
/// w ##Class(web.DHCEQ.Plat.LIBPNotice).AuditData("8")
ClassMethod AuditData(RowID)
{
	new (RowID,%session) 
	i RowID="" q ""
	Set $ZT="ERRORAudit"
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPNotice Set N_Status='2' where N_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}

	s OperateInfo="^67^"_RowID_"^1^^2"

 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// 描述:删除
/// w ##Class(web.DHCEQ.Plat.LIBPNotice).DeleteData("8")
ClassMethod DeleteData(RowID)
{
	new (RowID,%session) 
	i RowID="" q ""
	Set $ZT="ERRORDelete"
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPNotice Set N_InvalidFlag='Y',N_Status='3' where N_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}

	s OperateInfo="^67^"_RowID_"^1^^3"

 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.Plat.LIBPNotice).GetOnePNotice("7")
ClassMethod GetOnePNotice(rowid)
{
	new result,resultex,LocCode,AppInfo,Total
	s (result,resultex,LocCode,AppInfo,Total)=""
	s result= ^DHCEQPNotice(rowid)
	s resultex=resultex_"^"	;Hospital
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$Piece($Get(^CT("HOSP",$p(result,"^",1))),"^",2)
	s resultex=resultex_"^"	;NoticeCatDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQPCNoticeCat",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",15))
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"time")	
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")
	//add by lmm 2020-04-20 增加查阅范围
	s SourceDesc=0
	s Desc= $case($p(result,"^",24),"2":"grp","3":"dept","4":"role","5":"user",:"")
	i Desc'=""  s SourceDesc=##class(web.DHCEQCommon).GetTrakNameByID(Desc,$p(result,"^",25))
	s resultex=resultex_"^"_SourceDesc	;SourceDesc
		
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod GetOnePNoticeNew(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOnePNoticeNew"
	s ObjNotice=##Class(User.DHCEQPNotice).%OpenId(RowID)
	s NoticeInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjNotice)
	;modify by lmm 2020-03-17 1224449
	i ObjNotice.NHospitalDR'=""  d
	.d NoticeInfo.%Set("NHospitalDR_CTHOSPDesc",$Piece($Get(^CT("HOSP",ObjNotice.NHospitalDR)),"^",2))
	d NoticeInfo.%Set("NNoticeCat_CNDesc",$Piece($Get(^DHCEQPNotice(ObjNotice.NNoticeCat)),"^",2))
	d NoticeInfo.%Set("NManageLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjNotice.NManageLocDR))
	d NoticeInfo.%Set("NPublishDate",##class(web.DHCEQCommon).TransValueToPage(ObjNotice.NPublishDate,"date"))
	d NoticeInfo.%Set("NPublishTime",##class(web.DHCEQCommon).TransValueToPage(ObjNotice.NPublishTime,"time"))
	d NoticeInfo.%Set("NEffectiveDate",##class(web.DHCEQCommon).TransValueToPage(ObjNotice.NEffectiveDate,"date"))
	s OperateLogID=$o(^DHCEQOperateLog(0,"Source","3","67",RowID,0))
	i OperateLogID'=""  d
	.s OperateLogDate=$Piece($Get(^DHCEQOperateLog(OperateLogID)),"^",5) 
	.s OperateLogDate=##class(web.DHCEQCommon).TransValueToPage(OperateLogDate,"date")
	.s OperateLogTime=$Piece($Get(^DHCEQOperateLog(OperateLogID)),"^",6) 
	.s OperateLogTime=##class(web.DHCEQCommon).TransValueToPage(OperateLogTime,"time")
	.s OperateLogUserDR=$Piece($Get(^DHCEQOperateLog(OperateLogID)),"^",7) 
	.s OperateLogUser=##class(web.DHCEQCommon).GetTrakNameByID("user",OperateLogUserDR)
	d NoticeInfo.%Set("OperateLogDate",OperateLogDate)
	d NoticeInfo.%Set("OperateLogTime",OperateLogTime)
	d NoticeInfo.%Set("OperateLogUser",OperateLogUser)
	// MZY0121	2586856		2022-04-15		替换换行及增加空格
	s tmpNContent=##class(web.DHCEQCommon).Replace(ObjNotice.NContent,$C(10),"<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
	d NoticeInfo.%Set("NContent",tmpNContent)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,NoticeInfo)
ERRORGetOnePNoticeNew
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by lmm 2020-09-07 1481391 增加入参：GroupLimitFlag
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBPNotice","GetNotice","","","","","2","","","Month","","Y")
Query GetNotice(NoticeCatDR As %String = "", Title As %String = "", Content As %String = "", ManageLocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", DateRange As %String = "", SearchAll As %String = "", EffectiveFlag As %String = "", GroupLimitFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,THospitalDR:%String,THospital:%String,TNoticeCatDR:%String,TNoticeCat:%String,TTitle:%String,TSubTitle:%String,TPublishDept:%String,TPublishUser:%String,TPublishDate:%String,TEffectiveDate:%String,TAbstract:%String,TContentType:%String,TContent:%String,TStandard:%String,TSource:%String,TManageLoc:%String,TStatus:%String,TRemark:%String,TOperateLogDate:%String,TOperateLogTime:%String,TOperateLogUser:%String")
{
}

ClassMethod GetNoticeExecute(ByRef qHandle As %Binary, NoticeCatDR As %String = "", Title As %String = "", Content As %String = "", ManageLocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", DateRange As %String = "", SearchAll As %String = "", EffectiveFlag As %String = "", GroupLimitFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	i StartDate'="" Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")   
	i EndDate'="" Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")   
 	
 	s CurDate=+$h
 	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPNotice(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetNotice
	.Set TRowID = rowid	
	.;modify by lmm 2020-04-20 begin
	.Set TSourceType=$Piece($Get(^DHCEQPNotice(TRowID)),"^",24) 
	.Set TSourceIDDR=$Piece($Get(^DHCEQPNotice(TRowID)),"^",25) 
	.q:(GroupLimitFlag="Y")&&(TSourceType="2")&&(TSourceIDDR'=%session.Get("LOGON.GROUPID"))
	.q:(TSourceType="4")&&('$D(^DHCEQCCode(0,"DHCEQCGroupRole",0,"GroupRole",%session.Get("LOGON.GROUPID"),TSourceIDDR)))
	.q:(TSourceType="3")&&(TSourceIDDR'=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID")))
	.;modify by lmm 2020-04-23 1286271
	.q:(TSourceType="5")&&(TSourceIDDR'=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")))
	.s TSourceID=0
	.s Desc= $case(TSourceType,"2":"grp","3":"dept","4":"role","5":"user",:"")
	.i Desc'=""  s TSourceID=##class(web.DHCEQCommon).GetTrakNameByID(Desc,TSourceIDDR)
	.Set TInvalidFlag=$Piece($Get(^DHCEQPNotice(TRowID)),"^",18) 
	.Quit:TInvalidFlag'="N"
	.Set TStatus=$Piece($Get(^DHCEQPNotice(TRowID)),"^",16) 
	.Quit:(Status'="")&&(TStatus'=Status)
	.Set TStatus=$case(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废",:"")
	.Set TNoticeCatDR=$Piece($Get(^DHCEQPNotice(TRowID)),"^",2) 
	.Quit:(NoticeCatDR'="")&&(TNoticeCatDR'[NoticeCatDR)
	.Set TTitle=$Piece($Get(^DHCEQPNotice(TRowID)),"^",3) 
	.Quit:(Title'="")&&(TTitle'[Title)
	.Set TEffectiveDate=$Piece($Get(^DHCEQPNotice(TRowID)),"^",9) 
	.q:(EffectiveFlag="Y")&&(CurDate<TEffectiveDate)
	.q:(StartDate'="")&&(StartDate>TEffectiveDate)
	.q:(EndDate'="")&&(EndDate<TEffectiveDate)
	.q:(DateRange="Month")&&((CurDate-30)>TEffectiveDate)
	.q:(DateRange="Month")&&(CurDate<TEffectiveDate)
	.Set TContent=$Piece($Get(^DHCEQPNotice(TRowID)),"^",12) 
	.Quit:(Content'="")&&(TContent'[Content)
	.Set TManageLocDR=$Piece($Get(^DHCEQPNotice(TRowID)),"^",15) 
	.Quit:(ManageLocDR'="")&&(TManageLocDR'=ManageLocDR)
	.Set THospitalDR=$Piece($Get(^DHCEQPNotice(TRowID)),"^",1) 
	.i THospitalDR'="" Set THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2)
	.i TNoticeCatDR'="" Set TNoticeCat=$Piece($Get(^DHCEQCCode("DHCEQPCNoticeCat",TNoticeCatDR)),"^",2) 
	.Set TSubTitle=$Piece($Get(^DHCEQPNotice(TRowID)),"^",4) 
	.Set TPublishDept=$Piece($Get(^DHCEQPNotice(TRowID)),"^",5) 
	.Set TPublishUser=$Piece($Get(^DHCEQPNotice(TRowID)),"^",6) 
	.Set TPublishDate=$Piece($Get(^DHCEQPNotice(TRowID)),"^",7) 
	.Set TPublishTime=$Piece($Get(^DHCEQPNotice(TRowID)),"^",8) 
	.Set TEffectiveDate=##class(web.DHCEQCommon).TransValueToPage(TEffectiveDate,"date")
	.Set TAbstract=$Piece($Get(^DHCEQPNotice(TRowID)),"^",10) 
	.Set TContentType=$Piece($Get(^DHCEQPNotice(TRowID)),"^",11) 
	.Set TStandard=$Piece($Get(^DHCEQPNotice(TRowID)),"^",13) 
	.Set TSource=$Piece($Get(^DHCEQPNotice(TRowID)),"^",14) 
	.Set TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.Set TRemark=$Piece($Get(^DHCEQPNotice(TRowID)),"^",17) 
	.q:(SearchAll'="")&&((TTitle'[SearchAll)&&(TSubTitle'[SearchAll)&&(TAbstract'[SearchAll)&&(TContent'[SearchAll)&&(TRemark'[SearchAll))
	.Set TOperateLogID=$o(^DHCEQOperateLog(0,"Source","3","67",TRowID,0))
	.i TOperateLogID'=""  d
	..Set TOperateLogDate=$Piece($Get(^DHCEQOperateLog(TOperateLogID)),"^",5) 
	..;q:(DateRange="Month")&&(CurDate>TOperateLogDate)&&((CurDate-2)<TOperateLogDate)
	..Set TOperateLogDate=##class(web.DHCEQCommon).TransValueToPage(TOperateLogDate,"date")
	..Set TOperateLogTime=$Piece($Get(^DHCEQOperateLog(TOperateLogID)),"^",6) 
	..Set TOperateLogTime=##class(web.DHCEQCommon).TransValueToPage(TOperateLogTime,"time")
	..Set TOperateLogUserDR=$Piece($Get(^DHCEQOperateLog(TOperateLogID)),"^",7) 
	..Set TOperateLogUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TOperateLogUserDR)
	.Do OutputRowGetNotice
	Quit $$$OK
OutputRowGetNotice
   	Set Data=$lb(TRowID,THospitalDR,THospital,TNoticeCatDR,TNoticeCat,TTitle,TSubTitle,TPublishDept,TPublishUser,TPublishDate,TEffectiveDate,TAbstract,TContentType,TContent,TStandard,TSource,TManageLoc,TStatus,TRemark,TOperateLogDate,TOperateLogTime,TOperateLogUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetNotice
	Set (TDesc,TRowID,TOperateLogID,TOperateLogDate,TOperateLogTime,TOperateLogUserDR,TOperateLogUser,THospitalDR,THospital,TNoticeCatDR,TNoticeCat,TTitle,TSubTitle,TPublishDept,TPublishUser,TPublishDate,TEffectiveDate,TAbstract,TContentType,TContent,TStandard,TSource,TManageLoc,TStatus,TRemark)=""
	Quit
}

ClassMethod GetNoticeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNoticeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNoticeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNoticeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
