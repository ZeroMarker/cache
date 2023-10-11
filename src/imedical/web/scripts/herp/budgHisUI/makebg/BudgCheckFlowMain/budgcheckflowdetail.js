$(function(){//��ʼ��
 $('#stepNocb').val('');
 $('#usercb').val('');
 $('#deptcb').val('');


    Init();
}); 
function Init(){
	var stepNocbObj=$HUI.combobox('#stepNocb',{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgCheckFlow&MethodName=StepNO",
        mode:'remote',
        valueField:'rowid',    
        textField:'rowid',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid,
            param.userid = userid
        }
	
	});	
	
var usercbObj=$HUI.combobox('#usercb',{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgCheckFlow&MethodName=UserName",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid,
            param.userid = userid
        }
	
	});	

var deptcbObj=$HUI.combobox('#deptcb',{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid,
            param.userdr = userid,
            param.flag = '1^',
            param.year = '',
            param.audept = '',
            param.schemedr = ''
            
        }
	
	});	

	 detailColumn = [[{
			field: 'rowid',
			title: 'ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'checkmainid',
			title: '����ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'deptid',
			title: '���ÿ���',
			halign: 'center',
			width:150,
			allowBlank: false,
			formatter:function(value, row) {
				return row.deptname;
			},
			editor: {
				type: 'combobox',
				options: {
					required: true,
			        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			        mode:'remote',
			        valueField:'rowid',    
			        textField:'name',
			        onBeforeLoad:function(param){
			            param.str = param.q;
			            param.hospid = hospid,
			            param.userdr = userid,
			            param.flag = '1^',
			            param.year = '',
			            param.audept = '',
			            param.schemedr = ''
			            
			        }
				}
			}
		}, {
			field: 'stepno',
			title: '˳���',
			halign: 'center',
			width:60,
			allowBlank: false,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min:0,
					max:10
				}
			}
		}, {
			field: 'procdesc',
			title: '��λ����',
			halign: 'center',
			width:150,
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			field: 'chkerid',
			title: '�û���',
			halign: 'center',
			width:150,
			allowBlank: false,
			formatter:function(value, row) {
				return row.chkname;
			},
			editor: {
				type: 'combobox',
				options: {
					required: true,
			        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			        mode:'remote',
			        valueField:'rowid',    
			        textField:'name',
			        onBeforeLoad:function(param){
			            param.str = param.q;
			            param.hospid = hospid,
			            param.userdr = userid,
			            param.flag = '1',
			            param.checkflag = ''
			            
			        }
				}
			}
		}, {
			field: 'isdirect',
			title: '�Ƿ������',
			halign: 'center',
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					required: true,
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '��'
						}, {
							rowid: '2',
							name: '��'
						}
					]
		    }}}, {
			field: 'compOrderNo',
			title: '����˳��',
			halign:'left',
			width:60,
			editor: {
				type: 'numberbox',
				options: {
					min:0,
					max:10
				}
			}
		}
	]]

var DetailGridObj = $HUI.datagrid('#DetailGrid', {	
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
			MethodName: 'ListDetail',
			hospid: hospid,
			userid: userid
		},
		columns: detailColumn,
		fit:true,
		fitColumns:false,
		autoSizeColumn:true, //�����еĿ������Ӧ����
		rownumbers: true, //�к�
		pagination: true, //��ҳ
		pageSize: 12,
		pageList: [12, 24, 36, 48, 60],
		toolbar: "#trb",
		onClickRow:onClickRow
	});
	
	
	    var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#DetailGrid').datagrid('validateRow', editIndex)){
				$('#DetailGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}

	 function onClickRow(index){
	        $('#DetailGrid').datagrid('endEdit', editIndex);
			if (editIndex != index){
				if (endEditing()){
					$('#DetailGrid').datagrid('selectRow', index)
					$('#DetailGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#DetailGrid').datagrid('selectRow', editIndex)}
			}} 
//��ѯ����
  $("#findBtn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
     if(row==null){
		  $.messager.popover({
		      msg:'����ѡ����������',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:document.body.clientWidth / 2,
			         top:1}})
			         return;
		  }
         DetailGridObj.load({
                ClassName: "herp.budg.hisui.udata.uBudgCheckFlow",
                MethodName: "ListDetail",
                hospid: hospid,
			    userid: userid,
			    checkmainid: row.rowid, 
			    stepno:$('#stepNocb').combobox('getValue'),
			    usernameDr:$('#usercb').combobox('getValue'), 
			    deptname:$('#deptcb').combobox('getValue') 
            })

	  })
	  
 //����
  $("#AddBtnCen").click(function(){
	  	  if (endEditing()){
		  $('#DetailGrid').datagrid('appendRow',{rowid: '',checkmainid: '',deptid: '',stepno: '',procdesc: '',chkerid:'',isdirect:'',compOrderNo:''}); 
		  editIndex = $('#DetailGrid').datagrid('getRows').length-1;
		  $('#DetailGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}
})
//����ǰУ��
function chkBefSave(rowIndex, grid, row) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = row[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined)) {
						var info = title + "��Ϊ���������Ϊ�գ�";
						$.messager.popover({
							msg: info,
							type: 'info',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: document.body.clientWidth / 2, //�����м���ʾ
								top: 1
							}
						});
						return false;
					}
				}
			}
		}
		return true;
}

