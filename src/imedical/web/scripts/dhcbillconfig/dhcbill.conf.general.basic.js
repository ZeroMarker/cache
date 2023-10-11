$(function () {
	//载入前先判断该配置点是否未发布，如果不是则不允许再修改或导入
	if (CV.IsReleased == 2){
		disableById("btn-save");
	}else{
		enableById("btn-save");
	}
	// 只读权限
	if (CV.LimitFlag == 2){
		disableById("btn-save");
	}
	
	$HUI.linkbutton("#btn-save", {
		onClick: function() {
			_saveClick();
		}
	});
	
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryHospList&PublicFlag='+CV.PublicFlag+'&ResultSetType=array',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			if(CV.PublicFlag == 1){
				$(this).combobox("select", "COM");
			}else{
				$(this).combobox("select", PUBLIC_CONSTANT.SESSION.HOSPID);
			}
		},
		onChange: function(newValue, oldValue) {
			_setBasicOValue();
		}
	});

	var _getHospId = function() {
		return getValueById("hospital");
	};

	var _getRelaId = function() {
		var hospId = _getHospId();
		return $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetRelaDataId", relaCode: CV.RelaCode, sourceData: "", hospId: hospId}, false);
	};

	var _getTgtData = function() {
		var relaId = _getRelaId();
		return getPropValById("CF_BILL_COM.CfgRelaData", relaId, "CRDTgtData");
	};
	var _setActiveDateFrom = function() {
		var relaId = _getRelaId();
		var date = getPropValById("CF_BILL_COM.CfgRelaData", relaId, "CRDActiveDateFrom");
		date = $.m({ClassName: "websys.Conversions", MethodName: "DateLogicalToHtml", h: date}, false);
		setValueById("activeDateFrom",date);
	};
	var _setActiveDateTo = function() {
		var relaId = _getRelaId();
		var date = getPropValById("CF_BILL_COM.CfgRelaData", relaId, "CRDActiveDateTo");
		date = $.m({ClassName: "websys.Conversions", MethodName: "DateLogicalToHtml", h: date}, false);
		setValueById("activeDateTo",date);
	};

	var _setBasicOValue = function() {
		var _tgtData = _getTgtData();
		_setActiveDateFrom();
		_setActiveDateTo();

		switch($tgtObj.prop("type")) {
		case "checkbox":
			setValueById($tgtObj[0].id, (_tgtData == 1));
			break;
		case "text":						
			if ($tgtObj.hasClass("combobox-f")) {
				var url = $URL + "?ClassName=" + CV.SrcClassName + "&QueryName=" + CV.SrcQueryName
				+ "&ResultSetType=array" + "&dicType=" + CV.TgtDataSrcDicType + "&hospId=" + _getHospId();
				
				if ($tgtObj.combobox("options").multiple) {
					$tgtObj.combobox("reload", url).combobox("setValues", _tgtData.split("^"));
					break;
				}
				$tgtObj.combobox("reload", url).combobox("setValue", _tgtData);
				break;
			}
			setValueById($tgtObj[0].id, _tgtData);
			break;
		default:
			setValueById($tgtObj[0].id, _tgtData);
		}
		if(colorFlag == "color"){
			//$tgtObj.css('background-color', getValueById($tgtObj[0].id));
			$tgtObj.selectColor(); 
		}
	};

	var _getTgtValue = function() {
		var _tgtData = getValueById($tgtObj[0].id);
		switch($tgtObj.prop("type")) {
		case "checkbox":
			_tgtData = $tgtObj.checkbox("getValue") ? 1 : 0;
			break;
		case "text":
			if ($tgtObj.hasClass("combobox-f")) {
				if ($tgtObj.combobox("options").multiple) {
					_tgtData = String($tgtObj.combobox("getValues").join("^"));
				}
			}
			break;
		default:
		}
		return _tgtData;
	};
	
	//保存事件
	var _saveClick = function() {
		if (CV.UpdLevelFlag == 1){
			if (GV.PassFlag == "Y"){
				updateDate();
			}else{
				$.messager.prompt("提示", "请输入密码", function (r) {
					if (r) {
						var PassWardFlag =  $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckPassword", Password: r}, false);
						if (+PassWardFlag){
							GV.PassFlag = "Y";
							updateDate();
						}else{
							$.messager.alert('提示', '密码错误', 'error');
						}
					}
				});
			}
		}else{
			$.messager.confirm("确定", "是否确认保存？", function(r) {
				if (r) {
					updateDate();
				}
			});
		}
		// 保存数据方法剥离
		function updateDate() {
			var relaAry = [];
			var rela = {
				CRDTgtData: _getTgtValue(),
				CRDActiveDateFrom: getValueById("activeDateFrom"),
				CRDActiveDateTo: getValueById("activeDateTo")
			};
			relaAry.push(JSON.stringify(rela));
			//新的保存方法
			$.m({
				ClassName: "BILL.CFG.COM.GeneralCfg",
				MethodName: "SaveRelaDataForBasic",
				RelaCode: CV.RelaCode,
				TgtData: _getTgtData(),
				RelaList: relaAry,
				HospId: _getHospId()
			}, function(rtn) {
				var myAry = rtn.split("^");
				var iconCls = (myAry[0] == 0) ? "success" : "error";
				if (CV.EnablePMASystem != 0) {
					$.messager.popover({msg: (myAry[1] || myAry[0]), type: iconCls});
					//把权力项申请按钮显示到界面上
					BILL_INF.getStatusHtml("HIS-OPBILL-SFYXTGHF", "btn-save");
				}else {
					//未启用权力系统
					var msg = (myAry[0] == 0) ? "保存成功" : ("保存失败：" + (myAry[1] || myAry[0]));
					$.messager.popover({msg: msg, type: iconCls});
				}
			});
		}
	}
	
	if (CV.EnablePMASystem != 0) {
		//+2023-03-07 ZhYW 把权力项申请按钮显示到界面上
		BILL_INF.getStatusHtml("HIS-OPBILL-SFYXTGHF", "btn-save");
	}
});