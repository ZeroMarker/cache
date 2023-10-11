/**
 * FileName: dhcbill/outpay/dhcbill.outpay.insuprocess.js
 * Anchor: lxy
 * Date: 2022-12-22
 * Description: 审核明细
 */
var AuditArray="";
$(function () {
	initInsuProcessList();
	initQueryMenu();
	if ((InvStr!="")&&(typeof InvStr !="undefined")){
		getDataGridData();
	}
});


function initQueryMenu() {
	//项目名称查询事件
	$("#itemDesc").focus().keydown(function (e) {
		itemDescKeydown(e);
	});

}

function itemDescKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getDataGridData();
	}
}

/*
//项目名称
function initItem() { 
	$('#itemDesc').combogrid({   
	 panelWidth: 500,
	 fitColumns: true,
	 method: 'GET',
	 pagination: true,
	 idField: 'ItmDesc',
	 textField: 'ItmDesc',
	 mode: 'remote',
	 url: $URL + '?ClassName=BILL.OUTPAY.BL.ItemCtl&QueryName=ItmInfoQuery',
	 delay: 300,
	 lazy: true,
	 enterNullValueClear: false,
	 selectOnNavigation: false,
	 columns: [[
     {field: 'ItmDR', title: 'rowid', width:250, hidden:true},
	 {field: 'ItmCode', title: '收费项代码', width: 100},
	 {field: 'ItmDesc', title: '收费项名称', width: 150},  
	 ]],
	 onBeforeLoad: function (param) {
	 	param.key = param.q;
	 	param.AdmReasonDr =AdmReasonDr;
	 	param.HospDr = session['LOGON.HOSPID'];							
		 },
	 onLoadSuccess:function(data){
			getDataGridData();
		}
	});
}
*/


function getDataGridData(){
   var queryParams = {
	   ClassName: 'BILL.OUTPAY.BL.OPInvAuditCtl',
	   QueryName: 'InvItemListQuery',
	   InvStr: InvStr,
	   AdmReasonDr:AdmReasonDr,
	   ItmName:getValueById('itemDesc'),
	   HospDr:session['LOGON.HOSPID']
	}
	loadDataGridStore('InsuProcessList',queryParams);	
}

