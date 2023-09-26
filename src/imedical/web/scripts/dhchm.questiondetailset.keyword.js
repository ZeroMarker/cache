/**
 * 调查问卷展示 dhchm.questiondetailset.keyword.js
 * @Author   wangguoying
 * @DateTime 2019-05-14
 */


function ShowDetailPanel(SubjOrd)
{
	var framWidth= $('#SurveyFrame').width()-20;
	var framHeight=$('#SurveyFrame').height()-20;
	var SizeJSON={
		width:framWidth,
		height:framHeight
	};
	var url="dhchm.questiondetailset.csp?ReadOnly=Y&SubjectOrder="+SubjOrd+"&QuesID="+QuesID+"&EQID="+$("#EQID").val()+"&Job="+Job+"&SizeJSON="+ JSON.stringify(SizeJSON);
	$('#SurveyFrame').attr("src",url);

}



