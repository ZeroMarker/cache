﻿//下拉单选
(function ($) {
    function getRadioId(comboboxId,val)
    {
        return comboboxId + "_" + val;
    }
    function getRadioname(comboboxId) {
        return comboboxId + "_name";
    }
    var methods = {
        init: function (options) {
            var defaults = {
                required: false,
               // editable: false,
                Onchange: null,
               // multiple: false
                //   , valueField: "id"
                //  , textField: "text"
            }
            var endOptions = $.extend(defaults, options);
            this.each(function () {
                var _this = $(this);
                var id = _this.attr("id");
                $(_this).combobox({
                    valueField: endOptions.valueField,
                    textField: endOptions.textField,
                    multiple: false,
                    allowNull:true,
                    selectOnNavigation: false,
                    anelHeight: "auto",
                    editable: endOptions.editable,
                    required: endOptions.required,
                    data: endOptions.data,
                    formatter: function (row) {
                        var opts;
                        var val = row[endOptions.valueField];
                        var text = row[endOptions.textField];
                        var RadioId = getRadioId(id, val);
                        var Radioname = getRadioname(id);
                        if (row.selected == true) {
                            opts = "<input style='height:13px' type='radio' checked='checked' id='" + RadioId + "' name='" + Radioname + "' value='" + val + "'>" + text;
                        } else {
                            opts = "<input style='height:13px' type='radio' id='" + RadioId + "' name='" + Radioname + "' value='" + val + "'>" + text;
                        }
                        return opts;
                    },
                    onSelect: function (rec) {
						if(rec)
						{ 				
							  var val = rec[endOptions.valueField];
                        var RadioId = getRadioId(id, val);                  
                        $("#" + RadioId).prop('checked', true);
                        if (endOptions.Onchange) {
                            endOptions.Onchange(rec);
                        }
						}
                      
                    }, onUnselect: function (rec) {
                        var val = rec[endOptions.valueField];
                        var RadioId = getRadioId(id, val);                 
                        $("#" + RadioId).prop('checked', false);
                      /*  if (endOptions.Onchange) {
                            endOptions.Onchange(false, rec);
                        }*/
                    }
                });
            });
        },
        enable: function (isenable) {
            var _this = $(this);
            if (isenable) {
                $(_this).combobox("enable");
            }
            else {
                $(_this).combobox("disable");
            }
        },
        disable: function (isenable) {
            var _this = $(this);
            if (isenable) {
                $(_this).combobox("disable");
            }
            else {
                $(_this).combobox("enable");
            }
        },
        setValue: function (vals) {
            var _this = $(this);
            var id = _this.attr("id");
            $(_this).combobox("setValue", vals);        
            var RadioId = getRadioId(id, vals);        
            $("#" + RadioId).prop('checked', true);
			 var itemselect=null;
			 	var valueField=$(_this).combobox('options').valueField;
                  for (var i = 0; i < datas.length; i++)
				{
					if(datas[i][valueField]==vals[0])
					{
						itemselect=datas[i];
						break;
					}
				}
				if(itemselect!=null)
				 $(_this).combobox('options').onSelect.call($('#' + id)[0], itemselect);
 
        },
        setValues: function (vals) {
            var _this = $(this);
            var id = _this.attr("id");//单选只能选择一个，
            if (vals.length > 0) {
                var tempval = vals[0];
                $(_this).combobox("setValue", tempval);
                var RadioId = getRadioId(id, tempval);
                $("#" +RadioId).prop('checked', true);				
				var datas=$(_this).combobox("getData");
				var itemselect=null;
				var valueField=$(_this).combobox('options').valueField;
                  for (var i = 0; i < datas.length; i++)
				{
					if(datas[i][valueField]==vals[0])
					{
						itemselect=datas[i];
						break;
					}
				}			
				if(itemselect!=null)
				 $(_this).combobox('options').onSelect.call($('#' + id)[0], itemselect);
            }
             
        },
        loadData: function (data) {
            var _this = $(this);
            $(_this).combobox("loadData", data);
        },
        options: function () {
            var _this = $(this);
            return $(_this).combobox("options");
        },
        getValue: function () {
            var _this = $(this);
            var re = $(_this).combobox("getValue");
            return re == undefined ? "" : re;
        },
        getValues: function () {
            var _this = $(this);
            var re = $(_this).combobox("getValues");
            return re == undefined ? [] : re;
        },
        getData: function () {
            var _this = $(this);
            var re = $(_this).combobox("getData");
            return re == undefined ? [] : re;
        }
    };

    $.fn.DropDropRadio = function (method) {
        // 方法调用
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof method === 'object' || !method) {
            return methods.init.apply(this, arguments);
        } else {
            $.error('Method ' + method + 'does not exist on mutiselect.js');
        }
    };
})(jQuery);

