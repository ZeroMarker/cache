// 消毒包维护界面
var WinRowId, WinHospId, WinFn;
var AddPkgWin = function(RowId, HospId, Fn) {
	WinRowId = RowId;
	WinHospId = HospId;
	WinFn = Fn;
	$HUI.dialog('#AddPkgWin').open();
};

var initAddPkgWin = function() {
	var PkgSpec = $HUI.combobox('#PkgSpecId', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var PkgClassCom = $HUI.combobox('#PkgClassId', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.radio("[name='PkgAttributeId']", {
		onChecked: function(e, value) {
			if ($(e.target).attr('value') === '3') {
				$('#PkgSterType').combobox('clear');
				$('#PkgSterTypeRequired').hide();
			} else {
				$('#PkgSterTypeRequired').show();
			}
		}
	});
	$HUI.combobox('#PkgAttributeId', {
		data: PackTypeDetailData,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
		}
	});
	var PkgMaterialCom = $HUI.combobox('#PkgMaterialId', {
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Length = record['Length'];
			$('#PkgLength').numberbox('setValue', Length);
		}
	});
	var PkgUom = $HUI.combobox('#PkgUom', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var PkgSterType = $HUI.combobox('#PkgSterType', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var PkgReqLoc = $HUI.combobox('#PkgReqLoc', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var Firm = $HUI.combobox('#Firm', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('AddPkgCondition');
			ParamsObj.BDPHospital = WinHospId;
			if (isEmpty(ParamsObj.PkgDesc)) {
				$UI.msg('alert', '消毒包名称不能为空！');
				return;
			}
			if (isEmpty(ParamsObj.PkgAttributeId)) {
				$UI.msg('alert', '包属性不能为空！');
				return;
			}
			if ((ParamsObj.PkgAttributeId === '6') && (isEmpty(ParamsObj.PkgSterType))) {
				$UI.msg('alert', '灭菌方式不能为空！');
			}
			if ((ParamsObj.PkgAttributeId === '1') || (ParamsObj.PkgAttributeId === '2') || (ParamsObj.PkgAttributeId === '7') || (ParamsObj.PkgAttributeId === '10')) {
				if (isEmpty(ParamsObj.PkgSterType)) {
					$UI.msg('alert', '灭菌方式不能为空！');
					return;
				}
				if (isEmpty(ParamsObj.PkgMaterialId)) {
					$UI.msg('alert', '包装材料不能为空！');
					return;
				}
				if (isEmpty(ParamsObj.PkgPrice)) {
					$UI.msg('alert', '单价不能为空！');
					return;
				}
				if (isEmpty(ParamsObj.PkgLength)) {
					$UI.msg('alert', '有效期不能为空！');
					return;
				}
				if (isEmpty(ParamsObj.PkgClassId)) {
					$UI.msg('alert', '消毒包分类不能为空！');
					return;
				}
				if (isEmpty(ParamsObj.PkgUom)) {
					$UI.msg('alert', '单位不能为空！');
					return;
				}
			}
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.Package',
				MethodName: 'jsSavePkg',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#AddPkgWin').close();
					WinFn(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function ReloadCombobox() {
		var DetailParams = JSON.stringify(addSessionParams({ BDPHospital: WinHospId }));
		
		var PkgSpecUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + DetailParams;
		PkgSpec.clear();
		PkgSpec.reload(PkgSpecUrl);
		
		var PkgClassUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array&Params=' + DetailParams;
		PkgClassCom.clear();
		PkgClassCom.reload(PkgClassUrl);
		
		var PkgMaterialUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array&Params=' + DetailParams;
		PkgMaterialCom.clear();
		PkgMaterialCom.reload(PkgMaterialUrl);
		
		var PkgSterTypeUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&Params=' + DetailParams;
		PkgSterType.clear();
		PkgSterType.reload(PkgSterTypeUrl);
		
		var PkgUomUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array&Params=' + DetailParams;
		PkgUom.clear();
		PkgUom.reload(PkgUomUrl);
		
		var PkgReqLocUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DetailParams;
		PkgReqLoc.clear();
		PkgReqLoc.reload(PkgReqLocUrl);
		
		var FirmUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFirm&ResultSetType=array&Params=' + DetailParams;
		Firm.clear();
		Firm.reload(FirmUrl);
	}
	
	$HUI.dialog('#AddPkgWin', {
		onOpen: function() {
			$UI.clearBlock('#AddPkgCondition');
			$('#WorkCost').numberbox('enable');
			ReloadCombobox();
			if (!isEmpty(WinRowId)) {
				$.cm({
					ClassName: 'web.CSSDHUI.PackageInfo.Package',
					MethodName: 'Select',
					PkgId: WinRowId
				}, function(jsonData) {
					$UI.fillBlock('#AddPkgCondition', jsonData);
					var ItmQty = tkMakeServerCall('web.CSSDHUI.Common.PackageInfoCommon', 'GetItmQtyByPkgId', WinRowId);
					if (ItmQty > 0) {
						$('#WorkCost').numberbox('disable');
					}
				});
			} else {
				var DefaultValue = {
					PkgUseFlag: 'Y'
				};
				$UI.fillBlock('#AddPkgCondition', DefaultValue);
				if ($('input[name=PkgAttributeId]:checked').val() === '3') {
					$('#PkgSterTypeRequired').hide();
				} else {
					$('#PkgSterTypeRequired').show();
				}
			}
		}
	});
};
$(initAddPkgWin);