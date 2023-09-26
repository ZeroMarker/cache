$(function(){
	var tabs = $('#feedbacktab').tabs().tabs('tabs');
	for(var i=0; i<tabs.length; i++){
		tabs[i].panel('options').tab.unbind().bind('mouseenter',{index:i},function(e){
			$('#feedbacktab').tabs('select', e.data.index);
		});
	}
});


var Infocolumns = [[
		{field:'name',title:'FiledName',width:100,sortable:true},
		{field:'value',title:'FiledValue',width:100,resizable:false}
	]];


$('#patinfo').propertygrid({
	url: '../EMRservice.Ajax.feedbackissue.cls?action=GetPatientInfo&episodeID='+episodeID,
	method: 'get',
	showHeader:false,
	showGroup: false,
	scrollbarSize:0,
	columns: Infocolumns,
	groupFormatter: groupFormatter
});

$('#docinfo').propertygrid({
	url: '../EMRservice.Ajax.feedbackissue.cls?action=GetDoctorInfo&userID='+userID,
	method: 'get',
	showHeader:false,
	showGroup: false,
	scrollbarSize:0,
	columns: Infocolumns,
	groupFormatter: groupFormatter
});

function groupFormatter(fvalue, rows){
	return fvalue + ' - <span style="color:red">' + rows.length + ' rows</span>';
}

function save(){
	var messagecontent=$("#feedBackText").val();
	//�滻���еĻ��з�
	if (messagecontent=="")
	{
		alert("δ��д������Ϣ����,����д,�����ˣ�");
		return;
		
	}
	var messagecontent=ValueReplace(messagecontent);
	
	jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.feedbackissue.cls",
			async : true,
			data : {"action":"SaveFeedBack","FeedBackIssue":messagecontent,"episodeID":episodeID,"userID":userID},
			success : function(d) {
	           if ( d != "") 
			   {
				   alert("���ⷴ���ɹ���лл���İ�����")
			   }
			},
			error : function(d) { alert("����ʧ�ܣ���绰4748");}
	});
	
	
};



function saveDocInfo(){
	var DocInfo="";
	var rows = $('#docinfo').propertygrid('getChanges');
	if(rows==""){
		return;	
	}
	for(var i=0; i<rows.length; i++){
		  DocInfo += rows[i].name + ':' + rows[i].value + ',';
	}
	
	jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.feedbackissue.cls",
			async : true,
			data : {"action":"SaveDocInfo","DoctorInfo":DocInfo,"episodeID":episodeID,"userID":userID},
			success : function(d) {
	           return;
			},
			error : function(d) { alert("����ʧ�ܣ���绰4748");}
	});
	
	
};


function send(){
		saveDocInfo();
		save();
	}
	
function ValueReplace(v)
{
	//�滻���лس�
	var v=v.replace(new RegExp("\n","gm"),"");
	
	//�滻����˫����
	var v=v.replace(new RegExp("\"","gm"),"\'");
	
	return v;	
}

function showHelp()
{
	window.open ('../scripts/emr/help/help.html','���Ӳ���ʹ���ֲ�','height=600,width=800?toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no') 
}