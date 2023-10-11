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
	function ConfigHasCache(pageCode){
		pageCode = pageCode||ServerObj.pageCode;
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "ConfigHasCache",
			pageCode: pageCode
		},false);
		
		return responseText;
	}
	function CacheConfigPage(pageCode, pageName, ProductLine, parentPageCode, parentPageName, MainCSPIsLink){
		pageCode = pageCode||ServerObj.pageCode;
		pageName = pageName||ServerObj.pageName;
		ProductLine = ProductLine||ServerObj.ProductLine;
		parentPageCode = parentPageCode||ServerObj.parentPageCode;
		parentPageName = parentPageName||ServerObj.parentPageName;
		MainCSPIsLink= MainCSPIsLink||ServerObj.MainCSPIsLink;
		var Str=pageCode+"^"+pageName+"^"+ProductLine+"^"+parentPageCode+"^"+parentPageName+"^"+MainCSPIsLink;
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "SaveConfigPage",
			Str: Str
		},false);
	}
	function storageConfigPageCache(pageCode, parentPageCode, domSelectors, domNotSelectors){
		pageCode = pageCode||ServerObj.pageCode,
		parentPageCode = parentPageCode||ServerObj.parentPageCode,
		domSelectors = domSelectors||ServerObj.domSelectors;
		if (!domSelectors) return;
		domNotSelectors = domNotSelectors||ServerObj.domNotSelectors;
		if (!domNotSelectors) domNotSelectors="";
		else  domNotSelectors="^"+domNotSelectors+"^";
		var rtnObj = {};
		var domSelectorsArr=domSelectors.split("^");
		for (var i=0; i< domSelectorsArr.length; i++){
			var oneDomSelectorStr=domSelectorsArr[i];
			var oneDomSelectorArr=oneDomSelectorStr.split("!");
			var domSelector=oneDomSelectorArr[0];
			var domType=oneDomSelectorArr[1];
			var CacheTabColumnFlag=oneDomSelectorArr[2];
			var $nodes = $(domSelector);
			for (var j=0; j< $nodes.length; j++){
				var domId = $nodes[j]['id']||"";
				if (domId == "") {
					continue;
				}
				var componentType = domType || getComponentType(domId);
				if ((domNotSelectors.indexOf(componentType) >= 0)||(("^"+domNotSelectors+"^").indexOf("^"+("#"+domId)+"^") >= 0)) {
					continue;
				}
				var isJump = supportJump(componentType);
				// 元素所在单元ID、名称。用于弹出层/表格等元素的父层
				var DomUnitId="",DomUnitName=""; 
				var _$diag=$("#"+domId).parents(".hisui-dialog")
				if (_$diag.length > 0) {
					DomUnitId=_$diag[0].id;
					DomUnitName=$("#"+DomUnitId).dialog('options').title;
				}else{
					// 元素父层div存在panel
					var _$panel=$("#"+domId).parents(".hisui-panel");
					if (_$panel.length > 0) {
						DomUnitName=$($("#"+domId).parents(".hisui-panel")[0]).panel('options').title;
						if (!DomUnitName) DomUnitName="";
					}
				}
				var domName = "";
				if (componentType == "table") {
					domSelector="datagrid";
					domName = $("#"+domId).datagrid('options').title;
					if (!domName) domName=DomUnitName;
					if ((domName==DomUnitName)&&(DomUnitId=="")) DomUnitName="";
					//缓存datagrid列元素
					if (CacheTabColumnFlag == 1) {
						var componentType="table-item",isJump=0,DomUnitId=domId,DomUnitName=domName;
						if (!DomUnitName) DomUnitName="",DomUnitId="";
						var columns=$("#"+domId).datagrid('options').columns[0];
						for (var m=0; m<columns.length; m++){
							var field=columns[m].field;
							var title=columns[m].title;
							var hidden=columns[m].hidden;
							if (hidden == true) continue;
							rtnObj[field] = title + "^" + componentType + "^" + isJump + "^" + DomUnitId + "^" + DomUnitName + "^" + domSelector;
						}
						continue;
					}
				}else{
					var _$label = $("label[for="+domId+"]");
					if (_$label.length > 0){
					   if (_$label.parents("tr").css('display') == 'none') continue;
					   domName = _$label[0].innerHTML;
					}else if ((componentType =="checkbox")||(componentType =="radio")){
						// 元素类型为checkbox/radio且html中label非独立代码
						domName=$("#"+domId).next('label').text();
					}else if (componentType =="select"){
						// 获取select 父层div标题
						var _$panel=$("#"+domId).parent(".hisui-panel");
						if (_$panel.length > 0) {
							domName=$("#"+domId).parent(".hisui-panel").panel('options').title;
						}
						if ((domName == "")&&(DomUnitName!="")&&(DomUnitId!="")) {
							domName=DomUnitName;
							DomUnitName="",DomUnitId="";
						}
						if ((domName==DomUnitName)&&(DomUnitId=="")) DomUnitName="";
					}
				}
				domName = domName + "^" + componentType + "^" + isJump + "^" + DomUnitId + "^" + DomUnitName + "^" + domSelector;
				rtnObj[domId] = domName;
			}
		}
		var domJson = JSON.stringify(rtnObj);
		var responseText = $.m({
			ClassName: "web.DHCDocPageDom",
			MethodName: "StorageCache",
			pageCode: pageCode,
			domJson: domJson,
			domSelector: ""
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
			return 1;
		}else if (componentType == "button") {
			return 0;
		} else if( componentType == "radio") {
			return 0;
		} else if(componentType == "checkbox") {
			return 0;
		} else if (componentType == "switchbox"){
			return 0;
		} else if (componentType == "tabs"){
			return 0;
		}else {
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
		}else if ((className.indexOf("hisui-lookup")>=0)||(className.indexOf("lookup-text")>=0) ||(className.indexOf("lookup")>=0)) {
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
		} else if (className.indexOf("hisui-switchbox")>=0){
			return "switchbox";
		}else {
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
			
			if (ParaObj.keyValueJson[keyCode]) {
				var responseText = $.m({
					ClassName: "web.DHCDocPageDom",
					MethodName: "GetShortKey",
					pageCode: pageCode
				},false);
				
				var keyObj = {};
				if (responseText != "") {
					keyObj = JSON.parse(responseText);
				}
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
		if($(".combobox-f").length){
			$(".combobox-f").combobox('options').keyHandler.enter=function(){
				var $panel=$(this).combobox('panel');
				if($panel.length&&$panel.is(":visible")){
					var index=$panel.find('div.combobox-item-selected').index();
					if(index>=0){
						var valueField=$(this).combobox('options').valueField;
						var value=$(this).combobox('getData')[index][valueField];
						$(this).combobox('setValue',value);
					}
					$(this).combobox('hidePanel');
				}
				var id=$(this)[0].id;
				return $.DHCDoc.domFocusJump(pageCode,domSelector,id);
			}
		}
		if($(".datebox-f").length){
			$(".datebox-f").datebox('options').keyHandler.enter=function (e){ 
				var id=$(this)[0].id;
				return $.DHCDoc.domFocusJump(pageCode,domSelector,id);
			}
		}
		$(".dateboxq").off('keydown.pagedowm').on('keydown.pagedowm',function(e){
			if(e.keyCode==13){
				var id=$(this)[0].id;
				return $.DHCDoc.domFocusJump(pageCode,domSelector,id);
			}
		});
	}	
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
		setMousePois:setMousePois,
		storageConfigPageCache:storageConfigPageCache,
		CacheConfigPage:CacheConfigPage,
		ConfigHasCache:ConfigHasCache
	})

	return true;
}(jQuery,window,document));