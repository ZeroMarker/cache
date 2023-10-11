/// Creator:    bianshuai
/// CreateDate: 2014-09-22
/// Descript:   填写药历窗口

function createMedRecordWin(EpisodeID,PatientID,drugSearchLocID)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:$g('药历书写'),
		collapsible:true,
		border:true,
		closed:"true",
		width:1200,
		height:520,
		minimizable:false,						/// 隐藏最小化按钮
		maximized:true,							/// 最大化(qunianpeng 2018/3/15)	
		onClose:function(){
			$('#win').remove(); 				/// 窗口关闭时移除win的DIV标签
		}
	}); 


	var InsVal="";
	var EpisodeVal=EpisodeID;
	var PatientVal=PatientID;
	var CategoryVal="";

	//iframe 定义
	//var iframe = '<iframe width=100% height=100% src=epr.newfw.main.csp?EpisodeID='+ EpisodeID+' frameborder=0 framespacing=0></iframe>';
	//var iframe = '<iframe width=100% height=100% src=dhcmed.epr.newfw.centertablistdetial.csp?PatientID='+PatientVal+'&EpisodeID='+EpisodeVal+'&TemplateID=525&CategoryID=337&CategoryType=Group&ChartItemID=ML315&ProfileID=ML315&TemplateName=药历&TemplateDocID=765 frameborder=0 framespacing=0></iframe>';
	var iframe = '<iframe width=100% height=100% src=dhcpha.clinical.drugrecord.csp?PatientID='+PatientVal+'&EpisodeID='+EpisodeVal+'&drugSearchLocID='+drugSearchLocID+' frameborder=0 framespacing=0></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
