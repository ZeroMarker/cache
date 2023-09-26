/*入库单审核*/
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
	   ///设置初始值 考虑使用配置
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
			title : '供应商',
			field : 'vendor',
			width : 150
		}, {
			title : '物资代码',
			field : 'code',
			width : 150
		}, {
			title : '物资名称',
			field : 'inciDesc',
			width : 150
		}, {
			title : "物资条码",
			field : 'barcode',
			width : 200
		}, {
			title : "发票号",
			field : 'invno',
			width : 200,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : '发票日期',
			field : 'invdate',
			width : 70,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title : '发票金额',
			field : 'invamt',
			width : 90,
			editor:{
				type:'numberbox',
				options:{
					   required:true
					}
				}
		}, {
			title : '入库单号',
			field : 'ingno',
			width : 70
		}, {
			title : '入库单号dr',
			field : 'ingri',
			width : 70,
			hidden:true
		}, {
			title : '补录入库子表Dr',
			field : 'IngriModify',
			width : 90,
            hidden:true
		}, {
			title : "补录入库单号",
			field : 'IngriModifyNo',
			width : 120
		}, {
			title : "生成日期",
			field : 'dateofmanu',
			width : 80
		}, {
			title : "医嘱日期",
			field : 'orddate',
			width : 100
		}, {
			title : "医嘱时间",
			field : 'ordtime',
			width : 100
		}, {
			title : "数量",
			field : 'qty',
			width : 100
		}, {
			title : "单位",
			field : 'uomdesc',
			width : 100
		}, {
			title : "进价",
			field : 'rp',
			width : 100
		}, {
			title : "病区",
			field : 'ward',
			width : 100
		}, {
			title : "厂商",
			field : 'manf',
			width : 100
		}, {
			title : "患者登记号",
			field : 'pano',
			width : 100
		}, {
			title : "患者姓名",
			field : 'paname',
			width : 100
		}, {
			title : "医生",
			field : 'doctor',
			width : 100
		}, {
			title : "接收科室",
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
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.toDate)){
			$UI.msg('alert','截止日期不能为空!');
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
		// 有效行数
		var count = 0;
	    for (var i = 0; i < RowsData.length; i++) {
	       var item = RowsData[i].RowId;
		   if (!isEmpty(item)) {
				count++;
		   }
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','请选择明细!');
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