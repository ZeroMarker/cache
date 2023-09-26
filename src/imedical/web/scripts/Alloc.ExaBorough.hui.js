var PageLogicObj={
	m_ExaBoroughTabDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	//���ط������������
	ExaBoroughTabDataGridLoad();
});
$(window).load(function() {
	InitPopover();
})
function Init(){
	var hospComp = GenHospComp("DHCExaBorough");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ExaBoroughTabDataGridLoad();
		ClearData();
	}
	PageLogicObj.m_ExaBoroughTabDataGrid=InitExaBoroughTabDataGrid();
}
function InitExaBoroughTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }, {
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'����',width:200},
		{field:'Tname',title:'����',width:200},
		{field:'Tmemo',title:'��ע',width:200},
		{field:'TCheckin',title:'�Ƿ񱨵�',width:90},
		{field:'TAutoCheckin',title:'�Ƿ��ѯ���Զ�����',width:150},
		{field:'TFristReson',title:'�Ƿ���Ҫ��д����ԭ��',width:150},
		{field:'TNoCheckinDocCanRecAdm',title:'δ�����ɾ���',width:100},
		{field:'TCreatQueueNo',title:'�����������к�',width:100},
		{field:'TDelayQueueNo',title:'�����ٵ��ͷ�',width:100},
		{field:'TCallDelayQueueNo',title:'���ųͷ�',width:100},
		{field:'TCallFilePath',title:'����Ŀ¼',width:200},
		{field:'TWaitFilePath',title:'�Ⱥ�Ŀ¼',width:200},
		{field:'THospital',title:'ҽԺ',width:300}
    ]]
	var ExaBoroughTabDataGrid=$("#ExaBoroughTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return ExaBoroughTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Tcode"]);
	$("#name").val(row["Tname"]);
	$("#memo").val(row["Tmemo"]);
	$("#CallFilePath").val(row["TCallFilePath"]);
	$("#WaitFilePath").val(row["TWaitFilePath"]);
	$("#FristReson").checkbox('setValue',row["TFristReson"]=="Y"?true:false);
	$("#Checkin").checkbox('setValue',row["TCheckin"]=="Y"?true:false);
	$("#AutoReportCheckin").checkbox('setValue',row["TAutoCheckin"]=="Y"?true:false);
	$("#NoCheckinDocCanRecAdm").checkbox('setValue',row["TNoCheckinDocCanRecAdm"]=="Y"?true:false);
	$("#CreatQueueNo").checkbox('setValue',row["TCreatQueueNo"]=="Y"?true:false);
	$("#DelayQueueNo").checkbox('setValue',row["TDelayQueueNo"]=="Y"?true:false);
	$("#CallDelayQueueNo").checkbox('setValue',row["TCallDelayQueueNo"]=="Y"?true:false);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var CallFilePath=$("#CallFilePath").val();
	var WaitFilePath=$("#WaitFilePath").val();
	var Checkin=$("#Checkin").checkbox('getValue')?"Y":"N";
	var ExabAutoReport=$("#AutoReportCheckin").checkbox('getValue')?"Y":"N";
	var FristReson=$("#FristReson").checkbox('getValue')?"Y":"N";
	var NoCheckinDocCanRecAdm=$("#NoCheckinDocCanRecAdm").checkbox('getValue')?"Y":"N";
	var CreatQueueNo=$("#CreatQueueNo").checkbox('getValue')?"Y":"N";
	var DelayQueueNo=$("#DelayQueueNo").checkbox('getValue')?"Y":"N";
	var CallDelayQueueNo=$("#CallDelayQueueNo").checkbox('getValue')?"Y":"N";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var OtherStr=CreatQueueNo+"^"+DelayQueueNo+"^"+CallDelayQueueNo+"^"+HospID
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertExaB",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		Checkin:Checkin,
		ExabSubCallFilePath:CallFilePath,
		ExabSubWaitFilePath:WaitFilePath,
		ExabAutoReport:ExabAutoReport,
		FristReson:FristReson,
		NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
		OtherStr:OtherStr
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���ӳɹ�!");
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
			ExaBoroughTabDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var CallFilePath=$("#CallFilePath").val();
	var WaitFilePath=$("#WaitFilePath").val();
	var Checkin=$("#Checkin").checkbox('getValue')?"Y":"N";
	var ExabAutoReport=$("#AutoReportCheckin").checkbox('getValue')?"Y":"N";
	var FristReson=$("#FristReson").checkbox('getValue')?"Y":"N";
	var NoCheckinDocCanRecAdm=$("#NoCheckinDocCanRecAdm").checkbox('getValue')?"Y":"N";
	var CreatQueueNo=$("#CreatQueueNo").checkbox('getValue')?"Y":"N";
	var DelayQueueNo=$("#DelayQueueNo").checkbox('getValue')?"Y":"N";
	var CallDelayQueueNo=$("#CallDelayQueueNo").checkbox('getValue')?"Y":"N";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var OtherStr=CreatQueueNo+"^"+DelayQueueNo+"^"+CallDelayQueueNo+"^"+HospID
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"updateExaB",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		rowid:row["Tid"],
		Checkin:Checkin,
		ExabSubCallFilePath:CallFilePath,
		ExabSubWaitFilePath:WaitFilePath,
		ExabAutoReport:ExabAutoReport,
		ExabFristReson:FristReson,
		NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
		OtherStr:OtherStr,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '���³ɹ�!',type:'success'});
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_ExaBoroughTabDataGrid.datagrid("getRowIndex",row),
				row: {
					Tcode: code,
					Tname: name,
					Tmemo:memo,
					TCheckin: Checkin,
					TCallFilePath: CallFilePath,
					TWaitFilePath:WaitFilePath,
					TAutoCheckin:ExabAutoReport,
					TNoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
					TFristReson:FristReson,
					TCreatQueueNo:CreatQueueNo,
					TDelayQueueNo:DelayQueueNo,
					TCallDelayQueueNo:CallDelayQueueNo
				}
			});
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"delExaB",
		itmjs:"",
		itmjsex:"",
		rid:row["Tid"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","ɾ���ɹ�!");
			ClearData();
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
			ExaBoroughTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
			return false;
		}
	});
}
function ClearData(){
	$("#code,#name,#memo,#CallFilePath,#WaitFilePath").val("");
	$("#Checkin,#AutoReportCheckin,#FristReson,#TNoCheckinDocCanRecAdm").checkbox('uncheck');
}
function CheckDataValid(){
	var code=$("#code").val();
	if (code==""){
		$.messager.alert("��ʾ","����д����!","info",function(){$("#code").focus();});
		return false;
	}
	var name=$("#name").val();
	if (name==""){
		$.messager.alert("��ʾ","����д����!","info",function(){$("#name").focus();});
		return false;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (HospID==""){
		$.messager.alert("��ʾ","��ѡ��ҽԺ!","info");
		return false;
	}
	return true;
}
function ExaBoroughTabDataGridLoad(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindExaBorough",
	    depid : "",
	    HospId :HospID,
	    Pagerows:PageLogicObj.m_ExaBoroughTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitPopover(){
	$("#DelayQueueNo").next().popover({
		title:'����',
		style:'inverse',
		content:"�ڷ�ʱ�ε������,���˾���ʱ�α�������Ϊ�ٵ����ߣ����ڵ�ǰʱ�ε����һ����",
		placement:'bottom',
		trigger:'hover'
	});
	$("#CallDelayQueueNo").next().popover({
		title:'����',
		width:'400px',
		height:'320px;',
		style:'inverse',
		content:"�ڷ�ʱ�ε������,��һ�ι������±���,�ŵ���ǰʱ�ε����һ��;�ڶ��ι������±���,�ŵ���ǰʱ�ε���һ��ʱ�ε����һ��;�����μ����Ϲ������±���,�ŵ����ʱ�ε����һ����",
		placement:'auto-bottom',
		trigger:'hover'
	});
}