/*
 * FileName: dhcpe/ct/viplevel.js
 * Author: xy
 * Date: 2021-08-08
 * Description: VIP等级维护
 */

var tableName = "DHC_PE_LocVIPLevel";

var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID']

$(function () {

	//获取科室下拉列表
	GetLocComp(SessionStr)

	InitCombobox();

	//初始化 VIP等级Grid
	InitVIPGrid();

	//初始化 VIP等级详情Grid
	InitLocVIPGrid();

	//科室下拉列表change
	$("#LocList").combobox({
		onSelect: function () {
			var LocID = session['LOGON.CTLOCID']
			var LocListID = $("#LocList").combobox('getValue');
			if (LocListID != "") { var LocID = LocListID; }

			$("#LocVIPGrid").datagrid('load', {
				ClassName: "web.DHCPE.CT.VIPLevel",
				QueryName: "FindLocVIPInfo",
				VIPLevelID: $("#ID").val(),
				NoActiveFlag: $("#NoActive").checkbox('getValue') ? "Y" : "N",
				LocID: LocID
			})


			/*****************服务级别重新加载(combobox)*****************/
			var HMServiceurl = $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindHMService&ResultSetType=array&LocID=" + LocID;
			$('#HMService').combobox('reload', HMServiceurl);
			/*****************服务级别重新加载(combobox)*****************/
		}

	});



	//查询
	$('#BFind').click(function () {
		BFind_click();
	});

	//清屏
	$('#BClear').click(function () {
		BClear_click();
	});

	//新增
	$('#BAdd').click(function () {
		BAdd_click();
	});

	//修改
	$('#BUpdate').click(function () {
		BUpdate_click();
	});


	//清屏(科室VIP等级维护)
	$('#BLClear').click(function () {
		BLClear_click();
	});

	//新增(科室VIP等级维护)
	$('#BLAdd').click(function () {
		BLAdd_click();
	});

	//修改(科室VIP等级维护)
	$('#BLUpdate').click(function () {
		BLUpdate_click();
	});
	/*
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			$("#LocVIPGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.VIPLevel",
			QueryName:"FindLocVIPInfo",
			VIPLevelID:$("#ID").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:$("#LocList").combobox('getValue')
			})			
		}			
	});   
	 */

	//查询(科室VIP等级维护)
	$('#BLFind').click(function () {
		BLFind_click();
	});

})



/*******************************VIP等级 start*************************************/
//查询
function BFind_click() {
	$("#VIPGrid").datagrid('load', {
		ClassName: "web.DHCPE.CT.VIPLevel",
		QueryName: "FindVIPLevel",
		Code: $("#Code").val(),
		Desc: $("#Desc").val(),
		NoActive: $("#VIPNoActive").checkbox('getValue') ? "Y" : "N"

	});
}

//清屏
function BClear_click() {
	$("#ID,#Code,#Desc").val("");
	$("#VIPNoActive").checkbox('setValue', true);
	BFind_click();
	BLFind_click();

}

//新增
function BAdd_click() {

	BSave_click("0");
}

//修改
function BUpdate_click() {
	BSave_click("1");
}

function BSave_click(Type) {

	if (Type == "1") {
		var ID = $("#ID").val();
		if (ID == "") {
			$.messager.alert("提示", "请选择待修改的记录", "info");
			return false;
		}
	}
	if (Type == "0") {
		if ($("#ID").val() != "") {
			$.messager.alert("提示", "新增数据不能选中记录,请点击清屏后进行新增", "info");
			return false;
		}
		var ID = "";
	}

	var Code = $("#Code").val();
	if ("" == Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
		});
		$.messager.alert("提示", "代码不能为空", "info");
		return false;
	}

	var Desc = $("#Desc").val();
	if ("" == Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
		});
		$.messager.alert("提示", "描述不能为空", "info");
		return false;
	}

	var iVIPNoActive = "N";
	var VIPNoActive = $("#VIPNoActive").checkbox('getValue');
	if (VIPNoActive) iVIPNoActive = "Y"

	var UserID = session['LOGON.USERID'];

	var InfoStr = Code + "^" + Desc + "^" + iVIPNoActive + "^" + UserID;

	//alert("InfoStr:"+InfoStr)

	var ret = tkMakeServerCall("web.DHCPE.CT.VIPLevel", "UpdateVIPLevel", ID, InfoStr);
	var Arr = ret.split("^");
	if (Arr[0]!="-1") {
		$.messager.popover({ msg:Arr[1], type: 'success', timeout: 1000 });
		BClear_click();
	} else {
		$.messager.alert("提示", Arr[1], "error");
	}


}

