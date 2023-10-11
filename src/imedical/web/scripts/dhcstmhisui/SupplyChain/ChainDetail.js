
function ChainDetailWin(RowId, Fn, InciShowFlag) {
	$HUI.dialog('#ChainDetailWin', {
		width: gWinWidth,
		height: gWinHeight,
		onClose: function() {
			if (!isEmpty(Fn)) {
				Fn();
			}
		}
	}).open();
	if (!isEmpty(RowId)) {
		GetChainDetail(RowId, InciShowFlag);
	} else {
		CreateDetailPanel(1);
		MonitorDetailPanel(1);
		$('#ChainMain [name="ChainCode"]').focus();
	}
}

function GetChainDetail(RowId, InciShowFlag) {
	$('#ChainDetail').empty();
	var ChainDetail = $.cm({
		ClassName: 'web.DHCSTMHUI.SupplyChain',
		MethodName: 'GetChainDetail',
		RowId: RowId
	}, false);
	var MainObj = ChainDetail['Main'], DetailArray = ChainDetail['Detail'];
	$UI.fillBlock('#ChainMain', MainObj);
	var LastFlag = false;
	for (var i = 0, Len = DetailArray.length; i < Len; i++) {
		var DetailObj = DetailArray[i];
		var Level = DetailObj['Level'], Flag = DetailObj['Flag'];
		if (isEmpty(Level)) {
			return;
		}
		if (i == (Len - 1)) {
			LastFlag = true;
		}
		CreateDetailPanel(Level, LastFlag);
		$UI.fillBlock('#DetailPanel' + Level, DetailObj);
		if (!LastFlag) {
			$HUI.checkbox('#DetailPanel' + Level + ' [name="Flag"]').disable();
			$('#DetailPanel' + Level + ' [name="AddDetailBT"]').hide();
			$('#DetailPanel' + Level + ' [name="DelDetailBT"]').hide();
		} else if (Flag == 'Y') {
			$('#DetailPanel' + Level + ' [name="AddDetailBT"]').hide();
			$('#ToCompany' + Level).parent().prev()[0].bgColor = '#98f198';
			$('#ToCompany' + Level).parent().prev()[0].innerText = '被授权供应商';
		}
		// /物资信息维护界面显示，所有元素只读
		if (InciShowFlag == 'Y') {
			$('#ChainMain' + ' [name="ChainCode"]').attr('readonly', true);
			$('#ChainMain' + ' [name="Remarks"]').attr('readonly', true);
			$('#DetailManf').combobox('readonly', true);
			$('#DetailSaveBT').hide();
			$HUI.checkbox('#DetailPanel' + Level + ' [name="Flag"]').disable();
			$('#DetailPanel' + Level + ' [comboname="ToCompany"]').combobox('readonly', true);
			$('#DetailPanel' + Level + ' [comboname="StartDate"]').combobox('readonly', true);
			$('#DetailPanel' + Level + ' [comboname="EndDate"]').combobox('readonly', true);
			$('#DetailPanel' + Level + ' [name="AddDetailBT"]').hide();
			$('#DetailPanel' + Level + ' [name="UpLoadDetailBT"]').hide();
			$('#DetailPanel' + Level + ' [name="DelDetailBT"]').hide();
		}
		MonitorDetailPanel(Level);
	}
}

