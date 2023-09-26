//名称	DHCPEInPatientToHP.js
//功能	住院体检患者
//组件	DHCPEInPatientToHP
//创建	2008.08.10
//创建人  xy
//修改 yupeng
function BodyLoadHandler() {
	
	
	$(window).on('resize', function () {
    	window.location.reload();
	});
	
   
	var obj,EpisodeID="",encmeth="",BaseInfo="";
	obj=document.getElementById("BDelete");
	if (obj){
		obj.onclick=BDelete_click;
		Showobj=document.getElementById("ShowDelete");
		var ShowDelete=0;
		if (Showobj) ShowDelete=Showobj.value;
		if (ShowDelete==0) obj.style.display = "none";
	}
	
	
	obj=document.getElementById("EpisodeID");
	if (obj){ EpisodeID=obj.value;}
	if (EpisodeID!=""){
		var flag=tkMakeServerCall("web.DHCPE.OtherPatientToHP","IsOtherPatientToHP",EpisodeID);
		
		if(flag=="1"){return false;}
		obj=document.getElementById("BaseInfo")
		if (obj) BaseInfo=obj.value;
		if (BaseInfo!=""){
			var Arr=BaseInfo.split("^");
			var User=session['LOGON.USERID'];
		$.messager.confirm("确认", "确定要将'"+Arr[1]+"'设置为体检人员吗?", function(r){
		if (r){
			
			
			$.m({ ClassName:"web.DHCPE.OtherPatientToHP", MethodName:"Save",PAADM:EpisodeID,UserID:User},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示",ReturnValue,"info"); 
					return false; 
				}else if (ReturnValue.split("^")[0]=='0') {
					obj=document.getElementById("BFind");
					if (obj) obj.click(); 
				}
			});	
		}
	});
		}
	}
		
}


function BDelete_click()
{
	
	var encmeth="",ID="",UserID="";
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("提示","请选择待操作人员","info");
		return false;
}
	var obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	UserID=session['LOGON.USERID']
	var Ret=cspRunServerMethod(encmeth,ID,UserID);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		obj=document.getElementById("BFind");
		if (obj) obj.click();
	}else{
		$.messager.alert("提示",Arr[1],"info");
	} 
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{	
		var rowid=rowdata.EpisodeID;
        setValueById("ID",rowid)
		
	}else{
		 setValueById("ID","")	    
		 selectrow=-1;
		return;
	}
	
}


function DblClickRowHandler(rowIndex,rowData)
{
	var str="dhcpedocpatient.hisui.csp"+"?EpisodeID="+rowData.EpisodeID;
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1200,height=800,left=100,top=10');
	var wwidth=1450;
  	var wheight=1450;
  	var xposition = 0;
  	var yposition = 0;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(str,"_blank",nwin)


	
}

document.body.onload = BodyLoadHandler;