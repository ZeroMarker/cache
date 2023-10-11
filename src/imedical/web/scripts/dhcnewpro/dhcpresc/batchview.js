var patType = "";
//页面初始化函数
function initPageDefault(){
	
	initParams();
	initPresctList();			//初始化处方列表
	initProblemType();			//初始化问题下拉框
	initDrugList();				//初始化药品列表下拉框
	initButton();				//初始化按钮
	initDateBox();				//初始化查询条件
	
}

function initParams(){
	
	patType = getParam("MenuModule");   /// 类型
}

//初始化处方列表
function initPresctList(){
	
	var columns=[[
		{field:'check',title:'sel',checkbox:true},
		{title:'处方ID',field:"auditID",width:120,align:"left",hidden:'true'},
		{title:'患者ID',field:"patientID",width:120,align:"left",hidden:'true'},
		{title:'就诊ID',field:"admID",width:120,align:"left",hidden:'true'},
		{title:'就诊号',field:"admNo",width:120,align:"left"},
		{title:'病人姓名',field:"patName",width:120,align:"left"},
		{title:'性别',field:"patSex",width:80,align:"left"},
		{title:'年龄',field:"patAge",width:80,align:"left"},
		{title:'诊断',field:"diagnos",width:160,align:"left"},
		{title:'标识',field:"manLevel",width:100,align:"left",
			styler:function(value,row,index){
				return switchWarn(value,row,index)
				}
			},
		{title:'创建时间',field:"creteDatetime",width:180,align:"left"},
		{title:'处方科室',field:"locDesc",width:100,align:"left"},
		{title:'处方医生',field:"docDesc",width:100,align:"left"},
		{title:'审核人',field:"pharDesc",width:100,align:"left"},
		{title:'审核状态',field:"status",width:120,align:"left"},
		{title:'审核理由',field:"reason",width:160,align:"center"},
		{title:'药师备注',field:"remark",width:160,align:"center"},
	]];
	
	var option={
		rownumbers : false,
		singleSelect : false,
		onDblClickRow:function(rowIndex,rowData){
			var auditID = rowData.auditID;
			var patientID = rowData.patientID
			var admID = rowData.admID
			var url="dhcpresc.auditdetail.csp?";
			if ('undefined'!==typeof websys_getMWToken){
				url += "&MWToken="+websys_getMWToken();
			}
			url += "&auditID="+auditID+"&patientID="+patientID+"&admID="+admID
			var detail = window.open(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1');	
		}
	}
	var handStaus = $("input[name='handle']:checked").val();
	handStaus = (handStaus == undefined) ? "" : handStaus;
	var params = "^^^^^"+ handStaus +"^"+patType;
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName=GetBatchPrescList&params="+encodeURI(params);
	new ListComponent('prescList', columns, uniturl, option).Init();
}

//判断处方最终状态
function switchStatus(value,row,index){
	
	switch(value){
		
		case "0":
			value = "新任务";
			break;
		case "1":
			value = "待确认";
			break;
		case "2":
			value = "必须修改";
			break;	
	}
	
	return value;
		
}

//判断标识
function switchWarn(value,row,index){

	switch(value){
		
		case "禁止":;
			css = "color:white;bold;background-color:#2F4F4F"
			break;
		case "警示":
			css = "color:white;bold;background-color:#FA8072"
			break;
		case "提醒":
			css = "color:white;bold;background-color:orange"
			break;	
		case "提示":
			css = "color:white;bold;background-color:green"
			break;
		default:
			css = ""
			break;
	}

	return css;
		
}

//初始化问题下拉框
function initProblemType(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#problemtype",{
		url:uniturl+"QueryDicItem&code=RIT&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){
			
		 }
	})	
}

//初始化药品列表下拉框
function initDrugList(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName="  

	$HUI.combobox("#druglist",{
		url:uniturl+"GetDrugList",
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){	
		 }
	})
	
}

//初始化问题类型下拉框
function initProblemType(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName="  

	$HUI.combobox("#problemtype",{
		url:uniturl+"GetProblemType",
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){	
		 }
	})
	
}


//初始化按钮
function initButton(){
	
	/*/清空病号输入框
	$("#resetPatno").bind("click",function(){
		$("#patno").val("");	
	});
	
	//清空门诊号输入框
	$("#resetAdmno").bind("click",function(){
		$("#admno").val("");	
	});*/
	
	//查询按钮
	$("#query").bind("click",queryPresc);
	
	//通过按钮
	$("#batchpass").bind("click",function(){batchPass("批量通过","STA04")});
	
	//双签按钮
	$("#dbbatchpass").bind("click",function(){batchPass("批量双签通过","STA03")});
	
	//拒绝按钮
	$("#batchnopass").bind("click",function(){batchPass("批量必须修改","STA01")});
	
}
//批量通过Action
function batchPass(mark,code)
{
	
	var selItems = $("#prescList").datagrid('getSelections');
	if(selItems.length==0)
	{
		$.messager.alert('提示',"请选择要处理的处方！","warning");
		return false;
	}
	var listDataStr=""
	var itemId = ""   //$HUI.combobox("#inselitm").getValue();		//便捷录入项目
	var remark = mark						//备注
	var readCode = 0;
	var stateCode = code   					//通过
	for(var i=0;i<selItems.length;i++)
	{
		var listData = selItems[i].auditID +"^"+ itemId +"^"+ LgUserID +"^"+ stateCode +"^"+ readCode +"^"+ remark;
		if(listDataStr=="")
		{
			listDataStr=listData	
		}else
		{
			listDataStr=listDataStr+"$$"+listData	
		}
	}
	runClassMethod(
		"web.DHCPRESCAudit",
		"saveAuditsInfo",
		{
			"listDataStr":listDataStr
		},
		function(ret){
			if(ret.split("^")[0]==0){
				if(ret.split("^")[1]!=0){
					if(selItems.length == ret.split("^")[1]){
						$.messager.alert('提示',"所选择数据已审核完成，请选择未审核数据处理！","info");
					}else{
						$.messager.alert('提示',"处理成功"+selItems.length-ret.split("^")[1]+"条待审核记录！其中"+ret.split("^")[1]+"条记录无需二次审核！","info");
					}
					
					queryPresc();
				}else{
					$.messager.alert('提示',"处理成功！","info");
					queryPresc();
				}
			
				return;
			}else{
				$.messager.alert('提示',"处理失败！"+ret,"error");
				return;
			}
		}
	,'text');	
}


//查询处方
function queryPresc(){
	
	var patno = ""
	var admno = ""
	var problemtype = $HUI.combobox("#problemtype").getText();
	var drug = ""
	var manlevel = $("input[name='manlevel']:checked").val();
	manlevel =  (manlevel == undefined) ? "" : manlevel;
	var handStaus = $("input[name='handle']:checked").val();
	handStaus = (handStaus == undefined) ? "" : handStaus;
	var params = patno + "^" + admno + "^" + manlevel + "^" + problemtype + "^" + drug  + "^" + handStaus;
	var params = params +"^" + patType;
	$("#prescList").datagrid("load",{"params":params})
}

//初始化日期框
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })