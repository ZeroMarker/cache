
///sunhaiming20210807
$(function(){
	var _GV={
		ClassName:"Nur.HISUI.AccompanyConfig",
		regSearchAllInPatGroup:""
	}
	function Init(){
		InitHospList();  
		initBasicData();
		$("#groupSearch").searchbox({
			searcher:function(){
				groupSearchClick();
			}
		})
	}
	function initGrid(){  //主配置表格
		var toolbarConfig = [{
	        text: '新增',
	        iconCls: 'icon-add',
	        handler: addRow
	    }, {
	        text: '删除',
	        iconCls: 'icon-cancel',
	        handler: deleteRow
	    }, {
	        text: '保存',
	        iconCls: 'icon-save',
	        handler: saveRow
	    },'-',{
	        text: '陪护医嘱设置',
	        iconCls: 'icon-batch-cfg',
	        handler: accomOrderConfig
	    },'-',{
		    id:"accomRegNoSearchConfig",
	        text: '登记号查询设置',
	        iconCls: 'icon-batch-cfg',
	        handler: accomRegNoSearchConfig
	    }/*,'-',{
	        text: '重复添加陪护人员提示设置',
	        iconCls: 'icon-tip-blue',
	        handler: accomAlertConfig
	    },*/];
		$('#accomGrid').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			loadMsg : '加载中..',  
			rownumbers : true,
			idField:"id",
			toolbar:toolbarConfig,
			columns :[[{field:'colType',title:'类型',width:150,
						 editor: {
		                    type: 'combobox',
		                    options: {
		                        valueField: 'ID',
		                        textField: 'desc',
		                        required: true,
								panelHeight:"auto",
		                 		editable:false,
		                		enterNullValueClear:false,
                                onShowPanel:function(){
	                                var url = $(this).combobox('options').url;
									if (!url){
										var url = $URL+"?ClassName=Nur.HISUI.AccompanyConfig&QueryName=findDisplayList&ResultSetType=array&className=CF.NUR.Accom.Config&property=AccomColType";
										$(this).combobox('reload',url);
									}
	                            },
	                            missingMessage:"请选择类型！"
		                    }
		                },
		              },
			          {field:'colCode',title:'代码',width:100,
			           editor:{
				          type:'validatebox',
				          options:{
					        required:true,
					        missingMessage:"代码项必填！"    
					      }    
				       }
				      },
			          {field:'colDesc',title:'描述',width:100,
			            editor:{
				          type:'validatebox',
				          options:{
					        required:true,
					        missingMessage:"描述项必填！"    
					      }    
				       }
			          },
			          {field:'colFunc',title:'函数',width:350,editor: 'validatebox'},
			          {field:'colDataType',title:'元素类型',width:100,
			          	editor: {
		                    type: 'combobox',
		                    options: {
		                        valueField: 'ID',
		                        textField: 'desc',
		                        required: true,
								panelHeight:"auto",
		                 		editable:false,
		                		enterNullValueClear:false,
                                onShowPanel:function(){
	                                var url = $(this).combobox('options').url;
									if (!url){
										var url = $URL+"?ClassName=Nur.HISUI.AccompanyConfig&QueryName=findDisplayList&ResultSetType=array&className=CF.NUR.Accom.Config&property=AccomColDataType";
										$(this).combobox('reload',url);
									}
	                            },
	                            onSelect:function(record){
		                            var colDataType=$(this).combobox("getValue");
		                            var index=$("#accomGrid").datagrid("getEditingIndex");
		                            var colValueObj=$("#accomGrid").datagrid('getEditor', {index:index,field:'colValue'});
									if ((colDataType!=1)&&(colDataType!=6)&&(colDataType!=7)){
										$(colValueObj.target[0]).removeAttr("disabled");
									}else{
										colValueObj.target[0].value="";
										$(colValueObj.target[0]).attr("disabled","disabled");
									}
		                        },
	                            missingMessage:"请选择元素类型！"
		                    }
		                },
		                
		              },
			          {field:'colValue',title:'选项',width:200,
			            editor:{
				           type:"validatebox",
				        }
			          },
			          {field:'colWidth',title:'宽度',width:100,editor: 'numberbox'},
			          {field:'colDefaultVal',title:'默认值',width:100,editor: 'validatebox'},
			          //{field:'colWarning',title:'预警值',width:100,editor: 'validatebox'},
			          {field:'colOrder',title:'顺序号',width:100,
			            editor: {
				          type:"numberbox",
				          options:{
					        required:true,
					        missingMessage:"顺序号必填！"    
					      } 
				        }
			          },
			          {field:'colUsing',title:'状态',width:60,
			            editor: {
		                    type: 'checkbox',
		                    options:{
			                    on:'Y',
			                    off:'N'
			                }
			            },
			            formatter:function(value){
				          if(value!=""){
					         return  value=="Y"?"启用":"停用" ; 
					      }    
				        }
			          },
			          {field:'id',title:'id',hidden:"true"},
			          ]],
			url : $URL+"?ClassName="+_GV.ClassName+"&QueryName=findConfigData",
			onBeforeLoad:function(param){
				param.opType=$("#opType").combobox('getValue');
				param.hospId=$HUI.combogrid('#_HospList').getValue();
			},
			onDblClickRow:onDblClickRow
	   })
	   $(".datagrid-toolbar>table:first>tbody>tr:last-child").append("<div class='datagrid-btn-separator'>&nbsp;</div>"); //添加|分割线
	   $(".datagrid-toolbar>table:first>tbody>tr:last-child").append($("#readAccomInfoDiv"));  //添加文字和switch控件
	   $('#accomRegNoSearchConfig').after($('<a></a>').linkbutton({
	        plain:true,
	        iconCls:'icon-help'
	    }).tooltip({
	        content:"配置有权限根据患者登记号查询全院住院患者的安全组"
	    }));
	}
	function initBasicData(){
	   var opTypeData=$cm({
		   ClassName:_GV.ClassName,
           QueryName:"findDisplayList",
           ResultSetType:"array",
           className:"CF.NUR.Accom.Config",
           property:"AccomOPType"
        },false);
       $("#opType").combobox({
	        valueField:'ID',
			textField:'desc',
			panelHeight:"auto",
			editable:false,
			data:opTypeData,
			onSelect:function(){
				gridLoad();
			}
		   });
	   $("#opType").combobox('setValue',"P");  //加载维护类型并默认人员登记
	   var ifReadAccomInfo=$m({
		   ClassName:'Nur.HISUI.AccompanyConfig',
           MethodName:'getOnceConfig',
           type:'readAccomInfo',
           hospId:$HUI.combogrid('#_HospList').getValue()
       },false);
	   if(ifReadAccomInfo=="false"){   //外部switch切换
		   $("#readAccomInfo").switchbox('toggle');
	   } 
	   loadRegSearchAllInPatGroup();
	}
	function gridLoad(){  //加载主配置表格
		$('#accomGrid').datagrid("clearSelections");
		$('#accomGrid').datagrid("reload");
		editIndex=undefined;
	}
	var editIndex = undefined; //正在编辑的行索引
	function endEditing() {
	    if (editIndex == undefined) { return true }
	    if ($('#accomGrid').datagrid('validateRow', editIndex)) {
	        $('#accomGrid').datagrid('endEdit', editIndex);
	        editIndex = undefined;
	        return true;
	    } else {
	        return false;
	    }
	}
	function onDblClickRow(index,row) {//双击开始编辑并为colValue列添加placeHolder
	    if (editIndex != index) {
	        if (endEditing()) {
	            $('#accomGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
	            editIndex = index;
	        } else {
	            $('#accomGrid').datagrid('selectRow', editIndex);
	        }
	        var target=$('#accomGrid').datagrid('getEditor',{'index':editIndex,'field':'colValue'}).target;
	        $(target).attr("placeHolder","多个选项用&分割");
	    }
	}
    function addRow(){  //添加行
	   if (endEditing()) {
	        $('#accomGrid').datagrid('appendRow', { status: 'P' });
	        editIndex = $('#accomGrid').datagrid('getRows').length - 1;
	        $('#accomGrid').datagrid('selectRow', editIndex)
	            .datagrid('beginEdit', editIndex);
	        var target=$('#accomGrid').datagrid('getEditor',{'index':editIndex,'field':'colValue'}).target;
	        $(target).attr("placeHolder","多个选项用&分割");
	   }
	}
    function deleteRow(){  //删除行
	    var selectRow=$("#accomGrid").datagrid('getSelected');
	    if(!selectRow){
		    $.messager.popover({msg:"请选择需要删除的行！",type:"alert"});
		    return;
		}else if(!selectRow.id){
			$.messager.popover({msg:"没有保存不需要删除！",type:"alert"});
		    return;
	    }else{
		    $.messager.confirm('确认对话框', "是否确认删除?", function(r){
				if (r){
				   $m({
					    ClassName:_GV.ClassName,
					    MethodName:"deleteRow",
						id:selectRow.id
					},function(ret){
						if(ret!=""){
					        $.messager.popover({msg:ret,type:"error"});
					    }else{
						    $.messager.popover({msg:"删除成功！",type:"success"});
						    gridLoad();
						}
					})
				}
			});
		}
	}
    function saveRow(){  //保存主配置
	    if (endEditing()) {
            saveLink();
            $('#accomGrid').datagrid('acceptChanges');
        }    
	}
	function saveLink() { //保存主配置
        var rows = $('#accomGrid').datagrid('getChanges');
        var itemArr=["id","colType","colCode","colDesc","colFunc","colDataType","colValue","colOrder","colUsing","colWidth","colDefaultVal"]; //,"colWarning"
	    var error=[];
	    rows.forEach(function (row) {
		    var str="";
		    itemArr.forEach(function(item){
			    var val=$.trim(row[item])||'';
			    str=str==""?item+"@"+val:str+"^"+item+"@"+val;
			});
	        var ret=$m({ClassName:_GV.ClassName,
	                    MethodName:"saveRowData",
	                    rowData:str,
	                    hospId:$HUI.combogrid('#_HospList').getValue(),
	                    opType:$("#opType").combobox('getValue')},false);
	         if(ret!=""){
		         error.push(ret);
		     }
		 });
		 if(error.length>0){
			 $.messager.popover({msg:error.join("!"),type:"error"});
	     }else{
		     $.messager.popover({msg:"保存成功！",type:"success"});
		     gridLoad();
		 }
    }
    function InitHospList(){  //加载院区
		var hospComp = GenHospComp("NUR_Accom_Config");
		hospComp.jdata.options.onSelect = function(e,t){
			gridLoad();
			loadRegSearchAllInPatGroup();
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			initBasicData();
			initGrid();
		}
    }
    var firstOrder=1;
    function accomOrderConfig(){  //加载医嘱设置
	    if(firstOrder==1){
		  var orderEditor=new editor("OrderConfigGrid");
		  initOrderConfigDialog(orderEditor);
		  firstOrder=0;    
		}
        $HUI.dialog("#OrderConfigDialog").open();
	}
	var firstAlert=1;  //加载重复提醒设置
	function accomAlertConfig(){
	   	if(firstAlert==1){
		  var alertEditor=new editor("AlertConfigGrid");
		  initAlertConfigDialog(alertEditor);
		  var ifAlertAccomInfo=$m({ClassName:'Nur.HISUI.AccompanyConfig',
	                           MethodName:'getOnceConfig',
	                           type:'alertAccomInfo',
	                           hospId:$HUI.combogrid('#_HospList').getValue()},false);
	      if(ifAlertAccomInfo=="false"){
		    $("#alertAccomInfo").switchbox('toggle');
	      }
		  firstAlert=0;    
		}
        $HUI.dialog("#AlertConfigDialog").open();
	}
    function initOrderConfigDialog(orderEditor){ //初始化医嘱弹框
	  $HUI.dialog('#OrderConfigDialog',{
		width:550,
		modal:true,
		height:350,
		closed:true,
		title:'陪护医嘱设置',
		iconCls:'icon-w-config',
		/*buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#OrderConfigDialog").close();
			}
		}],*/
		onClose:function(){
			$("#OrderConfigGrid").datagrid("rejectChanges").datagrid("unselectAll");
		}
	 }); 
	 $("#OrderConfigGrid").datagrid({
				mode: 'remote',
				fit:true,
				border:false,
				pagination:false,
				showPageList:false,
				height:300,
				showRefresh:false,
				singleSelect:true,
				headerCls:'panel-header-gray',
				split:true,
				toolbar:[{
			        text: '新增',
			        iconCls: 'icon-add',
			        handler: orderEditor.addRow
			    }, {
			        text: '删除',
			        iconCls: 'icon-cancel',
			        handler: deleteOrderConfigRow
			    }],
				columns: [[
					{field:"ArcimID",title:"医嘱项ID",align:"center",width:130},
					{field:"ArcimDesc",title:"医嘱名称",align:"left",width:380,
						editor: {
			                type: 'combogrid',
			                options: {
			                    mode: 'remote',
			                    delay: 500,
			                    panelWidth: 400,
			                    panelHeight: 350,
			                    idField: 'id',
			                    textField: 'desc',
			                    displayMsg: '',
			                    required: true,
			                    url: $URL,
			                    queryParams: {
			                        ClassName: _GV.ClassName,
			                        QueryName: "getArcim",
			                        hospId:$HUI.combogrid('#_HospList').getValue()
			                    },
			                    pagination: true,
			                    pageSize: 10,
			                    columns: [[
			                        { field: 'id', title: '医嘱项ID', width: 80 },
			                        { field: 'desc', title: '医嘱名称', width: 300 }
			                    ]],
			                    onSelect: function (rowIndex, rowData) {
			                        var arcimBeforeTrans = $('#OrderConfigGrid').datagrid('getData');
			                          var ifExit =false;
			                         arcimBeforeTrans.rows.forEach(function (row) {	     //判断是否重复           
				                        if(row.ArcimID == rowData.id){
			                            	ifExit=true ;
			                            	return false;
				                        }
			                        })
			                        if (ifExit) {
			                            $.messager.popover({ msg: '医嘱项已存在！', type: 'alert', timeout: 2000 });
			                        }else{
				                        var selected=$('#OrderConfigGrid').datagrid('getSelected');
				                        selected.ArcimID=rowData.id;
				                        saveOrderConfigData(selected.ID);  //自动保存
				                    }
			                    },
			                    onBeforeLoad:function(param){
									param.hospId=$HUI.combogrid('#_HospList').getValue();
								}
			                }
			            },
		            },
		            {field:"ID",title:"ID",hidden:true},
		            
				]],
				url : $URL+"?ClassName="+_GV.ClassName+"&QueryName=findOrderConfig&hospId="+$HUI.combogrid('#_HospList').getValue(),
				onDblClickRow:function(index,row) {  //双击编辑
						    if (orderEditor.editIndex != index) {
						        if (orderEditor.endEditing()) {
						            $('#OrderConfigGrid').datagrid('selectRow', index)
						                .datagrid('beginEdit', index);
						            orderEditor.editIndex = index;
						        } else {
						            $('#OrderConfigGrid').datagrid('selectRow',orderEditor.editIndex);
						        }
						    }
				}
     	});
     	function saveOrderConfigData(ID){ //保存医嘱配置方法
			if (orderEditor.endEditing()) {
				var rows = $('#OrderConfigGrid').datagrid('getChanges');
				var itemArr=["ArcimID"];
				var error=[];
				rows.forEach(function (row) {
					var str="";
					itemArr.forEach(function(item){
						var val=row[item]||'';
						str=str==""?item+"@"+val:str+"^"+item+"@"+val;
					});
					var ret=$m({ClassName:_GV.ClassName,
								MethodName:"saveOrderConfigData",
								rowData:str,
								hospId:$HUI.combogrid('#_HospList').getValue(),
								ID:ID
								},false);
					 if(ret!=""){
						 error.push(ret);
					 }
				 });
				 if(error.length>0){
					 $.messager.popover({msg:error.join("!"),type:"error"});
				 }else{
					 $.messager.popover({msg:"保存成功！",type:"success"});
				 }
				orderEditor.gridLoad();
				$('#OrderConfigGrid').datagrid('acceptChanges');
			}   
		}
		 function deleteOrderConfigRow(){   //删除医嘱配置方法
		    var selectRow=$("#OrderConfigGrid").datagrid('getSelected');
		    if(!selectRow){
			    $.messager.popover({msg:"请选择需要删除的行！",type:"alert"});
			    return;
			}else if(!selectRow.ArcimID){
				$.messager.popover({msg:"没有保存不需要删除！",type:"alert"});
			    return;
		    }else{
			    $.messager.confirm('确认对话框', "是否确认删除?", function(r){
					if (r){
					   $m({
						    ClassName:_GV.ClassName,
						    MethodName:"deleteOrderConfigRow",
							ID:selectRow.ID,
		                    hospId:$HUI.combogrid('#_HospList').getValue()
						},function(ret){
							if(ret!=""){
						        $.messager.popover({msg:ret,type:"error"});
						    }else{
							    $.messager.popover({msg:"删除成功！",type:"success"});
							   orderEditor.gridLoad();
							}
						})
					}
				});
			}
		} 
	}
  function initAlertConfigDialog(alertEditor){   //初始化提示弹框
	  $HUI.dialog('#AlertConfigDialog',{
		width:540,
		modal:true,
		height:350,
		closed:true,
		title:'提示弹框填写字段',
		iconCls:'icon-gear-gray',
		buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#AlertConfigDialog").close();
			}
		}],
	 }); 
	 $("#AlertConfigGrid").datagrid({
				mode: 'remote',
				fit:true,
				border:false,
				pagination:false,
				showPageList:false,
				height:300,
				showRefresh:false,
				singleSelect:true,
				headerCls:'panel-header-gray',
				split:true,
				toolbar:[{
			        text: '新增',
			        iconCls: 'icon-add',
			        handler: alertEditor.addRow
			    }, {
			        text: '删除',
			        iconCls: 'icon-cancel',
			        handler: deleteAlertConfigRow
			    }],
				columns: [[
					{field:"type",title:"类型",align:"center",width:245,
					  	editor: {
		                    type: 'combobox',
		                    options: {
		                        valueField: 'ID',
		                        textField: 'desc',
		                        required: true,
								panelHeight:"auto",
		                 		editable:false,
		                		enterNullValueClear:false,
                                onShowPanel:function(){
	                                var url = $(this).combobox('options').url;
									if (!url){
										var url = $URL+"?ClassName=Nur.HISUI.AccompanyConfig&QueryName=findDisplayList&ResultSetType=array&className=CF.NUR.Accom.Config&property=AccomColType";
										$(this).combobox('reload',url);
									}
	                            },
	                            missingMessage:"请选择类型！",
	                            onSelect:function(record){
		                            var target=$("#AlertConfigGrid").datagrid('getEditor',{'index':alertEditor.editIndex,'field':'desc'}).target;
		                            target.combobox('clear');
		                            var colTypeDesc=$cm({ClassName:_GV.ClassName,
									                     QueryName:"findColTypeAndDesc",
									                     ResultSetType:"array",
									                     hospId:$HUI.combogrid('#_HospList').getValue(),
									                     opType:$("#opType").combobox('getValue'),
									                     colTypeFilter:record.ID},false);
								
		                            target.combobox('loadData',colTypeDesc); //根据不同的信息类型带出对应的列
		                        }
		                    }
		                },
					},
					{field:"desc",title:"描述",align:"center",width:245,
					  	editor: {
		                    type: 'combobox',
		                    options: {
		                        valueField: 'colCode',
		                        textField: 'colDesc',
		                        required: true,
								panelHeight:"auto",
		                 		editable:false,
		                		enterNullValueClear:false,
	                            missingMessage:"请选择需要填写的项目！",
	                            onSelect:function(rowData){
		                             var colBeforeTrans = $('#AlertConfigGrid').datagrid('getData');
			                         var ifExit =false;
			                         colBeforeTrans.rows.forEach(function (row) {	              
				                        if(row.desc == rowData.colCode){
			                            	ifExit=true ;
			                            	return false;
				                        }
			                        })
			                        if (ifExit) {
			                            $.messager.popover({ msg: '项目已存在！', type: 'alert', timeout: 2000 });
			                        }else{
				                        var selected=$("#AlertConfigGrid").datagrid('getSelected');
				                        saveAlertConfigData(selected.ID);
				                    }
		                        }
		                    }
		                },
					},
					{field:"ID",title:"ID",hidden:"true"},
				]],
				url : $URL+"?ClassName="+_GV.ClassName+"&QueryName=findAlertConfig&hospId="+$HUI.combogrid('#_HospList').getValue(),
				onDblClickRow:function(index,row) {
						    if (alertEditor.editIndex != index) {
						        if (alertEditor.endEditing()) {
						            $('#AlertConfigGrid').datagrid('selectRow', index)
						                .datagrid('beginEdit', index);
						            alertEditor.editIndex = index;
						        } else {
						            $('#AlertConfigGrid').datagrid('selectRow',alertEditor.editIndex);
						        }
						    }
				}
     	});
     	function saveAlertConfigData(ID){  //保存提示配置方法
			if (alertEditor.endEditing()) {
				var rows = $('#AlertConfigGrid').datagrid('getChanges');
				var itemArr=["type","desc"];
				var error=[];
				rows.forEach(function (row) {
					var str="";
					itemArr.forEach(function(item){
						var val=row[item]||'';
						str=str==""?item+"@"+val:str+"^"+item+"@"+val;
					});
					var ret=$m({ClassName:_GV.ClassName,
								MethodName:"saveAlertConfigData",
								rowData:str,
								hospId:$HUI.combogrid('#_HospList').getValue(),
								ID:ID
								},false);
					 if(ret!=""){
						 error.push(ret);
					 }
				 });
				 if(error.length>0){
					 $.messager.popover({msg:error.join("!"),type:"error"});
				 }else{
					 $.messager.popover({msg:"保存成功！",type:"success"});
				 }
				alertEditor.gridLoad();
				$('#AlertConfigGrid').datagrid('acceptChanges');
			}   
		}
		function deleteAlertConfigRow(){  //删除提示配置方法
		    var selectRow=$("#AlertConfigGrid").datagrid('getSelected');
		    if(!selectRow){
			    $.messager.popover({msg:"请选择需要删除的行！",type:"alert"});
			    return;
			}else if(!selectRow.ID){
				$.messager.popover({msg:"没有保存不需要删除！",type:"alert"});
			    return;
		    }else{
			    $.messager.confirm('确认对话框', "是否确认删除?", function(r){
					if (r){
					   $m({
						    ClassName:_GV.ClassName,
						    MethodName:"deleteAlertConfigRow",
							ID:selectRow.ID,
		                    hospId:$HUI.combogrid('#_HospList').getValue()
						},function(ret){
							if(ret!=""){
						        $.messager.popover({msg:ret,type:"error"});
						    }else{
							    $.messager.popover({msg:"删除成功！",type:"success"});
							    alertEditor.gridLoad();
							}
						})
					}
				});
			}
		} 
	}
	function editor(id){   //编辑可编辑类
		this.id=id;
		this.editIndex = undefined;
		var _this=this;
		this.endEditing=function() {
		    if (_this.editIndex == undefined) { return true }
		    if ($('#'+_this.id).datagrid('validateRow', _this.editIndex)) {
		        $('#'+_this.id).datagrid('endEdit', _this.editIndex);
		        _this.editIndex = undefined;
		        return true;
		    } else {
		        return false;
		    }
		}
		this.gridLoad=function(){
			$('#'+_this.id).datagrid("clearSelections");
			$('#'+_this.id).datagrid("reload");
			_this.editIndex=undefined;
		}
		this.addRow=function(){
		   if (_this.endEditing()) {
		        $('#'+_this.id).datagrid('appendRow', { status: 'P' });
		        _this.editIndex = $('#'+_this.id).datagrid('getRows').length - 1;
		        $('#'+_this.id).datagrid('selectRow', _this.editIndex)
		            .datagrid('beginEdit', _this.editIndex);
		   }
		}
	}
	var initRegSearchConfigGridFlag=1;
	function accomRegNoSearchConfig(){
	    if(initRegSearchConfigGridFlag==1){
		  initRegSearchConfigGrid();
		  initRegSearchConfigDialog();
		  initRegSearchConfigGridFlag=0;    
		}else{
			$("#regSearchConfigGrid").datagrid("reload");
		}
        $HUI.dialog("#regSearchConfigDialog").open();
	}
	function initRegSearchConfigDialog(){ //初始化医嘱弹框
		  $HUI.dialog('#regSearchConfigDialog',{
			width:300,
			modal:true,
			height:600,
			closed:true,
			title:'登记号查询设置',
			iconCls:'icon-w-config',
			buttons:[{
				text:'保存',
				handler:function(){
					saveRegSearchConfigData();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog("#regSearchConfigDialog").close();
				}
			}],
			onClose:function(){
				$("#groupSearch").searchbox("setValue","");
				$("#regSearchConfigGrid").datagrid("unselectAll");
			}
		 }); 
	 }
	function initRegSearchConfigGrid(){
		$("#regSearchConfigGrid").datagrid({
			mode: 'remote',
			fit:true,
			border:false,
			pagination:false,
			showPageList:false,
			
			showRefresh:false,
			singleSelect:false,
			headerCls:'panel-header-gray',
			idField:'SSGRPRowId',
			split:true,
			columns: [[
				{field:"SSGRPRowId",title:"",checkbox:'true'},
				{field:"SSGRPDesc",title:"安全组",align:"left",width:220,
	            }
			]],
			url : $URL+"?ClassName=web.DHCBL.CT.SSGroup&QueryName=GetList&activeflag=Y&rows=99999",
			onBeforeLoad:function(param){
				$("#regSearchConfigGrid").datagrid("unselectAll");
				param.rowid="";
				param.desc=$("#groupSearch").searchbox("getValue");
				param.hospid=$HUI.combogrid('#_HospList').getValue();
			},
			onLoadSuccess:function(){
				var rows=$('#regSearchConfigGrid').datagrid('getRows');
				for (var i=0;i<_GV.regSearchAllInPatGroup.split("^").length;i++){
					var groupId=_GV.regSearchAllInPatGroup.split("^")[i];
					if (groupId=="") continue;
					var index =$('#regSearchConfigGrid').datagrid('getRowIndex',groupId);
					if (index>=0){
						$('#regSearchConfigGrid').datagrid('selectRow',index);
					}
				}
			}
     	});
	}
	function saveRegSearchConfigData(){
		var selRows=$("#regSearchConfigGrid").datagrid("getSelections");
		var inGroupStr=""
		if(selRows.length>0){
			var array=[];
			selRows.forEach(function(val,index){
				var value=val.SSGRPRowId;			
				array.push(value);	
			})
			inGroupStr=array.join("^");	
		}	
		var rows=$('#regSearchConfigGrid').datagrid('getRows');
		var outGroupStr="";
		for (var i=0;i<rows.length;i++){
			var ID=rows[i].SSGRPRowId;
			if ($.hisui.indexOfArray(selRows,"SSGRPRowId",ID)<0) {
				if (outGroupStr == "") outGroupStr = ID;
				else  outGroupStr = outGroupStr + "^" + ID;
			}
		}
		var rtn=$m({
			ClassName:'Nur.HISUI.AccompanyConfig',
		    MethodName:'saveRegSearchAllInPatGroup',
		    inGroupStr:inGroupStr,
		    outGroupStr:outGroupStr,
		    hospId:$HUI.combogrid('#_HospList').getValue()
	    },false)
		if(rtn==0){
			$.messager.popover({msg:"保存成功！",type:"success"});
			loadRegSearchAllInPatGroup();
			$HUI.dialog("#regSearchConfigDialog").close();
		}else{
			$.messager.popover({msg:"保存失败",type:"error"});
		}
	}
	function groupSearchClick(){
		$("#regSearchConfigGrid").datagrid("reload");
	}
	function loadRegSearchAllInPatGroup(){
	   _GV.regSearchAllInPatGroup=$m({
		   ClassName:'Nur.HISUI.AccompanyConfig',
           MethodName:'getRegSearchAllInPatGroup',
           hospId:$HUI.combogrid('#_HospList').getValue()
       },false);
   }
	Init();  //入口
})