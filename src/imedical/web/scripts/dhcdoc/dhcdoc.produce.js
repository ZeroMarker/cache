$(function(){
	InitDocProduceTab();
});
var PageLogicObj={
	DocProduceDataGrid:"",
	DocProduceGridEditRow:"",
}
function InitDocProduceTab(){
	 var DocProduceToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	PageLogicObj.DocProduceGridEditRow = undefined;
                PageLogicObj.DocProduceDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                PageLogicObj.DocProduceDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PageLogicObj.DocProduceDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.DocProduceGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.DocProduceDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = PageLogicObj.DocProduceDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DocProduce",
									MethodName:"Delect",
								   	RowID:Rowid
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadDocProduceGrid()	
								}
	                        }else{
								PageLogicObj.DocProduceGridEditRow = undefined;
                				PageLogicObj.DocProduceDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
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
                PageLogicObj.DocProduceGridEditRow = undefined;
                PageLogicObj.DocProduceDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.DocProduceGridEditRow != undefined){
		            var DocProduceDataRow=PageLogicObj.DocProduceDataGrid.datagrid("selectRow",PageLogicObj.DocProduceGridEditRow).datagrid("getSelected"); 
		           	var RowID=DocProduceDataRow.RowID
		           	if (RowID==undefined) RowID=""
			        var editors = PageLogicObj.DocProduceDataGrid.datagrid('getEditors', PageLogicObj.DocProduceGridEditRow);
			        var ProcduceCode=editors[0].target.val()
			        var ProcduceDesc=editors[1].target.val()
			        if (ProcduceCode==""){
				        $.messager.alert("提示","请填写代码","warning");
				        return false
				        }
				    if (ProcduceDesc==""){
				        $.messager.alert("提示","请填写描述","warning");
				        return false
				        }
			        var ProcduceActive=editors[2].target.is(':checked');
					if(ProcduceActive) ProcduceActive="Y";
					else  ProcduceActive="N";
					var ProcduceShowCode=editors[3].target.val()
			        var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.DocProduce",
						MethodName:"Insert",
					   	RowID :RowID, ProduceCode :ProcduceCode, ProduceDesc :ProcduceDesc, 
					   	ProduceActive:ProcduceActive,ProcduceShowCode:ProcduceShowCode
					},false);
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        LoadDocProduceGrid()			
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
    var DocProduceColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
        			{ field: 'ProcduceCode', title: '产品线代码', width: 120,editor : {type : 'text',options : {}}},
        			{ field: 'ProcduceDesc', title: '产品线描述', width: 200,editor : {type : 'text',options : {}}},
        			{ field: 'ProcduceActive', title: '激活', width:55,align:'center',
		                styler: function(value,row,index){
		                    if (value=="Y"){return 'color:#21ba45;'}else{return 'color:#f16e57;'}
		                },
		                formatter:function(value,record){
			                if (value=="Y"){return '是'}else{return '否'}
		                },
		                editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : 'N'
                                }
                       },
		           },
		           { field: 'ProcduceShowCode', title: '产品线模块展示代码', width: 200,editor : {type : 'text',options : {}}}
					
    			 ]];
	// 煎药方式列表Grid
	PageLogicObj.DocProduceDataGrid=$('#DocProduceTab').datagrid({  
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
		columns :DocProduceColumns,
		toolbar :DocProduceToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.DocProduceDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.DocProduceDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.DocProduceGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.DocProduceDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.DocProduceGridEditRow=rowIndex;
		}
	});
	LoadDocProduceGrid()
	
}
function LoadDocProduceGrid(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DocProduce",
	    QueryName : "FindDocProduce",
	    Pagerows:PageLogicObj.DocProduceDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.DocProduceDataGrid.datagrid('loadData',GridData);
		PageLogicObj.DocProduceGridEditRow=undefined
		PageLogicObj.DocProduceDataGrid.datagrid("clearSelections")
	})
}