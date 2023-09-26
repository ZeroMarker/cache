/// Modified by MLH 20060904
/// 自动接收检验结果
Class web.DHCPE.TransResult Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod LabResultMainAll() As %String
{
	s admId=%request.Get("EpisodeID")

	s userId=%session.Get("LOGON.USERID")
	s OEORDRowId=0
	f  s OEORDRowId=$O(^OEORD(0,"Adm",admId,OEORDRowId)) q:OEORDRowId=""  d
	.s OEORIChildsub=0
	.f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
	..s ordItmId=OEORDRowId_"||"_OEORIChildsub
	..s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)

	q ret
}

/// Description: main function, the preCondition is %request.Get("EpisodeID") is exists.
/// return: "":Correct;  Else:Error occured.
ClassMethod LabResultMain() As %String
{
	s admId=%request.Get("EpisodeID")
	s ordItmId=%request.Get("OEORIRowId")
	s userId=%session.Get("LOGON.USERID")
	s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	//d ##class(web.DHCPE.TransResult).TransExtendItem(admId,ordItmId,userId)
	q ret
}

/// Description: 继承结果
/// Debug: w ##class(web.DHCPE.TransResult).TransExtendItem()
ClassMethod TransExtendItem(admId As %String, ordItmId As %String, userId As %String)
{
	q:admId="" 
	s arcItemId="",itemStatusDr=""
	s myCount=+$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	q:myCount>0 
	q:##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited" 
	s AdmLocID=$P($g(^PAADM(admId)),"^",4)
	s itemStatusDr=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s arcItemId=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
	
	/*
	s ExtendFlag=$g(^DHCPECTDataEx("DHCPEStationOrder","Extend",arcItemId)) 
	i ExtendFlag'="Y"
	{
		d ..InsertNormalResult(admId,ordItmId,userId)
	}
	*/
	s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcItemId,AdmLocID)
	q:OrderID=""
	s SOSID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_AdmLocID,OrderID,0))  
	q:SOSID=""
	s ExtendFlag=$lg($g(^CF.PE.StationOrderSetD(SOSID)),22) 
	q:ExtendFlag'="Y"
	s IADMID=$o(^DHCPEIADM(0,"PAADM",admId,0)) //DHC_PE_IADM
	s ICRMID=$p($g(^DHCPEIADM(IADMID)),"^",4) //PIADM_RowId
	s PIBIID=$p($g(^DHCPEPreIADM(ICRMID)),"^",1) //DHC_PE_PreIBaseInfo
	s PreAdmId=ICRMID
	s SQLCODE=0
	s Flag=1
	f  s PreAdmId=$o(^DHCPEPreIADM(0,"PIBI",PIBIID,PreAdmId),-1) q:(PreAdmId="")||(SQLCODE'=0)||(Flag=0)  d
	.s DHCPEIADM=$o(^DHCPEIADM(0,"CRMADM",PreAdmId,0)) //DHC_PE_IADM
	.q:DHCPEIADM="" 
	.s PAADM=$p($g(^DHCPEIADM(DHCPEIADM)),"^",1) //PA_ADM
	.s OEORIDR=""
	.//&sql(select RLT_OEORI_DR into :OEORIDR from SQLUser.dhc_pe_result
	.// where rlt_adm_dr=:PAADM and RLT_ARCIM_DR=:arcItemId)
	.s OrderItemID=""
	.f  s OrderItemID=$O(^DHCPERLT(0,"ADMOD",PAADM,OrderItemID),-1) q:(OrderItemID="")||(OEORIDR'="")  d
	..s CurArcItemID=$p($g(^OEORD($p(OrderItemID,"||",1),"I",$p(OrderItemID,"||",2),1)),"^",2)
	..s:CurArcItemID=arcItemId OEORIDR=OrderItemID
	.q:OEORIDR=""
	.s Flag=0
	.s ODID=0
	.f  s ODID=$o(^DHCPERLT(0,"ADMOD",PAADM,OEORIDR,ODID)) q:(ODID="")||(SQLCODE'=0)  d
	..s ResultID=$o(^DHCPERLT(0,"ADMOD",PAADM,OEORIDR,ODID,0)) //DHC_PE_Result
	..s ResultDesc=$p($g(^DHCPERLT(ResultID)),"^",4)
	..s Normal=$p($g(^DHCPERLT(ResultID)),"^",7)
	..s Advice=$p($g(^DHCPERLT(ResultID)),"^",8)
	..s TemplateDesc=$p($g(^DHCPERLT(ResultID)),"^",10)
	..s updateDt=+$h
	..&sql(insert into SQLUser.dhc_pe_result
	 (rlt_adm_dr, rlt_ARCIM_DR, rlt_OD_DR, rlt_user_dr,rlt_updateDate,rlt_OEORI_DR,RLT_Result,RLT_Normal,RLT_TemplateDesc,RLT_Advice)
	 values(:admId, :arcItemId, :ODID, :userId, :updateDt,:ordItmId,:ResultDesc,:Normal,:TemplateDesc,:Advice))
	..q:SQLCODE'=0
	q:SQLCODE'=0
	i Flag=1
	.d ..InsertNormalResult(admId,ordItmId,userId)
	q:Flag=1 SQLCODE
	&SQL(update sqluser.OE_ORDItem set OEORI_ItemStat_DR='6' where OEORI_RowID=:ordItmId)
	q
}

// w ##class(web.DHCPE.TransResult).trans("A0001",1)

ClassMethod LabResultLast(admId As %String) As %String
{
	Set userId=%session.Get("LOGON.USERID")
	Set ret=""
	Set orderRowId=0
	For  Set orderRowId=$O(^OEORD(0,"Adm",admId,orderRowId)) Quit:orderRowId=""  Do
	.Set ordItmChd=0
	.For  Set ordItmChd=$O(^OEORD(orderRowId,"I",ordItmChd)) Quit:ordItmChd=""  Do
	..Set LabNo=$P($G(^OEORD(orderRowId,"I",ordItmChd,3)),"^",20)
	..If $g(LabNo)'="" Do
	...Set ordItmId=orderRowId_"||"_ordItmChd
	...Set ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	q ret
}

/// return: "":Correct;  Else:Error occured.
/// test: s ret=##class(web.DHCPE.TransResult).TransALabItem("4031448","3901","3960681||38")
ClassMethod TransALabItem(admId As %String, UserId As %String, ordItmId As %String)
{
	q ##class(web.DHCPE.TransResultEx).TransLabResultForXH(admId,UserId,ordItmId)
	s episodeNo="", itemStatusDr="", OEIId=""
	s labItemCode=""
	i admId="" s admId=$P(^OEORD(+ordItmId),"^",1)
	s LocID=$P($G(^PAADM(admId)),"^",4)
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)

	s CurSpace=$ZNSpace
	s OEIId=ordItmId
	//Q:($P(^OEORD(+ordItmId,"I",$p(ordItmId,"||",2),3),"^",35)) ""
	
	/*   
    &sql(SELECT  OEORI_LabEpisodeNo	, oeori_itemstat_dr, OEORI_ItmMast_DR
		 into :episodeNo,  :itemStatusDr, :arcItemId
		 FROM  SQLUser.OE_OrdItem
		 where oeori_RowId=:ordItmId and oeori_itemstat_dr<>4 )
	*/
	q:(OEIId="") "Error: No correct OEORDItem!"	//已停止
	
	s itemStatusDr=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	
	// 删除核实状态的医嘱的结果 检验撤销等
	i itemStatusDr="1" d
	.s ResultID=0
	.f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	..&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)
	
	s arcItemId=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",2)
	s episodeNo=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",20)
	
	q:($g(episodeNo)="") "Error: EpisodeNo is Null!"
	
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") "" //总检已经审核
	//是否是检验医嘱
	//q:(..CheckIsLabItem(OEIId)=0) "Error: the Item is not a labItem!"
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	//取检验外部代码
	s labItemCode=""
	s LabItemSetID=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",35)
	q:LabItemSetID="" ""
	s labItemCode=$p(LabItemSetID,"||",2)
	q:labItemCode="" ""
	/*
	i TrakVerison="TrakCare" d
	.Quit:'$d(^ARCIM(+arcItemId,1,"EXT"))
	.Set Ext=$o(^ARCIM(+arcItemId,1,"EXT",0))
	.Quit:$g(Ext)=""
	.Set labItemCode=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",4)
	*/
	
	
	/*
	i "MedTrak"=TrakVerison d
	.s arcos=$p(^OEORD(+ordItmId,"I",$p(ordItmId,"||",2),3),"^",10)
	.Quit:$g(arcos)=""
	.s labItemCode=$P($G(^ARCOS(arcos)), "^", 11)
   
	i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) Set labItemCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
	q:((labItemCode="")||(episodeNo="")) "Error: the arcItem's Ext_code is null."
	*/
	//判断检验状态
	
	s labItemStatus=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",31)
	q:(labItemStatus'="A") "Error: the result is not send by labDepartment."	//A: Authorised, 已发送
	
	
	//取检验录入日期   2007-07-27
	//s UpdateDate=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",4)
	s AuditDate=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",4)
	s AuditTime=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",5)
	s AuditTime=AuditTime*60
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	Quit:(AuditDate<TranedDate) "Date"  //判断是否传输过
	Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
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
	.s AuditUser=$O(^[namespaceLab]SSU("SSUSR",0,"SSUSR_Initials",AuditUser,""))
	*/
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser
	
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
	i LisInterface="N"  d
	.s num=""
  	.f  s num=$o(^TTAB("TS",labItemCode,0,num))  q:num=""  d
  	..s LabItemDetailCode=$p($g(^TTAB("TS",labItemCode,0,num)),"\",8)
  	..d TransResult
  	else  d
	.s LabItemDetailCode=""
	.f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	..d TransResult
	Q ""
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
	s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
	s ResultSort=$p(labResult,"\",9)
	s:ResultSort="" ResultSort="999999999"
	S labResult=$p(labResult,"\",1)
	q:labResult=""
	s LabResultStr=""
	
	/*
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
	if LisInterface="N" d
	.If $g(labResult)'="" Do
	..s CurSpace=$ZNSpace
	..zn namespaceLab
	..;s LabResultStr=$$TestItmRes^CHDhcLabReport(episodeNo,LabItemDetailCode,labResult,AuditDate)
	
	..s LabResultStr=$$TestItmRes^DHCLtkReport(episodeNo,LabItemDetailCode,labResult,AuditDate,"")
	
	..//s retvalue=itmcode_$c(2)_itmname_$c(2)_synonym_$c(2)_$tr(itmres,$c(13,10),"")_$c(2)_itmunits
	..//s retvalue=retvalue_$c(2)_resflag_$c(2)_ranges_$c(2)_otherres_$c(2)_rangcolor_$c(2)_itmtype_$c(2)_resflag1
	..//代码_$c(2)_名称_$c(2)_英文缩写_$c(2)_结果_$c(2)_单位_$c(2)_异常标记（U警告标记P警告标记M荒诞值N正常H高L低A异常）_$c(2)_参考范围_$c(2)_其它结果_$c(2)_颜色
	..;s LabresultStr=##class(web.DHCLabTestCode).GetTestCodeResult(episodeNo,LabItemDetailCode,labResult,AuditDate)
	..zn CurSpace
    ..i LabResultStr'="" s labResult=$p(LabResultStr,$c(2),4)
	..s NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(ItemID,mySex,myAge)
	..s Unit=$p(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2)),"^",4)
	else  d
	.s NormalStr=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Ranges"))
	.s Unit=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Unit"))
	s IsNormal=..LabIsNormal(NormalStr,LabItemDetailCode,labResult)
	*/
	s HLFlag=""
	s CurSpace=$ZNSpace
	zn namespaceLab
	s LabResultStr=$$TestItmRes^DHCLtkReport(episodeNo,LabItemDetailCode,labResult,AuditDate,"")
	i LabResultStr'="" d
	.s labResult=$p(LabResultStr,$c(2),4)
	.s NormalStr=$p(LabResultStr,$c(2),7)
	.s Unit=$p(LabResultStr,$c(2),5)
	.s IsNormal=$p(LabResultStr,$c(2),6)
	.s HLFlag=IsNormal
	.i IsNormal="N" d
	..s IsNormal="1"
	.e  d
	..s IsNormal="0"
	e  d
	.s NormalStr=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Ranges"))
	.s Unit=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Unit"))
	.s IsNormal=..LabIsNormal(NormalStr,LabItemDetailCode,labResult)
	
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
	i UserId="" s UserId=AuditUser

	s PLIST(2)=admId
	s PLIST(3)=arcItemId
	s PLIST(4)=ItemID
	s PLIST(5)=labResult
	s PLIST(6)=UserId
	s PLIST(7)=AuditDate //+$h
	s PLIST(8)=IsNormal
	s PLIST(11)=OEIId
	s PLIST(13)=$p($h,",",2)
	s PLIST(16)=ResultSort
	b ;ResultSort
	s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,OEIId,ItemID,0))
	i RLTID="" d
	.&SQL(Insert into sqluser.DHC_PE_Result values :PLIST())
	e  d
	.&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
	i SQLCODE=0  d
	.s RLTID=%ROWID
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=Unit
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"HLFlag")=HLFlag
	.s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID) 
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
	q 
	////Modified  Over
	
	///为了检验没有布局等信息修改
	s LabItemDetailCode=""
	f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	.s IsNormal=1
	.s Code=$ZCVT(LabItemDetailCode,"U")
	.s ItemID=""
	.s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
	.i stationID="" d
	..s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetail(LabItemDetailCode)
	.e  d
	..s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
	..s ItemID=stationID_"||"_sub
	.q:ItemID=""
	.s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
	.S labResult=$p(labResult,"\",1)
	.s labResult=$p(labResult,$C(13,10),1)
	.i labResult[("阴性") d
	..s labResult=$P(labResult,"@",1)
	.e  d
	..s labResult=##class(web.DHCPE.Public.Setting).Replace(labResult,"@"," ")
	.//s labResult=$p(..trans(LabItemDetailCode,labResult),$c(1),2)
	.s NormalStr=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Ranges"))
	.;b ;NormalStr,LabItemDetailCode,labResult
	.s IsNormal=..LabIsNormal(NormalStr,LabItemDetailCode,labResult)
	.//s CTTCTComm=$s(IsNormal=0:1,IsNormal=1:0)
	.s UserId=$p($g(^TEPI(episodeNo,1,labItemCode,1)),"\",3)
	.i UserId'="" d
	..s UserId=$ZCVT(UserId,"U")
	..s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserId,""))
	
	.i UserId="" s UserId=AuditUser
	.// If $g(labResult)'="" Do
	.//.zn namespaceLab
	.//.s LabResultStr=$$TestItmRes^CHDhcLabReport(episodeNo,LabItemDetailCode,labResult,61062)
	.//.zn CurSpace
	.//. Set flag=$p(LabResultStr,$c(2),11)
	.//.If (flag'="")&(flag'="N") Set IsNormal="0"
	.s PLIST(2)=admId
	.s PLIST(3)=arcItemId
	.s PLIST(4)=ItemID
	.s PLIST(5)=labResult
	.s PLIST(6)=UserId
	.s PLIST(7)=AuditDate //+$h
	.s PLIST(8)=IsNormal
	.s PLIST(11)=OEIId
	.s PLIST(13)=$p($h,",",2)
	.s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,OEIId,ItemID,0))
	.i RLTID="" d
	..&SQL(Insert into sqluser.DHC_PE_Result values :PLIST())
	.e  d
	..&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
	.i SQLCODE=0  d
	..s RLTID=%ROWID
	..s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
	..s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Unit"))
	..s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID)         //add
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
	q ""
	////Modified  Over
}

/// description: 判断指定医嘱是否是一个检验医嘱
/// return: 0-not a labItem;  1-Is a LabItem
/// test: w ##class(web.DHCPE.TransResult).CheckIsLabItem("48885||6")
ClassMethod CheckIsLabItem(OEIId As %String)
{
	s episodeNo=""
	&sql(SELECT  OEORI_LabEpisodeNo
				into :episodeNo
		FROM  SQLUser.OE_OrdItem
		where oeori_RowId=:OEIId)
	
	q:(episodeNo="") 0
	q 1
}

/// Modified by MLH 11-07
/// description: 插入空的检验结果记录
/// return: "": correct 	else: Error infomation
/// test: w ##class(web.DHCPE.TransResult).InsertBlankLabItem("48885||6",1)
ClassMethod InsertBlankLabItem(OEIId, UserId, episodeNo, labItemCode)
{
	s admId="", arcItemId="", itemStatusDr=""
	/*&sql(SELECT  OEORI_OEORD_ParRef->OEORD_Adm_DR, oeori_itmMast_dr, oeori_itemstat_dr
		 			into  :admId, :arcItemId, :itemStatusDr
		 FROM  SQLUser.OE_OrdItem
		 where oeori_RowId=:OEIId)*/
	s itemStatusDr=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s admId=$p(^OEORD(+OEIId),"^",1)
	Set arcItemId=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",2)
	 s PAADM=$p($g(^OEORD($P(OEIId,"||",1))),"^",1)
	 s LocID=$P($G(^PAADM(PAADM)),"^",4)
		
	s myCount=0
	
	Set updateDt=+$h
	Set ODRRowId=0
	For  Set ODRRowId=$O(^DHCPEODR(0,"ARCIM",arcItemId,ODRRowId)) q:(ODRRowId="")  d
	.s ODDR=$p(^DHCPEODR(ODRRowId),"^",2)
	.q:ODDR=""
	.Set RLTRowId=""
	.//&sql(select rlt_RowId into :RLTRowId from SQLUser.dhc_pe_result 
  	.// where rlt_adm_dr=:admId and  rlt_OEORI_DR=:OEIId and rlt_OD_DR=:ODDR)
  	.s RLTRowId=$o(^DHCPERLT(0,"ADMOD",admId,OEIId,ODDR,0))
  	.If RLTRowId="" Do
	..&sql(insert into SQLUser.dhc_pe_result
	 (rlt_adm_dr, rlt_ARCIM_DR, rlt_OD_DR, rlt_user_dr,rlt_updateDate, rlt_OEORI_DR)
	  values(:admId, :arcItemId, :ODDR, :UserId, :updateDt,:OEIId))
	..q:(SQLCODE'=0)
	
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
	Set RLTRowId=0
	For  Set RLTRowId=$O(^DHCPERLT(0,"OEORI",OEIId,RLTRowId)) Quit:RLTRowId=""  Do
	.Set RLTODDR=$p(^DHCPERLT(RLTRowId),"^",3)
	.Set ODLabtrakCode=$p(^DHCPEST($P(RLTODDR,"||",1),"OD",$P(RLTODDR,"||",2)),"^",10)
	.q:labItemCode=""       //20090305 c
    .q:ODLabtrakCode=""    //20090305 c
	.Set labResult=$d(^TEPI(episodeNo,1,labItemCode,1,"DATA",ODLabtrakCode))
	.If labResult=0 Do
	..&sql(delete from SQLUser.dhc_pe_result where rlt_rowid=:RLTRowId)
	q ""
}

/// Description: RisResultMain function, the preCondition is %request.Get("EpisodeID") is exists.
/// return: "":Correct;  Else:Error occured.
ClassMethod RisResultMain() As %String
{
	s admId=%request.Get("EpisodeID")
	//s arcItmId=%request.Get("ARCIMID")n
	s ordItmId=%request.Get("OEORIRowId")
	s userId=%session.Get("LOGON.USERID")
	s ret=##class(web.DHCPE.TransResult).TransARisItem(admId, ordItmId, userId)
	q ret
}

/// Create by MLH
/// return: "":Correct;  Else:Error occured.
/// test: w ##class(web.DHCPE.TransResult).TransARisItem("50677","44809||5",10691)
ClassMethod TransARisItem1(admId As %String, ordItmId As %String, UserId As %String)
{
	
	q:(ordItmId="") "Error: No correct OEORDItem!"
	s itemStatusDr=""
	s labItemCode=""

	&sql(SELECT   oeori_itemstat_dr, OEORI_ItmMast_DR
		 into  :itemStatusDr, :arcItemId
		 FROM  SQLUser.OE_OrdItem
		 where oeori_rowid=:ordItmId and OEORI_OEORD_ParRef->OEORD_Adm_DR=:admId		 
      			and oeori_itemstat_dr<>4 )
	q:(arcItemId="") "Error: No correct arcItemId" //已停止

	//q:(##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(admId)="Audited") "" //总检已经审核

	s DCMRPTRowId=$o(^DicomRpti("oeorditem",ordItmId,0))
	q:($g(DCMRPTRowId)="") ""
		
	s RisItemStatus=$P(^DicomRpt(DCMRPTRowId),"^",9)
	q:(RisItemStatus="") "Error: the result is not Verify."	//未审核
	
	s ExamDesc=$P(^DicomRpt(DCMRPTRowId),"^",3)  //3,检查所见
	s ExamResult=$P(^DicomRpt(DCMRPTRowId),"^",4)  //4,诊断意见
	s ClinicInfo=$P(^DicomRpt(DCMRPTRowId),"^",17)  //17,临床诊断
	q:((ExamDesc="")&(ExamResult)&(ClinicInfo)) "Error: No RisData" //没有Ris数据
	
	s DCMUserId=$P(^DicomRpt(DCMRPTRowId),"^",7)
	i DCMUserId'="" s UserId=$p(^DicomCT(DCMUserId),"^",1)
	
	s retStr=..InsertBlankRisItem(ordItmId, UserId)
	q:(retStr'="") retStr
	s resultId="", orderDetailId=""
	f  s orderDetailId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId))  q:(orderDetailId="")  d
	.s resultId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId,"0"))
	.s objResult=##class(User.DHCPEResult).%OpenId(resultId)
	.s RisItemDesc=objResult.RLTODDR.ODDesc	//细项的名称
	.s ODDesc=$p(RisItemDesc,"-",2)
	.i ODDesc="检查结果" d 
	..
	..s ClinicInfo=##Class(web.DHCPE.ResultEdit).GetRisDataClinicInfo(ordItmId)
	..s ExamDesc=##Class(web.DHCPE.ResultEdit).GetRisDataExamDesc(ordItmId)
	..s ExamResult=##Class(web.DHCPE.ResultEdit).GetRisDataExamResult(ordItmId)
	..s ResultStr="临床诊断:"_ClinicInfo
	..s ResultStr=ResultStr_";检查所见:"_ExamDesc
	..s ResultStr=ResultStr_";诊断意见:"_ExamResult
	..s objResult.RLTResult=ResultStr
	.s objResult.RLTUpdateDate=+$h
	.s objResult.RLTUpdateTime=$p($h,",",2)
	.s objResult.RLTUserDR=UserId
	.s retStatus=objResult.%Save()
	.b:($$$ISOK(retStatus)'=1)	;objResult.%Save()
	q ""
}

