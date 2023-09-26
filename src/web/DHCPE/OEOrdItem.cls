Import SQLUser

/// created by Robert 2006/3/29
/// 体检系统中医嘱项的处理
/// 
Class web.DHCPE.OEOrdItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// Description: 取某个ADM的没停止的医嘱及其状态
/// debug:  d ##Class(%ResultSet).RunQuery("web.DHCPE.OEOrdItem","FindOItemStatusForAdm","753530","")
Query FindOItemStatusForAdm(AdmId As %Library.String = "", OEStatus As %Library.String = "", EpisodeID As %String = "", CSPName As %String = "") As %Query(ROWSPEC = "RowId:%String, ItemId:%String, ItemDesc:%String, ItemCode:%String, ItemPrice:%String, StatDesc:%String, statCode:%String, LabNo:%String, BillStatus:%String, Station:%String, Diet:%String, TResultStatus:%String,FactAmount:%String,AccountAmount:%String,TPlacerNo:%String,TSpecName:%String,TPreItemID:%String,TNotPrint:%String,placerCode:%String,TAdmId:%String,UserID:%String,TBloodDate:%String,TDrugStatus:%String,TChecked:%String,OEORIRowId:%String,TRefuseReason:%String,IsYQ:%String,YQDate:%String,RecLocDesc,ARCICOrderType")
{
}

