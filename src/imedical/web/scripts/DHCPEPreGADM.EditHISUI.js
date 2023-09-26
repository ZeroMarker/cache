//名称 DHCPEPreGADM.EditHISUI.jS
//功能 团体预约hisui
//创建 
//创建人 yp

var BNewWin = function(){
	
	setValueById("PGTRowId","")
	setValueById("PGTChildSub","")
	setValueById("TeamDesc","")

	$HUI.window("#NewWin",{
		title:"团体分组信息",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		modal:true,
		width:900,
		height:620
	});
	
	$HUI.radio("#TeamSexN").setValue(true);
	$HUI.radio("#TeamMarriedN").setValue(true);
	
	var VIPLevelDesc=$("#VIPLevel").combobox('getText');
	if (VIPLevelDesc=="职业病"){
			$("#OMEType").combobox('enable');
			$("#HarmInfo").combotree('enable');
		}else{
				$("#OMEType").combobox('disable');
				$("#HarmInfo").combotree('disable');
				
		}

	var GADMID=getValueById("ID")
	
	var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
	
	
	setValueById("ParRef_Name",ret.split("^")[3])
	
	SetParRefData(ret)
	
	var ret=tkMakeServerCall("web.DHCPE.PreGTeam","DocListBroker","","",GADMID+"^^");
	
	//TeamClear();
	
}

var RapidNewWin = function(){
	
	var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
	if (GStatus!="PREREG"){
		$("#RapidNew").linkbutton('disable');
		return false;
		}
	else{
		$("#RapidNew").linkbutton('enable');
	}

	$HUI.window("#RapidNewWin",{
		title:"快速分组",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		modal:true,
		width:800,
		height:500
	});
	
	var GADMID=getValueById("ID")
	var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
	SetRapidParRefData(ret)
}


function VIPLevelOnChange()
{
	
	var obj=document.getElementById("VIPLevel");
	if (obj){
		var VIPLevel=$("#VIPLevel").combobox('getValue');
		
		if (VIPLevel=="") return false;
		
		var VIPLevelDesc=$("#VIPLevel").combobox('getText');
		if (VIPLevelDesc=="职业病"){
			$("#OMEType").combobox('enable');
			$("#HarmInfo").combotree('enable');
			var TeamOMETypeObj = $HUI.combobox("#OMEType",{
				url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOMEType&ResultSetType=array",
				valueField:'id',
				textField:'Desc',
				onBeforeLoad: function(param){
					param.VIPLevel=$("#VIPLevel").combobox('getValue'); 
	 			}	
			});
	
			}else{
				$("#OMEType").combobox('disable');
				$("#HarmInfo").combotree('disable');
				$("#OMEType").combobox('setValue',"");
				$("#HarmInfo").combotree('setValue',"");
				
			}
		var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel)
		if (PatType!=""){
			var obj=document.getElementById("TeamPatFeeTypeName");
			if (obj) $('#TeamPatFeeTypeName').combobox('setValue',PatType);
		}
		var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"G");
		var obj=document.getElementById("RoomPlace");
		if (obj) { $('#RoomPlace').combobox('setValue',DefaultRoomPlace);}
		$('#RoomPlace').combobox('reload');
		
		
	}
	
}
function TeamSetAddItem(value) {
	
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	//	允许加项	PGADM_AddOrdItem	19
	obj=document.getElementById("TeamAddOrdItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			setValueById("TeamAddOrdItem",true)
			iAddOrdItem=true;
			
		}
		else { 
			setValueById("TeamAddOrdItem",false)
			iAddOrdItem=false;
		}
				
	}
	iLLoop=iLLoop+1;	
	
	var iAddOrdItemLimit=false;
	//	加项金额限制	PGADM_AddOrdItemLimit	20
	obj=document.getElementById("TeamAddOrdItemLimit");
	if (obj) { 
		if (iAddOrdItem) {
			obj.disabled=false;
			if ("Y"==Data[iLLoop]) {
				setValueById("TeamAddOrdItemLimit",true)
				iAddOrdItemLimit=true;
			}
			else {
				obj.checked=false;
				iAddOrdItemLimit=false;
			}
			
		}
		else {
			obj.disabled=true;
			
			obj.checked=false;
			iAddOrdItemLimit=false;
							
		}
	}
	iLLoop=iLLoop+1;	
	
	//	允许加项金额	PGADM_AddOrdItemAmount	21
	obj=document.getElementById("TeamAddOrdItemAmount");
	if (obj) {
		if (iAddOrdItemLimit) {
			obj.disabled=false;
			setValueById("TeamAddOrdItemAmount",Data[iLLoop])
		}
		else{
			obj.disabled=true;
			
			obj.value="";
		}
		
	}
	iLLoop=iLLoop+1;	
	
	//	允许加药	PGADM_AddPhcItem	22
	var iAddPhcItem=false;
	obj=document.getElementById("TeamAddPhcItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			setValueById("TeamAddPhcItem",true)
			iAddPhcItem=true;
		}
		else {
			setValueById("TeamAddPhcItem",false)
			iAddPhcItem=false
		}

	}
	iLLoop=iLLoop+1;	
	
}

