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
		alert("��ʼ���ڲ���Ϊ��");
		var obj=document.getElementById("Create");
		if (obj) {
			obj.onclick=CreateClick;
			obj.disabled=false;
		}
		return;	
	}
	if(EndDate==""){
		alert("�������ڲ���Ϊ��");
		var obj=document.getElementById("Create");
		if (obj) {
			obj.onclick=CreateClick;
			obj.disabled=false;
		}
		return;	
	}
	var day=DateDiff(StartDate,EndDate)
	if(day>3){
		var flag=confirm("�����ɳ��������ҽ��,�Ƿ����?")
		if(flag==false){
			var obj=document.getElementById("Create");
			if (obj) {
				obj.onclick=CreateClick;
				obj.disabled=false;
			}
			return	
		}
		if (day>7){
			alert("�������ɳ���7���ҽ��,���޸�����.");
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
    alert("ҽ������ʼ,�����ĵȴ�...")
	var MethodCreatOrder=document.getElementById("MethodCreatOrder")
	if(MethodCreatOrder){var encmeth=MethodCreatOrder.value} else{var encmeth=""}
	var ret=cspRunServerMethod(encmeth,StartDate,EndDate,PatientNo,EpisodeID,WardID)
	if (ret==0){
		alert("��ҽ���ɹ�!");
	}else if (ret==-100){
		alert("δ�ҵ�����.");
	}else if (ret==-101){
		alert("�ò�������[���ɳ�����ҩҽ��]����,Ϊ����ϵͳѹ��,���Ժ�����.");
	}else if (ret==-200){
		alert("δ�ҵ����˾����¼.");
	}else if (ret==-201){
		alert("�ò��˴���[���ɳ�����ҩҽ��]����,Ϊ����ϵͳѹ��,���Ժ�����.");
	}else{
		alert("��ҽ��ʧ��!")
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
   //ת��Ϊ04-19-2007��ʽ 
   aDate = sDate2.split('/'); 
   oDate2 = new Date(aDate[1]+'-'+ aDate[0] +'-'+aDate[2]); 
   iDays = parseInt(Math.abs(oDate1 -oDate2)/1000/60/60/24);//�����ĺ�����ת��Ϊ���� 
   return iDays+1 ;
   }

