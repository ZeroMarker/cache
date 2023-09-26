// 名称:库存报损制单(高值)
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');
var init = function() {
	var ClearMain=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(INScrapMGrid);
		setEditEnable();
		Dafult()
		$UI.fillBlock('#MainConditions',DafultValue)
	}
	function setEditDisable(){
		$HUI.combobox("#SupLoc").disable();
		$HUI.combobox("#ScgStk").disable();
		$HUI.combobox("#INScrapReason").disable();
	}
	///放开可编辑组件的disabled属性
	function setEditEnable(){
		$HUI.combobox("#ScgStk").enable();
		$HUI.combobox("#SupLoc").enable();
		$HUI.combobox("#INScrapReason").enable();
	}
//Grid 列 comboxData
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var rows =INScrapMGrid.getRows();  
				var row = rows[INScrapMGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.Inci;
				}
				
			},
			onSelect:function(record){
				var rows =INScrapMGrid.getRows();  
				var row = rows[INScrapMGrid.editIndex];
				row.UomDesc=record.Description;
				$('#INScrapMGrid').datagrid('refreshRow', INScrapMGrid.editIndex);
				
			},
			onShowPanel:function(){
				$(this).combobox('reload');
			}
		}
	};	
	var SupLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var INScrapReasonParams=JSON.stringify(addSessionParams({Type:"M"}));
	var INScrapReasonBox = $HUI.combobox('#INScrapReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetReasonForScrap&ResultSetType=array&Params='+INScrapReasonParams,
		valueField: 'RowId',
		textField: 'Description'
	});
