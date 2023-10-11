var hospComp="",hospID = session['LOGON.HOSPID'],wardID = session['LOGON.WARDID'],locID=session['LOGON.LOCID'],userID=session['LOGON.USERID'];
var setDataGrid,setOrderGrid,setRuleGrid,setCaseGrid;
$(function() {
	hospComp = GenHospComp("Nur_IP_ThresholdConfig",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;     	
    	var tab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex',tab);
		if(index==0){
			reloadDataGrid();
		}else{
			reloadOrderGrid();
			reloadRuleGrid("");
			reloadCaseGrid("");
		}
	}  ///ѡ���¼�
	
	initTable();    
    reloadDataGrid();
    
    $('#keyword').bind('keydown',function(event){
        if(event.keyCode == "13"){
         	searchData();
        }
  	});
	
	// ��ֵ��������
	$("#btn-add").click(function(){
		$("#add-dialog").dialog({title:"������ֵ����"}).dialog("open");
 		//��ձ�����
 		$('#form').form("clear");
 		getFormData("",false);
	});
		
	// �л�ҳǩ
	var ruleTabLoadFlag=false;
	$HUI.tabs("#tabs",
	{
		onSelect:function(title,index){
			if(index==0){
				reloadDataGrid();
			}else{
				if(!ruleTabLoadFlag){
					initRuleTab();
					ruleTabLoadFlag=true;
				}
				reloadOrderGrid();
				reloadRuleGrid("");
				reloadCaseGrid("");				
			}
		}
	});
})

// ��ʼ��table
function initTable(){
    var setColumns = [[
    	{field:'tableName',title:'������',width:260},  
    	{field:'scoreField',title:'��ֵ�ֶ�',width:120}, 
    	{field:'validLocs',title:'��Ч����',width:260,formatter:function(value,row,index){
	    	return value=="" ? "ȫԺ" : value.substr(1,value.length);
	    }},   
    	{field:'code',title:'����',width:120},
    	{field:'expression',title:'��ֵ���ʽ',width:300},
    	{field:'desc',title:'��ֵ����',width:300}
	]];
	setDataGrid = $('#thresholdGrid').datagrid({
		fit : true,
		columns :setColumns,
		rownumbers:true,
		toolbar:"#toolbar",
		pagination : true,  //�Ƿ��ҳ
		pageSize: 15,
		pageList : [15,30,50],
		singleSelect : true,
		loadMsg : '������..' 
	});  
}

// ��ֵ���ò�ѯ
function searchData(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	if(index==0){
		var keyword=$.trim($("#keyword").val());
		reloadDataGrid(keyword)
	}else{
		reloadOrderGrid();
	}    
}

// �б����ݼ���
function reloadDataGrid(keyword)
{
	$.cm({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		QueryName:"GetThresholdList",
		hospDR:hospID,
		keyword:keyword,
		rows:99999
	},function(data){
		setDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',data); 
	})
};

// ��ȡ�������б�
function getFormData(guid,mult) {
    $cm({
        ClassName: "NurMp.NursingRecordsChart",
        QueryName: "GetAssessItems",
        keyword: "",
        loc: locID,
        Hospital:hospID,
        rows:99999
    },function (obj) {
        $HUI.combobox(".formSel", {
            valueField: "id",
            textField: "desc",
            multiple: mult,
            selectOnNavigation: false,
            // panelHeight: "210",
            editable: true,
            data: obj.rows,
            onLoadSuccess: function(data){
                if(guid){
	                if(mult){
		            	$(this).combobox('setValues', guid.split("^"));   
		            }else{
			            $(this).combobox('setValue', guid);
			        }	            	     
	            }
            }
        });
    });
}

// �޸�ѡ�е���ֵ��������ʱ�����ݻ���
function updateData(){	
	var rows=$('#thresholdGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog").dialog({title:"�޸���ֵ����"}).dialog("open");
   		getFormData(rows[0].guid,false);
    	//��ձ�����
 		$('#form').form("clear");
	 	$('#form').form("load",{
	 		Rowid: rows[0].rowid,
	 		ScoreField: rows[0].scoreField,
	 		Code: rows[0].code,
	 		Expression: rows[0].expression,
	 		Desc: rows[0].desc		
 		}); 			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫ�޸ĵ���������", "info");
 	}
}

// ����ѡ�е���ֵ��������
function copyData(){	
	var rows=$('#thresholdGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog").dialog({title:"������ֵ����"}).dialog("open");
   		getFormData(rows[0].guid,false);
    	//��ձ�����
 		$('#form').form("clear");
	 	$('#form').form("load",{
	 		ScoreField: rows[0].scoreField,
	 		Code: rows[0].code,
	 		Expression: rows[0].expression,
	 		Desc: rows[0].desc		
 		}); 			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫ���Ƶ���������", "info");
 	}
}

