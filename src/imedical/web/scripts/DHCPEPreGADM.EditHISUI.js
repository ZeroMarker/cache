//���� DHCPEPreGADM.EditHISUI.jS
//���� ����ԤԼhisui
//���� 
//������ yp

var BNewWin = function(){
	
	setValueById("PGTRowId","")
	setValueById("PGTChildSub","")
	setValueById("TeamDesc","")

	$HUI.window("#NewWin",{
		title:"���������Ϣ",
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
	if (VIPLevelDesc=="ְҵ��"){
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
		title:"���ٷ���",
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
		if (VIPLevelDesc=="ְҵ��"){
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
	//	�������	PGADM_AddOrdItem	19
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
	//	����������	PGADM_AddOrdItemLimit	20
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
	
	//	���������	PGADM_AddOrdItemAmount	21
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
	
	//	�����ҩ	PGADM_AddPhcItem	22
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
	// PGADM_BookDateBegin	ԤԼ����
	//setValueById("RapidBookDateBegin",fillData)
	$("#RapidBookDateBegin").datebox('setValue',fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateEnd
	//setValueById("RapidBookDateEnd",fillData)
	$("#RapidBookDateEnd").datebox('setValue',fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookTime	ԤԼʱ��
	setValueById("RapidBookTime",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ԤԼ�Ӵ���Ա
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
	
	// PGADM_GReportSend ���屨�淢��
	setValueById("RapidGReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend ���˱��淢�� 
	setValueById("RapidIReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode ���㷽ʽ
	setValueById("RapidDisChargedMode",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
    
    //VIP
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //Ĭ������������
    
    setValueById("RapidPatFeeTypeName",fillData)
	
	
	return true;
	
	
	
}

function SetParRefData(value) {

	var obj;
	var fillData;
	var Data=value.split("^");
	var iLLoop=4;	
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	ԤԼ����
	setValueById("TeamBookDateBegin",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateEnd
	setValueById("TeamBookDateEnd",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookTime	ԤԼʱ��
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	setValueById("TeamPEDeskClerkNameID",fillData)
	// PGADM_AuditUser_DR	ԤԼ�Ӵ���Ա
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
	
	// PGADM_GReportSend ���屨�淢��
	setValueById("TeamGReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend ���˱��淢�� 
	setValueById("TeamIReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode ���㷽ʽ
	setValueById("TeamDisChargedMode",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
    
    //VIP
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //Ĭ������������
    
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
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){
		
		if (SelectIds==""){
				SelectIds=selectrow[i].PIADM_RowId;
			}else{
				SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
			} 
	}
	/*
	if(selectrow.length>=2){
		$.messager.alert("��ʾ","ֻ��ѡ��һ��ת��","info");
		return false;
		}
	*/
	if(SelectIds=="")
	{ 
		$.messager.alert("��ʾ","��ѡ���ת����Ա","info");
		return false;
	}
    var iRowId=SelectIds;


	//if (!confirm("�Ƿ�ȷ��ת��")) return false;
	//$.messager.confirm("ȷ��", "�Ƿ�ȷ��ת��", function(r){if (!r) { return false; }});
	$.messager.confirm("ȷ��", "�Ƿ�ȷ��ת�飿", function(r){
		if (r){
			
				var flag=tkMakeServerCall("web.DHCPE.CancelPE","CheckIAdmCanCancel",iRowId);
				if(flag=="1") {
					$.messager.alert("��ʾ","������ִ�л����ѽ��ѵ���Ŀ,����ת��","info");
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
				//websys_lu(lnk,false,'width=800,height=700,hisui=true,title=�����б�')
	
			}
	});
	
		
	
}
var init = function(){
	
	
	SetButtonDisable();
	LoadCard();
	
	if((OperType)&&(OperType=="T"))
	{$('#GroupTab').tabs('select',"�������");}
	
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
			
  			$('#GroupTab').tabs('select',"�������");
		});

	$('#GroupTab').tabs({
    
    	onSelect:function(title,index){
        	if(title=="�������")
        	{
				$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
	
	        	
	        }
    	}
	});
	//ת��
	$("#BMoveTeam").click(function(){
  			BMoveTeam_Click();
		});

	   //���ٷ���
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
		
	//����
	$("#TeamClear").click(function(){
  			TeamClear();
		});
	
	//��ΪԤ��		
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
		textField:'����',
		onBeforeLoad:function(param){
			
			param.Desc = param.q;
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'����',title:'����',width:100},
			{field:'����',title:'����',width:200}
			
			
			
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
			{field:'TID',title:'����',
			formatter:function(value,row,index){
					return "<a href='#' onclick='DelGTeamTemp(\""+row.TID+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
					</a>";
			}},
			{field:'TAgeFrom',title:'��������'},
			{field:'TAgeTo',title:'��������'},
			{field:'TSex',hidden:true},
			{field:'THouse',hidden:true},
			{field:'TDesc',title:'��������'},
			{field:'TSexDesc',title:'�Ա�'},
			{field:'THouseDesc',title:'����'}
					
		]],
		onClickRow:function(rowIndex,rowData){
			
			setValueById("TeamDesc",rowData.TDesc)
			setValueById("UpperLimit",rowData.TAgeFrom)
			setValueById("LowerLimit",rowData.TAgeTo)
			SexDesc=rowData.TSexDesc
			if(SexDesc=="��"){
				$HUI.radio("#TeamSexM").setValue(true);
			}else if(SexDesc=="Ů"){
				$HUI.radio("#TeamSexF").setValue(true);
			}else{
				$HUI.radio("#TeamSexN").setValue(true);
			}
			MarryDesc=rowData.THouseDesc
			if(MarryDesc=="δ��"){
				$HUI.radio("#TeamMarriedUM").setValue(true);
			}else if(MarryDesc=="�ѻ�"){
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
			{field:'Sequence',title:'���',checkbox:true},
			
			{field:'PIADM_PIBI_DR',title:'ԤԼ�޸�',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='GIAdmEdit(\""+row.PIADM_RowId+"^"+row.PIADM_PIBI_DR_RegNo+"^"+row.PIADM_PIBI_DR_Name+"^"+row.PIADM_PEDateBegin+"^"+row.PIADM_PETime+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>";
			}},
			
			{field:'PIADM_RowId',title:'��ѯ��Ŀ',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='CheckItem(\""+row.PIADM_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
					</a>";
			}},
			{field:'BaseInfo',title:'������Ϣ',align:'center',
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
			{field:'Amount',title:'���'},
			{field:'PIADM_PIBI_DR_RegNo',title:'�ǼǺ�'},
			{field:'PIADM_PIBI_DR_Name',title:'����'},
			{field:'PIADM_PGADM_DR',hidden:true},
			{field:'PIADM_PGADM_DR_Name',hidden:true},
			{field:'PIADM_PGTeam_DR',hidden:true},
			{field:'PIADM_PGTeam_DR_Name',hidden:true},
			{field:'PIADM_PEDateBegin',title:'�������'},
			{field:'PIADM_PEDateEnd',title:'��������'},
			{field:'PIADM_PETime',hidden:true},
			{field:'PIADM_PEDeskClerk_DR',hidden:true},
			{field:'PIADM_PEDeskClerk_DR_Name',title:'�Ӵ���'},
			{field:'PIADM_Status',hidden:true},
			{field:'PIADM_Status_Desc',title:'״̬'},
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
			{field:'PIADM_AddOrdItem',title:'���Ѽ���'},
			{field:'PIADM_AddOrdItemLimit',hidden:true},
			{field:'PIADM_AddOrdItemAmount',hidden:true},
			{field:'PIADM_AddPhcItem',title:'��ҩ'},
			{field:'PIADM_AddPhcItemLimit',hidden:true},
			{field:'PIADM_AddPhcItemAmount',hidden:true},
			{field:'PIADM_IReportSend',hidden:true},
			{field:'PIADM_IReportSend_Desc',hidden:true},
			{field:'PIADM_DisChargedMode',hidden:true},
			{field:'PIADM_DisChargedMode_Desc',title:'���㷽ʽ'},
			{field:'PIADM_VIP',hidden:true},
			{field:'PIADMRemark',hidden:true},
			{field:'TArriveDate',title:'����ʱ��'},
			{field:'TType',title:'ְ��'},
			{field:'TNewHPNo',title:'����'},
			{field:'PACCardDesc',title:'֤������'},
			{field:'IDCard',title:'֤����'},
			{field:'TPosition',title:'����',
			formatter:function(value,row,index){
					return tkMakeServerCall("web.DHCPE.PreCommon","GetPosition","PreADM",row.PIADM_RowId);
			}},
			{field:'TRoomPlace',title:'����λ��',
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
			{field:'GroupID',title:'����ID',hidden:true},
			{field:'PGT_RowId',title:'����ID',hidden:true},
			{field:'PGT_ChildSub',title:'����',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='PreTeamEdit(\""+row.PGT_ChildSub+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>";
			}},
			{field:'PGT_ParRef_Name',title:'��������',hidden:true},
			{field:'PGT_Desc',title:'��������'},
			{field:'teamcheckitem',title:'��ѯ��Ŀ',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='CheckTeamItem(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
					</a>";
			}},
			{field:'PGTSex',title:'Sex',hidden:true},
			{field:'PGT_Sex_Desc',title:'�Ա�'},
			{field:'PGT_UpperLimit',title:'��������'},
			{field:'PGT_LowerLimit',title:'��������'},
			{field:'PGTMarried',title:'Married',hidden:true},
			{field:'PGT_Married_Desc',title:'����'},
			{field:'PGTUpdateUserDR',title:'UserID',hidden:true},
			{field:'PGT_UpdateUser_DR_Name',title:'������',hidden:true},
			{field:'PGT_UpdateDate',title:'����ʱ��',hidden:true},
			{field:'PGT_AddOrdItem',title:'���Ѽ���'},
			{field:'PGT_AddOrdItemLimit',title:'����������',hidden:true},
			{field:'PGT_AddOrdItemAmount',title:'������',hidden:true},
			{field:'PGT_AddPhcItem',title:'�����ҩ'},
			{field:'PGT_AddPhcItemLimit',title:'��ҩ�������',hidden:true},
			{field:'PGT_AddPhcItemAmount',title:'��ҩ���',hidden:true},
			{field:'PGTGReportSend',title:'GSend',hidden:true},
			{field:'PGT_GReportSend_Name',title:'���屨�淢��',hidden:true},
			{field:'PGTIReportSend',title:'ISend',hidden:true},
			{field:'PGT_IReportSend_Name',title:'���˱��淢��',hidden:true},
			{field:'PGTDisChargedMode',title:'Mode',hidden:true},
			{field:'PGT_DisChargedMode_Name',title:'���㷽ʽ'},
			{field:'PGT_BookDateBegin',title:'ԤԼ��ʼ����'},
			{field:'PGT_BookDateEnd',title:'ԤԼ��ֹ����'},
			{field:'PGT_BookTime',title:'ԤԼʱ��',hidden:true},
			{field:'PGTPEDeskClerkDR',title:'PEDeskClerk',hidden:true},
			{field:'PGT_PEDeskClerk_DR_Name',title:'�Ӵ���',hidden:true},
			{field:'TTotalPerson',title:'����'},
			{field:'THadChecked',title:'�Ѽ�����',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='HadCheckedList(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
					</a>";
			}},
			{field:'TNoCheckDetail',title:'δ������',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='NoCheckedList(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
					</a>";
			}},
			{field:'TCancelPEDetail',title:'ȡ���������',align:'center',
			formatter:function(value,row,index){
					return "<a href='#' onclick='CancelPEList(\""+row.PGT_RowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
					</a>";
			}},

			{field:'TRoomPlace',title:'����λ��',
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
			{field:'GBI_Code',title:'�������',width:100},
			{field:'GBI_Desc',title:'��������',width:200}
			
			
			
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
		idField:'����',
		textField:'����',
		onBeforeLoad:function(param){
			param.Name = param.q;
		},
		onClickRow:function(rowIndex,rowData){
			
	
			setValueById("RegNo",rowData.�ǼǺ�)
			setValueById("PIBI_RowId",rowData.����)
			$("#BNewIADM").linkbutton('enable');
		
		},
		columns:[[
			{field:'����',title:'����',width:80},
			{field:'�ǼǺ�',title:'�ǼǺ�',width:100},
			{field:'����',title:'����',width:120}
			
			
			
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
		textField:'����',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'����',title:'����',width:100},
			{field:'����',title:'����',width:200}
			
			
			
		]]
	});
	
	
	var PEDeskClerkNameObj = $HUI.combogrid("#PEDeskClerkName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
		mode:'remote',
		delay:200,
		idField:'HIDDEN',
		textField:'����',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
			{field:'HIDDEN',hidden:true},
			{field:'����',title:'����',width:100},
			{field:'����',title:'����',width:200}
			
			
			
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
			{field:'TNo',title:'��ͬ���',width:100},
			{field:'TName',title:'��ͬ����',width:100},
			{field:'TSignDate',title:'ǩ������',width:100},
			{field:'TRemark',title:'��ע',width:100},
			{field:'TCreateDate',title:'¼������',width:100},
			{field:'TCreateUser',title:'¼����',width:100}
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
		$.messager.alert("��ʾ","δ�ҵ���¼","info");
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
		//	PIBI_PAPMINo	�ǼǺ�	1
		setValueById("PIBI_RowId","")
		setValueById("RegNo","")
		
		alert("��Ч�ǼǺ�!");
		
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
				 $.messager.popover({msg: "��Ч�ͻ���Ϣ", type: "info"});
				//alert("��Ч�ͻ���Ϣ");
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
			$.messager.alert("��ʾ", "����Ա���ڸ��ˣ����ڸ���ԤԼ���������", "info")
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
		$.messager.alert("��ʾ","����ѡ������¼","info"); 
		return false;
	} 
	else{
		$.messager.confirm("ȷ��", "�Ƿ�ȷ��ɾ���÷���", function(r){
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
				
				//ɾ��������������Աʱ��������
				if ("IADM Err"==Errs[0]) {
					$.messager.alert("��ʾ","��Ա�ǼǼ�¼ɾ������"+Errs[1],"info"); 
					
				}
				
				//ɾ��������ʱ��������
				if ("GTeam Err"==Errs[0]) {
					$.messager.alert("��ʾ","�������¼ɾ������"+Errs[1],"info"); 
					
				}
				
				if ("2"==Errs[0]) {
					$.messager.alert("��ʾ","������������Ա","info"); 
					
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
		
		$.messager.confirm("ȷ��", "����������ԤԼ���Ƿ��ٴ�ԤԼ��", function(data){	
		if (data) {
		}
		else{
				Clear_click();
			
			}
		}
			
		);
	}
	//�Ǽ���Ϣ
	var PreGADMData=Data[1];
	if (""!=PreGADMData) { SetPreGADM(PreGADMData); }
	
	//������Ϣ
	var PreGBaseGnfoData=Data[0];
	
	if (""!=PreGBaseGnfoData) { SetPreGBaseInfoSelect(PreGBaseGnfoData) }

		
}


function SetPatient_Sel(value) {
	
	
	//Clear_click();

	var obj;
	var Data=value.split(";");
	
	var IsShowAlert=Data[2];
	
	if ("Y"==IsShowAlert) {
		
		
		
		$.messager.confirm("ȷ��", "����������ԤԼ���Ƿ��ٴ�ԤԼ��", function(data){	
		if (data) {
		}
		else{
				Clear_click();
			
			}
		}
			
		);
		
		
	}
	
	//�Ǽ���Ϣ
	var PreGADMData=Data[1];
	if ((""!=PreGADMData)&&(PreGADMData.split("^")[0]!=0)) { SetPreGADM(PreGADMData); }
	
	//������Ϣ
	var PreGBaseGnfoData=Data[0];
	
	if ((""!=PreGBaseGnfoData)&&(PreGBaseGnfoData.split("^")[0]!=0)) { SetPreGBaseInfo(PreGBaseGnfoData) }

		
}
//�Ǽ���Ϣ
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
	
	
	//��ͬ�շ� PIADM_AsCharged
	
	if (Default)
	{
		if ((Default=="2")||(Default=="3")){setValueById("AsCharged",true)}
		else{
			setValueById("AsCharged",false)
			}
			
		
	}
		
	
	if ('0'==iRowId) { return true; }
	
	
	//����ADM 0
	setValueById("PGADM_RowId",iRowId)

	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_PGBI_DR	Ԥ����ͻ�RowId 2
	setValueById("PGBI_RowId",fillData)

	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_BookDateBegin	ԤԼ���� 4
	setValueById("BookDateBegin",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookDateEnd 29
	setValueById("BookDateEnd",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_BookTime	ԤԼʱ�� 5
	setValueById("BookTime",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ԤԼ�Ӵ���Ա 16
	//setValueById("PEDeskClerkName",fillData)
	$("#PEDeskClerkNameID").val(fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	$("#PEDeskClerkName").combogrid('setValue',fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Status	״̬ 8
	setValueById("Status",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
		
	// PGADM_AsCharged	��ͬ�շ� 3
	
	
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
	
	// PGADM_GReportSend ���屨�淢�� 26
	setValueById("GReportSend",fillData);
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_IReportSend ���˱��淢�� 27
	setValueById("IReportSend",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	// PGADM_DisChargedMode ���㷽ʽ 28
	setValueById("DisChargedMode",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_DelayDate
	setValueById("DelayDate",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	// PGADM_Remark	��ע 6
	setValueById("Remark",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	
	setValueById("PAPMINo",fillData)
	iLLoop=iLLoop+3;
	fillData=Data[iLLoop];
	// PGADM_PEDeskClerk_DR ԤԼ�Ӵ���Ա 15
	setValueById("Sales",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];

	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 31
	setValueById("Type",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 32
	setValueById("GetReportDate",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 33
	setValueById("GetReportTime",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 33
	setValueById("PayType",fillData)
	
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// PGADM_AuditUser_DR	ҵ��Ա 33
	setValueById("Percent",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	������� ����ȡ�ƷѼ۸�
	setValueById("PatFeeTypeName",fillData)
	
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	��ͬID
	setValueById("Contract",fillData)
	iLLoop=iLLoop+1;
	fillData=Data[iLLoop];
	// 	��ͬ����
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
	//	�����ҩ	
	if ("Y"==Data[iLLoop]) {
		setValueById("TeamAddPhcItem",true);
	}
	
	
	iLLoop=iLLoop+1;	
	
	
}
function SetAddItem(value) {
	
	var Data=value.split("^");
	var iLLoop=0;	
	
	var iAddOrdItem=false;
	
	//	�������	PGADM_AddOrdItem	19
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
	//	����������	PGADM_AddOrdItemLimit	20
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
	
	//	���������	PGADM_AddOrdItemAmount	21
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
	
	//	�����ҩ	PGADM_AddPhcItem	22
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
	

		//��λ����	PGBI_Code	1
		
		setValueById("GroupCode",Data[iLLoop])
		iLLoop=iLLoop+1;
		//��    ��	PGBI_Desc	2
		$("#GroupDesc").combogrid("setText",Data[iLLoop])
	
		return false;
	}

	
	setValueById("PGBI_RowId",iRowId)
	//��λ����	PGBI_Code	1
	setValueById("GroupCode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Desc	2
	
	
	iLLoop=iLLoop+1;
	//��    ַ	PGBI_Address	3
	setValueById("Address",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��������	PGBI_Postalcode	4
	setValueById("Postalcode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��ϵ��	PGBI_Linkman	5
	setValueById("Linkman",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//ҵ������	PGBI_Bank	6
	setValueById("Bank",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Account	7
	setValueById("Account",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//��ϵ�绰1	PGBI_Tel1	8
	setValueById("Tel1",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��ϵ�绰2	PGBI_Tel2	9
	setValueById("Tel2",Data[iLLoop])

	iLLoop=iLLoop+1;
	//�����ʼ�	PGBI_Email	10
	setValueById("Email",Data[iLLoop])
	
	iLLoop=iLLoop+3;
	//�����ʼ�	PGBI_PAPMINo	10
	setValueById("PAPMINo",Data[iLLoop])
	iLLoop=iLLoop+2;
	//	CardNo	10
	setValueById("CardNo",Data[iLLoop])
	
	return true;
	
	
	
	
}

//������Ϣ
function SetPreGBaseInfo(value) {

	var obj;
	
	var Data=value.split("^");
	var iLLoop=0;

	var iRowId=Data[iLLoop];	
	
	iLLoop=iLLoop+1;
	if ("0"==iRowId) {
	

		//��λ����	PGBI_Code	1
		
		setValueById("GroupCode",Data[iLLoop])
		iLLoop=iLLoop+1;
		//��    ��	PGBI_Desc	2
		$("#GroupDesc").combogrid("setText",Data[iLLoop])
	
		return false;
	}

		
	setValueById("PGBI_RowId",iRowId)
	//��λ����	PGBI_Code	1
	setValueById("GroupCode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Desc	2
	setValueById("GroupDesc",iRowId)
	//$("#GroupDesc").combogrid("setText",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//��    ַ	PGBI_Address	3
	setValueById("Address",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��������	PGBI_Postalcode	4
	setValueById("Postalcode",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��ϵ��	PGBI_Linkman	5
	setValueById("Linkman",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//ҵ������	PGBI_Bank	6
	setValueById("Bank",Data[iLLoop])
	

	iLLoop=iLLoop+1;
	//��    ��	PGBI_Account	7
	setValueById("Account",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//��ϵ�绰1	PGBI_Tel1	8
	setValueById("Tel1",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��ϵ�绰2	PGBI_Tel2	9
	setValueById("Tel2",Data[iLLoop])

	iLLoop=iLLoop+1;
	//�����ʼ�	PGBI_Email	10
	setValueById("Email",Data[iLLoop])
	
	iLLoop=iLLoop+3;
	//�����ʼ�	PGBI_PAPMINo	10
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
	
	// PGADM_RowId	����ADM 1
	
	
	iRowId=getValueById("PGADM_RowId")
	if(iRowId=="0") {var iRowId="";}
	
	// PGADM_PGBI_DR	Ԥ����ͻ�RowId 2
	iPGBIDR=getValueById("PGBI_RowId")
	
	
	if (($("#GroupDesc").combogrid('getValue'))==($("#GroupDesc").combogrid('getText'))||(($("#GroupDesc").combogrid('getText')=="")))  {
		$.messager.alert("��ʾ","��������ѡ����ȷ��","info");
		return false;
	}
	
	
	// PGADM_BookDateBegin	ԤԼ���� 4
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
		$.messager.alert('��ʾ','�����ʼ���ڲ���С��1840��!',"info"); 
		return false;
	}
	if(EndYear<1840){
		$.messager.alert('��ʾ','��ֹ���ڲ���С��1840��!',"info"); 
		return false;
	}
	// PGADM_BookTime	ԤԼʱ�� 5
	iBookTime=getValueById("BookTime")
	
	// PGADM_AuditUser_DR	ԤԼ�Ӵ���Ա 16
	iPEDeskClerkDR=$("#PEDeskClerkName").combogrid("getValue")
	if (($("#PEDeskClerkName").combogrid('getValue')==undefined)||($("#PEDeskClerkName").combogrid('getText')=="")){var iPEDeskClerkDR="";}
	/*if(iPEDeskClerkDR!="")
	{
	if (($("#PEDeskClerkName").combogrid('getValue'))==($("#PEDeskClerkName").combogrid('getText')))  {
		$.messager.alert("��ʾ","�Ӵ���ѡ����ȷ��","info");
		return false;
	}
	}
	*/
	   var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(iPEDeskClerkDR)))&&(iPEDeskClerkDR!="")){var iPEDeskClerkDR=$("#PEDeskClerkNameID").val();}

   
	// PGADM_Status	״̬ 8
	iStatus=getValueById("Status")
	
		
	// PGADM_AsCharged	��ͬ�շ� 3
	iAsCharged=getValueById("AsCharged")
	if (iAsCharged) { iAsCharged="Y"; }
	else { iAsCharged="N"; }
	// PGADM_AddOrdItem ������� 20
	iAddOrdItem=getValueById("AddOrdItem")
	if (iAddOrdItem) { iAddOrdItem='Y'; }
	else { iAddOrdItem='N';}
	
	// PGADM_AddOrdItemLimit ���������� 21
	iAddOrdItemLimit=getValueById("AddOrdItemLimit")
	if (iAddOrdItemLimit) { iAddOrdItemLimit='Y'; }
	else { iAddOrdItemLimit='N';}
	// PGADM_AddOrdItemAmount ��������� 22
	iAddOrdItemAmount=getValueById("AddOrdItemAmount")
	
	
	if((iAddOrdItemLimit=="Y")&&(iAddOrdItemAmount=="")){
		$.messager.alert('��ʾ','���Ƽ�����ʱ�����������Ϊ�գ�',"info");
		  return false;
	}
	
	if((iAddOrdItemAmount!="")&&(iAddOrdItemAmount<=0)){
		$.messager.alert('��ʾ','������Ӧ����0',"info");
		  return false;
	}
	
	

	 if(!IsFloat(iAddOrdItemAmount)){
		  $.messager.alert('��ʾ','����������ʽ����ȷ',"info");
		  return false;
	  }
	if((iAddOrdItemAmount!="")&&(iAddOrdItemAmount.indexOf(".")!="-1")&&(iAddOrdItemAmount.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","������С������ܳ�����λ","info");
			return false;
		}

	// PGADM_AddPhcItem �����ҩ 23
	iAddPhcItem=getValueById("AddPhcItem")
	if (iAddPhcItem) { iAddPhcItem='Y'; }
	else { iAddPhcItem='N';}
	// PGADM_AddPhcItemLimit ��ҩ������� 24
	iAddPhcItemLimit=getValueById("AddPhcItemLimit")
	if (iAddPhcItemLimit) { iAddPhcItemLimit='Y'; }
	else { iAddPhcItemLimit='N';}
	//  PGADM_AddPhcItemAmount�����ҩ��� 25
	iAddPhcItemAmount=getValueById("AddPhcItemAmount")

	// PGADM_GReportSend ���屨�淢�� 26
	iGReportSend=getValueById("GReportSend")
	
	// PGADM_IReportSend ���˱��淢�� 27
	iIReportSend=getValueById("IReportSend")
	
	// PGADM_DisChargedMode ���㷽ʽ 28
	iDisChargedMode=getValueById("DisChargedMode")
	
	// PGADM_DelayDate
	iDelayDate=getValueById("DelayDate")
	if(iDelayDate!=""){
		var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iBookDateBegin)
		var iDelayDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDelayDate)
		
		if(iDelayDateLogical<BookDateBeginLogical){
			$.messager.alert("��ʾ","�������ڲ������������ʼ����","info");
			return false;
		}
	}
	

	
	// PGADM_Remark	��ע 29
	iRemark=getValueById("Remark")
	
	
	// PGADM_AuditUser_DR	ҵ��Ա 30
	Sales=$("#Sales").combogrid("getValue")
	if (($("#Sales").combogrid('getValue')==undefined)||($("#Sales").combogrid('getText')=="")){var Sales="";}
	if(Sales!="")
	{
	if (($("#Sales").combogrid('getValue'))==($("#Sales").combogrid('getText')))  {
		$.messager.alert("��ʾ","ҵ��Աѡ����ȷ��","info");
		return false;
	}
	}
	
	// ����	ҵ��Ա 31
	Type=getValueById("Type")
	
	
	// ȡ��������	ҵ��Ա 32
	GetReportDate=getValueById("GetReportDate")
	
	if(GetReportDate!=""){
		var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iBookDateBegin)
		var GetReportDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",GetReportDate)
		
		if(GetReportDateLogical<=BookDateBeginLogical){
			$.messager.alert("��ʾ","ȡ��������Ӧ���������ʼ����","info");
			return false;
		}
	}

	//iBookDateBegin=getValueById("BookDateBegin")
	
	// ȡ����ʱ��	ҵ��Ա 33
	GetReportTime=getValueById("GetReportTime")
	
	// ��������	ҵ��Ա 33
	PayType=getValueById("PayType")
	
	// �ٷֱ�	ҵ��Ա 33
	Percent=getValueById("Percent")
	
	// �Ͳͱ�־	ҵ��Ա 33
	var iDietFlag=getValueById("DietFlag")
	if (!iDietFlag) { DietFlag="0"; }	
	//��Ʒ��־	ҵ��Ա 33
	var iGiftFlag=getValueById("GiftFlag")
	if (iGiftFlag) { GiftFlag="1";}
	//������������ȡ�۸�
	PatFeeType=getValueById("PatFeeTypeName")
	
	//������ͬ
	Contract=$("#Contract").combogrid("getValue")
	if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getText')=="")){var Contract="";}
	if(Contract!="")
	{
	if (($("#Contract").combogrid('getValue'))==($("#Contract").combogrid('getText')))  {
		$.messager.alert("��ʾ","��ͬѡ����ȷ��","info");
		return false;
	}
	}
	
	
	var Instring= trim(iRowId)					// 1
				+"^"+trim(iPGBIDR)				// 2	PGADM_PGBI_DR	Ԥ����ͻ�
				+"^"+trim(iBookDateBegin)		// 3	PGADM_BookDateBegin	ԤԼ����
				+"^"+trim(iBookDateEnd)			// 4	PGADM_BookDateEnd
				+"^"+trim(iBookTime)			// 5	PGADM_BookTime	ԤԼʱ��
				+"^"+trim(iPEDeskClerkDR)		// 6	PGADM_PEDeskClerk_DR	ԤԼ�Ӵ���Ա
				+"^"+trim(iStatus)				// 7	PGADM_Status	״̬
				+"^"+trim(iAsCharged)			// 8	PGADM_AsCharged	��ͬ�շ�
				+"^"+trim(iAddOrdItem)			// 9	PGADM_AddOrdItem �������
				+"^"+trim(iAddOrdItemLimit)		// 10	PGADM_AddOrdItemLimit ����������
				+"^"+trim(iAddOrdItemAmount)	// 11	PGADM_AddOrdItemAmount ���������
				+"^"+trim(iAddPhcItem)			// 12	PGADM_AddPhcItem �����ҩ
				+"^"+trim(iAddPhcItemLimit)		// 13	PGADM_AddPhcItemLimit ��ҩ�������
				+"^"+trim(iAddPhcItemAmount)	// 14	PGADM_AddPhcItemAmount�����ҩ���
				+"^"+trim(iGReportSend)			// 15	PGADM_GReportSend ���屨�淢��
				+"^"+trim(iIReportSend)			// 16	PGADM_IReportSend ���˱��淢��
				+"^"+trim(iDisChargedMode)		// 17	PGADM_DisChargedMode ���㷽ʽ
				+"^"+trim(iDelayDate)           // 18	PGADM_DelayDate ��������
				+"^"+trim(iRemark)				// 19	PGADM_Remark	��ע	
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
		$.messager.alert("��ʾ","�������ڲ������ڿ�ʼ����","info");
		return false;
	}
	
	if (flag=="Err HomeDate")
	{
		$.messager.alert("��ʾ","�������ڲ���С��������������","info");
		return false;
	}
	if (flag=="Err GetReportDate")
	{
		$.messager.alert("��ʾ","ȡ�������ڲ���С�ڽ���","info");
		return false;
	}

 
	if (""==iRowId) { //������� ���� RowId
		var Rets=flag.split("^");
		flag=Rets[0];
		// PGADM_RowId	����ADM 1
		setValueById("PGADM_RowId",Rets[1])
		setValueById("ID",Rets[1])
		GroupID=Rets[1]
	}

	if ('0'==flag) {
		
		if (""==iRowId) { 
			$.messager.alert("��ʾ","ԤԼ�ɹ�","success");
		}
		else { 
			$.messager.alert("��ʾ","���³ɹ�","success");
		 }
	
		if (""==iRowId) { //ˢ��ҳ��
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
		$.messager.alert("��ʾ","�����ѵǼ�","info");
		return false;		
	}
	else if ('Err 05'==flag) {
		$.messager.alert("��ʾ","¼�Ѳ���Ԥ�Ǽ�״̬,�����޸�","info");
		return false;		
	}		
	else {
		$.messager.alert("��ʾ","���´��� �����:"+flag,"info");
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
	
	
	//��ͬ�շ� PIADM_AsCharged
	
	if (Default)
	{
		if ((Default=="2")||(Default=="3")){setValueById("AsCharged",true)}
		else{
			setValueById("AsCharged",false)
			}
			
		
	}
	LoadCard();
}

//  �������(PGADM_AddOrdItem)
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
// PGADM_AddOrdItemLimit ���������� 
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

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//����Ϊ��
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
	
	//����ADM	PGT_ParRef
	OneData=getValueById("ID")
	
	if ((""==OneData)||("0"==OneData)) {
		
		 $.messager.alert("��ʾ","��Ч����","info");
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

	//��������	PGT_Desc
	OneData=getValueById("TeamDesc") 
	if (""==OneData) {
		
	$.messager.alert("��ʾ","�������Ʋ���Ϊ��","info"); 
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
	
	//ԤԼʱ�� PGT_BookTime
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//ԤԼ�Ӵ�Ա PGT_PEDeskClerk_DR
	OneData=$("#TeamPEDeskClerkName").combogrid("getValue")
	if (($("#TeamPEDeskClerkName").combogrid('getValue')==undefined)||($("#TeamPEDeskClerkName").combogrid('getText')=="")){var OneData="";}
	var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(OneData)))&&(OneData!="")){var OneData=$("#TeamPEDeskClerkNameID").val();}

	DataStr=DataStr+"^"+OneData
	OneData=""	
	
	// PGT_AddOrdItem ���Ѽ���
	
	iAddOrdItem=getValueById("TeamAddOrdItem")
	if (iAddOrdItem) { OneData='Y'; }
	else { OneData='N';}
	
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemLimit ����������
	iAddOrdItemLimit=getValueById("TeamAddOrdItemLimit")
	if (iAddOrdItemLimit) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemAmount ���Ѽ�����
	OneData=getValueById("TeamAddOrdItemAmount") 
	if ((iAddOrdItemLimit)&&(OneData=="")){
		$.messager.alert('��ʾ','���Ƽ�����ʱ�����������Ϊ��',"info");
		  	return false;
		
	}

	if((OneData!="")&&(OneData<=0)){
		$.messager.alert('��ʾ','������Ӧ����0',"info");
		  return false;
	}

	 if(!IsFloat(OneData)){
		  $.messager.alert('��ʾ','�������ʽ����ȷ',"info");
		  return false;
	  }
	if((OneData!="")&&(OneData.indexOf(".")!="-1")&&(OneData.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","������С������ܳ�����λ","info");
			return false;
		}

	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItem �����ҩ
	iAddPhcItem=getValueById("TeamAddPhcItem")
	if (iAddPhcItem) { OneData='Y'; }
	else { OneData='N';}
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItemLimit ��ҩ������� 
	OneData='N'
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//  PGT_AddPhcItemAmount�����ҩ���
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//�Ա�	PGT_Sex
	var checkedRadioObj = $("input[name='TeamSex']:checked");
	OneData=checkedRadioObj.val();
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//��������	PGT_UpperLimit
	OneData=getValueById("UpperLimit")
	if (OneData!=""){
		if(+OneData<0){
		  $.messager.alert("��ʾ","�������޲���С��0","info"); 
			websys_setfocus("UpperLimit"); 
			return false;
	  }

		if(!isInteger(OneData)) {
			$.messager.alert("��ʾ","�������޸�ʽ�Ƿ�","info"); 
			websys_setfocus("UpperLimit"); 
			return false;
	}
	}



	
	DataStr=DataStr+"^"+trim(OneData)
	OneData=""

	//��������	PGT_LowerLimit
	OneData=getValueById("LowerLimit")
	if (OneData!=""){
		if(+OneData<0){
		  $.messager.alert("��ʾ","�������޲���С��0","info"); 
			websys_setfocus("UpperLimit"); 
			return false;
	  }
		if(!isInteger(OneData)) {
			$.messager.alert("��ʾ","�������޸�ʽ�Ƿ�","info"); 
			websys_setfocus("LowerLimit"); 
			return false;
	}
	}



	var iUpperLimit=parseFloat($("#UpperLimit").val())
	var iLowerLimit=parseFloat($("#LowerLimit").val())
	if(iUpperLimit<iLowerLimit){
		$.messager.alert("��ʾ","�������޲��ܴ�������","info");		
		return false;
	}

	DataStr=DataStr+"^"+trim(OneData)
	OneData=""

	//����״��	PGT_Married
	
	var checkedRadioObj = $("input[name='TeamMarried']:checked");
	OneData=checkedRadioObj.val();
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//VIP�ȼ�
	OneData=$("#VIPLevel").combogrid("getValue")
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	 
	// ����ȼ�
	 
	DataStr=DataStr+"^"+OneData
	OneData=""
    //���������� ���ڼƷѼ۸�
    OneData=$("#TeamPatFeeTypeName").combogrid("getValue")
   
	DataStr=DataStr+"^"+OneData
	//�Ƿ����������
	OneData=""
	iNoIncludeGroup=getValueById("NoIncludeGroup")
	if (iNoIncludeGroup) { OneData=1; }
	else { OneData="";}
	
	DataStr=DataStr+"^"+OneData;
	//���㷽ʽ
	OneData=""
	OneData=$("#TeamDisChargedMode").combogrid("getValue")
	
	DataStr=DataStr+"^"+OneData;
	//Σ������
	OneData=""
	var OccuId=$("#HarmInfo").combotree("getValues")
	var OneData=OccuId.join(",");



	DataStr=DataStr+"^"+OneData;
	
	//�������
	OneData=""
	OneData=$("#OMEType").combobox("getValue")
	

	DataStr=DataStr+"^"+OneData;

   //���λ��
	OneData=""
	OneData=$("#RoomPlace").combogrid("getValue")
	
	DataStr=DataStr+"^"+OneData;
	
	//alert(DataStr)
	
	var flag=tkMakeServerCall("web.DHCPE.PreGTeam","Save2","","",DataStr);
	
	if (flag=="Err Date")
	{
		 $.messager.alert("��ʾ","��������С�ڿ�ʼ����","info");
		return false;
	}
	if ('0'==flag) {
		
		$('#NewWin').window('close');
		$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
		
	}	
	else {
		$.messager.alert("��ʾ","���´��� �����:"+flag);
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
		//$.messager.alert("��ʾ","�������Ʋ���Ϊ��","info"); 
		//return false;
	}

	var iAgeDown=$("#LowerLimit").val();
	
	if(iAgeDown!="")
	{ 
	  if(+iAgeDown<0){
		  $.messager.alert("��ʾ","�������޲���С��0","info"); 
		websys_setfocus("LowerLimit"); 
		return false;
	  }
	  if(!(isInteger(iAgeDown))){
		   $.messager.alert("��ʾ","�������޸�ʽ�Ƿ�","info"); 
		websys_setfocus("LowerLimit"); 
		return false;
	  }
	}
	


	var iAgeUp=$("#UpperLimit").val();
	if(iAgeUp!="")
	{ 
	  if(+iAgeUp<0){
		  $.messager.alert("��ʾ","�������޲���С��0","info"); 
		websys_setfocus("UpperLimit"); 
		return false;
	  }
	  if(!(isInteger(iAgeUp))){
		   $.messager.alert("��ʾ","�������޸�ʽ�Ƿ�","info"); 
		websys_setfocus("UpperLimit"); 
		return false;
	  }
	}

	if(iAgeUp<iAgeDown){
		$.messager.alert("��ʾ","�������޲��ܴ�������","info"); 
		return false;
	}
	
	if(iAgeDown!="")  var iAgeDown=tkMakeServerCall("web.DHCPE.Cashier","Round",iAgeDown,0,5)
	if(iAgeUp!="")  var iAgeUp=tkMakeServerCall("web.DHCPE.Cashier","Round",iAgeUp,0,5)
	
	//�Ա� 
	var checkedRadioObj = $("input[name='TeamSex']:checked");
	var iSex=checkedRadioObj.val();
	
	//����״�� 
	var checkedRadioObj = $("input[name='TeamMarried']:checked");
	var iMarried=checkedRadioObj.val();
	
	var ret=1;
	var InStr=iDesc+'^'+iAgeUp+'^'+iAgeDown+'^'+iSex+'^'+iMarried;
	
	var ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet",InStr,"","Set"); 
	if (ret==0){
		$.messager.alert("��ʾ","����ɹ�","success"); 
		$("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",VIP:"",ToGID:"",GBID:"",TemplateFlag:"1"}); 
			
	}
	else{
		$.messager.alert("��ʾ","����ʧ��","error");
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
		$.messager.alert("��ʾ","�빴ѡ����","info");
		return false;	
	}
	var RapidEndDate=$("#RapidBookDateEnd").datebox('getValue');
	var RapidStartDate=$("#RapidBookDateBegin").datebox('getValue');
	var iRapidStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",RapidStartDate);
	var iRapidEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",RapidEndDate);
	
	if((iRapidStartDate!="")&&(iRapidEndDate!="")&&(iRapidEndDate<iRapidStartDate))
	{
		$.messager.alert("��ʾ","��������С�ڿ�ʼ����","info"); 
		return false;
	}
	if (OneData=="Team_One"){
		iTeamNum=1;
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="ȫ����Ա";
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
				iDesc="��";
	            iSex="M";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else
			{
				iDesc="Ů";
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
				iDesc="��";
	            iSex="M";
	            iMarried="N";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue; 
			}
			else if(i==1)
			{
				iDesc="Ůδ��";
	            iSex="F";
	            iMarried="UM";
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else 
			{
				iDesc="Ů�ѻ�";
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
				$.messager.alert("��ʾ","������޲���Ϊ��","info"); 
				return false;
				}
	    if (!(isInteger(iAge))||(iAge<0)) {
					$.messager.alert("��ʾ","�����ʽ�Ƿ�","info"); 
					return false;
				}	
		 if (iAge>100) {
					$.messager.alert("��ʾ","�������޲��ܳ���100","info"); 
					return false;
				}
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="�д��ڵ���"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==1)
			{
				iDesc="��С�ڵ���"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==2) 
			{
				iDesc="Ů���ڵ���"+iAge+"��";
	            iSex="F";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else
			{
				iDesc="ŮС�ڵ���"+iAge+"��";
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
				$.messager.alert("��ʾ","������޲���Ϊ��","info"); 
				return false;
				}
	    if (!(isInteger(iAge))||(iAge<0)) {
					$.messager.alert("��ʾ","�����ʽ�Ƿ�","info"); 
					return false;
				}	
		 if (iAge>100) {
					$.messager.alert("��ʾ","�������޲��ܳ���100","info"); 
					return false;
				}
		for (var i=0;i<iTeamNum;i++)
		{
			if(i==0)
			{
				iDesc="Ůδ��";
	            iSex="F";
	            iMarried="UM";
	            iAgeLow=""
	            iAgeHigh=""
	            
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==1)
			{
				iDesc="�д��ڵ���"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=iAge
	            iAgeHigh=100
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==2) 
			{
				iDesc="��С�ڵ���"+iAge+"��";
	            iSex="M";
	            iMarried="N";
	            iAgeLow=0
	            iAgeHigh=iAge
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
	            continue;
			}
			else if(i==3)
			{
				iDesc="Ů�ѻ���ڵ���"+iAge+"��";
	            iSex="F";
	            iMarried="M";
	            iAgeLow=iAge
	            iAgeHigh=100
				
	            save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum)
	            continue;
			}
			else
			{
				iDesc="Ů�ѻ�С�ڵ���"+iAge+"��";
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
	  $.messager.alert("��ʾ","��Ч����","info");
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

	//��������	PGT_Desc
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
	
	//ԤԼʱ�� PGT_BookTime
	OneData=getValueById("RapidBookTime")
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//ԤԼ�Ӵ�Ա PGT_PEDeskClerk_DR
	 
	DataStr=DataStr+"^"+OneData
	OneData=""	
	
	// PGT_AddOrdItem ���Ѽ���
	/*
	obj=document.getElementById("AddOrdItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[7];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemLimit ����������
	/*
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[8];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddOrdItemAmount ���Ѽ�����
	/*
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { OneData=obj.value; }
	*/
	OneData=PreGInfo[9];


	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItem �����ҩ
	/*
	obj=document.getElementById("AddPhcItem");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[10];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// PGT_AddPhcItemLimit ��ҩ�������
	/*
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && obj.checked) { OneData='Y'; }
	else { OneData='N';}
	*/
	OneData=PreGInfo[11];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//  PGT_AddPhcItemAmount�����ҩ���
	/*
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { OneData=obj.value; }
	*/
	OneData=PreGInfo[12];
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//�Ա�	PGT_Sex
	OneData=Sex
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//��������	PGT_UpperLimit
	OneData=AgeHigh
	DataStr=DataStr+"^"+OneData
	OneData=""

	//��������	PGT_LowerLimit
	OneData=AgeLow
	DataStr=DataStr+"^"+OneData
	OneData=""

	//����״��	PGT_Married
	OneData=Married
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//VIP�ȼ�
	OneData=$("#RapidVIPLevel").combogrid("getValue") 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	obj=document.getElementById("TeamLevel");
	if (obj) { OneData=obj.value; } 
	DataStr=DataStr+"^"+OneData
	OneData=""
	 
    //���������� ���ڼƷѼ۸�
    OneData=$("#RapidPatFeeTypeName").combogrid("getValue") 
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//�Ƿ����������
	OneData=""
	obj=document.getElementById("RapidNoIncludeGroup");
	if (obj&&obj.checked) { OneData=1; } 
	DataStr=DataStr+"^"+OneData;

	//���㷽ʽ
	OneData=$("#RapidDisChargedMode").combogrid("getValue") 
	
	DataStr=DataStr+"^"+OneData;
	
	
	var flag=tkMakeServerCall("web.DHCPE.PreGTeamNew","Save2","","",DataStr);
	
	
	if (flag=="Err Date")
	{
		$.messager.alert("��ʾ","��������С�ڿ�ʼ����","info"); 
		return false;
	}
	if ('0'==flag) {
		
		$('#RapidNewWin').window('close');
		$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
		
	}	
	else {
		
		$.messager.alert("��ʾ","���´��� ����ţ�"+flag,"error"); 
		return false;
	}

	return true;

}	
function BAddItem()
{
	var PreOrAdd="ADD"  //�Ƿ񹫷Ѽ���
	var iRowId=getValueById("PIADM_RowId")
	var iRowId=GetSelectADM();
	if(iRowId=="")
	{
		$.messager.alert("��ʾ", "��ѡ��һ���ͻ���Ϣ", "info");
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
	
	var PreOrAdd="PRE"  //�Ƿ񹫷Ѽ���
	var iRowId=getValueById("PIADM_RowId")
	var iRowId=GetSelectADM();
	if(iRowId=="")
	{
		$.messager.alert("��ʾ", "��ѡ��һ���ͻ���Ϣ", "info");
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

//������ԤԼ��Ա
function BCancelSelect()
{
	
	var SelectIds=""
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){
		
		if (SelectIds==""){
				SelectIds=selectrow[i].PIADM_RowId;
			}else{
				SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
			} 
	}
	if(selectrow.length>=2){
		$.messager.alert("��ʾ","ֻ��ѡ��һ�˳���","info");
		return false;
		}
	
	if(SelectIds=="")
	{ 
		$.messager.alert("��ʾ","��ѡ���������Ա","info");
		return false;
	}
	
	
	$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r){
		if (r){
			 var PreIADMDR=SelectIds
   
			var ret=tkMakeServerCall("web.DHCPE.SelectPreInfo","Cancel",PreIADMDR);
			var Arr=ret.split("^");
			if (Arr[0]==0){
				$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:getValueById("PGTRowId"),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
				$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
	    		$.messager.alert("��ʾ","�����ɹ�","success");
			}else{
				$.messager.alert("��ʾ",Arr[1],"info");
			}
			
		}
	}); 
	
}	


function BSelectPre()
{
	var Url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESelectPreInfo&&TeamID="+getValueById("PGTRowId");
	websys_lu(Url,false,'width=1020,height=545,hisui=true,title=�ϲ�������')


/*
	$HUI.window("#SelectPreInfoWin",{
		title:"�ϲ�������",
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
		title:"���������Ϣ",
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
	
	//����ADM	PGT_ParRef	1
	setValueById("",Data[iLLoop])
	
	iLLoop=iLLoop+1;
		
	//	PGT_RowId
	setValueById("",Data[iLLoop]) 
	iLLoop=iLLoop+1;
	//	PGT_ChildSub 3
	setValueById("",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//��������	PGT_Desc 4
	setValueById("TeamDesc",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateBegin	21
	setValueById("TeamBookDateBegin",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//	PGT_BookDateEnd	22
	setValueById("TeamBookDateEnd",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//ԤԼʱ�� PGT_BookTime 23
	
	iLLoop=iLLoop+1;
	
	// PGT_PEDeskClerk_DR 24
	setValueById("TeamPEDeskClerkName",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	
	var strLine="";
	//	���Ѽ���	PGT_AddOrdItem	12
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	

	//	����������	PGT_AddOrdItemLimit	13
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	
	//	���Ѽ�����	PGT_AddOrdItemAmount	14
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	�����ҩ	PGT_AddPhcItem	15
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;	
	
	//	��ҩ�������	PGT_AddPhcItemLimit	16
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;

	//	�����ҩ���	PGT_AddPhcItemAmount	17
	strLine=strLine+Data[iLLoop]+"^"; 
	iLLoop=iLLoop+1;
	SetTeamAddItem(strLine);
	
	//�Ա�	PGT_Sex 5
	
	if(Data[iLLoop]=="M")
	{$HUI.radio("#TeamSexM").setValue(true);}
	else if(Data[iLLoop]=="F")
	{$HUI.radio("#TeamSexF").setValue(true);}
	else
	{$HUI.radio("#TeamSexN").setValue(true);}
	
	iLLoop=iLLoop+1;
	//��������	PGT_UpperLimit 6
	setValueById("UpperLimit",Data[iLLoop])

	iLLoop=iLLoop+1;
	//��������	PGT_LowerLimit 7
	setValueById("LowerLimit",Data[iLLoop])

	iLLoop=iLLoop+1;
	//����״��	PGT_Married 8
	if(Data[iLLoop]=="M")
	{$HUI.radio("#TeamMarriedM").setValue(true);}
	else if(Data[iLLoop]=="UM")
	{$HUI.radio("#TeamMarriedUM").setValue(true);}
	else
	{$HUI.radio("#TeamMarriedN").setValue(true);}
   
	iLLoop=iLLoop+4;
	
	//��������	PGT_LowerLimit 7
	setValueById("ParRef_Name",Data[iLLoop])
	iLLoop=iLLoop+1;
	
	//	���屨�淢��	PGT_GReportSend	18
	setValueById("TeamGReportSend",Data[iLLoop])
	iLLoop=iLLoop+1;	
	
	//	���˱��淢��	PGT_IReportSend	19
	setValueById("TeamIReportSend",Data[iLLoop])
	iLLoop=iLLoop+1;	
	
	//	���㷽ʽ	PGT_DisChargedMode	20
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
	
	if (VIPLevelDesc=="ְҵ��"){
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
	//�������
	OMEType=Data[iLLoop];
	//setValueById("OMEType",Data[iLLoop])
    $("#OMEType").combobox("setValues",OMEType);
    
	iLLoop=iLLoop+1;
	var RoomPlace=""
	RoomPlace=Data[iLLoop];
	//alert(RoomPlace)
	setValueById("RoomPlace",Data[iLLoop])
	
	iLLoop=iLLoop+1;
	//Σ������
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
		title:"��Ŀ��Ϣ�б�",
		collapsible:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.GTEdit&ID='+rowid+'&RegNo='+regno+'&Name='+name+'&PEDate='+pedate+'&PETime='+petime+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.GTEdit"+"&ID="+rowid+"&RegNo="+regno+"&Name="+name+"&PEDate="+pedate+"&PETime="+petime;
	
	websys_lu(str,false,'width=700,height=495,hisui=true,title=ԤԼ��Ϣ�޸�')
	
	
	
}
/*
function BaseInfo(rowid)
{
	

	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit&OperType=Q&ID="+rowid;
	
	websys_lu(str,false,'width=1000,height=590,hisui=true,title=���˻�����Ϣά��')
	
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
	//websys_lu(str,false,'width=1000,height=590,hisui=true,title=���˻�����Ϣά��')
	var lnk="dhcpepreibaseinfo.edit.hisui.csp?OperType=Q&ID="+PIBI;
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=795,height=640,hisui=true,title=���˻�����Ϣά��')
}



function NoCheckedList(rowid)
{
	/*
	$HUI.window("#CheckedListWin",{
		title:"�����Ϣ�б�",
		collapsible:false,
		modal:true,
		width:1200, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=N&GroupID='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=N&GroupID="+rowid;
	
	websys_lu(str,false,'width=1200,height=495,hisui=true,title=δ����Ϣ�б�')
}

function HadCheckedList(rowid)
{
	/*
	$HUI.window("#CheckedListWin",{
		title:"�����Ϣ�б�",
		collapsible:false,
		modal:true,
		width:1200, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=Y&GroupID='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=Y&GroupID="+rowid;
	
	websys_lu(str,false,'width=1200,height=495,hisui=true,title=�Ѽ���Ϣ�б�')
	
}
function CancelPEList(rowid)
{
	
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=C&GroupID="+rowid;
	websys_lu(str,false,'width=1200,height=495,hisui=true,title=ȡ�������Ϣ�б�')
	
}
function CheckTeamItem(rowid)
{
	/*
	$HUI.window("#ItemWin",{
		title:"��Ŀ��Ϣ�б�",
		collapsible:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=TEAM&AdmId='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=TEAM&AdmId="+rowid;
	
	websys_lu(str,false,'width=690,height=495,hisui=true,title=��Ŀ��Ϣ�б�')
}

function CheckItem(rowid)
{
	/*
	$HUI.window("#ItemWin",{
		title:"��Ŀ��Ϣ�б�",
		collapsible:false,
		modal:true,
		width:800, 
		height:600,
		content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=PERSON&AdmId='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

	});
	*/
	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=PERSON&AdmId="+rowid;
	
	websys_lu(str,false,'width=690,height=495,hisui=true,title=��Ŀ��Ϣ�б�')
	
	
	
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
	
	//Ԥ�ǼǸ��˻�����Ϣ�� PIADM_PIBI_DR 1
	iPIBIDR=getValueById("PIBI_RowId")
	
	
	//��Ӧ�����ADM PIADM_PGADM_DR 2
	iPGADMDR=getValueById("ID")
	
	if (""==iPGADMDR) {
			//��Ч������
			$.messager.alert("��ʾ","��Ч����",'info');
			return false;
		}
	

	//��Ӧ��ADM PIADM_PGTeam_DR 3
	iPGTeamDR=getValueById("PGTRowId")
	
	if (""==iPGTeamDR) {
			//��Ч������
			$.messager.alert("��ʾ","��Ч����",'info');
			return false;
		} 
	
	
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",iPIBIDR,iPGADMDR,iPGTeamDR);
	if (flag=="Err Audit")
	{
		//alert("�ƷѼ�¼�������,����ȡ����˼�¼");
		$.messager.alert("��ʾ","�ƷѼ�¼�������,����ȡ����˼�¼",'info');
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
		$.messager.alert("��ʾ","�ͻ�����������������Ѵ���!",'info');
		//alert("�ͻ�����������������Ѵ���!");
		return false;		
	}
	else if ('Err 09'==flag) {
		$.messager.alert("��ʾ","����������ͻ�ʧ��"+":"+Rets[1],'error');
		//alert("����������ͻ�ʧ��"+":"+Rets[1]);
		return false;		
	}
	else {
		$.messager.alert("��ʾ","���´��� �����:"+flag,'error');
		//alert("���´��� �����:"+flag);
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

	// PREREG ԤԼ
	obj=getValueById("PREREG");
	if (obj){ iStatus=iStatus+"^"+"PREREG"; }

	// REGISTERED �Ǽ�
	obj=getValueById("REGISTERED");
	if (obj){ iStatus=iStatus+"^"+"REGISTERED"; }
	
	// REGISTERED ����
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
		alert("�����,���˼�����ȡ�����!");
		return false;
	}
    if (flag!="") {
	   	alert("�������!"+":"+flag);
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
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//��ȡ�������飬��������
	
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
		 $.messager.alert("��ʾ","��ѡ���ȡ�����ķ���","info"); 
		return false;
	}
	
	$.messager.confirm("ȷ��", "�Ƿ�ȷ��ȡ����죿", function(r){
	if (r){		
	
		var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",iRowId,"T","0");
	
		Ret=Ret.split("^")

		if (Ret[0]=="0") 
	
	 	{
		 	$.messager.alert("��ʾ","���ȡ����죡","info");
		 	 
		 	$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:$("#PGTRowId").val(),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
		   
		 	$("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")}); 

		 } 
   	 else
     	{
	    	$.messager.alert("��ʾ",Ret[1],"info");
	    
	 		}
		}
	});
	
	
}



function BCancelPE()
{
	
	var SelectIds=""
	var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
		
		if (SelectIds==""){
				SelectIds=selectrow[i].PIADM_RowId;
			}else{
				SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
			} 
	}
	
	if(SelectIds=="")
	{ 
		$.messager.alert("��ʾ","��ѡ���ȡ��������Ա","info");
		return false;
	}

	
	$.messager.confirm("ȷ��", "�Ƿ�ȷ��ȡ����죿", function(r){
		if (r){
			
			var CancelFlag=0;
	
	PreAdmIdStr=SelectIds.split("^")

	for(var i=0;i<PreAdmIdStr.length;i++){
		
		var PreAdmId=PreAdmIdStr[i];
		var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",PreAdmId,"I","0"); 
		Ret=Ret.split("^")
		
		if (Ret[1]!=="���ȡ��������")
	   	{ 
	   		CancelFlag=1; 
	    }
		
	}
	

	if (CancelFlag=="0") 
	
	 {
		 
		 $.messager.alert("��ʾ","���ȡ����죡","info");
		 
		 var gteam=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetGTeamByIADM",PreAdmId);
		 
    	 $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:gteam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
         
         $("#TeamGrid").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
	 	 
	 
	 } 
    else
     {
	    $.messager.alert("��ʾ",Ret[1],"info");
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
	var OneNum=19;  //ÿ�β�������OneNum+1
	var obj=document.getElementById("PGTRowId");
	if (obj) { 
		iRowId=obj.value; 
		if((LastTeamRowID!="")&&(LastTeamRowID!=iRowId)) {var OKNumTotal=0,ErrNumTotal=0;}
		var LastTeamRowID=iRowId;	
	}

	if (""==iRowId) 
	
	{
		$.messager.alert("��ʾ","����ѡ�����!","info");
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
		 //if (obj) obj.innerText="�ɹ�:"+OKNumTotal+"��;����:"+ErrNumTotal+"��";
		 setTimeout("register()",500);
		 
	 }else{
		 var OKNum=Arr[1];
		 var ErrNum=Arr[2];
		 OKNumTotal=OKNumTotal+(+OKNum);
		 ErrNumTotal=ErrNumTotal+(+ErrNum);
		 var obj=document.getElementById("RegisterInfo");
		 //if (obj) obj.innerText="�ɹ�:"+OKNumTotal+"��;����:"+ErrNumTotal+"��";
		 $.messager.alert("��ʾ","�������!","info");
		 //alert("�������!"+"�ɹ�:"+OKNumTotal+"��;����:"+ErrNumTotal+"��");
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
		$.messager.alert("��ʾ","����ѡ�����","info");
		return false;
	 }
	var IDS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetTeamIADM",iRowId)
	if (IDS=="")
	{
		$.messager.alert("��ʾ","û����Ҫ��ӡ������","info");
		return
		
	}
	var temprow=IDS.split("^");
	for(i=0;i<=(temprow.length-1);i++)
	{
		PAADM=temprow[i]
		Instring=PAADM+"^1^PAADM";
		var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
		PEPrintDJD("P",PAADM,"");//DHCPEPrintDJDCommon.js lodop��ӡ���ﵥ
		//PrintA4(value,1,"N"); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
		var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
		
	}
	
}
//����ƾ��
function ConPrintTPerson_click()
{
	var obj,ConRegNo,iRegNo
	obj=document.getElementById("ContinueRegNo");
	if (obj) {
		ConRegNo=obj.value;
		if(ConRegNo==""){
			alert("����������������")
			return false;
		}
		var flag=tkMakeServerCall("web.DHCPE.PrintGroupPerson","IsHPNo",ConRegNo);
		if(flag=="1"){
			alert("��������Ų���ȷ");
			return false;
		}

		//iRegNo=RegNoMask(ConRegNo);
		PrintTeamPerson_click(iRegNo);
		}
	else {alert("��������������!")}
}

//�������ӡ
function PrintTeamPerson_click(ConRegNo)
{
	try{
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
	
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
    var myDate = new Date();
    myDate.getFullYear();
    
    var obj=document.getElementById("PGTRowId");
    if(obj)  {var PGADMID=obj.value;} 	//team
    if ((""==PGADMID)){
		alert("δѡ�����");
		return false;	}
    var Instring=PGADMID;
  
    
    var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",Instring,"Y",ConRegNo);
    
    var str=returnval; 
    var temprow=str.split("^");
   	if(temprow=="")
   	{
		alert("��������Ա����Ϊ��")
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
	   
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //����
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //�Ա�
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //����
	    //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //�绰
		xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; //����
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //��Ż�����
	    xlsheet.cells(Rows+6,Cols+3)=tempcol[9]; //��λ����
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //��������
	    
	    
  		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"��"+HospitalName+"���ƾ��";

	    xlsheet.cells(Rows+2,Cols+1)="����:";
	    xlsheet.cells(Rows+2,Cols+3)="�Ա�:";
	    xlsheet.cells(Rows+2,Cols+5)="����:";
	    //xlsheet.cells(Rows+3,Cols+1)="��ϵ�绰:";
		xlsheet.cells(Rows+3,Cols+1)="����:";
	    xlsheet.cells(Rows+4,Cols+1)="���(�����):";
	    xlsheet.cells(Rows+6,Cols+1)="��λ���ƣ�";
	    xlsheet.cells(Rows+7,Cols+1)="��������:";
	    xlsheet.cells(Rows+8,Cols+1)="��ע:��Ѫʱ��:����8:00---9:30";
	   if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    	xlsheet.cells(Rows+10,Cols+1)="���绰: ";    
		    xlsheet.cells(Rows+8,Cols+1)="��ע:�Ǽ�ʱ��:����7:45---10:00";
		}
		else
		{
	    if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰: ";
	    	}else{
	    		xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰:";
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

//�����ӡ������Ա���ƾ������
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
	
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������

    var myDate = new Date();
    myDate.getFullYear();
    
  
   	var temprow=iRowIDStr.split("^");
   	if(temprow=="")
   	{
		alert("��û��ѡ���κ�һ����Ա!")
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
	    xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //����
	    xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //�Ա�
	    xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //����
	    //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //�绰
	    xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; ///����
	    xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //��Ż�����
	    xlsheet.cells(Rows+6,Cols+3)=tempcol[9] //PIADMName; //��λ����
	    xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //��������
	    
		    
		var HOSPID=session['LOGON.HOSPID'];
	    var HospitalName=""
	    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
	    if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
	    xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"��"+HospitalName+"���ƾ��";
	   
	    //xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"�걱��Э��ҽԺ����������ƾ��";
	    xlsheet.cells(Rows+2,Cols+1)="����:";
	    xlsheet.cells(Rows+2,Cols+3)="�Ա�:";
	    xlsheet.cells(Rows+2,Cols+5)="����:";
	    xlsheet.cells(Rows+3,Cols+1)="����:";
	    xlsheet.cells(Rows+4,Cols+1)="���(�����):";
	    xlsheet.cells(Rows+6,Cols+1)="��λ���ƣ�";
	    xlsheet.cells(Rows+7,Cols+1)="��������:";
	    xlsheet.cells(Rows+8,Cols+1)="��ע:��Ѫʱ��:����8:00---9:30";
	   if(session['LOGON.CTLOCID']=='572')
	    {
		    xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    	xlsheet.cells(Rows+10,Cols+1)="���绰:";    
		    
		}
		else
		{
	    if
	 		(tempcol[14]=="2"){
		    	xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰:";
	    	}else{
	    		xlsheet.cells(Rows+9,Cols+1)="����ַ:";
	    		xlsheet.cells(Rows+10,Cols+1)="���绰:";
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
//��֤�Ƿ�Ϊ������
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
