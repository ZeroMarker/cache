Import SQLUser

Class web.DHCPE.Public.Setting Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// d ##class(web.DHCPE.Public.Setting).Initial()

ClassMethod Initial()
{
	;^DHCPESetting("DHCPE","CancelPEType",CurLoc)
	////以下中的263是一个科室代码
	//到达时是否判断预约时间
	Set ^DHCPESetting("DHCPE","BookDateLimit")="No"
	//可以找零的支付方式
	Set ^DHCPESetting("DHCPE","CanChangePayModes")="1,2"
	//是否四舍五入
	Set ^DHCPESetting("DHCPE","RoundManager")="N"
	//登记号是否和就诊卡关联
	Set ^DHCPESetting("DHCPE","CardRelate")="Yes"
	//收费时其他支付方式现金找零最大的金额
	Set ^DHCPESetting("DHCPE","CashierMin")="100"
	//默认视同收费的模式 0：都不默认  1：个人视同收费 2：团体视同收费 3：都视同收费
	Set ^DHCPESetting("DHCPE","CashierSystem",263)="3"
	//设置医生界面^打印条码是否自动到达^到达界面读卡自动到达   Y为自动到达
	Set ^DHCPESetting("DHCPE","AutoArrived",263)="Y^Y^Y"
	//调用的接口类  不用修改
	Set ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"
	//默认的病人类型、性别   自费^男^男^女  CT_SocialStatus  CT_Sex
	Set ^DHCPESetting("DHCPE","DefPatientType")="1^1^1^2"
	//一个体检病人的PAADM 一开始设置为空即可
	Set ^DHCPESetting("DHCPE","DefaultPAADM",263)=""
	//团体报告中是统计诊断还是疾病   以及打印的建议是疾病的建议还是诊断的建议  维护诊断时是否需要关联疾病
	//Y为疾病  N为诊断
	Set ^DHCPESetting("DHCPE","GRDiagnosisType")="N^N^Y"
	//体检费, 团体对应的ADM的医嘱项Id ,  用于对团体进行收费 自定义价格 文件中的PE009
	Set ^DHCPESetting("DHCPE","Group'sOEArcItemId")="13343||1"
	//当前团体编码从何处开始
	Set ^DHCPESetting("DHCPE","GroupPatNO_Begin")="00000000"
	//
	s ^DHCPESetting("DHCPE","GroupPatNO_CurNo")=""
	//体检用到的医院代码，如果下面报告代码没设置，打印报告的csp也和此代码有关
	Set ^DHCPESetting("DHCPE","HospitalCode")="SHDF"
	//医院名称
	Set ^DHCPESetting("DHCPE","HospitalName")="上海东方医院"
	//预约人员的状态 一般不需要修改
	Set ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
	//发票中打印的列数
	Set ^DHCPESetting("DHCPE","InvCol")="2"
	//打印发票的明细的格式：(1:ItemName_"^"_ItemPrice_"^"_qty_"^"_FactAmount 2:ItemName_"^"_Uom_"^"_qty_"^"_FactAmount 3:ItemName_"^"_Uom_"^"_qty_"^"_ItemPrice_"^"_FactAmount)
	Set ^DHCPESetting("DHCPE","InvColSortType")="3"
	//发票打印默认医瞩项  比如体检费、检查费等对应的医嘱项
	Set ^DHCPESetting("DHCPE","InvDefaulltFee")="13343||1"
	//默认支付方式
	Set ^DHCPESetting("DHCPE","InvDefaultPayMode")="1"
	//发票标志区别,友谊用N,复兴用空,其他用Y
	Set ^DHCPESetting("DHCPE","InvFlag")="Y"
	//打印发票时是否打印明细  1  打印  0 不打印
	Set ^DHCPESetting("DHCPE","InvListFlag")="0"
	//单张发票打印明细的最大数量
	Set ^DHCPESetting("DHCPE","InvMaxListCount")="24"
	//是否打印费用类别 统计发票中对应的化验费、检查费等具体
	Set ^DHCPESetting("DHCPE","InvPrintCatInfo")="Y"
	//设置不打印条码的医嘱  一般不设置  ARC_ItmMast1^ARC_ItmMast2
	Set ^DHCPESetting("DHCPE","NoCodeLabItem")=""
	//不打印报告的站点
	Set ^DHCPESetting("DHCPE","NoReportStation")=""
	//厦门家族史等对应的细项5||1^5||2^5||3
	Set ^DHCPESetting("DHCPE","ODStr")=""
	//NoGen---预先不生成号段(登记号)(安贞) Gen---预先生成号段(友谊) FreeCreate--只有录入登记号(华山)
	Set ^DHCPESetting("DHCPE","PAPMINo_GenModel")="NoGen"
	//体检医嘱套Code的前缀
	Set ^DHCPESetting("DHCPE","PEItemCodePrefix")="PE"
	//体检客户的公费类型   好像就没使用到
	Set ^DHCPESetting("DHCPE","PEPatType")="公费"
	//下面两个暂时还没有医院使用
	//使用前首先根据导检单的顺序设置一个字符串s ^DHCPESetting("DHCPE","PatItemSort")="1^1&2^2&3^3&4^4@4"
	//   1^1   导检单打印顺序ID^打印顺序   @4每隔多少人变化
	Set ^DHCPESetting("DHCPE","PatItemSort")=""
	//当前导检单的打印顺序
	Set ^DHCPESetting("DHCPE","PatItemSortTemp")=""
	//下一个团体代码
	Set ^DHCPESetting("DHCPE","PatNO_CurNo")="1"
	//华山设置的体检使用的登记号开始值
	Set ^DHCPESetting("DHCPE","PatNO_Begin")="00000000"
	//华山设置的体检使用结束的登记号值
	Set ^DHCPESetting("DHCPE","PatNO_End")="00040000"
	//导检单是否打印前后的内容  0不打印
	Set ^DHCPESetting("DHCPE","PatOrdFlag")="0^0"
	//体检开单对应的默认医生 CT_CareProv
	Set ^DHCPESetting("DHCPE","PhyExamDrId",263)="23"
	//体检中心对应的科室  CT_Loc
	//Set ^DHCPESetting("DHCPE","PhyExamLocId")="133"
	//报告中对应的医院  现在基本弄一个图片
	Set ^DHCPESetting("DHCPE","ReportTitle")="上海东方医院"
	//凑整费对应的医嘱项  自定义价格 文件中的PE008
	Set ^DHCPESetting("DHCPE","RoundingFee",238)="13343||1"
	//凑整费限额，尚未用
	Set ^DHCPESetting("DHCPE","RoundingFeeLimitMin")="0"
	//凑整费模式   0：不允许   1：个人收费允许  2：团体收费允许  3：个人和团体收费均允许。
	Set ^DHCPESetting("DHCPE","RoundingFeeMode")="3"
	//总检对应的安全组
	Set ^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")=",179,"
	//收费时，可以找零的特殊支付方式  CT_PayMode
	Set ^DHCPESetting("DHCPE","SpecialPayModes")="1,2"
	//检验站点  DHC_PE_Station
	Set ^DHCPESetting("DHCPE","StationId_Lab")="7"
	//安贞不需要建议的站点
	Set ^DHCPESetting("DHCPE","StationId_NoAdvice")=""
	//不需要提交的站点
	Set ^DHCPESetting("DHCPE","StationId_NoSubmit")=""
	//其它项目的站点  纯粹收费的项目  在导检单报告中无显示
	Set ^DHCPESetting("DHCPE","StationId_Other")="18"
	//检查项目对应的站点
	Set ^DHCPESetting("DHCPE","StationId_Ris")="8^9^10^11^12^13^14^15^16^17"
	//药品对应的站点
	Set ^DHCPESetting("DHCPE","StationId_Medical")=20
	//版本
	Set ^DHCPESetting("DHCPE","TrakVerison")="TrakCare"
	//
	Set ^DHCPESetting("DHCPEBaseData","PEARCOS")=""
	//检验对应的命名空间
	Set ^DHCPESetting("NAMESPACE","LABDATA")="LABDATA"
	//数据对应的命名空间
	Set ^DHCPESetting("NAMESPACE","MEDDATA")="DHC-DATA"
	//计费方式 New-新计费 Old-老计费  安贞为Old
	s ^DHCPESetting("DHCPE","BilledMode")="New"   
	//体检系统正式上线日期
	s ^DHCPESetting("DHCPE","PESystemStartDate")="61756" 
	//自动获取身高体重数值的医嘱
	s ^DHCPESetting("DHCPE","GetHWOrder")=""
	 //业务人员对应的科室
	s ^DHCPESetting("DHCPE","SalesDefaultDept")=""
	//是否打开结果界面直接默认正常值
	s ^DHCPESetting("DHCPE","AutoNormalResult",263)="Y"
	//检验是否取接口数据
	s ^DHCPESetting("DHCPE","LisInterface")="Y"
	//设置就诊费用类型 6为普通用于一般体检，8是国际医疗特需
	s ^DHCPESetting("DHCPE","DefADMFeeType",152)=6
	//体检复检医生安全组设置 此设置华山、友谊大门诊健康体检在用
	s ^DHCPESetting("DHCPE","MainDoctorGroup") = 290 
	//不同体检科室是否有复检功能
	s ^DHCPESetting("DHCPE","MainDoctorGroup",152)="Y"
	//建卡时的长度，已经按照卡类型取，基本没用了
	s ^DHCPESetting("DHCPE","CardNoLength")=10
	//卡类型，因为有可能存在多种卡类型，修改程序从js中传入卡类型
	s ^DHCPESetting("DHCPE","CardType")=1
	//总检chartbook，修改程序直接使用站点，彻底取消chart
	s ^DHCPESetting("DHCPE","ChartBook")=25
	//是否使用叫号接口
	s ^DHCPESetting("DHCPE","CallVoice",1542)="Y"
	//是否使用网上报告
	s ^DHCPESetting("DHCPE","NetReport",1542)="N"
	//导检单上是否打印收费项
	s ^DHCPESetting("DHCPE","PrintTarInfo",1542)="N"
	//自动提交人ID
	s ^DHCPESetting("DHCPE","AutoAuditUser",1542)="3901"
	//^DHCPESetting("DHCPE","CancelPEType",CurLoc)
	s ^DHCPESetting("DHCPE","CancelPEType",53)=1
	//是否像接口发送医嘱信息
	s ^DHCPESetting("DHCPE","SendOrder",1542)="Y"
	//当诊断不存在时，直接添加建议的默认ID
	s ^DHCPESetting("DHCPE","DefaultEDID")=""
	//套餐是否默认为一种分类（收费项），不设置就拆分
	s ^DHCPESetting("DHCPE","SetsDefaultTar",1542)=""
	//设置发票分类，在发票xml上的对应的标签名字
	s ^DHCPESetting("DHCPE","InvFeeCat","DHC_TarOC发票分类ID")="ElementName"
	quit
	////以下5个具体意思有代确定
	/*
	s ^DHCPESetting("DHCPE","GroupPatNO_Begin")="00000001"	//分配给团体的登记号的起初号
	s ^DHCPESetting("DHCPE","GroupPatNO_CurNo")=""
	s ^DHCPESetting("DHCPE","PatNO_Begin")="00030000"	//分配给团体的登记号的起初号
	s ^DHCPESetting("DHCPE","PatNO_End")="00040000"   //分配给团体的登记号的结束号
	s ^DHCPESetting("DHCPE","PatNO_CurNo")=""
	*/
}

