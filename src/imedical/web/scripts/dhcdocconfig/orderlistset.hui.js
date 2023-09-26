/**
 * orderlistset.js ҽ��¼��ҽ��������HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */
 
var selectRowId=""
$(function () {
	
	//ҳ���Զ�ɸѡ
	$("#code").keyup(function(){
	  FindymData()
	});
	$("#desc").keyup(function(){
	  FindymData()
	});
	$("#addym-dialog").dialog({
	   iconCls:'icon-w-update',
	   width:350,
	   modal:true,
	   shadow:false,
	   closed:true 
	})
	//����������
	$('#bgtable').combobox({ 
		url: 'dhcdocorderlistset.request.csp?action=getgrid&DOPRowId='+selectRowId,
		valueField:'rowid', 
		textField:'desc' 
	});
	$('#updatemessage-dialog').dialog({ 
		iconCls:'icon-w-update',
		title: '����/�޸�ҳ����Ϣ��ʾ', 
		width:473, 
		height:220, 
		closed: true, 
		modal: true ,
		shadow:false
	});
	$('#updateshortcutkey-dialog').dialog({ 
		iconCls:'icon-w-update',
		title: '����/�޸�ҳ���ݼ�', 
		width:473, 
		height:220, 
		closed: true, 
		modal: true ,
		shadow:false
	});
	$('#grid-dialog').dialog({ 
		iconCls:'icon-w-edit',
		title: '����ά��', 
		width:600, 
		height:500, 
		closed: true, 
		modal: true ,
		shadow:false
	});
	$('#updategrid-dialog').dialog({ 
		iconCls:'icon-w-update',
		title: '����/�޸ı���', 
		width:300, 
		height:200, 
		closed: true, 
		modal: true ,
		shadow:false
	});
	
	$('#updateym').click( function (){
		var url = "dhcdocorderlistset.request.csp?action=updateym&id="+$('#ymid').val()+"&ymCode="+$('#ymCode').val()+"&ymDesc="+$('#ymDesc').val();
		if ( $('#ymCode').val() == ""){
			$.messager.alert("����", "ҳ����벻��Ϊ�գ�", 'error')
			return false;
		}
		
		if ($('#ymDesc').val() == ""){
			$.messager.alert("����", "ҳ�����Ʋ���Ϊ�գ�", 'error')
			return false;
		}
		$.ajax({
			url : url,
			type: "POST",
			success:function (response) {
				if ($('#updateym').attr("value")=="����") var successmsg="�����ɹ�"
				else var successmsg="�޸ĳɹ�"
				response = eval('(' + response + ')');
				if (response.ResultCode == 0) {
					$("#addym-dialog").dialog("close")
					$('#ym').datagrid('rejectChanges');
					$('#ym').datagrid('reload');
					$.messager.show({
						msg : successmsg,
						title : "�ɹ�"
					});
				} else {
					//$('#ym').datagrid('reload');
					$.messager.alert("����", "����ʧ��" + "," + response.ResultMsg, 'error')
				}
			}

		})	
	 })

	$('#ym').datagrid({
		url : 'dhcdocorderlistset.request.csp?action=ym',
		//pagination : 'true',
		//fit : true,
		border : false,
		fitColumns:'true',
		singleSelect:true,
		pagination : false,
		pagePosition : 'bottom',
		pageSize : 10,
		toolbar:[{		
				iconCls: 'icon-add',
				text:'����',	
				handler: function(){
					$("#addym-dialog").dialog("open");
					$('#addym-form').form("clear");	//��ձ�������
				}  	
			},{  		
				iconCls: 'icon-write-order', 
				text:'�޸�', 		
				handler: function(){
					UpdateymData();
				}
			} ,{		
					iconCls: 'icon-cancel', 
					text:'ɾ��', 		
					handler: function(){
						DeleteymData();
					}
				}	
		], 
		columns : [[{
				field : 'rowid',
				title : '���',
				width : 10,
				hidden:true
				//checkbox:true
			}, {
				field : 'code',
				title : 'ҳ�����',
				width : 200,
				sortable:true
			}, {
				field : 'desc',
				title : 'ҳ������',
				width : 100,
				sortable:true

		}]],
		onClickRow : function (rowIndex, rowData) {
			$('#dg').datagrid('load',{
				DOGRowId:""
			});									     
			selectRowId = rowData["rowid"];
			$('#message').datagrid('load',{
			  DOPRowId:selectRowId}							 
			);
			$('#bgtable').combogrid({ 
				url: 'dhcdocorderlistset.request.csp?action=getgrid&DOPRowId='+selectRowId,
				valueField:'rowid', 
				textField:'desc',
				columns:[[ 
				{field:'rowid',title:'����ID',hidden:true},
				{field:'code',title:'�������'},
				{field:'desc',title:'��������'}, 
				{field:'type',title:'��������'}
				]] ,
				onLoadSuccess:function(){  
					//Ĭ��ѡ�е�һ��
					if(($('#bgtable').combogrid('grid').datagrid("getRows").length)>=1){
					$('#bgtable').combogrid('grid').datagrid("selectRow",0)
					//$('#bgtable').combogrid('grid').
					}								 
				}  ,
				onSelect:function(){
					$('#dg').datagrid('load',{  
					DOGRowId:$('#bgtable').combogrid('grid').datagrid('getSelected').rowid}  
				 );  
				}
			});
			$('#grid').datagrid('load',{  
			  DOPRowId:selectRowId  
			 });  
			$('#ShortcutKey').datagrid('load',{
			  DOPRowId:selectRowId}							 
			);
		},
		onDblClickRow: function (rowIndex, rowData) {
			UpdateymData();
		}
	});

	///��Ϣ��ʾ����
	$('#message').datagrid({
		url : 'dhcdocorderlistset.request.csp?action=message',
		pagination : 'true',
		pagePosition : 'bottom',
		pageSize : 10,
		fit : true,
		border : false,
		//fitColumns:true,
		//singleSelect:true,
		toolbar:[{		
			iconCls: 'icon-add',
			text:'����',  		
			handler: function(){
				$('#updatemessage-dialog').dialog("open")
				//��ձ�������
				$('#updatemessage-form').form("clear")
			}  	
		},{	
			iconCls: 'icon-write-order', 
			text:'�޸�', 		
			handler: function(){
				UpdateMessageData();
			}  	
		 },{
			iconCls: 'icon-cancel', 
			text:'ɾ��', 		
			handler: function(){
				DeleteMessageData();
			}  	
		 }], 
		 columns : [[{
					field : 'rowid',
					title : '���',
					//width : 100,
					hidden:true
					//checkbox:true
					
				}, {
					field : 'code',
					title : '��ʾ����'
					//,width : 100
					//sortable:true
					
				}, {
					field : 'desc',
					title : '��ʾ����'
					//,width : 200
					//sortable:true
					
				}, {
					field : 'otherdesc',
					title : '��ʾ��������'
					//,width : 60
					//sortable:true
					
				}]],
		onDblClickRow: function (rowIndex, rowData) {
			$('#message').datagrid('selectRow',rowIndex);
			UpdateMessageData();
		}
	});
	
	///ҳ�����
	$('#grid').datagrid({
		url : 'dhcdocorderlistset.request.csp?action=grid&DOPRowId='+selectRowId,
		pagination : 'true',
		fit : true,
		headerCls:'panel-header-gray',
		border : true,
		fitColumns:'true',
		singleSelect:true,
		toolbar:[{  		
		iconCls: 'icon-add',
		text:'����',  		
		handler: function(){
		$("#updategrid-dialog").dialog("open");
		//��ձ�������
		$('#updategrid-form').form("clear")
		}  	
		},{  		
			iconCls: 'icon-write-order', 
			text:'�޸�', 		
			handler: function(){
				UpdategridData();
				}  	
		 },{  		
			iconCls: 'icon-cancel', 
			text:'ɾ��', 		
			handler: function(){
				DeleteGridData();
				}  	
		 }
		] , 

		columns : [[{
					field : 'rowid',
					title : '���',
					width : 100,
					hidden:true
					//checkbox:true
					
				}, {
					field : 'code',
					title : '�������',
					width : 200,
					sortable:true
					
				}, {
					field : 'desc',
					title : '��������',
					width : 100,
					sortable:true
					
				}, {
					field : 'type',
					title : '��������',
					width : 100,
					sortable:true
					
				}]],
			   
	   onDblClickRow: function (rowIndex, rowData) {
			UpdategridData();
	   }
	});
	
	//�б���
	$('#dg').datagrid({
		url : 'dhcdocorderlistset.request.csp?action=colset',
		pagination : true,
		fit : true,
		border : false,
		//width : 600,
		fitColumns : true,
		pagePosition : 'bottom',
		pageSize : 10,
		//height: 400,
		columns : [[{
					field : 'rowid',
					title : '���',
					width : 100,
					checkbox : true
				}, {
					field : 'code',
					title : '��ID',
					width : 100,
					editor : 'text'
				}, {
					field : 'desc',
					title : '������',
					width : 100,
					editor : 'text'
				}, {
					field : 'colwidth',
					title : '�п�',
					width : 100,
					editor : 'text'
				}, {
					field : 'hidden',
					title : '�Ƿ�����',
					width : 100,
					formatter:function(value,row,index){
						if (value == "Y") {
							return "<span class='c-ok'>��</span>"
						} else {
							return "<span class='c-no'>��</span>"
						}
					},
					editor : {
						type : 'icheckbox',
						options : {
							on : 'Y',
							off : ''
						}
					}
				}, {
					field : 'expression',
					title : '����ʽ',
					editor : 'text',
					width : 300
				}
			]],
		toolbar : [{
				id : 'btnadd',
				text : '����',
				iconCls : 'icon-add',
				handler : function () {
					//�ж��Ƿ���Ҫ������
					var IsCanAddRow = true;
					var IsCanAddRow = CheckData();
					
					var Rows = $('#dg').datagrid("getRows");
					if (IsCanAddRow == true) {
						$('#dg').datagrid('insertRow', {
								index : Rows.length,
								row : {
									rowid : '',
									code : '',
									desc : '',
									colwidth : '',
									expression : ''
								}
							});
						$('#dg').datagrid('beginEdit', Rows.length - 1);
						var ed = $('#dg').datagrid('getEditor', {
									index : Rows.length - 1,
									field : 'code'
								});
						$(ed.target).focus();
					}
					
				}
			}, {
				id : 'btncut',
				text : 'ɾ��',
				iconCls : 'icon-cancel',
				handler : function () {
					DeleteData();
				}
			}, {
				id : 'btnsave',
				text : '����',
				iconCls : 'icon-save',
				handler : function () {
					//��������δ�������
					var IsCanSave = CheckData();
					if (IsCanSave == false)
						return;
					var Data = $('#dg').datagrid("getData");
					var Rows = $('#dg').datagrid("getRows");
					for (var i = 0; i < Rows.length; i++) {
						$('#dg').datagrid('endEdit', i);
						SaveDataToServer(Data.rows[i]);
					}
					$('#dg').datagrid('reload');
				}
			}, {
				id : 'btnredo',
				text : 'ȡ���༭',
				iconCls : 'icon-redo',
				handler : function () {
					$('#dg').datagrid('rejectChanges');
					$('#dg').datagrid('unselectAll')
				}
			}
		],
		onDblClickRow : function (rowIndex, rowData) {
			var rowid_ed = $('#dg').datagrid('getEditor', {
						index : rowIndex,
						field : 'rowid'
					});
			if (rowid_ed == null) {
				$('#dg').datagrid('beginEdit', rowIndex);
			} else {
				$('#dg').datagrid('endEdit', rowIndex);
			}
		},
		onAfterEdit : function (rowIndex, rowData, changes) {},
		onLoadSuccess : function (data) {}
	});
	//ҳ���ݼ�����
	$('#ShortcutKey').datagrid({
		url : 'dhcdocorderlistset.request.csp?action=shortcutkey',
		pagination : 'true',
		pagePosition : 'bottom',
		pageSize : 10,
		fit : true,
		border : false,
		//fitColumns:true,
		//singleSelect:true,
		toolbar:[{		
			iconCls: 'icon-add',
			text:'����',  		
			handler: function(){
				$('#updateshortcutkey-dialog').dialog("open")
				//��ձ�������
				$('#updateshortcutkey-form').form("clear")
			}  	
		},{	
			iconCls: 'icon-write-order', 
			text:'�޸�', 		
			handler: function(){
				UpdateShortcutKeyData();
			}  	
		 },{
			iconCls: 'icon-cancel', 
			text:'ɾ��', 		
			handler: function(){
				DeleteShortcutKeyData();
			}  	
		 }], 
		 columns : [[{
					field : 'ItemID',
					title : 'Ԫ��ID'
				}, {
					field : 'ShortcutKey',
					title : '��ݼ�'
				}, {
					field : 'callBackFun',
					title : '���ú���'
				}]],
		onDblClickRow: function (rowIndex, rowData) {
			$('#ShortcutKey').datagrid('selectRow',rowIndex);
			UpdateShortcutKeyData();
		}
	});
});

