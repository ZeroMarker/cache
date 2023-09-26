	var CurrLocId=""; //记录选中的行
	var CurrItemCatId="";
	var CurrArcimId="";
    var locDataGrid; //定义全局变量datagrid
    var editRow = undefined; //定义全局变量：当前编辑的行
    var cureItemCatDataGrid ; //定义全局变量datagrid
    var editRow2 = undefined; //定义全局变量：当前编辑的行
    var cureItemDataGrid; //定义全局变量datagrid
    var editRow3 = undefined; //定义全局变量：当前编辑的行
    var cureItemCatAppendDataGrid; //定义全局变量datagrid
    var editRow4 = undefined; //定义全局变量：当前编辑的行
    var cureItemAppendDataGrid; //定义全局变量datagrid
    var editRow5 = undefined; //定义全局变量：当前编辑的行
$(function(){
	///科室列表columns
	var locToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
                if (editRow != undefined) {
                    //locDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    locDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    locDataGrid.datagrid("beginEdit", 0);
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
                var rows = locDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].LocId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            var LocID=ids.join(',')
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteClinicLoc","false",function testget(value){
						if(value=="0"){
							locDataGrid.datagrid('load');
           					locDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow = undefined;
						},"","",LocID);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },
        '-',/* {
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
                //修改时要获取选择到的行
                var rows = locDataGrid.datagrid("getSelections");
                //如果只选择了一行则可以进行修改，否则不操作
                if (rows.length == 1) {
                    //修改之前先关闭已经开启的编辑行，当调用endEdit该方法时会触发onAfterEdit事件
                    if (editRow != undefined) {
                        locDataGrid.datagrid("endEdit", editRow);
                    }else{ 
                    	
                        //当开启了当前选择行的编辑状态之后，
                        //应该取消当前列表的所有选择行，要不然双击之后无法再选择其他行进行编辑
                        var rowIndex = locDataGrid.datagrid("getRowIndex", rows[0]);
                        //开启编辑
                        locDataGrid.datagrid("beginEdit", rowIndex);
                        //把当前开启编辑的行赋值给全局变量editRow
                        editRow = rowIndex; 
                        var selected=locDataGrid.datagrid('getRows');
                        var LocId=selected[rowIndex].LocId;  
                        var editors = locDataGrid.datagrid('getEditors', editRow);
                        //当无编辑行时
                        //获取到当前选择行的下标
						editors[0].target.combobox('setValue',LocId);
						editors[1].target.combobox('setValue',NeedAppFlag);
						locDataGrid.datagrid("unselectAll");
 						//locDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
            }
        },
        '-',*/ {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow != undefined)
                {
                	var editors = locDataGrid.datagrid('getEditors', editRow);      
					var LocId =  editors[0].target.combobox('getValue');
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveClinicLoc","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							locDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							locDataGrid.datagrid('load');
           					locDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow = undefined;
						},"","",LocId);
            		}
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                if (editRow!=undefined) locDataGrid.datagrid("endEdit", editRow);
                editRow = undefined;
                locDataGrid.datagrid("rejectChanges");
                locDataGrid.datagrid("unselectAll");
            }
        }];
    locColumns=[[    
        			{ field: 'LocDesc', title: '科室名称', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'LocRowID',
								textField:'LocDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindLoc";
									param.Arg1 = "";
									param.ArgCnt = 1;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'LocId', title: '科室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}
    			 ]];
     // 已设置科室列表Grid
	locDataGrid=$('#tabCureLocList').datagrid({  
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
		idField:"LocId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :locColumns,
    	toolbar :locToolBar,
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocCureAppConfig';
			param.QueryName ='FindClinicLoc';
			param.ArgCnt =0;
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			locDataGrid.datagrid('selectRow',rowIndex);
			var selected=locDataGrid.datagrid('getRows'); 
			var LocId=selected[rowIndex].LocId;
			loadcureItemCatDataGrid(LocId);
		}
	});
	//-------------治疗项目子类代码---------------
	var cureItemCatToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
               if (CurrLocId!="")
               {
                if (editRow2 != undefined) {
                    //cureItemCatDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    cureItemCatDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    cureItemCatDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow2 = 0;
                }
              }else{
	              $.messager.alert('提示',"请选择一行治疗科室记录");
	          }
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //删除时先获取选择行
                var rows = cureItemCatDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ItemCatId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            var cureItemCatID=ids.join(',')
                           //alert("删除:"+CurrLocId+"^"+cureItemCatID)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeletecureItemCat","false",function testget(value){
						if(value=="0"){
							cureItemCatDataGrid.datagrid('load');
           					cureItemCatDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败");
						}
						editRow2 = undefined;
						},"","",CurrLocId,cureItemCatID);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	          }else{
		           $.messager.alert('提示',"请选择一行治疗科室记录");	
		      }
            }
        },
        '-', /*{
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //修改时要获取选择到的行
                var rows = cureItemCatDataGrid.datagrid("getSelections");
                //如果只选择了一行则可以进行修改，否则不操作
                if (rows.length == 1) {
                    //修改之前先关闭已经开启的编辑行，当调用endEdit该方法时会触发onAfterEdit事件
                    if (editRow2 != undefined) {
                        cureItemCatDataGrid.datagrid("endEdit", editRow2);
                    }else{ 
                    	
                        //当开启了当前选择行的编辑状态之后，
                        //应该取消当前列表的所有选择行，要不然双击之后无法再选择其他行进行编辑
                        var rowIndex = cureItemCatDataGrid.datagrid("getRowIndex", rows[0]);
                        //开启编辑
                        cureItemCatDataGrid.datagrid("beginEdit", rowIndex);
                        //把当前开启编辑的行赋值给全局变量editRow
                        editRow2 = rowIndex; 
                        var selected=cureItemCatDataGrid.datagrid('getRows');
                        var ItemCatId=selected[rowIndex].ItemCatId;   
                        var editors = cureItemCatDataGrid.datagrid('getEditors', editRow2);
                        //console.info("ItemCatId:="+ItemCatId)
                        //当无编辑行时
                        //获取到当前选择行的下标
						editors[0].target.combobox('setValue',ItemCatId);
						cureItemDataGrid.datagrid("unselectAll");
 						//cureItemDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
              }else{
		           $.messager.alert('提示',"请选择一行治疗科室记录");	
		      }
            }
        },
        '-',*/ {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow2 != undefined)
                {
                	var editors = cureItemCatDataGrid.datagrid('getEditors', editRow2);      
					var ItemCatId =  editors[0].target.combobox('getValue');
					//console.info("保存:"+CurrLocId+"^"+ItemCatId)
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SavecureItemCat","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemCatDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							cureItemCatDataGrid.datagrid('load');
           					cureItemCatDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow2 = undefined;
						},"","",CurrLocId,ItemCatId);
            		}
            	}else{
		           $.messager.alert('提示',"请选择一行治疗科室记录");	
		      }
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow2 = undefined;
                cureItemCatDataGrid.datagrid("rejectChanges");
                cureItemCatDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemCatColumns=[[    
        			{ field: 'ItemCatDesc', title: '医嘱子类', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'ItemCatRowID',
								textField:'ItemCatDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindItemCat";
									param.ArgCnt = 0;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'LocId', title: '科室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '子类ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}
    			 ]];
	cureItemCatDataGrid=$("#tabCureItemCatList").datagrid({  
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
		idField:"ItemCatId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemCatColumns,
    	toolbar :cureItemCatToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			cureItemCatDataGrid.datagrid('selectRow',rowIndex);
			var selected=cureItemCatDataGrid.datagrid('getRows'); 
			var ItemCatId=selected[rowIndex].ItemCatId;
			loadcureItemDataGrid(ItemCatId);
			//loadItemCatAppendDataGrid(ItemCatId);
		}
	});
	//-------------治疗项目代码---------------
	var cureItemToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
               if ((CurrLocId!="")&&(CurrItemCatId!=""))
               {
                if (editRow3 != undefined) {
                    //cureItemDataGrid.datagrid("endEdit", editRow3);
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
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow3 = 0;
                }
              }else{
	              $.messager.alert('提示',"请选择一行医嘱子类记录");
	          }
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //删除时先获取选择行
                var rows = cureItemDataGrid.datagrid("getSelections");
                //console.info(rows);
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var ArcimId=ids.join(',')
                            //console.info("删除:"+CurrLocId+"^"+CurrItemCatId+"^"+ArcimId)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeletecureItem","false",function testget(value){
						if(value=="0"){
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow3 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	          }else{
		           $.messager.alert('提示',"请选择一行医嘱子类记录");	
		      }
            }
        },
        '-',/* {
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //修改时要获取选择到的行
                var rows = cureItemDataGrid.datagrid("getSelections");
                //如果只选择了一行则可以进行修改，否则不操作
                if (rows.length == 1) {
                    //修改之前先关闭已经开启的编辑行，当调用endEdit该方法时会触发onAfterEdit事件
                    if (editRow3 != undefined) {
                        cureItemDataGrid.datagrid("endEdit", editRow3);
                    }else{ 
                    	
                        //当开启了当前选择行的编辑状态之后，
                        //应该取消当前列表的所有选择行，要不然双击之后无法再选择其他行进行编辑
                        var rowIndex = cureItemDataGrid.datagrid("getRowIndex", rows[0]);
                        //开启编辑
                        cureItemDataGrid.datagrid("beginEdit", rowIndex);
                        //把当前开启编辑的行赋值给全局变量editRow
                        editRow3 = rowIndex; 
                        var selected=cureItemDataGrid.datagrid('getRows');
                        var ArcimId=selected[rowIndex].ArcimId; 
                        var editors = cureItemDataGrid.datagrid('getEditors', editRow3);
                        //console.info(ArcimId)
                        //当无编辑行时
                        //获取到当前选择行的下标
						editors[0].target.combobox('setValue',ArcimId);
						cureItemDataGrid.datagrid("unselectAll");
 						//cureItemDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
              }else{
		           $.messager.alert('提示',"请选择一行医嘱子类记录");	
		      }
            }
        },
        '-',*/ {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow3 != undefined)
                {
                	var editors = cureItemDataGrid.datagrid('getEditors', editRow3);      
					var ArcimId =  editors[0].target.combobox('getValue');
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SavecureItem","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemDataGrid.datagrid("endEdit", editRow3);
                			editRow3 = undefined;
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow3 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
            		}
            	}else{
		           $.messager.alert('提示',"请选择一行医嘱子类记录");	
		      }
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow3 = undefined;
                cureItemDataGrid.datagrid("rejectChanges");
                cureItemDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemColumns=[[    
        			{ field: 'ArcimDesc', title: '医嘱项名称', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'ArcimRowID',
								textField:'ArcimDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindItem";
									//console.info(CurrItemCatId);
									param.Arg1 = CurrItemCatId;
									param.ArgCnt = 1;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'ArcimId', title: '医嘱项ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '子类ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'LocId', title: '科室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}   
    			 ]];
	cureItemDataGrid=$("#tabCureItemList").datagrid({  
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
		idField:"ArcimId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemColumns,
    	toolbar :cureItemToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			cureItemDataGrid.datagrid('selectRow',rowIndex);
			var selected=cureItemDataGrid.datagrid('getRows'); 
			var ArcimId=selected[rowIndex].ArcimId;
			//loadItemAppendDataGrid(ArcimId);
		}
	});
	//-------------子类绑定费用---------------
	var cureItemCatAppendToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
               if ((CurrLocId!="")&&(CurrItemCatId!=""))
               {
                if (editRow4 != undefined) {
                    //cureItemCatAppendDataGrid.datagrid("endEdit", editRow4);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    cureItemCatAppendDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    cureItemCatAppendDataGrid.datagrid("beginEdit", 0);
                    //cureItemCatAppendDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow4 = 0;
                }
              }else{
	              $.messager.alert('提示',"请选择一行医嘱子类记录");
	          }
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //删除时先获取选择行
                var rows = cureItemCatAppendDataGrid.datagrid("getSelections");
                //console.info(rows);
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var ArcimId=ids.join(',')
                            //console.info("删除:"+CurrLocId+"^"+CurrItemCatId+"^"+ArcimId)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteItemCatAppend","false",function testget(value){
						if(value=="0"){
							cureItemCatAppendDataGrid.datagrid('load');
           					cureItemCatAppendDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow4 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	          }else{
		           $.messager.alert('提示',"请选择一行医嘱子类记录");	
		      }
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow4 != undefined)
                {
                	var editors = cureItemCatAppendDataGrid.datagrid('getEditors', editRow4);      
					var ArcimId =  editors[0].target.combobox('getValue');
					//console.info(CurrLocId+","+CurrItemCatId+","+ArcimId);
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveItemCatAppend","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemCatAppendDataGrid.datagrid("endEdit", editRow4);
                			editRow4 = undefined;
							cureItemCatAppendDataGrid.datagrid('load');
           					cureItemCatAppendDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if(value=="100") value="请选择医嘱项"
							if(value=="110") value="已经做过设置,附加项目只能绑定一个"
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow4 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
            		}
            	}else{
		           $.messager.alert('提示',"请选择一行医嘱子类记录");	
		      }
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow4 = undefined;
                cureItemCatAppendDataGrid.datagrid("rejectChanges");
                cureItemCatAppendDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemCatAppendColumns=[[    
        			{ field: 'ArcimDesc', title: '医嘱项名称', width: 100, align: 'center', sortable: true, resizable: true,
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
					{ field: 'ArcimId', title: '医嘱项ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '子类ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'LocId', title: '科室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}   
    			 ]];
	cureItemCatAppendDataGrid=$("#tabCureItemCatAppendList").datagrid({  
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
		//pagination : true,  //
		rownumbers : true,  //
		idField:"ArcimId",
		//pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemCatAppendColumns,
    	toolbar :cureItemCatAppendToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
	//-------------治疗项目绑定费用---------------
	var cureItemAppendToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
               //console.info("ADD:"+CurrLocId+"^"+CurrItemCatId+"^"+CurrArcimId); 
               if ((CurrLocId!="")&&(CurrItemCatId!="")&&(CurrArcimId!=""))
               {
                if (editRow5 != undefined) {
                    //cureItemAppendDataGrid.datagrid("endEdit", editRow5);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    cureItemAppendDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    cureItemAppendDataGrid.datagrid("beginEdit", 0);
                    //cureItemAppendDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow5 = 0;
                }
              }else{
	              $.messager.alert('提示',"请选择一行医嘱项目记录");
	          }
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!="")&&(CurrArcimId!=""))
	            {
                //删除时先获取选择行
                var rows = cureItemAppendDataGrid.datagrid("getSelections");
                //console.info(rows);
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].AppendArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var AppendArcimId=ids.join(',')
                            //console.info("删除:"+CurrLocId+"^"+CurrItemCatId+"^"+CurrArcimId)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteItemAppend","false",function testget(value){
						if(value=="0"){
							cureItemAppendDataGrid.datagrid('load');
           					cureItemAppendDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							if (value=="100") value="请选择一条附加项目"
							else if (value=="110") value="记录不存在"
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow5 = undefined;
						},"","",CurrLocId,CurrItemCatId,CurrArcimId,AppendArcimId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	          }else{
		           $.messager.alert('提示',"请选择一行医嘱项目记录");	
		      }
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!="")&&(CurrArcimId!=""))
	            {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow5 != undefined)
                {
                	var editors = cureItemAppendDataGrid.datagrid('getEditors', editRow5);      
					var AppendArcimId =  editors[0].target.combobox('getValue');
					//console.info("Save:"+CurrLocId+","+CurrItemCatId+","+CurrArcimId+","+AppendArcimId)
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveItemAppend","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemAppendDataGrid.datagrid("endEdit", editRow5);
                			editRow5 = undefined;
							cureItemAppendDataGrid.datagrid('load');
           					cureItemAppendDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if(value=="100") value="请选择医嘱项"
							if(value=="110") value="已经做过设置,附加项目只能绑定一个"
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow5 = undefined;
						},"","",CurrLocId,CurrItemCatId,CurrArcimId,AppendArcimId);
            		}
            	}else{
		           $.messager.alert('提示',"请选择一行医嘱项目记录");	
		      }
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow5 = undefined;
                cureItemAppendDataGrid.datagrid("rejectChanges");
                cureItemAppendDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemAppendColumns=[[    
        			{ field: 'ArcimDesc', title: '医嘱项名称', width: 100, align: 'center', sortable: true, resizable: true,
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
					{ field: 'ArcimId', title: '医嘱项ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'AppendArcimId', title: '附加医嘱项ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '子类ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'LocId', title: '科室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}   
    			 ]];
	cureItemAppendDataGrid=$("#tabCureItemAppendList").datagrid({  
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
		//pagination : true,  //
		rownumbers : true,  //
		idField:"AppendArcimId",
		//pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemAppendColumns,
    	toolbar :cureItemAppendToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
});
function loadcureItemCatDataGrid(LocId)
{
	if(LocId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindCurecureItemCat';
	queryParams.Arg1 =LocId;	
	queryParams.ArgCnt =1;
	var opts = cureItemCatDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemCatDataGrid.datagrid('load', queryParams);
	//console.info(LocId);
	CurrLocId=LocId;
	editRow2 = undefined;
	editRow3 = undefined;
	editRow4 = undefined;
	editRow5 = undefined;
}
function loadcureItemDataGrid(ItemCatId)
{
	if(ItemCatId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindCurecureItem';
	queryParams.Arg1 =CurrLocId;
	queryParams.Arg2 =ItemCatId;	
	queryParams.ArgCnt =2;
	var opts = cureItemCatDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemDataGrid.datagrid('load', queryParams);
	//console.info(ItemCatId);
	CurrItemCatId=ItemCatId;
	editRow3 = undefined;
	editRow4 = undefined;
	editRow5 = undefined;
}
function loadItemCatAppendDataGrid(ItemCatId)
{
	if(ItemCatId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindItemCatAppend';
	queryParams.Arg1 =CurrLocId;
	queryParams.Arg2 =ItemCatId;	
	queryParams.ArgCnt =2;
	var opts = cureItemCatAppendDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemCatAppendDataGrid.datagrid('load', queryParams);
	//console.info("ItemCatId:"+CurrLocId+","+ItemCatId);
	editRow4 = undefined;
}
function loadItemAppendDataGrid(ItemId)
{
	if(ItemId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindItemAppend';
	queryParams.Arg1 =CurrLocId;
	queryParams.Arg2 =CurrItemCatId;
	queryParams.Arg3 =ItemId;	
	queryParams.ArgCnt =3;
	var opts = cureItemAppendDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemAppendDataGrid.datagrid('load', queryParams);
	CurrArcimId=ItemId;
	editRow5 = undefined;
	//console.info("CurrArcimId:"+ItemId);
}
