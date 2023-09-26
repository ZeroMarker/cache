var PageLogicObj={
	m_tabBLTypeListDataGrid:"",
	m_tabBLContentListDataGrid:"",
	m_tabBLTempListDataGrid:"",
	m_tabBLItemListDataGrid:"",
	m_tabBLArcItemListDataGrid:"",
	ArcItemRowID:"",
	itmmastid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
})
function Init(){
	PageLogicObj.m_tabBLTypeListDataGrid=InitBLTypeListDataGrid();
	PageLogicObj.m_tabBLContentListDataGrid=InitBLContentListDataGrid();
	PageLogicObj.m_tabBLTempListDataGrid=InitBLTempListDataGrid();
	}
function InitEvent(){
	$("#BSaveBLMap").click(BSaveBLMapHandle);
	$("#BSaveBLTempl").click(BSaveBLTemplHandle);
	BLTypeListDataGridLoad();
	BLTempListDataGridLoad();
	}
function BSaveBLMapHandle(){
	var Code=$("#BLType").val()
	if (Code==""){
		 $.messager.alert("提示","代码不能为空!");
		return false;
		}
	var Desc=$("#BLName").val()
	if (Desc==""){
		 $.messager.alert("提示","描述不能为空!");
		return false;
		}
	var JSStr=$("#BLJsContent").val()
	/*var FirstFunction=$("#BLFristFunction").val()
	var ItmmastFunction=$("#BLitmmastFunction").val()*/
	var OpenInitFuc=(eval($("#OpenInitFuc").switchbox("getValue"))==true?"Y":"N")
	var OpenitmmastFuc=(eval($("#OpenitmmastFuc").switchbox("getValue"))==true?"Y":"N")
	var OpenSaveOther=(eval($("#OpenSaveOther").switchbox("getValue"))==true?"Y":"N")
	var LoadSaveOther=(eval($("#LoadSaveOther").switchbox("getValue"))==true?"Y":"N")
	var RowID=""
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((row)&&(row.length!=0)){
		RowID=row.RowID
	}
	var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLType",Code,Desc,JSStr,RowID,OpenInitFuc,OpenitmmastFuc,OpenSaveOther,LoadSaveOther)
	if (rtn=="0"){
		BLTypeListDataGridLoad();
		$("#BLType-dialog").dialog("close");
		}
	
	}
function BSaveBLTemplHandle(){
	var Code=$("#BLTName").val()
	if (Code==""){
		 $.messager.alert("提示","描述不能为空!");
		return false;
		}
	var Desc=$("#Content").val()
	if (Desc==""){
		 $.messager.alert("提示","内容不能为空!");
		return false;
		}
	var IDStr=$("#BLTID").val()
	if (IDStr==""){
		 $.messager.alert("提示","内容不能为空!");
		return false;
		}
	var BLTJsStr=$("#BLTJsContent").val();
	var RowID=""
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((row)&&(row.length!=0)){
		RowID=row.RowID;
	}
	var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLTemple",Code,Desc,RowID,IDStr,BLTJsStr)
	if (rtn=="0"){
		BLTempListDataGridLoad();
		$("#BLTempl-dialog").dialog("close");
		}
	}
function BSaveBLItemHandle(){}
function BFindBLItemHandle(){}
function InitBLTypeListDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddBLTypeClickHandle();}
    },{
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() { UpdateBLTypeClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteBLTypeClickHandle();}
    }];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field: 'BLTypeCode', title: '代码', width: 50},
		{ field: 'BLTypeDesc', title: '描述', width: 200},
		{ field:'BLTypeJSAddress',title:'调用JS地址',width:200,
			formatter:function(value,rec){  
			var btn=""
			if (rec.Rowid!=""){
	           var btn = '<a href="#"  class="editcls"  onclick="JSAddressShow(\'' + rec.BLTypeJSAddress + '\')">'+rec.BLTypeJSAddress+'</a>';
				}
			return btn;
	   		 }
        },
		/*{ field: 'BLFristFunction', title: '初始化方法', width: 250},
		{ field: 'BLItmmastFunction', title: '项目点击调用方法', width: 250},*/
		{ field: 'BLInit', title: '初始化', width: 50},
		{ field: 'BLItemMast', title: '项目点击取消点击', width: 50},
		{ field: 'BLSaveOther', title: '保存其他信息', width: 50},
		{ field: 'BLLoadOther', title: '加载其他信息', width: 50},
		]]
	var tabBLTypeListDataGrid=$('#tabBLTypeList').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		//fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :Columns,
		toolbar :toobar,
		onCheck:function(index, row){
		},
		onSelect:function(index, row){
			BLContentListDataGridLoad(row["RowID"])
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){
			
		}
	});
	return tabBLTypeListDataGrid;	
}
function JSAddressShow(JSContent){
	var ip=window.status.split("服务器IP:")[1]
	 var lnk = "http://"+ip+"/imedical/web/"+JSContent
     window.open(lnk, true, "status=1,scrollbars=1,top=20,left=10,width=1300,height=690");
	}
