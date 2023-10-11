/**
 * @author SongChao
 * @version 20180911
 * @description 标本运送js
 */
var carrySheetGroupObj={
	"Urgent":"加急",
	"RecLoc":"接收科室",
	"ItemSubCat":"医嘱子类分组",
	"Specimen":"标本类型分组"
}
var GV = {
	ClassName: "Nur.HISUI.SpecManage",
	ordContArr:[],
	columsObj:{},
	CarryNo:""
};
var init = function () {
	if (carrySheetConfig.isAllowChangeDisplaySheetType!="Y"){
		$("#displaySheetTypeSwitch").hide();
	}
	if (carrySheetConfig.defDisplaySheetType=="Ward"){
		$("#displaySheetTypeSwitch").switchbox("setValue",true,"skipOnChange");
	}else{
		$("#displaySheetTypeSwitch").switchbox("setValue",false,"skipOnChange");
	}
	initSpecTeam();
	initSheetSearchCondition();
	initGridCarrySheet();
	initEvent();
}
$(init)
var CarrySheetDataGridLoadSuccCallBack=$.Callbacks("unique");
var CarrySheetDetailGridLoadSuccCallBack=$.Callbacks("unique");
function initSpecTeam() {
	if (SpecTeam) {
		switch (SpecTeam) {
		case 'Lis':
			$HUI.radio("#lisRadio").setValue(true);
			$HUI.radio("#lisRadio").setDisable(true);
			$("#pisRadioSpan").hide();
			$('#panelCarryTabSheet').panel('setTitle', $g('检验运送单查询'));
			break;
		case 'Pis':
			$HUI.radio("#pisRadio").setValue(true);
			$HUI.radio("#pisRadio").setDisable(true);
			$("#lisRadioSpan").hide();
			$('#panelCarryTabSheet').panel('setTitle', $g('病理运送单查询'));
			break;
		default:
			$HUI.radio("#lisRadio").setValue(true);
		}

	} else {
		$HUI.radio("#lisRadio").setValue(true);
	}
}
function specTeamCheckChange(){
	var lisRadioChk=$("#lisRadio").radio("getValue");
	var pisRadioChk=$("#pisRadio").radio("getValue");
	if (lisRadioChk){
		$('#panelCarryTabSheet').panel('setTitle', $g('检验运送单查询'));
	}else if(pisRadioChk){
		$('#panelCarryTabSheet').panel('setTitle', $g('病理运送单查询'));
	}else{
		$('#panelCarryTabSheet').panel('setTitle', $g('送单查询'));
	}
	findCarrySheet();
	loadGridCarrySheetDetail();
	$('#panelCarrySheetDetail').panel('setTitle', $g('运送单'));
}
/**
 * @description 绑定按钮事件
 */
function initEvent() {
	$('#findCarrySheetBtn').bind('click', function(){
		findCarrySheet();
		loadGridCarrySheetDetail();
	});
	$('#outLocCarrySheetBtn').bind('click', outLocCarrySheetBtnClick);
	$('#deleteCarrySheetBtn').bind('click', deleteCarrySheetBtnClick);
	$('#insertCarrySheetDetailBtn').bind('click', insertCarrySheetDetailBtnClick);
	$('#detailLabNOInput').bind('keydown', function (e) {
		if (e.keyCode == 13) {
			insertCarrySheetDetailBtnClick();
		}
	});
	$('#outLocCarrySheetDetailBtn').bind('click', outLocCarrySheetDetailBtnClick);
	$('#printCarrySheetBtn').bind('click', printCarrySheetBtnClick);
	$('#outLocPrintSheetDetailBtn').bind('click', outLocPrintSheetDetailBtnClick);
	$('#printCarrySheetBarBtn').click(printCarrySheetBarBtnClick);
	
}
/**
 * @description 初始化运送单查询条件
 */
function initSheetSearchCondition() {
	$('#sheetStartDateBox').datebox('setValue', formatDate(new Date()));
	$('#sheetEndtDateBox').datebox('setValue', formatDate(new Date()));
}

/**
 *@description 初始化gridCarrySheet按钮操作及事件监听等
 *
 */
