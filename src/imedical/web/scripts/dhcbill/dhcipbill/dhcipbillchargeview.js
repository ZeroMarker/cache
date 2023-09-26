/**
*FileName:	dhcipbillchargeview.js
*Anchor:	Lid
*Date:	2015-01-10
*Description:	�°�סԺ�շ���� ����������ϵlid/hujunbin
*/
function log(val) {
	//console.log(val);
}

var FIXEDNUM = 2;
var SessionObj = {
	guser : session['LOGON.USERID'],
	group : session['LOGON.GROUPID'],
	ctLoc : session['LOGON.CTLOCID'],
	hospital : session['LOGON.HOSPID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhcbill.query.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp"
};

//סԺ�շ�����
var Config = {
	dhcJfConfig : null,
	initConfig: function() {
		//��Ҫ����dhcjfconfig.js
		this.dhcJfConfig = new DHCJFConfig();
	},
	clearConfig: function() {
		this.dhcJfConfig = null;
	}
}

var GlobalObj = {
	patientId : "",
	episodeId : "",
	billId : "",
	prtId : "",
	balance: 99999, //ƽ����
	initGlobal : function(patientId, episodeId, billId, prtId){
		this.patientId = patientId;
		this.episodeId = episodeId;
		this.billId  = billId;
		this.prtId = prtId;
	},
	clearGlobal : function(){
		this.patientId = "";
		this.episodeId = "";
		this.billId  = "";
		this.prtId = "";
		this.balance = 99999;
	},
	initGlobalByData : function(rowData) {
		this.patientId  = rowData.patientid;
		this.episodeId  = rowData.episodeid;
		this.billId = rowData.pbrowid;
		this.prtId = rowData.prtrowid;
	},
	initBalance: function(balance) {
		this.balance = balance;
	}
}

var editIndex = undefined;
var clickBillFlag = ""; //����ʱ�ж��Ƿ������˵�

//ȫ�ֱ���Ѻ�����
var DepositSelectObj = {
	loadFlag: false,
	depositArray: [],
	autoSelectFlag: false
}

//�������
jQuery(document).ready(function(){
	setTimeout("initDocument();",50);
});

function initDocument() {
	Config.initConfig();
	GlobalObj.clearGlobal();
	initPanel();
	initLedgerData();
	initPaymListData();
	initTabsEvent();
	loadDHCIPBillEvent();
	checkInv(); //����Ĭ�Ϸ�Ʊ��
	//�Ƿ����ӹ�����
	if(m_Adm && m_Adm != "") {
		getPatInfo();
	}
	setFocus("patientNO");
}


function initPanel() {
	//addTabs();
	initTopPanel();
	initPaymListPanel();
	initLedgerPanel();
	initButtonPanel();
	initDepositPanel();
	initPatListPanel();  //ע��λ�ã�Ҫ�ŵ����
}

function clearData() {
	//jQuery("#tPaymList").datagrid('loadData', {total: 0, rows: []});
	//jQuery("#tLedger").datagrid('loadData', {total: 0, rows: []});
	//clearPatFeeInfo();
	initDepositData();
	initLedgerData();
	initPaymListData();
	clearPatFeeInfo();
	if(m_Adm) {
		m_Adm = "";
	}
}

function clearTopInfo() {
	jQuery("#patientNO").val("");
	jQuery("#medicareNO").val("");
	jQuery("#cardNO").val("");
	jQuery("#admList").combogrid("clear");
	var admListPanel = jQuery("#admList").combogrid("grid");
	admListPanel.datagrid('loadData', { total: 0, rows: [] });
	setListDefVal();
	jQuery("#patName").text("");
	jQuery("#patAge").text("");
	jQuery("#patSex").text("");
}

//��ʼ����ѯͷ���
function initTopPanel() {
	jQuery("#clear").linkbutton({
		 iconCls: 'icon-clear'
	});
	jQuery("#btnReadCard").linkbutton({
		iconCls: 'icon-readcard'
	});
	initAdmList();
	initChargeStatus();
	initCardType();
	setListDefVal();
	initTopPanelEvent();
}

function initTopPanelEvent() {
	//jQuery("#patientNO, #medicareNO").on("keydown", function(e) {findPatKeyDown(e)});
	jQuery("#patientNO").off("keydown").on("keydown", function(e) {findPatKeyDownPatNo(e)});
	jQuery("#medicareNO").off("keydown").on("keydown", function(e) {findPatKeyDownMedicare(e)});
	jQuery("#clear").on("click", clearClick);
	jQuery("#patDetBtn").off().on("click", function() {
		//��������ȫ����Ϣ
		if(GlobalObj.episodeId == "") {
			return false;
		}
		var tepisodeId = GlobalObj.episodeId
		if(jQuery("#admList[class='combogrid-f combo-f']").length) {
			tepisodeId = jQuery("#admList").combogrid("getValue");
		}
		var url = 'dhc.nurse.vue.mainentry.csp?ViewName=PatInfo?&FromIconProfile=1&EpisodeID=' + tepisodeId;
		websys_showModal({
			url: url,
			title: '���߻�����Ϣ',
			width: '70%',
			height: '70%',
			closed: true
		});
	});
	
	jQuery("#cardNO").off("keydown").on("keydown", {paramCardType:"cardTypeDR", paramCardNo:"cardNO", paramPatNo:"patientNO"}, cardKeyDownHandler);
}

//�������ѡ�
function addTabs() {
	initAddDepositTab();
	initRefDepositTab();
	initBillDetailTab();
	initHalfBillTab();
	initHalfBillByOrdTab();
	initDepDetailTab();
	initTarFeeTab();
	initOrdFeeTab();
	//Ĭ�ϲ����б�
	jQuery('#chargeTabs').tabs('select', 0);
}


//��ʼ�������б�
function initPatListPanel() {
	jQuery('#tPatList').datagrid({
		fit:true,
		//width: 'auto',
		//height: 300,	    //jQuery("#tt").tabs("options").height-200,               
		striped: true,  	//�Ƿ���ʾ������Ч��
		singleSelect : true,
		selectOnCheck: false,
		fitColumns: false,
		autoRowHeight: false,
		scrollbarSize: '10px',
		url: null,
		border: false,
		loadMsg: 'Loading...',
		pagination: false, //���Ϊtrue������DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		columns:[[  
			{title: '��������', field: 'admdate', halign: "center", width: 84},
			{title: '����ʱ��', field: 'admtime', halign: "center", width: 64},
			{title: '�ѱ�', field: 'instypedesc', halign: "center", width: 80},
			{title: '���Ҳ���', field: 'locward', halign: "center", width: 260},
			{title: '����', field: 'beddesc', halign:"center", width: 60},
			{title: 'Ԥ����',  field: 'deposit', align: "right", halign:"center", width: 100},
			{title: '�ܽ��', field: 'totalamount', align: "right", halign:"center", width: 100},
			{title: '�Ը����',  field: 'patientshare', align: "right", halign:"center", width: 100},
			{title: 'ҽ������', field: 'ybfee', align: "right", halign: "center", hidden: true},	//�����أ�������Ŀ�ٷſ�
			{title: '�ۿ۽��', field: 'discountamount', align: "right", halign: "center", width: 80},
			{title: '���˽��', field: 'payorshare', align: "right", halign: "center", width: 80},
			{title: 'סԺ״̬', field: 'dischargestatus', halign: "center", width: 80},
			{title: '�˵�״̬',  field: 'paidflag', halign: "center", width: 80},
			{title: '��Ժ����', field: 'dischargedate', halign: "center", width: 80},
			{title: '��Ժʱ��', field: 'dischargetime', halign: "center", width: 80},
			{title: '��Ժ������', field: 'admuser', halign: "center", width: 80},
			{title: 'סԺ����', field: 'zydays', align: "right", halign: "center", width:80},
			{title: '��Ժ������',  field: 'disuser', halign: "center", width:80},
			{title: '��ʿ��Ժ������', field: 'disdocname', halign: "center", width: 110},
			{title: '���״̬',  field: 'CodingFlag', halign: "center", width: 80},
			{title: '�������',  field: 'CodingUPDate', halign: "center", width: 80},
			{title: '���ʱ��',  field: 'CodingUPTime', halign: "center", width: 80},
			{title: '�����',  field: 'CodingUPUserDr', halign: "center", width: 80},
			{title: '���ԭ��',  field: 'CodingReason', halign: "center"},
			{title: '��Ʊ��', field: 'invno', halign: "center", width: 80},
			{title: '�����������', field: 'prtdate', halign: "center", width: 120},
			{title: '�������ʱ��',  field: 'prttime', halign: "center", width: 120},
			{title: '����״̬', field: 'visitstatus', halign: "center", hidden: true},
			{title: '�˵�ID', field: 'pbrowid', halign: "center", width: 80},
			{title: '�˵�״̬',  field: 'pbflag', halign: "center", hidden: true},
			{title: '�ѱ�ID', field: 'instypedr', halign: "center", hidden: true},
			{title: 'PAPMIRowID', field: 'patientid', halign: "center", hidden: true},
			{title: '��ƱID',  field: 'prtrowid', halign: "center", hidden: true},
			{title: '��Ʊ״̬', field: 'prtflag', halign: "center", width: 80},
			{title: '�����', field: 'episodeid', halign: "center", hidden: false, width: 80},
			{title: '�Ƿ�ת��', field: 'translocFlag', align: "center", halign:"center", hidden: false,width:80,
				formatter:function(value, row, index) {
					if(value == 'Y'){  //����ת�Ʊ�־  add zhangli  2017-08-03
						return "<a href='javascript:;' onclick=\"openCostInquriy('" + row.pbrowid + "', '" + row.episodeid + "')\">��</a>";
					}else {
						return '��';
					}
				}
			}
		]],
		rowStyler: function(index, row){
			if ((row.dischargestatus == "���ս���") || (row.dischargestatus == "��ʿ�����Ժ") || (row.dischargestatus == "�������õ���")){
				return 'color:#FF0000;';
			}
		},
		onBeforeLoad: function(data) {
			var admAry = getEpisodeIdOfPatList();
			var lockRtn = lockAdm("User.OEOrder", admAry, false);
		},
		onLoadSuccess: function(data) {
			DepositSelectObj.depositArray = [];  //���Ѻ������
			DepositSelectObj.loadFlag = false;
			ableElement("insuChargeBtn");
			ableElement("insuPreChargeBtn");
			ableElement("disChargeBtn");
			var bool = false;
			var episodeidAry = new Array();
			jQuery.each(data.rows, function (index, val) {
				if(bool){
					return false;
				};
				if(val.pbrowid==GlobalObj.billId){
					jQuery("#tPatList").datagrid("selectRow", index);
					bool = true;
				}
				var episodeid=val.episodeid;
				episodeidAry.push(episodeid);
			});
			//var lockRtn = lockAdm("User.OEOrder",episodeidAry,true);
			if(!bool) {
				var maxLen = data.rows.length;
				if(maxLen > 0){
					jQuery(this).datagrid("selectRow", 0);  //Ĭ��ѡ���һ��
					if(jQuery("#tool-btn-BillTool").length) {
						setFocus("tool-btn-BillTool");
					}else if(jQuery("#billBtn").length) {
						setFocus("billBtn");
					}
				}else {
					clearData();
				}
			}
		},
		onLoadError: function() {
			jQuery.messager.alert('����', '���ػ����б�ʧ��.');
		},
		onSelect: function(rowIndex, rowData) {
			DepositSelectObj.depositArray = []; //���Ѻ������
			DepositSelectObj.loadFlag = false;
			GlobalObj.initGlobalByData(rowData);
			initLedgerData();
			initPaymListData();
			initPatFeeInfo();
			initDepositData();
			onLoadSuccessPaym();

			//ͷ�˵���ֵ
			var frm = dhcsys_getmenuform();
			if (frm) {
				frm.EpisodeID.value = rowData.episodeid;
				frm.PatientID.value = rowData.patientid;
			}
			if(GlobalObj.billId == "") {
				return false;
			}
			var episodeidAry=new Array();
			var episodeid=rowData.episodeid;
			episodeidAry.push(episodeid);
			var lockRtn=lockAdm("User.OEOrder",episodeidAry,true);
			if(lockRtn){return false;}	//ѡ���Adm�Ѿ�������
			
			//����Ѿ�ҽ�����㣬�ѽ��㰴ť���
			var insuChargeFlag = checkInsuCharge();
			if(!insuChargeFlag) {
				disElement("insuChargeBtn");
				disElement("insuPreChargeBtn");
				ableElement("disChargeBtn", chargeClick);
				ableElement("cancelInsuBtn", cancelInsuChargeClick);
			}else {
				disElement("cancelInsuBtn");
				ableElement("insuChargeBtn", insuChargeClick);
				ableElement("insuPreChargeBtn", insuPreChargeClick);
				disElement("disChargeBtn");
			}
			
			//�ж��Ƿ��з�Ʊ
			var qualifStatus=getQualifStatus();
			var hasInv = checkInv();
			if ((!hasInv) && (qualifStatus == 0)) {
				jQuery.messager.alert('��ʾ', "��û�п��÷�Ʊ,���ܽ���.������������췢Ʊ.");
			}
		},
		onRowContextMenu: function(e, rowIndex, rowData) {
			e.preventDefault();
			//���ûѡ�У���ѡ��
			var row = jQuery(this).datagrid("getSelected");
			if(!row) {
				jQuery(this).datagrid("selectRow", rowIndex);
			}
			//����Ҽ��˵�
			var rtnMenuArr = getAuthMenu(SessionObj.group, "IPBILLRighty");
			if(typeof rtnMenuArr == "string") {
				rtnMenuArr = jQuery.parseJSON(rtnMenuArr);
			}
			
			if(rtnMenuArr != []) {
				try {
					createGridRightyKey(e, 'rightyKey', rtnMenuArr);
				}catch(ex) {
					jQuery.messager.alert("����", "�����Ҽ��˵�ʧ��");
				}
			}
			//�ж��ǲ�����ͬһ����¼���һ��������ˢ��֧����ʽ��Ѻ��
			if(rowData.pbrowid != GlobalObj.billId) {
				jQuery(this).datagrid("selectRow", rowIndex);
			}
		},
		onSortColumn: function(sort, order) {
			
		}
	});

	//��ʼ�������˵� �����Ҫ�����˵�����Ҫ��΢�޸�initToolMenu����
	//initChargeMenu();
	initToolMenu();
}

