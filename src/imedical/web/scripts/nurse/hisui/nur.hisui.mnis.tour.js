/// Creator:      EH
/// CreatDate:    2021-06-04
/// Description:  分级巡视/输液巡视/输血巡视 单人/多人

var GV = {
	CLASSNAME: 'Nur.HISUI.MNIS.Tour',
	TOOLTIP: 'tooltip'
};

/// 初始化
$(function() {
    initPageDom();
	initEvent();
});

function initEvent() {
	$('#tourGridFindBtn').bind('click', tourGridOnFindClick);
	$('#tourGridExportBtn').bind('click', tourGridOnExportClick);
}
function initPageDom() {
	var cms = tourGridColumnModel();
	$HUI.datagrid('#tourGrid', {
		url: '',
		columns: [
			cms.columns
		],
		frozenColumns: [
			cms.frozenColumns
		],
		fitColumns: false,
		idField: 'ID',
		pagination: true,
		pageSize: 100,
		pageList: [100, 200, 500],
		loadFilter: pagerFilter,
		singleSelect: true,
		onLoadSuccess: tourGridOnLoadData
	});
	if (PageFlag == 'S') {
		/// vue界面病人banner重复
		var removePatBanner = function() {
			if (ifPatBannerExist('patInfoBanner_patInfoText')) {
				var top = $('#main').children().children().eq(2).css('top');
				if (parseInt(top) == 0) return;
				var style = document.createElement('style');
				style.type = 'text/css';
				var content = '#main{padding:4px;border:0;-moz-border-radius:0;-webkit-border-radius:0;border-radius:0}#main>.layout>.layout-panel-center{border-left:0 none}';
				try {
				　　style.appendChild(document.createTextNode(content));
				} catch(e) {
				　　style.styleSheet.cssText = content;
				}
				var head = document.getElementsByTagName('head')[0];
				head.appendChild(style);
				$('#main').parent().parent().layout('resize');
				$('#main').children().layout('panel', 'north').hide();
				$('#main').children().layout('panel', 'north').height(0);
				$('#main').children().layout('resize');
				var height = $('#main').children().children().eq(2).children().eq(1).height();
				$('#main').children().children().eq(2).css('top', 0);
				$('#main').children().children().eq(2).children().eq(1).height(height + parseInt(top));
				var grid = $('#tourPanel').children(':first').children(':first');
				grid.height(grid.height() + parseInt(top));
			} else if (ifPatBannerExist('PatInfoItem')) {
				var top = parseInt($('#main').children().eq(0).children().eq(1).css('top'));
				if (top == 0) return;
				var style = document.createElement('style');
				style.type = 'text/css';
				var content = '#main{padding:4px;border:0;-moz-border-radius:0;-webkit-border-radius:0;border-radius:0}#main>.layout>.layout-panel-center{border-left:0 none}';
				try {
				　　style.appendChild(document.createTextNode(content));
				} catch(e) {
				　　style.styleSheet.cssText = content;
				}
				var head = document.getElementsByTagName('head')[0];
				head.appendChild(style);
				$('#main').parent().parent().layout('resize');
				var banner = $('#main').children().eq(0).children().eq(0).height();
				$('#main').children().eq(0).children().eq(0).height(0);
				$('#main').children().eq(0).children().eq(1).css('top', '0px');
				var height = $('#main').children().eq(0).children().eq(1).height();
				$('#main').children().eq(0).children().eq(1).height(height + banner);
				var height = $('#main').children().eq(0).children().eq(1).children().eq(1).height();
				$('#main').children().eq(0).children().eq(1).children().eq(1).height(height + top);
				var height = $('#main').children().eq(0).children().eq(1).children().eq(1).children().eq(0).height();
				$('#main').children().eq(0).children().eq(1).children().eq(1).children().eq(0).height(height + top);
				var grid = $('#tourPanel').children(':first').children(':first');
				grid.height(grid.height() + parseInt(top));
			}
			if ($('#main').children().layout('panel', 'north').css('display') != 'none') {
				setPatientInfo(EpisodeID);
			}
		};
		$(window).resize(function() {
			setTimeout(function() {
				removePatBanner();
			}, 1000);
		});
		removePatBanner();
		$('#tourGridStartDate').datebox('setValue', GV.PARAMETER.startDate);
		$('#tourGridEndDate').datebox('setValue', GV.PARAMETER.endDate);
		setTimeout(tourGridOnFindClick, 20);
	} else {
		$('#tourGridDate').datebox('setValue', GV.PARAMETER.endDate);
		setTimeout(function() {
			if (typeof(getAllCheckedPatient) != 'undefined') {
				var fn = $('#patientTree').tree('options').onLoadSuccess;
				$('#patientTree').tree('options').onLoadSuccess = function(node, data) {
					if (typeof(fn) == 'function') fn(node, data);
					setTimeout(tourGridOnFindClick, 20);
				}
			}
		}, 10);
	}
}
function tourGridOnFindClick() {
	var episodeIDStr, startDate, endDate;
	if (PageFlag == 'S') {
		episodeIDStr = EpisodeID;
		startDate = $('#tourGridStartDate').datebox('getValue');
		endDate = $('#tourGridEndDate').datebox('getValue');
	} else {
		if ($HUI.patienttree) {
			episodeIDStr = $HUI.patienttree();
		} else if (typeof(getAllCheckedPatient) != 'undefined') {
			getAllCheckedPatient();
			episodeIDStr = window.EpisodeIDStr;
		} else {
			episodeIDStr = EpisodeID
		}
		startDate = $('#tourGridDate').datebox('getValue');
		endDate = $('#tourGridDate').datebox('getValue');
	}
	var queryParams = {
		ClassName: GV.CLASSNAME,
		MethodName: GV.PARAMETER.methodName,
		ResultSetType: 'array',
		locID: LocID,
		episodeIDStr: episodeIDStr,
		startDate: startDate,
		endDate: endDate,
		returnType: false
	};
	var options = $('#tourGrid').datagrid('options');
	if (options.url == '') {
		options.url = $URL;
	}
	$('#tourGrid').datagrid('reload', queryParams);
}

