/// 名称: web.DHCCPW.MR.ClinPathWaysMonitor
/// 描述: 临床路径监控相关查询
/// 编写者：zhufei
/// 编写日期: 2010-06-25
Class web.DHCCPW.MR.ClinPathWaysMonitor Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 取医嘱项信息
ClassMethod GetArcimByArcID(ArcimID As %String) As %String
{
	New (ArcimID)
	Set return=""
	Quit:ArcimID="" return
	
	Set (ArcCode,ArcDesc,SubCat,Drug,StartDate,EndDate,Priority,Unit)=""
	Set ArcID1=$p(ArcimID,"||",1),ArcID2=$p(ArcimID,"||",2)
	Quit:'$d(^ARCIM(ArcID1,ArcID2)) return
 	Set ArcCode=$p($g(^ARCIM(ArcID1,ArcID2,1)),"^",1)     //医嘱项代码
 	Set ArcDesc=$p($g(^ARCIM(ArcID1,ArcID2,1)),"^",2)     //医嘱项名称
 	Set SubCat=""
 	Set SubCatID=$p($g(^ARCIM(ArcID1,ArcID2,1)),"^",10)   //医嘱子类
	Set:SubCatID'="" SubCat=$p(^ARC("IC",SubCatID),"^",2) //医嘱子类描述
	Set UnitDr=$p($g(^ARCIM(ArcID1,ArcID2,8)),"^",14)     //整包装(袋\盒\...)
	Set:UnitDr'="" Unit=$p($g(^CT("UOM",UnitDr)),"^",2)   //整包装描述
	Set Drug=$p($g(^ARCIM(ArcID1,ArcID2,1)),"^",12)       //药学项
	Set Drug1=$p(Drug,"||",1)
	Set Drug2=$p(Drug,"||",2)
 	Set:(Drug1'="")&&(Drug2'="") Drug=$p($g(^PHCD(Drug1,Drug2)),"^",2)        //药学项名称
 	Set StartDate=$p($p($g(^ARCIM(ArcID1,ArcID2,1)),"^",13),"Z",1)  //开始日期
 	Set:StartDate'="" StartDate=$zd(StartDate,3)
 	Set EndDate=$p($g(^ARCIM(ArcID1,ArcID2,7)),"^",1)    //结束日期
 	Set:EndDate'="" EndDate=$zd(EndDate,3)
 	Set Priority=$p($g(^ARCIM(ArcID1,ArcID2,8)),"^",22)  //医嘱默认类型(临时医嘱\长期医嘱\自备药\出院带药\...)
 	Set:Priority'="" Priority=$p($g(^OECPR(Priority)),"^",2)
 	Set return=ArcimID_"^"_ArcCode_"^"_ArcDesc_"^"_SubCat_"^"_Drug_"^"_StartDate_"^"_EndDate_"^"_Priority_"^"_Unit_"^"_SubCatID
 	
	Quit return
}

