//名称:		实盘：录入方式四(高值扫码盘点)
var init = function() {
	//=======================条件初始化start==================
	//类组  库存分类联动
	$('#ScgStk').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				StkCatBox.loadData(data);
				})
			}
	})
	//库存分类
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
		});
	//货位
	var LocStkBinParams=JSON.stringify(addSessionParams({LocDr:gLocId}));
	var LocStkBinBox = $HUI.combobox('#LocStkBin', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+LocStkBinParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//管理组
	var LocManaGrpBox = $HUI.combobox('#LocManaGrp', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId='+gLocId,
		valueField: 'RowId',
		textField: 'Description'
	});
	//实盘窗口
	var InStkTkWinBox = $HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId='+gLocId,
			valueField: 'RowId',
			textField: 'Description',
			editable:false
		});
		$('#InStkTkWin').combobox('setValue', gInstwWin);
		$("#BarCode").bind('keypress',function(event){
			if(event.keyCode==13){
				var barcode= $("#BarCode").val();
				if(!isEmpty(barcode)){
					HVINStkTk(barcode);
					$("#BarCode").val("");
				}
			}
		})
	//===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	//清屏
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var Dafult={
				ScgStk:"",
				LocManaGrp:"",
				InstNo:"",
				StkCatBox:"",
				LocStkBin:"",
				InStkTkWin:""
			}
		$UI.fillBlock('#Conditions',Dafult);
	}
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDetail();
		}
	});
	
	var Select=function(inst){
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			inst: inst
			},
			function(jsonData){
				$UI.fillBlock('#Conditions',jsonData);
				QueryDetail();
		});
	}
	
	function QueryDetail(){
		var ParamsObj=$UI.loopBlock('#Conditions');
		$UI.setUrl(DetailGrid);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			qPar:"",
			Inst:ParamsObj.inst,
			Others: ""
		});
	}
	
	function loadHVBarCodeInfoGrid() {
		var row = $('#DetailGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.rowid)){
			$UI.msg('alert','参数错误!');
			return;
		}
		$UI.setUrl(HVBarCodeInfoGrid);
		HVBarCodeInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
				QueryName: 'jsItmTrackDetail',
				insti: row.rowid,
				Others:"",
				qPar:""
			});
	}
	
		//条码实盘
	function HVINStkTk(HVBarCode){
		if(isEmpty(HVBarCode)){
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTMHUI.INStkTkItmTrack', 'INStkTkItmTrack', HVBarCode, gRowid, gUserId);
		var resultArr = result.split('^');
		var ret = resultArr[0];
		if(ret === '0'){
			loadHVBarCodeInfoGrid();
		}else{
			if(ret == -10){
				$UI.msg('alert','该条码不存在!')
			}else if(ret == -11){
				$UI.msg('alert','该条码不在当前盘点单中!')
			}else if(ret == -12){
				$UI.msg('alert','该条码已进行扫码盘点!')
			}else{
				$UI.msg('alert','错误:' + ret)
			}
			return false;
		}
	}
	//======================tbar操作事件end============================
	var DetailGridCm = [[{
			title: 'rowid',
			field: 'rowid',
			hidden: true
		}, {
			title: 'inclb',
			field: 'inclb',
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			hidden: true
		}, {
			title: '物资代码',
			field: 'code',
			width:120
		}, {
			title: '物资名称',
			field: 'desc',
			width:150
		}, {
			title: "规格",
			field:'spec',
			width:100
		}, {
			title: "批号",
			field:'batchNo',
			width:100
		}, {
			title: "有效期",
			field:'expDate',
			width:100
		}, {
			title:"厂商",
			field:'manf',
			width:100
		}, {
			title:"账盘数量",
			field:'freQty',
			width:80,
			align:'right',
			hidden: true
		}, {
			title:"uomrowid",
			field:'uom',
			hidden:true
		}, {
			title:"单位",
			field:'uomDesc',
			width:100
		}, {
			title:"buomrowid",
			field:'buom',
			hidden:true
		}, {
			title:"基本单位",
			field:'buomDesc',
			width:80,
			hidden: true
		}, {
			title:"进价",
			field:'rp',
			width:100,
			align:'right',
			hidden: true
		}, {
			title:"售价",
			field:'sp',
			width:100,
			align:'right',
			hidden: true
		}, {
			title:"实盘数量",
			field:'countQty',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
					}
				}
		}, {
			title:"实盘日期",
			field:'countDate',
			width:100
		}, {
			title:"实盘时间",
			field:'countTime',
			width:100
		}, {
			title:"实盘人",
			field:'userName',
			width:60
		}, {
			title:"货位",
			field:'stkbin',
			width:60,
			hidden: true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		url : '',
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm'	
		},
		columns : DetailGridCm,
		onSelect:function(index, row){
			loadHVBarCodeInfoGrid();
		}
	})
	var HVBarCodeInfoGridCm = [[
		{
			title: 'instit',
			field: 'instit',
			hidden: true
		}, {
			title: '条码ID',
			field: 'dhcit',
			hidden: true
		} , {
			title:"高值条码",
			field:'HVBarCode',
			width:200
		}, {
			title:"盘点标志",
			field:'institFlag',
			width:100
		}
		]]
		
	var HVBarCodeInfoGrid = $UI.datagrid('#HVBarCodeInfoGrid',{
		url : '',
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			MethodName: 'jsItmTrackDetail'
		},
		columns : HVBarCodeInfoGridCm,
		rows:9999,
		onClickCell: function(index, filed ,value){
			HVBarCodeInfoGrid.commonClickCell(index,filed,value);
		}
	})
	Select(gRowid);
	
}
$(init);
