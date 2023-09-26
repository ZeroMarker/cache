ImportJqueryUI();

var createMedication = function(Params){
	this.Params = Params;	
}
	
createMedication.prototype.init=function(){	

	initTable();
	
	initDiv();
	
	dragDiv();
	
	initMethod();
	
	
}

addTr = "";
addTrs="";
//加载CSS liangqiang 2014-05-20
function ImportCssByLink(url){  
  var link = document.createElement("link");
	  link.type = "text/css";
	  link.rel = "stylesheet";
	  link.href = url;
	  document.getElementsByTagName("head")[0].appendChild(link);
     
}

//加载JqueryUI相关环境
function ImportJqueryUI()
{
	var url="../scripts/dhcnewpro/dhcem/css/medication.css"
	ImportCssByLink(url)
}
//动态生成div
function initTable(){
	
	var bigDiv = " <div id='medication'>";
	bigDiv += "<div id='medititle'>";
	bigDiv += "<div id='meditle'>知识库检测信息</div>";
	bigDiv += "<div id='mediclose'><img src='../scripts/dhcnewpro/images/close.png'></img></div></div>";
	bigDiv +="<div id='medicont'></div></div>"
	$(document.body).append(bigDiv);
	$("#medication").show();
	Params="盐酸葡萄糖注射液,10403321||1827:没有维护$C(1)注射用投保什么什么的,10403321||1825:用药频率@无此频率!联合用药@使用该药5%葡萄糖(四川)250ml输液就必须使用大于5ml灭菌注射用水!辅助用药个数@新懒狗辅助用药不能超过2个AAAAAA!用法用量@单次2gccc$C(1)盐酸葡萄糖注射液,10403321||1827:没有维护"
	Params=Params+"$C(1)注射用投保什么什么的,10403321||1825:用药频率@无此频率!联合用药@使用该药5%葡萄糖(四川)250ml输液就必须使用大于5ml灭菌注射用水!辅助用药个数@新懒狗辅助用药不能超过2个AAAAAA!用法用量@单次2gccc$C(1)盐酸葡萄糖注射液,10403321||1827:没有维护"
	//Params="注射用投保什么什么的,10403321||1825:用药频率@无此频率$C(1)盐酸葡萄糖注射液,10403321||1827:没有维护"
	//Params="注射用投保什么什么的,10403321||1825:用药频率@无此频率"
	alert(Params)
	var BlockArr= Params.split("$C(1)");
	
	for(var x=0;x<BlockArr.length;x=x+1){// edit by yuliping 
	
		init(x);	

	}

}

//窗口的拖动
function initDiv(){	
    var bool = false;
    var offsetX = 0;
    var offsetY = 0;
    $("#medititle").mousedown(function () {
        bool = true;
        offsetX = event.offsetX;
        offsetY = event.offsetY;

        $("#medititle").css('cursor', 'move');
    })
     .mouseup(function () {
           bool = false;
     })
    $(document).mousemove(function (e) {
        if (!bool)
            return;
        var x = event.clientX - offsetX;
        var y = event.clientY - offsetY;
        $("#medication").css("left", x);
        $("#medication").css("top", y);
    }) 
}

function dragDiv(){
	
	//窗口的拖动
    var bool = false;
    var offsetX = 0;
    var offsetY = 0;
    $("#detailtitle").mousedown(function () {
        bool = true;
        offsetX = event.offsetX;
        offsetY = event.offsetY;

        $("#detailtitle").css('cursor', 'move');
    })
     .mouseup(function () {
           bool = false;
     })
    $(document).mousemove(function (e) {
        if (!bool)
            return;
        var x = event.clientX - offsetX;
        var y = event.clientY - offsetY;
        $("#detailcont").css("left", x);
        $("#detailcont").css("top", y);
    }) 		
}

//绑定方法
function initMethod(){
	
	$("#mediclose").on('click',function () {
        $("#medication").hide();
        addTr = "";//窗口关闭之后清空
        addTrs="";
    }); 

    $("#detailclose").on('click',function () {
        $("#detail").css("display","none");
    });
	}


//动态生成另一个div
function datailTable(){
	
	datailTr = "";
	datailTr +="<table class='datailTb' cellspacing='0' cellpadding='0'>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="<tr><td class='table_title'>【"+'第1条'+"】</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>啦啦啦啦啦啦</td></tr>";
	datailTr +="</table>"
	$("#detailcont").html(datailTr)	
	
}

//点击其他目录显示	
function otherList(){
	e = event;
	//var className=$(e.target).attr("class");   在ie8不识别
	var className=$(e.srcElement).attr("class");
	var tdNum = $(e.srcElement).attr("tdNum");
	$(e.srcElement).parents("table").find("td:first").attr("rowspan",tdNum);
	$("."+className).show();
	//$(e.target).parents("tr").hide();  ie8不支持
	$(e.srcElement).parents("tr").hide();
}

