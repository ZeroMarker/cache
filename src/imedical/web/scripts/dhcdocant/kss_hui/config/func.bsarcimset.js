/**
 * func.bsnormal.js
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageLogicObj = {
	m_Grid: ""
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})

function Init(){
	InitHospList();
	InitArcimList();
	InitGrid();
	
}

function InitEvent(){
	$("#BFind").click(findCfg)
}

function PageHandle(){
	//
}

function InitGrid() {
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {//����б�Ĳ�����ť���,�޸�,ɾ����
			    editRow = undefined;
				PageLogicObj.m_Grid.rejectChanges();
				PageLogicObj.m_Grid.unselectAll();
                if (editRow != undefined) {
					PageLogicObj.m_Grid.endEdit(editRow);
                    return;
                }else{
	                //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
					PageLogicObj.m_Grid.insertRow({
						index: 0,
                        row: {
							cqmx:"N",
							tgc:"N",
							lab:"N"
						}
					});
                    //���²������һ�п����༭״̬
					PageLogicObj.m_Grid.beginEdit(0);
                    editRow = 0;
                }
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                //ɾ��ʱ�Ȼ�ȡѡ����
				var rows = PageLogicObj.m_Grid.getSelections();
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowId);
                            }
                            var ids = ids.join(',');
                            if (ids == ""){
	                            editRow = undefined;
								PageLogicObj.m_Grid.rejectChanges();
								PageLogicObj.m_Grid.unselectAll();
				                return;
	                        }
							
                            var result = $.m({
								 ClassName:"DHCAnt.KSS.Config.ArcimSet",
								 MethodName:"Delete",
								 ids:ids
							},false);
							
							if(result == "0"){
								PageLogicObj.m_Grid.load();
								PageLogicObj.m_Grid.unselectAll();
	           					$.messager.popover({msg:"ɾ���ɹ�!",type:'success'});
							}else{
								$.messager.alert('��ʾ',"ɾ��ʧ��:" + result);
								return;
							}
							editRow = undefined;
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
				if(editRow == undefined){
					return false;
				}
				PageLogicObj.m_Grid.selectRow(editRow);
				var rows = PageLogicObj.m_Grid.getSelected();
				if(rows.rowId){
	                var rowId = rows.rowId
	            }else{
		            var rowId = ""
		        }
		        var editors = PageLogicObj.m_Grid.getEditors(editRow);
				//var ArcimRowid=editors[0].target.combobox('getValue');
				var ArcimRowid = rows.arcim;
				if ((ArcimRowid=="")||(ArcimRowid==undefined)){
					$.messager.alert('��ʾ',"��ѡ��ҽ���","warning");
					return false;
				}
				var cqmx = editors[1].target.is(':checked')?"Y":"N";
				var tgc = editors[2].target.is(':checked')?"Y":"N";
				var lab = editors[3].target.is(':checked')?"Y":"N";
				var inHosp = PageLogicObj.m_Hosp.getValue()||"";
				if (inHosp == "") {
					$.messager.alert('��ʾ',"��ѡ��Ժ����","warning");
					return false;
				}
				var inPara = rowId + "^" + ArcimRowid + "^" + cqmx + "^" + tgc + "^" + lab + "^" + inHosp;
				
				var result = $.m({
					 ClassName:"DHCAnt.KSS.Config.ArcimSet",
					 MethodName:"Save",
					 inPara:inPara
				},false);
				
				if(result == 1) {
					PageLogicObj.m_Grid.endEdit(editRow);
					editRow = undefined;
					PageLogicObj.m_Grid.load();
					PageLogicObj.m_Grid.unselectAll();
					$.messager.popover({msg:"����ɹ�!",type:'success'});
				} else if (result == "-1") {
					$.messager.alert('��ʾ',"�����Ѵ��ڣ�", "warning");
					return false;
				} else {
					$.messager.alert('��ʾ',"����ʧ��:" + result);
					return false;
				}
				editRow = undefined;
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                editRow = undefined;
				PageLogicObj.m_Grid.rejectChanges();
				PageLogicObj.m_Grid.unselectAll();
            }
        }];
	var Columns = [[    
                    { field: 'rowId', title: 'ID', width: 1,hidden:true},
                    { field: 'arcimDesc', title: '����', width: 250,
					    editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
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
		                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'����',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onSelect : function(rowIndex, rowData) {
										PageLogicObj.m_Grid.selectRow(editRow);
										var rows = PageLogicObj.m_Grid.getSelected();
										//var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                                        if(rows)rows.arcim = rowData.ArcimRowID
				                     },
				                     onBeforeLoad:function(param){
						                 var desc=param['q'];
										 var HospId = PageLogicObj.m_Hosp.getValue()||"";
										 if (HospId=="") {
											HospId = session['LOGON.HOSPID'];
										 }
										 param = $.extend(param,{Alias:param["q"],HospId:HospId});
						             }
                        		}
		        			}
					},
        			{ field: 'arcim', title: 'ҽ����ID', width: 250,hidden:true},
					{ field: 'cqmx', title: '�Ƿ�̼��ùϩ', width: 100,
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
					{ field: 'tgc', title: '�Ƿ���ӻ���', width: 100,
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
					{ field: 'lab', title: '�Ƿ��ͼ�', width: 100,
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
					{field:'hospName',title:'����Ժ��',width:200
						
						/*,formatter:function(value,row){
							return row.hospName;
						},
						editor:{
							type:'combobox',
							options:{
								valueField:'hosp',
								textField:'hospName',
								defaultFilter:4,
								//multiple:true,
								url:$URL+"?ClassName=DHCAnt.KSS.Config.ArcimSet&QueryName=QryHosp&ResultSetType=array",
								mode:'remote',
								//data:PageLogicObj.m_HisDoc,
								required:false,
								blurValidValue:true
							},
							onBeforeLoad:function(param){
								//param.q = param["q"];
							}
						}*/
					}
    			 ]];
				 
	PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Config.ArcimSet",
			QueryName : "QryANTArcim",
			InHosp:session['LOGON.HOSPID']
		},
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"rowId",	//DARCIMRowid
		pageSize:15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		onClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������", "error");
		        return false;
			}
		},
		onDblClickRow:function(rowIndex, rowData){
			//ItemOrderQtyLimitDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.m_Grid.beginEdit(rowIndex);
			editRow=rowIndex
		},
		onBeforeLoad:function(param){
			var ArcimRowid = $('#Combo_Arcim').combogrid('getValue'); 
			param = $.extend(param,{ArcimRowid:ArcimRowid});
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			editRow=undefined;
		}
	});
	
}

