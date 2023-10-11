/**
 * lifedosage.edit.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
var PLObject = {
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
	Combox_ItemDescNew();
	
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
           {field:'ArcimDesc',title:'����',width:320,sortable:true},
            {field:'ArcimDR',title:'ID',width:70,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:450,
        panelHeight:380,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.CFG.DrugDic',QueryName: 'FindMasterItem',InType:"R",InOrderCate:"��ҩ",HospId: ServerObj.InHosp},
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

function Combox_ItemDescNew() {
	
	var Form = ""+String.fromCharCode(3)+ServerObj.InHosp
	$("#ItemDesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'����',width:430}
           ,{field:'HIDDEN',title:'ҽ����ID',width:120,sortable:true}
        ]],
        pagination:true,
        panelWidth:550,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem',Form:Form},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{Item:desc,TYPE:"R"});	//TYPE:"L^SERVICE"
	    },onSelect:function(ind,item){
		    PLObject.v_Arcim=item['HIDDEN'];
		}
    });
    
}

function InitData() {
	if (ServerObj.DID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.DrugDic",
			MethodName:"GetInfo",
			ID: ServerObj.DID
		},function(MObj){
			//$("#Name").numberbox("setValue",MObj.DName)
			$("#Name").val(MObj.DName)
			$("#ItemDesc").lookup('setText', MObj.DArcimDesc);
			PLObject.v_Arcim = MObj.DArcimDR
			if (MObj.DActive==1) {
				$("#active").checkbox("check");
			} else {
				$("#active").checkbox("uncheck");
			}
		});
	}
}

function Save () {
	var DID = ServerObj.DID;
	var Arcim = PLObject.v_Arcim;
	var DName = $.trim($("#Name").val());
	var Active = $("#active").checkbox("getValue")?1:0;
	//var User = session['LOGON.USERID'];
	if (Arcim == "") {
		$.messager.alert("��ʾ", "����д����ҩƷ��", "info");
		return false;
	}
	if (DName == "") {
		$.messager.alert("��ʾ", "����д��д���ƣ�", "info");
		return false;
	}
	var mList = Arcim + "^" + Active + "^" + DName +"^"+ ServerObj.InHosp
	
	$m({
		ClassName:"DHCDoc.Chemo.CFG.DrugDic",
		MethodName:"Save",
		DID:DID,
		mList:mList
	}, function(result){
		if (result == 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info",function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");		
			});
		} else if (result == "-2") {
			$.messager.alert("��ʾ", "�����Ѵ��ڣ�", "info");
			return false;
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
			return false;
		}
	});
}
