Import SQLUser

Class web.DHCICUCVitalSignWarn Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 20160902+dyl跟前台统计区分开

/// d ##class(%ResultSet).RunQuery("web.DHCICUCVitalSignWarn","FindICUCInquiry","","")
Query FindICUCInquiry(desc, CtlocDr, HospId As %String = "") As %Query(ROWSPEC = "TRowid:%String,TICUCICode:%String,TICUCIDesc:%String,TICUCICtlocDr:%String,TICUCICtloc:%String,TICUCIStatusCode:%String,TICUCIStatus:%String,TICUCISearchLevel:%String,TICUCIIcuaCount:%String,TICUCIResultCount:%String,TICUCIDataType:%String,TICUCIType:%String,ICUCIIsByDate:%String,TICUCIUpdateDate:%String,TICUCIUpdateTime:%String,TICUCIUpdateUserDr:%String") [ SqlProc ]
{
}

ClassMethod FindICUCInquiryExecute(ByRef qHandle As %Binary, desc, CtlocDr, HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s dateformatnum=##class(websys.Conversions).DateFormat()	//20170302+dyl
	if CtlocDr=""  d ;配置界面使用
		.
		.s TRowid=0
		.f  s TRowid=$o(^DHCICUCInquiry(TRowid))  q:TRowid=""  d
			..d OutputRow1(TRowid)
	e  d ;前台程序调用
		.
		.;添加本科室的配置
		.//d Find(CtlocDr)
		.s rowid=""
		.f  s rowid=$o(^DHCICUCInquiry(0,"Ctloc",CtlocDr,rowid))  q:rowid=""  d	
		..d OutputRow1(rowid)
		.
		.;添加本科室关联病区的配置
		.s locStr=##class(web.DHCClinicCom).GetLinkLocId(CtlocDr)
		.s num=$l(locStr,"^")
		.f i=1:1:num  d
			..s wardId=$p(locStr,"^",i)
			..q:wardId=""
			..//q:'$d(^DHCICUPara(0,"Ctloc",wardId))
			..//d Find(wardId)
			..s rowid=""
			..f  s rowid=$o(^DHCICUCInquiry(0,"Ctloc",wardId,rowid))  q:rowid=""  d	
				...d OutputRow1(rowid)

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1(TRowid)
	q:'##class(User.DHCICUCInquiry).%ExistsId(TRowid)
	s obj=##class(User.DHCICUCInquiry).%OpenId(TRowid)
	s hospitalId="",DataAttributionDr=""
	i $d(^DHCICUCInquiry(TRowid,1)) s DataAttributionDr=$lg(^DHCICUCInquiry(TRowid,1),1)
	i DataAttributionDr'="" s hospitalId=$li(^DHCICUC("DataAttribution",DataAttributionDr),1)
	q:((hospitalId'="")&(HospId'="")&(HospId'=hospitalId))
	s TICUCICode=obj.ICUCICode
	q:TICUCICode'["Vital"
	q:obj.ICUCIDesc'[desc
	s TICUCIDesc=obj.ICUCIDesc
	s TICUCICtlocDr=obj.ICUCICtlocDr
	s TICUCICtloc=""
	i TICUCICtlocDr'="" s TICUCICtloc=$p($g(^CTLOC(+TICUCICtlocDr)),"^",2)
	s TICUCIStatusCode=obj.ICUCIStatus
	s TICUCIStatus=""
	s:TICUCIStatusCode="I" TICUCIStatus="Initial"
	s:TICUCIStatusCode="S" TICUCIStatus="Search"
	s:TICUCIStatusCode="F" TICUCIStatus="Finish"
	s TICUCISearchLevel=obj.ICUCISearchLevel
	s TICUCIIcuaCount=obj.ICUCIIcuaCount
	s TICUCIResultCount=obj.ICUCIResultCount
	s TICUCIDataType=obj.ICUCIDataType
	s TICUCIType=obj.ICUCIType
	s ICUCIIsByDate=obj.ICUCIIsByDate
	i TICUCIType="" s TICUCIType="All"
	e  i TICUCIType="A" s TICUCIType="All"
	e  i TICUCIType="L" s TICUCIType="Location"
	e  i TICUCIType="U" s TICUCIType="User"
	e  i TICUCIType="S" s TICUCIType ="SelfDefine"
	e  s TICUCIType=""
	s ICUCIUpdateDate=obj.ICUCIUpdateDate
	i ICUCIUpdateDate'="" s ICUCIUpdateDate=$zd(ICUCIUpdateDate,dateformatnum)
	s ICUCIUpdateTime=obj.ICUCIUpdateTime
	i ICUCIUpdateTime'="" s ICUCIUpdateTime=$zt(ICUCIUpdateTime,2)
	s ICUCIUpdateUserDr=obj.ICUCIUpdateUserDr
	d obj.%Close()
	if ICUCIUpdateUserDr'="" s ICUCIUpdateUserDr=$p($g(^SSU("SSUSR",ICUCIUpdateUserDr)),"^",2)
	set Data=$lb(TRowid,TICUCICode,TICUCIDesc,TICUCICtlocDr,TICUCICtloc,TICUCIStatusCode,TICUCIStatus,TICUCISearchLevel,TICUCIIcuaCount,TICUCIResultCount,TICUCIDataType,TICUCIType,ICUCIIsByDate,ICUCIUpdateDate,ICUCIUpdateTime,ICUCIUpdateUserDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCInquiryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCInquiryExecute ]
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

ClassMethod FindICUCInquiryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCInquiryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCICUCVitalSignWarn).InsertICUCInquiry("VitalSignWarn","危急值预警",104,"","","","")
ClassMethod InsertICUCInquiry(ICUCICode As %String, ICUCIDesc As %String, ICUCICtlocDr As %String, ICUCIStatus As %String, ICUCISearchLevel As %String, ICUCIIcuaCount As %Float = "", ICUCIResultCount As %Float, ICUCIIsByDate As %String = "", ICUCIType As %String = "", ICUCIUpdateUserDr As %String = "", ICUCIUpdateDate As %String = "", ICUCIUpdateTime As %String = "", ICUCIDataType As %String = "") As %String
{
	k ^DylTEMP
	s ^DylTEMP(1)=ICUCICode_"/"_ICUCIDesc_"/"_ICUCICtlocDr_"/"_ICUCIStatus
	_"/"_ICUCISearchLevel_"/"_ICUCIIcuaCount_"/"_ICUCIResultCount_"/"_ICUCIIsByDate
	_"/"_ICUCIType_"/"_ICUCIUpdateUserDr_"/"_ICUCIUpdateDate_"/"_ICUCIUpdateTime_"/"_ICUCIDataType
	q:ICUCICode="" "代码不能为空"
	q:ICUCIDesc="" "描述不能为空"
	q:ICUCICtlocDr="" "科室不能为空"	
	s ICUCIUpdateDate=##Class(web.DHCClinicCom).ConvertToDateH(ICUCIUpdateDate)
	s ICUCIUpdateTime=##Class(web.DHCClinicCom).ConvertToTimeH(ICUCIUpdateTime)
	i ICUCIType="All" s ICUCIType="A"
	e  i ICUCIType="Location" s ICUCIType="L"
	e  s ICUCIType="U"
	i ICUCIUpdateUserDr="" s ICUCIUpdateUserDr=%session.Data("LOGON.USERID")
	k PLIST
	TSTART
    s PLIST(2)=ICUCICode	;代码
	s PLIST(3)=ICUCIDesc	;描述
    s PLIST(4)=ICUCICtlocDr	;科室
	s PLIST(5)=ICUCIStatus	;状态
	s PLIST(6)=ICUCIType	;类型
	s PLIST(7)=ICUCISearchLevel	;搜索级别
	s PLIST(8)=ICUCIIcuaCount	;统计
	s PLIST(9)=ICUCIResultCount	;结果统计
	s PLIST(10)=ICUCIIsByDate	;为空
	s PLIST(11)=ICUCIDataType	;统计类型
	//s PLIST(12)=ICUCIType	;木有用的
	s PLIST(13)=ICUCIUpdateUserDr	;用户
	s PLIST(14)=ICUCIUpdateDate	;日期
	s PLIST(15)=ICUCIUpdateTime	;时间
	//s PLIST(16)=ICUCIType	;类型
	
	&SQL(insert into DHC_ICUC_Inquiry values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

ClassMethod UpdateICUCInquiry(RowID As %String, ICUCICode As %String, ICUCIDesc As %String, ICUCICtlocDr As %String, ICUCIStatus As %String, ICUCISearchLevel As %String, ICUCIIcuaCount As %Float, ICUCIResultCount As %Float, ICUCIType As %String = "", ICUCIUpdateUserDr As %String = "", ICUCIUpdateDate As %String = "", ICUCIUpdateTime As %String = "", ICUCIDataType As %String = "") As %String
{
	q:RowID="" "ID不能为空"
	q:ICUCICode="" "代码不能为空"
	q:ICUCIDesc="" "描述不能为空"
	q:ICUCICtlocDr="" "科室不能为空"
	s ICUCIUpdateDate=##Class(web.DHCClinicCom).ConvertToDateH(ICUCIUpdateDate)
	s ICUCIUpdateTime=##Class(web.DHCClinicCom).ConvertToTimeH(ICUCIUpdateTime)
	i ICUCIType="All" s ICUCIType="A"
	e  i ICUCIType="Location" s ICUCIType="L"
	e  s ICUCIType="U"
	i ICUCIUpdateUserDr="" s ICUCIUpdateUserDr=%session.Data("LOGON.USERID")
	k PLIST
	TSTART
    s PLIST(2)=ICUCICode	;代码
	s PLIST(3)=ICUCIDesc	;描述
    s PLIST(4)=ICUCICtlocDr	;科室
	s PLIST(5)=ICUCIStatus	;状态
	s PLIST(6)=ICUCIType	;类型
	s PLIST(7)=ICUCISearchLevel	;
	s PLIST(8)=ICUCIIcuaCount	;
	s PLIST(9)=ICUCIResultCount	;类型
	//s PLIST(10)=ICUCIIsByDate	;类型
	s PLIST(11)=ICUCIDataType	;类型
	//s PLIST(12)=ICUCIType	;木有用的
	s PLIST(13)=ICUCIUpdateUserDr	;类型
	s PLIST(14)=ICUCIUpdateDate	;类型
	s PLIST(15)=ICUCIUpdateTime	;类型
	//s PLIST(16)=ICUCIType	;类型
	&sql(update DHC_ICUC_Inquiry Values :PLIST() where ICUCI_RowId=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCICUCVitalSignWarn).DeleteICUCInquiry("1")
ClassMethod DeleteICUCInquiry(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from DHC_ICUC_Inquiry where %ID=:RowID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCVitalSignWarn","FindVitalSignWarn","40")
Query FindVitalSignWarn(TRowid As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ICUCVI_RowId,
       ICUCVI_Code,
       ICUCVI_Desc,
       ICUCVI_Type,
	   %EXTERNAL(ICUCVI_Type) As ICUCVI_TypeDesc,
       ICUCVI_MinQty,
       ICUCVI_MaxQty,
       ICUCVI_MainItem,
       ICUCVI_Duration,
       ICUCVI_Arcim,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',ICUCVI_Arcim) As ICUCVI_ArcimDesc,
       ICUCVI_IcuriId,
	   CIS_AN_COM.String_GetDescByID('User.DHCICUCRecordItem','ICUCRIDesc',ICUCVI_IcuriId) As ICUCVI_IcuriDesc,
       ICUCVI_SeqNo,
       ICUCVI_ConfigType,
	   %EXTERNAL(ICUCVI_ConfigType) As ICUCVI_ConfigTypeDesc,
       ICUCVI_MainItemLink,
	   CIS_AN_COM.String_GetDescByID('User.DHCICUCVitalSignWarn','ICUCVIDesc',ICUCVI_MainItemLink) As ICUCVI_MainItemLinkDesc
       from SQLUSER.DHC_ICUC_VitalSignWarn where ICUCVI_Parref=:TRowid
}

/// d ##class(web.DHCICUCVitalSignWarn).InsertVitalSignWarn(3,^TMPVitalSignWarn("Para"))
ClassMethod InsertVitalSignWarn(ICUCIRowid As %String, data As %String) As %String
{
	set ^TMPVitalSignWarn("Para")=data
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    kill VitalSignWarn
    m VitalSignWarn=array(1)
	k PLIST
	TSTART
    s PLIST(2)=ICUCIRowid
    s PLIST(3)=$g(VitalSignWarn("ICUCVI_Code"))
    s PLIST(4)=$g(VitalSignWarn("ICUCVI_Desc"))
    s PLIST(5)=$g(VitalSignWarn("ICUCVI_Type"))
    s PLIST(6)=$g(VitalSignWarn("ICUCVI_MinQty"))
    s PLIST(7)=$g(VitalSignWarn("ICUCVI_MaxQty"))
    s PLIST(8)=$g(VitalSignWarn("ICUCVI_MainItem"))
    s PLIST(9)=$g(VitalSignWarn("ICUCVI_Duration"))
    s PLIST(10)=$g(VitalSignWarn("ICUCVI_Arcim"))
    s PLIST(11)=$g(VitalSignWarn("ICUCVI_IcuriId"))
    s PLIST(12)=$g(VitalSignWarn("ICUCVI_SeqNo"))
    s PLIST(13)=$g(VitalSignWarn("ICUCVI_ConfigType"))
    s PLIST(14)=$g(VitalSignWarn("ICUCVI_MainItemLink"))
    &SQL(insert into DHC_ICUC_VitalSignWarn values:PLIST())    
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	TCOMMIT
	/// 调整顺序
    //d ..AdjustSeq(ICUCIRowid)
	q SQLCODE
}

/// d ##class(web.DHCICUCVitalSignWarn).UpdateVitalSignWarn("3",^TMPVitalSignWarn("Para"))
ClassMethod UpdateVitalSignWarn(ICUCIRowid As %String, RowId As %String = "", data As %String)
{
	set ^TMPVitalSignWarn("Para")=data
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    kill VitalSignWarn
    m VitalSignWarn=array(1)
	k PLIST
	TSTART
    s PLIST(1)=RowId
    s PLIST(2)=ICUCIRowid
    s PLIST(3)=$g(VitalSignWarn("ICUCVI_Code"))
    s PLIST(4)=$g(VitalSignWarn("ICUCVI_Desc"))
    s PLIST(5)=$g(VitalSignWarn("ICUCVI_Type"))
    s PLIST(6)=$g(VitalSignWarn("ICUCVI_MinQty"))
    s PLIST(7)=$g(VitalSignWarn("ICUCVI_MaxQty"))
    s PLIST(8)=$g(VitalSignWarn("ICUCVI_MainItem"))
    s PLIST(9)=$g(VitalSignWarn("ICUCVI_Duration"))
    s PLIST(10)=$g(VitalSignWarn("ICUCVI_Arcim"))
    s PLIST(11)=$g(VitalSignWarn("ICUCVI_IcuriId"))
    s PLIST(12)=$g(VitalSignWarn("ICUCVI_SeqNo")) 
    s PLIST(13)=$g(VitalSignWarn("ICUCVI_ConfigType"))
    s PLIST(14)=$g(VitalSignWarn("ICUCVI_MainItemLink"))
	&SQL(update DHC_ICUC_VitalSignWarn values:PLIST() where ICUCVI_RowId=:RowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
    // 调整顺序
    //d ..AdjustSeq(ICUCIRowid)
	q SQLCODE
}

/// d ##class(web.DHCICUCVitalSignWarn).DeleteVitalSignWarn("1")
ClassMethod DeleteVitalSignWarn(ICUCIRowid As %String, RowId As %String = "", ICUCIUpdateUserDr As %String = "") As %String
{
	i RowId'=""  d
	.&SQL(delete from DHC_ICUC_VitalSignWarn where ICUCVI_RowId=:RowId)
	i (RowId="")&&(ICUCIRowid'="") d
	.&SQL(delete from DHC_ICUC_VitalSignWarn where ICUCVI_Parref=:ICUCIRowid)
	.s ^DHCICUCInquiry(ICUCIRowid,"I")=0
	s tmpCIRowId=""
	i (RowId="")&&(ICUCIRowid="")&&(ICUCIUpdateUserDr'="") d
	.s tmpCIRowId=$o(^DHCICUCInquiry(0,"TypeUser","S",ICUCIUpdateUserDr,""))
	.i tmpCIRowId'=""  d
	..&SQL(delete from DHC_ICUC_VitalSignWarn where ICUCVI_Parref=:tmpCIRowId)
	..s ^DHCICUCInquiry(tmpCIRowId,"I")=0
	q SQLCODE
}

// 重新按顺序设置序号

ClassMethod AdjustSeq(mainId) As %String
{
	// 调整序号
	s sub=""
	f  s sub=$O(^DHCICUCInquiry(mainId,"I",sub)) q:sub=""  d
	.s subRowId=mainId_"||"_sub
	.q:'##class(User.DHCICUCVitalSignWarn).%ExistsId(subRowId)
	.s obj=##class(User.DHCICUCVitalSignWarn).%OpenId(subRowId)
	.s TMPSeqItem(+obj.ICUCIISeqNo,sub)=subRowId
	.d obj.%Close()
	
	s seq=""
	s index=1
	f  s seq=$O(TMPSeqItem(seq)) q:seq=""  d
	.s sub=""
	.f  s sub=$O(TMPSeqItem(seq,sub)) q:sub=""  d
	..s subRowId=$g(TMPSeqItem(seq,sub))
	..q:'##class(User.DHCICUCVitalSignWarn).%ExistsId(subRowId)
	..s obj=##class(User.DHCICUCVitalSignWarn).%OpenId(subRowId)
	..s obj.ICUCIISeqNo=index
	..d obj.%Save()
	..d obj.%Close()
	..s index=index+1
}

/// w ##class(web.DHCICUCVitalSignWarn).GetVitalSignEvent(159,13,94,"2021-11-01","2021-11-03","00:00","23:59","A")
/// dateForWardType:空为入病区时间,I为在病区时间,
ClassMethod GetVitalSignEvent(ctlocIdStr, icuaId, ICUCVIParref, inquiryFromDate, inquiryToDate, inquiryFromTime = "", inquiryToTime = "", disposal = "A") As %String
{
	q:ctlocIdStr="" -1
	q:ICUCVIParref="" -1
	s ICUCVIParref=95
	k ^DHCICUVitalSignWarn($j)
	s WarnId=""
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	f  s WarnId=$o(^DHCICUCVitalSignWarnI("Inquiry"," "_ICUCVIParref,WarnId)) q:WarnId=""  d
	   .s ICUCVICode=$lg(^DHCICUCVitalSignWarnD(WarnId),2)
	   .s ICUCVIDesc=$lg(^DHCICUCVitalSignWarnD(WarnId),3)
	   .s ICUCVIType=$lg(^DHCICUCVitalSignWarnD(WarnId),4)  //数据类型(生命体征、检验结果、药物)
	   .s ICUCVIMinQty=$lg(^DHCICUCVitalSignWarnD(WarnId),5)
	   .s ICUCVIMaxQty=$lg(^DHCICUCVitalSignWarnD(WarnId),6)
	   .s ICUCVIDuration=$lg(^DHCICUCVitalSignWarnD(WarnId),8)
	   .s ICUCVIArcim=$lg(^DHCICUCVitalSignWarnD(WarnId),9)
	   .s ICUCVIIcuriId=$lg(^DHCICUCVitalSignWarnD(WarnId),10)
	   .s ICUCVIMainItemLink=$lg(^DHCICUCVitalSignWarnD(WarnId),13)
	   .s date=inquiryFromDate-1
	   .i (ICUCVIType="V")&(ICUCVICode'["Average") d	//生命体征--重症记录
		  ..q:$lg(^DHCICUCVitalSignWarnD(WarnId),12)'="S" //必须是查找项
		  ..f  s date=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date)) q:(date="")!(date>inquiryToDate)!(date<inquiryFromDate)  d
	        ...s time=""
	        ...f  s time=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date,icuaId,time)) q:(time="")  d
	          ....q:(date=inquiryFromDate)&(time<inquiryFromTime)
	          ....q:(date=inquiryToDate)&(time>inquiryToTime) 
              ....s refIcuoId=""
              ....b ;
	          ....f  s refIcuoId=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date,icuaId,time,refIcuoId)) q:(refIcuoId="")  d
                .....q:'$d(^DHCICUOrder(refIcuoId))
		        .....q:"ICD"[$p(^DHCICUOrder(refIcuoId),"^",25)
		        .....b ;44
		        .....s OrderTime=$p(^DHCICUOrder(refIcuoId),"^",6)
		        .....s RefValue=$p(^DHCICUOrder(refIcuoId),"^",11)
	            .....q:(ICUCVIMinQty'="")&(ICUCVIMaxQty'="")&((RefValue>ICUCVIMinQty)&(RefValue<ICUCVIMaxQty))
		        .....s ^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date,ICUCVIMainItemLink,ICUCVICode,refIcuoId)=ICUCVICode_"^"_ICUCVIDesc_"^"_ICUCVIType_"^"_ICUCVIMainItemLink_"^"_RefValue_"^"_OrderTime
	            .....b ;45
	   .e  i (ICUCVIType="V")&(ICUCVICode["Average") d
	   ..s RefValue=..getAverageValue(icuaId,ICUCVIIcuriId,inquiryFromDate,inquiryFromTime,inquiryToTime)
	   ..q:(ICUCVIMinQty'="")&(ICUCVIMaxQty'="")&((RefValue>ICUCVIMinQty)&(RefValue<ICUCVIMaxQty))
	   ..q:RefValue=0
	   ..s ^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,inquiryFromDate,ICUCVIMainItemLink,ICUCVICode,"Average")=ICUCVICode_"^"_ICUCVIDesc_"^"_ICUCVIType_"^"_ICUCVIMainItemLink_"^"_RefValue_"^"_inquiryFromTime       
	   .i ICUCVIType="L" d	//检验结果--检验系统
	   .i ICUCVIType="O" d	//药物医嘱--重症记录
		  ..q:$lg(^DHCICUCVitalSignWarnD(WarnId),12)'="S" //必须是查找项
	      ..s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
		  ..q:oeordId=""
		  ..f  s date=$o(^OEORDi(0,"ARCIM",oeordId,ICUCVIArcim,date)) q:(date="")!(date>inquiryToDate)!(date<inquiryFromDate)   d
	        ...s oeoriSub=0
	        ...f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,ICUCVIArcim,date,oeoriSub)) q:(oeoriSub="")   d
			  ....q:'$d(^OEORD(oeordId,"I",oeoriSub))
			  ....s oeoriId=oeordId_"||"_oeoriSub
			  ....s oeoreSub=0,isFrist=0
			  ....f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(isFrist)  d
				.....s ONum=0							
				.....s exStDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
				.....s exStTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)
				.....q:(exStDate<inquiryFromDate)
	            .....q:(exStDate>inquiryToDate)
				.....q:(exStDate=inquiryFromDate)&(exStTime<inquiryFromTime)
	            .....q:(exStDate=inquiryToDate)&(exStTime>inquiryToTime)
	            .....s ONum=ONum+1
	            .....s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
			    .....q:'$d(^DHCICUOrder(0,"OEORE",oeoreId,icuaId))
		        .....s ^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date,ICUCVIMainItemLink,ICUCVICode,ONum)=ICUCVICode_"^"_ICUCVIDesc_"^"_ICUCVIType_"^"_ICUCVIMainItemLink_"^"_oeoreId_"^"_exStTime_"^-1"
	    .i ICUCVIType="N" d	//体温单--护理组
	    ..f inquiryDate=inquiryFromDate:1:inquiryToDate d
	    ...;s NurValue=180
	    ...s NurValue=##Class(Nur.Interface.OutSide.Temperature).getLimtItemValue(EpisodeID,inquiryDate,"sysPressure","MIN")
	    ...q:NurValue=""
	    ...s date=inquiryDate-1
	    ...i ICUCVIDuration'="" d
	    ....f  s date=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date)) q:(date="")!(date>inquiryDate)  d
	    .....s queryTime=inquiryFromTime-(3600*ICUCVIDuration)-1
	    .....s num=0
	    .....f  s queryTime=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date,icuaId,queryTime)) q:(queryTime="")!(queryTime>inquiryFromTime)  d
	    ......s flag=0
	    ......s num=num+1
	    ......s refIcuoId="" f  s refIcuoId=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date,icuaId,queryTime,refIcuoId)) q:(refIcuoId="")!(flag=1)  d
          .......q:'$d(^DHCICUOrder(refIcuoId))
		  .......q:"ICD"[$p(^DHCICUOrder(refIcuoId),"^",25)
		  .......s OrderTime=$p(^DHCICUOrder(refIcuoId),"^",6)
		  .......s RefValue=$p(^DHCICUOrder(refIcuoId),"^",11)
		  .......s:(NurValue-RefValue<30) flag=1  //有高的
	    ......i (flag=0)&(num>=ICUCVIDuration)  s ^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date,ICUCVIMainItemLink,ICUCVICode,queryTime)=ICUCVICode_"^"_ICUCVIDesc_"^"_ICUCVIType_"^"_ICUCVIMainItemLink_"^"_RefValue_"^"_queryTime
     q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCVitalSignWarn","FindVitalSignEvent","13","95","2021-11-10","2021-11-10","10:00","23:59","A")
