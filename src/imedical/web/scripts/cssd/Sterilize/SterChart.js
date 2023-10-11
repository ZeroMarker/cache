// 灭菌验收曲线图弹框
var gType, gRowId, gHospId;
var SterChart = function(Type, RowId, HospId) {
	gType = Type;
	gRowId = RowId;
	gHospId = HospId;
	$HUI.dialog('#SterChartWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
};

var initSterChart = function() {
	function QueryChart() {
		var Params = {
			Type: gType,
			RowId: gRowId,
			HospId: gHospId
		};
		Params = JSON.stringify(addSessionParams(Params));
		$.cm({
			ClassName: 'web.CSSDHUI.MachineData.DataDeal',
			MethodName: 'GetFileData',
			Params: Params
		}, function(jsonData) {
			var dateTimeData = jsonData.dateTimeData;
			if (isEmpty(dateTimeData)) {
				$UI.msg('alert', '未获取到机器信息!');
				$('#SterChartWin').window('close');
				return;
			}
			var pressData = jsonData.pressData;
			var tempData = jsonData.tempData;
			var A0Data = jsonData.A0Data;
			var CommTitle = '';
			if (gType === 'sterilizer') {
				CommTitle = '灭菌器';
			} else if (gType === 'washer') {
				CommTitle = '清洗机';
			}
			var dateTimeArr = dateTimeData.split(',');
			if (tempData !== '') {
				var tempArr = tempData.split(',');
				$('#SterChartTempTitle').html(CommTitle + '--温度曲线图');
				Chart(dateTimeArr, tempArr, 'SterChartTemp', '温度', '#6ab2ec', '#FF4500');
			}
			if (pressData !== '') {
				var pressArr = pressData.split(',');
				$('#SterChartPressTitle').html(CommTitle + '--压力曲线图');
				Chart(dateTimeArr, pressArr, 'SterChartPress', '压力', '#6ab2ec', '#9400D3');
			} else if (A0Data !== '') {
				var A0Arr = A0Data.split(',');
				$('#SterChartPressTitle').html(CommTitle + '--A0值曲线图');
				Chart(dateTimeArr, A0Arr, 'SterChartPress', 'A0值', '#6ab2ec', '#9400D3');
			}
		});
	}
	$HUI.dialog('#SterChartWin', {
		onOpen: function() {
			QueryChart();
		}
	});
};
$(initSterChart);