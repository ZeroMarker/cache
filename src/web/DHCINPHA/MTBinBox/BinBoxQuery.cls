/// Description:装箱操作查询相关
/// Creator:    hulihua
/// CreateDate: 2018-01-11
/// Table:      DHC_PHBox--物流箱
Class web.DHCINPHA.MTBinBox.BinBoxQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "" ]
{

/// Description:获取该装箱签的箱数用于C#循环打印的签数
/// Creator:	hulihua
/// CreateDate:	2017-04-26
/// Table:      DHC_PHBox
/// Input:		物流箱ID
/// Output:
/// Return：    该装箱签的箱数
/// Others:    
/// w ##class(web.DHCINPHA.MTBinBox.BinBoxQuery).GetPhBoxNum("4")
ClassMethod GetPhBoxNum(phbid As %String) As %String
{
	Q:phbid="" 0
	s PhbNum=$p(^DHCPHBOX(phbid),"^",2)
	Q PhbNum
}

/// Description:获取揭药室打印封箱签的条码号以及顺序号
/// Creator:	hulihua
/// CreateDate:	2018-12-21
/// Table:      DHC_PHBox
/// Input:		物流箱ID^序号
/// Output:
/// Return：    条码号^顺序号
/// Others:    
/// w ##class(web.DHCINPHA.MTBinBox.BinBoxQuery).GetPrintHMNumberAndNo("1#1")
ClassMethod GetPrintHMNumberAndNo(params As %String) As %String
{
	q:params="" ""
	s phbid=$p(params,"^",1)
	s PhBoxNumber=$p(params,"^",2)
	s PhbNo=$p(^DHCPHBOX(phbid),"^",1)
	s PhBoxNumber=$s(PhBoxNumber#2=0:PhBoxNumber\2,1:PhBoxNumber\2+1)
	s BarCode=PhbNo_PhBoxNumber
	s RetStr=BarCode_"^"_PhBoxNumber
	q RetStr
}

/// Description:获取揭药室装箱签的打印信息
/// Creator:	hulihua
/// CreateDate:	2018-01-11
/// Table:      DHC_PHBox、DHC_PHDraw
/// Input:		物流箱ID
/// Output:
/// Return：    箱号^箱信息^科室名称^封箱日期^药品品种数
/// Others:    
/// w ##class(web.DHCINPHA.MTBinBox.BinBoxQuery).GetPrintHMPhBoxInfoL("1#1")
ClassMethod GetPrintHMPhBoxInfoL(params As %String) As %String
{
	q:params="" ""
	s phbid=params
	s PhbNum=$p(^DHCPHBOX(phbid),"^",2)
	s PhLoc=$p(^DHCPHBOX(phbid),"^",15)
	s WardLocId=$p(^DHCPHBOX(phbid),"^",16)
	S WardCode=$p(^CTLOC(WardLocId),"^",51)
	i WardCode="" s WardCode=$p(^CTLOC(WardLocId),"^",2)
	s CreateDate=$p(^DHCPHBOX(phbid),"^",18)
	s CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate)
    s phmbid="",i=0,sumpocnum=0,sumjarnum=0
	f  s phmbid=$o(^DHCPHAMEDBi("WardLocPHBoxDr",WardLocId,phbid,phmbid))  q:phmbid=""  d
	.s prescNo=$p(^DHCPHAMEDB(phmbid),"^",4)
	.s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	.s prescFactor=$p(prescStr,"^",2)
	.s PreFormType=$p(prescStr,"^",8)
	.s jarnum=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOralPasteJarNum(prescNo)
	.s sumjarnum=sumjarnum+jarnum
	.s prescConfigSatr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetHMPrescConfig(prescNo)
	.s presAllSendFlag=$p(prescConfigSatr,"^",8)									
	.s phmbch=0
	.f  s phmbch=$o(^DHCPHAMEDBi("WardLocPHBoxDr",WardLocId,phbid,phmbid,phmbch))  q:phmbch=""  d
	..q:'$d(^DHCPHAMEDB(phmbid,"I",phmbch))
	..s BrothBatNo=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",17)
	..s UncovMedFlag=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",5)
	..q:UncovMedFlag'="Y"
	..s ActUncovMedPocNum=$s(jarnum'=0:0,1:+$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",7))
	..s sumpocnum=sumpocnum+ActUncovMedPocNum
	..s i=$s(presAllSendFlag="Y":i+prescFactor,1:i+1)										
	.
	s InciNum=$s(((sumpocnum'=0)&&(sumjarnum=0)):i_"付/"_sumpocnum_"袋",((sumpocnum=0)&&(sumjarnum'=0)):i_"付/"_sumjarnum_"罐",1:i_"付/"_sumpocnum_"袋+"_sumjarnum_"罐")
	S phboxid="",j=0
	F  S phboxid=$O(^DHCPHBOXi(0,"CreateDatePhLocWrad",+$h,PhLoc,WardLocId,phboxid))  Q:phboxid=""  D
	.S PhBoxUseFlag=$p(^DHCPHBOX(phboxid),"^",14)
	.Q:PhBoxUseFlag="Y"
	.S j=j+1
	
	S PbBoxNum=BrothBatNo
	s PbBoxInfo="/"_PhbNum_"箱--"_PbBoxNum_"批"
	S Data=PbBoxInfo_"^"_WardCode_"^"_CreateDate_"^"_InciNum
	Q Data
}

/// Description:获取封揭药室待发放的揭药箱列表
/// Creator:	hulihua
/// CreateDate:	2018-01-11
/// Table:      DHC_PHBox--物流箱
/// Input:
/// Output:		住院号、登记号、姓名、床号、处方号、揭药时间、揭药袋数、揭药人、转科之前病区、转科之后病区、子表ID
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.MTBinBox.BinBoxQuery).GetLeaseKitBoxList("50","1","01/01/2018^11/01/2018^127^102^")
ClassMethod GetLeaseKitBoxList(rows, page, params) As %String
{
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardLocId=$p(params,"^",3)
	s PhaLocId=$p(params,"^",4)
	s DispBoxFlag=$p(params,"^",5)
	s ScanFlag=$p(params,"^",6)
	s BarCode=$p(params,"^",7)		//揭药箱号
	i BarCode'="" d
	.i BarCode'["ZX"  d
	..s PhbBoxNo="ZX"_$e(BarCode,1,$l(BarCode)-1)
	.e  d
	..s PhbBoxNo=BarCode
	.s InPhBoxId=$o(^DHCPHBOXi("No",PhbBoxNo,""),-1)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTBinBox.BinBoxQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTBinBox.BinBoxQuery","GetLeaseKitBoxList",pid,"BOXNO")
	s n=0
	i BarCode'="" d
	.s PhBoxId=InPhBoxId
	.d SetTmpGlobal
	e  d
	.f Date=StartDate:1:EndDate d
	..i WardLocId="" d
	...s WardLoc=""
	...f  s WardLoc=$o(^DHCPHBOXi(0,"CreateDatePhLocWrad",Date,PhaLocId,WardLoc)) q:WardLoc=""  d
	....s PhBoxId=""
	....f  s PhBoxId=$o(^DHCPHBOXi(0,"CreateDatePhLocWrad",Date,PhaLocId,WardLoc,PhBoxId))  q:PhBoxId=""  d
	.....d SetTmpGlobal
	....
	...
	..e  d
	...;选择了病区的情况
	...s PhBoxId=""
	...f  s PhBoxId=$o(^DHCPHBOXi(0,"CreateDatePhLocWrad",Date,PhaLocId,WardLocId,PhBoxId))  q:PhBoxId=""  d
	....d SetTmpGlobal
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
 	i End>n s End=n
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(n,rows) //输出json前缀串
	s count=0
	s Index=""
	f  s Index=$o(^TMP("DHCINPHA","web.DHCINPHA.MTBinBox.BinBoxQuery","GetLeaseKitBoxList",pid,"BOXNO",Index)) q:Index=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTBinBox.BinBoxQuery","GetLeaseKitBoxList",pid,"BOXNO",Index)
	.s count = count+1
	.s Title1="TPhboxId^TPhbStatus^TPhBoxNo^TPhBoxNum^TLocDesc"
	.s Title2="TUserCreate^TDateCreate^TUserPhHand^TDatePhHand^TUserLogistics"
	.s Title3="TRemark"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTBinBox.BinBoxQuery","GetLeaseKitBoxList",pid,"BOXNO")
	q ""	
SetTmpGlobal
	q:(PhBoxId="")||('$d(^DHCPHBOX(PhBoxId)))
	s PhbNoUseFlag=$p(^DHCPHBOX(PhBoxId),"^",14)
	q:PhbNoUseFlag="Y"									;作废的过滤
	s PhbStatus=$p(^DHCPHBOX(PhBoxId),"^",13)
	q:(DispBoxFlag="N")&&(ScanFlag="N")&&(PhbStatus'="20") ;不是扫码完成的不发放
	q:(DispBoxFlag="Y")&&(PhbStatus<"60")
	q:(ScanFlag="Y")&&(PhbStatus'="10")				
	s PhbStatus=$s(PhbStatus="10":"封箱完成",PhbStatus="20":"扫码完成",PhbStatus="60":"揭药箱已发放",PhbStatus="70":"物流交接完成",1:"")
	s PhBoxNo=$p(^DHCPHBOX(PhBoxId),"^",1)
	s PhBoxNum=$p(^DHCPHBOX(PhBoxId),"^",2)
	s TLocId=$p(^DHCPHBOX(PhBoxId),"^",16)
	s TLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(TLocId),"^",2)
	s UserCreateDr=$p(^DHCPHBOX(PhBoxId),"^",17)
	s UserCreate=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(UserCreateDr),"^",2)
	s DateCreate=$p(^DHCPHBOX(PhBoxId),"^",18)
	s DateCreate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateCreate)
	s TimeCreate=$p(^DHCPHBOX(PhBoxId),"^",19)
	s TimeCreate=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeCreate)
	s DateCreate=DateCreate_" "_TimeCreate
	s UserPhHandDr=$p(^DHCPHBOX(PhBoxId),"^",3)
	s UserPhHand=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(UserPhHandDr),"^",2)
	s DatePhHand=$p(^DHCPHBOX(PhBoxId),"^",4)
	s DatePhHand=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DatePhHand)
	s TimePhHand=$p(^DHCPHBOX(PhBoxId),"^",5)
	s TimePhHand=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimePhHand)
	s:DatePhHand'="" DatePhHand=DatePhHand_" "_TimePhHand
	s UserLogisticsDr=$p(^DHCPHBOX(PhBoxId),"^",6)
	s UserLogistics=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(UserLogisticsDr),"^",2)
	s Remark=$p(^DHCPHBOX(PhBoxId),"^",20)
	s n=n+1
	s Index=PhBoxId
	s Data1=PhBoxId_"^"_PhbStatus_"^"_PhBoxNo_"^"_PhBoxNum_"^"_TLocDesc
	s Data2=UserCreate_"^"_DateCreate_"^"_UserPhHand_"^"_DatePhHand_"^"_UserLogistics
	s Data3=Remark
	s ^TMP("DHCINPHA","web.DHCINPHA.MTBinBox.BinBoxQuery","GetLeaseKitBoxList",pid,"BOXNO",Index)=Data1_"^"_Data2_"^"_Data3
	q
}

