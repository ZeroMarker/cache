function obtainPage(data,PageCount1,PageCurPage1){
	var PageCurPage=PageCurPage1,PageCount=PageCount1;
	if((data!="")&&(data!=undefined)){
	var liCount=data.total;  	 //���۵�������
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
     if(parent.$("#comments-list").html()==""){
	    var PageCount=1;
    }
    loadPages(PageCurPage,PageCount);
    parent.$('a:contains("��ҳ")').bind("click",function(){	
    	 if(PageCurPage=="1"){
			 alert("�Ѿ�����ҳ��");
			 }else{  
	   			 PageCurPage=1;
	    		 getcurComments(pageSize,PageCurPage); 
	    		 obtainPage("",PageCount,PageCurPage);
			 }
	    });
	parent.$('a:contains("βҳ")').bind("click",function(){
	    if(PageCurPage==PageCount){
			 alert("�Ѿ���βҳ��");
			 }else{
	    		PageCurPage=PageCount;
	   		    getcurComments(pageSize,PageCurPage);  
	     		obtainPage("",PageCount,PageCurPage);
			 }
	    });
    parent.$('a:contains("��һҳ")').bind("click",function(){
		 if(PageCurPage=="1"){
			 alert("�Ѿ�����ҳ��");
			 }else{
			 PageCurPage=PageCurPage-1;
			 getcurComments(pageSize,PageCurPage); 	
			 obtainPage("",PageCount,PageCurPage);
			}
		 });
    parent.$('a:contains("��һҳ")').bind("click",function(){
		  if(PageCurPage==PageCount){
			 alert("�Ѿ���βҳ��");
			 }else{
			 PageCurPage=PageCurPage+1;
			 getcurComments(pageSize,PageCurPage); 	
			 obtainPage("",PageCount,PageCurPage);
			}
		 });	
 }
 
 function getcurComments(pageSize,pageIndex){
	 runClassMethod("web.disappraise","getAllCurAppraise",{repType:repType,mainRowID:mainRowID,pageSize:pageSize,pageIndex:pageIndex},function(jsonObj){
	 	parent.$("#comments-list").empty();
		//initComments(jsonObj);
	});
 }
 
function initComments(data)
{	
for (var i=0;i<data.total;i++){ 
        parent.$("#comments-list").append('<div class="comments" id="comment-li"></div>');
        parent.$("#comment-li").append('<li>');
        parent.$("#comment-li").append('<div>');
        parent.$("#comment-li").append('<img src="../scripts/emr/image/icon/man.jpg">');
        parent.$("#comment-li").append('<div class="user" style="color: #7AA9D5;margin-left: 80px;margin-top: -30px;"><strong>'+data.rows[i].appUser+'</strong><strong style="color:red">��</strong><strong style="color:red">'+data.rows[i].RaNubmer+'</strong><strong style="color:red">��</strong><strong style="color:red">��</strong></div>');
		parent.$("#comment-li").append('<div style="font-size: 12px;color: #A093A7;float: right;">'+data.rows[i].appDate+'</div>');
		parent.$("#comment-li").append('</div>');
		parent.$("#comment-li").append('<div style="margin-top:40px;">');
		parent.$("#comment-li").append('<span>'+data.rows[i].RaRemarks+'</span>');
		parent.$("#comment-li").append('</div>');
		parent.$("#comment-li").append('<a style="float:right;margin-right:30px;" href="##">�ظ�</a>');
		parent.$("#comment-li").append('<img style="float:right;"  src="../scripts/dhcpha/images/comment/reply.png">');
		//parent.$("#comment-li").append('<div class="replycontent" id="replycontent'+data[i].id+'"></div>');
		//parent.$("#comment-li").append('<div class="reply" id="reply-list'+data[i].id+'"></div>');
		parent.$("#comment-li").append('</div>');
		parent.$("#comment-li").append('</li>');
	}
}
function loadPages(PageCurPage,PageCount){
	parent.$("#comments-list").append('<div class="page" id="comments-page"></div>');
    parent.$("#comments-page").append('<a href="#">��ҳ</a>');
    parent.$("#comments-page").append('<a href="#">��һҳ</a>');
    parent.$("#comments-page").append('<a href="#">��'+PageCurPage+'ҳ</a>');
    parent.$("#comments-page").append('<a href="#">��'+PageCount+'ҳ</a>');
    parent.$("#comments-page").append('<a href="#">��һҳ</a>');
    parent.$("#comments-page").append('<a href="#">βҳ</a>');
	}
