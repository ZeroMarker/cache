// ����:��汨���Ƶ�(��ֵ)
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
	///�ſ��ɱ༭�����disabled����
	function setEditEnable(){
		$HUI.combobox("#ScgStk").enable();
		$HUI.combobox("#SupLoc").enable();
		$HUI.combobox("#INScrapReason").enable();
	}
//Grid �� comboxData
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
//��ť��ز���
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
			$UI.msg("alert","û����Ҫ�������ϸ!");
			return false;
		}
		var Detail=INScrapMGrid.getChangesData('Inclb')
		var ListData=JSON.stringify(Detail)
		if(ListData===false){return}; //��֤δͨ��  ���ܱ���
		if (isEmpty(ListData)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
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
			$UI.confirm('ȷ��Ҫɾ����?','','', del)
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
				$UI.msg("alert","û����Ҫ��ӡ�ĵ���!");
				return;
			}
			if(InScrapParamObj.PrintNoComplete!='Y'&&ParamsObj['InsComp'] != 'Y'){
				$UI.msg("alert","δ��ɲ��ܴ�ӡ!");
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
			title:"���ʴ���",
			field:'InciCode',
			width:100
		},{
			title:"��������",
			field:'InciDesc',
			width:200
		},{
			title:"��ֵ����",
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
			title:"����~Ч��",
			field:'BatExp',
			width:150
		},{
			title:"����",
			field:'Manf',
			width:200
		},{
			title:"���ο��",
			field:'InclbQty',
			width:100
		},{
			title:"���ο��ÿ��",
			field:'AvaQty',
			saveCol: true,
			width:100
		},{
			title:"��������",
			field:'Qty',
			saveCol: true,
			width:100
		},{
			title:"��λRowId",
			field:'UomId',
			width:100,
			saveCol: true,
			hidden:true
		},{
			title:"��λ",
			field:'UomDesc',
			width:100
		},{
			title:"�ۼ�",
			field:'Sp',
			saveCol: true,
			width:100
		},{
			title:"�ۼ۽��",
			field:'SpAmt',
			width:100
		},{
			title:"����",
			field:'Rp',
			saveCol: true,
			width:100
		},{
			title:"���۽��",
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
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					Save();
				}}],
		beforeAddFn:function(){
			if($("#InsComp").val()=="Y"){
				$UI.msg("alert","�Ѿ���ɣ���������һ��!");	
				return false;
			}			
			if(isEmpty($HUI.combobox("#SupLoc").getValue())){
				$UI.msg("alert","�Ƶ����Ҳ���Ϊ��!");
				return false;
			};
			if(isEmpty($HUI.combobox("#ScgStk").getValue())){
				$UI.msg("alert","���鲻��Ϊ��!");
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
								$UI.msg('alert','���벻���ظ�¼��!');
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
								$UI.msg('alert', '����'+BarCode+'����'+ScgStkDesc+'����,�뵱ǰ����!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(Inclb == ''){
								$UI.msg('alert','�ø�ֵ����û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(IsAudit != 'Y'){
								$UI.msg('alert','�ø�ֵ������δ��˵�'+lastDetailOperNo+',���ʵ!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(Type=='T'){
								$UI.msg('alert','�ø�ֵ�����Ѿ�����,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(Status!='Enable'){
								$UI.msg('alert','�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}else if(RecallFlag=='Y'){
								$UI.msg('alert','�ø�ֵ���봦������״̬,�����Ƶ�!');
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
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
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
			$UI.msg('alert','���ÿ�治��');
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
	/*--���ó�ʼֵ--*/
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