function SaveDataToServer(rowData) {
    var SuccessMessage = "�����ɹ�";
    var ErrorMessage = "����ʧ�ܣ�";
    var DOGRowId=$('#bgtable').combogrid('grid').datagrid('getSelected').rowid
	
    if (rowData["rowid"] == "") {
        url = "dhcdocorderlistset.request.csp?action=add&DOGRowId="+DOGRowId+"&code="+ rowData["code"] + "&desc=" + rowData["desc"] + "&colwidth=" + rowData["colwidth"] + "&hidden=" + rowData["hidden"] + "&expression=" + rowData["expression"] 
   } else {
        url = "dhcdocorderlistset.request.csp?action=update&rowid=" + rowData["rowid"] + "&code=" + rowData["code"] + "&desc=" + rowData["desc"] + "&colwidth=" + rowData["colwidth"] + "&hidden=" + rowData["hidden"] + "&expression=" + rowData["expression"]
			SuccessMessage = "�޸ĳɹ�";
        ErrorMessage = "�޸�ʧ�ܣ�";
    }
    $.ajax({
            url : url,
            type:"POST",
            success : function (response) {
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
                    $('#dg').datagrid('acceptChanges');
                    $.messager.show({
                            msg : SuccessMessage,
                            title : "�ɹ�"
                        });
                } else {
                    $('#dg').datagrid('rejectChanges');
                    $.messager.alert("����", ErrorMessage + "," + response.ResultMsg, 'error')
                }
            }
            
        })
    
}

