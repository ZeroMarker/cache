
$(function(){
	GetReportdetail();//��ǰ��ϸ��Ϣ
	
})

//������Ϣ
function GetReportdetail(){	
	runClassMethod("web.DHCADVExaDetails","QueryAuditMess",{'ReportID':ReportID,'TypeCode':TypeCode},function(data){	
			if(data!=""){
				var list=data.split("$$"); 
				var listlen=list.length;
				
				var singlelist=list[0].split("^")
				$('.show-status').append('<li style="padding-left:30px;" id="current-time">'+singlelist[4]+'</li>')
				var singlelen=singlelist.length;
				$('#current-status').html($g(singlelist[11])+"&nbsp&nbsp"+$g(singlelist[10])+"!")
				if(list.length>1){
					var SubmitUser=list[(list.length-2)].split("^")[3];
				}else{
					var SubmitUser=list[(list.length-1)].split("^")[3];
				}
				
				for(var i=0;i<list.length;i++){
					
					var UserList=list[i].split("^")[3];
					var ReceiveList=$g(list[i].split("^")[10]);
					var StausList=$g(list[i].split("^")[11]);
					if((RepUserFlag=="-1")&&((StausList=="")||(((ReceiveList==$g("δ����"))||(ReceiveList==$g("����")))&&(SubmitUser==UserList)))){
						UserList=$g("����");
					}
					var NextLocList=list[i].split("^")[6];
					if ((list[i].split("^")[9]!="")&&(list[i].split("^")[9]!=undefined)){
						NextLocList=NextLocList+"("+list[i].split("^")[14]+$g("�ظ�")+")"
						
					}
					$(".status-list").append(
						'<li>'+
						'<div class="circle"></div>'+
						'<span class="inittxt">'+StausList+"("+$g(list[i].split("^")[10])+")"+'</span>'+
						'<span class="time">'+list[i].split("^")[4]+'</span>'+
						'<span class="user">'+$g("������")+':'+UserList+'</span>'+
						'<span class="txt">'+ $g(list[i].split("^")[10])+'</span>'+
						'<span class="nextloc">'+ NextLocList+'</span>'+  // ��˼�¼ �˴�����ָ�����  ת����¼ �˴����� ��ת����+�� �ظ�ʱ��+�ظ���
						'</li>')
						
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

