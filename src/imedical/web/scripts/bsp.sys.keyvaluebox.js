//==============模板提示组件===================================================================================================================
;(function ($) {
	//Functions
	function init(target){
		var t=$(target);
		var state=$.data(target,'templateprompt');
		var opts=state.options;


		var p = $("<div class=\"combo2-panel templateprompt-panel\" ></div>").appendTo("body");  //此控件想用于 值表达式下拉面板中  所以类使用 combo2-panel combo2-p 保证点击此面板不会隐藏其它面板
		p.panel({
			doSize: false, closed: true, cls: "combo2-p templateprompt-p", style: { position: "absolute", zIndex: 10 }, onOpen: function () {
				var p = $(this).panel("panel");
				if ($.fn.menu) {
					p.css("z-index", $.fn.menu.defaults.zIndex++);
				} else {
					if ($.fn.window) {
						p.css("z-index", $.fn.window.defaults.zIndex++);
					}
				}
				$(this).panel("resize");
			}
		});
		p.panel("resize",{width:opts.panelWidth,height:opts.panelHeight});
		state.panel=p;
		var table=$('<table class="templateprompt-panel-content-dg"></table>').appendTo(p);
		table.datagrid($.extend({},opts,{border: false, fit: true, singleSelect: true, onSelect: function (_909, row) {
					var t=this;
					setTimeout(function(){
						if (row){
							var str=$(target).val();
							var c=getCursorPosition(target); //获取光标所在位置
							//从光标位置往前找，找到${ 且未先找到}  
							var str1=str.substr(0,c);
							var str2=str.substr(c,str.length);
							if (str1.indexOf('${')>-1){
								var q=str1.split('${').pop();
								if (q.indexOf('}')==-1){
									var q2='';
									//从光标往后找 找到}或者& 且未先找到${
									if(str2.indexOf('}')>-1) {
										q2=str2.split('}')[0];
										if(q2.indexOf('${')>-1){
											q2='';
										}else{
											q2=q2+"}";
										}
									}
									if (q2==''&&　str2.indexOf('&')>-1){
										q2=str2.split('&')[0];
										if(q2.indexOf('${')>-1){
											q2='';
										}
									}
									
									str=str1.substr(0,str1.length-q.length)+row[opts.idField]+'}';
									var pos=str.length;
									str=str+str2.substr(q2.length,str2.length);
									$(target).val(str);
									setCursorPosition(target,pos);

								}
							}
							
						}
						if (opts.onSelect) opts.onSelect.call(t, _909, row);
						p.panel('close');
					},0)
	
				}}));
		state.grid=table;
		$(document).off(".templateprompt").on("mousedown.templateprompt", function (e) {
			var p = $(e.target).closest(".templateprompt,div.templateprompt-p");
			if (p.length) {
				return;
			}
			$("body>div.templateprompt-p>div.templateprompt-panel:visible").panel("close");
		});	
		t.unbind('.templateprompt');
		t.bind("keydown.templateprompt paste.templateprompt drop.templateprompt input.templateprompt", function (e) {
            if ("undefined" ==typeof e.keyCode){return ;}
            switch (e.keyCode) {
                case 38:
                    opts.keyHandler.up.call(target, e);
                    break;
                case 40:
                    opts.keyHandler.down.call(target, e);
                    break;
                case 37:
                    opts.keyHandler.left.call(target, e);
                    break;
                case 39:
                    opts.keyHandler.right.call(target, e);
                    break;
                case 13:
                    e.preventDefault();
                    opts.keyHandler.enter.call(target, e);
                    return false;
                case 9:
                case 27:
                    //_85e(target);
                    break;
                default:
                    if (true||opts.editable) {
                        if (state.timer) {
                            clearTimeout(state.timer);
                        }
                        state.timer = setTimeout(function () {
							var str = t.val();
							var c=getCursorPosition(t[0]); //获取光标所在位置
							//从光标位置往前找，找到${ 且未先找到}  即可弹出
							var str1=str.substr(0,c);
							if (str1.indexOf('${')>-1){
								var q=str1.split('${').pop();
								if (q.indexOf('}')==-1){
									showPanel(target);
									//-->showPanel
									if (state.previousValue != q) {
										state.previousValue = q;
										opts.keyHandler.query.call(target, q, e);
									}
									return;
								}
							}
							hidePanel(target);
							return;
                        }, opts.delay);
                    }
            }
        });
	}
	function getCursorPosition(target){
		var oTxt1 =target;
		var cursurPosition=-1;
		if(typeof oTxt1.selectionStart=='number'){//非IE浏览器
			cursurPosition= oTxt1.selectionStart;
		}else{//IE
			var range = document.selection.createRange();
			range.moveStart("character",-oTxt1.value.length);
			cursurPosition=range.text.length;
		}
		return cursurPosition;
	}
	function setCursorPosition(target,pos){
		if (target.setSelectionRange) {  
			target.focus();  
			setTimeout(function(){
				target.setSelectionRange (pos, pos);  
			},10);
            
        }else if (target.createTextRange) {  
            var range = target.createTextRange();  
            range.collapse(true);  
            range.moveEnd('character', pos);  
            range.moveStart('character', pos);  
            range.select();  
        } 
	}
	function hidePanel(target){
		var p = $.data(target, "templateprompt").panel;
		if (!p.panel("options").closed){
			p.panel('close');
		}
		
	}
	function showPanel(_860,onShowPanel) {
		var _861 = $.data(_860, "templateprompt");
		var opts = _861.options||{};
		var _862 = $(_860)
		var _863 = _861.panel;
		_863.panel("move", { left: _864(), top: _865() });
		if (_863.panel("options").closed) {
			_863.panel("open");
		   if (onShowPanel) onShowPanel.call(_860);
		}
		(function () {
			if (_863.is(":visible")) {
				_863.panel("move", { left: _864(), top: _865() });
				setTimeout(arguments.callee, 200);
			}
		})();
		function _864() {
			var left = _862.offset().left;
			if (opts.panelAlign == "right") {
				left += _862._outerWidth() - _863._outerWidth();
			}
			if (left + _863._outerWidth() > $(window)._outerWidth() + $(document).scrollLeft()) {
				left = $(window)._outerWidth() + $(document).scrollLeft() - _863._outerWidth();
			}
			if (left < 0) {
				left = 0;
			}
			return left;
		};
		function _865() {
			var top = _862.offset().top + _862._outerHeight()-1;
			if (top + _863._outerHeight() > $(window)._outerHeight() + $(document).scrollTop()) {
				top = _862.offset().top - _863._outerHeight();
			}
			if (top < $(document).scrollTop()) {
				top = _862.offset().top + _862._outerHeight()-1;
			}
			return top;
		};
	};
	function nav(_90d, dir) {
        var _90e = $.data(_90d, "templateprompt");
        var opts = _90e.options;
        var grid = _90e.grid;
        var _90f = grid.datagrid("getRows").length;
        if (!_90f) {
            return;
        }
        var tr = opts.finder.getTr(grid[0], null, "highlight");
        if (!tr.length) {
            tr = opts.finder.getTr(grid[0], null, "selected");
        }
        var _910;
        if (!tr.length) {
            _910 = (dir == "next" ? 0 : _90f - 1);
        } else {
            var _910 = parseInt(tr.attr("datagrid-row-index"));
            _910 += (dir == "next" ? 1 : -1);
            if (_910 < 0) {
                _910 = _90f - 1;
            }
            if (_910 >= _90f) {
                _910 = 0;
            }
        }
        grid.datagrid("highlightRow", _910);
        /*if (opts.selectOnNavigation) {
            _90e.remainText = false;
            grid.datagrid("selectRow", _910);
        }*/
	};
	function enter(_91e) {
        var _91f = $.data(_91e, "templateprompt");
        var opts = _91f.options;
        var grid = _91f.grid;
        var tr = opts.finder.getTr(grid[0], null, "highlight");
        _91f.remainText = false;
        if (tr.length) {
            var _920 = parseInt(tr.attr("datagrid-row-index"));
            if (opts.multiple) {
                if (tr.hasClass("datagrid-row-selected")) {
                    grid.datagrid("unselectRow", _920);
                } else {
                    grid.datagrid("selectRow", _920);
                }
            } else {
                grid.datagrid("selectRow", _920);
            }
		}
    };	
	function query(target,q){
        var state = $.data(target, "templateprompt");
        var opts = state.options;
        var grid = state.grid;

        if (opts.mode == "remote") {
            grid.datagrid("clearSelections");
            grid.datagrid("load", $.extend({}, opts.queryParams, { q: q }));
        } else {
            if (!q) {
                return;
            }
            grid.datagrid("clearSelections").datagrid("highlightRow", -1);
            var rows = grid.datagrid("getRows");
            var qq = opts.multiple ? q.split(opts.separator) : [q];
            $.map(qq, function (q) {
                q = $.trim(q);
                if (q) {
                    $.map(rows, function (row, i) {
                        if (q == row[opts.textField]) {
                            grid.datagrid("selectRow", i);
                        } else {
                            if (opts.filter.call(target, q, row)) {
                                grid.datagrid("highlightRow", i);
                            }
                        }
                    });
                }
            });
        }
	}
	function destroy(target){
		var state = $.data(target, "templateprompt");
        state.panel.panel("destroy");
        $(target).remove();
	}
    //入口
    $.fn.templateprompt = function (opts, param) {
        if (typeof opts == "string") {
            var fn = $.fn.templateprompt.methods[opts];
            return fn(this, param);
        }
        opts = opts || {};
        return this.each(function () {
            var state = $.data(this, "templateprompt");
            if (state) {
                $.extend(state.options, opts);
            } else {
                $.data(this, "templateprompt", { options: $.extend({}, $.fn.templateprompt.defaults, $.fn.templateprompt.parseOptions(this), opts) });
            }
			//然后去做初始化等
			init(this);
        });
    };
    //方法
    $.fn.templateprompt.methods = {
        options: function (jq) {
            return $.data(jq[0], "templateprompt").options;
        } , destroy: function (jq) {
            return jq.each(function () {
                destroy(this);
            });
        },clearPreviousValue:function(jq){  //增加清除前一次查询条件方法
            return jq.each(function () {
                var state = $.data(this, "templateprompt");
                if (state) {
	                state.previousValue=null;
	            }
            });
	    }
    };
    //解析配置项
    $.fn.templateprompt.parseOptions = function (target) {
	    var t=$(target);
        return $.extend({}, $.parser.parseOptions(target, [{ panelWidth: "number"}]),{ panelHeight: (t.attr("panelHeight") == "auto" ? "auto" : parseInt(t.attr("panelHeight")) || undefined)});
    };
    //默认配置项
    $.fn.templateprompt.defaults = $.extend({}, $.fn.datagrid.defaults,{ 
    	delay:200,
    	keyHandler: {
	        up: function (e) {
                nav(this, "prev");
                e.preventDefault();
            }, down: function (e) {
                nav(this, "next");
                e.preventDefault();
            }, left: function (e) {
	        }, right: function (e) {
	        }, enter: function (e) {
				e.preventDefault();
				enter(this);
	        }, query: function (q, e) {
				query(this,q);
	        }
		}, filter: function (q, row) {
            var opts = $(this).templateprompt("options");
            return row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) == 0;
        },lazy:false
    });
})(jQuery);

