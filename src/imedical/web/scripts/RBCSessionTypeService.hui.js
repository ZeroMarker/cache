var PageLogicObj={
	m_SessionTypeListDataGrid:"",
	m_SessionServerListDataGrid:"",
	editRow2:"",
	dialog1:"",
	PreOrderListDataGridEditRow:undefined,
	PreOrderListDataGrid:"",
	PreDiagnoseListDataGridEditRow:undefined,
	PreDiagnoseListDataGrid:""
};
$(function(){
	var hospComp = GenHospComp("DHC_RBCSessionTypeService");
	hospComp.jdata.options.onSelect = function(e,t){
		SessionTypeListDataGridLoad();
		InitSessionServerListDataGrid();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//ҳ�����ݳ�ʼ��
		Init();
		//���عҺ�ְ��
		SessionTypeListDataGridLoad();
		InitTip();
	}	
});
function Init(){
	$("#tipContent").css('width',$("#tipContent").parent().width()-32);
	PageLogicObj.m_SessionTypeListDataGrid=InitSessionTypeListDataGrid();
	PageLogicObj.m_SessionServerListDataGrid=InitSessionServerListDataGrid();
	$("#cmd_OK").click(SaveExcludeAdmReason);
}
function InitSessionTypeListDataGrid(){
	var Columns=[[
		{field:'ID',hidden:true},
		{field:'Desc',title:'�Һ�ְ��',width:280,align:'center'}
    ]];
	var SessionTypeListDataGrid=$("#SessionTypeList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'ID',
		columns :Columns,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
			SessionServerListDataGridLoad("OrderNorm");
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return SessionTypeListDataGrid;
}
function SessionTypeListDataGridLoad(){
	$.q({
	    ClassName : "web.DHCBL.BaseReg.BaseDataQuery",
	    QueryName : "RBCSessionTypeQuery",
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_SessionTypeListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_SessionTypeListDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
	}); 
}
function InitSessionServerListDataGrid(){
	var RegServiceGroup= $m({
	    ClassName : "web.DHCOPRegConfig",
	    MethodName : "GetSpecConfigNode",
	    NodeName : "RegServiceGroup",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
	///SERRowId:%String,ARCIMDR:%String,ARCITMDesc:%String
	var SeviceQueryData = $cm({
	    ClassName : "web.DHCRBResource",
	    QueryName : "SeviceQuery",
	    RegServiceGroupRowId : RegServiceGroup,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:99999,rows:99999
	},false);
	var Columns=[[
		{field:'SERRowId',hidden:true},
		{field:'ARCIMDR',hidden:true},
		{field:'ARCITMDesc',title:'ҽ��������',width:300,align:'center', 
        	editor:{
		    	type:'combogrid',
		    	options:{
		    		required: true,
		        	panelWidth:450,
					panelHeight:350,
                    idField:'ID',
                    textField:'Desc',
                    value:'',//ȱʡֵ 
                    mode:'remote',
					pagination : false,//�Ƿ��ҳ   
					rownumbers:true,//���   
					collapsible:false,//�Ƿ���۵���   
					fit: true,//�Զ���С   
					pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
					pageList: [10],//��������ÿҳ��¼�������б�  
					data:SeviceQueryData,
                    columns:[[
                        {field:'Desc',title:'����',width:300,sortable:true},
	                    {field:'ID',title:'ID',hidden:true},
						{field:'Price',title:'���',width:120,sortable:true}
                     ]],
					 keyHandler:{
						up: function () {
			                //ȡ��ѡ����
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //ȡ��ѡ���е�rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //�����ƶ�����һ��Ϊֹ
			                    if (index > 0) {
			                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
			                    }
			                } else {
			                    var rows = $(this).combogrid('grid').datagrid('getRows');
			                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
			                }
			             },
			             down: function () {
			               //ȡ��ѡ����
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //ȡ��ѡ���е�rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //�����ƶ�����ҳ���һ��Ϊֹ
			                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
			                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
			                    }
			                } else {
			                    $(this).combogrid('grid').datagrid('selectRow', 0);
			                }
			            },
						left: function () {
							return false;
			            },
						right: function () {
							return false;
			            },            
						enter: function () { 
			                //ѡ�к������������ʧ
			                $(this).combogrid('hidePanel');
							$(this).focus();
			            }
        			},
					onSelect : function(rowIndex, rowData) {
						var ArcimSelRow=PageLogicObj.m_SessionServerListDataGrid.datagrid("selectRow",PageLogicObj.editRow2).datagrid("getSelected"); 
						var oldInstrArcimId=ArcimSelRow.ARCIMDR;
						if (parseInt(rowData.Price)==0){
							$.messager.confirm("��ʾ", "<i>100%�ۿۡ���Һŷѡ�������</i>�ȹ�����0����ҽ�����ͻ���������ʱ�Ի����0����ҽ������ȷ����Ҫ��Ӵ�ҽ������",
								function(r) {
									if (r) {
										ArcimSelRow.ARCIMDR=rowData.ID;
									}else{
										PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
										PageLogicObj.editRow2 = "";
										SessionServerListDataGridLoad("OrderNorm");
									}
								}
							)
						}else{
							ArcimSelRow.ARCIMDR=rowData.ID;
						}
					}
        		}
        	}
       },
	   {field:'OtherAdmReason',title:'����ѱ�',width:300}
    ]
    ];
    var ToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
            	var rows = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelections");
                if (rows.length == 0){
	                $.messager.alert("��ʾ", "��ѡ��һ��Ҫά���ĹҺ�ְ��", "error"); 
	                return false;
	            }
                PageLogicObj.editRow2 = "";
                PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges");
                PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll");

                if (PageLogicObj.editRow2 != "") {
                    PageLogicObj.m_SessionServerListDataGrid.datagrid("endEdit", PageLogicObj.editRow2);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    PageLogicObj.m_SessionServerListDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    PageLogicObj.m_SessionServerListDataGrid.datagrid("beginEdit", 0);
                    //����ǰ�༭���и�ֵ
                    PageLogicObj.editRow2 = 0;
                }
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = PageLogicObj.m_SessionServerListDataGrid.datagrid("getSelections");
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
	                            if (!rows[i].SERRowId){
		                            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges");
					                PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll");
					                PageLogicObj.editRow2 = "";
					                return;
		                        }
                                ids.push(rows[i].SERRowId);
                                var entityInfo=["ID="+rows[i].SERRowId,
									"SERParRef="+rows[i].SERRowId,
									"SERRBCServiceDR="+rows[i].ARCIMDR
                				];
								var resource=Card_GetEntityClassInfoToXML(entityInfo);
                                $cm({
									ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
									MethodName:"RBResourceServerDelete",
									Infostr:resource
								 },function(value){
									 if(value=="0"){
										//PageLogicObj.m_SessionServerListDataGrid.datagrid('load');
										PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
										SessionServerListDataGridLoad("OrderNorm");
			           					
			           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
									}else{
										$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
									}
									PageLogicObj.editRow2 = "";
								});
                            }
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },{
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
              var rows = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelections");
               if (rows.length > 0)
               { 
       				var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].ID);
                    }
                    var SessionTypeList=ids.join(',');
	                if (PageLogicObj.editRow2 !== ""){
						if(SessionTypeList=="") return false;
						var SaveSelRow=PageLogicObj.m_SessionServerListDataGrid.datagrid("selectRow",PageLogicObj.editRow2).datagrid("getSelected"); 
						//var editors = PageLogicObj.m_SessionServerListDataGrid.datagrid('getEditors', PageLogicObj.editRow2); 
						var ARCIMDR=SaveSelRow["ARCIMDR"];
						var SERRowId=SaveSelRow["SERRowId"];
						if (typeof SERRowId=="undefined"){
							SERRowId="";
						}
						if ((ARCIMDR=="")||(ARCIMDR==undefined)){
							$.messager.alert("��ʾ","��ѡ��ҽ����!");
	                        return false;
						}
	                	
			            var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");	  
    					var SERParRef=select.ID;
    					var entityInfo=["ID="+SERRowId,
							"SERParRef="+SERParRef,
							"SERRBCServiceDR="+ARCIMDR,
							"HospID="+$HUI.combogrid('#_HospList').getValue(),
							"SERType="+"OrderNorm",
							"SERDiagnoseDr="
			            ];
			            var resource=Card_GetEntityClassInfoToXML(entityInfo);
                        $cm({
							ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
							MethodName:"RBResourceServerSave",
							Infostr:resource,
							dataType:"text"
						 },function(value){
							 if(value=="0"){
								PageLogicObj.m_SessionServerListDataGrid.datagrid("endEdit", PageLogicObj.editRow2);
								PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid('unselectAll');
								PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
								var data=PageLogicObj.m_SessionServerListDataGrid.datagrid("getData");
								for (var i=data["rows"].length-1;i>=0;i--){
									PageLogicObj.m_SessionServerListDataGrid.datagrid('deleteRow',i);
								}
								SessionServerListDataGridLoad("OrderNorm");
	           					$.messager.show({title:"��ʾ",msg:"��ӳɹ�"});
							}else{
								$.messager.alert('��ʾ',"���ʧ�ܣ�"+value);
								return;
							}
							PageLogicObj.editRow2 = "";
						});
	                }
	            
	             }else{
		            $.messager.alert("��ʾ", "��ѡ��һ��Ҫά���ĹҺ�ְ��", "error"); 
		         }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                PageLogicObj.editRow2 = "";
                SessionServerListDataGridLoad("OrderNorm");
            }
        },'-',{
	       text: '����ķѱ�',
            iconCls: 'icon-edit',
            handler: function() {
			    var select = PageLogicObj.m_SessionServerListDataGrid.datagrid("getSelected");
			    if (!select){
					$.messager.alert("��ʾ","��ѡ��ҽ����!");
	            	return false;
				}	  
	            var SERRowId=select["SERRowId"];
	            if ((SERRowId=="")||(SERRowId==undefined)){
		            $.messager.alert("��ʾ","�뱣�����ά��!");
	            	return false;
		        }
                ExcludeAdmReason(SERRowId);
            } 
	    },{
	       text: 'Ԥ�ɷ�ҽ��',
            iconCls: 'icon-write-order',
            handler: function() {
			    var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
			    if (!select){
					$.messager.alert("��ʾ","��ѡ��Һ�ְ��!");
	            	return false;
				}
				$("#PreOrderList-dialog").dialog("open");
				var ID=select.ID;
				InitPreOrderList()
				SessionServerListDataGridLoad("OrderPre")
            } 
	    },{
	       text: 'Ԥ�����',
            iconCls: 'icon-add-diag',
            handler: function() {
			    var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
			    if (!select){
					$.messager.alert("��ʾ","��ѡ��Һ�ְ��!");
	            	return false;
				}
				$("#PreDiagnoseList-dialog").dialog("open");	
				InitOrderDiagList()
				SessionServerListDataGridLoad("OrderDiag")  
            } 
	    }
	    ];
    
	var SessionServerListDataGrid=$("#SessionServerList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'SERRowId',
		columns : Columns,
		toolbar : ToolBar,
		onDblClickRow:function(rowIndex, rowData){
            if (PageLogicObj.editRow2!=="") {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������", "error");
		        return false;
			}
			PageLogicObj.m_SessionServerListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow2=rowIndex;
	    },
	    onLoadSuccess:function(data){
		    PageLogicObj.editRow2="";
		    $(this).datagrid("unselectAll");
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	SessionServerListDataGrid.datagrid("unselectAll").datagrid('loadData', { total: 0, rows: [] });  
	return SessionServerListDataGrid;
}
function SessionServerListDataGridLoad(Type){
	var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
	if (!select)  return false;
    var ID=select.ID;
    
    if (Type=="OrderNorm"){
	    var pageSizeArr=PageLogicObj.m_SessionServerListDataGrid.datagrid("options").pageSize
	}else if(Type=="OrderPre"){
		 var pageSizeArr=PageLogicObj.PreOrderListDataGrid.datagrid("options").pageSize   
	}else if(Type=="OrderDiag"){
		var pageSizeArr=PageLogicObj.PreDiagnoseListDataGrid.datagrid("options").pageSize	  
			  
			  }
	$.q({
	    ClassName : "web.DHCRBResource",
	    QueryName : "QuerySessionServer",
	    SerParRef : ID,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Type:Type,
	    Pagerows:PageLogicObj.m_SessionServerListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		if (Type=="OrderNorm"){
			PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
		}else if(Type=="OrderPre"){
			PageLogicObj.PreOrderListDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
		}else if(Type=="OrderDiag"){
			PageLogicObj.PreDiagnoseListDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
		}
		
	}); 
}

function ExcludeAdmReason(SERRowId){
	//IInstrAutoLinkOrdExcludePrior
	$("#excludeAdmReason").val(SERRowId);
	$("#dialog-AdmReasonSelect").css("display", ""); 
	PageLogicObj.dialog1 = $("#dialog-AdmReasonSelect" ).dialog({
      autoOpen: false,
      height: 400,
      width: 300,
      modal: true
    });
	PageLogicObj.dialog1.dialog("open");
	$("#List_AdmReason").html("");
	$.q({
	    ClassName : "web.DHCRBResource",
	    QueryName : "FindAdmReason",
	    SERRowId : SERRowId,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},function(Data){
		var ListArr=new Array();
		jQuery.each(Data.rows, function(i, n) { 
			if (n.SelFlag==1){
				ListArr[ListArr.length]= "<option value=" + n.AdmReason + " Selected="+ n.SelFlag+">" + n.AdmReasonDesc + "</option>"; 
			}else{
				ListArr[ListArr.length]= "<option value=" + n.AdmReason + ">" + n.AdmReasonDesc + "</option>"; 
			}
		});
		$("#List_AdmReason").append(ListArr.join(""));
	}); 
}
function SaveExcludeAdmReason(){
	var SERRowId=$("#excludeAdmReason").val();
	var AdmReasonStr="";
   var size = $("#List_AdmReason"+ " option").size();
   if(size>0){
		$.each($("#List_AdmReason"+" option:selected"), function(i,own){
          var svalue = $(own).val();
		  if (AdmReasonStr=="") AdmReasonStr=svalue;
		  else AdmReasonStr=AdmReasonStr+"^"+svalue;
		})
   }
   var ret= $cm({
	    ClassName : "web.DHCRBResource",
	    MethodName : "InsertSEREXCludeAdmReason",
	    SERRowId : SERRowId,
	    EXCludeAdmReasonStr : AdmReasonStr
	},false);
	if (ret==0){
		$("#excludeAdmReason").val("");
		PageLogicObj.dialog1.dialog( "close" );	
		$.messager.show({title:"��ʾ",msg:"��ӳɹ�"});
		SessionServerListDataGridLoad("OrderNorm");
	}
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>���Ｖ��ҳ��ʹ��˵��</li>" + 
		"<li>1�����Ｖ��ά����ά���Һ�ְ����Ӧ�ķ�����ã��Һ�ʱ������ѡ�Ű�ĹҺ�ְ�Ʋ�����عҺŷ��á�</li>" +
		"<li>2���Ҳ�ҽ�������Ƽ���������ҽ����ά��-������Դ������<�Һŷ�����>��ҽ�����б�</li>" +
		"<li>3��<�Һŷ�����>�����ڹҺ����ý���ά����</li>" +
		"<li>4�����Һŷ�����δ����,��ҳ��ҽ��������������Ϊ��,�ҶԼ������ʱ���������¼�ĹҺŷ��ڽɷ�ʱ�����������ɷѡ�</li>" + 
		"<li>5���Һŷ��������ú�,����������,�����޸�,�����޸�����ѯ������</li>" + 
		"<li>6��ҽ������ڹҺ���ط��õ�ҽ��,��������ҽ���������Ϊ�Һŷ�����,���������ʱ���������¼�ĹҺŷ��ڽɷ�ʱ�����������ɷѡ�</li>" +
		"<li>7��<i>100%�ۿۡ���Һŷѡ�������</i>�ȹ�����0����ҽ�����ͻ���������ʱ�Ի����0����ҽ������ͨ��������ʹ��<i>�Һ�����-���ҽ��</i>�������ҽ����</li>" 
	$("#tip").popover({
		trigger:'hover',
		content:_content
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
	                        Rowid=rows[0].SERRowId
	                        if (Rowid){
		                        var entityInfo=["ID="+Rowid,
									"SERParRef="+""
                				];
								var resource=Card_GetEntityClassInfoToXML(entityInfo);
		                        var value=$.m({
									ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
									MethodName:"RBResourceServerDelete",
									Infostr:resource
								},false);
								if(value=="0"){
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        SessionServerListDataGridLoad("OrderPre")	
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
			        var subrowid=ArcimSelRow.SERRowId
					var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");	  
					var SERParRef=select.ID;
					var entityInfo=["ID="+subrowid,
						"SERParRef="+SERParRef,
						"SERRBCServiceDR="+ArcimRowID,
						"HospID="+$HUI.combogrid('#_HospList').getValue(),
						"SERType="+"OrderPre",
						"SERDiagnoseDr="
		            ];
		            var resource=Card_GetEntityClassInfoToXML(entityInfo);
					var value=$.m({
						ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
							MethodName:"RBResourceServerSave",
							Infostr:resource,
							dataType:"text"
					},false);
					if(value=="0"){
						$.messager.popover({msg: '����ɹ�',type:'success'});
				        SessionServerListDataGridLoad("OrderPre")	
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
    				{field:'SERRowId',hidden:true},
					{field:'ARCIMDR',hidden:true},
					{field:'ARCITMDesc',title:'ҽ��������',width: 20,
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
									param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
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
	                        Rowid=rows[0].SERRowId
	                        if (Rowid){
		                        var entityInfo=["ID="+Rowid,
									"SERParRef="+""
                				];
								var resource=Card_GetEntityClassInfoToXML(entityInfo);
		                        var value=$.m({
									ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
									MethodName:"RBResourceServerDelete",
									Infostr:resource
								},false);
								if(value=="0"){
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        SessionServerListDataGridLoad("OrderDiag")	
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
			        var subrowid=ArcimSelRow.SERRowId
					var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");	  
					var SERParRef=select.ID;
					var entityInfo=["ID="+subrowid,
						"SERParRef="+SERParRef,
						"SERRBCServiceDR="+"",
						"HospID="+$HUI.combogrid('#_HospList').getValue(),
						"SERType="+"OrderDiag",
						"SERDiagnoseDr="+MRCDIADR
		            ];
		            var resource=Card_GetEntityClassInfoToXML(entityInfo);
					var value=$.m({
						ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
							MethodName:"RBResourceServerSave",
							Infostr:resource,
							dataType:"text"
					},false);
					if(value=="0"){
						$.messager.popover({msg: '����ɹ�',type:'success'});
				        SessionServerListDataGridLoad("OrderDiag")	
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
    				{field:'SERRowId',hidden:true},
					{field:'MRCDIADR',hidden:true},
					{field:'MRCDIADesc',title:'�������', width: 20,
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
									var HospID=$HUI.combogrid('#_HospList').getValue(),
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
