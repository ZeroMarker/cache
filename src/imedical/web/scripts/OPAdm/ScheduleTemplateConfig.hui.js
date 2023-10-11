var TemplateConfigDataGrid;
var editRow = undefined;
var PageLogicObj={
	PreOrderListDataGridEditRow:undefined,
	PreOrderListDataGrid:"",
	PreDiagnoseListDataGridEditRow:undefined,
	PreDiagnoseListDataGrid:""
};
$(function(){
	//初始化
	Init();
	TemplateConfigTabGridLoad();
});
function Init(){
}
function TemplateConfigTabGridLoad(){
	var PrescriptTypeToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    editRow = undefined;
	                TemplateConfigDataGrid.datagrid("rejectChanges");
	                TemplateConfigDataGrid.datagrid("unselectAll");
					RowID=""
                }
                TemplateConfigDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                TemplateConfigDataGrid.datagrid("beginEdit", 0);
                editRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = TemplateConfigDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var ID=""
                            for (var i = 0; i < rows.length; i++) {
                                ID=rows[i].RowID;
                            }
                            if (ID==""){
	                            editRow = undefined;
				                TemplateConfigDataGrid.datagrid("rejectChanges");
				                TemplateConfigDataGrid.datagrid("unselectAll");
								RowID="";
								return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
								MethodName:"delete",
								Rowid:ID
							},false); 
					        if(value=="0"){
						       TemplateConfigDataGrid.datagrid('unselectAll').datagrid('load');
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
                TemplateConfigDataGrid.datagrid("rejectChanges");
                TemplateConfigDataGrid.datagrid("unselectAll");
				RowID="";
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=TemplateConfigDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = TemplateConfigDataGrid.datagrid('getEditors', editRow);
				var Code = editors[0].target.val();
				if(Code==""){
					$.messager.alert('提示',"代码不能为空");
					return false;
				};
				var Desc=editors[1].target.val();
				if(Desc==""){
					$.messager.alert('提示',"描述不能为空");
					return false;
				};
				var Type=editors[2].target.combobox('getValue');
				if(!Type){
					$.messager.alert('提示',"类型不能为空!");
					return false;
				};
				var STCFatherCode=editors[3].target.val();
				if((STCFatherCode=="")&&(Type=="sub")){
					$.messager.alert('提示',"请填写父数据的代码");
					return false;
				};
				var STCDataTemp=editors[4].target.val();
				
				var STCDataTempDesc=editors[5].target.val();
				var STCDataTempGlobal=editors[6].target.val();
				if ((Type=="combobox-data")&&((STCDataTemp=="")||(STCDataTempDesc==""))){
					$.messager.alert('提示',"请填写完整的关联表信息");
					return false;
				}
				 var STCDataMultCheck=editors[7].target.is(':checked');
				if(STCDataMultCheck) {STCDataMultCheck="Y";} else{STCDataMultCheck="N";}
				var STCDataHospShow=editors[8].target.val();
				var Str=Code+"^"+Desc+"^"+Type+"^"+STCFatherCode+"^"+STCDataTemp+"^"+STCDataTempDesc+"^"+STCDataTempGlobal+"^"+STCDataMultCheck
				var RowID=""
				if(rows.RowID){
					RowID=rows.RowID
					 var value=$.m({ 
						ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
						MethodName:"update",
						Rowid:RowID, str:Str, STCDataHospShow:STCDataHospShow,dataType:"text"
					},false); 
					if(value==0){
					   TemplateConfigDataGrid.datagrid('unselectAll').datagrid('load');
					   $.messager.show({title:"提示",msg:"保存成功"});
					}else{
					   $.messager.alert('提示',"保存失败:"+value);
					   return ;
					}
				}else{
	                var value=$.m({ 
						ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
						MethodName:"insert",
						Str:Str,
						HospId:ServerObj.HospId,
						STCDataHospShow:STCDataHospShow,
						dataType:"text"
					},false); 
					if(value==0){
					   TemplateConfigDataGrid.datagrid('unselectAll').datagrid('load');
					   $.messager.show({title:"提示",msg:"新增成功"});
					}else{
					   $.messager.alert('提示',"新增失败:"+value);
					   return ;
					}
				}
					editRow = undefined;
			 }
			}
		}
		,{
	       text: '预缴费医嘱',
            iconCls: 'icon-write-order',
            handler: function() {
				$("#PreOrderList-dialog").dialog("open");
				InitPreOrderList()
				SessionServerListDataGridLoad("Order")
            } 
	    },{
	       text: '预开诊断',
            iconCls: 'icon-add-diag',
            handler: function() {
				$("#PreDiagnoseList-dialog").dialog("open");	
				InitOrderDiagList()
				SessionServerListDataGridLoad("Diag")  
            } 
	    }
		];
	PrescriptTypeColumns=[[    
                    { field: 'RowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'STCCode', title:'代码', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
        			{ field: 'STCDesc', title: '描述', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCType', title: '类型', width: 100, align: 'center', sortable: true,
					    editor :{  
							type:'combobox',  
							options:{
								//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetLimitType",
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"text","Desc":"文本"},{"ID":"checkbox","Desc":"勾选框"},{"ID":"combobox-sub","Desc":"下拉框关联子数据"},{"ID":"combobox-data","Desc":"下拉框关联字典表"},{"ID":"sub","Desc":"子数据"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"text","Desc":"文本"},{"ID":"checkbox","Desc":"勾选框"},{"ID":"combobox-sub","Desc":"下拉框关联子数据"},{"ID":"combobox-data","Desc":"下拉框关联字典表"},{"ID":"sub","Desc":"子数据"}]  
									return data;
								}
							  }
     					},
     					formatter:function(value,record){
				 			return record.STCTypeDesc;
				 		}
					},
					{ field: 'STCFatherCode', title: '关联父表代码', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCDataTemp', title: '关系字典表', width: 100, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCDataTempDesc', title: '关系字典表描述字段', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCDataTempGlobal', title: '关系字典表Global', width: 80,hidden:true,align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{field:'STCDataMultCheck',title:'多选框',width:100, editor : {
			                type : 'icheckbox',
			                options : {
			                    on : "是",
			                    off : '否'
			                }
			           },
			           styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
						},
						formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 		}
					},
					{ field: 'STCDataHospShow', title: '关系字典表过滤医院表达式(固定变量:ROWID,HospId)', width: 280, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
    			 ]];
	TemplateConfigDataGrid=$('#tabTemplateConfig').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.OPAdm.ScheduleTemplateConfig&QueryName=GetScheduleTemplateConfigList&HospId=",
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
			TemplateConfigDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   },
	   onBeforeLoad:function(param){
		   editRow=undefined;
		   $('#tabTemplateConfig').datagrid('unselectAll');
		   param = $.extend(param,{HospId:ServerObj.HospId});
	   }
	});
}
function InitPreOrderList(){
	 var CNMedCookArcModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	PageLogicObj.PreOrderListDataGridEditRow = undefined;
                PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                PageLogicObj.PreOrderListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PageLogicObj.PreOrderListDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.PreOrderListDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.PreOrderListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = PageLogicObj.PreOrderListDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({ 
									ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
									MethodName:"delete",
									Rowid:Rowid
								},false); 
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        SessionServerListDataGridLoad("Order")	
								}
	                        }else{
								PageLogicObj.PreOrderListDataGridEditRow = undefined;
                				PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.PreOrderListDataGridEditRow = undefined;
                PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.PreOrderListDataGridEditRow != undefined){
		            var ArcimSelRow=PageLogicObj.PreOrderListDataGrid.datagrid("selectRow",PageLogicObj.PreOrderListDataGridEditRow).datagrid("getSelected"); 
		           	var ArcimRowID=ArcimSelRow.ARCIMDR
		           	if (!ArcimRowID){
						$.messager.alert("提示","请选择医嘱!");
                        return false;
			        } 
			        var RowID=ArcimSelRow.RowID
			        var Str=""+"^"+""+"^"+"Order"+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ArcimRowID

			        if (RowID){
				        var value=$.m({ 
						ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
						MethodName:"update",
						Rowid:RowID, str:Str, STCDataHospShow:"",dataType:"text"
						},false); 
				        
				      }else{
					    var value=$.m({ 
							ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
							MethodName:"insert",
							Str:Str,
							HospId:ServerObj.HospId,
							STCDataHospShow:"",
							dataType:"text"
						},false); 
					    }
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        SessionServerListDataGridLoad("Order")	
				        PageLogicObj.PreOrderListDataGridEditRow = undefined;
                		PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");	
					}else{
						if(value=="Repeat"){
							$.messager.alert("提示","数据重复","warning");	
						}else{
							$.messager.alert("提示",value,"warning");	
						}	
					}
		        }
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var CNMedCookArcModeColumns=[[   
    				{field:'RowID',hidden:true},
					{field:'ARCIMDR',hidden:true},
					{field:'ARCITMDesc',title:'医嘱项名称', width: 20,
                    	editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								url:$URL+"?ClassName=web.DHCBL.DHCRBResource.DHCRBResourceBuilder&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'名称',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.PreOrderListDataGrid.datagrid("selectRow",PageLogicObj.PreOrderListDataGridEditRow).datagrid("getSelected");
									rows.ARCIMDR=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=PageLogicObj.PreOrderListDataGrid.datagrid("selectRow",PageLogicObj.PreOrderListDataGridEditRow).datagrid("getSelected");
									rows.ARCIMDR=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc,HospId:ServerObj.HospId});
								}
                    		}
	        			  }
					}
    			 ]];
	// 煎药方式列表Grid
	PageLogicObj.PreOrderListDataGrid=$('#PreOrderList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.PreOrderListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.PreOrderListDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.PreOrderListDataGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.PreOrderListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.PreOrderListDataGridEditRow=rowIndex;
		},onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			PageLogicObj.PreOrderListDataGridEditRow=undefined;
		}
	});
	
}