function initGridCarrySheet() {
	var locID = session['LOGON.CTLOCID'];
	var stDate = $('#sheetStartDateBox').datebox('getValue');
	var endDate = $('#sheetEndtDateBox').datebox('getValue');
	var status = $('#sheetStateBox').combobox('getValue');
	var filterStr = $('#sheetFilter').val();
	var specTeamCheckedRadioObj = $("input[name='specTeam']:checked");
	var specTeamVal = specTeamCheckedRadioObj.val();
	var PrintFlag=$("#printStateBox").combobox("getValue");
	var displaySheetType=$("#displaySheetTypeSwitch").switchbox("getValue")?"Ward":"User";
	$('#gridCarrySheet').datagrid({
		url: $URL,
		idField:"CarryNo",
		queryParams: {
			ClassName: GV.ClassName,
			MethodName: "findCarrySheet",
			StDate: stDate,
			EndDate: endDate,
			LocID: locID,
			Status: status,
			FilterStr: filterStr,
			SpecTeam: specTeamVal,
			PrintFlag:PrintFlag,
			displaySheetType:displaySheetType
		},
		onSelect: gridCarrySheetClickRow,
		onLoadSuccess:function(data){
			CarrySheetDataGridLoadSuccCallBack.fire();
		},
		onBeforeLoad:function(param){
			$('#gridCarrySheet').datagrid("unselectAll");
		}
	});
	$('#creatCarrySheetBtn').bind('click', creatCarrySheetBtnClick);
}

/**
 * @description 运送单出科按钮监听
 * @param {*} CarryNo
 * @param {*} TransCount
 */
function outLocCarrySheetBtnClick() {
	var rowData = $('#gridCarrySheet').datagrid('getSelected');
	var carryNo =GV.CarryNo;//rowData.CarryNo;
	//var carryCount = rowData.TransCount;
	var carryCount = $('#gridCarrySheetDetail').datagrid('getRows').length;
	outLocCarrySheet(carryNo, carryCount);
}
/**
 * @description 运送单删除按钮监听
 * @param {*} CarryNo
 * @param {*} TransCount
 */
function deleteCarrySheetBtnClick() {
	var rowData = $('#gridCarrySheet').datagrid('getSelected');
	if (!rowData){
		$.messager.popover({msg: "请选择需要删除的记录！"});
		return false;	
	}
	var carryNo = rowData.CarryNo;
	deleteCarrySheet(carryNo)
}

/**
 *@description 获取采取时间页签下运送单对应的标本填充grid
 * @param {*} carryNo 运送单号
 */
function getCarrySheetSpecs(carryNo) {
	var ifCarry = $('#switchCarry').switchbox('getValue');
	if (ifCarry) {
		$cm({
			ClassName: "Nur.HISUI.SpecManage",
			MethodName: "getCarrySheetSpecs",
			CarryNO: carryNo,
		}, function (jsonData) {
			$('#gridCarrySpecs').datagrid({
				data: jsonData
			})
		})
	}
}
/**
 * @description 将标本插入运送单
 */
function insertCarrySheet(labNo) {
	var lisType=$HUI.radio("#lisRadio").getValue();
	if(!lisType&&labNo.replace(/(^s*)|(s*$)/g, "").length ==0){
		$.messager.popover({
				msg: "标本号不能为空!",
				timeout: 5000
			});
		return;	
	}
	if(lisType&&labNo.indexOf("-")>0){
		$.messager.popover({
				msg: "病理标本不能插入检验运送单!",
				timeout: 5000
			});
		return;
	}
	if(!lisType&&labNo.indexOf("-")<0){
		$.messager.popover({
				msg: "检验标本不能插入病理运送单!",
				timeout: 5000
			});
		return;
	}
	var jsonData=$cm({
		ClassName: "Nur.HISUI.SpecManage",
		MethodName: "getCarrySheetGroup",
		LabNo: labNo.trim()
	}, false)
	var rowData = $('#gridCarrySheet').datagrid('getSelected');
	if (rowData.CarrySheetGroup && !$.isEmptyObject(rowData.CarrySheetGroup)){
		var notEqualArr=isObjectValueEqual(rowData.CarrySheetGroup,jsonData)
		if (notEqualArr.length){
			$.messager.popover({msg: notEqualArr.join("、")+"与运送单同单规则不同！"});
			return false;
		}
	}
	if (GV.CarryNo != '') {
		var locID = session['LOGON.CTLOCID'];
		var jsonData=$cm({
			ClassName: "Nur.HISUI.SpecManage",
			MethodName: "specRelateCarrySheet",
			LabNo: labNo.trim(),
			CarryNo: GV.CarryNo,
			LocID: locID,
		}, false)
		if (String(jsonData.success) !== "0") {
			$.messager.popover({
				msg: jsonData.errInfo,
				timeout: 5000
			});
		}else{
			var index=$('#gridCarrySheet').datagrid('getRowIndex',$.trim(GV.CarryNo)+" ");
			$('#gridCarrySheet').datagrid('updateRow',{
				index: index,
				row: {
					TransCount: jsonData.TransCount,
					CarrySheetGroup:jsonData.CarrySheetGroup
				}
			});
			if (carrySheetConfig.specDisplayOrder=="Asc"){
				$('#gridCarrySheetDetail').datagrid('appendRow',jsonData.carryDetailObj[0]);
			}else{
				$('#gridCarrySheetDetail').datagrid('insertRow',{
					index: GV.ordContInfo===""?0:1,	// 索引从0开始
					row: jsonData.carryDetailObj[0]
				});
			}
			if (getSpecTeam()=="L"){
				updateOrdContInfo(jsonData.carryDetailObj[0],"Add");
			}
			setTimeout(function(){
				var ifdisable = GV.CarryStatus != "C";
				$('.deleteSpecBtn').linkbutton({
					plain: true,
					iconCls: 'icon-remove',
					disabled: ifdisable
				});
			})
		}
	}
	else{
		$.messager.popover({
				msg: "请选择有效的运送单!",
				timeout: 5000
			});
		return;
	}
}