// ����/�޸�ѡ�е���ֵ��������
function saveData(){
	var rowid=$.trim($("#rowid").val());
	var tableNameDR=$("#name").combobox('getValue');
	var scoreField=$.trim($("#scoreField").val());
	var code=$.trim($("#code").val());
	var expression=$.trim($("#expression").val());
	var desc=$.trim($("#desc").val());
	if(tableNameDR == "")
	{
		$.messager.popover({ msg: '�����Ʋ���Ϊ�գ�', type:'error' });
    	return false;
	}
	if(scoreField == "")
	{
		$.messager.popover({ msg: '��ֵ�ֶβ���Ϊ�գ�', type:'error' });
    	return false;
	}		
	if(code == "")
	{
		$.messager.popover({ msg: '���벻��Ϊ�գ�', type:'error' });
    	return false;
	}
	if(expression == "")
	{
		$.messager.popover({ msg: '��ֵ���ʽ����Ϊ�գ�', type:'error' });
    	return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveThresholdConfig",
		"rowid":rowid,
		"guid":tableNameDR,
		"scoreField":scoreField,
		"code":code,
		"expression":expression,
		"desc":desc,
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"����ɹ���", type:'success'});	
			var keyword = $.trim($("#keyword").val());		
			reloadDataGrid(keyword);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// ɾ��ѡ�е���ֵ��������
function delData(){	
	var rows=$('#thresholdGrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����ʾ", "ɾ����ֵ���ã����������ѹ��򴥷�������ʧЧ��ȷ��Ҫɾ����", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
					MethodName:"DeleteThresholdConfig",
					"rowid":rows[0].rowid,
					"userId":userID
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"ɾ���ɹ���", type:'success'});	
						var keyword=$.trim($("#keyword").val());		
						reloadDataGrid(keyword);						
					}else{	
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
					}
				}); 
			}
		});				
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫɾ������������", "info");
 	}
}

/* =======���������ѹ�������======= */
// ��ʼ��table
function initRuleTab(){	
	// ������ҽ������
	setOrderGrid = $('#orderGrid').datagrid({
		fit : true,
		columns :[[
	    	{field:'desc',title:'ҽ������',width:150},  
	    	{field:'arcItmName',title:'����ҽ��',width:150}, 
	    	{field:'status',title:'״̬',width:80,formatter:function(value, row, index){
	        	return value == "Y" ? "����" : "ͣ��"	
	        }}
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                $("#add-dialog-order").dialog({title:"����������ҽ������"}).dialog("open");
 					//��ձ�����
 					$('#order-form').form("clear"); 					
 					// Ĭ������
	 				$HUI.switchbox("#status").setValue(true);
	 				getLinkOrderData("","");
	            }
			},
			{
	            iconCls: 'icon-write-order',
	            text: '�޸�',
	            handler: function () {
	                updateOrderData();
	            }
	        }
        ],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex, rowData){
			reloadRuleGrid(rowData.rowid);
			reloadCaseGrid(rowData.rowid);				
		} 
	});
	
	// ���ѹ�������
	setRuleGrid = $('#ruleGrid').datagrid({
		fit : true,
		columns :[[
	    	{field:'code',title:'����',width:150},  
	    	{field:'condition',title:'��������',width:360}, 
	    	{field:'remindTmpl',title:'���ѱ�',width:360}
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
		            var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            $("#add-dialog-rule").dialog({title:"�������ѹ�������"}).dialog("open");
 						//��ձ�����
 						$('#rule-form').form("clear");
 						$("#nurLevel").val(rows[0].desc);
 						// ��������
 						getConditionList("","");
 						getFormData("",true);
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }	                	
	            }
			},{
	            iconCls: 'icon-write-order',
	            text: '�޸�',
	            handler: function () {
		            var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            updateRuleData(0);
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }
	            }
	        },{
            	iconCls: 'icon-copy',
            	text: '����',
            	handler: function () {
                	var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            updateRuleData(1);
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }
            	},
	        },{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            delRuleData();
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..'		
	}); 
	
	// ������������
	setCaseGrid = $('#caseGrid').datagrid({
		fit : true,
		columns :[[
	    	{field:'code',title:'����code',width:200},  
	    	{field:'templateName',title:'������',width:260}, 
	    	{field:'validLocs',title:'��Ч����',width:260,formatter:function(value,row,index){
		    	return value=="" ? "ȫԺ" : value.substr(1,value.length);
		    }}, 
	    	{field:'requiredField',title:'�������ֶ�',width:350}
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            $("#add-dialog-case").dialog({title:"����������������"}).dialog("open");
 						//��ձ�����
 						$('#case-form').form("clear");
 						// ������
 						getFormData("",false);
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }
	            }
			},{
	            iconCls: 'icon-write-order',
	            text: '�޸�',
	            handler: function () {
	                var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            updateCaseData();
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }
	            }
	        },{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            delCaseData();
			        }else{
				        $.messager.alert("����ʾ", "��ѡ��һ��ҽ����������", "info");
				    }
            	}
         	}
		],
		singleSelect : true,
		loadMsg : '������..' 
	}); 
}

