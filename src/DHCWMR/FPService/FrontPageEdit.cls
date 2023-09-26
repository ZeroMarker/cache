/// 名称: DHCWMR.FPService.FrontPageEdit
/// 描述: 编目页面配置相关服务
/// 编写者：zhufei
/// 编写日期: 2016-12-28
Class DHCWMR.FPService.FrontPageEdit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-12-28
/// Description:  根据设置自动加载JS
/// Table：       DHCWMR.SS.Config
/// Input：       
/// Return：      返回String
/// w ##Class(DHCWMR.FPService.FrontPageEdit).AutoLoadFPEditPageJS()
ClassMethod AutoLoadFPEditPageJS(aHospitalID As %String) As %String
{
	New (aHospitalID)
	Set return=0
	
	Set AutoLoadType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("AutoLoadFPEditPageJS",aHospitalID)
	If AutoLoadType=1 {  //首页全编目版本
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FrontPageAll_Gui.js'></script>",!
    	Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FrontPageAll_Event.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_PatInfo.js'></script>",!
    	Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_Diagnos.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_Operation.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_Main.js'></script>",!
    	Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_PatCost.js'></script>",!
	} Else {   //诊断手术编目版本
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FrontPage_Gui.js'></script>",!
    	Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FrontPage_Event.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_PatInfo.js'></script>",!
    	Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_Diagnos.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_Operation.js'></script>",!
    	Write "<script type='text/javascript' src='../scripts/dhcwmr/fp/frontpageedit/FPModule_ExtraItem.js'></script>",!
	}
	
	Set return=1
	Quit return
}

}
