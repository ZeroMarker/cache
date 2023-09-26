var LocStore;
var DocStore;
var Grid;
var CM;
var SM;
var AM;
var PM;
var Start = +new Date();
var selectedAM;
var selectedPM;
var t = [];
var combo_CardType;
var InsuCardType = ""
	var currentLocID = "";
var locStoreLoadCount = 0;
var DocList;
var TimeRangeStore = [];
var SelectedTimeRange = "";
t['NotSelectSchedule'] = "����ȷ��ԤԼ�Ӻŵİ��";
t['NotTodayAddUpdate'] = "�Ӻ�ֻ�ܼӵ��պ�";
t['NotAppToday'] = "����ԤԼ���պ�";
t['AppHoliday'] = "������ԤԼ���ڼ���";
t['CardOnlyForReg'] = "�˿�ֻ�ܼӺŲ���ԤԼ";
t['InvaildCard'] = "��Ч��";
t['NotSelectPatient'] = "���ָ��ݿ���ȷ������";
t['AppOK'] = "ԤԼ�ɹ�";
t['AppFail'] = "ԤԼʧ��";
t['AddUpdateOK'] = "�Ӻųɹ�";
t['AddUpdateFail'] = "�Ӻ�ʧ��";
t['DocAppFial_2001'] = "��ʱ����Ѿ�û��ԤԼ��,�����ʱ���";

function GetCardTypeRegType() {
	var RegType = "";
	var CardTypeValue = DHCC_GetElementData("CardType");
	return CardTypeValue;
}
//��鿨�Ƿ���Ч�B�����Ч��õ����Ŷ�Ӧ�Ĳ��˻�����Ϣ
function CheckCardNo() {
	//���Ҫ�뿨����һ��
	var CardNo = DHCC_GetElementData("CardNo");
	var CardTypeRowId = GetCardTypeRowId();
	if (CardNo == "")
		return;
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardNo, "", "PatInfo");
	//alert(myrtn);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	AccAmount = myary[3];
	switch (rtn) {
	case "0":
		//����Ч���ʻ�
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		var NewCardTypeRowId = myary[8];
		if (NewCardTypeRowId != CardTypeRowId) {
			var CardTypeValue = GetCTValueByCardTypeRowID(NewCardTypeRowId);
			combo_CardType.setValue(CardTypeValue);
		}
		//combo_CardType.setValue(NewCardTypeRowId);
		
		var RegType = GetCardTypeRegType();
		if (RegType == "REG") {
			alert(t['CardOnlyForReg']);
			return;
		}
		
		SetPatientInfo(PatientNo, CardNo);
		break;
	case "-200":
		//����Ч
		alert(t['InvaildCard']);
		ClearPatInfo();
		websys_setfocus('CardNo');
		break;
	case "-201":
		//����Ч���ʻ�
		//alert(t['21']);
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		var NewCardTypeRowId = myary[8];
		if (NewCardTypeRowId != CardTypeRowId) {
			var CardTypeValue = GetCTValueByCardTypeRowID(NewCardTypeRowId);
			combo_CardType.setValue(CardTypeValue);
		}
		var RegType = GetCardTypeRegType();
		if (RegType == "��ʱҽ�ƿ�") {
			alert(t['CardOnlyForReg']);
			return;
		}
		//DHCC_SelectOptionByCode("PayMode","CASH")
		SetPatientInfo(PatientNo, CardNo);
		break;
	default:
		ClearPatInfo();
	}
}
//���ò��˻�����Ϣ
function SetPatient_Sel(value) {
	try {
		var Patdetail = value.split("^");
		DHCC_SetElementData("Name", Patdetail[0]);
		DHCC_SetElementData("Age", Patdetail[1]);
		DHCC_SetElementData("Sex", Patdetail[2]);
		DHCC_SetElementData("AppBreakCount", Patdetail[10]);
		DHCC_SetElementData("PatientID", Patdetail[6]);
		PatientID=Patdetail[6];
	} catch (e) {
		alert(e.message)
	};
}

//�õ������ò��˻�����Ϣ
function SetPatientInfo(PatientNo, CardNo) {
	//DHCC_SelectOptionByCode("PayMode","CPP");
	if (PatientNo != '') {
		ClearPatInfo();
		DHCC_SetElementData("PatientNo", PatientNo);
		DHCC_SetElementData("CardNo", CardNo);
		var encmeth = DHCC_GetElementData('GetDetail');
		if (encmeth != "") {
			
			if (cspRunServerMethod(encmeth, 'SetPatient_Sel', '', PatientNo) == '0') {
				var obj = document.getElementById('CardNo');
				obj.className = 'clsInvalid';
				websys_setfocus('BAppoint');
				return websys_cancel();
			} else {
				var obj = document.getElementById('CardNo');
				obj.className = '';
				websys_setfocus('BAppoint');
				return websys_cancel();
			}
		}
	} else {
		websys_setfocus('CardNo');
		ClearPatInfo();
		return websys_cancel();
	}
}