/// Description:保存揭药箱发放信息
/// Creator:	hulihua
/// CreateDate:	2018-01-11
/// Table:      DHC_PHBox--物流箱
/// Input:
/// Output:		揭药箱主表ID^发放人ID^物流人员ID
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.MTBinBox.BinBoxQuery).GetLeaseKitBoxList("50","1","01/01/2018^11/01/2018^127^102^")
ClassMethod SaveDispBoxData(PhBoxIdStr, UserId, LogisticsId, DispLocId) As %String
{
	q:UserId="" -1
	q:LogisticsId="" -2
	s HospId=$p($g(^CTLOC(DispLocId)),"^",22)
	s Params="^"_DispLocId_"^"_UserId_"^"_HospId
	s ParamPropStr=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetParamProp(Params)
	s InvokPatchFlag=$p(ParamPropStr,"^",6)
	s PatchProCodeStr=$p(ParamPropStr,"^",7)
	s len=$l(PhBoxIdStr,"&&")
	s Ret=0
	f i=1:1:len	d
	.s PhBoxId=$p(PhBoxIdStr,"&&",i)
	.s PhbStatus=$p(^DHCPHBOX(PhBoxId),"^",13) 
	.q:PhbStatus'="20" 
	.s PhbNoUseFlag=$p(^DHCPHBOX(PhBoxId),"^",14)
	.q:PhbNoUseFlag="Y" 
	.s SqlStr=PhBoxId_"^"_UserId_"^"_LogisticsId
	.s Ret=##Class(web.DHCINPHA.MTBinBox.SqlDbBinBox).UpdateBoxData(SqlStr)
	.//以下为调用配送接口
	.i (InvokPatchFlag="Y")&&(PatchProCodeStr'="")  d
	..s ProCodeLen=$L(PatchProCodeStr,"&")
	..f j=1:1:ProCodeLen  d
	...s PatchProCode=$p(PatchProCodeStr,"&",j)
	...s ProjectID=$o(^DHCDISLI(0,"Code",$$ALPHAUP^SSUTIL4(PatchProCode),""),-1)
	...q:ProjectID=""
	...d ##class(web.DHCSTInterfacePH).SendToDispatch(PhBoxId,ProjectID)
	..
	.
	q Ret
}

/// Description:扫描保存揭药箱的暂存信息
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table: 		DHC_PHBox--物流箱     
/// Input:		BarCode--物流箱条码
/// Output:		
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.MTBinBox.BinBoxQuery).SaveBoxBarData("50")
ClassMethod SaveBoxBarData(BarCode) As %String
{
	s $zt="PSC"
	q:BarCode="" -1
	i BarCode'["ZX"  d
	.s PhbBoxNo="ZX"_$e(BarCode,1,$l(BarCode)-1)
	e  d
	.s PhbBoxNo=BarCode
	s PhBoxId=$o(^DHCPHBOXi("No",PhbBoxNo,""),-1)
	q:PhBoxId="" -2 
	s SqlStr=PhBoxId_"^20"
	s Ret=##Class(web.DHCINPHA.MTBinBox.SqlDbBinBox).SaveBoxBarDataDb(SqlStr)
	q:Ret'=0 Ret
	s TLocId=$p(^DHCPHBOX(PhBoxId),"^",16)
	s WardLoc=$s(TLocId'="":$p(^CTLOC(TLocId),"^",87),1:"")
	s PhBoxNum=$p(^DHCPHBOX(PhBoxId),"^",2)
	s Ret=WardLoc_",共"_PhBoxNum_"箱"
	q Ret
PSC 
	w $ze
	q
}

Storage Default
{
<Data name="BinBoxQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHA.M810B.BinBoxQueryD</DataLocation>
<DefaultData>BinBoxQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPHA.M810B.BinBoxQueryD</IdLocation>
<IndexLocation>^web.DHCINPHA.M810B.BinBoxQueryI</IndexLocation>
<StreamLocation>^web.DHCINPHA.M810B.BinBoxQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
