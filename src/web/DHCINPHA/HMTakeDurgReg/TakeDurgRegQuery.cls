/// Description:住院草草药领取登记查询相关
/// Creator:    hulihua
/// CreateDate: 2017-08-02
/// Table:      DHC_PHACollected-住院发药主表
Class web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询所有已发但还未登记的处方病区列表
/// Creator:	hulihua
/// CreateDate:	2017-08-07
/// Table:      DHC_PHACollected
/// Input:		每页行数、页数、开始日期^开始时间^截至日期^截至时间^发药科室
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery).GetDurgRegWardList("1","50","09/07/2017^^10/08/2017^^88")
ClassMethod GetDurgRegWardList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s PhaLoc=$p(params,"^",5)
	s ChkRegFlag=$p(params,"^",6)
	s LogUserId=$p(params,"^",7)
	s WardIdStr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLogWardStrByUserId(LogUserId)
	q:WardIdStr="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetDurgRegWardList",pid)
	s n=0
	s WardLen=$l(WardIdStr,",")
	f j=1:1:WardLen d
	.s wardid=$p(WardIdStr,",",j)
	.f Date=StartDate:1:EndDate d
	..s phac=""
	..f  s phac=$o(^DHCPHAC(0,"DATEWARD",PhaLoc,Date,wardid,phac)) q:phac=""  d
	...q:$d(^TMP("DHCINPHA","web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetDurgRegWardList",pid,"WARD",wardid))
	...s auditflag=$p(^DHCPHAC(phac),"^",25)
	...q:auditflag'=ChkRegFlag
	...s prescNo=$p($g(^DHCPHAC(phac,1)),"^",1) 
	...s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	...s CookType=$p(prescStr,"^",7)
	...q:CookType'["自煎"
	...s n=n+1
	...s ^TMP("DHCINPHA","web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetDurgRegWardList",pid,"WARD",wardid)=""
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串

	s count=0
	s wardid=""
	f  s wardid=$o(^TMP("DHCINPHA","web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetDurgRegWardList",pid,"WARD",wardid)) q:wardid=""  d
	.s ward=$p(^PAWARD(wardid),"^",2)
	.s mdata=wardid_"^"_ward
	.s count = count+1
	.s Title="TWardId^TWard"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetDurgRegWardList",pid)
	q ""
}

/// Description:获取某病区需要登记的所有处方信息
/// Creator:	hulihua
/// CreateDate:	2017-08-08
/// Table:      DHC_PHACollected
/// Input:		每页行数、页数、开始日期^开始时间^截至日期^截至时间^发药科室
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery).GetWardPrescnoList("1","50","15/06/2017^^21/11/2017^^96^9")
ClassMethod GetWardPrescnoList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s PhaLoc=$p(params,"^",5)
	s ChkRegFlag=$p(params,"^",6)
	s WardId=$p(params,"^",8)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetWardPrescnoList",pid)
	s n=0
	f Date=StartDate:1:EndDate d
	.s phac=""
	.f  s phac=$o(^DHCPHAC(0,"DATEWARD",PhaLoc,Date,WardId,phac))  q:phac=""  d
	..s auditflag=$p(^DHCPHAC(phac),"^",25)
	..q:auditflag'=ChkRegFlag
	..s Statue=$s(auditflag="Y":"已登记",1:"")
	..s CollectUser=$p(^DHCPHAC(phac),"^",13)		//发药人
	..s CollectUserName=$s(CollectUser'="":$p($G(^SSU("SSUSR",CollectUser)),"^",2),1:"")	
	..s CollectDate=$p(^DHCPHAC(phac),"^",2)		//发药日期
	..s CollectDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CollectDate)
	..s CollectTime=$p(^DHCPHAC(phac),"^",3)		//发药时间
	..s CollectTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CollectTime)
	..s phacsub=$o(^DHCPHAC(phac,"I",""),-1)
	..s admDr=$p(^DHCPHAC(phac,"I",phacsub),"^",3)
	..s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	..s PatNo=$p(patInfo,"^",1)
	..s PatName=$p(patInfo,"^",3)
	..s PatSex=$p(patInfo,"^",4)
	..s PameNo=$p(patInfo,"^",12)
	..s prescNo=$p($g(^DHCPHAC(phac,1)),"^",1) 
	..s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	..s Instruc=$p(prescStr,"^",1)
	..s Factor=$p(prescStr,"^",2)
	..s Note=$p(prescStr,"^",6)
	..s CookType=$p(prescStr,"^",7)
	..q:CookType'["自煎"
	..s Data1=prescNo_"^"_Instruc_"^"_Factor_"^"_CookType_"^"_Note
	..s Data2=PatNo_"^"_PameNo_"^"_PatName_"^"_PatSex_"^"_CollectUserName
	..s Data3=CollectDate_"^"_CollectTime_"^"_phac_"^"_Statue
	..s index=PatNo_","_prescNo
	..s n=n+1
	..s ^TMP("DHCINPHA","web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetWardPrescnoList",pid,"Prescno",index)=Data1_"^"_Data2_"^"_Data3
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA","web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetWardPrescnoList",pid,"Prescno",index)) q:index=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetWardPrescnoList",pid,"Prescno",index)
	.s count = count+1
	.s mdata=mdata_"^"_count
	.s Title1="TPrescNo^TInstruc^TFactor^TCookType^TNote"
	.s Title2="TPatNo^TPameNo^TPatName^TPatSex^TCollectUserName"
	.s Title3="TCollectDate^TCollectTime^TPhac^TStatue^TCount"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetWardPrescnoList",pid)
	q ""
}