function GetCardTypeRowId() {
	var CardTypeRowId = "";
	var CardTypeValue = combo_CardType.getValue();
	
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}
//��ҽ����
function ReadInsuCard_click() {
	var rtn = ReadCard("N");
	if ((rtn == "-1") || (rtn == "")) {
		alert(t['ReadInsuCardErr']);
		return;
	}
	var myArr = rtn.split("|");
	var InsuCardNo = myArr[0];
	var ICNO = myArr[1];
	combo_CardType.setValue(InsuCardType);
	DHCC_SetElementData("CardNo", InsuCardNo);
	CheckCardNo();
	
}
function BtnReadCardHandler() {
	var CardTypeRowId = GetCardTypeRowId();
	var myoptval = combo_CardType.getValue();
	var myrtn;
	//if(combo_CardType.getRawValue()=="���￨"){
	//myrtn=DHCACC_GetAccInfo("","")
	//}
	//else{
	myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	//}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	//AccAmount=myary[3];
	switch (rtn) {
	case "0":
		//����Ч
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
		if (NewCardTypeRowId != CardTypeRowId)
			combo_CardType.setValue(NewCardTypeRowId);
		SetPatientInfo(PatientNo, CardNo, PatientID);
		break;
	case "-200":
		//����Ч
		alert(t['InvaildCard']);
		websys_setfocus('RegNo');
		break;
	case "-201":
		//�ֽ�
		//alert(t['21']);
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
		if (NewCardTypeRowId != CardTypeRowId)
			combo_CardType.setValue(NewCardTypeRowId);
		SetPatientInfo(PatientNo, CardNo, PatientID);
		
		break;
	default:
	}
}

function LocChangeHandler(obj, value, text) {
	//getDocList(value);
	DocList.setValue('');
	DocStore.load({
		params : {
			pClassName : "web.CTCareProv",
			pClassQuery : "GetDocByLoc",
			P1 : value,
			P2 : "",
			P3 : 'NurseAdd'
		},
		callback : function (r, options, success) {}
	});
}

function AMRowClick(Grid, rowIndex, e) {
	PM.getSelectionModel().clearSelections();
	selectedPM = null;
	var store = Grid.getStore();
	//selectedAM=AM.getSelectionModel().getSelected();
	if (Grid.getSelectionModel().getSelectedCell()) {
		selectedAM = store.getAt(Grid.getSelectionModel().getSelectedCell()[0]);
		/*
		var selections = Grid.getSelectionModel().getSelections();
		for (var i = 0; i < selections.length; i++) {
		var record = selections[i];
		}
		 */
	}
	if (selectedAM) {
		
		var RBASId = "";
		if (selectedAM) {
			RBASId = selectedAM.get("ASRowId");
			
		}
		
		TimeRangeStore = "";
		var ret = tkMakeServerCall('web.DHCBL.Doctor.Appoint', 'GetTimeRangeReg', 'ToJson', '', RBASId);
		//�з�ʱ��ԤԼ��Ϣ
		if (ret != 0) {
			TimeRangeStore = eval('(' + ret + ")");
			var comboStore = [];
			var selectedValue = "";
			for (var i = 0; i < TimeRangeStore.length; i++) {
				comboStore.push([TimeRangeStore[i][1], TimeRangeStore[i][0]]);
				if (TimeRangeStore[i][2] == 1) {
					selectedValue = TimeRangeStore[i][0];
				}
			}
			TimeRangeStore = comboStore;
			
		}
	}
	
}
function PMRowClick(Grid, rowIndex, e) {
	
	AM.getSelectionModel().clearSelections();
	selectedAM = null;
	//selectedPM=PM.getSelectionModel().getSelected();
	var store = Grid.getStore();
	if (Grid.getSelectionModel().getSelectedCell()) {
		selectedPM = store.getAt(Grid.getSelectionModel().getSelectedCell()[0]);
	}
	
	var RBASId = "";
	if (selectedPM) {
		RBASId = selectedPM.get("ASRowId");
		
	}
	
	TimeRangeStore = "";
	var ret = tkMakeServerCall('web.DHCBL.Doctor.Appoint', 'GetTimeRangeReg', 'ToJson', '', RBASId);
	//�з�ʱ��ԤԼ��Ϣ
	if (ret != 0) {
		TimeRangeStore = eval('(' + ret + ")");
		var comboStore = [];
		var selectedValue = "";
		for (var i = 0; i < TimeRangeStore.length; i++) {
			comboStore.push([TimeRangeStore[i][1], TimeRangeStore[i][0]]);
			if (TimeRangeStore[i][2] == 1) {
				selectedValue = TimeRangeStore[i][1];
			}
		}
		TimeRangeStore = comboStore;
		
	}
}
function DocChangeHandler(obj, value, text, type) {
	 ClearStore();
	 selectedAM=null;
	 selectedPM=null;
	if(value==""){
		return;
	 }
	var selectedLoc=Ext.getCmp("LocList").getValue();
	if(selectedLoc==""){
		return;
	}
	var check=cspRunServerMethod(CheckTimeInterval,selectedLoc,value);
	var appSearch=Ext.getCmp("AppSearch");
	var AppSeq=Ext.getCmp("AppSeq");
	var AddSearch = Ext.getCmp("AddSearch");
	var AddSeq = Ext.getCmp("AddSeq");
	
	var selectedDate = Ext.getCmp("date").getRawValue();
	if(value==""){
		alert("ҽ������Ϊ��");
		return;
	}
	if ((check==1)&&(selectedDate != CurrentDate)){
		appSearch.show();
		AppSeq.show();
		
	
	}else{
		appSearch.hide();
		AppSeq.hide();
		
	}
	
	
	var AMStore = AM.getStore();
	//261^3883^0^5105736^1^^89^^^2^^^N"
	//���ڹҺŲ�ѯ��ʶ
	var WinRegFlag = "N";
	var QueryStr = "";
	QueryStr+=Ext.getCmp("LocList").getValue();
	QueryStr += "^";
	QueryStr += "3881" + "^";
	//����

	if (type == "App") {
		var ASRowIdStr=GetASRowId(selectedLoc,value,selectedDate);
		QueryStr += selectedDate + "^";
	} else {
		if (selectedDate == CurrentDate) {
			QueryStr += "^";
		} else {
		    if(check==1){
		    	var ASRowIdStr=GetASRowId(selectedLoc,value,selectedDate);
				QueryStr += selectedDate + "^";
			}else{
				return;
			}
		}
	}
	//PAPERID
	QueryStr += PatientID + "^";
	QueryStr += "1" + "^";
	//FindDocDr
	
	QueryStr += value + "^";
	//��½��ȫ��
	/*
	if(Ext.getCmp("LocList").getRawValue().indexOf("����")!=-1){
	QueryStr += "352" + "^";
	}else if(Ext.getCmp("LocList").getRawValue().indexOf("����")!=-1){
	QueryStr += "353" + "^";
	}
	else {
	QueryStr += "344" + "^";
	}
	 */
	//������ȫ��Ȩ��
	QueryStr += "^";
	QueryStr += "^" + "^";
	QueryStr += "1" + "^";
	QueryStr += "^" + "^";
	QueryStr += "N";
	QueryStr += "^" + WinRegFlag;
	AMStore.load({
		params : {
			pClassName : "web.BriefEntry",
			pClassQuery : "OPDocList",
			P1 : QueryStr
		},
		callback : function (r, options, success) {}
	});
	var PMStore = PM.getStore();
	var Arr = QueryStr.split("^");
	Arr[9] = "2";
	QueryStr = Arr.join("^");
	
	PMStore.load({
		params : {
			pClassName : "web.BriefEntry",
			pClassQuery : "OPDocList",
			P1 : QueryStr
		},
		callback : function (r, options, success) {}
	});
	
}