// ҽ���������ݼ���
function reloadOrderGrid()
{
	$.cm({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		QueryName:"GetNurLevelOrdList",
		hospDR:hospID,
		rows:99999
	},function(data){
		setOrderGrid.datagrid('loadData',data); 
	})
};

// ���ѹ����������ݼ���
function reloadRuleGrid(parref)
{
	if(parref){
		$.cm({
			ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
			QueryName:"GetNurLevelRuleList",
			parref:parref,
			hospDR:hospID,
			rows:99999
		},function(data){
			setRuleGrid.datagrid('loadData',data); 
		})
	}else{
		setRuleGrid.datagrid('loadData',[]);
	}	
};

// ���������������ݼ���
function reloadCaseGrid(parref)
{
	if(parref){		
		$.cm({
			ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
			QueryName:"GetNurLevelCaseList",
			parref:parref,
			hospDR:hospID,
			rows:99999
		},function(data){
			setCaseGrid.datagrid('loadData',data); 
		})
	}else{
		setCaseGrid.datagrid('loadData',[]); 
	}
};

// ��ȡ����ҽ���б�
function getLinkOrderData(arcItmDR,arcItmName) {	
	//ҽ������
	$HUI.combogrid("#linkOrd", {
		panelWidth: 500,
		panelHeight: 330,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){
			console.log(arcItmName);
			console.log(param);
			if(arcItmName){
				param['q']=arcItmName;
				arcItmName=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){
			if(arcItmDR){
	            $(this).combogrid('setValues', arcItmDR.split("^"));
	            arcItmDR="";     
	        }
		}
	});
}

// �޸�ѡ�е�ҽ����������ʱ�����ݻ���
function updateOrderData(){	
	var rows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog-order").dialog({title:"�޸Ļ�����ҽ������"}).dialog("open");
   		getLinkOrderData(rows[0].arcItmDR,rows[0].arcItmName);
    	//��ձ�����
 		$('#order-form').form("clear");
	 	$('#order-form').form("load",{
	 		OrdRowid: rows[0].rowid,
	 		OrdDesc: rows[0].desc		
 		}); 
 		if(rows[0].status == "Y"){
	 		$HUI.switchbox("#status").setValue(true);	
	 	}else{
		 	$HUI.switchbox("#status").setValue(false);	
		}			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫ�޸ĵ�ҽ����������", "info");
 	}
}

// ����ҽ������
function saveOrdData(){
	var rowid=$.trim($("#ordRowid").val());
	var desc=$.trim($("#ordDesc").val());
	var arcItmDR=$HUI.combogrid('#linkOrd').getValues();
	var status = $("#status").switchbox('getValue') ? "Y" : "N";
	if(desc == "")
	{
		$.messager.popover({ msg: 'ҽ����������Ϊ�գ�', type:'error' });
    	return false;
	}
	if(arcItmDR.length==0)
	{
		$.messager.popover({ msg: '����ҽ������Ϊ�գ�', type:'error' });
    	return false;
	}		
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveNurLevelOrder",
		"rowid":rowid,
		"arcItmDr":arcItmDR.join("^"),
		"desc":desc,
		"status":status,
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog-order").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"����ɹ���", type:'success'});			
			reloadOrderGrid();						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// ��ȡ���������б���ֵ���ã�
function getConditionList(tcidStr,keyword){
	//ҽ������
	$HUI.combogrid("#condition", {
		panelWidth: 400,
		panelHeight: 300,
		delay:500,
		mode:'remote',
		idField: 'rowid',
		textField: 'code',
		multiple:true,
		columns: [[
			{field:'rowid',title:'ID',width:20},
			{field:'code',title:'����',width:40},
			{field:'expression',title:'��ֵ���ʽ',width:100}
			
		]],
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=GetThresholdList",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(keyword){
				param['q']=keyword;
				keyword=""
			}
			if (param['q']) {
				var keyword=param['q'];
			}
			param = $.extend(param,{hospDR:$HUI.combogrid('#_HospList').getValue(),keyword:keyword});
		},
		onLoadSuccess:function(){
			if(tcidStr){
	            $(this).combogrid('setValues', tcidStr.split("^"));
	            tcidStr=[];     
	        }
		}
	});	
}