function InitVIPGrid() {
	$HUI.datagrid("#VIPGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.CT.VIPLevel",
			QueryName: "FindVIPLevel",
			NoActive: $("#VIPNoActive").checkbox('getValue') ? "Y" : "N"

		},
		frozenColumns: [[
			{ field: 'TCode', title: '代码', width: 60 },
			{ field: 'TDesc', title: '描述', width: 120 },

		]],
		columns: [[
			{ field: 'id', title: 'id', hidden: true },
			{ field: 'TNoActive', title: '激活', align: 'center', width: 60 },
			{ field: 'TUpdateDate', title: '更新日期', width: 120 },
			{ field: 'TUpdateTime', title: '更新时间', width: 120 },
			{ field: 'TUserName', title: '更新人', width: 120 }

		]],
		onSelect: function (rowIndex, rowData) {

			$("#ID").val(rowData.id);
			$("#Desc").val(rowData.TDesc);
			$("#Code").val(rowData.TCode);
			$('#LocVIPGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			BLClear_click();

		}
	});
}

/*******************************VIP等级 end*************************************/


/*******************************科室VIP等级详情 start*************************************/

//查询(科室VIP等级维护)
function BLFind_click() {

	$("#LocVIPGrid").datagrid('load', {
		ClassName: "web.DHCPE.CT.VIPLevel",
		QueryName: "FindLocVIPInfo",
		VIPLevelID: $("#ID").val(),
		NoActiveFlag: $("#NoActive").checkbox('getValue') ? "Y" : "N",
		LocID: $("#LocList").combobox('getValue')
	})
}


//清屏
function BLClear_click() {

	$("#LVID,#HPCode,#Template,#ZYDInfo,#ZYDTemplate").val("");
	$("#Secret,#Default").checkbox('setValue', false);
	$("#NoActive").checkbox('setValue', true);
	$("#PatFeeType,#HMService,#CutInLine,#GeneralType").combobox('setValue', "");
	$("#OrdSetsDesc").combogrid('setValue', "");
	$("#GeneralType").combobox('setValue', "JKTJ");
	$("#GIFlag").combobox("setValue", "");
	BLFind_click();

}

//新增
function BLAdd_click() {

	BLSave_click("0");
}

//修改
function BLUpdate_click() {
	BLSave_click("1");
}


function BLSave_click(Type) {

	var VIPLevelDR = $("#ID").val();
	if (VIPLevelDR == "") {
		$.messager.alert("提示", "请选择VIP等级记录", "info");
		return false;
	}

	if (Type == "1") {
		var ID = $("#LVID").val();
		if (ID == "") {
			$.messager.alert("提示", "请选择待修改的记录", "info");
			return false;
		}
	}
	if (Type == "0") {
		if ($("#LVID").val() != "") {
			$.messager.alert("提示", "新增数据不能选中记录,请点击清屏后进行新增", "info");
			return false;
		}
		var ID = "";
	}


	var LocID = $("#LocList").combobox('getValue');

	var iHPCode = $("#HPCode").val();
	if ("" == iHPCode) {
		$("#HPCode").focus();
		var valbox = $HUI.validatebox("#HPCode", {
			required: true,
		});
		$.messager.alert("提示", "体检号编码不能为空", "info");
		return false;
	}

	var iZYDTemplate = ""
	//var iZYDTemplate=$("#ZYDTemplate").val();

	var iZYDInfo = $("#ZYDInfo").val();

	var iTemplate = $("#Template").val();

	var iPatFeeType = $("#PatFeeType").combobox('getValue');

	var iGeneralType = $("#GeneralType").combobox('getValue');

	var iHMService = $("#HMService").combobox('getValue');

	var reg = /^[0-9]+.?[0-9]*$/;
	if ((!(reg.test(iHMService))) && (iHMService != "")) { var iHMService = $("#HMServiceDR").val(); }

	var iCutInLine = $("#CutInLine").combobox('getValue');

	var iOrdSetsDesc = $("#OrdSetsDesc").combogrid('getValue');
	if (($("#OrdSetsDesc").combogrid('getValue') == undefined) || ($("#OrdSetsDesc").combogrid('getValue') == "")) { var iOrdSetsDesc = ""; }

	var iNoActive = "N";
	var NoActive = $("#NoActive").checkbox('getValue');
	if (NoActive) iNoActive = "Y"

	var iSecret = "N";
	var Secret = $("#Secret").checkbox('getValue');
	if (Secret) iSecret = "Y"

	var iDefault = "N";
	var Default = $("#Default").checkbox('getValue');
	if (Default) iDefault = "Y"

	var giFlag = $("#GIFlag").combobox("getValue");

	var UserID = session['LOGON.USERID'];

	var InfoStr = iHPCode + "^" + iZYDTemplate + "^" + iZYDInfo + "^" + iTemplate + "^" + iPatFeeType + "^" + iGeneralType + "^" + iHMService + "^" + iCutInLine + "^" + iOrdSetsDesc + "^" + iNoActive + "^" + iSecret + "^" + iDefault + "^" + LocID + "^" + UserID + "^" + tableName + "^" + VIPLevelDR + "^" + giFlag;

	//alert("InfoStr:"+InfoStr)

	var ret = tkMakeServerCall("web.DHCPE.CT.VIPLevel", "UpdateLocVIPLevel", ID, InfoStr);
	var Arr = ret.split("^");
	if (Arr[0] == "-1") {
		$.messager.alert("提示", Arr[1], "error");
	} else {
		$.messager.alert("提示", Arr[1], "success");
		BLFind_click();
	}

}