function CreateDetailPanel(Level, LastFlag) {
	var PanelId = 'DetailPanel' + Level;
	var FromCompanyId = 'FromCompany' + Level, ToCompanyId = 'ToCompany' + Level;
	var FromCompanyLabel = '经销商', ToOrgLabel = '经销商';
	if (Level == 1) {
		FromCompanyLabel = '生产厂家';
	}
	$('#ChainDetail').append(
		`<div id=${PanelId} style="margin:0 0 0 10px;float:left;">
		<div class="hisui-panel" data-options="headerCls:'panel-header-gray'" title=${Level}级授权书 style="width:375px;">
			<table class="Condition">
				<tr>
					<td>授权${FromCompanyLabel}</td>
					<td style="text-align:left;"><input id=${FromCompanyId} name="FromCompany" class="hisui-combobox text" disabled style="width:190px;"></td>
				</tr>
				<tr>
					<td>被授权经销商</td>
					<td style="text-align:left;">
						<input id=${ToCompanyId} name="ToCompany" class="hisui-combobox text" style="width:190px;">
						<input name="Flag" class='hisui-checkbox' type="checkbox" value="Y" label="供应商" style="margin:0;">
					</td>
				</tr>
				<tr>
					<td>授权效期</td>
					<td style="text-align:left;">
						<input name="StartDate" class="hisui-datebox text" style="width:115px">
						&nbsp至&nbsp
						<input name="EndDate" class="hisui-datebox text" style="width:115px;">
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="text-align:right;">
						<input name="RowId" type="hidden">
						<input name="Level" type="hidden">
						<a href="#" name="AddDetailBT" class="hisui-linkbutton" style="margin-left:6px;">新增</a>
						<a href="#" name="UpLoadDetailBT" class="hisui-linkbutton" style="margin-left:6px;">上传</a>
						<a href="#" name="ViewFileDetailBT" class="hisui-linkbutton" style="margin-left:6px;">查看</a>
						<a href="#" name="DelDetailBT" class="hisui-linkbutton" style="margin-left:6px;">删除</a>
					</td>
				</tr>
			</table>
		</div>
	</div>`
	);
	if (Level == 1) {
		$('#' + PanelId + ' [name="DelDetailBT"]').hide();
	}
	$('#' + PanelId + ' [name="Level"]').val(Level);
	$.parser.parse($('#' + PanelId));
	
	var ManfUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=Array';
	var VendorUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array';
	var DealerUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDealer&ResultSetType=array';
	var FromCompanyUrl = DealerUrl, ToCompanyUrl = DealerUrl;
	if (Level == 1) {
		FromCompanyUrl = ManfUrl;
	}
	if (LastFlag) {
		ToCompanyUrl = VendorUrl;
	}
	$HUI.combobox('#' + FromCompanyId, {
		url: FromCompanyUrl
	});
	$HUI.combobox('#' + ToCompanyId, {
		url: ToCompanyUrl,
		onSelect: function(record) {
			var CompanyId = record['RowId'];
			for (var i = 1; i < Level; i++) {
				var ToCompanyId = $('#ToCompany' + i).combobox('getValue');
				if (ToCompanyId == CompanyId) {
					$UI.msg('alert', '与' + i + '级授权经销商重复!');
					$(this).combobox('clear');
					return;
				}
			}
		}
	});
}