function AddBLTypeClickHandle(){
	$("#BLType-dialog").dialog("open");
	PageLogicObj.m_tabBLTypeListDataGrid.datagrid('clearSelections');
	$("#BLType").val("")
	$("#BLName").val("")
	$("#BLJsContent").val("")	
	$("#OpenInitFuc").switchbox('setValue',true);
	$("#OpenitmmastFuc").switchbox('setValue',true);
	$("#OpenSaveOther").switchbox('setValue',true);
	$("#LoadSaveOther").switchbox('setValue',true);
	//$("#BLFristFunction").val()
	//$("#BLitmmastFunction").val()
	}
function UpdateBLTypeClickHandle(){
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要修改的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	$("#BLType-dialog").dialog("open");
	$("#BLType").val(row["BLTypeCode"])
	$("#BLName").val(row["BLTypeDesc"])
	var BLContern=row["BLTypeJSAddress"]
	$("#BLJsContent").val(BLContern)
	if (row["BLInit"]=="Y"){
		$("#OpenInitFuc").switchbox('setValue',true);
	}else{
		$("#OpenInitFuc").switchbox('setValue',false);
	}
	if (row["BLItemMast"]=="Y"){
		$("#OpenitmmastFuc").switchbox('setValue',true);
	}else{
		$("#OpenitmmastFuc").switchbox('setValue',false);
	}
	if (row["BLSaveOther"]=="Y"){
		$("#OpenSaveOther").switchbox('setValue',true);
	}else{
		$("#OpenSaveOther").switchbox('setValue',false);
	}
	if (row["BLLoadOther"]=="Y"){
		$("#LoadSaveOther").switchbox('setValue',true);
	}else{
		$("#LoadSaveOther").switchbox('setValue',false);
	}
	/*var BLContern=row["BLFristFunction"]
	$("#BLFristFunction").val(row["BLFristFunction"])
	$("#BLitmmastFunction").val(row["BLItmmastFunction"])*/
		
	}
function DeleteBLTypeClickHandle(){
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"DelectBLType",
		dataType:"text",
		RowID:Rowid
	},function(PatName){
		BLTypeListDataGridLoad()
	});
	}
function BLTypeListDataGridLoad()
{ 
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLType",
		Pagerows:PageLogicObj.m_tabBLTypeListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLTypeListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	
};
function InitBLContentListDataGrid(){
	var toobar=[{
        text: '',
        iconCls: 'icon-up',
        handler: function() { UPBLContentClickHandle();}
    },{
        text: '',
        iconCls: 'icon-down',
        handler: function() { DOWNBLContentClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteBLContentClickHandle();}
    }/*,{
        text: '项目元素维护',
        iconCls: 'icon-report-switch',
        handler: function() { ArcForItemClickHandle();}
    }*/];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field: 'BLContentDesc', title: '描述', width: 50},
		{ field: 'BLContentText', title: '内容', width: 250},
		]]
	var tabBLContentListDataGrid=$('#tabBLContentList').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :Columns,
		toolbar :toobar,
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){
			
		}
	});
	return tabBLContentListDataGrid;
	}
function UPBLContentClickHandle(){
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择的记录!","info");
		return false;
	}
	var TempRowid=row.RowID;
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	var MapRowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"ChangeApptNote",
		dataType:"text",
		MapID:MapRowid,
		TempID:TempRowid,
		ChangeType:"Up"
	},function(PatName){
		BLContentListDataGridLoad(MapRowid)
	});
	}
function DOWNBLContentClickHandle(){
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择的记录!","info");
		return false;
	}
	var TempRowid=row.RowID;
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	var MapRowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"ChangeApptNote",
		dataType:"text",
		MapID:MapRowid,
		TempID:TempRowid,
		ChangeType:"Down"
	},function(PatName){
		BLContentListDataGridLoad(MapRowid)
	});
	}
function DeleteBLContentClickHandle(){
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择的记录!","info");
		return false;
	}
	var TempRowid=row.RowID;
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	var MapRowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"DelectApptNote",
		dataType:"text",
		MapID:MapRowid,
		TempID:TempRowid
	},function(PatName){
		BLContentListDataGridLoad(MapRowid)
	});
	}
