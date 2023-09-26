/**
 * ���񼶱�ά��  dhchm.dhchmcserviceclass.js
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */

function init()
{
	setGridHeight();
}

/**
 * ����DataGrid�߶�
 * @Author   wangguoying
 * @DateTime 2019-03-29
 */
function setGridHeight()
{
	$("#SCListDiv").height($("#SeviceDiv").height()-141);
	$("#SCList").datagrid("resize");
	$("#QRListDiv").height($("#OptionPanel").height()-131);
	$("#QRList").datagrid("resize");
}
$(init);
var QuestionnaireObj = $HUI.combobox("#Questionnaire",{
		url:$URL+"?ClassName=web.DHCHM.BaseDataSet&QueryName=GetCQuestionnaire&ResultSetType=array",
		valueField:'ID',
		textField:'QDesc',
		onSelect:function(record){
		}
	});
var SCDataGrid = $HUI.datagrid("#SCList",{
		url:$URL,
		title:"",
		bodyCls:'panel-body-gray',
		border:false,
		queryParams:{
			ClassName:"web.DHCHM.BaseDataSet",
			QueryName:"GetCServiceClass",
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				ClearBtn_onclick();
				QClear_onclick();
				QRDataGrid.load({ClassName:"web.DHCHM.BaseDataSet",QueryName:"GetCSCQLink",theid:rowData.ID});
				$("#SCID").val(rowData.ID);
				$("#Code").val(rowData.SCCode);
				$("#Desc").val(rowData.SCDesc);
				$("#Price").val(rowData.SCPrice);
				$("#Months").val(rowData.SCMonths);
				$("#Remark").val(rowData.SCRemark);
				if(rowData.SCActive=="true"){
					$("#Active").checkbox("check");
				}else{
					$("#Active").checkbox("uncheck");
				}		
			}
		},
		onDblClickRow:function(index,row){														
		},	
		columns:[[
			{field:'ID',hidden:true,sortable:'true'},
			{field:'SCCode',width:100,title:'����'},
			{field:'SCDesc',width:150,title:'����'},
			{field:'SCActive',width:50,title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'SCPrice',width:100,title:'����۸�'},
			{field:'SCMonths',width:150,title:'��ü��ʱ��(��)'},
			{field:'SCRemark',width:200,title:'��ע'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});

var QRDataGrid = $HUI.datagrid("#QRList",{
		url:$URL,
		title:"",
		bodyCls:'panel-body-gray',
		queryParams:{
			ClassName:"web.DHCHM.BaseDataSet",
			QueryName:"GetCSCQLink",
			theid:$("#SCID").val()
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				QClear_onclick();
				$("#QRID").val(rowData.ID);
				$("#Questionnaire").combobox("setValue",rowData.SCQLCQuestionnaireDR);
				$("#QSeq").val(rowData.SCQLOrder);
				$("#QRemark").val(rowData.SCQLRemark);		
			}
		},
		onDblClickRow:function(index,row){														
		},	
		columns:[[
			{field:'ID',hidden:true,sortable:'true'},
			{field:'SCQLCQuestionnaireDR',hidden:true},
			{field:'QDesc',width:200,title:'�ʾ�'},
			{field:'SCQLOrder',width:60,title:'˳��'},
			{field:'SCQLRemark',width:100,title:'��ע'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
/**
 * �������
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function ClearBtn_onclick(){
	$("#SCID").val("");
	$("#Code").val("");
	$("#Desc").val("");
	$("#Price").val("");
	$("#Months").val("");
	$("#Remark").val("");
	$("#Active").checkbox("check");
}

/**
 * ��ౣ��
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function SaveBtn_onclick(){
	var ID=$("#SCID").val();
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	var Price=$("#Price").val();
	var Months=$("#Months").val();
	var Remark=$("#Remark").val();
	var Active="N";
	if($("#Active").checkbox("getValue")){
		Active="Y";
	}
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var proStr="SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark";
	var valStr=Active+"^"+Code+"^"+Desc+"^"+Months+"^"+Price+"^"+Remark;
	try{
		var ret=tkMakeServerCall("web.DHCHM.BaseDataSet","CServiceClassSaveData",ID,valStr,proStr);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");      	
            SCDataGrid.load({ClassName:"web.DHCHM.BaseDataSet",QueryName:"GetCServiceClass"});
            ClearBtn_onclick();
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	} 
}
/**
 * �Ҳ�����
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QClear_onclick(){
	$("#QRID").val("");
	$("#Questionnaire").combobox("setValue","");
	$("#QSeq").val("");
	$("#QRemark").val("");
}
/**
 * ��������ʾ�
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QSave_onclick(){
	var ID=$("#QRID").val();
	var SCID=$("#SCID").val();
	var Questionnaire=$("#Questionnaire").combobox("getValue");
	var QSeq=$("#QSeq").val();
	var QRemark=$("#QRemark").val();
	if(SCID==""){
		$.messager.alert("��ʾ","����������Ϊ��","info");
		return false;
	}
	if(Questionnaire==""){
		$.messager.alert("��ʾ","�����ʾ���Ϊ��","info");
		return false;
	}
	if(QSeq==""){
		$.messager.alert("��ʾ","��Ų���Ϊ��","info");
		return false;
	}
	var property = "SCQLParRef^SCQLCQuestionnaireDR^SCQLOrder^SCQLRemark";
	var valList = SCID+"^"+Questionnaire+"^"+QSeq+"^"+QRemark;
	try{
		var ret=tkMakeServerCall("web.DHCHM.BaseDataSet","CSCQLinkSaveData",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");      	
            QRDataGrid.load({ClassName:"web.DHCHM.BaseDataSet",QueryName:"GetCSCQLink",theid:SCID});
            QClear_onclick();
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	} 
}
/**
 * ɾ�������ʾ�
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QDeleter_onclick(){
	var ID=$("#QRID").val();
	var SCID=$("#SCID").val();
	if(ID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������","info");
		return false;
	}
	$.messager.confirm("ɾ��", "ȷ��ɾ����¼?", function (r) {
		if (r) {
			try{
				var ret=tkMakeServerCall("web.DHCHM.BaseDataSet","CSCQLinkDelete",ID);
				if (parseInt(ret)<0) {
					var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
		            $.messager.alert("����","ɾ��ʧ��"+errMsg,"error");
					return false;
		        }else {
		        	$.messager.alert("�ɹ�","ɾ���ɹ�","success");      	
		            QRDataGrid.load({ClassName:"web.DHCHM.BaseDataSet",QueryName:"GetCSCQLink",theid:SCID});
		            QClear_onclick();
		        }
			}catch(err){
				$.messager.alert("����","ɾ��ʧ�ܣ�"+err.description,"error");
				return false;
			} 
		} else {
			
		}
	});
	
}