/**
*FileName:	dhcipbillchargeview.js
*Anchor:	Lid
*Date:	2015-01-10
*Description:	新版住院收费入口 如有疑问联系lid/hujunbin
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

//住院收费配置
var Config = {
	dhcJfConfig : null,
	initConfig: function() {
		//需要引入dhcjfconfig.js
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
	balance: 99999, //平衡金额
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
var clickBillFlag = ""; //结算时判断是否点击了账单

//全局变量押金对象
var DepositSelectObj = {
	loadFlag: false,
	depositArray: [],
	autoSelectFlag: false
}

//界面入口
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
	checkInv(); //设置默认发票号
	//是否链接过来的
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
	initPatListPanel();  //注意位置，要放到最后
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

//初始化查询头面板
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
		//弹出病人全部信息
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
			title: '患者基本信息',
			width: '70%',
			height: '70%',
			closed: true
		});
	});
	
	jQuery("#cardNO").off("keydown").on("keydown", {paramCardType:"cardTypeDR", paramCardNo:"cardNO", paramPatNo:"patientNO"}, cardKeyDownHandler);
}

//添加其他选项卡
function addTabs() {
	initAddDepositTab();
	initRefDepositTab();
	initBillDetailTab();
	initHalfBillTab();
	initHalfBillByOrdTab();
	initDepDetailTab();
	initTarFeeTab();
	initOrdFeeTab();
	//默认病人列表
	jQuery('#chargeTabs').tabs('select', 0);
}


//初始化病人列表
function initPatListPanel() {
	jQuery('#tPatList').datagrid({
		fit:true,
		//width: 'auto',
		//height: 300,	    //jQuery("#tt").tabs("options").height-200,               
		striped: true,  	//是否显示斑马线效果
		singleSelect : true,
		selectOnCheck: false,
		fitColumns: false,
		autoRowHeight: false,
		scrollbarSize: '10px',
		url: null,
		border: false,
		loadMsg: 'Loading...',
		pagination: false, //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers: true,  //如果为true，则显示一个行号列。
		columns:[[  
			{title: '就诊日期', field: 'admdate', halign: "center", width: 84},
			{title: '就诊时间', field: 'admtime', halign: "center", width: 64},
			{title: '费别', field: 'instypedesc', halign: "center", width: 80},
			{title: '科室病区', field: 'locward', halign: "center", width: 260},
			{title: '床号', field: 'beddesc', halign:"center", width: 60},
			{title: '预交金',  field: 'deposit', align: "right", halign:"center", width: 100},
			{title: '总金额', field: 'totalamount', align: "right", halign:"center", width: 100},
			{title: '自付金额',  field: 'patientshare', align: "right", halign:"center", width: 100},
			{title: '医保报销', field: 'ybfee', align: "right", halign: "center", hidden: true},	//先隐藏，具体项目再放开
			{title: '折扣金额', field: 'discountamount', align: "right", halign: "center", width: 80},
			{title: '记账金额', field: 'payorshare', align: "right", halign: "center", width: 80},
			{title: '住院状态', field: 'dischargestatus', halign: "center", width: 80},
			{title: '账单状态',  field: 'paidflag', halign: "center", width: 80},
			{title: '出院日期', field: 'dischargedate', halign: "center", width: 80},
			{title: '出院时间', field: 'dischargetime', halign: "center", width: 80},
			{title: '入院办理人', field: 'admuser', halign: "center", width: 80},
			{title: '住院天数', field: 'zydays', align: "right", halign: "center", width:80},
			{title: '出院办理人',  field: 'disuser', halign: "center", width:80},
			{title: '护士出院办理人', field: 'disdocname', halign: "center", width: 110},
			{title: '审核状态',  field: 'CodingFlag', halign: "center", width: 80},
			{title: '审核日期',  field: 'CodingUPDate', halign: "center", width: 80},
			{title: '审核时间',  field: 'CodingUPTime', halign: "center", width: 80},
			{title: '审核人',  field: 'CodingUPUserDr', halign: "center", width: 80},
			{title: '审核原因',  field: 'CodingReason', halign: "center"},
			{title: '发票号', field: 'invno', halign: "center", width: 80},
			{title: '财务结算日期', field: 'prtdate', halign: "center", width: 120},
			{title: '财务结算时间',  field: 'prttime', halign: "center", width: 120},
			{title: '就诊状态', field: 'visitstatus', halign: "center", hidden: true},
			{title: '账单ID', field: 'pbrowid', halign: "center", width: 80},
			{title: '账单状态',  field: 'pbflag', halign: "center", hidden: true},
			{title: '费别ID', field: 'instypedr', halign: "center", hidden: true},
			{title: 'PAPMIRowID', field: 'patientid', halign: "center", hidden: true},
			{title: '发票ID',  field: 'prtrowid', halign: "center", hidden: true},
			{title: '发票状态', field: 'prtflag', halign: "center", width: 80},
			{title: '就诊号', field: 'episodeid', halign: "center", hidden: false, width: 80},
			{title: '是否转科', field: 'translocFlag', align: "center", halign:"center", hidden: false,width:80,
				formatter:function(value, row, index) {
					if(value == 'Y'){  //增加转科标志  add zhangli  2017-08-03
						return "<a href='javascript:;' onclick=\"openCostInquriy('" + row.pbrowid + "', '" + row.episodeid + "')\">是</a>";
					}else {
						return '否';
					}
				}
			}
		]],
		rowStyler: function(index, row){
			if ((row.dischargestatus == "最终结算") || (row.dischargestatus == "护士办理出院") || (row.dischargestatus == "结束费用调整")){
				return 'color:#FF0000;';
			}
		},
		onBeforeLoad: function(data) {
			var admAry = getEpisodeIdOfPatList();
			var lockRtn = lockAdm("User.OEOrder", admAry, false);
		},
		onLoadSuccess: function(data) {
			DepositSelectObj.depositArray = [];  //清空押金数组
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
					jQuery(this).datagrid("selectRow", 0);  //默认选择第一行
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
			jQuery.messager.alert('错误', '加载患者列表失败.');
		},
		onSelect: function(rowIndex, rowData) {
			DepositSelectObj.depositArray = []; //清空押金数组
			DepositSelectObj.loadFlag = false;
			GlobalObj.initGlobalByData(rowData);
			initLedgerData();
			initPaymListData();
			initPatFeeInfo();
			initDepositData();
			onLoadSuccessPaym();

			//头菜单传值
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
			if(lockRtn){return false;}	//选择的Adm已经被锁定
			
			//如果已经医保结算，把结算按钮变灰
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
			
			//判断是否有发票
			var qualifStatus=getQualifStatus();
			var hasInv = checkInv();
			if ((!hasInv) && (qualifStatus == 0)) {
				jQuery.messager.alert('提示', "您没有可用发票,不能结算.如果结算请先领发票.");
			}
		},
		onRowContextMenu: function(e, rowIndex, rowData) {
			e.preventDefault();
			//如果没选中，先选中
			var row = jQuery(this).datagrid("getSelected");
			if(!row) {
				jQuery(this).datagrid("selectRow", rowIndex);
			}
			//添加右键菜单
			var rtnMenuArr = getAuthMenu(SessionObj.group, "IPBILLRighty");
			if(typeof rtnMenuArr == "string") {
				rtnMenuArr = jQuery.parseJSON(rtnMenuArr);
			}
			
			if(rtnMenuArr != []) {
				try {
					createGridRightyKey(e, 'rightyKey', rtnMenuArr);
				}catch(ex) {
					jQuery.messager.alert("错误", "创建右键菜单失败");
				}
			}
			//判断是不是在同一条记录上右击如果是则不刷新支付方式和押金
			if(rowData.pbrowid != GlobalObj.billId) {
				jQuery(this).datagrid("selectRow", rowIndex);
			}
		},
		onSortColumn: function(sort, order) {
			
		}
	});

	//初始化下拉菜单 如果需要下拉菜单，需要稍微修改initToolMenu方法
	//initChargeMenu();
	initToolMenu();
}

function getEpisodeIdOfPatList(){
	var episodeidAry=new Array();
	var rows = jQuery('#tPatList').datagrid('getRows')//获取当前的数据行
	for (var i = 0; i < rows.length; i++) {
		episodeidAry.push(rows[i]['episodeid']);
	}
	return episodeidAry;
}

//初始化支付方式
function initPaymListPanel() {
	jQuery('#tPaymList').datagrid({ 
		fit: true,
		toolbar: "#pmTool",
		checkOnSelect: false,  //必须设置 此项为点击该行后不选择checkbox,不设置的话会对checkbox的设置有影响
		selectOnCheck: false,  //不必设置 这里设置成false，目的是为了显示的时候不选择上，行颜色为白色而不是黄色的选中状态
		striped: true,  	   //是否显示斑马线效果
		singleSelect: true,
		url: null,
		fitColumns: false,
		autoRowHeight: false,
		cache: false,
		border: false,
		loadMsg: 'Loading...',
		rownumbers: true,  //如果为true，则显示一个行号列。
		columns:[[
			{ title: '支付方式', field: 'CTPMDesc', width: 160,
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
							jQuery.messager.alert("错误", "支付方式列表加载错误");
						},
						onSelect: function(record, row) {
							//选中以后使datagrid处于不可编辑状态
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
								//更新datagrid行的默认信息
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
								//返回第一个被选中的行或如果没有选中的行则返回null。
								var focusCol = "CTPMAmt";
								//payMOnClickCell(editIndex, focusCol, "");
							}
						}
					}
				}
			},
			{ title: '金额', field: 'CTPMAmt',width:120,align:'right',formatter:changeTwoDecimal_f,
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
			{ title: '银行',  field: 'CTPMBank',width:160,
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
							jQuery.messager.alert("错误", "银行列表加载错误");
						},
						onSelect: function(record, row) {
							//选中以后使datagrid银行处于不可编辑状态
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
								//返回第一个被选中的行或如果没有选中的行则返回null。
								var rowData = jQuery('#tPaymList').datagrid('selectRow', editIndex).datagrid('getSelected'); 
								var paymcode = rowData.CTPMCode;
								focusCol = "CTPMCheckno";
								payMOnClickCell(editIndex, focusCol, "");
							}
						}
					}
				}
			},
			{ title: '支行',  field: 'CTPMBankSub', hidden: true
				/*添加支行时使用
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
			{title: '支票/卡号', field: 'CTPMCheckno', width:160, editor:'text'},
			{title: '卡号', field: 'CTPMBankNo', hidden: true, width:160, editor:'numberbox'},
			{title: '支付单位', field: 'CTPMUnit', width: 160, editor:'text'},
			{title: '账户', field: 'CTPMAcount', hidden: true, width:160, editor:'text'},
			{title: '支付方式CODE', field: 'CTPMCode', hidden: true},
			{title: '转账', field: 'pmck', width: 40, checkbox: true, hidden: true},
			{title: '支付方式ID', field: 'CTPMRowID', hidden: true},
			{title: 'ybFlag', field: 'ybFlag', hidden: true},
			{title: 'fixedValue', field: 'fixedValue', hidden: true}
		]],
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			//如果已经医保结算，在加载时把医保信息加载进去
			var ybInfo = getInsuChargeInfo();
			addGridInsuInfo(ybInfo);
			onLoadSuccessPaym();
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "加载支付方式列表错误.");
		},
		onClickCell: function(index, field, value) {
			if(GlobalObj.billId == "") {
				jQuery.messager.alert("提示", "请先选择账单或此病人为新住院病人.");
				return false;
			}
			//编辑时 未账单不可编辑 中途结算的除外 14.11.15
			var hasClickBill = checkBillClick();
			if(!hasClickBill) {
				jQuery.messager.alert("提示", "请先账单.");
				return false;
			}
			var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
			var maxIndex = maxLen - 1;
			//失去焦点事件
			if(field == "CTPMAmt" || field == "CTPMCheckno" || field == "CTPMUnit") {
				clearPaymEvent();
				initPaymEvent();
			}
			//如果是结算过的单击不起作用
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

//初始化台帐信息
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
		loadMsg: 'Loading…',
		rownumbers: true,  //如果为true，则显示一个行号列。
		columns:[[  
			{ title: '分类', field: 'TarDesc1',width: 80},
			{ title: '金额', field: 'TarAmt1' ,width: 80, align: 'right', sortable: true, sorter: numberSort},
			{ title: '分类', field: 'TarDesc2', hidden: true},
			{ title: '金额', field: 'TarAmt2', width: 60, hidden: true, align: 'right'}
		]],
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "加载分类列表错误.");
		}
	});
}

function numberSort(a, b){
	var number1 = parseFloat(eval(a));  
	var number2 = parseFloat(eval(b));  
	return ((number1 > number2) ? 1 : -1);    
}

//初始化按钮面面板
function initButtonPanel() {
	initChargeAmt();
	initChargeBtn();
}

//初始化押金窗口
function initDepositWindow() {
	jQuery("#depositDetailPanel").window({    
		title: "押金明细",
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

//初始化押金面板
function initDepositPanel() {
	jQuery("#tDepositList").datagrid({
		fit: true,
		checkOnSelect: false, //必须设置 此项为点击该行后不选择checkbox,不设置的话会对checkbox的设置有影响
		selectOnCheck: false, //不必设置 这里设置成false，目的是为了显示的时候不选择上，行颜色为白色而不是黄色的选中状态
		striped: true,  	  //是否显示斑马线效果
		singleSelect: false,
		fitColumns: false,
		autoRowHeight: false,
		cache: false,
		loadMsg: '数据加载中……',
		rownumbers: true,  //如果为true，则显示一个行号列。
		url: null,
		columns:[[  
			{ title: 'ck', field: 'ck', checkbox: true},
			{ title: '金额', field: 'TDepAmt', width: 80},
			{ title: '押金单号', field: 'TDepNO', width: 80},
			{ title: '支付方式',  field: 'TDepPayM', width: 80},
			{ title: '收费日期', field: 'TDepPrtDate', width: 80},
			{ title: '收费员', field: 'TUser', width: 80},
			{ title: '结算标志', field: 'TBillFlag', hidden: true,
				formatter:function(value, row, index){
					return +value;
				}
			},
			{ title: '押金状态', field: 'TPrtStatus', width:60},
			{ title: 'TPayMRowid', field: 'TPayMRowid', hidden:true},
			{ title: 'TRcptRowid', field: 'TRcptRowid', hidden:true},
			{ title: 'TBankBackFlag', field: 'TBankBackFlag', hidden:true},
			{ title: 'TRefundNo',  field: 'TRefundNo', hidden:true},
			{ title: 'TPrtStatusFlag', field: 'TPrtStatusFlag', hidden:true},
			{ title: 'PAPMIRowID', field: 'patientid', hidden:true},
			{ title: 'TARRCPTDR',  field: 'TARRCPTDR', hidden:true}
		]],
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			//加载成功后设置选中状态
			jQuery("#depositDetailPanel input:checkbox").removeAttr('disabled'); //清除checkbox状态，需要设置！避免列标题的checkbox保持不可编辑状态
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
							DepositSelectObj.loadFlag=true;		//只设置一次
						}
					}
				}
			});

			if(Config.dhcJfConfig.selYjPayFlag != "Y") {
				jQuery("#depositDetailPanel input:checkbox").attr("disabled", "disabled");
			}
			//如果是最终结算的押金也不可选 14.11.15
			var patlistData = jQuery("#tPatList").datagrid("getSelected");
			if(!patlistData) {
				return false;
			}
			//if(patlistData.dischargestatus == "最终结算") {
			if ((patlistData.dischargestatus == "最终结算")||(patlistData.dischargestatus == "护士办理出院")||(patlistData.dischargestatus == "结束费用调整")){
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
			//add 14.11.15 初始化已选押金默认金额
			//如果不设置会有（如果押金金额为0的话，已选押金会设置成上一个有押金的病人记录的金额）
			//changeDeposit(); //先注释 2015-3-18
			setDepositArray();
			DepositSelectObj.autoSelectFlag = false;
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "加载押金列表错误.");
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
				jQuery.messager.alert("押金列表", pmStr + " : 不可选,请确认该支付方式是否钱已到账.");
			}
			changeDeposit();
		},
		onUncheckAll: function(rows) {
			changeDeposit();
		},
		onCheck: function(index,rowData) {
			var canCheck = canDepositCheck(rowData.TBillFlag);
			if(!canCheck) {
				jQuery.messager.alert("押金列表", "该项不可选,请确认该笔钱是否已到账.");
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

//初始化病人列表数据
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

//初始化支付方式列表数据
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

//初始化押金列表数据
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

//初始化台账列表数据
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

//就诊下拉数据表格
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
		loadMsg: '数据加载中……', 
		rownumbers: true,  //如果为true，则显示一个行号列。
	    idField: 'TadmId',
	    textField: 'TadmLoc',
	    columns:[[    
	        {field: 'TadmId', title:'ID', width: 60},
	        {field: 'TadmDate', title:'就诊时间', width: 140},    
	        {field: 'TadmLoc', title:'就诊科室', width: 120},    
	        {field: 'TadmWard', title:'就诊病区', width: 120},
	       	{field: 'TdisDate', title:'出院时间', width: 120}
	    ]],
	    onLoadSuccess:function(data) {
	    	
	    },
	    onLoadError:function() {
	    	jQuery.messager.alert("就诊", "加载就诊列表失败");
	    },
	    onSelect: function(rowIndex, rowData) {
	    	GlobalObj.clearGlobal();
	    	clearData();
	    	setCurrentAdm();
	    	initPatListData();
	    }
	});
}

//初始化病人就诊列表
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

//结算状态下拉框
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
			text: '全部'
		},{
			id: 'billed',
			text: '未结算'
		},{
			id: 'discharge',
			text: '最终结算'
		},{
			id: 'paid',
			text: '结算历史'
		},{
			id: 'toBill',
			text: '新入院'
		}],
		onSelect: function(record) {
			GlobalObj.clearGlobal();
			clearData();
			setCurrentAdm();
			initPatListData();
		}
	});
}

//初始化卡类型
function initCardType() {
	//卡类型初始化
	jQuery('#cardTypeDR').combobox({
		panelHeight: 80,
		url: QUERY_URL.QUERY_COMBO_URL,
		editable: false,
		multiple: false,
		mode: "remote",
		method: "GET",  //使用POST加载时间较长
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
			//选择时设置读卡按钮灰亮 卡号是否可读
			var recVal = record.value;
			initReadCard(recVal);
		},
		onLoadSuccess:function() { ////14.11.12
			//初始化时设置读卡按钮灰亮 卡号是否可读
			var recVal = jQuery(this).combobox("getValue");
			initReadCard(recVal);
		}
	});
}

///计算应收、应退金额
function calcReceivable(newValue, oldValue){
	var selDepAmt = jQuery("#selDepAmt").numberbox("getValue");
	var patShareAmt = jQuery("#patShareAmt").numberbox("getValue");
	var patInsuAmt = jQuery("#patInsuAmt").numberbox("getValue");
	//应收/应退款 = 自付 - 医保支付 - 押金
	var amt = parseFloat(patShareAmt) - parseFloat(patInsuAmt) - parseFloat(selDepAmt);	
	jQuery("#patStAmt").numberbox("setValue", amt);
	if(amt < 0){
		//应退
		jQuery("#TAmt").numberbox("setValue", (0-amt));
		jQuery("#SAmt").numberbox("setValue", 0);
	}else{
		//应收
		jQuery("#SAmt").numberbox("setValue", amt);
		jQuery("#TAmt").numberbox("setValue", 0);
	}
	//
}

//初始化金额面板
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
	
	//应填金额事件
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

//初始化按钮
function initChargeBtn() {
	jQuery("#insuChargeBtn, #disChargeBtn, #cancelChargeBtn, #cancelInsuBtn, #insuPreChargeBtn").keyup(function(e) {
		var array = ["insuChargeBtn", "disChargeBtn", "cancelChargeBtn", "cancelInsuBtn", "insuPreChargeBtn"];
		buttonKeyUp(e, this, array);
	});
}

//登记号病案号回车事件
function findPatKeyDown(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		getPatInfo();
	}
}

//登记号回车事件
function findPatKeyDownPatNo(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		jQuery("#medicareNO").val("");
		getPatInfo();
	}
}

//病案号回车事件
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
		jQuery.messager.alert("错误", "没有该病人信息");
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
	//全局变量赋值
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

//设置病人基本信息
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

//设置金额信息
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

//清除费用信息
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
	checkInv();     //设置默认发票号
	jQuery("#currentInvId").val("");
}

//添加医保金额
function addGridInsuInfo(ybInfo) {
	if(!ybInfo) {
		return;
	}
	var tmpAry = ybInfo.split("|");
	if (tmpAry[0] != 0){
		disElement("disChargeBtn");	   //医保结算不成功，"出院结算"按钮变灰
		return;
	}
	var CH2 = String.fromCharCode(2);
	//1,首先判断页面上是否已经有了医保要添加的支付方式
	//2,如果有改变原来的值，没有的话再添加
	var myIndex = 0;
	var myInsuAmt = 0;
	var insuChargeFlag = true;
	var insuPmErrStr = '';
	var insuPmLen = ybInfo.split(CH2).length;
	for (var i = 1; i <= insuPmLen - 1; i++) {
		var pmId = ybInfo.split(CH2)[i].split("^")[0];
		var pmAmt = ybInfo.split(CH2)[i].split("^")[1];
		var checkInfo = checkPmExist(pmId);          //判断页面上是否已经有了医保要添加的支付方式
		var checkFlag = checkInfo.split("^")[0];     
		var checkAmt = checkInfo.split("^")[1];
		var checkIndex = checkInfo.split("^")[2];
		var checkYbFlag = checkInfo.split("^")[3];    //是否医保支付标识
		if ((checkFlag == '1') && (checkYbFlag == 'Y')) {
			return;
		} else {
			//获取code和desc
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
				index: 0,	//索引从0开始
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
	//更新医保金额
	myInsuAmt = parseFloat(myInsuAmt).toFixed(FIXEDNUM);
	jQuery("#patInsuAmt").numberbox("setValue", myInsuAmt);
	//改变默认金额的值、平衡金额的值(支付方式)
	onLoadSuccessPaym();

	if(!insuChargeFlag) {
		jQuery.messager.alert("Error", "医保结算支付方式" + insuPmErrStr + "在HIS系统中不存在，请联系信息科！");
		return false;
	}
	return true;
}

//判断某个支付方式在支付方式列表上是否存在
//若存在时的金额及Index
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

//删除医保支付方式
function delGridInsuInfo() {
	var insuIndexArr = new Array();
	var allRows = jQuery("#tPaymList").datagrid("getRows");  //所有行
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
	//改变默认金额的值、平衡金额的值(支付方式)
	onLoadSuccessPaym();
}

//更多查询按钮事件
function searchClick() {
	jQuery("#chargeSearchPanel").window({    
		title: "多条件查询",
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
			//+2017-05-25 ZhYW 初始化Panel后加载数据
			initPatListDataBySearch();
		},
		onClose: function() {
		}
	});
}

//清屏
function clearClick() {
	GlobalObj.clearGlobal();
	clearTopInfo();
	initPatListData();
	clearData();
	setFocus("patientNO");
}

//获取就诊列表里的当前就诊
function setCurrentAdm() {
	var episodeId = "";
	if(jQuery("#admList[class='combogrid-f combo-f']").length) {
		episodeId = jQuery("#admList").combogrid("getValue");
	}
	GlobalObj.initGlobal(GlobalObj.patientId, episodeId, GlobalObj.billId, GlobalObj.prtId);
	setBaseInfo(episodeId, "", "");
}

//设置当前默认下拉列表
function setCurrAdmList() {
	if(jQuery("#admList[class='combogrid-f combo-f']").length) {
		var currAdm = GlobalObj.episodeId;
		jQuery("#admList").combogrid("setValue", currAdm);
	}
}

//设置平衡金额
function setBalance() {
	//改变平衡金额的值（支付方式）
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

//设置必填金额
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
				//弹出提示tip，现在注释，不删
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

//取默认支付方式费用
function getDefPaymSum() {
	var deposit = jQuery("#selDepAmt").numberbox("getValue"); //已选押金
	var patShare = jQuery("#patShareAmt").numberbox("getValue");  //自付金额
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



//支付方式列表加载成功后
function onLoadSuccessPaym() {
	var data = jQuery("#tPaymList").datagrid("getData");
	var defPaymStr = getDefPaym();
	var defPaymArr = defPaymStr.split("^");
	var defPaymDr = defPaymArr[0];
	var defPaymDesc = defPaymArr[1];
	var defAmt = getDefPaymSum();  //取默认应交费用
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
			//判断当前默认支付方式是否有值，如果有值默认+该值
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
	//改变平衡金额的值（支付方式）
	setBalance();
}

//失去焦点事件
function onPaymBlur() {
	//取消事件 不然会造成循环递归
	//clearPaymEvent();
	if(editIndex != undefined) {
		//jQuery("#tPaymList").datagrid("endEdit", editIndex);
		//editIndex = undefined;
	}
}

//keyup事件
function onPaymKeyDown(e) {
	e = e || window.event;
	if(e.keyCode == 189) {  //numberbox不能输入两个负号，当原有值为负数时清空一下
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:editIndex,field:"CTPMAmt"});
		if(ed) {
			jQuery(ed.target).numberbox("setValue", "-");
		}
	}

	if(e.keyCode == 13) {
		clearPaymEvent();
		if(editIndex != undefined) {
			/*
			//如果有必填项，默认到银行必填项
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
			//没有必填项，默认到下一行的金额
			var nextIndex = editIndex + 1;
			var ed = jQuery('#tPaymList').datagrid('getEditor', {index:editIndex,field:"CTPMAmt"});
			if(ed) {
				//升级到jQuery2 后IE11 回车通过nuberbox("getValue")获取不到值
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

//支付方式列表中的所有在编辑状态的单元格endEdit
function endEditAllPaym() {
	//14.11.21 加判断，防止报错
	if(jQuery("#tPaymList").length > 0) {
		var allPaymRow = jQuery("#tPaymList").datagrid("getRows");
		jQuery.each(allPaymRow, function(index, value) {
			jQuery("#tPaymList").datagrid("endEdit", index);	
		});
	}
}

//获取收退金额
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

//获取当前所有支付方式的和
function getPaymAll() {
	var paymAll = 0;
	var allRows = jQuery("#tPaymList").datagrid("getRows");  //所有行
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
*包含开头和结尾的值
*beginIndex:开始索引；endIndex:结束索引;
*inArr:包含的数组；outArr:结束的数组
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

//获取收退现金额
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

//计算收退金额
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

//判断焦点位置，是出院结算还是医保结算
function setChargeFocus() {
	var fous = 1;
	if(focus) {
		setFocus("insuChargeBtn");
	}else {
		setFocus("disChargeBtn");
	}
}

//判断未到账押金是否可选
function canDepositCheck(flag) {
	if(flag == 0) {
		return false;
	}else {
		return true;
	}
}

//改变押金时，计算费用
function changeDeposit() {
	//改变押金列表时
	
	//1 设置已选金额
	//2 清空支付方式列表
	//3 改变默认支付方式金额
	//4 同时更新病人基本信息里的应收应退
	
	//1 取已选押金
	if(jQuery("#selDepAmt").length) {
		var ckDep = getCheckDepositSum();
		jQuery("#selDepAmt").numberbox("setValue", ckDep);
	}
	//2 清空支付方式列表的值
	if(DepositSelectObj.autoSelectFlag === false) {
		clearLeftRow(0);
		onLoadSuccessPaym();
	}

	//3 取选中的押金金额改变应收应退
	var balanceAmt = getStAmt();
	balanceAmt = parseFloat(balanceAmt).toFixed(FIXEDNUM);

	//4 改变平衡金额的值（支付方式）
	var pmAll = getPaymAll();
	pmAll = parseFloat(pmAll);
	var pmBalance = balanceAmt - pmAll;
	pmBalance = parseFloat(pmBalance).toFixed(FIXEDNUM);
	GlobalObj.initBalance(pmBalance);
	
	//设置必填金额
	setTipAmt();
	var hasClickBill = checkBillClick();
	if(hasClickBill && DepositSelectObj.autoSelectFlag === false) {
		setPaymListFocus();
	}
}

//改变押金时，计算费用
function changeDepositOld() {
	//改变押金列表时
	//1,改变平衡金额的值（支付方式）
	//2,同时更新病人基本信息里的应收应退
	//3,设置已选金额
	
	//1 取选中的押金金额改变应收应退
	var balanceAmt = getStAmt();
	balanceAmt = parseFloat(balanceAmt).toFixed(FIXEDNUM);

	//2 改变平衡金额的值（支付方式）
	var pmAll = getPaymAll();
	pmAll = parseFloat(pmAll);
	var pmBalance = balanceAmt - pmAll;
	pmBalance = parseFloat(pmBalance).toFixed(FIXEDNUM);
	GlobalObj.initBalance(pmBalance);
	
	//取已选押金
	if(jQuery("#selDepAmt").length) {
		var ckDep = getCheckDepositSum();
		jQuery("#selDepAmt").numberbox("setValue", ckDep);
	}
	
	setBalance();
	//设置必填金额
	setTipAmt();
}

//获取选择的押金金额
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

//设置选择的押金数组
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

//获取押金ID是否存在
function checkDepInArr(depId) {
	var depositArray=DepositSelectObj.depositArray;
	if(jQuery.isArray(depositArray) && jQuery.inArray(depId, depositArray) != -1) {
		return true;
	}
	return false;
}

//判断是否账单
function checkBillClick() {
	
	return true; //Lid 2018-03-27 交付中心要求,在输入登记号后,查询出病人信息时,直接账单,不用每次点击结算时再账单,方便收费员操作
	
	//add 14.11.15 判断是否是中途结算的，中途结算的不需要账单
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

//支付方式blur事件和keydown事件
function initPaymEvent() {
	//jQuery("#layoutPaym").delegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text","blur", onPaymBlur);
	//jQuery("#layoutPaym").delegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown", function(e){onPaymKeyDown(e)});
	jQuery("#layoutPaym").delegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text","blur", onPaymBlur);
	jQuery("#layoutPaym").delegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown", function(e){onPaymKeyDown(e)});
	jQuery("#layoutPaym").delegate("[field='CTPMCheckno'] [class='datagrid-editable-input']", "blur", onPaymBlur);
	jQuery("#layoutPaym").delegate("[field='CTPMUnit'] [class='datagrid-editable-input']", "blur", onPaymBlur);
}

//清除支付方式blur和keydown事件
function clearPaymEvent() {
	//jQuery("#layoutPaym").undelegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text","blur");
	//jQuery("#layoutPaym").undelegate("#tPaymList td[field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown");
	jQuery("#layoutPaym").undelegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f.validatebox-text", "blur");
	jQuery("#layoutPaym").undelegate("#tPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f,.validatebox-text", "keydown");
	jQuery("#layoutPaym").undelegate("[field='CTPMCheckno'] [class='datagrid-editable-input']", "blur");
	jQuery("#layoutPaym").undelegate("[field='CTPMUnit'] [class='datagrid-editable-input']", "blur");
}

//单击支付方式单元格
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
				//弹出提示tip，现在注释，不删
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

//单元格是否可编辑
function isCellAllowedEdit(index, field, value) {
	var bool = true;	//默认能编辑
	var rowData = jQuery('#tPaymList').datagrid('selectRow',index).datagrid('getSelected'); //返回第一个被选中的行或如果没有选中的行则返回null。
	var paymcode = rowData.CTPMCode;
	var ybFlag = rowData.ybFlag;
	var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
	var maxIndex = maxLen - 1;
	//医保支付方式不能编辑
	if(ybFlag != undefined && ybFlag == 'Y'){
		bool = false;	
	}
	if(GlobalObj.billId == "") {
		return false;
	}
	//走配置 支付方式不能编辑
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

//根据卡类型格式化卡号 打算写到公共js里
//paramCardType和paramCardNo,paramPatNo传入的是元素的ID
//下拉框元素ID,卡号元素ID,登记号元素ID
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
	   				alert("卡无效!");
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
						//jQuery.messager.alert("卡无效", "卡无效");
						//return;
						alert("卡无效");
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
*加载DataGrid数据
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
*加载ComboGrid数据
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;
	grid.datagrid('load', queryParams);
}

//获取授权菜单JSON
function getAuthMenu(group, menuPar) {
	var rtnMenuArr = tkMakeServerCall("web.UDHCJFBILLMENU", "getSubListToJson", menuPar, group);
	return rtnMenuArr;
}

/**
*创建右键菜单
*/
function createGridRightyKey(event, target, menuBtnArr) {
	//没有授权菜单 不创建
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
					disabled: false,  //平台接口
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
*初始化下拉菜单
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
			jQuery.messager.alert("错误", "创建下拉菜单失败");
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
		var listBtnId = 'list-btn-' + code;																							//平台接口
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
				disabled: false //平台接口
			});
		}
	});
}

