/// 名称: 危害因素关联检查项目
/// 编写者：zhongricheng
/// 编写日期: 2021-08-06
Class web.DHCPE.CT.EndangerItem Extends %RegisteredObject
{

/// Creator：zhongricheng
/// CreatDate：2021-08-06
/// Description: 更新职业病危害因素对应检查项目
/// Table：危害因素对应检查项目 User.DHCPEEDItem   DHC_PE_EDItem
/// Input: ID 表Id,可空白  InfoStr 数据串 
/// Return：code -1 失败   msg 原因
/// dubug: w ##class(web.DHCPE.CT.EndangerItem).SaveEndangerItem("","","")
ClassMethod SaveEndangerItem(Parref, ID, InfoStr, LocId, USERID = "")
{
	q:Parref="" ..OutInfo(-1, "未获取到危害因素ID")
	q:'$d(^User.DHCPEEndangerD(Parref)) ..OutInfo(-1, "无效危害因素ID")
	
	q:LocId="" ..OutInfo(-1, "未选择有效科室")
	
	s arcim=$p(InfoStr,"^",2)
	s setsFlag=$p(InfoStr,"^",3)
	q:arcim="" ..OutInfo(-1, "请选择检查项目或套餐")
	s omeType=$p(InfoStr,"^",1)
	s tableName=$p(InfoStr,"^",8)
	
	s tmpSub=0,qFlag=0
	f  s tmpSub=$o(^User.DHCPEEDItemI("ItemIDIndex"," "_arcim,Parref,tmpSub)) q:((tmpSub="")||(qFlag=1))  d
	.q:(Parref_"||"_tmpSub)=ID
	.q:##class(User.DHCPEEDItem).GetLocShowDataFlag(Parref_"||"_tmpSub,LocId)'="Y"
	.s tmpOmeType=$LG(^User.DHCPEEndangerD(Parref,"EDItemChild",tmpSub),5)
	.s:omeType=tmpOmeType qFlag=1
    q:qFlag=1 ..OutInfo(-1, "该危害因素对应相同检查种类的项目已存在")
	
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	
	if ID="" d
	.s obj=##class(User.DHCPEEDItem).%New()
	.d obj.EDIParrefSetObjectId(Parref)
	e  d
	.s obj=##class(User.DHCPEEDItem).%OpenId(ID)
	
	s obj.EDIItemMastID=arcim
	d obj.EDIOMETypeDRSetObjectId(omeType)
	s obj.EDISetsFlag=setsFlag
	s obj.EDINeedFlag=$p(InfoStr,"^",4)
	s obj.EDIActive=$p(InfoStr,"^",5)
	s obj.EDIExpInfo=$p(InfoStr,"^",6)
	s obj.EDIRemark=$p(InfoStr,"^",7)
	s obj.EDIUpdateDate=+$h
	s obj.EDIUpdateTime=$p($h,",",2)
	s obj.EDIUpdateUserDR=USERID
	
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	
	s ret=""
	if ($System.Status.IsError(sc)) {
		s msg=$System.Status.GetErrorText(sc)
		goto SaveEndangerItemErr
		q ret
	} else {
		s:ID="" ret=##class(User.DHCPEEDItem).SaveDataToPowerControl(obj.%Id(),LocId,USERID)
		i ($p(ret,"^",1)="-1") {
			s msg="插入记录授权表失败"
			goto SaveEndangerItemErr
			q ret
		}
		TCommit
		q ..OutInfo(obj.%Id())
	}
SaveEndangerItemErr
	TROLLBACK
	//s:msg="" msg="程序出错"_$ZE
	s ret=..OutInfo(-1, msg)
	q
}

/// Description: 删除职业病危害因素对应检查项目
/// Table：危害因素对应检查项目 User.DHCPEEDItem   DHC_PE_EDItem
/// Input: ID 表Id
/// Return：code -1 失败   msg 原因
/// Creator：zhongricheng
/// CreatDate：2021-08-09
/// dubug: w ##class(web.DHCPE.CT.EndangerItem).DeleteEndangerItem("")
ClassMethod DeleteEndangerItem(ID)
{
	q:ID="" ..OutInfo("-1", "请选择需要删除的记录")
	s obj=##class(User.DHCPEEDItem).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc)) {
		q ..OutInfo("-1", $System.Status.GetErrorText(sc))
	} else {
		q ..OutInfo(obj.%Id())
	}
}

