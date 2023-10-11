/**
 * Description：服务级别维护
 * FileName: dhcpe.ct.serviceclass.js
 * @Author   wangguoying
 * @DateTime 2021-08-10
 */
var _SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
var _tableNme = "DHC_HM_CServiceClass";


/**
 * [初始化服务级列表]
 * @Author   wangguoying
 * @DateTime 2021-08-10
 */
function initSCDatagrid(){
	$("#SCID").val("");
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;
	$HUI.datagrid("#SCList", {
		url: $URL,
		title: "",
		bodyCls: 'panel-body-gray',
		border: false,
		queryParams: {
			ClassName: "web.DHCPE.CT.HM.BaseDataSet",
			QueryName: "GetCServiceClassNew",
			LocID : locId
		},
		onSelect: function(rowIndex, rowData) {
			if (rowIndex > -1) {
				//ClearBtn_onclick();
				$("#SCID,#Code,#Desc,#Price,#Months,#Remark").val("");
				$("#Active").checkbox("check");

				QClear_onclick();
				$("#QRList").datagrid("load",{
					ClassName: "web.DHCHM.BaseDataSet",
					QueryName: "GetCSCQLink",
					theid: rowData.ID,
					LocID:$("#LocList").combobox("getValue")
				});
				$("#SCID").val(rowData.ID);
				$("#Code").val(rowData.SCCode);
				$("#Desc").val(rowData.SCDesc);
				$("#Price").val(rowData.SCPrice);
				$("#Months").val(rowData.SCMonths);
				$("#Remark").val(rowData.SCRemark);
				if (rowData.SCActive == "true") {
					$("#Active").checkbox("check");
				} else {
					$("#Active").checkbox("uncheck");
				}
				if (rowData.TEmpower == "Y") {
					$("#Empower").checkbox("check");
				} else {
					$("#Empower").checkbox("uncheck");
				}
			}
			
		},
		onDblClickRow: function(index, row) {},
		columns: [
			[{
				field: 'ID',
				hidden: true,
				sortable: 'true'
			}, {
				field: 'SCCode',
				width: 100,
				title: '编码'
			}, {
				field: 'SCDesc',
				width: 150,
				title: '描述'
			}, {
				field: 'SCActive',
				width: 40,
				title: '激活',
				align: 'center',
				formatter: function(value, row, index) {
					var checked = value == "true" ? "checked" : "";
					return "<input type='checkbox' disabled class='hisui-checkbox' " + checked + " >";
				}
			},{
				field:'TEmpower',width:90,title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},{ 
				field:'TEffPowerFlag',
				width:'100',
				align:'center',
				title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
					return '<input type="checkbox" value="" disabled/>';
				 }
				}
			}, {
				field: 'SCPrice',
				width: 100,
				title: '建议价格'
			}, {
				field: 'SCMonths',
				width: 150,
				title: '随访间隔时间(月)'
			}, {
				field: 'SCRemark',
				width: 200,
				title: '备注'
			}]
		],
		toolbar:[{
			iconCls: 'icon-key',
			
			text: '数据关联科室',
			handler: function(){relateLocWin();}
		}],
		fitColumns: true,
		pagination: true,
		pageSize: 20,
		fit: true,
		rownumbers: true
	});
	initQRDataGrid();
}

/**
 * [授权科室]
 * @Author   wangguoying
 * @DateTime 2021-08-11
 */
function relateLocWin(){	
	var row = $("#SCList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"未选择记录"});
		return false;
	} 
	//单独授权 
	if(row.TEmpower!="Y"){
		 $.messager.popover({type:"alert",msg:"该记录没单独授权,不能关联科室！"});
		 return false;
	}
	
    var LocID=$("#LocList").combobox('getValue')
    OpenLocWin(_tableNme,row.ID,_SessionStr,LocID,initSCDatagrid);
}


function initQRDataGrid(){
	$HUI.datagrid("#QRList", {
		url: $URL,
		title: "",
		bodyCls: 'panel-body-gray',
		queryParams: {
			ClassName: "web.DHCHM.BaseDataSet",
			QueryName: "GetCSCQLink",
			theid: $("#SCID").val(),
			LocID:$("#LocList").combobox("getValue")
		},
		onSelect: function(rowIndex, rowData) {
			if (rowIndex > -1) {
				QClear_onclick();
				$("#QRID").val(rowData.ID);
				$("#Questionnaire").combobox("setValue", rowData.SCQLCQuestionnaireDR);
				$("#QSeq").val(rowData.SCQLOrder);
				$("#QRemark").val(rowData.SCQLRemark);
			}
		},
		onDblClickRow: function(index, row) {},
		columns: [
			[{
				field: 'ID',
				hidden: true,
				sortable: 'true'
			}, {
				field: 'SCQLCQuestionnaireDR',
				hidden: true
			}, {
				field: 'QDesc',
				width: 200,
				title: '问卷'
			}, {
				field: 'SCQLOrder',
				width: 60,
				title: '顺序'
			}, {
				field: 'SCQLRemark',
				width: 100,
				title: '备注'
			}]
		],
		fitColumns: true,
		pagination: true,
		pageSize: 20,
		fit: true,
		rownumbers: true
	});
}

