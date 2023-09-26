//DHCPEExpertDiagnosis.New.js
var UserId=session['LOGON.USERID']
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("DeleteP");
	if (obj) obj.onclick=Delete_click;
	obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_Click;
	obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("Active");
    if (obj){obj.checked=true}
    var obj=document.getElementById("Code");
    if(obj){obj.disabled=true}
	obj=document.getElementById("StationName");
	if (obj) obj.onchange=StationName_onchange;
    obj=document.getElementById("RelateIllness");
	if (obj) obj.onchange=RelateIllness_onchange;
	obj=document.getElementById("StationLocDesc");
	if (obj) obj.onchange=StationLocDesc_onchange;
	Muilt_LookUp('RelateIllness');
	init();
}
function StationLocDesc_onchange()
{
	var obj=document.getElementById("StationLocID");
	if (obj) obj.value="";
	var obj=document.getElementById("StationLocDesc");
	if (obj) obj.value="";
}
function AfterSelectStationLoc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("StationLocID");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("StationLocDesc");
	if (obj) obj.value=Arr[3];
}
function ExpertDiagnosis(aDiagnoseConclusion,aDetail)
{	
    document.getElementById("DiagnoseConclusion").value=aDiagnoseConclusion;
    document.getElementById("Detail").value=aDetail;  		
}


function init()
{
	
	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    //if (obj && ""!=obj.value){
		obj=document.getElementById("DataBox");
		//alert(obj.value)
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
			obj=document.getElementById("Sort");
			if(obj){ obj.value=EDList[8]; }
			obj=document.getElementById("StationLocID");
			if(obj){ obj.value=EDList[9]; }
			obj=document.getElementById("StationName");
			var AddNum=3;
			obj.value=EDList[8+AddNum];
			obj=document.getElementById("Detail");
			obj.value=EDList[7+AddNum];
            obj=document.getElementById("DiagnosisLevel");   
	        obj.value=EDList[10+AddNum]
	        obj=document.getElementById("EDCRID");           
	        obj.value=EDList[11+AddNum]
	        obj=document.getElementById("Sex_DR_Name");   
	        obj.value=EDList[12+AddNum]
			obj=document.getElementById("StationLocDesc");   
	        obj.value=EDList[13+AddNum]
			obj=document.getElementById("Illness");
			if(EDList[3]=="Y"){ obj.checked=true; }
			obj=document.getElementById("CommonIllness");
			if(EDList[4]=="Y"){ obj.checked=true; }
			obj=document.getElementById("Active");
			if(EDList[9+AddNum]=="Y"){ 
				obj.checked=true; 
			}else{
				obj.checked=false;
			}
		}
    //}
}
function StationName_onchange()
{
	var obj=document.getElementById("StationID");
	if (obj) obj.value="";
	StationLocDesc_onchange();
}
function RelateIllness_onchange()
{
	var obj=document.getElementById("IllRowID");
	if (obj) obj.value="";
}
//新增
function BAdd_Click()
{
	//Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserUpdate
	var obj=document.getElementById("ParrefRowId");
	if (obj&&obj.value!=""){
		if (!confirm("要使用信息重新增加新建议吗")){
			return false;
		}
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
	
 	var LevelID=""
  	var obj=document.getElementById("DiagnosisLevel");
    if (obj){LevelID=obj.value
	    
	    }
	
 	
  	var DiagnoseConclusion=""
  	var obj=document.getElementById("DiagnoseConclusion");
    if (obj){
		DiagnoseConclusion=obj.value
	}
	if (""==DiagnoseConclusion){
		//alert("请填写汇总分析意见");
            alert("请填写结论");
		return false
  	} 
  	
  	var EDAlias=""
  	var obj=document.getElementById("EDAlias");
    if (obj){
		EDAlias=obj.value
	}
	if (""==EDAlias){
		alert("必须填写别名");
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
		//alert("请填写结论");
            alert("请填写建议");
		return false
  	} 
  	else{
	  	var obj=document.getElementById("StationID");
    	if (obj){
			StationID=obj.value
		}
		if (""==StationID){
		alert("必须选择站点");
		return false
  	}
  	    var RelateFlag="N",IllRowID=""            //
  	 	var obj=document.getElementById("GetRelateFlag");
  	 	if (obj){RelateFlag=obj.value}
  	 	var obj=document.getElementById("IllRowID");
	    if (obj) {IllRowID=obj.value}
  	 	if ((RelateFlag=="Y")&&(IllRowID==""))
  	 	{	alert("必须关联疾病");
		    return false
	  	}
	  	var HighRisk="N";
	  	var obj=document.getElementById("HighRisk");
  		if (obj&&obj.checked){HighRisk="Y"}
		var Sort="";
	  	var obj=document.getElementById("Sort");
  		if (obj){Sort=obj.value}
		var StationLocID="";
	  	var obj=document.getElementById("StationLocID");
  		if (obj){StationLocID=obj.value}
		
		var SexDR=""
  		var obj=document.getElementById("Sex_DR_Name"); 
		if (obj) { SexDR=obj.value; }

    	var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+CommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+StationID+"^"+Active+"^"+LevelID+"^"+IllRowID+"^"+HighRisk+"^"+Sort+"^"+StationLocID+"^"+SexDR;
    	var Ins=document.getElementById('InsertBox');
    	if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
        var value=cspRunServerMethod(encmeth,InString)
  
        values=value.split("^");
        flag=values[0];
        if ('0'==flag) {
	        if (InsertType!="User")
	        {  
	        	alert("添加成功")
	        	lnk="dhcpeexpertdiagnosis.lnk.csp?ParrefRowId="+values[1];
		        parent.location.href=lnk
		        return false;
	        }
	        if (opener)
	        {
		       opener.AddDiagnosis(values[1]+"^^^^");
		       window.close();
	        }
	        
	    }
         else{
	        alert("Update error.ErrNo="+flag)
     	}
     }
     
     
}
//更新
function Update_Click()
{	
  	var EDRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		EDRowId=obj.value
	}
	if (EDRowId==""){
		alert("没有原记录,请点击'新建'");
		return false;
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
		//alert("请填写汇总分析意见");
		alert("请填写结论");
		return false
  	} 

  	var Detail=""
  	var obj=document.getElementById("Detail");
    if (obj){
		Detail=obj.value
	}
	if (""==Detail){
		//alert("请填写结论");
		alert("请填写建议");
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
  		
  		var Sort="";
	  	var obj=document.getElementById("Sort");
  		if (obj){Sort=obj.value}
		var StationLocID="";
	  	var obj=document.getElementById("StationLocID");
  		if (obj){StationLocID=obj.value}
		
    	var Ins=document.getElementById('UpdateBox');
    	if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
		var ExpStr=HighRisk+"^"+Sort+"^"+StationLocID
        var flag=cspRunServerMethod(encmeth,EDRowId,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserId,StationID,Active,DiagnosisLevel,EDCRID,SexDR,ExpStr)
        //alert("flag:"+flag);
        if ('0'==flag) 
        {
	        //window.opener.location.href=window.opener.location.href;
	        //alert(window.opener.location.href);
	        //window.close();
	        //window.opener.location.reload();
			alert("更新成功");
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
function GetIllDesc(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("RelateIllness");
	if (obj) obj.value=DataArry[1];
	var obj=document.getElementById("IllRowID");
	if (obj) obj.value=DataArry[0];
}

/*
function unload()
{
	if (isnull(window.returnValue)) window.returnValue=0
}*/
document.body.onload = BodyLoadHandler;
//documnet.body.unonload = unload;