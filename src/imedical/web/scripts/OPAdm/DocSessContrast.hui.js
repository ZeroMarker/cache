var PageLogicObj={
	m_CareTypeListDataGrid:"",
	m_ResListDataGrid:"",
	editRow:-1,
	editRowNew:-1,
};
var SessObj={SessRowid:'',SessDesc:''};
var ResObj={LocRowid:'',LocDesc:'',ResRowid:'',ResDesc:'',SessRowid:'',SessDesc:''};
$(document).ready(function(){
	var hospComp = GenHospComp("DHC_RBSessContrast");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#Combo_CTLoc').combobox('reload');
		$HUI.combobox('#Combo_CTLoc').setValue("");
		LoadCareTypeListDataGridData();
		LoadResListDataGridData();
	}
	Init();
	InitEvent();
})
$(window).load(function(){
	LoadCareTypeListDataGridData();
	LoadResListDataGridData();
});

function Init(){
	InitFindLoc();
	PageLogicObj.m_CareTypeListDataGrid=InitCareTypeListDataGrid();
	PageLogicObj.m_ResListDataGrid=InitResListDataGrid();
}
function InitEvent(){
	$('#BFind').click(LoadResListDataGridData);
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
	            SessObj.SessRowid=rowObj.SessRowid;
				SessObj.SessDesc=rowObj.SessDesc;
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
						SessObj.SessRowid=record.SessRowid;
						SessObj.SessDesc=record.SessDesc;
					},
					onChange:function(newValue,oldValue){
						if (newValue==""){
							SessObj.SessRowid="";
							SessObj.SessDesc="";
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
		pageSize: 20,
		pageList : [20,50,100],
		idField:'CareTpRowid',
		columns :Columns,
		toolbar:toobar,
		onDblClickRow: function (rowIndex, row) {
			if (rowIndex!=PageLogicObj.editRow){
            	PageLogicObj.editRow=EditDataGridRow(CareTypeListDataGrid,rowIndex,PageLogicObj.editRow);
            	SessObj.SessRowid=row.SessRowid;
				SessObj.SessDesc=row.SessDesc;
            }
        },onAfterEdit: function (rowIndex, rowData, changes) {
	        //if(SessObj.SessRowid!=""){
		        $(this).datagrid('updateRow',{
					index:rowIndex,
					row:SessObj
				});
	        //}
			SessObj={SessRowid:'',SessDesc:''};
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
		PageLogicObj.m_CareTypeListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_CareTypeListDataGrid.datagrid('clearSelections').datagrid('clearChecked'); 
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
					$.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
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
                PageLogicObj.m_ResListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                //PageLogicObj.m_ResListDataGrid.datagrid("unselectAll");  
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
							ResObj.LocRowid=record.LocRowid;
							ResObj.LocDesc=record.LocDesc;
							var rows=PageLogicObj.m_ResListDataGrid.datagrid("selectRow",PageLogicObj.editRowNew).datagrid("getSelected");
	                        rows.LocRowid=record.LocRowid
							//科室医生资源combobox联动
							var obj=PageLogicObj.m_ResListDataGrid.datagrid('getEditor',{index:PageLogicObj.editRowNew,field:'ResDesc'})
							if(obj){
								var CareTarget=obj.target;
								CareTarget.combobox('clear');
								var url=$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocRes&LocId="+ResObj.LocRowid+"&ResultSetType=array";
								CareTarget.combobox('reload',url);
								CareTarget.combobox("select","");
								ResObj.ResRowid="";
								rows.ResRowid="";
							}
						},
						filter: function(q, row){
							return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								ResObj.LocRowid="";
								ResObj.LocDesc="";
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
						url:$URL+"?ClassName=web.DHCDocSessContrast&QueryName=QueryLocRes&LocId="+ResObj.LocRowid+"&ResultSetType=array",
						required:false,
						editable:true,
						panelHeight:'300',
						onSelect:function(record){
							var rows=PageLogicObj.m_ResListDataGrid.datagrid("selectRow",PageLogicObj.editRowNew).datagrid("getSelected");
	                        rows.ResRowid=record.ResRowid
							ResObj.ResRowid=record.ResRowid;
							ResObj.ResDesc=record.ResDesc;
						},
						filter: function(q, row){
							return (row["ResDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								ResObj.ResRowid="";
								ResObj.ResDesc="";
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
							ResObj.SessRowid=record.SessRowid;
							ResObj.SessDesc=record.SessDesc;
						},
						filter: function(q, row){
							return (row["SessDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								ResObj.SessRowid="";
								ResObj.SessDesc="";
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
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
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
	        if(ResObj.LocRowid!=""){
		        $(this).datagrid('updateRow',{
					index:rowIndex,
					row:ResObj
				});
	        }
			ResObj={LocRowid:'',LocDesc:'',ResRowid:'',ResDesc:'',SessRowid:'',SessDesc:''};
           // editRowNew=-1;
        },
        onLoadSuccess:function(){
	        PageLogicObj.editRowNew=-1;
	        PageLogicObj.m_ResListDataGrid.datagrid('unselectAll');
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
	ResObj=PageLogicObj.m_ResListDataGrid.datagrid("getData").rows[newRow];
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
				PageLogicObj.m_ResListDataGrid.datagrid('unselectAll');
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