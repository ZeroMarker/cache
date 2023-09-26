/**
 * @description ҩƷά��-ҩѧ����
 */
function DHCPHCCAT() {
	$.parser.parse('#lyDHCPHCCat');
	InitTreeGridDHCPHCCat();
	PHA.SearchBox("conPHCCatAlias", {
		width: parseInt($("#treegridDHCPHCCatBar").width()) - 20,
		searcher: function (text) {
			$('#treegridDHCPHCCat').treegrid("options").queryParams.InputStr = "^^" + text;
			$('#treegridDHCPHCCat').treegrid("reload");
			// $("#conPHCCatAlias").next().children().select();
			$("#conPHCCatAlias").searchbox("clear");
			$("#conPHCCatAlias").next().children().focus();
			$('#treegridDHCPHCCat').treegrid("unselectAll");
		},
		placeholder: "�������ƴ�����ƻس���ѯ"
	});
	$("#btnSaveDHCPHCCat").on("click", function () {
		PHA.Confirm("��ʾ", "��ȷ�ϱ�����?", function () {
			SaveDHCPHCCat("");
		});
	});
	$("#btnSaveDHCPHCCatS").on("click", function () {
		PHA.Confirm("��ʾ", "��ȷ�ϱ���Ϊͬ����?", function () {
			SaveDHCPHCCat("S");
		});
	});
	$("#btnSaveDHCPHCCatI").on("click", function () {
		PHA.Confirm("��ʾ", "��ȷ�ϱ���Ϊ�¼���?", function () {
			SaveDHCPHCCat("I");
		});
	});
	$("#btnAddDHCPHCCat").on("click", function () {
		PHA.Confirm("��ʾ", "��ȷ��������?", function () {
			AddDHCPHCCat();
		});
	});
	$("#btnDelDHCPHCCat").on("click", function () {
		PHA.Confirm("��ʾ", "��ȷ��ɾ����?", function () {
			DelDHCPHCCat();
		});
	});
	MakeToolTip();
}

/**
 * @description ��ʼ��ҩѧ�������α��
 */
function InitTreeGridDHCPHCCat() {
	var treeColumns = [
		[{
				field: 'phcCatDesc',
				title: 'ҩѧ����',
				width: 700
			},
			{
				field: 'phcCatCode',
				title: '����',
				width: 200,
				hidden: false
			},
			{
				field: 'phcCatLevel',
				title: '����',
				width: 100,
				align: 'center',
				hidden: false
			},

			{
				field: 'phcCatId',
				title: 'phcCatId',
				hidden: true
			},
			{
				field: '_parentId',
				title: 'parentId',
				hidden: true
			},
			{
				field: 'phcCatParent',
				title: '����Id',
				hidden: true
			}
		]
	];
	var dataOptions = {
		idField: 'phcCatId',
		treeField: 'phcCatDesc',
		rownumbers: false, //�к� 
		columns: treeColumns,
		queryParams: {
			ClassName: "PHA.IN.DHCPHCCat.Query",
			QueryName: "DHCPHCCat",
			page: 1,
			rows: 9999
		},
		toolbar: "#treegridDHCPHCCatBar",
		onClickRow: function (rowId) {
			$.cm({
				ClassName: 'PHA.IN.DHCPHCCat.Query',
				MethodName: 'SelectDHCPHCCat',
				PHCCatId: rowId,
				ResultSetType: 'Array'
			}, function (arrData) {
				PHA.SetVals(arrData);
				$("#phcCatCode").focus();
			});
		},
		onExpand: function () {
			// $(this).treegrid("reload",3)

		},
		onLoadSuccess: function () {
			PHA.DomData("#dataDHCPHCCat", {
				doType: "clear"
			});
			$("#phcCatDescAll").val("");
		}

	}
	PHA.TreeGrid("treegridDHCPHCCat", dataOptions);
}

/**
 * @description ����
 */
