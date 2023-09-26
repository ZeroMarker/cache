//名称	DHCPEDocPatientList.js
//功能	体检列表
//组件	DHCPEDocPatientList	
//创建	2018.09.30
//创建人  xy
function LoadHandler1() {
	

	$("#Find").click(function() {
				Find_click();		
        });
	
	$("#PatientNo").keydown(function(e) {		
			if(e.keyCode==13){
				Find_click();
			}
			
        });
        
     $("#SurName").keydown(function(e) {		
			if(e.keyCode==13){
				Find_click();
			}
			
        });
	
	
	 $("#CardNo").keydown(function(e) {		
			if(e.keyCode==13){
				CardNo_Change();
			}
			
        });
     $("#CardNo").change(function(){
  			CardNo_Change();
		}); 
	var obj=document.getElementById("GroupName");
	if (obj) obj.onchange=GroupNameChanged;
	
	var obj=document.getElementById("TeamName");
	if (obj) obj.onchange=TeamNameChanged;
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCardClickHandler;}
	

    Muilt_LookUp('GroupName'+'^'+'TeamName'+'^'+'DepName');
	websys_setfocus("PatientNo");
	
	//卡类型初始化
	//initialReadCardButton();
	
}


function Find_click()
{
	 
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var iPatientNo=getValueById("PatientNo");
	if (iPatientNo.length<RegNoLength&&iPatientNo.length>0) { iPatientNo=RegNoMask(iPatientNo);}
	$("#PatientNo").val(iPatientNo);

    var iSurName=getValueById("SurName");
   
    var iStartDate=getValueById("StartDate");
    
    var iEndDate=getValueById("EndDate");
    
	var iGroupName=getValueById("GroupName");
   
    var iGroupID=getValueById("GroupID");
   
    var iTeamName=getValueById("TeamName");
    
    var iTeamID=getValueById("TeamID");
    
	var IncludeCompleted=getValueById("IncludeCompleted");
	if(IncludeCompleted){IncludeCompleted=1;}
	else{IncludeCompleted="";}
	
	var IsCanSumResult=getValueById("IsCanSumResult");
	if(IsCanSumResult){IsCanSumResult=1;}
	else{IsCanSumResult="";}
	
	var LocAudited=getValueById("LocAudited");
	if(LocAudited){LocAudited=1;}
	else{LocAudited="";}
	
	var MainDoctor=getValueById("MainDoctor");
	if(MainDoctor){MainDoctor=1;}
	else{MainDoctor="";}
	
	 var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEDocPatientList"
			+"&PatientNo="+iPatientNo
			+"&SurName="+iSurName
			+"&StartDate="+iStartDate
			+"&EndDate="+iEndDate
			+"&GroupID="+iGroupID
			+"&TeamID="+iTeamID
			+"&TeamName="+iTeamName
            +"&IncludeCompleted="+IncludeCompleted
            +"&IsCanSumResult="+IsCanSumResult
            +"&LocAudited="+LocAudited
			+"&MainDoctor="+MainDoctor
            ;
			 //alert(lnk)
      $("#tDHCPEDocPatientList").datagrid('load',{ComponentID:55929,PatientNo:iPatientNo,SurName:iSurName,StartDate:iStartDate,EndDate:iEndDate,GroupID:iGroupID,TeamID:iTeamID,TeamName:iTeamName,IncludeCompleted:IncludeCompleted,IsCanSumResult:IsCanSumResult,LocAudited:LocAudited,MainDoctor:MainDoctor});   

           
            
    //location.href=lnk; 
    
	
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change()
	}
}

function CardNo_Change()
{
	 var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	if (myCardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
	//alert("myrtn:"+myrtn)
	return false;
	

}
//读卡
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PatientNo").val(PatientNo);
			Find_click();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PatientNo").val(PatientNo);
			Find_click();
			event.keyCode=13;
			break;
		default:
	}
}


function AfterGroupSelected(value){
	
	if (""==value){return false}
	var aiList=value.split("^");
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=aiList[0];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=aiList[1];
	
}

function AfterItemSelected(value){
	if (""==value){return false}
	var aiList=value.split("^");
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=aiList[1];
	var obj=document.getElementById("TeamName");
	if (obj) obj.value=aiList[0];
	
}

function GroupNameChanged()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamName");
	if (obj) obj.value="";
}

function TeamNameChanged()
{
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
}


function DblClickRowHandler(rowIndex,rowData)
{
	var lnk="dhcpedocpatient.hisui.csp"+"?PAADM="+rowData.EpisodeID;
	var wwidth=screen.width-10;
	var wheight=screen.height-10;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(lnk,"_blank",nwin)	
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		
	}else
	{
		SelectedRow=-1;
	
	}


}


function GetIPAddress()	{
			var SetSkipStatus=document.getElementById('SetSkipStatus');
			if (SetSkipStatus) {var encmeth=SetSkipStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID);
}
function UnLoadHandler()	{
	//alert('Now unload Window!!');
}

document.body.onload=LoadHandler1;
document.body.onunload=UnLoadHandler;
