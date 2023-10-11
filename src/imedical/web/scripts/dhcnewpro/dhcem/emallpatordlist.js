
$(function(){
	/// 初始化加载病人就诊ID
	initParams();
	
	initDateBox();
	
	initCombobox();
	
	initTable();
	
})

function initParams(){
	///是否HOSOPEN
	HOSOPEN = getParam("hosOpen");	
	
	SEEORDTYPE = getParam("seeOrdType");
}

function initDateBox(){
	$HUI.datebox("#StartDate").setValue(formatDate(-2));
	$HUI.datebox("#EndDate").setValue(formatDate(0));	
}

function initCombobox(){
	$HUI.combobox("#KeptLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=jsonListWard&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        qryEmPatList();
	    }	
	})
	
	///就诊科室
	$HUI.combobox("#AdmLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        qryEmPatList();
	    }	
	})	
	
	
	$HUI.combobox("#OrdType",{
		data:[
			{"value":"jyd","text":"检验单"},//hxy 2020-02-21 原：1 2 3 4
			{"value":"psd","text":"皮试单"},
			{"value":"syd","text":"输液单"},
			{"value":"zld","text":"治疗单"},
			{"value":"kfd","text":"口服单"},
			{"value":"jcd","text":"检查单"},
			{"value":"zsd","text":"注射单"},
			{"value":"sxd","text":"输血单"}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       qryEmPatList();
	    }	
	})
	SEEORDTYPE?$HUI.combobox("#OrdType").setValue(SEEORDTYPE):"";
	
	$HUI.combobox("#CheckLev",{
		data:[
			{"value":"1","text":"Ⅰ级"},//hxy 2020-02-21 原：1 2 3 4
			{"value":"2","text":"Ⅱ级"},
			{"value":"3","text":"Ⅲ级"},
			{"value":"4","text":"Ⅳa级"},
			{"value":"5","text":"Ⅳb级"} //ed
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       qryEmPatList();
	    }	
	})	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	/// 卡类型  卡类型的combobox的onSelect事件。
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
	        var CardTypeDefArr = option.value.split("^");
	        m_CardNoLength = CardTypeDefArr[17];
	        m_CCMRowID = CardTypeDefArr[14];
	        
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#EmCardNo').attr("readOnly",false);
		    }else{
				$('#EmCardNo').attr("readOnly",true);
			}
			$('#EmCardNo').val("");  /// 清空内容
	    }
	};
	var url = uniturl+"CardTypeDefineListBroker";
	new ListCombobox("EmCardType",url,'',option).init();
	
	/// 登记号/床号/姓名 回车事件
	$("#TmpCondition").bind('keypress',TmpCon_KeyPress);
	
	/// 卡号 回车事件
	$("#EmCardNo").bind('keypress',EmCardNo_KeyPress);
	
}

function initTable(){
	
	var columns=[[
		{field:'admPriority',title:'当前分级',width:70,align:'center',formatter:setCellPAAdmPriority},
		{field:'emNurLev',title:'初始分级',width:70,align:'center',formatter:setCellLevLabel},
		{field:'patNo',title:'登记号',width:120},
		{field:'patName',title:'姓名',width:100},
		{field:'patSex',title:'性别',width:60,align:'center'},
		{field:'patAge',title:'年龄',width:70,align:'center'},
		{field:'arciName',title:'医嘱名称',width:120},
		{field:'sttDate',title:'开医嘱日期',width:120},
		{field:'sttTime',title:'开医嘱时间',width:120},
		{field:'ctcpDesc',title:'开医嘱人',width:120},
		{field:'emPCLvArea',title:'区域',width:60,align:'center',styler:setCellAreaLabel},
		{field:'admLoc',title:'就诊科室',width:120},
		{field:'admDoc',title:'就诊医生',width:120},
		{field:'admWard',title:'病区',width:120,align:'center'},					 //+
		{field:'admBed',title:'床号',width:80,align:'center'},                     //+
		{field:'diagnosis',title:'诊断',width:190,align:'center'},
		{field:'admDate',title:'就诊日期',width:120,align:'center'},
		{field:'admTime',title:'就诊时间',width:120,align:'center'},				 //+
		{field:'title',title:'状态',width:80,align:'center'},				     //+
		{field:'regDoctor',title:'号别',width:120,align:'center'},
		{field:'billType',title:'病人类型',width:80,align:'center'},
		{field:'emPatGreFlag',title:'绿色通道',width:70,align:'center',formatter:setCellGreenLabel},
		{field:'emPCLvNurse',title:'分诊护士',width:100},
		{field:'admId',title:'EpisodeID',width:100,align:'center'},
		
	]];
	
	///  定义datagrid
	var option = {
		fit:true,
		toolbar:'#container',
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
		
	    },
		onLoadSuccess:function(data){
			
			
		},
	    onDblClickRow: function (rowIndex, rowData) {
		  
		  	hosSetPatient({
			  	hosOpen:HOSOPEN,
				EpisodeID:rowData.admId,
				PatientID:rowData.patientId
			})
		  
        }
	};
	/// 就诊类型
	var params = getParams();;
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMNurMessageInterface&MethodName=ordTypeNumber&model=1&params="+params;
	new ListComponent('patList', columns, uniturl, option).Init(); 
}