function InitOrderDiagList(){
	///煎药方式
	 var CNMedCookArcModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                PageLogicObj.PreDiagnoseListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PageLogicObj.PreDiagnoseListDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.PreDiagnoseListDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.PreDiagnoseListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = PageLogicObj.PreDiagnoseListDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                         var value=$.m({ 
									ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
									MethodName:"delete",
									Rowid:Rowid
								},false); 
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        SessionServerListDataGridLoad("Diag")	
								}
	                        }else{
								PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                				PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.PreDiagnoseListDataGridEditRow != undefined){
		            var ArcimSelRow=PageLogicObj.PreDiagnoseListDataGrid.datagrid("selectRow",PageLogicObj.PreDiagnoseListDataGridEditRow).datagrid("getSelected"); 
		           	var MRCDIADR=ArcimSelRow.MRCDIADR
		           	if (!MRCDIADR){
						$.messager.alert("提示","请选择诊断!");
                        return false;
			        } 
					var RowID=ArcimSelRow.RowID
			        var Str=""+"^"+""+"^"+"Diag"+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^^"+MRCDIADR
			        if (RowID){
				        var value=$.m({ 
						ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
						MethodName:"update",
						Rowid:RowID, str:Str, STCDataHospShow:"",dataType:"text"
						},false); 
				        
				      }else{
					    var value=$.m({ 
							ClassName:"DHCDoc.OPAdm.ScheduleTemplateConfig", 
							MethodName:"insert",
							Str:Str,
							HospId:ServerObj.HospId,
							STCDataHospShow:"",
							dataType:"text"
						},false); 
					    }
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        SessionServerListDataGridLoad("Diag")	
				        PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                		PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
					}else{
						if(value=="Repeat"){
							$.messager.alert("提示","数据重复","warning");	
						}else{
							$.messager.alert("提示",value,"warning");	
						}	
					}
		        }
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var CNMedCookArcModeColumns=[[   
    				{field:'RowID',hidden:true},
					{field:'MRCDIADR',hidden:true},
					{field:'MRCDIADesc', title:'诊断名称',width: 20,
                    	editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'HIDDEN',
	        					textField:'desc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								url:$URL+"?ClassName=web.DHCDocDiagnosEntryV8&QueryName=LookUpWithAlias",
	                            columns:[[
	                                {field:'desc',title:'名称',width:310,sortable:true},
					                {field:'HIDDEN',title:'ID',width:100,sortable:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.PreDiagnoseListDataGrid.datagrid("selectRow",PageLogicObj.PreDiagnoseListDataGridEditRow).datagrid("getSelected");
									rows.MRCDIADR=rowData.HIDDEN
								},
								onClickRow: function (rowIndex, rowData){
									var rows=PageLogicObj.PreDiagnoseListDataGrid.datagrid("selectRow",PageLogicObj.PreDiagnoseListDataGridEditRow).datagrid("getSelected");
									rows.MRCDIADR=rowData.HIDDEN
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									 var desc=param['q'];
							        if (desc=="") return false;
									var ICDType=0;
									var HospID=ServerObj.HospId,
									param = $.extend(param,{desc:desc,loc:'',ver1:"",EpisodeID:"",ICDType:ICDType,
															UserId:'',LimitRows:"",
															UseDKBFlag:'0',LocID:session['LOGON.CTLOCID'],LogHospDr:HospID});
								}
                    		}
	        			  }
					}
    			 ]];
	// 煎药方式列表Grid
	PageLogicObj.PreDiagnoseListDataGrid=$('#PreDiagnoseList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.PreDiagnoseListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.PreDiagnoseListDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.PreDiagnoseListDataGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.PreDiagnoseListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.PreDiagnoseListDataGridEditRow=rowIndex;
		},onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			PageLogicObj.PreDiagnoseListDataGridEditRow=undefined;
		}
	});
	}
function SessionServerListDataGridLoad(Type){
	if(Type=="Order"){
		 var pageSizeArr=PageLogicObj.PreOrderListDataGrid.datagrid("options").pageSize   
	}else if(Type=="Diag"){
		var pageSizeArr=PageLogicObj.PreDiagnoseListDataGrid.datagrid("options").pageSize	  
	}
	$.q({
	    ClassName : "DHCDoc.OPAdm.ScheduleTemplateConfig",
	    QueryName : "GetScheduleTemplateTypeList",
	    HospId : ServerObj.HospId,
	    Type:Type,
	    Pagerows:pageSizeArr,rows:99999
	},function(GridData){
		if(Type=="Order"){
			PageLogicObj.PreOrderListDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
		}else if(Type=="Diag"){
			PageLogicObj.PreDiagnoseListDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
		}
		
	}); 
	}
