//ҳ��Event
function InitMROBSItemCatWinEvent(obj){
	
	//��ť��ʼ��
	obj.InitDialog=function(){
		$('#layer').dialog({
			title: '�������ά��',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true,
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
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMROBSItemCat"),value);
		}	
	});
	obj.LoadEvent = function(args){ 
		//����
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//�ر�
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#layer').close();
     	});
		//���
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMROBSItemCat.getSelected()
			obj.layer(rd);	
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
     }
     //˫���༭�¼�
	obj.gridMROBSItemCat_onDbselect = function(rd){
		obj.layer(rd);
	}
	//ѡ��
	obj.gridMROBSItemCat_onSelect = function (){
		var rowData = obj.gridMROBSItemCat.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridMROBSItemCat.clearSelections();
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
		var Code = $('#txtBTCode').val();
		var Desc = $('#txtBTDesc').val();
		Code=$.trim(Code)
		Desc=$.trim(Desc)
		
		if (!Code) {
			errinfo = errinfo + "���벻����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "���Ʋ�����Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		var flg = $m({
			ClassName:"DHCHAI.DP.MROBSItemCat",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("������ʾ", "��������!" , 'info');
				//ע��code ���Ʒ��ƥ��
			} else if(parseInt(flg) == -100){
				$.messager.alert("������ʾ" , '�����������ظ�!');
			}else{
				$.messager.alert("������ʾ", "����ʧ��!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridMROBSItemCat.reload() ;//ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.DP.MROBSItemCat",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("������ʾ","-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ�����ݴ���!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridMROBSItemCat.reload() ;//ˢ�µ�ǰҳ
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			
			$('#txtBTCode').val(Code);
			$('#txtBTDesc').val(Desc);
		}else{
			obj.RecRowID = "";
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
			
		}
		$('#layer').show();
		obj.InitDialog()
		
	}
}