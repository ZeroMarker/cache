Import SQLUser

Class web.DHCPATCardUnite Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 104;

// w ##class(web.DHCPATCardUnite).GetAllCardInfoByRegNo("0000110135")

ClassMethod GetAllCardInfoByRegNo(RegNo As %Library.String = "")
{
	n (RegNo)
	s rtn=""
	q:RegNo="" rtn
	;s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	;s RegNo=$e("0000000000000000000",1,myPatLen-$l(RegNo))_RegNo
	s papmiID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:papmiID="" rtn
	s cardRef=0
	f  s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",papmiID,cardRef)) q:cardRef=""  d
	.s type=$P(^DHCCARD("CF",cardRef),"^",10)
	.q:type'="N"
	.s cardNo=$P(^DHCCARD("CF",cardRef),"^",2)
	.s cardType=$P(^DHCCARD("CF",cardRef),"^",16)
	.i cardType'="" s cardType=$P(^DHCCARDTYPEDef(cardType),"^",2)
	.s oneInfo=cardRef_$C(2)_cardType_"^"_cardNo
	.i rtn="" d
	..s rtn=oneInfo
	.e  d
	..s rtn=rtn_$C(1)_oneInfo
	q rtn
}

ClassMethod GetPatInfoByRegNo(RegNo As %Library.String = "")
{
	;w ##class(web.DHCPATCardUnite).GetPatInfoByRegNo("00000007")
	n (RegNo)
	s rtn="^^^^^^^^^"
	q:RegNo="" rtn
	s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	s myPatLen=0
	
	s RegNo=$e("0000000000000000000",1,myPatLen-$l(RegNo))_RegNo
	s RegNo=$ZCVT(RegNo,"U")
	s papmiID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:papmiID="" rtn
	q:##class(web.DHCPATCardUnite).PatMasActive(papmiID)="N" rtn
	s Name=$P(^PAPER(papmiID,"ALL"),"^",1)
	s Sex=$P(^PAPER(papmiID,"ALL"),"^",7)
	i Sex'="" s Sex=$P(^CT("SEX",Sex),"^",2)
	s Dob=$P(^PAPER(papmiID,"ALL"),"^",6)
	i Dob'="" s Dob=..%ZD(Dob) //$ZD(Dob,3)
	s ID=$P(^PAPER(papmiID,"PAT",3),"^",6)
	s MedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmiID,"",$g(%session.Data("LOGON.HOSPID")))
	s PatType="",PatCode=""
	s PatType=$P(^PAPER(papmiID,"PER",1),"^",10)
	s:PatType'="" PatType=PatType_";"_$P(^CT("SS",PatType),"^",2)
	s AccMID=..GetAccMID(papmiID)
	s Amount=""
	s:AccMID'="" Amount=$P(^DHCACD("AccM",AccMID),"^",8)
	s:Amount'="" Amount=+Amount
	s YBCode=$p($g(^PAPER(papmiID,"PAT",3)),"^",12) //$P(^PAPER(papmiID,"ALL"),"^",19)
	s AdmInfo=..GetAdmInfo(papmiID)
	//Add
	s CredType=$p($g(^PAPER(papmiID,"PAT",3)),"^",7)
	s:CredType'="" CredType=CredType_";"_$P(^PAC("CARD",CredType),"^",2)
	s Marital=$p($g(^PAPER(papmiID,"PER",2)),"^",3)
	s:Marital'="" Marital=Marital_";"_$P(^CT("MAR",Marital),"^",2)
	s Tel=$p($g(^PAPER(papmiID,"PER",1)),"^",11)
	s Mobile=$p($g(^PAPER(papmiID,"PER",4)),"^",21)
	s MedicalUnionNo=$p($g(^PAPER(papmiID,"PAT",3)),"^",12)
	s Country=$p($g(^PAPER(papmiID,"PER",1)),"^",8)
	b ;1
	s:Country'="" Country=Country_";"_$P(^CT("COU",Country),"^",2)
	b ;2
	s Nation=$p($g(^PAPER(papmiID,"PER",2)),"^",1)
	s:Nation'="" Nation=Nation_";"_$P(^CT("NAT",Nation),"^",2)
	s ProvinceHome=$p($g(^PAPER(papmiID,"PER",2)),"^",11)
	s:ProvinceHome'="" ProvinceHome=ProvinceHome_";"_$P(^CT("PROV",ProvinceHome),"^",2)
	s CityHome=$p($g(^PAPER(papmiID,"ALL")),"^",18)
	s:CityHome'="" CityHome=CityHome_";"_$P(^CT("CIT",CityHome),"^",2)
	s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",papmiID,0))
	i DHCPersonID'="" d
	.s ProvinceBirth=$P(^DHCPERSON(DHCPersonID),"^",13)
	.s:ProvinceBirth'="" ProvinceBirth=ProvinceBirth_";"_$P(^CT("PROV",ProvinceBirth),"^",2)
	.s CityBirth=$P(^DHCPERSON(DHCPersonID),"^",14)
	.s:CityBirth'="" CityBirth=CityBirth_";"_$P(^CT("CIT",CityBirth),"^",2)
	.s AreaBirth=$P(^DHCPERSON(DHCPersonID),"^",15)
	.s:AreaBirth'="" AreaBirth=AreaBirth_";"_$P(^CT("CITAREA",AreaBirth),"^",2)
	.s CompanyPostCode=$P(^DHCPERSON(DHCPersonID),"^",7)
	.s ProvinceHouse=$P(^DHCPERSON(DHCPersonID),"^",17)
	.s:ProvinceHouse'="" ProvinceHouse=ProvinceHouse_";"_$P(^CT("PROV",ProvinceHouse),"^",2)
	.s Cityhouse=$P(^DHCPERSON(DHCPersonID),"^",18)
	.s:Cityhouse'="" Cityhouse=Cityhouse_";"_$P(^CT("CIT",Cityhouse),"^",2)
	.s AreaHouse=$P(^DHCPERSON(DHCPersonID),"^",19)
	.s:AreaHouse'="" AreaHouse=AreaHouse_";"_$P(^CT("CITAREA",AreaHouse),"^",2)
	.s PostCodeHouse=$P(^DHCPERSON(DHCPersonID),"^",9)
	.s Zip=$P(^DHCPERSON(DHCPersonID),"^",8)
	e  d
	.s (ProvinceBirth,CityBirth,AreaBirth,CompanyPostCode,ProvinceHouse,Cityhouse,AreaHouse,PostCodeHouse,Zip)=""
	s Province=$p($g(^PAPER(papmiID,"PER",4)),"^",2)
	s:Province'="" Province=Province_";"_$P(^CT("PROV",Province),"^",2)
	s City=$p($g(^PAPER(papmiID,"PER",1)),"^",5)
	s:City'="" City=City_";"_$P(^CT("CIT",City),"^",2)
	s Area=$p($g(^PAPER(papmiID,"PER",4)),"^",9)
	s:Area'="" Area=Area_";"_$P(^CT("CITAREA",Area),"^",2)
	s Address=$p($g(^PAPER(papmiID,"PER","ADD",1)),"^",1)
	//s Zip=$p($g(^PAPER(papmiID,"PER",1)),"^",7)
	//s:Zip'="" Zip=Zip_";"_$P(^CT("ZIP",Zip),"^",2)
	s Vocation=$p($g(^PAPER(papmiID,"PER",2)),"^",6)
	s:Vocation'="" Vocation=Vocation_";"_$P(^CT("OCC",Vocation),"^",2)
	s Company=$p($g(^PAPER(papmiID,"PER",4)),"^",18)
	s OfficeTel=$p($g(^PAPER(papmiID,"PER",1)),"^",9)
	//s CompanyPostCode
	//s ProvinceHouse
	//s Cityhouse
	//s AreaHouse
	//s PostCodeHouse
	s ForeignName=$p($g(^PAPER(papmiID,"PER",2)),"^",13)
	s Relation=$p($g(^PAPER(papmiID,"EMP")),"^",4)
	s:Relation'="" Relation=Relation_";"_$P(^CT("RLT",Relation),"^",2)
	s ForeignAddress=$p($g(^PAPER(papmiID,"PER",1)),"^",1)
	s ForeignPhone=$p($g(^PAPER(papmiID,"ALL")),"^",4)
	s ForeignIDCard=$p($g(^PAPER(papmiID,"PER",2)),"^",4)
	s EmployeeFunction=$p($g(^PAPER(papmiID,"PER",3)),"^",3)
	s:EmployeeFunction'="" EmployeeFunction=EmployeeFunction_";"_$P($g(^CT("EMF",EmployeeFunction)),"^",2)
	s PAPMISecretLevel=$p($g(^PAPER(papmiID,"DHC")),"^",30)
	s:PAPMISecretLevel'="" PAPMISecretLevel=PAPMISecretLevel_";"_$List(^User.DHCSecretLevelD(PAPMISecretLevel),3)
	
	s ret=Name_"^"_Sex_"^"_Dob_"^"_ID_"^"_MedicalNo_"^"_PatType_"^"_PatCode_"^"_Amount_"^"_YBCode_"^"_AdmInfo
	s ret=ret_"^"_CredType_"^"_Marital_"^"_Tel_"^"_Mobile_"^"_MedicalUnionNo_"^"_Country_"^"_Nation
	s ret=ret_"^"_ProvinceHome_"^"_CityHome_"^"_ProvinceBirth_"^"_CityBirth_"^"_AreaBirth_"^"_CompanyPostCode_"^"_ProvinceHouse
	s ret=ret_"^"_Cityhouse_"^"_AreaHouse_"^"_PostCodeHouse_"^"_Province_"^"_City_"^"_Area_"^"_Address
	s ret=ret_"^"_Zip_"^"_Vocation_"^"_Company_"^"_OfficeTel_"^"_ForeignName_"^"_Relation_"^"_ForeignAddress
	s ret=ret_"^"_ForeignPhone_"^"_ForeignIDCard_"^"_EmployeeFunction_"^"_PAPMISecretLevel
	q ret
}

ClassMethod GetAccMID(papmiID)
{
	s AccMID=""
	s AccID=""
	f  s AccID=$O(^DHCACDi("AccM",0,"PAPMI",papmiID,AccID)) q:(AccID="")||(AccMID'="")  d
	.s Status=$P(^DHCACD("AccM",AccID),"^",13)
	.q:Status'="N"
	.s AccMID=AccID
	q AccMID
}

ClassMethod GetRegNoByCardNo(CardType, CardNo)
{
	n (CardType,CardNo)
	s RegNo=""
	s CardRef=0
	f  s CardRef=$o(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,CardRef)) q:(CardRef="")||(RegNo'="")  d
	.s ActiveFlag=$p(^DHCCARD("CF",CardRef),"^",10)
	.q:ActiveFlag'="N"
	.s RegNo=$p(^DHCCARD("CF",CardRef),"^",6)
	q RegNo   //返回登记号
}

// 检查合并的卡类型是不是有相同的

// rtn 1  有相同的类型

// w ##class(web.DHCPATCardUnite).CheckCardType("a^b")

ClassMethod CheckCardType(SelectCard)
{
	
	n (SelectCard)
	s rtn=0
	q rtn ;不判断是否存在相同类型的卡
	s i=$L(SelectCard,"^")
	f j=1:1:i d
	.s oneType=$p(SelectCard,"^",j)
	.q:oneType=""
	.s:$D(^TempDHCPAT($J,oneType)) rtn=1
	.s ^TempDHCPAT($J,oneType)=""
	k ^TempDHCPAT($J)
	q rtn
}

ClassMethod GetOldOtherInfo(papmiID, HospId As %String = "")
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s OldMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmiID,"",HospId)
	s OldPatType=$P(^PAPER(papmiID,"PER",1),"^",10)
	s OldYBCode=$P(^PAPER(papmiID,"ALL"),"^",19)
	s CredType=$p($g(^PAPER(papmiID,"PAT",3)),"^",7)
	s Marital=$p($g(^PAPER(papmiID,"PER",2)),"^",3)
	s Tel=$p($g(^PAPER(papmiID,"PER",1)),"^",11)
	s Mobile=$p($g(^PAPER(papmiID,"PER",4)),"^",21)
	s MedicalUnionNo=$p($g(^PAPER(papmiID,"PAT",3)),"^",12)
	s Country=$p($g(^PAPER(papmiID,"PER",1)),"^",8)
	s Nation=$p($g(^PAPER(papmiID,"PER",2)),"^",1)
	s ProvinceHome=$p($g(^PAPER(papmiID,"PER",2)),"^",11)
	s CityHome=$p($g(^PAPER(papmiID,"ALL")),"^",18)
	s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",papmiID,0))
	i DHCPersonID'="" d
	.s ProvinceBirth=$P(^DHCPERSON(DHCPersonID),"^",13)
	.s CityBirth=$P(^DHCPERSON(DHCPersonID),"^",14)
	.s AreaBirth=$P(^DHCPERSON(DHCPersonID),"^",15)
	.s CompanyPostCode=$P(^DHCPERSON(DHCPersonID),"^",7)
	.s ProvinceHouse=$P(^DHCPERSON(DHCPersonID),"^",17)
	.s Cityhouse=$P(^DHCPERSON(DHCPersonID),"^",18)
	.s AreaHouse=$P(^DHCPERSON(DHCPersonID),"^",19)
	.s PostCodeHouse=$P(^DHCPERSON(DHCPersonID),"^",9)
	.s Zip=$P(^DHCPERSON(DHCPersonID),"^",8)
	e  d
	.s (ProvinceBirth,CityBirth,AreaBirth,CompanyPostCode,ProvinceHouse,Cityhouse,AreaHouse,PostCodeHouse,Zip)=""
	s Province=$p($g(^PAPER(papmiID,"PER",4)),"^",2)
	s City=$p($g(^PAPER(papmiID,"PER",1)),"^",5)
	s Area=$p($g(^PAPER(papmiID,"PER",4)),"^",9)
	s Address=$p($g(^PAPER(papmiID,"PER","ADD",1)),"^",1)
	s Vocation=$p($g(^PAPER(papmiID,"PER",2)),"^",6)
	s Company=$p($g(^PAPER(papmiID,"PER",4)),"^",18)
	s OfficeTel=$p($g(^PAPER(papmiID,"PER",1)),"^",9)
	s ForeignName=$p($g(^PAPER(papmiID,"PER",2)),"^",13)
	s Relation=$p($g(^PAPER(papmiID,"EMP")),"^",4)
	s ForeignAddress=$p($g(^PAPER(papmiID,"PER",1)),"^",1)
	s ForeignPhone=$p($g(^PAPER(papmiID,"ALL")),"^",4)
	s ForeignIDCard=$p($g(^PAPER(papmiID,"PER",2)),"^",4)
	s OldIDCard=$p($g(^PAPER(papmiID,"PAT",3)),"^",6)
	s ForeignCredType=$p($g(^PAPER(papmiID,"ALL")),"^",25)
	s PoliticalLevel=$p($g(^PAPER(papmiID,"PER",3)),"^",3)
	s SecretLevel=$P(^PAPER(papmiID ,"DHC"),"^",30)
	s StreetBirth=$p($g(^PAPER(papmiID,"DHC")),"^",52)
	s StreetHouse=$p($g(^PAPER(papmiID,"DHC")),"^",53)
	s StreetNow=$p($g(^PAPER(papmiID,"DHC")),"^",54)
	s ret=OldMedicare_"^"_OldPatType_"^"_OldYBCode
	s ret=ret_"^"_CredType_"^"_Marital_"^"_Tel_"^"_Mobile_"^"_MedicalUnionNo_"^"_Country_"^"_Nation
	s ret=ret_"^"_ProvinceHome_"^"_CityHome_"^"_ProvinceBirth_"^"_CityBirth_"^"_AreaBirth_"^"_CompanyPostCode_"^"_ProvinceHouse
	s ret=ret_"^"_Cityhouse_"^"_AreaHouse_"^"_PostCodeHouse_"^"_Province_"^"_City_"^"_Area_"^"_Address
	s ret=ret_"^"_Zip_"^"_Vocation_"^"_Company_"^"_OfficeTel_"^"_ForeignName_"^"_Relation_"^"_ForeignAddress
	s ret=ret_"^"_ForeignPhone_"^"_ForeignIDCard_"^"_PoliticalLevel_"^"_SecretLevel_"^"_OldIDCard_"^"_ForeignCredType
	s ret=ret_"^"_StreetNow_"^"_StreetBirth_"^"_StreetHouse
	s ret=$tr(ret,$C(1),"")
	q ret
}

/// creator:郭荣勇
/// date:2013-01-17
/// desc:医嘱是否有过发药
/// output:1 有发药;0 没有发药
/// w ##class(web.UDHCStopOrderLook).IsDspDrug("599||1")
ClassMethod IsDspDrug(oeitm As %String) As %String
{
	n (oeitm)
	s dstatusFlag=0
	s dis=0 for {
		s dis=$O(^DHCOEDISQTY(0,"OEORI",oeitm,dis)) q:dis=""
		s dstatus=""
		if $g(dis)'="" s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		if dstatus="C" s dstatusFlag=1
		q:dstatusFlag=1	
	}
	
	q dstatusFlag
}

