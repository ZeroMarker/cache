/**
 * 名称:   		对公共PHA对象扩展一些新方法 (基于药学首页的扩展)
 * 编写人:  	Huxiaotian
 * 编写日期: 	2020-04-20
 * js:			pha/sys/v1/extend.pha.js
 */

if("undefined" == typeof PHA) {
	PHA = {};
}
(function(PHA){
	/**
	 * @description 重写批量操作值的几个方法,在原来的基础上引入父元素ID
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
						msg: lblText + "不能为空",
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
	* 获取url
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
	* @description: 表格编辑相关
	*/
	// 上下移动列
	PHA.UpDownCol = function(_opt){
		var _gridID = _opt.gridID;
		var _ifUp = _opt.ifUp;
		// 取值
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "有必填项没有输入,无法完成表格编辑!",
				type: "alert"
			});
			return;
		}
		var selectedData = $("#" + _gridID).datagrid("getSelected") || "";
		if (selectedData == "") {
			PHA.Popover({
				msg: "请选择需要上下移动的行!",
				type: "alert"
			});
			return;
		}
		var rowsData = $("#" + _gridID).datagrid("getRows");
		var rowIndex = $("#" + _gridID).datagrid('getRowIndex', selectedData);
		if (_ifUp == true) {
			if (rowIndex == 0) {
				PHA.Popover({
					msg: "已到达第一行!",
					type: "alert"
				});
				return;
			}
		} else {
			if (rowIndex == rowsData.length - 1) {
				PHA.Popover({
					msg: "已到达最后一行!",
					type: "alert"
				});
				return;
			}
		}
		var newSelectedData = PHA.deepCopy(selectedData);
		// 交换行
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
	// 文本编辑框
	PHA.TextBoxEditor = function(){
		return {
			type: 'validatebox'
		}
	};
	// 数字编辑框
	PHA.NmberBoxEditor = function(){
		return {
			type: 'validatebox'
		}
	}
	// 复选编辑框
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
	// 添加行
	PHA.GridAppendRow = function(_options){
		var _gridID = _options.gridID;
		var _defaultData = _options.defaultData;
		var _editField = _options.editField;
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "请先完成表格上一行编辑!",
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
	// 开始编辑
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
	// 结束编辑
	PHA.GridEndEidting = function(_gridID){
		var isEndEidting = $("#" + _gridID).datagrid("endEditing");
		if (!isEndEidting) {
			PHA.Popover({
				msg: "未填入必填项,无法完成编辑!",
				type: "alert",
				timeout: 1000
			});
			return false;
		}
		return true;
	}
	// 获取有改变的行的数据
	PHA.GridChangedRows = function(_gridID) {
		var changedRows = $("#" + _gridID).datagrid("getChanges") || [];
		if (changedRows.length == 0) {
			PHA.Popover({
				msg: "没有需要保存的数据!",
				type: "error",
				timeout: 1000
			});
			return [];
		}
		return changedRows;
	}
	/*
	* @description: 运行完后台之后统一处理方法
	*/
	PHA.AfterRunServer = function (retStr, succCallFn, errCallFn) {
		var retArr = retStr.split("^");
		var retVal = retArr[0];
		var retInfo = retArr[1];
		if (retVal < 0) {
			PHA.Alert("提示", retInfo, retVal);
			if (errCallFn) {
				errCallFn();
			}
		} else {
			PHA.Popover({
				msg: retInfo || "成功!",
				type: "success",
				timeout: 500
			});
			if (succCallFn) {
				succCallFn();
			}
		}
	}
	// 拷贝对象
	PHA.deepCopy = function (source) {
		var result = {};
		for (var key in source) {
			result[key] = typeof source[key]==='object'? PHA.deepCopy(source[key]): source[key];
		}
		return result;
	}
})(PHA)