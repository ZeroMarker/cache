/*
 * FileName:	dhcbill.pkg.nurseconfirm.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: 护士确认套餐
 */
 
 var GV={
	ADM:'',
	BILL:'',
	PAPMI:'',
	PACKAGEID:''
}

$(function () {
	$('#RegNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		patientNoKeydown(event);
  		}
	})
	$('#MedicalNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		MedicalNoKeydown(event);
  		}
	})
	init_dg();
	init_ArcItm();
	init_ArcCat();
	init_CTLoc();
	initAdmList();
	setValueById('StartDate',getDefStDate(-31));
	setValueById('EndDate',getDefStDate(31));
});

function init_CTLoc(){
	// 开单科室
	$HUI.combobox('#CTLoc',{
		panelHeight: 150,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array&desc=&gLoc=" + PUBLIC_CONSTANT.SESSION.CTLOCID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			initLoadGrid();
		},
		onChange: function (newValue, oldValue) {
		}		
	})	
	//接收科室
	$HUI.combobox('#recDep',{
		panelHeight: 150,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array&desc=&gLoc=" + PUBLIC_CONSTANT.SESSION.CTLOCID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			initLoadGrid();
		},
		onChange: function (newValue, oldValue) {
		}		
	})		
	
}
function init_ArcItm(){
	$HUI.combobox("#ArcItm",{	
		valueField:'ItemDr',
		textField:'ItemDesc',
		url:$URL,
		onBeforeLoad:function(para){
			para.ClassName='BILL.PKG.BL.NoDiscountsConfig';
			para.QueryName='QueryNoDiscountsConfig';
	  		para.OrdCatDr='';
	  		para.OrdCatSubDr='';
	 		para.ArcItmDr='';
	 		para.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
	 		para.ResultSetType='Array';
		},	
		onLoadSuccess:function(){
				
		},
		onLoadError:function(err){

		},
		onSelect:function(rec){
			
		}	
	})
}
function init_ArcCat(){
	$HUI.combobox('#ArcCat',{
			valueField:'ordcatid',
			textField:'ordcat',
			url:$URL,
			defaultFilter:4,
			onBeforeLoad:function(param){
				param.ResultSetType='Array';
				param.ClassName='web.UDHCJFORDCHK';
				param.QueryName='ordcatlookup';	
			},
			onSelect:function(rec){
				initLoadGrid();
			}	
		
		
	})	
}
/*
 * 护士套餐确认Dg
 */
function init_dg() {
	var dgColumns = [[
			{field:'execDatTime',title:'执行时间',width:220},
			{field:'billTotalAmt',title:'金额',width:150,align:'right'},
			{field:'billQty',title:'账单数量',width:100 },
			{field:'execStDatTime',title:'要求执行时间',width:150 },
			{field:'execStatus',title:'执行状态',width:150},
			{field:'billFlag',title:'账单状态',width:150},
			{field:'ordItm',title:'医嘱rowid',width:150},
			{field:'pboRowId',title:'账单医嘱ID',width:150},
			{field:'oeore',title:'执行记录ID',width:220},
			{field:'itmCatDesc',title:'医嘱大类',150:150},
			{field:'execUserName',title:'执行人',width:150},
			{field:'recDeptName',title:'接收科室',width:150 },
			{field:'userDeptName',title:'开单科室',width:150},
			{field:'RemainingQty',title:'剩余数量',width:150}
		]];
	$('#dg').datagrid({
		//idField:'ordItm',
		fit: true,
		border: false,
		striped: true,
		rownumbers: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		///pageList: [9999],
		columns: dgColumns,
		frozenColumns: [[
							{title: 'ck', field: 'ck', checkbox: true},
							{field:'arcimDesc',title:'医嘱名称',width:220},
							{field:'ProductFlag',title:'套餐标识',width:150,
								formatter:function(value,data,row){
									return  value=='1' ? value='套餐内': '套餐外';
								},
								styler:function(value,row,index){
									return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}
							},
						]],					
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
		},
		onCheck:function(index,rowData){
		},
		onCheckAll:function(data){
		}	
	});
}
/*
 * 加载Datagrid
 */
function initLoadGrid(){
	var queryParam={
		ClassName:'BILL.PKG.BL.PackageConfirmation',
		QueryName:'FindProOrdDetail',
		episodeId:GV.ADM,
		itmCateId:getValueById('ArcCat'),
		arcimId:getValueById('ArcItm'),
		recDeptId:getValueById('recDep'),
		userDeptId:getValueById('CTLoc'),
		stDate:getValueById('StartDate'),
		endDate:getValueById('EndDate'),
		billStatus:''
	}
	loadDataGridStore('dg',queryParam);		
}
/*
 * 查询
 */
