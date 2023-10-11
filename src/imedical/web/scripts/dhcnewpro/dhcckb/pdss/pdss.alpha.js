/*
 * @Author: qunianpeng
 * @Date: 2022-08-29 14:17:23
 * @Descripttion: ��ȫ��ҩ���ܾ���ϵͳ���
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-09-02 14:30:48
 */
(function (window) {

	// ��������������ű�������win10����Ϊ125%���������Ҫ����0.8��,���ܱ���ԭ����ʾ��С
	function setRatio(){
    
	    var defaultRatio = 1; //Ĭ�����ű�
	    var ratio=0;
	    var screen=window.screen;
	    var ua=navigator.userAgent.toLowerCase();
	 
	    if(window.devicePixelRatio !== undefined)
	    {
	        ratio=window.devicePixelRatio;    
	    }
	    else if(~ua.indexOf('msie'))
	    {
	        if(screen.deviceXDPI && screen.logicalXDPI)
	        {
	            ratio=screen.deviceXDPI/screen.logicalXDPI;        
	        }
	    
	    }
	    else if(window.outerWidth !== undefined && window.innerWidth !== undefined)
	    {
	        ratio=window.outerWidth/window.innerWidth;
	    }
	 
	    if(ratio > 1){
	        
	        //var setZoom = defaultRatio/window.devicePixelRatio; //Ĭ��zoom
	        //document.body.style.zoom = setZoom.toFixed(6);
	        var setZoom = defaultRatio/window.devicePixelRatio; //Ĭ��zoom
	        ratio = setZoom.toFixed(6);
	    }
	    return ratio;
	}
	
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
		this.manLev = "";
		this.controlFlag = "N"		/// ǿ����˱�־(Ĭ��ΪN)
		this.MsgID = "";			/// ��Ϣ���id
		this.Msg = "";				/// ��Ϣjson	
		this.reason = [];			// ����ԭ��
		this.drugUniqueStr = ""; 	// ҩƷΨһ��ʶ��
		this.checkFlag = "Y";		// �鿴����˱��
		this.config = {};			// �������:����˼���,����ʱ��,��ʾλ�õ�			
		this.ratio = 1;	
        this.init( options );
    };
    
    PDSS.prototype = {
		constructor : PDSS,
		templates : {
            main: '<div id="ckb_view_win" class="ckb_view_container" onselectstart="return false">'+
                    '<div id="ckb_view_bar" class= "ckb_view_head" >'+
                        '<div class= "ckb_view_head_logo" ><img id="ckb_logoid" src="../scripts/dhcnewpro/dhcckb/pdss/images/plu-tips.png" alt=""></div>'+
                        '<div class= "ckb_view_head_title" > <label>��ȫ��ҩ���ܾ���ϵͳ</label></div>'+ 
                        '<div class= "ckb_view_head_tools" >'+
                            '<a class= "ckb_view_tool_refresh" href="javascript:void(0)" ></a>' +
                            '<a class="ckb_view_tool_small" href="javascript:void(0)"></a>'+
                            '<a class= "ckb_view_tool_big" href="javascript:void(0)"></a>'+
                            '<a class= "ckb_view_tool_down" href="javascript:void(0)" ></a>' + 
                        '</div>'+
                    '</div >' +
                    '<div id="ckb_view_bodyid" class="ckb_view_body"></div>' +
                    '<div id="control" class="ckb_view_control"><span id="bt_return" class="btn_style btn_return">�����޸�</span><span href="#" id="bt_audit" class="btn_style btn_audit">ǿ�����</span></div>' +
                 '</div > ',
            view: {
                item:'',
                refres:'',
                eduItem:'',
                monTemp:''
            },
			warnWin: '<div id="ckb_warn_win" class="ckb_warn_win">' +				
						'<div class="ckb_warn_bg"></div>'+
						'<div class="ckb_warn_pull"></div>'+
						'<div class="ckb_warn_logo">'+
							'<img src="../scripts/dhcnewpro/dhcckb/pdss/images/plu-default.png" alt="" />'+
						'</div>'+
		  			'</div>',                               
            reasonWin : '<div id="view_reason" class="view_reason">'+
                        '	<div id="ckb_view_bar" class="ckb-view-head"><div class="ckb_view_head_logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>˫ǩ����</label><div class="ckb-view-head-tools"><a class="ckb_view_tool_close" href="javascript:void(0)"></a></div></div>'+
                        '   <div class="view_reason_body">'+
                        '		<p style="margin-top:10px;"><label style="font-weight:bold;">����д��ҩ���ɣ�</label></p>'+
                        '		<div class="realist" style="height:140px;padding:6px;"><p><input type="checkbox" name="reagrp" value="����������⣬��Ҫ������" /><label>����������⣬��Ҫ������</label></p><p><input type="checkbox" name="reagrp" value="���ظ���ҩ��Ӵ����" /><label>���ظ���ҩ��Ӵ����</label></p><p><input type="checkbox" name="reagrp" value="����ǿ��Ҫ��" /><label>����ǿ��Ҫ��</label></p><p><input type="checkbox" name="reagrp" value="���˲�����Ҫ" /><label>���˲�����Ҫ</label></p><p><input type="checkbox" name="reagrp" value="����" /><label>����</label></p></div>'+
                        '		<div style="height:100px;padding:6px;"><textarea id="reason" style="width:260px;height:100px;resize:none;" required></textarea></div>'+
                        '	</div>'+
                        '   <div class="view_reason_foot"><span id="bt_doublesign" class="btn_style btn_sign">˫ǩ����</span></div>'+
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
			document.getElementById("ckb_warn_win").onmousedown = function(e){ 
				getObject(document.getElementById("ckb_warn_win"),e||event);       //box�����¼�������  e-->FF  window.event-->IE
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
				
				//me.re_vreason(); // ˫ǩ���� λ��
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
			$(".ckb_view_container .ckb_view_tool_close").bind('click',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
				$(".ckb_warn_win").remove();
				$(".view-reason").remove();   /// ɾ��˫ǩ���˵���
				if (me.manLev != "forbid"){		// ��ǿ����˴�����һ��,��Ϊ����������Զ���
					typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// �ص�����
				}
			});
			
			/// ����
			$("#ckb_view_win").on('click','.ckb_view_item_more',function(){
				var _vid = $(this).closest(".ckb_view_item").attr("data-id");
				if ($(".ckb_view_item_detail[data-id='"+ _vid +"']").is(':hidden')){
					$(".ckb_view_item_detail[data-id='" + _vid + "']").show();
					$(this).css("background","url(../scripts/dhcnewpro/dhcckb/pdss/images/item_up.png) no-repeat");
					$(this).parent().next().find('.ckb_rulesource').show();
					
				}else{
					$(".ckb_view_item_detail[data-id='" + _vid + "']").hide();
					$(this).css("background","url(../scripts/dhcnewpro/dhcckb/pdss/images/item_more.png) no-repeat");
					$(this).parent().next().find('.ckb_rulesource').hide();					
				}				
			});
			
			/// �Ƽ���ҩ
			$("#ckb_view_win").on('click','.ckb_recmedical',function(){
				$(".ckb_view_item_recmedical").remove();
				var recmedical = $(this).closest(".ckb_view_item").attr("data-recmedical");
				if (recmedical == "") return;
				var recmedicalArr = recmedical.split(",");
				var htmlstr = "";
				for(var m=0; m<recmedicalArr.length; m++){
					htmlstr = htmlstr + "<p>"+ recmedicalArr[m] +"</p>";
				}
				htmlstr = '<div class="ckb_view_item_recmedical"><span>���Ƽ���ҩ��</span>' + htmlstr +'</div>';
				$(".ckb_view_item_detail").append(htmlstr);
				$(".ckb_view_item_more").click();
				// �Ȱ��Ƽ���ҩ��Ϣ����������
				return;
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
			
			/// ˵����
			$("#ckb_view_win").on('click','.ckb_iteminstru',function(){
				//var _vid = $(this).closest(".ckb-view-detail").attr("data-itmid");
				//window.open('dhcckb.wiki.csp?IncId='+ _vid);
			});			
						
			/// �ο�����
			$("#ckb_view_win").on('click','.item_link_literature',function(){
				// var _vid = $(this).closest(".item_link_literature").attr("data-itmid");
				// window.open('dhcckb.reference.csp?IncId='+ _vid);
			});	
			
			/// �Ŵ��¼�
			$(".ckb_view_tool_big").bind('click', function () {
				var newratio = $("#ckb_view_win").css("zoom")||1;
				newratio = parseFloat(newratio) + 0.1;			
				if (newratio.toFixed(6)<1.5){
					$("#ckb_view_win").css("zoom",newratio);
					me.relocation();
				}			
			});		
			
			/// ��С�¼�
			$(".ckb_view_tool_small").bind('click', function () {				
				var newratio = $("#ckb_view_win").css("zoom")||1;
				newratio = parseFloat(newratio) - 0.1;
				if (newratio.toFixed(6)>0.5){
					$("#ckb_view_win").css("zoom",newratio);
					me.relocation();
				}				
			});
			
			/// �����¼�
			$(".ckb_view_tool_refresh").bind('click', function () {
				$("#ckb_view_win").css("zoom",me.ratio||1);
				me.relocation();
			});
			
			/// �����¼�
			$(".ckb_view_tool_down").bind('click', function () {
				me.showModel(0);
				event.stopPropagation();
			});
			
			/// ��ʾ�Ƶ���¼�
			$(".ckb_warn_win .ckb_warn_pull").bind('click',function(){
				me.showModel(1);
				event.stopPropagation();
			});
			
			
			/// ǿ�����
			$("#bt_audit").bind('click',function(){
				me.controlFlag = "Y";
				me.passFlag = 1;

				var reasonArr = [];											
				$("textarea[name='ckb_reason']").each(function() {
					var reasonObj={};
				    //if ($(this).val().trim() != '') {
					   reasonObj.item = $(this).attr("data-item");
					   reasonObj.seqno = $(this).attr("data-seqno");
					   reasonObj.manlevel = $(this).attr("data-manlevel");
					   reasonObj.unique = $(this).attr("data-unique");
				       reasonObj.val = $(this).val();
				    //}
				    var selectReason = "";
				    var $label = "#WL"+$(this).attr("data-unique");
				    $($label+" :checkbox:checked").each(function(){
					     if ($(this).val() != ""){
						 	selectReason = (selectReason == "")?$(this).val():selectReason+"!!"+$(this).val();	
						 } 
					});

					if (selectReason != ""){
						reasonObj.selectReason = selectReason;
						reasonObj.reagrpId = $label;
					}	
					if (!$.isEmptyObject(reasonObj)){
						reasonArr.push(reasonObj);
					}					
				})		
				me.reason = reasonArr;
				/*for (i=0;i<reasonArr.length;i++){
					if((reasonArr[i].manlevel=="forbid")&&(reasonArr[i].val=="")){				 
					me.controlFlag = "N";
					$.messager.alert('��ʾ','ҽ����ע����Ϊ��');	
					return;	
					}   // ǿ�����ʱ��ֹ������Ҫд��ע��Ϣ 2022-03-04
				}*/		
				$(".ckb-view-container").remove();			
				$(".ckb_warn_win").remove();
				me.feedBack("", me.MsgID||"", reasonArr,me.drugUniqueStr||"");	// ǿ�����ʱ,�޸ĺ�̨������
				typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// �ص�����
			})
			
			/// �����޸�		
			$(".ckb_view_control").on('click', '#bt_return', function () {
				$(".ckb_view_container").remove();			
				$(".ckb_warn_win").remove();
				$(".view_reason").remove();   /// ɾ��˫ǩ���˵���
				typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// �ص�����
			})
			
			/// ��������¼�
			$('#ckb_view_win').mouseover(function (e) {
				if (me.passFlag != 0){
			       $("#ckb_view_win").stop(true, false)
				}
			});
			    
			/// ����Ƴ��¼�
		    $('#ckb_view_win').mouseout(function () {
			    if (me.passFlag == 1){
					$('#ckb_view_win').delay(2500).hide(0);
				}		        
		    });
			
		},
		relocation : function() {			
			/// �����������¶�λ			
	        var Height = document.documentElement.clientHeight; /// ȡ�������ҳ���������Ŀ��
	        var Width = document.documentElement.clientWidth;   /// ȡ�������ҳ���������Ŀ��	        
	       	//(winϵͳ���õķŴ󣬻���������ķŴ����С����Ӱ������������ش�С(��������/body�Ĵ�С), ����win10���������������ʾ125%,��1920*1080��body���� clientWidth��clientHeight1528*724(����ʾ�����ر�����)
	        // ������Ļʵ�ʵ����ز���仯�����磺ͨ��clientWidth��ȡ��ֵΪ1500,������Ļʵ��Ϊ1920,�ᵼ�º���������Ĳ������Ŵ����С����Ӱ���Ԫ�����õĴ�С
	       	Width = Width/(this.ratio||1);					/// ����������Ŵ����С��,��������ӱ仯ǰ��ʵ�ʿ�Ⱥ͸�(��������ʵ�ʸ߶ȣ�������div���õ�λ�û�����������ı仯���仯)
	        Height = Height/(this.ratio||1);  
	         
	   		var El = document.getElementById("ckb_view_win"); /// ��ȡdiv�����
	        var El_Height = El.offsetHeight; 				/// ��ȡdiv��ĸ߶�ֵ
	        var El_Width = El.offsetWidth;   				/// ��ȡdiv��Ŀ��ֵ	        
	 		
	 		var top = "35px";
	 		var bottom = Height-El_Height +"px";
	 		var left = "10px";
	 		var right = Width - El_Width -20 +"px";	
	 		var xcenter = Width/2 - El_Width/2 +"px";	 		
	 		/*
	 		if (this.config.pluPosition||"" != ""){
		        var position = this.config.pluPosition;
		        // // ֻ��һ����λ��,������x��
		        if (position.indexOf("-") == -1){
			        El.style.top = top;
			        El.style.left = (position=="left")?left:(position=="center")?xcenter:(position=="right")?right:xcenter;
			    }else{
					if (position.indexOf("top") !=- 1){ //
			    		El.style.top = top;			    		
				    }
				    if (position.indexOf("bottom") != -1){
				    	El.style.top = bottom;
				    }
				    if (position.indexOf("left") != -1){
				    	El.style.left = left;	
				    }
				    if (position.indexOf("right") != -1){
				    	El.style.left = right;	
				    } 				    			
				}           
		        
	        }else{
		        // Ĭ������
		    	El.style.top = "35px";	
	       		El.style.left = Width/2 - El_Width/2 +"px";
		    }
		    */
	        /// ��ʾ�����¶�λ
	      	var El_Warn = document.getElementById("ckb_warn_win"); /// ��ȡdiv�����	      
	        var El_WarnWidth = El_Warn.offsetWidth;  
	        El_Warn.style.left =  Width/2 - El_WarnWidth/2 +"px";	
	        El_Warn.style.top = "35px";		        
	        
	        // ֻҪ��top bottom left right
	   		// ���Ͻ� left top
	        //El.style.top = "35px"; 	/// �����������α仯���ɱ�֤Ԫ���ڿ��������ڵ�λ�ò���
	       	//El.style.left = "10px";	
	       	// ����   top center
	       	El.style.top = "35px";	
	       	El.style.left = Width/2 - El_Width/2 +"px";
	        // ���Ͻ� right top
	        //El.style.top = "35px";	
	        //El.style.left = Width - El_Width -20 +"px";		
	        // ����  left center
	        //El.style.top = Height/2 - El_Height/2 +"px";	
	        //El.style.left = "10px";		
	        // ���� center center
	        //El.style.top = Height/2 - El_Height/2 +"px";	
	        //El.style.left = Width/2 - El_Width/2 +"px";
	        // ���� right center
	        //El.style.top = Height/2 - El_Height/2 +"px";	
	        //El.style.left = Width - El_Width -20 +"px";	
	        // ���� left bottom
	        //El.style.top = Height-El_Height +"px";	
	        //El.style.left = "10px";
	        // ���� center bottom
	        //El.style.top = Height-El_Height +"px";
	        //El.style.left = Width/2 - El_Width/2 +"px";
	        //���� right bottom
	        //El.style.top = Height-El_Height +"px";
	        //El.style.left = Width - El_Width -20 +"px";	      				      
	      
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
			this.ratio = setRatio();
			var me = this;
			$(".ckb_view_container").remove(); 	/// ɾ����Ϣ���
			$(".ckb_warn_win").remove(); 		/// ɾ����ʾ��ͼ��
			this.container.append( template( this.templates.main ) );
			if ($(".ckb_warn_win").length == 0){
				this.container.append( template( this.templates.warnWin ) );  /// ��ʼ����ʾ��
			}		
            if ($(".view_reason").length == 0) {	// ˫ǩ����
				// this.container.append( template( this.templates.reasonWin ) ); /// ǿ���������
			}			
			// ��ȡ��������
			this.update( {}, function( data ) {	
				me.config = data;							
				me.relocation(); /// ���¶�λ
			}, "Config")
						
			$(".ckb_view_container").hide();
			$(".ckb_warn_win").hide(); 			
            me.init_Temp();	// ��ʼ��ģ��
		},
		init_Temp : function() {			
			/// ��ʼ��ģ��  
			var me = this;
			templates = me.templates;
            templates.view[ "item" ] = me.patinfo_html() + me.temp_html();
        },        
        patinfo_html: function () {			
            
            var tempHtml = "";    
            tempHtml += '<div class="ckb_view_parent clearfix">';
            tempHtml += '   <div class="ckb_view_parent_left">';
            tempHtml += '       <% var seximg = (patInfo.patSex=="��")?"pat_male.png":"pat_female.png"; %>';
            tempHtml += '       <img src="../scripts/dhcnewpro/dhcckb/pdss/images/<%-seximg %>" alt="" />';
            tempHtml += '       <div class="ckb_patname nowrap"><%-patInfo.patName %></div>';
            tempHtml += '   </div>';
            tempHtml += '   <div class="ckb_view_parent_right">';
            tempHtml += '       <% var patmsg =patInfo.patSex + "  /" + patInfo.patAge + "  /"; %>';
            tempHtml += '       <% if(patInfo.patHeight != "") patmsg += patInfo.patHeight + "  /"; %>';
            tempHtml += '       <% if(patInfo.patWeight != "") patmsg += patInfo.patWeight + "  /"; %>';  
            tempHtml += '       <%patmsg += "����ҽ��  "+ patInfo.mainDoc + "  /"; %>';  
            tempHtml += '       <%patmsg += patInfo.patLoc + "  /"; %>';  
            tempHtml += '       <% if(patInfo.billType != "") patmsg += patInfo.billType + "  /"; %>';  
            tempHtml += '       <div class="pat_info nowrap"><%-patmsg %></div>';
            tempHtml += '       <div class="pat_spec nowrap">';
            tempHtml += '           <% for( var i = 0; i < patInfo.specialPop.length; i ++ ) { %>';
            tempHtml += '               <span><%-patInfo.specialPop[i] %></span>'
            tempHtml += '           <%} %>'
            tempHtml += '       </div>'      
            tempHtml += '       <div class="pat_diag nowrap"><%-patInfo.diag %></div>';
            tempHtml += '    </div>';
            tempHtml += '</div>'; 
            
         
		    return tempHtml;
        },        
		temp_html: function () {			
			
			// ҽ����עѡ��
			//this.config.notelists = ['�ٴ�ָ��', 'ҩƷ˵����'];
			var notelists = this.config.notelists||[];
			
			var notehtml = "";					
			for (var index = 0; index < notelists.length; index++) {
				notehtml += '<label><input type="checkbox" name="reagrp" value="'+notelists[index]+'">'+notelists[index]+'</label>';
			}
			if (notehtml != '') {
				notehtml = '<div class="view_notesitem">' + notehtml + '</div>';
				notehtml = '<div class="view_notelists"><span>ҽ����ע��</span>'+notehtml+'</div>';
			}

            var tempHtml = "";    
            tempHtml += '<div class="ckb_view_main" id="ckbid_main">';
            tempHtml +=     '<% for( var i = 0; i < items.length; i ++ ) { %> <% var item = items[ i ]; %>';
            //------------------------------------ckb_view_item-start-----------------------------            
            tempHtml +=         '<div class="ckb_view_item" data-id="WL<%-item.unique %>" data-recmedical="<%-item.adviceDrug %>">';
            //////////////////////////////item_cont��ʼ//////////////////////////////////////////    
            tempHtml +=             '<div class="ckb_view_item_cont">'; 
            tempHtml +=                 '<div class="ckb_view_item_head clearfix">';
            tempHtml +=                     '<div class="ckb_row">'; 
            tempHtml +=                     '<% var level =  ((item.manLevel =="normal")||(item.manLevel =="")||(item.manLevel ==undefined))?"ckb_itemtips":"ckb_item" + item.manLevel;  %>';            
            tempHtml +=                         '<span class="ckb_itemlevel <%-level %>"></span>';
            tempHtml +=                         '<span class="ckb_itemvalue" data-id="<%-item.itmID %>" data-name="<%-item.item %>"><%-item.item %></span>';
            //tempHtml +=                         '<span class="ckb_iteminstru" onclick=\"window.open(\'dhcckb.wiki.csp?IncId=<%-item.itmID %>\')\"></span>';
            tempHtml +=                         '<span class="ckb_iteminstru" onclick=\"window.open(\'dhcckb.pdss.instruction.csp?IncId=<%-item.itmID %>\')\"></span>';
            tempHtml +=                         '<% if(item.adviceDrug != "") { %><span class="ckb_recmedical"></span> <% } %>';
            tempHtml +=                         '<span class="ckb_itemuse"><%-item.tips[0].DrugPreMet %>&nbsp;&nbsp;<%-item.tips[0].OnceDose==0?"":item.tips[0].OnceDose %>&nbsp;&nbsp;<%-item.tips[0].DrugFreq %></span>';
            tempHtml +=                     '</div>'; 
            tempHtml +=                     '<div class="ckb_view_item_more"></div>';           
            tempHtml +=                 '</div>';  
            ////////////////////////////item_head����
            tempHtml +=                 '<div class="ckb_view_item_body">';
            tempHtml +=                     '<% var warnsArr = item.warns; %><% for( var j = 0; j < warnsArr.length; j++ ) { %> <% var warn = warnsArr[ j ]; %>';
            tempHtml +=                         '<% var libarylevel = (warn.manLevel=="normal")||(warn.manLevel=="")||(warn.manLevel=="undefined")?"tips_color":warn.manLevel+"_color" %>';
            tempHtml +=                         '<% var libtxtlevel = (warn.manLevel=="normal")||(warn.manLevel=="")||(warn.manLevel=="undefined")?"tips_txtcolor":warn.manLevel+"_txtcolor" %>';            
            tempHtml +=                         '<div class="item_group">';
            tempHtml +=                         '<% for( var k = 0; k < warn.itms.length; k++ ) { %><% var rule = warn.itms[k] %>';
            tempHtml +=                             '<% var rulelevel= (rule.manLevel=="normal")||(rule.manLevel=="")||(rule.manLevel=="undefined")?"tips_color":rule.manLevel+"_color" %>';            
            tempHtml +=                             '<% for( var m = 0; m < rule.itms.length; m++ ) { %><% var itmcase = rule.itms[m] %>';
            tempHtml +=                                 '<% var caselevel = (itmcase.manLevel=="normal")||(itmcase.manLevel=="")||(itmcase.manLevel=="undefined")?"tips_color":itmcase.manLevel+"_color" %>';            
            tempHtml +=                                 '<div class="ckb_text_row">';            
            tempHtml +=                                 '<% if(m == 0) { %>';
            tempHtml +=                                      '<span class="item_levelstyle item_lineleft <%-libarylevel %>"></span>';
            tempHtml +=                                      '<span class="item_leveltext text_18left <%-libtxtlevel %>"><%-warn.manLev %></span>';
            tempHtml +=                                      '<span class="item_libary text_18left"><%-warn.keyname %></span>';
            tempHtml +=                                      '<span class="item_levelstyle text_18left <%-caselevel %>"></span>'; // ��Ŀ��������Ҫ����
            tempHtml +=                                      '<span class="item_msg"><%-itmcase.val %></span>';
            tempHtml +=                                 '<% } else { %>';         
            tempHtml +=                                      '<span class="item_levelstyle item_lineleft"></span>';
            tempHtml +=                                      '<span class="item_leveltext text_18left"></span>';
            tempHtml +=                                      '<span class="item_libary text_18left"></span>';
            tempHtml +=                                      '<span class="item_levelstyle text_18left <%-caselevel %>"></span>';
            tempHtml +=                                      '<span class="item_msg"><%-itmcase.val %></span>';
            tempHtml +=                                 '<% } %>';  
            tempHtml +=                                 '</div>';
            tempHtml +=                             '<% } %>';    
            tempHtml +=                             '<% if(rule.source != "") { %>';													
			tempHtml +=                             '<div class="ckb_text_row ckb_rulesource">'; 
			tempHtml +=                             	'<span class="item_levelstyle item_lineleft"></span>';
            tempHtml +=                             	'<span class="item_leveltext text_18left"></span>';
            tempHtml +=                             	'<span class="item_libary text_18left"></span>';
            tempHtml +=                             	'<span class="item_levelstyle text_18left%>"></span>';
            tempHtml +=                                 '<span class="item_msg"><span style="color:red">���ο����ݡ�:</span><%-rule.source %></span>';
			tempHtml +=                             '</div>'; 
            tempHtml +=                             '<% } %>';												
            tempHtml +=                         '<% } %>';
            tempHtml +=                         '</div>';
            tempHtml +=                     '<% } %>';            
            tempHtml +=                 '</div>';
            ////////////////////////////item_body����
            tempHtml +=              '</div>';   
            //////////////////////////////item_cont����/////////////////////////////////////////             
            tempHtml +=             '<div class="ckb_view_item_detail" data-id="WL<%-item.unique %>">';
            tempHtml +=             	'<span>����˽����</span><span>����˵�����޶�</span>';
			
			tempHtml += 			'</div>';
            tempHtml +=             '<div class="ckb_view_item_education"></div>';
            //////////////////////////////item_docnotes��ʼ////////////////////////////////////            
            tempHtml +=             '<div class="ckb_view_item_docnotes">';
			tempHtml +=					notehtml;
            // tempHtml +=                 '<div class="view_notelists">';
            // tempHtml +=                     '<span>ҽ����ע��</span>';
            // tempHtml +=                     '<div class="view_notesitem">';
            // tempHtml +=                         '<label><input type="checkbox" name="reagrp" value="�ٴ�ָ��">�ٴ�ָ��</label>'
            // tempHtml +=                     '</div>';
            // tempHtml +=                 '</div>';
            tempHtml +=                 '<div class="view_noteinput">';
            tempHtml +=                     '<textarea name="ckb_reason" id="reason<%-item.unique %>" data-unique="<%-item.unique %>" data-seqno="<%-item.seqno%>" data-item="<%-item.item %>" data-manlevel="<%-item.manLevel %>" required=""></textarea>';
            tempHtml +=                 '</div>';
            tempHtml +=             '</div>';
            ////////////////////////////////////item_docnotes����/////////////////////////////
            tempHtml +=         '</div>';
            //------------------------------------ckb_view_item-end-----------------------------
            tempHtml +=     '<%} %>';
			tempHtml += '</div>';			
		    return tempHtml;
		} ,
		showPanel : function () {
			if ($(".ckb_view_container").is(':hidden')){
				$(".ckb_view_container").show();
			}
		},
		showModel : function (model) {
			switch (model){
				case 0:	// ��ʾ����ͼ��		
					//$(".ckb_warn_win").show(); 	
					//$(".ckb_view_container").hide();	
					$(".ckb_warn_win").fadeIn(); 	
					$(".ckb_view_container").fadeOut();					
					break;
				case 1:	// ��ʾ������ϸ
					//$(".ckb_view_container").show();
					//$(".ckb_warn_win").hide(); 
					$(".ckb_view_container").fadeIn();
					$(".ckb_warn_win").fadeOut();
					break;		
									
				default:	// ������
					$(".ckb_warn_win").remove(); 
					$(".ckb_view_container").remove();						
					break;
			}
		},
		btnControl : function (data) {
						
			if (this.passFlag == 1) {
				$('#bt_audit').unbind("click");	
				// $('#bt_audit').hide();	
				// $(".ckb_view_control").hide();
				$('#ckb_view_win').delay(parseInt(this.config.showtime||5000)).hide(0);	
			}
			if (this.checkFlag == "Y") {
				$("textarea[name='ckb_reason'").attr("disabled",true); 
				$("input[type=checkbox][name='reagrp']").attr("disabled",true); 	
			}			
		},
		updateTips : function() {
			var me = this;
			me.nav_ind = 0;
			me.bin_event();
			templates = me.templates;	        
			var main = $('#ckb_view_bodyid');	
			var me = this;
			//$("#ckb_view_win").css("zoom",this.ratio||1); // ����
			document.getElementById("ckb_view_win").style.zoom = this.ratio||1; // ����
			document.getElementById("ckb_warn_win").style.zoom = this.ratio||1; // ����
			this.update(this.bin_data.data, function (data) {
				
				if (typeof data.ErrorCode == "undefined") {					
					//����logo����
                    var imglogo = (data.manLevel == "normal") || (data.manLevel == "") || (data.manLevel == undefined) ?"plu-tips.png":"plu-"+data.manLevel+".png";
                    $("#ckb_logoid").attr('src','../scripts/dhcnewpro/dhcckb/pdss/images/'+imglogo);
					$(".ckb_warn_logo img").attr('src','../scripts/dhcnewpro/dhcckb/pdss/images/'+imglogo);
										
					// ���ݸ�ֵ
					main.append( template( templates.view[ "item" ], data ) );					
				
					// ��ʾģʽ�Ŀ���
					//me.EffFlag = 0;
					me.showModel(me.EffFlag);						
					
					// ���ݸ�ֵ
					me.passFlag = data.passFlag;   /// �����ͨ��״̬
					// ��ֹ����ҽ���ļ��� �� ��Ҫǿ����˵ļ��� ����ͨ��
					var notalllowLevel = me.config.notallowLevel||"forbid";
					var auditLevel = me.config.auditLevel||"warn";
					if ((notalllowLevel.indexOf(data.manLevel) ==-1 )||(auditLevel.indexOf(data.manLevel) ==-1 )) {
						me.passFlag = 0;
					} else{
						me.passFlag = 1;			//
					}						
					me.manLevel = data.manLev ;     /// ��˽����ʾ����
					me.MsgID = data.MsgID;
					me.Msg = data.items;	
					me.manLev = data.manLevel;
					me.drugUniqueStr = data.DrugUniqueStr;
					
					// ��ť����
					me.btnControl(data);

					if(data.passFlag==1){					//ͨ����鲻����
						$(".ckb_view_container").remove();
						$(".ckb_warn_win").remove();
					}				
				}else{
					$(".ckb_warn_win").remove(); 	
					main.append('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					$(".ckb-view-container").show();
				}
				if (me.passFlag == 1) {
					typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// �ص�����
				}
			})
		},		
		update: function (data, callback, action) {	
			this.checkFlag = data.CheckFlag || "Y";			
			runClassMethod("web.DHCCKBService" ,"AcitonProxy", {"jsParamObj" : JSON.stringify(data), "MsgID" : data.MsgID||"", "action" : action||"Pass", "checkFlag" : data.CheckFlag||"Y"},function(jsonObject){
			 		callback.call( this, jsonObject );
			},'json',false)            
		},
		review : function( data ) {
			//this.checkFn(data);
		},
		refresh : function( data, Fn, EffFlag) {
			data.ClientIP = "" //CKBClientIp;			
			
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
		feedBack : function(fn,msgID, reasons,drugUniqueStr) {			 // 2020/12/1 ���������ӿ�			
			// runClassMethod("web.DHCCKBService" ,"UpdateFeedBack", {"msgID":msgID,"reasonsArr":JSON.stringify(reasons),"status":"R","way":"mul","drugUniqueStr":drugUniqueStr},function(jsonObject){
			// 	//fn.call( this, jsonObject);				
			// },'',false)
		},
		initDocNotes:function(){
			var msgID = this.MsgID||"";		
			runClassMethod("web.DHCCKBService" ,"InitDocNotes", {"msgID" : msgID},function(jsonObject){
				if( (jsonObject != "")&&(jsonObject != null)&&(jsonObject != undefined)&&(typeof jsonObject == "object") ){										
					for (i=0; i<=jsonObject.length-1; i++){
						var itemObj = jsonObject[i];
						var noteId = itemObj.unique;
						$("#reason"+noteId).val(itemObj.note||"");	// ��ע��Ϣ
						
						var $label = "#WL"+noteId;	// ��ѡ��ע��Ϣ
						var reasonArr = itemObj.reasons.split("!!");													
						$($label+" :checkbox").each(function(){
						     if (($(this).val() != "")&&($.inArray($(this).val(),reasonArr)>=0 ) ){
							 	$(this).attr("checked","checked");
							 } 
						});	
					}
					// ��ʾҽ��д����ע,����ҽ����ע
					$("textarea[name='ckb_reason'").attr("disabled",true); 
					$("input[type=checkbox][name='reagrp']").attr("disabled",true); 					
				}
				
			},'json',false)		
		}
	};
	
    window.PDSS = PDSS;
})(this)