/**
 * 左侧清屏
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function ClearBtn_onclick() {
	
	$("#SCID").val("");
	$("#Code").val("");
	$("#Desc").val("");
	$("#Price").val("");
	$("#Months").val("");
	$("#Remark").val("");
	$("#Active").checkbox("check");
	$("#Empower").checkbox("uncheck");
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	$("#SCList").datagrid("load",{
		ClassName: "web.DHCPE.CT.HM.BaseDataSet",
		QueryName: "GetCServiceClassNew",
		LocID:locId
	});
	$("#QRList").datagrid("load",{
			ClassName: "web.DHCHM.BaseDataSet",
			QueryName: "GetCSCQLink",
			theid:"",
			LocID:$("#LocList").combobox("getValue")
	});


}

/**
 * 左侧保存
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function SaveBtn_onclick() {
	var ID = $("#SCID").val();
	var Code = $("#Code").val();
	var Desc = $("#Desc").val();
	var Price = $("#Price").val();
	var Months = $("#Months").val();
	var Remark = $("#Remark").val();
	var Active = "N";
	if ($("#Active").checkbox("getValue")) {
		Active = "Y";
	}
	if (Code == "") {
		$.messager.alert("提示", "代码不能为空", "info");
		return false;
	}
	if (Desc == "") {
		$.messager.alert("提示", "描述不能为空", "info");
		return false;
	}
	//单独授权 
	var iEmpower = "N";
	if ($("#Empower").checkbox("getValue")) {
		iEmpower = "Y";
	}
	
	var proStr = "SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark";
	var valStr = Active + "^" + Code + "^" + Desc + "^" + Months + "^" + Price + "^" + Remark;
	var UserID = session['LOGON.USERID'];
	try {
		var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData", "SaveSrvClass", ID, proStr,valStr,$("#LocList").combobox("getValue"),UserID,iEmpower);
		if (parseInt(ret) < 0) {
			var errMsg = ret.split("^").length > 1 ? ":" + ret.split("^")[1] : "";
			$.messager.alert("错误", "保存失败" + errMsg, "error");
			return false;
		} else {
			$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
			
			ClearBtn_onclick();
		}
	} catch (err) {
		$.messager.alert("错误", "保存失败：" + err.description, "error");
		return false;
	}
}
/**
 * 右侧清屏
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QClear_onclick() {
	$("#QRID").val("");
	$("#Questionnaire").combobox("setValue", "");
	$("#QSeq").val("");
	$("#QRemark").val("");
}
/**
 * 保存关联问卷
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QSave_onclick() {
	var ID = $("#QRID").val();
	var SCID = $("#SCID").val();
	var Questionnaire = $("#Questionnaire").combobox("getValue");
	var QSeq = $("#QSeq").val();
	var QRemark = $("#QRemark").val();
	if (SCID == "") {
		$.messager.alert("提示", "所属服务不能为空", "info");
		return false;
	}
	if (Questionnaire == "") {
		$.messager.alert("提示", "所属问卷不能为空", "info");
		return false;
	}
	if (QSeq == "") {
		$.messager.alert("提示", "序号不能为空", "info");
		return false;
	}
	var property = "SCQLParRef^SCQLCQuestionnaireDR^SCQLOrder^SCQLRemark";
	var valList = SCID + "^" + Questionnaire + "^" + QSeq + "^" + QRemark;
	try {
		var ret = tkMakeServerCall("web.DHCHM.BaseDataSet", "CSCQLinkSaveData", ID, valList, property);
		if (parseInt(ret) < 0) {
			var errMsg = ret.split("^").length > 1 ? ":" + ret.split("^")[1] : "";
			$.messager.alert("错误", "保存失败" + errMsg, "error");
			return false;
		} else {
			$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
			$("#QRList").datagrid("load",{
				ClassName: "web.DHCHM.BaseDataSet",
				QueryName: "GetCSCQLink",
				theid: SCID,
				LocID :$("#LocList").combobox("getValue")
			});
			QClear_onclick();
		}
	} catch (err) {
		$.messager.alert("错误", "保存失败：" + err.description, "error");
		return false;
	}
}
/**
 * 删除关联问卷
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QDeleter_onclick() {
	var ID = $("#QRID").val();
	var SCID = $("#SCID").val();
	if (ID == "") {
		$.messager.alert("提示", "请选择需要删除的行", "info");
		return false;
	}
	$.messager.confirm("删除", "确定删除记录?", function(r) {
		if (r) {
			try {
				var ret = tkMakeServerCall("web.DHCHM.BaseDataSet", "CSCQLinkDelete", ID);
				if (parseInt(ret) < 0) {
					var errMsg = ret.split("^").length > 1 ? ":" + ret.split("^")[1] : "";
					$.messager.alert("错误", "删除失败" + errMsg, "error");
					return false;
				} else {
					$.messager.popover({msg: '删除成功',type:'success',timeout: 1000});
					$("#QRList").datagrid("load",{
						ClassName: "web.DHCHM.BaseDataSet",
						QueryName: "GetCSCQLink",
						theid: SCID,
						LocID: $("#LocList").combobox("getValue")
					});
					QClear_onclick();
				}
			} catch (err) {
				$.messager.alert("错误", "删除失败：" + err.description, "error");
				return false;
			}
		} else {

		}
	});

}

function init_questionnaire(){
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;
	$HUI.combobox("#Questionnaire",{
		url:$URL+"?ClassName=web.DHCPE.CT.HM.CommonData&QueryName=FindQuestionnaire&Active=Y&LocID="+locId+"&ResultSetType=array",
		valueField:'QNID',
		textField:'QDesc',
		onSelect:function(record){
		}
	});
}

function init() {
	GetLocComp(_SessionStr);
	//科室下拉列表change
	$("#LocList").combobox({
		onSelect: function() {
			initSCDatagrid();
			init_questionnaire();
		}
	});
	
}


$(init);
