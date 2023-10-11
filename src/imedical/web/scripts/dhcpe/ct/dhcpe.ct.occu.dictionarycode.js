// dhcpe/ct/dhcpe.ct.occu.dictionarycode.js
// dhcpe.ct.occu.dictionarycode.csp
// by zhongricheng

var ClickFlag = "";

$(function() {
	InitCBaseCodeDataGrid();
	$("#BAddBase").click(function() {
		BAddBase("Add");
	});
});

// ��ʼ��������
function InitCBaseCodeDataGrid() {
	$HUI.datagrid("#CBCodeList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.Occu.DictionaryCode",
			QueryName:"SearchBaseCode",
			Type:"BASE"
		},
		columns:[[
			{field:"TId", title:"TId", hidden:true},
			{field:"TType", title:"TType", hidden:true},
			{field:"TRelation", title:"TRelation", hidden:true},
			{field:"TRemark", title:"��ע", hidden:true},
			{field:"TExp", title:"��չ��־", hidden:true},
			{field:"TCode", title:"����", formatter: function (value, rowData, rowIndex) {
					if (rowData.TActive != "Y") {
						return "<span style='color:#7a7374'>" + value + "</span>";
					}
					return value;
				}
			},
			{field:"TDesc",title:"����",width:10,formatter:function(value,rowData,rowIndex){
					if (rowData.TActive != "Y") {
						return "<span style='color:#7a7374'>" + value + "</span>";
					}
					return value;
				}
			}
		]],
		collapsible:true, //�����������
		lines:true,
		//striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		showPageList:true,
		beforePageText:"��",
		showRefresh:true,
		afterPageText:"ҳ,��{pages}ҳ",
		displayMsg:"��{total}��",
		pagination:true,
		
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
			
			$("#BUpdList").linkbutton("enable");
			
			if (rowData.TActive != "Y") {
				$.messager.popover({msg: "�û�������δ���", type: "alert"});
				//$.messager.alert("��ʾ", "�û�������δ���", "info");
				ClickFlag = "N";
				//return false;
			} else {
				ClickFlag = "";
			}
			
			$("#BUpdBase").unbind("click");
			$("#BUpdBase").linkbutton("enable");
			$("#BUpdBase").click(function() {
				BClear_click("BASE");
				BAddBase("Upd");
			});
			
			$("#BAddTree").unbind("click");
			$("#BAddTree").linkbutton("disable");
			$("#BUpdTree").unbind("click");
			$("#BUpdTree").linkbutton("disable");
			InitCBaseCodeTree("BASE", rowData.TCode);
		},
		onSelect: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onUnselect: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess: function(data) {
		}
	});
}

/// ��ȡjson������ʾtree
function InitCBaseCodeTree(pType, Type) {
	var formData = new FormData();
    formData.append("action", "getBaseData");
    formData.append("pType",pType);
    formData.append("Type",Type);
    
	$.messager.progress({title: "��ʾ", msg: "���ڻ�ȡ������...", text: "��ȡ������..."});
			
    $.ajax({
	    url:"dhcpe.occu.action.csp",
	    data:formData,
        type: "POST",
        processData: false,
        contentType: false,
        dataType: "json",
	    success: function (data) {
		    $.messager.progress("close");
		    ShowCBaseCodeTree(data);
	    },
	    error: function () {
		    $.messager.progress("close");
		    $.messager.alert("��ʾ", "�Ͽ����ӻ����ݳ���", "info");
	    }
	});
}

