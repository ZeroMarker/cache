
/*
 * 新品立项,根据立项数据生成库存项目
 */
function NewItmInfo(){
	
	$HUI.dialog('#NewItmWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	function NewItmClear(){
		$UI.clearBlock('#NewItmWin');
		$UI.clear(NewItmMasterGrid);
		$UI.clear(NewItmDetailGrid);
		var NetItmDafultData = {
			StartDate: DateFormatter(DateAdd(new Date(), 'm', -1)),
			EndDate: new Date()
		};
		$UI.fillBlock('#NewItmWin', NetItmDafultData);
	}
	
	$UI.linkbutton('#NewItmSearchBT', {
		onClick: function(){
			NewItmSearch();
		}
	});
	function NewItmSearch(){
		var ParamsObj = $UI.loopBlock('#NewItmConditions');
		ParamsObj['CreatedFlag'] = 'N';
		ParamsObj['AckFlag'] = 'Y';
		var Params = JSON.stringify(ParamsObj);
		NewItmMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm',
			Params: Params
		});
	}
	
	$UI.linkbutton('#NewItmCleanBT', {
		onClick: function(){
			NewItmClear();
		}
	});
	
	$UI.linkbutton('#NewItmSynSCIBT', {
		onClick: function(){
			var Param = gLocId + '^' + gUserId;
			var Result = $.m({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'getSciHopInc',
				Param: Param
			}, false);
			if(Result == 0){
				$UI.msg('success', '同步成功!');
				NewItmSearch();
			}else{
				$UI.msg('error', '处理失败:' + Result);
			}
		}
	});
		
	var NewItmMasterGrid = $UI.datagrid('#NewItmMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm'
		},
		columns: [[
			{
				title : '审批单编号',
				field : 'NIRowId',
				width : 50
			},{
				title : '审批单名称',
				field : 'NINo',
				width : 120
			},{
				title : '物资名称',
				field : 'NIDesc',
				width : 120
			},{
				title : '规格',
				field : 'NISpec',
				width : 80
			},{
				title : '审批日期',
				field : 'NIDateTime',
				width : 150
			}
		]],
		fitColumns: true,
		onSelect: function(index, row){
			var NIRowId = row['NIRowId'];
			$UI.clear(NewItmDetailGrid);
			NewItmDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCNewItm',
				MethodName: 'GetNewItmInfo',
				Parref: NIRowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				NewItmMasterGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row){
			var NIRowId = row['NIRowId'];
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCNewItm',
				MethodName: 'GetItmDetail',
				RowId: NIRowId
			}, function(NewItmObj){
				var InciDatas = {};
				InciData['NewItmRowId'] = NewItmObj['NIRowId'];
				InciData['InciDesc'] = NewItmObj['NIDesc'];
				InciData['Spec'] = NewItmObj['NISpec'];
				InciData['BUom'] = NewItmObj['NIPUom'], InciData['PUom'] = NewItmObj['NIPUom'];
				InciData['Brand'] = NewItmObj['NIBrand'];
				InciData['Model'] = NewItmObj['NIModel'];
				InciData['Abbrev'] = NewItmObj['NIAbbrev'];
				InciData['HighPrice'] = NewItmObj['NIHighRiskFlag'];
//				Ext.getCmp('INFOChargeFlag').setValue(ChargeFlag=='Y');
				InciData['ImplantationMat'] = NewItmObj['NIImplantationMat'];
				InciData['ImpFlag'] = NewItmObj['NIImportFlag'];
//				Ext.getCmp('INFOBAflag').setValue(INFOBAflag=='Y');
				
				$UI.clearBlock('#InciData');
				$UI.fillBlock('#InciData', InciData);
				$HUI.dialog('#NewItmWin').close();
			});
		}
	});
	
	var NewItmDetailGrid = $UI.datagrid('#NewItmDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			MethodName: 'GetNewItmInfo'
		},
		columns : [[
			{
				title : '字段',
				field : 'Desc',
				width : 100
			},{
				title : '字段值',
				field : 'Value',
				width : 120
			}
		]],
		fitColumns: true
	});
	
	NewItmClear();
	NewItmSearch();
}