function getEpisodeIdOfPatList(){
	var episodeidAry=new Array();
	var rows = jQuery('#tPatList').datagrid('getRows')//��ȡ��ǰ��������
	for (var i = 0; i < rows.length; i++) {
		episodeidAry.push(rows[i]['episodeid']);
	}
	return episodeidAry;
}

//��ʼ��֧����ʽ
function initPaymListPanel() {
	jQuery('#tPaymList').datagrid({ 
		fit: true,
		toolbar: "#pmTool",
		checkOnSelect: false,  //�������� ����Ϊ������к�ѡ��checkbox,�����õĻ����checkbox��������Ӱ��
		selectOnCheck: false,  //�������� �������ó�false��Ŀ����Ϊ����ʾ��ʱ��ѡ���ϣ�����ɫΪ��ɫ�����ǻ�ɫ��ѡ��״̬
		striped: true,  	   //�Ƿ���ʾ������Ч��
		singleSelect: true,
		url: null,
		fitColumns: false,
		autoRowHeight: false,
		cache: false,
		border: false,
		loadMsg: 'Loading...',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		columns:[[
			{ title: '֧����ʽ', field: 'CTPMDesc', width: 160,
				editor: {
					type: 'combobox',
					formatter: function(row){
						var opts = jQuery(this).combobox('options');
						return row[opts.textField];
					},
					options:{
						valueField: 'caption',
						textField: 'caption',
						url: QUERY_URL.QUERY_COMBO_URL,
						required: false,
						editable: false,
						selectOnNavigation: true,
						multiple: false,
						onBeforeLoad:function(param){
							param.ClassName = "web.DHCIPBillCashier";
							param.QueryName = "ReadPMList";
							param.Arg1 = SessionObj.group;
							param.Arg2 = GlobalObj.prtId;
							param.ArgCnt = 2;
						},
						onLoadSuccess: function() {
							jQuery(this).combobox("showPanel");
						},
						onLoadError: function() {
							jQuery.messager.alert("����", "֧����ʽ�б���ش���");
						},
						onSelect: function(record, row) {
							//ѡ���Ժ�ʹdatagrid���ڲ��ɱ༭״̬
							if(editIndex != undefined) {
								var productname = jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMDesc'];
								var productValue = jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMRowID'];
								var comboValue = record.value;
								var ed = jQuery('#tPaymList').datagrid('getEditor', {
									index: editIndex,
									field: 'CTPMDesc'
								});
								if(ed){
									var productname = jQuery(ed.target).combobox('getText');
									//jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMDesc']['caption'] = productname;
								}
								//����datagrid�е�Ĭ����Ϣ
								var comboPmId = comboValue.split("^")[0];
								var comboPmCode = comboValue.split("^")[1];
								jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMDesc']['caption'] = productname;
								jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMCode'] = comboPmCode;
								jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMRowID'] = comboPmId;
								//jQuery("#tPaymList").datagrid("endEdit", editIndex);
								jQuery("#tPaymList").datagrid("endEditCell",{index:editIndex, field:"CTPMDesc"});
							}
						},
						onHidePanel: function() {
							if(editIndex != undefined) {
								//���ص�һ����ѡ�е��л����û��ѡ�е����򷵻�null��
								var focusCol = "CTPMAmt";
								//payMOnClickCell(editIndex, focusCol, "");
							}
						}
					}
				}
			},
			{ title: '���', field: 'CTPMAmt',width:120,align:'right',formatter:changeTwoDecimal_f,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2,
						onChange: function(newVal, oldVal) {
							//setNextRowAmt(newVal, oldVal);	
						}
					}
				}
			},
			{ title: '����',  field: 'CTPMBank',width:160,
				formatter:function(value){
					return value;
				},
				editor: {
					type:'combobox',
					options:{
						//valueField: 'value',
						valueField: 'caption',
						textField: 'caption',
						url: QUERY_URL.QUERY_COMBO_URL,
						required: false,
						editable: false,
						selectOnNavigation: true,
						multiple: false,
						onBeforeLoad: function(param){
							param.ClassName = "web.DHCBillOtherLB";
							param.QueryName = "QBankList";
						},
						onLoadSuccess: function() {
							jQuery(this).combobox("showPanel");
						},
						onLoadError: function() {
							jQuery.messager.alert("����", "�����б���ش���");
						},
						onSelect: function(record, row) {
							//ѡ���Ժ�ʹdatagrid���д��ڲ��ɱ༭״̬
							if(editIndex != undefined) {
								var ed = jQuery('#tPaymList').datagrid('getEditor', {
									index: editIndex,
									field: 'CTPMBank'
								});
								if(ed) {
									var productname = jQuery(ed.target).combobox('getText');
									jQuery('#tPaymList').datagrid('getRows')[editIndex]['caption'] = productname;
								}
							}
						},
						onHidePanel: function() {
							if(editIndex != undefined) {
								//���ص�һ����ѡ�е��л����û��ѡ�е����򷵻�null��
								var rowData = jQuery('#tPaymList').datagrid('selectRow', editIndex).datagrid('getSelected'); 
								var paymcode = rowData.CTPMCode;
								focusCol = "CTPMCheckno";
								payMOnClickCell(editIndex, focusCol, "");
							}
						}
					}
				}
			},
			{ title: '֧��',  field: 'CTPMBankSub', hidden: true
				/*���֧��ʱʹ��
				formatter: function(value,row) {
					return row.xxx;
				},
				editor: {
					type: 'combobox',
					options: {
						valueField: '',
						textField: '',
						url: QUERY_URL.QUERY_COMBO_URL,
						required: false,
						onBeforeLoad: function(param) {
							//param.ClassName = "";
							//param.QueryName = "";
						}
					}
				}
				*/
			},
			{title: '֧Ʊ/����', field: 'CTPMCheckno', width:160, editor:'text'},
			{title: '����', field: 'CTPMBankNo', hidden: true, width:160, editor:'numberbox'},
			{title: '֧����λ', field: 'CTPMUnit', width: 160, editor:'text'},
			{title: '�˻�', field: 'CTPMAcount', hidden: true, width:160, editor:'text'},
			{title: '֧����ʽCODE', field: 'CTPMCode', hidden: true},
			{title: 'ת��', field: 'pmck', width: 40, checkbox: true, hidden: true},
			{title: '֧����ʽID', field: 'CTPMRowID', hidden: true},
			{title: 'ybFlag', field: 'ybFlag', hidden: true},
			{title: 'fixedValue', field: 'fixedValue', hidden: true}
		]],
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			//����Ѿ�ҽ�����㣬�ڼ���ʱ��ҽ����Ϣ���ؽ�ȥ
			var ybInfo = getInsuChargeInfo();
			addGridInsuInfo(ybInfo);
			onLoadSuccessPaym();
		},
		onLoadError: function() {
			jQuery.messager.alert("����", "����֧����ʽ�б����.");
		},
		onClickCell: function(index, field, value) {
			if(GlobalObj.billId == "") {
				jQuery.messager.alert("��ʾ", "����ѡ���˵���˲���Ϊ��סԺ����.");
				return false;
			}
			//�༭ʱ δ�˵����ɱ༭ ��;����ĳ��� 14.11.15
			var hasClickBill = checkBillClick();
			if(!hasClickBill) {
				jQuery.messager.alert("��ʾ", "�����˵�.");
				return false;
			}
			var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
			var maxIndex = maxLen - 1;
			//ʧȥ�����¼�
			if(field == "CTPMAmt" || field == "CTPMCheckno" || field == "CTPMUnit") {
				clearPaymEvent();
				initPaymEvent();
			}
			//����ǽ�����ĵ�����������
			var billInfo = getBillBaseInfo();
			var billFlag = "";
			if(billInfo != "") {
				billFlag = billInfo.split("^")[15];
			}
			if(billFlag == "B") {
				payMOnClickCell(index, field, value);
			}
		},
		onSelect:function(index,rowData){
			
		},
		onBeforeEdit: function(index, rowData) {
			
		},
		onAfterEdit: function(index, rowData, changes) {
			editIndex = undefined;
			setBalance();
		}
	});
}

//��ʼ��̨����Ϣ
function initLedgerPanel() {
	jQuery("#tLedger").datagrid({
		fit: true,
		border: false,
		checkOnSelect: false, 
		selectOnCheck: false,
		striped: true,
		singleSelect: true,
		url: null,
		fitColumns: false,
		autoRowHeight: false,
		remoteSort: false,
		cache: false,
		loadMsg: 'Loading��',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		columns:[[  
			{ title: '����', field: 'TarDesc1',width: 80},
			{ title: '���', field: 'TarAmt1' ,width: 80, align: 'right', sortable: true, sorter: numberSort},
			{ title: '����', field: 'TarDesc2', hidden: true},
			{ title: '���', field: 'TarAmt2', width: 60, hidden: true, align: 'right'}
		]],
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			
		},
		onLoadError: function() {
			jQuery.messager.alert("����", "���ط����б����.");
		}
	});
}

function numberSort(a, b){
	var number1 = parseFloat(eval(a));  
	var number2 = parseFloat(eval(b));  
	return ((number1 > number2) ? 1 : -1);    
}

//��ʼ����ť�����
function initButtonPanel() {
	initChargeAmt();
	initChargeBtn();
}

//��ʼ��Ѻ�𴰿�
function initDepositWindow() {
	jQuery("#depositDetailPanel").window({    
		title: "Ѻ����ϸ",
		width: 600,
		height: 400,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		resizable: false,
		modal: true,
		onClose: function() {
			setDepositArray();
		}
	});
	initDepositData();
}

