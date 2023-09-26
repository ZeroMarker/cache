/// 名称: DHCCPW.MR.FORM.OEOrderSrv
/// 描述: 表单医嘱录入相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-17
Class DHCCPW.MR.FORM.OEOrderSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		zhufei
/// CreatDate:		2015-06-19
/// Description:	将临床路径对应的医嘱直接增加到医嘱录入界面上
/// Table:        	User.DHCMRCClinPathWaysItmGene
/// Input:        	关联通用名ID^医嘱项ID^整包装数量^单次剂量^剂量单位^频次^用法^疗程^备注
/// Return:       	return=0：成功
/// Others:			w ##class(DHCCPW.MR.FORM.OEOrderSrv).AddMRCPWItemToList("AddCopyItemToList","",$c(1)_"401||1||1||12||3^5614||1^3^1^^^^^^"_$c(1)_"401||1||1||12||4^21654||1^3^1^^^^^^"_$c(1)_"401||1||1||13||3^14767||1^3^1^^^^^^"_$c(1)_"401||1||1||14||3^4979||1^3^1^^^^^^"_$c(1)_"401||1||1||15||4^3944||1^3^1^^^^^^"_$c(1)_"401||1||1||16||6^6593||1^3^1^^^^^^")
ClassMethod AddMRCPWItemToList(itmjs As %Library.String = "", itmjsex As %Library.String = "", aOrderList As %String) As %String
{
	s jsval=""
	
	//Set ^ZF=aOrderList
	
	//取默认医嘱类型
	Set tOrderPriorID=$o(^OECPR(0,"Desc","临时医嘱",""))
	Set:tOrderPriorID="" tOrderPriorID=$o(^OECPR(0))
	
	Kill arrOrderList
	For indArc=1:1:$l(aOrderList,$c(1)) {
		Set arcimInfo=$p(aOrderList,$c(1),indArc)
		Continue:arcimInfo=""
		
		Set GeneID=$p(arcimInfo,"^",1)
		Set ArcimID=$p(arcimInfo,"^",2)
		Set OrderPriorID=$p(arcimInfo,"^",3)
		Set OrderPackQty=$p(arcimInfo,"^",4)
		Set OrderDoseQty=$p(arcimInfo,"^",5)
		Set OrderDoseUOMID=$p(arcimInfo,"^",6)
		Set OrderFreqID=$p(arcimInfo,"^",7)
		Set OrderDurID=$p(arcimInfo,"^",8)
		Set OrderInstrID=$p(arcimInfo,"^",9)
		Set OrderResume=$p(arcimInfo,"^",10)
		Set OrderSeqNos=$p(arcimInfo,"^",11)
		
		Set OrderSeqNo=+$p(OrderSeqNos,".",1)
		Set OrderSeqSub=+$p(OrderSeqNos,".",2)
		Set StepItemID=$p(GeneID,"||",1)_"||"_$p(GeneID,"||",2)_"||"_$p(GeneID,"||",3)_"||"_$p(GeneID,"||",4)
		
		If $l(ArcimID,"||")=2 {
			Set (OrderPrior,OrderDoseUOM,OrderFreq,OrderFreqFactor,OrderFreqInterval)=""
			Set (OrderInstr,OrderDur,OrderDurFactor,OrderPackUOM)=""
			Set:OrderPriorID="" OrderPriorID=tOrderPriorID
			Set:OrderPriorID'="" OrderPrior=$p($g(^OECPR(OrderPriorID)),"^",2)
			Set:OrderDoseUOMID'="" OrderDoseUOM=$P(^CT("UOM",OrderDoseUOMID),"^",2)
			If OrderFreqID'="" {
				Set OrderFreq=$P($g(^PHCFR(OrderFreqID)),"^",3)
				Set OrderFreqFactor=$P($g(^PHCFR(OrderFreqID)),"^",2)
				Set OrderFreqInterval=$P($g(^PHCFR(OrderFreqID)),"^",5)
			}
			Set:OrderInstrID'="" OrderInstr=$P($g(^PHCIN(OrderInstrID)),"^",2)
			If OrderDurID'="" {
				Set OrderDurFactor=$P($g(^PHCDU(OrderDurID)),"^",2)
				Set OrderDur=$P($g(^PHCDU(OrderDurID)),"^",3)
			}
			Set OrderPackUOMID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),8)),"^",14)
			Set:OrderPackUOMID'="" OrderPackUOM=$P($G(^CT("UOM",OrderPackUOMID)),"^",2)
			
			//医嘱信息
			Set ItemData=OrderDoseQty_$C(1)_OrderDoseUOM_$C(1)_OrderDoseUOMID
			Set ItemData=ItemData_"^"_OrderFreq_$C(1)_OrderFreqID_$C(1)_OrderFreqFactor_$C(1)_OrderFreqInterval
			Set ItemData=ItemData_"^"_OrderInstr_$C(1)_OrderInstrID
			Set ItemData=ItemData_"^"_OrderDur_$C(1)_OrderDurID_$C(1)_OrderDurFactor
			Set ItemData=ItemData_"^"_OrderPackQty_$C(1)_OrderPackUOM_$C(1)_OrderPackUOMID
			Set ItemData=ItemData_"^"_OrderPrior_$C(1)_OrderPriorID_$c(1)_OrderResume
			Set ItemData=ItemData_"^^^"  //医嘱套ID、空、医嘱子类ID
			
			//医嘱大类
			Set OrderType=""
			Set SubCatRowId=$p(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1),"^",10)
			Set:SubCatRowId'="" OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
		} Else {
			Set ItemData=""
			Set OrderType=""
		}
		Set arrOrderList(OrderSeqNo,OrderSeqSub)=$lb(ArcimID,StepItemID,ItemData,OrderType)
	}
	
	Set xSeqNo="",OrderSeqNo=0
	For {
		Set xSeqNo=$o(arrOrderList(xSeqNo))
		Quit:xSeqNo=""
		
		If $d(arrOrderList(xSeqNo,0)){
			Set OrderSeqNo=OrderSeqNo+1
		}
		
		Set xSubNo="",OrderSubNo=0
		For {
			Set xSubNo=$o(arrOrderList(xSeqNo,xSubNo))
			Quit:xSubNo=""
			
			Set OrderInfo=$g(arrOrderList(xSeqNo,xSubNo))
			Set ArcimID=$list(OrderInfo,1)
			Set StepItemID=$list(OrderInfo,2)
			Set ItemData=$list(OrderInfo,3)
			Set OrderType=$list(OrderInfo,4)
			
			If $l(ArcimID,"||")=2 {
				If $d(arrOrderList(xSeqNo,0)){
					Set:xSubNo>0 OrderSubNo=OrderSubNo+1
				} Else {
					Set OrderSeqNo=OrderSeqNo+1
				}
				If OrderSubNo<1 {
					Set tOrderSeqNo=OrderSeqNo
				} Else {
					Set tOrderSeqNo=OrderSeqNo_"."_OrderSubNo
				}
				
				Set jsval=jsval_"Copyary[Copyary.length]="""_ArcimID_"!"_tOrderSeqNo_"!"_ItemData_"!"_OrderType_"!!Order!"_StepItemID_""";"
			} Else {  //医嘱套
				Set ARCOSID=ArcimID
				Continue:ARCOSID=""
				
				Set rs=##Class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
				Do rs.Execute(ARCOSID)
				Set columns = rs.GetColumnCount()
				While (rs.Next()) {
					Set ArcimID=$ZCVT(rs.Data("ItemRowid"),"O","JS")
					Set ItemData=$ZCVT(rs.Data("ItemData"),"O","JS")
					Set OrderType=$ZCVT(rs.Data("ItemOrderType"),"O","JS")
					Set tOrderSeqNo=$ZCVT(rs.Data("ItemSeqNo"),"O","JS")
					Set OrderSubNo=OrderSubNo+tOrderSeqNo
					Set jsval=jsval_"Copyary[Copyary.length]="""_ArcimID_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!OSItem!"_StepItemID_""";"
				}
				Do rs.Close()
			}
		}
	}
	Kill arrOrderInfo
	
	If (itmjs'="")&&(jsval'="") {
		Set jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary);"
		&javascript<#(jsval)#>
	}
	
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-06-17
/// Description:  通用名查询医嘱项
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       ItemID : 表单项目
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCCPW.MR.FORM.OEOrderSrv","QryOrderListByGene",4587636,"ZYFSX-左氧氟沙星","","")
Query QryOrderListByGene(aEpisodeID As %String, aArcimID As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String,OrderType:%String,PrescType:%String,FreqDR:%String,FreqDesc:%String,DuratDR:%String,DuratDesc:%String,InstrucDR:%String,InstrucDesc:%String,DoseQty:%String,DoseUomDR:%String,DoseUomDesc:%String,PHCGeneDesc:%String,PHCSpecDesc:%String,PHCFormDesc:%String")
{
}

ClassMethod QryOrderListByGeneExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aArcimID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=aEpisodeID_"-"_aArcimID
	Quit:(aEpisodeID="")||(aArcimID="") $$$OK
	Quit:$l(aArcimID,"||")=1 $$$OK
	
	Set ArcimInfo=##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(aArcimID)
	Quit:ArcimInfo="" return
	Set tOrderType=$p(ArcimInfo,"^",2)
	Set tPrescType=$p(ArcimInfo,"^",3)
	Set tPHCFormDR=$p(ArcimInfo,"^",13)
	Set tPHCFormDesc=$p(ArcimInfo,"^",14)
	Set tPHCGeneDR=$p(ArcimInfo,"^",15)
	Set tPHCGeneDesc=$p(ArcimInfo,"^",16)
	Set tPHCSpecDesc=$p(ArcimInfo,"^",17)
	Set tArcimDesc=$p(ArcimInfo,"^",20)
	
	Set tmpGeneDesc=##class(DHCCPW.IO.FromHisSrv).ALPHAUP(tPHCGeneDesc)
	Set xGeneID=""
	For {
		Set xGeneID=$o(^PHCGE("GE",0,"Name",tmpGeneDesc,xGeneID))
		Quit:xGeneID=""
		
		Set GeneDesc=$p($g(^PHCGE("GE",xGeneID)),"^",2)
		Continue:tPHCGeneDesc'=GeneDesc
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^ARCIM(0,"Gener",xGeneID,xArcimID))
			Quit:xArcimID=""
			
			Set ArcimID=xArcimID_"||1"
			Set ArcimInfo=##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(ArcimID)
			Continue:ArcimInfo=""
			Set OrderType=$p(ArcimInfo,"^",2)
			Set PrescType=$p(ArcimInfo,"^",3)
			Set DoseQty=$p(ArcimInfo,"^",4)
			Set DoseUomDR=$p(ArcimInfo,"^",5)
			Set DoseUomDesc=$p(ArcimInfo,"^",6)
			Set DuratDR=$p(ArcimInfo,"^",7)
			Set DuratDesc=$p(ArcimInfo,"^",8)
			Set FreqDR=$p(ArcimInfo,"^",9)
			Set FreqDesc=$p(ArcimInfo,"^",10)
			Set InstrucDR=$p(ArcimInfo,"^",11)
			Set InstrucDesc=$p(ArcimInfo,"^",12)
			Set PHCFormDR=$p(ArcimInfo,"^",13)
			Set PHCFormDesc=$p(ArcimInfo,"^",14)
			Set PHCGeneDR=$p(ArcimInfo,"^",15)
			Set PHCGeneDesc=$p(ArcimInfo,"^",16)
			Set PHCSpecDesc=$p(ArcimInfo,"^",17)
			Set ArcimDesc=$p(ArcimInfo,"^",20)
			//Continue:(tPHCFormDesc'="")&&(tPHCFormDesc'=PHCSpecDesc)	//规格
			//Continue:(tPHCGeneDesc'="")&&(tPHCGeneDesc'=PHCFormDesc)	//剂型
			
			If OrderType="R" {
				Set IsArcInci=##class(DHCCPW.IO.FromHisSrv).CheckArcimInci(aEpisodeID,ArcimID)
				Continue:IsArcInci<1 //无库存,主要是针对药品和材料
			}
			
			Set Data=$lb(ArcimID,ArcimDesc,OrderType,PrescType,FreqDR,FreqDesc,DuratDR,DuratDesc,InstrucDR,InstrucDesc,DoseQty,DoseUomDR,DoseUomDesc)
			Set Data=Data_$lb(PHCGeneDesc,PHCSpecDesc,PHCFormDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

ClassMethod QryOrderListByGeneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderListByGeneExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrderListByGeneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderListByGeneExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2015-06-17
/// Description:  查询表单项目关联医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       ItemID : 表单项目
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCCPW.MR.FORM.OEOrderSrv","QryOrderListByStep",4597636,"401||1||1","2||6","")
Query QryOrderListByStep(aEpisodeID As %String, aStepID As %String, aSubCatID As %String, aItemIDs As %String) As %Query(ROWSPEC = "ItemID:%String,ItemDesc:%String,ItmNoStr:%String,ItmSubCatID:%String,ItmSubCatDesc:%String,ItmIsOptional:%String,IGPriority:%String,IGPriorityDesc:%String,IGIsMain:%String,OrderSeqNo:%String,IGAIndex:%String,IGAArcimDR:%String,IGAArcimDesc:%String,PHCGeneDesc:%String,PHCSpecDesc:%String,PHCFormDesc:%String,IGAPackQty:%String,IGAFreqDR:%String,IGAFreqDesc:%String,IGADuratDR:%String,IGADuratDesc:%String,IGAInstrucDR:%String,IGAInstrucDesc:%String,IGADoseQty:%String,IGADoseUomDR:%String,IGADoseUomDesc:%String,IGADefault:%String,IGAResume:%String,IsArcInci:%String,IsChecked:%String,IGASign:%String")
{
}

ClassMethod QryOrderListByStepExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aStepID As %String, aSubCatID As %String, aItemIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:$l(aItemIDs,"||")=4 aStepID=aItemIDs	//update by liuyh 考虑合并症

	Quit:aStepID="" $$$OK
	Set FormID=$p(aStepID,"||",1)
	Set EpSub=$p(aStepID,"||",2)
	Set StepSub=$p(aStepID,"||",3)
	Quit:(FormID="")||(EpSub="")||(StepSub="") $$$OK
	
	Set:aItemIDs'="" aItemIDs=","_aItemIDs_","
	
	Kill arrOrderList
	Set xItmGrpNo=0
	For {
		Set xItmGrpNo=$o(^DHCMRCi("CPW",0,"ITEM","IndexGroupNo",FormID,EpSub,StepSub,xItmGrpNo))
		Quit:xItmGrpNo=""
		
		Set xItemSub=0,ItemNumber=0
		For {
			Set xItemSub=$o(^DHCMRCi("CPW",0,"ITEM","IndexGroupNo",FormID,EpSub,StepSub,xItmGrpNo,xItemSub))
			Quit:xItemSub=""
			
			Set ItemID=FormID_"||"_EpSub_"||"_StepSub_"||"_xItemSub
			Continue:(aItemIDs'="")&&(aItemIDs'[(","_ItemID_","))
			Set objItem=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(ItemID)
			Continue:'$IsObject(objItem)
			Set ItemDesc=objItem.CPWSIDesc
			Continue:'$IsObject(objItem.CPWSISubCategory)
			Set ItmSubCatID=objItem.CPWSISubCategory.%Id()
			Continue:(aSubCatID'="")&&(aSubCatID'=ItmSubCatID)
			Set ItmSubCatDesc=objItem.CPWSISubCategory.SISCDesc
			Set ItmIsOptional=objItem.CPWSIIsMust
			Set ItmIsOptional=$s(ItmIsOptional["Y":1,1:0)  //是否可选项目
			Set ItmNoStr=""
			Set ItmGroupNo=objItem.CPWSIGroupNo
			Set $p(ItmNoStr,"0",6-$l(ItmGroupNo))=ItmGroupNo
			Set ItemNumber=ItemNumber+1
			Set ItmNoStr=ItmNoStr_"-"_ItemNumber
			
			//表单项目内容
			Set ItemData=$lb(ItemID,ItemDesc,ItmNoStr,ItmSubCatID,ItmSubCatDesc,ItmIsOptional)
			Set arrOrderList(xItmGrpNo,xItemSub)=ItemData
			
			Set xIGNo=0
			For {
				Set xIGNo=$o(^DHCMRCi("CPW",0,"GENE","IndexGeneNo",FormID,EpSub,StepSub,xItemSub,xIGNo))
				Quit:xIGNo=""
				
				Set xGeneSub=0
				For {
					Set xGeneSub=$o(^DHCMRCi("CPW",0,"GENE","IndexGeneNo",FormID,EpSub,StepSub,xItemSub,xIGNo,xGeneSub))
					Quit:xGeneSub=""
					
					Set GeneID=ItemID_"||"_xGeneSub
					Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(GeneID)
					Continue:'$IsObject(objGene)
					
					Set IGNo=objGene.IGNo              //序号
					Set IGGeneDesc=objGene.IGGeneDesc  //通用名
					Set IGPriority=objGene.IGPriority  //医嘱类型
					Set IGPriorityDesc=$p($g(^OECPR(IGPriority)),"^",2)
					Set IGIsMain=objGene.IGIsMain      //主医嘱
					Set IGIsMain=$s(IGIsMain["Y":1,1:0)
					Set IGLinkNo=objGene.IGLinkNo      //关联号
					If IGLinkNo'="" {
						Set objLnkGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(IGLinkNo)
						If $IsObject(objLnkGene) {
							Set IGLinkNo=objLnkGene.IGNo
						} Else {
							Set IGLinkNo=""
						}
					}
					
					//关联通用名内容
					Set GeneData=$lb(IGPriority,IGPriorityDesc,IGIsMain)
					If IGLinkNo'="" {
						Set OrderSeqNo=+IGLinkNo
						Set OrderSeqSub=+IGNo
					} Else {
						Set OrderSeqNo=+IGNo
						Set OrderSeqSub=0
					}
					Set arrOrderList(xItmGrpNo,xItemSub,OrderSeqNo,OrderSeqSub)=GeneData
					
					For indArc=1:1:objGene.IGArcimList.Count() {
						Set objArcim=objGene.IGArcimList.GetAt(indArc)
						Continue:'$IsObject(objArcim)
						Set ArcimDR = objArcim.ITMARCIMDR
						Continue:ArcimDR=""
						
						Set ArcimInfo=##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(ArcimDR)
						Continue:ArcimInfo=""
						Set OrderType=$p(ArcimInfo,"^",2)
						Set PrescType=$p(ArcimInfo,"^",3)
						Set PHCFormDR=$p(ArcimInfo,"^",13)
						Set PHCFormDesc=$p(ArcimInfo,"^",14)
						Set PHCGeneDR=$p(ArcimInfo,"^",15)
						Set PHCGeneDesc=$p(ArcimInfo,"^",16)
						Set PHCSpecDesc=$p(ArcimInfo,"^",17)
						Set ArcimDesc=$p(ArcimInfo,"^",20)  //医嘱套
						Set:$l(ArcimDR,"||")=1 ArcimDesc="[医嘱套]"_ArcimDesc
						
						Set IGAPackQty = objArcim.ITMQty
						Set IGAFreqDR = objArcim.ITMFreqDR
						Set IGAFreqDesc=""
						Set:IGAFreqDR'="" IGAFreqDesc=$p($g(^PHCFR(IGAFreqDR)),"^",3)
						Set IGADuratDR = objArcim.ITMDuratDR
						Set IGADuratDesc=""
						Set:IGADuratDR'="" IGADuratDesc=$p($g(^PHCDU(IGADuratDR)),"^",3)
						Set IGAInstrucDR = objArcim.ITMInstrucDR
						Set IGAInstrucDesc=""
						Set:IGAInstrucDR'="" IGAInstrucDesc=$p($g(^PHCIN(IGAInstrucDR)),"^",2)
						Set IGADoseQty = objArcim.ITMDoseQty
						Set IGADoseUomDR = objArcim.ITMUOMDR
						Set IGADoseUomDesc=""
						Set:IGADoseUomDR'="" IGADoseUomDesc=$p($g(^CT("UOM",IGADoseUomDR)),"^",2)
						Set IGADefault=objArcim.ITMDefault    //首选医嘱
						Set IGADefault=$s(IGADefault["Y":1,1:0)
						Set IGAIsActive = objArcim.ITMIsActive
						Continue:IGAIsActive'["Y"
						Set IGAResume = objArcim.ITMResume
						
						If OrderType="R" {
							Set IsArcInci=##class(DHCCPW.IO.FromHisSrv).CheckArcimInci(aEpisodeID,ArcimDR)
						} Else {
							Set IsArcInci=1
						}
						Set IsChecked=IGADefault  //首选医嘱默认被选中
						Set:IsArcInci<1 IsChecked=0
						
						Set IGAIndex=GeneID_"-"_indArc
						
						//医嘱信息
						Set OrderData=$lb(IGAIndex,ArcimDR,ArcimDesc,PHCGeneDesc,PHCSpecDesc,PHCFormDesc,IGAPackQty,IGAFreqDR,IGAFreqDesc,IGADuratDR,IGADuratDesc,IGAInstrucDR,IGAInstrucDesc,IGADoseQty,IGADoseUomDR,IGADoseUomDesc,IGADefault,IGAResume,IsArcInci,IsChecked)
						Set arrOrderList(xItmGrpNo,xItemSub,OrderSeqNo,OrderSeqSub,indArc)=OrderData
					}
				}
			}
		}
	}
	
	Set xItmGrpNo=0,OrderSeqNo=0
	For {
		Set xItmGrpNo=$o(arrOrderList(xItmGrpNo))
		Quit:xItmGrpNo=""
		
		Set xItemSub=0
		For {
			Set xItemSub=$o(arrOrderList(xItmGrpNo,xItemSub))
			Quit:xItemSub=""
			
			//表单项目
			Set ItemData=$g(arrOrderList(xItmGrpNo,xItemSub))
			
			Set xSeqNo=""
			For {
				Set xSeqNo=$o(arrOrderList(xItmGrpNo,xItemSub,xSeqNo))
				Quit:xSeqNo=""
				
				If $d(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,0)){
					Set OrderSeqNo=OrderSeqNo+1
				}
				
				Set xSubNo="",OrderSubNo=0
				For {
					Set xSubNo=$o(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,xSubNo))
					Quit:xSubNo=""
					
					If $d(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,0)){
						Set:xSubNo>0 OrderSubNo=OrderSubNo+1
					} Else {
						Set OrderSeqNo=OrderSeqNo+1
					}
					If OrderSubNo<1 {
						Set tOrderSeqNo=OrderSeqNo
					} Else {
						Set tOrderSeqNo=OrderSeqNo_"."_OrderSubNo
					}
					
					//通用名信息
					Set GeneData=$g(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,xSubNo))
					Set GeneData=GeneData_$lb(tOrderSeqNo)  //增加顺序号
					
					Set xArcNo=0,ArcCount=0
					For {
						Set xArcNo=$o(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,xSubNo,xArcNo))
						Quit:xArcNo=""
						
						//医嘱信息
						Set OrderData=$g(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,xSubNo,xArcNo))
						Set ArcCount=ArcCount+1
						If ArcCount>1 {
							If $o(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,xSubNo,xArcNo))="" {
								Set IGASign=2
							} Else {
								Set IGASign=0
							}
						} Else {
							If $o(arrOrderList(xItmGrpNo,xItemSub,xSeqNo,xSubNo,xArcNo))="" {
								Set IGASign=3
							} Else {
								Set IGASign=1
							}
						}
						Set OrderData=OrderData_$lb(IGASign) //增加启止符号
						
						Set ^CacheTemp(repid,ind)=ItemData_GeneData_OrderData
						Set ind=ind+1
					}
				}
			}
		}
	}
	Kill arrOrderList
	
	Quit $$$OK
}

ClassMethod QryOrderListByStepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderListByStepExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrderListByStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderListByStepExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