/// 不需要合并规则,返回1^不合原因 可以不合
ClassMethod CheckCardUnite(OldRegNo As %String) As %String
{
	n (OldRegNo)
	s myrtnFlag=0,myrtnInfo=""
	s OldPapmiID=$O(^PAPERi("PAPMI_PatNo",OldRegNo,0))

	;住院病人未财务结算不能合并,留观病人,不能合并
	s PAAdmTypeStr="O^E^I"
	s ExitFlag=0,ExitInfo=""
	f i=1:1:$l(PAAdmTypeStr,"^") {
		s AdmType=$p(PAAdmTypeStr,"^",i)
		s AdmId=0
		for {
			s AdmId=$O(^PAPERdr(OldPapmiID,"ADM",AdmType,AdmId)) q:AdmId=""
			s VisitStatus=$P(^PAADM(AdmId),"^",20)
			continue:VisitStatus="C"
			s Dep="",Doc=""
			s DepCodeDR=$p($g(^PAADM(AdmId)),"^",4)
			i DepCodeDR'="" s Dep=$p($g(^CTLOC(DepCodeDR)),"^",2)
			s AdmDocCodeDR=$p($g(^PAADM(AdmId)),"^",9)
			i AdmDocCodeDR'="" s Doc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
			if AdmType="I" {
				;住院财务结算
				s ChargeAudit=##class(web.DHCDocMain).isFinDischg(AdmId)
				s BillFlag=$p($g(^PAADM(AdmId)),"^",45)
				s BillNo=$O(^DHCPB(0,"ADM",AdmId,""),-1)
				//s ChargeAudit=##class(web.DHCIPBillConfirm).GetFinalConfFlag(+BillNo)
				//if ($p(ChargeAudit,"^")'="Y")&&(BillFlag'="Y") s myrtnFlag=1,myrtnInfo="被合并的ID:"_OldRegNo_"就诊唯一号("_AdmId_")未做财务结算,不能合并."
				if ($p(ChargeAudit,"^")'="1")&&(BillFlag'="Y") s myrtnFlag=1,myrtnInfo="被合并的ID:"_OldRegNo_"就诊唯一号("_AdmId_")未做财务结算,不能合并."
			}else {
				;急诊留观
				s StayFlag=##class(web.DHCADMVisitStat).GetStayStatus(AdmId)
				if StayFlag=1 s myrtnFlag=1,myrtnInfo="被合并的ID:"_OldRegNo_"就诊唯一号("_AdmId_")正在留观,不能合并."
				
				if myrtnFlag=0 {
					;存在100天内未缴费的医嘱,检验,检查未执行
					s AdmDate=$p($g(^PAADM(AdmId)),"^",6)
					continue:(+$H-100)>AdmDate
					s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(AdmId)
					continue:OrderRowid=""
					s itemsub=0
					for {
						s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")
						s statcode=""
						s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
						i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
						continue:(statcode="D")||(statcode="U")||(statcode="I")||(statcode="E")
						s Billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
						s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
						s OrderType=""
						s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
						i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
						s ServerMaterial=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
						i ServerMaterial="S" s ServerMaterial="Service"
						i Billed="P" {
							;已经收费的检验,检查未执行不允许合并
							i ((ServerMaterial="Service")||(OrderType="L"))&&(statcode'="E") s myrtnFlag=1,myrtnInfo="被合并的ID:"_OldRegNo_"存在已经收费的检验,检查未执行,不允许合并.注:(就诊日期:"_..%ZD(AdmDate)_",就诊科室:"_Dep_",医生:"_Doc_")"
							;已经收费未发药的不能合并
							if (OrderType="R") {
								s DisId=$O(^DHCOEDISQTY(0,"OEORI",OrderRowid_"||"_itemsub,0))
								if (DisId'="")&&(..IsDspDrug(OrderRowid_"||"_itemsub)=0) s myrtnFlag=1,myrtnInfo="被合并的ID:"_OldRegNo_"存在已经收费未发的药品,不允许合并.注:(就诊日期:"_..%ZD(AdmDate)_",就诊科室:"_Dep_",医生:"_Doc_")"
							}
						}else{
							;存在正常未收费的医嘱不允许合并
							s myrtnFlag=1,myrtnInfo="被合并的ID:"_OldRegNo_"存在未收费的医嘱,不允许合并.注:(就诊日期:"_..%ZD(AdmDate)_",就诊科室:"_Dep_",医生:"_Doc_")"
						}
						q:myrtnFlag=1
					}
				}
			}
			q:myrtnFlag=1
		}
	}
	
	q myrtnFlag_"^"_myrtnInfo
}

// w ##class(web.DHCPATCardUnite).CardUnite(2, 1, "")

// 合并卡信息

ClassMethod CardUnite(OldRegNo, RegNo, SelectCard, OtherInfo As %String = "", LogonHospDR As %String = "")
{
	s CurUserID=%session.Get("LOGON.USERID")
	n (OldRegNo, RegNo, SelectCard,CurUserID,OtherInfo,LogonHospDR)
	s $ZT="UniteErr"
	s OldPapmiID=$O(^PAPERi("PAPMI_PatNo",OldRegNo,0))
	s OldIDLevel=..GetIDLevel(OldPapmiID)
	s PapmiID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	s NewIDLevel=..GetIDLevel(PapmiID)
	i (OldIDLevel<NewIDLevel){
		q "更新到的ID优先级低于被合并的"
	}
	
	;住院病人未财务结算不能合并,留观病人,不能合并
	s CheckInfo=..CheckCardUnite(OldRegNo)
	q:$p(CheckInfo,"^",1)=1 $p(CheckInfo,"^",2)
	
	s SelectCard="^"_SelectCard_"^"
	s SQLCODE=0
	s Date=..%SysDate()
	s Time=..%SysTime()
	
	TSTART
	//更新合并到的登记号对应的卡信息
	
	i OtherInfo'=""{
		s OldOtherInfo=..GetOldOtherInfo(PapmiID)
		s SQLCODE=..UpdateOtherInfo(OtherInfo,PapmiID)
		i SQLCODE'=0{
			TROLLBACK
			q "更新合并到的登记号对应的病人信息错误1"
		}
		s OtherInfo=OldOtherInfo
		s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAPerson",OldPapmiID,PapmiID,PapmiID,OtherInfo,CurUserID)
		i SQLCODE'=0{
			TROLLBACK
			q "更新合并到的登记号对应的病人信息错误4"_SQLCODE
		}
	}
	s cardRef=0
	f  s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",PapmiID,cardRef)) q:(cardRef="")||(SQLCODE'=0)  d
	.s type=$P(^DHCCARD("CF",cardRef),"^",10)
	.q:type'="N"
	.i SelectCard'[("^"_cardRef_"^") d
	..&SQL(Update DHC_CardRef set CF_ActiveFlag='R' where CF_RowID=:cardRef)
	..q:SQLCODE'=0
	..&SQL(insert into DHC_CardStatusChange (CSC_CF_ParRef,CSC_Date,CSC_Time,CSC_CurStatus,CSC_User_DR,CSC_Hosp_DR) values (:cardRef,:Date,:Time,'R',:CurUserID,:LogonHospDR))
	..q:SQLCODE'=0
	..//插入日志、更新的不是PA_PatMas表ID更新其它信息
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCCardRefType",OldPapmiID,PapmiID,cardRef,type,CurUserID)
	i SQLCODE'=0{
		TROLLBACK
		q "更新合并到的登记号对应的卡信息错误"
	}
	//更新被合并登记号对应的卡
	s cardRef=0
	f  s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",OldPapmiID,cardRef)) q:(cardRef="")||(SQLCODE'=0)  d
	.s type=$P(^DHCCARD("CF",cardRef),"^",10)
	.q:type'="N"
	.i SelectCard'[("^"_cardRef_"^") d
	..&SQL(Update DHC_CardRef set CF_ActiveFlag='R' where CF_RowID=:cardRef)
	..q:SQLCODE'=0
	..&SQL(insert into DHC_CardStatusChange (CSC_CF_ParRef,CSC_Date,CSC_Time,CSC_CurStatus,CSC_User_DR,CSC_Hosp_DR) values (:cardRef,:Date,:Time,'R',:CurUserID,:LogonHospDR))
	..q:SQLCODE'=0
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCCardRefType",OldPapmiID,PapmiID,cardRef,type,CurUserID)
	.e  d
	..s NewAccMID=..GetAccMID(PapmiID)
	..s OldAccMID=$P(^DHCCARD("CF",cardRef),"^",1)  ;记录原账户信息
	..&SQL(Update DHC_CardRef set CF_PAPMI_DR=:PapmiID,CF_PAPMINo=:RegNo,CF_AccNo_DR=:NewAccMID where CF_RowID=:cardRef)
	..q:SQLCODE'=0
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCCardRef",OldPapmiID,PapmiID,cardRef,OldAccMID,CurUserID)
	b ;DHCCardRef over
	i SQLCODE'=0{
		TROLLBACK
		q "更新被合并登记号对应的卡信息错误"
	}
	//更新被合并登记号的病历号为空
	s OldMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(OldPapmiID,"",$g(%session.Data("LOGON.HOSPID")))
	&SQL(Update PA_PatMas set PAPMI_Active='N' where PAPMI_RowId=:OldPapmiID)
	i SQLCODE'=0{
		TROLLBACK
		q "更新被合并登记号对应的病历信息错误"
	}
	
	//插入日志、更新的不是PA_PatMas表ID更新其它信息
	s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAPatMas",OldPapmiID,PapmiID,OldPapmiID,OldMedicare,CurUserID)
	i SQLCODE'=0{
		TROLLBACK
		q "更新被合并登记号对应的病历信息错误"
	}
	//更新就诊以及预约记录  因为判断是否已就诊，预约记录分开更新了
	s err=..UniteAdmInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	
	//修改以后就诊信息的费别
	d ##class(DHCExternalService.CardInterface.CardManager).UpdateAdmedReason(PapmiID)
	
	//更新就诊信息
	s admType=""
	f  s admType=$O(^PAPERdr(OldPapmiID,"ADM",admType)) q:(admType="")||(SQLCODE'=0)  d
	.s admID=0
	.f  s admID=$O(^PAPERdr(OldPapmiID,"ADM",admType,admID)) q:(admID="")||(SQLCODE'=0)  d
	..&SQL(Update PA_Adm set PAADM_PAPMI_DR=:PapmiID where PAADM_RowID=:admID)
	..q:SQLCODE'=0
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAAdm",OldPapmiID,PapmiID,admID,"",CurUserID)
	i SQLCODE'=0{
		TROLLBACK
		q "合并就诊信息错误"
	}
	
	/*liuxuefeng
	//更新体检产品组的信息
	s err=..UnitePEInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	
	//更新护士站信息
	s err=##class(web.DHCPAPregnancy).UnitePregInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//医政组信息
	s SQLCODE=##class(DHCMed.Service).MergePatient(OldPapmiID,PapmiID,CurUserID)
	i +SQLCODE<0{
		TROLLBACK
		q "医政组更新错误"_SQLCODE
	}
	//统计组信息
	s err=$$UpPapmiOldToNew^DHCWLUPPapmi(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//更新其它产品组信息
	liuxuefeng*/
	TCOMMIT
	q ""
UniteErr
	TROLLBACK
	q "程序非正常退出"_$ZERROR
}

ClassMethod UpdateOtherInfo(OtherInfo, PapmiID)
{
	s ^Tempscl("UpdateOtherInfo")=OtherInfo_","_PapmiID
	s SQLCODE=0
	s MedicalNo=$P(OtherInfo,"^",1)
		s PatType=$P(OtherInfo,"^",2)
		s YBCode=$P(OtherInfo,"^",3)
		s CredType=$P(OtherInfo,"^",4)
		s Marital=$P(OtherInfo,"^",5)
		s Tel=$P(OtherInfo,"^",6)
		s Mobile=$P(OtherInfo,"^",7)
		s MedicalUnionNo=$P(OtherInfo,"^",8)
		s Country=$P(OtherInfo,"^",9)
		s Nation=$P(OtherInfo,"^",10)
		s ProvinceHome=$P(OtherInfo,"^",11)
		s CityHome=$P(OtherInfo,"^",12)
		s ProvinceBirth=$P(OtherInfo,"^",13)
		s CityBirth=$P(OtherInfo,"^",14)
		s AreaBirth=$P(OtherInfo,"^",15)
		s CompanyPostCode=$P(OtherInfo,"^",16)
		s ProvinceHouse=$P(OtherInfo,"^",17)
		s CityHouse=$P(OtherInfo,"^",18)
		s AreaHouse=$P(OtherInfo,"^",19)
		s PostCodeHouse=$P(OtherInfo,"^",20)
		s Province=$P(OtherInfo,"^",21)
		s City=$P(OtherInfo,"^",22)
		s Area=$P(OtherInfo,"^",23)
		s Address=$P(OtherInfo,"^",24)
		s Zip=$P(OtherInfo,"^",25)
		s Vocation=$P(OtherInfo,"^",26)
		s Company=$P(OtherInfo,"^",27)
		s OfficeTel=$P(OtherInfo,"^",28)
		s ForeignName=$P(OtherInfo,"^",29)
		s Relation=$P(OtherInfo,"^",30)
		s ForeignAddress=$P(OtherInfo,"^",31)
		s ForeignPhone=$P(OtherInfo,"^",32)
		s ForeignIDCard=$P(OtherInfo,"^",33)
		s PoliticalLevel=$P(OtherInfo,"^",34)
		s SecretLevel=$P(OtherInfo,"^",35)
		s IDCard=$P(OtherInfo,"^",36)
		s ForeignCredType=$P(OtherInfo,"^",37)
		s StreetNow=$P(OtherInfo,"^",38)
		s StreetBirth=$P(OtherInfo,"^",39)
		s StreetHouse=$P(OtherInfo,"^",40)
		s PAPERAreaHome=$P(OtherInfo,"^",41)
		s AddressBirth=$P(OtherInfo,"^",42)
		s RegisterPlace=$P(OtherInfo,"^",43)
		s AddressList=$LB(Address)
		&SQL(Update PA_Person set PAPER_SocialStatus_DR=:PatType
								  
								  ,PAPER_Marital_DR=:Marital
								  ,PAPER_TelH=:Tel
								  ,PAPER_Country_DR=:Country
								  ,PAPER_Nation_DR=:Nation
								  ,PAPER_Province_Birth_DR=:ProvinceHome
								  ,PAPER_CityBirth_DR=:CityHome
								  ,PAPER_CT_Province_DR=:Province
								  ,PAPER_CityCode_DR=:City
								  ,PAPER_CityArea_DR=:Area
								  ,PAPER_Occupation_DR=:Vocation
								  ,PAPER_TelO=:OfficeTel
								  ,PAPER_ForeignId=:ForeignName
								  ,PAPER_CTRLT_DR=:Relation
								  ,PAPER_ForeignAddress=:ForeignAddress
								  ,PAPER_ForeignPhone=:ForeignPhone
								  ,PAPER_ForeignCountry=:ForeignIDCard
								  ,PAPER_StName=:AddressList
								  ,PAPER_EmployeeFunction=:PoliticalLevel
								  ,PAPER_ForeignCardTypeDR=:ForeignCredType
								  ,PAPER_AreaHome_DR=:PAPERAreaHome
								 
		 where PAPER_RowId=:PapmiID)
		i SQLCODE'=0{
			q SQLCODE
		}
		&SQL(Update PA_PatMas set PAPMI_Medicare=:MedicalNo
								  ,PAPMI_Name3=:YBCode
								  ,PAPMI_CardType_DR=:CredType
								  ,PAPMI_MobPhone=:Mobile
								  ,PAPMI_HealthFundNo=:MedicalUnionNo
								  ,PAPMI_DVAnumber=:IDCard
								  ,PAPMI_SecondPhone=:Company
		where PAPMI_RowId=:PapmiID)
		i SQLCODE'=0{
			q SQLCODE
		}
		&SQL(Update DHC_PA_PatMas set PAPMI_StreetBirth=:StreetBirth
								  ,PAPMI_StreetHouse=:StreetHouse
								  ,PAPMI_StreetNow=:StreetNow
		where PAPMI_RowId=:PapmiID)
		i SQLCODE'=0{
			q SQLCODE
		}
		
		;身份证的设置要判断证件类型是不是身份证
		s CredTypeDesc=""
		S:CredType'="" CredTypeDesc=$P($G(^PAC("CARD",CredType)),"^",2)
		if (CredTypeDesc[("身份证")){
			s myPAID=$ZConvert(IDCard,"U")
			s $p(^PAPER(PapmiID,"ALL"),"^",9)=myPAID
			s myPAID=$ZConvert(IDCard_"Z","U")
			s ^PAPERi("PAPMI_ICPPBC",myPAID,PapmiID)=""
		}
			
		// PAPMI_SecretLevel_DR
		s $P(^PAPER(PapmiID ,"DHC"),"^",30)=SecretLevel
		s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PapmiID,0))
		i DHCPersonID'="" d
		.&SQL(Update DHC_Person set 
				PAPER_Comment1=:CompanyPostCode
				,PAPER_Comment3=:PostCodeHouse
				,PAPER_Comment2=:Zip
				,PAPER_BirthProvince_DR=:ProvinceBirth  
				,PAPER_BirthCity_DR=:CityBirth
				,PAPER_BirthArea_dr=:AreaBirth
				,PAPER_HouseProvince_DR=:ProvinceHouse
				,PAPER_HouseCity_DR=:CityHouse
				,PAPER_HouseArea_DR=:AreaHouse
				
				,PAPER_BirthAddress=:AddressBirth
				,PAPER_HouseAddress=:RegisterPlace
			where PAPER_RowID=:DHCPersonID
		)
		/*;PAPER_BirthProvince_DR=:ProvinceBirth  
		,PAPER_BirthCity_DR=:CityBirth
		,PAPER_BirthArea_dr=:AreaBirth
		,PAPER_HouseProvince_DR=:ProvinceHouse
		,PAPER_HouseCity_DR=:CityHouse
		,PAPER_HouseArea_DR=:AreaHouse
		*/
		e  d
		.&SQL(Insert DHC_Person (
						PAPER_Comment1
						,PAPER_Comment3
						,PAPER_Comment2
						,PAPER_BirthProvince_DR
						,PAPER_BirthCity_DR  
						,PAPER_BirthArea_dr
						,PAPER_HouseProvince_DR
						,PAPER_HouseCity_DR
						,PAPER_HouseArea_DR
						,PAPER_BirthAddress
						,PAPER_HouseAddress
					)
				values (
						:CompanyPostCode
						,:PostCodeHouse
						,:Zip
						,:ProvinceBirth
						,:CityBirth
						,:AreaBirth
						,:ProvinceHouse
						,:CityHouse
						,:AreaHouse
						,:AddressBirth
						,:RegisterPlace
						
				)
			)
			/*;PAPER_BirthProvince_DR
			,PAPER_BirthCity_DR  
			,PAPER_BirthArea_dr
			,PAPER_HouseProvince_DR
			,PAPER_HouseCity_DR
			,PAPER_HouseArea_DR
			
			:ProvinceBirth
			,:CityBirth
			,:AreaBirth
			,:ProvinceHouse
			,:CityHouse
			,:AreaHouse
			*/
		q SQLCODE
}

