String.prototype.escapeJquery = function () {
	// 转义之后的结果
	var escapseResult = this;
	// javascript正则表达式中的特殊字符
	var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
		"]", "|", "{", "}"
	];
	// jquery中的特殊字符,不是正则表达式中的特殊字符
	var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
		":", ";", "<", ">", ",", "/"
	];
	for (var i = 0; i < jsSpecialChars.length; i++) {
		escapseResult = escapseResult.replace(new RegExp("\\" +
				jsSpecialChars[i], "g"), "\\" +
			jsSpecialChars[i]);
	}
	for (var i = 0; i < jquerySpecialChars.length; i++) {
		escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
			"g"), "\\" + jquerySpecialChars[i]);
	}
	return escapseResult;
};
Date.prototype.format = function (fmt) {
	var o = {
		"M+": this.getMonth() + 1, //月           
		"d+": this.getDate(), //日           
		"h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //时           
		"H+": this.getHours(), //小时           
		"m+": this.getMinutes(), //分           
		"s+": this.getSeconds(), //秒           
		"q+": Math.floor((this.getMonth() + 3) / 3), //季
		"S": this.getMilliseconds() //毫秒           
	};
	var week = {
		"0": "\u65e5",
		"1": "\u4e00",
		"2": "\u4e8c",
		"3": "\u4e09",
		"4": "\u56db",
		"5": "\u4e94",
		"6": "\u516d"
	};
	if (/(y+)/.test(fmt)) {
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	}
	if (/(E+)/.test(fmt)) {
		fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468") : "") + week[this.getDay() + ""]);
	}
	for (var k in o) {
		if (new RegExp("(" + k + ")").test(fmt)) {
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		}
	}
	return fmt;
};;


