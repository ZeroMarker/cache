/// 名称: DHCMA.CPW.IO.ToDoc
/// 描述: 给医生站接口
/// 编写者：jiangpengpeng
/// 编写日期: 2018-11-30
Class DHCMA.CPW.IO.ToDoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-30
/// Description:  医生站小图标
/// Input：       aEpisodeID : 就诊ID
/// Return:		  
/// w ##class(DHCMA.CPW.IO.ToDoc).GetCPWStatusToImg("15")
ClassMethod GetCPWStatusToImg(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetCPWStatusToImgErr"
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID),-1)
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Continue:'$IsObject(objPathway)
		
		Set CPWStatus=objPathway.CPStatus
		Continue:(CPWStatus="U")||(CPWStatus="P")
		Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请","T":"不入径",:"")
		Continue:CPWStatus=""
		
		Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
		Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
		Continue:CPWStatus'="入径"
		
		Set:CPWStatus'="" CPWStatus=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",CPWStatus,LangID)
		Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)
		
		Set return=CPWStatus_"【"_CPWDesc_"】"
		Quit
	}
	
	Quit return
	
GetCPWStatusToImgErr
	Quit "-999"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-30
/// Description:  取临床路径信息接口
/// Input：       aEpisodeID : 就诊ID
/// Return:		  返回String: 路径名称_$c(1)_入径天数_$c(1)_当前阶段_$c(1)_状态
/// w ##class(DHCMA.CPW.IO.ToDoc).GetCPWInfoByAdm("30!!1")
ClassMethod GetCPWInfoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetCPWInfoByAdmtErr"
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID),-1)
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Continue:'$IsObject(objPathway)
		
		Set CPWStatus=objPathway.CPStatus
		Continue:(CPWStatus="U")||(CPWStatus="P")
		Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请","T":"不入径",:"")
		Continue:CPWStatus=""
		
		Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
		Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc
		
		Set CPWDays=0
		Set CPActDate=objPathway.CPActDate
		Set CPInDate=objPathway.CPInDate
		Set CPOutDate=objPathway.CPOutDate
		Set:CPWStatus="入径" CPWDays=+$H-CPInDate+1
		Set:CPWStatus="完成" CPWDays=CPActDate-CPInDate+1
		Set:CPWStatus="出径" CPWDays=CPOutDate-CPInDate+1
		
		Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)
		Set:CurrEpisDesc'="" CurrEpisDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurrEpisDesc,LangID)
		Set:CPWStatus'="" CPWStatus=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",CPWStatus,LangID)
		
		Set return=CPWDesc_$C(1)_CPWDays_$C(1)_CurrEpisDesc_$C(1)_CPWStatus
		Quit
	}
	
	Quit return
	
GetCPWInfoByAdmtErr
	Quit "-999"
}

