
/// Creator:    bianshuai
/// CreateDate: 2015-09-29
/// Descript:   ���˼໤��Ϣ����
function showPatMonWin(EpisodeID){
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	
	var offsetWidth=document.body.offsetWidth-100;
	var offsetHeight=document.body.offsetHeight-100;

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');
	//iframe ֱ�Ӽ���tab��div��

	$('#win').window({
		title:'����ҩѧ�����Ϣ��ѯ',
		collapsible:true,
		border:true,
		closed:"true",
		width:offsetWidth,
		height:offsetHeight,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	});
	$('#win').window('open');
}