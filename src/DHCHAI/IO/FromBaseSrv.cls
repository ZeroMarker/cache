/// 名称: DHCHAI.IO.FromBaseSrv
/// 描述: 测试菜单服务类
/// 编写者：zhufei
/// 编写日期: 2017-03-28
Class DHCHAI.IO.FromBaseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-03-28
/// Description:  自动创建测试菜单+权限
/// Input：       GroupID：安全组ID
/// Return:		  return>0:成功
/// Debug:		  w ##Class(DHCHAI.IO.FromBaseSrv).SetSecurity(226)
ClassMethod SetSecurity(aGroupID As %String = "") As %String
{
	New (aGroupID)
	Set return=""
	
	Set ProductDr=##class(DHCMed.SS.Products).GetIDByCode("HAI")
	Quit:ProductDr="" return
	
	Set GroupList=""
	If aGroupID'="" {
		Set:$d(^SSU("SSGRP",aGroupID)) GroupList=$lb(aGroupID)
	}
	If GroupList="" {
		Set xGroupDr=""
		For {
			Set xGroupDr=$o(^DHCMed.SS.SecurityI("IndexOfGPM",xGroupDr))
			Quit:xGroupDr=""
			Continue:'$d(^DHCMed.SS.SecurityI("IndexOfGPM",xGroupDr,ProductDr))
			
			Set:$d(^SSU("SSGRP",xGroupDr)) GroupList=GroupList_$lb(xGroupDr)
		}
	}
	
	Set Count=0
	For indG=1:1:$ll(GroupList) {
		Set xGroupDr=$listget(GroupList,indG)
		Continue:xGroupDr=""
		
		Set xParentMenuDr=""
		For {
			Set xParentMenuDr=$o(^DHCMed.SS.MenusI("IndexProParentIndex",ProductDr,xParentMenuDr))
			Quit:xParentMenuDr=""
			
			Set xIndex=""
			For {
				Set xIndex=$o(^DHCMed.SS.MenusI("IndexProParentIndex",ProductDr,xParentMenuDr,xIndex))
				Quit:xIndex=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCMed.SS.MenusI("IndexProParentIndex",ProductDr,xParentMenuDr,xIndex,xID))
					Quit:xID=""
					
					Set SecID=##class(DHCMed.SS.Security).Update(xGroupDr,ProductDr,xID,1)
					Set:SecID>0 Count=Count+1
				}
			}
		}
	}
	
	Quit Count
}

}