Query FindVitalSignEvent(icuaId As %String, ICUCVIParref As %String, fromDate As %String = "", toDate As %String = "", fromTime As %String = "", toTime As %String = "", disposal As %String = "A") As %Query(ROWSPEC = "EventDate:%String,EventId:%String,EventCode:%String,EventDesc:%String,Disposal:%String,userName:%String,userId:%String,DisposalDateTime:%String") [ SqlProc ]
{
}

ClassMethod FindVitalSignEventExecute(ByRef qHandle As %Binary, icuaId As %String, ICUCVIParref As %String, fromDate As %String, toDate As %String, fromTime As %String, toTime As %String, disposal As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s ctlocId=%session.Get("LOGON.CTLOCID")
	s ctlocId=159
	s subItemStr=""
	s VitalMainId=""
	s ICUCVIParref=95
	s:fromDate="" fromDate=+$h
	s:toDate="" toDate=+$h
	s:fromTime="" fromTime="00:00"
	s:toTime="" toTime="23:59"
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	d ##class(web.DHCICUCVitalSignWarn).GetVitalSignEvent(ctlocId,icuaId,ICUCVIParref,fromDate,toDate,fromTime,toTime,disposal)
	
	s date=fromDate-1 f  s date=$o(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date)) q:(date="")!(date>toDate)  d  //分析异常数据
	.s mainId="" f  s mainId=$o(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date,mainId)) q:(mainId="")  d
	..s checkNum=0
	..s ICUCVICode=$lg(^DHCICUCVitalSignWarnD(mainId),2)
	..s Duration=$lg(^DHCICUCVitalSignWarnD(mainId),8)
	..s ICUCVINo=$lg(^DHCICUCVitalSignWarnD(mainId),11)
	..s subItemStr=..GetSubItemStr(ICUCVIParref,mainId)
	..s subItemStrLength=$l(subItemStr,"^")
	..f dnum=1:1:subItemStrLength d
	...s subItemCode=$p(subItemStr,"^",dnum)
	...i $d(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date,mainId,subItemCode)) s checkNum=checkNum+1
	...s subtraction=+$p($g(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,date,mainId,subItemCode,1)),"^",7)
	...s checkNum=checkNum+subtraction
	...b ;
	..i (checkNum>=ICUCVINo) s CheckList(date,mainId)=mainId
	b ;
	f  s date=$o(CheckList(date)) q:(date="")!(date>toDate)  d
	.f  s VitalMainId=$o(CheckList(date,VitalMainId)) q:(VitalMainId="")  d
	..s VitalMainCode=$lg(^DHCICUCVitalSignWarnD(VitalMainId),2)
	..s VitalMainItemDesc=$lg(^DHCICUCVitalSignWarnD(VitalMainId),7)
	..s Date=$zd(date,3)
	..s EventId=""
	..s Disposal="",DisposalDesc="",userName="",userId="",DisposalDateTime=""
	..s EventId=$o(^DHCICUVitalEventI("DateCode",date,VitalMainCode,EventId))
	..i EventId'="" d
	...s ICUAId=$lg(^DHCICUVitalEventD(EventId),1)
	...q:(ICUAId'="")&(ICUAId'=icuaId)
	...s Disposal=$lg(^DHCICUVitalEventD(EventId),7)
	...q:(disposal'="A")&(Disposal'="")&(Disposal'=disposal)
	...s DisposalDesc=$CASE(Disposal,"V":"确认","O":"未处理","I":"忽视")
	...s userId=$lg(^DHCICUVitalEventD(EventId),8)
	...i userId'="" s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	...s DisposalDate=$lg(^DHCICUVitalEventD(EventId),9)
	...s DisposalTime=$lg(^DHCICUVitalEventD(EventId),10)
	...i (DisposalDate'="")&(DisposalTime'="") s DisposalDateTime=$zd(DisposalDate,3)_" "_$zt(DisposalTime,2)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Date,VitalMainId,VitalMainCode,VitalMainItemDesc,DisposalDesc,userName,userId,DisposalDateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindVitalSignEventFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVitalSignEventExecute ]
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