/// 体检站点类型 HealthFile:健康档案站点 Lab:检验站点 RIS或空:检查站点 NOR
/// w ##class(web.DHCPE.Public.Setting).GetGroupPatNO()
ClassMethod GetGroupPatNO() As %String
{
	i 0=$D(^DHCPESetting("DHCPE","PatNO_CurNo")) d
	.s GroupPatNO=^DHCPESetting("DHCPE","GroupPatNO_Begin")
	.s ^DHCPESetting("DHCPE","PatNO_CurNo")=+^DHCPESetting("DHCPE","GroupPatNO_Begin")+1
	e  d
	.s GroupPatNO=$G(^DHCPESetting("DHCPE","PatNO_CurNo"))
	.s ^DHCPESetting("DHCPE","PatNO_CurNo")=+^DHCPESetting("DHCPE","PatNO_CurNo")+1
	s GroupPatNO=$Extract("00000000",1,8-$Length(GroupPatNO))_GroupPatNO
	s GroupPatNO="G"_GroupPatNO
	Q GroupPatNO
}

/// 体检站点类型 HealthFile:健康档案站点 Lab:检验站点 RIS或空:检查站点 NOR
/// w ##class(web.DHCPE.Public.Setting).GetStationType()
ClassMethod GetStationType(StationId As %String = "") As %String
{
	Q:(""=StationId) ""
	s StationType="NOR"
	i StationId=$G(^DHCPESetting("DHCPE","StationId_Lab")) s StationType="Lab"
	i ("^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^")[("^"_StationId_"^") s StationType="Ris"
	Q StationType
}

/// 获取体检系统版本 
/// w ##class(web.DHCPE.Public.Setting).GetTrakVerison()
ClassMethod GetTrakVerison() As %String
{
	// 1 新版本 默认	检验项目由医嘱项外码对应
	// 0 旧版本 		检验项目由医嘱套外码对应
	s TrakVerison=$G(^DHCPESetting("DHCPE","TrakVerison"))
	s:(""=TrakVerison) TrakVerison="TrakCare"
	Q TrakVerison
}

/// ##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
ClassMethod GetPAPMINoGenModel() As %String
{
	s GenModel=$g(^DHCPESetting("DHCPE","PAPMINo_GenModel"))
	Q GenModel
}

/// 获取市场部ID （业务人员）
ClassMethod GetSalesDefaultDept() As %String
{
	s SalesDefaultDept=$g(^DHCPESetting("DHCPE","SalesDefaultDept"))
	Q SalesDefaultDept
}

/// Create by MLH 2008-03-05
/// 获取体检系统正式运行时间
ClassMethod GetPESystemStartDate() As %String
{
	s PESystemStartDate=$g(^DHCPESetting("DHCPE","PESystemStartDate"))
	s PESystemStartDate=$s(PESystemStartDate'="":PESystemStartDate,PESystemStartDate="":60700)
	q PESystemStartDate
}

/// 显示体检系统参数列表
/// test: d ##class(%ResultSet).RunQuery("web.DHCPE.Public.Setting","SearchSetting")
Query SearchSetting() As %Query(ROWSPEC = "STT_Param:%String, STT_Desc:%String, STT_Value:%String")
{
}

ClassMethod SearchSettingExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
 	s ind=1
	s Param=""
	f  s Param=$O(^DHCPESetting("DHCPE",Param)) q:Param=""  d
	.s Value=$G(^DHCPESetting("DHCPE",Param))
	.s Desc=$G(^DHCPESetting("DHCPE", Param, "Desc"))
	.d SearchSettingOut
	.

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchSettingOut
	set Data=$lb(Param,Desc, Value)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSettingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSettingExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchSettingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSettingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %String
{
	s Param=$P(InString,"^",1)
	s Desc=$P(InString,"^",2)
	s Value=$P(InString,"^",3)
	
	s ^DHCPESetting("DHCPE",Param)=Value
	s ^DHCPESetting("DHCPE",Param, "Desc")=Desc
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	Q 0
}

/// ##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %String
{
	s Param=$P(InString,"^",1)
	Q:(""=Param) Param_"^^"
	k ^DHCPESetting("DHCPE",Param)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	Q 0
}

/// ##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s Param=$P(InString,"^",1)
	Q:(""=Param) Param_"^^"
	s Value=$G(^DHCPESetting("DHCPE",Param))
	s Desc=$G(^DHCPESetting("DHCPE", Param, "Desc"))
	s Data=Param_"^"_Desc_"^"_Value
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	q Data
}

ClassMethod DeleteTable()
{
	&sql(delete from DHC_PE_PreIBaseInfo)
	&sql(delete from DHC_PE_PreIADM)
	&sql(delete from DHC_PE_PreIOrdEnt)
	&sql(delete from DHC_PE_PreIOrdItem)
	&sql(delete from DHC_PE_PreGBaseInfo)
	&sql(delete from DHC_PE_PreGADM)
	&sql(delete from DHC_PE_PreGTeam)
	&sql(delete from DHC_PE_PreGTOrdEnt)
	&sql(delete from DHC_PE_PreGTOrdItem)
	&sql(delete from DHC_PE_PreAudit)
	
	&sql(delete from DHC_PE_IADM)
	&sql(delete from DHC_PE_AsChargedOrder)
	&sql(delete from DHC_PE_CRMOrder)
	&sql(delete from DHC_PE_GBaseInfo)
	&sql(delete from DHC_PE_GTeam)
	&sql(delete from DHC_PE_GADM)
	&sql(delete from DHC_PE_GeneralAdvice)
	&sql(delete from DHC_PE_GeneralAdviceDetail)
	&sql(delete from DHC_PE_GeneralSummarize)
	&sql(delete from DHC_PE_Report)
	&sql(delete from DHC_PE_Result)
	&sql(delete from DHC_PE_StationSummarize)
	&sql(delete from DHC_PE_StationWait)	
	K ^DHCPEGenED
}

ClassMethod DeleteGlabol()
{
	Set ARCIM=0
	For  Set ARCIM=$O(^DHCPEODR(0,"Required",ARCIM))  Quit:(ARCIM="")  Do
	.Set ODRRowId=0
	.For  Set ODRRowId=$O(^DHCPEODR(0,"Required",ARCIM,"Y",ODRRowId))  Quit:(ODRRowId="")  Do
	..If $g(^DHCPEODR(ODRRowId))="" Do
	...Write !,ODRRowId
	...Kill ^DHCPEODR(0,"Required",ARCIM,"Y",ODRRowId)
}

ClassMethod KillAllPEGlobal()
{
	;d ##class(web.DHCPE.Public.Setting).KillAllPEGlobal()
	k ^BAKDHCPEODR 
	k ^BAKDHCPEST 
	k ^DHCPE 
	k ^DHCPEAP 
	k ^DHCPEARCIMCon 
	k ^DHCPECRMO 
	k ^DHCPECashierTemp 
	k ^DHCPEComponent 
	k ^DHCPECreateSMSID 
	k ^DHCPEData 
	k ^DHCPEDataEX 
	k ^DHCPEDataEx 
	k ^DHCPEDataExBak 
	k ^DHCPEDataExWrz 
	k ^DHCPEDataExi 
	k ^DHCPEDateEx 
	k ^DHCPEED 
	k ^DHCPEEDA 
	k ^DHCPEEDC 
	k ^DHCPEEDCR 
	k ^DHCPEGADM 
	k ^DHCPEGBI 
	k ^DHCPEGC 
	k ^DHCPEGGS 
	k ^DHCPEGS 
	k ^DHCPEGSDM 
	k ^DHCPEGenED 
	k ^DHCPEHCRelate 
	k ^DHCPEHPNoRecord 
	k ^DHCPEHighRiskOrder 
	k ^DHCPEIADM 
	k ^DHCPEIDR 
	k ^DHCPEIE 
	k ^DHCPEILLS 
	k ^DHCPEILLSA 
	k ^DHCPEINVPRT 
	k ^DHCPEImportGInfo 
	k ^DHCPEItemSort 
	k ^DHCPELabPatNo 
	k ^DHCPEMenu 
	k ^DHCPENetReport 
	k ^DHCPENetReportPage 
	k ^DHCPENoPayCashier 
	k ^DHCPENoRelateDetailResult 
	k ^DHCPEODR 
	k ^DHCPEOEITEM 
	k ^DHCPEOEITEMAccAcc 
	k ^DHCPEOEITEMAccAccSource 
	k ^DHCPEOEITEMAccAccTemp 
	k ^DHCPEOEITEMAccAccTempSource 
	k ^DHCPEOEITEMBAK 
	k ^DHCPEOEITEMSource 
	k ^DHCPEOEITEMTemp 
	k ^DHCPEOEITEMTempSource 
	k ^DHCPEOSE 
	k ^DHCPEOldXHData 
	k ^DHCPEOutResultDetailTemp 
	k ^DHCPEPAPBR 
	k ^DHCPEPRT 
	k ^DHCPEPatItemPrintFlag 
	k ^DHCPEPatSortForNorCus 
	k ^DHCPEPayedCashier 
	k ^DHCPEPreA 
	k ^DHCPEPreAI 
	k ^DHCPEPreGADM 
	k ^DHCPEPreGBI 
	k ^DHCPEPreIADM 
	k ^DHCPEPreIBI 
	k ^DHCPEQueryResultTemp 
	k ^DHCPERLT 
	k ^DHCPERPT 
	k ^DHCPERegisterTempData 
	k ^DHCPERoom 
	k ^DHCPESS 
	k ^DHCPEST 
	k ^DHCPESWATMP 
	k ^DHCPESetting 
	k ^DHCPEShowEDInfo 
	k ^DHCPESort 
	k ^DHCPESortTemp 
	k ^DHCPESpecial 
	k ^DHCPESpecialBak 
	k ^DHCPESpecialContral 
	k ^DHCPESpecialReportInfo 
	k ^DHCPESpecialReportInfoBase 
	k ^DHCPESpecialReportPrintRecord 
	k ^DHCPEStationOrder 
	k ^DHCPETEMPArcCosStatic 
	k ^DHCPETMIC 
	k ^DHCPETMP 
	k ^DHCPETMPChargeStr 
	k ^DHCPETMPContrast 
	k ^DHCPETMPDWA 
	k ^DHCPETMPFTZYYExport 
	k ^DHCPETMPICExport 
	k ^DHCPETMPIS 
	k ^DHCPETMPLWA 
	k ^DHCPETMPNRData 
	k ^DHCPETMPNormalFlag 
	k ^DHCPETMPOSQ 
	k ^DHCPETMPOrdSets 
	k ^DHCPETMPPA 
	k ^DHCPETMPPC 
	k ^DHCPETMPPQ 
	k ^DHCPETMPPRS 
	k ^DHCPETMPPRSExport 
	k ^DHCPETMPRECPAPERData 
	k ^DHCPETMPSAQ 
	k ^DHCPETMPSWA 
	k ^DHCPETMPSWAExport 
	k ^DHCPETemp 
	k ^DHCPETempHPNo 
	k ^DHCPETempLabEpisodeNo 
	k ^DHCPETempLabEpisodeScan 
	k ^DHCPETempQuery 
	k ^DHCPETempResult 
	k ^DHCPETmpHadCheck 
	k ^DHCPEUSERREPORT 
	k ^DHCPEUpdateAuditRecord 
	k ^DHCPEUpdateLabNo 
	k ^DHCPEUserReportEx 
	k ^DHCPEVIPLevel 
	k ^DHCPEVIPLevelI 
	k ^DHCPEXWMTMP 
	k ^TEMPDHCPEInv 
	k ^TEMPDHCPELocWork 
	k ^TempDHCPE 
	k ^TempDHCPEAdviceSort 
	k ^TempDHCPEArcDesc 
	k ^TempDHCPEBarCodeSort 
	k ^TempDHCPEBarPrint 
	k ^TempDHCPEBarPrintFind 
	k ^TempDHCPECatInfo 
	k ^TempDHCPEChangeReult 
	k ^TempDHCPECheckInfo 
	k ^TempDHCPECheckInfoSex 
	k ^TempDHCPECheckProgress 
	k ^TempDHCPEDesc 
	k ^TempDHCPEDoc 
	k ^TempDHCPEEDDesc 
	k ^TempDHCPEEDInfo 
	k ^TempDHCPEEX 
	k ^TempDHCPEExportCommon 
	k ^TempDHCPEExportRecord 
	k ^TempDHCPEGADMList 
	k ^TempDHCPEGSS 
	k ^TempDHCPEGetInfor 
	k ^TempDHCPEGroupReport 
	k ^TempDHCPEInsertOtherItem 
	k ^TempDHCPEItemInfo 
	k ^TempDHCPELabRelate 
	k ^TempDHCPEListInfo 
	k ^TempDHCPEPerIADM 
	k ^TempDHCPEPreInfoFind 
	k ^TempDHCPEPreItemListEx 
	k ^TempDHCPEPrintDirect 
	k ^TempDHCPEPrintDirectSpecNum 
	k ^TempDHCPEPrintIAdmInfoSort 
	k ^TempDHCPERecPaper 
	k ^TempDHCPERecomm 
	k ^TempDHCPEResultDiagnosis 
	k ^TempDHCPEResultDiagnosisNew 
	k ^TempDHCPEResultDiagnosisNewAdvi 
	k ^TempDHCPEResultDiagnosisNewOrde 
	k ^TempDHCPEResultDiagnosisNewSpec 
	k ^TempDHCPEResultNew 
	k ^TempDHCPEResultNewLabSpecNo 
	k ^TempDHCPERoomInsert 
	k ^TempDHCPERoomManager 
	k ^TempDHCPERoomPerson 
	k ^TempDHCPESendAudit 
	k ^TempDHCPESetPatItem 
	k ^TempDHCPESetPatItemList 
	k ^TempDHCPESort 
	k ^TempDHCPESpec 
	k ^TempDHCPESpecialItem 
	k ^TempDHCPEStationOrder 
	k ^TempDHCPETransResult 
	k ^TempDHCPEUpdTar 
	k ^TempDHCPEUserReport 
	k ^User.DHCPEAdmRecordManagerD 
	k ^User.DHCPEAdmRecordManagerI 
	k ^User.DHCPEAdmRefuseRoomD 
	k ^User.DHCPEAdmRefuseRoomI 
	k ^User.DHCPEAdmRoomRecordD 
	k ^User.DHCPEAdmRoomRecordI 
	k ^User.DHCPEAreaC 
	k ^User.DHCPEAreaD 
	k ^User.DHCPEAreaI 
	k ^User.DHCPECardMonthReportC 
	k ^User.DHCPECardMonthReportD 
	k ^User.DHCPECardMonthReportI 
	k ^User.DHCPEContractD 
	k ^User.DHCPEContractI 
	k ^User.DHCPECurDateAdmInfoD 
	k ^User.DHCPECurDateAdmInfoI 
	k ^User.DHCPEEDKeyD 
	k ^User.DHCPEEDKeyI
	k ^User.DHCPEExpressD
	k ^User.DHCPEExpressI 
	k ^User.DHCPEGSDUnitRecordD 
	k ^User.DHCPEGSDUnitRecordI 
	k ^User.DHCPEGSSumD 
	k ^User.DHCPEGSSumI 
	k ^User.DHCPEGSSumS 
	k ^User.DHCPEGSSumSBak 
	k ^User.DHCPEHighRiskResultD 
	k ^User.DHCPEHighRiskResultI 
	k ^User.DHCPEHighRiskResultS 
	k ^User.DHCPEModifyDateRecordD 
	k ^User.DHCPEModifyDateRecordI 
	k ^User.DHCPENetItemTypeD 
	k ^User.DHCPENetItemTypeI 
	k ^User.DHCPENetOrdSetsC 
	k ^User.DHCPENetOrdSetsD 
	k ^User.DHCPENetOrdSetsI 
	k ^User.DHCPENetPreRecordD 
	k ^User.DHCPENetPreRecordI 
	k ^User.DHCPENetSetsItemC 
	k ^User.DHCPENetSetsItemDetailI 
	k ^User.DHCPENetSetsItemI 
	k ^User.DHCPENetSetsItemTypeC 
	k ^User.DHCPENetSetsItemTypeI 
	k ^User.DHCPENewMessageTempletD 
	k ^User.DHCPENewMessageTempletI 
	k ^User.DHCPENewSendMessageD 
	k ^User.DHCPENewSendMessageI 
	k ^User.DHCPEPositiveRecordD 
	k ^User.DHCPEPositiveRecordI 
	k ^User.DHCPEPreManagerC 
	k ^User.DHCPEPreManagerD 
	k ^User.DHCPEPreManagerI 
	k ^User.DHCPEPreTemplateC 
	k ^User.DHCPEPreTemplateD 
	k ^User.DHCPEPreTemplateI 
	k ^User.DHCPERoomC 
	k ^User.DHCPERoomI 
	k ^User.DHCPERoomIPI 
	k ^User.DHCPERoomSpecialRoomI 
	k ^User.DHCPERoomSpecimenI 
	k ^User.DHCPESendAuditD 
	k ^User.DHCPESendAuditI 
	k ^User.DHCPETempExpertDiagnosisD 
	k ^User.DHCPETempExpertDiagnosisI 
	k ^wrzDHCPEAP 
	k ^zlTempDHCPE 
	k ^DHCPEFTPhysical 
	k ^DHCPEFTPhysicalFlag 
	k ^DHCPEHMInterfaceErrRecord 
	k ^DHCPESM 
	k ^DHCPESettingBak 
	k ^DHCPESettingHYD 
	k ^DHCPETMPLabData 
	k ^DHCPETmp 
	k ^TMPDHCPE
	k ^TempDHCPEDBResult
	k ^TempDHCPEDocPatientChecking
	k ^TempDHCPEEDSort
	k ^TempDHCPEReport
	k ^TempLXLDHCPEPersonStatistic
	k ^User.DHCPEBasePicInfoD 
	k ^User.DHCPEBasePicInfoI
}

/// 功能:体检清理数据
/// 参数：1:基础数据 0:业务数据 2:配置数据
/// d ##class(web.DHCPE.Public.Setting).KillPEGlobal(0)
ClassMethod KillPEGlobal(KillBaseDataFlag As %Library.String = "")
{
	;d ##class(web.DHCPE.Public.Setting).KillPEGlobal(0)
	i KillBaseDataFlag=1  d
	.d KillBaseData //基本数据
	i KillBaseDataFlag=0  d
	.d KillPEData   //业务数据
	i KillBaseDataFlag=2  d
	.d KillCFData   //配置数据
	
	q 0
KillBaseData
	k ^DHCPEST    //1、站点信息DHC_PE_Station
				  //2、站点和体检大项（医嘱）对照表DHC_PE_StationOrder
				  //3、细项表DHC_PE_OrderDetail
			      //4、体检选择DHC_PE_ODStandard
				  //5、站点等候客户排队表DHC_PE_StationWait（DHC_PE_Station的子表）
    
    
	k ^DHCPEStationOrder			  
	k ^DHCPEODR   //大项和细项组合关系对照表DHC_PE_OrderDetailRelate
	k ^DHCPEDataEx("DHCPEStationOrder","SignItem")  //特殊项目
	
	k ^DHCPEED    //专家诊断主表DHC_PE_ExpertDiagnosis,专家诊断条件表DHC_PE_EDCondition
				  //专家诊断条件表DHC_PE_EDCondition

		
			  
	k ^DHCPEEDA   //专家诊断别名表DHC_PE_EDAlias
    K ^DHCPEIDR
	k ^DHCPEEDC   //专家建议级别
	k ^DHCPEEDCR  //专家建议和级别关联数据
	
	k ^User.DHCPEExpressD //专家建议表达式
	k ^User.DHCPEExpressI
	
	K ^DHCPEILLS //疾病维护
	K ^DHCPEILLSA 
	
	k ^DHCPEGC	  //安全组权限表DHC_PE_GroupChart
	//k ^DHCPEOSE	  //医嘱套功能扩展表DHC_PE_OrdSetsEx
	//k ^DHCPEIE   //体检医嘱扩展自定义价格医嘱 赠送项目
	
	//诊室分区、诊室
	k ^User.DHCPEAreaC
	k ^User.DHCPEAreaD
	k ^User.DHCPEAreaI
	k ^User.DHCPERoomC
	k ^User.DHCPERoomI
	k ^User.DHCPERoomIPI
	k ^User.DHCPERoomSpecialRoomI
	k ^User.DHCPERoomRoomPlaceI
	k ^User.DHCPERoomSpecimenI

	
	//职业病 体检人员分类
	K ^User.DHCPEConclusionI
	K ^User.DHCPEConclusionD
	
	//职业健康检查种类
	k ^User.DHCPEOMETypeD
	k ^User.DHCPEOMETypeI
	
	//目标疾病
	k ^User.DHCPEOMEIllnessD
	k ^User.DHCPEOMEIllnessI
	k ^User.DHCPEEDCheckCycleI
	
	//防护措施
	k ^User.DHCPEProtectiveMeasuresD
	k ^User.DHCPEProtectiveMeasuresI
	
	//行业维护
	k ^User.DHCPEIndustryD
	k ^User.DHCPEIndustryI
	
	//工种维护
	k ^User.DHCPEWorkTypeD
	k ^User.DHCPEWorkTypeI
	
	//危害因素
	k ^User.DHCPEEndangerC
	k ^User.DHCPEEndangerD
	k ^User.DHCPEEndangerS
	k ^User.DHCPEEndangerTypeI
    k ^User.DHCPEEndangerTypeD
	k ^User.DHCPEEDItemI 
	k ^User.DHCPEEDItemDetailI
	
	//诊断标准维护
	k ^User.DHCPEDiagnosticCriteriaD
	k ^User.DHCPEDiagnosticCriteriaI
	
	// 项目发生明细记录
	k ^User.DHCPEItemDetailRecordD
	k ^User.DHCPEItemDetailRecordI
	
	//职业健康处理意见模板维护
	k ^User.DHCPEHandlingOpinionsI
    k ^User.DHCPEHandlingOpinionsD
	
	//体检医嘱套维护-网上套餐维护
	k ^User.DHCPENetItemTypeD
	k ^User.DHCPENetItemTypeI
	
	//调查问卷
	K ^User.DHCHMCQDOLinkDetailI
	K ^User.DHCHMCQEDLinkI
	K ^User.DHCHMCQuestionSubject
	K ^User.DHCHMCQDOptionsI
	K ^User.DHCHMCSDLinkI
	
	//服务级别维护
	k ^User.DHCHMCSCQLinkI
	
	//扩展字段
	K ^DHCPECTDataEx
	
	//VIP等级
	k ^DHCPEVIPLevel
	
	//工作量分配类型
	k ^User.DHCPEWorkDistributeTypeD  
 	k ^User.DHCPEWorkDistributeTypeI
 	
 	//质量管理错误类型
 	k ^User.DHCPEQMTypeD
 	k ^User.DHCPEQMTypeI
	
	q
KillPEData

	k ^DHCPEPreIBI	//预约）个人基本信息表DHC_PE_PreIBaseInfo
	k ^DHCPEPreIADM //（预约）个人ADM表DHC_PE_PreIADM
					//（预约）个人项目套餐表 DHC_PE_PreIOrdEnt（个人ADM表的子表）
					//（预约）个人项目套餐费用表 DHC_PE_PreIOrdEntFee（个人项目套餐表的子表）
					//（预约）个人项目表 DHC_PE_PreIOrdItem（个人ADM表的子表）
					//（预约）个人项目费用表 DHC_PE_PreIOrdItemFee（个人项目表的子表）
					
	k ^DHCPEPreGBI	//（预约）团体客户基本信息表DHC_PE_PreGBaseInfo
	k ^DHCPEPreGADM //（预约）团体客户ADM表 DHC_PE_PreGADM
	 				//（预约）团体分组表 DHC_PE_PreGTeam（团体ADM表的子表）
	 				//（预约）团体分组项目套餐表 DHC_PE_PreGTOrdEnt（团体分组表的子表）
	 				//（预约）团体分组项目表 DHC_PE_PreGTOrdItem（团体分组表的子表）
	 				
	k ^DHCPEPreA	//（预约）团体和个人ADM审核表 DHC_PE_PreAudit
	
	k ^DHCPEPAPBR	//（预约）审核表和收费表的对照 DHC_PE_PAPBRelate
		
	k ^DHCPEGBI   //团体客户基本信息登记表DHC_PE_GBaseInfo
	k ^DHCPEGADM  //1、团体客户ADM表 DHC_PE_GADM
				  //2、团体分组表 DHC_PE_GTeam（团体ADM表的子表）
	k ^DHCPEIADM  //体检人员表ADM表DHC_PE_IADM
	//k ^DHCPEACO	  //视同收费项目费用状态表DHC_PE_AsChargedOrder（挂账）
	k ^DHCPECRMO  //与CRM大项对照表DHC_PE_CRMOrder
	
	k ^DHCPERPT   //体检报告DHC_PE_Report
	
	k ^DHCPERLT   //体检结果表DHC_PE_Result
	k ^DHCPETempResult
	k ^DHCPESS    //科室小结DHC_PE_StationSummarize
	              //站点（科室）小结阳性体征DHC_PE_SSResult（所有阳性体征）
	              //站点（科室）小结诊断明细DHC_PE_SSDiagnosis（所有诊断）
	k ^DHCPEGA	  //总检建议DHC_PE_GeneralAdvice
				  //总检建议明细表DHC_PE_GeneralAdviceDetail
	k ^DHCPEGS	  //总检结论DHC_PE_GeneralSummarize
				  //总检结论阳性体征DHC_PE_GSResult（各个科室阳性体征）
				  //总检结论诊断明细DHC_PE_GSDiagnosis（各个科室所有诊断）
	k ^DHCPEGGS
    k ^DHCPEGSDM			  //
	k ^DHCPERPT   //体检报告DHC_PE_Report
	
	k ^DHCPEINVPRT	//发票表
	k ^DHCPEUSERREPORT	//收费员日结表
	k ^DHCPEGenED	//保存的业务阳性体征
	k ^DHCPEACO
    k ^DHCPEAP
    //体检过程记录
    k ^User.DHCPEAdmRecordManagerD
    k ^User.DHCPEAdmRecordManagerI
    //体检诊室记录
    k ^User.DHCPEAdmRoomRecordD
    k ^User.DHCPEAdmRoomRecordI
    //当天报到记录
    k ^User.DHCPECurDateAdmInfoD
    k ^User.DHCPECurDateAdmInfoI
   	//高危记录
    k ^User.DHCPEHighRiskDetailI
    k ^User.DHCPEHighRiskResultC
    k ^User.DHCPEHighRiskResultD
    k ^User.DHCPEHighRiskResultI
    //预约管理
    k ^User.DHCPEPreManagerD
	k ^User.DHCPEPreManagerI 
	//送总检
	k ^User.DHCPESendAuditI
	k ^User.DHCPESendAuditD
	//短信
	k ^User.DHCPENewSendMessageD
	k ^User.DHCPENewSendMessageI
	//
	k ^User.DHCPEGSSumD
	k ^User.DHCPEGSSumI
	k ^User.DHCPEGSSumS
	//
	k ^User.DHCPECardMonthReportD
	k ^User.DHCPECardMonthReportI
	k ^User.DHCPECardMonthReportS
	//
	k ^User.DHCPEAdmRoomRecordD
	k ^User.DHCPEAdmRoomRecordI
	k ^User.DHCPEAdmRoomRecordS
	
    //采血记录
    k ^DHCPETempLabEpisodeNo
    k ^DHCPETempLabEpisodeScan
    
    //收表确认
    k ^DHCPEDataEx("ConfirmRecPaper")
    k ^DHCPEDataEx("DHC_PE_PreIOrdItem")
    k ^DHCPEDataEx("DHCPEResult")
    k ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser")
    k ^DHCPEDataExi("DHCPEPreIADM")
    k ^DHCPEDataExi("DHCPEPreGADM")
    k ^DHCPEDataEx("DHCPEIADM")
    k ^DHCPEDataEx("DHCPEPreIADM")
    K ^DHCPEDataEX("DHCPEGTeamTemplate") //分组存为预置
    k ^DHCPEDataEx("DHCPEPreGADM")
    k ^DHCPEDataEx("InsertRoundFee")  //凑整费记录信息
    k ^DHCPEDataEx("SendRisRequest")
    k ^DHCPECBVIPLevel("PIBI")
    k ^DHCPEHPNoRecord  //体检号计数器
    k ^DHCPEOEITEM  //收费拆分为收费项
    k ^DHCPEConfirmInfo //确认加项
    k ^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor")
    k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck") //拒绝项目
    K ^DHCPEDataEx("DHCPESendPACSApplay","OEORDID") //新产品检查申请
    k ^DHCPENetReport //新版打印报告
    //K ^DHCPESpecialContral("DHCPEXH")
    K ^DHCPESpecial
    k ^DHCPEPatItemPrintFlag //导诊单打印的标记
	//集中打印发票
	K ^User.DHCPEINVFocusPrtI
	K ^User.DHCPEINVFocusPrtD
	
	//集中打印发票报表
	k ^User.DHCPEFocusPrtReportI
	k ^User.DHCPEFocusPrtReportD
	
	//团体合同  主场设置
	K ^User.DHCPEContractD
	K ^User.DHCPEContractI
	K ^User.DHCPEPreHomeInfoI
	K ^User.DHCPEPreHomeInfoD

    //职业病
	K ^User.DHCPEPreIADMExI
    K ^User.DHCPEPreIADMExD
    k ^User.DHCPEPreIBaseInfoExD
    k ^User.DHCPEPreIBaseInfoExI
    k ^User.DHCPEGeneralSummarizeExI
    k ^User.DHCPEGeneralSummarizeExD
    
    //住院体检
    k ^User.DHCPEOtherPatientToHPI
    k ^User.DHCPEOtherPatientToHPD
    
    //质量管理错误类型上报
    K ^User.DHCPEQualityManagerI
    K ^User.DHCPEQualityManagerD
    
    //体检结果分析指标global
    k ^DHCPEQueryTarget 
    
    //体检结果对比   
	k ^User.DHCPEGSContrastD
	k ^User.DHCPEGSContrastI  
	
	//网上预约记录
	k ^User.DHCPENetPreRecordD 
	k ^User.DHCPENetPreRecordI 

	//医生工作量分配(业务数据)
	K ^User.DHCPEWorkDistributionD
	k ^User.DHCPEWorkDistributionI
	
	//调查问卷
	k ^User.DHCHMOBaseInfoD
	k ^User.DHCHMOBaseInfoI
	k ^User.DHCHMOBaseInfoS
	k ^User.DHCHMOEvaluationRecordD
	k ^User.DHCHMOEvaluationRecordI
	k ^User.DHCHMOEvaluationRecordS
	k ^User.DHCHMOQEQuestionD
	k ^User.DHCHMOQEQuestionI
	k ^User.DHCHMOQEQuestionS
	k ^User.DHCHMOQEQuestionC
	k ^User.DHCHMOQResultI
	k ^User.DHCHMOQResultS
	k ^User.DHCHMOQEvaluationI
	k ^User.DHCHMOQEvaluationS
	k ^User.DHCHMOQMedicalTipsI
	k ^User.DHCHMOQMedicalTipsS
	k ^DHCPEDataNewEx("HMToPreIADM")
	k ^DHCPEDataNewEx("PreIADMToHM")
	
    k ^DHCPESetting("DHCPE","DefaultPAADM")
    
    //其他
    k ^DHCPE("Url")
    k ^DHCPE("InfoType")
    k ^DHCPEA 
    k ^DHCPEBGYLGetAdmCurRoomErr 
    k ^DHCPECBSpecial 
    k ^DHCPECBVIPLevel 
   
    k ^DHCPECashierTemp 
    
    k ^DHCPECreateSMSID  
    
    k ^DHCPEData
    k ^DHCPEDataEX
    k ^DHCPEDateEx
    k ^DHCPEDataExI 
    k ^DHCPEDataExi 
    k ^DHCPEDataNewEx 
    k ^DHCPEDataExNew
     
    k ^DHCPEFactAmount
     
    k ^DHCPEHR 
    k ^DHCPEHRD 
    k ^DHCPEHRDR
     
    k ^DHCPEHighRiskOrder 
    
    k ^DHCPEImportGInfo 
    
    k ^DHCPEItemSort 
    
    k ^DHCPEMarkPis 
    k ^DHCPEMarkPisTemp
     
    k ^DHCPENetReportPage 
    
    k ^DHCPEODA 
    
    k ^DHCPEOEITEMAccAcc 
    k ^DHCPEOEITEMAccAccTemp 
    k ^DHCPEOEITEMTemp
    
    k ^DHCPEOtherPatientToHP 
    
    k ^DHCPEPRT 
    
    k ^DHCPEPreAI
     
    k ^DHCPEPreIADMMark 
    
    k ^DHCPERLTTMP
    
    k ^DHCPERSON 
    
    k ^DHCPERecord 
    
    k ^DHCPERegisterTempData 
   
   
    k ^DHCPETMP
    k ^DHCPETMPChargeStr 
    k ^DHCPETMPContrast 
    k ^DHCPETMPLabEpisode 
    k ^DHCPETMPLocNum 
    k ^DHCPETMPNRData 
    k ^DHCPETMPNormalFlag 
    k ^DHCPETMPOrdSets 
    k ^DHCPETMPPA 
    k ^DHCPETMPRECPAPERData 
    k ^DHCPETMPSendPACSApplay  //检查、检验申请记录
    k ^DHCPETEMPAdviceNew 
     
    k ^DHCPETemp 
    k ^DHCPETempARCIMOrdItem 
    k ^DHCPETempHPNo 
    k ^DHCPETempQuery 
    k ^DHCPETempReport 
    k ^DHCPETmpHadCheck 
    
    k ^DHCPEVIPLevelI
    
    k ^DHCPEWebServiceRecord 
    
    k ^DHCPEXWMTMP 
    
    k ^DHCPEYDTEST 
    
    k ^DHCPETEST 
    
    
    q
KillCFData
	//医生权限配置
   	k ^DHCPECFDataEx("ChartAssign") 
  
   	//医生打折权限配置
   	K ^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit")
   	
   	//体检设置
   	k ^DHCPESetting("DHCPE")
   	
   	//体检特殊项目权限管理
   	k ^DHCPESpecialContral("DHCPEXH")
   	
   	//会诊费、住院医生
   	k ^DHCPEOtherPatientToHPBase
   	
   	//体检提供给第三方的webservice，包括我们自己的体检网上预约、查看报告都走的接口配置
   	k ^User.DHCPEServiceActionD
	k ^User.DHCPEServiceActionI
   	
   	
   
   	//网上套餐
   	k ^User.DHCPENetOrdSetsC
	k ^User.DHCPENetOrdSetsD
	k ^User.DHCPENetOrdSetsI
	
	//网上套餐类型维护
   	k ^User.DHCPENetSetsItemTypeI
   	   	
   	
	//网上套餐项目维护
	k ^User.DHCPENetSetsItemI 
	k ^User.DHCPENetSetsItemC 
	
	//网上套餐细项维护
	k ^User.DHCPENetSetsItemDetailI 
	
   	//问卷基本内容维护界面，维护的关联套餐
   	k ^User.DHCHMCQDLinkOrdSetsI
   	

   	//问卷基本内容维护界面，维护的关联套餐
   	k ^User.DHCHMCQDLinkOrdSetsI
   	
   	//医嘱套功能扩展表DHC_PE_OrdSetsEx
    k ^DHCPEOSE	  
    
    //体检医嘱扩展自定义价格医嘱 赠送项目 
    k ^DHCPEIE  
     
    //诊室位置维护(和科室相关)
    K ^DHCPECTDataEx("RoomPlace")
    
    //工作分配医生(配置数据)
	k ^User.DHCPEWorkDistributeTypeC
	k ^User.DHCPEWorkDoctorI
	k ^User.DHCPEWorkLinkUrlI

    
	q
}

ClassMethod UpdateODRSeq()
{
	Set ODRRowId=0
	For  Set ODRRowId=$O(^DHCPEODR(ODRRowId)) Quit:ODRRowId=""  Do
	.Set ODRowId=$P(^DHCPEODR(ODRRowId),"^",2)
	.Set SeqStr=$g(^DHCPEST((+ODRowId),"OD",$P(ODRowId,"||",2)))
	.Set Seq=$p(SeqStr,"^",11)
	.Set Seq=$e(Seq,2,$l(Seq))
	.&SQL(Update SQLUSER.DHC_PE_OrderDetailRelate Set ODR_Sequence=:Seq Where ODR_RowId=:ODRRowId)
	.//w !,Seq
	Quit 0
}

ClassMethod UpdateLabODDetail(LabStation As %Library.String = "")
{
	Set ODCldSub=0
	For  Set ODCldSub=$O(^DHCPEST(LabStation,"OD",ODCldSub)) Quit:ODCldSub=""  Do
	.Set ODDesc=$P(^DHCPEST(LabStation,"OD",ODCldSub),"^",1)
	.//If ODCldSub=218 B
	.Set Str=ODDesc
	.Quit:ODDesc'["（"
	.Set Str=$P(ODDesc,"（",1)_"("_$P(ODDesc,"（",2)
	.//If ODCldSub=218 B
	.Quit:ODDesc'["）"
	.Set Str=$P(Str,"）",1)_")"_$P(Str,"）",2)
	.Set ODRowId=LabStation_"||"_ODCldSub
	.&SQL(Update SQLUSER.DHC_PE_OrderDetail Set OD_Desc=:Str Where OD_RowId=:ODRowId)
	.//w !,Seq
	Quit 0
}

/// w ##class(web.DHCPE.Public.Setting).ShowChartPage(431104,52)
ClassMethod ShowChartPage(EpisodeID, ChartID)
{
	s AllPEStation=##class(web.DHCPE.ResultDiagnosis).AdmNeedStation(EpisodeID)
	s AllPEStation="^"_AllPEStation_"^"
	s PEStation=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))
	s PEStation="^"_$G(PEStation)_"^"
	q:((PEStation'="^^")&&(AllPEStation'[PEStation)) 0
	q 1
}

