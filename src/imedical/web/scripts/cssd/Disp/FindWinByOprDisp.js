var FindWinByOprDisp=function(Fn){
	 //�������
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�¼����
			//$("#FReqLoc").combobox('setValue',gLocId);
		}
	});
	//��Ӧ����
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
			$("#FSupLoc").combobox('setValue',data[0].RowId);
		}
	});
	//����
	var SupLocBox = $HUI.combobox('#FYMonth', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetYMonth&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
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