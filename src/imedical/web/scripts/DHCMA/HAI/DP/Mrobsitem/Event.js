//������ĿEvent
function InitMROBSItemWinEvent(obj){
	//��ť��ʼ��
	obj.InitDialog=function(){
		$('#layer').dialog({
			title: '������Ŀά��',
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
			var rd=obj.gridMROBSItem.getSelected()
			obj.layer(rd);	
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
     }
     //˫���༭�¼�
	obj.gridMROBSItem_onDbselect = function(rd){
		obj.layer(rd);
	}
	//ѡ��
	obj.gridMROBSItem_onSelect = function (){
		var rowData = obj.gridMROBSItem.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridMROBSItem.clearSelections();
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
		var Code = $('#txtBTItemCode').val();
		var Desc = $('#txtBTItemDesc').val();
		var BTCatDr = $('#cboBTCatDr').combobox('getValue');
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		
		
		if (!Code) {
			errinfo = errinfo + "������Ŀ���벻����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "������Ŀ���Ʋ�����Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;	
		inputStr = inputStr + CHR_1 + BTCatDr;	
		inputStr = inputStr + CHR_1 + IsActive;	
		var flg = $m({
			ClassName:"DHCHAI.DP.MROBSItem",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("������ʾ", "��������!" , 'info');
				//ע��code ���Ʒ��ƥ��
			} else if(parseInt(flg) == -100){
				$.messager.alert("������롢�����ظ�!" , 'info');
			}else{
				$.messager.alert("������ʾ", "����ʧ��!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridMROBSItem.reload() ;//ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.DP.MROBSItem",
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
					obj.gridMROBSItem.reload() ;//ˢ�µ�ǰҳ
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Code = rd["BTItemCode"];
			var Desc = rd["BTItemDesc"];
			var BTCatDr=rd["BTCatDr"];
			$('#txtBTItemCode').val(Code);
			$('#txtBTItemDesc').val(Desc);
			$('#cboBTCatDr').combobox('setValue',BTCatDr);
		}else{
			obj.RecRowID = "";
			$('#txtBTItemCode').val('');
			$('#txtBTItemDesc').val('');
			$('#cboBTCatDr').combobox('setValue','');
			
		}
		$('#layer').show();
		obj.InitDialog()
		
	}
}