
var PageLogicObj={
	m_threechecklistDataGrid:"",
	D_ThreeDocID:""
};
$(function(){
	//页面元素初始化
	//PageHandle();
	//页面数据初始化
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	 PageLogicObj.m_threechecklistDataGrid=threechecklistDataDataGrid();
	 var cbox = $HUI.combobox("#DocTypeCode", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data: [{"id":"MaterD","text":$g("主(副)任医师"),"selected":"true"},{"id":"UpD","text":$g("上级医师")}],
			onSelect: function (rec) {
			}
	   });
	 //alert($URL)
	 var cbox = $HUI.combobox("#Doclist", {
		url:$URL+"?ClassName=web.DHCDocThreeCheckListAdm&QueryName=IPDocList&LocId="+ServerObj.LocID+"&ResultSetType=array",
		valueField:'RowId',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onSelect: function (record) {
			
		},
		onLoadSuccess:function(data){
		}
	});
}
function InitEvent(){
	threechecklistDataDataGridLoad();
	$('#BSave').click(function() {
		SaveDocClickHandle();	
	})
}
function threechecklistDataDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }, {
        text: '更新',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    }];
    if (ServerObj.CurrUserFlag=="1"){var toobar=""}
	var Columns=[[ 
		{field:'ThreeDocID',hidden:true,title:'ThreeDocID'},
		{field:'ThreeDocAdmID',hidden:true,title:'ThreeDocAdmID'},
		{field:'Type',title:'类型',width:100},
		{field:'UserDesc',title:'医生',width:100},
		{field:'UserID',hidden:true,title:'UserID'},
		{field:'ActiveFlag',title:'激活医生',width:100,
			editor:{
				type:'switchbox',
				options:{
					onText:$g('已激活'),
	                offText:$g('激活'),
	                onClass:'primary',
	                offClass:'gray',
	                size:"small",
	                onSwitchChange:function(e,val){
		                DocThreeCheckChange(e,val)
		            }
                }
			}
		},
		{field:'Defined',title:'护士分床时默认增加',
			styler: function(value,row,index){
			 				if (value=="Y"){
				 				return '';
				 			}else{
					 			return '';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 	   },width:130}
    ]]
    if (ServerObj.EpisodeID==""){
	    var Columns=[[ 
			{field:'ThreeDocID',hidden:true,title:'ThreeDocID'},
			{field:'ThreeDocAdmID',hidden:true,title:'ThreeDocAdmID'},
			{field:'Type',title:'类型',width:100},
			{field:'UserDesc',title:'医生',width:100},
			{field:'UserID',hidden:true,title:'UserID'},
			{field:'Defined',title:'护士分床时默认增加',width:100}
	    ]]
	    }
	var threechecklistDataDataGrid=$("#tabthreechecklist").datagrid({
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
		idField:'ThreeDocAdmID',
		columns :Columns,
		toolbar:toobar,
		onClickCell:function(rowIndex, field, value){
			},
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){

		},onLoadSuccess:function(data){
			var Rows=PageLogicObj.m_threechecklistDataGrid.datagrid('getRows');
			var ListData = PageLogicObj.m_threechecklistDataGrid.datagrid('getData');
			if ((ServerObj.CurrUserFlag!="1")&&(ServerObj.EpisodeID!="")){
				for (var i=Rows.length-1;i>=0;i--) {
					PageLogicObj.m_threechecklistDataGrid.datagrid("beginEdit", i);
					if (ListData.originalRows[i].ActiveFlag=="N"){var ActiveFlag=false;
					}else{var ActiveFlag=true;}
					var et = PageLogicObj.m_threechecklistDataGrid.datagrid('getEditor', {index:i,field:'ActiveFlag'});
					$HUI.switchbox(et.target).setValue(ActiveFlag)
					
					//if (ServerObj.CurrUserFlag=="1"){$(et.target).attr("disabled",true)}
				}
			}
		}
	}); 
	return threechecklistDataDataGrid;
}
function threechecklistDataDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocThreeCheckListAdm",
	    QueryName : "FindThreeDocAdm",
	    UserID : ServerObj.UserID,
	    LocID :ServerObj.LocID,
	    Adm :ServerObj.EpisodeID,
	    Pagerows:PageLogicObj.m_threechecklistDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_threechecklistDataGrid.datagrid("unselectAll");
		PageLogicObj.m_threechecklistDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function DocThreeCheckChange(e,val){
	
	var IDIndex=$(".datagrid-row-over")[0].id;
	var indexid=IDIndex.split("-")[4];
	var ListData = PageLogicObj.m_threechecklistDataGrid.datagrid('getData');
	var ThreeDocID=ListData.originalRows[indexid].ThreeDocID
	var ThreeDocAdmID=ListData.originalRows[indexid].ThreeDocAdmID
	var Type=ListData.originalRows[indexid].Type
	if (ServerObj.EpisodeID==""){
		$.messager.alert("提示","请选择患者后维护","info");
		var et = PageLogicObj.m_threechecklistDataGrid.datagrid('getEditor', {index:indexid,field:'ActiveFlag'});
		$HUI.switchbox(et.target).setValue(false);
		return
		}
	if (val.value==true){var DocType="Y"}else{var DocType="N"}
	var CheckFlag=0
	if (DocType=="Y"){
		var Rows=PageLogicObj.m_threechecklistDataGrid.datagrid('getRows');
		var ListData = PageLogicObj.m_threechecklistDataGrid.datagrid('getData');
		for (var i=Rows.length-1;i>=0;i--) {
			if (i==indexid) continue;
			var et = PageLogicObj.m_threechecklistDataGrid.datagrid('getEditor', {index:i,field:'ActiveFlag'});
			var ActiveValue=$HUI.switchbox(et.target).getValue()
			var RowType=ListData.originalRows[i].Type
			if ((RowType==Type)&&(ActiveValue==true)){
				CheckFlag=1
			}
		}
	}
	if (CheckFlag==1){
		$.messager.alert("提示","存在同一类型的医生不能改变","info");
		var et = PageLogicObj.m_threechecklistDataGrid.datagrid('getEditor', {index:indexid,field:'ActiveFlag'});
		$HUI.switchbox(et.target).setValue(false);
		return 
	}	
	$.cm({
		ClassName:"web.DHCDocThreeCheckListAdm",
		MethodName:"InsertThreeDocAdm",
		Adm:ServerObj.EpisodeID, ThreeDocID:ThreeDocID, ThreeDocAdmID:ThreeDocAdmID,
		Type:DocType, UpdateUserID:session['LOGON.USERID']
	},function(GridData){
		if (GridData!="0"){
			$.messager.alert("提示",$g("改变失败")+GridData,"info")
		}
		
	});
	
}
function AddClickHandle(){
	PageLogicObj.D_ThreeDocID="";
	$("#DocTypeCode,#Doclist").combobox('select','');
	$("#add-dialog").dialog("open");
}
function SaveDocClickHandle(){
	var DocTypeCode=$HUI.combobox("#DocTypeCode").getValue();
	var DocID=$HUI.combobox("#Doclist").getValue();
	if (DocID==undefined) DocID="";
	if (DocID==""){
		$.messager.alert("提示","请选择医生","info")
		return false;
	}
	var DefinedType=$("#DocDefined").checkbox('getValue');
	if (DefinedType==true){DefinedType="Y"}else{DefinedType="N"}
	
	$.cm({
		ClassName:"web.DHCDocThreeCheckListAdm",
		MethodName:"InsertThreeCheckDoc",
		ID:PageLogicObj.D_ThreeDocID, UserID:DocID, LocID:ServerObj.LocID,
		Type:DocTypeCode, UpdateUserID:session['LOGON.USERID'],Defined:DefinedType,
		Adm :ServerObj.EpisodeID,
		dataType:"text"
	},function(GridData){
		if (GridData!="0"){
			if (GridData==3){ 
				var GridData=$g("医生重复!");
			}else if(GridData==2){
				var GridData=$g("存在同一类型的医生已激活!");
			}
			$.messager.alert("提示",$g("保存失败!")+GridData,"info")
		}else{
			threechecklistDataDataGridLoad();
			$("#add-dialog").dialog("close");
			PageLogicObj.D_ThreeDocID="";
			$HUI.combobox("#Doclist").setValue("");	
		}
	});
}
function DelClickHandle(){
	var SelectedRow = PageLogicObj.m_threechecklistDataGrid.datagrid('getSelected');
	if (SelectedRow==null){
		$.messager.alert("提示","请选择一行","info");
		return false;
	}
	$.messager.confirm('提示', $g('是否删除您的所有患者对应的')+$g(SelectedRow.Type)+SelectedRow.UserDesc, function(r){
		if (r){
		    $.cm({
				ClassName:"web.DHCDocThreeCheckListAdm",
				MethodName:"DelectThreeDoc",
				ID:SelectedRow.ThreeDocID
			},function(GridData){
				if (GridData!="0"){
					$.messager.alert("提示",$g("删除失败")+GridData)
				}else{
					$.messager.popover({msg:"删除成功!",type:'success'});
					threechecklistDataDataGridLoad();
				}
			});
		}
	});
}
function UpdateClickHandle(){
	var SelectedRow = PageLogicObj.m_threechecklistDataGrid.datagrid('getSelected');
	if (SelectedRow==null){
		$.messager.alert("提示","请选择一行!");
		return false;
	}
	$("#add-dialog").dialog("open");
	$HUI.combobox("#Doclist").setValue(SelectedRow.UserID);
	if (SelectedRow.Type==$g("主(副)任医师")){var Type="MaterD"}else{var Type="UpD"}
	$HUI.combobox("#DocTypeCode").setValue(Type);
	if (SelectedRow.Defined=="Y"){var Defined=true}else{var Defined=false}
	$HUI.checkbox("#DocDefined").setValue(Defined)
	PageLogicObj.D_ThreeDocID=SelectedRow.ThreeDocID
}