ClassMethod FindOItemStatusForAdmExecute(ByRef qHandle As %Binary, AdmId As %Library.String = "", OEStatus As %Library.String = "", EpisodeID As %String = "", CSPName As %String = "") As %Status
{
	//s ^tempdhcpe("EpisodeID")=$lb(AdmId,OEStatus,EpisodeID)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	s EpisodeID=$G(EpisodeID)
	i EpisodeID'="" s AdmId=EpisodeID
	Q:(""=AdmId) $$$OK
	s Job=$J
	
	k ^TempDHCPE("OEOrdItem",Job)
	s OEORDRowId=0
	s OEORDRowId=$O(^OEORD(0,"Adm",AdmId,OEORDRowId))
	Q:(""=OEORDRowId) $$$OK
	s LocID=$p($g(^PAADM(AdmId)),"^",4)
	s OEORIChildsub=0
	s ret=""
	s iLLoop=1
	f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
	.s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	.s NotPrintFlag=$g(^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEORIRowId))
	.i NotPrintFlag="Y" S NotPrintFlag="1"
	.e  S NotPrintFlag="0"
	.s CRMID=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,""))
	.q:CRMID=""		
	.s PreItemID=$p($g(^DHCPECRMO(CRMID)),"^",2)
	.q:PreItemID=""
	.s RecLoc=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$p(PreItemID,"||",2))),"^",17) //接收科室
	.s RecLocDesc=""
    .i RecLoc'="" s RecLocDesc=$p($G(^CTLOC(RecLoc)),"^",2)
	.s ItemStat=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$p(PreItemID,"||",2))),"^",16)
	.s ARCOS=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",10)
	.s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.q:OEORIItemStatDR=""
	.// OEC_OrderStatus.{OSTAT_Code}
	.s OSTATCode=$P($g(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	.// OEC_OrderStatus.{OSTAT_Desc}
	.s OSTATDesc=$P($g(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
	.s RefuseReason=""
	.If ((OSTATDesc="核实")||(OSTATDesc="Verified"))&($p($g(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)),"^",1)=1) Do
	..Set OSTATDesc="谢绝检查"
	..s RefuseReason=$p($g(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)),"^",5)
	.
	.//ƠƜŏ OEORI_LabEpisodeNo
	.s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
	.
	.// OEORI_ItmMast_DR
	.s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.// ARC_ItmMast.{ARCIM_Desc}
	.s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
	.s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
	.s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.s ARCIMCode=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
	.//s ARCIMPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(OEORIItmMastDR)
	.
	.s ARCICOrderType=""
	.s ItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) 
	.i ItemCatDR'=""  s ARCICOrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7) //医嘱子分类
	.
	.s STInfo=..FromARCIMToStation(OEORIItmMastDR,LocID)
	.s STDesc=$P(STInfo,"^",1)
	.
	.//DHC_PE_StationOrder.{STORD_Diet}
	.s STORDDiet=$P(STInfo,"^",2)
	.
	.// DHC_PE_AsChargedOrder.{}
	.s CRMOID=0
	.s ACOBillStatus="未处理"
	.s FactPrice=""
	.s ARCIMPrice=""
	.f  s CRMOID=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,CRMOID)) q:CRMOID=""  d
	..s ACOBillStatus=$p(^DHCPECRMO(CRMOID),"^",4)
	..s ACOBillStatus=..GetBillStatu(ACOBillStatus)
	..s CRMORI=$p(^DHCPECRMO(CRMOID),"^",2)
	..s IID=$p(CRMORI,"||",1)
	..s Sub=$p(CRMORI,"||",2)
	..s ARCIMPrice=$p($g(^DHCPEPreIADM(IID,"ORDITEM",Sub)),"^",14)
	..i $p(ARCIMPrice,".",1)="" s ARCIMPrice=0_ARCIMPrice
	..s ARCIMPrice=$fn(ARCIMPrice,"",2)
	..s FactPrice=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMORI,"","")
	..i $p(FactPrice,".",1)="" s FactPrice=0_FactPrice
	..s FactPrice=$fn(FactPrice,"",2)
	.s EPVisitDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.s ResultStatus=..GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEORIRowId)
	.s PlacesNo=##class(web.DHCNurCom).GetPlacerNo(OEORIRowId)
	.s SpecName=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
	.s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(OEORIRowId)
	.;s placerCode=$p(placerStr,"^",1)
	.s placerCode=$p(placerStr,"^",5)
    .s BloodDate="" ,PrintUserName=""                                                         
	.i OEORILabEpisodeNo'=""   d
	..;s BloodDate=$p($g(^DHCPETempLabEpisodeNo(OEORILabEpisodeNo)),"^",1)
	..s BloodDate=$p($g(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)),"^",1)
	..i BloodDate'=""  s BloodDate=##class(websys.Conversions).DateLogicalToHtml(BloodDate)                           
	..s PrintUser=$P($G(^DHCPETempLabEpisodeNo(OEORILabEpisodeNo)),"^",3) 
    ..i PrintUser'=""  s PrintUserName=$p($g(^SSU("SSUSR",PrintUser)),"^",2) 
    .s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowId,""),-1)            //add  by zl start
    .s OEDStatus=""
    .i OEDId'=""  d
	..s OEDStatus=$p($G(^DHCOEDISQTY(OEDId)),"^",7)
	..i OEDStatus="C"  s OEDStatus="已发药"
	..i OEDStatus="TC"  s OEDStatus="未发药"
	..i OEDStatus="R"  s OEDStatus="已退药" 
	.s DrugCheck=$d(^DHCPEDataEx("SendPHDRequest",OEORIRowId)) //$d(^DHCPEDataEx("DHCPEDrugApply","SelectId",OEORIRowId))              
	.d OutOItemStatusForAdm
	s i=0
	s PatItemHadPrint=""
	f  s PatItemHadPrint=$O(^TempDHCPE("OEOrdItem",Job,PatItemHadPrint)) q:PatItemHadPrint=""  d
	.s STID=""
	.f  s STID=$O(^TempDHCPE("OEOrdItem",Job,PatItemHadPrint,STID)) q:STID=""  d
	..s LabEpisodeNo=""
	..f  s LabEpisodeNo=$O(^TempDHCPE("OEOrdItem",Job,PatItemHadPrint,STID,LabEpisodeNo)) q:LabEpisodeNo=""  d
	...s ind=""
	...f  s ind=$O(^TempDHCPE("OEOrdItem",Job,PatItemHadPrint,STID,LabEpisodeNo,ind)) q:ind=""  d
	....s i=i+1
	....set Data=$G(^TempDHCPE("OEOrdItem",Job,PatItemHadPrint,STID,LabEpisodeNo,ind))
	....Set ^CacheTemp(repid,i)=Data
	k ^TempDHCPE("OEOrdItem",Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOItemStatusForAdm
	;s STID=+$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(OEORIItmMastDR,LocID)
    i StatOrderDR'="" s STID=$p(StatOrderDR,"||",1)   
	s LabEpisodeNo=+OEORILabEpisodeNo
	s PatItemHadPrint=+$D(^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreItemID))
	s:PatItemHadPrint'=0 PatItemHadPrint=1
	s:PatItemHadPrint=0 ACOBillStatus=ACOBillStatus_"未打"
	s:PatItemHadPrint=1 ACOBillStatus=ACOBillStatus_"已打"
	s IsAsCharged=##class(web.DHCPE.PreAudit).IsAsCharged(CRMORI)
	i IsAsCharged="1" s ACOBillStatus=ACOBillStatus_"(定额卡支付)"
	s IsYQ="否",YQDate=""
	s YQID=$o(^User.DHCPEDelayRecordI("OEORIIndex"," "_OEORIRowId,0))
	i YQID'=""{
		if ($lg(^User.DHCPEDelayRecordD(YQID),4)="Y"){
			s IsYQ="是"
			s YQDate=##class(websys.Conversions).DateLogicalToHtml($lg(^User.DHCPEDelayRecordD(YQID),8))
		}
		}
		
    /***翻译 start***/
	s STDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STDesc,"STDesc","cls")
    s OSTATDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,OSTATDesc)
    s IsYQ=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,IsYQ)
    s ResultStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,ResultStatus)
    s ACOBillStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,ACOBillStatus)
    s OEDStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,OEDStatus)
    s STORDDiet=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,STORDDiet)
    //SpecName
	s ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
    /***翻译 end***/
    
	set Data=$lb(OEORIRowId, OEORIItmMastDR, ARCIMDesc, ARCIMCode, ARCIMPrice, OSTATDesc, OSTATCode, OEORILabEpisodeNo, ACOBillStatus, STDesc, STORDDiet, ResultStatus,FactPrice,ARCIMPrice,PlacesNo,SpecName,PreItemID,NotPrintFlag,placerCode,AdmId,PrintUserName,BloodDate,OEDStatus,DrugCheck,OEORIRowId,RefuseReason,IsYQ,YQDate,RecLocDesc,ARCICOrderType)
	
	s ^TempDHCPE("OEOrdItem",Job,PatItemHadPrint,STID,LabEpisodeNo,ind)=Data
	;Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

