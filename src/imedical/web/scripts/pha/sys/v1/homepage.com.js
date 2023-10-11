/*
 * descriotion: ҩѧ��ҳ - ҳ��Ԫ�����ɿ�(��Ƭ��ʽ��)
 * creaator:	Huxt 2020-05-10
 * js:			pha/sys/v1/homepage.com.js
 * others:      this used in pha/sys/v1/homepage.js
 */
var PHA_HOMEPAGE = {
	LayoutOptions: {},
	Cards: [],
	CurrentCardNum: 0,
	IconPath: '../scripts/pha/sys/v1/icons/',
	FilePath: '../scripts/pha/sys/v1/files/',
	CommonQueryPage: 'pha.com.v1.query.csp',
	ResizeCards: {},
	PaddingCard: ['todoCard', 'dataCard', 'lnkCard'],
	CheckEmptyCard: {
		todoCard: 0,
		dataCard: 0
	},
	WindowsOpen: {},
	PageMaxCols: 4,
	TabIndex: 0,
	AuthStr: session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'],
	colorArr: ['#60D6CD', '#01AAEC', '#3495D8', '#FFBA42', '#F98B70', '#B7A1DF'],
	pageWidth: 0,
	emptyPanelHeight: 208,
	/*
	 * @description: ҳ�沼�ֹ������� (��1��)
	 * @creator:     Huxt 2020-05-11
	 * @params:      _options
	 * @others:      pha/sys/v1/homepage.js
	 */
	Layout: function (_options) {
		// �û��Ƿ��л�����. Huxt 2022-09-16
		if (typeof HomePage_selectedLocId != 'undefined' && HomePage_selectedLocId != '') {
			var authArr = this.AuthStr.split('^');
			authArr[3] = HomePage_selectedLocId;
			this.AuthStr = authArr.join('^');
		}
		// ��������
		var authStr = this.AuthStr;
		var layoutOptStr = tkMakeServerCall("PHA.SYS.HomePage.Query", "GetPageConfig", authStr);
		this.LayoutOptions = eval('(' + layoutOptStr + ')');
		// ����Ĭ��
		this.LayoutOptions.cardLoadAnimate = this.LayoutOptions.cardLoadAnimate || 'N';
		this.LayoutOptions.cardLoadMode = this.LayoutOptions.cardLoadMode || 'M';
		this.LayoutOptions.cardLoadNum = this.LayoutOptions.cardLoadNum || 8;
		this.LayoutOptions.includeInTabs = this.LayoutOptions.includeInTabs || 'N';
		this.LayoutOptions.effectiveWidth = this.LayoutOptions.effectiveWidth || '100%'; // �˲���ͣ�� 2021-02-19
		this.LayoutOptions.colWidthRateList = this.LayoutOptions.colWidthRateList || '0,0.7,0.3,0';
		this.LayoutOptions.niceScroll = this.LayoutOptions.niceScroll || 'Y';
		var colWidthRateArr = this.LayoutOptions.colWidthRateList.split(',');
		if (colWidthRateArr.length <= 2) {
			this.LayoutOptions.colWidthRateList = "0," + this.LayoutOptions.colWidthRateList + ",0";
			colWidthRateArr = this.LayoutOptions.colWidthRateList.split(',');
		}
		// ��ȡ������ַ���
		var includeInTabs = this.LayoutOptions.includeInTabs;
		var _bodyCls = includeInTabs == "Y" || includeInTabs == "1" || includeInTabs == 1 ? 'pha-body' : '';
		var htmlStr = this.GetLayoutHtml();
		$('#layout-container').layout('add', {
			region: 'center',
			border: false,
			content: htmlStr,
			bodyCls: _bodyCls
		});
		if ($('#layout-container-tabs').length > 0) {
			$.parser.parse('#layout-container-tabs');
		}
		// ҳ��Ŀհ׿��
		if (this.isLiteCss()) {
			$('#layout-container').layout('panel', 'center').children().eq(0).css('background-color', '#f5f5f5');
		}
		this.pageWidth = $('#layout-container').layout('panel', 'center')[0].offsetWidth; // ҳ���ܿ��
		var paddingLeft = colWidthRateArr[0] * this.pageWidth; // ���հ׿��
		paddingLeft = paddingLeft > 10 ? paddingLeft : 10;
		var paddingRight = colWidthRateArr[colWidthRateArr.length - 1] * this.pageWidth; // �Ҳ�հ׿��
		paddingRight = paddingRight > 10 ? paddingRight : 10;
		// ���������
		var scrollWidth = this.LayoutOptions.niceScroll == 'Y' ? 0 : 18;
		// portal
		$('#portal-layout').portal({
			border: false,
			fit: true,
			paddingLeft: paddingLeft,
			paddingRight: paddingRight,
			scrollWidth: scrollWidth,
			onStateChange: function () {
				PHA_HOMEPAGE.SaveLayoutSort();
			}
		});
		$('#portal-layout').css('overflow-x', 'hidden');
		$('#portal-layout').parent().css('overflow', 'hidden');
		// ��ʼ��������
		if (this.LayoutOptions.niceScroll == 'Y') {
			$('#portal-layout').niceScroll({
				cursoropacitymax: 1,
				cursorwidth: '4px',
				horizrailenabled: false,
				scrollspeed: 60
			});
			/*
			$('#portal-layout').mCustomScrollbar({
		        theme: 'inset-2-dark',
		        scrollInertia: 100
		    });
		    */
		}
	},
	/*
	 * @description: ��ʼ����Ƭ  (��3��)
	 * @creator:     Huxt 2020-05-11
	 * @params:      _options
	 * @others:      pha/sys/v1/homepage.js
	 */
	InitCards: function (_options) {
		var authStr = this.AuthStr;
		$.cm({
			ClassName: 'PHA.SYS.HomePage.Query',
			MethodName: 'QueryAllCards',
			authStr: authStr
		}, function (retJson) {
			if (retJson.success == 0) {
				alert(retJson.msg);
				return;
			}
			var cardLen = retJson.length;
			if (cardLen == 0) {
				alert("δ��ȡ�����õĿ�Ƭ, ������Ȩ��");
				return;
			}
			for (var i = 0; i < cardLen; i++) {
				PHA_HOMEPAGE.ShowOneCard(retJson[i]);
			}
			$('#portal-layout').portal('resize');

			setTimeout(function () {
				PHA_HOMEPAGE.ResizeScroll();
				PHA_HOMEPAGE.InitMac();
			}, 1000);
		});
	},
	/*
	 * @description: ��ʼ����Ƭ - ��ʾһ����Ƭ
	 */
	ShowOneCard: function (_cardOptions) {
		var hisuiOpt = _cardOptions.hisuiOpt;
		var normalOpt = _cardOptions.normalOpt;
		var items = _cardOptions.items;
		if (typeof normalOpt == "undefined") {
			return;
		}
		if (!this.hasProperty(hisuiOpt)) {
			return;
		}
		/* ��Ƭ���� */
		hisuiOpt.id = normalOpt.picCode;
		hisuiOpt.headerCls = 'panel-header-gray';
		hisuiOpt.height = (hisuiOpt.height == "" || parseFloat(hisuiOpt.height) <= 0) ? 200 : parseFloat(hisuiOpt.height);
		hisuiOpt.title = hisuiOpt.title == "" ? normalOpt.picDesc : hisuiOpt.title;
		var renderToId = hisuiOpt.id;
		if (normalOpt.preloadCsp && normalOpt.preloadCsp != "") {
			var urlCsp = normalOpt.preloadCsp;
			urlCsp = urlCsp.indexOf('?') > 0 ? '' : '?'
			if ('undefined' !== typeof websys_getMWToken){
				urlCsp += "&MWToken=" + websys_getMWToken();
			}
			$.ajax({
				url: urlCsp,
				async: false, // Ҫ��Ҫ�ĳ��첽, todo...
				success: function (_htmlText) {
					hisuiOpt.content = _htmlText; // Ԥ����CSP
					renderToId = normalOpt.renderTo;
				}
			});
		}
		if (normalOpt.layoutType == "T" && _cardOptions.forms.length == 0) {
			hisuiOpt.title = "";
		}
		/* ��ӿ�Ƭ���Ͻǰ�ť */
		var _tools = [];
		if (parseInt(normalOpt.refreshBtn) == 1) {
			_tools.push({
				iconCls: 'icon-reload',
				handler: function () {
					_cardOptions.isReload = true;
					PHA_HOMEPAGE.LoadCardContent(_cardOptions);
				}
			});
		}
		if (normalOpt.helpInfo != "") {
			_tools.push({
				iconCls: 'icon-help',
				handler: function () {
					PHA_HOMEPAGE.OpenHelpWin(normalOpt.helpInfo);
				}
			});
		}
		if (_tools.length > 0) {
			hisuiOpt.tools = _tools;
		}
		/* add card to portal panel */
		var portalColIndex = normalOpt.portalColIndex;
		if (this.LayoutOptions.pageCols == 1) {
			portalColIndex = PHA_HOMEPAGE.CurrentCardNum % this.LayoutOptions.pageCols;
			PHA_HOMEPAGE.CurrentCardNum = PHA_HOMEPAGE.CurrentCardNum + 1;
		} else {
			if (portalColIndex == 'R') {
				portalColIndex = this.LayoutOptions.pageCols - 1;
			} else if (portalColIndex == "" || typeof portalColIndex == "undefined" || parseFloat(portalColIndex) > this.LayoutOptions.pageCols - 1) {
				portalColIndex = PHA_HOMEPAGE.CurrentCardNum % (this.LayoutOptions.pageCols - 1);
				PHA_HOMEPAGE.CurrentCardNum = PHA_HOMEPAGE.CurrentCardNum + 1;
			} else {
				PHA_HOMEPAGE.CurrentCardNum = PHA_HOMEPAGE.CurrentCardNum + 1;
			}
			portalColIndex = parseFloat(portalColIndex);
		}
		var cardPanel = $('<div></div>').appendTo('body');
		cardPanel.panel(hisuiOpt);
		$('#portal-layout').portal('add', {
			panel: cardPanel,
			columnIndex: portalColIndex
		});
		/* Ԥ����CSP��ѯ��ť */
		if (normalOpt.preloadCsp != "") {
			$('#' + renderToId + '-' + 'find').on('click', function () {
				_cardOptions.isReload = true;
				PHA_HOMEPAGE.LoadCardContent(_cardOptions);
			});
		}
		/* ���ؿ�Ƭ���� */
		_cardOptions.renderToId = renderToId;
		setTimeout(function(){
			PHA_HOMEPAGE.LoadCardContent(_cardOptions);
		}, 0);
	},
	/*
	 * @description: ��ʼ����Ƭ - ���ؿ�Ƭ����
	 */
	LoadCardContent: function (_cardOptions) {
		var isReload = _cardOptions.isReload;
		var renderToId = _cardOptions.renderToId;
		var hisuiOpt = _cardOptions.hisuiOpt;
		var normalOpt = _cardOptions.normalOpt;
		var items = _cardOptions.items;
		var forms = _cardOptions.forms;
		/* ��Ƭ�ֳɱ������������� */
		var selTabIndex = 0;
		var queryParams = {};
		if (isReload) {
			// ��ʼ����ֵ
			var _cardId = hisuiOpt.id;
			if (typeof this.CheckEmptyCard[_cardId] != "undefined") {
				this.CheckEmptyCard[_cardId] = 0;
			}
			if (typeof this.ResizeCards[_cardId] != "undefined") {
				var cardInitHeight = hisuiOpt.height;
				$('#' + _cardId).panel('resize', {
					height: cardInitHeight
				});
				this.ResizeCards[_cardId]["curHeight"] = cardInitHeight;
				this.ResizeCards[_cardId]["curCardNum"] = 0;
			}
			// �����������
			$('#' + _cardOptions.contentId)
			if (normalOpt.layoutType == "T") {
				var selTab = $('#' + _cardOptions.contentId).tabs('getSelected');
				var selTabIndex = $('#' + _cardOptions.contentId).tabs('getTabIndex', selTab) || 0;
			}
			$('#' + _cardOptions.contentId).remove();
			$('#' + renderToId).append("<div id='" + _cardOptions.contentId + "' style='height:" + (_cardOptions.contentHeight) + "px;width:100%'></div>");
			// ������
			queryParams = this.GetFormDatta(hisuiOpt.id);
		} else {
			// ������
			if (forms.length > 0) {
				_cardOptions.formId = renderToId + '-' + 'form';
				$('#' + renderToId).append("<div id='" + _cardOptions.formId + "' class='div-form-container'></div>");
				this.CardItem_Forms({
					forms: forms,
					cardId: renderToId,
					cardFormId: _cardOptions.formId,
					queryParams: queryParams
				}, _cardOptions);
			}
			var formHeight = 0;
			var $cardForm = $('#' + _cardOptions.formId);
			if ($cardForm.length > 0) {
				formHeight = $cardForm[0].clientHeight;
			}
			// ��������
			var allHeight = $('#' + renderToId).height();
			if (allHeight == null) {
				if (renderToId == '') {
					console.log("��Ƭ����:" + normalOpt.picCode + ": δָ����Ⱦ����id");
				} else {
					console.log("��Ƭ����:" + normalOpt.picCode + ": ָ������Ⱦ����id:" + renderToId + "��CSP�в�����");
				}
				return;
			}
			_cardOptions.contentId = renderToId + '-' + 'content';
			_cardOptions.contentHeight = allHeight - formHeight - 1;
			$('#' + renderToId).append("<div id='" + _cardOptions.contentId + "' style='height:" + (_cardOptions.contentHeight) + "px;width:100%'></div>");
		}
		queryParams.LogonStr = this.AuthStr;
		_cardOptions.queryParams = queryParams;

		/* ���ݲ�ͬ�Ĳ��ַ�ʽ�������� */
		var itemsLen = items.length;
		if (normalOpt.layoutType == "T") {
			// �����Tabs
			var pWidth = $('#' + renderToId).width();
			$('#' + _cardOptions.contentId).addClass('hisui-tabs tabs-gray');
			$('#' + _cardOptions.contentId).tabs({
				fit: false,
				width: pWidth,
				border: false,
				height: _cardOptions.contentHeight
			});
			// ���������
			for (var i = 0; i < itemsLen; i++) {
				var oneCardItem = items[i];
				var itemRenderToId = _cardOptions.contentId + "-" + i;
				oneCardItem.normalOpt.itemRenderToId = itemRenderToId;

				var _text = oneCardItem.normalOpt.text != "" && typeof oneCardItem.normalOpt.text != "undefined" ? oneCardItem.normalOpt.text : oneCardItem.normalOpt.piciDesc;
				$('#' + _cardOptions.contentId).tabs('add', {
					title: _text,
					content: "<div id='" + itemRenderToId + "'></div>",
					fit: true,
					selected: true, // ������true
					closable: false
				});
				var pHeight = $("#" + itemRenderToId).parent().height();
				var pWidth = $("#" + itemRenderToId).parent().width();
				$("#" + itemRenderToId).height(pHeight);
				$("#" + itemRenderToId).width(pWidth);
				this.CardItem(oneCardItem, _cardOptions);
			}
			$('#' + _cardOptions.contentId).tabs('select', selTabIndex);
		} else if (normalOpt.layoutType == "S") {
			// ��Ҫ�߾�� (JS��д����,������չ��ע��,todo...)
			if (this.PaddingCard.indexOf(hisuiOpt.id) >= 0) {
				$('#' + _cardOptions.contentId).css('padding', '5px 0px 5px 0px');
				$('#' + _cardOptions.contentId).height($('#' + _cardOptions.contentId).height() - 9);
			}
			// ��¼������Ӧ�߶ȵĿ�Ƭ
			if (normalOpt.autoHeight == 1) {
				var cardHeight = parseInt($('#' + hisuiOpt.id).css('height'));
				var cardWidth = parseInt($('#' + hisuiOpt.id).css('width'));
				this.ResizeCards[hisuiOpt.id] = {
					width: cardWidth,
					height: cardHeight,
					curHeight: cardHeight,
					curCardNum: 0
				}
			}
			// ֱ����������Ӽ���
			for (var i = 0; i < itemsLen; i++) {
				var oneCardItem = items[i];
				var itemRenderToId = _cardOptions.contentId;
				oneCardItem.normalOpt.itemRenderToId = itemRenderToId;
				this.CardItem(oneCardItem, _cardOptions);
			}
		} else if (normalOpt.layoutType == "RC") {
			if (itemsLen == 1) {
				var oneCardItem = items[0];
				var itemRenderToId = _cardOptions.contentId + "0-0-inner";
				$('#' + _cardOptions.contentId).append("<div id='" + itemRenderToId + "' style='width:100%;height:100%'></div>");
				oneCardItem.normalOpt.itemRenderToId = itemRenderToId;
				this.CardItem(oneCardItem, _cardOptions);
			} else {
				// ����������Grid
				$('#' + _cardOptions.contentId).parent().addClass('content_noscroll'); // ������������
				var initRet = this.InitRCLayout(_cardOptions);
				if (initRet == false) {
					return;
				}
				// ���������
				for (var i = 0; i < itemsLen; i++) {
					var oneCardItem = items[i];
					var keyWord = oneCardItem.normalOpt.piccCode;
					if (_cardOptions.normalOpt.splitType == 'D' && keyWord.indexOf('hisui') >= 0) {
						oneCardItem.hisuiOpt.border = true;
					}
					var itemRenderToId = _cardOptions.contentId + '-' + (oneCardItem.normalOpt.piciRowIndex - 1) + '-' + (oneCardItem.normalOpt.piciColIndex - 1) + '-' + 'inner';
					oneCardItem.normalOpt.itemRenderToId = itemRenderToId;
					this.CardItem(oneCardItem, _cardOptions);
				}
			}
		} else {
			alert("��Ƭ:" + normalOpt.picCode + "δָ�����ַ�ʽ!!!");
		}
	},
	// ����һ������
	CardItem: function (_oneCardItem, _cardOptions) {
		var _keyWord = _oneCardItem.normalOpt.piccCode;
		if (_keyWord.indexOf('todo') == 0) {
			this.CardItem_Todo(_oneCardItem, _cardOptions);
		} else if (_keyWord.indexOf('data') == 0) {
			this.CardItem_Data(_oneCardItem, _cardOptions);
		} else if (_keyWord.indexOf('lnk') == 0) {
			this.CardItem_Lnk(_oneCardItem, _cardOptions);
		} else if (_keyWord.indexOf('doc') == 0) {
			this.CardItem_Doc(_oneCardItem, _cardOptions);
		} else if (_keyWord.indexOf('hisui') == 0) {
			this.CardItem_DataGrid(_oneCardItem, _cardOptions);
		} else if (_keyWord.indexOf('echarts') == 0) {
			this.CardItem_ECharts(_oneCardItem, _cardOptions);
		} else {
			alert("��Ƭ���ݴ���:" + _keyWord + "δά���ؼ��ִ���!!!");
		}
	},
	CardItem_Todo: function (_oneCardItem, _cardOptions) {
		// card
		var _cardId = _cardOptions.hisuiOpt.id;
		var _queryParams = _cardOptions.queryParams;
		// card item
		var _normalOpt = _oneCardItem.normalOpt;
		var _renderToId = _normalOpt.itemRenderToId;
		var _text = _normalOpt.text != "" ? _normalOpt.text : _normalOpt.piciDesc;
		_normalOpt.text = _text;
		_queryParams.InputStr = _normalOpt.InputStr || "";
		// get html
		var itemHtmlStr = "";
		itemHtmlStr += "<div id='" + _normalOpt.piciCode + "' class='todo-cell' style='display:none'>";
		itemHtmlStr += "	<div class='todo-cell-left'>";
		itemHtmlStr += "		<div class='todo-cell-leftNum'>" + "" + "</div>";
		itemHtmlStr += "		<div class='todo-cell-leftText'>" + _text + "</div>";
		itemHtmlStr += "	</div>";
		itemHtmlStr += "	<div class='todo-cell-right'>";
		itemHtmlStr += "		<img src='" + this.IconPath + _normalOpt.icon + ".png'/>";
		itemHtmlStr += "	</div>";
		itemHtmlStr += "</div>";
		$('#' + _renderToId).append(itemHtmlStr); // ��֤˳��,�����,���Ч�� todo...
		var postData = $.extend({}, {
			ClassName: _normalOpt.ClassName,
			MethodName: _normalOpt.MethodName
		}, _queryParams);

		$.ajax({
			url: $URL,
			type: "get",
			data: postData,
			dataType: "text",
			success: function (responseTxt, statusTxt, xhr) {
				// û������
				var responseMsg = '';
				if(responseTxt.indexOf('^') >= 0){
					responseMsg = responseTxt.split('^')[1];
					responseTxt = responseTxt.split('^')[0];
				}
				responseMsg = responseMsg == '' ? responseTxt : responseTxt + '(' + responseMsg +')';
				responseTxt = parseFloat(responseTxt);
				if (responseTxt == 0 || isNaN(responseTxt) == true) {
					if (typeof PHA_HOMEPAGE.CheckEmptyCard[_cardId] != "undefined") {
						PHA_HOMEPAGE.CheckEmptyCard[_cardId] = PHA_HOMEPAGE.CheckEmptyCard[_cardId] + 1;
						if (PHA_HOMEPAGE.CheckEmptyCard[_cardId] == _cardOptions.items.length) {
							var $renderTo = $('#' + _renderToId);
							var $renderToPar = $renderTo.parent();
							var cardWidth = $renderToPar.width();
							var marginLeft = parseInt((cardWidth - 389) / 2);
							$renderTo.append("<img src='" + PHA_HOMEPAGE.IconPath + "empty-data" + ".png' style='margin-left:" + marginLeft + "px;'/>");
							PHA_HOMEPAGE.CheckEmptyCard[_cardId] = 0;
							$('#' + _cardId).panel('resize', {
								height: PHA_HOMEPAGE.emptyPanelHeight
							});
						}
					}
					return;
				}
				// $('#' + _renderToId).append(itemHtmlStr);
				var piciCode = _normalOpt.piciCode;
				var cellObj = $('#' + _cardId + ' #' + piciCode);
				cellObj.css('display', 'block');
				cellObj.children().eq(0).children().eq(0).text(responseMsg); // ����
				cellObj.css('background-color', _normalOpt.backgroundColor); // ��ɫ
				cellObj.hover(function () {
					cellObj.css('background-color', _normalOpt.hoverBackgroundColor); // ��ͣ��ɫ
				}, function () {
					cellObj.css('background-color', _normalOpt.backgroundColor); // ������ɫ
				});
				cellObj.on('click', function () {
					PHA_HOMEPAGE.OpenLink(_oneCardItem, _cardOptions); // �������
				});
				if (_normalOpt.hoverTips != "") {
					cellObj.attr('title', _normalOpt.hoverTips); // ��ͣ��ʾ
					cellObj.tooltip({
						position: 'bottom'
					});
				}
				// ����Ӧ�߶�
				PHA_HOMEPAGE.ResizeCardHeight({
					cardId: _cardId,
					cellWidth: 260 + 10 + 10,
					cellHieght: 68 + 5 + 5 // css: todo-cell
				});
			},
			error: function (responseTxt, statusTxt, xhr) {
				console.log(responseTxt);
			}
		});
	},
	CardItem_Data: function (_oneCardItem, _cardOptions) {
		// card
		var _cardId = _cardOptions.hisuiOpt.id;
		var _queryParams = _cardOptions.queryParams;
		// card item
		var _normalOpt = _oneCardItem.normalOpt;
		var _renderToId = _normalOpt.itemRenderToId;
		var _text = _normalOpt.text != "" ? _normalOpt.text : _normalOpt.piciDesc;
		_normalOpt.text = _text;
		_queryParams.InputStr = _normalOpt.InputStr || "";
		// get html
		var itemHtmlStr = "";
		itemHtmlStr += "<div id='" + _normalOpt.piciCode + "' class='data-cell' style='display:none'>";
		itemHtmlStr += "	<div class='data-cell-left'>";
		itemHtmlStr += "		<div class='data-cell-leftImg'>";
		itemHtmlStr += "			<img src='" + this.IconPath + _normalOpt.icon + ".png'/>";
		itemHtmlStr += "		</div>";
		itemHtmlStr += "		<div class='data-cell-leftNum'>" + "" + "</div>";
		itemHtmlStr += "	</div>";
		itemHtmlStr += "	<div class='data-cell-right'>" + _text + "</div>";
		itemHtmlStr += "</div>";
		$('#' + _renderToId).append(itemHtmlStr);
		var postData = $.extend({}, {
			ClassName: _normalOpt.ClassName,
			MethodName: _normalOpt.MethodName
		}, _queryParams);

		$.ajax({
			url: $URL,
			type: "get",
			data: postData,
			dataType: "text",
			success: function (responseTxt, statusTxt, xhr) {
				// û������
				responseTxt = parseFloat(responseTxt);
				if (responseTxt == 0 || isNaN(responseTxt) == true) {
					if (typeof PHA_HOMEPAGE.CheckEmptyCard[_cardId] != "undefined") {
						PHA_HOMEPAGE.CheckEmptyCard[_cardId] = PHA_HOMEPAGE.CheckEmptyCard[_cardId] + 1;
						if (PHA_HOMEPAGE.CheckEmptyCard[_cardId] == _cardOptions.items.length) {
							var $renderTo = $('#' + _renderToId);
							var $renderToPar = $renderTo.parent();
							var cardWidth = $renderToPar.width();
							var marginLeft = parseInt((cardWidth - 88) / 2);
							var marginTop = 60;
							$('#' + _renderToId).append("<div style='font-size:22px; color:#999999; margin-left:" + marginLeft + "px; margin-top:" + marginTop + "px;'>��������</div>");
							PHA_HOMEPAGE.CheckEmptyCard[_cardId] = 0;
							$('#' + _cardId).panel('resize', {
								height: PHA_HOMEPAGE.emptyPanelHeight
							});
						}
					}
					return;
				}
				// $('#' + _renderToId).append(itemHtmlStr);
				var piciCode = _normalOpt.piciCode;
				var cellObj = $('#' + _cardId + ' #' + piciCode);
				cellObj.css('display', 'block');
				cellObj.children().eq(0).children().eq(1).text(responseTxt); // ����
				cellObj.on('click', function () {
					PHA_HOMEPAGE.OpenLink(_oneCardItem, _cardOptions); // �������
				});
				if (_normalOpt.hoverTips != "") {
					cellObj.attr('title', _normalOpt.hoverTips); // ��ͣ��ʾ
					cellObj.tooltip({
						position: 'bottom'
					});
				}
				// ����Ӧ�߶�
				PHA_HOMEPAGE.ResizeCardHeight({
					cardId: _cardId,
					cellWidth: 260 + 10 + 10,
					cellHieght: 68 + 5 + 5 // css: data-cell
				});
			},
			error: function (responseTxt, statusTxt, xhr) {
				console.log(responseTxt);
			}
		});
	},
	CardItem_Lnk: function (_oneCardItem, _cardOptions) {
		// card
		var _cardId = _cardOptions.hisuiOpt.id;
		var _queryParams = _cardOptions.queryParams;
		// card item
		var _normalOpt = _oneCardItem.normalOpt;
		var _renderToId = _normalOpt.itemRenderToId;
		var _text = _normalOpt.text != "" ? _normalOpt.text : _normalOpt.piciDesc;
		_normalOpt.text = _text;
		_queryParams.InputStr = _normalOpt.InputStr || "";
		// get html
		var itemHtmlStr = "";
		itemHtmlStr += "<div id='" + _normalOpt.piciCode + "' class='link-cell'>";
		itemHtmlStr += "	<div class='link-cell-top'>";
		itemHtmlStr += "		<div class='link-cell-topImg'>";
		itemHtmlStr += "			<img src='" + this.IconPath + _normalOpt.icon + ".png'/>";
		itemHtmlStr += "		</div>";
		itemHtmlStr += "		<div class='link-cell-topNum'>" + "" + "</div>";
		itemHtmlStr += "	</div>";
		itemHtmlStr += "	<div class='link-cell-bottom'>" + _text + "</div>";
		itemHtmlStr += "</div>";
		// �������
		var piciCode = _normalOpt.piciCode;
		$('#' + _renderToId).append(itemHtmlStr);
		var cellObj = $('#' + _cardId + ' #' + piciCode);
		cellObj.on('click', function () {
			PHA_HOMEPAGE.OpenLink(_oneCardItem, _cardOptions); // �������
		});
		if (_normalOpt.hoverTips != "") {
			cellObj.attr('title', _normalOpt.hoverTips); // ��ͣ��ʾ
			cellObj.tooltip({
				position: 'bottom'
			});
		}
		// ��ʾ����
		if (_normalOpt.ClassName != "" && _normalOpt.MethodName != "") {
			var postData = $.extend({}, {
				ClassName: _normalOpt.ClassName,
				MethodName: _normalOpt.MethodName
			}, _queryParams);

			$.ajax({
				url: $URL,
				type: "get",
				data: postData,
				dataType: "text",
				success: function (responseTxt, statusTxt, xhr) {
					cellObj.children().eq(0).children().eq(1).text(responseTxt); // ����
				},
				error: function (responseTxt, statusTxt, xhr) {
					console.log(responseTxt);
				}
			});
		}
		// ����Ӧ�߶�
		PHA_HOMEPAGE.ResizeCardHeight({
			cardId: _cardId,
			cellWidth: 90 + 10 + 10,
			cellHieght: 90 + 5 + 5 // css: link-cell
		});
	},
	CardItem_Doc: function (_oneCardItem, _cardOptions) {
		// card
		var _cardId = _cardOptions.hisuiOpt.id;
		var _queryParams = _cardOptions.queryParams;
		// card item
		var _normalOpt = _oneCardItem.normalOpt;
		var _renderToId = _normalOpt.itemRenderToId;
		var _text = _normalOpt.text != "" ? _normalOpt.text : _normalOpt.piciDesc;
		_normalOpt.text = _text;
		// get html
		var _outerWidth = $('#' + _renderToId).width();
		var _textWidth = parseFloat(_outerWidth) - 52 - 46; // ��ȥͼ�� & ������
		var itemHtmlStr = "";
		itemHtmlStr += "<div id='" + _normalOpt.piciCode + "' class='div-file-row'>";
		itemHtmlStr += "	<div class='div-file-row-inner'>";
		itemHtmlStr += "		<div class='div-file-row-left'>";
		itemHtmlStr += "			<img src='" + this.IconPath + _normalOpt.icon + ".png'/>";
		itemHtmlStr += "		</div>";
		itemHtmlStr += "		<div class='div-file-row-right' style='width:" + _textWidth + "px;'>" + _text + "</div>";
		itemHtmlStr += "	</div>";
		itemHtmlStr += "</div>";
		// add html and event
		var piciCode = _normalOpt.piciCode;
		$('#' + _renderToId).append(itemHtmlStr);
		var cellObj = $('#' + _cardId + ' #' + piciCode);
		cellObj.on('click', function () {
			PHA_HOMEPAGE.OpenLink(_oneCardItem, _cardOptions); // �������
		});
		if (_normalOpt.hoverTips != "") {
			cellObj.attr('title', _normalOpt.hoverTips); // ��ͣ��ʾ
			cellObj.tooltip({
				position: 'bottom'
			});
		}
		// ����Ӧ�߶�
		PHA_HOMEPAGE.ResizeCardHeight({
			cardId: _cardId,
			cellWidth: 0,
			cellHieght: 50 // css: div-file-row
		});
	},
	CardItem_ECharts: function (_oneCardItem, _cardOptions) {
		// card
		var _cardId = _cardOptions.hisuiOpt.id;
		var _queryParams = _cardOptions.queryParams;
		// card item
		var _normalOpt = _oneCardItem.normalOpt;
		var _renderToId = _normalOpt.itemRenderToId;
		var _text = _normalOpt.text != "" ? _normalOpt.text : _normalOpt.piciDesc;
		_normalOpt.text = _text;
		_queryParams.InputStr = _normalOpt.InputStr || "";
		// get postData
		var postData = $.extend({}, {
			ClassName: _normalOpt.ClassName,
			MethodName: _normalOpt.MethodName
		}, _queryParams);
		$.ajax({
			url: $URL,
			type: "get",
			data: postData,
			dataType: "json",
			success: function (retJosn, statusTxt, xhr) {
				var domObj = document.getElementById(_renderToId);
				var myChart = echarts.init(domObj);
				myChart.setOption(retJosn);
			},
			error: function (responseTxt, statusTxt, xhr) {
				console.log(responseTxt);
			}
		});
	},
	CardItem_DataGrid: function (_oneCardItem, _cardOptions) {
		// card
		var _cardId = _cardOptions.hisuiOpt.id;
		var _queryParams = _cardOptions.queryParams;
		// card item
		var _hisuiOpt = _oneCardItem.hisuiOpt;
		var _normalOpt = _oneCardItem.normalOpt;
		var _renderToId = _normalOpt.itemRenderToId;
		var _text = _normalOpt.text != "" ? _normalOpt.text : _normalOpt.piciDesc;
		_normalOpt.text = _text;
		_queryParams.InputStr = _normalOpt.InputStr || "";
		// get postData
		var postData = $.extend({}, {
			ClassName: _hisuiOpt.ClassName,
			QueryName: _hisuiOpt.QueryName,
			MethodName: _hisuiOpt.MethodName,
			totalFields: _hisuiOpt.totalFields || "",
			totalFooter: _hisuiOpt.totalFooter || ""
		}, _queryParams);
		// hisui-datagrid
		if (_normalOpt.piccCode == 'hisui-datagrid') {
			_hisuiOpt.url = $URL;
			_hisuiOpt.queryParams = postData;
			_hisuiOpt.toolbar = ""; // �������� todo...
			_hisuiOpt.gridSave = false;
			PHA.Grid(_renderToId, _hisuiOpt);
			if (this.isIECore()) {
				var $gParent = $('#' + _renderToId).parent().parent();
				$gParent.height($gParent.height() - 1);
			}
		}
	},
	// ��Ƭ��(�÷���ֻ��ҳ���ʼ����ʱ�����)
	CardItem_Forms: function (_formsOptions, _cardOptions) {
		var forms = _formsOptions.forms;
		var cardId = _formsOptions.cardId;
		var cardFormId = _formsOptions.cardFormId;
		var queryParams = _formsOptions.queryParams;
		for (var i = 0; i < forms.length; i++) {
			var oneFormOptions = forms[i];
			var oneFormHisuiOpt = oneFormOptions.hisuiOpt;
			var oneFormNormalOpt = oneFormOptions.normalOpt;
			queryParams[oneFormNormalOpt.piciCode] = oneFormHisuiOpt.value || "";
			//
			var oneFormHtmlStr = "";
			if (oneFormNormalOpt.piccCode == 'hisui-validatebox') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<label for='" + oneFormNormalOpt.piciCode + "' class='div-form-cellLabel'>" + oneFormNormalOpt.piciDesc + "</label>";
				oneFormHtmlStr += "<input id='" + oneFormNormalOpt.piciCode + "' data-pha=\"class:'hisui-validatebox',save:true,clear:true,query:true\" />";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				var $formObj = $('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode);
				$formObj.validatebox(oneFormHisuiOpt);
				var val = oneFormHisuiOpt.value || "";
				if (val != "") {
					$formObj.val(val);
				}
			} else if (oneFormNormalOpt.piccCode == 'hisui-datebox') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<label for='" + oneFormNormalOpt.piciCode + "' class='div-form-cellLabel'>" + oneFormNormalOpt.piciDesc + "</label>";
				oneFormHtmlStr += "<input id='" + oneFormNormalOpt.piciCode + "' data-pha=\"class:'hisui-datebox',save:true,clear:true,query:true\" />";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).datebox(oneFormHisuiOpt);
			} else if (oneFormNormalOpt.piccCode == 'hisui-timespinner') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<label for='" + oneFormNormalOpt.piciCode + "' class='div-form-cellLabel'>" + oneFormNormalOpt.piciDesc + "</label>";
				oneFormHtmlStr += "<input id='" + oneFormNormalOpt.piciCode + "' data-pha=\"class:'hisui-timespinner',save:true,clear:true,query:true\" />";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).timespinner(oneFormHisuiOpt);
			} else if (oneFormNormalOpt.piccCode == 'hisui-combobox') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<label for='" + oneFormNormalOpt.piciCode + "' class='div-form-cellLabel'>" + oneFormNormalOpt.piciDesc + "</label>";
				oneFormHtmlStr += "<input id='" + oneFormNormalOpt.piciCode + "' data-pha=\"class:'hisui-combobox',save:true,clear:true,query:true\" />";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				var thisComboURL = this.GetComboURL(oneFormHisuiOpt);
				if (thisComboURL != "") {
					oneFormHisuiOpt.url = thisComboURL;
					oneFormHisuiOpt.mode = 'remote';
					oneFormHisuiOpt.onBeforeLoad = function (param) {
						param.QText = param.q;
					}
				}
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).combobox(oneFormHisuiOpt);
			} else if (oneFormNormalOpt.piccCode == 'hisui-combogrid') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<label for='" + oneFormNormalOpt.piciCode + "' class='div-form-cellLabel'>" + oneFormNormalOpt.piciDesc + "</label>";
				oneFormHtmlStr += "<input id='" + oneFormNormalOpt.piciCode + "' data-pha-combogrid='true' data-pha=\"class:'hisui-combogrid',save:true,clear:true,query:true\" />";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				var thisComboURL = this.GetComboURL(oneFormHisuiOpt);
				if (thisComboURL != "") {
					oneFormHisuiOpt.url = thisComboURL;
					oneFormHisuiOpt.mode = 'remote';
					oneFormHisuiOpt.onBeforeLoad = function (param) {
						param.QText = param.q;
					}
				}
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).combogrid(oneFormHisuiOpt);
			} else if (oneFormNormalOpt.piccCode == 'hisui-radio') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				var _radioData = oneFormHisuiOpt.radioData;
				var _radioDataLen = _radioData.length;
				for (var j = 0; j < _radioDataLen; j++) {
					oneFormHtmlStr += "<input class='hisui-radio' type='radio' label='" + _radioData[j].Description + "' name='" + oneFormHisuiOpt.name + "' value='" + _radioData[j].RowId + "'>";
				}
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				$('#' + cardFormId + " [name='" + oneFormHisuiOpt.name + "']").radio(oneFormHisuiOpt);
				// Ĭ��ѡ��
				var val = oneFormHisuiOpt.value || "";
				if (val != "") {
					$('#' + cardFormId + " [name='" + oneFormHisuiOpt.name + "'][value='" + val + "']").radio('setValue', true);
				}
			} else if (oneFormNormalOpt.piccCode == 'hisui-checkbox') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<input id='" + oneFormNormalOpt.piciCode + "' class='hisui-checkbox' type='checkbox' data-pha=\"class:'hisui-checkbox',save:true,clear:true,query:true\" />";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).checkbox(oneFormHisuiOpt);
			} else if (oneFormNormalOpt.piccCode == 'hisui-keywords') {
				oneFormHtmlStr += "<div class='div-kw-cell'>";
				oneFormHtmlStr += "<div id='" + oneFormNormalOpt.piciCode + "' data-pha-keywords='true'></div>";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				// ˢ�¿�Ƭ�¼�
				oneFormHisuiOpt.onClick = function () {
					_cardOptions.isReload = true;
					PHA_HOMEPAGE.LoadCardContent(_cardOptions);
				}
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).keywords(oneFormHisuiOpt);
			} else if (oneFormNormalOpt.piccCode == 'hisui-linkbutton') {
				oneFormHtmlStr += "<div class='div-form-cell'>";
				oneFormHtmlStr += "<a id='" + oneFormNormalOpt.piciCode + "'>" + oneFormNormalOpt.piciDesc + "</a>";
				oneFormHtmlStr += "</div>";
				$('#' + cardFormId).append(oneFormHtmlStr);
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).linkbutton(oneFormHisuiOpt);
				// ˢ�¿�Ƭ�¼�
				$('#' + cardFormId + ' #' + oneFormNormalOpt.piciCode).on('click', function () {
					_cardOptions.isReload = true;
					PHA_HOMEPAGE.LoadCardContent(_cardOptions);
				});
			}
		}
	},
	GetComboURL: function (_options) {
		if (_options.MethodName && _options.ClassName != "" && _options.MethodName != "") {
			return "websys.Broker.cls?ClassName=" + _options.ClassName + "&MethodName=" + _options.MethodName;
		}
		if (_options.QueryName && _options.ClassName != "" && _options.QueryName != "") {
			return "websys.Broker.cls?ClassName=" + _options.ClassName + "&QueryName=" + _options.QueryName + "&ResultSetType=array";
		}
		return "";
	},
	GetFormDatta: function (cardId) {
		var myFormData = {};
		// ��ѡ��
		var formRadios = $("#" + cardId + " .hisui-radio");
		formRadios.each(function () {
			myFormData[this.name] = $("input[name='" + this.name + "']:checked").val() || "";
		});
		// �ؼ���
		var formKeywords = $("#" + cardId + " [data-pha-keywords]");
		formKeywords.each(function () {
			var kwStr = "";
			var kwArr = $("#" + this.id).keywords('getSelected');
			for (var i = 0; i < kwArr.length; i++) {
				if (kwStr == "") {
					kwStr = kwArr[i].id;
				} else {
					kwStr = kwStr + '^' + kwArr[i].id;
				}
			}
			myFormData[this.id] = kwStr;
		});
		// �������
		var formCombogrids = $("#" + cardId + " [data-pha-combogrid]");
		formCombogrids.each(function () {
			var valStr = ""
				var valArr = $("#" + this.id).combogrid('getValues') || [];
			for (var i = 0; i < valArr.length; i++) {
				if (valStr == "") {
					valStr = valArr[i];
				} else {
					valStr = valStr + "^" + valArr[i];
				}
			}
			myFormData[this.id] = valStr;
		});
		// ���ñ�
		var _formData = PHA.DomData('#' + cardId, {
			doType: 'save',
			retType: 'Json'
		});
		if (_formData.length == 0) {
			_formData[0] = {};
		}
		var retFormData = $.extend({}, _formData[0], myFormData);
		// ת��Boolean. for (var k in retFormJosn) {}
		return retFormData;
	},
	// ÿ����ϸ������ɺ����
	ResizeCardHeight: function (_options) {
		// ȡ��Ҫ�ı��С�Ŀ�Ƭ
		var cardId = _options.cardId;
		var resizeCardOpt = this.ResizeCards[cardId];
		if (!resizeCardOpt) {
			return;
		}
		var cellWidth = _options.cellWidth;
		var cellHieght = _options.cellHieght;
		// ��������
		var cardWidth = resizeCardOpt.width;
		var curCardNum = resizeCardOpt.curCardNum;
		var cols = cellWidth == 0 ? 1 : parseInt(cardWidth / cellWidth); // ��Ƭ���Էż���
		var rows = Math.ceil((curCardNum + 1) / cols); // ��Ƭ��Ҫ�ż���
		// ��Ҫ�ĸ߶�
		var needHeight = cellHieght * rows;
		if (needHeight > resizeCardOpt.curHeight) {
			var headerHeight = 34;
			$('#' + cardId).panel('resize', {
				height: needHeight + headerHeight + 1 + 10 // ���±߾඼Ϊ5
			});
			resizeCardOpt.curHeight = needHeight;
		}
		resizeCardOpt.curCardNum = curCardNum + 1;
	},
	// ���в���
	InitRCLayout: function (_cardOptions) {
		$('#' + _cardOptions.contentId).parent().addClass('content_noscroll'); // ������������
		var mCells = this.GetCells(_cardOptions);
		var mCellpadding = _cardOptions.normalOpt.splitType == 'S' ? 5 : 0;
		var mPadding = _cardOptions.normalOpt.splitType == 'S' ? '5px 5px 5px 5px' : '10px 10px 10px 10px';
		if (mCells.length == 0) {
			return false;
		}
		//
		var rateArr = (_cardOptions.normalOpt.rateStr || "").split(';');
		var widthRateStr = rateArr[0].split(':')[1];
		var widthRateArr = widthRateStr.split(',');
		//
		$('#' + _cardOptions.contentId).layoutgrid({
			layoutMode: 'table',
			layoutAlign: 'center',
			fit: true,
			colsWidth: widthRateArr,
			cellpadding: mCellpadding,
			padding: mPadding,
			forceLoad: true,
			showScroll: false,
			onScrollEnd: function () {},
			cells: mCells
		});
		return true;
	},
	// ���в���ʱ��ȡcell��Ϣ
	GetCells: function (_cardOptions) {
		var contentHeight = _cardOptions.contentHeight;
		var normalOpt = _cardOptions.normalOpt;
		var rateStr = normalOpt.rateStr || "";
		var splitType = normalOpt.splitType;
		if (rateStr == "") {
			alert("��Ƭ<" + normalOpt.picDesc + ">���в���δָ��<���б�����>");
			return [];
		}
		var rateArr = rateStr.split(';');
		var widthRateStr = rateArr[0].split(':')[1];
		var heightRateStr = rateArr[1].split(':')[1];
		if (widthRateStr == "" || heightRateStr == "") {
			alert("��Ƭ<" + normalOpt.picDesc + ">���в���<���б�����>���Ϸ�");
			return [];
		}
		var retCells = [];
		var widthRateArr = widthRateStr.split(',');
		var heightRateArr = heightRateStr.split(',');
		var hRows = heightRateArr.length;
		var wCols = widthRateArr.length;
		// ��ͬ�ķָʽ
		if (splitType == 'S') {
			// ʵ�߷ָ�
			var availHeight = contentHeight - 22 - ((hRows - 1) * 11);
			for (var hi = 0; hi < hRows; hi++) {
				var cellHeight = availHeight * heightRateArr[hi];
				for (var wj = 0; wj < wCols; wj++) {
					var cellInnerId = _cardOptions.contentId + '-' + hi + '-' + wj + '-' + 'inner';
					retCells.push({
						id: '', // Ĭ����: ���id + rowIndex + colIndex
						rowIndex: hi,
						colIndex: wj,
						height: cellHeight,
						class: 'panel_cell_border',
						animateSpeed: 300,
						content: "<div id='" + cellInnerId + "' style='height:" + (cellHeight - 2) + "px;width:100%'></div>",
						resizable: false
					});
				}
			}
		} else if (splitType == 'D') {
			// ���߷ָ�
			var tmpCssText = '';
			var availHeight = contentHeight - 20 - ((hRows - 1) * 1);
			for (var hi = 0; hi < hRows; hi++) {
				var cellHeight = availHeight * heightRateArr[hi];
				for (var wj = 0; wj < wCols; wj++) {
					var cellInnerId = _cardOptions.contentId + '-' + hi + '-' + wj + '-' + 'inner';
					// ���߱߿�(4�����)
					if (hi == hRows - 1 && wj == wCols - 1) {
						tmpCssText = '';
					} else if (hi == hRows - 1) {
						tmpCssText = 'border-right:1px dashed #CCCCCC;';
					} else if (wj == wCols - 1) {
						tmpCssText = 'border-bottom:1px dashed #CCCCCC';
					} else {
						tmpCssText = 'border-right:1px dashed #CCCCCC;border-bottom:1px dashed #CCCCCC';
					}
					// �߾�(9�����) - �е�Ӱ��Ч�ʰ�
					var unavailHeight = 5;
					var paddingStr = '';
					if (hi == 0 && wj == 0) {
						paddingStr = '0px 5px 5px 0px';
					} else if (hi == 0 && wj == wCols - 1) {
						paddingStr = '0px 0px 5px 5px';
					} else if (hi == hRows - 1 && wj == wCols - 1) {
						paddingStr = '5px 0px 0px 5px';
					} else if (hi == hRows - 1 && wj == 0) {
						paddingStr = '5px 5px 0px 0px';
					} else if (hi == 0) {
						paddingStr = '0px 5px 5px 5px';
					} else if (wj == 0) {
						unavailHeight = 10;
						paddingStr = '5px 5px 5px 0px';
					} else if (hi == hRows - 1) {
						paddingStr = '5px 5px 0px 5px';
					} else if (wj == wCols - 1) {
						unavailHeight = 10;
						paddingStr = '5px 0px 5px 5px';
					} else {
						unavailHeight = 10;
						paddingStr = '5px';
					}
					retCells.push({
						id: '', // Ĭ����: ���id + rowIndex + colIndex
						rowIndex: hi,
						colIndex: wj,
						height: cellHeight,
						cssText: tmpCssText,
						animateSpeed: 300,
						content: "<div style='padding:" + paddingStr + ";height:" + (cellHeight - unavailHeight) + "px;'><div id='" + cellInnerId + "' style='height:" + (cellHeight - unavailHeight) + "px;'></div></div>",
						resizable: false
					});
				}
			}
		} else {
			alert(normalOpt.picCode + ': δָ���ָʽ��');
			return [];
		}
		return retCells;
	},
	// ���沼��˳��
	SaveLayoutSort: function () {
		var pageCols = PHA_HOMEPAGE.LayoutOptions.pageCols;
		var cardSortNumArr = [];
		var curCardSortNum = 0;
		var curCardId = "";
		if (pageCols == 1) {
			var firstColPortal = $('#portal-layout').portal('getPanels', 0);
			for (var r = 0; r < firstColPortal.length; r++) {
				curCardId = firstColPortal[r][0].id;
				curCardSortNum = curCardSortNum + 1;
				cardSortNumArr.push({
					picCode: curCardId,
					picaCode: "sortNum",
					picoiVal: curCardSortNum
				});
				cardSortNumArr.push({
					picCode: curCardId,
					picaCode: "portalColIndex",
					picoiVal: 0
				});
			}
		} else {
			// ���
			var rowsArr = [];
			var colPortalArr = [];
			var cols = pageCols - 1;
			for (var i = 0; i < cols; i++) {
				var thisColPortal = $('#portal-layout').portal('getPanels', i);
				rowsArr.push(thisColPortal.length);
				colPortalArr.push(thisColPortal);
			}
			var maxRows = PHA_HOMEPAGE.maxNum(rowsArr);
			for (var r = 0; r < maxRows; r++) {
				for (var c = 0; c < cols; c++) {
					var thisColPortal = colPortalArr[c];
					if (thisColPortal.length > r) {
						curCardId = thisColPortal[r][0].id;
						curCardSortNum = curCardSortNum + 1;
						cardSortNumArr.push({
							picCode: curCardId,
							picaCode: "sortNum",
							picoiVal: curCardSortNum
						});
						cardSortNumArr.push({
							picCode: curCardId,
							picaCode: "portalColIndex",
							picoiVal: c
						});
					}
				}
			}
			// ���Ҳ��һ��
			var rightColPortal = $('#portal-layout').portal('getPanels', pageCols - 1);
			for (var r = 0; r < rightColPortal.length; r++) {
				curCardId = rightColPortal[r][0].id;
				curCardSortNum = curCardSortNum + 1;
				cardSortNumArr.push({
					picCode: curCardId,
					picaCode: "sortNum",
					picoiVal: curCardSortNum
				});
				cardSortNumArr.push({
					picCode: curCardId,
					picaCode: "portalColIndex",
					picoiVal: 'R'
				});
			}
		}
		// ����
		var jsonDataStr = JSON.stringify(cardSortNumArr);
		var authStr = PHA_HOMEPAGE.AuthStr;
		$.cm({
			ClassName: 'PHA.SYS.HomePage.Save',
			MethodName: 'SaveCardSort',
			authType: '', // ����ûʲô��,��ֱ̨����д��
			authStr: authStr,
			jsonDataStr: jsonDataStr,
			dataType: 'text'
		}, function (retText) {
			var retArr = retText.split('^');
			if (retArr[0] < 0) {
				$.messager.alert("��ʾ", "����ʧ��: " + retArr[1], "info");
				return;
			}
			PHA.Popover({
				msg: "����ɹ�!",
				type: "success",
				timeout: 1000
			});
		});
		this.ResizeScroll();
	},
	// �����ӵķ�ʽ
	OpenLink: function (_oneCardItem, _cardOptions) {
		var _cardItemNormalOpt = _oneCardItem.normalOpt;
		var _keyWord = _cardItemNormalOpt.piccCode;
		if (_keyWord.indexOf('todo') == 0 || _keyWord.indexOf('data') == 0 || _keyWord.indexOf('lnk') == 0) {
			if (_cardItemNormalOpt.linkType == 'H') {
				this.OpenLink_HISUI(_oneCardItem, _cardOptions);
			} else if (_cardItemNormalOpt.linkType == 'W') {
				this.OpenLink_Window(_oneCardItem, _cardOptions);
			} else if (_cardItemNormalOpt.linkType == 'T') {
				this.OpenLink_Tabs(_oneCardItem, _cardOptions);
			}
		} else if (_keyWord.indexOf('doc') == 0) {
			var fileName = _cardItemNormalOpt.piciDesc || "";
			var filePath = this.FilePath + fileName;
			var link = document.createElement('a');
			link.setAttribute("download", "");
			link.href = filePath;
			link.click();
			$(link).remove();
		} else {
			alert("δ�������ӷ�ʽ!");
		}
	},
	OpenLink_HISUI: function (_oneCardItem, _cardOptions) {
		var _cardItemNormalOpt = _oneCardItem.normalOpt;
		var _linkUrl = _cardItemNormalOpt.linkUrl || "";
		if (_linkUrl == "") {
			_linkUrl = this.CommonQueryPage + '?pageId=' + (_cardItemNormalOpt.linkPage || "");
		}
		_linkUrl += _linkUrl.indexOf('?') >= 0 ? '&' : '?';
		_linkUrl += this.GetLinkParams(_oneCardItem, _cardOptions);
		if ('undefined' !== typeof websys_getMWToken){
			_linkUrl += "&MWToken=" + websys_getMWToken();
		}
		var winId = "homepage_hisuiWinCom";
		var winContentId = "homepage_hisuiWinCom" + "_" + "content";
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: $(document.body).width() - 14,
			height: $(document.body).height() - 14,
			modal: true,
			title: _cardItemNormalOpt.text,
			iconCls: 'icon-search',
			content: "<iframe id='" + winContentId + "' src=''></iframe>",
			closable: true,
			onClose: function () {
				_cardOptions.isReload = true;
				PHA_HOMEPAGE.LoadCardContent(_cardOptions);
			}
		});
		$('#' + winContentId).width($('#' + winContentId).parent().width() - 5);
		$('#' + winContentId).height($('#' + winContentId).parent().height() - 8);
		$('#' + winContentId).attr('src', _linkUrl);
		$('#' + winId).dialog('setTitle', _cardItemNormalOpt.text);
		$('#' + winId).dialog('open');
	},
	OpenLink_Window: function (_oneCardItem, _cardOptions) {
		var _cardItemNormalOpt = _oneCardItem.normalOpt;
		var _linkUrl = _cardItemNormalOpt.linkUrl || "";
		if (_linkUrl == "") {
			_linkUrl = this.CommonQueryPage + '?pageId=' + (_cardItemNormalOpt.linkPage || "");
		}
		_linkUrl += _linkUrl.indexOf('?') >= 0 ? '&' : '?';
		_linkUrl += this.GetLinkParams(_oneCardItem, _cardOptions);
		if ('undefined' !== typeof websys_getMWToken){
			_linkUrl += "&MWToken=" + websys_getMWToken();
		}
		var winPadding = 10; // UIҪ�󵯴���������
		var w = screen.availWidth - 15 - (winPadding * 2);
		var h = screen.availHeight - 65 - (winPadding * 2);
		if (this.isIECore()) {
			var w = screen.availWidth - 28 - (winPadding * 2);
			var h = screen.availHeight - 52 - (winPadding * 2);
		}
		this.WindowsOpen = window.open(_linkUrl, _cardItemNormalOpt.text, 'height=' + h + ', width=' + w + ', top=' + winPadding + ', left=' + winPadding + ', toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
		// ������ҳ��ر��¼�
		var loop = setInterval(function () {
			if (PHA_HOMEPAGE.WindowsOpen.closed) {
				clearInterval(loop);
				_cardOptions.isReload = true;
				PHA_HOMEPAGE.LoadCardContent(_cardOptions);
			}
		}, 600);
	},
	OpenLink_Tabs: function (_oneCardItem, _cardOptions) {
		var _cardItemNormalOpt = _oneCardItem.normalOpt;
		var _linkUrl = _cardItemNormalOpt.linkUrl || "";
		if (_linkUrl == "") {
			_linkUrl = this.CommonQueryPage + '?pageId=' + (_cardItemNormalOpt.linkPage || "");
		}
		_linkUrl += _linkUrl.indexOf('?') >= 0 ? '&' : '?';
		_linkUrl += this.GetLinkParams(_oneCardItem, _cardOptions);
		if ('undefined' !== typeof websys_getMWToken){
			_linkUrl += "&MWToken=" + websys_getMWToken();
		}
		var urlObj = this.parseLinkUrl(_linkUrl);
		var _TMENU = urlObj.TMENU || ""; // ��Ƭά����ʱ���Զ���ȡ�������
		var _tabTitle = _cardItemNormalOpt.text;
		var _tabCode = _cardItemNormalOpt.piciCode;
		var _iframeID = "iframe" + "-" + _cardItemNormalOpt.piciCode;
		var includeInTabs = this.LayoutOptions.includeInTabs;
		if (includeInTabs == "Y") {
			if ($("#" + _iframeID).length > 0) {
				var tabIndex = $("#" + _iframeID).attr('tabIndex');
				$('#layout-container-tabs').tabs('select', parseInt(tabIndex));
				return;
			}
			// ����
			$('#layout-container-tabs').tabs('add', {
				title: _tabTitle,
				content: "<iframe id='" + _iframeID + "' src=''></iframe>",
				fit: true,
				selected: true,
				closable: true,
				onClose: function () {}
			});
			var tabWidth = $('#layout-container-tabs').width();
			var tabHeight = $('#layout-container-tabs').height();
			$("#" + _iframeID).width(tabWidth - 20);
			$("#" + _iframeID).height(tabHeight - 60);
			$("#" + _iframeID).attr('src', _linkUrl);
			var mTabs = $('#layout-container-tabs').tabs('tabs');
			$("#" + _iframeID).attr('tabIndex', mTabs.length - 1);
			// onClose����Ч,��дһ��
			$('#layout-container-tabs').children().eq(0).children().eq(2).find('.tabs-close').on('click', function () {
				setTimeout(function () {
					var mTabs = $('#layout-container-tabs').tabs('tabs');
					for (var i = 0; i < mTabs.length; i++) {
						var $oneTab = $(mTabs[i]);
						var $iframe = $oneTab.find('iframe[tabIndex]');
						if ($iframe.length == 0) {
							continue;
						}
						$iframe.attr('tabIndex', i);
					}
				}, 500);
			})
		} else {
			if (_TMENU == '') {
				alert('����: ' + _linkUrl + 'δ�Ҳ˵�!');
				return;
			}
			try {
				websys_createWindow("websys.csp?a=a&TMENU=" + _TMENU + "&TPAGID=", "TRAK_main", ",addTab=1,title=" + _tabTitle + ",closable=true,code=" + _tabTitle);
			} catch (e) {
				alert(
					"ʹ��Tabs��ʽ�򿪴������������÷�ʽ(HIS 8.4):\r\n" +
					"(1) �ڹ�������ά������,ά��pageAttr�е�includeInTabsΪY;\r\n" +
					"(2) ��ȫ������Ϊ�����ҳǩ��, ����Ҫ�Ҳ˵�");
			}
		}
	},
	GetLinkParams: function(_oneCardItem, _cardOptions){
		var InputStr = _oneCardItem.normalOpt.InputStr || '';
		var qParams = _cardOptions.queryParams;
		var ret = '';
		for (var qp in qParams) {
			var iParam = qParams[qp];
			if (qp == 'InputStr') {
				iParam = InputStr;
			}
			iParam = encodeURIComponent(iParam);
			ret += ret == '' ? qp + '=' + iParam : '&' + qp + '=' + iParam;
		}
		return ret;
	},
	// �򿪰�����Ϣ����
	OpenHelpWin: function (helpInfo) {
		var winId = "homepage_helpWin";
		var winContentId = "homepage_helpWin" + "_" + "content";
		if ($('#' + winId).length == 0) {
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog({
				width: 420,
				height: 300,
				modal: true,
				title: '����',
				iconCls: 'icon-help',
				content: "<div id='" + winContentId + "'style='margin:10px;'></div>",
				closable: true
			});
			$('#' + winContentId).width($('#' + winContentId).parent().width() - 20);
			$('#' + winContentId).height($('#' + winContentId).parent().height() - 20);
		}
		if (helpInfo.indexOf('.csp') > 0) {
			helpInfo += helpInfo.indexOf('?') >= 0 ? '' : '?';
			if ('undefined' !== typeof websys_getMWToken){
				helpInfo += "&MWToken=" + websys_getMWToken();
			}
			$.ajax({
				url: helpInfo,
				async: false,
				success: function (_htmlText) {
					$('#' + winContentId).html(_htmlText);
					$.parser.parse('#' + winContentId);
					$('#' + winId).dialog('open');
				}
			});
		} else {
			$('#' + winContentId).html(helpInfo);
			$('#' + winId).dialog('open');
		}
	},
	// ͼ���б���
	OpenIconWin: function (_options) {
		_options = _options || {};
		var selectedIcon = _options.selectedIcon || '';
		var winId = "homepage_iconWin";
		var winContentId = "homepage_iconWin" + "_" + "content";
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 600,
			height: parseInt($(document.body).height() * 0.85),
			modal: true,
			title: '����ͼ���б� - ˫������',
			iconCls: 'icon-w-img',
			content: "<iframe id='" + winContentId + "' src=''></iframe>",
			closable: true,
			onClose: function () {}
		});
		$('#' + winContentId).width($('#' + winContentId).parent().width() - 5);
		$('#' + winContentId).height($('#' + winContentId).parent().height() - 8);
		$('#' + winContentId).attr('src', 'pha.sys.v1.iconpreview.csp?selectedIcon=' +  selectedIcon);
		$('#' + winId).dialog('open');
	},
	CloseIconWin: function(){
		$('#homepage_iconWin').dialog('close');
	},
	parseLinkUrl: function (url) {
		var retUrlObj = {};
		var urlArr = url.split("?");
		var pageName = urlArr[0];
		var pageParamStr = urlArr[1];
		retUrlObj.pageName = pageName;
		if (urlArr.length == 1) {
			return retUrlObj;
		}
		var pageParamArr = pageParamStr.split('&');
		for (var i = 0; i < pageParamArr.length; i++) {
			var oneParamStr = pageParamArr[i];
			if (oneParamStr == '') {
				continue;
			}
			var oneParamArr = oneParamStr.split('=');
			var oneParamKey = oneParamArr[0];
			var oneParamVal = oneParamArr[1];
			if (oneParamKey == '' || oneParamVal == '') {
				continue;
			}
			retUrlObj[oneParamKey] = oneParamVal;
		}
		return retUrlObj;
	},
	/*
	 * @description: ��װ��ʼ�����ð�ť�ķ���
	 * @creator: 	 Huxt 2020-05-10
	 * @params:		 _options.right
	 * 				 _options.bottom
	 * 				 _options.menuRight
	 * 				 _options.menuBottom
	 * 				 _options.animateSpeed
	 * 				 _options.menuList
	 * @others:		 ��
	 */
	SetBtn: function (_options) {
		// Ĭ������
		var showMenuFlag = false;
		var _right = _options.right || 10;
		var _bottom = _options.bottom || 10;
		var _menuRight = _options.menuRight || 10;
		var _menuBottom = _options.menuBottom || 60;
		var _animateSpeed = _options.animateSpeed || 200;
		var _menuList = _options.menuList;
		// ������ð�ť
		var btnHtmlStr = "";
		btnHtmlStr += "<div id='settingBtn-position' style='position:absolute; right:" + _right + "px;bottom:" + _bottom + "px;'>";
		btnHtmlStr += "<img src='" + this.IconPath + "btn-setting" + ".png' id='settingBtn-icon' />";
		btnHtmlStr += "</div>";
		$(btnHtmlStr).appendTo('body');
		$("#settingBtn-icon").hover(function () {
			$("#settingBtn-icon").addClass('loaderCls');
		}, function () {
			$("#settingBtn-icon").removeClass('loaderCls');
			if (showMenuFlag == true) {
				//hideMenu();
			}
		});
		// ���ð�ť����¼�
		$("#settingBtn-icon").on('click', function () {
			if (showMenuFlag == false) {
				var menuListHtmlStr = "";
				menuListHtmlStr += "<div id='settingMenu-list' class='menu-shadow setting-menu" + (PHA_COM.IsLiteCss ? "-lite" : "") + "' style='position:absolute; right:" + _menuRight + "px; bottom:" + _menuBottom + "px; opacity:0;'>";
				for (var i = 0; i < _menuList.length; i++) {
					var _oneMenu = _menuList[i];
					menuListHtmlStr += "<div id='" + _oneMenu.id + "' class='setting-btn" + (PHA_COM.IsLiteCss ? "-lite" : "") + "'>" + _oneMenu.text + "</div>";
				}
				menuListHtmlStr += "</div>";
				$('body').append(menuListHtmlStr);
				// ���¼�
				for (var i = 0; i < _menuList.length; i++) {
					var _oneMenu = _menuList[i];
					$('#' + _oneMenu.id).on('click', function () {
						_options.onClickMenu && _options.onClickMenu({
							id: this.id,
							text: this.innerText
						});
						hideMenu();
					})
				}
				showMenu();
			} else {
				hideMenu();
			}
		});
		// ��ʾ����
		function showMenu() {
			$("#settingMenu-list").animate({
				right: _menuRight,
				bottom: _menuBottom,
				opacity: 1
			}, _animateSpeed);
			showMenuFlag = true;
		}
		// ���ط���
		function hideMenu() {
			$("#settingMenu-list").animate({
				right: _right,
				bottom: _bottom,
				opacity: 0
			}, _animateSpeed, function () {
				$('#settingMenu-list').remove();
			});
			showMenuFlag = false;
		}
	},
	/*
	 * @description: ҳ�����ð�ť��ʼ�� (��2��)
	 * @creator:     Huxt 2020-05-11
	 * @params:      _options
	 * @others:      pha/sys/v1/homepage.js
	 */
	InitSetBtn: function () {
		var _right = this.LayoutOptions.niceScroll == 'Y' ? 10 : 28;
		var _bottom = 6;
		var _menuBottom = 60;
		if (this.LayoutOptions.includeInTabs == 'Y') {
			_right = _right + 11;
			_bottom = _bottom + 11;
			_menuBottom = _menuBottom + 11;
		}
		var menuList = [{
				id: 'menu-pageSet',
				text: $g('ҳ������')
			}, {
				id: 'menu-cardSet',
				text: $g('��Ƭ����')
			}
		];
		if (typeof HomePage_globalConfig == 'object' && HomePage_globalConfig.SwitchLoc == 'Y') {
			menuList.push({
				id: 'menu-switchLoc',
				text: $g('�л�����')
			});
		}
		PHA_HOMEPAGE.SetBtn({
			right: _right,
			bottom: _bottom,
			menuRight: _right,
			menuBottom: _menuBottom,
			animateSpeed: 200, // ����ʱ��
			menuList: menuList,
			onClickMenu: function (menu) {
				if (menu.id == 'menu-pageSet') {
					PHA_HOMEPAGE.PageSet(menu);
				}
				if (menu.id == 'menu-cardSet') {
					PHA_HOMEPAGE.CardSet(menu);
				}
				if (menu.id == 'menu-switchLoc') {
					PHA_HOMEPAGE.SwitchLoc(menu);
				}
			}
		});
	},
	/*
	 * ҳ�����õ���
	 */
	PageSet: function (menu) {
		var winId = "homepage_page_set";
		var winContentId = "homepage_page_set" + "_" + "content";
		if ($('#' + winId).length == 0) {
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog({
				width: 650,
				height: 260,
				modal: true,
				title: 'ҳ������',
				iconCls: 'icon-w-setting',
				content: "<div id='" + winContentId + "' style='margin:10px;border-bottom:1px solid #d1d6da'></div><div style='margin:15px 10px 20px 10px;height:25px;'><center>" + PHA_SYS_SET.Com.GetTypeHtml('page_set_save_type') + "</center></div>",
				closable: true,
				buttons: [{
						text: $g('����'),
						handler: function () {
							PHA_HOMEPAGE.SavePageSet();
						}
					}, {
						text: $g('�ر�'),
						handler: function () {
							$('#' + winId).dialog('close');
						}
					}
				]
			});
			$('#' + winContentId).width($('#' + winContentId).parent().width() - 20);
			$('#' + winContentId).height($('#' + winContentId).parent().height() - 65);
		}
		// ��ʼ����
		var effectiveWidth = this.LayoutOptions.effectiveWidth; // 100%, �˲���ͣ�� 2021-02-19
		effectiveWidth = this.toFloat(effectiveWidth);
		var colWidthRateList = this.LayoutOptions.colWidthRateList; // '0,0.7,0.3,0'
		var colWidthRateArr = colWidthRateList.split(',');
		var niceScroll = this.LayoutOptions.niceScroll; // 'Y'
		var pageMaxCols = this.PageMaxCols;
		var colLeftWidthRate = colWidthRateArr[0];
		var colRightWidthRate = colWidthRateArr[colWidthRateArr.length - 1];
		// �Ƿ�ʹ������������
		var contentHtml = "";
		var isNiceScroll = niceScroll == 'Y' ? 'true' : 'false';
		// ����
		contentHtml += "<div style='margin:10px;'><input id='page_niceScroll' class='hisui-checkbox' data-options='checked:" + isNiceScroll + "' type='checkbox' label='����������' /> </div>";
		contentHtml += "<div style='margin:10px;'>";
		for (var i = 0; i < pageMaxCols; i++) {
			var chkFlag = "false";
			if (i == colWidthRateArr.length - 3) {
				chkFlag = "true";
			}
			var paddingLeft = i == 0 ? 0 : 20;
			contentHtml += "<div class='pha-col' style='padding-left: " + paddingLeft + "px;'>";
			contentHtml += "<input class='hisui-radio' type='radio' label='" + (i + 1) + "��' name='pageSetting-cols' value='" + (i + 1) + "' data-options=\"checked:" + chkFlag + ",required:true,requiredSel:true\" />";
			contentHtml += "</div>";
		}
		contentHtml += "</div>";
		// �п�ȱ���
		contentHtml += "<div id='page_colWidthRateList' style='height:26px;margin:10px 10px 10px 12px;'></div>";
		// ��ӵ�Window
		$('#' + winContentId).children().remove();
		$('#' + winContentId).html(contentHtml);
		$.parser.parse('#' + winContentId);
		// ��ѡ���
		$("[name='pageSetting-cols']").radio({
			onChecked: function (e, value) {
				var items = [];
				items.push({
					text: '�հ���',
					rate: colLeftWidthRate,
					color: '#d1d6da'
				});
				var cols = parseInt($(e.target).attr("value"));
				var rate = 1 / cols;
				for (var i = 0; i < cols; i++) {
					items.push({
						text: '��' + (i + 1) + '��',
						rate: parseFloat((1 - colLeftWidthRate - colRightWidthRate) * rate).toFixed(4),
						color: PHA_HOMEPAGE.colorArr[i]
					});
				}
				items.push({
					text: '�հ���',
					rate: colRightWidthRate,
					color: '#d1d6da'
				});

				PHA_HOMEPAGE.myScaleBar('page_colWidthRateList', {
					height: 25,
					width: 600,
					items: items
				});
			}
		});
		// ��ʼ��һ��������
		var items = [];
		for (var i = 0; i < colWidthRateArr.length; i++) {
			var iText = '��' + i + '��';
			var iRate = parseFloat(colWidthRateArr[i]).toFixed(4);
			var iColor = PHA_HOMEPAGE.colorArr[i];
			if (i == 0 || i == colWidthRateArr.length - 1) {
				iText = "�հ���";
				iColor = "#d1d6da"
			}
			items.push({
				text: iText,
				rate: iRate,
				color: iColor
			});
		}
		PHA_HOMEPAGE.myScaleBar('page_colWidthRateList', {
			height: 25,
			width: 600,
			items: items
		});
		
		// ��ʾ�������� (�û�/��ȫ��/����/ͨ��)
		$.cm({
			ClassName: 'PHA.SYS.HomePage.Query',
			MethodName: 'GetPageSaveType',
			authStr: this.AuthStr,
			dataType: 'text'
		}, function (retText) {
			PHA_SYS_SET.Com.SetSaveType(retText, 'page_set_save_type');
		});
		// �򿪴���
		$('#' + winId).dialog('open');
		$('#' + winId).find('.dialog-button').css('padding-top', '0px');
		$('#' + winContentId).parent().css('overflow', 'hidden');
	},
	SavePageSet: function () {
		var authType = PHA_SYS_SET.Com.GetSaveType('page_set_save_type');
		if (authType == "") {
			PHA.Popover({
				msg: "��ѡ�񱣴����ͣ�",
				type: "alert"
			});
			return;
		}
		var effectiveWidth = 1; // ͣ��
		var colWidthRateListArr = this.myScaleBar('page_colWidthRateList', 'getValue');
		var colWidthRateList = colWidthRateListArr.join(','); // ����: 0,0,7,0,3,0
		var niceScroll = $('#page_niceScroll').checkbox('getValue');
		var saveJson = {
			effectiveWidth: effectiveWidth,
			colWidthRateList: colWidthRateList,
			niceScroll: niceScroll
		}
		var jsonDataStr = JSON.stringify(saveJson);
		var authStr = this.AuthStr;
		$.cm({
			ClassName: 'PHA.SYS.HomePage.Save',
			MethodName: 'SavePageConfig',
			authType: authType,
			authStr: authStr,
			jsonDataStr: jsonDataStr,
			dataType: 'text'
		}, function (retText) {
			var retArr = retText.split('^');
			if (retArr[0] < 0) {
				$.messager.alert("��ʾ", "����ʧ��: " + retArr[1], "info");
				return;
			}
			location.reload();
		});
	},
	/*
	 * ��Ƭ���õ���
	 */
	CardSet: function (menu) {
		var winId = "homepage_card_set";
		var winContentId = "homepage_card_set" + "_" + "content";
		if ($('#' + winId).length == 0) {
			// �����ʼ��
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog({
				width: 420,
				height: parseInt($(window).height() * 0.94),
				modal: true,
				title: '��Ƭ����',
				iconCls: 'icon-w-setting',
				content: "<div id='" + winContentId + "' style='margin:0px;'></div><div style='margin:15px 10px 20px 10px;height:25px;'><center>" + PHA_SYS_SET.Com.GetTypeHtml('card_set_save_type') + "</center></div>",
				closable: true,
				buttons: [{
						text: '����',
						handler: function () {
							PHA_HOMEPAGE.SaveCardSet(winContentId);
						}
					}, {
						text: '�ر�',
						handler: function () {
							$('#' + winId).dialog('close');
						}
					}
				]
			});
			// ���������� (���Կ��Թ���)
			// $('#' + winContentId).parent().niceScroll({cursorwidth: '4px',});
			var dialogBody = $('#' + winId).dialog('body').children().eq(0).children().eq(0).children().eq(0);
			dialogBody.parent().addClass('pha-scrollbar-hidden');
			dialogBody.addClass('pha-body');
			dialogBody.addClass('pha-scrollbar-hidden-chl');
			// ��������������
			// $('#' + winContentId).width($('#' + winContentId).parent().width() - 20);
			$('#' + winContentId).height($('#' + winContentId).parent().height() - 75);
			$('#' + winContentId).css('border-bottom', '1px dashed #d1d6da');
			$('#' + winContentId).css('overflow-x', 'hidden');
			$('#' + winContentId).parent().css('overflow', 'hidden');
			
			// �������ṹ
			this.InitCardSetTree(winContentId);
		}
		$('#' + winId).dialog('open');
		$('#' + winId).find('.dialog-button').css('padding-top', '0px');
		if (typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite') {
			$('#' + winId).find('.dialog-button').children().eq(0).addClass('green');
		}
		// ��ʾ�������� (�û�/��ȫ��/����/ͨ��)
		$.cm({
			ClassName: 'PHA.SYS.HomePage.Query',
			MethodName: 'GetCardSaveType',
			authStr: this.AuthStr,
			dataType: 'text'
		}, function (retText) {
			PHA_SYS_SET.Com.SetSaveType(retText, 'card_set_save_type');
		});
		// ˢ����
		this.QueryCardSetTree(winContentId);
	},
	SaveCardSet: function (winContentId) {
		var authType = PHA_SYS_SET.Com.GetSaveType('card_set_save_type');
		if (authType == "") {
			PHA.Popover({
				msg: "��ѡ�񱣴����ͣ�",
				type: "alert"
			});
			return;
		}
		var saveJson = [];
		var treeRoots = $('#' + winContentId).tree('getRoots');
		for (var i = 0; i < treeRoots.length; i++) {
			var rootData = $('#' + winContentId).tree('getData', treeRoots[i].target);
			var rootDataChl = rootData.children;
			for (var j = 0; j < rootDataChl.length; j++) {
				saveJson.push({
					pici: rootDataChl[j].id,
					picasVal: rootDataChl[j].checked == true ? 'N' : 'Y' // ��ѡ�˵�,��Ҫ��ʾ,hidden���Դ�N
				});
			}
		}
		var jsonDataStr = JSON.stringify(saveJson);
		var authStr = this.AuthStr;
		$.cm({
			ClassName: 'PHA.SYS.HomePage.Save',
			MethodName: 'SaveCardConfig',
			authType: authType,
			authStr: authStr,
			jsonDataStr: jsonDataStr,
			dataType: 'text'
		}, function (retText) {
			var retArr = retText.split('^');
			if (retArr[0] < 0) {
				$.messager.alert("��ʾ", "����ʧ��: " + retArr[1], "info");
				return;
			}
			location.reload();
		});
	},
	InitCardSetTree: function (_treeId) {
		PHA.Tree(_treeId, {
			mode: 'remote',
			fit: true,
			checkbox: true,
			lines: true,
			autoNodeHeight: false,
			url: '',
			onCheck: function (node, checked) {
				// ��������Ȩ�Ĳ���
				if (node.cardAuthType != "Card") {
					return;
				}
				// ����Ƭ��Ȩ��ȫѡ
				var parent = $(this).tree('getParent', node.target);
				if (checked) {
					if (!node.children) {
						$(this).tree('check', parent.target);
						var allCheckedNodes = $(this).tree('getChecked');
						for (var i = 0; i < allCheckedNodes.length; i++) {
							var tempNode = allCheckedNodes[i];
							if (tempNode.children) {
								if (tempNode.id != parent.id) {
									// $(this).tree('uncheck', tempNode.target);
								}
							}
						}
					} else {
						var allCheckedNodes = $(this).tree('getChecked');
						for (var i = 0; i < allCheckedNodes.length; i++) {
							var tempNode = allCheckedNodes[i];
							if (tempNode.children) {
								if (tempNode.id != node.id) {
									// $(this).tree('uncheck', tempNode.target);
								}
							}
						}
					}
				} else {
					if (!node.children) {
						$(this).tree('uncheck', parent.target);
					}
				}
			},
			onClick: function (node) {
				if (node.checked) {
					$('#' + _treeId).tree('uncheck', node.target);
				} else {
					$('#' + _treeId).tree('check', node.target);
				}
			},
			onLoadSuccess: function () {
				var fitWidth = $('#' + _treeId).parent().width();
				$('#' + "homepage_card_set" + "_" + "content").children('li').width(fitWidth - 22); // Huxt 2021-04-29
			}
		});
		if (this.isLiteCss()) {
			$('#' + "homepage_card_set" + "_" + "content").css('background', '#ffffff');
		}
	},
	QueryCardSetTree: function (_treeId) {
		var authStr = this.AuthStr;
		$("#" + _treeId).tree("options").url = PHA.GetUrl({
			ClassName: 'PHA.SYS.HomePage.Query',
			MethodName: 'GetCardConfig',
			authStr: authStr
		});
		$("#" + _treeId).tree("reload");
	},
	/*
	 * �л����ҵ���
	 * Huxt 2022-09-16
	 */
	SwitchLoc: function(menu){
		var winId = "homepage_switch_loc";
		var winTblId = "homepage_switch_loc" + "_" + "tbl";
		if ($('#' + winId).length == 0) {
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog({
				width: 650,
				height: 500,
				modal: true,
				title: '�л����� - ˫������',
				iconCls: 'icon-w-setting',
				content: '' +
					'<div class="hisui-layout" fit="true" border="false">' +
					'	<div data-options="region:\'center\',border:false" class="pha-body" style="background:#ffffff;">' +
					'		<div class="hisui-panel" title="" data-options="iconCls:\'icon-house\',headerCls:\'panel-header-gray\',fit:true">' +
					'			<table id="' + winTblId + '"></table>' +
					'		</div>' +
					'	</div>' +
					'</div>'
			});
			var columns = [[{
					title: "ID",
					field: "RowId",
					width: 50
				}, {
					title: "��������",
					field: "Description",
					width: 100
				}
			]];
			var dataGridOption = {
				url: PHA_STORE.CTLoc().url + '&TypeStr=D&UserId=' + session["LOGON.USERID"],
				singleSelect: true,
				pagination: true,
				columns: columns,
				gridSave: true,
				toolbar: '',
				fitColumns: true,
				gridSave: false,
				onDblClickRow: function(rowIndex, rowData) {
					PHA_HOMEPAGE.DoSwitchLoc(rowData);
				}
			};
			PHA.Grid(winTblId, dataGridOption);
		} else {
			$('#' + winTblId).datagrid('reload');
		}
		$('#' + winId).dialog('open');
	},
	DoSwitchLoc: function(selectedLocData) {
		var locId = selectedLocData.RowId;
		tkMakeServerCall('PHA.SYS.HomePage.Save', 'SetSelectedLoc', session['LOGON.USERID'], locId);
		location.reload();
	},
	// ====================================================
	// ���ù����� (ÿ�μ����µ�����֮����Ҫ����һ��)
	ResizeScroll: function () {
		if (this.LayoutOptions.niceScroll == 'Y') {
			$('#portal-layout').getNiceScroll().resize();
			/*
			$('#portal-layout').mCustomScrollbar({
	        	theme: 'inset-2-dark',
	        	scrollInertia: 100
	    	});
	    	*/
		}
	},
	// ��ȡ�����ַ���
	GetLayoutHtml: function () {
		var includeInTabs = this.LayoutOptions.includeInTabs;
		var colWidthRateList = this.LayoutOptions.colWidthRateList;
		var colWidthRateArr = colWidthRateList.split(',');
		var pageCols = colWidthRateArr.length;
		this.LayoutOptions.colWidthRateArr = colWidthRateArr; // remenber it
		this.LayoutOptions.pageCols = pageCols - 2; // ��ȥ���пհ�
		if (pageCols < 3) {
			alert("��������С��3�У�");
			return "";
		}

		var layoutHtmlStr = "";
		if (includeInTabs == "Y" || includeInTabs == "1" || includeInTabs == 1) {
			layoutHtmlStr += "<div id='layout-container-tabs' class='hisui-tabs tabs-gray' fit='true'>";
			layoutHtmlStr += "	<div title='����̨'>";
			layoutHtmlStr += "		<div id='portal-layout' style='position:relative;'>";
			for (var i = 1; i < pageCols - 1; i++) {
				layoutHtmlStr += "			<div style='width:" + this.toPercentage(colWidthRateArr[i]) + ";'></div>";
			}
			layoutHtmlStr += "		</div>";
			layoutHtmlStr += "	</div>";
			layoutHtmlStr += "</div>";
		} else {
			layoutHtmlStr += "<div id='portal-layout' style='position:relative'>";
			for (var i = 1; i < pageCols - 1; i++) {
				layoutHtmlStr += "			<div style='width:" + this.toPercentage(colWidthRateArr[i]) + ";'></div>";
			}
			layoutHtmlStr += "</div>";
		}
		return layoutHtmlStr;
	},
	// ת�ɰٷֱȵ���ʽ
	toPercentage: function (num) {
		if (num == '') {
			return '0%';
		}
		if (num.toString().indexOf('%') > 0) {
			return num;
		}
		return (num * 100) + '%';
	},
	// ת��С������ʽ
	toFloat: function (num) {
		if (num == '') {
			return 0;
		}
		if (num.toString().indexOf('%') > 0) {
			var num = num.toString().replace('%', '');
			return parseFloat(num / 100);
		}
		var num = parseFloat(num)
			if (num > 1) {
				return num / 100;
			}
			return num;
	},
	isIECore: function () {
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			return true;
		} else {
			return false;
		}
	},
	maxNum: function (_numArr) {
		var _max = _numArr[0];
		for (var i = 1; i < _numArr.length; i++) {
			var _cur = _numArr[i];
			_cur > _max ? _max = _cur : null;
		}
		return _max;
	},
	hasProperty: function(obj){
		if (!obj) {
			return false;
		}
		for (var pr in obj) {
			return true;
		}
		return false;
	},
	/*
	 * @description: �Զ���ٷֱȱ����϶���,����̫�پͲ�д�����,ֱ��д������
	 * @creator:     Huxt 2020-05-20
	 * @params:      _id - html dom id
	 *               _options - �������
	 * @others:      ��
	 */
	myScaleBar: function (_id, _options) {
		// ȡֵ
		if (_options === 'getValue') {
			var retArr = [];
			var mBars = $('#' + _id).find('.pha-scalebar-rate');
			for (var i = 0; i < mBars.length; i++) {
				var iRate = $(mBars[i]).attr('rate');
				iRate = parseFloat(iRate);
				retArr.push(iRate);
			}
			return retArr;
		}
		// =============================
		// ��ʼ��
		var items = _options.items;
		var tWidth = _options.width - ((items.length - 1) * 10);
		var htmlStr = "";
		for (var i = 0; i < items.length; i++) {
			var oneWidthData = items[i];
			var text = oneWidthData.text;
			var rate = oneWidthData.rate;
			var color = oneWidthData.color;
			var rateInt = (parseFloat(rate) * 100).toFixed(2);
			htmlStr += "<div class='pha-scalebar-rate' style='";
			htmlStr += "width:" + (tWidth * rate) + "px;";
			htmlStr += "background-color:" + color + ";";
			htmlStr += "color:" + (oneWidthData.textColor || 'white') + ";";
			htmlStr += "' ";
			htmlStr += "index='" + i + "' ";
			htmlStr += "text='" + text + "' ";
			htmlStr += "rate='" + rate + "' ";
			htmlStr += "rateInt='" + rateInt + "' ";
			htmlStr += ">";
			htmlStr += text + ":" + rateInt;
			htmlStr += "</div>";
			if (i != items.length - 1) {
				htmlStr += "<img class='pha-scalebar-drag' src='../scripts/pha/sys/v1/icons/btn-scale-drag.png' draggable='false'></img>";
			}
		}
		$('#' + _id).children().remove();
		$('#' + _id).append(htmlStr);
		var startX = 0; 		// �϶���ʼXֵ
		var totalWidth = 0; 	// ����������ܿ��
		var $curDrag = null; 	// ���������һ���ƶ���
		var handle = false; 	// �Ƿ���
		$(".pha-scalebar-drag").mousedown(function (e) {
			e.stopPropagation();
			startX = e.pageX;
			handle = true;
			$curDrag = $(this);
		});
		$(document).mousemove(function (e) {
			e.stopPropagation();
			// �Ƿ�������
			if (handle) {
				var moveWidth = e.pageX - startX;
				var $LeftRate = $curDrag.prev();
				var $RightRate = $curDrag.next();
				var leftWidth = $LeftRate.width();
				var rightWidth = $RightRate.width();
				if (totalWidth == 0) {
					totalWidth = leftWidth + rightWidth;
				}
				var newLeftWidth = leftWidth + moveWidth;
				var newRightWidth = totalWidth - newLeftWidth; // rightWidth - moveWidth;
				if ($LeftRate.length > 0) {
					newLeftWidth = newLeftWidth <= 0 ? 0 : newLeftWidth;
					if (newLeftWidth >= 0 && newLeftWidth <= totalWidth) {
						$LeftRate.width(newLeftWidth);
						// ��ʾ����
						var newRate = (newLeftWidth / tWidth).toFixed(2);
						var newRateInt = parseInt(parseFloat(newRate) * 100);
						var newHtml = $LeftRate.attr('text') + ":" + newRateInt.toFixed(2);
						$LeftRate.attr('rate', newRate);
						$LeftRate.attr('rateInt', newRateInt);
						$LeftRate.html(newHtml);
					}
				}
				if ($RightRate.length > 0) {
					newRightWidth = newRightWidth <= 0 ? 0 : newRightWidth;
					if (newRightWidth >= 0 && newRightWidth <= totalWidth) {
						$RightRate.width(newRightWidth);
						// ��ʾ����
						var newRate = (newRightWidth / tWidth).toFixed(2);
						var newRateInt = parseInt(parseFloat(newRate) * 100);
						var newHtml = $RightRate.attr('text') + ":" + newRateInt.toFixed(2);
						$RightRate.attr('rate', newRate);
						$RightRate.attr('rateInt', newRateInt);
						$RightRate.html(newHtml);
					}
				}
				startX = e.pageX;
				_options.onDrag && _options.onDrag($('#' + _id), $curDrag);
			}
		});
		$(document).mouseup(function () {
			startX = 0;
			totalWidth = 0;
			$curDrag = null;
			handle = false;
		});
	},
	isLiteCss: function(){
		if (typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite') {
			return true;
		}
		return false;
	},
	// ��ʼ��MAC��ַ, ��Щ
	InitMac: function(){
		if (typeof PHA_LOG === 'object') {
			try {
				var $parentDoc = $(window.parent.document);
				if ($parentDoc.find('#pha_mac').length == 0) {
					var pha_mac = PHA_LOG._getMAC();
					$parentDoc.find('body').append('<input id="pha_mac" type="hidden" value="' + pha_mac + '"/>');
					tkMakeServerCall('PHA.SYS.HomePage.Save', 'SetClientMAC', pha_mac);
				}
			} catch(e){}
		}
	}
}
