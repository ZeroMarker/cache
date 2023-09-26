/// 名称: DHCMA.CPW.BTS.BudgetOrdRecSrv
/// 描述: 表单测算医嘱明细服务类
/// 编写者：yankai
/// 编写日期: 2021-01-25
Class DHCMA.CPW.BTS.BudgetOrdRecSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2022-01-25
/// Description:  检查是否已存在测算医嘱记录
/// Table：       
/// Input：       aFormID
/// Return：      >0：存在；<=0：不存在
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).IsExistBORec("")
ClassMethod IsExistBORec(aFormID As %String) As %String
{
	New (aFormID)
	Set return=0
	Quit:aFormID="" return
	
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) -1
	
	Set BudgetCostID=$o(^DHCMA.CPW.BT.BudgetCostI("IdxofPathFormDr",aFormID,""))
	Quit:BudgetCostID="" -2
	
	Set objBudgetCost=##class(DHCMA.CPW.BT.BudgetCost).%OpenId(BudgetCostID)
	Set return=objBudgetCost.ChildOrd.Count()
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-25
/// Description:  同步关联医嘱信息到测算医嘱明细表中
/// Table：       
/// Input：       aFormID
/// Return：      >0：同步成功；<=0：同步失败
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).SyncFormOrdToBORec("1","1||1||14||1")
ClassMethod SyncFormOrdToBORec(aFormID As %String, aFormOrdIDStr As %String = "") As %String
{
	New (aFormID,aFormOrdIDStr)
	Set return=0
	Quit:aFormID="" return
	//Set ^TEMPYK("SyncFormOrdToBORec")=$LB(aFormID,aFormOrdIDStr)
	Set objForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
 	Quit:'$IsObject(objForm) "-1"
 	
 	Set $ZT="SyncFormOrdToBORecErr"
 	TStart
 	
 	Set bgtCostID=$o(^DHCMA.CPW.BT.BudgetCostI("IdxofPathFormDr",aFormID,""))
	If bgtCostID=""{
		Set bgtCostInputStr="^"_aFormID_"^^^^"
		Set bgtCostID=##class(DHCMA.CPW.BT.BudgetCost).Update(bgtCostInputStr,"^")
		If +bgtCostID<=0{
			TRollBack
			Quit "-2"	
		}
	}
 	
 	If aFormOrdIDStr=""{		//指定关联医嘱串为空，则同步表单下所有
 		Set objBgtCost=##class(DHCMA.CPW.BT.BudgetCost).GetObjById(bgtCostID)
 		Do objBgtCost.ChildOrd.Clear()		//清空原测算医嘱项
 		
		Set xIndNo=""
	 	For {
		 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xIndNo))
		 	Quit:xIndNo=""
		 	
			Set xSubEpID=""
		 	For {
			 	Set xSubEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xIndNo,xSubEpID))
			 	Quit:xSubEpID=""
			 	
			 	Set xObjEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aFormID_"||"_xSubEpID)
			 	Continue:'$IsObject(xObjEP)
			 	
			 	Set EpDesc = xObjEP.EpDesc
			 	Set FormEpID = xObjEP.%Id()
			 	
			 	Set xSubItemID = ""
			 	For {
				 	Set xSubItemID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xSubEpID,"ITM",xSubItemID))
				 	Quit:xSubItemID=""
				 	
				 	Set FormItemID = aFormID_"||"_xSubEpID_"||"_xSubItemID
				 	Set xObjItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(FormItemID)
				 	Continue:'$IsObject(xObjItem)
				 	Set ItemDesc = xObjItem.ItemDesc
				 	
				 	Set xSubOrdID = ""
				 	For {
					 	Set xSubOrdID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xSubEpID,"ITM",xSubItemID,"ORD",xSubOrdID))
					 	Quit:xSubOrdID=""
					 	
					 	Set FormOrdID=aFormID_"||"_xSubEpID_"||"_xSubItemID_"||"_xSubOrdID
					 	Set ret=..SyncSingleFormOrd(FormOrdID,bgtCostID)
					 	If +ret>0{
						 	Set return=return+1
						}
				 	}
			 	}
		 	}
	 	}	 	
	}Else{
		For indx=1:1:$l(aFormOrdIDStr,"^"){
			Set xFormOrdID = $p(aFormOrdIDStr,"^",indx)
			Continue:xFormOrdID=""
			Set ret=..SyncSingleFormOrd(xFormOrdID,bgtCostID)
			If +ret>0{
			 	Set return=return+1
			}
		}	
	}
 	
 	If $TLevel>0 TCommit
	Quit return
	
SyncFormOrdToBORecErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2022-02-18
/// Description:  同步单条关联医嘱到测算医嘱中
/// Table：       
/// Input：       aFormOrdID
/// Return：      >0：同步成功；<=0：同步失败
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).SyncSingleFormOrd("78||1||9||4",12)
ClassMethod SyncSingleFormOrd(aFormOrdID As %String, aBgtCostID As %String) As %String
{
	New (aFormOrdID,aBgtCostID)
	Set return=0
	Quit:(aFormOrdID="")||(aBgtCostID="") return
	
	Set objBgtCost=##class(DHCMA.CPW.BT.BudgetCost).GetObjById(aBgtCostID)
	Quit:'$IsObject(objBgtCost) -1
	
	Set objFormOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aFormOrdID)
 	Quit:'$IsObject(objFormOrd) -2
 	Set OrdIsActive = objFormOrd.OrdIsActive
 	Quit:OrdIsActive'=1 -3
 	Set FormItemID=objFormOrd.Parref.%Id()
 	Set FormEpID=objFormOrd.Parref.Parref.%Id()
 	Set OrdMastID=objFormOrd.OrdMastID
 	Set isCNMedOrd=##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem(OrdMastID)
 	Quit:OrdMastID'["||" -4										//医嘱套不同步
 	//Continue:(OrdMastID'["||")&&(isCNMedOrd'=1)				//非中草药类医嘱套不同步
 	
 	Set InputStr = aBgtCostID									//父类ID
 	Set InputStr = InputStr _"^"_ ""							//子类ID
 	Set InputStr = InputStr _"^"_ FormEpID						//阶段ID
 	Set InputStr = InputStr _"^"_ FormItemID					//项目ID
 	Set InputStr = InputStr _"^"_ aFormOrdID						//关联医嘱记录
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdTypeDr.%Id()
 	Set InputStr = InputStr _"^"_ OrdMastID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdGeneID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdPriorityID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdDoseQty
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdUOMID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdFreqID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdDuratID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdInstrucID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdUseDays
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdQty
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdQtyUomID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdNote
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdChkPosID
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdLnkOrdDr
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdIsDefault
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdIsFluInfu
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdIsActive
 	Set InputStr = InputStr _"^"_ objFormOrd.SeqCode
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdActDate
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdActTime
 	Set InputStr = InputStr _"^"_ objFormOrd.OrdActUserID
		
	Set return=##class(DHCMA.CPW.BT.BudgetOrderRec).Update(InputStr,"^")
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  查询测算医嘱明细表Query
/// Table：       
/// Input：       aFormID
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.BudgetOrdRecSrv","QryBORecCost",84,"2!!1")
Query QryBORecCost(aFormID As %String, aHospID As %String) As %Query(ROWSPEC = "BORecID:%String,FormEpID:%String,FormEpDesc:%String,FormItemID:%String,FormItemDesc:%String,FormOrderID:%String,OrdTypeDr:%String,OrdTypeDesc:%String,OrdMastID:%String,OrdMastDesc:%String,OrdGeneID:%String,OrdGeneDesc:%String,OrdPriorityID:%String,OrdPriorityDesc:%String,OrdQty:%String,OrdQtyUomID:%String,OrdQtyUomDesc:%String,OrdFreqID:%String,OrdFreqDesc:%String,OrdDuratID:%String,OrdDuratDesc:%String,OrdInstrucID:%String,OrdInstrucDesc:%String,OrdDoseQty:%String,OrdUOMID:%String,OrdUOMDesc:%String,OrdNote:%String,OrdChkPosID:%String,OrdLnkOrdDr:%String,OrdIsActive:%String,OrdUseDays:%String,BaseUomPrice:%String,Resume:%String,BORecCost:%String")
{
}

