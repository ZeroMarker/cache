/**
 * FileName: dhcbill.dc.billbalance.js
 * Author: tangzf
 * Date: 2022-06-6
 * Description: �˵�ƽ����У��
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
//�������
$(function(){
	//�س��¼�    
	key_enter();
	// ��Ʒ��
	//ini_ProductLine();	
	//ҵ������box
	//ini_YWLX();
	
	//Ĭ��ʱ��
	setDateBox();
	// ��ʾ��Ϣ
    $("#csconflg-tips").popover({
	    trigger:'hover',
	    placement:'bottom',
	    content:'<font color=' + TPBAndPBOColor + '>�˵��ܽ����˵�ҽ���ܽ�ƽ<font><br/>\
	    		 <font color=' + TPBSelfAndPBOColor + '>�˵��Ը������˵�ҽ���Ը���ƽ<br/>\
	    		 <font color=' + TPBOAndPBDColor + '>�˵�ҽ���ܽ����˵���ϸ�ܽ�ƽ<br/>\
	    		 <font color=' + TPBOSelfAndPBDColor + '>�˵�ҽ���Ը������˵���ϸ�Ը���ƽ',
	    width :300,
	    
	});
	// grid
	init_dg();
	
	//  ����Ա
	//InitUser();
	RunQuery();
});
//�������
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
			{title: '�ǼǺ�', field: 'RegNo', width: 100},
			{title: '����', field: 'PatName', width: 60},
			{title: '�ʵ���', field: 'ErrBill', width: 140},
			{title: '�ʵ��ܽ��', field: 'PBAmount', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(val !="" && REG.test(val)){
						if(val !=row.PBOToTalAmount.split(':')[1])	{
							color=TPBAndPBOColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: '�ʵ��Ը����', field: 'PBPatientShare', width: 110,align:'right',
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
			{title: 'PBO�ܽ��', field: 'PBOToTalAmount', width: 120,align:'right',
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
			{title: 'PBO�Ը����', field: 'PBOPatientShare', width: 120,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.PBAmount !=""){ // PBO֮�ͺ�PB�Ը�����
						if(row.PBAmount !=val.split(':')[1])	{
							color=TPBSelfAndPBOColor;
						}
					}
					if(row.ShowPBO !=""){ // PBD֮�ͺ�PBO�Ը�����
						if(val !=row.PBDPatientShare.split(':')[1])	{
							color=TPBOSelfAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: 'PBD', field: 'ShowPBD', width: 90},
			{title: 'PBD�ܽ��', field: 'PBDTotalAmount', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.ShowPBO !=""){ //
						if(row.PBOToTalAmount !=val.split(':')[1])	{
							color=TPBOAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: 'PBD�Ը����', field: 'PBDPatientShare', width: 110,align:'right',
				formatter:function(val,row,index){
					var color = "";
					if(row.ShowPBO !=""){ //
						if(row.PBOPatientShare !=val.split(':')[1])	{
							color=TPBOSelfAndPBDColor;
						}
					}
					return "<font color='" + color + "'>" + val + "</font>";
				}},
			{title: '�˵�����', field: 'ShowPBD', width: 90}
			
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

//��ѯ
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
//Ĭ��ʱ��
function setDateBox() {
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
///�س�
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
//����
function clear_click() {
	$('#tQueryPanel').form('clear');
	setDateBox();
	RunQuery();	
}
//ҵ������
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
			{ title: '����', field: 'cCode', width: 200 },
			{ title: '����', field: 'cDesc', width: 200 }
		]]
	})
}
// ��Ʒ��
function ini_ProductLine() {
	$HUI.combogrid("#ProductLine", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=ProductLine"+'&HospDr='+HospDr+'&ExpStr=N',
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '����', field: 'cCode', width: 200 },
			{ title: '����', field: 'cDesc', width: 200 }
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
 * Description: ���ɴμ�����Modifydl
 * input:	msg : ��ʾ����
 * 			buttonType : �Ƿ���ʾ��ť "disable" ����ʾ
 * 			title : ��������
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
