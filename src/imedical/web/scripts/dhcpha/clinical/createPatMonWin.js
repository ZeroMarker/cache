
/// Creator:    bianshuai
/// CreateDate: 2015-09-29
/// Descript:   病人监护信息窗口
function showPatMonWin(EpisodeID){
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	
	var offsetWidth=document.body.offsetWidth-100;
	var offsetHeight=document.body.offsetHeight-100;

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');
	//iframe 直接加在tab的div中

	$('#win').window({
		title:'病人药学监测信息查询',
		collapsible:true,
		border:true,
		closed:"true",
		width:offsetWidth,
		height:offsetHeight,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	});
	$('#win').window('open');
}