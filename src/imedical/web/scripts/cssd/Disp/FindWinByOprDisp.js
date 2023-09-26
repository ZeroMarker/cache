var FindWinByOprDisp=function(Fn){
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
	//年月
	var SupLocBox = $HUI.combobox('#FYMonth', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetYMonth&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			$("#FYMonth").combobox('setValue',data[0].RowId);
		}
	});	
	  var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
			}
	  $UI.fillBlock('#FindWin',Dafult)
	  $HUI.dialog('#FindWin').open()
	  $UI.linkbutton('#FCancelBT',{
		  onClick:function(){
			 $HUI.dialog('#FindWin').close();
		  }
	  });
	  $UI.linkbutton('#FSuerBT',{
		  onClick:function(){
			 var ParamsObj=$UI.loopBlock('#FindWin');
			 ParamsObj.ReqFlag="0,1"
			 Fn(ParamsObj);
			 $HUI.dialog('#FindWin').close();
		  }
	  });
	  
	  
}