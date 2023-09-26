//===========================================================================================
/// Creator: yuliping
/// CreateDate: 2020-04-01
//  Descript: �����¼���עҵ����
//===========================================================================================
var NoteId=""           //��עid
$(document).ready(function(){
	recordId=getParam("recordId");  	//����д��¼id
	RepTypeDr=getParam("RepTypeDr"); 	//������id
	formid=getParam("formid");  		//��״̬����
	editFlag=getParam("editFlag");  	//�༭��־��0����ɾ�����水ť��ֻ��ʾ
	bandButtons();						//��ť��
	getNotesTable();						//��ע�б�
	
})
//��ť��
function bandButtons(){
	if(editFlag==1){
		$("#saveNotes").on("click",function(){ 		///����
			saveNotes();
		})
		$("#deleteNotes").on("click",function(){ 		///ɾ��
			deleteNotes();
		})
	}else{
		$("#saveNotes").hide();					
		$("#deleteNotes").hide();
	}
}

//������ע
function saveNotes(){
	var addNotes=$.trim($('#addNotes').val());
	if(addNotes==""){
		$.messager.alert("��ʾ","��ע���ݲ���Ϊ�գ�");
		return ;
	}
	if(addNotes.length>1500){
		$.messager.alert("��ʾ","��ע���ݳ�����");
		return ;
	}
	var params=recordId+"^"+RepTypeDr+"^"+formid+"^"+addNotes+"^"+UserId;
	runClassMethod("web.DHCADVReportNote","saveRepNotes",{"ListData":params,"NoteId":NoteId},function(rtn){
		if(rtn > 0){
			$.messager.alert("��ʾ","��ע�ѱ��棡");
			reloadNoteTable();
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ�"+rtn);
			}
	},"text",false)
}

///��ʼ����ע�б�
function getNotesTable(){
	var columns=[[
		{field:'Notes',title:'��������',width:100,align:'center',hidden:true},
		{field:'userName',title:'��ע��',width:100,align:'center'},
		{field:'NoteId',title:'ID',width:100,align:'center',hidden:true},
		{field:'AuditDate',title:'��עʱ��',width:260,align:'center'},
		{field:'DicField',title:'Ԫ��',width:100,align:'center',hidden:true}
	]];
	$HUI.datagrid("#notesTable",{
		url:$URL+"?ClassName=web.DHCADVReportNote&MethodName=jsonNotes",
		toolbar:'#toolbar',
		queryParams:{
			recordId:recordId,
			typeId:RepTypeDr,
			formDicId:formid
		},
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onSelect:function(rowIndex,rowData){
				$("#addNotes").val(rowData.Notes);
				NoteId=rowData.NoteId;
		},
		onLoadSuccess:function(data){
			addShowNotesBut(data.DicField);
		}
	});		
}

//��ע�б����¼���
function reloadNoteTable(){
	$HUI.datagrid("#notesTable",{
		queryParams:{
			recordId:recordId,
			typeId:RepTypeDr,
			formDicId:formid
		}
	})
	$("#addNotes").val("");
	NoteId="";
}
//ɾ��
function deleteNotes(){
	var rows = $("#notesTable").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCADVReportNote","deleteNotes",{"NoteId":NoteId}, function(rtn){
					if(rtn == 0){
						$.messager.alert("��ʾ","ɾ���ɹ���");
						reloadNoteTable();
					}else{
						$.messager.alert("��ʾ","ɾ��ʧ�ܣ�" + rtn);
					}
				},"text",false)
			}
		})
	}
}