//为datagrid增加templateprompt类型编辑框
(function($){
	$.extend($.fn.datagrid.defaults.editors, {
		templateprompt: {
			init: function(container, options){
				var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container);
				input.templateprompt(options);
				return input;
			},
			destroy: function(target){
				$(target).templateprompt('destroy')
			},
			getValue: function(target){
				return $(target).val();
			},
			setValue: function(target, value){
				$(target).val(value);
			},
			resize: function(target, width){
				$(target)._outerWidth(width)._outerHeight(30);
			}
		}
	});
})(jQuery);

//==============模板提示组件 END===================================================================================================================


/**
 * 显示面板 initKeyValueBox initCombo2grid使用
 * @param {*} _860 dom元素
 * @param {*} onShowPanel 显示面板时调用方法
 */
function _85f(_860,onShowPanel) {
    var _861 = $.data(_860, "combo2");
    var opts = _861.options||{};
    var _862 = $(_860)
    var _863 = _861.panel;
    _863.panel("move", { left: _864(), top: _865() });
    if (_863.panel("options").closed) {
        _863.panel("open");
       if (onShowPanel) onShowPanel.call(_860);
    }
    (function () {
        if (_863.is(":visible")) {
            _863.panel("move", { left: _864(), top: _865() });
            setTimeout(arguments.callee, 200);
        }
    })();
    function _864() {
        var left = _862.offset().left;
        if (opts.panelAlign == "right") {
            left += _862._outerWidth() - _863._outerWidth();
        }
        if (left + _863._outerWidth() > $(window)._outerWidth() + $(document).scrollLeft()) {
            left = $(window)._outerWidth() + $(document).scrollLeft() - _863._outerWidth();
        }
        if (left < 0) {
            left = 0;
        }
        return left;
    };
    function _865() {
        var top = _862.offset().top + _862._outerHeight()-1;
        if (top + _863._outerHeight() > $(window)._outerHeight() + $(document).scrollTop()) {
            top = _862.offset().top - _863._outerHeight();
        }
        if (top < $(document).scrollTop()) {
            top = _862.offset().top + _862._outerHeight()-1;
        }
        return top;
    };
};

