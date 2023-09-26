/**
 * dhcant.base-1.0.0.js
 * 
 * Copyright (c) 2017-2018 QiuPeng. All rights reserved.
 * 
 * Version: 1.0.0 
 * 
 * CREATED BY QP 2017-03-11
 * 
 */
(function( window, Date, undefined ) {
	var ANT = {};
	window.ANT = ANT;
	$.extend(ANT, {
		GetDateStr: function (AddDayCount){
			var cfgFormat = $.InvokeMethod("DHCAnt.Util.CacheServerBase","GetDateFormat");
			AddDayCount = AddDayCount||0;
			var curDate = new Date(); 
			curDate.setDate(curDate.getDate()+AddDayCount);
			var y = curDate.getFullYear(); 
			var m = curDate.getMonth()+1;
			var d = curDate.getDate(); 
			if (m.toString().length == 1) {
				m = "0" + m;
			}
			if (d.toString().length == 1) {
				d = "0" + d;
			}
			if (cfgFormat == 1) {
				return m+"/"+d+"/"+y; 
			} else if (cfgFormat == 3) {
				return y+"-"+m+"-"+d; 
			} else {
				return d+"/"+m+"/"+y; 
			};
		},
		GetDateStrOld: function (AddDayCount){
			AddDayCount = AddDayCount||0;
			var curDate = new Date(); 
			curDate.setDate(curDate.getDate()+AddDayCount);
			var y = curDate.getFullYear(); 
			var m = curDate.getMonth()+1;
			var d = curDate.getDate(); 
			return y+"-"+m+"-"+d; 
		},
		getBrowserType: function () {
			var explorer =navigator.userAgent;
			if ( explorer.indexOf("MSIE 7.0") >= 0 ) {
				return "IE8";
			} else if ( explorer.indexOf("MSIE 6.0") >= 0 ) {
				return "IE6";
			} else if ( explorer.indexOf("MSIE 8.0") >= 0 ) {
				return "IE8";
			} else if ( explorer.indexOf("MSIE 9.0") >= 0 ) {
				return "IE9";
			} else if ((explorer.indexOf("MSIE") >= 0)||( explorer.indexOf("Trident") >= 0 )) {
				return "IE";
			} else if (explorer.indexOf("Firefox") >= 0) {
				return "Firefox";
			} else if(explorer.indexOf("Chrome") >= 0){
				return "Chrome";
			} else if(explorer.indexOf("Opera") >= 0){
				return "Opera";
			} else if(explorer.indexOf("Safari") >= 0){
				return "Safari";
			} else if(explorer.indexOf("Netscape")>= 0) { 
				return "Netscape";
			} else {
				return "";
			};
		},
		initEasyUIPage: function(pageSize, pageArray) {
			if ($.fn.datagrid){
				$.fn.datagrid.defaults.pageSize = pageSize;
				$.fn.datagrid.defaults.pageList = pageArray;
			};
			return this;
		},
		preventRightClick: function(selector) {
			$(selector).bind('contextmenu',function(e){
				//e = e||window.event;    
				return false;
			});
		},
		DHC: {
			setHUICombo: function (browserType) {
				if (browserType == "IE") {
					$("#i-auth-condition-docname").next().find(".combo-text").css("width","108px");  
				} else if (browserType == "IE8") {
					$("#i-auth-condition-docname").next().find(".combo-text").css("width","108px");  
				} else {
					$("#i-auth-condition-docname").next().find(".combo-text").css("width","122px");  
				};
				return false;
			},
			setHCombo: function (browserType, id) {
				if (browserType == "IE") {
					$("#" + id).next().find(".combo-text").css("width","108px");  
				} else if (browserType == "IE8") {
					$("#" + id).next().find(".combo-text").css("width","108px");  
				} else {
					$("#" + id).next().find(".combo-text").css("width","122px");  
				};
				return false;
			},
			getAuditType: function(locid,inHosp) {
				var auditType = $.InvokeMethod("DHCAnt.KSS.Common.Method","GetAuditType", locid,inHosp);
				return auditType;
			},
			getProcessDep: function() {
				var products = $.InvokeMethod("DHCAnt.KSS.Common.Method","GetAllDep", 1).split("%");
				$.each(products,function(i, n){
					products[i] = $.parseJSON(n);
				});
				return products;
			},
			getConsultDepNums: function(InHosp) {
				InHosp = InHosp||"";
				var num = $.InvokeMethod("DHCAnt.KSS.Common.Method","GetConsultDepNums",InHosp);
				return num;
			},
			ifEnableYFDrug: function() {
				var rtn = $.InvokeMethod("DHCAnt.KSS.Common.Method","ComIfEnableYFDrug");
				return rtn;
			},
			getDocAuthNum: function(inHosp) {
				inHosp = inHosp||"";
				var mnum = $.InvokeMethod("DHCAnt.KSS.Common.Method","GetDocAuthNum",inHosp);
				return mnum;
			},
			get9DocAuth: function(ctCareId,hospId) {
				var docAuthStr = $.InvokeMethod("DHCAnt.KSS.Common.Method","Get9DocAuth",ctCareId,hospId);
				var docAuthArray = docAuthStr.split("&");
				var OAuthArray = docAuthArray[0].split("^"),
					EAuthArray = docAuthArray[1].split("^"),
					IAuthArray = docAuthArray[2].split("^"),
					docAuthObj = {};
				docAuthObj.OAuth = {
					kss1Control: OAuthArray[0],
					kss1Verify: OAuthArray[1],
					kss1ItemId: OAuthArray[2],
					kss2Control: OAuthArray[3],
					kss2Verify: OAuthArray[4],
					kss2ItemId: OAuthArray[5],
					kss3Control: OAuthArray[6],
					kss3Verify: OAuthArray[7],
					kss3ItemId: OAuthArray[8]
				};
				docAuthObj.EAuth = {
					kss1Control: EAuthArray[0],
					kss1Verify: EAuthArray[1],
					kss1ItemId: EAuthArray[2],
					kss2Control: EAuthArray[3],
					kss2Verify: EAuthArray[4],
					kss2ItemId: EAuthArray[5],
					kss3Control: EAuthArray[6],
					kss3Verify: EAuthArray[7],
					kss3ItemId: EAuthArray[8]
				};
				docAuthObj.IAuth = {
					kss1Control: IAuthArray[0],
					kss1Verify: IAuthArray[1],
					kss1ItemId: IAuthArray[2],
					kss2Control: IAuthArray[3],
					kss2Verify: IAuthArray[4],
					kss2ItemId: IAuthArray[5],
					kss3Control: IAuthArray[6],
					kss3Verify: IAuthArray[7],
					kss3ItemId: IAuthArray[8]
				};
				return docAuthObj;
			}
		},
		setComboWidth: function (type, id) {
			if ( type == "IE") {
				$("#" + id).css("width", "140px");
			};
			if ( type == "Chrome") {
				$("#" + id).css("width", "154px");
			};
			return this;
		},
		initCheckboxSetting: function (selector) {
			$(selector).iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});
		},
		ajaxEasyUILoading: function () {
			$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
			$("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",height:"40px",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2}); 
		},
		ajaxEasyUILoadEnd: function () {
			$(".datagrid-mask").remove(); 
			$(".datagrid-mask-msg").remove(); 
		},
		parseExcel: function (excelOBJ) {
			var oXL = new ActiveXObject("Excel.application");
			var oWB = oXL.Workbooks.open(excelOBJ.filePath);
			oWB.worksheets(1).select();
			var oSheet = oWB.ActiveSheet;
			var rows =  oSheet .usedrange.rows.count;
			var cols =  oSheet .usedrange.columns.count;
			try {
				var count = 0;
				for (var i = 2; i <= rows; i++) {
					var docNum = oSheet.Cells(i, 1).value||"";
					var docName = oSheet.Cells(i, 2).value||"";
					var admType = oSheet.Cells(i, 3).value||"";
					var kssLevel = oSheet.Cells(i, 4).value||"";
					var appType = oSheet.Cells(i, 5).value||"";
					var prescFlag = oSheet.Cells(i, 6).value||"";
					var authFlag = oSheet.Cells(i, 7).value||"";
					var docAuthStr=docNum + "^" + docName + "^" + admType + "^" + kssLevel + "^"
									+ appType + "^" + prescFlag + "^" + authFlag;
					var rtn = $.InvokeMethod(excelOBJ.className,excelOBJ.method, docAuthStr);
					if (rtn == "-101") {
						excelOBJ.MaskUtil.unmask();	
						layer.alert('导入失败，原因：获取不到'+ docName + '的医护级别...', {title:'提示',icon: 5}); 
						return false;
					};
					if (rtn == "-102") {
						excelOBJ.MaskUtil.unmask();	
						layer.alert("导入失败，原因：没有维护该医护级别主表...", {title:'提示',icon: 5}); 
						return false;
					};
					if (rtn == "-103") {
						excelOBJ.MaskUtil.unmask();	
						layer.alert("导入失败...", {title:'提示',icon: 5}); 
						return false;
					};
					if (rtn == "-104") {
						excelOBJ.MaskUtil.unmask();	
						layer.alert("维护医生无处方权失败...", {title:'提示',icon: 5}); 
						return false;
					};
					if (rtn == "-105") {
						excelOBJ.MaskUtil.unmask();	
						layer.alert("找不到该管制分类...", {title:'提示',icon: 5}); 
						return false;
					};
					count++;
				};
				excelOBJ.MaskUtil.unmask();	
				//$.messager.alert('<i class="fa fa-arrow-right" style="font-size:14px; color:#0E2D5F; font-weight:bold;">&nbsp;恭喜</i>','<span style="font-size:14px;">导入成功，共导入<i style="color: blue;font-size:1.5em;">&nbsp;' + count + '</i>&nbsp;&nbsp;	条记录！</span>','info');
				layer.alert('<span style="font-size:14px;">导入成功，共导入<i style="color: blue;font-size:1.5em;">&nbsp;' + count + '</i>&nbsp;&nbsp;	条记录！</span>', {
					title:'提示',
					icon: 6
				});
			} catch(e) {
				layer.alert("导入失败...", {title:'提示',icon: 5}); 
				oXL.Application.Quit();
				CollectGarbage();
				return false;
			}
			oXL.Application.Quit();
			CollectGarbage();
			return false;
		},
		initEasyUIMask: function() {
			var $mask,$maskMsg;  
			var defMsg = '正在处理，请稍待。。。';  
			function init(){  
				if(!$mask){  
					$mask = $("<div class=\"datagrid-mask mymask\"></div>").appendTo("body");  
				}  
				if(!$maskMsg){  
					$maskMsg = $("<div class=\"datagrid-mask-msg mymask\">"+defMsg+"</div>")  
						.appendTo("body").css({'font-size':'14px', 'color': 'green', 'padding-top': '8px', 'height':'40px'});  
				}  
				  
				$mask.css({width:"100%",height:$(document).height()});  
				  
				var scrollTop = $(document.body).scrollTop();  
				  
				$maskMsg.css({  
					left:( $(document.body).outerWidth(true) - 190 ) / 2  
					,top:( ($(window).height() - 45) / 2 ) + scrollTop  
				});   
						  
			};
			  
			return {  
				mask:function(msg){  
					init();  
					$mask.show();  
					$maskMsg.html(msg||defMsg).show();  
				}  
				,unmask:function(){  
					$mask.hide();  
					$maskMsg.hide();  
				}  
			};
		},
		IESupport: function(type) {
			if ( type.indexOf("IE") < 0) {
				layer.alert("该功能仅支持IE浏览器，谢谢......", {title:'提示',icon: 5}); 
				return false;
			};
			return true;
		},
		updateGridActions: function (index, selector) {
			$(selector).datagrid('updateRow',{
				index: index,
				row:{}
			});
		},
		getGridRowIndex: function(target) {
			var tr = $(target).closest('tr.datagrid-row');
			return parseInt(tr.attr('datagrid-row-index'));
		},
		editGridRow: function(target, selector) {
			$(selector).simpledatagrid('selectRow',ANT.getGridRowIndex(target));
			$(selector).datagrid('beginEdit', ANT.getGridRowIndex(target));
		},
		deleteGridRow: function (target, selector) {
			$.messager.confirm('提示','你确定要删除么？',function(r){
				if (r){
					$(selector).datagrid('deleteRow', ANT.getGridRowIndex(target));
				}
			});
		},
		saveGridRow: function (target, selector) {
			$(selector).datagrid('endEdit', ANT.getGridRowIndex(target));
		},
		cancelGridRow: function(target, selector) {
			$(selector).datagrid('cancelEdit', ANT.getGridRowIndex(target));
			$(selector).simpledatagrid('reload').simpledatagrid('clearSelections');
		},
		cancelGridRowNew: function (target, selector,RowOBJ) {
			RowOBJ.editRow = undefined;
			$(selector).datagrid("rejectChanges").datagrid("unselectAll");
			return false;
		},
		insert: function (selector) {
			var row = $(selector).datagrid('getSelected');
			if (row){
				var index = $(selector).datagrid('getRowIndex', row);
			} else {
				index = 0;
			};
			$(selector).datagrid('insertRow', {
				index: index,
				row:{
				status:'P'
				}
			});
			$(selector).datagrid('selectRow',index);
			$(selector).datagrid('beginEdit',index);
		}
	});
	
	Date.prototype.format = function(format){ 
		var o = { 
			"M+" : this.getMonth()+1,
			"d+" : this.getDate(),
			"h+" : this.getHours(),
			"m+" : this.getMinutes(),
			"s+" : this.getSeconds(),
			"q+" : Math.floor((this.getMonth()+3)/3),
			"S" : this.getMilliseconds()
		};
		
		if(/(y+)/.test(format)) { 
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
		};
		
		for(var k in o) { 
			if(new RegExp("("+ k +")").test(format)) { 
				format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
			} 
		};
		
		return format; 
	};
})( window, Date );