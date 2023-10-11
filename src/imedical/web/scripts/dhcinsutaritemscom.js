/*
 * FileName:	dhcinsutaritemscom.js
 * User:		DingSH 
 * Date:		2019-05-30	
 * Description: ҽ��Ŀ¼ά��
 */

var GUser = session['LOGON.USERID'];
var HospDr = session['LOGON.HOSPID'];
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],
	}
}
var INTIMxmbm = ""

$(function () {
	InitInItemsDg();
	initKeyTypes();
	//�ؼ��ֻس��¼�
	$("#tKeyWords").keydown(function (e) {
		if (e.keyCode == 13) {
			QryInTarItems();
		}
	});
	
});
//���ز�ѯ����
function initKeyTypes() {
	$HUI.combobox("#tKeyType", {
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: '0', text: '��ѯ����' }
			, { id: '1', text: '��ƴ��', selected: true }
			, { id: '2', text: '������' }
			, { id: '3', text: '������' }
		],
		defaultFilter: '1'
	});
	
	var tinsutypecombox = $('#tInsuType').combogrid({
		panelWidth: 350,
		panelHeight: 238,
		idField: 'cCode',
		textField: 'cDesc',
		rownumbers: true,
		url: $URL,
		onBeforeLoad: function (param) {
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName = 'QueryDic1';
			param.Type = 'TariType';
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		fit: true,
		pagination: false,
		columns: [[
			{ field: 'cCode', title: '����', width: 60 },
			{ field: 'cDesc', title: '����', width: 100 }
		]],
		fitColumns: true,
		onLoadSuccess: function (data) {
			tinsutypecombox.combogrid('setValue', data.rows[0].cCode);
		},
		onSelect: function (index, data) {
		}
	});
}