ClassMethod FindOItemStatusForAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOItemStatusForAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOItemStatusForAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOItemStatusForAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 得到账单状态
ClassMethod GetBillStatu(Statu)
{
	s StatuDesc=""
	i Statu="NP" s StatuDesc="未付费"
	i Statu="OC" s StatuDesc="挂帐"
	i Statu="P" s StatuDesc="付费"
	i Statu="PP" s StatuDesc="部分付费"
	q StatuDesc
}

/*ClassMethod GetResultStatus(episodeNo, arcItemId, arcos, oeorirowid)
{
	i episodeNo="" q ""
	s labItemCode=""
	//&sql(select Ext_code into:labItemCode from sqluser.arc_itemexternalcodes 
	//			where ext_parRef=:arcItemId)
		
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	//s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	
	//i TrakVerison="MedTrak"
	//{
		//s StationID=$o(^DHCPEST(0,"STORD_ARCIM",arcItemId,0))
		//i LabStation=StationID
		//{
			//s Sub=$o(^DHCPEST(0,"STORD_ARCIM",arcItemId,StationID,0))
			//s arcos=$p(^DHCPEST(StationID,"O",Sub),"^",3)
		//}
		
	//}
	
	s ExtCode=""
	
	//i TrakVerison="TrakCare" d
	//.Quit:$g(arcItemId)=""
	//.Quit:'$d(^ARCIM(+arcItemId,1,"EXT"))
	//.Set Ext=$o(^ARCIM(+arcItemId,1,"EXT",0))
	//.Quit:$g(Ext)=""
	//.Set ExtCode=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",4)
	
	i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) Set ExtCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
	
	s RLTID=$O(^DHCPERLT(0,"OEORI",oeorirowid,0))
	i RLTID'="" q "已回传"

	i "MedTrak"=TrakVerison d
	.Quit:$g(arcos)=""
	.s ExtCode=$P($G(^ARCOS(arcos)), "^", 11)
	
	
	i ExtCode="" q ""
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s ^DHCTemp("jdl")=episodeNo_","_ExtCode
	s ^lisatest("0414","GetResultStatus",arcItemId)=arcItemId_"^"_ExtCode
	s labItemStatus=$P($g(^[namespaceLab]TEPI(episodeNo,1,ExtCode,1)),"\",31)
	;w episodeNo_"^"_ExtCode_"^"_labItemStatus,!
	q:(labItemStatus="A") "已发送"
	q:(labItemStatus="P") "检验状态错误"
	
	i oeorirowid'=""
	{
	s ORIStat=$p($G(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)),"^",13)
	q:ORIStat=6 "已接收标本"
	}
	
	
	if $g(^DHCPETempLabEpisodeScan(episodeNo))'=""  q "已采"
	if $g(^DHCPETempLabEpisodeNo(episodeNo))'=""  q "已打印"
	q "未打印"
	
	
	
	i "MedTrak"=TrakVerison 
	{
		///安贞、友谊用
		if $g(^DHCCLLABBLOOD("BLOOD",oeorirowid))'=""  q "已采"
		q "未采"
	}
	
	q "未发送"
	//s aa=^DHCCLLABBLOOD("BLOOD",arcItemId)
	///20070417
	s Flag=0
	s Sub=0
	f  s Sub=$o(^OEORD($p(arcItemId,"||",1),"I",$p(arcItemId,"||",2),"X",Sub)) q:(Sub="")||(Flag=1)  d
	.s Date=$p(^OEORD($p(arcItemId,"||",1),"I",$p(arcItemId,"||",2),"X",Sub),"^",1)
	.i Date'="" s Flag=1
	i Flag=1 q "已采"
	q "未采"
	//q "未发送"
}
*/
/// 根据检验标本号得到检验结果
ClassMethod GetResultStatus(episodeNo, arcItemId, arcos, oeorirowid)
{
	i episodeNo="" q ""
	s labItemCode=""
	//&sql(select Ext_code into:labItemCode from sqluser.arc_itemexternalcodes 
	//			where ext_parRef=:arcItemId)
	s PAADM=$p(^OEORD(+oeorirowid),"^",1)
	s LocID=$P($G(^PAADM(PAADM)),"^",4)

	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	//s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
	
	/*s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	i TrakVerison="MedTrak"
	{
		s StationID=$o(^DHCPEST(0,"STORD_ARCIM",arcItemId,0))
		i LabStation=StationID
		{
			s Sub=$o(^DHCPEST(0,"STORD_ARCIM",arcItemId,StationID,0))
			s arcos=$p(^DHCPEST(StationID,"O",Sub),"^",3)
		}
		
	}*/
	
	s ExtCode=""
	/*
	i TrakVerison="TrakCare" d
	.Quit:$g(arcItemId)=""
	.Quit:'$d(^ARCIM(+arcItemId,1,"EXT"))
	.Set Ext=$o(^ARCIM(+arcItemId,1,"EXT",0))
	.Quit:$g(Ext)=""
	.Set ExtCode=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",4)
	*/
	i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) Set ExtCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
	
	s RLTID=$O(^DHCPERLT(0,"OEORI",oeorirowid,0))
	i RLTID'="" q "已回传"

	i "MedTrak"=TrakVerison d
	.Quit:$g(arcos)=""
	.s ExtCode=$P($G(^ARCOS(arcos)), "^", 11)
	
	
	i ExtCode="" q ""
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
	
	i LisNewVersion="Y" d
	.s LisReportInfo=##Class(LabService.TSInfomation).GetLabInfo(oeorirowid)
	.s labItemStatus=$P(LisReportInfo,$c(2),73) 
	e  d
	.s labItemStatus=$P($g(^[namespaceLab]TEPI(episodeNo,1,ExtCode,1)),"\",31)
	.;w episodeNo_"^"_ExtCode_"^"_labItemStatus,!
	q:(labItemStatus="A") "已发送"
	q:(labItemStatus="P") "检验状态错误"
	q:(labItemStatus="3") "已发送"
	i oeorirowid'=""
	{
	s ORIStat=$p($G(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)),"^",13)
	q:ORIStat=6 "已接收标本"
	}
	
	
	if $g(^DHCPETempLabEpisodeScan(episodeNo))'=""  q "已采"
	if $g(^DHCPETempLabEpisodeNo(episodeNo))'=""  q "已打印"
	q "未打印"
	
	
	
	i "MedTrak"=TrakVerison 
	{
		///安贞、友谊用
		if $g(^DHCCLLABBLOOD("BLOOD",oeorirowid))'=""  q "已采"
		q "未采"
	}
	
	q "未发送"
	//s aa=^DHCCLLABBLOOD("BLOOD",arcItemId)
	///20070417
	s Flag=0
	s Sub=0
	f  s Sub=$o(^OEORD($p(arcItemId,"||",1),"I",$p(arcItemId,"||",2),"X",Sub)) q:(Sub="")||(Flag=1)  d
	.s Date=$p(^OEORD($p(arcItemId,"||",1),"I",$p(arcItemId,"||",2),"X",Sub),"^",1)
	.i Date'="" s Flag=1
	i Flag=1 q "已采"
	q "未采"
	//q "未发送"
}