///加载CSS样式
function LoadStyleText(cssText){
	var style = document.createElement('style');
	style.type = 'text/css';
	style.innerHTML=cssText
	document.getElementsByTagName('head').item(0).appendChild(style);
}
/// 加载combo2样式
function LoadCombo2Css(size){
	size=size||30;
	LoadStyleText('		\
	.combo2-arrow{\
			display:inline-block;\
			width:'+(size-2)+'px;\
			height:'+(size-2)+'px;\
			margin-left:10px;\
			background:url(../images/uiimages/input-btn-expand.png)	no-repeat center center;\
			background-color:#abddff;\
			cursor:pointer;\
			border:1px solid #40a2de;\
			vertical-align:top;\
		}\
		.combo2-arrow.disabled{\
			border-color:#bbb;\
			background-color:#bbb;\
		}\
		.combo2-p>.combo2-panel {\
		    border-color: #9ed2f2;\
		}\
		.combo2-panel-content{\
			padding:10px;\
		}\
		.combo2-panel-buttons{\
			text-align:center;\
		}\
		.panel.combo2-p{\
			box-shadow: 0px 3px 3px 3px rgba(0, 0, 0, 0.1);\
		}\
		');
}


//==============创建键值录入框=======================================================================================================================
/**
 * 
 * @param {*} target dom元素
 * @param {*} opts 配置项
 */
