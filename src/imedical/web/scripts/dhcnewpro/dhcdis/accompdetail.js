///creatdate: 2017.1.6
///creator: lvpeng
///���������ѯ��ϸ
$(function(){
	//initCirCle();	//��ʼ��panelԲ��
	GetPatcurdetail();//��ǰ��ϸ��Ϣ
})

//��ʼ��Բ
function initCirCle(){
	 var canvas=document.getElementById("topcircle");
	 var context=canvas.getContext("2d");
	 context.fillStyle="#B4E2CB";
	 context.beginPath();
	 context.arc(27,28,12,0,Math.PI*2,true); //Math.PI*2��JS���㷽������Բ
	 context.closePath();
	 context.fill();
	 var canvas=document.getElementById("topcircle");
	 var context=canvas.getContext("2d");
	 context.fillStyle="#19AF65";
	 context.beginPath();
	 context.arc(27,28,6,0,Math.PI*2,true); //Math.PI*2��JS���㷽������Բ
	 context.closePath();
	 context.fill();	
}

//������Ϣ
function GetPatcurdetail(){
	runClassMethod("web.DHCDISDetail","FindDisDetailaop",{'taskID':mainRowID},function(data){
				if(data!=""){
				var list=data.split("$$"); 
				var listlen=list.length;
				var singlelist=list[0].split("^")
				$('.show-status').append('<li style="padding-left:30px;" id="current-time">'+singlelist[0]+'&nbsp;&nbsp;'+singlelist[1]+'&nbsp;&nbsp;'+singlelist[3]+'</li>')
				var singlelen=singlelist.length;
				
				$('#current-status').html(singlelist[2]+"!")

				for(var i=0;i<list.length-1;i++){
						if(list[i].split("^").length>4){
							var arcarr=list[i].split("^")[3].split("@"); //��Ŀ
							var htmlstr="";
							for(var j=0;j<arcarr.length;j++){
								var long=arcarr[j].split("#"); //�ָ���Ŀ����Ա

								htmlstr='<li>'+
				  						 '<div class="node-icon"></div>'+
				  						 '<span class="inittxt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>'+
										 '<span class="time1">'+"������Ŀ��"+long[0]+'</span>';
								var userarr=long[1].split("^"); //��Ա
								
								var username=""
								for(var k=0;k<userarr.length;k++){
									if(userarr.length==1){
										username=userarr[k];
									}else{
										username=username+userarr[k]
									}
								}

								if(username!=""){
									htmlstr=htmlstr+'<span class="txt1">'+"������Ա��"+username+'</span>';
								}else{
									htmlstr=htmlstr+'</li>';
								}
								
								$(".status-list").append(htmlstr);
							}	
							$(".status-list").append('<li>'+
							  						 '<div class="circle"></div>'+
							  						 '<span class="inittxt">'+list[i].split("^")[2]+'</span>'+
													 '<span class="time">'+list[i].split("^")[0]+'&nbsp;&nbsp;'+list[i].split("^")[1]+'</span>'+
													 '<span class="txt">'+list[i].split("^")[2]+"��"+'</span>'+
													 '</li>')
						}else if(list[i].split("^").length<=4){
								$(".status-list").append('<li>'+
													 '<div class="circle"></div>'+
													 '<span class="inittxt">'+list[i].split("^")[2]+'</span>'+
													 '<span class="time">'+list[i].split("^")[0]+'&nbsp;&nbsp;'+list[i].split("^")[1]+'&nbsp;&nbsp;'+list[i].split("^")[3]+'</span>'+
													 '<span class="txt">'+list[i].split("^")[2]+"��"+'</span>'+
													 '</li>')
						}
				}
				}
						$(".status-list li:last-child ").css('border-left-color','#fff');
						
						if($(".status-list li:first-child > div").attr('class')=="circle"){
							$(".status-list li:first-child > div").removeClass("circle");
							$(".status-list li:first-child > div").addClass("playcircle");
							$(".status-list li:first-child ").css("color","#000");
						}else{
							$(".status-list li:last-child > div").removeClass("circle");
							$(".status-list li:last-child > div").addClass("playcircle")
							$(".status-list li:last-child ").css('color','#000');
						}
		},"text")	
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