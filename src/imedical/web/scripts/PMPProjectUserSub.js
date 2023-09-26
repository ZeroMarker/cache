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
	var ProDRHidden=document.getElementById('ProDRHidden').value;  //项目id
	 if (ProDRHidden=="") {
		alert("项目不能为空！");
		return;}
	var SSUserid=document.getElementById('SSUserid').value;  //userid
	if (SSUserid=="") {
		alert("人员不能为空！");
		return;}
	var dicid=document.getElementById('dicid').value;  //职称id
	if (dicid=="") {
		alert("职称不能为空！");
		return;}
	var phone=document.getElementById('phone').value;  //联系方式
	var date1=document.getElementById('date1').value;  //到达日期
	var time1=document.getElementById('time1').value;  //到达时间
	var date2=document.getElementById('date2').value;  //到达日期
	var time2=document.getElementById('time2').value;  //到达时间
	var remark=document.getElementById('remark').value;  //项目id
	var ProjectId=document.getElementById('ProjectId').value;
	var updatestr=tkMakeServerCall("web.PMPProjectUser","updateProjectUser",ProDRHidden,SSUserid,dicid,phone,date1,time1,date2,time2,remark,ProjectId);
    if(updatestr){
	    alert("更新成功！")
	    opener.location.reload();
	    window.close();
	    }else{
		    alert("更新失败！")
		    return;
		    }
	}
	
	
function Save_Click(){
	var ProDRHidden=document.getElementById('ProDRHidden').value;  //项目id
	 if (ProDRHidden=="") {
		alert("项目不能为空！");
		return;}
	var SSUserid=document.getElementById('SSUserid').value;  //userid
	if (SSUserid=="") {
		alert("人员不能为空！");
		return;}
	var dicid=document.getElementById('dicid').value;  //职称id
	if (dicid=="") {
		alert("职称不能为空！");
		return;}
	var dicid=document.getElementById('dicid').value;  //职称id
	var phone=document.getElementById('phone').value;  //联系方式
	var date1=document.getElementById('date1').value;  //到达日期
	var time1=document.getElementById('time1').value;  //到达时间
	var date2=document.getElementById('date2').value;  //到达日期
	var time2=document.getElementById('time2').value;  //到达时间
	var remark=document.getElementById('remark').value;  //项目id
	
	var insertstr=tkMakeServerCall("web.PMPProjectUser","insertProjectUser",ProDRHidden,SSUserid,dicid,phone,date1,time1,date2,time2,remark);
    if(insertstr){
	    alert("添加成功！")
	    
	   // var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPProjectUser";
	   opener.location.reload();
  	   window.close();

	    }else{
		    alert("添加失败！")
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
