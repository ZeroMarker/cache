var PageLogicObj={
	v_CHosp:"",
	v_CHospDesc:"",
	m_HospComp:"",
	m_PilotExpression:"",
	m_SuperDepRowId:"",
	m_PilotProReg:"",
	m_PilotProSubCatStr:"",
	m_ProCodeLenght:"",
	m_AutoProCode:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
	m_Loc:"",
	v_Loc:"",
	m_Doc:"",
	v_Doc:"",
	PNO : {
		"CROTable":[]
	},
	m_CROTable:""	// PageLogicObj.m_CROTable
};
$(function(){
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//�¼���ʼ��
	InitEvent();
	//PrintTest();
});
$(window).load(function() {
	Init();
	//console.log(PageLogicObj.v_Loc)
	setTimeout(function(){
		PageLogicObj.m_Doc.select(PageLogicObj.v_Doc)
		$("#PPCreateDepartment").combobox("select",PageLogicObj.v_Loc);
		
	},300);
})
function Init(){
	InitEasyUITool();
	InitHospList();
	if (ServerObj.Flag=="Other" && ServerObj.PPRowId!=""){
		var myXml=$.cm({
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"GetProjectInfoByID",
			dataType:"text",
			PPRowId:ServerObj.PPRowId
		},false); 
		if (myXml!=""){
			 SetProInfoByXML(myXml);
		}
	}
}
function SetProInfoByXML(XMLStr){
	xMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	/*var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) { 
		$.messager.alert("��ʾ",xmlDoc.parseError.reason); 
		return; 
	}*/
	var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
	if (!xmlDoc) return;
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) {
		
		/*var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;*/
		var myItemName = getNodeName(nodes,i);
		var myItemValue = getNodeValue(nodes,i);
		var _$id=$("#"+myItemName);
		if (_$id.length>0){
			if (_$id.hasClass("hisui-combobox")){
				if ((myItemName=="PPCreateDepartment")||(myItemName=="PPStartUser")) {
					//_$id.combobox("setValue",myItemValue);
					if (myItemName=="PPCreateDepartment") {PageLogicObj.v_Loc = myItemValue}
					if (myItemName=="PPStartUser") {PageLogicObj.v_Doc = myItemValue}
				} else {
					if (myItemName=="PPInterFlag") {
						_$id.combobox("select",myItemValue); //nodes(i+1).text
					} else {
						if (getNodeName(nodes,i-1)==(myItemName+"Dr")){ //nodes(i-1).nodeName
							if (myItemName=="PPCreateDepartment") {
								PageLogicObj.v_Loc = getNodeValue(nodes,i-1);
							} else {
								if (myItemName!="PPCreateDepartment") {
									_$id.combobox("select",getNodeValue(nodes,i-1)); //nodes(i-1).text
								}
							}
						}else{
							if (myItemName=="StudyType") {
								
								_$id.combobox("select",myItemValue)
								
							}
							else if (myItemName!="PPCreateDepartment") {
								_$id.combobox("select",getNodeValue(nodes,i-1)); //nodes(i+1).text
							}
						}
					}
				}
				
			}else if(_$id.hasClass("hisui-checkbox")){
				if (myItemValue=="Y"){
					_$id.checkbox('check');
				}else{
					_$id.checkbox('uncheck');
				}
			} else if (_$id.hasClass("hisui-datebox")) {
				_$id.datebox("setValue",myItemValue);
			} else if (_$id.hasClass("hisui-numberspinner")) {
				_$id.numberspinner("setValue",myItemValue);
			}  else{
				_$id.val(myItemValue);
			}
		}
	}
	delete(xmlDoc);
}
function InitEvent(){
	$("#Create").click(CreateClickHander);
	$("#Update").click(UpdateClickHander);
	$("#BtnPrintYXB").click(BtnPrintYXBClickHander);
	$("#ChangeState").click(ChangeStateClickBlurHander);
	$("#OtherDep").click(OtherDepClickBlurHander);
	$("#PPCode").blur(PPCodeBlurHander);
	$('input:text:first').focus(); 
	var $inp = $('input:text'); 
	$inp.bind('keydown', function (e) { 
		var key = e.which; 
		if (key == 13) { 
			e.preventDefault(); 
			var nxtIdx = $inp.index(this) + 1; 
			if ($(":input:text:eq(" + nxtIdx + ")").css("display")=="none"){
				nxtIdx=nxtIdx+1;
			}
			$(":input:text:eq(" + nxtIdx + ")").focus(); 
		} 
	}); 
}
function CreateClickHander(){
	if (!CheckBeforeSave()) return false;
	SaveDataToServer();
}
function CheckBeforeSave(){
	if (PageLogicObj.m_AutoProCode!=1){
		var PPCode=$("#PPCode").val();
		if (PPCode==""){
			$.messager.alert("��ʾ","��¼����Ŀ����!","info",function (){
				$("#PPCode").focus();
			})
			return false;
		}else{
			if (!PPCodeBlurHander()) return false;
		}
	}
	var ArchivesFilesNo=$("#ArchivesFilesNo").val();
	if ((ServerObj.ArchivesFilesNoSt==0)&&(ArchivesFilesNo=="")){
		$.messager.alert("��ʾ","�����ļ��б�Ų���Ϊ��!","info",function (){
			$("#ArchivesFilesNo").focus();
		})
		return false;
	}
	var PPDesc=$("#PPDesc").val();
	if (PPDesc==""){
		$.messager.alert("��ʾ","ҩ��/ҽ����е���Ʋ���Ϊ��.","info",function (){
			$("#PPDesc").focus();
		})
		return false;
	}
	var PlanNo=$("#PlanNo").val();
	if (PlanNo==""){
		$.messager.alert("��ʾ","������Ų���Ϊ��.","info",function (){
			$("#PlanNo").focus();
		})
		return false;
	}
	var PlanName=$("#PlanName").val();
	if (PlanName==""){
		$.messager.alert("��ʾ","�������Ʋ���Ϊ��.","info",function (){
			$("#PlanName").focus();
		})
		return false;
	}
	var ApplicationUnit=$("#ApplicationUnit").val();
	if (ApplicationUnit==""){
		$.messager.alert("��ʾ","�����˲���Ϊ��.","info",function (){
			$("#ApplicationUnit").focus();
		})
		return false;
	}
	
	var PilotCategoryDr=$("#PilotCategory").combobox("getValue");
	var PilotCategoryDr=CheckComboxSelData("PilotCategory",PilotCategoryDr);
	if (PilotCategoryDr==""){
		$.messager.alert("��ʾ","��ѡ�����!","info",function (){
			$('#PilotCategory').next('span').find('input').focus();
		})
		return false;
	}
	var ApprovalNo=$("#ApprovalNo").val();
	if (ApprovalNo==""){
		$.messager.alert("��ʾ","�����Ų���Ϊ��.","info",function (){
			$("#ApprovalNo").focus();
		})
		return false;
	}
	var ApplyMatterDr=$("#ApplyMatter").combobox("getValue");
	var ApplyMatterDr=CheckComboxSelData("ApplyMatter",ApplyMatterDr);
	if (ApplyMatterDr==""){
		$.messager.alert("��ʾ","��ѡ����������!","info",function (){
			$('#ApplyMatter').next('span').find('input').focus();
		})
		return false;
	}
	var ApplyStageDr=$("#ApplyStage").combobox("getValue");
	var ApplyStageDr=CheckComboxSelData("ApplyStage",ApplyStageDr);
	if (ApplyStageDr==""){
		$.messager.alert("��ʾ","��ѡ��������!","info",function (){
			$('#ApplyStage').next('span').find('input').focus();
		})
		return false;
	}
	var PPInterFlag=$("#PPInterFlag").combobox("getValue");
	if (PPInterFlag==""){
		$.messager.alert("��ʾ","��ѡ���ʹ��ڱ�ʶ!","info",function (){
			$('#PPInterFlag').next('span').find('input').focus();
		})
		return false;
	}
	var StudyType=$("#StudyType").combobox("getValue");
	if (StudyType==""){
		$.messager.alert("��ʾ","�������Ͳ���Ϊ��.","info",function (){
			$('#StudyType').next('span').find('input').focus();
		})
		return false;
	}
	var IsHeadmanDr=$("#IsHeadman").combobox("getValue");
	var IsHeadmanText=$("#IsHeadman").combobox("getText");
	if (IsHeadmanDr==""){
		$.messager.alert("��ʾ","���о�����״̬����Ϊ��.","info",function (){
			$('#IsHeadman').next('span').find('input').focus();
		})
		return false;
	} else {
		
	}
	var LeaderCompany=$.trim($("#LeaderCompany").val())
	var LeaderCompanyPI=$.trim($("#LeaderCompanyPI").val())
	if (LeaderCompany==""){
		$.messager.alert("��ʾ","�鳤��λ����Ϊ��.","info",function (){
			$("#LeaderCompany").focus();
		})
		return false;
	}
	if (LeaderCompanyPI==""){
		$.messager.alert("��ʾ","�鳤��λPI����Ϊ��.","info",function (){
			$("#LeaderCompanyPI").focus();
		})
		return false;
	}
	
	var PPCreateDepartmentDr=$("#PPCreateDepartment").combobox("getValue"); 
	var PPCreateDepartmentDr=CheckComboxSelData("PPCreateDepartment",PPCreateDepartmentDr);
	if (PPCreateDepartmentDr==""){
		$.messager.alert("��ʾ","��ѡ���������!","info",function (){
			$('#PPCreateDepartment').next('span').find('input').focus();
		})
		return false;
	}
	var PPStartUserDr=$("#PPStartUser").combobox("getValue"); 
	var PPStartUserDr=CheckComboxSelData("PPStartUser",PPStartUserDr); 
	if (PPStartUserDr==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ�о���!","info",function (){
			$('#PPStartUser').next('span').find('input').focus();
		})
		return false;
	}
	var PPNum=$("#PPNum").numberspinner("getValue")||"";
	if (PPNum==""){
		$.messager.alert("��ʾ","��Ŀ��������Ϊ��.","info",function (){
			$("#PPNum").focus();
		})
		return false;
	} else if (PPNum<0) {
		$.messager.alert("��ʾ","��Ŀ����������ڵ���0.","info",function (){
			$("#PPNum").focus();
		})
		return false;
	} else {}
	var PPStartDate=$("#PPStartDate").datebox("getValue")||"",
		PPEndDate=$("#PPEndDate").datebox("getValue")||"";
	
	if ((PPStartDate!="")&&(PPEndDate!="")) {
		var result = CompareDate(PPStartDate,PPEndDate,dtformat);
		if (result==1) {
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������!","info")
			return false;	
		}
	}
	
	var ApplyContactTel=$.trim($("#ApplyContactTel").val());
	if (ApplyContactTel!=""){
		if (!CheckTelOrMobile(ApplyContactTel,"ApplyContactTel","��췽��ϵ�˵绰")) return false;	
	}
	
	
	return true;
}

