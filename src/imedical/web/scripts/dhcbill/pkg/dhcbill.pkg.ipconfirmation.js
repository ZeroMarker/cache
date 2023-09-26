/*
 * FileName:	dhcbill.pkg.ipconfirmation.js
 * User:		tangzf
 * Date:		2019-09-23
 * Function:	
 * Description: 住院套餐确认
 */
var GV={
	ADM:'',
	BILL:'',
	PAPMI:'',
	PACKAGEID:'',
	editRowIndex:-1,
	FixFlag:'' ,//是否进行过灵活折扣 1 : 已经进行过灵活折扣
	deleteStr:'', // 删除的灵活折扣串
	OrdExItms:{}  ,//医嘱执行记录
	EditIndex: undefined,
	curRowIndex:-1,
    curRow:{},
    curVal:0.0,
    ed:{},
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
	init_CTLoc();
	initAdmList();
	
	//初始化折扣金额
	$('#DiscAmt').numberbox({
		precision:2,
		min:0
	})
	/*
	// 套餐外折扣金额事件 (只有未进行过折扣的才可以操作)
	if(GV.FixFlag!='1'){
		$("#DiscAmt").keyup(function(e){ 
			if(e.keyCode===13){
				calDatagridRate(this.value);	
			}
		
		})
		$('#DiscAmt').bind('change',function(){
				calDatagridRate(this.value);
	  		
		})
	}
	*/
	///init_DiscReason();
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
	
}
/*
 * 
 */
function init_dg() {
	var dgColumns = [[
			{field:'billTotalAmt',title:'金额',width:150,align:'right'},
			{field:'billPashareAmt',title:'自付金额',width:150,align:'right'},
			{field:'billQty',title:'账单数量',width:100 },			
			{field:'Amt',title:'优惠金额',width:150 ,align:'right',
				/*editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}*/
			},
			{field:'execStDatTime',title:'要求执行时间',width:220 },
			{field:'execDatTime',title:'执行时间',width:220},
			{field:'execStatus',title:'执行状态',width:150},
			{field:'billFlag',title:'账单状态',width:150},
			{field:'ordItm',title:'医嘱rowid',width:150},
			{field:'pboRowId',title:'账单医嘱ID',width:150},
			{field:'oeore',title:'执行记录ID',width:220},
			{field:'itmCatDesc',title:'医嘱大类',150:150},
			{field:'execUserName',title:'执行人',width:150},
			{field:'recDeptName',title:'接收科室',width:150 },
			{field:'userDeptName',title:'开单科室',width:150},
			{field:'RemainingQty',title:'剩余数量',width:150},
			{field:'FixSubRowId',title:'FixSubRowId',width:150,hidden:true}
		]];
GV.OrdExItms=$HUI.datagrid("#dg",{
		//idField:'ordItm',
		//sortName:'ProductFlag',
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		pageSize: 80,
		pageList: [80, 120, 160, 200],
		columns: dgColumns,
		rownumbers: true,
		///pageList: [99999],
		frozenColumns: [[
							{title: 'ck', field: 'ck', checkbox: true,
								styler:function(value,row,index){
									return true
								}
							},
							{field:'arcimDesc',title:'医嘱项',width:220},
							{field:'ProductFlag',title:'套餐标识',width:80,
								formatter:function(value,data,row){
									value=='1'?value='套餐内':value='套餐外';
									return value;
								},
								styler:function(value,row,index){
									return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}			
							},
							{
								field:'FixFlag',title:'折扣标志',width:80,
								formatter:function(value,data,row){
									if(value=='1') {
										if(GV.deleteStr==''){
											GV.deleteStr=data.FixSubRowId;
											GV.FixFlag='1';	
										}else{
											GV.deleteStr=GV.deleteStr+'^'+data.FixSubRowId;
										}
									}else{
											GV.FixFlag='';	
										}
									value=='1'?value='已折扣':value='未折扣';
									return value;
								},
								styler:function(value,row,index){
									return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}
							},
							{field:'NoDisFag',title:'可否打折',width:60,
								formatter:function(value,data,row){
									value=='1'?value='可':value='否';
									return value;
								},
								styler:function(value,row,index){
									return value=='0'?'color:green;font-weight:bold':'color:red;font-weight:bold';
								}}
						]],					
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			data.rows.length>0?GV.BILL=data.rows[0].pboRowId.split('||')[0]:'';
		},
		onSelect:function(index,rowData){
	
		},
		
	    onBeginEdit: function (index, row) {
			   //OrdExBeginEdit(index, row);
    	},
		onAfterEdit:function(rowIndex, rowData, changes){
			//OrdExAfterEdit(rowIndex, rowData, changes);
			
		},
		onCheck:function(index,rowData){
		},
		onUncheck:function(index,rowData){
			//clearDatagridDiscrate(index,rowData);
		}
		,
	    onClickCell: function (index, field, value) {
			   //OrdExEditCell(index, field, value);
		},
		
		
		
	});
}

