var CareTypeListDataGrid;
var ResListDataGrid;
var editRow=-1,editRowNew=-1;
var SessObj={SessRowid:'',SessDesc:''};
var ResObj={LocRowid:'',LocDesc:'',ResRowid:'',ResDesc:'',SessRowid:'',SessDesc:''};
$(window).load(function(){
	InitCareTypeList();
	InitDocList();
});
$(document).ready(function(){
	Init();
	InitEvent();
});

function Init(){
	$('#Combo_CTLoc').combobox({    
    	valueField:'LocRowid',   
    	textField:'LocDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'web.DHCDocSessContrast';
			param.QueryName = 'QueryLocList'
			param.Arg1="";
			param.ArgCnt =1;
		} ,
		filter: function(q, row){
			return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});	
}
function InitEvent(){
	$('#BFind').bind("click",function(){
		LoadResListDataGridData();	
	})	
	$(document.body).bind("keydown",BodykeydownHandler)
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
function InitCareTypeList()
{
	var CareTypeBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
		            CareTypeListDataGrid.datagrid("endEdit", editRow);
		            var DataArr=CareTypeListDataGrid.datagrid('getData').rows;
		            var InputStr="";
		            for(i=0;i<DataArr.length;i++){
			            if(InputStr=="") InputStr=DataArr[i].CareTpRowid+"!"+DataArr[i].SessRowid;
			        	else InputStr=InputStr+"^"+DataArr[i].CareTpRowid+"!"+DataArr[i].SessRowid;
			        }
			        var ret=tkMakeServerCall('web.DHCDocSessContrast','SaveSessContrast',InputStr);
			        if(ret=='0'){
		            	$.messager.show({title:"提示",msg:"保存成功"});
		            	CareTypeListDataGrid.datagrid("reload");
			        }else{
			        	$.messager.alert("提示","保存失败","warning");
			        }
		            //$.messager.show({title:"提示",msg:"保存成功"});
	            }
			},"-",{
            text: '编辑',
            iconCls: 'icon-edit',
            handler: function() {
	            var rowObj=CareTypeListDataGrid.datagrid("getSelected");
	            if(rowObj){		           
		            var rowIndex=CareTypeListDataGrid.datagrid("getRowIndex",rowObj);
		            CareTypeListDataGrid.datagrid("rejectChanges");
		            editRow=EditDataGridRow(CareTypeListDataGrid,rowIndex,editRow);
		            SessObj.SessRowid=rowObj.SessRowid;
					SessObj.SessDesc=rowObj.SessDesc;
		        }else
	            	$.messager.alert("提示","请选择需要编辑的行","info");
            	}
            }];
	ListColumns=[[ 
			{ field: 'CareTpRowid', title:'', width: 1,align: 'center', sortable: true,hidden:true},
			{ field: 'CareTpDesc', title: '医护类型',width:200,  align: 'center', sortable: true},
			{ field: 'SessRowid', title:'', width: 1,align: 'center', sortable: true,hidden:true},
			{ field: 'SessDesc', title: '默认职称',width:200,  align: 'center', sortable: true, resizable: true ,
				editor:{
					type:'combobox',
					options:{
						valueField:'SessRowid',
						textField:'SessDesc',
						url:'./dhcdoc.cure.query.combo.easyui.csp?ClassName=web.DHCDocSessContrast&QueryName=QuerySessList',
						//required:true,
						editable:true,
						panelHeight:'300',
						onSelect:function(record){
							SessObj.SessRowid=record.SessRowid;
							SessObj.SessDesc=record.SessDesc;
						},
						onChange:function(newValue,oldValue){
							if (newValue==""){
								SessObj.SessRowid="";
							}
						}
					}
				}
			}
		 ]];
	CareTypeListDataGrid=$('#tabCareTypeList').datagrid({
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"CareTpRowid",
		pageList : [20,50,100],
		columns :ListColumns,
		toolbar :CareTypeBar,
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocSessContrast';
			param.QueryName ='QueryCareType';
			param.ArgCnt =0;
		},
		onDblClickRow: function (rowIndex, row) {
			if (rowIndex!=editRow){
            	editRow=EditDataGridRow(CareTypeListDataGrid,rowIndex,editRow);
            	SessObj.SessRowid=row.SessRowid;
				SessObj.SessDesc=row.SessDesc;
            }
            
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
	        debugger;
	        //if(SessObj.SessRowid!=""){
		        $(this).datagrid('updateRow',{
					index:rowIndex,
					row:SessObj
				});
	        //}
			SessObj={SessRowid:'',SessDesc:''};
            editRow = -1;
        }
	});
}
function InitDocList()
{
	var ResListBar = [{
			text: '增加',
			iconCls: 'icon-add',
			handler: function() {
				if(editRowNew!=-1){
					$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        	return false;	
				}
				if(!CheckResRequire()) return;
				var newRowIndex=ResListDataGrid.datagrid('getRows').length;
				ResListDataGrid.datagrid('appendRow',{SessRowid:'',SessDesc:'',ResRowid:'',ResDesc:'',SessRowid:'',SessDesc:''});
				editRowNew=EditDataGridRow(ResListDataGrid,newRowIndex,editRowNew);
			}   
		},"-",{
			text: '删除',
			iconCls: 'icon-remove',
			handler: function() {
				var rowObj=ResListDataGrid.datagrid("getSelected");
	            if(rowObj){
					if(rowObj.RBRCRowID){
						var RBRCRowID=rowObj.RBRCRowID;
					}else{
						var RBRCRowID="";	
					}
					if(RBRCRowID==""){
						//editRowNew = -1;
		                //ResListDataGrid.datagrid("rejectChanges");
		                //ResListDataGrid.datagrid("unselectAll");        
						$.messager.alert("提示","请选择需要删除的行","info");
						return;
					}
					$.dhc.util.runServerMethod("web.DHCDocSessContrast","delete","false",function testget(value){
						if(value=="0"){
							ResListDataGrid.datagrid('load');
           					ResListDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRowNew= -1;
					},"","",RBRCRowID);
		            //var rowIndex=ResListDataGrid.datagrid("getRowIndex",rowObj);
		            //ResListDataGrid.datagrid("deleteRow",rowIndex);
		        }else
	            	$.messager.alert("提示","请选择需要删除的行","info");
			}
		},'-', {
			text: '取消编辑',
			iconCls: 'icon-edit',
			handler: function() {
				//取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRowNew = -1;
                ResListDataGrid.datagrid("rejectChanges");
                ResListDataGrid.datagrid("unselectAll");            
			}   
        },'-', {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				/*ResListDataGrid.datagrid("endEdit", editRowNew);
	            var DataArr=ResListDataGrid.datagrid('getData').rows;
	            var InputStr="";
	            for(i=0;i<DataArr.length;i++){
		            if(InputStr=="") InputStr=DataArr[i].LocRowid+"!"+DataArr[i].ResRowid+"!"+DataArr[i].SessRowid+"!"+DataArr[i].RBRCRowID;
		        	else InputStr=InputStr+"^"+DataArr[i].LocRowid+"!"+DataArr[i].ResRowid+"!"+DataArr[i].SessRowid+"!"+DataArr[i].RBRCRowID;
		        } */
		        var rows = ResListDataGrid.datagrid("getRows");
		        if (rows.length > 0)
               	{ 	
		         	for (var i = 0; i < rows.length; i++) {
						if(editRowNew==i){
							var rows=ResListDataGrid.datagrid("selectRow",editRowNew).datagrid("getSelected");
							var editors = ResListDataGrid.datagrid('getEditors', editRowNew); 
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
								$.messager.alert("提示","请选择科室");  
								return false; 	
							}
							if(SessRowid==""){
								$.messager.alert("提示","请选择职称");   
								return false; 		
							}
					        var InputData="";
					        var InputData=LocRowid+"!"+ResRowid+"!"+SessRowid+"!"+RBRCRowID;
					        var ret=tkMakeServerCall('web.DHCDocSessContrast','SaveResContrast',InputData);
					        var retArr=ret.split("^");
					        if(retArr[0]=='0'){
				            	$.messager.show({title:"提示",msg:"保存成功"});
				            	ResListDataGrid.datagrid("reload");
				            	editRowNew=-1;
					        }else
					        	$.messager.alert("提示",retArr[1],"warning");   
						} 
		         	}
               	}  
			}
        }]
	ListColumns=[[ 
			{ field: 'RBRCRowID', title:'', width: 1,align: 'center', sortable: true,hidden:true},
			{ field: 'LocRowid', title:'', width: 1,align: 'center', sortable: true,hidden:true},
			{ field: 'LocDesc', title: '科室',width:200,  align: 'center', sortable: false, resizable: true,
				editor:{
					type:'combobox',
					options:{
						valueField:'LocRowid',
						textField:'LocDesc',
						url:'./dhcdoc.cure.query.combo.easyui.csp?ClassName=web.DHCDocSessContrast&QueryName=QueryLocList',
						required:true,
						editable:true,
						panelHeight:'300',
						onSelect:function(record){
							ResObj.LocRowid=record.LocRowid;
							ResObj.LocDesc=record.LocDesc;
							var rows=ResListDataGrid.datagrid("selectRow",editRowNew).datagrid("getSelected");
	                        rows.LocRowid=record.LocRowid
							//科室医生资源combobox联动
							var obj=ResListDataGrid.datagrid('getEditor',{index:editRowNew,field:'ResDesc'})
							if(obj){
								var CareTarget=obj.target;
								CareTarget.combobox('clear');
								CareTarget.combobox('reload');
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
			{ field: 'ResRowid', title:'', width: 1,align: 'center', sortable: true,hidden:true},
			{ field: 'ResDesc', title: '医生',width:200,  align: 'center', sortable: false,
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
						url:'./dhcdoc.cure.query.combo.easyui.csp',
						method:'GET',
						required:false,
						editable:true,
						panelHeight:'300',
						onSelect:function(record){
							var rows=ResListDataGrid.datagrid("selectRow",editRowNew).datagrid("getSelected");
	                        rows.ResRowid=record.ResRowid
							ResObj.ResRowid=record.ResRowid;
							ResObj.ResDesc=record.ResDesc;
						},
						onBeforeLoad:function(param){
							param.ClassName ='web.DHCDocSessContrast';
							param.QueryName ='QueryLocRes';
							param.Arg1=ResObj.LocRowid;
							param.ArgCnt =1;	
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
			{ field: 'SessRowid', title:'', width: 1,align: 'center', sortable: false,hidden:true},
			{ field: 'SessDesc', title: '职称',width:200,  align: 'center', sortable: false, resizable: true,
				editor:{
					type:'combobox',
					options:{
						valueField:'SessRowid',
						textField:'SessDesc',
						url:'./dhcdoc.cure.query.combo.easyui.csp?ClassName=web.DHCDocSessContrast&QueryName=QuerySessList',
						required:true,
						editable:true,
						panelHeight:'300',
						onSelect:function(record){
							var rows=ResListDataGrid.datagrid("selectRow",editRowNew).datagrid("getSelected");
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
	ResListDataGrid=$('#tabResList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ResRowid",
		pageList : [20,50,100],
		columns :ListColumns,
		toolbar :ResListBar,
		onDblClickCell: function (rowIndex, field, value){
            //editRowNew=EditResDataGridRow(ResListDataGrid,rowIndex,editRowNew);
            if (editRowNew != -1) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
            editRowNew=EditResDataGridRow(rowIndex);
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
        onLoadSuccess:function(data){
	        editRowNew=-1;
	        ResListDataGrid.datagrid('unselectAll');
	    }		
	});
	LoadResListDataGridData();
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
function EditResDataGridRow(newRow)
{
	if(editRowNew!=-1) {
		ResListDataGrid.datagrid("endEdit", editRowNew);
		ResListDataGrid.datagrid("cancelEdit", editRowNew);
	}
	ResObj=ResListDataGrid.datagrid("getData").rows[newRow];
    ResListDataGrid.datagrid("beginEdit", newRow);
    return newRow;
}
function CheckResRequire()
{
	ResListDataGrid.datagrid("endEdit", editRowNew);
	var DataArr=ResListDataGrid.datagrid("getData").rows;
	for(i=0;i<DataArr.length;i++){
        if((DataArr[i].LocDesc=="")||(DataArr[i].SessDesc=="")){
            $.messager.alert("提示","科室和医生挂号职称必选","warning");
            editRowNew=i;
            ResListDataGrid.datagrid("beginEdit", editRowNew);
            return false;
        }
    }
    return true;
}

function LoadResListDataGridData(){
	editRowNew=-1;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocSessContrast';
	queryParams.QueryName ='QueryResContrast';
	queryParams.Arg1 =$('#Combo_CTLoc').combobox('getValue');;
	queryParams.ArgCnt =1;
	var opts = ResListDataGrid.datagrid("options");
	opts.url = "./dhcdoc.config.query.grid.easyui.csp"
	ResListDataGrid.datagrid('load', queryParams);
	ResListDataGrid.datagrid('unselectAll');	
}