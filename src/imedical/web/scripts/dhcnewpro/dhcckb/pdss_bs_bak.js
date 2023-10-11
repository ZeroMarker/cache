//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-05-09
// 描述:	   安全用药智能决策系统(PDSS,Physic Decision Safety Support System)
//===========================================================================================

var CKBClientIp = "";
(function(window){
	
	GetClientIp();	// 获取客户端ip
	function encodeHTML( html ) {
		var map = {
			'&' : '&amp;',
			'<' : '&lt;',
			'>' : '&gt;',
			'"' : '&quot;',
			'\'' : '&#39;'
		};

		return String( html ).replace( /[&<>'']/g, function( m ) {
			return map[ m ];
		} );
	}
	
	function template( text, data ) { // eslint-disable-line no-unused-vars

		var delimiters = [ '<%', '%>' ];

		var settings = {
			evaluate : new RegExp( delimiters[ 0 ] + '([\\s\\S]+?)' + delimiters[ 1 ], 'g' ),
			interpolate : new RegExp( delimiters[ 0 ] + '=([\\s\\S]+?)' + delimiters[ 1 ], 'g' ),
			escape : new RegExp( delimiters[ 0 ] + '-([\\s\\S]+?)' + delimiters[ 1 ], 'g' )
		};

		// When customizing `templateSettings`, if you don't want to define an
		// interpolation, evaluation or escaping regex, we need one that is
		// guaranteed not to match.
		var noMatch = /(.)^/;

		// Certain characters need to be escaped so that they can be put into a
		// string literal.

		var escapes = {
			'\'' : '\'',
			'\\' : '\\',
			'\r' : 'r',
			'\n' : 'n',
			'\t' : 't',
			'\u2028' : 'u2028',
			'\u2029' : 'u2029'
		};

		var escaper = /\\|'|\r|\n|\u2028|\u2029/g;

		var escapeChar = function( match ) {
			return '\\' + escapes[ match ];
		};

		// Combine delimiters into one regular expression via alternation.
		var matcher = RegExp( [
			( settings.escape || noMatch ).source,
			( settings.interpolate || noMatch ).source,
			( settings.evaluate || noMatch ).source,
			( settings.css || noMatch ).source
		].join( '|' ) + '|$', 'g' );

		// Compile the template source, escaping string literals appropriately.
		var index = 0;
		var source = '__p+=\'';
		text.replace( matcher, function( match, escape, interpolate, evaluate, css, offset ) {
			source += text.slice( index, offset ).replace( escaper, escapeChar );
			index = offset + match.length;

			if( escape ) {
				source += '\'+\n((__t=(' + escape + '))==null?\'\':encodeHTML(__t))+\n\'';
			} else if( interpolate ) {
				source += '\'+\n((__t=(' + interpolate + '))==null?\'\':__t)+\n\'';
			} else if( evaluate ) {
				source += '\';\n' + evaluate + '\n__p+=\'';
			}

			// Adobe VMs need the match returned to produce the correct offest.
			return match;
		});
		source += '\';\n';

		// If a variable is not specified, place data values in local scope.
		if (!settings.variable) source = 'with(obj||{}){\n' + source + '}\n';

		source = 'var __t,__p=\'\',__j=Array.prototype.join,' +
		'print=function(){__p+=__j.call(arguments,\'\');};\n' +
		source + 'return __p;\n';

		var render;

		try {
			render = new Function( settings.variable || 'obj', 'encodeHTML', source);
		} catch( e ) {
			e.source = source;
			throw e;
		}

		if( data ) {
			return render( data, encodeHTML );
		}

		var template = function(data) {
			return render.call( this, data, encodeHTML );
		};

		// Provide the compiled source as a convenience for precompilation.
		var argument = settings.variable || 'obj';
		template.source = 'function(' + argument + '){\n' + source + '}';

		return template;
	}
	
	function getFormatHtml(tempHtml, area) {
		
		var htmlstr = "";
		var rows = $(tempHtml).find('.area[data-area="'+ area +'"] .row');
		for(var m=0; m<rows.length; m++){
			
			htmlstr = htmlstr +'<div class="row">';
			/// 默认添加项目序号及目录样式标识
			if (m == 0){
				var monHeadHtml = ""; var monBodyHtml = ""; 
				if (1){
					 monHeadHtml = '<span class="labelcheck"><input type="checkbox" class="label-check-input" value="<%-item.manLevel%>"></input></span>';
					 monBodyHtml = '<span class="labelcheck"></span>';
				}
				if (area == "monHead") htmlstr = htmlstr + monHeadHtml +'<span class="itemlabel-xh <%-item.manLevel%>-bg"><label data-id=""><%-(i+1)%></label></span>';
				if (area == "monBody") htmlstr = htmlstr + monBodyHtml +'<span class="itemlabel-yy <%-rule.manLevel%>-bg"><label data-id=""></label></span>';
			}
			var els = $(rows[m]).find('label');
			for(var n=0; n<els.length; n++){
				
				if ($(els[n]).attr("data-id") != ""){
					$(els[n]).text("<%-" + $(els[n]).attr("data-id") + "%>").parent();
				}
				htmlstr = htmlstr + $(els[n]).parent().prop("outerHTML").replace("ruleColorCss","<%-" + "ruleColorCss" + "%>");
			}
			htmlstr = htmlstr +'</div>';
		}
		
		return escape2Html(htmlstr);
	}
	
	function  escape2Html(str) {
	    var  arrEntities={ 'lt' : '<' , 'gt' : '>' , 'nbsp' : ' ' , 'amp' : '&' , 'quot' : '"' };
	    return  str.replace(/&(lt|gt|nbsp|amp|quot);/ig, function (all,t){ return  arrEntities[t];});
	}
	var PDSS = function(options){
		
		if( !options ) options = {};
		for( var attr in options ) {
			if( options.hasOwnProperty( attr ) ) {
				this[ attr ] = options[ attr ];
			}
		}
		this.status = {
            activeTab : 'tips'
        };
        this.nav_ind = 0; // 标识当前显示的菜单项
        this.gotTips = 0; // 标识已经生成了智能审查dom
        this.gotEdus = 0; // 标识已经生成了用药教育dom
        
		if( !this.container ) this.container = document.body;
		this.container = $( this.container );
		this.EffFlag = 1 ;    /// 展示效果
		this.checkFn = null ; /// 回调函数
		this.passFlag = 1 ;   /// 审查结果通过状态
		this.manLevel = "提示" ;   /// 审核结果警示级别
		this.controlFlag = "N"	/// 强制审核标志(默认为N)
		this.MsgID = "";						/// 消息标记id
		this.Msg = "";							 /// 消息json
		this.init( options );
	};
	
	PDSS.prototype = {
		constructor : PDSS,
		templates : {
			//main  : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>安全用药智能决策系统</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-body-lists"></div></div></div>',
			//main : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>安全用药智能决策系统</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-nav"><span class="ckb-view-nav-item ckb-view-nav-active" data-name="tips">智能审查</span><span class="ckb-view-nav-item" data-name="edus">用药教育</span></div><div class="ckb-view-main" id="ckbid-main1" style="overflow: auto;"></div><div class="ckb-view-main" id="ckbid-main2" style="display: none"></div></div>',
			//       '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>安全用药智能决策系统</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-nav"><span class="ckb-view-nav-item ckb-view-nav-active" data-name="tips">智能审查</span><span class="ckb-view-nav-item" data-name="edus">用药教育</span></div><div class="ckb-view-main" id="ckbid-main1"></div><div id ="control" class="ckb-view-control"><label>强制审核：</label><label><input class="ckb-view-control-checkbox" type="checkbox" id="reviewWarnY" name="reviewWarn" value="Y">是</label></td><td><label><input class="ckb-view-control-checkbox" type="checkbox" id="reviewWarnN" name="reviewWarn" value="N" >否</label></div><div class="ckb-view-main" id="ckbid-main2" style="display: none"></div></div>',
		 main : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>安全用药智能决策系统</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-main" id="ckbid-main1"></div><div id ="control" class="ckb-view-control"><span id="bt_return" class="btn-style btn-return">返回修改</span><span href="#" id="bt_audit" class="btn-style btn-audit">强制审核</span></div><div class="ckb-view-main" id="ckbid-main2" style="display: none"></div></div>',
			view  : {
				item:'<% for( var i = 0; i < items.length; i ++ ) { %> <% var item = items[ i ]; %>'+
					 '<div class="ckb-view-body-item" data-id="WL<%-item.unique %>">'+
						 '<div class="ckb-view-item-head">'+
							  '<div class="ckb-view-item-warn-light">'+
								  '<img src="../scripts/dhcnewpro/dhcckb/images/<%-item.manLevel%>-16.png" border=0/>'+
							  '</div>'+
							  '<div class="ckb-view-item-xh"><label><%-(i+1)%></label></div>'+
							  '<div class="ckb-view-item-tip"><label><%-item.item%></label></div>'+
						 	  '<div class="ckb-view-item-foot">'+
								  '<label class="ckb-view-item-more" data-id="WL<%-item.unique %>">详细信息[+]</label>'+
							  '</div>'+
							  '<div class="ckb-view-item-bottom-line"></div>'+
						  '</div>'+	// head 结束
						  '<div class="ckb-view-item-body">'+	// warns是目录级别
						 	'<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ]; var itemCss = j==item.warns.length-1?"":"ckb-view-item-bottom-line";%>'+
							 	 //'<% var itmColorCss = "warn-color-normal"; if( warn.manLevel == "remind") itmColorCss = "remind-color";if( warn.manLevel == "forbid") itmColorCss = "forbid-color"; if( warn.manLevel == "warn") itmColorCss = "warn-color"; if( warn.manLevel == "tips") itmColorCss = "tips-color"; if( warn.manLevel == "normal") itmColorCss = "normal-color";%>'+
								'<% for (var k = 0; k < warn.itms.length; k++) { %> <% var rule =warn.itms[k]; var ruleCss = k==warn.itms.length-1?"":"ckb-view-item-bottom-line"; %>'+	// 规则
									'<div class="ckb-view-item">'+
								 		'<div class="ckb-view-item-icon">'+
									 		'<img src="../scripts/dhcnewpro/dhcckb/images/<%-rule.manLevel%>-10.png" border=0/>'+	
								 		'</div>'+
								  		'<% var ruleColorCss = "warn-cololr-normal"; if (rule.manLevel == "remind") ruleColorCss = "remind-color";if(rule.manLevel == "forbid") ruleColorCss = "forbid-color"; if(rule.manLevel == "warn") ruleColorCss = "warn-color"; if( rule.manLevel == "tips") ruleColorCss = "tips-color"; if( rule.manLevel == "normal") ruleColorCss = "normal-color"; %>'+	
								  		'<div class="ckb-view-item-warn <%-ruleColorCss%>"><label><%-rule.manLev%></label></div>'+	// 规则级别
								 		'<div class="ckb-view-item-tips <%-ruleColorCss%>"><label><%-warn.keyname%></label></div>'+	// 目录描述
											'<% for (var m = 0; m<rule.itms.length; m++){ %>'+	// 提醒内容
												'<div class="ckb-view-item-rest"><label><%-rule.itms[m].val%></label></div>'+													
											'<% } %>'+												
											'<% var ruleSource = ""; if ( rule.source != "")  ruleSource="【参考依据】:"+rule.source; %>'+
											'<div class="ckb-view-item-rest"><label><%-ruleSource%></label></div>'+	// 提示依据											
									 	'<div class="ckb-view-item-top-line"></div>'+
									 	'<div class="<%-ruleCss%>"></div>'+
									 '</div>'+
								'<% } %>'+
						   '<% } %>'+
						 '</div>'+	// body 结束
					  '</div>'+		// itm结束
					  '<div class="ckb-view-detail" data-id="WL<%-item.unique %>">'+	
					  		'<div class="ckb-view-detail-patbase">'+
					   	    	 '<div class="ckb-view-detail-title">'+
					   	   			 '<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		 	 '<label>基本信息</label>'+
					   	     	 '</div>'+
					   	     	 '<div class="ckb-view-detail-info">'+
					   	   	   	 	 '<table border="1" cellspacing="0" cellpadding="1" class="ckb-view-item-table">'+
					   	   	   	  	  '<tr style="height:30px;"><td class="key-label"><label>年龄：</label></td><td><label class="val-label"><%-item.tips[0].AgeProp %></label></td><td class="key-label"><label>身高：</label></td><td><label class="val-label"><%-item.tips[0].Height %></label></td><td class="key-label"><label>体重：</label></td><td><label class="val-label"><%-item.tips[0].Weight %></label></td></tr>'+
					   	   	   	 	  '<tr style="height:30px;"><td class="key-label"><label>单次剂量：</label></td><td><label class="val-label"><%-item.tips[0].OnceDose %></label></td><td class="key-label"><label>每日用量：</label></td><td><label class="val-label"><%-item.tips[0].DayDose %></label></td><td class="key-label"><label>给药频率：</label></td><td><label class="val-label"><%-item.tips[0].DrugFreq %></label></td></tr>'+
					   	   	   	  	  '<tr style="height:30px;"><td class="key-label"><label>给药方式：</label></td><td><label class="val-label"><%-item.tips[0].DrugPreMet %></label></td><td class="key-label"><label>持续时间：</label></td><td colspan=3><label class="val-label"><%-item.tips[0].Treatment %></label></td></tr>'+
					   	   	   	  	'</table>'+
					   	    	 '</div>'+
					   	     	 '<div class="ckb-view-detail-line"></div>'+
					   	     	 '<div class="ckb-view-item-bottom-line"></div>'+
					     	'</div>'+
					  		'<div class="ckb-view-detail-res">'+
					   	   	  	'<div class="ckb-view-detail-title">'+
					   	   			 '<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		 	 '<label>审查结果</label>'+
					   	     	'</div>'+
					   	      	'<div class="ckb-view-detail-resinfo">'+
					   	   			 '<label>超出说明书限定</label>'+
					   	     	'</div>'+
					   	     	'<div class="ckb-view-detail-line"></div>'+
					   	      	'<div class="ckb-view-item-top-line"></div>'+
					   	      	'<div class="ckb-view-item-bottom-line"></div>'+
					    	'</div>'+
					  		'<div class="ckb-view-detail-res">'+
					   	      	'<div class="ckb-view-detail-title">'+
					   	   			'<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		  	'<label>参考用法用量</label>'+
					   	      	'</div>'+
					   	      	'<div class="ckb-view-detail-info">'+
					   	   	   			'<table border="1" cellspacing="0" cellpadding="1" class="ckb-view-item-table">'+
					   	   	   	  			'<tr style="height:30px;"><td colspan=2 class="key-label" style="width:115px"><label>详情参考说明书</label></td><td class="key-label"><a href="javascript:void(0)" onclick=\"window.open(\'dhcckb.wiki.csp?IncId=<%-item.itmID %>\')\">详情</a></td><td colspan=2><label class="val-label"></label></td></tr>'+					   	   	   	 	  
					   	   	   	  	  		//'<tr style="height:30px;"><td class="key-label"><label>年龄阶段：</label></td><td colspan=2><label class="val-label"></label></td><td class="key-label"><label>体重范围：</label></td><td colspan=2><label class="val-label"></label></td></tr>'+
					   	   	   	 	  		//'<tr style="height:30px;"><td class="key-label"><label>常规用量：</label></td><td colspan=2><label class="val-label"></label></td><td class="key-label"><label>常规频率：</label></td><td colspan=2><label class="val-label"></label></td></tr>'+
					   	   	   	  	 		 //'<tr style="height:30px;"><td class="key-label"><label>常规疗程：</label></td><td colspan=2><label class="val-label"></label></td><td class="key-label"><label></label></td><td colspan=2><label class="val-label"></label></td></tr>'+
					   	   	   	 		'</table>'+
					   	      	'</div>'+
					   	      	'<div class="ckb-view-item-top-line"></div>'+
					     	'</div>'+
					  '</div>'+	// detail结束
				      '<% } %>',
				refres:'',
				eduItem:'<% for( var m = 0; m < items.length; m ++ ) { %> '+
						'<% var item = items[ m ]; %>'+
							'<div class="ckb-view-body-item" data-id="WL<%-item.unique %>">'+
								'<div class="ckb-view-item-head">'+
//									'<div class="ckb-view-item-warn-light">'+
//								  		'<img src="../scripts/dhcnewpro/dhcckb/images/forbid-16.png" border=0/>'+
//							  		'</div>'+
//									'<div class="ckb-view-item-xh"><label><%-(i+1)%></label></div>'+
									'<div class="ckb-view-item-education"><label>用药教育</label></div>'+
//									'<div class="ckb-view-item-foot" style="display:none">'+
//										'<label class="ckb-view-item-more" data-id="WL<%-item.unique %>">详细信息[+]</label>'+
//									'</div>'+				
								'</div>'+	// head 结束
								'<div class="ckb-view-item-body">'+	
									'<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ];%>'+
										'<% for (var k = 0; k < warn.itms.length; k++) { %> <% var rule =warn.itms[k]; %>'+	// 规则
											'<% if (rule.val != "") {%>'+
												'<div class="ckb-view-item">'+
													//'<div class="ckb-view-item-tips"><label><%-warn.keyname%></label></div>'+	// 目录描述														
													'<div class="ckb-view-item-edu"><label><%-rule.val%></label></div>'+	 // 提醒内容
												 '</div>'+
											'<% } %>'+
										'<% } %>'+
								   '<% } %>'+
								 '</div>'+	// body 结束
							'</div>'+		// itm结束
						'<% } %>',
				monTemp:''
			},
			warnWin : '<div class="ckb_warn_win">'+
							 '<ul class="warn_ul">'+
							 	'<li class="warn_li"><div id="warn" class="icon-warn-default icon-warn-red"></div></li>'+
							 	'<li class="warn_li"><div id="forbid" class="icon-warn-default icon-warn-black"></div></li>'+
							 	//'<li class="warn_li"><div id="normal" class="icon-warn-default icon-warn-green"></div></li>'+
							 	'<li class="warn_li"><div id="tips" class="icon-warn-default icon-warn-yellow"></div></li>'+
							 	'<li class="warn_li"><div id="info" class="warn-log warn-info">日志</div></li>'+
							 '</ul>'+
							 '<div class="ckb-warn-icon"><a class="ckb-warn-close" href="javascript:void(0)"></a></div>'+
						  '</div>',
			reasonWin : '<div id="view-reason" class="view-reason">'+
						'	<div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>双签复核</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div>'+
						'   <div class="view-reason-body">'+
						'		<p style="margin-top:10px;"><label style="font-weight:bold;">请填写用药理由：</label></p>'+
						'		<div class="realist" style="height:140px;padding:6px;"><p><input type="checkbox" name="reagrp" value="患者情况特殊，需要超剂量" /><label>患者情况特殊，需要超剂量</label></p><p><input type="checkbox" name="reagrp" value="需重复给药或加大剂量" /><label>需重复给药或加大剂量</label></p><p><input type="checkbox" name="reagrp" value="病人强烈要求" /><label>病人强烈要求</label></p><p><input type="checkbox" name="reagrp" value="病人病情需要" /><label>病人病情需要</label></p><p><input type="checkbox" name="reagrp" value="其他" /><label>其他</label></p></div>'+
						'		<div style="height:100px;padding:6px;"><textarea id="reason" style="width:260px;height:100px;resize:none;" required></textarea></div>'+
						'	</div>'+
						'   <div class="view-reason-foot"><span id="bt_doublesign" class="btn-style btn-sign">双签复核</span></div>'+
						'</div>'
		} ,
		bin_event : function() {
			
			 var o;   //捕获到的事件
			 var X;   //box水平宽度
			 var Y;   //box垂直高度
			 function getObject(obj,e){    //获取捕获到的对象
				o = obj;
				document.all?o.setCapture() : window.captureEvents(Event.MOUSEMOVE);  
				X = e.clientX - parseInt(o.offsetLeft);   //获取宽度，
				Y = e.clientY - parseInt(o.offsetTop);   //获取高度，
			}
			document.getElementById("ckb_view_bar").onmousedown = function(e){ 
				getObject(document.getElementById("ckb_view_win"),e||event);       //box捕获事件并处理  e-->FF  window.event-->IE
			};
			document.onmousemove = function(dis){    //鼠标移动事件处理
				if(!o){    //如果未获取到相应对象则返回
					return;
				}
				if(!dis){  //事件
					dis = event ;
				}
				o.style.left = dis.clientX - X +"px";     //设定box样式随鼠标移动而改变
				o.style.top = dis.clientY - Y + "px";
				
				me.re_vreason(); // 双签弹出 位置
			};
			document.onmouseup = function(){    //鼠标松开事件处理
				if(!o){   //如果未获取到相应对象则返回
					return;
				}
				// document.all（IE）使用releaseCapture解除绑定；其余比如FF使用window对象针对事件的捕捉
				document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP);
				o = '';   //还空对象
			};
			
			var me = this;
			/// 关闭事件
			$(".ckb-view-container .ckb-view-tool-close").bind('click',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
				$(".ckb_warn_win").remove();
				$(".view-reason").remove();   /// 删除双签复核弹窗
			});
			
			/// 详情
			$("#ckb_view_win").on('click','.ckb-view-item-more',function(){
				var _vid = $(this).closest(".ckb-view-body-item").attr("data-id");
				if ($(".ckb-view-detail[data-id='"+ _vid +"']").is(':hidden')){
					$(".ckb-view-detail[data-id='"+ _vid +"']").show();
					//$(this).text("详细信息[-]");
				}else{
					$(".ckb-view-detail[data-id='"+ _vid +"']").hide();
					//$(this).text("详细信息[+]");
				}
			});
			
			/// 推荐用药
			$("#ckb_view_win").on('click','.item-recmedical',function(){
				// 此处后期删除，不作为系统部分
				var recmedical = $(this).closest(".ckb-view-body-item").attr("data-recmedical");
				if (recmedical == "") return;
				var recmedicalArr = recmedical.split(",");
				var htmlstr = "";
				for(var m=0; m<recmedicalArr.length; m++){
					htmlstr = htmlstr + "<p>"+ recmedicalArr[m] +"</p>";
				}
				$("#win .recmedical").html(htmlstr);
				
				$('#win').window({
					title:'推荐用药',
					iconCls:'icon-w-paper',
				    width:600,
				    height:300,
				    modal:true,
				    collapsible : false,
					minimizable : false,
					maximizable : false
				});
				
			});
			
			/// 用药教育
			$("#ckb_view_win").on('click','.item-edu',function(){
				var _vid = $(this).closest(".ckb-view-body-item").attr("data-id");
				if ($(".ckb-view-education[data-id='"+ _vid +"']").is(':hidden')){
					$(".ckb-view-education[data-id='"+ _vid +"']").show();
					//$(this).text("详细信息[-]");
					me.updateEdus();
				}else{
					$(".ckb-view-education[data-id='"+ _vid +"']").hide();
					//$(this).text("详细信息[+]");
				}
			});
			
			/// 说明书
			$("#ckb_view_win").on('click','.item-link-intoducation',function(){
				var _vid = $(this).closest(".ckb-view-detail").attr("data-itmid");
				window.open('dhcckb.wiki.csp?IncId='+ _vid);
			});
			
						
			/// 参考文献
			$("#ckb_view_win").on('click','.item-link-literature',function(){
				var _vid = $(this).closest(".ckb-view-detail").attr("data-itmid");
				window.open('dhcckb.reference.csp?IncId='+ _vid);
			});
			
			/// 控制灯事件
			$(".warn-light").on('click','img',function(){
				$(".ckb-view-body-item[data-id='"+ this.id +"']").show().siblings().hide(); /// 项目隐藏
				me.showPanel();
			})
			
			/// 勾选框事件
			$('input[name="reviewWarn"]').bind("click",function(){
				if($(this).prop('checked')){
					if (this.id == "reviewWarnY"){
						$("#reviewWarnN").attr("checked",false);
					}
					if (this.id == "reviewWarnN"){
						$("#reviewWarnY").attr("checked",false);
					}
					me.controlFlag = this.value;
				};	

				typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// 回调函数
			});
			
			/// 控制灯事件 2020-09-30 bianshuai
			$(".warn-info").bind('click',function(){
				//alert("警示灯点击事件，您当前点击的是："+ this.id);
				var link = "dhcckb.problemscenter.csp";
				window.open(link,"_blank","height="+ (window.screen.availHeight - 150) +", width="+ (window.screen.availWidth - 150) +", top=50, left=50,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
				event.stopPropagation();
			})
			
			/// 最小化事件
			$(".ckb-warn-close").bind('click',function(){
				$(".ckb_warn_win").addClass("ckb_warn_win_min");
				event.stopPropagation();
			});
			
			$(".ckb_warn_win").bind('click',function(){
				if($(".warn_ul").css("display")=='none' ) {
					$(".ckb_warn_win").removeClass("ckb_warn_win_min");
				}
				event.stopPropagation();
			})
				
			/// 强制审核
			$("#bt_audit").bind('click',function(){
				$(".view-reason").css({'display':'block'});
			})
			
			/// 返回修改
			//$("#bt_return").bind('click',function(){
			$(".ckb-view-control").on('click','#bt_return',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
				$(".ckb_warn_win").remove();
				$(".view-reason").remove();   /// 删除双签复核弹窗
			})
			
			/// 关闭事件
			$(".view-reason .ckb-view-tool-close").bind('click',function(){
				$(".view-reason").css({'display':'none'});
			});
						
			/// 双签复核
			$("#bt_doublesign").bind('click',function(){
				$(".view-reason").css({'display':'none'});
				$.messager.alert('提示','复核成功！','info');
			});
			
		},
		relocation : function() {
			
			/// 弹出窗体重新定位
			var El = document.getElementById("ckb_view_win"); /// 获取div块对象
	        var Height = document.documentElement.clientHeight; /// 取得浏览器页面可视区域的宽度
	        var Width = document.documentElement.clientWidth;   /// 取得浏览器页面可视区域的宽度
	        var El_Height = El.offsetHeight; /// 获取div块的高度值
	        var El_Width = El.offsetWidth;   /// 获取div块的宽度值
	        El.style.top = (Height - El_Height)/2+"px";
	        El.style.left = (Width - El_Width)/2+"px";
	        
	        var VR_El = document.getElementById("view-reason"); /// 获取div块对象
	        VR_El.style.top = (Height - El_Height)/2+"px";
	        VR_El.style.left = ((Width - El_Width)/2 + El_Width + 3) +"px";
	        
	        $(".ckb_warn_win").css("left",(Width/2-135)+"px"); /// 警示灯重新定位 2020-09-30 bianshuai
		},
		re_vreason : function() {
			
			/// 弹出窗体重新定位
			var El = document.getElementById("ckb_view_win");   /// 获取div块对象
	        var VR_El = document.getElementById("view-reason"); /// 获取div块对象
	        var El_Width = El.offsetWidth;   /// 获取div块的宽度值
	        VR_El.style.top = El.style.top;
	        VR_El.style.left = (parseInt(El.style.left) + El_Width + 3) +"px";
	        
		},
		bin_data : {},
		init : function() {
			this.initMain();
		},
		initMain : function() {
			var me = this;
			$(".ckb-view-container").remove(); /// 删除面板
			$(".ckb_warn_win").remove(); /// 删除面板
			this.container.append( template( this.templates.main ) );
			if ($(".ckb_warn_win").length == 0){
				this.container.append( template( this.templates.warnWin ) );  /// 初始化警示灯 2020-09-30 bianshuai
			}
			if (me.WinType == "OPENWIN"){
				$(".ckb-view-tool-close").remove(); /// 移除关闭按钮
			}
			if ($(".view-reason").length == 0){
				this.container.append( template( this.templates.reasonWin ) ); /// 强制审核区域
			}
			this.relocation(); /// 重新定位
			$(".ckb-view-container").hide();
			$(".ckb_warn_win").hide(); 
			// 切换顶部导航标签
            $( '.ckb-view-container' ).delegate( '.ckb-view-nav-item', 'click', function() {
                var el = $( this );
                el.siblings().removeClass( 'ckb-view-nav-active' );
                el.addClass( 'ckb-view-nav-active' );
                $('.ckb-view-main').hide(); 
                $($('.ckb-view-main')[$(this).index()]).show();				
	
             	if (me.status.activeTab != el.attr( 'data-name' ) && JSON.stringify(me.bin_data)!="{}") {
                    me.status.activeTab = el.attr( 'data-name' );
                    me.nav_ind = el.index();
                    if (me.nav_ind == 0) {
                        if(me.gotTips==0){
                            me[ me.__method( me.status.activeTab ) ]();
                            me.gotTips = 1;
                        }
                    } else if (me.nav_ind == 1) {
                        if(me.gotEdus==0){
                            me[ me.__method( me.status.activeTab ) ]();
                            me.gotEdus = 1;
                        }
                    }
                } else {
                    return false;
                } 
            } );
            me.init_Temp();	// 初始化模板 bianshuai 2021-01-04
		},
		init_Temp : function() {
			
			/// 初始化模板  bianshuai 2021-01-04
			var me = this;
			templates = me.templates;
			var main = $( '#ckbid-main1' );
			this.update( {}, function( data ) {
								
				if (typeof data.ErrorCode == "undefined"){
					
					templates.view[ "monTemp" ] = me.temp_html(data);			
				}else{
					main.append('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					$(".ckb-view-container").show();
				}
			}, "Temp")
		} ,
		temp_html : function(jsonObj) {
			
			/// 初始化模板  bianshuai 2021-01-04
			var tempHtml = jsonObj.Html;
			var tempHeadHtml = getFormatHtml(tempHtml, "monHead"); /// 审查项目
			var tempbodyHtml = getFormatHtml(tempHtml, "monBody"); /// 审查结果目录
			var tempBaseHtml = getFormatHtml(tempHtml, "monBase"); /// 建议信息
		  
		    var tempHtml = "";
				tempHtml = tempHtml + '<% for( var i = 0; i < items.length; i ++ ) { %> <% var item = items[ i ]; var base = item.tips[0];%>';
				tempHtml = tempHtml + '<div class="ckb-view-body-item" data-id="WL<%-item.unique %>" data-recmedical="<%-item.adviceDrug %>">';
				tempHtml = tempHtml + '   <div class="ckb-view-item-head">';
				tempHtml = tempHtml +         tempHeadHtml;
				tempHtml = tempHtml + '   </div>';	// head 结束
				tempHtml = tempHtml + '   <div class="ckb-view-item-body">';	// warns是目录级别
				tempHtml = tempHtml + '   	<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ]; var itemCss = j==item.warns.length-1?"":"ckb-view-item-bottom-line";%>';
				tempHtml = tempHtml + '   		<% for (var k = 0; k < warn.itms.length; k++) { %> <% var rule =warn.itms[k]; var ruleCss = k==warn.itms.length-1?"":"ckb-view-item-bottom-line"; %>';	// 规则
				tempHtml = tempHtml + '   		    <% var ruleColorCss = "warn-cololr-normal"; if (rule.manLevel == "remind") ruleColorCss = "remind-color";if(rule.manLevel == "forbid") ruleColorCss = "forbid-color"; if(rule.manLevel == "warn") ruleColorCss = "warn-color"; if( rule.manLevel == "tips") ruleColorCss = "tips-color"; if( rule.manLevel == "normal") ruleColorCss = "normal-color"; %>';	
				tempHtml = tempHtml + '   			<% var ruleSource = ""; if ( rule.source != "")  ruleSource="参考依据："+rule.source; %>';
				
				tempHtml = tempHtml + '  			<div class="item-group">';  // 组
				tempHtml = tempHtml + '   				<% for (var m = 0; m<rule.itms.length; m++){ var val = rule.itms[m].val;%>';
				tempHtml = tempHtml + '  			    	<div class="item-group-rows">';  // 组
				tempHtml = tempHtml +    			    		tempbodyHtml;
				tempHtml = tempHtml + '  			    	</div>';
				tempHtml = tempHtml + '   				<% } %>';
				tempHtml = tempHtml + '  			</div>';
				
				tempHtml = tempHtml + '   	   <% } %>';
				tempHtml = tempHtml + '   	<% } %>';
				tempHtml = tempHtml + '   </div>';
				tempHtml = tempHtml + '</div>';
				
				tempHtml = tempHtml + '<div class="ckb-view-detail" data-id="WL<%-item.unique %>"  data-itmid="<%-item.itmID %>">';
				tempHtml = tempHtml +     tempBaseHtml;
				tempHtml = tempHtml + '</div>';	// detail结束
				
				
				tempHtml = tempHtml + '<div id="ckbid-main2" class="ckb-view-education" data-id="WL<%-item.unique %>">';
				//tempHtml = tempHtml +     tempBaseHtml;
				tempHtml = tempHtml + '</div>';	// 用药教育结束
				
				
				tempHtml = tempHtml + '<div class="ckb-view-docnotes" data-id="WL<%-item.unique %>">';
				tempHtml = tempHtml + '	   <div class="view-notelists">';
				tempHtml = tempHtml + '	   		<label>医生批注：</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="临床指南" /><label>临床指南</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="CFDA相关适应症" /><label>CFDA相关适应症</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="新编药物学" /><label>新编药物学</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="马丁代尔" /><label>马丁代尔</label>';
				tempHtml = tempHtml + '	  		<input type="checkbox" name="reagrp" value="药品说明书" /><label>药品说明书</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="otherVal" /><label>其他</label>';
				tempHtml = tempHtml + '    </div>';
				tempHtml = tempHtml + '    <div style="margin-top:5px;"><textarea id="reason" style="width:560px;height:30px;resize:none;margin-left:88px;" required></textarea></div>';
				tempHtml = tempHtml + '</div>';	// detail结束
				
				tempHtml = tempHtml + '<% } %>';
		    return tempHtml;
		} ,
		turnLight : function( data ) {
			
			/// 控制药品审查亮灯
			if (typeof data.items == "undefined") return;
			var unique = data.unique;
			var WarnLight = data.manLevel;
			$("#WL" + unique).attr("src","../scripts/dhcnewpro/dhcckb/images/"+ WarnLight +".png");
			
			$(".warn_li div:not(.warn-log)").addClass("icon-warn-default");     /// 初始化警示灯 2020-09-30 bianshuai
			if (WarnLight != "normal") $("#"+WarnLight).removeClass("icon-warn-default");
		},
		showPanel : function () {
			if ($(".ckb-view-container").is(':hidden')){
				$(".ckb-view-container").show();
			}
		},
		formatTemp : function () {
			
			var itemgroup = $(".ckb-view-item-body .item-group");
			for (var m=0; m<=itemgroup.length; m++){
				var item_group_rows = $(itemgroup[m]).find(".item-group-rows");
				for (var n=0; n<item_group_rows.length; n++){
					var els = $(item_group_rows[n]).find('.row');
					if (n != 0) $(item_group_rows[n]).find('span[data-valloc=startLine]').find("label").text("");
					if (n != 0) $(item_group_rows[n]).find('span.itemlabel-yy').css({"visibility":"hidden"});
					if (n != (item_group_rows.length -1)) $(item_group_rows[n]).find('span[data-valloc=endLine]').find("label").text("");
					for(var k=0; k<els.length; k++){
						if ($(els[k]).text() == "") $(els[k]).remove();
					}
				}				
			}
			/// 此处是为了应付演示，后期需删除
			$(".ckb-view-body-item[data-recmedical='']").find('.item-recmedical').css({"visibility":"hidden"});

		},
		updateTips : function() {
			var me = this;
			me.nav_ind = 0;
			me.bin_event();
			templates = me.templates;
			//var main = $( '.ckb-view-body-lists' );
			var main = $( '#ckbid-main1' );
			
			var me = this;
			this.update( this.bin_data.data, function( data ) {
		
				if (typeof data.ErrorCode == "undefined"){
				 /*
					if (me.EffFlag == 1){
						main.append( template( templates.view[ "item" ], data ) );
						me.turnLight(data);  /// 提示灯控制
						$(".ckb-view-container").show();
					}else{
						main.append( template( templates.view[ "item" ], data ) );
						me.turnLight(data);  /// 提示灯控制
					}
					*/
					//main.append( template( templates.view[ "item" ], data ) );
					main.append( template( templates.view[ "monTemp" ], data ) );
					
					me.formatTemp();     // 格式化输出模板
					
					me.turnLight(data);  /// 提示灯控制
					switch (me.EffFlag){
						case 0:	// 只弹提示灯			
						$(".ckb_warn_win").show(); 	
						$(".ckb-view-container").hide();					
						break;
						case 1:	// 弹窗明细
						$(".ckb-view-container").show();
						$(".ckb_warn_win").remove(); 
						break;
						case 3:	// 提示灯和明细都弹
						$(".ckb-view-container").show();
						$(".ckb_warn_win").show(); 
						break;
						case 2:	// 不弹出						
						default:	// 不弹窗
						$(".ckb_warn_win").remove(); 
						$(".ckb-view-container").hide();						
						break;
					}
					me.passFlag = data.passFlag ;   /// 审查结果通过状态				
					me.manLevel = data.manLev ;     /// 审核结果警示级别
					me.MsgID = data.MsgID;
					me.Msg = data.items;
					//typeof me.checkFn === "function" ? me.checkFn( data.passFlag, data.manLev ) : ""; 	/// 回调函数
//					$("label[data-id=ruleSource]").each(function(){
//						if ($(this).text() == ""){
//							$(this).parent().parent().css("display","none");
//						}
//					})
				}else{
					$(".ckb_warn_win").remove(); 	
					main.append('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					$(".ckb-view-container").show();
				}
			})
		},
		updateEdus : function() {
			var me = this;
			//me.bin_event();
			//me.nav_ind = 1;
			templates = me.templates;
			var main = $( '#ckbid-main2' );
			this.bin_data.data.Action="EduRule"
			this.update( this.bin_data.data, function( data ) {
								
				if (typeof data.ErrorCode == "undefined"){								
					main.html( template( templates.view[ "eduItem" ], data ) );
					//$(".ckb-view-container").show();				
				}else{
					main.html('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					//$(".ckb-view-container").show();
				}
			})
		},
		update : function( data, callback, action ) {
			
			// 增加action(事件分发类型) bianshuai 2021-01-04
			runClassMethod("web.DHCCKBService" ,"AcitonProxy", {"jsParamObj" : JSON.stringify(data), "MsgID" : data.MsgID||"", "action" : action||"Pass"},function(jsonObject){
					/*if(jsonObject.passFlag==1){					//sufan 2020-09-11 暂时加这里
						$(".ckb-view-container").remove();
					}*/
					
					callback.call( this, jsonObject );
			},'json',false)
		},
		review : function( data ) {
			//this.checkFn(data);
		},
		refresh : function( data, Fn, EffFlag) {
			data.ClientIP = CKBClientIp;			
			
			if ((data.Action == null)||(data.Ation === undefined)){
				data.Action = "CheckRule"
			}
			this.bin_data.data = data;
			this.checkFn = Fn;
			this.EffFlag = EffFlag;    /// 展示效果
			this.gotTips = this.gotEdus = 0;
			if (this.nav_ind == 0) {
                this[ this.__method( this.status.activeTab ) ]();
                this.gotTips = 1;
            } else if (this.nav_ind == 1) {
                this[ this.__method( this.status.activeTab ) ]();
                this.gotEdus = 1;
            }
			//this[ this.__method( "Tips" ) ]();
		},
		__method : function( name ) {
			return 'update' + name.replace( /(^|-)([a-zA-Z])/g, function( m, n, o ) {
				return o.toUpperCase();
			} );
		},
			close:function(){	// 关闭事件
			$(".ckb-view-container").remove();
		},
		feedBack : function(fn,msgID, user, date, time, ordItemStr, userType) {			 // 2020/12/1 新增反馈接口
			runClassMethod("web.DHCCKBService" ,"FeedBack", {"msgID":msgID,"user":user,"date":date,"time":time,"ordItemStr":ordItemStr,"userType":userType},function(jsonObject){
				fn.call( this, jsonObject );
			},'json',false)
		},
	};
	
	window.PDSS = PDSS;
})(this)

function GetClientIp()
{
	runClassMethod("web.DHCCKBCommonUtil","GetClientIp",{},function(jsonString){
		CKBClientIp = jsonString;		
	},'',false)
}