/**
 * @description 查询运送单信息
 */
function findCarrySheet() {
	var locID = session['LOGON.CTLOCID'];
	var stDate = $('#sheetStartDateBox').datebox('getValue');
	var endDate = $('#sheetEndtDateBox').datebox('getValue');
	var status = $('#sheetStateBox').combobox('getValue');
	var filterStr = $('#sheetFilter').val();
	var specTeamCheckedRadioObj = $("input[name='specTeam']:checked");
	var specTeamVal = specTeamCheckedRadioObj.val();
	var PrintFlag=$("#printStateBox").combobox("getValue");
	var displaySheetType=$("#displaySheetTypeSwitch").switchbox("getValue")?"Ward":"User";
	$("#gridCarrySheet").datagrid('reload', {
		ClassName: GV.ClassName,
		MethodName: "findCarrySheet",
		StDate: stDate,
		EndDate: endDate,
		LocID: locID,
		Status: status,
		FilterStr: filterStr,
		SpecTeam: specTeamVal,
		PrintFlag:PrintFlag,
		displaySheetType:displaySheetType
	});
}

/**
 *@description 新建运送单按钮监听
 */
function creatCarrySheetBtnClick(callBackFun) {
	$('#creatCarrySheetBtn').unbind('click', creatCarrySheetBtnClick);
	var locID = session['LOGON.CTLOCID'];
	var userCode = session['LOGON.USERCODE'];
	var specTeamCheckedRadioObj = $("input[name='specTeam']:checked");
	var specTeamVal = specTeamCheckedRadioObj.val();
	$('#creatCarrySheetBtn').linkbutton('disable');
	$cm({
		ClassName: GV.ClassName,
		MethodName: "createCarrySheet",
		LocID: locID,
		UserCode: userCode,
		SpecTeam: specTeamVal
	}, function (jsonData) {
		if (String(jsonData.success) !== "0") {
			$.messager.show({
				title: '新建运送单消息',
				msg: jsonData.errInfo,
				timeout: 5000,
				showType: 'slide'
			});
		} else {
			findCarrySheet();
		}
		setTimeout("$('#creatCarrySheetBtn').linkbutton('enable');$('#creatCarrySheetBtn').bind('click', creatCarrySheetBtnClick);",1000);
		//$('#creatCarrySheetBtn').linkbutton('enable');
		//$('#creatCarrySheetBtn').bind('click', creatCarrySheetBtnClick);
	});
}

/**
 * @description 运送单出科
 * @param {*} CarryNo
 * @param {*} TransCount
 */