function SetRapidParRefData(value) {
	
	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=4;	
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	预约日期
	//setValueById("RapidBookDateBegin",fillData)
	$("#RapidBookDateBegin").datebox('setValue',fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateEnd
	//setValueById("RapidBookDateEnd",fillData)
	$("#RapidBookDateEnd").datebox('setValue',fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookTime	预约时间
	setValueById("RapidBookTime",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	预约接待人员
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	setValueById("RapidPEDeskClerkName",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
	var strLine=""
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	TeamSetAddItem(strLine);
	
	// PGADM_GReportSend 团体报告发送
	setValueById("RapidGReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend 个人报告发送 
	setValueById("RapidIReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode 结算方式
	setValueById("RapidDisChargedMode",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
    
    //VIP
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //默认团体就诊类别
    
    setValueById("RapidPatFeeTypeName",fillData)
	
	
	return true;
	
	
	
}

function SetParRefData(value) {

	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=4;	
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	预约日期
	setValueById("TeamBookDateBegin",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateEnd
	setValueById("TeamBookDateEnd",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookTime	预约时间
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	setValueById("TeamPEDeskClerkNameID",fillData)
	// PGADM_AuditUser_DR	预约接待人员
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	setValueById("TeamPEDeskClerkName",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
	var strLine=""
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	TeamSetAddItem(strLine);
	
	// PGADM_GReportSend 团体报告发送
	setValueById("TeamGReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend 个人报告发送 
	setValueById("TeamIReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode 结算方式
	setValueById("TeamDisChargedMode",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
    
    //VIP
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //默认团体就诊类别
    
    setValueById("TeamPatFeeTypeName",fillData)
	
	var VIPLevel="";
	VIPLevel=getValueById("VIPLevel")
	var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"G");
	setValueById("RoomPlace",DefaultRoomPlace)
	return true;

}
function TeamAddOrdItem_click(value) {


	if (value) {
		 	$("#TeamAddOrdItemLimit").checkbox("enable");
			setValueById("TeamAddOrdItemLimit",true);
			$("#TeamAddOrdItemAmount").attr("disabled",false)
		
	}
	else{
		
			$("#TeamAddOrdItemLimit").checkbox("disable");
			setValueById("TeamAddOrdItemLimit",false)
		
			$("#TeamAddOrdItemAmount").attr("disabled",true);
			setValueById("TeamAddOrdItemAmount","")
			
	}

}
function TeamAddOrdItemLimit_click(value) {
	if (value) {
		$("#TeamAddOrdItemAmount").attr("disabled",false)
		
	}
	else{
		$("#TeamAddOrdItemAmount").attr("disabled",true);
		setValueById("TeamAddOrdItemAmount","") 
			
	}
	
}
function ReadCardClickHandlerG(){
	var SelValue=$HUI.combobox("#CardType").getValue();
	
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	var myary=SelValue.split("^");
	var myEquipDR=myary[14];
	
	var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);
	
	
	
	var ReturnArr=rtn.split("^");
	
	if (ReturnArr[0]=="-200")
	{
		 var cardvalue=rtn.split("^")[1];
		 return false;
	}
	
	$('#PAPMINo').val(ReturnArr[5]);
	RegNoOnChange();
	$('#CardNo').val(ReturnArr[1]);
	
}
	
function ReadCardClickHandler(){
	var SelValue=$HUI.combobox("#PCardType").getValue();
	
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	var myary=SelValue.split("^");
	var myEquipDR=myary[14];
	
	var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);
	
	
	
	var ReturnArr=rtn.split("^");
	
	if (ReturnArr[0]=="-200")
	{
		 var cardvalue=rtn.split("^")[1];
		 return false;
	}
	$('#RegNo').val(ReturnArr[5]);
	PRegNoOnChange();
	$('#PCardNo').val(ReturnArr[1]);
	
	
	
}
function DHCACC_GetAccInfoHISUI(CardTypeDR, EquipDR)
{
	
	//var myrtn =DHCACC_ReadMagCard(EquipDR);
	
	var myrtn =DHCACC_ReadMagCard(EquipDR,"R", "23");
	
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
	
			var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
			var myrtn=tkMakeServerCall("web.UDHCAccManageCLSIF","getaccinfofromcardno",myCardNo,myCheckNo, myExpStr);
			
			var myary=myrtn.split("^");
			if(myary[0]==0)
			{
			rtn=myary[0];
			
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myPAPMI=myary[7];
			var myPAPMNo=myary[8];
			var myAccType=myary[10];
			var myAccGrpLeftM=myary[17]
			if (myary.length>12){
				myGetCardTypeDR=myary[12];
			}
			if (myary.length>13){
				mySCTTip = myary[13];
			}
			}
		
	}else{
		rtn=myary[0];
		
	}
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip+"^"+myAccGrpLeftM;
}

function SetButtonDisable()
{
	
	$("#AddOrdItemLimit").checkbox("disable");
	$("#AddOrdItemAmount").attr('disabled','disabled');
	
		
	
	

	
	var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
	if (GStatus!="PREREG")
	{
		$("#RapidNew").linkbutton('disable');
	}
}


function BMoveTeam_Click()
{
	var SelectIds=""
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		
		if (SelectIds==""){
				SelectIds=selectrow[i].PIADM_RowId;
			}else{
				SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
			} 
	}
	/*
	if(selectrow.length>=2){
		$.messager.alert("提示","只能选择一人转组","info");
		return false;
		}
	*/
	if(SelectIds=="")
	{ 
		$.messager.alert("提示","请选择待转组人员","info");
		return false;
	}
    var iRowId=SelectIds;


	//if (!confirm("是否确定转组")) return false;
	//$.messager.confirm("确认", "是否确定转组", function(r){if (!r) { return false; }});
	$.messager.confirm("确认", "是否确定转组？", function(r){
		if (r){
			
				var flag=tkMakeServerCall("web.DHCPE.CancelPE","CheckIAdmCanCancel",iRowId);
				if(flag=="1") {
					$.messager.alert("提示","存在已执行或者已交费的项目,不能转组","info");
					return false;
				}
	
				var iPGADM=getValueById("ID");
	
				var iGTeam=getValueById("PGTRowId");

				var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEMoveTeam"
				+"&ParRef="+iPGADM
				+"&PIADMRowId="+iRowId
				+"&PGTeam="+iGTeam
				;
				var wwidth=900;
				var wheight=650;
	
				var xposition = (screen.width - wwidth) / 2;
				var yposition = ((screen.height - wheight) / 2)-10;
				var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
					+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
					;
	
				var cwin=window.open(lnk,"_blank",nwin)
				//websys_lu(lnk,false,'width=800,height=700,hisui=true,title=分组列表')
	
			}
	});
	
		
	
}
var init = function(){
	
	
	SetButtonDisable();
	LoadCard();
	
	if((OperType)&&(OperType=="T"))
	{$('#GroupTab').tabs('select',"团体分组");}
	
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandlerG;
	var obj=document.getElementById('PReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;
	
	$("#BRegister").css({"width":"110px"});
	$("#BNewIADM").css({"width":"130px"});
	$("#PNewItem").css({"width":"130px"});
	$("#BAddItem").css({"width":"130px"});
	$("#BCancelSelect").css({"width":"130px"});
	$("#BMoveTeam").css({"width":"120px"});
	$("#BCancelPE").css({"width":"120px"});
	$("#BFind").css({"width":"130px"});
	$("#BSelectPre").css({"width":"130px"});
	$("#PrintTeamSelf").css({"width":"130px"});
	
	$("#Update").css({"width":"130px"});
	$("#GroupTeam").css({"width":"130px"});
	$("#PreGImport").css({"width":"130px"});
	$("#ImportCheck").css({"width":"130px"});

	$("#GroupTeam").click(function(){
			
  			$('#GroupTab').tabs('select',"团体分组");
		});

	$('#GroupTab').tabs({
    
    	onSelect:function(title,index){
        	if(title=="团体分组")
        	{
				$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
	
	        	
	        }
    	}
	});
	//转组
	$("#BMoveTeam").click(function(){
  			BMoveTeam_Click();
		});

	   //快速分组
      $HUI.radio("[name='TeamNum']",{
            onChecked:function(e,value){
	           var checkedRadioObj = $("input[name='TeamNum']:checked");
				OneData=checkedRadioObj.val();
	
				if ((OneData=="Team_One")||(OneData=="Team_Two")||(OneData=="Team_Three")){
	            	$("#AgeBoundary").attr('disabled',true);
					$("#AgeBoundary").val("")
				}else{
					$("#AgeBoundary").attr('disabled',false);
					
				}
               
           }
        });



	$("#BPrintPatItem").click(function(){
  			BPrintPatItem_click();
		});
		
	$("#PrintTeamPerson").click(function(){
  			PrintTeamPerson_click("");
		});	
	
	
	$("#ContinueRegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				ConPrintTPerson_click();
			}
			
        });
       
	
	$("#ContinuePrintTeamPer").click(function(){
  			ConPrintTPerson_click();
		});
			
	$("#PrintTeamSelf").click(function(){
  			PrintTeamSelf_click();
		});		
		
		
	$("#Update").click(function(){
  			Update();
		});
	$("#PNewItem").click(function(){
  			PNewItem();
		});	
	$("#BNewIADM").click(function(){
  			BNewIADM();
		});	
	$("#BSelectPre").click(function(){
  			BSelectPre();
		});		
	$("#BCancelSelect").click(function(){
  			BCancelSelect();
		});		
		
	$("#BCancelPE").click(function(){
  			BCancelPE();
		});		
	$("#TCancelPE").click(function(){
  			TCancelPE();
		});			
	$("#BRegister").click(function(){
  			BRegister();
		});		
		
	$("#BAddItem").click(function(){
  			BAddItem();
		});		
		
	$("#BNewItem").click(function(){
  			BNewItem();
		});		
		
	$("#TeamUpdate").click(function(){
  			TeamUpdate();
		});	
		
	//清屏
	$("#TeamClear").click(function(){
  			TeamClear();
		});
	
	//存为预置		
	$("#SaveTemplate").click(function(){
  			SaveTemplate();
		});
		
	$("#BCopyTeam").click(function(){
  			BCopyTeam();
		});		
			
		
	$("#RapidUpdate").click(function(){
  			RapidUpdate();
		});	
	$("#PreGImport").click(function(){
  			ReadInfo();
		});	
	
	$("#ImportCheck").click(function(){
  			CheckInfo();
		});	
	
	
		
	$("#BNew").click(function(){
  			BNewWin();
		});
	
	$("#BFind").click(function(){
  			BFind_Click();
		});
	
	
	$("#RapidNew").click(function(){
  			RapidNewWin();
		});	
		
		
	$("#BDelete").click(function(){
  			Delete_click();
		});	
	
	$("#PAPMINo").change(function(){
  			RegNoOnChange();
		});
		
	$("#PAPMINo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        });
        
    $("#CardNo").change(function(){
  			CardNoOnChange();
		});
		
	$("#CardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				CardNoOnChange();
			}
			
        });    
        
	$("#RegNo").change(function(){
  			PRegNoOnChange();
		});
		
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				
				PRegNoOnChange();
			}
			
        });

	$("#PCardNo").change(function(){
  			PCardNoOnChange();
		});
		
	$("#PCardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				PCardNoOnChange();
			}
			
        });

   	
	setValueById("ID",GroupID);
    setValueById("PGADM_RowId",GroupID)
	setValueById("DietFlag",DietFlag);
	setValueById("GiftFlag",GiftFlag);
	
	
	
	var TeamPEDeskClerkNameObj = $HUI.combogrid("#TeamPEDeskClerkName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
		mode:'remote',
		delay:200,
		idField:'HIDDEN',
		textField:'姓名',
		onBeforeLoad:function(param){
			
			param.Desc = param.q;
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'工号',title:'工号',width:100},
			{field:'姓名',title:'姓名',width:200}
			
			
			
		]]
	});
	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onSelect:function(record){
			
			VIPLevelOnChange(record.id);
		}
	});
	
	var RapidVIPObj = $HUI.combobox("#RapidVIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onSelect:function(record){
			
		}
	});
	
	var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP");
	
	$('#VIPLevel').combobox('setValue',VIPNV);
	$('#RapidVIPLevel').combobox('setValue',VIPNV);
	
	var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		mode:'remote',
		
		onBeforeLoad:function(param){
			var VIP=$("#VIPLevel").combobox("getValue");
			param.VIPLevel = VIP;
			param.GIType = "G";
		}
		})
	$('#RoomPlace').combobox('reload');
	var TempSetObj = $HUI.datagrid("#TempSet",{
		
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreGTeam",
			QueryName:"GetGTeamTempSet",
			VIP:"",
			ToGID:"",
			GBID:"",
			TemplateFlag:"1"
		},
		fitColumns:true,
 		columns:[[
			{field:'TID',title:'操作',
			formatter:function(value,row,index){
					return "<a href='#' onclick='DelGTeamTemp(\""+row.TID+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
					</a>";
			}},
			{field:'TAgeFrom',title:'年龄上限'},
			{field:'TAgeTo',title:'年龄下限'},
			{field:'TSex',hidden:true},
			{field:'THouse',hidden:true},
			{field:'TDesc',title:'分组名称'},
			{field:'TSexDesc',title:'性别'},
			{field:'THouseDesc',title:'婚姻'}
					
		]],
		onClickRow:function(rowIndex,rowData){
			
			setValueById("TeamDesc",rowData.TDesc)
			setValueById("UpperLimit",rowData.TAgeFrom)
			setValueById("LowerLimit",rowData.TAgeTo)
			SexDesc=rowData.TSexDesc
			if(SexDesc=="男"){
				$HUI.radio("#TeamSexM").setValue(true);
			}else if(SexDesc=="女"){
				$HUI.radio("#TeamSexF").setValue(true);
			}else{
				$HUI.radio("#TeamSexN").setValue(true);
			}
			MarryDesc=rowData.THouseDesc
			if(MarryDesc=="未婚"){
				$HUI.radio("#TeamMarriedUM").setValue(true);
			}else if(MarryDesc=="已婚"){
				$HUI.radio("#TeamMarriedM").setValue(true);
			}else{
				$HUI.radio("#TeamMarriedN").setValue(true);
			}
			
	        
		},
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		
	});
	
	var TeamPersonGridObj = $HUI.datagrid("#TeamPersonGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreIADM",
			QueryName:"SearchGTeamIADM",
			GTeam:"",
			RegNo:"",
			Name:"",
			DepartName:"",
			OperType:"",
			Status:""

		},
		onClickRow:function(rowIndex,rowData){
			
			//setValueById("PIADM_RowId",rowData.PIADM_RowId)
			//$("#PNewItem").linkbutton('enable');
			//$("#BAddItem").linkbutton('enable');
		},
		onCheck:function(rowIndex,rowData){
			
			setValueById("PIADM_RowId",rowData.PIADM_RowId);
			$("#PNewItem").linkbutton('enable');
			$("#BAddItem").linkbutton('enable'); 
	
		},
		onUncheck:function(rowIndex,rowData){
			setValueById("PIADM_RowId","");
			$("#PNewItem").linkbutton('disable');
			$("#BAddItem").linkbutton('disable');
			
		},
		
		fitColumns:true,
		checkOnSelect:true,
		selectOnCheck:true,
 		columns:[[
			{field:'Sequence',title:'序号',checkbox:true},
			
			{field:'PIADM_PIBI_DR',title:'预约修改',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='GIAdmEdit(\""+row.PIADM_RowId+"^"+row.PIADM_PIBI_DR_RegNo+"^"+row.PIADM_PIBI_DR_Name+"^"+row.PIADM_PEDateBegin+"^"+row.PIADM_PETime+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>";
			}},
			
			{field:'PIADM_RowId',title:'查询项目',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='CheckItem(\""+row.PIADM_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
					</a>";
			}},
			{field:'BaseInfo',title:'基本信息',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='BaseInfo(\""+index+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add_note.png' border=0/>\
					</a>";
					/*return "<a href='#' onclick='BaseInfo(\""+row.PIADM_PIBI_DR+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add_note.png' border=0/>\
					</a>";
					*/
			}},
			{field:'PIADM_PGADM_DR',hidden:true},
			{field:'Amount',title:'金额'},
			{field:'PIADM_PIBI_DR_RegNo',title:'登记号'},
			{field:'PIADM_PIBI_DR_Name',title:'姓名'},
			{field:'PIADM_PGADM_DR',hidden:true},
			{field:'PIADM_PGADM_DR_Name',hidden:true},
			{field:'PIADM_PGTeam_DR',hidden:true},
			{field:'PIADM_PGTeam_DR_Name',hidden:true},
			{field:'PIADM_PEDateBegin',title:'体检日期'},
			{field:'PIADM_PEDateEnd',title:'截至日期'},
			{field:'PIADM_PETime',hidden:true},
			{field:'PIADM_PEDeskClerk_DR',hidden:true},
			{field:'PIADM_PEDeskClerk_DR_Name',title:'接待人'},
			{field:'PIADM_Status',hidden:true},
			{field:'PIADM_Status_Desc',title:'状态'},
			{field:'PIADM_AsCharged',hidden:true},
			{field:'PIADM_AccountAmount',hidden:true},
			{field:'PIADM_DiscountedAmount',hidden:true},
			{field:'PIADM_SaleAmount',hidden:true},
			{field:'PIADM_FactAmount',hidden:true},
			{field:'PIADM_AuditUser_DR',hidden:true},
			{field:'PIADM_AuditUser_DR_Name',hidden:true},
			{field:'PIADM_AuditDate',hidden:true},
			{field:'PIADM_UpdateUser_DR',hidden:true},
			{field:'PIADM_UpdateUser_DR_Name',hidden:true},
			{field:'PIADM_UpdateDate',hidden:true},
			{field:'PIADM_ChargedStatus',hidden:true},
			{field:'PIADM_ChargedStatus_Desc',hidden:true},
			{field:'PIADM_CheckedStatus',hidden:true},
			{field:'PIADM_CheckedStatus_Desc',hidden:true},
			{field:'PIADM_AddOrdItem',title:'公费加项'},
			{field:'PIADM_AddOrdItemLimit',hidden:true},
			{field:'PIADM_AddOrdItemAmount',hidden:true},
			{field:'PIADM_AddPhcItem',title:'加药'},
			{field:'PIADM_AddPhcItemLimit',hidden:true},
			{field:'PIADM_AddPhcItemAmount',hidden:true},
			{field:'PIADM_IReportSend',hidden:true},
			{field:'PIADM_IReportSend_Desc',hidden:true},
			{field:'PIADM_DisChargedMode',hidden:true},
			{field:'PIADM_DisChargedMode_Desc',title:'结算方式'},
			{field:'PIADM_VIP',hidden:true},
			{field:'PIADMRemark',hidden:true},
			{field:'TArriveDate',title:'到达时间'},
			{field:'TType',title:'职务'},
			{field:'TNewHPNo',title:'体检号'},
			{field:'PACCardDesc',title:'证件类型'},
			{field:'IDCard',title:'证件号'},
			{field:'TPosition',title:'部门',
			formatter:function(value,row,index){
					return tkMakeServerCall("web.DHCPE.PreCommon","GetPosition","PreADM",row.PIADM_RowId);
			}},
			{field:'TRoomPlace',title:'诊室位置',
			formatter:function(value,row,index){
					return tkMakeServerCall("web.DHCPE.PreCommon","GetRoomPlace","PreADM",row.PIADM_RowId);
			},styler: function(value,row,index){
				
					return 'border-right:0;';
				}
			}
			
		]],
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		});
	
    var TeamGridObj = $HUI.datagrid("#TeamGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreGTeam",
			QueryName:"SearchGTeam",
			ParRef:GroupID

		},
		onClickRow:function(rowIndex,rowData){
			setValueById("PGTRowId",rowData.PGT_RowId)
			setValueById("PGTChildSub",rowData.PGT_ChildSub)
			$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:rowData.PGT_RowId,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
			$("#BCopyTeam").linkbutton('enable');
			$("#BDelete").linkbutton('enable');	
			$("#BNewItem").linkbutton('enable');
		var flag=tkMakeServerCall("web.DHCPE.PreGADM","IsRegister",rowData.PGT_RowId);
		if(flag==0){
			$("#BRegister").linkbutton('disable');
		}else{
			$("#BRegister").linkbutton('enable');
		}
		
		
		},
		fitColumns:true,
		columns:[[
			{field:'GroupID',title:'团体ID',hidden:true},
			{field:'PGT_RowId',title:'分组ID',hidden:true},
			{field:'PGT_ChildSub',title:'操作',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='PreTeamEdit(\""+row.PGT_ChildSub+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>";
			}},
			{field:'PGT_ParRef_Name',title:'团体名称',hidden:true},
			{field:'PGT_Desc',title:'分组名称'},
			{field:'teamcheckitem',title:'查询项目',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='CheckTeamItem(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
					</a>";
			}},
			{field:'PGTSex',title:'Sex',hidden:true},
			{field:'PGT_Sex_Desc',title:'性别'},
			{field:'PGT_UpperLimit',title:'年龄上限'},
			{field:'PGT_LowerLimit',title:'年龄下限'},
			{field:'PGTMarried',title:'Married',hidden:true},
			{field:'PGT_Married_Desc',title:'婚姻'},
			{field:'PGTUpdateUserDR',title:'UserID',hidden:true},
			{field:'PGT_UpdateUser_DR_Name',title:'更新人',hidden:true},
			{field:'PGT_UpdateDate',title:'更新时间',hidden:true},
			{field:'PGT_AddOrdItem',title:'公费加项'},
			{field:'PGT_AddOrdItemLimit',title:'加项金额限制',hidden:true},
			{field:'PGT_AddOrdItemAmount',title:'加项金额',hidden:true},
			{field:'PGT_AddPhcItem',title:'允许加药'},
			{field:'PGT_AddPhcItemLimit',title:'开药金额限制',hidden:true},
			{field:'PGT_AddPhcItemAmount',title:'开药金额',hidden:true},
			{field:'PGTGReportSend',title:'GSend',hidden:true},
			{field:'PGT_GReportSend_Name',title:'团体报告发送',hidden:true},
			{field:'PGTIReportSend',title:'ISend',hidden:true},
			{field:'PGT_IReportSend_Name',title:'个人报告发送',hidden:true},
			{field:'PGTDisChargedMode',title:'Mode',hidden:true},
			{field:'PGT_DisChargedMode_Name',title:'结算方式'},
			{field:'PGT_BookDateBegin',title:'预约开始日期'},
			{field:'PGT_BookDateEnd',title:'预约截止日期'},
			{field:'PGT_BookTime',title:'预约时间',hidden:true},
			{field:'PGTPEDeskClerkDR',title:'PEDeskClerk',hidden:true},
			{field:'PGT_PEDeskClerk_DR_Name',title:'接待人',hidden:true},
			{field:'TTotalPerson',title:'人数'},
			{field:'THadChecked',title:'已检名单',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='HadCheckedList(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
					</a>";
			}},
			{field:'TNoCheckDetail',title:'未检名单',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='NoCheckedList(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
					</a>";
			}},
			{field:'TCancelPEDetail',title:'取消体检名单',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='CancelPEList(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
					</a>";
			}},

			{field:'TRoomPlace',title:'诊室位置',
			formatter:function(value,row,index){
					return tkMakeServerCall("web.DHCPE.PreCommon","GetRoomPlace","PGTADM",row.PGT_RowId);
			}}
			
		]],
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		});
	
	var GroupDescObj = $HUI.combogrid("#GroupDesc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode:'remote',
		delay:200,
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			
		},
		onSelect:function(rowIndex, rowData){
			
			setValueById("GroupCode",rowData.GBI_Code)
			ID="^"+rowData.GBI_Code
			
			GroupDescSelect(ID)
			 
    		},
		columns:[[
			{field:'GBI_RowId',hidden:true},
			{field:'GBI_Code',title:'团体编码',width:100},
			{field:'GBI_Desc',title:'团体名称',width:200}
			
			
			
		]]
	});
	var PatFeeTypeNameObj = $HUI.combobox("#PatFeeTypeName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
		valueField:'id',
		textField:'Desc'
	});
	
	
	var DepartNameObj = $HUI.combobox("#DepartName",{
		url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGDepart&ResultSetType=array",
		valueField:'DepartName',
		textField:'DepartName',
		onBeforeLoad:function(param){
			param.GID=getValueById("ID");
			param.TeamID="";
			param.Type="PGADM";
			param.Depart=param.q;
		}
	});
	
	var PatNameObj = $HUI.combogrid("#PatName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIBaseInfo&QueryName=PreIBaseInfoList",
		mode:'remote',
		delay:200,
		idField:'编码',
		textField:'姓名',
		onBeforeLoad:function(param){
			param.Name = param.q;
		},
		onClickRow:function(rowIndex,rowData){
			
	
			setValueById("RegNo",rowData.登记号)
			setValueById("PIBI_RowId",rowData.编码)
			$("#BNewIADM").linkbutton('enable');
		
		},
		columns:[[
			{field:'编码',title:'编码',width:80},
			{field:'登记号',title:'登记号',width:100},
			{field:'姓名',title:'姓名',width:120}
			
			
			
		]]
	});
	
	
	var RapidPatFeeTypeNameObj = $HUI.combobox("#RapidPatFeeTypeName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
		valueField:'id',
		textField:'Desc'
	});

   
	var TeamOMETypeObj = $HUI.combobox("#OMEType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOMEType&ResultSetType=array",
		valueField:'id',
		textField:'Desc',
		onBeforeLoad: function(param){
			param.VIPLevel=$("#VIPLevel").combobox('getValue'); 
	 	}	
	});
	
	var HarmInfoObj = $HUI.combotree("#HarmInfo",{
			
			url:$URL+"?ClassName=web.DHCPE.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array",
			checkbox:true,
			multiple:true,
			onlyLeafCheck:true
			
		});


	var TeamPatFeeTypeNameObj = $HUI.combobox("#TeamPatFeeTypeName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
		valueField:'id',
		textField:'Desc'
	});
	
	var SalesObj = $HUI.combogrid("#Sales",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
		mode:'remote',
		delay:200,
		idField:'HIDDEN',
		textField:'姓名',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'工号',title:'工号',width:100},
			{field:'姓名',title:'姓名',width:200}
			
			
			
		]]
	});
	
	
	var PEDeskClerkNameObj = $HUI.combogrid("#PEDeskClerkName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
		mode:'remote',
		delay:200,
		idField:'HIDDEN',
		textField:'姓名',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'工号',title:'工号',width:100},
			{field:'姓名',title:'姓名',width:200}
			
			
			
		]]
	});
	
	
	
	var ContractObj = $HUI.combogrid("#Contract",{
		panelWidth:600,
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TName',
		onBeforeLoad:function(param){
			param.Contract = param.q;
		},
		
		columns:[[
			{field:'TID',hidden:true},
			{field:'TNo',title:'合同编号',width:100},
			{field:'TName',title:'合同名称',width:100},
			{field:'TSignDate',title:'签订日期',width:100},
			{field:'TRemark',title:'备注',width:100},
			{field:'TCreateDate',title:'录入日期',width:100},
			{field:'TCreateUser',title:'录入人',width:100}
		]]
	});
	
	
	var obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
			var ret=tkMakeServerCall("web.DHCPE.PreGADM","DocListBroker","","",obj.value+"^");
			
			SetPatient_Sel(ret);
		
	}
}