//��ʼ��Ѻ�����
function initDepositPanel() {
	jQuery("#tDepositList").datagrid({
		fit: true,
		checkOnSelect: false, //�������� ����Ϊ������к�ѡ��checkbox,�����õĻ����checkbox��������Ӱ��
		selectOnCheck: false, //�������� �������ó�false��Ŀ����Ϊ����ʾ��ʱ��ѡ���ϣ�����ɫΪ��ɫ�����ǻ�ɫ��ѡ��״̬
		striped: true,  	  //�Ƿ���ʾ������Ч��
		singleSelect: false,
		fitColumns: false,
		autoRowHeight: false,
		cache: false,
		loadMsg: '���ݼ����С���',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		url: null,
		columns:[[  
			{ title: 'ck', field: 'ck', checkbox: true},
			{ title: '���', field: 'TDepAmt', width: 80},
			{ title: 'Ѻ�𵥺�', field: 'TDepNO', width: 80},
			{ title: '֧����ʽ',  field: 'TDepPayM', width: 80},
			{ title: '�շ�����', field: 'TDepPrtDate', width: 80},
			{ title: '�շ�Ա', field: 'TUser', width: 80},
			{ title: '�����־', field: 'TBillFlag', hidden: true,
				formatter:function(value, row, index){
					return +value;
				}
			},
			{ title: 'Ѻ��״̬', field: 'TPrtStatus', width:60},
			{ title: 'TPayMRowid', field: 'TPayMRowid', hidden:true},
			{ title: 'TRcptRowid', field: 'TRcptRowid', hidden:true},
			{ title: 'TBankBackFlag', field: 'TBankBackFlag', hidden:true},
			{ title: 'TRefundNo',  field: 'TRefundNo', hidden:true},
			{ title: 'TPrtStatusFlag', field: 'TPrtStatusFlag', hidden:true},
			{ title: 'PAPMIRowID', field: 'patientid', hidden:true},
			{ title: 'TARRCPTDR',  field: 'TARRCPTDR', hidden:true}
		]],
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			//���سɹ�������ѡ��״̬
			jQuery("#depositDetailPanel input:checkbox").removeAttr('disabled'); //���checkbox״̬����Ҫ���ã������б����checkbox���ֲ��ɱ༭״̬
			var flag = DepositSelectObj.loadFlag;
			DepositSelectObj.autoSelectFlag = true;
			jQuery.each(data.rows, function (index,val) {
				if(flag){
					var depId = val.TPayMRowid;
					var isCheckin=checkDepInArr(depId);
					if(isCheckin){
						jQuery("#tDepositList").datagrid("checkRow", index);
					}
				}else{
					var billFlag=val.TBillFlag;
					if(+billFlag==1){
						jQuery("#tDepositList").datagrid("checkRow", index);
						if(!flag){
							DepositSelectObj.loadFlag=true;		//ֻ����һ��
						}
					}
				}
			});

			if(Config.dhcJfConfig.selYjPayFlag != "Y") {
				jQuery("#depositDetailPanel input:checkbox").attr("disabled", "disabled");
			}
			//��������ս����Ѻ��Ҳ����ѡ 14.11.15
			var patlistData = jQuery("#tPatList").datagrid("getSelected");
			if(!patlistData) {
				return false;
			}
			//if(patlistData.dischargestatus == "���ս���") {
			if ((patlistData.dischargestatus == "���ս���")||(patlistData.dischargestatus == "��ʿ�����Ժ")||(patlistData.dischargestatus == "�������õ���")){
				jQuery("#depositDetailPanel input:checkbox").attr("disabled", "disabled");
			}
			var billFlag = "";
			var billInfo = getBillBaseInfo();
			if(billInfo != "") {
				billFlag = billInfo.split("^")[15];
			}
			if(billFlag == "P") {
				jQuery("#depositDetailPanel input:checkbox").attr("disabled", "disabled");
			}
			//add 14.11.15 ��ʼ����ѡѺ��Ĭ�Ͻ��
			//��������û��У����Ѻ����Ϊ0�Ļ�����ѡѺ������ó���һ����Ѻ��Ĳ��˼�¼�Ľ�
			//changeDeposit(); //��ע�� 2015-3-18
			setDepositArray();
			DepositSelectObj.autoSelectFlag = false;
		},
		onLoadError: function() {
			jQuery.messager.alert("����", "����Ѻ���б����.");
		},
		onCheckAll: function(rows) {
			var pmStr = "";
			jQuery.each(rows, function(index, value) {
				var rowData = rows[index];
				var canCheck = canDepositCheck(rowData.TBillFlag);
				if(!canCheck) {
					var myIndex = index + 1;
					var str = myIndex + rowData.TDepPayM;
					if(pmStr == "") {
						pmStr = str;
					} else {
						pmStr = pmStr + "," + str;
					}
					jQuery("#tDepositList").datagrid("uncheckRow", index);
				}
			});
			if(pmStr != "") {
				jQuery.messager.alert("Ѻ���б�", pmStr + " : ����ѡ,��ȷ�ϸ�֧����ʽ�Ƿ�Ǯ�ѵ���.");
			}
			changeDeposit();
		},
		onUncheckAll: function(rows) {
			changeDeposit();
		},
		onCheck: function(index,rowData) {
			var canCheck = canDepositCheck(rowData.TBillFlag);
			if(!canCheck) {
				jQuery.messager.alert("Ѻ���б�", "�����ѡ,��ȷ�ϸñ�Ǯ�Ƿ��ѵ���.");
				jQuery("#tDepositList").datagrid("uncheckRow", index);
				return false;
			} else {
				changeDeposit();
			}
		},
		onUncheck: function(index, rowData) {
			changeDeposit();
		}
	});
}

//��ʼ�������б�����
function initPatListData() {
	var queryParams = new Object();
	var ClassName = "web.DHCIPBillCashier";
	var QueryName = "searchbill";    //"searchBillByAdm";
	var chargeStatus = "";
	if(jQuery("#chargeStatus[class='combobox-f combo-f']").length) {
		chargeStatus = jQuery("#chargeStatus").combobox("getValue");
	}
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = "";
	queryParams.Arg2 = "";
	queryParams.Arg3 = "";
	queryParams.Arg4 = "";
	queryParams.Arg5 = "";
	queryParams.Arg6 = "";
	queryParams.Arg7 = "";
	queryParams.Arg8 = "";
	queryParams.Arg9 = "";
	queryParams.Arg10 = "";
	queryParams.Arg11 = "";
	queryParams.Arg12 = GlobalObj.episodeId;
	queryParams.Arg13 = chargeStatus;
	queryParams.Arg14 = SessionObj.guser + "^" + SessionObj.group + "^" + SessionObj.ctLoc + "^" + SessionObj.hospital;
	queryParams.ArgCnt = 14;
	loadDataGridStore("tPatList",queryParams);
}

//��ʼ��֧����ʽ�б�����
function initPaymListData() {
	jQuery("#tipAmt").html("");
	var queryParams = new Object();
	var ClassName = "web.DHCIPBillCashier";
	var QueryName = "ReadPMSequence";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = SessionObj.guser;
	queryParams.Arg2 = SessionObj.group;
	queryParams.Arg3 = GlobalObj.prtId;
	queryParams.Arg4 = GlobalObj.billId;
	queryParams.ArgCnt = 4;
	loadDataGridStore("tPaymList",queryParams);	
}

//��ʼ��Ѻ���б�����
function initDepositData() {
	var queryParams = new Object();
	var ClassName = "web.DHCIPBillCashier";
	var QueryName = "depositlist";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = GlobalObj.episodeId;
	queryParams.Arg2 = GlobalObj.billId;
	queryParams.ArgCnt = 2;
	loadDataGridStore("tDepositList", queryParams);
}

//��ʼ��̨���б�����
function initLedgerData() {
	var queryParams = new Object();
	var ClassName = "web.DHCIPBillCashier";
	var QueryName = "getLedger";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = GlobalObj.billId;
	queryParams.ArgCnt = 1;
	loadDataGridStore("tLedger", queryParams);
}

//�����������ݱ��
function initAdmList() {
	jQuery("#admList").combogrid({
		fit: true,
		panelWidth: 450,
		border: false,
		checkOnSelect: false, 
		selectOnCheck: false,
		striped: true,
		singleSelect: true,
		url: null,
		fitColumns: false,
		autoRowHeight: false,
		cache: false,
		editable: false,
		loadMsg: '���ݼ����С���', 
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    idField: 'TadmId',
	    textField: 'TadmLoc',
	    columns:[[    
	        {field: 'TadmId', title:'ID', width: 60},
	        {field: 'TadmDate', title:'����ʱ��', width: 140},    
	        {field: 'TadmLoc', title:'�������', width: 120},    
	        {field: 'TadmWard', title:'���ﲡ��', width: 120},
	       	{field: 'TdisDate', title:'��Ժʱ��', width: 120}
	    ]],
	    onLoadSuccess:function(data) {
	    	
	    },
	    onLoadError:function() {
	    	jQuery.messager.alert("����", "���ؾ����б�ʧ��");
	    },
	    onSelect: function(rowIndex, rowData) {
	    	GlobalObj.clearGlobal();
	    	clearData();
	    	setCurrentAdm();
	    	initPatListData();
	    }
	});
}

//��ʼ�����˾����б�
function initAdmListData() {
	var queryParams = new Object();
	var ClassName = "web.DHCIPBillCashier";
	var QueryName = "searchAdm";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = GlobalObj.patientId;
	queryParams.ArgCnt = 1;
	loadComboGridStore("admList", queryParams);
}

//����״̬������
function initChargeStatus() {
	jQuery("#chargeStatus").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField: 'id',
    	url: null,   
    	textField: 'text',
		data: [{
			id: '',
			text: 'ȫ��'
		},{
			id: 'billed',
			text: 'δ����'
		},{
			id: 'discharge',
			text: '���ս���'
		},{
			id: 'paid',
			text: '������ʷ'
		},{
			id: 'toBill',
			text: '����Ժ'
		}],
		onSelect: function(record) {
			GlobalObj.clearGlobal();
			clearData();
			setCurrentAdm();
			initPatListData();
		}
	});
}

//��ʼ��������
function initCardType() {
	//�����ͳ�ʼ��
	jQuery('#cardTypeDR').combobox({
		panelHeight: 80,
		url: QUERY_URL.QUERY_COMBO_URL,
		editable: false,
		multiple: false,
		mode: "remote",
		method: "GET",  //ʹ��POST����ʱ��ϳ�
		selectOnNavigation: true,
		valueField: 'value',    
		textField: 'caption',
		onShowPanel:function(){
			//var url = './dhcbill.query.combo.easyui.csp';    
			//jQuery('#comboCardTypeDR').combobox('reload', url);   
		},
		onBeforeLoad:function(param){
			param.ClassName = "web.DHCBillOtherLB";
			param.QueryName = "QCardTypeDefineList";
		},
		onSelect: function(record) { //14.11.12
			//ѡ��ʱ���ö�����ť���� �����Ƿ�ɶ�
			var recVal = record.value;
			initReadCard(recVal);
		},
		onLoadSuccess:function() { ////14.11.12
			//��ʼ��ʱ���ö�����ť���� �����Ƿ�ɶ�
			var recVal = jQuery(this).combobox("getValue");
			initReadCard(recVal);
		}
	});
}

///����Ӧ�ա�Ӧ�˽��
function calcReceivable(newValue, oldValue){
	var selDepAmt = jQuery("#selDepAmt").numberbox("getValue");
	var patShareAmt = jQuery("#patShareAmt").numberbox("getValue");
	var patInsuAmt = jQuery("#patInsuAmt").numberbox("getValue");
	//Ӧ��/Ӧ�˿� = �Ը� - ҽ��֧�� - Ѻ��
	var amt = parseFloat(patShareAmt) - parseFloat(patInsuAmt) - parseFloat(selDepAmt);	
	jQuery("#patStAmt").numberbox("setValue", amt);
	if(amt < 0){
		//Ӧ��
		jQuery("#TAmt").numberbox("setValue", (0-amt));
		jQuery("#SAmt").numberbox("setValue", 0);
	}else{
		//Ӧ��
		jQuery("#SAmt").numberbox("setValue", amt);
		jQuery("#TAmt").numberbox("setValue", 0);
	}
	//
}

//��ʼ��������
function initChargeAmt() {
	jQuery("#totleAmt,#totleDeposit,#selDepAmt,#patPaidAmt,#patShareAmt,#recOrBackMoney,#patPayorAmt,#disCountAmt,#patStAmt,#patInsuAmt,#SAmt,#TAmt").numberbox({
		 precision: 2,
		 formatter: changeTwoDecimal_f,
		 onChange: calcReceivable
	}).css({
		"height": "28px",
		"width":"140px",
		"text-align" : "right",
		"font-weight": "bold",
		"color": "black",
		"font-size": "18px"
	});
	jQuery("#TAmt").css({color:"red"});
	jQuery("#currentInv").validatebox().css({
		"height": "28px",
		"width":"140px",
		"text-align" : "right",
		"font-weight": "bold",
		"color": "black",
		"font-size": "18px"
	});;
	
	jQuery("#totleAmt,#totleDeposit,#selDepAmt,#patShareAmt,#patPayorAmt,#disCountAmt,#currentInv,#patStAmt,#patInsuAmt,#SAmt,#TAmt").attr({
		"readonly": true
	});
	
	jQuery("#depDetailBtn").on("click", function() {
		initDepositWindow();
	});
	jQuery("#patPaidAmt").on("keydown", function(e) {
		var e = e || window.event;
		if (e.keyCode == 13) {
			calReturnAmt();
		}
	});
	
	//Ӧ�����¼�
	jQuery("#tipAmt").off("click").on("click", function(e) {
		setColumnVal();
	});
}

function changeTwoDecimal_f(x) {
    var f_x = parseFloat(x);
    if (isNaN(f_x)) {
        return "";
    }
    var f_x = Math.round(x * 100) / 100;
    var s_x = f_x.toString();
    var pos_decimal = s_x.indexOf('.');
    if (pos_decimal < 0) {
        pos_decimal = s_x.length;
        s_x += '.';
    }
    while (s_x.length <= pos_decimal + 2) {
        s_x += '0';
    }
    return s_x;
}

