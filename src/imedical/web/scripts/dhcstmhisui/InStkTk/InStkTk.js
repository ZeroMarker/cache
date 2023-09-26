var init = function() {
	//=======================条件初始化start==================
	var UseItmTrack=GetAppPropValue('DHCITMTRACKM').UseItmTrack;
	//科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange:function(e){
			init(e)
		}
	});
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
			});
		}
	})
	//库存分类
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
		});
	var HVFlagParams=JSON.stringify(addSessionParams());
	var HVFlag = $HUI.combobox('#HVFlag', {
			url:$URL + '?ClassName=web.DHCSTMHUI.INStkTk&QueryName=GetHVflag&ResultSetType=array&HVFlagParams='+HVFlagParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	
	function init(LocId){
		var LocManGrpBox = $HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId='+LocId,
			valueField: 'RowId',
			textField: 'Description',
			multiple:true,
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			formatter:function(row){  
				var opts;
				if(row.selected==true){
					opts = row.Description+"<span id='i"+row.RowId+"' class='icon icon-ok'></span>";
				}else{
					opts = row.Description+"<span id='i"+row.RowId+"' class='icon'></span>";
				}
				return opts;
			},
			onSelect:function(rec) {
				var obji =  document.getElementById("i"+rec.RowId);
				$(obji).addClass('icon-ok');
			},
			onUnselect:function(rec){
				var obji =  document.getElementById("i"+rec.RowId);
				$(obji).removeClass('icon-ok');
			}
		});
			//起始货位
		var StartLocStkBinParams=JSON.stringify(addSessionParams({LocDr:LocId}));
		var StartLocStkBinBox = $HUI.combobox('#StartLocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+StartLocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		//终止货位
		var StartLocStkBinParams=JSON.stringify(addSessionParams({LocDr:LocId}));
		var StartLocStkBinBox = $HUI.combobox('#EndLocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+StartLocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	
	//===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			FindWin(query);
		}
	});
	var query = function query(Params){ 
		if(isEmpty(Params.FStartDate)){
			Params.FStartDate=DateFormatter(new Date())
		}
		if(isEmpty(Params.FEndDate)){
			Params.FEndDate=DateFormatter(new Date())
		}
		if(isEmpty(Params.FLocId)){
			var loc=$('#SupLoc').combobox('getValue');
			Params.FLocId=loc;
		}
		var Params=JSON.stringify(Params)
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			sort:"instNo",
			order:"desc",
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	function Clear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
				SupLoc:gLocObj,
				InstNo:"",
				InstDate:"",
				InstTime:"",
				Comp:"",
				Remark:"",
				StartLocStkBin:"",
				ScgStk:"",
				StkCatBox:"",
				MinRp:"",
				MaxRp:"",
				EndLocStkBin:"",
				RandomNum:"",
				NotUseFlag:"",
				HVFlag:UseItmTrack=="Y"?2:0,
				TkUom:"1",
				ManageDrugFlag:""
			}
		$UI.fillBlock('#MainConditions',Dafult)
		DetailGrid.setFooterInfo();
	}
	//生成盘点点
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions');
			MainObj.LocManGrp = MainObj.LocManGrp.join(',');
			var LocId = MainObj['SupLoc'];
			if(isEmpty(LocId)){
				$UI.msg('alert', '请选取科室!');
				return;
			}
			var HVFlag=MainObj.HVFlag;
			if(isEmpty(HVFlag)){
				$UI.msg('alert','高值标志不能为空');
				return;
			}
			var CheckParams = {LocId : LocId};
			var CheckRet = $.m({
				ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
				MethodName: 'CheckBeforeInstk',
				Params: JSON.stringify(CheckParams)
			},false);
			if(!isEmpty(CheckRet)){
				$UI.msg('alert', CheckRet);
				return;
			}
			var Main=JSON.stringify(MainObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.INStkTk',
				MethodName: 'jsCreateInStktk',
				Main: Main
			},function(jsonData){
				if(jsonData.success>=0){
					$UI.msg('success',jsonData.msg);
					var ParamsObj=$UI.loopBlock('#FindWin');
					query(ParamsObj)
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	
	//完成
	var Comp= function(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选操作数据!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSetComplete',
			inst: row.inst
		},function(jsonData){
			if(jsonData.success>=0){
				var ParamsObj=$UI.loopBlock('#FindWin');
				query(ParamsObj)
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	//取消完成
	var SetUnComplete= function(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选操作数据!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSetUnComplete',
			inst: row.inst
		},function(jsonData){
			if(jsonData.success>=0){
				$UI.msg('success',jsonData.msg);
				var ParamsObj=$UI.loopBlock('#FindWin');
				query(ParamsObj);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	//删除
	var Delete = function(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','请选操作数据!');
			return false;
		}
		if (row.comp=="Y") {
			$UI.msg('alert','请先取消完成后再删除操作!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsDelete',
			inst: row.inst
		},function(jsonData){
			if(jsonData.success>=0){
				$UI.msg('success',jsonData.msg);
				var ParamsObj=$UI.loopBlock('#FindWin');
				Clear();
				query(ParamsObj);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function Select(){
		$UI.clearBlock('#MainConditions');
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			inst: row.inst
		}, function(jsonData){
			$UI.fillBlock('#MainConditions',jsonData);
			$("#LocManGrp").combobox("setValues",jsonData.InStkGrpId.split(','));
			//按钮控制
			if($HUI.checkbox("#Comp").getValue()){
				//setEditDisable();
			}else{
				//setEditEnable();
			}
		});
	}
	//加载明细
	function loadDetailGrid(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		var ParamsObj=$UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItm',
				QueryName: 'jsDHCSTInStkTkItm',
				Inst: row.inst,
				Others:"",
				qPar:"",
				totalFooter:'"code":"合计"',
				totalFields:'freQty,freezeRpAmt'
			});
	}
	//打印
	function print(type){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		var ret = tkMakeServerCall("web.DHCSTMHUI.INStkTk", "UpPrintFlag", row.inst);
		PrintINStk(row.inst, type);
	}
	//======================tbar操作事件end============================
	
	var MasterGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		},{
			title: '盘点单号',
			field: 'instNo',
			width:200
		}, {
			title:"日期",
			field:'date',
			width:100,
			align:'left'
		}, {
			title:"时间",
			field:'time',
			width:70,
			align:'left'
		}, {
			title:"盘点人rowid",
			field:'user',
			hidden: true
		}, {
			title:"盘点人",
			field:'userName',
			width:70,
			align:'left'
		}, {
			title:"状态",
			field:'status',
			width:70,
			align:'left',
			hidden: true
		},  {
			title:"科室rowid",
			field:'loc',
			hidden:true
		},  {
			title:"科室",
			field:'locDesc',
			width:100,
			align:'left'
		}, {
			title:"盘点完成",
			field:'comp',
			width:70,
			align:'left',
			formatter: function(value,row,index){
				if (row.comp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"实盘录入完成",
			field:'stktkComp',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"调整完成",
			field:'adjComp',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"adj",
			field:'adj',
			hidden:true
		}, {
			title:"manFlag",
			field:'manFlag',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"账盘单位",
			field:'freezeUom',
			width:70,
			align:'left',
			formatter: function(value,row,index){
				if (row.freezeUom==1){
					return "入库单位";
				} else {
					return "基本单位";
				}
			}
		}, {
			title:"账盘进价金额",
			field:'SumFreezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"账盘售价金额",
			field:'SumFreezeSpAmt',
			width:100,
			align:'right'
		}, {
			title:"包括不可用",
			field:'includeNotUse',
			width:100,
			align:'left'
		}, {
			title:"仅不可用",
			field:'onlyNotUse',
			width:70,
			align:'left'
		}, {
			title:"类组rowid",
			field:'scg',
			hidden:true
		}, {
			title:"类组",
			field:'scgDesc',
			width:70,
			align:'left'
		}, {
			title:"库存分类rowid",
			field:'sc',
			hidden:true
		}, {
			title:"库存分类",
			field:'scDesc',
			width:70,
			align:'left'
		}, {
			title:"开始货位",
			field:'frSb',
			width:70,
			align:'left'
		}, {
			title:"结束货位",
			field:'toSb',
			width:70,
			align:'left'
		}, {
			title:"录入类型",
			field:'InputType',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"打印标志",
			field:'printflag',
			width:70,
			align:'left'
		}, {
			title:"最低进价",
			field:'MinRp',
			width:70,
			align:'right'
		}, {
			title:"最高进价",
			field:'MaxRp',
			width:70,
			align:'right'
		}, {
			title:"随机数",
			field:'RandomNum',
			width:70,
			align:'right'
		}, {
			title:"高值标志",
	        	field:'HighValue',
			width:70,
			align:'left'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid',{
		url : $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk'
		},
		columns: MasterGridCm,
		showBar: true,
		toolbar:[{
				text: '完成',
				iconCls: 'icon-ok',
				handler: function () {
					Comp();
				}},{
				text: '取消完成',
				iconCls: 'icon-no',
				handler: function () {
					SetUnComplete();
				}},{
				text: '删除',
				iconCls: 'icon-cancel',
				handler: function () {
					Delete();
				}},{
				text: '按批次打印',
				iconCls: 'icon-print',
				handler: function () {
					var type = 1;
					print(type);
				}},{
				text: '按品种打印',
				iconCls: 'icon-print',
				handler: function () {
					var type = 2;
					print(type);
				}}],
		onSelect:function(index, row){
			loadDetailGrid();
			Select();
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#MasterGrid').datagrid("selectRow", 0)
				loadDetailGrid();
				Select();
			}
		}
	})
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
			title:"厂商",
			field:'manf',
			width:100
		}, {
			title:"条码",
			field:'barcode',
			width:100,
			align:'left'
		}, {
			title:"账盘数量",
			field:'freQty',
			width:100,
			align:'right'
		}, {
			title:"账盘日期",
			field:'freDate',
			width:100
		}, {
			title:"账盘时间",
			field:'freTime',
			width:100,
			align:'left'
		}, {
			title:"实盘数量",
			field:'countQty',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"实盘日期",
			field:'countDate',
			width:100,
			hidden:true
		}, {
			title:"实盘时间",
			field:'countTime',
			width:80,
			align:'left',
			hidden:true
		}, {
			title:"实盘人",
			field:'countPerson',
			hidden: true,
			align:'left',
			hidden:true
		}, {
			title:"实盘人",
			field:'countPersonName',
			width:100,
			align:'left',
			hidden:true
		}, {
			title:"dd",
			field:'variance',
			width:100,
			align:'left',
			hidden:true
		}, {
			title:"备注",
			field:'remark',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"状态",
			field:'status',
			width:60,
			align:'left'
		}, {
			title:"单位",
			field:'uom',
			hidden: true,
			align:'left',
			hidden:true
		}, {
			title:"单位",
			field:'uomDesc',
			width:60,
			align:'left'
		}, {
			title:"批号",
			field:'batchNo',
			width:100,
			align:'left'
		}, {
			title:"有效期",
			field:'expDate',
			width:100,
			align:'left'
		}, {
			title:"具体规格",
			field:'specdesc',
			width:100,
			align:'left'
		}, {
			title:"调整标志",
			field:'adjFlag',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"货位码",
			field:'sbDesc',
			width:100,
			align:'left'
		}, {
			title:"dd",
			field:'inadi',
			hidden: true,
			align:'left',
			hidden:true
		}, {
			title:"售价",
			field:'sp',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"进价",
			field:'rp',
			width:60,
			align:'right'
		}, {
			title:"账盘售价金额",
			field:'freezeSpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"账盘进价金额",
			field:'freezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"实盘售价金额",
			field:'countSpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"实盘进价金额",
			field:'countRpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"损益售价金额",
			field:'varianceSpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"损益进价金额",
			field:'varianceRpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"dd",
			field:'trueQty',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"类组",
			field:'scgDesc',
			width:100,
			align:'left'
		}, {
			title:"供应商",
			field:'vendor',
			width:100,
			align:'left'
		}, {
			title:"库存分类",
			field:'incscdesc',
			width:100,
			align:'left'
		}, {
			title:"dd",
			field:'freeBarCode',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"dd",
			field:'countBarCode',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"dd",
			field:'varianceBarCode',
			width:60,
			align:'left',
			hidden:true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm'
		},
		columns : DetailGridCm,
		showBar: true,
		totalFooter:'"code":"合计"',
		totalFields:'freQty,freezeRpAmt'
	})
	Clear();
}
$(init);
