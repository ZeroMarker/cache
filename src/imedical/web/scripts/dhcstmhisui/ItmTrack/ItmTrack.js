/*高值跟踪*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
		///设置初始值 考虑使用配置
		var Dafult={
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: "N",
			FStatusBox: "Y"
		};
		$UI.fillBlock('#FindConditions',Dafult);
	}
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FRecLocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var VendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	$HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	$('#Status').simplecombobox({
		data: [
			{RowId: 'Reg', Description: '注册'},
			{RowId: 'Enable', Description: '可用'},
			{RowId: 'Used', Description: '已用'},
			{RowId: 'Else', Description: '其他'}
		]
	});
	$('#wardno').bind('keydown', function(event){
		if(event.keyCode == 13){
			var PapmiNo = $(this).val();
			if(isEmpty(PapmiNo)){
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try{
				var patinfostr=tkMakeServerCall("web.DHCSTMHUI.HVMatOrdItm", "Pa",PapmiNo);
				var patinfoarr=patinfostr.split("^");
				var newPaAdmNo=patinfoarr[0];
				var patinfo=patinfoarr[1]+","+patinfoarr[2];
				$("#wardno").val(newPaAdmNo);
			}catch(e){}
			 return false;
		}
	});
	var HandlerParams=function(){
		var Obj={Hv:'Y',StkGrpType:"M"};
		return Obj;
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			Params:Params
		});
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	
	$UI.linkbutton('#PrintBT',{
		onClick: function(){
			var rowsData = BarMainGrid.getSelections();
			if(isEmpty(rowsData)){
				$UI.msg('alert', '请选择需要打印的条码!');
				return;
			}
			for(var i = 0, Len = rowsData.length; i < Len; i++){
				var row = rowsData[i];
				var BarCode = row['BarCode'];
				PrintBarcode(BarCode,1);
			}
		}
	});
	
	var BarMainCm = [[
		{
			title : "RowId",
			field : 'RowId',
			width : 50,
			hidden : true
		}, {
			title : "InciId",
			field : 'InciId',
			width : 120,
			hidden : true
		}, {
			title : '物资代码',
			field : 'InciCode',
			width : 100
		}, {
			title : '物资名称',
			field : 'InciDesc',
			width : 150
		}, {
			title : "条码",
			field : 'BarCode',
			width : 200
		}, {
			title : "自带条码",
			field : 'OriginalCode',
			width : 200
		}, {
			title : '状态',
			field : 'Status',
			formatter : StatusFormatter,
			width : 70
		}, {
			title : "当前位置",
			field : 'CurrentLoc',
			width : 100
		}, {
			title : "打印标记",
			field : 'PrintFlag',
			formatter : BoolFormatter,
			align : 'center',
			width : 80
		}, {
			title : 'Incib',
			field : 'Incib',
			width : 90,
			hidden: true
		}, {
			title : 'Inclb',
			field : 'Inclb',
			width : 100,
			hidden: true
		}, {
			title : '批号~效期',
			field : 'BatExp',
			width : 150,
			hidden : true
		},{
			title : '批号',
			field : 'BatNo',
			width : 100
		},{
			title : '效期',
			field : 'ExpDate',
			width : 90
		}, {
			title : '规格',
			field : 'Spec',
			width : 90
		}, {
			title : "具体规格",
			field : 'SpecDesc',
			width : 120
		}, {
			title : "单位",
			field : 'UomDesc',
			width : 80
		}, {
			title : "供应商",
			field : 'VendorDesc',
			width : 160
		}, {
			title : "厂商",
			field : 'ManfDesc',
			width : 160
		}, {
			title : "条码生成(注册)时间",
			field : 'DateTime',
			width : 160
		}, {
			title : "操作人",
			field : 'DhcitUser',
			width : 100
		}, {
			title: '自带批次码',
			field: 'BatchCode',
			width: 200
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query'
		},
		columns: BarMainCm,
		showBar:true,
		onSelect:function(index, row){
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				Parref: row['RowId'],
				rows: 99999
			});
		},
		onDblClickRow: function(index, row){
			var RowId = row['RowId'];
			if (isEmpty(RowId)) {
				return;
			}
			var BarCode = row['BarCode'];
			var InciDesc = row['InciDesc'];
			var InfoStr = BarCode + ' : ' + InciDesc;
			BarCodePackItm(RowId, InfoStr);
		}
	})
	
	var BarDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '类型',
			field : 'Type',
			formatter : TypeRenderer,
			width : 80
		}, {
			title : 'Pointer',
			field : 'Pointer',
			width : 80,
			hidden: true
		}, {
			title : '台账标记',
			field : 'IntrFlag',
			formatter : BoolFormatter,
			align : 'center',
			width : 80
		}, {
			title : '处理号',
			field : 'OperNo',
			width : 120
		}, {
			title : '业务发生日期',
			field : 'Date',
			hidden : true,
			width : 120
		}, {
			title : "业务发生时间",
			field : 'Time',
			formatter : function(value, row, index){
				return row['Date'] + ' ' + value;
			},
			width : 160
		}, {
			title : "业务操作人",
			field : 'User',
			width : 80
		}, {
			title : "位置信息",
			field : 'OperOrg',
			width : 120
		}		
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem',
			rows: 99999
		},
		pagination:false,
		columns: BarDetailCm,
		showBar:true
	});
	
	Clear();
}
$(init);