function outLocCarrySheet(CarryNo, TransCount) {
	if (TransCount > 0) {
		$('#outLocDialog').dialog({
			onClose: function () {
				$('#outLocDialogForm').form('clear');
			},
			buttons: [{
					text: $g('保存'),
					handler: function () {
						var transUserCode = $('#transUserCode').val();
						var transUserPass = $('#transUserPass').val();
						$cm({
							ClassName: "Nur.HISUI.SpecManage",
							MethodName: "passwordConfirm",
							UserCode: transUserCode,
							PassWord: transUserPass
						}, function (jsonData) {
							if (String(jsonData.result) !== '0') {
								if(jsonData.result=='用户名为空!'){
									jsonData.result=$g("护工工号不能为空!");
								}
								$.messager.show({
									title: '用户验证消息',
									msg: jsonData.result,
									timeout: 5000,
									showType: 'slide'
								});
							} else {
								var transUserID = jsonData.userID;
								var containerNo = $('#containerNoInput').val();
								var userID = session['LOGON.USERID'];
								var locID = session['LOGON.CTLOCID'];
								$cm({
									ClassName: "Nur.HISUI.SpecManage",
									MethodName: "outLocCarrySheet",
									CarryNO: CarryNo,
									ContainerNo: containerNo,
									TransUserID: transUserID,
									UserID: userID,
									UserLocID: locID
								}, function (jsonData) {
									if (String(jsonData.success) !== "0") {
										$.messager.show({
											title: '标本交接消息',
											msg: jsonData.errInfo,
											timeout: 5000,
											showType: 'slide'
										});
									} else {
										$HUI.dialog('#outLocDialog').close();
										findCarrySheet();
										loadGridCarrySheetDetail();
										$('#panelCarrySheetDetail').panel('setTitle', $g('运送单'));
									}
								});
							}
						});
					}
				}, {
					text: '关闭',
					handler: function () {
						$HUI.dialog('#outLocDialog').close();
					}
				}
			]
		});
		$('#outLocDialog').dialog('open');
	} else {
		$.messager.show({
			title: '标本交接消息',
			msg: "空运送单无法出科,请填写标本信息!!",
			timeout: 5000,
			showType: 'slide'
		});
	}
}

/**
 * @description 删除标本运送单
 * @param {*} CarryNo
 */
function deleteCarrySheet(CarryNo) {
	var userID = session['LOGON.USERID'];
	$.messager.confirm("删除", "确定删除么", function (r) {
		if (r) {
			$cm({
				ClassName: "Nur.HISUI.SpecManage",
				MethodName: "deleteCarrySheet",
				CarryNO: CarryNo,
				UserID: userID
			}, function (jsonData) {
				if (String(jsonData.success) !== "0") {
					$.messager.show({
						title: '删除运送单消息',
						msg: jsonData.errInfo,
						timeout: 5000,
						showType: 'slide'
					});
				} else {
					$('#panelCarrySheetDetail').panel('setTitle', $g('运送单'));
					findCarrySheet();
					GV.CarryNo="";
				}
			})
		} else {
			return;
		}
	});
}
/**
 *@description 从运送单中删除标本
 */
function deleteSpecBtnClick(labNo, CarryNo) {
	var locID = session['LOGON.CTLOCID'];
	$.messager.confirm("删除", "确定删除么", function (r) {
		if (r) {
			$cm({
				ClassName: GV.ClassName,
				MethodName: "specDelFromCarrySheet",
				LabNo: labNo,
				CarryNo: CarryNo,
			}, function (jsonData) {
				if (String(jsonData.success) !== "0") {
					$.messager.show({
						title: '删除标本消息',
						msg: jsonData.errInfo,
						timeout: 5000,
						showType: 'slide'
					});
				} else {
					var index=$('#gridCarrySheet').datagrid('getRowIndex',CarryNo);
					$('#gridCarrySheet').datagrid('updateRow',{
						index: index,
						row: {
							TransCount: jsonData.TransCount,
							CarrySheetGroup:jsonData.CarrySheetGroup
						}
					});
					var rows=$('#gridCarrySheetDetail').datagrid('getRows');
					var detailIndex=$('#gridCarrySheetDetail').datagrid('getRowIndex',labNo);
					var delRow=rows[detailIndex];
					$('#gridCarrySheetDetail').datagrid('deleteRow',detailIndex);
					if (getSpecTeam()=="L"){
						updateOrdContInfo(delRow,"Del");
					}
					//loadGridCarrySheetDetail(CarryNo);
					//findCarrySheet();
				}
			})
		} else {
			return;
		}
	});
}
/**
 *@description 初始化GridCarrySheetDetail按钮操作及事件监听等
 *
 */