//��ѯҽ��Ŀ¼
function QryInTarItems() {

	//var stdate=$('#stdate').datebox('getValue');
	//var endate=$('#endate').datebox('getValue');
	var InRowid = ""
	var KeyWords = $('#tKeyWords').val();
	var KeyType = $('#tKeyType').combobox("getValue");
	if (!arguments[0]) {		//WangXQ 20220608 ���Ʋ�ѯ�ؼ�����С����,�л�Ժ��ʱ���ж�
		if (KeyType == "") { 
			$.messager.alert("��ܰ��ʾ", "��ѡ���ѯ����", "info")
			return
		}
		if (KeyType != "0" && KeyWords.length < 2) {
			$.messager.alert("��ܰ��ʾ", "������ؼ���,�ؼ��ֳ�������Ϊ2", "info")
			return
		}
	}
	$('#tInTarItems').datagrid('options').url = $URL;
	var InsuType = $('#tInsuType').combobox("getValue");
	$('#tInTarItems').datagrid('reload', {
		ClassName: 'web.INSUTarItemsCom',
		QueryName: 'QueryAll',
		txt: KeyWords,
		Class: KeyType,
		Type: InsuType,
		zfblTmp:"",
		ExpStr:"", 
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	});

}
//��ʼ��ҽ��Ŀ¼gd
function InitInItemsDg() {
	//��ʼ��datagrid
	$HUI.datagrid("#tInTarItems", {
		//url:$URL,
		fit: true,
		width: '100%',
		height: 800,
		border: false,
		singleSelect: true,
		rownumbers: true,
		data: [],
		frozenColumns: [[
			{
				field: 'TOpt',
				width: 40,
				title: '����',
				align: 'center',
				formatter: function (value, row, index) {

					return "<img class='myTooltip' style='width:60' title='�޸�' onclick=\"InTarItemsEditClick("+"'"+index+"'"+")\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' style='border:0px;cursor:pointer'>";

				}
			}

		]],
		columns: [[
			{ field: 'RecordSum', title: 'RecordSum', width: 10, hidden: true },
			{ field: 'rowid', title: 'rowid', width: 10, hidden: true },
			{ field: 'INTIMxmbm', title: 'ҽ����Ŀ����', width: 140 },
			{ field: 'INTIMxmmc', title: 'ҽ����Ŀ����', width: 180 },
			{ field: 'INTIMjx', title: '����', width: 60 },
			{ field: 'INTIMgg', title: '���', width: 60 },
			{ field: 'INTIMdw', title: '��λ ', width: 60 },
			{ field: 'INTIMsfdlbmDesc', title: '�շѴ�������', width: 100 },
			//{field:'INTIMsfdlbm',title:'�շѴ���',width:10,hidden:true},
			{ field: 'INTIMzfbl1', title: '�Ը�����', width: 80 },
			{ field: 'INTIMtjdm', title: '��Ŀ�ȼ�', width: 80 },
			{
				field: 'INTIMflzb1', title: '�Ƿ�ҽ��', width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "��";
					} else {
						return "��";
					}
				}

			},
			{
				field: 'INTIMflzb2', title: '��Ч��־', width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "��";
					} else {
						return "��";
					}
				}
			},
			{ field: 'INTIMActiveDate', title: '��Ч����', width: 100 },
			{ field: 'INTIMExpiryDate', title: 'ʧЧ����', width: 100 },
			{ field: 'INTIMDate', title: '��������', width: 100 },
			{ field: 'INTIMTime', title: '����ʱ��', width: 80 },
			{ field: 'INTIMUserName', title: '������', width: 60 },
			{ field: 'INTIMxmrj', title: 'ƴ����', width: 120 },
			{ field: 'INTIMsfxmbmdesc', title: 'ҽ�����', width: 120 },
			{ field: 'INTIMsfxmbm', title: 'ҽ�����', width: 10, hidden: true },
			{ field: 'INTIMxmlb', title: '��Ŀ���', width: 100, hidden: true },
			{ field: 'INTIMXmlbDesc', title: '��Ŀ���', width: 100 },
			{ field: 'INTIMyf', title: '�÷�', width: 80 },
			{ field: 'INTIMyl', title: '����', width: 80 },
			{ field: 'INTIMtxbz', title: '������ҩ��ʶ', width: 150 },
			{ field: 'INTIMpzwh', title: '��׼�ĺ�', width: 80 },
			{ field: 'INTIMUnique', title: '���ұ���', width: 120 },
			{ field: 'INTIMyysmbm', title: '��������', width: 140 },
			{ field: 'INTIMspmc', title: '��Ʒ����', width: 100 },
			{ field: 'INTIMspmcrj', title: '��Ʒ����ƴ����', width: 140 },
			{ field: 'INTIMyyjzjbz', title: 'ҽԺ���ӱ�ʶ', width: 140 },
			{ field: 'INTIMsfdlbm', title: '�շѴ������', width: 120 },
			{ field: 'INTIMsl', title: '����', width: 50, hidden: true },
			{ field: 'INTIMbzjg', title: '��׼�۸�', width: 50, hidden: true },
			{ field: 'INTIMsjjg', title: 'ʵ�ʼ۸�', width: 50, hidden: true },
			{ field: 'INTIMzgxj', title: '����޼�', width: 50, hidden: true },
			{ field: 'INTIMbpxe', title: '�����޶�', width: 50, hidden: true },
			{ field: 'INTIMbz', title: '��ע', width: 100, hidden: true },
			{ field: '"Index', title: '���', width: 150, hidden: true },
			{ field: 'INTIMzfbl2', title: '�Ը�����2', width: 50, hidden: true },
			{ field: 'INTIMzfbl3', title: '�Ը�����3', width: 50, hidden: true },
			{ field: 'INTIMflzb3', title: '����ָ��3', width: 50, hidden: true },
			{ field: 'INTIMflzb4', title: '����ָ��4', width: 50, hidden: true },
			{ field: 'INTIMflzb5', title: '����ָ��5', width: 50, hidden: true },
			{ field: 'INTIMflzb6', title: '����ָ��6', width: 50, hidden: true },
			{ field: 'INTIMflzb7', title: '����ָ��7', width: 50, hidden: true },
			{ field: 'INTIMljzfbz', title: '�ۼ�������ʶ', width: 50, hidden: true },
			{ field: 'INTIMfplb', title: '��Ʊ���', width: 50, hidden: true },
			{ field: 'INTIMDicType', title: 'Ŀ¼���', width: 50, hidden: true },
			{ field: 'INTIMHospDr', title: 'Ժ��ָ��', width: 50, hidden: true }
		]],
		pageSize: 20,
		pagination: true,
		onClickRow: function (rowIndex, rowData) {
		},
		onDblClickRow: function (rowIndex, rowData) {

			InTarItemsEditClick(rowIndex);
		},
		onUnselect: function (rowIndex, rowData) {
			//alert(rowIndex+"-"+rowData.itemid)
		},
		onLoadSuccess: function (data) {
			var index = 0;
		}
	});

}