function BLContentListDataGridLoad(MapID){
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLContent",
		MapID:MapID,
		Pagerows:PageLogicObj.m_tabBLContentListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLContentListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	}
function InitBLTempListDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddBLTempClickHandle();}
    },{
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() { UpdateBLTempClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteBLTempClickHandle();}
    },{
        text: '增加内容维护',
        iconCls: 'icon-add',
        handler: function() { AddtoMapBLTempClickHandle();}
    },{
        text: '元素维护',
        iconCls: 'icon-set-col',
        handler: function() { AddItemBLTempClickHandle();}
    }
    ];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field: 'BLTempleID', title: 'ID', width: 80},
		{ field: 'BLTempleDesc', title: '描述', width: 80},
		{ field: 'BLTempleJS', title: '引用JS', width: 200,
		formatter:function(value,rec){  
			var btn=""
			if (rec.Rowid!=""){
	           var btn = '<a href="#"  class="editcls"  onclick="JSAddressShow(\'' + rec.BLTempleJS + '\')">'+rec.BLTempleJS+'</a>';
				}
			return btn;
	   		 }
		},
		{ field: 'BLTempleContetn', title: '内容', width: 250},
		]]
	var tabBLTypeListDataGrid=$('#tabBLTempList').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		//fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :Columns,
		toolbar :toobar,
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){
			
		}
	});
	return tabBLTypeListDataGrid;
}
function AddBLTempClickHandle(){
	$("#BLTempl-dialog").dialog("open");
	PageLogicObj.m_tabBLTempListDataGrid.datagrid('clearSelections');
	$("#Content").val("");
	$("#BLTName").val("");
	$("#BLTID").val("");
	$("#BLTJsContent").val("");
	}
function UpdateBLTempClickHandle(){
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要修改的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	$("#BLTempl-dialog").dialog("open");
	$("#BLTName").val(row["BLTempleDesc"])
	$("#BLTID").val(row["BLTempleID"])
	$("#BLTJsContent").val(row["BLTempleJS"]);
	var BLContern=row["BLTempleContetn"]
	var BLContern=BLContern.split("<xmp>")[1]
	var BLContern=BLContern.split("</xmp>")[0]
	$("#Content").val(BLContern)
	}

function DeleteBLTempClickHandle(){
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"DelectBLTemple",
		dataType:"text",
		RowID:Rowid
	},function(PatName){
		BLTempListDataGridLoad()
	});}
function BLTempListDataGridLoad(){
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLTemple",
		Pagerows:PageLogicObj.m_tabBLTempListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLTempListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	}
function AddtoMapBLTempClickHandle(){
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要增加的记录!","info");
		return false;
	}
	TempRowid=row.RowID;
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要增加到申请单的记录!","info");
		return false;
	}
	MapRowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"InsertApptNote",
		dataType:"text",
		MapID:MapRowid,
		TempID:TempRowid
	},function(rtn){
		if (rtn==0) {
			BLContentListDataGridLoad(MapRowid);
		}else if(rtn=="repeat"){
			$.messager.alert("提示","记录重复!","info");
			return false;
		}else{
			$.messager.alert("提示","添加失败!"+rtn,"info");
			return false;
		}
	});
}
function AddItemBLTempClickHandle(){
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要维护的记录!","info");
		return false;
	}
	var BLTempRowID=row.RowID;
	$("#BLItem-dialog").dialog("open");
	$("#BLItemID,#BLItemDesc,#BLItemLength").val("");
	$("#forSave,#ForRequest").checkbox('uncheck');

	/*$("#BLItemID").val()
	$("#BLItemDesc").val()
	$("#ContentJS").val()*/
	PageLogicObj.m_tabBLItemListDataGrid=InitBLItemListDataGrid();
	BLItemDataGridLoad();
	}
function InitBLItemListDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddBLItemClickHandle();}
    },{
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() { UpdateBLItemClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteBLItemClickHandle();}
    },{
        text: '清空',
        iconCls: 'icon-clear',
        handler: function() { ClearBLItemClickHandle();}
    }
    ];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field: 'BLItemID', title: '元素ID', width: 80},
		{ field: 'BLItemDesc', title: '元素描述', width: 80},
		//{ field: 'BLItemJSContent', title: '元素JS表达式', width: 350},
		{ field: 'BLItemAcqiur', title: '是否必填', width: 80},
		{ field: 'BLItemSave', title: '是否保存', width: 80},
		{ field: 'BLItemLength', title: '限制填写长度', width: 80},
		]]
	var tabBLTypeListDataGrid=$('#tabBLItemList').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 50,
		pageList : [50,100],
		columns :Columns,
		toolbar :toobar,
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onSelect:function(index, row){
			$("#BLItemID").val(row["BLItemID"])
			$("#BLItemDesc").val(row["BLItemDesc"])
			var BLContern=row["BLItemJSContent"]
			var BLContern=BLContern.split("<xmp>")[1]
			var BLContern=BLContern.split("</xmp>")[0]
			$("#BLItemContent").val(BLContern)
			if (row["BLItemAcqiur"]=="Y"){
				$HUI.checkbox("#ForRequest").setValue(true);	
			}else{
				$HUI.checkbox("#ForRequest").setValue(false);}
			if (row["BLItemSave"]=="Y"){
				$HUI.checkbox("#forSave").setValue(true);
			}else{
				$HUI.checkbox("#forSave").setValue(false);}
			$("#BLItemLength").val(row["BLItemLength"])
		},
		onBeforeSelect:function(index, row){
			
		}
	});
	return tabBLTypeListDataGrid;
	}
function ClearBLItemClickHandle(){
	$("#BLItemID").val("")
	$("#BLItemDesc").val("")
	$("#BLItemContent").val("")
	$HUI.checkbox("#ForRequest").setValue(false);
	$HUI.checkbox("#forSave").setValue(false);
	$("#BLItemLength").val("");
	}
function BLItemDataGridLoad(){
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要增加的记录!","info");
		return false;
	}
	var BLTempRowID=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLItem",
		BLTempRowID:BLTempRowID,
		Pagerows:PageLogicObj.m_tabBLItemListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	}
function AddBLItemClickHandle(){
	var row=PageLogicObj.m_tabBLTempListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要增加的记录!","info");
		return false;
	}
	var BLTempRowID=row.RowID;
	var Code=$("#BLItemID").val()
	if (Code==""){
		 $.messager.alert("提示","描述不能为空!");
		return false;
		}
	var Desc=$("#BLItemDesc").val()
	if (Desc==""){
		 $.messager.alert("提示","内容不能为空!");
		return false;
	}
	var ForRequestFlag="",forSaveFlag="";
	var ForRequest=$("#ForRequest").prop("checked");
	if(ForRequest)ForRequestFlag="Y"
	var forSave=$("#forSave").prop("checked");
	if(forSave)forSaveFlag="Y"
	var BLItemContent=$("#BLItemContent").val()
	var BLItemLength=$("#BLItemLength").val()
	var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLItem",Code,Desc,BLItemContent,"",ForRequestFlag,forSaveFlag,BLTempRowID,BLItemLength)
	if (rtn=="0"){
		BLItemDataGridLoad();
		}
	}
function UpdateBLItemClickHandle(){
	var row=PageLogicObj.m_tabBLItemListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要保存的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	var Code=$("#BLItemID").val()
	if (Code==""){
		 $.messager.alert("提示","描述不能为空!");
		return false;
		}
	var Desc=$("#BLItemDesc").val()
	if (Desc==""){
		 $.messager.alert("提示","内容不能为空!");
		return false;
	}
	var BLItemContent=$("#BLItemContent").val()
	var ForRequestFlag="",forSaveFlag="";
	var ForRequest=$("#ForRequest").prop("checked");
	if(ForRequest)ForRequestFlag="Y"
	var forSave=$("#forSave").prop("checked");
	if(forSave)forSaveFlag="Y"
	var BLItemLength=$("#BLItemLength").val()
	var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLItem",Code,Desc,BLItemContent,Rowid,ForRequestFlag,forSaveFlag,"",BLItemLength)
	if (rtn=="0"){
		BLItemDataGridLoad();
		}
	}
function DeleteBLItemClickHandle(){
	var row=PageLogicObj.m_tabBLItemListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"DelectBLItem",
		dataType:"text",
		RowID:Rowid
	},function(PatName){
		BLItemDataGridLoad()
	});
}
function ArcForItemClickHandle(){
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	$("#itemArcList").html("")
	LoadCheckItemList();
	$("#BLArcItem-dialog").dialog("open");
	PageLogicObj.m_tabBLArcItemListDataGrid=InitBLArcItemListDataGrid();
	$("#itemArcList").on("click","[name='item']",TesItm_onClick);
	var tempckid="";
	$("#itemArcList").on("click","[name='item']",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("#itemArcList input[type='checkbox'][name="+this.name+"]").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					}
				})	
			}else{
				}
		})
	}