// 合并就诊以及预约记录

ClassMethod UniteAdmInfo(OldPAPMIID As %String = "", NewPAPMIID As %String = "", CurUserID As %String = "")
{
	n (OldPAPMIID, NewPAPMIID,CurUserID)
	s SQLCODE=0
	q:(OldPAPMIID="")||(NewPAPMIID="") SQLCODE
	s Type=""
	f  s Type=$O(^PAPERdr(OldPAPMIID,"ADM",Type)) q:(Type="")||(SQLCODE'=0)  d
	.s id=0
	.f  s id=$O(^PAPERdr(OldPAPMIID,"ADM",Type,id)) q:(id="")||(SQLCODE'=0)  d
	..s ActiveFlag=$P(^PAADM(id),"^",20)
	..;q:ActiveFlag="C"
	..s Date=$P(^PAADM(id),"^",6)
	..q:Date<+$H  ;只是判断了日期,没有判断时间
	..s MRAdm=$P(^PAADM(id),"^",61)
	..;q:$O(^MR(MRAdm,"DIA",0))'=""  ;有诊断的不做修改
	..&SQL(Update PA_Adm set PAADM_PAPMI_DR=:NewPAPMIID where PAADM_RowID=:id)
	..q:SQLCODE'=0
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAAdm",OldPAPMIID,NewPAPMIID,id,"",CurUserID)
	..q:SQLCODE'=0
	..//更新对应的预约ID
	..s ResourceID=$O(^RBAS("ADM",id,0))
	..q:ResourceID=""
	..s ASSub=$O(^RBAS("ADM",id,ResourceID,0))
	..s ApptSub=$O(^RBAS("ADM",id,ResourceID,ASSub,0))
	..s ApptID=ResourceID_"||"_ASSub_"||"_ApptSub
	..&SQL(Update RB_Appointment set APPT_PAPMI_DR=:NewPAPMIID where APPT_RowId=:ApptID)
	..q:SQLCODE'=0
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("RBAppointment",OldPAPMIID,NewPAPMIID,ApptID,"",CurUserID)
	q:SQLCODE'=0 "更新就诊以及预约记录错误"
	s Status=""
	f  s Status=$O(^PAPERDR(OldPAPMIID,"RB_Appt",Status)) q:(Status="")||(SQLCODE'=0)  d
	.s ResourceID=0
	.f  s ResourceID=$O(^PAPERDR(OldPAPMIID,"RB_Appt",Status,ResourceID)) q:(ResourceID="")||(SQLCODE'=0)  d
	..s ASSub=0
	..f  s ASSub=$O(^PAPERDR(OldPAPMIID,"RB_Appt",Status,ResourceID,ASSub)) q:(ASSub="")||(SQLCODE'=0)  d
	...s ApptSub=0
	...f  s ApptSub=$O(^PAPERDR(OldPAPMIID,"RB_Appt",Status,ResourceID,ASSub,ApptSub)) q:(ApptSub="")||(SQLCODE'=0)  d
	....s PAADM=$P(^RBAS(ResourceID,ASSub,"APPT",ApptSub),"^",4)
	....q:PAADM'=""  ;已经就诊的不再更新
	....s ApptID=ResourceID_"||"_ASSub_"||"_ApptSub
	....&SQL(Update RB_Appointment set APPT_PAPMI_DR=:NewPAPMIID where APPT_RowId=:ApptID)
	....q:SQLCODE'=0
	....s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("RBAppointment",OldPAPMIID,NewPAPMIID,ApptID,"",CurUserID)
	q:SQLCODE'=0 "更新预约记录错误"
	q ""
}

// 体检合并

ClassMethod UnitePEInfo(OldPAPMIID As %String = "", NewPAPMIID As %String = "", CurUserID As %String = "")
{
	n (OldPAPMIID, NewPAPMIID,CurUserID)
	s SQLCODE=0
	q:(OldPAPMIID="")||(NewPAPMIID="") SQLCODE
	s OldRegNo=$P(^PAPER(OldPAPMIID,"PAT",1),"^",1)
	s NewRegNo=$P(^PAPER(NewPAPMIID,"PAT",1),"^",1)
	s OldBaseId=$o(^DHCPEPREIBI(0,"PAPMINo",OldRegNo,0))
	s NewBaseId=$o(^DHCPEPREIBI(0,"PAPMINo",NewRegNo,0))
	i OldBaseId'="" d
	.i NewBaseId="" d
	..&sql(update DHC_PE_PreIBaseInfo set PIBI_PAPMINo=:NewRegNo where PIBI_RowId=:OldBaseId)
	..i SQLCODE=0 d //插入日志、更新的不是PA_PatMas表ID更新其它信息
	...s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCPEPreIBaseInfo",OldPAPMIID,NewPAPMIID,OldBaseId,OldRegNo,CurUserID)
	.e  d
	..s PreIAdmID=0
	..f  s PreIAdmID=$O(^DHCPEPreIADM(0,"PIBI",OldBaseId,PreIAdmID)) q:(PreIAdmID="")||(SQLCODE'=0)  d
	...&sql(update DHC_PE_PreIADM set PIADM_PIBI_DR=:NewBaseId where PIADM_RowID=:PreIAdmID)
	...i SQLCODE=0 d //插入日志、更新的不是PA_PatMas表ID更新其它信息
	....s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCPEPreIADM",OldPAPMIID,NewPAPMIID,PreIAdmID,OldBaseId,CurUserID)
	i SQLCODE'=0
	{
		q "更新体检信息错误"
	}
	q ""
}

// 撤销合并卡信息

ClassMethod CardConverse(OldRegNo, RegNo, ExpStr = "")
{
	n (OldRegNo,RegNo,ExpStr,%session)
	s CurUserID=$p(ExpStr,"^",1)
	if (CurUserID="") s CurUserID=%session.Get("LOGON.USERID")
	s LogonHospDR=$p(ExpStr,"^",2)
	s ComputerIP=$p(ExpStr,"^",3)
	
	s $ZT="ConverseErr"
	s OldPapmiID=$O(^PAPERi("PAPMI_PatNo",OldRegNo,0))
	s PapmiID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:'$D(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID)) "没有合并过这两个信息"
	s SQLCODE=0
	TSTART
	//撤销合并到卡信息修改
	s TableName=$ZCVT("PAPerson","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.i OtherInfo'="" d //更新状态  从日志中找到原来病历号以及病人类型
	..s SQLCODE=..UpdateOtherInfo(OtherInfo,RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新原病人信息错误"
	}
	
	//卡信息未合并,仅修改状态的卡信息记录撤销
	s Date=..%SysDate()
	s Time=..%SysTime()
	s TableName=$ZCVT("DHCCardRefType","U")
	s UnitID=0,Valid=1
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.s Valid=1
	.i OtherInfo="N" d
	..s Valid=..CheckCardNoIsValidate(RecordID)
	.q:Valid=0
	.&SQL(Update DHC_CardRef set CF_ActiveFlag=:OtherInfo where CF_RowID=:RecordID)
	.q:SQLCODE'=0
	.&SQL(insert into DHC_CardStatusChange (CSC_CF_ParRef,CSC_Date,CSC_Time,CSC_CurStatus,CSC_User_DR,CSC_Hosp_DR,CSC_ComputerIP) values (:RecordID,:Date,:Time,:OtherInfo,:CurUserID,:LogonHospDR,:ComputerIP))
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i Valid=0 {
		TROLLBACK
		q "被合并卡已使用,无法撤销合并"
	}
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新卡信息错误"
	}
	//卡信息撤销合并
	s TableName=$ZCVT("DHCCardRef","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.&SQL(Update DHC_CardRef set CF_PAPMI_DR=:OldPapmiID,CF_PAPMINo=:OldRegNo,CF_AccNo_DR=:OtherInfo where CF_RowID=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新卡信息错误"
	}
	//病历号撤销合并
	s TableName=$ZCVT("PAPatMas","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo //从日志文件找到原来病历号更新回来 PAPMI_Medicare=:OtherInfo,
	.&SQL(Update PA_PatMas set PAPMI_Active='Y' where PAPMI_RowId=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新病历号信息错误"
	}
	
	//就诊信息撤销合并
	s TableName=$ZCVT("PAAdm","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.&SQL(Update PA_Adm set PAADM_PAPMI_DR=:OldPapmiID where PAADM_RowID=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新就诊信息错误"
	}
	//预约记录撤销合并
	s TableName=$ZCVT("RBAppointment","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPapmiID," "_PapmiID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.&SQL(Update RB_Appointment set APPT_PAPMI_DR=:OldPapmiID where APPT_RowId=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "更新预约信息错误"
	}
	/*
	//更新体检产品组的信息
	s err=..ConversePEInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//更新护士站信息
	s err=##class(web.DHCPAPregnancy).ConversePregInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//更新医政组信息
	s SQLCODE=##class(DHCMed.Service).CancelMerge(OldPapmiID,PapmiID,CurUserID)
	i +SQLCODE<0{
		TROLLBACK
		q "医政组更新错误"_SQLCODE
	}
	//更新统计组信息
	s err=$$UpPapmiNewToOld^DHCWLUPPapmi(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//更新其它产品组信息
	*/
	TCOMMIT
	q ""
ConverseErr
	TROLLBACK
	q "程序非正常退出"
}

// 撤销合并体检信息

ClassMethod ConversePEInfo(OldPAPMIID As %String = "", NewPAPMIID As %String = "", CurUserID As %String = "")
{
	n (OldPAPMIID,NewPAPMIID,CurUserID)
	//Index OldNewPAPMI On (CUTableName As AlphaUp, CUActiveFlag, CUOldPAPMIRowid, CUNewPAPMIRowid, CURecordID)[ Data = CUOtherInfo ];
	s SQLCODE=0
	s TableName=$ZCVT("DHCPEPreIBaseInfo","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPAPMIID," "_NewPAPMIID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.&sql(Update DHC_PE_PreIBaseInfo set PIBI_PAPMINo=:OtherInfo where PIBI_RowId=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		q "更新体检基本信息错误"
	}
	s TableName=$ZCVT("DHCPEPreIADM","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPAPMIID," "_NewPAPMIID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.s OtherInfo=obj.CUOtherInfo
	.&sql(update DHC_PE_PreIADM set PIADM_PIBI_DR=:OtherInfo where PIADM_RowID=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0
	{
		q "更新体检预约信息错误"
	}
	q ""
}

ClassMethod PatientCardQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatientCardQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PatientCardQueryExecute(ByRef qHandle As %Binary, vName As %String = "", vCredNo As %String = "", vBirthDay As %String = "", vSex As %String = "", UserID As %String = "", TPAGCNTX As %String = "", vPatYBCode As %String = "", vAge As %String = "", vInMedicare As %String, CredTypeID As %String = "", TelHome As %String = "", PAPMINo As %String = "") As %Status
{
   // d ##class(%ResultSet).RunQuery("web.DHCPATCardUnite","PatientCardQuery","24352:20998:20108","22222","1993-06-05","2","","","","28岁","101034","22","19900033333","0000000017")
   	set ^tmp("PatientCardQueryExecute")=$LB(vName , vCredNo , vBirthDay , vSex , UserID , TPAGCNTX , vPatYBCode , vAge , vInMedicare, CredTypeID , TelHome , PAPMINo)
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^tmp("PatInfo",$j)
 	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
 	Set HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
 	s vvAge=vAge
 	if vvAge'=""{
 		Set:vvAge["-" vvAgeMin=$p(vvAge,"-",1)
 		Set:vvAge["-" vvAgeMax=$p(vvAge,"-",2)
 		Set:vvAge'["-" vvAgeMin=$case(vvAge["岁",1:$p(vvAge,"岁",1),:0)
 		Set:vvAge'["-" vvAgeMax=$case(vvAge["岁",1:$p(vvAge,"岁",1),:0)
 	}
	;姓名是以ASCII传入,需要转为字符
 	s vName=##class(DHCDoc.Util.Base).AscTransChar(vName)
	s vvName=$$ALPHAUP^SSUTIL4(vName)
	if vvName'="" {
		i UserID="" s UserID=%session.Get("LOGON.USERID")
		if TPAGCNTX="" {
			KILL ^TMPPatientCardQuery("PatientCardQuery",UserID)
			s ^TMPPatientCardQuery("PatientCardQuery",UserID)=vvName
		} else {
			s vvName=$g(^TMPPatientCardQuery("PatientCardQuery",UserID))
		}
	}
	;s vvName=##class(web.DHCDocCommon).UnEscape(vvName)
	
	s vvCredNo=$ZConvert(vCredNo,"U")
	s vvPatYBCode=$ZConvert(vPatYBCode,"U")
	s vvInMedicare=$ZConvert(vInMedicare,"U")
	s TelHome=$ZConvert(TelHome,"U")
	s PAPMINo=$ZConvert(PAPMINo,"U")
	//s PersonRowId=$o(^PAPERi("PAPMI_PatNo",PAPMINo,PersonRowId))
	if PAPMINo'=""{
		
		s PersonRowId=""
		f  s PersonRowId=$O(^PAPERi("PAPMI_PatNo",PAPMINo,PersonRowId)) q:PersonRowId=""  d
		.d PatInfoShow(PersonRowId)
	}
	if PAPMINo'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i vBirthDay'=""{
		s vBirthDay=..%ZDH(vBirthDay)
	}
	
	if vInMedicare'=""{
		s AloneFlag=1
		s PersonRowId=""
		f  s PersonRowId=$O(^PAPERi("Medicare1",vvInMedicare,PersonRowId)) q:PersonRowId=""  d
		.d PatInfoSetCount(PersonRowId,AloneFlag)
	}
	
	
	 if vvCredNo'=""{
		s AloneFlag=1
		s PersonRowId=""
		f  s PersonRowId=$o(^PAPERi("DVA",vvCredNo,PersonRowId)) q:PersonRowId=""  d
		.d PatInfoSetCount(PersonRowId,AloneFlag)
	} if (vvName'=""){
		s PersonRowId=""
		f  s PersonRowId =$o(^PAPERi("PAPER_PatName",vvName,PersonRowId)) q:PersonRowId=""  d
		.//增加年龄段查询
		.q:##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)="N"
		.s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
		.s PaperAgeYr=##class(web.PAPerson).calculateAge(PersonRowId,"Y")
		.q:((vvAge'="")&&((PaperAgeYr<vvAgeMin)||(PaperAgeYr>vvAgeMax)))
		.d PatInfoSetCount(PersonRowId)
	} if (TelHome'="") {
		s PersonRowId=""
		f  s PersonRowId = $o(^PAPERi("Phone",TelHome_"Z",PersonRowId)) q:PersonRowId=""  d
		.s PaperAgeYr=##class(web.PAPerson).calculateAge(PersonRowId,"Y")
		.q:##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)="N"
		.s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
		.q:((vvAge'="")&&((PaperAgeYr<vvAgeMin)||(PaperAgeYr>vvAgeMax)))
		.d PatInfoSetCount(PersonRowId)
	}
	s PersonRowId=0 f  s PersonRowId=$O(^tmp("PatInfo",$j,PersonRowId)) q:PersonRowId=""  d
    .d PatInfo(PersonRowId)
    k ^tmp("PatInfoCount",$j)
    s PersonRowId=0 f  s PersonRowId=$O(^tmp("PatInfo",$j,PersonRowId)) q:PersonRowId=""  d
    .s ^tmp("PatInfoCount",$j,+$G(^tmp("PatInfo",$j,PersonRowId)),PersonRowId)=""
    s Count="" f  s Count=$O(^tmp("PatInfoCount",$j,Count),-1) q:Count=""  d
    .s PersonRowId=0 f  s PersonRowId=$O(^tmp("PatInfoCount",$j,Count,PersonRowId)) q:PersonRowId=""  d
    ..d PatInfoShow(PersonRowId)
    k ^tmp("PatInfoCount",$j)
    k ^tmp("PatInfo",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PatInfoSetCount(PersonRowId,AloneFlag="")
	n (repid,ind,PersonRowId,AloneFlag,vBirthDay,vSex,vPatYBCode,CredTypeID,HospID,%session)
	d ReSetVar
	q:##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)="N"
	s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
	q 
PatInfoShow(PersonRowId,AloneFlag="1")
	n (repid,ind,PersonRowId,AloneFlag,vBirthDay,vSex,vPatYBCode,CredTypeID,HospID,%session)
	d ReSetVar
	q:##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)="N"
	s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
	s myName=$p($g(^PAPER(PersonRowId,"ALL")),"^",1)
	s myCredTypeID=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",7)
	s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	
	s myTelH=$p($g(^PAPER(PersonRowId,"PER",1)),"^",11) ;电话号码
	s myBirthDay=$p(^PAPER(PersonRowId,"ALL"),"^",6) ;出生日期
	
	;调用最新标准库统一接口
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PersonRowId,"",HospID)
	s myBirthDay=..%ZD(myBirthDay)
	i Age'="" s myBirthDay=myBirthDay_"("_Age_")"
	s mySexDr=$p(^PAPER(PersonRowId,"ALL"),"^",7) ;性别
	
	
	i mySexDr'="" d 
	.s mySexDesc=$p(^CT("SEX",mySexDr),"^",2)			 				
	e  s mySexDesc=""
	s myOutMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"O",$g(%session.Data("LOGON.HOSPID"))) ;门诊病历号(东)
	s myInMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"I",$g(%session.Data("LOGON.HOSPID"))) ;住院病历号(东)
	s myNewOutMedicareNo=""
	s myNewInMedicareNo=""
	s myEmMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"E",$g(%session.Data("LOGON.HOSPID"))) ;急诊病历号
	s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PersonRowId,""))
	i DHCPersonDr'=""  d 
	.i $d(^DHCPERSON(DHCPersonDr))  d 
	..s myNewOutMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",5)	;住院病历号(西)
	..s myNewInMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",6)		;住院病历号(西)
	..s myEmMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",2)		;急诊病历号
	
	s myAddress=$p($g(^PAPER(PersonRowId,"PER","ADD",1)),"^",1) ;住址
	s myCompany=$p($g(^PAPER(PersonRowId,"PER",4)),"^",18)      ;工作单位		 						 				
	s myPatType=""   
 	s socialstatus=$p($g(^PAPER(PersonRowId,"PER",1)),"^",10) 
	i socialstatus'="" d
	.s myPatType=$p($g(^CT("SS",socialstatus)),"^",2)           ;病人类型
	s myPapmiNo=$p($g(^PAPER(PersonRowId,"PAT",1)),"^",2)        ;IP_No
	s UnionNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",12)
	s PatYBCode=$p($G(^PAPER(PersonRowId,"PAT",3)),"^",12) //$p($G(^PAPER(PersonRowId,"ALL")),"^",19) 		;医保号
	s TMobPhone=$p($g(^PAPER(PersonRowId,"PER",4)),"^",21)   	;手机号 pa_patmas.PAPMI_MobPhone
	s vvPatYBCode=$ZConvert(vPatYBCode,"U")
	
	//联系人
	s myContactPerson=""
	i $d(^PAPER(PersonRowId,"PER",2)) s myContactPerson=$p(^PAPER(PersonRowId,"PER",2),"^",13) 
	
	//其他证件信息
	s OtherCardNo=..GetOtherCardInfo(PersonRowId)
	s myOtherStr=myTelH_"^"_myBirthDay_"^"_myAddress_"^"_myCompany_"^"_mySexDesc_"^"_myPatType_"^"_myPapmiNo
	s myOtherStr=myOtherStr_"^"_myInMedicareNo_"^"_myOutMedicareNo_"^"_myNewOutMedicareNo_"^"_myNewInMedicareNo_"^"_myEmMedicareNo_"^"_UnionNo_"^"_myContactPerson
	s myOtherStr=myOtherStr_"^"_TCreateDate_"^"_TCreateUser_"^"_PatYBCode_"^"_TMobPhone
	s CardNO=..GetCardNoInfo(PersonRowId)
	s CardNO=##class(web.DHCDocUtil).EvalJSON(CardNO)
	
	set Data=$ListBuild(myName,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),OtherCardNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
PatInfo(PersonRowId,AloneFlag="1")
	n (repid,ind,PersonRowId,AloneFlag,vBirthDay,vSex,vPatYBCode,CredTypeID,HospID,%session)
	d ReSetVar
	q:##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)="N"
	s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
	s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
	s myName=$p($g(^PAPER(PersonRowId,"ALL")),"^",1)
	s myCredTypeID=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",7)
	s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	i (CredTypeID'="")&&(myCredTypeID=CredTypeID) s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
	s myTelH=$p($g(^PAPER(PersonRowId,"PER",1)),"^",11) ;电话号码
	s myBirthDay=$p(^PAPER(PersonRowId,"ALL"),"^",6) ;出生日期
	i (vBirthDay'="")&&(myBirthDay=vBirthDay) s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
	;调用最新标准库统一接口
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PersonRowId,"",HospID)
	s myBirthDay=..%ZD(myBirthDay)
	i Age'="" s myBirthDay=myBirthDay_"("_Age_")"
	s mySexDr=$p(^PAPER(PersonRowId,"ALL"),"^",7) ;性别
	i (vSex'="")&&(mySexDr=vSex) s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
	i mySexDr'="" d 
	.s mySexDesc=$p(^CT("SEX",mySexDr),"^",2)			 				
	e  s mySexDesc=""
	s myOutMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"O",$g(%session.Data("LOGON.HOSPID"))) ;门诊病历号(东)
	s myInMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"I",$g(%session.Data("LOGON.HOSPID"))) ;住院病历号(东)
	s myNewOutMedicareNo=""
	s myNewInMedicareNo=""
	s myEmMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"E",$g(%session.Data("LOGON.HOSPID"))) ;急诊病历号
	s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PersonRowId,""))
	i DHCPersonDr'=""  d 
	.i $d(^DHCPERSON(DHCPersonDr))  d 
	..s myNewOutMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",5)	;住院病历号(西)
	..s myNewInMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",6)		;住院病历号(西)
	..s myEmMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",2)		;急诊病历号
	
	s myAddress=$p($g(^PAPER(PersonRowId,"PER","ADD",1)),"^",1) ;住址
	s myCompany=$p($g(^PAPER(PersonRowId,"PER",4)),"^",18)      ;工作单位		 						 				
	s myPatType=""   
 	s socialstatus=$p($g(^PAPER(PersonRowId,"PER",1)),"^",10) 
	i socialstatus'="" d
	.s myPatType=$p($g(^CT("SS",socialstatus)),"^",2)           ;病人类型
	s myPapmiNo=$p($g(^PAPER(PersonRowId,"PAT",1)),"^",2)        ;IP_No
	s UnionNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",12)
	s PatYBCode=$p($G(^PAPER(PersonRowId,"PAT",3)),"^",12) //$p($G(^PAPER(PersonRowId,"ALL")),"^",19) 		;医保号
	s TMobPhone=$p($g(^PAPER(PersonRowId,"PER",4)),"^",21)   	;手机号 pa_patmas.PAPMI_MobPhone
	s vvPatYBCode=$ZConvert(vPatYBCode,"U")
	i ($ZConvert(PatYBCode,"U")[vvPatYBCode)&&(vvPatYBCode'="") s ^tmp("PatInfo",$j,PersonRowId)=+$G(^tmp("PatInfo",$j,PersonRowId))+1
	//联系人
	s myContactPerson=""
	i $d(^PAPER(PersonRowId,"PER",2)) s myContactPerson=$p(^PAPER(PersonRowId,"PER",2),"^",13) 
	
	//其他证件信息
	s OtherCardNo=..GetOtherCardInfo(PersonRowId)
	s myOtherStr=myTelH_"^"_myBirthDay_"^"_myAddress_"^"_myCompany_"^"_mySexDesc_"^"_myPatType_"^"_myPapmiNo
	s myOtherStr=myOtherStr_"^"_myInMedicareNo_"^"_myOutMedicareNo_"^"_myNewOutMedicareNo_"^"_myNewInMedicareNo_"^"_myEmMedicareNo_"^"_UnionNo_"^"_myContactPerson
	s myOtherStr=myOtherStr_"^"_TCreateDate_"^"_TCreateUser_"^"_PatYBCode_"^"_TMobPhone
	s CardNO=..GetCardNoInfo(PersonRowId)
	s CardNO=##class(web.DHCDocUtil).EvalJSON(CardNO)
	
	q
	
ReSetVar
	set (CardNO,myTelH,myBirthDay,myInMedicareNo,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myEmMedicareNo,TCreateDate,TCreateUser,OtherCardNo)=""
	q
}

ClassMethod GetCardNoInfo(PersonRowId)
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s CardNO=""
	s CardID=""
	f  s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,CardID)) q:CardID=""  d
	.s Flag=$P(^DHCCARD("CF",CardID),"^",10)
	.q:Flag'="N"
	.set CFTypeID=$P(^DHCCARD("CF",CardID),"^",16)
	.//判断卡类型是否给该院区授权
	.s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFTypeID,HospID,+$H)
	.q:HosFlag'="Y"
	.s cCardNo=$P(^DHCCARD("CF",CardID),"^",2)
	.s CardTypeDR=$p($g(^DHCCARD("CF",CardID)),"^",16)
	.q:CardTypeDR=""
	.s CardType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",2)
	.//卡号拼接 卡类型首字母
	.s cCardNo=CardType_" "_cCardNo //$c(1)
	.i CardNO="" d
	..s CardNO=cCardNo
	.e  d
	..s CardNO=CardNO_","_cCardNo
	q CardNO
}

ClassMethod GetCardNoInfoCustom(PersonRowId, SearchSource As %String = "")
{
	
	s CardNO=""
	s CardID=""
	f  s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,CardID)) q:CardID=""  d
	.s Flag=$P(^DHCCARD("CF",CardID),"^",10)
	.q:(Flag'="N")&&(Flag'="UA")
	.s cCardNo=$P(^DHCCARD("CF",CardID),"^",2)
	.s CardTypeDR=$p($g(^DHCCARD("CF",CardID)),"^",16)
	.s CardType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",2)
	.//卡号拼接 卡类型首字母
	.s cCardNo=$e(CardType,1,1)_cCardNo
	.i CardNO="" d
	..s CardNO=cCardNo
	.e  d
	..s CardNO=CardNO_","_cCardNo
	q CardNO
}

