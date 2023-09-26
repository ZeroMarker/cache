Import sqluser

/// 体检项目延期
Class web.DHCPE.OrderPostPoned Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:  查询一段时间内延期项目信息
/// Input:        DateBegin(延期开始日期), DateEnd(延期结束日期), RegNo(登记号), Name(姓名),LocID(登录科室ID)
/// Debug:  d ##class(%ResultSet).RunQuery("web.DHCPE.OrderPostPoned","CheckDelay","1","")
Query CheckDelay(DateBegin As %Library.String = "", DateEnd As %Library.String = "", RegNo As %String = "", Name As %String = "", LocID) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,DateDesc:%String,ArcDesc:%String,IfComplateAll:%String")
{
}

ClassMethod CheckDelayExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "", RegNo As %String = "", Name As %String = "", LocID) As %Status
{
	
   	s ^tmpdhcpe("CheckDelay")=$Lb(DateBegin,DateEnd,RegNo,Name,LocID)
   	s ind=1
 	Set repid=$I(^CacheTemp)
 	
 	if ((""=DateBegin)&&(""=DateEnd)&&(RegNo="")&&(Name="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	i DateEnd'="" s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	
	i DateBegin="" s DateBegin=1
	i DateEnd="" s DateEnd=+$H
	
	s AdmDate=DateBegin-1
	f  s AdmDate=$O(^User.DHCPEDelayRecordI("DateFlagADMOEORIIndex",AdmDate)) q:(AdmDate="")||(AdmDate>DateEnd)  d
	.s PAADM=""
	.s DateDesc=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	.f  s PAADM=$o(^User.DHCPEDelayRecordI("DateFlagADMOEORIIndex",AdmDate,"Y",PAADM)) q:(PAADM="")  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,LocID)
	..q:LocFlag="1"
	..s PAPMIID=$P($g(^PAADM(PAADM)),"^",1)
	..q:PAPMIID=""
	..s TRegNo=$P($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	..s TName=$P($g(^PAPER(PAPMIID,"ALL")),"^",1)
	..q:(RegNo'="")&&(RegNo'=TRegNo)
	..q:(Name'="")&&(Name'=TName)
	..s OrdItem=""
	..f  s OrdItem=$o(^User.DHCPEDelayRecordI("DateFlagADMOEORIIndex",AdmDate,"Y",PAADM,OrdItem)) q:(OrdItem="")  d
	...s ID=$o(^User.DHCPEDelayRecordI("DateFlagADMOEORIIndex",AdmDate,"Y",PAADM,OrdItem,0))
	...s data=$g(^User.DHCPEDelayRecordI("DateFlagADMOEORIIndex",AdmDate,"Y",PAADM,OrdItem,ID))
	...s RealOrdItem=$Replace(OrdItem," ","")
	...s ArcItm=$p($g(^OEORD(+RealOrdItem,"I",$p(OrdItem,"||",2),1)),"^",2)
	...q:ArcItm=""
	...s ArcDesc=$p($g(^ARCIM(+ArcItm,1,1)),"^",2)
	...s IfComplateAll=$lg(^User.DHCPEDelayRecordD(ID),6)
	...s:(IfComplateAll="Y") IfComplateAll="是"
	...s:(IfComplateAll="N") IfComplateAll="否"
	.../***翻译 start***/
    ...s ArcDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ArcDesc,"ARCIMDesc","cls")
    ...s IfComplateAll=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedelay.hisui.csp",IfComplateAll)
    .../***翻译 end***/
	...s Data=$lb(TRegNo,TName,DateDesc,ArcDesc,IfComplateAll)
	...Set ^CacheTemp(repid,ind)=Data
 	...Set ind=ind+1
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod CheckDelayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckDelayExecute ]
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

ClassMethod CheckDelayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckDelayExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 更新延期时间和延期原因
/// Debug：  w ##Class(web.DHCPE.OrderPostPoned).PostPoneOrder("950||16","Y","01","2019-01-05")
ClassMethod PostPoneOrder(oeori, Flag, Reason, Date)
{
	s ^tmpdhcpe("PostPoneOrder")=$lb(oeori, Flag, Reason, Date)
	s CRMOID=$O(^DHCPECRMO(0,"OEORI",oeori,""))
	s CRMORI=$P($g(^DHCPECRMO(CRMOID)),"^",2)
	s PIOI=CRMORI
	
	s Flag="Y"
	if Reason="" s Reason="01"  //为空默认01客户要求
	q:Date="" "请先选择延期日期！"
	q:Date'["-" "请检查日期格式是否正确！"
	s Date=$zdh(Date,3)
	s User=%session.Get("LOGON.USERID")
	&sql(Update DHC_PE_PreIOrdItem Set PIOI_PostponedFlag=:Flag,PIOI_PostponedReason=:Reason,PIOI_PostponedDate=:Date,PIOI_PostponedUser=:User Where PIOI_RowId=:PIOI)
	
	//延期发送短信 add by wangminglong 2019-4-16 start
	i SQLCODE=0 d
	.s CRMOIADMDR=$P($g(^DHCPECRMO(CRMOID)),"^",3)
	.s PreIAdm=$p($g(^DHCPEIADM(CRMOIADMDR)),"^",4)
	.d ##class(web.DHCPE.SendMessage).DirectSenMessage("PostPoneSendMsg",PreIAdm,"",Date)
	//延期发送短信 add by wangminglong 2019-4-16 end
	
	q SQLCODE
}

/// Description: 取消延期
/// Debug: w ##Class(web.DHCPE.OrderPostPoned).CancelPostPoneOrder("1094||2")
ClassMethod CancelPostPoneOrder(oeori)
{
	s CRMOID=$O(^DHCPECRMO(0,"OEORI",oeori,""))
	s CRMORI=$P($g(^DHCPECRMO(CRMOID)),"^",2)
	s PIOI=CRMORI
	s Flag="",Reason="",Date="",User=""
	&sql(Update DHC_PE_PreIOrdItem Set PIOI_PostponedFlag=:Flag,PIOI_PostponedReason=:Reason,PIOI_PostponedDate=:Date,PIOI_PostponedUser=:User Where PIOI_RowId=:PIOI)
	q SQLCODE
}

/// Description:  延期原因下拉列表
/// Debug： d ##Class(web.DHCPE.OrderPostPoned).OutPostponedReasonToHTML("130")
ClassMethod OutPostponedReasonToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='延期原因' id='PostPoneReason' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value='01'>客户要求</option>",!
	w "<option value='02'>暂不满足检查条件</option>",!
	w "<option value='03'>其他原因</option>",!
	w "</select>",!
	Quit $$$OK
}

