/**
 * FileName: dhcbill.dc.billbalance.js
 * Author: tangzf
 * Date: 2022-06-6
 * Description: 账单平衡性校验
 */

 var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl"	 
}
var TPBAndPBOColor='red';
var TPBOAndPBDColor="#4507c9";
var TPBSelfAndPBOColor='#ba0c0c';
var TPBOSelfAndPBDColor="#9c0ac9"
 var HospDr=session['LOGON.HOSPID'];
 var REG = new RegExp("[\\U4E00-\\U9FFF]","g")
//界面入口
$(function(){
	//回车事件    
	key_enter();
	// 产品线
	//ini_ProductLine();	
	//业务类型box
	//ini_YWLX();
	
	//默认时间
	setDateBox();
	// 提示信息
    $("#csconflg-tips").popover({
	    trigger:'hover',
	    placement:'bottom',
	    content:'<font color=' + TPBAndPBOColor + '>账单总金额和账单医嘱总金额不平<font><br/>\
	    		 <font color=' + TPBSelfAndPBOColor + '>账单自负金额和账单医嘱自负金额不平<br/>\
	    		 <font color=' + TPBOAndPBDColor + '>账单医嘱总金额和账单明细总金额不平<br/>\
	    		 <font color=' + TPBOSelfAndPBDColor + '>账单医嘱自负金额和账单明细自负金额不平',
	    width :300,
	    
	});
	// grid
	init_dg();
	
	//  操作员
	//InitUser();
	RunQuery();
});
//数据面板
function init_dg(){
	$HUI.treegrid("#dg", {
		idField:'Rowid',
    	treeField:'ErrBill',
		onDblClickRow:function(index,row){
			if(row.state == "closed"){
				$(this).treegrid('expand',index);
			}else{
				$(this).treegrid('collapse',index);
			}
			
		},
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pagination: true,
		pageSize: 20,
		displayMsg: '',
		columns: [[
			{title: 'Rowid', field: 'Rowid', hidden: true}, 
			{title: '登记号', field: 'RegNo', width: 100},
			{title: '姓名', field: 'PatName', width: 60},
			{title: '帐单号', field: 'ErrBill', width: 140},
			{title: '帐单总金额', field: 'PBAmount', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(val !="" && REG.test(val)){
						if(val !=row.PBOToTalAmount.split(':')[1])	{
							color=TPBAndPBOColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: '帐单自负金额', field: 'PBPatientShare', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(val !="" && REG.test(val)){
						if(val !=row.PBOPatientShare.split(':')[1])	{
							color=TPBSelfAndPBOColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: 'PBO', field: 'ShowPBO', width: 75},
			{title: 'PBO总金额', field: 'PBOToTalAmount', width: 120,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.PBAmount !=""){ //
						if(row.PBAmount !=val.split(':')[1])	{
							color=TPBAndPBOColor;
						}
					}
					if(row.ShowPBO !=""){ //
						if(val !=row.PBDTotalAmount.split(':')[1])	{
							color=TPBOAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: 'PBO自负金额', field: 'PBOPatientShare', width: 120,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.PBAmount !=""){ // PBO之和和PB自负金额不等
						if(row.PBAmount !=val.split(':')[1])	{
							color=TPBSelfAndPBOColor;
						}
					}
					if(row.ShowPBO !=""){ // PBD之和和PBO自负金额不等
						if(val !=row.PBDPatientShare.split(':')[1])	{
							color=TPBOSelfAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: 'PBD', field: 'ShowPBD', width: 90},
			{title: 'PBD总金额', field: 'PBDTotalAmount', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.ShowPBO !=""){ //
						if(row.PBOToTalAmount !=val.split(':')[1])	{
							color=TPBOAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: 'PBD自负金额', field: 'PBDPatientShare', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.ShowPBO !=""){ //
						if(row.PBOPatientShare !=val.split(':')[1])	{
							color=TPBOSelfAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: '账单日期', field: 'ShowPBD', width: 90}
			
		]],
		onLoadSuccess: function(data) {
			$(this).treegrid('unselectAll');
		},
		onSelect: function() {
			//loadConfPage();
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
	
}

//查询
function RunQuery() {
	ClearGrid("ckDet");
	var RegNo=getValueById("RegNo");
	var PatName=getValueById("PatName");
	var AdmId=getValueById("AdmDr");
	var Bill=getValueById("PBDr");
	
	var ExpStr = RegNo + "|" + Bill + "|" + AdmId + "|" + PatName + "|";
	$.cm({
		ClassName: "BILL.DC.Common",
		QueryName: "QueryBillBalanceError",
		StartDate:"2022-1-1",
		EndDate:"2022-6-18", 
		StartTime : "",
		EndTime : "",
		ExpStr:ExpStr,
		rows:999999
	},function(jsonData){	
		for (i=0;i<jsonData.rows.length;i++){
			if(jsonData.rows[i]._parentId == ""){
				jsonData.rows[i]['state']='closed';
			}
			if(jsonData.rows[i].Rowid.indexOf("O") >-1){
				jsonData.rows[i]['state']='closed';
			}
		};
		jsonData.total = jsonData.rows.length;
		$('#dg').treegrid('loadData',jsonData);
	});
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
//默认时间
function setDateBox() {
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
///回车
function key_enter() {
	$('#PatName').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#PBDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#RegNo').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#AdmDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
}
//清屏
function clear_click() {
	$('#tQueryPanel').form('clear');
	setDateBox();
	RunQuery();	
}
//业务类型
function ini_YWLX() {
	$HUI.combogrid("#YWLX", {
		url: $URL,
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'INSUMsgYWLX';
			param.ExpStr = 'N|' + $("#ProductLine").combobox('getValue');
			param.HospDr = HospDr;
			return true;

		},
		columns: [[
			{ title: '代码', field: 'cCode', width: 200 },
			{ title: '描述', field: 'cDesc', width: 200 }
		]]
	})
}
// 产品线
function ini_ProductLine() {
	$HUI.combogrid("#ProductLine", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=ProductLine"+'&HospDr='+HospDr+'&ExpStr=N',
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '代码', field: 'cCode', width: 200 },
			{ title: '描述', field: 'cDesc', width: 200 }
		]],
		onLoadSuccess:function(data){
					
		},
		onSelect:function(){
			$('#YWLX').combogrid('grid').datagrid('reload');
		}
	})
}
/**
 * Creator: tangzf
 * CreatDate: 2019-7-10
 * Description: 生成次级弹窗Modifydl
 * input:	msg : 提示内容
 * 			buttonType : 是否显示按钮 "disable" 不显示
 * 			title : 弹窗标题
 */
function openCellWindow(msg,buttonType,title){
	$('#editCode').val(msg);
	$('#Modifydl').panel({
    	title:title,
 	});
	$("#saveBtn").linkbutton(buttonType);
	if(buttonType=="disable"){
		$("#saveBtn").hide();	
	}else{
		$("#saveBtn").show();	
	}
	$('#Modifydl').window('open');	
}
function InitUser(){
	$('#UserCode').combobox({
		valueField: 'Desc',
		textField: 'Desc',
		url:$URL,
		defaultFilter:'4',
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindSSUser';
			param.ResultSetType = 'array';
			param.HospId = HospDr;
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});	
}
