Class web.DHCPE.CRM.RisGateway Extends %Persistent
{

/// Description: 到达发送申请消息（调用集成平台检查、检验、病理发送消息的方法）
/// Input:       PAADM：就诊ID	
/// Debug:w ##class(web.DHCPE.CRM.RisGateway).GetPAADM("4839","ARRIVED")
ClassMethod GetPAADM(PAADM, IADMStatus)
{
	s ^tempdhcpe("GetPAADM")=PAADM_"^"_IADMStatus
	s ret=""
   	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
    s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
    q:Status'="ARRIVED" "" 
	s oeord=$O(^OEORD(0,"Adm",PAADM,0))
	q:oeord="" ""
	s Ord=$O(^OEORD(0,"Adm",PAADM,0))
	q:Ord="" ""
	
	i (($g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))="B")) d
	.d ..GetPISPAADMOld(PAADM) //发送病理申请
  
	s LisOrdInfo="",RisOrdInfo="",IsRisFlag="",IsLisFlag=""
	
	s Sub=0
	f  s Sub=$O(^OEORD(Ord,"I",Sub)) q:Sub=""  d
	.s OrdItemID=Ord_"||"_Sub
	.s OrdItemID=..GetRequestOEORIStrByOrd(OrdItemID)
	.q:OrdItemID=""
	.s IsLisFlag=$p(OrdItemID,"#",2)
	.s IsRisFlag=$p(OrdItemID,"#",3)
	.i IsLisFlag=1 d
	..i LisOrdInfo="" s LisOrdInfo=$p(OrdItemID,"#",1)
	..e  s LisOrdInfo=LisOrdInfo_"^"_$p(OrdItemID,"#",1)
	.i IsRisFlag=1 d
	..i RisOrdInfo="" s RisOrdInfo=$p(OrdItemID,"#",1)
	..e  s RisOrdInfo=RisOrdInfo_"^"_$p(OrdItemID,"#",1)
	b ;RisOrdInfo,LisOrdInfo
	i RisOrdInfo'=""  s ret=##class(web.DHCPE.CRM.RisGateway).SendRequestInfoNew(RisOrdInfo,LocID,1,0)
    i LisOrdInfo'=""  s ret=##class(web.DHCPE.CRM.RisGateway).SendRequestInfoNew(LisOrdInfo,LocID,0,1)
    q ret
}

/// Description: 单个医嘱调用平台发送/撤销检查、检验申请消息
/// Input:       InfoType:R 发送申请，D 撤销申请, ID:医嘱ID，UserID：操作人ID		 
/// Debug:   d ##class(web.DHCPE.CRM.RisGateway).SendInfo("")
ClassMethod SendInfo(InfoType, ID, UserID As %String = "")
{
	s ret=""

	i UserID="" d
	.s:$D(%session) UserID=%session.Get("LOGON.USERID")
    s:UserID="" UserID=1
    
	s LocID=$p($g(^OEORD($p(ID,"||",1),"I",$p(ID,"||",2),1)),"^",3)	
	q:LocID="" ""
	
	s SendOrderFlag=$g(^DHCPESetting("DHCPE","SendOrder",LocID))
	
 	s arcid=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",2)
	q:arcid="" ""
	
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcid,LocID)
	s STID=$p(StatOrderDR,"||",1)
	q:STID="" ""
	s STDesc=$P($g(^DHCPEST(STID)),"^",2)
 	
 	//发送申请
	i InfoType="R" d
	.i STDesc["病理" d
	..i ($g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))="B") d
	...d ..SendPisApplicationOld(ID)
	.e  d
	..s Strs=..GetRequestOEORIStrByOrd(ID)
	..q:Strs=""
	..s LisFlag=$p(Strs,"#",2)
	..s RisFlag=$p(Strs,"#",3)
	..s ret=..SendRequestInfoNew(ID,LocID,RisFlag,LisFlag)
	e  d   //撤销申请
	.i STDesc["病理" d
	..i ($g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))="B")&&($g(^DHCPESetting("DHCPE","SendPisInterface",LocID))="Y") d
	...//病理撤销申请
	...d ##Class(web.DHCAPPInterface).revPisNo(ID,UserID)
	...q:'$D(^DHCPEDataEx("SendPisRequest",ID))
	...//是否第三方都需要调用,具体控制在平台
	...s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPORDERITEMINFO",ID)
	...k ^DHCPEDataEx("SendPisRequest",ID)
    .e  d
	..s Strs=..GetDropOEORIStrByOrdNew(ID)
	..q:Strs=""
	..s ret=..SendDropInfoNew(ID,LocID)
	q ret
}