function DeleteData() {
    var rows = $('#dg').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����Ŀ��', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                        if ($.trim(rows[i].rowid) == "") {						  
                            unSaveIndexs.push($('#dg').datagrid('getRowIndex',rows[i]));
                        } else {
                            ids.push(rows[i].rowid);
                        }
                    }
                    //ɾ���Ѿ����������
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=del&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#dg').datagrid('reload');
                                        $('#dg').datagrid('unselectAll')
                                        $.messager.show({
                                                msg : "ɾ���ɹ���",
                                                title : "�ɹ�"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                        $.messager.alert("����", "ɾ��ʧ��," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    //ɾ��δ�����ҳ������
                    if (unSaveIndexs.length > 0) {
                        for (var i = 0; i < unSaveIndexs.length; i++) {
                            var RowIndex = unSaveIndexs[i];
                            $("#dg").datagrid("deleteRow", RowIndex);
                        }
                    }
                    
                }
            })
    }
}

//ɾ��ҳ��
function DeleteymData(){
	 var rows = $('#ym').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����Ŀ��', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //ɾ���Ѿ����������
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=delym&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#ym').datagrid('reload');
                                        $('#ym').datagrid('unselectAll')
                                        $.messager.show({
                                                msg : "ɾ���ɹ���",
                                                title : "�ɹ�"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                         $('#ym').datagrid('reload');
                                        $('#ym').datagrid('unselectAll')
                                        $.messager.alert("����", "ɾ��ʧ��," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    
                    
                }
            })
    }else{
	    $.messager.alert("����","��ѡ��һ�У�",'error')
	            
     }
	
}