/// Description: 根据医嘱ID取延期标志、延期日期、延期原因、延期人
/// Input:       oeori HIS医嘱表ID
/// Output:      延期标志^延期日期^延期原因^延期人
/// Debug:  w ##Class(web.DHCPE.OrderPostPoned).GetPostPoneInfo("1094||2")
ClassMethod GetPostPoneInfo(oeori)
{
	s CRMOID=$O(^DHCPECRMO(0,"OEORI",oeori,""))
	q:CRMOID="" "^^^"
	s CRMORI=$P(^DHCPECRMO(CRMOID),"^",2)
	s PIOI=CRMORI
	
	s PostPoneFlag="",PostPoneReason="",PostPoneDate="",PostPoneUser=""
	s PostPoneFlag=$p(^DHCPEPreIADM(+PIOI,"ORDITEM",$p(PIOI,"||",2)),"^",18)
	s PostPoneReason=$p(^DHCPEPreIADM(+PIOI,"ORDITEM",$p(PIOI,"||",2)),"^",19)
	s:PostPoneReason="01" PostPoneReason="客户要求"
	s:PostPoneReason="02" PostPoneReason="暂不满足检查要求"
	s:PostPoneReason="03" PostPoneReason="其他原因"
	s PostPoneDate=$p(^DHCPEPreIADM(+PIOI,"ORDITEM",$p(PIOI,"||",2)),"^",20)
	i PostPoneDate'="" s PostPoneDate=$zd(PostPoneDate,3)
	s PostPoneUser=$p(^DHCPEPreIADM(+PIOI,"ORDITEM",$p(PIOI,"||",2)),"^",21)
	i PostPoneUser'="" s PostPoneUser=$p(^SSU("SSUSR",PostPoneUser),"^",2)
	
	q PostPoneFlag_"^"_PostPoneReason_"^"_PostPoneDate_"^"_PostPoneUser
}

/// 根据就诊ID判断该次就诊是否有延检项目 add by wangminglong 2019-3-22
/// Input:AdmId HIS就诊表ID
/// Output:Y表示有延检项目 空表示无
/// w ##Class(web.DHCPE.OrderPostPoned).GetPostPoneFlagByAdm("3310")
ClassMethod GetPostPoneFlagByAdm(AdmId)
{
	s ^tempdhcpe("GetPostPoneFlagByAdm",AdmId)=$lb(AdmId)
	s OEOrder=0
	s PostPoneFlag=""
	f  s OEOrder=$O(^OEORD(0,"Adm",AdmId,OEOrder))  q:((OEOrder=""))  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:((OEOrdItem="")||(PostPoneFlag="Y"))  d
	..s CRMOID=$O(^DHCPECRMO(0,"OEORI",OEOrder_"||"_OEOrdItem,""))
	..q:CRMOID=""
	..s CRMORI=$P(^DHCPECRMO(CRMOID),"^",2)
	..s PIOI=CRMORI
	..s PostPoneFlag=$p(^DHCPEPreIADM(+PIOI,"ORDITEM",$p(PIOI,"||",2)),"^",18)  //延迟标志   
	
	q PostPoneFlag
}