/// ��ʾtree
function ShowCBaseCodeTree(data) {
	$("#CBCodeTree").tree({
		data: [data],
		formatter:function(node){
			var s = "" + node.text;
            if (node.children){
                s += "   ---  <span style='color:#40A2DE;'>(" + node.children.length + ")</span>";
            }
            return s;
		},
		onClick: function (node) {
			if (ClickFlag != "N") {
				if (node.attributes.ExFlag == "Y") {
					$("#BAddTree").unbind("click");
					$("#BAddTree").linkbutton("enable");
					$("#BAddTree").click(function() {
						BClear_click("");
						BUpdTree("Add");
					});
				} else {
					$("#BAddTree").linkbutton("disable");
					$("#BAddTree").unbind("click");
				}
				if (node.attributes.Type != "BASE") {
					$("#BUpdTree").unbind("click");
					$("#BUpdTree").linkbutton("enable");
					$("#BUpdTree").click(function() {
						BClear_click("");
						BUpdTree("Upd");
					});
				} else {
					$("#BUpdTree").linkbutton("disable");
					$("#BUpdTree").unbind("click");
				}
			}
		},
		onDblClick: function (node) {  // ˫�����¼�
			$("#CBCodeTree").tree("toggle", node.target); // չ���ر�
		}
	});
}

/// ���»�������
function BAddBase(OptType) {
	var Id = "";
	if (OptType == "Add") {
		BClear_click("BASE");
		$("#BCodeWin").removeAttr("disabled", true);
		$("#BCodeWin").validatebox("validate");
		var title = "������������";
		var icon = "icon-w-add";
	} else {
		$("#BCodeWin").attr("disabled", true);
		
		var SelGridData = $("#CBCodeList").datagrid("getSelected");
		Id = SelGridData.TId;
		if (Id == "") {
			$.messager.alert("��ʾ", "��ѡ�������������޸ġ�", "info");
			return false; 
		}
		var Code = SelGridData.TCode;
		var Desc = SelGridData.TDesc;
		var Type = SelGridData.TType;
		var Code = SelGridData.TCode;
		var Active = SelGridData.TActive;
		var ExFlag = SelGridData.TExFlag;
		var title = "�޸� " + Desc + " ��������";
		var icon = "icon-w-edit";
		
		$("#BCodeWin").val(Code).validatebox("validate");;  // ����
		$("#BDescWin").val(Desc).validatebox("validate");  // ����
		if (Active == "Y") { $("#BActiveWin").checkbox("setValue", true); }
		if (ExFlag == "Y") { $("#BExFlagWin").checkbox("setValue", true); }
	}
	
	$("#BaseCodeWin").show();
	
	var myWin = $HUI.dialog("#BaseCodeWin", {
		iconCls:icon,
		resizable:true,
		title:title,
		modal:true,
		buttonAlign:"center",
		buttons:[{
			text:"����",
			handler:function() {
				UpdBaseCode(OptType, Id);
			}
		},{
			text:"�ر�",
			handler:function(){
				myWin.close();
			}
		}]
	});
}