/// Creator：	  zhongricheng
/// CreatDate：   2021-08-09
/// Description:  职业病危害因素对应检查项目Query
/// Table：       危害因素对应检查项目 User.DHCPEEDItem   DHC_PE_EDItem
/// Input:        Parref DHC_PE_Endanger表Id   CTLOCID 登陆科室
/// Return：
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.EndangerItem","SearchEndangerItem","1")
Query SearchEndangerItem(Parref As %Library.String = "", LocID As %Library.String = "", HospID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TArcimID:%String,TArcimCode:%String,TArcimDesc:%String,TSetsFlag:%String,TNeedFlag:%String,TOMETypeDR:%String,TOMEType:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchEndangerItemExecute(ByRef qHandle As %Binary, Parref As %Library.String = "", LocID As %Library.String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	i Parref="" {
		Quit $$$OK
 	}
 	
 	s:LocID="" LocID=%session.Get("LOGON.CTLOCID")
 	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
 	
 	s Child=0
 	f  s Child=$O(^User.DHCPEEndangerD(Parref,"EDItemChild",Child)) q:Child=""  d
 	.s tId=Parref_"||"_Child
 	.q:##class(User.DHCPEEDItem).GetLocShowDataFlag(tId,LocID)'="Y"
 	.s ItemMast=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),2)
	.q:ItemMast=""
	.s SetsFlag=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),4)
	.i SetsFlag="Y" d
	..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_OrdSets",ItemMast,HospID)
	..s ArcimCode=$P($g(^ARCOS(+ItemMast)),"^",1)
 	..s ArcimDesc=$P($g(^ARCOS(+ItemMast)),"^",2)
	.e  d
	..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ItemMast,HospID)
	..s ArcimCode=$P($g(^ARCIM(+ItemMast,1,1)),"^",1)
 	..s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMast)
 	.q:(HOSPshowFlag="N")
 	.s SetsFlag=$s(SetsFlag="Y":"是",1:"否")
	.s NeedFlag=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),3)
 	.s NeedFlag=$s(NeedFlag="Y":"是",1:"否")
	.s OMETypeDR=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),5),OMETypeDesc=""
	.s:OMETypeDR'="" OMETypeDesc=$LG(^User.DHCPEOMETypeD(OMETypeDR),3) 
	.s Active=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),6)
 	.s Active=$s(Active="Y":"是",1:"否")
	.s ExpInfo=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),7)
	.s Remark=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),8)
	.d outEndangerItem
	Quit $$$OK
outEndangerItem
	set Data=$lb(tId,ItemMast,ArcimCode,ArcimDesc,SetsFlag,NeedFlag,OMETypeDR,OMETypeDesc,Active,ExpInfo,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：zhongricheng
/// CreatDate：2021-08-09
/// Description: 根据ID获取职业病危害因素对应检查项目信息
/// Table：危害因素对应检查项目 User.DHCPEEDItem   DHC_PE_EDItem
/// Input: ID DHC_PE_EDItem
/// Return：json串
/// dubug: d ##class(web.DHCPE.CT.EndangerItem).GetEndangerItemInfo("")
ClassMethod GetEndangerItemInfo(ID)
{
	q:ID="" ""
	s Parref=+ID
	q:'$d(^User.DHCPEEndangerD(Parref)) ""
	s Child=$p(ID,"||",2)
	q:'$d(^User.DHCPEEndangerD(Parref,"EDItemChild",Child)) ""
	
	s ItemMast=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),2)
	q:ItemMast="" ""
	s SetsFlag=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),4)
	i SetsFlag="Y" {
		s ArcimCode=$P($g(^ARCOS(+ArcimID)),"^",1)
 		s ArcimDesc=$P($g(^ARCOS(+ArcimID)),"^",2)
	} else {
		s ArcimCode=$P($g(^ARCIM(+ArcimID,1,1)),"^",1)
 		s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMast)
	}
	
	s NeedFlag=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),3)
	s OMETypeDR=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),5),OMETypeDesc=""
	s:OMETypeDR'="" OMETypeDesc=$LG(^User.DHCPEOMETypeD(OMETypeDR),3) 
	s Active=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),6)
	s ExpInfo=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),7)
	s Remark=$lg(^User.DHCPEEndangerD(Parref,"EDItemChild",Child),8)
	
	s info={}
	s info.ItemMast=ItemMast
	s info.ArcimCode=ArcimCode
	s info.ArcimDesc=ArcimDesc
	s info.SetsFlag=SetsFlag
	s info.NeedFlag=NeedFlag
	s info.OMETypeDR=OMETypeDR
	s info.OMETypeDesc=OMETypeDesc
	s info.Active=Active
	s info.ExpInfo=ExpInfo
	s info.Remark=Remark
	q info.%ToJSON()
}