function InTarItemsEditClick(rowIndex) {

	//LocRowIndex=rowIndex;
	var rowData = $('#tInTarItems').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	//initInItmFrm(rowIndex,rowData)
	//var rowData  = $('#tInTarItems').datagrid('getSelected'); //��bug
	if (!rowData ) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ��Ŀ¼!", 'info');
	   return ;
	}
	var url = "dhcinsutareditcom.csp?&InItmRowid=" + rowData.rowid + "&INSUType=" + rowData.INTIMsfxmbm + "&Hospital=" + rowData.INTIMHospDr;
	websys_showModal({
		url: url,
		title: "�޸�-ҽ��Ŀ¼ά��",
		iconCls: "icon-w-edit",
		width: "855",
		height: "660",
		onClose: function () {
			QryInTarItems(1);
		},

	}

	);

}

//��ѯҽ��Ŀ¼��Ӧ���շ���
function btnTarQryClick(){
	var selected = $('#tInTarItems').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ��Ŀ¼!", 'info');
	   return ;
	}
	var Rowid =selected.rowid 
	var url = "insutarcontrastpop.csp?&Rowid="+Rowid+"&INSUType="+selected.INTIMsfxmbm+"&Hospital=" + selected.INTIMHospDr + "&INTIMxmbm=" +selected.INTIMxmbm+ "&INSUType=" +selected.INTIMsfxmbm;
	websys_showModal({
		url: url,
		title: selected.INTIMxmmc+"--------���յ��շ���",
		iconCls: "icon-w-edit",
		width: "920",
		height: "420",
		onClose: function () {
			
		}
	});

}
//Ŀ¼��չ��Ϣά�� 2023-02-17
function  btnTarExtEditClick(){
	var rowData = $('#tInTarItems').datagrid('getSelected');
	if (!rowData) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ��Ŀ¼!", 'info');
	   return ;
	}
	var InsuCode =rowData.INTIMxmbm;
	var InsuDesc =rowData.INTIMxmmc;
	var HiType =rowData.INTIMsfxmbm; 
	var HospId =rowData.INTIMHospDr; 
	var url = "dhcinsu.taritemsextedit.csp?InsuCode="+InsuCode+"&InsuDesc="+encodeURIComponent(InsuDesc)+"&HospId=" + HospId + "&HiType=" +HiType;
	websys_showModal({
		url: url,
		title: "��"+InsuDesc+"��"+"Ŀ¼��չ��Ϣά��",
		iconCls: "icon-w-edit",
		width: "760",
		height: "345",
		onClose: function () {
			
		}
	});

}



//ҽ��Ŀ¼����
function InItmEpot() {
	try {
		var KeyWords = $('#tKeyWords').val();
		var KeyType = $('#tKeyType').combobox("getValue");
		var InsuType = $('#tInsuType').combobox("getValue");
		$.messager.progress({
			title: "��ʾ",
			msg: '���ڵ���ҽ��Ŀ¼����',
			text: '������....'
		});
		$cm({
			ResultSetType: "ExcelPlugin",
			ExcelName: "ҽ��Ŀ¼",
			PageName: "QueryAll",
			ClassName: "web.INSUTarItemsCom",
			QueryName: "QueryAll",
			txt: KeyWords,
			Class: KeyType,
			Type: InsuType,
			zfblTmp: ""
		}, function () {
			setTimeout('$.messager.progress("close");', 3 * 1000);
		});

		/*var InRowid=""
		var KeyWords=$('#tKeyWords').val();
		var KeyType=$('#tKeyType').combobox("getValue");
		var InsuType=$('#tInsuType').combobox("getValue");	
		var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"ҽ��Ŀ¼����", //Ĭ��DHCCExcel
		ClassName:"web.INSUTarItemsCom",
		QueryName:"QueryAll",
		txt:KeyWords,
		Class:KeyType,
		Type:InsuType,
		zfblTmp:""
		 },false);
		 location.href = rtn;
		$.messager.progress({
					title: "��ʾ",
					msg: '���ڵ���ҽ��Ŀ¼����',
					text: '������....'
				});
		setTimeout('$.messager.progress("close");', 3 * 1000);	
		    
			return;*/
	} catch (e) {
		$.messager.alert("����", e.message);
		$.messager.progress('close');
	};


}


function InItmImpt() {
	var filePath = ""
	var exec = '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
		+ 'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
		+ 'if (!fName){fName="";}'
		+ 'xlApp.Quit();'
		+ 'xlSheet=null;'
		+ 'xlApp=null;'
		+ 'return fName;}());'
	CmdShell.notReturn = 0;
	var rs = CmdShell.EvalJs(exec);
	if (rs.msg == 'success') {
		filePath = rs.rtn;
		importItm(filePath);
	} else {
		$.messager.alert('��ʾ', '���ļ�����' + rs.msg, 'error');
	}


}