//��ʼ����ť
function initChargeBtn() {
	jQuery("#insuChargeBtn, #disChargeBtn, #cancelChargeBtn, #cancelInsuBtn, #insuPreChargeBtn").keyup(function(e) {
		var array = ["insuChargeBtn", "disChargeBtn", "cancelChargeBtn", "cancelInsuBtn", "insuPreChargeBtn"];
		buttonKeyUp(e, this, array);
	});
}

//�ǼǺŲ����Żس��¼�
function findPatKeyDown(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		getPatInfo();
	}
}

//�ǼǺŻس��¼�
function findPatKeyDownPatNo(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		jQuery("#medicareNO").val("");
		getPatInfo();
	}
}

//�����Żس��¼�
function findPatKeyDownMedicare(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		jQuery("#patientNO").val("");
		getPatInfo();
	}
}

function getPatInfo() {
	var patNo = jQuery("#patientNO").val();
	var medicare = jQuery("#medicareNO").val();
	if ((patNo != "") || (medicare != "")) {
		if(m_Adm) {m_Adm = "";}
		var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getpatcurradm", "setpat_val", "", patNo, medicare);
	}else if(m_Adm != "") {
		var rtn = tkMakeServerCall("web.DHCIPBillCashier", "GetAdmInfo", "setpat_val", "", m_Adm);
		m_Adm = "";
	}
}

function setpat_val(value) {
	if(value == "") {
		jQuery.messager.alert("����", "û�иò�����Ϣ");
		return;
	}
   	var val = value.split("^");
   	var myPatNo = val[0];
   	var myPatName = val[1];
	var myVisitStatus = val[8];
	var myAdmId = val[2];	
	if(myVisitStatus == "C"){
		myAdmId = "";
	}
   	var myMedicare = val[6];
	var myPapmiId = val[14];
	
	if(myAdmId == "") {
		setBaseInfoByPapmi(myPapmiId, myAdmId);
	}else {
		setBaseInfo(myAdmId, "", "");
	}
	//ȫ�ֱ�����ֵ
	GlobalObj.initGlobal(myPapmiId, myAdmId, "", "");
   	initAdmListData();
	initPatListData();
	setCurrAdmList();
	var tab = jQuery('#chargeTabs').tabs('getSelected');
	var tabIndex = jQuery('#chargeTabs').tabs('getTabIndex', tab);
	if(tabIndex != 0) {
		jQuery("#chargeTabs").tabs("select", 0);
	}
}

//���ò��˻�����Ϣ
function setBaseInfo(admId, billId, prtId) {
	var info = tkMakeServerCall("web.DHCIPBillCashier", "GetPatInfo", admId, billId, prtId);
	var patInfoStr = info.split("$");
	var patInfo = patInfoStr[0].split("^");
	var myPatName = patInfo[1];
	var myPatNo = patInfo[0];
	var myMedicare = patInfo[2];
	var mySex = patInfo[4];
	var myAge = patInfo[6];
	jQuery("#patientNO").val(myPatNo);
   	jQuery("#medicareNO").val(myMedicare);
   	jQuery("#patName").text(myPatName);
   	jQuery("#patAge").text(myAge);
   	jQuery("#patSex").text(mySex);
}

function setBaseInfoByPapmi(papmi, admId) {
	var info = tkMakeServerCall("web.DHCIPBillCashier", "getPatBaseInfo", papmi, admId);
	var patInfoStr = info.split("$");
	var patInfo = patInfoStr[0].split("^");
	var myPatName = patInfo[1];
	var myPatNo = patInfo[0];
	var myMedicare = patInfo[2];
	var mySex = patInfo[4];
	var myAge = patInfo[6];
	jQuery("#patientNO").val(myPatNo);
   	jQuery("#medicareNO").val(myMedicare);
   	jQuery("#patName").text(myPatName);
   	jQuery("#patAge").text(myAge);
   	jQuery("#patSex").text(mySex);
}

//���ý����Ϣ
function initPatFeeInfo() {
	var rtn = tkMakeServerCall("web.DHCIPBillCashier", "GetPatInfo", GlobalObj.episodeId, GlobalObj.billId, GlobalObj.prtId);
	var rtnArr = rtn.split("$");
	var patInfoStr = rtnArr[0];
	var admInfoStr = rtnArr[1];
	var feeInfoStr = rtnArr[2];
	var feeInfoArr = feeInfoStr.split("^");

	var deposit = feeInfoArr[0], totalAmt = feeInfoArr[1], shareAmt = feeInfoArr[2], discAmt = feeInfoArr[3];
	var payorAmt = feeInfoArr[4], stAmt = feeInfoArr[5], ysAmt = feeInfoArr[6], ytAmt = feeInfoArr[7];
	var ybAmt = feeInfoArr[8], zfAmt = feeInfoArr[9], yeAmt = feeInfoArr[10];
	var depInfo = getDepositInfo();
	var allDepAmt = depInfo.split("^")[0];
	var avaiDepAmt = depInfo.split("^")[1];
	
	jQuery("#totleDeposit").numberbox("setValue", allDepAmt);
	jQuery("#totleAmt").numberbox("setValue", totalAmt);
	jQuery("#selDepAmt").numberbox("setValue", avaiDepAmt);
	jQuery("#patShareAmt").numberbox("setValue", shareAmt);
	jQuery("#patPayorAmt").numberbox("setValue", payorAmt);
	jQuery("#disCountAmt").numberbox("setValue", discAmt);
	jQuery("#patInsuAmt").numberbox("setValue", ybAmt);
	jQuery("#patStAmt").numberbox("setValue", stAmt);
}

//���������Ϣ
function clearPatFeeInfo() {
	jQuery("#totleDeposit").numberbox("setValue", 0);
	jQuery("#totleAmt").numberbox("setValue", 0);
	jQuery("#selDepAmt").numberbox("setValue", 0);
	jQuery("#patShareAmt").numberbox("setValue", 0);
	jQuery("#patPayorAmt").numberbox("setValue", 0);
	jQuery("#disCountAmt").numberbox("setValue", 0);
	jQuery("#patInsuAmt").numberbox("setValue", 0);
	jQuery("#patStAmt").numberbox("setValue", 0);
	jQuery("#patPaidAmt").numberbox("setValue", "");
	jQuery("#recOrBackMoney").numberbox("setValue", "");
	checkInv();     //����Ĭ�Ϸ�Ʊ��
	jQuery("#currentInvId").val("");
}

//���ҽ�����
function addGridInsuInfo(ybInfo) {
	if(!ybInfo) {
		return;
	}
	var tmpAry = ybInfo.split("|");
	if (tmpAry[0] != 0){
		disElement("disChargeBtn");	   //ҽ�����㲻�ɹ���"��Ժ����"��ť���
		return;
	}
	var CH2 = String.fromCharCode(2);
	//1,�����ж�ҳ�����Ƿ��Ѿ�����ҽ��Ҫ��ӵ�֧����ʽ
	//2,����иı�ԭ����ֵ��û�еĻ������
	var myIndex = 0;
	var myInsuAmt = 0;
	var insuChargeFlag = true;
	var insuPmErrStr = '';
	var insuPmLen = ybInfo.split(CH2).length;
	for (var i = 1; i <= insuPmLen - 1; i++) {
		var pmId = ybInfo.split(CH2)[i].split("^")[0];
		var pmAmt = ybInfo.split(CH2)[i].split("^")[1];
		var checkInfo = checkPmExist(pmId);          //�ж�ҳ�����Ƿ��Ѿ�����ҽ��Ҫ��ӵ�֧����ʽ
		var checkFlag = checkInfo.split("^")[0];     
		var checkAmt = checkInfo.split("^")[1];
		var checkIndex = checkInfo.split("^")[2];
		var checkYbFlag = checkInfo.split("^")[3];    //�Ƿ�ҽ��֧����ʶ
		if ((checkFlag == '1') && (checkYbFlag == 'Y')) {
			return;
		} else {
			//��ȡcode��desc
			var pmInfo = tkMakeServerCall("web.DHCIPBillCashier", "getPaymInfo", pmId);
			var pmInfoArr = pmInfo.split("^");
			var pmFlag = pmInfoArr[0];
			var pmCode = pmInfoArr[1];
			var pmDesc = pmInfoArr[2];
			if (pmFlag != 0) {
				insuChargeFlag = false;
				insuPmErrStr = (insuPmErrStr == "") ? pmId : (insuPmErrStr + "," + pmId);
				continue;
			}
			jQuery('#tPaymList').datagrid('insertRow', {
				index: 0,	//������0��ʼ
				row: {
					CTPMRowID: pmId,
					CTPMAmt: pmAmt,
					CTPMCode: pmCode,
					CTPMDesc: pmDesc,
					CTPMAcount: '',
					CTPMBank: '',
					CTPMBankSub: '',
					CTPMBankNo: '',
					CTPMUnit: '',
					CTPMCheckno: '',
					transFlag: 'N',
					ybFlag: 'Y'
				}
			});
			myIndex++;
			pmAmt = parseFloat(pmAmt);
			myInsuAmt = myInsuAmt + pmAmt;
		}
	}
	//����ҽ�����
	myInsuAmt = parseFloat(myInsuAmt).toFixed(FIXEDNUM);
	jQuery("#patInsuAmt").numberbox("setValue", myInsuAmt);
	//�ı�Ĭ�Ͻ���ֵ��ƽ�����ֵ(֧����ʽ)
	onLoadSuccessPaym();

	if(!insuChargeFlag) {
		jQuery.messager.alert("Error", "ҽ������֧����ʽ" + insuPmErrStr + "��HISϵͳ�в����ڣ�����ϵ��Ϣ�ƣ�");
		return false;
	}
	return true;
}

//�ж�ĳ��֧����ʽ��֧����ʽ�б����Ƿ����
//������ʱ�Ľ�Index
function checkPmExist(pmId) {
	var pmFlag = 0;
	var myPmAmt = 0;
	var myIndex = 0;
	var ybFlag = '';
	var allPaymRow = jQuery("#tPaymList").datagrid("getRows");
	jQuery.each(allPaymRow, function(index, value) {
		var rowData = allPaymRow[index];
		var paymAmt = rowData['CTPMAmt'];
		var myPmId = rowData['CTPMRowID'];
		var myYbFlag = rowData['ybFlag'];
		if (myPmId == pmId) {
			pmFlag = 1;
			ybFlag = myYbFlag;
			myPmAmt = paymAmt;
			if (jQuery.trim(myPmAmt) == "") {
				myPmAmt = 0;
			}
			myIndex = index;
			return true;
		}
	});
	var rtn = pmFlag + "^" + myPmAmt + "^" + myIndex + "^" + ybFlag;
	return rtn;
}

//ɾ��ҽ��֧����ʽ
function delGridInsuInfo() {
	var insuIndexArr = new Array();
	var allRows = jQuery("#tPaymList").datagrid("getRows");  //������
	jQuery.each(allRows, function(index, value) {
		var rowData = allRows[index];
		if(rowData['ybFlag'] == "Y") {
			insuIndexArr.push(rowData);
		}
	});
	var insuLen = insuIndexArr.length;
	for(var i = 0; i < insuLen; i++) {
		var row = insuIndexArr[i];
		var thisIndex = jQuery("#tPaymList").datagrid("getRowIndex", row);
		jQuery("#tPaymList").datagrid("deleteRow", thisIndex);
	}
	//�ı�Ĭ�Ͻ���ֵ��ƽ�����ֵ(֧����ʽ)
	onLoadSuccessPaym();
}

//�����ѯ��ť�¼�
function searchClick() {
	jQuery("#chargeSearchPanel").window({    
		title: "��������ѯ",
		width:840,  
		height:520,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		draggable:false,
		onOpen: function() {
			initSearchPanel();
			initSearchEvent();
			//+2017-05-25 ZhYW ��ʼ��Panel���������
			initPatListDataBySearch();
		},
		onClose: function() {
		}
	});
}

//����
function clearClick() {
	GlobalObj.clearGlobal();
	clearTopInfo();
	initPatListData();
	clearData();
	setFocus("patientNO");
}

//��ȡ�����б���ĵ�ǰ����
function setCurrentAdm() {
	var episodeId = "";
	if(jQuery("#admList[class='combogrid-f combo-f']").length) {
		episodeId = jQuery("#admList").combogrid("getValue");
	}
	GlobalObj.initGlobal(GlobalObj.patientId, episodeId, GlobalObj.billId, GlobalObj.prtId);
	setBaseInfo(episodeId, "", "");
}

