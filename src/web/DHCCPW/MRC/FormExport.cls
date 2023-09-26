/// 名称: web.DHCCPW.MRC.FormExport
/// 描述: 表单导出
/// 编写者：zhufei
/// 编写日期: 2012-03-15
Class web.DHCCPW.MRC.FormExport Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCCPW.MRC.FormExport).GetBaseInfo(1)
ClassMethod GetBaseInfo(aCPWID As %String) As %String
{
	New (aCPWID)
	Set return=""
	
	Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(aCPWID)
	Quit:'$IsObject(objCPW) return
	Quit:'$IsObject(objCPW.CPWCPWDicDR) return
	
	Set CPWName=objCPW.CPWCPWDicDR.CPWDDesc   //路径名称
	Set CPWOffShoot=objCPW.CPWOffShoot  // 是否分支型临床路径
	Set:CPWOffShoot["Y" CPWName="*"_CPWName
	If $IsObject(objCPW.CPWCPWDicDR.CPWDCPWTypeDR)
	{
		Set CPWType=objCPW.CPWCPWDicDR.CPWDCPWTypeDR.CLPTDesc  //路径类型
	}
	Set CPWICD=objCPW.CPWICD            // 准入ICD
	Set CPWKeys=objCPW.CPWKeys          // 准入诊断关键词
	Set CPWOperICD=objCPW.CPWOperICD    // 准入手术ICD
	Set CPWOperKeys=objCPW.CPWOperKeys  // 准入手术关键词
	Set CPWLabel=objCPW.CPWLabel        // 准入提示
	Set CPWCost=objCPW.CPWCost          // 参考费用
	Set CPWDays=objCPW.CPWDays          // 参考天数
	Set CPWVarDesc=objCPW.CPWVarDesc    // 变异原因分析
	//Set CPWHelpFild=objCPW.CPWHelpFild  // 临床路径知识
	
	Set return="路径名称"_$c(2)_CPWName
	Set return=return_$c(1)_"路径类型"_$c(2)_CPWType
	Set return=return_$c(1)_"准入诊断ICD10"_$c(2)_CPWICD
	Set return=return_$c(1)_"准入诊断关键字"_$c(2)_CPWKeys
	Set return=return_$c(1)_"准入手术CM3"_$c(2)_CPWOperICD
	Set return=return_$c(1)_"准入手术关键字"_$c(2)_CPWOperKeys
	Set return=return_$c(1)_"准入提示"_$c(2)_CPWLabel
	Set return=return_$c(1)_"参考费用"_$c(2)_CPWCost
	Set return=return_$c(1)_"参考天数"_$c(2)_CPWDays
	Set return=return_$c(1)_"变异分析描述"_$c(2)_CPWVarDesc
	
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.FormExport).GetEpSteps(1)
ClassMethod GetEpSteps(aCPWID As %String) As %String
{
	New (aCPWID)
	Set return=""
	Quit:aCPWID="" return
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"GetEpSteps")
	
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID))
		Quit:EpID=""
		
		Set CPWEpID=aCPWID_"||"_EpID
		Set objCPWEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWEpID)
		If $IsObject(objCPWEp) {
			Set CPWEpDesc=objCPWEp.EPDesc
			Set EpNo=objCPWEp.EPEpisode
			Set tmpEpNo=""
			If EpNo'="" {
				Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
				Set EpNo=tmpEpNo
			}
		}
		
		Set EpStepID=0
		For {
			Set EpStepID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID,"STEP",EpStepID))
			Quit:EpStepID=""
			
			Set CPWEpStepID=CPWEpID_"||"_EpStepID
			Set objCPWEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CPWEpStepID)
			If $IsObject(objCPWEpStep) {
				Set CPWEpStepDesc=objCPWEpStep.CPWSDesc
				Set StepNo=objCPWEpStep.CPWSDayNumber
				Set tmpStepNo=""
				If StepNo'="" {
					Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
					Set StepNo=tmpStepNo
				}
				Set num=$i(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID))
				Set ^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID,StepNo,EpStepID)=""
			}
		}
	}
	
	Set EpNo=""
	For {
		Set EpNo=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo))
		Quit:EpNo=""
		Set EpID=""
		For {
			Set EpID=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID))
			Quit:EpID=""
			
			Set CPWEpID=aCPWID_"||"_EpID,CPWEpDesc=""
			Set objCPWEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWEpID)
			If $IsObject(objCPWEp) {
				Set CPWEpDesc=objCPWEp.EPDesc
			}
			Set StepNo=""
			For {
				Set StepNo=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID,StepNo))
				Quit:StepNo=""
				Set StepID=""
				For {
					Set StepID=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID,StepNo,StepID))
					Quit:StepID=""
					
					Set CPWEpStepID=CPWEpID_"||"_StepID,CPWEpStepDesc=""
					Set objCPWEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CPWEpStepID)
					If $IsObject(objCPWEpStep) {
						Set CPWEpStepDesc=objCPWEpStep.CPWSDesc
					}
					Set StepDay=objCPWEpStep.CPWSDay
					Set StepDayUnit=objCPWEpStep.CPWSUnit
					
					Set EpStepCnt=+$g(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID))
					If EpStepCnt>1 {
						Set return=return_$c(1)_CPWEpStepID_$c(2)_CPWEpDesc_"("_CPWEpStepDesc_")"_$c(2)_StepDay
					} Else {
						Set return=return_$c(1)_CPWEpStepID_$c(2)_CPWEpDesc_$c(2)_StepDay
					}
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetEpSteps")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.FormExport).GetEpStepItems("1||1||1",1)
ClassMethod GetEpStepItems(aEpStepID As %String, argNum As %String) As %String
{
	New (aEpStepID,argNum)
	Set return=""
	
	Set JIndex=$j,ZIndex=$zn
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItems")
	Set CPWID=$p(aEpStepID,"||",1)
	Set EpID=$p(aEpStepID,"||",2)
	Set StepID=$p(aEpStepID,"||",3)
	
	If (argNum=1)||(argNum=2)||(argNum=3) {
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:ItemID=""
			
			Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set (ItemDesc,ItemType,GroupNo)=""
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
			If $IsObject(objItem) {
				Set ItemDesc=objItem.CPWSIDesc
				If $IsObject(objItem.CPWSISubCategory) {
					Set ItemSubCat=objItem.CPWSISubCategory.SISCDesc
					If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
						Set ItemCateg=objItem.CPWSISubCategory.SISCParRef.SICDesc
					}
				}
				Set GroupNo=+objItem.CPWSIGroupNo
				Set:GroupNo="" GroupNo=999
			}
			Continue:ItemDesc=""
			Continue:(argNum=1)&&(ItemCateg'="主要诊疗工作")
			Continue:(argNum=2)&&(ItemCateg'="重点医嘱")
			Continue:(argNum=3)&&(ItemCateg'="主要护理工作")
			
			Set ^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,StepItemID)=$lb(ItemSubCat,ItemDesc)
		}
	}
	
	Set GroupNo=""
	For {
		Set GroupNo=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo))
		Quit:GroupNo=""
		
		Set ItemID="",GroupDesc="",GroupType=""
		For {
			Set ItemID=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,ItemID))
			Quit:ItemID=""
			Set Itemls=$g(^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,ItemID))
			Set ItemType=$list(Itemls,1)
			Set ItemDesc=$list(Itemls,2)
			Continue:ItemDesc=""
			Set GroupDesc=GroupDesc_"、"_ItemDesc
			Set GroupType=ItemType
		}
		Set:GroupDesc'="" GroupDesc=$e(GroupDesc,2,$l(GroupDesc))
		Continue:GroupDesc=""
		Set return=return_$c(1)_GroupType_$c(2)_GroupDesc
	}
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItems")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

}
