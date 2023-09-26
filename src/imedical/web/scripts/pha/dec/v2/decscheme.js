/*
 * @ģ��:     ��ҩ����ά��
 * @��д����: 2019-08-07
 * @��д��:   hulihua
 */
$(function () {
	InitDict();
	InitGridDecScheme();
});

/*
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	var activeData = [{ "RowId": "Y", "Description": "����" }, { "RowId": "N", "Description": "������" }];
	var YOrNData = [{ "RowId": "Y", "Description": "��" }, { "RowId": "N", "Description": "��" }];
	PHA.ComboBox("cmbActive", {
		data: activeData
	});
	
	PHA.ComboBox("cmbPresForm", {
		url: PHA_DEC_STORE.PrescForm().url
	});
	var presEffectData = [{
				"RowId": "һ����",
				"Description": "һ����"
			}, {
				"RowId": "�����",
				"Description": "�����"
			}, {
				"RowId": "�̲���",
				"Description": "�̲���"
			}
		]
	PHA.ComboBox("cmbPresEffect", {
		data: presEffectData
	});
	PHA.ComboBox("cmbSecDec", {
		data: YOrNData
	});
	PHA.ComboBox("cmbPaste", {
		data: YOrNData
	});
	PHA.ComboBox("qCmbScheState", {
		width: 110,
		//placeholder: '����״̬...',
		data: activeData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	
	PHA.ComboBox("qCmbPresEffect", {
		width: 110,
		//placeholder: '������Ч...',
		data: presEffectData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	PHA.ComboBox("qCmbSecDec", {
		width: 110,
		//placeholder: '�Ƿ����...',
		data: YOrNData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	PHA.ComboBox("qCmbPaste", {
		width: 110,
		//placeholder: '�Ƿ��Ƹ�...',
		data: YOrNData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	PHA.ComboBox("qCmbPresForm", {
		width: 110,
		//placeholder: '��������...',
		url: PHA_DEC_STORE.PrescForm().url,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	$("#qTxtScheName").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryGrid();
		}
	});
}
/*
 * ��ʼ���������
 * @method InitGridDecScheme
 */
