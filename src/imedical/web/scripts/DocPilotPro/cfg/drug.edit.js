/**
 * stage.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PageLogicObj = {
	v_Arcim:""	
}
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	InitData()
	
}

function InitEvent () {
	$("#Save").click(function () {
		SaveHandler("ARC")	
	});
	$("#SaveTYM").click(function () {
		SaveHandler("TYM")	
	});
}

function PageHandle() {
	
}

function InitCombox() {
	
	var Form = ""+String.fromCharCode(3)+ServerObj.InHosp
	$("#DArcim").lookup({
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
		    PageLogicObj.v_Arcim=item['HIDDEN'];
		}
    });
    
}


function InitData() {
	$cm({
		ClassName:"web.PilotProject.Model.Stage",
		MethodName:"GetInfo",
		id: ServerObj.ID
	},function(MObj){
		//debug(MObj,"MObj")
		if (ServerObj.ID!="") {
			$("#code").val(MObj.STCode);
			$("#name").val(MObj.STName);
			//$("#days").numberbox("setValue",MObj.STDays);
			if (MObj.STActive==1) {
				$("#active").checkbox("check")
			} else {
				$("#active").checkbox("uncheck")
			}
			if (MObj.STProject) {
				PageLogicObj.m_Project.setValue(MObj.STProject)
			}
		}
		//$("#seqno").numberbox("setValue", MObj.STSeqno);

	});
	
}

function SaveHandler(InType) {
	if (PageLogicObj.v_Arcim=="") {
		$.messager.alert("��ʾ","ҩƷ���Ʋ���Ϊ�գ�","warning")
		return false;
	}
	var BaseParamObj = {
		ID:"",
		DProjectID:ServerObj.PPRowId,
		DArcimDR:PageLogicObj.v_Arcim,
		DAddUser:session['LOGON.USERID'],
		InType:InType
	}
	
	var BaseParamJson=JSON.stringify(BaseParamObj);
	var msg = "ȷ�ϰ���ҽ�������ô��";
	if (InType == "TYM") {
		msg = "ȷ�ϰ���ͨ�������ô��"
	} 
	$.messager.confirm("��ʾ", msg,function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCP.CFG.Drug",
				MethodName:"Save",
				BaseParamJson:BaseParamJson
			}, function(result){
				result = result.split("^")
				if (result[0]> 0) {
					$.messager.alert("��ʾ", "����ɹ���", "info", function () {
						websys_showModal("hide");
						websys_showModal('options').CallBackFunc();
						websys_showModal("close");
					});
				} else {
					$.messager.alert("��ʾ", result , "warning");
					return false;
				}
			});
			
			
		}
	});	
	
		
	
	
	
	
	
}