// ����
function UpdBaseCode(flag, Id) {
	if (flag == "Add") { 
		var Id = "";
	} else {
		if (Id == "") {
			$.messager.alert("��ʾ", "��ѡ����������н����޸ġ�", "info");
			return false; 
		}
	}
	var code = "", desc = "";
	var active = "N", exFlag = "N";
	
	if ($("#BCodeWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { code = $("#BCodeWin").val(); }
	else { $.messager.alert("��ʾ", "���벻��Ϊ�գ�", "info"); return false; }
	
	if ($("#BDescWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { desc = $("#BDescWin").val(); }
	else { $.messager.alert("��ʾ", "��������Ϊ�գ�", "info"); return false; }
	
	var cActive = $("#BActiveWin").checkbox("getValue");
	if (cActive) { active = "Y"; }
	
	var cExFlag = $("#BExFlagWin").checkbox("getValue");
	if (cExFlag) { exFlag = "Y"; }
	
	var Strs = code + "^" + desc + "^" + active + "^" + exFlag;
	
	$cm({
		ClassName:"web.DHCPE.CT.Occu.DictionaryCode",
		MethodName:"UpdBaseCode",
		Id:Id,
		Strs:Strs
	}, function(data){
		if (data.code == "-1") {
			$.messager.alert("��ʾ", data.msg, "info");
			return false;
		}
		$.messager.popover({msg: (flag=="Add"?"����":"�޸�")+"�ɹ�!", type: "success", timeout: 2000, showType: "slide"});
		//$.messager.alert("��ʾ", (flag=="Add"?"����":"�޸�")+"�ɹ�!", "info");
		$("#CBCodeList").datagrid("reload");
		$("#CBCodeTree").tree("loadData",[]);
		$("#BaseCodeWin").window("close");
		BClear_click("Base");
	});
}

/// �����ӽڵ�
function BUpdTree(OptType) {
	var SelTreeData = $("#CBCodeTree").tree("getSelected");
	var Id = "";
	if (OptType == "Add") {
		var pId = SelTreeData.id;
		if (pId == "") {
			$.messager.alert("��ʾ", "�޸��ڵ㣬�޷�" + title + "�ӽڵ㣡", "info");
			return false;
		}
		var pCode = SelTreeData.attributes.Code;
		
		$("#CodeWin").removeAttr("disabled", true);
		$("#CodeWin").validatebox("validate");
		
		$("#ExFlagWin").removeAttr("disabled");
		$("#ExFlagWin").parent().removeClass("disabled");
		
		var title = "����";
		var icon = "icon-w-add";
	} else {
		Id = SelTreeData.id;
		if (Id == "") {
			$.messager.alert("��ʾ", "��ѡ����Ӧ�ڵ������޸ġ�", "info");
			return false; 
		}
		
		var pId = SelTreeData.attributes.LinkDr;
		if (pId == "") {
			$.messager.alert("��ʾ", "�޸��ڵ㣬�޷��޸Ĵ˽ڵ㣡", "info");
			return false; 
		}
		var pCode = SelTreeData.attributes.Type;
		
		$("#CodeWin").val(SelTreeData.attributes.Code).validatebox("validate");  // ����
		$("#DescWin").val(SelTreeData.attributes.Desc).validatebox("validate");  // ����
		if (SelTreeData.attributes.Active == "Y") { $("#ActiveWin").checkbox("setValue", true); }
		if (SelTreeData.attributes.ExFlag == "Y") { $("#ExFlagWin").checkbox("setValue", true); }
		$("#PlatformCodeWin").val(SelTreeData.attributes.PlCode);
		$("#CustomData1Win").val(SelTreeData.attributes.Custom1);
		$("#CustomData2Win").val(SelTreeData.attributes.Custom2);
		$("#CustomData3Win").val(SelTreeData.attributes.Custom3);
		$("#ExpandCodeWin").val(SelTreeData.attributes.ExCode);
		$("#RemarkWin").val(SelTreeData.attributes.Remark);

		
		var title = "�޸�";
		var icon = "icon-w-edit";
	}
	
	var tDesc = SelTreeData.attributes.Desc + " " + (OptType=="Add"?"��":"") + "�ڵ�";
	
	$("#DetailCodeWin").show();
	var myWin = $HUI.dialog("#DetailCodeWin", {
		iconCls:icon,
		resizable:true,
		title:title + " " + tDesc,
		modal:true,
		buttonAlign:"center",
		buttons:[{
			text:"����",
			handler:function() {
				UpdDetailCode(OptType, pId, Id, pCode);
			}
		},{
			text:"�ر�",
			handler:function(){
				myWin.close();
			}
		}]
	});
}

// ����
function UpdDetailCode(flag, pId, Id, PCode) {
	if (flag == "Add") {
		var Id = ""; 
	} else {
		if (Id == "") {
			$.messager.alert("��ʾ", "��ѡ���н����޸ġ�", "info");
			return false; 
		}
	}
	if (PCode == "") {
		$.messager.alert("��ʾ", "δ��ȡ����Ӧ���͡�", "info");
		return false; 
	}
	
	var code = "", desc = "", expandCode = "", remark = "", platformcode = "";
	var customData1 = "", customData2 = "", customData3 = "";
	var active = "N", exFlag = "N";
	
	if ($("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { code = $("#CodeWin").val(); }
	else { $.messager.alert("��ʾ", "���벻��Ϊ�գ�", "info"); return false; }
	
	if ($("#DescWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { desc = $("#DescWin").val(); }
	else { $.messager.alert("��ʾ", "��������Ϊ�գ�", "info"); return false; }
	
	var cActive = $("#ActiveWin").checkbox("getValue");
	if (cActive) { active = "Y"; }
	
	var cExFlag = $("#ExFlagWin").checkbox("getValue");
	if (cExFlag) { exFlag = "Y"; }
	
	expandCode = $("#ExpandCodeWin").val();
	remark = $("#RemarkWin").val();
	
	platformcode = $("#PlatformCodeWin").val();
	customData1 = $("#CustomData1Win").val();
	customData2 = $("#CustomData2Win").val();
	customData3 = $("#CustomData3Win").val();
	
	var InString = code + "^" + desc + "^" + PCode + "^" + active + "^" + exFlag
				 + "^" + expandCode + "^" + remark + "^" + platformcode + "^" + customData1 + "^" + customData2
				 + "^" + customData3
				 ;
	
	$cm({
		ClassName:"web.DHCPE.CT.Occu.DictionaryCode",
		MethodName:"UpdBaseDetileCode",
		Id:Id,
		pId:pId,
		Strs:InString
	}, function(data){
		if (data.code == "-1") {
			$.messager.alert("��ʾ", data.msg, "info");
			return false;
		}
		if ( flag == "Add" ) {
			$.messager.popover({msg: "����ɹ�!", type: "success", timeout: 2000, showType: "slide"});
			//$.messager.alert("��ʾ","����ɹ�!", "info");
			
			var node = $("#CBCodeTree").tree("getSelected");
			if (node) {
				$("#CBCodeTree").tree("append", {
					parent: node.target,
					data: [{
						id: data.msg,
						text: desc + " [" + code + "]",
						state: "open",
						attributes: {"Code":code, "Desc":desc, "Type":PCode,
									 "LinkDr":pId, "Active":active, "ExFlag":exFlag,
									 "ExCode":expandCode, "Remark":remark, "PlCode":platformcode,
						 			 "Custom1":customData1, "Custom2":customData2, "Custom3":customData3
									}
					}]
				});
			}
		} else {
			$.messager.popover({msg: "�޸ĳɹ�!", type: "success", timeout: 2000, showType: "slide"});
			//$.messager.alert("��ʾ","�޸ĳɹ�!", "info");
			
			var pNode = null;
			var node = $("#CBCodeTree").tree("getSelected");
			if (node) {
				$("#CBCodeTree").tree("update", {
					target: node.target,
					text: desc + " [" + code + "]",
					state: "open",
					attributes: {"Code":code, "Desc":desc, "Type":PCode,
								 "LinkDr":pId, "Active":active, "ExFlag":exFlag,
								 "ExCode":expandCode, "Remark":remark, "PlCode":platformcode,
						 		 "Custom1":customData1, "Custom2":customData2, "Custom3":customData3
								}
				});
			}
			
			var pNode = $("#CBCodeTree").tree("getParent", node.target);
		}
		$("#DetailCodeWin").window("close");
		BClear_click("");
	});
}

function BClear_click(Type) {
	if (Type == "BASE") {
		$("#BCodeWin").val("").validatebox("validate");
		$("#BDescWin").val("").validatebox("validate");
		$("#BActiveWin").checkbox("setValue", false);
		$("#BExFlagWin").checkbox("setValue", false);
	} else {
		$("#CodeWin").val("").validatebox("validate");
		$("#DescWin").val("").validatebox("validate");
		$("#ActiveWin").checkbox("setValue", false);
		$("#ExFlagWin").checkbox("setValue", false);
		$("#PlatformCodeWin").val("");
		$("#CustomData1Win").val("");
		$("#CustomData2Win").val("");
		$("#CustomData3Win").val("");
		$("#ExpandCodeWin").val("");
		$("#RemarkWin").val("");
	}
}
