/// Description:手工记录工作量查询相关
/// Creator:    hulihua
/// CreateDate: 2017-11-29
/// Table:      
Class web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:扫面条码获取处方相关信息
/// Creator:	hulihua
/// CreateDate:	2017-11-29
/// Table:      
/// Input:		barcode-条码号，status-记录状态
/// Output:		
/// Return：	处方号、登记号、姓名、性别、年龄、用法、付数、煎药方式、开方科室
/// Others: 
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery).GetPrescByBarCode("I190117000010","调剂")
ClassMethod GetPrescByBarCode(barcode As %String, status As %String) As %String
{
	n (barcode,status)
	S DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s prescNo=$s($F(barcode,$c(16)):$p(barcode,$c(16),2),1:barcode)
	q:prescNo="" -1_DataDelim_"处方号为空!"
	s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	q:ord="" -2_DataDelim_"该处方不存在!"
	S phac=$O(^DHCPHACi("PRESCNO",prescNo,""),-1)
	Q:phac="" -3_DataDelim_"该处方还未到药房!"
	S phacsub=$o(^DHCPHAC(phac,"I",""),-1)
	Q:phacsub="" -4_DataDelim_"该处方发药有问题!"
	S SendMedNum=+$p(^DHCPHAC(phac),"^",23)
	S PrintFlag=+$p(^DHCPHAC(phac),"^",16)
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	S PrescForm=$p(prescStr,"^",8)
	S CoookType=$p(prescStr,"^",7)
	Q:(status'["调剂")&&((PrescForm["颗粒剂")||(PrescForm["袋装饮片")||(CoookType["自煎")) -7_DataDelim_"该类型处方不能记录煎药工作量!"
	S ExitRetInfo=""
	I status["调剂"  D
	.S Operator=$p(^DHCPHAC(phac),"^",5)
	.S Operator=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(Operator),"^",2)
	.S OperatorDate=$p(^DHCPHAC(phac),"^",18)
	.S OperatorDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(OperatorDate)
	.S OperatorTime=$p(^DHCPHAC(phac),"^",19)
	.S OperatorTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OperatorTime)
	.S:(Operator'="")&&(OperatorDate'="")&&(OperatorTime'="") ExitRetInfo=-6_DataDelim_Operator_" "_OperatorDate_" "_OperatorTime
	E  D
	.S Type=$s($F(prescNo,"I"):"I",1:"O")
	.S MbcId=$o(^DHCMBC(0,"PRESCNO",prescNo,""),-1)
	.Q:MbcId=""
	.S StateDr=$o(^DHCMBCS(0,"TYPENAME",Type,status,""),-1)
	.Q:StateDr=""
	.S MbciCh=$o(^DHCMBC(0,"ITMSTATE",StateDr,MbcId,""),-1)
	.Q:MbciCh=""
	.S MbciUser=$p(^DHCMBC(MbcId,"I",MbciCh),"^",1)
	.S MbciUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(MbciUser),"^",2)
	.S MbciDate=$p(^DHCMBC(MbcId,"I",MbciCh),"^",2)
	.S MbciDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(MbciDate)
	.S MbciTime=$p(^DHCMBC(MbcId,"I",MbciCh),"^",3)
	.S MbciTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(MbciTime)
	.S:(MbciUser'="")&&(MbciDate'="")&&(MbciTime'="") ExitRetInfo=-6_DataDelim_MbciUser_" "_MbciDate_" "_MbciTime
	Q:ExitRetInfo'="" ExitRetInfo
	S Instruc=$p(prescStr,"^")
	S Factor=$p(prescStr,"^",2)
	S admDr=$p(prescStr,"^",27)
	s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	S PatNo=$p(patInfo,"^")
	S PatName=$p(patInfo,"^",3)
	S PatSex=$p(patInfo,"^",4)
	S PatAge=$p(patInfo,"^",5)
	S preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	S DoctorLoc=$p(preOrdStr,"^",1)
	S ResutStr1=prescNo_DataDelim_PatNo_DataDelim_PatName_DataDelim_PatSex_DataDelim_PatAge
	S ResutStr2=Instruc_DataDelim_Factor_DataDelim_CoookType_DataDelim_DoctorLoc
	S ResutStr=ResutStr1_DataDelim_ResutStr2
	Q ResutStr
}

/// Description:保存界面扫描的工作量信息
/// Creator:	hulihua
/// CreateDate:	2017-11-29
/// Table:      DHC_PHACollected--发药主表
/// Input:		prescNo-处方号、Status-煎药状态、RecordUserId-记录人ID
/// Output:
/// Return： 	0-成功、小于0-失败  
/// Others:							
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery).SaveRecordWorkLoad("I17112800002","包装","dthealth")
ClassMethod SaveRecordWorkLoad(PrescNo As %String, Status As %String, RecordUserId As %String) As %String
{
	N (PrescNo,Status,RecordUserId)
	//s ^hlh($h)=$lb(PrescNo,Status,UserCode)
	Q:PrescNo="" "-1^该处方号有误！"
	Q:Status="" "-2^未选择煎药状态！"
	Q:(RecordUserId="")||('$d(^SSU("SSUSR",RecordUserId))) "-3^记录人为空或不存在！"
	S Type=$S($F(PrescNo,"I"):"I",1:"O")
	I Type="I"  D
	.S DispId=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPhacByPres(PrescNo)
	E  D
	.S DispId=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	Q:DispId="" "-4^该处方还未发药！"
	S SqlStr=Type_"^"_DispId_"^"_Status_"^"_RecordUserId
	I Status="调剂" D
	.s ret=##class(web.DHCINPHA.HMRecordWorkLoad.SqlDbRecordWorkLoad).SaveAdjustorData(SqlStr)
	E  D
	.S ret=##class(web.DHCINPHA.HMRecordWorkLoad.SqlDbRecordWorkLoad).SaveMBCData(SqlStr)
	Q ret
}

/// Description:保存状态暂存信息
/// Creator:	hulihua
/// CreateDate:	2017-11-30
/// Table:      
/// Input:		DecConid-煎药状态ID、Status-煎药状态、UserCode-工号
/// Output:		^DHCINPHATMP("DHCINPHA",$this,"SaveTempStatus",UserCode)
/// Return： 	0-成功、小于0-失败  
/// Others:							
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery).SaveRecordWorkLoad()
ClassMethod SaveTempStatus(DecConid As %String, Status As %String, UserCode As %String) As %String
{
	N (DecConid,Status,UserCode)
	Q:DecConid="" "-1^该处方号有误！"
	Q:Status="" "-2^未选择煎药状态！"
	Q:UserCode="" "-3^记录工号为空！"
	S ^DHCINPHATMP("DHCINPHA",$this,"SaveTempStatus",UserCode)=DecConid_"^"_Status
	Q 0
}

