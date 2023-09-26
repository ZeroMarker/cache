
    var editRow = undefined; //定义全局变量：当前编辑的行
    var cureItemDataGrid; //定义全局变量datagrid
$(function(){
	///治疗项目列表columns
	var cureItemToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
                if (editRow != undefined) {
                    //locDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    cureItemDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    cureItemDataGrid.datagrid("beginEdit", 0);
                    //locDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow = 0;
                }

            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                //删除时先获取选择行
                var rows = cureItemDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ArcimID);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            var ArcimRowID=ids.join(',')
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteConfigCureItem","false",function testget(value){
						if(value=="0"){
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow = undefined;
						},"","",ArcimRowID);
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
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow != undefined)
                {
                	var editors = cureItemDataGrid.datagrid('getEditors', editRow);      
					var ArcimRowID =  editors[0].target.combobox('getValue');
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveConfigCureItem","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow = undefined;
						},"","",ArcimRowID);
            		}
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                if (editRow!=undefined) cureItemDataGrid.datagrid("endEdit", editRow);
                editRow = undefined;
                cureItemDataGrid.datagrid("rejectChanges");
                cureItemDataGrid.datagrid("unselectAll");
            }
        }];
    cureItemColumns=[[    
        			{ field: 'ArcimDesc', title: '治疗项目名称', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'ArcimRowID',
								textField:'ArcimDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindAllItem";
									param.ArgCnt = 0;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'ArcimID', title: '治疗项目ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}
    			 ]];
     // 已设置科室列表Grid
	cureItemDataGrid=$('#tabCureItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : './dhcdoc.cure.query.grid.easyui.csp',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ArcimID",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemColumns,
    	toolbar :cureItemToolBar,
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocCureAppConfig';
			param.QueryName ='FindConfigCureItem';
			param.ArgCnt =0;
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		}
	});
});


