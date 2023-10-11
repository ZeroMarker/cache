var PageLogicObj={
	m_CareTypeListDataGrid:"",
	m_ResListDataGrid:"",
	m_SessDeptListDataGrid:"",
	m_LocListTabDataGrid:"",
	editRow:-1,
	editRowNew:-1,
	editRowSessDept:undefined,
	ShowDeptSessRowid:""
};
var PageTempObj={
	SessObj:{SessRowid:'',SessDesc:''},
	ResObj:{LocRowid:'',LocDesc:'',ResRowid:'',ResDesc:'',SessRowid:'',SessDesc:''},
	SessDeptObj:{NoAuthDeptIDStr:'',AuthDeptIDStr:'',AuthDeptCount:'',SessRowid:'',SessDesc:''}
}
$(document).ready(function(){
	var hospComp = GenHospComp("DHC_RBSessContrast");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#Combo_CTLoc').combobox('reload');
		$HUI.combobox('#Combo_CTLoc').setValue("");
		LoadDataGridData();
	}
	Init();
	InitEvent();
})
$(window).load(function(){
	LoadDataGridData();
});

function LoadDataGridData(){
	LoadCareTypeListDataGridData();
	LoadResListDataGridData();
}

function Init(){
	InitFindLoc();
	PageLogicObj.m_CareTypeListDataGrid=InitCareTypeListDataGrid();
	PageLogicObj.m_ResListDataGrid=InitResListDataGrid();
	PageLogicObj.m_SessDeptListDataGrid=InitSessDeptListDataGrid();
}
function InitEvent(){
	$('#BFind').click(LoadResListDataGridData);
	$('#BSave').click(SaveLocStrToDataGrid);
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitFindLoc(){
	$HUI.combobox('#Combo_CTLoc',{    
    	valueField:'LocRowid',   
    	textField:'LocDesc',
    	url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocList&Desc=&ResultSetType=array",
		filter: function(q, row){
			return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onBeforeLoad:function(param){
			param.HospID=$HUI.combogrid('#_HospList').getValue();
		}
	});		
}

function InitCareTypeListDataGrid(){
	var toobar=[{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { SaveCareTypeClickHandle();}
    },{
        text: '编辑',
        iconCls: 'icon-edit',
        handler: function() {
            var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
            if(rowObj){		           
	            var rowIndex=PageLogicObj.m_CareTypeListDataGrid.datagrid("getRowIndex",rowObj);
	            //PageLogicObj.m_CareTypeListDataGrid.datagrid("rejectChanges");
	            PageLogicObj.editRow=EditDataGridRow(PageLogicObj.m_CareTypeListDataGrid,rowIndex,PageLogicObj.editRow);
	            PageTempObj.SessObj.SessRowid=rowObj.SessRowid;
				PageTempObj.SessObj.SessDesc=rowObj.SessDesc;
	        }else
            	$.messager.alert("提示","请选择需要编辑的行","info");
        	}
        }];
	var Columns=[[ 
		{field:'CareTpRowid',hidden:true,title:''},
		{field:'CareTpDesc',title:'医护类型',width:200},
		{field:'SessDesc',title:'默认职称',width:200,
			editor:{
				type:'combobox',
				options:{
					valueField:'SessRowid',
					textField:'SessDesc',
					url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QuerySessList&Desc=&HospID="+$HUI.combogrid('#_HospList').getValue()+"&ResultSetType=array",
					editable:true,
					panelHeight:'300',
					onBeforeLoad:function(param){
							param.HospID=$HUI.combogrid('#_HospList').getValue();
						},
					onSelect:function(record){
						PageTempObj.SessObj.SessRowid=record.SessRowid;
						PageTempObj.SessObj.SessDesc=record.SessDesc;
					},
					onChange:function(newValue,oldValue){
						if (newValue==""){
							PageTempObj.SessObj.SessRowid="";
							PageTempObj.SessObj.SessDesc="";
						}
					}
				}
			}
		},
		{field:'SessRowid',hidden:true,title:''},
    ]]
	var CareTypeListDataGrid=$("#tabCareTypeList").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 10,
		pageList : [10,20,50],
		idField:'CareTpRowid',
		columns :Columns,
		toolbar:toobar,
		onClickRow: function (rowIndex, row) {
			LoadSessDeptDataGridData(row.CareTpRowid);
		},
		onDblClickRow: function (rowIndex, row) {
			if (rowIndex!=PageLogicObj.editRow){
            	PageLogicObj.editRow=EditDataGridRow(CareTypeListDataGrid,rowIndex,PageLogicObj.editRow);
            	PageTempObj.SessObj.SessRowid=row.SessRowid;
				PageTempObj.SessObj.SessDesc=row.SessDesc;
            }
        },onAfterEdit: function (rowIndex, rowData, changes) {
	        //if(PageTempObj.SessObj.SessRowid!=""){
		        $(this).datagrid('updateRow',{
					index:rowIndex,
					row:PageTempObj.SessObj
				});
	        //}
			PageTempObj.SessObj={SessRowid:'',SessDesc:''};
            PageLogicObj.editRow = -1;
        }
		
	}); 
	return CareTypeListDataGrid;
}
function EditDataGridRow(DataGridObj,newRow,oldRow)
{
	if(oldRow!=-1) {
		DataGridObj.datagrid("endEdit", oldRow);
		DataGridObj.datagrid("cancelEdit", oldRow);
	}
    DataGridObj.datagrid("beginEdit", newRow);
    return newRow;
}