/// 取检验标本
/// 一个医嘱可能对应多个标本
ClassMethod GetLabSpecByOrdID(argOrItemID As %String) As %String
{
	New (argOrItemID)
 	Set return=""
 	Set OrdID=$p(argOrItemID,"||",1)
 	Set SubID=$p(argOrItemID,"||",2)
 	Quit:(OrdID="")||(SubID="") return
 	
 	Set SpecID=0
 	For {
	 	Set SpecID=$o(^OEORD(OrdID,"I",SubID,"SPEC",SpecID))
	 	Quit:SpecID=""
	 	
	 	Set SpecCode=$p($g(^OEORD(OrdID,"I",SubID,"SPEC",SpecID)),"^",1)  //检验标本代码
	 	Set SpecDesc=$p($g(^TTAB("SPEC",SpecCode)),"\",1)  //检验标本名称
	 	Set return=return_","_SpecDesc
	}
	
	Set:return'="" return=$e(return,2,$l(return))
 	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-25
/// Description:  医嘱相关信息
/// Return:       $lb() 或 ""
ClassMethod BuildOEData(argOeItemID As %String, argDateFrom As %String, argDateTo As %String, argItemCat As %String, argItemSubCat As %String) As %List
{
	New (argOeItemID,argDateFrom,argDateTo,argItemCat,argItemSubCat)
	Set return=""
	
	Set OeItemID=argOeItemID
	Set OrdID=$p(OeItemID,"||",1)
	Set SubID=$p(OeItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	Set OrdStr1=$g(^OEORD(OrdID,"I",SubID,1))
	Set OrdStr2=$g(^OEORD(OrdID,"I",SubID,2))
	Set OrdStr3=$g(^OEORD(OrdID,"I",SubID,3))
	Set OrdStr5=$g(^OEORD(OrdID,"I",SubID,5))
	Set OrdStr9=$g(^OEORD(OrdID,"I",SubID,9))
	Set OrdStr11=$g(^OEORD(OrdID,"I",SubID,11))
	Set ArcimID=$p(OrdStr1,"^",2)  //医嘱项
	Set ArcStr=..GetArcimByArcID(ArcimID)  //医嘱项对应信息
	Quit:ArcStr="" return
	Set ArcimCode=$p(ArcStr,"^",2)
	Set ArcimDesc=$p(ArcStr,"^",3)
	Set ArcimSubCatDesc=$p(ArcStr,"^",4)
	Set ArcimSubCat=+$p(ArcStr,"^",10)
	Set ArcimCat=+$p($g(^ARC("IC",ArcimSubCat)),"^",8)
	Quit:(argItemSubCat'="")&&(argItemSubCat'=ArcimSubCat) return
	Quit:(argItemCat'="")&&(argItemCat'=ArcimCat) return
	Set OrdCreateDate=$p(OrdStr3,"^",7)  //下医嘱日期
	Set:OrdCreateDate'="" OrdCreateDate=$zd(OrdCreateDate,3)
	Set OrdCreateTime=$p(OrdStr1,"^",17)
	Set:OrdCreateTime'="" OrdCreateTime=$zt(OrdCreateTime,2)
	Set OrdStartDate=$p(OrdStr1,"^",9)  //开始日期
	Quit:(argDateFrom'="")&&(OrdStartDate<argDateFrom) return
	Quit:(argDateTo'="")&&(OrdStartDate>argDateTo) return
	Set:OrdStartDate'="" OrdStartDate=$zd(OrdStartDate,3)
	Set OrdStartTime=$p(OrdStr1,"^",10)
	Set:OrdStartTime'="" OrdStartTime=$zt(OrdStartTime,2)
	Set PrescNo=$p(OrdStr1,"^",14)  //处方号???
	Set DoseQty=$p(OrdStr2,"^",1)  //剂量
	Set DoseUnit=$p(OrdStr2,"^",3)  //剂量单位(g\袋\片\粒\...)
	Set:DoseUnit'="" DoseUnit=$p($g(^CT("UOM",DoseUnit)),"^",2)
	Set OrderSeqNo=$p(OrdStr3,"^",4)  //???
	Set PriorityDR=$p(OrdStr1,"^",8)  //医嘱类型(长期医嘱\临时医嘱\即刻医嘱\自备药医嘱\...)
	Set Priority="",PriorityCode=""
	Set:PriorityDR'="" Priority=$p($g(^OECPR(PriorityDR)),"^",2)
	Set:PriorityDR'="" PriorityCode=$p($g(^OECPR(PriorityDR)),"^",1)
	Set PHFreq=$p(OrdStr2,"^",4)
	Set:PHFreq'="" PHFreq=$p($g(^PHCFR(PHFreq)),"^",1)  //频次
	Set Instr=$p(OrdStr2,"^",7)
	Set:Instr'="" Instr=$p($g(^PHCIN(Instr)),"^",2)  //用法
	Set OrdStatusDR=$p(OrdStr1,"^",13)
	Set:OrdStatusDR'="" OrdStatus=$p($g(^OEC("OSTAT",OrdStatusDR)),"^",2)
	Set:OrdStatusDR'="" OrdStatusCode=$p($g(^OEC("OSTAT",OrdStatusDR)),"^",1)
	Set Dura=$p(OrdStr2,"^",6)  //疗程
	Set:Dura'="" Dura=$p($g(^PHCDU(Dura)),"^",3)
	Set Doctor=$p(OrdStr1,"^",11)
	Set:Doctor'="" Doctor=$p($g(^CTPCP(Doctor,1)),"^",2)
	Set QtyPackUOM=$p(OrdStr9,"^",4)
	Set PackUOMDesc=""  //整包装单位
	Set BillingUOMDR=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),8)),"^",14)
	Set:BillingUOMDR'="" PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	Set HaveDispensing=0,DStatus=""
	Set Dis=0
	For {
		Set Dis=$o(^DHCOEDISQTY(0,"OEORI",OeItemID,Dis))
		Quit:Dis=""
		Set DStatus=$p($g(^DHCOEDISQTY(Dis)),"^",7)
		Set HaveDispensing=1
	}
	If HaveDispensing=1 {
		Set:DStatus="C" DStatus="已发"
		Set:DStatus="P" DStatus="未发"
		Set:DStatus="" DStatus="未打包"
	}
	Set LabEpisodeNo=$p(OrdStr3,"^",20)  //条码号
	Set OrdLabSpec=..GetLabSpecByOrdID(OeItemID)  //检验标本
	If OrdStatus="停止" {
		Set OrdXDate=$p(OrdStr3,"^",34)  //停医嘱日期
		Set:OrdXDate'="" OrdXDate=$zd(OrdXDate,3)
		Set OrdXTime=$p(OrdStr2,"^",15)
		Set:OrdXTime'="" OrdXTime=$zt(OrdXTime,2)
	}
	If OrdStatus="执行" {
		Set ChildID=$o(^OEORD(OrdID,"I",SubID,"X",0))
		If ChildID'="" {
			Set tmpOrdExec=$g(^OEORD(OrdID,"I",SubID,"X",ChildID))
			Set OrdXDate=$p(tmpOrdExec,"^",1)
			Set OrdXTime=$p(tmpOrdExec,"^",2)
			Set:OrdXDate'="" OrdXDate=$zd(+OrdXDate,3)
			Set:OrdXTime'="" OrdXTime=$zt(+OrdXTime,2)
		}
	}
	Set OrdSkinTestResult=""  //皮试
	Set OrdSkinTest=$p(OrdStr5,"^",2)
	Set ABNorm=$p($g(^OEORD(OrdID,"I",SubID,11)),"^",3)
	If OrdSkinTest="Y" {
		If ABNorm="Y" {
			Set OrdSkinTestResult="阳性"
		} Else {
			Set OrdSkinTestResult="阴性"
		}
	}
	Set OrdAction=$p(OrdStr11,"^",21)  //皮试备注
	Set:OrdAction'="" OrdAction=$P($g(^OEC("ACT",OrdAction)),"^",2)
	Set OrdDepProcNotes=$g(^OEORD(OrdID,"I",SubID,"DEP",1))  //备注
	Set OrdBilled=$p(OrdStr3,"^",5)  //是否计费???
	
	Set Data=$lb($g(OeItemID))
	Set Data=Data_$lb($g(Priority))
	Set Data=Data_$lb($g(ArcimDesc))
	Set Data=Data_$lb($g(ArcimSubCatDesc))
	Set Data=Data_$lb($g(OrdCreateDate))
	Set Data=Data_$lb($g(OrdCreateTime))
	Set Data=Data_$lb($g(OrdStartDate))
	Set Data=Data_$lb($g(OrdStartTime))
	Set Data=Data_$lb($g(OrdXDate))
	Set Data=Data_$lb($g(OrdXTime))
	Set Data=Data_$lb($g(OrdStatus))
	Set Data=Data_$lb($g(DoseQty))
	Set Data=Data_$lb($g(DoseUnit))
	Set Data=Data_$lb($g(PHFreq))
	Set Data=Data_$lb($g(Instr))
	Set Data=Data_$lb($g(Dura))
	Set Data=Data_$lb($g(QtyPackUOM))
	Set Data=Data_$lb($g(PackUOMDesc))
	Set Data=Data_$lb($g(PrescNo))
	Set return=Data
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-25
/// Description:  此次就诊医嘱记录
/// Input：       EpisodeID(就诊号)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysMonitor","QryOEItemByAdm","76734","","","6","225")
Query QryOEItemByAdm(argEpisodeID As %String, argDateFrom As %String, argDateTo As %String, argItemCat As %String, argItemSubCat As %String) As %Query(ROWSPEC = "OeItemID:%String,Priority:%String,ArcimDesc:%String,ArcimSubCat:%String,OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,OrdXDate:%String,OrdXTime:%String,OrdStatus:%String,DoseQty:%String,DoseUnit:%String,PHFreq:%String,Instr:%String,Dura:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String")
{
}

ClassMethod QryOEItemByAdmExecute(ByRef qHandle As %Binary, argEpisodeID As %String, argDateFrom As %String, argDateTo As %String, argItemCat As %String, argItemSubCat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argEpisodeID="" $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	//Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	//^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	Set OeordID=0
	For {
		Set OeordID=$o(^OEORD(0,"Adm",argEpisodeID,OeordID))
		Quit:OeordID=""
		
		Set SubID=0
		For {
			//^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
			Set SubID=$o(^OEORD(OeordID,"I",SubID))
			Quit:SubID=""
			
			Set OeItemID=OeordID_"||"_SubID
			Set Data=..BuildOEData(OeItemID,argDateFrom,argDateTo,argItemCat,argItemSubCat)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOEItemByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEItemByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEItemByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEItemByAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhufei
/// CreatDate：   2010-06-30
/// Description:  临床路径监控程序
/// Input：       PathWayID(临床路径),EpisodeID(就诊号)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysMonitor","QryMonitor","","")
Query QryMonitor(argPathWayID As %String) As %Query(ROWSPEC = "EpisodeID:%String:就诊号,RuleID:%String:规则号,RuleName:%String:规则名称,RuleType:%String:表达式类型,RuleItem:%String:项目号,ItemName:%String:项目名称,RuleNorm:%String:基准,RuleTime:%String:时限要求,RuleAmount:%String:数量要求,RuleRst:%String:结果")
{
}

ClassMethod QryMonitorExecute(ByRef qHandle As %Binary, argPathWayID As %String, argEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	If $IsObject(objPathWay){
		If $IsObject(objPathWay.CPWPathwayDR) {
			Set PathWayID=objPathWay.CPWPathwayDR.%Id()
		}
		Set InDate=objPathWay.CPWInDate
		Set InTime=objPathWay.CPWInTime
		Set MRAdm=objPathWay.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	}
	Quit:$g(PathWayID)="" $$$OK
	Quit:EpisodeID="" $$$OK
	Set CPWID=argPathWayID
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMRC("CPW",PathWayID,"RULE",SubID))
		Quit:SubID=""
		
		Set Data=""
		Set RuleID=PathWayID_"||"_SubID
		Set objRule=##class(web.DHCCPW.MRC.CheckRule).GetObjById(RuleID)
		If $IsObject(objRule){
			Set IsActive=objRule.CPWRActiveFlag   //是否有效
			Continue:IsActive'["Y"
			Set RuleName=objRule.CPWRDesc         //规则名称
			Set RuleExp=objRule.CPWRExpression    //表达式
			Set RuleType=$p(RuleExp,$c(1),1)      //表达式类型
			Set RuleItem=$p(RuleExp,$c(1),2)      //项目(临床路径项目)
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(RuleItem)
			If $IsObject(objItem){
				Set ItemName=objItem.CPWSIDesc    //项目名称
				Set ItemArcim=objItem.CPWSIARCIM
			}
			If objItem'="" Do objItem.%Close()
			If RuleType="A" {
				Set NormTime=$p(RuleExp,$c(1),3)  //基准时间(入院时间\入径时间)
				Set NormTime=$s(NormTime=1:"入院时间",NormTime=2:"入径时间",1:"Error")
				Set TimeMin=+$p(RuleExp,$c(1),4)   //最小时间
				Set TimeMax=+$p(RuleExp,$c(1),5)   //最大时间
				Set TimeUnit=$p(RuleExp,$c(1),6)  //时间单位
				Set TimeUnit=$s(TimeUnit="D":"天",TimeUnit="H":"时",TimeUnit="M":"分",1:"Error")
				Set AmountMin=+$p(RuleExp,$c(1),7) //最小数量
				Set AmountMax=+$p(RuleExp,$c(1),8) //最大数量
				Set RuleRst=..getResultOfA(CPWID,RuleExp)
				Set RuleRst=$s(RuleRst>0:"完成",1:"未完成")
				Set Data=$lb(EpisodeID,RuleID,RuleName,RuleType,RuleItem,$g(ItemName),NormTime,TimeMin_"~"_TimeMax_TimeUnit,AmountMin_"~"_AmountMax,RuleRst)
			}
			If RuleType="B" {
				Set NormItem=$p(RuleExp,$c(1),3)  //基准项目(临床路径项目)
				Set objNormItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(NormItem)
				If objNormItem'="" Do objNormItem.%Close()
				Set NormItem=objNormItem.CPWSIDesc  //基准项目名称
				Set TimeMin=+$p(RuleExp,$c(1),4)   //最小时间
				Set TimeMax=+$p(RuleExp,$c(1),5)   //最大时间
				Set TimeUnit=$p(RuleExp,$c(1),6)  //时间单位
				Set TimeUnit=$s(TimeUnit="D":"天",TimeUnit="H":"时",TimeUnit="M":"分",1:"Error")
				Set AmountMin=+$p(RuleExp,$c(1),7) //最小数量
				Set AmountMax=+$p(RuleExp,$c(1),8) //最大数量
				Set RuleRst=..getResultOfB(CPWID,RuleExp)
				Set RuleRst=$s(RuleRst>0:"完成",1:"未完成")
				Set Data=$lb(EpisodeID,RuleID,RuleName,RuleType,RuleItem,$g(ItemName),NormItem,TimeMin_"~"_TimeMax_TimeUnit,AmountMin_"~"_AmountMax,RuleRst)
			}
		}
		If objRule'="" Do objRule.%Close()
		Continue:Data=""
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMonitorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMonitorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMonitorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMonitorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 取A类型监控结果
/// 此方法不能独立运行
ClassMethod getResultOfA(argCPWID As %String, argRuleExp As %String) As %String
{
	New (argCPWID,argRuleExp)
	Set return=""
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argCPWID)
	If $IsObject(objPathWay){
		Set InDate=objPathWay.CPWInDate
		Set InTime=objPathWay.CPWInTime
		Set MRAdm=objPathWay.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	}
	If objPathWay'="" Do objPathWay.%Close()
	Set RuleExp=$g(argRuleExp),EpisodeID=$g(EpisodeID)
	
	Set RuleType=$p(RuleExp,$c(1),1)      //表达式类型
	Quit:RuleType'="A" return
	Set RuleItem=$p(RuleExp,$c(1),2)      //项目(临床路径项目)
	Set ItemArcim=""
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(RuleItem)
	If $IsObject(objItem){
		Set ItemArcim=objItem.CPWSIARCIM
	}
	If objItem'="" Do objItem.%Close()
	Set NormTime=$p(RuleExp,$c(1),3)   //基准时间(入院时间\入径时间)
	Set TimeMin=+$p(RuleExp,$c(1),4)   //最小时间
	Set TimeMax=+$p(RuleExp,$c(1),5)   //最大时间
	Set TimeUnit=$p(RuleExp,$c(1),6)   //时间单位
	Set AmountMin=+$p(RuleExp,$c(1),7) //最小数量
	Set AmountMax=+$p(RuleExp,$c(1),8) //最大数量
	
	If NormTime="1" {   //入院时间
		//Set SDate=+$p($g(^PAADM(EpisodeID)),"^",6)
		//Set STime=+$p($g(^PAADM(EpisodeID)),"^",7)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set SDate=$p(AdmDateTime,"^",1)
		Set STime=$p(AdmDateTime,"^",2)
	}
	If NormTime="2" {   //入径时间
		Set SDate=InDate
		Set STime=InTime
	}
	Set StartDate=$g(SDate),EndDate=$g(SDate)
	Set StartTime=$g(STime),EndTime=$g(STime)
	
	If TimeUnit="D" {
		Set StartDate=SDate+TimeMin
		Set EndDate=SDate+TimeMax
	}
	If TimeUnit="H" {
		Set StartTime=STime+(TimeMin*3600)
		Set EndTime=STime+(TimeMax*3600)
	}
	If TimeUnit="M" {
		Set StartTime=STime+(TimeMin*60)
		Set EndTime=STime+(TimeMax*60)
	}
	
	Set Count=0
	//^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
	Set OrdID=0
	For {
		Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,OrdID))
		Quit:OrdID=""
		Set ItemCount=+ItemArcim.Count()
		For Ind=1:1:ItemCount {
			Set Arcim=ItemArcim.GetAt(Ind).ITMARCIMDR
			Quit:'$d(^OEORDi(0,"ARCIM",OrdID,Arcim))
			Set OrdDate=StartDate-1
			For {
				Set OrdDate=$o(^OEORDi(0,"ARCIM",OrdID,Arcim,OrdDate))
				Quit:(OrdDate="")||(OrdDate>EndDate)
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrdID,Arcim,OrdDate,SubID))
					Quit:SubID=""
					Set OrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)
					Quit:(OrdDate=StartDate)&&(OrdTime<StartTime)
					Quit:(OrdDate=EndDate)&&(OrdTime>EndTime)
					Set Count=Count+1
				}
			}
		}
	}
	If (AmountMin>Count)||(AmountMax<Count) Set return=0
	Quit:(AmountMin>Count)||(AmountMax<Count) return
	
	Set return=Count
	Quit return
}

