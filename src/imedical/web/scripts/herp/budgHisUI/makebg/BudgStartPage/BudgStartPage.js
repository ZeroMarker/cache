var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
$(function(){//��ʼ��
    Init();
}); 



function Init(){
	var height=(($(window).height()-10)*2)/9-45;
	$(".heightauto").css("height",height);
	var Height=(($(window).height()-10)*3)/9-45;
	$(".heightAuto").css("height",Height);
    var heightt=($(window).height()-45)/3;
	$(".heighttauto").css("height",heightt);
	
	var margin_top1=(($(window).height()-10)/6-45-$("li").height())/2;
	$("li").css("margin-top",margin_top1);
	
//���������С�仯ʱ	
  $(window).resize(function () {
	var height=(($(window).height()-10)*2)/9-45;
	$(".heightauto").css("height",height);
	var Height=(($(window).height()-10)*3)/9-45
	$(".heightAuto").css("height",Height);
    var heightt=($(window).height()-45)/3;
	$(".heighttauto").css("height",heightt);
	
	var margin_top1=(($(window).height()-10)/6-45-$("li").height())/2;
	$("li").css("margin-top",margin_top1);
});

/*	alert($(window).height()); //�������ǰ���ڿ�������߶�
	alert($(window).height()/4);
	var height=($(window).height()-10)/4-45;
	$(".heightauto").css("height",height);*/
	
///�����ת���溯��
function toPage(name){
	$.m({
		ClassName:'herp.budg.hisui.common.HUIHOME',
		MethodName:'GetMenuId', 
		name :name
	 },
	 function(data){
		 var datarr=data.split("^");
		 parent.addTab(datarr[1], datarr[0]);
	})			
}

///��ȡ��Ŀ����
function getNum(methodname,selectorid){
$.m({
	 ClassName:'herp.budg.hisui.udata.uBudgStartPage',
	 MethodName:methodname,
	 CompDR :hospid,
	 userid:userid
	 },
	function(count){
		changeColor(count,selectorid);
		if(count.length<=5){
		$(selectorid).text(count);
		}else{
		$(selectorid).text(0)	
		}
	});	
}

///��ɫ�仯����
function changeColor(count,id){
	if(count<=2){
		$(id).css("color","#229D7B");	
	}
	if((count>=3)&&(count<5)){
	    $(id).css("color","#F1B145");	
	}
	if(count>5){
		$(id).css("color","#D23D28");	
    }
}
	
///��ת�����������Ա�ҳ��
	$(".KSBZ").click(function(){
	  	toPage(" HERP.BUDG.HISUI.BUDGSCHEMMASELF");
  	})
///��ת�������������ҳ��
	$(".KSSH").click(function(){
		toPage(" HERP.BUDG.HISUI.BUDGSCHEMAUDITDEPTYEAR");			
	})
///��ת������ȫԺ����ҳ��
	$(".QYBZ").click(function(){
		toPage(" HERP.BUDG.HISUI.BUDGSCHEMWIDEHOS"); 
	})
///��ת������ȫԺ���ҳ�� 
	$(".QYSH").click(function(){ 
		toPage(" HERP.BUDG.HISUI.BUDGSCHEMAUDITWIDEHOS"); 
	})
///��ת��������������Ҷ���ҳ��   
	$(".KSDZ").click(function(){ 
		toPage(" HERP.BUDG.HISUI.BUDGU8HERP"); 
	})
///��ת�������������Ŀ����ҳ��  
	$(".KMDZ").click(function(){ 
		toPage(" HERP.BUDG.HISUI.BUDGU8HERPITEM"); 
	})

///�����ƿ���
getNum('getNoEstablishDept','#BZ1');	
		
//���ύ����
getNum('getNoSubmitDept','#BZ2');

//����˿���
getNum('NoAuditDept','#BZ3');
	
//���ύȫԺ
getNum('NoSubmithos','#BZ4');

//�����ȫԺ
getNum('NoAudithosScheme','#BZ5');
	
///��������Ŀ
getNum('getNoEstablishItem','#XM1');

///���ύ��Ŀ
getNum('getNoSubmitItem','#XM2');

///�������Ŀ
getNum('NoAuditItem','#XM3');
		
//��������Ҷ���
getNum('DeptComparison','#ZX1');

//�������Ŀ����
getNum('DeptComparison','#ZX2');

}