ClassMethod PatientCardQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatientCardQueryExecute ]
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

Query PatientCardQuery(Name As %String = "", CredNo As %String = "", BirthDay As %String = "", Sex As %String = "", UserID As %String = "", TPAGCNTX As %String = "", PatYBCode As %String = "", Age As %String = "", InMedicare As %String = "", CredTypeID As %String = "", TelHome As %String = "", PAPMINo As %String = "") As %Query(ROWSPEC = "Name:%String,EmployeeNo:%String,IDCardNo:%String,CardNO:%String,ActivedFlag:%String,CardID:%String,CardTypeDesc:%String,CredNo:%String,CredTypeDesc:%String,myOtherStr:%String,TPatientID:%String,TCreateDate:%String,TCreateUser:%String,OtherCardNo:%String")
{
}

ClassMethod CardUniteQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardUniteQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardUniteQueryExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Name As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s Job=$J
 	k ^TempDHCPATCardUnit(Job)
 	i StartDate="" s StartDate=1
 	i EndDate="" s EndDate=..%SysDate()
 	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'=""   s EndDate=..%ZDH(EndDate)
 	s Date=StartDate-1
 	f  s Date=$O(^User.DHCPATCardUniteLogI("UnitDate",Date)) q:(Date="")||(Date>EndDate)  d
 	.s OldID=" "
 	.f  s OldID=$O(^User.DHCPATCardUniteLogI("UnitDate",Date,OldID)) q:(OldID="")  d
	..s NewID=" "
	..f  s NewID=$O(^User.DHCPATCardUniteLogI("UnitDate",Date,OldID,NewID)) q:(NewID="")  d
	...s ID=0
	...f  s ID=$O(^User.DHCPATCardUniteLogI("UnitDate",Date,OldID,NewID,ID)) q:(ID="")  d
	....s obj=##class(User.DHCPATCardUniteLog).%OpenId(ID)
	....s Flag=obj.CUActiveFlag
	....s OID=obj.CUOldPAPMIRowid
	....s NID=obj.CUNewPAPMIRowid
	....s Time=obj.CUInsertTime
	....s Type=obj.CUTableName
	....q:Type="PAAdm"
	....q:Type="RBAppointment"
	....s ^TempDHCPATCardUnit(Job,Date,Time,OID,NID,Flag)=ID
	s Date=""
	f  s Date=$O(^TempDHCPATCardUnit(Job,Date)) q:Date=""  d
	.s Time=""
	.f  s Time=$O(^TempDHCPATCardUnit(Job,Date,Time)) q:Time=""  d
	..s OID=""
	..f  s OID=$O(^TempDHCPATCardUnit(Job,Date,Time,OID)) q:OID=""  d
	...s NID=""
	...f  s NID=$O(^TempDHCPATCardUnit(Job,Date,Time,OID,NID)) q:NID=""  d
	....s Flag=""
	....f  s Flag=$O(^TempDHCPATCardUnit(Job,Date,Time,OID,NID,Flag)) q:Flag=""  d
	.....s ID=$G(^TempDHCPATCardUnit(Job,Date,Time,OID,NID,Flag))
	.....d CardUniteInfo(NID,OID,ID)
	k ^TempDHCPATCardUnit(Job)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
CardUniteInfo(NID,OID,ID)
	d CardUniteReSetVar
	s TOldRegNo=$P($G(^PAPER(OID,"PAT",1)),"^",2)
	s TNewRegNo=$P($G(^PAPER(NID,"PAT",1)),"^",2)
	s TName=$P(^PAPER(NID,"ALL"),"^",1)
	q:(Name'="")&&(TName'[Name)
	s TSex=$P(^PAPER(NID,"ALL"),"^",7)
	s:TSex'="" TSex=$P(^CT("SEX",TSex),"^",2)
	s TDob=$P(^PAPER(NID,"ALL"),"^",6)
	s:TDob'="" TDob=..%ZD(TDob) //$ZD(TDob,3)
	s TDate=..%ZD(Date) //$ZD(Date,3)
	s obj=##class(User.DHCPATCardUniteLog).%OpenId(ID)
	s CUInsertTime=obj.CUInsertTime
	s TDate=TDate_" "_..%ZT(CUInsertTime,1)
	s TUser=obj.CUInsertUserID
	s:TUser'="" TUser=$P(^SSU("SSUSR",TUser),"^",2)
	s TCancelDate=obj.CUConverseDate
	s:TCancelDate'="" TCancelDate=..%ZD(TCancelDate) //$ZD(TCancelDate,3)
	s TCancelTime=obj.CUConverseTime
	if TCancelTime'="" s TCancelTime=..%ZT(TCancelTime,1),TCancelDate=TCancelDate_" "_TCancelTime
	s TCancelUser=obj.CUConverseUserID
	s:TCancelUser'="" TCancelUser=$P(^SSU("SSUSR",TCancelUser),"^",2)
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(NID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	s TUnitReason=obj.CUUnitReason
	set Data=$ListBuild(TOldRegNo,TNewRegNo,TName,TSex,TDob,TDate,TUser,TCancelDate,TCancelUser,TPoliticalLevel,TSecretLevel,TUnitReason)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
	
CardUniteReSetVar
	set (TOldRegNo,TNewRegNo,TName,TSex,TDob,TDate,TUser,TCancelDate,TCancelUser,TPoliticalLevel,TSecretLevel)=""
	q
}

ClassMethod CardUniteQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardUniteQueryExecute ]
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

