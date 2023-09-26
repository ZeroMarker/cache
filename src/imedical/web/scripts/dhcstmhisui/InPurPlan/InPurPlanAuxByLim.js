var init = function() {

	/*--按钮事件--*/
	$UI.linkbutton('#TipBT',{
		onClick:function(){
			$HUI.dialog('#FindWin').open()
		}
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			if(isEmpty(ParamsObj.PurLoc)){
				$UI.msg("alert","采购科室不能为空!");
				return;
			}
			var Fac=ParamsObj.RepLevFac
			if(Fac<0||Fac>1){
				$UI.msg("alert","标准补货取整比例应该是0-1之间的数!");
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			PurGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanAuxByLim',
				QueryName: 'QueryLocItmForPurch',
				Params:Params,
				rows: 99999
			});
		}
	});
	
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			Save();
		}
	});
	function Save(){
		if(savecheck()==true){
			var MainObj=$UI.loopBlock('#MainConditions')
			var Main=JSON.stringify(MainObj)
			var DetailObj=PurGrid.getRowsData();
			if(DetailObj==""){
				$UI.msg('alert','没有需要保存的明细!')
				return;
			}
			var Detail=JSON.stringify(DetailObj)
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'Save',
				Main: Main,
				Detail: Detail
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.clear(PurGrid);
					$UI.msg("success",jsonData.msg);
					var purId=jsonData.rowid;
					var UrlStr = "dhcstmhui.inpurplan.csp?gPurId="+purId;
					Common_AddTab('采购', UrlStr);
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
		}
	}
	//数据检查
	function savecheck(){
		var rowsData = PurGrid.getRows();
		for(var i=0;i<rowsData.length;i++){
			var row=rowsData[i]
			var InciId=row.InciId;
			var UomId=row.UomId;
			var Qty=row.Qty;
			if ((UomId=="")&&(InciId!="")){
				$UI.msg("alert","第"+(i+1)+"行单位为空");
				return false;
			}
			if(InciId!=""&&Qty<0){
				$UI.msg("alert","第"+(i+1)+"行数量不能小于0");
				return false;
			}
		}
		return true;
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default();
		}
	});
	
	/*--绑定控件--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var rows =PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.InciId;
				}
			},
			onSelect:function(record){
				var rows =PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				var seluom=record.RowId
				var rp=row.Rp
				var buom=row.BUomId
				var confac=row.ConFac
				var uom=row.UomId  //旧单位
				if(seluom!=uom){
					if(seluom!=buom){		//原单位是基本单位，目前选择的是入库单位
						Rp=Number(rp).mul(confac); 
					}else{					//目前选择的是基本单位，原单位是入库单位
						Rp=Number(rp).div(confac);
					}
				}
				PurGrid.updateRow({
					index:PurGrid.editIndex,
					row: {
						UomDesc:record.Description,
						UomId:record.RowId,
						Rp:Rp
					}
				});
				$('#PurGrid').datagrid('refreshRow', PurGrid.editIndex);
				//setTimeout(function(){PurGrid.refreshRow();},0);
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	/*--Grid--*/
	var PurCm = [[
		{
			title:"物资RowId",
			field:'InciId',
			hidden:true
		}, {
			title:"代码",
			field:'InciCode',
			width:100
		}, {
			title:"描述",
			field:'InciDesc',
			width:100
		}, {
			title:"建议采购量",
			field:'PurQty',
			width:100,
			align:'right'
		}, {
			title:"实际采购量",
			field:'Qty',
			width:100,
			align:'right',
			necessary:true,
			editor:{
				type:'numberbox',
				options:{
					required:true
				}
			}
		}, {
			title:"单位",
			field:'UomId',
			width:80,
			necessary:true,
			formatter: CommonFormatter(UomCombox,'UomId','UomDesc'),
			editor:UomCombox
		}, {
			title:"供应商Id",
			field:'VendorId',
			width:80,
			hidden:true
		}, {
			title:"供应商",
			field:'VendorDesc',
			width:80
		}, {
			title:"厂商Id",
			field:'ManfId',
			width:80,
			hidden:true
		}, {
			title:"厂商",
			field:'ManfDesc',
			width:80
		}, {
			title:"进价",
			field:'Rp',
			width:100,
			align:'right'
		}, {
			title:"采购科室库存",
			field:'StkQty',
			width:100,
			align:'right'
		}, {
			title:"库存上限",
			field:'MaxQty',
			width:100,
			align:'right'
		}, {
			title:"库存下限",
			field:'MinQty',
			width:100,
			align:'right'
		}, {
			title:"标准库存",
			field:'RepQty',
			width:80,
			align:'right'
		}, {
			title:"参考库存",
			field:'LevelQty',
			width:80,
			align:'right'
		}, {
			title:"补货标准",
			field:'RepLev',
			width:80,
			align:'right'
		}, {
			title:"配货商Id",
			field:'CarrierId',
			width:80,
			hidden:true
		}, {
			title:"配货商",
			field:'CarrierDesc',
			width:80
		}, {
			title:"资质信息",
			field:'ApcWarn',
			width:80
		}, {
			title:"基本单位",
			field:'BUomId',
			width:80,
			hidden:true
		}, {
			title:"转换系数",
			field:'ConFac',
			width:80,
			hidden:true
		}
	]];
	
	var PurGrid = $UI.datagrid('#PurGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanAuxByLim',
			QueryName: 'QueryLocItmForPurch',
			rows: 99999
		},
		columns: PurCm,
		pagination:false,
		showBar:true,
		onClickCell: function(index, filed ,value){
			PurGrid.commonClickCell(index,filed,value)
		}
	})
	/*--设置初始值--*/
	var Default=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurGrid);
		///设置初始值 考虑使用配置
		var DefaultValue={
			PurLoc:gLocObj
		}
		$UI.fillBlock('#MainConditions',DefaultValue)
	}
	Default()
}
$(init);