//点击其他目录显示	
function otherLists(){
	e = event;
	//var className=$(e.target).attr("class");   在ie8不识别
	//var tdNum = $(e.srcElement).attr("tdNum");
	//$(e.srcElement).parents("table").find("td:first").attr("rowspan",tdNum);
	//$(e.target).parents("tr").hide();  ie8不支持
	$(e.srcElement).parents("tr").hide();
	$("#medicont").append(addTr);
	
}		


//点击其他项目显示
function otherProject(){
	$(".medicontTb").show();
	$("#otherProject").hide();	
}

function detail(){
	$("#detail").show();	
}

//动态生成table yuliping  不用
/*function initTables(x){
	
	var BlockArr= Params.split("$C(1)");
	var TrArr = BlockArr[x].split("#")[1].split("!");//第一条
	var TrArrLength = TrArr.length+1;
	
	
	var tit="<div class='table_title' style='border-bottom: 1px solid #ccc;padding-top: 3px;'>共["+BlockArr.length+"]条</div>";
	
	
	addTr +="<div class='table_title' style='margin:5px 0 0 7px;width:566px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:#DDDDDD;'>第"+(x+1)+"条</div>";
	
	addTr +="<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6' >〖配伍药名〗</td><td colspan='2'>"+BlockArr[x].split("#")[0]+"</td></tr>";
	for(var y=0;y<TrArr.length;y++){
		addTr +="<tr><td style='background-color:#F6F6F6;width:100px;' >〖"+TrArr[y].split("@")[0]+"〗</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+TrArr[y].split("@")[1]+"</td></tr>";
		}
		
	
	if(x==0){
		addTrs=addTr;
		addTrs=tit+addTrs
		addTrs +="<tr><td><a href='#' onclick='otherLists()' tdNum='"+TrArrLength+"' class='trId"+x+"' style='font-size: 10px;'>更多信息[+]</a></td><td></td></tr>";			
		addTrs +="</table>";
		}else{
		addTr +="</table>";
	}
	$("#medicont").html(addTrs);
	
	}*/
//动态生成table yuliping 
function init(x){
	
	var BlockArr= Params.split("$C(1)");
	var TrArrs = BlockArr[x].split(":")[1]
	
	var TrArr = BlockArr[x].split(":")[1].split("!");
	var TrArrLength = TrArr.length+1;
	
	if(x==0){ 
		
		addTrs +="<div class='table_title' style='border-bottom: 1px solid #ccc;padding-top: 3px;'>共["+BlockArr.length+"]条</div>";

		addTrs +="<div class='table_title' style='margin:5px 0 0 7px;width:566px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:#DDDDDD;'>第"+(x+1)+"条</div>";
	
		addTrs +="<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6;width:120px' >〖配伍药名〗</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+BlockArr[x].split(",")[0]+"</td></tr>";
		if(TrArrs=="没有维护"){
			
			addTrs +="<tr><td colspan='3'  style='border-right:solid #E3E3E3 1px'>没有维护该项</td></tr>";
		}else{                                   //第一条
		
			for(var y=0;y<TrArr.length;y++){
				addTrs +="<tr><td style='background-color:#F6F6F6;width:120px;' >〖"+TrArr[y].split("@")[0]+"〗</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+TrArr[y].split("@")[1]+"</td></tr>";
				}

		}
		if((x==0)&&(BlockArr.length>1)){
			
			addTrs +="<tr><td><a href='#' onclick='otherLists()' tdNum='"+TrArrLength+"' class='trId"+x+"' style='font-size: 10px;'>更多信息[+]</a></td><td></td></tr>";			
		}
		addTrs +="</table>";
		
		$("#medicont").html(addTrs);
	}else{						//剩余几条	
	
	addTr +="<div class='table_title' style='margin:5px 0 0 7px;width:566px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:#DDDDDD;'>第"+(x+1)+"条</div>";
	
	addTr +="<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6;width:120px;' >〖配伍药名〗</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+BlockArr[x].split(",")[0]+"</td></tr>";	  					 
		if(TrArrs=="没有维护"){
		
			addTr +="<tr><td colspan='3'  style='border-right:solid #E3E3E3 1px'>没有维护该项</td></tr>";
		}else{
	
			for(var y=0;y<TrArr.length;y++){
			addTr +="<tr><td style='background-color:#F6F6F6;width:120px;' >〖"+TrArr[y].split("@")[0]+"〗</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+TrArr[y].split("@")[1]+"</td></tr>";
			}
		}
	addTr +="</table>";
			
	}
	

}