Query CardUniteQuery(StartDate As %String = "", EndDate As %String = "", Name As %String = "") As %Query(ROWSPEC = "TOldRegNo:%String,TNewRegNo:%String,TName:%String,TSex:%String,TDob:%String,TDate:%String,TUser:%String,TCancelDate:%String,TCancelUser:%String,TPoliticalLevel:%String,TSecretLevel:%String,TUnitReason:%String")
{
}

// q:##class(web.DHCPATCardUnite).PatMasActive(PatientID)="N"

ClassMethod PatMasActive(PatientID)
{
	q $P($G(^PAPER(PatientID,"PAT",1)),"^",6)
}

/// 4.1 存在银医卡合并到有银医卡的ID。
/// 4.2 存在医保号的合并到带有医保号的ID。
/// 4.3 存在一个病案号合并到带有病案号的ID。
/// 4.4 姓名、性别信息不一致不能合并，必须先走改名流程再进行合并。
/// 4.5 存在不同病案号的合并，必须有专门权限的操作员选择保留的病案号及ID。
/// 4.6 合并信息界面允许按照姓名、性别、及年龄范围去检索数据进行合并
/// 4.7 存在医保号、银医卡、病案号等多个ID进行合并时，合并原则是将医保号、银医卡和病案号（含以后的健康卡号等）统一合并到银医卡对应的ID。
/// 4.8 合并后，被合并的ID灭活，在系统中不再流通，诊疗信息应能通过合并后的ID查阅和使用。
/// 4.9 优先合并顺序从上至下。
/// creator:郭荣勇
/// date:2012-09-24
/// desc:自动合并卡信息,需要人为的规则暂不考虑,待后期通过"合并查询"菜单做撤销合并处理
ClassMethod AutoUnite(PatientNo)
{
	n (PatientNo)
	s $zt="AutoUniteErr"
	s myrtn=0
	s PatientNo=$$ALPHAUP^SSUTIL4(PatientNo)
	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	Q:PatientID="" "-100^病人登记号未找到病人表的Rowid"
	
	s PatCredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	s PatCredNo=$$ALPHAUP^SSUTIL4(PatCredNo)
	Q:PatCredNo="" "-100^没有身份证号"
	s PAPMIRowId=0
	for {
		s PAPMIRowId=$O(^PAPERi("DVA",PatCredNo,PAPMIRowId)) q:PAPMIRowId=""
		i $d(^TMPPAPMIDVA("CredNo",PatCredNo)) {
			i $d(^PAPMIDVARepeat("Repeat",PatCredNo)) {
				s ^PAPMIDVARepeat("Repeat",PatCredNo)=$g(^PAPMIDVARepeat("Repeat",PatCredNo))_"^"_PAPMIRowId
			}else{
				s ^PAPMIDVARepeat("Repeat",PatCredNo)=$g(^TMPPAPMIDVA("CredNo",PatCredNo))_"^"_PAPMIRowId
			}
			s myrtn=1
		}else{
			s ^TMPPAPMIDVA("CredNo",PatCredNo)=PAPMIRowId
		}
	}
	
	
	q myrtn
AutoUniteErr
	TRO
	Q "-100^程序异常,ErrorMsg:"_$ZERROR
}

/// 查询所有有重复身份证的病人Rowid
/// w ##class(web.DHCPATCardUnite).AutoUniteSearch()
ClassMethod AutoUniteSearch()
{
	k ^TMPPAPMIDVA("CredNo")
	k ^PAPMIDVARepeat("Repeat")
	s PAPMINo=0,Count=0
	for {
		s PAPMINo=$O(^PAPERi("PAPMI_PatNo",PAPMINo)) q:PAPMINo=""
		s IsRepeatFlag=..AutoUnite(PAPMINo)
		i IsRepeatFlag=1 s Count=Count+1
	}
	
	
	
	Q Count
}

/// 查询所有有重复卡号的病人Rowid
/// w ##class(web.DHCPATCardUnite).AutoRepeatCardNo()
ClassMethod AutoRepeatCardNo()
{
	k ^PAPMIDVARepeat("CardNo")
	s CFCardNo=0,Count=0
	for {
		s CFCardNo=$O(^DHCCARDi("CF",0,"CardNo",CFCardNo)) q:CFCardNo=""
		s CFRowId=0,RepeatCount=0,RepeatStr=""
		for {
			s CFRowId=$O(^DHCCARDi("CF",0,"CardNo",CFCardNo,CFRowId)) q:CFRowId=""
			s ActiveFlag=$p($g(^DHCCARD("CF",CFRowId)),"^",10)
			i ActiveFlag="N" {
				s RepeatCount=RepeatCount+1
				i RepeatStr="" s RepeatStr=CFRowId
				e  s RepeatStr=RepeatStr_"^"_CFRowId
			}
		}
		i RepeatCount>1 {
			for i=1:1:$L(RepeatStr,"^") {
				s CFRowId=$p(RepeatStr,"^",i)
				s CardNo=$p($g(^DHCCARD("CF",CFRowId)),"^",2)
				s PAPMINo=$p($g(^DHCCARD("CF",CFRowId)),"^",6)
				s PAPMIId=$p($g(^DHCCARD("CF",CFRowId)),"^",4)
				s IDCardNo=$p($g(^DHCCARD("CF",CFRowId)),"^",5)
				s CardTypeDR=$p($g(^DHCCARD("CF",CFRowId)),"^",16)
				continue:CardTypeDR=""
				s ^PAPMIDVARepeat("CardNo",CardTypeDR,CardNo,PAPMIId,CFRowId)=""
				s Count=Count+1
			}
		}
	}
	
	
	
	Q Count
}

/// 更新所有有重复卡号的病人Rowid,未关联卡置为回收R状态
/// w ##class(web.DHCPATCardUnite).UpdateRepeatCardNo()
ClassMethod UpdateRepeatCardNo()
{
	s CFCardNo=0,Count=0
	for {
		s CFCardNo=$O(^PAPMIDVARepeat("CardNo",3,CFCardNo)) q:CFCardNo=""
		s PAPMIId=0
		for {
			s PAPMIId=$O(^PAPMIDVARepeat("CardNo",3,CFCardNo,PAPMIId)) q:PAPMIId=""
			s CFRowId=0
			for {
				s CFRowId=$O(^PAPMIDVARepeat("CardNo",3,CFCardNo,PAPMIId,CFRowId)) q:CFRowId=""
				i $g(^PAPMIDVARepeat("CardNo",3,CFCardNo,PAPMIId,CFRowId))=-1 {
					&sql(Update SQLUser.DHC_CardRef set CF_ActiveFlag='R' Where CF_RowId=:CFRowId)
					i SQLCODE {
						s ^tmpgry("UpdateRepeatCardNo",CFCardNo,CFRowId)=SQLCODE
					}else{
						s Count=Count+1
						s ^PAPMIDVARepeat("CardNo",3,CFCardNo,PAPMIId,CFRowId)="OK"
					}
				}
			}
		}
	}
	
	Q Count
}

ClassMethod GetAdmInfo(PatientID)
{
	s SQLCODE=0
	s CurAdmNum=0
	s CurAmount=0
	s AAdmNum=0
	s Type=""
	f  s Type=$O(^PAPERdr(PatientID,"ADM",Type)) q:(Type="")||(SQLCODE'=0)  d
	.s id=0
	.f  s id=$O(^PAPERdr(PatientID,"ADM",Type,id)) q:(id="")||(SQLCODE'=0)  d
	..s ActiveFlag=$P(^PAADM(id),"^",20)
	..q:ActiveFlag="C"
	..s Date=$P(^PAADM(id),"^",6)
	..;q:Date<+$H  ;只是判断了日期,没有判断时间
	..i Date=..%SysDate() d
	...s CurAdmNum=CurAdmNum+1
	...;计算当天就诊未付费金额
	..e  i Date>+$H  d
	...s AAdmNum=AAdmNum+1
	s ApptNum=0
	s ResourceID=0
	f  s ResourceID=$O(^PAPERDR(PatientID,"RB_Appt","I",ResourceID)) q:(ResourceID="")||(SQLCODE'=0)  d
	.s ASSub=0
	.f  s ASSub=$O(^PAPERDR(PatientID,"RB_Appt","I",ResourceID,ASSub)) q:(ASSub="")||(SQLCODE'=0)  d
	..s ApptSub=0
	..f  s ApptSub=$O(^PAPERDR(PatientID,"RB_Appt","I",ResourceID,ASSub,ApptSub)) q:(ApptSub="")||(SQLCODE'=0)  d
	...s PAADM=$P(^RBAS(ResourceID,ASSub,"APPT",ApptSub),"^",4)
	...q:PAADM'=""  ;已经就诊的不再更新
	...s ApptNum=ApptNum+1
	s Str=""
	i CurAdmNum>0 d
	.s Str="当天已挂号数:"_CurAdmNum
	i AAdmNum>0 d
	.i Str="" d
	..s Str="预约已取号数:"_AAdmNum
	.e  d
	..s Str=Str_$C(13)_"预约已取号数:"_AAdmNum
	i ApptNum>0 d
	.i Str="" d
	..s Str="预约未取号数:"_ApptNum
	.e  d
	..s Str=Str_$C(13)_"预约未取号数:"_ApptNum
	q Str
}

ClassMethod CanUnite(OldRegNo, RegNo)
{
	s rtn=""
	;s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	;s OldRegNo=$e("0000000000000000000",1,myPatLen-$l(OldRegNo))_OldRegNo
	s OldPapmiID=$O(^PAPERi("PAPMI_PatNo",OldRegNo,0))
	q:OldPapmiID="" "被合并ID"_OldRegNo_"不存在"
	s OldIDLevel=..GetIDLevel(OldPapmiID)
	s PapmiID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:PapmiID="" "合并到ID"_RegNo_"不存在"
	s NewIDLevel=..GetIDLevel(PapmiID)
	i (OldIDLevel<NewIDLevel){
		q "合并到的ID:"_RegNo_"优先级低于被合并的ID:"_OldRegNo
	}
	s OldMedical=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",OldPapmiID,"I","") 
	s NewMedical=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",PapmiID,"I","") 
	i (OldMedical'="")&&(NewMedical'="")&&(NewMedical'=OldMedical){
		s Flag=##class(web.DHCDocHardCoded).GetUpdateInfoFlag()
		q:Flag=0 "病案号不相同,没有合并的权限"	
	}
	q rtn
}

ClassMethod QueryFeeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryFeeExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryFeeExecute(ByRef QHandle As %Binary, RegNo As %String, Days As %String, AdmRecorder As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Days="" s Days=3
 	s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	s RegNo=$e("0000000000000000000",1,myPatLen-$l(RegNo))_RegNo
	s PatientID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	if PatientID'="" {
	s Type=""
	f  s Type=$O(^PAPERdr(PatientID,"ADM",Type)) q:(Type="")  d
	.q:Type="H"
	.s id=""
	.f  s id=$O(^PAPERdr(PatientID,"ADM",Type,id),-1) q:(id="")  d
	..s ActiveFlag=$P(^PAADM(id),"^",20)
	..q:ActiveFlag="C"
	..s Date=$P(^PAADM(id),"^",6)
	..//q:Date>$H  ;大于当前时间退出  肯定没有未付费记录
	..q:$zabs((+$H)-Date)>Days
	..s Date=..%ZD(Date)
	..s LocID=$P(^PAADM(id),"^",4)
	..i LocID'="" s LocID=$P(^CTLOC(LocID),"^",2)
	..s DocID=$P(^PAADM(id),"^",9)
	..i DocID'="" s DocID=$P(^CTPCP(DocID,1),"^",2)
	..i AdmRecorder'="" d
	...s Arcimdesc="",Amount="",ODate=""
	...Do OutputRow
	..q:AdmRecorder'=""
	..s MRAdm=$P(^PAADM(id),"^",61)
	..q:$O(^MR(MRAdm,"DIA",0))=""  ;没有诊断肯定没有未付费记录
	..s Order=$O(^OEORD(0,"Adm",id,0))
	..q:Order=""
	..s EpissubtypeId=$P($g(^PAADM(id,1)),"^",6)
	..s AdmReasonId=$P($g(^PAADM(id,1)),"^",7)
	..s PAADMRegConDisDR=$P($G(^PAADM(id,"DHC")),"^",25)
	..s Sub=0
	..f  s Sub=$O(^OEORD(Order,"I",Sub)) q:Sub=""  d
	...s Stat=$P($g(^OEORD(Order,"I",Sub,1)),"^",13)
	...q:(Stat'=1)&&(Stat'=6)
	...s Paied=$P(^OEORD(Order,"I",Sub,3),"^",5)
	...q:Paied="P"
	...s OEItemID=Order_"||"_Sub

	...s Arcim=$P(^OEORD(Order,"I",Sub,1),"^",2)
	...s Arcimdesc=$P($G(^ARCIM(+Arcim,1,1)),"^",2)
	
	...s arctpdr=$p(^ARCIM($p(Arcim,"||",1),$p(Arcim,"||",2),1),"^",10)
	...s arctype=$p(^ARC("IC",arctpdr),"^",7)
	...s OrderPackQty=$P(^OEORD(Order,"I",Sub,9),"^",4)
	...i arctype'="R" d
	....s pqty=0,pbrowid=0
	....f  s pbrowid=$o(^DHCPBi(0,"OEORI",OEItemID,pbrowid)) q:pbrowid=""  d
	.....q:$d(^DHCPB(pbrowid))=10 ;add hujunbin 15.2.5
    .....q:$d(^DHCPB(pbrowid))=0 ;add hujunbin 15.2.5
    .....s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
    .....s pb=pbrowid  ;+2015-3-19 hujunbin 底下获取账单的时候+pb就等于0了
    .....s pbosub=0
    .....f  s pbosub=$o(^DHCPBi(0,"OEORI",OEItemID,pbrowid,pbosub)) q:pbosub=""  d
    ......q:$d(^DHCPB(pbrowid,"O",pbosub))=10
    ......s pbo=^DHCPB(pbrowid,"O",pbosub)
    ......s pbbillqty=$p(pbo,"^",5)
    ......s pbrefundqty=$p(pbo,"^",6)
    ......s pqty=pqty+pbbillqty+pbrefundqty
	....i +pqty'=0 s OrderPackQty=pqty
	....e  s OrderPackQty=$p(^OEORD(Order,"I",Sub,1),"^",12)

    ...s ProtocolPackUOMDR=$p($g(^OEORD(Order,"I",Sub,"DHC")),"^",13)	
	...s OEORIPrice=$P(^OEORD(Order,"I",Sub,3),"^",25) 
	...s ReLocID=$p($g(^OEORD(Order,"I",Sub,3)),"^",6)
	...i OrderPackQty'="" d
	....i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	....;包含基础单位和整包装代为的价格转换
	....s ExpStr=Order_"||"_Sub_"^^"_id_"^"_ReLocID
	....s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,Arcim , $H, "", "","", OEORIPrice,"",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	...else  d
	....;只是基本单位的价格
	....s ExpStr=PAADMRegConDisDR_"^"_Order_"||"_Sub_"^^"_id_"^"_ReLocID
	....s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,Arcim , $H, "", "","", OEORIPrice,"",ExpStr)
	....s ArcPrice=$j($p(ArcPrice,"^",1),3,2)
	
	
	...s Amount=$fn($P(ArcPrice,"^",1),"",2)
	...//s Amount=$P($G(^OEORD(Order,"I",Sub,2)),"^",13)
	...s ODate=$P($G(^OEORD(Order,"I",Sub,3)),"^",7)
	...s:ODate'="" ODate=..%ZD(ODate)
 	...Do OutputRow
	}
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutputRow
	set Data=$lb(Date,LocID,DocID,Arcimdesc,ODate,Amount)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod QueryFeeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFeeExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 19062535
/// d ##class(%ResultSet).RunQuery("web.DHCPATCardUnite", "QueryFee","19062584","58")
Query QueryFee(RegNo As %String, Days As %String, AdmRecorder As %String = "") As %Query(ROWSPEC = "Date:%String,LocID:%String,DocID:%String,Arcim:%String,ODate:%String,Amount:%String") [ SqlProc ]
{
}

// w ##class(web.DHCPATCardUnite).GetIDLevel(3610732)

// 3610732 5362072

ClassMethod GetIDLevel(PatientID)
{
	s IDJob=$J
	k ^TempGetIDLevel(IDJob,PatientID)
	s MaxLevel=4
	s CurCardType=""
	f  s CurCardType=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientID,CurCardType)) 	q:(CurCardType="")  d
	.s CardID=0
	.f  s CardID=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientID,CurCardType,CardID)) 	q:(CardID="")  d
	..s Status=$P(^DHCCARD("CF",CardID),"^",10)
	..;s Status="D"
	..q:(Status'="N")&&(Status'="S")&&(Status'="UA")
	..s CardTypeCode=$P(^DHCCARDTYPEDef(CurCardType),"^",1)
	..set myIDLevel=##Class(DHCExternalService.CardInterface.GetRelate).GetIDLevelFromCardTypeCode(CardTypeCode)
	..set ^TempGetIDLevel(IDJob,PatientID,myIDLevel)=0
	..b ;
	//s Medicare=$P(^PAPER(PatientID,"PAT",1),"^",22) ;有病历号
	//s:Medicare'="" ^TempGetIDLevel(IDJob,PatientID,3)=0 
	s ^TempGetIDLevel(IDJob,PatientID,MaxLevel)=0 ;所有
	s IDLevel=$O(^TempGetIDLevel(IDJob,PatientID,""))
	k ^TempGetIDLevel(IDJob,PatientID)
	q IDLevel
}

/// 2012.12.5
/// 卡合并后 历史就诊记录查询
/// d ##class(%ResultSet).RunQuery("web.DHCPATCardUnite", "OldPatientIDSearch","19062584","58")
Query OldPatientIDSearch(CardNo As %String = "", PatientNo As %String = "") As %Query(ROWSPEC = "AdmDate:%String,AdmTime:%String,AdmDoc:%String,AdmReason:%String,AdmType:%String,PAAdmWard:%String,PAAdmBed:%String,AdmDept:%String,PatientID:%String,EpisodeID:%String,AdmDischgDate:%String,MRDiagnoseDesc:%String")
{
}

ClassMethod OldPatientIDSearchClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = OldPatientIDSearchExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPATCardUnite","OldPatientIDSearch","2153864365","")

ClassMethod OldPatientIDSearchExecute(ByRef QHandle As %Binary, CardNo As %String = "", PatientNo As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	s ind=1
  
    
 	Set QHandle=$lb(0,repid,0) 	
 	s CFRowID=0
 	s FindPatPapmi=0
 	s checkResult=0
 	s NewID=""
 	s UniteID=0
 	s ^test=CardNo_","_PatientNo
 	s CardNo=$Replace(CardNo," ","")
 	s PatientNo=$Replace(PatientNo," ",PatientNo)
 	i CardNo'="" {
 	  for  s CFRowID=$O(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowID)) q:CFRowID=""  d
 	  .s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
	  .q:ActiveFlag'="N"
	  .s NewID=" "_$p(^DHCCARD("CF",CFRowID),"^",4)
	  .s CFPAPMINo=$p(^DHCCARD("CF",CFRowID),"^",6)
	  .d:NewID'="" FindAdmMessage
 	}
 	i (PatientNo'=""){
	 		s:$d(^PAPERi("PAPMI_PatNo",PatientNo)) NewID=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
	 		.d:NewID'="" FindAdmMessage
	 		
 	}
 	 Quit $$$OK
