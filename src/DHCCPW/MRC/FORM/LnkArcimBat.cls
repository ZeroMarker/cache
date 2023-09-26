/// 名称: DHCCPW.MRC.FORM.LnkArcimBat
/// 描述: 关联医嘱批处理相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-15
Class DHCCPW.MRC.FORM.LnkArcimBat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##Class(DHCCPW.MRC.FORM.LnkArcimBat).ChangeLnkArcim("79||1||1||11||162-1,79||1||1||11||192-1","1087||1^1^18^4^8^63^^^9")
ClassMethod ChangeLnkArcim(aIGAIndex As %String, aArcimInfo As %String) As %String
{
	New (aIGAIndex, aArcimInfo)
	Set return=0
	Quit:(aIGAIndex="")||(aArcimInfo="") return
	
	Set ArcimID = $p(aArcimInfo,"^",1)
	Quit:ArcimID="" return
	Set DoseQty = $p(aArcimInfo,"^",2)
	Set DoseUomID = $p(aArcimInfo,"^",3)
	Set FreqID = $p(aArcimInfo,"^",4)
	Set InstrucID = $p(aArcimInfo,"^",5)
	Set DurationID = $p(aArcimInfo,"^",6)
	Set PackQty = $p(aArcimInfo,"^",7)
	Set ItmResume = $p(aArcimInfo,"^",8)
	Set UpdateUser = $p(aArcimInfo,"^",9)
	
	For indArc=1:1:$l(aIGAIndex,",") {
		Set tmpIGAindex=$p(aIGAIndex,",",indArc)
		Continue:tmpIGAindex=""
		
		Set GeneID=$p(tmpIGAindex,"-",1)
		Set IGASub=$p(tmpIGAindex,"-",2)
		Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(GeneID)
		Continue:'$IsObject(objGene)
		Set ItemID=$p(GeneID,"||",1)_"||"_$p(GeneID,"||",2)_"||"_$p(GeneID,"||",3)_"||"_$p(GeneID,"||",4)
		Set IGSub=$p(GeneID,"||",5)
		
		Set objArcim=objGene.IGArcimList.GetAt(IGASub)
		Continue:'$IsObject(objArcim)
		Set ArcimDR = objArcim.ITMARCIMDR
		Continue:ArcimDR=""
		
		Set aInputStr=ItemID
		Set aInputStr=aInputStr_"^"_IGSub
		Set aInputStr=aInputStr_"^"_IGASub
		Set aInputStr=aInputStr_"^"_objGene.IGNo
		Set aInputStr=aInputStr_"^"_objGene.IGPriority
		Set aInputStr=aInputStr_"^"_objGene.IGLinkNo
		Set aInputStr=aInputStr_"^"_$s(objGene.IGIsMain["Y":1,1:0)
		Set aInputStr=aInputStr_"^"_ArcimID
		Set aInputStr=aInputStr_"^"_DoseQty
		Set aInputStr=aInputStr_"^"_DoseUomID
		Set aInputStr=aInputStr_"^"_FreqID
		Set aInputStr=aInputStr_"^"_InstrucID
		Set aInputStr=aInputStr_"^"_DurationID
		Set aInputStr=aInputStr_"^"_PackQty
		Set aInputStr=aInputStr_"^"_$s(objArcim.ITMDefault["Y":1,1:0)
		Set aInputStr=aInputStr_"^"_$s(objArcim.ITMIsActive["Y":1,1:0)
		Set aInputStr=aInputStr_"^"_ItmResume
		Set aInputStr=aInputStr_"^"_UpdateUser
		
		Set flg=##Class(DHCCPW.MRC.FORM.LnkArcimSrv).SaveLnkArcim(aInputStr)
		If +flg<0 {
			Set return=-1
			Quit
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  查询关联医嘱列表
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimBat","QryLnkArcimList","700||1","")
Query QryLnkArcimList(aArcimID As %String, aCPWDID As %String, aCPWType As %String = "") As %Query(ROWSPEC = "IGAIndex:%String,CPWDID:%String,CPWDDesc:%String,IGGeneDesc:%String,IGPriorityDesc:%String,IGIsMain:%String,IGAArcimDesc:%String,IGAPackQty:%String,IGAFreqDesc:%String,IGADuratDesc:%String,IGAInstrucDesc:%String,IGADoseQty:%String,IGADoseUomDesc:%String,IGADefault:%String,IGAIsActive:%String,IGAResume:%String,UpdateDate:%String,UpdateUser:%String")
{
}

ClassMethod QryLnkArcimListExecute(ByRef qHandle As %Binary, aArcimID As %String, aCPWDID As %String, aCPWType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aArcimID="" $$$OK
	
	Set xFormID=0
	For {
		Set xFormID=$o(^DHCMRC("CPW",xFormID))
		Quit:xFormID=""
		
		Set objForm=##class(User.DHCMRCClinPathWays).GetObjById(xFormID)
		Continue:'$IsObject(objForm)
		Continue:'$IsObject(objForm.CPWCPWDicDR)
		Set CPWDID=objForm.CPWCPWDicDR.%Id()
		Continue:(aCPWDID'="")&&(aCPWDID'=CPWDID)
		Set CPWType=objForm.CPWCPWTypeDR.CLPTDesc
		Continue:(aCPWType'="")&&(aCPWType'=CPWType)
		Set CPWDDesc=objForm.CPWCPWDicDR.CPWDDesc
		Set CPWVersion=objForm.CPWVersion
		Set CPWDDesc=CPWDDesc_"(v"_CPWVersion_".0)"
		Set CPWDVersion=objForm.CPWCPWDicDR.CPWDVersion
		Set PublicDate=objForm.CPWVerDate
		Continue:(PublicDate'="")&&(xFormID'=CPWDVersion)
		Set xEpSub=0
		For {
			Set xEpSub=$o(^DHCMRC("CPW",xFormID,"EP",xEpSub))
			Quit:xEpSub=""
			
			Set xStepSub=0
			For {
				Set xStepSub=$o(^DHCMRC("CPW",xFormID,"EP",xEpSub,"STEP",xStepSub))
				Quit:xStepSub=""
				
				Set xItemSub=0
				For {
					Set xItemSub=$o(^DHCMRC("CPW",xFormID,"EP",xEpSub,"STEP",xStepSub,"ITEM",xItemSub))
					Quit:xItemSub=""
					
					Set xGeneSub=0
					For {
						Set xGeneSub=$o(^DHCMRC("CPW",xFormID,"EP",xEpSub,"STEP",xStepSub,"ITEM",xItemSub,"GENE",xGeneSub))
						Quit:xGeneSub=""
						
						Set GeneID=xFormID_"||"_xEpSub_"||"_xStepSub_"||"_xItemSub_"||"_xGeneSub
						Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(GeneID)
						Continue:'$IsObject(objGene)
						
						Set IGNo=objGene.IGNo              //序号
						Set IGGeneDesc=objGene.IGGeneDesc  //通用名
						Set IGLinkNo=objGene.IGLinkNo      //关联号
						Set IGPriority=objGene.IGPriority  //医嘱类型
						Set IGPriorityDesc=$p($g(^OECPR(IGPriority)),"^",2)
						Set IGIsMain=objGene.IGIsMain      //主医嘱
						Set IGIsMain=$s(IGIsMain["Y":1,1:0)
						
						For indArc=1:1:objGene.IGArcimList.Count() {
							Set objArcim=objGene.IGArcimList.GetAt(indArc)
							Continue:'$IsObject(objArcim)
							Set ArcimDR = objArcim.ITMARCIMDR
							Continue:ArcimDR=""
							Continue:aArcimID'=ArcimDR
							Set ArcimDesc=$p($g(^ARCIM(+ArcimDR,+$p(ArcimDR,"||",2),1)),"^",2)
							
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
							Set IGAIsActive=$s(IGAIsActive["Y":1,1:0)
							Set IGAResume = objArcim.ITMResume
							Set UpdateDate = objArcim.ITMUpdateDate
							;Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
							Set:UpdateDate'="" UpdateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(UpdateDate)
							Set UpdateTime = objArcim.ITMUpdateTime
							Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
							Set UpdateDate=UpdateDate_" "_UpdateTime
							Set UpdateUser = objArcim.ITMUpdateUser
							Set:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
							
							Set IGAIndex=GeneID_"-"_indArc
							Set Data=$lb(IGAIndex,CPWDID,CPWDDesc,IGGeneDesc,IGPriorityDesc,IGIsMain,ArcimDesc,IGAPackQty,IGAFreqDesc,IGADuratDesc,IGAInstrucDesc,IGADoseQty,IGADoseUomDesc,IGADefault,IGAIsActive,IGAResume,UpdateDate,UpdateUser)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLnkArcimListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLnkArcimListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLnkArcimListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLnkArcimListExecute ]
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
