//页面Event
function InitEnviHyApplyWinEvent(obj){
	obj.loadEvents=function(){    	
		// 申请
		$("#btnApply").on('click', function(){
			obj.Report="";
			obj.ApplyEdit();		
		});
		$('#btnColSpec').on('click', function(){
			obj.btnColSpec_onClick();
		});
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
						if (RepStatusCode !='2')continue;
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
	
	// 打印条码
	$("#btnPrintBar").on('click', function(){
		var checkedRows=$HUI.datagrid('#gridApply').getChecked();
		if (checkedRows.length<1) {$.messager.alert("错误提示","请勾选申请记录进行打印！", 'info'); return;}
		for (var j=0;j<checkedRows.length;j++) {
			var rd=checkedRows[j];
			var ID = rd["ReportID"];
			var ItemDesc = rd["EvItemDesc"];
			var NormDesc = rd["NormDesc"];
			var NormMax = rd["NormMax"];
			var NormMin = rd["NormMin"];
			var CenterNum = rd["CenterNum"];
			var SurroundNum = rd["SurroundNum"];
			var SpecimenNum = rd["SpecimenNum"];
			var BarCode = rd["BarCode"];
			var MonitorDate = rd['MonitorDate'];
			var ApplyLocDesc = rd['ApplyLocDesc'];
			var ItemObjDesc = rd['EvItemObjDesc'];
			if (ItemObjDesc=="") ItemObjDesc = rd['EHItemObjTxt'];
			
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
	     // 打印控件
	     var printControlObj=document.getElementById("barPrintControl");	
		 DHCP_XMLPrint(printControlObj,printParam,printList);
	}
	
	//打印报告改为润乾预览打印
	$('#btnPrintReport').click(function(e){
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
	});
	
	//关闭申请
	$('#closeA').on('click', function(){
		$HUI.dialog('#ApplyEdit').close();
	})
	
	// 申请、修改申请记录
	$('#addA').on('click', function(){
		var rd = obj.Report;
		var ReCheckRepID="",IsReCheck="",ReportID=""
		if (rd) {
			var ReportID=rd.ReportID;
			var ReCheckRepID=rd.ReCheckRepID;
			if (ReCheckRepID) IsReCheck=1;
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
		
		var InfEnviHyItem = $m({
			ClassName:"DHCHAI.IR.EnviHyItem",
			MethodName:"GetObjById",
			id:EvItemDr
			},false);
		var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
		var EHSpecimenNum = cm.EHSpecimenNum
		
		if (HospitalDr == '') {
			ErrorStr += '院区不允许为空！<br/>';	
		}
		if (MonitorLocDr == '') {
			ErrorStr += '监测科室不允许为空！<br/>';
		}
		if (MonitorDate == '') {
			ErrorStr += '监测日期不允许为空！<br/>';
		}
		if (EvItemDr == '') {
			ErrorStr += '监测项目不允许为空！<br/>';
		}
		/**if (($('#EvObject').css('display')!='none')&&(EvObjectDr == '')) {
			ErrorStr += '监测对象不允许为空！<br/>';
		}**/
		if ((IsObjNull==0)&&(EvObjectDr == '')) {
			ErrorStr += '监测对象不允许为空！<br/>';
		}
		if (SpecimenNum == 0) {
			ErrorStr += '标本数量不允许为空！<br/>';
      
		}
		if ((parseInt(EHSpecimenNum))<parseInt(SpecimenNum)) {
			ErrorStr = ErrorStr + "参照点个数、中心个数、周边个数总数不允许大于标本个数!<br>";
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
			} else {
				$.messager.alert("错误提示","保存失败:"+retval, 'info');
			}
		})
	})
	// 复制申请记单
	$('#copyA').on('click', function(){
		$HUI.dialog('#ApplyEdit').close(); //关闭申请填写窗口
		$HUI.dialog('#CopyApply').open(); //打开历史申请列表
	})
	// 复制到本月
	$('#copyADetail').on('click', function(){
		var SelectRows=$HUI.datagrid('#HisApplyList').getSelections();
		var MonitorDate=$('#CAMonitorDate').datebox('getValue');
		if (MonitorDate== '') {
			$.messager.alert("错误提示","监测日期不能为空", 'info');
			$('#CAMonitorDate').focus();
			return;
		}
		var SErrorStr=""
		for(var i=0;i<SelectRows.length;i++) {
			var row=SelectRows[i]
			var HospitalDr=row.HospID
			var ApplyLocDr=row.ApplyLocID
			var MonitorLocDr=row.MonitorLocID
			var EvItemDr=row.EvItemID
			var EvObjectDr=row.EvItemObjID
			var EHItemObjTxt=row.EHItemObjTxt; 
			var SpecimenNum=row.SpecimenNum
			var CenterNum=row.RepCenterNum
			var SurroundNum=row.RepSurroundNum	
			var ReferToNum=row.ReferToNum
			var ErrorStr = "";
			if (HospitalDr == '') {
				ErrorStr += '院区不允许为空！<br/>';	
			}
			if (MonitorLocDr == '') {
				ErrorStr += '监测科室不允许为空！<br/>';
			}
			if (MonitorDate == '') {
				ErrorStr += '监测日期不允许为空！<br/>';
			}
			if (EvItemDr == '') {
				ErrorStr += '监测项目不允许为空！<br/>';
			}
			if ((EHItemObjTxt=="")&&(EvObjectDr == '')) { //申请状态时监测对象有可能为空
				//ErrorStr += '监测对象不允许为空！<br/>';
			}
			if (SpecimenNum == 0) {
				ErrorStr += '标本数量不允许为空！<br/>';
			}
			if (ErrorStr != '') {
				$.messager.alert("错误提示","第"+i+"条申请记录有误:"+ErrorStr, 'info');
				continue;
			}
		
			var InputStr = "";
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
			InputStr += "^" + ''; 			//EHEnterTypeDr
			InputStr += "^" + ''; 			//IsReCheck
			InputStr += "^" + ''; 			//ReCheckRepDr
			InputStr += "^" + ''; 			//ItemObjTxt //复制历史申请单时，手工录入的对象重置
			InputStr += "^" + MonitorLocDr; 			
			InputStr += "^" + ReferToNum; 			
			
			$m({
				ClassName:"DHCHAI.IR.EnviHyReport",
				MethodName:"Update",
				InStr:InputStr
			},function(retval){
				if (parseInt(retval)>0){
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
				} else {
					ErrorStr +="第"+i+"条申请记录复制失败:"+retval+'<br/>'
				}
			
			});
		}
	  	if (SErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return ;
		}else{
			$.messager.popover({msg: '复制成功！',type:'success',timeout: 2000});
			$HUI.dialog('#CopyApply').close();
			obj.reloadgridApply();
		}
		
	})
	
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
		var Standard 	= Common_CheckboxValue('checkStandard');
		var ErrorStr="";
	
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
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
	
	obj.ShowResutlDtl=function(ReportID) {
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
		        { field:"BarCode",title:"标本条码",width:'100'},
		        { field:"RstTypeDesc",title:"结果类型",width:'100'},
				{ field:"Result",title:"菌落数",width:'60'},
				{ field:"BactDesc",title:"致病菌",width:'120'},
				{ field:"LogDate",title:"录入日期",width:'100'},
				{ field:"LogTime",title:"录入时间",width:'80'},
				{ field:"LogUserDesc",title:"录入人",width:'100'}
	        ]]
    	});
		$HUI.dialog('#ResultDetail').open();
	}
	
	obj.ReCheck=function(row) {
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