ClassMethod QryBORecCostExecute(ByRef qHandley As %Binary, aFormID As %String, aHospID As %String) As %Status
{
	
	Set repidy=$I(^CacheTemp)
	Set indy=1
	Set qHandley=$lb(0,repidy,0)
 
 	Set objForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
 	Quit:'$IsObject(objForm) $$$OK
 	
 	Set objParref=##class(DHCMA.CPW.BT.BudgetCost).GetObjByFormID(aFormID)
 	Quit:'$IsObject(objParref) $$$OK
 	Set ParrefID=objParref.%Id()
 	
 	Set xSubBORecID=""
 	For{
	 	Set xSubBORecID=$o(^DHCMA.CPW.BT.BudgetCostD(ParrefID,"ORD",xSubBORecID))
	 	Quit:xSubBORecID=""
	 	
	 	Set objBORec=##class(DHCMA.CPW.BT.BudgetOrderRec).GetObjById(ParrefID_"||"_xSubBORecID)
	 	Continue:'$IsObject(objBORec)
	 	Continue:'$IsObject(objBORec.BRFormEpDr)
	 	Continue:'$IsObject(objBORec.BRFormItemDr)
	 	Continue:'$IsObject(objBORec.BROrdTypeDr)
	 	
	 	Set (xBORecID,FormEpID,FormEpDesc,FormItemID,FormItemDesc,FormOrderID)=""
	 	Set xBORecID=ParrefID_"||"_xSubBORecID
	 	Set FormEpID=objBORec.BRFormEpDr.%Id()
	 	Set FormEpDesc=objBORec.BRFormEpDr.EpDesc
	 	Set FormItemID=objBORec.BRFormItemDr.%Id()
	 	Set FormItemDesc=objBORec.BRFormItemDr.ItemDesc
	 	Set FormOrderID=objBORec.BRFormOrderID
	 	
	 	Set (OrdTypeDr,OrdTypeDesc,OrdInfo,OrdMastID,OrdMastDesc,OrdGeneID,OrdGeneDesc,OrdPriorityID,OrdPriorityDesc)=""
	 	Set (retOrdQtyUom,OrdQty,OrdQtyUomID,OrdQtyUomDesc,OrdFreqID,OrdFreqDesc,OrdDuratID,OrdDuratDesc,OrdInstrucID,OrdInstrucDesc)=""
	 	Set (OrdDoseQty,OrdUOMID,OrdUOMDesc,OrdUseDays,retBaseUomPrice,BaseUomPrice,BaseUomID,EQTransFactor,Resume,BudgetOrdCost)=""
	 	
	 	//关联类型
		Set OrdTypeID = objBORec.BROrdTypeDr.%Id()
		Set OrdTypeDesc = objBORec.BROrdTypeDr.BTDesc
	 	
	 	//取医嘱信息、通用名
	 	Set OrdMastID = objBORec.BROrdMastID
	 	Set OrdInfo = ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(OrdMastID,+aHospID)
	 	Set OrdMastDesc = $p(OrdInfo,"^",20)  //医嘱名
	 	Set OrdGeneID = $p(OrdInfo,"^",15) 
	 	//Set:PHCGeneID'="" OrdGeneDesc=$p($g(^PHCGE("GE",OrdGeneID)),"^",2)
	 	Set OrdGeneDesc = $p(OrdInfo,"^",16)  //通用名
	 	
	 	Set OrdPriorityID = objBORec.BROrdPriorityID
	 	Set OrdPriorityDesc=$p($g(^OECPR(OrdPriorityID)),"^",2)
	 	Set OrdQty = objBORec.BROrdQty			//数量
	 	Set OrdQtyUomID = objBORec.BROrdQtyUomID
	 	If OrdQtyUomID=""{
	 		Set:OrdMastID["||" retOrdQtyUom=##Class(DHCMA.CPW.IO.FromDoc).GetQtyUomByArcimID(OrdMastID)	//数量单位
	 		Set OrdQtyUomID=$p(retOrdQtyUom,"^",1) 
	 		Set OrdQtyUomDesc=$p(retOrdQtyUom,"^",2) 	
		}Else{
			Set OrdQtyUomDesc=$p($g(^CT("UOM",OrdQtyUomID)),"^",2)	
		}
	 	
	 	Set OrdFreqID = objBORec.BROrdFreqID
	 	Set:OrdFreqID'="" OrdFreqDesc=$p($g(^PHCFR(OrdFreqID)),"^",3)
	 	Set OrdDuratID = objBORec.BROrdDuratID 
	 	Set:OrdDuratID'="" OrdDuratDesc=$p($g(^PHCDU(OrdDuratID)),"^",3)
	 	Set OrdInstrucID = objBORec.BROrdInstrucID
	 	Set:OrdInstrucID'="" OrdInstrucDesc=$p($g(^PHCIN(OrdInstrucID)),"^",2)
	 	Set OrdDoseQty = objBORec.BROrdDoseQty
	 	If (OrdDoseQty'="")&(OrdDoseQty<1)&(OrdDoseQty'=0){
			Set OrdDoseQty="0"_OrdDoseQty
		}
	 	Set OrdUOMID = objBORec.BROrdUOMID								//剂量单位
	 	Set:OrdUOMID'="" OrdUOMDesc=$p($g(^CT("UOM",OrdUOMID)),"^",2)
	 	Set OrdNote = objBORec.BROrdNote
	 	Set OrdChkPosID = objBORec.BROrdChkPosID
		Set OrdLnkOrdDr = objBORec.BROrdLnkOrdDr
		Set OrdIsActive = objBORec.BROrdIsActive
	 	
	 	Set OrdUseDays = objBORec.BROrdUseDays
	 	Set:OrdUseDays'="" OrdUseDays=OrdUseDays
	 	Set:OrdMastID["||" retBaseUomPrice=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderPrice(OrdMastID,+aHospID)	//库存项单价		
	 	If retBaseUomPrice'="" {
		 	Set BaseUomPrice=$p(retBaseUomPrice,"^",1)	
		 	Set BaseUomID=$p(retBaseUomPrice,"^",2)
	 		Set BaseUomPrice=$fn(+BaseUomPrice,"",4)_"/"_$p(BaseUomPrice,"/",2)	//$fn(+BaseUomPrice,"",4)
	 		If (OrdUOMID'="")&&(BaseUomID'="")&&(OrdUOMID'=BaseUomID){
				Set EQTransFactor=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetEQUomTransFactor(OrdMastID,OrdUOMID)
				Set Resume="1"_$p(BaseUomPrice,"/",2)_"="_EQTransFactor_OrdUOMDesc		
			}
		 }
		 
		 Set BORecCost=##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).GetBORecCost(xBORecID,+aHospID)		//医嘱项费用
	 	 Set:BORecCost'="" BORecCost=$fn(BORecCost,"",2)
	 	 Set Data=$lb(xBORecID,FormEpID,FormEpDesc,FormItemID,FormItemDesc,FormOrderID,OrdTypeDr,OrdTypeDesc,OrdMastID,OrdMastDesc,OrdGeneID,OrdGeneDesc,OrdPriorityID,OrdPriorityDesc,OrdQty,OrdQtyUomID,OrdQtyUomDesc,OrdFreqID,OrdFreqDesc,OrdDuratID,OrdDuratDesc,OrdInstrucID,OrdInstrucDesc,OrdDoseQty,OrdUOMID,OrdUOMDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsActive,OrdUseDays,BaseUomPrice,Resume,BORecCost)
		 Set ^CacheTemp(repidy,indy)=Data
		 Set indy=indy+1
	}
	
 	Quit $$$OK
}

ClassMethod QryBORecCostClose(ByRef qHandley As %Binary) As %Status [ PlaceAfter = QryBORecCostExecute ]
{
	Set repidy=$LIST(qHandley,2)
 	Kill ^CacheTemp(repidy)
 	Quit $$$OK
}

ClassMethod QryBORecCostFetch(ByRef qHandley As %Binary, ByRef Rowy As %List, ByRef AtEndy As %Integer = 0) As %Status [ PlaceAfter = QryBORecCostExecute ]
{
	Set AtEndy=$LIST(qHandley,1)
 	Set repidy=$LIST(qHandley,2)
 	Set indy=$LIST(qHandley,3)
 	Set indy=$o(^CacheTemp(repidy,indy))
 	If indy="" {
 		Set AtEndy=1
 		Set Rowy=""
 	}
 	Else {	
 		Set Rowy=^CacheTemp(repidy,indy)
 	}
 	s qHandley=$lb(AtEndy,repidy,indy)
	Quit $$$OK
}

/// Creator：     yankai
/// CreatDate：   2022-02-08
/// Description:  测算某医嘱项费用
/// Table：       
/// Input：       aBORecID
/// Return：      费用
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).GetBORecCost("1||1","2")
ClassMethod GetBORecCost(aBORecID As %String, aHospID As %String) As %String
{
	New (aBORecID,aHospID,%session)
	Set return=""
	Quit:(aBORecID="")||(aHospID="") return
	
	Set:(aHospID="")&&($d(^%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set objBORec=##class(DHCMA.CPW.BT.BudgetOrderRec).GetObjById(aBORecID)
	Quit:'$IsObject(objBORec) return
	Quit:'$IsObject(objBORec.BRParref) return
	Quit:'$IsObject(objBORec.BRParref.PathFormDr) return
	Set FormID=objBORec.BRParref.PathFormDr.%Id()
	
	Set OrdPrice=0
	Set (OrdMastID,OrdPriorID,OrdPriorCode,isLongTimeOrd)=""
	Set OrdMastID=objBORec.BROrdMastID
	Set OrdPriorID = objBORec.BROrdPriorityID										//医嘱项、医嘱套ID
	Set:OrdPriorID'="" OrdPriorCode=$p($g(^OECPR(OrdPriorID)),"^",1)				//医嘱优先级代码
	Set isLongTimeOrd=$s((OrdPriorCode="S")||(OrdPriorCode="OMST")||(OrdPriorCode="OMCQZT"):1,1:0)		//医嘱优先级是否是长期类医嘱
	
	//单次剂量,剂量单位ID,频次ID,频次因子,用药天数,疗程ID,数量,数量单位ID,数量单位描述
	Set (OrdDoseQty,OrdUOMID,OrdFreqID,PhcFactor,OrdUseDays,OrdDuratID,OrdQty,QtyUOMID,QtyUOMDesc,retQtyUom)=""
	If OrdMastID["||"{											//医嘱项
		Set OrdDoseQty = objBORec.BROrdDoseQty					//单次剂量
		Set OrdUOMID = objBORec.BROrdUOMID						//剂量单位 指向CT_UOM
		Set OrdFreqID = objBORec.BROrdFreqID					//频次 指向PHC_Freq
		Set:OrdFreqID PhcFactor=$p($g(^PHCFR(OrdFreqID)),"^",2)	//频次因子
		Set:PhcFactor="" PhcFactor=1
		Set OrdUseDays = objBORec.BROrdUseDays					//用药天数
		Set:OrdUseDays="" OrdUseDays=1
		
		Set OrdDuratID = objBORec.BROrdDuratID					//疗程 指向PHCDuration
		Set OrdQty=objBORec.BROrdQty							//数量
		Set:OrdQty="" OrdQty=1
		
		Set QtyUOMID = objBORec.BROrdQtyUomID
	 	If QtyUOMID=""{
	 		Set:OrdMastID["||" retQtyUom=##Class(DHCMA.CPW.IO.FromDoc).GetQtyUomByArcimID(OrdMastID)	//数量单位
	 		Set QtyUOMID=$p(retQtyUom,"^",1) 
	 		Set QtyUOMDesc=$p(retQtyUom,"^",2) 	
		}Else{
			Set QtyUOMDesc=$p($g(^CT("UOM",QtyUOMID)),"^",2)	
		}
		
		Set OrdPrice=##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).GetOrdPriceByArcim(FormID,OrdMastID,isLongTimeOrd,OrdUOMID,OrdDoseQty,PhcFactor,OrdUseDays,OrdQty,QtyUOMID,+aHospID)
	}Else{			//医嘱套暂不处理
		/*					
		Set retRS=##Class(%ResultSet).%New("DHCMA.CPW.BTS.PathFormEpSrv:QryOrderByARCOS")			//查询医嘱套明细信息
		Do retRS.Execute(OrdMastID,+aHospID,"",aFormOrdID)
		Set columns = retRS.GetColumnCount()
		While (retRS.Next()) {
			//	医嘱项ID,单次剂量,剂量单位描述,剂量单位ID,频次单位描述,频次单位ID,频次因子,用药天数,疗程描述,疗程ID,数量,数量单位ID,数量单位描述
			Set (ARCIMRowid,OrdDoseQty,OrdUOMDesc,OrdUOMID,OrdFreqDesc,OrdFreqID,PhcFactor,OrdUseDays,OrdDurDesc,OrdDuratID,OrdQty,QtyUOMID,QtyUOMDesc)=""		//每次循环重新赋值
			Set ARCIMRowid=retRS.Data("ARCIMRowid")
			Set OrdDoseQty = retRS.Data("DoseQty")													//单次剂量
			Set OrdUOMDesc = retRS.Data("DoseUOMDesc")												//剂量单位描述
			Set:OrdUOMDesc'="" OrdUOMID=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(OrdUOMDesc),""))		//剂量单位ID 指向CT_UOM
			Set OrdFreqDesc = retRS.Data("FreqDesc")
			Set:OrdFreqDesc'="" OrdFreqID = $o(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(OrdFreqDesc),""))	//频次ID 指向PHC_Freq
			Set:OrdFreqID'="" PhcFactor=$p($g(^PHCFR(OrdFreqID)),"^",2)								//频次因子
			Set:PhcFactor="" PhcFactor=1
			Set OrdUseDays = retRS.Data("ItemUseDays")												//用药天数
			Set:OrdUseDays="" OrdUseDays=1
			Set OrdDurDesc =retRS.Data("DurDesc")													//疗程描述
			Set:OrdDurDesc'="" OrdDuratID = $o(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(OrdDurDesc),""))	//疗程 指向PHCDuration
			Set OrdQty=retRS.Data("ItemQty")														//数量
			Set:OrdQty="" OrdQty=1
			
			Set retQtyUom=##Class(DHCMA.CPW.IO.FromDoc).GetQtyUomByArcimID(ARCIMRowid)		//数量单位
			Set QtyUOMID=$p(retQtyUom,"^",1)
			Set QtyUOMDesc=$p(retQtyUom,"^",2)
			
			Set xItemPrice=##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).GetOrdPriceByArcim(FormID,ARCIMRowid,isLongTimeOrd,OrdUOMID,OrdDoseQty,PhcFactor,OrdUseDays,OrdQty,QtyUOMID,aHospID)
			Set OrdPrice=OrdPrice+xItemPrice
		}*/
	}
	
	Quit OrdPrice
}

/// Creator：     yankai
/// CreatDate：   2022-02-08
/// Description:  根据医嘱项信息获取价格
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).GetOrdPriceByArcim()
ClassMethod GetOrdPriceByArcim(aFormID As %String, aOrdMastID As %String, aIsLongTimeOrd As %String, aOrdUOMID As %String, aOrdDoseQty As %String, aPhcFactor As %String, aOrdUseDays As %String, aOrdQty As %String, aQtyUOMID As %String, aHospID As %String) As %String
{
	New (aFormID,aOrdMastID,aIsLongTimeOrd,aOrdUOMID,aOrdDoseQty,aPhcFactor,aOrdUseDays,aOrdQty,aQtyUOMID,aHospID)
	Set return=""
	Quit:(aFormID="")||(aOrdMastID="")||(aHospID="") return
	
	Set ItemCatRowid=$p($g(^ARCIM(+aOrdMastID,+$p(aOrdMastID,"||",2),1)),"^",10)
	Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid,+aHospID)	//处方类别代码:1:西药,2:中成药,3:草药,4:有频次的处置治疗,5:精神二类药,"":其他
	
	Set DosePrice=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderPrice(aOrdMastID,+aHospID)   //剂量单位单价
	Set BaseDoseUomID=$p(DosePrice,"^",2)
	Set OrderType=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderType(aOrdMastID)
	
	If OrderType="R"{					//药物医嘱
		If aIsLongTimeOrd{				//长期医嘱按天计算
			Set:aOrdUseDays="" aOrdUseDays=1
			If BaseDoseUomID=aOrdUOMID{
				Set OrdPrice=$fn(+DosePrice*aOrdDoseQty*aPhcFactor*aOrdUseDays,"",4) 		
			}Else{
				Set EQTransFactor=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetEQUomTransFactor(aOrdMastID,aOrdUOMID)
				Set OrdPrice=$fn(+DosePrice/EQTransFactor*aOrdDoseQty*aPhcFactor*aOrdUseDays,"",4)	
			}	
		}Else{					//非长期类医嘱按数量计算
			Set:aOrdQty="" aOrdQty=1
			If (BaseDoseUomID=aQtyUOMID){
				Set OrdPrice=$fn(+DosePrice*aOrdQty,"",4)
			}Else{
				Set retConFactor=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetUomTransFactor(aQtyUOMID,BaseDoseUomID)		//获取数量单位与药学项基本单位转换因子
				Set ConFactor=$p(retConFactor,"^",1)
				
				If $p(retConFactor,"^",2)=1{			//正向转换
					Set OrdPrice=$fn(+DosePrice*ConFactor*aOrdQty,"",4)
				}Else{									//负向转换
					Set OrdPrice=$fn(+DosePrice/ConFactor*aOrdQty,"",4)	
				}
			}	
		}	
	}Else{			//非药物医嘱
		If aIsLongTimeOrd{			 //长期医嘱
			Set:aOrdUseDays="" aOrdUseDays=1
			If PHPrescType=4{	     //有频次的处置治疗
				Set OrdPrice=$fn(+DosePrice*aPhcFactor*aOrdUseDays,"",4)
			}Else{					//无频次非药物医嘱
				Set OrdPrice=$fn(+DosePrice*aOrdUseDays,"",4)
			}	
		}Else{						//临时医嘱
			Set:aOrdQty="" aOrdQty=1
			Set OrdPrice=$fn(+DosePrice*aOrdQty,"",4)
		}
	}
	
	If aFormID'=""{
		Set (TarItemList,xTarItemID)=""
		Set TarItemList=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarListByArcim(aOrdMastID)	//该医嘱项对应收费项
		
		If OrderType="R"{	//药物：一条医嘱项对应一个收费项
			Set:TarItemList'="" xTarItemID=$li(TarItemList,1)						
			If xTarItemID'=""{
				Set TarMCCNewID=$p($g(^DHCTARI(xTarItemID)),"^",30)					//新首页费用子分类
				//Set TarMCCNewCode=$p($g(^DHCTarC("MCNew",TarMCCNewID)),"^",1)		//新首页费用子类代码
				//Set TarMCCNewDesc=$p($g(^DHCTarC("MCNew",TarMCCNewID)),"^",2)		//新首页费用子类描述
				//Set TarMCNew=$p($g(^DHCTarC("MCNew",TarMCCNewID)),"^",3)			//新首页费用大类
				
				Set ^||TEMPFormArcimPrice($j,aFormID,TarMCCNewID)=$g(^||TEMPFormArcimPrice($j,aFormID,TarMCCNewID))+OrdPrice
				
				//调用市医保接口，返回计费项收费类别，计算自费总额
				Set retTarItemInsu=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarItemInsu(xTarItemID,+aHospID)
				Set retPayCat=$p(retTarItemInsu,"^",1)
				If (retPayCat="自费")||(retPayCat=""){
					Set ^||TEMPFormArcimPrice($j,aFormID,"SelfPaySum")=$g(^||TEMPFormArcimPrice($j,aFormID,"SelfPaySum"))+OrdPrice	
				}
			}
		}Else{
			//非药物：存在一条医嘱项对应多个收费项的情况
			Set TarPrice=0
			For indx=1:1:$ll(TarItemList){
				Set xTarItemID=$li(TarItemList,indx)
				Set TarMCCNewID=$p($g(^DHCTARI(xTarItemID)),"^",30)					//新首页费用子分类
				Set xSttDate=$o(^DHCOLT(0,"ARTTA",aOrdMastID,xTarItemID,""))
				Set xOLTID=$o(^DHCOLT(0,"ARTTA",aOrdMastID,xTarItemID,xSttDate,""))
				Set Qty=$p(^DHCOLT(xOLTID),"^",3)
				Set:Qty="" Qty=1
				
				Set retPrice=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarItemPrice(xTarItemID,+aHospID)	//返回收费项单价
				Set TarPrice=+retPrice*Qty
				If aIsLongTimeOrd{			 //长期医嘱
					Set:aOrdUseDays="" aOrdUseDays=1
					If PHPrescType=4{	     //有频次的处置治疗
						Set TarPrice=$fn(+TarPrice*aPhcFactor*aOrdUseDays,"",4)
					}Else{					//无频次非药物医嘱
						Set TarPrice=$fn(+TarPrice*aOrdUseDays,"",4)
					}	
				}Else{						//临时医嘱
					Set TarPrice=$fn(+TarPrice*aOrdQty,"",4)
				}
				Set ^||TEMPFormArcimPrice($j,aFormID,TarMCCNewID)=$g(^||TEMPFormArcimPrice($j,aFormID,TarMCCNewID))+TarPrice
				
				//调用市医保接口，返回计费项收费类别，计算自费总额
				Set retTarItemInsu=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetTarItemInsu(xTarItemID,+aHospID)
				Set retPayCat=$p(retTarItemInsu,"^",1)
				If (retPayCat="自费")||(retPayCat=""){
					Set ^||TEMPFormArcimPrice($j,aFormID,"SelfPaySum")=$g(^||TEMPFormArcimPrice($j,aFormID,"SelfPaySum"))+TarPrice	
				} 
			}
		}
	}
	
	Quit OrdPrice
}

