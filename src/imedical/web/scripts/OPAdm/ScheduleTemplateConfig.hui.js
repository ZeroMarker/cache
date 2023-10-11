var TemplateConfigDataGrid;
var editRow = undefined;
var PageLogicObj={
	PreOrderListDataGridEditRow:undefined,
	PreOrderListDataGrid:"",
	PreDiagnoseListDataGridEditRow:undefined,
	PreDiagnoseListDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	TemplateConfigTabGridLoad();
});
function Init(){
}
function TemplateConfigTabGridLoad(){
	var PrescriptTypeToolBar = [{
            text: '���',
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
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = TemplateConfigDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
       					       $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
					        }else{
						       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						       return false;
					        }
					        editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                editRow = undefined;
                TemplateConfigDataGrid.datagrid("rejectChanges");
                TemplateConfigDataGrid.datagrid("unselectAll");
				RowID="";
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=TemplateConfigDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = TemplateConfigDataGrid.datagrid('getEditors', editRow);
				var Code = editors[0].target.val();
				if(Code==""){
					$.messager.alert('��ʾ',"���벻��Ϊ��");
					return false;
				};
				var Desc=editors[1].target.val();
				if(Desc==""){
					$.messager.alert('��ʾ',"��������Ϊ��");
					return false;
				};
				var Type=editors[2].target.combobox('getValue');
				if(!Type){
					$.messager.alert('��ʾ',"���Ͳ���Ϊ��!");
					return false;
				};
				var STCFatherCode=editors[3].target.val();
				if((STCFatherCode=="")&&(Type=="sub")){
					$.messager.alert('��ʾ',"����д�����ݵĴ���");
					return false;
				};
				var STCDataTemp=editors[4].target.val();
				
				var STCDataTempDesc=editors[5].target.val();
				var STCDataTempGlobal=editors[6].target.val();
				if ((Type=="combobox-data")&&((STCDataTemp=="")||(STCDataTempDesc==""))){
					$.messager.alert('��ʾ',"����д�����Ĺ�������Ϣ");
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
					   $.messager.show({title:"��ʾ",msg:"����ɹ�"});
					}else{
					   $.messager.alert('��ʾ',"����ʧ��:"+value);
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
					   $.messager.show({title:"��ʾ",msg:"�����ɹ�"});
					}else{
					   $.messager.alert('��ʾ',"����ʧ��:"+value);
					   return ;
					}
				}
					editRow = undefined;
			 }
			}
		}
		,{
	       text: 'Ԥ�ɷ�ҽ��',
            iconCls: 'icon-write-order',
            handler: function() {
				$("#PreOrderList-dialog").dialog("open");
				InitPreOrderList()
				SessionServerListDataGridLoad("Order")
            } 
	    },{
	       text: 'Ԥ�����',
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
					{ field: 'STCCode', title:'����', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
        			{ field: 'STCDesc', title: '����', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCType', title: '����', width: 100, align: 'center', sortable: true,
					    editor :{  
							type:'combobox',  
							options:{
								//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetLimitType",
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"text","Desc":"�ı�"},{"ID":"checkbox","Desc":"��ѡ��"},{"ID":"combobox-sub","Desc":"���������������"},{"ID":"combobox-data","Desc":"����������ֵ��"},{"ID":"sub","Desc":"������"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"text","Desc":"�ı�"},{"ID":"checkbox","Desc":"��ѡ��"},{"ID":"combobox-sub","Desc":"���������������"},{"ID":"combobox-data","Desc":"����������ֵ��"},{"ID":"sub","Desc":"������"}]  
									return data;
								}
							  }
     					},
     					formatter:function(value,record){
				 			return record.STCTypeDesc;
				 		}
					},
					{ field: 'STCFatherCode', title: '�����������', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCDataTemp', title: '��ϵ�ֵ��', width: 100, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCDataTempDesc', title: '��ϵ�ֵ�������ֶ�', width: 80, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'STCDataTempGlobal', title: '��ϵ�ֵ��Global', width: 80,hidden:true,align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{field:'STCDataMultCheck',title:'��ѡ��',width:100, editor : {
			                type : 'icheckbox',
			                options : {
			                    on : "��",
			                    off : '��'
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
				 			if (value=="Y") return "��";
				 			else  return "��";
				 		}
					},
					{ field: 'STCDataHospShow', title: '��ϵ�ֵ�����ҽԺ���ʽ(�̶�����:ROWID,HospId)', width: 280, align: 'center', sortable: true,
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
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
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
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
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
            text: '����',
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
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.PreOrderListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        SessionServerListDataGridLoad("Order")	
								}
	                        }else{
								PageLogicObj.PreOrderListDataGridEditRow = undefined;
                				PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
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
                PageLogicObj.PreOrderListDataGridEditRow = undefined;
                PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.PreOrderListDataGridEditRow != undefined){
		            var ArcimSelRow=PageLogicObj.PreOrderListDataGrid.datagrid("selectRow",PageLogicObj.PreOrderListDataGridEditRow).datagrid("getSelected"); 
		           	var ArcimRowID=ArcimSelRow.ARCIMDR
		           	if (!ArcimRowID){
						$.messager.alert("��ʾ","��ѡ��ҽ��!");
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
						$.messager.popover({msg: '����ɹ�',type:'success'});
				        SessionServerListDataGridLoad("Order")	
				        PageLogicObj.PreOrderListDataGridEditRow = undefined;
                		PageLogicObj.PreOrderListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");	
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
	 ///��ҩ��ʽ�б�columns ����ҽ�������տ���
    var CNMedCookArcModeColumns=[[   
    				{field:'RowID',hidden:true},
					{field:'ARCIMDR',hidden:true},
					{field:'ARCITMDesc',title:'ҽ��������', width: 20,
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
								value:'',//ȱʡֵ 
								mode:'remote',
								pagination : true,//�Ƿ��ҳ   
								rownumbers:true,//���   
								collapsible:false,//�Ƿ���۵���   
								fit: true,//�Զ���С   
								pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
								pageList: [10],//��������ÿҳ��¼�������б�  
								url:$URL+"?ClassName=web.DHCBL.DHCRBResource.DHCRBResourceBuilder&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'����',width:310,sortable:true},
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
	// ��ҩ��ʽ�б�Grid
	PageLogicObj.PreOrderListDataGrid=$('#PreOrderList').datagrid({  
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
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.PreOrderListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.PreOrderListDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.PreOrderListDataGridEditRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
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
	///��ҩ��ʽ
	 var CNMedCookArcModeToolBar = [{
            text: '����',
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
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.PreDiagnoseListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        SessionServerListDataGridLoad("Diag")	
								}
	                        }else{
								PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                				PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
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
                PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.PreDiagnoseListDataGridEditRow != undefined){
		            var ArcimSelRow=PageLogicObj.PreDiagnoseListDataGrid.datagrid("selectRow",PageLogicObj.PreDiagnoseListDataGridEditRow).datagrid("getSelected"); 
		           	var MRCDIADR=ArcimSelRow.MRCDIADR
		           	if (!MRCDIADR){
						$.messager.alert("��ʾ","��ѡ�����!");
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
						$.messager.popover({msg: '����ɹ�',type:'success'});
				        SessionServerListDataGridLoad("Diag")	
				        PageLogicObj.PreDiagnoseListDataGridEditRow = undefined;
                		PageLogicObj.PreDiagnoseListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
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
	 ///��ҩ��ʽ�б�columns ����ҽ�������տ���
    var CNMedCookArcModeColumns=[[   
    				{field:'RowID',hidden:true},
					{field:'MRCDIADR',hidden:true},
					{field:'MRCDIADesc', title:'�������',width: 20,
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
								value:'',//ȱʡֵ 
								mode:'remote',
								pagination : true,//�Ƿ��ҳ   
								rownumbers:true,//���   
								collapsible:false,//�Ƿ���۵���   
								fit: true,//�Զ���С   
								pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
								pageList: [10],//��������ÿҳ��¼�������б�  
								url:$URL+"?ClassName=web.DHCDocDiagnosEntryV8&QueryName=LookUpWithAlias",
	                            columns:[[
	                                {field:'desc',title:'����',width:310,sortable:true},
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
	// ��ҩ��ʽ�б�Grid
	PageLogicObj.PreDiagnoseListDataGrid=$('#PreDiagnoseList').datagrid({  
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
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.PreDiagnoseListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.PreDiagnoseListDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.PreDiagnoseListDataGridEditRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
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
