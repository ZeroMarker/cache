/// 删除弹窗
function removePopUpWin(){
	$("#PopUpWin").remove(); 
} 

/// 增加弹出div的样式设置
var style1 = document.createElement('style');
style1.innerHTML = '#PopUpWin .fixed-table-container thead th .th-inner, #PopUpWin .fixed-table-container tbody td .th-inner{line-height:14px;}';
document.head.appendChild(style1);
 
var PopUpWin = function(tarobj, width, height, url, fn){
	this.tarobj = tarobj;
	this.width = width;
	this.height = height;
	this.url = url;
	this.fn = fn;
}

PopUpWin.prototype.init=function(){
	var fn = this.fn;

	///创建弹出窗体
	//$(document.body).append('<div id="PopUpWin" style="width:'+ this.width +'px;height:'+ this.height +'px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#E0ECFF;"></div>') 
	//$("#PopUpWin").append('<table id="PopUpWin_Table"></table>');	
	$("#PopUpWin").show();
	$("#PopUpWin").css("left",this.tarobj.offset().left);
	$("#PopUpWin").css("top",this.tarobj.offset().top+ this.tarobj.outerHeight());

	$(window).bind('keydown', function (e){
		//Esc
		if (e.keyCode == 27){
			removePopUpWin();
		}
	})
}
