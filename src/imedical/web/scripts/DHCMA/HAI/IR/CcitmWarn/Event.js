//ҳ��Event
function InitCCItmWarnWinEvent(obj){
	//������
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCCItmWarn"),value);
		}	
	});	
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '����Ԥ����Ŀ�༭',
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
   		obj.gridCCItmWarnLoad();
		//���
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCCItmWarn.getSelected()
			obj.layer(rd);	
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//˫���༭�¼�
	obj.gridCCItmWarn_onDbselect = function(rd){
		obj.layer(rd);
	}
	//ѡ��
	obj.gridCCItmWarn_onSelect = function (){
		var rowData = obj.gridCCItmWarn.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridCCItmWarn.clearSelections();
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
		var Desc2 = $('#txtDesc2').val();
		var KeyWords = $('#txtKeyWords').val();
		var IndNo = $('#txtIndNo').val();
		var Arg1 = $('#txtArg1').val();
		var Arg2 = $('#txtArg2').val();
		var Arg3 = $('#txtArg3').val();
		var Arg4 = $('#txtArg4').val();
		var Arg5 = $('#txtArg5').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var ActUserDr = $.LOGON.USERID;
		var Desc 	= Desc.trim();
		var Desc2 	= Desc2.trim();
		
		
		if (!Desc) {
			errinfo = errinfo + "����Ԥ����Ŀ���Ʋ�����Ϊ��!<br>";
		}	
		if (!Desc2) {
			errinfo = errinfo + "����Ԥ����Ŀ����2������Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Desc;
		InputStr += "^" + Desc2;
		InputStr += "^" + KeyWords;
		InputStr += "^" + IndNo;
		InputStr += "^" + Arg1;
		InputStr += "^" + Arg2;
		InputStr += "^" + Arg3;
		InputStr += "^" + Arg4;
		InputStr += "^" + Arg5;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		var flg = $m({
			ClassName:"DHCHAI.IR.CCItmWarn",
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
			obj.gridCCItmWarnLoad(); //ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.IR.CCItmWarn",
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
					obj.gridCCItmWarnLoad();  //ˢ�µ�ǰҳ
				}
			} 
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var Desc = rd["Desc"];
			var Desc2 = rd["Desc2"];
			var KeyWords = rd["KeyWords"];
			var IndNo = rd["IndNo"];
			var Arg1 = rd["Arg1"];
			var Arg2 = rd["Arg2"];
			var Arg3 = rd["Arg3"];
			var Arg4 = rd["Arg4"];
			var Arg5 = rd["Arg5"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#txtDesc').val(Desc);
			$('#txtDesc2').val(Desc2);
			$('#txtKeyWords').val(KeyWords);
			$('#txtIndNo').val(IndNo);
			$('#txtArg1').val(Arg1);
			$('#txtArg2').val(Arg2);
			$('#txtArg3').val(Arg3);
			$('#txtArg4').val(Arg4);
			$('#txtArg5').val(Arg5);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID = "";
			$('#txtDesc').val('');
			$('#txtDesc2').val('');
			$('#txtKeyWords').val('');
			$('#txtArg1').val('');
			$('#txtArg2').val('');
			$('#txtArg3').val('');
			$('#txtArg4').val('');
			$('#txtArg5').val('');
			$('#txtIndNo').val('');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	obj.gridCCItmWarnLoad = function(){
		originalData["gridCCItmWarn"]="";
		$("#gridCCItmWarn").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCItmWarnSrv",
			QueryName:"QryWarnSrv",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCCItmWarn').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}