/**
 * FileName: dhcinsu.contrastconfig.main.js
 * Anchor: tangzf
 * Date: 2020-03-09
 * Description: 医保对照维护
 */
var GV = {};

$(function() {
	$("#page-search").searchbox({
		searcher: function(value) {
			GV.PageList.load({
				ClassName : "web.INSUDicDataCom",
				QueryName : "QueryDicAllInfo",
				CodeAndDesc : value,
				queryFlag : 'Con'
			});
		}
	});
	$HUI.linkbutton("#btn-update", {
		onClick: function () {
			updateClick();
		}
	});
	
	GV.PageList = $HUI.datagrid("#pageList",{
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		pageSize: 30,
		displayMsg: '',
		toolbar: '#pl-tb',
		// INDIDDicCode,INDIDDicDesc,INDIDDicDemo
		columns: [[
				   {title: '代码', field: 'INDIDDicCode'},
				   {title: '描述', field: 'INDIDDicDesc'},
				   {field: 'INDIDDicBill3',hidden:true},
		]],
		url: $URL,
		queryParams: {
			ClassName : "web.INSUDicDataCom",
			QueryName : "QueryDicAllInfo",
			queryFlag : "Con",
			CodeAndDesc : ''
		},
		onLoadSuccess: function(data) {
		/*	GV.PageList.unselectAll();
			GV.PageList.getPanel().find(".l-btn:not('#btn-add')").linkbutton("disable");
			$(".layout:first").layout("panel", "center").panel("setTitle", "页面配置");
			$("iframe").attr("src", "dhcbill.nodata.warning.csp");*/
		},
		onSelect: function(index, row) {
			/*GV.PageList.getPanel().find(".l-btn:not('#btn-add')").linkbutton("enable");
			$(".layout:first").layout("panel", "center").panel("setTitle", row.pageName + "页面配置");*/
			loadConfPage(index, row);
		}
	});
});
function loadConfPage(index, row) {
	var src = 'dhcinsu.contrastconfig.show.csp?&ParamDicType=' + row.INDIDDicCode + '&INDIDDicBill3=' + row.INDIDDicBill3;

	if (!row.INDIDDicBill3){
		$.messager.alert('提示','请先进行方法维护','info');
		src = 'dhcbill.nodata.warning.csp';
	}
	if ($("iframe").attr("src") != src) {
		$("iframe").attr("src", src);
	}
}


function updateClick() {
	var row = GV.PageList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要修改的行", type: "info"});
		return;
	}
	save(row);
}

function save(row) {
	$("#edit-Dlg").show();
	var id = "";
	var clsName = "web.INSUDictionaryContrast";
	var pageName = "";
	var confURL = "";
	var dlgIconCls = "icon-w-add";
	var dlgTitle = "新增";
	if (row) {
		if(row.INDIDDicBill3.split('|').length > 2){
			clsName = row.INDIDDicBill3.split('|')[0];
			pageName = row.INDIDDicBill3.split('|')[1];
			confURL = row.INDIDDicBill3.split('|')[2];
		}
		dlgIconCls = "icon-w-edit";
		dlgTitle = "方法维护";
	}
	setValueById("edit-cspName", clsName);
	setValueById("edit-pageName", pageName);
	setValueById("edit-confURL", confURL);
	$(".validatebox-text").validatebox("validate");
	
	var editDlgObj = $HUI.dialog("#edit-Dlg", {
		iconCls: dlgIconCls,
		title: dlgTitle,
		draggable: false,
		modal: true,
		buttons: [{
				text: "保存",
				handler: function () {
					var bool = true;
					$(".validatebox-text").each(function(index, item) {
						if (!$(this).validatebox("isValid")) {
							$.messager.popover({msg: "请输入<font color=red>" + $(this).parent().prev().text() + "</font>", type: "info"});
							bool = false;
							return false;
						}
					});
					if (!bool) {
						return;
					}
					
					var pageInfo = getValueById("edit-cspName") + "|" + getValueById("edit-pageName") + "|" + getValueById("edit-confURL");
					var jsonObj = {
							INDIDDicBill3 : pageInfo,
					}
					var Code = row.INDIDDicCode
					var jsonStr = JSON.stringify(jsonObj);
					$.messager.confirm("确认", "确认保存？", function(r) {
						if (r) {
							$.m({
								ClassName: "web.INSUDicDataCom",
								MethodName: "UpdaDicInfoByJson",
								JsonStr: jsonStr,
								Code: Code
							}, function (rtn) {
								var myAry = rtn.split("^");
								if (myAry[0] == "0") {
									$.messager.popover({msg: "保存成功", type: "success"});
									editDlgObj.close();
									GV.PageList.reload();
								} else {
									$.messager.popover({msg: "保存失败：" + myAry[0], type: "error"});
								}
							});
						}
					});
				}
			}, {
				text: '关闭',
				handler: function () {
					editDlgObj.close();
				}
			}
		]
	});
}

function selectHospCombHandle(){
	$('#pageList').datagrid('reload');	
}