/// Description: 获取检查、检验医嘱
/// Return:      医嘱ID_"#"_检验标识_"#"_检查标识
/// Debug: w ##class(web.DHCPE.CRM.RisGateway).GetRequestOEORIStrByOrd("321||5")
ClassMethod GetRequestOEORIStrByOrd(ID)
{
   
	q:'$D(^OEORD(+ID,"I",$p(ID,"||",2),1)) ""
	s LocID=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",3)
	q:LocID="" ""
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
	s OEOrderID=+ID,IADMStatus=""
    s PAADM=$p($g(^OEORD(OEOrderID)),"^",1)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
    Q:Status'="ARRIVED" ""  //不是到达退出
  
	q:$D(^DHCPEDataEx("SendRisRequest",ID)) ""
	q:$D(^DHCPEDataEx("SendLisRequest",ID)) ""
	s PayFlag=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),3)),"^",5)
	q:PayFlag'="P" ""
	s ExFlag=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",13)
	q:ExFlag'="1" ""
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID))
	;q:SendOrderFlag'="Y" ""
	s arcid=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",2)
	s ServMaterial=$P($g(^ARCIM(+arcid,$P(arcid,"||",2),7)),"^",6)
    //q:ServMaterial'="S" ""
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcid,LocID)
	s STID=$p(StatOrderDR,"||",1)
	q:STID="" ""
	s STDesc=$P($g(^DHCPEST(STID)),"^",2)
	q:STDesc["病理" ""
    q:("^"_LabStation_"^"_RisStation_"^")'[("^"_STID_"^") ""
	s LisFlag=0,RisFlag=0
	i (LabStation=STID) d
	.s ^DHCPEDataEx("SendLisRequest",ID)=$H
	.s LisFlag=1
	i ("^"_RisStation_"^")[("^"_STID_"^") d
	.s ^DHCPEDataEx("SendRisRequest",ID)=$H
	.s RisFlag=1
	q ID_"#"_LisFlag_"#"_RisFlag
}

ClassMethod GetDropOEORIStrByOrdNew(ID)
{
	s LocID=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",3)
	q:LocID="" ""
	s arcid=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",2)
	q:arcid="" ""
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcid,LocID)
	s STID=$p(StatOrderDR,"||",1)
	q:STID="" ""
	s STDesc=$P($g(^DHCPEST(STID)),"^",2)
	q:STDesc["病理" ""
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))
   	q:(LabStation=STID)&&('$D(^DHCPEDataEx("SendLisRequest",ID))) ""
   	q:("^"_RisStation_"^")[("^"_STID_"^")&&('$D(^DHCPEDataEx("SendRisRequest",ID))) ""
	s ExFlag=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",13)
	q:ExFlag'="1" ""
    s LisFlag=0,RisFlag=0
	i (LabStation=STID) d
	.k ^DHCPEDataEx("SendLisRequest",ID)
	.s LisFlag=1	
	i ("^"_RisStation_"^")[("^"_STID_"^") d
	.k ^DHCPEDataEx("SendRisRequest",ID)
	.s RisFlag=1
	
	q ID_"#"_LisFlag_"#"_RisFlag
}

/// Description: 调用平台撤销检查、检验申请消息(是否第三方都需要调用,具体控制在平台)
/// Input:       OEORIStrs: 医嘱ID^医嘱ID, LocID:科室ID
/// Debug:  d ##class(web.DHCPE.CRM.RisGateway).SendDropInfoNew("")
ClassMethod SendDropInfoNew(OEORIStrs, LocID As %String = "")
{
	q:OEORIStrs="" ""
	s ret=""
	i LocID="" {
		s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	}
	s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPORDERITEMINFO",OEORIStrs)
	q ret
}

/// Description: 调用平台发送检查、检验申请消息(是否第三方都需要调用,具体控制在平台)
/// Input:       OEORIStrs: 医嘱ID^医嘱ID, LocID:科室ID
/// 			 RisFlag:检查标记, LisFlag:检验标记
/// Debug:  d ##class(web.DHCPE.CRM.RisGateway).SendRequestInfoNew("")
ClassMethod SendRequestInfoNew(OEORIStrs, LocID As %String = "", RisFlag As %String = "", LisFlag As %String = "")
{
	q:OEORIStrs="" ""
	s ret=""
	i LocID="" {
		s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	}
	
	i (RisFlag="1") {
		s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPERISAPPINFO",OEORIStrs)
	}
	i (LisFlag="1") {
		s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPELISAPPINFO",OEORIStrs)
	}
			
	q ret
}

/*
// s val=##class(web.DHCPE.CRM.RisGateway).GetPAADM(7271458, "ARRIVED")
ClassMethod GetPAADM(PAADM, IADMStatus)
{
   	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
    s Status=$p(^DHCPEIADM(IADM),"^",8)
    Q:Status'="ARRIVED" "" 
	;d ##class(web.DHCPE.CRM.Gateway).GetPatientInfoForHH(PAADM)
	s oeord=$O(^OEORD(0,"Adm",PAADM,0))
	q:oeord="" ""
	s ordInfo=""
	;"医嘱RowId^医嘱RowId@发票ID"
	;w ##class(DHCENS.BILL.BS.WebBILLService).OPChargeSend("8733||3")
	s Ord=$O(^OEORD(0,"Adm",PAADM,0))
	q:Ord="" ""
	
	//i (($g(^DHCPESetting("DHCPE","SendPisFBWay"))="B")) d
	i (($g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))="B")) d
	.d ..GetPISPAADMOld(PAADM) //发送病理申请

	s Sub=0
	f  s Sub=$O(^OEORD(Ord,"I",Sub)) q:Sub=""  d
	.s OrdItemID=Ord_"||"_Sub
	.s OrdItemID=..GetRequestOEORIStrByOrd(OrdItemID)
	.q:OrdItemID=""
	.i ordInfo="" d
	..s ordInfo=OrdItemID
	.e  d
	..s ordInfo=ordInfo_"^"_OrdItemID
	;b ;ordInfo
	q:ordInfo="" ""
	s ret=..SendRequestInfo(ordInfo)
	q ret
}
*/

/*
// w ##class(web.DHCPE.CRM.RisGateway).GetRequestOEORIStrByOrd("321||5")
ClassMethod GetRequestOEORIStrByOrd(ID)
{
	q:'$D(^OEORD(+ID,"I",$p(ID,"||",2),1)) ""
	s LocID=$p($G(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",3)
	q:LocID="" ""
	s OEOrderID=+ID,IADMStatus=""
    s PAADM=$p(^OEORD(OEOrderID),"^",1)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s Status=$p(^DHCPEIADM(IADM),"^",8)
    Q:Status'="ARRIVED" ""
    //不是到达退出
	q:$D(^DHCPEDataEx("SendRisRequest",ID)) ""
	s PayFlag=$p(^OEORD(+ID,"I",$p(ID,"||",2),3),"^",5)
	q:PayFlag'="P" ""
	s ExFlag=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",13)
	q:ExFlag'="1" ""
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID))
	q:SendOrderFlag'="Y" ""
	s arcid=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",2)
	s ServMaterial=$P(^ARCIM(+arcid,$P(arcid,"||",2),7),"^",6)
    q:ServMaterial'="S" ""
	s STID=$o(^DHCPEST(0,"STORD_ARCIM",arcid,0))
	//s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	//s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))

	//q:("^"_LabStation_"^"_RisStation_"^27^4^")'[("^"_STID_"^") ""
	s ^DHCPEDataEx("SendRisRequest",ID)=$H
	q ID
}

*/
ClassMethod GetDropOEORIStrByOrd(ID)
{
  
	q:'$D(^DHCPEDataEx("SendRisRequest",ID)) ""
	s ExFlag=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",13)
	q:ExFlag'="1" ""
	k ^DHCPEDataEx("SendRisRequest",ID)
	q ID
}

/// 发送登记消息
/// d ##class(web.DHCPE.CRM.RisGateway).SendRequestInfo("4087711||40")
ClassMethod SendRequestInfo(OEORIStrs)
{
	s ret=""
	;b ;OEORIStrs
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID)) 
	//q:SendOrderFlag'="Y" ""
	q:SendOrderFlag'="Y" "-1^不是第三方,不发送申请消息"
	s ret=##class(DHCENS.BILL.BS.WebBILLService).OPChargeSend(OEORIStrs)
	q ret
	;d ##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService("OPChageADT",OEORIStrs)
	;d ##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService("OPCharge",OEORIStrs)
}

/// 发送取消消息
/// d ##class(web.DHCPE.CRM.RisGateway).SendDropInfo("3964049||44")
ClassMethod SendDropInfo(OEORIStrs)
{
   
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID)) 
	q:SendOrderFlag'="Y" "-1^不是第三方,不发送撤销申请消息"
	q ##class(DHCENS.BILL.BS.WebBILLService).OPRefundChargeSend(OEORIStrs)
	;d ##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService("OPCRefund",OEORIStrs)
}

