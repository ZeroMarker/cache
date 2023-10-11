//ҳ��Event
function InitCRuleOperWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleOper"),value);
		}	
	});
	var p = $('#gridCRuleOper').datagrid('getPager');
	    if (p){
	        $(p).pagination({ //���÷�ҳ������
	           //��ҳ���ܿ���ͨ��Pagination���¼����ú�̨��ҳ������ʵ��
	        	onRefresh:function(){
					obj.gridCRuleOperKeysLoad("");  //ˢ�µ�ǰҳ
					$("#btnAdd_one").linkbutton("disable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
	        	}
	 
	        });
	    }
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '������Ϣ�༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
	//�༭����2
	obj.SetDiaglog2=function(){
		$('#layer_two').dialog({
			title: '�ؼ��ʱ༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave2_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer_two').close();
				}
			}]
		});
	}
	
	//��ť��ʼ��
    obj.LoadEvent = function(args){ 
		$("#btnAdd_one").linkbutton("disable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    	obj.gridCRuleOperLoad();
		obj.gridCRuleOperKeysLoad();
		//����
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//�޸�
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleOper.getSelected();
			obj.layer(rd);	
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//����
		$('#btnAdd_one').on('click', function(){
			obj.layer_two();
		});
    	//�޸�
		$('#btnEdit_one').on('click', function(){
			var rd2=obj.gridCRuleOperKeys.getSelected();
			obj.layer_two(rd2);	
		});
		//ɾ��
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete2_click();
		});
    }
    //˫���༭�¼�
	obj.gridCRuleOper_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//ѡ��
	obj.gridCRuleOper_onSelect = function (){
		var rowData = obj.gridCRuleOper.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridCRuleOperKeysLoad("");
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleOper.clearSelections();
			$("#btnAdd_one").linkbutton("disable");
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAdd_one").linkbutton("enable");
			obj.gridCRuleOperKeysLoad(Parref);
		}
	} //˫���༭�¼�
	obj.gridCRuleOperKeys_onDbselect = function(rd2){
		obj.layer_two(rd2);
	}
	//ѡ��
	obj.gridCRuleOperKeys_onSelect = function (){
		var rowData2 = obj.gridCRuleOperKeys.getSelected();
		if($("#btnEdit_one").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowId  = (rowData2 ? rowData2["ID"] : '');
		if (rowId == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleOperKeys.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
		obj.RecRowID2 = rowId;
	}
	//����
	obj.btnSave_click = function(){
		var errinfo = "";
		var Type = $('#cboType').combobox('getValue');
		var LocDr = $('#cboLocation').combobox('getValue');
		var OperIncDr = $('#cboOperInc').combobox('getValue');
		var OperDxDr = '';
		var OperDesc = $('#txtOperDesc').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		
		
		if (!LocDr) {
			errinfo = errinfo + "���Ҳ�����Ϊ��!<br>";
		}	
		if ((!OperIncDr)&&(!OperDxDr)&&(!OperDesc)) {
			errinfo = errinfo + "�п����͡��������Ʋ�����ͬʱΪ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Type;
		InputStr += "^" + LocDr;
		InputStr += "^" + OperIncDr;
		InputStr += "^" + OperDxDr;
		InputStr += "^" + OperDesc;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleOper",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-100'){
				$.messager.alert("������ʾ" , '���������ظ�!');
			}else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
			
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCRuleOperLoad(); //ˢ�µ�ǰҳ
		}
	}
	//�������
	obj.btnSave2_click = function(){
		var errinfo = "";
		var InWord = $('#txtInWord').val();
		var ExWords = $('#txtExWords').val();
		var CRulerd = obj.gridCRuleOper.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		
		if ((InWord.indexOf(" ") >= 0) || (InWord == '')) {
			errinfo = errinfo + "�ؼ���(����)������Ϊ��!<br>";
		}	
		if ((ExWords.indexOf(" ") >= 0) || (ExWords == '')) {
			errinfo = errinfo + "�ؼ���(�ų�)������Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID2;
		InputStr += "^" + Parref;
		InputStr += "^" + InWord;
		InputStr += "^" + ExWords;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleOperKeys",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-100'){
				$.messager.alert("������ʾ" , '��׼����+�ؼ����ظ�!');
			}else{
			}
			
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID2 = flg
			obj.gridCRuleOperKeysLoad(Parref); //ˢ�µ�ǰҳ
		}
	}
	//ɾ������ 
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleOper",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleOperLoad();  //ˢ�µ�ǰҳ
					obj.gridCRuleOperKeysLoad("");
					$("#btnAdd_one").linkbutton("disable");
				}
			} 
		});
	}//ɾ������ 
	obj.btnDelete2_click = function(){
		var CRulerd = obj.gridCRuleOper.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		if (obj.RecRowID2==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleOperKeys",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleOperKeysLoad(Parref);  //ˢ�µ�ǰҳ
					$("#btnAdd_one").linkbutton("enable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Type = rd["Type"];
			var LocDesc = rd["LocDesc"];
			var LocID = rd["LocID"];
			var Operation = rd["Operation"];
			var IncID = rd["IncID"];
			var IncDesc = rd["IncDesc"];
			var IsActive = rd["IsActive"];
			
			$('#cboType').combobox('setValue',Type);
			$('#cboLocation').combobox('setValue',LocID);
			$('#cboLocation').combobox('setText',LocDesc);
			$('#txtOperDesc').val(Operation);
			$('#cboOperInc').combobox('setValue',IncID);
			$('#cboOperInc').combobox('setText',IncDesc);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#cboType').combobox('setValue','');
			$('#cboLocation').combobox('setValue','');
			$('#txtOperDesc').val('');
			$('#cboOperInc').combobox('setValue','');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	//���ô���-��ʼ��
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			var InWord = rd["InWord"];
			var ExWords = rd["ExWords"];
			
			$('#txtInWord').val(InWord);
			$('#txtExWords').val(ExWords);
		}else{
			obj.RecRowID2 = "";
			$('#txtInWord').val('');
			$('#txtExWords').val('');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	obj.gridCRuleOperKeysLoad = function(aRuleID){
		$("#gridCRuleOperKeys").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleOperSrv",
			QueryName:"QryCRuleOperKeys",	
			aOperID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleOperKeys').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.RecRowID2 = "";
		$("#btnAdd_one").linkbutton("enable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    }
	obj.gridCRuleOperLoad = function(){
		originalData["gridCRuleOper"]="";
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleOperSrv",
			QueryName:"QryCRuleOper",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleOper').datagrid('loadData', rs);					
		});
    }
}