function tourGridColumnModel() {
	var parr = $cm({
		ClassName: GV.CLASSNAME,
		MethodName: 'Parameter',
		pageName: PageName,
		locID: LocID,
		episodeID: EpisodeID
	}, false);
	GV.PARAMETER = parr;
	var colModel = parr.columns;
	var columns = [], frozenColumns = [], orderStepWrapLeft = 0, orderStepWrap = false;
	colModel.forEach(function(value, index, array) {
		var column = value;
		if (!column.hasOwnProperty('width')) {
			column.width = 120;
		}
		if (column.formatter == 'orderstep') {
			orderStepWrap = true;
		}
		if (!orderStepWrap && !column.hidden) {
			orderStepWrapLeft += parseInt(column.width);
		}
		var colCls = column.hasOwnProperty('class') ? column.class : '';
		switch (column.formatter) {
			case 'table':
			case 'popover':
			case 'orderstep':
				column.formatter = function(value, row, index) {
					var table = '';
					if (value) {
						var color = '', cls = colCls;
						if (typeof(value) == 'object') {
							color = value.hasOwnProperty('color') ? value.color : '';
							if (value.hasOwnProperty('class')) {
								cls = value.class;
							}
						}
						var tr = function(tr) {
							var text;
							if (typeof(tr) == 'object') {
								text = tr.value;
								var styleAttr = '', clsAttr = '';
								var trColor = tr.hasOwnProperty('color') ? tr.color : color;
								var trCls = tr.hasOwnProperty('class') ? tr.class : cls;
								if (trColor != '') {
									if (styleAttr == '') {
										styleAttr = ' style="';
									}
									else {
										styleAttr = styleAttr.substring(0, styleAttr.length - 1) + ';';
									}
									styleAttr += 'color:' + trColor + '"';
								}
								if (trCls != '') {
									clsAttr = ' class="' + trCls + '"';
								}
								switch (trCls) {
									case 'arcimdesc':
										text = tr.value;
										if (typeof (tr.value) == 'object') {
											text = '';
											var style = tr.value.length > 1 ? '' : ' style="border:0"';
											for (var j = 0; j < tr.value.length; j++) {
												text += '<div style="display:flex">'
												var desc = typeof(tr.value[j]) == 'object' ? tr.value[j].value : tr.value[j];
												text += '<div><div class="left-bracket"' + style + '></div><div class="right-bracket"' + style + '></div></div>';
												text += '<div style="margin:5px 0 0 5px"><span>' + desc + '</span></div></div>';
											}
										}
										break;
									default:
										break;
								}
								text = '<div' + clsAttr + '>' + text + '</div>';
							} else {
								text = tr;
							}
							text = '<tr' + clsAttr + styleAttr + '><td nowrap=nowrap style="border:none">' + text + '</td></tr>';
							return text;
						};
						if (typeof(value) == 'object') {
							if (value.hasOwnProperty('value')) {
								table += tr(value);
							} else {
								if (colCls !== '') {
									table += tr({
										value: value
									});
								} else {
									for (var i = 0; i < value.length; i++) {
										table += tr(value[i]);
									}
								}
							}
							if (table != '') {
								table = '<table class="datagrid-cell-table">' + table + '</table>';
							}
						} else {
							table = value;
						}
					}
					return table;
				}
				break;
			default:
				break;
		}
		if (String(column.frozen) == 'true') {
			frozenColumns.push(column);
		} else {
			columns.push(column);
		}
	});
	GV.ORDERSTEPWRAPLEFT = orderStepWrapLeft;
	return {
		columns: columns,
		frozenColumns: frozenColumns
	};
}
function tourGridOnLoadData(data) {
	var grid = $('#tourGrid');
	var rows = grid.datagrid('getRows');
	var table = $('table.datagrid-cell-table');
	var orderStepWrapLeft = GV.ORDERSTEPWRAPLEFT;
	table.each(function() {
	    var tb = $(this);
	    var field = tb.parent('div').parent('td').attr('field');
	    var index = tb.parent('div').parent('td').parent('tr').attr('datagrid-row-index');
	    if (!index) { return; }
	    var value = rows[index][field], trPopover = null;
	    if (value.hasOwnProperty('value')) {
		    if (value.hasOwnProperty('popover')) {
			    trPopover =rows[index][field].popover;
			}
			value =rows[index][field].value;
		}
		var bgColor = '#666', tdColor = '#fff';
	    var tr = tb.children('tbody').children('tr');
	    var trCls = tr.attr('class');
	    if (trCls) {
		    tr = tb.children('tbody').children('tr').children('td').children('div.' + trCls);
		    if (tr.children('div').length) {
				tr = tb.children('tbody').children('tr').children('td').children('div.' + trCls).children('div');
			}
		}
	    var position = 'right';
	    var popover = function(value, j) {
			var table = '';
			var popover = trPopover ? trPopover : value[j].popover;
			if (popover) {
				if (trCls == 'orderstep') {
					if (popover.length == 0) { return ''; }
					position = 'bottom';
					/* bgColor = '#fff', tdColor = '#666' */;
					var line = '';
					for (var i = 0; i < popover.length; i++) {
						if (!GV.TIMELINEWRAP) {
							var panelWidth = $('#tourGrid').parent().parent().parent().parent().width();
							var orderStepWrapOffset = panelWidth - (orderStepWrapLeft - panelWidth * .5);
							var testLine = '<div class="orderstep"><div class="orderstep_item"><div style="display:flex"><div class="splitline"></div><div style="margin:0px auto;text-align:center">'
							for (var j = 0; j < popover[i].length; j++) {
								var text = popover[i][j];
								testLine += '<p class="text"><span style="color:' + tdColor + '">' + text + '</span></p>';
							}
							testLine += '</div></div></div><div class="orderstep_item"><div style="display:flex"><div class="splitline"></div><div style="margin:0px auto;text-align:center"></div></div></div></div>';
							String.prototype.width = function(font) {
								var f = font || '12px arial', o = $('<div></div>')
								.html(this)
								.css({'position': 'absolute', 'float': 'left', 'white-space': 'nowrap', 'font': f, 'visibility': 'hidden', 'z-index': 10})
								.appendTo($('body')), w = o.width();
								o.remove();
								return w;
							};
							var testWidth = testLine.width();
							var k = 0;
							if (testWidth > 0) {
								if (orderStepWrapOffset > 0 && orderStepWrapOffset < panelWidth) {
									k = Math.floor(orderStepWrapOffset / testWidth);
								} else {
									k = Math.floor(panelWidth / testWidth - .5);
								}
								if (k < 1) { k = 1; }
							}
							GV.TIMELINEWRAP = k && !isNaN(k) ? k : 5;
						}
						if (i % GV.TIMELINEWRAP == 0) { line += '<div class="orderstep_item"><div style="display:flex"><div class="splitline"></div><div style="margin:0px auto;text-align:center"></div></div></div></div><div class="orderstep">'; }
						line += '<div class="orderstep_item"><div style="display:flex"><div class="splitline"></div><div style="margin:0px auto;text-align:center">';
						for (var j = 0; j < popover[i].length; j++) {
							var text = popover[i][j];
							line += '<p class="text"><span style="color:' + tdColor + '">' + text + '</span></p>';
						}
						line += '</div></div></div>';
					}
					line = '<div class="orderstep">' + line + '</div>';
					table += '<tr><td style="border:none">' + line + '</td></tr>';
				} else {
					for (var i = 0; i < popover.length; i++) {
						var id = popover[i].title;
						var text = popover[i].value;
						if (text == undefined) {
							text = '';
						}
						if (typeof(text) == 'object') {
							text = '';
							var cls = popover[i].class;
							var l = popover[i].value.length;
							if (l > 1) {
								if (cls == 'arcimdesc') {
									for (var k = 0; k < popover[i].value.length; k++) {
										text += '<div style="display:flex">'
										text += '<div><div class="left-bracket"></div><div class="right-bracket"></div></div>';
										text += '<div style="margin:5px 0 0 5px"><span style="color:' + tdColor + '">' + popover[i].value[k].value + '</span></div></div>';
									}
								}
							} else if (l == 1) {
								text += '<span style="color:' + tdColor + '">' + popover[i].value[0].value + '</span>';
							}
							if (cls != '') {
								text = '<div class="' + cls + '">' + text + '</div>';
							} else {
								text = '<div>' + text + '</div>';
							}
							table += '<tr><td nowrap=nowrap style="border:none"><span style="color:' + tdColor + '">' + id + '：</span></td><td style="border:none">' + text + '</td></tr>';
						} else {
							table += '<tr><td nowrap=nowrap style="border:none"><span style="color:' + tdColor + '">' + id + '：</span></td><td style="border:none"><span style="color:' + tdColor + '">' + text + '</span></td></tr>';
						}
					}
				}
			}
			if (table != '') {
				table = '<table class="datagrid-cell-table">' + table + '</table>';
			}
			return table;
		};
	    /// tip方式2选1
	    if (GV.TOOLTIP == 'tooltip') {
		    tr.each(function(j) {
			    var text =popover(value, j);
			    if (text == '') { return; }
			    $(this).tooltip({
				    position: position,
				    content: text,
				    onShow: function() {
					    var tip = $(this).tooltip('tip');
						tip.css({
							backgroundColor: bgColor,
							borderColor: bgColor
						});
						var top = tip.offset().top;
						var left = tip.offset().left;
						var width = tip.width();
						var height = tip.height();
						var clientWidth = $('#main').width();
						var clientHeight = $('#main').height();
						if (top + height > clientHeight) {
							top = Math.max(clientHeight - height, 150);
							if (left + width > clientWidth || clientWidth - left < 200) {
								left = Math.max(Math.min(clientWidth, left) - width - 150, 150);
							}
							tip.css('top', parseInt(top) + 'px');
							tip.css('left', parseInt(left) + 'px');
						} else if (left + width > clientWidth || clientWidth - left < 200) {
							left = Math.max(Math.min(clientWidth, left) - width - 150, 150);
							tip.css('top', parseInt(top) + 'px');
							tip.css('left', parseInt(left) + 'px');
						}
				    }
				});
			});
		} else if (GV.TOOLTIP == 'tips') {
			tr.each(function(j) {
			    var text = popover(value, j);
			    if (text == '') { return; }
			    text = '<div style="max-width:400px;word-break:break-all;word-wrap:break-word">' + text + '</div>';
				$(this).tips({
					content: text,
					style: {
						backgroundColor: bgColor,
						borderColor: bgColor,
						color: tdColor
					},
					wrapColor: tdColor
				});
			});
		}
	});
}
function pagerFilter(data) {
    if (typeof data.length == 'number' && typeof data.splice == 'function') {
        data = {
            total: data.length,
            rows: data
        }
    }
    var dg = $(this);
    var opts = dg.datagrid('options');
    var pager = dg.datagrid('getPager');
    pager.pagination({
        beforePageText: "页",
        afterPageText: "页，共{pages}页",
        displayMsg: "显示{from}到{to}，共{total}条记录",
        onSelectPage: function (pageNum, pageSize) {
            opts.pageNumber = pageNum;
            opts.pageSize = pageSize;
            pager.pagination('refresh', {
                pageNumber: pageNum,
                pageSize: pageSize
            });
            dg.datagrid('loadData', data);
        }
    });
    if (!data.originalRows) {
        data.originalRows = data.rows;
    	GV.ORIGINALROWS = data.rows;
    }
    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
    var end = start + parseInt(opts.pageSize);
    data.rows = (data.originalRows.slice(start, end));
    return data;
}
function setPatientInfo(EpisodeID) {
	$.m({
		ClassName: 'web.DHCDoc.OP.AjaxInterface',
		MethodName: 'GetOPInfoBar',
		CONTEXT: '',
		EpisodeID: EpisodeID
	}, function(html) {
		if (html != '') {
			$('.PatInfoItem').html(reservedToHtml(html));
		} else {
			$('.PatInfoItem').html($g('获取病人信息失败。请检查【患者信息展示】配置。'));
		}
	});
	function reservedToHtml(str) {
		var replacements = {
			'&lt;': '<',
			'&#60;': '<',
			'&gt;': '>',
			'&#62;': '>',
			'&quot;': '\"',
			'&#34;': '\"',
			'&apos;': '\'',
			'&#39;': '\'',
			'&amp;': '&',
			'&#38;': '&'
		};
		return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
			return replacements[v];
		});
	}
}
function ifPatBannerExist(id) {
	return parent && !parent.closed
			&& parent.document.getElementsByClassName(id)
			&& parent.document.getElementsByClassName(id).length;
}
function tourGridOnExportClick() {
	var tableToExcel = (function () {
		var uri = 'data:application/vnd.ms-excel;base64,',
		template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><?xml version="1.0" encoding="UTF-8" standalone="yes"?><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
		base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) },
		format = function (s, c) {
			var t = s; for (var p in c) { t = t.replace('{' + p + '}', c[p]); } return t;
		};
		return function (table, name) {
			if (!table.nodeType) table = document.getElementById(table);
			var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML };
			//window.location.href = uri + base64(format(template, ctx));
			var link = document.createElement('a')
	        link.setAttribute('href', uri + base64(format(template, ctx)))
	        link.setAttribute('download', name + '.xls')
	        link.click();
	        link = null;
		};
	})();
	var exportAsTable = function() {
		var data = GV.ORIGINALROWS;
		var columns = $('#tourGrid').datagrid('options').frozenColumns[0].concat(dg.datagrid('options').columns[0]);
		var dateStr = (PageFlag == 'S') ?
			($('#tourGridStartDate').datebox('getValue') + '_' + $('#tourGridEndDate').datebox('getValue'))
			: $('#tourGridDate').datebox('getValue');
		var fileName = PageTitle + '_' + dateStr;
		var th = '<tr>', tb = '';
		columns.forEach(function(column, columnIndex) {
			if (column.hidden) return;
			th += '<th>' + column.title + '</th>';
		});
		th += '</tr>';
		data.forEach(function(row, rowIndex) {
			var tr = '<tr style="mso-number-format:\'\@\';">';
			columns.forEach(function(column, columnIndex) {
				if (column.hidden) return;
				var value = '';
				if (row.hasOwnProperty(column.field)) {
					value = row[column.field];
					if (Object.prototype.toString.call(value) === '[object Array]') {
						var cells = value, value = '';
						cells.forEach(function(cell, cellIndex) {
							var span = '<span style="color:' + cell.color + '">' + cell.value + '</span>';
							value += (cellIndex > 0) ? ('<br>' + span) : span;
						});
					}
				}
				tr += '<td>' + value + '</td>';
			});
			tr += '</tr>';
			tb += tr;
		});
		var div = '<table id="exportAsTable">' + th + tb + '</table>';
		$(div).appendTo($('body'));
		tableToExcel('exportAsTable', fileName);
		$('#exportAsTable').remove();
	};
	var dg = $('#tourGrid');
	var data = GV.ORIGINALROWS;
	if (!data || !data.length) {
		$.messager.popover({ msg: '没有数据', type: 'alert', timeout: 5000 });
		return;
	}
	try {
		var oXL = new ActiveXObject('Excel.Application');
		var oWB = oXL.Workbooks.Add();
		var oSheet = oWB.ActiveSheet;
	} catch (e) {
		if (e.message.indexOf('ActiveXObject') > -1 || e.message.indexOf('Automation') > -1) exportAsTable();
		else $.messager.popover({ msg: '错误: '+ e.message, type: 'alert', timeout: 5000 });
		return;
	}
	var i = 1, j = 1;
	var columns = $('#tourGrid').datagrid('options').frozenColumns[0].concat(dg.datagrid('options').columns[0]);
	columns.forEach(function(column, columnIndex) {
		if (column.hidden) return;
		oSheet.Cells(i, j++).value = '\'' + column.title ;
	});
	data.forEach(function(row, rowIndex) {
		i++;
		columns.forEach(function(column, columnIndex) {
			if (column.hidden) return;
			var value = '';
			if (row.hasOwnProperty(column.field)) {
				value = row[column.field];
				if (Object.prototype.toString.call(value) === '[object Array]') {
					var cells = value, value = '';
					cells.forEach(function(cell, cellIndex) {
						var span = cell.value;
						value += (cellIndex > 0) ? (String.fromCharCode(10) + span) : span;
					});
				}
			}
			oSheet.Cells(i, j++).value = '\'' + value ;
		});
	});
	var dateStr = (PageFlag == 'S') ?
		($('#tourGridStartDate').datebox('getValue') + '_' + $('#tourGridEndDate').datebox('getValue'))
		: $('#tourGridDate').datebox('getValue');
	try {
		oXL.Visible = true;
		var fname = oXL.Application.GetSaveAsFilename("#(PageTitle)#" + '_' + dateStr, 'Excel Spreadsheets (*.xls), *.xls');
		oWB.SaveAs(fname);
		oWB.Close();
		oXL.Quit();
	} catch (e) {
		$.messager.popover({ msg: '错误: '+ e.message, type: 'alert', timeout: 5000 });
		return;
	}
}
