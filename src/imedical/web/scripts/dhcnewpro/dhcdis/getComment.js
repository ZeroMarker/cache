//��ʾ������Ϣ
function getComment()
{  alert(4)
 	runClassMethod("web.disappraise","getAllAppraise",{repType:repType,mainRowID:mainRowID},function(jsonObj){
	 	parent.$("#comments-list").empty();
		initComment(jsonObj);
	});
}

//��������
function initComment(data)
{
	obtainPage(data);
}