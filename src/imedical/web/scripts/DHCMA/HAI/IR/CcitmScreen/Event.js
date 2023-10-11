//ҳ��Event
function InitCCItmScreenWinEvent(obj){
	//������
	$('#btnsearch').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridCCItmScreen"),value);
		}	
	});	
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '����ɸ����Ŀ�༭',
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
   		obj.gridCCItmScreenLoad();
		//���
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridCCItmScreen.getSelected()
			obj.layer(rd);	
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
   	}
   	//˫���༭�¼�
	obj.gridCCItmScreen_onDbselect = function(rd){
		obj.layer(rd);
	}
	//ѡ��
	obj.gridCCItmScreen_onSelect = function (){
		var rowData = obj.gridCCItmScreen.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridCCItmScreen.clearSelections();
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
		var Arg1 = $('#txtArg1').val();
		var Arg2 = $('#txtArg2').val();
		var Arg3 = $('#txtArg3').val();
		var Arg4 = $('#txtArg4').val();
		var Arg5 = $('#txtArg5').val();
		var Arg6 = $('#txtArg6').val();
		var Arg7 = $('#txtArg7').val();
		var Arg8 = $('#txtArg8').val();
		var Arg9 = $('#txtArg9').val();
		var Arg10 = $('#txtArg10').val();
		var Score = $('#txtScore').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var ActUserDr = $.LOGON.USERID;
		
		var Desc = Desc.trim();
		var Desc2 = Desc2.trim();
		
		if (!Desc) {
			errinfo = errinfo + "����ɸ����Ŀ���Ʋ�����Ϊ��!<br>";
		}	
		if (!Desc2) {
			errinfo = errinfo + "����ɸ����Ŀ����2������Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		
		var InputStr = obj.RecRowID;
		InputStr += "^" + Desc;
		InputStr += "^" + Desc2;
		InputStr += "^" + KeyWords;
		InputStr += "^" + Arg1;
		InputStr += "^" + Arg2;
		InputStr += "^" + Arg3;
		InputStr += "^" + Arg4;
		InputStr += "^" + Arg5;
		InputStr += "^" + Arg6;
		InputStr += "^" + Arg7;
		InputStr += "^" + Arg8;
		InputStr += "^" + Arg9;
		InputStr += "^" + Arg10;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		InputStr += "^" + Score;
		var flg = $m({
			ClassName:"DHCHAI.IR.CCItmScreen",
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
			obj.gridCCItmScreenLoad(); //ˢ�µ�ǰҳ
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
					ClassName:"DHCHAI.IR.CCItmScreen",
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
					obj.gridCCItmScreenLoad();  //ˢ�µ�ǰҳ
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
			var Arg1 = rd["Arg1"];
			var Arg2 = rd["Arg2"];
			var Arg3 = rd["Arg3"];
			var Arg4 = rd["Arg4"];
			var Arg5 = rd["Arg5"];
			var Arg6 = rd["Arg6"];
			var Arg7 = rd["Arg7"];
			var Arg8 = rd["Arg8"];
			var Arg9 = rd["Arg9"];
			var Arg10 = rd["Arg10"];
			var Score = rd["Score"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			
			$('#txtDesc').val(Desc);
			$('#txtDesc2').val(Desc2);
			$('#txtKeyWords').val(KeyWords);
			$('#txtArg1').val(Arg1);
			$('#txtArg2').val(Arg2);
			$('#txtArg3').val(Arg3);
			$('#txtArg4').val(Arg4);
			$('#txtArg5').val(Arg5);
			$('#txtArg6').val(Arg6);
			$('#txtArg7').val(Arg7);
			$('#txtArg8').val(Arg8);
			$('#txtArg9').val(Arg9);
			$('#txtArg10').val(Arg10);
			$('#txtScore').val(Score);
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
			$('#txtArg6').val('');
			$('#txtArg7').val('');
			$('#txtArg8').val('');
			$('#txtArg9').val('');
			$('#txtArg10').val('');
			$('#txtScore').val('');
			$('#chkActive').checkbox('setValue',false);
			
		}
		$('#layer').show();
		obj.SetDiaglog();
		
	}
	obj.gridCCItmScreenLoad = function(){
		originalData["gridCCItmScreen"]="";
		$("#gridCCItmScreen").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.IRS.CCItmScreenSrv",
			QueryName:"QryScreenSrv",		
	    	page:1,
			rows:999
		},function(rs){
			$('#gridCCItmScreen').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}