//页面Event
function InitEnviHyApplyWinEvent(obj){
	obj.loadEvents=function(){ 
		obj.BatchIDs=""; 
		obj.flag=0; 	
		obj.counts="";
		// 申请
		$("#btnApply").on('click', function(){
			obj.Report="";
			obj.ApplyEdit();		
		});
		$("#btnBatchApply").on('click', function(){
			obj.BatchReport="";
			obj.OpenBatchApply();
			
		});
		$('#btnColSpec').on('click', function(){
			obj.btnColSpec_onClick();
		});
		$("#btnReason").click(function(e){
			
			obj.refreshgridReason();
			$('#LayerReson').show();
			obj.LayerReason();
			
		});
			//导出按钮事件
		$('#btnExport').on('click', function(){
			obj.btnExport_onClick();
		});
	}
	
	//导出功能
	obj.btnExport_onClick = function(){
		var rows =$HUI.datagrid('#gridApply').getRows().length;  
		if (rows>0) {
			 var chkRows=$('#gridApply').datagrid('getChecked').length;
			 if (chkRows>0) {
				 var rowData =$HUI.datagrid('#gridApply').getChecked();
			 }else {
			 	var rowData =getRows('#gridApply');
			 }
			 ExportData(rowData);
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	function getRows(target){
		var allPage = true;   //默认导出所有页 
        var state = $(target).data('datagrid');  
	    if (allPage) {   //导出所有页
	        var opts=state.options;    
	        var url=opts.url,queryParams=opts.queryParams;
	        if (!$.isEmptyObject(queryParams)) {   //后台分页查询中参数不为空,此写法类似导出前查询一次，将查询内容作param.rows传入
	        	var autoParams={page:1,rows:1000000}; //datagrid自动加的参数
		        if (opts.remoteSort && opts.sortName) {
		            autoParams.sort=opts.sortName;
		            autoParams.order=opts.sortOrder
		        }
		        if(url && url!=""){
			        var rows= new Array(); 
			       $.ajaxSettings.async = false;
		            $.post(url,$.extend({},queryParams,autoParams),'','json').done(function(ret){
		                if (typeof ret.rows=="object" ) {
		                    rows = ret.rows;
		                }
		            });
		            $.ajaxSettings.async = true;
		            return rows;
		             
		        }else{
					var rows=state.data?( (state.data.originalRows ? state.data.originalRows:state.data.rows ) ||state.data||[]):state.originalRows;
		        	return rows;
		        }
	        }else {   //前台分页查询
		        return state.data.originalRows||state.originalRows;	
	        }
	    }else {  //导出当前页
	        return state.data.rows||state.rows;
	    }
	}
	obj.btnColSpec_onClick = function(){
		var chkRows=$('#gridApply').datagrid('getChecked');
		if (chkRows.length>0) {
			 $.messager.confirm("确认", "是否批量采集标本?", function (r) {
				if (r) {
					var reportIds = '';
					for (var row = 0; row < chkRows.length; row++){
						var rd = chkRows[row];
						if (!rd) continue;
						var repId = rd['ReportID'];
						var RepStatusCode = rd['RepStatusCode'];
						if (RepStatusCode !=obj.BeforeStatusCode)continue;
						if (reportIds != ''){
							reportIds += ',' + repId;
						} else {
							reportIds = repId;
						}
					}
					var flg = $m({
						ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
						MethodName  : "SaveBactRepOpera",
						aReportIDs  : reportIds,
						aBarcode    : '',
						aStatusCode : 6,
						aLogonLocDr : LogonLocID,
						aLogonUserDr: LogonUserID
					},false);
					if (parseInt(flg) < 1) {
						$.messager.alert("错误提示","采集标本操作错误!Error=" + flg, 'info');
					} else {
						$.messager.popover({msg: '采集标本操作成功！',type:'success',timeout: 1000});
						obj.reloadgridApply();//刷新当前页
					}
				}
			});
		}else {
			$.messager.alert("确认", "无记录,不可操作!", 'info');
			return;
		}
	};
	//打开批量申请页面
    obj.OpenBatchApply = function () {
		LogonHospID=$.LOGON.HOSPID;
		LogonHospDesc=$.LOGON.HOSPDESC;
		LogonUserID=$.LOGON.USERID;
		LogonLocID=$.LOGON.LOCID;
		LogonLocDesc=$.LOGON.LOCDESC;
		obj.flag=0;
		
	 	//批量申请设置开始日期为当月1号
		var date=new Date()
		var cboDate=Common_GetDate(date);
		Common_SetValue('cboDate',cboDate);
		
 		//批量申请科室
		if (tDHCMedMenuOper['Admin']!=1) { 
		 //临床科室
	    	obj.cboBatchMonitorLoc = Common_ComboToLoc('cboBatchMonitorLoc',LogonHospID);	
	    	$('#cboBatchMonitorLoc').combobox('disable');
			$('#cboBatchMonitorLoc').combobox('setValue',LogonLocID);
			$('#cboBatchMonitorLoc').combobox('setText',LogonLocDesc);
			obj.AdminFlag=0;
			obj.cboBatchMonitorLoc=$("#cboBatchMonitorLoc").combobox('getValue');
		}else {
			obj.AdminFlag = tDHCMedMenuOper['Admin'];
			obj.cboBatchMonitorLoc= Common_ComboToLoc('cboBatchMonitorLoc',LogonHospID);
			$('#cboBatchMonitorLoc').combobox('setValue',LogonLocID);
			$('#cboBatchMonitorLoc').combobox('setText',LogonLocDesc);
	    	$('#cboBatchMonitorLoc').combobox('enable');
	    	obj.AdminFlag=1;
	    	obj.cboBatchMonitorLoc=$("#cboBatchMonitorLoc").combobox('getValue');
		}
		var ExtTypeIDs= $cm({
        	ClassName: "DHCHAI.IRS.EnviHyLocItemsSrv",
        	QueryName: "QryBatchEnviHyLocItems",
        	locId: obj.cboBatchMonitorLoc,
       		aDate:cboDate,
       		ItemID:""
    	}, false);
    	obj.BatchIDs=ExtTypeIDs;
    	$("#BatchApplyInfo").html("");
    	MakePage(ExtTypeIDs,cboDate);
    	$('#LayerBatchApply').dialog({
			title: '监测批量申请单',
			iconCls:"icon-w-paper",
			headerCls:'panel-header-gray',
			modal: true
		});
		$HUI.dialog('#LayerBatchApply').open();
		
		 
		//复选框勾选事件
    	$("input[name='selectApply']").click(function() {
       		var length=$("input[type='checkbox']:checked").length;
       		if(length==obj.counts){
	       		$("#checkAll").checkbox('setValue', true);
	       	}
    	});
		
  
    }
	// 监测日期切换
	$('#cboDate').datebox({
        onSelect : function(date) {
			var NewDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
			var BatchLoc=$("#cboBatchMonitorLoc").combobox('getValue');
			$("#BatchApplyInfo").html("")
			var ExtTypeIDs= $cm({
			ClassName: "DHCHAI.IRS.EnviHyLocItemsSrv",
			QueryName: "QryBatchEnviHyLocItems",
			locId: BatchLoc,
			aDate:NewDate,
			ItemID:""
			}, false);
			MakePage(ExtTypeIDs,NewDate);
		}
	 });
	 // 监测科室切换
	$('#cboBatchMonitorLoc').combobox({
		onSelect:function(data){
			if(obj.flag==0){
			var BatchLoc=data.ID;
			var NewDate=$('#cboDate').datebox('getValue');
			$("#BatchApplyInfo").html("");
				
					var ExtTypeIDs= $cm({
					ClassName: "DHCHAI.IRS.EnviHyLocItemsSrv",
					QueryName: "QryBatchEnviHyLocItems",
					locId: BatchLoc,
					aDate:NewDate,
					ItemID:""
				}, false);	
				MakePage(ExtTypeIDs,NewDate);
			}
			
		}
	});

   
	//全选方法$("[name='checkApply']").attr("checked",'true');
   	//组装公用方法
   	function MakePage(ExtTypeIDs,cboDate){
	   	var html="<table class='easyui-datagrid' style='text-align:center;width:1100px' id ='BatchApply'>"  
	   	var html=html+  '<tr style="height:30px;">'
		var html=html+	'<td class="selectAll" style="width:60px;padding-bottom:10px;background-color:#F4F4F4;">'
		var html=html+	'<input class="hisui-checkbox " id="checkAll" name ="checkAllApply" type="checkbox"  data-options="checked:false" >'
		var html=html+	'</td>'
		var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">'+$g('监测项目')+'</td>'
		var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">'+$g('监测对象')+'</td>'
		var html=html+	'<td class="r-label" style="display: none;"></td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:130px;background-color:#F4F4F4;">'+$g('对象备注')+'</td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:100px;background-color:#F4F4F4;">'+$g('中心数')+'</td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:100px;background-color:#F4F4F4;">'+$g('周边数')+'</td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:100px;background-color:#F4F4F4;">'+$g('参照点数')+'</td>'
		var html=html+  '</tr>'
		var ApplyTimes=0
		var counts=0
    	for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
	    	var ExtTypeData    = ExtTypeIDs.rows[ind];
	    	var EvItemDesc     = ExtTypeData.EvItemDesc;
	   		var	xID            = ExtTypeData.xID;
	   		var EHNote         = ExtTypeData.EHNote;
	   		var	EvItemID       = ExtTypeData.EvItemID;
	   		var EHItemMax      = ExtTypeData.EHItemMax;
        	var EHCenterNum    = ExtTypeData.EHCenterNum;
        	var EHSurroundNum  = ExtTypeData.EHSurroundNum;
        	var EHReferToNum   = ExtTypeData.EHReferToNum;
			var ApplyCount  = $m({
				ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
				MethodName:"ApplyCount",
				aLocDr:$('#cboBatchMonitorLoc').combobox('getValue'),
				aItemDr:EvItemID,
				aDate:cboDate	
			},false);
        	var EvObjectdata=$cm({
				ClassName:'DHCHAI.IRS.EnviHyItemSrv',
				QueryName:'QryEvObjsByItem',
				ResultSetType:'array',
				aParRef:EvItemID,
				aLocID:$('#cboBatchMonitorLoc').combobox('getValue')	
			},false);
			var ApplyTimes1=EHItemMax - ApplyCount;
			counts+=ApplyTimes1
			if(ApplyTimes1>0){
				for (var i = 0; i< ApplyTimes1; i++) {
					var html=html+  '<tr style="padding:10px;">'
					var html=html+	'<td class="selectAll" style="padding-bottom:10px;">'
					var html=html+	'<input class="hisui-checkbox " id="check'+xID+"-"+i+'" name ="selectApply" type="checkbox"  data-options="checked:false" >'
					var html=html+	'</td>'
					var html=html+	'<td style="padding:8px 0px 0px 0px;">'
					var html=html+		'<input class="textbox" disabled style="width:240px; background-color:#FFFFFF;border:1px solid #9ed2f2;color:black" value='+EvItemDesc+'>'
					var html=html+	'</td>'
					var html=html+	'<td style="padding:8px 0px 0px 0px;">'
					var html=html+		'<input class="hisui-combobox" id="cboBatObject'+xID+"-"+i+'" style="text-align:center">'
					var html=html+	'</td>'
					var html=html+	'<td style="display: none;padding:8px 0px 0px 0px;">'
					var html=html+		'<input class="textbox" id="BatchEvIsObjNull' + xID +"-"+i+ '" >'
					var html=html+	'</td>'
					var html=html+	'<td style="padding:8px 0px 0px 0px;">'
					var html=html+		'<input class="textbox" id="EHNote' + xID + "-"+i+'" style="text-align:center">'
					var html=html+	'</td>'
					var html=html+	'<td style="padding:8px 0px 0px 0px;"> '
					var html=html+		'<input class="textbox" id=EHCenterNum' + xID +"-"+i+ ' style="text-align:center">'
					var html=html+	'</td>'
					var html=html+	'<td style="padding:8px 0px 0px 0px;">'
					var html=html+		'<input class="textbox" id=EHSurroundNum' + xID +"-"+i+ ' style="text-align:center">'
					var html=html+	'</td>'
					var html=html+	'<td style="padding:8px 0px 0px 0px;">'
					var html=html+		'<input class="textbox" id=EHReferToNum' + xID + "-"+i+' style="text-align:center">'
					var html=html+	'</td>'
					var html=html+  '</tr>'	
					
				}
				
			}
	   	}
		var html=html+  '</table>'
   		obj.counts=counts
		if(0<=counts&&counts<=10){
			var html=html+  '<div id="Abutton" align="center" style="position:absolute;left:50%;bottom:10px;transform:translateX(-50%)">'
			var html=html+  '<a href="#" id="addB"  class="hisui-linkbutton hover-dark" style="margin-right:20px">保存</a>'
			var html=html+  '<a href="#" id="closeB"  class="hisui-linkbutton hover-dark">关闭</a>'
			var html=html+  '</div>'
		}else{
			var html=html+  '<div id="Abutton" align="center" style="padding-bottom:10px;">'
			var html=html+  '<a href="#" id="addB" class="hisui-linkbutton hover-dark" style="margin-right:20px" >保存</a>'
			var html=html+  '<a href="#" id="closeB" class="hisui-linkbutton hover-dark">关闭</a>'
			var html=html+  '</div>'
		}
		$("#BatchApplyInfo").append(html);
		$.parser.parse("#BatchApplyInfo"); // 解析EasyUI组件
		$(".selectAll .checkbox").css("margin-left","-28px");
		$(".selectAll .checkbox").css("margin-top","4px")
		$(".divMask").css("display","none");
		//全选事件
		$('#addB').on('click', function(){ 
   	 		LogonHospID=$.LOGON.HOSPID;
  			if(obj.flag==0){
	   			var count=0;
	   			var ErrorStr = "";
				var arr=[];
	    		for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
	  				var ExtTypeData    = ExtTypeIDs.rows[ind];
	    			var EvItemDesc     = ExtTypeData.EvItemDesc;
		    		var	xID        	   = ExtTypeData.xID;
		    		var	EvItemID       = ExtTypeData.EvItemID;
        			var EHCenterNum    = ExtTypeData.EHCenterNum;
       	    		var EHSurroundNum  = ExtTypeData.EHSurroundNum;
        			var EHReferToNum   = ExtTypeData.EHReferToNum;
        			var EHNote         = ExtTypeData.EHNote;
        			var	EHIsObjNull    = ExtTypeData.EHReferToNum;
        			var EHItemMax      = ExtTypeData.EHItemMax;

        			var EvObjectdata=$cm({
						ClassName:'DHCHAI.IRS.EnviHyItemSrv',
						QueryName:'QryEvObjsByItem',
						ResultSetType:'array',
						aParRef:EvItemID,
						aLocID:$('#cboBatchMonitorLoc').combobox('getValue')	
					},false);
					for (var i = 0; i< EHItemMax; i++) {
						var check=$('#check'+xID+"-"+i).is(':checked');
						if(check) {
							count=count+1;
							var rd = obj.BatchReport;
							var ReCheckRepID="",IsReCheck="",IsReCheck=""
							var ReportID=''
							var HospitalDr      = LogonHospID;
							var MonitorLocDr    = $("#cboBatchMonitorLoc").combobox('getValue');
							var MonitorDate   	= $("#cboDate").datebox('getValue');
							var EvItemDr 		= EvItemID;
							var EvObjectDr   	= $('#cboBatObject'+xID+"-"+i).combobox('getValue');
							var EHItemObjTxt   	= $("#EHNote"+xID+"-"+i).val();
							var CenterNum		= $("#EHCenterNum"+xID+"-"+i).val();
							if (CenterNum==""){
								CenterNum=0
							}
							var SurroundNum		= $("#EHSurroundNum"+xID+"-"+i).val();
							if (SurroundNum==""){
								SurroundNum=0
							}
							var ReferToNum		= $("#EHReferToNum"+xID+"-"+i).val();
							if (ReferToNum==""){
								ReferToNum=0
							}
							var SpecimenNum    	= parseInt(CenterNum)+parseInt(SurroundNum)+parseInt(ReferToNum);
							var IsObjNull		= EHIsObjNull
							var ErrorStr = "";
							if (EvItemDr == '') {
								$.messager.alert("错误提示",'监测项目不允许为空！<br/>', 'info');
								return;
							}
							var InfEnviHyItem = $m({
								ClassName:"DHCHAI.IR.EnviHyItem",
								MethodName:"GetObjById",
								id:EvItemDr
							},false);
							var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
			
							var EHSpecimenNum = cm.EHSpecimenNum;
							var IsObjNull=cm.EHIsObjNull;
							var EHIsSpecNum = cm.EHIsSpecNum;
			
							if (HospitalDr == '') {
								ErrorStr += ($g('院区不允许为空！')+'<br/>');	
							}
							if (MonitorLocDr == '') {
								ErrorStr += ($g('监测科室不允许为空！')+'<br/>');
							}
							if (MonitorDate == '') {
								ErrorStr += ($g('监测日期不允许为空！')+'<br/>');
							}
							if ((IsObjNull==0)&&(EvObjectDr == '')) {
								ErrorStr += ($g('监测对象不允许为空！')+'<br/>');
							}
							var EvObjectDesc = $("#EHNote"+xID).val();
							if (((EvObjectDesc=="手")||(EvObjectDesc=="其他"))&(EHItemObjTxt=="")){
								ErrorStr += ($g('检测对象为手或其他时，对象备注不允许为空！')+'<br/>');
							}
							if (SpecimenNum == 0) {
								ErrorStr += ($g('标本数量不允许为空！')+'<br/>');
							}
							if (ErrorStr != '') {
								$.messager.alert("错误提示",ErrorStr, 'info');
									return;
							}
							var InfEnviHyItem = $m({
								ClassName:"DHCHAI.IR.EnviHyItem",
								MethodName:"GetObjById",
								id:EvItemDr
							},false);
							var cm1=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
			
							var EHSpecimenNum = cm1.EHSpecimenNum
							if ((EHIsSpecNum!="1")&&((parseInt(EHSpecimenNum))<parseInt(SpecimenNum))) {
								ErrorStr = ErrorStr + ($g("参照点个数、中心个数、周边个数总数不允许大于标本个数!")+"<br>");
							}
							var applyFlag  = $m({
								ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
								MethodName:"CheckIsApply",
								aLocDr:MonitorLocDr,
								aItemDr:EvItemDr,
								aDate:MonitorDate
							},false);
							if ((applyFlag=="1")&&(ReportID=="")){
								ErrorStr = ErrorStr + ($g("科室申请的项目超过了本月申请次数!")+"<br>");
							}
							var applyFlag= $m({
								ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
								MethodName:"CheckIsAllowApply",
								aLocDr:MonitorLocDr,
								aItemDr:EvItemDr,
								aDate:MonitorDate
							},false);
							if ((applyFlag!="1")&&(ReportID=="")){
								ErrorStr = ErrorStr + ($g("科室申请的项目还不允许监测!")+"<br>");
							}
							if (ErrorStr != '') {
								$.messager.alert("错误提示",ErrorStr, 'info');
								return;
							}
			
							var InputStr = ReportID;
								InputStr += "^" + EvItemDr;
								InputStr += "^" + EvObjectDr;
								InputStr += "^" + 1;
								InputStr += "^" + MonitorDate;
								InputStr += "^" + '';
								InputStr += "^" + '';
								InputStr += "^" + LogonLocID;
								InputStr += "^" + LogonUserID;
								InputStr += "^" + SpecimenNum;
								InputStr += "^" + CenterNum;
								InputStr += "^" + SurroundNum;
								InputStr += "^" + ''; 			//RepDate
								InputStr += "^" + ''; 			//RepTime
								InputStr += "^" + ''; 			//RepLocDr
								InputStr += "^" + ''; 			//RepUserDr
								InputStr += "^" + ''; 			//Standard
								InputStr += "^" + ''; 			//Resume
								InputStr += "^" + ''; 			//CollDate
								InputStr += "^" + ''; 			//CollTime
								InputStr += "^" + ''; 			//CollUserDr
								InputStr += "^" + ''; 			//RecDate
								InputStr += "^" + ''; 			//RecTime
								InputStr += "^" + ''; 			//RecUserDr
								InputStr += "^" + ''; 			//IsRstByItm
								InputStr += "^" + IsReCheck; 	//IsReCheck
								InputStr += "^" + ReCheckRepID; //ReCheckRepDr
								InputStr += "^" + EHItemObjTxt; //ItemObjTxt
								InputStr += "^" + MonitorLocDr; 			
								InputStr += "^" + ReferToNum;
								arr.push(InputStr);
			
							
						}
					}
				}
				if(count==0){
					$.messager.alert("提示","请选择监测项目!",'info');
				}else{
					for(var i = 0; i < arr.length; i++){
						InputStr=arr[i];
						var retval = $m({
							ClassName:"DHCHAI.IR.EnviHyReport",
							MethodName:"Update",
							InStr:InputStr
						},false);
						if (parseInt(retval)>0){
							// 环境卫生学监测检验标本 
							var retvalLog = $m({
								ClassName:"DHCHAI.DP.LabInfVisitNumber",
								MethodName:"SaveLabBarcode",
								aReportID:retval
							});
							// 保存日志
							var LogStr = retval;
								LogStr = LogStr + '^' + LogonLocID;
								LogStr = LogStr + '^' + LogonUserID;
								LogStr = LogStr + '^' + 1;
								LogStr = LogStr + '^' + '';
							var retvalLog = $m({
								ClassName:"DHCHAI.IR.EnviHyReportLog",
								MethodName:"Update",
								aInput:LogStr
							});
							$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
							$HUI.dialog('#LayerBatchApply').close();
							obj.reloadgridApply1();
							var checkItem= EvItemDesc.indexOf("新冠")
							if(checkItem!=-1){
								$m({
									ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
									MethodName  : "SaveBactRepOpera",
									aReportIDs  : retval,
									aBarcode    : '',
									aStatusCode : 2,
									aLogonLocDr : LogonLocID,
									aLogonUserDr: LogonUserID
								},false);
								$m({
									ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
									MethodName  : "SaveBactRepOpera",
									aReportIDs  : retval,
									aBarcode    : '',
									aStatusCode : 6,
									aLogonLocDr : LogonLocID,
									aLogonUserDr: LogonUserID
								},false);
								$m({
									ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
									MethodName  : "SaveBactRepOpera",
									aReportIDs  : retval,
									aBarcode    : '',
									aStatusCode : 3,  
									aLogonLocDr : LogonLocID,
									aLogonUserDr: LogonUserID
								},false);	
							} 
						} else {
							$.messager.alert("错误提示","保存失败:"+retval, 'info');
						}
					}
				}
			}
		});
		//关闭批量申请
	 	$('#closeB').on('click', function(){
			$HUI.dialog('#LayerBatchApply').close();
		});
		//显示全部
		$('#checkAll').click(function() {
			var check=$('#checkAll').is(':checked');
			if(check){
				for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
					var ExtTypeData    = ExtTypeIDs.rows[ind];
					var EHItemMax      = ExtTypeData.EHItemMax;
					var	xID  = ExtTypeData.xID;
					for (var i = 0; i< EHItemMax; i++){
						$("#check"+xID+"-"+i).checkbox('setValue', true);
					}
				} 
			}else{
				for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
					var ExtTypeData    = ExtTypeIDs.rows[ind];
					var EHItemMax      = ExtTypeData.EHItemMax;
					var	xID  = ExtTypeData.xID;
					for (var i = 0; i< EHItemMax; i++){
						$("#check"+xID+"-"+i).checkbox('setValue', false);
					}
				} 
			}
		});
			
		
		for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
	    	var ExtTypeData    = ExtTypeIDs.rows[ind];
	    	var EvItemDesc     = ExtTypeData.EvItemDesc;
	   		var	xID            = ExtTypeData.xID;
	   		var	EHIsObjNull    = ExtTypeData.EHIsObjNull;
	   		var EHNote         = ExtTypeData.EHNote;
	   		var	EvItemID       = ExtTypeData.EvItemID;
        	var EHCenterNum    = ExtTypeData.EHCenterNum;
        	var EHSurroundNum  = ExtTypeData.EHSurroundNum;
        	var EHReferToNum   = ExtTypeData.EHReferToNum;
       		var EHItemMax      = ExtTypeData.EHItemMax;
       		
        	var EvObjectdata=$cm({
				ClassName:'DHCHAI.IRS.EnviHyItemSrv',
				QueryName:'QryEvObjsByItem',
				ResultSetType:'array',
				aParRef:EvItemID,
				aLocID:$('#cboBatchMonitorLoc').combobox('getValue')	
			},false);
			for (var i = 0; i < EHItemMax; i++) {
				$("#EHNote"+xID+"-"+i).val(EHNote);
				$("#EHCenterNum"+xID+"-"+i).val(EHCenterNum);
				$("#EHSurroundNum"+xID+"-"+i).val(EHSurroundNum);
				$("#EHReferToNum"+xID+"-"+i).val(EHReferToNum);
				$("#BatchEvIsObjNull"+xID+"-"+i).val(EHIsObjNull);
		
				$HUI.combobox("#cboBatObject"+xID+"-"+i,{
					data:EvObjectdata,
					valueField:'ObjID',
					textField:'ObjDesc',
					editable:true,
					onLoadSuccess:function(data){
						//只有一条记录默认加载
						if (data.length==1) {
							$('#cboBatObject'+xID+"-"+i).combobox('select',data[0]['ObjID']);
						}
					}
				});
			}
	 	}
	 }
	  
	//重新加载表格数据
	obj.reloadgridApply1 = function(){

		var HospIDs	    = $("#cboHospital").combobox('getValue');
		var DateType	= $("#DateType").combobox('getValue');
		var DateFrom	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		var MonitorLoc 	= $("#cboMonitorLoc").combobox('getValue');
		//var MonitorLoc 	= $.LOGON.LOCID;
		//$("#cboMonitorLoc").combobox('setValue',MonitorLoc);
		var EvItem  	= $("#cboEvItem").combobox('getValue');
		var StatusCode 	= $("#cboRepStatus").combobox('getValue');
		//var Standard 	= Common_CheckboxValue('checkStandard');
		var ErrorStr="";
	
		if (HospIDs=="") {
			ErrorStr += ($g('请选择院区!')+'<br/>');
		}
		if (DateFrom=="") {
			ErrorStr += ($g('请选择监测开始日期!')+'<br/>');
		}
		if (DateTo == "") {
			ErrorStr += ($g('请选择监测结束日期!')+'<br/>');
		}
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		if (DateFlag==1){
			ErrorStr += ($g('监测开始日期不能大于监测结束日期!')+'<br/>');
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			$('#gridApply').datagrid('load',{
				ClassName:'DHCHAI.IRS.EnviHyReportSrv',
		        QueryName:'QryEvReport',
		        aHospIDs:HospIDs,
		        aDateType:DateType,
		        aDateFrom:DateFrom,
		        aDateTo:DateTo,
		        aMonitorLoc:MonitorLoc,
		        aItemID:EvItem,
		        aStatusCode:StatusCode,
		        aFlowFlg:"", //按标本状态筛查
		        aStandard:''
			});
		}
		$('#gridApply').datagrid('unselectAll');
	};
     	
		
	// 删除
	$("#btnDelete").on('click', function(){
		var rows=$('#gridApply').datagrid('getChecked');
		if (rows.length<1) {
			$.messager.alert("错误提示","请勾选申请记录进行删除！", 'info'); 
			return;
		}
		$.messager.confirm("提示", "确认是否删除勾选申请?", function (r) {				
			if (r) {
				var ErrorMsg="",reportIds='';
				for (var k=0;k<rows.length;k++) {
					var rd=rows[k]
					if (rd.RepStatusCode!="1"){
						ErrorMsg+="申请单【"+rd.BarCode+"】为非申请状态,不能删除！<br/>"
						continue;
					}else{
						var repId = rd['ReportID'];
						if (reportIds != ''){
							reportIds += ',' + repId;
						} else {
							reportIds = repId;
						}
					}
				}
				var flg = $m({
					ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
					MethodName  : "SaveBactRepOpera",
					aReportIDs  : reportIds,
					aBarcode    : '',
					aStatusCode : 0,
					aLogonLocDr : LogonLocID,
					aLogonUserDr: LogonUserID
				},false);
				if (parseInt(flg)<0){
					ErrorMsg+=flg+'<br>'
				}
				if (ErrorMsg==""){
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
					obj.reloadgridApply();
				}else{
					$.messager.alert("删除失败",ErrorMsg, 'info');	
					obj.reloadgridApply();
				}
			}				
		});
	});
	
	//弹出加载层
	function loading(msg) {
		$.messager.progress({
			title: "提示",
			msg: msg,
			text: '请稍等....'
		});
	}
	//取消加载层  
	function disLoad() {
		$.messager.progress("close");
	}  
	// 打印条码
	$("#btnPrintBar").on('click', function(){
		var checkedRows=$HUI.datagrid('#gridApply').getChecked();
		if (checkedRows.length<1) {$.messager.alert("错误提示","请勾选申请记录进行打印！", 'info'); return;}
		//$.messager.popover({msg: '正在打印中,请稍等....',type: 'success',timeout: 2000});
		loading("正在打印");
		for (var j=0;j<checkedRows.length;j++) {
			var rd=checkedRows[j];
			var ID = rd["ReportID"];
			var ItemDesc = rd["EvItemDesc"];
			var NormDesc = rd["NormDesc"];
			var NormMax = rd["NormMax"];
			var NormMin = rd["NormMin"];
			var CenterNum = rd["RepCenterNum"];
			var SurroundNum = rd["RepSurroundNum"];
			var SpecimenNum = rd["SpecimenNum"];
			var BarCode = rd["BarCode"];
			var MonitorDate = rd['MonitorDate'];
			var MonitorLocDesc = rd['MonitorLocDesc'];
			var ItemObjDesc = rd['EvItemObjDesc'];
			if (ItemObjDesc=="") ItemObjDesc = rd['EHItemObjTxt'];
			
			SpecimenNum = SpecimenNum*1;
			CenterNum   = CenterNum*1;
			SurroundNum = SurroundNum*1;
			for(var i = 1; i <= SpecimenNum; i++){
				//条码：8位检验码+2位标本编码
				var SubBarCode = '00' + i;
				SubBarCode = SubBarCode.substring(SubBarCode.length-2,SubBarCode.length);
				vBarCode = "E"+BarCode + SubBarCode;
				
				//项目名称，添加中心、周边及序号
				var SubItemNo = i;
				var SubItemDesc = '';
				if ((CenterNum>0)&&(i<=CenterNum)){
					SubItemDesc = "中心-" + SubItemNo;
				} else if ((SurroundNum>0)&&(i<=(SurroundNum+CenterNum))){
					SubItemDesc = "周边-" + SubItemNo;
				} else if ((CenterNum>0)||(SurroundNum>0)) {
					SubItemDesc = "参照-" + SubItemNo;
				} else {
					SubItemDesc = "检测-" + SubItemNo;
				}
				vItemDate  = MonitorDate + '【' + SubItemDesc + '/' + SpecimenNum + '】';
				///MonitorLocDesc = 
				//增加检测标准
				if (i==1){
					//ItemObjDesc=ItemObjDesc+'【'+ NormDesc+ '】';
					ItemObjDesc=ItemObjDesc;
				}
				if (i==1){
					MonitorLocDesc = MonitorLocDesc+'【'+ NormDesc+ '】';
				}
				
				//条码打印
				PrintXMLBar(ItemDesc,ItemObjDesc,vItemDate,MonitorLocDesc,vBarCode);
			}
		}
		disLoad();
		
	});

	function  PrintXMLBar(ItemDesc,NormObject,ItemDate,LocDesc,BarCode) {
		 var printParam="";
	     var printList="";
	     // 获取XML模板配置
	 	 DHCP_GetXMLConfig("InvPrintEncrypt","DHCHAIEnviHyBar");
	 	 // 打印参数
	     printParam=printParam+"ItemDesc"+String.fromCharCode(2)+ItemDesc;
	     printParam=printParam+"^NormObject"+String.fromCharCode(2)+NormObject;
	     printParam=printParam+"^ItemDate"+String.fromCharCode(2)+ItemDate;
	     printParam=printParam+"^LocDesc"+String.fromCharCode(2)+LocDesc;
	     printParam=printParam+"^BarCode"+String.fromCharCode(2)+BarCode;	
	     printParam=printParam+"^BarCodeNo"+String.fromCharCode(2)+BarCode; 
         if (xmlPrintFlag==2){
             // lodop打印
            DHC_PrintByLodop(getLodop(),printParam,"","","");   
         } else{
              // 控件打印
            var printControlObj=document.getElementById("barPrintControl");
            DHCP_XMLPrint(printControlObj,printParam,printList);   
         }      
	}
	
	//打印报告改为润乾预览打印
	$('#btnPrintReport').click(function(e){
		var checkedRows=$HUI.datagrid('#gridApply').getChecked();
		if (checkedRows.length<1) {$.messager.alert("错误提示","请勾选申请记录进行打印！", 'info'); return;}
		//$.messager.popover({msg: '正在打印中,请稍等....',type: 'success',timeout: 2000});
		loading("正在打印");
		var ReportIDs="";
		var EnviHyRepPrint = $m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"GetValByCode",
			aCode:"EnviHyRepPrint"
		},false);
		var EnviHyRepPrintCheck = $m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"GetValByCode",
			aCode:"EnviHyRepPrintCheck"
		},false);
		var CheckFlag=0;
		for (var j=0;j<checkedRows.length;j++) {
			var rd=checkedRows[j];
			var ID = rd["ReportID"];
			var RepStatusDesc=rd["RepStatusDesc"];
			if (RepStatusDesc!="审核结果"){
				CheckFlag=1;
			}
			if ((RepStatusDesc!="审核结果")&(RepStatusDesc!="录入结果")){
				continue;
			}
			if ((RepStatusDesc!="审核结果")&(EnviHyRepPrintCheck=="1")){
				continue;
			}
			if (EnviHyRepPrint==1){
				//直接打印
				var fileName="{DHCMAEnvihyapply.raq(aReportID="+ID+")}";    //修改为直接打印
				DHCCPM_RQDirectPrint(fileName);
			}
			if (ReportIDs==""){
				ReportIDs=ID;
			}else{
				ReportIDs=ReportIDs+"^"+ID;
			}
		}
		disLoad();
		if (ReportIDs==""){
			if (EnviHyRepPrintCheck==1){
				$.messager.alert("错误提示","请选择审核结果的报告进行打印！", 'info');
				return;
			}else{
				$.messager.alert("错误提示","请选择录入结果的报告进行打印！", 'info');
				return;
			}
			
		}
		if ((CheckFlag==1)&&(EnviHyRepPrintCheck==1)){
			$.messager.alert("错误提示","选择的报告包含了未审核的报告，不能打印！", 'info');
			return;
		}
		
		if (EnviHyRepPrint!=1){
			var fileName="DHCMAEnvihyapply.raq&aReportID="+ReportIDs;
			DHCCPM_RQPrint(fileName);
		}
		
		/*  DHCHAI.IRS.EnviHyReportSrv  QryEnviPrintRepInfo
		//var selRow = $('#gridApply').datagrid('getSelected');
		var selRows = $('#gridApply').datagrid('getSelections');
		
		if(selRows == null){
			$.messager.alert("错误提示","请选择一份打印报告", 'info');
			return;
		}
		
		if(selRows != null  ){
			if(selRows.length > 1){
				$.messager.alert("错误提示","请选择一份打印报告", 'info');
				return;
			}else{
				var ReportID = selRows[0].ReportID;
			}
     		
 		}
 		//var fileName="DHCMAEnvihyapply.raq&aReportID="+ReportID;
		//DHCCPM_RQPrint(fileName);
		var fileName="{DHCMAEnvihyapply.raq(aReportID="+ReportID+")}";    //修改为直接打印
		DHCCPM_RQDirectPrint(fileName);
		
		//var selRow = $('#gridApply').datagrid('getSelected');
		var selRows = $('#gridApply').datagrid('getSelections');
		
		if(selRows == null){
			$.messager.alert("错误提示","请选择一份打印报告", 'info');
			return;
		}
		
		if(selRows != null  ){
			if(selRows.length > 1){
				$.messager.alert("错误提示","请选择一份打印报告", 'info');
				return;
			}else{
				var ReportID = selRows[0].ReportID;
			}
     		
 		}
 		//var fileName="DHCMAEnvihyapply.raq&aReportID="+ReportID;
		//DHCCPM_RQPrint(fileName);
		var fileName="{DHCMAEnvihyapply.raq(aReportID="+ReportID+")}";    //修改为直接打印
		DHCCPM_RQDirectPrint(fileName);
		*/
	});
	
	//关闭申请
	$('#closeA').on('click', function(){
		$HUI.dialog('#ApplyEdit').close();
	});
	
	// 申请、修改申请记录
	$('#addA').on('click', function() {
		var rd = obj.Report;
		var ReCheckRepID="",IsReCheck="",ReportID=""
		if (rd) {
			var ReportID=rd.ReportID;
			var ReCheckRepID=rd.ReCheckRepID;
			if (ReCheckRepID>0) IsReCheck=1;
		}
		var HospitalDr      = $("#cboAHospital").combobox('getValue');
		var MonitorLocDr    = $("#cboALoc").combobox('getValue');
		var MonitorDate   	= $("#AMonitorDate").datebox('getValue');
		var EvItemDr 		= $("#cboAEvItem").combobox('getValue');
		var EvObjectDr   	= $("#cboAEvObject").combobox('getValue');
		var EHItemObjTxt   	= $("#AEvObjectTxt").val();
		var CenterNum		= $("#txtCenterNum").val();
		var SurroundNum		= $("#txtSurroundNum").val();
		var ReferToNum		= $("#txtReferToNum").val();
		var SpecimenNum    	= parseInt(CenterNum)+parseInt(SurroundNum)+parseInt(ReferToNum);
		var IsObjNull		= $("#AEvIsObjNull").val();
		var ErrorStr = "";
		if (EvItemDr == '') {
			$.messager.alert("错误提示",'监测项目不允许为空！<br/>', 'info');
			return;
		}
		var InfEnviHyItem = $m({
			ClassName:"DHCHAI.IR.EnviHyItem",
			MethodName:"GetObjById",
			id:EvItemDr
		},false);
		var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
		var EHSpecimenNum = cm.EHSpecimenNum;
		var IsObjNull=cm.EHIsObjNull;
		var EHIsSpecNum = cm.EHIsSpecNum;
		if (HospitalDr == '') {
			ErrorStr += ($g('院区不允许为空！')+'<br/>');	
		}
		if (MonitorLocDr == '') {
			ErrorStr += ($g('监测科室不允许为空！')+'<br/>');
		}
		if (MonitorDate == '') {
			ErrorStr += ($g('监测日期不允许为空！')+'<br/>');
		}
		/**if (($('#EvObject').css('display')!='none')&&(EvObjectDr == '')) {
			ErrorStr += '监测对象不允许为空！<br/>';
		}**/
		if ((IsObjNull==0)&&(EvObjectDr == '')) {
			ErrorStr += ($g('监测对象不允许为空！')+'<br/>');
		}
		var EvObjectDesc = $("#cboAEvObject").combobox('getText');
		if (((EvObjectDesc=="手")||(EvObjectDesc=="其他"))&(EHItemObjTxt=="")){
            ErrorStr += ($g('检测对象为手或其他时，对象备注不允许为空！')+'<br/>');
        }
		if (SpecimenNum == 0) {
			ErrorStr += ($g('标本数量不允许为空！')+'<br/>');
      
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		var InfEnviHyItem = $m({
			ClassName:"DHCHAI.IR.EnviHyItem",
			MethodName:"GetObjById",
			id:EvItemDr
		},false);
		var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
		var EHSpecimenNum = cm.EHSpecimenNum
		var EvItemDesc=cm.EHItemDesc
		if ((EHIsSpecNum!="1")&&((parseInt(EHSpecimenNum))<parseInt(SpecimenNum))) {
			ErrorStr = ErrorStr + ($g("参照点个数、中心个数、周边个数总数不允许大于标本个数!")+"<br>");
		}
		var applyFlag= $m({
			ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			MethodName:"CheckIsAllowApply",
			aLocDr:MonitorLocDr,
			aItemDr:EvItemDr,
			aDate:MonitorDate
		},false);
		if ((applyFlag!="1")&&(ReportID=="")){
			ErrorStr = ErrorStr + ($g("科室申请的项目还不允许监测!")+"<br>");
		}
		var applyFlag  = $m({
			ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			MethodName:"CheckIsApply",
			aLocDr:MonitorLocDr,
			aItemDr:EvItemDr,
			aDate:MonitorDate
		},false);
		if ((applyFlag=="1")&&(ReportID=="")){
			ErrorStr = ErrorStr + ($g("科室申请的项目超过了本月申请次数!")+"<br>");
		}
		
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		
		var InputStr = ReportID;
		InputStr += "^" + EvItemDr;
		InputStr += "^" + EvObjectDr;
		InputStr += "^" + 1;
		InputStr += "^" + MonitorDate;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + LogonLocID;
		InputStr += "^" + LogonUserID;
		InputStr += "^" + SpecimenNum;
		InputStr += "^" + CenterNum;
		InputStr += "^" + SurroundNum;
		InputStr += "^" + ''; 			//RepDate
		InputStr += "^" + ''; 			//RepTime
		InputStr += "^" + ''; 			//RepLocDr
		InputStr += "^" + ''; 			//RepUserDr
		InputStr += "^" + ''; 			//Standard
		InputStr += "^" + ''; 			//Resume
		InputStr += "^" + ''; 			//CollDate
		InputStr += "^" + ''; 			//CollTime
		InputStr += "^" + ''; 			//CollUserDr
		InputStr += "^" + ''; 			//RecDate
		InputStr += "^" + ''; 			//RecTime
		InputStr += "^" + ''; 			//RecUserDr
		InputStr += "^" + ''; 			//IsRstByItm
		InputStr += "^" + IsReCheck; 	//IsReCheck
		InputStr += "^" + ReCheckRepID; //ReCheckRepDr
		InputStr += "^" + EHItemObjTxt; //ItemObjTxt
		InputStr += "^" + MonitorLocDr; 			
		InputStr += "^" + ReferToNum; 			
		
		$m({
			ClassName:"DHCHAI.IR.EnviHyReport",
			MethodName:"Update",
			InStr:InputStr
		},function(retval){
			if (parseInt(retval)>0){
				// 环境卫生学监测检验标本 add by zhoubo 2020-12-04
				var retvalLog = $m({
					ClassName:"DHCHAI.DP.LabInfVisitNumber",
					MethodName:"SaveLabBarcode",
					aReportID:retval
				});
				// 保存日志
				var LogStr = retval;
				LogStr = LogStr + '^' + LogonLocID;
				LogStr = LogStr + '^' + LogonUserID;
				LogStr = LogStr + '^' + 1;
				LogStr = LogStr + '^' + '';
				var retvalLog = $m({
					ClassName:"DHCHAI.IR.EnviHyReportLog",
					MethodName:"Update",
					aInput:LogStr
				});
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
				$HUI.dialog('#ApplyEdit').close();
				obj.reloadgridApply();
				var checkItem= EvItemDesc.indexOf("新冠")
				if(checkItem!=-1){ 
					$m({
						ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
						MethodName  : "SaveBactRepOpera",
						aReportIDs  : retval,
						aBarcode    : '',
						aStatusCode : 2,
						aLogonLocDr : LogonLocID,
						aLogonUserDr: LogonUserID
					},false);
					$m({
						ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
						MethodName  : "SaveBactRepOpera",
						aReportIDs  : retval,
						aBarcode    : '',
						aStatusCode : 6,
						aLogonLocDr : LogonLocID,
						aLogonUserDr: LogonUserID
					},false);
					$m({
						ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
						MethodName  : "SaveBactRepOpera",
						aReportIDs  : retval,
						aBarcode    : '',
						aStatusCode : 3,  
						aLogonLocDr : LogonLocID,
						aLogonUserDr: LogonUserID
					},false);	
				}
			} else {
				$.messager.alert("错误提示","保存失败:"+retval, 'info');
			}
		})
	});
	// 复制申请记单
	$('#copyA').on('click', function(){
		$HUI.dialog('#ApplyEdit').close(); //关闭申请填写窗口
		$HUI.dialog('#CopyApply').open(); //打开历史申请列表
	});
	// 复制到本月
	$('#copyADetail').on('click', function(){
		obj.flag=1;
		var SelectRows=$HUI.datagrid('#HisApplyList').getSelections();
		var MonitorDate=$('#CAMonitorDate').datebox('getValue');
		if (MonitorDate== '') {
			$.messager.alert("错误提示","监测日期不能为空", 'info');
			$('#CAMonitorDate').focus();
			return;
		}
		if (SelectRows.length<1) {
			$.messager.alert("提示","至少选择一条记录进行复制", 'info');
			return ;
		}
		var MonitorLoc=$('#CAMonitorLoc').combobox('getValue');
		var monthlist=$m({
		 	ClassName:'DHCHAI.IRS.EnviHyReportSrv',
			MethodName:'GetLastMonth'	
		},false)
		var monthlist=eval(monthlist);
		var errorStr=""
		for (var i=0;i<SelectRows.length;i++){
			var row			   =SelectRows[i]
			var EvItemID       =row.EvItemID
			var EHItemMax	   =row.EHItemMax
			var EvItemDesc	   =row.EvItemDesc
			var ApplyCount  = $m({
				ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
				MethodName:"ApplyCount",
				aLocDr:$('#CAMonitorLoc').combobox('getValue'),
				aItemDr:EvItemID,
				aDate:MonitorDate	
			},false);
			var applyFlag  = $m({
				ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
				MethodName:"CheckIsApply",
				aLocDr:$('#CAMonitorLoc').combobox('getValue'),
				aItemDr:EvItemID,
				aDate:MonitorDate,
			},false);
			if (applyFlag!=""){
				if(ApplyCount>EHItemMax||ApplyCount==EHItemMax){
					errorStr="监测项目: "+EvItemDesc+"存在超过科室计划中对应时间段监测数量!"
				}
			}
		}
		if (errorStr!= '') {
			$.messager.alert("错误提示",errorStr, 'info');
			return;
		}
		if (tDHCMedMenuOper['Admin']!=1) { 
		 //临床科室
	    	obj.cboBatchMonitorLoc = Common_ComboToLoc('cboBatchMonitorLoc',LogonHospID);	
	    	$('#cboBatchMonitorLoc').combobox('disable');
			$('#cboBatchMonitorLoc').combobox('setValue',LogonLocID);
			$('#cboBatchMonitorLoc').combobox('setText',LogonLocDesc);
			obj.AdminFlag=0;
			obj.cboBatchMonitorLoc=$("#cboBatchMonitorLoc").combobox('getValue');
		}else {
			obj.AdminFlag = tDHCMedMenuOper['Admin'];
			obj.cboBatchMonitorLoc= Common_ComboToLoc('cboBatchMonitorLoc',LogonHospID);
			$('#cboBatchMonitorLoc').combobox('setValue',LogonLocID);
			$('#cboBatchMonitorLoc').combobox('setText',LogonLocDesc);
	    	$('#cboBatchMonitorLoc').combobox('enable');
	    	obj.AdminFlag=1;
	    	obj.cboBatchMonitorLoc=$("#cboBatchMonitorLoc").combobox('getValue');
		}
		
		var ExtIDs= $cm({
        	ClassName: "DHCHAI.IRS.EnviHyReportSrv",
        	QueryName: "QryEvReportByMonth",
        	aHospIDs: $.LOGON.HOSPID,
       		aMonth:monthlist[0].id,
       		aDate:MonitorDate,
       		aMonitorLoc:obj.cboBatchMonitorLoc
    	}, false);
    	$("#BatchApplyInfo").html("");
		obj.BatchIDs=SelectRows;
    	MakePage1(SelectRows,MonitorLoc,MonitorDate);	
	});
	
	function MakePage1(SelectRows,MonitorLoc,MonitorDate) {
		var html="<table class='easyui-datagrid' style='text-align:center;width:1100px' id ='BatchApply'>"  
	   	var html=html+  '<tr style="height:30px;">'
	   	var html=html+	'<td class="selectAll" style="width:60px;padding-bottom:10px;background-color:#F4F4F4;">'
		var html=html+	'<input class="hisui-checkbox " id="checkAll" name ="checkAllApply" type="checkbox"  data-options="checked:false" >'
		var html=html+	'</td>'
		var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">监测项目</td>'
		var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">监测对象</td>'
		var html=html+	'<td class="r-label" style="display: none;"></td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:130px;background-color:#F4F4F4;">对象备注</td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:100px;background-color:#F4F4F4;">中心数</td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:100px;background-color:#F4F4F4;">周边数</td>'
		var html=html+	'<td class="r-label" style="text-align:center;width:100px;background-color:#F4F4F4;">参照点数</td>'
		var html=html+  '</tr>'
		for (var i=0;i<SelectRows.length;i++) {
			var row			   =SelectRows[i]
			var EvItemID       =row.EvItemID
			var xID			   =row.ReportID
			var EvItemDesc     = row.EvItemDesc;
			var html=html+  '<tr style="padding:10px;">'
			var html=html+	'<td class="selectAll" style="padding-bottom:10px;">'
			var html=html+	'<input class="hisui-checkbox " id="check'+xID+'" name ="selectApply" type="checkbox"  data-options="checked:false" >'
			var html=html+	'</td>'
			var html=html+	'<td style="padding:8px 0px 0px 0px;">'
			var html=html+		'<input class="textbox" disabled style="width:240px; background-color:#FFFFFF;border:1px solid #9ed2f2;color:black" value='+EvItemDesc+'>'
			var html=html+	'</td>'
			var html=html+	'<td style="padding:8px 0px 0px 0px;">'
			var html=html+		'<input class="hisui-combobox" id="cboBatObject'+xID+'" style="text-align:center">'
			var html=html+	'</td>'
			var html=html+	'<td style="display: none;padding-bottom:10px;">'
			var html=html+		'<input class="textbox" id="BatchEvIsObjNull' + xID + '" >'
			var html=html+	'</td>'
			var html=html+	'<td style="padding:8px 0px 0px 0px;">'
			var html=html+		'<input class="textbox" id="EHNote' + xID + '" style="text-align:center">'
			var html=html+	'</td>'
			var html=html+	'<td style="padding:8px 0px 0px 0px;"> '
			var html=html+		'<input class="textbox" id=EHCenterNum' + xID + ' style="text-align:center">'
			var html=html+	'</td>'
			var html=html+	'<td style="padding:8px 0px 0px 0px;">'
			var html=html+		'<input class="textbox" id=EHSurroundNum' + xID + ' style="text-align:center">'
			var html=html+	'</td>'
			var html=html+	'<td style="padding:8px 0px 0px 0px;">'
			var html=html+		'<input class="textbox" id=EHReferToNum' + xID + ' style="text-align:center">'
			var html=html+	'</td>'
			var html=html+  '</tr>'	
		}
		var html=html+  '</table>'	
		if(0<=SelectRows.length&&SelectRows.length<=10) {
			var html=html+  '<div id="Abutton" align="center" style="position:absolute;left:50%;bottom:10px;transform:translateX(-50%)">'
			var html=html+  '<a href="#" id="addB"  class="hisui-linkbutton hover-dark" style="margin-right:20px">保存</a>'
			var html=html+  '<a href="#" id="closeB"  class="hisui-linkbutton hover-dark">关闭</a>'
			var html=html+  '</div>'
		}else{
			var html=html+  '<div id="Abutton" align="center" style="position:absolute;left:50%;transform:translateX(-50%);padding-bottom:10px;">'
			var html=html+  '<a href="#" id="addB" class="hisui-linkbutton hover-dark" style="margin-right:20px">保存</a>'
			var html=html+  '<a href="#" id="closeB" class="hisui-linkbutton hover-dark">关闭</a>'
			var html=html+  '</div>'
		}
		$("#BatchApplyInfo").append(html);
		Common_SetValue('cboDate',MonitorDate);
		
		$(".selectAll .checkbox").css("margin-left","-28px");
		$(".selectAll .checkbox").css("margin-top","8px")
		$(".divMask").css("display","block")
		$('#cboDate').combobox('disable');
		$.parser.parse("#BatchApplyInfo"); // 解析EasyUI组件
		
		//显示全部
		$('#checkAll').click(function() {
		var check=$('#checkAll').is(':checked');
			if(check){
				for (var ind = 0; ind < SelectRows.length; ind++) {
					var row=SelectRows[ind]
					var xID=row.ReportID
					$("#check"+xID).checkbox('setValue', true);
				} 
			}else{
				for (var ind = 0; ind < SelectRows.length; ind++) {
					var row=SelectRows[ind]
					var xID=row.ReportID
					$("#check"+xID).checkbox('setValue', false);
				} 
			}
		});
		for (var i=0;i<SelectRows.length;i++ ){
			var row=SelectRows[i]
			var EvItemDr=row.EvItemID
			var xID=row.ReportID
			var ReportID		=row.ReportID
	    	var EvItemDesc     = row.EvItemDesc;
	   		var	EHIsObjNull    = row.EHIsObjNull;
	   		var EHNote         = row.EHItemObjTxt;
	   		var	EvItemID       = row.EvItemID;
        	var EHCenterNum    = row.CenterNum;
        	var EHSurroundNum  = row.RepSurroundNum;
        	var EHReferToNum   = row.ReferToNum;
        	var EvObjectdata=$cm({
				ClassName:'DHCHAI.IRS.EnviHyItemSrv',
				QueryName:'QryEvObjsByItem',
				ResultSetType:'array',
				aParRef:EvItemID,
				aLocID:MonitorLoc	
			},false);
			$("#EHNote"+xID).val(EHNote);
			$("#EHCenterNum"+xID).val(EHCenterNum);
			$("#EHSurroundNum"+xID).val(EHSurroundNum);
			$("#EHReferToNum"+xID).val(EHReferToNum);
			$("#BatchEvIsObjNull"+xID).val(EHIsObjNull);
			$HUI.combobox("#cboBatObject"+xID,{
				data:EvObjectdata,
				valueField:'ObjID',
				textField:'ObjDesc',
				editable:true,
				onLoadSuccess:function(data){
					//只有一条记录默认加载
					if (data.length==1) {
						$('#cboBatObject'+xID).combobox('select',data[0]['ObjID']);
					}
				}
			});
		}
		$('#LayerBatchApply').dialog({
			title: '监测批量申请单',
			iconCls:"icon-w-paper",
			headerCls:'panel-header-gray',
			modal: true
		});
		$HUI.dialog('#LayerBatchApply').open();	
	
		//批量申请保存
		$('#addB').on('click', function(){
			if(obj.flag==1){
				var count=0;
				var ErrorStr = "";
				for (var ind = 0; ind < SelectRows.length; ind++) {
					var ExtTypeData    = SelectRows[ind];
					var EvItemDesc     = ExtTypeData.EvItemDesc;
					var	xID        	   = ExtTypeData.ReportID;
					var	EvItemID       = ExtTypeData.EvItemID;
					var EHCenterNum    = ExtTypeData.CenterNum;
					var EHSurroundNum  = ExtTypeData.SurroundNum;
					var EHReferToNum   = ExtTypeData.ReferToNum;
					var EHNote         = ExtTypeData.EHItemObjTxt;
					var EHIsObjNull    = ExtTypeData.EHIsObjNull;
				
					var EvObjectdata=$cm({
						ClassName:'DHCHAI.IRS.EnviHyItemSrv',
						QueryName:'QryEvObjsByItem',
						ResultSetType:'array',
						aParRef:EvItemID,
						aLocID:$('#cboBatchMonitorLoc').combobox('getValue')	
					},false);
					var check=$('#check'+xID).is(':checked');
					if(check) {
						count=count+1;
						var rd = obj.BatchReport;
						var ReCheckRepID="",IsReCheck="",IsReCheck=""
						var ReportID=''
						var HospitalDr      = LogonHospID;
						var MonitorLocDr    = $("#cboBatchMonitorLoc").combobox('getValue');
					//	var MonitorDate   	= $("#cboDate").datebox('getValue');
						var EvItemDr 		= EvItemID;
						var EvObjectDr   	= $('#cboBatObject'+xID).combobox('getValue');
						var EHItemObjTxt   	= $("#EHNote"+xID).val();
						var CenterNum		= $("#EHCenterNum"+xID).val();
						if (CenterNum==""){
							CenterNum=0
						}
						var SurroundNum		= $("#EHSurroundNum"+xID).val();
						if (SurroundNum==""){
							SurroundNum=0
						}
						var ReferToNum		= $("#EHReferToNum"+xID).val();
						if (ReferToNum==""){
							ReferToNum=0
						}
						var SpecimenNum    	= parseInt(CenterNum)+parseInt(SurroundNum)+parseInt(ReferToNum);
						var IsObjNull		= EHIsObjNull
						var ErrorStr = "";
						if (EvItemDr == '') {
							$.messager.alert("错误提示",'监测项目不允许为空！<br/>', 'info');
							return;
						}
						var InfEnviHyItem = $m({
							ClassName:"DHCHAI.IR.EnviHyItem",
							MethodName:"GetObjById",
							id:EvItemDr
						},false);
						var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
						
						var EHSpecimenNum = cm.EHSpecimenNum;
						var IsObjNull=cm.EHIsObjNull;
						var EHIsSpecNum = cm.EHIsSpecNum;
						
						if (HospitalDr == '') {
							ErrorStr += '院区不允许为空！<br/>';	
						}
						if (MonitorLocDr == '') {
							ErrorStr += '监测科室不允许为空！<br/>';
						}
						if (MonitorDate == '') {
							ErrorStr += '监测日期不允许为空！<br/>';
						}
						if ((IsObjNull==0)&&(EvObjectDr == '')) {
							ErrorStr += '监测对象不允许为空！<br/>';
						}
						var EvObjectDesc = $("#EHNote"+xID).val();
						if (((EvObjectDesc=="手")||(EvObjectDesc=="其他"))&(EHItemObjTxt=="")){
							ErrorStr += '检测对象为手或其他时，对象备注不允许为空！<br/>';
						}
						if (SpecimenNum == 0) {
							ErrorStr += '标本数量不允许为空！<br/>';
						}
						if (ErrorStr != '') {
							$.messager.alert("错误提示",ErrorStr, 'info');
							return;
						}
						var InfEnviHyItem = $m({
							ClassName:"DHCHAI.IR.EnviHyItem",
							MethodName:"GetObjById",
							id:EvItemDr
						},false);
						var cm1=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
						
						var EHSpecimenNum = cm1.EHSpecimenNum
						if ((EHIsSpecNum!="1")&&((parseInt(EHSpecimenNum))<parseInt(SpecimenNum))) {
							ErrorStr = ErrorStr + "参照点个数、中心个数、周边个数总数不允许大于标本个数!<br>";
						}
						var applyFlag  = $m({
							ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
							MethodName:"CheckIsApply",
							aLocDr:MonitorLocDr,
							aItemDr:EvItemDr,
							aDate:MonitorDate,
							aMark:"1"
						},false);
						if ((applyFlag=="1")&&(ReportID=="")) {
							ErrorStr = ErrorStr + "科室申请的项目超过了本月申请次数!<br>";
						}
						var applyFlag= $m({
							ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
							MethodName:"CheckIsAllowApply",
							aLocDr:MonitorLocDr,
							aItemDr:EvItemDr,
							aDate:MonitorDate
						},false);
						if ((applyFlag!="1")&&(ReportID=="")){
							ErrorStr = ErrorStr + "科室申请的项目还不允许监测!<br>";
						}
						if (ErrorStr != '') {
							$.messager.alert("错误提示",ErrorStr, 'info');
							return;
						}
						
						var InputStr = ReportID;
						InputStr += "^" + EvItemDr;
						InputStr += "^" + EvObjectDr;
						InputStr += "^" + 1;
						InputStr += "^" + MonitorDate;
						InputStr += "^" + '';
						InputStr += "^" + '';
						InputStr += "^" + LogonLocID;
						InputStr += "^" + LogonUserID;
						InputStr += "^" + SpecimenNum;
						InputStr += "^" + CenterNum;
						InputStr += "^" + SurroundNum;
						InputStr += "^" + ''; 			//RepDate
						InputStr += "^" + ''; 			//RepTime
						InputStr += "^" + ''; 			//RepLocDr
						InputStr += "^" + ''; 			//RepUserDr
						InputStr += "^" + ''; 			//Standard
						InputStr += "^" + ''; 			//Resume
						InputStr += "^" + ''; 			//CollDate
						InputStr += "^" + ''; 			//CollTime
						InputStr += "^" + ''; 			//CollUserDr
						InputStr += "^" + ''; 			//RecDate
						InputStr += "^" + ''; 			//RecTime
						InputStr += "^" + ''; 			//RecUserDr
						InputStr += "^" + ''; 			//IsRstByItm
						InputStr += "^" + IsReCheck; 	//IsReCheck
						InputStr += "^" + ReCheckRepID; //ReCheckRepDr
						InputStr += "^" + EHItemObjTxt; //ItemObjTxt
						InputStr += "^" + MonitorLocDr; 			
						InputStr += "^" + ReferToNum;
						
						var retval = $m({
							ClassName:"DHCHAI.IR.EnviHyReport",
							MethodName:"Update",
							InStr:InputStr
						},false);
						if (parseInt(retval)>0) {
							// 环境卫生学监测检验标本 
							var retvalLog = $m({
								ClassName:"DHCHAI.DP.LabInfVisitNumber",
								MethodName:"SaveLabBarcode",
								aReportID:retval
							});
							// 保存日志
							var LogStr = retval;
							LogStr = LogStr + '^' + LogonLocID;
							LogStr = LogStr + '^' + LogonUserID;
							LogStr = LogStr + '^' + 1;
							LogStr = LogStr + '^' + '';
							var retvalLog = $m({
								ClassName:"DHCHAI.IR.EnviHyReportLog",
								MethodName:"Update",
								aInput:LogStr
							});
						
							$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
							$HUI.dialog('#LayerBatchApply').close();
							obj.reloadgridApply1();
							var checkItem= EvItemDesc.indexOf("新冠")
							if(checkItem!=-1) {
								$m({
									ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
									MethodName  : "SaveBactRepOpera",
									aReportIDs  : retval,
									aBarcode    : '',
									aStatusCode : 2,
									aLogonLocDr : LogonLocID,
									aLogonUserDr: LogonUserID
								},false);
								$m({
									ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
									MethodName  : "SaveBactRepOpera",
									aReportIDs  : retval,
									aBarcode    : '',
									aStatusCode : 6,
									aLogonLocDr : LogonLocID,
									aLogonUserDr: LogonUserID
								},false);
								$m({
									ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
									MethodName  : "SaveBactRepOpera",
									aReportIDs  : retval,
									aBarcode    : '',
									aStatusCode : 3,  
									aLogonLocDr : LogonLocID,
									aLogonUserDr: LogonUserID
								},false);		
							} 
						} else {
							$.messager.alert("错误提示","保存失败:"+retval, 'info');
						}
					}
				}
				if(count==0){
					$.messager.alert("提示","请选择监测项目!",'info');
				}
			}
		}); 
	  	//关闭批量申请
		$('#closeB').on('click', function(){
			$HUI.dialog('#LayerBatchApply').close();
		}); 
	}
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		obj.reloadgridApply();
	});
		
	//重新加载表格数据
	obj.reloadgridApply = function(){
  		
		var HospIDs	    = $("#cboHospital").combobox('getValue');
		var DateType	= $("#DateType").combobox('getValue');
		var DateFrom	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		var MonitorLoc 	= $("#cboMonitorLoc").combobox('getValue');
		var EvItem  	= $("#cboEvItem").combobox('getValue');
		var StatusCode 	= $("#cboRepStatus").combobox('getValue');
		var Standard 	= Common_RadioValue('checkStandard');
		var ErrorStr="";
	
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		if (DateFrom=="") {
			ErrorStr += '请选择监测开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择监测结束日期!<br/>';
		}
		
		if (DateFlag==1) {
			ErrorStr += '监测开始日期不能大于监测结束日期!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			$('#gridApply').datagrid('load',{
				ClassName:'DHCHAI.IRS.EnviHyReportSrv',
		        QueryName:'QryEvReport',
		        aHospIDs:HospIDs,
		        aDateType:DateType,
		        aDateFrom:DateFrom,
		        aDateTo:DateTo,
		        aMonitorLoc:MonitorLoc,
		        aItemID:EvItem,
		        aStatusCode:StatusCode,
		        aFlowFlg:"", //按标本状态筛查
		        aStandard:Standard
			});
		}
		$('#gridApply').datagrid('unselectAll');
	};
	
	obj.ShowResutlDtl=function(ReportID,EvItemDesc) {
		var rData = $('#gridApply').datagrid('getRows')[EvItemDesc];
		EvItemDesc=rData.EvItemDesc;
		var reg = RegExp(/紫外线/);
    	if (EvItemDesc.match(reg)){
			$HUI.datagrid('#ResultGrid',{
	        fit:true,
	        rownumbers:true,
	        pagination:false,
	        striped:true,
	        singleSelect:true,
	        fitColumns:false,
	        url:$URL,
	        bodyCls:'no-border',
	        queryParams:{
		        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
		        QueryName:'QryResultDetail',
		        aReportID:ReportID
		    },
		    
	        columns:[[
		        { field:"BarCode",title:"标本条码",width:180},
		        { field:"RstTypeDesc",title:"结果类型",width:100},
				{ field:"Result",title:"强度值",width:60},
				{ field:"BactDesc",title:"致病菌",width:200},
				{ field:"LogDate",title:"录入日期",width:100},
				{ field:"LogTime",title:"录入时间",width:80},
				{ field:"LogUserDesc",title:"录入人",width:100}
	        ]]
    	});
		}else{
			$HUI.datagrid('#ResultGrid',{
	        fit:true,
	        rownumbers:true,
	        pagination:false,
	        striped:true,
	        singleSelect:true,
	        fitColumns:false,
	        url:$URL,
	        bodyCls:'no-border',
	        queryParams:{
		        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
		        QueryName:'QryResultDetail',
		        aReportID:ReportID
		    },
		    
	        columns:[[
		        { field:"BarCode",title:"标本条码",width:180},
		        { field:"RstTypeDesc",title:"结果类型",width:100},
				{ field:"Result",title:"菌落数",width:60},
				{ field:"BactDesc",title:"致病菌",width:200},
				{ field:"LogDate",title:"录入日期",width:100},
				{ field:"LogTime",title:"录入时间",width:80},
				{ field:"LogUserDesc",title:"录入人",width:100}
	        ]]
    	});
			}
		
		
		$HUI.dialog('#ResultDetail').open();
	}
	obj.ReCheck=function(aReportID) {

		obj.Report=aReportID
		var SelectRows=$HUI.datagrid('#gridApply').getRows();
		var row="";
		for(var i=0;i<SelectRows.length;i++) {
			var srow=SelectRows[i]
			if (obj.Report==srow.ReportID){
				var row=srow;
				break ;
			}
		}
		if (row==""){
			$.messager.alert("错误提示","数据错误，无法复检！", 'info');
			return;
		}
		if (obj.IsValidReason==1){
			
		
			var tDate=Common_GetDate(new Date());
			Common_SetValue('ReCheckMonitorCDate',tDate);
			$HUI.combobox("#cboCEvItem",{
				//url:$URL+'?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&ResultSetType=Array&aIsActive=1&aLocID='+$('#cboALoc').combobox('getValue'),
				url:$URL+'?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID=',  //+row.ApplyLocID,
				valueField:'ID',
				textField:'ItemDesc',
				allowNull: true, 
				onLoadSuccess:function(){
					
				}
			});

			var EvObjectdata=$cm({
				ClassName:'DHCHAI.IRS.EnviHyItemSrv',
				QueryName:'QryEvObjsByItem',
				ResultSetType:'array',
				aParRef:row.EvItemObjID,
				aLocID:row.ApplyLocID	
			},false);
		
			$HUI.combobox("#cboCEvObject",{
				data:EvObjectdata,
				valueField:'ObjID',
				textField:'ObjDesc',
				editable:true
			});
			$('#cboCEvItem').combobox("setValue",row.EvItemID);
			$('#cboCEvObject').combobox("setValue",row.EvItemObjID);
			$('#cboCEvObject').combobox("setText",row.EvItemObjDesc);
			$('#cboCEvItem').combobox('disable');
			$('#cboCEvObject').combobox('disable');
			$("#txtReason").val(row.Reason);   //不合格原因
			$("#txtAction").val(row.Action);   // 改进措施
			var ReCheckRepID=row.ReCheckReps.split(",")[0]
			if (parseInt(ReCheckRepID)>0){
				
				var ReCheckRepInfo=$m({
					ClassName:'DHCHAI.IRS.EnviHyReportSrv',
					MethodName:'GetReportInfo',
					aReportID:ReCheckRepID,
					aBarcode:""
				},false);
				var status=ReCheckRepInfo.split("^")[12]
				var MonitorDate=ReCheckRepInfo.split("^")[11]
				if (status!=""){
					Common_SetValue('ReCheckMonitorCDate',MonitorDate);
					var statusCode=status.split("!!")[0]
					if (statusCode!="1"){
						$('#ReCheckMonitorCDate').datebox('disable');
					}
					if (statusCode=="5"){
						websys_disable("txtReason");
						websys_disable("txtAction");
					}
				}
			}
			$HUI.dialog('#ReCheck').open(); 
			$(".datebox .validatebox-text").css("width","280px")
		}else{
			$.messager.prompt("提示", "请填写复检监测日期", function (r) {
				if (r) {
					var MonitorDate=$('#ReCheckMonitorDate').datebox('getValue');
					var HospitalDr=row.HospID
					var ApplyLocDr=row.ApplyLocID
					var MonitorLocDr=row.MonitorLocID
					var EvItemDr=row.EvItemID 
					var EvObjectDr=row.EvItemObjID
					var EHItemObjTxt=row.EHItemObjTxt
					var SpecimenNum=row.SpecimenNum
					var CenterNum=row.RepCenterNum
					var SurroundNum=row.RepSurroundNum
					var ReferToNum=row.ReferToNum
					var IsObjNull=row.IsObjNull;	
					var ErrorStr = "";
					if (HospitalDr == '') {
						ErrorStr += '院区不允许为空！<br/>';	
					}
					if (ApplyLocDr == '') {
						ErrorStr += '科室不允许为空！<br/>';
					}
					if (MonitorDate == '') {
						ErrorStr += '监测日期不允许为空！<br/>';
					}
					if (EvItemDr == '') {
						ErrorStr += '监测项目不允许为空！<br/>';
					}
					if ((EvObjectDr == '')&&(EHItemObjTxt=="")) { 
						//ErrorStr += '监测对象不允许为空！<br/>';
					}
					if (SpecimenNum == 0) {
						ErrorStr += '标本数量不允许为空！<br/>';
					}
					if (ErrorStr != '') {
						$.messager.alert("错误提示",ErrorStr, 'info');
						return;
					}
				
					var InputStr = "";
					InputStr += "^" + EvItemDr;
					InputStr += "^" + EvObjectDr;
					InputStr += "^" + 1;
					InputStr += "^" + MonitorDate;
					InputStr += "^" + '';
					InputStr += "^" + '';
					InputStr += "^" + ApplyLocDr;
					InputStr += "^" + LogonUserID;
					InputStr += "^" + SpecimenNum;
					InputStr += "^" + CenterNum;
					InputStr += "^" + SurroundNum;
					InputStr += "^" + ''; 			//RepDate
					InputStr += "^" + ''; 			//RepTime
					InputStr += "^" + ''; 			//RepLocDr
					InputStr += "^" + ''; 			//RepUserDr
					InputStr += "^" + ''; 			//Standard
					InputStr += "^" + ''; 			//Resume
					InputStr += "^" + ''; 			//CollDate
					InputStr += "^" + ''; 			//CollTime
					InputStr += "^" + ''; 			//CollUserDr
					InputStr += "^" + ''; 			//RecDate
					InputStr += "^" + ''; 			//RecTime
					InputStr += "^" + ''; 			//RecUserDr
					InputStr += "^" + ''; 			//录入方式
					InputStr += "^" + 1; 			//IsReCheck
					InputStr += "^" + row.ReportID; //ReCheckRepDr
					InputStr += "^" + EHItemObjTxt; //ItemObjTxt
					InputStr += "^" + MonitorLocDr; 
					InputStr += "^" + ReferToNum; 	
					$m({
						ClassName:"DHCHAI.IR.EnviHyReport",
						MethodName:"Update",
						InStr:InputStr
					},function(retval){
						if (parseInt(retval)>0){
								// 环境卫生学监测检验标本 add by zhoubo 2020-12-04
								var retvalLog = $m({
									ClassName:"DHCHAI.DP.LabInfVisitNumber",
									MethodName:"SaveLabBarcode",
									aReportID:retval
								});
								// 保存日志
								var LogStr = retval;
								LogStr = LogStr + '^' + LogonLocID;
								LogStr = LogStr + '^' + LogonUserID;
								LogStr = LogStr + '^' + 1;
								LogStr = LogStr + '^' + '';
								var retvalLog = $m({
									ClassName:"DHCHAI.IR.EnviHyReportLog",
									MethodName:"Update",
									aInput:LogStr
								});
								$.messager.popover({msg: '复检申请成功！',type:'success',timeout: 2000});
								obj.reloadgridApply();
							}else{
								$.messager.alert("复检申请失败",retval, 'info');
							}
						}
					)
				}
			});
			 $(".messager-input").parent()
			 .append('<div style="text-align:center"><input id="ReCheckMonitorDate" style="width:180px;"></div>'); 
			 $('#ReCheckMonitorDate').datebox()
			 $('#ReCheckMonitorDate').datebox('setValue',Common_GetDate(new Date()));
			 $(".messager-input").hide();
			 $(".messager-input").val('true');
	    }
	}	
	/*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓以下全是不合格原因的修改↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
	//关闭申请
	$('#closeC').on('click', function(){
		$HUI.dialog('#ReCheck').close();
	})
	
	// 申请、修改申请记录
	$('#addC').on('click', function(){

		var SelectRows=$HUI.datagrid('#gridApply').getRows();
		var row="";
		for(var i=0;i<SelectRows.length;i++) {
			var srow=SelectRows[i]
			if (obj.Report==srow.ReportID){
				var row=srow;
				break ;
			}
		}
		if (row==""){
			$.messager.alert("错误提示","数据错误，无法复检！", 'info');
			return;
		}
		var MonitorDate=$('#ReCheckMonitorCDate').datebox('getValue');
		var cboCEvItem= $("#cboCEvItem").combobox('getValue');
		var cboCEvObject= $("#cboCEvObject").combobox('getValue');
		// 保存不合格原因和措施
		var Reason=$.trim($("#txtReason").val());   //不合格原因
		var Action=$.trim($("#txtAction").val());   // 改进措施
		
		var HospitalDr=row.HospID
		var ApplyLocDr=row.ApplyLocID
		var MonitorLocDr=row.MonitorLocID
		var EvItemDr=row.EvItemID 
		var EvObjectDr=row.EvItemObjID
		var EHItemObjTxt=row.EHItemObjTxt
		var SpecimenNum=row.SpecimenNum
		var CenterNum=row.RepCenterNum
		var SurroundNum=row.RepSurroundNum
		var ReferToNum=row.ReferToNum
		var IsObjNull=row.IsObjNull;	
		var ErrorStr = "";

		if (Action==""){
			ErrorStr += '改进措施不允许为空！<br/>';
			$("#txtAction").focus();			
		}
		if (Reason==""){
			ErrorStr += '不合格原因不允许为空！<br/>';	
			$("#txtReason").focus();
		}
		if (HospitalDr == '') {
			ErrorStr += '院区不允许为空！<br/>';	
		}
		if (ApplyLocDr == '') {
			ErrorStr += '科室不允许为空！<br/>';
		}
		if (MonitorDate == '') {
			ErrorStr += '监测日期不允许为空！<br/>';
			$("#ReCheckMonitorCDate").focus();		
		}
		if (EvItemDr == '') {
			ErrorStr += '监测项目不允许为空！<br/>';
		}
		if ((EvObjectDr == '')&&(EHItemObjTxt=="")) { 
			//ErrorStr += '监测对象不允许为空！<br/>';
		}
		if (SpecimenNum == 0) {
			ErrorStr += '标本数量不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		var InputStr = "";
		var ReCheckRepID=row.ReCheckReps.split(",")[0]
		/*判断是否已经复检过,如果复检过返回非空 */
		var Str=$m({
				ClassName:"DHCHAI.IR.EnviHyReCheck",
				MethodName:"GetValue",
				key:row.ReportID
			},false)      
		if ((Str!="")&&(parseInt(ReCheckRepID)>0)){     //已填复检单 -修改
			//单独修改时间和不合格原因
            
            //if (InputStr=="") return;
            
                var ReCheckRepInfo=$m({
                    ClassName:'DHCHAI.IRS.EnviHyReportSrv',
                    MethodName:'GetReportInfo',
                    aReportID:ReCheckRepID,
                    aBarcode:""
                },false);
                      
                if (ReCheckRepInfo!=""){
                    var status=ReCheckRepInfo.split("^")[12]       
                    var statusCode=status.split("!!")[0]
                    if (statusCode=="5"){
                        return;
                    }
                    
                    var ret1="",ret2=""
                    if (statusCode!="1"){
                        
                    }else{
                         ret1 = $m({
                           ClassName:"DHCHAI.IRS.EnviHyReportSrv",
                            MethodName:"ReCheckDate",
                            aReCheckRepId:ReCheckRepID,
                            aEHMonitorDate:MonitorDate
                           },false);
                    }
                    
                    var ret2 = $m({
                        ClassName:"DHCHAI.IR.EnviHyReCheck",
                        MethodName:"SetValue",
                        key:row.ReportID,
                        value:Reason+"^"+Action
                       },false);
                      if (ret2=="1"){
                         $.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
                         obj.reloadgridApply();
                       }else{
                         $.messager.alert("保存异常",ret1+"~"+ret2, 'info');
                       }
                }

		}else{
			// 未填复检单 添加
			ReCheckRepDr=row.ReportID    
			InputStr += "^" + EvItemDr;
			InputStr += "^" + EvObjectDr;
			InputStr += "^" + 1;
			InputStr += "^" + MonitorDate;
			InputStr += "^" + '';
			InputStr += "^" + '';
			InputStr += "^" + ApplyLocDr;
			InputStr += "^" + LogonUserID;
			InputStr += "^" + SpecimenNum;
			InputStr += "^" + CenterNum;
			InputStr += "^" + SurroundNum;
			InputStr += "^" + ''; 			//RepDate
			InputStr += "^" + ''; 			//RepTime
			InputStr += "^" + ''; 			//RepLocDr
			InputStr += "^" + ''; 			//RepUserDr
			InputStr += "^" + ''; 			//Standard
			InputStr += "^" + ''; 			//Resume
			InputStr += "^" + ''; 			//CollDate
			InputStr += "^" + ''; 			//CollTime
			InputStr += "^" + ''; 			//CollUserDr
			InputStr += "^" + ''; 			//RecDate
			InputStr += "^" + ''; 			//RecTime
			InputStr += "^" + ''; 			//RecUserDr
			InputStr += "^" + ''; 			//录入方式
			InputStr += "^" + 1; 			//IsReCheck
			InputStr += "^" + row.ReportID; //ReCheckRepDr
			InputStr += "^" + EHItemObjTxt; //ItemObjTxt
			InputStr += "^" + MonitorLocDr; 
			InputStr += "^" + ReferToNum; 	
			
			$m({
				ClassName:"DHCHAI.IR.EnviHyReport",
				MethodName:"Update",
				InStr:InputStr
			},function(retval){
				if (parseInt(retval)>0){
						// 环境卫生学监测检验标本 add by zhoubo 2020-12-04
						var retvalLog = $m({
							ClassName:"DHCHAI.DP.LabInfVisitNumber",
							MethodName:"SaveLabBarcode",
							aReportID:retval
						},false);
						// 保存不合格原因和措施
						var reason=$("#txtReason").val()   //不合格原因
						var action=$("#txtAction").val()   // 改进措施
						

						var retvalLog = $m({
							ClassName:"DHCHAI.IR.EnviHyReCheck",
							MethodName:"SetValue",
							key:row.ReportID,
							value:reason+"^"+action
						},false);
						// 保存日志
						var LogStr = retval;
						LogStr = LogStr + '^' + LogonLocID;
						LogStr = LogStr + '^' + LogonUserID;
						LogStr = LogStr + '^' + 1;
						LogStr = LogStr + '^' + '';
						var retvalLog = $m({
							ClassName:"DHCHAI.IR.EnviHyReportLog",
							MethodName:"Update",
							aInput:LogStr
						});
						
						$.messager.popover({msg: '复检申请成功！',type:'success',timeout: 2000});
						obj.reloadgridApply();
						
					}else{
						$.messager.alert("复检申请失败",retval, 'info');
					}
				}
			)

		}
			
		
		var ReCheckRepID="",IsReCheck="",ReportID=""
		$HUI.dialog('#ReCheck').close();
		
	})

	//不正确原因
	obj.LayerReason = function() {

		$HUI.dialog('#LayerReason',{	
            title:'不合格原因-选择',
			iconCls:'icon-w-paper',
			width: 317,  
			height:360,  
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'确认',
				handler:function(){	
					var ReasonList="";
					var rows = obj.gridReason.getChecked();			
					var length = obj.gridReason.getChecked().length;  
					for (i=0;i<length;i++) {
						var DicDesc = rows[i].DicDesc;
						ReasonList += DicDesc+" ";
					}
					var Reason = $("#txtReason").val(); 
					if (!Reason) {
						$('#txtReason').val(ReasonList);
					}else {
						$('#txtReason').val(Reason+ReasonList);
					}
					$HUI.dialog('#LayerReason').close();
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#LayerReason').close();}
			}]
		});
		$("#LayerReason .datagrid-wrap").css("border-color","#E2E2E2");
	}
	
	 obj.refreshgridReason = function(){
		obj.gridReason = $HUI.datagrid("#gridReason",{ 
			fit: false,
			height:264,
			width:300,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			pagination: false,
			rownumbers: true, //如果为true, 则显示一个行号列
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.BTS.DictionarySrv',
				QueryName:'QryDic',
				aTypeCode:'EnviHyReason',
				aActive:1
			},
			columns:[[
				{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
				{field:'ID',title:'ID',width:50,hidden:true},
                {field:'DicDesc',title:'不合格原因',width:240}
			]]
		});
    }
}

