/**
 * warning.edit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
 
PLObject = {
	v_ItemDr:"",
	m_Item:""
}
 
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	InitData();
	
}

function InitEvent () {
	$("#save").click(saveHandler);
}

function PageHandle() {
	
}

function InitData() {
	if (ServerObj.WID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.Warning",
			MethodName:"GetInfo",
			id: ServerObj.WID
		},function(MObj){
			$("#msg").val(MObj.WMsg)
			$("#note").val(MObj.WNote)
			PLObject.m_Type.select(MObj.WType);
			PLObject.m_Type.disable();
			PLObject.v_ItemDr=MObj.WItemDr
			setTimeout(function () {
				if (PLObject.m_Item!="") {
					PLObject.m_Item.setValue(MObj.WItem)
					PLObject.m_Item.disable();
				} else {
					$("#item").attr("disabled","disabled");
				}
				
			},100)
			
			
		});
	}
}

function InitCombox() {
	PLObject.m_Type = $HUI.combobox("#type", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.Warning&QueryName=QryType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true,
		onSelect: function (r) {
			if (r.id=="A") {
				$("#item").removeAttr("disabled").val("");
				PLObject.m_Item = $HUI.combobox("#item", {
					url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.Warning&QueryName=FindMasterItem&InOrderType=R&ResultSetType=array",
					valueField:'ArcimDR',
					textField:'ArcimDesc',
					blurValidValue:true,
					mode:"remote",
					width:265,
					onBeforeLoad: function(param){
						var desc=param['q'];
						param = $.extend(param,{arcimdesc:desc});
					}
				});
				SetToCombox("#item")
			} else if (r.id=="N") {
				PLObject.m_Item = "";
				SetToInput("#item");
				$("#item").attr("disabled","disabled");
				
			} else if (r.id=="D") {
				$("#item").removeAttr("disabled");
				PLObject.m_Item = $HUI.combobox("#item", {
					url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=GetPhcCat&ResultSetType=array",
					valueField:'phcat',
					textField:'phcatdesc',
					width:265,
					defaultFilter:4
				});
				SetToCombox("#item")
				
			} else if (r.id=="I") {
				PLObject.m_Phcat.enable();
				/*PLObject.m_Item = $HUI.combobox("#item", {
					url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=GetPhcSubCat&ResultSetType=array",
					valueField:'subcat',
					textField:'phcatsubdesc',
					width:265,
					defaultFilter:4
				});
				SetToCombox("#item")*/
			} else {}
		}
	});
	
	PLObject.m_Phcat = $HUI.combobox("#phcat", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=GetPhcCat&ResultSetType=array",
		valueField:'phcat',
		textField:'phcatdesc',
		disabled:true,
		defaultFilter:4,
		blurValidValue:true,
		onSelect: function (r) {
			var url = $URL+"?ClassName=DHCDoc.GCPSW.COM.Qry&QueryName=GetPhcSubCat&phcatdr="+r.phcat+"&ResultSetType=array";
			//PLObject.m_Item.reload(url);	
			
			PLObject.m_Item = $HUI.combobox("#item", {
					url:url,
					valueField:'id',
					textField:'desc',
					width:265,
					defaultFilter:4
				});
			SetToCombox("#item")
				
		}
	})
}

function saveHandler() {
	var id = ServerObj.WID;
	var type = PLObject.m_Type.getValue()||"";
	var item = "";
	//debug(PLObject.m_Item)
	if (id!="") {
		item = PLObject.v_ItemDr||"";
	} else {
		if (PLObject.m_Item == "") {
			item = $.trim($("#item").val());
		} else {
			//alert("h: "+PLObject.m_Item.getValue())
			item = PLObject.m_Item.getValue()||"";
		}
	}
	
	var msg = $.trim($("#msg").val());
	var note = $.trim($("#note").val());
	var user = GetSession("USER");
	
	if (type=="") {
		$.messager.alert("提示","禁用类型不能为空!","warning")
		return false;
	}
	if (type!="N") {
		if (item=="") {
			$.messager.alert("提示","禁用项目不能为空!","warning")
			return false;
		}
	} else {
		if (msg=="") {
			$.messager.alert("提示","预警信息不能为空!","warning")
			return false;
		}
	}
	
	if (msg=="") {
		//$.messager.alert("提示","预警信息不能为空！","warning")
		//return false;
	}
	var mList = id+"^"+type+"^"+item+"^"+msg+"^"+user+"^"+note;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.Warning",
		MethodName:"Save",
		PID:ServerObj.PID,
		mList:mList
	}, function(result){
		if (result >= 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		} else if (result == "-2") {
			$.messager.alert("提示", "配置已存在！", "warning");
			return false;
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
	
	
	
}