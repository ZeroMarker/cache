/// 体检发证管理
Class web.DHCPE.CardManager Extends %RegisteredObject
{

ClassMethod Save(PAADM, Conclusion, Suggestions)
{
	s ret=##class(web.DHCPE.ResultDiagnosis).UpdateStationS(PAADM,0,"")
	s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	q:SSID="" "没有总检记录"
	
	s ret=##class(web.DHCPE.ResultDiagnosis).AuditStationS(PAADM,"Submit",0,"N")
	q:ret'=0 "总检审核失败"
		
	//s Str=Conclusion_"^"_""_"^"_Suggestions_"^"_""_"^"_""_"^"_""
    s Str=""_"^"_""_"^"_Suggestions_"^"_""_"^"_""_"^"_""_"^"_Conclusion
	s ret=##class(web.DHCPE.GeneralSummarizeEx).Save(SSID,Str)
	i ret>0 q 0
	q ret
}

ClassMethod GetGSEx(PAADM)
{
	s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	q:SSID="" ""
	s GSEXID=$O(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",SSID,0))
	q:GSEXID="" ""
	s obj=##class(User.DHCPEGeneralSummarizeEx).%OpenId(GSEXID)
	//s GSEConclusionID=obj.GSEConclusionID.%Id()
	//q GSEConclusionID_"^"_Suggestions
	s GSEConclusion=obj.GSEConclusionDesc
    s Suggestions=obj.GSESuggestions
	q GSEConclusion_"^"_Suggestions
}

/// w ##class(web.DHCPE.CardManager).UpdateResult("1251383",2502)
ClassMethod UpdateResult(PAADM, DocID)
{
	s OEOrdID=$O(^OEORD(0,"Adm",PAADM,0))
	q:OEOrdID="" "NoOrd"
	s CheckDate=+$H
	s ItemSub=0
	f  s ItemSub=$O(^OEORD(OEOrdID,"I",ItemSub)) q:ItemSub=""  d
	.s Stat=$P(^OEORD(OEOrdID,"I",ItemSub,1),"^",13)
	.q:Stat="4"
	.s ArcItemID=$P(^OEORD(OEOrdID,"I",ItemSub,1),"^",2)
	.s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ArcItemID,0))
	.q:StationID=""
	.;s Flag=$G(^DHCPECFDataEx("ChartAssign",DocID,LocID,GroupID,"Write",StationID))
	.;q:Flag'="Y"
	.s OEID=OEOrdID_"||"_ItemSub
	.b ;OEID
	.q:$D(^DHCPERLT(0,"OEORI",OEID))
	.s ResultStr=##class(web.DHCPE.DoctorBatchRecord).GetDefaultResult(OEID)
	.q:ResultStr=""
	.s Ret=##class(web.DHCPE.ResultNew).SaveResult(ResultStr,DocID,"",CheckDate)
	q "Over"
}

ClassMethod UpdateOneResult(ResultID, Result, Normal)
{
	&SQL(Update Sqluser.DHC_PE_Result set RLT_Result=:Result,RLT_Normal=:Normal where RLT_RowID=:ResultID)
}

ClassMethod GetODTemplate(ResultID, IsNormal)
{
	s ODID=$P(^DHCPERLT(ResultID),"^",3)
	q:ODID="" ""
	s ret=""
	s StandSub=0
	f  s StandSub=$O(^DHCPEST(+ODID,"OD",$P(ODID,"||",2),"ODS",StandSub)) q:StandSub=""  d
	.s NormalFlag=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2),"ODS",StandSub),"^","6")
	.q:(NormalFlag="Y")&&(IsNormal="0")
	.q:(NormalFlag="N")&&(IsNormal="1")
	.s ret=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2),"ODS",StandSub),"^","2")
	q ret
}

// w ##class(web.DHCPE.CardManager).GetResultInfo(1256108)