function initKeyValueBox(target,opts){
	if (!opts.valueEditor) opts.valueEditor='text';
	$(target).width($(target).width()-40).addClass('combo2');
	var arrow=$('<span class="combo2-arrow"></span>').insertAfter(target);
    var p = $("<div class=\"combo2-panel\" ></div>").appendTo("body");
    p.panel({
        doSize: false, closed: true, cls: "combo2-p", style: { position: "absolute", zIndex: 10 }, onOpen: function () {
            var p = $(this).panel("panel");
            if ($.fn.menu) {
                p.css("z-index", $.fn.menu.defaults.zIndex++);
            } else {
                if ($.fn.window) {
                    p.css("z-index", $.fn.window.defaults.zIndex++);
                }
            }
            $(this).panel("resize");
        }
    });
    p.panel("resize",{width:opts.panelWidth,height:opts.panelHeight});
    $.data(target,'combo2',{panel:p});
    
    
    $(arrow).off('click.combo2').on('click.combo2',function(){
	    if($(this).hasClass('disabled')) return false;
	    if (opts.checkValue){
			if(opts.checkValue.call(target,$(target).val())===false){
				return ;
			}
		}
	    
	    _85f(target,function(){
		    var target=this;
			var all=opts.parseValue($(target).val());
			var table=$('<table class="combo2-panel-content-dg"></table>');
			
			$.data(target, "combo2").panel.find('.combo2-panel-content').empty().append(table);
			table.data('editindex','-1');
			table.datagrid({
				columns:[[
					{field:'key',title:opts.keyTitle||'参数名',width:200,editor:'text'},
					{field:'value',title:opts.valueTitle||'参数值',width:200,editor:opts.valueEditor},
					{field:'desc',title:opts.descTitle||'说明',width:150,editor:opts.descEditor,formatter:function(val,row,ind){
						if(row._readonly) {
							return val+ ' --'+(row._readonlyMsg||'禁止修改')
						}	
						return val;
					}}
				]],
				fit:true,
				data:all,
				rownumbers:true,
				bodyCls:'panel-header-gray',
				onClickRow:function(index,row){
					var editindex=$(this).data('editindex')
					if( editindex==index){
						$(this).datagrid('endEdit', index);
						editindex=-1;
					}else{
						if(editindex>-1) $(this).datagrid('endEdit', editindex);
						if( index==$(this).datagrid('getRows').length-1){  //只要点击最后一行 就新增一行
							$(this).datagrid('appendRow',{key:'',value:'',custom:true,desc:''});
						}
						$(this).datagrid('beginEdit', index);
						editindex=index;
						if (!row.custom){
							var et=$(this).datagrid('getEditor',{index:index,field:'key'}).target;
							$(et).attr('disabled','disabled');
						}
						if (row._readonly){  //只读行  禁止编辑
							var et=$(this).datagrid('getEditor',{index:index,field:'key'}).target;
							$(et).attr('disabled','disabled');
							var et2=$(this).datagrid('getEditor',{index:index,field:'value'}).target;
							$(et2).attr('disabled','disabled');
						}
					}
					$(this).data('editindex',editindex)
				},
				onAfterEdit:function(index,rowData){
					if( index==$(this).datagrid('getRows').length-1){  //最后一行
						if(rowData.key!="" && rowData.value!="" ){
							$(this).datagrid('appendRow',{key:'',value:'',custom:true,desc:''});
						}
					}
				}
				
			})
		});
	})
	$('<div class="combo2-panel-content"></div>').appendTo(p).outerHeight(opts.panelHeight-40-2);
	var buttons=$('<div class="combo2-panel-buttons"></div>').appendTo(p);
	var $okBtn=$('<a >确定</a>').appendTo(buttons).linkbutton({
		stopAllEventOnDisabled:true
	})
	$okBtn.off('click.combo2').on('click.combo2',function(){
		var table=p.find('.combo2-panel-content-dg');
		var editindex=table.data('editindex');
		if (editindex>-1) table.datagrid('endEdit',editindex);
		var rows=table.datagrid('getRows');
		
		var str=opts.formatValue(rows);
		
		$(target).val(str);
		
		p.panel('close');
	})
	var $cancelBtn=$('<a style="margin-left:15px;">取消</a>').appendTo(buttons).linkbutton({
		stopAllEventOnDisabled:true
	})
	$cancelBtn.off('click.combo2').on('click.combo2',function(){
		p.panel('close');
	})
	
    $(document).off(".combo2").on("mousedown.combo2", function (e) {
        var p = $(e.target).closest(".combo2,div.combo2-p");
        if (p.length) {
            return;
        }
        $("body>div.combo2-p>div.combo2-panel:visible").panel("close");
    });	
}
//==============创建键值录入框 END  =======================================================================================================================

