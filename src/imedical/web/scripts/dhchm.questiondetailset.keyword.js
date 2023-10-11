/**
 * �����ʾ�չʾ dhchm.questiondetailset.keyword.js
 * @Author   wangguoying
 * @DateTime 2019-05-14
 */
var _saveFlag=1 ;  //��ǰҳ���Ƿ񱣴�

//$.messager.defaults = { ok: "����", cancel: "����" };

function ShowDetailPanel(SubjOrd)
{
	if(SubjOrd != ""){
		if(_saveFlag == 0){
			var oldUrl = $('#SurveyFrame').attr("src");
			var oldOrder=oldUrl.split("&SubjectOrder=")[1];
			oldOrder=oldOrder.split("&QuesID=")[0];
			if(oldOrder == "") oldOrder=$("#FirstOrder").val();
			if(oldOrder == SubjOrd){ //���˵Ĺؼ���ѡ��
				return false;				
			}
			
			if(save_results()){
				setHadSaveClass(oldOrder);
				show(SubjOrd);
			}else{
				//����ʧ��
				$("#SubjectKeys").keywords("select",oldOrder); //����ѡ��ԭ���Ĺؼ���  û�鵽�ؼ���ѡ�е���ֹ�¼���ֻ������ѡ
				return false;	
			}	
		}else{
			show(SubjOrd);	
		}
	}else{
		show(SubjOrd);
	}

}

function submit(type){
	var oldLi = $("li.pe-keywords-a-red");
	if(oldLi.length > 0  && type == "SUBMIT"){
		$.messager.confirm("��ʾ","����δ��������⣬�Ƿ��ύ��",function(r){
			if(r){
				submit_invoke(type);
			}
		});	
	}else{
		submit_invoke(type);
	}
}

function submit_invoke(type){
	if(save_results()){
		var ret = tkMakeServerCall("web.DHCPE.HM.ExamSurveyHandler","SubmitSurvey",$("#EQID").val(),type,session["LOGON.USERID"],session['LOGON.GROUPDESC']);
		var tmp = ret.split("^");
		if(tmp[0] != "0"){
			$.messager.alert("��ʾ",tmp[1],"error");
		}else{
			$.messager.alert("��ʾ","�����","success",function(){
				window.location.href="dhchm.questiondetailset.keyword.csp?EQID="+$("#EQID").val();
			});
		}
	}
}


function setHadSaveClass(id){
	var oldLi = $("li#"+id+".pe-keywords-a-red");
	if(oldLi.length == 1){
		$(oldLi[0]).removeClass("pe-keywords-a-red");
		$(oldLi[0]).addClass("pe-keywords-a-green");
	}
	var oldLi = $("li#"+id+".pe-keywords-a-yellow");
	if(oldLi.length == 1){
		$(oldLi[0]).removeClass("pe-keywords-a-yellow");
		$(oldLi[0]).addClass("pe-keywords-a-green");
	}
}



function show(SubjOrd){
	_saveFlag=1;
	var framWidth= $('#SurveyFrame').width()-25;
	var framHeight=$('#SurveyFrame').height()-25;
	var SizeJSON={
		width:framWidth,
		height:framHeight
	};
	var readonly="N";
	if(EQStatus=="3") readonly="Y";
	var url="dhchm.questiondetailset.csp?ReadOnly="+readonly+"&SubjectOrder="+SubjOrd+"&QuesID="+QuesID+"&EQID="+$("#EQID").val()+"&Job="+Job+"&DocFlag=Y&SizeJSON="+ JSON.stringify(SizeJSON);
	$('#SurveyFrame').attr("src",url);
}


function save_results(){
	var childWindow=window.frames['SurveyFrame'].contentWindow;
	return childWindow.save_curPage();
}


function preview(){
	var execParam ={
		business : "REPORT",		//����̶�ΪREPORT
		admId : $("#H_PAADM").val(),	
		opType : "5",  //5 Ԥ��
		fileType : "word",
		printType : "11"  //11Ϊ����������
	};
	var json = JSON.stringify(execParam); 
	$PESocket.sendMsg(json,null);
}