function CardNoOnChange()
{
	
	CardNoChangeAppHISUI("PAPMINo","CardNo","RegNoOnChange()","Clear_click()","0");
	
}
function CardNoChangeAppHISUI(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
	
	var obj;
	var CardNo="",SelectCardTypeRowID="";
	obj=document.getElementById(CardElement);
	if (obj) CardNo=obj.value;
	if (CardNo=="") return;
	if (ClearFlag=="1") eval(AppFunctionClear);
	obj.value=CardNo;
	
	var SelValue=$HUI.combobox("#CardType").getValue();
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	SelectCardTypeRowID=myCardTypeDR;
	
	CardNo=CardNo+"$"+SelectCardTypeRowID;
	
	RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
	
	if (RegNo=="") {
		$.messager.alert("提示","未找到记录","info");
		return;
	}

	obj=document.getElementById(RegNoElement);
	if (obj)
	{
		obj.value=RegNo;
		eval(AppFunction);
	}
}

function LoadCard()
{
	var HospID=session['LOGON.HOSPID']
	$.m({
			ClassName:"web.UDHCOPOtherLB",
			MethodName:"ReadCardTypeDefineListBroker",
			JSFunName:"GetCardTypeToHUIJson",
			ListName:"",
			SessionStr:"^^^^"+HospID
		},function(val){
			
			var ComboJson=JSON.parse(val); 
			
			$HUI.combobox('#CardType',{
				data:ComboJson,
				valueField:'id',    
				textField:'text',
			onSelect:function(record){
				CardTypeKeydownHandlerG();
			}
		});
		CardTypeKeydownHandlerG();
		});
		
	$.m({
			ClassName:"web.UDHCOPOtherLB",
			MethodName:"ReadCardTypeDefineListBroker",
			JSFunName:"GetCardTypeToHUIJson",
			ListName:"",
			SessionStr:"^^^^"+HospID
		},function(val){
			
			var ComboJson=JSON.parse(val); 
			
			$HUI.combobox('#PCardType',{
				data:ComboJson,
				valueField:'id',    
				textField:'text',
			onSelect:function(record){
				CardTypeKeydownHandler();
			}
		});
		CardTypeKeydownHandler();
		});	
		
	
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function GetCardEqRowIdA(){
	var CardEqRowId="";
	var CardTypeValue=$HUI.combobox("#PCardType").getValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}

function CardTypeKeydownHandler(){
	var SelValue=$HUI.combobox("#PCardType").getValue();
	
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	if (myary[16]=="Handle"){;
		$("#PCardNo").attr("disabled",false);
		DisableBtn("PReadCard",true);
		$("#PCardNo").focus();
	}else{
		$("#PCardNo").attr("disabled",true);
		DisableBtn("PReadCard",false);
		$("#PReadCard").focus();
		
		m_CCMRowID=GetCardEqRowIdA();
		var myobj=document.getElementById("PCardNo");
		
		if (myobj){myobj.readOnly = false;} 
		var obj=document.getElementById("PReadCard");
		if (obj){
			obj.disabled = false;
			
		}
		DHCWeb_setfocus("PReadCard");
	}
}
function GetCardEqRowIdG(){
	var CardEqRowId="";
	var CardTypeValue=$HUI.combobox("#CardType").getValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}

function CardTypeKeydownHandlerG(){
	var SelValue=$HUI.combobox("#CardType").getValue();
	
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	if (myary[16]=="Handle"){;
		$("#CardNo").attr("disabled",false);
		DisableBtn("ReadCard",true);
		$("#CardNo").focus();
	}else{
		$("#CardNo").attr("disabled",true);
		DisableBtn("ReadCard",false);
		$("#ReadCard").focus();
		
		m_CCMRowID=GetCardEqRowIdG();
		var myobj=document.getElementById("CardNo");
		
		if (myobj){myobj.readOnly = false;} 
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled = false;
			
		}
		DHCWeb_setfocus("ReadCard");
	}
}

function PCardNoOnChange()
{
	
	PCardNoChangeAppHISUI("RegNo","PCardNo","PRegNoOnChange()","","");
	
}

function PCardNoChangeAppHISUI(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
	var obj;
	var CardNo="",SelectCardTypeRowID="";
	obj=document.getElementById(CardElement);
	if (obj) CardNo=obj.value;
	if (CardNo=="") return;
	if (ClearFlag=="1") eval(AppFunctionClear);
	
	obj.value=CardNo;
	
	var SelValue=$HUI.combobox("#PCardType").getValue();
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	SelectCardTypeRowID=myCardTypeDR;
	
	CardNo=CardNo+"$"+SelectCardTypeRowID;
	
	RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
	
	if (RegNo=="") return;
	obj=document.getElementById(RegNoElement);
	if (obj)
	{
		obj.value=RegNo;
		eval(AppFunction);
	}
}

function PSetPatient_Sel(value) {

	var obj;
	var Data=value.split("^");
	var iLLoop=0;
	
	iRowId=Data[iLLoop];
	iLLoop=iLLoop+1;
	
	if ("0"==iRowId){
		//	PIBI_PAPMINo	登记号	1
		setValueById("PIBI_RowId","")
		setValueById("RegNo","")
		
		alert("无效登记号!");
		
		return false;
	};
	
	setValueById("PIBI_RowId",Data[0])
	setValueById("RegNo",Data[1])
	setValueById("PatName",Data[2])		
	setValueById("PCardNo",Data[32])	
	
	$("#BNewIADM").linkbutton('enable');
	
	
	
}

function FindPatDetailTeam(ID){
	var Instring=ID;
	
	var SelValue=$HUI.combobox("#PCardType").getValue();
	
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	
	var flag=tkMakeServerCall("web.DHCPE.PreIBaseInfo","DocListBroker",'','',Instring+"$"+myCardTypeDR);
	PSetPatient_Sel(flag)

}

function PRegNoOnChange()
{
		var obj;
		
		var iRegNo=getValueById("RegNo");
		iRegNo = RegNoMask(iRegNo);
		
		
		var IBaseInfoID=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetIBaseInfoIDByADM",iRegNo);
		
		if (IBaseInfoID==""){
				setValueById("RegNo","")
				setValueById("PCardNo","")
				setValueById("PatName","")
				 $.messager.popover({msg: "无效客户信息", type: "info"});
				//alert("无效客户信息");
				return false;
		
		}
		iRegNo="^"+iRegNo+"^";
		
		FindPatDetailTeam(iRegNo);
	
	
}

function RegNoOnChange() {
	
		
		var iPAPMINo=getValueById("PAPMINo");
		if(iPAPMINo=="")
		{
			return false;
		}
		iPAPMINo = RegNoMask(iPAPMINo);
		
		setValueById("PAPMINo",iPAPMINo)
		
		var GCode=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetGCodeByADM",iPAPMINo);
		
		if (GCode=="") {
			$.messager.alert("提示", "该人员属于个人，请在个人预约界面操作！", "info")
			Clear_click();
		
			return false;
		}
		
		ID="^"+GCode;
		
		FindPatDetail(ID);	
		
}


function Delete_click() {
     
	var iRowId="";
	iRowId=getValueById("PGTRowId")
	var iParRef=getValueById("ID")
	if (iRowId=="")	{
		$.messager.alert("提示","请先选择分组记录","info"); 
		return false;
	} 
	else{
		$.messager.confirm("确认", "是否确定删除该分组", function(r){
		if (r){
		
			var flag=tkMakeServerCall("web.DHCPE.PreGTeam","Delete",'','',iRowId);
			
			if (flag=='0') {
				$("#PGTRowId").val("");
				$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
				$("#BCopyTeam").linkbutton('disable');
				$("#BDelete").linkbutton('disable');	
				$("#BNewItem").linkbutton('disable');
				}
			else{
				var Errs=flag.split("^");
				
				//删除团体组所属人员时发生错误
				if ("IADM Err"==Errs[0]) {
					$.messager.alert("提示","人员登记记录删除错误："+Errs[1],"info"); 
					
				}
				
				//删除团体组时发生错误
				if ("GTeam Err"==Errs[0]) {
					$.messager.alert("提示","团体组记录删除错误："+Errs[1],"info"); 
					
				}
				
				if ("2"==Errs[0]) {
					$.messager.alert("提示","团体中已有人员","info"); 
					
				}
				
				return false;
			}

		}
		});
	}
}

