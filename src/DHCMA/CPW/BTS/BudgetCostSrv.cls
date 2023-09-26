/// 名称: DHCMA.CPW.BTS.BudgetCostSrv
/// 描述: 路径表单费用预算服务类
/// 编写者：yankai
/// 编写日期: 2021-01-08
Class DHCMA.CPW.BTS.BudgetCostSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2022-02-16
/// Description:  根据FormID获取BudgetCostID,不存在的生成对象
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetBCIDByFormID("7","4")
ClassMethod GetBCIDByFormID(aFormID As %String, aUserID As %String = "") As %String
{
	New (aFormID,aUserID)
	Set return=""
	Quit:aFormID="" return
	
	Set objBC=##class(DHCMA.CPW.BT.BudgetCost).GetObjByFormID(aFormID)
	If $IsObject(objBC) {
		Set return = objBC.%Id()	
	}Else{
		Set aInputStr="^"_aFormID_"^^^^"	
		Set return=##class(DHCMA.CPW.BT.BudgetCost).Update(aInputStr,"^")
	}
		
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  封装计费组接口获取单价（药物：药学项基本单位单价；非药物：医嘱项计价单位单价）
/// Table：       
/// Input：       医嘱项Rowid（arc_itmmast),剂量基本单位aUomID,院区id
/// Return：      价格/单位
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderPrice("4873||1",2)
ClassMethod GetOrderPrice(aArcimID As %String, aHospID As %String) As %String
{
	New (aArcimID,aHospID,%session)
	Set return=0
	Quit:aArcimID="" return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	//w ##class(PHA.FACE.OUT.Com).ChkFreeDrug(aArcimID)	判断医嘱项是否是免费药
	//计费接口，返回医嘱项对应的首条库存项的单位费用（单位为库存项单位）
	Set retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",aArcimID,"","","","","",+aHospID,"")
	//Set retPrice=10
	Set Price=$fn($P(retPrice,"^",1),"",4)
	//s DiscPrice=$P(retPrice,"^",2)
	//s InsPrice=$P(retPrice,"^",3)
	//s PatPrice=$P(retPrice,"^",4)
	Set OrderType=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderType(aArcimID)
	If (OrderType="R"){				//药物
		Set DoseUOMID="",DosUOMDesc=""
		Set retDoseUom=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetDoseUom(aArcimID)	
		Set DoseUOMID=$p(retDoseUom,"^",1)
		Set DosUOMDesc=$p(retDoseUom,"^",2)
		
		Set INCIrowid="" 
		Set inciList=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetInciListByArcim(aArcimID)
		Set:inciList'="" INCIrowid=$li(inciList,1)			//取首条有效库存项
		
		Set ConFac=1		//转换因子定义
		If INCIrowid'="" {
			Set CNMedItemFlag=##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem(aArcimID,+aHospID)	//检查是否是草药医嘱项;西药类药学项基本单位和库存项基本单位一致无需处理
			If (CNMedItemFlag="1"){
				Set BaseUomID=$p($g(^INCI(INCIrowid,1)),"^",10)                     			//INCI_CTUOM_DR  库存基本单位
				If (BaseUomID'=DoseUOMID)&&(DoseUOMID'=""){
					Set ConFacID=$o(^CT("CTCF",0,"UOM",BaseUomID,DoseUOMID,""))					//单位转换系数表CT_ConFac
					If ConFacID="" Set ConFac=1
					Else  Set ConFac=$p(^CT("CTCF",ConFacID),"^",3)
				}
				Set Price=$fn(Price/ConFac,"",4)												//计算药学项基本单位金额
			}
		}
		Set return=Price_"/"_DosUOMDesc_"^"_DoseUOMID
	}Else{				//非药物
		Set DoseUOMID=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),8)),"^",14)
		Set:DoseUOMID'="" DosUOMDesc=$p($g(^CT("UOM",DoseUOMID)),"^",2)
		
		Set return=Price_"/"_DosUOMDesc_"^"_DoseUOMID
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-08-16
/// Description:  封装计费组接口获取单价（药品：发药单位根据就诊类型，非药品：计价单位单价）
/// Table：       
/// Input：       医嘱项Rowid（arc_itmmast),剂量基本单位aUomID,院区id
/// Return：      价格/单位
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderDispensePrice("2275||1",2)
ClassMethod GetOrderDispensePrice(aArcimID As %String, aHospID As %String, aAdmType As %String = "I") As %String
{
	New (aArcimID,aHospID,aAdmType)
	Set return=0
	Quit:aArcimID="" return
	
	Set:aHospID'="" HospID=$p(aHospID,"!!",1)
	//w ##class(PHA.FACE.OUT.Com).ChkFreeDrug(aArcimID)	判断医嘱项是否是免费药
	//计费接口，返回医嘱项对应的首条库存项的单位费用（单位为库存项单位）
	Set retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",aArcimID,"","","","","",HospID,"")
	//Set retPrice=10
	Set Price=$fn($P(retPrice,"^",1),"",4)
	//s DiscPrice=$P(retPrice,"^",2)
	//s InsPrice=$P(retPrice,"^",3)
	//s PatPrice=$P(retPrice,"^",4)
	Set OrderType=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderType(aArcimID)
	If (OrderType="R"){				//药物
		Set DoseUOMID="",DosUOMDesc=""
		Set retDoseUom=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetDoseUom(aArcimID)	//药学项基本单位
		Set DoseUOMID=$p(retDoseUom,"^",1)
		Set DosUOMDesc=$p(retDoseUom,"^",2)
		
		Set INCIrowid="" 
		Set inciList=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetInciListByArcim(aArcimID)
		Set:inciList'="" INCIrowid=$li(inciList,1)			//取首条有效库存项
		
		Set ConFac=1,ConFacType=1		//转换因子定义
		Set PatUomID="",PatUomDesc=""   //发药单位
		If INCIrowid'="" {
			Set BaseUomID=$p($g(^INCI(INCIrowid,1)),"^",10)                     			//INCI_CTUOM_DR  库存基本单位
			Set PatUomID=$s(aAdmType="I":$p($g(^INCI(INCIrowid,1)),"^",13),1:$p($g(^INCI(INCIrowid,1)),"^",12))  //INCI_CTUOM_DR  库存发药单位（根据就诊类型，门诊：门诊发药单位，住院：住院发药单位）
			Set PatUomDesc=$p($g(^CT("UOM",PatUomID)),"^",2)
			
			If (BaseUomID'=PatUomID)&&(PatUomID'=""){
				Set retConFac=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetUomTransFactor(PatUomID,BaseUomID)	//获取发药单位和库存基本单位转换系数
				Set ConFac=$p(retConFac,"^",1),ConFacType=$p(retConFac,"^",2)
				Set:+ConFac=0 ConFac=1
			}
			Set Price=$s(ConFacType=1:$fn(Price*ConFac,"",4),1:$fn(Price/ConFac,"",4))    	//计算药品发药单位金额												//计算药学项基本单位金额
		}
		If (PatUomID'="")&&(PatUomDesc'=""){ 
			Set return=Price_"/"_PatUomDesc_"^"_PatUomID
		}Else{
			Set return=Price_"/"_DosUOMDesc_"^"_DoseUOMID
		}
	}Else{				//非药物
		Set DoseUOMID=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),8)),"^",14)
		Set:DoseUOMID'="" DosUOMDesc=$p($g(^CT("UOM",DoseUOMID)),"^",2)
		
		Set return=Price_"/"_DosUOMDesc_"^"_DoseUOMID
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-13
/// Description:  获取单位转换系数
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetUomTransFactor("7","4")
ClassMethod GetUomTransFactor(aFromUomID As %String, aToUomID As %String) As %String
{
	New (aFromUomID,aToUomID)
	Set return=""
	Quit:(aFromUomID="")||(aToUomID="") return
	
	Set TransType=1			//1：正向转换；0：反向转换
	Set ConFacID=$o(^CT("CTCF",0,"UOM",aFromUomID,aToUomID,""))			//单位转换系数表CT_ConFac
	If ConFacID="" {
		Set ConFac=1
		Set ConFacID=$o(^CT("CTCF",0,"UOM",aToUomID,aFromUomID,""))
		If ConFacID=""{
			Set ConFac=1	
		}Else{
			Set ConFac=$p(^CT("CTCF",ConFacID),"^",3)
			Set TransType=0	
		}
	}Else{ 
		Set ConFac=$p(^CT("CTCF",ConFacID),"^",3)
	}
	
	Set return=ConFac_"^"_TransType
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-13
/// Description:  获取剂量等效单位转换系数（1*药学项基本单位=等效系数*等效单位）
/// Table：       
/// Input：       医嘱项Rowid（arc_itmmast),剂量基本单位aUomID
/// Return：
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetEQUomTransFactor("2275||1",66)
ClassMethod GetEQUomTransFactor(aArcimID As %String, aUomID As %String) As %Float
{
	New (aArcimID,aUomID)
	Set return=1
	Quit:(aArcimID="")||(aUomID="") return
	
	Set retBaseUom=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetDoseUom(aArcimID)
	Set BaseDoseUomID=$p(retBaseUom,"^",1)
	
	Set EQQty=1
	If (BaseDoseUomID'=aUomID)&&(BaseDoseUomID'="")&&(aUomID'=""){
		Set DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(aArcimID)
		Set DrgMastID=$p(DrgformRowid,"||",1),DrgFormID=$p(DrgformRowid,"||",2)
		
		Set EqID=0
		For {
			Set EqID=$o(^PHCD(DrgMastID,"DF",DrgFormID,"EQ",EqID))
			Quit:EqID=""
			
			Set EQUomID=$p($g(^PHCD(DrgMastID,"DF",DrgFormID,"EQ",EqID)),"^",1)
			Continue:EQUomID'=aUomID
			Set EQQty=$p($g(^PHCD(DrgMastID,"DF",DrgFormID,"EQ",EqID)),"^",2)
			Quit
		}
	}

	Set:$e(EQQty,1,1)="." EQQty="0"_EQQty
	Set:EQQty'="" return=EQQty
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-13
/// Description:  获取药学项基本单位
/// Table：       
/// Input：       医嘱项Rowid（arc_itmmast)
/// Return：
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetDoseUom("2275||1")
ClassMethod GetDoseUom(aARCIMRowid As %String) As %String
{
	New (aARCIMRowid)
	Set return=""
	Quit:aARCIMRowid="" return
	
	Set (DoseUOMID,DoseUOMDesc)=""
	Set DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(aARCIMRowid)     	//药学项指针
	Set:DrgformRowid'="" DoseUOMID=$p($g(^PHCD($p(DrgformRowid,"||",1),"DF",$p(DrgformRowid,"||",2),2)),"^",4)  //药学项基本单位
	Set:DoseUOMID'="" DoseUOMDesc=$p($g(^CT("UOM",DoseUOMID)),"^",2)
	
	Set return=DoseUOMID_"^"_DoseUOMDesc
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-13
/// Description:  获取医嘱类型(R:药品，N:诊疗，L:检验，P:自定价医嘱，M:材料，X:检查)
/// Table：       
/// Input：       医嘱项Rowid（arc_itmmast)
/// Return：
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderType("2275||1")
ClassMethod GetOrderType(aARCIMRowid As %String) As %String
{
	New (aARCIMRowid)
	Set return=""
	Quit:aARCIMRowid="" return
	
	Set ItemCatRowid=$p($g(^ARCIM(+aARCIMRowid,+$p(aARCIMRowid,"||",2),1)),"^",10)
	Set OrderType=$p($g(^ARC("IC",+ItemCatRowid)),"^",7)
	
	Quit OrderType
}

/// Creator：     yankai
/// CreatDate：   2022-01-13
/// Description:  获取所有医嘱项对应的收费项（含药物、非药物）
/// Table：       
/// Input：       医嘱项Rowid（arc_itmmast)
/// Return：
/// zw ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarListByArcim("1413||1")
ClassMethod GetTarListByArcim(aARCIMRowId As %String, aParaDate As %String = "") As %String
{
	New (aARCIMRowId,aParaDate)
	Set return=""
	Quit:aARCIMRowId="" return
	
	Set:aParaDate="" aParaDate=+$h
	Set TarItemList=""
	Set OrderType=..GetOrderType(aARCIMRowId)
	If OrderType="R"{
		Set TarItemList=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarListByDrugArcim(aARCIMRowId)	
	}Else{
		Set xTarItemID=""
		For{
			Set xTarItemID=$o(^DHCOLT(0,"ARTTA",aARCIMRowId,xTarItemID))
			Quit:xTarItemID=""
			
			Set xSttDate=""
			For {
				Set xSttDate=$o(^DHCOLT(0,"ARTTA",aARCIMRowId,xTarItemID,xSttDate))	
				Quit:xSttDate=""
				Continue:aParaDate<xSttDate
				
				Set xLinkTarID=""
				For {
					Set xLinkTarID=	$o(^DHCOLT(0,"ARTTA",aARCIMRowId,xTarItemID,xSttDate,xLinkTarID))
					Quit:xLinkTarID=""
					
					Set LinkEndDate=$p($g(^DHCOLT(xLinkTarID)),"^",5)
					Continue:(LinkEndDate'="")&&(aParaDate>LinkEndDate)
					Set TariSttDate=$p($g(^DHCTARI(xTarItemID)),"^",11)
					Continue:aParaDate<TariSttDate
					Set TariEndDate=$p($g(^DHCTARI(xTarItemID)),"^",12)
					Continue:(TariEndDate'="")&&(aParaDate>TariEndDate)
					Set TarItemList=TarItemList_$lb(xTarItemID)	
				}
			}	
		}
	}
	
	Set return=TarItemList	
	Quit return
}

/// Creator:	 yankai
/// Description: 根据药物医嘱项获取有效的库存项
/// CreateDate:  2022-01-15
/// Input:       医嘱项ID(Arc_ItemMast表ID),截止日期(数值)
/// OutPut：     $lb(inciID1,inciID2)
/// Other:       8.3之后版本
/// From:		 ##class(PHA.FACE.OUT.Com).GetInciListByArcim("1372||1","")
/// zw ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetInciListByArcim("1372||1","")
ClassMethod GetInciListByArcim(arcimID As %String, paraDate As %String = "") As %String
{
	n (arcimID,paraDate)
    q:arcimID="" ""
    
    s inciList=""
    s arcSub=$p(arcimID,"||",1)
    q:arcSub="" ""
    q:..GetOrderType(arcimID)'="R" ""
    i paraDate="" s paraDate=+$h
    
    s inciID="" 
    f  s inciID=$o(^INCI(0,"ARCIM_DR",arcSub,inciID)) q:inciID=""  d
    .s notUseFlag=$p(^INCI(inciID,2),"^",9)
    .//q:(ordEndDate'="")&&(notUseFlag="Y")
    .s ordEndDate=""
    .s infoID=$o(^DHCITMINFO(0,"INCI",inciID,""))
    .i infoID'="" d
    ..s itmInfoData=$g(^DHCITMINFO(infoID))
    ..s infoEndDate=$p(itmInfoData,"^",31)
    ..s ordEndDate=$p(itmInfoData,"^",113)
    .q:(infoEndDate'="")&&(infoEndDate<paraDate)
    .q:(ordEndDate'="")&&(ordEndDate<paraDate)
    .i inciList="" d
    ..s inciList=$lb(inciID)
    .e  d
    ..s inciList=inciList_$lb(inciID)
    q inciList
}

/// Creator:	 yankai
/// Descript:    根据药物医嘱项获取有效的收费项
/// CreateDate:  2022-01-15
/// Input:       医嘱项ID(Arc_ItemMast表ID),截止日期(数值)
/// OutPut：     $lb(tariID1,tariID2)
/// Other:       8.3之后版本
/// From:		 ##class(PHA.FACE.OUT.Com).GetTarListByArcim("1372||1","")
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarListByDrugArcim("1372||1","")
ClassMethod GetTarListByDrugArcim(arcimID As %String, paraDate As %String = "") As %String
{
	n (arcimID,paraDate)
    q:arcimID="" ""
    
    s tariList=""
    s arcSub=$p(arcimID,"||",1)
    q:arcSub="" ""
    q:..GetOrderType(arcimID)'="R" ""
    i paraDate="" s paraDate=+$h
    
    s inciID="" 
    f  s inciID=$o(^INCI(0,"ARCIM_DR",arcSub,inciID)) q:inciID=""  d
    .s notUseFlag=$p(^INCI(inciID,2),"^",9)
    .//q:notUseFlag="Y"
    .s ordEndDate=""
    .s infoID=$o(^DHCITMINFO(0,"INCI",inciID,""))
    .i infoID'="" d
    ..s itmInfoData=$g(^DHCITMINFO(infoID))
    ..s infoEndDate=$p(itmInfoData,"^",31)
    ..s ordEndDate=$p(itmInfoData,"^",113)
    .q:(infoEndDate'="")&&(infoEndDate<paraDate)
    .q:(ordEndDate'="")&&(ordEndDate<paraDate)
    .s trID=""
    .f  s trID=$o(^DHCINCTARi("INCI",inciID,trID)) q:trID=""  d
    ..s inctrData=$g(^DHCINCTAR(trID))
    ..q:inctrData=""
    ..s trStartDate = $p(inctrData,"^",4)
    ..q:(trStartDate'="")&&(trStartDate>paraDate)
    ..s trEndDate=$p(inctrData,"^",5)
    ..q:(trEndDate'="")&&(trEndDate<paraDate)
    ..s tariID=$p(inctrData,"^",2)
    ..i tariList="" d
    ...s tariList=$lb(tariID)
    ..e  d
    ...s tariList=tariList_$lb(tariID)
    q tariList
}

/// 计费组接口：根据收费项获取单价
/// Function: 获取收费项价格
/// CreateDate:2022-02-25
/// Creator: yankai
/// Input:tarirowide(收费项rowid),hospid（医院id）
/// Retrun:收费项价格
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarItemPrice("22",2)
ClassMethod GetTarItemPrice(tarirowid As %String, hospid As %String = "") As %String
{
	n (tarirowid,hospid,%session)
	q:tarirowid="" ""
	
	s $ZE="GetTarItemPriceErr"
	s:hospid'="" hospid=$p(hospid,"!!",1)
	if hospid="" s hospid=$g(%session.Data("LOGON.HOSPID"))
	s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","",hospid)
	//s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","")
	s tarprice=$p(priceinfo,"^",1)
	s tarprice=$fn(tarprice,"N")  //如果是.3 前面补0
	s tarprice=$tr(tarprice,$c(10),"")
	s tarprice=$tr(tarprice,$c(13),"")
	s tarprice=$tr(tarprice,$c(0),"")	 
	q tarprice
	
GetTarItemPriceErr
	q ""
}

/// 调用市医保接口，获取收费项对应的医保类别
/// w ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarItemInsu(43,2)
ClassMethod GetTarItemInsu(aTarItemID As %String, aHospID As %String) As %String
{
	New (aTarItemID,aHospID)
	Set return=""
	Quit:aTarItemID="" return
	
	Set $ZE="GetTarInsuPayCatErr"
	Set return=##class(web.DHCINSUPort).TarItmLinkInsu(aTarItemID,1,"","","",$p(aHospID,"!!",1))		//第二个参数指向AdmReasonDr 病人就诊费别(paadm_admreason),这里写死取自费患者
	//Set return=##class(web.DHCINSUPort).TarItmLinkInsu(aTarItemID,1,"","","")
	Quit return
	
GetTarInsuPayCatErr
	Quit ""
}

/*
/// Descript:    根据医嘱项获取有效的库存项(医生站、计费)
/// CreateDate:  2019-08-22
/// Input:       医嘱项ID(Arc_ItemMast表ID),截止日期(数值)
/// OutPut：     $lb(inciID1,inciID2)
/// Other:       8.3之后版本
/// w ##class(PHA.FACE.OUT.Com).GetInciListByArcim("1372||1","")
ClassMethod GetInciListByArcim(arcimID As %String, paraDate As %String) As %String
{
	q ##class(PHA.COM.Drug).GetInciListByArcim(arcimID,paraDate)
}

/// Descript:    根据医嘱项获取有效的收费项(计费)
/// CreateDate:  2020-05-13
/// Input:       医嘱项ID(Arc_ItemMast表ID),截止日期(数值)
/// OutPut：     $lb(tariID1,tariID2)
/// Other:       8.3之后版本
/// w ##class(PHA.FACE.OUT.Com).GetTarListByArcim("1372||1","")
ClassMethod GetTarListByArcim(arcimID As %String, paraDate As %String) As %String
{
	q ##class(PHA.COM.Drug).GetTarListByArcim(arcimID,paraDate)
}

/// Descript:    根据收费项获取库存项（计费）
/// CreateDate:  2020-05-13
/// Input:       收费项ID(DHCTarItem表ID),截止日期(数值)
/// OutPut：     $lb(inciID1,inciID2)
/// Other:       8.3之后版本
/// w ##class(PHA.FACE.OUT.Com).GetIncListByTar("1372","")
ClassMethod GetIncListByTar(tariID As %String, paraDate As %String) As %String
{
	q ##class(PHA.COM.Drug).GetIncListByTar(tariID,paraDate)
}

/// Descript:    根据收费项获取医嘱项（计费）
/// CreateDate:  2020-05-13
/// Input:       收费项ID(DHCTarItem表ID),截止日期(数值)
/// OutPut：     $lb(arcimID1,arcimID2)
/// Other:       8.3之后版本
/// w ##class(PHA.FACE.OUT.Com).GetArcListByTar("1372","")
ClassMethod GetArcListByTar(tariID As %String, paraDate As %String) As %String
{
	q ##class(PHA.COM.Drug).GetArcListByTar(tariID,paraDate)
}

/// Descript:    判断收费项是否有效（计费）
/// CreateDate:  2020-05-13
/// Input:       收费项ID(DHCTarItem表ID),截止日期(数值)
/// OutPut：     1-有效,0-无效
/// Other:       8.3之后版本
/// w ##class(PHA.FACE.OUT.Com).IsValidTar("1372","")
ClassMethod IsValidTar(tariID As %String, paraDate As %String) As %String
{
	q ##class(PHA.COM.Drug).IsValidTar(tariID,paraDate)
}

/// Descript:    是否药品
/// CreateDate:  2020-05-13
/// Input:       医嘱项ID(Arc_ItemMast表ID),库存项ID(INC_Itm表ID)
/// OutPut：     1-是,0-否
/// w ##class(PHA.FACE.OUT.Com).IsDrug("1372","")
ClassMethod IsDrug(arcimID As %String, inciID As %String) As %String
{
	q ##class(PHA.COM.Drug).IsDrug(arcimID,inciID)
}*/
}