Ext.onReady(function () {
	var a1 = ( + new Date());
	
	LocStore = new Ext.data.JsonStore({
			autoDestroy : true,
			'id' : 0,
			fields : ['CTLocDesc', 'CTLocID'],
			root : 'record',
			url : "ext.websys.querydatatrans.csp"
			
		});
	LocStore.load({
		params : {
			pClassName : "web.DHCCTLocMinor",
			pClassQuery : "GetOPLocList",
			P1 : "",
			P2 : "NurseAdd"
		},
		callback : function (r, options, success) {}
	});
	var LocList = new Ext.form.ComboBox({
			width : 170,
			typeAhead : true,
			height : 100,
			triggerAction : 'all',
			store : LocStore,
			mode : 'local',
			id : "LocList",
			lazyRender : true,
			valueField : 'CTLocID',
			displayField : 'CTLocDesc',
			listeners : {
				change : LocChangeHandler,
				select:function(){
				 ClearStore();
				  if(GJYL==""){
					ClearPatInfo();
				 }
				 DocList.setValue('');
				 selectedAM=null;
				 selectedPM=null;
				}
			}
		})
		
		DocStore = new Ext.data.JsonStore({
			autoDestroy : true,
			'id' : 0,
			fields : ['CareProvID', 'DocDesc', 'LocDesc', 'LocID'],
			root : 'record',
			url : "ext.websys.querydatatrans.csp"
			
		});
	
	DocList = new Ext.form.ComboBox({
			width : 80,
			typeAhead : true,
			triggerAction : 'all',
			column : '.5',
			store : DocStore,
			mode : 'local',
			id : "DocList",
			lazyRender : true,
			valueField : 'CareProvID',
			displayField : 'DocDesc',
			listeners : {
				select : function (combo, record, index) {
					var selectedValue = record.get("CareProvID");
					DocChangeHandler(combo, selectedValue, '', '');
				}
				//,change: DocChangeHandler
			}
		});
	
	CardTypeStore = eval("(" + CardTypeArray + ')');
	var defaultCardType;
	
	for (var i = 0; i < CardTypeStore.length; i++) {
		if (CardTypeStore[i][0] == "���￨") {
			defaultCardType = CardTypeStore[i][1];
			
		}
		if (CardTypeStore[i][0] == "ҽ����") {
			InsuCardType = CardTypeStore[i][1];
		}
	}
	combo_CardType = new Ext.form.ComboBox({
			//width: 100,
			width : 170 - 13,
			typeAhead : true,
			height : 100,
			//renderTo:'LocListDiv',
			triggerAction : 'all',
			store : new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
				
			}),
			mode : 'local',
			lazyRender : false,
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
	
	var tbar = new Ext.Toolbar({
			//height:40,
			items : [
			    {
					text : '����',
					xtype : 'label'
				}, 
				{
					xtype : 'label',
					width : '5'
				}, 
				{
					//ֻ�ܼӵ���ĺ�
					id : 'date',
					format : 'Y-m-d',
					xtype : 'datefield',
					value : CurrentDate,
					listeners : {
						select : function (obj, value) {
						    ClearStore();
							var appSearch = Ext.getCmp("AppSearch");
							var AppSeq = Ext.getCmp("AppSeq");
							var AddSearch = Ext.getCmp("AddSearch");
							var AddSeq = Ext.getCmp("AddSeq");
							var date = Ext.util.Format.date(value, 'Y-m-d');
							
							if (date == CurrentDate) {
								appSearch.hide();
								AppSeq.hide();
								AddSearch.show();
								AddSeq.show();
							} else {
								var doc = Ext.getCmp("DocList").getValue();
								var loc = Ext.getCmp("LocList").getValue();
								
								AddSearch.hide();
								AddSeq.hide();
								if(loc!=""){
									DocList.setValue('');
									
									DocStore.load({
										params : {
											pClassName : "web.CTCareProv",
											pClassQuery : "GetDocByLoc",
											P1 : loc,
											P2 : "",
											P3 : 'NurseAdd',
											P4:date
											
										},
										callback : function (r, options, success) {}
									});
								}
							
							}
							//DocChangeHandler("", Ext.getCmp("DocList").getValue(), "", "App");
							
						}
						
					}
					//,disabled: true
				},
				 {
					xtype : 'label',
					width : 10
				},
			    {
					text : '����',
					xtype : 'label'
				},
				LocList, {
					width : 10,
					xtype : 'label'
				}, {
					text : 'ҽ��',
					xtype : 'label'
				},
				DocList, {
					width : 20,
					xtype : 'label'
				},  {
					text : '����ID:',
					cls : 'orderbtn',
					xtype : 'label'
					//,hidden:true
				}, {
					text : '',
					id : 'PatientNo',
					xtype : 'textfield',
					cls : 'orderbtn',
					width : '90',
					grow : true,
					enableKeyEvents : true,
					selectOnFocus : true,
					listeners : {
						keydown : function (obj, e) {
							
							if (e.getKey() == Ext.EventObject.ENTER) {
								//retStr = cspRunServerMethod(GetPatientMessage, this.getValue(), "");
								var patientNo = this.getValue();
								var locdesc=Ext.getCmp("LocList").getRawValue();
								var ret = locdesc.indexOf("����ҽ��")!=-1?cspRunServerMethod(GetCardNoByPatientID, patientNo,"1"):cspRunServerMethod(GetCardNoByPatientID, patientNo,"");
								//var ret = cspRunServerMethod(GetCardNoByPatientID, patientNo);
								if ((ret != "") && (ret.split(",").length > 0)) {
									SetPatientInfo(patientNo, ret.split(",")[0]);
									PatientID = ret.split(",")[1];
								} else {
									alert("��Ч�Ĳ���ID");
								}
							}
						}
					},
					autoSize : function () {
						this.focus();
						
					}
					//hidden:true
				}, {
					text : '�Ƽ���',
					xtype : 'label'
				}, {
					id : 'EmployeeNo',
					xtype : 'textfield',
					width : 70
				}, {
					text : '������',
					xtype : 'label'
					
				}, {
					id : 'NeedListen',
					xtype : 'checkbox',
					handler : function () {}
				}, {
					text : 'ԤԼ��ѯ',
					id : 'AppSearch',
					xtype : 'button',
					hidden : true,
					handler : function () {
						DocChangeHandler("", Ext.getCmp("DocList").getValue(), "", "App");
					}
				}, {
					text : '�ӺŲ�ѯ',
					id : 'AddSearch',
					xtype : 'button',
					handler : function () {
						DocChangeHandler("", Ext.getCmp("DocList").getValue(), "", "Add");
					}
				}, {
					text : '�Ӻ�',
					id : 'AddSeq',
					xtype : 'button',
					handler : AddBeforeUpdate
				}, {
					text : 'ԤԼ',
					id : 'AppSeq',
					hidden : true,
					handler : function () {
						AppointClickHandler();
					}
				}
			]
		});
	
	var titleBar = new Ext.Toolbar({
			items : [{
					cls : 'x-panel-header-text',
					xtype : 'label',
					id : 'titleBar',
					text : '����'
				}
			]
		});
	var cardToolBar = new Ext.Toolbar({
			height : 40,
			items : [{
					xtype : 'hidden',
					id : 'GetDetail',
					value : GetDetail
				}, {
					cls : 'x-panel-header-text',
					xtype : 'label',
					text : '������'
					
				},
				combo_CardType, {
					xtype : 'label',
					width : '5'
				}, {
					cls : 'x-panel-header-text',
					xtype : 'button',
					id : 'btnRead',
					handler : BtnReadCardHandler,
					text : '����'
				}, {
					xtype : 'label',
					width : '5'
				}, {
					cls : 'x-panel-header-text',
					xtype : 'button',
					id : 'btnReadInsu',
					//hidden: true,
					handler : ReadInsuCard_click,
					text : '��ҽ����'
				}, {
					xtype : 'label',
					text : '����'
				}, {
					xtype : 'label',
					width : '5'
				}, {
					
					xtype : 'textfield',
					//disabled:true,
					id : 'CardNo',
					grow : true,
					enableKeyEvents : true,
					selectOnFocus : true,
					listeners : {
						keydown : function (obj, e) {
							
							if (e.getKey() == Ext.EventObject.ENTER) {
								//retStr = cspRunServerMethod(GetPatientMessage, this.getValue(), "");
								var cardno = this.getValue();
								
								var ret = cspRunServerMethod(GetPatientID, cardno);
								if ((ret != "") && (ret.split(",").length > 0)) {
									SetPatientInfo(ret.split(",")[2], ret.split(",")[0]);
									PatientID = ret.split(",")[1];
								} else {
									alert("��Ч��");
								}
							}
						}
					},
					autoSize : function () {
						this.focus();
						
					}
				}, {
					xtype : 'label',
					width : '5'
				}, {
					xtype : 'label',
					text : '����'
				}, {
					xtype : 'label',
					width : '5'
				}, {
					//xtype:'label',
					xtype : 'textfield',
					disabled : true,
					id : 'Name',
					width : 40
				}, {
					xtype : 'label',
					width : '5'
				}, {
					xtype : 'label',
					text : '����'
				}, {
					// xtype:'label',
					xtype : 'textfield',
					disabled : true,
					id : 'Age',
					width : 40
				}, {
					xtype : 'label',
					width : '5'
				}, {
					text : '�Ա�',
					xtype : 'label'
				}, {
					xtype : 'label',
					width : '5'
				}, {
					//xtype:'label',
					xtype : 'textfield',
					disabled : true,
					id : 'Sex',
					width : 40
				}, {
					xtype : 'label',
					width : '5'
				}, {
					xtype : 'label',
					disabled : true,
					text : 'ΥԼ����'
				}, {
					xtype : 'label',
					width : '5'
				}, {
					id : 'AppBreakCount',
					//xtype:'label',
					xtype : 'textfield',
					disabled : true,
					width : 40
				}, {
					xtype : 'hidden',
					id : 'PatientID'
				}
				
			]
		});
	var columnHeaders = ["ҽ��", "����", "��רҵ", "�Ӻ�ְ��", "�����޶�", "ԤԼ�޶�", "�Ӻ��޶�", "�Ӻ�", "ʣ��", "�Ӻŷ�", "����", "ԤԼ��", "������", "������", "����", "��ԤԼ��", "�ɼӺ���", "�Ű�״̬", "�ֳ�ʣ��", "����", "ʱ��", "�ѼӺ���", "�����־", "ԤԼʱ���"];
	var dataIndexs = ["MarkDesc", "RoomDesc", "ClinicGroupDesc", "SessionTypeDesc", "Load", "AppLoad", "AddLoad", "AvailAddSeqNoStr", "AvailSeqNoStrR", "RegFee", "ExamFee", "AppFee", "ReCheckFee", "RoomCode", "DepDesc", "AppedCount", "NurseAdd", "ScheduleStatus", "AvailNorSeqNoStr", "ScheduleDate", "TimeRange", "AddedCount", "HoliFee", "HoliFeeDr", "AppFeeDr", "ASRowId", "ScheduleDateWeek", "RegFeeDr", "Period"];
	var hiddenHeaders = ["ԤԼ�޶�", "�Ӻ��޶�", "�Ӻ�", "ʣ��", "������", "�����־", "�Ű�״̬", "�Ӻŷ�", "����", "������", "ԤԼ��","ʱ��"];
	var columns = new Array();
	var dataRecords = new Array();
	for (var j = 0; j < columnHeaders.length; j++) {
		if (columnHeaders[j] == "ԤԼʱ���") {
			columns.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j],
				renderer : SetComboBoxRender,
				editable : true,
				editor : new Ext.form.ComboBox({
					pressed : true,
					width : 80,
					typeAhead : true,
					dataIndex : dataIndexs[j],
					forceAll : true,
					forceSelection : true,
					mode : 'local',
					dataIndex : dataIndexs[j],
					editable : true,
					store : new Ext.data.ArrayStore({
						autoDestroy : true,
						fields : ["RowId", "Desc"]
					}),
					valueField : 'RowId',
					displayField : 'Desc',
					listeners : { //
						beforequery : function (obj) {
							var grid = AM;
							var store = AM.getStore();
							var currentRow = grid.getSelectionModel().getSelectedCell()[0];
							obj.combo.store.loadData(TimeRangeStore, false);
							obj.forceAll = true;
							obj.query = "";
						},
						select : function (combo, record, index) {
							
							SelectedTimeRange = record.get("Desc");
						},
						change : AppTimeRangeChange
						
					}
				})
				//width: 200
				
			});
		}else if ((columnHeaders[j] == "�����޶�")||(columnHeaders[j] == "�ɼӺ���")||(columnHeaders[j] == "��ԤԼ��")){
			columns.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j],
				width: 70
				
			});
		} else if (hiddenHeaders.indexOf(columnHeaders[j]) != -1) {
			columns.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j],
				hidden : true
				//width: 200
			});
		} else {
			columns.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j]
				//width: 200
				
			});
		}
	}
	for (var i = 0; i < dataIndexs.length; i++) {
		dataRecords.push({
			name : dataIndexs[i],
			type : "string"
		});
	}
	var cm = new Ext.grid.ColumnModel({
			defaults : {
				sortable : false // columns are not sortable by default
			},
			columns : columns
		});
	var store = new Ext.data.Store({
			autoDestroy : true,
			url : "ext.websys.querydatatrans.csp",
			reader : new Ext.data.JsonReader({
				totalProperty : 'total',
				root : 'record'
			},
				Ext.data.Record.create(dataRecords)),
			listeners : {
				// add: function(ds, records, options) {}
			}
		});
	
	AM = new Ext.grid.EditorGridPanel({
			id : "AMGrid",
			store : store,
			cm : cm,
			region : "north",
			plain : true,
			header : false,
			height : 330,
			tbar : tbar,
			clicksToEdit : 1,
			//autoScroll:true,
			enableDragDrop : false,
			enableHdMenu : false,
			viewConfig : {
				//forceFit: true,
				getRowClass : function (record, index) {}
			},
			//sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			title : "���磺�ɼӺ�/ԤԼҽ���б�",
			listeners : {
				render : function () {
					cardToolBar.render(this.tbar);
					titleBar.render(this.tbar);
					
				},
				rowclick : AMRowClick
			}
		});
	store.load({
		params : {
			pClassName : "web.BriefEntry",
			pClassQuery : "OPDocList",
			P1 : ""
		},
		callback : function (r, options, success) {}
	});
	
	var columnsPM = new Array();
	var dataRecordsPM = new Array();
	for (var j = 0; j < columnHeaders.length; j++) {
		if (columnHeaders[j] == "ԤԼʱ���") {
			columnsPM.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j],
				renderer : SetComboBoxRender,
				editable : true,
				editor : new Ext.form.ComboBox({
					pressed : true,
					width : 80,
					typeAhead : true,
					dataIndex : dataIndexs[j],
					forceAll : true,
					forceSelection : true,
					mode : 'local',
					dataIndex : dataIndexs[j],
					editable : true,
					store : new Ext.data.ArrayStore({
						autoDestroy : true,
						fields : ["RowId", "Desc"]
					}),
					valueField : 'RowId',
					displayField : 'Desc',
					listeners : { //
						beforequery : function (obj) {
							var grid = PM;
							var store = grid.getStore();
							var currentRow = grid.getSelectionModel().getSelectedCell()[0];
							
							obj.combo.store.loadData(TimeRangeStore, false);
							obj.forceAll = true;
							obj.query = "";
							
						},
						select : function (combo, record, index) {
							
							SelectedTimeRange = record.get("Desc");
						},
						change : AppTimeRangeChange
					}
				})
				//width: 200
				
			});
		} else if ((columnHeaders[j] == "�����޶�")||(columnHeaders[j] == "�ɼӺ���")||(columnHeaders[j] == "��ԤԼ��")){
			columnsPM.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j],
				width: 70
				
			});
		}else if (hiddenHeaders.indexOf(columnHeaders[j]) != -1) {
			columnsPM.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j],
				hidden : true
				//width: 200
			});
		} else {
			columnsPM.push({
				header : columnHeaders[j],
				id : dataIndexs[j],
				dataIndex : dataIndexs[j]
				//width: 200
				
			});
		}
		
	}
	for (var i = 0; i < dataIndexs.length; i++) {
		dataRecordsPM.push({
			name : dataIndexs[i],
			type : "string"
		});
	}
	var cmPM = new Ext.grid.ColumnModel({
			defaults : {
				sortable : false // columns are not sortable by default
			},
			columns : columnsPM
		});
	var storePM = new Ext.data.Store({
			autoDestroy : true,
			url : "ext.websys.querydatatrans.csp",
			reader : new Ext.data.JsonReader({
				totalProperty : 'total',
				root : 'record'
			},
				Ext.data.Record.create(dataRecordsPM)),
			listeners : {
				// add: function(ds, records, options) {}
			}
		});
	PM = new Ext.grid.EditorGridPanel({
			id : "PMGrid",
			store : storePM,
			cm : cmPM,
			region : 'center',
			clicksToEdit : 1,
			sm : new Ext.grid.CellSelectionModel(),
			frame : true,
			enableDragDrop : false,
			enableHdMenu : false,
			viewConfig : {
				getRowClass : function (record, index) {}
			},
			//sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			title : "����",
			listeners : {
				rowclick : PMRowClick
			}
		});
	storePM.load({
		params : {
			pClassName : "web.BriefEntry",
			pClassQuery : "OPDocList",
			P1 : ""
		},
		callback : function (r, options, success) {}
	});
	
	var viewport = new Ext.Viewport({
			layout : 'border',
			id : "viewport",
			items : [AM, PM]
		});
	combo_CardType.setValue(defaultCardType);
	a1 = +new Date();
	if(PatientNo!=""){
		SetPatientInfo(PatientNo, "");
	}
})

