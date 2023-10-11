//页面Event
function InitviewScreenEvent(obj){
	var checkedRows=""
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
		//批量修改状态
		$('#bacthChStatus').on('click', function(){
			 checkedRows=$HUI.datagrid('#gridReuslt').getChecked();
			if (checkedRows.length<1) {$.messager.alert("错误提示","请勾选申请记录进行状态修改！", 'info'); return;}
			for (var j=0;j<checkedRows.length;j++) {
				var rd=checkedRows[j];
				var objRep = obj.GetReport(rd["ReportID"],rd["BarCode"]);
				if (!objRep){
					$.messager.alert("错误提示", "申请日期时间为:"+rd["ApplyDate"]+" "+rd["ApplyTime"]+"的"+$g(rd["ItemDesc"])+" 监测报告单获取有误，请检查!", 'info');
					return;
				}
				if ((rd["StatusCode"]=='4')||(rd["StatusCode"]=='5')){
					$.messager.alert("错误提示", "申请日期时间为:"+rd["ApplyDate"]+" "+rd["ApplyTime"]+"的"+$g(rd["ItemDesc"])+" 监测报告单状态为录入结果或者审核结果,不允许修改状态!", 'info');
					return;
				}
			}
			$HUI.dialog('#winUpdateStatus1').open();
		});
//		//打印报告
//		$('#btnPrtReps').on('click', function(){
//			$.messager.alert("提示","打印报告开发中", 'info');
//		});
			//打印报告改为润乾预览打印
	$('#btnPrtReps').click(function(e){
		var checkedRows=$HUI.datagrid('#gridReuslt').getChecked();
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
			var RepStatusDesc=rd["StatusDesc"];
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

		for (var indSpec = 1; indSpec <= EnviHyMaxSpecimen; indSpec++){
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
		var ContentID=tab[0].id;
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
			aItemDr       : $('#cboEvItem').combobox('getValues').toString(),  //监测项目ID
			aStatusCode   : $('#cboStatus').combobox('getValue'),
			aStandardCode : $('#cboStandard').combobox('getValue'),
			aBarCode:$('#barcode').val(),
			page:1,
			rows:50
		},function(rs){
			$('#gridReuslt').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
			setTimeout(function(){
				$("#txtBarcode").val("").focus();
			},100);	
		});
	}
	$(document).keydown(function(event) {
	if (event.keyCode == 13) {
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
		//var aItemDr		= $("#cboEvItem").combobox('getValues');
		//结果列表
		obj.gridReusltLoad();
            }
        });
	obj.btnFind_onClick = function(){
		var DateFrom	= $('#txtStartDate').datebox('getValue');
		var DateTo 		= $('#txtEndDate').datebox('getValue');
		var BarCode     = $('#barcode').val();
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
		//var aItemDr		= $("#cboEvItem").combobox('getValues');
		//结果列表
		obj.gridReusltLoad();
	}
	//弹出修改状态页面
	obj.winUpStatus_show = function(aRepId,aBarcode){
		var objRep = obj.GetReport(aRepId,aBarcode);
		if (!objRep) {
			$.messager.alert("错误提示", "监测报告单获取有误，请检查!", 'info');
			return;
		}
		obj.ReportObj = objRep;
		if ((objRep.StatusCode == '4')||(objRep.StatusCode == '5')){
			$.messager.alert("错误提示", "录入结果状态的报告不允许修改状态!", 'info');
			return;
		}
		//修改状态弹窗
		$HUI.dialog('#winUpdateStatus').open();
	}
	//弹出结果录入页面
	obj.winEnterResult_show = function(aRepId,aBarcode){
		var objRep = obj.GetReport(aRepId,aBarcode);
		obj.ReportObj = objRep;
		obj.arrResult = obj.GetResult(objRep.ReportID,objRep.Barcode);
		if (obj.arrResult.length>8){
			$("#winEnterResult .r-label").css("padding-right","0px")
		}else{
			$("#winEnterResult .r-label").css("padding-right","10px")
		}
		if (!objRep) {
			$.messager.alert("错误提示", "监测报告单获取有误，请检查!", 'info');
			return;
		}
		if (objRep.StatusCode == '5'){
			obj.winEnterResult_layer(objRep,0);  //不可编辑
			$("#txtBarcode").val("").focus();
		} else if (objRep.StatusCode == '4'){
			obj.winEnterResult_layer(objRep,1);  //可编辑
			$("#txtBarcode").val("").focus();
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
					$("#txtBarcode").val("").focus();
					return;
				}
			}
			if(objRep.SpecTypeCode==19) {
				$("#BatchEnterResult").html("");
				var html= "<table class='easyui-datagrid' style='text-align:center;width:580px;' id ='BatchApply'>"  
	   			var html=html+  '<tr style="height:30px;">'
				var html=html+	'<td class="selectAll" style="width:60px;padding-bottom:10px;background-color:#F4F4F4;">'
				var html=html+	'<input class="hisui-checkbox " id="checkAll" name ="checkAllApply" type="checkbox"  data-options="checked:false" >'
				var html=html+	'</td>'
				var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">申请号</td>'
				var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">项目名称</td>'
				var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">监测对象</td>'
				var html=html+	'<td class="r-label" style="text-align:center;background-color:#F4F4F4;">监测结果</td>'
				var html=html+  '</tr>'
				var ExtTypeIDs= $cm({
	        		ClassName: "DHCHAI.IRS.EnviHyReportSrv",
	        		QueryName: "QryReportByDate",
	        		aHospIDs      : $('#cboHospital').combobox('getValue'),
					aDateFrom     : $('#txtStartDate').datebox('getValue'),
					aDateTo       : $('#txtEndDate').datebox('getValue'),
					aMonitorLocDr : $('#txtMonitorLocID').val(),
					aItemDr       : $('#cboEvItem').combobox('getValue'),  //监测项目ID
					aStatusCode   : $('#cboStatus').combobox('getValue'),
					aStandardCode : $('#cboStandard').combobox('getValue'),
					page:1,
					rows:50,
	       			ItemID:""
	    		}, false);
  
    			for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
	    			var ExtTypeData    = ExtTypeIDs.rows[ind];
	    			var SpecTypeDesc   = ExtTypeData.SpecTypeDesc
	    			var	xID        	   = ExtTypeData.ReportID;
	    			var ItemDesc	   = ExtTypeData.ItemDesc;
	    			var BarCode	       = ExtTypeData.BarCode;
	    			var ItemObjDesc	   = ExtTypeData.ItemObjDesc;
	    			var checkItem      = SpecTypeDesc.indexOf("新冠")
					if(checkItem!=-1){
						var html=html+  '<tr style="padding:10px;">'
						var html=html+	'<td class="selectAll" style="padding-bottom:10px;">'
						var html=html+	'<input class="hisui-checkbox " id="check'+xID+'" name ="selectApply" type="checkbox"  data-options="checked:false" >'
						var html=html+	'</td>'
						var html=html+	'<td style="padding-bottom:10px;width:150px">'
						var html=html+		'<input class="textbox" disabled style=" text-align:center;width:150px;background-color:#FFFFFF;border:1px solid #9ed2f2;color:black" value='+BarCode+'>'
						var html=html+	'</td>'
						var html=html+	'<td style="padding-bottom:10px;width:150px">'
						var html=html+		'<input class="textbox" disabled style=" text-align:center;width:150px;background-color:#FFFFFF;border:1px solid #9ed2f2;color:black" value='+ItemDesc+'>'
						var html=html+	'</td>'
						
						var html=html+	'<td style="padding-bottom:10px;width:126px">'
						var html=html+			'<input class="textbox" disabled style=" text-align:center;width:126px;background-color:#FFFFFF;border:1px solid #9ed2f2;color:black" value='+ItemObjDesc+'>'
						var html=html+	'</td>'
						var html=html+	'<td style="padding-bottom:10px;width:100px">'
						var html=html+		'<input class="hisui-combobox" id="cboBatObject'+xID+'" style="text-align:center;width:100px">'
						var html=html+	'</td>'
						var html=html+  '</tr>'	
					}
    			}
    			var html=html+  '</table>'
    			
    			if(0<=ExtTypeIDs.total&&ExtTypeIDs.total<=7){
	   				var html=html+  '<div id="Abutton" align="center" style="position:absolute;left:50%;bottom:10px;transform:translateX(-50%)">'
   					var html=html+  '<a href="#" id="addB"  class="hisui-linkbutton hover-dark" style="margin-right:20px">保存</a>'
   					var html=html+  '<a href="#" id="closeB"  class="hisui-linkbutton hover-dark">关闭</a>'
   					var html=html+  '</div>'
	   			}else{
					var html=html+  '<div id="Abutton" align="center" >'
   					var html=html+  '<a href="#" id="addB" class="hisui-linkbutton hover-dark" style="margin-right:20px" >保存</a>'
   					var html=html+  '<a href="#" id="closeB" class="hisui-linkbutton hover-dark">关闭</a>'
   					var html=html+  '</div>'
		   		}
				$("#BatchEnterResult").append(html);
				$.parser.parse("#BatchEnterResult");
				
				//全选事件
				$('#checkAll').click(function() {
					var check=$('#checkAll').is(':checked');
					if(check){
						for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
							var ExtTypeData    = ExtTypeIDs.rows[ind];
							var	xID            = ExtTypeData.ReportID;
							$("#check"+xID).checkbox('setValue', true);
						} 
					}else{
						for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
							var ExtTypeData    = ExtTypeIDs.rows[ind];
							var	xID            = ExtTypeData.ReportID;
							$("#check"+xID).checkbox('setValue', false);
						} 
					}
				});
				//数据填充
				var EHRstTypes= $cm({
    				ClassName: "DHCHAI.BTS.DictionarySrv",
    				QueryName: "QryDic",
    				aTypeCode: "EHRstType",
    				aEnterRstType:1,
    				ResultSetType:'array',
    				aActive:1,
    				aFlag:1
        		}, false);	
				for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
					var ExtTypeData    = ExtTypeIDs.rows[ind];
					var	xID    		   = ExtTypeData.ReportID;
					var SpecTypeDesc   = ExtTypeData.SpecTypeDesc
					var checkItem= SpecTypeDesc.indexOf("新冠")
					if(checkItem!=-1){
						$HUI.combobox("#cboBatObject"+xID,{
							data:EHRstTypes,
							valueField:'DicCode',
							textField:'DicDesc',
							editable:true,
							onLoadSuccess:function(data){
								//只有一条记录默认加载
								if (data.length==1) {
									$('#cboBatObject'+xID).combobox('select',data[0]['DicCode']);
								}else{
									$('#cboBatObject'+xID).combobox('select',data[1]['DicCode']);
								}
							}
						});
					}
				}
				//保存事件
				$('#addB').on('click', function() {
					var resultInfo = '';
					var ErrorMsg=""; 
					var count=0;
					for (var i = 0; i< ExtTypeIDs.total; i++){
						var ExtTypeData    = ExtTypeIDs.rows[i];
						var	xID    		   = ExtTypeData.ReportID;
						var SpecTypeDesc   = ExtTypeData.SpecTypeDesc
						var checkItem= SpecTypeDesc.indexOf("新冠")
						var check=$('#check'+xID).is(':checked');
						if(check){
							count++;
						}
						if(checkItem!=-1&&check) {
							var RstTypeCode		= $('#cboBatObject'+xID).combobox('getValue')
							var RstTypeDesc		= $("#cboBatObject"+xID).combobox('getText')
							var Result       = "";
							var BactID       = "";
							var BactDesc     = "";
							var SpecNumber   =ExtTypeData.SpecimenNum
							var SpecNumDesc  =""
							var rowInfo = SpecNumber + '^' + SpecNumDesc + '^' +RstTypeCode + '^' +RstTypeDesc + '^' +Result + '^' +BactID + '^' +BactDesc
							if (resultInfo!=''){
								resultInfo += '!!' + rowInfo;
							} else {
								resultInfo = rowInfo;
							}
							var baseInfo =  ExtTypeData.ReportID;
							baseInfo += '^' + obj.ReportObj.Barcode;
							baseInfo += '^' + LogonLocID;
							baseInfo += '^' + LogonUserID;
							baseInfo += '^' + '4';  //4录入结果
							baseInfo += '^' + ExtTypeData.ItemObjID;  //监测对象
							baseInfo += '^' + ExtTypeData.ItemObjTxt;     //备注
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
								$.messager.popover({msg: '录入结果操作成功！',type:'success',timeout: 1000});
								obj.gridReusltLoad() ;//刷新
								$HUI.dialog('#LayerBatchApply').close();
								obj.gridReusltLoad() ;//刷新
							}
						}
						
					}
					if(count==0){
						$.messager.alert("错误提示","请选择监测项目", 'info');
					}
				});
				
				//关闭事件	
				$('#closeB').on('click', function(){
					$HUI.dialog('#LayerBatchApply').close();
				});
				
				$('#LayerBatchApply').dialog({
					title: '新冠监测结果批量录入',
				    iconCls:"icon-w-paper",
				    headerCls:'panel-header-gray',
				    modal: true
			     });
				$HUI.dialog('#LayerBatchApply').open();	
			}else{
				obj.winEnterResult_layer(objRep,1);
			}
			  //可编辑
			$("#txtBarcode").val("").focus();
			$("#txtResult1").focus();
		}
	}
	
    //录入结果窗体-初始化
	obj.winEnterResult_layer= function(objRep,isEdit){
		obj.ReportObj = objRep;
		obj.arrResult = obj.GetResult(objRep.ReportID,objRep.Barcode);
		if (obj.arrResult.length<1) return;
		var len=$("#tableEnterResult tr").length    
		if (obj.arrResult.length>len){
			$.messager.alert("错误提示", "项目标本超出最大展开范围，请修改参数配置（EnviHyMaxSpecimen）之后重启界面！", 'info');
			return;
		}
		
		$('#txtRstItem').val(objRep.ItemDesc);
		var ItemObjValue=objRep.ItemObjDesc;

		if (objRep.ItemObjTxt!=""&ItemObjValue=="") {
			ItemObjValue=objRep.ItemObjTxt;
		} 
		$('#txtRstObject').val(ItemObjValue);
		$('#txtResume').val(objRep.txtResume);
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
					if (index!=(len-1)){
						$(this).hide();
					}else{
						$(this).show();
					}
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
		for (var row = 1; row <= len; row++){
			var objResult = obj.arrResult[row];
			if (objResult){
				$("#lblItemNum"+row).text(objResult.SpecNumDesc);
				$('#txtResult'+row).attr('disabled',false);
				$('#txtRstBactID'+row).attr('disabled',false);
				$('#txtRstBactDesc'+row).attr('disabled',false);
				if (objResult.RstTypeCode==""){
					$('#cboRstType'+row).combobox('setValue',"1");
					$('#cboRstType'+row).combobox('setText',"菌落数");
					if(objRep.SpecTypeCode== 17||objRep.SpecTypeCode==18){
						$('#cboRstType'+row).combobox('setValue',"7");
						$('#cboRstType'+row).combobox('setText',"辐照强度");
						$('#txtRstBactID'+row).attr('disabled',true);
						$('#txtRstBactDesc'+row).attr('disabled',true);
					}
					if (objResult.SpecNumDesc.indexOf("参照值")>=0){
						$('#cboRstType'+row).combobox('setValue',"6");
						$('#cboRstType'+row).combobox('setText',"阴性");
					}
					$('#txtResult'+row).val("");
					$('#txtRstBactID'+row).val("");
					$('#txtRstBactDesc'+row).val("");
				}else {
					$('#cboRstType'+row).combobox('setValue',objResult.RstTypeCode);
					$('#cboRstType'+row).combobox('setText',objResult.RstTypeDesc);
					$('#txtResult'+row).val(objResult.Result);
					$('#txtRstBactID'+row).val(objResult.BactID);
					$('#txtRstBactDesc'+row).val(objResult.BactDesc);
				}
				
				if (objResult.SpecNumDesc.indexOf("参照值")>=0){
					$('#txtResult'+row).attr('disabled',true);
					$('#txtRstBactID'+row).attr('disabled',true);
					$('#txtRstBactDesc'+row).attr('disabled',true);
				}
			}
		}
		//录入结果弹窗
		$HUI.dialog('#winEnterResult').open();
	}
	
	//修改状态事件
	obj.winUpdateStatus_btnSave_click = function(){
		var ReportID = obj.ReportObj.ReportID;
		var StatusCode = $('#cboStatus1').combobox('getValue');
		var flg = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "UpdateStatus",
			aReportID   : ReportID,
			aStatusCode : StatusCode
		},false);
		if (parseInt(flg) < 1) {
			bClose = false;
			$.messager.alert("错误提示","修改状态操作错误!Error=" + flg, 'info');
			return ;
		} else {
			bClose = true;
			$.messager.popover({msg: '修改状态操作成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winUpdateStatus').close();
			$('#cboStatus1').combobox('setValue',"");
			obj.gridReusltLoad() ;//刷新
		}
		
	}
	//批量修改状态事件
	obj.winUpdateStatus_btnSave_click1 = function(){
		console.log(checkedRows,"tt")
		for (var j=0;j<checkedRows.length;j++) {
			var rd=checkedRows[j];
			var ReportID = rd['ReportID'];
			var StatusCode = $('#cboStatus2').combobox('getValue');
			var flg = $m({
				ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
				MethodName  : "UpdateStatus",
				aReportID   : ReportID,
				aStatusCode : StatusCode
			},false);
			if (parseInt(flg) < 1) {
				bClose = false;
				$.messager.alert("错误提示","申请日期时间为:"+rd["ApplyDate"]+" "+rd["ApplyTime"]+"的"+$g(rd["ItemDesc"])+" 监测报告单修改状态操作错误!Error=" + flg, 'info');
				return ;
			} 
		}
			bClose = true;
			$.messager.popover({msg: '批量修改状态操作成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winUpdateStatus1').close();
			$('#cboStatus2').combobox('setValue',"");
			obj.gridReusltLoad() ;//刷新
		
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
					
					if (objResult.BactDesc=='') objResult.BactID='';
					var lblItemNum=$("#lblItemNum"+index).text();
					if(objResult.RstTypeDesc!="标本不合格"){
						if ((lblItemNum.indexOf("参照值")>=0)&&(objResult.RstTypeDesc!="阴性")&&(objResult.RstTypeDesc!="阳性")){
							ErrorMsg = ErrorMsg+ '第'+index+'行：参照值结果类型只能录入阴性或阳性！</br>'
						}
						if (((objResult.RstTypeDesc!="阴性")&&(objResult.RstTypeDesc!="阳性")&&(objResult.RstTypeDesc!="未检出")&&(!objResult.Result)) ||(!objResult.RstTypeCode)){
							ErrorMsg = ErrorMsg+ '第'+index+'行请录入正确的结果信息！</br>'
						}
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
			$("#txtBarcode").val("").focus();
			return;
		}
	
		//基本信息
		var baseInfo = obj.ReportObj.ReportID;
		baseInfo += '^' + obj.ReportObj.Barcode;
		baseInfo += '^' + LogonLocID;
		baseInfo += '^' + LogonUserID;
		baseInfo += '^' + '4';  //4录入结果
		baseInfo += '^' + $('#txtRstObject').val();  //监测对象
		baseInfo += '^' + $('#txtResume').val();     //备注
		var flg = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "SaveReportResults",
			aBaseInfo   : baseInfo,
			aResultInfo : resultInfo
		},false);
		if (parseInt(flg) < 1) {
			bClose = false;
			$.messager.alert("错误提示","录入结果操作错误!Error=" + flg, 'info');
			$("#txtBarcode").val("").focus();
			return ;
		} else {
			bClose = true;
			$.messager.popover({msg: '录入结果操作成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winEnterResult').close();
			setTimeout(function(){
				$('#txtBarcode').val("");
				$('#txtBarcode').focus();
			},1000);
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
			var reportIds = '';
			var pingbancnt=0,shs10zhycnt=0,jhs9zhycnt=0,othercnt=0;
			var message="所需耗材：<br/>";
			if (chkRows.length>0) {
				for (var row = 0; row < chkRows.length; row++){
					var rd = chkRows[row];
					if (!rd) continue;
					var repId = rd['ReportID'];
					if (reportIds != ''){
						reportIds += ',' + repId;
					} else {
						reportIds = repId;
					}
					// SpecTypeDesc
					var SpecimenNum   = parseInt(rd['SpecimenNum']);
					var SpecTypeDesc  = rd['SpecTypeDesc'];
					
					if (SpecTypeDesc.indexOf("消毒液")>=0){
						jhs9zhycnt=jhs9zhycnt+SpecimenNum;
					}else if (SpecTypeDesc=="空气"){
						pingbancnt=pingbancnt+SpecimenNum;
					}else if ((SpecTypeDesc=="手")||(SpecTypeDesc=="物表")){
						shs10zhycnt=shs10zhycnt+SpecimenNum;
					}else{
						othercnt=othercnt+SpecimenNum;
					}
				}
			}
			if (pingbancnt>0){
				message=message+"平板："+pingbancnt+"个<br/>";
			}
			if (shs10zhycnt>0){
				message=message+"10毫升中和液："+shs10zhycnt+"个<br/>";
			}
			if (jhs9zhycnt>0){
				message=message+"9毫升消毒中和液："+jhs9zhycnt+"个<br/>";
			}
			if (othercnt>0){
				message=message+"其他材料："+othercnt+"个<br/>";
			}
			if (chkRows.length>0) {
				 $.messager.confirm("确认", message+"<br/>是否批量发放材料?", function (r) {
					if (r) {
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
							$('#txtBarcode').val();
							$('#txtBarcode').focus();
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
	//打印条码
	obj.btnBarcode_onClick = function() {
		var checkedRows=$HUI.datagrid('#gridReuslt').getChecked();
		if (checkedRows.length<1) {$.messager.alert("错误提示","请勾选申请记录进行打印！", 'info'); return;}
		//$.messager.popover({msg: '正在打印中,请稍等....',type: 'success',timeout: 2000});
		loading("正在打印");
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
			var MonitorLocDesc = rd['MonitorLocDesc'];
			var ItemObjDesc = rd['ItemObjDesc'];
			if (ItemObjDesc=="") ItemObjDesc = rd['ItemObjTxt'];
			
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
				vItemDate   = MonitorDate + '【' + SubItemDesc + '/' + SpecimenNum + '】';
				//条码打印
				PrintXMLBar(ItemDesc,ItemObjDesc,vItemDate,MonitorLocDesc,vBarCode);
			}
		}
		disLoad();
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
          if (xmlPrintFlag==2){
             // lodop打印
            DHC_PrintByLodop(getLodop(),printParam,"","","");   
         } else{
              // 控件打印
	     // 打印控件
	     var printControlObj=document.getElementById("barPrintControl");	
		 DHCP_XMLPrint(printControlObj,printParam,printList);
         }      
		}
	
	//条码输入事件（目前只有3接收标本、4录入结果有条码操作）
	obj.txtBarcode_onKeydown = function(){
		var barcode = $('#txtBarcode').val();
		// add by zhoubo 2021-10-28 去掉条码前面的标示字符
		if (barcode.substr(0, 1)=="E") {
			barcode = barcode.slice(1);
		}
		if (barcode.length==8) { //项目条码
			var ReportID = parseInt(barcode);
			var objRep = obj.GetReport(ReportID);
		} else {  //标本条码
			var objRep = obj.GetReport('',barcode);
		}
		if (objRep) {
			$('#txtBarcode').val(objRep.Barcode);  //条码回写到输入框
			var len=objRep.Barcode.length;
			var BarNumber = objRep.Barcode.substring(len-2,len);  //判断条码数与标本数大小
			var SpecimenNum = objRep.SpecimenNum;
			if ((BarNumber>SpecimenNum)||(objRep.Barcode == '')){
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
				setTimeout(function(){
					$('#txtBarcode').val("");
					$('#txtBarcode').focus();
				},1000);
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
		objRep.CollDate        = arrInfo[19].split('!!')[0];
		objRep.CollTime        = arrInfo[19].split('!!')[1];
		objRep.CollUser        = arrInfo[19].split('!!')[2];
		objRep.RecDate         = arrInfo[20].split('!!')[0];
		objRep.RecTime         = arrInfo[20].split('!!')[1];
		objRep.RecUser         = arrInfo[20].split('!!')[2];
		objRep.RepDate         = arrInfo[21].split('!!')[0];
		objRep.RepTime         = arrInfo[21].split('!!')[1];
		objRep.RepLoc          = arrInfo[21].split('!!')[2];
		objRep.RepUser         = arrInfo[21].split('!!')[3];
		objRep.txtResume       = arrInfo[22];
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
		        { field:"UpdateLocDesc",title:"操作科室",width:'140'},
				{ field:"UpdateUser",title:"操作人",width:'140'},
				{ field:"UpdateDate",title:"操作日期",width:'140'},
				{ field:"UpdateTime",title:"操作时间",width:'140'}
	        ]]
	    });
		$HUI.dialog('#winStatusList').open();
	}
}

