//ҳ��Event
function InitHandHyRegWinEvent(obj) {
    obj.HandRegID = "";
	
    obj.LoadEvent = function (args) {  
	    //Ĭ��ҽ����ʿ�ȷǹ���ԱȨ��ֻ����д���޸ĵ������� 0Ϊ������ 1Ϊҽ����ʿ�ȷǹ���ԱȨ��ֻ����д���޸ĵ�������
		var IsHandHyRegUpdate = $m({
			ClassName: "DHCHAI.BT.Config",
			MethodName: "GetValByCode",
			aCode: "IsHandHyRegUpdate"
			}, false);
		if(IsHandHyRegUpdate=="1"){
			//Ĭ��ҽ����ʿ�ȷǹ���ԱȨ��ֻ����д���޸ĵ�������
			//����ԱȨ��
			var CheckFlg = 0;
			if (tDHCMedMenuOper['Admin'] == 1) {
				CheckFlg = 1; 
				}
			if(CheckFlg == 0){
				var my_date = new Date();
				var first_date = new Date(my_date.getFullYear(), my_date.getMonth(), 1);
				var last_date = new Date(my_date.getFullYear(), my_date.getMonth() + 1, 0);
				var opt = $("#ObsDate").datebox('options');
				opt.minDate = opt.formatter(first_date); 
				opt.maxDate = opt.formatter(last_date); 
			}	
		}	  
		if (!obj.RegID) {
			 /* ��Ⱦ������ */
			obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);  //ҽԺ
			obj.cboObsType = obj.refreshDicID("cboObsType", "HandHyObsMethod");    //���鷽ʽ
			obj.cboObsPage = obj.refreshDicID("cboObsPage", "HandHyObsPage");  //����ҳ
			obj.ObsDate = $('#ObsDate').datebox('setValue', Common_GetDate(new Date()));  // ��������
			//ȡ��¼�˵ķ���
			obj.USERDESCLng = $m({          //��ǰҳ(Ĭ�����һҳ)
		        ClassName: "DHCHAI.Abstract",
		        MethodName: "HAIGetTranByDesc",
		        aProp: "SSUSRName"
		        ,aDesc:$.LOGON.USERDESC
		        ,aClassName:"User.SSUser"
		    }, false);
			obj.txtObsUser = $('#txtObsUser').val(obj.USERDESCLng);    //������
			$("#btnDelete").hide();
			$("#btnPrint").hide();
		}else {
			obj.refreshgridHandHyReg();
		}
    }
    //Ժ������¼�
    $HUI.combobox('#cboHospital', {
        onSelect: function (data) {
           Common_ComboToLoc("cboObsLoc", data.ID, "", "", ""); //��ʼ������
        }
    });
    //�����ı��¼�
    $HUI.combobox('#cboObsLoc', {
        onSelect: function () {
			if (($('#ObsDate').datebox('getValue'))&&($('#cboObsType').combobox('getValue'))&&($('#cboObsPage').combobox('getValue'))) {
				obj.refreshgridHandHyReg();  //ˢ�±��
			}
        }
    });
    //ҳ��ı��¼�
    $HUI.combobox('#cboObsPage', {
        onSelect: function (row) {
			if (($('#cboObsLoc').combobox('getValue'))&&($('#cboObsType').combobox('getValue'))&&($('#ObsDate').datebox('getValue'))) {
				obj.refreshgridHandHyReg();  //ˢ�±��
			}
        }
    });
    //���ڸı��¼�
    $HUI.datebox('#ObsDate', {
        onChange: function (newValue, oldValue) {
			if (($('#cboObsLoc').combobox('getValue'))&&($('#cboObsType').combobox('getValue'))&&($('#cboObsPage').combobox('getValue'))) {
				obj.refreshgridHandHyReg();  //ˢ�±��
			}
        }
    })
	//���鷽ʽ�ı��¼�
    $HUI.combobox('#cboObsType', {
        onSelect: function (row) {
			var ObsPage = row.DicDesc;
			if ((!$('#cboObsLoc').combobox('getValue'))) {   //��ʼ�Բ����Ϊ��¼����
				$('#cboObsLoc').combobox('setValue',$.LOGON.LOCID);
			}
			if (($('#cboObsLoc').combobox('getValue'))&&($('#ObsDate').datebox('getValue'))&&($('#cboObsPage').datebox('getValue'))) {
				obj.refreshgridHandHyReg();  //ˢ�±��
			}
        }
    })
	
    //ˢ�±�
    obj.refreshgridHandHyReg = function () {
		if (!obj.RegID) {
			var HospitalDr = $('#cboHospital').combobox('getValue'); 
			var ObsLocDr = $('#cboObsLoc').combobox('getValue'); 
			var ObsMethod = $('#cboObsType').combobox('getValue'); 
			var ObsPage = $('#cboObsPage').combobox('getValue'); 
			var ObsDate = $('#ObsDate').datebox('getValue');
			var ObsUser = $('#txtObsUser').val();
		} else{
			var ObsLocDr = obj.ObsLocID; 
			var ObsMethod = obj.ObsMethod; 
			var ObsPage = obj.ObsPage; 
			var ObsDate = obj.ObsDate;
			var ObsUser = obj.ObsUser;
		}
		if ((ObsLocDr=="")||(ObsMethod=="")||(ObsPage=="")||(ObsDate=="")) {
			return;
		}
		
        var flg = $m({
            ClassName: "DHCHAI.IR.HandHyReg",
            MethodName: "GetIDByLocDate",
            aLocDr: ObsLocDr,
            aObsDate: ObsDate,
            aObsPageDr: ObsPage,
			aObsMethodDr: ObsMethod
        }, false);
		
        if (parseInt(flg) > 0) {
            obj.HandRegID = parseInt(flg);
            $("#btnDelete").show();
			if (ServerObj.RegVer=='2') {
				$("#btnPrint").show();
			}else {
				$("#btnPrint").hide();
			}
        } else {
            obj.HandRegID = "";
            $("#btnDelete").hide();
			$("#btnPrint").hide();
        }
        obj.gridHandHyReg.load({
            ClassName: "DHCHAI.IRS.HandHyRegSrv",
            QueryName: "QryHandHyReg",
            aLocID: ObsLocDr,
            aCheckDate: ObsDate,
            aObsPageID: ObsPage,
			aObsMethodID: ObsMethod
        })
    }
    //����
    $("#btnSave").on('click', function () {
		if (!obj.RegID) {
			var HospitalDr = $('#cboHospital').combobox('getValue'); 
			var ObsLocDr = $('#cboObsLoc').combobox('getValue'); 
			var ObsMethod = $('#cboObsType').combobox('getValue'); 
			var ObsPage = $('#cboObsPage').combobox('getValue'); 
			var ObsDate = $('#ObsDate').datebox('getValue');
			var ObsUser = $('#txtObsUser').val();
		}else {
			var ObsLocDr = obj.ObsLocID; 
			var ObsMethod = obj.ObsMethod; 
			var ObsPage = obj.ObsPage; 
			var ObsDate = obj.ObsDate;
			var ObsUser = obj.ObsUser;
		}
	 
        if (ObsLocDr == '') {
            $.messager.alert("��ʾ", "���鲡��������Ϊ��!", 'info');
            return;
        }
        if (ObsMethod == '') {
            $.messager.alert("��ʾ", "���鷽ʽ������Ϊ��!", 'info');
            return;
        }
        if (ObsPage == '') {
            $.messager.alert("��ʾ", "����ҳ������Ϊ��!", 'info');
            return;
        }
        if (ObsDate == '') {
            $.messager.alert("��ʾ", "�����·ݲ�����Ϊ��!", 'info');
            return;
        }
        if (ObsUser == '') {
            $.messager.alert("��ʾ", "�����˲�����Ϊ��!", 'info');
            return;
        }

		var HandHyRegTim = obj.CheckInputData();	
        if (!HandHyRegTim) {
            return;
        }
		if (HandHyRegTim=="") {
            $.messager.alert("��ʾ", '������������ϢΪ��!', 'info');
            return;
        }else {
			HandHyRegTim = HandHyRegTim.join("#");
		}
        var HandHyRegCnt = obj.CheckCntData();
		if (!HandHyRegCnt) {
            return;
        }	
	
	    var InputStr = obj.HandRegID;
        InputStr += "^" + ObsLocDr;        // ������Ҳ���
        InputStr += "^" + ObsMethod;       // �������ͣ��Բ�/���죩
        InputStr += "^" + ObsPage;         // ����ڼ�ҳ
        InputStr += "^" + ObsDate;         // �����·�
        InputStr += "^" + ObsUser;         // ������
        InputStr += "^" + "1";             // �Ƿ���Ч
        InputStr += "^" + "";              // �Ǽ�����
        InputStr += "^" + "";              // �Ǽ�ʱ��
        InputStr += "^" + $.LOGON.USERID;  // �Ǽ���
	  
        var flg = $m({
            ClassName: "DHCHAI.IRS.HandHyRegSrv",
            MethodName: "SaveHandHyReg",
            aInputStr: InputStr,
            aInputRegTim: HandHyRegTim,
            aInputRegCnt: HandHyRegCnt
        }, false);
     
        if (parseInt(flg) < 0) {
            if (parseInt(flg) == "-101") {
                $.messager.alert("��ʾ", '������������Ϣ����ʧ��!', 'info');
                return;
            } else if (parseInt(flg) == "-102") {
                $.messager.alert("��ʾ", '����������ʱ����Ϣ����ʧ��!', 'info');
                return;
            } else if (parseInt(flg) == "-103") {
                $.messager.alert("��ʾ", '��������������Ϣ����ʧ��!', 'info');
                return;
            } else {
                $.messager.alert("��ʾ", '����ʧ��!', 'info');
                return;
            }
        } else {
            obj.HandRegID = parseInt(flg);
			$("#btnDelete").show();
			if (ServerObj.RegVer=='2') {
				$("#btnPrint").show();
			}
            obj.refreshgridHandHyReg();
            $.messager.alert("��ʾ", '����ɹ�!', 'info');
        }
    })
	
	// ����������ʱ��
	obj.CheckInputData = function (){
		var arrResult = new Array();
        var rows = $('#gridHandHyReg').datagrid('getRows');
		if (ServerObj.RegVer!='2') {
			var ObsTypeID1 = $('#ObsTypeID1').val(); 
			var ObsTypeID2 = $('#ObsTypeID2').val(); 
			var ObsTypeID3 = $('#ObsTypeID3').val(); 
			var ObsTypeID4 = $('#ObsTypeID4').val();	
			
			for (var row = 0; row < rows.length; row++) {
				var rd = rows[row];
				var val = getItemValues(rd['Cmp1'])+",Type-"+ObsTypeID1+",Name-"+""+",Sign-A";
				var texts = getItemTexts(rd['Cmp1']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�2��3��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');              
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�2��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp2'])+",Type-"+ObsTypeID1+",Name-"+""+",Sign-A";
				var texts = getItemTexts(rd['Cmp2']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�5��6��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�5��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�6��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp3'])+",Type-"+ObsTypeID2+",Name-"+""+",Sign-B";
				var texts = getItemTexts(rd['Cmp3']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�8��9��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�8��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�9���ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp4'])+",Type-"+ObsTypeID2+",Name-"+""+",Sign-B";
				var texts = getItemTexts(rd['Cmp4']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�11��12��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�11��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�12��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp5'])+",Type-"+ObsTypeID3+",Name-"+""+",Sign-C";
				var texts = getItemTexts(rd['Cmp5']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�14��15��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�14��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�15��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp6'])+",Type-"+ObsTypeID4+",Name-"+""+",Sign-D";
				var texts = getItemTexts(rd['Cmp6']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�17��18��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�17��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�18��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
			}
		}else {	
			var ObsName1 = $('#ObsName1').lookup('getText'); 
			var ObsName2 = $('#ObsName2').lookup('getText'); 
			var ObsName3 = $('#ObsName3').lookup('getText'); 
			var ObsType1 = $('#ObsType1').combobox('getValue'); 
			var ObsType2 = $('#ObsType2').combobox('getValue');
			var ObsType3 = $('#ObsType3').combobox('getValue');
		
			for (var row = 0; row < rows.length; row++) {
				var rd = rows[row];
				if ((getItemValues(rd['Cmp1']))&&(!ObsType1)) {
					 $.messager.alert("��ʾ", "��1��Ԫ,��ѡ�񱻵�����ְҵ!", 'info');              
					 return false;
				}
				var val = getItemValues(rd['Cmp1'])+",Type-"+ObsType1+",Name-"+ObsName1+",Sign-A";
				var texts = getItemTexts(rd['Cmp1']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�2��3��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');              
						return false;
					}
				}
				//�����ѡ��������û��������ԭ��������
				if(Common_CheckboxLabel(rd['Cmp1']+"-I5").indexOf($g("����"))>-1&&(($('#'+rd['Cmp1']+'-Other').val()==undefined)||($('#'+rd['Cmp1']+'-Other').val()==""))){
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��,����д��ȷ����ԭ��!", 'info');
					return false;
				}

				if (((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0))||((("," + texts + ",").indexOf(",�Ӵ����˺�,") >= 0) && (("," + texts + ",").indexOf(",�Ӵ�������,") >= 0))) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�2��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				var Err=getErrTexts(rd['Cmp1']);
				if (((("," + texts + ",").indexOf(",ϴ��,") >= 0) ||(("," + texts + ",").indexOf(",����,") >= 0)||(("," + texts + ",").indexOf(",ϴ��+����,") >= 0))&& (("," + texts + ",").indexOf(",��ȷ,") <0)&&(!Err)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��4��,ϴ�֡�������ϴ��+��������ȷʱ��ѡ����ȷԭ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��ȷ,")>=0)&&(Err)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��4��,ϴ�֡�������ȷ�벻��ȷԭ�򲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
				
				if ((getItemValues(rd['Cmp2']))&&(!ObsType2)) {
					 $.messager.alert("��ʾ", "��2��Ԫ,��ѡ�񱻵�����ְҵ!", 'info');              
					 return false;
				}
				var val = getItemValues(rd['Cmp2'])+",Type-"+ObsType2+",Name-"+ObsName2+",Sign-B";
				var texts = getItemTexts(rd['Cmp2']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�6��7��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				//�����ѡ��������û��������ԭ��������
				if(Common_CheckboxLabel(rd['Cmp2']+"-I5").indexOf($g("����"))>-1&&(($('#'+rd['Cmp2']+'-Other').val()==undefined)||($('#'+rd['Cmp2']+'-Other').val()==""))){
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��,����д��ȷ����ԭ��!", 'info');
					return false;
				}				
				if (((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0))||((("," + texts + ",").indexOf(",�Ӵ����˺�,") >= 0) && (("," + texts + ",").indexOf(",�Ӵ�������,") >= 0))) {
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�7��,�ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				
				var Err=getErrTexts(rd['Cmp2']);
				if (((("," + texts + ",").indexOf(",ϴ��,") >= 0) ||(("," + texts + ",").indexOf(",����,") >= 0)||(("," + texts + ",").indexOf(",ϴ��+����,") >= 0))&& (("," + texts + ",").indexOf(",��ȷ,") <0)&&(!Err)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�7��8��,ϴ�֡�������ϴ��+��������ȷʱ��ѡ����ȷԭ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��ȷ,")>=0)&&(Err)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�7��8��,ϴ�֡�������ȷ�벻��ȷԭ�򲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
				
				if ((getItemValues(rd['Cmp3']))&&(!ObsType3)) {
					 $.messager.alert("��ʾ", "��3��Ԫ,��ѡ�񱻵�����ְҵ!", 'info');              
					 return false;
				}
				var val = getItemValues(rd['Cmp3'])+",Type-"+ObsType3+",Name-"+ObsName3+",Sign-C";
				var texts = getItemTexts(rd['Cmp3']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("��ʾ", "��" + (row + 1) + "�е�10��11��,��ѡ��ָ������������Ϊ,����ϵͳ��Ϊ��Ч��¼!", 'info');
						return false;
					}
				}
				//�����ѡ��������û��������ԭ��������
				if(Common_CheckboxLabel(rd['Cmp3']+"-I5").indexOf($g("����"))>-1&&(($('#'+rd['Cmp3']+'-Other').val()==undefined)||($('#'+rd['Cmp3']+'-Other').val()==""))){
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�3��,����д��ȷ����ԭ��!", 'info');
					return false;
				}				
				if (((("," + texts + ",").indexOf(",���˺�,") >= 0) && (("," + texts + ",").indexOf(",������,") >= 0))||((("," + texts + ",").indexOf(",�Ӵ����˺�,") >= 0) && (("," + texts + ",").indexOf(",�Ӵ�������,") >= 0))) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�10��,���˺󡢻����󲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��,") >= 0) && (("," + texts + ",").indexOf(",��ȷ,") >= 0)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�11���ޡ���ȷ����ͬʱѡ��!", 'info');
					return false;
				}
				var Err=getErrTexts(rd['Cmp3']);
				if (((("," + texts + ",").indexOf(",ϴ��,") >= 0) ||(("," + texts + ",").indexOf(",����,") >= 0)||(("," + texts + ",").indexOf(",ϴ��+����,") >= 0))&& (("," + texts + ",").indexOf(",��ȷ,") <0)&&(!Err)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�11��12��,ϴ�֡�������ϴ��+��������ȷʱ��ѡ����ȷԭ��!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",��ȷ,")>=0)&&(Err)) {
					$.messager.alert("��ʾ", "��" + (row + 1) + "�е�11��12��,ϴ�֡�������ȷ�벻��ȷԭ�򲻿�ͬʱѡ��!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
			}
		}
		return arrResult;
	}
	// ��������������
	obj.CheckCntData = function (){
		var HandHyRegCnt ="";
		if (ServerObj.RegVer!='2') {
			var ObsNumber1 = $('#ObsNumber1').val(); 
			var ObsNumber2 = $('#ObsNumber2').val(); 
			var ObsNumber3 = $('#ObsNumber3').val(); 
			var ObsNumber4 = $('#ObsNumber4').val();
			var ObsType1 = $('#ObsType1').val(); 
			var ObsType2 = $('#ObsType2').val(); 
			var ObsType3 = $('#ObsType3').val(); 
			var ObsType4 = $('#ObsType4').val();	
			var ObsTypeID1 = $('#ObsTypeID1').val(); 
			var ObsTypeID2 = $('#ObsTypeID2').val(); 
			var ObsTypeID3 = $('#ObsTypeID3').val(); 
			var ObsTypeID4 = $('#ObsTypeID4').val();	

			if (ObsNumber1 == '') {
				$.messager.alert("��ʾ", ObsType1+"��������������Ϊ��!", 'info');
				return false;
			}
			if (ObsNumber2 == '') {
				$.messager.alert("��ʾ", ObsType2+"��������������Ϊ��!", 'info');
				return false;
			}
			if (ObsNumber3 == '') {
				$.messager.alert("��ʾ", ObsType3+"��������������Ϊ��!", 'info');
				return false;
			}
			if (ObsNumber4 == '') {
				$.messager.alert("��ʾ", ObsType4+"��������������Ϊ��!", 'info');
				return false;
			}
			HandHyRegCnt = ObsTypeID1+","+ObsNumber1 +",A"+ "#"+ObsTypeID2+","+ObsNumber2 +",B"+ "#"+ObsTypeID3+"," + ObsNumber3 +",C"+"#"+ObsTypeID4+","+ObsNumber4+",D";
		}else {	
			var ObsName1 = $('#ObsName1').lookup('getText'); 
			var ObsName2 = $('#ObsName2').lookup('getText'); 
			var ObsName3 = $('#ObsName3').lookup('getText'); 
			var ObsType1 = $('#ObsType1').combobox('getValue'); 
			var ObsType2 = $('#ObsType2').combobox('getValue');
			var ObsType3 = $('#ObsType3').combobox('getValue');
			HandHyRegCnt = ObsType1+"," + (ObsType1 ? 1:"") +"," +(ObsType1 ? "A":"")+ "#"+ObsType2+"," + (ObsType2 ? 1:"") +"," +(ObsType2 ? "B":"")+ "#"+ObsType3+","+(ObsType3 ? 1:"")+"," +(ObsType3 ? "C":"");
		}
		return HandHyRegCnt;
	}
	//��ӡ
    $("#btnPrint").on('click', function () {
		var RegID=(obj.RegID) ? obj.RegID:obj.HandRegID;
       	var fileName="DHCHAIHandHyReport.raq&aRegID="+RegID;
		DHCCPM_RQPrint(fileName);
    })
    //��ӡ�հ�
    $("#btnPrintNull").on('click', function () {
		var RegID="0";
       	var fileName="DHCHAIHandHyReport.raq&aRegID="+RegID;
		DHCCPM_RQPrint(fileName);
    })
    //ɾ��
    $("#btnDelete").on('click', function () {
        if (obj.HandRegID == "") {
			$.messager.alert("��ʾ", "������ʱ�޷�ɾ��!", 'info');
			return;
		}
        $.messager.confirm("��ʾ", 'ȷ���Ƿ�ɾ��?', function (r) {
            if (r) {
                var flg = $m({
                    ClassName: "DHCHAI.IR.HandHyReg",
                    MethodName: "DeleteById",
                    aId: obj.HandRegID
                }, false);
                if (parseInt(flg) < 0) {
                    $.messager.alert("��ʾ", "ɾ��ʧ��!", 'info');
                } else {
                    $("#btnDelete").hide();
					$("#btnPrint").hide();
                    obj.HandRegID = "";
					if (!obj.RegID) {
						obj.refreshgridHandHyReg();
					}else {
						$("#btnSave").hide();
					}
                    $.messager.popover({msg: 'ɾ���ɹ���',type: 'success',timeout: 2000});
                }
            }
            else {
                return;
            }
        });
    })
    function getItemValues(cmp) {
        var str = "";
        if (cmp == "") {
            return str;
        }
        var cmpArr = $('ul#' + cmp + ' li :checkbox');
        for (var num = 0; num < cmpArr.length; num++) {
            if (cmpArr[num].checked) {
                str = str + ',' + cmpArr[num].id;
            }
        }
        var cmpArr = $('ul#' + cmp + ' li :radio');
        for (var num = 0; num < cmpArr.length; num++) {
            if (cmpArr[num].checked) {
                str = str + ',' + cmpArr[num].id;
            }
        }
		if(($('#'+cmp+'-Other').val())!=undefined&&($('#'+cmp+'-Other').val()!="")){
			str= str +',Other-'+ $('#'+cmp+'-Other').val()
		}
		
        if (str != "") {
            var str = str.substring(1);
        }
        return str;
    }

    function getItemTexts(cmp) {
        var str = "";
        if (cmp == "") {
            return str;
        }
        $('ul#' + cmp).find("li").each(function () {
            if ($(this).find("input")[0].checked) {
                str = str + ',' + $.trim($(this).text());
            }
        });

        if (str != "") {
            var str = str.substring(1);
        }
        return str;
    }
	
	
	function getErrTexts(cmp) {
        var str = "";
        if (cmp == "") {
            return str;
        }
		$("input[name='"+cmp + '-I5'+"']:checked").each(function(){
             str = str + ',' +$(this).attr("label");
        });
		if (str != "") {
            var str = str.substring(1);
        }
        return str;
    }
    //�����ֵ�������(Ĭ��ѡ�е�һ��)
	obj.refreshDicID = function (ItemCode, DicType) {
	    $HUI.combobox("#" + ItemCode, {
	        url: $URL,
	        editable: true,
	        allowNull: true,
	        defaultFilter: 4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
	        valueField: 'ID',
	        textField: 'DicDesc',
			loadFilter : function(data) {
				if (obj.ParamAdmin=="Admin"){
					return data;
				}/*
				var len=data.length
				for (var indRd = 0; indRd < data.length; indRd++){
					var rd = data[indRd];
					if (rd["DicDesc"]==$g("����")) {
						delete data[indRd];
						data.length=len-2;
						break;
					}
				}*/
				return data;
				
			},
	        onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
	            param.ClassName = 'DHCHAI.BTS.DictionarySrv';
	            param.QueryName = 'QryDic';
	            param.aTypeCode = DicType;
	            param.aActive = 1;
	            param.ResultSetType = 'array';
	        },
	        onLoadSuccess: function () {   //��ʼ���ظ�ֵ
	            var data = $(this).combobox('getData');
	            if (data.length > 0) {
	                $(this).combobox('select', data[0]['ID']);
	            }
	        },
			
	    });
	}
}