function loadGridCarrySheetDetail(carryNo) {
	$('#gridCarrySheetDetail').datagrid('getColumnOption', 'DetailOperate').formatter = function (val, row, index) {
		if (row.ArcimDesc) {
			return '<a href="#" class="deleteSpecBtn" onclick="deleteSpecBtnClick(\'' + row.LabNo + '\',\'' + GV.CarryNo + '\')"></a>';
		}else{
			return "";
		}
	};
	var ifdisable = GV.CarryStatus != "C";
	$('#gridCarrySheetDetail').datagrid({
		autoSizeColumn:false,
		url: $URL,
		idField:"LabNo",
		nowrap:false,  /*此处为false*/
		queryParams: {
			ClassName: GV.ClassName,
			MethodName: "getCarrySheetSpecs",
			CarryNO: carryNo,
			specDisplayOrder:carrySheetConfig.specDisplayOrder
		},
		onLoadSuccess: function (data) {
			$('.deleteSpecBtn').linkbutton({
				plain: true,
				iconCls: 'icon-remove',
				disabled: ifdisable
			});
			if (getSpecTeam()=="L"){
				$('#gridCarrySheetDetail').datagrid("showColumn","OrdTubeColor");
				var otherOrdContCount=0;
				GV.ordContArr=[];
				for (var i=0;i<data.total;i++){
					var OrdLabCont=data.rows[i].OrdLabCont;
					if (!OrdLabCont) otherOrdContCount++;
					else {
						var index=$.hisui.indexOfArray(GV.ordContArr,"labCont",OrdLabCont);
						if (index>=0) {
							GV.ordContArr[index].count=GV.ordContArr[index].count+1;
						}else{
							GV.ordContArr.push({"labCont":OrdLabCont,"count":1});
						}
					}
				}
				if (otherOrdContCount>0){
					GV.ordContArr.push({"labCont":"其他","count":otherOrdContCount})
				}
				insertOrdContInfo();
			}else{
				$('#gridCarrySheetDetail').datagrid("hideColumn","OrdTubeColor");
			}
			CarrySheetDetailGridLoadSuccCallBack.fire();
		}
	});
	GV.columsObj=getarrySheetDetailColumObj();
}
/**
 * @description 运送单详情页增加标本按钮监听
 */
function insertCarrySheetDetailBtnClick() {
	var transCount = $('#gridCarrySheetDetail').datagrid('getRows').length;
	if (GV.ordContArr.length>0){
		transCount--;
	}
	if ((carrySheetConfig.maxSpecNum!="")&&(transCount==carrySheetConfig.maxSpecNum)) {
		$.messager.popover({ msg: "超过运送单最大标本数："+carrySheetConfig.maxSpecNum, type:'alert' });
		autoCreatSheet();
	}else{
		if (GV.CarryNo==""){
			autoCreatSheet();
		}else{
			insertCarrySheetDetail();
		}
	}
}
function autoCreatSheet(){
	if (!checkLabNo()) return;
	CarrySheetDataGridLoadSuccCallBack.add(autoSelCarrySheet);
	CarrySheetDetailGridLoadSuccCallBack.add(insertCarrySheetDetail);
	creatCarrySheetBtnClick();
}
function checkLabNo(){
	var labNo = $('#detailLabNOInput').val();
	var lisType=$HUI.radio("#lisRadio").getValue();
	if(!lisType&&labNo.replace(/(^s*)|(s*$)/g, "").length ==0){
		$.messager.popover({
				msg: "标本号不能为空!",
				timeout: 5000
			});
		return false;	
	}
	if(lisType&&labNo.indexOf("-")>0){
		$.messager.popover({
				msg: "病理标本不能插入检验运送单!",
				timeout: 5000
			});
		return false;
	}
	if(!lisType&&labNo.indexOf("-")<0){
		$.messager.popover({
				msg: "检验标本不能插入病理运送单!",
				timeout: 5000
			});
		return false;
	}
	var locID = session['LOGON.CTLOCID'];
	var rtn=$m({
		ClassName: "Nur.NurseCarry",
		MethodName: "checkLabNo",
		labNo: labNo.trim(),
		LocDr:session['LOGON.CTLOCID']
	}, false)
	if (rtn!=""){
		$.messager.popover({msg: rtn.split("@")[1]});
		return false;
	}
	return true;
}
function insertCarrySheetDetail(){
	CarrySheetDetailGridLoadSuccCallBack.remove(insertCarrySheetDetail);
	var labNO = $('#detailLabNOInput').val();
	insertCarrySheet(labNO);
	//loadGridCarrySheetDetail(GV.CarryNo);
	//findCarrySheet();
	$('#detailLabNOInput').val('');
}
function autoSelCarrySheet(){
	$('#gridCarrySheet').datagrid("selectRow",0);
}
/**
 * @description 运送单详情页增加标本按钮监听
 */
function outLocCarrySheetDetailBtnClick() {
	var transCount = $('#gridCarrySheetDetail').datagrid('getRows').length;
	outLocCarrySheetBtnClick(GV.CarryNo, transCount)
}
/**
 *@description 运送单数据表格行双击事件
 *
 */