//==============创建简单的列表选择框  =======================================================================================================================
/**
 * 
 * @param {*} target dom元素
 * @param {*} opts 配置项
 */
function initCombo2grid(target,opts){
	$(target).width($(target).width()-40).addClass('combo2');
	var arrow=$('<span class="combo2-arrow"></span>').insertAfter(target);
    var p = $("<div class=\"combo2-panel\" ></div>").appendTo("body");
    p.panel({
        doSize: false, closed: true, cls: "combo2-p", style: { position: "absolute", zIndex: 10 }, onOpen: function () {
            var p = $(this).panel("panel");
            if ($.fn.menu) {
                p.css("z-index", $.fn.menu.defaults.zIndex++);
            } else {
                if ($.fn.window) {
                    p.css("z-index", $.fn.window.defaults.zIndex++);
                }
            }
            $(this).panel("resize");
        }
    });
    p.panel("resize",{width:opts.panelWidth,height:opts.panelHeight});
    $.data(target,'combo2',{panel:p});
    var table=$('<table class="combo2-panel-content-dg"></table>').appendTo(p);
    table.datagrid($.extend({},opts,{border: false, fit: true, singleSelect: true, onSelect: function (_909, row) {
                var t=this;
                setTimeout(function(){
                    if (row){
	                    $(target).val(row[opts.idField]);
	                }
	                if (opts.onSelect) opts.onSelect.call(t, _909, row);
                    p.panel('close');
                },0)

            }}));
    

    $(arrow).off('click.combo2').on('click.combo2',function(){
	    if($(this).hasClass('disabled')) return false;
	    _85f(target,function(){
		    var target=this;
		    var p=$.data(target,'combo2').panel;
		    var table=p.find('.combo2-panel-content-dg');
		    var idField=table.datagrid('options').idField;
		    var value=$(target).val();
		    var rows=table.datagrid('getRows');
		    var tIdx=-1;
		    $.each(rows,function(idx){
			    if(this[idField]==value){
					tIdx=idx;
					return false;
				}
			})
			if (tIdx>-1){
				var tOnSelect=table.datagrid('options').onSelect;
				table.datagrid('options').onSelect=function(){};
				table.datagrid('selectRow',tIdx);
				table.datagrid('options').onSelect=tOnSelect;
			}
		    
		    
		    
		});
	})
    $(document).off(".combo2").on("mousedown.combo2", function (e) {
        var p = $(e.target).closest(".combo2,div.combo2-p");
        if (p.length) {
            return;
        }
        $("body>div.combo2-p>div.combo2-panel:visible").panel("close");
    });	
}
//==============创建简单的列表选择框 END =======================================================================================================================