function LoadCareTypeListDataGridData(){
	$.cm({
		ClassName:"web.DHCDocSessContrast",
		QueryName:"QueryCareType",
		'Type':"DOCTOR",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		Pagerows:PageLogicObj.m_CareTypeListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.editRow=-1;
		PageLogicObj.m_CareTypeListDataGrid.datagrid('clearSelections').datagrid('clearChecked'); 	
		PageLogicObj.m_CareTypeListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		LoadSessDeptDataGridData();
	}); 
}

function SaveCareTypeClickHandle(){
	PageLogicObj.m_CareTypeListDataGrid.datagrid("endEdit", PageLogicObj.editRow);
    var DataArr=PageLogicObj.m_CareTypeListDataGrid.datagrid('getData').rows;
    var InputStr="";
    for(i=0;i<DataArr.length;i++){
        if(InputStr=="") InputStr=DataArr[i].CareTpRowid+"!"+DataArr[i].SessRowid;
    	else InputStr=InputStr+"^"+DataArr[i].CareTpRowid+"!"+DataArr[i].SessRowid;
    }
    $.cm({
		ClassName:"web.DHCDocSessContrast",
		MethodName:"SaveSessContrast",
		InputStr:InputStr,
		HospID:$HUI.combogrid('#_HospList').getValue(),
		dataType:"text",
	},function(getValue){
		if(getValue=='0'){
	    	$.messager.show({title:"提示",msg:"保存成功"});
	    	LoadCareTypeListDataGridData();
	    }else{
	    	$.messager.alert("提示","保存失败","warning");
	    }	
	})	
}

