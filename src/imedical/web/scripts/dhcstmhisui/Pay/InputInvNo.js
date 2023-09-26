/*��ⵥ���*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(InputInvnoGrid);
		var IngrParamObj = GetAppPropValue('DHCITMTRACKM');	
		function DefaultStDate(){
	    var Today = new Date();
	    var DefaStartDate = IngrParamObj.DefaStartDate;
	    if(isEmpty(DefaStartDate)){
		   return Today;
	    }
	    var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	       return DateFormatter(EdDate);		
        }
 
       function DefaultEdDate(){
	    var Today = new Date();
	    var DefaEndDate = IngrParamObj.DefaEndDate;
	    if(isEmpty(DefaEndDate)){
		    return Today;
	    }
	    var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	    return DateFormatter(EdDate);
      }
	   ///���ó�ʼֵ ����ʹ������
		var Dafult={fromDate: DefaultStDate(),
					toDate: DefaultEdDate(),
					
					}
		$UI.fillBlock('#MainConditions',Dafult)
	   }
	var FReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FReqLocBox = $HUI.combobox('#ReqLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FReqLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	
	var FVendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var FVendorBox = $HUI.combobox('#FVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
		});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	
	var InputInvnoCm = [[
	    {	field: 'ck',
			checkbox: true
		},{
			title : "orirowid",
			field : 'orirowid',
			width : 100,
			hidden : true
		}, {
			title : "inci",
			field : 'inci',
			width : 120,
			hidden : true
		}, {
			title : '��Ӧ��',
			field : 'vendor',
			width : 150
		}, {
			title : '���ʴ���',
			field : 'code',
			width : 150
		}, {
			title : '��������',
			field : 'inciDesc',
			width : 150
		}, {
			title : "��������",
			field : 'barcode',
			width : 200
		}, {
			title : "��Ʊ��",
			field : 'invno',
			width : 200,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : '��Ʊ����',
			field : 'invdate',
			width : 70,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title : '��Ʊ���',
			field : 'invamt',
			width : 90,
			editor:{
				type:'numberbox',
				options:{
					   required:true
					}
				}
		}, {
			title : '��ⵥ��',
			field : 'ingno',
			width : 70
		}, {
			title : '��ⵥ��dr',
			field : 'ingri',
			width : 70,
			hidden:true
		}, {
			title : '��¼����ӱ�Dr',
			field : 'IngriModify',
			width : 90,
            hidden:true
		}, {
			title : "��¼��ⵥ��",
			field : 'IngriModifyNo',
			width : 120
		}, {
			title : "��������",
			field : 'dateofmanu',
			width : 80
		}, {
			title : "ҽ������",
			field : 'orddate',
			width : 100
		}, {
			title : "ҽ��ʱ��",
			field : 'ordtime',
			width : 100
		}, {
			title : "����",
			field : 'qty',
			width : 100
		}, {
			title : "��λ",
			field : 'uomdesc',
			width : 100
		}, {
			title : "����",
			field : 'rp',
			width : 100
		}, {
			title : "����",
			field : 'ward',
			width : 100
		}, {
			title : "����",
			field : 'manf',
			width : 100
		}, {
			title : "���ߵǼǺ�",
			field : 'pano',
			width : 100
		}, {
			title : "��������",
			field : 'paname',
			width : 100
		}, {
			title : "ҽ��",
			field : 'doctor',
			width : 100
		}, {
			title : "���տ���",
			field : 'admloc',
			width : 100
		}
	]];
	var InputInvnoGrid = $UI.datagrid('#InputInvnoGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InputInvNo',
			QueryName: 'Query'
		},
		columns: InputInvnoCm,
		showBar:false,
		singleSelect:false,
		onSelect:function(index, row){
			
		}
	})
	
	
	function Query(){
		var ParamsObj=$UI.loopBlock('#MainConditions')
		if(isEmpty(ParamsObj.fromDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.toDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(InputInvnoGrid);
		InputInvnoGrid.load({
			ClassName: 'web.DHCSTMHUI.InputInvNo',
			QueryName: 'find',
			Params:Params
		});
	}
	function Save(){
		var RowsData=InputInvnoGrid.getSelections();
		// ��Ч����
		var count = 0;
	    for (var i = 0; i < RowsData.length; i++) {
	       var item = RowsData[i].RowId;
		   if (!isEmpty(item)) {
				count++;
		   }
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','��ѡ����ϸ!');
			return false;
		}
		var RowsData=InputInvnoGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.InputInvNo',
			MethodName: 'Update',
			ListData: JSON.stringify(RowsData)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				Query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	Clear();

}
$(init);