
/// Creator:    bianshuai
/// CreateDate: 2014-09-22
/// Descript:   ��д��ҩ���鴰��

function createMedAdviseWin(adm)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'��ҩ����',
		collapsible:true,
		border:true,
		closed:"true",
		width:1200,
		height:520,
		//collapsible:false,
		minimizable:false,					   /// ������С����ť
		maximized:true,						   /// ���(qunianpeng 2018/3/10)
		onClose:function(){
			$('#win').remove();  			   /// ���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}		
	}); 

	//iframe ����
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvises.csp?PatientID='+adm+'&EpisodeID='+adm+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
