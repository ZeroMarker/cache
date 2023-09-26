Class web.DHCPE.TransResultEx Extends %Persistent
{

ClassMethod SetArrowInfo(admId As %String, ordItmId As %String)
{
	//w ##class(web.DHCPE.TransResultEx).TransLabResultForXH(4078629,5918,"4006928||35")
	//s ^wrzResult(ordItmId)=admId_"^"_UserId
	q:'$D(^DHCPERLT(0,"OEORI",ordItmId))
	 s LocID=$P($G(^PAADM(admId)),"^",4)
	s episodeNo="", itemStatusDr="", OEIId=""
	s labItemCode=""
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
	s CurSpace=$ZNSpace
	s OEIId=ordItmId
	q:(OEIId="") "Error: No correct OEORDItem!"	//已停止
	s itemStatusDr=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s arcItemId=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",2)
	s episodeNo=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",20)
	q:($g(episodeNo)="") "Error: EpisodeNo is Null!"
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	//取检验外部代码
	s labItemCode=""
	s labItemCode=$O(^TEPI(episodeNo,1,""))
	q:labItemCode="" "NoLabItemCode"
	
	//判断检验状态
	s labItemStatus=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",31)
	s Job=$J
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface",LocID))
	i LisInterface="N"  d
	.s num=""
  	.f  s num=$o(^TTAB("TS",labItemCode,0,num))  q:num=""  d
  	..s LabItemDetailCode=$p($g(^TTAB("TS",labItemCode,0,num)),"\",8)
  	..d TransResult
  	else  d
	.d ..SetArcimInfo(episodeNo,+ordItmId,Job)
	.s LabItemDetailCode=""
	.f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	..d TransResult
	k ^TempDHCPETransResult(Job,"TranResult")
	Q "Over"
TransResult
	
	s IsNormal=1
	s Code=$$ALPHAUP^SSUTIL4(LabItemDetailCode)
	s ItemID=""
	q:Code=""
	s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
	i stationID="" d
	.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetail(LabItemDetailCode)
	e  d
	.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
	.s ItemID=stationID_"||"_sub
	q:ItemID=""
	s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
	i '$D(^TempDHCPETransResult(Job,"TranResult",ODDesc))
	{
		;s ^DHCPENoRelateDetailResult(+$H,episodeNo,labItemCode,LabItemDetailCode)=OEIId
		q
	}
	s CurOEID=$G(^TempDHCPETransResult(Job,"TranResult",ODDesc))
	s CurArcimID=$p(^OEORD($p(CurOEID,"||",1),"I",$p(CurOEID,"||",2),1),"^",2)
	s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
	s HLFlag=$p(labResult,"\",2)
	S labResult=$p(labResult,"\",1)
	q:labResult=""
	s LabResultStr=""
	s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,CurOEID,ItemID,0))
	w RLTID_"^"_HLFlag,!
	s:HLFlag'="" ^wrzTempHL(HLFlag)=RLTID
	q
	q:RLTID=""
	;q:$D(^DHCPEDataEx("DHCPEResult",RLTID,"HLFlag"))
	s ^DHCPEDataEx("DHCPEResult",RLTID,"HLFlag")=HLFlag
	
	q
}

ClassMethod TransLabResultForXH(admId As %String, UserId As %String, ordItmId As %String)
{
	//w ##class(web.DHCPE.TransResultEx).TransLabResultForXH(6672698,5918,"6549675||2")
	//s ^wrzResult(ordItmId)=admId_"^"_UserId
	s episodeNo="", itemStatusDr="", OEIId=""
	s labItemCode=""
	s LocID=$P($G(^PAADM(admId)),"^",4)
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	q:'$d(^DHCPESetting("NAMESPACE","LABDATA",LocID)) "该科室没有配置"
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)

	s CurSpace=$ZNSpace
	s OEIId=ordItmId
	q:(OEIId="") "Error: No correct OEORDItem!"	//已停止
	s itemStatusDr=$p($G(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",13)
	q:itemStatusDr="" ""
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	
	// 删除核实状态的医嘱的结果 检验撤销等
	i itemStatusDr="1" d
	.s ResultID=0
	.f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	..&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)
	
	//i OEIId="6107560||112" s OEIId="6107560||1"
	s arcItemId=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",2)
	s episodeNo=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",20)
	q:($g(episodeNo)="") "Error: EpisodeNo is Null!"
	s admId=$P(^OEORD(+OEIId),"^",1)
	
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	
	//取检验外部代码
	s labItemCode=""
	/*同一标本号回传不同医嘱*/
	s LabItemSetID=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",35)
	q:LabItemSetID="" "外部代码错误"_LabItemSetID
	s labItemCode=$p(LabItemSetID,"||",2)
	q:labItemCode="" "NoLabItemCode"
	/*同一标本号回传到一个医嘱*/
	/*
	s labItemCode=$O(^TEPI(episodeNo,1,""))
	q:labItemCode="" "NoLabItemCode"
	*/
	
	//判断检验状态
	s labItemStatus=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",31)
	q:(labItemStatus'="A") "检验报告未发送"	//A: Authorised, 已发送
	//取检验录入日期   2007-07-27
	s AuditDate=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",4)
	s AuditTime=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",5)
	s AuditTime=AuditTime*60
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	if (##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited"){
		s PEAuditDate=..GetAuditDate(admId)
		if (PEAuditDate<AuditDate){
			d ##Class(web.DHCPE.TransResult).NoticeAuditDoc(admId,ordItmId)
		
		}
	
	
	}
	
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") "已总检" //总检已经审核
	
	
	;Quit:(AuditDate<TranedDate) "Date"  //判断是否传输过
	;Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
	s sex=$P($g(^TEPI(episodeNo)),"\",3)
    s age=$P($g(^TEPI(episodeNo)),"\",25)
	Set myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(admId)
	Set mySex=$p(myStr,"^",2)
	Set myAge=$p(myStr,"^",1)    
	//审核人 2008-06-04
	s AuditUser=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",6)
	/*
	i AuditUser'="" d
	.s AuditUser=$ZCVT(AuditUser,"U")
	.s AuditUser=$O(^SSU("SSUSR",0,"SSUSR_Initials",AuditUser,""))
	*/
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser
	s Job=$J
	k ^TempDHCPETransResult(Job,OEIId)
	//s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface",LocID))
	i LisInterface="N"  d
	.s num=""
  	.f  s num=$o(^TTAB("TS",labItemCode,0,num))  q:num=""  d
  	..s LabItemDetailCode=$p($g(^TTAB("TS",labItemCode,0,num)),"\",8)
  	..d TransResult
  	else  d
	.d ..SetArcimInfo(episodeNo,+ordItmId,Job)
	.b ;^TempDHCPETransResult
	.s LabItemDetailCode=""
	.f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	..d TransResult
	k ^TempDHCPETransResult(Job,"TranResult")
	
	// 删除多的细项结果 
	s ResultID=0
	f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	.q:$D(^TempDHCPETransResult(Job,OEIId,ResultID))
	.&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)
	k ^TempDHCPETransResult(Job,OEIId)
	
	Q "Over"
TransResult

	s IsNormal=1
	s Code=$$ALPHAUP^SSUTIL4(LabItemDetailCode)
	s ItemID=""
	q:Code=""
	s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
	i stationID="" d
	.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetail(LabItemDetailCode)
	e  d
	.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
	.s ItemID=stationID_"||"_sub
	q:ItemID=""
	s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
	i ODDesc="备注"
	{
		s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
		s ResultSort=$p(labResult,"\",9)
		s:ResultSort="" ResultSort="999999999"
		S labResult=$p(labResult,"\",1)
		s ^DHCPERLT("LabSpecNo",episodeNo)=labResult //备注信息
		q
	}
	i '$D(^TempDHCPETransResult(Job,"TranResult",ODDesc))
	{
		s ^DHCPENoRelateDetailResult(+$H,episodeNo,labItemCode,LabItemDetailCode)=OEIId
		q
	}
	s CurOEID=$G(^TempDHCPETransResult(Job,"TranResult",ODDesc))
	s CurArcimID=$p(^OEORD($p(CurOEID,"||",1),"I",$p(CurOEID,"||",2),1),"^",2)
	s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
	s ResultSort=$p(labResult,"\",9)
	s:ResultSort="" ResultSort="999999999"
	s HLFlag=$p(labResult,"\",2)
	S labResult=$p(labResult,"\",1)
	q:labResult=""
	s LabResultStr=""
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface",LocID))
	if LisInterface="N" d
	.If $g(labResult)'="" Do
	..s CurSpace=$ZNSpace
	..zn namespaceLab
	..s LabResultStr=$$TestItmRes^CHDhcLabReport(episodeNo,LabItemDetailCode,labResult,AuditDate)
	..zn CurSpace
    ..i LabResultStr'="" s labResult=$p(LabResultStr,$c(2),4)
	..s NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(ItemID,mySex,myAge)
	..s Unit=$p(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2)),"^",4)
	else  d
	.s NormalStr=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Ranges"))
	.s Unit=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Unit"))
	i HLFlag'="" d
	.s IsNormal="0"
	e  d
	.s IsNormal=##class(web.DHCPE.TransResult).LabIsNormal(NormalStr,LabItemDetailCode,labResult)
	//s CTTCTComm=$s(IsNormal=0:1,IsNormal=1:0)
	/*
	i LabResultStr'=""   d
	.s NormalFlag=$p(LabResultStr,$c(2),11)
	.i (NormalFlag="A")||(NormalFlag="P") s IsNormal="0"
	.else  s IsNormal="1"
	*/
	s UserId=$p($g(^TEPI(episodeNo,1,labItemCode,1)),"\",3)
	/*
	i (UserId'="")&&(LisInterface="Y") d
	.s UserId=$ZCVT(UserId,"U")
	.s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserId,""))
	*/
	//i UserId="" s UserId=AuditUser

	s PLIST(2)=admId
	s PLIST(3)=CurArcimID
	s PLIST(4)=ItemID
	s PLIST(5)=labResult
	s PLIST(6)=UserId
	s PLIST(7)=AuditDate //+$h
	s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(CurArcimID)
	//乙肝、基因检测都当做异常显示
	s:((ODDesc[("乙肝"))||(ODDesc[("乙型肝炎")))&&((ArcimDesc[("乙肝5项"))||(ArcimDesc[("输血8项"))||(ArcimDesc[("乙肝五项"))||(ArcimDesc[("HBV-DNA"))) IsNormal=0
	s:(ODDesc[("基因型")) IsNormal=0
	;;s:ODDesc[("乙型肝炎") IsNormal=0
	b ;IsNormal
	s PLIST(8)=IsNormal
	s PLIST(11)=CurOEID
	s PLIST(13)=$p($h,",",2)
	s PLIST(16)=ResultSort
	b ;ResultSort
	s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,CurOEID,ItemID,0))
	i RLTID="" d
	.&SQL(Insert into sqluser.DHC_PE_Result values :PLIST())
	e  d
	.&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
	i SQLCODE=0  d
	.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",ordItmId)
	.s RLTID=%ROWID
	.s ^TempDHCPETransResult(Job,OEIId,OEIId,RLTID)=""
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=Unit
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"HLFlag")=HLFlag
	.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",CurOEID)
	.s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID) 
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",CurOEID)=$h
	q 
	////Modified  Over
}

ClassMethod GetAuditDate(PAAdmId As %String)
{
	s peIAdmId=$o(^DHCPEIADM(0,"PAADM",PAAdmId,"0"))
	q:peIAdmId="" ""
	s generalAdvisorId=$o(^DHCPEGS(0,"IADM",peIAdmId,0))
	q:generalAdvisorId="" ""
	s auditDate=$p($g(^DHCPEGS(generalAdvisorId,1)),"^",6)
	q auditDate
}

ClassMethod SetArcimInfo(LabNo, OEORDID, Job)
{
	k ^TempDHCPETransResult(Job,"TranResult")
	s OEpisNoid=0
	f  s OEpisNoid=$O(^OEORD(0,"EpisNo",LabNo,OEORDID,OEpisNoid)) Q:(""=OEpisNoid)  d
	.s Stat=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)
	.q:Stat=4
	.s OEORIItmMastDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",2)
	.d SetOneArcimDetail
	q
	
SetOneArcimDetail
	s ODRID=0
	f  s ODRID=$O(^DHCPEODR(0,"ARCIM",OEORIItmMastDR,ODRID)) q:ODRID=""  d
	.s ODID=$P(^DHCPEODR(ODRID),"^",2)
	.s ODDesc=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",1)
	.s ^TempDHCPETransResult(Job,"TranResult",ODDesc)=OEORDID_"||"_OEpisNoid
	q
}

Storage Default
{
<Data name="TransResultExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.TransResultExD</DataLocation>
<DefaultData>TransResultExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.TransResultExD</IdLocation>
<IndexLocation>^web.DHCPE.TransResultExI</IndexLocation>
<StreamLocation>^web.DHCPE.TransResultExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