/// Creator：     yankai
/// CreatDate：   2022-02-09
/// Description:  测算表单分类费用及总费用
/// Table：       
/// Input：       aFormID
/// Return：      >0：执行成功；<=0：执行失败
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).BudgetFormCost("83","2!!1","9!!1")
ClassMethod BudgetFormCost(aFormID As %String, aHospID As %String, aUserID As %String) As %String
{
	New (aFormID,aHospID,aUserID)
	Set return=""
	Quit:(aFormID="")||(aHospID="")||(aUserID="") return
	
	Set objForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
 	Quit:'$IsObject(objForm) -1
	
	//检查是否已存在测算医嘱
	Set isExistBORec=##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).IsExistBORec(aFormID)
	If +isExistBORec<=0{
		Quit "-2"
		//Set retSyncOrd=##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).SyncFormOrdToBORec(aFormID)    //此处为先同步关联医嘱作为测算医嘱
		//Quit:+retSyncOrd<=0 -2	
	}
	
	Set objBgtCost= ##class(DHCMA.CPW.BT.BudgetCost).GetObjByFormID(aFormID)
	Quit:'$IsObject(objBgtCost) -3
	Set ParrefID=objBgtCost.%Id()
	
	Kill ^||TEMPFormArcimPrice($j)
	Set rsBORec=##class(%ResultSet).%New("DHCMA.CPW.BTS.BudgetOrdRecSrv:QryBORecCost")
	Do rsBORec.Execute(aFormID,aHospID)
	Set isValid = rsBORec.QueryIsValid()
	Quit:'isValid -4

	Set $ZT="BudgetFormCostError"	
	TStart
	
	If $d(^||TEMPFormArcimPrice($j,aFormID)){
		Do objBgtCost.ChildDtl.Clear()			//干掉原有分类费用信息
		
		Set xTarMCCNewID="",retFlg="",TotalCost="",SelfPaySum=0,SelfPayRatio=0
		For {
			Set xTarMCCNewID=$o(^||TEMPFormArcimPrice($j,aFormID,xTarMCCNewID))		//首页费用分类子类
			Continue:xTarMCCNewID="SelfPaySum"
			Quit:xTarMCCNewID=""
			
			Set xTarMCNew=$p($g(^DHCTarC("MCNew",xTarMCCNewID)),"^",3)				//首页费用分类大类
			Set xTarMCCNewCost=$g(^||TEMPFormArcimPrice($j,aFormID,xTarMCCNewID))	//类别费用
			Set:xTarMCCNewCost'="" TotalCost=TotalCost+xTarMCCNewCost
			
			Set aInputStr=ParrefID_"^^"_xTarMCCNewID_"^"_xTarMCCNewCost_"^"_xTarMCNew
			Set retFlg=##class(DHCMA.CPW.BT.BudgetCostDtl).Update(aInputStr,"^")
			If +retFlg<=0{
				TRollBack
				Quit	
			}
		}
		Quit:+retFlg<=0 -5
		
		Set SelfPaySum=$g(^||TEMPFormArcimPrice($j,aFormID,"SelfPaySum"))
		Set:(TotalCost'="")&&(TotalCost'=0) SelfPayRatio=$fn(+SelfPaySum/TotalCost,"",4)
		
		Set objBgtCost=##class(DHCMA.CPW.BT.BudgetCost).%OpenId(ParrefID)
		Set objBgtCost.TotalCost=TotalCost
		Set objBgtCost.SelfPayRatio=SelfPayRatio
		Set objBgtCost.BudgetUser=aUserID
		Set objBgtCost.BudgetDate=+$h
		Set objBgtCost.BudgetTime=$p($h,",",2)
		Set sc=objBgtCost.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		TRollBack
	   		Quit -6
		}Else{
			Set return=objBgtCost.%Id()
		}
		Do objBgtCost.%Close()	
	}Else{
		TRollBack
		Quit -7	
	}
	
	If $TLevel>0 TCommit
	Quit return
	
