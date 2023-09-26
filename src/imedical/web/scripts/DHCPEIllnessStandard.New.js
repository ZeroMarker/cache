var UserId=session['LOGON.USERID']
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_Click;
	
	obj=document.getElementById("IllnessExplain");
	if (obj) obj.onclick=IllnessExplain_Click; 
	
	obj=document.getElementById("IllSportGuide");
	if (obj) obj.onclick=IllSportGuide_Click;
	obj=document.getElementById("IllDietGuide");
	if (obj) obj.onclick=IllDietGuide_Click;
	
	
}
function IllSportGuide_Click()
{
  	IllLink_Click("2")
}
function IllDietGuide_Click()
{
	IllLink_Click("3")
}
function IllnessExplain_Click()
{
	IllLink_Click("1")
}
function IllLink_Click(Type){
	
	var obj;
    obj=document.getElementById("Rowid");
	if (obj){var ID=obj.value; }

	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("DiagnoseConclusion");
	if (obj){var IllDesc=obj.value; }   
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEIllnessExplain&IllRowID="+ID+"&LinkType="+Type+"&IllDesc="+IllDesc;
	
		
	var wwidth=700;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;

	var cwin=window.open(lnk,"_blank",nwin)	
	return false;    //LIKE形式的返回值为false
	                 //菜单连接形式的返回值为TRUE        
}
//更新
function Update_Click()
{	
  	//Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserUpdate
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
  		//alert(EDRowId+"!"+Code+"!"+DiagnoseConclusion+"!"+Detail+"!"+Illness+"!"+CommonIllness+"!"+UserId);
    	var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+CommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+ToReport+"^"+SexDR+"^^"+Type
    	var Ins=document.getElementById('UpdateBox');
    	if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
        var value=cspRunServerMethod(encmeth,InString)
        values=value.split("^");
        flag=values[0];

        if ('0'==flag) {
	        if (InsertType!="User")
	        {
		        alert("添加成功")
		        var obj=document.getElementById('Rowid');
		        if(obj){obj.value=values[1]}
				//window.close();
		       // return false;
	        }
	        if (opener)
	        {
		      // opener.AddDiagnosis(values[1]+"^^^^")
			     opener.location.reload();
	        }
	        window.close();
	    }
         else{
	        alert("Update error.ErrNo="+flag)
     	}
     }
    //window.close();
}
function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationID");
	if (obj) obj.value=DataArry[1];
}
/*
function unload()
{
	if (isnull(window.returnValue)) window.returnValue=0
}*/
document.body.onload = BodyLoadHandler;
//documnet.body.unonload = unload;