// �޸�ѡ�еĹ�����������ʱ�����ݻ���
function updateRuleData(flag){
	var rows=$('#ruleGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	var operate=flag ? "����": "�޸�"
	if (rows.length == 1) {
   		$("#add-dialog-rule").dialog({title:operate+"���ѹ�������"}).dialog("open");
   		getConditionList(rows[0].tcidStr,"");
   		getFormData(rows[0].guidStr,true);
    	//��ձ�����
 		$('#rule-form').form("clear");
	 	$('#rule-form').form("load",{
	 		RuleRowid: flag ? "" : rows[0].rowid,
	 		NurLevel:ordRows[0].desc,
	 		RuleCode: rows[0].code
 		});			
 	}else{	 	
    	$.messager.alert("����ʾ", "��ѡ��Ҫ"+operate+"�Ĺ�����������", "info");
 	}
}

// �������ѹ�������
function saveRuleData(){
	var rows=$('#orderGrid').datagrid("getSelections");
	var parref=rows[0].rowid;
	var rowid=$.trim($("#ruleRowid").val());
	var code=$.trim($("#ruleCode").val());
	var condition=$HUI.combogrid('#condition').getValues();
	var tmpl=$HUI.combobox('#remindTmpl').getValues(); 
	if(code == "")
	{
		$.messager.popover({ msg: '���벻��Ϊ�գ�', type:'error' });
    	return false;
	}
	if(condition.length == 0)
	{
		$.messager.popover({ msg: '������������Ϊ�գ�', type:'error' });
    	return false;
	}		
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveNurLevelRule",
		"parref":parref,
		"rowid":rowid,
		"code":code,
		"condition":condition.join("^"),
		"guidStr":tmpl.join("^"),
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog-rule").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"����ɹ���", type:'success'});			
			reloadRuleGrid(parref);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// ɾ��ѡ�еĹ�����������
function delRuleData(){	
	var rows=$('#ruleGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����ʾ", "ȷ��Ҫɾ�������ѹ�����", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
					MethodName:"DeleteNurLevelRule",
					"rowid":ordRows[0].rowid+"||"+rows[0].rowid,
					"userId":userID
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"ɾ���ɹ���", type:'success'});			
						reloadRuleGrid(ordRows[0].rowid);						
					}else{	
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
					}
				});
			}
		});   		 			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫɾ������������", "info");
 	}
}

// �޸�ѡ�еĲ�����������������ʱ�����ݻ���
function updateCaseData(){
	var rows=$('#caseGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog-case").dialog({title:"�޸Ĳ�����������"}).dialog("open");
   		getFormData(rows[0].guid,false);
    	//��ձ�����
 		$('#case-form').form("clear");
	 	$('#case-form').form("load",{
	 		CaseRowid: rows[0].rowid,
	 		//CaseCode:rows[0].code,
	 		//ValidLocs: rows[0].validLocs,
	 		RequiredField: rows[0].requiredField
 		});			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫ�޸ĵĲ�����������������", "info");
 	}
}

// ���没������������
function saveCaseData(){
	var rows=$('#orderGrid').datagrid("getSelections");
	var parref=rows[0].rowid;
	var ID=$.trim($("#caseRowid").val());
	//var code=$.trim($("#caseCode").val());
	var guid=$HUI.combobox('#tmplName').getValue(); 
	var requiredField=$.trim($("#requiredField").val());
	if(guid == "")
	{
		$.messager.popover({ msg: '�����Ʋ���Ϊ�գ�', type:'error' });
    	return false;
	}
	if(requiredField == "")
	{
		$.messager.popover({ msg: '�������ֶβ���Ϊ�գ�', type:'error' });
    	return false;
	}		
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveNurLevelCase",
		"parref":parref,
		"rowid":ID,
		"code":"",
		"guid":guid,
		"requiredField":requiredField,
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog-case").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"����ɹ���", type:'success'});			
			reloadCaseGrid(parref);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// ɾ��ѡ�еĲ�����������������
function delCaseData(){	
	var rows=$('#caseGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����ʾ", "ȷ��Ҫɾ������������", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
					MethodName:"DeleteNurLevelCase",
					"rowid":rows[0].rowid,
					"userId":userID
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"ɾ���ɹ���", type:'success'});			
						reloadCaseGrid(ordRows[0].rowid);						
					}else{	
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
					}
				}); 
			}
		});			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫɾ������������", "info");
 	}
}
