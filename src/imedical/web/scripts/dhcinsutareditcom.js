/*
* FileName:	dhcinsutareditcom.js
* User:		DingSH 
* Date:		2019-06-06	
* Description: ҽ��Ŀ¼ά������
*/
var GUser=session['LOGON.USERID'];
var HospDr='';
var GlobalInsuType = '';
$.extend($.fn.validatebox.defaults.rules, {
	checkZfblMaxAmt: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "����ֵ����С��0����1"
	}
});

$(function () {
	var Rq = INSUGetRequest();
	var rowid = Rq["InItmRowid"];
	var AllowUpdateFlag = Rq["AllowUpdateFlag"]; // �Ƿ������޸ı�־
	var HospDr = Rq["Hospital"]
	//// tangzf 2019-8-9 add new insuitmes start-----------------
	InitSfxmbmCmb(); // ��ʼ��ҽ������
	InitSfdlbm();	// ���÷���
	
	GlobalInsuType=Rq["INSUType"]; //
	$('#lsfxmbm').combobox('select',GlobalInsuType)
	disableById("lsfxmbm");
	Initflzb1();	// ����ָ��1
	Initflzb2();	// ����ָ��2
	//$('#lsfxmbm').combobox('reload');
	//init_lxmlbCombobox(); //��Ŀ���
	if(rowid!=""){
		disableById("lsfxmbm") ; //����������򲻽���	�ڴ˴��ɸ��������� ������ҽ�����ֶ����ĵ�  ��Ŀ
	}else{
		$('#btnU').linkbutton({text:'����',iconCls:'icon-w-add'});
	}
	if(AllowUpdateFlag == 'N'){
		$('#btnU').hide();//ҽ��Ŀ¼���ս������ӹ����Ĳ������޸�	
	}
	// tangzf 2019-8-9 add new insuitmes end -----------------
	$.m({
		ClassName: "web.INSUTarItemsCom",
		MethodName: "GetInItemById",
		type: "GET",
		Rowid: rowid
	},function (rtn) {
			if (rtn != "-1") {
				//alert("rtn="+rtn)
				var AryD = rtn.split("^");
				InsuType = AryD[2];
				loadInItm(rtn); // 
			}
		});
	$("#btnU").click(function () {	
		UpdateInItm();		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
	
	
	
//ҽ����Ŀ���ƻس��¼�
$("#lxmmc").keyup(function(e) { lxmmc_onkeyup(e);});  

$('.textbox').blur(function (e){
	        try
	        {
			  INSUcheckText(this.value); 
	        }
	        catch(ex)
	        {
		        e.target.value="";
			    e.target.focus(); 
		     }
			
	});


});	


//ҽ����Ŀ���ƻس��¼�
function lxmmc_onkeyup(e){	
	if (e.keyCode==13)
	{
	$.m({
		ClassName: "web.DHCINSUPort",
		MethodName: "GetCNCODE",
		type: "GET",
		HANZIS:getValueById("lxmmc"),
		FLAG: "4",
		SPLIT: ""
	},function (rtn)
	{	
		setValueById("lxmrj", rtn);	
		});
    }
    else{
	    if (getValueById("lxmmc")==""){setValueById("lxmrj", "")}
	    }
	
		
}
/*
 * ��������
 */
function checkData() {
	var rtn = true;
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		rtn = false;
		$.messager.alert('��ʾ', '������֤ʧ��' , 'error');
	}
	return rtn;
}
//��ʼ��Sfxmbm
function InitSfxmbmCmb() {
	$HUI.combobox("#lsfxmbm", {
		url: $URL,
		editable: false,
		valueField: 'cCode',
		textField: 'cDesc',
		panelHeight: 100,
		method: "GET",
		//data:comboJson.rows,
		onBeforeLoad: function (param) {
			param.ClassName = "web.INSUDicDataCom"
			param.QueryName = "QueryDic"
			param.ResultSetType = "array";
			param.Type = "DLLType"
			param.Code = ""
		},
		loadFilter: function (data) {
			for (var i in data) {
				if (data[i].cDesc == "ȫ��") {
					data.splice(i, 1);
				}
			}
			return data;
		},
		onLoadSuccess: function (data) {
		},
		onSelect: function (rec) {
			// tangzf 2019-8-9 ����ҽ��Ŀ¼ �л�ҽ������ʱ  ����combobox----------
			//var InsuType=rec.cCode;
			//INSULoadDicData('lsfdlbmdesc','FeeType' + GlobalInsuType);  // ���ط��÷���
			//INSULoadDicData('ltjdm','AKA065' + GlobalInsuType);  // ������Ŀ�ȼ�
			//INSULoadDicData('lxmlb','AKE003' + GlobalInsuType);  // ������Ŀ���
			INSULoadDicData('lsfdlbmdesc','med_chrgitm_type' + GlobalInsuType);  // ���ط��÷���
			INSULoadDicData('ltjdm','chrgitm_lv' + GlobalInsuType);  // ������Ŀ�ȼ�
			INSULoadDicData('lxmlb','list_type' + GlobalInsuType);  // ������Ŀ���
			// tangzf 2019-8-9 ����ҽ��Ŀ¼ �л�ҽ������ʱ  ����combobox----------	 
		}			 			 
	});
}
function InitSfdlbm() {
	$("#lsfdlbmdesc").combobox({
		onSelect: function ( rowData,rowIndex) {
		 	setValueById("lsfdlbm", rowData.cCode);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				setValueById("lsfdlbm", "");
			}
		}
	});
}	 
//����ҽ����Ч��־flzb2
function Initflzb2() {
	$HUI.combobox("#lflzb2", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: 'Y', text: '��' }
			, { id: 'N', text: '��' }
	 
		]
	}
	);
}
//�����Ƿ�ҽ����־ flzb1
function Initflzb1() {
	$HUI.combobox("#lflzb1", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: 'Y', text: '��' }
			, { id: 'N', text: '��' }
		]
	}
	);
}
//ҽ��Ŀ¼ά��������ֵ
function loadInItm(InData) {
	var AryD = InData.split("^");
	setTimeout(function () {
			setValueById("lrowid", AryD[0]);
			setValueById("lsfxmbm", AryD[2]);
			setValueById("lsfdlbm", AryD[1]);
			setValueById("lsfdlbmdesc", AryD[1]);
		}, 300);
	setValueById("lxmlb", AryD[7]);
	setValueById("lxmbm", AryD[3]);
	setValueById("lpzwh", AryD[14]);
	setValueById("lflzb3", AryD[26]);
	setValueById("lxmmc", AryD[4]);
	setValueById("lspmc", AryD[31]);
	setValueById("lflzb4", AryD[27]);
	setValueById("lgg", AryD[9]);
	setValueById("lspmcrj", AryD[32]);
	setValueById("lflzb5", AryD[28]);
	setValueById("ljx", AryD[8]);
	setValueById("lbzjg", AryD[15]);
	setValueById("lflzb6", AryD[29]);
	setValueById("ldw", AryD[10]);
	setValueById("lsjjg", AryD[16]);
	setValueById("lflzb7", AryD[30]);
	setValueById("lxmrj", AryD[5]);
	setValueById("lzgxj", AryD[17]);
	setValueById("lfplb", AryD[36]);
	setValueById("lyf", AryD[11]);
	setValueById("lbpxe", AryD[21]);
	setValueById("lljzfbz", AryD[33]);
	setValueById("lzfbl1", AryD[18]);
	setValueById("lyl", AryD[12]);
	setValueById("lyyjzjbz", AryD[34]);
	setValueById("lflzb1", AryD[24]);
	setValueById("lsl", AryD[13]);
	setValueById("lyysmbm", AryD[35]);
	setValueById("lzfbl2", AryD[19]);
	setValueById("lDicType", AryD[37]);
	setValueById("ltjdm", AryD[23]);
	setValueById("lzfbl3", AryD[20]);
	setValueById("lUnique", AryD[43]);
	setValueById("lActiveDate", AryD[42]);
	setValueById("ltxbz", AryD[6]);
	setValueById("lbz", AryD[22]);
	setValueById("lExpiryDate", AryD[44]);
	setValueById("lDate", AryD[39]);
	setValueById("lUserName", AryD[48]);
	setValueById("lUserDr", AryD[38]);	
	setValueById("lflzb2", AryD[25]);	// 2019-8-9 tangzf ��Ч��־
}	
//����ҽ��Ŀ¼
function UpdateInItm() {
	var InStr = BuildInItmFromEdStr();
	if (InStr == "-1" || !checkData()) return "-1";
	$.m({
		ClassName: "web.INSUTarItemsCom",
		MethodName: "CheckInsu",
		type: "POST",
		InStr: InStr
	}, function (rtn) {
		if ((rtn > 0) & (rtn != getValueById("lrowid"))) {
			$.messager.alert("��ʾ", "����ͬ��ҽ����Ŀ,��������", 'info');
			return "-1";
		}
		else {
			$.m({
				ClassName: "web.INSUTarItemsCom",
				MethodName: "Update",
				type: "POST",
				itmjs: "",
				itmjsex: "",
				InString: InStr
			}, function (srtn) {
					if (srtn == "0") { $.messager.alert("��ʾ", "���³ɹ�", 'info',function(){
						websys_showModal('close');	
					});}
					else { $.messager.alert("��ʾ", "����ʧ��,Err=" + srtn, 'info');}
				});
		} 
	});		 
}