function gridCarrySheetClickRow(rowIndex, rowData) {
	CarrySheetDataGridLoadSuccCallBack.remove(autoSelCarrySheet);
	var carryTitle = $g('运送单：') + rowData.CarryNo + ' ' + rowData.CarryUserName + ' ' + rowData.CarryDate + ' ' + rowData.CarryTime +'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
			+ '<span style="font-weight:bold">'+$g("接收科室:")+'</span>' 
			+'<span style="color: red;font-weight:bold;margin-left:10px;">'+rowData.RecLocDesc+'</span>';
		$('#panelCarrySheetDetail').panel('setTitle', carryTitle);
	GV.CarryNo = rowData.CarryNo;
	GV.CarryStatus = rowData.Status;
	loadGridCarrySheetDetail(GV.CarryNo);
	$('#layoutCarry').layout('collapse', 'west');
	if (rowData.Status != "C") {
		setToolBar(true)
	} else {
		setToolBar(false)
	}
}

/**
 *@description 设置明细工具条可用状态
 *
 */
function setToolBar(disable) {
	if (disable) {
		document.getElementById('detailLabNOInput').setAttribute("disabled", "true");
		$('#insertCarrySheetDetailBtn').linkbutton('disable');
		$('#outLocCarrySheetDetailBtn').linkbutton('disable');
		//$('#outLocPrintSheetDetailBtn').linkbutton('disable');
	} else {
		document.getElementById('detailLabNOInput').removeAttribute("disabled", "true");
		$('#insertCarrySheetDetailBtn').linkbutton('enable');
		$('#outLocCarrySheetDetailBtn').linkbutton('enable');
		//$('#outLocPrintSheetDetailBtn').linkbutton('enable');
	}
}

/**
 *@description 批量打印按钮
 */
function printCarrySheetBtnClick() {
	// var selRow = $('#gridCarrySheet').datagrid('getSelected');
	//var directPrintStr="{NurseCarryDetail.raq(TransmitNo="+selRow.CarryNo+")}";
	/*var url = "dhccpmrunqianreportprint.csp?reportName=NurseCarryDetail.raq&TransmitNo=" + GV.CarryNo; //selRow.CarryNo;
	window.open(url, 1, "width=666,height=568,top=90,left=570,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");*/
	//DHCCPM_RQDirectPrint(directPrintStr);
	var selSpecTeam=getSpecTeam();
	var dateTime=getServerTime();	
	var rows=$('#gridCarrySheet').datagrid('getChecked'); 
	var newData=[];
	if(rows.length>0){
		newData=rows.filter(function(val){
			return val.TransCount>0;
		})
		if(newData.length>0){
			/// 能打印的运送单
			var CarryNoStr="";
			var LODOP=getLodop();		
			LODOP.PRINT_INIT("运送单标本明细");
			LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")	
			newData.forEach(function(val){
				CarryNoStr=CarryNoStr=="" ? $.trim(val.CarryNo) : CarryNoStr+"^"+$.trim(val.CarryNo);
				var headStr="<thead><tr><td>标本号</td><td>患者姓名</td><td>性别</td><td>年龄</td><td>医嘱</td><td>标本类型</td>"+(selSpecTeam=="L"?"<td>容器</td>":"")+"</tr></thead>";
				var footStr="<tfoot><tr><th colspan='6' align='right'>打印时间:"+dateTime.date+" "+dateTime.time+"</th></tr></tfoot>";
				var records=$.cm({
					ClassName:GV.ClassName,
					MethodName:"getCarrySheetSpecs",
					CarryNO:val.CarryNo
				},false);
				var rowStr="<tbody>";
				var otherOrdContCount=0;
				var ordLabContArr=[];
				records.forEach(function(row){
					if (selSpecTeam=="L"){
						var OrdLabCont="其他";
						if (row.OrdLabCont) {
							OrdLabCont=row.OrdLabCont;
							var index=$.hisui.indexOfArray(ordLabContArr,"labCont",OrdLabCont);
							if (index>=0) {
								ordLabContArr[index].count=ordLabContArr[index].count+1;
							}else{
								ordLabContArr.push({"labCont":OrdLabCont,"count":1});
							}
						}else {
							otherOrdContCount++;
						}
					}
					rowStr=rowStr+'<tr>'+'<td>'+row.LabNo+'</td>'+'<td>'+row.PatName+'</td>'+'<td>'+row.Sex+'</td>'+'<td>'+row.Age+'</td>'+'<td>'+row.ArcimDesc+'</td>'+'<td>'+(row.SpecName?row.SpecName:"")+'</td>';
					if (selSpecTeam=="L"){
						rowStr=rowStr+'<td>'+row.OrdLabCont+'</td>'
					}
					rowStr=rowStr+"</tr>"
				})
				var colspan=5
				if (selSpecTeam=="L"){
					colspan=6;
					if (otherOrdContCount>0){
						ordLabContArr.push({"labCont":"其他","count":otherOrdContCount})
					}
					var ordContInfo="";
					for (var i=0;i<ordLabContArr.length;i++){
						var contObj=ordLabContArr[i];
						if (ordContInfo=="") ordContInfo=contObj.labCont+":"+contObj.count;
						else  ordContInfo=ordContInfo+" "+contObj.labCont+":"+contObj.count;
					}
					rowStr=rowStr+'<tr><td>标本容器统计</td><td colspan="'+colspan+'" align="center">'+ordContInfo+'</td>'
				}
				rowStr=rowStr+'<tr><td>合计标本数目</td><td colspan="'+colspan+'" align="center">'+val.TransCount+'</td>'
				rowStr=rowStr+"</tbody>";
				var strHTML = '<style>table,th{border:none;font-weight:normal;} td{border: 1px solid #000;text-align:center;} thead td{font-weight:bold;}</style>"<table style="border-collapse:collapse;" border=0 cellSpacing=0 cellPadding=0  width="100%" bordercolor="#000000">'+headStr+rowStr+footStr+"</table>";
				LODOP.ADD_PRINT_TEXT(40,0,"100%",42,"运送单标本明细");
				LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
				LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
				LODOP.SET_PRINT_STYLEA(0,"Bold",1);
				LODOP.ADD_PRINT_BARCODE(25,21,185,45,"128Auto",val.CarryNo);
				LODOP.ADD_PRINT_TEXT(66,206,180,22,"运送单号:"+val.CarryNo);
				LODOP.ADD_PRINT_TEXT(66,406,160,22,"交接时间:"+val.TransDate+" "+val.TransTime);
				LODOP.ADD_PRINT_TEXT(66,586,160,22,"接单人:"+val.TransUserName);
				LODOP.ADD_PRINT_TABLE("22mm","5mm","190mm","280mm",strHTML);
				LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
				LODOP.NEWPAGE();				
			})
			LODOP.PRINT();
			if(CarryNoStr!="") setCarrySheetPrintFlag(CarryNoStr);				
		}else{
			$.messager.popover({msg: '请选择打印标本数不为0的运送单！',type:'alert'});
		}
	}else{
		$.messager.popover({msg: '请选择要打印的运送单！',type:'alert'});
	}
}