//�Ӻ�
function AddBeforeUpdate() {
	var ret = CheckBeforeAddUpdate();
	if (ret == false) {
		return false
	}
	
	var AdmReason = "";
	var UserID = session['LOGON.USERID'];
	var GroupID = session['LOGON.GROUPID'];
	//�Ƽ���
	var EmployeeNo;
	if (Ext.getCmp('EmployeeNo'))
		EmployeeNo = Ext.getCmp('EmployeeNo').getValue();
	
	if ((EmployeeNo) && (EmployeeNo != "")) {
		var VipFlag = tkMakeServerCall("web.DHCRBAppointment", "IsVipPatient", EmployeeNo);
		if ((VipFlag == "0")) {
			alert("����¼�벻��ȷ");
			//websys_setfocus('EmployeeNo');
			return false;
		}
	}
	try {
		var ASRowId = "",
		QueueNo = "";
		if (selectedAM) {
			ASRowId = selectedAM.data.ASRowId;
		}
		if (selectedPM) {
			if (selectedPM.data)
				ASRowId = selectedPM.data.ASRowId;
		}
		
		if (OPRAppEncrypt != '') {
			var ret = cspRunServerMethod(OPRAppEncrypt, '', '', PatientID, ASRowId, QueueNo, UserID, "NURSEADD", "", EmployeeNo);
			if (ret.split("^")[0] == "0") {
				alert(t["AddUpdateOK"]);
				ClearPatInfo();
				DocChangeHandler("", Ext.getCmp("DocList").getValue(), "", "Add");
				//window.close();
				
			} else {
				
				if (ret == "-1111") {
					alert("�������Ӻ���");
				} else {
					//-201 û��ԤԼ��Դ
					if(ret=="-302"){
					  ret="������ÿ��ÿ����ͬҽ���Ӻ��޶�"
					}
					alert(t['AddUpdateFail'] + ret);
				}
				//ClearPatInfo();
				//websys_setfocus('CardNo');
				return;
			}
			selectedAM=null;
			selectedPM=null;
		}
	} catch (e) {
		alert(e.message)
	}
	
}
function CheckBeforeAddUpdate() {
	if ((!selectedPM) && (!selectedAM)){
		alert(t['NotSelectSchedule']);
		return false;
	}
	if (PatientID == "") {
		alert(t['NotSelectPatient']);
		websys_setfocus('CardNo');
		return false;
	}
	
	var store,
	ColData,
	ASRowId,
	AppDate;
	if (selectedAM) {
		ASRowId = selectedAM.data.ASRowId;
		AppDate = selectedAM.data.ScheduleDate;
		if (ASRowId == undefined) {
			ASRowId = "";
		}
	}
	if (selectedPM) {
		ASRowId = selectedPM.data.ASRowId;
		AppDate = selectedPM.data.ScheduleDate;
		if (ASRowId == undefined) {
			ASRowId = "";
		}
	}
	
	if (ASRowId == "") {
		alert(t['NotSelectSchedule']);
		return false;
	}
	
	if (AppDate != CurrentDate) {
		alert(t['NotTodayAddUpdate']);
		return false;
	}
	
	return true;
	
}

