 
 /// 药学监护编辑
 var url="dhcpha.clinical.action.csp";
 
 var monAdmID="";
 var monSubClassId=""; //学科分类
 var monId="";         //监护ID
 var monIndex="";
 
 $(function(){

	 monAdmID=getParam("monAdmID");
	 monSubClassId=getParam("monSubClassId");

 	 $('li a').live('click',function(){
 	 	$(this).css({"background":"#87CEFA"}).parent()
 	 		.siblings().children().css({"background":"#FFFFFF"});
 	 		//showPatPhaSerWin();
	 })
 	 $('a:contains("提交")').bind("click",save);  //提交
 })
 
 /// 病人药学服务窗口
function showPatPhaSerWin(){

	if($('#monwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"药学服务查询",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		onClose:function(){
			$('#monwin').remove();  //窗口关闭时移除win的DIV标签
		}
	});

	var iframe='' //'<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.patphaserwin.csp?monAdmID='+monAdmID+'&monSubClassId='+monSubClassId+'"></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
}
 