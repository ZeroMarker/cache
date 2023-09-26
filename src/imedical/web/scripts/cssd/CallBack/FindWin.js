var FindWin=function(Fn){
	//请求科室
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			//$("#FReqLoc").combobox('setValue',gLocId);
		}
	});
	//供应科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			$("#FSupLoc").combobox('setValue',data[0].RowId);
		}
	});
	//楼号
	var FloorBox = $HUI.combobox('#FloorCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFloorCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			//$("#FloorCode").combobox('setValue',data[0].RowId);
		},
		onSelect: function (row) {
                    if (row != null) {
						//alert(row.RowId);
                        $HUI.combobox('#LineCode', {
                          url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array&FloorCode='+row.RowId,
                          valueField: 'RowId',
                          textField: 'Description',
						  	onLoadSuccess: function (data) {   //默认第一个值
								$("#LineCode").combobox('setValue',data[0].RowId);
							}
                      }); 
                    }
                }

	});
	/* //线路号
	var LineBox = $HUI.combobox('#LineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			//$("#LineCode").combobox('setValue',data[0].RowId);
		}
	}); */
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
			}
	$UI.clearBlock('#SelBarCodeConditions');
	$UI.fillBlock('#FindWin',Dafult);
	$HUI.dialog('#FindWin').open();
	$UI.linkbutton('#FCancelBT',{
		onClick:function(){
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FSuerBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindWin');
			Fn(ParamsObj);
			$HUI.dialog('#FindWin').close();
		}
	});
}
