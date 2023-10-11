/// author:    qqa
/// date:      2019-11-22
/// descript:  ���ﻤʿִ������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var editRow = ""; editDRow = ""; editPRow = "",editCRow="",editURow="";
var editARow="";
/// ҳ���ʼ������
function initPageDefault(){
	
	///��Ժ������
	MoreHospSetting("DHC_EmExecFormSet");
	
	///��̬���õ�DomԪ��
	InitPageDom();
	
	///��ʼ������Panel
	InitPanel();
	
	///��ʼ��Combbox
	InitCombobox();
	
	///��ʼ���󶨵ķ���
	InitMethod();
	
	//��ʼ��ִ�е��б�
	InitMainList();
}

///��Ժ������
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTableAndCombo;
}

function InitPageDom(){
	var pageWidth = $("#execFormAreaAll").parent().width();
	var pageHeight = $("#execFormAreaAll").parent().height();
	
	var needPadTop = (parseInt(pageHeight)/2-90)+"px";
	var needPadTop2 = (parseInt(pageHeight)/2-150)+"px";
	
	var execFormPanH = parseInt(pageHeight)+"px";
	var execFormPanW = parseInt((pageWidth-250)/2);  ///��̬������panel���
	execColPanLiW = execFormPanW-40;				   ///��̬������panel��Itm���
	
	$("#formSaveBtn").css("margin-top",needPadTop);
	$("#formMoveUpBtn").css("margin-top",needPadTop2);
	$("#execFormAreaAll").css({width:execFormPanW+"px","height":execFormPanH});
	$("#execFormAreaCheck").css({width:execFormPanW+"px","height":execFormPanH});
	$("#formSaveAreaAll").css({width:"110px","height":execFormPanH});
	$("#formSaveAreaCheck").css({width:"110px","height":execFormPanH});
	return;
}

function InitPanel(){
	$HUI.panel("#formPanelAll",{
		fit:true,
		title:"ִ�е�",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#formPanelCheck",{
		fit:true,
		title:"����Ȩ",
		headerCls:'panel-header-card'
	})
}

function LoadColumnsList(){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		return;	
	}

	$cm({
		ClassName:"web.DHCEMNurExecFormSet",
		MethodName:"JsonListColumns",
		ExecFormID:rowsData.ID
	},function(jsonData){
		
		var noCheckData = jsonData.NoCheckDate;
		var checkData = jsonData.CheckDate
		if($(".listLiItm").length){
			$(".listLiItm").remove();
		}
		
		if(noCheckData.lenght!=0){
			var itmData="",itmHtml="";
			for (i in noCheckData){
				itmData = noCheckData[i];
				itmHtml = '<li class="listLiItm" style="width:'+execColPanLiW+'px" data-id="'+itmData.value+'">'+itmData.text+'</li>';
				$("#columnsPanel1").append(itmHtml);
			}
		}
		
		if(checkData.lenght!=0){
			var itmData="",itmHtml="";
			for (i in checkData){
				itmData = checkData[i];
				itmHtml = '<li class="listLiItm" style="width:'+execColPanLiW+'px" data-id="'+itmData.value+'">'+itmData.text+'</li>';
				$("#columnsPanel2").append(itmHtml);
			}
		}
		
	});	
	return;
}


function InitCombobox(){
	var HospID = $HUI.combogrid("#_HospList").getValue();
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();
	$HUI.combobox("#autGroup",{
		url:$URL+"?ClassName=web.DHCEMNurExecFormSetAut&MethodName=GetGroupJsonListCombo&Type="+thisType+"&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
}

function InitMethod(){
	
	$("#queryBTN").on('click',ReloadMainTable);
	
	
	$("#formPanelAll,#formPanelCheck").on("click",".listLiItmTwo",function(){
		var isCtrlKey = window.event.ctrlKey;
		if(!isCtrlKey){
			$(this).parent().find(".listLiItmTwo").not($(this)).removeClass("checkTwo");
			$(this).toggleClass("checkTwo");
		}else{
			if(!$(this).parent().find(".checkTwo").length){
				$(this).parent().find(".checkTwo").removeClass("checkTwo");			
			}
			$(this).toggleClass("checkTwo");
		}
	})
	
	$('#autGroupInp').on('keypress', function(e){   
		if((e||event).keyCode=="13"){
			$("#queryBTN").click();
		}
	});
	
}


///��ʼ���ֵ������б�
function InitMainList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:50,align:'center'},
		{field:'Name',title:'����',width:200,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		fitColumns:true,
		rownumbers:false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        LoadExecFormList(); ///����ִ�а�ȫ������
	        return;	        	
	    }
	};
	var autGroup = $HUI.combobox("#autGroup").getValue();
	var HospID = $HUI.combogrid("#_HospList").getValue();
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();	///Group/Loc
	params = autGroup+"^"+HospID+"^"+thisType;
	
	var uniturl = $URL+"?ClassName=web.DHCEMNurExecFormSetAut&MethodName=GetGroupJsonListTable&Params="+params;
	new ListComponent('main', columns, uniturl, option).Init();

}

