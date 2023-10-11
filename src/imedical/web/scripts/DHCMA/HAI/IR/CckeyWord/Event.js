//ҳ��Event
function InitKeyWordWinEvent(obj){
	//������
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridKeyWord"),value);
		}	
	});	
//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '�ؼ��ʶ���༭',
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
	//��ť��ʼ��
    obj.LoadEvent = function(args){ 
   		obj.gridKeyWordLoad();
		//���
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridKeyWord.getSelected()
			obj.layer(rd);	
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//˫���༭�¼�
	obj.gridKeyWord_onDbselect = function(rd){
		obj.layer(rd);
	}
	//ѡ��
	obj.gridKeyWord_onSelect = function (){
		var rowData = obj.gridKeyWord.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridKeyWord.clearSelections();
		}
		else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//�������
	obj.btnSave_click = function(){
		var errinfo = "";
		var Desc = $('#txtDesc').val();
		var Note = $('#txtNote').val();
		var Desc = Desc.trim();
		var Note = Note.trim();
		if (!Note) {
			errinfo = errinfo + "�ؼ���˵��������Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "�ؼ������Ʋ�����Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Desc;
		InputStr += "^" + Note;
		var flg = $m({
			ClassName:"DHCHAI.IR.CCKeyWord",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("�����ظ�!" , 'info');
			}else{
				$.messager.alert("������ʾ", "����ʧ��!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridKeyWordLoad(); //ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.IR.CCKeyWord",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("������ʾ","-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridKeyWordLoad();  //ˢ�µ�ǰҳ
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Desc = rd["Desc"];
			var Note = rd["Note"];
			
			$('#txtDesc').val(Desc);
			$('#txtNote').val(Note);
		}else{
			obj.RecRowID = "";
			$('#txtDesc').val('');
			$('#txtNote').val('');
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	obj.gridKeyWordLoad = function(){
		originalData["gridKeyWord"]="";
		$("#gridKeyWord").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCKeyWordSrv",
			QueryName:"QryKeyWordSrv",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridKeyWord').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}