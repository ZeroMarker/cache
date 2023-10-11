
//名称	DHCPEDietManager.js
//功能	客户就餐
//组件	DHCPEDietManager  	
//创建	2018.08.23
//创建人  xy

var TPEADMID=""
var vRoomRecordID=""
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	//发饭
	obj=document.getElementById("BSend");
	if (obj){obj.onclick=BSend_click;}
	
	//取消发饭
	obj=document.getElementById("BCancelDiet");
	if (obj){obj.onclick=BCancelDiet_click;}

	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_KeyDown;
	}
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}	

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }
	
	obj=document.getElementById("BWaitList");
	if (obj) {obj.onclick=BWaitList_Click;}
	
	obj=document.getElementById("BComplete");
	if (obj) {obj.onclick=BComplete_Click;}
	SetRoomID();
	
}

function BCancelDiet_click()
{

	CancelDiet("0");
	return false;
}
function CancelDiet(Type)
{
	var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
	if(selectrow=="-1"){
		$.messager.alert("提示","请选择待取消就餐的人","info");
	     return false;
	     }
	var TPEADMID=objtbl[selectrow].TPEADM;
	var TCount=objtbl[selectrow].TCount;
	if (TPEADMID=="")
	{
		$.messager.alert("提示","请选择待取消就餐的人","info");
		return false; 
	}
	
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","CancelDiet",TPEADMID,Type,TCount);	
if (ReturnStr=="NCancelDiet")
	{ 
		$.messager.alert("提示","不能取消就餐","info");
		return true;
	}
if (ReturnStr=="Success")
	{ 
	  
		$.messager.alert("提示","取消就餐成功","success");
		//location.reload();
		 BFind_click();
		return true;
	}
	if (ReturnStr=="CancelDiet")
	{
		$.messager.confirm("确认", "是否确定取消就餐？", function(r){
		if (r){
				CancelDiet("1");
			}
		});
	}
	
	return false;
}


//added by xy 20151023
function RegNo_KeyDown(e){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		        
				var iRegNo="",TPEADMID="",Type=0,obj;
				var CTLocID=session['LOGON.CTLOCID'];
				
				var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
				var iRegNo=$("#RegNo").val();
				if(iRegNo==""){
					 $.messager.alert("提示","请输入登记号","info"); 
					return false; 
					
				}
				if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
						iRegNo=RegNoMask(iRegNo,CTLocID);
						$("#RegNo").val(iRegNo);
				}
				
				var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
				 var TPEADMID=""
				if((selectrow!="-1")&&(selectrow!="0")){
					var TPEADMID=objtbl[selectrow].TPEADM;
					}
				
				if(iRegNo==""){
					var TPEADMID=TPEADMID;
				}else{
					TPEADMID=iRegNo+"^";
				}
				
				if (TPEADMID=="")
				{
					 $.messager.alert("提示","请先选择待就餐的人","info"); 
					return false; 
				}
              
				var IsDietFlag=tkMakeServerCall("web.DHCPE.DietManager","IsDietFlag",TPEADMID);
				//alert(IsDietFlag)
			
				if(IsDietFlag=="NCanntDiet")
				{
					 $.messager.alert("提示","没有就餐权限","info"); 
					 return true;
				}
				else if(IsDietFlag=="NoPerson")
				{ 
					$.messager.alert("提示","没有选择就餐人员或者人员没有到达","info");
					return false;
				}else if(IsDietFlag=="CanntDiet"){
					$.messager.alert("提示","餐前项目还未检查完,不能吃饭","info");
					return false;
				}else if(IsDietFlag=="HadDiet")
				{
					$.messager.confirm("确认", "已经就餐,是否再次就餐？", function(r){
					if (r){
						
						 var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,1)
						 if (ReturnStr=="Success")
				         { 
				         	$.messager.alert("提示","就餐成功","success");
					      	BFind_click();
					      	return true;
				          }
						}
					else{
						return false;
					}
					});

					
				}else{
					
					var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,0)
					if (ReturnStr=="Success")
					{ 
					
						$.messager.popover({msg: "就餐成功", type: "info"});
						//$.messager.alert("提示","就餐成功","success");
						BFind_click();
						return true;
					}
				
				}
				
				return false;
	}
}

function SetRoomID()
{
	var Info=GetComputeInfo("");  //计算机名称  DHCPECommon.js
	var encmeth=GetValue("GetRoomIDClass");
	var RoomID=cspRunServerMethod(encmeth,Info);
	var Arr=RoomID.split("$")
	var Flag=Arr[1];
	/*
	if (Flag=="N"){
		var obj=GetObj("BActiveRoom");
		if (obj) obj.innerText="激活诊室";
	}*/
	var RoomID=Arr[0];
	SetValue("RoomID",RoomID);
	var encmeth=GetValue("GetCheckInfoClass");
	var UserID=session['LOGON.USERID'];
	var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
	var Arr=CheckInfo.split("$");
	var NumInfo=Arr[0];
	var NumArr=NumInfo.split("^");
	var PersonInfo=Arr[1];
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+PersonInfo
	var Info="共<font color=red size=6>"+NumArr[0]+"</font>人,已检<font color=red size=6>"+NumArr[1]+"</font>人,<a href="+lnk+" target='_blank' >未检<font size=6>"+NumArr[2]+"</font>人</a>"
	var obj=document.getElementById("cCheckInfo");
	//if (obj) obj.innerHTML=Info;
	
}


