/// Description: HISUI DataGrid表格配置业务类
/// FileName: web.DHCPE.DataGrid.Setting
/// Creator: wangguoying
/// Date: 2022-07-11
Class web.DHCPE.DataGrid.Setting Extends %RegisteredObject
{

/// Description：保存列表配置
/// Input:   
/// 			PageName：CSP名称
/// 			ElementID：DataGird元素ID
/// 			ColsData：列配置信息
/// 			SessionStr：用户ID^科室ID^安全组ID		
/// Return:		
/// 				0：成功  非0^失败信息
/// Creator:	wangguoying
/// CreateDate:	2022-07-11
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).SaveSetting("dhcpe.cashierexception.csp","InvListQueryTab","{""total"":21,""rows"":[{""field"":""TOPInfo"",""title"":""操作"",""sort"":1,""width"":80,""hidden"":true,""forzen"":""Y"",""formatterFunc"":"""",""align"":""center"",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-TOPInfo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TInvNo"",""title"":""发票号"",""sort"":2,""width"":300,""hidden"":false,""forzen"":""Y"",""formatterFunc"":"""",""sortable"":true,""boxWidth"":284,""cellClass"":""datagrid-cell-c13-TInvNo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TRegNo"",""title"":""病人号"",""sort"":3,""width"":100,""hidden"":false,""forzen"":""Y"",""formatterFunc"":"""",""boxWidth"":84,""cellClass"":""datagrid-cell-c13-TRegNo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TPatName"",""title"":""姓名"",""sort"":4,""width"":100,""hidden"":true,""forzen"":""Y"",""formatterFunc"":"""",""boxWidth"":84,""cellClass"":""datagrid-cell-c13-TPatName"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TPayMode"",""title"":""支付方式"",""sort"":14,""width"":300,""hidden"":false,""forzen"":""Y"",""formatterFunc"":"""",""boxWidth"":284,""cellClass"":""datagrid-cell-c13-TPayMode"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TRoundInfo"",""title"":""凑整费"",""sort"":15,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""align"":""right"",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-TRoundInfo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TRowId"",""title"":""TRowId"",""sort"":5,""width"":0,""hidden"":true,""forzen"":""N"",""formatterFunc"":"""",""auto"":true,""cellClass"":""datagrid-cell-c13-TRowId"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TAmount"",""title"":""金额"",""sort"":6,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""align"":""right"",""sortable"":true,""boxWidth"":64,""cellClass"":""datagrid-cell-c13-TAmount"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TFlag"",""title"":""状态"",""sort"":7,""width"":60,""hidden"":false,""forzen"":""N"",""formatterFunc"":""testFormatter"",""boxWidth"":44,""cellClass"":""datagrid-cell-c13-TFlag"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""_selected"":false},{""field"":""TUser"",""title"":""收费员"",""sort"":8,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-TUser"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TInvDate"",""title"":""收费日期"",""sort"":9,""width"":150,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":134,""cellClass"":""datagrid-cell-c13-TInvDate"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TRPFlag"",""title"":""结账标志"",""sort"":10,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""align"":""center"",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-TRPFlag"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TRPDate"",""title"":""结账日期"",""sort"":11,""width"":120,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":104,""cellClass"":""datagrid-cell-c13-TRPDate"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TDropDate"",""title"":""退费日期"",""sort"":12,""width"":100,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":84,""cellClass"":""datagrid-cell-c13-TDropDate"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TRInvNo"",""title"":""被退费的发票号"",""sort"":13,""width"":120,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":104,""cellClass"":""datagrid-cell-c13-TRInvNo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TInvName"",""title"":""发票名称"",""sort"":16,""width"":100,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":84,""cellClass"":""datagrid-cell-c13-TInvName"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""Tsswr"",""title"":""分币误差"",""sort"":17,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""align"":""right"",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-Tsswr"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TSex"",""title"":""性别"",""sort"":18,""width"":40,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""sortable"":true,""boxWidth"":24,""cellClass"":""datagrid-cell-c13-TSex"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TAge"",""title"":""年龄"",""sort"":19,""width"":40,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":24,""cellClass"":""datagrid-cell-c13-TAge"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""TPosition"",""title"":""部门"",""sort"":20,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-TPosition"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false},{""field"":""Ttsest"",""title"":""测试"",""sort"":21,""width"":80,""hidden"":false,""forzen"":""N"",""formatterFunc"":"""",""boxWidth"":64,""cellClass"":""datagrid-cell-c13-Ttsest"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false}],""rowStylerFunc"":""testRowStyler"",""autoWrap"":""Y""}","11849^304^164","11849")
ClassMethod SaveSetting(PageName, ElementID, ColsData, SessionStr, UserID = "")
{
}

/// Description：查询列表配置ID
/// Input:   
/// 			PageName：CSP名称
/// 			ElementID：DataGird元素ID
/// 			SessionStr：用户ID^科室ID^安全组ID	
/// 			AllMatch：1：用户、科室、安全组完全匹配	 满分5分
/// 					  0：找最匹配的记录;用户匹配+3分 科室匹配+1分 安全组匹配+1分  
/// Return:		
/// 			DHC_PE_DataGridSet.ID
/// Creator:	wangguoying
/// CreateDate:	2022-07-11
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).GetSettingID("dhcpe.cashierexception.csp","InvListQueryTab","11849^304^164")
ClassMethod GetSettingID(PageName, ElementID, SessionStr, AllMatch = "1")
{
}

/// Description：查询配置的列信息
/// Input:   
/// 			PageName：CSP名称
/// 			ElementID：DataGird元素ID
/// 			SessionStr：用户ID^科室ID^安全组ID
/// Return:		
/// 			[]
/// Creator:	wangguoying
/// CreateDate:	2022-07-12
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).GetSettingArray("dhcpe.cashierexception.csp","InvListQueryTab","11849^304^164")
ClassMethod GetSettingArray(PageName, ElementID, SessionStr)
{
}

/// Description：保存导出配置
/// Input:   
/// 			PageName：CSP名称
/// 			ElementID：DataGird元素ID
/// 			SettingData：配置信息
/// 			SessionStr：用户ID^科室ID^安全组ID		
/// Return:		
/// 				0：成功  非0^失败信息
/// Creator:	wangguoying
/// CreateDate:	2022-07-14
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).SaveExportSetting("dhcpe.cashierexception.csp","InvListQueryTab","{""fileName"":""\""收费记录\""_$P(^SSU(\""SSUSR\"", %session.Get(\""LOGON.USERID\"")),\""^\"",2)"",""title"":""\""收费异常处理\"""",""titleSize"":"""",""inscribe"":""\""制表日期：\""_$ZD(+$H,3)_\"" \""_$ZT($P($H,\"",\"",2))"",""sheetField"":"""",""showLine"":""Y"",""rows"":[{""field"":""TOPInfo"",""title"":""操作"",""sort"":1,""width"":180,""hidden"":true,""forzen"":""Y"",""align"":""center"",""boxWidth"":164,""cellClass"":""datagrid-cell-c1-TOPInfo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""N"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TRegNo"",""title"":""病人号"",""sort"":2,""width"":100,""hidden"":false,""forzen"":""Y"",""boxWidth"":84,""cellClass"":""datagrid-cell-c1-TRegNo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TPatName"",""title"":""姓名"",""sort"":3,""width"":100,""hidden"":false,""forzen"":""Y"",""boxWidth"":84,""cellClass"":""datagrid-cell-c1-TPatName"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TFlag"",""title"":""状态"",""sort"":4,""width"":60,""hidden"":false,""forzen"":""N"",""boxWidth"":44,""cellClass"":""datagrid-cell-c1-TFlag"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TUser"",""title"":""收费员"",""sort"":5,""width"":80,""hidden"":false,""forzen"":""N"",""boxWidth"":64,""cellClass"":""datagrid-cell-c1-TUser"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TRowId"",""title"":""TRowId"",""sort"":6,""width"":0,""hidden"":true,""forzen"":""N"",""auto"":true,""cellClass"":""datagrid-cell-c1-TRowId"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""N"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TAmount"",""title"":""金额"",""sort"":7,""width"":80,""hidden"":false,""forzen"":""N"",""align"":""right"",""sortable"":true,""boxWidth"":64,""cellClass"":""datagrid-cell-c1-TAmount"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TInvNo"",""title"":""发票号"",""sort"":8,""width"":120,""hidden"":false,""forzen"":""N"",""sortable"":true,""boxWidth"":104,""cellClass"":""datagrid-cell-c1-TInvNo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TInvDate"",""title"":""收费日期"",""sort"":9,""width"":150,""hidden"":false,""forzen"":""N"",""boxWidth"":134,""cellClass"":""datagrid-cell-c1-TInvDate"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TRPFlag"",""title"":""结账标志"",""sort"":10,""width"":80,""hidden"":false,""forzen"":""N"",""align"":""center"",""boxWidth"":64,""cellClass"":""datagrid-cell-c1-TRPFlag"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TRPDate"",""title"":""结账日期"",""sort"":11,""width"":120,""hidden"":false,""forzen"":""N"",""boxWidth"":104,""cellClass"":""datagrid-cell-c1-TRPDate"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TDropDate"",""title"":""退费日期"",""sort"":12,""width"":100,""hidden"":false,""forzen"":""N"",""boxWidth"":84,""cellClass"":""datagrid-cell-c1-TDropDate"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TRInvNo"",""title"":""被退费的发票号"",""sort"":13,""width"":120,""hidden"":false,""forzen"":""N"",""boxWidth"":104,""cellClass"":""datagrid-cell-c1-TRInvNo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TPayMode"",""title"":""支付方式"",""sort"":14,""width"":300,""hidden"":false,""forzen"":""N"",""boxWidth"":284,""cellClass"":""datagrid-cell-c1-TPayMode"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TRoundInfo"",""title"":""凑整费"",""sort"":15,""width"":80,""hidden"":false,""forzen"":""N"",""align"":""right"",""boxWidth"":64,""cellClass"":""datagrid-cell-c1-TRoundInfo"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TInvName"",""title"":""发票名称"",""sort"":16,""width"":100,""hidden"":false,""forzen"":""N"",""boxWidth"":84,""cellClass"":""datagrid-cell-c1-TInvName"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""Tsswr"",""title"":""分币误差"",""sort"":17,""width"":80,""hidden"":false,""forzen"":""N"",""align"":""right"",""boxWidth"":64,""cellClass"":""datagrid-cell-c1-Tsswr"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TSex"",""title"":""性别"",""sort"":18,""width"":40,""hidden"":false,""forzen"":""N"",""sortable"":true,""boxWidth"":24,""cellClass"":""datagrid-cell-c1-TSex"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TAge"",""title"":""年龄"",""sort"":19,""width"":40,""hidden"":false,""forzen"":""N"",""boxWidth"":24,""cellClass"":""datagrid-cell-c1-TAge"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""TPosition"",""title"":""部门"",""sort"":20,""width"":80,""hidden"":false,""forzen"":""N"",""boxWidth"":64,""cellClass"":""datagrid-cell-c1-TPosition"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""},{""field"":""Ttsest"",""title"":""测试"",""sort"":21,""width"":80,""hidden"":false,""forzen"":""N"",""boxWidth"":64,""cellClass"":""datagrid-cell-c1-Ttsest"",""hidable"":true,""filterable"":true,""ignoreFormatterWhenFilter"":false,""canExport"":""Y"",""colStyle"":""S"",""verticalAlign"":""BOTTOM"",""horizontalAlign"":""LEFT"",""autoWrap"":""N""}]}","11849^304^164","11849")
ClassMethod SaveExportSetting(PageName, ElementID, SettingData, SessionStr, UserID = "")
{
}

