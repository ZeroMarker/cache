var PageLogicObj={
	m_RoomCompTabDataGrid:""
};
$(function(){
	InitHospList();
	InitEvent();
});
function InitHospList(){
	//初始化医院
	var hospComp = GenHospComp("DHCRoomComp");
	hospComp.jdata.options.onSelect = function(e,t){
		//页面元素初始化
		PageHandle();
		RoomCompTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		//页面元素初始化
		PageHandle();
		RoomCompTabDataGridLoad();
	}
}
function InitEvent(){
	$('#Bfind').click(RoomCompTabDataGridLoad);
}
function Init(){
	PageLogicObj.m_RoomCompTabDataGrid=InitRoomCompTabDataGrid();
}
function PageHandle(){
	InitRoom();
}
function InitRoomCompTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'计算机代码',width:200},
		{field:'Tname',title:'计算机名称',width:200},
		{field:'Tip',title:'IP地址',width:200},
		{field:'Troom',title:'所属诊室',width:200}
    ]]
	var RoomCompTabDataGrid=$("#RoomCompTab").datagrid({
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
			var selrow=PageLogicObj.m_RoomCompTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RoomCompTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RoomCompTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return RoomCompTabDataGrid;
}
function RoomCompTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindDHCRoomComp",
	    roomid:$("#room").combobox('getValue'), 
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_RoomCompTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RoomCompTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_RoomCompTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitRoom(){
	//初始化诊室
	$.cm({
		ClassName:"web.DHCOPBorExaRoom",
		QueryName:"FindDHCExaRoom",
		dataType:"json",
		room:"",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#room", {
				valueField: 'rid',
				textField: 'name', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
				}
		 });
	});
}
function SetSelRowData(row){
	$("#code").val(row['Tcode']);
	$("#name").val(row['Tname']);
	$("#IP").val(row['Tip']);
	$("#room").combobox('select',row['Troomid']);
}
function AddClickHandle(){
   if(!CheckData()) return false;
   var code=$("#code").val();
   var name=$("#name").val();
   var ip=$("#IP").val();
   var roomid=$("#room").combobox('getValue');
   if (roomid==undefined) roomid="";
   tkMakeServerCall("web.DHCExaBorough","insertRoomComp",'SetPid','',code,name,ip,roomid);
}
function DelClickHandle(){
   var row=PageLogicObj.m_RoomCompTabDataGrid.datagrid('getSelected');
   if (!row){
	   $.messager.alert("提示","请选择需要删除的数据!");
	   return false;
   }
   tkMakeServerCall("web.DHCExaBorough","delRoomComp",'Setdel','',row['Tid']);
}
function UpdateClickHandle(){
   var row=PageLogicObj.m_RoomCompTabDataGrid.datagrid('getSelected');
   if (!row){
	   $.messager.alert("提示","请选择需要更新的数据!");
	   return false;
   }
   if(!CheckData()) return false;
   var code=$("#code").val();
   var name=$("#name").val();
   var ip=$("#IP").val();
   var roomid=$("#room").combobox('getValue');
   if (roomid==undefined) roomid="";
   tkMakeServerCall("web.DHCExaBorough","updateRoomComp",'SetPid','',code,name,ip,roomid,row['Tid']);
}
function CheckData(){
	var code=$("#code").val();
	if (code==""){
		$.messager.alert("提示","计算机代码不能为空!","info",function(){
			$("#code").focus();
		});
	   return false;
	}
	var name=$("#name").val();
	if (name==""){
		$.messager.alert("提示","计算机名称不能为空!","info",function(){
			$("#name").focus();
		});
	   return false;
	}
	var ip=$("#IP").val();
	if (ip==""){
		$.messager.alert("提示","IP地址不能为空!","info",function(){
			$("#IP").focus();
		});
	   return false;
	}
	var room=$("#room").combobox('getValue');
	if (room==undefined) room="";
	if (room==""){
		$.messager.alert("提示","所属诊室不能为空!","info",function(){
			$("#room").next('span').find('input').focus();
		});
	   return false;
	}
	return true;
}
function Setdel(value){
	if (value==0){
		$.messager.popover({msg: '删除成功!',type:'success'});
		ClearData();
		RoomCompTabDataGridLoad();
	}else{
		$.messager.alert("提示","删除失败!"+value);
	}
}
function SetPid(value){
	if (value==0){
		$.messager.popover({msg: '保存成功!',type:'success'});
		ClearData();
		RoomCompTabDataGridLoad();
	}else if(value<0){
		$.messager.alert("提示","保存失败!"+value);
	}else{
		$.messager.alert("提示","保存失败!计算机代码或计算机名称或IP地址重复!");
	}
}
function ClearData(){
	$("#room").combobox("select","");
	$("#code,#name,#IP").val('');
}