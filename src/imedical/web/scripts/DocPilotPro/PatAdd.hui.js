var PageLogicObj={
	m_PilotProListTabDataGrid:"",
	m_PilotProPatListTabDataGrid:"",
	m_DATE_FORMAT:""
};
if (ServerObj.sysDateFormat=="4"){
	//DD/MM/YYYY
    PageLogicObj.m_DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
}else if(ServerObj.sysDateFormat=="3"){
	//YYYY-MM-DD
	PageLogicObj.m_DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
}
$(function(){	
	//页面数据初始化
	Init();
	//页面数据初始化
	PageHandle();
	//加载表格数据
	PilotProListTabDataGridLoad();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	LoadPatientInfo();
}
function LoadPatientInfo(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProPat",
		MethodName:"GetPatNoByID",
		EpisodeID:ServerObj.EpisodeID,
		PatientID:ServerObj.PatientID,
		dataType:"text"
	},function(PatNo){
		SetPatInfo(PatNo);
	});
}
function SetPatInfo(PatNo){
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetPatientByNo", 
		PapmiNo:PatNo,
		dataType:"text"
	},function(rtnStr){
		if (rtnStr!=""){
			var rtnStrTemp=rtnStr.split("^");
			var myStr=rtnStrTemp[1]+","+rtnStrTemp[2]+","+rtnStrTemp[3]+","+rtnStrTemp[4];
			$("#PatientID").val(rtnStrTemp[0]);
			$("#PatInfo").val(myStr);
		}
	});
}
function InitEvent(){
	$("#BFind").click(FindClick);
	$("#BSave").click(SaveClick);
	$("#BEdit").click(EditClick);
	$("#FindPilotPro").keydown(FindPilotProKeydown);
	$("#FindPilotPro").change(FindPilotProChange);
}
function FindPilotProKeydown(e){
	if(e.keyCode==13){
		FindClick();
	}
}
function FindPilotProChange(){
	var q=$("#FindPilotPro").val().toUpperCase();
	if (q==""){
		FindClick();
	}
}
function FindClick(){
	var q=$("#FindPilotPro").val().toUpperCase();
	PageLogicObj.m_PilotProListTabDataGrid.datagrid('uncheckAll');
	ClearPilotProListTab();
	PilotProListTabDataGridLoad();
	if (q=="") return;
	setTimeout(function(){
		var rows=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getRows');
		for (var i=rows.length-1;i>=0;i--){
			var PPRName=rows[i]["PPRName"];
			var PPRDesc=PPRName.split("-")[0].toUpperCase();
			var PPRCode=PPRName.split("-")[1].toUpperCase();
			if ((PPRDesc.indexOf(q)>=0)||(PPRCode.indexOf(q)>=0)){
			}else{
				PageLogicObj.m_PilotProListTabDataGrid.datagrid('deleteRow',i);
			}
		}
	})
}
function ClearPilotProListTab(){
	PageLogicObj.m_PilotProListTabDataGrid.datagrid('loadData',{"total":0,"rows":[]})
}
function Init(){
	PageLogicObj.m_PilotProListTabDataGrid=InitPilotProListTabDataGrid();
	PageLogicObj.m_PilotProPatListTabDataGrid=InitPilotProPatListTabDataGrid();
}
function InitPilotProListTabDataGrid(){
	var Columns=[[ 
		{field:'PPRowId',hidden:true,title:''},
		{field:'PPRName',title:'项目名称',width:407,
			styler: function(value,row,index){
					//return 'border-right:0;';
			}

		}
    ]]
	var PilotProListTabDataGrid=$("#PilotProListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : false,  
		rownumbers : true,  
		idField:'PPRowId',
		columns :Columns,
		onSelect:function(index, row){
			PilotProPatListTabDataGridLoad(row["PPRowId"]);
			$.cm({
				ClassName:"web.PilotProject.DHCDocPilotProCommon",
				MethodName:"GetStartUserByUserID",
				dataType:"text",
				PPRowId:row["PPRowId"],
				UserId:session['LOGON.USERID']
			},function(ret){
				 var arr=ret.split("^")
				 $("#HealthCareProviderDr").val(arr[0]);
				 $("#HealthCareProvider").val(arr[1]);
			}); 
		},
		onUncheck:function(index, row){
			selProjectChange(true);
			PilotProPatListTabDataGridLoad(row["PPRowId"]);
		}
	}); 
	return PilotProListTabDataGrid;
}
function InitPilotProPatListTabDataGrid(){
	var Columns=[[ 
		//{field:'Check',title:'选择',checkbox:'true'},
		{field:'PatDr',hidden:true,title:'',},
		{field:'PPPID',title:'PPPID',width:100},
		{field:'PatName',title:'患者姓名',width:200},
		{field:'PPPAgreementDate',title:'签署知情同意书日期',width:200},
		{field:'PPPReMark',title:'备注',width:200},
		{field:'PPPScreenNo',title:'筛选号',width:200,
			styler: function(value,row,index){
					//return 'border-right:0;';
			}
		}
    ]]
	var PilotProPatListTabDataGrid=$("#PilotProPatListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : false,  
		rownumbers : true,  
		idField:'PatDr',
		columns :Columns,
		//checkOnSelect:true,
		//selectOnCheck:false,
		onSelect:function(index, row){
			ProPatListChangeHander(row["PatDr"]);
		},
		onUncheck:function(index, row){
			ClearProPatInfo();
		}
	}); 
	return PilotProPatListTabDataGrid;
}
function ProPatListChangeHander(SelPatientID){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择项目!");
		return false;
	}
	var PPRowId=row["PPRowId"];
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProPat",
		MethodName:"GetProPatInfo",
		dataType:"text",
		PatientID:SelPatientID,
		PPRowId:PPRowId
	},function(myXML){
		ClearProPatInfo();
		SetProInfoByXML(myXML);
	});
}
function SetProInfoByXML(XMLStr)
{
	xMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	/*var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) { 
		$.messager.alert("提示",xmlDoc.parseError.reason); 
		return false; 
	}*/
	var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
	if (!xmlDoc) return;
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) {
		//var myItemName=nodes(i).nodeName;
		//var myItemValue= nodes(i).text;
		var myItemName = getNodeName(nodes,i);
		var myItemValue = getNodeValue(nodes,i);
		var _$id=$("#"+myItemName);
		if (_$id.hasClass("hisui-combobox")){
			_$id.combobox("select",myItemValue)
		}else if(_$id.hasClass("hisui-datebox")){
			_$id.datebox("setValue",myItemValue)
		}else{
			_$id.val(myItemValue);
		}
	}
	delete(xmlDoc);
}
function ClearProPatInfo() {
	$("#HealthCareProviderDr").val("");
	$("#HealthCareProvider").val("");
	$("#PPPReMark").val("");
	$("#PPPPatientLimit").val("");
	$("#AgreementDate").datebox("setValue","");
	$("#ExitDate").val("");
	$("#CancelReason").val("");
	$("#ScreenNo").val("");
}
function PilotProListTabDataGridLoad(){
	var myArray=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectStrSelf",
		InHosp:session['LOGON.HOSPID'],
		UserID:session['LOGON.USERID'],
		dataType:"text"
	},false);
	for (var i=0;i<myArray.split("^").length;i++){
		var myArrayTemp=myArray.split("^")[i];
		var rtnArrayTemp=myArrayTemp.split(String.fromCharCode(1));
		if (rtnArrayTemp[0]==""){continue;}
		PageLogicObj.m_PilotProListTabDataGrid.datagrid('appendRow',{
			PPRowId: rtnArrayTemp[0],
			PPRName: rtnArrayTemp[1]
		});
	} 
}
function PilotProPatListTabDataGridLoad(PPRowId){
	ClearPilotProPatListTab();
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProPat",
		MethodName:"GetProPatStrByProID",
		PPRowId:PPRowId,
		dataType:"text"
	},function(myArray){
		var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid("getSelected");
		var PPRowId=row["PPRowId"];
		for (var i=0;i<myArray.split("^").length;i++){
			var myArrayTemp=myArray.split("^")[i];
			var rtnArrayTemp=myArrayTemp.split(String.fromCharCode(1));
			if (rtnArrayTemp[0]==""){continue;}
			var XMLStr=$.cm({
				ClassName:"web.PilotProject.DHCDocPilotProPat",
				MethodName:"GetProPatInfo",
				dataType:"text",
				PatientID:rtnArrayTemp[0],
				PPRowId:PPRowId
			},false);
			
			xMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
			/*var xmlDoc=DHCDOM_CreateXMLDOM();
			xmlDoc.async = false;
			xmlDoc.loadXML(XMLStr);
			if(xmlDoc.parseError.errorCode != 0) { 
				$.messager.alert("提示",xmlDoc.parseError.reason); 
				return false; 
			}*/
			var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
			if (!xmlDoc) return;
			var PPPScreenNo="",PPPReMark="",PPPAgreementDate="";
			var nodes = xmlDoc.documentElement.childNodes; 
			for(var k=0; k<nodes.length; k++) {
				//var myItemName=nodes(k).nodeName;
				//var myItemValue= nodes(k).text;
				var myItemName = getNodeName(nodes,k);
				var myItemValue = getNodeValue(nodes,k);
				if (myItemName=="ScreenNo"){
					PPPScreenNo=myItemValue;
				}
				if (myItemName=="PPPReMark"){
					PPPReMark=myItemValue;
				}
				if (myItemName=="AgreementDate"){
					PPPAgreementDate=myItemValue;
				}
			}
			delete(xmlDoc);
			
			PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('appendRow',{
				PatDr: rtnArrayTemp[0],
				PatName: rtnArrayTemp[1],
				PPPScreenNo:PPPScreenNo,
				PPPReMark:PPPReMark,
				PPPID:rtnArrayTemp[2],
				PPPAgreementDate:PPPAgreementDate,
				Check:""
			});
		}
		//PPP_ReMark 10  PPP_AgreementDate 12 PPP_ScreenNo 17
	});
}
function ClearPilotProPatListTab(){
	var rows = PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getRows');
    for(var i=rows.length-1;i>=0;i--){
        var index = PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getRowIndex', rows[i]);  
        PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('deleteRow',index);
    }
}
function EditClick() {
	var row=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择患者!","warning");
		return false;
	}
	if (row.PPPID=="") {
		$.messager.alert("提示","请选择患者!","warning");
		return false;
	}
	var PPRowId = row.PPPID.split("||")[0];
	var myrtn=CheckBeforeSave();
	if (myrtn==false) return;
	
	var AgreementDate=$("#AgreementDate").datebox("getValue");
	var ScreenNo = $.trim($("#ScreenNo").val());
	var PPPReMark = $.trim($("#PPPReMark").val())
	var InPara=ScreenNo+String.fromCharCode(1)+AgreementDate+String.fromCharCode(1)+PPPReMark
	$.cm({
		ClassName:"web.PilotProject.Extend.PatAdd",
		MethodName:"UpdatePat",
		dataType:"text",
		PPPID:row.PPPID,
		InPara:InPara
	},function(rtn){
		var myArray=rtn.split("^");
		if (myArray[0]=='0'){
			$.messager.alert("提示","保存成功!","info",function(){
				PilotProPatListTabDataGridLoad(PPRowId);
				$("#AgreementDate").datebox("setValue","");
				$("#PPPReMark").val("");
				$("#ScreenNo").val("");
			});
		}else{
			$.messager.alert("提示","错误: "+myArray[1]);
		}
	}); 
		
	
}

