/**
 * nmain.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PageLogicObj = {
	v_DefaultDate:"",
	v_DefaultYear:"",
	v_DefaultMonth:"",
	v_DefaultDay:"",
	v_DefaultDateArr:[],
	v_DeafultBCode:"",
	v_SelectBCCode:"",
	v_SelectType:"",
	m_ItemCountGrid:""
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})


function Init(){
	InitHISUI();
	GetDefaultDate();
	//GetDefaultBCode();
	InitDate();
	InitButton();
	LoadTabItem();
}

function InitEvent () {
	$("#Save").click(SaveHandler);
	$("#Sync").click(SyncHandler);
	$("#Submit").click(SubmitHandler)
	$("#Print").click(PrintHandler)
	$("#FixBC").click(FixBCHandler)
	$("#ReSubmit").click(ReSubmitHandler)
}

function SubmitHandler () {
	var selected = PageLogicObj.m_ItemCountGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择班次！", "info");
		return false;
	}
	var BCDate= $("#BCDate").datebox("getValue")||"";
	if (BCDate == "") {
		$.messager.alert("提示", "请选择日期！", "info");
		return false;
	}
	
	if (selected.NID=="") {
		$.messager.alert("提示", "请先进行保存在进行交班！", "info");
		return false;
	}
	var URL = "dhcdoc.passwork.nmain.submit.csp?NID="+selected.NID
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'交班',
		width:350,height:300,
		CallBackFunc: function () {
			InitData(selected.NID);	
		}
	})
}

function ReSubmitHandler () {
	var URL = "dhcdoc.passwork.nmain.resubmit.csp?NID="+""
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'补交',
		width:350,height:350,
		CallBackFunc: function () {
			GetDefaultBCode();
			FindItemCount();
		}
	})
}

function InitButton(){
	var FixBCBtn = tkMakeServerCall("DHCDoc.PW.CFG.BCRule", "GetRuleValue",session['LOGON.CTLOCID'],"FixBCBtn");
	if (FixBCBtn == 1) {
		$("#FixBC").removeClass("c-hidden");
	}
}

function FixBCHandler () {
	var selected = PageLogicObj.m_ItemCountGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择班次！", "info");
		return false;
	}
	var BCDate= $("#BCDate").datebox("getValue")||"";
	if (BCDate == "") {
		$.messager.alert("提示", "请选择日期！", "info");
		return false;
	}
	
	if (selected.NID=="") {
		$.messager.alert("提示", "请先进行保存在进行交班！", "info");
		return false;
	}
	var URL = "dhcdoc.passwork.nmain.fixbctime.csp?NID="+selected.NID
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'调整班次时间',
		width:350,height:300,
		CallBackFunc: function () {
			GetDefaultBCode();
			FindItemCount();
		}
	})
}
function PrintHandler () {
	var selected = PageLogicObj.m_ItemCountGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择班次！", "info");
		return false;
	}
	var BCDate= $("#BCDate").datebox("getValue")||"";
	if (BCDate == "") {
		$.messager.alert("提示", "请选择日期！", "info");
		return false;
	}
	
	if (selected.NID=="") {
		$.messager.alert("提示", "请先进行保存在进行打印！", "info");
		return false;
	}
	var rpxName = $cm({
		ClassName:"DHCDoc.PW.RPX.NMain",
		MethodName:"GetRpxName",
		LocID:session['LOGON.CTLOCID'],
		PType:PageLogicObj.v_SelectType,
		dataType:"text"
	},false);
	
	var InPType = PageLogicObj.v_SelectType,InPatNo="";
	var param = "NID="+selected.NID+"&LocId="+session['LOGON.CTLOCID']+"&BCDate="+BCDate+"&UserId="+session['LOGON.USERID'];
	param = param +"&InBCCode="+selected.BCCode+"&InPType="+InPType+"&InPatNo="+InPatNo;
	var URL = "dhccpmrunqianreport.csp?reportName="+rpxName+"&"+param;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-print',
		title:'打印/导出',
		width:1000,height:600
	})
}

function SyncHandler () {
	var selected = PageLogicObj.m_ItemCountGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择班次！", "info");
		return false;
	}
	var BCDate= $("#BCDate").datebox("getValue")||"";
	if (BCDate == "") {
		$.messager.alert("提示", "请选择日期！", "info");
		return false;
	}
	if (selected.NID=="") {
		$.messager.alert("提示", "请先保存班次！", "info");
		return false;
	}
	var SubmitNote = $.trim($("#SubmitNote").val()),
		AccpetNote = $.trim($("#AccpetNote").val());
	var C1 = String.fromCharCode(1);
	var InAdd = InEdit = "";
	if (selected.NID == "") {
		InAdd = session['LOGON.CTLOCID']+C1+BCDate+C1+selected.BCCode+C1+session['LOGON.USERID']+C1+session['LOGON.HOSPID']+C1+SubmitNote+C1+AccpetNote
	} else {
		InEdit = session['LOGON.USERID']+C1+SubmitNote+C1+AccpetNote
	}

	$.messager.confirm("提示", "同步会重新生成数据，确定继续么?", function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.PW.BS.NMain",
				MethodName:"SavePW",
				ID:selected.NID,
				InAdd:InAdd,
				InEdit:InEdit,
				IsSync:1
			}, function(result){
				var result = result.split("^");
				if (result[0] > 0) {
					$.messager.alert("提示", "同步成功！", "info");
					FindItemCount();
					return true;
				} else {
					$.messager.alert("提示", "同步失败：" +result[1] , "info");
					return false;
				}
			});
		} else {
			
		}
	});
		
	
	
}

function SaveHandler () {
	var selected = PageLogicObj.m_ItemCountGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择班次！", "info");
		return false;
	}
	var BCDate= $("#BCDate").datebox("getValue")||"";
	if (BCDate == "") {
		$.messager.alert("提示", "请选择日期！", "info");
		return false;
	}
	var SubmitNote = $.trim($("#SubmitNote").val()),
		AccpetNote = $.trim($("#AccpetNote").val());
	var C1 = String.fromCharCode(1);
	var InAdd = InEdit = "";
	if (selected.NID == "") {
		InAdd = session['LOGON.CTLOCID']+C1+BCDate+C1+selected.BCCode+C1+session['LOGON.USERID']+C1+session['LOGON.HOSPID']+C1+SubmitNote+C1+AccpetNote
	} else {
		InEdit = session['LOGON.USERID']+C1+SubmitNote+C1+AccpetNote
	}
	
	$m({
		ClassName:"DHCDoc.PW.BS.NMain",
		MethodName:"SavePW",
		ID:selected.NID,
		InAdd:InAdd,
		InEdit:InEdit
	}, function(result){
		var result = result.split("^");
		if (result[0] > 0) {
			$.messager.alert("提示", "保存成功！", "info");
			FindItemCount();
			return true;
		} else {
			$.messager.alert("提示", "保存失败：" +result[1] , "info");
			return false;
		}
	});
			
	
}

function InitData(NID) {
	var NID = NID || "";
	if (NID !="") {
		$cm({
			ClassName:"DHCDoc.PW.Model.NMainInfo",
			MethodName:"GetInfo",
			id: NID
		},function(MObj){
			$("#SubmitNote").val(MObj.SubmitNote)
			$("#AccpetNote").val(MObj.AcceptNote)
			if (MObj.SubmitUser) {
				$("#SubmitUser").html(MObj.SubmitUser)
			} else {
				$("#SubmitUser").html("")
			}
			if (MObj.AcceptUser) {
				$("#AcceptUser").html(MObj.AcceptUser)
			} else {
				$("#AcceptUser").html("")
			}
			if (MObj.AddUser) {
				$("#AddUser").html(MObj.AddUser)
			} else {
				$("#AddUser").html("")
			}
		});
	} else {
		ClearData();
	}
}

function ClearData() {
	$("#SubmitNote").val("")
	$("#AccpetNote").val("")
	$("#SubmitUser").html("")
	$("#AcceptUser").html("")
	$("#AddUser").html("")
}

function SetItemCountPanel() {
	var IHeightStr = tkMakeServerCall("DHCDoc.PW.BS.NMain", "SetItemCountPanel",session['LOGON.CTLOCID'],PageLogicObj.v_DefaultDate);
	IHeightStr = IHeightStr.split("^")
	if (IHeightStr[0]!=1) {
		$.messager.alert("错误", IHeightStr[1] , "error");
			return false;
	}
	var options = $("#ItemCountPanel").panel("options") 
	$("#ItemCountPanel").panel('resize',{
		width:options.width,
		height: IHeightStr[1]
	});
	$("#layout2").layout({});
	InitItemCountGrid("ItemCount");	

}

function InitDate() {
	$("#BCDate").datebox({
		//required:true,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			ClearData();
			PageLogicObj.m_ItemCountGrid.clearSelections()
			GetDefaultBCode();
			ClearTPL();
			FindItemCount();
			
		}
	})	
	
}

function PageHandle() {
	$('#BCDate').datebox('calendar').calendar({
        validator: function (date) {
            //var curr_time = new Date()
            //var d1 = new Date(curr_time.getFullYear(), curr_time.getMonth(), curr_time.getDate());
            var d1 = new Date(PageLogicObj.v_DefaultYear, PageLogicObj.v_DefaultMonth, PageLogicObj.v_DefaultDay);
            return d1 >= date;
        }
    });
	$("#BCDate").datebox("setValue", PageLogicObj.v_DefaultDate);
	GetDefaultBCode();
	SetItemCountPanel();
}

function GetDefaultBCode() {
	var BCDate= $("#BCDate").datebox("getValue")||"";
	//var ret = tkMakeServerCall("DHCDoc.PW.COM.Method", "GetCurrentBCCode",session['LOGON.CTLOCID']);
	var ret = tkMakeServerCall("DHCDoc.PW.COM.Method", "GetDefaultBCode",session['LOGON.CTLOCID'],BCDate);
	PageLogicObj.v_SelectBCCode = ret
	PageLogicObj.v_DeafultBCode = ret
	return ret;
}

function GetDefaultDate () {
	var ret = tkMakeServerCall("DHCDoc.PW.COM.Method", "GetDefaultDate",session['LOGON.CTLOCID']);
	var TArr = ret.split("^");
	PageLogicObj.v_DefaultDateArr = TArr;
	PageLogicObj.v_DefaultDate = TArr[0]
	PageLogicObj.v_DefaultYear = parseInt(TArr[1])
	PageLogicObj.v_DefaultMonth = parseInt(TArr[2])
	PageLogicObj.v_DefaultDay = parseInt(TArr[3])
	return ret;
}

function LoadTabItem (LocId) {
	var ret = tkMakeServerCall("DHCDoc.PW.BS.NMain", "GetTabList","",session['LOGON.CTLOCID']);
	if (ret!="") {
		var json = JSON.parse(ret);
		var result = "" //"<div id='item0' class='tab selectedItem' onclick='ItemClick(this"+',"",""'+")'>全部</div>"
		for (var i=0;i<json.length;i++) {
			var record = json[i];
			var code = record["code"];
			var html = "<div title='"+record["name"]+"' class='"+record["ClassName"]+"' onclick='ItemClick(this,"+'"'+record["url"]+'","'+record["code"]+'"'+")'>"+record["name"]+"</div>"
			result = result + html;
		}
		
		_$dom = $(result);
		$("#i-tab").empty();
		$("#i-tab").append(_$dom);
	}
}

function ItemClick (elem,url,type) {
	PageLogicObj.v_SelectType = type;
	var selected = PageLogicObj.m_ItemCountGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择班次！", "info");
		return false;
	}
	var NID = selected.NID;
	var BCCode = selected.BCCode;
	var BCDate = $('#BCDate').datebox("getValue")||"";
	SwitchItem(elem)
	var url = url||"";
	if (url=="") {
		url = "dhcdoc.passwork.nmain.comtpl.csp";
	}
	url = url+"?PType="+type+"&BCCode="+BCCode+"&NID="+NID+"&BCDate="+BCDate;
    url=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(url):url;
	$("#ItemFrame").attr("src",url)
}

function SwitchItem(elem){
	$(elem).addClass("selectedItem").siblings().removeClass("selectedItem");
}

function ClearTPL(url) {
	var url = url||"";
	if (url=="") {
		url = "dhcdoc.passwork.nmain.comtpl.csp";
	}
    url=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(url):url;
	$("#ItemFrame").attr("src",url)
}

function InitBTypeGrid2 (id) {
	var columns = [[
		{field:'code',title:'代码',width:50},
		{field:'desc',title:'描述',width:100},
		{field:'value',title:'数值',width:200},
        {field:'rowid',title:'ID',width:60,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#"+id, {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : false,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.CFG.BCRule",
			QueryName : "QryBCRule",
			InMID:1
		},
		onUnselect:function(){
		},
		toolbar:[{
				text:'新增',
				id:'BTAdd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'BTEdit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'病人类型',
				id:'BPatType',
				iconCls: 'icon-paper-cfg'
			},{
				text:'规则配置',
				id:'BRule',
				iconCls: 'icon-paper-cfg'
			},{
				text:'关联科室',
				id:'BLinkLoc',
				iconCls: 'icon-paper-cfg'
			}
		],
		columns :columns,
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_BTypeGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_BTypeGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_BTypeGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			$("#dg-rule-code").val("").removeAttr("disabled");
			$("#dg-rule-desc").val("");
			$("#dg-rule-value").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-rule-code").val(rowData.code)	//.attr("disabled","disabled");
			$("#dg-rule-desc").val(rowData.desc);
			$("#dg-rule-value").val(rowData.value);
		}
	});
	
	PageLogicObj.m_BTypeGrid =  DurDataGrid;
	return false;
}

function InitItemCountGrid (id) {
	var columns = tkMakeServerCall("DHCDoc.PW.BS.NMain","GetColumns",session['LOGON.CTLOCID']);
	var columnsArr = columns.split(String.fromCharCode(1));
	for (var i=0; i<columnsArr.length; i++) {
		var json = JSON.parse(columnsArr[i]);
		columnsArr[i] = json;
	}
	var columnsNew = [];
	columnsNew.push(columnsArr);
	var DurDataGrid = $HUI.datagrid("#"+id, {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : false,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		idField:"BCCode",
		queryParams:{
			ClassName : "DHCDoc.PW.BS.NMain",
			QueryName : "ItemCountQry",
			LocId:session['LOGON.CTLOCID'],
			UserId:session['LOGON.USERID'],
			BCDate:PageLogicObj.v_DefaultDate,
			InBCCode:"TEST"
		},
		/*toolbar:[{
				text:'新增',
				id:'BTAdd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'BTEdit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'病人类型',
				id:'BPatType',
				iconCls: 'icon-paper-cfg'
			},{
				text:'规则配置',
				id:'BRule',
				iconCls: 'icon-paper-cfg'
			},{
				text:'关联科室',
				id:'BLinkLoc',
				iconCls: 'icon-paper-cfg'
			}
		],*/
		columns :columnsNew,
		onLoadSuccess:function (data) {
			$(this).datagrid("selectRecord",PageLogicObj.v_DeafultBCode)
		},
		onSelect: function (rowIndex, rowData) {
			PageLogicObj.v_SelectBCCode = rowData.BCCode;
			SetButton(rowData)
			$("#i-tab .selectedItem").trigger("click")
			InitData(rowData.NID)
			//$("#item0").trigger("click")
		}
	});
	
	PageLogicObj.m_ItemCountGrid =  DurDataGrid;
	return false;
	
	
}

function InitHISUI () {
	$.extend($.fn.datebox.defaults, {
		currentText: ""
	});
}
function SetButton(rowData) {
	if (rowData.NID == "") {
		$("#Submit").linkbutton('disable');
		$("#Print").linkbutton('disable');	
		$("#FixBC").linkbutton('disable');	
		$("#Sync").linkbutton('disable');	
	} else {
		$("#Submit").linkbutton('enable');
		$("#Print").linkbutton('enable');
		$("#FixBC").linkbutton('enable');
		$("#Sync").linkbutton('enable');
	}
	if (rowData.BCCode == "") {
		$("#Save").linkbutton('disable');
	} else {
		$("#Save").linkbutton('enable');
	}
}

function FindItemCount() {
	PageLogicObj.m_ItemCountGrid.reload({
		ClassName : "DHCDoc.PW.BS.NMain",
		QueryName : "ItemCountQry",
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		BCDate:$("#BCDate").datebox("getValue")||"",
		InBCCode:"TEST"
	})	
}
