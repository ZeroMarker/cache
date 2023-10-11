//ҳ��Event
function InitCRuleDefWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCRuleDef"),value);
		}	
	});
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '��Ⱦ��ϱ�׼�༭',
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
			title: '��Ⱦ��ϱ�׼�༭',
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
    	obj.gridCRuleDefLoad();
		//����
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
    	//�޸�
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCRuleDef.getSelected();
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
			var rd2=obj.gridCRuleDefExt.getSelected();
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
	obj.gridCRuleDef_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//ѡ��
	obj.gridCRuleDef_onSelect = function (){
		var rowData = obj.gridCRuleDef.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleDef.clearSelections();
			obj.gridCRuleDefExtLoad("");
			$("#btnAdd_one").linkbutton("disable");
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			obj.gridCRuleDefExtLoad(Parref);
		}
	} //˫���༭�¼�
	obj.gridCRuleDefExt_onDbselect = function(rd2){
		if (obj.RecRowID==""){
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleDefExt.clearSelections();
			return;
		}
		obj.layer_two(rd2);
	}
	//ѡ��
	obj.gridCRuleDefExt_onSelect = function (){
		if (obj.RecRowID==""){
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleDefExt.clearSelections();
			return;
		}
		var rowData2 = obj.gridCRuleDefExt.getSelected();
		if (rowData2["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridCRuleDefExt.clearSelections();
		} else {
			obj.RecRowID2 = rowData2["ID"];
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
	}
	//����
	obj.btnSave_click = function(){
		var errinfo = "";
		var PosDr = $('#cboInfPos').combobox('getValue');
		var Title = $('#txtTitle').val();
		var Note = $('#txtNote').val();
		var IndNo = $('#txtIndNo').val();
		var MaxAge = $('#txtMaxAge').val();
		var MinAge = $('#txtMinAge').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var ActUserDr = $.LOGON.USERID;
		
		
		if (!PosDr) {
			errinfo = errinfo + "��Ⱦ�������������Ϊ��!<br>";
		}	
		if (!Title) {
			errinfo = errinfo + "��׼���岻����Ϊ��!<br>";
		}	
		if (!Note) {
			errinfo = errinfo + "��׼���������Ϊ��!<br>";
		}
		if ((MaxAge !="")&&(MinAge!="")&&(parseInt(MaxAge)>parseInt(MinAge))) {
			errinfo = errinfo + "�������޲��ܴ�����������!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + PosDr;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		InputStr += "^" + MaxAge;
		InputStr += "^" + MinAge;
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleDef",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("������ʾ" , '��Ⱦ��������ظ�!');
			
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = "";
			obj.gridCRuleDefLoad(); //ˢ�µ�ǰҳ
		}
	}
	//�������
	obj.btnSave2_click = function(){
		var errinfo = "";
		var Title = $('#txtExtTitle').val();
		var Note = $('#txtExtNote').val();
		var TypeDr = $('#cboDiagType').combobox('getValue');
		var IndNo = $('#txtExtIndNo').val();
		var IsActive = $("#chkExtActive").checkbox('getValue')? '1':'0';
		var CRulerd = obj.gridCRuleDef.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		var SubId="";
		if(obj.RecRowID2!=""){
			SubId=obj.RecRowID2.split("||")[1];
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubId;
		InputStr += "^" + Title;
		InputStr += "^" + Note;
		InputStr += "^" + TypeDr;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		
		if (!Title) {
			errinfo = errinfo + "��϶��岻����Ϊ��!<br>";
		}	
		if (!Note) {
			errinfo = errinfo + "��Ͻ��������Ϊ��!<br>";
		}	
		if (!TypeDr) {
			errinfo = errinfo + "������Ͳ�����Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleDefExt",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("������ʾ" , '��Ⱦ��������ظ�!');
			
		}else {
			$HUI.dialog('#layer_two').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID2 = "";
			obj.gridCRuleDefExtLoad(Parref); //ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.IR.CRuleDef",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridCRuleDefLoad();  //ˢ�µ�ǰҳ
					obj.gridCRuleDefExtLoad("");  //ˢ�µ�ǰҳ
				}
			} 
		});
	}//ɾ������ 
	obj.btnDelete2_click = function(){
		var CRulerd = obj.gridCRuleDef.getSelected();
		var Parref  = (CRulerd ? CRulerd["ID"] : '');
		if (obj.RecRowID2==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CRuleDefExt",
					MethodName:"DeleteById",
					aId:obj.RecRowID2
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridCRuleDefExtLoad(Parref);  //ˢ�µ�ǰҳ
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			//var InfPosDesc = rd["InfPosDesc"];
			var InfPosID = rd["InfPosID"];
			var Title = rd["Title"];
			var Note = rd["Note"];
			var IndNo = rd["IndNo"];
			var MaxAge = rd["MaxAge"];
			var MinAge = rd["MinAge"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#cboInfPos').combobox('setValue',InfPosID);
			$('#txtTitle').val(Title);
			$('#txtNote').val(Note);
			$('#txtIndNo').val(IndNo);
			$('#txtMaxAge').val(MaxAge);
			$('#txtMinAge').val(MinAge);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#cboInfPos').combobox('setValue','');
			$('#txtTitle').val('');
			$('#txtNote').val('');
			$('#txtIndNo').val('');
			$('#txtMaxAge').val('');
			$('#txtMinAge').val('');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	//���ô���-��ʼ��
	obj.layer_two= function(rd){
		if(rd){
			obj.RecRowID2 = rd["ID"];
			var Title = rd["Title"];
			var Note = rd["Note"];
			//var TypeDesc = rd["TypeDesc"];
			var TypeID = rd["TypeID"];
			var IndNo = rd["IndNo"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#txtExtTitle').val(Title);
			$('#txtExtNote').val(Note);
			$('#cboDiagType').combobox('setValue',TypeID);
			$('#txtExtIndNo').val(IndNo);
			$('#chkExtActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2 = "";
			$('#txtExtTitle').val('');
			$('#txtExtNote').val('');
			$('#cboDiagType').combobox('setValue','');
			$('#txtExtIndNo').val('');
			$('#chkExtActive').checkbox('setValue',false);
			
		}
		$('#layer_two').show();
		obj.SetDiaglog2();
		
	}
	obj.gridCRuleDefExtLoad = function(aRuleID){
		$("#gridCRuleDefExt").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCRuleDefSrv",
			QueryName:"QryCRuleDefExt",	
			aRuleDefID:aRuleID,	
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleDefExt').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
	obj.gridCRuleDefLoad = function(){
		originalData["gridCRuleDef"]="";
		$("#gridCRuleDef").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCRuleDefSrv",
			QueryName:"QryCRuleDef",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCRuleDef').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}