//ԤԼ
function AppointClickHandler() {
	var ret = CheckBeforeAppoint();
	if (ret == false) {
		return false
	}
	
	var NeedListen = "";
	var AdmReason = "";
	var UserID = session['LOGON.USERID'];
	var GroupID = session['LOGON.GROUPID'];
	//�Ƽ���
	if (Ext.getCmp('NeedListen'))
		NeedListen = Ext.getCmp('NeedListen').getValue();
	var EmployeeNo;
	if (Ext.getCmp('EmployeeNo'))
		EmployeeNo = Ext.getCmp('EmployeeNo').getValue();
	if (EmployeeNo != "") {
		var VipFlag = tkMakeServerCall("web.DHCRBAppointment", "IsVipPatient", EmployeeNo);
		if ((VipFlag == "0")) {
			alert("����¼�벻��ȷ");
			return false;
		}
	}
	
	try {
		var ASRowId = "",
		QueueNo = "";
		if (selectedAM) {
			ASRowId = selectedAM.data.ASRowId;
			
		}
		if (selectedPM) {
			ASRowId = selectedPM.data.ASRowId;
		}
		
		if (OPRAppEncrypt != '') {
			if (SelectedTimeRange != "") {
				var ret = cspRunServerMethod(OPRAppEncrypt, '', '', PatientID, ASRowId, QueueNo, UserID, "DOC", NeedListen, '', SelectedTimeRange);
			} else {
				var ret = cspRunServerMethod(OPRAppEncrypt, '', '', PatientID, ASRowId, QueueNo, UserID, "DOC", NeedListen);
			}
			var retArr = ret.split("^");
			if (retArr[0] == "0") {
				alert(t["AppOK"]);
				var AppARowid = retArr[1];
				var AppPrinte = "";
				if (Ext.get('AppPrint')) {
					AppPrinte = Ext.getCmp('AppPrint').getValue();
					//<input name="AppPrint" id="AppPrint" type="hidden" value="1"/>
				}
				if (AppPrinte != "") {
					//var AppPrintData = tkMakeServerCall("web.DHCOPAdmReg", "GetAppPrintData", AppARowid);
					//AppPrintOut(AppPrintData) //�˴����ô�ӡ����
				}
				
			} else {
				//-201 û��ԤԼ��Դ
				if (retArr[0] == "-2001") {
					alert(t['DocAppFial_2001']);
				} else {
					if(ret=="-302"){
					  ret="������ÿ��ÿ����ͬҽ��ԤԼ�޶�"
					}
					alert(t['AppFail'] + ret);
				}
				
				return;
			}
			selectedAM=null;
			selectedPM=null;
		}
		
	} catch (e) {
		alert(e.message)
	}
}