//工具菜单
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
			jQuery.messager.alert("错误", "创建工具菜单失败："+ex.message);
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

//设置默认下拉框值
function setListDefVal(id) {
	if(id == "" || id == undefined) {
		id = '';
	}
	jQuery('#chargeStatus').combobox('setValue', id);
}

//设置默认焦点
function setFocus(id) {
	if(jQuery("#" + id).length) {
		jQuery("#" + id).focus();
	}
}

//读卡 14.11.12
function readCardClick() {
	var recVal = jQuery("#cardTypeDR").combobox("getValue");
	if(recVal == "") {
		return;
	}

	var recValArr = recVal.split("^");
	var cardTypeDR = recValArr[0];
	var myrtn = DHCACC_GetAccInfo(cardTypeDR,recVal);
	if(myrtn == "-200") {
		jQuery.messager.alert("读卡", "无效卡或未插卡");
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
			alert("卡无效");
			break;
		case "-201":
			jQuery("#patientNO").val(myary[5]);
			jQuery("#cardNO").val(myary[1]);
			getPatInfo();		
			break;
		default:
	}
}

//初始化卡类型时卡号和读卡按钮的变化 14.11.12
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

//控制按钮灰亮 14.11.12
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

//控制按钮灰亮 14.11.12
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

//结算按钮焦点 按钮事件
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