FindAdmMessage
  /*
   for  set FindPatPapmi=$O(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID,FindPatPapmi)) q:FindPatPapmi=""  d
    .i CFRowID'=0 d
	..for  set UniteID=$O(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID,FindPatPapmi,"DHCCARDREF",UniteID)) q:UniteID=""  d
	...set CardID=$LISTGet(^User.DHCPATCardUniteLogD(UniteID),10)
	...set CUOtherInfo=$LISTGet(^User.DHCPATCardUniteLogD(UniteID),19)
	...q:CUOtherInfo="N"
	...set:CardID=CFRowID checkResult=1
	.q:(CFRowID'=0)&&(checkResult=0)
	.b ;FindPatPapmi
	.set FindPatientID=$Replace(FindPatPapmi," ","")
	.s AdmType="" f  s AdmType=$o(^PAPERdr(FindPatientID,"ADM",AdmType)) q:AdmType=""  d
	..//s FindPatientID=$$ALPHAUP^SSUTIL4(FindPatientID)
    ..s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(FindPatientID,"ADM",AdmType,PaadmRowid)) q:PaadmRowid=""  d
    ...s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    ...s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
    ...if FindPatientID'=PAPMI q
    ...s PatientID=PAPMI
    ...s EpisodeID=PaadmRowid
    ...do PatAdmInfo
    ...do OutPutRow
    */

    while $d(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID))'=0
    {
	  set FindPatPapmi=""
	  b ;1
	  //set FindPatPapmi=$O(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID,FindPatPapmi))
	  for  set FindPatPapmi=$O(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID,FindPatPapmi)) q:FindPatPapmi=""  d
	  .q:FindPatPapmi="" 
	  .set FindPatientID=$Replace(FindPatPapmi," ","")
	  .s AdmType="" 
	  .f  s AdmType=$o(^PAPERdr(FindPatientID,"ADM",AdmType)) q:AdmType=""  d
  	  ..s PaadmRowid=0 
  	  ..f  s PaadmRowid=$o(^PAPERdr(FindPatientID,"ADM",AdmType,PaadmRowid)) q:PaadmRowid=""  d 
   	  ...s PatientID=FindPatientID
   	  ...s EpisodeID=PaadmRowid
   	  ...do PatAdmInfo
   	  ...do OutPutRow
   	
      set FindPatPapmi=""
	  set FindPatPapmi=$O(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID,FindPatPapmi))
	  set NewID=FindPatPapmi
	  b ;3
	  q:NewID=""
    }
   
  
    
   quit