//重写 hisui datagrid 
(function ($) {
    var _501 = 0;
    function _502(a, o) {
        for (var i = 0, len = a.length; i < len; i++) {
            if (a[i] == o) {
                return i;
            }
        }
        return -1;
    };
    function _503(a, o, id) {
        if (typeof o == "string") {
            for (var i = 0, len = a.length; i < len; i++) {
                if (a[i][o] == id) {
                    a.splice(i, 1);
                    return;
                }
            }
        } else {
            var _504 = _502(a, o);
            if (_504 != -1) {
                a.splice(_504, 1);
            }
        }
    };
    function _505(a, o, r) {
        for (var i = 0, len = a.length; i < len; i++) {
            if (a[i][o] == r[o]) {
                return;
            }
        }
        a.push(r);
    };
    function _506(_507) {
        var _508 = $.data(_507, "datagrid");
        var opts = _508.options;
        var _509 = _508.panel;
        var dc = _508.dc;
        var ss = null;
        if (opts.sharedStyleSheet) {
            ss = typeof opts.sharedStyleSheet == "boolean" ? "head" : opts.sharedStyleSheet;
        } else {
            ss = _509.closest("div.datagrid-view");
            if (!ss.length) {
                ss = dc.view;
            }
        }
        var cc = $(ss);
        var _50a = $.data(cc[0], "ss");
        if (!_50a) {
            _50a = $.data(cc[0], "ss", { cache: {}, dirty: [] });
        }
        return {
            add: function (_50b) {
                var ss = ["<style type=\"text/css\" hisui=\"true\">"];
                for (var i = 0; i < _50b.length; i++) {
                    _50a.cache[_50b[i][0]] = { width: _50b[i][1] };
                }
                var _50c = 0;
                for (var s in _50a.cache) {
                    var item = _50a.cache[s];
                    item.index = _50c++;
                    ss.push(s + "{width:" + item.width + "}");
                }
                ss.push("</style>");
                $(ss.join("\n")).appendTo(cc);
                cc.children("style[hisui]:not(:last)").remove();
            }, getRule: function (_50d) {
                var _50e = cc.children("style[hisui]:last")[0];
                var _50f = _50e.styleSheet ? _50e.styleSheet : (_50e.sheet || document.styleSheets[document.styleSheets.length - 1]);
                var _510 = _50f.cssRules || _50f.rules;
                return _510[_50d];
            }, set: function (_511, _512) {
                var item = _50a.cache[_511];
                if (item) {
                    item.width = _512;
                    var rule = this.getRule(item.index);
                    if (rule) {
                        rule.style["width"] = _512;
                    }
                }
            }, remove: function (_513) {
                var tmp = [];
                for (var s in _50a.cache) {
                    if (s.indexOf(_513) == -1) {
                        tmp.push([s, _50a.cache[s].width]);
                    }
                }
                _50a.cache = {};
                this.add(tmp);
            }, dirty: function (_514) {
                if (_514) {
                    _50a.dirty.push(_514);
                }
            }, clean: function () {
                for (var i = 0; i < _50a.dirty.length; i++) {
                    this.remove(_50a.dirty[i]);
                }
                _50a.dirty = [];
            }
        };
    };
    function _515(_516, _517) {
        var opts = $.data(_516, "datagrid").options;
        var _518 = $.data(_516, "datagrid").panel;
        if (_517) {
            if (_517.width) {
                opts.width = _517.width;
            }
            if (_517.height) {
                opts.height = _517.height;
            }
        }
        if (opts.fit == true) {
            var p = _518.panel("panel").parent();
            opts.width = p.width();
            opts.height = p.height();
        }
        _518.panel("resize", { width: opts.width, height: opts.height });
    };
    function _519(_51a) {
        var opts = $.data(_51a, "datagrid").options;
        var dc = $.data(_51a, "datagrid").dc;
        var wrap = $.data(_51a, "datagrid").panel;
        var _51b = wrap.width();
        var _51c = wrap.height();
        var view = dc.view;
        var _51d = dc.view1;
        var _51e = dc.view2;
        var _51f = _51d.children("div.datagrid-header");
        var _520 = _51e.children("div.datagrid-header");
        var _521 = _51f.find("table");
        var _522 = _520.find("table");
        view.width(_51b);
        var _523 = _51f.children("div.datagrid-header-inner").show();
        //console.log("rownumber-数字列的宽");
        //console.log(_523.find("table").width());
        _51d.width(_523.find("table").width());
        if (!opts.showHeader) {
            _523.hide();
        }
        _51e.width(_51b - _51d._outerWidth());
        _51d.children("div.datagrid-header,div.datagrid-body,div.datagrid-footer").width(_51d.width());
        _51e.children("div.datagrid-header,div.datagrid-body,div.datagrid-footer").width(_51e.width());
        var hh;
        _51f.css("height", "");
        _520.css("height", "");
        _521.css("height", "");
        _522.css("height", "");
        hh = Math.max(_521.height(), _522.height());
        _521.height(hh);
        _522.height(hh);
        _51f.add(_520)._outerHeight(hh);
        if (opts.height != "auto") {
            var _524 = _51c - _51e.children("div.datagrid-header")._outerHeight() - _51e.children("div.datagrid-footer")._outerHeight() - wrap.children("div.datagrid-toolbar")._outerHeight() - wrap.children("div.datagrid-btoolbar")._outerHeight();
            wrap.children("div.datagrid-pager").each(function () {
                _524 -= $(this)._outerHeight();
            });
            dc.body1.add(dc.body2).children("table.datagrid-btable-frozen").css({ position: "absolute", top: dc.header2._outerHeight() });
            var _525 = dc.body2.children("table.datagrid-btable-frozen")._outerHeight();
            _51d.add(_51e).children("div.datagrid-body").css({ marginTop: _525, height: (_524 - _525) });
        }
        view.height(_51e.height());
    };
    function _526(_527, _528, _529) {
        var rows = $.data(_527, "datagrid").data.rows;
        var opts = $.data(_527, "datagrid").options;
        var dc = $.data(_527, "datagrid").dc;
        if (!dc.body1.is(":empty") && (!opts.nowrap || opts.autoRowHeight || _529)) {
            if (_528 != undefined) {
                var tr1 = opts.finder.getTr(_527, _528, "body", 1);
                var tr2 = opts.finder.getTr(_527, _528, "body", 2);
                _52a(tr1, tr2);
            } else {
                var tr1 = opts.finder.getTr(_527, 0, "allbody", 1);
                var tr2 = opts.finder.getTr(_527, 0, "allbody", 2);
                _52a(tr1, tr2);
                if (opts.showFooter) {
                    var tr1 = opts.finder.getTr(_527, 0, "allfooter", 1);
                    var tr2 = opts.finder.getTr(_527, 0, "allfooter", 2);
                    _52a(tr1, tr2);
                }
            }
        }
        _519(_527);
        if (opts.height == "auto") {
            var _52b = dc.body1.parent();
            var _52c = dc.body2;
            var _52d = _52e(_52c);
            var _52f = _52d.height;
            if (_52d.width > _52c.width()) {
                _52f += 18;
            }
            _52b.height(_52f);
            _52c.height(_52f);
            dc.view.height(dc.view2.height());
        }
        dc.body2.triggerHandler("scroll");
        function _52a(trs1, trs2) {
            for (var i = 0; i < trs2.length; i++) {
                var tr1 = $(trs1[i]);
                var tr2 = $(trs2[i]);
                tr1.css("height", "");
                tr2.css("height", "");
                var _530 = Math.max(tr1.height(), tr2.height());
                tr1.css("height", _530);
                tr2.css("height", _530);
            }
        };
        function _52e(cc) {
            var _531 = 0;
            var _532 = 0;
            $(cc).children().each(function () {
                var c = $(this);
                if (c.is(":visible")) {
                    _532 += c._outerHeight();
                    if (_531 < c._outerWidth()) {
                        _531 = c._outerWidth();
                    }
                }
            });
            return { width: _531, height: _532 };
        };
    };
    function _533(_534, _535) {
        var _536 = $.data(_534, "datagrid");
        var opts = _536.options;
        var dc = _536.dc;
        if (!dc.body2.children("table.datagrid-btable-frozen").length) {
            dc.body1.add(dc.body2).prepend("<table class=\"datagrid-btable datagrid-btable-frozen\" cellspacing=\"0\" cellpadding=\"0\"></table>");
        }
        _537(true);
        _537(false);
        _519(_534);
        function _537(_538) {
            var _539 = _538 ? 1 : 2;
            var tr = opts.finder.getTr(_534, _535, "body", _539);
            (_538 ? dc.body1 : dc.body2).children("table.datagrid-btable-frozen").append(tr);
        };
    };
    function _53a(_53b, _53c) {
        function _53d() {
            var _53e = [];
            var _53f = [];
            $(_53b).children("thead").each(function () {
                var opt = $.parser.parseOptions(this, [{ frozen: "boolean" }]);
                $(this).find("tr").each(function () {
                    var cols = [];
                    $(this).find("th").each(function () {
                        var th = $(this);
                        var col = $.extend({}, $.parser.parseOptions(this, ["field", "align", "halign", "order", { sortable: "boolean", checkbox: "boolean", resizable: "boolean", fixed: "boolean" }, { rowspan: "number", colspan: "number", width: "number" }]), { title: (th.html() || undefined), hidden: (th.attr("hidden") ? true : undefined), formatter: (th.attr("formatter") ? eval(th.attr("formatter")) : undefined), styler: (th.attr("styler") ? eval(th.attr("styler")) : undefined), sorter: (th.attr("sorter") ? eval(th.attr("sorter")) : undefined) });
                        if (th.attr("editor")) {
                            var s = $.trim(th.attr("editor"));
                            if (s.substr(0, 1) == "{") {
                                col.editor = eval("(" + s + ")");
                            } else {
                                col.editor = s;
                            }
                        }
                        cols.push(col);
                    });
                    opt.frozen ? _53e.push(cols) : _53f.push(cols);
                });
            });
            return [_53e, _53f];
        };
        var _540 = $("<div class=\"datagrid-wrap\">" + "<div class=\"datagrid-view\">" + "<div class=\"datagrid-view1\">" + "<div class=\"datagrid-header\">" + "<div class=\"datagrid-header-inner\"></div>" + "</div>" + "<div class=\"datagrid-body\">" + "<div class=\"datagrid-body-inner\"></div>" + "</div>" + "<div class=\"datagrid-footer\">" + "<div class=\"datagrid-footer-inner\"></div>" + "</div>" + "</div>" + "<div class=\"datagrid-view2\">" + "<div class=\"datagrid-header\">" + "<div class=\"datagrid-header-inner\"></div>" + "</div>" + "<div class=\"datagrid-body\"></div>" + "<div class=\"datagrid-footer\">" + "<div class=\"datagrid-footer-inner\"></div>" + "</div>" + "</div>" + "</div>" + "</div>").insertAfter(_53b);
        _540.panel({ doSize: false });
        _540.panel("panel").addClass("datagrid").bind("_resize", function (e, _541) {
            var opts = $.data(_53b, "datagrid").options;
            if (opts.fit == true || _541) {
                _515(_53b);
                setTimeout(function () {
                    if ($.data(_53b, "datagrid")) {
                        _542(_53b);
                    }
                }, 0);
            }
            return false;
        });
        //wanghc 2018-1-11 add code --> addClass("datagrid-f") ---> treegrid->checkbox-bind rowevent
        $(_53b).addClass("datagrid-f").hide().appendTo(_540.children("div.datagrid-view"));
        var cc = _53d();
        var view = _540.children("div.datagrid-view");
        var _543 = view.children("div.datagrid-view1");
        var _544 = view.children("div.datagrid-view2");
        return { panel: _540, frozenColumns: cc[0], columns: cc[1], dc: { view: view, view1: _543, view2: _544, header1: _543.children("div.datagrid-header").children("div.datagrid-header-inner"), header2: _544.children("div.datagrid-header").children("div.datagrid-header-inner"), body1: _543.children("div.datagrid-body").children("div.datagrid-body-inner"), body2: _544.children("div.datagrid-body"), footer1: _543.children("div.datagrid-footer").children("div.datagrid-footer-inner"), footer2: _544.children("div.datagrid-footer").children("div.datagrid-footer-inner") } };
    };
    function _545(_546) {
        var _547 = $.data(_546, "datagrid");
        var opts = _547.options;
        var dc = _547.dc;
        var _548 = _547.panel;
        _547.ss = $(_546).datagrid("createStyleSheet");
        _548.panel($.extend({}, opts, {
            id: null, doSize: false, onResize: function (_549, _54a) {
                setTimeout(function () {
                    if ($.data(_546, "datagrid")) {
                        _519(_546);
                        _579(_546);
                        opts.onResize.call(_548, _549, _54a);
                    }
                }, 0);
            }, onExpand: function () {
                _526(_546);
                opts.onExpand.call(_548);
            }
        }));
        _547.rowIdPrefix = "datagrid-row-r" + (++_501);
        _547.cellClassPrefix = "datagrid-cell-c" + _501;
        _54b(dc.header1, opts.frozenColumns, true);
        _54b(dc.header2, opts.columns, false);
        _54c();
        dc.header1.add(dc.header2).css("display", opts.showHeader ? "block" : "none");
        dc.footer1.add(dc.footer2).css("display", opts.showFooter ? "block" : "none");
        if (opts.toolbar) {
            if ($.isArray(opts.toolbar)) {
                $("div.datagrid-toolbar", _548).remove();
                var tb = $("<div class=\"datagrid-toolbar\"><table cellspacing=\"0\" cellpadding=\"0\"><tr></tr></table></div>").prependTo(_548);
                var tr = tb.find("tr");
                for (var i = 0; i < opts.toolbar.length; i++) {
                    var btn = opts.toolbar[i];
                    if (btn == "-") {
                        $("<td><div class=\"datagrid-btn-separator\"></div></td>").appendTo(tr);
                    } else {
                        var td = $("<td></td>").appendTo(tr);
                        var tool = $("<a href=\"javascript:void(0)\"></a>").appendTo(td);
                        tool[0].onclick = eval(btn.handler || function () {
                        });
                        tool.linkbutton($.extend({}, btn, { plain: true }));
                    }
                }
            } else {
                $(opts.toolbar).addClass("datagrid-toolbar").prependTo(_548);
                $(opts.toolbar).show();
            }
        } else {
            $("div.datagrid-toolbar", _548).remove();
        }
        $("div.datagrid-pager", _548).remove();
        if (opts.pagination) {
            var _54d = $("<div class=\"datagrid-pager\"></div>");
            if (opts.pagePosition == "bottom") {
                _54d.appendTo(_548);
            } else {
                if (opts.pagePosition == "top") {
                    _54d.addClass("datagrid-pager-top").prependTo(_548);
                } else {
                    var ptop = $("<div class=\"datagrid-pager datagrid-pager-top\"></div>").prependTo(_548);
                    _54d.appendTo(_548);
                    _54d = _54d.add(ptop);
                }
            }
            _54d.pagination({
                total: (opts.pageNumber * opts.pageSize),
                pageNumber: opts.pageNumber,
                showRefresh: opts.showRefresh,  // wanghc 2018-1-29
                showPageList: opts.showPageList, // wanghc 2018-1-29
                afterPageText: opts.afterPageText,// wanghc 2018-1-29
                beforePageText: opts.beforePageText,// wanghc 2018-1-29
                displayMsg: opts.displayMsg,// wanghc 2018-1-29
                pageSize: opts.pageSize,
                pageList: opts.pageList,
                onSelectPage: function (_54e, _54f) {
                    opts.pageNumber = _54e;
                    opts.pageSize = _54f;
                    _54d.pagination("refresh", { pageNumber: _54e, pageSize: _54f });
                    _577(_546);
                }
            });
            opts.pageSize = _54d.pagination("options").pageSize;
        }
        // wanghc 初始化时,增加加滚动条 2018-12-20
        dc.body2.html("<div style='width:" + dc.view2.find('.datagrid-header-row').width() + "px;border:solid 0px;height:1px;'></div>");
        //_54b => renderGridHeader
        function _54b(_550, _551, _552) {
            if (!_551) {
                return;
            }
            $(_550).show();
            $(_550).empty();
            var _553 = [];
            var _554 = [];
            if (opts.sortName) {
                _553 = opts.sortName.split(",");
                _554 = opts.sortOrder.split(",");
            }
            //var tmpclone = $(_550).clone()[0];  //add by lan---2018-12-19 先clone一个节点,生成grid,生成完后再置回
            var t = $("<table class=\"datagrid-htable\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tbody></tbody></table>").appendTo(_550);
            for (var i = 0; i < _551.length; i++) {
                //add yucz 2019-9-26 支持不固定的标题行
                var temptr = "<tr class=\"datagrid-header-row " + opts.id + "-header-row" + i + "\"></tr>";
                var tr = $(temptr).appendTo($("tbody", t));
                var cols = _551[i];
                for (var j = 0; j < cols.length; j++) {
                    var col = cols[j];
                    var attr = "";
                    if (col.rowspan) {
                        attr += "rowspan=\"" + col.rowspan + "\" ";
                    }
                    if (col.colspan) {
                        attr += "colspan=\"" + col.colspan + "\" ";
                    }
                    var td = $("<td " + attr + "></td>").appendTo(tr);
                    if (col.checkbox) {
                        td.attr("field", col.field);
                        $("<div class=\"datagrid-header-check\"></div>").html("<input type=\"checkbox\"/>").appendTo(td);
                    } else {
                        if (col.field) {
                            td.attr("field", col.field);
                            td.append("<div class=\"datagrid-cell\"><span></span><span class=\"datagrid-sort-icon\"></span></div>");
                            $("span", td).html(col.title);
                            $("span.datagrid-sort-icon", td).html(""); //html("&nbsp;");-html(""); neer 2019-4-4 当align:'right'时列头与内容没对齐
                            var cell = td.find("div.datagrid-cell");
                            var pos = _502(_553, col.field);
                            if (pos >= 0) {
                                cell.addClass("datagrid-sort-" + _554[pos]);
                            }
                            if (col.resizable == false) {
                                cell.attr("resizable", "false");
                            }
                            if (col.width) {
                                cell._outerWidth(col.width);
                                col.boxWidth = parseInt(cell[0].style.width);
                            } else {
                                col.auto = true;
                            }
                            cell.css("text-align", (col.halign || col.align || ""));
                            col.cellClass = _547.cellClassPrefix + "-" + col.field.replace(/[\.|\s]/g, "-");
                            cell.addClass(col.cellClass).css("width", "");
                        } else {
                            //$("<div class=\"datagrid-cell-group\"></div>").html(col.title).appendTo(td);//这是原来的代码，下面是新加的
                            //add yucz 2019-9-26 支持不固定的标题行
                            td.append("<div class=\"datagrid-cell-group\"><span></span></div>");
                            $("span", td).html(col.title);
                            var cell = td.find("div.datagrid-cell-group");
                            cell.css("text-align", (col.halign || col.align || ""));
                            cell.css("height", "auto")
                        }
                    }
                    if (col.hidden) {
                        td.hide();
                    }
                }
            }
            if (_552 && opts.rownumbers) {
                var td = $("<td rowspan=\"" + opts.frozenColumns.length + "\"><div class=\"datagrid-header-rownumber\"></div></td>");
                if ($("tr", t).length == 0) {
                    td.wrap("<tr class=\"datagrid-header-row\"></tr>").parent().appendTo($("tbody", t));
                } else {
                    td.prependTo($("tr:first", t));
                }
            }
            //$(_550).replaceWith(tmpclone);  //add lan 2018-12-19
        };
        function _54c() {
            var _555 = [];
            var _556 = _557(_546, true).concat(_557(_546));
            for (var i = 0; i < _556.length; i++) {
                var col = _558(_546, _556[i]);
                if (col && !col.checkbox) {
                    _555.push(["." + col.cellClass, col.boxWidth ? col.boxWidth + "px" : "auto"]);
                }
            }
            _547.ss.add(_555);
            _547.ss.dirty(_547.cellSelectorPrefix);
            _547.cellSelectorPrefix = "." + _547.cellClassPrefix;
        };

        if (opts.btoolbar) {
            if ($.isArray(opts.btoolbar)) {
                $("div.datagrid-btoolbar", _548).remove();
                var tb = $("<div class=\"datagrid-btoolbar\"><table cellspacing=\"0\" cellpadding=\"0\"><tr></tr></table></div>").appendTo(_548);
                var tr = tb.find("tr");
                for (var i = 0; i < opts.btoolbar.length; i++) {
                    var btn = opts.btoolbar[i];
                    if (btn == "-") {
                        $("<td><div class=\"datagrid-btn-separator\"></div></td>").appendTo(tr);
                    } else {
                        var td = $("<td></td>").appendTo(tr);
                        var tool = $("<a href=\"javascript:void(0)\"></a>").appendTo(td);
                        tool[0].onclick = eval(btn.handler || function () {
                        });
                        tool.linkbutton($.extend({}, btn, { plain: true }));
                    }
                }
            } else {
                $(opts.btoolbar).addClass("datagrid-btoolbar").appendTo(_548);
                $(opts.btoolbar).show();
            }
        } else {
            $("div.datagrid-btoolbar", _548).remove();
        }
    };
    function _559(_55a) {
        var _55b = $.data(_55a, "datagrid");
        var _55c = _55b.panel;
        var opts = _55b.options;
        var dc = _55b.dc;
        var _55d = dc.header1.add(dc.header2);
        _55d.find("input[type=checkbox]").unbind(".datagrid").bind("click.datagrid", function (e) {
            if (opts.singleSelect && opts.selectOnCheck) {
                return false;
            }
            if ($(this).is(":checked")) {
                _5df(_55a);
            } else {
                _5e5(_55a);
            }
            e.stopPropagation();
        });
        var _55e = _55d.find("div.datagrid-cell");
        _55e.closest("td").unbind(".datagrid").bind("mouseenter.datagrid", function () {
            if (_55b.resizing) {
                return;
            }
            $(this).addClass("datagrid-header-over");
        }).bind("mouseleave.datagrid", function () {
            $(this).removeClass("datagrid-header-over");
        }).bind("contextmenu.datagrid", function (e) {
            var _55f = $(this).attr("field");
            opts.onHeaderContextMenu.call(_55a, e, _55f);
        }).bind("dblclick.datagrid", function (e) {   //cryze 双击列头事件 和表头右键菜单的监听放在一起
            var _55f = $(this).attr("field");
            opts.onDblClickHeader.call(_55a, e, _55f);
        })
        _55e.unbind(".datagrid").bind("click.datagrid", function (e) {
            var p1 = $(this).offset().left + 5;
            var p2 = $(this).offset().left + $(this)._outerWidth() - 5;
            if (e.pageX < p2 && e.pageX > p1) {
                _56c(_55a, $(this).parent().attr("field"));
            }
        }).bind("dblclick.datagrid", function (e) {
            var p1 = $(this).offset().left + 5;
            var p2 = $(this).offset().left + $(this)._outerWidth() - 5;
            var cond = opts.resizeHandle == "right" ? (e.pageX > p2) : (opts.resizeHandle == "left" ? (e.pageX < p1) : (e.pageX < p1 || e.pageX > p2));
            if (cond) {
                var _560 = $(this).parent().attr("field");
                var col = _558(_55a, _560);
                if (col.resizable == false) {
                    return;
                }
                $(_55a).datagrid("autoSizeColumn", _560);
                col.auto = false;
            }
        });
        var _561 = opts.resizeHandle == "right" ? "e" : (opts.resizeHandle == "left" ? "w" : "e,w");
        _55e.each(function () {
            $(this).resizable({
                handles: _561, disabled: ($(this).attr("resizable") ? $(this).attr("resizable") == "false" : false), minWidth: 25, onStartResize: function (e) {
                    _55b.resizing = true;
                    _55d.css("cursor", $("body").css("cursor"));
                    if (!_55b.proxy) {
                        _55b.proxy = $("<div class=\"datagrid-resize-proxy\"></div>").appendTo(dc.view);
                    }
                    _55b.proxy.css({ left: e.pageX - $(_55c).offset().left - 1, display: "none" });
                    setTimeout(function () {
                        if (_55b.proxy) {
                            _55b.proxy.show();
                        }
                    }, 500);
                }, onResize: function (e) {
                    _55b.proxy.css({ left: e.pageX - $(_55c).offset().left - 1, display: "block" });
                    return false;
                }, onStopResize: function (e) {
                    _55d.css("cursor", "");
                    $(this).css("height", "");
                    $(this)._outerWidth($(this)._outerWidth());
                    var _562 = $(this).parent().attr("field");
                    var col = _558(_55a, _562);
                    col.width = $(this)._outerWidth();
                    col.boxWidth = parseInt(this.style.width);
                    col.auto = undefined;
                    $(this).css("width", "");
                    _542(_55a, _562);
                    _55b.proxy.remove();
                    _55b.proxy = null;
                    if ($(this).parents("div:first.datagrid-header").parent().hasClass("datagrid-view1")) {
                        _519(_55a);
                    }
                    _579(_55a);
                    opts.onResizeColumn.call(_55a, _562, col.width);
                    setTimeout(function () {
                        _55b.resizing = false;
                    }, 0);
                }
            });
        });
        dc.body1.add(dc.body2).unbind().bind("mouseover", function (e) {
            if (_55b.resizing) {
                return;
            }
            /* 2018-11-23 start -- showTip*/
            var td = $(e.target);
            var colname = undefined;
            if ("undefined" == typeof td.attr('field')) {
                td = td.closest('td');
            }
            colname = td.attr('field');
            if (colname) {
                var tmpdg = $.data(_55a, "datagrid");
                var cm = tmpdg.options.columns;
                for (var i = 0; i < cm.length; i++) {
                    for (var j = 0; j < cm[i].length; j++) {
                        if (cm[i][j].field == colname) {
                            if (cm[i][j].showTip) {
                                var tipWidth = cm[i][j].tipWidth || 350;
                                td.tooltip({
                                    content: td.text(),
                                    onShow: function (e1) {
                                        $(this).tooltip("tip").css({
                                            width: tipWidth, top: e1.pageY + 20, left: e1.pageX - (250 / 2)
                                        });
                                    }
                                }).tooltip("show", e);
                            }
                        }
                    }
                }
            }
            /** end */
            var tr = $(e.target).closest("tr.datagrid-row");
            if (!_563(tr)) {
                return;
            }
            var _564 = _565(tr);
            _5c7(_55a, _564, true);  //高亮显示 增加isMouse 2019-5-24

            e.stopPropagation();
        }).bind("mouseout", function (e) {
            var tr = $(e.target).closest("tr.datagrid-row");
            if (!_563(tr)) {
                return;
            }
            var _566 = _565(tr);
            opts.finder.getTr(_55a, _566).removeClass("datagrid-row-over");
            e.stopPropagation();
        }).bind("click", function (e) {
            var tt = $(e.target);
            var tr = tt.closest("tr.datagrid-row");
            if (!_563(tr)) {
                return;
            }
            var _567 = _565(tr);
            if (tt.parent().hasClass("datagrid-cell-check")) {
                if (opts.singleSelect && opts.selectOnCheck) {
                    if (!opts.checkOnSelect) {
                        _5e5(_55a, true);
                    }
                    _5d2(_55a, _567);
                } else {
                    if (tt.is(":checked")) {
                        _5d2(_55a, _567);
                    } else {
                        _5d9(_55a, _567);
                    }
                }
            } else {
                var row = opts.finder.getRow(_55a, _567);
                var td = tt.closest("td[field]", tr);
                if (td.length) {
                    var _568 = td.attr("field");
                    opts.onClickCell.call(_55a, _567, _568, row[_568]);
                }
                if (opts.singleSelect == true) {
                    _5cb(_55a, _567);
                } else {
                    if (opts.ctrlSelect) {
                        if (e.ctrlKey) {
                            if (tr.hasClass("datagrid-row-selected")) {
                                _5d3(_55a, _567);
                            } else {
                                _5cb(_55a, _567);
                            }
                        } else {
                            $(_55a).datagrid("clearSelections");
                            _5cb(_55a, _567);
                        }
                    } else {
                        if (tr.hasClass("datagrid-row-selected")) {
                            _5d3(_55a, _567);
                        } else {
                            _5cb(_55a, _567);
                        }
                    }
                }
                opts.onClickRow.call(_55a, _567, row);
            }
            e.stopPropagation();
        }).bind("dblclick", function (e) {
            var tt = $(e.target);
            var tr = tt.closest("tr.datagrid-row");
            if (!_563(tr)) {
                return;
            }
            var _569 = _565(tr);
            var row = opts.finder.getRow(_55a, _569);
            var td = tt.closest("td[field]", tr);
            if (td.length) {
                var _56a = td.attr("field");
                opts.onDblClickCell.call(_55a, _569, _56a, row[_56a]);
            }
            opts.onDblClickRow.call(_55a, _569, row);
            e.stopPropagation();
        }).bind("contextmenu", function (e) {
            var tr = $(e.target).closest("tr.datagrid-row");
            if (!_563(tr)) {
                return;
            }
            var _56b = _565(tr);
            var row = opts.finder.getRow(_55a, _56b);
            opts.onRowContextMenu.call(_55a, e, _56b, row);
            e.stopPropagation();
        });
        dc.body2.bind("scroll", function () {
            var b1 = dc.view1.children("div.datagrid-body");
            b1.scrollTop($(this).scrollTop());
            var c1 = dc.body1.children(":first");
            var c2 = dc.body2.children(":first");
            if (c1.length && c2.length) {
                var top1 = c1.offset().top;
                var top2 = c2.offset().top;
                if (top1 != top2) {
                    b1.scrollTop(b1.scrollTop() + top1 - top2);
                }
            }
            dc.view2.children("div.datagrid-header,div.datagrid-footer")._scrollLeft($(this)._scrollLeft());
            dc.body2.children("table.datagrid-btable-frozen").css("left", -$(this)._scrollLeft());
        });
        function _565(tr) {
            if (tr.attr("datagrid-row-index")) {
                return parseInt(tr.attr("datagrid-row-index"));
            } else {
                return tr.attr("node-id");
            }
        };
        function _563(tr) {
            return tr.length && tr.parent().length;
        };
    };
    function _56c(_56d, _56e) {
        var _56f = $.data(_56d, "datagrid");
        var opts = _56f.options;
        _56e = _56e || {};
        var _570 = { sortName: opts.sortName, sortOrder: opts.sortOrder };
        if (typeof _56e == "object") {
            $.extend(_570, _56e);
        }
        var _571 = [];
        var _572 = [];
        if (_570.sortName) {
            _571 = _570.sortName.split(",");
            _572 = _570.sortOrder.split(",");
        }
        if (typeof _56e == "string") {
            var _573 = _56e;
            var col = _558(_56d, _573);
            if (!col.sortable || _56f.resizing) {
                return;
            }
            var _574 = col.order || "asc";
            var pos = _502(_571, _573);
            if (pos >= 0) {
                var _575 = _572[pos] == "asc" ? "desc" : "asc";
                if (opts.multiSort && _575 == _574) {
                    _571.splice(pos, 1);
                    _572.splice(pos, 1);
                } else {
                    _572[pos] = _575;
                }
            } else {
                if (opts.multiSort) {
                    _571.push(_573);
                    _572.push(_574);
                } else {
                    _571 = [_573];
                    _572 = [_574];
                }
            }
            _570.sortName = _571.join(",");
            _570.sortOrder = _572.join(",");
        }
        if (opts.onBeforeSortColumn.call(_56d, _570.sortName, _570.sortOrder) == false) {
            return;
        }
        $.extend(opts, _570);
        var dc = _56f.dc;
        var _576 = dc.header1.add(dc.header2);
        _576.find("div.datagrid-cell").removeClass("datagrid-sort-asc datagrid-sort-desc");
        for (var i = 0; i < _571.length; i++) {
            var col = _558(_56d, _571[i]);
            _576.find("div." + col.cellClass).addClass("datagrid-sort-" + _572[i]);
        }
        if (opts.remoteSort) {
            _577(_56d);
        } else {
            _578(_56d, $(_56d).datagrid("getData"));
        }
        opts.onSortColumn.call(_56d, opts.sortName, opts.sortOrder);
    };
    function _579(_57a) {
        var _57b = $.data(_57a, "datagrid");
        var opts = _57b.options;
        var dc = _57b.dc;
        dc.body2.css("overflow-x", "");
        if (!opts.fitColumns) {
            return;
        }
        if (!_57b.leftWidth) {
            _57b.leftWidth = 0;
        }
        var _57c = dc.view2.children("div.datagrid-header");
        var _57d = 0;
        var _57e;
        var _57f = _557(_57a, false);
        for (var i = 0; i < _57f.length; i++) {
            var col = _558(_57a, _57f[i]);
            if (_580(col)) {
                _57d += col.width;
                _57e = col;
            }
        }
        if (!_57d) {
            return;
        }
        if (_57e) {
            _581(_57e, -_57b.leftWidth);
        }
        var _582 = _57c.children("div.datagrid-header-inner").show();
        var _583 = _57c.width() - _57c.find("table").width() - opts.scrollbarSize + _57b.leftWidth;
        var rate = _583 / _57d;
        if (!opts.showHeader) {
            _582.hide();
        }
        for (var i = 0; i < _57f.length; i++) {
            var col = _558(_57a, _57f[i]);
            if (_580(col)) {
                var _584 = parseInt(col.width * rate);
                _581(col, _584);
                _583 -= _584;
            }
        }
        _57b.leftWidth = _583;
        if (_57e) {
            _581(_57e, _57b.leftWidth);
        }
        _542(_57a);
        if (_57c.width() >= _57c.find("table").width()) {
            dc.body2.css("overflow-x", "hidden");
        }
        function _581(col, _585) {
            if (col.width + _585 > 0) {
                col.width += _585;
                col.boxWidth += _585;
            }
        };
        function _580(col) {
            if (!col.hidden && !col.checkbox && !col.auto && !col.fixed) {
                return true;
            }
        };
    };
    function _586(_587, _588) {
        var _589 = $.data(_587, "datagrid");
        var opts = _589.options;
        var dc = _589.dc;
        var tmp = $("<div class=\"datagrid-cell\" style=\"position:absolute;left:-9999px\"></div>").appendTo("body");
        if (_588) {
            _515(_588);
            if (opts.fitColumns) {
                _519(_587);
                _579(_587);
            }
        } else {
            if (!!opts.autoSizeColumn) { //wanghc 增加配置 影响grid速度
                var _58a = false;
                var _58b = _557(_587, true).concat(_557(_587, false));
                for (var i = 0; i < _58b.length; i++) {
                    var _588 = _58b[i];
                    var col = _558(_587, _588);
                    if (!col.hidden && col.auto) {  //by wanghc 增加col.hidden判断,隐藏列不用计算 2018-5-3
                        _515(_588);
                        _58a = true;
                    }
                }
                if (_58a && opts.fitColumns) {
                    _519(_587);
                    _579(_587);
                }
            }
        }
        tmp.remove();
        function _515(_58c) {
            var _58d = dc.view.find("div.datagrid-header td[field=\"" + _58c + "\"] div.datagrid-cell");
            _58d.css("width", "");
            var col = $(_587).datagrid("getColumnOption", _58c);
            col.width = undefined;
            col.boxWidth = undefined;
            col.auto = true;
            $(_587).datagrid("fixColumnSize", _58c);
            var _58e = Math.max(_58f("header"), _58f("allbody"), _58f("allfooter"));
            _58d._outerWidth(_58e);
            col.width = _58e;
            col.boxWidth = parseInt(_58d[0].style.width);
            _58d.css("width", "");
            $(_587).datagrid("fixColumnSize", _58c);
            opts.onResizeColumn.call(_587, _58c, col.width);
            function _58f(type) {
                var _590 = 0;
                if (type == "header") {
                    _590 = _591(_58d);
                } else {
                    opts.finder.getTr(_587, 0, type).find("td[field=\"" + _58c + "\"] div.datagrid-cell").each(function () {
                        var w = _591($(this));
                        if (_590 < w) {
                            _590 = w;
                        }
                    });
                }
                return _590;
                function _591(cell) {
                    return cell.is(":visible") ? cell._outerWidth() : tmp.html(cell.html())._outerWidth();
                };
            };
        };
    };
    function _542(_592, _593) {
        var _594 = $.data(_592, "datagrid");
        var opts = _594.options;
        var dc = _594.dc;
        var _595 = dc.view.find("table.datagrid-btable,table.datagrid-ftable");
        _595.css("table-layout", "fixed");
        if (_593) {
            fix(_593);
        } else {
            var ff = _557(_592, true).concat(_557(_592, false));
            for (var i = 0; i < ff.length; i++) {
                fix(ff[i]);
            }
        }
        _595.css("table-layout", "auto");
        _596(_592);
        setTimeout(function () {
            _526(_592);
            _59b(_592);
        }, 0);
        function fix(_597) {
            var col = _558(_592, _597);
            if (!col.checkbox) {
                _594.ss.set("." + col.cellClass, col.boxWidth ? col.boxWidth + "px" : "auto");
            }
        };
    };
    function _596(_598) {
        var dc = $.data(_598, "datagrid").dc;
        dc.body1.add(dc.body2).find("td.datagrid-td-merged").each(function () {
            var td = $(this);
            var _599 = td.attr("colspan") || 1;
            var _59a = _558(_598, td.attr("field")).width;
            for (var i = 1; i < _599; i++) {
                td = td.next();
                _59a += _558(_598, td.attr("field")).width + 1;
            }
            $(this).children("div.datagrid-cell")._outerWidth(_59a);
        });
    };
    function _59b(_59c) {
        var dc = $.data(_59c, "datagrid").dc;
        dc.view.find("div.datagrid-editable").each(function () {
            var cell = $(this);
            var _59d = cell.parent().attr("field");
            var col = $(_59c).datagrid("getColumnOption", _59d);
            cell._outerWidth(col.width);
            var ed = $.data(this, "datagrid.editor");
            if (ed.actions.resize) {
                ed.actions.resize(ed.target, cell.width());
            }
        });
    };
    function _558(_59e, _59f) {
        function find(_5a0) {
            if (_5a0) {
                for (var i = 0; i < _5a0.length; i++) {
                    var cc = _5a0[i];
                    for (var j = 0; j < cc.length; j++) {
                        var c = cc[j];
                        if (c.field == _59f) {
                            return c;
                        }
                    }
                }
            }
            return null;
        };
        var opts = $.data(_59e, "datagrid").options;
        var col = find(opts.columns);
        if (!col) {
            col = find(opts.frozenColumns);
        }
        return col;
    };
    function _557(_5a1, _5a2) {

        var opts = $.data(_5a1, "datagrid").options;
        var _5a3 = (_5a2 == true) ? (opts.frozenColumns || [[]]) : opts.columns;
        if (_5a3.length == 0) {
            return [];
        }
        var _5a4 = [];
        function _5a5(_5a6) {
            var c = 0;
            var i = 0;
            while (true) {
                if (_5a4[i] == undefined) {
                    if (c == _5a6) {
                        return i;
                    }
                    c++;
                }
                i++;
            }
        };
        function _5a7(r) {
            var ff = [];
            var c = 0;
            for (var i = 0; i < _5a3[r].length; i++) {
                var col = _5a3[r][i];
                if (col.field) {
                    ff.push([c, col.field]);
                }
                c += parseInt(col.colspan || "1");
            }
            for (var i = 0; i < ff.length; i++) {
                ff[i][0] = _5a5(ff[i][0]);
            }
            for (var i = 0; i < ff.length; i++) {
                var f = ff[i];
                _5a4[f[0]] = f[1];
            }
        };
        for (var i = 0; i < _5a3.length; i++) {
            _5a7(i);
        }
		
		var _newRe = [];
		//add yucz 2019-12-9 返回正确顺序的列字段 
		if (!!$.data(_5a1, "amendDataDisplay") && !!$.data(_5a1, "filelds"))
		{
			_newRe = _newRe.concat($.data(_5a1, "filelds"));
			for (var i = 0;i< _5a4.length; i++)
			{
				var testReg = /^ID/;
				if (testReg.test(_5a4[i]))
				{
					_newRe.splice(i,0,_5a4[i]);
				}				
			}
			
			
			return _newRe;
		}
		else
			return _5a4;
    };
    function _578(_5a8, data) {
        var _5a9 = $.data(_5a8, "datagrid");
        var opts = _5a9.options;
        var dc = _5a9.dc;
        data = opts.loadFilter.call(_5a8, data);
        data.total = parseInt(data.total);
        _5a9.data = data;
        if (data.footer) {
            _5a9.footer = data.footer;
        }
        if (!opts.remoteSort && opts.sortName) {
            var _5aa = opts.sortName.split(",");
            var _5ab = opts.sortOrder.split(",");
            data.rows.sort(function (r1, r2) {
                var r = 0;
                for (var i = 0; i < _5aa.length; i++) {
                    var sn = _5aa[i];
                    var so = _5ab[i];
                    var col = _558(_5a8, sn);
                    var _5ac = col.sorter || function (a, b) {
                        return a == b ? 0 : (a > b ? 1 : -1);
                    };
                    r = _5ac(r1[sn], r2[sn]) * (so == "asc" ? 1 : -1);
                    if (r != 0) {
                        return r;
                    }
                }
                return r;
            });
        }
        if (opts.view.onBeforeRender) {
            opts.view.onBeforeRender.call(opts.view, _5a8, data.rows);
        }
        opts.view.render.call(opts.view, _5a8, dc.body2, false);
        opts.view.render.call(opts.view, _5a8, dc.body1, true);
        if (opts.showFooter) {
            opts.view.renderFooter.call(opts.view, _5a8, dc.footer2, false);
            opts.view.renderFooter.call(opts.view, _5a8, dc.footer1, true);
        }
        if (opts.view.onAfterRender) {
            opts.view.onAfterRender.call(opts.view, _5a8);
        }
        _5a9.ss.clean();
        if (opts.rownumbers && opts.fixRowNumber) {
            $(_5a8).datagrid("fixRowNumber");
        }
        opts.onLoadSuccess.call(_5a8, data);
        var _5ad = $(_5a8).datagrid("getPager");
        if (_5ad.length) {
            var _5ae = _5ad.pagination("options");
            if (_5ae.total != data.total) {
                _5ad.pagination("refresh", { total: data.total });
                if (opts.pageNumber != _5ae.pageNumber) {
                    opts.pageNumber = _5ae.pageNumber;
                    _577(_5a8);
                }
            }
        }
        _526(_5a8);
        dc.body2.triggerHandler("scroll");
        _5af(_5a8);
        $(_5a8).datagrid("autoSizeColumn");
    };
    function _5af(_5b0) {
        var _5b1 = $.data(_5b0, "datagrid");
        var opts = _5b1.options;
        if (opts.idField) {
            var _5b2 = $.data(_5b0, "treegrid") ? true : false;
            var _5b3 = opts.onSelect;
            var _5b4 = opts.onCheck;
            opts.onSelect = opts.onCheck = function () {
            };
            var rows = opts.finder.getRows(_5b0);
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var _5b5 = _5b2 ? row[opts.idField] : i;
                //cryze 2019-3-13
                if (opts.view.type == 'scrollview') _5b5 += (opts.view.index || 0);  //index的作用getTr起作用 拼接得到tr的id，scrollview用的是总的index值
                if (_5b6(_5b1.selectedRows, row)) {
                    /*if (opts.view.type == 'scrollview'){
                        // index为datagrid的rows的index.即为当前页数据源对应的数组,不能只从firstRows中取
                        //_5b5为当前数据的index，当为scrollview插件时，rows为所有数据8000
                        //通过id列查询一次
                        for(var w=0; w<_5b1.data.firstRows.length; w++){
                            if (_5b1.data.firstRows[w][opts.idField] == row[opts.idField]) {
                                _5b5 = w ;
                            }
                        }
                    }*/
                    _5cb(_5b0, _5b5, true);
                }
                if (_5b6(_5b1.checkedRows, row)) {
                    /*if (opts.view.type == 'scrollview'){
                        //_5b5为当前数据的index，当为scrollview插件时，rows为所有数据8000
                        // index为datagrid的rows的index.即为当前页数据源对应的数组,不能只从firstRows中取
                        //通过id列查询一次
                        for(var w=0; w<_5b1.data.firstRows.length; w++){
                            if (_5b1.data.firstRows[w][opts.idField] == row[opts.idField]) {
                                _5b5 = w ;
                            }
                        }
                    }*/
                    _5d2(_5b0, _5b5, true);
                }
            }
            opts.onSelect = _5b3;
            opts.onCheck = _5b4;
        }
        function _5b6(a, r) {
            for (var i = 0; i < a.length; i++) {
                if (a[i][opts.idField] == r[opts.idField]) {
                    a[i] = r;
                    return true;
                }
            }
            return false;
        };
    };
    function _5b7(_5b8, row) {
        var _5b9 = $.data(_5b8, "datagrid");
        var opts = _5b9.options;
        var rows = _5b9.data.rows;
        if (typeof row == "object") {
            return _502(rows, row);
        } else {
            for (var i = 0; i < rows.length; i++) {
                if (rows[i][opts.idField] == row) {
                    return i;
                }
            }
            return -1;
        }
    };
    function _5ba(_5bb) {
        var _5bc = $.data(_5bb, "datagrid");
        var opts = _5bc.options;
        var data = _5bc.data;
        if (opts.idField) {
            return _5bc.selectedRows;
        } else {
            var rows = [];
            opts.finder.getTr(_5bb, "", "selected", 2).each(function () {
                rows.push(opts.finder.getRow(_5bb, $(this)));
            });
            return rows;
        }
    };
    function _5bd(_5be) { //getChecked
        var _5bf = $.data(_5be, "datagrid");
        var opts = _5bf.options;
        if (opts.idField) {
            return _5bf.checkedRows;
        } else {
            var rows = [];
            opts.finder.getTr(_5be, "", "checked", 2).each(function () {
                rows.push(opts.finder.getRow(_5be, $(this)));
            });
            return rows;
        }
    };
    function _5c0(_5c1, _5c2) {
        var _5c3 = $.data(_5c1, "datagrid");
        var dc = _5c3.dc;
        var opts = _5c3.options;
        var tr = opts.finder.getTr(_5c1, _5c2);
        if (tr.length) {
            if (tr.closest("table").hasClass("datagrid-btable-frozen")) {
                return;
            }
            var _5c4 = dc.view2.children("div.datagrid-header")._outerHeight();
            var _5c5 = dc.body2;
            var _5c6 = _5c5.outerHeight(true) - _5c5.outerHeight();
            var top = tr.position().top - _5c4 - _5c6;
            if (top < 0) {
                _5c5.scrollTop(_5c5.scrollTop() + top);
            } else {
                if (top + tr._outerHeight() > _5c5.height() - 18) {
                    _5c5.scrollTop(_5c5.scrollTop() + top + tr._outerHeight() - _5c5.height() + 18);
                }
            }
        }
    };

    /**
     * 
     * @param {*} _5c8 target
     * @param {*} _5c9 index
     * @param {*} isMouse 是否是鼠标悬浮高亮 add 2019-5-24
     */
    function _5c7(_5c8, _5c9, isMouse) {
        var _5ca = $.data(_5c8, "datagrid");
        var opts = _5ca.options;
        opts.finder.getTr(_5c8, _5ca.highlightIndex).removeClass("datagrid-row-over");
        opts.finder.getTr(_5c8, _5c9).addClass("datagrid-row-over");
        var previoushighlightIndex = _5ca.highlightIndex;
        _5ca.highlightIndex = _5c9;
        if (isMouse === true && previoushighlightIndex == _5c9) {  //鼠标悬浮触发频率很高 是鼠标悬浮且index没改变 不触发onHighlightRow

        } else {
            opts.onHighlightRow.call(_5c8, _5c9, _5ca.data.rows[_5c9]); //cryze 2019-5-23 hightlightRow事件
        }

    };
    function _5cb(_5cc, _5cd, _5ce) {
        var _5cf = $.data(_5cc, "datagrid");
        var dc = _5cf.dc;
        var opts = _5cf.options;
        var _5d0 = _5cf.selectedRows;
        /*add onBeforeSelect event by wanghc 2018-05-23*/
        var row = opts.finder.getRow(_5cc, _5cd); //提前
        if (false === opts.onBeforeSelect.call(_5cc, _5cd, row)) {
            return;
        }
        if (opts.singleSelect) {
            _5d1(_5cc);
            _5d0.splice(0, _5d0.length);
        }
        if (!_5ce && opts.checkOnSelect) {
            _5d2(_5cc, _5cd, true);
        }

        if (opts.idField) {
            _505(_5d0, opts.idField, row);
        }
        opts.finder.getTr(_5cc, _5cd).addClass("datagrid-row-selected");
        opts.onSelect.call(_5cc, _5cd, row);
        _5c0(_5cc, _5cd);
    };
    function _5d3(_5d4, _5d5, _5d6) {
        var _5d7 = $.data(_5d4, "datagrid");
        var dc = _5d7.dc;
        var opts = _5d7.options;
        /*add onBeforeUnselect event by wanghc 2018-05-23*/
        var row = opts.finder.getRow(_5d4, _5d5); //提前
        if (false === opts.onBeforeUnselect.call(_5d4, _5d5, row)) {
            return;
        }
        var _5d8 = $.data(_5d4, "datagrid").selectedRows;
        if (!_5d6 && opts.checkOnSelect) {
            _5d9(_5d4, _5d5, true);
        }
        opts.finder.getTr(_5d4, _5d5).removeClass("datagrid-row-selected");
        if (opts.idField) {
            _503(_5d8, opts.idField, row[opts.idField]);
        }
        opts.onUnselect.call(_5d4, _5d5, row);
    };
    function _5da(_5db, _5dc) {
        var _5dd = $.data(_5db, "datagrid");
        var opts = _5dd.options;
        var rows = opts.finder.getRows(_5db);
        var _5de = $.data(_5db, "datagrid").selectedRows;
        if (!_5dc && opts.checkOnSelect) {
            _5df(_5db, true);
        }
        opts.finder.getTr(_5db, "", "allbody").addClass("datagrid-row-selected");
        if (opts.idField) {
            for (var _5e0 = 0; _5e0 < rows.length; _5e0++) {
                _505(_5de, opts.idField, rows[_5e0]);
            }
        }
        opts.onSelectAll.call(_5db, rows);
    };
    function _5d1(_5e1, _5e2) {
        var _5e3 = $.data(_5e1, "datagrid");
        var opts = _5e3.options;
        var rows = opts.finder.getRows(_5e1);
        var _5e4 = $.data(_5e1, "datagrid").selectedRows;
        var lastSelectedRowIndex = _5b7(_5e1,_5e4[0]);
        if (!_5e2 && opts.checkOnSelect) {
            _5e5(_5e1, true);
        }
        opts.finder.getTr(_5e1, "", "selected").removeClass("datagrid-row-selected");

        //yucz 2019-11-4 当用户取消选中一行时触发
        if (lastSelectedRowIndex > -1)
            opts.onUnselect.call(_5e1, lastSelectedRowIndex, _5e4[0]);

        if (opts.idField) {
            for (var _5e6 = 0; _5e6 < rows.length; _5e6++) {
                _503(_5e4, opts.idField, rows[_5e6][opts.idField]);
            }
        }
        opts.onUnselectAll.call(_5e1, rows);
    };
    // checked row(target,index,true|false)
    function _5d2(_5e7, _5e8, _5e9) {
        var _5ea = $.data(_5e7, "datagrid");
        var opts = _5ea.options;
        /*add onBeforeCheck event by wanghc 2018-05-23*/
        var row = opts.finder.getRow(_5e7, _5e8);
        if (false === opts.onBeforeCheck.call(_5e7, _5e8, row)) {
            return;
        }
        if (!_5e9 && opts.selectOnCheck) {
            _5cb(_5e7, _5e8, true);
        }
        var tr = opts.finder.getTr(_5e7, _5e8).addClass("datagrid-row-checked");
        var ck = tr.find("div.datagrid-cell-check input[type=checkbox]");
        ck._propAttr("checked", true);
        tr = opts.finder.getTr(_5e7, "", "checked", 2);
        if (tr.length == opts.finder.getRows(_5e7).length) {
            var dc = _5ea.dc;
            var _5eb = dc.header1.add(dc.header2);
            _5eb.find("input[type=checkbox]")._propAttr("checked", true);
        }

        if (opts.idField) {
            _505(_5ea.checkedRows, opts.idField, row);
        }
        opts.onCheck.call(_5e7, _5e8, row);
    };
    function _5d9(_5ec, _5ed, _5ee) {
        var _5ef = $.data(_5ec, "datagrid");
        var opts = _5ef.options;
        /*add onBeforeUncheck event by wanghc 2018-05-23 */
        var row = opts.finder.getRow(_5ec, _5ed);
        if (false === opts.onBeforeUncheck.call(_5ec, _5ed, row)) {
            return;
        }
        if (!_5ee && opts.selectOnCheck) {
            _5d3(_5ec, _5ed, true);
        }
        var tr = opts.finder.getTr(_5ec, _5ed).removeClass("datagrid-row-checked");
        var ck = tr.find("div.datagrid-cell-check input[type=checkbox]");
        ck._propAttr("checked", false);
        var dc = _5ef.dc;
        var _5f0 = dc.header1.add(dc.header2);
        _5f0.find("input[type=checkbox]")._propAttr("checked", false);
        if (opts.idField) {
            _503(_5ef.checkedRows, opts.idField, row[opts.idField]);
        }
        opts.onUncheck.call(_5ec, _5ed, row);
    };
    function _5df(_5f1, _5f2) {
        var _5f3 = $.data(_5f1, "datagrid");
        var opts = _5f3.options;
        var rows = opts.finder.getRows(_5f1);
        if (!_5f2 && opts.selectOnCheck) {
            _5da(_5f1, true);
        }
        var dc = _5f3.dc;
        var hck = dc.header1.add(dc.header2).find("input[type=checkbox]");
        var bck = opts.finder.getTr(_5f1, "", "allbody").addClass("datagrid-row-checked").find("div.datagrid-cell-check input[type=checkbox]");
        hck.add(bck)._propAttr("checked", true);
        if (opts.idField) {
            for (var i = 0; i < rows.length; i++) {
                _505(_5f3.checkedRows, opts.idField, rows[i]);
            }
        }
        opts.onCheckAll.call(_5f1, rows);
    };
    function _5e5(_5f4, _5f5) {
        var _5f6 = $.data(_5f4, "datagrid");
        var opts = _5f6.options;
        var rows = opts.finder.getRows(_5f4);
        if (!_5f5 && opts.selectOnCheck) {
            _5d1(_5f4, true);
        }
        var dc = _5f6.dc;
        var hck = dc.header1.add(dc.header2).find("input[type=checkbox]");
        var bck = opts.finder.getTr(_5f4, "", "checked").removeClass("datagrid-row-checked").find("div.datagrid-cell-check input[type=checkbox]");
        hck.add(bck)._propAttr("checked", false);
        if (opts.idField) {
            for (var i = 0; i < rows.length; i++) {
                _503(_5f6.checkedRows, opts.idField, rows[i][opts.idField]);
            }
        }
        opts.onUncheckAll.call(_5f4, rows);
    };
    function _5f7(_5f8, _5f9) {
        var opts = $.data(_5f8, "datagrid").options;
        var tr = opts.finder.getTr(_5f8, _5f9);
        var row = opts.finder.getRow(_5f8, _5f9);
        if (tr.hasClass("datagrid-row-editing")) {
            return;
        }
        if (opts.onBeforeEdit.call(_5f8, _5f9, row) == false) {
            return;
        }
        tr.addClass("datagrid-row-editing");
        _5fa(_5f8, _5f9);
        _59b(_5f8);
        tr.find("div.datagrid-editable").each(function () {
            var _5fb = $(this).parent().attr("field");
            var ed = $.data(this, "datagrid.editor");
            ed.actions.setValue(ed.target, row[_5fb]);
        });
        _5fc(_5f8, _5f9);
        opts.onBeginEdit.call(_5f8, _5f9, row);
    };
    /// endEdit(t,rowIndex=0,flag)
    function _5fd(_5fe, _5ff, _600) {
        var opts = $.data(_5fe, "datagrid").options;
        var _601 = $.data(_5fe, "datagrid").updatedRows;
        var _602 = $.data(_5fe, "datagrid").insertedRows;
        var tr = opts.finder.getTr(_5fe, _5ff);
        var row = opts.finder.getRow(_5fe, _5ff);
        if (!tr.hasClass("datagrid-row-editing")) {
            return;
        }
        if (!_600) {
            if (!_5fc(_5fe, _5ff)) {
                return;
            }
            var _603 = false;
            var _604 = {};
            tr.find("div.datagrid-editable").each(function () {
                var _605 = $(this).parent().attr("field");
                var ed = $.data(this, "datagrid.editor");
                var _606 = ed.actions.getValue(ed.target);
                if (row[_605] != _606) {
                    row[_605] = _606;
                    _603 = true;
                    _604[_605] = _606;
                }
            });
            if (_603) {
                if (_502(_602, row) == -1) {
                    if (_502(_601, row) == -1) {
                        _601.push(row);
                    }
                }
            }
            opts.onEndEdit.call(_5fe, _5ff, row, _604);
        }
        tr.removeClass("datagrid-row-editing");
        _607(_5fe, _5ff);
        $(_5fe).datagrid("refreshRow", _5ff);
        if (!_600) {
            // datagrid by wanghc 2018-6-21
            if (opts.showChangedStyle) {
                for (var i in _604) {
                    tr.children('td[field="' + i + '"]').addClass('datagrid-value-changed');
                }
            }
            opts.onAfterEdit.call(_5fe, _5ff, row, _604);
        } else {
            opts.onCancelEdit.call(_5fe, _5ff, row);
        }
    };
    function _608(_609, _60a) {
        var opts = $.data(_609, "datagrid").options;
        var tr = opts.finder.getTr(_609, _60a);
        var _60b = [];
        tr.children("td").each(function () {
            var cell = $(this).find("div.datagrid-editable");
            if (cell.length) {
                var ed = $.data(cell[0], "datagrid.editor");
                _60b.push(ed);
            }
        });
        return _60b;
    };
    function _60c(_60d, _60e) {
        var _60f = _608(_60d, _60e.index != undefined ? _60e.index : _60e.id);
        for (var i = 0; i < _60f.length; i++) {
            if (_60f[i].field == _60e.field) {
                return _60f[i];
            }
        }
        return null;
    };
    function _5fa(_610, _611) {
        var opts = $.data(_610, "datagrid").options;
        var tr = opts.finder.getTr(_610, _611);
        tr.children("td").each(function () {
            var cell = $(this).find("div.datagrid-cell");
            var _612 = $(this).attr("field");
            var col = _558(_610, _612);
            if (col && col.editor) {
                var _613, _614;
                if (typeof col.editor == "string") {
                    _613 = col.editor;
                } else {
                    _613 = col.editor.type;
                    _614 = col.editor.options;
                }
                var _615 = opts.editors[_613];
                if (_615) {
                    var _616 = cell.html();
                    var _617 = cell._outerWidth();
                    cell.addClass("datagrid-editable");
                    cell._outerWidth(_617);
                    cell.html("<table border=\"0\" cellspacing=\"0\" cellpadding=\"1\"><tr><td></td></tr></table>");
                    cell.children("table").bind("click dblclick contextmenu", function (e) {
                        e.stopPropagation();
                    });
                    $.data(cell[0], "datagrid.editor", { actions: _615, target: _615.init(cell.find("td"), _614), field: _612, type: _613, oldHtml: _616 });
                }
            }
        });
        _526(_610, _611, true);
    };
    function _607(_618, _619) {
        var opts = $.data(_618, "datagrid").options;
        var tr = opts.finder.getTr(_618, _619);
        tr.children("td").each(function () {
            var cell = $(this).find("div.datagrid-editable");
            if (cell.length) {
                var ed = $.data(cell[0], "datagrid.editor");
                if (ed.actions.destroy) {
                    ed.actions.destroy(ed.target);
                }
                cell.html(ed.oldHtml);
                $.removeData(cell[0], "datagrid.editor");
                cell.removeClass("datagrid-editable");
                cell.css("width", "");
            }
        });
    };
    function _5fc(_61a, _61b) {
        var tr = $.data(_61a, "datagrid").options.finder.getTr(_61a, _61b);
        if (!tr.hasClass("datagrid-row-editing")) {
            return true;
        }
        var vbox = tr.find(".validatebox-text");
        vbox.validatebox("validate");
        vbox.trigger("mouseleave");
        var _61c = tr.find(".validatebox-invalid");
        return _61c.length == 0;
    };
    function _61d(_61e, _61f) {
        var _620 = $.data(_61e, "datagrid").insertedRows;
        var _621 = $.data(_61e, "datagrid").deletedRows;
        var _622 = $.data(_61e, "datagrid").updatedRows;
        if (!_61f) {
            var rows = [];
            rows = rows.concat(_620);
            rows = rows.concat(_621);
            rows = rows.concat(_622);
            return rows;
        } else {
            if (_61f == "inserted") {
                return _620;
            } else {
                if (_61f == "deleted") {
                    return _621;
                } else {
                    if (_61f == "updated") {
                        return _622;
                    }
                }
            }
        }
        return [];
    };
    function _623(_624, _625) {
        var _626 = $.data(_624, "datagrid");
        var opts = _626.options;
        var data = _626.data;
        var _627 = _626.insertedRows;
        var _628 = _626.deletedRows;
        $(_624).datagrid("cancelEdit", _625);
        var row = opts.finder.getRow(_624, _625);
        if (_502(_627, row) >= 0) {
            _503(_627, row);
        } else {
            _628.push(row);
        }
        _503(_626.selectedRows, opts.idField, row[opts.idField]);
        _503(_626.checkedRows, opts.idField, row[opts.idField]);
        opts.view.deleteRow.call(opts.view, _624, _625);
        if (opts.height == "auto") {
            _526(_624);
        }
        $(_624).datagrid("getPager").pagination("refresh", { total: data.total });
    };
    function _629(_62a, _62b) {
        var data = $.data(_62a, "datagrid").data;
        var view = $.data(_62a, "datagrid").options.view;
        var _62c = $.data(_62a, "datagrid").insertedRows;
        view.insertRow.call(view, _62a, _62b.index, _62b.row);
        _62c.push(_62b.row);
        $(_62a).datagrid("getPager").pagination("refresh", { total: data.total });
    };
    function _62d(_62e, row) {
        var data = $.data(_62e, "datagrid").data;
        var view = $.data(_62e, "datagrid").options.view;
        var _62f = $.data(_62e, "datagrid").insertedRows;
        view.insertRow.call(view, _62e, null, row);
        _62f.push(row);
        $(_62e).datagrid("getPager").pagination("refresh", { total: data.total });
    };
    function _630(_631) {
        var _632 = $.data(_631, "datagrid");
        var data = _632.data;
        var rows = data.rows;
        var _633 = [];
        for (var i = 0; i < rows.length; i++) {
            _633.push($.extend({}, rows[i]));
        }
        _632.originalRows = _633;
        _632.updatedRows = [];
        _632.insertedRows = [];
        _632.deletedRows = [];
    };
    function _634(_635) {
        var data = $.data(_635, "datagrid").data;
        var ok = true;
        for (var i = 0, len = data.rows.length; i < len; i++) {
            if (_5fc(_635, i)) {
                _5fd(_635, i, false);
            } else {
                ok = false;
            }
        }
        if (ok) {
            _630(_635);
        }
    };
    function _636(_637) {
        var _638 = $.data(_637, "datagrid");
        var opts = _638.options;
        var _639 = _638.originalRows;
        var _63a = _638.insertedRows;
        var _63b = _638.deletedRows;
        var _63c = _638.selectedRows;
        var _63d = _638.checkedRows;
        var data = _638.data;
        function _63e(a) {
            var ids = [];
            for (var i = 0; i < a.length; i++) {
                ids.push(a[i][opts.idField]);
            }
            return ids;
        };
        function _63f(ids, _640) {
            for (var i = 0; i < ids.length; i++) {
                var _641 = _5b7(_637, ids[i]);
                if (_641 >= 0) {
                    (_640 == "s" ? _5cb : _5d2)(_637, _641, true);
                }
            }
        };
        for (var i = 0; i < data.rows.length; i++) {
            _5fd(_637, i, true);
        }
        var _642 = _63e(_63c);
        var _643 = _63e(_63d);
        _63c.splice(0, _63c.length);
        _63d.splice(0, _63d.length);
        data.total += _63b.length - _63a.length;
        data.rows = _639;
        _578(_637, data);
        _63f(_642, "s");
        _63f(_643, "c");
        _630(_637);
    };
    function _577(_644, _645) {
        var opts = $.data(_644, "datagrid").options;
        if (_645) {
            opts.queryParams = _645;
        }
        var _646 = $.extend({}, opts.queryParams);
        if (opts.pagination) {
            $.extend(_646, { page: opts.pageNumber, rows: opts.pageSize });
        }
        if (opts.sortName) {
            $.extend(_646, { sort: opts.sortName, order: opts.sortOrder });
        }
        if (opts.onBeforeLoad.call(_644, _646) == false) {
            return;
        }
        $(_644).datagrid("loading");
        /**
         * cryze 2018-9-13 
         * 为啥要通过setTimeout(fn,0)这种方式调用,不理解  
         * 猜测：连续两次调用 第一次为url1,第二次为url2, 这种操作就可以都按url2获取数据了  
         * 矛盾点：queryParams是第一次按照第一次，第二次按照第二次  
         */
        setTimeout(function () {
            _647();
        }, 0);
        function _647() {
            var _648 = opts.loader.call(_644, _646, function (data) {
                setTimeout(function () {
                    $(_644).datagrid("loaded");
                }, 0);
                _578(_644, data);
                setTimeout(function () {
                    _630(_644);
                }, 0);
            }, function () {
                setTimeout(function () {
                    $(_644).datagrid("loaded");
                }, 0);
                opts.onLoadError.apply(_644, arguments);
            });
            if (_648 == false) {
                $(_644).datagrid("loaded");
            }
        };
    };
    function _649(_64a, _64b) {
        var opts = $.data(_64a, "datagrid").options;
        _64b.rowspan = _64b.rowspan || 1;
        _64b.colspan = _64b.colspan || 1;
        if (_64b.rowspan == 1 && _64b.colspan == 1) {
            return;
        }
        var tr = opts.finder.getTr(_64a, (_64b.index != undefined ? _64b.index : _64b.id));
        if (!tr.length) {
            return;
        }
        var row = opts.finder.getRow(_64a, tr);
        var _64c = row[_64b.field];
        var td = tr.find("td[field=\"" + _64b.field + "\"]");
        td.attr("rowspan", _64b.rowspan).attr("colspan", _64b.colspan);
        td.addClass("datagrid-td-merged");
        for (var i = 1; i < _64b.colspan; i++) {
            td = td.next();
            td.hide();
            row[td.attr("field")] = _64c;
        }
        for (var i = 1; i < _64b.rowspan; i++) {
            tr = tr.next();
            if (!tr.length) {
                break;
            }
            var row = opts.finder.getRow(_64a, tr);
            var td = tr.find("td[field=\"" + _64b.field + "\"]").hide();
            row[td.attr("field")] = _64c;
            for (var j = 1; j < _64b.colspan; j++) {
                td = td.next();
                td.hide();
                row[td.attr("field")] = _64c;
            }
        }
        _596(_64a);
    };
    $.fn.datagrid = function (_64d, _64e) {
        if (typeof _64d == "string") {
            return $.fn.datagrid.methods[_64d](this, _64e);
        }
        _64d = _64d || {};
        return this.each(function () {
            var _64f = $.data(this, "datagrid");
            var opts;
            if (_64f) {
                opts = $.extend(_64f.options, _64d);
                _64f.options = opts;
            } else {
                opts = $.extend({}, $.extend({}, $.fn.datagrid.defaults, { queryParams: {} }), $.fn.datagrid.parseOptions(this), _64d);
                $(this).css("width", "").css("height", "");
                var _650 = _53a(this, opts.rownumbers);
                if (!opts.columns) {
                    opts.columns = _650.columns;
                }
                if (!opts.frozenColumns) {
                    opts.frozenColumns = _650.frozenColumns;
                }
                opts.columns = $.extend(true, [], opts.columns);
                opts.frozenColumns = $.extend(true, [], opts.frozenColumns);
                opts.view = $.extend({}, opts.view);
                $.data(this, "datagrid", { options: opts, panel: _650.panel, dc: _650.dc, ss: null, selectedRows: [], checkedRows: [], data: { total: 0, rows: [] }, originalRows: [], updatedRows: [], insertedRows: [], deletedRows: [] });
            }
            _545(this);
            _559(this);
            _515(this);

            if (opts.data) {
                _578(this, opts.data);
                _630(this);
            } else {
                var data = $.fn.datagrid.parseData(this);
                if (data.total > 0) {
                    _578(this, data);
                    _630(this);
                }
            }
            if (!opts.lazy && opts.url) {   // lazy为true时  初始化不去远程访问数据  //cryze 2018-9-13  url未配置也不调用 
                _577(this);
            }

        });
    };
    var _651 = {
        text: {
            init: function (_652, _653) {
                var _654 = $("<input type=\"text\" class=\"datagrid-editable-input\">").appendTo(_652);
                return _654;
            }, getValue: function (_655) {
                return $(_655).val();
            }, setValue: function (_656, _657) {
                $(_656).val(_657);
            }, resize: function (_658, _659) {
                $(_658)._outerWidth(_659)._outerHeight(30);   //cryze 2018-4-13 height 22-30
            }
        }, textarea: {
            init: function (_65a, _65b) {
                var _65c = $("<textarea class=\"datagrid-editable-input\"></textarea>").appendTo(_65a);
                return _65c;
            }, getValue: function (_65d) {
                return $(_65d).val();
            }, setValue: function (_65e, _65f) {
                $(_65e).val(_65f);
            }, resize: function (_660, _661) {
                $(_660)._outerWidth(_661);
            }
        }, icheckbox: { /*新的icheckbox*/
            init: function (_662, _663) {
                var opt = $.extend({ on: 'on', off: 'off' }, _663);
                var _664 = $("<input type=\"checkbox\">").appendTo(_662);
                //_664.val(opt.on);
                //_664.attr("offval", opt.off);
                _664.checkbox(opt);
                return _664;
            }, getValue: function (_665) {
                if ($(_665).checkbox("getValue")) {
                    return $(_665).checkbox("options").on;
                } else {
                    return $(_665).checkbox("options").off;
                }
            }, setValue: function (_666, _667) {
                var _668 = false;
                if ($(_666).checkbox("options").on == _667) {
                    _668 = true;
                }
                $(_666).checkbox("setValue", _668);
            }
        }, checkbox: {
            init: function (_662, _663) {
                var _664 = $("<input type=\"checkbox\">").appendTo(_662);
                _664.val(_663.on);
                _664.attr("offval", _663.off);
                return _664;
            }, getValue: function (_665) {
                if ($(_665).is(":checked")) {
                    return $(_665).val();
                } else {
                    return $(_665).attr("offval");
                }
            }, setValue: function (_666, _667) {
                var _668 = false;
                if ($(_666).val() == _667) {
                    _668 = true;
                }
                $(_666)._propAttr("checked", _668);
            }
        }, numberbox: {
            init: function (_669, _66a) {
                var _66b = $("<input type=\"text\" class=\"datagrid-editable-input\">").appendTo(_669);
                _66b.numberbox(_66a);
                return _66b;
            }, destroy: function (_66c) {
                $(_66c).numberbox("destroy");
            }, getValue: function (_66d) {
                $(_66d).blur();
                return $(_66d).numberbox("getValue");
            }, setValue: function (_66e, _66f) {
                $(_66e).numberbox("setValue", _66f);
            }, resize: function (_670, _671) {
                $(_670)._outerWidth(_671)._outerHeight(30);  //cryze 2018-4-13 height 22-30
            }
        }, validatebox: {
            init: function (_672, _673) {
                var _674 = $("<input type=\"text\" class=\"datagrid-editable-input\">").appendTo(_672);
                _674.validatebox(_673);
                return _674;
            }, destroy: function (_675) {
                $(_675).validatebox("destroy");
            }, getValue: function (_676) {
                return $(_676).val();
            }, setValue: function (_677, _678) {
                $(_677).val(_678);
            }, resize: function (_679, _67a) {
                $(_679)._outerWidth(_67a)._outerHeight(30);   //cryze 2018-4-13 height 22-30
            }
        }, datebox: {
            init: function (_67b, _67c) {
                var _67d = $("<input type=\"text\">").appendTo(_67b);
                _67d.datebox(_67c);
                return _67d;
            }, destroy: function (_67e) {
                $(_67e).datebox("destroy");
            }, getValue: function (_67f) {
                return $(_67f).datebox("getValue");
            }, setValue: function (_680, _681) {
                $(_680).datebox("setValue", _681);
            }, resize: function (_682, _683) {
                $(_682).datebox("resize", _683);
            }
        }, datetimebox: {    //cryze  行编辑支持datetimebox  直接抄的datebox,变量都加了i,好像没啥意义，主要是看着他们都用的各自的变量名
            init: function (i_67b, i_67c) {
                var i_67d = $("<input type=\"text\">").appendTo(i_67b);
                i_67d.datetimebox(i_67c);
                return i_67d;
            }, destroy: function (i_67e) {
                $(i_67e).datetimebox("destroy");
            }, getValue: function (i_67f) {
                return $(i_67f).datetimebox("getValue");
            }, setValue: function (i_680, i_681) {
                $(i_680).datetimebox("setValue", i_681);
            }, resize: function (i_682, i_683) {
                $(i_682).datetimebox("resize", i_683);
            }
        }, combobox: {
            init: function (_684, _685) {
                var _686 = $("<input type=\"text\">").appendTo(_684);
                _686.combobox(_685 || {});
                return _686;
            }, destroy: function (_687) {
                $(_687).combobox("destroy");
            }, getValue: function (_688) {
                var opts = $(_688).combobox("options");
                if (opts.multiple) {
                    return $(_688).combobox("getValues").join(opts.separator);
                } else {
                    return $(_688).combobox("getValue");
                }
            }, setValue: function (_689, _68a) {
                var opts = $(_689).combobox("options");
                if (opts.multiple) {
                    if (_68a) {
                        $(_689).combobox("setValues", _68a.split(opts.separator));
                    } else {
                        $(_689).combobox("clear");
                    }
                } else {
                    $(_689).combobox("setValue", _68a);
                }
            }, resize: function (_68b, _68c) {
                $(_68b).combobox("resize", _68c);
            }
        }, combotree: {
            init: function (_68d, _68e) {
                var _68f = $("<input type=\"text\">").appendTo(_68d);
                _68f.combotree(_68e);
                return _68f;
            }, destroy: function (_690) {
                $(_690).combotree("destroy");
            }, getValue: function (_691) {
                var opts = $(_691).combotree("options");
                if (opts.multiple) {
                    return $(_691).combotree("getValues").join(opts.separator);
                } else {
                    return $(_691).combotree("getValue");
                }
            }, setValue: function (_692, _693) {
                var opts = $(_692).combotree("options");
                if (opts.multiple) {
                    if (_693) {
                        $(_692).combotree("setValues", _693.split(opts.separator));
                    } else {
                        $(_692).combotree("clear");
                    }
                } else {
                    $(_692).combotree("setValue", _693);
                }
            }, resize: function (_694, _695) {
                $(_694).combotree("resize", _695);
            }
        }, combogrid: {
            init: function (_696, _697) {
                var _698 = $("<input type=\"text\">").appendTo(_696);
                _698.combogrid(_697);
                return _698;
            }, destroy: function (_699) {
                $(_699).combogrid("destroy");
            }, getValue: function (_69a) {
                var opts = $(_69a).combogrid("options");
                if (opts.multiple) {
                    return $(_69a).combogrid("getValues").join(opts.separator);
                } else {
                    return $(_69a).combogrid("getValue");
                }
            }, setValue: function (_69b, _69c) {
                var opts = $(_69b).combogrid("options");
                if (opts.multiple) {
                    if (_69c) {
                        $(_69b).combogrid("setValues", _69c.split(opts.separator));
                    } else {
                        $(_69b).combogrid("clear");
                    }
                } else {
                    $(_69b).combogrid("setValue", _69c);
                }
            }, resize: function (_69d, _69e) {
                $(_69d).combogrid("resize", _69e);
            }
        }, linkbutton: { /*增加linkbutton by wanghc 2018-05-30*/
            //{colHandler:desc}
            init: function (_67b, _67c) {
                var _67d = $("<a href='#'></a>").appendTo(_67b);
                _67d.linkbutton(_67c);
                _67d.click(_67c.handler);
                return _67d;
            }, destroy: function (_67e) {
                //$(_67e).linkbutton("destroy");
            }, getValue: function (_67f) {
                return $(_67f).linkbutton("options").text;
            }, setValue: function (_680, _681) {
                $(_680).linkbutton("options").text = _681;
                $(_680).linkbutton({});
            }, resize: function (_682, _683) {
                //$(_682).linkbutton("resize", _683);
            }
        },
        switchbox: { /*增加switchbox by wanghc 2018-05-30*/
            init: function (_67b, _67c) {
                var _67d = $("<div href='#'></div>").appendTo(_67b);
                _67d.switchbox(_67c);
                return _67d;
            }, destroy: function (_67e) {
                $(_67e).switchbox("destroy");
            }, getValue: function (_67f) {
                if ($(_67f).switchbox("getValue")) {
                    return $(_67f).switchbox("options").onText;
                } else {
                    return $(_67f).switchbox("options").offText;
                }
            }, setValue: function (_680, _681) {
                //$(_680).switchbox("setActive",false);
                var flag = false;
                if ($(_680).switchbox("options").onText == _681) { flag = true }
                $(_680).switchbox("setValue", flag, false);
                //$(this).find(inputSelector).prop('checked', value).trigger('change', skipOnChange);
                //$(_680).switchbox("setActive",true);
            }, resize: function (_682, _683) {
                //$(_682).linkbutton("resize", _683);
            }
        }
    };
    $.fn.datagrid.methods = {
        options: function (jq) {
            var _69f = $.data(jq[0], "datagrid").options;
            var _6a0 = $.data(jq[0], "datagrid").panel.panel("options");
            var opts = $.extend(_69f, { width: _6a0.width, height: _6a0.height, closed: _6a0.closed, collapsed: _6a0.collapsed, minimized: _6a0.minimized, maximized: _6a0.maximized });
            return opts;
        }, setSelectionState: function (jq) {
            return jq.each(function () {
                _5af(this);
            });
        }, createStyleSheet: function (jq) {
            return _506(jq[0]);
        }, getPanel: function (jq) {
            return $.data(jq[0], "datagrid").panel;
        }, getPager: function (jq) {
            return $.data(jq[0], "datagrid").panel.children("div.datagrid-pager");
        }, getColumnFields: function (jq, _6a1) {
            return _557(jq[0], _6a1);
        }, getColumnOption: function (jq, _6a2) {
            return _558(jq[0], _6a2);
        }, resize: function (jq, _6a3) {
            return jq.each(function () {
                _515(this, _6a3);
            });
        }, load: function (jq, _6a4) {
            return jq.each(function () {
                var opts = $(this).datagrid("options");
                opts.pageNumber = 1;
                var _6a5 = $(this).datagrid("getPager");
                _6a5.pagination("refresh", { pageNumber: 1 });
                _577(this, _6a4);
            });
        }, reload: function (jq, _6a6) {
            return jq.each(function () {
                _577(this, _6a6);
            });
        }, reloadFooter: function (jq, _6a7) {
            return jq.each(function () {
                var opts = $.data(this, "datagrid").options;
                var dc = $.data(this, "datagrid").dc;
                if (_6a7) {
                    $.data(this, "datagrid").footer = _6a7;
                }
                if (opts.showFooter) {
                    opts.view.renderFooter.call(opts.view, this, dc.footer2, false);
                    opts.view.renderFooter.call(opts.view, this, dc.footer1, true);
                    if (opts.view.onAfterRender) {
                        opts.view.onAfterRender.call(opts.view, this);
                    }
                    $(this).datagrid("fixRowHeight");
                }
            });
        }, loading: function (jq) {
            return jq.each(function () {
                var opts = $.data(this, "datagrid").options;
                $(this).datagrid("getPager").pagination("loading");
                if (opts.loadMsg) {
                    var _6a8 = $(this).datagrid("getPanel");
                    if (!_6a8.children("div.datagrid-mask").length) {
                        $("<div class=\"datagrid-mask\" style=\"display:block\"></div>").appendTo(_6a8);
                        var msg = $("<div class=\"datagrid-mask-msg\" style=\"display:block;left:50%\"></div>").html(opts.loadMsg).appendTo(_6a8);
                        msg._outerHeight(40);
                        msg.css({ marginLeft: (-msg.outerWidth() / 2), lineHeight: (msg.height() + "px") });
                    }
                }
            });
        }, loaded: function (jq) {
            return jq.each(function () {
                $(this).datagrid("getPager").pagination("loaded");
                var _6a9 = $(this).datagrid("getPanel");
                _6a9.children("div.datagrid-mask-msg").remove();
                _6a9.children("div.datagrid-mask").remove();
            });
        }, fitColumns: function (jq) {
            return jq.each(function () {
                _579(this);
            });
        }, fixColumnSize: function (jq, _6aa) {
            return jq.each(function () {
                _542(this, _6aa);
            });
        }, fixRowHeight: function (jq, _6ab) {
            return jq.each(function () {
                _526(this, _6ab);
            });
        }, fixRowNumber: function (jq) {
            return jq.each(function () {
                var panel = $(this).datagrid("getPanel");
                //获取最后一行的number容器,并拷贝一份
                var clone = $(".datagrid-cell-rownumber", panel).last().clone();
                //由于在某些浏览器里面,是不支持获取隐藏元素的宽度,所以取巧一下
                clone.css({
                    "position": "absolute",
                    left: -1000
                }).appendTo("body");
                var width = clone.width("auto").width();
                //默认宽度是25,所以只有大于25的时候才进行fix
                if (width > 25) {
                    //多加5个像素,保持一点边距
                    $(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).width(width + 5);
                    //修改了宽度之后,需要对容器进行重新计算,所以调用resize
                    $(this).datagrid("resize");
                    //一些清理工作
                    clone.remove();
                    clone = null;
                } else {
                    //还原成默认状态
                    $(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).removeAttr("style");
                }
            });
        }, freezeRow: function (jq, _6ac) {
            return jq.each(function () {
                _533(this, _6ac);
            });
        }, autoSizeColumn: function (jq, _6ad) {
            return jq.each(function () {
                _586(this, _6ad);
            });
        }, loadData: function (jq, data) {
            return jq.each(function () {
                _578(this, data);
                _630(this);
            });
        }, getData: function (jq) {
            return $.data(jq[0], "datagrid").data;
        }, getRows: function (jq) {
            return $.data(jq[0], "datagrid").data.rows;
        }, getFooterRows: function (jq) {
            return $.data(jq[0], "datagrid").footer;
        }, getRowIndex: function (jq, id) {
            return _5b7(jq[0], id);
        }, getChecked: function (jq) {
            return _5bd(jq[0]);
        }, getSelected: function (jq) {
            var rows = _5ba(jq[0]);
            return rows.length > 0 ? rows[0] : null;
        }, getSelections: function (jq) {
            return _5ba(jq[0]);
        }, clearSelections: function (jq) {
            return jq.each(function () {
                var _6ae = $.data(this, "datagrid");
                var _6af = _6ae.selectedRows;
                var _6b0 = _6ae.checkedRows;
                _6af.splice(0, _6af.length);
                _5d1(this);
                if (_6ae.options.checkOnSelect) {
                    _6b0.splice(0, _6b0.length);
                }
            });
        }, clearChecked: function (jq) {
            return jq.each(function () {
                var _6b1 = $.data(this, "datagrid");
                var _6b2 = _6b1.selectedRows;
                var _6b3 = _6b1.checkedRows;
                _6b3.splice(0, _6b3.length);
                _5e5(this);
                if (_6b1.options.selectOnCheck) {
                    _6b2.splice(0, _6b2.length);
                }
            });
        }, scrollTo: function (jq, _6b4) {
            return jq.each(function () {
                _5c0(this, _6b4);
            });
        }, highlightRow: function (jq, _6b5) {
            return jq.each(function () {
                _5c7(this, _6b5);
                _5c0(this, _6b5);
            });
        }, selectAll: function (jq) {
            return jq.each(function () {
                _5da(this);
            });
        }, unselectAll: function (jq) {
            return jq.each(function () {
                _5d1(this);
            });
        }, selectRow: function (jq, _6b6) {
            return jq.each(function () {
                _5cb(this, _6b6);
            });
        }, selectRecord: function (jq, id) {
            return jq.each(function () {
                var opts = $.data(this, "datagrid").options;
                if (opts.idField) {
                    var _6b7 = _5b7(this, id);
                    if (_6b7 >= 0) {
                        $(this).datagrid("selectRow", _6b7);
                    }
                }
            });
        }, unselectRow: function (jq, _6b8) {
            return jq.each(function () {
                _5d3(this, _6b8);
            });
        }, checkRow: function (jq, _6b9) {
            return jq.each(function () {
                _5d2(this, _6b9);
            });
        }, uncheckRow: function (jq, _6ba) {
            return jq.each(function () {
                _5d9(this, _6ba);
            });
        }, checkAll: function (jq) {
            return jq.each(function () {
                _5df(this);
            });
        }, uncheckAll: function (jq) {
            return jq.each(function () {
                _5e5(this);
            });
        }, beginEdit: function (jq, _6bb) {
            return jq.each(function () {
                _5f7(this, _6bb);
            });
        }, endEdit: function (jq, _6bc) {
            return jq.each(function () {
                _5fd(this, _6bc, false);
            });
        }, cancelEdit: function (jq, _6bd) {
            return jq.each(function () {
                _5fd(this, _6bd, true);
            });
        }, getEditors: function (jq, _6be) {
            return _608(jq[0], _6be);
        }, getEditor: function (jq, _6bf) {
            return _60c(jq[0], _6bf);
        }, refreshRow: function (jq, _6c0) {
            return jq.each(function () {
                var opts = $.data(this, "datagrid").options;
                opts.view.refreshRow.call(opts.view, this, _6c0);
            });
        }, validateRow: function (jq, _6c1) {
            return _5fc(jq[0], _6c1);
        }, updateRow: function (jq, _6c2) {
            return jq.each(function () {
                var opts = $.data(this, "datagrid").options;
                opts.view.updateRow.call(opts.view, this, _6c2.index, _6c2.row);
            });
        }, appendRow: function (jq, row) {
            return jq.each(function () {
                _62d(this, row);
            });
        }, insertRow: function (jq, _6c3) {
            return jq.each(function () {
                _629(this, _6c3);
            });
        }, deleteRow: function (jq, _6c4) {
            return jq.each(function () {
                _623(this, _6c4);
            });
        }, getChanges: function (jq, _6c5) {
            return _61d(jq[0], _6c5);
        }, acceptChanges: function (jq) {
            return jq.each(function () {
                _634(this);
            });
        }, rejectChanges: function (jq) {
            return jq.each(function () {
                _636(this);
            });
        }, mergeCells: function (jq, _6c6) {
            return jq.each(function () {
                _649(this, _6c6);
            });
        }, showColumn: function (jq, _6c7) {
            return jq.each(function () {
                var _6c8 = $(this).datagrid("getPanel");
                _6c8.find("td[field=\"" + _6c7 + "\"]").show();
                $(this).datagrid("getColumnOption", _6c7).hidden = false;
                $(this).datagrid("fitColumns");
            });
        }, hideColumn: function (jq, _6c9) {
            return jq.each(function () {
                var _6ca = $(this).datagrid("getPanel");
                _6ca.find("td[field=\"" + _6c9 + "\"]").hide();
                $(this).datagrid("getColumnOption", _6c9).hidden = true;
                $(this).datagrid("fitColumns");
            });
        }, sort: function (jq, _6cb) {
            return jq.each(function () {
                _56c(this, _6cb);
            });
        }, setColumnTitle: function (jq, colOpt) {
            return jq.each(function () {
                var _69f = $.data($(this)[0], "datagrid").dc.header2;
                //var _6ca = $(this).datagrid("getPanel");
                for (var f in colOpt) {
                    _69f.find('.datagrid-header-row td[field="' + f + '"] .datagrid-cell span').first().html(colOpt[f]);
                }
            });
        }
    };
    $.fn.datagrid.parseOptions = function (_6cc) {
        var t = $(_6cc);
        return $.extend({}, $.fn.panel.parseOptions(_6cc), $.parser.parseOptions(_6cc, ["url", "toolbar", "btoolbar", "idField", "sortName", "sortOrder", "pagePosition", "resizeHandle", { sharedStyleSheet: "boolean", fitColumns: "boolean", autoRowHeight: "boolean", striped: "boolean", nowrap: "boolean" }, { rownumbers: "boolean", singleSelect: "boolean", ctrlSelect: "boolean", checkOnSelect: "boolean", selectOnCheck: "boolean" }, { pagination: "boolean", pageSize: "number", pageNumber: "number" }, { multiSort: "boolean", remoteSort: "boolean", showHeader: "boolean", showFooter: "boolean" }, { scrollbarSize: "number" }]), { pageList: (t.attr("pageList") ? eval(t.attr("pageList")) : undefined), loadMsg: (t.attr("loadMsg") != undefined ? t.attr("loadMsg") : undefined), rowStyler: (t.attr("rowStyler") ? eval(t.attr("rowStyler")) : undefined) });
    };
    $.fn.datagrid.parseData = function (_6cd) {
        var t = $(_6cd);
        var data = { total: 0, rows: [] };
        var _6ce = t.datagrid("getColumnFields", true).concat(t.datagrid("getColumnFields", false));
        t.find("tbody tr").each(function () {
            data.total++;
            var row = {};
            $.extend(row, $.parser.parseOptions(this, ["iconCls", "state"]));
            for (var i = 0; i < _6ce.length; i++) {
                row[_6ce[i]] = $(this).find("td:eq(" + i + ")").html();
            }
            data.rows.push(row);
        });
        return data;
    };
    var _6cf = {
        render: function (_6d0, _6d1, _6d2) {
            var _6d3 = $.data(_6d0, "datagrid");
            var opts = _6d3.options;
            var rows = _6d3.data.rows;
            var _6d4 = $(_6d0).datagrid("getColumnFields", _6d2);
            if (_6d2) {
                if (!(opts.rownumbers || (opts.frozenColumns && opts.frozenColumns.length))) {
                    return;
                }
            }
            if (rows.length > 0) {
                var _6d5 = ["<table class=\"datagrid-btable\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tbody>"];
                for (var i = 0; i < rows.length; i++) {
                    var css = opts.rowStyler ? opts.rowStyler.call(_6d0, i, rows[i]) : "";
                    var _6d6 = "";
                    var _6d7 = "";
                    if (typeof css == "string") {
                        _6d7 = css;
                    } else {
                        if (css) {
                            _6d6 = css["class"] || "";
                            _6d7 = css["style"] || "";
                        }
                    }
                    var cls = "class=\"datagrid-row " + (i % 2 && opts.striped ? "datagrid-row-alt " : " ") + _6d6 + "\"";
                    var _6d8 = _6d7 ? "style=\"" + _6d7 + "\"" : "";
                    var _6d9 = _6d3.rowIdPrefix + "-" + (_6d2 ? 1 : 2) + "-" + i;
                    _6d5.push("<tr id=\"" + _6d9 + "\" datagrid-row-index=\"" + i + "\" " + cls + " " + _6d8 + ">");
                    _6d5.push(this.renderRow.call(this, _6d0, _6d4, _6d2, i, rows[i]));
                    _6d5.push("</tr>");
                }
                _6d5.push("</tbody></table>");
                $(_6d1).html(_6d5.join(""));
            } else {
                // 增加判断,空数据增加滚动条 2018-12-20 wanghc
                $(_6d1).html("<div style='width:" + _6d3.dc.view2.find(".datagrid-header-row").width() + "px;border:solid 0px;height:1px;'></div>");
            }
        }, renderFooter: function (_6da, _6db, _6dc) {
            var opts = $.data(_6da, "datagrid").options;
            var rows = $.data(_6da, "datagrid").footer || [];
            var _6dd = $(_6da).datagrid("getColumnFields", _6dc);
            var _6de = ["<table class=\"datagrid-ftable\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tbody>"];
            for (var i = 0; i < rows.length; i++) {
                _6de.push("<tr class=\"datagrid-row\" datagrid-row-index=\"" + i + "\">");
                _6de.push(this.renderRow.call(this, _6da, _6dd, _6dc, i, rows[i]));
                _6de.push("</tr>");
            }
            _6de.push("</tbody></table>");
            $(_6db).html(_6de.join(""));
        }, renderRow: function (_6df, _6e0, _6e1, _6e2, _6e3) {
            /** 生成tr内的html: <td>...</td> */
            var opts = $.data(_6df, "datagrid").options;
            var cc = [];
            if (_6e1 && opts.rownumbers) {
                var _6e4 = _6e2 + 1;
                if (opts.pagination) {
                    _6e4 += (opts.pageNumber - 1) * opts.pageSize;
                }
                cc.push("<td class=\"datagrid-td-rownumber\"><div class=\"datagrid-cell-rownumber\">" + _6e4 + "</div></td>");
            }
            for (var i = 0; i < _6e0.length; i++) {
                var _6e5 = _6e0[i];
                var col = $(_6df).datagrid("getColumnOption", _6e5);
                if (col) {
                    var _6e6 = _6e3[_6e5];
                    var css = col.styler ? (col.styler(_6e6, _6e3, _6e2) || "") : "";
                    var _6e7 = "";
                    var _6e8 = "";
                    if (typeof css == "string") {
                        _6e8 = css;
                    } else {
                        if (css) {
                            _6e7 = css["class"] || "";
                            _6e8 = css["style"] || "";
                        }
                    }
                    var cls = _6e7 ? "class=\"" + _6e7 + "\"" : "";
                    var _6e9 = col.hidden ? "style=\"display:none;" + _6e8 + "\"" : (_6e8 ? "style=\"" + _6e8 + "\"" : "");
                    cc.push("<td field=\"" + _6e5 + "\" " + cls + " " + _6e9 + ">");
                    var _6e9 = "";
                    if (!col.checkbox) {
                        if (col.align) {
                            _6e9 += "text-align:" + col.align + ";";
                        }
                        if (!opts.nowrap) {
                            _6e9 += "white-space:normal;height:auto;";
                        } else {
                            if (opts.autoRowHeight) {
                                _6e9 += "height:auto;";
                            }
                        }
                    }
                    cc.push("<div style=\"" + _6e9 + "\" ");
                    cc.push(col.checkbox ? "class=\"datagrid-cell-check\"" : "class=\"datagrid-cell " + col.cellClass + "\"");
                    cc.push(">");
                    if (col.checkbox) {
                        cc.push("<input type=\"checkbox\" " + (_6e3.checked ? "checked=\"checked\"" : ""));
                        cc.push(" name=\"" + _6e5 + "\" value=\"" + (_6e6 != undefined ? _6e6 : "") + "\">");
                    } else {
                        if (col.formatter) {
                            cc.push(col.formatter(_6e6, _6e3, _6e2));
                        } else {
                            cc.push(_6e6);
                        }
                    }
                    cc.push("</div>");
                    cc.push("</td>");
                }
            }
            return cc.join("");
        }, refreshRow: function (_6ea, _6eb) {
            this.updateRow.call(this, _6ea, _6eb, {});
        }, updateRow: function (_6ec, _6ed, row) {
            var opts = $.data(_6ec, "datagrid").options;
            var rows = $(_6ec).datagrid("getRows");
            $.extend(rows[_6ed], row);
            var css = opts.rowStyler ? opts.rowStyler.call(_6ec, _6ed, rows[_6ed]) : "";
            var _6ee = "";
            var _6ef = "";
            if (typeof css == "string") {
                _6ef = css;
            } else {
                if (css) {
                    _6ee = css["class"] || "";
                    _6ef = css["style"] || "";
                }
            }
            var _6ee = "datagrid-row " + (_6ed % 2 && opts.striped ? "datagrid-row-alt " : " ") + _6ee;
            function _6f0(_6f1) {
                var _6f2 = $(_6ec).datagrid("getColumnFields", _6f1);
                var tr = opts.finder.getTr(_6ec, _6ed, "body", (_6f1 ? 1 : 2));
                var _6f3 = tr.find("div.datagrid-cell-check input[type=checkbox]").is(":checked");
                //wanghc 以前td有datagrid-value-changed样式的,还得加上 实现修改后小红三角
                //---start
                if (opts.showChangedStyle) {
                    var changedFields = [];
                    tr.children(".datagrid-value-changed").each(function () {
                        changedFields.push($(this).attr("field"));
                    });
                }
                //---end
                tr.html(this.renderRow.call(this, _6ec, _6f2, _6f1, _6ed, rows[_6ed]));
                //---start 加上样式
                if (opts.showChangedStyle) {
                    for (var i = 0; i < changedFields.length; i++) {
                        tr.children('td[field="' + changedFields[i] + '"]').addClass("datagrid-value-changed");
                    }
                }
                //---end
                // neer 2019-05-19 如果datagrid的配置项checkbox:true时且为可编辑表格时，endEdit调用时不能清空datagrid-row-checked状态d
                var isRowChecked = tr.hasClass('datagrid-row-checked');
                tr.attr("style", _6ef).attr("class", tr.hasClass("datagrid-row-selected") ? _6ee + " datagrid-row-selected" : _6ee)
                if (isRowChecked) { tr.addClass('datagrid-row-checked'); }
                if (_6f3) {
                    tr.find("div.datagrid-cell-check input[type=checkbox]")._propAttr("checked", true);
                }
            };
            _6f0.call(this, true); /** true表示number列 */
            _6f0.call(this, false); /**false表示内容列 */
            $(_6ec).datagrid("fixRowHeight", _6ed);
        }, insertRow: function (_6f4, _6f5, row) {
            var _6f6 = $.data(_6f4, "datagrid");
            var opts = _6f6.options;
            var dc = _6f6.dc;
            var data = _6f6.data;
            if (_6f5 == undefined || _6f5 == null) {
                _6f5 = data.rows.length;
            }
            if (_6f5 > data.rows.length) {
                _6f5 = data.rows.length;
            }
            function _6f7(_6f8) {
                var _6f9 = _6f8 ? 1 : 2;
                for (var i = data.rows.length - 1; i >= _6f5; i--) {
                    var tr = opts.finder.getTr(_6f4, i, "body", _6f9);
                    tr.attr("datagrid-row-index", i + 1);
                    tr.attr("id", _6f6.rowIdPrefix + "-" + _6f9 + "-" + (i + 1));
                    if (_6f8 && opts.rownumbers) {
                        var _6fa = i + 2;
                        if (opts.pagination) {
                            _6fa += (opts.pageNumber - 1) * opts.pageSize;
                        }
                        tr.find("div.datagrid-cell-rownumber").html(_6fa);
                    }
                    if (opts.striped) {
                        tr.removeClass("datagrid-row-alt").addClass((i + 1) % 2 ? "datagrid-row-alt" : "");
                    }
                }
            };
            function _6fb(_6fc) {
                var _6fd = _6fc ? 1 : 2;
                var _6fe = $(_6f4).datagrid("getColumnFields", _6fc);
                var _6ff = _6f6.rowIdPrefix + "-" + _6fd + "-" + _6f5;
                var tr = "<tr id=\"" + _6ff + "\" class=\"datagrid-row\" datagrid-row-index=\"" + _6f5 + "\"></tr>";
                if (_6f5 >= data.rows.length) {
                    if (data.rows.length) {
                        opts.finder.getTr(_6f4, "", "last", _6fd).after(tr);
                    } else {
                        var cc = _6fc ? dc.body1 : dc.body2;
                        cc.html("<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tbody>" + tr + "</tbody></table>");
                    }
                } else {
                    opts.finder.getTr(_6f4, _6f5 + 1, "body", _6fd).before(tr);
                }
            };
            _6f7.call(this, true);
            _6f7.call(this, false);
            _6fb.call(this, true);
            _6fb.call(this, false);
            data.total += 1;
            data.rows.splice(_6f5, 0, row);
            this.refreshRow.call(this, _6f4, _6f5);
        }, deleteRow: function (_700, _701) {
            var _702 = $.data(_700, "datagrid");
            var opts = _702.options;
            var data = _702.data;
            function _703(_704) {
                var _705 = _704 ? 1 : 2;
                for (var i = _701 + 1; i < data.rows.length; i++) {
                    var tr = opts.finder.getTr(_700, i, "body", _705);
                    tr.attr("datagrid-row-index", i - 1);
                    tr.attr("id", _702.rowIdPrefix + "-" + _705 + "-" + (i - 1));
                    if (_704 && opts.rownumbers) {
                        var _706 = i;
                        if (opts.pagination) {
                            _706 += (opts.pageNumber - 1) * opts.pageSize;
                        }
                        tr.find("div.datagrid-cell-rownumber").html(_706);
                    }
                    if (opts.striped) {
                        tr.removeClass("datagrid-row-alt").addClass((i - 1) % 2 ? "datagrid-row-alt" : "");
                    }
                }
            };
            opts.finder.getTr(_700, _701).remove();
            _703.call(this, true);
            _703.call(this, false);
            data.total -= 1;
            data.rows.splice(_701, 1);
        }, onBeforeRender: function (_707, rows) {
        }, onAfterRender: function (_708) {
            var opts = $.data(_708, "datagrid").options;
            if (opts.showFooter) {
                var _709 = $(_708).datagrid("getPanel").find("div.datagrid-footer");
                _709.find("div.datagrid-cell-rownumber,div.datagrid-cell-check").css("visibility", "hidden");
            }
        }
    };
    $.fn.datagrid.defaults = $.extend({}, $.fn.panel.defaults, {
        showChangedStyle: true, /*wanghc editor状态下,是否显示修改后的左上小红三角 */
        fixRowNumber: false, /*wanghc 行号列是否自动适应 */
        autoSizeColumn: true, /*wanghc 速度更新配置成false*/
        sharedStyleSheet: false, frozenColumns: undefined, columns: undefined, fitColumns: false, resizeHandle: "right", autoRowHeight: true,
        btoolbar: null, /* bottom tool bar*/
        toolbar: null, striped: false, method: "post", nowrap: true, idField: null, url: null, data: null, loadMsg: "Processing, please wait ...", rownumbers: false, singleSelect: false, ctrlSelect: false, selectOnCheck: true, checkOnSelect: true, pagination: false, pagePosition: "bottom", pageNumber: 1, pageSize: 10, pageList: [10, 20, 30, 40, 50], queryParams: {}, sortName: null, sortOrder: "asc", multiSort: false, remoteSort: true, showHeader: true, showFooter: false, scrollbarSize: 18, rowStyler: function (_70a, _70b) {
        }, loader: function (_70c, _70d, _70e) {
            var opts = $(this).datagrid("options");
            if (!opts.url) {
                return false;
            }
            $.ajax({
                type: opts.method, url: opts.url, data: _70c, dataType: "json", success: function (data) {
                    _70d(data);
                }, error: function () {
                    _70e.apply(this, arguments);
                }
            });
        }, loadFilter: function (data) {
            if (typeof data.length == "number" && typeof data.splice == "function") {
                return { total: data.length, rows: data };
            } else {
                return data;
            }
        }, editors: _651, finder: {
            getTr: function (_70f, _710, type, _711) {
                type = type || "body";
                _711 = _711 || 0;
                var _712 = $.data(_70f, "datagrid");
                var dc = _712.dc;
                var opts = _712.options;
                if (_711 == 0) {
                    var tr1 = opts.finder.getTr(_70f, _710, type, 1);
                    var tr2 = opts.finder.getTr(_70f, _710, type, 2);
                    return tr1.add(tr2);
                } else {
                    if (type == "body") {
                        var tr = $("#" + _712.rowIdPrefix + "-" + _711 + "-" + _710);
                        if (!tr.length) {
                            tr = (_711 == 1 ? dc.body1 : dc.body2).find(">table>tbody>tr[datagrid-row-index=" + _710 + "]");
                        }
                        return tr;
                    } else {
                        if (type == "footer") {
                            return (_711 == 1 ? dc.footer1 : dc.footer2).find(">table>tbody>tr[datagrid-row-index=" + _710 + "]");
                        } else {
                            if (type == "selected") {
                                return (_711 == 1 ? dc.body1 : dc.body2).find(">table>tbody>tr.datagrid-row-selected");
                            } else {
                                if (type == "highlight") {
                                    return (_711 == 1 ? dc.body1 : dc.body2).find(">table>tbody>tr.datagrid-row-over");
                                } else {
                                    if (type == "checked") {
                                        return (_711 == 1 ? dc.body1 : dc.body2).find(">table>tbody>tr.datagrid-row-checked");
                                    } else {
                                        if (type == "last") {
                                            return (_711 == 1 ? dc.body1 : dc.body2).find(">table>tbody>tr[datagrid-row-index]:last");
                                        } else {
                                            if (type == "allbody") {
                                                return (_711 == 1 ? dc.body1 : dc.body2).find(">table>tbody>tr[datagrid-row-index]");
                                            } else {
                                                if (type == "allfooter") {
                                                    return (_711 == 1 ? dc.footer1 : dc.footer2).find(">table>tbody>tr[datagrid-row-index]");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }, getRow: function (_713, p) {
                var _714 = (typeof p == "object") ? p.attr("datagrid-row-index") : p;
                return $.data(_713, "datagrid").data.rows[parseInt(_714)];
            }, getRows: function (_715) {
                return $(_715).datagrid("getRows");
            }
        }, view: _6cf, onBeforeLoad: function (_716) {
        }, onLoadSuccess: function () {
        }, onLoadError: function () {
        }, onClickRow: function (_717, _718) {
        }, onDblClickRow: function (_719, _71a) {
        }, onClickCell: function (_71b, _71c, _71d) {
        }, onDblClickCell: function (_71e, _71f, _720) {
        }, onBeforeSortColumn: function (sort, _721) {
        }, onSortColumn: function (sort, _722) {
        }, onResizeColumn: function (_723, _724) {
        }, onBeforeSelect: function (_725, _726) {
        }, onSelect: function (_725, _726) {
        }, onBeforeUnselect: function (_727, _728) {
        }, onUnselect: function (_727, _728) {
        }, onSelectAll: function (rows) {
        }, onUnselectAll: function (rows) {
        }, onBeforeCheck: function (_729, _72a) {
        }, onCheck: function (_729, _72a) {
        }, onBeforeUncheck: function (_72b, _72c) {
        }, onUncheck: function (_72b, _72c) {
        }, onCheckAll: function (rows) {
        }, onUncheckAll: function (rows) {
        }, onBeforeEdit: function (_72d, _72e) {
        }, onBeginEdit: function (_72f, _730) {
        }, onEndEdit: function (_731, _732, _733) {
        }, onAfterEdit: function (_734, _735, _736) {
        }, onCancelEdit: function (_737, _738) {
        }, onHeaderContextMenu: function (e, _739) {
        }, onRowContextMenu: function (e, _73a, _73b) {
        }, onDblClickHeader: function (e, _739) {    //cryze 双击表格头事件，默认
        }, lazy: false    //cryze 2018-3-22 为true初始化不加载列表数据
        , onHighlightRow: function (index, row) { //cryze datagrid 高亮行(鼠标悬浮和combogrid上下选时)触发事件
        }
    });
})(jQuery);