function InitResListDataGrid(){
	var ResListBar = [{
			text: '增加',
			iconCls: 'icon-add',
			handler: function() {
				if(PageLogicObj.editRowNew!=-1){
					$.messager.alert("提示", "有正在编辑的行，请先点击保存!", "info");
		        	return false;	
				}
				if(!CheckResRequire()) return;
				//添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                PageLogicObj.m_ResListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {
						SessRowid:"",
						SessDesc:"",
						ResRowid:"",
						ResDesc:"",
						SessRowid:"",	
						SessDesc:"",						
					}
                });
                PageLogicObj.m_ResListDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.editRowNew = 0;

			}   
		}, {
			text: '取消编辑',
			iconCls: 'icon-edit',
			handler: function() {
                PageLogicObj.m_ResListDataGrid.datagrid("rejectChanges").datagrid("clearSelections");
                //PageLogicObj.m_ResListDataGrid.datagrid("clearSelections");  
                // rejectChanges没回滚???
                LoadResListDataGridData();  
                PageLogicObj.editRowNew = -1;
			}   
        },{
			text: '删除',
			iconCls: 'icon-remove',
			handler: function() {
				DeleteResListData();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveResListData();
			}
        }]
	var ListColumns=[[ 
			{ field: 'RBRCRowID', title:'', width: 1,align: 'left', sortable: true,hidden:true},
			{ field: 'LocRowid', title:'', width: 1,align: 'left', sortable: true,hidden:true},
			{ field: 'LocDesc', title: '科室',width:200,  align: 'left', sortable: false, resizable: true,
				editor:{
					type:'combobox',
					options:{
						valueField:'LocRowid',
						textField:'LocDesc',
						url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocList&Desc=&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
						required:true,
						editable:true,
						panelHeight:'300',
						onBeforeLoad:function(param){
							param.HospID=$HUI.combogrid('#_HospList').getValue();
						},
						onSelect:function(record){
							PageTempObj.ResObj.LocRowid=record.LocRowid;
							PageTempObj.ResObj.LocDesc=record.LocDesc;
							var rows=PageLogicObj.m_ResListDataGrid.datagrid("selectRow",PageLogicObj.editRowNew).datagrid("getSelected");
	                        rows.LocRowid=record.LocRowid
							//科室医生资源combobox联动
							var obj=PageLogicObj.m_ResListDataGrid.datagrid('getEditor',{index:PageLogicObj.editRowNew,field:'ResDesc'})
							if(obj){
								var CareTarget=obj.target;
								CareTarget.combobox('clear');
								var url=$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocRes&LocId="+PageTempObj.ResObj.LocRowid+"&ResultSetType=array";
								CareTarget.combobox('reload',url);
								CareTarget.combobox("select","");
								PageTempObj.ResObj.ResRowid="";
								rows.ResRowid="";
							}
						},
						filter: function(q, row){
							return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								PageTempObj.ResObj.LocRowid="";
								PageTempObj.ResObj.LocDesc="";
							}
						}
					}
				}
			},
			{ field: 'ResRowid', title:'', width: 1,align: 'left', sortable: true,hidden:true},
			{ field: 'ResDesc', title: '医生',width:200,  align: 'left', sortable: false,
				styler: function(value,row,index){
					if (value==""){
						return 'background-color:#ffee00;color:red;';
					}
				},
				formatter: function(value,row,index){
					if (value=="")	return "<B>--科室默认--</B>";
					else return value;
				},
				editor:{
					type:'combobox',
					options:{
						valueField:'ResRowid',
						textField:'ResDesc',
						url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocRes&LocId="+PageTempObj.ResObj.LocRowid+"&ResultSetType=array",
						required:false,
						editable:true,
						panelHeight:'300',
						onSelect:function(record){
							var rows=PageLogicObj.m_ResListDataGrid.datagrid("selectRow",PageLogicObj.editRowNew).datagrid("getSelected");
	                        rows.ResRowid=record.ResRowid
							PageTempObj.ResObj.ResRowid=record.ResRowid;
							PageTempObj.ResObj.ResDesc=record.ResDesc;
						},
						filter: function(q, row){
							return (row["ResDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								PageTempObj.ResObj.ResRowid="";
								PageTempObj.ResObj.ResDesc="";
							}
						}
					}
				}
			},
			{ field: 'SessRowid', title:'', width: 1,align: 'left', sortable: false,hidden:true},
			{ field: 'SessDesc', title: '职称',width:200,  align: 'left', sortable: false, resizable: true,
				editor:{
					type:'combobox',
					options:{
						valueField:'SessRowid',
						textField:'SessDesc',
						url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QuerySessList&Desc=&HospID="+$HUI.combogrid('#_HospList').getValue()+"&ResultSetType=array",
						required:true,
						editable:true,
						panelHeight:'300',
						onBeforeLoad:function(param){
							param.HospID=$HUI.combogrid('#_HospList').getValue();
						},
						onSelect:function(record){
							var rows=PageLogicObj.m_ResListDataGrid.datagrid("selectRow",PageLogicObj.editRowNew).datagrid("getSelected");
	                        rows.SessRowid=record.SessRowid
							PageTempObj.ResObj.SessRowid=record.SessRowid;
							PageTempObj.ResObj.SessDesc=record.SessDesc;
						},
						filter: function(q, row){
							return (row["SessDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								PageTempObj.ResObj.SessRowid="";
								PageTempObj.ResObj.SessDesc="";
							}
						}
					}
				}
			}
		 ]];
	var ResListDataGrid=$('#tabResList').datagrid({  
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
		idField:"RBRCRowID",
		columns :ListColumns,
		toolbar :ResListBar,
		onDblClickCell: function (rowIndex, field, value){
            if (PageLogicObj.editRowNew != -1) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存!", "info");
		        return false;
			}
            PageLogicObj.editRowNew=EditResDataGridRow(rowIndex);
        },
        onBeginEdit:function(rowIndex, rowData){
	        var obj=PageLogicObj.m_ResListDataGrid.datagrid('getEditor',{index:rowIndex,field:'ResDesc'})
			if(obj){
				var CareTarget=obj.target;
				CareTarget.combobox('clear');
				var url=$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocRes&LocId="+rowData.LocRowid+"&ResultSetType=array";
				CareTarget.combobox('reload',url);
				CareTarget.combobox("setValue",rowData.ResRowid);
			}
	    },
        onAfterEdit: function(rowIndex, rowData, changes) {
	        if(PageTempObj.ResObj.LocRowid!=""){
		        $(this).datagrid('updateRow',{
					index:rowIndex,
					row:PageTempObj.ResObj
				});
	        }
			PageTempObj.ResObj={LocRowid:'',LocDesc:'',ResRowid:'',ResDesc:'',SessRowid:'',SessDesc:''};
           // editRowNew=-1;
        },
        onLoadSuccess:function(){
	        PageLogicObj.editRowNew=-1;
	        PageLogicObj.m_ResListDataGrid.datagrid('clearSelections');
	    }		
	});
	return ResListDataGrid;
}

