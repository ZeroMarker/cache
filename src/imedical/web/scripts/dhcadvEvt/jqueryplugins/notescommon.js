//===========================================================================================
/// Creator: yuliping
/// CreateDate: 2020-04-02
//  Descript: �����¼���ע����js
//===========================================================================================

//����� ����Ԫ�ذ���ע
function bandFromNotes(){
	getFormDic();   ////���ݱ�idȡ��Ԫ�ز�����ע��ť
	getNotes();     ///ȡ����ע��Ϣ
}
	
//���ݱ�idȡ��Ԫ�� yuliping 2020-03-30
function getFormDic(){
	if(recordId == "") return
	runClassMethod("web.DHCADVFormDicContrast","jsonFormDicNew",{"FormID":$("#formId").val()},function(jsonStr){
		if(jsonStr != ""){
			var length = jsonStr.length;
			for(var i=0; i < length; i++){
				bandAddnotes(jsonStr[i].code);
				}
			}
		},"json",false)
	
	
	}
	
var noteflag = 1  //Ψһ��־�������ظ����
//Ԫ�ذ�tooltip yuliping 	2020-03-30
function bandAddnotes(id){
	var dom='"' + id + '"';
	$("#"+id).tooltip({position: 'top',
	    content: "<button onclick='addNotes("+dom+")' style='background-color:#fff;border:0px;'>�����ע</button>",
	    hideDelay: 600,
	    showDelay: 1,
	    onShow: function(){
		    if (noteflag == 1) {
				$(this).tooltip('tip').css({
					borderradius: 5
				});
				$(this).addClass("add-notes");
		    }
			noteflag = 0;
	    },
	    onHide: function(){
			$(".add-notes").removeClass("add-notes");
			noteflag = 1;
		}
    }) 
}

//��ע����csp yuliping 2020-03-30
function addNotes(id){
	if($('#noteswin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="noteswin"></div>');
	$('#noteswin').window({
		title:'������ע',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:850,    
		height:350,
		top:$('body').scrollTop() + ((screen.availHeight-400)/4)
	});
	
	var iframe = '<iframe scrolling="no" width=800 style="margin-left:20px" height=300  frameborder="0" src="dhcadv.addnotes.csp?recordId='+recordId+'&RepTypeDr='+RepTypeDr+'&formid='+id+'&editFlag=1"></iframe>';	
	$('#noteswin').html(iframe);
	$('#noteswin').window('open');

}
//����ע��ʾ���  yuliping 2020-04-01
function getNotes(){
	runClassMethod("web.DHCADVReportNote","jsonOnlyNotes",{"recordId":recordId,"typeId":RepTypeDr},function(jsonStr){
		if(jsonStr != ""){
			for(var i = 0; i < jsonStr.length; i++){
				addShowNotesBut(jsonStr[i].DicField);
			}
		}
	},"json",false)
}
//����ע��Ӱ�ť yuliping 2020-03-31
function addShowNotesBut(id){
	var domId = '"' + id + '"';
	var html = "<img src='../scripts/dhcadvEvt/images/warning.png' onclick='showNotes(" + domId + ")' style=''></img>";
	$("#"+id).after(html);
}

//����ע��ʾ���� yuliping 2020-04-01
function showNotes(domId){
	if($('#noteswin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="noteswin"></div>');
	$('#noteswin').window({
		title:'��ע��Ϣ',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:850,    
		height:350,
		top:$('body').scrollTop() + ((screen.availHeight-400)/4)
	});

	var iframe = '<iframe scrolling="no" width=800 style="margin-left:20px" height=300  frameborder="0" src="dhcadv.addnotes.csp?recordId='+recordId+'&RepTypeDr='+RepTypeDr+'&formid='+domId+'&editFlag=0"></iframe>';
	$('#noteswin').html(iframe);
	$('#noteswin').window('open');
}
