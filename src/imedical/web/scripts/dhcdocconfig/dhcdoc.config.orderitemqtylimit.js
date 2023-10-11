var OrderItemQtyLimitDataGrid;
var editRow = undefined;
var PACRowId="";
var RowBillType="";
$(function(){ 
  InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_PAADMPrescType");
	hospComp.jdata.options.onSelect = function(e,t){
		editRow = undefined;
		$('#tabOrderItemQtyLimit').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitOrderItemQtyLimit();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitOrderItemQtyLimit()
{
	var OrderItemQtyLimitToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                editRow = undefined;
				RowBillType="";
                OrderItemQtyLimitDataGrid.datagrid("rejectChanges");
            
			    OrderItemQtyLimitDataGrid.datagrid('unselectAll');
                if (editRow != undefined) {
					OrderItemQtyLimitDataGrid.datagrid("endEdit", editRow);
                }
				OrderItemQtyLimitDataGrid.datagrid("insertRow", {
					index: 0,
					row: {}
				});
				OrderItemQtyLimitDataGrid.datagrid("beginEdit", 0);
				editRow = 0;
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = OrderItemQtyLimitDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].AILRowid);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow = undefined;
								RowBillType="";
				                OrderItemQtyLimitDataGrid.datagrid("rejectChanges");
				                OrderItemQtyLimitDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.OrderItemQtyLimit", 
								MethodName:"delete",
								Rowid:ID
							},false);
					        if(value=="0"){
							   RowBillType="";
						       OrderItemQtyLimitDataGrid.datagrid('load');
       					       OrderItemQtyLimitDataGrid.datagrid('unselectAll');
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
                editRow = undefined;
				RowBillType="";
                OrderItemQtyLimitDataGrid.datagrid("rejectChanges");
                OrderItemQtyLimitDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var Rowid="";
				var rows = OrderItemQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				if (rows){
					Rowid=rows.AILRowid;
				} 
				var editors = OrderItemQtyLimitDataGrid.datagrid('getEditors', editRow);
				var BillType = editors[0].target.combobox('getValue');
				if(!BillType){
					$.messager.alert('提示',"请选择收费类别!");
					return false;
				};
				var PAADMType = editors[1].target.combobox('getValue');
				if(!PAADMType){
					$.messager.alert('提示',"请选择就诊类型!");
					return false;
				};
				var PrescType = editors[2].target.combobox('getValue');
				if(!PrescType){
					$.messager.alert('提示',"请选择处方类型!");
					return false;
				};
				var Default=editors[3].target.is(':checked');
				if(Default) Default="Y";
				else  Default="N";
				var Str=PAADMType+"^"+BillType+"^"+PrescType+"^"+""+"^"+""+"^"+""+"^"+""+"^"+Default;
				if(Rowid){
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.OrderItemQtyLimit", 
						MethodName:"update",
						Rowid:rows.AILRowid,
						Str:Str
					},false);
			        if(value==0){
				       OrderItemQtyLimitDataGrid.datagrid('load');
				       OrderItemQtyLimitDataGrid.datagrid('unselectAll');
				       $.messager.show({title:"提示",msg:"保存成功"});
			        }else if(value=="-1"){
						$.messager.alert('提示',"不能修改,该记录已经存在:"+value);
						return false;
					}else{
				       $.messager.alert('提示',"保存失败:"+value);
					   return false;
			        }
			        editRow = undefined;
				}else{
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.OrderItemQtyLimit", 
						MethodName:"insert",
						Str:Str,
						HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
			        if(value==0){
				       OrderItemQtyLimitDataGrid.datagrid('load');
				       OrderItemQtyLimitDataGrid.datagrid('unselectAll');
				       $.messager.show({title:"提示",msg:"保存成功"});
			        }else if(value=="-1"){
						$.messager.alert('提示',"不能增加,该记录已经存在:"+value);
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
	OrderItemQtyLimitColumns=[[    
                    { field: 'AILRowid', title: 'ID', width: 1,  sortable: true,hidden:true
					}, 
					{ field: 'BillType', title:'收费类别', width: 20,  sortable: true,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.OrderItemQtyLimit&QueryName=FindBillTypeConfig&value="+"&rows=9999",
								valueField:'BillTypeRowid',
								textField:'BillTypeDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
									$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					},
						formatter:function(BillTypeRowid,record){
							  return record.BillTypeDesc;
						}
					},
        			{ field: 'BillTypeDesc', title: '收费类别', width: 20,  sortable: true,hidden:true  
					},
					{ field: 'PAADMType', title: '就诊类型', width: 20, 
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PALocAmount&QueryName=GetPAAdmTypeList",
								valueField:'PAADMType',
								textField:'PAAdmTypeDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								}
							  }
     					},
						formatter:function(PAADMType,record){
							  return record.PAADMTypeDesc;
						}
					},
					{ field: 'PAADMTypeDesc', title: '就诊类型', width: 20, 
					  hidden:true
					},
					{ field: 'PrescType', title: '处方类型', width: 20, 
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetPrescriptTypeList"+"&rows=9999",
								valueField:'PTRowid',
								textField:'PTDescription',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
									$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					  },
						  formatter:function(PTRowid,record){
							return record.PrescTypeDesc;
						}
					},
					{ field: 'PrescTypeDesc', title: '处方类型', width: 20, 
					  hidden:true
					},
					{ field: 'Default', title: '默认', width: 20, 
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					}
					
    			 ]];
	OrderItemQtyLimitDataGrid=$('#tabOrderItemQtyLimit').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.OrderItemQtyLimit&QueryName=GetPAADMPrescTypeList",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"AILRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :OrderItemQtyLimitColumns,
		toolbar:OrderItemQtyLimitToolBar,
		onClickRow:function(rowIndex, rowData){
			RowBillType=rowData.BillType
		},
		onDblClickRow:function(rowIndex, rowData){   
          if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存或取消编辑", "error");
		        return false;
			}
			OrderItemQtyLimitDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
			RowBillType=rowData.BillType
       },
       onLoadSuccess:function(data){
	       editRow = undefined;
	       RowBillType="";
	   },
	   onBeforeLoad:function(param){
		   $('#tabOrderItemQtyLimit').datagrid('unselectAll');
		   param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
	   }
	});
}