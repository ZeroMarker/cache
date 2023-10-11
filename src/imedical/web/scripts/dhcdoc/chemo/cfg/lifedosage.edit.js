/**
 * lifedosage.edit.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_Arcim: ""
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	InitData()
}

function InitEvent () {
	$("#save").click(Save)
}

function InitCombox() {
	Combox_ItemDesc();
	
	PLObject.m_Dosage = $HUI.combobox("#ItemDoseUOM", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.LifeDose&QueryName=QryUom&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true
	});
	
}



function Combox_ItemDesc(){
	$("#ItemDesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimDR',
        textField:'ArcimDesc',
        columns:[[  
           {field:'ArcimDesc',title:'名称',width:320,sortable:true},
            {field:'ArcimDR',title:'ID',width:70,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:310,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.THPY.COM.Qry',QueryName: 'FindMasterItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{arcimdesc:desc});
	    },onSelect:function(ind,item){
		   PLObject.v_Arcim = item.ArcimDR;
		   //Combox_ItemDoseUOM(item.ArcimDR);
		}
    });
}

function InitData() {
	if (ServerObj.LDID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.LifeDose",
			MethodName:"GetInfo",
			LDID: ServerObj.LDID
		},function(MObj){
			$("#dosage").val(MObj.LDDosage)
			$("#ItemDesc").lookup('setText', MObj.LDArcimDesc);
			PLObject.v_Arcim = MObj.LDArcimDR
			PLObject.m_Dosage.setValue(MObj.LDUomDR);
		});
	}
	
}

function Save () {
	var LDID = ServerObj.LDID;
	var Arcim = PLObject.v_Arcim;
	var LDosage = $.trim($("#dosage").val());
	var Uom = $("#ItemDoseUOM").combobox("getValue")||"";
	var User = session['LOGON.USERID'];
	if (Arcim == "") {
		$.messager.alert("提示", "请填写化疗药品！", "info");
		return false;
	}
	if (dosage == "") {
		$.messager.alert("提示", "请填写终身剂量！", "info");
		return false;
	}
	if (Uom == "") {
		$.messager.alert("提示", "请填写剂量单位！", "info");
		return false;
	}
	$m({
		ClassName:"DHCDoc.Chemo.CFG.LifeDose",
		MethodName:"Save",
		LDID:LDID,
		Arcim:Arcim,
		LDosage:LDosage,
		Uom:Uom
	}, function(result){
		if (result == 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else if (result == "-113") {
			$.messager.alert("提示", "配置已存在！", "info");
			return false;
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
}

//=======================================================================================================

function Combox_ItemDoseUOM(ArcimID,DefaultDosUomDr) {
	ArcimID=ArcimID||"",
	DefaultDosUomDr=DefaultDosUomDr||"";
	
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemDoseUOM", 
		Inpute1:ArcimID,Inpute2:DefaultDosUomDr,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemDoseUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$(this).combobox('select',DefaultDosUomDr);
				}
		 });
	});
}