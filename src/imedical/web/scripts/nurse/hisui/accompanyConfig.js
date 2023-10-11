
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
	function initGrid(){  //�����ñ��
		var toolbarConfig = [{
	        text: '����',
	        iconCls: 'icon-add',
	        handler: addRow
	    }, {
	        text: 'ɾ��',
	        iconCls: 'icon-cancel',
	        handler: deleteRow
	    }, {
	        text: '����',
	        iconCls: 'icon-save',
	        handler: saveRow
	    },'-',{
	        text: '�㻤ҽ������',
	        iconCls: 'icon-batch-cfg',
	        handler: accomOrderConfig
	    },'-',{
		    id:"accomRegNoSearchConfig",
	        text: '�ǼǺŲ�ѯ����',
	        iconCls: 'icon-batch-cfg',
	        handler: accomRegNoSearchConfig
	    }/*,'-',{
	        text: '�ظ�����㻤��Ա��ʾ����',
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
			loadMsg : '������..',  
			rownumbers : true,
			idField:"id",
			toolbar:toolbarConfig,
			columns :[[{field:'colType',title:'����',width:150,
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
	                            missingMessage:"��ѡ�����ͣ�"
		                    }
		                },
		              },
			          {field:'colCode',title:'����',width:100,
			           editor:{
				          type:'validatebox',
				          options:{
					        required:true,
					        missingMessage:"��������"    
					      }    
				       }
				      },
			          {field:'colDesc',title:'����',width:100,
			            editor:{
				          type:'validatebox',
				          options:{
					        required:true,
					        missingMessage:"��������"    
					      }    
				       }
			          },
			          {field:'colFunc',title:'����',width:350,editor: 'validatebox'},
			          {field:'colDataType',title:'Ԫ������',width:100,
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
	                            missingMessage:"��ѡ��Ԫ�����ͣ�"
		                    }
		                },
		                
		              },
			          {field:'colValue',title:'ѡ��',width:200,
			            editor:{
				           type:"validatebox",
				        }
			          },
			          {field:'colWidth',title:'���',width:100,editor: 'numberbox'},
			          {field:'colDefaultVal',title:'Ĭ��ֵ',width:100,editor: 'validatebox'},
			          //{field:'colWarning',title:'Ԥ��ֵ',width:100,editor: 'validatebox'},
			          {field:'colOrder',title:'˳���',width:100,
			            editor: {
				          type:"numberbox",
				          options:{
					        required:true,
					        missingMessage:"˳��ű��"    
					      } 
				        }
			          },
			          {field:'colUsing',title:'״̬',width:60,
			            editor: {
		                    type: 'checkbox',
		                    options:{
			                    on:'Y',
			                    off:'N'
			                }
			            },
			            formatter:function(value){
				          if(value!=""){
					         return  value=="Y"?"����":"ͣ��" ; 
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
	   $(".datagrid-toolbar>table:first>tbody>tr:last-child").append("<div class='datagrid-btn-separator'>&nbsp;</div>"); //���|�ָ���
	   $(".datagrid-toolbar>table:first>tbody>tr:last-child").append($("#readAccomInfoDiv"));  //������ֺ�switch�ؼ�
	   $('#accomRegNoSearchConfig').after($('<a></a>').linkbutton({
	        plain:true,
	        iconCls:'icon-help'
	    }).tooltip({
	        content:"������Ȩ�޸��ݻ��ߵǼǺŲ�ѯȫԺסԺ���ߵİ�ȫ��"
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
	   $("#opType").combobox('setValue',"P");  //����ά�����Ͳ�Ĭ����Ա�Ǽ�
	   var ifReadAccomInfo=$m({
		   ClassName:'Nur.HISUI.AccompanyConfig',
           MethodName:'getOnceConfig',
           type:'readAccomInfo',
           hospId:$HUI.combogrid('#_HospList').getValue()
       },false);
	   if(ifReadAccomInfo=="false"){   //�ⲿswitch�л�
		   $("#readAccomInfo").switchbox('toggle');
	   } 
	   loadRegSearchAllInPatGroup();
	}
	function gridLoad(){  //���������ñ��
		$('#accomGrid').datagrid("clearSelections");
		$('#accomGrid').datagrid("reload");
		editIndex=undefined;
	}
	var editIndex = undefined; //���ڱ༭��������
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
	function onDblClickRow(index,row) {//˫����ʼ�༭��ΪcolValue�����placeHolder
	    if (editIndex != index) {
	        if (endEditing()) {
	            $('#accomGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
	            editIndex = index;
	        } else {
	            $('#accomGrid').datagrid('selectRow', editIndex);
	        }
	        var target=$('#accomGrid').datagrid('getEditor',{'index':editIndex,'field':'colValue'}).target;
	        $(target).attr("placeHolder","���ѡ����&�ָ�");
	    }
	}
    function addRow(){  //�����
	   if (endEditing()) {
	        $('#accomGrid').datagrid('appendRow', { status: 'P' });
	        editIndex = $('#accomGrid').datagrid('getRows').length - 1;
	        $('#accomGrid').datagrid('selectRow', editIndex)
	            .datagrid('beginEdit', editIndex);
	        var target=$('#accomGrid').datagrid('getEditor',{'index':editIndex,'field':'colValue'}).target;
	        $(target).attr("placeHolder","���ѡ����&�ָ�");
	   }
	}
    function deleteRow(){  //ɾ����
	    var selectRow=$("#accomGrid").datagrid('getSelected');
	    if(!selectRow){
		    $.messager.popover({msg:"��ѡ����Ҫɾ�����У�",type:"alert"});
		    return;
		}else if(!selectRow.id){
			$.messager.popover({msg:"û�б��治��Ҫɾ����",type:"alert"});
		    return;
	    }else{
		    $.messager.confirm('ȷ�϶Ի���', "�Ƿ�ȷ��ɾ��?", function(r){
				if (r){
				   $m({
					    ClassName:_GV.ClassName,
					    MethodName:"deleteRow",
						id:selectRow.id
					},function(ret){
						if(ret!=""){
					        $.messager.popover({msg:ret,type:"error"});
					    }else{
						    $.messager.popover({msg:"ɾ���ɹ���",type:"success"});
						    gridLoad();
						}
					})
				}
			});
		}
	}
    function saveRow(){  //����������
	    if (endEditing()) {
            saveLink();
            $('#accomGrid').datagrid('acceptChanges');
        }    
	}
	function saveLink() { //����������
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
		     $.messager.popover({msg:"����ɹ���",type:"success"});
		     gridLoad();
		 }
    }
    function InitHospList(){  //����Ժ��
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
    function accomOrderConfig(){  //����ҽ������
	    if(firstOrder==1){
		  var orderEditor=new editor("OrderConfigGrid");
		  initOrderConfigDialog(orderEditor);
		  firstOrder=0;    
		}
        $HUI.dialog("#OrderConfigDialog").open();
	}
	var firstAlert=1;  //�����ظ���������
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
    function initOrderConfigDialog(orderEditor){ //��ʼ��ҽ������
	  $HUI.dialog('#OrderConfigDialog',{
		width:550,
		modal:true,
		height:350,
		closed:true,
		title:'�㻤ҽ������',
		iconCls:'icon-w-config',
		/*buttons:[{
			text:'�ر�',
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
			        text: '����',
			        iconCls: 'icon-add',
			        handler: orderEditor.addRow
			    }, {
			        text: 'ɾ��',
			        iconCls: 'icon-cancel',
			        handler: deleteOrderConfigRow
			    }],
				columns: [[
					{field:"ArcimID",title:"ҽ����ID",align:"center",width:130},
					{field:"ArcimDesc",title:"ҽ������",align:"left",width:380,
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
			                        { field: 'id', title: 'ҽ����ID', width: 80 },
			                        { field: 'desc', title: 'ҽ������', width: 300 }
			                    ]],
			                    onSelect: function (rowIndex, rowData) {
			                        var arcimBeforeTrans = $('#OrderConfigGrid').datagrid('getData');
			                          var ifExit =false;
			                         arcimBeforeTrans.rows.forEach(function (row) {	     //�ж��Ƿ��ظ�           
				                        if(row.ArcimID == rowData.id){
			                            	ifExit=true ;
			                            	return false;
				                        }
			                        })
			                        if (ifExit) {
			                            $.messager.popover({ msg: 'ҽ�����Ѵ��ڣ�', type: 'alert', timeout: 2000 });
			                        }else{
				                        var selected=$('#OrderConfigGrid').datagrid('getSelected');
				                        selected.ArcimID=rowData.id;
				                        saveOrderConfigData(selected.ID);  //�Զ�����
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
				onDblClickRow:function(index,row) {  //˫���༭
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
     	function saveOrderConfigData(ID){ //����ҽ�����÷���
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
					 $.messager.popover({msg:"����ɹ���",type:"success"});
				 }
				orderEditor.gridLoad();
				$('#OrderConfigGrid').datagrid('acceptChanges');
			}   
		}
		 function deleteOrderConfigRow(){   //ɾ��ҽ�����÷���
		    var selectRow=$("#OrderConfigGrid").datagrid('getSelected');
		    if(!selectRow){
			    $.messager.popover({msg:"��ѡ����Ҫɾ�����У�",type:"alert"});
			    return;
			}else if(!selectRow.ArcimID){
				$.messager.popover({msg:"û�б��治��Ҫɾ����",type:"alert"});
			    return;
		    }else{
			    $.messager.confirm('ȷ�϶Ի���', "�Ƿ�ȷ��ɾ��?", function(r){
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
							    $.messager.popover({msg:"ɾ���ɹ���",type:"success"});
							   orderEditor.gridLoad();
							}
						})
					}
				});
			}
		} 
	}
  function initAlertConfigDialog(alertEditor){   //��ʼ����ʾ����
	  $HUI.dialog('#AlertConfigDialog',{
		width:540,
		modal:true,
		height:350,
		closed:true,
		title:'��ʾ������д�ֶ�',
		iconCls:'icon-gear-gray',
		buttons:[{
			text:'�ر�',
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
			        text: '����',
			        iconCls: 'icon-add',
			        handler: alertEditor.addRow
			    }, {
			        text: 'ɾ��',
			        iconCls: 'icon-cancel',
			        handler: deleteAlertConfigRow
			    }],
				columns: [[
					{field:"type",title:"����",align:"center",width:245,
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
	                            missingMessage:"��ѡ�����ͣ�",
	                            onSelect:function(record){
		                            var target=$("#AlertConfigGrid").datagrid('getEditor',{'index':alertEditor.editIndex,'field':'desc'}).target;
		                            target.combobox('clear');
		                            var colTypeDesc=$cm({ClassName:_GV.ClassName,
									                     QueryName:"findColTypeAndDesc",
									                     ResultSetType:"array",
									                     hospId:$HUI.combogrid('#_HospList').getValue(),
									                     opType:$("#opType").combobox('getValue'),
									                     colTypeFilter:record.ID},false);
								
		                            target.combobox('loadData',colTypeDesc); //���ݲ�ͬ����Ϣ���ʹ�����Ӧ����
		                        }
		                    }
		                },
					},
					{field:"desc",title:"����",align:"center",width:245,
					  	editor: {
		                    type: 'combobox',
		                    options: {
		                        valueField: 'colCode',
		                        textField: 'colDesc',
		                        required: true,
								panelHeight:"auto",
		                 		editable:false,
		                		enterNullValueClear:false,
	                            missingMessage:"��ѡ����Ҫ��д����Ŀ��",
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
			                            $.messager.popover({ msg: '��Ŀ�Ѵ��ڣ�', type: 'alert', timeout: 2000 });
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
     	function saveAlertConfigData(ID){  //������ʾ���÷���
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
					 $.messager.popover({msg:"����ɹ���",type:"success"});
				 }
				alertEditor.gridLoad();
				$('#AlertConfigGrid').datagrid('acceptChanges');
			}   
		}
		function deleteAlertConfigRow(){  //ɾ����ʾ���÷���
		    var selectRow=$("#AlertConfigGrid").datagrid('getSelected');
		    if(!selectRow){
			    $.messager.popover({msg:"��ѡ����Ҫɾ�����У�",type:"alert"});
			    return;
			}else if(!selectRow.ID){
				$.messager.popover({msg:"û�б��治��Ҫɾ����",type:"alert"});
			    return;
		    }else{
			    $.messager.confirm('ȷ�϶Ի���', "�Ƿ�ȷ��ɾ��?", function(r){
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
							    $.messager.popover({msg:"ɾ���ɹ���",type:"success"});
							    alertEditor.gridLoad();
							}
						})
					}
				});
			}
		} 
	}
	function editor(id){   //�༭�ɱ༭��
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
	function initRegSearchConfigDialog(){ //��ʼ��ҽ������
		  $HUI.dialog('#regSearchConfigDialog',{
			width:300,
			modal:true,
			height:600,
			closed:true,
			title:'�ǼǺŲ�ѯ����',
			iconCls:'icon-w-config',
			buttons:[{
				text:'����',
				handler:function(){
					saveRegSearchConfigData();
				}
			},{
				text:'�ر�',
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
				{field:"SSGRPDesc",title:"��ȫ��",align:"left",width:220,
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
			$.messager.popover({msg:"����ɹ���",type:"success"});
			loadRegSearchAllInPatGroup();
			$HUI.dialog("#regSearchConfigDialog").close();
		}else{
			$.messager.popover({msg:"����ʧ��",type:"error"});
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
	Init();  //���
})