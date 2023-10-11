/*
 * @Author: qunianpeng
 * @Date: 2022-08-29 14:17:23
 * @Descripttion: 安全用药智能决策系统插件
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-09-02 14:30:48
 */
(function (window) {

	// 计算浏览器的缩放比例。如win10设置为125%，浏览器需要缩放0.8倍,才能保持原本显示大小
	function setRatio(){
    
	    var defaultRatio = 1; //默认缩放比
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
	        
	        //var setZoom = defaultRatio/window.devicePixelRatio; //默认zoom
	        //document.body.style.zoom = setZoom.toFixed(6);
	        var setZoom = defaultRatio/window.devicePixelRatio; //默认zoom
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
        this.nav_ind = 0; // 标识当前显示的菜单项
        this.gotTips = 0; // 标识已经生成了智能审查dom
        this.gotEdus = 0; // 标识已经生成了用药教育dom
        
		if( !this.container ) this.container = document.body;
		this.container = $( this.container );
		this.EffFlag = 1 ;    /// 展示效果
		this.checkFn = null ; /// 回调函数
		this.passFlag = 1 ;   /// 审查结果通过状态
		this.manLevel = "提示" ;   /// 审核结果警示级别
		this.manLev = "";
		this.controlFlag = "N"		/// 强制审核标志(默认为N)
		this.MsgID = "";			/// 消息标记id
		this.Msg = "";				/// 消息json	
		this.reason = [];			// 反馈原因
		this.drugUniqueStr = ""; 	// 药品唯一标识串
		this.checkFlag = "Y";		// 查看或审核标记
		this.config = {};			// 审核配置:如审核级别,悬浮时间,显示位置等			
		this.ratio = 1;	
        this.init( options );
    };
    
    PDSS.prototype = {
		constructor : PDSS,
		templates : {
            main: '<div id="ckb_view_win" class="ckb_view_container" onselectstart="return false">'+
                    '<div id="ckb_view_bar" class= "ckb_view_head" >'+
                        '<div class= "ckb_view_head_logo" ><img id="ckb_logoid" src="../scripts/dhcnewpro/dhcckb/pdss/images/plu-tips.png" alt=""></div>'+
                        '<div class= "ckb_view_head_title" > <label>安全用药智能决策系统</label></div>'+ 
                        '<div class= "ckb_view_head_tools" >'+
                            '<a class= "ckb_view_tool_refresh" href="javascript:void(0)" ></a>' +
                            '<a class="ckb_view_tool_small" href="javascript:void(0)"></a>'+
                            '<a class= "ckb_view_tool_big" href="javascript:void(0)"></a>'+
                            '<a class= "ckb_view_tool_down" href="javascript:void(0)" ></a>' + 
                        '</div>'+
                    '</div >' +
                    '<div id="ckb_view_bodyid" class="ckb_view_body"></div>' +
                    '<div id="control" class="ckb_view_control"><span id="bt_return" class="btn_style btn_return">返回修改</span><span href="#" id="bt_audit" class="btn_style btn_audit">强制审核</span></div>' +
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
                        '	<div id="ckb_view_bar" class="ckb-view-head"><div class="ckb_view_head_logo"><img src="../scripts/dhcnewpro/dhcckb/images/logo.png" border=0/></div><label>双签复核</label><div class="ckb-view-head-tools"><a class="ckb_view_tool_close" href="javascript:void(0)"></a></div></div>'+
                        '   <div class="view_reason_body">'+
                        '		<p style="margin-top:10px;"><label style="font-weight:bold;">请填写用药理由：</label></p>'+
                        '		<div class="realist" style="height:140px;padding:6px;"><p><input type="checkbox" name="reagrp" value="患者情况特殊，需要超剂量" /><label>患者情况特殊，需要超剂量</label></p><p><input type="checkbox" name="reagrp" value="需重复给药或加大剂量" /><label>需重复给药或加大剂量</label></p><p><input type="checkbox" name="reagrp" value="病人强烈要求" /><label>病人强烈要求</label></p><p><input type="checkbox" name="reagrp" value="病人病情需要" /><label>病人病情需要</label></p><p><input type="checkbox" name="reagrp" value="其他" /><label>其他</label></p></div>'+
                        '		<div style="height:100px;padding:6px;"><textarea id="reason" style="width:260px;height:100px;resize:none;" required></textarea></div>'+
                        '	</div>'+
                        '   <div class="view_reason_foot"><span id="bt_doublesign" class="btn_style btn_sign">双签复核</span></div>'+
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
			document.getElementById("ckb_warn_win").onmousedown = function(e){ 
				getObject(document.getElementById("ckb_warn_win"),e||event);       //box捕获事件并处理  e-->FF  window.event-->IE
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
				
				//me.re_vreason(); // 双签弹出 位置
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
			$(".ckb_view_container .ckb_view_tool_close").bind('click',function(){
				if (me.EffFlag == 1){
					$(".ckb-view-container").remove();
				}else{
					$(".ckb-view-container").hide();
				}
				$(".ckb_warn_win").remove();
				$(".view-reason").remove();   /// 删除双签复核弹窗
				if (me.manLev != "forbid"){		// 和强制审核处保持一致,因为其他级别的自动过
					typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// 回调函数
				}
			});
			
			/// 详情
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
			
			/// 推荐用药
			$("#ckb_view_win").on('click','.ckb_recmedical',function(){
				$(".ckb_view_item_recmedical").remove();
				var recmedical = $(this).closest(".ckb_view_item").attr("data-recmedical");
				if (recmedical == "") return;
				var recmedicalArr = recmedical.split(",");
				var htmlstr = "";
				for(var m=0; m<recmedicalArr.length; m++){
					htmlstr = htmlstr + "<p>"+ recmedicalArr[m] +"</p>";
				}
				htmlstr = '<div class="ckb_view_item_recmedical"><span>【推荐用药】</span>' + htmlstr +'</div>';
				$(".ckb_view_item_detail").append(htmlstr);
				$(".ckb_view_item_more").click();
				// 先把推荐用药信息放在详情中
				return;
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
			
			/// 说明书
			$("#ckb_view_win").on('click','.ckb_iteminstru',function(){
				//var _vid = $(this).closest(".ckb-view-detail").attr("data-itmid");
				//window.open('dhcckb.wiki.csp?IncId='+ _vid);
			});			
						
			/// 参考文献
			$("#ckb_view_win").on('click','.item_link_literature',function(){
				// var _vid = $(this).closest(".item_link_literature").attr("data-itmid");
				// window.open('dhcckb.reference.csp?IncId='+ _vid);
			});	
			
			/// 放大事件
			$(".ckb_view_tool_big").bind('click', function () {
				var newratio = $("#ckb_view_win").css("zoom")||1;
				newratio = parseFloat(newratio) + 0.1;			
				if (newratio.toFixed(6)<1.5){
					$("#ckb_view_win").css("zoom",newratio);
					me.relocation();
				}			
			});		
			
			/// 缩小事件
			$(".ckb_view_tool_small").bind('click', function () {				
				var newratio = $("#ckb_view_win").css("zoom")||1;
				newratio = parseFloat(newratio) - 0.1;
				if (newratio.toFixed(6)>0.5){
					$("#ckb_view_win").css("zoom",newratio);
					me.relocation();
				}				
			});
			
			/// 重置事件
			$(".ckb_view_tool_refresh").bind('click', function () {
				$("#ckb_view_win").css("zoom",me.ratio||1);
				me.relocation();
			});
			
			/// 收缩事件
			$(".ckb_view_tool_down").bind('click', function () {
				me.showModel(0);
				event.stopPropagation();
			});
			
			/// 警示灯点击事件
			$(".ckb_warn_win .ckb_warn_pull").bind('click',function(){
				me.showModel(1);
				event.stopPropagation();
			});
			
			
			/// 强制审核
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
					$.messager.alert('提示','医生批注不能为空');	
					return;	
					}   // 强制审核时禁止级别需要写批注消息 2022-03-04
				}*/		
				$(".ckb-view-container").remove();			
				$(".ckb_warn_win").remove();
				me.feedBack("", me.MsgID||"", reasonArr,me.drugUniqueStr||"");	// 强制审核时,修改后台的数据
				typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// 回调函数
			})
			
			/// 返回修改		
			$(".ckb_view_control").on('click', '#bt_return', function () {
				$(".ckb_view_container").remove();			
				$(".ckb_warn_win").remove();
				$(".view_reason").remove();   /// 删除双签复核弹窗
				typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// 回调函数
			})
			
			/// 鼠标移入事件
			$('#ckb_view_win').mouseover(function (e) {
				if (me.passFlag != 0){
			       $("#ckb_view_win").stop(true, false)
				}
			});
			    
			/// 鼠标移出事件
		    $('#ckb_view_win').mouseout(function () {
			    if (me.passFlag == 1){
					$('#ckb_view_win').delay(2500).hide(0);
				}		        
		    });
			
		},
		relocation : function() {			
			/// 弹出窗体重新定位			
	        var Height = document.documentElement.clientHeight; /// 取得浏览器页面可视区域的宽度
	        var Width = document.documentElement.clientWidth;   /// 取得浏览器页面可视区域的宽度	        
	       	//(win系统设置的放大，或者浏览器的放大或缩小，会影响浏览器的像素大小(可视区域/body的大小), 如在win10或浏览器中设置显示125%,则1920*1080的body会变成 clientWidth和clientHeight1528*724(可显示的像素变少了)
	        // 但是屏幕实际的像素不会变化（比如：通过clientWidth获取到值为1500,但是屏幕实际为1920,会导致横向滚动条的产生）放大或缩小，不影响给元素设置的大小
	       	Width = Width/(this.ratio||1);					/// 根据浏览器放大或缩小的,计算出可视变化前的实际宽度和高(若不计算实际高度，则下面div设置的位置会随着浏览器的变化而变化)
	        Height = Height/(this.ratio||1);  
	         
	   		var El = document.getElementById("ckb_view_win"); /// 获取div块对象
	        var El_Height = El.offsetHeight; 				/// 获取div块的高度值
	        var El_Width = El.offsetWidth;   				/// 获取div块的宽度值	        
	 		
	 		var top = "35px";
	 		var bottom = Height-El_Height +"px";
	 		var left = "10px";
	 		var right = Width - El_Width -20 +"px";	
	 		var xcenter = Width/2 - El_Width/2 +"px";	 		
	 		/*
	 		if (this.config.pluPosition||"" != ""){
		        var position = this.config.pluPosition;
		        // // 只有一个方位词,是设置x轴
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
		        // 默认上中
		    	El.style.top = "35px";	
	       		El.style.left = Width/2 - El_Width/2 +"px";
		    }
		    */
	        /// 警示灯重新定位
	      	var El_Warn = document.getElementById("ckb_warn_win"); /// 获取div块对象	      
	        var El_WarnWidth = El_Warn.offsetWidth;  
	        El_Warn.style.left =  Width/2 - El_WarnWidth/2 +"px";	
	        El_Warn.style.top = "35px";		        
	        
	        // 只要有top bottom left right
	   		// 左上角 left top
	        //El.style.top = "35px"; 	/// 无论浏览器如何变化，可保证元素在可视区域内的位置不变
	       	//El.style.left = "10px";	
	       	// 上中   top center
	       	El.style.top = "35px";	
	       	El.style.left = Width/2 - El_Width/2 +"px";
	        // 右上角 right top
	        //El.style.top = "35px";	
	        //El.style.left = Width - El_Width -20 +"px";		
	        // 左中  left center
	        //El.style.top = Height/2 - El_Height/2 +"px";	
	        //El.style.left = "10px";		
	        // 中中 center center
	        //El.style.top = Height/2 - El_Height/2 +"px";	
	        //El.style.left = Width/2 - El_Width/2 +"px";
	        // 右中 right center
	        //El.style.top = Height/2 - El_Height/2 +"px";	
	        //El.style.left = Width - El_Width -20 +"px";	
	        // 左下 left bottom
	        //El.style.top = Height-El_Height +"px";	
	        //El.style.left = "10px";
	        // 中下 center bottom
	        //El.style.top = Height-El_Height +"px";
	        //El.style.left = Width/2 - El_Width/2 +"px";
	        //右下 right bottom
	        //El.style.top = Height-El_Height +"px";
	        //El.style.left = Width - El_Width -20 +"px";	      				      
	      
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
			this.ratio = setRatio();
			var me = this;
			$(".ckb_view_container").remove(); 	/// 删除消息面板
			$(".ckb_warn_win").remove(); 		/// 删除警示灯图标
			this.container.append( template( this.templates.main ) );
			if ($(".ckb_warn_win").length == 0){
				this.container.append( template( this.templates.warnWin ) );  /// 初始化警示灯
			}		
            if ($(".view_reason").length == 0) {	// 双签复核
				// this.container.append( template( this.templates.reasonWin ) ); /// 强制审核区域
			}			
			// 获取配置数据
			this.update( {}, function( data ) {	
				me.config = data;							
				me.relocation(); /// 重新定位
			}, "Config")
						
			$(".ckb_view_container").hide();
			$(".ckb_warn_win").hide(); 			
            me.init_Temp();	// 初始化模板
		},
		init_Temp : function() {			
			/// 初始化模板  
			var me = this;
			templates = me.templates;
            templates.view[ "item" ] = me.patinfo_html() + me.temp_html();
        },        
        patinfo_html: function () {			
            
            var tempHtml = "";    
            tempHtml += '<div class="ckb_view_parent clearfix">';
            tempHtml += '   <div class="ckb_view_parent_left">';
            tempHtml += '       <% var seximg = (patInfo.patSex=="男")?"pat_male.png":"pat_female.png"; %>';
            tempHtml += '       <img src="../scripts/dhcnewpro/dhcckb/pdss/images/<%-seximg %>" alt="" />';
            tempHtml += '       <div class="ckb_patname nowrap"><%-patInfo.patName %></div>';
            tempHtml += '   </div>';
            tempHtml += '   <div class="ckb_view_parent_right">';
            tempHtml += '       <% var patmsg =patInfo.patSex + "  /" + patInfo.patAge + "  /"; %>';
            tempHtml += '       <% if(patInfo.patHeight != "") patmsg += patInfo.patHeight + "  /"; %>';
            tempHtml += '       <% if(patInfo.patWeight != "") patmsg += patInfo.patWeight + "  /"; %>';  
            tempHtml += '       <%patmsg += "主治医生  "+ patInfo.mainDoc + "  /"; %>';  
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
			
			// 医生批注选项
			//this.config.notelists = ['临床指南', '药品说明书'];
			var notelists = this.config.notelists||[];
			
			var notehtml = "";					
			for (var index = 0; index < notelists.length; index++) {
				notehtml += '<label><input type="checkbox" name="reagrp" value="'+notelists[index]+'">'+notelists[index]+'</label>';
			}
			if (notehtml != '') {
				notehtml = '<div class="view_notesitem">' + notehtml + '</div>';
				notehtml = '<div class="view_notelists"><span>医生批注：</span>'+notehtml+'</div>';
			}

            var tempHtml = "";    
            tempHtml += '<div class="ckb_view_main" id="ckbid_main">';
            tempHtml +=     '<% for( var i = 0; i < items.length; i ++ ) { %> <% var item = items[ i ]; %>';
            //------------------------------------ckb_view_item-start-----------------------------            
            tempHtml +=         '<div class="ckb_view_item" data-id="WL<%-item.unique %>" data-recmedical="<%-item.adviceDrug %>">';
            //////////////////////////////item_cont开始//////////////////////////////////////////    
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
            ////////////////////////////item_head结束
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
            tempHtml +=                                      '<span class="item_levelstyle text_18left <%-caselevel %>"></span>'; // 项目提醒中需要排序
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
            tempHtml +=                                 '<span class="item_msg"><span style="color:red">【参考依据】:</span><%-rule.source %></span>';
			tempHtml +=                             '</div>'; 
            tempHtml +=                             '<% } %>';												
            tempHtml +=                         '<% } %>';
            tempHtml +=                         '</div>';
            tempHtml +=                     '<% } %>';            
            tempHtml +=                 '</div>';
            ////////////////////////////item_body结束
            tempHtml +=              '</div>';   
            //////////////////////////////item_cont结束/////////////////////////////////////////             
            tempHtml +=             '<div class="ckb_view_item_detail" data-id="WL<%-item.unique %>">';
            tempHtml +=             	'<span>【审核结果】</span><span>超出说明书限定</span>';
			
			tempHtml += 			'</div>';
            tempHtml +=             '<div class="ckb_view_item_education"></div>';
            //////////////////////////////item_docnotes开始////////////////////////////////////            
            tempHtml +=             '<div class="ckb_view_item_docnotes">';
			tempHtml +=					notehtml;
            // tempHtml +=                 '<div class="view_notelists">';
            // tempHtml +=                     '<span>医生批注：</span>';
            // tempHtml +=                     '<div class="view_notesitem">';
            // tempHtml +=                         '<label><input type="checkbox" name="reagrp" value="临床指南">临床指南</label>'
            // tempHtml +=                     '</div>';
            // tempHtml +=                 '</div>';
            tempHtml +=                 '<div class="view_noteinput">';
            tempHtml +=                     '<textarea name="ckb_reason" id="reason<%-item.unique %>" data-unique="<%-item.unique %>" data-seqno="<%-item.seqno%>" data-item="<%-item.item %>" data-manlevel="<%-item.manLevel %>" required=""></textarea>';
            tempHtml +=                 '</div>';
            tempHtml +=             '</div>';
            ////////////////////////////////////item_docnotes结束/////////////////////////////
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
				case 0:	// 显示简略图标		
					//$(".ckb_warn_win").show(); 	
					//$(".ckb_view_container").hide();	
					$(".ckb_warn_win").fadeIn(); 	
					$(".ckb_view_container").fadeOut();					
					break;
				case 1:	// 显示弹窗明细
					//$(".ckb_view_container").show();
					//$(".ckb_warn_win").hide(); 
					$(".ckb_view_container").fadeIn();
					$(".ckb_warn_win").fadeOut();
					break;		
									
				default:	// 不弹窗
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
			//$("#ckb_view_win").css("zoom",this.ratio||1); // 缩放
			document.getElementById("ckb_view_win").style.zoom = this.ratio||1; // 缩放
			document.getElementById("ckb_warn_win").style.zoom = this.ratio||1; // 缩放
			this.update(this.bin_data.data, function (data) {
				
				if (typeof data.ErrorCode == "undefined") {					
					//更新logo级别
                    var imglogo = (data.manLevel == "normal") || (data.manLevel == "") || (data.manLevel == undefined) ?"plu-tips.png":"plu-"+data.manLevel+".png";
                    $("#ckb_logoid").attr('src','../scripts/dhcnewpro/dhcckb/pdss/images/'+imglogo);
					$(".ckb_warn_logo img").attr('src','../scripts/dhcnewpro/dhcckb/pdss/images/'+imglogo);
										
					// 数据赋值
					main.append( template( templates.view[ "item" ], data ) );					
				
					// 显示模式的控制
					//me.EffFlag = 0;
					me.showModel(me.EffFlag);						
					
					// 数据赋值
					me.passFlag = data.passFlag;   /// 审查结果通过状态
					// 禁止生成医嘱的级别 和 需要强制审核的级别 不能通过
					var notalllowLevel = me.config.notallowLevel||"forbid";
					var auditLevel = me.config.auditLevel||"warn";
					if ((notalllowLevel.indexOf(data.manLevel) ==-1 )||(auditLevel.indexOf(data.manLevel) ==-1 )) {
						me.passFlag = 0;
					} else{
						me.passFlag = 1;			//
					}						
					me.manLevel = data.manLev ;     /// 审核结果警示级别
					me.MsgID = data.MsgID;
					me.Msg = data.items;	
					me.manLev = data.manLevel;
					me.drugUniqueStr = data.DrugUniqueStr;
					
					// 按钮控制
					me.btnControl(data);

					if(data.passFlag==1){					//通过审查不弹窗
						$(".ckb_view_container").remove();
						$(".ckb_warn_win").remove();
					}				
				}else{
					$(".ckb_warn_win").remove(); 	
					main.append('<p style="text-align: center;padding-top: 100px;font-size: 14px;color: red;letter-spacing:2px;">'+ data.ErrorMessage +'</p>');
					$(".ckb-view-container").show();
				}
				if (me.passFlag == 1) {
					typeof me.checkFn === "function" ? me.checkFn(me) : ""; 	/// 回调函数
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
		feedBack : function(fn,msgID, reasons,drugUniqueStr) {			 // 2020/12/1 新增反馈接口			
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
						$("#reason"+noteId).val(itemObj.note||"");	// 备注信息
						
						var $label = "#WL"+noteId;	// 勾选批注信息
						var reasonArr = itemObj.reasons.split("!!");													
						$($label+" :checkbox").each(function(){
						     if (($(this).val() != "")&&($.inArray($(this).val(),reasonArr)>=0 ) ){
							 	$(this).attr("checked","checked");
							 } 
						});	
					}
					// 表示医生写过批注,禁用医生批注
					$("textarea[name='ckb_reason'").attr("disabled",true); 
					$("input[type=checkbox][name='reagrp']").attr("disabled",true); 					
				}
				
			},'json',false)		
		}
	};
	
    window.PDSS = PDSS;
})(this)