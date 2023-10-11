var PageLogicObj={
	m_tabBLTypeListDataGrid:"",
	m_tabBLContentListDataGrid:"",
	m_tabBLTempListDataGrid:"",
	m_tabBLItemListDataGrid:"",
	m_tabBLArcItemListDataGrid:"",
	ArcItemRowID:"",
	itmmastid:"",
	BLTempLastRow:"",
	ChangeBLTemp:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	PageHandle();
})
function Init(){
	PageLogicObj.m_tabBLTypeListDataGrid=InitBLTypeListDataGrid();
	PageLogicObj.m_tabBLContentListDataGrid=InitBLContentListDataGrid();
	InitBLTempListDataGrid();
	InitExportTypeViewDataGrid();
	InitExportViewDataGrid(); //模板导出表格
	InitBLItemXType();
	
	var content="<ul>"
	content=content+"<li>初始化方法:	Init()</li>"
	content=content+"<li>选中项目方法:ItemMastOn(id,Desc,Emg)</li>"
	content=content+"<li>取消选中项目方法:ItemMastOff(itmmast)</li>"
	content=content+"<li>特殊判断必填方法:CheckSaveInfo()</li>"
	content=content+"<li>保存其他数据方法:SaveOtherInfo()</li>"
	content=content+"<li>加载其他数据方法:LoadOtherInfo(JsonStr)</li>"
	content=content+"<li>支持单据(左侧及中间列表内容)导入导出、模板(右侧列表及元素维护内容)导入导出。</li>"
	content=content+"<li>--导入时模板导入需先于单据导入,若单据维护的模板ID(界面上的ID,非后台表ID)对应不存在，则会忽略导入该项内容维护，需手动维护。</li>"
	content=content+"<li>--若不支持中间件导出，也提供了后台txt导出方法，请咨询产品组。</li>"
	content=content+"</ul>"
	$("#helptip").popover({title:'配置说明',content:content,width:400});
}
function InitEvent(){
	$("#BSaveBLMap").click(BSaveBLMapHandle);
	$("#BSaveBLTempl").click(BSaveBLTemplHandle);
	BLTypeListDataGridLoad();
	BLTempListDataGridLoad();
	$("#showviewopen").click(showviewopenHandle);
	$("#Typeviewopen").click(showtypeviewopenHandle);
	$("#Typeviewexport").click(TypeExportHandle);  //模板导出
	$("#Typeviewimport").click(TypeImportHandle);  //模板导入 
	$("#B_GenExportType").click(B_ExportType); //单据导出
	$("#B_GenImportTemp").click(B_ImportTemp); //模板导出
	$("#B_GenExportTemp").click(B_ExportTemp); //模板导出
	$("#viewexport").click(tempexportHandle);  //模板导出
	$("#viewimport").click(tempimportHandle);  //模板导入 
	$("#AddSame").click(function(){
		AddBLTempClickHandle("Same");
	});
	$("#AddNext").click(function(){
		AddBLTempClickHandle("Next");
	});
	$("#AddtoMapBLTemp").click(AddtoMapBLTempClickHandle);
	$("#AddBLTempContent").click(function(){
		var AddBLTempContent=$("#AddBLTempContent").prop("checked");
		if (AddBLTempContent){
			$HUI.checkbox("#AddBLTempType").setValue(false);
			$("#BLTJsContenttd").show()
			$("#Contenttd").show()
		}else{
			
			}
		});
	$("#AddBLTempType").click(function(){
	var AddBLTempContent=$("#AddBLTempType").prop("checked");
	if (AddBLTempContent){
		$HUI.checkbox("#AddBLTempContent").setValue(false);
		$("#BLTJsContenttd").hide()
		$("#Contenttd").hide()
	}else{
		
		}
	});
	
	//模板导出 全选/取消事件
	$("#TempEchkSel").checkbox({
		onCheckChange:function(e,value){
			var data=$('#tabExportTempList').treegrid("getData");
			if(value){
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						$('#tabExportTempList').treegrid('checkNode',data[i].RowID);	
					}
				}
			}else{
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						$('#tabExportTempList').treegrid('uncheckNode',data[i].RowID);	
					}
				}
			}
		}
	})
}
function PageHandle(){
	if(ServerObj.MapType=="CA"){
		$("#west_cPanel").panel({title:"治疗单据模板维护"})	
	}
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
	
	var TempType="",XMLTempName="",ActiveFlag="Y";
	if($("#XMLTempName").length>0){
		XMLTempName=$("#XMLTempName").val();
	}
	var checkedRadioJObj = $("input[name='TempType']:checked");
	if(checkedRadioJObj.length>0){
		TempType=checkedRadioJObj.val();
	}
	if(TempType==""){
		TempType=ServerObj.MapType;	
	}
	if($("#ActiveFlag").length>0){
		ActiveFlag=(eval($("#ActiveFlag").switchbox("getValue"))==true?"Y":"N")
	}
	var RowID=""
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((row)&&(row.length!=0)){
		RowID=row.RowID
	}
	var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLType",Code,Desc,JSStr,RowID,OpenInitFuc,OpenitmmastFuc,OpenSaveOther,LoadSaveOther,TempType,XMLTempName,ActiveFlag)
	if (rtn=="0"){
		BLTypeListDataGridLoad();
		$("#BLType-dialog").dialog("close");
	}else{
		$.messager.alert("提示","保存失败,错误代码:"+rtn);
		return false;	
	}
	
}
function BSaveBLTemplHandle(){
	var Code=$("#BLTName").val()
	if (Code==""){
		 $.messager.alert("提示","描述不能为空!");
		return false;
	}
	var AddBLTempContent=$("#AddBLTempContent").prop("checked");
	var Desc=""
	var BLTJsStr=""
	if (AddBLTempContent){
		var Desc=$("#Content").val()
		var BLTJsStr=$("#BLTJsContent").val();
		if (Desc==""){
			 $.messager.alert("提示","内容不能为空!");
			return false;
		}
	}
	var AddBLTempType=$("#AddBLTempType").prop("checked");
	if ((!AddBLTempContent)&&(!AddBLTempType)){
		 $.messager.alert("提示","请选择一个分类");
			return false;
		}
	var IDStr=$("#BLTID").val()
	if (IDStr==""){
		 $.messager.alert("提示","ID不能为空!");
		return false;
	}
	//var BLTJsStr=$("#BLTJsContent").val();
	var RowID=PageLogicObj.ChangeBLTemp
	/*var row=$('#tabBLTempList').treegrid('getSelected');
	if ((row)&&(row.length!=0)){
		RowID=row.RowID;
	}*/
	//var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLTemple",Code,Desc,RowID,IDStr,BLTJsStr,ServerObj.MapType,PageLogicObj.BLTempLastRow)
	var rtn=$.cm({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"InsertBLTemple",
		Desc:Code,
		Content:Desc,
		RowID:RowID,
		ID:IDStr,
		JSStr:BLTJsStr,
		MapType:ServerObj.MapType,
		LastID:PageLogicObj.BLTempLastRow,
		dataType:"text",
		_headers:{'X-Accept-Tag':1}
	},false)
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
        iconCls: 'icon-cancel',
        handler: function() { DeleteBLTypeClickHandle();}
    },{
		text:"",
		id:"TypeMoreMulit"
	}];
	var HiddenFlag=false
	if (ServerObj.MapType==""){HiddenFlag=true}
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
		{ field: 'BLItemMast', title: '医嘱勾选/取消勾选功能', width: 50},
		{ field: 'BLSaveOther', title: '保存其他信息', width: 50},
		{ field: 'BLLoadOther', title: '加载其他信息', width: 50},
		{ field: 'BLXMLTempName', title: 'XML模板名称', width: 50,hidden:HiddenFlag},
		{ field: 'BLMapType', title: '模板类型', width: 50,hidden:true},
		{ field: 'BLActiveFlag', title: '激活', width: 50,hidden:true}
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
		url:$URL+"?ClassName=web.DHCDocAPPBL&QueryName=FindBLType&MapType="+ServerObj.MapType+"&FindType=All"+"&rows=99999",
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
		onBeforeLoad:function(param){
			var MapType=getMapType();
			$.extend(param,{MapType:MapType});
		},
		rowStyler:function(rowIndex, rowData){
 			if (rowData.BLActiveFlag!="Y"){
	 			return 'color:#788080;';
	 		}
		},
		onLoadSuccess:function(){
			$('#MoreType_toolbar').appendTo('#TypeMoreMulit');
			$('#TypeMoreMulit').find("span").eq(0).css("display","none"); 	
		}
	});
	return tabBLTypeListDataGrid;	
}
function JSAddressShow(JSContent){
	var ip=window.status.split("服务器IP:")[1]
	 var lnk = "https://"+ip+":1443/imedical/web/"+JSContent
	 if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
     window.open(lnk, true, "status=1,scrollbars=1,top=20,left=10,width=1300,height=690");
	}