/// d ##class(web.DHCPE.Public.Setting).UpdateSpec("3348438")
ClassMethod UpdateSpec(OEORD)
{
	s OESub=0
	TSTART
	f  s OESub=$o(^OEORD(OEORD,"I",OESub)) q:OESub=""  d
	.s ARCID=$p($g(^OEORD(OEORD,"I",OESub,1)),"^",2)
	.q:ARCID=""
	.s SPEC=""
	.s SPEC=$p(##class(web.DHCPE.PreItemList).GetDefaultSpecName(ARCID,1),"^",1)
	.s Sub=0
	.f  s Sub=$o(^OEORD(OEORD,"I",OESub,"SPEC",Sub)) q:Sub=""  d
	..s RowID=OEORD_"||"_OESub_"||"_Sub
	..;&SQL(update sqluser.OE_OrdSpecimen set SPEC_Code=:SPEC where SPEC_RowID=:RowID)
	..w SQLCODE_"^"_SPEC,!
	TROLLBACK
	//TCOMMIT
}

/// d ##class(web.DHCPE.Public.Setting).UpdateEX("1")
ClassMethod UpdateEX(Str)
{
	s EDID=0
	TSTART
	f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
	.s Detail=$p($G(^DHCPEED(EDID,"Detail")),"^",1)
	.s Spli=Str_"."
	.s Rep="("_Str_")"
	.s Detail=..Replace(Detail,Spli,Rep)
	.w Detail,!
	.&SQL(update sqluser.DHC_PE_ExpertDiagnosis set ED_Detail=:Detail where ED_RowId=:EDID)
	TCOMMIT
}

/// d ##class(web.DHCPE.Public.Setting).UpdateEC()
ClassMethod UpdateEC()
{
	s EDID=0
	TSTART
	f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
	.s Detail=$p($G(^DHCPEED(EDID,"Detail")),"^",1)
	.s Detail=..Replace(Detail,"""","")
	.s EDConclusion=$p(^DHCPEED(EDID,1),"^",1)
	.s EDConclusion=..Replace(EDConclusion,"""","")
	.&SQL(update sqluser.DHC_PE_ExpertDiagnosis (ED_Detail,ED_DiagnoseConclusion) values (:Detail,:EDConclusion) where ED_RowId=:EDID)
	TCOMMIT
}

/// d ##class(web.DHCPE.Public.Setting).UpdateEA()
ClassMethod UpdateEA()
{
	TSTART
	s EDARowId=0
  	f  s EDARowId=$o(^DHCPEEDA(EDARowId)) q:EDARowId=""  d
  	.s EDAText=$p(^DHCPEEDA(EDARowId),"^",2)
	.s EDAText=..Replace(EDAText,"""","")
	.&SQL(update sqluser.DHC_PE_EDAlias (EDA_Text) values (:EDAText) where EDA_RowId=:EDARowId)
	TCOMMIT
}

/// ##class(web.DHCPE.Public.Setting).Replace("1")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

/// Create by MLH 2008-06-18
/// d ##class(web.DHCPE.Public.Setting).InitOrdHasPhoto()
ClassMethod InitOrdHasPhoto()
{
	
	Set STORDChd=0
	For  Set STORDChd=$o(^DHCPEST(10,"O",STORDChd)) Quit:STORDChd=""  Do
	.Set STORDRowId=10_"||"_STORDChd
	.Set ^DHCPEDataEx("DHCPEStationOrder","Photo",STORDRowId)="Y"
	
	Set STORDChd=0
	For  Set STORDChd=$o(^DHCPEST(13,"O",STORDChd)) Quit:STORDChd=""  Do
	.Set STORDRowId=13_"||"_STORDChd
	.Set ^DHCPEDataEx("DHCPEStationOrder","Photo",STORDRowId)="Y"
	Quit
}

ClassMethod TestDelete()
{
	;d ##class(web.DHCPE.Public.Setting).TestDelete()
	k ^User.DHCPEAdmRoomRecordD
    k ^User.DHCPEAdmRoomRecordI
    //当天报到记录
    k ^User.DHCPECurDateAdmInfoD
    k ^User.DHCPECurDateAdmInfoI
   	//高危记录
    k ^User.DHCPEHighRiskDetailI
    k ^User.DHCPEHighRiskResultC
    k ^User.DHCPEHighRiskResultD
    k ^User.DHCPEHighRiskResultI
    //预约管理
    k ^User.DHCPEPreManagerD
	k ^User.DHCPEPreManagerI 
	//送总检
	k ^User.DHCPESendAuditI
	k ^User.DHCPESendAuditD
	//短信
	k ^User.DHCPENewSendMessageD
	k ^User.DHCPENewSendMessageI
}

}
