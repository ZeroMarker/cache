/**
 * 问卷维护  dhchm.questionnaireset.js
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */
$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.QuestionnaireSet',MethodName:'CheckQSCodeExist',Type:$("#QType").combobox("getValue"),Code:value,ID:$("#QNID").val()};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '代码已存在'
	}
});


var QNDataGrid=$HUI.datagrid("#QNList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionnaireSet",
			QueryName:"FindQuestion"
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				//QClear_onclick();
				$("#QNID,#QCode,#QDesc,#QRemark").val("");
				$("#QType").combobox('setValue','HM');
				$("#QActive").checkbox("check");

				$("#QNID").val(rowData.QNID);
				$("#QCode").val(rowData.QCode);
				$("#QDesc").val(rowData.QDesc);
				$("#QRemark").val(rowData.QRemark);
				$("#QType").combobox("setValue",rowData.QType);
				if(rowData.QActive=="true"){
					$("#QActive").checkbox("check");
				}else{
					$("#QActive").checkbox("uncheck");
				}
				RefreshTab();
				EDDataGrid.load({
					ClassName:"web.DHCHM.QuestionnaireSet",
					QueryName:"FindEDL",
					ParRef:rowData.QNID
				});					
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QNID',hidden:true,sortable:'true'},
			{field:'QCode',width:'40',title:'编码'},
			{field:'QDesc',width:'120',title:'描述'},
			{field:'QType',width:'60',title:'类型',
				formatter:function(value,row,index){
					var ret="";
					switch(value){
						case "HM":
							ret="健康管理";
							break;
						case "CRM":
							ret="随访";
							break;
					}
					return ret;
				}
			},
			{field:'QActive',width:'25',title:'激活',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QRemark',title:'备注'},
		]],
		singleSelect:true,
		pagination:true,
		pageSize:20,
		displayMsg:"",
		fit:true
	});
	
var EDDataGrid=$HUI.datagrid("#EDList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionnaireSet",
			QueryName:"FindEDL",
			ParRef:$("#QNID").val()
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				$("#EDLID").val(rowData.EDLID);
				$("#EvaluationID").combobox("setValue",rowData.QEDLEvaluationDetailDR);
				$("#EvaOrder").val(rowData.QEDLOrder);
				$("#EvaCalcOrder").val(rowData.QEDLCalculateOrder);	
				if(rowData.QEDLActive=="true"){
					$("#EvaActive").checkbox("check");
				}else{
					$("#EvaActive").checkbox("uncheck");
				}				
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'EDLID',hidden:true,sortable:'true'},
			{field:'QEDLEvaluationDetailDR',hidden:true,sortable:'true'},
			{field:'EDDesc',width:250,title:'评估内容'},
			{field:'QEDLOrder',width:100,title:'显示顺序'},
			{field:'QEDLCalculateOrder',width:100,title:'计算顺序'},
			{field:'QEDLActive',width:60,title:'激活',align:"center",
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		singleSelect:true,
		pagination:true,
		pageSize:20,
		fit:true,
		fitColumns:true,
		rownumbers:true
	});	

function evaluation_clean(){
	$("#EDLID").val("");
	$("#EvaluationID").combobox("setValue","");
	$("#EvaOrder").val("");
	$("#EvaCalcOrder").val("");	
	$("#EvaActive").checkbox("check");
	EDDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindEDL",ParRef:$("#QNID").val()});
}

function evaluation_save(){
	var ID=$("#EDLID").val();
	var ParRef=$("#QNID").val();
	var EvaluationID=$("#EvaluationID").combobox("getValue");
	var EvaOrder=$("#EvaOrder").val();
	var EvaCalcOrder=$("#EvaCalcOrder").val();
	var EvaActive="N"	
	
	if($("#EvaActive").checkbox("getValue")){
		EvaActive="Y";
	}
	if(EvaluationID==""){
		$.messager.alert("提示","评估内容不能为空","info");
		return false;
	}
	if(ParRef==""){
		$.messager.alert("提示","所属问卷不能为空","info");
		return false;
	}
	var property = 'QEDLActive^QEDLCalculateOrder^QEDLEvaluationDetailDR^QEDLOrder^QEDLParRef';
	var valList=EvaActive+"^"+EvaCalcOrder+"^"+EvaluationID+"^"+EvaOrder+"^"+ParRef;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","EDLSave",ID,valList,property,ParRef,EvaluationID);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");     
        	 evaluation_clean();	
            EDDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindEDL",ParRef:ParRef});
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}

	
/**
 * 左侧清屏
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function QClear_onclick(){
	$("#QNID").val("");
	$("#QCode").val("");
	$("#QDesc").val("");
	$("#QRemark").val("");
	//$("#QType").combobox("setValue","");
	$("#QType").combobox('setValue','HM');
	$("#QActive").checkbox("check");
	RefreshTab();
	evaluation_clean();
	EDDataGrid.load({
		ClassName:"web.DHCHM.QuestionnaireSet",
		QueryName:"FindEDL"
	});
  QNDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindQuestion"});
}
/**
 * 左侧保存
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function QSave_onclick(){
	var ID=$("#QNID").val();
	var Code=$("#QCode").val();
	var Desc=$("#QDesc").val();
	if(Code==""){
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	if(!$("#QCode").validatebox("isValid")){
		$.messager.alert("提示","代码已存在","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var Remark=$("#QRemark").val();
	if(!$("#QRemark").validatebox("isValid")){
		$.messager.alert("提示","备注超长","info");
		return false;
	}

	var Type=$("#QType").combobox("getValue");
	if(Type==""){
		$.messager.alert("提示","类型不能为空","info");
		return false;
	}

	var Active="N";
	if($("#QActive").checkbox("getValue")){
		Active="Y";
	}
	var property = 'QActive^QCode^QDesc^QRemark^QType';
	var valList=Active+"^"+Code+"^"+Desc+"^"+Remark+"^"+Type;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","QNSave",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");     
        	 QClear_onclick();	
            QNDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindQuestion"});
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}
/**
 * 左侧面板收起 展开
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function Westpanel_resize(){
	RefreshTab();
}	
/**
 * 刷新右侧页签
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function RefreshTab(){
	var subTab=$('#TabPanel').tabs("getTab","主题内容");
	$('#TabPanel').tabs("update",{
		tab:subTab,
		options: {
			content:'<iframe src="dhchm.questionsubject.csp?QuestionDR='+$("#QNID").val()+ ' "   width="100%" height="100%" frameborder="0"></iframe>'
		}	
	});
}

var EvaluateCombogrid=$("#EvaluationID").combobox({
        valueField: 'QEDLEvaluationDetailDR',
        textField: 'EDDesc',
        url:$URL+'?ClassName=web.DHCHM.QuestionnaireSet&QueryName=FindEvaDetail&ResultSetType=array'
	});


/**
 * 设置DataGrid 高度
 * @Author   wangguoying
 * @DateTime 2019-04-03
 */
function setGridHeight()
{
	$(".panel-header.panel-header-gray").css("border-radius","4px 4px 0 0")
	$("#QNListDiv").height($("#WestPanel").height()-261);
	$("#QNList").datagrid("resize");
	$("#EDListDiv").height($("#TabPanel").height()-205);
	EDDataGrid.resize();
}
function init(){
	
	//alert($(window).height()+"\n"+$("#ContentDiv").height())
	setGridHeight();
}
$(init);