//ԤԼ֮ǰ��֤
function CheckBeforeAppoint() {
	//��֤���˿����ǼǺ�
	
	if (PatientID == "") {
		alert(t['NotSelectPatient']);
		return false;
	}
	var store,
	ColData,
	AppDate;
	var ASRowId="";
	if (selectedAM) {
		ASRowId = selectedAM.data.ASRowId;
		AppDate = selectedAM.data.ScheduleDate;
		if (ASRowId == undefined) {
			ASRowId = "";
		}
	}
	if (selectedPM) {
		ASRowId = selectedPM.data.ASRowId;
		AppDate = selectedPM.data.ScheduleDate;
		if (ASRowId == undefined) {
			ASRowId = "";
		}
	}
	
	if (ASRowId == "") {
		alert(t['NotSelectSchedule']);
		return false;
	}
	
	//ԤԼ��������
	if (AppDate == CurrentDate) {
		alert(t['NotAppToday']);
		return false;
	}
	var holiday = (new Date()).getDay();
	var holiday = cspRunServerMethod(GetWeekOfDate, AppDate);
	if ((holiday == "0") || (holiday == "6")) {
		if (!confirm(t['AppHoliday']))
			return false;
	}
	return true;
}
function ClearPatInfo() {
	DHCC_SetElementData("CardNo", "");
	DHCC_SetElementData("PatientNo", "");
	DHCC_SetElementData("PatientID", "");
	DHCC_SetElementData("Name", "");
	DHCC_SetElementData("Age", "");
	DHCC_SetElementData("Sex", "");
	DHCC_SetElementData("AppBreakCount", "");
	//DHCC_SetElementData("CardType","");
}