function LoadExecFormList(){
	var rowsData = $("#main").datagrid('getSelected');
	if (rowsData == null) {
		return;	
	}
	LoadList("JsonListExecForm","execFormTab",rowsData.ID);
	return;
}


function LoadList(methodName,areaId,groupID){
	var InHospID = $HUI.combogrid("#_HospList").getValue();
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();	///Group/Loc

	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:methodName,
		GroupID:groupID,
		InHospID:InHospID,
		ThisType:thisType
	},function(jsonData){
		if($("#"+areaId).find(".listLiItmTwo").length){
			$("#"+areaId).find(".listLiItmTwo").remove();
		}

		for (key in jsonData){
			var listItmData=jsonData[key];
			var id="";
			if(key=="NoCheckDate") id="formPanelAll";
			if(key=="CheckDate") id="formPanelCheck";
			for (i in listItmData){
				itmData = listItmData[i];
				itmHtml = '<li class="listLiItmTwo '+(itmData.IsHas==1?"checkTwo":"")+'" data-id="'+itmData.value+'">'+itmData.text+'</li>';
				$("#"+id).append(itmHtml);
			}
		}
		
	});	
	return;
}



function formMoveUp(){
	formMoveOp("up");
}

function formMoveDown(){
	formMoveOp("down");
}

function formMoveOp(mode){
	var checkItmLen = $("#formPanelCheck").find(".checkTwo").length;
	if(checkItmLen==0){
		$.messager.alert("��ʾ","δѡ��Ԫ��!","warning");
		return;
	}
	if(checkItmLen>1){
		$.messager.alert("��ʾ","��ѡ��һ��Ҫ�ƶ�Ԫ��!","warning");
		return;
	}
	
	var checkDom = $("#formPanelCheck").find(".checkTwo")[0];
	if(mode=="up"){
		if(!$(checkDom).prev().hasClass("listLiItmTwo")){
			$.messager.alert("��ʾ","�Ѿ�������ǰ��!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).prev()[0].outerHTML;
		$(checkDom).after(prevDomHtml);
		$(checkDom).prev().remove();
	}
	if(mode=="down"){
		if(!$(checkDom).next().hasClass("listLiItmTwo")){
			$.messager.alert("��ʾ","�Ѿ��������!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).next()[0].outerHTML;
		$(checkDom).before(prevDomHtml);
		$(checkDom).next().remove();
	}
	return;	
}

function formSave(){
	formOp("add");
}

function formDel(){
	formOp("del");
}

function formSaveOrder(){
	formOp("order")
}

function formSaveDefault(){
	var defExecFormDr="";
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ�а�ȫ��!","warning");
		return;	
	}	
	var checkItmLen = $("#formPanelCheck").find(".checkTwo").length;
	
	if(checkItmLen==0){
		$.messager.alert("��ʾ","��ѡ��һ��Ҫ����Ĭ�ϵ�ִ�е�!","warning");
		return;
	}
	
	if(checkItmLen>1){
		$.messager.alert("��ʾ","����ѡ�ж��ִ�е�!","warning");
		return;
	}
	if(checkItmLen==1){
		var checkDom = $("#formPanelCheck").find(".checkTwo")[0];
		defExecFormDr =$(checkDom).attr("data-id"); 
	}
	
	var groupID = rowsData.ID;
	var inHospID = $HUI.combogrid("#_HospList").getValue();
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();	///Group/Loc
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:"SaveItmDefExecForm",
		dataType:"text",
		GroupID:groupID,
		InHospID:inHospID,
		DefExecFormDr:defExecFormDr,
		ThisType:thisType
	},function(ret){
		if(ret==0){
			LoadExecFormList();	
			$.messager.alert("��ʾ","Ĭ�ϱ���ɹ�!","warning");
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
			return;	
		}
	});	
}

function formClearnDefault(){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ�а�ȫ��!","warning");
		return;	
	}	
	
	var groupID = rowsData.ID;
	var inHospID = $HUI.combogrid("#_HospList").getValue();
	
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();	///Group/Loc	
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:"SaveItmDefExecForm",
		dataType:"text",
		GroupID:groupID,
		InHospID:inHospID,
		DefExecFormDr:"",
		ThisType:thisType
	},function(ret){
		if(ret==0){
			LoadExecFormList();	
			$.messager.alert("��ʾ","�ɹ�ȡ��Ĭ�ϣ�","warning");
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
			return;	
		}
	});	
}