/// Creator：	 zhongricheng
/// CreatDate：	 2021-08-15
/// Description: 保存危害因素检查项目的重点检查内容
/// Table：      危害因素对应检查细项 User.DHCPEEDItemDetail   DHC_PE_EDItemDetail
/// Input:       Parref DHC_PE_EDItem表ID   ID DHC_PE_EDItemDetail表ID
/// Return：
/// Dubug:  d ##class(web.DHCPE.CT.EndangerItem).UpdEndangerItmDetail("1||13","1||13||125","1||27^N^^","152","12187")
ClassMethod UpdEndangerItmDetail(Parref, ID, InfoStr, LocId, USERID As %String = "")
{
	s ^tempdhcpe("UpdEndangerItmDetail")=$lb(Parref, ID, InfoStr, LocId, USERID )
	q:Parref="" ..OutInfo("-1", "请先选择需要操作的项目")
	q:'$d(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2))) ..OutInfo("-1", "操作的项目无效")
	
	if ID="" d
	.s obj=##class(User.DHCPEEDItemDetail).%New()
	.d obj.EDDParrefSetObjectId(Parref)
	e  d
	.s obj=##class(User.DHCPEEDItemDetail).%OpenId(ID)
	
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	d obj.EDIDDetailDRSetObjectId($p(InfoStr,"^",1))
	s obj.EDIActive=$p(InfoStr,"^",2)
	s obj.EDIExpInfo=$p(InfoStr,"^",3)
	s obj.EDIRemark=$p(InfoStr,"^",4)
	s obj.EDIUpdateDate=+$h
	s obj.EDIUpdateTime=$p($h,",",2)
	s obj.EDIUpdateUserDR=USERID
	s sc=obj.%Save()
	d obj.%Close()
	
	if ($System.Status.IsError(sc)) {
		q ..OutInfo("-1", $System.Status.GetErrorText(sc))
	} else {
		q ..OutInfo(obj.%Id())
	}
}

/// Creator：zhongricheng
/// CreatDate：2021-08-14
/// Description: 危害因素检查项目的重点检查内容
/// Table：危害因素对应检查细项 User.DHCPEEDItemDetail   DHC_PE_EDItemDetail
/// Input: Parref DHC_PE_EDItem表ID
/// Return：
/// dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.EndangerItem","SearchEndangerItmDetail","1||27")
Query SearchEndangerItmDetail(Parref As %Library.String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TODRowId:%String,TODCode:%String,TODDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String,TUpdDate:%String,TUpdTime:%String,TUpdUser:%String,TUpdUserName:%String")
{
}

ClassMethod SearchEndangerItmDetailExecute(ByRef qHandle As %Binary, Parref As %Library.String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	i Parref="" {
		Quit $$$OK
 	}
 	
 	s ArcImRowId=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2)),2)
 	i ArcImRowId="" {
		Quit $$$OK
 	}
 	
 	s ODRelate=0
 	f  s ODRelate=$o(^DHCPEODR(0,"ARCIM",ArcImRowId,ODRelate)) q:ODRelate=""  d
 	.s NoActive=$p($g(^DHCPEODR(ODRelate)),"^",8)
 	.;q:NoActive'="N"
 	.s ODRowId=$p($g(^DHCPEODR(ODRelate)),"^",2)
 	.;q:##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODRowId,LocID)'="Y"
 	.
 	.s ODCode=$p($g(^DHCPEST(+ODRowId,"OD",$p(ODRowId,"||",2))),"^",11)
	.s ODDesc=$p($g(^DHCPEST(+ODRowId,"OD",$p(ODRowId,"||",2))),"^",1)
	.s Active="N"
 	.s (tId,ExpInfo,Remark,UpdateDate,UpdateTime,UpdateUser,UpdateUserName)=""
 	.s ID=$o(^User.DHCPEEDItemDetailI("DetailDRIndex",ODRowId,+Parref,$p(Parref,"||",2),0))
 	.i ID'="" d
 	..s tId=Parref_"||"_ID
 	..s Active=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2),"EDItemDetailChild",ID),3)
 	..s ExpInfo=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2),"EDItemDetailChild",ID),4)
 	..s Remark=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2),"EDItemDetailChild",ID),5)
 	..s UpdateDate=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2),"EDItemDetailChild",ID),6)
 	..s:UpdateDate'="" UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
 	..s UpdateTime=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2),"EDItemDetailChild",ID),7)
 	..s:UpdateTime'="" UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
 	..s UpdateUser=$lg(^User.DHCPEEndangerD(+Parref,"EDItemChild",$p(Parref,"||",2),"EDItemDetailChild",ID),8)
 	..s UpdateUserName=$s(UpdateUser'="":$p($g(^SSU("SSUSR",UpdateUser)),"^",2),1:"")
	.d outEndangerItmDetail
	
	Quit $$$OK
outEndangerItmDetail      
	set Data=$lb(tId,ODRowId,ODCode,ODDesc,Active,ExpInfo,Remark,UpdateDate,UpdateTime,UpdateUser,UpdateUserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description: 输出json格式字符串
/// Table：
/// Input: code 代码  msg 信息
/// Return：{"code":"1","msg":"成功"}
/// Creator：zhongricheng
/// CreatDate：2021-08-04
/// dubug: w ##class(web.DHCPE.CT.EndangerItem).OutInfo("1","3")
ClassMethod OutInfo(code, msg As %String = "")
{
	s json={}
	s json.code=code
	s json.msg=msg
	q json.%ToJSON()
}

}