function initLoadGrid(){
	var queryParam={
		ClassName:'BILL.PKG.BL.PackageConfirmation',
		QueryName:'FindProOrdDetail',
		episodeId:GV.ADM,
		userDeptId:getValueById('CTLoc'),
		billStatus:'',
	}
	loadDataGridStore('dg',queryParam);		
	GV.OrdExItms=$HUI.datagrid("#dg");
}

/*
 * 清屏
 */
$('#BtnClear').bind('click', function () {
	clear_Click();	
})
function clear_Click(){
	GV={
		ADM:'',
		BILL:'',
		PAPMI:'',
		PACKAGEID:'',
		editRowIndex:-1,
		FixFlag:'' ,
		deleteStr:'' ,
	    OrdExItms:{}  ,//医嘱执行记录
	    EditIndex: undefined,
	    curRowIndex:-1,
        curRow:{},
        curVal:0.0,
        ed:{},
	}
	refreshBar('','');
	$("#searchTable").form("clear");
	initLoadGrid();	
}
/*
 * 取消
 */
$('#BtnCancel').bind('click', function () {
		$.messager.confirm('确认', '您确认想要取消全部匹配的数据吗？', function (r) {
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
})
/*
 * 修改套餐
 */
$('#BtnUpdate').bind('click', function () {
	var OEOREStr=getOEOREStr();
	if(OEOREStr!=''){
		$.m({
			ClassName: "BILL.PKG.BL.PackageConfirmation",
			MethodName: "UpdateOrdExecByExeStr",
			OEExcStr:OEOREStr,
			Guser:PUBLIC_CONSTANT.SESSION.USERID,
		},function(rtn){
			if(rtn.split('^')[0]==='0'){
				$.messager.alert('提示','保存成功','info',function(){
				});
			}else{
				$.messager.alert('提示','保存失败:'+rtn.split('^')[1],'info');
			}
			initLoadGrid();

		})
	}else{
		$.messager.alert('提示','没有更新的记录','info');	
	}
});
/*
 * 灵活折扣
 */
$('#BtnSave').bind('click', function () {
	if(GV.FixFlag=='1'){
		$.messager.alert('提示','该患者已经进行过灵活折扣','info');
		return;
	}
	if(getValueById('DiscReason')==''){
		$.messager.alert('提示','审批单号不能为空','info');
		return;
	}
	$.m({  
		ClassName: "BILL.PKG.BL.Flexiblediscount",
		MethodName: "FlexibleIPdiscountSave",
		AdmDr:GV.ADM,
		OrdStr:'',
		Acount:getValueById('OutPackageAmt'), 
		DiscRate:'', 
		DiscAcount:getValueById('DiscAmt'), 
		DiscReason:getValueById('DiscReason'),
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
		UserDr:PUBLIC_CONSTANT.SESSION.USERID
		},function(rtn){
			if(rtn.split('^')[0]==='0'){
				$.messager.alert('提示','保存成功','info',function(){
					initLoadGrid();	
			});
			}else{
				$.messager.alert('提示','保存失败:'+rtn.split('^')[1],'info');
			}
	})		
});
/*
 * 删除灵活折扣
 */
$('#BtnDelete').bind('click', function () {
	dleteFlexDisClick();
});

$('#BtnFind').bind('click', function () {
	FindClick();
});
/*
 * 查询
 */
function FindClick() {
	initLoadGrid();
	CheckPackage();
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
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", GV.ADM, PUBLIC_CONSTANT.SESSION.USERID, GV.BILL, computerName);
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
/*
 * 重新生成账单
 */
$('#BtnReBill').bind('click', function () {
	reBillClick();
});
/*
 * 重新生成账单  
 */
function reBillClick() {
	if(GV.BILL == "") {
		$.messager.alert("账单", "未选择账单，不允许重新生成账单!",'info');
		return;
	}
	if(GV.ADM == "") {
		$.messager.alert('账单','请选择病人','info');
		return;
	} else {
		var insuUpFlag=getInsuUpFlag();
		if(insuUpFlag == 1){
			$.messager.alert('提示','账单医保已上传,不允许重新生成账单!','info');
			return;
		}else if (insuUpFlag == 2){
			$.messager.alert('提示','账单医保已结算,不允许重新生成账单!','info');
			return;			
		}
		var rebillnum = tkMakeServerCall("web.DHCIPBillCashier", "JudgeBabyDeposit", 	GV.ADM);
		if(rebillnum != ""){
			$.messager.alert('账单','婴儿有未结算押金,如需重新生成账单请退婴儿押金!','info');
			return;
		}
		var billNum = tkMakeServerCall("web.UDHCJFBaseCommon", "JudgeBillNum", GV.ADM);
		if(billNum == 1) {
			_rebill();
		} else if (billNum >= 2) {
			$.messager.confirm("确认", "病人有两个或多个未结算的账单,是否确认重新生成账单?", function(r) {
				if(r) {
					_rebill();
				} else {
					return;
				}
			});
		} else if (billNum == 0) {
			$.messager.alert("账单",  "未结算账单数为0,请确认该条记录是否已结算.",'info')
			retur
		} else {
			$.messager.alert("账单",  "重新生成账单失败" + ",返回值：" + billNum,'info');
			return;
		}
	}
	
	function _rebill() {
		var rtn = tkMakeServerCall("web.UDHCJFREBILL", "REBILL", "", "", GV.ADM, GV.BILL, PUBLIC_CONSTANT.SESSION.USERID);
		if(rtn == 0) {
			$.messager.alert("账单", "重新生成账单成功.", "info", function() {
				initLoadGrid();
			});
		} else if(rtn == "ExtItmErr") {
			$.messager.alert("账单", "账单中执行记录有附加的收费项目,不能重新生成账单.",'info');
			return;
		} else if(rtn == "BabyErr") {
			//$.messager.alert("账单", "母婴账单合并,请选择母亲账单进行重新生成账单!");
			$.messager.alert("账单", "请选择母亲账单进行重新生成账单!",'info');
			return;
		} else {	
			$.messager.alert("账单", "重新生成账单失败.",'info');
			return;
		}
	}
}
//获取医保结算信息
//返回值:
// 	1:医保已上传明细
// 	2:医保已结算
// 	小于0:医保未结算未上传
function getInsuUpFlag(){
	var insuUpFlag = tkMakeServerCall("web.DHCIPBillCashier","JudgePBInsuUpFlag",GV.BILL,"");
	return insuUpFlag;
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
		columns: [[
				   {field: 'TadmDate',	title: '就诊时间', width: 150},
				   {field: 'TadmLoc', title: '就诊科室', width: 90},
				   {field: 'TadmWard', title: '就诊病区', width: 130},
				   {field: 'TdisDate', title: '出院时间', width: 150},
				   {field: "TadmId", title: "TadmId", width: 150}
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
			getAdmInfo();// 加载表单头 就诊信息
			CheckPackage();
		}
	});
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
 * 获取患者基本信息
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
 * 获取患者就诊信息
 */
function getAdmInfo() {
	try
	{
		$.m({
			ClassName: 'BILL.PKG.BL.PackageConfirmation',
			MethodName: 'GetPatInfo',
			AdmDr: GV.ADM
		}, function (rtn) {
			var myAry = rtn.split('^');
			if (myAry[0]=='101') {
				$.messager.alert('提示', '获取就诊信息失败'+rtn, 'error');
			} else {
				setValueById('Deposit',parseFloat(myAry[5]).toFixed(2));
				setValueById('OutPackageAmt',parseFloat(myAry[8]).toFixed(2));
				setValueById('InPackageAmt',parseFloat(myAry[7]).toFixed(2));
				setValueById('PackageAmt',parseFloat(myAry[9]).toFixed(2));
			}
		});
	}
	catch (e)
	{
		$.messager.alert('异常发生在dhcbill.pkg.ipconfirmation.js：getAdmInfo', e,'error');
	}
}

/*
 * 获取执行记录串 修改套餐时使用
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
 * 灵活折扣相关
 *
 * ---------Start----------  
 */
function init_DiscReason(){
	PKGLoadDicData('DiscReason','DiscountReason','','combobox');	 
}

/*
 * 通过面板实收金额计算datagrid折扣率
 * value 实收金额
 */
function calDatagridRate(value){
	var OutTotal=parseFloat($('#OutPackageAmt').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('提示','实收金额不能大于总金额','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	rate=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}

/*
 * 删除折扣
 */
function dleteFlexDisClick(){
	///alert(GV.ADM)
	$.messager.confirm('提示','是否删除灵活折扣记录？',function(r){
		if(r){
			$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountIPDelete",
					AdmDr:GV.ADM,
					HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('提示','删除成功','info',function(){
							initLoadGrid();	
						});
					}else{
						$.messager.alert('提示','删除失败:'+rtn.split('^')[1],'info');
						initLoadGrid();
					}
				})
				
			}		
		})				
}
/*
 * datagrid折扣比例编辑框回车事件
 */
 /*
function datagridRateEnter(){
	$('td[field="DisRate"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//alert("GV.editRowIndex="+GV.editRowIndex)
	  		if(this.value>1) this.value=1;
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
	  		//var rowData=$('#dg').datagrid('getSelected');
	  		//setRowRate(this.value, GV.editRowIndex, rowData);
			//setValueById('DiscAmt','');
  		}
	})
	$('td[field="DisRate"] .datagrid-editable-input').bind('change',function(){
	  		if(this.value>1) this.value=1;
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
	  		//var rowData=$('#dg').datagrid('getSelected');
	  		//calcRowRate(this.value, GV.editRowIndex, rowData);
			//setValueById('DiscAmt','');
  		
	})
}*/
/*
 * datagrid实收金额编辑框回车事件
 */
 /*
function datagridAmtEnter(){
	$('td[field="Amt"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="Amt"] .datagrid-editable-input').bind('change',function(){
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}*/
/*
 * 根据实收金额计算单条医嘱折扣率
 * amt 单条医嘱实收金额
 */
 /*
function calcRowRate(amt, index, rowData){
	var amt=parseFloat(amt);
	var OERDAmt=rowData.billTotalAmt;
	if(OERDAmt<amt){
		$.messager.alert('提示','填写金额不能大于医嘱金额','info');
			HISUIDataGrid.setFieldValue('Amt', 0, index, 'dg');	
			HISUIDataGrid.setFieldValue('DisRate', 0, index, 'dg');
		}else{
			var rate=amt/parseFloat(OERDAmt);
			HISUIDataGrid.setFieldValue('DisRate',parseFloat(rate).toFixed(4), index, 'dg');
		}
}*/
/*
 * 根据单条医嘱折扣率计算实收金额
 * rate 单条医嘱折扣率
 */
 /*
function setRowRate(rate,index,rowData){
	var amt=rowData.billTotalAmt * rate;
	//alert("amt="+amt)
	HISUIDataGrid.setFieldValue('DiscAmt', rate, index, 'dg');	
	HISUIDataGrid.setFieldValue('Amt', parseFloat(amt).toFixed(2), index, 'dg');
	//alert("rate="+rate)	
	$('#dg').datagrid('endEdit', GV.editRowIndex);
}*/

/*
 * 填写datagrid折扣率
 * rate : 折扣率
 */
function setDatagridRate(rate){
	var eachRowobj=$('#dg').datagrid('getData'); 
	for(var index=0;index<eachRowobj.total;index++){
		if((eachRowobj.rows[index].ProductFlag=='0')&&(eachRowobj.rows[index].NoDisFag=='1')){ // 只有套餐外才可以使用折扣率
			rate=parseFloat(rate).toFixed(4);
			HISUIDataGrid.setFieldValue('DisRate', parseFloat(rate).toFixed(4), index, 'dg');
			var amt=eachRowobj.rows[index].billTotalAmt * rate;
			HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
			$('#dg').datagrid('checkRow',index);
		}
	}	
}
/*
 * 计算datagrid折扣率
 * value 实收金额
 * 根据实收金额和套餐外医嘱金额计算折扣率
 */

function calDatagridRate(value){
	var OutTotal=parseFloat($('#OutPackageAmt').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('提示','实收金额不能大于套餐外医嘱金额','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	value=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}
 /*
 * datagrid 开始新一行编辑并结束上一行编辑
 * index 需要编辑的行号
 */ 
/*
function datagridEditRow(index,rowData){
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}		
	GV.editRowIndex=index;
	if(rowData.ProductFlag=='1'||rowData.ordCateType=='R'){return;} // 套餐内不能编辑
	$('#dg').datagrid('beginEdit',GV.editRowIndex);	
}
*/
/*
 * 灵活折扣相关
 *
 * ---------End----------  
 */
/*
 * 取消勾选清空datagrid折扣率
 */
function clearDatagridDiscrate(index,rowData){
	if (rowData.ProductFlag!='1'&&GV.FixFlag!='1'){ // 套餐外 未进行过折扣
		HISUIDataGrid.setFieldValue('DisRate', '', index, 'dg');
		HISUIDataGrid.setFieldValue('Amt','', index, 'dg');
	}

}
/*
*	提示套餐是否划算
*/
function CheckPackage()
{
	try
	{
		$.m({
			ClassName: 'BILL.PKG.BL.PackageConfirmation',
			MethodName: 'GetPatInfo',
			AdmDr: GV.ADM
		}, function (rtn) {
			var myAry = rtn.split('^');
			if (myAry[0]=='101') {
				$.messager.alert('提示', '获取就诊信息失败'+rtn, 'error');
			} else {
				var TnTotal = parseFloat(myAry[9]);
				var TnShare = parseFloat(myAry[7]);
				if (TnShare<TnTotal){
					$.messager.alert('提示',"套内医嘱总额："+TnShare+"小于套餐售价："+TnTotal+"，不建议使用套餐",'info');
				}

			}
		});
	}
	catch (e)
	{
		$.messager.alert('异常发生在dhcbill.pkg.ipconfirmation.js：getAdmInfo', e,'error');
	}
}






/**
* 医嘱执行记录单元格编辑
*/
function OrdExEditCell(index, field, value) {
	GV.OrdExItms.selectRow(index);   //选中设定行
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.OrdExItms.editCell({
			index: index,
			field: field
		});
		var ed = GV.OrdExItms.getEditor({
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus().select();
		}
		GV.EditIndex = index;
	}
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.OrdExItms.validateRow(GV.EditIndex)) {
		GV.OrdExItms.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}


/**
* 单元格是否可编辑
* true: 可编辑, false: 不可编辑 ,,
*/
function isCellAllowedEdit(index, field, value) {
	var row = GV.OrdExItms.getRows()[index];
	if ((field != "DisRate") && (field != "Amt")) {
	
			return false;
		
	}
	
	if((row.NoDisFag==0)||(row.NoDisFag=="否")){
		return false
		}
	if(row.ProductFlag=='1'||row.ordCateType=='R')	{
		
			return false
		}
	return true;
}

/**
*开始编辑
*/
function OrdExBeginEdit(index, row)
 {
     RowDisRateEnter(index, row);
     RowAmtEnter(index, row);
     
}

/**
* 结束编辑
*/
function OrdExAfterEdit(index, rowData, changes) {
	GV.OrdExItms.endEdit(index);
	GV.EditIndex = undefined;
	//CalcSalesAmt();
}


/**
*数值转换
*/	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}

/**
*单元格-根据折扣率计算实收金额
*/
function RowDisRateEnter(index, row)
{
	var ed = GV.OrdExItms.getEditor({index: index, field: "DisRate"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowDisRateEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowDisRateEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowDisRateEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var PashareAmt=toNumber(row.billPashareAmt)
	 if (newVal=="") return ;
	 if (toNumber(newVal) > 1)
             {
               $.messager.alert('提示', '填写折扣率不能大于 1', 'error',function() {
	           $(ed.target).numberbox("setValue", 1);
				GV.OrdExItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	              var SalesAmount = toNumber(newVal) *  PashareAmt 
		        	if (PashareAmt <SalesAmount)
		       		 {
			        
			          	 $.messager.alert('提示', '实收金额不能大于自付金额：'+TotalAmt, 'error',function() {
			              $(ed.target).numberbox("setValue", 1);
			              GV.OrdExItms.endEdit(index);
				          GV.EditIndex = undefined;
				          //calcRowOrdExAmt(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('Amt', SalesAmount.toFixed(2), index, 'dg');
				         GV.OrdExItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				     }
	             }
	
}






/**
*单元格-根据实收金额计算折扣率
*/
function RowAmtEnter(index, row)
{
	var ed = GV.OrdExItms.getEditor({index: index, field: "Amt"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowAmtEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowAmtEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowAmtEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var PashareAmt=toNumber(row.billPashareAmt)
	if (newVal=="") return ;
	 if (toNumber(newVal) > PashareAmt)
             {
               $.messager.alert('提示', '填写实收金额不能大于自付金额', 'error',function() {
	           $(ed.target).numberbox("setValue", PashareAmt);
				GV.OrdExItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	                     var DisRate = toNumber(newVal) / PashareAmt 
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('DisRate', DisRate.toFixed(4), index, 'dg');
				         GV.OrdExItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				    
	             }
	
}

/*
 * 住院灵活折扣
 */
$('#FlexButton').bind('click', function () {
	FlexButton_Click();	
})

function FlexButton_Click()
{
	var patNo = getValueById('RegNo');
	var str="&patNo="+patNo+"&AdmDr="+GV.ADM;
    var lnk = 'dhcbill.pkg.ipflexiblediscount.csp?'+str;
	var nwin = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no,titlebar=no,left=' + 0 + ',top=' + 0;
	websys_showModal({
		width: '90%',
		height: '90%',
		iconCls: 'icon-w-find',
		title: '住院部分打折' ,
		url:encodeURI(lnk) ,
		onClose: function (){
			ClrDocWin(myAdmstr, "");
			var FixRowID=top.window.returnValue;
			document.getElementById("FixRowID").value=FixRowID;
		}
	});
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