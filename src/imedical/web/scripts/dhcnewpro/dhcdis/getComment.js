//显示评论信息
function getComment()
{  alert(4)
 	runClassMethod("web.disappraise","getAllAppraise",{repType:repType,mainRowID:mainRowID},function(jsonObj){
	 	parent.$("#comments-list").empty();
		initComment(jsonObj);
	});
}

//加载评论
function initComment(data)
{
	obtainPage(data);
}