/*
 * Description: 调查问卷维护
 * FileName: dhcpe.ct.hm.questionnaire.js
 * Author: wangguoying
 * Date: 2021-08-14
 */

var _SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
var _tableNme = "DHC_HM_CQuestionnaire";

function initQNList(){
	RefreshTab();
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;
	$HUI.datagrid("#QNList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.HM.CommonData",
			QueryName:"FindQuestionnaireNew",
			LocID: locId
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				//QClear_onclick();
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
				
				if (rowData.TEmpower == "Y") {
					$("#Empower").checkbox("check");
				} else {
					$("#Empower").checkbox("uncheck");
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
			{field:'QActive',width:'40',title:'激活',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},{
				field:'TEmpower',width:90,title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},{ 
				field:'TEffPowerFlag',
				width:'100',
				align:'center',
				title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
					return '<input type="checkbox" value="" disabled/>';
				}
			}
		 },
		{field:'QRemark',title:'备注'}
		]],
		toolbar:[{
			iconCls: 'icon-key',
			text: '数据关联科室',
			handler: function(){relateLocWin();}
		}],
		singleSelect:true,
		pagination:true,
		pageSize:20,
		displayMsg:"",
		fit:true
	});
}	
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
	$("#QType").combobox("setValue","");
	$("#QActive").checkbox("check");
	$("#QNList").datagrid("unselectAll");
	$("#Empower").checkbox("uncheck");
	RefreshTab();
	
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
	if(Desc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var Remark=$("#QRemark").val();
	var Type=$("#QType").combobox("getValue");
	var Active="N";
	if($("#QActive").checkbox("getValue")){
		Active="Y";
	}
	
	//单独授权 
	var iEmpower = "N";
	if ($("#Empower").checkbox("getValue")) {
		iEmpower = "Y";
	}
	var property = 'QActive^QCode^QDesc^QRemark^QType';
	var valList=Active+"^"+Code+"^"+Desc+"^"+Remark+"^"+Type;
	try{
		var ret=tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveQuestionnaire",ID,property,valList,$("#LocList").combobox("getValue"),session["LOGON.USERID"],iEmpower);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");     
        	 QClear_onclick();	
        	 $("#QNList").datagrid("reload");
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
	var lnk="dhcpe.ct.hm.questionsubject.csp?QuestionDR="+$("#QNID").val();
	$('#TabPanel').tabs("update",{
		tab:subTab,
		options: {
			content:'<iframe src= " ' + PEURLAddToken(lnk) + ' "width="100%" height="100%" frameborder="0"></iframe>'
		}	
	});
}

var EvaluateCombogrid=$("#EvaluationID").combobox({
        valueField: 'QEDLEvaluationDetailDR',
        textField: 'EDDesc',
        url:$URL+'?ClassName=web.DHCHM.QuestionnaireSet&QueryName=FindEvaDetail&ResultSetType=array',
	});


/**
 * 设置DataGrid 高度
 * @Author   wangguoying
 * @DateTime 2019-04-03
 */
function setGridHeight()
{
	$(".panel-header.panel-header-gray").css("border-radius","4px 4px 0 0")

}
function init(){
	
	//alert($(window).height()+"\n"+$("#ContentDiv").height())
	
	GetLocComp(_SessionStr);
	//科室下拉列表change
	$("#LocList").combobox({
		onSelect: function() {
			initQNList();
		}
	});
	setGridHeight();
}

/**
 * [授权科室]
 * @Author   wangguoying
 * @DateTime 2021-08-11
 */
function relateLocWin(){
	var row = $("#QNList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"未选择记录"});
		return false;
	} 
	//单独授权 
	if(row.TEmpower!="Y"){
		 $.messager.popover({type:"alert",msg:"该记录没单独授权,不能关联科室！"});
		 return false;
	}
	
    var LocID=$("#LocList").combobox('getValue')
    OpenLocWin(_tableNme,row.QNID,_SessionStr,LocID,initQNList);
}


$(init);