var PageLogicObj={
	m_SuspendReasonTabDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//������ݳ�ʼ��
	SuspendReasonTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_SuspendReasonTabDataGrid=InitSuspendReasonTabDataGrid();
}
function InitEvent(){
	$("#Bfind").click(SuspendReasonTabDataGridLoad)
}
function InitSuspendReasonTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:''},
		{field:'Code',title:'����',width:300},
		{field:'Desc',title:'ԭ��',width:300},
		{field:'DateFrom',title:'��Ч����',width:250},
		{field:'DateTo',title:'��ֹ����',width:250}
    ]]
	var SuspendReasonTabDataGrid=$("#SuspendReasonTab").datagrid({
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
		idField:'RowID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_SuspendReasonTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_SuspendReasonTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_SuspendReasonTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return SuspendReasonTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Code"])
	$("#name").val(row["Desc"])
	$("#StartDate").datebox('setValue',row["DateFrom"])
	$("#EndDate").datebox('setValue',row["DateTo"])
}
function SuspendReasonTabDataGridLoad(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	$.q({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		QueryName:"FindSuspendReason",
		TCode:Code,
		TDesc:Name,
		AllFlag:"Y",
		Pagerows:PageLogicObj.m_SuspendReasonTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_SuspendReasonTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function AddClickHandle(){
	if(!CheckData()) return false;
	var Code=$("#code").val()
	var Name=$("#name").val()
	var DateFrom=$("#StartDate").datebox("getValue")
	var DateTo=$("#EndDate").datebox("getValue")
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��!")
		return false;
	}
	if(Name==""){
		$.messager.alert("��ʾ","��������Ϊ��!")
		return false;
	}
	$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"InsertSuspendReason",
		RowID:"", Code:Code, Desc:Name, DateFrom:DateFrom, DateTo:DateTo,
		dataType:"text"
	},function(rtn){
		if(rtn=="0"){
			$.messager.alert("��ʾ","�����ɹ�!")
			ClearData()
			SuspendReasonTabDataGridLoad()
		}else{
			$.messager.alert("��ʾ",rtn)
			return false;
		}
	})
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_SuspendReasonTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	if(!CheckData()) return false;
	var RowId=row["RowID"]
	var Code=$("#code").val()
	var Name=$("#name").val()
	var DateFrom=$("#StartDate").datebox("getValue")
	var DateTo=$("#EndDate").datebox("getValue")
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��!")
		return false;
	}
	$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"InsertSuspendReason",
		dataType:"text",
		RowID:RowId, Code:Code, Desc:Name, DateFrom:DateFrom, DateTo:DateTo
	},function(rtn){
		if(rtn=="0"){
			$.messager.alert("��ʾ","���³ɹ�!")
			ClearData()
			SuspendReasonTabDataGridLoad()
		}else{
			$.messager.alert("��ʾ",rtn)
			return false;
		}
	})
}
function ClearData(){
	$("#code").val("")
	$("#name").val("")
	$("#StartDate").datebox('setValue',"")
	$("#EndDate").datebox('setValue',"")
}
function CheckData(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	if(Code==""){$.messager.alert("��ʾ","���������!");return false;}
	if(Name==""){$.messager.alert("��ʾ","������ԭ��!");return false;}
	if(StDate==""){$.messager.alert("��ʾ","��������Ч����!");return false;}
	return true;
}
function DHCStringToXml(Key,Value){
	return "<"+Key+">"+Value+"</"+Key+">"
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