//���õ�ǰĬ�������б�
function setCurrAdmList() {
	if(jQuery("#admList[class='combogrid-f combo-f']").length) {
		var currAdm = GlobalObj.episodeId;
		jQuery("#admList").combogrid("setValue", currAdm);
	}
}

//����ƽ����
function setBalance() {
	//�ı�ƽ�����ֵ��֧����ʽ��
	var balanceAmt = getStAmt();
	balanceAmt = parseFloat(balanceAmt);
	var pmAll = getPaymAll();
	pmAll = parseFloat(pmAll);
	var pmBalance = balanceAmt - pmAll;
	pmBalance = parseFloat(pmBalance).toFixed(FIXEDNUM);
	GlobalObj.initBalance(pmBalance);
	jQuery("#tipBalance").html(pmBalance);
	if(pmBalance != 0) {
		jQuery("#tipBalance").css("color", "red");
	}else {
		jQuery("#tipBalance").css("color", "black");
	}
}

//���ñ�����
function setTipAmt() {
	if(editIndex != undefined) {
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:editIndex,field:"CTPMAmt"});
		if(ed) {
			var thisRowObj = jQuery('#tPaymList').datagrid('getSelected');
			var thisVal = thisRowObj.CTPMAmt;
			thisVal = Number(thisVal);
			var balanceAmt = GlobalObj.balance;
			balanceAmt = Number(balanceAmt);
			if(!isNaN(thisVal) && !isNaN(balanceAmt)) {
				//������ʾtip������ע�ͣ���ɾ
				var tipVal = thisVal + balanceAmt;
				tipVal = parseFloat(tipVal).toFixed(2);
				jQuery("input.datagrid-editable-input.numberbox-f.validatebox-text").addClass('easyui-tooltip').attr('title', tipVal);
				jQuery("#tipAmt").html(tipVal);
			}
		}
	}else {
		jQuery("#tipAmt").html("");
	}	
}

//ȡĬ��֧����ʽ����
function getDefPaymSum() {
	var deposit = jQuery("#selDepAmt").numberbox("getValue"); //��ѡѺ��
	var patShare = jQuery("#patShareAmt").numberbox("getValue");  //�Ը����
	var paymAll = getPaymAll();

	if(deposit === "") {
		deposit = 0;
	}
	if(patShare === "") {
		patShare = 0;
	}
	if(paymAll === "") {
		paymAll = 0;
	}
	deposit = parseFloat(deposit);
	patShare = parseFloat(patShare);
	paymAll = parseFloat(paymAll);
	
	var balanceAmt = patShare - deposit- paymAll;
	balanceAmt = parseFloat(balanceAmt).toFixed(FIXEDNUM);
	GlobalObj.initBalance(balanceAmt);

	return balanceAmt;
}



//֧����ʽ�б���سɹ���
function onLoadSuccessPaym() {
	var data = jQuery("#tPaymList").datagrid("getData");
	var defPaymStr = getDefPaym();
	var defPaymArr = defPaymStr.split("^");
	var defPaymDr = defPaymArr[0];
	var defPaymDesc = defPaymArr[1];
	var defAmt = getDefPaymSum();  //ȡĬ��Ӧ������
	var admReasonDetStr = getAdmReason();
	var admReasonId = admReasonDetStr[0];
	var admReasonNationalCode = admReasonDetStr[1];
	var billInfo = getBillBaseInfo();
	var billFlag = billInfo.split("^")[15];
	/*
	if(admReasonNationalCode > 0 && billFlag != "P") {
		defAmt = "";
	}
	*/
	jQuery.each(data.rows, function(index, value) {
		var rowData = data.rows[index];
		var rowPmDr = rowData['CTPMRowID'];
		var rowAmt = rowData['CTPMAmt'];
		if(rowPmDr == defPaymDr && billFlag != "P") {
			//�жϵ�ǰĬ��֧����ʽ�Ƿ���ֵ�������ֵĬ��+��ֵ
			rowAmt = Number(rowAmt).toFixed(FIXEDNUM);
			defAmt = Number(defAmt).toFixed(FIXEDNUM);
			defAmt = defAmt + rowAmt;
			defAmt = defAmt.toFixed(FIXEDNUM);
			if(GlobalObj.billId == "") {
				defAmt = "";
			}
			jQuery("#tPaymList").datagrid("updateRow", {
				index: index,
				row: {
					CTPMAmt: defAmt
				}
			});
		}
	});
	//�ı�ƽ�����ֵ��֧����ʽ��
	setBalance();
}

//ʧȥ�����¼�
function onPaymBlur() {
	//ȡ���¼� ��Ȼ�����ѭ���ݹ�
	//clearPaymEvent();
	if(editIndex != undefined) {
		//jQuery("#tPaymList").datagrid("endEdit", editIndex);
		//editIndex = undefined;
	}
}

//keyup�¼�
function onPaymKeyDown(e) {
	e = e || window.event;
	if(e.keyCode == 189) {  //numberbox���������������ţ���ԭ��ֵΪ����ʱ���һ��
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:editIndex,field:"CTPMAmt"});
		if(ed) {
			jQuery(ed.target).numberbox("setValue", "-");
		}
	}

	if(e.keyCode == 13) {
		clearPaymEvent();
		if(editIndex != undefined) {
			/*
			//����б����Ĭ�ϵ����б�����
			var thisRow = jQuery("#tPaymList").datagrid("getSelected");
			var thisRowPaymId = thisRow.CTPMRowID;
			var thisRowPaymAmt = thisRow.CTPMAmt;
			var reqFlag = IsPaymRequired(thisRowPaymId);
			if(reqFlag != "0" && thisRowPaymAmt != "" && thisRowPaymAmt != 0) {
				payMOnClickCell(editIndex, "CTPMBank", "");
				initPaymEvent();
				return false;
			}
			*/
			//û�б����Ĭ�ϵ���һ�еĽ��
			var nextIndex = editIndex + 1;
			var ed = jQuery('#tPaymList').datagrid('getEditor', {index:editIndex,field:"CTPMAmt"});
			if(ed) {
				//������jQuery2 ��IE11 �س�ͨ��nuberbox("getValue")��ȡ����ֵ
				var setedVal = jQuery(ed.target).get(0).value;
				jQuery(ed.target).numberbox("setValue",setedVal);
			}
			jQuery("#tPaymList").datagrid("endEdit", editIndex);
			editIndex = undefined;
			jQuery("#tPaymList").datagrid("selectRow", nextIndex);
			var nextRow = jQuery("#tPaymList").datagrid("getSelected");
			var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
			var maxIndex = maxLen - 1;
			if((nextRow != null) && (nextRow.CTPMAmt != undefined) && (nextIndex <= maxIndex)) {
				editIndex = nextIndex;
				payMOnClickCell(editIndex, "CTPMAmt", "");
				initPaymEvent();
			}else {
				setFocus("patPaidAmt");
			}
		}
	}
}

//֧����ʽ�б��е������ڱ༭״̬�ĵ�Ԫ��endEdit
function endEditAllPaym() {
	//14.11.21 ���жϣ���ֹ����
	if(jQuery("#tPaymList").length > 0) {
		var allPaymRow = jQuery("#tPaymList").datagrid("getRows");
		jQuery.each(allPaymRow, function(index, value) {
			jQuery("#tPaymList").datagrid("endEdit", index);	
		});
	}
}

//��ȡ���˽��
function getStAmt() {
	var ckDeposit = jQuery("#selDepAmt").numberbox("getValue");
	var totAmt = jQuery("#totleAmt").numberbox("getValue");
	var patShare = jQuery("#patShareAmt").numberbox("getValue");
	var disAmt = jQuery("#disCountAmt").numberbox("getValue");
	var payorAmt = jQuery("#patPayorAmt").numberbox("getValue");

	ckDeposit = Number(ckDeposit);
	totAmt = Number(totAmt);
	disAmt = Number(disAmt);
	payorAmt = Number(payorAmt);
	var stAmt = totAmt - ckDeposit - disAmt - payorAmt;
	stAmt = stAmt.toFixed(FIXEDNUM);
	
	return stAmt;
}

//��ȡ��ǰ����֧����ʽ�ĺ�
function getPaymAll() {
	var paymAll = 0;
	var allRows = jQuery("#tPaymList").datagrid("getRows");  //������
	jQuery.each(allRows, function(index, value) {
		var rowData = allRows[index];
		if(rowData['CTPMAmt'] == "" || rowData['CTPMAmt'] == 0 || rowData['CTPMAmt'] == undefined) {
			return true;
		}
		var paymAmt = rowData['CTPMAmt'];
		paymAmt = parseFloat(paymAmt);
		paymAll = paymAll + paymAmt;
	});
	paymAll = parseFloat(paymAll).toFixed(FIXEDNUM);
	return paymAll;
}

/*
*������ͷ�ͽ�β��ֵ
*beginIndex:��ʼ������endIndex:��������;
*inArr:���������飻outArr:����������
*/
function getSelPaymAmt(selObj) {
	var beginIndex = selObj.beginIndex;
	var endIndex = selObj.endIndex;
	var inArr = selObj.inArr;
	var outArr = selObj.outArr;

	var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
	var maxIndex = maxLen - 1;

	if(beginIndex == "" || beginIndex == undefined) {
		beginIndex = 0;
	}
	if(endIndex == "" || endIndex == undefined) {
		endIndex = maxIndex;
	}
	if(!jQuery.isArray(inArr)) {
		inArr = [];
	}
	if(!jQuery.isArray(outArr)) {
		outArr = [];
	}

	var paymAll = 0;
	for(var i = beginIndex; i <= endIndex; i++) {
		var amt = 0;
		var edAmt = jQuery('#tPaymList').datagrid('getEditor', {index:i, field:"CTPMAmt"});
		if(edAmt) {
			amt = jQuery(edAmt.target).numberbox("getValue");
		}else {
			amt = jQuery('#tPaymList').datagrid('getRows')[i]['CTPMAmt'];
		}
		
		if(amt == "" || amt == 0 || amt == undefined) {
			continue;
		}
		
		if(((inArr.length > 0)&& (jQuery.inArray(i, inArr) == "-1")) || ((outArr.length > 0) && (jQuery.inArray(i, outArr) >= 0))) {
			continue;
		}
		
		amt = parseFloat(amt);
		paymAll = paymAll + amt;
	}

	paymAll = parseFloat(paymAll).toFixed(FIXEDNUM);

	return paymAll;
}

//��ȡ�����ֽ��
function getStCashAmt() {
	var cashAmt = 0;
	var allPaymRow = jQuery("#tPaymList").datagrid("getRows");
	jQuery.each(allPaymRow, function(index, value) {
		var rowData = allPaymRow[index];
		var paymAmt = rowData['CTPMAmt'];
		var paymDr = rowData['CTPMRowID'];
		var paymCode = rowData['CTPMCode'];
		var ybFlag = rowData['ybFlag'];
		if(paymAmt == "" || paymAmt == 0 || paymAmt == null || paymAmt == undefined) {
			return true;
		}
		if(ybFlag == "Y") {
			return true;
		}
		if(paymCode != "CASH") {
			return true;
		}
		paymAmt = parseFloat(paymAmt);
		cashAmt = cashAmt + paymAmt;
	})
	cashAmt = parseFloat(cashAmt).toFixed(FIXEDNUM);
	return cashAmt;
}

//�������˽��
function calReturnAmt() {
	var pmCash = getStCashAmt();
	var amt = jQuery("#patPaidAmt").val(); //numberbox("getValue");
	if(amt == "") {
		amt = 0;
	}
	amt = parseFloat(amt).toFixed(FIXEDNUM);
	var myBalance = amt - pmCash;
	myBalance = parseFloat(myBalance).toFixed(FIXEDNUM);
	jQuery("#recOrBackMoney").numberbox("setValue", myBalance);
}

//�жϽ���λ�ã��ǳ�Ժ���㻹��ҽ������
function setChargeFocus() {
	var fous = 1;
	if(focus) {
		setFocus("insuChargeBtn");
	}else {
		setFocus("disChargeBtn");
	}
}

//�ж�δ����Ѻ���Ƿ��ѡ
function canDepositCheck(flag) {
	if(flag == 0) {
		return false;
	}else {
		return true;
	}
}

