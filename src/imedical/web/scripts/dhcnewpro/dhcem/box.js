

$(document).ready(function() {
		//$('#datetimepicker').datetimepicker({
		//    format: 'yyyy-mm-dd hh:ii'
		//});

		///$(".cc").on('click',function(){
		/// modalchange("hxy");
		//$(".modal-title").html('<i style="margin-right:6px;" class="fa fa-chevron-circle-down"></i>'+'提示')
		//$(".modal-title").addClass("dhccdialogtitle")
		//$(".modal-header").addClass("dhccdialogheader")
		//$(".modal-content").addClass("dhccdialog")
		//$(".close").addClass("dhccdialogclose")
		
	    //$('#CommonModel').modal()
		
	///})

	
})
function ee(){
	dhccBox.confirm("我的title","我的message","我的classname",function(result){ alert("3");})
	dhccBox.cusconfirm("我的title","我的message","我的classname","自定义按钮one","自定义按钮two",自定义按钮one的回调函数,自定义按钮two的回调函数)
	//dhccBox.cusconfirm("我的title","我的message","我的classname","自定义one","自定义two",function(result){ alert("3");},function(result){ alert("4");})
	//dhccBox.alert("message","className")
	//dhccBox.confirm("Your message he!!!!", function(result){ alert("1");})
}
//alert 规范
function dd(){
	bootbox.dialog({
	  message: "我的message",     // dialog的内容
	  //title: "Custom title",   // dialog的标题
	  onEscape: function() {},   // 退出dialog时的回调函数，包括用户使用ESC键及点击关闭 
	  animate: true,             // 是否动画弹出dialog，IE10以下版本不支持	  
	  className: "my-modalone",  // dialog的类名 
	  buttons: {                 // dialog底端按钮配置
	    success: {               // 其中一个按钮配置  
	      label: "确认",         // 按钮显示的名称
	      className: "btn-primary",
	      callback: function() {alert(1)}
	    },
	    "取消": {                // 另一个按钮配置
	      className: "btn-primary",
	      callback: function() {}
	    }
	  }
});
//dhccmodalstyle("title标题","className请唯一并与上方className保持一致");
dhccmodalstyle("我的title","my-modalone");
	
}
function a(){
	//dhccBox.confirm("Your message here…", function(result){ alert("1");})
	bootbox.dialog({
	  // dialog的内容
	  message: "I am a custom dialog",
	  // dialog的标题
	  title: "Custom title",
	  // 退出dialog时的回调函数，包括用户使用ESC键及点击关闭
	  onEscape: function() {}, 
	  //show: true,  // 是否显示此dialog，默认true  
	  //backdrop: true,  // 是否显示body的遮罩，默认true   
	  //closeButton: true,  // 是否显示关闭按钮，默认true
	  // 是否动画弹出dialog，IE10以下版本不支持
	  animate: true, 
	  // dialog的类名
	  className: "my-modal", 
	  // dialog底端按钮配置
	  buttons: {  
	    // 其中一个按钮配置
	    success: {   
	      // 按钮显示的名称
	      label: "Success!", 
	      // 按钮的类名
	      className: "btn-primary",
	      // 点击按钮时的回调函数
	      callback: function() {}
	    },
	    // 另一个按钮配置
	    "Danger!": {
	      className: "btn-primary",
	      callback: function() {}
	    }
	  }
});

//modalchange("hxy");

}
//function modalchange(hxy){
//	$(".modal-title").html('<i style="margin-right:6px;" class="fa fa-chevron-circle-down"></i>'+hxy )
//	$(".modal-title").addClass("dhccdialogtitle")
//	$(".modal-header").addClass("dhccdialogheader")
//	$(".modal-content").addClass("dhccdialog")
//	$(".close").addClass("dhccdialogclose")
//}
function a1(){
	alert(1)
	$('#myLinkToConfirm').confirmModal({
    confirmTitle     : 'Custom please confirm',
    confirmMessage   : 'Custom are you sure you want to perform this action ?',
    confirmOk        : 'Custom yes',
    confirmCancel    : 'Cutom cancel',
    confirmDirection : 'rtl',
    confirmStyle     : 'primary',
    confirmCallback  : defaultCallback,
    confirmDismiss   : true,
    confirmAutoOpen  : false
});
	//$('#myLinkToConfirm').confirmModal();
}

//隐藏modal所有元素
function conceal2(){
	$("#CommonModel .modal-header").removeClass("bg-warning")
	$("#CommonModel .modal-header").removeClass("bg-success")
	$("#CommonModel .modal-header").removeClass("bg-purple")
	$("#CommonModel .modal-header").removeClass("bg-danger")
	$("#CommonModel .modal-header").removeClass("bg-info")
	$('#changedate').css("display","none");
	$('#changetime').css("display","none");
	$('#patarea').css("display","none");
	$('#backoutarea').css("display","none");
	$('#Disinputdate').css("display","none");
	$('#Disinputtime').css("display","none");
}