PatAdmInfo
 	s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
    s AdmDate=$zd(AdmDate,3)
    s AdmTime=$p($g(^PAADM(PaadmRowid)),"^",7)
    s AdmTime=..%ZT(AdmTime,2)
    s AdmReason=$p($g(^PAADM(PaadmRowid,1)),"^",7)
    s AdmReason=$p(^PAC("ADMREA",AdmReason),"^",2)
	s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
 	s AdmDept=$p($p($g(^CTLOC(Admdepcode)),"^",2),"-",2)
 	s admdocdr=$p($g(^PAADM(PaadmRowid)),"^",9) 
 	s CreateUserDr=$p($g(^PAADM(PaadmRowid)),"^",43)
    s AdmDischgDate=$p($g(^PAADM(PaadmRowid)),"^",17) //出院日期
 	i AdmDischgDate'="" s AdmDischgDate=$zd(AdmDischgDate,3)
 	s Comm=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
 	Set Ward=$P($g(^PAADM(PaadmRowid)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	Set Bed=$P($g(^PAADM(PaadmRowid)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
 	i admdocdr="" {s AdmDoc=""   }
 	else {  s AdmDoc=$p($g(^CTPCP(admdocdr,1)),"^",2)
 
 	}
 	s MRAdmRowid=$p($g(^PAADM(PaadmRowid)),"^",61)
 
 	s MRDiagnoseDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmRowid,"^")
 	s MRDLength=$Length(MRDiagnoseDesc,"^")
 	s MRDiagnoseDesc=$P(MRDiagnoseDesc,"^",MRDLength)
	quit
	
OutPutRow
	set Data=$lb(AdmDate,AdmTime,AdmDoc,AdmReason,AdmType,PAAdmWard,PAAdmBed,AdmDept,PatientID,EpisodeID,AdmDischgDate,MRDiagnoseDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OldPatientIDSearchFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFeeExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

// 检查是否被合并过

// w ##class(web.DHCPATCardUnite).CheckIfUnite("2153864365")

ClassMethod CheckIfUnite(CardNo As %String = "", PatientNo As %String = "")
{
	
	q:((CardNo'="")&&('$d(^DHCCARDi("CF",0,"CardNo",CardNo)))) 0
	
	s checkResult=0,CFRowID="",OldID="",UniteID=""
	i CardNo'="" {
 	  for  s CFRowID=$O(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowID)) q:CFRowID=""  d
 	  .s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
	  .q:ActiveFlag'="N"
	  .s NewID=" "_$p(^DHCCARD("CF",CFRowID),"^",4)
	  .s CFPAPMINo=$p(^DHCCARD("CF",CFRowID),"^",6)
	  .b ;1
	  .i $d(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID))=10 d
	  ..b ;3
	  ..for  set OldID=$O(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",NewID,OldID)) q:OldID=""  d
	  ...set:OldID'="" checkResult=1
	  .i $d(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1",NewID))=10 d
	  ..for  set OldID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1",NewID,OldID)) q:OldID=""  d
	  ...set:OldID'="" checkResult=1
 	}
 	if PatientNo'=""{	 	 
	 	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
	 	s checkResult=$d(^User.DHCPATCardUniteLogI("NewOldPAPMI"," 1",PatientID))
 	}
 	q checkResult
}

/// 根据卡描述获取卡类型
ClassMethod ReadCardTypeByDesc(Desc)
{
	s Desc=$P(Desc,$C(1),1)
	s Desc=$P(Desc," ",1)
	s myTypeID=0 s myval="" 
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:((myTypeID="")||(myval'=""))  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.Q:Desc'=mydes
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	q myval
}

/// creater lxz
/// desc 获取患者其他证件信息
/// input PAPMIDr 患者ID
/// OutPut w ##class(web.DHCPATCardUnite).GetOtherCardInfo(83)
ClassMethod GetOtherCardInfo(PAPMIDr)
{
	Q:PAPMIDr="" ""
	s CardStr=""
	s CardType=0 
	f  s CardType=$O(^DHCPCNi("PAPMI",PAPMIDr,CardType)) Q:CardType=""  d
	.s RowID=0
	.s CardNOStr=""
	.f  s RowID=$O(^DHCPCNi("PAPMI",PAPMIDr,CardType,RowID)) Q:RowID=""  d
	..s CardNO=$P($G(^DHCPCN(RowID)),"^",4)
	..i CardNOStr=""  s CardNOStr=CardNO
	..e  s CardNOStr=CardNOStr_","_CardNO
	.i CardStr="" s CardStr=CardType_"^"_CardNOStr
	.e  s CardStr=CardStr_"!"_CardType_"^"_CardNOStr
	q CardStr
}

/// 获取存在相同姓名、性别、出生日期、联系电话的患者id
/// w ##class(web.DHCPATCardUnite).GetPatByInfo("","病历测试",2,"01/01/1990","13509081425",2)
ClassMethod GetPatByInfo(CardType, Name, Sex, Birth, Tel, PAPMIRowID)
{
	s ^tempscl("GetPatByInfo")=CardType_","_Name_","_Sex_","_Birth_","_Tel_","_PAPMIRowID
	s CardActive="0",CardNo=""
	if (CardType'=""){
		q:(CardType="")!(Name="")!(Sex="")!(Birth="")!(Tel="") "0"
		d CheckRepeat(CardType)
	}else{
		q:(PAPMIRowID="")&&(Name="")!(Sex="")!(Birth="")!(Tel="") "0"
		s CardTypeStr=""
		s CardTypeRowid=0
		f  s CardTypeRowid=$o(^DHCCARDi("CF",0,"PAPMICTDR",PAPMIRowID,CardTypeRowid)) q:(CardTypeRowid="")  d
		.s CFRowId=0	
		.f  s CFRowId=$o(^DHCCARDi("CF",0,"PAPMICTDR",PAPMIRowID,CardTypeRowid,CFRowId)) q:(CFRowId="")  d
		..s CardActive=$p(^DHCCARD("CF",CFRowId),"^",10)
		..q:(CardActive'="N") 
		..i CardTypeStr="" s CardTypeStr=CardTypeRowid
		..e  s CardTypeStr=CardTypeStr_"^"_CardTypeRowid
		Q:CardTypeStr="" "0"
		for i=1:1:$l(CardTypeStr,"^") {
			s CardActive="0"
			s CardType=$p(CardTypeStr,"^",i)
			d CheckRepeat(CardType)
			Q:CardActive'=0  
		}
	}
	q CardActive_"^"_CardNo
CheckRepeat(CardType)
	s PatId=0 f  s PatId=$o(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(Name),PatId)) q:(PatId="")||(CardActive="N")||(CardActive="S")  d  //!(" N S "[CardActive)  d
	.q:(PatId=PAPMIRowID)&&(PAPMIRowID'="")
	.s PatSex=$p(^PAPER(PatId,"ALL"),"^",7)
	.q:PatSex'=Sex
	.s PatBirth=$p(^PAPER(PatId,"ALL"),"^",6)
	.q:PatBirth'=..%ZDH(Birth)
	.s PatTel=$p(^PAPER(PatId,"PER",1),"^",11)
	.q:PatTel'=Tel
	.s CFRowId=0
	.f  s CFRowId=$o(^DHCCARDi("CF",0,"PAPMICTDR",PatId,CardType,CFRowId)) q:(CFRowId="")||(CardActive="N")||(CardActive="S")  d
	..s CardActive=$p(^DHCCARD("CF",CFRowId),"^",10)
	..s CardNo=$p(^DHCCARD("CF",CFRowId),"^",2)
	q
}

ClassMethod GetPatInfoByPatientID(papmiID, inforType)
{
	s ^tempqujian("GetPatInfoByPatientID")=papmiID_","_inforType
	s rtn=""
	q:papmiID="" ""
	;q:##class(web.DHCPATCardUnite).PatMasActive(papmiID)="N" rtn
	s Name=$P(^PAPER(papmiID,"ALL"),"^",1)
	s Sex=$P(^PAPER(papmiID,"ALL"),"^",7)
	i Sex'="" s Sex=$P(^CT("SEX",Sex),"^",2)
	s Dob=$P(^PAPER(papmiID,"ALL"),"^",6)
	i Dob'="" s Dob=..%ZD(Dob) //$ZD(Dob,3)
	s ID=$P(^PAPER(papmiID,"PAT",3),"^",6)
	s MedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmiID,"I",$g(%session.Data("LOGON.HOSPID")))
	s PatType="",PatCode=""
	s PatType=$P(^PAPER(papmiID,"PER",1),"^",10)
	s:PatType'="" PatType=PatType_";"_$P(^CT("SS",PatType),"^",2)
	s AccMID=..GetAccMID(papmiID)
	s Amount=""
	s:AccMID'="" Amount=$P(^DHCACD("AccM",AccMID),"^",8)
	s:Amount'="" Amount=+Amount
	s YBCode=$p($g(^PAPER(papmiID,"PAT",3)),"^",12) //$P(^PAPER(papmiID,"ALL"),"^",19)
	s AdmInfo=..GetAdmInfo(papmiID)
	//Add
	s CredType=$p($g(^PAPER(papmiID,"PAT",3)),"^",7)
	s:CredType'="" CredType=CredType_";"_$P(^PAC("CARD",CredType),"^",2)
	s Marital=$p($g(^PAPER(papmiID,"PER",2)),"^",3)
	s:Marital'="" Marital=Marital_";"_$P(^CT("MAR",Marital),"^",2)
	s Tel=$p($g(^PAPER(papmiID,"PER",1)),"^",11)
	s Mobile=$p($g(^PAPER(papmiID,"PER",4)),"^",21)
	s MedicalUnionNo=$p($g(^PAPER(papmiID,"PAT",3)),"^",12)
	s Country=$p($g(^PAPER(papmiID,"PER",1)),"^",8)
	b ;1
	s:Country'="" Country=Country_";"_$P(^CT("COU",Country),"^",2)
	b ;2
	s Nation=$p($g(^PAPER(papmiID,"PER",2)),"^",1)
	s:Nation'="" Nation=Nation_";"_$P(^CT("NAT",Nation),"^",2)
	s ProvinceHome=$p($g(^PAPER(papmiID,"PER",2)),"^",11)
	s:ProvinceHome'="" ProvinceHome=ProvinceHome_";"_$P(^CT("PROV",ProvinceHome),"^",2)
	s CityHome=$p($g(^PAPER(papmiID,"ALL")),"^",18)
	s:CityHome'="" CityHome=CityHome_";"_$P(^CT("CIT",CityHome),"^",2)
	s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",papmiID,0))
	i DHCPersonID'="" d
	.s ProvinceBirth=$P(^DHCPERSON(DHCPersonID),"^",13)
	.s:ProvinceBirth'="" ProvinceBirth=ProvinceBirth_";"_$P(^CT("PROV",ProvinceBirth),"^",2)
	.s CityBirth=$P(^DHCPERSON(DHCPersonID),"^",14)
	.s:CityBirth'="" CityBirth=CityBirth_";"_$P(^CT("CIT",CityBirth),"^",2)
	.s AreaBirth=$P(^DHCPERSON(DHCPersonID),"^",15)
	.s:AreaBirth'="" AreaBirth=AreaBirth_";"_$P(^CT("CITAREA",AreaBirth),"^",2)
	.s CompanyPostCode=$P(^DHCPERSON(DHCPersonID),"^",7)
	.s ProvinceHouse=$P(^DHCPERSON(DHCPersonID),"^",17)
	.s:ProvinceHouse'="" ProvinceHouse=ProvinceHouse_";"_$P(^CT("PROV",ProvinceHouse),"^",2)
	.s Cityhouse=$P(^DHCPERSON(DHCPersonID),"^",18)
	.s:Cityhouse'="" Cityhouse=Cityhouse_";"_$P(^CT("CIT",Cityhouse),"^",2)
	.s AreaHouse=$P(^DHCPERSON(DHCPersonID),"^",19)
	.s:AreaHouse'="" AreaHouse=AreaHouse_";"_$P(^CT("CITAREA",AreaHouse),"^",2)
	.s PostCodeHouse=$P(^DHCPERSON(DHCPersonID),"^",9)
	.s Zip=$P(^DHCPERSON(DHCPersonID),"^",8)
	.s RegisterPlace=$P(^DHCPERSON(DHCPersonID),"^",20)
	.s BirthPlace=$P(^DHCPERSON(DHCPersonID),"^",16)
	e  d
	.s (ProvinceBirth,CityBirth,AreaBirth,CompanyPostCode,ProvinceHouse,Cityhouse,AreaHouse,PostCodeHouse,Zip,RegisterPlace,BirthPlace)=""
	s Province=$p($g(^PAPER(papmiID,"PER",4)),"^",2)
	s:Province'="" Province=Province_";"_$P(^CT("PROV",Province),"^",2)
	s City=$p($g(^PAPER(papmiID,"PER",1)),"^",5)
	s:City'="" City=City_";"_$P(^CT("CIT",City),"^",2)
	s Area=$p($g(^PAPER(papmiID,"PER",4)),"^",9)
	s:Area'="" Area=Area_";"_$P(^CT("CITAREA",Area),"^",2)
	s Address=$p($g(^PAPER(papmiID,"PER","ADD",1)),"^",1)
	//s Zip=$p($g(^PAPER(papmiID,"PER",1)),"^",7)
	//s:Zip'="" Zip=Zip_";"_$P(^CT("ZIP",Zip),"^",2)
	s Vocation=$p($g(^PAPER(papmiID,"PER",2)),"^",6)
	s:Vocation'="" Vocation=Vocation_";"_$P(^CT("OCC",Vocation),"^",2)
	s Company=$p($g(^PAPER(papmiID,"PER",4)),"^",18)
	s OfficeTel=$p($g(^PAPER(papmiID,"PER",1)),"^",9)
	//s CompanyPostCode
	//s ProvinceHouse
	//s Cityhouse
	//s AreaHouse
	//s PostCodeHouse
	s ForeignName=$p($g(^PAPER(papmiID,"PER",2)),"^",13)
	s Relation=$p($g(^PAPER(papmiID,"EMP")),"^",4)
	s:Relation'="" Relation=Relation_";"_$P(^CT("RLT",Relation),"^",2)
	s ForeignAddress=$p($g(^PAPER(papmiID,"PER",1)),"^",1)
	s ForeignPhone=$p($g(^PAPER(papmiID,"ALL")),"^",4)
	s ForeignIDCard=$p($g(^PAPER(papmiID,"PER",2)),"^",4)
	s EmployeeFunction=$p($g(^PAPER(papmiID,"PER",3)),"^",3)
	s:EmployeeFunction'="" EmployeeFunction=EmployeeFunction_";"_$P($g(^CT("EMF",EmployeeFunction)),"^",2)
	s PAPMISecretLevel=$p($g(^PAPER(papmiID,"DHC")),"^",30)
	s:PAPMISecretLevel'="" PAPMISecretLevel=PAPMISecretLevel_";"_$List(^User.DHCSecretLevelD(PAPMISecretLevel),3)
	//联系人证件类型
	s ForeignCredType=$p($g(^PAPER(papmiID,"ALL")),"^",25)
	s:ForeignCredType'="" ForeignCredType=ForeignCredType_";"_$P(^PAC("CARD",ForeignCredType),"^",2)
	s StreetBirth=$p($g(^PAPER(papmiID,"DHC")),"^",52)
	s:StreetBirth'="" StreetBirth=StreetBirth_";"_$p(^CT("LOCTYPE",StreetBirth),"^",2)
	s StreetHouse=$p($g(^PAPER(papmiID,"DHC")),"^",53)
	s:StreetHouse'="" StreetHouse=StreetHouse_";"_$p(^CT("LOCTYPE",StreetHouse),"^",2)
	s StreetNow=$p($g(^PAPER(papmiID,"DHC")),"^",54)
	s:StreetNow'="" StreetNow=StreetNow_";"_$p(^CT("LOCTYPE",StreetNow),"^",2)
	s AreaHome=$p($g(^PAPER(papmiID,"PER",6)),"^",41)
	s:AreaHome'="" AreaHome=AreaHome_";"_$P(^CT("CITAREA",AreaHome),"^",2)
	
	b ;0093 
	if (inforType="Old"){
		s rtn="[{ PatientID:'"_papmiID_"',CardType: '"_""_"',Name:'"_Name_"',OldCardNo:'"_""_"',Sex:'"_Sex_"',OldBirthDay:'"_Dob
		s rtn=rtn_"',OldMarital:'"_Marital_"',OldTel:'"_Tel_"',OldMobile:'"_Mobile_"',OldMedicalUnionNo:'"_MedicalUnionNo
		s rtn=rtn_"',OldCredType:'"_CredType_"',OldIDCard:'"_ID_"',OldAmount:'"_Amount_"',OldYBCode:'"_YBCode
		s rtn=rtn_"',OldMedicalNo:'"_MedicalNo_"',OldPatType:'"_PatType_"',OldCountry:'"_Country_"',OldNation:'"_Nation
		s rtn=rtn_"',OldProvinceHome:'"_ProvinceHome_"',OldCityHome:'"_CityHome_"',OldProvinceBirth:'"_ProvinceBirth
		s rtn=rtn_"',OldCityBirth:'"_CityBirth_"',OldAreaBirth:'"_AreaBirth_"',OldProvince:'"_Province
		s rtn= rtn_"',OldCity:'"_City_"',OldArea:'"_Area_"',OldAddress:'"_Address_"',OldZip:'"_Zip
		s rtn=rtn_"',OldVocation:'"_Vocation_"',OldCompany:'"_Company_"',OldOfficeTel:'"_OfficeTel_"',OldCompanyPostCode:'"_CompanyPostCode
		s rtn=rtn_"',OldProvinceHouse:'"_ProvinceHouse_"',OldCityhouse:'"_Cityhouse_"',OldAreaHouse:'"_AreaHouse
		s rtn=rtn_"',OldPostCodeHouse:'"_PostCodeHouse_"',OldForeignName:'"_ForeignName_"',OldRelation:'"_Relation
		s rtn=rtn_"',OldForeignAddres:'"_ForeignAddress_"',OldForeignPhone:'"_ForeignPhone_"',OldForeignIDCard:'"_ForeignIDCard
		s rtn=rtn_"',OldForeignCredType:'"_ForeignCredType
		s rtn=rtn_"',OldStreetBirth:'"_StreetBirth
		s rtn=rtn_"',OldStreetHouse:'"_StreetHouse
		s rtn=rtn_"',OldStreetNow:'"_StreetNow
		s rtn=rtn_"',OldAreaHome:'"_AreaHome
		s rtn=rtn_"',OldRegisterPlace:'"_RegisterPlace
		s rtn=rtn_"',OldAddressBirth:'"_BirthPlace
		
		s rtn=rtn_"',OldPoliticalLevel:'"_EmployeeFunction_"',OldSecretLevel:'"_PAPMISecretLevel_"'}]"
	}else{
		s rtn="[{ PatientID:'"_papmiID_"',NewCardType: '"_""_"',NewName:'"_Name_"',NewCardNo:'"_""_"',NewSex:'"_Sex_"',NewBirthDay:'"_Dob
		s rtn=rtn_"',NewMarital:'"_Marital_"',NewTel:'"_Tel_"',NewMobile:'"_Mobile_"',NewMedicalUnionNo:'"_MedicalUnionNo
		s rtn=rtn_"',NewCredType:'"_CredType_"',NewIDCard:'"_ID_"',NewAmount:'"_Amount_"',NewYBCode:'"_YBCode
		s rtn=rtn_"',NewMedicalNo:'"_MedicalNo_"',NewPatType:'"_PatType_"',NewCountry:'"_Country_"',NewNation:'"_Nation
		s rtn=rtn_"',NewProvinceHome:'"_ProvinceHome_"',NewCityHome:'"_CityHome_"',NewProvinceBirth:'"_ProvinceBirth
		s rtn=rtn_"',NewCityBirth:'"_CityBirth_"',NewAreaBirth:'"_AreaBirth_"',NewProvince:'"_Province
		s rtn= rtn_"',NewCity:'"_City_"',NewArea:'"_Area_"',NewAddress:'"_Address_"',NewZip:'"_Zip
		s rtn=rtn_"',NewVocation:'"_Vocation_"',NewCompany:'"_Company_"',NewOfficeTel:'"_OfficeTel_"',NewCompanyPostCode:'"_CompanyPostCode
		s rtn=rtn_"',NewProvinceHouse:'"_ProvinceHouse_"',NewCityhouse:'"_Cityhouse_"',NewAreaHouse:'"_AreaHouse
		s rtn=rtn_"',NewPostCodeHouse:'"_PostCodeHouse_"',NewForeignName:'"_ForeignName_"',NewRelation:'"_Relation
		s rtn=rtn_"',NewForeignAddres:'"_ForeignAddress_"',NewForeignPhone:'"_ForeignPhone_"',NewForeignIDCard:'"_ForeignIDCard
		s rtn=rtn_"',NewForeignCredType:'"_ForeignCredType
		s rtn=rtn_"',NewStreetBirth:'"_StreetBirth
		s rtn=rtn_"',NewStreetHouse:'"_StreetHouse
		s rtn=rtn_"',NewStreetNow:'"_StreetNow
		s rtn=rtn_"',NewAreaHome:'"_AreaHome
		
		s rtn=rtn_"',NewRegisterPlace:'"_RegisterPlace
		s rtn=rtn_"',NewAddressBirth:'"_BirthPlace
		s rtn=rtn_"',NewPoliticalLevel:'"_EmployeeFunction_"',NewSecretLevel:'"_PAPMISecretLevel_"'}]"
	}
	q rtn
}

/// do ##class(%ResultSet).RunQuery("web.DHCPATCardUnite","FindPatientCard")
ClassMethod FindPatientCardExecute(ByRef qHandle As %Binary, PatientStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s PatLength=$L(PatientStr,"^")
	for i=1:1:PatLength{
		s PatientID=$p(PatientStr,"^",i)
		s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
		s PatSex=$P(^PAPER(PatientID,"ALL"),"^",7)
		i PatSex'="" s PatSex=$P(^CT("SEX",PatSex),"^",2)
		s PatientNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
		
		s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""))
		if (cardRef="") {
			set Data=$lb("",PatientNo,"","",PatName,PatSex)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
		s cardRef=""
		f  {
			s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,cardRef)) 
			q:cardRef=""  
			s type=$P(^DHCCARD("CF",cardRef),"^",10)
			continue:type'="N"
			s CardNo=$P(^DHCCARD("CF",cardRef),"^",2)
			s CardType=$P(^DHCCARD("CF",cardRef),"^",16)
			continue:($p(^DHCCARD("CF",cardRef),"^",29)="Y")
			i CardType'="" s CardType=$P(^DHCCARDTYPEDef(CardType),"^",2)
			set Data=$lb(cardRef,PatientNo,CardType,CardNo,PatName,PatSex)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindPatientCardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientCardExecute ]
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

ClassMethod FindPatientCardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientCardExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindPatientCard(PatientStr As %String) As %Query(ROWSPEC = "CardRowid:%String,PatientNo:%String,CardType:%String,CardNo:%String,PatName:%String,PatSex:%String")
{
}

// 合并卡信息

ClassMethod CardUniteNew(OldPapmiIDStr, PapmiID, SelectCard, OtherInfo As %String = "", LogonHospDR As %String = "", UnitReason As %String = "", CurUserID As %String = "", ComputerIP As %String = "")
{
	
	n (OldPapmiIDStr, PapmiID, SelectCard,CurUserID,OtherInfo,LogonHospDR,UnitReason,ComputerIP,%session)
	if (%session){
		s CurUserID=%session.Get("LOGON.USERID")
	}
	s ^tempscl("CardUniteNew")=OldPapmiIDStr_","_PapmiID_","_SelectCard_","_OtherInfo_","_LogonHospDR
	//q 0
	s $ZT="UniteErrNew"
	s NewIDLevel=..GetIDLevel(PapmiID)
	s OldPapmiLe=$l(OldPapmiIDStr,"^")
	/*s flag=""
	for i=1:1:OldPapmiLe{
		s OldPapmiID=$P(OldPapmiIDStr,"^")
		continue:OldPapmiID=""
		continue:OldPapmiID=PapmiID
		s OldIDLevel=..GetIDLevel(OldPapmiID)
		s OldRegNo=$P(^PAPER(OldPapmiID,"PAT",1),"^",1)
		i (OldIDLevel<NewIDLevel){
			if flag="" set flag=OldRegNo_"更新到的ID优先级低于被合并的"
			else  set flag=flag_","_OldRegNo_"更新到的ID优先级低于被合并的"
		}
		;住院病人未财务结算不能合并,留观病人,不能合并
		s CheckInfo=..CheckCardUnite(OldRegNo)
		if ($p(CheckInfo,"^",1)=1){
			if flag="" set flag= $p(CheckInfo,"^",2)
			else  set flag=flag_","_$p(CheckInfo,"^",2)
		}
		}
	*/
	s SelectCard="^"_SelectCard_"^"
	s SQLCODE=0
	s Date=..%SysDate()
	s Time=..%SysTime()
	s RegNo=$P(^PAPER(PapmiID,"PAT",1),"^",1)
	TSTART
	//更新合并到的登记号对应的卡信息
	s flag=""
	for i=1:1:OldPapmiLe{
		s OldPapmiID=$P(OldPapmiIDStr,"^",i)
		continue:OldPapmiID=""
		continue:OldPapmiID=PapmiID
		s OldIDLevel=..GetIDLevel(OldPapmiID)
		s OldRegNo=$P(^PAPER(OldPapmiID,"PAT",1),"^",1)
		i OtherInfo'=""{
			s OldOtherInfo=..GetOldOtherInfo(PapmiID)
			s SQLCODE=..UpdateOtherInfo(OtherInfo,PapmiID)
			i SQLCODE'=0{
				TROLLBACK
				s flag="更新合并到的登记号对应的病人信息错误1"
				q 
			}
			s OtherInfo=OldOtherInfo
			s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAPerson",OldPapmiID,PapmiID,PapmiID,OtherInfo,CurUserID,UnitReason)
			i SQLCODE'=0{
				TROLLBACK
				s flag="更新合并到的登记号对应的病人信息错误4"_SQLCODE
				q 
			}
		}
		s cardRef=0
		f  s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",PapmiID,cardRef)) q:(cardRef="")||(SQLCODE'=0)  d
		.s type=$P(^DHCCARD("CF",cardRef),"^",10)
		.q:type'="N"
		.i SelectCard'[("^"_cardRef_"^") d
		..&SQL(Update DHC_CardRef set CF_ActiveFlag='R' where CF_RowID=:cardRef)
		..q:SQLCODE'=0
		..&SQL(insert into DHC_CardStatusChange (CSC_CF_ParRef,CSC_Date,CSC_Time,CSC_CurStatus,CSC_User_DR,CSC_Hosp_DR,CSC_ComputerIP) values (:cardRef,:Date,:Time,'R',:CurUserID,:LogonHospDR,:ComputerIP))
		..q:SQLCODE'=0
		..//插入日志、更新的不是PA_PatMas表ID更新其它信息
		..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCCardRefType",OldPapmiID,PapmiID,cardRef,type,CurUserID,UnitReason)
		i SQLCODE'=0{
			TROLLBACK
			s flag="更新合并到的登记号对应的卡信息错误"
			q 
		}
		//更新被合并登记号对应的卡
		s cardRef=0
		f  s cardRef=$O(^DHCCARDi("CF",0,"PAPMIDR",OldPapmiID,cardRef)) q:(cardRef="")||(SQLCODE'=0)  d
		.s type=$P(^DHCCARD("CF",cardRef),"^",10)
		.q:type'="N"
		.i SelectCard'[("^"_cardRef_"^") d
		..&SQL(Update DHC_CardRef set CF_ActiveFlag='R' where CF_RowID=:cardRef)
		..q:SQLCODE'=0
		..&SQL(insert into DHC_CardStatusChange (CSC_CF_ParRef,CSC_Date,CSC_Time,CSC_CurStatus,CSC_User_DR,CSC_Hosp_DR,CSC_ComputerIP) values (:cardRef,:Date,:Time,'R',:CurUserID,:LogonHospDR,:ComputerIP))
		..q:SQLCODE'=0
		..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCCardRefType",OldPapmiID,PapmiID,cardRef,type,CurUserID,UnitReason)
		.e  d
		..s NewAccMID=..GetAccMID(PapmiID)
		..s OldAccMID=$P(^DHCCARD("CF",cardRef),"^",1)  ;记录原账户信息
		..&SQL(Update DHC_CardRef set CF_PAPMI_DR=:PapmiID,CF_PAPMINo=:RegNo,CF_AccNo_DR=:NewAccMID where CF_RowID=:cardRef)
		..q:SQLCODE'=0
		..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("DHCCardRef",OldPapmiID,PapmiID,cardRef,OldAccMID,CurUserID,UnitReason)
		b ;DHCCardRef over
		i SQLCODE'=0{
			TROLLBACK
			s flag="更新被合并登记号对应的卡信息错误"
			q
		}
		//更新被合并登记号的病历号为空
		s OldMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(OldPapmiID,"",$g(%session.Data("LOGON.HOSPID")))
		&SQL(Update PA_PatMas set PAPMI_Active='N' where PAPMI_RowId=:OldPapmiID)
		i SQLCODE'=0{
			TROLLBACK
			s flag="更新被合并登记号对应的病历信息错误"
			q 
		}

		//插入日志、更新的不是PA_PatMas表ID更新其它信息
		s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAPatMas",OldPapmiID,PapmiID,OldPapmiID,OldMedicare,CurUserID,UnitReason)
		i SQLCODE'=0{
			TROLLBACK
			s flag="更新被合并登记号对应的病历信息错误"
			q 
		}
		//更新就诊以及预约记录  因为判断是否已就诊，预约记录分开更新了
		s err=..UniteAdmInfo(OldPapmiID,PapmiID,CurUserID)
		i err'=""{
			TROLLBACK
			s flag=err
			q 
		}

		//修改以后就诊信息的费别
		d ##class(DHCExternalService.CardInterface.CardManager).UpdateAdmedReason(PapmiID)

		//更新就诊信息
		s admType=""
		f  s admType=$O(^PAPERdr(OldPapmiID,"ADM",admType)) q:(admType="")||(SQLCODE'=0)  d
		.s admID=0
		.f  s admID=$O(^PAPERdr(OldPapmiID,"ADM",admType,admID)) q:(admID="")||(SQLCODE'=0)  d
		..&SQL(Update PA_Adm set PAADM_PAPMI_DR=:PapmiID where PAADM_RowID=:admID)
		..q:SQLCODE'=0
		..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAAdm",OldPapmiID,PapmiID,admID,"",CurUserID,UnitReason)
		i SQLCODE'=0{
			TROLLBACK
			s flag="合并就诊信息错误"
			q 
		}
		
		;更新住院证信息
		s ret=0
		s BookID=0 f {
			s BookID=$o(^DHCDocIPBK(0,"PatientID",OldPapmiID,BookID))
			q:BookID=""
			s BookDate=$p($g(^DHCDocIPBK(BookID)),"^",10)
			continue:BookDate<+$h
			&sql(update DHCDocIPBooking set PatientID=:PapmiID where RowID=:BookID)
			if SQLCODE=0 {
				s LogRet=##class(User.DHCPATCardUniteLog).InsertLog("DHCDocIPBooking",OldPapmiID,PapmiID,BookID,"",CurUserID,UnitReason)
				if LogRet'=0 s ret="-555"
			}else {
				s ret="-555"
			}
			q:ret'=0
		}
		i ret'=0{
			TROLLBACK
			s flag="合并住院证信息错误"
			q 
		}
	}
	/*liuxuefeng
	//更新体检产品组的信息
	s err=..UnitePEInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	
	//更新护士站信息
	s err=##class(web.DHCPAPregnancy).UnitePregInfo(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//医政组信息
	s SQLCODE=##class(DHCMed.Service).MergePatient(OldPapmiID,PapmiID,CurUserID)
	i +SQLCODE<0{
		TROLLBACK
		q "医政组更新错误"_SQLCODE
	}
	//统计组信息
	s err=$$UpPapmiOldToNew^DHCWLUPPapmi(OldPapmiID,PapmiID,CurUserID)
	i err'=""{
		TROLLBACK
		q err
	}
	//更新其它产品组信息
	liuxuefeng*/
	TCOMMIT
	q flag