function BuildInItmFromEdStr() {
	//*У������
	//var ChkValErrMsg = ChkValErr();			
	var InStr = getValueById("lrowid");
	InStr = InStr + "^" + getValueById("lsfdlbm")  //�շѴ������
	InStr = InStr + "^" + getValueById("lsfxmbm")  //ҽ������
	InStr = InStr + "^" + getValueById("lxmbm")    //ҽ����Ŀ����
	InStr = InStr + "^" + getValueById("lxmmc")    //ҽ����Ŀ����
	InStr = InStr + "^" + getValueById("lxmrj")    //��Ŀƴ����
	InStr = InStr + "^" + getValueById("ltxbz")    //������ҩ��־
	InStr = InStr + "^" + getValueById("lxmlb")    //��Ŀ���
	InStr = InStr + "^" + getValueById("ljx")      //����
	InStr = InStr + "^" + getValueById("lgg")      //���
	InStr = InStr + "^" + getValueById("ldw")      //��λ
	InStr = InStr + "^" + getValueById("lyf")      //�÷�
	InStr = InStr + "^" + getValueById("lyl")      //����
	InStr = InStr + "^" + getValueById("lsl")      //����
	InStr = InStr + "^" + getValueById("lpzwh")    //��׼�ĺ�
	InStr = InStr + "^" + getValueById("lbzjg")    //��׼�۸�
	InStr = InStr + "^" + getValueById("lsjjg")    //ʵ�ʼ۸�
	InStr = InStr + "^" + getValueById("lzgxj")    //����޼�
	InStr = InStr + "^" + getValueById("lzfbl1")   //�Ը�����1
	InStr = InStr + "^" + getValueById("lzfbl2")   //�Ը�����2
	InStr = InStr + "^" + getValueById("lzfbl3")   //�Ը�����3
	InStr = InStr + "^" + getValueById("lbpxe")    //�����޶�
	InStr = InStr + "^" + getValueById("lbz")      //��ע
	InStr = InStr + "^" + getValueById("ltjdm")    //��Ŀ�ȼ�
	InStr = InStr + "^" + getValueById("lflzb1")    //�Ƿ�ҽ��
	InStr = InStr + "^" + getValueById("lflzb2")    //��Ч��־ 
	InStr = InStr + "^" + getValueById("lflzb3")    //����ָ��3
	InStr = InStr + "^" + getValueById("lflzb4")    //����ָ��4
	InStr = InStr + "^" + getValueById("lflzb5")    //����ָ��5
	InStr = InStr + "^" + getValueById("lflzb6")    //����ָ��6
	InStr = InStr + "^" + getValueById("lflzb7")    //����ָ��7
	InStr = InStr + "^" + getValueById("lspmc")     //��Ʒ����
	InStr = InStr + "^" + getValueById("lspmcrj")   //��Ʒ�����ȼ�
	InStr = InStr + "^" + getValueById("lljzfbz")   //�ۼ�֧����־
	InStr = InStr + "^" + getValueById("lyyjzjbz")  //ҽԺ���ӱ�־
	InStr = InStr + "^" + getValueById("lyysmbm")   //ҽԺ��Ŀ����
	InStr = InStr + "^" + getValueById("lfplb")     //��Ʊ���
	InStr = InStr + "^" + getValueById("lDicType")  //Ŀ¼���
	InStr = InStr + "^" + GUser + "^" + "" + "^" + "" + "^" + ClientIPAddress;
	InStr = InStr + "^" + getValueById("lActiveDate");
	InStr = InStr + "^" + getValueById("lUnique");
	InStr = InStr + "^" + getValueById("lExpiryDate");
	InStr = InStr + "^" + HospDr;
	return InStr;
}

