var PageLogicObj={
	m_FreeOrdSetTabDataGrid:"",
	m_PPFItmMastDR:"",
	v_CHosp:""
};
$(function(){
	Init();
	//页面元素初始化
	InitEvent();
	PageHandle();
	FreeOrdSetTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_FreeOrdSetTabDataGrid=InitFreeOrdSetTabDataGrid();
	InitCombox();
}
function InitEvent() {
	$("#BFind").click(FreeOrdSetTabDataGridLoad);
	$("#Clear").click(Clear_Handle)
}
function PageHandle(){
	InitPPFItmMast();
}

function InitCombox() {
	PageLogicObj.m_Stage = $HUI.combobox("#PPFPrjStage", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryStage&PrjDR="+ServerObj.PPRowId+"&ResultSetType=array",
		valueField:'id',
		textField:'stageDesc',
		//required:true,
		blurValidValue:true
	});
	
}

function InitFreeOrdSetTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {Add_Handle(); }
    }/*,{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }*/,{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() { DelClickHandle();}
    },{
        text: '复制',
        iconCls: 'icon-copy',
        handler: function() { CopyClickHandle();}
    }];
    /*
    ArcimRowId:%String,Arcimdesc:%String,Arcimcode:%String,PPFRowId:%String,PPFSttDate:%String,PPFSttTime,PPFEndDate,PPFEndTime,PPFFreeNum
    */
	var Columns=[[ 
		{field:'ck',checkbox:true},
		{field:'PPFRowId',hidden:true,title:''},
		{field:'action',title:'操作',width:50,align:'center',
			formatter:function(value,row,index){
				var s = '<span style="color:#40A2DE;cursor:pointer;" onclick="Edit_Handle(' + "'" +row.PPFRowId+ "'"+ ')">修改</span>';
				return s;
			}
		},
		{field:'PPFStageDesc',title:'阶段',width:100},
		{field:'Arcimdesc',title:'医嘱名称',width:250},
		{field:'PPFFreeNum',title:'免费次数',width:100},
		{field:'PPFSttDate',title:'开始日期',width:100},
		{field:'PPFSttTime',title:'开始时间',width:100},
		{field:'PPFEndDate',title:'结束日期',width:100},
		{field:'PPFEndTime',title:'结束时间',width:100},
		{field:'PPFLimitEntryAfterNoFreeNum',title:'免费次数用尽后限制录入',width:180},
		{field:'PPFAddUser',title:'添加人',width:100},
		{field:'PPFAddLoc',title:'添加科室',width:100},
		{field:'PPFAddDate',title:'添加日期',width:100},
		{field:'PPFAddTime',title:'添加时间',width:100}
		
    ]]
	var FreeOrdSetTabDataGrid=$("#FreeOrdSetTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'PPFRowId',
		columns :Columns,
		toolbar:toobar
		/*onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			Clear();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}*/
	}); 
	return FreeOrdSetTabDataGrid;
}

function FreeOrdSetTabDataGridLoad(){
	var text = $("#PPFItmMastDR").lookup("getText")||"";
	if (text=="") {
		PageLogicObj.m_PPFItmMastDR = "";
		}
	$.q({
	    ClassName : "web.PilotProject.DHCDocPilotProject",
	    QueryName : "FindProFreeOrd",
	    PPRowId: ServerObj.PPRowId, 
	    InArcim: PageLogicObj.m_PPFItmMastDR,
	    InStage: PageLogicObj.m_Stage.getValue()||"",
	    Pagerows: PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitPPFItmMast(){
	var Form=session['LOGON.CTLOCID']+String.fromCharCode(3)+GetHospValue()
	$("#PPFItmMastDR").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'名称',width:350},
           {field:'HIDDEN',title:'医嘱项ID',width:120,sortable:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem','Form':Form},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{Item:desc});	//TYPE:"L^SERVICE"
	    },onSelect:function(ind,item){
		    PageLogicObj.m_PPFItmMastDR=item['HIDDEN'];
		}
    });
}
function AddClickHandle(){
	SaveData('');
}
function DelClickHandle () {
	var selectArr = PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('getSelections');
	if (selectArr.length == 0) {
		$.messager.alert("提示","请选择要删除的记录！","warning")
		return false;
	}
	
	var ids=[];
	for (var i=0; i<selectArr.length; i++) {
		ids.push(selectArr[i].PPFRowId)	
	}
	ids = ids.join(",");
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"web.PilotProject.CFG.FindGCP",
				MethodName:"DelFreeOrder",
				ids:ids
			}, function(result){
				if (result == 0) {
					Clear();
					$.messager.alert("提示", "删除成功！", "info");
					FreeOrdSetTabDataGridLoad();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
	
}

function Edit_Handle(id) {
	if (id=="") {
		$.messager.alert("提示","请选择一行记录！","warning")
		return false;
	}
	var PW = 500,
		PH = 400,
		URL = "docpilotpro.cfg.freeord.edit.csp?id="+id+"&PPRowId="+ServerObj.PPRowId+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改',
		//maximizable:true,
		//maximized:true,
		width:PW,height:PH,
		CallBackFunc:FreeOrdSetTabDataGridLoad
	})
}

function Add_Handle() {
	var id = "",
		PW = 550,
		PH = 500,
		URL = "docpilotpro.cfg.freeord.edit.csp?id="+id+"&PPRowId="+ServerObj.PPRowId+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'增加',
		//maximizable:true,
		//maximized:true,
		width:PW,height:PH,
		CallBackFunc:function () {
			$.messager.popover({msg: '保存成功!',type:'success'});
			FreeOrdSetTabDataGridLoad();
		}
	})
}