//设置默认的支付方式列表的焦点
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

//设置支付方式下一行的金额
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

//获取编辑框底下是否已经设置
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

//点击应填金额时 自动填充到正在编辑的单元格
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


//扩展单击单元格
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

//初始化Tab面板事件
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
					jQuery.messager.alert("交押金", "请选择病人");
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
					jQuery.messager.alert("费用清单", "请选择病人!!");
					jQuery(this).tabs('select', 0);
					return false;
				}

				initBillDetailTab();
			}
			if(panelID == "halfBillTab") {
				if(billId == "") {
					jQuery.messager.alert("中途结算", "账单为空,不允许拆分账单.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var billInfo = getBillBaseInfo();
				if(billInfo == "") {
					jQuery.messager.alert("中途结算", "账单信息获取失败.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var billFlag = billInfo.split("^")[15];
				if(billFlag == "P") {
					jQuery.messager.alert("中途结算", "此账单已经结算,不能拆分账单.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				//判断医保病人是否能够中途结算
				var canHarfForInsu = canHarfBillForInsu();
				if(!canHarfForInsu) {
					jQuery.messager.alert("中途结算", "该患者为医保患者,不能中途结算.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var num = getBillNum();
				num = parseInt(num);
				if(num > 1) {
					jQuery.messager.alert("中途结算", "病人有多个未结账单,不允许拆分账单.");
					jQuery(this).tabs('select', 0);
					return false;
				}else if(num == 1) {
					//中途结算窗口
					//判断是否有tab，没有的话创建，有的话打开
					var billedFlag = billClick();
					initHalfBillTab();
				} else if(num == 0) {
					jQuery.messager.alert("中途结算", "病人没有未结账单.");
					return false;
				} else {
					jQuery.messager.alert("中途结算", "返回值：" + num);
					return false;
				}
			}

			if(panelID == "halfBillByOrdTab") {
				if(billId == "") {
					jQuery.messager.alert("拆分账单", '此病人没有账单,不能拆分账单');
					jQuery(this).tabs('select', 0);
					return false;
				}
				var billInfo = getBillBaseInfo();
				var billFlag = "";
				if(billInfo == "") {
					jQuery.messager.alert("拆分账单", "账单信息获取失败.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				billFlag = billInfo.split("^")[15];
				if(billFlag == "P") {
					jQuery.messager.alert("拆分账单", '此账单已经结算,不能拆分账单');
					jQuery(this).tabs('select', 0);
					return false;
				}
				//判断医保病人是否能够中途结算
				var canHarfForInsu = canHarfBillForInsu();
				if(!canHarfForInsu) {
					jQuery.messager.alert("拆分账单", "该患者为医保患者,不能中途结算.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				var num = getBillNum();
				num = parseInt(num);
				if(num > 1) {
					jQuery.messager.alert("拆分账单", "病人有多个未结算账单不允许拆分账单.");
					jQuery(this).tabs('select', 0);
					return false;
				}
				//判断是否有tab，没有的话创建，有的话打开
				initHalfBillByOrdTab();
			}
			if(panelID == "searchDepDet") {
				if (episodeId == "") { //((billId == "") || (episodeId == "")) {
					jQuery.messager.alert("押金明细", "就诊为空！");
					jQuery(this).tabs('select', 0);
					return false;
				}
				initDepDetailTab();
			}
			if(panelID == "searchTarFee") {
				if (billId == "") {
					jQuery.messager.alert("收费项目", "账单号为空！");
					jQuery(this).tabs('select', 0);
					return false;
				}

				initTarFeeTab();
			}
			if(panelID == "searchOrdFee") {
				if (billId == "") {
					jQuery.messager.alert("医嘱费用", "账单号为空！");
					jQuery(this).tabs('select', 0);
					return false;
				}

				initOrdFeeTab();
			}
			if(panelID == "admOrderFee") {
				if(episodeId == "") {
					jQuery.messager.alert("医嘱费用", "就诊为空，请选择就诊！");
					jQuery(this).tabs('select', 0);
					return false;
				}
				initAdmOrderFeeTab();
			}
		}
	});
}

//交押金Tab
function initAddDepositTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + GlobalObj.episodeId + '&deposittype=' + '' + '&TabLinkFlag=' + 'Y';
	addOneTab("chargeTabs", "addDepositTab", "交押金", url);
}

//退押金
function initRefDepositTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFRefundDeposit&Adm=' + GlobalObj.episodeId + '&TabLinkFlag=' + 'Y';
	addOneTab("chargeTabs", "refDepositTab", "退押金", url);
}

//病人费用明细
function initBillDetailTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + GlobalObj.billId;
	addOneTab("chargeTabs", "billDetailTab", "患者费用明细", url);
}

//中途结算
function initHalfBillTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFIntPay&BillNo=' + GlobalObj.billId;
	addOneTab("chargeTabs", "halfBillTab", "中途结算", url);
}

//医嘱拆分账单
function initHalfBillByOrdTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBILLOEORIItemGroup&EpisodeID=' + GlobalObj.episodeId + '&BillNo=' + GlobalObj.billId + '&Guser=' + SessionObj.guser;
	addOneTab("chargeTabs", "halfBillByOrdTab", "医嘱拆分账单", url);
}

//押金明细查询
function initDepDetailTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&BillNo=' + GlobalObj.billId + "&Adm=" + GlobalObj.episodeId;
	addOneTab("chargeTabs", "searchDepDet", "押金明细查询", url);
}

//收费项目查询
function initTarFeeTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFItmDetail&BillNo=' + GlobalObj.billId;
	addOneTab("chargeTabs", "searchTarFee", "收费项目查询", url);
}

//医嘱费用查询
function initOrdFeeTab() {
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdDetail&BillNo=' + GlobalObj.billId+"&EpisodeID=" + GlobalObj.episodeId;
	addOneTab("chargeTabs", "searchOrdFee", "医嘱费用查询", url);
}

//医嘱费用查询（Order）
function initAdmOrderFeeTab() {
	var url = 'dhcbill.ipbill.patordfee.csp?EpisodeID=' + GlobalObj.episodeId;
	addOneTab("chargeTabs", "admOrderFee", "医嘱费用查询", url);
}

//添加tab面板
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

//链接组件
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

//获取iframe里的元素
function getIframeElement(iframeId, elementId) {
	var iframeWin = document.getElementById(iframeId).contentWindow;
	var elementObj = iframeWin.document.getElementById(elementId);
	return elementObj;
}

//iframe 调用父窗口方法来跳转到病人列表 
function setDefTabFromIframe() {
	jQuery("#chargeTabs").tabs("select", 0);
}

//锁定/解锁就诊记录
//flag：锁类型(默认和医生站相同)
//admAry:就诊记录数组
//isLock：true:加锁,false:解锁
//返回值：true:有锁定adm，false：无锁定adm
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

//过滤数组中的重复元素
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
		title: '患者科室费用查询',
		width: '90%',
		height: '85%',
		closed: true
	});
}