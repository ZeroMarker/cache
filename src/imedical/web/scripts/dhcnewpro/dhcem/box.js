

$(document).ready(function() {
		//$('#datetimepicker').datetimepicker({
		//    format: 'yyyy-mm-dd hh:ii'
		//});

		///$(".cc").on('click',function(){
		/// modalchange("hxy");
		//$(".modal-title").html('<i style="margin-right:6px;" class="fa fa-chevron-circle-down"></i>'+'��ʾ')
		//$(".modal-title").addClass("dhccdialogtitle")
		//$(".modal-header").addClass("dhccdialogheader")
		//$(".modal-content").addClass("dhccdialog")
		//$(".close").addClass("dhccdialogclose")
		
	    //$('#CommonModel').modal()
		
	///})

	
})
function ee(){
	dhccBox.confirm("�ҵ�title","�ҵ�message","�ҵ�classname",function(result){ alert("3");})
	dhccBox.cusconfirm("�ҵ�title","�ҵ�message","�ҵ�classname","�Զ��尴ťone","�Զ��尴ťtwo",�Զ��尴ťone�Ļص�����,�Զ��尴ťtwo�Ļص�����)
	//dhccBox.cusconfirm("�ҵ�title","�ҵ�message","�ҵ�classname","�Զ���one","�Զ���two",function(result){ alert("3");},function(result){ alert("4");})
	//dhccBox.alert("message","className")
	//dhccBox.confirm("Your message he!!!!", function(result){ alert("1");})
}
//alert �淶
function dd(){
	bootbox.dialog({
	  message: "�ҵ�message",     // dialog������
	  //title: "Custom title",   // dialog�ı���
	  onEscape: function() {},   // �˳�dialogʱ�Ļص������������û�ʹ��ESC��������ر� 
	  animate: true,             // �Ƿ񶯻�����dialog��IE10���°汾��֧��	  
	  className: "my-modalone",  // dialog������ 
	  buttons: {                 // dialog�׶˰�ť����
	    success: {               // ����һ����ť����  
	      label: "ȷ��",         // ��ť��ʾ������
	      className: "btn-primary",
	      callback: function() {alert(1)}
	    },
	    "ȡ��": {                // ��һ����ť����
	      className: "btn-primary",
	      callback: function() {}
	    }
	  }
});
//dhccmodalstyle("title����","className��Ψһ�����Ϸ�className����һ��");
dhccmodalstyle("�ҵ�title","my-modalone");
	
}
function a(){
	//dhccBox.confirm("Your message here��", function(result){ alert("1");})
	bootbox.dialog({
	  // dialog������
	  message: "I am a custom dialog",
	  // dialog�ı���
	  title: "Custom title",
	  // �˳�dialogʱ�Ļص������������û�ʹ��ESC��������ر�
	  onEscape: function() {}, 
	  //show: true,  // �Ƿ���ʾ��dialog��Ĭ��true  
	  //backdrop: true,  // �Ƿ���ʾbody�����֣�Ĭ��true   
	  //closeButton: true,  // �Ƿ���ʾ�رհ�ť��Ĭ��true
	  // �Ƿ񶯻�����dialog��IE10���°汾��֧��
	  animate: true, 
	  // dialog������
	  className: "my-modal", 
	  // dialog�׶˰�ť����
	  buttons: {  
	    // ����һ����ť����
	    success: {   
	      // ��ť��ʾ������
	      label: "Success!", 
	      // ��ť������
	      className: "btn-primary",
	      // �����ťʱ�Ļص�����
	      callback: function() {}
	    },
	    // ��һ����ť����
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

//����modal����Ԫ��
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