(function($){
	var $q2 = function(data,success,error){
		data.pClassName=data.ClassName;
		data.pQueryName=data.QueryName;
		delete data.QueryName;
		data.ClassName='BSP.SMP.COM.JsonTools';
		data.MethodName='Query2Json';
		return $cm(data,success,error);
	}
	$.q2=$q2;
	window.$q2=$q2;

})(jQuery);
(function (root) {
	var SMP_COMM = {};

	function readAsText(files, callback) {
		var ret = [],
			mylen = files.length;;
		for (var i = 0, f; f = files[i]; i++) {
			var reader = new FileReader();
			reader.onload = (function (file) {
				return function () {
					ret.push({
						name: file.name,
						result: this.result
					});
					mylen--;
					if (mylen == 0) callback(ret);
				}
			})(f);;
			reader.readAsText(f);
		}

	}

	function readAsExcel(files, cfg, fn) {
		var wb, rABS = false;
		if (typeof cfg == "function") {
			fn = cfg;
			cfg = {}
		}
		cfg = cfg || {};

		function setup_reader(file) {
			var filename = file.name;
			var reader = new FileReader();
			///因为IE浏览器不识别readAsBinaryString函数，所以重新书写readAsBinaryString函数
			if (!FileReader.prototype.readAsBinaryString) {
				FileReader.prototype.readAsBinaryString = function (f) {
					var binary = "";
					var pt = this;
					var reader = new FileReader();
					reader.onload = function (e) {
						var bytes = new Uint8Array(reader.result);
						var length = bytes.byteLength;
						for (var i = 0; i < length; i++) {
							binary += String.fromCharCode(bytes[i]);
						}
						pt.content = binary;
						$(pt).trigger('onload');
					};
					reader.readAsArrayBuffer(f);
				}
			}

			reader.onload = function (e) {
				//alert("onload");
				if (reader.result) reader.content = reader.result;
				data = reader.content;
				if (rABS) {
					wb = XLSX.read(btoa(fixdata(data)), { //手动转化
						type: 'base64'
					});
				} else {
					wb = XLSX.read(data, {
						type: 'binary'
					});
				}
				var sheetArr = [];
				if (cfg.allSheet) {
					for (var j = 0, len = wb.SheetNames.length; j < len; j++) {
						var sheetItem = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[j]]);
						sheetArr.push(sheetItem);
					}
				} else {
					var sheetItem = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
					sheetArr.push(sheetItem);
				}
				if (cfg.callbackOnce) {
					AllJson[filename] = sheetArr;
					completedCount++;
					if (length == completedCount && typeof fn == "function") fn(AllJson);
				} else {
					if (typeof fn == "function") {
						var json = {};
						json[filename] = sheetArr;
						fn(json);
					}
				}


			};

			if (rABS) {
				reader.readAsArrayBuffer(file);
			} else {
				reader.readAsBinaryString(file);
			}

			function fixdata(data) { //文件流转BinaryString
				var o = "",
					l = 0,
					w = 10240;
				for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
				o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
				return o;
			}
		}
		var AllJson = {};
		var length = files.length,
			completedCount = 0
		for (var i = 0; i < length; i++) {
			setup_reader(files[i]);
		}
	}




	SMP_COMM.bestSize = function (width, height) {
		width = width || 10000, height = height || 10000;
		var winWidth = $(window).width() || document.body.clientWidth || 1200,
			winHeight = $(window).height() || document.body.clientHeight || 600;
		if (typeof width == "string" && width.indexOf('%') > -1) {
			width = winWidth * (parseFloat(width) || 80) * 0.01;
		}
		if (typeof height == "string" && height.indexOf('%') > -1) {
			height = winHeight * (parseFloat(height) || 80) * 0.01;
		}
		width = parseInt(Math.min(width, winWidth - 20));
		height = parseInt(Math.min(height, winHeight - 20));
		var left = (winWidth - width) / 2,
			top = (winHeight - height) / 2;
		return {
			left: left,
			top: top,
			width: width,
			height: height
		}

	};
	SMP_COMM.simpleModal=function(title,url,width,height,target,otherOpts){
		var $easyModal=$('#easyModal');
		if ($easyModal.length==0){
			$easyModal=$('<div id="easyModal" style="overflow:hidden;"><iframe name="easyModal" style="width: 100%;height: 100%; margin:0; border: 0;" scrolling="auto"></iframe></div>').appendTo(target||'body');
		}
		var bestSize=SMP_COMM.bestSize(width,height)
		var newOpts=$.extend({
			iconCls:'icon-w-paper',
			modal:true,
			title:title
		},otherOpts,{
			width:bestSize.width,
			height:bestSize.height,
			inline:!!target
			,onClose:function(){
				$(target||'body').removeClass('panel-noscroll');
				if (otherOpts && otherOpts.onClose) otherOpts.onClose.call(this);
			},onOpen:function(){
				$(target||'body').addClass('panel-noscroll');
				if (otherOpts && otherOpts.onOpen) otherOpts.onOpen.call(this);
			}
		})
		
		$easyModal.dialog(newOpts).dialog('open').dialog('center');
		$easyModal.find('iframe').attr('src',url);

	}
	SMP_COMM.formatDate = function (datestr, format) {
		format = format || 3;
		if (format == 3) { //转换里面 dd/MM/yyyy格式的
			datestr = datestr.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig, function (m, i, d) {
				return m.split('/').reverse().join('-');
			})
		}
		if (format == 4) { //转换里面 yyyy-MM-dd 的
			datestr = datestr.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig, function (m) {
				return m.split('-').reverse().join('/');
			})
		}
		return datestr;
	};
	SMP_COMM.debounce = function (func, wait, immediate) {
		var timeout, result;
		var debounced = function () {
			var context = this;
			var args = arguments;

			if (timeout) clearTimeout(timeout);
			if (immediate) {
				// 如果已经执行过，不再执行
				var callNow = !timeout;
				timeout = setTimeout(function () {
					timeout = null;
				}, wait)
				if (callNow) result = func.apply(context, args)
			} else {
				timeout = setTimeout(function () {
					func.apply(context, args)
				}, wait);
			}
			return result;
		};
		debounced.cancel = function () {
			clearTimeout(timeout);
			timeout = null;
		};
		return debounced;
	};
	SMP_COMM.showBread = function (opts) {
		var winTemp = window,
			winIndex = null;
		while (true) {
			if (winTemp.isIndexPage) {
				winIndex = winTemp;
				break;
			} else if (winTemp.parent === winTemp) {
				break;
			} else {
				winTemp = winTemp.parent;
			}

		}
		if (winIndex) return winIndex.showBread(opts);
	};
	SMP_COMM.simpleFilterInit = function (GV, filterField, renderData) {
		$('#filter').searchbox({
			searcher:function (v) {
				GV.q = v;
				var filterRows = [];
				$.each(GV.rows, function () {
					if (this[filterField].toUpperCase().indexOf(v.toUpperCase()) > -1) filterRows.push(this);
				})
				GV.filterRows = filterRows;
				renderData(GV.filterRows);
			}
		})
	};
	SMP_COMM.simpleToggleInit = function (GV, type, renderData) {
		if (type == "echarts") $('#c-wraper').show();
		var items = [{
				text: '表格',
				id: 'grid'
			}, {
				text: '图表',
				id: 'echarts'
			}],
			selectedIndex = 0;
		items.forEach(function (item, ind) {
			if (item.id == type) selectedIndex = ind
		})
		items[selectedIndex].selected = true;
		$('#toggle').keywords({
			singleSelect: true,
			items: items,
			onClick: function (v) {
				if (v.id == "grid" && $('#c-wraper').is(':visible')) {
					$('#c-wraper').hide();
					renderData(GV.filterRows);
				} else if (v.id == "echarts" && !$('#c-wraper').is(':visible')) {
					$('#c-wraper').show();
					renderData(GV.filterRows);
				}
			}
		})
	}
	SMP_COMM.alert = function (title, msg, type) {
		if (typeof $.messager.popover == "function") {
			$.messager.popover({
				msg: msg,
				type: type,
				timeout: 1000
			})
		} else {
			$.messager.alert(title, msg)
		}
	}
	SMP_COMM.createSimpleEditGrid = (function () {
		var state = {
			isEditing: false,
		}
		return function (opts) {
			function setEditingIndex(ind) {
				if (ind > -1) {
					selfState.editingIndex = ind;
					selfState.isEditing = true;
				} else {
					selfState.editingIndex = -1;
					selfState.isEditing = false;
				}
				updateBtnState();
			}

			function updateBtnState() {
				if (opts.parentGrid && $(opts.parentGrid).hasClass('datagrid-f') > 0 && !$(opts.parentGrid).datagrid('getSelectedId')) {
					$('#' + opts.id + '-tb-btn-add' + ',#' + opts.id + '-tb-btn-edit' + ',#' + opts.id + '-tb-btn-delete').linkbutton('disable');
					$('#' + opts.id + '-tb-btn-undo' + ',#' + opts.id + '-tb-btn-save').linkbutton('disable');
					$('#' + opts.id + '-tb-btn-excel' + ',#' + opts.id + '-tb-btn-import').linkbutton('disable');
					return;
				}else{
					$('#' + opts.id + '-tb-btn-excel' + ',#' + opts.id + '-tb-btn-import').linkbutton('enable');
				}
				if (selfState.isEditing) {
					$('#' + opts.id + '-tb-btn-add' + ',#' + opts.id + '-tb-btn-edit' + ',#' + opts.id + '-tb-btn-delete').linkbutton('disable');
					$('#' + opts.id + '-tb-btn-undo' + ',#' + opts.id + '-tb-btn-save').linkbutton('enable');
				} else {
					$('#' + opts.id + '-tb-btn-add').linkbutton('enable');
					if (dg.datagrid('getSelected')) $('#' + opts.id + '-tb-btn-edit' + ',#' + opts.id + '-tb-btn-delete').linkbutton('enable');
					else $('#' + opts.id + '-tb-btn-edit' + ',#' + opts.id + '-tb-btn-delete').linkbutton('disable');
					$('#' + opts.id + '-tb-btn-undo' + ',#' + opts.id + '-tb-btn-save').linkbutton('disable');
				}
			}
			var selfState = {
				isEditing: false,
				editingIndex: -1
			};
			state[opts.id] = selfState;
			if (opts.toolbar && opts.toolbar.length > 0) {
				var $tb = $('<div id="' + opts.id + '-tb"></div>').insertAfter('#' + opts.id);

				$.each(opts.toolbar, function (ind, item) {
					if (typeof item == "object") {
						var btnId = item.id || (opts.id + '-tb-btn-' + ind);
						var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">' + item.text + '</a>').appendTo($tb);
						$btn.linkbutton({
							plain: true,
							onClick: item.handler || function () {},
							iconCls: item.iconCls || undefined
						})
					} else if (typeof item == "string") {
						if (item == "filter") {
							$tb.css({
								paddingTop: '4px',
								paddingBottom: '4px'
							})
							var id = opts.id + '-tb-filter';
							var $filterCon = $('<div style="float:right;padding-right:10px;"></div>').appendTo($tb);
							var $filter = $('<input id="' + id + '"/>').appendTo($filterCon);
							$filter.searchbox({
								searcher: function (val) {
									if (typeof opts.filterFun == "function") opts.filterFun.call(dg[0], val);
								}
							})
						} else if (item == "-") {

						} else if (item == "add") {
							var btnId = opts.id + '-tb-btn-add'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">新增</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-add',
								onClick: function () {
									if (selfState.isEditing) {
										SMP_COMM.alert("提示", "请先保存正在编辑的行", 'info');
										return;
									}
									var newRow = opts.newRowGetter ? opts.newRowGetter.call(dg) : {};
									var newRowIndex = dg.datagrid('unselectAll').datagrid('appendRow', newRow).datagrid('getRows').length - 1;
									dg.datagrid('beginEdit', newRowIndex);
									setEditingIndex(newRowIndex);

								}
							})
						} else if (item == "edit") {
							var btnId = opts.id + '-tb-btn-edit'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">修改</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-edit',
								onClick: function () {
									if (selfState.isEditing) {
										SMP_COMM.alert("提示", "请先保存正在编辑的行", 'info');
										return;
									}
									var rows=dg.datagrid('getSelections');
									var row=null;
									if(rows &&rows.length>0) {
										//var row = dg.datagrid('getSelected');	
										row=rows[rows.length-1];
									}
									
									if (row) {
										var rowIndex = dg.datagrid('getRowIndex', row);
									} else {
										SMP_COMM.alert("提示", "请选择一行数据", 'info');
										return;
									}
									dg.datagrid('beginEdit', rowIndex);

									setEditingIndex(rowIndex);

									var edts = dg.datagrid('getEditors', selfState.editingIndex);
									for (var i = 0; i < edts.length; i++) {
										var edt = edts[i];
										if (opts.disabledEditFields && opts.disabledEditFields instanceof Array && opts.disabledEditFields.indexOf(edt.field) > -1) {
											$(edt.target).attr('disabled', 'disabled');
											if ($(edt.target).hasClass('combobox-f')){
												$(edt.target).combobox('disable');
											}
										}
										if (typeof opts.isDisableddField=='function'){
											if (opts.isDisableddField.call(dg[0],rowIndex,row,edt.field)) {
												$(edt.target).attr('disabled', 'disabled');
												if ($(edt.target).hasClass('combobox-f')){
													$(edt.target).combobox('disable');
												}
											}
											
										}
									}
								}
							})
						} else if (item == "delete") {
							var btnId = opts.id + '-tb-btn-delete'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">删除</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-remove',
								onClick: function () {
									if (selfState.isEditing) {
										SMP_COMM.alert("提示", "请先保存正在编辑的行", 'info');
										return;
									}
									
									var rows=dg.datagrid('getSelections');
									var row=null;
									if(rows &&rows.length>0) {
										row=rows[rows.length-1];
									}

									var row = dg.datagrid('getSelected');
									if (row) {
										var rowInd = dg.datagrid('getRowIndex', row);
										$.messager.confirm("确定", opts.deleteConfirmMsg || (rows.length==1?"确认删除此条数据吗？":"确认删除选择的这"+rows.length+'条数据吗？'), function (r) {
											if (r) {
												if (typeof opts.deleteFun == "function") opts.deleteFun.call(dg[0], rowInd, row, function (flag, errMsg,succMsg) {
													if (flag) {
														SMP_COMM.alert("成功", succMsg||"删除成功", "success");
														dg.datagrid('reload');
													} else {
														SMP_COMM.alert("失败", errMsg, "error");
													}
												},rows);
											}
										})
									} else {
										SMP_COMM.alert("提示", "请选择一行数据", 'info');
										return;
									}

								}
							})
						} else if (item == "undo") {
							var btnId = opts.id + '-tb-btn-undo'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">取消编辑</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-undo',
								onClick: function () {
									if (selfState.isEditing && selfState.editingIndex > -1) {
										var row = dg.datagrid('getRows')[selfState.editingIndex];
										if (row && row.TId) {
											dg.datagrid('cancelEdit', selfState.editingIndex);
										} else {
											dg.datagrid('deleteRow', selfState.editingIndex);
										}
										setEditingIndex(-1);
									} else {
										SMP_COMM.alert("提示", "您没有正在编辑的行", 'info');
									}

								}
							})

						} else if (item == "save") {
							var btnId = opts.id + '-tb-btn-save'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">保存</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-save',
								onClick: function () {
									if (selfState.isEditing && selfState.editingIndex > -1) {
										dg.datagrid('endEdit', selfState.editingIndex);
										var edts = dg.datagrid('getEditors', selfState.editingIndex);
										if (edts && edts.length > 0) { //validate未验证通过
											return;
										}
										var rowData = dg.datagrid('getRows')[selfState.editingIndex];
										if (typeof opts.validateFun == "function") {
											opts.validateFun.call(dg[0], selfState.editingIndex, rowData, function (flag, msg) {
												if (flag) {
													if (typeof opts.saveFun == "function") {
														opts.saveFun.call(dg[0], selfState.editingIndex, rowData, function (flag, msg, newRowData) {
															if (flag) {
																SMP_COMM.alert("成功", "保存成功", "success");
																if (newRowData && newRowData[opts.idField]) {
																	$.extend(rowData, newRowData);
																} else {
																	rowData[opts.idField] = msg;
																}

																dg.datagrid('updateRow', {
																	index: selfState.editingIndex,
																	row: rowData
																});
																setEditingIndex(-1);
															} else {
																SMP_COMM.alert('失败', msg, 'error');
																dg.datagrid('beginEdit', selfState.editingIndex);
															}

														})
													}
												} else {
													SMP_COMM.alert('提示', msg, 'info');
													dg.datagrid('beginEdit', selfState.editingIndex);
												}
											})
										}

									} else {
										SMP_COMM.alert("提示", "您没有正在编辑的行", 'info');
									}

								}
							})
						} else if (item == "export") {
							var btnId = opts.id + '-tb-btn-excel'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">导出</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-excel',
								onClick: function () {
									var title = (dg.datagrid('getPanel').panel('options').title || opts.id) + (new Date()).format('-yyyyMMdd-HHmmss');
									var m = $.messager.prompt('导出', '请输入excel文件名称', function (r) {
										if (r) {
											$.messager.progress({ //用xlsx导出时一般很快，可能一闪而过    用MSExcel,卡进程，动画基本没有
												title: '正在导出',
												msg: '正在导出数据,请稍后...'
											});
											grid2excel(dg, $.extend({
												IE11IsLowIE: false,
												filename: r,
												allPage: true,
												callback: function (success, data) {
													if (success) {
														SMP_COMM.alert('成功', '导出成功 ' + (data || ''), 'success');

													} else {
														SMP_COMM.alert('失败', '导出失败 ' + (data || ''), 'error');
													}
													$.messager.progress('close');
												}
											},opts.grid2excelOpts||{}));


										} else {
											SMP_COMM.alert('提示', '您选择了取消或文件名为空', 'alert');
										}
									}).find('.messager-input').val(title); //给个默认excel名

								}
							})
						} else if (item == "import") {
							var btnId = opts.id + '-tb-btn-import'
							var $btn = $('<a href="javascript:void(0)" id="' + btnId + '">导入</a>').appendTo($tb);
							$btn.linkbutton({
								plain: true,
								iconCls: 'icon-import-xls',
								onClick: function () {
									//alert('import');
									if (!selfState.importWin) {
										selfState.excelParsedData = [];
										var winId = btnId + '-win';
										var $importWin = $('<div id="' + winId + '"></div>').appendTo('body');
										selfState.importWin = $importWin;
										var size = SMP_COMM.bestSize();
										var title = (dg.datagrid('getPanel').panel('options').title || opts.id);
										var layoutId = winId + '-layout',
											prevTableId = winId + '-t',
											fileId = winId + '-file';
										var contentHtml = '<div class="hisui-layout" data-options="fit:true" id="' + layoutId + '">\
											<div data-options="region:\'north\',border:false" style="height:50px;padding:10px;">\
												<input id="' + fileId + '" type="file" class="hisui-filebox" style="width:400px;" data-options="buttonText:\'选择\',prompt:\'excel文件：*.xls,*.xlsx\'" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">\
												<a class="hisui-linkbutton" id="' + fileId + '-ok" >确定</a>  \
												<a class="hisui-linkbutton" id="' + fileId + '-clear">清除</a> \
												<a class="hisui-linkbutton" id="' + fileId + '-import">导入</a> \
											</div>\
											<div data-options="region:\'center\',border:false" style="padding:0 10px 10px 10px;">\
												<table id="' + prevTableId + '"></table>\
											</div>\
										</div>';
										$importWin.dialog({
											width: size.width,
											height: size.height,
											title: title + ' Excel导入',
											modal: true,
											draggable: false,
											content: contentHtml,
											onOpen:function(){
												$('#'+fileId+'-clear').trigger('click');
											}
										})
										var processWinId = winId + '-process-win',
											processId = winId + '-process-bar';
										var $processWin = $('<div class="hisui-dialog" id="' + processWinId + '" data-options="width:400,height:180,closed:true,modal:true,draggable:false,resizable:false,closable:false,title:\'导入进度\'" style="padding:10px;">\
																<div style="padding:10px;text-align:center;line-height:20px;">正在导入,请等候...</div>\
																<div id="' + processId + '" class="hisui-progressbar" data-options="value:0," style="width:380px;"></div>\
															</div>').appendTo('body');
										$processWin.dialog({
											buttons:[
												{
													text:'停止',
													handler:function(){
														$.messager.confirm('确认','是否停止导入？',function(r){
															if(r) {
																$processWin.dialog('close');
																state.FORCE_STOP_IMPORT_PROCESSE=true;
															}else{
																
															}
														})	
													}	
												}
											]
										});
										var $processBar = $('#' + processId).progressbar({});
										var resultWinId = winId + '-result-win',
											resultTableId = winId + '-result-t';
										var $resultWin = $('<div class="hisui-dialog" id="' + resultWinId + '" data-options="width:1000,height:500,closed:true,modal:true,draggable:false,resizable:false,title:\'导入结果\'" style="padding:10px;">\
															<table id="' + resultTableId + '"></table>\
														</div>').appendTo('body');
										$resultWin.dialog({
											width: size.width,
											height: size.height,
											title: title + ' Excel导入结果',
											onClose:function(){
												dg.datagrid('reload');
												
											}
										})
										var $resultTable = $('#' + resultTableId);





										var prevColumns = [];
										selfState.title2Code = {};
										selfState.code2Title = {};
										$.each(opts.columns, function (ind, ele) {
											var prevColumnsI = [];
											$.each(ele, function (ind2, ele2) {
												prevColumnsI.push($.extend({}, ele2));
												selfState.title2Code[ele2.title] = ele2.field;
												selfState.code2Title[ele2.field] = ele2.title;
											})
											prevColumns.push(prevColumnsI);
										})
										var $prevTable = $('#' + prevTableId).datagrid({
											fit: true,
											fitColumns: true,
											title: title + ' Excel数据预览',
											rownumbers: true,
											striped: true,
											headerCls: 'panel-header-gray',
											iconCls: 'icon-paper',
											idField: opts.codeField || 'TCode',
											singleSelect: true,
											pagination: true,
											pageSize: 30,
											columns: prevColumns,
											data: {
												total: 0,
												rows: []
											}
										})
										var pager = $prevTable.datagrid("getPager");
										pager.pagination({
											total: selfState.excelParsedData.length,
											onSelectPage: function (pageNo, pageSize) {
												var grid = $prevTable;
												var gridOpts = grid.datagrid('options');
												gridOpts.pageNumber = pageNo;
												gridOpts.pageSize = pageSize;
												var start = (pageNo - 1) * pageSize;
												var end = start + pageSize;
												grid.datagrid("loadData", selfState.excelParsedData.slice(start, end));
												pager.pagination('refresh', {
													total: selfState.excelParsedData.length,
													pageNumber: pageNo
												});
											}
										});
										$('#' + fileId + '-ok').click(function () {
											var files = $('#' + fileId).filebox('files');
											if (files) {
												readAsExcel(files, function (ret) {
													var sheetrows;
													for (var i in ret) { //循环文件 
														sheetrows = ret[i][0];
														if (sheetrows) break;
													}
													console.log(sheetrows);

													if (sheetrows && sheetrows.length) {
														selfState.excelData = sheetrows;
														selfState.excelParsedData = [];
														$.each(selfState.excelData, function (i, item) {
															if (typeof opts.excelFilter=='function') { //表格数据过滤  返回true显示
																if (opts.excelFilter.call(dg[0],i,item)!=true) return;
															}
															var newrow = opts.newRowGetter ? opts.newRowGetter.call(dg) : {}; 
															$.each(item, function (key) {
																if (selfState.title2Code[key]) newrow[selfState.title2Code[key]] = item[key];
															})
															if (typeof opts.rowParser == "function") opts.rowParser.call(dg[0], newrow); //this指向用原表格
															selfState.excelParsedData.push(newrow);
														})
														var msg="表格数据"+selfState.excelData.length+'条，'
																+'满足导入条件的有'+selfState.excelParsedData.length+'条';
														SMP_COMM.alert('成功',msg , 'success');	
														
														
														
														$prevTable.datagrid('unselectAll');
														pager.pagination('select', 1);



													}

												})
											}
										})

										$('#' + fileId + '-clear').click(function () {
											$('#' + fileId).filebox('clear');
											$prevTable.datagrid('unselectAll');
											selfState.excelData = [];
											selfState.excelParsedData = [];
											selfState.excelResultData = [];
											pager.pagination('select', 1);
										})

										var importRows = function (rows, callback,importOpts) {
											importOpts=importOpts||{};
											var ind = 0,
												len = rows.length,
												result = {
													rows: [],
													countSucc: 0,
													countFail: 0
												};
											if (typeof opts.importFun !== "function") {
												callback(process, result, true, true);
												return;
											}
											function importOneRow(oneIndex) {
												opts.importFun(rows[oneIndex], function (ret, isSuccess) {
													result.rows.push($.extend({
														'_result': ret,
														'_isSuccess':isSuccess
													}, rows[ind]));
													result[isSuccess ? 'countSucc' : 'countFail']++;
													ind++;
													var process = ((ind / len * 100).toFixed(2)) + "%";
													callback(process, result.rows[ind - 1]); //导入一条 单步callback
													if (ind == len) {
														callback(process, result, true); //最后一条 全部导完 整体callback
													} else if (state.FORCE_STOP_IMPORT_PROCESSE) {
														callback(process, result, true, true);
													} else {
														importOneRow(ind); //不是最后一条 继续导入下一条
													}
												},importOpts);
											}
											importOneRow(ind);
										};

										var showImportResult=function (result, isForce) {
											$resultWin.dialog('open').dialog('center');
											var colArr = [];
											$.each(prevColumns[0], function (i, item) {
												colArr.push($.extend({}, item, {
													width: 100
												}))
											})
											colArr.push({
												field: '_result',
												title: '_result',
												width: 200,
												styler: function (value, row, index) {
													if (!row._isSuccess) {
														return 'background-color:#ffee00;color:red;';
													}
												}
											});
											selfState.excelResultData = result.rows;

											$resultTable.datagrid({
												fit: true,
												fitColumns: true,
												title: title + ' Excel数据导入结果',
												rownumbers: true,
												striped: true,
												headerCls: 'panel-header-gray',
												iconCls: 'icon-paper',
												idField: opts.codeField || 'TCode',
												singleSelect: true,
												pagination: true,
												pageSize: 30,
												columns: [colArr],
												data: {
													total: 0,
													rows: []
												},
												toolbar: [{
													iconCls: 'icon-excel',
													text: '导出结果',
													handler: function () {
														var title = ($resultTable.datagrid('getPanel').panel('options').title || 'excel导入结果') + (new Date()).format('-yyyyMMdd-HHmmss');
														var m = $.messager.prompt('导出', '请输入excel文件名称', function (r) {
															if (r) {
																$.messager.progress({ //用xlsx导出时一般很快，可能一闪而过    用MSExcel,卡进程，动画基本没有
																	title: '正在导出',
																	msg: '正在导出数据,请稍后...'
																});
																grid2excel($resultTable, {
																	IE11IsLowIE: false,
																	filename: r,
																	allPage: true,
																	customRows:selfState.excelResultData ,  //自己实现的分页 需要传数据进去
																	callback: function (success, data) {
																		if (success) {
																			SMP_COMM.alert('成功', '导出成功 ' + (data || ''), 'success');

																		} else {
																			SMP_COMM.alert('失败', '导出失败 ' + (data || ''), 'error');
																		}
																		$.messager.progress('close');
																	}
																});


															} else {
																SMP_COMM.alert('提示', '您选择了取消或文件名为空', 'alert');
															}
														}).find('.messager-input').val(title); //给个默认excel名
													}
												}]
											})
											var pager = $resultTable.datagrid("getPager");
											pager.pagination({
												total: selfState.excelResultData.length,
												onSelectPage: function (pageNo, pageSize) {
													var grid = $resultTable;
													var gridOpts = grid.datagrid('options');
													gridOpts.pageNumber = pageNo;
													gridOpts.pageSize = pageSize;
													var start = (pageNo - 1) * pageSize;
													var end = start + pageSize;
													grid.datagrid("loadData", selfState.excelResultData.slice(start, end));
													pager.pagination('refresh', {
														total: selfState.excelResultData.length,
														pageNumber: pageNo
													});
												}
											});
											pager.pagination('select', 1);
										}


										$('#' + fileId + '-import').click(function () {
											if(!(selfState.excelParsedData && selfState.excelParsedData instanceof Array && selfState.excelParsedData.length>0)){
												SMP_COMM.alert('提示','请先选择excel文件，并确定','info')
												return;
											}
											if (opts.allowOverwrite) { //允许覆盖导入
												$.messager.confirm('是否覆盖','导入的数据可能已存在，是否覆盖？',function(r){
													if (r) {
														startImportRows(true);
													}else{
														startImportRows(false);
													}
												})
											}else{
												startImportRows(false);
											}
											
											
											function startImportRows(overwrite){
												state.FORCE_STOP_IMPORT_PROCESSE=false;
												$importWin.dialog('close');
												$processWin.dialog('open');
												//逐条异步导入  （全部一起导入没进度，分段多条导入后台方法麻烦些，同步导入会阻塞UI线程）
												importRows(selfState.excelParsedData, function (process, result, isEnd, isForce) {
													if (isEnd == true) {
														if (isForce == true) {
															$.messager.alert("成功", '已停止', null, function () {
																$processWin.dialog('close');
																showImportResult(result, true);
															});
														} else {
															$.messager.alert("成功", '导入成功', null, function () {
																$processWin.dialog('close');
																showImportResult(result);
															});

														}

													} else {

														console.log(process, result);
														$processBar.progressbar('setValue', parseFloat(process));
													}
												},{overwrite:overwrite});	
											}
										})
									}
									selfState.importWin.dialog('open');


								}
							})
						} else {

						}
					}
				}) //end each
			} //end if opts.toolbar

			var dg = $('#' + opts.id).datagrid({
				fit: true,
				fitColumns: true,
				title: opts.title,
				rownumbers: true,
				striped: true,
				headerCls: 'panel-header-gray',
				iconCls: 'icon-paper',
				idField: opts.idField || 'TId',
				singleSelect: typeof opts.singleSelect=='boolean'?opts.singleSelect:true,
				checkOnSelect:typeof opts.checkOnSelect=='boolean'?opts.checkOnSelect:true,
				selectOnCheck:typeof opts.selectOnCheck=='boolean'?opts.selectOnCheck:true,
				mode: 'remote',
				toolbar: (opts.toolbar && opts.toolbar.length > 0) ? '#' + opts.id + '-tb' : undefined,
				displayMsg: opts.displayMsg,
				pagination: true,
				pageSize: opts.pageSize||30,
				pageList:opts.pageList||[10,20,30,50,100],
				columns: opts.columns,
				url: $URL,
				queryParams: opts.queryParams,
				onBeforeLoad: function () {
					$(this).datagrid('unselectAll');
				},
				onDblClickRow: function (ind) {
					if (opts.toolbar && opts.toolbar.length > 0 && opts.toolbar.indexOf('edit') > -1) {
						$('#' + opts.id).datagrid('selectRow',ind);
						$('#' + opts.id + '-tb-btn-edit').click();
					}
				},
				onLoadSuccess: function () {
					setEditingIndex(-1);
					updateBtnState();
					if (typeof opts.onSelectChange == "function") opts.onSelectChange.call(this);
				},
				onSelect: function (ind, row) {
					updateBtnState();
					if (typeof opts.onSelectChange == "function") opts.onSelectChange.call(this);
				},
				onUnselect: function () {
					updateBtnState();
					if (typeof opts.onSelectChange == "function") opts.onSelectChange.call(this);
				},onBeforeCheck:opts.onBeforeCheck
				,onBeforeSelect:opts.onBeforeSelect
				
			})
			return dg;
		}
	})();
	
	
	SMP_COMM.simpleChoice=function(opts){
		var $simpleChoice=$('#simple-choice');
		if ($simpleChoice.length==0){
			$simpleChoice=$('<div id="simple-choice" style="padding:10px;"><div class="simple-choice-header" style="line-height:20px;padding-bottom:5px;border-bottom:1px solid #eee; color:#017bce;font-weight:bold;"></div><div class="simple-choice-body" style="padding-top:13px;"></div></div>').appendTo('body');
			$simpleChoice.dialog({
				modal:true,
				width:opts.width,
				height:opts.height,
				title:opts.title||'请选择',
				iconCls:opts.iconCls||'icon-w-paper',
				closed:true,
				onClose:function(){
					$simpleChoice.find('.simple-choice-kw').keywords('clearAllSelected');
				}
			})
		}
		$simpleChoice.dialog('open').dialog('resize',{width:opts.width,height:opts.height}).dialog('center');
		$simpleChoice.find('.simple-choice-header').html(opts.msg||'');
		$simpleChoice.find('.simple-choice-body').empty();
		var kw=$('<div class="simple-choice-kw"></div>').appendTo($simpleChoice.find('.simple-choice-body'));
		
		kw.keywords({
			onClick:function(v){
				if(typeof opts.onChoice=='function') opts.onChoice.call(this,v);
				$simpleChoice.dialog('close');
			},
            items:opts.items
		})
	}
	///jqSelector元素选择器，xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
	SMP_COMM.renderSimpleEChart=function(opts){
		var dom=$(opts.jqSelector)[0];//元素选择
		var rows=opts.rows;
		
		var myChart = echarts.getInstanceByDom(dom)||echarts.init(dom);
		
		var option = {
		    tooltip : opts.tooltip||{
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    dataZoom: opts.dataZoom||[
		        {
		            type: 'inside'
		        }
		    ],
		    grid: opts.grid||{
		        left: '3%',
		        right: '4%',
		        bottom: '80px',
		        containLabel: true
		    },
		    xAxis : [
		        {
		            type : opts.xAxisType,
		            axisTick: {
		                alignWithLabel: true
		            },
		            axisLabel: opts.axisLabel||{  
					   interval:0,  
					   rotate:45
					}  
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		    legend: {
		        data: []
		    },
		    series : [
		    ]
		};
		
		if (opts.selectedMode) option.legend.selectedMode=opts.selectedMode;
		if (opts.legendSelected) option.legend.selected=opts.legendSelected;
		if (opts.xAxisType=='category') option.xAxis[0].data=rows.map(function(row){return row[opts.cateField];});
		$.each(opts.columns,function(i,col){
			option.legend.data.push(col.title);
			if (col.selected===false) {
				if (option.legend.selected) option.legend.selected[col.title]=false;
				else  option.legend.selected={},option.legend.selected[col.title]=false;
			}
			if (opts.xAxisType=='time'){
				var seriesItem={
					name:col.title,
					type:'line',
					barWidth: col.barWidth,
					data:rows.map(function(row){
			            var time=row[opts.dateField]+' '+row[opts.timeField];
			            if ((typeof opts.rowFilter!=='function' || opts.rowFilter(row,col.field)!==false)&&( !isNaN(row[col.field]))) return {name:time,value:[time,row[col.field]]} ;
			        })
				};
				option.series.push(seriesItem);
			}else if(opts.xAxisType=='category'){
				var seriesItem={
		            name:col.title,
		            type:'bar',
		            barWidth: col.barWidth,
		            data:rows.map(function(row){
			            if ((typeof opts.rowFilter!=='function' || opts.rowFilter(row,col.field)!==false)&&( !isNaN(row[col.field]))) return row[col.field];
			        })
				};
				option.series.push(seriesItem);
			}
		})
		
		myChart.setOption(option);
		myChart.off('click');
		myChart.on('click',function(o){
			if (typeof opts.onClick=="function") opts.onClick.call(this,o);
		})
	}
	///重复调用多次才触发
	SMP_COMM.repeat=function(fn,wait,times){
        var timer,result,currtimes=0,flag=false;
        var repeated=function(){
            var context=this;
            var args=arguments;
            if (!flag){
                currtimes=0;
            }
            currtimes++;
            if(currtimes>=times) {
                result =fn.apply(context,args);
            }
            flag=true;
            if (timer) clearTimeout(timer);
            timer=setTimeout(function(){
                flag=false;
            },wait);
        };
        repeated.reset = function() {
            clearTimeout(timer);
            timer = null;
            flag=false;
            currtimes=0;
        };
        return repeated;
    }
	
	SMP_COMM.bindRepeatEvent=function(jq,event,fn,wait,times){
		var repeatFun=SMP_COMM.repeat(fn,wait,times)
		jq.on(event,repeatFun)
	}

	root.SMP_COMM = SMP_COMM;
})(window);

(function ($) {
	$.fn.combogrid.methods.setRemoteValue = function (jq, param) {
		return jq.each(function () {
			if (typeof param == "string") {
				$(this).combogrid('setValue', param);
			} else {
				var val = param['value'] || '';
				var text = param['text'] || '';
				$(this).combogrid('options').keyHandler.query.call(this, text);
				$(this).combogrid('setValue', val).combogrid('setText', text);
			}
		})
	}
})(jQuery);
(function ($) {
	$.fn.datagrid.methods.load2 = function (jq, param) {
		return jq.each(function () {
			var oldParams = $(this).datagrid('options').queryParams || {};
			var cloneOldParams = {};
			for (var i in oldParams) {
				if (i != "page" && i != "rows" && i != "q" && i != "sort" && i != "order") cloneOldParams[i] = oldParams[i];
			}
			$(this).datagrid('load', $.extend(cloneOldParams, param));
		})
	}
	$.fn.datagrid.methods.getSelectedId = function (jq, param) {
		var idField = jq.datagrid('options').idField;
		var row = jq.datagrid('getSelected');
		return (row || {})[idField];
	}
})(jQuery);


$.extend($.fn.validatebox.defaults.rules, {
	//global 命名
    globalname: {
		validator: function(value,param){
			var mode=param[0];
			if (mode=="fuzzyleft") {  //左匹配Global 允许末位为*
				var myreg = /^[A-Za-z%][A-Za-z0-9\.]{0,30}[A-Za-z0-9*]$/
				
			}else{ //全匹配
				var myreg = /^[A-Za-z%][A-Za-z0-9\.]{0,30}[A-Za-z0-9]$/
			}
			return myreg.test(value);
		},
		message: 'Global名称不正确'
    }
});