function CompareDate(date1,date2,dateformat){
    dateformat = dateformat||"YMD"
    //DMY��ʾ�������ꣻMDY��ʾ�������ꣻYMD��ʾ��������
    if (dateformat=="DMY") {
        var date1_Arr = date1.split("/"),
            date2_Arr = date2.split("/");
        date1 = date1_Arr[2]+"-"+date1_Arr[1]+"-"+date1_Arr[0];
        date2 = date2_Arr[2]+"-"+date2_Arr[1]+"-"+date2_Arr[0];
    } else if (dateformat=="YMD") {
        
    } else {
        //MDY��������
    }
    var oDate1 = new Date(date1);
    var oDate2 = new Date(date2);
    if(oDate1.getTime() > oDate2.getTime()){
    	return 1;
    } else if (oDate1.getTime() == oDate2.getTime()) {
        return 0;
    } else {
        return -1;
    }
}

function PPCodeBlurHander(){
	var PPCode=$("#PPCode").val();
	if (PPCode!=""){
		if ((PageLogicObj.m_ProCodeLenght!="")&&(PPCode.length!=PageLogicObj.m_ProCodeLenght)){
			$.messager.alert("��ʾ","��Ŀ����λ������","info",function (){
				$("#PPCode").focus();
			})
			return false;
		}
	}
	var myrtn=$.cm({ 
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"CheckPPCodeRlue",
		dataType:"text",
		PPCodeDesc:PPCode
	},false); 
	var myArray=myrtn.split("^");
	if (myArray[0]!="0"){
		 $.messager.alert("��ʾ",myArray[1],"info",function(){
			 $("#PPCode").focus();
		 });
		return false;
	}
	return true;
}
function PPCodeBlurHander(){
	var PPCode=$("#PPCode").val();
	if (PPCode!=""){
		if((PageLogicObj.m_ProCodeLenght!="")&&(PPCode.length!=PageLogicObj.m_ProCodeLenght)){
			$.messager.alert("��ʾ","��Ŀ���볤��ӦΪ:"+PageLogicObj.m_ProCodeLenght+"λ","info",function(){
				$("#PPCode").focus();
			});
			return false;
		}
		var myrtn=$.cm({ 
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"CheckPPCodeRlue",
			dataType:"text",
			PPCodeDesc:PPCode,
			paraPPRowId:ServerObj.PPRowId
		},false);
		var myArray=myrtn.split("^");
		if (myArray[0]!="0"){
			$.messager.alert("��ʾ",myArray[1],"info",function(){
				$("#PPCode").focus();
			});
			return false;
		} 
	}
	return true;
}
function SaveDataToServer(){
	try{
		var myProjecctInfo=getProjecctInfo();
		var CROObj = GetCROStr("CROTable") 
		if (!CROObj.success) {
			return false;		
		}
		var CROInfo = CROObj.content;
		
		var myExpStr="";
		var OtherDepStr=$("#OtherDepStr").val();
		var rtn=$.cm({ 
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"InsertProjectInfo",
			dataType:"text",
			myProjecctInfo:myProjecctInfo,
			myExpStr:myExpStr,
			OtherDepStr:OtherDepStr,
			InHosp:GetHospValue(),
			CROInfo:CROInfo
		},false); 
		var myArray=rtn.split("^");
		if (myArray[0]=='0')
		{
			$.messager.alert("��ʾ","����ɹ�!","info",function(){
				 $.messager.confirm('ȷ�϶Ի���', '�Ƿ��ӡԤ���?', function(r){
					if (r){
					    ShowMessage("����ίԱ��������¼","�ٴ�ҩ������������¼","ȫ��","<br>","","",function(ret){
						    if ((ret==null)){}
							if (ret==1) {PrintECAPPRRecord(myArray[1])}
							if (ret==2) {PrintZXLCAPPRRecord(myArray[1]);}
							if (ret==3){
								PrintECAPPRRecord(myArray[1]);
				   				PrintZXLCAPPRRecord(myArray[1]);
				   			}
				   			ClearData();
							if (parent){
								parent.PilotProListTabDataGridLoad();
								parent.destroyDialog("Project");
							}
						});
						
					}else{
						ClearData();
						if (parent){
							parent.PilotProListTabDataGridLoad();
							parent.destroyDialog("Project");
						}
					}
				});
			});
		}else{
			$.messager.alert("��ʾ","����: "+myArray[1]);
		}
	}catch(E){
		$.messager.alert("��ʾ",E.message);
		return;
	}
}
function ClearData(){
	var $input=$(":input:text");
	for (var i=0;i<$input.length;i++){
		$("#"+$input[i]["id"]).val("");
	}
	$("#PPStartDate").datebox("clear")
	$("#PPEndDate").datebox("clear")
	
	$(".hisui-combobox").combobox('select','');
	$("#OtherDepStr,OtherDepartment").val("");
	$("#PPNum").numberspinner("clear");
	PageLogicObj.m_CROTable.reload();
	
}
function ShowMessage(Button1,Button2,Button3,Message,Name,PrescriptTypeStr,callback)
{
	var url="docpilotpro.printmessage.hui.csp?Button1="+Button1+"&Button2="+Button2+"&Button3="+Button3+"&Message="+Message+"&PrescriptTypeStr="+PrescriptTypeStr; 
	/*var ret=window.showModalDialog(url,Name,"dialogwidth:34em;dialogheight:12em;center:1;status:no");
	return ret;*/
	websys_showModal({
		url:url,
		title:'��ӡ����',
		width:505,height:150,
		CallBackFunc:function(CallBackData){
			if (callback) callback(CallBackData);
		}
	})
}
function getProjecctInfo(){
	var myxml="";
	var myparseinfo = ServerObj.InitProjectEntity;
	var myxml=GetEntityClassInfoToXML(myparseinfo)
	return myxml;
}
function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try{
		var myary=ParseInfo.split("^");
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			xmlobj.BeginNode(myary[myIdx]);
			var _$id=$("#"+myary[myIdx]);
			var myval="";
			if (_$id.length==0){
				var node=myary[myIdx];
				var Len=node.length-2;
				var id=node.substring(0,Len);
				//console.log(node+": "+id)
				if ($("#"+id).length>0){
					if ($("#"+id).hasClass("hisui-combobox")){
						myval=$("#"+id).combobox("getValue");
					}else{
						myval=$("#"+id).val();
					}
					
			    }

			}else{
				if (_$id.hasClass("hisui-combobox")){
					myval=_$id.combobox("getValue")||"";
				}else if(_$id.hasClass("hisui-checkbox")){
					myval="N";
					if (_$id.checkbox('getValue')) myval="Y";
				} else if (_$id.hasClass("hisui-datebox")) {
					myval=_$id.datebox("getValue")||"";
				} else if (_$id.hasClass("hisui-numberspinner")) {
					//_$id.numberspinner("setValue",myItemValue);
					myval=_$id.numberspinner("getValue")||"";
				} else{
					myval=_$id.val();
				}
				
			}
			
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err){
		$.messager.alert("��ʾ","Error: " + Err.description);
	}	
	return myxmlstr;
}
function UpdateDataToServer(){
	try{
		var myProjecctInfo=getProjecctInfo();
		var CROObj = GetCROStr("CROTable") 
		if (!CROObj.success) {
			return false;		
		}
		var CROInfo = CROObj.content;
		//console.log(CROInfo)
		//console.log(myProjecctInfo)
		//return false;
		var rtn=$.cm({ 
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"UpdateMethod",
			dataType:"text",
			myProjecctInfo:myProjecctInfo,
			PPRowId:ServerObj.PPRowId,
			CROInfo:CROInfo
		},false); 
		var myArray=rtn.split("^");
		if (myArray[0]=='0'){
			$.messager.alert("��ʾ","�޸ĳɹ�!","info",function(){
				if (parent){
					parent.PilotProListTabDataGridLoad();
					parent.destroyDialog("Project");
				}
				
			});
		}else{
			$.messager.alert("��ʾ","����: "+myArray[1]);
		}
	}catch(E){
		$.messager.alert("��ʾ",E.message);
		return false;
	}
}
function UpdateClickHander(){
	if (!CheckBeforeSave()) return false;
	UpdateDataToServer()
}
function BtnPrintYXBClickHander(){
	ShowMessage("����ίԱ��������¼","�ٴ�ҩ������������¼","ȫ��","<br>","","",function(ret){
		if ((ret==null)){return false;}
		if (ret==1) {PrintECAPPRRecord(ServerObj.PPRowId)}
		if (ret==2) {PrintZXLCAPPRRecord(ServerObj.PPRowId);}
		if (ret==3){
			PrintECAPPRRecord(ServerObj.PPRowId);
			PrintZXLCAPPRRecord(ServerObj.PPRowId);
		}
	});	
}
function ChangeStateClickBlurHander(){
	var ret=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectByID",
		dataType:"text",
		PPRowId:ServerObj.PPRowId
	},false);
	if (ret==""){
		return false;
	}
	var arr=ret.split("^");
	var StatusDr=arr[21];
	var $code ="<table class='search-table'>"
					+"<tr>"
						+"<td class='r-label'><label for='StatusNew'>״̬</label></td>"
						+"<td><input class='textbox' id='StatusNew'/></td>"
					+"</tr>"
			   +"</table>" ;
	createModalDialog("status",$("#PPDesc").val()+" ״̬�ı�", '400', '200',"icon-w-edit","����",$code,"ChangeProjectStatus()");
	var cbox = $HUI.combobox("#StatusNew", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:false,
			data: [
				{"rowid":"N","Desc":"����"}
				,{"rowid":"H","Desc":"δ����"}
				,{"rowid":"V","Desc":"����"}
				,{"rowid":"P","Desc":"����������"}
				,{"rowid":"F","Desc":"�����"}
				,{"rowid":"A","Desc":"��ͣ"}
				,{"rowid":"S","Desc":"��ֹ"}
				,{"rowid":"B","Desc":"��ֹ"}
				,{"rowid":"I","Desc":"������"}
				,{"rowid":"D","Desc":"�ϻ�δͨ��"}
			],
			onLoadSuccess:function(){
				$(this).combobox('select',StatusDr);
			}
	 });
	 
}
function PageHandle(){
	//���
	LoadPilotCategory();
	//�����
    LoadSubPilotCategory("");
    //��������
    LoadApplyMatter();
    //�����ڱ�
    LoadApplyStage();
    //������״̬
    LoadIsHeadman();
    //�������
    PageLogicObj.m_Loc = LoadDepartment();
    //��Ҫ�о���
    LoadStartUser();
    LoadPPInterFlag()
    GetConfig();
    //ҳ��Ԫ����ʾ������
    InitElementStatus();
    InitPlanNoGrid();
    InitPPStudyType()
}
function InitPPStudyType(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"����ҩ��",
		DDesc:"��������",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#StudyType", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onSelect:function(rec){
				
			},onChange:function(newValue,OldValue){
				
			}
	 });
}
function GetConfig(){
	var myAry=ServerObj.PilotProConfigStr.split("^");
		PageLogicObj.m_PilotExpression=myAry[0];
		PageLogicObj.m_SuperDepRowId=myAry[1];
		PageLogicObj.m_PilotProReg=myAry[2];
		PageLogicObj.m_PilotProSubCatStr=myAry[3];
		PageLogicObj.m_ProCodeLenght=myAry[4];
		PageLogicObj.m_AutoProCode=myAry[9];
}
function InitElementStatus(){
	if (ServerObj.Flag=="Other"){
		$("#Create").hide();
	}else{
		$("#Update,#BtnPrintYXB,#ChangeState").hide();
		//$("#PPRemark").attr("disabled",true);
	}
	if (ServerObj.ArchivesFilesNoStart!=0){
		$("#ArchivesFilesNo").attr("disabled",true);
	}
	if (PageLogicObj.m_AutoProCode=="1") {
		$("#PPCode").attr("disabled",true);
	}
}
function LoadPPInterFlag() {
	$HUI.combobox("#PPInterFlag",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'����'},
			{id:'2',text:'����'}
		]
	});	
}
function LoadPilotCategory(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"����ҩ��",
		DDesc:"���",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#PilotCategory", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onSelect:function(rec){
				//���¼���������б�
				if (rec) {
					LoadSubPilotCategory(rec["rowid"]);
					var cbox = $HUI.combobox("#SubPilotCategory");
					cbox.select("");
				}
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#SubPilotCategory");
					cbox.select("");
					var cbox = $HUI.combobox("#PilotCategory");
					cbox.setValue("");
				}
			}
	 });
}
function LoadSubPilotCategory(CategoryId){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindSubPilotCategory",
		dataType:"json",
		PilotCategoryRowId:CategoryId,
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#SubPilotCategory", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#SubPilotCategory");
					cbox.setValue("");
				}
			}
	 });
}
function LoadApplyMatter(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"����ҩ��",
		DDesc:"��������",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#ApplyMatter", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#ApplyMatter");
					cbox.setValue("");
				}
			}
	 });
}
function LoadApplyStage(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"����ҩ��",
		DDesc:"������",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#ApplyStage", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#ApplyStage");
					cbox.setValue("");
				}
			}
	 });
}
function LoadIsHeadman(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindDefineData",
		dataType:"json",
		MDesc:"����ҩ��",
		DDesc:"�Ƿ����鳤",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#IsHeadman", {
			valueField: 'rowid',
			textField: 'Desc', 
			editable:false,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#IsHeadman");
					cbox.setValue("");
				}
			},
			onSelect: function (r) {
				if (typeof r != "undefined") {
					if (r.Desc=="�μ�") {
					} else {
						var LeaderCompany=$.trim($("#LeaderCompany").val())
						if (LeaderCompany=="") {
							$("#LeaderCompany").val(GetHospDesc())	
						}
						
					}
				}
				
			}
	 });
}
var LastSelLocId="";
function LoadDepartment(){
	var cbox = $HUI.combobox("#PPCreateDepartment", {
		url:$URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc=&InHosp="+(GetHospValue()+999)+"&ResultSetType=array",
		valueField:'RowId',
		textField:'Desc',
		filter: function(q, row){
			q=q.toUpperCase();
			return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
		},
		/*onChange:function(newValue,OldValue){
			if (!newValue){
				console.log(newValue)
				var cbox = $HUI.combobox("#PPCreateDepartment");
				cbox.setValue("");
			}else{
				LastSelLocId=newValue;
			}
		},*/
		onBeforeLoad: function(param){
			//LastSelLocId=$("#PPCreateDepartment").combobox('getValue');
		},
		onLoadSuccess:function(){
			/*var DefLocId="";
			var rows=$("#PPCreateDepartment").combobox('getData');
			for (var i=0;i<rows.length;i++){
				if ((rows[i].RowId==LastSelLocId)||((LastSelLocId=="")&&(rows.length==1))) {
					DefLocId=rows[i].RowId;
					break;
				}
			}
			$("#PPCreateDepartment").combobox('select',DefLocId);
			*/
			
			
		}
	})
	
	/*
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindLoc",
		dataType:"json",
		Loc:"",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#PPCreateDepartment", {
			valueField: 'RowId',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#PPCreateDepartment");
					cbox.setValue("");
				}
			},
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
			}
	 });
	 */
	 return cbox;
}
function LoadStartUser(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindStartUser",
		dataType:"json",
		PPStartUser:"",
		InHosp:GetHospValue(),
		rows:99999
	},false); 
	PageLogicObj.m_Doc = $HUI.combobox("#PPStartUser", {
			valueField: 'Hidden',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (!newValue){
					//var cbox = $HUI.combobox("#PPStartUser");
					//cbox.setValue("");
					
					/*
					var sid = "";
					var loc=""
					url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&User="+sid+"&InHosp="+GetHospValue()+"&ResultSetType=array";
					PageLogicObj.m_Loc.reload(url);
					PageLogicObj.m_Loc.setValue("");
					*/
				}
			},
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["SSUSRInitials"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (record) {
				if (record) {
					var sid = record.Hidden;
					var loc=""
					url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&User="+sid+"&InHosp="+GetHospValue()+"&ResultSetType=array";
					PageLogicObj.m_Loc.reload(url);
					PageLogicObj.m_Loc.clear();
				}
				//PageLogicObj.m_Loc.setValue("");
			}
	 });
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="PPCreateDepartment"){
			var CombValue=Data[i].RowId;
		 	var CombDesc=Data[i].Desc;
	     }else if(id=="PPStartUser"){
		    var CombValue=Data[i].Hidden;
		 	var CombDesc=Data[i].Desc;
		 }else{
		    var CombValue=Data[i].rowid  
		 	var CombDesc=Data[i].Desc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
//Ԥ���-EC�ٴ�����������¼���ӡ
function PrintECAPPRRecord(PPRowId){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocETHICSAPPRRECORD");
	try {
		var ret=$.cm({
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"GetProjectByID",
			dataType:"text",
			PPRowId:PPRowId
		},false); 
     	if (ret!=""){
		   var arr=ret.split("^")
		   var PPCode=arr[1]
		   var PPDesc=arr[2]
		   var PlanName=arr[4]
		   var ApplicationUnit=arr[5]
		   var PPCreateDepartment=arr[6]
		   var PPStartUser=arr[7]
		   var PilotCategory=arr[8]
		   var ApplyMatter=arr[9]
		   var ApprovalNo=arr[10]
		   var ApplyStage=arr[11]
		   var ApplyContact=arr[12]
		   var ApplyContactTel=arr[13]
		   var SubPilotCategory=arr[15]
		   if (SubPilotCategory!=""){
			   PilotCategory=SubPilotCategory
		   }
		   var PDlime=String.fromCharCode(2);
		   var MyPara="ApplicationUnit"+PDlime+ApplicationUnit+"^PPDesc"+PDlime+PPDesc+"^PilotCategory"+PDlime+PilotCategory;
		   MyPara=MyPara+PDlime+"^ApplyMatter"+PDlime+ApplyMatter+ApplyStage+"^PlanName"+PDlime+PlanName+"^ApplyContact"+PDlime+ApplyContact+" "+ApplyContactTel;
		   MyPara=MyPara+PDlime+"^PPStartUser"+PDlime+PPStartUser;
		   MyPara=MyPara+PDlime+"^Title"+PDlime+ServerObj.HospName+"ҩ���ٴ���������ίԱ��";
   		}
		//var myobj=document.getElementById("ClsBillPrint");
		//PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	} catch(e) {alert(e.message)};
	/*var TemplatePath=ServerObj.PrintPath;
    var ApplicationUnit,PPDesc,PilotCategory,ApplyStage,ApplyMatter,PlanName,ArchivesFilesNo,ApplyContact,ApplyContactTel,PPStartUser
    var myTotlNum=0;
    var CashNUM=0;
    var myencmeth="";
    var xlApp,xlsheet,xlBook
    TemplatePath=TemplatePath+"DHCDOCETHICSAPPRRECORD.xlsx";
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(TemplatePath);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;  
    xlsheet.PageSetup.RightMargin=0;
    var ret=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectByID",
		dataType:"text",
		PPRowId:PPRowId
	},false); 
     if (ret!=""){
	   var arr=ret.split("^")
	   var PPCode=arr[1]
	   var PPDesc=arr[2]
	   var PlanName=arr[4]
	   var ApplicationUnit=arr[5]
	   var PPCreateDepartment=arr[6]
	   var PPStartUser=arr[7]
	   var PilotCategory=arr[8]
	   var ApplyMatter=arr[9]
	   var ApprovalNo=arr[10]
	   var ApplyStage=arr[11]
	   var ApplyContact=arr[12]
	   var ApplyContactTel=arr[13]
	   var SubPilotCategory=arr[15]
	   if (SubPilotCategory!=""){
		   PilotCategory=SubPilotCategory
	   }
   }
    xlsheet.cells(3,3)=ApplicationUnit;
    xlsheet.cells(4,3)=PPDesc;
	xlsheet.cells(4,6)=PilotCategory;
	xlsheet.cells(4,8)=ApplyMatter+ApplyStage
    xlsheet.cells(5,3)=PlanName;
    xlsheet.cells(3,9)=ApplyContact+" "+ApplyContactTel;
	xlsheet.cells(4,10)=PPStartUser;
    var HospName=ServerObj.HospName;
    if (HospName!="") xlsheet.cells(1,2)=HospName+"ҩ���ٴ���������ίԱ��";
    xlsheet.printout;
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null;*/
}
//Ԥ���-�����ٴ�����������¼���ӡ
function PrintZXLCAPPRRecord(PPRowId){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocZXLCAPPRECORD");
	try {
		var ret=$.cm({
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"GetProjectByID",
			dataType:"text",
			PPRowId:PPRowId
		},false); 
     	if (ret!=""){
		   var arr=ret.split("^")
		   var PPCode=arr[1]
		   var PPDesc=arr[2]
		   var PlanName=arr[4]
		   var ApplicationUnit=arr[5]
		   var PPCreateDepartment=arr[6]
		   var PPStartUser=arr[7]
		   var PilotCategory=arr[8]
		   var ApplyMatter=arr[9]
		   var ApprovalNo=arr[10]
		   var ApplyStage=arr[11]
		   var ApplyContact=arr[12]
		   var ApplyContactTel=arr[13]
		   var SubPilotCategory=arr[15]
		   if (SubPilotCategory!=""){
			   PilotCategory=SubPilotCategory
		   }
		   var PDlime=String.fromCharCode(2);
		   var MyPara="ApplicationUnit"+PDlime+ApplicationUnit+"^PPDesc"+PDlime+PPDesc+"^PilotCategory"+PDlime+PilotCategory;
		   MyPara=MyPara+PDlime+"^ApplyMatter"+PDlime+ApplyMatter+ApplyStage+"^PlanName"+PDlime+PlanName+"^ApplyContact"+PDlime+ApplyContact+" "+ApplyContactTel;
		   MyPara=MyPara+PDlime+"^PPStartUser"+PDlime+PPStartUser;
		   MyPara=MyPara+PDlime+"^Title"+PDlime+ServerObj.HospName+"�ٴ�ҩ���о�����";
   		}
		//var myobj=document.getElementById("ClsBillPrint");
		//PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	} catch(e) {alert(e.message)};
	
	/*var TemplatePath=ServerObj.PrintPath;
    var ApplicationUnit,PPDesc,PilotCategory,ApplyStage,ApplyMatter,PlanName,ArchivesFilesNo,ApplyContact,ApplyContactTel,PPStartUser
    var myTotlNum=0;
    var CashNUM=0;
    var myencmeth="";
    var xlApp,xlsheet,xlBook
    TemplatePath=TemplatePath+"DHCDOCZXLCAPPRECORD.xlsx";
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(TemplatePath);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;  
    xlsheet.PageSetup.RightMargin=0;
    var ret=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectByID",
		dataType:"text",
		PPRowId:PPRowId
	},false); 
     if (ret!=""){
	   var arr=ret.split("^")
	   var PPCode=arr[1]
	   var PPDesc=arr[2]
	   var PlanName=arr[4]
	   var ApplicationUnit=arr[5]
	   var PPCreateDepartment=arr[6]
	   var PPStartUser=arr[7]
	   var PilotCategory=arr[8]
	   var ApplyMatter=arr[9]
	   var ApprovalNo=arr[10]
	   var ApplyStage=arr[11]
	   var ApplyContact=arr[12]
	   var ApplyContactTel=arr[13]
	   var SubPilotCategory=arr[15]
	   if (SubPilotCategory!=""){
		   PilotCategory=SubPilotCategory
	   }
   }
    xlsheet.cells(3,3)=ApplicationUnit;
    xlsheet.cells(3,8)=ApplyContact+" "+ApplyContactTel;
    xlsheet.cells(4,3)=PPDesc;
	xlsheet.cells(4,5)=PilotCategory;
	xlsheet.cells(4,7)=ApplyMatter+ApplyStage;
	xlsheet.cells(4,9)=PPStartUser;
    xlsheet.cells(5,3)=PlanName;
    var HospName=ServerObj.HospName;
    if (HospName!="") xlsheet.cells(1,2)=HospName+"�ٴ�ҩ���о�����";
   xlsheet.printout;
   xlBook.Close (savechanges=false);
   xlApp.Quit();
   xlApp=null;
   xlsheet=null;*/
}
function OtherDepClickBlurHander(){
	var PPDesc=$("#PPDesc").val();
	var OtherDepStr=$("#OtherDepStr").val();
	var OtherDepartment=$("#OtherDepartment").val();
	var src="docpilotpro.otherdep.hui.csp?PPRowId="+ServerObj.PPRowId+"&OtherDepStr="+OtherDepStr+"&OtherDepartment="+OtherDepartment+"&InHosp="+GetHospValue()
	src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
    var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","��Ŀ: "+PPDesc, PageLogicObj.dw, PageLogicObj.dh+60,"icon-w-edit","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	if(_btntext!=""){
	   var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		},{
			text:'�ر�',
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
		}]
   }else{
	   var buttons=[];
   }
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        buttons:buttons,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function ResetOtherDepData(OtherDepStr,OtherDepartment){
	$("#OtherDepStr").val(OtherDepStr);
	$("#OtherDepartment").val(OtherDepartment);
}
function ChangeProjectStatus(){
	var PPRowId=ServerObj.PPRowId;
	var ret=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"StatusChangeMethod",
		dataType:"text",
		PPRowId:ServerObj.PPRowId,
		Status:$("#StatusNew").combobox('getValue')
	},false);
	if (ret==0){
		$.messager.alert("��ʾ","״̬�޸ĳɹ�!","info",function(){
			destroyDialog("status");
			//window.location.reload();
		})
	}else{
		$.messager.alert("��ʾ","״̬�޸�ʧ��!");
	}
}

