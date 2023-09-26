/**
 * Created By SCL
 *
 * EasyUI for jQuery 1.11.3
 * 
 * Copyright (c) 2009-2018 www.jeasyui.com. All rights reserved.
 *
 * Licensed under the freeware license: http://www.jeasyui.com/license_freeware.php
 *
 */
(function($) {
	function bindEvent(target){
		var item = $.data(target, "simplydatagrid");
        var opts=item.options;
        var header=$(target).find(".datagrid-header-row");
        header.unbind('.simplydatagrid');
        for (var event in opts.headerEvents) {
            header.bind(event+'.simplydatagrid', opts.headerEvents[event]);
        }
        var bodytab=$(target).find("tbody tr");
        bodytab.unbind('.simplydatagrid');
        for (var event in opts.rowEvents) {
            bodytab.bind(event+'.simplydatagrid', opts.rowEvents[event]);
        }
        mousehover(target);
	}
	function mousehover(target){
		var id=target.id;
		//添加鼠标悬浮事件
	     $("table[id='" + id + "'] tbody tr").mouseover(function () {
	         $(this).addClass("datagrid-row-over");
	     }).mouseleave(function () {
	         $(this).removeClass("datagrid-row-over");
	     });
	}
	function headerClickHandler(e) {
		var ietmId=e.target.id;
		var tabId=ietmId.split("-")[0];
		var item = $.data($("#"+tabId)[0], "simplydatagrid");
		var opts=item.options;
		var ck = $(e.target).closest("input[type=checkbox]");
		if (ck.length) {
			if (opts.singleSelect && opts.selectOnCheck) {
                return false;
            }
            if (ck.is(":checked")) {
	            var checked=true;
	        }else{
		        var checked=false;
		    }
		    ChangeCheckAll($("#"+tabId)[0],checked);
		}
		e.stopPropagation();
    };
    //表格权限按钮改变事件
    function ChangeCheckAll(target,checkedValue){
	    var item = $.data(target, "simplydatagrid");
	    var opts=item.options;
	    var _$tr=$(target).find("tbody tr");
	    _$tr.removeClass("datagrid-row-checked").removeClass("datagrid-row-selected");
	    var hck=$(target).find(".datagrid-header-row input[type=checkbox]");
	    var bck =_$tr.find("div.cell-check input[type=checkbox]");
        hck.add(bck)._propAttr("checked", checkedValue);
        if (checkedValue) {
	        if (opts.selectOnCheck) {
		        _$tr.addClass("datagrid-row-selected").addClass("datagrid-row-checked");;
		    }
	    }
	}
	// 行点击
    function rowClickHandler(e){
	    var tr = getTr(e.target);
        if (!tr) {
            return;
        }
        var _$td=tr.find("div.cell-check input[type=checkbox]");
        if (_$td.attr("disabled")=="disabled") {
	        return;
	    }
        var tabTrget = getTabByTR(tr);
        var item = $.data(tabTrget, "simplydatagrid");
        var opts=item.options;
        var tt = $(e.target);
        var hck=$(tabTrget).find(".datagrid-header-row input[type=checkbox]");
	    //var bck =tr.find("div.cell-check input[type=checkbox]");
	    var checked=false;
        if (tt.parent().hasClass("cell-check")) {
	        var val=tt.is(":checked");
		    if (val) {
			    checked=val;
			    tr.addClass("datagrid-row-checked").addClass("datagrid-row-selected"); 
			}else{
				tr.removeClass("datagrid-row-checked").removeClass("datagrid-row-selected"); 
			}
	    }else{
		    if (tr.hasClass("datagrid-row-selected") || tr.hasClass("datagrid-row-checked")) {
			    tr.removeClass("datagrid-row-checked").removeClass("datagrid-row-selected");
			    _$td._propAttr("checked", false);
			}else{
				checked=true;
				tr.addClass("datagrid-row-checked").addClass("datagrid-row-selected");
			    _$td._propAttr("checked", true);
			}
		}
		
		var idArr=tr.find("td")[0].id.split("-");
		var index=idArr[idArr.length-1];
		var row=opts.data[index];
		if (checked) {
			opts.onCheck.apply($(tabTrget), [parseInt(index),row]);
		}else{
			opts.onUncheck.apply($(tabTrget), [parseInt(index),row]);
		}
		if ($(tabTrget).find("tr.datagrid-row-checked").length==opts.data.length) {
	    	hck._propAttr("checked", true);
	    }else{
		    hck._propAttr("checked", false);
		}
	}
	function getTr(t,_b4){
		var tr = $(t).closest(_b4 || "tr");
        if (tr.length && tr.parent().length) {
            return tr;
        } else {
            return undefined;
        }
	}
	function getTabByTR(t) {
        return $(t).closest(".simplydatagrid")[0];
    };
    /***********以下是方法************/
    function setTitle(targetTab,_title){
	    $(targetTab).parent().siblings(".panel-header").children(".panel-title")[0].innerHTML=_title;
	}
    //勾选一行
    function checkRow(targetTab,index){
	    var _$tab=$(targetTab);
	    var _$tr=_$tab.find("tbody tr");
	    var _$rowtr=$(_$tr[index]);
	    var bck =_$rowtr.find("div.cell-check input[type=checkbox]");
	    bck._propAttr("checked", true);
	    var item = $.data(_$tab[0], "simplydatagrid");
        var opts=item.options; 
        if (opts.selectOnCheck) {
	        _$rowtr.addClass("datagrid-row-selected").addClass("datagrid-row-checked");
	    }
	    var hck=_$tab.find(".datagrid-header-row input[type=checkbox]");
	    if (_$tab.find("tr.datagrid-row-checked").length==opts.data.length) {
	    	hck._propAttr("checked", true);
	    }else{
		    hck._propAttr("checked", false);
		}
	}
	//取消勾选一行
	function uncheckRow(targetTab,index){
		var _$tab=$(targetTab);
		var _$tr=_$tab.find("tbody tr");
	    var _$rowtr=$(_$tr[index]);
	    var bck =_$rowtr.find("div.cell-check input[type=checkbox]");
	    bck._propAttr("checked", false);
	    var item = $.data(_$tab[0], "simplydatagrid");
        var opts=item.options; 
	    _$rowtr.removeClass("datagrid-row-selected").removeClass("datagrid-row-checked");
	    var hck=_$tab.find(".datagrid-header-row input[type=checkbox]");
		//hck._propAttr("checked", false);
		var hck=_$tab.find(".datagrid-header-row input[type=checkbox]");
	    if (_$tab.find("tr.datagrid-row-checked").length==0) {
	    	hck._propAttr("checked", false);
	    }
	}
	//全选
	function checkAll(targetTab){
		var _$tab=$(targetTab);
		var _$tr=_$tab.find("tbody tr");
		var bck =_$tr.find("div.cell-check input[type=checkbox]");
		var hck=_$tab.find(".datagrid-header-row input[type=checkbox]");
		hck.add(bck)._propAttr("checked", true);
		 _$tr.addClass("datagrid-row-selected").addClass("datagrid-row-checked");
	}
	//取消全选
	function uncheckAll(targetTab){
		var _$tab=$(targetTab);
		var _$tr=_$tab.find("tbody tr");
		var bck =_$tr.find("div.cell-check input[type=checkbox]");
		var hck=_$tab.find(".datagrid-header-row input[type=checkbox]");
		hck.add(bck)._propAttr("checked", false);
		 _$tr.removeClass("datagrid-row-selected").removeClass("datagrid-row-checked");
	}
	function getRows(_$tab){
		var item = $.data(_$tab[0], "simplydatagrid");
        var opts=item.options;
        return opts.data;
	}
	//在复选框呗选中的时候返回所有行
	function getChecked(targetTab){
		var item = $.data(targetTab, "simplydatagrid");
        var opts = item.options;
        var data = opts.data;
        var rows = [];
        var _$ck = $(targetTab).find("tbody div.cell-check input[type=checkbox]");
        for (var _$i=0;_$i<_$ck.length;_$i++){
	        if ($(_$ck[_$i]).is(":checked")) {
		        var _$td=$(_$ck[_$i]).parents("td");
		        var idArr=_$td[0].id.split("-");
				var index=idArr[idArr.length-1];
				rows.push(data[index]);
		    }
		}
	    return rows;
	}
	//返回所有被选中的行，当没有记录被选中的时候将返回一个空数组
	function getSelections(targetTab){
		var item = $.data(targetTab, "simplydatagrid");
        var opts = item.options;
        var data = opts.data;
        var rows = [];
        var _$chk=$(targetTab).find("tbody tr.datagrid-row-checked");
	    for (var _$i=0;_$i<_$chk.length;_$i++){
		    var _$td=$(_$chk[_$i]).children("td");
	        var idArr=_$td[0].id.split("-");
			var index=idArr[idArr.length-1];
			rows.push(data[index]);
		}
	    return rows;
	}
	function getRowIndex(targetTab,row){
		var item = $.data(targetTab, "simplydatagrid");
        var opts = item.options;
        var rows = opts.data;
        if (typeof row == "object") {
	        return $.hisui.indexOfArray(rows, row);
	    }else{
		    for (var i = 0; i < rows.length; i++) {
                if (rows[i][opts.idField] == row) {
                    return i;
                }
            }
            return - 1; 
		}
	}
	/***********以上是方法************/
    function init(target,opts) {
		  var _1f1=$(target);
		  var _1f2=_1f1.parent();
		  var _1f3 = $('<div class="panel-header"><div class="panel-title">' + opts.title + "</div></div>").prependTo(_1f2);
		  _1f3.addClass(opts.headerCls);
		  if (!opts.border){ 
		  	 _1f3.addClass("panel-header-noborder");
		  }
		  var _1f4=$('<div class="panel-body"></div>').appendTo(_1f2);
		  _1f4.append($(target));
		  if (!opts.border){ 
		  	 _1f4.addClass("panel-body-noborder");
		  }
		  var columns = opts.columns;
	       columns=columns[0];
		  var hidl={} //隐藏的列
		  var ListRowData={} //列数据标题和顺序
		  var CheckRow={} //勾选的列
		  var th=[];
		  var CheckCode=""
		  $.each(columns,function(row,data){
			  var o = columns[row];
			 var code=o.field;
			 var check=false;
			 if (o.checkbox) {
				 CheckRow[code]='true';
				 check=true;
			 }
			 var display="" //"width: "+(o.width?o.width+"px;":40+"px;");
			 if (o.hidden) {
				 display=display+' display:none;';hidl[code]="Y"
			 }
			 if (check){
			 	th.push("<th style='width:15px;'><input id='"+opts.id+"-"+code+"-CheckAll' type='checkbox'></input></th>"); //
			 }else{
				th.push("<th style='"+display+"'>"+data.title+"</th>");
			 }
			 ListRowData[code]=o;
		  })
		  $("<thead><tr class='datagrid-header-row'>"+th.join('')+"</tr></thead>").appendTo(_1f1)
		  $.each(opts.data,function(row,jsondata){
			  if (jsondata){
					var onerow ={}
					$.each(jsondata,function(code,data){
						onerow[code]=data
					})	
					var rowadd=[];
					$.each(ListRowData,function(code,data){
						if (code==""){return}
						var display=hidl[code]?'display:none;':"";
						
						var c = "",u="";
						var l = opts.rowStyler ? opts.rowStyler.call(this,row, onerow) : "";
						"string" == typeof l ? u = l: l && (c = l["class"] || "", u = l.style || "");
						if (data.formatter) {
							rowadd.push("<td class='"+c+"' id="+code+"-z-"+row+" style='"+display+l+"'>"+(data.formatter(onerow[code],onerow,row)?data.formatter(onerow[code],onerow,row):onerow[code])+"</td>");
						}else{
							if (CheckRow[code]){
								rowadd.push("<td class='"+c+"' id="+code+"-z-"+row+" style='"+display+l+"'><div class='cell-check'><input type='checkbox'></div></input></td>"); //onclick=onCheckRow('"+opts.id+"','"+row+"')
							}else{
								rowadd.push("<td class='"+c+"' id="+code+"-z-"+row+" style='"+display+l+"'>"+onerow[code]+"</td>");	
							}
						}
					})
					rowadd="<tr>"+rowadd.join('')+"</tr>";
					if (rowadd!=""){
						_1f1.append(rowadd);
					}	
				}
		})
		//$(target).appendTo($("<div></div>"))
	    return $(target);
    }
    $.fn.simplydatagrid = function(options, param) {
        if (typeof options == "string") {
            return $.fn.simplydatagrid.methods[options](this, param);
        }
        options = options || {};
        return this.each(function() {
            var state  = $.data(this, "simplydatagrid");
            var opts;
            if (state) {
                opts = $.extend(state.options, options);
                state.options = opts;
            } else {
                state = $.data(this, 'simplydatagrid', {
                    options: $.extend({}, $.fn.simplydatagrid.defaults, $.fn.simplydatagrid.parseOptions(this), options),
                    bar: init(this,options)
                });
            }
            //绑定事件
            bindEvent(this);
        });
    };
    
    $.fn.simplydatagrid.methods = {
        options: function(jq) {
            var _1de = $.data(jq[0], "simplydatagrid").options;
            return _1de;
            /*var _1df = $.data(jq[0], "simplydatagrid").panel.panel("options");
            var opts = $.extend(_1de, {
                width: _1df.width,
                height: _1df.height,
                closed: _1df.closed,
                collapsed: _1df.collapsed,
                minimized: _1df.minimized,
                maximized: _1df.maximized
            });
            return opts;*/
        },
        checkRow: function(jq, _1f8) {
            return jq.each(function() {
                checkRow(this, _1f8);
            });
        },
        uncheckRow: function(jq, _1f9) {
            return jq.each(function() {
                uncheckRow(this, _1f9);
            });
        },
        getRows: function(jq, _1f9) {
            return getRows(jq);
        },
        getChecked: function(jq) {
            return getChecked(jq[0]);
        },
        getSelections: function(jq) {
	        return getSelections(jq[0]);
        },
        checkAll:function(jq){
	        return jq.each(function() {
                checkAll(this);
            });	        
	    },
	    uncheckAll:function(jq){
		    return jq.each(function() {
                uncheckAll(this);
            });
	    },
	    getRowIndex: function(jq, id) {
            return getRowIndex(jq[0], id);
        },
        setTitle: function(jq, _1f9) {
            return jq.each(function() {
                setTitle(this, _1f9);
            });
        }
    };
    $.fn.simplydatagrid.parseOptions = function(target) {
        return $.extend({}, $.parser.parseOptions(target, ['width','height','text',{value:'number'}]));
    };

    $.fn.simplydatagrid.defaults = {
	    id:"",
	    title:"",
	    headerCls:"",
        columns: undefined,
        idField: null,
        data: null,
        singleSelect: false,
        ctrlSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        showHeader: true,
        headerEvents: {
            click: headerClickHandler,
        },
        rowEvents: {
            click: rowClickHandler
        },
        rowStyler: function(index,row) {},
        onClickRow: function(index, row) {},
        onSelect: function(_index, row) {},
        onUnselect: function(index, row) {},
        onSelectAll: function(rows) {},
        onUnselectAll: function(rows) {},
        onCheck: function(index, row) {},
        onUncheck: function(index, row) {},
        onCheckAll: function(rows) {},
        onUncheckAll: function(rows) {}
     }
     //注册自定义easyui插件simplydatagrid
     //$.parser.plugins.push("simplydatagrid");
})(jQuery);