ClassMethod FindVitalSignEventClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVitalSignEventExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取子项
/// w ##class(web.DHCICUCVitalSignWarn).GetSubItemStr(1)
ClassMethod GetSubItemStr(ICUCVIParref As %String, mainId As %String) As %String
{
	s SubItemStr=""
	s ICUCVIParref=95
	s WarnId="" f  s WarnId=$o(^DHCICUCVitalSignWarnI("Inquiry"," "_ICUCVIParref,WarnId)) q:WarnId=""  d
	.s ICUCVIMainItemLink=$lg(^DHCICUCVitalSignWarnD(WarnId),13)
	.q:((ICUCVIMainItemLink="")||((ICUCVIMainItemLink'="")&&(mainId'=ICUCVIMainItemLink)))
	.s ICUCVICode=$lg(^DHCICUCVitalSignWarnD(WarnId),2)
	.i SubItemStr'="" s SubItemStr=SubItemStr_"^"_ICUCVICode
	.e  s SubItemStr=ICUCVICode
	q SubItemStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCVitalSignWarn","FindVitalSignEventDetail","13","94","2021-11-01","8")
Query FindVitalSignEventDetail(icuaId As %String, ICUCVIParref As %String, Date As %String, mainId As %String) As %Query(ROWSPEC = "EventTime:%String,EventCode:%String,EventDesc:%String,EventType:%String,EventTypeId:%String,EventMainDesc:%String,EventValue:%String") [ SqlProc ]
{
}

ClassMethod FindVitalSignEventDetailExecute(ByRef qHandle As %Binary, icuaId As %String, ICUCVIParref As %String, Date As %String, mainId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Date=##class(web.DHCClinicCom).ConvertToDateH(Date)
	s ICUCVIParref=95
	s vitalCode=""
	s EventTime="",EventCode="",EventDesc="",EventType="",EventTypeId="",EventMainDesc="",EventValue=""
	f  s vitalCode=$o(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,Date,mainId,vitalCode)) q:(vitalCode="")  d
	.s WarnId=""
	.f  s WarnId=$o(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,Date,mainId,vitalCode,WarnId)) q:(WarnId="")  d
	..s data=$g(^DHCICUVitalSignWarn($j,icuaId,ICUCVIParref,Date,mainId,vitalCode,WarnId))
	..s EventCode=$p(data,"^",1)
	..s EventDesc=$p(data,"^",2)
	..s EventTypeId=$p(data,"^",3)
	..s EventType=$CASE(EventTypeId,"V":"生命体征","O":"药物医嘱","L":"检验结果")
	..s EventMainId=$p(data,"^",4)
	..s EventValue=$p(data,"^",5)
	..s EventTime=$p(data,"^",6)
	..s:EventTime'="" EventTime=$zt(EventTime,2)
	..d OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(EventTime,EventCode,EventDesc,EventType,EventTypeId,EventMainDesc,EventValue)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindVitalSignEventDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVitalSignEventDetailExecute ]
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

