/**
 * FileName: dhcbill.conf.ip.monitor.sec.js
 * Anchor: ZhYW
 * Date: 2020-01-09
 * Description: 住院费用监控配置
 */

$(function() {
	setValueById("airStDate", GV.AirStDate);
	setValueById("airEndDate", GV.AirEndDate);
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	$HUI.checkbox("#airMode", {
		onChecked: function(e, value) {
			disableById("airStDate");
			disableById("airEndDate");
			setValueById("airStDate", "");
			setValueById("airEndDate", "");
		},
		onUnchecked: function(e, value) {
			enableById("airStDate");
			enableById("airEndDate");
			setValueById("airStDate", GV.AirStDate);
			setValueById("airEndDate", GV.AirEndDate);
		}
	});
	
	/**
	* 保存
	*/
	function saveClick() {
		var airMode = getValueById("airMode");
		var airStDate = getValueById("airStDate");
		var airEndDate = getValueById("airEndDate");
		var jsonObj = {
			MoniId: GV.MoniId,
			Id: GV.CDId,
			AirMode: airMode ? 1 : 0,
			AirStDate: airStDate,
			AirEndDate: airEndDate,
		}
		$.cm({
			ClassName: "web.DHCIPBillCostMonitorConfig",
			MethodName: "SaveCheckData",
			jsonStr: JSON.stringify(jsonObj)
		}, function (rtn) {
			var type = (rtn.success == "0") ? "success" : "error";
			$.messager.popover({msg: rtn.msg, type: type});
			GV.CateList.reload();
		});
	}
});