//�ı�Ѻ��ʱ���������
function changeDeposit() {
	//�ı�Ѻ���б�ʱ
	
	//1 ������ѡ���
	//2 ���֧����ʽ�б�
	//3 �ı�Ĭ��֧����ʽ���
	//4 ͬʱ���²��˻�����Ϣ���Ӧ��Ӧ��
	
	//1 ȡ��ѡѺ��
	if(jQuery("#selDepAmt").length) {
		var ckDep = getCheckDepositSum();
		jQuery("#selDepAmt").numberbox("setValue", ckDep);
	}
	//2 ���֧����ʽ�б��ֵ
	if(DepositSelectObj.autoSelectFlag === false) {
		clearLeftRow(0);
		onLoadSuccessPaym();
	}

	//3 ȡѡ�е�Ѻ����ı�Ӧ��Ӧ��
	var balanceAmt = getStAmt();
	balanceAmt = parseFloat(balanceAmt).toFixed(FIXEDNUM);

	//4 �ı�ƽ�����ֵ��֧����ʽ��
	var pmAll = getPaymAll();
	pmAll = parseFloat(pmAll);
	var pmBalance = balanceAmt - pmAll;
	pmBalance = parseFloat(pmBalance).toFixed(FIXEDNUM);
	GlobalObj.initBalance(pmBalance);
	
	//���ñ�����
	setTipAmt();
	var hasClickBill = checkBillClick();
	if(hasClickBill && DepositSelectObj.autoSelectFlag === false) {
		setPaymListFocus();
	}
}

//�ı�Ѻ��ʱ���������
function changeDepositOld() {
	//�ı�Ѻ���б�ʱ
	//1,�ı�ƽ�����ֵ��֧����ʽ��
	//2,ͬʱ���²��˻�����Ϣ���Ӧ��Ӧ��
	//3,������ѡ���
	
	//1 ȡѡ�е�Ѻ����ı�Ӧ��Ӧ��
	var balanceAmt = getStAmt();
	balanceAmt = parseFloat(balanceAmt).toFixed(FIXEDNUM);

	//2 �ı�ƽ�����ֵ��֧����ʽ��
	var pmAll = getPaymAll();
	pmAll = parseFloat(pmAll);
	var pmBalance = balanceAmt - pmAll;
	pmBalance = parseFloat(pmBalance).toFixed(FIXEDNUM);
	GlobalObj.initBalance(pmBalance);
	
	//ȡ��ѡѺ��
	if(jQuery("#selDepAmt").length) {
		var ckDep = getCheckDepositSum();
		jQuery("#selDepAmt").numberbox("setValue", ckDep);
	}
	
	setBalance();
	//���ñ�����
	setTipAmt();
}

//��ȡѡ���Ѻ����
function getCheckDepositSum() {
	var depositSum = 0;
	if(jQuery("#tDepositList").length) {
		var allCheckRow = jQuery("#tDepositList").datagrid("getChecked");
		jQuery.each(allCheckRow, function(index, value) {
			var rowData = allCheckRow[index];
			var depAmt = rowData.TDepAmt;
			depAmt = parseFloat(depAmt);
			depositSum = depositSum + depAmt;
		});
	}
	depositSum = depositSum.toFixed(FIXEDNUM);
	return depositSum;
}

//����ѡ���Ѻ������
function setDepositArray() {
	DepositSelectObj.depositArray = [];
	var depStr = "";
	var depositSum = 0;
	if(jQuery("#tDepositList").length) {
		var allCheckRow = jQuery("#tDepositList").datagrid("getChecked");
		jQuery.each(allCheckRow, function(index, value) {
			var rowData = allCheckRow[index];
			var depId = rowData.TPayMRowid;
			DepositSelectObj.depositArray.push(depId);
		});
	}
}

//��ȡѺ��ID�Ƿ����
function checkDepInArr(depId) {
	var depositArray=DepositSelectObj.depositArray;
	if(jQuery.isArray(depositArray) && jQuery.inArray(depId, depositArray) != -1) {
		return true;
	}
	return false;
}

//�ж��Ƿ��˵�
function checkBillClick() {
	
	return true; //Lid 2018-03-27 ��������Ҫ��,������ǼǺź�,��ѯ��������Ϣʱ,ֱ���˵�,����ÿ�ε������ʱ���˵�,�����շ�Ա����
	
	//add 14.11.15 �ж��Ƿ�����;����ģ���;����Ĳ���Ҫ�˵�
	var billFlag = "";
	var billInfo = getBillBaseInfo();
	if(billInfo != "") {
		billFlag = billInfo.split("^")[15];
	}

	var billNum = getBillNum();
	if(billNum == 1) {
		if(clickBillFlag == undefined) {
			return false;
		}
		if(GlobalObj.episodeId != clickBillFlag && billFlag != "P") {
			return false;
		} else {
			return true;
		}
	} else {
		return true;		
	}
	
}

//֧����ʽblur�¼���keydown�¼�
function initPaymEvent() {
	//jQuery("#layoutPaym").delegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text","blur", onPaymBlur);
	//jQuery("#layoutPaym").delegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown", function(e){onPaymKeyDown(e)});
	jQuery("#layoutPaym").delegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text","blur", onPaymBlur);
	jQuery("#layoutPaym").delegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown", function(e){onPaymKeyDown(e)});
	jQuery("#layoutPaym").delegate("[field='CTPMCheckno'] [class='datagrid-editable-input']", "blur", onPaymBlur);
	jQuery("#layoutPaym").delegate("[field='CTPMUnit'] [class='datagrid-editable-input']", "blur", onPaymBlur);
}

//���֧����ʽblur��keydown�¼�
function clearPaymEvent() {
	//jQuery("#layoutPaym").undelegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text","blur");
	//jQuery("#layoutPaym").undelegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown");
	jQuery("#layoutPaym").undelegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text", "blur");
	jQuery("#layoutPaym").undelegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown");
	jQuery("#layoutPaym").undelegate("[field='CTPMCheckno'] [class='datagrid-editable-input']", "blur");
	jQuery("#layoutPaym").undelegate("[field='CTPMUnit'] [class='datagrid-editable-input']", "blur");
}

//����֧����ʽ��Ԫ��
function payMOnClickCell(index, field,value) {
	var isEdit = isCellAllowedEdit(index, field, value);
	if(!isEdit)return;
	if (endEditing()){
		jQuery('#tPaymList').datagrid('selectRow', index)
				.datagrid('editCell', {index:index,field:field});
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:index,field:field});
		if(ed) {
			jQuery(ed.target).focus();
			jQuery(ed.target).select();
			var thisRowObj = jQuery('#tPaymList').datagrid('getSelected');
			var thisVal = thisRowObj.CTPMAmt;
			thisVal = Number(thisVal);
			var balanceAmt = GlobalObj.balance;
			balanceAmt = Number(balanceAmt);
			if(!isNaN(thisVal) && !isNaN(balanceAmt) && field == "CTPMAmt") {
				//������ʾtip������ע�ͣ���ɾ
				var tipVal = thisVal + balanceAmt;
				tipVal = parseFloat(tipVal).toFixed(2);
				jQuery("input.datagrid-editable-input.numberbox-f.validatebox-text").addClass('easyui-tooltip').attr('title', tipVal);
				jQuery("#tipAmt").html(tipVal);
			}
			jQuery(ed.target).bind("blur",editCellOnBlur);
		}
		editIndex = index;
	}
}

function editCellOnBlur(){
	//jQuery('#tPaymList').datagrid('endEdit', editIndex);
	//editIndex = undefined;
}

//��Ԫ���Ƿ�ɱ༭
function isCellAllowedEdit(index, field, value) {
	var bool = true;	//Ĭ���ܱ༭
	var rowData = jQuery('#tPaymList').datagrid('selectRow',index).datagrid('getSelected'); //���ص�һ����ѡ�е��л����û��ѡ�е����򷵻�null��
	var paymcode = rowData.CTPMCode;
	var ybFlag = rowData.ybFlag;
	var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
	var maxIndex = maxLen - 1;
	//ҽ��֧����ʽ���ܱ༭
	if(ybFlag != undefined && ybFlag == 'Y'){
		bool = false;	
	}
	if(GlobalObj.billId == "") {
		return false;
	}
	//������ ֧����ʽ���ܱ༭
	var flag = IsPaymRequired(rowData.CTPMRowID);
	if(flag == 0) {
		if(field != "CTPMAmt" && field != "CTPMDesc"){
			bool = false;
		}
	}
	return bool;
}