$('#BtnFind').bind('click', function () {
	FindClick();
});
function FindClick() {
	initLoadGrid();
}

/*
 * 清屏
 */
$('#BtnClear').bind('click', function () {
	clear_Click();	
})
function clear_Click(){
	var GV={
		ADM:'',
		BILL:'',
		PAPMI:'',
		PACKAGEID:''
	}
	refreshBar('','');
	$("#searchTable").form("clear");
	initLoadGrid();	
}
/*
 * 修改
 */
$('#BtnUpdate').bind('click', function () {
	var OEOREStr=getOEOREStr();
	if(OEOREStr==''){
		$.messager.alert('提示','没有可以更新的数据','info');	
		return;
	}
	$.m({
		ClassName: "BILL.PKG.BL.PackageConfirmation",
		MethodName: "UpdateOrdExecByExeStr",
		OEExcStr:OEOREStr, 
		Guser:PUBLIC_CONSTANT.SESSION.USERID, 
	}, function(rtn){
		if(rtn.split('^')[0]=='0'){
				$.messager.alert('提示','匹配成功','info');	
			}else{
				$.messager.alert('提示','匹配失败rtn='+rtn,'error');		
			}
			initLoadGrid();
	});

});
/*
 * 套餐确认自动匹配
 */
$('#BtnSave').bind('click', function () {
	$.messager.confirm('确认','是否进行自动匹配?',function(r){
		if(r){
			$.m({
				ClassName: "BILL.PKG.BL.PackageConfirmation",
				MethodName: "AutoPackageConfirm",
				AdmDr:GV.ADM, 
				Guser:PUBLIC_CONSTANT.SESSION.USERID,
			}, function(rtn){
				if(rtn.split('^')[0]=='0'){
					$.messager.alert('提示','匹配成功','info');	
				}else{
					$.messager.alert('提示','匹配失败rtn='+rtn,'error');		
				}
				initLoadGrid();
			});		
		}	
	})			
});
/*
 * 套餐取消自动匹配
 */
$('#BtnCancel').bind('click', function () {
	$.messager.confirm('确认', '您确认想要取消匹配的数据吗？', function (r) {
		if (r) {
			$.m({
				ClassName: "BILL.PKG.BL.PackageConfirmation",
				MethodName: "CancelAutoPackageConfirm",
				AdmDr:GV.ADM, 
				Guser:PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn.split('^')[0] == "0") {
					$.messager.alert('提示', "取消成功", 'success',function(){	
					});
				} else {
					$.messager.alert('提示', "取消失败，错误代码：" + rtn, 'error',function(){	
					});
				}
				initLoadGrid();
			});
		}
	});
});

$('#BtnFind').bind('click', function () {
	FindClick();
});


function FindClick() {
	initLoadGrid();
}
/*
 * 账单
 */
$('#BtnBill').bind('click', function () {
	billClick();
});
/*
 * 账单  
 */
function billClick() {
	if(GV.ADM === "") {
		$.messager.alert('账单','请选择就诊记录','info');
		return false;
	} else {
		var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getmotheradm", GV.ADM);
		if(rtn === "true") {
			$.messager.alert('账单', '此病人为婴儿不允许做账单.','info');
			return false;
		}
		var computerName = '';//getComputerName();
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", GV.ADM, PUBLIC_CONSTANT.SESSION.HOSPID, GV.BILL, computerName);
		if(rtn == 0) {
			$.messager.alert('账单', '账单成功', "info", function() {
				initLoadGrid();
			});
		} else if(rtn == "AdmNull") {
			$.messager.alert('账单', "就诊号不能为空.",'info');
			return false;
		} else if(rtn == "PBNull") {
			$.messager.alert('账单', '账单号为空,账单失败.','info');
			return false;
		} else if(rtn == "OrdNull") {
			$.messager.alert('账单', '病人没有医嘱,不能账单.','info');
			return false;
		} else if(rtn == "2") {
			$.messager.alert('账单', '同时存在两个未付账单,不允许做账单.','info');
			return false;
		} else {
			$.messager.alert('账单', '账单失败.','info');
			return false;
		}
	}

	return true;
}
/**
* 就诊下拉数据表格
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		idField: "TadmId",
		textField: "TadmLoc",
		columns: [[{field: "TadmId", title: "就诊号",width: 100}, 
				   {field: 'TadmDate',	title: '就诊时间', width: 150},
				   {field: 'TadmLoc', title: '就诊科室', width: 90},
				   {field: 'TadmWard', title: '就诊病区', width: 130},
				   {field: 'TdisDate', title: '出院时间', width: 150}
			]],
		onLoadSuccess:function(data) {
			var admGrid=$('#admList').combogrid('grid');
			if(admGrid.datagrid('getRows').length>0){
				admGrid.datagrid('selectRow',0)	
			}			
	    },
		onSelect: function (rowIndex, rowData) {
			GV.ADM=rowData.TadmId;
			initLoadGrid();
		}
	});
	loadAdmList();
}

/**
* 加载就诊列表
*/
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "searchAdm",
		papmi: GV.PAPMI
	}
	loadComboGridStore("admList", queryParams);
}
/*
 * 登记号回车
 */
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = $(e.target).val();
		if (!patientNo) {
			return;
		}
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: patientNo,
			HOSPID: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (rtn) {
			clear_Click();
			$(e.target).val(rtn);
			getPatInfo();
		});
	}
}
/*
 * 获取患者信息
 */