/// Create by MLH
/// return: "":Correct;  Else:Error occured.
/// test: w ##class(web.DHCPE.TransResult).TransARisItem("7731283","7588738||43",1)
ClassMethod TransARisItem(admId As %String, ordItmId As %String, UserId As %String)
{
	Quit:($G(ordItmId)="") "Error: No correct OEORDItem!"
	Set itemStatusDr=""
	Set labItemCode=""
	/*&sql(SELECT   oeori_itemstat_dr, OEORI_ItmMast_DR
		 into  :itemStatusDr, :arcItemId
		 FROM  SQLUser.OE_OrdItem
		 where oeori_rowid=:ordItmId and OEORI_OEORD_ParRef->OEORD_Adm_DR=:admId		 
      			and oeori_itemstat_dr<>4 )
	Quit:($g(arcItemId)="") "Error: No correct arcItemId" //已停止
	*/
	q:ordItmId="" "医嘱ID不能为空"
	s itemStatusDr=$p(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s arcItemId=$p(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1),"^",2)
	q:arcItemId="" "数据异常，医嘱项ID为空"
	
	///Add by wrz for xdt
	s STRowId=0
	s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId))
	Q:(""=STRowId) 0
	s STORDChildSub=0
	s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId, STORDChildSub))
	Q:(""=STORDChildSub) 0
	s ReportFormat=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",4)
	q:ReportFormat["EKG" 0
	s admId=$P(^OEORD(+ordItmId),"^",1)
	///Add End
	i ReportFormat="RF_PIS"
	{
		;获取病理结果
		d ..TransAPISItem(admId,ordItmId,UserId)
		q 0
	}
	
	Set RARRowId=$o(^DHCPACRegInfoi("OEORI",ordItmId,0))
	Quit:$g(RARRowId)="" "没有报告（DHCRB_Reginfo表没有数据），请联系检查系统工程师"
	Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	//Set DRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,0))
	set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
	b ;RisStudyNo DRPTRowId
	Quit:($g(DRPTRowId)="") "没有检查报告(DHCRB_Report表没有数据)"
	Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
	Quit:(RisItemStatus'="5")&&(RisItemStatus'="4") "报告未审核或者未发布，当前状态"_RisItemStatus_"，请联系检查系统或者平台工程师"	//未发布
	b ;DRPTRowId
	///Add by MLH 2008-05-13  判断最后发布时间
	s AuditDate=$P(^DHCRBStudy("Report",DRPTRowId),"^",12)
	//超声一般不审核，pacs默认审核日期1990-01-01，放射必须审核
	i ((AuditDate="21915")||(AuditDate="")) s AuditDate=$P(^DHCRBStudy("Report",DRPTRowId),"^",9)
	
	if (##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited"){
			s ErrInfo="总检已经审核"
			s PEAuditDate=..GetAuditDate(admId)
			if (PEAuditDate<AuditDate){
				d ##Class(web.DHCPE.TransResult).NoticeAuditDoc(admId,ordItmId)
			
			}
	
	
	}
	q:(##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(admId)="Audited") "总检已经审核" //总检已经审核
	
	s AuditTime=$P(^DHCRBStudy("Report",DRPTRowId),"^",13)
	i AuditTime=""  s AuditTime=$P(^DHCRBStudy("Report",DRPTRowId),"^",10)
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	/// 
	//Quit:(AuditDate<TranedDate) "已经接收过结果"  //判断是否传输过
	//Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "已经接收过结果"
	////////////
	Set ExamDesc=^DHCRBStudy("Report",DRPTRowId,"ExamDescEx")  //3,检查所见
	s ExamDesc=##class(web.DHCPE.Public.Setting).Replace(ExamDesc,"检查所见:","")
	Set ExamResult=^DHCRBStudy("Report",DRPTRowId,"ResultDescEx")  //4,诊断意见
	s ExamResult=##class(web.DHCPE.Public.Setting).Replace(ExamResult,"检查意见:","")
	//Set ExamDesc=$G(^DHCRBStudy("Report",DRPTRowId,"ResultDescEx"))  //3,检查所见
	//Set ExamResult=$G(^DHCRBStudy("Report",DRPTRowId,"ExamDescEx"))  //4,诊断意见
	s OneStr=""
	/*
	i ExamResult["检查所见:" d
	.s OneStr=$P(ExamDesc,"检查意见:",2)
	.s ExamDesc=$P(ExamResult,"检查所见:",2)
	.s ExamResult=OneStr
	*/
	Set ClinicInfo=""
	//s ClinicInfo=$P(^DicomRpt(DRPTRowId),"^",17)  //17,临床诊断
	b ;ClinicInfo
	q:((ExamDesc="")&(ExamResult="")&(ClinicInfo="")) "DHCRB_Report表里没有检查诊断和建议" //没有Ris数据
	s DCMUserId=$P(^DHCRBStudy("Report",DRPTRowId),"^",11)  ;审核医生
	s ReportUserId=$P($G(^DHCRBStudy("Report",DRPTRowId)),"^",8)  ;报告医生
	s:DCMUserId="" DCMUserId=ReportUserId
	//是否正常的判断
	s result=$P(^DHCRBStudy("Report",DRPTRowId),"^",7)
	i result="N" d
	.s result=1
	e  d
	.s result=0
	
	//i DCMUserId'="" s UserId=$p(^DicomCT(DCMUserId),"^",1)
	s UserId=DCMUserId
	
	s ReportUserID=$P(^DHCRBStudy("Report",DRPTRowId),"^",8)
	s ReportDate=$P(^DHCRBStudy("Report",DRPTRowId),"^",9)
	s ReportTime=$P(^DHCRBStudy("Report",DRPTRowId),"^",10)
	
	//审核人
	Set DCMUserCode=$p($g(^SSU("SSUSR",DCMUserId)),"^",1)
	Set DCMUserDesc=$p($g(^SSU("SSUSR",DCMUserId)),"^",2)
	Set CheckUserInfo=##class(User.DHCPESSUser).SetPESSUser(DCMUserCode,DCMUserDesc,"TRIS")
		
	//报告人
	Set ReportUserCode=$p($g(^SSU("SSUSR",ReportUserID)),"^",1)
	Set ReportUserDesc=$p($g(^SSU("SSUSR",ReportUserID)),"^",2)
	Set ReportUserInfo=##class(User.DHCPESSUser).SetPESSUser(ReportUserCode,ReportUserDesc,"TRIS")
	//Quit:(CheckUserInfo="")&&(ReportUserInfo="") "录入人和审核人都为空"
	
	Set CheckUserID=$p(CheckUserInfo,"^",1)
	Set ReportUserID=$p(ReportUserInfo,"^",1)
	
	s retStr=..InsertBlankRisItem(ordItmId, UserId)
	
	q:(retStr'="") "插入检查细项失败，失败代码"_retStr
	s ErrInfo=""
	s resultId="", orderDetailId=""
	f  s orderDetailId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId))  q:(orderDetailId="")  d
	.s resultId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId,"0"))
	.s objResult=##class(User.DHCPEResult).%OpenId(resultId)
	.s RisItemDesc=objResult.RLTODDR.ODDesc	//细项的名称
	.s RisItemDescLength=$l(RisItemDesc,"-")
	.s ODDesc=$p(RisItemDesc,"-",RisItemDescLength)
	.s ResultStr=""
	.i ODDesc="检查结果" d 
	..;s ClinicInfo=##class(web.DHCPE.ReportGetInfor).Replace(ClinicInfo,"_$c(13,10)_","  ")
	..;s ClinicInfo=##class(web.DHCPE.ReportGetInfor).Replace(ClinicInfo,"_$c_","  ")
	..;s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c(13,10)_","  ")
	..;s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c_","  ")
	..;s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,"_$c(13,10)_","  ")
	..;s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,"_$c_","  ")
	..s ResultStr="临床诊断:"_ClinicInfo
	..s ResultStr=ResultStr_";检查所见:"_ExamDesc
	..s ResultStr=ResultStr_";诊断意见:"_ExamResult
	..s ^DHCPETempResult(ordItmId)=ResultStr
	..s objResult.RLTResult=ResultStr
	.e  d
	..s ErrInfo=ErrInfo_";没有修改体检结果表，请查看大项和细项组合关系对照里关联的细项是否为‘医嘱名称-检查结果’,并且是唯一关联的细项"
	.i AuditDate'="" d
	..s objResult.RLTUpdateDate=AuditDate
	.e  s objResult.RLTUpdateDate=+$h 
	.i AuditTime'="" d 
	..s objResult.RLTUpdateTime=AuditTime
	.e  s objResult.RLTUpdateTime=$p($h,",",2)
	.s:UserId'="" objResult.RLTUserDR=UserId
	.s objResult.RLTNormal=result
	.Do objResult.RLTResultUserDRSetObjectId(CheckUserID)
	.Do objResult.RLTReportUserDRSetObjectId(ReportUserID)
	.Do objResult.RLTAuditUserDRSetObjectId(CheckUserID)
	.Set objResult.RLTReportDate=ReportDate
	.Set objResult.RLTReportTime=ReportTime
	.Set objResult.RLTAuditDate=AuditDate
	.Set objResult.RLTAuditTime=AuditTime
	.s retStatus=objResult.%Save()
	.//b:($$$ISOK(retStatus)'=1)	;objResult.%Save()
	.i ($System.Status.IsError(retStatus)) d
	..s ErrInfo=ErrInfo_";"_$System.Status.GetErrorText(retStatus)
	.s $p(^DHCPERLT(resultId),"^",4)=ResultStr
	.s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(resultId)         //add
	.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",ordItmId)
	q:(ErrInfo'="") ErrInfo	
	s ^DHCPEData("DHCPEResult","RIS","ReportUser",ordItmId)=ReportUserId
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
	q ""
}

/// Creator: 	 xy
/// CreateDate:  20200418
/// Description: 从平台获取检查结果
/// Input:       admId:就诊ID, ordItmId:医嘱ID, UserId:用户ID
/// Debug: w ##class(web.DHCPE.TransResult).TransARisItemByPT("798","768||2",11849)
ClassMethod TransARisItemByPT(admId As %String, ordItmId As %String, UserId As %String)
{
	s $zt="TransARisItemByPTerr"
	Quit:($G(ordItmId)="") "Error: No correct OEORDItem!"
	Set itemStatusDr=""
	Set labItemCode=""
	q:ordItmId="" ""
	i admId="" s admId=$P(^OEORD(+ordItmId),"^",1)
	s itemStatusDr=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s arcItemId=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
	q:arcItemId="" "arcItemId is null"
	
	s STRowId=0
	//s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId))
	/***多院区改造 start***/
	i admId'="" s LocID=$p($g(^PAADM(admId)),"^",4)
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcItemId,LocID)
    s STRowId=$p(StatOrderDR,"||",1)      //站点ID
	/***多院区改造 end***/
	
	q:(""=STRowId) "未找到体检站点信息，请查看站点和项目组合数据维护是否正确"
	
	s STORDChildSub=0
	s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId, STORDChildSub))
	Q:(""=STORDChildSub) "未找到体检站点和项目组合信息，请查看站点和项目组合数据维护是否正确"
	
	s admId=$P($g(^OEORD(+ordItmId)),"^",1)
	
	//q:(##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(admId)="Audited") "总检已经审核" //总检已经审核
	
	//平台获取检查报告信息的query
	//d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectReportByOeordID",医嘱ID)
	s rs=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID") 
	d rs.Execute(ordItmId)
	s ResultSort=0
    s ErrInfo=""
	s GetActiveResult=0
	while(rs.Next())
	{
		s ResultSort=ResultSort+1
	
		//检查所见
		S ExamDesc=rs.Get("ExamDesc")  
		;b ;检查所见 ExamDesc
		;s ExamDesc=##class(web.DHCPE.Public.Setting).Replace(ExamDesc,"检查所见:","")
		
		//诊断意见
		S ExamResult=rs.Get("strResult")  
		;b ;诊断意见 ExamResult
		;s ExamResult=##class(web.DHCPE.Public.Setting).Replace(ExamResult,"检查意见:","")
	
		s OneStr=""
		S ClinicInfo=""
		if ((ExamDesc="")&(ExamResult="")&(ClinicInfo="")){
			
			s:(ErrInfo'="") ErrInfo=ErrInfo_"平台接口返回的数据里，临床诊断、检查所见、诊断意见都是空，平台接口：web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID，请联系平台工程师！"
			s:(ErrInfo="") ErrInfo="平台接口返回的数据里，临床诊断、检查所见、诊断意见都是空，平台接口：web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID，请联系平台工程师！"
			}
		continue:((ExamDesc="")&(ExamResult="")&(ClinicInfo="")) 
		s GetActiveResult=1
		
		//审核日期
		S AuditDate=rs.Get("RISRCheckDate")
		i AuditDate'="" s AuditDate=$zdh(AuditDate,3)
		
		
		if (##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited"){
			s ErrInfo="总检已经审核"
			s PEAuditDate=..GetAuditDate(admId)
			if (PEAuditDate<AuditDate){
				d ##Class(web.DHCPE.TransResult).NoticeAuditDoc(admId,ordItmId)
			
			}
	
	
		}
		q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited")  //"总检已经审核"
		
		//审核时间
		S AuditTime=rs.Get("RISRCheckTime")
	    i AuditTime'="" s AuditTime=$zth(AuditTime,3)
	    
	    //报告日期
	    S ReportDate=rs.Get("RISRReportDate")
		i ReportDate'="" s ReportDate=$zdh(ReportDate,3)
	    
	    //报告时间
	    S ReportTime=rs.Get("RISRReportTime")
		i ReportTime'="" s ReportTime=$zth(ReportTime,3)
		;b ;ReportDate ReportTime
		
		i AuditDate="" s AuditDate=ReportDate
		i AuditTime="" s AuditTime=ReportTime
		
		//审核医生
		s DCMUserId=""
		s DCMUserCode=rs.Get("RISRCheckDocCode") //审核医生Code
		s DCMUserDesc=rs.Get("RISRCheckDocDesc") //审核医生Desc
		
		/*** 体检操作人员库表——DHC_PE_SSUser
		（1）根据审核医生（报告医生）Code、审核医生（报告医生）Desc判断是否是his里ss_user表的人员，
			如果是，表DHC_PE_SSUser中字段SSU_User_DR更新为ss_user表的ID,
			如果不是，表DHC_PE_SSUser中字段SSU_User_DR值为空；
		（2）结果表字段RLT_ResultUser_DR，RLT_ReportUser_DR 报告人，RLT_AuditUser_DR 审核人
			分别存的是表DHC_PE_SSUser的ID,这样不管检查、检验是不是第三方，都可以取DHC_PE_SSUser中相关字段对应的值
		***/
		s CheckUserInfo=##class(User.DHCPESSUser).SetPESSUser(DCMUserCode,DCMUserDesc,"TRIS")
		i DCMUserCode'="" s DCMUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DCMUserCode),0))
		;b ;DCMUserCode  DCMUserId  CheckUserInfo
		
		//报告医生
		s ReportUserId=""
		s ReportUserCode=rs.Get("RISRReportDocCode") //报告医生Code
		s ReportUserDesc=rs.Get("RISRReportDocDesc") //报告医生Desc
		s ReportUserInfo=##class(User.DHCPESSUser).SetPESSUser(ReportUserCode,ReportUserDesc,"TRIS")
		i ReportUserCode'="" s ReportUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ReportUserCode),0))  
	    ;b ;ReportUserCode ReportUserId ReportUserInfo
	    
		s:DCMUserId="" DCMUserId=ReportUserId
		
		//取DHC_PE_SSUser表的ID
		s CheckUserID=$p(CheckUserInfo,"^",1)
		s ReportUserID=$p(ReportUserInfo,"^",1)
		
		//是否正常的判断
		//s result=rs.Get("RISRWarnCode") //平台危机值
		//s result=rs.Get("RISRAbnormalFlags") //RISRAbnormalFlags:异常标记（一般用于检验）
		s result=rs.Get("RISRIsPositive")    //RISRIsPositive:是否阳性
		;b ;result
		i result="N" d
		.s result=1
		e  d
		.s result=0
	
		s UserId=DCMUserId
	
		s retStr=..InsertBlankRisItem(ordItmId,UserId)
		if (retStr'=""){
			
			s:(ErrInfo'="") ErrInfo=ErrInfo_"体检插入结果失败,失败代码："_retStr
			s:(ErrInfo="") ErrInfo="体检插入结果失败,失败代码："_retStr
			}
		
		continue:(retStr'="")
		
		s resultId="", orderDetailId=""
		f  s orderDetailId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId))  q:(orderDetailId="")  d
		.s resultId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId,"0"))
		.s objResult=##class(User.DHCPEResult).%OpenId(resultId)
		.s RisItemDesc=objResult.RLTODDR.ODDesc	//细项的名称
		.s RisItemDescLength=$l(RisItemDesc,"-")
		.s ODDesc=$p(RisItemDesc,"-",RisItemDescLength)
		.s ResultStr=""
		.i ODDesc="检查结果" d 
		..;s ClinicInfo=##class(web.DHCPE.ReportGetInfor).Replace(ClinicInfo,"_$c(13,10)_","  ")
		..;s ClinicInfo=##class(web.DHCPE.ReportGetInfor).Replace(ClinicInfo,"_$c_","  ")
		..;s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c(13,10)_","  ")
		..;s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,"_$c_","  ")
		..;s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,"_$c(13,10)_","  ")
		..;s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,"_$c_","  ")
		..s ResultStr="临床诊断:"_ClinicInfo
		..s ResultStr=ResultStr_";检查所见:"_ExamDesc
		..s ResultStr=ResultStr_";诊断意见:"_ExamResult
		..s ^DHCPETempResult(ordItmId)=ResultStr
		..s objResult.RLTResult=ResultStr
		.e  d
		..s ErrInfo=ErrInfo_";没有修改体检结果表，请查看大项和细项组合关系对照里关联的细项是否为‘医嘱名称-检查结果’,并且是唯一关联的细项"
		.i AuditDate'="" d
		..s objResult.RLTUpdateDate=AuditDate
		.e  s objResult.RLTUpdateDate=+$h 
		.i AuditTime'="" d 
		..s objResult.RLTUpdateTime=AuditTime
		.e  s objResult.RLTUpdateTime=$p($h,",",2)
		.s:UserId'="" objResult.RLTUserDR=UserId  
		.Do objResult.RLTResultUserDRSetObjectId(CheckUserID)
		.Do objResult.RLTReportUserDRSetObjectId(ReportUserID)
		.Do objResult.RLTAuditUserDRSetObjectId(CheckUserID)
		.Set objResult.RLTReportDate=ReportDate
		.Set objResult.RLTReportTime=ReportTime
		.Set objResult.RLTAuditDate=AuditDate
		.Set objResult.RLTAuditTime=AuditTime
		.s objResult.RLTNormal=result
		.s retStatus=objResult.%Save()
		.b:($System.Status.IsError(retStatus))	;objResult.%Save()
		.i ($System.Status.IsError(retStatus)) d
		..s ErrInfo=ErrInfo_";"_$System.Status.GetErrorText(retStatus)
		.s $p(^DHCPERLT(resultId),"^",4)=ResultStr
		.s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(resultId)         
		.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",ordItmId)
	
		s ^DHCPEData("DHCPEResult","RIS","ReportUser",ordItmId)=ReportUserId
		s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h

	
	}
	q:(ErrInfo'="") ErrInfo	
	q:(GetActiveResult=0) "平台接口返回的数据为空，平台接口：web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID，请联系平台工程师！"
	Q ""
TransARisItemByPTerr
	q "检查项目回传异常"_$ZERROR
}