// d ##class(web.DHCPE.CRM.RisGateway).SendInfo("R",ID)

// d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",ID)

// InfoType:R  申请

//         D  取消

// ID      :  OE_ORDItem

/*
ClassMethod SendInfo(InfoType, ID)
{
 	s ret=""
	i InfoType="R" d
	.s Strs=..GetRequestOEORIStrByOrd(ID)
	.q:Strs=""
	.s ret=..SendRequestInfo(Strs)
	e  d
	.s Strs=..GetDropOEORIStrByOrd(ID)
	.q:Strs=""
	.s ret=..SendDropInfo(Strs)
	q ret
}
*/

/*
ClassMethod SendInfo(InfoType, ID)
{
	s LocID=$p($G(^OEORD($p(ID,"||",1),"I",$p(ID,"||",2),1)),"^",3)	
	q:LocID=""
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID))
 	s ret=""
	i InfoType="R" d
	.s arcid=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",2)
	.s STID=$o(^DHCPEST(0,"STORD_ARCIM",arcid,0))
	.s STDesc=""
	.i STID'="" s STDesc=$P($G(^DHCPEST(STID)),"^",2)
	.i STDesc["病理" d
	..;i ($g(^DHCPESetting("DHCPE","SendPisFBWay"))="B") d
	..i ($g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))="B") d
	...d ..SendPisApplicationOld(ID)
	.e  d
	..s Strs=..GetRequestOEORIStrByOrd(ID)
	..q:Strs=""
	..s ret=..SendRequestInfo(Strs)
	e  d
	.s arcid=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",2)
	.s STID=$o(^DHCPEST(0,"STORD_ARCIM",arcid,0))
	.s STDesc=""
	.i STID'="" s STDesc=$P($G(^DHCPEST(STID)),"^",2)
	.i STDesc["病理" d
	..;i ($g(^DHCPESetting("DHCPE","SendPisFBWay"))="B")&&($g(^DHCPESetting("DHCPE","SendPisInterface"))="Y") d
	..i ($g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))="B")&&($g(^DHCPESetting("DHCPE","SendPisInterface",LocID))="Y") d
	...;d ##Class(web.DHCEMInterface).revPisNo(ID,%session.Get("LOGON.USERID"))
	...d ##Class(web.DHCAPPInterface).revPisNo(ID,%session.Get("LOGON.USERID"))
	...I (SendOrderFlag="Y") D
	....;具体平台方法：按实际项目情况	
	....;d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000042",ID)
    .e  d
	..s Strs=..GetDropOEORIStrByOrd(ID)
	..q:Strs=""
	..s ret=..SendDropInfo(Strs)
	q ret
}
*/
ClassMethod GetPISPAADMOld(PAADM)
{
	
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s oeord=$O(^OEORD(0,"Adm",PAADM,0))
	q:oeord="" ""
	s ordInfo=""
	s Ord=$O(^OEORD(0,"Adm",PAADM,0))
	q:Ord="" ""
	s OrdItemID=""
	s Sub=0
	f  s Sub=$O(^OEORD(Ord,"I",Sub)) q:Sub=""  d
	.s OrdItemID=Ord_"||"_Sub
	.q:'$D(^OEORD(Ord,"I",Sub,1)) 
	.s LocID=$p($G(^OEORD(Ord,"I",Sub,1)),"^",3)
	.q:LocID="" 
	.s markid=$p($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	.q:markid=""
	.s ordtype=$p($G(^OEORD(Ord,"I",Sub,1)),"^",13)
	.q:ordtype'="1"
	.s PayFlag=$p($G(^OEORD(Ord,"I",Sub,3)),"^",5)
	.q:PayFlag'="P" 	
	.s stationid="",STDesc=""
	.;s stationid=$o(^DHCPEST(0,"STORD_ARCIM",markid,0)) 
	.s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(markid,LocID)
	.s stationid=+StatOrderDR //多院区改造
	.q:stationid=""
	.s STDesc=$P($g(^DHCPEST(stationid)),"^",2)
	.q:STDesc'["病理" 
	.;q:$d(^DHCPEMarkPis("mark",OrdItemID,PAADM))
	.q:$d(^DHCPEDataEx("SendPisRequest",OrdItemID))
	.s ARCIMID=$p(markid,"||",1)
	.s ARCIMDesc=$p($g(^ARCIM(+ARCIMID,1,1)),"^",2)
	.s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID))
	.;s SendPisInterface=$g(^DHCPESetting("DHCPE","SendPisInterface"))
	.s SendPisInterface=$g(^DHCPESetting("DHCPE","SendPisInterface",LocID))
	.i SendPisInterface="N" d
	..i ARCIMDesc="脱落细胞学检查与诊断" d
    ...zn "PIS"
    ...;d ##class(Src.PIS3Interface).TJBatchSendApp(OrdItemID,PAADM,"20","宫颈涂片")
    ...zn "DHC-APP"
	..e  d
	...zn "PIS"
    ...;d ##class(Src.PIS3Interface).TJBatchSendApp(OrdItemID,PAADM,"23","液基细胞")
    ...zn "DHC-APP"
    .;s ^DHCPEMarkPis("mark",OrdItemID,PAADM)=$h
    .e  s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPEPISAPPINFO",OrdItemID)
    .s ^DHCPEDataEx("SendPisRequest",OrdItemID)=$h
    
  
    q "ok"
}

