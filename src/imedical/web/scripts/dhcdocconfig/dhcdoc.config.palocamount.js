var editRow = undefined;
var PALocAmountDataGrid;
$(function(){
	InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_PALocAmount");
	hospComp.jdata.options.onSelect = function(e,t){
		PALocAmountDataGrid.datagrid("unselectAll");
		InitPALocAmountGrid();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPALocAmountGrid();
	}
}
function InitPALocAmountGrid()
{
	var PALocAmountToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
               PALocAmountDataGrid.datagrid('unselectAll');
                if (editRow == undefined) {
					//PALocAmountDataGrid.datagrid("endEdit", editRow);
					PALocAmountDataGrid.datagrid("insertRow", {
	                    index: 0,
	                    row: {}
	                });
	                PALocAmountDataGrid.datagrid("beginEdit", 0);
	                editRow = 0;
                }
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PALocAmountDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].PLARowid);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                             editRow = undefined;
				                PALocAmountDataGrid.datagrid("rejectChanges");
				                PALocAmountDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.PALocAmount", 
								MethodName:"delete",
								Rowid:ID
							},false);
					        if(value=="0"){
						       PALocAmountDataGrid.datagrid('load');
       					       PALocAmountDataGrid.datagrid('unselectAll');
       					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
					        }
					        editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var editors = PALocAmountDataGrid.datagrid('getEditors', editRow);
				var PatientType = editors[0].target.combobox('getValue');
				if(!PatientType){
					$.messager.alert('提示',"请选择患者类型");
					return false;
				};
				var PAADMType=editors[1].target.combobox('getValue');
				if(!PAADMType){
					$.messager.alert('提示',"请选择就诊类型");
					return false;
				};
				var rows = PALocAmountDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var Loc=rows.LocDr; //editors[2].target.combobox('getValue');
				if(!Loc){
					$.messager.alert('提示',"请选择科室");
					return false;
				};
				var AllowAmount=$.trim(editors[3].target.val());
				if(AllowAmount==""){
					$.messager.alert('提示',"金额不能为空且为数字");
					return false;
				};
				if (AllowAmount!=""){
					if (isNaN(Number(AllowAmount))==true){
						$.messager.alert("提示", "金额请填写数字!");
		        		return false;
					}
					if (AllowAmount<0) {
						$.messager.alert("提示", "金额不能为负!");
		        		return false;
					}
				}
				var rows=PALocAmountDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var PLARowid="";
				if(rows.PLARowid){
					PLARowid=rows.PLARowid
				}
				var str=PLARowid+","+PatientType+","+PAADMType+","+Loc+","+AllowAmount;
				//alert(PLARowid+","+PatientType+","+PAADMType+","+Loc+","+AllowAmount)
				var value=$.m({ 
					ClassName:"DHCDoc.DHCDocConfig.PALocAmount", 
					MethodName:"save",
					str:str
				},false);
		        if(value==0){
			       PALocAmountDataGrid.datagrid('load');
			       PALocAmountDataGrid.datagrid('unselectAll');
			       $.messager.show({title:"提示",msg:"保存成功"});
		        }else if(value=="-1"){
					$.messager.alert('提示',"不能增加或修改,该记录已存在!");
			        return false;
				}else{
			       $.messager.alert('提示',"保存失败:"+value);
		        }
		        editRow = undefined;
			 }else{
				 $.messager.alert('提示',"没有需要保存的数据!");
			 }
			}
		},{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                PALocAmountDataGrid.datagrid("rejectChanges");
                PALocAmountDataGrid.datagrid("unselectAll");
            }
        }];
	PALocAmountColumns=[[ 
	                { field: 'PLARowid', title: 'ID', width: 10, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'PatientType', title: '病人类型', width: 150,
					   hidden:true
					},
					{ field: 'PatientTypeDR', title: '病人类型', width: 130,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PALocAmount&QueryName=GetSocialList",
								valueField:'SSRowId',
								textField:'SSDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
									param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					  },
						  formatter:function(SSRowId,record){
							  return record.PatientType;
						  }
					},
					
					{ field: 'PAADMTypeDr', title: '就诊类型',  width: 100,
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
						formatter:function(SSRowId,record){
							  return record.PAADMType;
						  }
					},
					{ field: 'PAADMType', title: '就诊类型', width: 10,
					   hidden:true
					},
					{ field: 'LocDesc', title: '科室', width: 200,	
						editor :{
							type:'combobox',  
							options:{
								mode:"remote",
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrRecloc&QueryName=GetOrdDep&desc=&rows=99999",
								valueField:'CTLOCRowID',
								textField:'CTLOCDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
						            if (param['q']) {
										var desc=param['q'];
									}else{
										var desc="";
									}
									param = $.extend(param,{desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								},
								onSelect:function(rec){
									var rows=PALocAmountDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.LocDr=rec.CTLOCRowID;
								},
								onChange:function(newValue, oldValue){
									if (newValue==""){
										var rows=PALocAmountDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    rows.LocDr="";
									}
								},
								onHidePanel:function(){
									var rows=PALocAmountDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									if (!$.isNumeric($(this).combobox('getValue'))) return;
									rows.LocDr=$(this).combobox('getValue');
								}
							  }
						}			   
					},
					{ field: 'LocDr', title: '科室',  width: 200,hidden:true},
					{ field: 'AllowAmount', title: '金额', width: 90,
					  editor : {type : 'validatebox',options : {required:true}}
					}
    			 ]];
	PALocAmountDataGrid=$('#tabPALocAmount').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PALocAmount&QueryName=GetPALocAmount&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"PLARowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PALocAmountColumns,
		toolbar:PALocAmountToolBar,
		onDblClickRow:function(rowIndex,rowData){  
           if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存或取消编辑", "error");
		        return false;
			}
			PALocAmountDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   }
	});
};