function CopyClickHandle () {
	var selectArr = PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('getSelections');
	if (selectArr.length == 0) {
		$.messager.alert("提示","请选择一行记录！","warning")
		return false;
	}
	
	var ids=[];
	for (var i=0; i<selectArr.length; i++) {
		ids.push(selectArr[i].PPFRowId)	
	}
	ids = ids.join(",")
	
	var URL = "docpilotpro.cfg.freeord.copy.csp?ids="+ids+"&PPRowId="+ServerObj.PPRowId;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-copy',
		title:'复制',
		//maximizable:true,
		//maximized:true,
		width:320,height:310,
		CallBackFunc:FreeOrdSetTabDataGridLoad
	})
	
	
}

function Clear_Handle () {
	PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('unselectAll');	
	
	$("#PPFItmMastDR").lookup('setText','');
	PageLogicObj.m_Stage.clear();
	PageLogicObj.m_PPFItmMastDR="";
	FreeOrdSetTabDataGridLoad();
	
}

function UpdateClickHandle(){
	var row=PageLogicObj.m_FreeOrdSetTabDataGrid.datagrid('getSelected');
	if(!row){
		$.messager.alert("提示","请选择一条需要更新的数据!")
		return false
	}
	SaveData(row['PPFRowId']);
}
function SaveData(PPFRowId){
	var myrtn=CheckBeforeUpdate();
	if (myrtn==false)retrun;
	var myExpStr=session['LOGON.USERID'];
	var ArcimIDStr=getProjecctInfo();
	var rtn=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"SaveProFreeOrd",
		PPRowID:ServerObj.PPRowId,
		PPFRowID:PPFRowId,
		ProFreeOrdInfo:ArcimIDStr,
		myExpStr:myExpStr,
		dataType:"text"
	},false)
	if (rtn==0){
		$.messager.popover({msg: '保存成功!',type:'success'});
		Clear();
		FreeOrdSetTabDataGridLoad();
	}else if(rtn==-1){
		$.messager.alert("提示","保存失败!项目重复!","warning");
	}else{
		$.messager.alert("提示","保存失败!","error");
	}
}
function CheckBeforeUpdate(){
	if ($("#PPFItmMastDR").lookup('getText')=="")  PageLogicObj.m_PPFItmMastDR="";
	if (PageLogicObj.m_PPFItmMastDR==""){
		$.messager.alert("提示","请选择医嘱!","info",function(){
			$("#PPFItmMast").next('span').find('input').focus();
		});
		return false;
	}
	var PPFFreeNum=$("#PPFFreeNum").val();
	if (PPFFreeNum==""){
		$.messager.alert("提示","免费次数不能为空!","info",function(){
			$("#PPFFreeNum").next('span').find('input').focus();
		});
		return false;
	}else{
		var reg=/^[1-9]+\d*$/;
		if(!reg.test(PPFFreeNum)){
		    $.messager.alert("提示","免费次数只能是大于0的整数!","info",function(){
				$("#PPFFreeNum").next('span').find('input').focus();
			});
			return false;
		}
	}
	var PPFSttDate=$("#PPFSttDate").datebox('getValue');
	if (PPFSttDate==""){
		$.messager.alert("提示","请选择开始日期!","info",function(){
			$("#PPFSttDate").next('span').find('input').focus();
		});
		return false;
	}
	return true;
}
function SetSelRowData(row){
	$("#PPFItmMastDR").lookup('setText',row['Arcimdesc']);
	PageLogicObj.m_Stage.setValue(row['PPFStageDr']);
	PageLogicObj.m_PPFItmMastDR=row['ArcimRowId'];
	$("#PPFSttDate").datebox('setValue',row['PPFSttDate']);
	$("#PPFEndDate").datebox('setValue',row['PPFEndDate']);
	$("#PPFSttTime").timespinner('setValue',row['PPFSttTime']);
	$("#PPFEndTime").timespinner('setValue',row['PPFEndTime']);
	$("#PPFFreeNum").val(row['PPFFreeNum']);
	if (row['PPFLimitEntryAfterNoFreeNum']=="Y"){
		$("#PPFLimitEntryAfterNoFreeNum").checkbox('check');
	}else{
		$("#PPFLimitEntryAfterNoFreeNum").checkbox('uncheck');
	}
}
function Clear(){
	$("#PPFItmMastDR").lookup('setText','');
	PageLogicObj.m_Stage.clear();
	PageLogicObj.m_PPFItmMastDR="";
	$("#PPFSttDate,#PPFEndDate").datebox('setValue','');
	$("#PPFSttTime,#PPFEndTime").timespinner('setValue','');
	$("#PPFFreeNum").val('');
	$("#PPFLimitEntryAfterNoFreeNum").checkbox('uncheck');
}
function getProjecctInfo(){
	var myxml="";
	var myparseinfo = $("#InitProjectEntity").val();
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
				if (_$id.hasClass("hisui-combobox")){
					var myval=_$id.combobox("getValue");
					if (myval==undefined) myval="";
					if (myval!=""){
						myval=myval.split("^")[0];
					}
				}else if(_$id.hasClass("hisui-datebox")){
					var myval=_$id.datebox("getValue");
				}else if(_$id.hasClass("hisui-timespinner")){
					var myval=_$id.timespinner("getValue");
				}else if(myary[myIdx]=="PPFItmMastDR"){
					if ($("#PPFItmMastDR").lookup('getText')=="")  PageLogicObj.m_PPFItmMastDR="";
					var myval=PageLogicObj.m_PPFItmMastDR;
				}else if(_$id.hasClass("hisui-checkbox")){
					var myval="N";
					if (_$id.checkbox("getValue")){
						myval="Y";
					}
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

function GetHospValue() {
	PageLogicObj.v_CHosp = ServerObj.InHosp
	
	return PageLogicObj.v_CHosp
}