function InitGridDecScheme() {
	var columns = [
		[{
				field: 'TDecScheId',
				title: 'TDecScheId',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'TScheCode',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TScheDesc',
				title: '��������',
				align: 'left',
				width: 140
			}, {
				field: 'TActiveFlag',
				title: '����״̬',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "����";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else if (value == "N") {
						return "������";		//PHA_COM.Fmt.Grid.No.Icon;
					} else  {
						return "";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}, {
				field: 'TPresForm',
				title: '��������',
				align: 'left',
				width: 120
			}, {
				field: 'TPresEffect',
				title: '������Ч',
				align: 'left',
				hidden: true ,
				width: 100
			}, {
				field: 'TSoakInt',
				title: '����ʱ��(��)',
				align: 'left',
				width: 100
			}, {
				field: 'TFirDecInt',
				title: '�׼�ʱ��(��)',
				align: 'left',
				width: 100
			}, {
				field: 'TFirWaterQua',
				title: '�׼��ˮ��(ML)',
				align: 'left',
				width: 120
			}, {
				field: 'TSecDecFlag',
				title: '�Ƿ����',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "��";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else {
						return "��";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}, {
				field: 'TPasteFlag',
				title: '�Ƿ��Ƹ�',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "��";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else {
						return "��";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}, {
				field: 'TSecDecInt',
				title: '����ʱ��(��)',
				align: 'left',
				width: 100
			}, {
				field: 'TSecWaterQua',
				title: '�����ˮ��(ML)',
				align: 'left',
				width: 120
			}, {
				field: 'TTemper',
				title: '�¶�(��)',
				align: 'left',
				width: 60
			}, {
				field: 'TPressure',
				title: 'ѹǿ(��)',
				align: 'left',
				width: 80
			}, {
				field: 'TPresFormDr',
				title: '�����������',
				align: 'left',
				width: 10,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.DEC.CfDecSche.Query',
			QueryName: 'QueryProSche'
		},
		toolbar: "#gridDecSchemeBar",
		columns: columns,
		onDblClickRow: function (rowIndex) {
			MainTain("U");
		},
        onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridDecScheme", dataGridOption);
}

function MainTain(type) {
    var gridSelect = $('#gridDecScheme').datagrid('getSelected');
    if (type == "U") {
        if (gridSelect == null) {
            PHA.Popover({
                msg: "����ѡ����Ҫ�޸ĵļ�¼",
                type: 'alert'
            });
            return;
        }
		$("#txtScheCode").val(gridSelect.TScheCode);
		$('#txtScheDesc').val(gridSelect.TScheDesc);
		$('#txtScheCode').validatebox('validate');
		$('#txtScheDesc').validatebox('validate');
		$("#cmbActive").combobox('setValue', gridSelect.TActiveFlag);
		$("#cmbPresForm").combobox('setValue', gridSelect.TPresFormDr);
		$("#cmbPresEffect").combobox('setValue', gridSelect.TPresEffect);
		$('#txtPressure').val(gridSelect.TPressure);
		$('#txtSoakInt').val(gridSelect.TSoakInt);
		$('#txtFirDecInt').val(gridSelect.TFirDecInt); 
		$('#txtFirWaterQua').val(gridSelect.TFirWaterQua);
		$("#cmbSecDec").combobox('setValue', gridSelect.TSecDecFlag);
		$('#txtSecDecInt').val(gridSelect.TSecDecInt); 
		$('#txtSecWaterQua').val(gridSelect.TSecWaterQua);
		$('#txtTemper').val(gridSelect.TTemper);
		$("#cmbPaste").combobox('setValue', gridSelect.TPasteFlag);
    } else if (type = "A") {
        $('#txtScheCode').val("");
		$('#txtScheDesc').val("");
		$("#cmbActive").combobox('clear');
		$("#cmbPresForm").combobox('clear');
		$("#cmbPresEffect").combobox('clear');
		$('#txtPressure').val("");
		$('#txtSoakInt').val("");
		$('#txtFirDecInt').val(""); 
		$('#txtFirWaterQua').val("");
		$("#cmbSecDec").combobox('clear');
		$('#txtSecDecInt').val(""); 
		$('#txtSecWaterQua').val("");
		$('#txtTemper').val("");
		$("#cmbPaste").combobox('clear');
    }
    $('#gridDecSchemeWin').window({ 'title': "��ҩ����" + ((type == "A") ? "����" : "�༭") })
    $('#gridDecSchemeWin').window('open');
}

/*
 * ��������
 * @method SaveData
 */
function SaveData(){
	var scheCode = $('#txtScheCode').val().trim();
	var scheDesc = $('#txtScheDesc').val().trim();
	var activeFlag = $("#cmbActive").combobox('getValue');
	var prescForm = $("#cmbPresForm").combobox('getValue');
	var prescEffect = ""	//$("#cmbPresEffect").combobox('getValue');
	var pressure = $('#txtPressure').val().trim();
	var soakInt = $('#txtSoakInt').val().trim();
	var firDecInt = $('#txtFirDecInt').val().trim(); 
	var firWaterQua = $('#txtFirWaterQua').val().trim();
	var secDecFlag = $("#cmbSecDec").combobox('getValue');
	var secDecInt = $('#txtSecDecInt').val().trim(); 
	var secWaterQua = $('#txtSecWaterQua').val().trim();
	var temperature = $('#txtTemper').val().trim();
	var pasteFlag = $("#cmbPaste").combobox('getValue');	//�Ƿ��Ƹ�
	var winTitle = $("#gridDecSchemeWin").panel('options').title;
	var decScheId = "";
	if (winTitle.indexOf("�༭") >= 0){
		var gridSelect = $('#gridDecScheme').datagrid('getSelected');
        decScheId = gridSelect.TDecScheId;
    }
	if((scheCode=="")||(scheCode==null)){
		PHA.Popover({
			msg: "�������벻��Ϊ�գ�",
			type: 'alert'
		});
		return;
	}
	if((scheDesc=="")||(scheDesc==null)){
		PHA.Popover({
			msg: "�������Ʋ���Ϊ�գ�",
			type: 'alert'
		});
		return;
	}
	if((activeFlag=="")||(activeFlag==null)){
		PHA.Popover({
			msg: "����״̬����Ϊ�գ�",
			type: 'alert'
		});
		return;
	}
	if((prescForm=="")||(prescForm==null)){
		PHA.Popover({
			msg: "�������Ͳ���Ϊ�գ�",
			type: 'alert'
		});
		return;
	}
	/*
	if((prescEffect=="")||(prescEffect==null)){
		PHA.Popover({
			msg: "������Ч����Ϊ�գ�",
			type: 'alert'
		});
		return;
	}
	*/
	var dataStr1=scheCode+"^"+scheDesc+"^"+activeFlag+"^"+prescForm+"^"+prescEffect
	var dataStr2=pressure+"^"+soakInt+"^"+firDecInt+"^"+firWaterQua+"^"+secDecFlag
	var dataStr3=secDecInt+"^"+secWaterQua+"^"+temperature+"^"+pasteFlag
	var dataStr=dataStr1+"^"+dataStr2+"^"+dataStr3;
	$m({
		ClassName:"PHA.DEC.CfDecSche.OperTab",
		MethodName:"SavOrUpData",
		ProScheId:decScheId,
		SqlStr:dataStr
	},function(txtData){
		var retCode=txtData.split("^")[0];
		if(retCode==0){
			PHA.Popover({
				msg: "����ɹ���",
				type: 'success'
			});
			$('#gridDecSchemeWin').window('close');
			$('#gridDecScheme').datagrid('query');
		}else{
			PHA.Popover({
				msg: "����ʧ�ܣ�" + txtData.split("^")[1],
				type: 'alert'
			});
			return;
		}
	});
}
/*
 * ��ȡ����ֵ
 * @method CloseWin
 */
function getParam() {
	var scheName = $("#qTxtScheName").val();
	var scheState = $("#qCmbScheState").combobox("getValue");
	var presEffect = "" //$("#qCmbPresEffect").combobox("getValue");
	var secDec = $("#qCmbSecDec").combobox("getValue");
	var presForm = $("#qCmbPresForm").combobox("getValue");
	var paste = $("#qCmbPaste").combobox("getValue");
	return scheName +"^"+ scheState +"^"+ presForm +"^"+ secDec +"^"+  presEffect +"^"+ paste;
}
/*
 * ���ر������
 * @method InitGridDecScheme
 */
function queryGrid(){
	$('#gridDecScheme').datagrid('query',{
		inputStr: getParam()	
	});
}
/*
 * ��ս���
 * @method Clear
 */
function Clear(){
	$("#qTxtScheName").val("");
	$("#qCmbScheState").combobox("setValue","");
	$("#qCmbPresEffect").combobox("setValue","");
	$("#qCmbSecDec").combobox("setValue","");
	$("#qCmbPresForm").combobox("setValue","");
	$('#gridDecScheme').datagrid('clear');
	$("#qCmbPaste").combobox("setValue","");
}
/*
 * �رյ�����
 * @method CloseWin
 */
function CloseWin() {
	$('#gridDecSchemeWin').window('close');
}
