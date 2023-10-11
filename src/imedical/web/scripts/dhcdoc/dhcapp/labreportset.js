var tablabreportSetDataGrid;
var editRow = undefined;
var RowID="";
var dialog1;
$(function(){
	InitHospList();
	$("#BSave").click(SaveClickHandler);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SplitPrescriptSetting");
	hospComp.jdata.options.onSelect = function(e,t){
		//InitPrescript();
		$('#tablabreportSet').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InittablabreportSet();
	}
}
function InittablabreportSet()
{
	var PrescriptTypeToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    editRow = undefined;
	                tablabreportSetDataGrid.datagrid("rejectChanges");
	                tablabreportSetDataGrid.datagrid("unselectAll");
					RowID=""
                }
                tablabreportSetDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                editRow = 0;
                tablabreportSetDataGrid.datagrid("beginEdit", 0);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = tablabreportSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ID=rows[0].RowID
                            if (ID==""){
	                            editRow = undefined;
				                tablabreportSetDataGrid.datagrid("rejectChanges");
				                tablabreportSetDataGrid.datagrid("unselectAll");
								RowID="";
								return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCApp.LabReportSet", 
								MethodName:"Delect",
								RowID:ID
							},false); 
					        if(value=="0"){
						       tablabreportSetDataGrid.datagrid('load');
       					       tablabreportSetDataGrid.datagrid('unselectAll');
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
                tablabreportSetDataGrid.datagrid("rejectChanges");
                tablabreportSetDataGrid.datagrid("unselectAll");
				RowID=""
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=tablabreportSetDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = tablabreportSetDataGrid.datagrid('getEditors', editRow);
				var Type=editors[0].target.combobox('getValue'); 
				if(Type==""){
					$.messager.alert('��ʾ',"���Ͳ���Ϊ��");
					return false;
				};
				var ReportFullFile=editors[2].target.val();
				var ARCIMDR=rows.ARCIMDR
				var ARCIMCatDR=rows.ARCIMCatDR
				
				if ((Type=="ҽ����")&&(ARCIMDR=="")){
					$.messager.alert('��ʾ',"ҽ�����Ϊ��");
					return false;
					}
				if ((Type=="����")&&(ARCIMCatDR=="")){
					$.messager.alert('��ʾ',"���಻��Ϊ��");
					return false;
					}
				if (Type=="Ĭ��"){
					ARCIMDR=""
					ARCIMCatDR=""
					}
				var ToReportNo=editors[3].target.is(':checked');
				if(ToReportNo) ToReportNo="Y";
				else {ToReportNo="N"};
				var BeforeReportNo=editors[4].target.val();
				var BeforeReportNoSplit=editors[5].target.val();
				var ToRegistNo=editors[6].target.is(':checked');
				if(ToRegistNo) ToRegistNo="Y";
				else {ToRegistNo="N"};
				var BeforeRegistNo=editors[7].target.val();
				var  ToUserCode=editors[8].target.is(':checked');
				if( ToUserCode)  ToUserCode="Y";
				else { ToUserCode="N"};
				var BeforeUserCode=editors[9].target.val();
				var BeforeOther=editors[10].target.val();
				var InfoStr=ToReportNo+String.fromCharCode(1)+BeforeReportNo+String.fromCharCode(1)+BeforeReportNoSplit+String.fromCharCode(1)+ToRegistNo
				InfoStr=InfoStr+String.fromCharCode(1)+BeforeRegistNo+String.fromCharCode(1)+ToUserCode+String.fromCharCode(1)+BeforeUserCode+String.fromCharCode(1)+BeforeOther
				var RowID=""
				if (rows.RowID) RowID=rows.RowID
                var value=$.m({ 
					ClassName:"DHCDoc.DHCApp.LabReportSet", 
					MethodName:"Insert",
					RowID:RowID, Type:Type, ReportFullFile:ReportFullFile, ARCIMDR:ARCIMDR,
					 ARCIMCatDR:ARCIMCatDR, InfoStr:InfoStr, HospID:$HUI.combogrid('#_HospList').getValue(),
					dataType:"text"
				},false); 
				if(value==0){
				   RowID="";
				   tablabreportSetDataGrid.datagrid('load');
				   tablabreportSetDataGrid.datagrid('unselectAll');
				   $.messager.show({title:"��ʾ",msg:"����ɹ�"});
				}else{
				   $.messager.alert('��ʾ',"����ʧ��:"+value);
				   return ;
				}
				editRow = undefined;
				
				
			 }
			}
		},'-',{
			text: '�����������',
			iconCls: 'icon-edit',
			handler: function() {
				
	          $("#dialog-LabSelect").dialog( "open" );
	          GetRadioValue("LabReport")
			}
		}];
	PrescriptTypeColumns=[[    
                    { field: 'RowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Type', title:'����', width: 80, align: 'center', sortable: true,
					  editor:{
					        type:'combobox',
					        options:{
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:[
						      		{"code":"Ĭ��","desc":"Ĭ��"},
						      		{"code":"ҽ����","desc":"ҽ����"},
						      		{"code":"����","desc":"����"}
						      	   ]
					        }
				         },
						  formatter:function(value, record){
							  return record.Type;
						 }
					},
        			{ field: 'Desc', title: 'ҽ����/����', width: 150, align: 'center', sortable: true,
					    editor:{
		                         type:'combogrid',
		                         options:{
		                             required: false,
		                             panelWidth:450,
									 panelHeight:350,
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
									delay:500,
		                            url:$URL+"?ClassName=DHCDoc.DHCApp.LabReportSet&QueryName=FindItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'����',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onSelect : function(rowIndex, rowData) {
										var editors = tablabreportSetDataGrid.datagrid('getEditors', editRow); 
										var Type=editors[0].target.combobox('getValue'); 
										var rows=tablabreportSetDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
										if (Type=="ҽ����") {
												if(rows){
													rows.ARCIMDR=rowData.ArcimRowID
													rows.ARCIMCatDR=""
												}
											}else{
											    if(rows){
												    rows.ARCIMDR=""
													rows.ARCIMCatDR=rowData.ArcimRowID
												    }
												}
      
				                     },
				                     onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 var editors = tablabreportSetDataGrid.datagrid('getEditors', editRow); 
						                 var Type=editors[0].target.combobox('getValue'); 
						                 param = $.extend(param,{Alias:param["q"],Type:Type,HospId:$HUI.combogrid('#_HospList').getValue()});
						             }
                        		}
		        			}
					},
					{ field: 'ARCIMDR', title: 'ҽ����ID', width: 250,hidden:true},
					{ field: 'ARCIMCatDR', title: '����ID', width: 250,hidden:true},
					{ field: 'ReportFullFile', title:'����·��', width: 250, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'ToReportNo', title: '�Ƿ��������', width: 130,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
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
					{ field: 'BeforeReportNo', title:'�����ǰ����', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'BeforeReportNoSplit', title:'�������ŷָ���', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'ToRegistNo', title: '�Ƿ����ǼǺ�', width: 130,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
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
					{ field: 'BeforeRegistNo', title:'�ǼǺ�ǰ����', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'ToUserCode', title: '�Ƿ����û�����', width: 130,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
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
					{ field: 'BeforeUserCode', title:'�û�����ǰ����', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'BeforeOther', title:'��������', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					}
    			 ]];
	tablabreportSetDataGrid=$('#tablabreportSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCApp.LabReportSet&QueryName=GetLabReportSetList&HospId=",
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
			editRow=rowIndex
			tablabreportSetDataGrid.datagrid("beginEdit", rowIndex);
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   },
	   onBeforeLoad:function(param){
		   RowID="";
		   $('#tabPrescriptSet').datagrid('unselectAll');
		   param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
	   }
	});
}
function SaveClickHandler(){
	 var DataList="";
	 var LabReport = $("input[name='DHCAPP_LabReport']:checked").val();
	 if (LabReport==undefined) {LabReport=""}
	 DataList="LabReport"+String.fromCharCode(1)+LabReport;
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"SavebaseInfo",
	 	DataList:DataList,
	 	HospId:HospID
		},false);
	if (value==0){
		$.messager.popover({msg: '����ɹ�!',type:'success'});
		$("#dialog-LabSelect").dialog( "close" );
	}else{
		$.messager.alert("��ʾ", "����ʧ��"+value, "error");
        return false;	
		}	
}
function GetRadioValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value!=""){
		$HUI.radio("#"+value).setValue(true);
		}
	}