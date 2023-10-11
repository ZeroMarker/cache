/* ���ɵ�����*/
var init = function() {
	/* --�󶨿ؼ�--*/
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
	// ȡ���������������û�
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
	/* --��ť�¼�--*/
	$('#conSpaceQty').on('focus', function() {
		GetSpaceQty();
	});
	function GetSpaceQty() {
		var spaceQty = $('#conSpaceQty').val();
		var maxnum = $('#conHvOrdNum').val();		// ͳ�Ƹ�ֵҽ������
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
		$('#conSaveRandomNum').val('');				//	�ı������
		$HUI.radio('#chkPercent').setValue(true);		// ��ѡ��ѡ��
		$HUI.radio('#chkRandomNum').setValue(false);	// ��ѡ�򲻿���
	});
		
	$('#conSaveRandomNum').on('click', function() {
		$('#conSavePercent').val('');						//	�ı������
		$HUI.radio('#chkRandomNum').setValue(true);		// ��ѡ��ѡ��
		$HUI.radio('#chkPercent').setValue(false);		// ��ѡ�򲻿���
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
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
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
					$UI.msg('alert', '��ѯʧ�ܣ�������룺' + RetVal);
				} else {
					if (jobRetVal == 0) {
						$UI.msg('alert', 'û�з��������ĸ�ֵҽ��,�������ѯ����������!');
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
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			width: 150
		}, {
			title: '��ҽ������',
			field: 'OrdLocDesc',
			width: 150
		}, {
			title: 'ҽ��',
			field: 'OrdUser',
			width: 150
		}, {
			title: 'ҽ������',
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
			$UI.confirm('��ȷ��Ҫ���ɸ�ֵ��������?', 'warning', '', Create, '', '', '����', false);
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
						$UI.msg('alert', '��ѯʧ�ܣ��������' + jobRetVal);
					} else {
						if (jobRetVal < 0) {
							$UI.msg('alert', '���ɵ�����ʧ��!');
						} else {
							$UI.msg('success', '��ȡ�ɹ�!');
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
			$UI.msg('alert', '����ͳ�Ƹ�ֵҽ������!');
			return false;
		}
		if (conHvOrdNum == 0) {
			$UI.msg('alert', '��ֵҽ������Ϊ0,û�пɳ�ȡ�ĸ�ֵҽ��,����ͳ�Ƹ�ֵҽ��!');
			return false;
		}
		var rnum = $('#conSaveRandomNum').val();
		var pcent = $('#conSavePercent').val();
		if (isEmpty(rnum) && isEmpty(pcent)) {
			$UI.msg('alert', '������д��������߰ٷֱ�!');
			return false;
		}
		if ((!(rnum > 0)) && (!(pcent > 0))) {
			$UI.msg('alert', '��д����������߰ٷֱȸ�ʽ����ȷ�����޸ĺ�����!');
			return false;
		}
		var rnumstr = rnum.split('.');
		if (rnumstr[0] !== rnum) {
			$UI.msg('alert', '��д�����������ΪС�������޸ĺ�����!');
			return false;
		}
		if (parseFloat(rnum) > parseFloat((conHvOrdNum * conHvOrdNum))) {
			$UI.msg('alert', '����������ܸ�ֵҽ��������' + conHvOrdNum * 100 + '%,������������!');
			return false;
		}
		if (!(pcent > 0) && (pcent !== '')) {
			$UI.msg('alert', '�ٷֱȸ�ʽ����ȷ!');
			return false;
		}
		if (parseFloat(pcent) > (conHvOrdNum * 100)) {
			$UI.msg('alert', '�ٷֱȲ��ܴ���' + conHvOrdNum * 100 + '%,��������ٷֱ�!');
			return false;
		}
		if (((parseFloat(pcent) * parseFloat(conHvOrdNum) / 100) < 1) && (pcent !== '')) {
			$UI.msg('alert', '���ٷֱȳ�ȡ�����С��1,���ܳ�ȡ!');
			return false;
		}
		// �����
		var spaceqtynum = $('#conSpaceQty').val();
		if ((!(spaceqtynum > 0)) && (spaceqtynum != 0) && (spaceqtynum != '')) {
			$UI.msg('alert', '�������д����ȷ!');
			return false;
		}
		if ((parseInt(spaceqtynum) != spaceqtynum) && (spaceqtynum != '')) {
			$UI.msg('alert', '�����ֻ��������!');
			return false;
		}
		return true;
	}
	/* --���ó�ʼֵ--*/
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