function GroupDescSelect(ID)
{
	
	FindPatDetailSelect(ID)
}
function FindPatDetailSelect(ID){

	var Instring=ID;

	var flag=tkMakeServerCall("web.DHCPE.PreGADM","DocListBroker","","",Instring);
	
	SetPatient_SelSelect(flag);
}
function FindPatDetail(ID){

	var Instring=ID;

	var flag=tkMakeServerCall("web.DHCPE.PreGADM","DocListBroker","","",Instring);
	
	SetPatient_Sel(flag);
}
function SetPatient_SelSelect(value) {
	

	var obj;
	var Data=value.split(";");
	
	var IsShowAlert=Data[2];
	
	if ("Y"==IsShowAlert) {
		
		$.messager.confirm("确认", "此团体已有预约，是否再次预约？", function(data){	
		if (data) {
		}
		else{
				Clear_click();
			
			}
		}
			
		);
	}
	//登记信息
	var PreGADMData=Data[1];
	if (""!=PreGADMData) { SetPreGADM(PreGADMData); }
	
	//团体信息
	var PreGBaseGnfoData=Data[0];
	
	if (""!=PreGBaseGnfoData) { SetPreGBaseInfoSelect(PreGBaseGnfoData) }

		
}


function SetPatient_Sel(value) {
	
	
	//Clear_click();

	var obj;
	var Data=value.split(";");
	
	var IsShowAlert=Data[2];
	
	if ("Y"==IsShowAlert) {
		
		
		
		$.messager.confirm("确认", "此团体已有预约，是否再次预约？", function(data){	
		if (data) {
		}
		else{
				Clear_click();
			
			}
		}
			
		);
		
		
	}
	
	//登记信息
	var PreGADMData=Data[1];
	if ((""!=PreGADMData)&&(PreGADMData.split("^")[0]!=0)) { SetPreGADM(PreGADMData); }
	
	//团体信息
	var PreGBaseGnfoData=Data[0];
	
	if ((""!=PreGBaseGnfoData)&&(PreGBaseGnfoData.split("^")[0]!=0)) { SetPreGBaseInfo(PreGBaseGnfoData) }

		
}
//登记信息
function SetPreGADM(value) {
	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	var CurDate="",GReportSend="AC",IReportSend="IS"
	
	CurDate=tkMakeServerCall("web.DHCPE.PreGADM","GetDefaultDate");
	
	setValueById("BookDateBegin",CurDate)
	setValueById("BookDateEnd",CurDate)
	
	setValueById("GReportSend",GReportSend)
	setValueById("IReportSend",IReportSend)
	
	
	//视同收费 PIADM_AsCharged
	
	if (Default)
	{
		if ((Default=="2")||(Default=="3")){setValueById("AsCharged",true)}
		else{
			setValueById("AsCharged",false)
			}
			
		
	}
		
	
	if ('0'==iRowId) { return true; }
	
	
	//团体ADM 0
	setValueById("PGADM_RowId",iRowId)

	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_PGBI_DR	预团体客户RowId 2
	setValueById("PGBI_RowId",fillData)

	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	预约日期 4
	setValueById("BookDateBegin",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookDateEnd 29
	setValueById("BookDateEnd",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookTime	预约时间 5
	setValueById("BookTime",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	预约接待人员 16
	//setValueById("PEDeskClerkName",fillData)
	$("#PEDeskClerkNameID").val(fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	$("#PEDeskClerkName").combogrid('setValue',fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Status	状态 8
	setValueById("Status",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
		
	// PGADM_AsCharged	视同收费 3
	
	
	if (fillData=="Y"){setValueById("AsCharged",true);
		}
	else{setValueById("AsCharged",false);
		}
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	var strLine=""
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	strLine=strLine+fillData+"^"; 
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	SetAddItem(strLine);
	
	// PGADM_GReportSend 团体报告发送 26
	setValueById("GReportSend",fillData);
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend 个人报告发送 27
	setValueById("IReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode 结算方式 28
	setValueById("DisChargedMode",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_DelayDate
	setValueById("DelayDate",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Remark	备注 6
	setValueById("Remark",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	setValueById("PAPMINo",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
	// PGADM_PEDeskClerk_DR 预约接待人员 15
	setValueById("Sales",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 31
	setValueById("Type",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 32
	setValueById("GetReportDate",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 33
	setValueById("GetReportTime",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 33
	setValueById("PayType",fillData)
	
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	业务员 33
	setValueById("Percent",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	就诊类别 用于取计费价格
	setValueById("PatFeeTypeName",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	合同ID
	setValueById("Contract",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	合同名称
	return true;
		

}
function SetTeamAddItem(value) {
	var Data=value.split("^");
	var iLLoop=0;	

	if ("Y"==Data[iLLoop]) {
		setValueById("TeamAddOrdItem",true);	
	}
	else { 
	
		$("#TeamAddOrdItemLimit").checkbox("disable");
		$("#TeamAddOrdItemAmount").attr('disabled',true);
	}
	
	iLLoop=iLLoop+1;		
	if ("Y"==Data[iLLoop]) {
		setValueById("TeamAddOrdItemLimit",true);
		setValueById("TeamAddOrdItemAmount",Data[iLLoop+1])
		$("#TeamAddOrdItemAmount").attr('disabled',false);	
	}
	else { 
		setValueById("TeamAddOrdItemLimit",false);
		setValueById("TeamAddOrdItemAmount",Data[iLLoop+1])
		$("#TeamAddOrdItemAmount").attr('disabled',true);
		
	}
	
	iLLoop=iLLoop+1;	
	iLLoop=iLLoop+1;	
	//	允许加药	
	if ("Y"==Data[iLLoop]) {
		setValueById("TeamAddPhcItem",true);
	}
	
	
	iLLoop=iLLoop+1;	
	
	
}
function SetAddItem(value) {
	
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	
	//	允许加项	PGADM_AddOrdItem	19
	obj=document.getElementById("AddOrdItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			setValueById("AddOrdItem",true)
			iAddOrdItem=true;
			
		}
		else { 
			setValueById("AddOrdItem",false)
			iAddOrdItem=false;
		}
				
	}
	iLLoop=iLLoop+1;	
	
	var iAddOrdItemLimit=false;
	//	加项金额限制	PGADM_AddOrdItemLimit	20
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) { 
		if (iAddOrdItem) {
			obj.disabled=false;
			if ("Y"==Data[iLLoop]) {
				setValueById("AddOrdItemLimit",true)
				iAddOrdItemLimit=true;
			}
			else {
				obj.checked=false;
				iAddOrdItemLimit=false;
			}
			
		}
		else {
			obj.disabled=true;
			
			obj.checked=false;
			iAddOrdItemLimit=false;
							
		}
	}
	iLLoop=iLLoop+1;	
	
	//	允许加项金额	PGADM_AddOrdItemAmount	21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) {
		if (iAddOrdItemLimit) {
			obj.disabled=false;
			setValueById("AddOrdItemAmount",Data[iLLoop])
		}
		else{
			obj.disabled=true;
			
			obj.value="";
		}
		
	}
	iLLoop=iLLoop+1;	
	
	//	允许加药	PGADM_AddPhcItem	22
	var iAddPhcItem=false;
	obj=document.getElementById("AddPhcItem");
	if (obj) {
		if ("Y"==Data[iLLoop]) {
			setValueById("AddPhcItem",true)
			iAddPhcItem=true;
		}
		else {
			setValueById("AddPhcItem",false)
			iAddPhcItem=false
		}

	}
	iLLoop=iLLoop+1;	
	
	
}

function SetPreGBaseInfoSelect(value) {

	var obj;
	
	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	
	
	iLLoop=iLLoop+1;
	if ("0"==iRowId) {
	

		//单位编码	PGBI_Code	1
		
		setValueById("GroupCode",Data[iLLoop])
		iLLoop=iLLoop+1;
		//描    述	PGBI_Desc	2
		$("#GroupDesc").combogrid("setText",Data[iLLoop])
	
		return false;
	}

	
	setValueById("PGBI_RowId",iRowId)
	//单位编码	PGBI_Code	1
	setValueById("GroupCode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	
	
	iLLoop=iLLoop+1;
	//地    址	PGBI_Address	3
	setValueById("Address",Data[iLLoop])

	iLLoop=iLLoop+1;
	//邮政编码	PGBI_Postalcode	4
	setValueById("Postalcode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//联系人	PGBI_Linkman	5
	setValueById("Linkman",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//业务银行	PGBI_Bank	6
	setValueById("Bank",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//帐    号	PGBI_Account	7
	setValueById("Account",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//联系电话1	PGBI_Tel1	8
	setValueById("Tel1",Data[iLLoop])

	iLLoop=iLLoop+1;
	//联系电话2	PGBI_Tel2	9
	setValueById("Tel2",Data[iLLoop])

	iLLoop=iLLoop+1;
	//电子邮件	PGBI_Email	10
	setValueById("Email",Data[iLLoop])
	
	iLLoop=iLLoop+3;
	//电子邮件	PGBI_PAPMINo	10
	setValueById("PAPMINo",Data[iLLoop])
	iLLoop=iLLoop+2;
	//	CardNo	10
	setValueById("CardNo",Data[iLLoop])
	
	return true;
	
	
	
	
}

//团体信息
function SetPreGBaseInfo(value) {

	var obj;
	
	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	
	
	iLLoop=iLLoop+1;
	if ("0"==iRowId) {
	

		//单位编码	PGBI_Code	1
		
		setValueById("GroupCode",Data[iLLoop])
		iLLoop=iLLoop+1;
		//描    述	PGBI_Desc	2
		$("#GroupDesc").combogrid("setText",Data[iLLoop])
	
		return false;
	}

		
	setValueById("PGBI_RowId",iRowId)
	//单位编码	PGBI_Code	1
	setValueById("GroupCode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//描    述	PGBI_Desc	2
	setValueById("GroupDesc",iRowId)
	//$("#GroupDesc").combogrid("setText",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//地    址	PGBI_Address	3
	setValueById("Address",Data[iLLoop])

	iLLoop=iLLoop+1;
	//邮政编码	PGBI_Postalcode	4
	setValueById("Postalcode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//联系人	PGBI_Linkman	5
	setValueById("Linkman",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//业务银行	PGBI_Bank	6
	setValueById("Bank",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//帐    号	PGBI_Account	7
	setValueById("Account",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//联系电话1	PGBI_Tel1	8
	setValueById("Tel1",Data[iLLoop])

	iLLoop=iLLoop+1;
	//联系电话2	PGBI_Tel2	9
	setValueById("Tel2",Data[iLLoop])

	iLLoop=iLLoop+1;
	//电子邮件	PGBI_Email	10
	setValueById("Email",Data[iLLoop])
	
	iLLoop=iLLoop+3;
	//电子邮件	PGBI_PAPMINo	10
	setValueById("PAPMINo",Data[iLLoop])
	iLLoop=iLLoop+2;
	//	CardNo	10
	setValueById("CardNo",Data[iLLoop])
	
	return true;
		
	
}


function Update() {
	var iRowId="";
	var iPGBIDR="", iAsCharged="", iBookDateBegin="", iBookDateEnd="", iBookTime="", iRemark="", 
		iContractNo="", iStatus="",
		iAccountAmount="", iDiscountedAmount="", iFactAmount="",
		iAuditUserDR="", iAuditDate="", 
		iUpdateUserDR="", iUpdateDate="", 
		iPEDeskClerkDR="", iSaleAmount="",
		iChargedStatus="", iChargedStatusDesc="", 
		iCheckedStatus="", iCheckedStatusDesc="", 
		iAddOrdItem="", iAddOrdItemLimit="", iAddOrdItemAmount="", 
		iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
		iGReportSend="", iGReportSendDesc="", 
		iIReportSend="", iIReportSendDesc="",
		iDisChargedMode="", iDisChargedModeDesc="",iDelayDate="",Sales="",
		Type="",GetReportDate="",GetReportTime="",PayType="",Percent=""
		DietFlag="1",GiftFlag="0",PatFeeType="",Contract="";
	    var obj;
	
	// PGADM_RowId	团体ADM 1
	
	
	iRowId=getValueById("PGADM_RowId")
	if(iRowId=="0") {var iRowId="";}
	
	// PGADM_PGBI_DR	预团体客户RowId 2
	iPGBIDR=getValueById("PGBI_RowId")
	
	
	if (($("#GroupDesc").combogrid('getValue'))==($("#GroupDesc").combogrid('getText'))||(($("#GroupDesc").combogrid('getText')=="")))  {
		$.messager.alert("提示","团体名称选择不正确！","info");
		return false;
	}
	
	
	// PGADM_BookDateBegin	预约日期 4
	iBookDateBegin=getValueById("BookDateBegin")
	

	// PGADM_BookDateEnd 29
	iBookDateEnd=getValueById("BookDateEnd")
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat");
	 if (dtformat=="YMD"){
		  var BeginYear=iBookDateBegin.split("-")[0];
		  var EndYear=iBookDateEnd.split("-")[0];
	  }
	  if (dtformat=="DMY"){
		 var BeginYear=iBookDateBegin.split("/")[2];
		 var EndYear=iBookDateEnd.split("/")[2];
	  }
	  
	if(BeginYear<1840){
		$.messager.alert('提示','体检起始日期不能小于1840年!',"info"); 
		return false;
	}
	if(EndYear<1840){
		$.messager.alert('提示','截止日期不能小于1840年!',"info"); 
		return false;
	}
	// PGADM_BookTime	预约时间 5
	iBookTime=getValueById("BookTime")
	
	// PGADM_AuditUser_DR	预约接待人员 16
	iPEDeskClerkDR=$("#PEDeskClerkName").combogrid("getValue")
	if (($("#PEDeskClerkName").combogrid('getValue')==undefined)||($("#PEDeskClerkName").combogrid('getText')=="")){var iPEDeskClerkDR="";}
	/*if(iPEDeskClerkDR!="")
	{
	if (($("#PEDeskClerkName").combogrid('getValue'))==($("#PEDeskClerkName").combogrid('getText')))  {
		$.messager.alert("提示","接待人选择不正确！","info");
		return false;
	}
	}
	*/
	   var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(iPEDeskClerkDR)))&&(iPEDeskClerkDR!="")){var iPEDeskClerkDR=$("#PEDeskClerkNameID").val();}

   
	// PGADM_Status	状态 8
	iStatus=getValueById("Status")
	
		
	// PGADM_AsCharged	视同收费 3
	iAsCharged=getValueById("AsCharged")
	if (iAsCharged) { iAsCharged="Y"; }
	else { iAsCharged="N"; }
	// PGADM_AddOrdItem 允许加项 20
	iAddOrdItem=getValueById("AddOrdItem")
	if (iAddOrdItem) { iAddOrdItem='Y'; }
	else { iAddOrdItem='N';}
	
	// PGADM_AddOrdItemLimit 加项金额限制 21
	iAddOrdItemLimit=getValueById("AddOrdItemLimit")
	if (iAddOrdItemLimit) { iAddOrdItemLimit='Y'; }
	else { iAddOrdItemLimit='N';}
	// PGADM_AddOrdItemAmount 允许加项金额 22
	iAddOrdItemAmount=getValueById("AddOrdItemAmount")
	
	
	if((iAddOrdItemLimit=="Y")&&(iAddOrdItemAmount=="")){
		$.messager.alert('提示','限制加项金额时，加项金额不允许为空！',"info");
		  return false;
	}
	
	if((iAddOrdItemAmount!="")&&(iAddOrdItemAmount<=0)){
		$.messager.alert('提示','加项金额应大于0',"info");
		  return false;
	}
	
	

	 if(!IsFloat(iAddOrdItemAmount)){
		  $.messager.alert('提示','允许加项金额格式不正确',"info");
		  return false;
	  }
	if((iAddOrdItemAmount!="")&&(iAddOrdItemAmount.indexOf(".")!="-1")&&(iAddOrdItemAmount.toString().split(".")[1].length>2))
		{
			$.messager.alert("提示","加项金额小数点后不能超过两位","info");
			return false;
		}

	// PGADM_AddPhcItem 允许加药 23
	iAddPhcItem=getValueById("AddPhcItem")
	if (iAddPhcItem) { iAddPhcItem='Y'; }
	else { iAddPhcItem='N';}
	// PGADM_AddPhcItemLimit 加药金额限制 24
	iAddPhcItemLimit=getValueById("AddPhcItemLimit")
	if (iAddPhcItemLimit) { iAddPhcItemLimit='Y'; }
	else { iAddPhcItemLimit='N';}
	//  PGADM_AddPhcItemAmount允许加药金额 25
	iAddPhcItemAmount=getValueById("AddPhcItemAmount")

	// PGADM_GReportSend 团体报告发送 26
	iGReportSend=getValueById("GReportSend")
	
	// PGADM_IReportSend 个人报告发送 27
	iIReportSend=getValueById("IReportSend")
	
	// PGADM_DisChargedMode 结算方式 28
	iDisChargedMode=getValueById("DisChargedMode")
	
	// PGADM_DelayDate
	iDelayDate=getValueById("DelayDate")
	if(iDelayDate!=""){
		var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iBookDateBegin)
		var iDelayDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDelayDate)
		
		if(iDelayDateLogical<BookDateBeginLogical){
			$.messager.alert("提示","延期日期不能早于体检起始日期","info");
			return false;
		}
	}
	

	
	// PGADM_Remark	备注 29
	iRemark=getValueById("Remark")
	
	
	// PGADM_AuditUser_DR	业务员 30
	Sales=$("#Sales").combogrid("getValue")
	if (($("#Sales").combogrid('getValue')==undefined)||($("#Sales").combogrid('getText')=="")){var Sales="";}
	if(Sales!="")
	{
	if (($("#Sales").combogrid('getValue'))==($("#Sales").combogrid('getText')))  {
		$.messager.alert("提示","业务员选择不正确！","info");
		return false;
	}
	}
	
	// 类型	业务员 31
	Type=getValueById("Type")
	
	
	// 取报告日期	业务员 32
	GetReportDate=getValueById("GetReportDate")
	
	if(GetReportDate!=""){
		var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iBookDateBegin)
		var GetReportDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",GetReportDate)
		
		if(GetReportDateLogical<=BookDateBeginLogical){
			$.messager.alert("提示","取报告日期应大于体检起始日期","info");
			return false;
		}
	}

	//iBookDateBegin=getValueById("BookDateBegin")
	
	// 取报告时间	业务员 33
	GetReportTime=getValueById("GetReportTime")
	
	// 付款类型	业务员 33
	PayType=getValueById("PayType")
	
	// 百分比	业务员 33
	Percent=getValueById("Percent")
	
	// 就餐标志	业务员 33
	var iDietFlag=getValueById("DietFlag")
	if (!iDietFlag) { DietFlag="0"; }	
	//赠品标志	业务员 33
	var iGiftFlag=getValueById("GiftFlag")
	if (iGiftFlag) { GiftFlag="1";}
	//就诊类型用于取价格
	PatFeeType=getValueById("PatFeeTypeName")
	
	//所属合同
	Contract=$("#Contract").combogrid("getValue")
	if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getText')=="")){var Contract="";}
	if(Contract!="")
	{
	if (($("#Contract").combogrid('getValue'))==($("#Contract").combogrid('getText')))  {
		$.messager.alert("提示","合同选择不正确！","info");
		return false;
	}
	}
	
	
	var Instring= trim(iRowId)					// 1
				+"^"+trim(iPGBIDR)				// 2	PGADM_PGBI_DR	预团体客户
				+"^"+trim(iBookDateBegin)		// 3	PGADM_BookDateBegin	预约日期
				+"^"+trim(iBookDateEnd)			// 4	PGADM_BookDateEnd
				+"^"+trim(iBookTime)			// 5	PGADM_BookTime	预约时间
				+"^"+trim(iPEDeskClerkDR)		// 6	PGADM_PEDeskClerk_DR	预约接待人员
				+"^"+trim(iStatus)				// 7	PGADM_Status	状态
				+"^"+trim(iAsCharged)			// 8	PGADM_AsCharged	视同收费
				+"^"+trim(iAddOrdItem)			// 9	PGADM_AddOrdItem 允许加项
				+"^"+trim(iAddOrdItemLimit)		// 10	PGADM_AddOrdItemLimit 加项金额限制
				+"^"+trim(iAddOrdItemAmount)	// 11	PGADM_AddOrdItemAmount 允许加项金额
				+"^"+trim(iAddPhcItem)			// 12	PGADM_AddPhcItem 允许加药
				+"^"+trim(iAddPhcItemLimit)		// 13	PGADM_AddPhcItemLimit 加药金额限制
				+"^"+trim(iAddPhcItemAmount)	// 14	PGADM_AddPhcItemAmount允许加药金额
				+"^"+trim(iGReportSend)			// 15	PGADM_GReportSend 团体报告发送
				+"^"+trim(iIReportSend)			// 16	PGADM_IReportSend 个人报告发送
				+"^"+trim(iDisChargedMode)		// 17	PGADM_DisChargedMode 结算方式
				+"^"+trim(iDelayDate)           // 18	PGADM_DelayDate 延期日期
				+"^"+trim(iRemark)				// 19	PGADM_Remark	备注	
				+"^"+trim(Sales)
				+"^"+trim(Type)
				+"^"+trim(GetReportDate)
				+"^"+trim(GetReportTime)
				+"^"+trim(PayType)
				+"^"+trim(Percent)
				+"^"+trim(DietFlag)
				+"^"+trim(GiftFlag)
				+"^"+trim(PatFeeType)
				+"^"+trim(Contract)
				;
	
   //alert(Instring)
	var flag=tkMakeServerCall("web.DHCPE.PreGADM","Save2","","",Instring);
	
	if (flag=="Err Date")
	{
		$.messager.alert("提示","结束日期不能早于开始日期","info");
		return false;
	}
	
	if (flag=="Err HomeDate")
	{
		$.messager.alert("提示","结束日期不能小于主场结束日期","info");
		return false;
	}
	if (flag=="Err GetReportDate")
	{
		$.messager.alert("提示","取报告日期不能小于今天","info");
		return false;
	}

 
	if (""==iRowId) { //插入操作 返回 RowId
		var Rets=flag.split("^");
		flag=Rets[0];
		// PGADM_RowId	团体ADM 1
		setValueById("PGADM_RowId",Rets[1])
		setValueById("ID",Rets[1])
		GroupID=Rets[1]
	}

	if ('0'==flag) {
		
		if (""==iRowId) { 
			$.messager.alert("提示","预约成功","success");
		}
		else { 
			$.messager.alert("提示","更新成功","success");
		 }
	
		if (""==iRowId) { //刷新页面
			setValueById("PGADM_RowId",Rets[1])
			setValueById("ID",Rets[1])
			GroupID=Rets[1]
			var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
			if (GStatus!="PREREG"){
				$("#RapidNew").linkbutton('disable');
				return false;
				}
			else{
				$("#RapidNew").linkbutton('enable');
			}

			return false;
		}

		return false;
	}
	else if ('Err 02'==flag) {
		$.messager.alert("提示","团体已登记","info");
		return false;		
	}
	else if ('Err 05'==flag) {
		$.messager.alert("提示","录已不是预登记状态,不能修改","info");
		return false;		
	}		
	else {
		$.messager.alert("提示","更新错误 错误号:"+flag,"info");
		return false;
	} 
	return true;
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function Clear_click()
{
	$("#groupform").form("clear");
	var CurDate="",GReportSend="AC",IReportSend="IS"
	
	CurDate=tkMakeServerCall("web.DHCPE.PreGADM","GetDefaultDate");
	
	setValueById("BookDateBegin",CurDate)
	setValueById("BookDateEnd",CurDate)
	
	setValueById("GReportSend",GReportSend)
	setValueById("IReportSend",IReportSend)
	
	
	//视同收费 PIADM_AsCharged
	
	if (Default)
	{
		if ((Default=="2")||(Default=="3")){setValueById("AsCharged",true)}
		else{
			setValueById("AsCharged",false)
			}
			
		
	}
	LoadCard();
}

//  允许加项(PGADM_AddOrdItem)
function AddOrdItem_click(value) {
	if (value) {
		
			$("#AddOrdItemLimit").checkbox("enable");
			setValueById("AddOrdItemLimit",true);
			$("#AddOrdItemAmount").attr("disabled",false)
		
		
	}
	else{
		
			$("#AddOrdItemLimit").checkbox("disable");
			setValueById("AddOrdItemLimit",false)
		
			$("#AddOrdItemAmount").attr("disabled",true);
			setValueById("AddOrdItemAmount","")
			
	}

}
// PGADM_AddOrdItemLimit 加项金额限制 
function AddOrdItemLimit_click(value) {
	if (value) {
		$("#AddOrdItemAmount").attr("disabled",false)
	}
	else{
		$("#AddOrdItemAmount").attr("disabled",true);
		setValueById("AddOrdItemAmount","")	
			
	}
	
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function TeamUpdate() {
	var obj,OneData="",DataStr="";
	var iParRef="",iRowId="",iChildSub,iDesc;
	
	//团体ADM	PGT_ParRef
	OneData=getValueById("ID")
	
	if ((""==OneData)||("0"==OneData)) {
		
		 $.messager.alert("提示","无效团体","info");
		return false; 
	}

	iParRef=OneData
	DataStr=OneData
	OneData=""
	
	//	PGT_RowId
	OneData=getValueById("PGTRowId")
	iRowId=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//	PGT_ChildSub
	OneData=getValueById("PGTChildSub")
	iChildSub=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""

	//分组名称	PGT_Desc
	OneData=getValueById("TeamDesc") 
	if (""==OneData) {
		
	$.messager.alert("提示","分组名称不能为空","info"); 
		websys_setfocus("TeamDesc");
		return false;		
	}
	iDesc=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_BookDateBegin
	OneData=getValueById("TeamBookDateBegin") 
	DataStr=DataStr+"^"+OneData
	OneData=""

	// PGT_BookDateEnd
	OneData=getValueById("TeamBookDateEnd") 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//预约时间 PGT_BookTime
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//预约接待员 PGT_PEDeskClerk_DR
	OneData=$("#TeamPEDeskClerkName").combogrid("getValue")
	if (($("#TeamPEDeskClerkName").combogrid('getValue')==undefined)||($("#TeamPEDeskClerkName").combogrid('getText')=="")){var OneData="";}
	var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(OneData)))&&(OneData!="")){var OneData=$("#TeamPEDeskClerkNameID").val();}

	DataStr=DataStr+"^"+OneData
	OneData=""	
	
	// PGT_AddOrdItem 公费加项
	
	iAddOrdItem=getValueById("TeamAddOrdItem")
	if (iAddOrdItem) { OneData='Y'; }
	else { OneData='N';}
	
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemLimit 加项金额限制
	iAddOrdItemLimit=getValueById("TeamAddOrdItemLimit")
	if (iAddOrdItemLimit) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemAmount 公费加项金额
	OneData=getValueById("TeamAddOrdItemAmount") 
	if ((iAddOrdItemLimit)&&(OneData=="")){
		$.messager.alert('提示','限制加项金额时，加项金额不允许为空',"info");
		  	return false;
		
	}

	if((OneData!="")&&(OneData<=0)){
		$.messager.alert('提示','加项金额应大于0',"info");
		  return false;
	}

	 if(!IsFloat(OneData)){
		  $.messager.alert('提示','加项金额格式不正确',"info");
		  return false;
	  }
	if((OneData!="")&&(OneData.indexOf(".")!="-1")&&(OneData.toString().split(".")[1].length>2))
		{
			$.messager.alert("提示","加项金额小数点后不能超过两位","info");
			return false;
		}

	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItem 允许加药
	iAddPhcItem=getValueById("TeamAddPhcItem")
	if (iAddPhcItem) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItemLimit 加药金额限制 
	OneData='N'
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//  PGT_AddPhcItemAmount允许加药金额
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//性别	PGT_Sex
	var checkedRadioObj = $("input[name='TeamSex']:checked");
	OneData=checkedRadioObj.val();
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//年龄上限	PGT_UpperLimit
	OneData=getValueById("UpperLimit")
	if (OneData!=""){
		if(+OneData<0){
		  $.messager.alert("提示","年龄上限不能小于0","info"); 
			websys_setfocus("UpperLimit"); 
			return false;
	  }

		if(!isInteger(OneData)) {
			$.messager.alert("提示","年龄上限格式非法","info"); 
			websys_setfocus("UpperLimit"); 
			return false;
	}
	}



	
	DataStr=DataStr+"^"+trim(OneData)
	OneData=""

	//年龄下限	PGT_LowerLimit
	OneData=getValueById("LowerLimit")
	if (OneData!=""){
		if(+OneData<0){
		  $.messager.alert("提示","年龄下限不能小于0","info"); 
			websys_setfocus("UpperLimit"); 
			return false;
	  }
		if(!isInteger(OneData)) {
			$.messager.alert("提示","年龄下限格式非法","info"); 
			websys_setfocus("LowerLimit"); 
			return false;
	}
	}



	var iUpperLimit=parseFloat($("#UpperLimit").val())
	var iLowerLimit=parseFloat($("#LowerLimit").val())
	if(iUpperLimit<iLowerLimit){
		$.messager.alert("提示","年龄下限不能大于上限","info");		
		return false;
	}

	DataStr=DataStr+"^"+trim(OneData)
	OneData=""

	//婚姻状况	PGT_Married
	
	var checkedRadioObj = $("input[name='TeamMarried']:checked");
	OneData=checkedRadioObj.val();
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//VIP等级
	OneData=$("#VIPLevel").combogrid("getValue")
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	 
	// 分组等级
	 
	DataStr=DataStr+"^"+OneData
	OneData=""
    //就诊费用类别 用于计费价格
    OneData=$("#TeamPatFeeTypeName").combogrid("getValue")
   
	DataStr=DataStr+"^"+OneData
	//是否包含在团体
	OneData=""
	iNoIncludeGroup=getValueById("NoIncludeGroup")
	if (iNoIncludeGroup) { OneData=1; }
	else { OneData="";}
	
	DataStr=DataStr+"^"+OneData;
	//结算方式
	OneData=""
	OneData=$("#TeamDisChargedMode").combogrid("getValue")
	
	DataStr=DataStr+"^"+OneData;
	//危害因素
	OneData=""
	var OccuId=$("#HarmInfo").combotree("getValues")
	var OneData=OccuId.join(",");



	DataStr=DataStr+"^"+OneData;
	
	//检查种类
	OneData=""
	OneData=$("#OMEType").combobox("getValue")
	

	DataStr=DataStr+"^"+OneData;

   //检查位置
	OneData=""
	OneData=$("#RoomPlace").combogrid("getValue")
	
	DataStr=DataStr+"^"+OneData;
	
	//alert(DataStr)
	
	var flag=tkMakeServerCall("web.DHCPE.PreGTeam","Save2","","",DataStr);
	
	if (flag=="Err Date")
	{
		 $.messager.alert("提示","结束日期小于开始日期","info");
		return false;
	}
	if ('0'==flag) {
		
		$('#NewWin').window('close');
		$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
		
	}	
	else {
		$.messager.alert("提示","更新错误 错误号:"+flag);
		return false;
	}

	return true;
}

function TeamClear()
{
	
	$(".hisui-combobox").combobox('setValue','');
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#HarmInfo").combotree("setValue","")
	$("#TeamDesc,#TeamBookDateBegin,#TeamBookDateEnd,#UpperLimit,#LowerLimit,#TeamAddOrdItemLimit").val("");
	$HUI.radio("#TeamSexN").setValue(true);
	$HUI.radio("#TeamMarriedN").setValue(true);
	var GADMID=getValueById("ID")
	var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
	SetParRefData(ret)
	var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP");
	$('#VIPLevel').combobox('setValue',VIPNV);
}

function SaveTemplate()
{
	var iPGBIDR=getValueById("PGBI_RowId")
	var iDesc=getValueById("TeamDesc");
	if (iDesc=="") {
		//$.messager.alert("提示","分组名称不能为空","info"); 
		//return false;
	}

	var iAgeDown=$("#LowerLimit").val();
	
	if(iAgeDown!="")
	{ 
	  if(+iAgeDown<0){
		  $.messager.alert("提示","年龄下限不能小于0","info"); 
		websys_setfocus("LowerLimit"); 
		return false;
	  }
	  if(!(isInteger(iAgeDown))){
		   $.messager.alert("提示","年龄下限格式非法","info"); 
		websys_setfocus("LowerLimit"); 
		return false;
	  }
	}
	


	var iAgeUp=$("#UpperLimit").val();
	if(iAgeUp!="")
	{ 
	  if(+iAgeUp<0){
		  $.messager.alert("提示","年龄上限不能小于0","info"); 
		websys_setfocus("UpperLimit"); 
		return false;
	  }
	  if(!(isInteger(iAgeUp))){
		   $.messager.alert("提示","年龄上限格式非法","info"); 
		websys_setfocus("UpperLimit"); 
		return false;
	  }
	}

	if(iAgeUp<iAgeDown){
		$.messager.alert("提示","年龄下限不能大于上限","info"); 
		return false;
	}
	
	if(iAgeDown!="")  var iAgeDown=tkMakeServerCall("web.DHCPE.Cashier","Round",iAgeDown,0,5)
	if(iAgeUp!="")  var iAgeUp=tkMakeServerCall("web.DHCPE.Cashier","Round",iAgeUp,0,5)
	
	//性别 
	var checkedRadioObj = $("input[name='TeamSex']:checked");
	var iSex=checkedRadioObj.val();
	
	//婚姻状况 
	var checkedRadioObj = $("input[name='TeamMarried']:checked");
	var iMarried=checkedRadioObj.val();
	
	var ret=1;
	var InStr=iDesc+'^'+iAgeUp+'^'+iAgeDown+'^'+iSex+'^'+iMarried;
	
	var ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet",InStr,"","Set"); 
	if (ret==0){
		$.messager.alert("提示","保存成功","success"); 
		$("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",VIP:"",ToGID:"",GBID:"",TemplateFlag:"1"}); 
			
	}
	else{
		$.messager.alert("提示","保存失败","error");
		}
//	$("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",ToGID:"",TemplateFlag:"1"}); 
}


function RapidUpdate()
{
	var obj;
	var iDesc="",iSex="",iMarried="",iAge="",iAgeLow="",iAgeHigh="";
	var iTeamNum=0;
	
	var checkedRadioObj = $("input[name='TeamNum']:checked");
	OneData=checkedRadioObj.val();
	
	if(OneData==undefined){
		$.messager.alert("提示","请勾选分组","info");
		return false;	
	}
	var RapidEndDate=$("#RapidBookDateEnd").datebox('getValue');
	var RapidStartDate=$("#RapidBookDateBegin").datebox('getValue');
	var iRapidStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",RapidStartDate);
	var iRapidEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",RapidEndDate);
	
	if((iRapidStartDate!="")&&(iRapidEndDate!="")&&(iRapidEndDate<iRapidStartDate))
	{
		$.messager.alert("提示","结束日期小于开始日期","info"); 
		return false;
	}
	if (OneData=="Team_One"){
		iTeamNum=1;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="全体人员";
	            iSex="N";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}		
	}
	
	if (OneData=="Team_Two"){
		iTeamNum=2;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="男";
	            iSex="M";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else
			{
				iDesc="女";
	            iSex="F";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	
	if (OneData=="Team_Three"){
		
		
		iTeamNum=3;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="男";
	            iSex="M";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue; 
			}
			else if(i==1)
			{
				iDesc="女未婚";
	            iSex="F";
	            iMarried="UM";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else 
			{
				iDesc="女已婚";
	            iSex="F";
	            iMarried="M";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	
	if (OneData=="Team_Four"){
		
		iTeamNum=4;
		obj=document.getElementById("AgeBoundary");
	    if (obj&& obj.value){ iAge=obj.value;}
	     if (iAge=="") {
				$.messager.alert("提示","年龄界限不能为空","info"); 
				return false;
				}
	    if (!(isInteger(iAge))||(iAge<0)) {
					$.messager.alert("提示","年龄格式非法","info"); 
					return false;
				}	
		 if (iAge>100) {
					$.messager.alert("提示","年龄上限不能超过100","info"); 
					return false;
				}
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="男大于等于"+iAge+"岁";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==1)
			{
				iDesc="男小于等于"+iAge+"岁";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==2) 
			{
				iDesc="女大于等于"+iAge+"岁";
	            iSex="F";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else
			{
				iDesc="女小于等于"+iAge+"岁";
	            iSex="F";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	
	if (OneData=="Team_Five"){
	
		iTeamNum=5;
		
		obj=document.getElementById("AgeBoundary");
	    if (obj&& obj.value){ iAge=obj.value;}
	    if (iAge=="") {
				$.messager.alert("提示","年龄界限不能为空","info"); 
				return false;
				}
	    if (!(isInteger(iAge))||(iAge<0)) {
					$.messager.alert("提示","年龄格式非法","info"); 
					return false;
				}	
		 if (iAge>100) {
					$.messager.alert("提示","年龄上限不能超过100","info"); 
					return false;
				}
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="女未婚";
	            iSex="F";
	            iMarried="UM";
	            iAgeLow=""
	            iAgeHigh=""
	            
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==1)
			{
				iDesc="男大于等于"+iAge+"岁";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==2) 
			{
				iDesc="男小于等于"+iAge+"岁";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==3)
			{
				iDesc="女已婚大于等于"+iAge+"岁";
	            iSex="F";
	            iMarried="M";
	            iAgeLow=iAge
	            iAgeHigh=100
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum)
	            continue;
			}
			else
			{
				iDesc="女已婚小于等于"+iAge+"岁";
	            iSex="F";
	            iMarried="M";
	            iAgeLow=0
	            iAgeHigh=iAge
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
		}
	}
	
}

function save(Desc,Sex,Married,AgeLow,AgeHigh,Num,TeamNum){
	
	//alert(AgeLow,AgeHigh)
	
	var obj,OneData="",DataStr="";
	var iParRef="",iRowId="",iChildSub,iDesc;
	
	obj=document.getElementById("ID");
	if (obj) { OneData=obj.value; } 
	else {
		 obj.value=Desc; 
	     OneData=obj.value; }
       
    if((""==OneData)||("0"==OneData)){
	  $.messager.alert("提示","无效团体","info");
		return false;
    }

	iParRef=OneData
	DataStr=OneData
	OneData=""
	var PreGInfoStr=tkMakeServerCall("web.DHCPE.PreGTeamNew","GetPreGInfo",iParRef);
	var PreGInfo=PreGInfoStr.split("^");
	//	PGT_RowId
	
	iRowId=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""

	//	PGT_ChildSub
	
	iChildSub=OneData 
	DataStr=DataStr+"^"+OneData
	OneData=""

	//分组名称	PGT_Desc
	OneData=Desc
	iDesc=OneData
	DataStr=DataStr+"^"+OneData
	OneData=""
		
	// PGT_BookDateBegin
	OneData=getValueById("RapidBookDateBegin") 
	DataStr=DataStr+"^"+OneData
	OneData=""

	// PGT_BookDateEnd
	OneData=getValueById("RapidBookDateEnd") 
	 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//预约时间 PGT_BookTime
	OneData=getValueById("RapidBookTime")
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//预约接待员 PGT_PEDeskClerk_DR
	 
	DataStr=DataStr+"^"+OneData
	OneData=""	
	
	// PGT_AddOrdItem 公费加项
	/*
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[7];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemLimit 加项金额限制
	/*
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[8];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemAmount 公费加项金额
	/*
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { OneData=obj.value; }
	*/
	OneData=PreGInfo[9];


	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItem 允许加药
	/*
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[10];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItemLimit 加药金额限制
	/*
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[11];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//  PGT_AddPhcItemAmount允许加药金额
	/*
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { OneData=obj.value; }
	*/
	OneData=PreGInfo[12];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//性别	PGT_Sex
	OneData=Sex
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//年龄上限	PGT_UpperLimit
	OneData=AgeHigh
	DataStr=DataStr+"^"+OneData
	OneData=""

	//年龄下限	PGT_LowerLimit
	OneData=AgeLow
	DataStr=DataStr+"^"+OneData
	OneData=""

	//婚姻状况	PGT_Married
	OneData=Married
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//VIP等级
	OneData=$("#RapidVIPLevel").combogrid("getValue") 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	obj=document.getElementById("TeamLevel");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	 
    //就诊费用类别 用于计费价格
    OneData=$("#RapidPatFeeTypeName").combogrid("getValue") 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//是否包含在团体
	OneData=""
	obj=document.getElementById("RapidNoIncludeGroup");
	if (obj&&obj.checked) { OneData=1; } 
	DataStr=DataStr+"^"+OneData;

	//结算方式
	OneData=$("#RapidDisChargedMode").combogrid("getValue") 
	
	DataStr=DataStr+"^"+OneData;
	
	
	var flag=tkMakeServerCall("web.DHCPE.PreGTeamNew","Save2","","",DataStr);
	
	
	if (flag=="Err Date")
	{
		$.messager.alert("提示","结束日期小于开始日期","info"); 
		return false;
	}
	if ('0'==flag) {
		
		$('#RapidNewWin').window('close');
		$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
		
	}	
	else {
		
		$.messager.alert("提示","更新错误 错误号："+flag,"error"); 
		return false;
	}

	return true;

}	
function BAddItem()
{
	var PreOrAdd="ADD"  //是否公费加项
	var iRowId=getValueById("PIADM_RowId")
	var iRowId=GetSelectADM();
	if(iRowId=="")
	{
		$.messager.alert("提示", "请选择一条客户信息", "info");
		return;
		
	}
	
	var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
	/*
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	*/
	var wwidth=1450;
	var wheight=1450; 
	var xposition=0;
	var yposition=0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return true;
	
	
}

function PNewItem()
{
	
	var PreOrAdd="PRE"  //是否公费加项
	var iRowId=getValueById("PIADM_RowId")
	var iRowId=GetSelectADM();
	if(iRowId=="")
	{
		$.messager.alert("提示", "请选择一条客户信息", "info");
		return;
		
	}
	var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
	/*
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	*/
    var wwidth=1450;
	var wheight=1450; 
	var xposition=0;
	var yposition=0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	

	return true;
	
}

//撤销已预约人员
function BCancelSelect()
{
	
	var SelectIds=""
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		
		if (SelectIds==""){
				SelectIds=selectrow[i].PIADM_RowId;
			}else{
				SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
			} 
	}
	if(selectrow.length>=2){
		$.messager.alert("提示","只能选择一人撤销","info");
		return false;
		}
	
	if(SelectIds=="")
	{ 
		$.messager.alert("提示","请选择待撤销人员","info");
		return false;
	}
	
	
	$.messager.confirm("确认", "确定要撤销吗？", function(r){
		if (r){
			 var PreIADMDR=SelectIds
   
			var ret=tkMakeServerCall("web.DHCPE.SelectPreInfo","Cancel",PreIADMDR);
			var Arr=ret.split("^");
			if (Arr[0]==0){
				$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:getValueById("PGTRowId"),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
				$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
	    		$.messager.alert("提示","撤销成功","success");
			}else{
				$.messager.alert("提示",Arr[1],"info");
			}
			
		}
	}); 
	
}	


function BSelectPre()
{
	var Url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESelectPreInfo&&TeamID="+getValueById("PGTRowId");
	websys_lu(Url,false,'width=1020,height=545,hisui=true,title=合并到团体')


/*
	$HUI.window("#SelectPreInfoWin",{
		title:"合并到团体",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESelectPreInfo&&TeamID='+getValueById("PGTRowId")+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	
	*/

}

function BNewItem()
{
	
	var iRowId=getValueById("PGTRowId")
	var PreOrAdd="PRE"
	var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=TEAM"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
	
	/*		
	var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	*/
	var wwidth=1450;
	var wheight=1450; 
	var xposition=0;
	var yposition=0;

	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)			
	return true;		
	
}

function PreTeamEdit(instring)
{
	$HUI.window("#NewWin",{
		title:"团体分组信息",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		modal:true,
		width:900,
		height:620

	});
	
	
	
	
	
	
	$HUI.radio("#TeamSexN").setValue(true);
	$HUI.radio("#TeamMarriedN").setValue(true);
	
	$("#TeamGReportSend").combobox('disable');
	$("#TeamIReportSend").combobox('disable');

	

	var GADMID=getValueById("ID")
	
	var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
	
	
	setValueById("ParRef_Name",ret.split("^")[3])
	
	SetParRefData(ret)
	var ret=tkMakeServerCall("web.DHCPE.PreGTeam","DocListBroker","","",GADMID+"^^"+instring);
	
	TSetPatient_Sel(ret)
	
	
}


function TSetPatient_Sel(value) {
	var obj;
	var Data=value.split("^");
	var iLLoop=0;
	iRowId=Data[iLLoop];
	if ("0"==iRowId){
		return false;
	}
	
	//团体ADM	PGT_ParRef	1
	setValueById("",Data[iLLoop])
	
	iLLoop=iLLoop+1;
		
	//	PGT_RowId
	setValueById("",Data[iLLoop]) 
	iLLoop=iLLoop+1;
	//	PGT_ChildSub 3
	setValueById("",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//分组名称	PGT_Desc 4
	setValueById("TeamDesc",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateBegin	21
	setValueById("TeamBookDateBegin",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateEnd	22
	setValueById("TeamBookDateEnd",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//预约时间 PGT_BookTime 23
	
	iLLoop=iLLoop+1;
	
	// PGT_PEDeskClerk_DR 24
	setValueById("TeamPEDeskClerkName",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	
	var strLine="";
	//	公费加项	PGT_AddOrdItem	12
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	

	//	加项金额限制	PGT_AddOrdItemLimit	13
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	
	//	公费加项金额	PGT_AddOrdItemAmount	14
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	允许加药	PGT_AddPhcItem	15
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	加药金额限制	PGT_AddPhcItemLimit	16
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;

	//	允许加药金额	PGT_AddPhcItemAmount	17
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	SetTeamAddItem(strLine);
	
	//性别	PGT_Sex 5
	
	if(Data[iLLoop]=="M")
	{$HUI.radio("#TeamSexM").setValue(true);}
	else if(Data[iLLoop]=="F")
	{$HUI.radio("#TeamSexF").setValue(true);}
	else
	{$HUI.radio("#TeamSexN").setValue(true);}
	
	iLLoop=iLLoop+1;
	//年龄上限	PGT_UpperLimit 6
	setValueById("UpperLimit",Data[iLLoop])

	iLLoop=iLLoop+1;
	//年龄下限	PGT_LowerLimit 7
	setValueById("LowerLimit",Data[iLLoop])

	iLLoop=iLLoop+1;
	//婚姻状况	PGT_Married 8
	if(Data[iLLoop]=="M")
	{$HUI.radio("#TeamMarriedM").setValue(true);}
	else if(Data[iLLoop]=="UM")
	{$HUI.radio("#TeamMarriedUM").setValue(true);}
	else
	{$HUI.radio("#TeamMarriedN").setValue(true);}
   
	iLLoop=iLLoop+4;
	
	//团体名称	PGT_LowerLimit 7
	setValueById("ParRef_Name",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//	团体报告发送	PGT_GReportSend	18
	setValueById("TeamGReportSend",Data[iLLoop])
	iLLoop=iLLoop+1;	
	
	//	个人报告发送	PGT_IReportSend	19
	setValueById("TeamIReportSend",Data[iLLoop])
	iLLoop=iLLoop+1;	
	
	//	结算方式	PGT_DisChargedMode	20
	setValueById("TeamDisChargedMode",Data[iLLoop])
	iLLoop=iLLoop+1;	
	// PGT_PEDeskClerk_DR_Name 24.1
	
	iLLoop=iLLoop+1;
	
	setValueById("VIPLevel",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	iLLoop=iLLoop+1;
	setValueById("TeamPatFeeTypeName",Data[iLLoop])
	iLLoop=iLLoop+1;
	var NoInclude=""
	NoInclude=Data[iLLoop];
	if (NoInclude=="1"){
		setValueById("NoIncludeGroup",Data[iLLoop])
	}
	
	
	var VIPLevelDesc=$("#VIPLevel").combobox('getText');
	
	if (VIPLevelDesc=="职业病"){
			$("#OMEType").combobox('enable');
			$("#HarmInfo").combotree('enable');
				var TeamOMETypeObj = $HUI.combobox("#OMEType",{
				url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOMEType&ResultSetType=array",
				valueField:'id',
				textField:'Desc',
				onBeforeLoad: function(param){
					param.VIPLevel=$("#VIPLevel").combobox('getValue'); 
	 			} 
			});
	

		}else{
				$("#OMEType").combobox('disable');
				$("#HarmInfo").combotree('disable');
				
		}
	iLLoop=iLLoop+1;
	//检查种类
	OMEType=Data[iLLoop];
	//setValueById("OMEType",Data[iLLoop])
    $("#OMEType").combobox("setValues",OMEType);
    
	iLLoop=iLLoop+1;
	var RoomPlace=""
	RoomPlace=Data[iLLoop];
	//alert(RoomPlace)
	setValueById("RoomPlace",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//危害因素
	var HarmInfo=Data[iLLoop].split(","); 
	$("#HarmInfo").combotree("setValues",HarmInfo);

	
}

function GIAdmEdit(instring)
{
	
	var rowid=instring.split("^")[0]
	var regno=instring.split("^")[1]
	var name=instring.split("^")[2]
	var pedate=instring.split("^")[3]
	var petime=instring.split("^")[4]
	/*
	$HUI.window("#GIAdmEditWin",{
		title:"项目信息列表",
		collapsible:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.GTEdit&ID='+rowid+'&RegNo='+regno+'&Name='+name+'&PEDate='+pedate+'&PETime='+petime+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.GTEdit"+"&ID="+rowid+"&RegNo="+regno+"&Name="+name+"&PEDate="+pedate+"&PETime="+petime;
	
	websys_lu(str,false,'width=700,height=495,hisui=true,title=预约信息修改')
	
	
	
}
/*
function BaseInfo(rowid)
{
	

	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit&OperType=Q&ID="+rowid;
	
	websys_lu(str,false,'width=1000,height=590,hisui=true,title=个人基本信息维护')
	
}
*/
function BaseInfo(index)
{

	var rows = $('#TeamPersonGrid').datagrid("getRows");
	var PIADM=rows[index].PIADM_RowId;
	var PIBI=rows[index].PIADM_PIBI_DR;
	var GroupDR=rows[index].PIADM_PGADM_DR;
	var TeamDR=rows[index].PIADM_PGTeam_DR;
	   	
	//var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit&OperType=Q&ID="+PIBI+"&GroupDR="+GroupDR+"&TeamDR="+TeamDR;
	//websys_lu(str,false,'width=1000,height=590,hisui=true,title=个人基本信息维护')
	var lnk="dhcpepreibaseinfo.edit.hisui.csp?OperType=Q&ID="+PIBI;
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=795,height=640,hisui=true,title=个人基本信息维护')
}



function NoCheckedList(rowid)
{
	/*
	$HUI.window("#CheckedListWin",{
		title:"检查信息列表",
		collapsible:false,
		modal:true,
		width:1200, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=N&GroupID='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=N&GroupID="+rowid;
	
	websys_lu(str,false,'width=1200,height=495,hisui=true,title=未检信息列表')
}

function HadCheckedList(rowid)
{
	/*
	$HUI.window("#CheckedListWin",{
		title:"检查信息列表",
		collapsible:false,
		modal:true,
		width:1200, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=Y&GroupID='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=Y&GroupID="+rowid;
	
	websys_lu(str,false,'width=1200,height=495,hisui=true,title=已检信息列表')
	
}
function CancelPEList(rowid)
{
	
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=C&GroupID="+rowid;
	websys_lu(str,false,'width=1200,height=495,hisui=true,title=取消体检信息列表')
	
}
function CheckTeamItem(rowid)
{
	/*
	$HUI.window("#ItemWin",{
		title:"项目信息列表",
		collapsible:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=TEAM&AdmId='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=TEAM&AdmId="+rowid;
	
	websys_lu(str,false,'width=690,height=495,hisui=true,title=项目信息列表')
}

function CheckItem(rowid)
{
	/*
	$HUI.window("#ItemWin",{
		title:"项目信息列表",
		collapsible:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=PERSON&AdmId='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=PERSON&AdmId="+rowid;
	
	websys_lu(str,false,'width=690,height=495,hisui=true,title=项目信息列表')
	
	
	
}


function BNewIADM()
{
	var iRowId="";
	var iPIBIDR="", iPGADMDR="", iPGTeamDR="", iPEDateBegin="", iPEDateEnd="", iPETime="", iPEDeskClerkDR="", 
		iStatus="", iAsCharged="", iAccountAmount="", iDiscountedAmount="", iSaleAmount="", 
		iFactAmount="", iAuditUserDR="", iAuditDate="", iUpdateUserDR="", iUpdateDate=""
		iChargedStatus="", iCheckedStatus="", iAddOrdItem="", iAddOrdItemLimit="", 
		iAddOrdItemAmount="", iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
		iIReportSend="", iDisChargedMode=""
		;
	var obj;

	
	iRowId="";
	
	//预登记个人基本信息号 PIADM_PIBI_DR 1
	iPIBIDR=getValueById("PIBI_RowId")
	
	
	//对应团体的ADM PIADM_PGADM_DR 2
	iPGADMDR=getValueById("ID")
	
	if (""==iPGADMDR) {
			//无效团体组
			$.messager.alert("提示","无效团体",'info');
			return false;
		}
	

	//对应组ADM PIADM_PGTeam_DR 3
	iPGTeamDR=getValueById("PGTRowId")
	
	if (""==iPGTeamDR) {
			//无效团体组
			$.messager.alert("提示","无效分组",'info');
			return false;
		} 
	
	
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",iPIBIDR,iPGADMDR,iPGTeamDR);
	if (flag=="Err Audit")
	{
		//alert("计费纪录都已审核,请先取消审核纪录");
		$.messager.alert("提示","计费纪录都已审核,请先取消审核纪录",'info');
		return false;
	}
	
	if (""==iRowId) { 
		var Rets=flag.split("^");
		flag=Rets[0];
		
	}
	if ('0'==flag) {
		$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iPGTeamDR,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		
		window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iPGTeamDR,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		
		$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});

		window.parent.$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
		 
	}
	else if ('Err 07'==flag) {
		$.messager.alert("提示","客户在团体或团体组中已存在!",'info');
		//alert("客户在团体或团体组中已存在!");
		return false;		
	}
	else if ('Err 09'==flag) {
		$.messager.alert("提示","增加团体组客户失败"+":"+Rets[1],'error');
		//alert("增加团体组客户失败"+":"+Rets[1]);
		return false;		
	}
	else {
		$.messager.alert("提示","更新错误 错误号:"+flag,'error');
		//alert("更新错误 错误号:"+flag);
		return false;
	}
	
	return true;
	
}


function BFind_Click()
{
	
	var iStatus=GetStatus();
	
	
	$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:getValueById("PGTRowId"),RegNo:getValueById("RegNo"),Name:getValueById("PatName"),DepartName:getValueById("DepartName"),OperType:"",Status:iStatus}); 
		
	
	
}

function GetStatus()
{
	var obj;
	var iStatus="";

	// PREREG 预约
	obj=getValueById("PREREG");
	if (obj){ iStatus=iStatus+"^"+"PREREG"; }

	// REGISTERED 登记
	obj=getValueById("REGISTERED");
	if (obj){ iStatus=iStatus+"^"+"REGISTERED"; }
	
	// REGISTERED 到达
	obj=getValueById("ARRIVED");
	if (obj){ iStatus=iStatus+"^"+"ARRIVED"; }
	
	iStatus=iStatus+"^"
	return iStatus;
}

function BCopyTeam()
{
	var iRowId="";

	var obj=document.getElementById("PGTRowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	
	var flag=tkMakeServerCall("web.DHCPE.PreGTeam","CopyTeamData",iRowId);
	
	if (flag=="Notice"){
		alert("已审核,加人加项需取消审核!");
		return false;
	}
    if (flag!="") {
	   	alert("保存出错!"+":"+flag);
	   	return false;
    }
	$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")}); 
	$("#PGTRowId").val("");
	
}
function DelGTeamTemp(rowid)
{
	
	var ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet","",rowid,"Del"); 
	if(ret==0)
	{
		$("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",VIP:"",ToGID:"",GBID:"",TemplateFlag:"1"}); 
	}		
}

function GetSelectADM()
{
	var PreADMs=""
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		if (PreADMs==""){
				PreADMs=selectrow[i].PIADM_RowId
			}else{
				PreADMs=PreADMs+"^"+selectrow[i].PIADM_RowId
			}

	}
	return PreADMs
}


var DoType="";
function BRegister()
{
  
	DoType=2;
	register();
	
}

function TCancelPE()
{
	
	
	var iRowId=$("#PGTRowId").val();
	
	if (""==iRowId) {
		 $.messager.alert("提示","请选择待取消体检的分组","info"); 
		return false;
	}
	
	$.messager.confirm("确认", "是否确定取消体检？", function(r){
	if (r){		
	
		var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",iRowId,"T","0");
	
		Ret=Ret.split("^")

		if (Ret[0]=="0") 
	
	 	{
		 	$.messager.alert("提示","完成取消体检！","info");
		 	 
		 	$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:$("#PGTRowId").val(),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		   
		 	$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")}); 

		 } 
   	 else
     	{
	    	$.messager.alert("提示",Ret[1],"info");
	    
	 		}
		}
	});
	
	
}



function BCancelPE()
{
	
	var SelectIds=""
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
		
		if (SelectIds==""){
				SelectIds=selectrow[i].PIADM_RowId;
			}else{
				SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
			} 
	}
	
	if(SelectIds=="")
	{ 
		$.messager.alert("提示","请选择待取消体检的人员","info");
		return false;
	}

	
	$.messager.confirm("确认", "是否确定取消体检？", function(r){
		if (r){
			
			var CancelFlag=0;
	
	PreAdmIdStr=SelectIds.split("^")

	for(var i=0;i<PreAdmIdStr.length;i++){
		
		var PreAdmId=PreAdmIdStr[i];
		var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",PreAdmId,"I","0"); 
		Ret=Ret.split("^")
		
		if (Ret[1]!=="完成取消体检操作")
	   	{ 
	   		CancelFlag=1; 
	    }
		
	}
	

	if (CancelFlag=="0") 
	
	 {
		 
		 $.messager.alert("提示","完成取消体检！","info");
		 
		 var gteam=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetGTeamByIADM",PreAdmId);
		 
    	 $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:gteam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
         
         $("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
	 	 
	 
	 } 
    else
     {
	    $.messager.alert("提示",Ret[1],"info");
	     var gteam=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetGTeamByIADM",PreAdmId);
    	 $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:gteam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 

	    
	 }
		}
	});
	
	
}

var OKNumTotal=0,ErrNumTotal=0;
var LastTeamRowID="";
function register()
{
	var OneNum=19;  //每次操作人数OneNum+1
	var obj=document.getElementById("PGTRowId");
	if (obj) { 
		iRowId=obj.value; 
		if((LastTeamRowID!="")&&(LastTeamRowID!=iRowId)) {var OKNumTotal=0,ErrNumTotal=0;}
		var LastTeamRowID=iRowId;	
	}

	if (""==iRowId) 
	
	{
		$.messager.alert("提示","请先选择分组!","info");
	 	return false;
	 }
	 var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateTeamInfo",iRowId,DoType,OneNum);
	 var Arr=ret.split("^")
	 var Num=Arr[1]
	 if (Num>OneNum){
		 var OKNum=Arr[1];
		 var ErrNum=Arr[2];
		 OKNumTotal=OKNumTotal+(+OKNum);
		 ErrNumTotal=ErrNumTotal+(+ErrNum);
		 var obj=document.getElementById("RegisterInfo");
		 //if (obj) obj.innerText="成功:"+OKNumTotal+"人;错误:"+ErrNumTotal+"人";
		 setTimeout("register()",500);
		 
	 }else{
		 var OKNum=Arr[1];
		 var ErrNum=Arr[2];
		 OKNumTotal=OKNumTotal+(+OKNum);
		 ErrNumTotal=ErrNumTotal+(+ErrNum);
		 var obj=document.getElementById("RegisterInfo");
		 //if (obj) obj.innerText="成功:"+OKNumTotal+"人;错误:"+ErrNumTotal+"人";
		 $.messager.alert("提示","操作完成!","info");
		 //alert("操作完成!"+"成功:"+OKNumTotal+"人;错误:"+ErrNumTotal+"人");
	 }
	 
	var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
	if (GStatus!="PREREG"){
		$("#RapidNew").linkbutton('disable');
		//return false;
		}
	else{
		$("#RapidNew").linkbutton('enable');
	}
	$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iRowId,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
	
}

function BPrintPatItem_click()
{
	var Instring,PAADM
	var obj=document.getElementById("PGTRowId");
	if (obj) { var iRowId=obj.value; }
	if (""==iRowId) 
	{
		$.messager.alert("提示","请先选择分组","info");
		return false;
	 }
	var IDS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetTeamIADM",iRowId)
	if (IDS=="")
	{
		$.messager.alert("提示","没有需要打印的数据","info");
		return
		
	}
	var temprow=IDS.split("^");
	for(i=0;i<=(temprow.length-1);i++)
	{
		PAADM=temprow[i]
		Instring=PAADM+"^1^PAADM";
		var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
		PEPrintDJD("P",PAADM,"");//DHCPEPrintDJDCommon.js lodop打印导诊单
		//PrintA4(value,1,"N"); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
		var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
		
	}
	
}
//续打凭条
function ConPrintTPerson_click()
{
	var obj,ConRegNo,iRegNo
	obj=document.getElementById("ContinueRegNo");
	if (obj) {
		ConRegNo=obj.value;
		if(ConRegNo==""){
			alert("请先输入续打体检号")
			return false;
		}
		var flag=tkMakeServerCall("web.DHCPE.PrintGroupPerson","IsHPNo",ConRegNo);
		if(flag=="1"){
			alert("输入的体检号不正确");
			return false;
		}

		//iRegNo=RegNoMask(ConRegNo);
		PrintTeamPerson_click(iRegNo);
		}
	else {alert("请输入续打体检号!")}
}

//按分组打印
function PrintTeamPerson_click(ConRegNo)
{
	try{
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
	
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
    var myDate = new Date();
    myDate.getFullYear();
    
    var obj=document.getElementById("PGTRowId");
    if(obj)  {var PGADMID=obj.value;} 	//team
    if ((""==PGADMID)){
		alert("未选择分组");
		return false;	}
    var Instring=PGADMID;
  
    
    var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",Instring,"Y",ConRegNo);
    
    var str=returnval; 
    var temprow=str.split("^");
   	if(temprow=="")
   	{
		alert("该团体人员名单为空")
	   	return;
	} 
   
   	
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i]);
	    
	    var tempcol=row.split("^");
	    var j=(i+1)%6;
	    var Rows,Cols;
	    if (j==1){
	        Rows=0; 
	        Cols=0; 
	    }
	    if (j==2){
	        Rows=0;  
	        Cols=7; 		    
	    }
	    if (j==3){
	        Rows=12;  
	        Cols=0;    
	    }
	    if (j==4){
	        Rows=12; 
	        Cols=7; 	    
	    }
	    if (j==5){
	        Rows=24;  
	        Cols=0; 		    
	    }
	    if (j==0){
	   	    Rows=24;
	   	    Cols=7;
	    } 
	   
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //姓名
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //性别
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //年龄
	    //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //电话
		xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; //体检号
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //编号或条码
	    xlsheet.cells(Rows+6,Cols+3)=tempcol[9]; //单位名称
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //所属部门
	    
	    
  		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年"+HospitalName+"体检凭条";

	    xlsheet.cells(Rows+2,Cols+1)="姓名:";
	    xlsheet.cells(Rows+2,Cols+3)="性别:";
	    xlsheet.cells(Rows+2,Cols+5)="年龄:";
	    //xlsheet.cells(Rows+3,Cols+1)="联系电话:";
		xlsheet.cells(Rows+3,Cols+1)="体检号:";
	    xlsheet.cells(Rows+4,Cols+1)="编号(或编码):";
	    xlsheet.cells(Rows+6,Cols+1)="单位名称：";
	    xlsheet.cells(Rows+7,Cols+1)="所属部门:";
	    xlsheet.cells(Rows+8,Cols+1)="★注:抽血时间:上午8:00---9:30";
	   if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    	xlsheet.cells(Rows+10,Cols+1)="体检电话: ";    
		    xlsheet.cells(Rows+8,Cols+1)="★注:登记时间:上午7:45---10:00";
		}
		else
		{
	    if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    		xlsheet.cells(Rows+10,Cols+1)="体检电话: ";
	    	}else{
	    		xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    		xlsheet.cells(Rows+10,Cols+1)="体检电话:";
	    	}
		}
	    if(j==0){
		    xlsheet.printout;
            for(m=1;m<40;m++){
	            for(n=1;n<20;n++){
		            xlsheet.cells(m,n)="";
		            }
	            }
		    }
	}
	
 	if(j!=0){
	 
	xlsheet.printout;
	} 	
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;

	idTmr   =   window.setInterval("Cleanup();",1); 
	
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
	
	
}

//团体打印单个人员体检凭条方法
function PrintTeamSelf_click()
{
	var iRowId=GetSelectADM();
	PrintGPerson_click(iRowId)
	
}

function PrintGPerson_click(iRowIDStr)
{
	
	try{
		
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
	
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

    var myDate = new Date();
    myDate.getFullYear();
    
  
   	var temprow=iRowIDStr.split("^");
   	if(temprow=="")
   	{
		alert("您没有选择任何一个人员!")
	   	return;
	} 
   	
   	
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i]);
	    //alert("row:"+row)
		var tempcol=row.split("^");
	    var j=(i+1)%6;
	    var Rows,Cols;
	    if (j==1){
	        Rows=0; 
	        Cols=0; 
	    }
	    if (j==2){
	        Rows=0;  
	        Cols=7; 		    
	    }
	    if (j==3){
	        Rows=12;  
	        Cols=0;    
	    }
	    if (j==4){
	        Rows=12; 
	        Cols=7; 	    
	    }
	    if (j==5){
	        Rows=24;  
	        Cols=0; 		    
	    }
	    if (j==0){
	   	    Rows=24;
	   	    Cols=7;
	    }
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //姓名
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //性别
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //年龄
	    //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //电话
	    xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; ///体检号
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //编号或条码
	    xlsheet.cells(Rows+6,Cols+3)=tempcol[9] //PIADMName; //单位名称
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //所属部门
	    
		    
		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年"+HospitalName+"体检凭条";
	   
	    //xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年北京协和医院体检中心体检凭条";
	    xlsheet.cells(Rows+2,Cols+1)="姓名:";
	    xlsheet.cells(Rows+2,Cols+3)="性别:";
	    xlsheet.cells(Rows+2,Cols+5)="年龄:";
	    xlsheet.cells(Rows+3,Cols+1)="体检号:";
	    xlsheet.cells(Rows+4,Cols+1)="编号(或编码):";
	    xlsheet.cells(Rows+6,Cols+1)="单位名称：";
	    xlsheet.cells(Rows+7,Cols+1)="所属部门:";
	    xlsheet.cells(Rows+8,Cols+1)="★注:抽血时间:上午8:00---9:30";
	   if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    	xlsheet.cells(Rows+10,Cols+1)="体检电话:";    
		    
		}
		else
		{
	    if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    		xlsheet.cells(Rows+10,Cols+1)="体检电话:";
	    	}else{
	    		xlsheet.cells(Rows+9,Cols+1)="体检地址:";
	    		xlsheet.cells(Rows+10,Cols+1)="体检电话:";
	    	}
		}
	    if(j==0){
		    
		    xlsheet.printout;
            for(m=1;m<40;m++){
	            for(n=1;n<20;n++){
		            xlsheet.cells(m,n)="";
		            }
	            }
		    }
	}

 	if(j!=0){
	 
	xlsheet.printout;
	} 	
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;

	idTmr   =   window.setInterval("Cleanup();",1); 	
}
catch(e)
	{
		alert(e+"^"+e.message);
	}	
}


function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
 
}
//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	if(""==$.trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	//reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/;
	reg=/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/;
	
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
	
}
$(init);