function InitEasyUITool () {
	$.extend($.fn.validatebox.defaults.rules, {   
		gtnums: {   
			validator: function(value,param){
				return value >= param[0];   
			},   
			message: '��ֵ������ڵ���{0}'
		}   
	});  
}

//DHCPrtComm.js
function PrintFun(PObj,inpara,inlist){
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;   
		var rtn=docobj.loadXML(mystr);
		if (rtn){
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		}
	}catch(e){
		$.messager.alert("��ʾ",e.message);
		return false;
	}
}
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CNMedCode");
	hospComp.jdata.options.onSelect = function(rowIndex,data){
		PageLogicObj.v_CHosp = data.HOSPRowId;
		PageLogicObj.v_CHospDesc = data.HOSPDesc;
		SwitchHosp();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitHospValue()
	}
	PageLogicObj.m_HospComp = hospComp;
}

function GetHospValue() {
	if (PageLogicObj.v_CHosp == "") {
		return session['LOGON.HOSPID'];
	}
	
	return PageLogicObj.v_CHosp
}

function GetHospDesc() {
	if (PageLogicObj.v_CHospDesc == "") {
		return session['LOGON.HOSPDESC'];
	}
	
	return PageLogicObj.v_CHospDesc
}

function SwitchHosp() {
	var UserID = $("#PPStartUser").combobox("getValue")||"",
		loc = "",
		PPStartUser = "";
	//$("#LeaderCompany").val("")
	url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&User="+UserID+"&InHosp="+GetHospValue()+"&ResultSetType=array";
	PageLogicObj.m_Loc.reload(url);
	PageLogicObj.m_Loc.clear();
	
	url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindStartUser&PPStartUser="+PPStartUser+"&InHosp="+GetHospValue()+"&ResultSetType=array";
	PageLogicObj.m_Doc.reload(url);
	PageLogicObj.m_Doc.clear();

	ReLoadCfg();
	ServerObj.HospName = tkMakeServerCall("web.PilotProject.Com.Func","GetHospName",GetHospValue());
	
}