//����
  $("#SaveBtnCen").click(function(){
	var grid = $('#DetailGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			var ed = $('#DetailGrid').datagrid('getEditor', {
					index: indexs[i],
					field: 'chkerid'
				});
			if (ed) {
				var chkname = $(ed.target).combobox('getText');
				$('#DetailGrid').datagrid('getRows')[indexs[i]]['chkname'] = chkname;

			}
			var ed = $('#DetailGrid').datagrid('getEditor', {
					index: indexs[i],
					field: 'deptid'
				});
			if (ed) {
				var deptname = $(ed.target).combobox('getText');
				$('#DetailGrid').datagrid('getRows')[indexs[i]]['deptname'] = deptname;

			}
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "",detailData='';
	if (rows.length > 0) {
		$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function (t) {
			//alert(t);
			if (t) {
				var mainRow=$('#MainGrid').datagrid('getSelected');
				mainData=mainRow.rowid;
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var tempdata = row.rowid
							 + '^' + row.deptid
							 + '^' + row.stepno
							 + '^' + row.procdesc
							 + '^' + row.chkerid
							 + '^' + row.isdirect 
							 + '^' + row.compOrderNo ;
						if (detailData == "") {
							detailData = tempdata;
						} else {
							detailData = detailData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				//alert(detailData);
				if (flag == 1) {
					DoSaveCen(mainData,detailData);
				}
				grid.datagrid("reload");
				$('#DetailGrid').datagrid("reload");
			}
		})
	}})

//alert(document.body.clientWidth);
//���������̨����
var DoSaveCen = function (mainData,detailData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
		MethodName: 'SaveCen',
		mainData: mainData,
		detailData: detailData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '��ӳɹ���',
				type: 'success',
				timeout: 5000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: document.body.clientWidth / 2, //�����м���ʾ
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '���ʧ�ܣ�' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: document.body.clientWidth / 2, //�����м���ʾ
					top: 1
				}
			});
		}
	});
}
//ɾ��
  $("#DelBtnCen").click(function(){
	  	var rows = $('#DetailGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '��ѡ��Ҫɾ���ļ�¼��',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: document.body.clientWidth / 2, //�����м���ʾ
				top: 1
			}
		});
		return;
	}

	$.messager.confirm('ȷ��', 'ȷ��Ҫɾ��ѡ����������', function (t) {
		if (t) {
			var mainData = "";
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var rowid = row.rowid;
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//��������ɾ��
					editIndex = $('#DetailGrid').datagrid('getRowIndex', row);
					$('#DetailGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					return;
				}
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
				MethodName: 'DelCen',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: 'ɾ���ɹ���',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: document.body.clientWidth / 2, //�����м���ʾ
							top: 1
						}
					});
				} else {
					$.messager.popover({
						msg: 'ɾ��ʧ�ܣ�' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: document.body.clientWidth / 2, //�����м���ʾ
							top: 1
						}
					});
				}
			});
			$('#DetailGrid').datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
			$('#DetailGrid').datagrid("reload");
		}
	})

	  })	 	
	}
