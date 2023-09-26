/// 名称: DHCCPW.MR.FORM.VarianceSrv
/// 描述: 病情变异记录相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-17
Class DHCCPW.MR.FORM.VarianceSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-06-30
/// Description:  查询变异内容列表
/// Input：       PathWayID : 出入径ID
///               StepID ：步骤ID
///               UserType ：用户类型
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MR.FORM.VarianceSrv","QryVarItemList","21","79||1||1","D")
Query QryVarItemList(aPathWayID As %String, aStepID As %String, aUserType As %String) As %Query(ROWSPEC = "VarItemInd:%String,VarItemCode:%String,VarItemDesc:%String,VarItemGroup:%String")
{
}

ClassMethod QryVarItemListExecute(ByRef qHandle As %Binary, aPathWayID As %String, aStepID As %String, aUserType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aUserType="" $$$OK
	
	//update by zf 20150630 新版本同步数据
	Set flg=##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrderByPathWay(aPathWayID)
	Set stepEstimate=##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(aPathWayID,aStepID)
	Set StepSttDate=$list(stepEstimate,3)
	Set StepSttTime=$list(stepEstimate,4)
	Set StepEndDate=$list(stepEstimate,5)
	Set StepEndTime=$list(stepEstimate,6)
	Set compStepList=$list(stepEstimate,8)
	
	Kill ^TMP($zn,$j,"QryVarItemList")
	
	//1 步骤时间调整
	Set IsCheck1=##class(User.DHCMRCBaseConfig).GetValueByCode("CheckStepTimeAdjustToSign")
	If (IsCheck1'="N")&&(aUserType="D") {
		Set TimeAdjust=..CheckStepTimeAdjust(aPathWayID,aStepID)
		If TimeAdjust'="" {
			Set Type="步骤时间调整"
			Set Code=$list(TimeAdjust,1)
			Set Desc=$list(TimeAdjust,2)
			Set num=$i(^TMP($zn,$j,"QryVarItemList","RST",1))
			Set ^TMP($zn,$j,"QryVarItemList","RST",1,num)=$lb(Code,Desc,Type)
		}
	}
	
	//3 必选项目未执行
	//4 可选项目已执行
	Set IsCheck1=##class(User.DHCMRCBaseConfig).GetValueByCode("CheckFormRequiredItemToSign")
	Set IsCheck2=##class(User.DHCMRCBaseConfig).GetValueByCode("CheckFormOptionalItemToSign")
	Set FormID=+aStepID
	Set EpSub=$p(aStepID,"||",2)
	Set StepSub=$p(aStepID,"||",3)
	Set xItmGrpNo=0
	For {
		Set xItmGrpNo=$o(^DHCMRCi("CPW",0,"ITEM","IndexGroupNo",FormID,EpSub,StepSub,xItmGrpNo))
		Quit:xItmGrpNo=""
		
		Set xItemSub=0
		For {
			Set xItemSub=$o(^DHCMRCi("CPW",0,"ITEM","IndexGroupNo",FormID,EpSub,StepSub,xItmGrpNo,xItemSub))
			Quit:xItemSub=""
			
			Set ItemID=FormID_"||"_EpSub_"||"_StepSub_"||"_xItemSub
			Set objItem=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(ItemID)
			Continue:'$IsObject(objItem)
			
			Set ItemAdjust=..CheckVarStepItemID(aPathWayID,aStepID,ItemID)	//判断是否填写变异记录
			Continue:ItemAdjust=0 //检查变异是否处理过
			
			Set ItemDesc=objItem.CPWSIDesc
			Set objSubCat=objItem.CPWSISubCategory
			Continue:'$IsObject(objSubCat)
			Set SubCatDesc=objSubCat.SISCDesc
			Continue:SubCatDesc=""
			Set SubCatPower=objSubCat.SISCPower
			Set CategDesc=objSubCat.SISCParRef.SICDesc
			If aUserType="D" {
				Continue:(SubCatPower'="OE")&&(SubCatPower'="D")  //诊疗与医嘱
			} Else {
				Continue:(SubCatPower'="NE")&&(SubCatPower'="N")  //护理与护嘱
			}
			Set ItmIsOptional=objItem.CPWSIIsMust
			Set ItmIsOptional=$s(ItmIsOptional["Y":1,1:0)  //是否可选项目
			Set ItmIsOptional=$s(SubCatDesc["可选":1,SubCatDesc["必选":0,1:ItmIsOptional)
			
			Set IsItemImpl=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(aPathWayID,ItemID,aStepID,StepSttDate,StepEndDate)
			
			//3 必选项目未执行
			If (IsCheck1'="N")||(IsCheck1[aUserType) {
				If (ItmIsOptional=0)&&(IsItemImpl'=1)&&(ItemAdjust=1){
					Set Type="必选项目未执行"
					Set Code="CPWITM:"_ItemID_"-"_aStepID
					Set Desc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
					Set num=$i(^TMP($zn,$j,"QryVarItemList","RST",3))
					Set ^TMP($zn,$j,"QryVarItemList","RST",3,num)=$lb(Code,Desc,Type)
				}
			}
			
			//4 可选项目已执行
			If (IsCheck2="Y")||(IsCheck2[aUserType) {
				If (ItmIsOptional=1)&&(IsItemImpl=1){
					Set Type="可选项目已执行"
					Set Code="CPWITM:"_ItemID_"-"_aStepID
					Set Desc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
					Set num=$i(^TMP($zn,$j,"QryVarItemList","RST",4))
					Set ^TMP($zn,$j,"QryVarItemList","RST",4,num)=$lb(Code,Desc,Type)
				}
			}
			
			Set ArcimList=##class(DHCCPW.MR.FORM.ItemImplSrv).GetArcimByItem(ItemID)
			Continue:ArcimList=""
			For indArc=1:1:$listlength(ArcimList) {
				Set ArcimID=$list(ArcimList,indArc)
				Continue:ArcimID=""
				
				Set PHCGeneDesc=""
				Set PHCGeneID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),8)),"^",20)  //通用名
				Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
				Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)    //医嘱名称
				Set PHCGeneDesc=$zcvt(PHCGeneDesc,"U")
				Set ^TMP($zn,$j,"QryVarItemList","GENE",PHCGeneDesc)=""
			}
		}
	}
	//合并症、并发症
	For indComp=1:1:$listlength(compStepList) {
		Set CompStepID=$list(compStepList,indComp)
		Continue:CompStepID=""
		
		Set CompFormID=+CompStepID
		Set CompEpSub=$p(CompStepID,"||",2)
		Set CompStepSub=$p(CompStepID,"||",3)
		Set xItmGrpNo=0
		For {
			Set xItmGrpNo=$o(^DHCMRCi("CPW",0,"ITEM","IndexGroupNo",CompFormID,CompEpSub,CompStepSub,xItmGrpNo))
			Quit:xItmGrpNo=""
			
			Set xItemSub=0
			For {
				Set xItemSub=$o(^DHCMRCi("CPW",0,"ITEM","IndexGroupNo",CompFormID,CompEpSub,CompStepSub,xItmGrpNo,xItemSub))
				Quit:xItemSub=""
				
				Set ItemID=CompFormID_"||"_CompEpSub_"||"_CompStepSub_"||"_xItemSub
				Set objItem=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				
				Set ItemAdjust=..CheckVarStepItemID(aPathWayID,aStepID,ItemID)	//判断是否填写变异记录
				Continue:ItemAdjust=0 //检查变异是否处理过
				
				Set ItemDesc=objItem.CPWSIDesc
				Set objSubCat=objItem.CPWSISubCategory
				Continue:'$IsObject(objSubCat)
				Set SubCatDesc=objSubCat.SISCDesc
				Continue:SubCatDesc=""
				Set SubCatPower=objSubCat.SISCPower
				Set CategDesc=objSubCat.SISCParRef.SICDesc
				If aUserType="D" {
					Continue:(SubCatPower'="OE")&&(SubCatPower'="D")  //诊疗与医嘱
				} Else {
					Continue:(SubCatPower'="NE")&&(SubCatPower'="N")  //护理与护嘱
				}
				Set ItmIsOptional=objItem.CPWSIIsMust
				Set ItmIsOptional=$s(ItmIsOptional["Y":1,1:0)  //是否可选项目
				
				Set IsItemImpl=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(aPathWayID,ItemID,aStepID,StepSttDate,StepEndDate)
				
				//3 必选项目未执行
				If (IsCheck1'="N")||(IsCheck1[aUserType) {
					If (ItmIsOptional=0)&&(IsItemImpl'=1){
						Set Type="必选项目未执行"
						Set Code="CPWITM:"_ItemID_"-"_aStepID
						Set Desc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
						Set num=$i(^TMP($zn,$j,"QryVarItemList","RST",3))
						Set ^TMP($zn,$j,"QryVarItemList","RST",3,num)=$lb(Code,Desc,Type)
					}
				}
				
				//4 可选项目已执行
				If (IsCheck2="Y")||(IsCheck2[aUserType) {
					If (ItmIsOptional=1)&&(IsItemImpl=1){
						Set Type="可选项目已执行"
						Set Code="CPWITM:"_ItemID_"-"_aStepID
						Set Desc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
						Set num=$i(^TMP($zn,$j,"QryVarItemList","RST",4))
						Set ^TMP($zn,$j,"QryVarItemList","RST",4,num)=$lb(Code,Desc,Type)
					}
				}
				
				Set ArcimList=##class(DHCCPW.MR.FORM.ItemImplSrv).GetArcimByItem(ItemID)
				Continue:ArcimList=""
				For indArc=1:1:$listlength(ArcimList) {
					Set ArcimID=$list(ArcimList,indArc)
					Continue:ArcimID=""
					
					Set PHCGeneDesc=""
					Set PHCGeneID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),8)),"^",20)  //通用名
					Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
					Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)    //医嘱名称
					Set PHCGeneDesc=$zcvt(PHCGeneDesc,"U")
					Set ^TMP($zn,$j,"QryVarItemList","GENE",PHCGeneDesc)=""
				}
			}
		}
	}
	
	//2 路径外医嘱
	Set ArcimCategList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
	Set ArcimSubCatList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimSubCat",",")
	Set IsCheck=##class(User.DHCMRCBaseConfig).GetValueByCode("CheckOutOEItemToSign")
	If (IsCheck="Y")||(IsCheck[aUserType) {		//update by liuyh 2016-09-28 修改判断bug
		Set xGeneDesc=""
		For {
			Set xGeneDesc=$o(^DHCMRi("Order","IndexGeneric",aPathWayID,xGeneDesc))
			Quit:xGeneDesc=""
			Continue:$d(^TMP($zn,$j,"QryVarItemList","GENE",$zcvt(xGeneDesc,"U")))
			
			Set xDays=0
			For {
				Set xDays=$o(^DHCMRi("Order","IndexGeneric",aPathWayID,xGeneDesc,1,xDays))
				Quit:xDays=""
				
				Set xDate=StepSttDate-xDays
				For {
					Set xDate=$o(^DHCMRi("Order","IndexGeneric",aPathWayID,xGeneDesc,1,xDays,xDate))
					Quit:xDate=""
					Quit:xDate>StepEndDate
					
					Set xID=0
					For {
						Set xID=$o(^DHCMRi("Order","IndexGeneric",aPathWayID,xGeneDesc,1,xDays,xDate,xID))
						Quit:xID=""
						
						Set objOrder=##class(User.DHCMRClinicalPathWayOrder).GetObjById(xID)
						Continue:'$IsObject(objOrder)
						Set OEItemID=objOrder.CPWOOEItemID
						Set flg=..CheckVarByOrder(aPathWayID,OEItemID,aStepID)
						Continue:flg<1  //检查变异是否处理过
						Set ArcimID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2) //医嘱项
						Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)   //医嘱名称
						
						//根据设置医嘱大类或子类检查路径外医嘱
						Set (ArcimSubCatID,ArcimSubCat,ArcimCategID,ArcimCateg)=""
						Set ArcimSubCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
						Set:ArcimSubCatID'="" ArcimSubCat=$p($g(^ARC("IC",+ArcimSubCatID)),"^",2)
						Set:ArcimSubCatID'="" ArcimCategID=$p($g(^ARC("IC",+ArcimSubCatID)),"^",8)
						Set:ArcimCategID'="" ArcimCateg=$p($g(^OEC("ORCAT",+ArcimCategID)),"^",2)
						Continue:(ArcimCategList'="")&&(ArcimCateg'="")&&($listfind(ArcimCategList,ArcimCateg)>0)
						Continue:(ArcimSubCatList'="")&&(ArcimSubCat'="")&&($listfind(ArcimSubCatList,ArcimSubCat)>0)
						
						Set OrdSttDate=objOrder.CPWOSttDate
						Set:OrdSttDate'="" OrdSttDate=$zd(OrdSttDate,3)
						Set OrdXDate=objOrder.CPWOXDate
						Set:OrdXDate'="" OrdXDate=$zd(OrdXDate,3)
						Set OrdPriority=objOrder.CPWOPriority
						Set OEItemDoc=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",11) //开医嘱医生
						Set OEItemDoc=$p($g(^CTPCP(+OEItemDoc,1)),"^",2)
						
						Set Type="表单外医嘱"
						Set Code="OEITEM:"_OEItemID_"-"_aStepID
						Set Desc="["_OrdPriority_"]"_ArcimDesc_"["_OEItemDoc_"  "_OrdSttDate
						If (OrdPriority["长期")||(OrdXDate'="") {
							Set Desc=Desc_"~"_OrdXDate_"]"
						} Else {
							Set Desc=Desc_"]"
						}
						Set num=$i(^TMP($zn,$j,"QryVarItemList","RST",2))
						Set ^TMP($zn,$j,"QryVarItemList","RST",2,num)=$lb(Code,Desc,Type)
					}
				}
			}
		}
	}
	
	Set xCat=0,Number=0
	For {
		Set xCat=$O(^TMP($zn,$j,"QryVarItemList","RST",xCat))
		Quit:xCat=""
		
		Set xNum=0
		For {
			Set xNum=$O(^TMP($zn,$j,"QryVarItemList","RST",xCat,xNum))
			Quit:xNum=""
			
			Set Number=Number+1
			Set Data=$g(^TMP($zn,$j,"QryVarItemList","RST",xCat,xNum))
			Set ^CacheTemp(repid,ind)=$lb(Number)_Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,"QryVarItemList")
	
	Quit $$$OK
}