function InitHospValue () {
	if (ServerObj.InHosp!="") {
		PageLogicObj.m_HospComp.setValue(ServerObj.InHosp)
		PageLogicObj.m_HospComp.disable();
	}	
}
function ReLoadCfg() {
	var PilotProConfigStr=$.cm({
		ClassName:"web.PilotProject.DHCDocPPGroupSeting",
		MethodName:"GetInitInfo",
		dataType:"text",
		InHosp:GetHospValue()
	},false);
	
    ServerObj.PilotProConfigStr = PilotProConfigStr;
	
    var myAry = PilotProConfigStr.split("^");
		PageLogicObj.m_PilotExpression=myAry[0];
		PageLogicObj.m_SuperDepRowId=myAry[1];
		PageLogicObj.m_PilotProReg=myAry[2];
		PageLogicObj.m_PilotProSubCatStr=myAry[3];
		PageLogicObj.m_ProCodeLenght=myAry[4];
		PageLogicObj.m_AutoProCode=myAry[9];
		ServerObj.ArchivesFilesNoStart=myAry[11];

    if (ServerObj.ArchivesFilesNoStart!=0){
        
        if (ServerObj.InHosp=="") {
	        $("#ArchivesFilesNo").attr("disabled",true).val("");
		} 	
	
    } else {
		$("#ArchivesFilesNo").removeAttr("disabled");
	}
	
    if (PageLogicObj.m_AutoProCode=="1") {
	    if (ServerObj.InHosp=="") {
	        $("#PPCode").attr("disabled",true).val("");
		}
    } else {
        $("#PPCode").removeAttr("disabled")
    }

}

