/*
* @description: 卡片预览
* @params:		_options.renderToId - 卡片渲染外部ID
* 				_options.authStr - 权限字符串
* 				_options.picCode - 卡片ID
* @js:			pha/sys/v1/card.preview.js
* @others:		依赖 pha/sys/v1/homepage.com.js
*/ 
function CardPreview(cardPreviewId, _options) {
	if (_options == 'hide' && $("#" + cardPreviewId).length > 0) {
		$("#" + cardPreviewId).hide();
		return;
	}
	if (_options == 'isHide') {
		if ($("#" + cardPreviewId).length == 0) {
			return true; // 隐藏的
		}
		var cardDisplay = $("#" + cardPreviewId).css('display');
		if (cardDisplay == 'block') {
			return false; // 显示的
		} else {
			return true; // 隐藏的
		}
		return true; // 隐藏的
	}
	
	if ($("#" + cardPreviewId).length == 0) {
		var htmlStr = 
		'<div id="' + cardPreviewId + '" class="hisui-layout" fit="true">' +
			'<div data-options="region:\'center\',border:false" class="pha-body">' +
			'</div>' +
		'</div>';
		$("#" + _options.renderToId).append(htmlStr);
		$.parser.parse("#" + _options.renderToId);
	}
	$("#" + cardPreviewId).show();
	$("#" + cardPreviewId).children().eq(0).children().eq(0).niceScroll({
		cursoropacitymax: 1,
		cursorwidth: '4px',
		horizrailenabled: false,
		scrollspeed: 60
	});
	$("#" + cardPreviewId).children().eq(0).children().eq(0).children().remove();
	_options.cardPreviewId =cardPreviewId;
	CardPreviewData(_options);
}

// 卡片预览数据
function CardPreviewData(_options){
	$.cm({
		ClassName: 'PHA.SYS.HomePage.Query',
		MethodName: 'QueryOneCard',
		authStr: _options.authStr,
		picCode: _options.picCode
	}, function(retJson){
		if (retJson.success == 0) {
			alert(retJson.msg);
			return;
		}
		var normalOpt = retJson.normalOpt;
		if (normalOpt == null) {
			return;
		}
		var cardId = normalOpt.picCode;
		$("#" + _options.cardPreviewId).children().eq(0).children().eq(0).append("<div id='" + cardId + "'></div>");
		CardPreviewDataAdd(retJson);
		PHA_HOMEPAGE.ResizeScroll();
	});
}

// 卡片预览数据添加
function CardPreviewDataAdd(_cardOptions){
	var hisuiOpt = _cardOptions.hisuiOpt;
	var normalOpt = _cardOptions.normalOpt;
	var items = _cardOptions.items;
	if (typeof normalOpt == "undefined") {
		return;
	}
	/* 卡片整体 */
	hisuiOpt.id = normalOpt.picCode;
	hisuiOpt.headerCls = 'panel-header-gray';
	hisuiOpt.height = (hisuiOpt.height == "" || parseFloat(hisuiOpt.height) <= 0) ? 200 : parseFloat(hisuiOpt.height);
	hisuiOpt.title = hisuiOpt.title == "" ? normalOpt.picDesc : hisuiOpt.title;
	var renderToId = hisuiOpt.id;
	if (normalOpt.preloadCsp != "") {
		$.ajax({
			url: normalOpt.preloadCsp,
			async: false, // 要不要改成异步, todo...
			success: function(_htmlText) {
				hisuiOpt.content = _htmlText; // 预加载CSP
				renderToId = normalOpt.renderTo;
			}
		});
	}
	if (normalOpt.layoutType == "T" && _cardOptions.forms.length == 0) {
		hisuiOpt.title = "";
	}
	/* 添加卡片右上角按钮 */
	var _tools = [];
	if (parseInt(normalOpt.refreshBtn) == 1) {
		_tools.push({
			iconCls:'icon-reload',
			handler: function(){
				_cardOptions.isReload = true;
				PHA_HOMEPAGE.LoadCardContent(_cardOptions);
			}
		});
	}
	if (normalOpt.helpInfo != "") {
		_tools.push({
			iconCls:'icon-help',
			handler: function(){
				PHA_HOMEPAGE.OpenHelpWin(normalOpt.helpInfo);
			}
		});
	}
	if (_tools.length > 0) {
		hisuiOpt.tools = _tools;
	}
	/* add card panel */
	$('#' + hisuiOpt.id).panel(hisuiOpt);
	setTimeout(function(){
		$('#' + hisuiOpt.id).addClass('content_noscroll');
	}, 10);
	/* 预加载CSP查询按钮 */
	if (normalOpt.preloadCsp != "") {
		$('#' + renderToId + '-' + 'find').on('click', function(){
			_cardOptions.isReload = true;
			PHA_HOMEPAGE.LoadCardContent(_cardOptions);
		});
	}
	var _cardId = hisuiOpt.id;
	if (typeof PHA_HOMEPAGE.CheckEmptyCard[hisuiOpt.id] != "undefined") {
		PHA_HOMEPAGE.CheckEmptyCard[hisuiOpt.id] = 0;
	}
	/* 加载卡片内容 */
	_cardOptions.renderToId = renderToId;
	PHA_HOMEPAGE.LoadCardContent(_cardOptions);
}