function formOp(mode){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ�а�ȫ��!","warning");
		return;	
	}	
	var updFlag="";
	var mParArr=[];
	if(mode=="add"){
		$("#formPanelAll").find(".checkTwo").each(function(){
			mParArr.push($(this).attr("data-id"));
		})
	}
	
	if(mode=="del"){
		if($("#formPanelCheck").find(".checkTwo").length==0){
			$.messager.alert("��ʾ","û�д���������!","warning");
			return;	
		}
		
		$("#formPanelCheck").find(".listLiItmTwo").each(function(){
			if(!$(this).hasClass("checkTwo")){
				mParArr.push($(this).attr("data-id"));	
			}
		})
		updFlag=1;	
	}
	
	if(mode=="order"){
		$("#formPanelCheck").find(".listLiItmTwo").each(function(){
			mParArr.push($(this).attr("data-id"));	
		})
		updFlag=1;	
	}
	var mParams = mParArr.join("#")
	if((mParams=="")&&(mode!="del")){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;	
	}
	var groupID = rowsData.ID;
	var inHospID = $HUI.combogrid("#_HospList").getValue();
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();	///Group/Loc
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:"SaveItm",
		dataType:"text",
		GroupID:groupID,
		Params:mParams,
		InHospID:inHospID,
		UpdFlag:updFlag,
		ThisType:thisType
	},function(ret){
		if(ret==0){
			LoadExecFormList();	
			$.messager.alert("��ʾ","����ɹ�!","warning");
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
			return;	
		}
	});	
}

function ReloadMainTableAndCombo(){
	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();
	ReloadGroupCombo(thisType);
	ReloadMainTable();
	return;
}

function ReloadMainTable(){
	var autGroup = $HUI.combobox("#autGroup").getValue();
	var HospID = $HUI.combogrid("#_HospList").getValue();
 	var checkedRadioJObj = $("input[name='FSAType']:checked");
    var thisType = checkedRadioJObj.val();	///Group/Loc
    var autGroupInp = $("#autGroupInp").val();
	params = autGroup+"^"+HospID+"^"+thisType+"^"+autGroupInp;
	
	
	$HUI.datagrid('#main').load({
		Params:params
	})
	return ;
}

function ToggleType(){
	 var checkedRadioJObj = $("input[name='FSAType']:checked");
     var thisType = checkedRadioJObj.val();
     if(thisType==="Group"){
	 	$("#PointLabel").html("��ȫ��");    
	 	$("#PointLabel").css("margin-left","10px");
	 }else{
		$("#PointLabel").html("����");    		 
		$("#PointLabel").css("margin-left","24px");
	 }
	 
	 ReloadGroupCombo(thisType);
	 ReloadMainTable();
     return;
}

function ReloadGroupCombo(thisType){
	var HospID = $HUI.combogrid("#_HospList").getValue();
	$HUI.combobox("#autGroup").setValue("");
	$("#autGroupInp").val("");
	var url=$URL+"?ClassName=web.DHCEMNurExecFormSetAut&MethodName=GetGroupJsonListCombo&Type="+thisType+"&HospID="+HospID;
	$("#autGroup").combobox('reload',url);	
}

function changeFindType(e,value){
	if(value){
		$("#autGroup").combobox('setValue',"");	
	}else{
		$("#autGroupInp").val("");
	}
	$('.findItm').toggle();
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
