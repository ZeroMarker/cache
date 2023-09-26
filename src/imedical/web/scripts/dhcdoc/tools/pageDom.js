/**
 * easyui-tool - jQuery EasyUI Extend LIB
 * 
 * Copyright (c) 2019-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-11-20
 * 
 */
(function($,window,document){
	$.extend({ DHCDoc: {} }); 
	
	/**
	 * 参数变量
	 */
	var ParaObj = {
		keyJson: {
			F1:112,F2:113,F3:114,F4:115,F5:116,
			F6:117,F7:118,F8:119,F9:120,F10:121,
			F11:122,F12:123
		},
		keyValueJson: {
			112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",
			117:"F6",118:"F7",119:"F8",120:"F9",121:"F10",
			122:"F11",123:"F12"
		},
		focusJumpObj: undefined,
		mustFillObj: undefined
		
	};
	
	/**
	 *
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 * @return 1/0
	 */
	function hasCache (pageCode, domSelector) {
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "HasCache",
			pageCode: pageCode,
			domSelector: domSelector
		},false);
		
		return responseText;
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 * @return 0: success
	 */
	function storageCache (pageCode, domSelector) {
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		
		var rtnObj = {}
		var $nodes = $(domSelector);
		for (var i=0; i< $nodes.length; i++){
			var domId = $nodes[i]['id']||"";
			if (domId == "") {
				continue;
			}
			var componentType = getComponentType(domId)
			var isJump = supportJump(componentType);
			var domName = "";
			var _$label = $("label[for="+domId+"]");
			if (_$label.length > 0){
			   domName = _$label[0].innerHTML;
			}
			domName = domName + "^" + componentType + "^" + isJump;
			rtnObj[domId] = domName;
		}
		var domJson = JSON.stringify(rtnObj);
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "StorageCache",
			pageCode: pageCode,
			domJson: domJson,
			domSelector: domSelector
		},false);
		return responseText;
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 */
	function validateMustFill (pageCode,domSelector) {
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		
		if (!ParaObj.mustFillObj) {
			var responseText = $.m({
				ClassName: "web.DHCDocPageDom",
				MethodName: "GetMustFillDom",
				pageCode: pageCode,
				domSelector: domSelector
			},false);
			if (responseText == "") {
				return true;
			}
			var mustFillJson = JSON.parse(responseText);
			ParaObj.mustFillObj = mustFillJson;
		} else {
			var mustFillJson = ParaObj.mustFillObj;
		}
		
		var msg = "",FocusName="";
		for (var key in mustFillJson){
	　　　　var id = key;
			var text = mustFillJson[key];
			var cValue = getValue(id);	//getValue 方法待实现
			if (cValue == "") {
				if (msg == "") msg = text,FocusName=id;
				else msg = msg + " , " + text;
			}
	　　}
		
		if (msg != ""){
			$.messager.alert("提示","请输入：<font color=red>" + msg + "</font> !","info", function(){
				setFocus(FocusName);
			});
			return false;
		}
		return true;
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 * @param {*} domId 
	 */
	function domFocusJump (pageCode,domSelector,domId) {
		if (!ParaObj.focusJumpObj) {
			var responseText = $.m({
				ClassName:"web.DHCDocPageDom",
				MethodName:"GetFocusJumpDom",
				pageCode:pageCode,
				domSelector:domSelector
			},false);
			if (responseText == "") {
				return true;
			}
			ParaObj.focusJumpObj = JSON.parse(responseText);
			var mustFillJson = JSON.parse(responseText);
		} else {
			var mustFillJson = ParaObj.focusJumpObj;
		}
		var domIdx = findDomIndex(mustFillJson, domId);
		if (domIdx != "") {
			domIdx = parseInt(domIdx)
			if (mustFillJson[domIdx+1]) {
				var nextDomId = mustFillJson[domIdx+1];
			} else {
				var nextDomId = mustFillJson[0]||"";
			}
			setFocus(nextDomId);
		}
	}
	
	/**
	 * 
	 * @param {*} mustFillJson 
	 * @param {*} domId 
	 */
	function findDomIndex (mustFillJson, domId) {
		var findIdx = ""
		for (var key in mustFillJson) {
	　　　　var idx = key;
			var val = mustFillJson[key];
			if (val == domId) {
				findIdx = idx;
				break;
			}
		}
		return findIdx;
	}
	
	/**
	 * 
	 * @param {*} id 
	 */
	function supportJump(componentType){
		componentType = componentType||"";
		
		if (componentType == "lookup") {
			return 0;
		}else if (componentType == "button") {
			return 0;
		} else if( componentType == "radio") {
			return 0;
		} else if(componentType == "checkbox") {
			return 0;
		} else {
			return 1;
		}
	}
	
	/**
	 * 
	 * @param {*} id 
	 */
	function getComponentType(id){
		var className = $("#"+id).attr("class")||"";
		
		if (className == "") {
			return "text";
		}else if ((className.indexOf("hisui-lookup")>=0)||(className.indexOf("lookup-text")>=0)) {
			return "lookup";
		} else if( className.indexOf("combobox-f") >=0 ) {
			return "combobox";
		} else if((className.indexOf("hisui-datebox")>=0)||(className.indexOf("datebox-f")>=0)) {
			return "datebox";
		} else if (className.indexOf("hisui-linkbutton")>=0) {
			return "button";
		} else if (className.indexOf("hisui-radio")>=0) {
			return "radio";
		} else if (className.indexOf("hisui-checkbox")>=0) {
			return "checkbox";
		} else {
			return "text";
		}
	}
	
	/**
	 * 
	 * @param {*} id 
	 */
	function getValue(id){
		var className = $("#"+id).attr("class");
		if (typeof className == "undefined") {
			return $("#"+id).val()
		}
		if (className.indexOf("hisui-lookup")>=0) {
			var txt=$("#"+id).lookup("getText")
			//如果放大镜文本框的值为空,则返回空值
			if(txt!="") { 
				var val=$("#"+id).val()
			} else {
				var val=""
				$("#"+id+"Id").val("")
			}
			return val
		} else if( className.indexOf("combobox-f") >=0 ) { //hisui-combobox
			var val = $("#"+id).combobox("getValue")
			if (typeof val == "undefined") val=""
			return val
		} else if(className.indexOf("hisui-datebox")>=0) {
			return $("#"+id).datebox("getValue")
		} else {
			return $("#"+id).val()
		}
		return ""
	}
	
	/**
	 * 
	 * @param {*} id 
	 */
	function setFocus(id) {
		if (id == "") {
			return false;
		}
		var className = $("#"+id).attr("class")
		if(typeof className == "undefined"){
			$("#"+id).focus();
		} else if (("^"+className+"^").indexOf(("combo"))>=0){
			$("#"+id).next('span').find('input').focus();
		} else {
			$("#"+id).focus();
		}
	}
	
	/**
	 * 
	 * @param {*} keyCode 
	 * @param {*} cDomId 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 */
	function keyDown (keyCode,cDomId,pageCode,domSelector) {
		//
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		if (keyCode==13) {
			return $.DHCDoc.domFocusJump(pageCode,domSelector,cDomId)
		} else {
			var responseText = $.m({
				ClassName: "web.DHCDocPageDom",
				MethodName: "GetShortKey",
				pageCode: pageCode
			},false);
			
			var keyObj = {};
			if (responseText != "") {
				keyObj = JSON.parse(responseText);
			}
			if (ParaObj.keyValueJson[keyCode]) {
				var cKey = ParaObj.keyValueJson[keyCode];
				if (keyObj[cKey]) {
					var callback = keyObj[cKey];
					if ((callback)&&(callback!="")) {
						window[callback].call(this)
					}
					
				}
				
			}
		}
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 */
	function setKeyDesc (pageCode,domSelector) {
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "GetKeyDesc",
			pageCode: pageCode
		},false);
		
		var keyObj = {};
		if (responseText != "") {
			keyObj = JSON.parse(responseText);
			for(var key  in keyObj){
				(function(id, text){
					if (text!="") {
						setTimeout(function () {
							$("#"+key).text(keyObj[key]);
							$("#"+id).linkbutton({text:text});
						},10)
					}
				})(key, keyObj[key]);
			}
		}
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 */
	function setMousePois (pageCode,domSelector) {
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "GetMousePois",
			pageCode: pageCode,
			domSelector: domSelector
		},false);
		
		if (responseText!="") {
			setTimeout(function () {
				setFocus(responseText);
			},50);
		} 
		
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 */
	function InitCache (pageCode,domSelector) {
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		
		var hasCache = $.DHCDoc.hasCache();
		if (hasCache!=1) {
			$.DHCDoc.storageCache();
		}
	}
	
	/**
	 * 
	 * @param {*} pageCode 
	 * @param {*} domSelector 
	 */
	function extendHISUI(pageCode,domSelector){
		pageCode = pageCode||ServerObj.pageCode,
		domSelector = domSelector||ServerObj.domSelector;
		
		$HUI.combobox(".combobox-f", {
			keyHandler:{
				left: function (e) {
					return false;
				},
				right: function (e) {
					return false;
				},
				up: function (e) {
					nav(this,'prev');
					e.preventDefault();
				 },
				 down: function (e) {
					var Data=$(this).combobox("getData");
					var CurValue=$(this).combobox("getValue");
					if ($(this).combobox('panel').is(":hidden")){
						$(this).combobox('showPanel');
						return false;
					}
					nav(this,'next');
					e.preventDefault();
				},
				query: function (q, e) {
					_8c0(this, q);
				},
				enter: function (e) { 
					_8c5(this);
					var id=$(this)[0].id;
					return $.DHCDoc.domFocusJump(pageCode,domSelector,id)
				}
			}
		})
		
		$HUI.datebox(".datebox-f", {
			keyHandler:{
				enter: function (e) { 
					var id=$(this)[0].id;
					return $.DHCDoc.domFocusJump(pageCode,domSelector,id)
				}
			}
		})
		
	}
	
	/**
	 * 
	 * @desc：HISUI 扩展方法
	 */
	var _89b = 0;
	function _89c(_89d, _89e) {
		var _89f = $.data(_89d, "combobox");
		var opts = _89f.options;
		var data = _89f.data;
		for (var i = 0; i < data.length; i++) {
			if (data[i][opts.valueField] == _89e) {
				return i;
			}
		}
		return -1;
	};
	function _8a0(_8a1, _8a2) {
		var opts = $.data(_8a1, "combobox").options;
		var _8a3 = $(_8a1).combo("panel");
		var item = opts.finder.getEl(_8a1, _8a2);
		if (item.length) {
			if (item.position().top <= 0) {
				var h = _8a3.scrollTop() + item.position().top;
				_8a3.scrollTop(h);
			} else {
				if (item.position().top + item.outerHeight() > _8a3.height()) {
					var h = _8a3.scrollTop() + item.position().top + item.outerHeight() - _8a3.height();
					_8a3.scrollTop(h);
				}
			}
		}
	};
	function nav(_8a4, dir) {
		var opts = $.data(_8a4, "combobox").options;
		var _8a5 = $(_8a4).combobox("panel");
		var item = _8a5.children("div.combobox-item-hover");
		if (!item.length) {
			item = _8a5.children("div.combobox-item-selected");
		}
		item.removeClass("combobox-item-hover");
		var _8a6 = "div.combobox-item:visible:not(.combobox-item-disabled):first";
		var _8a7 = "div.combobox-item:visible:not(.combobox-item-disabled):last";
		if (!item.length) {
			item = _8a5.children(dir == "next" ? _8a6 : _8a7);
		} else {
			if (dir == "next") {
				item = item.nextAll(_8a6);
				if (!item.length) {
					item = _8a5.children(_8a6);
				}
			} else {
				item = item.prevAll(_8a6);
				if (!item.length) {
					item = _8a5.children(_8a7);
				}
			}
		}
		if (item.length) {
			item.addClass("combobox-item-hover");
			var row = opts.finder.getRow(_8a4, item);
			if (row) {
				_8a0(_8a4, row[opts.valueField]);
				if (opts.selectOnNavigation) {
					_8a8(_8a4, row[opts.valueField]);
				}
			}
		}
	};
	function _8a8(_8a9, _8aa) {
		var opts = $.data(_8a9, "combobox").options;
		var _8ab = $(_8a9).combo("getValues");
		if ($.inArray(_8aa + "", _8ab) == -1) {
			if (opts.multiple) {
				_8ab.push(_8aa);
			} else {
				_8ab = [_8aa];
			}
			_8ac(_8a9, _8ab);
			opts.onSelect.call(_8a9, opts.finder.getRow(_8a9, _8aa));
		}
	};
	function _8ad(_8ae, _8af) {
		var opts = $.data(_8ae, "combobox").options;
		var _8b0 = $(_8ae).combo("getValues");
		var _8b1 = $.inArray(_8af + "", _8b0);
		if (_8b1 >= 0) {
			_8b0.splice(_8b1, 1);
			_8ac(_8ae, _8b0);
			opts.onUnselect.call(_8ae, opts.finder.getRow(_8ae, _8af));
		}
	};
	function _8ac(_8b2, _8b3, _8b4) {
		var opts = $.data(_8b2, "combobox").options;
		var _8b5 = $(_8b2).combo("panel");
		if (!$.isArray(_8b3)){_8b3 = _8b3.split(opts.separator)}
		_8b5.find("div.combobox-item-selected").removeClass("combobox-item-selected");
		var vv = [], ss = [];
		for (var i = 0; i < _8b3.length; i++) {
			var v = _8b3[i];
			var s = v;
			opts.finder.getEl(_8b2, v).addClass("combobox-item-selected");
			var row = opts.finder.getRow(_8b2, v);
			if (row) { 
				s = row[opts.textField];
			}else{
				
			}
			vv.push(v);
			ss.push(s);
		}
		$(_8b2).combo("setValues", vv);
		if (!_8b4) {
			$(_8b2).combo("setText", ss.join(opts.separator));
		}
		if(opts.rowStyle && opts.rowStyle=='checkbox'){ 
			
			var tmpLen = $.data(_8b2, "combobox").data.length;
			if (vv.length==tmpLen){
				_8b5.parent().children("._hisui_combobox-selectall").addClass("checked");
			}else{
				_8b5.parent().children("._hisui_combobox-selectall").removeClass("checked");
			}
		}
	};
	function _8b6(_8b7, data, _8b8) {
		var _8b9 = $.data(_8b7, "combobox");
		var opts = _8b9.options;
		_8b9.data = opts.loadFilter.call(_8b7, data);
		_8b9.groups = [];
		data = _8b9.data;
		var _8ba = $(_8b7).combobox("getValues");
		var dd = [];
		var _8bb = undefined;
		for (var i = 0; i < data.length; i++) {
			var row = data[i];
			var v = row[opts.valueField] + "";
			var s = row[opts.textField];
			var g = row[opts.groupField];
			if (g) {
				if (_8bb != g) {
					_8bb = g;
					_8b9.groups.push(g);
					dd.push("<div id=\"" + (_8b9.groupIdPrefix + "_" + (_8b9.groups.length - 1)) + "\" class=\"combobox-group\">");
					dd.push(opts.groupFormatter ? opts.groupFormatter.call(_8b7, g) : g);
					dd.push("</div>");
				}
			} else {
				_8bb = undefined;
			}
			var cls = "combobox-item" + (row.disabled ? " combobox-item-disabled" : "") + (g ? " combobox-gitem" : "");
			dd.push("<div id=\"" + (_8b9.itemIdPrefix + "_" + i) + "\" class=\"" + cls + "\">");
			dd.push(opts.formatter ? opts.formatter.call(_8b7, row) : s);
			dd.push("</div>");
			if (row["selected"] && $.inArray(v, _8ba) == -1) {
				_8ba.push(v);
			}
		}
		$(_8b7).combo("panel").html(dd.join(""));
		if (opts.multiple) {
			_8ac(_8b7, _8ba, _8b8);
			if (opts.rowStyle && opts.rowStyle=='checkbox'){
				
				var myPanelJObj = $(_8b7).combo("panel");
				myPanelJObj.closest('.combo-p').children('._hisui_combobox-selectall').remove();
				var myPanelWidth = myPanelJObj.width() - 5; //
				var myallselJObj = $('<div style="width:'+myPanelWidth+'px" class="_hisui_combobox-selectall"><span class="combobox-checkbox"></span>鍏ㄩ??鍙栨秷鍏ㄩ??/div>')
				.bind('click',function(e){
					var _t = $(this);
					if (_t.hasClass('checked')){
						_t.removeClass('checked');
						$(_8b7).combobox("setValues",[]);
					}else{
						var tmpArr = [];
						_t.addClass('checked');
						$.map(data,function(v){
							tmpArr.push(v[opts.valueField]);
						});
						$(_8b7).combobox("setValues",tmpArr);
					}
					if (opts.onAllSelectClick){
						opts.onAllSelectClick.call(_8b7,e);
					} 
				});
				if (opts.allSelectButtonPosition=='bottom'){
					//myallselJObj.appendTo($(_8b7).combo("panel"));
					myallselJObj.insertAfter(myPanelJObj);
					myallselJObj.parent().addClass('bbtm');
				}else{
					//myallselJObj.prependTo($(_8b7).combo("panel"));
					myallselJObj.insertBefore(myPanelJObj);
					myallselJObj.parent().addClass('btop');
				}
			}
		} else {
			_8ac(_8b7, _8ba.length ? [_8ba[_8ba.length - 1]] : [], _8b8);
		}
		opts.onLoadSuccess.call(_8b7, data);
	};
	function _8bc(_8bd, url, _8be, _8bf) {
		var opts = $.data(_8bd, "combobox").options;
		if (url) {
			opts.url = url;
		}
		_8be = _8be || {};
		if (opts.onBeforeLoad.call(_8bd, _8be) == false) {
			return;
		}
		opts.loader.call(_8bd, _8be, function (data) {
			_8b6(_8bd, data, _8bf);
		}, function () {
			opts.onLoadError.apply(this, arguments);
		});
	};
	//doQuery
	function _8c0(_8c1, q) {
		var _8c2 = $.data(_8c1, "combobox");
		var opts = _8c2.options;
		if (opts.multiple && !q) {
			_8ac(_8c1, [], true); //_8ac setValues
		} else {
			_8ac(_8c1, [q], true);
		}
		if (opts.mode == "remote") {
			_8bc(_8c1, null, { q: q }, true); //_8bc request
		} else {
			var _8c3 = $(_8c1).combo("panel");
			_8c3.find("div.combobox-item-selected,div.combobox-item-hover").removeClass("combobox-item-selected combobox-item-hover");
			_8c3.find("div.combobox-item,div.combobox-group").hide();
			var data = _8c2.data;
			var vv = [];
			var qq = opts.multiple ? q.split(opts.separator) : [q];
			$.map(qq, function (q) {
				q = $.trim(q);
				var _8c4 = undefined;
				for (var i = 0; i < data.length; i++) {
					var row = data[i];
					if (opts.filter.call(_8c1, q, row)) {
						var v = row[opts.valueField];
						var s = row[opts.textField];
						var g = row[opts.groupField];
						var item = opts.finder.getEl(_8c1, v).show();
						if (q=="") continue;
						if (s.toLowerCase() == q.toLowerCase()) {
							vv.push(v);
							item.addClass("combobox-item-selected");
							if (vv.length==1) opts.onSelect.call(_8c1, opts.finder.getRow(_8c1, v));
						}else{
							if (s.indexOf(q.toUpperCase())>=0) {
								vv.push(v);
								item.addClass("combobox-item-selected");
								if (vv.length==1) opts.onSelect.call(_8c1, opts.finder.getRow(_8c1, v));
							}else{
								if ((row["AliasStr"])&&(row["AliasStr"]!="")){
									for (var j=0;j<row["AliasStr"].split("^").length;j++){
										if (row["AliasStr"].split("^")[j].indexOf(q.toUpperCase()) >= 0){
											vv.push(v);
											item.addClass("combobox-item-selected");
											if (vv.length==1) opts.onSelect.call(_8c1, opts.finder.getRow(_8c1, v));
										}
									}
								}
							}
						}
						if (opts.groupField && _8c4 != g) {
							$("#" + _8c2.groupIdPrefix + "_" + $.inArray(g, _8c2.groups)).show();
							_8c4 = g;
						}
					}
				}
			});
			if (opts.multiple){
				_8ac(_8c1, vv, true);
			} else {
				_8ac(_8c1, vv.length ? [vv[0]] : [], true);
			}
			
		}
	};
	//doEnter
	function _8c5(_8c6) {
		var t = $(_8c6);
		var opts = t.combobox("options");
		var _8c7 = t.combobox("panel");
		var item = _8c7.children("div.combobox-item-hover");
		if (item.length) {
			var row = opts.finder.getRow(_8c6, item);
			var _8c8 = row[opts.valueField];
			if (opts.multiple) {
				if (item.hasClass("combobox-item-selected")) {
					t.combobox("unselect", _8c8);
				} else {
					t.combobox("select", _8c8);
				}
			} else {
				t.combobox("select", _8c8);
			}
		}
		var vv = [];
		$.map(t.combobox("getValues"), function (v) {
			if (_89c(_8c6, v) >= 0) {
				vv.push(v);
			}
		});
		
		if(vv.length==0 && !opts.enterNullValueClear){
		}else{
			t.combobox("setValues", vv);
		}
		if (!opts.multiple) {
			t.combobox("hidePanel");
		}
	};
	
	function _8c9(_8ca) {
		var _8cb = $.data(_8ca, "combobox");
		var opts = _8cb.options;
		_89b++;
		_8cb.itemIdPrefix = "_hisui_combobox_i" + _89b;
		_8cb.groupIdPrefix = "_hisui_combobox_g" + _89b;
		$(_8ca).addClass("combobox-f");
		$(_8ca).combo($.extend({}, opts, {
			onShowPanel: function () {
				$(_8ca).combo("panel").find("div.combobox-item,div.combobox-group").show();
				_8a0(_8ca, $(_8ca).combobox("getValue"));
				opts.onShowPanel.call(_8ca);
			}
		}));
		$(_8ca).combo("panel").unbind().bind("mouseover", function (e) {
			$(this).children("div.combobox-item-hover").removeClass("combobox-item-hover");
			var item = $(e.target).closest("div.combobox-item");
			if (!item.hasClass("combobox-item-disabled")) {
				item.addClass("combobox-item-hover");
			}
			e.stopPropagation();
		}).bind("mouseout", function (e) {
			$(e.target).closest("div.combobox-item").removeClass("combobox-item-hover");
			e.stopPropagation();
		}).bind("click", function (e) {
			var item = $(e.target).closest("div.combobox-item");
			if (!item.length || item.hasClass("combobox-item-disabled")) {
				return;
			}
			var row = opts.finder.getRow(_8ca, item);
			if (!row) {
				return;
			}
			var _8cc = row[opts.valueField];
			if (opts.multiple) {
				if (item.hasClass("combobox-item-selected")) {
					_8ad(_8ca, _8cc);
				} else {
					_8a8(_8ca, _8cc);
				}
			} else {
				_8a8(_8ca, _8cc);
				$(_8ca).combo("hidePanel");
			}
			e.stopPropagation();
		});
	};
	
	/**
	 * 
	 */
	!function doPage () {
		setKeyDesc();
		setMousePois();
		setTimeout(function () {extendHISUI();},50)
		$(document).keydown(function(e) {
			window.onhelp = function() { return false };
			/*
			if (( e.keyCode==116)||( e.keyCode==122)) {
				e.keyCode = 0; 
				e.cancelBubble = true; 
				return false; 
			}
			*/
			if (window.event){
				var keyCode=window.event.keyCode;
				var type=window.event.type;
				var SrcObj=window.event.srcElement;
			}else{
				var keyCode=e.which;
				var type=e.type;
				var SrcObj=e.target;
			}
			var cDomId = SrcObj.id||"",
				pageCode = pageCode||ServerObj.pageCode,
				domSelector = domSelector||ServerObj.domSelector;
			keyDown(keyCode,cDomId,pageCode,domSelector);
		})
	}()
	
	$.extend($.DHCDoc, {
		hasCache : hasCache,
		InitCache: InitCache,
		storageCache : storageCache,
		validateMustFill: validateMustFill,
		domFocusJump: domFocusJump,
		extendHISUI:extendHISUI,
		setKeyDesc:setKeyDesc,
		setMousePois:setMousePois
	})

	return true;
}(jQuery,window,document));