function EditResDataGridRow(newRow)
{
	if(PageLogicObj.editRowNew!=-1) {
		PageLogicObj.m_ResListDataGrid.datagrid("endEdit", PageLogicObj.editRowNew);
		PageLogicObj.m_ResListDataGrid.datagrid("cancelEdit", PageLogicObj.editRowNew);
	}
	PageTempObj.ResObj=PageLogicObj.m_ResListDataGrid.datagrid("getData").rows[newRow];
    PageLogicObj.m_ResListDataGrid.datagrid("beginEdit", newRow);
    return newRow;
}

function SaveResListData(){
	var rows = PageLogicObj.m_ResListDataGrid.datagrid("getRows");
    if (rows.length > 0)
   	{ 	
     	for (var i = 0; i < rows.length; i++) {
			if(PageLogicObj.editRowNew==i){
				var rows=PageLogicObj.m_ResListDataGrid.datagrid("selectRow",PageLogicObj.editRowNew).datagrid("getSelected");
				var editors = PageLogicObj.m_ResListDataGrid.datagrid('getEditors', PageLogicObj.editRowNew); 
				if(rows.LocRowid){
					var LocRowid=rows.LocRowid;
				}else{
					var LocRowid="";	
				}
				if(rows.ResRowid){
					var ResRowid=rows.ResRowid;
				}else{
					var ResRowid="";	
				}
				if(rows.SessRowid){
					var SessRowid=rows.SessRowid;
				}else{
					var SessRowid="";	
				}
				if(rows.RBRCRowID){
					var RBRCRowID=rows.RBRCRowID;
				}else{
					var RBRCRowID="";	
				}
				if(LocRowid==""){
					$.messager.alert("提示","请选择科室","info");  
					return false; 	
				}
				if(SessRowid==""){
					$.messager.alert("提示","请选择职称","info");   
					return false; 		
				}
		        var InputData="";
		        var InputData=LocRowid+"!"+ResRowid+"!"+SessRowid+"!"+RBRCRowID;
		        $.cm({
					ClassName:"web.DHCDocSessContrast",
					MethodName:"SaveResContrast",
					'InputStr':InputData,
					dataType:"text",
				},function(value){
					var retArr=value.split("^");
					if(retArr[0]=='0'){
		            	$.messager.show({title:"提示",msg:"保存成功"});
		            	LoadResListDataGridData();
		            	PageLogicObj.editRowNew=-1;
			        }else{
			        	$.messager.alert("提示",retArr[1],"warning");  
			        } 
				})
			} 
     	}
   	} 	
}

