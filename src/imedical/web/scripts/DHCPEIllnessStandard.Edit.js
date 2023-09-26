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
	obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_Click;

	init();
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
			obj.value=EDList[0];
			obj=document.getElementById("DiagnoseConclusion");
			obj.value=EDList[1];
			obj=document.getElementById("Detail");
			obj.value=EDList[2];
			obj=document.getElementById("Illness");
			if(EDList[5]=="Y"){ obj.checked=true; }
			obj=document.getElementById("CommonIllness");
			if(EDList[6]=="Y"){ obj.checked=true; }
			obj=document.getElementById("ToReport");
			if(EDList[7]=="1"){ obj.checked=true; }
			obj=document.getElementById("Sex_DR_Name");
			obj.value=EDList[8];
			obj=document.getElementById("ReportType");
			obj.value=EDList[10];
			//obj=document.getElementById("StationName");
			//obj.value=EDList[8];
			
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
	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		EDRowId=obj.value
	}
	//alert
   	var Ins=document.getElementById('DeleteBox');
    if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    var flag=cspRunServerMethod(encmeth,EDRowId)
    if ('0'==flag) {
		  if (opener){opener.location.reload();}
	}
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
 	
  	var DiagnoseConclusion=""
  	var obj=document.getElementById("DiagnoseConclusion");
    if (obj){
		DiagnoseConclusion=obj.value
	}
	if (""==DiagnoseConclusion){
		alert("请填写汇总分析意见");
		return false
  	} 
  	
	//var InsertType="System"
	var obj=document.getElementById("InsertType");
	if (obj){InsertType=obj.value;}
  	var EDAlias=""
  	var obj=document.getElementById("EDAlias");
  	if (obj){EDAlias=obj.value;}
  	
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
	  	var obj=document.getElementById("ToReport");
    	var ToReport=0
    	if (obj&&obj.checked){
			ToReport=1
		}
		var obj=document.getElementById("Sex_DR_Name");
    	var SexDR=""
    	if (obj){
			SexDR=obj.value;
		}
		var Type=""
		obj=document.getElementById("ReportType");
		if (obj) Type=obj.value;
  		//alert(EDRowId+"!"+Code+"!"+DiagnoseConclusion+"!"+Detail+"!"+User+Date+"!"+CommonIllness+"!"+UserId);
    	
    	
    	var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^^^"+Illness+"^"+CommonIllness+"^"+ToReport+"^"+SexDR+"^^"+Type
    	var Ins=document.getElementById('UpdateBox');
    	if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,EDRowId,InString)
        //alert("flag:"+flag);
        if ('0'==flag) 
        {
	        //window.opener.location.href=window.opener.location.href;
	        //alert(window.opener.location.href);
			alert(t["01"]);
	        window.close();
	        window.opener.location.reload();
	        //location.reload();
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

	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIDRelate"
			+"&ParrefRowId="+ParrefRowId
			+"&EDID=";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=500,height=600,left=0,top=0';
	window.open(lnk,"_blank",nwin)
		 
}

document.body.onload = BodyLoadHandler;