/// Description:按照工号获取状态暂存信息
/// Creator:	hulihua
/// CreateDate:	2017-11-30
/// Table:      
/// Input:		UserCode-工号
/// Output:		
/// Return： 	状态ID、状态描述  
/// Others:							
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery).SaveRecordWorkLoad()
ClassMethod GetTempStatus(UserCode As %String) As %String
{
	N (UserCode)
	S DecCondStr=$G(^DHCINPHATMP("DHCINPHA",$this,"SaveTempStatus",UserCode))
	Q DecCondStr
}

/// Description:查询日期段内手工记录的工作量列表
/// Creator:	hulihua
/// CreateDate:	2018-03-01
/// Table:      DHC_PHACollected、DHC_PHDISPEN
/// Input:		每页行数、页数、开始日期^截至日期^药房科室ID^状态描述
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery).GetRecordWorkList("1","50","2018-11-13^2018-11-20^310^病区接收^4638")
ClassMethod GetRecordWorkList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=500
	s End = page*rows
	s Start=(page-1)*rows+1
	S DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s StartDate=$p(params,DataDelim,1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,DataDelim,2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhLocId=$p(params,DataDelim,3)
	s Status=$p(params,DataDelim,4)
	s gUserID=$p(params,DataDelim,5)
	k ^TMP("DHCINPHA",$this,"GetRecordWorkList","USERWORD",gUserID)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetRecordWorkList",pid,"RecordWork")
	s n=0,faccount=0
	f Date=StartDate:1:EndDate d
	.i Status="调剂" D
	..s phac=""
	..f  s phac=$o(^DHCPHACi("PHALocOperDate",PhLocId,Date,phac))  q:phac=""  d
	...s PhaDataSource=+$p(^DHCPHAC(phac),"^",35)
	...q:PhaDataSource=0		;界面刷卡
	...S OperatorDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"IP")
	...S OperatorTime=$p(^DHCPHAC(phac),"^",19)
	...s OperatorTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OperatorTime,"IP")
	...s OperatorDate=OperatorDate_" "_OperatorTime
	...s prescNo=$p(^DHCPHAC(phac,1),"^",1)
	...s Operator=$p(^DHCPHAC(phac),"^",5)
	...//q:(gUserID'="")&&(gUserID'=Operator)
	...S Operator=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(Operator),"^",2)
	...d SetTMPGlobal
	..
	.e  d
	..s TypeStr="I^O"
	..s TypeLen=$l(TypeStr,"^")
	..f i=1:1:TypeLen  d
	...s Type=$p(TypeStr,"^",i)
	...s statedr=$o(^DHCMBCS(0,"TYPENAME",Type,Status,""),-1)
	...q:statedr=""
	...s Mbc=""
	...f  s Mbc=$o(^DHCMBC(0,"DATESTATE",Date,statedr,Mbc)) q:Mbc=""  d
	....s prescNo=$p(^DHCMBC(Mbc),"^",1)
	....s Mbchl=$o(^DHCMBC(0,"DATESTATE",Date,statedr,Mbc,""),-1) 
	....s DataSource=+$p(^DHCMBC(Mbc,"I",Mbchl),"^",8)
	....//q:DataSource=0
	....S OperatorDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"IP")
	....S OperatorTime=$p(^DHCMBC(Mbc,"I",Mbchl),"^",3)
	....s OperatorTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OperatorTime,"IP")
	....s OperatorDate=OperatorDate_" "_OperatorTime
	....s Operator=$p(^DHCMBC(Mbc,"I",Mbchl),"^",1)
	....//q:(gUserID'="")&&(gUserID'=Operator)
	....s Operator=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(Operator),"^",2)
	....d SetTMPGlobal
	...
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	s TxtStr=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(gUserID),"^",2)_"在该段时间"_Status_n_"张,"_faccount_"付"
	s ^TMP("DHCINPHA",$this,"GetRecordWorkList","USERWORD",gUserID)=TxtStr
	s Title1="TPrescNo^TFactor^TPrescNoCount^TCoookType^TOperatorDate"
	s Title2="TOperator^TPrescForm"
	s Title=Title1_"^"_Title2
	s Index="",count=0
	f  s Index=$o(^TMP("DHCINPHA",$this,"GetRecordWorkList",pid,"RecordWork",Index))  q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"GetRecordWorkList",pid,"RecordWork",Index)
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
   	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetRecordWorkList",pid,"RecordWork")
	q ""	
SetTMPGlobal
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	S Factor=$p(prescStr,"^",2)
	S faccount=faccount+Factor
	S CoookType=$p(prescStr,"^",7)
	S PrescForm=$p(prescStr,"^",8)
	s PrescNoCount=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPrescNoCount(prescNo)
	s n=n+1
	s Data1=prescNo_"^"_Factor_"^"_PrescNoCount_"^"_CoookType_"^"_OperatorDate
	s Data2=Operator_"^"_PrescForm
	s ^TMP("DHCINPHA",$this,"GetRecordWorkList",pid,"RecordWork",n)=Data1_"^"_Data2
}

/// Description:获取已记录的工作量信息用于前台提示
/// Creator:	hulihua
/// CreateDate:	2018-04-24
/// Table:      
/// Input:		
/// Output:		
/// Return：	   
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery).GetRecordInfo()	
ClassMethod GetRecordInfo(gUserID As %String) As %String
{
	N (gUserID)
	Q $G(^TMP("DHCINPHA",$this,"GetRecordWorkList","USERWORD",gUserID))
}

}
