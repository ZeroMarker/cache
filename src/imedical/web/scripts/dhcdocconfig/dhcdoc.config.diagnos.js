var DiagnosDataGrid;
var DiagnosAliasDataGrid;
var editRow=undefined;
var editRow2=undefined;
$(function(){
	 $("#BFind").click(function(){
	   loadDiagnosDataGrid();
     });
	var DiagnosBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    DiagnosDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
                    DiagnosDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {

						}
                    });
                    DiagnosDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = DiagnosDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].MRCIDRowId);
                            }
                            var MRCIDRowId=ids.join(',')
                            $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.Diagnose","delete","false",function testget(value){
								if(value=="0"){
									DiagnosDataGrid.datagrid('load');
									DiagnosDataGrid.datagrid('unselectAll');
									$.messager.show({title:"提示",msg:"删除成功"});
								}else{
									$.messager.alert('提示',"删除失败:"+value);
								}
						      editRow = undefined;
						},"","",MRCIDRowId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	         
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
               //var rows = DiagnosDataGrid.datagrid("getSelected");     
               if (editRow != undefined)
                {
                	//var rows=DiagnosDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                	var rows=DiagnosDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
					var editors = DiagnosDataGrid.datagrid('getEditors', editRow);  				
					var Code =  editors[0].target.val();
					var ICD10Code =  editors[1].target.val();
					var ICD9Code =  editors[2].target.val();
	                var Description=editors[3].target.val();
					var LongDescription=editors[4].target.val();
					var SexRowid=editors[5].target.combobox('getValue');
					var FromDateNum=editors[6].target.combobox('getValue');
                    var CPWRowId=editors[7].target.combobox('getValue');
					var Str=Code+"!"+ICD10Code+"!"+ICD9Code+"!"+Description+"!"+LongDescription+"!"+SexRowid+"!"+FromDateNum+"!"+CPWRowId;
					var MRCIDRowId="";
					if(rows.MRCIDRowId){
						 MRCIDRowId=rows.MRCIDRowId;
					}
						$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.Diagnose","save","false",function testget(value){
							if(value=="0"){
								DiagnosDataGrid.datagrid("endEdit", editRow);
								editRow = undefined;
								DiagnosDataGrid.datagrid('load');
								DiagnosDataGrid.datagrid('unselectAll'); 
                                $.messager.show({title:"提示",msg:"保存成功"});								
							}else{
								$.messager.alert('提示',"保存失败:"+value);
								return false;
							}
						    editRow = undefined;
						},"","",MRCIDRowId,Str);
                	
			}
		  }
            
             
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow = undefined;
                DiagnosDataGrid.datagrid("rejectChanges");
                DiagnosDataGrid.datagrid("unselectAll");
            }
        },'-', {
            text: '别名',
            iconCls: 'icon-edit',
            handler: function() {
                var rows = DiagnosDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
	                $("#DiagnosAlias-form").css("display", ""); 
	                   dialog = $( "#DiagnosAlias-form" ).dialog({
				       autoOpen: false,
				       height: 400,
				       width: 500,
				       modal: true
				     });
				    dialog.dialog( "open" );
				    InitDiagnosAlias();
	                 /*var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].MRCIDRowId);
                            }
                            var MRCIDRowId=ids.join(',')*/
	            }else{
		            $.messager.alert("提示", "请选择需要维护别名的诊断", "error");
		        }
            }
        }];
    var DiagnosColumns=[[    
	                { field : 'MRCIDRowId',title : '',width : 1,hidden:true  
                    },
        			{ field: 'MRCIDCode', title: '代码', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor : {
                        type : 'text'
					  }
        			},
					{ field : 'MRCIDICD10CMCode',title : 'ICD10代码',width : 100 , align: 'center', sortable: true, resizable: true, 
                        editor : {
                        type : 'text',
						options:{
							required:false
						}
					  }
                    },
                    {
                      field : 'MRCIDICD9Map',title : 'ICD9代码',width : 100,
                        editor : {
                        type : 'text'
					   }	
                    },
					{ field: 'MRCIDDesc', title: '描述', width: 100, align: 'center', sortable: true, resizable: true,
					  editor : {
                        type : 'text'
					   }
					},
                    { field: 'MRCIDAlternateDesc', title: '英文描述', width: 100, align: 'center', sortable: true, resizable: true,
					  editor : {
                        type : 'text'
					  }
					},
					{ field: 'MRCIDSexDR', title: '性别限制', width: 100, align: 'center', sortable: true,
					  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'CTSEXRowId',
								textField:'CTSEXDesc',
								required:false,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.Diagnose";
									param.QueryName = "GetCTSex";
						            param.ArgCnt =0;
								}
							  }
     					  },
						  formatter:function(value,record){
							  return record.MRCIDSex;
						  }
					},
					{ field: 'MRCIDSex', title: '', width: 100, align: 'center', sortable: true, resizable: true,hidden:true
					},	
					{ field: 'MRCIDDateActiveFrom', title: '执行日期从', width: 100, align: 'center', sortable: true,editor: 'datebox',
					  formatter:function(value,record){
							  if((value!="")&&(value != undefined)) return value.split("/")[2]+"-"+value.split("/")[1]+"-"+value.split("/")[0];
							  else return "";
					  }
					},
                    { field: 'CPWRowId', title: '临床路径', width: 100, align: 'center', sortable: true, resizable: true,
					  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'DurRowId',
								textField:'DurCode',
								required:false,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.Diagnose";
									param.QueryName = "GetDiagnosPathWay";
						            param.ArgCnt =0;
								}
							  }
     					  },
						  formatter:function(value,record){
							  return record.CPWdesc;
						  }
					},
                    { field: 'CPWdesc', title: '', width: 100, align: 'center', sortable: true, resizable: true,hidden:true
					}					
    			 ]];
	DiagnosDataGrid=$("#tabDiagnos").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"MRCIDRowId",
		pageList : [15,50,100,200],
		columns :DiagnosColumns,
    	toolbar :DiagnosBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			DiagnosDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		},onBeforeLoad:function(param){
	       var DiagnosCode=$("#DiagnosCode").val();
	       var DiagnosDesc=$("#DiagnosDesc").val();
	       param.ClassName ='DHCDoc.DHCDocConfig.Diagnose';
	       param.QueryName ='GetDiagnos';
	       param.Arg1 =DiagnosCode;
	       param.Arg2 =DiagnosDesc;
	       param.ArgCnt =2;
	   }
	});
	//loadDiagnosDataGrid();
});
function loadDiagnosDataGrid()
{
	
	editRow=undefined;
    editRow2=undefined;
	var DiagnosCode=$("#DiagnosCode").val();
	var DiagnosDesc=$("#DiagnosDesc").val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Diagnose';
	queryParams.QueryName ='GetDiagnos';
	queryParams.Arg1 =DiagnosCode;
	queryParams.Arg2 =DiagnosDesc;
	queryParams.ArgCnt =2;
	var opts = DiagnosDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL
	DiagnosDataGrid.datagrid('load', queryParams);
};
function InitDiagnosAlias()
{
	var DiagnosAliasToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow2 != undefined) {
                    return;
                }else{
                    DiagnosAliasDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    DiagnosAliasDataGrid.datagrid("beginEdit", 0);
                    editRow2 = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = DiagnosAliasDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ALIASRowID);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.Diagnose","deleteAlias","false",function testget(value){
						        if(value=="0"){
							       DiagnosAliasDataGrid.datagrid('load');
           					       DiagnosAliasDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"提示",msg:"删除成功"});
						        }else{
							       $.messager.alert('提示',"删除失败:"+value);
						        }
						        editRow = undefined;
						   },"","",ID);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow2 = undefined;
                DiagnosAliasDataGrid.datagrid("rejectChanges");
                DiagnosAliasDataGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  //var rows = DiagnosAliasDataGrid.datagrid("getSelected");
			  var rows=DiagnosAliasDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected"); 
			  if (editRow2 != undefined) {
				  var editors = DiagnosAliasDataGrid.datagrid('getEditors', editRow2);
				  var Alias = editors[0].target.val(); 
				  if(Alias=="") {
					  $.messager.alert('提示',"请输入别名");
				  }
				  var ALIASRowID=""
				  if(rows.ALIASRowID){
					  ALIASRowID=rows.ALIASRowID
				  }
				  var MRCIDRowId=""
				  var rows = DiagnosDataGrid.datagrid("getSelected"); 
	              if(rows) MRCIDRowId=rows.MRCIDRowId
				  $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.Diagnose","saveAlias","false",function testget(value){
									if(value==0){
									   DiagnosAliasDataGrid.datagrid('load');
									   DiagnosAliasDataGrid.datagrid('unselectAll');
									   $.messager.show({title:"提示",msg:"保存成功"});
									}else{
									   $.messager.alert('提示',"保存失败:"+value);
									}
									editRow2 = undefined;
				    },"","",MRCIDRowId,ALIASRowID,Alias);
				  
			  }
			}
		}];
		var DiagnosAliasColumns=[[    
	                { field : 'ALIASRowID',title : '',width : 1,hidden:true  
                    },
        			{ field: 'ALIASText', title: '描述', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor : {
                        type : 'text'
					  }
        			}	
    			 ]];
	DiagnosAliasDataGrid=$("#tabDiagnosAlias").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ALIASRowID",
		pageList : [15,50,100,200],
		columns :DiagnosAliasColumns,
    	toolbar :DiagnosAliasToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow2 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			DiagnosAliasDataGrid.datagrid("beginEdit", rowIndex);
			editRow2=rowIndex
		},onBeforeLoad:function(param){
	       var MRCIDRowId="";
	       var rows = DiagnosDataGrid.datagrid("getSelected"); 
	      if(rows) MRCIDRowId=rows.MRCIDRowId
	      if(MRCIDRowId=="") return
	       param.ClassName ='DHCDoc.DHCDocConfig.Diagnose';
	       param.QueryName ='GetDiagnosAlias';
	       param.Arg1 =MRCIDRowId;
	       param.ArgCnt =1;
	   }
	});
	//loadDiagnosAliasDataGrid();
}
function loadDiagnosAliasDataGrid()
{
	editRow2 = undefined;
	var MRCIDRowId="";
	var rows = DiagnosDataGrid.datagrid("getSelected"); 
	if(rows) MRCIDRowId=rows.MRCIDRowId
	if(MRCIDRowId=="") return
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Diagnose';
	queryParams.QueryName ='GetDiagnosAlias';
	queryParams.Arg1 =MRCIDRowId;
	queryParams.ArgCnt =1;
	var opts = DiagnosAliasDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL
	DiagnosAliasDataGrid.datagrid('load', queryParams);
};