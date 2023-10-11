//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-05-09
// 描述:	   安全用药智能决策系统js
//===========================================================================================
(function(window){
	
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
	
	var InreView = function(options){
		
		if( !options ) options = {};
		for( var attr in options ) {
			if( options.hasOwnProperty( attr ) ) {
				this[ attr ] = options[ attr ];
			}
		}
		if( !this.container ) this.container = document.body;
		this.container = $( this.container );
		this.EffFlag = 1 ;    /// 展示效果
		this.checkFn = null ; /// 回调函数
		this.init( options );
	}
	
	InreView.prototype = {
		constructor : InreView,
		templates : {
			main  : '<div id="ckb_view_win" class="ckb-view-container"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>安全用药智能决策系统</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-body-lists"></div></div></div>',
			view  : {
				item:'<% for( var i = 0, l = items.length; i < l; i ++ ) { %> <% var item = items[ i ]; %>'+
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
						  '</div>'+
						  '<div class="ckb-view-item-body">'+
						 	  '<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ]; var itemCss = j==item.warns.length-1?"":"ckb-view-item-bottom-line";%>'+
							  '<% var itmColorCss = "warn-color-normal"; if( warn.manLevel == "remind") itmColorCss = "remind-color";if( warn.manLevel == "forbid") itmColorCss = "forbid-color"; if( warn.manLevel == "warn") itmColorCss = "warn-color"; if( warn.manLevel == "tips") itmColorCss = "tips-color"; if( warn.manLevel == "normal") itmColorCss = "normal-color";%>'+
								  '<div class="ckb-view-item">'+
								 	 '<div class="ckb-view-item-icon">'+
									 	 '<img src="../scripts/dhcnewpro/dhcckb/images/<%-warn.manLevel%>-10.png" border=0/>'+
								 	 '</div>'+
								 	 '<div class="ckb-view-item-warn <%-itmColorCss%>"><label><%-warn.manLev%></label></div>'+
								 	 '<div class="ckb-view-item-tips <%-itmColorCss%>"><label><%-warn.itemkey%></label></div>'+
								 	 '<div class="ckb-view-item-rest"><label><%-warn.itemval%></label></div>'+
							 	 	 '<div class="ckb-view-item-top-line"></div>'+
							 	 	 '<div class="<%-itemCss%>"></div>'+
							 	 '</div>'+
							  '<% } %>'+
						  '</div>'+
					  '</div>'+
			  		  '<div class="ckb-view-detail" data-id="WL<%-item.unique %>">'+
					     '<div class="ckb-view-detail-patbase">'+
					   	     '<div class="ckb-view-detail-title">'+
					   	   		 '<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		 '<label>基本信息</label>'+
					   	     '</div>'+
					   	     '<div class="ckb-view-detail-info">'+
					   	   	   	  '<table border="1" cellspacing="0" cellpadding="1" class="ckb-view-item-table">'+
					   	   	   	  	  '<tr style="height:30px;"><td class="key-label"><label>出生日期：</label></td><td><label class="val-label"><%-item.tips[0].Birth %></label></td><td class="key-label"><label>身高：</label></td><td><label class="val-label"><%-item.tips[0].Height %>CM</label></td><td class="key-label"><label>体重：</label></td><td><label class="val-label"><%-item.tips[0].Weight %>KG</label></td></tr>'+
					   	   	   	 	  '<tr style="height:30px;"><td class="key-label"><label>单次剂量：</label></td><td><label class="val-label"><%-item.tips[0].DoseUom %></label></td><td class="key-label"><label>每日用量：</label></td><td><label class="val-label"><%-item.tips[0].MaxDosQty %></label></td><td class="key-label"><label>给药频率：</label></td><td><label class="val-label"><%-item.tips[0].Freq %></label></td></tr>'+
					   	   	   	  	  '<tr style="height:30px;"><td class="key-label"><label>给药方式：</label></td><td><label class="val-label"><%-item.tips[0].Instr %></label></td><td class="key-label"><label>持续时间：</label></td><td colspan=3><label class="val-label"><%-item.tips[0].Duration %></label></td></tr>'+
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
				      '</div><% } %>',
				refres:''
			}
		} ,
		bin_event : function() {
			
			 var o,   //捕获到的事件
			  X,  //box水平宽度
			  Y;  //box垂直高度
			 function getObject(obj,e){    //获取捕获到的对象
				o = obj;
				// document.all（IE）使用setCapture方法绑定；其余比如FF使用Window对象针对事件的捕捉
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
				//    dis = arguments[0]||window.event;   //如果上面那句在FF下无法获取事件，听说可以通过 arguments[0]获取FF下的事件对象
				}
				o.style.left = dis.clientX - X +"px";     //设定box样式随鼠标移动而改变
				o.style.top = dis.clientY - Y + "px";
			};
			document.onmouseup = function(){    //鼠标松开事件处理
				if(!o){   //如果未获取到相应对象则返回
					return;
				}
				// document.all（IE）使用releaseCapture解除绑定；其余比如FF使用window对象针对事件的捕捉
				document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP)
				o = '';   //还空对象
			};
			
			var me = this;
			/// 关闭事件
			$(".ckb-view-tool-close").bind('click',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
			})
			
			/// 详情
			$("#ckb_view_win").on('click','.ckb-view-item-more',function(){
				if ($(".ckb-view-detail[data-id='"+ $(this).attr("data-id") +"']").is(':hidden')){
					$(".ckb-view-detail[data-id='"+ $(this).attr("data-id") +"']").show();
					$(this).text("详细信息[-]");
				}else{
					$(".ckb-view-detail[data-id='"+ $(this).attr("data-id") +"']").hide();
					$(this).text("详细信息[+]");
				}
//				if ($(this).parent().parent().next().is(':hidden')){
//					$(this).parent().parent().next().show();
//					$(this).text("详情[-]");
//				}else{
//					$(this).parent().parent().next().hide();
//					$(this).text("详情[+]");
//				}
			})
			
			/// 控制灯事件
			$(".warn-light").on('click','img',function(){
				$(".ckb-view-body-item[data-id='"+ this.id +"']").show().siblings().hide(); /// 项目隐藏
				me.showPanel();
			})
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
		},
		bin_data : {},
		init : function() {
			this.initMain();
		},
		initMain : function() {
			var me = this;
			$(".ckb-view-container").remove(); /// 删除面板
			this.container.append( template( this.templates.main ) );
			this.relocation(); /// 重新定位
			$(".ckb-view-container").hide();
		},
		turnLight : function( data ) {
			
			/// 控制药品审查亮灯
			if (typeof data.items == "undefined") return;
			for(var key in data.items){
				var unique = data.items[key].unique;
				var WarnLight = data.items[key].manLevel;
				$("#WL" + unique).attr("src","../scripts/dhcnewpro/dhcckb/images/"+ WarnLight +".png");
			}
		},
		showPanel : function () {
			if ($(".ckb-view-container").is(':hidden')){
				$(".ckb-view-container").show();
			}
		},
		updateTips : function() {
			var me = this;
			me.bin_event();
			templates = me.templates;
			var main = $( '.ckb-view-body-lists' );
			//main.append( templates.view.item );
			//$(".ckb-view-container").show();
			
			var me = this;
			this.update( this.bin_data.data, function( data ) {
				
				if (typeof data.ErrorCode == "undefined"){
					if (me.EffFlag == 1){
						main.append( template( templates.view[ "item" ], data[0] ) );
						me.turnLight(data[0]);  /// 提示灯控制
						$(".ckb-view-container").show();
					}else{
						main.append( template( templates.view[ "item" ], data[0] ) );
						me.turnLight(data[0]);  /// 提示灯控制
					}
				}else{
					main.append('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					$(".ckb-view-container").show();
				}
			})
		},
		update : function( data, callback ) {
			//runClassMethod("web.DHCCKBMonitor","InvKnowBaseExam",{"jsParamObj" : JSON.stringify(data)},function(jsonObject){
			runClassMethod("web.DHCCKBPass","IntMakPolPass",{"jsParamObj" : JSON.stringify(data)},function(jsonObject){
					callback.call( this, jsonObject );
			},'json',false)
			
		},
		review : function( data ) {
			this.checkFn(data);
		},
		refresh : function( data, Fn, EffFlag) {
			this.bin_data.data = data;
			this.checkFn = Fn;
			this.EffFlag = EffFlag;    /// 展示效果
			this[ this.__method( "Tips" ) ]();
		},

		__method : function( name ) {
			return 'update' + name.replace( /(^|-)([a-zA-Z])/g, function( m, n, o ) {
				return o.toUpperCase();
			} );
		}
	}
	
	window.InreView = InreView;
})(this)