//ɾ��ҳ����Ϣ��ʾ
function DeleteMessageData(){
var rows = $('#message').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����Ŀ��', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //ɾ���Ѿ����������
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=delelemessage&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#message').datagrid('reload');
                                        $('#message').datagrid('unselectAll')
                                        $.messager.show({
                                                msg : "ɾ���ɹ���",
                                                title : "�ɹ�"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                         $('#message').datagrid('reload');
                                        $('#message').datagrid('unselectAll')
                                        $.messager.alert("����", "ɾ��ʧ��," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    
                    
                }
            })
    }else{
	    $.messager.alert("����","ѡ��һ�У�",'error')
	            
     }


}

//ɾ������
function DeleteGridData(){
var rows = $('#grid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����Ŀ��', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //ɾ���Ѿ����������
                    if (ids.length > 0) {
                        $.ajax({
                                url : "dhcdocorderlistset.request.csp?action=delelegrid&IDs=" + ids.join('^'),
                                success : function (response) {
                                    response = eval('(' + response + ')');
                                    if (response.ResultCode == 0) {
                                        $('#grid').datagrid('reload');
                                        $('#grid').datagrid('unselectAll')
										 //���¼��ر���������
				                         reloadbgtable()
                                        $.messager.show({
                                                msg : "ɾ���ɹ���",
                                                title : "�ɹ�"
                                            })
                                        
                                    } else {
                                        //$('#dg').datagrid('rejectChanges');
                                         $('#grid').datagrid('reload');
                                        $('#grid').datagrid('unselectAll')
                                        $.messager.alert("����", "ɾ��ʧ��," + response.ResultMsg, 'error')
                                    }
                                }
                                
                            });
                    }
                    
                    
                }
            })
    }else{
	    $.messager.alert("����","ѡ��һ�У�",'err')
	            
     }


}