ClassMethod GetRisResultStatus(ARCIM, oeorirowid)
{
   
    s Status="未登记"
	s RARRowId=$o(^DHCPACRegInfoi("OEORI",oeorirowid,0))
    q:$g(RARRowId)="" "未登记"
	s Status="登记"
    s RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	s DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
	q:($g(DRPTRowId)="") "登记"
	s RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
    s RisItemStatus=$p($G(^DHCRBCStatus("ReportStatus",RisItemStatus)),"^",1)
    i RisItemStatus="S"  s Status="审核"
    i RisItemStatus="V"  s Status="发布"
    s RLTID=$O(^DHCPERLT(0,"OEORI",oeorirowid,0))
	i RLTID'="" q "已回传"
    q Status
}

/*
ClassMethod FromARCIMToStation(ARICM)
{

	q:ARICM="" ""
	s STID=$O(^DHCPEST(0,"STORD_ARCIM",ARICM,0))
	
	q:STID="" ""
	s STation=$P(^DHCPEST(STID),"^",2)
	s STSub=$O(^DHCPEST(0,"STORD_ARCIM",ARICM,STID,0))
	s Diet=$P(^DHCPEST(STID,"O",STSub),"^",2)
	s DietSesc=""
	i ("Preprandial"=Diet)||("PRE"=Diet) s DietSesc="空腹项目"
	i ("Postprandial"=Diet)||("POST"=Diet) s DietSesc="餐后项目"
	
	Q STation_"^"_DietSesc
}
*/
/// Creator：	   xy
/// CreatDate：	   20210830
/// Description:   根据医嘱项ID查找对应站点描述和就餐情况
/// Input:         ARICM(医嘱项ID),LocID(科室ID)
/// Return：       return=站点描述^就餐情况
/// dubug: w ##class(web.DHCPE.OEOrdItem).FromARCIMToStation()
ClassMethod FromARCIMToStation(ARICM As %String = "", LocID As %String = "")
{
	s ^tempdhcpe("FromARCIMToStation")=$lb(ARICM,LocID)
	q:ARICM="" ""
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARICM,LocID)
	s STID=+StatOrderDR
	q:STID="" ""
	s STationDesc=$P($g(^DHCPEST(STID)),"^",2) //站点描述
	s StatOrderSetID="",Diet=""
	i StatOrderDR'="" s StatOrderSetID=$O(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
	i StatOrderSetID'="" s Diet=$lg($g(^CF.PE.StationOrderSetD(StatOrderSetID)),4)  //就餐
	s DietSesc=""
	i ("Preprandial"=Diet)||("PRE"=Diet) s DietSesc="空腹项目"
	i ("Postprandial"=Diet)||("POST"=Diet) s DietSesc="餐后项目"
	Q STationDesc_"^"_DietSesc
}