function DeleteResListData(){
	var rowObj=PageLogicObj.m_ResListDataGrid.datagrid("getSelected");
    if(rowObj){
		if(rowObj.RBRCRowID){
			var RBRCRowID=rowObj.RBRCRowID;
		}else{
			var RBRCRowID="";	
		}
		if(RBRCRowID==""){
			$.messager.alert("提示","请选择需要删除的行","info");
			return;
		}
		$.m({
			ClassName:"web.DHCDocSessContrast",
			MethodName:"delete",
			'RBRCRowID':RBRCRowID,
			dataType:"text",
		},function(value){
			if(value=="0"){
				PageLogicObj.m_ResListDataGrid.datagrid('clearSelections');
				$.messager.show({title:"提示",msg:"删除成功"});
				LoadResListDataGridData();
			}else{
				$.messager.alert('提示',"删除失败:"+value,"error");
			}
			PageLogicObj.editRowNew= -1;	
		})
    }else{
    	$.messager.alert("提示","请选择需要删除的行","info");
	}	
}

function CheckResRequire()
{
	PageLogicObj.m_ResListDataGrid.datagrid("endEdit", PageLogicObj.editRowNew);
	var DataArr=PageLogicObj.m_ResListDataGrid.datagrid("getData").rows;
	for(i=0;i<DataArr.length;i++){
        if((DataArr[i].LocDesc=="")||(DataArr[i].SessDesc=="")){
            $.messager.alert("提示","科室和医生挂号职称必选","info");
            PageLogicObj.editRowNew=i;
            PageLogicObj.m_ResListDataGrid.datagrid("beginEdit", PageLogicObj.editRowNew);
            return false;
        }
    }
    return true;
}

function LoadResListDataGridData(){
	var FindLocID=$HUI.combobox("#Combo_CTLoc").getValue();
	FindLocID=CheckComboxSelData("Combo_CTLoc",FindLocID)
	$.cm({
	    ClassName : "web.DHCDocSessContrast",
	    QueryName : "QueryResContrast",
	    'LocId':FindLocID,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_ResListDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_ResListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_ResListDataGrid.datagrid('clearSelections').datagrid('clearChecked'); 
	}); 
	PageLogicObj.editRowNew=-1;
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
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
        //e.preventDefault(); 
        return false;  
    }  
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="Combo_CTLoc"){
			var CombValue=Data[i].LocRowid;
		 	var CombDesc=Data[i].LocDesc;
	     }else if (id=="AdmReason"){
		    var CombValue=Data[i].value  
		 	var CombDesc=Data[i].desc
		 }
		 if(selId==CombValue){
			 selId=CombValue;
			 Find=1;
			 break;
	     }
	  }
	  if (Find=="1") return selId
	  return "";
}

