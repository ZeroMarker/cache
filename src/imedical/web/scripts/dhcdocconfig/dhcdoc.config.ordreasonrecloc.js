var AdmReasonDataGrid;
var RecLocDataGrid;
var editRow=undefined;
var AdmReason="";
$(function(){ 
  InitAdmReasonList();
  InitRecLoc();
});
function InitRecLoc()
{
	var RecLocToolBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
			if(AdmReason==""){
				$.messager.alert('提示',"请先选择费别");
				return false;
			};
              var rows = RecLocDataGrid.datagrid("getRows"); //datagrid("getSelections");
			  var CTLOCRowIDStr="";
                //选择要删除的行  
               if (rows.length > 0)
               { 	
		         for (var i = 0; i < rows.length; i++) {
					if(editRow==i){
						selected="N";
						var editors = RecLocDataGrid.datagrid('getEditors', editRow); 
						selected=editors[0].target.is(':checked');
						if(selected) selected="Y"
					}else{
						selected=rows[i].selected
					}
				    if(selected=="Y"){
						if(CTLOCRowIDStr=="") CTLOCRowIDStr=rows[i].CTLOCRowID;
						else  CTLOCRowIDStr=CTLOCRowIDStr+"^"+rows[i].CTLOCRowID
					}
                 } 
                	$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig1","false",function testget(value){
						if(value=="0"){
							RecLocDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							RecLocDataGrid.datagrid('load');
           					RecLocDataGrid.datagrid('unselectAll');        					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow = undefined;
						},"","","OrdReasonRecLoc",AdmReason,CTLOCRowIDStr);
            	
            
             }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                RecLocDataGrid.datagrid("rejectChanges");
                RecLocDataGrid.datagrid("unselectAll");
            }
        }];
	RecLocColumns=[[    
                    { field: 'CTLOCRowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					},
        			{ field: 'CTLOCDesc', title: '名称', width: 50, align: 'center', sortable: true
					},
					{ field: 'selected', title: '选择', width: 50, align: 'center', sortable: true,
					   editor : {
                                type : 'checkbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					}
    			 ]];
	RecLocDataGrid=$('#tabRecLoc').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"CTLOCRowID",
		columns :RecLocColumns,
		toolbar :RecLocToolBar,
		onClickRow:function(rowIndex, rowData){
            if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			RecLocDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		}
	});
	LoadRecLocDataGrid();
};
function LoadRecLocDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.OrdReasonRecLoc';
	queryParams.QueryName ='FindDep';
	queryParams.Arg1 =AdmReason;
	queryParams.Arg2 ="OrdReasonRecLoc";
	queryParams.ArgCnt =2;
	var opts = RecLocDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	RecLocDataGrid.datagrid('load', queryParams);
};
function InitAdmReasonList(){
	AdmReasonColumns=[[    
                    { field: 'BillTypeRowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					},
        			{ field: 'BillTypeDesc', title: '名称', width: 50, align: 'center', sortable: true
					}
    			 ]];
	AdmReasonDataGrid=$('#tabReason').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"BillTypeRowid",
		//pageList : [15,50,100,200],
		columns :AdmReasonColumns,
		onClickRow:function(rowIndex, rowData){
		   editRow=undefined;
		   AdmReason=rowData.BillTypeRowid
           LoadRecLocDataGrid();
		}
	});
	LoadAdmReasonDataGrid();
};
function LoadAdmReasonDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.OrdReasonRecLoc';
	queryParams.QueryName ='FindBillType';
	queryParams.ArgCnt =0;
	var opts = AdmReasonDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	AdmReasonDataGrid.datagrid('load', queryParams);
};