///creatdate: 2016.8.30
///creator: lvpeng
///病人状态查询和状态变更明细
$(function(){
	InitParams();
	GetPatcurdetail();//当前明细信息
	initCirCle();	//初始化panel圆形
	initnodeCirCle(); //初始化节点圆形
})

function InitParams(){
	//PatientID==""?EpisodeID="":""; //hxy 2022-10-17 注释
}


//初始化圆
function initCirCle(){
	 var canvas=document.getElementById("topcircle");
	 var context=canvas.getContext("2d");
	 context.fillStyle="#B4E2CB";
	 context.beginPath();
	 context.arc(27,18,12,0,Math.PI*2,true); //Math.PI*2是JS计算方法，是圆
	 context.closePath();
	 context.fill();
	 var canvas=document.getElementById("topcircle");
	 var context=canvas.getContext("2d");
	 context.fillStyle="#19AF65";
	 context.beginPath();
	 context.arc(27,18,6,0,Math.PI*2,true); //Math.PI*2是JS计算方法，是圆
	 context.closePath();
	 context.fill();	
}

function initnodeCirCle(){
	
}

// 显示状态明细
function GetPatcurdetail(){
	if(EpisodeID==""){
		return;	
	}
	runClassMethod("web.DHCEMPatCurStatus","FindAdmstatusTotal",{'EpisodeID':EpisodeID},
	function(data){
			var list=data.split("$$"); 
			var listlen=list.length;
			var singlelist=list[listlen-2].split("^")
			$('.show-status').append('<li style="padding-left:30px;" id="current-time">'+singlelist[0]+'&nbsp;&nbsp;&nbsp;'+singlelist[1]+'</li>')
			var singlelen=singlelist.length;
			$('#current-status').html(singlelist[2]);
			
			
			for(var i=0;i<list.length-1;i++){
				$(".status-list").append('<li>'+
					 '<div class="circle"></div>'+
					 '<span class="inittxt">'+list[i].split("^")[2]+'</span>'+
					 '<span class="time">'+list[i].split("^")[0]+'&nbsp;&nbsp;&nbsp;'+list[i].split("^")[1]+'</span>'+
					 '<span class="txt">'+list[i].split("^")[3]+'&nbsp;&nbsp;&nbsp;'+$g("操作人")+":"+list[i].split("^")[4]+'</span>'+
					 '</li>')
			}
			
				$(".status-list li:last-child > div").removeClass("circle");
				$(".status-list li:last-child > div").addClass("playcircle")
				
	},"text",false);
}


/// 直接执行方法返回回调函数返回的data值
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}