function AddBLTypeClickHandle(){
	$("#BLType-dialog").dialog("open");
	PageLogicObj.m_tabBLTypeListDataGrid.datagrid('clearSelections');
	$("#BLType").val("")
	$("#BLName").val("")
	$("#BLJsContent").val("")	
	$("#XMLTempName").val("")
	$("#OpenInitFuc").switchbox('setValue',true);
	$("#OpenitmmastFuc").switchbox('setValue',true);
	$("#OpenSaveOther").switchbox('setValue',true);
	$("#LoadSaveOther").switchbox('setValue',true);
	$("#ActiveFlag").switchbox('setValue',true);
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
	$("#ActiveFlag").switchbox('setValue',row["BLActiveFlag"]=="Y");
	$("#XMLTempName").val(row["BLXMLTempName"])
	
	var BLMapType=row["BLMapType"];
	$HUI.radio("input[value='"+BLMapType+"']").setValue(true);
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
	},function(r){
		if(r=="-1"){
			$.messager.alert("提示","该模板在治疗项目设置已被关联使用,无法删除.","warning");
		}if(r=="-2"){
			$.messager.alert("提示","该模板在治疗服务组设置已被关联使用,无法删除.","warning");
		}else{
			BLTypeListDataGridLoad();
		}
		PageLogicObj.m_tabBLContentListDataGrid.datagrid('unselectAll').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',{"total":0,"rows":[]});
	});
}
function BLTypeListDataGridLoad()
{ 
	PageLogicObj.m_tabBLTypeListDataGrid.datagrid('unselectAll').datagrid('reload')
	/*$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLType",
		MapType:ServerObj.MapType,
		Pagerows:PageLogicObj.m_tabBLTypeListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLTypeListDataGrid.datagrid('unselectAll').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	*/
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
        iconCls: 'icon-cancel',
        handler: function() { DeleteBLContentClickHandle();}
    }/*,{
        text: '项目元素维护',
        iconCls: 'icon-report-switch',
        handler: function() { ArcForItemClickHandle();}
    }*/];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field: 'BLContentDesc', title: '描述', width: 190},
		{ field: 'BLContentText', title: '内容', width: 170}
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
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return tabBLContentListDataGrid;
}
function UPBLContentClickHandle(){
	var row=PageLogicObj.m_tabBLContentListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要上移的记录!","info");
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
		$.messager.alert("提示","请选择需要下移的记录!","info");
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
		$.messager.alert("提示","请选择需要删除的记录!","info");
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
		BLContentListDataGridLoad(MapRowid);
		PageLogicObj.m_tabBLContentListDataGrid.datagrid('unselectAll');
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
		text:"",
		id:"AddMulit"
	}/*,{
        text: '新增同级',
        iconCls: 'icon-add',
        handler: function() { AddBLTempClickHandle("Same");}
    },{
        text: '新增子级',
        iconCls: 'icon-add',
        handler: function() { AddBLTempClickHandle("Next");}
    }*/,{
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() { UpdateBLTempClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() { DeleteBLTempClickHandle();}
    }/*,{
        text: '增加内容维护',
        iconCls: 'icon-add',
        handler: function() { AddtoMapBLTempClickHandle();}
    }*/,{
        text: '元素维护',
        iconCls: 'icon-set-col',
        handler: function() { AddItemBLTempClickHandle();}
    },{
		text:"",
		id:"MoreMulit"
	}];
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field:'FatherRowID',title:'',hidden:true},
		{ field: 'BLTempleDesc', title: '描述', width: 180},
		{ field: 'BLTempleID', title: 'ID', width: 80},
		{ field: 'BLTempleJS', title: '引用JS', width: 400,
		formatter:function(value,rec){  
			var btn=""
			if (rec.Rowid!=""){
	           var btn = '<a href="#"  class="editcls"  onclick="JSAddressShow(\'' + rec.BLTempleJS + '\')">'+rec.BLTempleJS+'</a>';
				}
			return btn;
	   		 }
		},
		{ field: 'BLTempleContetn', title: '内容', width: 250,hidden:true}
	]]
	/*var tabBLTypeListDataGrid=$('#tabBLTempList').datagrid({  
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
			
		},
		onLoadSuccess:function(data){
			$('#MoreMulit_toolbar').appendTo('#MoreMulit');
			$('#MoreMulit').find("span").eq(0).css("display","none"); 
			}
	});*/
	 var tabBLTypeListDataGrid=$HUI.treegrid('#tabBLTempList',{
	    idField:'RowID',
	    treeField:'BLTempleDesc',
	    headerCls:'panel-header-gray',
	    fit : true,
	    border: false,   
	    columns:Columns,
	    toolbar:toobar,
		onDblClickRow:function(index){
			
		},
		onLoadSuccess:function(data){
			$('#AddMulit_toolbar').appendTo('#AddMulit');
			$('#MoreMulit_toolbar').appendTo('#MoreMulit');
			$('#MoreMulit').find("span").eq(0).css("display","none"); 
			$('#AddMulit').find("span").eq(0).css("display","none"); 
		}
	});
	return tabBLTypeListDataGrid;
}
function AddBLTempClickHandle(Type){
	var row=$('#tabBLTempList').treegrid('getSelected');
	if (((!row)||(row.length==0))&&(Type=="Next")){
		$.messager.alert("提示","请选择需要增加的下级记录！","info");
		return false;
	}
	if (((!row)||(row.length==0))&&(Type=="Same")){
		PageLogicObj.BLTempLastRow=0
	}else{
		if (Type=="Same"){
			PageLogicObj.BLTempLastRow=row.FatherRowID
		}else{
			PageLogicObj.BLTempLastRow=row.RowID
		}
	}
	$("#BLTempl-dialog").dialog("open");
	//PageLogicObj.m_tabBLTempListDataGrid.datagrid('clearSelections');
	$("#Content").val("");
	$("#BLTName").val("");
	$("#BLTID").val("");
	$("#BLTJsContent").val("");
	PageLogicObj.ChangeBLTemp="";
	$HUI.checkbox("#AddBLTempContent").setValue(true);
	$HUI.checkbox("#AddBLTempType").setValue(false);
	$("#BLTJsContenttd").show()
	$("#Contenttd").show()
}
function UpdateBLTempClickHandle(){
	var row=$('#tabBLTempList').treegrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要修改的记录!","info");
		return false;
	}
	Rowid=row.RowID;
	PageLogicObj.ChangeBLTemp=Rowid
	$("#BLTempl-dialog").dialog("open");
	$("#BLTName").val(row["BLTempleDesc"])
	$("#BLTID").val(row["BLTempleID"])
	$("#BLTJsContent").val(row["BLTempleJS"]);
	var BLContern=row["BLTempleContetn"]
	var BLContern=BLContern.split("<xmp>")[1]
	var BLContern=BLContern.split("</xmp>")[0]
	$("#Content").val(BLContern)
	if (BLContern!=""){
		$HUI.checkbox("#AddBLTempContent").setValue(true);
		$HUI.checkbox("#AddBLTempType").setValue(false);
		$("#BLTJsContenttd").show()
		$("#Contenttd").show()
		}else{
		$HUI.checkbox("#AddBLTempType").setValue(true);	
		$HUI.checkbox("#AddBLTempContent").setValue(false);
		$("#BLTJsContenttd").hide()
		$("#Contenttd").hide()
			}
}

