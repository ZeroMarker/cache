///PMPProjectUser

function BodyLoadHandler()
{
	var obj;
	
	obj=document.getElementById("Save") ;
	if (obj) obj.onclick=Save_Click;
	
	obj=document.getElementById("update") ;
	if (obj) obj.onclick=update_Click;
}

function update_Click(){
	var ProDRHidden=document.getElementById('ProDRHidden').value;  //��Ŀid
	 if (ProDRHidden=="") {
		alert("��Ŀ����Ϊ�գ�");
		return;}
	var SSUserid=document.getElementById('SSUserid').value;  //userid
	if (SSUserid=="") {
		alert("��Ա����Ϊ�գ�");
		return;}
	var dicid=document.getElementById('dicid').value;  //ְ��id
	if (dicid=="") {
		alert("ְ�Ʋ���Ϊ�գ�");
		return;}
	var phone=document.getElementById('phone').value;  //��ϵ��ʽ
	var date1=document.getElementById('date1').value;  //��������
	var time1=document.getElementById('time1').value;  //����ʱ��
	var date2=document.getElementById('date2').value;  //��������
	var time2=document.getElementById('time2').value;  //����ʱ��
	var remark=document.getElementById('remark').value;  //��Ŀid
	var ProjectId=document.getElementById('ProjectId').value;
	var updatestr=tkMakeServerCall("web.PMPProjectUser","updateProjectUser",ProDRHidden,SSUserid,dicid,phone,date1,time1,date2,time2,remark,ProjectId);
    if(updatestr){
	    alert("���³ɹ���")
	    opener.location.reload();
	    window.close();
	    }else{
		    alert("����ʧ�ܣ�")
		    return;
		    }
	}
	
	
function Save_Click(){
	var ProDRHidden=document.getElementById('ProDRHidden').value;  //��Ŀid
	 if (ProDRHidden=="") {
		alert("��Ŀ����Ϊ�գ�");
		return;}
	var SSUserid=document.getElementById('SSUserid').value;  //userid
	if (SSUserid=="") {
		alert("��Ա����Ϊ�գ�");
		return;}
	var dicid=document.getElementById('dicid').value;  //ְ��id
	if (dicid=="") {
		alert("ְ�Ʋ���Ϊ�գ�");
		return;}
	var dicid=document.getElementById('dicid').value;  //ְ��id
	var phone=document.getElementById('phone').value;  //��ϵ��ʽ
	var date1=document.getElementById('date1').value;  //��������
	var time1=document.getElementById('time1').value;  //����ʱ��
	var date2=document.getElementById('date2').value;  //��������
	var time2=document.getElementById('time2').value;  //����ʱ��
	var remark=document.getElementById('remark').value;  //��Ŀid
	
	var insertstr=tkMakeServerCall("web.PMPProjectUser","insertProjectUser",ProDRHidden,SSUserid,dicid,phone,date1,time1,date2,time2,remark);
    if(insertstr){
	    alert("��ӳɹ���")
	    
	   // var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPProjectUser";
	   opener.location.reload();
  	   window.close();

	    }else{
		    alert("���ʧ�ܣ�")
		    return;
		    }
	}

function LookUp_ProDesc(value){
    var info=value.split("^");
    document.getElementById("ProDRHidden").value=info[0];
    document.getElementById('ProDR').value = info[1];
}

function LookUp_dictionaryDesc(value){
	var info=value.split("^");
	document.getElementById("dicid").value=info[0];
    document.getElementById('dictionary').value = info[1];
	}

function getUserId(value){
	var info=value.split("^");
    document.getElementById("SSUser").value=info[0];
    document.getElementById("SSUserid").value = info[2];
    
	}

document.body.onload=BodyLoadHandler;