function getPatInfo() {
	var patientNo = getValueById('RegNo');
	var MedicalNo = getValueById('MedicalNo');
	///alert("patientNo="+patientNo)
	$.m({
		ClassName: 'BILL.PKG.COM.PatInfo',
		MethodName: 'GetPatInfo',
		patNO: patientNo,
		Medical:MedicalNo
	}, function (rtn) {
		///alert("rtn="+rtn)
		var myAry = rtn.split('^');
		if (!myAry[0]) {
			GV.PAPMI='';
			$.messager.alert('提示', '登记号错误', 'error');
		} else {
			GV.PAPMI=myAry[0];
			setValueById('RegNo',myAry[1]);
			setValueById('MedicalNo',myAry[2]);
			refreshBar(GV.PAPMI,'');
			loadAdmList();
		}
	});
	/*
	$.m({
		ClassName: 'web.UDHCJFBaseCommon',
		MethodName: 'GetCardNOByPAPMI',
		patNO: patientNo,
		papmiDr: '',
		adm: ''
	}, function (rtn) {
		var myAry = rtn.split('^');
		if (!myAry[1]) {
			GV.PAPMI='';
			$.messager.alert('提示', '登记号错误', 'error');
		} else {
			GV.PAPMI=myAry[1];
			refreshBar(GV.PAPMI,'');
			loadAdmList();
		}
	});*/
}
/*
 * 获取勾选的执行记录串
 */
function getOEOREStr(){
	var OEOREStr='';
	var selectRowData=$('#dg').datagrid('getChecked');
	$.each(selectRowData,function(index, row){
		OEOREStr==''?OEOREStr=row.oeore:OEOREStr=OEOREStr+'^'+row.oeore;
	})
	return OEOREStr;
}
/*
 * 初始化套餐
 */
function init_PackageDesc(){
	$HUI.combogrid('#PackageDesc',{
		panelWidth:500,   
	    editable:true,
	    panelHeight:300,  
      	fit: true,
     	pagination: true,
      	singleSelect: true,
      	multiple: false,
        onBeforeLoad:function(param){
	        param.ClassName='BILL.PKG.BL.Coupon';
	        param.QueryName='FindProductInfoByPatDr';
	        param.PatDr=GV.PAPMI;
		},
		url: $URL,
		idField: 'PatProRowId',
		textField: 'ProDesc',
		columns: [[
			{field:"ProDesc",title:"套餐名称",width:100},
			{field:"ProRefundStandard",title:"退费标准",width:80},
			{field:"ProIndependentpricing",title:"是否自主定价",width:100,
				formatter:function(value,rowData,index){
					return value==0?value="否":value="是"
				}
			},
			{field:"ProSalesPrice",title:"售价",width:100,align:'right'},
			{field:"ProPrice",title:"标准价格",width:100,align:'right'},
			{field:"PatProRowId",title:"客户套餐ROWID",width:100,hidden:true},

		]],
		onSelect:function(index,rowData){
			GV.PACKAGEID=rowData.PatProRowId		    
		},
	})	
}
/*
 * 住院号回车
 */
function MedicalNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var PatMedicare = $(e.target).val();
		if (!PatMedicare) {
			return;
		}
		getPatInfo();
	}
}