function DeleteBLTempClickHandle(){
	var row=$('#tabBLTempList').treegrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	var conf=dhcsys_confirm("确定删除?")
	if(!conf)return false;
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
	/*$.cm({
		ClassName:"web.DHCDocAPPBL",
		QueryName:"FindBLTemple",
		MapType:ServerObj.MapType,
		rows:99999
	},function(GridData){
		PageLogicObj.m_tabBLTempListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})*/
	$.cm({
	    ClassName:"web.DHCDocAPPBL",
	    MethodName:"FindBLTempeJson",
	    MapType:ServerObj.MapType,
	},function(GridData){
		$("#tabBLTempList").treegrid('unselectAll').treegrid('loadData',GridData);
	})
	}
function AddtoMapBLTempClickHandle(){
	var row=$('#tabBLTempList').treegrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要增加的记录!","info");
		return false;
	}
	TempRowid=row.RowID;
	if ((row["BLTempleJS"]=="")&&(row["BLTempleContetn"]=="<xmp></xmp>")){
		$.messager.alert("提示","请选择需要增加的模板内容记录!","info");
		return false;
		}
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
	var row=$('#tabBLTempList').treegrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要维护的记录!","info");
		return false;
	}
	var BLTempRowID=row.RowID;
	$("#BLItem-dialog").dialog("open");
	$("#BLItemID,#BLItemDesc,#BLItemLength,#BLItemXID").val("");
	$("#forSave,#ForRequest,#forXPrintName").checkbox('uncheck');
	$("#BLItemXType").combobox('setValue', "");

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
        iconCls: 'icon-cancel',
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
		{ field: 'BLItemSave', title: '是否保存', width: 50},
		{ field: 'BLItemAcqiur', title: '是否必填', width: 50},
		{ field: 'BLItemXPrintName', title: '是否打印时不打印元素描述', width: 110},
		{ field: 'BLItemLength', title: '限制填写长度', width: 80},
		{ field: 'BLItemXType', title: '控件类型', width: 80},
		{ field: 'BLItemXID', title: '控件类ID型', width: 80}
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
				$HUI.checkbox("#forSave").setValue(false);
			}
			if (row["BLItemXPrintName"]=="Y"){
				$HUI.checkbox("#forXPrintName").setValue(true);
			}else{
				$HUI.checkbox("#forXPrintName").setValue(false);
			}
			$("#BLItemLength").val(row["BLItemLength"])
			$("#BLItemXType").combobox('setValue', row["BLItemXType"]);
            		$("#BLItemXID").val(row["BLItemXID"])
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
	$HUI.checkbox("#forXPrintName").setValue(false);
	$("#BLItemXType").combobox('setValue', "");
    	$("#BLItemLength,#BLItemXID").val("");
}
function BLItemDataGridLoad(){
	var row=$('#tabBLTempList').treegrid('getSelected');
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
	var row=$('#tabBLTempList').treegrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要增加的记录!","info");
		return false;
	}
	var BLTempRowID=row.RowID;
	var Code=$("#BLItemID").val()
	if (Code==""){
		 $.messager.alert("提示","元素ID不能为空!");
		return false;
	}
	var Desc=$("#BLItemDesc").val()
	if (Desc==""){
		 $.messager.alert("提示","元素描述不能为空!");
		return false;
	}
	var ForRequestFlag="",forSaveFlag="",forXPrintName="";
	var ForRequest=$("#ForRequest").prop("checked");
	if(ForRequest)ForRequestFlag="Y"
	var forSave=$("#forSave").prop("checked");
	if(forSave)forSaveFlag="Y"
	var forXPrintName=$("#forXPrintName").prop("checked");
	if(forXPrintName)forXPrintNameFlag="Y";
	var BLItemContent=$("#BLItemContent").val()
	var BLItemLength=$("#BLItemLength").val()
	var BLItemXType = $("#BLItemXType").combobox('getValue');
    var BLItemXID = $("#BLItemXID").val()
    var BLItemExpt = BLItemXType + "^" + BLItemXID + "^" + forXPrintNameFlag;
	//var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLItem",Code,Desc,BLItemContent,"",ForRequestFlag,forSaveFlag,BLTempRowID,BLItemLength,BLItemExpt)
	var rtn=$.m({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"InsertBLItem",
		IDDesc:Code,Desc:Desc,Content:BLItemContent,
		RowID:"",Acquir:ForRequestFlag,Save:forSaveFlag,
		BLTempRowID:BLTempRowID,
		BLItemLength:BLItemLength,
		BLItemExpt:BLItemExpt
	},false)
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
		 $.messager.alert("提示","元素ID不能为空!");
		 return false;
	}
	var Desc=$("#BLItemDesc").val()
	if (Desc==""){
		$.messager.alert("提示","元素描述不能为空!");
		return false;
	}
	var BLItemContent=$("#BLItemContent").val()
	var ForRequestFlag="",forSaveFlag="",forXPrintNameFlag="";
	var ForRequest=$("#ForRequest").prop("checked");
	if(ForRequest)ForRequestFlag="Y";
	var forSave=$("#forSave").prop("checked");
	if(forSave)forSaveFlag="Y";
	var forXPrintName=$("#forXPrintName").prop("checked");
	if(forXPrintName)forXPrintNameFlag="Y";
	var BLItemLength=$("#BLItemLength").val()
	var BLItemXType = $("#BLItemXType").combobox('getValue');
    var BLItemXID = $("#BLItemXID").val()
    var BLItemExpt = BLItemXType + "^" + BLItemXID + "^" +forXPrintNameFlag;
	//var rtn=tkMakeServerCall("web.DHCDocAPPBL","InsertBLItem",Code,Desc,BLItemContent,Rowid,ForRequestFlag,forSaveFlag,"",BLItemLength,BLItemExpt)
	var rtn=$.m({
		ClassName:"web.DHCDocAPPBL",
		MethodName:"InsertBLItem",
		IDDesc:Code,Desc:Desc,Content:BLItemContent,
		RowID:Rowid,Acquir:ForRequestFlag,Save:forSaveFlag,
		BLTempRowID:"",
		BLItemLength:BLItemLength,
		BLItemExpt:BLItemExpt
	},false)
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
		{ field: 'ArcItemID', title: '',hidden:true}
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
function showviewopenHandle(){
	var row=$('#tabBLTempList').treegrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要展示的记录!","info");
		return false;
	}
	var BLTempRowID=row.RowID;
	var src="docapp.blmap.showview.hui.csp?BLTempRowID="+BLTempRowID;
	websys_showModal({
		url:src,
		title:row.BLTempleDesc+' 可视化窗口',
		width:1000,height:700
	})
	//var $code ="<iframe width='100%' height='100%' scrolling='0' frameborder='0' src='"+src+"'></iframe>" ;
	//createModalDialog("ShowView","可视化窗口", 1000, 700,"icon-w-edit","",$code,"");
}
function showtypeviewopenHandle(){
	var row=PageLogicObj.m_tabBLTypeListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要展示的记录!","info");
		return false;
	}
	var BLTypeRowID=row.RowID;
	var src="docapp.blmap.typeshowview.hui.csp?MapID="+BLTypeRowID;
	websys_showModal({
		url:src,
		title:row.BLTypeDesc+' 可视化窗口',
		width:1000,height:700
	})
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
//模板导出 start---
function InitExportViewDataGrid(){
	var Columns=[[
		{ field:'RowID',title:'',hidden:true},
		{ field:'FatherRowID',title:'',hidden:true},
		{ field: 'BLTempleDesc', title: '描述', width: 300},
		{ field: 'BLTempleID', title: 'ID', width: 150},
		{ field: 'BLTempleJS', title: '引用JS',hidden:true}
	]]
	var tabExportTempListDataGrid=$HUI.treegrid('#tabExportTempList',{
	    idField:'RowID',
	    treeField:'BLTempleDesc',
	    headerCls:'panel-header-gray',
	    fit : true,
	    checkbox:true,
	    border: false,   
	    columns:Columns
	})
	return tabExportTempListDataGrid;
}