/// Description:扫描条码获取发药表处方相关信息
/// Creator:	hulihua
/// CreateDate:	2018-01-17
/// Table:      
/// Input:		barcode-条码号
/// Output:		
/// Return：	处方号、登记号、姓名、性别、年龄、用法、付数、煎药方式、开方科室
/// Others: 
/// w ##class(web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery).GetPhaPrescByBarCode("1I18011705336")
ClassMethod GetPhaPrescByBarCode(barcode As %String, logonLocId As %String = "") As %String
{
	n (barcode,logonLocId)
	S prescNo=$s($F(barcode,$c(16)):$p(barcode,$c(16),2),1:barcode)
	Q:prescNo="" -1
	S ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	Q:ord="" -2
	S phac=$O(^DHCPHAC(0,"Prescno",prescNo,""),-1)
	Q:phac="" -3
	s logonHospId=$p($g(^CTLOC(+logonLocId)),"^",22)	//登录院区
	s recLocId=+$p($g(^DHCPHAC(phac)),"^",1)				//发药科室
	s prescHospId=$p($g(^CTLOC(+recLocId)),"^",22)
	q:(logonHospId'="")&&(logonHospId'=prescHospId) -11
	S phacsub=$o(^DHCPHAC(phac,"I",""),-1)
	Q:phacsub="" -4
	S auditflag=$p(^DHCPHAC(phac),"^",25)
	Q:auditflag="Y" -5
	Q:(##class(PHA.COM.Order).ChkIfRetCYPre(prescNo)=1) -6
	S Statue=$s(auditflag="Y":"已登记",1:"")
	S CollectUser=$p(^DHCPHAC(phac),"^",13)		//发药人
	S CollectUserName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(CollectUser),"^",2)	
	S CollectDate=$p(^DHCPHAC(phac),"^",2)		//发药日期
	S CollectDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CollectDate)
	S CollectTime=$p(^DHCPHAC(phac),"^",3)		//发药时间
	S CollectTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CollectTime)
	S:CollectDate'="" CollectDate=CollectDate_" "_CollectTime
	S admDr=$p(^OEORD(ord),"^",1)
	S patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	S PatNo=$p(patInfo,"^")
	S PatName=$p(patInfo,"^",3)
	S PatSex=$p(patInfo,"^",4)
	S PatAge=$p(patInfo,"^",5)
	S prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	S Instruc=$p(prescStr,"^")
	S Factor=$p(prescStr,"^",2)
	S CoookType=$p(prescStr,"^",7)
	s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	S DoctorLoc=$p(preOrdStr,"^",1)
	S DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	S ResutStr1=prescNo_DataDelim_PatNo_DataDelim_PatName_DataDelim_PatSex_DataDelim_PatAge
	S ResutStr2=Instruc_DataDelim_Factor_DataDelim_CoookType_DataDelim_DoctorLoc_DataDelim_Statue
	S ResutStr3=CollectUserName_DataDelim_CollectDate_DataDelim_phac
	S ResutStr=ResutStr1_DataDelim_ResutStr2_DataDelim_ResutStr3
	Q ResutStr
}

/// Description:草药登记表结构处理
/// Creator:	hulihua
/// CreateDate:	2017-08-09
/// Table:      DHC_PHACollected
/// Input:		发药主表ID
/// Output:
/// Return：    0-成功，非0-失败
/// Others:    
/// w ##class(web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery).SavePreReg("284^6")
ClassMethod SavePreReg(params) As %String
{
	n (params)
	s phac=$p(params,"^",1)
	q:phac="" "-1^未发药！"
	s reguserid=$p(params,"^",2)
	s prescno=$p(params,"^",3)
	q:(reguserid="")||('$d(^SSU("SSUSR",reguserid))) "-2^登记人不存在或为空！"
	s phacauditdate=+$h
	s phacaudittime=$p($h,",",2)
	s phacauditflag="Y"
	s auditflag=$p(^DHCPHAC(phac),"^",25)
	q:auditflag="Y" "-3^该处方已领取！"
	Q:(##class(PHA.COM.Order).ChkIfRetCYPre(prescno)=1) "-5^该处方已退药！"
	s listdata=phac_"^"_phacauditflag_"^"_phacauditdate_"^"_phacaudittime_"^"_reguserid
	s err=##class(web.DHCINPHA.MTNurseCheck.SqlDbPhacAuitCheck).UpdateAuditInfo(listdata)
	q:err<0 "-4^处理表结构失败！"
	;草药处方需要插入处方追踪信息！
	s phacloc=$p(^DHCPHAC(phac),"^",1)
	s SqlStr="^^"_prescno_"^C14^"_phacloc_"^"_reguserid
	d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
	q 0
}

Storage Default
{
<Data name="TakeDurgRegQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINP1C9D.TakeDurgReg9EB5D</DataLocation>
<DefaultData>TakeDurgRegQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINP1C9D.TakeDurgReg9EB5D</IdLocation>
<IndexLocation>^web.DHCINP1C9D.TakeDurgReg9EB5I</IndexLocation>
<StreamLocation>^web.DHCINP1C9D.TakeDurgReg9EB5S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