function InitSessDeptListDataGrid(){
	var toobar=[{
		text: '增加',
		iconCls: 'icon-add',
		handler: function() {
			if(PageLogicObj.editRowSessDept!=undefined){
				$.messager.alert("提示", "有正在编辑的行，请先点击保存!", "info");
	        	return false;	
			}
			//if(!CheckResRequire()) return;
			var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
            if(rowObj){
            }else{
	        	$.messager.alert("提示", "请先在上方表格选择一行医护人员类型数据.", "warning");
	        	return false;	
	        }
            PageLogicObj.m_SessDeptListDataGrid.datagrid("clearSelections");
            PageLogicObj.m_SessDeptListDataGrid.datagrid("insertRow", {
                index: 0,
                row: {
					SessRowid:"",
					SessDesc:"",
					AuthDeptCount:"",
					AuthDeptIDStr:""	
				}
            });
            PageLogicObj.m_SessDeptListDataGrid.datagrid("beginEdit", 0);
            PageLogicObj.editRowSessDept = -1;
			
		}   
	}, {
		text: '取消编辑',
		iconCls: 'icon-edit',
		handler: function() {
            PageLogicObj.m_SessDeptListDataGrid.datagrid("rejectChanges").datagrid("clearSelections");
            LoadSessDeptDataGridData();  
            PageLogicObj.editRowSessDept = undefined;
		}   
    },{
		text: '删除',
		iconCls: 'icon-remove',
		handler: function() {
			DeleteSessDeptListData();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			SaveSessDeptListData();
		}
    }]
	var Columns=[[ 
		{field:'SessDesc',title:'职称',width:200,
			editor:{
				type:'combobox',
				options:{
					valueField:'SessRowid',
					textField:'SessDesc',
					url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QuerySessList&Desc=&HospID="+$HUI.combogrid('#_HospList').getValue()+"&ResultSetType=array",
					editable:true,
					panelHeight:'300',
					onBeforeLoad:function(param){
						param.HospID=$HUI.combogrid('#_HospList').getValue();
					},
					onSelect:function(record){
						var GridData=PageLogicObj.m_SessDeptListDataGrid.datagrid("getData");
						var data=GridData.originalRows;
						var len=data.length;
						for(var i=0;i<len;i++){
							var onedata=data[i];
							if(onedata.SessRowid==record.SessRowid){
								$(this).combobox("clear");
								PageTempObj.SessDeptObj.SessRowid="";
								PageTempObj.SessDeptObj.SessDesc="";
								$.messager.alert("提示", "该职称数据已维护,请确认.", "warning");
								return false;
							}
						}
						PageTempObj.SessDeptObj.SessRowid=record.SessRowid;
						PageTempObj.SessDeptObj.SessDesc=record.SessDesc;
					},
					onChange:function(newValue,oldValue){
						if (newValue==""){
							PageTempObj.SessDeptObj.SessRowid="";
							PageTempObj.SessDeptObj.SessDesc="";
						}
					}
				}
			}
		},
		{field:'SessRowid',hidden:true,title:''},
		{field:'AuthDeptIDStr',hidden:true,title:''},
		{field:'AuthDeptCount', title: '已维护科室数量',width:140,  align: 'left', sortable: false},
		{field:'AuthDeptBtn', title:'科室', width: 100,align: 'left',
			formatter:function(value,row,index){
				var SessRowid=row.SessRowid;
				if(SessRowid=="")SessRowid=-1;
				return '<a href="###" id= "AuthDept'+index+'"'+' onclick=ShowAutoDept('+index+','+SessRowid+');>'+"<span class='fillspan'>配置科室</span>"+"</a>"
			}
		}
    ]]
	var SessDeptListDataGrid=$("#tabSessDeptList").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 10,
		pageList : [10,20,50],
		idField:'SessRowid',
		columns :Columns,
		toolbar:toobar,
		/*onDblClickRow: function (rowIndex, row) {
			if (rowIndex!=PageLogicObj.editRowSessDept){
            	PageLogicObj.editRowSessDept=EditDataGridRow(SessDeptListDataGrid,rowIndex,PageLogicObj.editRowSessDept);
            	PageTempObj.SessDeptObj.SessRowid=row.SessRowid;
				PageTempObj.SessDeptObj.SessDesc=row.SessDesc;
            }
        },*/onAfterEdit: function (rowIndex, rowData, changes) {
			PageTempObj.SessDeptObj={SessRowid:'',SessDesc:''};
            PageLogicObj.editRowSessDept = undefined;
        }
		
	}); 
	return SessDeptListDataGrid;
}

