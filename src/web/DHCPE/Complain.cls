/// 名称: 投诉管理
/// 编写者：ln
/// 编写日期: 2023-02-10
Class web.DHCPE.Complain Extends %RegisteredObject
{

/// Creator：    ln 
/// CreatDate：  20230210
/// Description: 投诉管理更新数据
/// Table：      投诉管理表 DHC_PE_Complain 
/// Input: 
/// Return：
/// debug: d ##class(web.DHCPE.Complain).UpdateUpLoadResult()
ClassMethod UpdateComplain(InfoStr As %String)
{
	s ^tempdhcpe("UpdateComplain")=$lb(InfoStr)
	s RowID=$P(InfoStr,"^",1)
	
	s CUser=%session.Get("LOGON.USERID")
	s CLoc=%session.Get("LOGON.CTLOCID")
	s Date=+$h
	s Time=$p($h,",",2)
	if RowID="" d
	.s obj=##class(User.DHCPEComplain).%New()
	e  d
	.s obj=##class(User.DHCPEComplain).%OpenId(RowID)
	
	s obj.CType=$P(InfoStr,"^",2)
	s obj.CSource=$P(InfoStr,"^",3)
	d obj.CComplainUserSetObjectId($P(InfoStr,"^",4))
	s obj.CComplainType=$P(InfoStr,"^",5)
	s obj.CComplainObject=$P(InfoStr,"^",6)
	s obj.CComplainContent=$P(InfoStr,"^",7)
	
	s EventTime=$P(InfoStr,"^",8)
	i EventTime'="" s EventTime=##class(websys.Conversions).DateHtmlToLogical(EventTime)
	s obj.CEventTime=EventTime
	
	s obj.CComplainCause=$P(InfoStr,"^",9)
	s obj.CDisProposal=$P(InfoStr,"^",10)
	s obj.CRemark=$P(InfoStr,"^",11)
	s obj.CName=$P(InfoStr,"^",12)
	s obj.CRegNo=$P(InfoStr,"^",13)
	s obj.CIDCard=$P(InfoStr,"^",14)
	d obj.CRecordSetObjectId($P(InfoStr,"^",15))	
	s obj.CClaimantName=$P(InfoStr,"^",16)
	s obj.CClaimantNo=$P(InfoStr,"^",17)
	s obj.CRelation=$P(InfoStr,"^",18)
	s obj.CTel=$P(InfoStr,"^",19)
	d obj.CUpdateUserSetObjectId(CUser)
	s obj.CUpdateDate=Date
	s obj.CUpdateTime=Time
    d obj.CLocSetObjectId(CLoc)
	
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		q "-1^"_$System.Status.GetErrorText(sc)
	} else {
		q obj.%Id()
	}
}

/// w ##class(web.DHCPE.Complain).GetComplainInfo("1")
ClassMethod GetComplainInfo(RowID As %String = "")
{
	q:RowID="" ""
	s obj=##class(User.DHCPEComplain).%OpenId(RowID)
	s CType=obj.CType
	s CSource=obj.CSource
	s ComplainUser=obj.CComplainUserGetObjectId()
	s ComplainType=obj.CComplainType
	s ComplainObject=obj.CComplainObject
	s ComplainContent=obj.CComplainContent
	s EventTime=obj.CEventTime
	s EventTime=##class(websys.Conversions).DateLogicalToHtml(EventTime)
	s ComplainCause=obj.CComplainCause
	s DisProposal=obj.CDisProposal
	s Remark=obj.CRemark
	s Name=obj.CName
	s RegNo=obj.CRegNo
	s IDCard=obj.CIDCard
	s PERecord=obj.CRecordGetObjectId()
	s PERecordDate=""
	i PERecord'="" s PERecordDate=$p(^DHCPEPreIADM(PERecord),"^",5)
	s ClaimantName=obj.CClaimantName
	s ClaimantNo=obj.CClaimantNo
	s Relation=obj.CRelation
	s Tel=obj.CTel
	
	q CType_"^"_CSource_"^"_ComplainUser_"^"_ComplainType_"^"_ComplainObject_"^"_ComplainContent_"^"_EventTime_"^"_ComplainCause_"^"_DisProposal_"^"_Remark_"^"_Name_"^"_RegNo_"^"_IDCard_"^"_PERecord_"^"_ClaimantName_"^"_ClaimantNo_"^"_Relation_"^"_Tel_"^"_PERecordDate
}