/// Creator：     yankai
/// CreatDate：   2022-10-18
/// Description:  取临床路径信息接口，返回json字符串
/// Input：       aEpisodeID : 就诊ID
/// Return:		  
/// w ##class(DHCMA.CPW.IO.ToDoc).GetCPWInfoByAdmNew("147!!1")
ClassMethod GetCPWInfoByAdmNew(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetCPWInfoNewErr"
	Set LangID= 20,Languages= "CH",HospID=""
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
		Set HospID=+$g(%session.Data("LOGON.HOSPID"))
	}
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set retObj = ##class(%DynamicObject).%New()
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)
	Quit:PathwayID="" return
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
		
	Set CPWStatus=objPathway.CPStatus
	Quit:(CPWStatus="U")||(CPWStatus="P")||(CPWStatus="A") return
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请","T":"不入径",:"")
	Quit:CPWStatus="" return
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
	Set CurrEpisID = objPathway.CPEpisDr.%Id()
	Set CurrEpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc

	Set CPWDays=0
	Set CPActDate=objPathway.CPActDate
	Set CPInDate=objPathway.CPInDate
	Set CPOutDate=objPathway.CPOutDate
	Set:CPWStatus="入径" CPWDays=+$H-CPInDate+1
	Set:CPWStatus="完成" CPWDays=CPActDate-CPInDate+1
	Set:CPWStatus="出径" CPWDays=CPOutDate-CPInDate+1
	
	Set IsTipZLItem=0,IsTipOrdItem=0,OpenOrdPageType="W"
	Set retTipType = ##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIconTipModeToDoc",HospID)
	Set tipZLType = $s(+retTipType'="":$p(retTipType,"||",1),1:2)
	Set tipOrdType = $s(+retTipType'="":$p(retTipType,"||",2),1:2)
	
	Set:CPWStatus="入径" IsTipZLItem = ..ChkCPWItemExeInfo(CurrEpisID, "A", tipZLType)	// 主要诊疗工作执行情况提示
	Set:CPWStatus="入径" IsTipOrdItem = ..ChkCPWItemExeInfo(CurrEpisID, "B", tipOrdType)	// 重点医嘱项目执行情况提示
	Set:$p(IsTipOrdItem,"^",2)="C" OpenOrdPageType="C"	// 待开立医嘱只有草药是点击才打开草药医嘱录入页面
	Do retObj.%Set("OrdPageType",OpenOrdPageType)
	
	If +IsTipZLItem {
		Do retObj.%Set("CIIcon","../images/webemr/macpw.gif")
		Do retObj.%Set("CITip","该路径有必选诊疗项目未执行")
	}Else{
		Do retObj.%Set("CIIcon","../images/webemr/临床路径.png")
		Do retObj.%Set("CITip","点击查看临床路径信息")		
	}
	If +IsTipOrdItem {
		Do retObj.%Set("COIcon","../images/webemr/macpworder.gif")
		Do retObj.%Set("COTip","该路径有必选医嘱项目未执行")
	}Else{
		Do retObj.%Set("COIcon","../images/webemr/macpworder.png")
		Do retObj.%Set("COTip","点击查看路径医嘱信息")		
	}
	
	Set:CPWDesc'="" CPWDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",CPWDesc,LangID)
	Set:CPWStatus'="" CPWStatus=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",CPWStatus,LangID)
	Set:CurrEpisDesc'="" CurrEpisDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurrEpisDesc,LangID)
	Do retObj.%Set("CPWName",CPWDesc)				// 路径名称
	Do retObj.%Set("Status",CPWStatus)				// 路径状态
	Do retObj.%Set("CurEpis",CurrEpisDesc)			// 当前阶段	
	Do retObj.%Set("CPWDays",CPWDays)				// 入径天数
	
	Quit retObj.%ToJSON()
	
GetCPWInfoNewErr
	Quit "-999"
}

/// Creator：     yankai
/// CreatDate：   2022-10-18
/// Description:  取当前阶段必选项目执行情况，根据检查类型返回是否提示
/// Input：       aCPWEpisID:阶段ID，
/// 			  aItemType:项目类别代码(诊疗项目、护理项目、医嘱项目)，
/// 			  aChkType：检查方式（1：只要有任一必选项目已执行则返回不提示，全部必选项目都未执行则返回需提示；
/// 									  2：全部必选项目都已执行则返回不提示，只要有任一必选项目未执行则返回需提示，）
/// Return:		  1：提示临床执行项目；0：不提示临床执行项目
/// w ##class(DHCMA.CPW.IO.ToDoc).ChkCPWItemExeInfo("94||1","A",1)
ClassMethod ChkCPWItemExeInfo(aCPWEpisID As %String, aItemType As %String, aChkType As %String = "1") As %String
{
	New (aCPWEpisID, aItemType, aChkType, %session)
	Set return = ""
	Quit:(aCPWEpisID = "")||(aItemType = "")||((aChkType '= 1)&&(aChkType '= 2)) return
	
	Set aPathwayID = $p(aCPWEpisID,"||",1)
	Set aEpisID = $p(aCPWEpisID,"||",2)
	Quit:(aPathwayID = "")||(aEpisID = "") return
 		
 	Set xImplID="",isEstRequired=0,LinkOrdType=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aCPWEpisID,xImplID))
 		Quit:xImplID=""
 		Quit:return'=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Set FormItemDr = objImpl.CPFormItemDr
 		Continue:'$IsObject(FormItemDr)
 		Set FormItemID = FormItemDr.%Id()
 		Set ItemCatCode = FormItemDr.ItemCatDr.BTTypeDr.BTCode
 		Continue:ItemCatCode'=aItemType			
 		Continue:objImpl.CPPathwayComplDr'=""				// 过滤合并症下项目
 		Continue:'+objImpl.CPIsActive
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	// 两变量值相反
 		
 		Continue:'IsRequired								// 过滤非必选
 		Set isEstRequired=1									// 是否存在必选项标志
 		Set IsImp=objImpl.CPIsImp							// 执行状态
 		
 		// 未执行的项目检查其下主医嘱,返回其下未开立的主医嘱是西药医嘱还是草药类医嘱
 		If (aItemType="B")&&(IsImp'=1){
	 		Set retType = ##class(DHCMA.CPW.BTS.PathFormItemSrv).GetLinkOrdType(FormItemID)
	 		Set:(retType["W")&&(LinkOrdType'["W") LinkOrdType = LinkOrdType_",W"
	 		Set:(retType["C")&&(LinkOrdType'["C") LinkOrdType = LinkOrdType_",C"
	 	}
 		
 		Set:(aChkType=1)&&(IsImp=1) return = 0				// aChkType为1时，任一必选项目已执行则返回不提示
 		Set:(aChkType=2)&&(IsImp'=1) return = 1				// aChkType为2时，任一必选项目未执行则返回需提示
 	}
 	
 	If (isEstRequired=1){
	 	Set:(aChkType=1)&&(return="") return = 1				// aChkType为1时，全部必选项都没执行时返回需提示
 		Set:(aChkType=2)&&(return="") return = 0				// aChkType为2时，全部必选项都已执行则返回不提示
	}Else{
		Set return = 0	
	}
	Set:LinkOrdType'="" LinkOrdType = $e(LinkOrdType,2,$l(LinkOrdType)) 
	Set return = return_"^"_LinkOrdType
 	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2015-06-19
/// Description:	将临床路径对应的医嘱直接增加到医嘱录入界面上
/// Table:        	User.DHCMRCClinPathWaysItmGene
/// Input:        	关联通用名ID^医嘱项ID^整包装数量^单次剂量^剂量单位^频次^用法^疗程^备注
/// Return:       	return=0：成功
/// Others:			w ##class(DHCMA.CPW.IO.ToDoc).AddMRCPWItemToList("AddCopyItemToList","",$c(1)_"^166^^^^^^^^^.0","2","1752")
ClassMethod AddMRCPWItemToList(itmjs As %Library.String = "", itmjsex As %Library.String = "", aOrderList As %String, aHospID As %String = "", aEpisodeID As %String = "") As %String
{
	s jsval=""
	
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
		Set BodyPartLabel=$p(arcimInfo,"^",12)
		Set DefSensitive=$p(arcimInfo,"^",13)
		
		Set OrderSeqNo=+$p(OrderSeqNos,".",1)
		Set OrderSeqSub=+$p(OrderSeqNos,".",2)
		Set StepItemID=$p(GeneID,"||",1)_"||"_$p(GeneID,"||",2)_"||"_$p(GeneID,"||",3)_"||"_$p(GeneID,"||",4)
		
		If $l(ArcimID,"||")=2 {
			Set (OrderPrior,OrderDoseUOM,OrderFreq,OrderFreqFactor,OrderFreqInterval)=""
			Set (OrderInstr,OrderDur,OrderDurFactor,OrderPackUOM)=""
			Set:OrderPriorID="" OrderPriorID=tOrderPriorID
			Set:OrderPriorID'="" OrderPrior=$p($g(^OECPR(OrderPriorID)),"^",2)
			Set:+OrderDoseUOMID>0 OrderDoseUOM=$P(^CT("UOM",OrderDoseUOMID),"^",2)
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
			Set ItemData=ItemData_"^^^"	 //中草药备注项^^
			Set ItemData=ItemData_"^"_DefSensitive
			Set ItemData=ItemData_"^^^^^"_BodyPartLabel	//检查部位
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
				If (xSeqNo=0){
					Set tOrderSeqNo=xSubNo
				}
				Set jsval=jsval_"Copyary[Copyary.length]="""_ArcimID_"!"_tOrderSeqNo_"!"_ItemData_"!"_OrderType_"!!Order!"_StepItemID_""";"
			}elseif(ArcimID[":"){ //自定义方剂
				Set TCMID=$p(ArcimID,":",2)
				Continue:TCMID=""
				Set rs=##Class(%ResultSet).%New("DHCMA.CPW.BTS.PathFormTCMSrv:QueryTCMDtl")
				Do rs.Execute(TCMID)
				Set tOrderSeqNo=0
				While (rs.Next()) {
					Set ArcimID=rs.Data("ArcID")
					//医嘱大类
					Set OrderType=""
					Set SubCatRowId=$p(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1),"^",10)
					Set:SubCatRowId'="" OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
					Set tOrderSeqNo=tOrderSeqNo+1
					Set DoseQty=rs.Data("DoseQty")
					Set CTUnit=rs.Data("CTUnit")
					Set OrderDoseUOMID=""
					Set ArcResume=rs.Data("ArcResume")
					//医嘱信息
					Set (OrderFreq,OrderFreqID,OrderFreqFactor,OrderFreqInterval,OrderInstr,OrderInstrID,OrderDur,OrderDurID,OrderDurFactor,
						OrderPackQty,OrderPackUOM,OrderPackUOMID,OrderPrior,OrderPriorID,OrderResume,BodyPartLabel)=""
					Set ItemData=DoseQty_$C(1)_CTUnit_$C(1)_OrderDoseUOMID
					Set ItemData=ItemData_"^"_OrderFreq_$C(1)_OrderFreqID_$C(1)_OrderFreqFactor_$C(1)_OrderFreqInterval
					Set ItemData=ItemData_"^"_OrderInstr_$C(1)_OrderInstrID
					Set ItemData=ItemData_"^"_OrderDur_$C(1)_OrderDurID_$C(1)_OrderDurFactor
					Set ItemData=ItemData_"^"_OrderPackQty_$C(1)_OrderPackUOM_$C(1)_OrderPackUOMID
					Set ItemData=ItemData_"^"_OrderPrior_$C(1)_OrderPriorID_$c(1)_OrderResume
					Set ItemData=ItemData_"^^^"  //医嘱套ID、空、医嘱子类ID
					Set ItemData=ItemData_"^"_ArcResume_"^^"	 //中草药备注项^^
					Set ItemData=ItemData_"^^^^^^"_BodyPartLabel	//检查部位
					Set jsval=jsval_"Copyary[Copyary.length]="""_ArcimID_"!"_tOrderSeqNo_"!"_ItemData_"!"_OrderType_"!!OSItem!"_StepItemID_""";"
				}
			}Else {  //医嘱套
				Set ARCOSID=ArcimID
				Continue:ARCOSID=""
				Set rs=##Class(%ResultSet).%New("DHCMA.CPW.BTS.PathFormEpSrv:QryOrderByARCOS")			//间接调用医生站医嘱套明细query
				Do rs.Execute(ARCOSID,aHospID,aEpisodeID)
				Set columns = rs.GetColumnCount()
				While (rs.Next()) {
					Set ArcimID=$ZCVT(rs.Data("ARCIMRowid"),"O","JS")
					Continue:$d(^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,ARCOSID,"Open"))&&('$d(^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,ARCOSID,ArcimID)))	//过滤掉在下医嘱时没有勾选的医嘱
					
					//进行关联序号检查，防止多组医嘱间存在相同医嘱   add by yankai20211020
					Set regSeqNo=$g(^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,ARCOSID,ArcimID))
					Set tOrderSeqNo=$ZCVT(rs.Data("SeqNo"),"O","JS")
					Continue:regSeqNo'=tOrderSeqNo					
					
					Set ItemData=$ZCVT(rs.Data("ARCItemData"),"O","JS")
					//Set ItemData=$tr(ItemData,"~","^")
					Set ItemData=$tr(ItemData,"~",$c(1))
					Set $p(ItemData,"^",24)=##class(ext.util.String).Replace($p(ItemData,"^",24),"@", $C(2))
					Set OrderType=$ZCVT(rs.Data("ARCOrdType"),"O","JS")
					Set jsval=jsval_"Copyary[Copyary.length]="""_ArcimID_"!"_tOrderSeqNo_"!"_ItemData_"!"_OrderType_"!!OSItem!"_StepItemID_""";"
				}
				Do rs.Close()
				Kill ^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,ARCOSID)
			}
		}
	}
	Kill arrOrderInfo
	Kill ^tmpDHCMA.CPW.ARCOSItems(aEpisodeID)
	
	If (itmjs'="")&&(jsval'="") {
		Set jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary);"
		&javascript<#(jsval)#>
	}
	
	Quit 0
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-30
/// Description:  判断当前阶段是否有未完成的重点医嘱项目
/// Input：       aEpisodeID : 就诊ID
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.IO.ToDoc).CheckHaveUnExItm("30!!1")
ClassMethod CheckHaveUnExItm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="CheckHaveUnExItmErr"
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID),-1)
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Continue:'$IsObject(objPathway)
		
		Set CPWStatus=objPathway.CPStatus
		Continue:(CPWStatus="U")||(CPWStatus="P")
		Quit:CPWStatus'="I"
		Set aPathwayID=xPathwayID
		Set aEpisID=objPathway.CPEpisDr.%Id()
		
		Set xImplID=""
	 	For {
	 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
	 		Quit:xImplID=""
	 		
	 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
	 		Continue:'$IsObject(objImpl)
	 		Continue:objImpl.CPPathwayComplDr'=""
	 		
	 		Set IsActive=objImpl.CPIsActive
	 		Continue:'IsActive
	 		
	 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
	 		Continue:(TypeDesc'="重点医嘱")
	 		
	 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	
	 		Continue:IsRequired		//过滤必选项
	 		
			Set IsImp=objImpl.CPIsImp
			Continue:IsImp		//过滤已执行
			
			Set IsVar=0	//是否变异
			Set xVarID=""
	 		For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,aPathwayID_"||"_xImplID,xVarID))
				Quit:xVarID=""
				
		 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
		 		Continue:'$IsObject(objVar)
			 	Continue:'objVar.CPIsActive
		 		Set IsVar=1
		 		Quit
		 	}
		 	Continue:IsVar		//过滤已添加变异
		 	
		 	Set return=1
		 	Quit
	 	}
		Quit
	}
	
	Quit return
	
CheckHaveUnExItmErr
	Quit "-999"
}

/// Creator：     yankai
/// CreatDate：   2020-05-14
/// Description:  医生站医嘱状态修改时调用接口（合并门诊路径、住院路径）
/// Input：       aEpisodeID : 就诊ID
/// 			aType : 1停止2撤销3作废
/// 			aOrdIDStr : 医嘱ID串^
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.IO.ToDoc).ChangeOrdStatus("1597","2","1483||4^1483||5","10209!!1")
ClassMethod ChangeOrdStatus(aEpisodeID As %String, aType As %String, aOrdIDStr As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aType,aOrdIDStr,aUserID)
	Set return=""
	
	//医嘱状态改变时修改临床路径信息按就诊类型区分门诊路径和住院路径
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	If (AdmType="O") {
		Set return=..ChangeOrdStatusToOPCPW(aEpisodeID,aType,aOrdIDStr,aUserID)
	}else{
		Set return=..ChangeOrdStatusToIPCPW(aEpisodeID,aType,aOrdIDStr,aUserID)
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-01-08
/// Description:  医生站操作时调用接口（To住院临床路径）
/// Input：       aEpisodeID : 就诊ID
/// 			aType : 1停止2撤销3作废
/// 			aOrdIDStr : 医嘱ID串^
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.IO.ToDoc).ChangeOrdStatusToIPCPW(7,2,"27||54",4634)
ClassMethod ChangeOrdStatusToIPCPW(aEpisodeID As %String, aType As %String, aOrdIDStr As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aType,aOrdIDStr,aUserID)
	Set return=""
	//S ^tmpDHCMACPWOrd=$lb(aEpisodeID,aType,aOrdIDStr,aUserID)
	Quit:(aEpisodeID="")||(aType="")||(aOrdIDStr="") return
	
	Set $ZT="ChangeOrdStatusErr"
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set CPWStatus=objPathway.CPStatus
	Quit:CPWStatus'="I" return		//只处理入径状态
	
	Set CurrEpisID=objPathway.CPEpisDr.%Id()	//当前阶段ID，只处理当前阶段
	
	For ind=1:1:$l(aOrdIDStr,"^") {
		Set xOrdID=$p(aOrdIDStr,"^",ind)
		Continue:xOrdID=""
		
		//删除路径外医嘱的变异记录.路径外医嘱没有医嘱执行记录和项目执行记录
		Set ret=..ChangeVar(PathwayID,CurrEpisID,xOrdID)
		
		//ret<0说明该医嘱不是路径外医嘱，则需要撤销医嘱执行记录和项目执行记录
		If (ret<0) {
			Set xImpl=""
			For {
				Set xImpl=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofOrd",xOrdID,PathwayID,xImpl))
				Quit:xImpl=""
				
				Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImpl)
				Continue:'$IsObject(objImpl)
				Set EpisID=objImpl.CPEpisDr.%Id()
				Continue:EpisID'=CurrEpisID
				
				Set xCPOrd=""
				For {
					Set xCPOrd=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofOrd",xOrdID,PathwayID,xImpl,xCPOrd))
					Quit:xCPOrd=""
					
					Set objCPOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(PathwayID_"||"_xImpl_"||"_xCPOrd)
					Continue:'$IsObject(objCPOrd)
					
					Set IsChange=0
					If ((aType="2")||(aType="3")) {	 //撤销相关医嘱的执行记录
						Set objCPOrd.CPIsActive=0
						Set objCPOrd.CPActDate=+$H
						Set objCPOrd.CPActTime=$p($h,",",2)
						Set objCPOrd.CPActUserID=aUserID
						
						Set sc=objCPOrd.%Save()
						If $system.Status.IsError(sc) {        //检查Save是否成功
					   		//Do $system.OBJ.DisplayError(sc) 
					   		Set return=-1
						}Else{
							Set return=objCPOrd.%Id()
							Set IsChange=1
						}
					} Else {
						//停止长期医嘱不需要处理
						
					}
					Continue:IsChange=0
					
					//修改项目执行状态
					Set ret=..ChangeImpl(PathwayID,xImpl)
				}
			}
		}
	}
	
	Quit return
ChangeOrdStatusErr
	Quit "-999"
}

/// Creator：     yankai
/// CreatDate：   2019-01-08
/// Description:  门诊临床路径医生站医嘱状态改变调用接口
/// Input：       aEpisodeID : 就诊ID
/// 			  aType : 2撤销
/// 			  aOrdIDStr : 医嘱ID串^
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.IO.ToDoc).ChangeOrdStatusToOPCPW("1597","2","1483||4^1483||5","10209!!1")
ClassMethod ChangeOrdStatusToOPCPW(aEpisodeID As %String, aType As %String, aOrdIDStr As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aType,aOrdIDStr,aUserID)
	Set return=""
	Quit:(aEpisodeID="")||(aType="")||(aOrdIDStr="") return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	
	//取本次就诊下路径执行的所有阶段并去重
	Set xEpisDr="",listEpisIDs=""
	For {
		Set xEpisDr=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,xEpisDr))
		Quit:xEpisDr=""
		
		Set xVisitID=""
		For {
			Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,xEpisDr," I",xVisitID))
			Quit:xVisitID=""
			
			Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
			Continue:'$IsObject(objVisit)
			Continue:'$IsObject(objVisit.CPPathwayDr)
			Continue:'$IsObject(objVisit.CPEpisDr)
			Set:$lf(listEpisIDs,xEpisDr)=0 listEpisIDs=listEpisIDs_$lb(xEpisDr)		
		}
	}
	
	//事务处理
	Set $ZT="ChgOrdStatusToOPCPWErr"
	TStart
	
	For ind=1:1:$l(aOrdIDStr,"^") {
		Set xOEORIRowId=$p(aOrdIDStr,"^",ind)
		Continue:xOEORIRowId=""
		
		Set EpisID=""
		For indx=1:1:$ll(listEpisIDs){
			Set EpisID=$li(listEpisIDs,indx)
			Continue:EpisID=""
			Set PathwayID=$p(EpisID,"||",1)
			Set xSubImplID=""
			For {
				Set xSubImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,EpisID,xSubImplID))	
				Quit:xSubImplID=""
				
				Set xSubOrdID="",IsChange=0
				For {
					Set xSubOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofOrd",xOEORIRowId,PathwayID,xSubImplID,xSubOrdID))
					Quit:xSubOrdID=""
					
					Set objOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(PathwayID_"||"_xSubImplID_"||"_xSubOrdID)
					Continue:'$IsObject(objOrd)
					Set objOrd.CPIsActive=0
					Set objOrd.CPActDate=+$H
					Set objOrd.CPActTime=$p($h,",",2)
					Set objOrd.CPActUserID=aUserID
					Set sc=objOrd.%Save()
							
					If $system.Status.IsError(sc) {  
						//Do $system.OBJ.DisplayError(sc) 
						TRollBack
						Set return=-1
						Quit
					}Else{
						Set return=objOrd.%Id()
						Set IsChange=1
					}					
				}
				Quit:return<0
				
				If IsChange=1{
					//（1）项目执行情况检查，是否要修改项目执行状态（执行原则：医嘱项目下至少有一条医嘱执行，则该项目执行）
					Set FlagExeImpl=..ChkImplExeInfo(PathwayID_"||"_xSubImplID,aUserID)
					If FlagExeImpl<0{
						TRollBack
						Set return=-2
						Quit	
					}
					//（2）必选项目未执行变异检查，符合条件添加变异
					Set FlagNoExeVar=""
					Set:FlagExeImpl>0 FlagNoExeVar=..ChkNoExeImplVar(PathwayID_"||"_xSubImplID,aEpisodeID)
					If (FlagExeImpl>0)&&(+FlagNoExeVar<0){
						TRollBack
						Set return=-3
						Quit	
					}
				}
				//（3）已记录的路径外医嘱变异检查，符合条件撤销
				Set FlagOutPathOrdVar=..ChkOutPathOrdVar(EpisID,xOEORIRowId)
				If FlagOutPathOrdVar<0{
					TRollBack
					Set return=-4
					Quit	
				}	
			}
			Quit:return<0	
		}
		Quit:return<0
	}
	Quit:return<0 return
	
	If $TLevel>0 TCommit
	Quit return
	
ChgOrdStatusToOPCPWErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// （1）	
/// Creator:		yankai
/// CreateDate:		2020-05-12
/// Description:	门诊路径撤销医嘱后，项目执行情况检查并修改项目执行状态（执行原则：医嘱项目下至少有一条主医嘱被执行，则该项目执行）
/// Input:			aImplID：项目ID
/// 				aUserID：撤销医嘱用户ID
/// Return:			0：项目执行状态未改变
/// 					>0:项目执行状态修改成功,返回项目ID（已执行——>未执行）
/// 					<0:项目执行状态修改失败
/// w ##class(DHCMA.CPW.IO.ToDoc).ChkImplExeInfo()
ClassMethod ChkImplExeInfo(aImplID As %String, aUserID As %String) As %String
{
	New (aImplID,aUserID)
	Set return=0
	Quit:(aImplID="")||(aUserID="") return
	
	Set PathwayID=$p(aImplID,"||",1)
	Set SubImplID=$p(aImplID,"||",2)
	Set xOeOrdID="",IsExe=0
	For {
		//Set xSubOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",xOEORIRowId,PathwayID,xSubImplID,xSubOrdID))
		Set xOeOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",xOeOrdID))
		Quit:xOeOrdID=""
		Quit:IsExe=1
		
		Set xSubOrdID=""
		For {
			Set xSubOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",xOeOrdID,PathwayID,SubImplID,xSubOrdID))
			Quit:xSubOrdID=""
			Quit:IsExe=1
			
			Set objOrd=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_SubImplID_"||"_xSubOrdID)
			Continue:'$IsObject(objOrd)
			Continue:objOrd.CPIsActive=0					//撤销的医嘱执行记录过滤
			Continue:objOrd.CPFormOrdDr=""					//方剂医嘱执行记录过滤
			Continue:objOrd.CPFormOrdDr.OrdIsFluInfu'=1		//相关联医嘱为非主医嘱的过滤
			Set IsExe=1	
		}
	}
	
	//如果项目下没有主医嘱被执行，则修改项目执行状态为未执行
	If IsExe=0{
		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aImplID)
		Quit:'$IsObject(objImpl) return
		
		Set objImpl.CPIsImp=0
		Set objImpl.CPActDate=+$h
		Set objImpl.CPActTime=$p($h,",",2)
		Set objImpl.CPActUserID=aUserID
		Set sc=objImpl.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
   			Do $system.OBJ.DisplayError(sc) 
   			Set return=-1
		}Else{
			Set return=objImpl.%Id()
		}
		Do objImpl.%Close()
	}
	Quit return
}

/// （2）
/// Creator:		yankai
/// CreatDate:		2020-05-13
/// Description:	对于取消执行状态的项目,如果满足1、项目记录所属阶段在本次就诊有Visit记录；2、项目记录所属阶段已阶段确认；3、项目为必选项目，则需添加必选项目未执行变异
/// Input:			aImplID:项目执行记录ID,aEpisodeID:就诊ID
/// Return:			
/// w ##class(DHCMA.CPW.IO.ToDoc).ChkNoExeImplVar()
ClassMethod ChkNoExeImplVar(aImplID As %String, aEpisodeID) As %String
{
	New (aImplID, aEpisodeID)
	Set return=0
	Quit:(aImplID="")||(aEpisodeID="") return
	
	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aImplID)
	Quit:'$IsObject(objImpl) return
	Quit:objImpl.CPIsImp=1																	//项目已执行直接退出
	Quit:objImpl.CPFormItemDr.ItemIsOption'=0 return										//非必选项目执行退出
	Set EpisID=objImpl.CPEpisDr.%Id()
	Set PathwayID=$p(aImplID,"||",1)
	
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisID(aEpisodeID,EpisID,"I")	//获取当前就诊下该阶段是否有有效记录
	Quit:'$IsObject(objVisit) return
	Quit:objVisit.CPEpisDr.CPIsConfirm'=1 return											//未进行阶段确认无需该检查，直接退出
	Set VisitID=objVisit.%Id()
	
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)
	Set VarRsnDicIDStr=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPVarRsnIDs",AdmHospID)	
	Set VarRsnID=$p(VarRsnDicIDStr,",",1)  													//必选项目未执行变异原因ID
	Set objVarRsn=##class(DHCMA.CPW.BT.PathVariat).GetObjById(VarRsnID)
	Quit:'$IsObject(objVarRsn) return
	Set VarRsnTxt=objVarRsn.BTDesc
	
	Set (VariatTxt,VariatCat)=""
 	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",PathwayID,EpisID,aImplID,xVarID))
		Quit:xVarID=""
		
 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
 		If ($IsObject(objVar)) {
	 		Continue:'objVar.CPIsActive
	 		
 			Set VariatTxt=objVar.CPVariatTxt
 			Set VariatCat=objVar.CPVariatDr.BTDesc
 		}
		Quit
	}
	
	Set InputStr=PathwayID
	Set InputStr=InputStr_"^"_xVarID
	Set InputStr=InputStr_"^"_VarRsnID
	Set InputStr=InputStr_"^"_VarRsnTxt
	Set InputStr=InputStr_"^"_EpisID
	Set InputStr=InputStr_"^"_aImplID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	 
	Set return=##class(DHCMA.CPW.CP.PathwayVar).Update(InputStr)
	Quit return
}

/// （3）
/// Cretor:			yankai
/// CreateDate:		2020-05-14
/// Description:	检查是否存在路径外医嘱变异，若存在则撤销
/// w ##class(DHCMA.CPW.IO.ToDoc).ChkOutPathOrdVar()
ClassMethod ChkOutPathOrdVar(aEpisID As %String, aOEORIRowId As %String) As %String
{
	New (aEpisID,aOEORIRowId)
	Set return=0
	Quit:(aEpisID="")||(aEpisID'["||")||(aOEORIRowId="") return
	
	Set PathwayID=$p(aEpisID,"||",1)
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",PathwayID,aEpisID,xVarID))
		Quit:xVarID=""
	
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
		Quit:'$IsObject(objVar)
		Continue:objVar.CPImplDr'=""				//路径外医嘱无关联项目，有的直接过滤
		Continue:objVar.CPIsActive=0
		Continue:objVar.CPOrdDID'=aOEORIRowId
		
		Quit	
	}
	Set:xVarID'="" return=##class(DHCMA.CPW.CP.PathwayVar).Delete(PathwayID_"||"_xVarID)	//删除符合条件的路径外医嘱变异记录
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-01-08
/// Description:  修改项目的执行状态
/// Input：       
/// Return:		  返回String: 1是
/// w ##class(DHCMA.CPW.IO.ToDoc).ChangeImpl(7,18)
ClassMethod ChangeImpl(aCPWID As %String, aImplID As %String) As %String
{
	New (aCPWID,aImplID)
	Set return=""
	Quit:(aCPWID="")||(aImplID="") return
	
	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aCPWID_"||"_aImplID)
	Quit:'$IsObject(objImpl) return
	Quit:'objImpl.CPIsActive return
	Quit:'objImpl.CPIsImp return
	
	Set IsImpl=0
	Set xFormOrdID=""
	For {
		Set xFormOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",aCPWID,aImplID,xFormOrdID))
		Quit:xFormOrdID=""
		
		Set objFormOrd=##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(xFormOrdID)
		Continue:'$IsObject(objFormOrd)
		Set IsMain=objFormOrd.OrdIsFluInfu	//是否主医嘱
		Continue:'IsMain
		
		Set xCPOrdID=""
		For {
			Set xCPOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",aCPWID,aImplID,xFormOrdID,xCPOrdID))
			Quit:xCPOrdID=""
			
			Set objCPOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(aCPWID_"||"_aImplID_"||"_xCPOrdID)
			Continue:'$IsObject(objCPOrd)
			
			Set IsActive=objCPOrd.CPIsActive
			Continue:'IsActive
			
			Set IsImpl=1	//存在已经执行的有效的主医嘱
			Quit
		}
		Quit:IsImpl=1
	}
	
	//不存在有效的主医嘱则该项目状态改为未执行
	If (IsImpl=0) {
		Set return=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aCPWID,aImplID,"","SYS","0","1")
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2020-05-18
/// Description:  因医嘱状态改变而撤销变异
/// Input：       
/// Return:		  
/// w ##class(DHCMA.CPW.IO.ToDoc).ChangeVar(7,18)
ClassMethod ChangeVar(aCPWID As %String, aEpisID As %String, aOrdID As %String) As %String
{
	New (aCPWID,aEpisID,aImplID,aOrdID)
	Set return=-1
	Quit:(aCPWID="")||(aEpisID="")||(aOrdID="") return
	
	Set IsVar=0
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aCPWID,aEpisID,xVarID))
		Quit:xVarID=""
		
 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aCPWID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	Continue:'objVar.CPIsActive
	 	Continue:objVar.CPOrdDID=""
	 	
	 	Set OrdDID=$p(objVar.CPOrdDID,"^",1)
	 	Continue:OrdDID'=aOrdID
	 	
 		Set IsVar=xVarID
 		Quit
 	}
 	
	Set:IsVar>0 return=##class(DHCMA.CPW.CP.PathwayVar).Delete(aCPWID_"||"_IsVar)
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-11-19
/// Description:  门诊路径医嘱审核后，将医嘱OrderID插入执行记录表
/// Table：       
/// Input：       aEpisodeID,aOrderID,aUserID,aType
/// Return：
/// w ##Class(DHCMA.CPW.IO.ToDoc).ExeOrderRewriteCPW(aEpisodeID,OrderStr,aUserID,aType)
ClassMethod ExeOrderRewriteCPW(aEpisodeID As %String, OrderStr As %String, aUserID As %String, aType As %String = "W") As %String
{
	New (aEpisodeID,OrderStr,aUserID,aType)
	Set return=""
	Quit:(aEpisodeID="")&&(OrderStr="") return

	//医嘱审核回写分门诊路径还是住院路径
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	If (AdmType="O") {
		Set return=##class(DHCMA.CPW.OPCPS.InterfaceSrv).ExecuteOPCPWOrder(aEpisodeID,OrderStr,aUserID,aType)
	}else{
		Set return=##class(DHCMA.CPW.CPS.InterfaceSrv).ExecuteOrder(aEpisodeID,OrderStr,aUserID,aType)	
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-11-27
/// Description:  统一封装获取临床路径状态接口给医生站
/// Table：       
/// Input：       aEpisodeID
/// Return：
/// w ##Class(DHCMA.CPW.IO.ToDoc).GetPathStatusToDOC(aEpisodeID)
ClassMethod GetPathStatusToDOC(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return

	//医嘱审核回写分门诊路径还是住院路径
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	If (AdmType="O") {
		Set return=##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOPCPWStatusToDOC(aEpisodeID)
	}else{
		Set return=##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatusToDOC(aEpisodeID)
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2020-10-15
/// Description:  统一封装判断路径是否已结束（完成或出径）
/// Table：       
/// Input：       aEpisodeID
/// Return：	  0：未结束（入径）；1：已结束（完成或出径）；空：未入径
/// w ##Class(DHCMA.CPW.IO.ToDoc).GetIsCloseCPW(760)
ClassMethod GetIsCloseCPW(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//医嘱审核回写分门诊路径还是住院路径
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr

	Set status=""
	If (AdmType="O") {
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
		Quit:'$IsObject(objVisit) return
		Set status=objVisit.CPPathwayDr.CPStatus
	}else{
		Set status=##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatus(aEpisodeID)
	}
	If status="I" {
		set return=0
	}elseif (status="O")||(status="C"){
		set return=1
	}else{
		set return=""
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-07-12
/// Description:  提供护理组是否需关注接口（路径未结束为需关注，结束或未入径则不需关注）
/// Table：       
/// Input：       aEpisodeID
/// Return：	  1：需关注；0：不需关注
/// w ##Class(DHCMA.CPW.IO.ToDoc).IsNeedFocusCPW(760)
ClassMethod IsNeedFocusCPW(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID=0 return
	
	Set ret=..GetIsCloseCPW(aEpisodeID)
	Set:ret=0 return=1
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-07-15
/// Description:  根据就诊由系统完成路径，提供医生站出院结算时按需调用
/// Table：       
/// Input：       aEpisodeID
/// Return：	  
/// w ##Class(DHCMA.CPW.IO.ToDoc).AutoCloseCPW(760,session['LOGON.CTLOCID'],session['LOGON.USERID'],session['DHCMA.CTWARDID'])
ClassMethod AutoCloseCPW(aEpisodeID As %String, aUserID As %String, aLocID As %String, aWardID As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID,aWardID)
	Set return=""
	Quit:(aEpisodeID="")||(aLocID="")||(aUserID="") return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	
	Set:aUserID'["!!" aUserID=aUserID_"!!"_SYSDr
	Set:aLocID'["!!" aLocID=aLocID_"!!"_SYSDr
	Set:(aWardID'="")&&(aWardID'["!!") aWardID=aWardID_"!!"_SYSDr
	
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(aUserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	
	Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)
	Quit:xPathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
	Quit:'$IsObject(objPathway) return
	Quit:objPathway.CPStatus'="I" return
	
	Set CPWInupt=xPathwayID_"^"_aUserID_"^"_DocID_"^"_aLocID_"^"_aWardID
	Set ret=##class(DHCMA.CPW.CP.Pathway).CloseCPW(CPWInupt,"^")
	
	Quit ret
}

}