//���ҳ�������Ƿ���Ա������������,����true ����,false ������
function CheckData() {
    var myrtn = true;
    var Data = $('#dg').datagrid("getData");
    var Rows = $('#dg').datagrid("getRows");
    for (var i = 0; i < Rows.length; i++) {
        var code_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'code'
                });
        if (code_ed == null)
            continue;
        var code = $(code_ed.target).val();
        var desc_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'desc'
                });
        var desc = $(desc_ed.target).val();
        var colwidth_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'colwidth'
                });
        var colwidth = $(colwidth_ed.target).val();
        var expression_ed = $('#dg').datagrid('getEditor', {
                    index : i,
                    field : 'expression'
                });
        var expression = $(expression_ed.target).val();
        if ($.trim(code) == "") {
            alert("��ID����Ϊ��");
            $(code_ed.target).focus();
            myrtn = false;
        } else if ($.trim(desc) == "") {
            alert("����������Ϊ��");
            $(desc_ed.target).focus();
            myrtn = false;
        } else if ($.trim(colwidth) == "") {
            alert("�п�����Ϊ��");
            $(colwidth_ed.target).focus();
            myrtn = false;
        } else if ($.trim(expression) == "") {
            alert("����ʽ����Ϊ��");
            $(expression_ed.target).focus();
            myrtn = false;
        }
    }
    return myrtn;
}
 function FindymData(){  
	$('#ym').datagrid('load',{  
		Code:$('#code').val(),  
		Desc:$('#desc').val()}  
		);  
}  

////�޸�ҳ�溯��
function UpdateymData(){ 
	var rows = $('#ym').datagrid('getSelections');
    if (rows.length ==1) {
       $("#addym-dialog").dialog("open");
	 //��ձ�������
	 $('#addym-form').form("clear")
	
	 $('#addym-form').form("load",{
		 ymid:rows[0].rowid,
		 ymCode:rows[0].code,
		 ymDesc:rows[0].desc
	 })
      $('#updateym').val("�޸�")        
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'error')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'error')
     }
   
}

