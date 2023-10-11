//ҳ��Event
function InitExamRoleEvent(obj){
	//������ʼ��
	$('#winPathExamRole').dialog({
		title: '������˽�ɫά��',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	
	/*
	// ���ɾ����ť�Ƿ�����ɾ�������������ظð�ť
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathExamRole")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}*/
	
    obj.LoadEvent = function(args){ 
     	//����
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//�ر�
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winPathExamRole').close();
     	});
		//���
     	$('#btnAdd').on('click', function(){
			obj.layer();
     	});
		//�༭
		$('#btnEdit').on('click', function(){
	     	var rd=obj.gridPathExamRole.getSelected();
			obj.layer(rd);		
     	});
		//ɾ��
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     }

	//ѡ����˽�ɫ
	obj.gridPathExamRole_onSelect = function (){
		var rowData = obj.gridPathExamRole.getSelected();
		if (rowData["OID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.gridPathExamRole.clearSelections();  //���ѡ����
		} else {
			obj.RecRowID = rowData["OID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	} 
	//˫���༭�¼� ����
	obj.gridPathExamRole_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//����
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var RoleType = $('#cboRoleType').combobox('getValue');
		var RoleValue = $('#cboRoleValue').combobox('getValue');
		var Priority = $('#txtPriority').val();
		var HospID = $("#cboSSHosp").combobox('getValue');
		if (HospID=="") HospID=session['DHCMA.HOSPID'];	
		
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		
		if (!Code) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		if (!RoleType) {
			errinfo = errinfo + "��ɫ����Ϊ��!<br>";
		}
		if (!RoleValue) {
			errinfo = errinfo + "��ɫ����Ϊ��!<br>";
		}
		if (!Priority) {
			errinfo = errinfo + "���ȼ�Ϊ��!<br>";
		}
		
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathExamRole",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "�������б���������Ŀ�ظ��������޸�!<br>";
	  	}
	  	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + RoleValue;
		inputStr = inputStr + CHR_1 + RoleType;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + Priority;
		inputStr = inputStr + CHR_1 + HospID;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathExamRole",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("������ʾ", "��������!" , 'info');
			} else {
				$.messager.alert("������ʾ", "�������ݴ���!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathExamRole').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.gridPathExamRole.reload() ;//ˢ�µ�ǰҳ
			obj.RecRowID = "";
		}
	}
	//ɾ��
	obj.btnDelete_click = function(){
		var rowID = obj.gridPathExamRole.getSelected()["xID"];
		debugger
		if (rowID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathExamRole",
					MethodName:"DeleteById",
					aId:rowID,
					aHospID: $("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("������ʾ","ϵͳ�������ò�����ɾ����", 'info');
					} else {
						$.messager.alert("������ʾ","ɾ�����ݴ���!Error=" + flg, 'info');
					}
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridPathExamRole.reload() ;//ˢ�µ�ǰҳ
				}
			} 
		});
	}
	
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID=rd["xID"];
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			var RoleType = rd["TypeCode"];
			var RoleValue = rd["Value"];
			var Priority = rd["Priority"];
			var IsActive =(rd["IsActive"]=="��"? true: false);

			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboRoleType').combobox('select',RoleType);
			$('#cboRoleValue').combobox('select',RoleValue);
			$('#txtPriority').val(Priority);
			$('#chkIsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtRoleType').combobox('clear');
			$('#cboRoleValue').combobox('clear');
			$('#txtPriority').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
		$HUI.dialog('#winPathExamRole').open();
	}
}