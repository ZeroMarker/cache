/**
 * 公共UI组件
 */
function CommonUI(){
	/**
	 * 初始化完成标志
	 */
	this._INIT_COMPLETED = false;
	/**
	 * 消息默认自动关闭时间(毫秒)
	 */
	this._DEFAULT_AUTO_CLOSE_TIME = 4000;

	/**
	 * 默认消息标题
	 */
	this._DEFAULT_TITLE_MESSAGE = "消息";

	/**
	 * 默认确认框标题
	 */
	this._DEFAULT_TITLE_CONFIRM = "请确认";

	/**
	 * 默认消息提示类型
	 */
	this._DEFAULT_ALERT_TYPE_MESSAGE = "info";

	/**
	 * 默认确认提示类型
	 */
	this._DEFAULT_CONFIRM_TYPE_MESSAGE = "question";

	/**
	 * 默认对话框提示类型
	 */
	this._DEFAULT_DIADIOG_TYPE_MESSAGE = "question";

	/**
	 * 默认ok按钮文本
	 */
	this._DEFAULT_OK_BUTTON_TEXT = "确定";

	/**
	 * 默认cancel按钮文本
	 */
	this._DEFAULT_CANCEL_BUTTON_TEXT = "取消";
	
	this.isLoadingComplete = function(){
		return this._INIT_COMPLETED;
	};
	this.loadComplete = function(){
		this._INIT_COMPLETED = true;
	};
	/**
	 * 内部初始化
	 * @author 
	 */
	this._init = function(){
		if(!this.isLoadingComplete()){
			this.loadComplete();
		}
	};
	/**
	 * 消息提示框，用于替换原生alert
	 * @param message 消息
	 * @param alertType 提示图标类型（可选,应在下列值之间：error|question|info|warning）
	 * @param title 标题（可选，默认为消息）
	 * @param okText （可选，按钮文本）
	 * @param okFunc (可选，确定按钮处理函数)
	 * @param hasCloseCross 有关闭按钮（可选，默认true）
	 */
	this.alert = function (message, alertType, title, okText, okFunc, hasCloseCross){
		var _alertType = alertType ? alertType : this._DEFAULT_ALERT_TYPE_MESSAGE; 
		jQuery.messager.defaults.ok = this._DEFAULT_OK_BUTTON_TEXT;
		if(okText) {
			jQuery.messager.defaults.ok = okText;
		}
		var _title = title ? title : this._DEFAULT_TITLE_MESSAGE; 

		jQuery.messager.alert(_title, message, _alertType, okFunc);
		
		if(!hasCloseCross) {
			jQuery("body > .messager-window:last .panel-tool > .panel-tool-close").remove();
		}
	};

	/**
	 * 消息确认框，用于替换原生confirm
	 * @param message 消息
	 * @param alertType 提示图标类型（可选,应在下列值之间：error|question|info|warning）
	 * @param okText 确定按钮文本（可选，有默认）
	 * @param okFunc 确定按钮处理函数（可选）
	 * @param cancelText 取消按钮文本（可选，有默认）
	 * @param cancelFunc 取消按钮处理函数（可选）
	 * @param title 标题（可选，有默认）
	 * @param hasCloseCross 有关闭按钮（可选，默认true）
	 * @param paramsobj okFunc需要的参数
	 */
	this.confirm = function (message, alertType, okText, okFunc, cancelText, cancelFunc, title, hasCloseCross ,paramsobj){
		var _alertType = alertType ? alertType : this._DEFAULT_CONFIRM_TYPE_MESSAGE; 
		var _title = title ? title : this._DEFAULT_TITLE_CONFIRM;
		jQuery.messager.defaults.ok = this._DEFAULT_OK_BUTTON_TEXT;
		if(okText) {
			jQuery.messager.defaults.ok = okText;
		}
		jQuery.messager.defaults.cancel = this._DEFAULT_CANCEL_BUTTON_TEXT;
		if(cancelText) {
			jQuery.messager.defaults.cancel = cancelText;
		}
		jQuery.messager.confirm(_title, message, function(rlt){
			if (rlt) { // ok
				var _paramsobj=paramsobj?paramsobj:"";
				if(okFunc) okFunc(_paramsobj);
			} else {  // cancel
				if(cancelFunc) cancelFunc();
			}
		});
		if(_alertType) {
			jQuery("body > .messager-window:last > .messager-body > .messager-icon")
				.removeClass("messager-question").addClass("messager-" + alertType);
		}
		if(!hasCloseCross) {
			jQuery("body > .messager-window:last > .panel-header > .panel-tool > .panel-tool-close").remove();
		}
	};

	/**
	 * 自动关闭的消息提示框（中间显示）
	 * @param message 消息
	 * @param alertType 提示图标类型（可选,应在下列值之间：error|question|info|warning）
	 * @param title 标题（可选）
	 * @param timeout 自动关闭时间（毫秒，默认1500）
	 */
	this.autoCloseCenterMessage = function(message, alertType, title, timeout){
		var _timeout = timeout ? timeout : this._DEFAULT_AUTO_CLOSE_TIME;
		this.showMessage(message, alertType, title, _timeout, true);
	};
	
	/*	
	*msg	提示内容	''	
	*type	提示类型	'error'	决定显示的提示样式，可选属性,'success','info','alert','error'
	*timeout	显示时间长度(毫秒)/td>	3000	0表示一直显示不消失。
	*showSpeed	显示速度	'fast'	可选属性,'fast','slow','normal',数字(毫秒数)
	*showType	显示方式	'slide'	可选属性,'slide','fade','show'
	*style	显示位置	顶部中间位置	right,top,left,bottom
	*/
	this.msg =function(type,msg,timeout,showSpeed,showType,style){
		var msg=msg||'',type=type||'error',timeout=timeout||4000,showSpeed=showSpeed||'fast'
		var showType=showType||'slide',style=style||{top:document.body.scrollTop+document.documentElement.scrollTop+40,left:''}
		var alertlength=$(".messager-popover.alert").length;
		//var iconlength=$(".messager-popover.icon").length;
		var length=0;
		if (alertlength>1){length=alertlength;}
		//if (iconlength>1){length=iconlength;}
		style.top+=length*50;
		var op={
			msg:msg,
			type:type,
			timeout:timeout,
			showType:showType,
			style:style
		}
		try{
			$.messager.popover(op);
		}catch(e){
			parent.$.messager.popover(op);
		}
	};

	/**
	 * 自动关闭的消息提示框（右下角显示）
	 * @param message 消息
	 * @param title 标题（可选）
	 * @param timeout 自动关闭时间（毫秒，默认1500）
	 * @param showType 显示方式（可选,应在下列值之间：fade|slide|show）
	 */
	this.autoCloseRightBottomMessage = function(message, title, timeout, showType){
		var _showType = showType ? showType : 'slide';
		var _timeout = timeout ? timeout : this._DEFAULT_AUTO_CLOSE_TIME;
		jQuery.messager.show({
			title: title,
			msg: message,
			timeout: _timeout,
	 		showType: _showType
		});
	};

	/**
	 * 显示模态消息
	 * @param message 消息
	 * @param alertType 提示图标类型（可选,应在下列值之间：error|question|info|warning）
	 * @param title 标题（可选，默认为消息）
	 * @param timeout 自动关闭时间（可选，默认为false）
	 * @param autoClose 是否自动关闭（可选，默认为false）
	 */
	this.showModalMessage = function(message, alertType, title, timeout, autoClose){
		this.showMessage(message, alertType, title, timeout, autoClose, true);
	};
	
	/**
	 * 显示消息（提供高级选项，中间显示）
	 * @param message 消息
	 * @param alertType 提示图标类型（可选,应在下列值之间：error|question|info|warning）
	 * @param title 标题（可选，默认为消息）
	 * @param timeout 自动关闭时间（可选，毫秒，默认1500）
	 * @param autoClose 是否自动关闭（可选，默认为false）
	 * @param modal 是否是模态对话框（可选，默认为false）
	 * @param okText（可选，按钮1文本）
	 * @param okFunc（可选，按下按钮1后的回调函数）
	 * @param cancelText（可选，按钮2文本，设置此参数将创建2个按钮）
	 * @param cancelFunc（可选，按下按钮2后的回调函数，仅当设置了按钮2时才可用）
	 * @param hasCloseCross（可选，有关闭x按钮，默认true）
	 */
	this.showMessage = function(message, alertType, title, timeout, autoClose, modal, okText, okFunc, cancelText, cancelFunc, hasCloseCross){
		var _alertType = alertType ? alertType : this._DEFAULT_DIADIOG_TYPE_MESSAGE;
		var _title = title ? title : this._DEFAULT_TITLE_MESSAGE;
		var _timeout = parseInt(timeout)>0 ? parseInt(timeout) : this._DEFAULT_AUTO_CLOSE_TIME;
		var _modal = null != modal ? modal : false; 
		var _okText = okText ? okText : '';
		var _cancelText = cancelText ? cancelText : '';
		var _hasCloseCross = null != hasCloseCross ? hasCloseCross : true;
		jQuery.messager.defaults.ok = this._DEFAULT_OK_BUTTON_TEXT;
		jQuery.messager.defaults.cancel = this._DEFAULT_CANCEL_BUTTON_TEXT;
		if(cancelText) {
			// two button
			this.confirm(message, _alertType, _okText, okFunc, _cancelText, cancelFunc, _title);
		} else {
			// one button
			this.alert(message, _alertType, _title, _okText, okFunc);
		}
		var win = jQuery("body > .messager-window:last > .messager-body");
		win.window({"modal": _modal});     // 模式窗口, 
		win.window({"draggable" : false}); // 禁止拖动窗口
		win.window({"shadow" : true});    // 去掉阴影
		var msEffect = 200;                // 效果持续时间
		function destroyMsgWin() { win.window('destroy'); }
		function closeCustomWin(ms) {
			try {
				if(!win.window("window")) return;
				if(win) {
					win.window("window").fadeOut(ms);
					setTimeout(function(){ destroyMsgWin(); }, ms);
				}
			} catch (e) {}
		}
		if(null != autoClose && !!autoClose && parseInt(timeout)>0) {
			win.window({"onBeforeClose": function() {
				if(win.timer) {
					clearTimeout(win.timer);
				}
				closeCustomWin(msEffect);
				return false;
			}});
			win.timer=setTimeout(function(){ closeCustomWin(msEffect); }, _timeout);
			win.window('window').hover(function(){
					if(win.timer) {
						clearTimeout(win.timer);
					}
				},function() {
					win.timer=setTimeout(function(){ closeCustomWin(msEffect); }, _timeout);
				}
			);
		}
		if(!_hasCloseCross) {
			jQuery("body > .messager-window:last > .panel-header > .panel-tool > .panel-tool-close").remove();
		}
	};
	
	/**
	 * 显示用户无法关闭的对话框
	 * @param message 消息
	 * @param alertType 提示类型（可选，默认为""）
	 * @param title 标题(可选，默认为消息)
	 * @param buttonText 关闭按钮文字（可选，如果没有或为空字符串，则不创建此按钮）
	 * @param callback 关闭按钮回调事件
	 * @param buttonText2 非关闭按钮文字（可选，如果没有或为空字符串，则不创建此按钮）
	 * @param callback2 非关闭按钮回调函数
	 */
	this.showUnCloseDialog = function(message, alertType, title, okText, okFunc, cancelText, cancelFunc){
		this.showMessage(message, alertType, title, 0, false, false, okText, okFunc, cancelText, cancelFunc, false);
	},
	
	/**
	 * 构造日期控件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param value 初始值
	 * @param required 是否必须（可选，默认为false）
	 * @param options 扩展选项（可选）
	 */
	this.datebox = function(obj, value, required, options){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				panelWidth: '280',
				panelHeight: '220'
			};
			if(null != required) {
				jQuery.extend(_options, { required: required });
			}
			options && jQuery.extend(_options, options);
			jqobj.datebox(_options); 
			jqobj.datebox('setValue', value);
		}
	};

	/**
	 * 获取日期对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getDateBox = function(obj){
		if(obj){
			return getJqueryDomElement(obj);
		} else {
			return null;
		}
	};
	
	/**
	 * 构造时间控件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param value 初始值
	 * @param required 是否必须（可选，默认为false）
	 * @param showSeconds 是否显示秒（可选，默认为false）
	 * @param min 最小值（可选）
	 * @param max 最大值（可选）
	 * @param options 扩展选项（可选）
	 */
	this.timespinner = function(obj, value, required, showSeconds, min, max, options){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				highlight: 0  // 高亮“时”
			};
			if(null != required) {
				jQuery.extend(_options, {required: required});
			}
			if(null != showSeconds) {
				jQuery.extend(_options, {"showSeconds": showSeconds});
			}
			if(min) {
				jQuery.extend(_options, {"min": min});
			}
			if(max) {
				jQuery.extend(_options, {"max": max});
			}
			options && jQuery.extend(_options, options);
			jqobj.timespinner(_options);
			jqobj.timespinner('setValue', value); // 验证max&min
		}
	};
	
	/**
	 * 获取时间条对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getTimeSpinner = function(obj){
		if(obj){
			return getJqueryDomElement(obj);
		} else {
			return null;
		}
	};
	
	/**
	 * 构造日期时间控件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param value 初始值
	 * @param required 是否必须（可选，默认为false）
	 * @param showSeconds 显示秒（可选，默认为false）
	 * @param  扩展选项（可选）
	 */
	this.datetimebox = function(obj, value, required, showSeconds, options){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				width: 160,
				showSeconds: false,
				panelWidth: '320',
				panelHeight: '230'
			};
			if(null != required) {
				jQuery.extend(_options, {required: required});
			}
			if(null != showSeconds) {
				jQuery.extend(_options, {"showSeconds": showSeconds});
			}
			options && jQuery.extend(_options, options);
			jqobj.datetimebox(_options); 
			jqobj.datetimebox('setValue', value);
		}
	};
	
	/**
	 * 获取日期时间控件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getDateTimeBox = function(obj){
		if(obj){
			return getJqueryDomElement(obj);
		}else{
			return null;
		}
	};
	
	/**
	 * 取得linkbutton对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getLinkButton = function (obj){
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得搜索框对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getSearchBox = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得翻页UI对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getPagination = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得拖动UI对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getDraggable = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得放置UI对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getDroppable = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得重设大小UI对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getResizable = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};

	/**
	 * 取得进度条对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getProgressBar = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得panel对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getPanel = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得tabs对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getTabs = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得accordion对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getAccordion = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得layout对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getLayout = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得menu对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getMenu = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得menubutton对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getMenuButton = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得linkbutton对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getLinkButton = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得splitbutton对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getSplitButton = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得window对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getWindow = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得dialog对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getDialog = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得alert|confirm对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getMessager = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得propertygrid对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getPropertyGrid = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得tree对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getTree = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得treegrid对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getTreeGrid = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得datagrid对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getDataGrid = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得validatebox对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getValidateBox = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得combo对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getCombo = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得combogrid对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getComboGrid = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得combotree对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getComboTree = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得numberbox对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getNumberBox = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得calendar对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getCalendar = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得numberspinner对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getNumberSpinner = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	
	/**
	 * 取得slider对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getSlider = function(obj) {
		if(obj) {
			return getJqueryDomElement(obj);
		}else {
			return null;
		}
	};
	/*
	 * xuchao
	 * 2018-07-05
	 * 按钮禁用1秒  防止重复点击
	 * 添加快捷键功能
	 * 示例代码 hotKey:''Ctrl+o'',
	 * tip 提示 快捷键功能
	*/
	this.linkbutton=function(id,options){
		if(isEmpty(ButtonCountObj[id])){
		
		}else{
			ButtonCountObj[id]=0;
		}
		if(options.hotKey){
			jQuery(document).bind('keydown',options.hotKey,function (evt){
				$HUI.linkbutton(id).disable();
				var Count=ButtonCountObj[id];
				options.onClick();
				setTimeout(function(){
					var CurCount=ButtonCountObj[id];
					if(Count==CurCount){///延时时间内是否处理过按钮，如果处理过则不再处理
						$HUI.linkbutton(id).enable();
					}
				},1000);
				return false;
			});
		}
		$HUI.linkbutton(id,{
			onClick:function(){
				$HUI.linkbutton(id).disable();
				var Count=ButtonCountObj[id];
				options.onClick();
				setTimeout(function(){
					var CurCount=ButtonCountObj[id];
					if(Count==CurCount){///延时时间内是否处理过按钮，如果处理过则不再处理
						$HUI.linkbutton(id).enable();
					}
				},1000);
			}
		});
		var text=$(id).text();
		if(options.hotKey){
			var text=text+'('+options.hotKey+')';
		}
		$(id).tooltip({
			position: 'right',
			content: '<span style="">'+text+'</span>',
			onHide: function(){
				$(id).tooltip('destroy');
			}
		});
	}
	/*
	 * xuchao
	 * 20190102
	 * $.cm   $.m 封装 
	 * 1 封装 showMask  hideMask功能
	 * 2 便于 以后添加功能
	*/
	this.cm=function(options,fn){
		//1 fn 是 Boolean类型
		if(typeof(fn)=='boolean'){
			return $.cm(options,fn);
		}
		else{
			//2 fn 是function
			showMask();
			$.cm(options,function(jsonData){
				hideMask();
				fn(jsonData)
			})
		}
	}
	this.m=function(options,fn){
		//1 fn 是 Boolean类型
		if(typeof(fn)=='boolean'){
			return $.m(options,fn);
		}
		else{
			//2 fn 是function
			showMask();
			$.m(options,function(jsonData){
				hideMask();
				fn(jsonData)
			})
		}
	}
	/**
	 * 构造DataGrid组件
	 * @param id，如#UomList
	 * @param options ，Grid 配置参数对象
	 * @author XuChao
	 */
	this.datagrid = function(id, options) {
		if (!id) return;
		var columns=options.columns;
		//处理cm公共属性
		var _columns=[[]];
		var _frozenCol=[[]];
		this.columns(columns,id,_columns,_frozenCol,options);
		options.columns=_columns;
		var _options ={};
		var colSet={
				text: '列设置',
				iconCls: 'icon-set-col',
				handler: function () {
					GridColSet(gridObj);
				}
			};
		var exportExcel={
				text: '导出当前页',
				iconCls: 'icon-export-data',
				handler: function () {
					showMask();
					var data=gridObj.getRows();
					data=data||[];
					var cm=columns[0];
					if(data.length==0){
						$UI.msg('alert', "没有数据需要导出!");
						hideMask();
						return false;
					}
					ExportExcel(data,cm);
					hideMask();
				}
			};
		var exportAll={
			text: '导出所有',
			iconCls: 'icon-export-all',
			handler: function () {
				showMask();
				var op=gridObj.jdata.options.queryParams;
				var cm=columns[0];
				///重置参数
				op.page=1;
				op.rows=9999999;
				$.cm(op,function(data){
					if(!data.rows||data.rows.length==0){
						$UI.msg('alert', "没有数据需要导出!");
						hideMask();
						return false;
					}
					ExportExcel(data.rows,cm)
					hideMask();
				})
			}
		};
		var addRow={
				text: '新增',
				iconCls: 'icon-add',
				handler: function () {gridObj.commonAddRow()}
			};
		var deleteRow={
				text: '删除',
				iconCls: 'icon-cancel',
				handler: function () {gridObj.commonDeleteRow()}
			};
		jQuery.extend(_options, {
			columns:_columns,
			frozenColumns:_frozenCol,
			data:[],
			autoRowHeight:true,
			striped:true,
			method:"post",
			nowrap:true,
			url:$URL,
			lazy:true,
			loadMsg:"加载中,请稍后...",
			pagination:true,
			rownumbers:true,
			singleSelect:true,
			pagePosition:"bottom",
			pageNumber:1,
			pageSize:15,
			pageList:[5,10,15,20,30,50,80,100],
			remoteSort: true,
			sortName: '',
			sortOrder: 'asc',
			border: false,
			fit: true,
			autoSizeColumn: false,
			beforeAddFn : function(){},	//新增一行前,判断是否符合条件(返回值===false则不新增行).
										//否则,获取新增行缺省值,返回值格式:object
			afterAddFn : function(){},	//新增一行后,如需调用某方法控制界面控件等,可通过此参数设置
			beforeDelFn: function(){},  //删除选中行前，,判断是否符合条件(返回值===false则不删除).
			showFooter: true,   //合计行
			onLoadError: function(error){
				$CommonUI.msg('error', "加载数据失败");
			},
			onSelectChangeFn:function(){},	//onselect、onunselect、onSelectAll、onUnselectAll事件发生时调用，处理选中或取消选中后执行方法
			onSelect : function (index, row){
				if(jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)){
					gridObj.jdata.options.onSelectChangeFn()
				}
			},
			onUnselect : function (index, row){
				if(jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)){
					gridObj.jdata.options.onSelectChangeFn()
				}
			},
			onSelectAll : function (rows){
				if(jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)){
					gridObj.jdata.options.onSelectChangeFn()
				}
			},
			onUnselectAll : function (rows){
				if(jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)){
					gridObj.jdata.options.onSelectChangeFn()
				}
			}
		});
		///toolbar 处理
		if(options.toolbar){
		}else{
			options.toolbar=[];
		}
		if(options.showAddDelItems){
			options.toolbar.unshift(addRow,deleteRow);
		}
		if(options.showAddItems){
			options.toolbar.unshift(addRow);
		}
		if(options.showDelItems){
			options.toolbar.unshift(deleteRow);
		}
		if(options.showBar)
		{
			options.toolbar.push(colSet,exportExcel,exportAll);
		}
		if(options) {
			_options=jQuery.extend(true,_options, options);
		}
		var ParamsObj = {};
		if(typeof _options.queryParams.Params != 'undefined'){
			ParamsObj = JSON.parse(_options.queryParams.Params);
		}
		_options.queryParams.Params=jQuery.extend(true,ParamsObj,sessionObj);
		_options.queryParams.Params=JSON.stringify(_options.queryParams.Params);
		var gridObj =$HUI.datagrid(id,_options);
		///公共方法
		gridObj.editIndex=undefined;
		///是否可以end一行的编辑状态
		gridObj.checked=true;
		///colSort 回车跳转顺序
		gridObj.colSort=null
		//刷新一行并恢复编辑状态
		gridObj.refreshRow=function(){
			if (this.editIndex == undefined){return true;}
//			if (gridObj.validateRow(this.editIndex)){
//				return true;
//			} else {
				$(id).datagrid('endEdit', this.editIndex).datagrid('refreshRow', this.editIndex).datagrid('selectRow', this.editIndex).datagrid('beginEdit', this.editIndex);
				gridObj.enter();
				var editor = gridObj.getEditor({index:gridObj.editIndex,field:gridObj.FocusField});
				$(editor.target).focus();
				$(editor.target).next().children().focus();
				return true;
//			}
		}
		//判断grid是否编辑完成
		gridObj.endEditing=function(){
			if (this.editIndex == undefined){return true;}
			if (gridObj.validateRow(this.editIndex)){
				gridObj.endEdit(this.editIndex);
				if(this.checked){
					this.editIndex = undefined;
					return true;
				}else{
					this.checked=true;
					gridObj.beginEdit(this.editIndex);
					return false
				}
			} else {
				var NowIndex=this.editIndex+1;
				$UI.msg('alert',"第"+NowIndex+"行存在必填项未填写(有红色三角形警示的列)!");
				return false;
			}
		}
		gridObj.commonClickCell = function(index, field, value){
			if (this.endEditing()){
				this.editIndex = index;
				gridObj.selectRow(index).datagrid('editCell',{index:index,field:field});
				gridObj.FocusField=field;
				if(field!=""){
					var ed = gridObj.getEditor({index:index,field:field});
					if(ed!=null){
						$(ed.target).focus();
						$(ed.target).next().children().focus();
					}
				}
			}
		}
		//编辑行事件
		gridObj.commonRowClick = function(index){
			if (this.endEditing()){
				gridObj.selectRow(index).datagrid('beginEdit', index)
				this.editIndex = index;
			} else {
				gridObj.selectRow(this.editIndex);
			}
		}
		
		//公用插入一行的方法
		gridObj.commonAddRow = function(rowObj){
			if(jQuery.isFunction(gridObj.jdata.options.beforeAddFn)){
				var beforeAddrowObj=gridObj.jdata.options.beforeAddFn()
				if(beforeAddrowObj===false){
					return;
				}
			}
			if(this.endEditing()){
				var row=$.extend({},beforeAddrowObj,rowObj);
				//var EditRowIndex = 0;
				//改为追加
				//gridObj.insertRow({index:EditRowIndex, row:row})
				gridObj.appendRow(row);
				var EditRowIndex=gridObj.getRows().length-1;
				gridObj.beginEdit(EditRowIndex);
				gridObj.clearSelections();
				gridObj.selectRow(EditRowIndex);
				this.editIndex=EditRowIndex;
				var FirstFocusField = gridObj.getFirstFocusField();
				if(!isEmpty(FirstFocusField)){
					var ed = gridObj.getEditor({index:EditRowIndex,field:FirstFocusField});
					$(ed.target).focus();
					$(ed.target).next().children().focus();
					gridObj.FocusField=FirstFocusField;
				}
				gridObj.enter();
			}
			if(jQuery.isFunction(gridObj.jdata.options.afterAddFn)){
				var afterAddFnObj = gridObj.jdata.options.afterAddFn()
				if(afterAddFnObj===false){
					return;
				}
			}
		},
		gridObj.enter=function(){
			var ed = gridObj.getEditors(this.editIndex);
			for (var i = 0, Len = ed.length; i < Len; i++){
				var e = ed[i];
				$(e.target).bind('keydown', function(){
					if (window.event.keyCode == 13){
						var Field = $(this).parents('td[field]').attr('field');
						//keydown中记录当前跳转格子,在keyup事件中按此值进行控制
						if(gridObj.JumpGridField !== false){
							gridObj.JumpGridField = Field;
						}
					}
				}).bind('keyup', function(ev){
					if (window.event.keyCode == 13){
						var Field = $(this).parents('td[field]').attr('field');
						//jump属性为false时,回车不进行跳转,需自行在column定义中维护
						var JumpFlag = gridObj.getColumnOption(Field)['jump'];
						//JumpGridField为false时,设不进行重新赋值(后续不进行跳转)
						if(gridObj.JumpGridField === Field && JumpFlag !== false){
							gridObj.startEditingNext(Field);
						}
						gridObj.JumpGridField = null;
					}
				});
				$(e.target).next().children().bind('keydown', function(ev){
					if (window.event.keyCode == 13){
						gridObj.keydownFlag = true;			//中文输入法,IE触发不了keydown, 通过此属性控制keyup是否执行
						var EditorObj = $(this).parent().prev();
						if(EditorObj.hasClass('combogrid-f')){
							gridObj.JumpGridField = null;
							//combogrid时,优先检测是否配置了回车函数
							try{
								var EnterFun = EditorObj.combogrid('options')['EnterFun'];
								if(!isEmpty(EnterFun)){
									var q = $(this).val();
									EnterFun(q, EditorObj);
									return;
								}
							}catch(e){}
						}else{
							var Field = $(this).parents('td[field]').attr('field');
							gridObj.JumpGridField = Field;
						}
					}
				}).bind('keyup', function(ev){
					if (window.event.keyCode == 13){
						if(gridObj.keydownFlag !== true){
							return;
						}
						gridObj.keydownFlag = false;
						var Field = $(this).parents('td[field]').attr('field');
						var JumpFlag = gridObj.getColumnOption(Field)['jump'];
						if(gridObj.JumpGridField === Field && JumpFlag !== false){
							gridObj.startEditingNext(Field);
						}
						gridObj.JumpGridField = null;
					}
				});
			}
		}
		// 停止回车跳转的方法,结合enter中用到的方法来实现
		gridObj.stopJump = function(target){
			gridObj.JumpGridField = false;
		}
		//公用编辑下一editor方法
		gridObj.startEditingNext = function(Field){
			var NextField=gridObj.getNextFocusField(Field);
			if(isEmpty(NextField)){
				gridObj.commonAddRow();
			}else{
				var editor = gridObj.getEditor({index:gridObj.editIndex,field:NextField});
				$(editor.target).focus();
				$(editor.target).select();
				$(editor.target).next().children().focus();
				$(editor.target).next().children().select();
				gridObj.FocusField=NextField;
			}
		}
		//公用删除行的方法(复制编辑行，删除编辑行，删除其他行，新增行赋值编辑行内容)
		gridObj.commonDeleteRow = function(rowObj){
			gridObj.endEditing();
			if(jQuery.isFunction(gridObj.jdata.options.beforeDelFn)){
				var beforeDel=gridObj.jdata.options.beforeDelFn()
				if(beforeDel===false){
					return;
				}
			}
			var arrData=[];  //处理后的数据
			var rowsData=[];
			if(gridObj.checkboxModle()){
				rowsData = gridObj.getChecked();
			}else{
				rowsData = gridObj.getSelections();
				var len=rowsData.length
				if(len<=0){
					///没有selections时候 看看cell
					var cell = gridObj.cell(); 
					if(cell){
						var row = gridObj.getRows()[cell.index];
						rowsData.push(row);
					}
				}
			}
			var len=rowsData.length;
			if(len<=0){
				$UI.msg('alert', "请选择要删除的行!");
				return;
			}
			
			//删除正在编辑行
			var edIndex=gridObj.editIndex;
			var edrow=""
			var ifDefAdd=false; //删除后是否需要重新增加行(行为空或已选择时为false)
			if(edIndex!=undefined && edIndex>-1){
				var edField=gridObj.FocusField;
				edrow=gridObj.getRows()[edIndex];
				var edRowId=edrow['RowId'];
				var ed = gridObj.getEditor({index:edIndex,field:edField});
				var edval=ed.target.val();
				if(isEmpty(edRowId)){
					//判断是否空行
					if(edval!=""){ifDefAdd=true;}
					else{
						var fields = gridObj.getColumnFields();
						for (var i = 0; i < fields.length; i++) {
							var value=edrow[fields[i]];
							if(!isEmpty(value)){ifDefAdd=true;}
						}
					}
					edrow[edField]=edval
					gridObj.deleteRow(edIndex);
					gridObj.editIndex=undefined;
				}else{
					arrData.unshift(edrow);
				}
			}
			for(var i=len-1;i>=0;i--){
				var row=rowsData[i];
				var index = gridObj.getRowIndex(row);
				if(index<0){ifDefAdd=false;}
				else{
					if(isEmpty(row.RowId)){
						gridObj.deleteRow(index);
					}else{
						arrData.unshift(row);
					}
				}
			}
			if(arrData.length<=0){
				gridObj.editIndex=undefined;	//删除后清除编辑行数
				//处理编辑行
				if(ifDefAdd==true){
					var EditRowIndex=0;
					var length = gridObj.getRows().length;
					if (length > 0) {
						EditRowIndex = length;
					}
					gridObj.insertRow({
						index: EditRowIndex,
						row: edrow
					});
				}
				$UI.msg('success', "删除成功!");
				return;
			}
			function deleterows(){
				$.cm({
					ClassName: options.deleteRowParams.ClassName,
					MethodName:options.deleteRowParams.MethodName,
					Params:JSON.stringify(arrData)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success', jsonData.msg);
						for(var i=len-1;i>=0;i--){
							var row=rowsData[i];
							if(row.RowId){
								var index = gridObj.getRowIndex(row);
								gridObj.deleteRow(index);
							}
						}
						gridObj.editIndex=undefined;	//删除后清除编辑行数
					}else{
						$UI.msg('error', jsonData.msg);
					}
				});
			};
			if(options.deleteRowParams && !isEmpty(options.deleteRowParams.ClassName) && !isEmpty(options.deleteRowParams.MethodName)){
				$UI.confirm('确定要删除选中行吗?','','', deleterows);
			}else{
				$UI.msg('alert', '该模块数据一经维护,不允许删除!');
			}
		},
		//获取第一个编辑的field
		gridObj.getFirstFocusField = function(){
			var colSort = gridObj.jdata.options['colSort'] || columns[0];
			$.each(colSort, function(index, value){
				if(isEmpty(gridObj.firstFocusField) && !isEmpty(value.editor) && value.hidden !== true){
					gridObj.firstFocusField = value.field;
					return false;
				}
			});
			return gridObj.firstFocusField;
		},
		//获取下一个编辑的field
		gridObj.getNextFocusField = function(Field){
			var pField='',nField='';
			var colSort = gridObj.jdata.options['colSort'] || columns[0];
			$.each(colSort, function(index, value){
				if(value.hidden !== true && !isEmpty(value.editor)){
					if(!isEmpty(value.editor.options) && value.editor.options.disabled){
						return true;
					}
					if(Field==pField){
						nField=value.field;
						return false;
					}
					pField= value.field;
				}
			});
			return nField;
		},
		//获取datagrid数据
		//添加key
		gridObj.getChangesData=function(key){
			var arrData=[];  //处理后的数据
			if(this.getRows().length==0){
				return false;
			}
			if(!isEmpty(key)){
				if(this.editIndex!=undefined){
					if((isEmpty(this.getRows()[this.editIndex][key]))&&(this.getRows().length==1)){
						return false;
					}
					if(!isEmpty(this.getRows()[this.editIndex][key])){
						if(!this.endEditing()){
							return false;
						}
					}
				}
			}else{
				if(!this.endEditing()){
					return false;
				}
			}
			var inserted = gridObj.getChanges('inserted');
			var updated = gridObj.getChanges('updated');
			var rowsData = [];
			rowsData = rowsData.concat(updated);
			rowsData = rowsData.concat(inserted);
			rowsData=DeepClone(rowsData)
			var saveColArr = [];		//记录保存需要的字段
			for (var col in columns[0]){
				if(columns[0][col].saveCol === true){
					saveColArr[saveColArr.length] = columns[0][col].field;
				}
			}
			for(var i=0; i<rowsData.length; i++){
				var row = rowsData[i];
				if(!isEmpty(saveColArr)){
					//按需要的字段, 简化下row的数据
					for(var rowKey in row){
						if(saveColArr.indexOf(rowKey) == -1){
							delete row[rowKey];
						}
					}
				}
				if(!isEmpty(key) && isEmpty(row[key])){
					continue;
				}
				arrData.unshift(row);
			}
			return arrData;
		};
		//获取datagrid数据所有
		gridObj.getRowsData=function(){
			var arrData=[];  //处理后的数据
			if(!this.endEditing()){
				return false;
			}
			var rowsData = gridObj.getRows();
			var saveColArr = [];		//记录保存需要的字段
			for (var col in columns[0]){
				if(columns[0][col].saveCol === true){
					saveColArr[saveColArr.length] = columns[0][col].field;
				}
			}
			for(var i=0;i<rowsData.length;i++){
				var row=rowsData[i];
				if(!isEmpty(saveColArr)){
					//按需要的字段, 简化下row的数据
					for(var rowKey in row){
						if(saveColArr.indexOf(rowKey) == -1){
							delete row[rowKey];
						}
					}
				}
				arrData.unshift(row);
			}
			return arrData;
		};
		gridObj.getSelectedData=function(){
			if(!this.endEditing()){
				return false;
			}
			var arrData=[];  //处理后的数据
			var rowsData = gridObj.getSelections();
			if(rowsData.length==0){
				return arrData;
			}
			//只取标记字段20180711
			var saveColArr = [];		//记录保存需要的字段
			for (var col in columns[0]){
				if(columns[0][col].saveCol === true){
					saveColArr[saveColArr.length] = columns[0][col].field;
				}
			}
			for(var i=0; i<rowsData.length; i++){
				var row = rowsData[i];
				if(!isEmpty(saveColArr)){
					//按需要的字段, 简化下row的数据
					for(var rowKey in row){
						if(saveColArr.indexOf(rowKey) == -1){
							delete row[rowKey];
						}
					}
				}
				arrData.unshift(row);
			}
			var arrData=changefieldval(arrData,columns);
			return arrData;
		};
		//重新加载并取消选中
		gridObj.commonReload=function(){
			gridObj.clearSelections();
			gridObj.reload();
		};
		//代替 ext的findExact   find
		gridObj.find=function(field,value){
			var index=-1;
			var rowsData = gridObj.getRows();
			for(var i=0;i<rowsData.length;i++){
				var row=rowsData[i];
				if(row[field]==value){
					index=i;
					return index;
				}
			}
			return index;
		};
		gridObj.checkboxModle=function(){
			var len=columns[0].length;
			for(var i=0;i<len;i++){
				var ck=columns[0][i].checkbox;
				if(ck){
					return true;
				}
			}
			return false;
		};
		gridObj.setFooterInfo = function(){
			var op = gridObj.jdata.options.queryParams;
			var totalFieldsStr = op.totalFields;
			if (totalFieldsStr == null){
				return false;
			}
			var rows = gridObj.getRows();
			var SumArr = [{}];
			var FieldsArr = totalFieldsStr.split(',');
			for(var j = 0, Len = FieldsArr.length; j < Len; j++){
				SumArr[0][FieldsArr[j]] = 0;
			}
			var totalFooterStr = op.totalFooter;
			if(totalFooterStr!=null){
			var FooterArr = totalFooterStr.split(':');
			var FooterTitleArr=FooterArr[0].split('"')
			var FooterListArr=FooterArr[1].split('"')
			SumArr[0][FooterTitleArr[1]] = FooterListArr[1];
			}
			for(var i = 0; i < rows.length; i++){
				for(var j = 0, Len = FieldsArr.length; j < Len; j++){
					var FieldTitle = FieldsArr[j];
					eval("SumArr[0]['"+ FieldTitle +"'] = Number(SumArr[0]['"+FieldTitle+"']) + Number(rows[i]['"+FieldTitle+"'])");
				}
			}
			gridObj.reloadFooter(SumArr);
		}
		
		return gridObj;
	};
	
	/*
	*处理cm,添加公共属性
	*/
	this.columns=function(cm,id,_columns,_frozenCol,options){
		var _cm=$.extend(true,[],cm);
		var op={
			//halign:"center",
			//sortable:true,
			resizable:true
		};
		////不显示列设置  不生成数数据
		if(options.showBar){
			var MainObj={
				AppName:'DHCSTCOMMONM',
				CspName:App_MenuCspName,
				GridId:id
			};
			var Main=JSON.stringify(addSessionParams(MainObj));
			var SaveModInfo = $.m({
				ClassName: 'web.DHCSTMHUI.StkSysGridSet',
				MethodName: 'JsGetSaveMod',
				Main: Main
			},false);
			if(SaveModInfo != ''){
				var MainStr = JSON.stringify(addSessionParams(MainObj));
				var Detail=JSON.stringify(cm[0].reverse());
				cm[0].reverse();
				var newcm = $.cm({
					ClassName:"web.DHCSTMHUI.StkSysGridSet",
					MethodName:"Query",
					Main:MainStr,
					Detail:Detail
				},false);
				if(!isEmpty(newcm) && newcm.length > 0){
					//有返回值按返回值
					var len=newcm.length;
					for(var i=0;i<len;i++){
						var field=newcm[i].field;
						var _cmobj=FindCmObj(_cm[0],field);
						var cmobj=jQuery.extend(true,_cmobj,op,newcm[i],{halign:newcm[i].align});
						if(cmobj.frozen=="true"){
							_frozenCol[0].push(cmobj);
						}else{
							_columns[0].push(cmobj);
						}
					}
					
					//初始化colSort
					var SortColumns = [].concat(_columns[0]);
					var Len = SortColumns.length;
					for(var i = Len - 1; i >= 0; i--){
						var Column = SortColumns[i];
						var EnterSortNum = Number(Column['enterSort']);
						if(EnterSortNum <= 0){
							SortColumns.splice(i, 1);
						}else{
							Column['enterSort'] = EnterSortNum;
						}
					}
					if(SortColumns.length > 0){
						var Sort=function(array){
							var d;
							for(var i = 0, len = array.length; i<len; i++){
								for(j=0; j<len; j++){
									if(array[i].enterSort - array[j].enterSort < 0){
										d = array[j];
										array[j] = array[i];
										array[i] = d;
									}
								}
							}
							return array;
						}
						options['colSort'] = Sort(SortColumns);
					}
				}
			}
		}
		
		if(_columns[0].length == 0){
			var len=cm[0].length;
			for(var i=0;i<len;i++){
				_columns[0].push(jQuery.extend(true,cm[0][i],op,{halign:cm[0][i].align}));
			}
		}
		return;
	}
	
	/**
	 * 按条件加载DataGrid数据
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param params 条件
	 */
	this.queryForDataGrid = function(obj, params){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			jqobj.datagrid('load', params);
		}
	};
	
	/**
	 * 构造树组件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param options 扩展选项（可选）
	 */
	this.tree = function(obj, url, data, onClick, onDblClick, checkbox, onlyLeafCheck, options){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				dnd: false, 		// 不能拖动
				cascadeCheck: true, // checkbox选择时联动
				lines: true 		// 导航虚线
			};
			if (url) {
				jQuery.extend(_options, {"url": url});
			}
			if (null!=data) {
				if('string'===typeof(data) && data) {
					jQuery.extend(_options, {"data": jQuery.parseJSON(data)});
				} else if('object'===typeof(data) && data) {
					jQuery.extend(_options, {"data": data});
				}
			}
			if (onClick) {
				jQuery.extend(_options, {"onClick": onClick});
			}
			if (onDblClick) {
				jQuery.extend(_options, {"onDblClick": onDblClick});
			}
			if (null != checkbox) {
				jQuery.extend(_options, {"checkbox": checkbox});
			}
			if (null != onlyLeafCheck) {
				jQuery.extend(_options, {"onlyLeafCheck": onlyLeafCheck});
			}
			options && jQuery.extend(_options, options);
			jqobj.tree(_options); 
		}
	};

	/**
	 * 提交form
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param async 是否异步提交
	 * @param url 提交url
	 * @param onSuccess 成功时调用函数
	 * @param onSubmit 提交时调用函数（可选）
	 */
	this.submitForm = function(obj, async, url, onSuccess, onSubmit){
		if(obj) {
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				url: url,
				"success": onSuccess
			};
			onSubmit && jQuery.extend(_options, {"onSubmit": onSubmit});
			if (async) {
				// ajax submit
				jqobj.form(_options);
				jqobj.submit();
			} else {
				// direct submit
				jqobj.submit('submit', _options);
			}
		}
	};
	
	/**
	 * 取得form对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getForm = function(obj){
		if(obj) {
			return getJqueryDomElement(obj);
		} else {
			return null;
		}
	};
	
	/**
	 * 取得指定id对象的类型
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * 
	 * @return string 
	 */
	this.getUIType = function(obj){
		var target = getJqueryDomElement(obj);
		if(!target || target.length==0) return '';
		
		var cbxCls = ['combobox','combotree','combogrid','datetimebox',
					'datebox','combo','numberbox','numberspinner','timespinner'];

		for(var i=0; i<cbxCls.length; i++){
			var type = cbxCls[i];
			if (target.eq(0).hasClass(type+'-f')){
				return type;
			}
		}

		if(target.eq(0).hasClass('multiselect2side')) {
			return 'multiselect2side';
		}
		if(target.eq(0).hasClass('calendar')) {
			return 'calendar';
		}
		if(target.eq(0).hasClass('dhc-slider')) {
			return 'slider';
		}
		if(target.eq(0).hasClass('validatebox-text')) {
			return 'validatebox';
		}
		
		var tagName = target.eq(0).prop('tagName').toLowerCase();
		if('input' === tagName) {
			tagName = target.eq(0).attr('type').toLowerCase();
		}
		return tagName;
	};
	
	/**
	 * 取得指定对象值
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getUIValue = function(obj) {
		var clsName = this.getUIType(obj);
		if(clsName) {
			var target = getJqueryDomElement(obj);
			if(!target || target.length==0) return null;

			var clses = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
			var idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				if(target[clses[idx]]('options').multiple) {
					return target.eq(0)[clses[idx]]('getValues');
				} else {
					return target.eq(0)[clses[idx]]('getValue');
				}
			}
			
			clses = ['select', 'multiselect2side'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				var rtnVal = [];
				$.each(target.children(':selected'), function(i,n){
					rtnVal.push($(this).val());
				});
				return rtnVal;
			}
			
			clses = ['radio'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				var rtnVal = null;
				$.each(target.filter(':checked'), function(i,n){
					rtnVal=$(this).val();
					return false;
				});
				return rtnVal;
			}
			
			clses = ['checkbox'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				var rtnVal = [];
				$.each(target.filter(':checked'), function(i,n){
					rtnVal.push($(this).val());
				});
				return rtnVal;
			}
			
			clses = ['numberbox'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				return target.eq(0)[clses[idx]]('getValue');
			}
			
			clses = ['slider'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				return target.eq(0)[clses[idx]]('getValue');
			}
			
			clses = ['calendar'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				return target.eq(0)[clses[idx]]('options').current;
			}
			
			clses = ['validatebox','input'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				return target.eq(0).val();
			}
		}
	};
	
	/**
	 * 设置指定ID值
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.setUIValue = function(obj, value) {
		var clsName = this.getUIType(obj);
		if(clsName) {
			var target = getJqueryDomElement(obj);
			if(!target || target.length==0) return null;
			
			var clses = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
			var idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				if(target[clses[idx]]('options').multiple) {
					target.eq(0)[clses[idx]]('setValues', value);
				} else {
					target.eq(0)[clses[idx]]('setValue', value);
				}
				return;
			}
			
			clses = ['multiselect2side', 'select'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				target.children(':selected').prop('selected', false);
				target.eq(0).val(value);
				return;
			}
			
			clses = ['radio'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				target.prop('cheched', false);
				target.each(function() {
					if($(this).val() == value) {
						$(this).prop('checked', true);
						return false;
					}
				})
				return;
			}
			
			clses = ['checkbox'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				target.prop('cheched', false);
				target.each(function() {
					if(-1 !== $.inArray($(this).val(), value)) {
						$(this).prop('checked', true);
					}
				})
				return;
			}
			
			clses = ['numberbox'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				var number = Number(value);
				if(!isNaN(number)) {
					target.eq(0)[clses[idx]]('setValue', number);
				}
				return;
			}
			
			clses = ['slider'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				target.eq(0)[clses[idx]]('setValue', value);
				return;
			}
			
			clses = ['calendar'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				target.eq(0)[clses[idx]]('options').current = value;
				return;
			}
			
			clses = ['validatebox','input'];
			idx = $.inArray(clsName, clses);
			if(-1 != idx) {
				target.eq(0).val(value);
				return;
			}
		}
	}
	
	/**
	 * 遍历区块数据组装成JSON字符串
	 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param skipNames 跳过的name数组
	 * @param skipHidden 是否跳过HTML标准组件里的hidden字段
	 * @param skipDisabled 是否跳过disable字段
	 */
	this.loopBlock = function(container, skipNames, skipHidden, skipDisabled){
		var attrs = {}; // 返回的对象
		var gettedNames = []; // 需跳过的组件名数组
		if(!skipNames) {
			skipNames = [];   // 需跳过的name
		}
		var target = jQuery(document);
		if(container) {
			target = getJqueryDomElement(container);
		}
		// combo&datebox
		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboName]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboName');
					if (jQuery(this).hasClass(type+'-f')){
						var options = jQuery(this)[type]('options');
						if(skipDisabled && options['disabled']) {
							return true;
						}
						if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
							return true;
						}
						if (options['multiple']){
							var val = jQuery(this)[type]('getValues');
							var seprator = options['seprator'];
							if(!isEmpty(seprator)){
								val = val.join(seprator);
							}
							extendJSON(name, val);
						} else {
							var val = jQuery(this)[type]('getValue');
							//if(type=='datebox'){
								//val=formatDate(val)
							//}
							extendJSON(name, val);
						}
						break;
					}
				}
			});
		}
		// radio&checkbox
		var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
		if(skipDisabled) ipts=ipts.not(":disabled");
		if(skipHidden) ipts=ipts.not(":hidden");
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
					iptsNames.push(name);
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
				var type = iptsFlts.eq(0).attr('type');
				if(type === 'radio') {
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							extendJSON(iptsNames[i], jQuery(this).val());
							return false;
						}
					});
				} else if(type === 'checkbox') {
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
							//2018-4-28
							//vals.push('Y')
						}
					});
					///2018-4-27  直接值传入
					if(vals.length==1){
						vals=vals[0]
					}else if(vals.length<1){
						vals=''
					}
					extendJSON(iptsNames[i], vals);
				}
			}
		}
		// numberbox&slider
		var cTypes = ['numberbox', 'slider'];
		for(var i=0;i<cTypes.length;i++) {
			ipts = jQuery("input["+cTypes[i]+"name]", target);
			if(skipDisabled) ipts=ipts.not(":disabled");
			if(ipts.length){
				ipts.each(function(){
					var name = jQuery(this).attr(cTypes[i]+'Name');
					if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
						return true;
					}
					var val = jQuery(this)[cTypes[i]]('getValue');
					extendJSON(name, val);
				});
			}
		}
		// multiselect2side
		ipts = jQuery(".multiselect2side", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipDisabled && $(this).next('.ms2side__div').find(':disabled').length) {
					return true;
				}
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this)['multiselect2side']('getValue');
				extendJSON(name, val);
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(skipDisabled) ipts=ipts.not(":disabled");
		if(skipHidden) ipts=ipts.not(":hidden");
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				extendJSON(name, val);
			});
		}
		// lookup
		ipts = jQuery(".lookup", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(jQuery(this).lookup('options')['valueType'] === 'text'){
					var val = jQuery(this).lookup('getText');
				} else {
					var val = jQuery(this).lookup('getValue');
				}
				extendJSON(name, val);
			});
		}
		// validatebox&input
		ipts = jQuery("input[name]", target);
		if(skipDisabled) ipts=ipts.not(":disabled");
		if(skipHidden) ipts=ipts.not(":hidden");
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				extendJSON(name, val);
			});
		}
		//textarea
		ipts = jQuery("textarea[name]", target);
		if(skipDisabled) ipts=ipts.not(":disabled");
		if(skipHidden) ipts=ipts.not(":hidden");
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				//返回取备注类型字段时，备注行之间的设定分隔符$c(3)  area单独处理 
				val=val.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
				extendJSON(name, val);
			});
		}
		// function
		function extendJSON(name, val) {
			if(!name) return;
			if(-1 !== $.inArray(name, gettedNames)) {
				// 只获取第一个name的值
				return;
			} else {
				gettedNames.push(name);
			}
			val = 'undefined'!==typeof(val)? val:'';
			var newObj = eval('({"'+name+'":'+jQuery.toJSON(val)+'})');
			jQuery.extend(attrs, newObj,sessionObj);
		}
		return attrs;
	};
	
	/**
	 * 通过JSON设置区块数据
	 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param data json字符串或JSON对象
	 */
	this.fillBlock = function(container, data){
		var json = data;
		if('string'===typeof(data)) json=$.parseJSON(data);
		if(!json) return;
		var target = $(document);
		if(container) {
			target = getJqueryDomElement(container);
		}
		// 遍历并加载数据
		var prefixs=[];
		loopJSON(json);
		//填充后的Json
		FormBlockJson[container]=this.loopBlock(container);
		function loopJSON(json) {
			if(!json) return;
			$.each(json, function(i, d){
				if(null !== d) {
					prefixs.push(i);
					setNameVal(prefixs.join('.'), d);
					prefixs.pop();
				}
			});
		}
		
		//触发Combo的onSelect事件
		function FireComboSelect(Combo, RowId){
			var opts = $.data(Combo, 'combobox').options;
			var Record = opts.finder.getRow(Combo, RowId);
			if(isEmpty(Record)){
				Record = {RowId: RowId};
			}
			opts.onSelect.call(Combo, Record);
		}
		
		function setNameVal(name, val) {
			name = 'undefined'!==typeof(name)? ''+name:'';
			if('' === name) return;
			val = 'undefined'!==typeof(val)? val:'';
			
			// combobox combotree combogrid datetimebox datebox combo
			var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
			var ipts = $('[comboname="' + name + '"]', target);
			if (ipts.length){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					if (ipts.hasClass(type+'-f')){
						if (ipts[type]('options').multiple){
							ipts[type]('setValues', val);
						} else {
							if(type=='datebox') {
								if(isEmpty(val)){return val}
								val=FormatDate(val)
								val = $.fn.datebox.defaults.formatter(val);
							}else if(type=='datetimebox'&&$.isNumeric(val)) {
								var valDate = new Date();valDate.setTime(val);
								val = $.fn.datebox.defaults.formatter(valDate);
							}else if(type=='combobox' && $.type(val) ==='object'){
								//如果是combo, 则进行AddComboData
								AddComboData(ipts, val.RowId, val.Description);
								val = val.RowId;
							}else if(type=='combotree' && $.type(val) === 'object'){
								//这里应该需要封装,时间原因,暂不做处理2020-06-12
								val = val.RowId;
							}
							ipts[type]('setValue', val);
						}
						if(type == 'combobox'){
							ipts.each(function(){
								FireComboSelect(this, val);
							});
						}
						return;
					}
				}
			}
			// numberbox slider
			var cTypes = ['numberbox', 'slider'];
			var f;
			for(var i=0;i<cTypes.length;i++) {
				f = $('input['+cTypes[i]+'name="'+name+'"]', target);
				if (f.length){
					f.eq(0)[cTypes[i]]('setValue', val);
					return;
				}
			}
			// timespinner
			f = $('input[name="'+name+'"].timespinner-f', target);
			if (f && f.length){
				f.eq(0)['timespinner']('setValue', val);
				return;
			}
			// radio checkbox
			var opts = $('input[name="'+name+'"][type=checkbox]', target);
			if(opts.length) {
				opts.prop('checked',false);
				opts.each(function(){
					var f = $(this);
					//if ('array'==$.type(val) && val && -1!==$.inArray(f.val(), val)
					//|| f.val() == String(val)){
					if ((val == true)||('string'==$.type(val) && val=='Y')){
						//f.prop('checked', true);
						$HUI.checkbox(this).setValue(true);
					}else{
						$HUI.checkbox(this).setValue(false);
					}
				});
				return;
			}
			// radio checkbox
			var opts = $('input[name="'+name+'"][type=radio]', target);
			if(opts.length) {
				opts.prop('checked',false);
				opts.each(function(){
					var f = $(this);
					if ('array'==$.type(val) && val && -1!==$.inArray(f.val(), val)
					|| f.val() == String(val)){
						$HUI.radio('#'+f.val()).setValue(true);
					}
				});
				return;
			}
			//lookup
			f = $('input[name="'+name+'"].lookup', target);
			if(f && f.length) {
				if($.type(val) ==='object'){
					f.eq(0)['lookup']('setValue', val['RowId']);
					f.eq(0)['lookup']('setText', val['Description']);
				}else{
					f.eq(0)['lookup']('setValue', val);
				}
				return;
			}
			// input
			f = $('input[name="'+name+'"]', target);
			if(f && f.length) {
				f.val(val);
				return;
			}
			// textarea
			f = $('textarea[name="'+name+'"]', target);
			if(f && f.length) {
				val=handleMemo(val,xMemoDelim());
				f.val(val);
				return;
			}
			// select
			f = $('select[name="'+name+'"]', target);
			if(f && f.length) {
				if(f.hasClass('multiselect2side')) {
					f['multiselect2side']('setValue',val);
				} else {
					f.val(val);
				}
				return;
			}
		}
	};
	this.isChangeBlock=function(container){
		var eq=JSON.stringify(FormBlockJson[container])===JSON.stringify(this.loopBlock(container));
		return !eq;
	}
	/**
	 * 遍历区块数据清空
	 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @author XuChao
	 */
	this.clearBlock = function(container){
		var skipNames = []; //input 选择清空时候  跳过 checkbox,radio
		var target = jQuery(document);
		if(container) {
			target = getJqueryDomElement(container);
		}
		var val='';
		// combo&datebox
		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboName]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboName');
					if (jQuery(this).hasClass(type+'-f')){
						if (jQuery(this)[type]('options').multiple){
							jQuery(this)[type]('setValues',val);
						} else {
							jQuery(this)[type]('setValue',val);
						}
						break;
					}
				}
			});
		}
		// radio&checkbox
		var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
					iptsNames.push(name);
					skipNames.push(name)
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
				var type = iptsFlts.eq(0).attr('type');
				if(type === 'radio') {
					iptsFlts.each(function(){
						if(eval(this.getAttribute("data-options"))){
							$HUI.radio(this).setValue(true);
						}
					});
				} else if(type === 'checkbox') {
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							//通过HUI设置值
							$HUI.checkbox(this).setValue(false);
							//jQuery(this).prop('checked',false);
						}
					});
				}
			}
		}
		// numberbox&slider
		var cTypes = ['numberbox', 'slider'];
		for(var i=0;i<cTypes.length;i++) {
			ipts = jQuery("input["+cTypes[i]+"name]", target);
			if(ipts.length){
				ipts.each(function(){
					var name = jQuery(this).attr(cTypes[i]+'Name');
					jQuery(this)[cTypes[i]]('setValue','');
				});
			}
		}
		// multiselect2side
		ipts = jQuery(".multiselect2side", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				jQuery(this)['multiselect2side']('setValue','');
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				jQuery(this).val('');
			});
		}
		// validatebox&input&textarea
		ipts = jQuery("input[name], textarea[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				jQuery(this).val('');
			});
		}
	}
	
	/**
	 * 创建textarea组件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param width textarea组件的宽度,默认为100
	 * @param height textarea组件的高度,默认为100
	 * @param required textarea组件是否为必填项,默认为false
	 * @author 
	 * @since 
	 */
	this.textarea = function(obj,width,height,required){
		var jqObj = getJqueryDomElement(obj);
		if(jqObj && jqObj.length > 0){
			
			width = width||100;
			jqObj.css("width",width);
			height = height||100;
			jqObj.css("height",height);
			
			if(required==null){
				required = false;
			}
			$CommonUI.getValidateBox(obj).validatebox({  
				required: required 
			});
		}
	};
	/**
	 * 取得textarea对象
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @author 
	 */
	this.getTextarea = function(obj) {
		if(obj){
			return getValidateBox(obj);
		} else {
			return null;
		}
	};
	
	/**
	 * 进度条
	 * @param obj 进度条dom元素，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param progressValue 进度值（参考范围[0-100]）
	 * @param text 显示文本（可选，默认{value}%）
	 * @param color 填充颜色（可选）
	 * @param bordercolor 边框颜色（可选）
	 * @param options 扩展选项（可选）
	 */
	this.progressbar = function(obj, progressValue, text, color, bordercolor, options){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				
			};
			jQuery.extend(_options, { value: progressValue });
			if(text) {
				jQuery.extend(_options, { "text": text });
			}
			options && jQuery.extend(_options, options);
			jqobj.progressbar(_options);
			if(null != color) {
				jqobj.find(".progressbar-value").css("background-color", color);
			}
			if(null != bordercolor) {
				jqobj.css("border-color", bordercolor);
			}
		}
	};
	
	/**
	 * 弹窗
	 * @param obj dom元素，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param href 值（url|object）
	 * @param title 窗口标题（可选）
	 * @param mode 是否模式窗口（可选）
	 * @param closed 是否可手动关闭（可选）
	 * @param cache 是否缓存（可选）
	 * @param options 扩展选项（可选）
	 */
	this.popWin = function(obj, href, title, mode, closed, cache, options){
		if(obj) {
			var jqobj = getJqueryDomElement(obj);
			var _options = { 
				width: 400,
				height: 300
			};
			if(href) jQuery.extend(_options, {'href':href});
			if(title) jQuery.extend(_options, {'title':title});
			if(mode) jQuery.extend(_options, {'mode':mode});
			if(closed) jQuery.extend(_options, {'closed':closed});
			if(cache) jQuery.extend(_options, {'cache':cache});
			if(options) jQuery.extend(_options, options);
			jqobj.dialog(_options);
		}
	};
	
	/**
	 * 下拉列表
	 * @param obj dom元素，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param value 值（url|object）
	 * @param textField 显示值（可选，textField）
	 * @param valueField 保存值（可选，valueField）
	 * @param options 扩展选项（可选）
	 */
	this.combobox = function(obj, value, textField, valueField, options){
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				panelHeight:'auto'
			};
			if(null != textField) {
				jQuery.extend(_options, { "textField": textField });
			}
			if(null != valueField) {
				jQuery.extend(_options, { "valueField": valueField });
			}
			options && jQuery.extend(_options, options);
			if('object' == typeof(value)) {
				// data
				jQuery.extend(_options, {'data': value, 'mode': 'local'});
			} else {
				// url
				jQuery.extend(_options, {'url': value, 'mode': 'remote'});
			}
			jqobj.combobox(_options);
		}
	};

	/**
	 * 取得combobox对象
	 * @param obj dom元素，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 */
	this.getComboBox = function(obj) {
		if(obj){
			return getJqueryDomElement(obj);
		} else {
			return null;
		}
	};
	/**
	 * 表单验证弹出对象
	 * @param obj dom元素，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象(表单id)
	 */
	this.formValidation = function(obj){
		var isValid=true;
		if(obj){
			var jqobj = getJqueryDomElement(obj);
			isValid = jqobj.form('validate');
			if(!isValid){
				jqobj.append("<div id='validationPanel'><div id='validationInfo'></div>");
				
				var obj = $("[class*=validatebox-invalid]", jqobj);
				$('#validationInfo').empty();
				obj.each(function(){
					var validInfo=$(this).prev().html();
					if(!validInfo){
						var validInfo=$(this).parent().prevAll('label').html();
					}
					var data = $(this).data('validatebox');
					$('#validationInfo').append(validInfo+data.message+'<br><br>');
				});
				
				$CommonUI.getDialog('#validationPanel').dialog({title: '提交错误',
					modal:true,closed:true,width:350,height:"auto",
					onClose:function(){$("#validationPanel").dialog('destroy');} });
				$("#validationPanel").dialog("open");
				$(".window-mask").on('click', function() {
					var val=$("#validationPanel").parent().css("display");
					if(val=="block"){
						$("#validationPanel").dialog('destroy');
						$(".window-mask").off();
					}
				});
			}
			return isValid;
		}
		return isValid;
	};
	/*
	*清空Grid
	* @param obj 对象
	*
	*/
	this.clear=function(obj){
		if(obj){
			obj.clearSelections();
			obj.loadData({total:0,rows:[]});
			obj.setFooterInfo()
		}
	}
	/*设置Grid的url $Url
	*/
	this.setUrl=function(obj){
		if(obj){
		obj.jdata.options.url=$URL
		}
	}
	/*检查必填项
	 * 通过 返回true
	 * 不通过 返回 false
	*/
	this.checkMustInput=function(Block,json){
		var length=FormMustInput[Block].length
		for (var i=0;i<length;i++){
			var val=json[FormMustInput[Block][i]];
			if(isEmpty(val)){
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 初始化CommonUI
	 */
	this._init();
}

/**
 * 获取标签定义在class上的属性值
 * @param obj 对象（dom对象|jQuery对象|标签id）
 * @param propertyName
 * @returns
 */
CommonUI.getClassProperty = function(obj, propertyName){
	return getClassProperty(obj, propertyName);
};

/**
 * 在标签的class上自定义属性（class中添加表达式格式“[p=pvalue]”）
 * @param obj 对象（dom对象|jQuery对象|标签id）
 * @param propertyName 属性名
 * @param propertyValue 属性值
 * @returns
 */
CommonUI.setClassProperty = function(obj, propertyName, propertyValue){
	return setClassProperty(obj, propertyName, propertyValue);
};

/*====================================================================
								~CommonUI
======================================================================*/
/**
 * CommonUI默认实例
 */
var $UI=$CommonUI = new CommonUI();