function InitPlanNoGrid(){
	var 
		AddImg = '<img src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/>',
		DelImg = "<img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/>";
	
	var AddRowTitle='<a href="#" onclick="InsertRow('+"'CROTable'"+')">'+AddImg+'</a>';
	PageLogicObj.m_CROTable = $HUI.datagrid("#CROTable", {
		fit: true,
		border:true,
        fitColumns : true,
		pagination:false,
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCP.BS.CRO",
			QueryName : "QryList",
			InPID: ServerObj.PPRowId
		},
	    columns:[[
		    {field:'CROCompany',title:'CRO��˾',width:230,editor:'text'},
		    {field:'CROContact',title:'CRO��ϵ��',width:230,editor:'text'},
		    {field:'CROContactTel',title:'CRO��ϵ�˵绰',width:230,editor:'text'},
		    {field:'rowid',title:'rowid',width:100,hidden:true},
			{field:'action',title:AddRowTitle,width:90,align:'center',
				formatter:function(value,row,index){
					var d = '<a class="c-pointer" onclick="DeleteRow(this,'+"'CROTable'"+')">'+DelImg+'</a>';
					return d;
				}
			},
			
	    ]],
		onBeforeEdit:function(index,row){
			row.editing = true;
		},
		onAfterEdit:function(index,row){
			row.editing = false;
		},
		onCancelEdit:function(index,row){
		},
		onLoadSuccess:function(data){
			if (ServerObj.See==1) {
				$(this).datagrid("hideColumn", "action");
			} else {
				var data=$(this).datagrid('getData');
				var total=data.total;
				for (i=0;i<total;i++) {
					$(this).datagrid('beginEdit',i);
				}
			}
			
		}
    });
}

