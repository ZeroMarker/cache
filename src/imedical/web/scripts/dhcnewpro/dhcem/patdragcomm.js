// by zhangxinxu welcome to visit my personal website http://www.zhangxinxu.com/
// zxx.drag v1.0 2010-03-23 Ԫ�ص���קʵ��

var params = {
	left: 0,
	top: 0,
	currentX: 0,
	currentY: 0,
	flag: false
};

var dragPatInfo={
	regNo:"",
	seatId:""
	}

//��ȡ���CSS����
var getCss = function(o,key){
	return o.currentStyle? o.currentStyle[key] : document.defaultView.getComputedStyle(o,false)[key]; 	
};

//��ק��ʵ��
var startDrag = function(bar, target, callback ,endcallback){
	if(getCss(target, "left") !== "auto"){
		params.left = getCss(target, "left");
	}
	if(getCss(target, "top") !== "auto"){
		params.top = getCss(target, "top");
	}
	//o���ƶ�����
	bar.onmousedown = function(event){
		$(this).css("z-index","9999");     //����div�߶�Ϊ���
		params.flag = true;
		if(!event){
			event = window.event;
			//��ֹIE����ѡ��
			bar.onselectstart = function(){
				return false;
			}  
		}
		var e = event;
		params.currentX = e.clientX;
		params.currentY = e.clientY;
	};
	document.onmouseup = function(){
		params.flag = false;	
		if(getCss(target, "left") !== "auto"){
			params.left = getCss(target, "left");
		}
		if(getCss(target, "top") !== "auto"){
			params.top = getCss(target, "top");
		}

		target.style.left ="0px";
		target.style.top = "0px";
		$(this).css("z-index","0");     //��ֹͣ�϶���ʱ�����ø߶�
		dragPatInfo.seatId = $(bar).find(".ArrangeBtn").attr("seatid");
		dragPatInfo.regNo = $(bar).find(".Transfuse").attr("regno");
		endcallback();
	};
	document.onmousemove = function(event){
		var e = event ? event: window.event;
		if(params.flag){
			var nowX = e.clientX, nowY = e.clientY;
			var disX = nowX - params.currentX, disY = nowY - params.currentY;
			target.style.left = parseInt(params.left) + disX + "px";
			target.style.top = parseInt(params.top) + disY + "px";
		}
		
		if (typeof callback == "function") {
			callback(parseInt(params.left) + disX, parseInt(params.top) + disY);
		}
	}	
};