document.body.onload=BodyLoadHandler;
function BodyLoadHandler(){
	var obj=document.getElementById("Create");
	if(obj) obj.onclick=CreateClick;
	
		
}
function CreateClick(){
	var obj=document.getElementById("Create");
	if (obj) {
		obj.onclick="";
		obj.disabled=true;
	}
	
	var StartDate=document.getElementById("StartDate").value;
	var EndDate=document.getElementById("EndDate").value;
	if(StartDate==""){
		alert("开始日期不能为空");
		var obj=document.getElementById("Create");
		if (obj) {
			obj.onclick=CreateClick;
			obj.disabled=false;
		}
		return;	
	}
	if(EndDate==""){
		alert("结束日期不能为空");
		var obj=document.getElementById("Create");
		if (obj) {
			obj.onclick=CreateClick;
			obj.disabled=false;
		}
		return;	
	}
	var day=DateDiff(StartDate,EndDate)
	if(day>3){
		var flag=confirm("将生成超过三天的医嘱,是否继续?")
		if(flag==false){
			var obj=document.getElementById("Create");
			if (obj) {
				obj.onclick=CreateClick;
				obj.disabled=false;
			}
			return	
		}
		if (day>7){
			alert("不能生成超过7天的医嘱,请修改日期.");
			var obj=document.getElementById("Create");
			if (obj) {
				obj.onclick=CreateClick;
				obj.disabled=false;
			}
			return;
		}
	}
	var PatientNo=""
	var PatientNoObj=document.getElementById("PatientNo");
	if (PatientNoObj){PatientNo=PatientNoObj.value}
	var EpisodeID=document.getElementById("EpisodeID").value;
	var WardID=document.getElementById("WardID").value;
	WardID=session['LOGON.WARDID']
    alert("医嘱处理开始,请耐心等待...")
	var MethodCreatOrder=document.getElementById("MethodCreatOrder")
	if(MethodCreatOrder){var encmeth=MethodCreatOrder.value} else{var encmeth=""}
	var ret=cspRunServerMethod(encmeth,StartDate,EndDate,PatientNo,EpisodeID,WardID)
	if (ret==0){
		alert("滚医嘱成功!");
	}else if (ret==-100){
		alert("未找到病区.");
	}else if (ret==-101){
		alert("该病区存在[生成长期领药医嘱]进程,为缓解系统压力,请稍后再试.");
	}else if (ret==-200){
		alert("未找到病人就诊记录.");
	}else if (ret==-201){
		alert("该病人存在[生成长期领药医嘱]进程,为缓解系统压力,请稍后再试.");
	}else{
		alert("滚医嘱失败!")
	}
	
	var obj=document.getElementById("Create");
	if (obj) {
		obj.onclick=CreateClick;
		obj.disabled=false;
	}
}
function DateDiff(sDate1,sDate2){  
   var aDate,oDate1,oDate2,iDays ;
   aDate =sDate1.split('/'); 
   oDate1 = new Date(aDate[1]+'-'+aDate[0]+'-'+aDate[2]) ;
   //转换为04-19-2007格式 
   aDate = sDate2.split('/'); 
   oDate2 = new Date(aDate[1]+'-'+ aDate[0] +'-'+aDate[2]); 
   iDays = parseInt(Math.abs(oDate1 -oDate2)/1000/60/60/24);//把相差的毫秒数转换为天数 
   return iDays+1 ;
   }