function tempexportHandle(){
	var dhhei=$(document.body).height()-100;
	$('#Export-dialog').dialog('open').dialog('resize',{
		width:550,
		height:dhhei,
		top: 50,
		left:($(document.body).width()-550)/2
	});
	$("#TempEchkSel").checkbox("uncheck")
	$.cm({
	    ClassName:"web.DHCDocAPPBLExport",
	    MethodName:"FindBLTempeJson",
	    MapType:ServerObj.MapType,
	},function(GridData){
		$("#tabExportTempList").treegrid('unselectAll').treegrid('loadData',GridData);
		
		var data=$('#tabExportTempList').treegrid("getData");
		if(data.length>0){
			for(var i=0;i<data.length;i++){
				$('#tabExportTempList').treegrid('uncheckNode',data[i].RowID);	
			}
		}
	})
}

function B_ExportTemp(){
	var ExportIDArr=[];
	var CheckedNodes =$('#tabExportTempList').treegrid('getCheckedNodes','checked');
	if(CheckedNodes.length>0){
		for(var i=0;i<CheckedNodes.length;i++){
			var rowData=CheckedNodes[i];
			if(rowData._parentId==""){
				continue;
			} 
			ExportIDArr.push(rowData.RowID);
		}
		
	}
	if(ExportIDArr.length==0){
		$.messager.alert("提示","请选择要导出的模板","warning");
		return;
	}
	/*$cm({
		ClassName:"web.DHCDocAPPBLExport",
		MethodName:"TempToExport",
		filename:FilePath,
		ExportID:ExportIDArr.join("^"),
		dataType:"text"
	},function(ret){
		$.messager.popover({msg:ret,type:"info",timeout:3000});	
	});
	return true;*/
	$cm({
		ResultSetType:'ExcelPlugin',
		ExcelName:"DHCDocTempToExcel",
		ClassName:"web.DHCDocAPPBLExport",
		QueryName:"QryTempToExcel",
		ExportID:ExportIDArr.join("^"),
		HospID:""
	});
	return;
}
//模板导入
function tempimportHandle(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=web.DHCDocAPPBLExport&mMethodName=ImportTotalExcel&SplitCount=1&NotShowDetail=Y";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='96%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("importDiag","导入", 600, 240,"icon-w-import","",$code,"");
	return
	var dhhei=200;
	$("#ImportFilePath").val("");
	$('#Import-dialog').dialog('open').dialog('resize',{
		width:500,
		height:dhhei,
		left:($(document.body).width()-500)/2
	});
}
function B_ImportTemp(){
	var FilePath=$("#ImportFilePath").val();
	if(FilePath==""){
		$.messager.alert("提示","请填写需导出到路径，并确认路径格式。","warning");
		return;
	}
	
	$cm({
		ClassName:"web.DHCDocAPPBLExport",
		MethodName:"ImportTempByTxt",
		FilePath:FilePath,
		dataType:"text"
	},function(ret){
		//$.messager.popover({msg:ret,type:"info",timeout:3000});	
		$.messager.alert("提示",ret,"info");	
	});
	return true;
}

