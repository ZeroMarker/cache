var PageLogicObj={
	m_PilotProPatListTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100
};
$(function(){	
	//ҳ�����ݳ�ʼ��
	Init();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//���ط������������
	PilotProPatListTabDataGridLoad();
	//�¼���ʼ��
	InitEvent();
});
function InitEvent(){
	$("#BFind").click(PilotProPatListTabDataGridLoad);
	$("#BExport").click(ExportClickHandle);
	$("#PatientNo").keydown(PapmiNoKeyDownHander);
	$("#PatName").keydown(PatNameKeyDownHander);
	$("#PatName").change(PatNameChange);
}
function PatNameKeyDownHander(e){
	var key=websys_getKey(e);
	if (key==13){
		PatNameChange()
	}
}
function PatNameChange(){
	$("#PatientNo").val("");
}
function PapmiNoKeyDownHander(e){
	var key=websys_getKey(e);
	if (key==13){
		SetPapmiNoLenth();
		SetPatInfo();
		PilotProPatListTabDataGridLoad();
	}
}
function SetPapmiNoLenth()
{
	var PatientNo=$('#PatientNo').val();
	var m_PAPMINOLength=10;
	if (PatientNo!='') {
		if ((PatientNo.length<m_PAPMINOLength)&&(m_PAPMINOLength!=0)) {
			for (var i=(m_PAPMINOLength-PatientNo.length-1); i>=0; i--) {
				PatientNo="0"+PatientNo;
			}
		}	
	}
	$('#PatientNo').val(PatientNo);
}
function SetPatInfo(){
	var PatientNo=$('#PatientNo').val();
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetPatientByNo",
		dataType:"text",
		PapmiNo:PatientNo
	},function(rtnStr){
		if (rtnStr!=""){
			var rtnStrTemp=rtnStr.split("^");
			var myStr=rtnStrTemp[1]+","+rtnStrTemp[2]+","+rtnStrTemp[3]+","+rtnStrTemp[4];
			$("#PatientID").val(rtnStrTemp[0]);
			$("#PatName").val(rtnStrTemp[2]);
		}else{
			$("#PatientID").val("");
			$("#PatName").val("");
		}
	}); 
}
function PageHandle(){
	LoadProjectList();
	//������в����б����ͷ�˵���ѡ����Ϣ
	var frm=dhcsys_getmenuform();
	if (frm){
		frm.PPRowId.value="";
		frm.EpisodeID.value="";
		frm.PatientID.value="";
	}
}
function LoadProjectList(){
	var ret=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectStrDocSelf",
		dataType:"text",
		UserID:session['LOGON.USERID']
	},false); 
	var arrDate=new Array();
	for (var i=0;i<ret.split("^").length;i++){
		var PPRowId=ret.split("^")[i].split(String.fromCharCode(1))[0];
		var PPName=ret.split("^")[i].split(String.fromCharCode(1))[1];
		var PlanName=ret.split("^")[i].split(String.fromCharCode(1))[2];
		arrDate.push({"id":PPRowId,"text":PPName,"PlanName":PlanName});
	}
	var cbox = $HUI.combobox("#PPDesc", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			data: arrDate,
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#PPDesc");
					cbox.setValue("");
				}
			}
	 });
	 
	 $HUI.combobox("#PatStatus", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			data: [
				{id:'',text:'ȫ��'},
				{id:'R',text:'�˳�'},{id:'N',text:'����'},
				{id:'C',text:'ȡ��'},{id:'O',text:'���'}
				
			]
	 });
	 
}
function Init(){
	PageLogicObj.m_PilotProPatListTabDataGrid=InitPilotProPatListTabDataGrid();
}
function InitPilotProPatListTabDataGrid(){
	var toobar=[{
        text: 'ȡ��',
        iconCls: 'icon-cancel',
        handler: function() {CancelClickHandle(); }
    }];
	var Columns=[[ 
		{field:'PPRowId',hidden:true,title:''},
		{field:'PPPRowId',hidden:true,title:''},
		{field:'PatientID',hidden:true,title:''},
		{field:'EpisodeID',hidden:true,title:''},
		{field:'mradm',hidden:true,title:''},
		{field:'PAPMINO',title:'�ǼǺ�',width:100},
		{field:'PAPMIName',title:'��������',width:100},
		{field:'PAPMIDOB',title:'��������',width:100},
		{field:'PAPMISex',title:'�Ա�',width:50},
		{field:'AddProDate',title:'��������',width:100},
		{field:'AddProTime',title:'����ʱ��',width:100},
		{field:'AddProUser',title:'������',width:100},
		{field:'PatStatus',title:'״̬',width:50,
			styler: function(value,row,index){
				if (value == "�˳�"){
					return 'background-color:#BEBEBE;';
				}
			}
		},
		{field:'PAAdmType',title:'��������',width:80},
		{field:'Hospital',title:'ҽԺ',width:120},
		{field:'PAAdmWard',title:'����',width:120},
		{field:'PAAdmBed',title:'����',width:50},
		{field:'PAAdmReason',title:'��������',width:80},
		{field:'Diagnosis',title:'���',width:120},
		{field:'CancelDate',title:'�˳�����',width:100},
		{field:'Age',title:'����',width:50},
		{field:'ProPatReMark',title:'��ע',width:100},
		//{field:'CancelUser',title:'��ע',width:100},
		{field:'CancelReason',title:'�˳�ԭ��',width:100},
		{field:'TPPDesc',title:'����������Ŀ',width:100},
		{field:'ScreenNo',title:'ɸѡ��',width:100}
    ]]
	var PilotProPatListTabDataGrid=$("#PilotProPatListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 15,
		pageList : [15,100,200],  
		rownumbers : true,  
		idField:'PPPRowId',
		columns :Columns,
		toolbar:toobar,
		onSelect:function(index, row){
			var PPRowId=row["PPRowId"];
			if (row.VisitState=="N") {
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value=row["PPRowId"];
					frm.EpisodeID.value=row["EpisodeID"];
					frm.PatientID.value=row["PatientID"];
					frm.mradm.value=row["mradm"];
				}
			} else {
				$.messager.alert("��ʾ","������״̬����ѡ��","info");
				$("#PilotProPatListTab").datagrid("clearSelections");
				
			}
			
		},
		onBeforeSelect:function(index, row){
			var oldSelRow=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getSelected');
			var oldSelIndex=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('unselectRow',index);
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value="";
					frm.EpisodeID.value="";
					frm.PatientID.value="";
					frm.mradm.value="";
				}
				return false;
			}
		}
	}); 
	return PilotProPatListTabDataGrid;
}
function PilotProPatListTabDataGridLoad(){
	
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProPat",
		QueryName:"FindProPatByUser",
		dataType:"json",
		CardTypeDefine:"",
		CardNo:"",
		PatientNo:$("#PatientNo").val(),
		PatName:$("#PatName").val(),
		StartDate:$("#StartDate").datebox("getValue"),
		EndDate:$("#EndDate").datebox("getValue"),
		UserID:session['LOGON.USERID'],
		UserLoc:session['LOGON.CTLOCID'],
		PPRowId:$("#PPDesc").combobox("getValue"),
		All:ServerObj.All,
		PPStatus:$("#PatStatus").combobox("getValue"),
		Pagerows:PageLogicObj.m_PilotProPatListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		var frm=dhcsys_getmenuform();
		if (frm){
			frm.PPRowId.value="";
			frm.EpisodeID.value="";
			frm.PatientID.value="";
			frm.mradm.value="";
		}
		PageLogicObj.m_PilotProPatListTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_PilotProPatListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
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
function ExportClickHandle(){
	var src="docpilotpro.labresultexport.hui.csp";
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","����������", 300, 230,"icon-w-export","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
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
function CancelClickHandle(){
	var row=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ���¼!");
		return false;
	}
	var PatStatus=row['PatStatus'];
	if (PatStatus!="����"){
		$.messager.alert("��ʾ","������"+PatStatus+"!");
		return false;
	}
	var EpisodeID=row["EpisodeID"];
	var PatientID=row["PatientID"];
	var PPRowId=row["PPRowId"];
	var src="docpilotpro.patcancel.hui.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PPRowId="+PPRowId;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","����ȡ������", 526, 345,"icon-w-edit","",$code,"");
}