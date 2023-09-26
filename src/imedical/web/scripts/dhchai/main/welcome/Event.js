//页面Event
function InitWelcomePageEvent(obj){
	$("#multipleDrug li").click(function(){
		var index=$("#multipleDrug li").index(this);
		$(this).removeClass().addClass("active").siblings().removeClass();
		var num=index*1+2;
		var chosenId='#main'+num;
		$(chosenId).css("display","block");
		$(chosenId).siblings().css("display","none");
	});
	$("#fever li").click(function(){
		var index=$("#fever li").index(this);
		$(this).removeClass().addClass("active").siblings().removeClass();
		var num=index*1+2;
		var chosenId='#fever'+num;
		$(chosenId).css("display","block");
		$(chosenId).siblings().css("display","none");
	});
}
function btnUnCheck_Click(){
	    var acurrDate = $.form.GetCurrDate('-');
		//var url="dhchai.ir.inf.repqry.csp?1=1&currDate="+acurrDate+'&Status='+113+'&flag='+1+"&2=2";
		var RepType = "1|2"
		var url="dhchai.ir.inf.repqry.csp?1=1&currDate="+acurrDate+'&Status='+113+'&flag='+1+'&aRepType='+RepType+"&2=2";
		//parent.layer.open({
		layer.open({
		      type: 2,
			  area: ['95%', '100%'],
			  title:'未审核报告',
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no'],
		});
}
function btnUnTreated_Click(){
		var url="dhcma.hai.ir.ccscreening.csp?1=1";
		//parent.layer.open({
		layer.open({
		      type: 2,
			  area: ['95%', '100%'],
			  title:'疑似未处理',
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no'],
		});
}

function btnclinicalfeedback_Click(){
		var url="dhcma.hai.ir.ccscreening.csp?1=1"+"&LocFlag="+""+"&IsFinflag="+1;
		//var url="dhchai.ir.ccscreening.csp?1=1&IsFinflag=1&2=2";
		//parent.layer.open({
		layer.open({
		      type: 2,
			  area: ['95%', '100%'],
			  title:'确诊未上报',
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no'],
		});
}

function btnInfMrb_Click(){
		//var url="dhchai.ir.ccscreening.csp?1=1";
		var url="dhchai.ir.mrb.ctlresult.csp?1=1&HomeFlag=1";
		//parent.layer.open({
		layer.open({
		      type: 2,
			  area: ['95%', '100%'],
			  title:'多重耐药菌未处理',
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no'],
		});
}
