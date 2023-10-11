/* 生成点评单*/
var init = function() {
	/* --绑定控件--*/
	var OriLocParams = JSON.stringify(addSessionParams({
		Type: 'All'
	}));
	var OriLocBox = $HUI.combobox('#OriLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + OriLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(e) {
			init(e);
		}
	});
	// 取开单科室下所有用户
	function init(LocId) {
		var DoctorParams = JSON.stringify(addSessionParams({
			LocDr: LocId
		}));
		var DoctorBox = $HUI.combobox('#Doctor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + DoctorParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	var HandlerParams = function() {
		var Scg = $('#StkGrpId').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkGrpId').combotree({
		onChange: function(newValue, oldValue) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + newValue;
			StkCatBox.reload(url);
		}
	});
	/* --按钮事件--*/
	$('#conSpaceQty').on('focus', function() {
		GetSpaceQty();
	});
	function GetSpaceQty() {
		var spaceQty = $('#conSpaceQty').val();
		var maxnum = $('#conHvOrdNum').val();		// 统计高值医嘱数量
		var rnum = '', pcent = '';
		var savetype = $("input[name='saveType']:checked").val();
		if (savetype == 'rNum') {
			var rnum = $('#conSaveRandomNum').val();
		} else {
			var pcent = $('#conSavePercent').val();
		}
		if (rnum != '') {
			var writeqty = rnum;
		} else {
			var rnum = parseInt(maxnum * pcent / 100);
			var writeqty = rnum;
		}
		$('#conWriteQty').val(writeqty);
		if (rnum != 0) {
			$('#conASpaceQty').val(Math.floor(maxnum / rnum));
		} else {
			$('#conASpaceQty').val();
		}
		if (spaceQty == 0) {
			$('#conTheoryQty').val();
		} else {
			$('#conTheoryQty').val(writeqty * spaceQty);
		}
	}
	$('#conSavePercent').on('click', function() {
		$('#conSaveRandomNum').val('');				//	文本框清空
		$HUI.radio('#chkPercent').setValue(true);		// 单选框选中
		$HUI.radio('#chkRandomNum').setValue(false);	// 单选框不可用
	});
		
	$('#conSaveRandomNum').on('click', function() {
		$('#conSavePercent').val('');						//	文本框清空
		$HUI.radio('#chkRandomNum').setValue(true);		// 单选框选中
		$HUI.radio('#chkPercent').setValue(false);		// 单选框不可用
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$('#conHvOrdNum').val('');
		$UI.clear(OrdItmGrid);
		showMask();
		var pid = tkMakeServerCall('web.DHCSTMHUI.CreateComment', 'JobGetHvOrdNum', Params);
		var jobInterval = setInterval(function() {
			var jobRet = tkMakeServerCall('web.DHCSTMHUI.CreateComment', 'JobRecieve', pid);
			if (jobRet != '') {
				clearInterval(jobInterval);
				hideMask();
				var jobRetArr = jobRet.split('^');
				var jobRetSucc = jobRetArr[0];
				var jobRetVal = jobRetArr[1];
				if (jobRetSucc < 0) {
					$UI.msg('alert', '查询失败，错误代码：' + RetVal);
				} else {
					if (jobRetVal == 0) {
						$UI.msg('alert', '没有符合条件的高值医嘱,请更换查询条件后再试!');
					} else {
						$('#conHvOrdNum').val(jobRetVal);
					}
				}
			}
		}, 1000);
		OrdItmGrid.load({
			ClassName: 'web.DHCSTMHUI.CreateComment',
			QueryName: 'GetHvOrdItm',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	var OrdItmCm = [[
		{
			title: 'Orirowid',
			field: 'Orirowid',
			hidden: true,
			width: 60
		}, {
			title: 'Oeori',
			field: 'Oeori',
			hidden: true,
			width: 60
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '高值条码',
			field: 'BarCode',
			width: 150
		}, {
			title: '开医嘱科室',
			field: 'OrdLocDesc',
			width: 150
		}, {
			title: '医生',
			field: 'OrdUser',
			width: 150
		}, {
			title: '医嘱日期',
			field: 'OriDate',
			width: 150,
			align: 'center'
		}
	]];
	var OrdItmGrid = $UI.datagrid('#OrdItmGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CreateComment',
			QueryName: 'GetHvOrdItm',
			query2JsonStrict: 1
		},
		columns: OrdItmCm,
		fitColumns: true,
		onClickRow: function(index, row) {
			OrdItmGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			$UI.confirm('您确认要生成高值点评单吗?', 'warning', '', Create, '', '', '警告', false);
		}
	});
	function Create() {
		if (CheckBeforeCreate() == true) {
			var ParamsQueryObj = $UI.loopBlock('#FindConditions');
			var ParamsSaveObj = $UI.loopBlock('#CreateConditions');
			var ParamsQuery = JSON.stringify(ParamsQueryObj);
			var ParamsSave = JSON.stringify(ParamsSaveObj);
			$('#conComNo').val('');
			showMask();
			var pid = tkMakeServerCall('web.DHCSTMHUI.CreateComment', 'JobSaveCommentData', ParamsQuery, ParamsSave);
			var jobInterval = setInterval(function() {
				var jobRet = tkMakeServerCall('web.DHCSTMHUI.CreateComment', 'JobRecieve', pid);
				if (jobRet != '') {
					clearInterval(jobInterval);
					hideMask();
					var jobRetArr = jobRet.split('^');
					var jobRetSucc = jobRetArr[0];
					var jobRetVal = jobRetArr[1];
					if (jobRetSucc < 0) {
						$UI.msg('alert', '查询失败，错误代码' + jobRetVal);
					} else {
						if (jobRetVal < 0) {
							$UI.msg('alert', '生成点评单失败!');
						} else {
							$UI.msg('success', '抽取成功!');
							$('#conComNo').val(jobRetVal);
						}
					}
				}
			}, 1000);
		}
	}
	
	function CheckBeforeCreate() {
		var conHvOrdNum = $('#conHvOrdNum').val();
		if (isEmpty(conHvOrdNum)) {
			$UI.msg('alert', '请先统计高值医嘱数量!');
			return false;
		}
		if (conHvOrdNum == 0) {
			$UI.msg('alert', '高值医嘱数量为0,没有可抽取的高值医嘱,请先统计高值医嘱!');
			return false;
		}
		var rnum = $('#conSaveRandomNum').val();
		var pcent = $('#conSavePercent').val();
		if (isEmpty(rnum) && isEmpty(pcent)) {
			$UI.msg('alert', '请先填写随机数或者百分比!');
			return false;
		}
		if ((!(rnum > 0)) && (!(pcent > 0))) {
			$UI.msg('alert', '填写的随机数或者百分比格式不正确，请修改后重试!');
			return false;
		}
		var rnumstr = rnum.split('.');
		if (rnumstr[0] !== rnum) {
			$UI.msg('alert', '填写的随机数不能为小数，请修改后重试!');
			return false;
		}
		if (parseFloat(rnum) > parseFloat((conHvOrdNum * conHvOrdNum))) {
			$UI.msg('alert', '随机数超过总高值医嘱数量的' + conHvOrdNum * 100 + '%,建议调整随机数!');
			return false;
		}
		if (!(pcent > 0) && (pcent !== '')) {
			$UI.msg('alert', '百分比格式不正确!');
			return false;
		}
		if (parseFloat(pcent) > (conHvOrdNum * 100)) {
			$UI.msg('alert', '百分比不能大于' + conHvOrdNum * 100 + '%,建议调整百分比!');
			return false;
		}
		if (((parseFloat(pcent) * parseFloat(conHvOrdNum) / 100) < 1) && (pcent !== '')) {
			$UI.msg('alert', '按百分比抽取随机数小于1,不能抽取!');
			return false;
		}
		// 间隔数
		var spaceqtynum = $('#conSpaceQty').val();
		if ((!(spaceqtynum > 0)) && (spaceqtynum != 0) && (spaceqtynum != '')) {
			$UI.msg('alert', '间隔数填写不正确!');
			return false;
		}
		if ((parseInt(spaceqtynum) != spaceqtynum) && (spaceqtynum != '')) {
			$UI.msg('alert', '间隔数只能填整数!');
			return false;
		}
		return true;
	}
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#CreateNoConditions');
		$UI.clearBlock('#CreateConditions');
		$UI.clearBlock('#FindConditions');
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#FindConditions', DefaultValue);
		$HUI.radio('#chkRandomNum').setValue(true);
	};
	Default();
};
$(init);