//���ҽ��Ŀ¼ά��
function clearInItm() {
	setValueById("lrowid", "");
	setValueById("lsfxmbm", "");
	setValueById("lsfdlbmdesc", "");
	setValueById("lsfdlbm", "");
	setValueById("lxmlb", "");
	setValueById("lxmbm", "");
	setValueById("lpzwh", "");
	setValueById("lflzb3", "");
	setValueById("lxmmc", "");
	setValueById("lspmc", "");
	setValueById("lflzb4", "");
	setValueById("lgg", "");
	setValueById("lspmcrj", "");
	setValueById("lflzb5", "");
	setValueById("ljx", "");
	setValueById("lbzjg", "");
	setValueById("lflzb6", "");
	setValueById("ldw", "");
	setValueById("lsjjg", "");
	setValueById("lflzb7", "");
	setValueById("lxmrj", "");
	setValueById("lzgxj", "");
	setValueById("lfplb", "");
	setValueById("lyf", "");
	setValueById("lbpxe", "");
	setValueById("lljzfbz", "");
	setValueById("lzfbl1", "");
	setValueById("lyl", "");
	setValueById("lyyjzjbz", "");
	setValueById("lflzb1", "");
	setValueById("lsl", "");
	setValueById("lyysmbm", "");
	setValueById("lzfbl2", "");
	setValueById("lDicType", "");
	setValueById("ltjdm", "");
	setValueById("lzfbl3", "");
	setValueById("lUnique", "");
	setValueById("lActiveDate", "");
	setValueById("ltxbz", "");
	setValueById("lbz", "");
	setValueById("lExpiryDate", "");
	setValueById("lDate", "");
	setValueById("lUserName", "");
	setValueById("lUserDr", "");
}	
//����У�飬У���Ƿ������ַ� DingSH 20171219
function CheckVal(InArgStr, InArgName) {
	var ErrMsg = "";
	var specialKey = "\^\'\"\n";
	var isFlag = ""
	//alert(specialKey)
	for (var i = 0; i < InArgStr.length; i++) {
		if (specialKey.indexOf(InArgStr.substr(i, 1)) >= 0) {
			isFlag = "1";
		}
	} 
	if (isFlag == "1") ErrMsg = "��" + InArgName + "��" + "��������" + "\^" + "  " + "\'" + "  " + "\"" + " �س� ���ַ�";
	//alert(ErrMsg)
	return ErrMsg;
}	
function ChkValErr() {
	var ChkValErrMsg = CheckVal(getValueById("lsfdlbm"), "�շѴ������");
	var ErrMsg = CheckVal(getValueById("lsfxmbm"), "ҽ������");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
			 
	var ErrMsg = CheckVal(getValueById("lxmbm"), "ҽ����Ŀ����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lxmmc"), "ҽ����Ŀ����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lxmrj"), "��Ŀƴ����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("ltxbz"), "������ҩ��־");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;

	var ErrMsg = CheckVal(getValueById("lxmlb"), "��Ŀ���");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
 
	var ErrMsg = CheckVal(getValueById("ljx"), "����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
			 
		 
	var ErrMsg = CheckVal(getValueById("lgg"), "���");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
			 
	
	var ErrMsg = CheckVal(getValueById("ldw"), "��λ");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lyf"), "�÷�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lyl"), "����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lsl"), "����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lpzwh"), "��׼�ĺ�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lbzjg"), "��׼�۸�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	
	var ErrMsg = CheckVal(getValueById("lsjjg"), "ʵ�ʼ۸�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lzgxj"), "����޼�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lzfbl1"), "�Ը�����1");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	
	var ErrMsg = CheckVal(getValueById("lzfbl2"), "�Ը�����2");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lzfbl3"), "�Ը�����3");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lbpxe"), "�����޶�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lbz"), "��ע");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	
	var ErrMsg = CheckVal(getValueById("ltjdm"), "��Ŀ�ȼ�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lflzb1"), "�Ƿ�ҽ��");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lflzb2"), "��Ч��־ ");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb3"), "����ָ��3");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb4"), "����ָ��4");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb5"), "����ָ��5");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb6"), "����ָ��6");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lflzb7"), "����ָ��7");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lspmc"), "��Ʒ����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lspmcrj"), "��Ʒ�����ȼ�");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lljzfbz"), "�ۼ�֧����־");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lyyjzjbz"), "ҽԺ���ӱ�־");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lyysmbm"), "ҽԺ��Ŀ����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
 
 
	var ErrMsg = CheckVal(getValueById("lfplb"), "��Ʊ���");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		

	var ErrMsg = CheckVal(getValueById("lActiveDate"), "��Ч����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lUnique"), "����Ψһ��");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("ExpiryDate"), "ʧЧ����");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	return ChkValErrMsg
}
/*
* ��Ŀ���combobox lxmlb
* tangzf 2019-7-18
*/
// ???�˴���д�� ����ͨ��ҽ���ֵ�ȡ?
function init_lxmlbCombobox() {
	/*$('#lxmlb').combobox({
		editable: false,
		valueField: 'id',
		textField: 'text',
		data: [
			{
				'id': '1',
				'text': 'ҩƷ'
			},
			{
				'id': '2',
				'text': '����'
			},
			{
				'id': '3',
				'text': '������ʩ'
			}
		]
	})*/
}
 


 