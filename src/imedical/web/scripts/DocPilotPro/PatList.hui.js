var PageLogicObj={
	m_PilotProPatListTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100
};
$(function(){	
	//页面数据初始化
	Init();
	//页面元素初始化
	PageHandle();
	//加载分诊区表格数据
	PilotProPatListTabDataGridLoad();
	//事件初始化
	InitEvent();
});
function InitEvent(){
	$("#BFind").click(PilotProPatListTabDataGridLoad);
	$("#BClean").click(BCleanHandler);
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
	//进入科研病人列表清除头菜单的选择信息
	/*var frm=dhcsys_getmenuform();
	if (frm){
		frm.PPRowId.value="";
		frm.EpisodeID.value="";
		frm.PatientID.value="";
	}*/
}
function LoadProjectList(){
	var ret=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectStrDocSelf",
		dataType:"text",
		UserID:session['LOGON.USERID'],
		InHosp:session['LOGON.HOSPID']
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
	 
	 /*$HUI.combobox("#PatStatus", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			data: [
				{id:'',text:'全部'},
				{id:'R',text:'退出'},{id:'N',text:'在组'},
				{id:'C',text:'取消'},{id:'O',text:'完成'}
				
			]
	 });*/
	 
	 $HUI.combobox("#PatStatus", {
		url:$URL+"?ClassName=web.PilotProject.DHCDocPilotProPat&QueryName=QryPatStatus&ResultSetType=array",
		valueField:'id',
		textField:'text',
		//required:true,
		blurValidValue:true
	});
	
}
function Init(){
	PageLogicObj.m_PilotProPatListTabDataGrid=InitPilotProPatListTabDataGrid();
}
function InitPilotProPatListTabDataGrid(){
	var toobar=[{
        text: '入组状态改变',
        iconCls: 'icon-write-order',
        handler: function() {CancelClickHandle(); }
    },
    {
        text: '阶段变更',
        iconCls: 'icon-write-order',
        handler: function() {Stage_Handle(); }
    }];
	var Columns=[[ 
		{field:'PPRowId',hidden:true,title:''},
		{field:'PPPRowId',hidden:true,title:''},
		{field:'PatientID',hidden:true,title:''},
		{field:'EpisodeID',hidden:true,title:''},
		{field:'mradm',hidden:true,title:''},
		{field:'Stage',title:'阶段',width:100},
		{field:'PAPMINO',title:'登记号',width:100},
		{field:'PAPMIName',title:'患者姓名',width:100},
		{field:'PAPMIDOB',title:'出生日期',width:100},
		{field:'PAPMISex',title:'性别',width:50},
		{field:'AddProDate',title:'加入日期',width:100},
		{field:'AddProTime',title:'加入时间',width:100},
		{field:'AddProUser',title:'加入人',width:100},
		{field:'PatStatus',title:'状态',width:50,
			styler: function(value,row,index){
				if (value == "退出"){
					return 'background-color:#BEBEBE;';
				}
			}
		},
		{field:'PAAdmType',title:'就诊类型',width:80},
		{field:'Hospital',title:'医院',width:120},
		{field:'PAAdmWard',title:'病区',width:120},
		{field:'PAAdmBed',title:'床号',width:50},
		{field:'PAAdmReason',title:'病人类型',width:80},
		{field:'Diagnosis',title:'诊断',width:120},
		{field:'CancelDate',title:'退出日期',width:100},
		{field:'Age',title:'年龄',width:50},
		{field:'ProPatReMark',title:'备注',width:100},
		//{field:'CancelUser',title:'备注',width:100},
		{field:'CancelReason',title:'退出原因',width:100},
		{field:'TPPDesc',title:'所属科研项目',width:100},
		{field:'ScreenNo',title:'筛选号',width:120}
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
				$.messager.alert("提示",$g("非在组状态不能选择"),"info");
				$("#PilotProPatListTab").datagrid("clearSelections");
				
			}
			
		},
		onBeforeSelect:function(index, row){
			var oldSelRow=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getSelected');
			var oldSelIndex=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('unselectRow',index);
				/*var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value="";
					frm.EpisodeID.value="";
					frm.PatientID.value="";
					frm.mradm.value="";
				}*/
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
		InHosp:session['LOGON.HOSPID'],
		Pagerows:PageLogicObj.m_PilotProPatListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		/*var frm=dhcsys_getmenuform();
		if (frm){
			frm.PPRowId.value="";
			frm.EpisodeID.value="";
			frm.PatientID.value="";
			frm.mradm.value="";
		}*/
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
function BCleanHandler() {
	$("#PatientNo,#PatName").val("");	
	$("#PatStatus").combobox("setValue","");
	$("#PPDesc").combobox("clear");
	$("#StartDate,#EndDate").datebox("clear")
	PilotProPatListTabDataGridLoad();
}
function ExportClickHandle(){
	var src="docpilotpro.labresultexport.hui.csp";
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project",$g("导出检验结果"), 275, 240,"icon-w-export","",$code,"");
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
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function Stage_Handle () {
	var row=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择记录!","warning");
		return false;
	}
	var PPRowId=row["PPRowId"];
	var PPPatid=row["PPPRowId"];
	var URL = "docpilotpro.bs.patlist.stage.csp?PPPatid="+PPPatid+"&PPRowId="+PPRowId;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:$g('阶段修改'),
		width:320,height:240,
		CallBackFunc:PilotProPatListTabDataGridLoad
	})
	
	
	
}

function CancelClickHandle(){
	var row=PageLogicObj.m_PilotProPatListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示",$g("请选择记录!"),"warning");
		return false;
	}
	var PatStatus=row['PatStatus'];
	var VisitState=row['VisitState'];
	if (VisitState!="N"){
		$.messager.alert("提示","患者已"+PatStatus+"!");
		return false;
	}
	var EpisodeID=row["EpisodeID"];
	var PatientID=row["PatientID"];
	var PPRowId=row["PPRowId"];
	var PPPatid=row["PPPRowId"];
	var src="docpilotpro.patcancel.hui.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PPRowId="+PPRowId+"&PPPatid="+PPPatid;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project",$g("入组状态改变"), 526, 340,"icon-w-edit","",$code,"");
}