function ShowAutoDept(ind,SessRowid){
	if((PageLogicObj.editRowSessDept!=undefined)&&(PageLogicObj.editRowSessDept!=ind)&&(SessRowid!=-1)){
		$.messager.alert("提示", "有正在编辑的行，请先点击保存!", "info");
    	return false;	
	}
	if(SessRowid==-1)SessRowid="";
	PageLogicObj.m_SessDeptListDataGrid.datagrid("clearSelections");
	
	if((SessRowid=="")||(typeof(SessRowid)=='undefined')){
		SessRowid=GetSessRowid();	
	}
	if(SessRowid==""){
		$.messager.alert("提示", "请先选择职称!", "warning");
		return false;
	}
	
	$("#FindLoc").searchbox('setValue',""); 
	$('#MulSessDeptWin').window('open');
	if (PageLogicObj.m_LocListTabDataGrid==""){
		PageLogicObj.m_LocListTabDataGrid=InitLocListTabDataGrid(SessRowid);
	}
	PageLogicObj.ShowDeptSessRowid=SessRowid;
	LoadLocListTabGridData(SessRowid);
}

function LoadSessDeptDataGridData(CareTypeId){
	if((CareTypeId=="")||(typeof(CareTypeId)=='undefined')){
		var CareTypeId="";
		var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
		if(rowObj){
			CareTypeId=rowObj.CareTpRowid;
		}
	}
	$.cm({
	    ClassName : "web.DHCDocSessContrast",
	    QueryName : "QueryLocContrast",
	    CareTypeId:CareTypeId,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_SessDeptListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_SessDeptListDataGrid.datagrid("clearSelections");
		PageLogicObj.editRowSessDept = undefined;
		PageTempObj.SessDeptObj={NoAuthDeptIDStr:'',AuthDeptIDStr:'',AuthDeptCount:'',SessRowid:'',SessDesc:''};
		PageLogicObj.m_SessDeptListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}

function FindLocChange(){
	//PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
	LoadLocListTabGridData(PageLogicObj.ShowDeptSessRowid);
}
function InitLocListTabDataGrid(SessRowid){
	var Columns=[[ 
		{field:'LocRowid',title:'',checkbox:true},
		{field:'LocDesc',title:'科室',width:260},
		{field:'AuthedFlag',title:'',hidden:true}
    ]]
	var LocListTabDataGrid=$("#LocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'LocRowid',
		columns :Columns,
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var AuthedFlag=data.rows[i].AuthedFlag;
				if (AuthedFlag>0) {
					PageLogicObj.m_LocListTabDataGrid.datagrid('selectRow',i);
				}
			}
		},onBeforeCheck:function(index, row){
			var CareTypeId="";
			var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
			if(rowObj){
				CareTypeId=rowObj.CareTpRowid;
			}
			var SessRowid=GetSessRowid();
			var AuthTypeDesc=$.cm({
				ClassName:"web.DHCDocSessContrast",
				MethodName:"CheckAuthedOtherFlag",
				CareTypeId:CareTypeId,
				SessRowId:SessRowid,
				LocRowId:row.LocRowid,
				HospID:$HUI.combogrid('#_HospList').getValue(),
				dataType:"text"
			},false)
			if (AuthTypeDesc!="") {
				var flag=dhcsys_confirm("该科室已对照["+AuthTypeDesc+"],确定将取消与["+AuthTypeDesc+"]的对照,是否继续?")
				if (!flag) {
					return false;
				}
			}
		}
	});
	return LocListTabDataGrid;
}