function endEditing(){
	if (editIndex == undefined){return true}
	if (jQuery('#tPaymList').datagrid('validateRow', editIndex)){
		var ed = jQuery('#tPaymList').datagrid('getEditor', {
			index:editIndex,
			field:'CTPMBank'
		});

		if(ed){
			var productname = jQuery(ed.target).combobox('getText');
			jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMBank']['caption'] = productname;
		}

		jQuery('#tPaymList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
	
}

//���ݿ����͸�ʽ������ ����д������js��
//paramCardType��paramCardNo,paramPatNo�������Ԫ�ص�ID
//������Ԫ��ID,����Ԫ��ID,�ǼǺ�Ԫ��ID
function cardKeyDownHandler(event) {
	//try {
		var e = event || window.event;
		var paramCardType = e.data.paramCardType;
		var paramCardNo = e.data.paramCardNo;
		var paramPatNo = e.data.paramPatNo;
		var cardTypeVal = "";
		var cardTypeDr = "";
		var cardNoFormat = "";
		if(e.keyCode == 13) {
			cardNoFormat = formatCardNo(paramCardType, paramCardNo);
			if(jQuery("#" + paramCardType + "[class='combobox-f combo-f']").length) {
				cardTypeVal = jQuery("#" + paramCardType).combobox("getValue");
			} else {
				cardTypeVal = jQuery("#" + paramCardType).val();
			}
			var cardNo = jQuery("#" + paramCardNo).val();

			if(cardNo == "" || cardNo == undefined) {
				return;
			}
			if((cardTypeVal != "") && (cardTypeVal.split("^").length > 16)) {
				cardTypeDr = cardTypeVal.split("^")[0];
			}
			if(cardNo != "") {
				var myrtn = DHCACC_GetAccInfo(cardTypeDr, cardNoFormat, "", "PatInfo");
				if (myrtn == -200) {
	   				alert("����Ч!");
	   				return;
				}
				//var myrtn = DHCACC_GetAccInfo(CardTypeRowId,CardNo,"");
				var myary = myrtn.split("^");
				var rtn = myary[0];				
				switch(rtn) {
					case "0": 
						jQuery("#" + paramPatNo).val(myary[5]);
						jQuery("#" + paramCardNo).val(myary[1]);
						getPatInfo();
						break; 
					case "-200": 
						//jQuery.messager.alert("����Ч", "����Ч");
						//return;
						alert("����Ч");
						break;
					case "-201": 
						jQuery("#" + paramPatNo).val(myary[5]);
						jQuery("#" + paramCardNo).val(myary[1]);
						getPatInfo();
						break;
					default:
				}
			}  
		}
	//}catch(e) {

	//}
}

function formatCardNo(paramCardType, paramCardNo){
	var cardNo = jQuery("#" + paramCardNo).val();
	if(cardNo != "") {
		var cardNoLen = getCardNoLength(paramCardType);
		if((cardNoLen != 0) && (cardNo.length < cardNoLen)) {
			var defLen = (cardNoLen - cardNo.length) - 1;
			for (var i = defLen; i >= 0; i--) {
				cardNo = "0" + cardNo;
			}
		}
	}
	return cardNo;
}

function getCardNoLength(paramCardType){
	var cardNoLen = 0;
	var cardTypeVal = "";
	if(jQuery("#" + paramCardType + "[class='combobox-f combo-f']").length) {
		cardTypeVal = jQuery("#" + paramCardType).combobox("getValue");
	} else {
		cardTypeVal = jQuery("#" + paramCardType).val();
	}
	if(cardTypeVal != "")  {
		var cardTypeArr = cardTypeVal.split("^");
		if(cardTypeArr.length > 17) {
			cardNoLen = cardTypeArr[17];
		}  
	}

	return cardNoLen;
}

/**
*����DataGrid����
*/
function loadDataGridStore(DataGridID, queryParams){
	window.setTimeout(function(){
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			url : QUERY_URL.QUERY_GRID_URL,
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}

/**
*����ComboGrid����
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// ��ȡ���ݱ�����
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;
	grid.datagrid('load', queryParams);
}

//��ȡ��Ȩ�˵�JSON
function getAuthMenu(group, menuPar) {
	var rtnMenuArr = tkMakeServerCall("web.UDHCJFBILLMENU", "getSubListToJson", menuPar, group);
	return rtnMenuArr;
}

/**
*�����Ҽ��˵�
*/
function createGridRightyKey(event, target, menuBtnArr) {
	//û����Ȩ�˵� ������
	if(menuBtnArr.length == 0) {
		return;
	}
	var $target = jQuery('#' + target);
	if(!jQuery("#" + target).length) {
		if(!$target.length) {
			$target = jQuery('<div id=\"' + target + '\"></div>').appendTo(document.body);
			$target.menu();
			jQuery.each(menuBtnArr, function(index, value) {
				var menu = menuBtnArr[index];
				$target.menu('appendItem', {
					id: menu.code,
					text: menu.desc,
					disabled: false,  //ƽ̨�ӿ�
					style: {
						visible: false,
						hidden: true,
						hide: true
					}
				});
			});
		}
	}
	$target.menu('show', {
		left: event.pageX,
		top: event.pageY
	});
}

/**
*��ʼ�������˵�
*/
function initChargeMenu() {
	var menuBtnArr = getAuthMenu(SessionObj.group, "IPBILLDownBox");
	if(typeof menuBtnArr == "string") {
		menuBtnArr = jQuery.parseJSON(menuBtnArr);
	}
	if(menuBtnArr != []) {
		try {
			createGridTool('tPatList', 'patListTool', menuBtnArr);
		}catch(ex) {
			jQuery.messager.alert("����", "���������˵�ʧ��");
		}
	}
}

function createGridTool(target, toolbar, menuBtnArr) {
	var toolbarDiv = "";
	if(!jQuery("#" + toolbar).length) {
		toolbarDiv = '<div id=\"' + toolbar + '\" style=\"height:auto;\"><div>';
		jQuery('#' + target).append(toolbarDiv);
	}
	var myInside = "";
	jQuery.each(menuBtnArr, function(index, value) {
		var listBtnArr =  menuBtnArr[index];
		var id = listBtnArr.id;
		var code = listBtnArr.code;
		var desc = listBtnArr.desc;
		var menuBtnId = 'menu-btn-' + code;
		var listBtnId = 'list-btn-' + code;																							//ƽ̨�ӿ�
		var menuBtnDiv = '<a id=\"' + menuBtnId + '\" href=\"javascript:void(0)\" style=\"float:left\" class=\"easyui-menubutton\" data-options=\"disabled:false' + ',menu: \'#' + listBtnId + '\'\" onmouseover=\"mouseoverTool(\'' + id + '\', \'' + code + '\');\">' + desc + '</a><div id=\"'+ listBtnId + '\" style=\"width:120px;\"></div>';
		myInside += menuBtnDiv;
	});
	jQuery('#' + toolbar).append(myInside);
	jQuery.parser.parse('#' + target);
	jQuery('#' + target).datagrid({
		toolbar: '#' + toolbar
	});
}

function mouseoverTool(id, code) {
	var listBtnId = 'list-btn-' + code;
	var menuBtnArr = tkMakeServerCall('web.UDHCJFBILLMENU', 'getSubListToJson', code, SessionObj.group);
	if(typeof menuBtnArr == "string") {
		menuBtnArr = jQuery.parseJSON(menuBtnArr)
	}
	jQuery.each(menuBtnArr, function(index, value) {
		var menu = menuBtnArr[index];
		var menuId = 'menu-' + code + '-' + menu.code;
		if(!jQuery('#' + menuId).length) {
			jQuery('#' + listBtnId).menu('appendItem', {
				id: menuId,
				text: menu.desc,
				name: menu.code,
				disabled: false //ƽ̨�ӿ�
			});
		}
	});
}

//���߲˵�
function initToolMenu() {
	var patListTool = "patListTool";
	var menuBtnArr = getAuthMenu(SessionObj.group, "IPBILLTool");
	if(typeof menuBtnArr == "string") {
		menuBtnArr = jQuery.parseJSON(menuBtnArr);
	}
	if(menuBtnArr != []) {
		try {
			//createToolMenu('tPatList', patListTool, menuBtnArr);
			jQuery('#tPatList').datagrid({
				toolbar: menuBtnArr
			});
		}catch(ex) {
			jQuery.messager.alert("����", "�������߲˵�ʧ�ܣ�"+ex.message);
		}
	}
}

function createToolMenu(target, toolbar, menuBtnArr) {
	var toolbarDiv = "";
	if(!jQuery("#" + toolbar).length) {
		toolbarDiv = '<div id=\"' + toolbar + '\" style=\"height:auto;\"><div>';
		jQuery('#' + target).append(toolbarDiv);
	}
	var tableHtml = '<div class="datagrid-toolbar"><table cellspacing="0" cellpadding="0" style="float:left"><tbody><tr></tr></tbody></table></div>';
	jQuery("#" + toolbar).append(tableHtml);

	var myInside = "";
	jQuery.each(menuBtnArr, function(index, value) {
		var listBtnArr =  menuBtnArr[index];
		var id = listBtnArr.id;
		var code = listBtnArr.code;
		var desc = listBtnArr.desc;
		var menuBtnId = 'tool-btn-' + code;
		var iconCls = listBtnArr.iconCls;
		var myHtml = '<a href="javascript:void(0)" class="l-btn l-btn-plain" group="" id=' + menuBtnId + '><span class="l-btn-left"><span class="l-btn-text ' + iconCls + ' l-btn-icon-left">' + desc + '</span></span></a>';
		jQuery("#" + toolbar + " table tbody tr").append("<td>" + myHtml + "</td>");
	});

	jQuery.parser.parse('#' + target);
	jQuery('#' + target).datagrid({
		toolbar: '#' + toolbar
	});
}

function createToolMenuOld(target, toolbar, menuBtnArr) {
	var toolbarDiv = "";
	if(!jQuery("#" + toolbar).length) {
		toolbarDiv = '<div id=\"' + toolbar + '\" style=\"height:auto;\"><div>';
		jQuery('#' + target).append(toolbarDiv);
	}
	
	var myInside = "";
	jQuery.each(menuBtnArr, function(index, value) {
		var listBtnArr =  menuBtnArr[index];
		var id = listBtnArr.id;
		var code = listBtnArr.code;
		var desc = listBtnArr.desc;
		var menuBtnId = 'tool-btn-' + code;
		var iconCls = 'icon-add';
		var menuBtnDiv = '<a id=\"' + menuBtnId + '\" href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"disabled:false,iconCls:\'' + iconCls + '\'\">' + desc + '</a>';
		myInside += menuBtnDiv;
	});
	myInside = "<span>" + myInside + "</span>"
	jQuery('#' + toolbar).append(myInside);
	toolbarDiv = jQuery("#" + toolbar).html();
	jQuery('#' + target).append(toolbarDiv);
	jQuery.parser.parse('#' + target);
	jQuery('#' + target).datagrid({
		toolbar: '#' + toolbar
	});
}

//����Ĭ��������ֵ
function setListDefVal(id) {
	if(id == "" || id == undefined) {
		id = '';
	}
	jQuery('#chargeStatus').combobox('setValue', id);
}

//����Ĭ�Ͻ���
function setFocus(id) {
	if(jQuery("#" + id).length) {
		jQuery("#" + id).focus();
	}
}

//���� 14.11.12
function readCardClick() {
	var recVal = jQuery("#cardTypeDR").combobox("getValue");
	if(recVal == "") {
		return;
	}

	var recValArr = recVal.split("^");
	var cardTypeDR = recValArr[0];
	var myrtn = DHCACC_GetAccInfo(cardTypeDR,recVal);
	if(myrtn == "-200") {
		jQuery.messager.alert("����", "��Ч����δ�忨");
		return;
	}

	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn){
		case "0":
			jQuery("#patientNO").val(myary[5]);
			jQuery("#cardNO").val(myary[1]);
			getPatInfo();
			break;
		case "-200":
			alert("����Ч");
			break;
		case "-201":
			jQuery("#patientNO").val(myary[5]);
			jQuery("#cardNO").val(myary[1]);
			getPatInfo();		
			break;
		default:
	}
}

//��ʼ��������ʱ���źͶ�����ť�ı仯 14.11.12
function initReadCard(recVal) {
	var recValArr = recVal.split("^");
	if(recValArr.length	> 16 && recValArr[16] == "Handle") {
		disElement("btnReadCard");
		jQuery("#cardNO").attr("readOnly", false);
	} else {
		jQuery('#btnReadCard').on("click",readCardClick);
		jQuery('#btnReadCard').css("color", "");
		jQuery("#cardNO").val("");
		jQuery("#cardNO").attr("readOnly", true);
	}	
}

//���ư�ť���� 14.11.12
function disElement(argName) {
	var arg = jQuery("#" + argName);
	var tagName = arg[0].tagName.toLowerCase();
	if(tagName == "a") {
		arg.css({
			color: "#C0C0C0"
		});
		arg.off("click").on("click", function() {
			return false; 
		})
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "button") {
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "input") {
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "select") {
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "") {
		
	} else {
		
	}
}

//���ư�ť���� 14.11.12
function ableElement(argName, fun) {
	var arg = jQuery("#" + argName);
	var tagName = arg[0].tagName.toLowerCase();
	if(tagName == "a") {
		arg.css({
			color: ""
		});
		if(typeof fun == "function") {
			arg.off("click").on("click", fun);
		}

		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "button") {
		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "input") {
		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "select") {
		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "") {
		
	} else {
		
	}
}

//���㰴ť���� ��ť�¼�
function buttonKeyUp(e, obj, array) {
	var e = e || window.event;
	var id = obj.id;

	if(jQuery.isArray(array)) {
		var index = jQuery.inArray(id, array);
		if(index != -1) {
			
		}
	}

	if (e.keyCode == 38) {
		if(jQuery.isArray(array)) {
			var index = jQuery.inArray(id, array);
			if(index != -1 && index != 0) {
				setFocus(array[index - 1]);
			}
		}
	}
	if (e.keyCode == 40) {
		if(jQuery.isArray(array)) {
			var index = jQuery.inArray(id, array);
			if(index != -1 && index != (array.length -1)) {
				setFocus(array[index + 1]);
			}
		}
	}
}

//datagrid key control
jQuery.extend(jQuery.fn.datagrid.methods, {
    keyCtr : function (jq) {
        return jq.each(function () {
            var grid = jQuery(this);
            grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
                switch (e.keyCode) {
                case 38: // up
                    var selected = grid.datagrid('getSelected');
                    if (selected) {
                        var index = grid.datagrid('getRowIndex', selected);
                        grid.datagrid('selectRow', index - 1);
                    } else {
                        var rows = grid.datagrid('getRows');
                        grid.datagrid('selectRow', rows.length - 1);
                    }
                    break;
                case 40: // down
                    var selected = grid.datagrid('getSelected');
                    if (selected) {
                        var index = grid.datagrid('getRowIndex', selected);
                        grid.datagrid('selectRow', index + 1);
                    } else {
                        grid.datagrid('selectRow', 0);
                    }
                    break;
                }
            });
        });
    }
});

//����Ĭ�ϵ�֧����ʽ�б�Ľ���
function setPaymListFocus() {
	clearPaymEvent();
	var defPaymStr = getDefPaym();
	var defPaymArr = defPaymStr.split("^");
	var defPaymDr = defPaymArr[0];
	var defPaymDesc = defPaymArr[1];
	var billInfo = getBillBaseInfo();
	var billFlag = "";
	if(billInfo != "") {
		billFlag = billInfo.split("^")[15];
	}
	if(billFlag == "P" || billFlag == "") {
		return false;
	}
	
	var editIndex = jQuery("#tPaymList").datagrid("selectRecord", defPaymDr).datagrid("getRowIndex");
	initPaymEvent();
	payMOnClickCell(editIndex, "CTPMAmt", "");
}

//����֧����ʽ��һ�еĽ��
function setNextRowAmt(newVal,oldVal) {
	var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
	var maxIndex = maxLen - 1;
	var row = jQuery("#tPaymList").datagrid("getSelected");
	var editIndex = jQuery("#tPaymList").datagrid("getRowIndex", row);
	var nextRowIndex=+editIndex+1;
	
	var paymAll = 0;
	paymAll = getSelPaymAmt({
		beginIndex: "",
		endIndex: "",
		inArr: [],
		outArr: [editIndex]
	});

	paymAll = parseFloat(paymAll).toFixed(FIXEDNUM);
	tmp=paymAll+newVal;
	var stAmt=jQuery("#patStAmt").numberbox("getValue");
	if(+tmp==+stAmt){
		return false;
	}
	if(editIndex>=0  && nextRowIndex<=maxIndex) {
		clearLeftRow(nextRowIndex);
		
		var pmAmt = 0;
		pmAmt = getSelPaymAmt({
			beginIndex: 0,
			endIndex: editIndex,
			inArr: [],
			outArr: []
		});

		var stAmt=jQuery("#patStAmt").numberbox("getValue");
		var lastRowAmt = parseFloat(stAmt-pmAmt).toFixed(FIXEDNUM);
		if(pmAmt == stAmt){
			
		}else{
			var ed = jQuery('#tPaymList').datagrid('getEditor', {index:nextRowIndex, field:"CTPMAmt"});
			if(ed) {
				jQuery(ed.target).numberbox("setValue", lastRowAmt);
			}else {
				//jQuery('#tPaymList').datagrid('getRows')[nextRowIndex]['CTPMAmt'] = (stAmt-pmAmt);
				jQuery('#tPaymList').datagrid('updateRow', {
					index: nextRowIndex,
					row: {
						CTPMAmt: lastRowAmt
					}
				});
			}
		}
	}
	setBalance();
}

//��ȡ�༭������Ƿ��Ѿ�����
function clearLeftRow(index) {
	var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
	for(var i=index; i<maxLen; i++) {
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:i, field:"CTPMAmt"});
		if(ed) {
			jQuery(ed.target).numberbox("setValue", "");
		}else {
			jQuery('#tPaymList').datagrid('updateRow', {
				index: i,
				row: {
					CTPMAmt: ''
				}
			});
		}
	}
	setBalance();
}

