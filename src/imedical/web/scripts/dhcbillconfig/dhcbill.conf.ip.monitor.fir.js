/**
 * FileName: dhcbill.conf.ip.monitor.fir.js
 * Anchor: ZhYW
 * Date: 2020-01-08
 * Description: 住院费用监控配置
 */

$(function() {
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	/**
	* 保存
	*/
	function saveClick() {
		var jsonObj = {
			MoniId: GV.MoniId,
			Id: GV.CDId,
			DaysMode: getValueById("daysMode")
		}
		$.cm({
			ClassName: "web.DHCIPBillCostMonitorConfig",
			MethodName: "SaveCheckData",
			jsonStr: JSON.stringify(jsonObj)
		}, function (rtn) {
			var type = (rtn.success == 0) ? "success" : "error";
			$.messager.popover({msg: rtn.msg, type: type});
			GV.CateList.reload();
		});
	}
});