function obtainPage(data,PageCount1,PageCurPage1){
	var PageCurPage=PageCurPage1,PageCount=PageCount1;
	if((data!="")&&(data!=undefined)){
	var liCount=data.length;  	 //���۵�������
		}	
    var pageSize=4;     			//ÿҳ��ʾ4������
    var PageShow=6;	//��ʾ4ҳ
    if((PageCount=="")||(PageCount==undefined)){
    	PageCount=Math.ceil(liCount/pageSize);	//�ܹ�ҳ��
    }
    if((PageCurPage=="")||(PageCurPage==undefined)){
    	PageCurPage=1;
    	getcurComments(pageSize,""); 
     }
     if($("#comments-list").html()==""){
	    var PageCount=1;
    }
    loadPages(PageCurPage,PageCount);
    $('a:contains("��ҳ")').bind("click",function(){	
    	 if(PageCurPage=="1"){
			 alert("�Ѿ�����ҳ��");
			 }else{  
	   			 PageCurPage=1;
	    		 getcurComments(pageSize,PageCurPage); 
	    		 obtainPage("",PageCount,PageCurPage);
			 }
		 document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
	    });
	$('a:contains("βҳ")').bind("click",function(){
	    if(PageCurPage==PageCount){
			 alert("�Ѿ���βҳ��");
			 }else{
	    		PageCurPage=PageCount;
	   		    getcurComments(pageSize,PageCurPage);  
	     		obtainPage("",PageCount,PageCurPage);
			 }
		document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
	    });
    $('a:contains("��һҳ")').bind("click",function(){
		 if(PageCurPage=="1"){
			 alert("�Ѿ�����ҳ��");
			 }else{
			 PageCurPage=PageCurPage-1;
			 getcurComments(pageSize,PageCurPage); 	
			 obtainPage("",PageCount,PageCurPage);
			}
		 document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
		 });
    $('a:contains("��һҳ")').bind("click",function(){
		  if(PageCurPage==PageCount){
			 alert("�Ѿ���βҳ��");
			 }else{
			 PageCurPage=PageCurPage+1;
			 getcurComments(pageSize,PageCurPage); 	
			 obtainPage("",PageCount,PageCurPage);
			}
		  document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
		 });	
 }
 function getcurComments(pageSize,pageIndex){
	 $.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        async:false,
        data: "Action=GetCurComment&InstanceID="+instanceId+"&FavInfoID="+favInfoId+"&PageIndex="+pageIndex+"&PageSize="+pageSize, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
       		if (data != "")
       		{    
	       		$("#comments-list").empty();
	       		initComments(eval(data));
	       		
	       	}
        } 
    });	

 }
function initComments(data)
{	
for (var i=0;i<data.length;i++){ 
        $("#comments-list").append('<div class="comments" id="comment-li"></div>');
        $("#comment-li").append('<li>');
        $("#comment-li").append('<div>');
        $("#comment-li").append('<img src="../scripts/dhcpha/emr/image/icon/man.jpg">');
        $("#comment-li").append('<div class="user" style="color: #7AA9D5;margin-left: 80px;margin-top: -30px;"><strong>'+data[i].userName+'</strong><strong style="color:red">��</strong><strong style="color:red">'+data[i].score+'</strong><strong style="color:red">��</strong><strong style="color:red">��</strong></div>');
		$("#comment-li").append('<div style="font-size: 12px;color: #A093A7;float: right;">'+data[i].datetime+'</div>');
		$("#comment-li").append('</div>');
		$("#comment-li").append('<div style="margin-top:40px;">');
		$("#comment-li").append('<span>'+data[i].content+'</span>');
		$("#comment-li").append('</div>');
		$("#comment-li").append('<a style="float:right;margin-right:30px;" href="##" onclick="replay('+"'"+data[i].id+"'"+')">�ظ�</a>');
		$("#comment-li").append('<img style="float:right;"  src="../scripts/dhcpha/images/comment/reply.png">');
		$("#comment-li").append('<div class="replycontent" id="replycontent'+data[i].id+'"></div>');
		$("#comment-li").append('<div class="reply" id="reply-list'+data[i].id+'"></div>');
		$("#comment-li").append('</div>');
		$("#comment-li").append('</li>');
		getReplays(data[i].id);		
	}
}
function loadPages(PageCurPage,PageCount){
	$("#comments-list").append('<div class="page" id="comments-page"></div>');
    $("#comments-page").append('<a href="#">��ҳ</a>');
    $("#comments-page").append('<a href="#">��һҳ</a>');
    $("#comments-page").append('<a href="#">��'+PageCurPage+'ҳ</a>');
    $("#comments-page").append('<a href="#">��'+PageCount+'ҳ</a>');
    $("#comments-page").append('<a href="#">��һҳ</a>');
    $("#comments-page").append('<a href="#">βҳ</a>');
	}