function DHCC_GetElementData(str) {
	var obj = Ext.getCmp(str);
	if (obj) {
		return obj.getValue();
	} else {
		return "";
	}
}

function DHCC_SetElementData(element, value) {
	
	var obj = Ext.getCmp(element);
	if (obj) {
		obj.xtype == "label" ? obj.setText(value) : obj.setValue(value);
	}
}
function GetPeriodJson() {}
function SetComboBoxRender(value, obj) {
	
	if (this.editor.el) {
		var rawValue = this.editor.getRawValue();
		return rawValue;
		
	} else {
		return value;
	}
}

function GetTimeRangeRegToJson(ListName, txtdesc, valdesc, ListIdx, SelFlag) {
	
	var aryitmdes = txtdesc //.split("^");
		var aryitminfo = valdesc //.split("^");
		TimeRangeStore.push([aryitmdes, aryitminfo]);
	
}
function AppTimeRangeChange(obj, value, text) {
	SelectedTimeRange = obj.getRawValue();
}

function GetCTValueByCardTypeRowID(CardTypeRowID) {
	for (var i = 0; i < CardTypeStore.length; i++) {
		if (CardTypeStore[i][1].split("^")[0] == CardTypeRowID) {
			
			return CardTypeStore[i][1];
		}
	}
	
}

