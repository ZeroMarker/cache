var PageLogicObj={
	m_PilotExpression:"",
	m_SuperDepRowId:"",
	m_PilotProReg:"",
	m_PilotProSubCatStr:"",
	m_ProCodeLenght:"",
	m_AutoProCode:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
	m_Loc:""
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
})
function Init(){
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
				if (getNodeName(nodes,i-1)==(myItemName+"Dr")){ //nodes(i-1).nodeName
					_$id.combobox("select",getNodeValue(nodes,i-1)); //nodes(i-1).text
				}else{
					_$id.combobox("select",getNodeValue(nodes,i-1)); //nodes(i+1).text
				}
			}else if(_$id.hasClass("hisui-checkbox")){
				if (myItemValue=="Y"){
					_$id.checkbox('check');
				}else{
					_$id.checkbox('uncheck');
				}
			}else{
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
			$('#ApplyMatterDr').next('span').find('input').focus();
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
	var IsHeadmanDr=$("#IsHeadman").combobox("getValue");
	if (IsHeadmanDr==""){
		$.messager.alert("��ʾ","���о�����״̬����Ϊ��.","info",function (){
			$('#IsHeadman').next('span').find('input').focus();
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
	return true;
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
		var myExpStr="";
		var OtherDepStr=$("#OtherDepStr").val();
		var rtn=$.cm({ 
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"InsertProjectInfo",
			dataType:"text",
			myProjecctInfo:myProjecctInfo,
			myExpStr:myExpStr,
			OtherDepStr:OtherDepStr
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
	$(".hisui-combobox").combobox('select','');
	$("#OtherDepStr,OtherDepartment").val("");
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
			if (_$id.length==0){
				var node=myary[myIdx];
				var Len=node.length-2;
				var id=node.substring(0,Len);
				if ($("#"+id).length>0){
					if ($("#"+id).hasClass("hisui-combobox")){
						var myval=$("#"+id).combobox("getValue");
					}else{
						var myval=$("#"+id).val();
					}
			    }
			}else{
				if (_$id.hasClass("hisui-combobox")){
					var myval=_$id.combobox("getValue");
				}else if(_$id.hasClass("hisui-checkbox")){
					var myval="N";
					if (_$id.checkbox('getValue')) myval="Y";
				}else{
					var myval=_$id.val();
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
		var rtn=$.cm({ 
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"UpdateMethod",
			dataType:"text",
			myProjecctInfo:myProjecctInfo,
			PPRowId:ServerObj.PPRowId
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
    GetConfig();
    //ҳ��Ԫ����ʾ������
    InitElementStatus();
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
			}
	 });
}
var LastSelLocId="";
function LoadDepartment(){
	var cbox = $HUI.combobox("#PPCreateDepartment", {
		url:$URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc=&ResultSetType=array",
		valueField:'RowId',
		textField:'Desc',
		filter: function(q, row){
			q=q.toUpperCase();
			return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
		},
		onChange:function(newValue,OldValue){
			if (!newValue){
				var cbox = $HUI.combobox("#PPCreateDepartment");
				cbox.setValue("");
			}else{
				LastSelLocId=newValue;
			}
		},
		onBeforeLoad: function(param){
			LastSelLocId=$("#PPCreateDepartment").combobox('getValue');
		},
		onLoadSuccess:function(){
			var DefLocId="";
			var rows=$("#PPCreateDepartment").combobox('getData');
			for (var i=0;i<rows.length;i++){
				if ((rows[i].RowId==LastSelLocId)||((LastSelLocId=="")&&(rows.length==1))) {
					DefLocId=rows[i].RowId;
					break;
				}
			}
			$("#PPCreateDepartment").combobox('select',DefLocId);
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
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#PPStartUser", {
			valueField: 'Hidden',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (!newValue){
					//var cbox = $HUI.combobox("#PPStartUser");
					//cbox.setValue("");
					
					var sid = "";
					var loc=""
					url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&User="+sid+"&ResultSetType=array";
					PageLogicObj.m_Loc.reload(url);
					PageLogicObj.m_Loc.setValue("");
				}
			},
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["SSUSRInitials"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (record) {
				var sid = record.Hidden;
				var loc=""
				url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&User="+sid+"&ResultSetType=array";
				PageLogicObj.m_Loc.reload(url);
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
	var src="docpilotpro.otherdep.hui.csp?PPRowId="+ServerObj.PPRowId+"&OtherDepStr="+OtherDepStr+"&OtherDepartment="+OtherDepartment;
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
			window.location.reload();
		})
	}else{
		$.messager.alert("��ʾ","״̬�޸�ʧ��!");
	}
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