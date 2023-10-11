/// 页面初始化函数
function initPageDefault(){
	initTodayAudit();
}

function initTodayAudit(){
	$cm({
		ClassName:"web.DHCPRESCOverview",
		MethodName:"GetTodayAuditDynamic",
	},function(jsonData){
		$('.ui-span').each(function(){
			$(this).text(jsonData[this.id]);
		})
	});
}


/// 自动设置图片展示区分布
function onresize_handler(){
	var Width = document.body.offsetWidth;
	var imgWidth = (Width - 120)/6;
	$(".pf-nav-item").width(imgWidth);
}
/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	/// 自动设置图片展示区分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;
/// JQuery 初始化页面
$(function(){ initPageDefault(); })