function ClearStore(){
			var AMStore = AM.getStore();
							AMStore.removeAll();
							var PMStore = PM.getStore();
							PMStore.removeAll();
}

function GetASRowId(LocId,DocId,StartDate) {
	var ASRowIdStr="";
	//�ж��Ƿ��г����¼
	var ScheduleTRangeStr=cspRunServerMethod(GetScheduleTRangeStrMethod,LocId,DocId,StartDate);
	if (ScheduleTRangeStr!="") {
		var ScheduleTRangeAry=ScheduleTRangeStr.split("^");
		for (var i=0;i<ScheduleTRangeAry.length;i++) {
			var TimeRangeItem=ScheduleTRangeAry[i];
			var TimeRangeId=TimeRangeItem.split(String.fromCharCode(2))[0];
			var TimeRangeDesc=TimeRangeItem.split(String.fromCharCode(2))[1];
			var ASRowId=cspRunServerMethod(GetTodayASRowIdByResMethod,LocId,DocId,"",StartDate,TimeRangeId);
			if (ASRowId=="") {
				var conflag=confirm("����["+StartDate+TimeRangeDesc+"]û�г����¼,�Ƿ��Ű�ģ���������ĳ����¼?");
				if (conflag) {
					var ASRowId=cspRunServerMethod(GetRapidASRowIdMethod,LocId,"","",StartDate,TimeRangeId,DocId);
					if (ASRowId==""){
						alert("����["+StartDate+TimeRangeDesc+"]�����¼ʧ��,��ȷ���Ƿ������й��Ű�?");
					}else{
						if (ASRowIdStr==""){ASRowIdStr=ASRowId;}else{ASRowIdStr=ASRowIdStr+"^"+ASRowId;}
					}
				}
			}else{
				if (ASRowIdStr==""){ASRowIdStr=ASRowId;}else{ASRowIdStr=ASRowIdStr+"^"+ASRowId;}
			}
		}
		if (ASRowIdStr=="") {
			return false;
		}
	}else{
		//���û�е�ǰ���ڵ��Ű��¼,���������,ʱ���Ѿ���ͨ���Ű���,
		var IsScheduleFlag=cspRunServerMethod(GetIsScheduleFlagMethod,LocId,DocId,StartDate);
		if (IsScheduleFlag=="0") {
			alert("����["+StartDate+"]��Ӧ������û���Ű�,������ǰ���ɳ����¼.");
			return false;
		}else if (IsScheduleFlag=="-1") {
			alert("����"+StartDate+"��Ӧ���Ű��Ѿ�ͣ��.");
			return false;
		}
	}
	
	return ASRowIdStr;
}
