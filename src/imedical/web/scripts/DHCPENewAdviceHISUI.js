var CurEDDesc="";


function AddEDID(obj)
{
	
	$HUI.window("#STEDDiv",{
		title:"科室建议",
		iconCls:'icon-w-list',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		modal:true,
		width:300,
		height:600
	});
	/*
    $("#STEDDiv").show();
	var op=getoffset(obj);
	
    var op=getoffset(obj);  
    var DivTop=op[0]+50;
	var Divleft=op[1]-500; 
	
	newPos=new Object();
	newPos.left=Divleft;
	newPos.top=DivTop;
	
	$("#STEDDiv").offset(newPos);
    $("#STEDDiv").show();
    */
	
}



function AddDefaultEDID(e)
{
	var obj,DefaultEDID="",DisplayDesc="",Result="",encmeth="";
	obj=document.getElementById("DefaultEDID");
	if (obj) DefaultEDID=obj.value;
	if (DefaultEDID==""){
		alert("该站点没有维护默认建议")
		return false;
	}
	if (DisplayDesc==""){
		DisplayDesc="默认"
	}
	if (Result==""){
		Result="默认"
	}
	obj=document.getElementById("UpdateDefaultEDInfo");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var ret=cspRunServerMethod(encmeth,DefaultEDID,DisplayDesc,Result);
	if (ret=="0"){
		//window.location.reload();
		AddDiagnosis(DefaultEDID);
	}else{
		alert(t["AddErr"]+ret)
	}
		return false;
}

