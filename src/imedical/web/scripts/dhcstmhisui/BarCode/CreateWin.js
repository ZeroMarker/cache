var CreateWin=function(Fn){
	  $UI.clearBlock('#CreateWin');
	  var FRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	  var FRecLocBox = $HUI.combobox('#InGdRecLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	  });	
	  var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	  var VendorBox = $HUI.combobox('#InGdReqVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	  });
	  var tRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	  var tRecLocBox = $HUI.combobox('#InGdReqLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+tRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	  });	
	  ///设置初始值 考虑使用配置
	  var Dafult={
					InGdRecLocId:gLocObj
					}
	  $UI.fillBlock('#CreateWin',Dafult)
	
	  $HUI.dialog('#CreateWin').open()
	  $UI.linkbutton('#InGdCancelBT',{
		  onClick:function(){
			 $HUI.dialog('#CreateWin').close();
		  }
	  });
	  $UI.linkbutton('#InGdSuerBT',{
		  onClick:function(){
			  var ParamsObj=$UI.loopBlock('#CreateWin');
		  
		     // 判断入库单是否已审批
		     // 判断入库部门和供货商是否为空
		     var phaLoc = ParamsObj.InGdRecLocId;
		     if (isEmpty(phaLoc)) {
			    $UI.msg('alert','请选择入库科室!');
			    return false;
		      }
		      var vendor = ParamsObj.InGdReqVendor;
		      if (isEmpty(vendor)) {
			     $UI.msg('alert','请选择供应商!');
			     //Ext.getCmp('ApcvmDr').focus();
			     return false;
		       }
			 Fn(ParamsObj);
			 $HUI.dialog('#CreateWin').close();
			 
		  }
	  });
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#Source', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	 var VirtualFlag = $HUI.checkbox('#XK',{
		onCheckChange: function(e, value){
			if(value){
				var RecLoc = $('#InGdRecLocId').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',RecLoc);
				var InfoArr = Info.split("^");
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#InGdRecLocId'), VituralLoc, VituralLocDesc);
				$('#InGdRecLocId').combobox('setValue', VituralLoc);
			}else{
				$('#InGdRecLocId').combobox('setValue', gLocId);
			}
		}
	  });
	 
      function checkIngrData(){
	      var ParamsObj=$UI.loopBlock('#CreateWin');
		  
		  // 判断入库单是否已审批
		  // 判断入库部门和供货商是否为空
		  var phaLoc = ParamsObj.InGdRecLocId;
		  if (isEmpty(phaLoc)) {
			$UI.msg('alert','请选择入库科室!');
			return false;
		  }
		  var vendor = ParamsObj.InGdReqVendor;
		  if (isEmpty(vendor)) {
			$UI.msg('alert','请选择供应商!');
			//Ext.getCmp('ApcvmDr').focus();
			return false;
		  }
		  
		  var RowsData=BarCodeGrid.getRows();
		  // 有效行数
		  var count = 0;
	      for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
		  }
		  if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','请输入入库明细!');
			return false;
		  }
		
		  return true;
      }
      
	  
}