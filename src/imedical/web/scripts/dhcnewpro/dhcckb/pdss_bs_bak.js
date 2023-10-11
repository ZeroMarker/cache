//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-05-09
// ����:	   ��ȫ��ҩ���ܾ���ϵͳ(PDSS,Physic Decision Safety Support System)
//===========================================================================================

var CKBClientIp = "";
(function(window){
	
	GetClientIp();	// ��ȡ�ͻ���ip
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
			/// Ĭ�������Ŀ��ż�Ŀ¼��ʽ��ʶ
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
        this.nav_ind = 0; // ��ʶ��ǰ��ʾ�Ĳ˵���
        this.gotTips = 0; // ��ʶ�Ѿ��������������dom
        this.gotEdus = 0; // ��ʶ�Ѿ���������ҩ����dom
        
		if( !this.container ) this.container = document.body;
		this.container = $( this.container );
		this.EffFlag = 1 ;    /// չʾЧ��
		this.checkFn = null ; /// �ص�����
		this.passFlag = 1 ;   /// �����ͨ��״̬
		this.manLevel = "��ʾ" ;   /// ��˽����ʾ����
		this.controlFlag = "N"	/// ǿ����˱�־(Ĭ��ΪN)
		this.MsgID = "";						/// ��Ϣ���id
		this.Msg = "";							 /// ��Ϣjson
		this.init( options );
	};
	
	PDSS.prototype = {
		constructor : PDSS,
		templates : {
			//main  : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>��ȫ��ҩ���ܾ���ϵͳ</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-body-lists"></div></div></div>',
			//main : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>��ȫ��ҩ���ܾ���ϵͳ</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-nav"><span class="ckb-view-nav-item ckb-view-nav-active" data-name="tips">�������</span><span class="ckb-view-nav-item" data-name="edus">��ҩ����</span></div><div class="ckb-view-main" id="ckbid-main1" style="overflow: auto;"></div><div class="ckb-view-main" id="ckbid-main2" style="display: none"></div></div>',
			//       '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>��ȫ��ҩ���ܾ���ϵͳ</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-nav"><span class="ckb-view-nav-item ckb-view-nav-active" data-name="tips">�������</span><span class="ckb-view-nav-item" data-name="edus">��ҩ����</span></div><div class="ckb-view-main" id="ckbid-main1"></div><div id ="control" class="ckb-view-control"><label>ǿ����ˣ�</label><label><input class="ckb-view-control-checkbox" type="checkbox" id="reviewWarnY" name="reviewWarn" value="Y">��</label></td><td><label><input class="ckb-view-control-checkbox" type="checkbox" id="reviewWarnN" name="reviewWarn" value="N" >��</label></div><div class="ckb-view-main" id="ckbid-main2" style="display: none"></div></div>',
		 main : '<div id="ckb_view_win" class="ckb-view-container" onselectstart="return false"><div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>��ȫ��ҩ���ܾ���ϵͳ</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div><div class="ckb-view-body"><div class="ckb-view-main" id="ckbid-main1"></div><div id ="control" class="ckb-view-control"><span id="bt_return" class="btn-style btn-return">�����޸�</span><span href="#" id="bt_audit" class="btn-style btn-audit">ǿ�����</span></div><div class="ckb-view-main" id="ckbid-main2" style="display: none"></div></div>',
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
				refres:'',
				eduItem:'<% for( var m = 0; m < items.length; m ++ ) { %> '+
						'<% var item = items[ m ]; %>'+
							'<div class="ckb-view-body-item" data-id="WL<%-item.unique %>">'+
								'<div class="ckb-view-item-head">'+
//									'<div class="ckb-view-item-warn-light">'+
//								  		'<img src="../scripts/dhcnewpro/dhcckb/images/forbid-16.png" border=0/>'+
//							  		'</div>'+
//									'<div class="ckb-view-item-xh"><label><%-(i+1)%></label></div>'+
									'<div class="ckb-view-item-education"><label>��ҩ����</label></div>'+
//									'<div class="ckb-view-item-foot" style="display:none">'+
//										'<label class="ckb-view-item-more" data-id="WL<%-item.unique %>">��ϸ��Ϣ[+]</label>'+
//									'</div>'+				
								'</div>'+	// head ����
								'<div class="ckb-view-item-body">'+	
									'<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ];%>'+
										'<% for (var k = 0; k < warn.itms.length; k++) { %> <% var rule =warn.itms[k]; %>'+	// ����
											'<% if (rule.val != "") {%>'+
												'<div class="ckb-view-item">'+
													//'<div class="ckb-view-item-tips"><label><%-warn.keyname%></label></div>'+	// Ŀ¼����														
													'<div class="ckb-view-item-edu"><label><%-rule.val%></label></div>'+	 // ��������
												 '</div>'+
											'<% } %>'+
										'<% } %>'+
								   '<% } %>'+
								 '</div>'+	// body ����
							'</div>'+		// itm����
						'<% } %>',
				monTemp:''
			},
			warnWin : '<div class="ckb_warn_win">'+
							 '<ul class="warn_ul">'+
							 	'<li class="warn_li"><div id="warn" class="icon-warn-default icon-warn-red"></div></li>'+
							 	'<li class="warn_li"><div id="forbid" class="icon-warn-default icon-warn-black"></div></li>'+
							 	//'<li class="warn_li"><div id="normal" class="icon-warn-default icon-warn-green"></div></li>'+
							 	'<li class="warn_li"><div id="tips" class="icon-warn-default icon-warn-yellow"></div></li>'+
							 	'<li class="warn_li"><div id="info" class="warn-log warn-info">��־</div></li>'+
							 '</ul>'+
							 '<div class="ckb-warn-icon"><a class="ckb-warn-close" href="javascript:void(0)"></a></div>'+
						  '</div>',
			reasonWin : '<div id="view-reason" class="view-reason">'+
						'	<div id="ckb_view_bar" class="ckb-view-head"><div class="ckb-view-head-logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>˫ǩ����</label><div class="ckb-view-head-tools"><a class="ckb-view-tool-close" href="javascript:void(0)"></a></div></div>'+
						'   <div class="view-reason-body">'+
						'		<p style="margin-top:10px;"><label style="font-weight:bold;">����д��ҩ���ɣ�</label></p>'+
						'		<div class="realist" style="height:140px;padding:6px;"><p><input type="checkbox" name="reagrp" value="����������⣬��Ҫ������" /><label>����������⣬��Ҫ������</label></p><p><input type="checkbox" name="reagrp" value="���ظ���ҩ��Ӵ����" /><label>���ظ���ҩ��Ӵ����</label></p><p><input type="checkbox" name="reagrp" value="����ǿ��Ҫ��" /><label>����ǿ��Ҫ��</label></p><p><input type="checkbox" name="reagrp" value="���˲�����Ҫ" /><label>���˲�����Ҫ</label></p><p><input type="checkbox" name="reagrp" value="����" /><label>����</label></p></div>'+
						'		<div style="height:100px;padding:6px;"><textarea id="reason" style="width:260px;height:100px;resize:none;" required></textarea></div>'+
						'	</div>'+
						'   <div class="view-reason-foot"><span id="bt_doublesign" class="btn-style btn-sign">˫ǩ����</span></div>'+
						'</div>'
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
				
				me.re_vreason(); // ˫ǩ���� λ��
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
			$(".ckb-view-container .ckb-view-tool-close").bind('click',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
				$(".ckb_warn_win").remove();
				$(".view-reason").remove();   /// ɾ��˫ǩ���˵���
			});
			
			/// ����
			$("#ckb_view_win").on('click','.ckb-view-item-more',function(){
				var _vid = $(this).closest(".ckb-view-body-item").attr("data-id");
				if ($(".ckb-view-detail[data-id='"+ _vid +"']").is(':hidden')){
					$(".ckb-view-detail[data-id='"+ _vid +"']").show();
					//$(this).text("��ϸ��Ϣ[-]");
				}else{
					$(".ckb-view-detail[data-id='"+ _vid +"']").hide();
					//$(this).text("��ϸ��Ϣ[+]");
				}
			});
			
			/// �Ƽ���ҩ
			$("#ckb_view_win").on('click','.item-recmedical',function(){
				// �˴�����ɾ��������Ϊϵͳ����
				var recmedical = $(this).closest(".ckb-view-body-item").attr("data-recmedical");
				if (recmedical == "") return;
				var recmedicalArr = recmedical.split(",");
				var htmlstr = "";
				for(var m=0; m<recmedicalArr.length; m++){
					htmlstr = htmlstr + "<p>"+ recmedicalArr[m] +"</p>";
				}
				$("#win .recmedical").html(htmlstr);
				
				$('#win').window({
					title:'�Ƽ���ҩ',
					iconCls:'icon-w-paper',
				    width:600,
				    height:300,
				    modal:true,
				    collapsible : false,
					minimizable : false,
					maximizable : false
				});
				
			});
			
			/// ��ҩ����
			$("#ckb_view_win").on('click','.item-edu',function(){
				var _vid = $(this).closest(".ckb-view-body-item").attr("data-id");
				if ($(".ckb-view-education[data-id='"+ _vid +"']").is(':hidden')){
					$(".ckb-view-education[data-id='"+ _vid +"']").show();
					//$(this).text("��ϸ��Ϣ[-]");
					me.updateEdus();
				}else{
					$(".ckb-view-education[data-id='"+ _vid +"']").hide();
					//$(this).text("��ϸ��Ϣ[+]");
				}
			});
			
			/// ˵����
			$("#ckb_view_win").on('click','.item-link-intoducation',function(){
				var _vid = $(this).closest(".ckb-view-detail").attr("data-itmid");
				window.open('dhcckb.wiki.csp?IncId='+ _vid);
			});
			
						
			/// �ο�����
			$("#ckb_view_win").on('click','.item-link-literature',function(){
				var _vid = $(this).closest(".ckb-view-detail").attr("data-itmid");
				window.open('dhcckb.reference.csp?IncId='+ _vid);
			});
			
			/// ���Ƶ��¼�
			$(".warn-light").on('click','img',function(){
				$(".ckb-view-body-item[data-id='"+ this.id +"']").show().siblings().hide(); /// ��Ŀ����
				me.showPanel();
			})
			
			/// ��ѡ���¼�
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

				typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// �ص�����
			});
			
			/// ���Ƶ��¼� 2020-09-30 bianshuai
			$(".warn-info").bind('click',function(){
				//alert("��ʾ�Ƶ���¼�������ǰ������ǣ�"+ this.id);
				var link = "dhcckb.problemscenter.csp";
				window.open(link,"_blank","height="+ (window.screen.availHeight - 150) +", width="+ (window.screen.availWidth - 150) +", top=50, left=50,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
				event.stopPropagation();
			})
			
			/// ��С���¼�
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
				
			/// ǿ�����
			$("#bt_audit").bind('click',function(){
				$(".view-reason").css({'display':'block'});
			})
			
			/// �����޸�
			//$("#bt_return").bind('click',function(){
			$(".ckb-view-control").on('click','#bt_return',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
				$(".ckb_warn_win").remove();
				$(".view-reason").remove();   /// ɾ��˫ǩ���˵���
			})
			
			/// �ر��¼�
			$(".view-reason .ckb-view-tool-close").bind('click',function(){
				$(".view-reason").css({'display':'none'});
			});
						
			/// ˫ǩ����
			$("#bt_doublesign").bind('click',function(){
				$(".view-reason").css({'display':'none'});
				$.messager.alert('��ʾ','���˳ɹ���','info');
			});
			
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
	        
	        var VR_El = document.getElementById("view-reason"); /// ��ȡdiv�����
	        VR_El.style.top = (Height - El_Height)/2+"px";
	        VR_El.style.left = ((Width - El_Width)/2 + El_Width + 3) +"px";
	        
	        $(".ckb_warn_win").css("left",(Width/2-135)+"px"); /// ��ʾ�����¶�λ 2020-09-30 bianshuai
		},
		re_vreason : function() {
			
			/// �����������¶�λ
			var El = document.getElementById("ckb_view_win");   /// ��ȡdiv�����
	        var VR_El = document.getElementById("view-reason"); /// ��ȡdiv�����
	        var El_Width = El.offsetWidth;   /// ��ȡdiv��Ŀ��ֵ
	        VR_El.style.top = El.style.top;
	        VR_El.style.left = (parseInt(El.style.left) + El_Width + 3) +"px";
	        
		},
		bin_data : {},
		init : function() {
			this.initMain();
		},
		initMain : function() {
			var me = this;
			$(".ckb-view-container").remove(); /// ɾ�����
			$(".ckb_warn_win").remove(); /// ɾ�����
			this.container.append( template( this.templates.main ) );
			if ($(".ckb_warn_win").length == 0){
				this.container.append( template( this.templates.warnWin ) );  /// ��ʼ����ʾ�� 2020-09-30 bianshuai
			}
			if (me.WinType == "OPENWIN"){
				$(".ckb-view-tool-close").remove(); /// �Ƴ��رհ�ť
			}
			if ($(".view-reason").length == 0){
				this.container.append( template( this.templates.reasonWin ) ); /// ǿ���������
			}
			this.relocation(); /// ���¶�λ
			$(".ckb-view-container").hide();
			$(".ckb_warn_win").hide(); 
			// �л�����������ǩ
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
            me.init_Temp();	// ��ʼ��ģ�� bianshuai 2021-01-04
		},
		init_Temp : function() {
			
			/// ��ʼ��ģ��  bianshuai 2021-01-04
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
			
			/// ��ʼ��ģ��  bianshuai 2021-01-04
			var tempHtml = jsonObj.Html;
			var tempHeadHtml = getFormatHtml(tempHtml, "monHead"); /// �����Ŀ
			var tempbodyHtml = getFormatHtml(tempHtml, "monBody"); /// �����Ŀ¼
			var tempBaseHtml = getFormatHtml(tempHtml, "monBase"); /// ������Ϣ
		  
		    var tempHtml = "";
				tempHtml = tempHtml + '<% for( var i = 0; i < items.length; i ++ ) { %> <% var item = items[ i ]; var base = item.tips[0];%>';
				tempHtml = tempHtml + '<div class="ckb-view-body-item" data-id="WL<%-item.unique %>" data-recmedical="<%-item.adviceDrug %>">';
				tempHtml = tempHtml + '   <div class="ckb-view-item-head">';
				tempHtml = tempHtml +         tempHeadHtml;
				tempHtml = tempHtml + '   </div>';	// head ����
				tempHtml = tempHtml + '   <div class="ckb-view-item-body">';	// warns��Ŀ¼����
				tempHtml = tempHtml + '   	<% for( var j = 0; j < item.warns.length; j ++ ) { %> <% var warn = item.warns[ j ]; var itemCss = j==item.warns.length-1?"":"ckb-view-item-bottom-line";%>';
				tempHtml = tempHtml + '   		<% for (var k = 0; k < warn.itms.length; k++) { %> <% var rule =warn.itms[k]; var ruleCss = k==warn.itms.length-1?"":"ckb-view-item-bottom-line"; %>';	// ����
				tempHtml = tempHtml + '   		    <% var ruleColorCss = "warn-cololr-normal"; if (rule.manLevel == "remind") ruleColorCss = "remind-color";if(rule.manLevel == "forbid") ruleColorCss = "forbid-color"; if(rule.manLevel == "warn") ruleColorCss = "warn-color"; if( rule.manLevel == "tips") ruleColorCss = "tips-color"; if( rule.manLevel == "normal") ruleColorCss = "normal-color"; %>';	
				tempHtml = tempHtml + '   			<% var ruleSource = ""; if ( rule.source != "")  ruleSource="�ο����ݣ�"+rule.source; %>';
				
				tempHtml = tempHtml + '  			<div class="item-group">';  // ��
				tempHtml = tempHtml + '   				<% for (var m = 0; m<rule.itms.length; m++){ var val = rule.itms[m].val;%>';
				tempHtml = tempHtml + '  			    	<div class="item-group-rows">';  // ��
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
				tempHtml = tempHtml + '</div>';	// detail����
				
				
				tempHtml = tempHtml + '<div id="ckbid-main2" class="ckb-view-education" data-id="WL<%-item.unique %>">';
				//tempHtml = tempHtml +     tempBaseHtml;
				tempHtml = tempHtml + '</div>';	// ��ҩ��������
				
				
				tempHtml = tempHtml + '<div class="ckb-view-docnotes" data-id="WL<%-item.unique %>">';
				tempHtml = tempHtml + '	   <div class="view-notelists">';
				tempHtml = tempHtml + '	   		<label>ҽ����ע��</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="�ٴ�ָ��" /><label>�ٴ�ָ��</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="CFDA�����Ӧ֢" /><label>CFDA�����Ӧ֢</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="�±�ҩ��ѧ" /><label>�±�ҩ��ѧ</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="������" /><label>������</label>';
				tempHtml = tempHtml + '	  		<input type="checkbox" name="reagrp" value="ҩƷ˵����" /><label>ҩƷ˵����</label>';
				tempHtml = tempHtml + '	   		<input type="checkbox" name="reagrp" value="otherVal" /><label>����</label>';
				tempHtml = tempHtml + '    </div>';
				tempHtml = tempHtml + '    <div style="margin-top:5px;"><textarea id="reason" style="width:560px;height:30px;resize:none;margin-left:88px;" required></textarea></div>';
				tempHtml = tempHtml + '</div>';	// detail����
				
				tempHtml = tempHtml + '<% } %>';
		    return tempHtml;
		} ,
		turnLight : function( data ) {
			
			/// ����ҩƷ�������
			if (typeof data.items == "undefined") return;
			var unique = data.unique;
			var WarnLight = data.manLevel;
			$("#WL" + unique).attr("src","../scripts/dhcnewpro/dhcckb/images/"+ WarnLight +".png");
			
			$(".warn_li div:not(.warn-log)").addClass("icon-warn-default");     /// ��ʼ����ʾ�� 2020-09-30 bianshuai
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
			/// �˴���Ϊ��Ӧ����ʾ��������ɾ��
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
						me.turnLight(data);  /// ��ʾ�ƿ���
						$(".ckb-view-container").show();
					}else{
						main.append( template( templates.view[ "item" ], data ) );
						me.turnLight(data);  /// ��ʾ�ƿ���
					}
					*/
					//main.append( template( templates.view[ "item" ], data ) );
					main.append( template( templates.view[ "monTemp" ], data ) );
					
					me.formatTemp();     // ��ʽ�����ģ��
					
					me.turnLight(data);  /// ��ʾ�ƿ���
					switch (me.EffFlag){
						case 0:	// ֻ����ʾ��			
						$(".ckb_warn_win").show(); 	
						$(".ckb-view-container").hide();					
						break;
						case 1:	// ������ϸ
						$(".ckb-view-container").show();
						$(".ckb_warn_win").remove(); 
						break;
						case 3:	// ��ʾ�ƺ���ϸ����
						$(".ckb-view-container").show();
						$(".ckb_warn_win").show(); 
						break;
						case 2:	// ������						
						default:	// ������
						$(".ckb_warn_win").remove(); 
						$(".ckb-view-container").hide();						
						break;
					}
					me.passFlag = data.passFlag ;   /// �����ͨ��״̬				
					me.manLevel = data.manLev ;     /// ��˽����ʾ����
					me.MsgID = data.MsgID;
					me.Msg = data.items;
					//typeof me.checkFn === "function" ? me.checkFn( data.passFlag, data.manLev ) : ""; 	/// �ص�����
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
			
			// ����action(�¼��ַ�����) bianshuai 2021-01-04
			runClassMethod("web.DHCCKBService" ,"AcitonProxy", {"jsParamObj" : JSON.stringify(data), "MsgID" : data.MsgID||"", "action" : action||"Pass"},function(jsonObject){
					/*if(jsonObject.passFlag==1){					//sufan 2020-09-11 ��ʱ������
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
			this.EffFlag = EffFlag;    /// չʾЧ��
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
			close:function(){	// �ر��¼�
			$(".ckb-view-container").remove();
		},
		feedBack : function(fn,msgID, user, date, time, ordItemStr, userType) {			 // 2020/12/1 ���������ӿ�
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