/// Description：查询导出配置ID
/// Input:   
/// 			PageName：CSP名称
/// 			ElementID：DataGird元素ID
/// 			SessionStr：用户ID^科室ID^安全组ID	
/// 			AllMatch：1：用户、科室、安全组完全匹配	 满分5分
/// 					  0：找最匹配的记录;用户匹配+3分 科室匹配+1分 安全组匹配+1分  
/// Return:		
/// 			DHC_PE_GridExportSet.ID
/// Creator:	wangguoying
/// CreateDate:	2022-07-11
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).GetExportSettingID("dhcpe.cashierexception.csp","InvListQueryTab","11849^304^164")
ClassMethod GetExportSettingID(PageName, ElementID, SessionStr, AllMatch = "1")
{
}

/// Description：查询导出配置信息
/// Input:   
/// 			PageName：CSP名称
/// 			ElementID：DataGird元素ID
/// 			SessionStr：用户ID^科室ID^安全组ID
/// Return:		
/// 			[]
/// Creator:	wangguoying
/// CreateDate:	2022-07-12
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).GetExportSettingArray("dhcpe.cashierexception.csp","InvListQueryTab","11849^304^164")
ClassMethod GetExportSettingArray(PageName, ElementID, SessionStr)
{
}

/// Description：转义特殊字符 
/// Input:
/// 			Str：要转义的字符串
/// 			Reversal：0：将上箭头转为@*!   1：反转，将@*!转为^   
/// Return:		
/// 			
/// Creator:	wangguoying
/// CreateDate:	2022-07-12
/// Debug: w ##class(web.DHCPE.DataGrid.Setting).Escape("dhcpe.cashierexception.csp11849^304^164",0)
ClassMethod Escape(Str, Reversal = "0")
{
}

}
