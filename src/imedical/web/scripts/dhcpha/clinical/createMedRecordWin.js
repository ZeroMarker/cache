/// Creator:    bianshuai
/// CreateDate: 2014-09-22
/// Descript:   ��дҩ������

function createMedRecordWin(EpisodeID,PatientID,drugSearchLocID)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:$g('ҩ����д'),
		collapsible:true,
		border:true,
		closed:"true",
		width:1200,
		height:520,
		minimizable:false,						/// ������С����ť
		maximized:true,							/// ���(qunianpeng 2018/3/15)	
		onClose:function(){
			$('#win').remove(); 				/// ���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	}); 


	var InsVal="";
	var EpisodeVal=EpisodeID;
	var PatientVal=PatientID;
	var CategoryVal="";

	//iframe ����
	//var iframe = '<iframe width=100% height=100% src=epr.newfw.main.csp?EpisodeID='+ EpisodeID+' frameborder=0 framespacing=0></iframe>';
	//var iframe = '<iframe width=100% height=100% src=dhcmed.epr.newfw.centertablistdetial.csp?PatientID='+PatientVal+'&EpisodeID='+EpisodeVal+'&TemplateID=525&CategoryID=337&CategoryType=Group&ChartItemID=ML315&ProfileID=ML315&TemplateName=ҩ��&TemplateDocID=765 frameborder=0 framespacing=0></iframe>';
	var iframe = '<iframe width=100% height=100% src=dhcpha.clinical.drugrecord.csp?PatientID='+PatientVal+'&EpisodeID='+EpisodeVal+'&drugSearchLocID='+drugSearchLocID+' frameborder=0 framespacing=0></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