function MonitorDetailPanel(Level) {
	var PanelId = 'DetailPanel' + Level;
	var FromCompanyId = 'FromCompany' + Level, ToCompanyId = 'ToCompany' + Level;
	var ManfUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=Array';
	var VendorUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array';
	var DealerUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDealer&ResultSetType=array';

	$HUI.checkbox('#' + PanelId + ' [name="Flag"]', {
		onCheckChange: function(e, value) {
			var ToCompanyUrl = '';
			if (value) {
				ToCompanyUrl = VendorUrl;
				ToCompanyLabel = '被授权供应商';
				$(this).parent().prev()[0].bgColor = '#98f198';
				$(this).parentsUntil('table').find('[name="AddDetailBT"]').hide();
			} else {
				ToCompanyUrl = DealerUrl;
				ToCompanyLabel = '被授权经销商';
				$(this).parent().prev()[0].bgColor = '';
				$(this).parentsUntil('table').find('[name="AddDetailBT"]').show();
			}
			$(this).parent().prev()[0].innerText = ToCompanyLabel;
			$HUI.combobox('#' + ToCompanyId, {
				url: ToCompanyUrl
			});
		}
	});
	
	$('#' + PanelId + ' [name="AddDetailBT"]').on('click', function() {
		var Condition = $(this).parentsUntil('.Condition');
		var ParamsObj = $UI.loopBlock(Condition);
		if (isEmpty(ParamsObj['FromCompany']) || isEmpty(ParamsObj['ToCompany']) || isEmpty(ParamsObj['StartDate']) || isEmpty(ParamsObj['EndDate'])) {
			$UI.msg('alert', '请填写完整!');
			return;
		}
		
		var CurrentLevel = Number(ParamsObj['Level']);
		var NextLevel = CurrentLevel + 1;
		// 创建下一级别panel
		CreateDetailPanel(NextLevel);
		// 下一级别,添加监听
		MonitorDetailPanel(NextLevel);
		var CurrentToCompanyId = $('#ToCompany' + CurrentLevel).combobox('getValue');
		$('#FromCompany' + NextLevel).combobox('setValue', CurrentToCompanyId);
		
		// 隐藏上一级别的按钮
		$(this).hide();
		$(this).siblings('[name="DelDetailBT"]').hide();
		$HUI.checkbox('#DetailPanel' + CurrentLevel + ' [name="Flag"]').disable();
	});
	
	$('#' + PanelId + ' [name="DelDetailBT"]').on('click', function() {
		var Condition = $(this).parentsUntil('.Condition');
		var ParamsObj = $UI.loopBlock(Condition);
		var CurrentLevel = Number(ParamsObj['Level']);
		if (CurrentLevel <= 1) {
			return;
		}
		var PrevLevel = CurrentLevel - 1;
		$('#DetailPanel' + PrevLevel + ' [name="AddDetailBT"]').show();
		if (PrevLevel != 1) {
			$('#DetailPanel' + PrevLevel + ' [name="DelDetailBT"]').show();
		}
		$HUI.checkbox('#DetailPanel' + PrevLevel + ' [name="Flag"]').enable();
		$('#DetailPanel' + CurrentLevel).remove();
	});
	
	$('#' + PanelId + ' [name="UpLoadDetailBT"]').on('click', function() {
		var Condition = $(this).parentsUntil('.Condition');
		var ParamsObj = $UI.loopBlock(Condition);
		var CurrentLevel = Number(ParamsObj['Level']);
		var RowId = ParamsObj['RowId'];
		if (isEmpty(RowId)) {
			$UI.msg('alert', '请先保存授权书再上传!');
			return;
		}
		var ParrefId = RowId.split('||')[0];
		UpLoadFileWin('SupplyChain', ParrefId, 'ChainLevel', CurrentLevel, RowId, '');
	});
	$('#' + PanelId + ' [name="ViewFileDetailBT"]').on('click', function() {
		var Condition = $(this).parentsUntil('.Condition');
		var ParamsObj = $UI.loopBlock(Condition);
		var CurrentLevel = Number(ParamsObj['Level']);
		var RowId = ParamsObj['RowId'];
		if (isEmpty(RowId)) {
			$UI.msg('alert', '请先保存授权书再上传!');
			return;
		}
		var ParrefId = RowId.split('||')[0];
		ViewFileWin('SupplyChain', ParrefId, 'ChainLevel', CurrentLevel, RowId, '', gHospId);
	});
}

function InitChainDetail() {
	$HUI.combobox('#DetailManf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ StkType: 'M' })),
		onSelect: function(record) {
			$('#FromCompany1').combobox('setValue', record['RowId']);
		}
	});
	$UI.linkbutton('#DetailSaveBT', {
		onClick: function() {
			SaveDetail();
		}
	});
	function SaveDetail() {
		var MainObj = $UI.loopBlock('#ChainMain');
		var DetailArray = [];
		var VendorId;
		var MaxLevel;		// 最大等级
		var Level = 1;
		while ($('#DetailPanel' + Level).length > 0) {
			var LevelObj = $UI.loopBlock($('#DetailPanel' + Level));
			if (LevelObj['Flag'] == 'Y') {
				VendorId = LevelObj['ToCompany'];
			}
			DetailArray.unshift(LevelObj);
			MaxLevel = Level;
			
			++Level;
		}
		MainObj['MaxLevel'] = MaxLevel;
		
		if (isEmpty(VendorId)) {
			$UI.msg('alert', '最后一级必须是供应商');
			return;
		}
		MainObj['Vendor'] = VendorId;
		
		$.cm({
			ClassName: 'web.DHCSTMHUI.SupplyChain',
			MethodName: 'jsSave',
			Main: JSON.stringify(MainObj),
			Detail: JSON.stringify(DetailArray)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var RowId = jsonData['rowid'];
				GetChainDetail(RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$HUI.dialog('#ChainDetailWin', {
		width: 1165,
		height: 530,
		onOpen: function() {
			$UI.clearBlock('#ChainMain');
			$('#ChainDetail').empty();
		}
	});
}
$(InitChainDetail);