// ����: ̨�˵�Ʒ��ϸͳ��
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			PhaLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
		var reportFrame = document.getElementById('TransDetailIFrame');
		reportFrame.src = '';
	};
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
		}
	});
	$('#ScgStk').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var StkGrpId = $('#ScgStk').combotree('getValue');
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var Obj = { StkGrpRowId: StkGrpId, StkGrpType: 'M', Locdr: PhaLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PhaLoc)) {
				$UI.msg('alert', '���Ҳ���Ϊ��!');
				return;
			}
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
			if (isEmpty(ParamsObj.Inci) && isEmpty(ParamsObj.InciDesc)) {
				$UI.msg('alert', '�������Ʋ���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkMoveStat.raq&Params=' + Params + '&Conditions=' + Conditions;
			var reportFrame = document.getElementById('TransDetailIFrame');
			reportFrame.src = CommonFillUrl(p_URL);
		}
	});
	function GetConditions(ParamsObj) {
		// ��ȡ��ѯ�����б�
		var Conditions = '';
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' ������: ' + ParamsObj.InciDesc;
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + '  ��ʼʱ�� ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '  ��ֹʱ�� ' + ParamsObj.EndDate;
		}
		return Conditions;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	Clear();
	GetReportStyle('#Report');
};
$(init);