function InitHospList() {
	PageLogicObj.m_Hosp = GenHospComp("Ant_Config_Func_ArcimSet");
	PageLogicObj.m_Hosp.jdata.options.onSelect = function(e,t){
		findCfg();
	}
	PageLogicObj.m_Hosp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function InitArcimList() {
	
	//Ժ��
	/*PageLogicObj.m_Hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect:function(record) {
			
		}
		
	});	*/
	
	//$('#Combo_Arcim').combogrid({
	PageLogicObj.m_Arcim = $HUI.combogrid("#Combo_Arcim", {
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//�Ƿ��ҳ   
		rownumbers:true,//���   
		collapsible:false,//�Ƿ���۵���   
		fit: true,//�Զ���С   
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
		pageList: [10],//��������ÿҳ��¼�������б�   
		method:'post', 
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[    
			{field:'ArcimDesc',title:'����',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#Combo_Arcim').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#Combo_Arcim').combogrid("options").value=selected.ArcimRowID;
			}
		 },
		 onBeforeLoad:function(param){
             var desc=param['q'];
			 var HospId = PageLogicObj.m_Hosp.getValue()||"";
			 if (HospId=="") {
				HospId = session['LOGON.HOSPID'];
			 }
             param = $.extend(param,{Alias:param["q"],HospId:HospId});
         }
	});
};

function findCfg () {
	var ArcimRowid = PageLogicObj.m_Arcim.getValue()||"";
	var InHosp = PageLogicObj.m_Hosp.getValue()||"";
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCAnt.KSS.Config.ArcimSet",
		QueryName : "QryANTArcim",
		ArcimRowid: ArcimRowid,
		InHosp:InHosp
	})	
}
 