function importItm(filePath) {
	if (filePath == "") {
		$.messager.alert('��ʾ', '��ѡ���ļ���', 'info')
		return;
	}
	$.messager.progress({
		title: "��ʾ",
		msg: 'ҽ��Ŀ¼������',
		text: '���ݶ�ȡ��...'
	});
	$.ajax({
		async: true,
		complete: function () {
			ReadItmExcel(filePath);
		}
	});

}
//��ȡExcel����
function ReadItmExcel(filePath) {

	//��ȡexcel
	var arr;
	try {
		arr = websys_ReadExcel(filePath);
		$.messager.progress("close");
	}
	catch (ex) {
		$.messager.progress("close");
		$.messager.alert('��ʾ', '����websys_ReadExcel�쳣��' + ex.message, 'error')
		return;
	}
	var rowCnt = arr.length
	$.messager.progress({
		title: "��ʾ",
		msg: 'ҽ��Ŀ¼����',
		text: '�����У�����' + (rowCnt - 1) + '��'
	});
	$.ajax({
		async: true,
		complete: function () {
			ItmArrSave(arr);
		}
	});
}
//ҽ��Ŀ¼���ݱ���
function ItmArrSave(arr) {

	//��ȡ��������
	var ErrMsg = "";     //��������
	var errRowNums = 0;  //��������
	var sucRowNums = 0;  //����ɹ�������
	var rowCnt = arr.length
	try {
		for (i = 1; i < rowCnt; i++) {
			var rowArr = arr[i]
			var UpdateStr = "^" + rowArr.join("^")
			var savecode = tkMakeServerCall("web.INSUTarItemsCom", "Update", "", "", UpdateStr)
			if (savecode == null || savecode == undefined) savecode = -1

			if (savecode >= 0) {
				sucRowNums = sucRowNums + 1;
			} else {
				errRowNums = errRowNums + 1;
				if (ErrMsg == "") {
					ErrMsg = i + ":" + savecode;
				} else {
					ErrMsg = ErrMsg + "<br>" + i + ":" + savecode;
				}
			}
		}

		if (ErrMsg == "") {
			$.messager.progress("close");
			$.messager.alert('��ʾ', '������ȷ�������');
		} else {
			$.messager.progress("close");
			var tmpErrMsg = "����ɹ���" + sucRowNums + "����ʧ�ܣ�" + errRowNums + "����";
			tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>" + ErrMsg;
			$.messager.alert('��ʾ', tmpErrMsg, 'info');
		}
		return;
	}
	catch (ex) {
		$.messager.progress("close");
		$.messager.alert('��ʾ', '����ҽ��Ŀ¼�����쳣��' + ex.message, 'error')
		return;
	}
	return;

}

function SetValue(value) {
	if (value == undefined) {
		value = "";
	}
	value = value.toString().replace(/\"/g, "");
	value = value.toString().replace(/\?/g, "");
	return value;
}
/*
 * ����ҽԺԺ��combogrid
 * tangzf 2019-7-18
 */
function selectHospCombHandle() {
	//$('#tInsuType').combobox('clear');
	$('#tInsuType').combobox('reload');
	QryInTarItems(1);	// WangXQ 20220616 �л�Ժ�����жϹؼ��ֳ���	
}
/*
 * ��������ҽ��Ŀ¼
 * tangzf 2019-7-18
 */
function addINSUTarItems() {
	//var InsuType = getValueById('tInsuType');
	var InsuType = $('#tInsuType').combogrid("getValue");	//WangXQ 20221027
	if (InsuType == "") {
		$.messager.alert('��ʾ', 'ҽ�����Ͳ���Ϊ��', 'info');
		return;
	}
	var url = "dhcinsutareditcom.csp?&InItmRowid=&INSUType=" + InsuType + "&Hospital=" + PUBLIC_CONSTANT.SESSION.HOSPID;//?&ItmRowid= + rowData.Rowid;
	websys_showModal({
		url: url,
		title: "����-ҽ��Ŀ¼ά��",
		iconCls: "icon-w-edit",
		width: "855",
		height: "660",
		onClose: function () {
			QryInTarItems();
		}
	})
}
function ExportConfig() {
	var KeyWords = $('#tKeyWords').val();
	var KeyType = $('#tKeyType').combobox("getValue");
	var InsuType = $('#tInsuType').combobox("getValue");
	window.open("websys.query.customisecolumn.csp?CONTEXT=Kweb.INSUTarItemsCom:QueryAll&PAGENAME=QueryAll" + "&txt=" + KeyWords + "&KeyType=" + KeyType + "&Type=" + InsuType + "&zfblTmp=" + "");
}