BudgetFormCostError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  返回表单测算费用汇总(按新首页费用子类汇总)
/// Table：       
/// Input：       aPathFormID
/// Return：      JSON数据
/// w ##class(DHCMA.CPW.BTS.BudgetOrdRecSrv).GetBudgetCostInfo(85)
ClassMethod GetBudgetCostInfo(aFormID As %String) As %String
{
	New (aFormID)
	Set return="[]"
	Quit:aFormID="" return
	
	Set objBgtCost=##class(DHCMA.CPW.BT.BudgetCost).GetObjByFormID(aFormID)
	Quit:'$IsObject(objBgtCost) -1
	Set ParrefID=objBgtCost.%Id()
	
	Set TotalCost=objBgtCost.TotalCost
	Set SelfPayRatio=objBgtCost.SelfPayRatio
	Set objFormTarMCNew = ##class(%DynamicObject).%New()
	
	Set xCostDtlID=""
	For {
		Set xCostDtlID=$o(^DHCMA.CPW.BT.BudgetCostD(ParrefID,"DTL",xCostDtlID))
		Quit:xCostDtlID=""
		
		Set objCostDtl=##class(DHCMA.CPW.BT.BudgetCostDtl).GetObjById(ParrefID_"||"_xCostDtlID)
		Set TarMCCNewCost=objCostDtl.TarMCCateNewCost		//费用
		Set TarMCCNewID=objCostDtl.TarMCCateNewDr			//子类
		Set TarMCNewID=objCostDtl.TarMCNewDr				//大类
		
		Set TarMCCNewCode=$p($g(^DHCTarC("MCNew",TarMCCNewID)),"^",1)		//新首页费用子类代码
		Set TarMCCNewDesc=$p($g(^DHCTarC("MCNew",TarMCCNewID)),"^",2)		//新首页费用子类描述
		
		Do objFormTarMCNew.%Set(TarMCCNewCode,TarMCCNewCost)
	}
	
	/*
	//返回全部分类费用
	Set xTarMCCNewID=""
	For {
		Set xTarMCCNewID=$o(^DHCTarC("MCNew",xTarMCCNewID))
		Quit:xTarMCCNewID=""

		Set TarMCCNewCode=$p($g(^DHCTarC("MCNew",xTarMCCNewID)),"^",1)		//新首页费用子类代码
		Set TarMCCNewDesc=$p($g(^DHCTarC("MCNew",xTarMCCNewID)),"^",2)		//新首页费用子类描述
		
		Set xSubDtlID=$o(^DHCMA.CPW.BT.BudgetCostI("DTL","IdxofParfTMCateNewDr",ParrefID,xTarMCCNewID,""))
		Set objCostDtl=##class(DHCMA.CPW.BT.BudgetCostDtl).GetObjById(ParrefID_"||"_xSubDtlID)
		Set TarMCCNewCost=""
		Set:$IsObject(objCostDtl) TarMCCNewCost=objCostDtl.TarMCCateNewCost		//费用

		Do objFormTarMCNew.%Set(TarMCCNewCode,TarMCCNewCost)
  	}
	*/
	
	Do objFormTarMCNew.%Set("TotalCost",TotalCost)
	Do objFormTarMCNew.%Set("SelfPayRatio",SelfPayRatio)
	Quit objFormTarMCNew.%ToJSON()
}

}
