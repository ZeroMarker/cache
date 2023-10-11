var TabResourceDataGrid;
var PageLogicObj={
	m_ComboJsonCSP:'./dhcdoc.cure.query.combo.easyui.csp',
}
function InitHospList()
{
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Zone_Search").combobox('select',"");
		LoadDocMarkComb();
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
$(function(){
	InitHospList();
	//Init();
	InitEvent();
	document.onkeydown = Doc_OnKeyDown;
});
function Init(){
	InitCombo();
	//InitTabArea();
	//InitTabWeek();
	InitTabResource();
	//LoadArea();
	//LoadWeek();	
}
function InitEvent(){
	$("#BFind").click(function(){
		TabResourceDataGrid.datagrid("reload");
	});
	$("#Update").click(UpdateClickHandler);
}
function Doc_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
   if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
}
function InitCombo(){
	InitSingleCombo('ScheduleLines_Search','RSLRowId','Desc','DHCDoc.DHCDocConfig.ScheduleTemp','RBScheduleLinesList');
	//InitSingleCombo('Zone_Search','RowId','Desc','web.DHCAlloc','LookUpExaBorough');
	InitSingleCombo('Zone_Search','rowid','desc','DHCDoc.DHCDocConfig.ScheduleTemp','QueryZoneList');
	InitSingleCombo('Week_Search','RowId','Desc','web.DHCAlloc','FindWeek');
}
function InitSingleCombo(id,valueField,textField,ClassName,Query){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var ComboObj={
		panelHeight:200,
		multiple:false,
		mode:"local",
		method: "GET",
		//selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	//url:PageLogicObj.m_ComboJsonCSP+'?ClassName='+ClassName+'&QueryName='+Query,
	  	url:$URL+'?ClassName='+ClassName+'&QueryName='+Query+'&HospId='+HospID+'&ResultSetType=array',
	  	filter: function(q, row){
			var opts = $(this).combobox('options');
			return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row['code'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	};
	if(id=="Zone_Search"){
		$.extend(ComboObj,{
			onSelect:function(record){
				TabResourceDataGrid.datagrid("reload");
				LoadDocMarkComb()
			}
		});
	}else if(id=="ScheduleLines_Search"){
		$.extend(ComboObj,{
			editable:false,
			onSelect:function(record){
				TabResourceDataGrid.datagrid("reload");
			}
		});
	}else if(id=="Week_Search"){
		$.extend(ComboObj,{
			onSelect:function(record){
				TabResourceDataGrid.datagrid("reload");
			}
		});
	}
	$("#"+id).combobox(ComboObj);
}
function LoadDocMarkComb() {
	var ExaBorough=$("#Zone_Search").combobox('getValue');
	$.q({
		ClassName:"web.DHCAlloc",
		QueryName:"FindDocMark",
		ExaBorough:ExaBorough,
		dataType:"json",
		rows:99999
	},function(Data) {
		$("#DocMark").combobox({
			valueField:'MarkId',
			textField:'MarkDesc',
			data:Data["rows"],
			filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			},
			onSelect:function(){
				TabResourceDataGrid.datagrid("reload");
			}
		})
	})
}
/*function InitTabArea(){
	var AreaColumns=[[ 
		{field:'Desc',title:'诊区',width:400},
		{field:'RowId',hidden:true},
	]]
	TabAreaDataGrid=$("#tabArea").datagrid({
		fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : false,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'RowId',
		columns :AreaColumns,
		onClickRow:function(rowIndex, rowData){
			TabResourceDataGrid.datagrid("reload");
		}
	});
}
function LoadArea(){
	$.q({
	    ClassName : "web.DHCAlloc",
	    QueryName : "LookUpExaBorough",
	    desc:"",
	    Pagerows:$("#tabArea").datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#tabArea").datagrid('loadData',GridData);
	})
}
function InitTabWeek(){
	var WeekColumns=[[ 
		{field:'Desc',title:'周',width:400},
		{field:'RowId',hidden:true},
	]]
	TabWeekDataGrid=$("#tabWeek").datagrid({
		fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : false,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'RowId',
		columns :WeekColumns,
		onClickRow:function(rowIndex, rowData){
			TabResourceDataGrid.datagrid("reload");
		}
	});
}
function LoadWeek(){
	$.q({
	    ClassName : "web.DHCAlloc",
	    QueryName : "FindWeek",
	    desc:"",
	    Pagerows:$("#tabWeek").datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#tabWeek").datagrid('loadData',GridData);
	})
}*/
function InitTabResource(){
	var TabResourceToolBar=[{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
            var rows = TabResourceDataGrid.datagrid("getChecked");
            if (rows.length > 0) {
                $.messager.confirm("提示", "你确定要删除吗?",
                	function(r) {
                        if (r) {
	                        $.messager.confirm('确认对话框', '是否一并删除相应的未有挂号及预约记录排班？', function(r){
								if (r){
								    del(rows,"Y");
								}else{
									del(rows,"N");
								}
							});
                        }
                });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "error");
            }
        }
	},{
		text: '修改挂号职称',
        iconCls: 'icon-edit',
        handler: function() {	            
            UpdateResource()
        }
	}]
	///RowId:%String,LocDesc:%String,DocDesc:%String,TRDesc
	var TabResColumns=[[ 
		{field:'RowId',checkbox:true},
		{field:'LocDesc',title:"科室",width:300},
		{field:'DocDesc',title:"号别",width:200},
		{field:'SessionType',title:"职称",width:200},
		{field:'TRDesc',title:"时段",width:200},
		{field:'DOWDayDesc',title:"星期",width:200}
		/*{field:'LocDesc',title:"科室",styler: function(value,row,index){
				return 'min-width:400px;';
		}},
		{field:'DocDesc',title:"号别",minwidth:400,styler: function(value,row,index){
				return 'min-width:400px;';
		}},
		{field:'TRDesc',title:"时段",minwidth:400,styler: function(value,row,index){
				return 'min-width:400px;';
		}}*/
	]]
	TabResourceDataGrid=$("#tabResource").datagrid({
		fit : true,
		width:'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		url :'./dhcdoc.config.query.grid.easyui.csp',
		loadMsg : '加载中..',  
		pagination : false,  //
		rownumbers : true,  //
		columns :TabResColumns,
		toolbar :TabResourceToolBar,
		onBeforeLoad:function(queryParams){
			var ExaBorough=$("#Zone_Search").combobox('getValue');
			var ScheduleLinesId=$("#ScheduleLines_Search").combobox('getValue');
			var WeekDay=$("#Week_Search").combobox('getValue');
			var DocMark=$("#DocMark").combobox("getValue");
			queryParams.ClassName ='web.DHCAlloc';
			queryParams.QueryName ='FindWeekResource';
			queryParams.Arg1 = WeekDay;
			queryParams.Arg2 = ExaBorough;
			queryParams.Arg3 = ScheduleLinesId
			queryParams.Arg4 = DocMark
			queryParams.Arg5 = $HUI.combogrid('#_HospUserList').getValue()
			queryParams.ArgCnt =5;
		}
	});
}
function UpdateResource() {
	var rows = TabResourceDataGrid.datagrid("getChecked");
    if (rows.length <= 0) {
        $.messager.alert("提示", "请选择要修改挂号职称的行", "error");
        return false
    } 
    $.q({
        ClassName:"web.DHCDocSessContrast",
        QueryName:"QuerySessList",
        Desc:"",
        HospID:$HUI.combogrid('#_HospUserList').getValue(),
        dataType:"json",
        rows:999
    },function(Data) {
        $("#SessionType").combobox({
            valueField:'SessRowid',
			textField:'SessDesc',
			editable:true,
			data:Data["rows"],
			filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			},
        })
        $("#UpdateWin").window("open")
    })
}
function UpdateClickHandler(){
	var UpdateSessionType=$("#SessionType").combobox("getValue")
	if (UpdateSessionType=="") {
		$.messager.alert("提示","请选择职称！")
		return false;
	}
	var rows = TabResourceDataGrid.datagrid("getChecked");
    if (rows.length <= 0) {
        $.messager.alert("提示", "请选择要删除的行", "error");
        return false
    } 
    var UpdateRet=0
	$.each(rows, function (index, row){
        var rowid=row['RowId']
        $.cm({
			ClassName:"web.DHCAlloc",
			MethodName:"UpdateRBResSession",
			SessId:rowid,
			SessionType:UpdateSessionType,
			dataType:"text"
		},function (ret) {
			if (ret=="0"){
			}else{
				UpdateRet=ret
				$.messager.alert('提示',"修改失败:"+ret);
				return false;
			}
		})
    })
    $("#UpdateWin").window("close")
    TabResourceDataGrid.datagrid('unselectAll').datagrid('reload');
    if (UpdateRet==0) $.messager.popover({msg:'修改成功!',type:'alert'});
}
function del(rows,DelScheduleFlag){
	var ids = [];
    for (var i = 0; i < rows.length; i++) {
        var value=$.cm({
		    ClassName : "web.DHCRBResSession",
		    MethodName : "Delete",
		    Rowid:rows[i].RowId, DelSchedule:DelScheduleFlag,
		    dataType:"text"
		},false)
		if (value=="0"){
			
		}else{
			$.messager.alert('提示',"删除失败:"+value);
			return false;
		}
    }
    TabResourceDataGrid.datagrid('unselectAll').datagrid('load');
    $.messager.popover({msg:'删除成功!',type:'alert'});
}