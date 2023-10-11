/*
 * FileName: dhcbill.ipbill.itmfeedtlsaudit.js
 * Author: gongxin
 * Date: 2023-04-21
 * Description: �������
*/

$(function () {
	refreshBar(CV.PatientID, CV.EpisodeID);
	initQueryMenu();
	initPBOList();
	
	//+upd gongxin ����������ʾ������Ϣ��
	if(CV.WindowType==""){
		$('#itmfeeauditlayout').layout('remove','north');
		
		$('#itmfeeauditlayout').layout('add',{    
    		region: 'north',    
    		height: 10,  
    		border:false ,  //ʹ�����֮������û����
    		bodyCls:'panel-body-gray',
    		content:"<p style='height:10px'></p>"
		});
		
		//$("#itmfeeauditlayout .layout-panel-north .panel-body-noheader").eq(1).addClass("panel-body-noborder");
	}
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			findClick();
		}
	});

	$HUI.linkbutton("#btn-confirm", {
		onClick: function () {
			confirmClick();
		}
	});
	
	$HUI.linkbutton("#btn-cancel", {
		onClick: function () {
			cancelClick();
		}
	});
	
	//��������Ŀ������ʶ
	$HUI.combobox("#reimbursementMark", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [//{value: '', text: $g(''), selected: true},
			   {value: '0', text: $g('ȫ��'), selected: true},
			   {value: '1', text: $g('ҽ��')},
		       {value: '2', text: $g('�Է�')}
		],onChange: function(newValue, oldValue) {
			if(newValue=="0"){
				//$HUI.checkbox("#zfMark","check");
			}else{
				$HUI.checkbox("#zfMark","uncheck");
			}
		}
	});
	
	//��˱�־
	$HUI.combobox("#confirmFlag", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: 'Y', text: $g('ͨ��'), selected: true},
		       {value: 'N', text: $g('�ܾ�')}
		]
	});
	
	//�շ������
	$HUI.combobox("#tarCate", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryTarIC&ResultSetType=array&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				$("#tarSubCate").combobox("clear").combobox("loadData", []);
				return;
			}
			var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryTarInpatCate&ResultSetType=array&tarTICDR=" + newValue + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
			$("#tarSubCate").combobox("clear").combobox("reload", url);
		}
	});
	
	//�շ�������
	$HUI.combobox("#tarSubCate", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	$HUI.checkbox("#zfMark",{
		onChecked:function(e,value){
			//if(getValueById("reimbursementMark")==2){
				$('#reimbursementMark').combobox('setValue', '0');
			//}
		}
	});
}

function initPBOList() {
	$HUI.datagrid("#pboList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "BILL.IP.BL.ItmFeeDtlsAudit",
		queryName: "ItmFeeDtlsQuery",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["BillDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["PBOOEORIDR", "PBDDr", "TARItmDr", "INSUItmDr", "CoverMainInsExt", "INAUDCoverMainIns", "ControlCoverMainIns" ,"TARICode", "unusualflag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "BillTime") {
					cm[i].formatter = function(value, row, index) {
					   	if (value) {
							return row.BillDate + " " + value;
						}
					};
				}
				if (cm[i].field == "TARIDesc") {
					cm[i].styler = function(value, row, index) {
					   	if (row.unusualflag==1) {
							return  'background-color:#ff9898;';
						}
					};
				}
				
				if ($.inArray(cm[i].field, ["INSUItmBZ","unusualreason"]) != -1) {
					cm[i].showTip = true;
					cm[i].tipWidth = 300;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["BillTime"]) != -1) {
						cm[i].width = 160;
					}
					if(cm[i].field=="InsuXMLB"){
						cm[i].width = 165;
					}
					if ($.inArray(cm[i].field, ["TARIDesc", "INSUItmBZ", "unusualreason"]) != -1) {
						cm[i].width = 250;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "BILL.IP.BL.ItmFeeDtlsAudit",
			QueryName: "ItmFeeDtlsQuery",
			BillDr: CV.BillID,
			StaDate: getValueById("stDate"),
			EndDate: getValueById("endDate"),
			TarCateDr: getValueById("tarCate"),
			TarSubCateDr: getValueById("tarSubCate"),
			TarDesc: getValueById("tarItem"),
			SelfFlag: (getValueById("zfMark") ? "Y" : "N"),
			RestrFundFlag: getValueById("reimbursementMark")
		}
	});
}

function findClick() {
	var queryParams = {
		ClassName: "BILL.IP.BL.ItmFeeDtlsAudit",
		QueryName: "ItmFeeDtlsQuery",
		BillDr: CV.BillID,
		StaDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		TarCateDr: getValueById("tarCate"),
		TarSubCateDr: getValueById("tarSubCate"),
		TarDesc: getValueById("tarItem"),
		SelfFlag: (getValueById("zfMark") ? "Y" : "N"),
		RestrFundFlag: getValueById("reimbursementMark")
	}
	loadDataGridStore("pboList", queryParams);
}

/**
* ���
*/
function confirmClick() {
	if ($("#btn-confirm").linkbutton("options").disabled) {
		return;
	}
	$("#btn-confirm").linkbutton("disable");
	
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�����?", function(r) {
		if (!r) {
			$("#btn-confirm").linkbutton("enable");
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBillDetailOrder",
			MethodName: "Confirm",
			Adm: CV.EpisodeID,
			BillNo: CV.BillID,
			User: PUBLIC_CONSTANT.SESSION.USERID,
			Reason: getValueById("confirmReason"),
			Flag: getValueById("confirmFlag")
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "��˳ɹ�", type: "success"});
				$("#btn-confirm").linkbutton("enable");
				return;
			}
			$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
			$("#btn-confirm").linkbutton("enable");
		});
	});
}

/**
* �������
*/
function cancelClick() {
	if ($("#btn-cancel").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancel").linkbutton("disable");
	
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϳ������?", function(r) {
		if (!r) {
			$("#btn-cancel").linkbutton("enable");
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBillDetailOrder",
			MethodName: "Confirm",
			Adm: CV.EpisodeID,
			BillNo: CV.BillID,
			User: PUBLIC_CONSTANT.SESSION.USERID,
			Reason: getValueById("confirmReason"),
			Flag: "C"
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "������˳ɹ�", type: "success"});
				$("#btn-cancel").linkbutton("enable");
				return;
			}
			$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
			$("#btn-cancel").linkbutton("enable");
		});
	});
}
