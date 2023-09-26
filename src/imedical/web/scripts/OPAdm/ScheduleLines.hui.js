var PageLogicObj={
	m_ScheduleLinesTabDataGrid:"",
	m_ReHospitalDataGrid:""
};
$(function(){
	var hospComp = GenUserHospComp();
	//初始化
	Init();
	InitEvent();
	hospComp.jdata.options.onSelect = function(e,t){
		//表格数据初始化
		ScheduleLinesTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//表格数据初始化
		ScheduleLinesTabDataGridLoad();
	}
});
function InitEvent(){
	$("#BSave").click(BSaveClickHandle);
}
function Init(){
	PageLogicObj.m_ScheduleLinesTabDataGrid=InitScheduleLinesTabDataGrid();
}
function InitScheduleLinesTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	        ClearEditWindow();
	        PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('unselectAll');
	        OpenWin('新建');
	    }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '修改',
        iconCls: 'icon-save',
        handler: function() {
	        var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
	        if (!row){
		        $.messager.alert('提示','请先选择需要修改的记录!');
		        return false;
		    }
		    SetEditWindow(row);	        
	        OpenWin('修改');
	    }
    }, {
        text: '医院授权',
        iconCls: 'icon-house',
        handler: function() { ReHospitalHandle();}
    }];
	var Columns=[[ 
		{field:'Code',title:'代码',width:100},
		{field:'Desc',title:'描述',width:100},
		{field:'StartDate',title:'开始日期',width:100},
		{field:'EndDate',title:'结束日期',width:100},
		{field:'Notes',title:'备注',width:150},
		{field:'Default',title:'是否默认',width:100,
			formatter:function(value,record){
	 			if (value=="Y") return "是";
	 			else  return "否";
	 		},styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
			}
		},
		{field:'AddUser',title:'增加人',width:100},
		{field:'AddLoc',title:'增加科室',width:100},
		{field:'AddDate',title:'增加日期',width:100},
		{field:'AddTime',title:'增加时间',width:100},
		{field:'RSLRowId',title:'RSLRowId',width:100,hidden:true}
    ]]
	var ScheduleLinesTabDataGrid=$("#ScheduleLinesTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'RSLRowId',
		columns :Columns,
		toolbar:toobar,
		onDblClickRow:function(index, row){
			SetEditWindow(row);	        
	        OpenWin('修改');
		}
	});
	return ScheduleLinesTabDataGrid;
}
function ScheduleLinesTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCApptScheduleLines",
	    QueryName : "RBScheduleLinesList",
	    HospID:$HUI.combogrid('#_HospUserList').getValue(),
	    Pagerows:PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('unselectAll');
		PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function ClearEditWindow(){
	$("#Code,#Desc,#Notes").val('');
	$("#StartDate,#EndDate").datebox('setValue','');
	$("#Default").checkbox('uncheck');
}
function SetEditWindow(row){
	$("#Code").val(row['Code']);
	$("#Desc").val(row['Desc']);
	$("#Notes").val(row['Notes']);
	$("#StartDate").datebox('setValue',row['StartDate']);
	$("#EndDate").datebox('setValue',row['EndDate']);
	if (row['Default']=="Y"){
		$("#Default").checkbox('check');
	}else{
		$("#Default").checkbox('uncheck');
	}
}
function BSaveClickHandle(){
	var Code=$("#Code").val();
	if (Code==""){
		$.messager.alert("提示","请输入代码!","info",function(){
			$("#Code").focus();
		});
		return false;
	}
	var Desc=$("#Desc").val();
	if (Desc==""){
		$.messager.alert("提示","请输入描述!","info",function(){
			$("#Desc").focus();
		});
		return false;
	}
	var Notes=$("#Notes").val();
	var StartDate=$("#StartDate").datebox('getValue');
	if (StartDate==""){
		$.messager.alert("提示","请输入开始日期!","info",function(){
			$("#StartDate").next('span').find('input').focus();
		});
		return false;
	}
	var EndDate=$("#EndDate").datebox('getValue');
	var Default="N";
	if ($("#Default").checkbox('getValue')) Default="Y";
	var para=Code+"^"+Desc+"^"+StartDate+"^"+EndDate+"^"+Notes+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+Default;
	var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
	if (row) var RSLRowId=row['RSLRowId'];
	else var RSLRowId="";
	$.cm({
		ClassName:"web.DHCApptScheduleLines",
		MethodName:"Save",
		RSLRowId:RSLRowId,
		para:para,
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		dataType:'text'
	},function(rtn){
		if (rtn==0){
			$.messager.popover({msg: "保存成功!",type:'success'});
			ScheduleLinesTabDataGridLoad();
			$('#EditWindow').window('close');
		}else{
			$.messager.alert("提示","保存失败!");
			return false;
		}
	});
}
function OpenWin(WinTitle){
	$('#EditWindow').window({
		title: WinTitle,
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true
	});
	$("#Code").focus();
}
function DelClickHandle(){
	var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
    if (!row){
        $.messager.alert('提示','请先选择需要删除的记录!');
        return false;
    }
    $.messager.confirm('确认对话框', '是否确定删除 <font color=red>'+row['Desc']+" </font>?", function(r){
		if (r){
		    var RSLRowId=row['RSLRowId'];
		    $.cm({
				ClassName:"web.DHCApptScheduleLines",
				MethodName:"Delete",
				RSLRowId:RSLRowId,
				dataType:'text'
			},function(rtn){
				if (rtn==0){
					$.messager.popover({msg: "删除成功!",type:'success'});
					ScheduleLinesTabDataGridLoad();
				}else{
					$.messager.alert("提示","删除失败!");
					return false;
				}
			});
		}
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
function ReHospitalHandle(){
	var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	GenHospWin("RB_ResScheduleLines",row.RSLRowId);
	/*$("#ReHospital-dialog").dialog("open");
	$.cm({
			ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
			QueryName:"GetHos",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Hosp", {
				editable:false,
				valueField: 'HOSPRowId',
				textField: 'HOSPDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#Hosp").combobox('select','');
				}
			 });
	});
	PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
	LoadReHospitalDataGrid();*/
}
function ReHospitalDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {ReHospitaladdClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {ReHospitaldelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'HospID',hidden:true,title:'HospID'},
		{field:'HospDesc',title:'医院',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReHospitalTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns :Columns,
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["RSLRowId"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"RB_ResScheduleLines",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll");
		PageLogicObj.m_ReHospitalDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("提示","请选择医院","info");
		return false;
		}
	var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["RSLRowId"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"RB_ResScheduleLines",
		BDPMPHDataReference:ID,
		BDPMPHHospital:HospID,
		dataType:"text",
	},function(data){
		if (data=="1"){
			$.messager.alert("提示","增加重复","info");
		}else{
			$.messager.popover({msg: data.split("^")[1],type:'success',timeout: 1000});
			LoadReHospitalDataGrid();
		}
	})
	}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("提示","请选择一行","info");
		return false;
	}
	var row=PageLogicObj.m_ScheduleLinesTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["RSLRowId"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"RB_ResScheduleLines",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
		LoadReHospitalDataGrid();
	})
	
}