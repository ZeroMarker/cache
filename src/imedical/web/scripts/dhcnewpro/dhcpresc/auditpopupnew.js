(function($) {
	/**
	 * 构造函数
	 */
	$.fn.qmes = function(options, param) {
		
		if(this[0] !== this[0].window){  //非window对象
			return;
		}
		
		if (typeof options == 'string') { //如果是字符串，调用函数
			return $.fn.qmes.methods[options](this, param);
		}
		options = options || {};

		var state = $.data(this, 'qmes');
		
		if (state) {
			//$.extend({}, state.options, options);
		} else {
			state = $.data(this, 'qmes', {
				options: $.extend({}, $.fn.qmes.defaults, options)
			});
			
			var r = init(this); ///初始化弹窗以及开启websocket
		}
		initMes(this);
	};
	
	
	/**
	 * 对外接口
	 */
	$.fn.qmes.methods = {
		getText: function(jq) {
			return getText(jq[0]);
		}
	};
	
	/**
	 * 获取Text
	 */
	function getText(target) {
		return 'text';
	};
	
	/**
	 * 默认值
	 */
	$.fn.qmes.defaults = $.extend({}, {
		userType:'',
		callBak:function(serverRetData){
			
		}
	});
	
	
	function initMes(target) {
		var _dc = $.data(target, 'qmes').options;
		var canvas = $(target).find('#appPanel')[0];
		
	}
	
	/**
	 * 初始化函数，生成整个combo组件的DOM结构 
	 */
	function init(target){
		if ($(target).length) {
			if (target[0].$('body').find('#appPanel').length) return;
			target[0].$('body').append(popHtml(target));
			//openWebsocket(target);
			openPolling(target);
		}
	}
	
	/**
	 * 弹窗html
	 */
	function popHtml(target){
		var _dc = $.data(target, 'qmes').options;
		var userType = _dc.userType
		var url = 'dhcpresc.newscontact.csp?userType='+userType;
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken();
		}
		var retHtml=
			'<script type="text/javascript">'+
				'function appContact(){'+
					'$("#newsContact").attr("src","'+url+'");'+
					'if($("#newsWin").hasClass("panel-body")){'+
						'$("#newsWin").window("open");'+
					'}else{'+
						'$("#newsWin").window({'+
							'width:800,'+
							'height:700,'+
							'iconCls:"icon-w-save",'+
							'resizable:false,'+
							'collapsible:false,'+
							'minimizable:false,'+
							'maximizable:false,'+
							'closable:false,'+
							'modal:false,'+
							'isTopZindex:true'+
						'});'+
					'}'+
				'}'+
			'</script>'+
			'<div id="appPanel" style="position:absolute;right:20px;bottom:15px;width:185px;height:75px;cursor:pointer;" onclick="appContact()">'+
				'<img style="position: absolute;" src="../scripts/dhcnewpro/dhcpresc/images/bz4.png"/>'+
				'<div>'+
					'<span style="color: #4da2f1;font-weight: 600;font-size: 15px;position: absolute;left: 80px;top:16px;">待处理</span>'+
					'<span id="auditNum" style="font-size: 16px;color: #0068c6;font-weight: 700;position: absolute;left: 140px;top:16px;"></span>'+
				'</div>'+
				'<div>'+
					'<span style="color: #b3b3b3;position: absolute;top: 43px;left: 80px;font-weight: 500;">聊天消息</span>'+
					'<span id="allMsgNum" style="background: #ff5219;color: #fff;position: absolute;top: 43px;left: 144px;border-radius: 10px;font-size: 10px;width: 15px;line-height: 15px;text-align: center;"></span>'+
				'</div>'+
			'</div>'+
			'<div style="position: absolute;right: 29px;bottom: 7px;width: 175px;height: 175px;cursor: pointer;display:none;" onclick="_appDao.appContact()">'+
				'<img style="position: absolute;width: 175px;z-index:-1;" src="../scripts/dhcnewpro/dhcpresc/images/jxfk.png"/>'+
				'<div style="margin-top: 20px;margin-left: 20px;line-height: 25px;">'+
					'<span style="width: 4px;height: 10px;display: inline-block;"></span>'+
					'<span style="margin-left: 10px;">处理状态</span>'+
				'</div>'+
				'<div style="margin-left: 20px;line-height: 25px;">'+
					'<span style="color:#bababa;font-size: 12px;font-weight: 500;">姓名</span>'+
					'<span style="color:#757575;font-size: 12px;font-weight: 600;margin-left: 10px;">张三</span>'+
				'</div>'+
				'<div style="margin-left: 20px;line-height: 25px;">'+
					'<span style="color:#bababa;font-size: 12px;font-weight: 500;">处方号</span>'+
					'<span style="color:#757575;font-size: 12px;font-weight: 600;margin-left: 10px;">989789798</span>'+
				'</div>'+
				'<div style="margin-left: 20px;margin-right: 15px;color: #757575;height: 60px;font-size: 12px;overflow: hidden;text-overflow: ellipsis;">'+
					'处方书写不合理处方书写不合理处方书写不合理处方书写不合理处方书写不合理'+
				'</div>'+
			'</div>'+
			'<div id="newsWin" class="hisui-window" title="消息沟通" style="overflow: hidden;">'+
				'<iframe id="newsContact" name="newsContact" src="" style="width:100%;height:100%"></iframe>'+
			'</div>'
		return retHtml;
	}
	
	function openPolling(target){
		var _dc = $.data(target, 'qmes').options;
		var userType = _dc.userType
		setInterval(function(){
			var lgUser = session['LOGON.USERID'];
			var params=userType+"^"+lgUser;
			$cm({
				ClassName:"web.DHCPRESCAuditPopup",
				MethodName:"MainUnReadTextNew",
				Params:params,
				"dataType":"text"
			},function(data){
				var $target = target[0].$('body').find('#appPanel');
				var retArr=data.split('^');
				var auditNum=retArr[0];
				var allMsgNum=retArr[1];
				$target.find('#auditNum').html(auditNum);
				$target.find('#allMsgNum').html(allMsgNum);
				if(parseInt(auditNum)||parseInt(allMsgNum)){
					$target.show();
					return;
				}else{
					$target.hide();	
				}
			});
				
		},1000*10);
	}
	
	function openWebsocket(target){
		
		return; ///cache的ws封装非常垃圾，改为轮询
		var _dc = $.data(target, 'qmes').options;
		var userType = _dc.userType
		
		//使用websoket通讯
		var wsUrl = ((window.location.protocol == 'https:')?'wss:':'ws:')+'//'+window.location.host+
						'/imedical/web/web.DHCPRESCWebSocketServer.cls?userType='+userType+'&conType=UnRead'; //UnRead是标识未读数字的ws
		var ws = new WebSocket(wsUrl);
		
		ws.onopen  = function(event) {
			console.log('连接成功建立!', event);
		};
		
		ws.onmessage = function(event) {
			console.log('WebSocket message received:', event);
			var data=event.data;
			var $target = target[0].$('body').find('#appPanel');
			var retArr=data.split('^');
			var auditNum=retArr[0];
			var allMsgNum=retArr[1];
			$target.find('#auditNum').html(auditNum);
			$target.find('#allMsgNum').html(allMsgNum);
			if(parseInt(auditNum)||parseInt(allMsgNum)){
				$target.show();
				return;
			}else{
				$target.hide();	
			}
		};
		
		ws.onerror = function(event) {
			console.log('WebSocket error received:', event);
		};
		
		ws.onclose = function(event) {
			console.log('连接已经关闭!', event);
			$.messager.confirm("警告", "连接已断开！是否重新连接?", function (r) {
				if (r) {
					openWebsocket(target);
				} 
			});
		};
	}
})(jQuery)