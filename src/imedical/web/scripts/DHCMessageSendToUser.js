var sendobj,rqtidobj,rqtnameobj,selectuserobj,contextobj,touseridobj,fromuseridobj;
document.body.onload=function(){
	sendobj=document.getElementById("SendBtn");
	rqtidobj=document.getElementById("rqtid");
	rqtnameobj=document.getElementById("rqtname");
	selectuserobj=document.getElementById("SelectUser");
	contextobj=document.getElementById("Context");
	touseridobj=document.getElementById("ToUserRowId");
	fromuseridobj=document.getElementById("LogOnUserId");
	
	var rqtid=rqtidobj.value ;
	if(rqtid!=""){
		selectuserobj.value=rqtnameobj.value ;
		//selectuserobj.setAttribute("disabled",true);
		touseridobj.value=rqtid;
	}
	if (sendobj){
		sendobj.onclick=sendMessage ;
	}
	
	selectuserobj.onchange=userchange;
}
//Set rtn =##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , OtherInfoJson )
function sendMessage(){
	var context=contextobj.value ;
	var logonid=fromuseridobj.value ;
	var touserrowid=touseridobj.value ;
	//alert(context+"**"+logonid+"**"+touserrowid);
	if(context.trim()==""){
		alert("请输入消息内容");
		return;
	}
	if(touserrowid==""){
		alert("请选择接受用户");
		return;
	}
	
	context=replaceTextarea1(context);
	
	var encobj=document.getElementById("enc");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,context,2000,logonid,"","",touserrowid,"");
	rtn = parseFloat(rtn);
	
	if (rtn>0){
		alert("发送成功");
		cleardata();
	}else{
		alert("发送失败");
	}
}

function cleardata(){
	selectuserobj.value="";
	//selectuserobj.setAttribute("disabled",false);
	contextobj.value="";
	rqtidobj.value="";
	rqtnameobj.value="";
	touseridobj.value="";
}

//当选择过接收用户时，若此时将用户选择框内容完全删掉，将touseridobj清空
function userchange(){
	if(selectuserobj.value==""){
		touseridobj.value="";
	}
}

function replaceTextarea1(str){
	var reg=new RegExp("\n","g");
	var reg1=new RegExp(" ","g");
	
	str = str.replace(reg,"<br>");
	str = str.replace(reg1,"<br>");
	
	return str;
}


function LookUpUser(str){
	var arr=str.split("^");
	selectuserobj.value=arr[0];
	touseridobj.value=arr[1];

}







