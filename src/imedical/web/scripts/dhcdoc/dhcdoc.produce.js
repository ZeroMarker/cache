$(function(){
	InitDocProduceTab();
});
var PageLogicObj={
	DocProduceDataGrid:"",
	DocProduceGridEditRow:"",
}
function InitDocProduceTab(){
	 var DocProduceToolBar = [{
            text: '����',
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
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.DocProduceDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        LoadDocProduceGrid()	
								}
	                        }else{
								PageLogicObj.DocProduceGridEditRow = undefined;
                				PageLogicObj.DocProduceDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                PageLogicObj.DocProduceGridEditRow = undefined;
                PageLogicObj.DocProduceDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '����',
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
				        $.messager.alert("��ʾ","����д����","warning");
				        return false
				        }
				    if (ProcduceDesc==""){
				        $.messager.alert("��ʾ","����д����","warning");
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
						$.messager.popover({msg: '����ɹ�',type:'success'});
				        LoadDocProduceGrid()			
					}else{
						if(value=="Repeat"){
							$.messager.alert("��ʾ","�����ظ�","warning");	
						}else{
							$.messager.alert("��ʾ",value,"warning");	
						}	
					}
		        }
			}
		}];
    var DocProduceColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
        			{ field: 'ProcduceCode', title: '��Ʒ�ߴ���', width: 120,editor : {type : 'text',options : {}}},
        			{ field: 'ProcduceDesc', title: '��Ʒ������', width: 200,editor : {type : 'text',options : {}}},
        			{ field: 'ProcduceActive', title: '����', width:55,align:'center',
		                styler: function(value,row,index){
		                    if (value=="Y"){return 'color:#21ba45;'}else{return 'color:#f16e57;'}
		                },
		                formatter:function(value,record){
			                if (value=="Y"){return '��'}else{return '��'}
		                },
		                editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : 'N'
                                }
                       },
		           },
		           { field: 'ProcduceShowCode', title: '��Ʒ��ģ��չʾ����', width: 200,editor : {type : 'text',options : {}}}
					
    			 ]];
	// ��ҩ��ʽ�б�Grid
	PageLogicObj.DocProduceDataGrid=$('#DocProduceTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false,  //�Ƿ��ҳ
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
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
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