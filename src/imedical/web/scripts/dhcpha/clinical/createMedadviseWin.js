
/// Creator:    bianshuai
/// CreateDate: 2014-09-22
/// Descript:   填写用药建议窗口

function createMedAdviseWin(adm)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'用药建议',
		collapsible:true,
		border:true,
		closed:"true",
		width:1200,
		height:520,
		//collapsible:false,
		minimizable:false,					   /// 隐藏最小化按钮
		maximized:true,						   /// 最大化(qunianpeng 2018/3/10)
		onClose:function(){
			$('#win').remove();  			   /// 窗口关闭时移除win的DIV标签
		}		
	}); 

	//iframe 定义
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvises.csp?PatientID='+adm+'&EpisodeID='+adm+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