ClassMethod FindVitalSignEventDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVitalSignEventDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCICUCVitalSignWarn).SaveVitalSignEvent(13,"MainItem1","2021-11-01","V",12177)
ClassMethod SaveVitalSignEvent(icuaId As %String, MainItem As %String, EventDate As %String, Disposal As %String, userId As %String) As %String
{
	s EventDate=##class(web.DHCClinicCom).ConvertToDateH(EventDate)
    s objICUEvent = ##class(User.DHCICUVitalEvent).%New()
	s objICUEvent.ICUVIEICUADr=icuaId
	s objICUEvent.ICUVIECode=MainItem
	s objICUEvent.ICUVIEFromDate=EventDate
	s objICUEvent.ICUVIEToDate=EventDate
	s objICUEvent.ICUVIECreateDate=$p($h,",",1)
	s objICUEvent.ICUVIECreateTime=$p($h,",",2)
	s objICUEvent.ICUVIEDisposal=Disposal
	s objICUEvent.ICUVIEDisposalUserDr=userId
	s objICUEvent.ICUVIEDisposalDate=$p($h,",",1)
	s objICUEvent.ICUVIEDisposalTime=$p($h,",",2)
	s saveStatus=objICUEvent.%Save()
 	s ICUEventID=objICUEvent.%Id()
	d objICUEvent.%Close()
    q 0
}