function InsertRow(id){
	id = "#"+id
	var data=$(id).datagrid('getData');
	var index=data.total;
	$(id).datagrid('insertRow', {
		index: index,
		row:{
			seqno:index,
			rowid:''
		}
	});
	$(id).datagrid('beginEdit',index);
	$(".datagrid-cell-c1-CROContactTel .datagrid-editable-input").keyup(function () {
		return $(this).val($(this).val().replace(/[^\d\-\d]/g,''))
	})
	return index;
}

function getRowIndex(target){
	var tr = $(target).closest('tr.datagrid-row');
	return parseInt(tr.attr('datagrid-row-index'));
}

function DeleteRow(target,id){
	id = "#"+id
	var total = $(id).datagrid('getData').total;
	var index = getRowIndex(target);
	if (index!=(total-1)) {
		//COM.alert("","�������¼��ʼɾ����",-1)
		//return false;
	}
	$(id).datagrid('selectRow',getRowIndex(target));
	var row = $(id).datagrid('getSelected');
	if (row.rowid!="") {
		COM.confirm("", "ȷ��ɾ��ô��", function () {
			var result = $.cm({
				ClassName: 'DHCDoc.GCP.BS.CRO',
				MethodName: 'Delete',
				ID: row.rowid,
				dataType: 'text'
			}, false);
			result = result.split("^")
			if (result[0] < 0) {
				$.DOC.alert('��ʾ', result[1], 'warning');
				return;
			} else {
				COM.popover({
					msg:"ɾ���ɹ���",
					type:"success"
				})
				$(id).datagrid('deleteRow', index);
			}
			
		});	
		
	} else {
		$(id).datagrid('deleteRow', index);
	}
	
}