ClassMethod QryVarItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarItemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod CheckVarByOrder(aPathWayID As %String, aOEItemID As %String, aStepID As %String) As %String
{
	New (aPathWayID,aOEItemID,aStepID)
	Set return=1
	Quit:(aPathWayID="")||(aOEItemID="")||(aStepID="") return
	
	Set ArcimID=$p($g(^OEORD(+aOEItemID,"I",$p(aOEItemID,"||",2),1)),"^",2) //医嘱项
	
	Set xSub=""
	For {
		Set xSub=$o(^DHCMR("CPW",aPathWayID,"VAR",xSub))
		Quit:xSub=""
		Quit:return<1
		
		Set objVar=##class(User.DHCMRClinicalPathWayVariance).GetObjById(aPathWayID_"||"_xSub)
		If $IsObject(objVar){
			Set UpdoFlag=objVar.CPWVUpdoFlag
			Continue:UpdoFlag="Y"
			Set ExtraValues=objVar.CPWVExtraValues
			Continue:(ExtraValues'[("OEITEM:"_aOEItemID_"-"_aStepID))&&(ExtraValues'[("ARCIM:"_ArcimID_"-"_aStepID))	//update by liuyh 2017-04-21
			//Continue:ExtraValues'[("ARCIM:"_ArcimID)
			Set return=0
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-30
/// Description:  查询步骤时间调整
/// Input：       aPathWayID  : 出入径ID
///               aStepID   : 步骤ID
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(DHCCPW.MR.FORM.VarianceSrv).CheckStepTimeAdjust("15","54||1||1")
ClassMethod CheckStepTimeAdjust(aPathWayID As %String, aStepID As %String) As %List
{
	New (aPathWayID,aStepID)
	Set return=""
	Quit:(aPathWayID="")||(aStepID="") return
	
	//取步骤时长
	Set stepEstimate=##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(aPathWayID,aStepID)
	Quit:stepEstimate="" return
	Set StepTime=$list(stepEstimate,7)
	Set (Day,Hour,Min)=0
	Set tmpStepTime=StepTime
	If tmpStepTime["天" {
		Set Day=+tmpStepTime
		set tmpStepTime=$p(tmpStepTime,"天",2)
	}
	If tmpStepTime["小时" {
		Set Hour=+tmpStepTime
		set tmpStepTime=$p(tmpStepTime,"小时",2)
	}
	Set Min=+tmpStepTime
	
	Set objStep=##class(User.DHCMRCClinPathWaysEpStep).GetObjById(aStepID)
	Quit:'$IsObject(objStep) return
	Set StepTimeUnit=objStep.CPWSUnit
	Set StepDay=objStep.CPWSDay
	Set StepDesc=objStep.CPWSDesc
	Set StepMinTime=+$p(StepDay,"-",1)
	Set:StepMinTime<1 StepMinTime=1
	Set StepMaxTime=+$p(StepDay,"-",2)
	Set:StepMaxTime<StepMinTime StepMaxTime=StepMinTime
	
	Set Desc="",TimeAdjust=""
	If StepTimeUnit="H" {
		Set Hour=(Day*24)+Hour
		If Hour<StepMinTime {
			Set TimeAdjust="Min"
			Set Desc="步骤时间缩短"
		} ElseIf Hour>StepMaxTime {
			Set TimeAdjust="Max"
			Set Desc="步骤时间延长"
		} Else {}
	} ElseIf StepTimeUnit="M" {
		Set Min=((Day*24)+Hour)*60+Min
		If Min<StepMinTime {
			Set TimeAdjust="Min"
			Set Desc="步骤时间缩短"
		} ElseIf Min>StepMaxTime {
			Set TimeAdjust="Max"
			Set Desc="步骤时间延长"
		} Else {}
	} Else {
		Set:Hour>=2 Day=Day+1
		If Day<StepMinTime {
			Set TimeAdjust="Min"
			Set Desc="步骤时间缩短"
		} ElseIf Day>StepMaxTime {
			Set TimeAdjust="Max"
			Set Desc="步骤时间延长"
		} Else {}
	}
	Quit:Desc="" return
	
	Set flg=..CheckVarByTime(aPathWayID,TimeAdjust,aStepID)
	
	Quit:flg<1 return //检查变异是否处理过
	
	Set Code="STEPTIME:"_TimeAdjust_"-"_aStepID
	Set Desc=Desc_"("_StepDesc_")"
	Set return=$lb(Code,Desc)
	Quit return
}

ClassMethod CheckVarByTime(aPathWayID As %String, aTimeAdjust As %String, aStepID As %String) As %String
{
	New (aPathWayID,aTimeAdjust,aStepID)
	Set return=1
	Quit:(aPathWayID="")||(aTimeAdjust="")||(aStepID="") return
	
	Set xSub=""
	For {
		Set xSub=$o(^DHCMR("CPW",aPathWayID,"VAR",xSub))
		Quit:xSub=""
		Quit:return<1
		
		Set objVar=##class(User.DHCMRClinicalPathWayVariance).GetObjById(aPathWayID_"||"_xSub)
		If $IsObject(objVar){
			Set UpdoFlag=objVar.CPWVUpdoFlag
			Continue:UpdoFlag="Y"
			Set ExtraValues=objVar.CPWVExtraValues
			
			Continue:ExtraValues'[("STEPTIME:"_aTimeAdjust_"-"_aStepID)
			Set return=0
		}
	}
	
	Quit return
}

ClassMethod CheckVarStepItemID(aPathWayID As %String, aStepID As %String, aItemID As %String) As %String
{
	New (aPathWayID,aStepID,aItemID)
	Set return=1
	Quit:(aPathWayID="")||(aStepID="")||(aItemID="") return
	
	Set xSub=""
	For {
		Set xSub=$o(^DHCMR("CPW",aPathWayID,"VAR",xSub))
		Quit:xSub=""
		Quit:return<1
		
		Set objVar=##class(User.DHCMRClinicalPathWayVariance).GetObjById(aPathWayID_"||"_xSub)
		If $IsObject(objVar){
			Set UpdoFlag=objVar.CPWVUpdoFlag
			Continue:UpdoFlag="Y"
			Set ExtraValues=objVar.CPWVExtraValues
				
			Continue:ExtraValues'[("CPWITM:"_aItemID_"-"_aStepID)
			Set return=0
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-30
/// Description:  签名时检查变异情况
/// Input：       aPathWayID  : 出入径ID
///               aStepID   : 步骤ID
///               aUserType   : 类型(D医生,N护士)
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(DHCCPW.MR.FORM.VarianceSrv).ChkVarItemList("43626","564||2||1","D")
ClassMethod ChkVarItemList(aPathWayID As %String, aStepID As %String, aUserType As %String) As %String
{
	New (aPathWayID,aStepID,aUserType)
	Set return=0,Count=0
	Quit:(aPathWayID="")||(aStepID="")||(aUserType="") return
	
	Set rs=##Class(%ResultSet).%New("DHCCPW.MR.FORM.VarianceSrv:QryVarItemList")
	Do rs.Execute(aPathWayID,aStepID,aUserType)
	While (rs.Next()){
		Set Count=Count+1
	}
	Do rs.Close()
	
	Set return=Count
	Quit return
}

}