/// w ##class(web.DHCICUCVitalSignWarn).getAverageValue(13,"5333","2021-11-01","00:00","23:59")
ClassMethod getAverageValue(icuaId As %String, ICUCVIIcuriId As %String, StDate As %String, StTime As %String, ToTime As %String)
{
	s StDate=##class(web.DHCClinicCom).ConvertToDateH(StDate)
	s StTime=##class(web.DHCClinicCom).ConvertToTimeH(StTime)
	s ToTime=##class(web.DHCClinicCom).ConvertToTimeH(ToTime)
	s num=0,Sum=0,AverageValue=0
    s time=StTime f  s time=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,StDate,icuaId,time)) q:(time="")!(time>ToTime)  d
	.s refIcuoId=""
	.f  s refIcuoId=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,StDate,icuaId,time,refIcuoId)) q:(refIcuoId="")  d
       ..q:'$d(^DHCICUOrder(refIcuoId))
	   ..q:"ICD"[$p(^DHCICUOrder(refIcuoId),"^",25)
	   ..s OrderTime=$p(^DHCICUOrder(refIcuoId),"^",6)
	   ..s RefValue=$p(^DHCICUOrder(refIcuoId),"^",11)
	   ..q:+RefValue=0
	   ..s num=num+1
	   ..s Sum=Sum+RefValue
	s:num'=0 AverageValue=Sum/num
	q AverageValue
}