/// Descript:记录延检项目  用于重新生成报告
/// Input:
/// 			PAADM ：就诊ID
/// 			OEORI ：医嘱Id
/// 			DelayDate ：延期日期
/// Return:   	ret ID 和错误描述 -1表示失败
/// Creater:	wangguoying
/// CreateDate:	2020-10-15
/// Debug: w ##class(web.DHCPE.OrderPostPoned).DelayRecord("421","2022-01-28","N","393||3")
ClassMethod DelayRecord(PAADM, DelayDate, IfComplateAll As %String = "Y", OEORI As %String = "", UserID As %String = "")
{
	s:(OEORI="") items=..GetDelayItems(PAADM,"Y")
	s:(OEORI'="") items=OEORI
	q:items="" ""
	i DelayDate'=""  s DelayDate=##class(websys.Conversions).DateHtmlToLogical(DelayDate)
	s ret=0
	TS
	f i=1:1:$L(items,",")
	{
		s oeori=$p(items,",",i)
		s obj=""
		
		i $D(^User.DHCPEDelayRecordI("OEORIIndex"," "_oeori)) d
		.s id=$O(^User.DHCPEDelayRecordI("OEORIIndex"," "_oeori,0))
		.s obj=##class(User.DHCPEDelayRecord).%OpenId(id)
		e  d
		.s obj=##class(User.DHCPEDelayRecord).%New()
		.s obj.DRPAADM=PAADM
		.s obj.DROEORI=oeori
		.s obj.DRIfComplateAll=IfComplateAll
		.s obj.DRDate=DelayDate
		s obj.DRNoGenFlag=..NeddReGenerateReport(oeori)
		b
		s sc=obj.%Save()
		d obj.%Close()
		If ($System.Status.IsError(sc))	d
		.s ret="-1^"_$System.Status.GetErrorText(sc)
		else  d
		.s ret=obj.%Id()
		.d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","DelayItem",UserID,oeori) //延期插入日志
		q:($System.Status.IsError(sc))
		
	}
	TRO:(ret<0)
	TC:(ret>=0)
	q ret
}

ClassMethod NeddReGenerateReport(OEORI)
{
	s Flag="Y"
	i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORI)) s Flag="N"   //弃检项目)
	s itemStat=$p($G(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
	i (itemStat'=1)&&(itemStat'=6) s Flag="N"
	q Flag
}

/// Creater:	wangguoying
/// CreateDate:	2020-10-15
/// Descript:   获取可以延检项目
/// Input:	    PAADM(就诊ID)
/// Return:     OEOrdItem,OEOrdItem,……
/// Debug:  w ##class(web.DHCPE.OrderPostPoned).GetDelayItems()
ClassMethod GetDelayItems(PAADM, IDFlag As %String = "N")
{
	q:PAADM="" "[]"
	
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID)) //其他站点
	s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID)) //药品站点
	s RisStations=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))   //检查站点   
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))    //检验站点
	
	s retStr=""
	s OEOrder=0
	
	s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",PAADM,""))
	s Stations=""
	f  s OEOrder=$O(^OEORD(0,"Adm",PAADM,OEOrder)) q:(OEOrder="")  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem)) q:(OEOrdItem="")  d
	..s OEORIRowId=OEOrder_"||"_OEOrdItem
	..s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))   
	..q:CRMOId=""
	..s CRMOrI=$p($g(^DHCPECRMO(CRMOId)),"^",2)
	..q:CRMOrI=""
	..s ORIStat=$p($G(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
	..q:ORIStat'=1
	..q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))
	..s ItemMastId=$p($G(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",1)
	..q:ItemMastId=""
	..s Flag=1
	..s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID)
	..q:StatOrderDR=""
	..s StationDR=$P(StatOrderDR,"||",1)
	..q:(StationDR=MedStation)||(StationDR=OtherStation)
	..s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
	..q:(OEORILabEpisodeNo'="")&&($D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)))
	..q:($d(^User.DHCPEDelayRecordI("FlagADMOEORIIndex","Y",PAADM," "_OEORIRowId)))
	..i IDFlag="N" d
	...s ArcimDR=$p($g(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",2)
	...q:ArcimDR=""
	...s ArcDesc=$p($g(^ARCIM(+ArcimDR,1,1)),"^",2)
	...b:(ArcDesc["细菌培养")
	...s TreeObj=##class(web.DHCPE.HM.Entity.TreeRoot).%New()
	...s TreeObj.id=$p(OEORIRowId,"||",1)_"-"_$p(OEORIRowId,"||",2)
	...s TreeObj.text=ArcDesc
	...s RetJson=##class(ext.util.JsonObject).ObjToJson(TreeObj)
	...s:retStr'="" retStr=retStr_","_RetJson
	...s:retStr="" retStr=RetJson
	..e  d
	...i retStr'="" s retStr=retStr_","_OEORIRowId
	...e  s retStr=OEORIRowId
	i retStr'="" s retStr=retStr
	q:(IDFlag="N") "["_retStr_"]"
	q retStr
}

/// Descript:   取消延检项目 
/// Input:	    OEIDS ：医嘱Id串	
/// Return:   	ret ID 和错误描述 -1表示失败
/// Creater:	sunxintao
/// CreateDate:	2022-01-22
/// Debug: w ##class(web.DHCPE.OrderPostPoned).CancelDelay()
ClassMethod CancelDelay(OEIDS, UserID As %String = "")
{
	s ^tempdhcpe("CancelDelay")=$lb(OEIDS, UserID)
	TS
	s ret=0
	f i=1:1:$L(OEIDS,"^")
	{
		s oeori=$p(OEIDS,"^",i)
		s obj=""
		
		s id=$O(^User.DHCPEDelayRecordI("OEORIIndex"," "_oeori,0))
		s:(id="") ret="-1"
		q:(ret<0)
		s obj=##class(User.DHCPEDelayRecord).%OpenId(id)
		continue:obj.DRNoGenFlag="N"  //已重新生成了的或删除状态或弃检的
		s PAADM=obj.DRPAADM 
		s obj.DRNoGenFlag="N"
		s sc=obj.%Save()
		d obj.%Close()
		If ($System.Status.IsError(sc))	d
		.s ret="-1^"_$System.Status.GetErrorText(sc)
		else  d
		.s ret=obj.%Id()
		.d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CancelDelayItem",UserID,oeori) //撤销延期插入日志
		q:($System.Status.IsError(sc))
		
		
	}
	TRO:(ret<0)
	TC:(ret>=0)
	q ret
}

/// Descript: 取已经延期的项目
/// Debug:    w ##class(web.DHCPE.OrderPostPoned).GetHadDelayItems(3596)
ClassMethod GetHadDelayItems(PAADM)
{
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
	s OtherStation= $g(^DHCPESetting("DHCPE","StationId_Other",LocID)) //其他站点
	s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))  //药品站点
	s ret=""
	s OEOrdItem=""
	f  s OEOrdItem=$o(^User.DHCPEDelayRecordI("FlagADMOEORIIndex","Y",PAADM,OEOrdItem)) q:(OEOrdItem="")  d
	.s RealID=$replace(OEOrdItem," ","")
	.s ArcimDR=$p($g(^OEORD(+RealID,"I",$p(RealID,"||",2),1)),"^",2)
	.q:ArcimDR=""
	.s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimDR,LocID)
	.q:OrderID=""
	.s StationDR=$P(OrderID,"||",1)
	.q:(StationDR=MedStation)||(StationDR=OtherStation)
	.s ArcDesc=$p($g(^ARCIM(+ArcimDR,1,1)),"^",2)
	.s:(ret'="") ret=ret_","_ArcDesc
	.s:(ret="") ret=ArcDesc
	q ret
}

/// Creater:	wangguoying
/// CreateDate:	2020-10-15
/// Descript: 重新生成延检报告  挂任务用
/// 		  报告增加延检项目信息，不修改总检内容
/// Input:			
/// Return:   0
/// Debug: w ##class(web.DHCPE.OrderPostPoned).GenDelayReportTask()
ClassMethod GenDelayReportTask()
{
	s doctor=1 ;回传结果默认医生
	s $ZT="TaskErr"
	s adm=""
	f  s adm=$O(^User.DHCPEDelayRecordI("FlagADMOEORIIndex","Y",adm)) q:adm=""  d
	.d ##class(web.DHCPE.TransResult).TransMain(adm,doctor) //回传结果
	.d ##class(web.DHCPE.NetReport.Main).SetReportData(adm)
	q 0
TaskErr
	s $zt=""
	s ^DHCPETaskErr(+$H,$P($H,",",2))=$ZE
	q $ZE
}

}