function InitLocVIPGrid() {
	$HUI.datagrid("#LocVIPGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.CT.VIPLevel",
			QueryName: "FindLocVIPInfo",
			LocID: session['LOGON.CTLOCID'],
			NoActiveFlag: $("#NoActive").checkbox('getValue') ? "Y" : "N",
			VIPLevelID: $("#ID").val()
		},

		frozenColumns: [[
			{ field: 'HPCode', title: '体检号编码', width: 90 },
			{ field: 'Template', title: '报告模板', width: 120 },
			{ field: 'Default', title: '默认', width: 50 },
			{ field: 'NoActive', title: '激活', width: 50 }
		]],
		columns: [[

			{ field: 'ID', title: 'ID', hidden: true },
			{ field: 'Secret', title: '保密', width: 50 },
			{ field: 'FeeTypeDR', title: 'FeeTypeDR', hidden: true },
			{ field: 'FeeType', title: '体检类型', width: 150 },
			{ field: 'OrdSetsDR', title: 'OrdSetsDR', hidden: true },
			{ field: 'OrdSets', title: '默认套餐', width: 150 },
			{ field: 'ZYDInfo', title: '导诊单提示', width: 150 },
			{
				field: 'ZYDTemplate', title: '导诊单模板', width: 150, formatter: function (value, row, ind) {
					var text = "<span color='red'>默认</span>";
					if (value.indexOf("$") >= 0) {
						var headT = "", bodyT = "", footT = "";
						var templateA = value.split("$");
						for (var i = 0; i < templateA.length; i++) {
							var temp = templateA[i];
							if (i == 0) {  // Head
								switch (temp) {
									case "H-Simple": headT = "简单"; break;
									case "H-General": headT = "常规"; break;
									case "H-Fully": headT = "全面"; break;
									case "H-Custom": headT = "自定义"; break;
									default: "";
								}
							} else if (i == 1) {  // Body
								switch (temp) {
									case "B-Formatter1": bodyT = "项目格式1"; break;
									case "B-Formatter2": bodyT = "项目格式2"; break;
									case "B-Formatter3": bodyT = "项目格式3"; break;
									case "B-Formatter4": bodyT = "项目格式4"; break;
									case "B-Custom": bodyT = "自定义"; break;
									default: "";
								}
							} else if (i == 2) {  // Foot
								switch (temp) {
									case "F-NoFooter": footT = "无页脚"; break;
									case "F-Pagination": footT = "仅页码"; break;
									case "F-Tips": footT = "仅提示"; break;
									case "F-PageAndTips": footT = "页码+提示"; break;
									case "F-Receive": footT = "领取信息"; break;
									case "B-Custom": footT = "自定义"; break;
									default: "";
								}
							}
						}
						text = headT + "," + bodyT + "," + footT;
					}
					return "<a href='javascript:void(0);' class='grid-td-text' onclick='BShowDJDTemplate(\"" + row.ID + "\", \"" + value + "\")'>" + text + "</a>";
				}
			},
			{ field: 'HMServiceDR', title: 'HMServiceDR', hidden: true },
			{ field: 'HMService', title: '问卷级别', width: 150 },
			{ field: 'CutInLine', title: '是否插队', width: 90 },
			{ field: 'TGIFlagDR', title: 'TGIFlagDR', hidden: true },
			{ field: 'TGIFlag', title: '限额类型', width: 90 },
			{
				field: 'GeneralType', title: '总检类型', width: 150,
				formatter: function (value, rowData, rowIndex) {
					if (value == "JKTJ") return "健康体检";
					else if (value == "RZTJ") return "入职体检";
					else if (value == "GWY") return "公务员";
					else if (value == "ZYJK") return "职业健康";
					else if (value == "JKZ") return "健康证";
					else if (value == "OTHER") return "其他";
					else return "健康体检";
				}
			},
			{ field: 'UpdateDate', title: '更新日期', width: 150 },
			{ field: 'UpdateTime', title: '更新时间', width: 150 },
			{ field: 'UserName', title: '更新人', width: 120 }
		]],
		onSelect: function (rowIndex, rowData) {

			$("#LVID").val(rowData.ID);
			$("#HPCode").val(rowData.HPCode);
			$("#Template").val(rowData.Template);
			$("#ZYDInfo").val(rowData.ZYDInfo);
			$("#ZYDTemplate").val(rowData.ZYDTemplate);
			if (rowData.Secret == "N") {
				$("#Secret").checkbox('setValue', false);
			} if (rowData.Secret == "Y") {
				$("#Secret").checkbox('setValue', true);
			};

			if (rowData.Default == "N") {
				$("#Default").checkbox('setValue', false);
			} if (rowData.Default == "Y") {
				$("#Default").checkbox('setValue', true);
			};

			$("#PatFeeType").combobox('setValue', rowData.FeeTypeDR);
			$("#OrdSetsDesc").combogrid('setValue', rowData.OrdSetsDR);
			$("#HMService").combobox('setValue', rowData.HMService);
			$("#HMServiceDR").val(rowData.HMServiceDR)
			$("#CutInLine").combobox('setValue', rowData.CutInLine);
			$("#GeneralType").combobox('setValue', rowData.GeneralType);
			$("#GIFlag").combobox("setValue", rowData.TGIFlagDR);
			if (rowData.NoActive == "N") {
				$("#NoActive").checkbox('setValue', false);
			} if (rowData.NoActive == "Y") {
				$("#NoActive").checkbox('setValue', true);
			};


		}
	});
}