//等待列表
function BWaitList_Click()
{
	if (vRoomRecordID!=""){
		if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
			return false;
		}
	}
	vRoomRecordID="";
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
		alert("电脑没有设置对应的诊室");
		return false;
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail&RoomID="+RoomID;
	var PWidth=window.screen.width
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+400+',width='+720+',left='+260+',top=0'
			;

	var ALertWin=window.open(lnk,"AlertWin",nwin)
	return false;
}
function BComplete_Click()
{
	var RecordID=vRoomRecordID;
	var RoomID=GetValue("RoomID");
	var encmeth=GetValue("CompleteClass");
	
	var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
	var PAADM=objtbl[selectrow].TPAADM;
	if (PAADM==""){
		alert("没有就诊患者");
		return false;
	}
	var ret=cspRunServerMethod(encmeth,RecordID,PAADM,RoomID);
	var Arr=ret.split("^");
	vRoomRecordID="";
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerText=Arr[1];
	alert(Arr[1]);
	BWaitList_Click();
}

function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
}

function AfterGroupSelected(value){
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("GroupID",aiList[0],true);
	SetCtlValueByID("GroupDesc",aiList[1],true);
	
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
}

function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}

function BSend_click()
{	
	
	Update("0")
	return false;
}


function Update(Type)  
{
	var iRegNo="",TPEADMID="",obj;
	obj=document.getElementById("RegNo");
	if(obj){
		var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
		iRegNo=obj.value;
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}
	
	var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
	var TPEADMID=""
	if(selectrow!="-1"){
		var TPEADMID=objtbl[selectrow].TPEADM;
		}
	
	if(iRegNo==""){
		var TPEADMID=TPEADMID;
	}else{
		TPEADMID=iRegNo+"^";
	}
	
	
	if (TPEADMID=="")
	{
		 $.messager.alert("提示","请先选择待就餐的人","info"); 
		return false; 
	}
	
	var IsDietFlag=tkMakeServerCall("web.DHCPE.DietManager","IsDietFlag",TPEADMID);
	
	if(IsDietFlag=="NCanntDiet")
	{
		 $.messager.alert("提示","没有就餐权限","info"); 
		return true;
	}
	else if(IsDietFlag=="NoPerson")
	{
		 $.messager.alert("提示","没有选择就餐人员或者人员没有到达","info"); 
		return false;
	}else if(IsDietFlag=="CanntDiet"){
		$.messager.alert("提示","餐前项目还未检查完,不能吃饭","info");
		return false;
	}else if(IsDietFlag=="HadDiet")
	{
	
		$.messager.confirm("确认", "已经就餐,是否再次就餐？", function(r){
		if (r){
			 var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,1)
			 if (ReturnStr=="Success")
			 { 
				  $.messager.alert("提示","就餐成功","success");
				BFind_click();
				return true;
			}
			
			}
		else{
			
		}
		});

		
	}else{
	

		var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,0)
		if (ReturnStr=="Success")
		{ 
	    	$.messager.alert("提示","就餐成功","success");
        	BFind_click();
			return true;
		}
	
	}
	
	return false;
	
	
}


function BFind_click()
{
	var CTLocID=session['LOGON.CTLOCID'];
	var iBeginDate="",iEndDate="",GroupID="",RegNo="",DietFlag="",iVIPID="";
	var iBeginDate=getValueById("BeginDate")
	var iEndDate=getValueById("EndDate")	
	var GroupID=getValueById("GroupID")
	var RegNo=getValueById("RegNo")
	var DietFlag=getValueById("DietFlag")
	if(DietFlag){DietFlag="Y";}
	else{DietFlag="N";}
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	if (RegNo.length<RegNoLength&&RegNo.length>0) { 
		RegNo=RegNoMask(RegNo,CTLocID);
		$("#RegNo").val(RegNo)
	}
	var iVIPID=getValueById("VIPLevel")
	var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEDietManager"           
    +"&BeginDate="+iBeginDate
    +"&EndDate="+iEndDate
    +"&GroupID="+GroupID
    +"&RegNo="+RegNo
    +"&DietFlag="+DietFlag
    +"&VIPLevel="+iVIPID
	;
	//alert(lnk)
	//location.href=lnk;
	$("#tDHCPEDietManager").datagrid('load',{ComponentID:55926,BeginDate:iBeginDate,EndDate:iEndDate,GroupID:GroupID,RegNo:RegNo,DietFlag:DietFlag,VIPLevel:iVIPID});
	SelectRowHandler(-1);
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var TPEADMID=rowdata.TPEADM;
		var Count=rowdata.TCount;
		$("#RegNo").val("");
		
	}else
	{
		selectrow=-1;
	
	}

}


function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}

document.body.onload = BodyLoadHandler;