/// 登记号/床号/姓名 回车事件
function TmpCon_KeyPress(e){

	if(e.keyCode == 13){
		var TmpCondition = $("#TmpCondition").val();
		if (!TmpCondition.replace(/[\d]/gi,"")&(TmpCondition != "")){
			///  登记号补0
			TmpCondition = GetWholePatNo(TmpCondition);
			$("#TmpCondition").val(TmpCondition);
		}
		qryEmPatList();
	}
}


///  卡号回车
function EmCardNo_KeyPress(e){

	if(e.keyCode == 13){
		var CardNo = $("#EmCardNo").val();
		if (CardNo == "") return;
		var CardNoLen = CardNo.length;
		if((m_CardNoLength!="")&&(m_CardNoLength!=0)){
			if (m_CardNoLength < CardNoLen){
				$.messager.alert("提示:","卡号输入错误,请重新录入！");
				return;
			}

			/// 卡号不足位数时补0
			for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
				CardNo="0"+CardNo;  
			}
		}
		
		$("#EmCardNo").val(CardNo);
		qryEmPatList();
	}
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}


function setCellPAAdmPriority(value, rowData, rowIndex){
	var fontColor = "";
	if (value == "1级"){ fontColor = "#F16E57";}
	if (value == "2级"){ fontColor = "orange";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>";	//hxy 2020-02-21
}

function setCell(value){
	if(value=="1级"){value="Ⅰ级";}
	if(value=="2级"){value="Ⅱ级";}
	if(value=="3级"){value="Ⅲ级";}
	if(value=="4级"){value="Ⅳa级";}
	if(value=="5级"){value="Ⅳb级";}
	return value;
}

/// 分级
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	if (value == "1级"){ fontColor = "#F16E57";}
	if (value == "2级"){ fontColor = "orange";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>"; //hxy 2020-02-21
}

/// 去向
function setCellAreaLabel(value, row, index){
	if (value == "红区"){
		return 'background-color:#F16E57;color:white';
	}else if (value == "橙区"){ //hxy 2020-02-21 st
		return 'background-color:orange;color:white'; //ed
	}else if (value == "黄区"){
		return 'background-color:#FFB746;color:white';
	}else if (value == "绿区"){
		return 'background-color:#2AB66A;color:white';
	}else{
		return '';
	}
}

/// 绿色通道
/// zhouxin
/// 2018-07-18
function setCellGreenLabel(value, rowData, rowIndex){
	var fontColor = "";
	var html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.admId+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	if (value == "是"){ html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.admId+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"/></a>'; }
	return html;
	
}

function showGreenRec(adm){
	var option = {
		minimizable:false,
		iconCls:'icon-save',
		onClose:function(){qryEmPatList()}
	}
	new WindowUX("绿色通道","PatLabWin", 700, 420 , option).Init();
	
	var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="98%" width="100%" scrolling="no"></iframe>';
	$("#PatLabWin").html(content);
	return;		
}

/// 获取参数
function getParams(){
	
	/// 开始日期
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// 结束日期
	var EndDate = $HUI.datebox("#EndDate").getValue();
	///级别
	var CheckLev = $HUI.combobox("#CheckLev").getValue();
	///登记号
	var TmpCondition = $("#TmpCondition").val();
	/// 卡号
	var CardNo = $("#EmCardNo").val();
	/// 就诊科室
	var AdmLoc = $HUI.combobox("#AdmLoc").getValue();
	///留观病区
	var EmWardID = $HUI.combobox("#KeptLoc").getValue()
	
	var OrdType = $HUI.combobox("#OrdType").getValue()
	

	
	
	
	return StartDate+'^'+EndDate+'^'+CheckLev+'^'+TmpCondition+'^'+CardNo+'^'+AdmLoc+'^'+EmWardID+'^'+OrdType;
}

/// 查询
function qryEmPatList(){
	
	$("#patList").datagrid("load",{model:1,"params":getParams()}); 
}