function GetCROStr(id) {
	var domid = id,
		jqid = "#"+id,
		FinalArr = [],
		FinalObj = {
			msg:'',
			success:true,
			content:''	
		};
	
	var outputGdRows = $(jqid).datagrid("getRows");
	if (outputGdRows.length==0) {
		//COM.alert("",PageLogicObj.MSGArr[domid],-1)
		return FinalObj;
	}
	
	var msg=""
	for (var i=0;i<outputGdRows.length;i++) {
		$(jqid).datagrid('endEdit', i);
		var resultArr = [];
		var CROCompany=$.trim(outputGdRows[i]['CROCompany']),
			CROContact=$.trim(outputGdRows[i]['CROContact']),
			CROContactTel=$.trim(outputGdRows[i]['CROContactTel']),
			rowid = outputGdRows[i]['rowid'];
		
		if (CROContactTel!=""){
			if (!CheckTelOrMobile(CROContactTel,"CROContactTel","��"+(i+1)+"�У�CRO��ϵ�˵绰")) {
				$(jqid).datagrid('beginEdit', i);
				FinalObj.success=false
				break;
			}
			
		}
		
		if ((CROCompany=="")&&(CROContact=="")&&(CROContactTel=="")) {
		} else {
			resultArr.push(rowid,CROCompany,CROContact,CROContactTel);
			FinalArr.push(resultArr.join(String.fromCharCode(1)))
		}
		
	}
	FinalObj.content = FinalArr.join(String.fromCharCode(2));
	return FinalObj
	
}
var COM = {
	alert: function(_title, _content, _type, _callBack) {
		if (_title=="") _title="��ʾ"
        if (isNumber(_type)) {
            if (_type == 1) {
                _type = 'info';
            } else if (_type == -1) {
                _type = 'warning';
            } else if (_type == -2) {
                _type = 'error';
            } else if (_type == 0) {
                _type = 'success';
            } else {
				_type = 'info';
			}
        }
        $.messager.alert(_title, _content, _type, _callBack);
    },
	popover: function (_opts) {
        var _defOpts = {
            timeout: 1000
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $.messager.popover(_nOpts);
    },
	confirm: function (_title, _content, _callBack) {
        if (_title == '') _title = '��ʾ';
        $.messager.confirm(_title, _content, function (r) {
            if (r) {
                _callBack();
            } else {
            }
        });
	}
}

function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}


/*  
��;����������Ƿ���ȷ�ĵ绰���ֻ���  
���룺  
value���ַ���  
���أ�  
���ͨ����֤����true,���򷵻�false
/^1[34578]\d{9}$/;  
*/  
function DHCC_IsTelOrMobile(telephone){ 
	//var teleReg = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/;  
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){  
		return false;  
	}else{  
		return true;  
	}  
}