function LoadLocListTabGridData(SessRowid){
	var desc=$("#FindLoc").searchbox('getValue'); 
	var CareTypeId="";
	var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
	if(rowObj){
		CareTypeId=rowObj.CareTpRowid;
	}
	if((SessRowid=="")||(typeof(SessRowid)=='undefined')){
		SessRowid=GetSessRowid();	
	}
	$.cm({
	    ClassName : "web.DHCDocSessContrast",
	    QueryName : "QueryLocList",
	    Desc:desc,
	    CareTypeId:CareTypeId,
	    SessRowId:SessRowid,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_LocListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_LocListTabDataGrid.datagrid("clearSelections").datagrid("clearChecked");;
		PageLogicObj.m_LocListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}

function SaveLocStrToDataGrid(){
	if (PageLogicObj.m_LocListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!","warning");
		return false;
	}
	var rows=PageLogicObj.m_LocListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!","warning");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var LocId=rows[i].LocRowid;
		if ($.hisui.indexOfArray(GridSelectArr,"LocRowid",LocId)>=0) {
			if (inPara == "") inPara = LocId;
			else  inPara = inPara + "^" + LocId;
		}else{
			if (subPara == "") subPara = LocId;
			else  subPara = subPara + "^" + LocId;
		}
	}
	
	$.extend(PageTempObj.SessDeptObj,{
		NoAuthDeptIDStr:subPara,AuthDeptIDStr:inPara
	})
	if(PageLogicObj.editRowSessDept==undefined){
		var rowObj=PageLogicObj.m_SessDeptListDataGrid.datagrid("getSelected");
		var index=PageLogicObj.m_SessDeptListDataGrid.datagrid("getRowIndex",rowObj);
		PageLogicObj.editRowSessDept=index;
	}
	PageLogicObj.ShowDeptSessRowid="";
	$('#MulSessDeptWin').window('close');
}

function SaveSessDeptListData(){
	var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
	if(rowObj){
		var SessRowid=GetSessRowid();
		if(SessRowid==""){
			$.messager.alert("提示", "未有需要保存的数据,请确认.", "warning");
    		return false;
		}
		var AuthDeptIDStr=PageTempObj.SessDeptObj.AuthDeptIDStr;
		if(AuthDeptIDStr==""){
			$.messager.alert("提示", "科室对照数据未发生改变或未对照,请确认.", "warning");
    		return false;	
		}
		$.cm({
			ClassName:"web.DHCDocSessContrast",
			MethodName:"SaveLocContrast",
			CareTypeId:rowObj.CareTpRowid,
			SessId:SessRowid,
			ILocStr:PageTempObj.SessDeptObj.AuthDeptIDStr,
			CLocStr:PageTempObj.SessDeptObj.NoAuthDeptIDStr,
			HospID:$HUI.combogrid('#_HospList').getValue()
		},function(ret){
			if(ret==0){
				LoadSessDeptDataGridData();
			}else{
				$.messager.alert("提示", "保存失败!", "warning");
    			return false;
			}
		})
    }else{
    	$.messager.alert("提示", "请先在上方表格选择一行医护人员类型数据.", "warning");
    	return false;	
    }
}

function GetSessRowid(){
	var SessRowid=PageTempObj.SessDeptObj.SessRowid;
	if(SessRowid==""){
		var rowObj=PageLogicObj.m_SessDeptListDataGrid.datagrid("getSelected");
        if(rowObj){
			SessRowid=rowObj.SessRowid;
        }
	}	
	return SessRowid;
}

function DeleteSessDeptListData(){
	var rowObj=PageLogicObj.m_CareTypeListDataGrid.datagrid("getSelected");
	if(rowObj){
		var SessRowid=GetSessRowid();
		if(SessRowid==""){
			$.messager.alert("提示", "未有需要删除的数据,请确认.", "warning");
    		return false;
		}
		$.messager.confirm("提示","是否确认删除?",function(r){
			if(r){
				$.cm({
					ClassName:"web.DHCDocSessContrast",
					MethodName:"DelLocContrast",
					CareTypeID:rowObj.CareTpRowid,
					SessionTypeID:SessRowid,
					HospID:$HUI.combogrid('#_HospList').getValue()
				},function(ret){
					if(ret==0){
						LoadSessDeptDataGridData();
					}else{
						$.messager.alert("提示", "删除失败!", "warning");
		    			return false;
					}
				})
			}
		},"info")
	}else{
		$.messager.alert("提示", "请选择一行医护人员类型.", "warning");
		return false;
	}
}