function AddDHCPHCCat() {
	var tgSelect = $('#treegridDHCPHCCat').treegrid('getSelected') || "";
	if (tgSelect == "") {
		PHA.Popover({
			msg: "����ѡ����Ҫ�����ҩѧ����",
			type: "alert"
		});
		return;
	}
	PHA.DomData("#dataDHCPHCCat", {
		doType: "clear"
	});
	$("#phcCatCode").focus();
}

/**
 * @description ����
 * @param {String} saveType ���淽ʽ(S:����Ϊͬ��,I:����Ϊ�¼�,"":���浱ǰ)
 */
function SaveDHCPHCCat(saveType) {
	var tgSelect = $('#treegridDHCPHCCat').treegrid('getSelected') || "";
	if (tgSelect == "") {
		PHA.Popover({
			msg: "����ѡ����Ҫ�����ҩѧ����",
			type: "alert"
		});
		return;
	}
	var phcCatPar = "";
	var phcCatId = "";
	if (saveType == "") {
		phcCatId = tgSelect.phcCatId;
		phcCatPar = tgSelect.phcCatParent;
	} else if (saveType == "S") {
		// ����Ϊͬ��
		phcCatPar = tgSelect.phcCatParent;
	} else if (saveType == "I") {
		// ����Ϊ�¼�
		phcCatPar = tgSelect.phcCatId;
	}
	var valsArr = PHA.DomData("#dataDHCPHCCat", {
		doType: "save"
	});
	var valsStr = valsArr.join("^");
	if (valsStr == "") {
		return;
	}
	var saveRet = $.cm({
		ClassName: 'PHA.IN.DHCPHCCat.Save',
		MethodName: 'Save',
		PHCCatId: phcCatId,
		DataStr: phcCatPar + "^" + valsStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
		ReloadPhcCatTreeById(tgSelect.phcCatId); 
	}
}

/**
 * @description ɾ��
 */
function DelDHCPHCCat() {
	var tgSelect = $('#treegridDHCPHCCat').treegrid('getSelected') || "";
	if (tgSelect == "") {
		PHA.Popover({
			msg: "����ѡ����Ҫɾ����ҩѧ����",
			type: "alert"
		});
		return;
	}
	var phcCatId = tgSelect.phcCatId;
	var saveRet = $.cm({
		ClassName: 'PHA.IN.DHCPHCCat.Save',
		MethodName: 'Delete',
		PHCCatId: phcCatId,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: 'ɾ���ɹ�',
			type: 'success'
		});
		$("#treegridDHCPHCCat").treegrid("reload");
		$('#treegridDHCPHCCat').treegrid("unselectAll");
		PHA.DomData("#dataDHCPHCCat", {
			doType: "clear"
		});
		$("#phcCatDescAll").val("");
	}
}

/**
 * ����ѡ�е�ҩѧId,���¼���ˢ��
 */
function ReloadPhcCatTreeById(phcCatId){
	if ((phcCatId!=undefined)&&(phcCatId!="")){
		var parentObj=$('#treegridDHCPHCCat').treegrid('getParent',phcCatId);
		if (parentObj==null){
			$('#treegridDHCPHCCat').treegrid('reload');
		}else{
			needLoadId=parentObj.phcCatId;
			if (needLoadId){
				$('#treegridDHCPHCCat').treegrid('reload',needLoadId);
			}	
		}
		return;
	}
	var selectNode = $("#treegridDHCPHCCat").treegrid('getSelected');
	if(selectNode==null){
		$('#treegridDHCPHCCat').treegrid('reload');
		return;
	}
	var selectId=selectNode.phcCatId;
	var needLoadId=selectId;
	var childLen=$('#treegridDHCPHCCat').treegrid('getChildren',selectId).length;
	if (childLen==0){
		needLoadId=$('#treegridDHCPHCCat').treegrid('getParent',selectId).phcCatRowId;
	}
	$('#treegridDHCPHCCat').treegrid('reload',needLoadId);
}