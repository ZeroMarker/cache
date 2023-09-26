Class DHCDoc.Interface.Inside.InsuPresc.Relate Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// 根据处方号或者医嘱id获取处方类别代码+处方项目分类代码+处方项目分类名称+中药类别代码+中药类别名称
/// 处方类别 1:门诊西药 2:门诊中药饮片 3:急诊西药 4:急诊中药饮片 5:儿科西药 6:儿科中药饮片 7:麻、精一 8:精二 9:中药饮片 10:中成药 99:其它
/// 项目分类 11:西药,12:中成药,13:中药饮片
/// 中药类别 1:未使用,2:中成药,3:中药饮片,9:其他中药
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetPrescTypeByNo("7543","O230213000044")
ClassMethod GetPrescTypeByNo(EpisodeID As %String, PrescNo As %String, OEORIRowid As %String = "") As %String
{
    s PrescType="99"
    if (OEORIRowid="")&&(PrescNo'="") {
	    s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	    s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
	    s OEORIRowid=OrderRowid_"||"_ChildSub
    }
    s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
    s AdmDepDesc=$p($g(^CTLOC(AdmDepDr)),"^",2)
    s ARCIMRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",2)
    s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
    s CNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid,HospitalId)
    if (CNMedItem'=1) {
        if (AdmType="O") s PrescType="1"
        if (AdmType="E") s PrescType="3"
        if (AdmDepDesc["儿") s PrescType="5"
        s ItemType="11",drugType=""
    }else{
        if (AdmType="O") s PrescType="2"
        if (AdmType="E") s PrescType="4"
        if (AdmDepDesc["儿") s PrescType="6"
        s ItemType="13",drugType="3"
    }
    ;中成药
    s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
    s CPMedItemCat=..%GetConfig("CPMedItemCat",HospitalId)
	if ("^"_CPMedItemCat_"^")[("^"_ItemCatDR_"^") s PrescType="10",ItemType="12",drugType="2"
    s PoisonDesc=""
    s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
    if (PoisonRowid'="") s PoisonDesc=$p($g(^PHCPO(PoisonRowid)),"^",2)
    if (PoisonDesc["麻")||(PoisonDesc["精一")||(PoisonDesc["精神一") s PrescType="7"
    if (PoisonDesc["精二")||(PoisonDesc["精神二") s PrescType="8"
    ;
    s ItemTypeDesc=$case(ItemType,"12":"中成药","13":"中药饮片",:"西药")
    s drugTypeDesc=$case(drugType,"2":"中成药","3":"中药饮片",:"")
    Q PrescType_"^"_ItemType_"^"_ItemTypeDesc_"^"_drugType_"^"_drugTypeDesc
}

/// 根据处方号获取药品类目数
/// 非中药时为处方药品类目数量,中药时为药品总剂数
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetDrugCntByNo("O230213000044","2")
ClassMethod GetDrugCntByNo(PrescNo As %String, HospitalId As %String = "2") As %String
{
    s rxDrugCnt=""
    s OrderRowid=0 for {
    	s OrderRowid=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid))
        Q:OrderRowid=""
		s ChildSub=0 for {
        	s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub))
        	Q:ChildSub=""
	        s StatusCode=""
	        s OrderStatusDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
	        if (OrderStatusDr'="") s StatusCode=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
	        continue:(StatusCode'="V")&&(StatusCode'="E")
	        s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
	        s CNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid,HospitalId)
	        if (CNMedItem=1) {
	            s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)
	            s rxDrugCnt=$p($g(^PHCDU(DurRowid)),"^",2)
	        }else{
	            s rxDrugCnt=rxDrugCnt+1
	        }
		}
    }
    Q rxDrugCnt
}

/// 通过用法id获取对照信息
/// 走医保组统一对照界面,字典类别固定: drugmedcwaycodeCon00A
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInstrCompInfo("2","2")
ClassMethod GetInstrCompInfo(InstrRowid As %String, HospitalId As %String = "2") As %String
{
	Q:InstrRowid="" ""
	s InstrCode=$p($g(^PHCIN(InstrRowid)),"^",1)
	s CompCode=##class(web.DHCINSUPort).GetDicByCodeAndInd("drugmedcwaycodeCon00A",InstrCode,6,HospitalId)
	s CompDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("drugmedcwaycodeCon00A",InstrCode,7,HospitalId)  
	Q CompCode_"^"_CompDesc
}

/// 通过频次id获取对照信息
/// 走医保组统一对照界面,字典类别固定: usedfrquCon00A
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetFreqCompInfo("2","2")
ClassMethod GetFreqCompInfo(FreqRowid As %String, HospitalId As %String = "2") As %String
{
	Q:FreqRowid="" ""
	s FreqCode=$p($g(^PHCFR(FreqRowid)),"^",1)
	s CompCode=##class(web.DHCINSUPort).GetDicByCodeAndInd("usedfrquCon00A",FreqCode,6,HospitalId)
	s CompDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("usedfrquCon00A",FreqCode,7,HospitalId)  
	Q CompCode_"^"_CompDesc
}

/// 通过收费项id获取国家医保信息
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetTarInsuInfo("7543","483")
ClassMethod GetTarInsuInfo(EpisodeID As %String, TariDr As %String) As %String
{
	s AdmReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s ItmLinkInsu=##class(web.DHCINSUPort).TarItmLinkInsu(TariDr,AdmReasonDr,"",EpisodeID,"",HospitalId)
    s InsuCode=$p(ItmLinkInsu,"^",12)
    s InsuDesc=$p(ItmLinkInsu,"^",11)
    Q InsuCode_"^"_InsuDesc
}

/// 通过单位id获取对照信息
/// 走医保组统一对照界面,字典类别固定: PackUOMCon00A
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUomCompInfo("2","2")
ClassMethod GetUomCompInfo(UOMRowid As %String, HospitalId As %String) As %String
{
	Q:UOMRowid="" ""
	s UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",2)
	s CompCode=##class(web.DHCINSUPort).GetDicByCodeAndInd("PackUOMCon00A",UOMDesc,6,HospitalId)
	s CompDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("PackUOMCon00A",UOMDesc,7,HospitalId)  
	Q CompCode_"^"_CompDesc
}

/// 根据用户id或者医护人员id获取国家医保码+姓名+证件号码+职称代码+职称名称
/// 职称走医保组统一对照界面,字典类别固定: ProfttlCon00A
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetUserInfo("18018","","2")
ClassMethod GetUserInfo(UserID As %String, CTPCPRowid As %String, HospitalId As %String = "2") As %String
{
	Q:(UserID="")&&(CTPCPRowid="") ""
	if (UserID="")&&(CTPCPRowid'="") s UserID=$o(^SSU("SSUSR",0,"CTPCP",CTPCPRowid,0))
	if (UserID'="")&&(CTPCPRowid="") s CTPCPRowid=$p($g(^SSU("SSUSR",UserID)),"^",14)
	s InsuCode=$p($g(^SSU("SSUSR",UserID)),"^",124)
	s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	s UserCredNo=$p($g(^SSU("SSUSR",UserID)),"^",122)
	s CarPrvTpDr=$p($g(^CTPCP(CTPCPRowid,1)),"^",4)
	s CarPrvTpCode=$p($g(^CT("CPT",CarPrvTpDr)),"^",1)
	s ProfttlCode=##class(web.DHCINSUPort).GetDicByCodeAndInd("ProfttlCon00A",CarPrvTpCode,6,HospitalId)
	s ProfttlDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("ProfttlCon00A",CarPrvTpCode,7,HospitalId)  
	Q InsuCode_"^"_UserName_"^"_UserCredNo_"^"_ProfttlCode_"^"_ProfttlDesc
}

/// 根据患者id获取人员证件类型
/// 走医保组统一对照界面,字典类别固定: CredTypeCon00A
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetPsnCertType("7543")
ClassMethod GetPsnCertType(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s CredTypeDr=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	s CredTypeCode=$p($g(^PAC("CARD",CredTypeDr)),"^",1)
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s psnCertType=##class(web.DHCINSUPort).GetDicByCodeAndInd("CredTypeCon00A",CredTypeCode,6,HospitalId)
	if (psnCertType="") s psnCertType="99" 
	Q psnCertType
}

/// 通过诊断id获取国家医保信息
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetDiagInsuInfo("34","2")
ClassMethod GetDiagInsuInfo(ICDRowid As %String, HospitalId As %String) As %String
{
	Q:ICDRowid="" ""
	s InsuType="00A"
	s DiagInsuInfo=$$GetConInfo^DHCINSUICDContrast(ICDRowid,InsuType,"",HospitalId)
	if (DiagInsuInfo'="") {
		s InsuCode=$p(DiagInsuInfo,"^",3)
    	s InsuDesc=$p(DiagInsuInfo,"^",4)
	}else{
		s InsuCode=$p($g(^MRC("ID",ICDRowid)),"^",4)
    	s InsuDesc=$p($g(^MRC("ID",ICDRowid)),"^",2)
	}
    Q InsuCode_"^"_InsuDesc
}

/// 通过就诊id获取医保登记信息
/// w ##class(DHCDoc.Interface.Inside.InsuPresc.Relate).GetInsuAdmInfoByAdmDr("7468")
ClassMethod GetInsuAdmInfoByAdmDr(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID),"^",1)
	s InsuAdmInfo=##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(EpisodeID)
	;定点医疗机构编号
    s fixmedinsCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","InsuHospCode",4,HospitalId)
    ;定点医疗机构名称
    s fixmedinsName=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","InsuHospName",4,HospitalId)
    ;参保地编号(异地参保人必填)
    s insuPlcNo=$p(InsuAdmInfo,"^",8)
    ;医保就诊ID
    s mdtrtId=$p(InsuAdmInfo,"^",11)
    ;医疗类别
    s medType=$p(InsuAdmInfo,"^",15)
    ;医保人员编号
    s psnNo=$p(InsuAdmInfo,"^",3)
	;病种编码 病种名称
    s diseCodg=$p($p(InsuAdmInfo,"^",39),"|",1)
    s diseName=$p($p(InsuAdmInfo,"^",39),"|",2)
    ;
    Q fixmedinsCode_"^"_fixmedinsName_"^"_insuPlcNo_"^"_mdtrtId_"^"_medType_"^"_psnNo_"^"_diseCodg_"^"_diseCodg
}

}
