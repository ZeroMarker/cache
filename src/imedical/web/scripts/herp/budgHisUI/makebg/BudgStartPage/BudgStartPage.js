var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
$(function(){//初始化
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
	
//当浏览器大小变化时	
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

/*	alert($(window).height()); //浏览器当前窗口可视区域高度
	alert($(window).height()/4);
	var height=($(window).height()-10)/4-45;
	$(".heightauto").css("height",height);*/
	
///点击跳转界面函数
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

///获取数目函数
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

///颜色变化函数
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
	
///跳转链接至科室自编页面
	$(".KSBZ").click(function(){
	  	toPage(" HERP.BUDG.HISUI.BUDGSCHEMMASELF");
  	})
///跳转链接至科室审核页面
	$(".KSSH").click(function(){
		toPage(" HERP.BUDG.HISUI.BUDGSCHEMAUDITDEPTYEAR");			
	})
///跳转链接至全院编制页面
	$(".QYBZ").click(function(){
		toPage(" HERP.BUDG.HISUI.BUDGSCHEMWIDEHOS"); 
	})
///跳转链接至全院审核页面 
	$(".QYSH").click(function(){ 
		toPage(" HERP.BUDG.HISUI.BUDGSCHEMAUDITWIDEHOS"); 
	})
///跳转链接至待处理科室对照页面   
	$(".KSDZ").click(function(){ 
		toPage(" HERP.BUDG.HISUI.BUDGU8HERP"); 
	})
///跳转链接至待处理科目对照页面  
	$(".KMDZ").click(function(){ 
		toPage(" HERP.BUDG.HISUI.BUDGU8HERPITEM"); 
	})

///待编制科室
getNum('getNoEstablishDept','#BZ1');	
		
//待提交科室
getNum('getNoSubmitDept','#BZ2');

//待审核科室
getNum('NoAuditDept','#BZ3');
	
//待提交全院
getNum('NoSubmithos','#BZ4');

//待审核全院
getNum('NoAudithosScheme','#BZ5');
	
///待编制项目
getNum('getNoEstablishItem','#XM1');

///待提交项目
getNum('getNoSubmitItem','#XM2');

///待审核项目
getNum('NoAuditItem','#XM3');
		
//待处理科室对照
getNum('DeptComparison','#ZX1');

//待处理科目对照
getNum('DeptComparison','#ZX2');

}