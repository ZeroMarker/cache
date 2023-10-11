/*
 * Description: �����ʾ�ά��
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
			{field:'QCode',width:'40',title:'����'},
			{field:'QDesc',width:'120',title:'����'},
			{field:'QType',width:'60',title:'����',
				formatter:function(value,row,index){
					var ret="";
					switch(value){
						case "HM":
							ret="��������";
							break;
						case "CRM":
							ret="���";
							break;
					}
					return ret;
				}
			},
			{field:'QActive',width:'40',title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},{
				field:'TEmpower',width:90,title:'������Ȩ',align:'center',
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
				title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
					return '<input type="checkbox" value="" disabled/>';
				}
			}
		 },
		{field:'QRemark',title:'��ע'}
		]],
		toolbar:[{
			iconCls: 'icon-key',
			text: '���ݹ�������',
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
			{field:'EDDesc',width:250,title:'��������'},
			{field:'QEDLOrder',width:100,title:'��ʾ˳��'},
			{field:'QEDLCalculateOrder',width:100,title:'����˳��'},
			{field:'QEDLActive',width:60,title:'����',align:"center",
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
		$.messager.alert("��ʾ","�������ݲ���Ϊ��","info");
		return false;
	}
	if(ParRef==""){
		$.messager.alert("��ʾ","�����ʾ���Ϊ��","info");
		return false;
	}
	var property = 'QEDLActive^QEDLCalculateOrder^QEDLEvaluationDetailDR^QEDLOrder^QEDLParRef';
	var valList=EvaActive+"^"+EvaCalcOrder+"^"+EvaluationID+"^"+EvaOrder+"^"+ParRef;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","EDLSave",ID,valList,property,ParRef,EvaluationID);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");     
        	 evaluation_clean();	
            EDDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindEDL",ParRef:ParRef});
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}

	
/**
 * �������
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
 * ��ౣ��
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function QSave_onclick(){
	var ID=$("#QNID").val();
	var Code=$("#QCode").val();
	var Desc=$("#QDesc").val();
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var Remark=$("#QRemark").val();
	var Type=$("#QType").combobox("getValue");
	var Active="N";
	if($("#QActive").checkbox("getValue")){
		Active="Y";
	}
	
	//������Ȩ 
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
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");     
        	 QClear_onclick();	
        	 $("#QNList").datagrid("reload");
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}
/**
 * ���������� չ��
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function Westpanel_resize(){
	RefreshTab();
}	
/**
 * ˢ���Ҳ�ҳǩ
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */	
function RefreshTab(){
	var subTab=$('#TabPanel').tabs("getTab","��������");
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
 * ����DataGrid �߶�
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
	//���������б�change
	$("#LocList").combobox({
		onSelect: function() {
			initQNList();
		}
	});
	setGridHeight();
}

/**
 * [��Ȩ����]
 * @Author   wangguoying
 * @DateTime 2021-08-11
 */
function relateLocWin(){
	var row = $("#QNList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"δѡ���¼"});
		return false;
	} 
	//������Ȩ 
	if(row.TEmpower!="Y"){
		 $.messager.popover({type:"alert",msg:"�ü�¼û������Ȩ,���ܹ������ң�"});
		 return false;
	}
	
    var LocID=$("#LocList").combobox('getValue')
    OpenLocWin(_tableNme,row.QNID,_SessionStr,LocID,initQNList);
}


$(init);