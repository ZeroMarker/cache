/// 名称: DHCHAI.DI.DIO.FromEmrSrv
/// 描述: 电子病历数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromEmrSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-09-15
/// Description:  通过就诊号+术语集获取病历信息
///               术语集单元：EPRmeta.Glossary对应^DHCEPRM.GlossaryI
///               术语集目录：EPRmeta.GlossaryCategory对应^DHCEPRM.GlossaryCategoryI
/// Input：       aEpisodeID:就诊号 
///               aGlossary:术语集标识符
/// Output        术语集对应该电子病历单元值
///               类型：数组 
///               格式：[{"实例ID","值"},{"实例ID","值"},...]
///               唯一模板为单值，可重复模板可能有多值
/// Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(27109587,"HDSD00.14.139")
/// Do $system.OBJ.Dump(arr)
ClassMethod GetDataByGlossaryX(aEpisodeID As %String, aGlossary As %String, aDateFrom As %String = "", aDateTo As %String = "") As %ArrayOfDataTypes
{
	New (aEpisodeID,aGlossary,aDateFrom,aDateTo)
	Set return=##class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aGlossary="") return
	//Quit:(aDateFrom="")||(aDateTo="") return
	
	Set arr=##Class(%ArrayOfDataTypes).%New()   
	If $l(aGlossary)<13 {
		Set xGrpGlossary=""
		For {
			Set xGrpGlossary=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID",xGrpGlossary))
			Quit:xGrpGlossary=""
			
			Set GrpGlossary=$e(xGrpGlossary,2,$l(xGrpGlossary))
			Continue:$e(GrpGlossary,1,$l(aGlossary))'=aGlossary  //代码不匹配
			Continue:$l(GrpGlossary)<12 //非根目录退出
			
			//Set arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,AInternalID)
			Set arrGrp=##Class(EMRservice.BIEMRService).GetDataByGlossaryCategory(aEpisodeID,GrpGlossary)
			Set xGlossary=""
			For	{
			    Set arr=arrGrp.GetNext(.xGlossary)
			    Quit:xGlossary=""
			    
			    Set tGrpGlossary=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_xGlossary,0))
				Continue:tGrpGlossary=""
				Set tGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_xGlossary,tGrpGlossary,0))
				Continue:tGlossaryID=""
				
				Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),9)
				Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),15)
				Continue:(GlossaryDesc="")||(GlossaryCode="")
				
				Do GetInstanceData
			}
			
			Continue:return.Count()>0
			
			//以下为协和特殊处理程序
			Set xGrpGlossaryID=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID",xGrpGlossary,0))
			Continue:xGrpGlossaryID=""
			Set xGlossaryID=""
			For {
				Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_xGrpGlossaryID,xGlossaryID))
				Quit:xGlossaryID=""
				
				Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(xGlossaryID)),9)
				Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(xGlossaryID)),15)
				Continue:(GlossaryDesc="")||(GlossaryCode="")
				
				Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryXH(aEpisodeID,GlossaryCode)
				Do GetInstanceData
			}
		}
	} Else {
		Set tGrpGlossary=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_aGlossary,0))
		Quit:tGrpGlossary="" return
		Set tGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_aGlossary,tGrpGlossary,0))
		Quit:tGlossaryID="" return
		
		Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),9)
		Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),15)
		Quit:(GlossaryDesc="")||(GlossaryCode="") return
		
		//Set arr=##Class(EPRservice.BOScatterData).GetDataByGlossary(AEpisodeID,AInternalID)
		Set arr=##Class(EMRservice.BIEMRService).GetDataByGlossary(aEpisodeID,GlossaryCode)
	
		Do GetInstanceData
		Quit:arr.Count()>0 return
		
		//以下为协和特殊处理程序
		Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryXH(aEpisodeID,GlossaryCode)
		Do GetInstanceData
	}
	Quit return
	
GetInstanceData
	Set xInstanceID=""
	For	{
	    Set value=arr.GetNext(.xInstanceID)
	    Quit:xInstanceID=""
		
	    Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(xInstanceID)
		Continue:'$IsObject(objInstance)
		If objInstance'="" Do objInstance.%Close()
		
		Set Title       = objInstance.Title          // 标题
		Set HappenDate  = objInstance.HappenDate     // 发生日期
		Set HappenTime  = objInstance.HappenTime     // 发生时间
		Set ModifyDate	= objInstance.ModifyDate     // 修改日期
		Set ModifyTime	= objInstance.ModifyTime     // 修改时间
		Set ModifyUser  = objInstance.ModifyUser     // 修改医生
		Set ModifyUserCode="",ModifyUserDesc=""
		Set:ModifyUser'="" ModifyUserCode=$p($g(^SSU("SSUSR",ModifyUser)),"^",1)
		Set:ModifyUser'="" ModifyUserDesc=$p($g(^SSU("SSUSR",ModifyUser)),"^",2)
		Continue:(aDateFrom'="")&(ModifyDate<aDateFrom)
		Continue:(aDateTo'="")&(ModifyDate>aDateTo)
		
		Set value=$tr(value,$c(1),"") //替换$c(1)
		Set Title=$tr(Title,$c(1),"") //替换$c(1)
		Set ModifyUserCode=$tr(ModifyUserCode,$c(1),"") //替换$c(1)
		Set ModifyUserDesc=$tr(ModifyUserDesc,$c(1),"") //替换$c(1)
		
		Set InstanceData=Title
		_$c(1)_HappenDate_$c(1)_HappenTime
		_$c(1)_ModifyDate_$c(1)_ModifyTime
		_$c(1)_ModifyUser_$c(1)_ModifyUserCode_$c(1)_ModifyUserDesc
		_$c(1)_GlossaryCode_$c(1)_GlossaryDesc
		_$c(1)_value
		
		Set InstanceData=$tr(InstanceData,$c(0),"") //替换$c(0)
		Do return.SetAt(InstanceData,xInstanceID_","_GlossaryCode)
	}
	Quit
}

/// Creator:    ???
/// CreateDate: 2017-09-19
/// Desc:       根据术语项代码取电子病历数据
/// Input:      AEpisodeID 就诊号
///             AGlossaryInternalID 术语项代码
/// Output:     w ##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryXH(76,"S.01.01")
ClassMethod GetDataByGlossaryXH(AEpisodeID As %String, AInternalID As %String) As %ArrayOfDataTypes
{
	New (AEpisodeID,AInternalID)
	Set result=##Class(%ArrayOfDataTypes).%New()
	Quit:((AEpisodeID = "")||(AInternalID = "")) result
	
	Set xCategoryID=""
	For {
		Set xCategoryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_$zcvt(AInternalID,"U"),xCategoryID))
		Quit:xCategoryID=""
		Quit:(result.Count()>0)
		
		Set xGlossaryID=""
		For {
			Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_$zcvt(AInternalID,"U"),xCategoryID,xGlossaryID))
			Quit:xGlossaryID=""
			
			Set result=##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,xGlossaryID)
			Quit:(result.Count()>0)
		}
	}
	Quit result
}

}