/// ******************************************************************
/// add by jdl
/// w ##class(web.DHCPE.OEOrdItem).TransOrder(113,"PREREG")
ClassMethod TransOrder(peAdmid, Status)
{
	
	s err=""
	s admid=""
	;&SQL(select IADM_PAADM_DR into :admid from sqluser.DHC_PE_IADM where IADM_RowId=:peAdmid)
	s admid=$P(^DHCPEIADM(peAdmid),"^",1)
	s curDate=+$H
	i admid=""  q "没有找到对应的PAAdm"
	s OrdId=0
	f  s OrdId=$o(^OEORD(0,"Adm",admid,OrdId)) q:((OrdId="")||(err'=""))  d
	.s OrdItem=0
	.f  s OrdItem=$o(^OEORD(OrdId,"I",OrdItem)) q:((OrdItem="")||(err'=""))  d
	..//s err=OrdId_"||"_OrdItem
	..//q
	..s BillFlag=$p($g(^OEORD(OrdId,"I",OrdItem,3)),"^",5)
	..s OrdStat=$p($g(^OEORD(OrdId,"I",OrdItem,1)),"^",13)
	..s OriRowId=OrdId_"||"_OrdItem
	..s billStatus=""
	..//&sql(select %INTERNAL(CRMO_BillStatus) into :billStatus from sqluser.dhc_pe_crmorder where crmo_oeori_dr=:OriRowId) 
	..s billStatus=$o(^DHCPECRMO(0,"OEORI",OriRowId,0))
	..i billStatus'="" s billStatus=$p($g(^DHCPECRMO(billStatus)),"^",4)
	..i (Status="ARRIVED")  d   ///如果是到达
	...i (((BillFlag="TB")!(BillFlag="B"))&((billStatus="OC")||(billStatus="P"))) d
	....//&sql(update sqluser.OE_OrdItem set Oeori_Billed="P" where oeori_rowid=:OriRowId)
	....&sql(update sqluser.OE_OrdItem set Oeori_Billed='P',OEORI_SttDat=:curDate where oeori_rowid=:OriRowId)
	....i SQLCODE  s err="更新医瞩状态失败!  SQLCODE="_SQLCODE
	..e  d     ///如果是取消
	...i ((OrdStat=1)&(billStatus'="P")) d //医嘱状态是核实
	....&sql(update sqluser.OE_OrdItem set Oeori_Billed='TB' where oeori_rowid=:OriRowId)
	....///s ^DHCTemp("jdl",OriRowId)="update sqluser.OE_OrdItem set Oeori_Billed='TB' where oeori_rowid="_OriRowId_" SQLCODE:"_SQLCODE
	....///&sql(delete from sqluser.dhc_pe_crmorder where crmo_oeori_dr=:OriRowId)
	....i SQLCODE  s err="更新医瞩状态失败!  SQLCODE="_SQLCODE
	q err
}

/// 获取系统设置的体检费医瞩项
/// w ##class(web.DHCPE.OEOrdItem).GetPEArcItem(a)
ClassMethod GetPEArcItem(arcItemId, LocID As %String = "")
{
	//new arcSub,arcVer
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	//s arcItemId=^DHCPESetting("DHCPE","Group'sOEArcItemId")
	s arcItemId=^DHCPESetting("DHCPE","Group'sOEArcItemId",LocID)
	if (arcItemId="") q "没有设置体检医瞩项"
	s arcSub=$p(arcItemId,"||",1)
	s arcVer=$p(arcItemId,"||",2)
	if ((arcSub="")||(arcVer="")) q "体检医瞩项设置不正确"
	if ($g(^ARCIM(arcSub,arcVer,1))="") q "体检医瞩项设置不正确"
	q ""
}

ClassMethod UpdateBarInfo(strings, Type)
{
	s Date=+$H
	s Time=$P($H,",",2)
	s userId=%session.Get("LOGON.USERID")
	s stringsLength=$L(strings,"^")
	TSTART
	for j=1:1:stringsLength
	{
		s oneInfo=$p(strings,"^",j)
		s oeoreId=$p(oneInfo,";",1)
		s placerNo=$p(oneInfo,";",2)
	    s LabNo=$p(oneInfo,";",3)
		s ErrInfo=##class(web.DHCNurCom).SetPlacerNo(userId,oeoreId,placerNo,Type) //,Type
		i ErrInfo'=0 Goto Err
		i (ErrInfo=0)&&(Type="N") d
	    .s ^DHCPETempLabEpisodeNo(LabNo)=Date_"^"_Time_"^"_userId
	    .s ^DHCPETempLabEpisodeNo("Date",Date,Time,LabNo)=""
		i (ErrInfo=0)&&(Type="Y") d
		.K ^DHCPETempLabEpisodeNo(LabNo)
		.k ^DHCPETempLabEpisodeNo("Date")
		s Status=..SetPatStatus(oeoreId)
		//s Status=..SetOtherStationStatus(oeoreId)
	}
	TCOMMIT
	q 0
Err
	TROLLBACK
	q ErrInfo
}

ClassMethod SaveNotPrintInfo(strings)
{
	s ret=0
 s stringsLength=$L(strings,"^")
 for j=1:1:stringsLength
 {s info=$p(strings,"^",j)
  s OEID=$P(info,";",1)
  s NotPrintInfo=$P(info,";",2)
  s falg=$P(NotPrintInfo,"^",1)
  i (falg="Y")&&('$d(^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEID))) s ret=1
  i (falg'="Y")&&($d(^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEID))) s ret=1
  
  i falg="Y"  d
  .s ^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEID)=falg
  else  d
   .k ^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEID)
 
}
 i ret=0 q "请先勾选或者取消勾选报告上不打印"
 q 0
}

ClassMethod SaveOneNoPrint(OEID, falg)
{
	i OEID="" q "数据异常"
 	 i falg="Y"  d
  	 .s ^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEID)=falg
  	 else  d
   	 .k ^DHCPEDataEx("DHCPEOrdItem","NotPrint",OEID)
   	 q 0
}

ClassMethod SetPatStatus(OEOrdItem)
{
 	s CRMORowId=0
	s CRMORowId=$O(^DHCPECRMO(0,"OEORI",OEOrdItem,CRMORowId))
	q:CRMORowId="" ""
  	s IADMDR=$p(^DHCPECRMO(CRMORowId),"^",3)
  	s PIADMDR=$P(^DHCPEIADM(IADMDR),"^",4)
  	d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PIADMDR)

 	q ""
}

ClassMethod GetColor(OEORIRowId)
{
	s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(OEORIRowId)
	s placerCode=$p(placerStr,"^",1)
	q:placerCode="C" "灰"
	q:placerCode="R" "红"
	q:placerCode="P" "粉"
	q:placerCode="Y" "黄"
	q:placerCode="G" "绿"
	q:placerCode="A" "紫"
	q:placerCode="H" "黑"
	q:placerCode="B" "蓝"
	q:placerCode="W" "白"
	q:placerCode="O" "褐"
	q:placerCode="Q" "橙"
	q ""
}

// d ##class(web.DHCPE.OEOrdItem).OutSendInfoButton()

ClassMethod OutSendInfoButton(OEORIID)
{
	s Info=""
	s HadRequestInfo=##class(web.DHCRisApplicationBill).IsSendAppBill(OEORIID)
	s:HadRequestInfo="Y" Info="有申请"
	s ARICM=$P(^OEORD(+OEORIID,"I",$P(OEORIID,"||",2),1),"^",2)
	s STID=$O(^DHCPEST(0,"STORD_ARCIM",ARICM,0))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s RisStation="^"_RisStation_"^"
	q:RisStation'[("^"_STID_"^") ""
	;i $D(^DHCPEDataEx("SendRisRequest",OEORIID)) d
	;.s Info=Info_";已发送"
	w Info
	s StatID=$P(^OEORD(+OEORIID,"I",$P(OEORIID,"||",2),1),"^",13)
	q:StatID'="1"
	w "<button id='"_OEORIID_"^send' onclick=SendInfo(this)>发送</button>"
	w:$D(^DHCPEDataEx("SendRisRequest",OEORIID)) "<button id='"_OEORIID_"^cancel' onclick=CancelSendInfo(this)>取消</button>"
	;w "<button id='"_OEORIID_"' onclick=CancelSendInfo(this)>取消</button>"  //wbg20140902
}

ClassMethod SendInfo(OEORIID)
{
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID)) 
	q:SendOrderFlag'="Y" "-1^不是第三方,不发送申请消息"
	s PayFlag=$p(^OEORD(+OEORIID,"I",$p(OEORIID,"||",2),3),"^",5)
	q:PayFlag'="P" "-1^没有付费,不能发送"
	s ^DHCPEDataEx("SendRisRequest",OEORIID)=$H
	q ##class(web.DHCPE.CRM.RisGateway).SendRequestInfo(OEORIID)
}

ClassMethod CancelSendInfo(OEORIID)
{
	;q:'$D(^DHCPEDataEx("SendRisRequest",OEORIID)) 0
	k ^DHCPEDataEx("SendRisRequest",OEORIID)
	q ##class(web.DHCPE.CRM.RisGateway).SendDropInfo(OEORIID)
}

// d ##class(web.DHCPE.OEOrdItem).GetGlobal()

ClassMethod GetGlobal()
{
	s LabNo=0
	f  s LabNo=$o(^DHCPETempLabEpisodeNo(LabNo))  q:LabNo=""  d
	.s Date=$P($g(^DHCPETempLabEpisodeNo(LabNo)),"^",1)
	.s Time=$P($g(^DHCPETempLabEpisodeNo(LabNo)),"^",2)
	.s userId=$P($g(^DHCPETempLabEpisodeNo(LabNo)),"^",3)
	.i (Date'="")&&(Time'="")&&(userId'="") s ^DHCPETempLabEpisodeNo("Date",Date,Time,LabNo)=""
}

/// 到达时更新医嘱状态为核实，取消到达时更新医嘱状态为预开
ClassMethod UpdateOEStat(PAADM)
{
	Set admloc=$p(^PAADM(PAADM),"^",4)
	q:$G(^DHCPESetting("DHCPE","PreOrder",admloc))'="1" 0
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s PStat=$o(^OEC("OSTAT",0,"Code","P",""))
	q:PStat="" 0
	s VStat=$o(^OEC("OSTAT",0,"Code","V",""))
	s (NewStat,OldStat)=""
	i IADM'="" d
	.s ADMStatus=$P(^DHCPEIADM(IADM),"^",8)
	.i ADMStatus="REGISTERED" d
	..s NewStat=PStat
	..s OldStat=VStat
	.i ADMStatus="ARRIVED" d
	..s NewStat=VStat
	..s OldStat=PStat
	q:NewStat="" 0
	s SQLCODE=0
	&SQL(Update Sqluser.OE_OrdItem Set OEORI_Itemstat_DR=:NewStat where OEORI_OEORD_Parref->OEORD_Adm_DR=:PAADM and OEORI_ItemStat_DR=:OldStat)
	s:SQLCODE=100 SQLCODE=0
	q SQLCODE
}

// pacs是否为第三方

ClassMethod ISSendOrder()
{
	s flag=0
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID)) 
	i SendOrderFlag="Y" s flag=1
	q flag
}

}
