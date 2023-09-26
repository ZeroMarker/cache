/**
 * �ʾ�����ά��  dhchm.questionsubject.js
 * @Author   wangguoying
 * @DateTime 2019-07-07
 */

var SubjectDataGrid = $HUI.datagrid("#SubjectList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.QuestionnaireSet",
			QueryName:"FindQSubject",
			ParRef:$("#QuestionDR").val()
		},
		onSelect:function(rowIndex,rowData){
			$("#SubjectDR").val(rowData.QSID);
			$("#SCode").val(rowData.QSCode);
			$("#SDesc").val(rowData.QSDesc);
			$("#SRemark").val(rowData.QSRemark);
			$("#SOrder").val(rowData.QSOrder);
			if(rowData.QSActive=="true"){
				$("#SActive").checkbox("check");			
			}else{
				$("#SActive").checkbox("uncheck");
			}
			QDetailDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindCSDLink",ParRef:rowData.QSID});
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QSID',hidden:true,sortable:'true'},
			{field:'QSCode',width:30,title:'����'},
			{field:'QSDesc',width:150,title:'����'},
			{field:'QSOrder',width:40,title:'˳��'},
			{field:'QSActive',width:30,title:'����',align:"center",
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QSRemark',width:80,title:'��ע'}
		]],
		pagination:true,
		pageSize:10,
		fitColumns:true,
		fit:true,
		rownumbers:true
	});
	

var QDetailDataGrid = $HUI.datagrid("#QDetailList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.QuestionnaireSet",
			QueryName:"FindCSDLink",
			ParRef:$("#SubjectDR").val()
		},
		onSelect:function(rowIndex,rowData){
			$("#SDLDR").val(rowData.SDLID);
			$("#QDOrder").val(rowData.SDLOrder);
			if(rowData.SDLActive=="true"){
				$("#QDActive").checkbox("check");
			}else{
				$("#QDActive").checkbox("uncheck");
			}
			initQuestionCombogrid(rowData.QDDesc);
			$("#QDetailDR").combogrid("setValue",rowData.SDLQuestionsDetailDR);
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'SDLID',hidden:true,sortable:'true'},
			{field:'SDLQuestionsDetailDR',hidden:true,sortable:'true'},
			{field:'QDDesc',width:200,title:'�ʾ�����'},
			{field:'SDLOrder',width:80,title:'��ʾ˳��'},
			{field:'SDLActive',width:50,title:'����',align:"center",
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:10,
		fit:true,
		rownumbers:true
	});
	
function subject_clean(){
	$("#SubjectDR").val("");
	$("#SCode").val("");
	$("#SDesc").val("");
	$("#SRemark").val("");
	$("#SOrder").val("");
	$("#SActive").checkbox("check");
}


function suject_save(){
	var ID=$("#SubjectDR").val();
	var Code=$("#SCode").val();
	var Desc=$("#SDesc").val();
	var Remark=$("#SRemark").val();
	var Order=$("#SOrder").val();
	var QuesDr=$("#QuestionDR").val();
	var Active="N";
	if($("#SActive").checkbox("getValue")){
		Active="Y";
	}
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	var property = 'QSActive^QSCode^QSDesc^QSOrder^QSParRef^QSRemark';
	var valList=Active+"^"+Code+"^"+Desc+"^"+Order+"^"+QuesDr+"^"+Remark;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","QSSave",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");     
        	subject_clean();	
            SubjectDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindQSubject",ParRef:QuesDr});
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}
	
function QDetail_clean()
{
	$("#SDLDR").val("");
	$("#QDOrder").val("");
	$("#QDActive").checkbox("check");
	$("#QDetailDR").combogrid("setValue","");
	initQuestionCombogrid("");
}	
	
function QDetail_save(){
	var ID=$("#SDLDR").val();
	var Order=$("#QDOrder").val();
	if(Order==""){
		$.messager.alert("��ʾ","��ʾ˳����Ϊ��","info");
		return false;
	}
	var Active="N";
	if($("#QDActive").checkbox("getValue")){
		Active="Y";
	}
	var ParRef=$("#SubjectDR").val();	
	if(ParRef==""){
		$.messager.alert("��ʾ","δѡ������","info");
		return false;
	}
	var DetailDr=$("#QDetailDR").combogrid("getValue");
	if(DetailDr==""||DetailDr=="undefined"){
		$.messager.alert("��ʾ","�ʾ����ݲ���Ϊ��","info");
		return false;
	}
	var property = 'SDLActive^SDLOrder^SDLParRef^SDLQuestionsDetailDR';
	var valList=Active+"^"+Order+"^"+ParRef+"^"+DetailDr;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","SDLSave",ID,valList,property,ParRef,DetailDr);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");     
        	QDetail_clean();	
            QDetailDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindCSDLink",ParRef:ParRef});
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}
function initQuestionCombogrid(Desc){
	var QuestionCombogrid=$("#QDetailDR").combogrid({
		panelWidth: 350,
        idField: 'SDLQuestionsDetailDR',
        textField: 'QDDesc',
        method: 'get',
        url:$URL+'?ClassName=web.DHCHM.QuestionnaireSet&QueryName=FindQD',
        onBeforeLoad:function(param){
        	if(Desc!==""){
        		param.Desc = Desc;
        	}else{
        		param.Desc=param.q;
        	}
			
		},
		mode:'remote',
		delay:200,
        columns: [[           				            			
			{field:'QDCode',title:'����',width:80},
			{field:'QDDesc',title:'����',width:200},
			{field:'SDLQuestionsDetailDR',title:'ID',width:80}
		]],
        onLoadSuccess: function () {
            					
       },
       fitColumns:true,
	   pagination:true,
	   pageSize:50,
	   displayMsg:""       	
	});
}
	
function init(){
	initQuestionCombogrid("");
	setGridHeight();
}


function setGridHeight()
{
	$("#SubjectListDiv").height($("#SubjectPanel").height()-204);
	SubjectDataGrid.resize();
	$("#QDetailListDiv").height($("#QuesPanel").height()-165);
	QDetailDataGrid.resize();

}

$(init);