function DBUpdate_click(){
		
	Update(1);
	return false;
}
function Update(AlertFlag)
{
	if($("#DBUpdate").linkbutton('options').disabled){
		return false
	}	

	SaveResult();
	var ObjArr=document.getElementsByName("Advice");
	var ArrLength=ObjArr.length;
	var Strings=""
	for (var i=0;i<ArrLength;i++)
	{
		var ObjID=ObjArr[i].id;
		var ID=ObjID.split("^")[0];
		var Remark="";
		var Advice=ObjArr[i].value;
		var obj=document.getElementById(ID+"^Desc");
		var DisplayDesc=obj.value;
		var EDCDesc=""
		if (Strings=="")
		{
			Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+""+"&&"+DisplayDesc+"&&"+EDCDesc
		}
		else
		{
			Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+""+"&&"+DisplayDesc+"&&"+EDCDesc
		}
	}
	
	if (Strings=="") 
	{
		return false;
	}
	var obj=document.getElementById("DUpdateBox");
	if (obj) var encmeth=obj.value;
	
	var flag=tkMakeServerCall("web.DHCPE.ResultEdit","UpdateStationDRemark",Strings);
	
	if (AlertFlag=="1") {
		window.location.reload();
	}
	return false;
}
function ShowEDInfo_change()
{
	var obj,ShowInfo=0,encmeth="";
	obj=document.getElementById("ShowEDInfo");
	if (obj&&obj.checked) ShowInfo=1;
	obj=document.getElementById("ShowEDInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ShowInfo)
	window.location.reload();
}

function DeleteEDInfo(e,alertFlag)
{
	if (alertFlag==1){
		$.messager.confirm("确认", "确定要删除该建议吗？", function(r){
			if (r){
				    var obj=document.getElementById("StationID");      
					if (obj) var ChartID=obj.value;             
					var obj=document.getElementById("EpisodeID");    
					if (obj) var EpisodeID=obj.value;             
					var obj=document.getElementById("DSSID");
					if (obj) var SSID=obj.value;
	
					var SSID=tkMakeServerCall("web.DHCPE.ResultEdit","GetSSId",EpisodeID,ChartID);
					var ID=e.id;
					var obj=document.getElementById("DSumResultBox");
					if (obj) var encmeth=obj.value;
					if (ID=="") return false;
					
					$.m({ ClassName:"web.DHCPE.ResultEdit", MethodName:"UpdateSSDiagnosis",SSID:SSID,SDID:ID,isDel:"1",ChartID:ChartID,EpisodeID:EpisodeID},function(ReturnValue){
				    	if (ReturnValue!='0') {
					    	if(ReturnValue=="HadAudit"){flag="科室已经提交";}
							if(ReturnValue=="HadDiagnosis"){flag="已经有相同的诊断";}
							//alert(flag)
					    	$.messager.alert("提示","删除失败:"+flag,"error");  
				   		}else{
					   		DeleteTableRow(e);
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				   		}
				   	});	
				}
			});
	}

}
/*
function DeleteEDInfo(e,alertFlag)
{
	if (alertFlag==1)
	{
		if (!confirm("确实要删除该建议吗")) {
			window.location.reload();
			 return false;
		}

	}
	var obj=document.getElementById("StationID");      
	if (obj) var ChartID=obj.value;             
	var obj=document.getElementById("EpisodeID");    
	if (obj) var EpisodeID=obj.value;             
	var obj=document.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	
	var SSID=tkMakeServerCall("web.DHCPE.ResultEdit","GetSSId",EpisodeID,ChartID);
	var ID=e.id;
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	
	//var flag=cspRunServerMethod(encmeth,SSID,ID,"1",ChartID,EpisodeID);
	var flag=tkMakeServerCall("web.DHCPE.ResultEdit","UpdateSSDiagnosis",SSID,ID,"1",ChartID,EpisodeID);
    if (flag==0){
		DeleteTableRow(e);
	}
	else{
		if(flag=="HadAudit"){flag="科室已经提交";}
		if(flag=="HadDiagnosis"){flag="已经有相同的诊断";}
		alert(flag)
		
	}
	return false;
}
*/

function StationSCancelSub()
{
	StatusChange("Cancel",0);
}


function Audit_click(e,CompleteFlag) {
	StatusChange("Submit",CompleteFlag);
	
}
function StatusChange(Type,CompleteFlag)
{
	 var obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;

	var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",PAADM,"PAADM");
	if((GAAuditedFlag=="1")&&(Type=="Cancel")) {
	 	   	$.messager.alert("提示","总检已初审,不能取消提交","info");
	 	   	return false;
 	   	}
 	 if((GAAuditedFlag=="1")&&(Type=="Submit")) {
	 	   	$.messager.alert("提示","总检已初审,不能提交","info");
	 	   	return false;
 	   	}


	var UpdateCode="1";
	
	CompleteFlag=tkMakeServerCall("web.DHCPE.ResultNew","GetWriteWay",StationIDHISUI)
	
	 var flag=tkMakeServerCall("web.DHCPE.ResultNew","IsOtherPatientToHP",PAADM)
	 if(flag=="1"){
		 alert("住院病人需在体检列表设置为体检类型");
		 return false;
	 }

	var UpdateCodeFlag=1;
	var UserID="";
	obj=document.getElementById("StationID");
	if (obj) ChartID=obj.value;
	var CurUserID=session['LOGON.USERID'];
	var CurLocID=session['LOGON.CTLOCID'];
	var UserID=session['LOGON.USERID'];
	if (Type=="Submit"){
		var obj=document.getElementById("AuditUser");
		if (obj) UserID=obj.value;
		// 自动插入会诊费
		var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,ChartID,UserID,CurUserID,CurLocID)
		var ConArr=ConRet.split("^");
		if (ConArr[0]=="-1"){
			alert(ConArr[1]);
			window.location.reload();
			return false;
		}else if (ConArr[0]=="-2"){
			if (!confirm(ConArr[1]+",是否继续?")){
			window.location.reload(); 
			return false;
			}

		}
		
	var UObj=document.getElementsByTagName('button');
	var ButtonLength=UObj.length;
	for (var i=0;i<ButtonLength;i++)
	{
		var ButtonID=UObj[i].name;
		if (ButtonID.split("Update").length>1)
		{
			if ((UObj[i].innerText.indexOf("保存结果")!=-1)){
		        //alert(UObj[i].id.split("^")[0])
				var ObjArr=document.getElementsByName(UObj[i].id.split("^")[0]);
				
				var ArrLength=ObjArr.length;
				var ResultInfo="";
				var Char_1=String.fromCharCode(1);
				for (var j=0;j<ArrLength;j++)
				{
					var ResultID=ObjArr[j].id;
					//alert(ResultID)
					var EyeSeeObj=document.getElementById(ResultID+"^EyeSee");
					if (EyeSeeObj){
					var EyeSee=EyeSeeObj.value;
					var ZDInfo=ObjArr[i].value;
					var Value="临床诊断:;检查所见:"+EyeSee+";诊断意见:"+ZDInfo;
				}else{
					var Value=ObjArr[j].value;
					}
		
				var OneInfo=ResultID+"^"+Value;
				if (ResultInfo==""){
					ResultInfo=OneInfo;
				}else{
					ResultInfo=ResultInfo+Char_1+OneInfo;
					}
			}
			var Flag=tkMakeServerCall("web.DHCPE.ResultNew","SaveResult",ResultInfo,"","","")
			if(Flag.split("^")[0]!="0"){
				$.messager.alert("提示",Flag.split("^")[1],"info");
				
				return false
				}
			}
		}
	}

		SaveResult();
	}
	
	//电子签名
	try{
		if (!PESaveCASign("1",PAADM+"%"+ChartID,"")) return false;
	}catch(e){}

	
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	//var flag=cspRunServerMethod(encmeth,PAADM,ChartID,Type,UserID);
	var flag=tkMakeServerCall("web.DHCPE.ResultEdit","AuditStationS",PAADM,ChartID,Type,UserID)
	if (flag=="0")
	{
		if (Type=="Submit")
		{
			if (CompleteFlag=="1")  //保存时科室确认
			{
				
				parent.BComplete();
			}
			var StationID=GetValue("StationID",1);
			var RoomID=GetValue("RoomID",1);
			if ((RoomID=="")&&(session['LOGON.CTLOCID']=="572")&&(StationID!="10")){
				document.write("<font color=red>完成检查</font>");
				
			}else{
				window.location.reload();
			}
			parent.ShowNextPage();
		}else{
			window.location.reload();
		}
		return false;
	}else{
		if (Type=="Submit")
		{
			var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,ChartID,CurUserID,CurUserID,CurLocID)
		
		}
		if(flag=="NoApp") $.messager.alert("提示","存在未执行的项目!","info");
		//window.location.reload();
		return false;
	}
}
function SaveResult()
{
	
	var UObj=document.getElementsByTagName('A');
	var ButtonLength=UObj.length;
	for (var i=0;i<ButtonLength;i++)
	{
		var ButtonID=UObj[i].id;
		if ((ButtonID.split("Update").length>1)&&((UObj[i].innerText.indexOf("保存结果")!=-1)||(UObj[i].innerText.indexOf("保存建议")!=-1))) UObj[i].click();
		if (ButtonID=="BSave") UObj[i].click();
	}
	var UObj=document.getElementsByTagName('button');
	var ButtonLength=UObj.length;
	for (var i=0;i<ButtonLength;i++)
	{
		var ButtonID=UObj[i].name;
		if (ButtonID.split("Update").length>1)
		{
			
			if ((UObj[i].innerText.indexOf("保存结果")!=-1)||(UObj[i].innerText.indexOf("保存建议")!=-1)){UObj[i].click();}
		}
		if (ButtonID=="BSave") UObj[i].click();
	}
	
	
}
function AddDiagnosis(value){
	var ID=value.split("^")[0];
	var obj=document.getElementById("StationID");
	if (obj) var ChartID=obj.value;
	obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	obj=document.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	var SSID=tkMakeServerCall("web.DHCPE.ResultEdit","GetSSId",EpisodeID,ChartID);
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	
	//var flag=cspRunServerMethod(encmeth,SSID,ID,"0",ChartID,EpisodeID);
	var flag=tkMakeServerCall("web.DHCPE.ResultEdit","UpdateSSDiagnosis",SSID,ID,"0",ChartID,EpisodeID);
	var Arr=flag.split("^");
	
	if (Arr[0]==0)
	{ 
		var obj=document.getElementById("GetEDInfoBox");
		if (obj) var encmeth=obj.value;
		//var Info=cspRunServerMethod(encmeth,ID,ChartID,EpisodeID);
		var Info=tkMakeServerCall("web.DHCPE.ResultEdit","GetEDInfo",ID,ChartID,EpisodeID);
		var InfoArr=Info.split("^");
		InsertNewRow(InfoArr[0],Arr[1],InfoArr[6]);
	}
	return false;
}
function EDClick()
{
	var eSrc=window.event.srcElement;
	var eSrcID=eSrc.id;
	var EpisodeID="";
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	var InfoArr=eSrcID.split("^");
	var StationID=InfoArr[0];
	var Desc=InfoArr[1];
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	EDDesc=Desc;
	//var Info=cspRunServerMethod(encmeth,StationID,Desc,EpisodeID);
	var Info=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","GetEDInfoByDesc",StationID,Desc,EpisodeID);
	if (Info=="") return false;
	CreateEDDetailDiv(eSrc,Info);
	//CreateDiv(eSrc,Info)
}
/*
function CreateDiv(obj,Info){  
	RemoveAllDiv(1); 
    div = document.createElement("div");   
    div.id="ALLEDDesc";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+30;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=200><TR align='left' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(0)'>关闭</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' value='"+OneArr[0]+"' ondblclick=AllEDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function AllEDDblClick(eSrc)
{
	var EDID=eSrc.value;
	EDDescDBLClick(CurEDDesc);
	AddDiagnosis(EDID);
}
*/
function InsertNewRow(SDID,Desc,Advice)
{
	var TableObj=document.getElementById("EDTABLE");
	var newTR = TableObj.insertRow(TableObj.rows.length);
	var newTD=newTR.insertCell(0);
	newTD.innerHTML = "<a href='javascript:void(0);' name='DeleteED' id='"+SDID+"'onclick='DeleteEDInfo(this,1)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
	var newTD=newTR.insertCell(1);
	newTD.innerHTML = "<textarea style='width:100%;white-space:normal; word-break:break-all;' rows=3 id='"+SDID+"^Desc' name='Desc'>"+Desc+"</textarea>";
	var newTD=newTR.insertCell(2);
	newTD.innerHTML = "<textarea style='width:85%;white-space:normal; word-break:break-all;' rows=3 id='"+SDID+"^Advice' name='Advice'>"+Advice+"</textarea>";
}  
function DeleteTableRow(e)
{
	var Rows=e.parentNode.parentNode.rowIndex;
	var TableObj=document.getElementById("EDTABLE");
	TableObj.deleteRow(Rows);
}