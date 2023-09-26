$(document).ready(function() {

	var _DHCDocDoOper = JQueryTool.StaticServerObject('web.DHCDocDoOper');
	InitForm();

	$('#ctlocctcpdatagrid').datagrid({
		url: 'dhcclinic.jquery.csp',
		queryParams: {
			ClassName: "web.DHCDocDoOper",
			QueryName: "FindCtcp",
			Arg1: "",
			Arg2: "",
			Arg3: "",
			Arg4: "",
			ArgCnt: 4
		},
		singleSelect: true,
		onClickRow: function(rowIndex, rowData) {
			selectctcpid = rowData["ctcpId"],
				//$('#docdooperdata').datagrid('load',{Arg1:selectctcpid})
				$('#docdooperdata').datagrid({
					queryParams: {
						ClassName: "web.DHCDocDoOper",
						QueryName: "FindOrcDocOper",
						Arg1: selectctcpid,
						ArgCnt: 1
					}
				})
		},
		columns: [
			[{
				field: 'ctcpDesc',
				title: '医生',
				width: 70
			}, {
				field: 'ctlocDesc',
				title: '科室',
				width: 100
			}, {
				field: 'ctcpId',
				title: 'CtcpId',
				width: 60
			}, {
				field: 'ctlocId',
				title: 'CtlocId',
				width: 60
			}, {
				field: 'ctcpWorkNo',
				title: '工号',
				width: 60
			}]
		],
		pagination: true,
		pageSize: 10,
		pageNumber: 1,
		pageList: [10, 20, 30, 40]
	});
	$('#btnfindctcp').bind('click', function() {
		FindCtcpData();
	});

	function FindCtcpData() {
		$('#ctlocctcpdatagrid').datagrid({
			queryParams: {
				ClassName: "web.DHCDocDoOper",
				QueryName: "FindCtcp",
				Arg1: $('#ctloc').combogrid('getValue'),
				Arg2: $('#name').textbox('getText'),
				Arg3: $('#workno').textbox('getText'),
				Arg4: $('#operation').combogrid('getValue'),
				ArgCnt: 4
			}
		})
	}

	$('#btnfindlocoper').bind('click', function() {
		FindLocOperData();
	});

	function FindLocOperData() {
		$('#ctlocdooperdata').datagrid({
			queryParams: {
				ClassName: "web.DHCDocDoOper",
				QueryName: "FindLocOperation",
				Arg1: $('#ctloc').combogrid('getValue'),
				ArgCnt: 1
			}
		})
	}
	$('#alloperdata').datagrid({
		url: 'dhcclinic.jquery.csp',
		queryParams: {
			ClassName: "web.DHCDocDoOper",
			QueryName: "FindOperation",
			Arg1: "",
			Arg2: "",
			ArgCnt: 2
		},
		//singleSelect:true,	
		columns: [
			[{
				field: 'OPTypeDes',
				title: '手术名称',
				width: 120
			}, {
				field: 'rowid',
				title: '手术ID'
			}]
		]
	});

	$('#btnfindoper').bind('click', function() {
		FindOperData();
	});

	function FindOperData() {
		$('#alloperdata').datagrid({
			queryParams: {
				ClassName: "web.DHCDocDoOper",
				QueryName: "FindOperation",
				Arg1: $('#opdesc').textbox('getText'),
				Arg2: $('#oplevel').combogrid('getValue'),
				ArgCnt: 2
			}
		})
	}

	$('#docdooperdata').datagrid({
		url: 'dhcclinic.jquery.csp',
		queryParams: {
			ClassName: "web.DHCDocDoOper",
			QueryName: "FindOrcDocOper",
			Arg1: "",
			ArgCnt: 1
		},
		//singleSelect:true,	
		columns: [
			[{
				field: 'tOperDesc',
				title: '手术名称',
				width: 120
			}, {
				field: 'tOperId',
				title: '手术ID'
			}]
		]
	});

	$('#ctlocdooperdata').datagrid({
		url: 'dhcclinic.jquery.csp',
		queryParams: {
			ClassName: "web.DHCDocDoOper",
			QueryName: "FindLocOperation",
			Arg1: "",
			ArgCnt: 1
		},
		//singleSelect:true,	
		columns: [
			[{
				field: 'tANCOper',
				title: '手术名称',
				width: 120
			}, {
				field: 'tANCOperDr',
				title: '手术ID'
			}, {
				field: 'tRowId',
				title: 'Rowid',
				hidden: true
			}]
		]
	});

	/////////////////////////////////////////////////////////////////////////
	$('#btnadd').bind('click', function() {
		AddCtcpOperData();
	});

	function AddCtcpOperData() {
		var rowsleft = $('#alloperdata').datagrid('getSelections');
		var len = rowsleft.length;
		if(len > 0) {
			for(var i = 0; i < len; i++) {
				var opdesc = rowsleft[i].OPTypeDes;
				var opid = rowsleft[i].rowid;
				var rowsright = $('#docdooperdata').datagrid('getRows');
				var ind = rowsright.length;
				if(ind > 0) {
					for(var j = 0; j < ind; j++) {
						if(opid == rowsright[j].tOperId) {
							alert("'" + rowsright[j].tOperDesc + "'" + "已存在,请取消选中后再添加!");
							return;
						}
					}
				}
				$('#docdooperdata').datagrid('insertRow', {
					index: ind,
					row: {
						tOperDesc: opdesc,
						tOperId: opid
					}
				});
				//$('#alloperdata').datagrid('unselectAll');
			}
		}
	}

	$('#btndelete').bind('click', function() {
		DeleteCtcpOperData();
	});

	function DeleteCtcpOperData() {
		var rowdatas = $('#docdooperdata').datagrid('getSelections');
		var len = rowdatas.length;
		if(len > 0) {
			for(var i = 0; i < len; i++) {
				var rowdata = rowdatas[i];
				var indexrow = $('#docdooperdata').datagrid('getRowIndex', rowdata);
				$('#docdooperdata').datagrid('deleteRow', indexrow)
			}
		}
	}

	$('#btnsavedocoper').bind('click', function() {
		SaveDocOperData();
	});

	function SaveDocOperData() {
		var docdata = $('#ctlocctcpdatagrid').datagrid('getSelected');
		if(docdata == null) {
			alert("请先选择手术医生!");
			return;
		}
		var docid = docdata.ctcpId;
		var opdatas = $('#docdooperdata').datagrid('getRows');
		var opdataslen = opdatas.length;
		var opdatastr = "";
		if(opdataslen > 0) {
			for(var i = 0; i < opdataslen; i++) {
				var opdataid = opdatas[i].tOperId;
				if(opdatastr == "") {
					opdatastr = opdataid;
				} else {
					opdatastr = opdatastr + "^" + opdataid;
				}
			}
		}
		$.ajax({
			url: "dhcclinic.jquery.method.csp",
			type: "POST",
			data: {
				ClassName: "web.DHCDocDoOper",
				MethodName: "SaveSelOper",
				Arg1: docid,
				Arg2: opdatastr,
				ArgCnt: 2
			},
			beforeSend: function() {
				$.messager.progress({
					text: '正在保存中...'
				});
			},
			success: function(data, response, status) {
				$.messager.progress('close');
				if(data == 0) {
					$.messager.show({
						title: '提示',
						msg: '保存成功'
					});
				} else {
					$.messager.alert('保存失败！', data, 'warning')
					return;
				}
			}

		})
	}

	///////////////////////////////////////////////////////////////////

	$('#btnaddctLoc').bind('click', function() {
		AddCtlocOperData();
	});

	function AddCtlocOperData() {
		//alert(1)
		var ctlocid = $('#ctloc').combogrid('getValue');
		var ctlocidText = $('#ctloc').combogrid('getText');
		if(ctlocidText == "") {
			alert("请选择手术科室!");
			return;
		}
		var rowsleft = $('#alloperdata').datagrid('getSelections');
		var len = rowsleft.length;
		if(len > 0) {
			for(var i = 0; i < len; i++) {
				var opdesc = rowsleft[i].OPTypeDes;
				var opid = rowsleft[i].rowid;
				$.ajax({
					type: "POST",
					url: "dhcclinic.jquery.method.csp",
					data: {
						ClassName: "web.DHCDocDoOper",
						MethodName: "JudgeIsRepeat",
						Arg1: ctlocid,
						Arg2: opid,
						ArgCnt: 2
					},
					//dataType: "json",
					async: false,
					success: function(data) {
						if(data == 1) {
							alert(opdesc + "手术重复,取消选中后重新添加!");
							return;
						} else {
							$.ajax({
								url: "dhcclinic.jquery.method.csp",
								type: "POST",
								async: false,
								data: {
									ClassName: "web.DHCDocDoOper",
									MethodName: "InsertLocOper",
									Arg1: ctlocid,
									Arg2: opid,
									ArgCnt: 2
								}
							})
						}
					}
				})

				//          var ret=_DHCDocDoOper.JudgeIsRepeat(ctlocid,opid);
				//			if(ret==1)
				//			{
				//				alert(opdesc+"手术重复,取消选中后重新添加!");
				//				return;
				//			}
				//			else{
				//			    $.ajax({
				//				url:"dhcclinic.jquery.method.csp",
				//				type:"POST",
				//				data:{
				//					ClassName:"web.DHCDocDoOper",
				//					MethodName:"InsertLocOper",
				//					Arg1:ctlocid,
				//					Arg2:opid,
				//					ArgCnt:2
				//				    }
				//			    })						
				//			}
			}
			var queryParams = $("#ctlocdooperdata").datagrid('options').queryParams;
			queryParams.Arg1 = ctlocid;
			$("#ctlocdooperdata").datagrid('reload');
		}
	}

	$('#btndeletectLoc').bind('click', function() {
		DeleteCtlocOperData();
	});

	function DeleteCtlocOperData() {
		var ctlocid = $('#ctloc').combogrid('getValue');
		if(ctlocid == "") {
			alert("请选择手术科室!");
			return;
		}
		var rowdatas = $('#ctlocdooperdata').datagrid('getSelections');
		var len = rowdatas.length;
		if(len > 0) {
			for(var i = 0; i < len; i++) {
				var rowid = rowdatas[i].tRowId;
				$.ajax({
					url: "dhcclinic.jquery.method.csp",
					type: "POST",
					data: {
						ClassName: "web.DHCDocDoOper",
						MethodName: "DeleteLocOper",
						Arg1: rowid,
						ArgCnt: 1
					}
				})
			}
			var queryParams = $("#ctlocdooperdata").datagrid('options').queryParams;
			queryParams.Arg1 = ctlocid;
			$("#ctlocdooperdata").datagrid('reload');
		}
	}

	////////////////////////////////////////////////////////////////////////////////////
	function InitForm() {
		$('#operation').combogrid({
			panelWidth: 200,
			panelHeight: 200,
			loadMsg: "正在加载中...",
			width: 150,
			url: 'dhcclinic.jquery.csp',
			idField: 'rowid',
			textField: 'OPTypeDes',
			method: "post",
			mode: 'remote',
			queryParams: {
				ClassName: "web.DHCDocDoOper",
				QueryName: "FindOperation",
				Arg1: "QueryFilter",
				Arg2: "",
				ArgCnt: 2
			},
			columns: [
				[{
					field: 'OPTypeDes',
					title: '手术名称',
					width: 130
				}, {
					field: 'rowid',
					title: '手术ID'
				}]
			]
		});
		$("#name").textbox({
			width: 150
		});
		$("#workno").textbox({
			width: 150
		});
		$('#ctloc').combogrid({
			panelWidth: 200,
			panelHeight: 200,
			loadMsg: "正在加载中...",
			width: 150,
			url: 'dhcclinic.jquery.csp',
			idField: 'ctlocId',
			textField: 'ctlocDesc',
			method: "post",
			queryParams: {
				ClassName: "web.DHCCLCom",
				QueryName: "FindLocList",
				Arg1: "QueryFilter",
				Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
				Arg3: "",
				ArgCnt: 3
			},
			columns: [
				[{
					field: 'ctlocId',
					title: '科室ID',
					hidden: true
				}, {
					field: 'ctlocDesc',
					title: '科室名称'
				}, {
					field: 'ctlocCode',
					title: '科室代码',
					hidden: true
				}]
			]
		});

		$("#opdesc").textbox({
			width: 120
		});
		$('#oplevel').combogrid({
			panelWidth: 150,
			panelHeight: 150,
			loadMsg: "正在加载中...",
			width: 120,
			url: 'dhcclinic.jquery.csp',
			idField: 'operCategId',
			textField: 'operCategLDesc',
			queryParams: {
				ClassName: "web.DHCANCOrc",
				QueryName: "FindORCOperationCategory",
				ArgCnt: 0
			},
			columns: [
				[{
					field: 'operCategLDesc',
					title: '分类',
					width: 100
				}, {
					field: 'operCategId',
					title: '分类ID'
				}]
			]
		});
	}

})