///�޸�ҳ����ʾ��Ϣ����
function UpdateMessageData(){
   var rows = $('#message').datagrid('getSelections');
    if (rows.length ==1) {
       $("#updatemessage-dialog").dialog("open");
	 //��ձ�������
	 $('#updatemessage-form').form("clear")
	
	 $('#updatemessage-form').form("load",{
		 messageid:rows[0].rowid,
		 messagecode:rows[0].code,
		 messagedesc:rows[0].desc,
		 messageOtherDesc:rows[0].otherdesc
	 })
      //$('#updatemessage-button').val("�޸�")        
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'error')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'error')
     }

}

///�޸ı�����
function UpdategridData(){
   var rows = $('#grid').datagrid('getSelections');
    if (rows.length ==1) {
       $("#updategrid-dialog").dialog("open");
	 //��ձ�������
	 $('#updategrid-form').form("clear")
	
	 $('#updategrid-form').form("load",{
		 gridid:rows[0].rowid,
		 gridcode:rows[0].code,
		 griddesc:rows[0].desc,
		 gridtype:rows[0].type
	 })
      //$('#updatemessage-button').val("�޸�")        
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'error')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'error')
     }

}

function updatemessage(){
     var url="dhcdocorderlistset.request.csp?action=updatemessage&id="+$('#messageid').val()+"&Code="+$('#messageCode').val()+"&Desc="+$('#messageDesc').val()+"&OtherDesc="+$('#messageOtherDesc').val()+"&DOPRowId="+selectRowId;
    if ($('#messageCode').val()==""){
	        $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
	        return false;
    }
    if ($('#messageDesc').val()==""){
	       $.messager.alert("����", "���Ʋ���Ϊ�գ�", 'error')
	       return false;
    }
   $.ajax({
            url : url,
            type:"POST",
            success:function (response) {
			   var successmsg="����ɹ�"
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
	               $("#updatemessage-dialog").dialog("close")
				   //$('#message').datagrid('rejectChanges');
                   $('#message').datagrid('reload');
                    $.messager.show({
	                        
                            msg : successmsg,
                            title : "�ɹ�"
                    });
                } else {
                   //$('#ym').datagrid('reload');
                    $.messager.alert("����", "����ʧ��" + "," + response.ResultMsg, 'error')
                }
            }
            
        })
}

function closeupdatemessagedialog(){
   $("#updatemessage-dialog").dialog("close");
}

function opengrid(){
   $('#grid-dialog').dialog("open")
}

function updategrid(){
   var url="dhcdocorderlistset.request.csp?action=updategrid&ID="+$('#gridId').val()+"&Code="+$('#gridCode').val()+"&Desc="+$('#gridDesc').val()+"&Type="+$('#gridType').val()+"&DOPRowId="+selectRowId;
    if ($('#gridCode').val()==""){
	        $.messager.alert("����", "���벻��Ϊ�գ�", 'error')
	        return false;
    }
    if ($('#gridDesc').val()==""){
	       $.messager.alert("����", "���Ʋ���Ϊ�գ�", 'error')
	       return false;
    }
	if ($('#gridType').val()==""){
	       $.messager.alert("����", "���Ͳ���Ϊ�գ�", 'error')
	       return false;
    }
   $.ajax({
            url : url,
            type:"POST",
            success:function (response) {
			   var successmsg="����ɹ�"
                response = eval('(' + response + ')');
                if (response.ResultCode == 0) {
	               $("#updategrid-dialog").dialog("close")
				   //$('#message').datagrid('rejectChanges');
                   $('#grid').datagrid('reload');
				   //���¼��ر���������
				   reloadbgtable()
                    $.messager.show({
                            msg : successmsg,
                            title : "�ɹ�"
                    });
                } else {
                   //$('#ym').datagrid('reload');
                    $.messager.alert("����", "����ʧ��" + "," + response.ResultMsg, 'error')
                }
            }
            
        })

}

function closeupdategriddialog(){
  $("#updategrid-dialog").dialog("close");
}

