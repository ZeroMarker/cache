// ������Ϣά�����۵���
var AdjPriceEdit = function(AspInfo) {
	$HUI.dialog('#AdjPriceWin').open();
	$UI.clearBlock('#AdjPriceConditions');
	var AspIncid = AspInfo.AspIncid;
	var AspIncCode = AspInfo.AspIncCode;
	var AspIncDesc = AspInfo.AspIncDesc;
	var AspIncUom = AspInfo.AspIncUom;
	var PriorRpUom = AspInfo.PriorRpUom;
	var PriorSpUom = AspInfo.PriorSpUom;
	var AspStkGrpType = AspInfo.AspStkGrpType;
	var AspStkCat = AspInfo.AspStkCat;
	// var PreExecuteDate=DateFormatter(new Date());
	var PreExecuteDate = DateFormatter(DateAdd(new Date(), 'd', parseInt(1)));
	var jsonData = { AspIncCode: AspIncCode, AspIncDesc: AspIncDesc, AspIncUom: AspIncUom, PriorRpUom: PriorRpUom, PriorSpUom: PriorSpUom, PreExecuteDate: PreExecuteDate };
	$UI.fillBlock('#AdjPriceConditions', jsonData);

	$HUI.combobox('#AspReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetAdjPriceReason&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.validatebox('#ResultRpUom', {
		required: true,
		tipPosition: 'bottom',
		placeholder: '������۱���'
	});
	$HUI.validatebox('#ResultSpUom', {
		required: true,
		tipPosition: 'bottom',
		placeholder: '�����ۼ۱���'
	});
	$('#ResultRpUom').bind('change', function() {
		var RpPUom = $('#ResultRpUom').val();
		if (RpPUom != 0) {
			$('#ResultSpUom').val(RpPUom);
		}
	});
	$UI.linkbutton('#SaveAdjPriceBT', {
		onClick: function() {
			var MainParams = JSON.stringify(addSessionParams({ AdjspNo: '', ScgId: AspStkGrpType }));
			var PreExecuteDate = $('#PreExecuteDate').val();
			var ResultRpUom = $('#ResultRpUom').val();
			var ResultSpUom = $('#ResultSpUom').val();
			var AspUomId = $('#AspIncUom').combobox('getValue');
			var AspReason = $('#AspReason').combobox('getValue');
			if (isEmpty(PreExecuteDate) || isEmpty(ResultRpUom) || isEmpty(ResultSpUom) || isEmpty(AspReason)) {
				$UI.msg('alert', '�������Ϊ��');
				return;
			}
			var Today = DateFormatter(new Date());
			if (PreExecuteDate < Today) {
				$UI.msg('alert', '�ƻ���Ч���ڲ���С�ڵ�ǰ����');
				return;
			}
			var AdjPrDetailArr = [];
			var AdjPrDetail = addSessionParams({
				RowId: '',
				PreExecuteDate: PreExecuteDate,
				Inci: AspIncid,
				AspUomId: AspUomId,
				ResultSpUom: ResultSpUom,
				ResultRpUom: ResultRpUom,
				AdjReasonId: AspReason,
				PriorSpUom: PriorSpUom,
				PriorRpUom: PriorRpUom,
				AdjSPCat: '�ֶ�����',
				WarrentNo: '',
				WnoDate: '',
				InvNo: '',
				InvDate: ''
			});
			AdjPrDetailArr.push(AdjPrDetail);
			var DetailParams = JSON.stringify(AdjPrDetailArr);
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'SaveAdjPrice',
				Main: MainParams,
				Detail: DetailParams,
				AdjUserId: gUserId
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#AdjPriceWin').close();
					GetDetail(AspIncid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
};