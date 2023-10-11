/**
 * ����:   		�Թ���PHA_COM������չһЩ�·��� (����ҩѧ��ҳ����չ)
 * ��д��:  	Huxiaotian
 * ��д����: 	2020-04-20
 * js:			pha/sys/v1/extend.com.js
 */
 
if("undefined" == typeof PHA_COM) {
	PHA_COM = {};
}
(function(PHA_COM){
	/*
	* �������Դ���
	*/
	PHA_COM.ComAttr = {
		Win: function(_options) {
			var _winOptions = _options.winOptions;
			var _cards = _options.cards || [];
			var _winId = _winOptions.id || "";
			if (_winId == "") {
				alert("winOptionsδָ��id����")
				return;
			}
			delete _winOptions.id;
			if (!_winOptions.buttons) {
				_winOptions.buttons = [{
					text: '����',
					handler: function(){
						if (_winOptions.onClickSave) {
							var _formData = PHA.DomData('#' + _winId, {
								doType: 'save',
								retType: 'Json'
							});
							_winOptions.onClickSave(_formData);
						}
					}
				}, {
					text: '�ر�',
					handler: function(){
						$('#' + _winId).dialog('close');
					}
				}]
			}
			
			if($("#" + _winId).length == 0 || _options.forceReload == true){
				if ($("#" + _winId).length == 0) {
					$('<div id="' + _winId + '"><div>').appendTo('body');
				}
				$('#' + _winId).dialog(_winOptions);
				// ��ʽ�޸�
				// $('#' + _winId).children().eq(1).css('border-top', '1px solid #d1d6da'); // UI����Ҫ������ôд
				// $('#' + _winId).children().eq(0).children().eq(0).addClass('layoutgrid_noscroll');
				// $('#' + _winId).children().eq(0).children().eq(0).niceScroll({cursoropacitymax: 1, cursorwidth: '4px'});
				var dialogBody = $('#' + _winId).dialog('body').children().eq(0).children().eq(0).children().eq(0);
				dialogBody.addClass('pha-body');
				// �������
				dialogBody.html('');
				for (var i = 0; i < _cards.length; i++) {
					this._AddCard(dialogBody, _cards[i]);
				}
			}
			
			// �򿪴���
			$("#" + _winId).dialog('open');
			// ���ر�����
			if (_options.data) {
				if (Object.prototype.toString.call(_options.data) == '[object Object]'){
					PHA.SetVals([_options.data], _winId);
				} else {
					PHA.SetVals(_options.data, _winId);
				}
			} else {
				PHA_COM.RunServer(
					_options.dataOptions,
					function(jsonData){
						if (jsonData.success == 0) {
							PHA.Alert("��ʾ", jsonData.msg, -1);
							$("#" + _winId).dialog('close');
							return;
						}
						PHA.SetVals(jsonData, _winId);
					},
					function(XMLHR){
						var resText = XMLHR.responseText; // ���ط�json
						var resArr = resText.split('^');
						PHA.Alert("��ʾ", resArr[1], resArr[0]);
						$("#" + _winId).dialog('close');
					}
				);
			}
		},
		_AddCard: function(dialogBody, _cardOptions) {
			// ��Ƭ��ʼ��
			var _cardId = _cardOptions.id || "";
			if (_cardId == "") {
				alert("cardδָ��id����")
				return;
			}
			var _containerId = _cardId + "-" + "container";
			var _title = _cardOptions.title || ("��Ƭ" + _cardId);
			
			dialogBody.append("<div id='" + _cardId + "'><div class='hisui-panel' title='" + _title + "' data-options=\"height:50,headerCls:'panel-header-card-gray'\"" + "></div></div>");
			$.parser.parse('#' + _cardId);
			var cardBody = $('#' + _cardId).children().eq(0).children().eq(1)
			var cardBodyWidth = cardBody.css('width');
			cardBody.css('width', parseInt(cardBodyWidth) - 38); // û�й�������ʱ�� +18px TODO...
			cardBody.addClass('pha-body');
			cardBody.css('border-radius', 4);
			cardBody.css('margin-bottom', 10);
			
			// ��ӿ�Ƭ����
			if (_cardOptions.html) {
				cardBody.append(_cardOptions.html);
				$.parser.parse('#' + _containerId); //todo...
				if ($('#' + _containerId).length > 0) {
					var ch = $('#' + _containerId)[0].clientHeight;
					cardBody.css('height', ch + 28);
				}
				return;
			}
			var htmlStr = "";
			$.ajax({
				url: "websys.Broker.cls",
				type: "post",
				async: false,
				dataType: "html",
				data: _cardOptions,
				success: function(htmlStr) {
					cardBody.append(htmlStr);
					$.parser.parse('#' + _containerId);
					if ($('#' + _containerId).length > 0) {
						var ch = $('#' + _containerId)[0].clientHeight;
						cardBody.css('height', ch + 28);
					}
				},
				error: function(XMLHR) {
					console.log(XMLHR);
					alert('����console����̨�鿴������Ϣ');
				}
		    });
		}
	}
	
	PHA_COM.RunServer = function(_data, successFn, errorFn){
		$.ajax({
			url: "websys.Broker.cls",
			type: "post",
			async: false,
			dataType: "json",
			data: _data,
			success: function(jsonData) {
				successFn && successFn(jsonData);
			},
			error: function(XMLHR) {
				errorFn && errorFn(XMLHR);
			}
	    });
	}
})(PHA_COM)