function reloadbgtable(){
	$('#bgtable').combogrid({ 
		url: 'dhcdocorderlistset.request.csp?action=getgrid&DOPRowId='+selectRowId,
		valueField:'rowid', 
		textField:'desc',
		columns:[[ 
			{field:'rowid',title:'����ID',hidden:true},
			{field:'code',title:'�������'},
			{field:'desc',title:'��������'}, 
			{field:'type',title:'��������'}
		]] ,
		onLoadSuccess:function(){  
			//Ĭ��ѡ�е�һ��
			if(($('#bgtable').combogrid('grid').datagrid("getRows").length)>=1){
				$('#bgtable').combogrid('grid').datagrid("selectRow",0)
				//$('#bgtable').combogrid('grid').
			}								 
		}  ,
		onSelect:function(){
			$('#dg').datagrid('load',{
				DOGRowId: $('#bgtable').combogrid('grid').datagrid('getSelected').rowid
			});  
		}

	 })
}

function updateShortcutKey(){
	var ItemID=$.trim($('#ItemID').val());
	var ItemShortcutKey=$.trim($('#ItemShortcutKey').val());
	var ShortcutKeyCallFun=$.trim($('#ShortcutKeyCallFun').val());
	if (ItemID==""){
	        $.messager.alert("����", "Ԫ��ID����Ϊ�գ�", 'error')
	        return false;
    }
    if (ItemShortcutKey==""){
	       $.messager.alert("����", "��ݼ�����Ϊ�գ�", 'error')
	       return false;
    }
    if (ShortcutKeyCallFun==""){
	    $.messager.alert("����", "���ú�������Ϊ�գ�", 'error')
	    return false;
	}
	var url="dhcdocorderlistset.request.csp?action=updateShortcutKey&ItemID="+ItemID+"&ItemShortcutKey="+ItemShortcutKey+"&ShortcutKeyCallFun="+ShortcutKeyCallFun+"&DOPRowId="+selectRowId+"&ID="+$("#ShortcutKeyid").val();
   $.ajax({
        url : url,
        type:"POST",
        success:function (response) {
		   var successmsg="����ɹ�"
            response = eval('(' + response + ')');
            if (response.ResultCode == 0) {
               $("#updateshortcutkey-dialog").dialog("close")
               $('#ShortcutKey').datagrid('reload');
                $.messager.show({
                    msg : successmsg,
                    title : "�ɹ�"
                });
            } else {
                $.messager.alert("����", "����ʧ��" + "," + response.ResultMsg, 'error')
            }
        }
    })
}
function UpdateShortcutKeyData(){
	var rows = $('#ShortcutKey').datagrid('getSelections');
    if (rows.length ==1) {
       $("#updateshortcutkey-dialog").dialog("open");
	 //��ձ�������
	 $('#updateshortcutkey-form').form("clear")
	
	 $('#updateshortcutkey-form').form("load",{
		 ShortcutKeyid:rows[0].rowid,
		 ItemID:rows[0].ItemID,
		 ItemShortcutKey:rows[0].ShortcutKey,
		 ShortcutKeyCallFun:rows[0].callBackFun
	 })
     }else if (rows.length>1){
	     $.messager.alert("��ʾ","��ѡ���˶���!")
     }else{
	     $.messager.alert("��ʾ","��ѡ��һ��!")
     }
}
function DeleteShortcutKeyData(){
	var rows = $('#ShortcutKey').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����Ŀ��', function (b) {
                if (b) {
                    for (var i = 0; i < rows.length; i++) {
                            ids.push(rows[i].rowid);
                    }
                    //ɾ���Ѿ����������
                    if (ids.length > 0) {
                        $.ajax({
                            url : "dhcdocorderlistset.request.csp?action=deleleShortcutKey&IDs=" + ids.join('^'),
                            success : function (response) {
                                response = eval('(' + response + ')');
                                if (response.ResultCode == 0) {
                                    $('#ShortcutKey').datagrid('reload');
                                    $('#ShortcutKey').datagrid('unselectAll')
                                    $.messager.show({
                                            msg : "ɾ���ɹ���",
                                            title : "�ɹ�"
                                        })
                                    
                                } else {
                                     $('#ShortcutKey').datagrid('reload');
                                    $('#ShortcutKey').datagrid('unselectAll')
                                    $.messager.alert("����", "ɾ��ʧ��," + response.ResultMsg, 'error')
                                }
                            }
                        });
                    }
                }
            })
    }else{
	    $.messager.alert("����","ѡ��һ�У�",'error')
     }
}