//按钮相关操作
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var HvFlag='Y';
			FindWin(Select,HvFlag);
		}
	});


	var Save=function(){
		var MainObj=$UI.loopBlock('#MainConditions')
		var IsChange=$UI.isChangeBlock('#MainConditions')
		var MainInfo=JSON.stringify(MainObj)
		var SelectedRow = INScrapMGrid.getSelected();
		if(isEmpty(SelectedRow)&&IsChange==false){
			$UI.msg("alert","没有需要保存的明细!");
			return false;
		}
		var Detail=INScrapMGrid.getChangesData('Inclb')
		var ListData=JSON.stringify(Detail)
		if(ListData===false){return}; //验证未通过  不能保存
		if (isEmpty(ListData)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'Save',
				MainInfo: MainInfo,
				ListData: ListData
			},function(jsonData){
				if(jsonData.success===0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else {
					$UI.msg('error',jsonData.msg);
				}
			});	
	}
	$UI.linkbutton('#DelBT',{
		onClick:function(){
			var Inscrap=$('#RowId' ).val()
			if(isEmpty(Inscrap)){return;}
			function del(){
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINScrap',
					MethodName: 'Delete',
					Inscrap: Inscrap
				},function(jsonData){
					if(jsonData.success===0){
						$UI.msg('success',jsonData.msg);
						ClearMain();
					}else{
						$UI.msg('error',jsonData.msg);
					
					}
				});					
			}
			$UI.confirm('确定要删除吗?','','', del)
		}
	});

	$UI.linkbutton('#ComBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions')
			var Inscrap=MainObj.RowId;
			if(isEmpty(Inscrap)){return;}
			var Main=JSON.stringify(MainObj)		
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'SetComplete',
				Params:Main
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});				
		}
	});
	$UI.linkbutton('#CanComBT',{
		onClick:function(){
			var Inscrap=$('#RowId' ).val()
			if(isEmpty(Inscrap)){return;}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'CancelComplete',
				Inscrap: Inscrap
			},function(jsonData){
				if(jsonData.success===0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});			
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
		}
	});	
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var Inspi = ParamsObj['RowId'];
			if(isEmpty(Inspi)){
				$UI.msg("alert","没有需要打印的单据!");
				return;
			}
			if(InScrapParamObj.PrintNoComplete!='Y'&&ParamsObj['InsComp'] != 'Y'){
				$UI.msg("alert","未完成不能打印!");
				return false;
			}
			PrintINScrap(Inspi);
		}
	});
	var Select=function(Inscrap){
		$UI.clearBlock('#MainConditions');
		$UI.clear(INScrapMGrid);
		setEditDisable()
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			MethodName: 'Select',
			Inscrap:Inscrap
		},function(jsonData){
			$UI.fillBlock('#MainConditions',jsonData);
			var InsComp = jsonData['InsComp'];
			if(InsComp=='Y'){
				var BtnEnaleObj = {'#ComBT':false, '#CanComBT':true,
				'#DelBT':false,'#PrintBT':true};
//				ChangeButtonEnable(BtnEnaleObj);
			}else{
				var BtnEnaleObj = {'#ComBT':true, '#CanComBT':false,
				'#DelBT':true,'#PrintBT':true};
				
			}
			ChangeButtonEnable(BtnEnaleObj);
		});
		$UI.setUrl(INScrapMGrid);
		INScrapMGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			Inscrap:Inscrap,
			rows:99999
		});

	}
	var INScrapMGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		},{
			title:"Inclb",
			field:'Inclb',
			width:150,
			saveCol: true,
			hidden: true
		},{
			title:"Incil",
			field:'Incil',
			width:150,
			hidden: true
		},{
			title: 'DhcitRowId',
			field: 'DhcitRowId',
			width: 80,
			hidden: true
		},{
			title:"物资代码",
			field:'InciCode',
			width:100
		},{
			title:"物资名称",
			field:'InciDesc',
			width:200
		},{
			title:"高值条码",
			field:'HVBarCode',
			width:150,
			saveCol: true,
			jump:false,
			editor: {
				type: 'validatebox',
				options: {
				required: true
				}
			}
		
		},{	
			title:"批号~效期",
			field:'BatExp',
			width:150
		},{
			title:"厂商",
			field:'Manf',
			width:200
		},{
			title:"批次库存",
			field:'InclbQty',
			width:100
		},{
			title:"批次可用库存",
			field:'AvaQty',
			saveCol: true,
			width:100
		},{
			title:"报损数量",
			field:'Qty',
			saveCol: true,
			width:100
		},{
			title:"单位RowId",
			field:'UomId',
			width:100,
			saveCol: true,
			hidden:true
		},{
			title:"单位",
			field:'UomDesc',
			width:100
		},{
			title:"售价",
			field:'Sp',
			saveCol: true,
			width:100
		},{
			title:"售价金额",
			field:'SpAmt',
			width:100
		},{
			title:"进价",
			field:'Rp',
			saveCol: true,
			width:100
		},{
			title:"进价金额",
			field:'RpAmt',
			width:100
		}
	]];
	var INScrapMGrid = $UI.datagrid('#INScrapMGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			rows:99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			MethodName: 'jsDelete'
		},
		columns: INScrapMGridCm,
		showBar:true,
		remoteSort: false,
		showAddDelItems:true,
		pagination: false,
		toolbar:[{
				text: '保存',
				iconCls: 'icon-save',
				handler: function () {
					Save();
				}}],
		beforeAddFn:function(){
			if($("#InsComp").val()=="Y"){
				$UI.msg("alert","已经完成，不能增加一行!");	
				return false;
			}			
			if(isEmpty($HUI.combobox("#SupLoc").getValue())){
				$UI.msg("alert","制单科室不能为空!");
				return false;
			};
			if(isEmpty($HUI.combobox("#ScgStk").getValue())){
				$UI.msg("alert","类组不能为空!");
				return false;
			};
			return true;
		},
		afterAddFn: function(){
			var BtnEnaleObj = {'#ComBT':true, '#CanComBT':false,
			'#DelBT':false,'#PrintBT':true};
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field, value){
			INScrapMGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var InsComp = $('#InsComp').val();
			if(InsComp=="Y"){
				return false;
			}
			var RowData = $(this).datagrid('getRows')[index];
			if(field == 'HVBarCode' && !isEmpty(RowData['RowId'])){
				return false;
			}
			return true;
		},
		onBeginEdit:function(index,row){
			$('#INScrapMGrid').datagrid('beginEdit', index);
			var ed = $('#INScrapMGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'HVBarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							if(isEmpty(BarCode)){
								INScrapMGrid.stopJump();
								return false;
							}
							var FindIndex = INScrapMGrid.find('HVBarCode',BarCode);
							if(FindIndex >= 0 && FindIndex != index){
								$UI.msg('alert','条码不可重复录入!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							},false);
							
							if(!isEmpty(BarCodeData.success) && BarCodeData.success != 0){
								$UI.msg('alert', BarCodeData.msg)
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var InsScgStk = $('#ScgStk').combobox('getValue');
							if(!CheckScgRelation(InsScgStk, ScgStk)){
								$UI.msg('alert', '条码'+BarCode+'属于'+ScgStkDesc+'类组,与当前不符!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(Inclb == ''){
								$UI.msg('alert','该高值材料没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(IsAudit != 'Y'){
								$UI.msg('alert','该高值材料有未审核的'+lastDetailOperNo+',请核实!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(Type=='T'){
								$UI.msg('alert','该高值材料已经出库,不可制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(Status!='Enable'){
								$UI.msg('alert','该高值条码处于不可用状态,不可制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(RecallFlag=='Y'){
								$UI.msg('alert','该高值条码处于锁定状态,不可制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}
							var SupLocId = $('#SupLoc').combobox('getValue');
							var ParamsObj = {InciDr: Inci, ProLocId: SupLocId, QtyFlag: 1, Inclb: Inclb};
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							},false);
							if(!InclbData || InclbData.rows.length < 1){
								$UI.msg('alert', BarCode + '没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}
							var InclbInfo = $.extend(InclbData.rows[0], {InciDr:Inci, DhcitRowId:dhcit,HVBarCode:BarCode });
							ReturnInfoFn(index, InclbInfo);
						}
					});
				}
			
			}
		}
	});
	function ReturnInfoFn(RowIndex,row){
		if(row.AvaQty < 1){
			$UI.msg('alert','可用库存不足');
			return;
			}
		INScrapMGrid.updateRow({
			index: RowIndex,
			row:{
				Incil :row.InciDr,
				InciCode:row.InciCode,
				InciDesc:row.InciDesc,
				HVBarCode: row.HVBarCode,
				Spec : row.Spec,
				Inclb :row.Inclb,
				BatExp :row.BatExp,
				Qty:row.OperQty,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp : row.Rp,
				Sp : row.Sp,
				RpAmt : row.Rp,
				SpAmt : row.Sp,
				InclbDirtyQty : row.DirtyQty,
				InclbQty:row.InclbQty,
				AvaQty:row.AvaQty,
				Qty:1
				}
		});
		$('#INScrapMGrid').datagrid('refreshRow', RowIndex);
		INScrapMGrid.commonAddRow();
	}
	/*--设置初始值--*/
	var BtnEnaleObj = {'#ComBT':false, '#CanComBT':false,'#DelBT':false,'#PrintBT':false};
	ChangeButtonEnable(BtnEnaleObj);
	var Dafult=function(){
		var DafultValue={
			RowId:"",
			SupLoc:gLocObj,
			Audit:'N',
			Date:DateFormatter(new Date())
		}
		$UI.fillBlock('#MainConditions',DafultValue)
	}
	Dafult()
}
$(init);