ClassMethod GetResultInfo(PAADM)
{
	
	s ret=""
	s OEID=""
	f  s OEID=$O(^DHCPERLT(0,"ADMOD",PAADM,OEID),-1) q:OEID=""  d
	.s ArcimID=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",2)
	.;q:ArcimID'="2185||1"
	.S ODID=0
	.f  s ODID=$O(^DHCPERLT(0,"ADMOD",PAADM,OEID,ODID)) q:ODID=""  d
	..s ODDesc=$p($g(^DHCPEST($p(ODID,"||",1),"OD",$p(ODID,"||",2))),"^",1)
	..q:ODDesc'["谷丙转氨酶"
	..s ResultID=$O(^DHCPERLT(0,"ADMOD",PAADM,OEID,ODID,0))
	..s Result=$P(^DHCPERLT(ResultID),"^",4)
	..s Range=$G(^DHCPEDataEx("DHCPEResult",ResultID,"Ranges"))
	..s ODUnit=$G(^DHCPEDataEx("DHCPEResult",ResultID,"Unit"))
	..s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrowNew(ResultID)
	..s TSInfo=""
	..s:Arrow=2 TSInfo="偏高"
	..s:Arrow=0 TSInfo="偏低"
	..s ret=TSInfo_"^"_Result_"^"_ODUnit_"^"_Range
	q ret
}

ClassMethod GetBaseInfo(PAADM, HOSPID As %String = "")
{
	s AdmId=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
	q ##class(web.DHCPE.PrintNewDirect).GetPatBaseInfo(AdmId,"0","N",HOSPID)
}

// w ##class(web.DHCPE.CardManager).GetReportInfo(1199860)

