/// ҳ���ʼ������
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


/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	var Width = document.body.offsetWidth;
	var imgWidth = (Width - 120)/6;
	$(".pf-nav-item").width(imgWidth);
}
/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	/// �Զ�����ͼƬչʾ���ֲ�
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })