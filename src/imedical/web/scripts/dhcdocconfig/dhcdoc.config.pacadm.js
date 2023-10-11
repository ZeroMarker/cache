var PACADMDataGrid;
var editRow = undefined;
var PACRowId="";
$(function(){ 
   InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_PACADM");
	hospComp.jdata.options.onSelect = function(e,t){
		 $('#tabPACADM').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPACADM();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.hasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitPACADM()
{
	var PACADMToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
            	editRow = undefined;
                PACADMDataGrid.datagrid("rejectChanges");
			    PACADMDataGrid.datagrid('unselectAll');
                if (editRow != undefined) {
					PACADMDataGrid.datagrid("endEdit", editRow);
                }
                PACADMDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                });
				PACADMDataGrid.datagrid("beginEdit", 0);
				editRow = 0;

              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PACADMDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].PACRowId);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow = undefined;
				                PACADMDataGrid.datagrid("rejectChanges");
				                PACADMDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.PACADM", 
								MethodName:"delete",
								Rowid:ID
							},false);
					        if(value=="0"){
						       PACADMDataGrid.datagrid('load');
	   					       PACADMDataGrid.datagrid('unselectAll');
	   					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
						       return;
					        }
					        editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                PACADMDataGrid.datagrid("rejectChanges");
                PACADMDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				if(editRow==0) PACADMDataGrid.datagrid("unselectAll");
				var rows=PACADMDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				//var rows = PACADMDataGrid.datagrid("getSelected");
				var editors = PACADMDataGrid.datagrid('getEditors', editRow);
				var PACSocialStatus = editors[0].target.combobox('getValue');
				if(!PACSocialStatus){
					$.messager.alert('提示',"请选择患者类别!");
					return false;
				};
				var PACAdmReason=editors[1].target.combobox('getValue');
				if(!PACAdmReason){
					$.messager.alert('提示',"请选择费别!");
					return false;
				};
				var PACRowId=rows.PACRowId;
				if (PACRowId==undefined) PACRowId="";
				if(PACRowId!=""){
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.PACADM", 
						MethodName:"update",
						Rowid:PACRowId,
						PACSocialStatus:PACSocialStatus,
						PACAdmReason:PACAdmReason,
						HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
			        if(value==0){
				       PACADMDataGrid.datagrid('load');
				       PACADMDataGrid.datagrid('unselectAll');
				       $.messager.show({title:"提示",msg:"保存成功"});
			        }else if(value=="-1"){
						$.messager.alert('提示',"不能修改,该记录已存在!");
				        return false;
					}else{
				        $.messager.alert('提示',"保存失败:"+value);
					    return false;
			        }
			        editRow = undefined;
				}else{
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.PACADM", 
						MethodName:"insert",
						PACSocialStatus:PACSocialStatus,
						PACAdmReason:PACAdmReason,
						HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
			        if(value==0){
				       PACADMDataGrid.datagrid('load');
				       PACADMDataGrid.datagrid('unselectAll');
				       $.messager.show({title:"提示",msg:"保存成功"});
			        }else if(value=="-1"){
						$.messager.alert('提示',"不能增加,该记录已存在!");
				        return false;
					}else{
				       $.messager.alert('提示',"保存失败:"+value);
			        }
			        editRow = undefined;
				}
	
			 }
			}
		}
		];
	PACADMColumns=[[    
                    { field: 'PACRowId', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'PACSocialStatusDr', title:'患者类别', width: 10,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PACADM&QueryName=GetCTSocialstatusList"+"&rows=9999",
								valueField:'SSRowId',
								textField:'SSDesc',
								required:false,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
									$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					},
						formatter:function(SSRowId,record){
							  return record.PACSocialStatus;
						  }
					},
        			{ field: 'PACSocialStatus', title: '病人类别', width: 20,hidden:true},
					{ field: 'PACAdmReasonDr', title: '费别', width: 20,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value="+"&rows=9999",
								valueField:'BillTypeRowid',
								textField:'BillTypeDesc',
								required:false,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
									$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					  },
						formatter:function(BillTypeRowid,record){
							  return record.PACAdmReason;
						}
					},
					{ field: 'PACAdmReason', title: '费别', width: 20, hidden:true}
    			 ]];
	PACADMDataGrid=$('#tabPACADM').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PACADM&QueryName=GetDHCPACADMList",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"PACRowId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PACADMColumns,
		toolbar:PACADMToolBar,
		onClickRow:function(rowIndex, rowData){
			PACRowId=rowData.PACRowId
		},
		onDblClickRow:function(rowIndex,rowData){  
           if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存或取消编辑");
		        return false;
			}
			PACADMDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
       },
       onLoadSuccess:function(data){
	       editRow = undefined;
	   },
	   onBeforeLoad:function(param){
		   $('#tabPACADM').datagrid('unselectAll');
		   param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
	   }

	});
}