/// w ##class(web.DHCICUCVitalSignWarn).CalDurationHour(13,"5333","HR","2","2021-11-01","2021-11-01","00:00","23:59")
ClassMethod CalDurationHour(icuaId As %String, ICUCVIIcuriId As %String, ICUCVICode As %String, ICUCVIDuration As %String, StDate As %String, ToDate As %String, StTime As %String, ToTime As %String)
{
	s StDate=##class(web.DHCClinicCom).ConvertToDateH(StDate)
	s StTime=##class(web.DHCClinicCom).ConvertToTimeH(StTime)
	s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
	s ToTime=##class(web.DHCClinicCom).ConvertToTimeH(ToTime)
    s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
    //s NurValue=##Class(Nur.Interface.OutSide.Temperature).getLimtItemValue(EpisodeID,StDate,ICUCVICode,"MIN")
	s NurValue=180
	q:NurValue="" 0
	s date=StDate-1
	i ICUCVIDuration'="" d
	.f  s date=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date)) q:(date="")!(date>StDate)!(date<ToDate)  d
	  ..s queryTime=StTime-(3600*ICUCVIDuration)-1
	  ..s num=0
	  ..f  s queryTime=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date,icuaId,queryTime)) q:(queryTime="")!(queryTime>StTime)  d
	  ...s flag=0
	  ...s num=num+1
	  ...s refIcuoId="" f  s refIcuoId=$o(^DHCICUOrder(0,"RecordItem",ICUCVIIcuriId,date,icuaId,queryTime,refIcuoId)) q:(refIcuoId="")!(flag=1)  d
          ....q:'$d(^DHCICUOrder(refIcuoId))
		  ....q:"ICD"[$p(^DHCICUOrder(refIcuoId),"^",25)
		  ....s OrderTime=$p(^DHCICUOrder(refIcuoId),"^",6)
		  ....s RefValue=$p(^DHCICUOrder(refIcuoId),"^",11)
		  ....s:(NurValue-RefValue<30) flag=1  //有高的
	  ...i (flag=0)&(num>=ICUCVIDuration) d
	  ....s ^DHCICUVitalSignWarn($j,icuaId,"94",date,8,ICUCVICode,queryTime)=ICUCVICode_"^ICUCVIDesc^ICUCVIType^8^"_RefValue_"^"_queryTime
    q 0
}

}