function InitExportTypeViewDataGrid(){
	var Columns=[[
		{ field:'RowCheck',checkbox:true},     
		{ field:'RowID',title:'',hidden:true},
		{ field: 'BLTypeCode', title: '代码', width: 150},
		{ field: 'BLTypeDesc', title: '描述', width: 300},
	]]
	var tabExportTypeListDataGrid=$HUI.datagrid('#tabExportTypeList',{
	    idField:'RowID',
	    headerCls:'panel-header-gray',
	    fit : true,
	    border: false,   
	    columns:Columns
	})
	return tabExportTypeListDataGrid;
}
function TypeExportHandle(){
	var dhhei=$(document.body).height()-100;
	$('#TypeExport-dialog').dialog('open').dialog('resize',{
		width:550,
		height:dhhei,
		top: 50,
		left:($(document.body).width()-550)/2
	});
	var MapType=getMapType();
	$.cm({
	    ClassName:"web.DHCDocAPPBL",
	    QueryName:"FindBLType",
	    MapType:MapType,
	    Pagerows:$('#tabExportTempList').datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		$("#tabExportTypeList").datagrid('clearChecked').datagrid('unselectAll').datagrid('loadData',GridData);
	})
}

function B_ExportType(){
	var ExportIDArr=[];
	var rows = $("#tabExportTypeList").datagrid("getSelections");
	if(rows.length>0){
		for(var i=0;i<rows.length;i++){
			ExportIDArr.push(rows[i].RowID);
		}	
	}
	if(ExportIDArr.length==0){
		$.messager.alert("提示","请选择要导出的单据","warning");
		return;
	}
	var MapType=getMapType();
	$cm({
		ResultSetType:'ExcelPlugin',
		ExcelName:"DHCDocAppTypeToExcel",
		ClassName:"web.DHCDocAPPBLExport",
		QueryName:"QryTypeToExcel",
		ExportID:ExportIDArr.join("^"),
		MapType:MapType
	});
	return;
}
//模板导入
function TypeImportHandle(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=web.DHCDocAPPBLExport&mMethodName=ImportTypeExcel&SplitCount=5&NotShowDetail=N";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='96%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("importDiag","导入", 800, 550,"icon-w-import","",$code,"");
}

function getMapType(){
	var MapType=ServerObj.MapType;
	if(ServerObj.MapType=="CA"){
		MapType=MapType+"^CR"	
	}
	return MapType;	
}

function InitBLItemXType() {
    $HUI.combobox("#BLItemXType", {
        data: [{ "id": "datagrid", "text": "datagrid" }, { "id": "checkbox", "text": "checkbox" }],
        valueField: 'id',
        textField: 'text',
        editable: true
    });
}
