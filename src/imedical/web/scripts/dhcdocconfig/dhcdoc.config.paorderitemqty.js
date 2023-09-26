var PAOrderItemQtyGrid;
var editRow=undefined;
$(function(){
    //初始化病人类型
	InitComboPatientType("SSDBCombo_PatientType");
	//初始化就诊类型
	InitComboPaadmType("SSDBCombo_PaadmType");
	//初始化收费项目大类
	InitComboSII("SSDBCombo_SII");
	InittabPAOrderItemQty();
	$("#BFind").click(function(){
		 loadPAOrderItemQtyGrid();
     });
	
})
function InitComboPatientType(param1)
{
	$("#"+param1+"").combobox({      
    	valueField:'SSRowId',   
    	textField:'SSDesc',
    	url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.PACADM';
						param.QueryName = 'GetCTSocialstatusList';
						param.ArgCnt =0;
		}  
	});
}
function InitComboPaadmType(param1)
{								
	$("#"+param1+"").combobox({      
    	valueField:'PAADMType',   
    	textField:'PAAdmTypeDesc',
    	url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.PALocAmount';
						param.QueryName = 'GetPAAdmTypeList';
						param.ArgCnt =0;
		}  
	});
}
function InitComboSII(param1)
{
	$("#"+param1+"").combobox({      
    	valueField:'TARCRowId',   
    	textField:'TARCDesc',
    	url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.PAOrderItemQty';
						param.QueryName = 'GetTarCateList';
						param.ArgCnt =0;
		}  
	});
}
function InittabPAOrderItemQty()
{
	var PADiagnoseDurationBar = [{
	text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
			    PAOrderItemQtyGrid.datagrid('unselectAll');
                if (editRow != undefined) {
					PAOrderItemQtyGrid.datagrid("endEdit", editRow);
                }
				PAOrderItemQtyGrid.datagrid("insertRow", {
					index: 0,
					row: {

					}
				});
				PAOrderItemQtyGrid.datagrid("beginEdit", 0);
				editRow = 0;
              
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = PAOrderItemQtyGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].PITRowid);
                            }
                            var PITRowid=ids.join(',')
                            $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.PAOrderItemQty","delete","false",function testget(value){
								if(value=="0"){
									PAOrderItemQtyGrid.datagrid('load');
									PAOrderItemQtyGrid.datagrid('unselectAll');
									$.messager.show({title:"提示",msg:"删除成功"});
								}else{
									$.messager.alert('提示',"删除失败:"+value);
								}
						      editRow = undefined;
						},"","",PITRowid);
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
               //var rows = PAOrderItemQtyGrid.datagrid("getSelected");     
               if (editRow != undefined)
                {
					if(editRow==0) PAOrderItemQtyGrid.datagrid("unselectAll");
                	var editors = PAOrderItemQtyGrid.datagrid('getEditors', editRow);  				
					var PatientType =  editors[0].target.combobox('getValue');
					if(PatientType==""){
						$.messager.alert("提示", "请选择病人类型!", "error");
						return false;
					}
					var PAADMType =  editors[1].target.combobox('getValue');
					if(PAADMType==""){
						$.messager.alert("提示", "请选择就诊类型!", "error");
						return false;
					}
					var SIIRowid =  editors[2].target.combobox('getValue');
					if(SIIRowid==""){
						$.messager.alert("提示", "请选择收费分类!", "error");
						return false;
					}
	                var AllowQty=editors[3].target.val();
					if(AllowQty==""){
						$.messager.alert("提示", "请输入限制数量!", "error");
						return false;
					}
					var LimitType =  editors[4].target.combobox('getValue');
					if(LimitType==""){
						$.messager.alert("提示", "请选择限制类型!", "error");
						return false;
					}
					var Str=PatientType+"!"+PAADMType+"!"+SIIRowid+"!"+AllowQty+"!"+LimitType;
					var PITRowid="";
					var rows=PAOrderItemQtyGrid.datagrid("selectRow",editRow).datagrid("getSelected")
					if(rows.PITRowid){
						var PITRowid=rows.PITRowid
					}
					var rows1 = PAOrderItemQtyGrid.datagrid("getRows");	
						$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.PAOrderItemQty","save","false",function testget(value){
							if(value==0){
								PAOrderItemQtyGrid.datagrid("endEdit", editRow);
								editRow = undefined;
								PAOrderItemQtyGrid.datagrid('load');
								PAOrderItemQtyGrid.datagrid('unselectAll'); 
                                $.messager.show({title:"提示",msg:"保存成功"});								
							}else if(value=="-1"){
								$.messager.alert('提示',"不能增加或修改,该记录已存在:"+value);
								return false;
							}else{
								$.messager.alert('提示',"保存失败:"+value);
								return false;
							}
						    editRow = undefined;
						},"","",PITRowid,Str);
                	
			}
		  }
            
             
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow = undefined;
                PAOrderItemQtyGrid.datagrid("rejectChanges");
                PAOrderItemQtyGrid.datagrid("unselectAll");
            }
        }];
    var PADiagnoseDurationColumns=[[    
	                { field : 'PITRowid',title : '',width : 1,hidden:true  
                    },
					{ field: 'PatientTypeDR', title: '病人类型', width: 50, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'SSRowId',
								textField:'SSDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.PACADM";
									param.QueryName = "GetCTSocialstatusList";
						            param.ArgCnt =0;
								}
							  }
     					},
						formatter:function(value,record){
							  return record.PatientType;
						}
        			},
					{ field : 'PatientType',title : '',width : 10 , align: 'center', sortable: true, hidden: true 
                    },
        			{ field: 'PAADMType', title: '就诊类型', width: 50, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'PAADMType',
								textField:'PAAdmTypeDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.PALocAmount";
									param.QueryName = "GetPAAdmTypeList";
						            param.ArgCnt =0;
								}
							  }
     					},
						formatter:function(value,record){
							  return record.PAADMTypeDesc;
						}
        			},
					{ field : 'PAADMTypeDesc',title : '',width : 10 , align: 'center', sortable: true, hidden: true 
                    },
        			{ field: 'PITSIIDR', title: '收费项目分类', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'TARCRowId',
								textField:'TARCDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.PAOrderItemQty";
									param.QueryName = "GetTarCateList";
									//param.Arg1 ="";
						            param.ArgCnt =0;
								}
							  }
     					  },
						formatter:function(value,record){
							  return record.TARCDesc;
						}
        			},
					{ field : 'TARCDesc',title : '',width : 10 , align: 'center', sortable: true, hidden: true 
                    },
					{ field: 'PITAllowQty', title: '允许医嘱数目', width: 50, align: 'center', sortable: true, resizable: true,
					  editor : {
                        type : 'text'
					  }
					},
					{ field : 'PITlimitType',title : '限制类型',width : 100 , align: 'center', sortable: true ,resizable: true,
					  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'PTLimitType',
								textField:'PTLimitTypeDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.PrescriptType";
									param.QueryName = "GetLimitType";
						            param.ArgCnt =0;
								}
							  }
     					  },
						formatter:function(value,record){
							  return record.PITlimitTypeDesc;
						}
                    },
					{ field: 'PITlimitTypeDesc', title: '1', width: 100, align: 'center',hidden:true
					}				
    			 ]];
	PAOrderItemQtyGrid=$("#tabPAOrderItemQty").datagrid({  
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
		idField:"PITRowid",
		pageList : [15,50,100,200],
		columns :PADiagnoseDurationColumns,
    	toolbar :PADiagnoseDurationBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			PAOrderItemQtyGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		}
	});
	loadPAOrderItemQtyGrid();
}
function loadPAOrderItemQtyGrid()
{
	var PatientType = $('#SSDBCombo_PatientType').combo('getValue'); 
	var PaadmType = $('#SSDBCombo_PaadmType').combo('getValue');
	var SIIRowid = $('#SSDBCombo_SII').combo('getValue');
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.PAOrderItemQty';
	queryParams.QueryName ='GetPAOrderItemQtyList';
	queryParams.Arg1 =PatientType;
	queryParams.Arg2 =PaadmType;
	queryParams.Arg3 =SIIRowid;
	queryParams.ArgCnt =3;
	var opts = PAOrderItemQtyGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL
	PAOrderItemQtyGrid.datagrid('clearSelections');
	PAOrderItemQtyGrid.datagrid('loadData', { total: 0, rows: [] });
	PAOrderItemQtyGrid.datagrid('load', queryParams);
};