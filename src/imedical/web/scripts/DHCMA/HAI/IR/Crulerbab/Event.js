//ҳ��Event
function InitCRuleRBAbWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleRBAb"),value);
		}	
	});
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: 'Ӱ��ѧɸ��༭',
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
			title: '�����Ŀ�༭',
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
    	obj.gridCRuleRBAbLoad();
		obj.gridCRuleRBCodeLoad();
		//����
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//�޸�
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleRBAb.getSelected();
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
			var rd2=obj.gridCRuleRBCode.getSelected();
			obj.layer_two(rd2);	
		});
		//ɾ��
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete2_click();
		});
		$("#btnAdd_one").linkbutton("disable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    }
     //˫���༭�¼�
	obj.gridCRuleRBAb_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//ѡ��
	obj.gridCRuleRBAb_onSelect = function (){
		var rowData = obj.gridCRuleRBAb.getSelected();
		
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAdd_one").linkbutton("disable");
			obj.gridCRuleRBAb.clearSelections(); 
			$('#gridCRuleRBCode').datagrid('loadData',{total:0,rows:[]});
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAdd_one").linkbutton("enable");
			obj.gridCRuleRBCodeLoad(Parref);
		}
	} 
	//˫���༭�¼�
	obj.gridCRuleRBCode_onDbselect = function(rd2){
		obj.layer_two(rd2);
	}
	//ѡ��
	obj.gridCRuleRBCode_onSelect = function (){
		var rowData2 = obj.gridCRuleRBCode.getSelected();
		var rowId = (rowData2 != null) ? rowData2["ID"] : '';
		if (rowId == obj.RecRowID2) {
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleRBCode.clearSelections();
		} else {
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
			obj.RecRowID2 = rowId;
	}
	
	//Ӱ��ѧɸ���׼����-����
	obj.btnSave_click = function(){
		var errinfo = "";
		var RBCode = $('#txtRBCode').val();
		var RBPos = $('#txtRBPos').val();
		var RBNote = $('#txtRBNote').val();
		var RBCFlag = $("#chkRBCFlag").checkbox('getValue')? '1':'0';
		
		
		if (!RBCode) {
			errinfo = errinfo + "�����Ŀ������Ϊ��!<br>";
		}	
		if (!RBPos) {
			errinfo = errinfo + "��鲿λ������Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + RBCode;      // �����Ŀ
		InputStr += "^" + RBPos;       // ��鲿λ
		InputStr += "^" + RBNote;      // ˵��
		InputStr += "^" + RBCFlag;     // ɸ���־
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleRBAb",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-100'){
				$.messager.alert("������ʾ" , '�����Ŀ�ظ�������ʧ��!');
			}else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridCRuleRBAbLoad(); //ˢ�µ�ǰҳ
		}
	}
	//�������
	obj.btnSave2_click = function(){
		var errinfo = "";
		var RBCodeDr = $('#cboRBCodeDr').combobox('getValue');
		var CRulerd = obj.gridCRuleRBAb.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		var ID 		= obj.RecRowID2
		if (ID.indexOf("||")>-1) {
			var SubID=ID.split('||')[1];
		} else {
			var SubID='';
		}
		
		var InputStr = Parref;		        // ����ID
		InputStr += "^" + SubID;            // �ӱ�ID
		InputStr += "^" + RBCodeDr;         // ������Ŀ
		InputStr += "^" + '';               // ��������
		InputStr += "^" + '';               // ����ʱ��
		InputStr += "^" + $.LOGON.USERID;   // ������
		
		if (!RBCodeDr) {
			errinfo = errinfo + "�����Ŀ������Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleRBCode",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)== '-2') {
				$.messager.alert("������ʾ" , '�����Ŀ�ظ�!');
			}else{
				$.messager.alert("������ʾ" , '����ʧ��!');
			}
			
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID2 = flg
			obj.gridCRuleRBCodeLoad(Parref); //ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.IR.CRuleRBAb",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleRBAbLoad();  //ˢ�µ�ǰҳ
				}
			} 
		});
	}//ɾ������ 
	obj.btnDelete2_click = function(){
		var CRulerd = obj.gridCRuleRBAb.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		if (obj.RecRowID2==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleRBCode",
					MethodName:"DeleteById",
					aId:obj.RecRowID2
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleRBCodeLoad(Parref);  //ˢ�µ�ǰҳ
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var RBCode = rd["RBCode"];
			var RBPos = rd["RBPos"];
			var RBNote = rd["RBNote"];
			
			$('#txtRBCode').val(RBCode);
			$('#txtRBPos').val(RBPos);
			$('#txtRBNote').val(RBNote);
			$("#chkRBCFlag").checkbox('setValue',(rd["RBCFlag"]=="1"? true: false));
		}else{
			obj.RecRowID = "";
			$('#txtRBCode').val('');
			$('#txtRBPos').val('');
			$('#txtRBNote').val('');
			$('#chkRBCFlag').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	//���ô���-��ʼ��
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			//var RBDesc = rd["RBCodeDesc"];
			var RBCodeDr = rd["RBCodeDr"];
			$('#cboRBCodeDr').combobox('setValue',RBCodeDr);
		}else{
			obj.RecRowID2 = "";
			$('#cboRBCodeDr').combobox('setValue','');
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	obj.gridCRuleRBCodeLoad = function(aRuleID){
		$("#gridCRuleRBCode").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleRBCodeSrv",
			QueryName:"QryCRuleRBCodeByID",	
			aRBAbID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleRBCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		obj.RecRowID2 = "";
		$("#btnAdd_one").linkbutton("enable");
		$("#btnEdit_one").linkbutton("disable");
		$("#btnDelete_one").linkbutton("disable");
    }
	obj.gridCRuleRBAbLoad = function(){
		originalData["gridCRuleRBAb"]="";
		$("#gridCRuleRBAb").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CRuleRBAbSrv",
			QueryName:"QryCRuleRBAb",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleRBAb').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}