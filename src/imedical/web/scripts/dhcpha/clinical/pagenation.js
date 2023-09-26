function obtainPage(data,PageCount1,PageCurPage1){
	var PageCurPage=PageCurPage1,PageCount=PageCount1;
	if((data!="")&&(data!=undefined)){
	var liCount=data.length;  	 //评论的总条数
		}	
    var pageSize=4;     			//每页显示4条评论
    var PageShow=6;	//显示4页
    if((PageCount=="")||(PageCount==undefined)){
    	PageCount=Math.ceil(liCount/pageSize);	//总共页数
    }
    if((PageCurPage=="")||(PageCurPage==undefined)){
    	PageCurPage=1;
    	getcurComments(pageSize,""); 
     }
     if($("#comments-list").html()==""){
	    var PageCount=1;
    }
    loadPages(PageCurPage,PageCount);
    $('a:contains("首页")').bind("click",function(){	
    	 if(PageCurPage=="1"){
			 alert("已经到首页了");
			 }else{  
	   			 PageCurPage=1;
	    		 getcurComments(pageSize,PageCurPage); 
	    		 obtainPage("",PageCount,PageCurPage);
			 }
		 document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
	    });
	$('a:contains("尾页")').bind("click",function(){
	    if(PageCurPage==PageCount){
			 alert("已经到尾页了");
			 }else{
	    		PageCurPage=PageCount;
	   		    getcurComments(pageSize,PageCurPage);  
	     		obtainPage("",PageCount,PageCurPage);
			 }
		document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
	    });
    $('a:contains("上一页")').bind("click",function(){
		 if(PageCurPage=="1"){
			 alert("已经到首页了");
			 }else{
			 PageCurPage=PageCurPage-1;
			 getcurComments(pageSize,PageCurPage); 	
			 obtainPage("",PageCount,PageCurPage);
			}
		 document.getElementById('comments-list').scrollTop = 0 ; //hxy 2018-03-07
		 });
    $('a:contains("下一页")').bind("click",function(){
		  if(PageCurPage==PageCount){
			 alert("已经到尾页了");
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
        $("#comment-li").append('<div class="user" style="color: #7AA9D5;margin-left: 80px;margin-top: -30px;"><strong>'+data[i].userName+'</strong><strong style="color:red">（</strong><strong style="color:red">'+data[i].score+'</strong><strong style="color:red">分</strong><strong style="color:red">）</strong></div>');
		$("#comment-li").append('<div style="font-size: 12px;color: #A093A7;float: right;">'+data[i].datetime+'</div>');
		$("#comment-li").append('</div>');
		$("#comment-li").append('<div style="margin-top:40px;">');
		$("#comment-li").append('<span>'+data[i].content+'</span>');
		$("#comment-li").append('</div>');
		$("#comment-li").append('<a style="float:right;margin-right:30px;" href="##" onclick="replay('+"'"+data[i].id+"'"+')">回复</a>');
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
    $("#comments-page").append('<a href="#">首页</a>');
    $("#comments-page").append('<a href="#">上一页</a>');
    $("#comments-page").append('<a href="#">第'+PageCurPage+'页</a>');
    $("#comments-page").append('<a href="#">共'+PageCount+'页</a>');
    $("#comments-page").append('<a href="#">下一页</a>');
    $("#comments-page").append('<a href="#">尾页</a>');
	}