function InitBLArcItemListDataGrid(){
	var toobar=[{ 
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() { UpdateBLArcItemClickHandle();}
    }
    ];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field: 'ArcID', title: '元素ID', width: 50},
		{ field: 'Name', title: '元素描述', width: 50},
		//{ field: 'ShowJSContent', title: 'JS表达式', width: 350},
		{ field: 'Acquir', title: '是否必填', width: 50},
		{ field: 'Save', title: '是否保存', width: 50},
		{ field: 'Hide', title: '是否隐藏', width: 50},
		{ field: 'ArcMapRowID', title: '',hidden:true},
		{ field: 'BLTempleRowID', title: '',hidden:true},
		{ field: 'ArcItemID', title: '',hidden:true},
		]]
	var InitBLArcItemListDataGrid=$('#tabBLArcItemList').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :Columns,
		toolbar :toobar,
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
			PageLogicObj.ArcItemRowID=""
		},
		onSelect:function(index, row){
			$("#BLArcItemID").val(row["ArcID"])
			$("#BLArcItemDesc").val(row["Name"])
			var BLContern=row["ShowJSContent"]
			var BLContern=BLContern.split("<xmp>")[1]
			var BLContern=BLContern.split("</xmp>")[0]
			$("#BLArcItemContent").val(BLContern)
			if (row["Acquir"]=="Y"){
				$HUI.checkbox("#ArcForRequest").setValue(true);	
			}else{
				$HUI.checkbox("#ArcForRequest").setValue(false);}
			if (row["Save"]=="Y"){
				$HUI.checkbox("#ArcforSave").setValue(true);
			}else{
				$HUI.checkbox("#ArcforSave").setValue(false);}
			if (row["Hide"]=="Y"){
				$HUI.checkbox("#ArcForHidden").setValue(true);
			}else{
				$HUI.checkbox("#ArcForHidden").setValue(false);}
			PageLogicObj.ArcItemRowID=row["RowID"]
		},
		onBeforeSelect:function(index, row){
			
		}
	});
	return InitBLArcItemListDataGrid;
}
/// 加载检查方法列表
function LoadCheckItemList(){
	var BLTypeCode=""
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((row)&&(row.length!=0)){
		BLTypeCode=row["BLTypeDesc"]
		
	}
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCodeNew",{"Code":BLTypeCode},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="item" type="checkbox" data-defsensitive="'+ itemArr[j-1].defSensitive +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemArcList").append(htmlstr+itemhtmlstr)
}
function TesItm_onClick(e){
	if ($(this).is(':checked')){
		var TesItemID = e.target.id;    /// 检查方法ID
		var TesItemDesc = $(e.target).parent().next().text(); /// 检查方法
		var itmmastid = TesItemID.replace("_","||");
		InitBLArcItemListDataGridLoad(itmmastid);
		PageLogicObj.itmmastid=itmmastid
	}else{
		InitBLArcItemListDataGridLoad("")
		PageLogicObj.itmmastid=""
		}
}
function InitBLArcItemListDataGridLoad(itmmastid){
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	var BLTempleRowID=row.RowID;
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	var ArcMapRowID=row.RowID;
	$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLArcItem",
		BLTempleRowID:BLTempleRowID,
		ArcMapRowID:ArcMapRowID,
		ArcItemID:itmmastid,
		Pagerows:PageLogicObj.m_tabBLArcItemListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLArcItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	}
function UpdateBLArcItemClickHandle(){
	/*if (PageLogicObj.ArcItemRowID==""){
		$.messager.alert("提示","请选择需要的记录!","info");
		return false;
		}*/
	if (PageLogicObj.itmmastid==""){
		$.messager.alert("提示","请选择需要的医嘱项!","info");
		return false;
		}
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	var BLTempleRowID=row.RowID;
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	var ArcMapRowID=row.RowID;
	var ArcID=$("#BLArcItemID").val()
	var Name=$("#BLArcItemDesc").val()
	var ShowJS=$("#BLArcItemContent").val()
	var SaveFlag="",AcquirFlag="",HideFlag="";
	var Save=$("#ArcforSave").prop("checked");
	if(Save) SaveFlag="Y"
	var Acquir=$("#ArcForRequest").prop("checked");
	if(Acquir)AcquirFlag="Y"
	var Hide=$("#ArcForHidden").prop("checked");
	if(Hide)HideFlag="Y"
	var ArcItemID=PageLogicObj.itmmastid
	var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLArcItem",PageLogicObj.ArcItemRowID,ArcID,Name,ShowJS,AcquirFlag,SaveFlag,HideFlag,BLTempleRowID,ArcMapRowID,ArcItemID)
	if (rtn=="0"){
		InitBLArcItemListDataGridLoad(ArcItemID)
		}
	}
function ClearBLArcItemClickHandle(){
	
	}