ClassMethod GetPISPAADM(PAADM)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
	s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
    
    q:$g(^DHCPESetting("DHCPE","SendPisInterface",LocID))'="Y"
    q:$g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))'="B"

   	s Ord=$O(^OEORD(0,"Adm",PAADM,0))
	q:Ord="" ""
	s locid=$P($G(^PAADM(PAADM)),"^",4) //就诊科室ID
	s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
	s OrdItemID=""
	s Sub=0
	f  s Sub=$O(^OEORD(Ord,"I",Sub)) q:Sub=""  d
	.s OrdItemID=Ord_"||"_Sub
	.s arcid=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),1)),"^",2)
	.q:arcid=""
	.;s STID=$o(^DHCPEST(0,"STORD_ARCIM",arcid,0))
	.s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcid,locid)
	.q:StatOrderID=""
	.s STID=+StatOrderID
	.s STDesc=""
	.i STID'="" s STDesc=$P($G(^DHCPEST(STID)),"^",2)
	.q:STDesc'["病理" 
	.d ..SendPisApplication(OrdItemID)
}

ClassMethod SendPisApplication(ID)
{
	q:'$D(^OEORD(+ID,"I",$p(ID,"||",2),1)) ""
	s OEOrderID=+ID
    s PAADM=$p($g(^OEORD(OEOrderID)),"^",1)
    s locid=$P($G(^PAADM(PAADM)),"^",4) //就诊科室ID
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
	s markid=$p($G(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",2)
	q:markid="" ""
	s PayFlag=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),3)),"^",5)
	s ExFlag=$p($g(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",13)
	q:ExFlag'="1" ""
	S CRMORowId=$O(^DHCPECRMO(0,"OEORI",ID,""))
	Q:CRMORowId="" ""
	S PreIOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",2)
	s DocUserID=$p($g(^DHCPEPreIADM(+PreIOrdItem,"ORDITEM",$p(PreIOrdItem,"||",2))),"^",11) //申请医生ID
	If $g(DocUserID)'="" d
	.Set doctor=$p($g(^SSU("SSUSR",DocUserID)),"^",14)
	.i doctor'="" d
	..s CarPrvTpDR=$p($g(^CTPCP(doctor,1)),"^",4)
	..i CarPrvTpDR'="" s CTCPTType=$p($g(^CT("CPT",CarPrvTpDR)),"^",4)
	..i CTCPTType="DOCTOR" S doctor=doctor
	..E  S doctor=$G(^DHCPESetting("DHCPE","PhyExamDrId",locid))
	i doctor="" s doctor=$G(^DHCPESetting("DHCPE","PhyExamDrId",locid))
	s DocUserID=$o(^SSU("SSUSR",0,"CTPCP",doctor,""))

	S RecLocID=$p($G(^OEORD(+ID,"I",$p(ID,"||",2),3)),"^",6) //接收科室ID
	q:RecLocID="" ""
	Q:$d(^DHCPEMarkPisTemp("mark",ID,PAADM))
	s ARCIMID=$p(markid,"||",1)
	s ARCIMDesc=$p($g(^ARCIM(+ARCIMID,1,1)),"^",2)
	s PISTypeDesc="",PISTypeID="",arNo=""
	
	/***取病理标本(多院区) start***/
	s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(markid,locid)
    s StatOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_locid,StatOrderID,""))  
    i StatOrderSetID'="" s PISTypeID=$lg($g(^CF.PE.StationOrderSetD(StatOrderSetID)),16)
	/***取病理标本(多院区) end***/
	//s PISTypeID=$g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",markid))
	
    i PISTypeID'="" d
    .s PISTypeDesc=$P($G(^DHCAPPTS(PISTypeID)),"^",2)
    .s arNo="1"
	 s flag=""
	/// InPut:mListData - 医嘱项ID^接收科室ID^就诊ID^申请医生ID^申请科室ID^加急标志^冰冻标志^人乳头病毒发现日期^临床病历^临床诊断^^^申请类型^医嘱ID
    ///                    &标本序号^标本标识^标本名字^标本部位^标本数量^拨片/蜡片^原病历号^备注
    s mListData=markid_"^"_RecLocID_"^"_PAADM_"^"_DocUserID_"^"_locid_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_ID_"&"_arNo_"^"_PISTypeID_"^"_PISTypeDesc_"^"_""_"^1"_"^"_""_"^"_""_"^"_""
    s flag=##Class(web.DHCAPPPisInterface).InsPisMas(mListData)
    s ^DHCPEMarkPisTemp("mark",ID,PAADM)=flag
    q "OK"
}