UniteErrNew
	TROLLBACK
	q "程序非正常退出"_$ZERROR
}

ClassMethod CheckforCardUniteNew(OldPapmiIDStr, PapmiID)
{
	
	s NewIDLevel=..GetIDLevel(PapmiID)
	s OldPapmiLe=$l(OldPapmiIDStr,"^")
	s NewPatType=$P(^PAPER(PapmiID,"PER",1),"^",10)
	s NewMedical=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",PapmiID,"I","")
	s Name=$P(^PAPER(PapmiID,"ALL"),"^",1)
	s Sex=$P(^PAPER(PapmiID,"ALL"),"^",7)
	s Dob=$P(^PAPER(PapmiID,"ALL"),"^",6)
	s flag=""
	for i=1:1:OldPapmiLe{
		s OldPapmiID=$P(OldPapmiIDStr,"^",i)
		continue:OldPapmiID=""
		continue:OldPapmiID=PapmiID
		s OldIDLevel=..GetIDLevel(OldPapmiID)
		s OldRegNo=$P(^PAPER(OldPapmiID,"PAT",1),"^",1)
		i (OldIDLevel<NewIDLevel){
			if flag="" set flag=OldRegNo_"更新到的ID优先级低于被合并的"
			else  set flag=flag_","_OldRegNo_"更新到的ID优先级低于被合并的"
		}
		;住院病人未财务结算不能合并,留观病人,不能合并
		s CheckInfo=..CheckCardUnite(OldRegNo)
		if ($p(CheckInfo,"^",1)=1){
			if flag="" set flag= $p(CheckInfo,"^",2)
			else  set flag=flag_","_$p(CheckInfo,"^",2)
		}
		//病人类型
		s OldPatType=$P(^PAPER(OldPapmiID,"PER",1),"^",10)
		if (OldPatType'=NewPatType){
			if flag="" set flag= "病人类型不一致不能合并"
			else  set flag=flag_","_"病人类型不一致不能合并"
			}
		s OldMedical=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",OldPapmiID,"I","")
		i (OldMedical'="")&&(NewMedical'="")&&(NewMedical'=OldMedical){
			s Flag=##class(web.DHCDocHardCoded).GetUpdateInfoFlag()
			if Flag=0 set flag="病案号不相同,没有合并的权限"	
		}
		s OldName=$P(^PAPER(OldPapmiID,"ALL"),"^",1)
		if (OldName'=Name){
			set flag="姓名不同，不能合并"
		}
		s OldSex=$P(^PAPER(OldPapmiID,"ALL"),"^",7)
		if (OldSex'=Sex){
			set flag="性别不同，不能合并"
		}
		s OldDob=$P(^PAPER(OldPapmiID,"ALL"),"^",6)
		if (OldDob'=Dob){
			set flag="出生日期不同，不能合并"
		}
		q:flag'=""
	}
	q flag
}

ClassMethod QueryFeeNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryFeeNewExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryFeeNewExecute(ByRef QHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String, AdmRecorder As %String = "", HospId As %String = "", Code As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
 	if StartDate'="" s StartDate=..%ZDH(StartDate)
 	if EndDate'="" s EndDate=..%ZDH(EndDate)
 	if StartDate="" s StartDate=..%SysDate()-180
 	if EndDate="" s EndDate=..%SysDate()
 	if PatientID'="" {
	 	if (Code=""){
			s Type=""
			f  s Type=$O(^PAPERdr(PatientID,"ADM",Type)) q:(Type="")  d
			.q:Type="H"
			.s id=""
			.f  s id=$O(^PAPERdr(PatientID,"ADM",Type,id),-1) q:(id="")  d
			..s ActiveFlag=$P(^PAADM(id),"^",20)
			..q:ActiveFlag="C"
			..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(id)
			..Q:AdmHospitalId'=HospId
			..s Date=$P(^PAADM(id),"^",6)
			..//q:Date>$H  ;大于当前时间退出  肯定没有未付费记录
			..q:((Date>EndDate)||(Date<StartDate))
			..s Date=..%ZD(Date)
			..s LocID=$P(^PAADM(id),"^",4)
			..i LocID'="" s LocID=$P(^CTLOC(LocID),"^",2)
			..s DocID=$P(^PAADM(id),"^",9)
			..i DocID'="" s DocID=$P(^CTPCP(DocID,1),"^",2)
			..i AdmRecorder="" d
			...s Arcimdesc="",Amount="",ODate=""
			...Do OutputQueryFeeNewRow
			..q:AdmRecorder=""
			..s MRAdm=$P(^PAADM(id),"^",61)
			..//q:$O(^MR(MRAdm,"DIA",0))=""  ;没有诊断肯定没有未付费记录
			..s Order=$O(^OEORD(0,"Adm",id,0))
			..q:Order=""
			..s EpissubtypeId=$P($g(^PAADM(id,1)),"^",6)
			..s AdmReasonId=$P($g(^PAADM(id,1)),"^",7)
			..s PAADMRegConDisDR=$P($G(^PAADM(id,"DHC")),"^",25)
			..s Sub=0
			..f  s Sub=$O(^OEORD(Order,"I",Sub)) q:Sub=""  d
			...s Stat=$P($g(^OEORD(Order,"I",Sub,1)),"^",13)
			...q:(Stat'=1)&&(Stat'=6)
			...s Paied=$P(^OEORD(Order,"I",Sub,3),"^",5)
			...s OEItemID=Order_"||"_Sub

			...s Arcim=$P(^OEORD(Order,"I",Sub,1),"^",2)
			...s Arcimdesc=$P($G(^ARCIM(+Arcim,1,1)),"^",2)
			...s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(Order_"||"_Sub)
			...s Arcimdesc=Arcimdesc_ReqPartDesc
			...s arctpdr=$p(^ARCIM($p(Arcim,"||",1),$p(Arcim,"||",2),1),"^",10)
			...s arctype=$p(^ARC("IC",arctpdr),"^",7)
			...s OrderPackQty=$P(^OEORD(Order,"I",Sub,9),"^",4)
			...i arctype'="R" d
			....s pqty=0,pbrowid=0
			....f  s pbrowid=$o(^DHCPBi(0,"OEORI",OEItemID,pbrowid)) q:pbrowid=""  d
			.....q:$d(^DHCPB(pbrowid))=10 ;add hujunbin 15.2.5
		    .....q:$d(^DHCPB(pbrowid))=0 ;add hujunbin 15.2.5
		    .....s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
		    .....s pb=pbrowid  ;+2015-3-19 hujunbin 底下获取账单的时候+pb就等于0了
		    .....s pbosub=0
		    .....f  s pbosub=$o(^DHCPBi(0,"OEORI",OEItemID,pbrowid,pbosub)) q:pbosub=""  d
		    ......q:$d(^DHCPB(pbrowid,"O",pbosub))=10
		    ......s pbo=^DHCPB(pbrowid,"O",pbosub)
		    ......s pbbillqty=$p(pbo,"^",5)
		    ......s pbrefundqty=$p(pbo,"^",6)
		    ......s pqty=pqty+pbbillqty+pbrefundqty
			....i +pqty'=0 s OrderPackQty=pqty
			....e  s OrderPackQty=$p(^OEORD(Order,"I",Sub,1),"^",12)

		    ...s ProtocolPackUOMDR=$p($g(^OEORD(Order,"I",Sub,"DHC")),"^",13)	
			...s OEORIPrice=$P(^OEORD(Order,"I",Sub,3),"^",25) 
			...s ReLocID=$p($g(^OEORD(Order,"I",Sub,3)),"^",6)
			...i OrderPackQty'="" d
			....i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
			....;包含基础单位和整包装代为的价格转换
			....s ExpStr=Order_"||"_Sub_"^^"_id_"^"_ReLocID
			....s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,Arcim , $H, "", "","", OEORIPrice,"",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
			...else  d
			....;只是基本单位的价格
			....s ExpStr=PAADMRegConDisDR_"^"_Order_"||"_Sub_"^^"_id_"^"_ReLocID
			....s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,Arcim , $H, "", "","", OEORIPrice,"",ExpStr)
			....s ArcPrice=$j($p(ArcPrice,"^",1),3,2)
			
			
			...s Amount=$fn($P(ArcPrice,"^",1),"",2)
			...//s Amount=$P($G(^OEORD(Order,"I",Sub,2)),"^",13)
			...s ODate=$P($G(^OEORD(Order,"I",Sub,3)),"^",7)
			...s:ODate'="" ODate=..%ZD(ODate)
		 	...Do OutputQueryFeeNewRow
	 	}
	 	if (Code="Reg"){
		 	s Type=""
			f  s Type=$O(^PAPERdr(PatientID,"ADM",Type)) q:(Type="")  d
			.q:Type="H"
			.q:Type="I"
			.s id=""
			.f  s id=$O(^PAPERdr(PatientID,"ADM",Type,id),-1) q:(id="")  d
			..s ActiveFlag=$P(^PAADM(id),"^",20)
			..q:ActiveFlag="C"
			..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(id)
			..Q:AdmHospitalId'=HospId
			..s Date=$P(^PAADM(id),"^",6)
			..q:((Date>EndDate)||(Date<StartDate))
			..q:Date<+$H
			..s mradm=$p(^PAADM(id),"^",61)
			..s DiagnoseCount=##class(web.DHCDocOrderEntry).GetMRDiagnoseCount(mradm)
			..q:DiagnoseCount'=0
			..s Arcimdesc="",Amount="",ODate=""
			..s Date=..%ZD(Date)
			..s LocID=$P(^PAADM(id),"^",4)
			..i LocID'="" s LocID=$P(^CTLOC(LocID),"^",2)
			..s DocID=$P(^PAADM(id),"^",9)
			..i DocID'="" s DocID=$P(^CTPCP(DocID,1),"^",2)
			..Do OutputQueryFeeNewRow
		 	
		}
		if (Code="App"){
			s RESRowId=""
			f  s RESRowId=$O(^PAPERDR(PatientID,"RB_Appt","I",RESRowId)) q:RESRowId=""  d
			.s Loc=$P($G(^RB("RES",RESRowId)),"^",1)
			.q:Loc=""
			.s HospDr=$p(^CTLOC(Loc),"^",22)
			.Q:HospDr'=HospId
			.s ASChildSub=""
			.f  s ASChildSub=$O(^PAPERDR(PatientID,"RB_Appt","I",RESRowId,ASChildSub)) q:ASChildSub=""  d
			..s APPTChildSub=""
			..f  s APPTChildSub=$O(^PAPERDR(PatientID,"RB_Appt","I",RESRowId,ASChildSub,APPTChildSub)) q:APPTChildSub=""  d
			...s Date=$P(^RBAS(RESRowId,ASChildSub),"^",1)
			...q:((Date>EndDate)||(Date<StartDate))
			...s DocID=$P($G(^RB("RES",RESRowId)),"^",2)
			...s LocID=$P($G(^RB("RES",RESRowId)),"^",1)
			...i LocID'="" s LocID=$P(^CTLOC(LocID),"^",2)
			...i DocID'="" s DocID=$P(^CTPCP(DocID,1),"^",2)
			...s Arcimdesc="",Amount="",ODate=""
			...s Date=..%ZD(Date)
			...Do OutputQueryFeeNewRow
			
		}
	}
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutputQueryFeeNewRow
	set Data=$lb(Date,LocID,DocID,Arcimdesc,ODate,Amount)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod QueryFeeNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFeeNewExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 19062535
/// d ##class(%ResultSet).RunQuery("web.DHCPATCardUnite", "QueryFee","19062584","58")
Query QueryFeeNew(PatientID As %String, StartDate As %String, EndDate As %String, AdmRecorder As %String = "", HospId As %String = "", Code As %String = "") As %Query(ROWSPEC = "Date:%String,LocID:%String,DocID:%String,Arcim:%String,ODate:%String,Amount:%String") [ SqlProc ]
{
}

ClassMethod CheckCardNoIsValidate(paraCardId As %String) As %String
{
	s Valid=1
	s tmpCardNO=$p(^DHCCARD("CF",paraCardId),"^",2)
	s tmpCardTypeId=$p(^DHCCARD("CF",paraCardId),"^",16)
	s cfrowid="0"
	f  s cfrowid=$o(^DHCCARDi("CF",0,"CardNo",tmpCardNO,cfrowid)) q:(cfrowid="")||(Valid=0)  d
	.;同一种类型卡 才能比较
	.s myCardTypeDR=$p(^DHCCARD("CF",cfrowid),"^",16)		;
	.q:(tmpCardTypeId'=myCardTypeDR)
	.s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
	.Q:ActiveFlag'="N"
	.s Valid=0
	Q Valid
}

/// Creator:	jm
/// CreatDate:	2023.02.22
/// Description:根据传入登记号获取到患者合并后的登记号(无合并信息,返回空)
/// Input:		OldPatientNo:登记号
/// Return:		空(无卡合并信息,使用原有登记号)/NewPatientNo(存在合并,使用新登记号)
/// Others:		w ##class(web.DHCPATCardUnite).GetCardUnitNewByOld("0000011927")
ClassMethod GetCardUnitNewByOld(OldPatientNo As %String) As %String
{
	n (OldPatientNo)
	Q:OldPatientNo="" ""
	s OldPAPMIRowid=$o(^PAPERi("PAPMI_PatNo",OldPatientNo,0))
	Q:OldPAPMIRowid="" ""
	s ActiveFlag=$p($g(^PAPER(OldPAPMIRowid,"PAT",1)),"^",6)
	Q:ActiveFlag'="N" ""
	;1表示有效,0表示撤销合并
	s NewPAPMIRowid=$replace($o(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPAPMIRowid,""),-1)," ","")
	Q:NewPAPMIRowid="" ""
	s NewPatientNo=$p(^PAPER(NewPAPMIRowid,"PAT",1),"^",1)
	Q NewPatientNo
}

}
