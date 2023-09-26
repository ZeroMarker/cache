//===========================================================================================
/// Creator: yuliping
/// CreateDate: 2020-04-01
//  Descript: 不良事件批注业务处理
//===========================================================================================
var NoteId=""           //批注id
$(document).ready(function(){
	recordId=getParam("recordId");  	//表单填写记录id
	RepTypeDr=getParam("RepTypeDr"); 	//表单类型id
	formid=getParam("formid");  		//表单状态描述
	editFlag=getParam("editFlag");  	//编辑标志，0隐藏删除保存按钮，只显示
	bandButtons();						//按钮绑定
	getNotesTable();						//批注列表
	
})
//按钮绑定
function bandButtons(){
	if(editFlag==1){
		$("#saveNotes").on("click",function(){ 		///保存
			saveNotes();
		})
		$("#deleteNotes").on("click",function(){ 		///删除
			deleteNotes();
		})
	}else{
		$("#saveNotes").hide();					
		$("#deleteNotes").hide();
	}
}

//保存批注
function saveNotes(){
	var addNotes=$.trim($('#addNotes').val());
	if(addNotes==""){
		$.messager.alert("提示","批注内容不能为空！");
		return ;
	}
	if(addNotes.length>1500){
		$.messager.alert("提示","批注内容超长！");
		return ;
	}
	var params=recordId+"^"+RepTypeDr+"^"+formid+"^"+addNotes+"^"+UserId;
	runClassMethod("web.DHCADVReportNote","saveRepNotes",{"ListData":params,"NoteId":NoteId},function(rtn){
		if(rtn > 0){
			$.messager.alert("提示","批注已保存！");
			reloadNoteTable();
			}else{
				$.messager.alert("提示","保存失败！"+rtn);
			}
	},"text",false)
}

///初始化批注列表
function getNotesTable(){
	var columns=[[
		{field:'Notes',title:'审批内容',width:100,align:'center',hidden:true},
		{field:'userName',title:'批注人',width:100,align:'center'},
		{field:'NoteId',title:'ID',width:100,align:'center',hidden:true},
		{field:'AuditDate',title:'批注时间',width:260,align:'center'},
		{field:'DicField',title:'元素',width:100,align:'center',hidden:true}
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
		loadMsg: '正在加载信息...',
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

//批注列表重新加载
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
//删除
function deleteNotes(){
	var rows = $("#notesTable").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVReportNote","deleteNotes",{"NoteId":NoteId}, function(rtn){
					if(rtn == 0){
						$.messager.alert("提示","删除成功！");
						reloadNoteTable();
					}else{
						$.messager.alert("提示","删除失败！" + rtn);
					}
				},"text",false)
			}
		})
	}
}

