Class DHCDoc.Interface.Inside.IOT.DrugInfo Extends %RegisteredObject
{

/// creator:tanjishan
/// date:2019-09-10
/// desc:互联互通共享文档【2.4	西药处方相关表（C0004）】
/// input：	SttDate&EndDate[YYYY-MM-DD]  门急诊患者检索的是就诊时间范围，住院患者检索的是出院时间范围；
/// 		HOSPCode院区代码，为空时返回所有数据；
Query QueryDrugPreInfo(SttDate As %String, EndDate As %String, HOSPCode As %String) As %Query(ROWSPEC = "AdmID:%String:就诊ID号,DocumentID:%String:文档唯一编号,HDSD0004002:%String:处方编号,HDSD0004006:%String:处方开立日期,HDSD0004005:%String:处方开立科室名称,HDSD0004007:%String:处方开立医师代码,HDSD00040071:%String:处方开立医师签名,HDSD0004009:%String:处方审核药剂师代码,HDSD00040091:%String:处方审核药剂师签名,HDSD0004010:%String:处方调配药剂师代码,HDSD00040101:%String:处方调配药剂师签名,HDSD0004004:%String:处方核对药剂师代码,HDSD00040041:%String:处方核对药剂师签名,HDSD0004003:%String:处方发药药剂师代码,HDSD00040031:%String:处方发药药剂师签名,HDSD0004011:%String:处方费用金额,HDSD0004013:%String:处方有效天数,HDSD0004001:%String:处方备注信息,HDSD00040051:%String:处方开立科室代码") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.DrugInfo","QueryDrugPreInfo","2019-01-01","2019-09-10","DHSZHYYZY")
ClassMethod QueryDrugPreInfoExecute(ByRef qHandle As %Binary, SttDate As %String, EndDate As %String, HOSPCode As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 1
	set qHandle = $lb(0,repid,0)
	s SttDate=$ZDH(SttDate,3)
	s EndDate=$ZDH(EndDate,3)
	if $D(^oddCOM("web.DHCDocOrderCommon","m","GetCNMedItemCatStr")){
		s CNMedItemCatStr=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	}else{
		s CNMedItemCatStr=$G(^DHCDocConfig("CNMedItemCat"))_"^"_$G(^DHCDocConfig("CNMedKLItemCat"))
	}
	///门急诊的按照就诊时间输出
	s mTypeStr="O^E"
	for mi=1:1:$L(mTypeStr,"^"){
		s mPAADMType=$P(mTypeStr,"^",mi)
		for mPAADMAdmDate=SttDate:1:EndDate{
			s mPAADMAdmTime=""
			for {
				s mPAADMAdmTime=$O(^PAADMi("TypeDate",mPAADMType,mPAADMAdmDate,mPAADMAdmTime))
				q:(mPAADMAdmTime="")
				s mEpisodeID=""
				for {
					s mEpisodeID=$O(^PAADMi("TypeDate",mPAADMType,mPAADMAdmDate,mPAADMAdmTime,mEpisodeID))
					q:(mEpisodeID="")
					s mAdmLocDr=$P($G(^PAADM(mEpisodeID)),"^",4)
					continue:mAdmLocDr=""
					s mHospDr=$P($G(^CTLOC(mAdmLocDr)),"^",22)
					s mHospCode=""
					if (mHospDr'=""){
						s mHospCode=$P($G(^CT("HOSP",mHospDr)),"^",1)
					}
					continue:(HOSPCode'="")&&(HOSPCode'=mHospCode)
					
					d GetAdmDrugPreInfoData(mEpisodeID)
				}
			}
		}
			
	}
	
	///住院的按照出院时间输出--如果要上传住院的数据，应该用出院时间检索
	
	for mPAADMDischargeDate=SttDate:1:EndDate{
		s mEpisodeID=""
		for {
			s mEpisodeID=$O(^PAADMi("DischargeDateExt",mPAADMDischargeDate,mEpisodeID))
			q:(mEpisodeID="")
			s mAdmLocDr=$P($G(^PAADM(mEpisodeID)),"^",4)
			continue:mAdmLocDr=""
			s mHospDr=$P($G(^CTLOC(mAdmLocDr)),"^",22)
			s mHospCode=""
			if (mHospDr'=""){
				s mHospCode=$P($G(^CT("HOSP",mHospDr)),"^",1)
			}
			
			continue:(HOSPCode'="")&&(HOSPCode'=mHospCode)
			d GetAdmDrugPreInfoData(mEpisodeID)
		}
	}
	
	q $$$OK
	
GetAdmDrugPreInfoData(EpisodeID)
	s OrderID=$o(^OEORD(0,"Adm",+EpisodeID,""))
	q:(OrderID="")
	s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	Kill PrescNoList
	s SubID=0
	for {
		s SubID=$O(^OEORD(OrderID,"I",SubID))
		q:(SubID="")
		s statcode=""
		s itemstat=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
		i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		continue:("UHDIC")[statcode
		s ArcimRowId=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",2)
		continue:ArcimRowId=""
		s ItemCatRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
		continue:ItemCatRowid=""
		s OrderType=""
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:OrderType'="R"
		continue:("^"_CNMedItemCatStr_"^")[("^"_ItemCatRowid_"^")
		
		s PrescNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",14)
		continue:PrescNo=""
		continue:$D(PrescNoList(PrescNo))
		d GetDrugPreInfoData(EpisodeID,PrescNo)
		s PrescNoList(PrescNo)=""
		
	}
	q
GetDrugPreInfoData(EpisodeID,PrescNo)
	d ReSetDrugPreInfo
	//就诊ID号
	s AdmID=EpisodeID
	//文档唯一编号
	s DocumentID=OrderID_"||"_SubID
	//处方编号
	s HDSD0004002=PrescNo
	s SttDat=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)
	//处方开立日期
	s HDSD0004006=$ZD(SttDat,3)
	s UserDepartId=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",2)
	if (UserDepartId'=""){
		//处方开立科室名称
		Set HDSD0004005=$P($G(^CTLOC(UserDepartId)),"^",2)
		//处方开立科室代码
		s HDSD00040051=$P($G(^CTLOC(UserDepartId)),"^",1)
	}
	s UserAdd=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",1)
	if (UserAdd'=""){
		//处方开立医师代码
		Set HDSD0004007=$P($G(^SSU("SSUSR",UserAdd)),"^",1)
		//处方开立医师签名
		s HDSD00040071=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	}
	
	S monitorID=$O(^DHCPHORDM(0,"PrescNo",PrescNo,""),-1)
	if (monitorID'=""){
		S monitorUserDr=$p(^DHCPHORDM(monitorID),"^",2)
		if (monitorUserDr'=""){
			//处方审核药剂师代码
			Set HDSD0004009=$P($G(^SSU("SSUSR",monitorUserDr)),"^",1)
			//处方审核药剂师签名
			s HDSD00040091=$P($G(^SSU("SSUSR",monitorUserDr)),"^",2)
		}
	}
	if (PAADMType="I"){
		s PhaId=$O(^DHCPHAC(0,"Prescno",PrescNo,""))
		if (PhaId'=""){
			s DHCPHAOperatorDr=$P(^DHCPHAC(PhaId),"^",4)	///配药人
			if (DHCPHAOperatorDr'=""){
				//处方调配药剂师代码
				s HDSD0004010=$P($G(^SSU("SSUSR",DHCPHAOperatorDr)),"^",1)
				//处方调配药剂师签名
				s HDSD00040101=$P($G(^SSU("SSUSR",DHCPHAOperatorDr)),"^",2)
			}
			s DHCPHAAuditorDr=$P(^DHCPHAC(PhaId),"^",24)	///配药人
			if (DHCPHAAuditorDr'=""){
				//处方核对药剂师代码
				s HDSD0004004=$P($G(^SSU("SSUSR",DHCPHAAuditorDr)),"^",1)
				//处方核对药剂师签名
				s HDSD00040041=$P($G(^SSU("SSUSR",DHCPHAAuditorDr)),"^",2)
			}
		}
	}else{
		//门诊
		s PHDROWID=$O(^DHCPHDISPi("PRESCNO",PrescNo,0))
		if (PHDROWID'=""){
			s PHPPYDR=$P($G(^DHCPHDISP(PHDROWID,1)),"^",3)
			if (PHPPYDR'=""){
				s PHPSSUSRDR=$P($G(^DHCPHPER(PHPPYDR)),"^",5)
				if (PHPSSUSRDR'=""){
					//处方调配药剂师代码
					s HDSD0004010=$P($G(^SSU("SSUSR",PHPSSUSRDR)),"^",1)
					//处方调配药剂师签名
					s HDSD00040101=$P($G(^SSU("SSUSR",PHPSSUSRDR)),"^",2)
				}
			}
			s PHDCheckUserDr=$P($G(^DHCPHDISP(PHDROWID,2)),"^",7)	//核对人
			if (PHDCheckUserDr'=""){
				//处方核对药剂师代码
				s HDSD0004004=$P($G(^SSU("SSUSR",PHDCheckUserDr)),"^",1)
				//处方核对药剂师签名
				s HDSD00040041=$P($G(^SSU("SSUSR",PHDCheckUserDr)),"^",2)
			}
		}
	}
	/*
	s dspId=$O(^DHCOEDISQTY(0,"OEORI",OrderID_"||"_SubID,0))
	if (dspId'=""){
		s DSPUserDr=$P(^DHCOEDISQTY(dspId),"^",10)
		if (DSPUserDr'=""){
			//处方发药药剂师代码
			s HDSD0004003=$P($G(^SSU("SSUSR",DSPUserDr)),"^",1)
			//处方发药药剂师签名
			s HDSD00040031=$P($G(^SSU("SSUSR",DSPUserDr)),"^",2)
		}
	}
	*/
	s PHDRowDr=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	if (PHDRowDr'=""){
		s PHPFYDR=$P(^DHCPHDISP(PHDRowDr,1),"^",2)
		if (PHPFYDR'=""){
			s SSUSRDR=$p(^DHCPHPER(PHPFYDR),"^",5)
			if (SSUSRDR'=""){
				//处方发药药剂师代码
				s HDSD0004003=$P($G(^SSU("SSUSR",SSUSRDR)),"^",1)
				//处方发药药剂师签名
				s HDSD00040031=$P($G(^SSU("SSUSR",SSUSRDR)),"^",2)
			}
		}
	}
	
	
	s PrescSum=0
	s PresSubID=0
	for {
		s PresSubID=$O(^OEORD(0,"PrescNo",PrescNo,OrderID,PresSubID))
		q:(PresSubID="")
		if ($D(^DHCPBi(0,"OEORI",OrderID_"||"_PresSubID))){
			s PBRowId=0
			for {
				s PBRowId=$O(^DHCPBi(0,"OEORI",OrderID_"||"_PresSubID,PBRowId))
				q:(PBRowId="")
				s PBOChildSub=0
				for {
					s PBOChildSub=$O(^DHCPBi(0,"OEORI",OrderID_"||"_PresSubID,PBRowId,PBOChildSub))
					q:(PBOChildSub="")
					s PPatShare=+$p($g(^DHCPB(PBRowId,"O",PBOChildSub)),"^",11)
					s PrescSum=PrescSum+PPatShare
				}
			}
		}else{
			s qty=0
			s dis=0
			for{
				s dis=$O(^DHCOEDISQTY(0,"OEORI",OrderID_"||"_PresSubID,dis))
				q:dis=""
				s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
				i (dstatus="C")||(dstatus="TC") {
					s qty=qty+$p(^DHCOEDISQTY(dis),"^",11)
				}
			}
			s price=+##Class(web.DHCDocOrderCommon).GetOEORIPrice(OrderID_"||"_PresSubID)
			s totalprice=price*qty
			s PrescSum=PrescSum+totalprice
		}
	}
	//处方费用金额
	s HDSD0004011=PrescSum
	s MaxDurFactur=0
	s PresSubID=0
	for {
		s PresSubID=$O(^OEORD(0,"PrescNo",PrescNo,OrderID,PresSubID))
		q:(PresSubID="")
		s itemstat=$p($g(^OEORD(OrderID,"I",PresSubID,1)),"^",13)
		i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		continue:("UHDIC")[statcode
		s PriorityDR = $p($g(^OEORD(OrderID,"I",PresSubID,1)),"^",8)
		s PriorCode=$p($g(^OECPR(PriorityDR)),"^")
		if (PriorCode="S")||(PriorCode="OMST")||(PriorCode="OMCQZT") {
			s OrderStarDate=$p($g(^OEORD(OrderID,"I",PresSubID,1)),"^",9)
			s OrderEndDate=$p($g(^OEORD(OrderID,"I",PresSubID,9)),"^",9)
			if (OrderStarDate'="")&&(OrderEndDate'=""){
				s OrderDurFactor=OrderEndDate-OrderStarDate
				if (OrderDurFactor>MaxDurFactur){
					s MaxDurFactur=OrderDurFactor
				}
			}
		}else{
			s OrderDurRowid=$P($G(^OEORD(OrderID,"I",PresSubID,2)),"^",6)
			if (OrderDurRowid=""){
				s OrderDurFactor=1
			}else{
				s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
			}
			
			if (OrderDurFactor>MaxDurFactur){
				s MaxDurFactur=OrderDurFactor
			}
		}
	}
	//处方有效天数
	s HDSD0004013=MaxDurFactur
	//处方备注信息
	s HDSD0004001=""
	d OutputRowDrugPreInfo

	
	Q
OutputRowDrugPreInfo
	Set Data=$LB(AdmID,DocumentID,HDSD0004002,HDSD0004006,HDSD0004005,HDSD0004007,HDSD00040071,HDSD0004009,HDSD00040091,HDSD0004010,HDSD00040101,HDSD0004004,HDSD00040041,HDSD0004003,HDSD00040031,HDSD0004011,HDSD0004013,HDSD0004001,HDSD00040051)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
ReSetDrugPreInfo
	s (AdmID,DocumentID,HDSD0004002,HDSD0004006,HDSD0004005,HDSD0004007,HDSD00040071,HDSD0004009,HDSD00040091,HDSD0004010,HDSD00040101,HDSD0004004,HDSD00040041,HDSD0004003,HDSD00040031,HDSD0004011,HDSD0004013,HDSD0004001,HDSD00040051)=""
	Quit
}

ClassMethod QueryDrugPreInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDrugPreInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryDrugPreInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDrugPreInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
