/// 名称: DHCMA.CPW.CPS.InterfaceSrv
/// 描述: 临床路径调试bug
/// 编写者：jiangpengpeng
/// 编写日期: 2019-02-25
Class DHCMA.CPW.CPS.DebugSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-02-25
/// Description:  调试一条没有匹配到的医嘱
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       aEpisodeID,aOrderID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.DebugSrv).ExecuteOrder("800850!!1","788225||27","3326")
ClassMethod ExecuteOrder(aEpisodeID As %String, aOrderID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aOrderID,aUserID)
	Set return=""
	Quit:(aEpisodeID="")&&(aOrderID="") return
	
	Set CPWStatus=##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatusToDOC(aEpisodeID)
	Quit:CPWStatus'="1" return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aUserID'["!!" aUserID=aUserID_"!!"_SYSDr
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)
	
	Set ComDescType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWGetCommonDescByType",AdmHospID)	//1处方通用名，2化学通用名
	
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录，即当前路径
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	Set EpisID=objPathway.CPEpisDr.%Id()		//当前执行阶段
	set EpisID="2||1"
	//TStart
	
	//For OrderInd=1:1:$l(OrderStr,"^") {
		/*Set aOEItmMastID=$p($p(OrderStr,"^",OrderInd),"*",1)
		Continue:aOEItmMastID=""
		Set aOEItemID=$p($p(OrderStr,"^",OrderInd),"*",2)
		Continue:aOEItemID=""
		*/
		set aOEItemID=aOrderID
		Set xOESubID=$p(aOEItemID,"||",2)
		
		Set aOEItmMastID= $p($g(^OEORD(+aOEItemID,"I",xOESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
		Set aPHCGeneDesc=""
		If (ComDescType="1") {
			Set PHCGeneID=$p($g(^ARCIM(+aOEItmMastID,+$p(aOEItmMastID,"||",2),8)),"^",20)
			Set:PHCGeneID'="" aPHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)	//处方通用名
		} ElseIf (ComDescType="2") {
			Set PHChemical=##class(PHA.FACE.OUT.Com).GetPHChemicalByArc(aOEItmMastID)
			Set aPHCGeneDesc=$p(PHChemical,"^",3)	//化学通用名
		} Else {
		}
		If (aPHCGeneDesc="") {
			Set ArcimDesc=$p($g(^ARCIM(+aOEItmMastID,+$p(aOEItmMastID,"||",2),1)),"^",2)    //医嘱名称
			Set aPHCGeneDesc=ArcimDesc
		}
		
		Set IsMatch=0	
		Set xImplID=""
	 	For {
	 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,EpisID,xImplID))
	 		Quit:xImplID=""
	 		
	 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
	 		Continue:'$IsObject(objImpl)
	 		
	 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
	 		Continue:(TypeDesc'="重点医嘱")
	 		
	 		Set FormItemID=objImpl.CPFormItemDr.%Id()
	 		Set FormID =$p(FormItemID,"||",1)
			Set FormEpID =$p(FormItemID,"||",2)
			Set FormEpItemID =$p(FormItemID,"||",3)
			
			Set xFormOrdID=""
			For {
				Set xFormOrdID=$o(^DHCMA.CPW.BT.PathFormD(FormID,"EP",FormEpID,"ITM",FormEpItemID,"ORD",xFormOrdID))
				Quit:xFormOrdID=""
				
				Set FormOrdID=FormID_"||"_FormEpID_"||"_FormEpItemID_"||"_xFormOrdID
				Set objOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(FormOrdID)
				Continue:'$IsObject(objOrd)
				Set OrdMastID=objOrd.OrdMastID
				
				Set IsExe=0	//项目是否执行
				Set IsMainord=objOrd.OrdIsFluInfu	//是否主医嘱
				Set:IsMainord IsExe=1	//只有主医嘱执行，此项目才算是执行
				
				//通过医嘱项ID匹配(ARC_ItmMast.RowID)
				//If (OrdMastID=aOEItmMastID) {
				//通过通用名匹配
				Set PHCGeneDesc=""
				If (ComDescType="1") {
					Set PHCGeneID=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),8)),"^",20)
					Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)	//处方通用名
				} ElseIf (ComDescType="2") {
					Set PHChemical=##class(PHA.FACE.OUT.Com).GetPHChemicalByArc(OrdMastID)
					Set PHCGeneDesc=$p(PHChemical,"^",3)	//化学通用名
				} Else {
				}
				If (PHCGeneDesc="") {
					Set ArcimDesc=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),1)),"^",2)    //医嘱名称
					Set PHCGeneDesc=ArcimDesc
				}
				
				If (aPHCGeneDesc=PHCGeneDesc) {
					Set ImplID=xImplID
					Set IsMatch=1
					Set ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(PathwayID,ImplID,aOEItemID,aUserID,IsExe,0)
					w FormOrdID,!
					If (ret<0) {
						Set return=-2
						//TRollBack
						Quit
					} Else {
						Set Parref=PathwayID_"||"_ImplID
						Set Child=""
						
						Set Inputs=Parref_"^"_Child_"^"_FormOrdID_"^"_aOEItemID_"^"_aUserID
						Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
						If (ret<0) {
							Set return=-3
							//TRollBack
							Quit
						}
					}
				}
				
			}
	 	}
	 	//没匹配成功的，添加到变异记录里
	 	If (IsMatch=0) {
		 	Set IsNew=1
	 		Set xVarID=""
			For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",PathwayID,EpisID,xVarID))
				Quit:xVarID=""
				
				Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
		 		Continue:'$IsObject(objVar)
		 		Continue:$IsObject(objVar.CPImplDr) //路径外医嘱没有项目指针
			 	Set VarOrd=objVar.CPOrdDID	
			 	
			 	If (+objVar.CPIsActive=0) {	//回写前有效性为0
			 		If (VarOrd=aOEItmMastID) {	//回写前VarOrd为医嘱字典ID
			 			Set return=##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(PathwayID_"||"_xVarID,aOEItemID)
			 			Set IsNew=0
			 			Quit
			 		} Else {
				 		Set IsNew=1
			 		}
			 	} Else {
			 		Set xVarOrd=$p(VarOrd,"^",1)	//回写后为医嘱记录ID
			 		Set xOESubID=$p(xVarOrd,"||",2)
					Set xOEItmMastID = $p($g(^OEORD(+xVarOrd,"I",xOESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
			 		If (aOEItmMastID=xOEItmMastID) {
			 			Set return=##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(PathwayID_"||"_xVarID,aOEItemID)
			 			Set IsNew=0
			 			Quit
			 		} Else {
			 			Set IsNew=1
			 		}
			 	}
			}
			If (IsNew=1) {
				//插入新记录
				Set return=##class(DHCMA.CPW.CP.PathwayVar).AddVarOrder(PathwayID,EpisID,aOEItemID,aUserID)
			}
	 	}
	//}
	
	//TCommit
	
	Quit return
}

// 测试程序

}
