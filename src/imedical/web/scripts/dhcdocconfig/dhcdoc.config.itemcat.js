var editRow=undefined;
var ItemCatDataGrid;
$(function(){ 
	 InitItemCatGrid();
});
function InitItemCatGrid()
{
	var ItemCatToolBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
			  if(editRow==undefined){
				  return false;
			  }
              //var rows = ItemCatDataGrid.datagrid("getRows"); 
              var rows=ItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
			  var OpenForAllHosp=0;
			  var StopOrderDiscExec=0;
			  var ARCICRowId="";
			  if(rows.ARCICRowId){
				  ARCICRowId=rows.ARCICRowId
			  }
			  var rows = ItemCatDataGrid.datagrid("getRows");
                //选择要删除的行  
               if (rows.length > 0)
               { 	
		         for (var i = 0; i < rows.length; i++) {
					if(editRow==i){
						//ARCICRowId=rows[i].ARCICRowId
						var editors = ItemCatDataGrid.datagrid('getEditors', editRow); 
						var selected=editors[0].target.is(':checked');
						if(selected) OpenForAllHosp="1";
						var LimitStartTime=editors[1].target.val();
						var time=/^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/ 
						if ((time.test(LimitStartTime) != true)&&(LimitStartTime!="")) {
						$.messager.alert("提示", "本日截止时间格式不正确,正确格式为:12:00:00", "error");
						return false;
						}
						var FrequenceRowId=editors[2].target.combobox('getValue');
						var selected=editors[3].target.is(':checked');
						if(selected) StopOrderDiscExec="1";
					}
                 } 
					  
				  var DHCFieldNumStr="1^2^3^4";
				  var ValStr=OpenForAllHosp+"^"+LimitStartTime+"^"+FrequenceRowId+"^"+StopOrderDiscExec;
                	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.ItemCat","SetDHCARCItemCatFieldValue","false",function testget(value){
						if(value=="0"){
							ItemCatDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							ItemCatDataGrid.datagrid('load');
           					ItemCatDataGrid.datagrid('unselectAll');
        					$.messager.show({title:"提示",msg:"保存成功"});
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow = undefined;
						},"","",ARCICRowId,DHCFieldNumStr,ValStr);
            	
            
             }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                ItemCatDataGrid.datagrid("rejectChanges");
                ItemCatDataGrid.datagrid("unselectAll");
            }
        }];
	ItemCatColumns=[[    
                    { field: 'ARCICRowId', title: 'LocRowID', width: 1, align: 'center', sortable: true,hidden:true
					},
        			{ field: 'ARCICDesc', title: '子类', width: 200, align: 'center', sortable: true
					},
					{ field: 'OpenForAllHosp', title: '允许跨院', width: 50, align: 'center', sortable: true,
					   editor : {
                                type : 'checkbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					},
					{ field: 'LimitStartTime', title: '本日医嘱截止时间', width: 100, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'FrequenceRowId', title: '默认频次', width: 100, align: 'center', sortable: true,
					  editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'FreqRowId',
								textField:'FreqCode',
								required:false,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.SubCatContral";
									param.QueryName = "FindFreqList";
						            param.Arg1 ="";
						            param.ArgCnt =1;
								}
							  }
     					  },
						  formatter:function(value, record){
							  return record.FrequenceDesc;
						  }
					},
					{ field: 'FrequenceDesc', title: '', width: 150, align: 'center', sortable: true,hidden:true
					},
					{ field: 'StopOrderDiscExec', title: '停医嘱自动停执行记录', width: 50, align: 'center', sortable: true,
					   editor : {
                                type : 'checkbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					}
    			 ]];
	ItemCatDataGrid=$('#tabItemCat').datagrid({  
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
		idField:"ARCICRowId",
		pageList : [15,50,100,200],
		columns :ItemCatColumns,
		toolbar :ItemCatToolBar,
		onClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			ItemCatDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		}
	});
	LoadItemCatDataGrid();
};
function LoadItemCatDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.ItemCat';
	queryParams.QueryName ='GetItemCatList';
	queryParams.ArgCnt =0;
	var opts = ItemCatDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	ItemCatDataGrid.datagrid('load', queryParams);
};