/*******************************科室VIP等级详情 end*************************************/
function InitCombobox() {
	var LocID = session['LOGON.CTLOCID']
	var LocListID = $("#LocList").combobox('getValue');
	if (LocListID != "") { var LocID = LocListID; }

	//体检类别
	var VIPObj = $HUI.combobox("#PatFeeType", {
		url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
		valueField: 'id',
		textField: 'desc',
		panelHeight: '70',
	});

	//问卷等级
	var HMSObj = $HUI.combobox("#HMService", {
		url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindHMService&ResultSetType=array&LocID=" + LocID,
		valueField: 'id',
		textField: 'desc',
		panelHeight: '105',
	});


	//默认套餐
	var OrdSeObj = $HUI.combogrid("#OrdSetsDesc", {
		panelWidth: 500,
		url: $URL + "?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode: 'remote',
		delay: 200,
		idField: 'OrderSetId',
		textField: 'OrderSetDesc',
		onBeforeLoad: function (param) {
			param.Set = param.q;
			param.Type = "ItemSet";
			param.LocID = session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
			param.UserID = session['LOGON.USERID'];

		},
		columns: [[
			{ field: 'OrderSetId', title: 'ID', width: 80 },
			{ field: 'OrderSetDesc', title: '名称', width: 200 },
			{ field: 'IsBreakable', title: '是否拆分', width: 80 },
			{ field: 'OrderSetPrice', title: '价格', width: 100 },

		]]
	});

	// 总检类型
	$HUI.combobox("#GeneralType", {
		valueField: 'id',
		textField: 'text',
		panelHeight: "auto",
		//editable:false,
		data: [
			{ id: 'JKTJ', text: '健康体检', selected: 'true' },
			{ id: 'RZTJ', text: '入职体检' },
			{ id: 'GWY', text: '公务员' },
			{ id: 'ZYJK', text: '职业健康' },
			{ id: 'JKZ', text: '健康证' },
			{ id: 'OTHER', text: '其他' }
		]
	});

	//是否插队
	$HUI.combobox("#CutInLine", {
		valueField: 'id',
		textField: 'text',
		panelHeight: "auto",
		data: [
			{ id: 'Y', text: '是' },
			{ id: 'N', text: '否' }
		]
	});

}

// 预览系统指引单
function BShowDJDTemplate(id, tempName) {
	var SelRowData = $("#VIPGrid").datagrid("getSelected");
	if (!SelRowData) {
		$.messager.alert("提示", "未获取到VIP等级！", "info");
		return false;
	}
	var VIPDesc = SelRowData.TDesc + "-";

	var lnk = "dhcpe.ct.djdtemplate.csp" + "?ID=" + id + "&TemplateName=" + tempName + "&LocID=" + session['LOGON.CTLOCID'];
	websys_showModal({
		title: VIPDesc + '导检单格式预览',
		url: websys_writeMWToken(lnk),
		width: '1150',
		height: '650',
		iconCls: 'icon-w-paper',
		onClose: function() {
			BLFind_click();
		}
	});
}