/// 取B类型监控结果
ClassMethod getResultOfB(argCPWID As %String, argRuleExp As %String) As %String
{
	New (argCPWID,argRuleExp)
	Set return="",Count=0
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argCPWID)
	If $IsObject(objPathWay){
		Set InDate=objPathWay.CPWInDate
		Set InTime=objPathWay.CPWInTime
		Set MRAdm=objPathWay.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	}
	If objPathWay'="" Do objPathWay.%Close()
	Set RuleExp=$g(argRuleExp),EpisodeID=$g(EpisodeID)
	
	Set RuleType=$p(RuleExp,$c(1),1)      //表达式类型
	Quit:RuleType'="B" return
	Set RuleItem=$p(RuleExp,$c(1),2)      //项目(临床路径项目)
	Set ItemArcim=""
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(RuleItem)
	If $IsObject(objItem){
		Set ItemArcim=objItem.CPWSIARCIM
	}
	If objItem'="" Do objItem.%Close()
	Set NormItem=$p(RuleExp,$c(1),3)  //基准项目(临床路径项目)
	Set TimeMin=+$p(RuleExp,$c(1),4)   //最小时间
	Set TimeMax=+$p(RuleExp,$c(1),5)   //最大时间
	Set TimeUnit=$p(RuleExp,$c(1),6)  //时间单位
	Set TimeUnit=$s(TimeUnit="D":"天",TimeUnit="H":"时",TimeUnit="M":"分",1:"Error")
	Set AmountMin=+$p(RuleExp,$c(1),7) //最小数量
	Set AmountMax=+$p(RuleExp,$c(1),8) //最大数量
	
	Set xDateTime=..getNormItemTime()
	Quit:xDateTime="" return
	Set SDate=$p(xDateTime," ",1)
	Set STime=$p(xDateTime," ",2)
	
	Set StartDate=SDate,EndDate=SDate
	Set StartTime=STime,EndTime=STime
	
	If TimeUnit="D" {
		Set StartDate=SDate+TimeMin
		Set EndDate=SDate+TimeMax
	}
	If TimeUnit="H" {
		Set StartTime=STime+(TimeMin*3600)
		Set EndTime=STime+(TimeMax*3600)
	}
	If TimeUnit="M" {
		Set StartTime=STime+(TimeMin*60)
		Set EndTime=STime+(TimeMax*60)
	}
	
	//^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
	Set OrdID=0
	For {
		Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,OrdID))
		Quit:OrdID=""
		Set ItemCount=+ItemArcim.Count()
		For Ind=1:1:ItemCount {
			Set Arcim=ItemArcim.GetAt(Ind).ITMARCIMDR
			Quit:'$d(^OEORDi(0,"ARCIM",OrdID,Arcim))
			Set OrdDate=StartDate-1
			For {
				Set OrdDate=$o(^OEORDi(0,"ARCIM",OrdID,Arcim,OrdDate))
				Quit:(OrdDate="")||(OrdDate>EndDate)
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrdID,Arcim,OrdDate,SubID))
					Quit:SubID=""
					Set OrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)
					Quit:(OrdDate=StartDate)&&(OrdTime<StartTime)
					Quit:(OrdDate=EndDate)&&(OrdTime>EndTime)
					Set Count=Count+1
				}
			}
		}
	}
	Quit:(AmountMin>Count)||(AmountMax<Count) return
	
	Set return=Count
	Quit return
}

ClassMethod getNormItemTime(argNormItem As %String) As %String
{
	New (argNormItem)
	Set return=""
	/*
	Set ItemArcim=""
	Set objItem=##Class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(argNormItem)
	If $IsObject(objItem){
		Set ItemName=objItem.CPWSIDesc    //项目名称
		Set ItemArcim=objItem.CPWSIARCIM  //关联医嘱项
	}
	If objItem'="" Do objItem.%Close()
	*/
	Quit return
}

}