//���Ӧ����ʱ �Զ���䵽���ڱ༭�ĵ�Ԫ��
function setColumnVal() {
	var tipAmt = jQuery("#tipAmt").html();
	if((editIndex != undefined) && (tipAmt != 0)) {
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:editIndex, field:"CTPMAmt"});
		if(ed) {
			jQuery(ed.target).numberbox("setValue", tipAmt);
		}else {
			//jQuery('#tPaymList').datagrid('getRows')[editIndex]['CTPMAmt'] = tipAmt;
			jQuery('#tPaymList').datagrid('updateRow', {
				index: editIndex,
				row: {
					CTPMAmt: tipAmt
				}
			});
		}
	}
}


//��չ������Ԫ��
jQuery.extend(jQuery.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = jQuery(this).datagrid('options');
			var fields = jQuery(this).datagrid('getColumnFields',true).concat(jQuery(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			jQuery(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	},
	endEditCell : function(jq,param){
		return jq.each(function(){
			var thisCellEditor = null;
			var opts = jQuery(this).datagrid('options');
			var fields = jQuery(this).datagrid('getColumnFields',true).concat(jQuery(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				log(col.editor)
				if (fields[i] == param.field){
					thisCellEditor = col.editor;
					col.editor = null;
					break;
				}
			}

			jQuery(this).datagrid('endEdit', param.index);

			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				if (fields[i] == param.field){
					col.editor = thisCellEditor;
					break;
				}
			}
		});
	}
});

//��ʼ��Tab����¼�
function initTabsEvent() {
	jQuery("#chargeTabs").tabs({
		onSelect: function(title,index) {
			var tabPanel = jQuery("#chargeTabs").tabs("getTab", index);
			var billId = jQuery.trim(GlobalObj.billId);
			var episodeId = jQuery.trim(GlobalObj.episodeId);
			var panelID = "";

			if(tabPanel) {
				var opts = tabPanel.panel("options");
				panelID = opts.id;
			}
			if(panelID == "patListTab") {
				initPatListData();
			}
			if(panelID == "addDepositTab" || panelID == "refDepositTab") {
				if(episodeId == "") {
					jQuery.messager.alert("��Ѻ��", "��ѡ����");
					jQuery(this).tabs('select', 0);
					return false;
				}

				if(panelID == "addDepositTab") {
					initAddDepositTab();
				}
				if(panelID == "refDepositTab") {
					initRefDepositTab();
				}
			}
			if(panelID == "billDetailTab") {
				if(billId == "") {
					jQuery.messager.alert("�����嵥", "��ѡ����!!");
					jQuery(this).tabs('select', 0);
					return false;
				}

				initBillDetailTab();
			}
			if(panelID == "halfBillTab") {
				if(billId == "") {
					jQuery.messager.alert("��;����", "�˵�Ϊ��,���������˵�.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var billInfo = getBillBaseInfo();
				if(billInfo == "") {
					jQuery.messager.alert("��;����", "�˵���Ϣ��ȡʧ��.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var billFlag = billInfo.split("^")[15];
				if(billFlag == "P") {
					jQuery.messager.alert("��;����", "���˵��Ѿ�����,���ܲ���˵�.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				//�ж�ҽ�������Ƿ��ܹ���;����
				var canHarfForInsu = canHarfBillForInsu();
				if(!canHarfForInsu) {
					jQuery.messager.alert("��;����", "�û���Ϊҽ������,������;����.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var num = getBillNum();
				num = parseInt(num);
				if(num > 1) {
					jQuery.messager.alert("��;����", "�����ж��δ���˵�,���������˵�.");
					jQuery(this).tabs('select', 0);
					return false;
				}else if(num == 1) {
					//��;���㴰��
					//�ж��Ƿ���tab��û�еĻ��������еĻ���
					var billedFlag = billClick();
					initHalfBillTab();
				} else if(num == 0) {
					jQuery.messager.alert("��;����", "����û��δ���˵�.");
					return false;
				} else {
					jQuery.messager.alert("��;����", "����ֵ��" + num);
					return false;
				}
			}

			if(panelID == "halfBillByOrdTab") {
				if(billId == "") {
					jQuery.messager.alert("����˵�", '�˲���û���˵�,���ܲ���˵�');
					jQuery(this).tabs('select', 0);
					return false;
				}
				var billInfo = getBillBaseInfo();
				var billFlag = "";
				if(billInfo == "") {
					jQuery.messager.alert("����˵�", "�˵���Ϣ��ȡʧ��.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				billFlag = billInfo.split("^")[15];
				if(billFlag == "P") {
					jQuery.messager.alert("����˵�", '���˵��Ѿ�����,���ܲ���˵�');
					jQuery(this).tabs('select', 0);
					return false;
				}
				//�ж�ҽ�������Ƿ��ܹ���;����
				var canHarfForInsu = canHarfBillForInsu();
				if(!canHarfForInsu) {
					jQuery.messager.alert("����˵�", "�û���Ϊҽ������,������;����.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var num = getBillNum();
				num = parseInt(num);
				if(num > 1) {
					jQuery.messager.alert("����˵�", "�����ж��δ�����˵����������˵�.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				//�ж��Ƿ���tab��û�еĻ��������еĻ���
				initHalfBillByOrdTab();
			}
			if(panelID == "searchDepDet") {
				if (episodeId == "") { //((billId == "") || (episodeId == "")) {
					jQuery.messager.alert("Ѻ����ϸ", "����Ϊ�գ�");
					jQuery(this).tabs('select', 0);
					return false;
				}
				initDepDetailTab();
			}
			if(panelID == "searchTarFee") {
				if (billId == "") {
					jQuery.messager.alert("�շ���Ŀ", "�˵���Ϊ�գ�");
					jQuery(this).tabs('select', 0);
					return false;
				}

				initTarFeeTab();
			}
			if(panelID == "searchOrdFee") {
				if (billId == "") {
					jQuery.messager.alert("ҽ������", "�˵���Ϊ�գ�");
					jQuery(this).tabs('select', 0);
					return false;
				}

				initOrdFeeTab();
			}
			if(panelID == "admOrderFee") {
				if(episodeId == "") {
					jQuery.messager.alert("ҽ������", "����Ϊ�գ���ѡ����");
					jQuery(this).tabs('select', 0);
					return false;
				}
				initAdmOrderFeeTab();
			}
		}
	});
}

//��Ѻ��Tab
function initAddDepositTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + GlobalObj.episodeId + '&deposittype=' + '' + '&TabLinkFlag=' + 'Y';
	addOneTab("chargeTabs", "addDepositTab", "��Ѻ��", url);
}

//��Ѻ��
function initRefDepositTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFRefundDeposit&Adm=' + GlobalObj.episodeId + '&TabLinkFlag=' + 'Y';
	addOneTab("chargeTabs", "refDepositTab", "��Ѻ��", url);
}

//���˷�����ϸ
function initBillDetailTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + GlobalObj.billId;
	addOneTab("chargeTabs", "billDetailTab", "���߷�����ϸ", url);
}

//��;����
function initHalfBillTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFIntPay&BillNo=' + GlobalObj.billId;
	addOneTab("chargeTabs", "halfBillTab", "��;����", url);
}

//ҽ������˵�
function initHalfBillByOrdTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBILLOEORIItemGroup&EpisodeID=' + GlobalObj.episodeId + '&BillNo=' + GlobalObj.billId + '&Guser=' + SessionObj.guser;
	addOneTab("chargeTabs", "halfBillByOrdTab", "ҽ������˵�", url);
}

//Ѻ����ϸ��ѯ
function initDepDetailTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&BillNo=' + GlobalObj.billId + "&Adm=" + GlobalObj.episodeId;
	addOneTab("chargeTabs", "searchDepDet", "Ѻ����ϸ��ѯ", url);
}

//�շ���Ŀ��ѯ
function initTarFeeTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFItmDetail&BillNo=' + GlobalObj.billId;
	addOneTab("chargeTabs", "searchTarFee", "�շ���Ŀ��ѯ", url);
}

//ҽ�����ò�ѯ
function initOrdFeeTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdDetail&BillNo=' + GlobalObj.billId+"&EpisodeID=" + GlobalObj.episodeId;
	addOneTab("chargeTabs", "searchOrdFee", "ҽ�����ò�ѯ", url);
}

//ҽ�����ò�ѯ��Order��
function initAdmOrderFeeTab() {
	var url = 'dhcbill.ipbill.patordfee.csp?EpisodeID=' + GlobalObj.episodeId;
	addOneTab("chargeTabs", "admOrderFee", "ҽ�����ò�ѯ", url);
}

//���tab���
function addOneTab(parentId, tabId, mTitle, mUrl) {
	if(jQuery("#" + parentId).tabs("exists", mTitle)) {
		jQuery("#" + parentId).tabs("select", mTitle);
		refreshTab(tabId, mUrl);
	}else {
		jQuery("#" + parentId).tabs('add', {
			id: tabId,
			fit: true,
	    	title: mTitle,
	    	closable: false,
	    	selected: false,
	    	border: false,
	    	cache: false
		});
	}
}

//�������
function refreshTab(tabId, url) {
	var iframeId = "iframe_" + tabId;
	var content = '<iframe id="' + iframeId + '" scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>'
	//var content='<iframe src=' +url+ ' name="'+ tabId +'" id="'+ tabId +'" scrolling="no" width=100% height="100%" frameborder=0  style="margin:0.5px 0.5px 0.5px 0.5px" align="center"></iframe>';
	var obj = jQuery("#" + tabId);
	if(obj) {
		var opts = obj.panel("options");
		opts.content = content;
		jQuery("#" + tabId).panel("refresh");
	}
}

//��ȡiframe���Ԫ��
function getIframeElement(iframeId, elementId) {
	var iframeWin = document.getElementById(iframeId).contentWindow;
	var elementObj = iframeWin.document.getElementById(elementId);
	return elementObj;
}

//iframe ���ø����ڷ�������ת�������б� 
function setDefTabFromIframe() {
	jQuery("#chargeTabs").tabs("select", 0);
}

//����/���������¼
//flag��������(Ĭ�Ϻ�ҽ��վ��ͬ)
//admAry:�����¼����
//isLock��true:����,false:����
//����ֵ��true:������adm��false��������adm
function lockAdm(flag,admAry,isLock){
	var admAry=unique(admAry);
	var admStr=admAry.join("^");
	if(flag==""){
		flag="User.OEOrder";
	}
	var lockAdmRtn=0;
	if(isLock){
		lockAdmRtn=tkMakeServerCall("web.DHCBillLockAdm","LockAdm",admStr,flag);
		if(lockAdmRtn!=""){
			var lockAdmRtn=lockAdmRtn.replace(/\^/g,"\n");
			alert(lockAdmRtn);
			disElement("insuChargeBtn");
			disElement("insuPreChargeBtn");
			disElement("disChargeBtn");
			//disElement("cancelChargeBtn");
			//disElement("cancelInsuBtn");
			return true;
		}else {
			return false;
		}
	}else {
		lockAdmRtn=tkMakeServerCall("web.DHCBillLockAdm","UnLockAdm",admStr,flag);
		return false;
	}
	return false;
}

//���������е��ظ�Ԫ��
function unique(arr) {
    var result = [], hash = {};
    for (var i = 0, elem; (elem = arr[i]) != null; i++) {
        if (!hash[elem]) {
            result.push(elem);
            hash[elem] = true;
        }
    }
    return result;
}

function openCostInquriy(billNO, episodeID) {
	var url = "dhcipbillpatcostinquriy.csp?BillNo=" + billNO + "&EpisodeID=" + episodeID;
	websys_showModal({
		url: url,
		title: '���߿��ҷ��ò�ѯ',
		width: '90%',
		height: '85%',
		closed: true
	});
}