function SaveClick(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择项目!");
		return false;
	}
	var PPRowId=row["PPRowId"];
	var myrtn=CheckBeforeSave(PPRowId);
	if (myrtn==false) return;
	SaveDataToServer(PPRowId);	
}
function CheckBeforeSave(PPRowId){
	var AgreementDate=$("#AgreementDate").datebox("getValue");
	if (AgreementDate=="") {
		$.messager.alert("提示","签署知情同意书日期不能为空.","info",function (){
			$('#AgreementDate').next('span').find('input').focus();
		});
		return false;
	}
	if(!PageLogicObj.m_DATE_FORMAT.test(AgreementDate)){
	   $.messager.$.messager.alert("提示","签署知情同意书日期格式不正确!","info",function (){
			$('#AgreementDate').next('span').find('input').focus();
		});
	   return false;
   }
   if (ServerObj.sysDateFormat=="4"){
	   var AgDate=AgreementDate.split("/");
	   var minDate = new Date(AgDate[2],AgDate[1],AgDate[0],0,0,0);
   }else{
	   var AgDate=AgreementDate.split("-");
	   var minDate = new Date(AgDate[0],AgDate[1],AgDate[2],0,0,0);
   }
   var myDate = new Date();
   var objDate = new Date(myDate.getFullYear(),myDate.getMonth()+1,myDate.getDate(),0,0,0);
   if (minDate.getTime() > objDate.getTime()) {
		$.messager.alert("提示","签署知情同意书日期不能晚于当前日期！","info",function (){
			$('#AgreementDate').next('span').find('input').focus();
		});
		return false;
   }
   return true;
}
function SaveDataToServer(PPRowId){
	try{
		var myProPatInfo=getProPatInfo();
		$.cm({
			ClassName:"web.PilotProject.DHCDocPilotProPat",
			MethodName:"SaveMethod",
			dataType:"text",
			myProPatInfo:myProPatInfo,
			PPRowId:PPRowId,
			USERID:session['LOGON.USERID'],
			PPPAPPPADr:"",
			InHosp:session['LOGON.HOSPID']
		},function(rtn){
			var myArray=rtn.split("^");
			if (myArray[0]=='0'){
				$.messager.alert("提示","保存成功!","info",function(){
					PilotProPatListTabDataGridLoad(PPRowId);
					$("#AgreementDate").datebox("setValue","");
					$("#PPPReMark").val("");
					$("#ScreenNo").val("");
				});
			}else{
				$.messager.alert("提示","错误: "+myArray[1]);
			}
		}); 
	}catch(E){
		alert(E.message);
		return;
	}
}
function getProPatInfo(){
	var myxml="";
	var myparseinfo = ServerObj.InitProPatEntity;
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
				var myval="";
			}else{
				if ((_$id.hasClass("hisui-combobox"))||(_$id.hasClass("hisui-datebox"))){
					var myval=_$id.combobox("getValue");  
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
		$.messager.alert("提示","Error: " + Err.description);
	}	
	return myxmlstr;
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
