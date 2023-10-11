//ҳ��Event
function InitOROperCatWinEvent(obj){
	//��ť��ʼ��
    obj.LoadEvent = function(args){
		var flag ="";		
		obj.LoadgridOROper();
		
		//����
		$('#btnAdd').on('click', function(){
			obj.OperCat('');
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOperCat.getSelected();
			obj.OperCat(rd);
		});
		
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OperCatEdit').close();
	    });		
		
		//����
		$('#btnOper').on('click', function(){
			obj.UpdateOperCat(1);	
		});
		//����
		$('#btnCancle').on('click', function(){
			obj.DeleteOperCat(1);		
		});
		
		//ȫ��
		$('#btnAll').on('click', function(){
			flag="";
			obj.gridOROperLoad();
		});
		//δ����
		$('#btnUnCat').on('click', function(){
			flag="0";
			obj.gridOROperLoad(flag);
		
		});
		//�ѷ���
		$('#btnCat').on('click', function(){
			flag="1";
			obj.gridOROperLoad(flag);
	
		});
		//�Զ�ƥ��
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.IRS.CRuleOperCatSrv',
				MethodName:'SynOperAnaesCat'
			},false);
			obj.gridOROperLoad();
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "û�п�ƥ�����ƥ��ʧ��!" , 'info');		
			}else {
				$.messager.popover({msg: '�ɹ�ƥ��'+flg+'��!',type:'success',timeout: 1000});
			}
		});
		//����
		$('#btnExport').on('click', function(){
			obj.ExportOperInfo(flag);	
		});

		$("#cboOperCatMap").combobox({
			onSelect: function (record) {
				obj.gridOROperLoad(flag);
			},onUnselect: function (record) {
				obj.gridOROperLoad(flag);
			}
		})
	}

    
	//����
	obj.ExportOperInfo= function(aType,aFlag) {
		var rows = $m({
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			QueryName:"QryOperAnaes",
			ResultSetType:'array',
			aOperCat:$('#cboOperCatMap').combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'),
			aFlag:aFlag,
			aShowAll:0
		},false);
		if (!rows) return false;   
		var rowList = JSON.parse(rows);
		if (rowList.length>0) {
			$('#gridOROper').datagrid('toExcel', {
			    filename: '������Ϣ.xls',
			    rows: rowList,
			    worksheet: '������Ϣ',
			});		
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}			
	}
	
	//�������
	obj.UpdateOperCat= function(aType) {
		var Catrd  = $("#gridOperCat").datagrid('getSelected');
		var Operrd = $("#gridOROper").datagrid('getChecked');
	
		var CatID  = (Catrd ? Catrd["ID"] : '');
		var OperIDs="";
		for (ind=0;ind<Operrd.length;ind++) {
			OperIDs +=Operrd[ind].OperID+","
		}
		
		if ((OperIDs == "")||(CatID == "")) {
			$.messager.alert("������ʾ",'ά�������ϵ��ͬʱѡ���������༰������Ϣ!','info');
			return;
		}else{
			var flg = $m({
				ClassName:'DHCHAI.IRS.CRuleOperCatSrv',
				MethodName:'UpdateCat',
				aIDs:OperIDs,
				aCatID:CatID,
				aType:aType,
				aIsAll:1
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "����ά��ʧ��" , 'info');	
				return;	
			}else {
				$.messager.popover({msg: '����ά���ɹ�',type:'success',timeout: 1000});
				$("#gridOROper").datagrid('reload');
			}
		}	
	}
	//��������
	obj.DeleteOperCat= function(aType) {
		var Catrd  = $("#gridOperCat").datagrid('getSelected');
		var Operrd = $("#gridOROper").datagrid('getChecked');
		
		var CatID  = (Catrd ? Catrd["ID"] : '');
		var OperIDs="";
		for (ind=0;ind<Operrd.length;ind++) {
			OperIDs +=Operrd[ind].OperID+","
		}
		
		var flg = $m({
			ClassName:'DHCHAI.IRS.CRuleOperCatSrv',
			MethodName:'DeleteCat',
			aIDs:OperIDs,
			aCatID:CatID,
			aType:aType,
			aIsAll:1
		},false);
	
		if (parseInt(flg) <=0) {
			if (parseInt(flg)==0) {
				$.messager.alert("��ʾ", "�޷��೷��" , 'info');	
				return;	
			}else {
				$.messager.alert("������ʾ", "��������ά��ʧ��" , 'info');	
				return;	
			}
		}else {
			$.messager.popover({msg: '��������ά���ɹ�',type:'success',timeout: 1000});
			$("#gridOROper").datagrid('reload');
		}
	}
	
	
	//����
	obj.gridOROperLoad = function(Flag) {
		$('#gridOROper').datagrid('load',{
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			QueryName:"QryOperAnaes",
			aOperCat:$('#cboOperCatMap').combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'),
			aFlag:Flag,
			aShowAll:0
		});
	}
	

	//����
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			flag="";
			obj.gridOROperLoad();
		}	
	});
	
	$('#searchcat').searchbox({ 
		searcher:function(value,name){
			obj.gridOperCat.load({
				ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
				QueryName:"QryOperCat",
				aAlias:value
			});
		}	
	});
		
	
	//�����ʼ��
	obj.OperCatEdit =function() {
		$('#OperCatEdit').dialog({
			title: '��������ά��',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	}
	
	//�༭����-��ʼ��
	obj.OperCat = function(rd){
		if (rd){
			obj.RecRowID=rd["ID"];
			obj.RecKeyID=rd["KeyID"];
			var OperCat = rd["OperCat"];
			var OperType = rd["OperType"];
			var KeyType = rd["KeyType"];
			var IncludeKey = rd["IncludeKey"];
			var ExcludeKeys = rd["ExcludeKeys"];
		   
			$('#cboOperCat').combobox('setValue',obj.RecRowID);
			$('#cboOperCat').combobox('setText',OperCat);
			//$('#cboOperCat').combobox('disable');
			$('#cboOperType').combobox('setValue',OperType);
			$('#cboKeyType').combobox('setValue',KeyType);
			$('#txtIncludeKey').val(IncludeKey);
			$('#txtExcludeKeys').val(ExcludeKeys);

		}else {
			obj.RecRowID="";
			obj.RecKeyID="";
			$('#cboOperCat').combobox('enable');
			$('#cboOperCat').combobox('setValue',"");
			$('#cboOperType').combobox('setValue',"");
			$('#cboKeyType').combobox('setValue',"");
			$('#txtIncludeKey').val("");
			$('#txtExcludeKeys').val("");
		}
		$('#OperCatEdit').show();
		obj.OperCatEdit();
	}
	//˫���༭�¼�
	obj.gridOperCat_onDbselect = function(rd){
		obj.OperCat(rd);
	}
	
	//ѡ��
	obj.gridOperCat_onSelect = function (){
		var rowData = obj.gridOperCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOperCat.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//����
	obj.btnSave_click = function(){
		var ID          = (obj.RecRowID ? obj.RecRowID: $('#cboOperCat').combobox('getValue'));		
		var OperCat     = $('#cboOperCat').combobox('getText');
		var OperType    = $('#cboOperType').combobox('getValue');
		var KeyType     = $('#cboKeyType').combobox('getValue');
		var IncludeKey  = $('#txtIncludeKey').val();
		var ExcludeKeys = $('#txtExcludeKeys').val();
	    var ActUser     = $.LOGON.USERID;
	     if (!OperCat) {
		    $.messager.alert("������ʾ", "�������಻����Ϊ�գ�" , 'info');	
			return;	
	    }
	    if (!OperType) {
		    $.messager.alert("������ʾ", "�������Ϊ�գ�" , 'info');	
			return;	
	    }
	    if (!KeyType) {
		    $.messager.alert("������ʾ", "�ؼ������Ͳ�����Ϊ�գ�" , 'info');	
			return;	
	    }
	    if (!IncludeKey) {
		    $.messager.alert("������ʾ", "�����ʲ�����Ϊ�գ�" , 'info');	
			return;	
	    }
		var InputStr = ID;
		InputStr += "^" + OperCat;
		InputStr += "^" + OperType;
		InputStr += "^" + 1;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleOperCat",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("������ʾ", "���������ظ���" , 'info');	
				return;	
			}else {
				$.messager.alert("������ʾ", "����ʧ�ܣ�" , 'info');	
				return;	
			}
		}else {
			var CatID=(ID ? ID : flg);
			var InputStr=CatID;
			InputStr += "^" + obj.RecKeyID;
			InputStr += "^" + KeyType;
			InputStr += "^" + IncludeKey;
			InputStr += "^" + ExcludeKeys;
			InputStr += "^" + 1;
			InputStr += "^" + '';
			InputStr += "^" + '';
			InputStr += "^" + ActUser;
			var ret = $m({
				ClassName:"DHCHAI.IR.CRuleOperCatKeys",
				MethodName:"Update",
				aInputStr:InputStr,
				aSeparete:"^"
			},false);
			if (parseInt(ret) <= 0) {
				if (parseInt(ret)=='-2') {
					$.messager.alert("������ʾ", "��������������ظ���" , 'info');	
					return;	
				}else {
					$.messager.alert("������ʾ", "����ʧ�ܣ�" , 'info');	
					return;	
				}
			}else {
		
				$HUI.dialog('#OperCatEdit').close();
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridOperCat.reload();
			}
		}
	}
	
	//ɾ��
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleOperCat",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert('ɾ��ʧ��!','info');					
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridOperCat.reload();
				}
			} 
		});
	}

	
}