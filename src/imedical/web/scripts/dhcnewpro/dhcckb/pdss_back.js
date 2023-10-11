//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-05-09
// ����:	   ��ȫ��ҩ���ܾ���ϵͳ(PDSS,Physic Decision Safety Support System)
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
	
	var PDSS = function(options){
		
		if( !options ) options = {};
		for( var attr in options ) {
			if( options.hasOwnProperty( attr ) ) {
				this[ attr ] = options[ attr ];
			}
		}
		if( !this.container ) this.container = document.body;
		this.container = $( this.container );
		this.EffFlag = 1 ;    /// չʾЧ��
		this.checkFn = null ; /// �ص�����
		this.passFlag = 0 ;   /// �����ͨ��״̬
		this.manLevel = 0 ;   /// ��˽����ʾ����
		this.init( options );
	};
	
	PDSS.prototype = {
		constructor : PDSS,
		templates : {
			main  : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>��ȫ��ҩ���ܾ���ϵͳ</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-body-lists"></div></div></div>',
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
								  '<label class="ckb-view-item-more" data-id="WL<%-item.unique %>">��ϸ��Ϣ[+]</label>'+
							  '</div>'+
							  '<div class="ckb-view-item-bottom-line"></div>'+
						  '</div>'+	// head ����
						  '<div class="ckb-view-item-body">'+	// warns��Ŀ¼����
						 	'<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ]; var itemCss = j==item.warns.length-1?"":"ckb-view-item-bottom-line";%>'+
							 	 //'<% var itmColorCss = "warn-color-normal"; if( warn.manLevel == "remind") itmColorCss = "remind-color";if( warn.manLevel == "forbid") itmColorCss = "forbid-color"; if( warn.manLevel == "warn") itmColorCss = "warn-color"; if( warn.manLevel == "tips") itmColorCss = "tips-color"; if( warn.manLevel == "normal") itmColorCss = "normal-color";%>'+
								'<% for (var k = 0; k < warn.itms.length; k++) { %> <% var rule =warn.itms[k]; var ruleCss = k==warn.itms.length-1?"":"ckb-view-item-bottom-line"; %>'+	// ����
									'<div class="ckb-view-item">'+
								 		'<div class="ckb-view-item-icon">'+
									 		'<img src="../scripts/dhcnewpro/dhcckb/images/<%-rule.manLevel%>-10.png" border=0/>'+	
								 		'</div>'+
								  		'<% var ruleColorCss = "warn-cololr-normal"; if (rule.manLevel == "remind") ruleColorCss = "remind-color";if(rule.manLevel == "forbid") ruleColorCss = "forbid-color"; if(rule.manLevel == "warn") ruleColorCss = "warn-color"; if( rule.manLevel == "tips") ruleColorCss = "tips-color"; if( rule.manLevel == "normal") ruleColorCss = "normal-color"; %>'+	
								  		'<div class="ckb-view-item-warn <%-ruleColorCss%>"><label><%-rule.manLev%></label></div>'+	// ���򼶱�
								 		'<div class="ckb-view-item-tips <%-ruleColorCss%>"><label><%-warn.keyname%></label></div>'+	// Ŀ¼����
											'<% for (var m = 0; m<rule.itms.length; m++){ %>'+	// ��������
												'<div class="ckb-view-item-rest"><label><%-rule.itms[m].val%></label></div>'+													
											'<% } %>'+												
											'<% var ruleSource = ""; if ( rule.source != "")  ruleSource="���ο����ݡ�:"+rule.source; %>'+
											'<div class="ckb-view-item-rest"><label><%-ruleSource%></label></div>'+	// ��ʾ����											
									 	'<div class="ckb-view-item-top-line"></div>'+
									 	'<div class="<%-ruleCss%>"></div>'+
									 '</div>'+
								'<% } %>'+
						   '<% } %>'+
						 '</div>'+	// body ����
					  '</div>'+		// itm����
					  '<div class="ckb-view-detail" data-id="WL<%-item.unique %>">'+	
					  		'<div class="ckb-view-detail-patbase">'+
					   	    	 '<div class="ckb-view-detail-title">'+
					   	   			 '<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		 	 '<label>������Ϣ</label>'+
					   	     	 '</div>'+
					   	     	 '<div class="ckb-view-detail-info">'+
					   	   	   	 	 '<table border="1" cellspacing="0" cellpadding="1" class="ckb-view-item-table">'+
					   	   	   	  	  '<tr style="height:30px;"><td class="key-label"><label>���䣺</label></td><td><label class="val-label"><%-item.tips[0].AgeProp %></label></td><td class="key-label"><label>��ߣ�</label></td><td><label class="val-label"><%-item.tips[0].Height %></label></td><td class="key-label"><label>���أ�</label></td><td><label class="val-label"><%-item.tips[0].Weight %></label></td></tr>'+
					   	   	   	 	  '<tr style="height:30px;"><td class="key-label"><label>���μ�����</label></td><td><label class="val-label"><%-item.tips[0].OnceDose %></label></td><td class="key-label"><label>ÿ��������</label></td><td><label class="val-label"><%-item.tips[0].DayDose %></label></td><td class="key-label"><label>��ҩƵ�ʣ�</label></td><td><label class="val-label"><%-item.tips[0].DrugFreq %></label></td></tr>'+
					   	   	   	  	  '<tr style="height:30px;"><td class="key-label"><label>��ҩ��ʽ��</label></td><td><label class="val-label"><%-item.tips[0].DrugPreMet %></label></td><td class="key-label"><label>����ʱ�䣺</label></td><td colspan=3><label class="val-label"><%-item.tips[0].Treatment %></label></td></tr>'+
					   	   	   	  	'</table>'+
					   	    	 '</div>'+
					   	     	 '<div class="ckb-view-detail-line"></div>'+
					   	     	 '<div class="ckb-view-item-bottom-line"></div>'+
					     	'</div>'+
					  		'<div class="ckb-view-detail-res">'+
					   	   	  	'<div class="ckb-view-detail-title">'+
					   	   			 '<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		 	 '<label>�����</label>'+
					   	     	'</div>'+
					   	      	'<div class="ckb-view-detail-resinfo">'+
					   	   			 '<label>����˵�����޶�</label>'+
					   	     	'</div>'+
					   	     	'<div class="ckb-view-detail-line"></div>'+
					   	      	'<div class="ckb-view-item-top-line"></div>'+
					   	      	'<div class="ckb-view-item-bottom-line"></div>'+
					    	'</div>'+
					  		'<div class="ckb-view-detail-res">'+
					   	      	'<div class="ckb-view-detail-title">'+
					   	   			'<div class="ckb-view-detail-title-img"><img src="../scripts/dhcnewpro/dhcckb/images/gray-10.png" border=0/></div>'+
					   	   		  	'<label>�ο��÷�����</label>'+
					   	      	'</div>'+
					   	      	'<div class="ckb-view-detail-info">'+
					   	   	   			'<table border="1" cellspacing="0" cellpadding="1" class="ckb-view-item-table">'+
					   	   	   	  			'<tr style="height:30px;"><td colspan=2 class="key-label" style="width:115px"><label>����ο�˵����</label></td><td class="key-label"><a href="javascript:void(0)" onclick=\"window.open(\'dhcckb.wiki.csp?IncId=<%-item.itmID %>\')\">����</a></td><td colspan=2><label class="val-label"></label></td></tr>'+					   	   	   	 	  
					   	   	   	  	  		//'<tr style="height:30px;"><td class="key-label"><label>����׶Σ�</label></td><td colspan=2><label class="val-label"></label></td><td class="key-label"><label>���ط�Χ��</label></td><td colspan=2><label class="val-label"></label></td></tr>'+
					   	   	   	 	  		//'<tr style="height:30px;"><td class="key-label"><label>����������</label></td><td colspan=2><label class="val-label"></label></td><td class="key-label"><label>����Ƶ�ʣ�</label></td><td colspan=2><label class="val-label"></label></td></tr>'+
					   	   	   	  	 		 //'<tr style="height:30px;"><td class="key-label"><label>�����Ƴ̣�</label></td><td colspan=2><label class="val-label"></label></td><td class="key-label"><label></label></td><td colspan=2><label class="val-label"></label></td></tr>'+
					   	   	   	 		'</table>'+
					   	      	'</div>'+
					   	      	'<div class="ckb-view-item-top-line"></div>'+
					     	'</div>'+
					  '</div>'+	// detail����
				      '<% } %>',
				refres:''
			}
		} ,
		bin_event : function() {
			
			 var o;   //���񵽵��¼�
			 var X;   //boxˮƽ���
			 var Y;   //box��ֱ�߶�
			 function getObject(obj,e){    //��ȡ���񵽵Ķ���
				o = obj;
				document.all?o.setCapture() : window.captureEvents(Event.MOUSEMOVE);  
				X = e.clientX - parseInt(o.offsetLeft);   //��ȡ��ȣ�
				Y = e.clientY - parseInt(o.offsetTop);   //��ȡ�߶ȣ�
			}
			document.getElementById("ckb_view_bar").onmousedown = function(e){ 
				getObject(document.getElementById("ckb_view_win"),e||event);       //box�����¼�������  e-->FF  window.event-->IE
			};
			document.onmousemove = function(dis){    //����ƶ��¼�����
				if(!o){    //���δ��ȡ����Ӧ�����򷵻�
					return;
				}
				if(!dis){  //�¼�
					dis = event ;
				}
				o.style.left = dis.clientX - X +"px";     //�趨box��ʽ������ƶ����ı�
				o.style.top = dis.clientY - Y + "px";
			};
			document.onmouseup = function(){    //����ɿ��¼�����
				if(!o){   //���δ��ȡ����Ӧ�����򷵻�
					return;
				}
				// document.all��IE��ʹ��releaseCapture����󶨣��������FFʹ��window��������¼��Ĳ�׽
				document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP);
				o = '';   //���ն���
			};
			
			var me = this;
			/// �ر��¼�
			$(".ckb-view-tool-close").bind('click',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
			});
			
			/// ����
			$("#ckb_view_win").on('click','.ckb-view-item-more',function(){
				if ($(".ckb-view-detail[data-id='"+ $(this).attr("data-id") +"']").is(':hidden')){
					$(".ckb-view-detail[data-id='"+ $(this).attr("data-id") +"']").show();
					$(this).text("��ϸ��Ϣ[-]");
				}else{
					$(".ckb-view-detail[data-id='"+ $(this).attr("data-id") +"']").hide();
					$(this).text("��ϸ��Ϣ[+]");
				}
			});
			
			/// ���Ƶ��¼�
			$(".warn-light").on('click','img',function(){
				$(".ckb-view-body-item[data-id='"+ this.id +"']").show().siblings().hide(); /// ��Ŀ����
				me.showPanel();
			})
		},
		relocation : function() {
			
			/// �����������¶�λ
			var El = document.getElementById("ckb_view_win"); /// ��ȡdiv�����
	        var Height = document.documentElement.clientHeight; /// ȡ�������ҳ���������Ŀ��
	        var Width = document.documentElement.clientWidth;   /// ȡ�������ҳ���������Ŀ��
	        var El_Height = El.offsetHeight; /// ��ȡdiv��ĸ߶�ֵ
	        var El_Width = El.offsetWidth;   /// ��ȡdiv��Ŀ��ֵ
	        El.style.top = (Height - El_Height)/2+"px";
	        El.style.left = (Width - El_Width)/2+"px";
		},
		bin_data : {},
		init : function() {
			this.initMain();
		},
		initMain : function() {
			var me = this;
			$(".ckb-view-container").remove(); /// ɾ�����
			this.container.append( template( this.templates.main ) );
			this.relocation(); /// ���¶�λ
			$(".ckb-view-container").hide();
		},
		turnLight : function( data ) {
			
			/// ����ҩƷ�������
			if (typeof data.items == "undefined") return;
			var unique = data.unique;
			var WarnLight = data.manLevel;
			$("#WL" + unique).attr("src","../scripts/dhcnewpro/dhcckb/images/"+ WarnLight +".png");
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
			
			var me = this;
			this.update( this.bin_data.data, function( data ) {
				
				if (typeof data.ErrorCode == "undefined"){
					if (me.EffFlag == 1){
						main.append( template( templates.view[ "item" ], data ) );
						me.turnLight(data);  /// ��ʾ�ƿ���
						$(".ckb-view-container").show();
					}else{
						main.append( template( templates.view[ "item" ], data ) );
						me.turnLight(data);  /// ��ʾ�ƿ���
					}
					me.passFlag = data.passFlag ;   /// �����ͨ��״̬
					me.manLevel = data.manLev ;     /// ��˽����ʾ����
					typeof me.checkFn === "function" ? me.checkFn( data.passFlag, data.manLev ) : ""; 	/// �ص�����
				}else{
					main.append('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					$(".ckb-view-container").show();
				}
			})
		},
		update : function( data, callback ) {
			
			runClassMethod("web.DHCCKBPassNew" ,"AcitonProxy", {"jsParamObj" : JSON.stringify(data), "lmID" : data.lmID||""},function(jsonObject){
					callback.call( this, jsonObject );
			},'json',false)
		},
		review : function( data ) {
			//this.checkFn(data);
		},
		refresh : function( data, Fn, EffFlag) {
			this.bin_data.data = data;
			this.checkFn = Fn;
			this.EffFlag = EffFlag;    /// չʾЧ��
			this[ this.__method( "Tips" ) ]();
		},

		__method : function( name ) {
			return 'update' + name.replace( /(^|-)([a-zA-Z])/g, function( m, n, o ) {
				return o.toUpperCase();
			} );
		}
	};
	
	window.PDSS = PDSS;
})(this)
