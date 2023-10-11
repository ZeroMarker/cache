function InitCCLocGroupLocWinEvent(obj){
	
	//��ʼtabҳǩ
	var tab = $('#divTabs').tabs('getSelected');
	var index = $('#divTabs').tabs('getTabIndex',tab);
	if (index==0) {
		$("#divtab0").css('display','block');			
	}	
	$HUI.tabs("#divTabs",{
		onSelect:function(title,index){
			obj.type=index;
			obj.SysUserID="";
			obj.LocID="";
			obj.LocGrpID="";
			$('#searchbox2').searchbox('clear');
			if (index==0){
				//���ѡ��
				obj.gridLocation.clearSelections();
				$("#divtab0").css('display','block');
				$("#divgridUser").removeAttr("style");	
				loadgridUser();
			}	
			if (index==1){
				//���ѡ��
				obj.gridSysUser.clearSelections();
				$("#divtab1").css('display','block');
				$("#divtab0").css('display','none');
				loadgridLoc();
			}
		}
	});
	
	$("#cboLocGrpType,#cboHospital").combobox({
         onChange:function(){
            obj.gridLocationLoad();
        }
    });

    //������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			obj.gridLocationLoad();
		}	
	});

    //������ϸ
	obj.gridLocationLoad = function(){
		 //��̨����ˢ��
        obj.gridLocation.load({
           ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryLoc',
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'), 
			aLocCate:"",
			aLocType:"",
			aIsActive:""
        })
    } 
	
	$("#cboLocGrpTypeT,#cboHospitalT").combobox({
         onChange:function(){
            obj.gridSysUserLoad();
        }
    });
    //������
	$('#searchboxT').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridSysUser"),value);
		}	
	});
	$('#btnEditT').on('click', function(){
		 var rd=obj.gridSysUser.getSelected();
         obj.InitDiagPhone(rd);
    });
	
	//������ϸ
	obj.gridSysUserLoad = function(){
		 //��̨����ˢ��
        obj.gridSysUser.load({
            ClassName:'DHCHAI.BTS.SysUserSrv',
			QueryName:'QrySysUserList',
			aLocID:"", 
			aTypeID:"", 
			aUserName:"",
			aUserCode:"", 
			aIsActive:"",
			aHospID:$("#cboHospitalT").combobox('getValue')
        })
    } 

	//�༭����
	obj.InitDiagPhone=function(rd){
		
		obj.SysUserID=rd["ID"];
		$('#txtUserCode,#txtUserDesc,#txtUserLoc').attr('disabled','disabled');
		$('#txtUserCode').val(rd["UserCode"]);
		$('#txtUserDesc').val(rd["UserDesc"]);
		$('#txtUserLoc').val(rd["LocDesc"]);
		$('#txtUserPhone').val(rd["PhoneNo"]);
		
		$('#EidtPhone').show();
			
		$('#EidtPhone').dialog({
			title: '�ֻ���ά��',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.SavePhone();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#EidtPhone').close();
				}
			}]
		});
	}
    
    obj.SavePhone = function(){
		var Phone = $('#txtUserPhone').val();		
		if (!Phone) {
			$.messager.alert("������ʾ","����д�ֻ��ţ�",'info');
			return ;
		}
		var isMblNum = /^[1][3,4,5,7,8,9][0-9]{9}$/;
        var isPhNum = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
        if (!isMblNum.test(Phone) && !isPhNum.test(Phone)) {
            $.messager.alert("��ʾ", "�ֻ��Ÿ�ʽ����!", 'info');
            return false;
        }

		var flg = $m({
			ClassName:"DHCHAI.BT.SysUser",
			MethodName:"ChangePhone",
			aUserId:obj.SysUserID,
			aPhone:Phone
		},false);
		if (parseInt(flg)> 0) {
			var rows = $('#gridSysUser').datagrid('getSelected');
			var index = $("#gridSysUser").datagrid('getRowIndex', rows);
			$('#gridSysUser').datagrid('updateRow',{
				index: index,
				row: {
					PhoneNo:Phone
				}
			});
			$HUI.dialog('#EidtPhone').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		}else{
			$.messager.alert("������ʾ", "����ʧ��!Error=" + flg, 'info');
		}
	}
		
    //������/���ο���ά��
	$('#btnEdit').on('click', function(){
        var rd=$('#gridUser').datagrid('getSelected');       
        if (obj.type==1) {
			obj.InitDiagLoc(rd);
		}else {
			obj.InitDiaglog(rd);
		}
    });
	$('#btnAdd').on('click', function(){
        if (obj.type==1) {
			obj.InitDiagLoc("");
		}else {
			obj.InitDiaglog("");
		}
    });
	$('#btnDelete').on('click', function(){
       var rd=$('#gridUser').datagrid('getSelected'); 
        if (rd["ID"]==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CCLocGroup",
					MethodName:"DeleteById",
					aId:rd["ID"]
				},false);
				if (flg == '0') {
					if (obj.type==1) {  //ˢ��
						obj.gridLocLoad();
					}else {
						obj.gridUserLoad();
					}
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("������ʾ","-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ��ʧ��!Error=" + flg, 'info');
					}			
				}
			}
		});
    });
	
	 
	//������
	$('#searchbox2').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridUser"),value);
		}	
	});
	//����������
	obj.gridUserLoad = function(){
		originalData["gridUser"]="";  //���¼���ǰ����ʼ�����ÿ�
		 //��̨����ˢ��
        $('#gridUser').datagrid('load',{
            ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUser',
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aLocID: obj.LocID,
			aAlias:$('#searchbox2').searchbox('getValue'), 
			aIsActive:""
        })
    }

	//�������ο���
	obj.gridLocLoad = function(){
		originalData["gridUser"]="";  //���¼���ǰ����ʼ�����ÿ�
		 //��̨����ˢ��
        $('#gridUser').datagrid('load',{
            ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUserLocGroup',
			aHospIDs:$("#cboHospitalT").combobox('getValue'),
			aGrpType:$("#cboLocGrpTypeT").combobox('getValue'),
			aUserID: obj.SysUserID
        })
    }
    
	//�༭����
	obj.InitDiaglog=function(rd){
		Common_ComboToLoc('cboLoc',$("#cboHospital").combobox('getValue'));
		$('#cboUser').lookup('enable');
		$('#txtPhone').removeAttr("disabled");
		$('#cboLoc').combobox('disable');
		
		if(rd==""){
			$('#cboLoc').combobox('clear');
			if (obj.LocID!=""){
				$('#cboLoc').combobox('setValue',obj.LocID);
			}
			
			$('#txtPhone').val("");
			$('#cboUser').lookup('clear');
			$('#dtEffect').datebox('setValue', Common_GetDate(new Date()));
			$('#dtExpiry').datebox('setValue',"");
			$('#chkIsActive').checkbox('setValue',false);
			obj.LocGrpID=""
	    }else {
			$('#cboLoc').combobox('setValue',rd["LocID"]);
			if (obj.LocID!=""){
				$('#cboLoc').combobox('setValue',obj.LocID);
			}
			$('#cboUser').lookup('setText',rd["UserDesc"]);
			obj.UserID=rd["CCLocUser"];
			$('#cboUserID').val(obj.UserID);
			$('#txtPhone').val(rd["PhoneNo"]);
		    $('#dtEffect').datebox('setValue', rd["BTEffectDate"]);
			$('#dtExpiry').datebox('setValue',rd["BTExpiryDate"]);

			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]=='��' ? true : false));
			obj.LocGrpID=rd["ID"];
		}
		$('#layer').show();
			
		$('#layer').dialog({
			title: '������ά��',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.Save();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}

	//���ķ���-����
	obj.Save = function(){
		var errinfo = "";
		var GrpType=$("#cboLocGrpType").combobox('getValue');
		var UserID = obj.UserID;
		var LocID = $('#cboLoc').combobox('getValue');
		var Phone = $('#txtPhone').val();
		var EffectDate = $('#dtEffect').datebox("getValue");
		var ExpiryDate = $('#dtExpiry').datebox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		if (!GrpType){
			errinfo = errinfo + $g("���������ͻ�ȡ����!")+"<br>";
		}
		if (!UserID) {
			errinfo = errinfo + $g("��������д�û���Ϣ!")+"<br>";
		}
		if (!Phone) {
			errinfo = errinfo + $g("����д�ֻ���!")+"<br>";
		}
		if ((!EffectDate)&&(ExpiryDate)) {
			errinfo = errinfo +$g("����д��Ч����!")+"<br>";
		}
		if ((EffectDate)&&(ExpiryDate)&&(Common_CompareDate(EffectDate,ExpiryDate))) {
			errinfo = errinfo +$g("��Ч���ڲ��ܴ��ڽ�ֹ����!")+"<br>";
		}
		var isMblNum = /^[1][3,4,5,7,8,9][0-9]{9}$/;
        var isPhNum = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
        if ((Phone)&&(!isMblNum.test(Phone) && !isPhNum.test(Phone))) {
           	errinfo = errinfo + $g("�ֻ��Ÿ�ʽ����!")+"<br>";
        }
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return ;
		}
		var InputStr=obj.LocGrpID;
		InputStr += "^" + LocID;
		InputStr += "^" + GrpType;
		InputStr += "^" + UserID;
		InputStr += "^" + Phone;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + EffectDate;
		InputStr += "^" + ExpiryDate;
		InputStr += "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.IRS.CCLocGroupSrv",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		if (parseInt(flg)> 0) {
			obj.gridUserLoad();		//ˢ��
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		}else{
			$.messager.alert("������ʾ", "����ʧ��!Error=" + flg, 'info');
		}
		//���ѡ��
		$('#gridUser').datagrid('clearSelections');
	}
	
	
	//�༭����
	obj.InitDiagLoc=function(rd){
		Common_ComboToMSLoc("cboLoc",$("#cboHospital").combobox('getValue'));
		
		$('#cboUserID').val(obj.SysUserID);
		$('#cboUser').lookup('setText',obj.UserDesc);
		$('#cboUser').lookup('disable');
		$('#txtPhone').val(obj.PhoneNum);
		$('#txtPhone').attr('disabled','disabled');
		$('#cboLoc').combobox('enable');
	
		if(rd==""){				
			$('#cboLoc').combobox('clear');
			$('#dtEffect').datebox('setValue', Common_GetDate(new Date()));
			$('#dtExpiry').datebox('setValue',"");
			$('#chkIsActive').checkbox('setValue',false);
	    }else {
		    $('#cboLoc').combobox ({    //�޸�ʱӦֻ�ܵ�ѡ
			   multiple:false, 
		    })
			$('#cboLoc').combobox('setValue',rd["LocID"]);
		    $('#dtEffect').datebox('setValue', rd["EffectDate"]);
			$('#dtExpiry').datebox('setValue',rd["ExpiryDate"]);

			$('#chkIsActive').checkbox('setValue',(rd["IsActive"]==1 ? true : false));
			obj.LocGrpID=rd["ID"];
		}
		$('#layer').show();
			
		$('#layer').dialog({
			title: '���ο���ά��',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.SaveUserLoc();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}

	//���ķ���-����
	obj.SaveUserLoc = function(){
		var errinfo = "";
		var GrpType=$("#cboLocGrpType").combobox('getValue');
		var UserID = obj.SysUserID;
		var arrLoc = $('#cboLoc').combobox('getValues');
		var Phone = $('#txtPhone').val();
		var EffectDate = $('#dtEffect').datebox("getValue");
		var ExpiryDate = $('#dtExpiry').datebox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		var LocIDs = arrLoc.toString();
	
		if (!GrpType){
			errinfo = errinfo + ($g("���������ͻ�ȡ����!")+"<br>");
		}
		
		if (!LocIDs) {
			errinfo = errinfo + ($g("��������д������Ϣ!")+"<br>");
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return ;
		}
		var Len =arrLoc.length;
		
		var InputStr=obj.LocGrpID;
		InputStr += "^" + LocIDs;
		InputStr += "^" + GrpType;
		InputStr += "^" + UserID;
		InputStr += "^" + Phone;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + EffectDate;
		InputStr += "^" + ExpiryDate;
		InputStr += "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.IRS.CCLocGroupSrv",
			MethodName:"BatchSave",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg)> 0) {
			obj.gridLocLoad();		//ˢ��
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-2'){
			$.messager.alert("������ʾ", "�����ظ�!" , 'info');
		}else{
			$.messager.alert("������ʾ", "����ʧ��!Error=" + flg, 'info');
		}
		//���ѡ��
		$('#gridUser').datagrid('clearSelections');
	}

}