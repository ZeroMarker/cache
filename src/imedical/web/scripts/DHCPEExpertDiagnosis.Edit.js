/// /// 对应组件 诊断条件 
var CurrentSel=0
var SelectedRow=-1
var UserId=session['LOGON.USERID']
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BEditCondition");
	if (obj) obj.onclick=BEditCondition_Click;
	obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_Click;
	//obj=document.getElementById("Delete");
	//if (obj) obj.onclick=Delete_Click;
	obj=document.getElementById("BEDR");
	if (obj) obj.onclick=BEDR_Click;
	obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_Click;
	obj=document.getElementById("StationName");
	if (obj) obj.onchange=StationName_onchange;
	obj=document.getElementById("KeyReplace");  //关键字维护
	if (obj) obj.onclick=KeyReplace_Click;
	init();
}

function StationName_onchange()
{
	var obj=document.getElementById("StationID");
	if (obj) obj.value="";
}
function init()
{
	
	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj && ""!=obj.value){
		obj=document.getElementById("DataBox");
		if (obj && ""!=obj.value){
			var EDStr=obj.value;
			var EDList=EDStr.split("^");
			obj=document.getElementById("Code");
			obj.value=EDList[5];
			if(obj){obj.disabled=true}
			obj=document.getElementById("DiagnoseConclusion");
			obj.value=EDList[0];
			obj=document.getElementById("StationID");
			obj.value=EDList[6];
			obj=document.getElementById("HighRisk");
			if(EDList[7]=="Y"){ obj.checked=true; }
			obj=document.getElementById("StationName");
			obj.value=EDList[8+1];
			obj=document.getElementById("Detail");
			obj.value=EDList[7+1];
            obj=document.getElementById("DiagnosisLevel");   
	        obj.value=EDList[10+1]
	        obj=document.getElementById("EDCRID");           
	        obj.value=EDList[11+1]
	        obj=document.getElementById("Sex_DR_Name");   
	        obj.value=EDList[12+1]
			obj=document.getElementById("Illness");
			if(EDList[3]=="Y"){ obj.checked=true; }
			obj=document.getElementById("CommonIllness");
			if(EDList[4]=="Y"){ obj.checked=true; }
			obj=document.getElementById("Active");
			if(EDList[9+1]=="Y"){ obj.checked=true; }
		}
    }
}

/*
function init()
{
	//alert("aaaaa");
	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		EDRowId=obj.value
	}
	//alert("EDRowId:"+EDRowId);
	
	var Ins=document.getElementById('InitBox');
    if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    var EDStr=cspRunServerMethod(encmeth,EDRowId)
    //alert(EDStr);
	
	var EDList=EDStr.split("^");
	obj=document.getElementById("Code");
	obj.value=EDList[5];
	obj=document.getElementById("DiagnoseConclusion");
	obj.value=EDList[0];
	obj=document.getElementById("Detail");
	obj.value=EDList[6];
	obj=document.getElementById("Illness");
	if(EDList[3]=="Y"){
		obj.checked=true;
	}
	obj=document.getElementById("CommonIllness");
	if(EDList[4]=="Y"){
		obj.checked=true;
	}
}
*/
//删除
function Delete_Click()
{
	return false;
	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		EDRowId=obj.value
	}

   	var Ins=document.getElementById('DeleteBox');
    if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    var flag=cspRunServerMethod(encmeth,EDRowId)
    if ('0'==flag) {}
    else{
	    alert("Update error.ErrNo="+flag)
    }
    window.close();
}

//更新
function Update_Click()
{	
//EDRowId,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserUpdate
	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		EDRowId=obj.value
	}
	
	var Code=""
  	var obj=document.getElementById("Code");
    if (obj){
		Code=obj.value
	}
	if (""==Code){
		alert("请选择填写编号");
		return false
  	} 
  	
  	var Illness="N"
  	var obj=document.getElementById("Illness");
    if (obj){
	    if(obj.checked==true){
			Illness="Y"
	    }
	}

  	var CommonIllness="N"
  	var obj=document.getElementById("CommonIllness");
    if (obj){
		if(obj.checked==true){
			CommonIllness="Y"
		}
    }
 	
 	
 	var Active="N"
  	var obj=document.getElementById("Active");
    if (obj){
		if(obj.checked==true){
			Active="Y"
		}
    }
    
    var  DiagnosisLevel=""
 	var obj=document.getElementById("DiagnosisLevel");
    if (obj) {DiagnosisLevel=obj.value;}
    
 	var  EDCRID=""
 	var obj=document.getElementById("EDCRID");
    if (obj) {EDCRID=obj.value;}
 	//alert("EDCRID:"+EDCRID);

 	
  	var DiagnoseConclusion=""
  	var obj=document.getElementById("DiagnoseConclusion");
    if (obj){
		DiagnoseConclusion=obj.value
	}
	if (""==DiagnoseConclusion){
		alert("请填写汇总分析意见");
		return false
  	} 

  	var Detail=""
  	var obj=document.getElementById("Detail");
    if (obj){
		Detail=obj.value
	}
	if (""==Detail){
		alert("请填写结论");
		return false
  	} 
  	else{ 
  		var obj=document.getElementById("StationID");
    	if (obj){
			StationID=obj.value
		}
	var SexDR=""
  	var obj=document.getElementById("Sex_DR_Name");	//	列表框时使用
	if (obj) { SexDR=obj.value; }
  		
  		var HighRisk="N";
	  	var obj=document.getElementById("HighRisk");
  		if (obj&&obj.checked){HighRisk="Y"}
  		
  		
    	var Ins=document.getElementById('UpdateBox');
    	if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
  
        var flag=cspRunServerMethod(encmeth,EDRowId,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserId,StationID,Active,DiagnosisLevel,EDCRID,SexDR,HighRisk)
        //alert("flag:"+flag);
        if ('0'==flag) 
        {
	        window.opener.location.href=window.opener.location.href;
	        //alert(window.opener.location.href);
	        //window.close();
	        //window.opener.location.reload();
	        location.reload();
	        }
         else{
	        alert("Update error.ErrNo="+flag)
     	}
     //
     }
    
}
function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationID");
	if (obj) obj.value=DataArry[1];
}
//增加诊断条件
function BEditCondition_Click()
{	
	var lnk;

	var ParrefRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		ParrefRowId=obj.value
	}

	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEEDCondition"
			+"&ParrefRowId="+ParrefRowId;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=500,height=600,left=0,top=0';
	window.open(lnk,"_blank",nwin)
		 
}
//增加诊断条件
function BEDR_Click()
{	
	var lnk;

	var ParrefRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		ParrefRowId=obj.value
	}

	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIDRelate"
			+"&ParrefRowId="
			+"&EDID="+ParrefRowId;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=500,height=600,left=0,top=0';
	window.open(lnk,"_blank",nwin)
		 
}
//关键字诊断维护
function KeyReplace_Click()
{	
	var lnk;

	var ParrefRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		ParrefRowId=obj.value
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEEDKeyReplace"
			+"&EDID="+ParrefRowId
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=500,height=600,left=0,top=0';
	window.open(lnk,"_blank",nwin)
		 
}
document.body.onload = BodyLoadHandler;