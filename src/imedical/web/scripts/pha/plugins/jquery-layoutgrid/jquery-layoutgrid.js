/**
 * 名称:   	 网格布局插件
 * 编写人:   Huxiaotian
 * 编写日期: 2020-04-04
 * js:		 scripts/pha/plugins/jquery-layoutgrid/jquery-layoutgrid.js
 * css:		 scripts/pha/plugins/jquery-layoutgrid/jquery-layoutgrid.css
 */
(function ($, window, document) {
	/*
	 * @插件调用入口
	 */
	$.fn.layoutgrid = function (method) {
		if (methods[method]) {
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		} else if (typeof method === 'object' || !method) {
			return methods.init.apply(this, arguments);
		} else {
			$.error('Method' + method + 'does not exist on jQuery.layoutgrid!!!');
		}
	};

	/*
	 * @方法集合
	 */
	var methods = {
		options: function () {
			var $this = this;
			return $this.data($this.selector.options);
		},
		add: function (options) {
			return this.each(function () {
				var rowIndex = parseInt(options.rowIndex);
				var colIndex = parseInt(options.colIndex);
				// 取用初始化参数
				var $this = $(this);
				var data = $this.data('layoutgrid');
				var initOptions = data.options;
				var colsWidth = initOptions.colsWidth;
				var cols = colsWidth.length;
				if (colIndex > cols - 1) {
					$.error('add error: rowIndex:' + rowIndex + ', colIndex:' + colIndex + ', 下标越界!!!');
					return;
				}
				var thisColWidthRate = colsWidth[colIndex];
				var thisColWidth = (initOptions.availableWidth - (initOptions.cellpadding * 2 * cols)) * thisColWidthRate;
				thisColWidth = parseInt(thisColWidth);
				var thisCellHeight = options.height || 10;
				var aSpeed = options.animateSpeed || initOptions.animateSpeed || 300;
				/*
				var cssObj = methods._getCssObject(options.cssText); // 解析CSS文本
				var borderLeftWidth = parseInt(cssObj['border-left']);
				var borderRightWidth = parseInt(cssObj['border-right']);
				if (isNaN(borderLeftWidth) == false) {
				thisColWidth = thisColWidth - borderLeftWidth; // 减去左边框
				}
				if (isNaN(borderRightWidth) == false) {
				thisColWidth = thisColWidth - borderRightWidth; // 减去右边框
				}
				 */
				// Cell最大宽高
				var cellMaxWidth = $this.css('width');
				var cellMaxHeight = $this.css('height');
				options.cellMaxWidth = parseInt(cellMaxWidth);
				options.cellMaxHeight = parseInt(cellMaxHeight);
				// 取ID
				var $thisId = data.id;
				var $thisCellId = (options.id && options.id != "") ? options.id : ($thisId + "-" + rowIndex + "-" + colIndex);

				// 显示布局
				if (initOptions.layoutMode == 'table') {
					// 1.表格式布局
					var trs = $this.children("table").children().children();
					var rows = trs.length;
					if (rowIndex >= rows) {
						var trStr = methods._getEmptyRows(rowIndex - rows + 1, cols, initOptions.cellpadding);
						$this.children("table").children().append(trStr);
						trs = $this.children("table").children().children();
					}
					var tr = trs.eq(rowIndex);
					var td = tr.children().eq(colIndex);

					if (options.panel) {
						// 添加外层DIV
						var _htmlStr = '<div style="width:' + thisColWidth + 'px;height:' + thisCellHeight + 'px;opacity:0;';
						if (options.cssText) {
							_htmlStr += options.cssText;
						}
						_htmlStr += '"';
						if (options.class) {
							_htmlStr += ' class="' + (options.class || '') + '"';
						}
						_htmlStr += '>'
						_htmlStr += '<div id="' + $thisCellId + '"></div>';
						_htmlStr += '</div>';
						td.html(_htmlStr);
						options.panel.fit = true;
						options.panel.width = thisColWidth;
						options.panel.height = thisCellHeight;
						$('#' + $thisCellId).panel(options.panel);
						// 动画显示
						$("#" + $thisCellId).parent().parent().animate({
							opacity: 1
						}, aSpeed, function () {
							options.onAddComplete && options.onAddComplete($thisCellId);
						});
					} else if (options.content) {
						// 外层DIV
						var _htmlStr = '<div id="' + $thisCellId + '" style="width:' + thisColWidth + 'px;height:' + thisCellHeight + 'px;opacity:0;';
						if (options.cssText) {
							_htmlStr += options.cssText;
						}
						_htmlStr += '"';
						if (options.class) {
							_htmlStr += ' class="' + (options.class || '') + '"';
						}
						_htmlStr += '>';
						_htmlStr += options.content;
						_htmlStr += '</div>';
						td.html(_htmlStr);
						// 动画显示
						$("#" + $thisCellId).animate({
							opacity: 1
						}, aSpeed, function () {
							options.onAddComplete && options.onAddComplete($thisCellId);
						});
					}
				} else {
					// 2.列式布局
					var curCol = $this.children().eq(0).children("div").eq(colIndex);
					var curColUl = curCol.children("ul").eq(0);
					var lis = curColUl.children();
					var rows = lis.length;
					if (rowIndex >= rows) {
						var liStr = methods._getEmptyLi(rowIndex - rows + 1, cols);
						curColUl.append(liStr);
						lis = $this.children().eq(0).children("div").eq(colIndex).children("ul").eq(0).children();
					}
					var li = lis.eq(rowIndex);
					if (rowIndex > 0) {
						li.css('margin-top', initOptions.cellpadding * 2); // todo...
					}

					if (options.panel) {
						// 添加外层DIV
						var _htmlStr = '<div style="width:' + thisColWidth + 'px;height:' + thisCellHeight + 'px;opacity:0;';
						if (options.cssText) {
							_htmlStr += options.cssText;
						}
						_htmlStr += '"';
						if (options.class) {
							_htmlStr += ' class="' + (options.class || '') + '"';
						}
						_htmlStr += '>'
						_htmlStr += '<div id="' + $thisCellId + '"></div>';
						_htmlStr += '</div>';
						li.html(_htmlStr);
						options.panel.fit = true;
						options.panel.width = thisColWidth;
						options.panel.height = thisCellHeight;
						$('#' + $thisCellId).panel(options.panel);
						// 动画显示
						$("#" + $thisCellId).parent().parent().animate({
							opacity: 1
						}, aSpeed, function () {
							options.onAddComplete && options.onAddComplete($thisCellId);
						});
					} else if (options.content) {
						// 外层DIV
						var _htmlStr = '<div id="' + $thisCellId + '" style="width:' + thisColWidth + 'px;height:' + thisCellHeight + 'px;opacity:0;';
						if (options.cssText) {
							_htmlStr += options.cssText;
						}
						_htmlStr += '"';
						if (options.class) {
							_htmlStr += ' class="' + (options.class || '') + '"';
						}
						_htmlStr += '>';
						_htmlStr += options.content;
						_htmlStr += '</div>';
						li.html(_htmlStr);
						// 动画显示
						$("#" + $thisCellId).animate({
							opacity: 1
						}, aSpeed, function () {
							options.onAddComplete && options.onAddComplete($thisCellId);
						});
					}
				}
				// 内容组件 todo...
				if (options.itemOptions) {
					methods._initComponent($thisCellId, options.itemOptions);
				}
				// 绑定改变大小事件
				if (options.resizable == true) {
					methods._initResizeEvent($thisCellId, options, initOptions);
				}
				// 绑定点击事件
				$("#" + $thisCellId).on('click', function (e) {
					if (initOptions.currentClickIsResize == true) {
						initOptions.currentClickIsResize = false;
						return;
					}
					var thisCell = $(this);
					if (initOptions.clickColor && initOptions.unClickColor) {
						// 当前点击的颜色
						$(this).css("background-color", initOptions.clickColor);
						// 其他未点击的颜色
						if (initOptions.layoutMode == 'table') {
							var tbody = thisCell.parent().parent().parent();
							var trs = tbody.children();
							for (var i = 0; i < trs.length; i++) {
								var tds = $(trs[i]).children();
								for (var j = 0; j < tds.length; j++) {
									var curCell = $(tds[j]).children().eq(0).not(thisCell).css('background-color', initOptions.unClickColor);
								}
							}
						} else {
							var tCol = thisCell.parent().parent().parent();
							methods._changeBackgroundColor({
								col: tCol,
								exceptJq: thisCell,
								unClickColor: initOptions.unClickColor
							});
							var oCol = tCol.siblings();
							for (var i = 0; i < oCol.length; i++) {
								methods._changeBackgroundColor({
									col: $(oCol[i]),
									exceptJq: thisCell,
									unClickColor: initOptions.unClickColor
								});
							}
						}
					}
					options.onClickCell && options.onClickCell(e, rowIndex, colIndex, $thisCellId, thisCell);
				});
				// 重置滚动条
				if ($thisId != "" && $('#' + $thisId).length > 0) {
					$('#' + $thisId).getNiceScroll().resize();
				}
			});
		},
		init: function (options) {
			// 记录当前ID
			if (this.selector.indexOf('#') != 0) {
				$.error('jQuery.layoutgrid插件当前只能使用id选择器实现!!!');
				return;
			}
			var $thisId = this.selector.replace("#", "");
			// 默认值
			var options = $.extend({
				layoutMode: 'table', // table or col, 默认为table
				layoutAlign: 'center', // left / center / right, 默认是left, 该属性只有在 fit!=true && 宽度没有布满父容器的时候
				fit: false, // 与width & height只有一个有效
				height: 100, // 宽
				width: 100, // 高
				cellpadding: 5, // grid之间的间隔
				forceLoad: false,
				borderTopWidth: 0,
				borderRightWidth: 0,
				borderBottomWidth: 0,
				borderLeftWidth: 0,
				paddingLeft: 0,
				paddingRight: 0,
				paddingBottom: 0,
				paddingLeft: 0,
				marginTop: 0,
				marginRight: 0,
				marginBottom: 0,
				marginLeft: 0
			}, options);

			return this.each(function () {
				var $this = $(this);
				var data = $this.data('layoutgrid');
				if (!data || options.forceLoad == true) {
					if (options.borderTop) {
						$this.css('border-top', options.borderTop);
						var bWidth = parseInt(options.borderTop);
						if (isNaN(bWidth) == false) {
							options.borderTopWidth = bWidth;
						}
					}
					if (options.borderRight) {
						$this.css('border-right', options.borderRight);
						var bWidth = parseInt(options.borderRight);
						if (isNaN(bWidth) == false) {
							options.borderRightWidth = bWidth;
						}
					}
					if (options.borderBottom) {
						$this.css('border-bottom', options.borderBottom);
						var bWidth = parseInt(options.borderBottom);
						if (isNaN(bWidth) == false) {
							options.borderBottomWidth = bWidth;
						}
					}
					if (options.borderLeft) {
						$this.css('border-left', options.borderLeft);
						var bWidth = parseInt(options.borderLeft);
						if (isNaN(bWidth) == false) {
							options.borderLeftWidth = bWidth;
						}
					}
					if (options.padding) {
						$this.css('padding', options.padding);
						// 按上右下左的顺序记录
						var paddingArr = options.padding.split(' ');
						var bWidth = parseInt(paddingArr[0]);
						if (isNaN(bWidth) == false) {
							options.paddingTop = bWidth;
						}
						var bWidth = parseInt(paddingArr[1]);
						if (isNaN(bWidth) == false) {
							options.paddingRight = bWidth;
						}
						var bWidth = parseInt(paddingArr[2]);
						if (isNaN(bWidth) == false) {
							options.paddingBottom = bWidth;
						}
						var bWidth = parseInt(paddingArr[3]);
						if (isNaN(bWidth) == false) {
							options.paddingLeft = bWidth;
						}
					}
					if (options.margin) {
						$this.css('margin', options.margin);
						// 按上右下左的顺序记录
						var marginArr = options.margin.split(' ');
						var bWidth = parseInt(marginArr[0]);
						if (isNaN(bWidth) == false) {
							options.marginTop = bWidth;
						}
						var bWidth = parseInt(marginArr[1]);
						if (isNaN(bWidth) == false) {
							options.marginRight = bWidth;
						}
						var bWidth = parseInt(marginArr[2]);
						if (isNaN(bWidth) == false) {
							options.marginBottom = bWidth;
						}
						var bWidth = parseInt(marginArr[3]);
						if (isNaN(bWidth) == false) {
							options.marginLeft = bWidth;
						}
					}

					// 创建表格
					var layoutMode = options.layoutMode;
					var layoutAlign = options.layoutAlign;
					var cellpadding = options.cellpadding;
					var colsWidth = options.colsWidth;
					var cols = colsWidth.length;
					// 修改表格样式
					var width = options.width;
					var height = options.height;
					var pWidth = $this.parent().css('width') || options.width || $(document).width();
					var pHeight = $this.parent().css('height') || options.height || $(document).height();
					if (options.fit == true) {
						width = parseInt(pWidth);
						height = parseInt(pHeight);
					}
					var unavailableWidth = options.marginRight + options.marginLeft + options.paddingRight + options.paddingLeft + options.borderLeftWidth + options.borderRightWidth + methods._calcAddUnavaWidth(cols);
					var availableWidth = width - unavailableWidth;
					var unavailableHeight = options.marginTop + options.marginBottom + options.paddingTop + options.paddingBottom + options.borderTopWidth + options.borderBottomWidth;
					var availableHeight = height - unavailableHeight;
					$this.css('width', availableWidth);
					$this.css('height', availableHeight);
					$this.addClass('layoutgrid_noscroll'); //去掉原滚动条
					// 记录参数
					options.width = width;
					options.height = height;
					options.unavailableWidth = unavailableWidth;
					options.availableWidth = availableWidth;
					options.unavailableHeight = unavailableHeight;
					options.availableHeight = availableHeight;

					// 开始布局
					var _htmlStr = "";
					if (options.html && options.html != '') {
						_htmlStr = options.html;
					} else {
						if (layoutMode == 'table') {
							// 表格式布局
							_htmlStr += '<table border="0" cellspacing="0" cellpadding="0"';
							_htmlStr += layoutAlign == 'center' ? ' class="layoutgrid_center"' : ' style="float:' + layoutAlign + ';"';
							_htmlStr += '>';
							_htmlStr += '<tr>';
							for (var c = 0; c < cols; c++) {
								_htmlStr += '<td style="padding:' + (
									(c == cols - 1)
									 ? (cellpadding + 'px ' + cellpadding + 'px ' + cellpadding + 'px ' + cellpadding + 'px;')
									 : (cellpadding + 'px;')) + '"></td>';
							}
							_htmlStr += '</tr>';
							_htmlStr += '</table>';
							// 滚动加载事件
							$this.scroll(function (e) {
								var scrollTop = $this.scrollTop();
								var scrollHeight = $this.children().eq(0)[0].scrollHeight;
								var windowHeight = $this.height();
								if (Math.abs(scrollTop + windowHeight - scrollHeight) < 1) {
									options.onScrollEnd && options.onScrollEnd(e);
								}
							});
						} else {
							// 列式布局
							var colsWidth = options.colsWidth;
							_htmlStr += '<div';
							_htmlStr += layoutAlign == 'center' ? ' style="overflow:auto;width:' + options.availableWidth + 'px;" class="layoutgrid_center"' : ' style="float:' + layoutAlign + ';"';
							_htmlStr += '>'
							for (var c = 0; c < cols; c++) {
								var thisColWidthRate = colsWidth[c];
								var thisColWidth = (options.availableWidth - (options.cellpadding * 2 * cols)) * thisColWidthRate; // 滚动条的位置留5
								thisColWidth = parseInt(thisColWidth);
								_htmlStr += '<div style="float:left;width:' + thisColWidth + 'px;padding:' + cellpadding + 'px;">';
								_htmlStr += '<ul class="layoutgrid_ul"></ul>';
								_htmlStr += '</div>';
							}
							_htmlStr += '</ul>'
							// 滚动加载事件
							$this.scroll(function (e) {
								var scrollTop = $this.scrollTop();
								var scrollHeightArr = [];
								$this.children().each(function () {
									scrollHeightArr.push($(this)[0].scrollHeight);
								});
								var maxScrollHeight = Math.max.apply(null, scrollHeightArr);
								var windowHeight = $this.height();
								if (Math.abs(scrollTop + windowHeight - maxScrollHeight) < 1) {
									options.onScrollEnd && options.onScrollEnd(e);
								}
							});
						}
					}
					// 添加内容
					$this.html(_htmlStr);
					// 数据绑定
					$(this).data('layoutgrid', {
						target: $this,
						options: options,
						id: $thisId
					});
					// 滚动条美化
					if ($('#' + $thisId).length > 0) {
						if (options.showScroll != true) {
							// $('#' + $thisId).niceScroll({cursoropacitymax: 0}); // 导致外层无法滚动. Huxt 2022-09-16
						} else {
							$('#' + $thisId).niceScroll();
						}
					}
					// 最后添加cells
					if (options.cells) {
						var ceilLen = options.cells.length;
						for (var i = 0; i < ceilLen; i++) {
							$this.layoutgrid('add', options.cells[i]);
						}
					}
				}
			});
		},

		/*
		 * @desc: 以下为私有方法
		 */
		_getEmptyRows: function (_rows, _cols, _cellpadding) {
			var trStr = "";
			for (var r = 0; r < _rows; r++) {
				trStr += '<tr>';
				for (var c = 0; c < _cols; c++) {

					trStr += '<td style="padding:' + (
						(c == _cols - 1)
						 ? (_cellpadding + 'px ' + _cellpadding + 'px ' + _cellpadding + 'px ' + _cellpadding + 'px;')
						 : (_cellpadding + 'px;')) + '"></td>';
				}
				trStr += '</tr>';
			}
			return trStr;
		},
		_getEmptyLi: function (_rows, _cols) {
			var liStr = "";
			for (var r = 0; r < _rows; r++) {
				liStr += '<li class="layoutgrid_li"></li>';
			}
			return liStr;
		},
		// todo...
		_initComponent: function ($thisCellId, comOptions) {
			var componentArr = ['datagrid', 'panel'];
			var itemId = comOptions.id || "";
			var itemType = comOptions.type || "";
			if (itemId == '') {
				return;
			}
			if (componentArr.indexOf(itemType) < 0) {
				return;
			}
			//
			if (itemType == 'datagrid') {
				$("#" + $thisCellId).html('<div id="' + itemId + '"></div>'); // or use append()???
				$("#" + itemId).datagrid(comOptions);
			} else if (itemType == 'panel') {
				$("#" + itemId).panel(comOptions);
			}
			return;
		},
		// 绑定改变大小
		_initResizeEvent: function ($thisCellId, options, initOptions) {
			var startHeight = null;
			var startWidth = null;
			var _handles = 's,e';
			$('#' + $thisCellId).resizable({
				handles: _handles,
				maxWidth: options.cellMaxWidth,
				minWidth: 10,
				maxHeight: options.cellMaxHeight,
				minHeight: 10,
				onStartResize: function (e) {
					startHeight = parseInt($(this).css('height'));
					startWidth = parseInt($(this).css('width'));
				},
				onResize: function (e) {
					initOptions.currentClickIsResize = true;
					if (initOptions.layoutMode == 'table') {
						if (e.data.dir == "s") {
							// 改变同一行的高度
							var thisTdHeight = $(this).css('height');
							var td = $(this).parent();
							var rowOtherTd = $(td).siblings();
							for (var i = 0; i < rowOtherTd.length; i++) {
								$(rowOtherTd[i]).children().eq(0).css('height', thisTdHeight);
							}
							// 改变相邻行的高度
							var hDiff = parseInt(thisTdHeight) - startHeight;
							startHeight = parseInt(thisTdHeight);
							var thisTr = $(td).parent('tr');
							var nextTr = $(thisTr).next();
							var nextRowTd = $(nextTr[0]).children();
							for (var i = 0; i < nextRowTd.length; i++) {
								var nextOneTdDiv = $(nextRowTd[i]).children();
								var nextOneTdDivHeight = parseInt($(nextOneTdDiv).css('height'));
								$(nextOneTdDiv[0]).css('height', nextOneTdDivHeight - hDiff);
							}
						} else {
							// 改变同一列的宽度
							var td = $(this).parent();
							var thisColIndex = $(td).parent('tr').find('td').index($(td));
							var thisTdWidth = $(this).css('width');
							var tr = $(this).parent().parent();
							var colOtherTr = $(tr).siblings();
							for (var i = 0; i < colOtherTr.length; i++) {
								var oneTd = $(colOtherTr[i]).children().eq(thisColIndex);
								var oneTdDiv = $(oneTd).children();
								$(oneTdDiv[0]).css('width', thisTdWidth);
							}
							// 改变相邻列的宽度
							var wDiff = parseInt(thisTdWidth) - startWidth;
							startWidth = parseInt(thisTdWidth);
							var allTr = $(this).parent().parent().parent().children();
							for (var i = 0; i < allTr.length; i++) {
								var oneTd = $(allTr[i]).children().eq(thisColIndex + 1);
								var oneTdDiv = $(oneTd).children();
								var oneTdDivWidth = parseInt($(oneTdDiv).css('width'));
								$(oneTdDiv[0]).css('width', oneTdDivWidth - wDiff);
							}
						}
					} else {
						if (e.data.dir == "s") {
							// 不操作
						} else {
							// 改变同一列的宽度
							var thisLiWidth = $(this).css('width');
							var _ul = $(this).parent().parent();
							var _lis = _ul.children();
							for (var i = 0; i < _lis.length; i++) {
								$(_lis[i]).children().eq(0).css('width', thisLiWidth);
							}
							// 改变相邻列的宽度
							var wDiff = parseInt(thisLiWidth) - startWidth;
							startWidth = parseInt(thisLiWidth);
							_ul.parent().css('width', parseInt(_ul.parent().css('width')) + wDiff);
							_ul.parent().next().css('width', parseInt(_ul.parent().next().css('width')) - wDiff);
							var _nextLis = _ul.parent().next().children().eq(0).children();
							for (var i = 0; i < _nextLis.length; i++) {
								var _nextLiWidth = $(_nextLis[i]).children().eq(0).css('width');
								$(_nextLis[i]).children().eq(0).css('width', parseInt(_nextLiWidth) - wDiff);
							}
						}
					}
				},
				onStopResize: function (e) {
					options.onStopResize && options.onStopResize(this);
				}
			});
		},
		// 改变其他的颜色
		_changeBackgroundColor: function (_options) {
			var col = _options.col;
			var exceptJq = _options.exceptJq;
			var _lis = col.children().eq(0).children();
			for (var i = 0; i < _lis.length; i++) {
				$(_lis[i]).children().eq(0).not(exceptJq).css('background-color', _options.unClickColor)
			}
		},
		// 显示的动画 -- 暂时不用了
		_showAnimate: function (jqDiv, _options, _fn) {
			if (_options.type == 'show') {
				jqDiv.show(_options.speed, _fn);
			} else if (_options.type == 'slideDown') {
				jqDiv.slideDown(_options.speed, _fn);
			} else if (_options.type == 'fadeIn') {
				jqDiv.fadeIn(_options.speed, _fn);
			} else {
				jqDiv.animate(_options.animate, _options.speed, _fn).css('display', 'block');
			}
		},
		// style字符串解析
		_getCssObject: function (_cssText) {
			var _retCssObj = {};
			if (_cssText) {
				var _cssArr = _cssText.split(';');
				var _cssLen = _cssArr.length;
				for (var i = 0; i < _cssLen; i++) {
					var _oneCssText = _cssArr[i];
					_oneCssText = $.trim(_oneCssText);
					if (_oneCssText == '' || _oneCssText.indexOf(':') < 0) {
						continue;
					}
					var _oneCssTextArr = _oneCssText.split(':');
					var _k = $.trim(_oneCssTextArr[0]);
					var _v = $.trim(_oneCssTextArr[1]);
					if (_k == '' || _v == '') {
						continue;
					}
					_retCssObj[_k] = _v;
				}
			}
			return _retCssObj;
		},
		// UI改造,布局宽度有点问题
		_calcAddUnavaWidth: function (cols) {
			if (cols == 1) {
				return 1;
			}
			return (cols - 1) * 2;
		}
	}
})(jQuery, window, document);
