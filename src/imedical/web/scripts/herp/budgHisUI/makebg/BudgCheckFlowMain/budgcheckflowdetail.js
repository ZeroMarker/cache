$(function(){//初始化
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
			title: '主表ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'deptid',
			title: '适用科室',
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
			title: '顺序号',
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
			title: '岗位描述',
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
			title: '用户名',
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
			title: '是否科主任',
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
							name: '是'
						}, {
							rowid: '2',
							name: '否'
						}
					]
		    }}}, {
			field: 'compOrderNo',
			title: '计算顺序',
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
		autoSizeColumn:true, //调整列的宽度以适应内容
		rownumbers: true, //行号
		pagination: true, //分页
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
//查询方法
  $("#findBtn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
     if(row==null){
		  $.messager.popover({
		      msg:'请先选择审批流！',
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
	  
 //新增
  $("#AddBtnCen").click(function(){
	  	  if (endEditing()){
		  $('#DetailGrid').datagrid('appendRow',{rowid: '',checkmainid: '',deptid: '',stepno: '',procdesc: '',chkerid:'',isdirect:'',compOrderNo:''}); 
		  editIndex = $('#DetailGrid').datagrid('getRows').length-1;
		  $('#DetailGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}
})
//保存前校验
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
						var info = title + "列为必填项，不能为空！";
						$.messager.popover({
							msg: info,
							type: 'info',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: document.body.clientWidth / 2, //顶端中间显示
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

//保存
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
		$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
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
//保存请求后台方法
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
				msg: '添加成功！',
				type: 'success',
				timeout: 5000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: document.body.clientWidth / 2, //顶端中间显示
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '添加失败！' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: document.body.clientWidth / 2, //顶端中间显示
					top: 1
				}
			});
		}
	});
}
//删除
  $("#DelBtnCen").click(function(){
	  	var rows = $('#DetailGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '请选中要删除的记录！',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: document.body.clientWidth / 2, //顶端中间显示
				top: 1
			}
		});
		return;
	}

	$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
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
					//新增的行删除
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
						msg: '删除成功！',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: document.body.clientWidth / 2, //顶端中间显示
							top: 1
						}
					});
				} else {
					$.messager.popover({
						msg: '删除失败！' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: document.body.clientWidth / 2, //顶端中间显示
							top: 1
						}
					});
				}
			});
			$('#DetailGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
			$('#DetailGrid').datagrid("reload");
		}
	})

	  })	 	
	}
