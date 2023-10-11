var OutPatientListConfigDataGrid;
var editRow = undefined;
$(function(){
	//初始化
	Init();
	OutPatientListConfigTabGridLoad();
});
function Init(){
	if (ServerObj.ExaBoroughDesc!=""){
		 $("#configtitle").html(ServerObj.ExaBoroughDesc)
		}else{
			$("#configtitle").html("全院")
			$("#configtitle").css("color","red")
			}
	}
function OutPatientListConfigTabGridLoad(){
	var PrescriptTypeToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    editRow = undefined;
	                OutPatientListConfigDataGrid.datagrid("rejectChanges");
	                OutPatientListConfigDataGrid.datagrid("unselectAll");
					RowID=""
                }
                OutPatientListConfigDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                OutPatientListConfigDataGrid.datagrid("beginEdit", 0);
                editRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = OutPatientListConfigDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RowID);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow = undefined;
				                OutPatientListConfigDataGrid.datagrid("rejectChanges");
				                OutPatientListConfigDataGrid.datagrid("unselectAll");
								RowID="";
								return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.OPDoc.PatientListConfig", 
								MethodName:"Delete",
								RowID:ID
							},false); 
					        if(value=="0"){
						       OutPatientListConfigDataGrid.datagrid('load');
       					       OutPatientListConfigDataGrid.datagrid('unselectAll');
							   RowID="";
       					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
						       return false;
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
                OutPatientListConfigDataGrid.datagrid("rejectChanges");
                OutPatientListConfigDataGrid.datagrid("unselectAll");
				RowID=""
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=OutPatientListConfigDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = OutPatientListConfigDataGrid.datagrid('getEditors', editRow);
				var DocPatientDesc = editors[0].target.val();
				if(DocPatientDesc==""){
					$.messager.alert('提示',"名称不能为空");
					return false;
				};
				var DocPatientPorio=editors[1].target.val();
				if(DocPatientPorio==""){
					$.messager.alert('提示',"排队优先级不能为空");
					return false;
				};
				var DocPatientStatusPorio=editors[2].target.val();
				if(DocPatientStatusPorio==""){
					$.messager.alert('提示',"状态优先级不能为空");
					return false;
				};
				var DocPatientSeries=editors[3].target.val();
				if(DocPatientSeries==""){
					$.messager.alert('提示',"连续数不能为空");
					return false;
				};
				var DocPatientFunction=editors[4].target.val();
				if(DocPatientFunction==""){
					$.messager.alert('提示',"表达式不能为空");
					return false;
				};
				var RowID=""
				if(rows.RowID){RowID=rows.RowID}
	                var value=$.m({ 
						ClassName:"DHCDoc.OPDoc.PatientListConfig", 
						MethodName:"Insert",
						RowID:RowID, Desc:DocPatientDesc, Porio:DocPatientPorio, 
						Series:DocPatientSeries, ExaBorough:ServerObj.ExaBoroughID, HospDr:ServerObj.HospId, 
						DocPatientFunction:DocPatientFunction,DocPatientStatusPorio:DocPatientStatusPorio,
						dataType:"text"
					},false); 
					if(value==0){
					   OutPatientListConfigDataGrid.datagrid('load');
					   OutPatientListConfigDataGrid.datagrid('unselectAll');
					   $.messager.show({title:"提示",msg:"保存成功"});
					}else{
					   $.messager.alert('提示',"保存失败:"+value);
					   return ;
					}
					editRow = undefined;
				
			 }
			}
		}];
	PrescriptTypeColumns=[[    
                    { field: 'RowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DocPatientDesc', title:'状态名称', width: 30, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
        			{ field: 'DocPatientPorio', title: '排队优先级', width: 20, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'DocPatientStatusPorio', title: '状态优先级', width: 20, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'DocPatientSeries', title: '连续数', width: 20, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'DocPatientFunction', title: '表达式', width: 200, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					
					
    			 ]];
	OutPatientListConfigDataGrid=$('#OutPatientListConfigTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.OPDoc.PatientListConfig&QueryName=GetPatientListConfigList&HospId=&ExaBorough=",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PrescriptTypeColumns,
		toolbar:PrescriptTypeToolBar,
		onClickRow:function(rowIndex, rowData){
			RowID=rowData.RowID
		},
		onDblClickRow:function(rowIndex, rowData){ 
		    RowID=rowData.RowID 
            if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			OutPatientListConfigDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   },
	   onBeforeLoad:function(param){
		   $('#OutPatientListConfigTab').datagrid('unselectAll');
		   param = $.extend(param,{HospId:ServerObj.HospId,ExaBorough:ServerObj.ExaBoroughID});
	   }
	});
	}