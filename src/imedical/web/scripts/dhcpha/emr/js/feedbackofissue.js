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
	//替换所有的换行符
	if (messagecontent=="")
	{
		alert("未填写反馈信息内容,请填写,辛苦了！");
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
				   alert("问题反馈成功，谢谢您的帮助！")
			   }
			},
			error : function(d) { alert("发送失败！请电话4748");}
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
			error : function(d) { alert("发送失败！请电话4748");}
	});
	
	
};


function send(){
		saveDocInfo();
		save();
	}
	
function ValueReplace(v)
{
	//替换所有回车
	var v=v.replace(new RegExp("\n","gm"),"");
	
	//替换所有双引号
	var v=v.replace(new RegExp("\"","gm"),"\'");
	
	return v;	
}

function showHelp()
{
	window.open ('../scripts/emr/help/help.html','电子病历使用手册','height=600,width=800?toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no') 
}