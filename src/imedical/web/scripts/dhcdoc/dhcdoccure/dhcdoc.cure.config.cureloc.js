	var CurrLocId=""; //记录选中的行
    var locDataGrid; //定义全局变量datagrid
    var editRow = undefined; //定义全局变量：当前编辑的行
    var locRoomDataGrid; //定义全局变量datagrid
    var editRow2 = undefined; //定义全局变量：当前编辑的行
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
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteLoc","false",function testget(value){
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
        '-', /*{
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
                        //console.info(LocId)
                        //当无编辑行时
                        //获取到当前选择行的下标
						editors[0].target.combobox('setValue',LocId);
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
					if (LocId=="")
					{
						$.messager.alert('提示',"请选择科室");
						return false;
					}
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveLoc","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							locDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							locDataGrid.datagrid('load');
           					locDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
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
                editRow = undefined;
                locDataGrid.datagrid("rejectChanges");
                locDataGrid.datagrid("unselectAll");
            }
        }];
    var LocRowID=""
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
			param.QueryName ='FindCureLoc';
			param.ArgCnt =0;
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			//console.info(rowIndex);
			locDataGrid.datagrid('selectRow',rowIndex);
			var selected=locDataGrid.datagrid('getRows'); 
			var LocId=selected[rowIndex].LocId;
			//console.info(LocId)
			loadLocRoomDataGrid(LocId);
		}
	});
	//--------------诊室代码---------------
	var locRoomToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
               if (CurrLocId!="")
               {
                if (editRow2 != undefined) {
                    //locRoomDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    locRoomDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    locRoomDataGrid.datagrid("beginEdit", 0);
                    //locRoomDataGrid.datagrid('addEditor',LocDescEdit);
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
                var rows = locRoomDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RoomId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            var LocRoomID=ids.join(',')
                            //console.info("删除:"+CurrLocId+"^"+LocRoomID)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteLocRoom","false",function testget(value){
						if(value=="0"){
							locRoomDataGrid.datagrid('load');
           					locRoomDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow2 = undefined;
						},"","",CurrLocId,LocRoomID);
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
        '-', {
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //修改时要获取选择到的行
                var rows = locRoomDataGrid.datagrid("getSelections");
                //如果只选择了一行则可以进行修改，否则不操作
                if (rows.length == 1) {
                    //修改之前先关闭已经开启的编辑行，当调用endEdit该方法时会触发onAfterEdit事件
                    if (editRow2 != undefined) {
                        locRoomDataGrid.datagrid("endEdit", editRow2);
                    }else{ 
                    	
                        //当开启了当前选择行的编辑状态之后，
                        //应该取消当前列表的所有选择行，要不然双击之后无法再选择其他行进行编辑
                        var rowIndex = locRoomDataGrid.datagrid("getRowIndex", rows[0]);
                        //开启编辑
                        locRoomDataGrid.datagrid("beginEdit", rowIndex);
                        //把当前开启编辑的行赋值给全局变量editRow
                        editRow2 = rowIndex; 
                        var selected=locRoomDataGrid.datagrid('getRows');
                        var RoomId=selected[rowIndex].RoomId;
                        var NeedAppFlag=selected[rowIndex].NeedAppFlag; 
                        var AppStartTime=selected[rowIndex].AppStartTime;
                        var AppTimeLength=selected[rowIndex].AppTimeLength;
                        var AppTimeRangeLimit=selected[rowIndex].AppTimeRangeLimit;   
                        var editors = locRoomDataGrid.datagrid('getEditors', editRow2);
                        //console.info(RoomId+"^"+AppStartTime+"^"+AppTimeLength)
                        //当无编辑行时
                        //获取到当前选择行的下标
						editors[0].target.combobox('setValue',RoomId);
						editors[1].target.combobox('setValue',NeedAppFlag);
						editors[2].target.combobox('setValue',AppStartTime);
						editors[3].target.combobox('setValue',AppTimeLength);
						editors[4].target.numberbox('setValue',AppTimeRangeLimit);
						locRoomDataGrid.datagrid("unselectAll");
 						//locRoomDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
              }else{
		           $.messager.alert('提示',"请选择一行治疗科室记录");	
		      }
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                if (editRow2 != undefined)
                {
                	var editors = locRoomDataGrid.datagrid('getEditors', editRow2);      
					var RoomId =  editors[0].target.combobox('getValue');
					var NeedAppFlag =  editors[1].target.combobox('getValue');
					var AppStartTime =  editors[2].target.combobox('getValue');
					var AppTimeLength =  editors[3].target.combobox('getValue');
					var AppTimeRangeLimit =  editors[4].target.numberbox('getValue');
					if (NeedAppFlag==0){
						if (RoomId==""){
						$.messager.alert("提示","请填写诊室");
						return false;
							
						}
							
					}else{
						if ((RoomId=="")||(NeedAppFlag=="")||(AppStartTime=="")||(AppTimeLength=="")||(AppTimeRangeLimit==""))
						{
						$.messager.alert("提示","必填项请填写完整");
						return false;
						}
						
					}
					
					//console.info("保存:"+RoomId+"^"+AppStartTime+"^"+AppTimeLength+"^"+AppTimeRangeLimit)
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveLocRoom","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							locRoomDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							locRoomDataGrid.datagrid('load');
           					locRoomDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
						}
						editRow2 = undefined;
						},"","",CurrLocId,RoomId,NeedAppFlag,AppStartTime,AppTimeLength,AppTimeRangeLimit);
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
                locRoomDataGrid.datagrid("rejectChanges");
                locRoomDataGrid.datagrid("unselectAll");
            }
        }];
    var locRoomColumns=[[    
        			{ field: 'RoomDesc', title: '诊室名称', width: 100, align: 'center', sortable: true, resizable: true,
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
        			{ field: 'NeedAppDesc', title: '是否启用预约', width: 100, align: 'center', sortable: true, resizable: true,
					  editor:{  
							type:'combobox',  
							options:{
								valueField:'AppFlag',
								textField:'AppFlagDesc',
								required:true,
								data: [{
										AppFlagDesc: '是',
										AppFlag: '1'
									},{
										AppFlagDesc: '否',
										AppFlag: '0'
									}],
								onSelect:function(rec){
									
								}
							}
						}
					},
					{ field: 'AppStartTime', title: '预约开始时间', width: 100, align: 'center', sortable: true, resizable: true,
					  editor:{  
							type:'combobox',  
							options:{
								valueField:'TimeValue',
								textField:'TimeDesc',
								required:true,
								data: [{
										TimeDesc: '6:00',
										TimeValue: '6:00'
									},{
										TimeDesc: '7:00',
										TimeValue: '7:00'
									},{
										TimeDesc: '8:00',
										TimeValue: '8:00'
									},{
										TimeDesc: '9:00',
										TimeValue: '9:00'
									},{
										TimeDesc: '10:00',
										TimeValue: '10:00'
									},{
										TimeDesc: '11:00',
										TimeValue: '11:00'
									},{
										TimeDesc: '12:00',
										TimeValue: '12:00'
									},{
										TimeDesc: '13:00',
										TimeValue: '13:00'
									},{
										TimeDesc: '14:00',
										TimeValue: '14:00'
									},{
										TimeDesc: '15:00',
										TimeValue: '15:00'
									}],
								onSelect:function(rec){
									
								}
							}
						}
					},
					{ field: 'AppTimeLengthDesc', title: '预约时间段长度', width: 100, align: 'center', sortable: true, resizable: true,
					  editor:{  
							type:'combobox',  
							options:{
								valueField:'TimeLengthValue',
								textField:'TimeLengthDesc',
								required:true,
								data: [{
										TimeLengthDesc: '30分钟',
										TimeLengthValue: '1800'
									},{
										TimeLengthDesc: '1小时',
										TimeLengthValue: '3600'
									},{
										TimeLengthDesc: '1个半小时',
										TimeLengthValue: '5400'
									},{
										TimeLengthDesc: '2小时',
										TimeLengthValue: '7200'
									}],
								onSelect:function(rec){
									
								}
							}
						}
					},
					{ field: 'AppTimeRangeLimit', title: '每个时间段内人次', width: 100, align: 'center', sortable: true, resizable: true,
						editor:{  
							type:'numberbox',
							options:{
								min:1,
								required:true   
							}  
						}
					},
					{ field: 'LocId', title: '科室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'RoomId', title: '诊室ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'NeedAppFlag', title: '预约Flag', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},	    	    
					{ field: 'AppTimeLength', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}	 	    	    
    			 ]];
	locRoomDataGrid=$("#tabCureLocRoomList").datagrid({  
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
		idField:"RoomId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :locRoomColumns,
    	toolbar :locRoomToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
});
function loadLocRoomDataGrid(LocId)
{
	if(LocId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindCureLocRoom';
	queryParams.Arg1 =LocId;	
	queryParams.ArgCnt =1;
	var opts = locRoomDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	locRoomDataGrid.datagrid('load', queryParams);
	//console.info(LocId);
	CurrLocId=LocId;
	editRow2 = undefined;
}