/**
 *@description 打印按钮
 */
function outLocPrintSheetDetailBtnClick() {
	//var selRow = $('#gridCarrySheet').datagrid('getSelected');
	//var directPrintStr="{NurseCarryDetail.raq(TransmitNo="+selRow.CarryNo+")}";
	var url = "dhccpmrunqianreportprint.csp?reportName=NurseCarryDetail.raq&TransmitNo=" + GV.CarryNo ;//+ selRow.CarryNo;
	window.open(url, 1, "width=666,height=568,top=90,left=570,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	//DHCCPM_RQDirectPrint(directPrintStr);
	
	// 更新打印标记
	setCarrySheetPrintFlag($.trim(GV.CarryNo));
}

function setCarrySheetPrintFlag(CarryNoStr){
	$.cm({
		ClassName:GV.ClassName,
		MethodName:"setCarrySheetPrintFlag",
		CarryNoStr:CarryNoStr,
		PrintFlag:"Y"
	},function(result){
		if(result==0) findCarrySheet();
	});
}
function OrdTubeColorStyler(value,row,index){
	if (row["OrdTubeColor"]){
		return 'background-color:'+value;
	}
}
function OrdTubeColorFormate(value,row,index){
	return "";
}
function mergeTabCarrySheetDetailCell(){
	$('#gridCarrySheetDetail').datagrid('mergeCells',{
		index: 0,
		field:"LabNo",
		rowspan:1,
		colspan:5
	}).datagrid('mergeCells',{
		index: 0,
		field:"ArcimDesc",
		rowspan:1,
		colspan:6
	});
}
function insertOrdContInfo(){
	var ordContInfo=getordContInfo();
	if (ordContInfo!=""){
		var columsObj=GV.columsObj;
		$.extend(columsObj, {LabNo: ordContInfo});
		$('#gridCarrySheetDetail').datagrid('insertRow',{
			index: 0,
			row: columsObj
		});
		mergeTabCarrySheetDetailCell();
	}
}
function getordContInfo(){
	var ordContInfo="";
	for (var i=0;i<GV.ordContArr.length;i++){
		var contObj=GV.ordContArr[i];
		if (ordContInfo=="") ordContInfo=contObj.labCont+":"+contObj.count;
		else  ordContInfo=ordContInfo+" "+contObj.labCont+":"+contObj.count;
	}
	return ordContInfo;
}
function updateOrdContInfo(data,operType){
	var type=GV.ordContArr.length>0?"update":"insert";
	var OrdLabCont=data.OrdLabCont?data.OrdLabCont:"其他";
	var index=$.hisui.indexOfArray(GV.ordContArr,"labCont",OrdLabCont);
	if (index>=0) {
		if (operType=="Del"){
			GV.ordContArr[index].count=GV.ordContArr[index].count-1;
			if (GV.ordContArr[index].count==0) {
				GV.ordContArr.splice(index,1);
			}
		}else{
			GV.ordContArr[index].count=GV.ordContArr[index].count+1;
		}
	}else{
		GV.ordContArr.push({"labCont":OrdLabCont,"count":1});
	}
	if (type=="insert"){
		insertOrdContInfo();
	}else{
		var ordContInfo=getordContInfo();
		if (ordContInfo!=""){
			var columsObj=GV.columsObj;
			$.extend(columsObj, {LabNo: ordContInfo});
			$('#gridCarrySheetDetail').datagrid('updateRow',{
				index: 0,
				row: columsObj
			});
			mergeTabCarrySheetDetailCell();
		}else{
			$('#gridCarrySheetDetail').datagrid('deleteRow',0);
		}
	}
}
function getarrySheetDetailColumObj(){
	var columsObj={};
	var opts=$('#gridCarrySheetDetail').datagrid('options');
	var frozenColumns=opts.frozenColumns;
	for (var i=0;i<frozenColumns[0].length;i++){
		columsObj[frozenColumns[0][i].field]="";
	}
	var colums=opts.columns;
	for (var i=0;i<colums[0].length;i++){
		columsObj[colums[0][i].field]="";
	}
	return columsObj;
}
function getSpecTeam(){
	var specTeamCheckedRadioObj = $("input[name='specTeam']:checked");
	var specTeamVal = specTeamCheckedRadioObj.val();
	return specTeamVal;
}
function printCarrySheetBarBtnClick(){
	DHCP_GetXMLConfig("InvPrintEncrypt","NurCarrySheet");
	var dateTime=getServerTime();	
	var rows=$('#gridCarrySheet').datagrid('getChecked'); 
	var newData=[];
	if(rows.length>0){
		newData=rows.filter(function(val){
			return val.TransCount>0;
		})
		if(newData.length>0){
			newData.forEach(function(val){
				printCarrySheetBar(val);			
			})
		}else{
			$.messager.popover({msg: '请选择打印标本数不为0的运送单！',type:'alert'});
		}
	}else{
		$.messager.popover({msg: '请选择要打印的运送单！',type:'alert'});
	}
}
function printCarrySheetBar(val){
	try {
		var MyPara = "" + String.fromCharCode(2);
		MyPara=MyPara +"^"+ "CarryNo" + String.fromCharCode(2) +val.CarryNo;
		MyPara=MyPara +"^"+ "createUser" + String.fromCharCode(2) +val.CarryUserName;
		MyPara=MyPara +"^"+ "createDate" + String.fromCharCode(2) +val.CarryDate+" "+val.CarryTime;
		MyPara=MyPara +"^"+ "recLoc" + String.fromCharCode(2) +val.RecLocDesc;
		MyPara=MyPara +"^"+ "specNum" + String.fromCharCode(2) +val.TransCount;
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	} catch(e) {alert(e.message)};
}
function getTransValue(value,row,index){
	return $g(value);
}
function isObjectValueEqual(a, b) {
	var notEqualArr=[];
	let aProps = Object.getOwnPropertyNames(a)
	let bProps = Object.getOwnPropertyNames(b)
	for (var prop in a) {
		if (b.hasOwnProperty(prop)) {
			if (typeof a[prop] === 'object') {
				if (!isObjectValueEqual(a[prop], b[prop])) notEqualArr.push(carrySheetGroupObj[prop]);
			} else if (a[prop] !== b[prop]) {
				notEqualArr.push(carrySheetGroupObj[prop]);
			}
		} else {
			notEqualArr.push(carrySheetGroupObj[prop]);
		}
	}
	return notEqualArr
}