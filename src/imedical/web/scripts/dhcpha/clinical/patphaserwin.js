 
 /// ҩѧ�໤�༭
 var url="dhcpha.clinical.action.csp";
 
 var monAdmID="";
 var monSubClassId=""; //ѧ�Ʒ���
 var monId="";         //�໤ID
 var monIndex="";
 
 $(function(){

	 monAdmID=getParam("monAdmID");
	 monSubClassId=getParam("monSubClassId");

 	 $('li a').live('click',function(){
 	 	$(this).css({"background":"#87CEFA"}).parent()
 	 		.siblings().children().css({"background":"#FFFFFF"});
 	 		//showPatPhaSerWin();
	 })
 	 $('a:contains("�ύ")').bind("click",save);  //�ύ
 })
 
 /// ����ҩѧ���񴰿�
function showPatPhaSerWin(){

	if($('#monwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"ҩѧ�����ѯ",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		onClose:function(){
			$('#monwin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	var iframe='' //'<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.patphaserwin.csp?monAdmID='+monAdmID+'&monSubClassId='+monSubClassId+'"></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
}
 