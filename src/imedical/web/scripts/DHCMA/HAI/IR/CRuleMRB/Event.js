//ҳ��Event
function InitDictionaryWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleMRB"),value);
		}	
	});
	var p = $('#gridCRuleMRB').datagrid('getPager');
	if (p){
		$(p).pagination({ //���÷�ҳ������
			//��ҳ���ܿ���ͨ��Pagination���¼����ú�̨��ҳ������ʵ��
	        onRefresh:function(){
				obj.RecRowID=""
		       	obj.gridCRuleMRBLoad();
				obj.gridMRBBactLoad('');
				$("#btnAdd_one").linkbutton("disable");
				$("#btnEdit_one").linkbutton("disable");
				$("#btnDelete_one").linkbutton("disable");
				$("#btnAdd_two").linkbutton("disable");
				$("#btnEdit_two").linkbutton("disable");
				$("#btnDelete_two").linkbutton("disable");
				$("#btnAdd_three").linkbutton("disable");
				$("#btnEdit_three").linkbutton("disable");
				$("#btnDelete_three").linkbutton("disable");
				$("#btnAdd_four").linkbutton("disable")
				$("#btnEdit_four").linkbutton("disable");
				$("#btnDelete_four").linkbutton("disable");
	        }
		});
	}
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '������ҩ������༭',
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
			title: 'ϸ���༭',
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
	//�༭����3
	obj.SetDiaglog3=function(){
		$('#layer_three').dialog({
			title: '�����ر༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave3_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer_three').close();
				}
			}]
		});
	}
	//�༭����4
	obj.SetDiaglog4=function(){
		$('#layer_four').dialog({
			title: '�ؼ��ʱ༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave4_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer_four').close();
				}
			}]
		});
	}
	//�༭����5
	obj.SetDiaglog5=function(){
		$('#layer_five').dialog({
			title: '����ҽ���༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave5_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer_five').close();
				}
			}]
		});
	}
	//��ť��ʼ��
    obj.LoadEvent = function(args){ 
    	obj.gridCRuleMRBLoad();
		obj.gridMRBBactLoad('');
		$("#btnAdd_one").linkbutton("disable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
		$("#btnAdd_two").linkbutton("disable");
		$("#btnEdit_two").linkbutton("disable");
		$("#btnDelete_two").linkbutton("disable");
		$("#btnAdd_three").linkbutton("disable");
		$("#btnEdit_three").linkbutton("disable");
		$("#btnDelete_three").linkbutton("disable");
		$("#btnAdd_four").linkbutton("disable");
		$("#btnEdit_four").linkbutton("disable");
		$("#btnDelete_four").linkbutton("disable");
		//����
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//�޸�
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleMRB.getSelected();
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
			var rd2=obj.gridMRBBact.getSelected();
			obj.layer_two(rd2);	
		});
		//ɾ��
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete2_click();
		});
		//����
		$('#btnAdd_two').on('click', function(){
			obj.layer_three();
		});
    	//�޸�
		$('#btnEdit_two').on('click', function(){
			var rd2=obj.gridMRBAnti.getSelected();
			obj.layer_three(rd2);	
		});
		//ɾ��
		$('#btnDelete_two').on('click', function(){
			obj.btnDelete3_click();
		});
		//����
		$('#btnAdd_three').on('click', function(){
			obj.layer_four();
		});
    	//�޸�
		$('#btnEdit_three').on('click', function(){
			var rd2=obj.gridMRBKeys.getSelected();
			obj.layer_four(rd2);	
		});
		//ɾ��
		$('#btnDelete_three').on('click', function(){
			obj.btnDelete4_click();
		});
		//����
		$('#btnAdd_four').on('click', function(){
			obj.layer_five();
		});
    	//�޸�
		$('#btnEdit_four').on('click', function(){
			var rd2=obj.gridIsolate.getSelected();
			obj.layer_five(rd2);	
		});
		//ɾ��
		$('#btnDelete_four').on('click', function(){
			obj.btnDelete5_click();
		});
    }
    
    //˫���༭�¼�
	obj.gridCRuleMRB_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//ѡ��
	obj.gridCRuleMRB_onSelect = function (){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.gridMRBBactLoad("");
			obj.gridMRBAntiLoad("");   
			obj.gridMRBKeysLoad("");   
			obj.gridIsolateLoad("");  
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleMRB.clearSelections();
			$("#btnAdd_one").linkbutton("disable");
			$("#btnAdd_two").linkbutton("disable");
			$("#btnAdd_three").linkbutton("disable");
			$("#btnAdd_four").linkbutton("disable");
		
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAdd_one").linkbutton("enable");
			$("#btnAdd_two").linkbutton("enable");
			$("#btnAdd_three").linkbutton("enable");
			$("#btnAdd_four").linkbutton("enable");
		
			obj.gridMRBBactLoad(Parref); 
			obj.gridMRBAntiLoad(Parref);   
			obj.gridMRBKeysLoad(Parref);   
			obj.gridIsolateLoad(Parref);  
		}
	} 
	//˫���༭�¼��ͼ�걾
	obj.gridMRBBact_onDbselect = function(rd){
		obj.layer_two(rd);
	}
	//ѡ���ͼ�걾
	obj.gridMRBBact_onSelect = function (){
		var rowData = obj.gridMRBBact.getSelected();
		if($("#btnEdit_one").hasClass("l-btn-disabled")) obj.RecRowID1="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID1) {
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridMRBBact.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
		obj.RecRowID1 = rowId;
	}
	//˫���༭�¼�������Ŀ
	obj.gridMRBAnti_onDbselect = function(rd){
		obj.layer_three(rd);
	}
	//ѡ�������Ŀ
	obj.gridMRBAnti_onSelect = function (){
		var rowData = obj.gridMRBAnti.getSelected();
		if($("#btnEdit_two").hasClass("l-btn-disabled")) obj.RecRowID2="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID2) {
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			obj.gridMRBAnti.clearSelections();
		} else {
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("enable");
			$("#btnDelete_two").linkbutton("enable");
		}
		obj.RecRowID2 = rowId;
	}
	//˫���༭�¼�������
	obj.gridMRBKeys_onDbselect = function(rd){
		obj.layer_four(rd);
	}
	//ѡ�������
	obj.gridMRBKeys_onSelect = function (){
		var rowData = obj.gridMRBKeys.getSelected();
		if($("#btnEdit_three").hasClass("l-btn-disabled")) obj.RecRowID3="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID3) {
			$("#btnAdd_three").linkbutton("enable");
			$("#btnEdit_three").linkbutton("disable");
			$("#btnDelete_three").linkbutton("disable");
			obj.gridMRBKeys.clearSelections();
		} else {
			$("#btnAdd_three").linkbutton("disable");
			$("#btnEdit_three").linkbutton("enable");
			$("#btnDelete_three").linkbutton("enable");
		}
		obj.RecRowID3 = rowId;
	}
	//˫���༭�¼��쳣��־
	obj.gridIsolate_onDbselect = function(rd){
		obj.layer_five(rd);
	}
	//ѡ���쳣��־
	obj.gridIsolate_onSelect = function (){
		var rowData = obj.gridIsolate.getSelected();
		if($("#btnEdit_four").hasClass("l-btn-disabled")) obj.RecRowID4="";
		var rowId = (rowData != null) ? rowData["ID"] : '';
		
		if (rowId == obj.RecRowID4) {
			$("#btnAdd_four").linkbutton("enable");
			$("#btnEdit_four").linkbutton("disable");
			$("#btnDelete_four").linkbutton("disable");
			obj.gridIsolate.clearSelections();
		} else {
			$("#btnAdd_four").linkbutton("disable");
			$("#btnEdit_four").linkbutton("enable");
			$("#btnDelete_four").linkbutton("enable");
		}
			obj.RecRowID4 = rowId;
	}
	//����
	obj.btnSave_click = function(){
		var errinfo = "";
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		var MRBCatDr = $('#cboMRBCat').combobox('getValue');
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var ActUser     = $.LOGON.USERID;
		var IsRuleCheck = $('#chkIsRuleCheck').checkbox('getValue')? '1':'0';
		var IsAntiCheck= $('#chkIsAntiCheck').checkbox('getValue')? '1':'0';
		var AnitCatCnt = $('#txtAnitCatCnt').val();
		var AnitCatCnt2 = $('#txtAnitCatCnt2').val();
		var IsKeyCheck = $("#chkIsKeyCheck").checkbox('getValue')? '1':'0';
		var Note =$('#txtNote').val();
		var IsIRstCheck = $("#chkIsIRstCheck").checkbox('getValue')? '1':'0';
		var IsResKeyCheck = $("#chkIsResKeyCheck").checkbox('getValue')? '1':'0';
		
		if (!BTCode) {
			errinfo = errinfo + "���벻����Ϊ��!<br>";
		}	
		if (!BTDesc) {
			errinfo = errinfo + "���Ʋ�����Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + MRBCatDr;
		InputStr += "^" + IsActive;
		InputStr += "^" + IsRuleCheck;
		InputStr += "^" + IsAntiCheck
		InputStr += "^" + AnitCatCnt;
		InputStr += "^" + AnitCatCnt2;
		InputStr += "^" + IsKeyCheck;
		InputStr += "^" +'';
		InputStr += "^" +'';
		InputStr += "^" + ActUser;
		InputStr += "^" + Note;
		InputStr += "^" + IsIRstCheck;
		InputStr += "^" + IsResKeyCheck;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRB",
			MethodName:"Update",
			InStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-2'){
				$.messager.alert("������ʾ" , '�����ظ�!');
			}else{
				$.messager.alert("������ʾ" , '����ʧ��');
			} 
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			if (obj.RecRowID == flg) {  //�޸�
				obj.RecRowID = "";			
				obj.gridMRBBactLoad("");
				obj.gridMRBAntiLoad("");   
				obj.gridMRBKeysLoad("");   
				obj.gridIsolateLoad("");
				$("#btnAdd_one").linkbutton("disable");
				$("#btnAdd_two").linkbutton("disable");
				$("#btnAdd_three").linkbutton("disable");
				$("#btnAdd_four").linkbutton("disable");
			}			
			obj.gridCRuleMRBLoad(); //ˢ�µ�ǰҳ
		}
	}
	//ɾ�����������Ŀ
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRB",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleMRBLoad();  //ˢ�µ�ǰҳ
					$("#btnAdd_one").linkbutton("disable");
					$("#btnAdd_two").linkbutton("disable");
					$("#btnAdd_three").linkbutton("disable");
					$("#btnAdd_four").linkbutton("disable");
					obj.gridMRBBactLoad("");
					obj.gridMRBAntiLoad("");
					obj.gridMRBKeysLoad("");
					obj.gridIsolateLoad("");
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var BTCode = rd["BTCode"];
			var BTDesc = rd["BTDesc"];
			//var BTCatDesc = rd["BTCatDesc"];
			var BTCatDr = rd["BTCatDr"];
			var BTIsActive = rd["BTIsActive"];
			BTIsActive = (BTIsActive=="1"? true: false)
			var IsRuleCheck = rd["IsRuleCheck"];
			IsRuleCheck = (IsRuleCheck=="1"? true: false)
			var IsAntiCheck = rd["IsAntiCheck"];
			IsAntiCheck = (IsAntiCheck=="1"? true: false)
			var AnitCatCnt = rd["AnitCatCnt"];
			var AnitCatCnt2 = rd["AnitCatCnt2"];
			var IsKeyCheck = rd["IsKeyCheck"];
			IsKeyCheck = (IsKeyCheck=="1"? true: false)
			var Note  = rd["RuleNote"];
			var IsIRstCheck= rd["IsIRstCheck"];
			var IsResKeyCheck= rd["IsResKeyCheck"];
			IsIRstCheck = (IsIRstCheck=="1"? true: false);
			IsResKeyCheck = (IsResKeyCheck=="1"? true: false);
			
			$('#txtBTCode').val(BTCode);
			$('#txtBTDesc').val(BTDesc);
			$('#cboMRBCat').combobox('setValue',BTCatDr);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
			$('#chkIsRuleCheck').checkbox('setValue',IsRuleCheck);
			$('#chkIsAntiCheck').checkbox('setValue',IsAntiCheck);
			$('#txtAnitCatCnt').val(AnitCatCnt);
			$('#txtAnitCatCnt2').val(AnitCatCnt2);
			$('#chkIsKeyCheck').checkbox('setValue',IsKeyCheck);
			$('#chkIsIRstCheck').checkbox('setValue',IsIRstCheck);
			$('#chkIsResKeyCheck').checkbox('setValue',IsResKeyCheck);
			$('#txtNote').val(Note);
		}else{
			obj.RecRowID = "";
			
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
			$('#cboMRBCat').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',false);
			$('#chkIsRuleCheck').checkbox('setValue',false);
			$('#chkIsAntiCheck').checkbox('setValue',false);
			$('#txtAnitCatCnt').val('');
			$('#txtAnitCatCnt2').val('');
			$('#chkIsKeyCheck').checkbox('setValue',false);
			$('#chkIsIRstCheck').checkbox('setValue',false);
			$('#chkIsResKeyCheck').checkbox('setValue',false);
			$('#txtNote').val('');
		}
		$('#layer').show();
		obj.SetDiaglog();
	}
	obj.gridCRuleMRBLoad = function(){
		originalData["gridCRuleMRB"]="";
		//$("#gridCRuleMRB").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryCRuleMRB",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleMRB').datagrid('loadData', rs);			
		});
    }
    //����ϸ������
    obj.btnSave2_click = function(){
		var errinfo = "";
		var BactDr = $('#cboBact').combobox('getValue');
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID=Parref["ID"];
		//var ID  = obj.gridMRBBact.getSelected();
		var SubID      = (obj.RecRowID1 ?obj.RecRowID1.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + BactDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		if (!BactDr) {
			errinfo = errinfo + "ϸ��������Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBBact",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("������ʾ" , 'ϸ�������ظ�!');
			} else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID1 = flg;
			obj.gridMRBBactLoad(ParrefID); //ˢ�µ�ǰҳ
		}
	}
	//���濹����
    obj.btnSave3_click = function(){
		var errinfo = "";
		var AntiCatDr = $('#cboLabAntiCat').combobox('getValue');
		var AntiDr = $('#cboLabAnti').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridMRBAnti.getSelected();
		var SubID      = (obj.RecRowID2 ?obj.RecRowID2.split("||")[1] : ''); 
		if ((AntiCatDr==0)&&(AntiDr !="")) {
			var AntiCatInfo = $m({
				ClassName:"DHCHAI.DPS.LabAntiSrv",
				MethodName:"GetCatByAnti",
				aAntiID:AntiDr
			},false);
			AntiCatDr = (AntiCatInfo ? AntiCatInfo.split("^")[0] : '');
		}
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + AntiCatDr;
		InputStr += "^" + AntiDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		if (AntiCatDr == "") {
			errinfo = errinfo + "�����ط��಻��Ϊ��!<br>";
		}
		if ((AntiCatDr == '')&&(AntiDr!="")) {
			errinfo = errinfo + "������û�й����ķ���!<br>";
		}
		if ((AntiCatDr == "0")&&(AntiDr =='')) {
			errinfo = errinfo + "�����ط���Ϊȫ��,�����ز�����Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBAnti",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("������ʾ" , '�Ѵ��ڸÿ����ط��༰�俹���أ������ظ�����!');
			} else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
		}else {
			$HUI.dialog('#layer_three').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID2 = flg;
			obj.gridMRBAntiLoad(ParrefID); //ˢ�µ�ǰҳ
		}
	}
	//����ؼ���
    obj.btnSave4_click = function(){
		var errinfo = "";
		var KeyWord = $('#txtKeyWord').val();
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridMRBKeys.getSelected();
		var SubID      = (obj.RecRowID3 ?obj.RecRowID3.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + KeyWord;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!KeyWord) {
			errinfo = errinfo + "�ؼ��ʲ�����Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}	
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBKeys",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("������ʾ" , '�ؼ����ظ�!');
			} else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
		}else {
			$HUI.dialog('#layer_four').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID3 = flg;
			obj.gridMRBKeysLoad(ParrefID); //ˢ�µ�ǰҳ
		}
	}
	//�����쳣��־
    obj.btnSave5_click = function(){
		var errinfo = "";
		var OEOrdDr = $('#cboOEOrd').combobox('getValue');
	    var ActUserDr  = $.LOGON.USERID;
		var Parref = obj.gridCRuleMRB.getSelected();
		var ParrefID  = (Parref ? Parref["ID"] : '');
		//var ID  = obj.gridIsolate.getSelected();
		var SubID      = (obj.RecRowID4 ?obj.RecRowID4.split("||")[1] : ''); 
		
		var InputStr = ParrefID;
		InputStr += "^" + SubID;
		InputStr += "^" + OEOrdDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		if (!OEOrdDr) {
			errinfo = errinfo + "����ҽ��������Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}	
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleMRBOEOrd",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("������ʾ" , '����ҽ�������ظ�!');
			} else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
		}else {
			$HUI.dialog('#layer_five').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID4 = flg;
			obj.gridIsolateLoad(ParrefID); //ˢ�µ�ǰҳ
		}
	}
	//ɾ��ϸ��
	obj.btnDelete2_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridMRBBact.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBBact",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID1 = "";
					obj.gridMRBBactLoad(Parref); //ˢ�µ�ǰҳ
					$("#btnAdd_one").linkbutton("enable");
					$("#btnEdit_one").linkbutton("disable");
					$("#btnDelete_one").linkbutton("disable");
				}
			} 
		});
	}
	//ɾ��������
	obj.btnDelete3_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridMRBAnti.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBAnti",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridMRBAntiLoad(Parref);  //ˢ�µ�ǰҳ
					$("#btnAdd_two").linkbutton("enable");
					$("#btnEdit_two").linkbutton("disable");
					$("#btnDelete_two").linkbutton("disable");
				}
			} 
		});
	}
	//ɾ���ؼ���
	obj.btnDelete4_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridMRBKeys.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBKeys",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID3 = "";
					obj.gridMRBKeysLoad(Parref);  //ˢ�µ�ǰҳ
					$("#btnAdd_three").linkbutton("enable");
					$("#btnEdit_three").linkbutton("disable");
					$("#btnDelete_three").linkbutton("disable");
				}
			} 
		});
	}
	//ɾ���쳣��־
	obj.btnDelete5_click = function(){
		var rowData = obj.gridCRuleMRB.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		var CRulerd = obj.gridIsolate.getSelected();
		var selectedID  = (CRulerd ? CRulerd["ID"] : '');
		if (selectedID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleMRBOEOrd",
					MethodName:"DeleteById",
					aId:selectedID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID4 = "";
					obj.gridIsolateLoad(Parref);  //ˢ�µ�ǰҳ
					$("#btnAdd_four").linkbutton("enable");
					$("#btnEdit_four").linkbutton("disable");
					$("#btnDelete_four").linkbutton("disable");
				}
			} 
		});
	}
	//���ô���-ϸ����ʼ��
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID1 = rd["ID"];
			//var BacDesc = rd["BactDesc"];
			var BactID = rd["BactID"];
			
			$('#cboBact').combobox('setValue',BactID);
		}else{
			obj.RecRowID1 = "";
			$('#cboBact').combobox('setValue','');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	//���ô���-�����س�ʼ��
	obj.layer_three= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			//var AntiCat = rd["AntiCatDesc"];
			var AntiCatDr = rd["AntiCatDr"];
			var AntiID = rd["AntiID"];
			
			$('#cboLabAntiCat').combobox('setValue',AntiCatDr);
			$('#cboLabAnti').combobox('setValue',AntiID);
		}else{
				obj.RecRowID2 = "";
			$('#cboLabAntiCat').combobox('setValue','');
			$('#cboLabAnti').combobox('setValue','');
		}
		$('#layer_three').show();
		obj.SetDiaglog3();
		
	}
	//���ô���-�ؼ��ʳ�ʼ��
	obj.layer_four= function(rd){
		if(rd){
			obj.RecRowID3 = rd["ID"];
			var KeyWord = rd["KeyWord"];
			
			$('#txtKeyWord').val(KeyWord);
		}else{
				obj.RecRowID3 = "";
			$('#txtKeyWord').val('');
			
		}
		$('#layer_four').show();
		obj.SetDiaglog4();
	}
	//���ô���-����ҽ����ʼ��
	obj.layer_five= function(rd){
		if(rd){
			obj.RecRowID4 = rd["ID"];
			//var BTOrdDesc = rd["BTOrdDesc"];
			var BTOrdID = rd["BTOrdID"];
			$('#cboOEOrd').combobox('setValue',BTOrdID);
		}else{
				obj.RecRowID4 = "";
				$('#cboOEOrd').combobox('setValue','');
		}
		$('#layer_five').show();
		obj.SetDiaglog5();
	}
	obj.gridMRBBactLoad = function(aRuleID){
		$("#gridMRBBact").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBBactByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridMRBBact').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridMRBAntiLoad = function(aRuleID){
		$("#gridMRBAnti").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBAntiByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridMRBAnti').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridMRBKeysLoad = function(aRuleID){
		$("#gridMRBKeys").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBKeysByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridMRBKeys').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridIsolateLoad = function(aRuleID){
		$("#gridIsolate").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleMRBSrv",
			QueryName:"QryMRBOEOrdByMRBID",	
			aMRBID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridIsolate').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}