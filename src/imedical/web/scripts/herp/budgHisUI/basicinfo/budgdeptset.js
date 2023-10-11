/*
Creator: Liu XiaoMing
CreatDate: 2018-11-17
Description: 全面预算管理-基本信息维护-预算科室维护（表格型）
CSPName: herp.budg.hisui.budgdeptset.csp
ClassName: herp.budg.hisui.udata.uBudgDeptSet
 */

var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //初始化
	$('#TypeCombo').val('')
	$('#CodeBox').val('')
	$('#NameBox').val('')
	Init();
});

function Init() {
	var ClassBox = {
		type: 'combobox',
		options: {
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
			delay: 200,
			onBeforeLoad: function (param) {
				param.hospid = "";
				param.userdr = userid;
				param.str = param.q;
			}
		}
	};
	var directBox = {
		type: 'combobox',
		options: {
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			delay: 200,
			onBeforeLoad: function (param) {
				param.hospid = "";
				param.userdr = userid;
				param.str = param.q;
				param.flag = "1";
			}
		}
	};
	var SupDeptBox = {
		type: 'combobox',
		options: {
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			delay: 200,
			onBeforeLoad: function (param) {
				param.hospid = "";
				param.userdr = userid;
				param.str = param.q;
				param.flag = "1";
			}
		}
	};
	//科室类别的下拉框
	var cyearObj = $HUI.combobox("#TypeCombo", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = "";
				param.userdr = userid;
				param.str = param.q;

			}
		});
	MainColumns = [[{
				field: 'ck',
				checkbox: true
			}, {
				field: 'rowid',
				title: 'ID',
				width: 80,
				hidden: true
			}, {
				field: 'CompName',
				title: '医疗单位',
				width: 80,
				hidden: true
			}, {
				field: 'code',
				title: '科室编码',
				align: 'center',
				width: 100,
				editor: {
					type: 'text'
				}
			}, {
				field: 'name',
				title: '科室名称',
				align: 'left',
				width: 120,
				editor: {
					type: 'text'
				}
			}, {
				field: 'classdr',
				title: '科室类别',
				align: 'left',
				width: 80,
				formatter: CommonFormatter(ClassBox, 'classdr', 'class1'),
				editor: ClassBox
			}, {
				field: 'directdr',
				title: '科主任',
				align: 'left',
				width: 100,
				formatter: CommonFormatter(directBox, 'directdr', 'direct'),
				editor: directBox
			}, {
				field: 'Level',
				title: '科室层次',
				align: 'left',
				width: 70,
				editor: {
					type: 'text'
				}
			}, {
				field: 'SupDeptID',
				title: '上级科室',
				align: 'left',
				width: 80,
				formatter: CommonFormatter(SupDeptBox, 'SupDeptID', 'SupDeptNa'),

				editor: SupDeptBox
			}, {
				field: 'IOFlag',
				title: '门诊住院',
				align: 'left',
				width: 80,
				editor: {
					type: 'text'
				}
			}, {
				field: 'IsBudg',
				title: '是否归口科室',
				align: 'left',
				width: 100,
				align: 'center',
				formatter: function (value, rec, rowIndex) {
					if (value == 1) {
						return '<input type="checkbox" checked="checked" value="' + value + '"/>';
					} else {
						return '<input type="checkbox" value=""/>';
					}

				},
				editor: {
					type: 'checkbox',
					options: {
						on: '1',
						off: '0'
					}
				}
			}, {
				field: 'State',
				title: '是否有效',
				align: 'left',
				width: 70,
				align: 'center',
				formatter: function (value, rec, rowIndex) {
					if (value == 1) {
						return '<input type="checkbox" checked="checked" value="' + value + '"/>';
					} else {
						return '<input type="checkbox" value=""/>';
					}

				},
				editor: {
					type: 'checkbox',
					options: {
						on: '1',
						off: '0'
					}
				}
			}, {
				field: 'IsItem',
				title: '是否用于项目预算',
				align: 'left',
				width: 130,
				align: 'center',
				formatter: function (value, rec, rowIndex) {
					if (value == 1) {
						return '<input type="checkbox" checked="checked" value="' + value + '"/>';
					} else {
						return '<input type="checkbox" value=""/>';
					}

				},
				editor: {
					type: 'checkbox',
					options: {
						on: '1',
						off: '0'
					}
				}
			}, {
				field: 'Pym',
				title: '拼音码',
				align: 'left',
				width: 80,
				editor: {
					type: 'text'
				}
			}, {
				field: 'IsLast',
				title: '是否末级',
				align: 'left',
				width: 70,
				align: 'center',
				formatter: function (value, rec, rowIndex) {
					if (value == 1) {
						return '<input type="checkbox" checked="checked" value="' + value + '"/>';
					} else {
						return '<input type="checkbox" value=""/>';
					}

				},
				editor: {
					type: 'checkbox',
					options: {
						on: '1',
						off: '0'
					}
				}
			}

		]];

	///hospid, deptdr, type, sortField, sortDir, start, limit
	var MainGridObj = $HUI.datagrid("#MainGrid", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgDeptSet",
				MethodName: "List",
				hospid: "",
				sortField: "",
				sortDir: "",
				deptdr: "",
				type: ""
			},
			fitColumns: false, //列固定
			loadMsg: "正在加载，请稍等…",
			autoRowHeight: true,
			singleSelect: true,
			rownumbers: true, //行号
			singleSelect: true,
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //页面大小选择列表
			pagination: true, //分页
			fit: true,
			columns: MainColumns,
			onClickRow: onClickRow, //在用户点击一行的时候触发
			toolbar: [{
					id: 'AddBn',
					iconCls: 'icon-add',
					text: '新增',
					handler: function () {
						add()
					}
				}, {
					id: 'SaveBn',
					iconCls: 'icon-save',
					text: '保存',
					handler: function () {
						save()
					}
				}, {
					id: 'DeleteBn',
					iconCls: 'icon-cancel',
					text: '删除',
					handler: function () {
						delect()
					}
				},{
					id: 'SetDept',
					iconCls: 'icon-edit',
					text: '设置归口科室',
					handler: function () {
						setdept()
					}
				},{
					id: 'ImportBn',
					iconCls: 'icon-import-xls',
					text: 'Excel导入',
					handler: function () {
						addimportFun();
					}
				}
			]
		});

	var editIndex = undefined;
	function endEditing() {
		if (editIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', editIndex)) {
			$('#MainGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	function onClickRow(index) {
		$('#MainGrid').datagrid('endEdit', editIndex);
		//if (editIndex != index) {
			if (endEditing()) {
				$('#MainGrid').datagrid('selectRow', index)
				$('#MainGrid').datagrid('beginEdit', index);
				var cellEditname = $('#MainGrid').datagrid("getEditor", {
						index: index,
						field: "name"
					});
				var cellEditPym = $('#MainGrid').datagrid("getEditor", {
						index: index,
						field: "Pym"
					});
				//$(cellEditPym.target).prop('disabled', true);
				$(cellEditname.target).keyup(function (event) {
					$(cellEditPym.target).val(makePy($(cellEditname.target).val().trim()));
				}),
				editIndex = index;
			} else {
				$('#MainGrid').datagrid('selectRow', editIndex)
			}
		//}
	}
	//新增
	function add() {
		if (endEditing()) {
			$('#MainGrid').datagrid('appendRow', {
				IsLast: 0
			});
			editIndex = $('#MainGrid').datagrid('getRows').length - 1;
			$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
			var cellEditname = $('#MainGrid').datagrid("getEditor", {
					index: editIndex,
					field: "name"
				});
			var cellEditPym = $('#MainGrid').datagrid("getEditor", {
					index: editIndex,
					field: "Pym"
				});
			//$(cellEditPym.target).prop('disabled', true);
			$(cellEditname.target).keyup(function (event) {
				$(cellEditPym.target).val(makePy($(cellEditname.target).val().trim()));
			})
		}
	}

	//删除
	function delect() {
		var grid = $('#MainGrid')
			var rows = grid.datagrid("getSelections");
		if (CheckDataBeforeDel(rows) == true) {
			del(grid, "herp.budg.hisui.udata.uBudgDeptSet", "Delete")
		} else {
			return;
		}
	};
	function CheckDataBeforeDel(rows) {
		if (!rows.length) {
			$.messager.popover({
				msg: '请选择所要删除的行！',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
			return;
		}
		return true;
	};
	// 查询函数
	//sortField, sortDir, start, limit, hospid
	var DFindBtn = function () {
		var type = $('#TypeCombo').combobox('getValue');
		var Code = $('#CodeBox').val()
			var Name = $('#NameBox').val()
			MainGridObj.load({
				ClassName: "herp.budg.hisui.udata.uBudgDeptSet",
				MethodName: "List",
				hospid: hospid,
				type: type,
				Code: Code,
				Name: Name
			})
	}

	// 点击查询按钮
	$("#FindBn").click(DFindBtn);
	// 点击保存按钮
	function save() {
		var indexs = $('#MainGrid').datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {
				$('#MainGrid').datagrid("endEdit", indexs[i]);
			}
		}
		var rows = $('#MainGrid').datagrid("getChanges");
		if (rows.length > 0) {
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				//((row.IsHelpEdit==undefined)?'':row.IsHelpEdit);
				var rowid = ((row.rowid == undefined) ? '' : row.rowid);
				var code = ((row.code == undefined) ? '' : row.code);
				if (code == '') {
					$.messager.popover({
						msg: '科室编码不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}				
				var desc = ((row.name == undefined) ? '' : row.name);
				if (desc == '') {
					$.messager.popover({
						msg: '科室名称不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}				
				var Level = ((row.Level == undefined) ? '' : row.Level);
				if (Level == '') {
					$.messager.popover({
						msg: '科室层次不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}
				var CompName = ((row.CompName == undefined) ? '' : row.CompName);
				var class1 = ((row.classdr == undefined) ? '' : row.classdr);
				if (class1 == '') {
					$.messager.popover({
						msg: '科室类别不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}
				var direct = ((row.directdr == undefined) ? '' : row.directdr);
				if (direct == '') {
					$.messager.popover({
						msg: '科主任不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}
				var SupDeptID = ((row.SupDeptID == undefined) ? '' : row.SupDeptID);
				var IOFlag = row.IOFlag;
				var IsBudg = row.IsBudg;
				if (IsBudg == '') {
					$.messager.popover({
						msg: '是否归口科室不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}
				var State = row.State;
				if (State == '') {
					$.messager.popover({
						msg: '是否有效不能为空!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
					break;
				}
				var IsItem = row.IsItem;
				var Pym = row.Pym;
				var IsLast = row.IsLast;
				//rowId, CompName, code, name, class, directdr, Level, SupDeptID, IOFlag, IsBudg, State, IsItem, Pym, IsLast
				//保存前不能为空列的验证
				var data = rowid + "^" + code + "^" + desc + "^" + CompName + "^" + class1 + "^" + direct + "^" + SupDeptID + "^" + IOFlag + "^" + IsBudg + "^" + State + "^" + IsItem + "^" + Pym + "^" + IsLast
					//alert(data);
					$.m({
						ClassName: 'herp.budg.hisui.udata.uBudgDeptSet',
						MethodName: 'Save',
						rowId: rowid,
						code: code,
						name: desc,
						CompName: CompName,
						classdr: class1,
						Level: Level,
						directdr: direct,
						SupDeptID: SupDeptID,
						IOFlag: IOFlag,
						IsBudg: IsBudg,
						State: State,
						IsItem: IsItem,
						Pym: Pym,
						IsLast: IsLast,
						hospid: hospid
					},
						function (Data) {
						if (Data == 0) {
							$.messager.popover({
								msg: '保存成功！',
								type: 'success',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top: 0
								}
							});
							$.messager.progress('close');
							$('#MainGrid').datagrid("reload");
							editIndex = undefined;
						} else {
							$.messager.popover({
								msg: '保存失败' + Data,
								type: 'error',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top: 0
								}
							});
							$.messager.progress('close');
						}
					});
			}
		}
	};
	
	
	
	
	/**是否归口科室  开始**/
    var setdept=function() {
        var $Btchwin;
        $Btchwin = $('#BtchWin').window({
            title: '归口科室设置',
            width: 500,
            height: 300,
            top: ($(window).height() - 300) * 0.5,
            left: ($(window).width() - 500) * 0.5,
            shadow: true,
            modal: true,
            //iconCls: 'icon-w-batch-add',
            closed: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            resizable: true,
            onClose:function(){ //关闭关闭窗口后触发
                $("#Btchfm").form("clear");
                $("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            }
        });
        
        var row = $('#MainGrid').datagrid('getSelected'); 
        var rowid="";
        var fromschemdr="";
        var DeptName="";
         if(row==null){
            fromschemdr=null;
            DeptName=null; 
           
                    
        }else{
	         
             var fromschemdr=row.classdr;   //选中行的科室类型名称
             var DeptName=row.name;         //选中行的科室名称
	        }
	        
        //alert(typeName)
        $Btchwin.window('open');
        // 表单的垂直居中
        xycenter($("#btchcenter"),$("#Btchfm"));
        // 设置表单垂直居中
        // 科室的下拉框
        var BtchUserObj = $HUI.combobox("#BtchUser",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetDeptName",
            mode:'remote',
            delay:200,
            valueField:'rowid',    
            textField:'name',
            value: DeptName,
           
        });
        // 科室类别下拉框
        var BtchDeptObj = $HUI.combobox("#BtchDept",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetDeptType",
            mode:'remote',
            delay:200,
            valueField:'rowid',    
            textField:'name',
            value:fromschemdr,
            
            
        });
        
       
        //是否归口科室 
        $("#BtchSave").unbind('click').click(function(){
            var DeptName=$("#BtchUser").combobox("getText")
            var id=$("#BtchUser").combobox("getValue")
            DeptName=DeptName.replace(/^\s+|\s+$/g,"");
            var DeptType=$("#BtchDept").combobox("getText");
            DeptType=DeptType.replace(/^\s+|\s+$/g,"");
            var IsBudg=$("#IsBudg").checkbox("getValue");
            if(row==null){
	             rowid=id 
	            }else{
		            rowid=row.rowid;
		            }
            if(IsBudg==true){
                IsBudg=1;
            }else{
                IsBudg=0;
            }
            console.log(IsBudg);
            
            $.m({
                ClassName:'herp.budg.hisui.common.ComboMethod',MethodName:'UpdateDept',DeptName:DeptName,DeptType:DeptType,IsBudg:IsBudg,RowId:rowid},
                
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '更改成功!',type:'success',timeout: 1000});
                          DFindBtn();
                    }else{
                        var message="更改失败!"
                        $.messager.popover({msg: message,type:'error'});
                    }
                }
            );
            $Btchwin.window('close');
        });
        //取消 
        $("#BtchClose").unbind('click').click(function(){           
            $Btchwin.window('close');
        });

    }
   
    /**是否归口科室  结束**/
}
