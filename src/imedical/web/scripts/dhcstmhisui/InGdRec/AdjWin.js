// 入库调价window
var SetAdjPrice = function(DataPrj) {
	$HUI.dialog('#AdjPriceWin').open();
	var tmpInci = DataPrj.Incid;
	var AspUomBox = $HUI.combobox('#AspUomId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array&Inci=' + tmpInci,
		valueField: 'RowId',
		textField: 'Description'
	});
	var tmpPreExecuteDate = DateAdd(new Date(), 'd', parseInt(1));
	var tmpIncidesc = DataPrj.Incidesc;
	var tmpIncicode = DataPrj.Incicode;
	var tmpStkGrpType = DataPrj.StkGrpType;
	var tmpLocId = DataPrj.LocDr;
	var tmpPriorSp = DataPrj.PriorSp;
	var tmpPriorRp = DataPrj.PriorRp;
	var tmpResultSp = DataPrj.ResultSp;
	var tmpResultRp = DataPrj.ResultRp;
	var tmpAspUomId = DataPrj.AdjSpUomId;
	var jsonData = { Code: tmpIncicode, Description: tmpIncidesc, PriorSpUom: tmpPriorSp, PriorRpUom: tmpPriorRp, ResultSpUom: tmpResultSp, ResultRpUom: tmpResultRp, AspUomId: tmpAspUomId };
	$UI.fillBlock('#AdjPriceConditions', jsonData);
	
	// /var result=tkMakeServerCall('web.DHCSTMHUI.INAdjSalePrice','Save',Main,Detail);
	$UI.linkbutton('#SaveAdjPrBT', {
		onClick: function() {
			var MainParams = JSON.stringify(addSessionParams({ AdjspNo: '' }));
			var AdjPrDetailArr = [];
			var AdjPrDetail = addSessionParams({ RowId: '', PreExecuteDate: tmpPreExecuteDate, Inci: DataPrj.Incid, AspUomId: DataPrj.AdjSpUomId, ResultSpUom: DataPrj.ResultSp,
				ResultRpUom: DataPrj.ResultRp, AdjReasonId: '', WarrentNo: '', WnoDate: '', InvNo: '',
				InvDate: '', PriorSpUom: DataPrj.PriorSp, PriorRpUom: DataPrj.PriorRp, AdjSPCat: '自动调价' });
			AdjPrDetailArr.push(AdjPrDetail);
			var DetailParams = JSON.stringify(AdjPrDetailArr);
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'Save',
				Main: MainParams,
				Detail: DetailParams
			}, function(jsonData) {
				$UI.msg('success', jsonData.msg);
				$HUI.dialog('#AdjPriceWin').close();
			});
		}
	});
};