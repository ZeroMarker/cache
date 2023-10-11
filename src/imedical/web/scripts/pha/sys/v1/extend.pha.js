/**
 * ����:   		�Թ���PHA������չһЩ�·��� (����ҩѧ��ҳ����չ)
 * ��д��:  	Huxiaotian
 * ��д����: 	2020-04-20
 * js:			pha/sys/v1/extend.pha.js
 */

if("undefined" == typeof PHA) {
	PHA = {};
}
(function(PHA){
	/**
	 * @description ��д��������ֵ�ļ�������,��ԭ���Ļ��������븸Ԫ��ID
	 */
	PHA.GetVals = function (gArr, retType, parDomId) {
		retType = retType || "";
		var valueArr = [];
		var valueObj = {};
		var gArrLen = gArr.length;
		if (gArrLen == 0) {
			return [];
		}
		for (var i = 0; i < gArrLen; i++) {
			var gId = gArr[i];
			var inputSelector = parDomId ? parDomId + " #" + gId : gId;
			var lalbelSelector = parDomId ? "#" + parDomId + " label[for='" + gId + "']" : gId;
			var lblText = $(lalbelSelector).text() || "";
			if (lblText != "") {
				lblText = lblText + ",";
			}
			var phaOpts = PHA.ChkPhaOpts(inputSelector);
			if (typeof phaOpts == "string") {
				PHA.Popover({
					msg: lblText + phaOpts,
					type: "error",
					style: {
						top: 20,
						left: ""
					}
				});
				return [];
			}
			var requied = phaOpts.requied;
			var gVal = PHA.DoVal("get", phaOpts.class, inputSelector);
			if (requied == true) {
				if (gVal == "") {
					PHA.Popover({
						msg: lblText + "����Ϊ��",
						type: "alert",
						style: {
							top: 20,
							left: ""
						}
					});
					return [];
				}
			}
			if (retType == "Json") {
				valueObj[gId] = gVal;
			} else {
				valueArr.push(gVal);
			}

		}
		if (retType == "Json") {
			valueArr.push(valueObj);
		}
		return valueArr;
	};
	PHA.SetVals = function (gArr, parDomId) {
		var gArrLen = gArr.length;
		for (var i = 0; i < gArrLen; i++) {
			var gObj = gArr[i];
			for (var gId in gObj) {
				var inputSelector = parDomId ? parDomId + " #" + gId : gId;
				var lalbelSelector = parDomId ? "#" + parDomId + " label[for='" + gId + "']" : gId;
				var phaOpts = PHA.ChkPhaOpts(inputSelector);
				if (typeof phaOpts == "string") {
					var lblText = $(lalbelSelector).text() || "";
					if (lblText != "") {
						lblText = lblText + ",";
					} else {
						lblText = inputSelector + ",";
					}
					PHA.Popover({
						msg: lblText + phaOpts,
						type: "error",
						style: {
							top: 20,
							left: ""
						}
					});
				}
				var gVal = gObj[gId];
				PHA.DoVal("set", phaOpts.class, inputSelector, gVal);
			}
		}
	};
	PHA.ClearVals = function (gArr, parDomId) {
		var gArrLen = gArr.length;
		for (var i = 0; i < gArrLen; i++) {
			var gId = gArr[i];
			var inputSelector = parDomId ? parDomId + " #" + gId : gId;
			var lalbelSelector = parDomId ? "#" + parDomId + " label[for='" + gId + "']" : gId;
			var phaOpts = PHA.ChkPhaOpts(inputSelector);
			if (typeof phaOpts == "string") {
				var lblText = $(lalbelSelector).text() || "";
				if (lblText != "") {
					lblText = lblText + ",";
				}
				PHA.Popover({
					msg: lblText + phaOpts,
					type: "error",
					style: {
						top: 20,
						left: ""
					}
				});
			}
			PHA.DoVal("clear", phaOpts.class, inputSelector);
		}
	};
	PHA.DomData = function (_domId, _opts) {
		var domArr = [];
		var doType = _opts.doType;
		$(_domId + " [data-pha]").each(function () {
			var _id = this.id;
			var phaOpts = PHA.ChkPhaOpts(_id);
			var doTypeVal = phaOpts[doType];
			if (doTypeVal === undefined) {
				return true;
			}
			if (doTypeVal === true) {
				domArr.push(_id);
			} else if (isNaN(doTypeVal) == false) {
				domArr[doTypeVal] = _id;
			}
		});
		var parId = _domId.indexOf("#") == 0 ? _domId.substring(1) : _domId;
		if (doType == "clear") {
			PHA.ClearVals(domArr, parId);
		} else {
			return PHA.GetVals(domArr, _opts.retType || "", parId);
		}
		return [];
	};
	
	/*
	* ��ȡurl
	*/
	PHA.GetUrl = function(_options) {
		var retUrl = $URL;
		var n = 0;
		for (var k in _options) {
			if (n == 0) {
				retUrl += "?" + k + "=" + encodeURIComponent(_options[k]);
			} else {
				retUrl += "&" + k + "=" + encodeURIComponent(_options[k]);
			}
			n = n + 1;
		}
		return retUrl;
	};
	/*
	* @description: ���༭���
	*/
	// �����ƶ���
	PHA.UpDownCol = function(_opt){
		var _gridID = _opt.gridID;
		var _ifUp = _opt.ifUp;
		// ȡֵ
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "�б�����û������,�޷���ɱ��༭!",
				type: "alert"
			});
			return;
		}
		var selectedData = $("#" + _gridID).datagrid("getSelected") || "";
		if (selectedData == "") {
			PHA.Popover({
				msg: "��ѡ����Ҫ�����ƶ�����!",
				type: "alert"
			});
			return;
		}
		var rowsData = $("#" + _gridID).datagrid("getRows");
		var rowIndex = $("#" + _gridID).datagrid('getRowIndex', selectedData);
		if (_ifUp == true) {
			if (rowIndex == 0) {
				PHA.Popover({
					msg: "�ѵ����һ��!",
					type: "alert"
				});
				return;
			}
		} else {
			if (rowIndex == rowsData.length - 1) {
				PHA.Popover({
					msg: "�ѵ������һ��!",
					type: "alert"
				});
				return;
			}
		}
		var newSelectedData = PHA.deepCopy(selectedData);
		// ������
		if (_ifUp == true) {
			$("#" + _gridID).datagrid('updateRow',{
				index: rowIndex,
				row: rowsData[rowIndex - 1]
			});
			$("#" + _gridID).datagrid('updateRow',{
				index: rowIndex - 1,
				row: newSelectedData
			});
			$("#" + _gridID).datagrid('selectRow', rowIndex - 1);
			_opt.onEnd && _opt.onEnd(rowIndex, rowIndex - 1);
		} else {
			$("#" + _gridID).datagrid('updateRow',{
				index: rowIndex,
				row: rowsData[rowIndex + 1]
			});
			$("#" + _gridID).datagrid('updateRow',{
				index: rowIndex + 1,
				row: newSelectedData
			});
			$("#" + _gridID).datagrid('selectRow', rowIndex + 1);
			_opt.onEnd && _opt.onEnd(rowIndex, rowIndex + 1);
		}
	};
	// �ı��༭��
	PHA.TextBoxEditor = function(){
		return {
			type: 'validatebox'
		}
	};
	// ���ֱ༭��
	PHA.NmberBoxEditor = function(){
		return {
			type: 'validatebox'
		}
	}
	// ��ѡ�༭��
	PHA.CheckBoxEditor = function(){
		return {
			type: 'icheckbox',
		    options: { on: 'Y', off: 'N' }
		}
	}
	PHA.CheckBoxFormatter = function(val, rowData, rowIndex){
		if (val == "Y"){
			return PHA_COM.Fmt.Grid.Yes.Chinese;
		} else {
			return PHA_COM.Fmt.Grid.No.Chinese;
		}
	}
	// �����
	PHA.GridAppendRow = function(_options){
		var _gridID = _options.gridID;
		var _defaultData = _options.defaultData;
		var _editField = _options.editField;
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "������ɱ����һ�б༭!",
				type: "alert",
				timeout: 1000
			});
			return;
		}
		$("#" + _gridID).datagrid("appendRow", _defaultData);
		var rowsData = $("#" + _gridID).datagrid('getRows');
		PHA.GridStartEdit({
			gridID: _gridID,
			index: rowsData.length - 1,
			field: _editField
		});
	}
	// ��ʼ�༭
	PHA.GridStartEdit = function(_options) {
		var _gridID = _options.gridID;
		var _index = _options.index;
		var _field = _options.field;
		$("#" + _gridID).datagrid('beginEditCell', {
	        index: _index,
	        field: _field
	    });
	    
	    var _thisEditor = $("#" + _gridID).datagrid('getEditor', {
			index: _index,
			field: _field
		});
		if (_thisEditor == null) {
			return;
		}
		if (_thisEditor.type == "combobox") {
			$(_thisEditor.target).combobox('showPanel');
			return;
		}
		if (_thisEditor.type == "combogrid") {
			$(_thisEditor.target).combogrid('showPanel');
			return;
		}
		if (_thisEditor.type == "combotree") {
			$(_thisEditor.target).combotree('showPanel');
			return;
		}
		if (_thisEditor.type == "datebox") {
			$(_thisEditor.target).datebox('showPanel');
			return;
		}
	}
	// �����༭
	PHA.GridEndEidting = function(_gridID){
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "δ���������,�޷���ɱ༭!",
				type: "alert",
				timeout: 1000
			});
			return false;
		}
		return true;
	}
	// ��ȡ�иı���е�����
	PHA.GridChangedRows = function(_gridID) {
		var changedRows = $("#" + _gridID).datagrid("getChanges") || [];
		if (changedRows.length == 0) {
			PHA.Popover({
				msg: "û����Ҫ���������!",
				type: "error",
				timeout: 1000
			});
			return [];
		}
		return changedRows;
	}
	/*
	* @description: �������̨֮��ͳһ������
	*/
	PHA.AfterRunServer = function (retStr, succCallFn, errCallFn) {
		var retArr = retStr.split("^");
		var retVal = retArr[0];
		var retInfo = retArr[1];
		if (retVal < 0) {
			PHA.Alert("��ʾ", retInfo, retVal);
			if (errCallFn) {
				errCallFn();
			}
		} else {
			PHA.Popover({
				msg: retInfo || "�ɹ�!",
				type: "success",
				timeout: 500
			});
			if (succCallFn) {
				succCallFn();
			}
		}
	}
	// ��������
	PHA.deepCopy = function (source) {
		var result = {};
		for (var key in source) {
			result[key] = typeof source[key]==='object'? PHA.deepCopy(source[key]): source[key];
		}
		return result;
	}
})(PHA)