ClassMethod GetReportInfo(PAADM)
{
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	q:SSID="" "-1^没有总检信息"
	s AuditUser=$p(^DHCPEGS(SSID,1),"^",5)
	q:AuditUser="" "-1^总检没有审核,不能打印"
	b ;AuditUser
	s GSEXID=$O(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",SSID,0))
	q:GSEXID="" "-1^健康证保存数据失败,不能打印,重新保存"
	s Flag=0  //判断是否可以打印，0不能打印
	i GSEXID'="" d
	.;s Conclusion=$LG(^User.DHCPEGeneralSummarizeExD(GSEXID),3)
	.;q:Conclusion=""
	.;s Level=$LG(^User.DHCPEConclusionD(Conclusion),7)
	.;s:Level=0 Flag=1
	.s Conclusion=$LG(^User.DHCPEGeneralSummarizeExD(GSEXID),13)
	.s:Conclusion="合格" Flag=1
	q:Flag=0 "-2^健康情况不合格，不能打印"
	i $D(^DHCPEDataEx("CardNo",PAADM)) d
	.s CardNo=$G(^DHCPEDataEx("CardNo",PAADM))
	e  d
	.s VIPLevel=+##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
	.s Year=+$ZD(+$H,"3")
	.s CardNo=$I(^DHCPEDataEx("CardNo","SortNum",Year))
	.s CardNo=$E("000000",0,6-$L(CardNo))_CardNo
	.s ^DHCPEDataEx("CardNo",PAADM)=CardNo
	.s ^DHCPEDataEx("CardNoIndex",CardNo)=PAADM
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s PatID=obj.PAADMPAPMIDRGetObjectId()
	//s PhotoFTP=$G(^DHCPESetting("DHCPE","PhotoFTP"))
	s PhotoFTP=$G(^DHCPESetting("DHCPE","PhotoFTP",LocID))
	s IP=$P(PhotoFTP,"^",1)
	s User=$P(PhotoFTP,"^",2)
	s PassWord=$P(PhotoFTP,"^",3)
	s Port=$P(PhotoFTP,"^",4)
	s Dir=$P(PhotoFTP,"^",5)
	s File=Dir_"/"_PatID_".jpg"
	;s Flag=##class(web.DHCPE.FTPManager).FTPFileExit(IP,User,PassWord,Port,File)
	;q:Flag="0" "-1^没有照片不能打印"
	s Name=obj.PAADMPAPMIDR.PAPMIName
	s Sex=obj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s Dob=obj.PAADMPAPMIDR.PAPMIDOB
	s:Dob'="" Dob=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
	s RegNo=obj.PAADMPAPMIDR.PAPMINo
	q PatID_"^"_Name_"^"_Sex_"^"_Dob_"^"_RegNo_"^"_CardNo
}

ClassMethod GetReportInfoXML(PAADM)
{
	s c=$c(2)
	s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	q:SSID="" "-1^没有总检信息"
	s AuditUser=$p(^DHCPEGS(SSID,1),"^",5)
	q:AuditUser="" "-1^总检没有审核,不能打印"
	s GSEXID=$O(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",SSID,0))
	q:GSEXID="" "-1^健康证保存数据失败,不能打印,重新保存"
	s Flag=0 //判断是否可以打印，0不能打印
	i GSEXID'="" d
	.;s Conclusion=$LG(^User.DHCPEGeneralSummarizeExD(GSEXID),3)
	.;q:Conclusion=""
	.;s Level=$LG(^User.DHCPEConclusionD(Conclusion),7)
	.;s:Level=0 Flag=1
	.s Conclusion=$LG(^User.DHCPEGeneralSummarizeExD(GSEXID),13)
	.s:Conclusion="合格" Flag=1
	q:Flag=0 "-2^健康情况不合格，不能打印"
	i $D(^DHCPEDataEx("CardNo",PAADM)) d
	.s CardNo=$G(^DHCPEDataEx("CardNo",PAADM))
	e  d
	.s VIPLevel=+##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
	.s Year=+$ZD(+$H,"3")
	.s CardNo=$I(^DHCPEDataEx("CardNo","SortNum",Year))
	.s CardNo=$E("000000",0,6-$L(CardNo))_CardNo
	.s ^DHCPEDataEx("CardNo",PAADM)=CardNo
	.s ^DHCPEDataEx("CardNoIndex",CardNo)=PAADM
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s PatID=obj.PAADMPAPMIDRGetObjectId()
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	s Date=$p($g(^DHCPEIADM(IADM)),"^",5)
	i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)

	s Name=obj.PAADMPAPMIDR.PAPMIName
	s Sex=obj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatID,PAADM)
	s RegNo=obj.PAADMPAPMIDR.PAPMINo
	s HOSPID=%session.Get("LOGON.HOSPID")
    s HospitalName=##class(web.DHCPE.DHCPECommon).GetHospitalName(HOSPID)
	s image=""
	s image=##Class(web.DHCPE.PreIBIUpdate).GetPhoto(RegNo,"RegNo")
	 s PhotoPath=""
	 if (image'="") s PhotoPath="data:image/png;Base64,"+image   //拍照照片
	 //if (image'="") s PhotoPath="data:image/jpg;Base64,"+image //身份证照片

	q "PatID"_c_PatID_"^"_"Name"_c_Name_"^"_"Sex"_c_Sex_"^"_"Age"_c_Age_"^"_"RegNo"_c_RegNo_"^"_"CardNo"_c_CardNo_"^"_"HospitalName"_c_HospitalName_"^"_"Photo"_c_PhotoPath_"^"_"Date"_c_Date
}

/// 通过证件号码，获取就诊ID
ClassMethod GetPAADMByZJNo(ZJNo)
{
	q:ZJNo="" ""
	s PAADM=$G(^DHCPEDataEx("CardNoIndex",ZJNo))
	q:PAADM="" ""
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s RegNo=obj.PAADMPAPMIDR.PAPMINo
	q RegNo_"^"_PAADM
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CardManager","FindCardManager","")
Query FindCardManager(EpisodeID As %String, UserID As %String) As websys.Query(ROWSPEC = "Name,EngName,Result,Range,TSInfo,Unit:%String")
{
}

ClassMethod FindCardManagerExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    i (EpisodeID=""){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
    i EpisodeID'="" s ADMLocID=$p($g(^PAADM(EpisodeID)),"^",4) //就诊科室ID
    
    d ##Class(web.DHCPE.ReportGetInfor).GetReportResult(EpisodeID,UserID)
 	s sStationSequence=""
	f  s sStationSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence)) q:sStationSequence=""  d
	.s StationId=""
	.f  s StationId=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId)) Q:(""=StationId)  d
	..s sARCSequence=""
	..f  s sARCSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence)) Q:(""=sARCSequence)  d
	...s iiiLLoop=0
	...f  s iiiLLoop=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop)) Q:(""=iiiLLoop)  d
	....s ARCIM=$G(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop))
	....s sArcimIdTemp=$p($G(^OEORD(+ARCIM,"I",$p(ARCIM,"||",2),1)),"^",2)
	....;s bFlagTemp=$G(^DHCPECTDataEx("DHCPEStationOrder","Sign",sArcimIdTemp))
	....s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(sArcimIdTemp,ADMLocID)
	....q:StatOrderDR=""
	....s bFlagTemp=""
	....S StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_ADMLocID,StatOrderDR,""))
	....i StatOrdSetID'="" s bFlagTemp=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),20)  //特殊检查
	....
	....q:ARCIM=""
	....s CurData=$G(^TMPReport(UserID,"Result", "ARCIM", ARCIM))
	....s ARCIMDesc=$P(CurData,"^",1)
	....s Checker=$P(CurData,"^",2)
	....s CheckDate=$P(CurData,"^",3)
	....s ReportFormat=$P(CurData,"^",4)
	....s AuditUser=$P(CurData,"^",5)
	....q:'$D(^TMPReport(UserID,"Result", "Content",ARCIM))
	....s (Name,EngName,Result,Range,TSInfo,Unit)=""
	....s Name=ARCIMDesc
	....d OutputRow
	....i (ReportFormat["LIS")||((ReportFormat["CAT")) d
	.....s ODID=0
	.....f  s ODID=$O(^TMPReport(UserID,"Result", "Content",ARCIM,ODID)) q:ODID=""  d
	......s CurData=$g(^TMPReport(UserID,"Result", "Content",ARCIM,ODID))
	......s Name=$P(CurData,"^",1)  //细项名称
	......s EngName=$P(CurData,"^",8)  //英文名称
	......s Normal=$P(CurData,"^",3)
	......s Result=$P(CurData,"^",2)
	......s ResultID=$P(CurData,"^",9)
	......i Normal="0" d
	.......s Result="<font color=#FF0000 size=3>"_Result_"</font>" 
	......e  d
	.......s Result=Result
	......s Range=$P(CurData,"^",5)  //参考范围
	......s TSInfo="&nbsp;"
	......i $P(CurData,"^",6)="2" d
	.......s TSInfo="↑"
	.......s TSInfo="<font color=#FF0000 size=3>"_TSInfo_"</font>"
	......i $P(CurData,"^",6)="0" d
	.......s TSInfo="↓"
	.......s TSInfo="<font color=#FF0000 size=3>"_TSInfo_"</font>"
	......s TSInfo=TSInfo //提示
	......s Unit=$P(CurData,"^",4)  //单位
	......d OutputRow
	....e  d
    .....s ODID=0
	.....f  s ODID=$O(^TMPReport(UserID,"Result", "Content",ARCIM,ODID)) q:ODID=""  d
	......s CurData=$g(^TMPReport(UserID,"Result", "Content",ARCIM,ODID))
	......s Name=$P(CurData,"^",1)  //细项名称
	......s Normal=$P(CurData,"^",3)
	......s Result=$P(CurData,"^",2)
	......s ResultID=$P(CurData,"^",6)
	......s Range=$P(CurData,"^",7)  //参考范围
	......s Unit=$P(CurData,"^",4)  //单位
	......i Normal="异常" d
	.......s Result="<font color=#FF0000 size=3>"_Result_"</font>" 
	......e  d
	.......s Result=Result
	......s ODDR=$P($g(^DHCPERLT(ResultID)),"^",3)
	......;s EngName=$g(^DHCPECTDataEx("BaseData","ZhToEn",ODDR))  //英文名称
	......s EngName=""
	......s ODSID=$O(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_ADMLocID,ODDR,""))
	......i ODSID'="" s EngName=$lg($g(^CF.PE.OrderDetailSetD(ODSID)),9)   //英文名称
	......s Type=$P($G(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2))),"^",2)
	......s:(Type="N")||(Type="C") TSInfo=##class(web.DHCPE.TransResult).GetLabResultArrowNew(ResultID)
	......s:(TSInfo="1") TSInfo=""
	......s:TSInfo="2" TSInfo="<font color=#FF0000 size=3>↑</font>"
	......s:TSInfo="0" TSInfo="<font color=#FF0000 size=3>↓</font>"
	......s TSInfo=TSInfo //提示
	......d OutputRow  
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(Name,EngName,Result,Range,TSInfo,Unit)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CardManager","OutConclusion",1)
Query OutConclusion(VIPLevel) As websys.Query(ROWSPEC = "id:%String,Desc:%String")
{
}

ClassMethod OutConclusionExecute(ByRef qHandle As %Binary, VIPLevel) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
	f  s id=$O(^User.DHCPEConclusionI("VIPLevelIndex",VIPLevel,id)) q:id=""  d
	.s Active=$LG(^User.DHCPEConclusionD(id),4)
	.q:Active'="Y"
	.s Desc=$LG(^User.DHCPEConclusionD(id),3)
	.s ^CacheTemp(repid,ind)=$lb(id,Desc)
	.s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetHadAudit(EpisodeID)
{
	s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(EpisodeID)
	s HadAudit="N"
 	i GSID'="" d
 	.s AuditUser=$p(^DHCPEGS(GSID,1),"^",5)
 	.s:AuditUser'="" HadAudit="Y"
 	q HadAudit
}

}
