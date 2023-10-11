//页面Event
function InitBPRegPatWinEvent(obj){
	obj.LoadEvent = function(args){ 
		
		$("#btnQuery").on('click',function(){
			obj.reloadgridAdm();
		});
		$("#btnAddPat").on('click',function(){
			obj.AddBPPatEdit();
			obj.ClearData();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
	}
	//关闭
	$('#closeA').on('click', function(){
		$HUI.dialog('#AddBPPatEdit').close();
	});
	//清除数据
	obj.ClearData = function(){
		$("#cboPABPPatType").combobox('setValue',"");
		$("#cboPAAdmLoc").combobox('setValue',"");
		$("#PAHDTime").val("");
		$("#PAAdmDoc").val("");
		$("#txtPatName2").val("");
		$("#PAAdmNurse").val("");
		$("#PARelTel").val("");
		$("#cboPAEpiInfo").combobox('setValue','');
		$("#PADiagnosis").val("");
		$("#PAStartDate").datebox('setValue','');
		$("#PAEndDate").datebox('setValue','');
		$("#PAStatusDate").datebox('setValue','');
		$("#PARegDate").datebox('setValue','');
		$("#PARegTime").timespinner('setValue','');
		$("#PAStatusTime").timespinner('setValue','');
		$("#PatName").text("");
		$("#Age").text("");
		$("#PapmiNo").text("");
		$("#MrNo").text("");
		$("#AdmDate").text("");
		$("#Sex").text("");
	}
	// 新增、修改记录
	$('#addA').on('click', function() {
		var PABPPatType  = $("#cboPABPPatType").combobox('getText');
		var HDLocDr      = $("#cboPAAdmLoc").combobox('getValue');
		var PAHDTime   	 = $("#PAHDTime").val();
		var PAAdmDoc   	 = $("#PAAdmDoc").val();
		var PAAdmNurse   = $("#PAAdmNurse").val();
		var PARelTel   	 = $("#PARelTel").val();
		var PAEpiInfo    = $("#cboPAEpiInfo").combobox('getText');
		var PADiagnosis  = $("#PADiagnosis").val();
		var PAStartDate  = $("#PAStartDate").datebox('getValue');
		var PAEndDate    = $("#PAEndDate").datebox('getValue');
		var PAStatusDate = $("#PAStatusDate").datebox('getValue');
		var PARegDate    = $("#PARegDate").datebox('getValue');
		var PARegTime    = $("#PARegTime").timespinner('getValue');
		var PAStatusTime = $("#PAStatusTime").timespinner('getValue');
		var PatName   	 = $("#PatName").html();
		var Age		     = $("#Age").html();
		var PapmiNo		 = $("#PapmiNo").html();
		var MrNo		 = $("#MrNo").html();
		var AdmDate		 = $("#AdmDate").html();
		var Sex  		 = $("#Sex").html();
		var errorStr = '';
		if ((!PatName)||(!obj.PABPRegID)) {
			errorStr = errorStr + "请选择患者信息!<br>"; 
		}
		if (!PABPPatType) {
			errorStr = errorStr + "请填写病人类型!<br>"; 
		}
		if (!PAAdmDoc) {
			errorStr = errorStr + "请填写主管医生!<br>"; 
		}
		if (!PAStartDate) {
			errorStr = errorStr + "请填写首次透析日期!<br>"; 
		}
		if (!PARegDate) {
			errorStr = errorStr + "请填写登记日期!<br>"; 
		}
		if(!PARegTime){
			errorStr = errorStr + "请填写登记时间!<br>"; 
		}
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return; 
		}
		
		var InputStr = "";
		InputStr += "^" + obj.PABPRegID;
		InputStr += "^" + obj.PAEpisodeID;
		InputStr += "^" + obj.PAPatientID;
		InputStr += "^" + MrNo;
		InputStr += "^" + PatName;
		InputStr += "^" + Sex;
		InputStr += "^" + Age;
		InputStr += "^" + obj.AdmType;
		InputStr += "^" + obj.Birthday;
		InputStr += "^" + PARelTel;
		InputStr += "^" + HDLocDr;
		InputStr += "^" + PAHDTime;
		InputStr += "^" + PAAdmDoc;
		InputStr += "^" + PAAdmNurse;
		InputStr += "^" + PAEpiInfo;
		InputStr += "^" + PABPPatType;
		InputStr += "^" + PADiagnosis;
		InputStr += "^" + PAStartDate;
		InputStr += "^" + PAEndDate;
		InputStr += "^" + PAStatusDate;
		InputStr += "^" + PAStatusTime;
		InputStr += "^" + PARegDate;
		InputStr += "^" + PARegTime;
		InputStr += "^" + "1"; // 是否有效			
		
		$m({
			ClassName:"DHCHAI.DP.BPRegister",
			MethodName:"Update",
			InStr:InputStr
		},function(retval){
			if (parseInt(retval)>0){
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
				$HUI.dialog('#AddBPPatEdit').close();
				obj.reloadgridAdm();
			} else {
				$.messager.alert("错误提示","保存失败:"+retval, 'info');
			}
		})
	});
	//查询
	obj.reloadgridAdm = function(){
		var ErrorStr="";
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		if(HospIDs==undefined){HospIDs=""}
		var DateFrom 	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= $("#txtPapmiNo").val();
		var MrNo 		= $("#txtMrNo").val();
		
		var ErrorStr = "";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if ((DateFrom!="")&&(DateTo!="")&&(Common_CompareDate(DateFrom,DateTo))) {
			ErrorStr += '开始日期不能大于结束日期!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		
		obj.gridAdmLoad();
		obj.gridAdm.clearSelections();
	};
		
	//登记号补零 length位数
	var length=10;
	obj.PapmiNo=""
	$("#txtPapmiNo").keydown(function(event){
		 if (event.keyCode ==13) {
			obj.PapmiNo = $("#txtPapmiNo").val();
			if(obj.PapmiNo) $("#txtPapmiNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
			obj.reloadgridAdm();
		}
	});	
	$("#txtPatName2").keydown(function(event){
		 if (event.keyCode ==13) {
			var PatValue = $("#txtPatName2").val();
			obj.InitPatInfo(PatValue);
		}
	});
	//初始化登记信息
	obj.InitRegInfo = function(rowdata){
		if (rowdata){
			obj.PAEpisodeID = rowdata.PAEpisodeID;
		    obj.PAPatientID = rowdata.PAPatientID;
		    obj.PABPRegID   = rowdata.PABPRegID;
		    obj.Birthday    = rowdata.PABirthday;
		    obj.AdmType     = rowdata.PAPatType;
			$("#cboPABPPatType").combobox('setText',rowdata.PABPPatType);
			$("#cboPAAdmLoc").combobox('setValue',rowdata.AdmLocID);
			$("#cboPAAdmLoc").combobox('setText',rowdata.AdmLocDesc);
			$("#PAHDTime").val(rowdata.PAHDTime);
			$("#PAAdmDoc").val(rowdata.PAAdmDoc);
			$("#PAAdmNurse").val(rowdata.PAAdmNurse);
			$("#PARelTel").val(rowdata.PARelTel);
			$("#cboPAEpiInfo").combobox('setText',rowdata.PAEpiInfo);
			$("#PADiagnosis").val(rowdata.PADiagnosis);
			$("#PAStartDate").datebox('setValue',rowdata.PAStartDate);
			$("#PAEndDate").datebox('setValue',rowdata.PAEndDate);
			$("#PAStatusDate").datebox('setValue',rowdata.PAStatusDate);
			$("#PARegDate").datebox('setValue',rowdata.PARegDate);
			$("#PARegTime").timespinner('setValue',rowdata.PARegTime);
			$("#PAStatusTime").timespinner('setValue',rowdata.PAStatusTime);
			$("#PatName").text(rowdata.PAPatName);
			$("#Age").text(rowdata.PAPatAge);
			$("#PapmiNo").text(rowdata.PapmiNo);
			$("#MrNo").text(rowdata.PAMrNo);
			$("#Sex").text(rowdata.PAPatSex);
		}
	};
	//初始化就诊信息
	obj.InitPatInfo = function(PatValue)
	{
		obj.AdmInfo = $cm({
			ClassName:"DHCHAI.DPS.BPRegisterSrv",
			QueryName:"QryAdmInfoByName",		
			aIntputs: PatValue
		},false);
		if (obj.AdmInfo.total==1) {
			var AdmInfo = obj.AdmInfo.rows[0];
			$('#PatName').text(AdmInfo.PatName);
			$('#Age').text(AdmInfo.Age);	
			$('#PapmiNo').text(AdmInfo.PapmiNo);
			$('#MrNo').text(AdmInfo.MrNo);
			$('#Sex').text(AdmInfo.Sex);
			$('#AdmDate').text(AdmInfo.AdmDate);
			obj.PAEpisodeID = AdmInfo.HISEpisodeID;
		    obj.PAPatientID = AdmInfo.PatientID;
		    obj.PABPRegID   = AdmInfo.PatientID+"||"+AdmInfo.HISEpisodeID;
		    obj.Birthday    = AdmInfo.Birthday;
		    obj.AdmType     = AdmInfo.AdmType;
		}else if (obj.AdmInfo.total>1){
			obj.OpenPatList();
		}else{
			$('#PatName').text("");
			$('#Age').text("");	
			$('#Sex').text("");	
			$('#PapmiNo').text("");
			$('#MrNo').text("");
			$('#AdmDate').text("");
		}
	};
	
	// 弹出病人列表框
	obj.OpenPatList = function(){
		obj.refreshgridPatList();
		$('#LayerOpenPatList').show();
		obj.LayerOpenPatList();
	}
	//病人列表弹出事件
	obj.LayerOpenPatList = function() {
		$HUI.dialog('#LayerOpenPatList',{
			title:"病人列表 [双击数据进行编辑]", 
			iconCls:'icon-w-paper',
			width: 780,    
			height: 400, 
			modal: true,
			isTopZindex:true
		});
	}
	//病人列表
	obj.refreshgridPatList = function(){
		var PatValue = $("#txtPatName2").val();
		obj.gridPatList = $HUI.datagrid("#gridPatList",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			fitColumns: true,
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.DPS.BPRegisterSrv',
				QueryName:'QryAdmInfoByName',
				aIntputs:PatValue,
				rows:9999
			},
			columns:[[
				{field:'PatName',title:'姓名',width:200},
				{field:'MrNo',title:'病案号',width:180},
				{field:'PapmiNo',title:'登记号',width:200},
				{field:'Sex',title:'性别',width:120},
				{field:'AdmDate',title:'就诊日期',width:120}
			]],	
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					obj.InitPatData(rowdata,'');
					$HUI.dialog('#LayerOpenPatList').close();
				}
			}		
		});		
	}
	// 初始化数据
	obj.InitPatData=function(d,r){
		if (d){
			$('#PatName').text(d.PatName);
			$('#Age').text(d.Age);
			$('#Sex').text(d.Sex);	
			$('#PapmiNo').text(d.PapmiNo);
			$('#MrNo').text(d.MrNo);
			$('#AdmDate').text(d.AdmDate);
			obj.PAEpisodeID = d.HISEpisodeID;
		    obj.PAPatientID = d.PatientID;
		    obj.PABPRegID   = d.PatientID+"||"+d.HISEpisodeID;
		    obj.Birthday    = d.Birthday;
		    obj.AdmType     = d.AdmType;
		}
	}
	obj.gridAdmLoad = function(){
		
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		var DateType 	= $("#cboDateType").combobox('getValue');
		var DateFrom 	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= $("#txtPapmiNo").val();
		var MrNo 		= $("#txtMrNo").val();
		var BDLocIDs 	= $('#cboBDLocation').combobox('getValues').join(',');	
		var aInputs = HospIDs+'^'+DateFrom+'^'+DateTo+'^'+PatName+'^'+PapmiNo+'^'+MrNo+'^'+BDLocIDs+'^'+DateType;
		 
		obj.gridAdm.load({
		    ClassName:"DHCHAI.DPS.BPRegisterSrv",
			QueryName:"QryBPAdm",
			aIntputs:aInputs
	    });
    }
	
	//导出
	obj.btnExport_click = function() {
		var rows=$("#gridAdm").datagrid('getRows').length;
		if (rows>0) {
			$('#gridAdm').datagrid('toExcel','血透患者病例列表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
}

