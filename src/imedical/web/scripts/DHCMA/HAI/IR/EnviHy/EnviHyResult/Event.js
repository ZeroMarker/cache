//页面Event
function InitviewScreenEvent(obj){
	//按钮事件绑定
	obj.LoadEvent = function(args){
		
		obj.Maintabs_onSelect(0);
		
		//根据执行操作显示页签
		if (obj.StatusOrder.indexOf('|2|')<0) {
			$('#Maintabs').tabs('close', '发放材料');
		}
		if (obj.StatusOrder.indexOf('|3|')<0) {
			$('#Maintabs').tabs('close', '接收标本');
		}
		
		//查询按钮事件
		$('#btnFind').on('click', function(){
			obj.btnFind_onClick();
		});
		//导出按钮事件
		$('#btnExport').on('click', function(){
			obj.btnExport_onClick();
		});
		//发放材料事件
		$('#btnIssuMat').on('click', function(){
			obj.btnIssuMat_onClick();
		});
		//采集标本事件
		$('#btnColSpec').on('click', function(){
			obj.btnColSpec_onClick();
		});
		
		//接收标本事件
		$('#btnRecSpec').on('click', function(){
			obj.btnRecSpec_onClick();
		});
		//审核结果
		$('#btnChkReps').on('click', function(){
			obj.btnCheckRep_onClick();
		});
		//打印条码
		$('#btnBarcode').on('click', function(){
			obj.btnBarcode_onClick();
		});
		//打印报告
		$('#btnPrtReps').on('click', function(){
			$.messager.alert("提示","打印报告开发中", 'info');
		});
		//条码回车事件
		/* $('#txtBarcode').bind('keydown', function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if (code == 13) {
				obj.txtBarcode_onKeydown();
			}
		}); */
		$('#txtBarcode').on('keyup', function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if (code == 13) {
				obj.txtBarcode_onKeydown();
			}
		});
	
		for (var indSpec = 1; indSpec <= 20; indSpec++){
			//结果类型 下拉框
			Common_ComboDicCode("cboRstType"+indSpec,"EHRstType",0);
			//致病菌 放大镜
			Common_LookupToBact("txtRstBactDesc"+indSpec,"txtRstBactID"+indSpec);
		}
	}
    
    $('#txtMonitorLocDesc').bind('change', function (e) {  //监测科室
		if($('#txtMonitorLocDesc').lookup("getText")==""){
			$("#txtMonitorLocID").val('');            //给监测科室隐藏元素赋值
		}
	});
	
    //tab页签切换
	$HUI.tabs("#Maintabs", {
		onSelect: function (title,index){
			obj.Maintabs_onSelect(index);
		}
	});
	
	//页签事件
	obj.Maintabs_onSelect = function(tabNo){
		$('#btnBarcode').hide();
		$('#btnIssuMat').hide();
		$('#btnColSpec').hide();
		$('#btnRecSpec').hide();
		$("#txtBarcode").hide();
		$("#btnChkReps").hide();
		var tab=$("#Maintabs").tabs('getSelected');
		var ContentID=tab.children('div')[0].lastChild.id;
		obj.TabArgs.ContentID   = ContentID;
		$('#'+ContentID).append(Maintabs_table);
	
		//寻找当前状态的前一个状态ID
		//1申请、2发放材料、3接收标本、4录入结果、5审核结果、6采集标本
		var CurrentStatusCode="",BeforeStatusCode="",BeforeStatusDesc="";
		switch (ContentID) {
			case 'Maintabs_Qry':
				CurrentStatusCode="";
				break;
			case 'Maintabs_IssuMat':
				CurrentStatusCode='2';  //发放材料
				break;
			case 'Maintabs_ColSpec':
				CurrentStatusCode='6'; //采集标本
				break;
			case 'Maintabs_RecSpec':
				CurrentStatusCode='3'; //接收标本
				break;
			case 'Maintabs_WriteReps':
				CurrentStatusCode='4'; //录入结果
				break;
			case 'Maintabs_CheckReps':
				CurrentStatusCode='5';
				break;
			default:
				CurrentStatusCode='';
				break;
		}
	   	StatusOrderArr=obj.StatusDicList.split(',');
		var StatusLength = StatusOrderArr.length;
	    for(var i = 0;i < StatusLength;i++){
		    if (StatusOrderArr[i]=="") continue;
	        if(StatusOrderArr[i].split('^')[0] == CurrentStatusCode){
	            BeforeStatusCode=StatusOrderArr[i-1].split('^')[0];
	            BeforeStatusDesc=StatusOrderArr[i-1].split('^')[1];
	            break
	        }
	    }
		
		$('#cboStatus').combobox('setValue',BeforeStatusCode);
		$('#cboStatus').combobox('setText',BeforeStatusDesc);
		obj.gridReusltLoad();
	}
    
	obj.gridReusltLoad = function(){
	
		$("#gridReuslt").datagrid("loading");
		$cm ({
			ClassName     : "DHCHAI.IRS.EnviHyReportSrv",
			QueryName     : "QryReportByDate",
			ResultSetType :"array",
			aHospIDs      : $('#cboHospital').combobox('getValue'),
			aDateFrom     : $('#txtStartDate').datebox('getValue'),
			aDateTo       : $('#txtEndDate').datebox('getValue'),
			aMonitorLocDr : $('#txtMonitorLocID').val(),
			aItemDr       : '',  //监测项目ID
			aStatusCode   : $('#cboStatus').combobox('getValue'),
			aStandardCode : $('#cboStandard').combobox('getValue'),
			page:1,
			rows:50
		},function(rs){
			$('#gridReuslt').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);			
		});
	}

	obj.btnFind_onClick = function(){
		var DateFrom	= $('#txtStartDate').datebox('getValue');
		var DateTo 		= $('#txtEndDate').datebox('getValue');
		var ErrorStr="";
		if (DateFrom=="") {
			ErrorStr += '请选择监测开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择监测结束日期!<br/>';
		}
		if (DateFrom > DateTo) {
			ErrorStr += '监测开始日期不能大于监测结束日期!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		//结果列表
		obj.gridReusltLoad();
	}
	
	//弹出结果录入页面
	obj.winEnterResult_show = function(aRepId,aBarcode){
		var objRep = obj.GetReport(aRepId,aBarcode);
		if (!objRep) {
			$.messager.alert("错误提示", "监测报告单获取有误，请检查!", 'info');
			return;
		}
		if (objRep.StatusCode == '5'){
			obj.winEnterResult_layer(objRep,0);  //不可编辑
		} else if (objRep.StatusCode == '4'){
			obj.winEnterResult_layer(objRep,1);  //可编辑
		} else {
			if (obj.StatusOrder.indexOf('|3|')>-1) {
				if (objRep.StatusCode != '3') {
					$.messager.alert("错误提示", "非【接收标本】状态,不允许【录入结果】操作!", 'info');
					return;
				} else if (objRep.IsAllDone != '1'){
					$.messager.alert("错误提示", "标本未全部接收,不允许【录入结果】操作!", 'info');
					return;
				}
					
			} else if (obj.StatusOrder.indexOf('|6|')>-1) {
				if (objRep.StatusCode != '6') {
					$.messager.alert("错误提示", "非【采集标本】状态,不允许【录入结果】操作!", 'info');
					return;
				}
			} else if (obj.StatusOrder.indexOf('|2|')>-1) {
				if (objRep.StatusCode != '2') {
					$.messager.alert("错误提示", "非【发放材料】状态,不允许【录入结果】操作!", 'info');
					return;
				}
			} else {
				if (objRep.StatusCode != '1') {
					$.messager.alert("错误提示", "非【申请】状态,不允许【录入结果】操作!", 'info');
					return;
				}
			}
			obj.winEnterResult_layer(objRep,1);  //可编辑
		}
	}
	
    //录入结果窗体-初始化
	obj.winEnterResult_layer= function(objRep,isEdit){
		obj.ReportObj = objRep;
		obj.arrResult = obj.GetResult(objRep.ReportID,objRep.Barcode);
		if (obj.arrResult.length<1) return;
		
		$('#txtRstItem').val(objRep.ItemDesc);
		var ItemObjValue=objRep.ItemObjDesc;
		if (ItemObjValue=="") ItemObjValue=objRep.ItemObjTxt;
		$('#txtRstObject').val(ItemObjValue);
		
		//中心值、周边值、项目值、参照值-->赋值
		$.each($("#tableEnterResult tr"),function(index){
			if (index<1) {
				$(this).show();
			} else {
				var objResult = obj.arrResult[index];
				if (objResult){
					$(this).show();
					$('#cboRstType'+index).combobox({disabled:(!isEdit)});
					$('#txtResult'+index).attr("disabled",(!isEdit));
					$('#txtRstBactDesc'+index).lookup({disabled:(!isEdit)});
				} else {
					$(this).hide();
				}
			}
		})
		$('#txtRstItem').attr("disabled",true);
		$('#txtRstObject').attr("disabled",(!isEdit));
		if (!isEdit){
			$('#winEnterResult_btnSave').hide();
		} else {
			$('#winEnterResult_btnSave').show();
		}
		
		//表单设置初始值
		for (var row = 1; row <= 20; row++){
			var objResult = obj.arrResult[row];
			if (objResult){
				$("#lblItemNum"+row).text(objResult.SpecNumDesc);
				$('#cboRstType'+row).combobox('setValue',objResult.RstTypeCode);
				$('#cboRstType'+row).combobox('setText',objResult.RstTypeDesc);
				$('#txtResult'+row).val(objResult.Result);
				$('#txtRstBactID'+row).val(objResult.BactID);
				$('#txtRstBactDesc'+row).val(objResult.BactDesc);
			}
		}
		
		//录入结果弹窗
		$HUI.dialog('#winEnterResult').open();
	}
	
	//结果保存事件
	obj.winEnterResult_btnSave_click = function(){
		//录入结果信息（中心值、周边值、项目值、参照值-->取值）
		var resultInfo = '';
		var ErrorMsg="";
		$.each($("#tableEnterResult tr"),function(index){
			if (index>0) {
				var objResult = obj.arrResult[index];
				if (objResult){
					objResult.RstTypeCode  = $('#cboRstType'+index).combobox('getValue');
					objResult.RstTypeDesc  = $('#cboRstType'+index).combobox('getText');
					objResult.Result       = $('#txtResult'+index).val();
					objResult.BactID       = $('#txtRstBactID'+index).val();
					objResult.BactDesc     = $('#txtRstBactDesc'+index).val();
			
					if (((objResult.RstTypeDesc!="未检出")&&(!objResult.Result)) ||(!objResult.RstTypeCode)){
						ErrorMsg = ErrorMsg+ '第'+index+'行请录入正确的结果信息！</br>'
					}
					
					var rowInfo = objResult.SpecNumber + '^' + objResult.SpecNumDesc + '^' + objResult.RstTypeCode + '^' + objResult.RstTypeDesc + '^' + objResult.Result + '^' + objResult.BactID + '^' + objResult.BactDesc
					
					if (resultInfo!=''){
						resultInfo += '!!' + rowInfo;
					} else {
						resultInfo = rowInfo;
					}
				}
			}
		});
		
		if (ErrorMsg) {
			bClose = false;
			$.messager.alert("提示",ErrorMsg, 'info');
			return;
		}
	
		//基本信息
		var baseInfo = obj.ReportObj.ReportID;
		baseInfo += '^' + obj.ReportObj.Barcode;
		baseInfo += '^' + LogonLocID;
		baseInfo += '^' + LogonUserID;
		baseInfo += '^' + '4';  //4录入结果
		
		var flg = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "SaveReportResults",
			aBaseInfo   : baseInfo,
			aResultInfo : resultInfo
		},false);
		if (parseInt(flg) < 1) {
			bClose = false;
			$.messager.alert("错误提示","录入结果操作错误!Error=" + flg, 'info');
			return ;
		} else {
			bClose = true;
			$.messager.popover({msg: '录入结果操作成功！',type:'success',timeout: 1000});
			$('#txtBarcode').val();
			obj.gridReusltLoad() ;//刷新
		}
	}
	
	//获取当前时间
	function getFormatDate(){
    	var nowDate = new Date();
    	var year 	= nowDate.getFullYear();
    	var month 	= nowDate.getMonth() + 1 < 10 ? "0" + (nowDate.getMonth() + 1) : nowDate.getMonth() + 1;
   	 	var date 	= nowDate.getDate() < 10 ? "0" + nowDate.getDate() : nowDate.getDate();
    	var hour 	= nowDate.getHours()< 10 ? "0" + nowDate.getHours() : nowDate.getHours();
    	var minute 	= nowDate.getMinutes()< 10 ? "0" + nowDate.getMinutes() : nowDate.getMinutes();
    	var second 	= nowDate.getSeconds()< 10 ? "0" + nowDate.getSeconds() : nowDate.getSeconds();
    	return year + "" + month + "" + date+""+hour+""+minute+""+second;
	}
	
	//导出功能
	obj.btnExport_onClick = function(){		
		var rows = obj.gridReuslt.getRows().length;  
		if (rows>0) {
			$('#gridReuslt').datagrid('toExcel', getFormatDate()+'检验工作站查询.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	//发放材料操作
	obj.btnIssuMat_onClick = function(){
		var rows = obj.gridReuslt.getRows().length;
		if (rows>0) {
			var chkRows = obj.gridReuslt.getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量发放材料?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['ReportID'];
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
							aStatusCode : 2,
							aLogonLocDr : LogonLocID,
							aLogonUserDr: LogonUserID
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","发放材料操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '发放材料操作成功！',type:'success',timeout: 1000});
							obj.gridReusltLoad() ;//刷新
						}
					}
				});
			} else {
				$.messager.alert("提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("确认", "无记录,不可操作!", 'info');
			return;
		}
	}
	obj.btnColSpec_onClick = function(){
		var rows = obj.gridReuslt.getRows().length;
		if (rows>0) {
			var chkRows = obj.gridReuslt.getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量采集标本?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['ReportID'];
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
							obj.gridReusltLoad();//刷新
						}
					}
				});
			} else {
				$.messager.alert("提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("确认", "无记录,不可操作!", 'info');
			return;
		}
	}
	//接收标本操作
	obj.btnRecSpec_onClick = function(){
		var rows = obj.gridReuslt.getRows().length;
		if (rows>0) {
			var chkRows = obj.gridReuslt.getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量接收标本?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['ReportID'];
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
							aStatusCode : 3,  //3接收标本
							aLogonLocDr : LogonLocID,
							aLogonUserDr: LogonUserID
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","接收标本操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '接收标本操作成功！',type:'success',timeout: 1000});
							obj.gridReusltLoad() ;//刷新
						}
					}
				});
			} else {
				$.messager.alert("错误提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("错误提示", "无记录,不可操作!", 'info');
			return;
		}
	}
	//审核结果
	obj.btnCheckRep_onClick = function(){
		var rows = obj.gridReuslt.getRows().length;
		if (rows>0) {
			var chkRows = obj.gridReuslt.getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量审核报告?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['ReportID'];
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
							aStatusCode : 5,  //3接收标本
							aLogonLocDr : LogonLocID,
							aLogonUserDr: LogonUserID
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","审核报告操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '审核报告操作成功！',type:'success',timeout: 1000});
							obj.gridReusltLoad() ;//刷新
						}
					}
				});
			} else {
				$.messager.alert("错误提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("错误提示", "无记录,不可操作!", 'info');
			return;
		}
	}
	//打印条码
	obj.btnBarcode_onClick = function() {
		var checkedRows=$HUI.datagrid('#gridReuslt').getChecked();
		if (checkedRows.length<1) {$.messager.alert("错误提示","请勾选申请记录进行打印！", 'info'); return;}
		for (var j=0;j<checkedRows.length;j++) {
			var rd=checkedRows[j];
			var ID = rd["ReportID"];
			var ItemDesc = rd["ItemDesc"];
			var NormDesc = rd["NormDesc"];
			var NormMax = rd["NormMax"];
			var NormMin = rd["NormMin"];
			var CenterNum = rd["CenterNum"];
			var SurroundNum = rd["SurroundNum"];
			var SpecimenNum = rd["SpecimenNum"];
			var BarCode = rd["BarCode"];
			var MonitorDate = rd['MonitorDate'];
			var ApplyLocDesc = rd['ApplyLocDesc'];
			var ItemObjDesc = rd['ItemObjDesc'];
			if (ItemObjDesc=="") ItemObjDesc = rd['ItemObjTxt'];
			
			SpecimenNum = SpecimenNum*1;
			CenterNum   = CenterNum*1;
			SurroundNum = SurroundNum*1;
			for(var i = 1; i <= SpecimenNum; i++){
				//条码：8位检验码+2位标本编码
				var SubBarCode = '00' + i;
				SubBarCode = SubBarCode.substring(SubBarCode.length-2,SubBarCode.length);
				vBarCode = "*"+BarCode + SubBarCode+"*";
				
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
				vItemDate   = MonitorDate + '【' + SubItemDesc + '/' + SpecimenNum + '】';
				//条码打印
				PrintXMLBar(ItemDesc,ItemObjDesc,vItemDate,ApplyLocDesc,vBarCode);
			}
		}
	};
	
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
	     // 打印控件
	     var printControlObj=document.getElementById("barPrintControl");	
		 DHCP_XMLPrint(printControlObj,printParam,printList);
	}
	
	//条码输入事件（目前只有3接收标本、4录入结果有条码操作）
	obj.txtBarcode_onKeydown = function(){
		var barcode = $('#txtBarcode').val();
		if (barcode.length==8) { //项目条码
			var ReportID = parseInt(barcode);
			var objRep = obj.GetReport(ReportID);
		} else {  //标本条码
			var objRep = obj.GetReport('',barcode);
		}
		if (objRep) {
			$('#txtBarcode').val(objRep.Barcode);  //条码回写到输入框
			var BarNumber = objRep.Barcode.substring(8,10);  //判断条码数与标本数大小
			var SpecimenNum = objRep.SpecimenNum;
			if ((BarNumber>SpecimenNum)||((objRep.Barcode == '')&&(barcode.length!=8))){
				$.messager.alert("错误提示", "条码为空或错误!", 'info');
				return;
			}
		} else {
			$.messager.alert("错误提示", "监测报告单获取有误，请检查!", 'info');
			return;
		}
		//条码操作
		if (obj.TabArgs.ContentID.indexOf('RecSpec')>-1){
			//接收标本
			if (objRep.StatusCode != '3'){
				if (obj.StatusOrder.indexOf('|6|')>-1) {
					if (objRep.StatusCode != '6') {
						$.messager.alert("错误提示", "非【采集标本】状态,不允许【接收标本】操作!", 'info');
						return;
					}
				} else if (obj.StatusOrder.indexOf('|2|')>-1) {
					if (objRep.StatusCode != '2') {
						$.messager.alert("错误提示", "非【发放材料】状态,不允许【接收标本】操作!", 'info');
						return;
					}
				} else {
					if (objRep.StatusCode != '1') {
						$.messager.alert("错误提示", "非【申请】状态,不允许【接收标本】操作!", 'info');
						return;
					}
				}
			}
			var flg = $m({
				ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
				MethodName  : "SaveBactRepOpera",
				aReportIDs  : objRep.ReportID,
				aBarcode    : objRep.Barcode,
				aStatusCode : 3,  //3接收标本
				aLogonLocDr : LogonLocID,
				aLogonUserDr: LogonUserID
			},false);
			if (parseInt(flg) < 1) {
				$.messager.alert("错误提示","接收标本操作错误!Error=" + flg, 'info');
			} else {
				$.messager.popover({msg: '接收标本操作成功！',type:'success',timeout: 1000});
				$('#txtBarcode').val();
				obj.gridReusltLoad() ;//刷新
			}
		} else if (obj.TabArgs.ContentID.indexOf('WriteReps')>-1){
			//录入结果
			if (objRep.StatusCode == '5'){
				obj.winEnterResult_layer(objRep,0);  //不可编辑
			} else if (objRep.StatusCode == '4'){
				obj.winEnterResult_layer(objRep,1);  //可编辑
			} else {
				if (obj.StatusOrder.indexOf('|3|')>-1) {
					if (objRep.StatusCode != '3') {
						$.messager.alert("错误提示", "非【接收标本】状态,不允许【录入结果】操作!", 'info');
						return;
					} else if (objRep.IsAllDone != '1'){
						$.messager.alert("错误提示", "标本未全部接收,不允许【录入结果】操作!", 'info');
						return;
					}
				} else if (obj.StatusOrder.indexOf('|6|')>-1) {
					if (objRep.StatusCode != '6') {
						$.messager.alert("错误提示", "非【采集标本】状态,不允许【录入结果】操作!", 'info');
						return;
					}
				} else if (obj.StatusOrder.indexOf('|2|')>-1) {
					if (objRep.StatusCode != '2') {
						$.messager.alert("错误提示", "非【发放材料】状态,不允许【录入结果】操作!", 'info');
						return;
					}
				} else {
					if (objRep.StatusCode != '1') {
						$.messager.alert("错误提示", "非【申请】状态,不允许【录入结果】操作!", 'info');
						return;
					}
				}
			}
			obj.winEnterResult_layer(objRep,1);  //可编辑
		} else {}
	}
	
	//获取报告对象
	obj.GetReport = function(aRepId,aBarcode){
		var repInfo = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "GetReportInfo",
			aReportID   : aRepId,
			aBarcode    : aBarcode
		},false);
	
		if (!repInfo) return '';
		
		var arrInfo = repInfo.split('^');
		var objRep = new Object();
		objRep.ReportID        = arrInfo[0];
		objRep.Barcode         = arrInfo[1];
		objRep.ItemDesc        = arrInfo[2];
		objRep.SpecTypeCode    = arrInfo[3].split('!!')[0];
		objRep.SpecTypeDesc    = arrInfo[3].split('!!')[1];
		objRep.Norm            = arrInfo[4];
		objRep.NormMax         = arrInfo[5];
		objRep.NormMin         = arrInfo[6];
		objRep.ForMula         = arrInfo[7];
		objRep.ItemUom         = arrInfo[8];
		objRep.IsObjNull       = arrInfo[9];
		objRep.ItemObjID       = arrInfo[10].split('!!')[0];
		objRep.ItemObjDesc     = arrInfo[10].split('!!')[1];
		objRep.ItemObjTxt      = arrInfo[10].split('!!')[2];
		objRep.MonitorDate     = arrInfo[11];
		objRep.StatusCode      = arrInfo[12].split('!!')[0];
		objRep.StatusDesc      = arrInfo[12].split('!!')[1];
		objRep.IsAllDone       = arrInfo[12].split('!!')[2];
		objRep.SpecimenNum     = arrInfo[13].split('!!')[0];
		objRep.CenterNum       = arrInfo[13].split('!!')[1];
		objRep.SurroundNum     = arrInfo[13].split('!!')[2];
		objRep.ReferToNum      = arrInfo[13].split('!!')[3];
		objRep.StandardCode    = arrInfo[14].split('!!')[0];
		objRep.StandardDesc    = arrInfo[14].split('!!')[1];
		objRep.EnterTypeCode   = arrInfo[15].split('!!')[0];
		objRep.EnterTypeDesc   = arrInfo[15].split('!!')[1];
		objRep.IsReCheck       = arrInfo[16];
		objRep.ReCheckRepDr    = arrInfo[17];
		objRep.ApplyDate       = arrInfo[18].split('!!')[0];
		objRep.ApplyTime       = arrInfo[18].split('!!')[1];
		objRep.ApplyLoc        = arrInfo[18].split('!!')[2];
		objRep.ApplyUser       = arrInfo[18].split('!!')[3];
		objRep.CollDate        = arrInfo[18].split('!!')[0];
		objRep.CollTime        = arrInfo[18].split('!!')[1];
		objRep.CollUser        = arrInfo[18].split('!!')[2];
		objRep.RecDate         = arrInfo[18].split('!!')[0];
		objRep.RecTime         = arrInfo[18].split('!!')[1];
		objRep.RecUser         = arrInfo[18].split('!!')[2];
		objRep.RepDate         = arrInfo[18].split('!!')[0];
		objRep.RepTime         = arrInfo[18].split('!!')[1];
		objRep.RepLoc          = arrInfo[18].split('!!')[2];
		objRep.RepUser         = arrInfo[18].split('!!')[3];
		return objRep
	}
	
	//获取报告对象
	obj.GetResult = function(aRepId,aBarcode){
		var rstInfo = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "GetReportResults",
			aReportID  : aRepId,
			aBarcode    : aBarcode
		},false);
		if (!rstInfo) return '';
		
		var arrInfo = rstInfo.split('!!');
		var arrResult = new Array();
		for (indRow = 0; indRow < arrInfo.length; indRow++){
			var rowInfo = arrInfo[indRow];
			if (!rowInfo) continue;
			var rd = rowInfo.split('^');
			var objResult = new Object();
			objResult.SpecNumber   = rd[0];
			objResult.SpecNumDesc  = rd[1];
			objResult.RstTypeCode  = rd[2];
			objResult.RstTypeDesc  = rd[3];
			objResult.Result       = rd[4];
			objResult.BactID       = rd[5];
			objResult.BactDesc     = rd[6];
			arrResult[objResult.SpecNumber] = objResult;
		}
		return arrResult
	}
	obj.winReportLog_show = function(ReportID){
		$HUI.datagrid('#RepStatusGrid',{
	        fit:true,
	        rownumbers:true,
	        pagination:false,
	        striped:true,
	        singleSelect:true,
	        fitColumns:false,
	        url:$URL,
	        queryParams:{
		        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
		        QueryName:'QryRepStatus',
		        aReportID:ReportID
		    },
	        columns:[[
		        { field:"UpdateStatus",title:"状态",width:'100'},
		        { field:"UpdateLocDesc",title:"操作科室",width:'100'},
				{ field:"UpdateUser",title:"操作人",width:'120'},
				{ field:"UpdateDate",title:"操作日期",width:'100'},
				{ field:"UpdateTime",title:"操作时间",width:'80'},
				{ field:"BatchNumber",title:"批次号",width:'160'}
	        ]]
	    });
		$HUI.dialog('#winStatusList').open();
	}
}

