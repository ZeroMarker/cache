/// 名称: DHCCPW.MR.DATA.UpGradeSrv
/// 描述: 系统升级 基础数据处理
/// 编写者：zhufei
/// 编写日期: 2015-05-25
Class DHCCPW.MR.DATA.UpGradeSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 处理历史关联医嘱数据
/// w ##Class(DHCCPW.MR.DATA.UpGradeSrv).ChangeLnkArcim()
ClassMethod ChangeLnkArcim()
{
	New
	Set Count=0
	
	Set xFormID=0
	For {
		Set xFormID=$o(^DHCMRC("CPW",xFormID))
		Quit:xFormID=""
		
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
					
					Set Count=Count+1
					w:Count#100=0 "Count="_Count,!
					Set ItemID=xFormID_"||"_xEpSub_"||"_xStepSub_"||"_xItemSub
					Set flg=..ChangeLnkArcimByItem(ItemID)
					If flg<0 {
						w "ErrorItemID="_ItemID,!
					}
				}
			}
		}
	}
	
	Do ##Class(User.DHCMRCClinPathWaysEpStepItem).%BuildIndices()
	Do ##Class(User.DHCMRClinicalPathWayImpl).%BuildIndices()
	
	Quit Count
}

/// 处理关联医嘱数据
/// w ##Class(DHCCPW.MRC.FORM.LnkArcimSrv).ChangeLnkArcimByItem("79||1||1||11")
ClassMethod ChangeLnkArcimByItem(aItemID As %String) As %String
{
	New (aItemID)
	Set return=0
	Quit:aItemID="" return
	
	Set objItem=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(aItemID)
	Quit:'$IsObject(objItem) return
	Quit:objItem.CPWSIARCIM.Count()<1 return
	
	Set isError=0
	For indArc=1:1:objItem.CPWSIARCIM.Count() {
		Set objArcim=objItem.CPWSIARCIM.GetAt(indArc)
		Continue:'$IsObject(objArcim)
		Set ArcimID=objArcim.ITMARCIMDR
		Continue:ArcimID=""
		
		W:$l(ArcimID,"||")'=2 "ID="_ArcimID_",医嘱套="_$p($g(^ARCOS(+ArcimID)),"^",2),!
		
		Set InputStr=aItemID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_indArc
		Set InputStr=InputStr_"^"_objArcim.ITMLinkNo  //最后要特殊处理关联号
		Set InputStr=InputStr_"^"_objArcim.ITMPriority
		Set IsMain=objArcim.ITMIsMain
		Set:(IsMain="Y")||(IsMain="") IsMain="Y"
		Set InputStr=InputStr_"^"_IsMain
		Set InputStr=InputStr_"^"_objArcim.ITMARCIMDR
		Set InputStr=InputStr_"^"_objArcim.ITMDoseQty
		Set InputStr=InputStr_"^"_objArcim.ITMUOMDR
		Set InputStr=InputStr_"^"_objArcim.ITMDuratDR
		Set InputStr=InputStr_"^"_objArcim.ITMFreqDR
		Set InputStr=InputStr_"^"_objArcim.ITMInstrucDR
		Set InputStr=InputStr_"^"_objArcim.ITMQty
		Set InputStr=InputStr_"^"_objArcim.ITMResume
		Set InputStr=InputStr_"^"_objArcim.ITMDefault
		Set InputStr=InputStr_"^"_objArcim.ITMIsActive
		Set UpdateUser=objArcim.ITMUpdateUser
		Set:+UpdateUser=0 UpdateUser=""
		Set InputStr=InputStr_"^"_UpdateUser
		Set InputStr=InputStr_"^"_objArcim.ITMUpdateDate
		Set InputStr=InputStr_"^"_objArcim.ITMUpdateTime
		Set flg=##class(User.DHCMRCClinPathWaysItmGene).Update(InputStr)
		Set:(+flg)<1 isError=1
	}
	Set:isError>0 return=-1
	Quit:isError>0 return
	
	Set FormID=+aItemID
	Set EpSub=$p(aItemID,"||",2)
	Set StepSub=$p(aItemID,"||",3)
	Set ItemSub=$p(aItemID,"||",4)
	Set xGeneSub=0
	For {
		Set xGeneSub=$o(^DHCMRC("CPW",FormID,"EP",EpSub,"STEP",StepSub,"ITEM",ItemSub,"GENE",xGeneSub))
		Quit:xGeneSub=""
		
		Set GeneID=FormID_"||"_EpSub_"||"_StepSub_"||"_ItemSub_"||"_xGeneSub
		Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(GeneID)
		Continue:'$IsObject(objGene)
		Continue:objGene.IGLinkNo=""
		Set LinkNo=objGene.IGLinkNo
		Set GeneSub=$o(^DHCMRCi("CPW",0,"GENE","IndexGeneNo",FormID,EpSub,StepSub,ItemSub,LinkNo,0))
		If GeneSub'="" {
			Set LinkNo=FormID_"||"_EpSub_"||"_StepSub_"||"_ItemSub_"||"_GeneSub
		} Else {
			Set LinkNo=""
		}
		
		Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(GeneID)
		Set obj.IGLinkNo     = LinkNo
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {     //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
		}
		Do obj.%Close()
	}
	
	Set return=1
	Quit return
}

Storage Default
{
<Data name="BaseDataSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.UpG572D.BaseDataSrvD</DataLocation>
<DefaultData>BaseDataSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.UpG572D.BaseDataSrvD</IdLocation>
<IndexLocation>^web.DHCCPW.UpG572D.BaseDataSrvI</IndexLocation>
<StreamLocation>^web.DHCCPW.UpG572D.BaseDataSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