/// Description: 插入空的RIS结果记录  
/// Return:      "": correct , else: Error infomation
/// Debug: w ##class(web.DHCPE.TransResult).InsertBlankRisItem("44809||5",1)
ClassMethod InsertBlankRisItem(ordItmId, UserId)
{
	s admId="", arcItemId="", itemStatusDr=""
	
	/*&sql(SELECT  OEORI_OEORD_ParRef->OEORD_Adm_DR, oeori_itmMast_dr, oeori_itemstat_dr
		 			into  :admId, :arcItemId, :itemStatusDr
		 FROM  SQLUser.OE_OrdItem
		 where oeori_RowId=:ordItmId)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	*/
	
	q:ordItmId="" ""
	s itemStatusDr=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s arcItemId=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
	q:arcItemId="" ""
	s admId=$p($g(^OEORD(+ordItmId)),"^",1)
	
	s myCount=0
	s myCount=+$o(^DHCPERLT(0,"OEORI",ordItmId,myCount))
	
	/*&sql(select count(*) into :myCount from SQLUser.dhc_pe_result 
		 where rlt_adm_dr=:admId and rlt_OEORI_DR=:ordItmId)
	*/
	q:(myCount>0) ""		//已经存在记录  //还要修改，MLH0904
	
	s updateDt=+$h
	s updateTt=$p($h,",",2)
    s num=0
    /*
	s ODRRowId=0
	f  s ODRRowId=$O(^DHCPEODR(0,"ARCIM",arcItemId,ODRRowId)) q:(ODRRowId="")  d
	.s ODDR=$p(^DHCPEODR(ODRRowId),"^",2)
	.s num=num+1
    .&sql(insert into SQLUser.dhc_pe_result
	 (rlt_adm_dr, rlt_ARCIM_DR, rlt_OD_DR, rlt_user_dr,rlt_updateDate,rlt_OEORI_DR,RLT_UpdateTime)
	  values(:admId, :arcItemId, :ODDR, :UserId, :updateDt,:ordItmId,:updateTt))
	.q:(SQLCODE'=0)
	*/
	
	/**********多院区******************/
	s LocID=$p($g(^PAADM(admId)),"^",4)
	s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcItemId,LocID)
	q:(OrderID="") "未找到站点和项目组合对照,请查看站点和项目组合对照"
	s ODRRowId=0
	s TMPErrInfo=""
	s TMPHadInsert=0
	f  s ODRRowId=$o(^DHCPEODR(0,"OrderID",OrderID,ODRRowId))  q:(ODRRowId="")  d
	.s LocShowDFlag=##class(User.DHCPEOrderDetailRelate).GetLocShowDataFlag(ODRRowId,LocID)
    .q:LocShowDFlag'="Y"
    .s ODDR=$p($g(^DHCPEODR(ODRRowId)),"^",2)
    .s num=num+1
    .&sql(insert into SQLUser.dhc_pe_result
	 (rlt_adm_dr, rlt_ARCIM_DR, rlt_OD_DR, rlt_user_dr,rlt_updateDate,rlt_OEORI_DR,RLT_UpdateTime)
	  values(:admId, :arcItemId, :ODDR, :UserId, :updateDt,:ordItmId,:updateTt))
	.s:(SQLCODE) TMPErrInfo=TMPErrInfo_";插入体检结果表失败,失败代码"_SQLCODE_"失败描述:"_%msg_"，请联系体检工程师"
	.q:(SQLCODE'=0)
	.s TMPHadInsert=1
	q:(TMPErrInfo'="") TMPErrInfo
	q:(TMPHadInsert=0) "没有插入体检结果表，请查看大项和细项组合对照是否维护正确"
	 /**********多院区******************/
	q ""
}

ClassMethod trans(tc, ret)
{
   s itmtype=$p($g(^TTAB("TC",tc)),"\",3)
   b //1
   i itmtype["N" d    ;numeric
   .s decimal=$e(itmtype,2)
   .i decimal="" s decimal="0"
   .s temres=..CheckResDecimal(ret,decimal)
   .s ret=temres_$c(1)_temres
   .b //2
   .;标准备注
   e  i itmtype["S" d
   .s preres=""
   .i $l(ret),$d(^TTAB("TC",tc,2,ret,1))  d
   ..s preres=$g(^TTAB("TC",tc,2,ret,1))
   .s ret=ret_$c(1)_preres
   .;血型
   e  i itmtype["B" d
   .s preres=""
   .i $l(ret),$d(^TTAB("BB-BG",ret)) d
   ..s preres=$p(^TTAB("BB-BG",ret),"\",1)
   .s ret=ret_$c(1)_preres
   .;bug
   e  i itmtype="V" d
   .i $l(ret),$d(^TTAB("BUG",ret)) d
   ..s preres=$p(^TTAB("BUG",ret),"\",1)
   ..s ret=ret_$c(1)_preres
   e  d
   .s ret=ret_$c(1)_ret
   q ret
}

ClassMethod CheckResDecimal(res, dec)
{
	//n (res,dec)
	s res=$g(res),dec=+$g(dec)
	s ret=""
	i res="" q ret
	i dec="" q ret
	s flag=""
	i ($e(res)="<")!($e(res)=">") s flag=$e(res),res=$tr(res,"<>")
	s res=+res
	s ret=$fn(res,"",dec)
	q flag_ret
}

// w ##class(web.DHCPE.TransResult).GetLabResultArrowNew(55616)

ClassMethod GetLabResultArrowNew(ResultID)
{
	s EpisodeID=$P($G(^DHCPERLT(ResultID)),"^",1)
	s LocID=$P($G(^PAADM(EpisodeID)),"^",4)

	s Arrow="1"
	i $D(^DHCPEDataEx("DHCPEResult",ResultID,"HLFlag")) d
	.s Info=$G(^DHCPEDataEx("DHCPEResult",ResultID,"HLFlag"))
	.s:(Info="H")||(Info="PH") Arrow="2"      
	.s:(Info="L")||(Info="PL") Arrow="0"
	e  d
	.s NormalFlag=$P($G(^DHCPERLT(ResultID)),"^",7)
	.q:NormalFlag="1"
	.s ODID=$P($G(^DHCPERLT(ResultID)),"^",3)
	.;i +ODID=$G(^DHCPESetting("DHCPE","StationId_Lab")) d
	.i +ODID=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID)) d
	..s NormalResult=$G(^DHCPEDataEx("DHCPEResult",ResultID,"Ranges"))
	.e  d
	..s EpisodeID=$P($G(^DHCPERLT(ResultID)),"^",1)
	..s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	..s myAge=$p(myStr,"^",1)
	..s mySex=$p(myStr,"^",2)
	..s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(ODID,mySex,myAge)
	.s ResultValue=$P($G(^DHCPERLT(ResultID)),"^",4)
	.s Arrow=..GetLabResultArrow(NormalResult, ResultValue)
	q Arrow
}

// w ##class(web.DHCPE.TransResult).GetLabResultArrow(">3","0.4")

ClassMethod GetLabResultArrow(NormalResult, ResultValue)
{
	s Arrow="1"
	q:ResultValue["阴性" 1
	q:ResultValue["阳性" 1
	q:ResultValue="大于=1.030" 2
	q:ResultValue[(">") 2
	q:ResultValue[("大于") 2
	q:ResultValue[("<") 0
	q:ResultValue[("小于") 0
	q:ResultValue[("≥") 2
	q:ResultValue[("≤") 0
	i NormalResult="" q Arrow
	s:NormalResult[("正常人群应:<3.37") NormalResult="<3.37"
	i NormalResult["<" d
	.s NormalResult=$p(NormalResult,"<",2)
	.i $e(NormalResult,1)="=" d
	..s NormalResult=$p(NormalResult,"=",2)
	.i ResultValue>+NormalResult s Arrow=2
	e  i NormalResult[">" d
	.s NormalResult=$p(NormalResult,">",2)
	.e  i $e(NormalResult,1)="=" d
	..s NormalResult=$p(NormalResult,"=",2)
	.i +ResultValue<+NormalResult s Arrow=0
	e  i NormalResult["小于" d
	.s NormalResult=$p(NormalResult,"小于",2)
	.i $e(NormalResult,1)="=" d
	..s NormalResult=$p(NormalResult,"=",2)
	.i ResultValue>+NormalResult s Arrow=2
	e  i NormalResult["大于" d
	.s NormalResult=$p(NormalResult,"大于",2)
	.e  i $e(NormalResult,1)="=" d
	..s NormalResult=$p(NormalResult,"=",2)
	.i ResultValue<+NormalResult s Arrow=0
	e  d
	.q:NormalResult'["-"
	.s Min=$p(NormalResult,"-",1)
	.s Max=$p(NormalResult,"-",2)
	.q:(Min="")&&(Max="")
	.i Min>ResultValue s Arrow="0"
	.i Max<ResultValue s Arrow="2"
	q Arrow
}

/*
ClassMethod TransMain(PAADM As %String = "")
{
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s RisStation="^"_RisStation_"^"
	s admId=%request.Get("EpisodeID")
	;s admId=%request.Get("PAADM")
	i admId="" s admId=PAADM
	q:admId="" ""
	s ret=""
	s userId=%session.Get("LOGON.USERID")
	s OEOrder=0
	f  s OEOrder=$O(^OEORD(0,"Adm",admId,OEOrder))  q:(OEOrder="")  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
	..s CurData=$G(^OEORD(OEOrder,"I",OEOrdItem,1))
	..Q:(""=CurData)
	..s ORIStat=$p(CurData,"^",13)
	..q:ORIStat'=6
	..s ordItmId=OEOrder_"||"_OEOrdItem
	..s ItemMastId=$p(CurData,"^",2)
	..s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	..q:StationId=""
	..;s RLTRowid=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	
	..s LabSpec=$p($G(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),3)),"^",20)
	..i (LabSpec'="") d  ;标本号不是空就回传
	...s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	..e  i (RisStation[("^"_StationId_"^")) d
	...s ret=##class(web.DHCPE.TransResult).TransARisItem(admId, ordItmId, userId)
	;d ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(admId, 0,"")
	
	q ret
	
	;w ##class(web.DHCPE.TransResult).TransMain(4012662)
	q:PAADM="" ""
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s RisStation="^"_RisStation_"^"
	s admId=%request.Get("EpisodeID")
	i admId="" s admId=PAADM
	s IADM=$o(^DHCPEIADM(0,"PAADM",admId,0))
	s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	s userId=%session.Get("LOGON.USERID")
	s GroupId=%session.Get("LOGON.GROUPID")
	s ret=""
	s ItemSub=0
	f  s ItemSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:(ItemSub="")  d
	.s Flag=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
	.q:Flag'=1
	.s ItemId=PreIADM_"||"_ItemSub
	.s ItemMastId=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",1)
	.s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	.s CrmOrderId=$o(^DHCPECRMO(0,"CRMORI",ItemId,0))
	.q:CrmOrderId=""
	.s ordItmId=$p(^DHCPECRMO(CrmOrderId),"^",1)
	.s RLTRowid=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	.s LabSpec=$p($G(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),3)),"^",20)
	.i (LabSpec'="") d  ;标本号不是空就回传
	..s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	.e  i (RisStation[("^"_StationId_"^")) d
	..s ret=##class(web.DHCPE.TransResult).TransARisItem(admId, ordItmId, userId)
	i (","_GroupId_",")=$G(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")) d
	.d ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(admId, 0,"")

	i ret'="" 
	{
		q ret
	}
	q ret
}
*/

/*
ClassMethod TransMain(PAADM As %String = "")
{
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s RisStation="^"_RisStation_"^"
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	s admId=%request.Get("EpisodeID")
	i admId="" s admId=PAADM
	q:admId="" ""
	s ret=""
	s userId=%session.Get("LOGON.USERID")
	s OEOrder=0
	f  s OEOrder=$O(^OEORD(0,"Adm",admId,OEOrder))  q:(OEOrder="")  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
	..s CurData=$G(^OEORD(OEOrder,"I",OEOrdItem,1))
	..Q:(""=CurData)
	..s ORIStat=$p(CurData,"^",13)
	..q:ORIStat'=6
	..s ordItmId=OEOrder_"||"_OEOrdItem
	..s ItemMastId=$p(CurData,"^",2)
	..s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	..q:StationId=""
	..;s RLTRowid=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	
	..s LabSpec=$p($G(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),3)),"^",20)
	..i (LabSpec'="")&&(LisNewVersion'="Y") d  ;标本号不是空就回传
	...s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	..e  i (LabSpec'="")&&(LisNewVersion="Y") d
	...s ret=##class(web.DHCPE.TransResult).TransALabItemNew(admId, userId,ordItmId)
	..e  i (RisStation[("^"_StationId_"^")) d
	...s ret=##class(web.DHCPE.TransResult).TransARisItem(admId, ordItmId, userId)
	;d ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(admId, 0,"")
	
	q ret
}
*/
ClassMethod TransMain(PAADM As %String = "")
{
	s admId=%request.Get("EpisodeID")
	i admId="" s admId=PAADM
	q:admId="" ""
	s CurLoc=$P($G(^PAADM(admId)),"^",4)
	
	//s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	//s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CurLoc))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CurLoc))

	s RisStation="^"_RisStation_"^"
	//s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",CurLoc))
	s TransResultFlag=##class(web.DHCPE.HISUICommon).GetSettingByLoc(%session.Get("LOGON.CTLOCID"),"TransResult")
	s admId=%request.Get("EpisodeID")
	i admId="" s admId=PAADM
	q:admId="" ""
	s ret=""
	s userId=%session.Get("LOGON.USERID")
	s OEOrder=0
	f  s OEOrder=$O(^OEORD(0,"Adm",admId,OEOrder))  q:(OEOrder="")  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
	..s CurData=$G(^OEORD(OEOrder,"I",OEOrdItem,1))
	..Q:(""=CurData)
	..s ORIStat=$p(CurData,"^",13)
	..q:ORIStat'=6
	..s ordItmId=OEOrder_"||"_OEOrdItem
	..s ItemMastId=$p(CurData,"^",2)
	..s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	..q:StationId=""
	..;s RLTRowid=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	
	..s LabSpec=$p($G(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),3)),"^",20)
	..i (LabSpec'="")&&(LisNewVersion'="Y") d  ;标本号不是空就回传
	...s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	..e  i (LabSpec'="")&&(LisNewVersion="Y")&&(TransResultFlag="PG") d
	...s ret=##class(web.DHCPE.TransResult).TransALabItemNew(admId,userId,ordItmId)
	..e  i (LabSpec'="")&&(LisNewVersion="Y")&&(TransResultFlag="PT") d
	...s ret=##class(web.DHCPE.TransResult).TransALabItemNewByPT(admId,userId,ordItmId)
	..e  i (RisStation[("^"_StationId_"^")) d
	...i (TransResultFlag="PT") d
	....s ret=##class(web.DHCPE.TransResult).TransARisItemByPT(admId,ordItmId,userId)
	...i (TransResultFlag="PG") d
	....s ret=##class(web.DHCPE.TransResult).TransARisItem(admId,ordItmId,userId)
	;d ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(admId, 0,"")
	
	q ret
}

ClassMethod Test()
{
	s id=0
	s i=0
	f  s id=$o(^DicomRpt(id)) q:i>30  d
	.s UserId=""
	.s DCMUserId=$P(^DicomRpt(DCMRPTRowId),"^",7)
	.i DCMUserId'="" s UserId=$p(^DicomCT(DCMUserId),"^",1)
	.w DCMUserID_"^"_UserId
}

/// 获取外部代码
/// w ##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare","2152||1")
ClassMethod GetLabExtCode(TrakVerison, arcItemId, OEORIID As %String = "")
{
	s LabExtCode=""
	i OEORIID=""
	{
		i TrakVerison="TrakCare" d
		.Quit:'$d(^ARCIM(+arcItemId,1,"EXT"))
		.s Ext=0
		.f  s Ext=$o(^ARCIM(+arcItemId,1,"EXT",Ext))  q:(Ext="")  d
		..s fromdate=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",1)
		..q:(+fromdate>+$H)
		..s todate=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",2)
		..q:((todate'="")&&(+todate<+$H))
		..Set LabExtCode=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",4)
	}
	else
	{
		s Ext=$P(^OEORD(+OEORIID,"I",$p(OEORIID,"||",2),3),"^",35)
		s LabExtCode=$P(Ext,"||",2)
		i LabExtCode="" s LabExtCode=..GetLabExtCode(TrakVerison, arcItemId)
	}
	q LabExtCode
}

/// 复兴医院 2008.03.03 xuwm
/// 获取身高体重仪的结果并填入到结果表中
/// stature avoirdupois
/// w ##Class(web.DHCPE.TransResult).GetBaseData(1)
ClassMethod GetBaseData(admid As %String = "")
{
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	// 获取当前的仪器值: 身高^体重
	s ResultValues=$G(^DHCTRAKTJ)
	Q:(""=ResultValues) "Error:Current No Data" //没有找到结果
	s ResultItems=$G(^DHCPESetting("DHCPE","GetBaseData"))
	Q:(""=ResultItems) "Error:No Test Item" //没有找到结果
	
	// 身高
	s stature=$P(ResultValues,"^",1)
	s:(stature>100) stature=stature
	s ret="^"_$P(ResultItems,"^",1)_":"_stature_";"
	
	// 体重
	s stature=$P(ResultValues,"^",2)
	s ret=ret_"^"_$P(ResultItems,"^",2)_":"_stature_";"
	
	Q ret
}

ClassMethod GetMaxRisReportID(RisStudyNo)
{
	q:RisStudyNo="" ""
	s maxDRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,""),-1)
	/*
	s maxDRPTRowId=0
	s dptRowId=0
	f  s dptRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,dptRowId))  q:dptRowId=""  d
	.b ;dptRowId
	.s maxDRPTRowId=dptRowId
	i maxDRPTRowId=0 s maxDRPTRowId=""
	*/
	q maxDRPTRowId
}

ClassMethod InsertNormalResult(admId, ordItmId, userId)
{
	i admId="" d
    .s:ordItmId'="" admId=$P($g(^OEORD(+ordItmId)),"^",1)
    s:admId'="" locId=$P($g(^PAADM(admId)),"^",4)
    
	q:$G(^DHCPESetting("DHCPE","AutoNormalResult",locId))'="Y" ""
	
	s C1=$C(1)
	s C2=$C(2)
	s ResultStr=""
	s PAPMI=$p($g(^PAADM(admId)),"^",1)
	s SexID=$P($g(^PAPER(PAPMI,"ALL")),"^",7)
	s SexCode=$P($g(^CT("SEX",SexID)),"^",1)
	s ARCIMID=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
    s StOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,locId)
	q:StOrderID="" ""
	s ODRelateID=0
    f  s ODRelateID=$o(^DHCPEODR(0,"OrderID",StOrderID,ODRelateID))  q:ODRelateID=""  d
    .s Sort=$p($G(^DHCPEODR(ODRelateID)),"^",3)
	.q:Sort=""
	.s DetailID=$p($G(^DHCPEODR(ODRelateID)),"^",2)
	.s DType=$P($G(^DHCPEST(+DetailID,"OD",$p(DetailID,"||",2))),"^",2)
	.q:DType'="S"
    .s SexType=$P($G(^DHCPEST(+DetailID,"OD",$p(DetailID,"||",2))),"^",9)
	.q:(SexType'="N")&&(SexType'=SexCode)
	.s NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(DetailID,SexCode,"17")
	.q:NormalStr=""
	.i ResultStr="" d
	..s ResultStr=DetailID_C1_NormalStr
	.e  d
	..s ResultStr=ResultStr_C2_DetailID_C1_NormalStr
	q:ResultStr=""
}

/*
ClassMethod InsertNormalResult(admId, ordItmId, userId)
{
	s locId=%session.Get("LOGON.CTLOCID")
	q:$G(^DHCPESetting("DHCPE","AutoNormalResult",locId))'="Y"
	s C1=$C(1)
	s C2=$C(2)
	s ResultStr=""
	s PAPMI=$p(^PAADM(admId),"^",1)
	s SexID=$P(^PAPER(PAPMI,"ALL"),"^",7)
	s SexCode=$P(^CT("SEX",SexID),"^",1)
	s ARCIMID=$p(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1),"^",2)
	s ODRelateID=0
	f  s ODRelateID=$o(^DHCPEODR(0,"ARCIM",ARCIMID,ODRelateID)) q:ODRelateID=""  d
	.s Sort=$p($G(^DHCPEODR(ODRelateID)),"^",3)
	.q:Sort=""
	.s DetailID=$p($G(^DHCPEODR(ODRelateID)),"^",2)
	.s DType=$P($G(^DHCPEST(+DetailID,"OD",$p(DetailID,"||",2))),"^",2)
	.q:DType'="S"
	.s SexType=$P($G(^DHCPEST(+DetailID,"OD",$p(DetailID,"||",2))),"^",9)
	.q:(SexType'="N")&&(SexType'=SexCode)
	.s NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(DetailID,SexCode,"17")
	.q:NormalStr=""
	.i ResultStr="" d
	..s ResultStr=DetailID_C1_NormalStr
	.e  d
	..s ResultStr=ResultStr_C2_DetailID_C1_NormalStr
	q:ResultStr=""
}
*/
/// d ##class(web.DHCPE.TransResult).TransAPISItem("784","746||3","1")
ClassMethod TransAPISItem(admId As %String, ordItmId As %String, UserId As %String)
{
	s LocID=$P($G(^PAADM(admId)),"^",4)
	//s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace"))
	s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace",LocID))

	s curZN=$ZNSpace
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	
	s PisInterfaceFlag=$g(^DHCPESetting("DHCPE","SendPisInterface",LocID))
	//s PisInterfaceFlag=$g(^DHCPESetting("DHCPE","SendPisInterface"))

	if (PisInterfaceFlag="Y") {
		///8.2.0新产品组方法
		///结果内容串:病理号^报告医生代码^报告医生^审核医生代码^审核医生^报告日期^审核日期
         ///^报告时间^审核时间^备注^肉眼所见^检查所见^诊断结果^检查结果^结果异常^PIS报告ID
		S value=##Class(web.DHCAPPPisInterface).GetPisItmRes(ordItmId)
		q:value="" "病理接口未返回诊断"
		 //检查所见
		s JCresult=$p(value,"^",12)
		i (JCresult="")||(JCresult=$c(0)) s JCresult=$p(value,"^",11)
		//诊断意见
		s ZDresult=$p(value,"^",13)
		//医生工号 
		s doc=$p(value,"^",4)
		s UserId=""
		i doc'="" d
		.s doc=$$ALPHAUP^SSUTIL4(doc)
		.s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",doc,""))
	

    	//报告发布日期
		s date=$zdh($p(value,"^",7),3) 
		
	}
	if (PisInterfaceFlag'="Y") {	
	//zn "PIS"
	zn PisNameSpace
	//病理8.0.2新版接口
	//PathID_"^"_RptClass_"^"_RptDiagnosis1_"^"_RptDiagnosis2_"^"_RptDoctor_"^"_RptDate_"^"_RptTime_"^"_RptLoc_"^"_PatName_"^"_sexDesc_"^"_PatBirth_"^"_AppDate_"^"_AppLoc_"^"_SurRoomNO
	//s value=##class(PISApp.PISService).GetRptInfoByTJOeorditemID(ordItmId)
	//病理8.1.1版接口
	//diagnosis_"^"_UserDR_"^"_rptDate
	s value=##class(Src.DPIS3OutInterface).GetPisDiagToTJ(ordItmId)
	zn curZN
	q:value="" "病理接口未返回诊断"
	//检查所见
	s JCresult=""
	//诊断意见
	s ZDresult=$p(value,"^",1)
	//医生工号 
	s doc=$p(value,"^",2)
	s UserId=""
	i doc'="" s UserId=doc
    //报告发布日期
	s date=$zdh($p(value,"^",3),3)
	}
	
	//q:TranedDate>date ""  //判断是否传输过
		 
	s retStr=..InsertBlankRisItem(ordItmId, UserId)
	q:(retStr'="") "插入细项失败"_retStr
	s ErrInfo=""
	s resultId="", orderDetailId=""
	f  s orderDetailId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId))  q:(orderDetailId="")  d
	.s resultId=$o(^DHCPERLT(0,"ADMOD",admId,ordItmId,orderDetailId,"0"))
	.s objResult=##class(User.DHCPEResult).%OpenId(resultId)
	.s RisItemDesc=objResult.RLTODDR.ODDesc	//细项的名称
	.s ODDesc=$p(RisItemDesc,"-",$l(RisItemDesc,"-"))
	.s ResultStr=""
	.i ODDesc="检查结果" d 
	..s JCresult=##class(web.DHCPE.ReportGetInfor).Replace(JCresult,"_$c(13,10)_","  ")
	..s JCresult=##class(web.DHCPE.ReportGetInfor).Replace(JCresult,"_$c_","  ")
	..s JCresult=##class(web.DHCPE.ReportGetInfor).Replace(JCresult,"\n","  ")
	..s ZDresult=##class(web.DHCPE.ReportGetInfor).Replace(ZDresult,"_$c(13,10)_","  ")
	..s ZDresult=##class(web.DHCPE.ReportGetInfor).Replace(ZDresult,"_$c_","  ")
	..s ZDresult=##class(web.DHCPE.ReportGetInfor).Replace(ZDresult,"\n","  ")
	..s ResultStr="临床诊断:"
	..s ResultStr=ResultStr_";检查所见:"_JCresult
	..s ResultStr=ResultStr_";诊断意见:"_ZDresult
	..s ^DHCPETempResult(ordItmId)=ResultStr
	..s objResult.RLTResult=ResultStr
	.e  d
	..s ErrInfo=ErrInfo_";没有修改体检结果表，请查看大项和细项组合关系对照里关联的细项是否为‘医嘱名称-检查结果’,并且是唯一关联的细项"
	.s objResult.RLTUpdateDate=date
	.s objResult.RLTUpdateTime=$p($h,",",2)
	.s objResult.RLTUserDR=UserId
	.s objResult.RLTNormal=0
	.s retStatus=objResult.%Save()
	.i ($System.Status.IsError(retStatus)) d
	..s ErrInfo=ErrInfo_";"_$System.Status.GetErrorText(retStatus)
	.s $p(^DHCPERLT(resultId),"^",4)=ResultStr
	.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",ordItmId)
	q:(ErrInfo'="") ErrInfo
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
}

// w ##class(web.DHCPE.TransResult).LabIsNormal("正常人群应:<3.37 高危人群应:<2.59 极高危人群应:<2.07","J6028","3.55")

ClassMethod LabIsNormal(NormalStr, CTTCCode, ItemValue)
{
	Quit:(($g(CTTCCode)="")||($g(ItemValue)="")) 1
	q:ItemValue[("阳性") 0
	q:ItemValue[("可疑") 0
	q:ItemValue[(">") 0
	q:ItemValue[("<") 0
	q:ItemValue[("阴性") 1
	
	q:ItemValue="TRACE" 0
	q:(NormalStr="NEG")&&(ItemValue'=NormalStr) 0
	q:ItemValue[("+") 0
	q:(NormalStr="")&&(ItemValue[("级)"))&&(ItemValue'[("0级)")) 0
	s RetFlag=0
	s:NormalStr[("正常人群应:<3.37") RetFlag=1
	s:NormalStr[("卵泡期:4.4-7.1") RetFlag=1
	s:NormalStr[("卵泡期:5.1-7.0") RetFlag=1
	s:NormalStr[("卵泡期:50-154.4") RetFlag=1
	s:NormalStr[("卵泡期:7.2-9.2") RetFlag=1
	s:NormalStr[("卵泡期:25.6-42.6") RetFlag=1
	s:NormalStr[("卵泡期:0.35-0.81") RetFlag=1
	;q:RetFlag=0 1
	s:NormalStr[("正常人群应:<3.37") NormalStr="<3.37"
	s:NormalStr[("卵泡期:4.4-7.1") NormalStr="2.6-49.7"
	s:NormalStr[("卵泡期:5.1-7.0") NormalStr="2.5-93.1"
	s:NormalStr[("卵泡期:50-154.4") NormalStr="20.7-460"
	s:NormalStr[("卵泡期:7.2-9.2") NormalStr="3.1-25"
	s:NormalStr[("卵泡期:25.6-42.6") NormalStr="6.1-55"
	s:NormalStr[("卵泡期:0.35-0.81") NormalStr="0.35-24"
	q:CTTCCode="" 1
	s NormalStr=##class(web.DHCPE.Public.Setting).Replace(NormalStr,"≤","<=")
	s NormalStr=##class(web.DHCPE.Public.Setting).Replace(NormalStr,"≥",">=")
	;s NormalStr=##class(web.DHCPE.Public.Setting).Replace(NormalStr,">=","")
	;s NormalStr=##class(web.DHCPE.Public.Setting).Replace(NormalStr,"<=","")
	;s NormalStr=##class(web.DHCPE.Public.Setting).Replace(NormalStr,">","")
	;s NormalStr=##class(web.DHCPE.Public.Setting).Replace(NormalStr,"<","")
	Set Normal=0
	Set ResultFormat=""
	s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i (ItemValue="NEGATIVE")&&(HospCode="SHHS") s ItemValue="阴性"
	s LocID=%session.Get("LOGON.CTLOCID")
	//Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)

	Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	
	s:ResultFormat="X" ResultFormat="N"
	If ResultFormat="X" Do
	.If NormalStr=ItemValue Set Normal=1
	.///尿常规正常值临时等马
	.//If $o(^TTAB("TC",CTTCCode,4,""))'="" Do
	.If $L(NormalStr,"-")>1 Do
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
	.if (ItemValue)="-" Set Normal=1
	If $e(ResultFormat,1)="N" Do
	.//Modified
	.i NormalStr["<" d
	..s NormalStr=$p(NormalStr,"<",2)
	..s EqualFlag=0
	..i NormalStr["=" d
	...s NormalStr=$p(NormalStr,"=",2)
	...s EqualFlag=1
	..s NormalStr=+NormalStr
	..s:(EqualFlag=1)&&(ItemValue<=NormalStr) Normal=1
	..s:(EqualFlag=0)&&(ItemValue<NormalStr) Normal=1
	.e  i NormalStr[">" d
	..s NormalStr=$p(NormalStr,">",2)
	..s EqualFlag=0
	..i NormalStr["=" d
	...s NormalStr=$p(NormalStr,"=",2)
	...s EqualFlag=1
	..s NormalStr=+NormalStr
	..s:(EqualFlag=1)&&(ItemValue>=NormalStr) Normal=1
	..s:(EqualFlag=0)&&(ItemValue>NormalStr) Normal=1
	.e  d
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
	//End
	If ResultFormat="S" Do
	.Set CTTCTCode=""
	.Set ResultDesc=""
	.Set NotNormal=""
	.For  Set CTTCTCode=$o(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:((CTTCTCode="")||(Normal=1))  Do
	..Set NotNormal=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
	..Set Format=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
	..Set ResultDesc=^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode,1)
	..If (ResultDesc=ItemValue)&(NotNormal="A") Set Normal=0
	..If ((ResultDesc=ItemValue)&(NotNormal'="A")) Set Normal=1
	b ;ResultFormat,!,NormalStr,!,ItemValue,!
	Quit:($g(ItemType)'="T")&(NormalStr="")&(ResultFormat="") 1
	Quit Normal
}

ClassMethod GetZBRISResult(PAADM, OEORDItemID)
{
	
	;w ##class(web.DHCPE.TransResult).GetZBRISResult("6619654","6497615||46")
	
	;s:OEORDItemID="4203815||4" OEORDItemID="4185938||4"
	;s:PAADM="4279105" PAADM="4260793"
	
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	
	s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
	s PIADM=$P(^DHCPEPreIADM(PIADM),"^",27) ;体检号
	s LocCode="1610000"
	s:LocID'="" LocCode=$P(^CTLOC(LocID),"^",1)
	
	i PIADM="VV0000432" s PIADM="FV0000432"
	i PIADM="P00006834" s PIADM="PAAKQ0003"
	s PIADM=PIADM_"^"_LocCode
	s ResultStream=##class(DHCENS.CheckHeal.BS.CheckHealService).GetZBTJRisResult(PIADM)
	q:ResultStream="" ""
	/*流转为字符串
	s StreamLen=ResultStream.SizeGet()
    d ResultStream.Rewind()
	s XML = ResultStream.Read(StreamLen)
	s Obj=##class(DHCENS.CheckHeal.Msg.TJRisReportList).%New()
	*/
	//流直接转换为对象
	b ;10
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(ResultStream)
	d reader.Correlate("TJRisReportList","DHCENS.CheckHeal.Msg.TJRisReportList")
	s obj=##class(DHCENS.CheckHeal.Msg.TJRisReportList).%New()
	s ResultCode="",ResultContent="",ResultInfo=""
	b ;11
	While reader.Next(.obj,.sc) {
		b ;12
		set Count=obj.TJRisReports.Count()
		q:Count=0
		b ;13
		set ResultCode=obj.ResultCode
		q:ResultCode'=0
		set ResultContent=obj.ResultContent
		;for i=1:1:Count
		;{
			set TJRisReport=##class(DHCENS.CheckHeal.Msg.TJRisReport).%New()
			set TJRisReport=obj.TJRisReports.GetAt(Count)
			b ;TJRisReport.ExamSee_";诊断意见:"_TJRisReport.Diagnose
			s ResultInfo="临床诊断:"_""_";检查所见:"_TJRisReport.ExamSee_";诊断意见:"_TJRisReport.Diagnose
			q:ResultInfo="临床诊断:;检查所见:;诊断意见:"
			s:TJRisReport.Auditor'="" TJRisReport.Auditor=$O(^SSU("SSUSR",0,"SSUSR_Name",TJRisReport.Auditor,0))
			b ;TJRisReport.Auditor
			
			s:TJRisReport.Writer'="" TJRisReport.Writer=$O(^SSU("SSUSR",0,"SSUSR_Name",TJRisReport.Writer,0))
			b ;TJRisReport.Writer
			
			s TJRisReport.AuditorDate=##class(web.DHCPE.Public.Setting).Replace(TJRisReport.AuditorDate,".","-")
			s:TJRisReport.AuditorDate'="" TJRisReport.AuditorDate=$ZDH(TJRisReport.AuditorDate,3)
			s:TJRisReport.AuditorTime'="" TJRisReport.AuditorTime=$ZTH(TJRisReport.AuditorTime)
			s TJRisReport.WriteRepotDate=##class(web.DHCPE.Public.Setting).Replace(TJRisReport.WriteRepotDate,".","-")
			s:TJRisReport.WriteRepotDate'="" TJRisReport.WriteRepotDate=$ZDH(TJRisReport.WriteRepotDate,3)
			s OEORDID=+OEORDItemID
			s OEORDID=$O(^OEORD(0,"Adm",PAADM,0))
			q:OEORDID=""
			s Sub=$P(OEORDItemID,"||",2)
			//f  s Sub=$O(^OEORD(OEORDID,"I",Sub)) q:Sub=""  d
			s Stat=$p($G(^OEORD(OEORDID,"I",Sub,1)),"^",13)
			q:Stat=4
			s arcItemId=$p(^OEORD(OEORDID,"I",Sub,1),"^",2)
			q:arcItemId=""
			s STRowId=0
			s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId))
			q:STRowId'="8"
			s RowID=OEORDID_"||"_Sub
			&SQL(Update Sqluser.OE_OrdItem set OEORI_ItemStat_DR='6' where OEORI_RowID=:RowID)
			q:SQLCODE'=0
			s RLTID=$o(^DHCPERLT(0,"OEORI",RowID,0))
			i RLTID="" d
			.s RLTObj=##class(User.DHCPEResult).%New()
			.s RLTObj.RLTADMDR=PAADM
			.s RLTObj.RLTARCIMDR=arcItemId
			.s RLTObj.RLTOEORIDR=RowID
			.s ODRID=$O(^DHCPEODR(0,"ARCIM",arcItemId, 0))
			.q:ODRID=""
			.s ODID=$P(^DHCPEODR(ODRID),"^",2)
			.d RLTObj.RLTODDRSetObjectId(ODID)
			e  d
			.s RLTObj=##class(User.DHCPEResult).%OpenId(RLTID)
			s RLTObj.RLTResult=""
			s RLTObj.RLTUpdateDate=TJRisReport.WriteRepotDate
			s RLTObj.RLTUpdateTime=$P($H,",",2)
			s RLTObj.RLTUserDR=TJRisReport.Writer
			s RLTObj.RLTNormal=0
			s retStatus=RLTObj.%Save()
			q:($$$ISOK(retStatus)'=1)
			s RLTID=RLTObj.%Id()
			s $p(^DHCPERLT(RLTID),"^",4)=ResultInfo
			k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",RowID)
			s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID) 
			
			//set Result1=TJRisReport.AdmOPNo_"^"_TJRisReport.Auditor_"^"_TJRisReport.AuditorDate_"^"_TJRisReport.AuditorTime_"^"_TJRisReport.Diagnose
			//set Result2=TJRisReport.ExamSee_"^"_TJRisReport.PatName_"^"_TJRisReport.PatRowId_"^"_TJRisReport.Writer_"^"_TJRisReport.WriteRepotDate
			//set Result3=TJRisReport.PatRowId
			
		;}
	}
	if ResultCode="0"
	{
		q 0
	}
	else
	{
		q ResultCode_"^"_ResultContent
	}
}

// d ##class(web.DHCPE.TransResult).EportNormalRange("1000000195")

ClassMethod EportNormalRange(ARCIMCode)
{
	s Par=$O(^ARCIM(0,"Code",ARCIMCode,0))
	q:Par="" "代码不存在"
	s ARCIMID=Par_"||1"
	s Flag=0
	s Order=""
	f  s Order=$O(^OEORDi(0,"ARCIM",Order),-1) q:(Order="")||(Flag=1)  d
	.s SttDat=""
	.f  s SttDat=$O(^OEORDi(0,"ARCIM",Order,ARCIMID,SttDat),-1) q:(SttDat="")||(Flag=1)  d
	..s Sub=""
	..f  s Sub=$O(^OEORDi(0,"ARCIM",Order,ARCIMID,SttDat,Sub),-1) q:(Sub="")||(Flag=1)  d
	...s LabItemSetID=$p($G(^OEORD(Order,"I",Sub,3)),"^",35)
	...q:LabItemSetID=""
	...s labItemCode=$p(LabItemSetID,"||",2)
	...s episodeNo=$p(^OEORD(Order,"I",Sub,3),"^",20)
	...s LabItemDetailCode=""
	...s i=0
	...f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	....w:i=0 "代码"_$C(9)_"描述"_$C(9)_"正常范围"_$C(9)_"单位",!
	....s i=i+1
	....s NormalStr=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Ranges"))
	....s Unit=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Unit"))
	....s Info=$G(^TTAB("TC",LabItemDetailCode))
	....s Desc=$P(Info,"\",1)
	....w LabItemDetailCode_$C(9)_Desc_$C(9)_NormalStr_$C(9)_Unit,!
	....s Flag=1
}

/*
s LabItemSetID=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",35)
	q:LabItemSetID="" ""

	i TrakVerison="TrakCare" d
	.Quit:'$d(^ARCIM(+arcItemId,1,"EXT"))
	.Set Ext=$o(^ARCIM(+arcItemId,1,"EXT",0))
	.Quit:$g(Ext)=""
	.Set labItemCode=$p(^ARCIM(+arcItemId,1,"EXT",Ext),"^",4)

	
	

	i "MedTrak"=TrakVerison d
	.s arcos=$p(^OEORD(+ordItmId,"I",$p(ordItmId,"||",2),3),"^",10)
	.Quit:$g(arcos)=""
	.s labItemCode=$P($G(^ARCOS(arcos)), "^", 11)
   
	i ((TrakVerison="TrakCare")&&($g(arcItemId)'="")) Set labItemCode=##Class(web.DHCPE.TransResult).GetLabExtCode("TrakCare",arcItemId)
	q:((labItemCode="")||(episodeNo="")) "Error: the arcItem's Ext_code is null."

	//判断检验状态
	s labItemStatus=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",31)
	q:(labItemStatus'="A") "Error: the result is not send by labDepartment."	//A: Authorised, 已发送
	
	
	//取检验录入日期   2007-07-27
	//s UpdateDate=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",4)
	s AuditDate=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",4)
	s AuditTime=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",5)
	s AuditTime=AuditTime*60
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	Quit:(AuditDate<TranedDate) "Date"  //判断是否传输过
	Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
	s sex=$P($g(^TEPI(episodeNo)),"\",3)
    s age=$P($g(^TEPI(episodeNo)),"\",25)
	Set myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(admId)
	Set mySex=$p(myStr,"^",2)
	Set myAge=$p(myStr,"^",1)    
	//审核人 2008-06-04
	s AuditUser=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",6)
	i AuditUser'="" d
	.s AuditUser=$ZCVT(AuditUser,"U")
	.s AuditUser=$O(^SSU("SSUSR",0,"SSUSR_Initials",AuditUser,""))
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser
	
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
	i LisInterface="N"  d
	.s num=""
  	.f  s num=$o(^TTAB("TS",labItemCode,0,num))  q:num=""  d
  	..s LabItemDetailCode=$p($g(^TTAB("TS",labItemCode,0,num)),"\",8)
  	..d TransResult
  	else  d
	.s LabItemDetailCode=""
	.f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	..d TransResult
	Q ""
TransResult

	s IsNormal=1
	s Code=$ZCVT(LabItemDetailCode,"U")
	s ItemID=""
	q:Code=""
	s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
	i stationID="" d
	.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetail(LabItemDetailCode)
	e  d
	.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
	.s ItemID=stationID_"||"_sub
	q:ItemID=""
	s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
	S labResult=$p(labResult,"\",1)
	q:labResult=""
	s LabResultStr=""
	s LisInterface=$g(^DHCPESetting("DHCPE","LisInterface"))
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
	s IsNormal=..LabIsNormal(NormalStr,LabItemDetailCode,labResult)
	//s CTTCTComm=$s(IsNormal=0:1,IsNormal=1:0)
	i LabResultStr'=""   d
	.s NormalFlag=$p(LabResultStr,$c(2),11)
	.i (NormalFlag="A")||(NormalFlag="P") s IsNormal="0"
	.else  s IsNormal="1"
	
	s UserId=$p($g(^TEPI(episodeNo,1,labItemCode,1)),"\",3)
	i (UserId'="")&&(LisInterface="Y") d
	.s UserId=$ZCVT(UserId,"U")
	.s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserId,""))
	
	i UserId="" s UserId=AuditUser

	s PLIST(2)=admId
	s PLIST(3)=arcItemId
	s PLIST(4)=ItemID
	s PLIST(5)=labResult
	s PLIST(6)=UserId
	s PLIST(7)=AuditDate //+$h
	s PLIST(8)=IsNormal
	s PLIST(11)=OEIId
	s PLIST(13)=$p($h,",",2)
	s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,OEIId,ItemID,0))
	i RLTID="" d
	.&SQL(Insert into sqluser.DHC_PE_Result values :PLIST())
	e  d
	.&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
	i SQLCODE=0  d
	.s RLTID=%ROWID
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
	.s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=Unit
	.s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID) 
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
	q 
	////Modified  Over
	
	///为了检验没有布局等信息修改
	s LabItemDetailCode=""
	f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	.s IsNormal=1
	.s Code=$ZCVT(LabItemDetailCode,"U")
	.s ItemID=""
	.s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
	.i stationID="" d
	..s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetail(LabItemDetailCode)
	.e  d
	..s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
	..s ItemID=stationID_"||"_sub
	.q:ItemID=""
	.s labResult=$g(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode))
	.S labResult=$p(labResult,"\",1)
	.s labResult=$p(labResult,$C(13,10),1)
	.i labResult[("阴性") d
	..s labResult=$P(labResult,"@",1)
	.e  d
	..s labResult=##class(web.DHCPE.Public.Setting).Replace(labResult,"@"," ")
	.//s labResult=$p(..trans(LabItemDetailCode,labResult),$c(1),2)
	.s NormalStr=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Ranges"))
	.;b ;NormalStr,LabItemDetailCode,labResult
	.s IsNormal=..LabIsNormal(NormalStr,LabItemDetailCode,labResult)
	.//s CTTCTComm=$s(IsNormal=0:1,IsNormal=1:0)
	.s UserId=$p($g(^TEPI(episodeNo,1,labItemCode,1)),"\",3)
	.i UserId'="" d
	..s UserId=$ZCVT(UserId,"U")
	..s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserId,""))
	
	.i UserId="" s UserId=AuditUser
	.// If $g(labResult)'="" Do
	.//.zn namespaceLab
	.//.s LabResultStr=$$TestItmRes^CHDhcLabReport(episodeNo,LabItemDetailCode,labResult,61062)
	.//.zn CurSpace
	.//. Set flag=$p(LabResultStr,$c(2),11)
	.//.If (flag'="")&(flag'="N") Set IsNormal="0"
	.s PLIST(2)=admId
	.s PLIST(3)=arcItemId
	.s PLIST(4)=ItemID
	.s PLIST(5)=labResult
	.s PLIST(6)=UserId
	.s PLIST(7)=AuditDate //+$h
	.s PLIST(8)=IsNormal
	.s PLIST(11)=OEIId
	.s PLIST(13)=$p($h,",",2)
	.s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,OEIId,ItemID,0))
	.i RLTID="" d
	..&SQL(Insert into sqluser.DHC_PE_Result values :PLIST())
	.e  d
	..&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
	.i SQLCODE=0  d
	..s RLTID=%ROWID
	..s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
	..s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=$G(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode,"Unit"))
	..s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID)         //add
	s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
	q ""

*/

// d ##class(web.DHCPE.TransResult).GetReg("7285000||29")

ClassMethod GetReg(ordItmId)
{
	Set RARRowId=$o(^DHCPACRegInfoi("OEORI",ordItmId,0))
	Quit:$g(RARRowId)="" "NoReport"
	Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	w RisStudyNo
}

/// Debug:w ##class(web.DHCPE.TransResult).TransALabItemNew()
ClassMethod TransALabItemNew(admId As %String, UserId As %String, ordItmId As %String)
{
	
	s episodeNo="", itemStatusDr="", OEIId=""
	i admId="" s admId=$P(^OEORD(+ordItmId),"^",1)
	s OEIId=ordItmId
	q:(OEIId="") "Error: No correct OEORDItem!"	//已停止
	s itemStatusDr=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	
	// 删除核实状态的医嘱的结果 检验撤销等
	i itemStatusDr="1" d
	.s ResultID=0
	.f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	..&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)
	
	s arcItemId=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",2)
	s episodeNo=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",20)
	q:($g(episodeNo)="") "Error: EpisodeNo is Null!"
	
	// //总检已经审核
	//是否是检验医嘱
	//q:(..CheckIsLabItem(OEIId)=0) "Error: the Item is not a labItem!"
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	//取检验外部代码  OEORI_LabTestSetRow
	s LabItemSetID=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",35)
	q:LabItemSetID="" "检验外部代码为空"
	
	//取检验报告信息
	s LisReportInfo=##Class(LabService.TSInfomation).GetLabInfo(ordItmId)
	
	//判断检验状态
	s labItemStatus=$P(LisReportInfo,$c(2),73)
	q:(labItemStatus'="3") "检验系统未审核结果"	//A: Authorised, 已发送
		
	//取检验录入日期 2007-07-27
	s AuditDate=$P(LisReportInfo,$c(2),64)
	i AuditDate'="" s AuditDate=$zdh(AuditDate,3)
	if (##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited"){
		s PEAuditDate=..GetAuditDate(admId)
		if (PEAuditDate<AuditDate){
			d ##Class(web.DHCPE.TransResult).NoticeAuditDoc(admId,ordItmId)
		
		}
	
	
	}
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") "总检已经审核"
	s AuditTime=$P(LisReportInfo,$c(2),65)
	i AuditTime'="" s AuditTime=$zth(AuditTime,3)
	
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	//Quit:(AuditDate<TranedDate) "Date" //判断是否传输过
	//Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
	
	//审核人 2008-06-04
	s AuditUser=$P(LisReportInfo,$c(2),66)
	i AuditUser'="" s AuditUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AuditUser),0))
	
	//录入人
	s EntryDate=$P(LisReportInfo,$c(2),60)
	i EntryDate'="" s EntryDate=$zdh(EntryDate,3)
	s EntryTime=$P(LisReportInfo,$c(2),61)
	i EntryTime'="" s EntryTime=$zth(EntryTime,3)
	s DoctorId=$P(LisReportInfo,$c(2),62)
	i DoctorId'="" s DoctorId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DoctorId),0))
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser
	
	//审核人
	Set DCMUserCode=$p($g(^SSU("SSUSR",AuditUser)),"^",1)
	Set DCMUserDesc=$p($g(^SSU("SSUSR",AuditUser)),"^",2)
	Set CheckUserInfo=##class(User.DHCPESSUser).SetPESSUser(DCMUserCode,DCMUserDesc,"TRIS")
		
	//录入人
	Set ReportUserCode=$p($g(^SSU("SSUSR",DoctorId)),"^",1)
	Set ReportUserDesc=$p($g(^SSU("SSUSR",DoctorId)),"^",2)
	Set ReportUserInfo=##class(User.DHCPESSUser).SetPESSUser(ReportUserCode,ReportUserDesc,"TRIS")
	//Quit:(CheckUserInfo="")&&(ReportUserInfo="") "录入人和审核人都为空"
	
	Set CheckUserID=$p(CheckUserInfo,"^",1)
	Set ReportUserID=$p(ReportUserInfo,"^",1)
	
	//备注
	s Remark=$P(LisReportInfo,$c(2),70)
	i Remark'="" d
	.s ^DHCPERLT("LabSpecNo",episodeNo)=Remark
	e  d
	.k ^DHCPERLT("LabSpecNo",episodeNo)

	s rs=##class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId") 
	d rs.Execute(ordItmId)
	s ResultSort=0
	s Job=$J
	s ErrInfo=""
	s GetActiveResult=0
	k ^TempDHCPETransResult(Job,OEIId)
	while(rs.Next())
	{
		s ResultSort=ResultSort+1
		s IsNormal=1
		s ItemID=""
		s Code=rs.Get("Code")
		if (Code=""){
			s:(ErrInfo'="") ErrInfo=ErrInfo_";检验接口返回了代码为空的数据，请联系检验工程师，检验接口：LabService.TSResult:GetResultByOrderId，入参:医嘱号！"
			s:(ErrInfo="") ErrInfo="检验接口返回了代码为空的数据，请联系检验工程师，检验接口：LabService.TSResult:GetResultByOrderId，入参:医嘱号！"
			
			}
		continue:Code=""
		b ;4
		s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
		i stationID="" d
		.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetailNew(Code,rs.Get("Name"),rs.Get("Unit"),rs.Get("Sync"))
		e  d
		.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
		.s ItemID=stationID_"||"_sub
		.i '$D(^DHCPECTDataEx("BaseData","ZhToEn",ItemID)) d
		..s ^DHCPECTDataEx("BaseData","ZhToEn",ItemID)=rs.Get("Sync")
		if (ItemID=""){
			s:(ErrInfo'="") ErrInfo=ErrInfo_";代码为"_Code_"的结果未找到对应的体检细项,请到细项维护查看!"
			s:(ErrInfo="") ErrInfo="代码为"_Code_"的结果未找到对应的体检细项,请到细项维护查看!"
			
			}
		continue:ItemID=""
		s labResult=rs.Get("Result")
		if (labResult=""){
			s:(ErrInfo'="") ErrInfo=ErrInfo_";代码为"_Code_"的结果为空,请联系检验工程师!"
			s:(ErrInfo="") ErrInfo="代码为"_Code_"的结果为空,请联系检验工程师!"
			
			}
		continue:labResult=""
		s NormalStr=rs.Get("Ranges")
		s NormalStr=##class(web.DHCPE.ReportGetInfor).Replace(NormalStr,"^","S")
		s Unit=rs.Get("Unit")
		s Unit=##class(web.DHCPE.ReportGetInfor).Replace(Unit,"^","S")
		s Flag=rs.Get("Flag")
		
		s HighRiskFlag="N"
		i (Flag="PL")||(Flag="PH")||(Flag="S") s HighRiskFlag="Y"
		i Flag'="" s IsNormal=0
		i DoctorId="" s DoctorId=AuditUser
		s Sequence=rs.Get("Sequence")
		i Sequence'="" s ResultSort=Sequence
		s PLIST(2)=admId
		s PLIST(3)=arcItemId
		s PLIST(4)=ItemID
		s PLIST(5)=labResult
		s PLIST(6)=DoctorId
		s PLIST(7)=AuditDate
		s PLIST(8)=IsNormal
		s PLIST(11)=OEIId
		s PLIST(13)=AuditTime
		s PLIST(14)=HighRiskFlag
		s PLIST(16)=ResultSort
		s PLIST(17)=AuditUser
		s PLIST(18)=CheckUserID
		s PLIST(19)=ReportUserID
		s PLIST(20)=CheckUserID
		s PLIST(21)=EntryDate
		s PLIST(22)=EntryTime
		s PLIST(23)=AuditDate
		s PLIST(24)=AuditTime
		s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,OEIId,ItemID,0))
		i RLTID="" d
		.&SQL(Insert into sqluser.DHC_PE_Result values:PLIST())
		e  d
		.&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
		i SQLCODE=0 d
		.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",ordItmId)
		.s RLTID=%ROWID
		.s ^TempDHCPETransResult(Job,OEIId,RLTID)=""
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=Unit
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"HLFlag")=Flag
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"Sync")=rs.Get("Sync")
		.;s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID) 
		.s GetActiveResult=1
		e  d
		.s:(ErrInfo'="") ErrInfo=ErrInfo_";更新体检结果失败，失败代码:"_SQLCODE_",失败描述:"_%msg_",请联系体检工程师!"
		.s:(ErrInfo="") ErrInfo="更新体检结果失败，失败代码:"_SQLCODE_",失败描述:"_%msg_",请联系体检工程师!"
		s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
		
	}
	q:(ErrInfo'="") ErrInfo
	q:(GetActiveResult=0) "检验接口未返回有效的数据，请联系检验工程师，检验接口：LabService.TSResult:GetResultByOrderId，入参:医嘱号！"
	
	// 删除多的细项结果 
	s DeleteErrCode=""
	s DeleteErrDesc=""
	s ResultID=0
	f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	.q:$D(^TempDHCPETransResult(Job,OEIId,ResultID))
	.&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)
	.i SQLCODE d
	..s:(DeleteErrCode'="") DeleteErrCode=DeleteErrCode_";"_SQLCODE
	..s:(DeleteErrCode="") DeleteErrCode=SQLCODE
	..s:(DeleteErrDesc'="") DeleteErrDesc=DeleteErrDesc_";"_%msg
	..s:(DeleteErrDesc="") DeleteErrDesc=%msg
	k ^TempDHCPETransResult(Job,OEIId)
	q:(DeleteErrCode'="") "删除体检的多余结果失败，失败代码:"_DeleteErrCode_"，失败描述:"_DeleteErrDesc_",请联系体检工程师！"
	Q ""
}

/// Creator:     xy
/// CreateDate:  20200416
/// Description: 从平台获取检验结果
/// Input:       admId:就诊ID, UserId:用户ID, ordItmId:医嘱ID
/// Debug: d ##class(web.DHCPE.TransResult).TransALabItemNewByPT()
ClassMethod TransALabItemNewByPT(admId As %String, UserId As %String, ordItmId As %String)
{
	s $zt="TransALabItemNewByPTerr"
	s episodeNo="", itemStatusDr="", OEIId=""
	i admId="" s admId=$P($g(^OEORD(+ordItmId)),"^",1)
	s LocID=$p($g(^PAADM(admId)),"^",4)
	s OEIId=ordItmId
	q:(OEIId="") "Error: No correct OEORDItem!"	//已停止
	s itemStatusDr=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",13)
	q:itemStatusDr="4" "Error: orderItem's status is stopped."	//已停止
	s arcItemId=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
	q:arcItemId="" "Error: arcItemId is null"
	s episodeNo=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3)),"^",20)
	q:($g(episodeNo)="") "Error: EpisodeNo is Null!"
	
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcItemId,LocID)
    s STRowId=$p(StatOrderDR,"||",1)      //站点ID
	q:(""=STRowId) "站点为空,请查看站点和项目组合数据维护是否正确！"
	
	
	// 删除核实状态的医嘱的结果 检验撤销等
	i itemStatusDr="1" d
	.s ResultID=0
	.f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	..&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)

	
	//是否是检验医嘱
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	
	//取检验外部代码  OEORI_LabTestSetRow(注：多院区HIS8.5医嘱表没插入检验外部代码)
	s LabItemSetID=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3)),"^",35)
	//q:LabItemSetID="" "检验外部代码为空"
	
	//取检验报告信息
	//d ##Class(web.DHCENS.EnsHISService).DHCHisInterface("GetLabInfo","781||1")
	s LisReportInfo=##Class(web.DHCENS.EnsHISService).DHCHisInterface("GetLabInfo",ordItmId)
	;b ;LisReportInfo
	
	//判断检验状态
	s labItemStatus=$P(LisReportInfo,$c(2),73)
	;b ;labItemStatus
	q:(labItemStatus'="1") "检验系统未审核结果" //"Error: the result is not send by labDepartment."	//1:审核  2:取消审核 3:作废
	
	//审核日期 
	s AuditDate=$P(LisReportInfo,$c(2),64)
	i AuditDate'="" s AuditDate=$zdh(AuditDate,3)
	
	if (##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited"){
		s PEAuditDate=..GetAuditDate(admId)
		if (PEAuditDate<AuditDate){
			d ##Class(web.DHCPE.TransResult).NoticeAuditDoc(admId,ordItmId)
		
		}
	
	
	}
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") "总检已经审核"
	
	//审核时间
	s AuditTime=$P(LisReportInfo,$c(2),65)
	i AuditTime'="" s AuditTime=$zth(AuditTime,3)

	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	//Quit:(AuditDate<TranedDate) "Date" //判断是否传输过
	//Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
	
	//审核人
	s AuditUser=$P(LisReportInfo,$c(2),66)
	i AuditUser'="" s AuditUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AuditUser),0))
	
	//录入日期 
	s EntryDate=$P(LisReportInfo,$c(2),60)
	i EntryDate'="" s EntryDate=$zdh(EntryDate,3)
	
	//录入时间 
	s EntryTime=$P(LisReportInfo,$c(2),61)
	i EntryTime'="" s EntryTime=$zth(EntryTime,3)
	
	//录入人
	s DoctorId=$P(LisReportInfo,$c(2),62)
	i DoctorId'=""  s DoctorId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DoctorId),0))
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser

	/*** 体检操作人员库表——DHC_PE_SSUser
	（1）根据审核医生（录入医生）Code、审核医生（录入医生）Desc判断是否是his里ss_user表的人员，
		 如果是，表DHC_PE_SSUser中字段SSU_User_DR更新为ss_user表的ID,
		 如果不是，表DHC_PE_SSUser中字段SSU_User_DR值为空；
	（2）结果表字段RLT_ResultUser_DR，RLT_ReportUser_DR 报告人，RLT_AuditUser_DR 审核人
		 分别存的是表DHC_PE_SSUser的ID,这样不管检查、检验是不是第三方，都可以取DHC_PE_SSUser中相关字段对应的值
	***/	
	
	//审核人
	Set DCMUserCode=$P(LisReportInfo,$c(2),66) //审核人Code
	Set DCMUserDesc=$P(LisReportInfo,$c(2),67) //审核人Desc
	Set CheckUserInfo=##class(User.DHCPESSUser).SetPESSUser(DCMUserCode,DCMUserDesc,"TLIS")
		
	//录入人
	Set ReportUserCode=$P(LisReportInfo,$c(2),62) //录入人Code
	Set ReportUserDesc=$P(LisReportInfo,$c(2),63) //录入人Desc
	Set ReportUserInfo=##class(User.DHCPESSUser).SetPESSUser(ReportUserCode,ReportUserDesc,"TLIS")
	//Quit:(CheckUserInfo="")&&(ReportUserInfo="") "录入人和审核人都为空"
	;b ;CheckUserInfo ReportUserInfo DCMUserCode DCMUserDesc  ReportUserCode ReportUserDesc
	
	//取DHC_PE_SSUser表的ID
	Set CheckUserID=$p(CheckUserInfo,"^",1)
	Set ReportUserID=$p(ReportUserInfo,"^",1)
	
	//备注
	s Remark=$P(LisReportInfo,$c(2),70)
	i Remark'="" d
	.s ^DHCPERLT("LabSpecNo",episodeNo)=Remark
	e  d
	.k ^DHCPERLT("LabSpecNo",episodeNo)
	
    //调取平台获取检验报告的query
    //d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectLISReportByOeordID","232||6")
	s rs=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID") 
	
	d rs.Execute(ordItmId)
	s ResultSort=0
	s Job=$J
	s ErrInfo=""
	s GetActiveResult=0
	k ^TempDHCPETransResult(Job,OEIId)
	while(rs.Next())
	{
		s ResultSort=ResultSort+1
		s IsNormal=1
		s ItemID=""
		s Code=rs.Get("ItemCode")
		if (Code=""){
			s:(ErrInfo'="") ErrInfo=ErrInfo_";平台接口返回了代码为空的数据，请联系平台工程师，平台接口：web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID，入参:医嘱号！"
			s:(ErrInfo="") ErrInfo="平台接口返回了代码为空的数据，请联系平台工程师，平台接口：web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID，入参:医嘱号！"
			
			}
		continue:Code=""
		
		/*s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
		i stationID="" d
		.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetailNew(Code,rs.Get("ItemDesc"),rs.Get("ItemUnit"),rs.Get("Synonym"))
		e  d
		.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
		.s ItemID=stationID_"||"_sub
		.i '$D(^DHCPEDataEx("BaseData","ZhToEn",ItemID)) d
		..s ^DHCPEDataEx("BaseData","ZhToEn",ItemID)=rs.Get("Synonym")
		*/
		
		s CodeU=$$ALPHAUP^SSUTIL4(Code)
		s StatID=""
		f  s StatID=$O(^DHCPEST(0,"OD_Code",CodeU,StatID))  q:StatID=""  d
		.s ODSub=""
		.f  s ODSub=$O(^DHCPEST(0,"OD_Code",CodeU,StatID,ODSub))  q:ODSub=""  d 
		..s ODID=StatID_"||"_ODSub
		..s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODID,LocID)
	    ..q:LocShowDFlag'="Y"
	    ..s stationID=StatID
	    ..s ItemID=ODID
		
		i ItemID="" d
		.s ItemID=##class(web.DHCPE.CT.StatOrderDetail).ImpOneLabDetailNew(Code,rs.Get("ItemDesc"),rs.Get("ItemUnit"),rs.Get("Synonym"),StatOrderDR,LocID,UserId)
		e  d
		. s ODSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,ItemID,0))
		.i ODSetID'="" d
		..s obj=##class(User.DHCPEOrderDetailSet).%OpenId(ODSetID)
		..s obj.ODSZhToEn=rs.Get("Synonym")
		..s sc=obj.%Save()
		..d obj.%Close()
		if (ItemID=""){
			s:(ErrInfo'="") ErrInfo=ErrInfo_";代码为"_Code_"的结果未找到对应的体检细项,请到细项维护查看!"
			s:(ErrInfo="") ErrInfo="代码为"_Code_"的结果未找到对应的体检细项,请到细项维护查看!"
			
			}
		continue:ItemID=""
		s labResult=rs.Get("ItemResult")
		if (labResult=""){
			s:(ErrInfo'="") ErrInfo=ErrInfo_";代码为"_Code_"的结果为空,请联系平台工程师!"
			s:(ErrInfo="") ErrInfo="代码为"_Code_"的结果为空,请联系平台工程师!"
			
			}
		continue:labResult=""
		s NormalStr=rs.Get("ItemRanges")
		s NormalStr=##class(web.DHCPE.ReportGetInfor).Replace(NormalStr,"^","S")
		s Unit=rs.Get("ItemUnit")
		s Unit=##class(web.DHCPE.ReportGetInfor).Replace(Unit,"^","S")
		s Flag=rs.Get("AbnorFlag")
		
		s HighRiskFlag="N"
		i (Flag="PL")||(Flag="PH")||(Flag="S") s HighRiskFlag="Y"
		i Flag'="" s IsNormal=0
		i DoctorId="" s DoctorId=AuditUser
		s Sequence=rs.Get("Sequence")
		i Sequence'="" s ResultSort=Sequence
		s PLIST(2)=admId
		s PLIST(3)=arcItemId
		s PLIST(4)=ItemID
		s PLIST(5)=labResult
		s PLIST(6)=DoctorId
		i AuditDate'="" d
		. s PLIST(7)=AuditDate
		e  d
		. s PLIST(7)=+$h
		s PLIST(8)=IsNormal
		s PLIST(11)=OEIId
		i AuditTime'="" d
		.s PLIST(13)=AuditTime
		e  d
		.s PLIST(13)=$p($h,",",2)
		s PLIST(14)=HighRiskFlag
		s PLIST(16)=ResultSort
		s PLIST(17)=AuditUser
		s PLIST(18)=CheckUserID
		s PLIST(19)=ReportUserID
		s PLIST(20)=CheckUserID
		s PLIST(21)=EntryDate
		s PLIST(22)=EntryTime
		s PLIST(23)=AuditDate
		s PLIST(24)=AuditTime
		s RLTID=$O(^DHCPERLT(0,"ADMOD",admId,OEIId,ItemID,0))
		i RLTID="" d
		.&SQL(Insert into sqluser.DHC_PE_Result values:PLIST())
		e  d
		.&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
		i SQLCODE=0 d
		.k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",ordItmId)
		.s RLTID=%ROWID
		.s ^TempDHCPETransResult(Job,OEIId,RLTID)=""
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"Ranges")=NormalStr
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"Unit")=Unit
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"HLFlag")=Flag
		.s ^DHCPEDataEx("DHCPEResult",RLTID,"Sync")=rs.Get("Sync")
		.;s SQLCODE=##class(web.DHCPE.HighRisk).GetHighRiskFlag(RLTID)
		.s GetActiveResult=1
		e  d
		.s:(ErrInfo'="") ErrInfo=ErrInfo_";更新体检结果失败，失败代码:"_SQLCODE_",失败描述:"_%msg_",请联系体检工程师!"
		.s:(ErrInfo="") ErrInfo="更新体检结果失败，失败代码:"_SQLCODE_",失败描述:"_%msg_",请联系体检工程师!"
		s ^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId)=$h
		
	}
	q:(ErrInfo'="") ErrInfo
	q:(GetActiveResult=0) "平台接口未返回有效的数据，请联系平台工程师，平台接口：web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID，入参:医嘱号！"
	// 删除多的细项结果 
	s DeleteErrCode=""
	s DeleteErrDesc=""
	s ResultID=0
	f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEIId,ResultID)) q:ResultID=""  d
	.q:$D(^TempDHCPETransResult(Job,OEIId,ResultID))
	.&SQL(Delete Sqluser.DHC_PE_Result where RLT_RowID=:ResultID)
	.i SQLCODE d
	..s:(DeleteErrCode'="") DeleteErrCode=DeleteErrCode_";"_SQLCODE
	..s:(DeleteErrCode="") DeleteErrCode=SQLCODE
	..s:(DeleteErrDesc'="") DeleteErrDesc=DeleteErrDesc_";"_%msg
	..s:(DeleteErrDesc="") DeleteErrDesc=%msg
	k ^TempDHCPETransResult(Job,OEIId)
	q:(DeleteErrCode'="") "删除体检的多余结果失败，失败代码:"_DeleteErrCode_"，失败描述:"_DeleteErrDesc_",请联系体检工程师！"
	
		
	Q ""
TransALabItemNewByPTerr
	s ^DHCPEDataEx("TransResultNew",ordItmId)=$H
	q "回传检验结果出现异常:"_$ZERROR
}

ClassMethod GetStatus(PAADM)
{
	s ostid=$g(^DHCPESetting("DHCPE","StationId_Other"))
	s OEOrder=0,sta=0
	f  s OEOrder=$O(^OEORD(0,"Adm",PAADM,OEOrder))  q:(OEOrder="")||(sta=2)  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")||(sta=2)  d
	..s CurData=$G(^OEORD(OEOrder,"I",OEOrdItem,1))
	..Q:(""=CurData)
	..s ORIStat=$p(CurData,"^",13)
	..q:(ORIStat=4)
	..Quit:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEOrder_"||"_OEOrdItem))
	..s ItemMastId=$p(CurData,"^",2)
	..s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	..q:StationId=""
	..q:(StationId=ostid)
	..s:(sta'=1)&&('$d(^DHCPERLT(0,"OEORI",OEOrder_"||"_OEOrdItem))) sta=3
	..s:(sta'=3)&&($d(^DHCPERLT(0,"OEORI",OEOrder_"||"_OEOrdItem))) sta=1
	..s:(sta=1)&&('$d(^DHCPERLT(0,"OEORI",OEOrder_"||"_OEOrdItem))) sta=2
	..s:(sta=3)&&($d(^DHCPERLT(0,"OEORI",OEOrder_"||"_OEOrdItem))) sta=2
	s ^DHCPEDataEx("TransResult",PAADM,"S")=sta
 	s ^DHCPEDataEx("TransResult",PAADM)=$h
	q sta
}

ClassMethod GetResultCount(OEID)
{
	//w ##class(web.DHCPE.TransResult).GetResultCount("5899667||22")
	s Count=0
	s ResultID=""
	s Job=$J
	k ^TempDHCPETransResult(Job,"Desc",OEID)
	f  s ResultID=$O(^DHCPERLT(0,"OEORI",OEID,ResultID)) q:ResultID=""  d
	.s ODID=$P(^DHCPERLT(ResultID),"^",3)
	.s ODDesc=$P($g(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",1)
	.q:$D(^TempDHCPETransResult(Job,"Desc",OEID,ODDesc))
	.s ^TempDHCPETransResult(Job,"Desc",OEID,ODDesc)=""
	.s Count=Count+1
	k ^TempDHCPETransResult(Job,"Desc",OEID)
	q Count
}

/// Descript:验证是否存在结果和实际接口不一致
/// Creater:	孙鑫涛
/// CreateDate:	2021-05-11
/// Input: PAADM就诊号
/// 
/// Return:0  不存在  1 存在  -1 出错   增加结果不一致的描述 DifResultDesc
/// Debugger:w ##class(web.DHCPE.TransResult).CheckMain()
ClassMethod CheckMain(PAADM As %String = "", GSIDFlag As %String = "N")
{
	S $ZT="ErrCheck"
	s:(GSIDFlag="Y") PAADM=$p($g(^DHCPEGS(PAADM,1)),"^",8)
	 s admId=PAADM
	 s DifResultDesc=""
	q:admId="" "-1^"
	s CurLoc=$P($G(^PAADM(admId)),"^",4)
	s DifResultDesc=""
	//s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	//s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CurLoc))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CurLoc))

	s RisStation="^"_RisStation_"^"
	//s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",CurLoc))
	s TransResultFlag=..GetSettingByLoc(%session.Get("LOGON.CTLOCID"),"TransResult")
	
	i admId="" s admId=PAADM
	q:admId="" "-1^"
	s ret="0"
	s userId=%session.Get("LOGON.USERID")
	s OEOrder=0
	f  s OEOrder=$O(^OEORD(0,"Adm",admId,OEOrder))  q:(OEOrder="")  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:(OEOrdItem="")  d
	..s CurData=$G(^OEORD(OEOrder,"I",OEOrdItem,1))
	..Q:(""=CurData)
	..s ORIStat=$p(CurData,"^",13)
	..q:ORIStat'=6
	..s ordItmId=OEOrder_"||"_OEOrdItem
	..s ItemMastId=$p(CurData,"^",2)
	..s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	..q:StationId=""
	..;s RLTRowid=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	..s LabSpec=$p($G(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),3)),"^",20)
	..i (LabSpec'="")&&(LisNewVersion'="Y") d  ;标本号不是空就回传
	...s retNew=..CheckLabResultForXH(admId, userId,ordItmId)
	...s ret=$p(retNew,"^",1)
	...s DifResultDesc=DifResultDesc_$p(retNew,"^",2)
	..e  i (LabSpec'="")&&(LisNewVersion="Y")&&(TransResultFlag'="PT") d
	...s retNew=..CheckALabItemNew(admId,userId,ordItmId)
	...s ret=$p(retNew,"^",1)
	...s DifResultDesc=DifResultDesc_$p(retNew,"^",2)
	..e  i (LabSpec'="")&&(LisNewVersion="Y")&&(TransResultFlag="PT") d
	...s retNew=..CheckALabItemNewByPT(admId,userId,ordItmId)
	...s ret=$p(retNew,"^",1)
	...s DifResultDesc=DifResultDesc_$p(retNew,"^",2)
	..e  i (RisStation[("^"_StationId_"^")) d
	...i (TransResultFlag="PT") d
	....s retNew=..CheckARisItemByPT(admId,ordItmId,userId)
	....s ret=$p(retNew,"^",1)
	....s DifResultDesc=DifResultDesc_$p(retNew,"^",2)
	...i (TransResultFlag'="PT") d
	....s retNew=..CheckARisItem(admId,ordItmId,userId)
	....s ret=$p(retNew,"^",1)
	....s DifResultDesc=DifResultDesc_$p(retNew,"^",2)
	;d ##class(web.DHCPE.ResultDiagnosis).UpdateStationS(admId, 0,"")
	
	q ret_"^"_DifResultDesc
ErrCheck
	s $ZT=""
	
	s rtn="-1^验证失败："_$ZE	
	q rtn
}

ClassMethod CheckLabResultForXH(admId As %String, UserId As %String, ordItmId As %String)
{
	//w ##class(web.DHCPE.TransResultEx).TransLabResultForXH(6672698,5918,"6549675||2")
	s episodeNo="", itemStatusDr="", OEIId=""
	s labItemCode=""
	s LocID=$P($G(^PAADM(admId)),"^",4)
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
	s ret=0
	s CurSpace=$ZNSpace
	s OEIId=ordItmId
	q:(OEIId="") "0"	//已停止
	q:$d(^DHCPEDataEx("SavePEResult","OEORI",ordItmId)) "0"
	s DifDesc=""
	/// m结果表这个索引用于 后面验证体检是否存在多余的结果
	k ^DHCPERLTTMP(0,"OEORI",ordItmId)
	m ^DHCPERLTTMP(0,"OEORI",ordItmId)=^DHCPERLT(0,"OEORI",ordItmId)
	
	
	s itemStatusDr=$p($G(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",13)
	q:itemStatusDr="" "0"
	q:itemStatusDr="4" "0"	//已停止
	
	
	
	//i OEIId="6107560||112" s OEIId="6107560||1"
	s arcItemId=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1),"^",2)
	s episodeNo=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",20)
	q:($g(episodeNo)="") "0"
	s admId=$P(^OEORD(+OEIId),"^",1)
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") "0" //总检已经审核
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	
	//取检验外部代码
	s labItemCode=""
	/*同一标本号回传不同医嘱*/
	s LabItemSetID=$p(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3),"^",35)
	q:LabItemSetID="" 0 //"外部代码错误"_LabItemSetID
	s labItemCode=$p(LabItemSetID,"||",2)
	q:labItemCode="" 0 //"NoLabItemCode"
	/*同一标本号回传到一个医嘱*/
	/*
	s labItemCode=$O(^TEPI(episodeNo,1,""))
	q:labItemCode="" "NoLabItemCode"
	*/
	
	//判断检验状态
	s labItemStatus=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",31)
	q:(labItemStatus'="A") 0 //"检验报告未发送"	//A: Authorised, 已发送
	//取检验录入日期   2007-07-27
	s AuditDate=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",4)
	s AuditTime=$P($g(^TEPI(episodeNo,1,labItemCode,1)),"\",5)
	s AuditTime=AuditTime*60
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
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
  	..d CheckResult
  	else  d
	.d ..SetArcimInfo(episodeNo,+ordItmId,Job)
	.b ;^TempDHCPETransResult
	.s LabItemDetailCode=""
	.f  s LabItemDetailCode=$O(^TEPI(episodeNo,1,labItemCode,1,"DATA",LabItemDetailCode)) q:LabItemDetailCode=""  d
	..d CheckResult
	k ^TempDHCPETransResult(Job,"TranResult")
	
	i $d(^DHCPERLTTMP(0,"OEORI",ordItmId)) d
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" 存在多余结果"
	.s:(DifDesc="") DifDesc=ArcDesc_" 存在多余结果"
	.s RltID=0
	.f  s RltID=$o(^DHCPERLTTMP(0,"OEORI",ordItmId,RltID)) q:(RltID="")  d
	..s ODID=$p(^DHCPERLTTMP(RltID),"^",3)
	..s OneRlt=$p(^DHCPERLTTMP(RltID),"^",4)
	..s ODDesc=$p(^DHCPEST(+ODID,"OD",$p(ODID,"||",2)),"^",1)
	..s ret=1
	..s DifDesc=DifDesc_","_ODDesc_":"_OneRlt
	..//s:($d(^DHCPERLTTMP(0,"PAADM_OD",admId))) ret=1
	
	
	
	Q ret_"^"_DifDesc
CheckResult

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
	
	s CurResult="" /// 结果表没数据的 也是不一致的
	s RltID=$o(^DHCPERLT(0,"PAADM_OD",admId,ItemID,0))
		
	s:(RltID'="") CurResult=$p(^DHCPERLT(RltID),"^",4) /// 结果表结果
	
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
		/// 这个感觉有问题 先注释 20210511
		//s ^DHCPENoRelateDetailResult(+$H,episodeNo,labItemCode,LabItemDetailCode)=OEIId
		//q
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
	s:(LisInterface="") LisInterface=$g(^DHCPESetting("DHCPE","LisInterface",LocID))
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
	
	i CurResult'=labResult d
	.s ret=1
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" "_ODDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_labResult
	.s:(DifDesc="") DifDesc=ArcDesc_" "_ODDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_labResult
	
	i RltID'="" d
	./// 结果一致的k掉这个临时global 最后验证是否还存在  存在表示结果表有不一致的或多的结果
	.k ^DHCPERLTTMP(0,"OEORI",ordItmId,RltID)
	
	q 
	////Modified  Over
}

ClassMethod GetSettingByLoc(locid, parameter)
{
	i (parameter="LABDATA")||(parameter="MEDDATA") q $g(^DHCPESetting("NAMESPACE",parameter))
	i (parameter="SendRisApplication") q $g(^DHCPESetting("DHCPE","StationId_Ris",parameter))
	
	i $d(^DHCPESetting("DHCPE",parameter,locid)) q $g(^DHCPESetting("DHCPE",parameter,locid))
	q $g(^DHCPESetting("DHCPE",parameter))
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

ClassMethod CheckALabItemNew(admId As %String, UserId As %String, ordItmId As %String)
{
	
	s episodeNo="", itemStatusDr="", OEIId=""
	i admId="" s admId=$P(^OEORD(+ordItmId),"^",1)
	s OEIId=ordItmId
	q:(OEIId="") 0	//已停止
	q:$d(^DHCPEDataEx("SavePEResult","OEORI",ordItmId)) "0"
	s DifDesc=""
	/// m结果表这个索引用于 后面验证体检是否存在多余的结果
	k ^DHCPERLTTMP(0,"OEORI",ordItmId)
	m ^DHCPERLTTMP(0,"OEORI",ordItmId)=^DHCPERLT(0,"OEORI",ordItmId)
	
	s itemStatusDr=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",13)
	q:itemStatusDr="4" 0
	s ret=0
	
	
	s arcItemId=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",2)
	s episodeNo=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3)),"^",20)
	q:($g(episodeNo)="") 0
	
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") 0
	//是否是检验医嘱
	//q:(..CheckIsLabItem(OEIId)=0) "Error: the Item is not a labItem!"
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	//取检验外部代码  OEORI_LabTestSetRow
	s LabItemSetID=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3)),"^",35)
	q:LabItemSetID="" 0
	
	//取检验报告信息
	s LisReportInfo=##Class(LabService.TSInfomation).GetLabInfo(ordItmId)
	
	
	
	//判断检验状态
	
	s labItemStatus=$P(LisReportInfo,$c(2),73)
	//q:(labItemStatus'="3") 0  /// 取消的也要继续判断 体检可能存在多余的结果
	
	
	//取检验录入日期 2007-07-27
	s AuditDate=$P(LisReportInfo,$c(2),64)
	s AuditDate=$zdh(AuditDate,3)
	s AuditTime=$P(LisReportInfo,$c(2),65)
	s AuditTime=$zth(AuditTime,3)
	
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	//Quit:(AuditDate<TranedDate) "Date" //判断是否传输过
	//Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
	
	
	//审核人 2008-06-04
	s AuditUser=$P(LisReportInfo,$c(2),66)
	i AuditUser'="" s AuditUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AuditUser),0))
	
	//录入人
	s DoctorId=$P(LisReportInfo,$c(2),62)
	i DoctorId'="" s DoctorId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DoctorId),0))
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser
	
	//备注
	s Remark=$P(LisReportInfo,$c(2),70)
	i Remark'="" d
	.s ^DHCPERLT("LabSpecNo",episodeNo)=Remark
	e  d
	.k ^DHCPERLT("LabSpecNo",episodeNo)

	s rs=##class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId") 
	d rs.Execute(ordItmId)
	s ResultSort=0
	s Job=$J
	k ^TempDHCPETransResult(Job,OEIId)
	while(rs.Next())
	{
		s ResultSort=ResultSort+1
		s IsNormal=1
		s ItemID=""
		s Code=rs.Get("Code")
		continue:Code=""
		
		
		
		
		s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
		i stationID="" d
		.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetailNew(Code,rs.Get("Name"),rs.Get("Unit"),rs.Get("Sync"))
		e  d
		.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
		.s ItemID=stationID_"||"_sub
		.i '$D(^DHCPECTDataEx("BaseData","ZhToEn",ItemID)) d
		..s ^DHCPECTDataEx("BaseData","ZhToEn",ItemID)=rs.Get("Sync")
		continue:ItemID=""
		s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
		s CurResult="" /// 结果表没数据的 也是不一致的
		s RltID=$o(^DHCPERLT(0,"PAADM_OD",admId,ItemID,0))
		
		s:(RltID'="") CurResult=$p(^DHCPERLT(RltID),"^",4) /// 结果表结果
		
		s labResult=rs.Get("Result")
		continue:labResult=""
		s:(CurResult'=labResult) ret=1
		i CurResult'=labResult d
		.s ret=1
		.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
		.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" "_ODDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_labResult
		.s:(DifDesc="") DifDesc=ArcDesc_" "_ODDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_labResult
		
		i RltID'="" d
		./// 结果一致的k掉这个临时global 最后验证是否还存在  存在表示结果表有多的结果
		.k ^DHCPERLTTMP(0,"OEORI",ordItmId,RltID)
		
		
		
	}
	i $d(^DHCPERLTTMP(0,"OEORI",ordItmId)) d
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" 存在多余结果"
	.s:(DifDesc="") DifDesc=ArcDesc_" 存在多余结果"
	.s RltID=0
	.f  s RltID=$o(^DHCPERLTTMP(0,"OEORI",ordItmId,RltID)) q:(RltID="")  d
	..s ODID=$p(^DHCPERLTTMP(RltID),"^",3)
	..s OneRlt=$p(^DHCPERLTTMP(RltID),"^",4)
	..s ODDesc=$p(^DHCPEST(+ODID,"OD",$p(ODID,"||",2)),"^",1)
	..s ret=1
	..s DifDesc=DifDesc_","_ODDesc_":"_OneRlt
	..//s:($d(^DHCPERLTTMP(0,"PAADM_OD",admId))) ret=1
	
	
	Q ret_"^"_DifDesc
}

/// d ##class(web.DHCPE.TransResult).CheckALabItemNewByPT("813","1","781||1")
ClassMethod CheckALabItemNewByPT(admId As %String, UserId As %String, ordItmId As %String)
{
	s $zt="CheckALabItemNewByPTerr"
	s episodeNo="", itemStatusDr="", OEIId=""
	i admId="" s admId=$P(^OEORD(+ordItmId),"^",1)
	s LocID=$p($g(^PAADM(admId)),"^",4)
	s DifDesc=""
	/// m结果表这个索引用于 后面验证体检是否存在多余的结果
	k ^DHCPERLTTMP(0,"OEORI",ordItmId)
	m ^DHCPERLTTMP(0,"OEORI",ordItmId)=^DHCPERLT(0,"OEORI",ordItmId)
	s OEIId=ordItmId
	q:(OEIId="") 0
	s itemStatusDr=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",13)
	q:itemStatusDr="4" 0
	q:$d(^DHCPEDataEx("SavePEResult","OEORI",ordItmId)) "0"
	
	s ret=0
	s arcItemId=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),1)),"^",2)
	s episodeNo=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3)),"^",20)
	q:($g(episodeNo)="") 0
	
	q:(##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited") 0 //总检已经审核
	
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcItemId,LocID)
    s STRowId=$p(StatOrderDR,"||",1)      //站点ID
	q:(""=STRowId) "站点为空,请查看站点和项目组合数据维护是否正确！"
	
	//是否是检验医嘱
	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
	i TrakVerison="" s TrakVerison="TrakCare"
	
	//取检验外部代码  OEORI_LabTestSetRow
	s LabItemSetID=$p($g(^OEORD($p(OEIId,"||",1),"I",$p(OEIId,"||",2),3)),"^",35)
	q:LabItemSetID="" 0
	
	//取检验报告信息
	//d ##Class(web.DHCENS.EnsHISService).DHCHisInterface("GetLabInfo","781||1")
	s LisReportInfo=##Class(web.DHCENS.EnsHISService).DHCHisInterface("GetLabInfo",ordItmId)
	b ;LisReportInfo
	//判断检验状态
	s labItemStatus=$P(LisReportInfo,$c(2),73)
	b ;labItemStatus
	q:(labItemStatus'="1") 0 //"Error: the result is not send by labDepartment."	//1:审核  2:取消审核 3:作废
	
	
	//取检验录入日期 2007-07-27
	s AuditDate=$P(LisReportInfo,$c(2),64)
	s AuditDate=$zdh(AuditDate,3)
	s AuditTime=$P(LisReportInfo,$c(2),65)
	s AuditTime=$zth(AuditTime,3)

	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	//Quit:(AuditDate<TranedDate) "Date" //判断是否传输过
	//Quit:((AuditDate=TranedDate)&(AuditTime<TranedTime)) "Time"
	
	//审核人
	s AuditUser=$P(LisReportInfo,$c(2),66)
	s AuditUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AuditUser),0))
	
	//录入人
	s DoctorId=$P(LisReportInfo,$c(2),62)
	s DoctorId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DoctorId),0))
	s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)=AuditUser
	
	//备注
	s Remark=$P(LisReportInfo,$c(2),70)
	i Remark'="" d
	.s ^DHCPERLT("LabSpecNo",episodeNo)=Remark
	e  d
	.k ^DHCPERLT("LabSpecNo",episodeNo)
    b ;AuditDate  AuditTime  AuditUser  DoctorId
	s rs=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID") 
	
	d rs.Execute(ordItmId)
	s ResultSort=0
	s Job=$J
	k ^TempDHCPETransResult(Job,OEIId)
	while(rs.Next())
	{
		s ResultSort=ResultSort+1
		s IsNormal=1
		s ItemID=""
		s Code=rs.Get("ItemCode")
		continue:Code=""
		
		/*
		s stationID=$O(^DHCPEST(0,"OD_Code",Code,0))
		i stationID="" d
		.s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetailNew(Code,rs.Get("ItemDesc"),rs.Get("ItemUnit"),rs.Get("Synonym"))
		e  d
		.s sub=$O(^DHCPEST(0,"OD_Code",Code,stationID,0))
		.s ItemID=stationID_"||"_sub
		.i '$D(^DHCPEDataEx("BaseData","ZhToEn",ItemID)) d
		..s ^DHCPEDataEx("BaseData","ZhToEn",ItemID)=rs.Get("Synonym")
		*/
			s CodeU=$$ALPHAUP^SSUTIL4(Code)
		s StatID=""
		f  s StatID=$O(^DHCPEST(0,"OD_Code",CodeU,StatID))  q:StatID=""  d
		.s ODSub=""
		.f  s ODSub=$O(^DHCPEST(0,"OD_Code",CodeU,StatID,ODSub))  q:ODSub=""  d 
		..s ODID=StatID_"||"_ODSub
		..s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODID,LocID)
	    ..q:LocShowDFlag'="Y"
	    ..s stationID=StatID
	    ..s ItemID=ODID
		
		i ItemID="" d
		.s ItemID=##class(web.DHCPE.CT.StatOrderDetail).ImpOneLabDetailNew(Code,rs.Get("ItemDesc"),rs.Get("ItemUnit"),rs.Get("Synonym"),StatOrderDR,LocID,UserId)
		e  d
		. s ODSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,ItemID,0))
		.i ODSetID'="" d
		..s obj=##class(User.DHCPEOrderDetailSet).%OpenId(ODSetID)
		..s obj.ODSZhToEn=rs.Get("Synonym")
		..s sc=obj.%Save()
		..d obj.%Close()
		
		continue:ItemID=""
		s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
		s CurResult="" /// 结果表没数据的 也是不一致的
		s RltID=$o(^DHCPERLT(0,"PAADM_OD",admId,ItemID,0))
		
		s:(RltID'="") CurResult=$p($g(^DHCPERLT(RltID)),"^",4) /// 结果表结果
		
		s labResult=rs.Get("ItemResult")
		continue:labResult=""
		i CurResult'=labResult d
		.s ret=1
		.s ArcDesc=$p($g(^ARCIM($p(arcItemId,"||",1),1,1)),"^",2)
		.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" "_ODDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_labResult
		.s:(DifDesc="") DifDesc=ArcDesc_" "_ODDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_labResult
		
		i RltID'="" d
		./// 结果一致的k掉这个临时global 最后验证是否还存在  存在表示结果表有多的结果
		.k ^DHCPERLTTMP(0,"OEORI",ordItmId,RltID)
		
		
		
	}
	
	i $d(^DHCPERLTTMP(0,"OEORI",ordItmId)) d
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" 存在多余结果"
	.s:(DifDesc="") DifDesc=ArcDesc_" 存在多余结果"
	.s RltID=0
	.f  s RltID=$o(^DHCPERLTTMP(0,"OEORI",ordItmId,RltID)) q:(RltID="")  d
	..s ODID=$p(^DHCPERLTTMP(RltID),"^",3)
	..s OneRlt=$p(^DHCPERLTTMP(RltID),"^",4)
	..s ODDesc=$p(^DHCPEST(+ODID,"OD",$p(ODID,"||",2)),"^",1)
	..s ret=1
	..s DifDesc=DifDesc_","_ODDesc_":"_OneRlt
	..//s:($d(^DHCPERLTTMP(0,"PAADM_OD",admId))) ret=1
	
	
	Q ret_"^"_DifDesc
CheckALabItemNewByPTerr
	//s ^DHCPEDataEx("TransResultNew",ordItmId)=$H
	q 1 //"回传检验结果出现异常:"_$ZERROR // 异常的也算不一致
}

ClassMethod CheckARisItem(admId As %String, ordItmId As %String, UserId As %String)
{
	Quit:($G(ordItmId)="") 0
	Set itemStatusDr=""
	Set labItemCode=""
	/*&sql(SELECT   oeori_itemstat_dr, OEORI_ItmMast_DR
		 into  :itemStatusDr, :arcItemId
		 FROM  SQLUser.OE_OrdItem
		 where oeori_rowid=:ordItmId and OEORI_OEORD_ParRef->OEORD_Adm_DR=:admId		 
      			and oeori_itemstat_dr<>4 )
	Quit:($g(arcItemId)="") "Error: No correct arcItemId" //已停止
	*/
	s ret=0
	s DifDesc=""
	q:ordItmId="" 0
	s CurResult="" /// 结果表没数据的 也是不一致的
	s CurRltID=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	s:(CurRltID'="") CurResult=$p(^DHCPERLT(CurRltID),"^",4)
	s retr=0
	s itemStatusDr=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",13)
	//q:(itemStatusDr="4")&&(CurResult'="") 1	//已停止 体检有结果 不一致
	q:(itemStatusDr="4")&&(CurResult="") 0	//已停止 体检没结果 一致
	s arcItemId=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
	q:arcItemId="" 0
	q:$d(^DHCPEDataEx("SavePEResult","OEORI",ordItmId)) "0"
	
	///Add by wrz for xdt
	s STRowId=0
	s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId))
	//Q:(""=STRowId)&&(CurResult'="") 1
	Q:(""=STRowId)&&(CurResult="") 0
	s STORDChildSub=0
	s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId, STORDChildSub))
	//Q:(""=STORDChildSub)&&(CurResult'="") 1
	Q:(""=STORDChildSub)&&(CurResult="") 0
	s ReportFormat=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",4)
	q:ReportFormat["EKG" 0
	s admId=$P(^OEORD(+ordItmId),"^",1)
	///Add End
	i ReportFormat="RF_PIS"
	{
		;获取病理结果
		//d ..TransAPISItem(admId,ordItmId,UserId)
		s ret=..CheckAPISItem(admId,ordItmId,UserId)
		q ret
	}
	
	q:(##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(admId)="Audited") 0 //总检已经审核
	Set RARRowId=$o(^DHCPACRegInfoi("OEORI",ordItmId,0))
	Quit:($g(RARRowId)="")&&(CurResult'="") 1
	Quit:($g(RARRowId)="")&&(CurResult="") 0
	Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	//Set DRPTRowId=$o(^DHCRBStudyi("Report","StudyNo",RisStudyNo,0))
	set DRPTRowId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
	b ;RisStudyNo DRPTRowId
	//Quit:($g(DRPTRowId)="")&&(CurResult'="") 1
	Quit:($g(DRPTRowId)="")&&(CurResult="") 0
	Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowId),"^",4)
	//Quit:(RisItemStatus'="5")&&(RisItemStatus'="4")&&(CurResult'="") 1
	Quit:(RisItemStatus'="5")&&(RisItemStatus'="4")&&(CurResult="") 0
	b ;DRPTRowId
	///Add by MLH 2008-05-13  判断最后发布时间
	s AuditDate=$P(^DHCRBStudy("Report",DRPTRowId),"^",12)
	//超声一般不审核，pacs默认审核日期1990-01-01，放射必须审核
	i ((AuditDate="21915")||(AuditDate="")) s AuditDate=$P(^DHCRBStudy("Report",DRPTRowId),"^",9)
	s AuditTime=$P(^DHCRBStudy("Report",DRPTRowId),"^",13)
	i AuditTime=""  s AuditTime=$P(^DHCRBStudy("Report",DRPTRowId),"^",10)
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s TranedTime=$p(IfTraned,",",2)
	
	////////////
	Set ExamDesc=^DHCRBStudy("Report",DRPTRowId,"ExamDescEx")  //3,检查所见
	s ExamDesc=##class(web.DHCPE.Public.Setting).Replace(ExamDesc,"检查所见:","")
	Set ExamResult=^DHCRBStudy("Report",DRPTRowId,"ResultDescEx")  //4,诊断意见
	s ExamResult=##class(web.DHCPE.Public.Setting).Replace(ExamResult,"检查意见:","")
	//Set ExamDesc=$G(^DHCRBStudy("Report",DRPTRowId,"ResultDescEx"))  //3,检查所见
	//Set ExamResult=$G(^DHCRBStudy("Report",DRPTRowId,"ExamDescEx"))  //4,诊断意见
	s OneStr=""
	/*
	i ExamResult["检查所见:" d
	.s OneStr=$P(ExamDesc,"检查意见:",2)
	.s ExamDesc=$P(ExamResult,"检查所见:",2)
	.s ExamResult=OneStr
	*/
	Set ClinicInfo=""
	//s ClinicInfo=$P(^DicomRpt(DRPTRowId),"^",17)  //17,临床诊断
	b ;ClinicInfo
	 //没有Ris数据
	s DCMUserId=$P(^DHCRBStudy("Report",DRPTRowId),"^",11)  ;审核医生
	s ReportUserId=$P($G(^DHCRBStudy("Report",DRPTRowId)),"^",8)  ;报告医生
	s:DCMUserId="" DCMUserId=ReportUserId
	//是否正常的判断
	s result=$P(^DHCRBStudy("Report",DRPTRowId),"^",7)
	i result="N" d
	.s result=1
	e  d
	.s result=0
	
	//i DCMUserId'="" s UserId=$p(^DicomCT(DCMUserId),"^",1)
	s UserId=DCMUserId
	
	q:((ExamDesc="")&(ExamResult="")&(ClinicInfo="")&(CurResult="")) 0
	s ResultStr="临床诊断:"_ClinicInfo
	s ResultStr=ResultStr_";检查所见:"_ExamDesc
	s ResultStr=ResultStr_";诊断意见:"_ExamResult
	i (ResultStr'=CurResult) d
	.s ret=1
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_ResultStr
	.s:(DifDesc="") DifDesc=ArcDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_ResultStr
	q ret_"^"_DifDesc
}

ClassMethod CheckAPISItem(admId As %String, ordItmId As %String, UserId As %String)
{
	s LocID=$P($G(^PAADM(admId)),"^",4)
	//s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace"))
	s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace",LocID))
	s ret=0
	s curZN=$ZNSpace
	s IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",ordItmId))
	s TranedDate=+IfTraned
	s DifDesc=""
	s CurResult="" /// 结果表没数据的 也是不一致的
	s CurRltID=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	s:(CurRltID'="") CurResult=$p(^DHCPERLT(CurRltID),"^",4)
	
	s PisInterfaceFlag=$g(^DHCPESetting("DHCPE","SendPisInterface",LocID))
	//s PisInterfaceFlag=$g(^DHCPESetting("DHCPE","SendPisInterface"))

	if (PisInterfaceFlag="Y") {
		///8.2.0新产品组方法
		///结果内容串:病理号^报告医生代码^报告医生^审核医生代码^审核医生^报告日期^审核日期
         ///^报告时间^审核时间^备注^肉眼所见^检查所见^诊断结果^检查结果^结果异常^PIS报告ID
		S value=##Class(web.DHCAPPPisInterface).GetPisItmRes(ordItmId)
		q:(value="")&&(CurResult="") 0
		//q:(value="")&&(CurResult'="") 1
		 //检查所见
		s JCresult=$p(value,"^",12)
		i (JCresult="")||(JCresult=$c(0)) s JCresult=$p(value,"^",11)
		//诊断意见
		s ZDresult=$p(value,"^",13)
		//医生工号 
		s doc=$p(value,"^",4)
		s UserId=""
		i doc'="" d
		.s doc=$$ALPHAUP^SSUTIL4(doc)
		.s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",doc,""))
	

    	//报告发布日期
		s date=$zdh($p(value,"^",7),3) 
		
	}
	if (PisInterfaceFlag'="Y") {	
	//zn "PIS"
	zn PisNameSpace
	//病理8.0.2新版接口
	//PathID_"^"_RptClass_"^"_RptDiagnosis1_"^"_RptDiagnosis2_"^"_RptDoctor_"^"_RptDate_"^"_RptTime_"^"_RptLoc_"^"_PatName_"^"_sexDesc_"^"_PatBirth_"^"_AppDate_"^"_AppLoc_"^"_SurRoomNO
	//s value=##class(PISApp.PISService).GetRptInfoByTJOeorditemID(ordItmId)
	//病理8.1.1版接口
	//diagnosis_"^"_UserDR_"^"_rptDate
	s value=##class(Src.DPIS3OutInterface).GetPisDiagToTJ(ordItmId)
	zn curZN
	//q:value="" 0 // 如果存在结果 接口不返回数据说明数据也不一致
	//检查所见
	s JCresult=""
	//诊断意见
	s ZDresult=$p(value,"^",1)
	//医生工号 
	s doc=$p(value,"^",2)
	s UserId=""
	i doc'="" s UserId=doc
    //报告发布日期
	s date=$zdh($p(value,"^",3),3)
	}
	
	
	
	
	s JCresult=##class(web.DHCPE.ReportGetInfor).Replace(JCresult,"_$c(13,10)_","  ")
	s JCresult=##class(web.DHCPE.ReportGetInfor).Replace(JCresult,"_$c_","  ")
	s JCresult=##class(web.DHCPE.ReportGetInfor).Replace(JCresult,"\n","  ")
	s ZDresult=##class(web.DHCPE.ReportGetInfor).Replace(ZDresult,"_$c(13,10)_","  ")
	s ZDresult=##class(web.DHCPE.ReportGetInfor).Replace(ZDresult,"_$c_","  ")
	s ZDresult=##class(web.DHCPE.ReportGetInfor).Replace(ZDresult,"\n","  ")
	s ResultStr="临床诊断:"
	s ResultStr=ResultStr_";检查所见:"_JCresult
	s ResultStr=ResultStr_";诊断意见:"_ZDresult
	i (ResultStr'=CurResult) d
	.s ret=1
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_ResultStr
	.s:(DifDesc="") DifDesc=ArcDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_ResultStr
	q ret_"^"_DifDesc
}

ClassMethod CheckARisItemByPT(admId As %String, ordItmId As %String, UserId As %String)
{
	s $zt="CheckARisItemByPTerr"
	Quit:($G(ordItmId)="") "Error: No correct OEORDItem!"
	Set itemStatusDr=""
	Set labItemCode=""
	s DifDesc=""
	q:ordItmId="" 0
	s ret=0
	s CurResult="" /// 结果表没数据的 也是不一致的
	s CurRltID=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	s:(CurRltID'="") CurResult=$p(^DHCPERLT(CurRltID),"^",4)
	
	s itemStatusDr=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",13)
	q:itemStatusDr="4" 0
	s arcItemId=$p($g(^OEORD($p(ordItmId,"||",1),"I",$p(ordItmId,"||",2),1)),"^",2)
	q:arcItemId="" 0
	q:$d(^DHCPEDataEx("SavePEResult","OEORI",ordItmId)) "0"
	
	/*
	s STRowId=0
	s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId))
	Q:(""=STRowId) 0
	s STORDChildSub=0
	s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId, STORDChildSub))
	Q:(""=STORDChildSub) 0
	*/
	/***多院区改造 start***/
	i admId'="" s LocID=$p($g(^PAADM(admId)),"^",4)
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcItemId,LocID)
    s STRowId=$p(StatOrderDR,"||",1)      //站点ID
	/***多院区改造 end***/
	q:(""=STRowId) "未找到体检站点信息，请查看站点和项目组合数据维护是否正确"
	s STORDChildSub=0
	s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, STRowId, STORDChildSub))
	Q:(""=STORDChildSub) "未找到体检站点和项目组合信息，请查看站点和项目组合数据维护是否正确"
	
	s admId=$P(^OEORD(+ordItmId),"^",1)
	
	q:(##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(admId)="Audited") 0 //总检已经审核
	
	s rs=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID") 
	d rs.Execute(ordItmId)
	s ResultSort=0
  	s ResultStr=""
	while(rs.Next())
	{
		s ResultSort=ResultSort+1
	
		//检查所见
		S ExamDesc=rs.Get("ExamDesc")  
		;b ;ExamDesc
		;s ExamDesc=##class(web.DHCPE.Public.Setting).Replace(ExamDesc,"检查所见:","")
		
		//诊断意见
		S ExamResult=rs.Get("strResult")  
		;b ;ExamResult
		;s ExamResult=##class(web.DHCPE.Public.Setting).Replace(ExamResult,"检查意见:","")
	
		s OneStr=""
		S ClinicInfo=""
		s:((ExamDesc="")&(ExamResult="")&(ClinicInfo="")&(CurResult'="")) ret=1
		//q:ret=1 
		continue:((ExamDesc="")&(ExamResult="")&(ClinicInfo="")) 
	
		//审核医生
		s DCMUserId=""
		s DCMUserCode=rs.Get("RISRCheckDocCode") //审核医生Code
		i DCMUserCode'="" s DCMUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DCMUserCode),0))
		;b ;DCMUserCode  DCMUserId
		
		//审核日期
		S AuditDate=rs.Get("RISRCheckDate")
		i AuditDate'="" s AuditDate=$zdh(AuditDate,3)

		//审核时间
		S AuditTime=rs.Get("RISRCheckTime")
	    i AuditTime'="" s AuditTime=$zth(AuditTime,3)
	    
	    //报告日期
	    S ReportDate=rs.Get("RISRReportDate")
		i ReportDate'="" s ReportDate=$zdh(ReportDate,3)
	    
	    //报告时间
	    S ReportTime=rs.Get("RISRReportTime")
		i ReportTime'="" s ReportTime=$zth(ReportTime,3)
		;b ;ReportDate ReportTime
		
		i AuditDate="" s AuditDate=ReportDate
		i AuditTime="" s AuditTime=ReportTime
		
		//报告医生
		s ReportUserId=""
		s ReportUserCode=rs.Get("RISRReportDocCode") //报告医生Code
		i ReportUserCode'="" s ReportUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ReportUserCode),0))  
	    ;b ;ReportUserCode ReportUserId
		s:DCMUserId="" DCMUserId=ReportUserId
	
		//是否正常的判断
		//s result=rs.Get("RISRWarnCode") //平台危机值
		//s result=rs.Get("RISRAbnormalFlags") //RISRAbnormalFlags:异常标记（一般用于检验）
		s result=rs.Get("RISRIsPositive")    //RISRIsPositive:是否阳性
		i result="N" d
		.s result=1
		e  d
		.s result=0
	
		s UserId=DCMUserId
	
		s ResultStr="临床诊断:"_ClinicInfo
		s ResultStr=ResultStr_";检查所见:"_ExamDesc
		s ResultStr=ResultStr_";诊断意见:"_ExamResult
	}
	i (ResultStr'=CurResult) d
	.s ret=1
	.s ArcDesc=$p(^ARCIM($p(arcItemId,"||",1),1,1),"^",2)
	.s:(DifDesc'="") DifDesc=DifDesc_";"_ArcDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_ResultStr
	.s:(DifDesc="") DifDesc=ArcDesc_" 存在不同结果,体检系统结果："_CurResult_",检验系统结果"_ResultStr
	Q ret_"^"_DifDesc
CheckARisItemByPTerr
	q 1
}

/// Description: 集成平台根据医嘱ID，调用体检方法,自动回传结果
/// Input:       ordItmId(医嘱ID)
/// Debug: d ##class(web.DHCPE.TransResult).TransResultByOEID()
ClassMethod TransResultByOEID(ordItmId)
{
	s $ZT="TransOneItemErr"
	q:'$D(^DHCPECRMO(0,"OEORI",ordItmId)) 0 
	s admId=$P($g(^OEORD(+ordItmId)),"^",1)
	s CurLoc=$P($g(^PAADM(admId)),"^",4)
	s AdmType=$P($g(^PAADM(admId)),"^",2)
	q:AdmType'="H" "NoHP"
	/// 推送消息给总检医生
	
	i (##class(web.DHCPE.ResultPermission).GetReportStatus(admId)="Audited"){
		s peIAdmId=$o(^DHCPEIADM(0,"PAADM",admId,"0"))
		q:peIAdmId="" ""
		s generalAdvisorId=$o(^DHCPEGS(0,"IADM",peIAdmId,0))
		q:generalAdvisorId="" ""
		s auditUserId=$p($g(^DHCPEGS(generalAdvisorId,1)),"^",5)
		s HPNo=##class(web.DHCPE.PreCommon).GetPEID(admId,"PAADM")
    	s obj=##class(User.OEOrdItem).%OpenId(ordItmId)
    	s ItemName=obj.OEORIItmMastDR.ARCIMDesc
    	s Context="体检号为'<font color=red>"_HPNo_"</font>'的体检客户，'<font color=red>"_ItemName_"</font>'报告重新审核,请取消总检重新审核!"
	
		
		/// 第二个参数 为信息的动作类型代码  websys.DHCMessageActionType表的code字段值  根据项目修改
		d ##class(websys.DHCMessageInterface).Send(Context, "1294", "", admId , ordItmId ,auditUserId,"","","",CurLoc)
	
	}
	s userId=""
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CurLoc))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CurLoc))
	s RisStation="^"_RisStation_"^"
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",CurLoc))
	s TransResultFlag=##class(web.DHCPE.HISUICommon).GetSettingByLoc(CurLoc,"TransResult")
	s ItemMastId=$p($g(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),1)),"^",2)
	//s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,CurLoc)
	s StationId=$p(StatOrderDR,"||",1)
	q:StationId="" "NoST"
	s LabSpec=$p($g(^OEORD(+ordItmId,"I",$P(ordItmId,"||",2),3)),"^",20)
	i (LabSpec'="")&&(LisNewVersion'="Y") d  ;标本号不是空就回传
	.s ret=##class(web.DHCPE.TransResult).TransALabItem(admId, userId,ordItmId)
	e  i (LabSpec'="")&&(LisNewVersion="Y")&&(TransResultFlag="PG") d
	.s ret=##class(web.DHCPE.TransResult).TransALabItemNew(admId,userId,ordItmId)
	e  i (LabSpec'="")&&(LisNewVersion="Y")&&(TransResultFlag="PT") d
	.s ret=##class(web.DHCPE.TransResult).TransALabItemNewByPT(admId,userId,ordItmId)
	e  i (RisStation[("^"_StationId_"^")) d
	.i (TransResultFlag="PT") d
	..s ret=##class(web.DHCPE.TransResult).TransARisItemByPT(admId,ordItmId,userId)
	.i (TransResultFlag="PG") d
	..s ret=##class(web.DHCPE.TransResult).TransARisItem(admId,ordItmId,userId)
	q 0
TransOneItemErr
	s $ZT=""
	q 0_"Err"
}

/// Description:  集成平台根据医嘱ID,调用体检方法,自动删除体检结果表相关数据
/// Input:        ordItmId(医嘱ID)
/// Debug: d ##class(web.DHCPE.TransResult).DeleteResultByOEID()
ClassMethod DeleteResultByOEID(ordItmId)
{
	s $ZT="DeleteResultByOEIDErr"
	s RLTRowId=0
	f  s RLTRowId=$O(^DHCPERLT(0,"OEORI",ordItmId,RLTRowId)) q:RLTRowId=""  d
	.s RLTODDR=$p($g(^DHCPERLT(RLTRowId)),"^",3)
	.&sql(delete from SQLUser.dhc_pe_result where rlt_rowid=:RLTRowId)
	q 0
DeleteResultByOEIDErr
	s $ZT=""
	q 0_"^Err^"_$ZERROR
}

/// Creator：    sunxintao
/// CreatDate：  20220612
/// Description: 获取医嘱的结果
/// Input:       OEID 医嘱ID
/// Debug： d ##class(%ResultSet).RunQuery("web.DHCPE.TransResult","GetOEItemResult","979||1")
Query GetOEItemResult(OEID As %Library.String = "") As %Query(ROWSPEC = "ItemName,Result,Unit,NormalRange,CheckDoc,ReportDoc,AuditDoc:%String")
{
}

ClassMethod GetOEItemResultExecute(ByRef qHandle As %Binary, OEID As %Library.String = "") As %Status
{
 	s ind=1
   	
   	Set repid=$I(^CacheTemp)
 	if (OEID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s RLT=0
	f  s RLT=$O(^DHCPERLT(0,"OEORI",OEID,RLT)) q:RLT=""  d
	.s ItemID=$P($g(^DHCPERLT(RLT)),"^",3)
	.s ODDesc=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",1)
	.s Result=$P($g(^DHCPERLT(RLT)),"^",4)
	.s User=$P($g(^DHCPERLT(RLT)),"^",16)
	.s:(User="") User=$P($g(^DHCPERLT(RLT)),"^",5)
	.s UserName="",ReportDoc="",AuditDoc=""
	.s:User'="" UserName=$P($G(^SSU("SSUSR",User)),"^",2)
	.// 报告医生
	.s RUser=$P($g(^DHCPERLT(RLT)),"^",17)
	.s:RUser'="" ReportDoc=$P($G(^SSU("SSUSR",RUser)),"^",2)
	.
	.// 审核医生
	.s AUser=$P($g(^DHCPERLT(RLT)),"^",18)
	.s:AUser'="" AuditDoc=$P($G(^SSU("SSUSR",AUser)),"^",2)
	.s ODUnit=$G(^DHCPEDataEx("DHCPEResult",RLT,"Unit"))
	.s Standard=$G(^DHCPEDataEx("DHCPEResult",RLT,"Ranges"))
	.d GetOneInfo

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetOneInfo
	s Data=$lb(ODDesc,Result,ODUnit,Standard,User_" "_UserName,RUser_" "_ReportDoc,AUser_" "_AuditDoc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod GetOEItemResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOEItemResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOEItemResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOEItemResultExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// / 提醒总检大夫需要重新总检
/// w ##Class(web.DHCPE.TransResult).NoticeAuditDoc()
ClassMethod NoticeAuditDoc(admId, ordItmId)
{
	s CurLoc=$P($g(^PAADM(admId)),"^",4)
	s peIAdmId=$o(^DHCPEIADM(0,"PAADM",admId,"0"))
	q:peIAdmId="" ""
	s generalAdvisorId=$o(^DHCPEGS(0,"IADM",peIAdmId,0))
	q:generalAdvisorId="" ""
	s auditUserId=$p($g(^DHCPEGS(generalAdvisorId,1)),"^",5)
	s HPNo=##class(web.DHCPE.PreCommon).GetPEID(admId,"PAADM")
	s obj=##class(User.OEOrdItem).%OpenId(ordItmId)
	s ItemName=obj.OEORIItmMastDR.ARCIMDesc
	s Context="体检号为'<font color=red>"_HPNo_"</font>'的体检客户，'<font color=red>"_ItemName_"</font>'报告重新审核,请取消总检重新审核!"

	
	/// 第二个参数 为信息的动作类型代码  websys.DHCMessageActionType表的code字段值  根据项目修改
	d ##class(websys.DHCMessageInterface).Send(Context, "1294", "", admId , ordItmId ,auditUserId,"","","",CurLoc)
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

}