function initInsuProcessList(){
	$('#InsuProcessList').datagrid({
		fit: true,
		border: false,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: false,
		rownumbers: true,
		columns:[[
		   {field:'InvNo',title:'发票号',width:120},
		   {field:'OutFlag',title:'是否外院发票',width:100,
		    formatter: function (value, row, index) {
				if (value) {
						return (value == 'Y') ? ('<font color="#21ba45">' + $g('是') + '</font>') : ('<font color="#f16e57">' + $g('否') + '</font>');
					}
			}},
		   {field:'PBODDr',title:'PBODDr',width:150,hidden:true},
		   {field:'ItmDR',title:'项目id',width:150,hidden:true,sortable:true,order:"acs"},
		   {field:'ItmCode',title:'项目编码',width:80,hidden:true},
		   {field:'ItmDesc',title:'项目名称',width:200},
		   {field:'ItemId',title:'ItemId',width:150,hidden:true},
		   {field:'InvDr',title:'发票id',width:150,hidden:true},
		   {field:'bz',title:'限制使用',width:100,showTip:true,tipWidth:450,tipTrackMouse:true},
		   {
			title: '审核通过',
			field: 'HospApprFlag1',
			width: 100,
			align: 'center',
			formatter: function (value, row, index) {
			if(row.HospApprFlag=="2"){
			return '<input  type="radio" name="selectRadio'+index+'" id="selectRadioL'+index+'" checked="checked"  onclick="clk(\''+row["ItmDesc"] + '\','+index+',\'L\')" />';
			}else{
			return '<input  type="radio" name="selectRadio'+index+'" id="selectRadioL'+index+'"  onclick="clk(\''+row["ItmDesc"] + '\','+index+',\'L\')"/>';	
				}
			}
		},
		{
			title: '不需要审核',
			field: 'HospApprFlag2',
			width: 100,
			align: 'center',
			formatter: function (value, row, index) {
			if((row.HospApprFlag=="0")||(row.HospApprFlag==""&&row.bz!="")){
			return '<input  type="radio" name="selectRadio'+index+'" id="selectRadioR'+index+'" checked="checked"  onclick="clk(\''+row["ItmDesc"] + '\','+index+',\'R\')" />';
			}else{
			return '<input  type="radio" name="selectRadio'+index+'" id="selectRadioR'+index+'"  onclick="clk(\''+row["ItmDesc"] + '\','+index+',\'R\')" />';	
				}
			}
		},
 		   {field:'BillDate',title:'费用发生日期',width:100},
		   {field:'BillTime',title:'费用发生时间',width:100},
		   {field:'HospApprFlag',title:'审核标识',width:100,hidden:true},
		   {field:'HospApprUserDr',title:'审核人Dr',width:100,hidden:true},
		   {field:'HospApprUser',title:'审核人',width:100},
		   {field:'HospApprDate',title:'审核日期',width:100},
		   {field:'HospApprTime',title:'审核时间',width:100},
		   {field:'Price',title:'单价',width:100,align: 'right'},
		   {field:'Qty',title:'数量',width:100},
		   {field:'Amt',title:'金额',width:100,align: 'right'},
		   {field:'InsuItmCode',title:'医保项目编码',width:100,hidden:true},
		   {field:'InsuItmDesc',title:'医保项目名称',width:100},
		   {field:'InsuScale',title:'自付比例',width:100}
		]],
		sortName:"ItmDR",
		sortOrder:"acs",
		remoteSort:false,
		onBeforeLoad:function(data){
			data.rows = "9999999";
			return data;
		}
   });
}
	
	
function clk(ItmName,num,type){
	 var arr=$('#InsuProcessList').datagrid('getData');
	 var checkedRadio=$('#selectRadio'+type+num)
	 var checkedRadioL=$('#selectRadioL'+num)
	 var checkedRadioR=$('#selectRadioR'+num)
	  if((checkedRadioL.data('waschecked')==true)&&(type=="L")){
		 checkedRadioL.prop('checked', false);
		 checkedRadioL.data('waschecked', false);
		 checkedRadioR.data('waschecked', true);
		 }else if ((checkedRadioL.data('waschecked')!=true)&&(type=="L")){
		 checkedRadioL.prop('checked', true); 
		 checkedRadioL.data('waschecked', true);
		 checkedRadioR.data('waschecked', false);
	     }else if ((checkedRadioR.data('waschecked')==true)&&(type=="R")){
		 checkedRadioR.prop('checked', false);
		 checkedRadioR.data('waschecked', false);
		 checkedRadioL.data('waschecked', true);
		 }else if ((checkedRadioR.data('waschecked')!=true)&&(type=="R")){
		 checkedRadioR.prop('checked', true); 
		 checkedRadioR.data('waschecked', true);
		 checkedRadioL.data('waschecked', false);
		 }
	 if (arr.rows.length >0) {
     for (var i = num; i < arr.rows.length ; i++) {
	 	var checkedRadio2=$('#selectRadio'+type+i)
		if ((arr.rows[i].ItmDesc==ItmName)){
			checkedRadio2.prop('checked',checkedRadio.prop('checked'))
        	 } 
		 }	
	}
}



function SaveClick() {
    var arr = $('#InsuProcessList').datagrid('getData');
    var AuditArr = new Array();
    if (arr.rows.length > 0) {
        for (var i = 0; i < arr.rows.length; i++) {
            var ItemId = arr.rows[i].ItemId;
            var PBOD = PBODType;
            var PBODDR = arr.rows[i].PBODDr;
            if (($('#selectRadioL' + i).prop('checked') == true) && ($('#selectRadioR' + i).prop('checked') == false)) {
                var HospApprFlag = "2";
            } else if (($('#selectRadioL' + i).prop('checked') == false) && $('#selectRadioR' + i).prop('checked') == true) {
                var HospApprFlag = "0";
            } else {
                var HospApprFlag = "1";
            };
            var Audit = ItemId + "^" + PBOD + "^" + PBODDR + "^" + HospApprFlag + "^" + session['LOGON.USERID'];
            AuditArr[i] = Audit;
        };
    };
    var Audit=AuditArr
    $.messager.confirm("确认","是否确认审核？",function(res){
	    if(!res){
		return;
		};
    $m({
        ClassName: "BILL.OUTPAY.BL.OPInvAuditCtl",
        MethodName: "InvItemsAudit",
        AuditList: Audit,
        AdmReasonDr:AdmReasonDr
    }, function (rtn) {
	    //var myAry = rtn.split("^");
        if (rtn == 0) {
	        $.messager.popover({msg: $g("操作成功！"), type: 'success'});
            getDataGridData();
            return;
        }
        $.messager.popover({msg: rtn, type: 'error'});
    	});
    });
}