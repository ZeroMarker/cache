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
t['NotSelectSchedule'] = "请先确定预约加号的班次";
t['NotTodayAddUpdate'] = "加号只能加当日号";
t['NotAppToday'] = "不能预约当日号";
t['AppHoliday'] = "您即将预约到节假日";
t['CardOnlyForReg'] = "此卡只能加号不能预约";
t['InvaildCard'] = "无效卡";
t['NotSelectPatient'] = "请现根据卡号确定患者";
t['AppOK'] = "预约成功";
t['AppFail'] = "预约失败";
t['AddUpdateOK'] = "加号成功";
t['AddUpdateFail'] = "加号失败";
t['DocAppFial_2001'] = "该时间段已经没有预约号,请更换时间段";

function GetCardTypeRegType() {
	var RegType = "";
	var CardTypeValue = DHCC_GetElementData("CardType");
	return CardTypeValue;
}
//检查卡是否有效如果有效则得到卡号对应的病人基本信息
function CheckCardNo() {
	//这边要与卡处理一致
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
		//卡有效有帐户
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
		//卡无效
		alert(t['InvaildCard']);
		ClearPatInfo();
		websys_setfocus('CardNo');
		break;
	case "-201":
		//卡有效无帐户
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
		if (RegType == "临时医疗卡") {
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
//设置病人基本信息
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

//得到并设置病人基本信息
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
//读医保卡
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
	//if(combo_CardType.getRawValue()=="就诊卡"){
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
		//卡有效
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
		if (NewCardTypeRowId != CardTypeRowId)
			combo_CardType.setValue(NewCardTypeRowId);
		SetPatientInfo(PatientNo, CardNo, PatientID);
		break;
	case "-200":
		//卡无效
		alert(t['InvaildCard']);
		websys_setfocus('RegNo');
		break;
	case "-201":
		//现金
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
		//有分时段预约信息
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
	//有分时段预约信息
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
		alert("医生不能为空");
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
	//窗口挂号查询标识
	var WinRegFlag = "N";
	var QueryStr = "";
	QueryStr+=Ext.getCmp("LocList").getValue();
	QueryStr += "^";
	QueryStr += "3881" + "^";
	//日期

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
	//登陆安全组
	/*
	if(Ext.getCmp("LocList").getRawValue().indexOf("特需")!=-1){
	QueryStr += "352" + "^";
	}else if(Ext.getCmp("LocList").getRawValue().indexOf("卫干")!=-1){
	QueryStr += "353" + "^";
	}
	else {
	QueryStr += "344" + "^";
	}
	 */
	//超级安全组权限
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
		if (CardTypeStore[i][0] == "就诊卡") {
			defaultCardType = CardTypeStore[i][1];
			
		}
		if (CardTypeStore[i][0] == "医保卡") {
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
					text : '日期',
					xtype : 'label'
				}, 
				{
					xtype : 'label',
					width : '5'
				}, 
				{
					//只能加当天的号
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
					text : '科室',
					xtype : 'label'
				},
				LocList, {
					width : 10,
					xtype : 'label'
				}, {
					text : '医生',
					xtype : 'label'
				},
				DocList, {
					width : 20,
					xtype : 'label'
				},  {
					text : '病人ID:',
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
								var ret = locdesc.indexOf("国际医疗")!=-1?cspRunServerMethod(GetCardNoByPatientID, patientNo,"1"):cspRunServerMethod(GetCardNoByPatientID, patientNo,"");
								//var ret = cspRunServerMethod(GetCardNoByPatientID, patientNo);
								if ((ret != "") && (ret.split(",").length > 0)) {
									SetPatientInfo(patientNo, ret.split(",")[0]);
									PatientID = ret.split(",")[1];
								} else {
									alert("无效的病人ID");
								}
							}
						}
					},
					autoSize : function () {
						this.focus();
						
					}
					//hidden:true
				}, {
					text : '推荐人',
					xtype : 'label'
				}, {
					id : 'EmployeeNo',
					xtype : 'textfield',
					width : 70
				}, {
					text : '需听课',
					xtype : 'label'
					
				}, {
					id : 'NeedListen',
					xtype : 'checkbox',
					handler : function () {}
				}, {
					text : '预约查询',
					id : 'AppSearch',
					xtype : 'button',
					hidden : true,
					handler : function () {
						DocChangeHandler("", Ext.getCmp("DocList").getValue(), "", "App");
					}
				}, {
					text : '加号查询',
					id : 'AddSearch',
					xtype : 'button',
					handler : function () {
						DocChangeHandler("", Ext.getCmp("DocList").getValue(), "", "Add");
					}
				}, {
					text : '加号',
					id : 'AddSeq',
					xtype : 'button',
					handler : AddBeforeUpdate
				}, {
					text : '预约',
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
					text : '上午'
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
					text : '卡类型'
					
				},
				combo_CardType, {
					xtype : 'label',
					width : '5'
				}, {
					cls : 'x-panel-header-text',
					xtype : 'button',
					id : 'btnRead',
					handler : BtnReadCardHandler,
					text : '读卡'
				}, {
					xtype : 'label',
					width : '5'
				}, {
					cls : 'x-panel-header-text',
					xtype : 'button',
					id : 'btnReadInsu',
					//hidden: true,
					handler : ReadInsuCard_click,
					text : '读医保卡'
				}, {
					xtype : 'label',
					text : '卡号'
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
									alert("无效卡");
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
					text : '姓名'
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
					text : '年龄'
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
					text : '性别',
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
					text : '违约次数'
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
	var columnHeaders = ["医生", "诊室", "亚专业", "加号职称", "正号限额", "预约限额", "加号限额", "加号", "剩号", "加号费", "诊查费", "预约费", "其他费", "诊室码", "科室", "已预约数", "可加号数", "排班状态", "现场剩号", "日期", "时段", "已加号数", "激活标志", "预约时间段"];
	var dataIndexs = ["MarkDesc", "RoomDesc", "ClinicGroupDesc", "SessionTypeDesc", "Load", "AppLoad", "AddLoad", "AvailAddSeqNoStr", "AvailSeqNoStrR", "RegFee", "ExamFee", "AppFee", "ReCheckFee", "RoomCode", "DepDesc", "AppedCount", "NurseAdd", "ScheduleStatus", "AvailNorSeqNoStr", "ScheduleDate", "TimeRange", "AddedCount", "HoliFee", "HoliFeeDr", "AppFeeDr", "ASRowId", "ScheduleDateWeek", "RegFeeDr", "Period"];
	var hiddenHeaders = ["预约限额", "加号限额", "加号", "剩号", "诊室码", "激活标志", "排班状态", "加号费", "诊查费", "其他费", "预约费","时段"];
	var columns = new Array();
	var dataRecords = new Array();
	for (var j = 0; j < columnHeaders.length; j++) {
		if (columnHeaders[j] == "预约时间段") {
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
		}else if ((columnHeaders[j] == "正号限额")||(columnHeaders[j] == "可加号数")||(columnHeaders[j] == "已预约数")){
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
			title : "上午：可加号/预约医生列表",
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
		if (columnHeaders[j] == "预约时间段") {
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
		} else if ((columnHeaders[j] == "正号限额")||(columnHeaders[j] == "可加号数")||(columnHeaders[j] == "已预约数")){
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
			title : "下午",
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

//加号
function AddBeforeUpdate() {
	var ret = CheckBeforeAddUpdate();
	if (ret == false) {
		return false
	}
	
	var AdmReason = "";
	var UserID = session['LOGON.USERID'];
	var GroupID = session['LOGON.GROUPID'];
	//推荐人
	var EmployeeNo;
	if (Ext.getCmp('EmployeeNo'))
		EmployeeNo = Ext.getCmp('EmployeeNo').getValue();
	
	if ((EmployeeNo) && (EmployeeNo != "")) {
		var VipFlag = tkMakeServerCall("web.DHCRBAppointment", "IsVipPatient", EmployeeNo);
		if ((VipFlag == "0")) {
			alert("工号录入不正确");
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
					alert("超过最大加号数");
				} else {
					//-201 没有预约资源
					if(ret=="-302"){
					  ret="，超过每人每天相同医生加号限额"
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

//预约
function AppointClickHandler() {
	var ret = CheckBeforeAppoint();
	if (ret == false) {
		return false
	}
	
	var NeedListen = "";
	var AdmReason = "";
	var UserID = session['LOGON.USERID'];
	var GroupID = session['LOGON.GROUPID'];
	//推荐人
	if (Ext.getCmp('NeedListen'))
		NeedListen = Ext.getCmp('NeedListen').getValue();
	var EmployeeNo;
	if (Ext.getCmp('EmployeeNo'))
		EmployeeNo = Ext.getCmp('EmployeeNo').getValue();
	if (EmployeeNo != "") {
		var VipFlag = tkMakeServerCall("web.DHCRBAppointment", "IsVipPatient", EmployeeNo);
		if ((VipFlag == "0")) {
			alert("工号录入不正确");
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
					//AppPrintOut(AppPrintData) //此处调用打印程序
				}
				
			} else {
				//-201 没有预约资源
				if (retArr[0] == "-2001") {
					alert(t['DocAppFial_2001']);
				} else {
					if(ret=="-302"){
					  ret="，超过每人每天相同医生预约限额"
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

//预约之前验证
function CheckBeforeAppoint() {
	//验证病人卡及登记号
	
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
	
	//预约日期限制
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
	//判断是否有出诊记录
	var ScheduleTRangeStr=cspRunServerMethod(GetScheduleTRangeStrMethod,LocId,DocId,StartDate);
	if (ScheduleTRangeStr!="") {
		var ScheduleTRangeAry=ScheduleTRangeStr.split("^");
		for (var i=0;i<ScheduleTRangeAry.length;i++) {
			var TimeRangeItem=ScheduleTRangeAry[i];
			var TimeRangeId=TimeRangeItem.split(String.fromCharCode(2))[0];
			var TimeRangeDesc=TimeRangeItem.split(String.fromCharCode(2))[1];
			var ASRowId=cspRunServerMethod(GetTodayASRowIdByResMethod,LocId,DocId,"",StartDate,TimeRangeId);
			if (ASRowId=="") {
				var conflag=confirm("您在["+StartDate+TimeRangeDesc+"]没有出诊记录,是否按排班模板产生该天的出诊记录?");
				if (conflag) {
					var ASRowId=cspRunServerMethod(GetRapidASRowIdMethod,LocId,"","",StartDate,TimeRangeId,DocId);
					if (ASRowId==""){
						alert("产生["+StartDate+TimeRangeDesc+"]出诊记录失败,请确认是否曾经有过排班?");
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
		//如果没有当前星期的排班记录,则不允许产生,时段已经是通过排班获得,
		var IsScheduleFlag=cspRunServerMethod(GetIsScheduleFlagMethod,LocId,DocId,StartDate);
		if (IsScheduleFlag=="0") {
			alert("您在["+StartDate+"]对应的星期没有排班,不能提前生成出诊记录.");
			return false;
		}else if (IsScheduleFlag=="-1") {
			alert("您在"+StartDate+"对应的排班已经停诊.");
			return false;
		}
	}
	
	return ASRowIdStr;
}