/// 单个医嘱发送申请
ClassMethod SendPisApplicationOld(ID)
{
	
	q:'$D(^OEORD(+ID,"I",$p(ID,"||",2),1)) ""
	s OEOrderID=+ID
    s PAADM=$p(^OEORD(OEOrderID),"^",1)
    s locid=$P($G(^PAADM(PAADM)),"^",4) //就诊科室ID
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
	s markid=$p($G(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",2)
	q:markid="" ""
	s PayFlag=$p(^OEORD(+ID,"I",$p(ID,"||",2),3),"^",5)
	q:PayFlag'="P" ""
	s ExFlag=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",13)
	q:ExFlag'="1" ""
	S CRMORowId=$O(^DHCPECRMO(0,"OEORI",ID,""))
	Q:CRMORowId="" ""
	S PreIOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",2)
	s DocUserID=$p($g(^DHCPEPreIADM(+PreIOrdItem,"ORDITEM",$p(PreIOrdItem,"||",2))),"^",11) //申请医生ID
	S RecLocID=$p($G(^OEORD(+ID,"I",$p(ID,"||",2),3)),"^",6) //接收科室ID
	q:RecLocID="" ""
	;Q:$d(^DHCPEMarkPis("mark",ID,PAADM)) ""
	q:$d(^DHCPEDataEx("SendPisRequest",ID)) ""
	s ARCIMID=$p(markid,"||",1)
	s ARCIMDesc=$p(^ARCIM(+ARCIMID,1,1),"^",2)
	s LocID=$p($G(^OEORD(+ID,"I",$p(ID,"||",2),1)),"^",3)
	q:LocID=""
	s SendOrderFlag=$G(^DHCPESetting("DHCPE","SendOrder",LocID))
	//s SendPisInterface=$g(^DHCPESetting("DHCPE","SendPisInterface"))
	s SendPisInterface=$g(^DHCPESetting("DHCPE","SendPisInterface",LocID))
	i SendPisInterface="N"  d
	.i ARCIMDesc="脱落细胞学检查与诊断" d
    ..zn "PIS"
    ..;d ##class(Src.PIS3Interface).TJBatchSendApp(OrdItemID,PAADM,"20","宫颈涂片")
    ..zn "DHC-APP"
	.e  d
	..zn "PIS"
    ..;d ##class(Src.PIS3Interface).TJBatchSendApp(OrdItemID,PAADM,"23","液基细胞")
    ..zn "DHC-APP"
    e  s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPEPISAPPINFO",ID) //是否第三方都需要调用,具体控制在平台
    ;s ^DHCPEMarkPis("mark",ID,PAADM)=$H
    s ^DHCPEDataEx("SendPisRequest",ID)=$h
    q "OK"
}

// 单独发送放射消息 第一个参数为病人的就诊记录PAADM  EpisodeID

// d ##class(web.DHCPE.CRM.RisGateway).ReSendInfo(12386, "ARRIVED")

ClassMethod ReSendInfo(PAADM As %String, IADMStatus As %String = "ARRIVED")
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
    s Status=$p(^DHCPEIADM(IADM),"^",8)
    Q:Status'="ARRIVED" "" 
	s pmi=$P(^PAADM(PAADM),"^",1)
	s XML="<Request><Patients><PaPatMas><ClassName>web.DHCService.CI.ZSYY.PACS</ClassName><Instruction>SendPACSRequest</Instruction><InterfaceType>ECGDITAN</InterfaceType><PAADMs><PaAdm><EpsodeId>***</EpsodeId><OrdItems><OrdItem><OrdId>***</OrdId></OrdItem></OrdItems></PaAdm></PAADMs><PMI>***</PMI></PaPatMas></Patients><Service>OPCharge</Service></Request>"
	s XML=##class(web.DHCPE.DHCPECommon).Replace(XML,"<EpsodeId>***</EpsodeId>","<EpsodeId>"_PAADM_"</EpsodeId>")
	s XML=##class(web.DHCPE.DHCPECommon).Replace(XML,"<PMI>***</PMI>","<PMI>"_pmi_"</PMI>")
	s oeord=$O(^OEORD(0,"Adm",PAADM,0))
	q:oeord="" ""
	s ordInfo=""
	s locStr=##class(web.DHCPE.CRM.RisGateway).GetXrayLoc(1)
	s locLength=$L(locStr,"^")
	f j=1:1:locLength d
	.s oeordsub=0
	.s loc=$P(locStr,"^",j)
	.f  s oeordsub=$O(^OEORDi(0,"RecDepOrd",oeord,loc,oeordsub)) q:oeordsub=""  d
	..s oeorditem=oeord_"||"_oeordsub
	..//q:$D(^DHCPEOrdItem("RisInfo",oeorditem)) //=$H
	..s stat=$p(^OEORD(oeord,"I",oeordsub,1),"^",13)
	..q:stat'="1"
	..//i ordInfo="" d
	..s ordInfo="<OrdItem><OrdId>"_oeorditem_"</OrdId></OrdItem>"
	..s ^DHCPEOrdItem("RisInfo",oeorditem)=$H
	..s OneXml=##class(web.DHCPE.DHCPECommon).Replace(XML,"<OrdItem><OrdId>***</OrdId></OrdItem>",ordInfo)
	..d ##class(web.DHCService.CI.ZSYY.PACS).DHCPESendPacsInfo(OneXml)
	q ""
}

// w ##class(web.DHCPE.CRM.RisGateway).GetXrayLoc(1)

ClassMethod GetXrayLoc(ParRef)
{
	s locInfo=""
	s childsub=0
	f  s childsub=$O(^User.DHCCITypeDefineD(ParRef,"OrdRule",childsub)) q:childsub=""  d
	.s id=ParRef_"||"_childsub
	.s obj=##class(User.DHCCITypeDefineOrderRule).%OpenId(id)
	.s activeFlag=obj.TORActiveFlag
	.q:activeFlag'="Y"
	.s startDate=obj.TORDateFrom
	.q:(startDate="")||(startDate>+$H)
	.s endDate=obj.TORDateTo
	.q:(endDate'="")&&(endDate<+$H)
	.s recLoc=obj.TORRecLocDR.%Id()
	.q:recLoc=""
	.i locInfo="" d
	..s locInfo=recLoc
	.e  d
	..s locInfo=locInfo_"^"_recLoc
	q locInfo
}

ClassMethod GetItemPrice(OEOrdItemID)
{
	;w ##class(web.DHCPE.CRM.RisGateway).GetItemPrice("286574||25")
	s $ZT="ItemPriceErr"
	q:OEOrdItemID="" ""
	s CRMOrderID=$O(^DHCPECRMO(0,"OEORI",OEOrdItemID,0))
	q:CRMOrderID="" ""
	s PEOrderID=$P(^DHCPECRMO(CRMOrderID),"^",2)
	q:PEOrderID="" ""
	s PreSetsID=$P(^DHCPEPreIADM(+PEOrderID,"ORDITEM",$P(PEOrderID,"||",2)),"^",2)
	s Price=""
	i PreSetsID=""  d
	.s Price=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PEOrderID,"","")
	e  d
	.s Price=$P(^DHCPEPreIADM(+PEOrderID,"ORDITEM",$P(PEOrderID,"||",2)),"^",14)
	q Price
	//q ##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PEOrderID,"","")
ItemPriceErr
	q ""
}

ClassMethod IsRISOrdItem(ID)
{
	s flag=0
	s PAADM=$P(^OEORD(+ID),"^",1)
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
	//s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))

	Q:ID="" "0"
	s arcid=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",2)
	s STID=$o(^DHCPEST(0,"STORD_ARCIM",arcid,0))
	s STDesc=""
	i STID'="" s STDesc=$P($G(^DHCPEST(STID)),"^",2)
	Q:RisStation'[STID "0"
	Q:STDesc["病理" "0"
	i STDesc'["病理" d
	.s flag=1
	q flag
}

ClassMethod IsPISOrdItem(ID)
{
	s flag=0
	Q:ID="" "0"
	s arcid=$p(^OEORD(+ID,"I",$p(ID,"||",2),1),"^",2)
	s STID=$o(^DHCPEST(0,"STORD_ARCIM",arcid,0))
	s STDesc=""
	i STID'="" s STDesc=$P($G(^DHCPEST(STID)),"^",2)
	i STDesc["病理" d
	.s flag=1
	q flag
}

Storage Default
{
<Data name="RisGatewayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CRM.RisGatewayD</DataLocation>
<DefaultData>RisGatewayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CRM.RisGatewayD</IdLocation>
<IndexLocation>^web.DHCPE.CRM.RisGatewayI</IndexLocation>
<StreamLocation>^web.DHCPE.CRM.RisGatewayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