/// Description: 投诉查询
/// Table：投诉管理表 DHC_PE_Complain 
/// Input: BDate(开始日期), EDate(结束日期), Loc(科室)
/// Return：
/// Creator：ln 
/// CreatDate：20230210
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.Complain","FindComplainRecord","2023-02-01","","C","105")
Query FindComplainRecord(BDate As %Library.String = "", EDate As %Library.String = "", Type As %String = "", ProStatus As %String = "", Loc As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TTypeDesc:%String,TCSource:%String,TCComplainUser:%String,TCComplainType:%String,TCComplainObject:%String,TCComplainContent:%String,TCEventTime:%String,TCComplainCause:%String,TCDisProposal:%String,TCRemark:%String,TCName:%String,TCRegNo:%String,TCIDCard:%String,TCRecord:%String,TRecordDate:%String,TCClaimantName:%String,TCClaimantNo:%String,TCRelation:%String,TCTel:%String,TCUpdateUser:%String,TCUpdateDate:%String,TCUpdateTime:%String,TCLoc:%String,TStatus:%String")
{
}

ClassMethod FindComplainRecordExecute(ByRef qHandle As %Binary, BDate As %Library.String = "", EDate As %Library.String = "", Type As %String = "", ProStatus As %String = "", Loc As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i Type="" s Type="C"
 	i BDate'="" s BDate=##class(websys.Conversions).DateHtmlToLogical(BDate)
 	i EDate'="" s EDate=##class(websys.Conversions).DateHtmlToLogical(EDate)
 	i BDate="" s BDate=+$H
	i EDate="" s EDate=+$H 	
 	
 	s Date=BDate-1
 	f  s Date=$O(^User.DHCPEComplainI("CTypeUpdateDateIndex"," "_Type,Date)) q:(Date="")||(Date>EDate)  d
 	.s id=""
 	.f  s id=$O(^User.DHCPEComplainI("CTypeUpdateDateIndex"," "_Type,Date,id)) q:(id="")  d
 	..d SetComplainInfo
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetComplainInfo
    s TTypeDesc=..GetTypeDesc(Type)
    s TCSource=$LG(^User.DHCPEComplainD(id),3)
    s TCSource=..GetValueByCode("PEComplain","CSource","C",TCSource)
    s TCComplainUser=$LG(^User.DHCPEComplainD(id),4)
    s:TCComplainUser'="" TCComplainUser=$P(^SSU("SSUSR",TCComplainUser),"^",2)
    
    s TCComplainType=$LG(^User.DHCPEComplainD(id),5)
    s TCComplainType=..GetValueByCode("PEComplain","CType","C",TCComplainType)
    s TCComplainObject=$LG(^User.DHCPEComplainD(id),6)
    s TCComplainObject=..GetValueByCode("PEComplain","CObject","C",TCComplainObject)
    s TCComplainContent=$LG(^User.DHCPEComplainD(id),7)
    
    s TCEventTime=$LG(^User.DHCPEComplainD(id),8)
    s TCEventTime=##class(websys.Conversions).DateLogicalToHtml(TCEventTime)
    s TCComplainCause=$LG(^User.DHCPEComplainD(id),9)
    s TCComplainCause=..GetValueByCode("PEComplain","CCause","C",TCComplainCause)
    s TCDisProposal=$LG(^User.DHCPEComplainD(id),10)
    
    s TCRemark=$LG(^User.DHCPEComplainD(id),22)
	s TCName=$LG(^User.DHCPEComplainD(id),11)
	s TCRegNo=$LG(^User.DHCPEComplainD(id),12)
	s TCIDCard=$LG(^User.DHCPEComplainD(id),13)
	s TCRecord=$LG(^User.DHCPEComplainD(id),14)
	s TRecordDate=""
	
	s:TCRecord'="" TRecordDate=$p(^DHCPEPreIADM(TCRecord),"^",4)
	s TRecordDate=##class(websys.Conversions).DateLogicalToHtml(TRecordDate)
	
	s TCClaimantName=$LG(^User.DHCPEComplainD(id),15)
	s TCClaimantNo=$LG(^User.DHCPEComplainD(id),16)
	s TCRelation=$LG(^User.DHCPEComplainD(id),17)
	s TCRelation=..GetValueByCode("PEComplain","CRelation","C",TCRelation)
	s TCTel=$LG(^User.DHCPEComplainD(id),18)
	s TCUpdateUser=$LG(^User.DHCPEComplainD(id),19)
	s TCUpdateUser=$P(^SSU("SSUSR",TCUpdateUser),"^",2)
	
	s TCUpdateDate=$LG(^User.DHCPEComplainD(id),20)
	s TCUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TCUpdateDate)
	s TCUpdateTime=$LG(^User.DHCPEComplainD(id),21)
	s TCUpdateTime=##class(websys.Conversions).TimeLogicalToHtml(TCUpdateTime)
    s TCLoc=$LG(^User.DHCPEComplainD(id),23)
    q:(Loc'="")&&(Loc'=TCLoc)
    s TCLoc=$p(^CTLOC(TCLoc),"^",2)
    
    s CompDispose=$o(^User.DHCPECompDisposeI("CDCompDRIndex",id,0))
    i CompDispose="" s TStatus="未处理"
    e  s TStatus="已处理"
    q:(ProStatus="NoPro")&&(TStatus="已处理")
    q:(ProStatus="HadPro")&&(TStatus="未处理")
    d FindComplainBuild
    
    q
FindComplainBuild      
	set Data=$lb(id,TTypeDesc,TCSource,TCComplainUser,TCComplainType,TCComplainObject,TCComplainContent,TCEventTime,TCComplainCause,TCDisProposal,TCRemark,TCName,TCRegNo,TCIDCard,TCRecord,TRecordDate,TCClaimantName,TCClaimantNo,TCRelation,TCTel,TCUpdateUser,TCUpdateDate,TCUpdateTime,TCLoc,TStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetTypeDesc(Type)
{
	q:Type="C" "投诉"
	//q:Type="S" "建议"
	
	q ""
}

/// 根据代码获得参数值(投诉管理)
/// w ##class(web.DHCPE.Complain).GetValueByCode("PEComplain","CSource","C","ST")
ClassMethod GetValueByCode(appcode As %String = "", Paramcode As %String = "", ValueType As %String = "", ValueCode As %String = "")
{
	q:(appcode="")||(Paramcode="")||(ValueCode="") ""
	i ValueType="" s ValueType="C"
	
	s appId=$o(^DHCPESettingsApp(0,"Code",appcode,0))
	q:appId="" ""
	s SPDR=$o(^DHCPESettingsParam(0,"APPCode",appId,Paramcode,0))
	q:SPDR="" ""
	
	s ValueID=$o(^DHCPESettingsValue(0,"ParamTV",SPDR,"Type",ValueType,ValueCode,0))
	q:ValueID="" ""
	s ParamValue=$p(^DHCPESettingsValue(ValueID),"^",4)
	q ParamValue
}

ClassMethod GetComplainContent(id)
{
	q:id="" ""
	s obj=##class(User.DHCPEComplain).%OpenId(id)
	s Content=obj.CComplainContent
	
	s CDMode="",CDDetail="",CDRemark=""
	s CompDispose=$o(^User.DHCPECompDisposeI("CDCompDRIndex",id,0))
	i CompDispose'="" d
	.s Dobj=##class(User.DHCPECompDispose).%OpenId(CompDispose)
	.s CDMode=Dobj.CDMode
	.s CDDetail=Dobj.CDDetail
	.s CDRemark=Dobj.CDRemark
	
	q Content_"^"_CDMode_"^"_CDDetail_"^"_CDRemark
}

ClassMethod UpdateCompDispose(InfoStr As %String)
{
	s ^tempdhcpe("UpdateCompDispose")=$lb(InfoStr)
	s CompRowID=$P(InfoStr,"^",1)
	
	s User=%session.Get("LOGON.USERID")
	s Date=+$h
	s Time=$p($h,",",2)
	
	s CompDispose=$o(^User.DHCPECompDisposeI("CDCompDRIndex",CompRowID,0))
	i CompDispose="" d
	.s obj=##class(User.DHCPECompDispose).%New()
	.d obj.CDCompDRSetObjectId(CompRowID)
	e  d
	.s obj=##class(User.DHCPECompDispose).%OpenId(CompDispose)
	s obj.CDMode=$P(InfoStr,"^",2)
	s obj.CDDetail=$P(InfoStr,"^",3)
	s obj.CDRemark=$P(InfoStr,"^",4)
	d obj.CDUpdateUserSetObjectId(User)
	s obj.CDUpdateDate=Date
	s obj.CDUpdateTime=Time
	
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		q "-1^"_$System.Status.GetErrorText(sc)
	} else {
		q obj.%Id()
	}
}

/// Description：添加体检投诉维护数据 
/// Input:   	
/// Return:		
/// Creator:	ln
/// CreateDate:	2023-02-14
/// Debug: w ##class(web.DHCPE.Complain).AddPEComplain()
ClassMethod AddPEComplain()
{
	Quit:$DATA(^DHCPESettingsApp(0,"Code","PEComplain")) "-1^配置信息已存在"
	Set $ZTRAP = "AddPEComplainErr"
	Tstart
	Write "/*************生成APP*************/",!
	Set appId = ##class(web.DHCPE.Settings.App).AddApp("PEComplain","投诉管理")
	If +appId<=0  Trollback  Quit appId
	
	
	Write "/*************生成Param事件来源*************/",!
	Set paramCS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CSource","事件来源")
	If +paramCS<=0  Trollback  Quit paramCS
	
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCS,"C","ST","电话投诉")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCS,"C","SS","现场投诉")
	If +js<=0  Trollback  Quit js
	
	
	Write "/*************生成Param投诉类型*************/",!
	Set paramCT = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CType","投诉类型")
	If +paramCT<=0  Trollback  Quit paramCT
	
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCT,"C","TDSS","患者不满意")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCT,"C","TDGTE","诊疗错误")
	If +js<=0  Trollback  Quit js
	
	
	Write "/*************生成Param投诉对象*************/",!
	Set paramCO = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CObject","投诉对象")
	If +paramCO<=0  Trollback  Quit paramCO
	
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCO,"C","Doc","医生")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCO,"C","Nur","护士")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCO,"C","Worker","工作人员")
	If +js<=0  Trollback  Quit js
	
	
	Write "/*************生成Param投诉原因*************/",!
	Set paramCC = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CCause","投诉原因")
	If +paramCC<=0  Trollback  Quit paramCC
	
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCC,"C","CErr","结果录入错误")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCC,"C","CBad","态度不好")
	If +js<=0  Trollback  Quit js
	
	
	Write "/*************生成Param与患者关系*************/",!
	Set paramCR = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CRelation","与患者关系")
	If +paramCR<=0  Trollback  Quit paramCR
	
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCR,"C","CSon","父子")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCR,"C","CDaut","母女")
	If +js<=0  Trollback  Quit js
	
	
	Write "/*************生成Param处理方式*************/",!
	Set paramCM = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CMode","处理方式")
	If +paramCM<=0  Trollback  Quit paramCM
	
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCM,"C","Med","调解")
	If +js<=0  Trollback  Quit js
	
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramCM,"C","Mod","修正错误")
	If +js<=0  Trollback  Quit js
	
	Tcommit
	Write "/*************SUCCESS*************/",!
	Quit 0
AddPEComplainErr
	Set $ZTRAP = ""
	Trollback
	Quit "-100^"_$ZERROR
}

/// 功能：根据登记号获取个人基本信息
/// w ##class(web.DHCPE.Complain).GetBaseInfoByRegNo("")
ClassMethod GetBaseInfoByRegNo(RegNo As %Library.String = "")
{
	q:RegNo="" ""
	s PIBIRowId=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBIRowId="" ""
	s Name="",IDCard=""
	s Name=$p($G(^DHCPEPreIBI(PIBIRowId)),"^",2)
	s IDCard=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",9)
	
	q Name_"^"_IDCard
}

}
