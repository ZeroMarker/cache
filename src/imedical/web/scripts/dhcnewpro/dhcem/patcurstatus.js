///creatdate: 2016.8.30
///creator: lvpeng
///����״̬��ѯ��״̬�����ϸ
$(function(){
	InitParams();
	GetPatcurdetail();//��ǰ��ϸ��Ϣ
	initCirCle();	//��ʼ��panelԲ��
	initnodeCirCle(); //��ʼ���ڵ�Բ��
})

function InitParams(){
	//PatientID==""?EpisodeID="":""; //hxy 2022-10-17 ע��
}


//��ʼ��Բ
function initCirCle(){
	 var canvas=document.getElementById("topcircle");
	 var context=canvas.getContext("2d");
	 context.fillStyle="#B4E2CB";
	 context.beginPath();
	 context.arc(27,18,12,0,Math.PI*2,true); //Math.PI*2��JS���㷽������Բ
	 context.closePath();
	 context.fill();
	 var canvas=document.getElementById("topcircle");
	 var context=canvas.getContext("2d");
	 context.fillStyle="#19AF65";
	 context.beginPath();
	 context.arc(27,18,6,0,Math.PI*2,true); //Math.PI*2��JS���㷽������Բ
	 context.closePath();
	 context.fill();	
}

function initnodeCirCle(){
	
}

// ��ʾ״̬��ϸ
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
					 '<span class="txt">'+list[i].split("^")[3]+'&nbsp;&nbsp;&nbsp;'+$g("������")+":"+list[i].split("^")[4]+'</span>'+
					 '</li>')
			}
			
				$(".status-list li:last-child > div").removeClass("circle");
				$(".status-list li:last-child > div").addClass("playcircle")
				
	},"text",false);
}


/// ֱ��ִ�з������ػص��������ص�dataֵ
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