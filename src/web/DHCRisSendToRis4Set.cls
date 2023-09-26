Import User

Class web.DHCRisSendToRis4Set Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据接受科室获取发送申请信息到RIS4.0标志
/// w ##class(web.DHCRisSendToRis4Set).GetSendRIS4Flag("83")
ClassMethod GetSendRIS4Flag(LocDR As %String) As %String
{
  
    s SendToRIS4="N"
	q:(LocDR="") SendToRIS4
	
	s LPRowID=""
	s LPRowID=$o(^DHCRBC("Loc",LocDR,LPRowID))
	i LPRowID'="" d
	.s SendToRIS4=$p($g(^DHCRBC("LocParam",LPRowID)),"^",21) 
	
	q SendToRIS4
}

/// 根据接受科室获取发送检查信息到RIS4.0标志
/// w ##class(web.DHCRisSendToRis4Set).GetStudyFlag("83")
ClassMethod GetStudyFlag(LocDR As %String) As %String
{
	s SendStudyToRIS4="N"
	q:(LocDR="") SendStudyToRIS4
	
	s LPRowID=""
	s LPRowID=$o(^DHCRBC("Loc",LocDR,LPRowID))
	i LPRowID'="" d
	.s SendStudyToRIS4=$P($g(^DHCRBC("LocParam",LPRowID)),"^",22)
	q SendStudyToRIS4
}

/// 发送申请信息到RIS4系统
ClassMethod SendApptoRis4(MutiOeorditemrowid As %String, XMLConent As %String)
{
   s SendRIS4=""
   s perOrditemRowid=$p(MutiOeorditemrowid,"@",1)
   s RecLocDR=$p($g(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3)),"^",6)
   s SendRIS4=..GetSendRIS4Flag(RecLocDR)
   i SendRIS4="Y" d
   .s ret=##class(RISService.InvokeRISService).InsertAppPACS(MutiOeorditemrowid,XMLConent)
}

/// 取消申请信息发送到RIS4系统
ClassMethod DelApptoRis4(MutiOeorditemrowid As %String)
{
	s Counts=$l(MutiOeorditemrowid,"@")
    f i=1:1:Counts 
    {     
          s SendRIS4="",RecLocDR=""
          s perOrditemRowid=$p(MutiOeorditemrowid,"@",i)
          s RecLocDR=$p($g(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3)),"^",6)
          s SendRIS4=..GetSendRIS4Flag(RecLocDR)
          i SendRIS4="Y" d
          .s ret=##class(RISService.InvokeRISService).DiscontinueAppInfoCacheWS(perOrditemRowid,"")
    }
}

/// 发送登记信息到RIS4系统
/// d ##class(web.DHCRisSendToRis4Set).SendStudytoRIS4("18349||5")
ClassMethod SendStudytoRIS4(MutiOeorditemrowid As %String)
{
	s ^tttt=MutiOeorditemrowid
    /*s perOrditemRowid=$p(MutiOeorditemrowid,"@",1)
    s RecLocDR="",SendRIS4=""
    s RecLocDR=$p($g(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3)),"^",6)
    s SendRIS4=..GetStudyFlag(RecLocDR)
    i SendRIS4="Y" d
	.s regrowid=0
	.s regrowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,regrowid))
	.i regrowid'="" d
	..s StudyNo=""
	..s StudyNo=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
	..s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(StudyNo,"A")*/
	
    s Counts=$l(MutiOeorditemrowid,"@")
    f i=1:1:Counts 
    {
	    s perOrditemRowid=$p(MutiOeorditemrowid,"@",i)
	    s RecLocDR="",SendRIS4=""
	    s RecLocDR=$p($g(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3)),"^",6)
	    s SendRIS4=..GetStudyFlag(RecLocDR)
	    i SendRIS4="Y" d
		.s regrowid=0
		.s regrowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,regrowid))
		.i regrowid'="" d
		..s StudyNo=""
		..s StudyNo=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
		..s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(StudyNo,"A")
	}
}

/// 发送取消登记信息到RIS4系统
ClassMethod SendUnRegtoRIS4(StudyNo As %String, LocDR As %String)
{
	s SendRIS4=""
	s SendRIS4=..GetStudyFlag(LocDR)
    i (SendRIS4="Y")
    {
		i StudyNo'="" d
		.s ret=##class(RISService.InvokeRISService).CancelRegisterPACS(StudyNo)
    }
}

/// 发送预约消息到RIS4系统
/// do ##class(web.DHCRisSendToRis4Set).SendBookedtoRIS4(StudyNo,LocDR)
ClassMethod SendBookedtoRIS4(StudyNo As %String, LocDR As %String)
{
    s SendRIS4=""
    q:(LocDR="")
    s SendRIS4=..GetStudyFlag(LocDR)
    i SendRIS4="Y" d
	.s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(StudyNo,"B")
	.;w !,"ret="_ret
}

/// 发送取消预约消息到RIS4系统
/// do ##class(web.DHCRisSendToRis4Set).SendCanelBookedtoRIS4("")
ClassMethod SendCanelBookedtoRIS4(Oeorditemrowid As %String)
{
	s RecLocDR="",SendRIS4=""
	q:(Oeorditemrowid="")
    s RecLocDR=$p($g(^OEORD($p(Oeorditemrowid,"||",1),"I",$p(Oeorditemrowid,"||",2),3)),"^",6)
    s SendRIS4=..GetStudyFlag(RecLocDR)
    i SendRIS4="Y" d
	 .s ret=##Class(RISService.InvokeRISService).CancelRegisterByOEOridPACS(Oeorditemrowid)
}

/// 函数 RisService
/// 功能：门诊结算后发送检查信息给RIS4.0
/// 参数：InvPrtRowID  发票号
/// 作者：gongping 2014-01-12
/// 调用方式：s ret=##class(web.DHCRisSendToRis4Set).SendOrdInfo("184517")
ClassMethod SendOrdInfo(InvPrtRowID) As %Integer
{
   n (InvPrtRowID)
   s ^TMPInv=InvPrtRowID
   s INVLinkDr="",OEOrdStr=""
	For  Set INVLinkDr=$o(^DHCBCI(0,"INV",InvPrtRowID,INVLinkDr)) Quit:INVLinkDr=""  Do
	.Set Bill=$p(^DHCBCI(INVLinkDr),"^",2)
	.Quit:'$D(^DHCPB(Bill))
	.Set Ord=0
	.For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
	..q:($d(^DHCPB(Bill,"O",Ord))=10)		
	..s perOrditemRowid=$p(^DHCPB(Bill,"O",Ord),"^",4)
	..s RecLocDR=$p($g(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3)),"^",6)
   	..s SendRIS4=..GetSendRIS4Flag(RecLocDR)
   	..i SendRIS4="Y" d
   	...i OEOrdStr="" s OEOrdStr=perOrditemRowid
	...e  s OEOrdStr=OEOrdStr_"@"_perOrditemRowid
    q:OEOrdStr="" 0
    s RetVal=##class(RISService.InvokeRISService).InsertAppPACS(OEOrdStr,"")
	q RetVal
}

}
