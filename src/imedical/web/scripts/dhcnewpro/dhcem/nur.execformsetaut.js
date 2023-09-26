/// author:    qqa
/// date:      2019-11-22
/// descript:  门诊护士执行设置
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var editRow = ""; editDRow = ""; editPRow = "",editCRow="",editURow="";
var editARow="";
/// 页面初始化函数
function initPageDefault(){
	
	///多院区设置
	MoreHospSetting("DHC_EmExecFormSet");
	
	///动态设置的Dom元素
	InitPageDom();
	
	///初始化界面Panel
	InitPanel();
	
	///初始化Combbox
	InitCombobox();
	
	///初始化绑定的方法
	InitMethod();
	
	//初始化执行单列表
	InitMainList();
}

///多院区设置
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}

function InitPageDom(){
	var pageWidth = $("#execFormAreaAll").parent().width();
	var pageHeight = $("#execFormAreaAll").parent().height();
	
	var needPadTop = (parseInt(pageHeight)/2-90)+"px";
	var needPadTop2 = (parseInt(pageHeight)/2-150)+"px";
	
	var execFormPanH = parseInt(pageHeight)+"px";
	var execFormPanW = parseInt((pageWidth-250)/2);  ///动态列设置panel宽度
	execColPanLiW = execFormPanW-40;				   ///动态列设置panel中Itm宽度
	
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
		title:"执行单",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#formPanelCheck",{
		fit:true,
		title:"已授权",
		headerCls:'panel-header-card'
	})
}

function LoadColumnsList(){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
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
	
	$HUI.combobox("#autGroup",{
		url:$URL+"?ClassName=web.DHCEMNurExecFormSetAut&MethodName=GetGroupJsonListCombo",
		valueField: "value", 
			textField: "text",
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
}


///初始化字典类型列表
function InitMainList(){
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:50,align:'center'},
		{field:'Name',title:'安全组',width:200,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		fitColumns:true,
		rownumbers:false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        LoadExecFormList(); ///加载执行安全组配置
	        return;	        	
	    }
	};
	var autGroup = $HUI.combobox("#autGroup").getValue();
	var HospID = $HUI.combogrid("#_HospList").getValue();
	params = autGroup+"^"+HospID;
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
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:methodName,
		GroupID:groupID,
		InHospID:InHospID
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
		$.messager.alert("提示","未选中元素!","warning");
		return;
	}
	if(checkItmLen>1){
		$.messager.alert("提示","请选中一个要移动元素!","warning");
		return;
	}
	
	var checkDom = $("#formPanelCheck").find(".checkTwo")[0];
	if(mode=="up"){
		if(!$(checkDom).prev().hasClass("listLiItmTwo")){
			$.messager.alert("提示","已经是在最前方!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).prev()[0].outerHTML;
		$(checkDom).after(prevDomHtml);
		$(checkDom).prev().remove();
	}
	if(mode=="down"){
		if(!$(checkDom).next().hasClass("listLiItmTwo")){
			$.messager.alert("提示","已经是在最后方!","warning");
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
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中安全组!","warning");
		return;	
	}	
	var checkItmLen = $("#formPanelCheck").find(".checkTwo").length;
	
	if(checkItmLen==0){
		$.messager.alert("提示","请选中一个要设置默认的执行单!","warning");
		return;
	}
	
	if(checkItmLen>1){
		$.messager.alert("提示","请勿选中多个执行单!","warning");
		return;
	}
	if(checkItmLen==1){
		var checkDom = $("#formPanelCheck").find(".checkTwo")[0];
		defExecFormDr =$(checkDom).attr("data-id"); 
	}
	
	var groupID = rowsData.ID;
	var inHospID = $HUI.combogrid("#_HospList").getValue();
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:"SaveItmDefExecForm",
		dataType:"text",
		GroupID:groupID,
		InHospID:inHospID,
		DefExecFormDr:defExecFormDr
	},function(ret){
		if(ret==0){
			LoadExecFormList();	
			$.messager.alert("提示","默认保存成功!","warning");
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});	
}

function formClearnDefault(){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中安全组!","warning");
		return;	
	}	
	
	var groupID = rowsData.ID;
	var inHospID = $HUI.combogrid("#_HospList").getValue();
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:"SaveItmDefExecForm",
		dataType:"text",
		GroupID:groupID,
		InHospID:inHospID,
		DefExecFormDr:""
	},function(ret){
		if(ret==0){
			LoadExecFormList();	
			$.messager.alert("提示","成功取消默认！","warning");
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});	
}

function formOp(mode){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中安全组!","warning");
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
			$.messager.alert("提示","没有待保存数据!","warning");
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
		$.messager.alert("提示","没有待保存数据!","warning");
		return;	
	}
	var groupID = rowsData.ID;
	var inHospID = $HUI.combogrid("#_HospList").getValue();
	$cm({
		ClassName:"web.DHCEMNurExecFormSetAut",
		MethodName:"SaveItm",
		dataType:"text",
		GroupID:groupID,
		Params:mParams,
		InHospID:inHospID,
		UpdFlag:updFlag
	},function(ret){
		if(ret==0){
			LoadExecFormList();	
			$.messager.alert("提示","保存成功!","warning");
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});	
}

function ReloadMainTable(){
	var autGroup = $HUI.combobox("#autGroup").getValue();
	var HospID = $HUI.combogrid("#_HospList").getValue();
	params = autGroup+"^"+HospID;
	
	
	$HUI.datagrid('#main').load({
		Params:params
	})
	return ;
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
