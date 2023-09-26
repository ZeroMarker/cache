/// author:    qqa
/// date:      2019-11-22
/// descript:  门诊护士执行设置
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var editRow = ""; editDRow = ""; editPRow = "",editCRow="",editURow="";
var editARow="",editBRow="";
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
	
	//打印列设置
	InitExecPrintSetTable();
}
///多院区设置
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}

function InitPageDom(){
	
	///隐藏不用的tab
	tab_option = $('#tabArea').tabs('getTab',"执行安全组设置").panel('options').tab;  
	tab_option.hide();
	
	var tabPageWidth = $("#tabArea").width();
	var tabPageHeight = $("#tabArea").height();
	
	var needPadTop = (parseInt(tabPageHeight)/2-90)+"px";
	var needPadTop2 = (parseInt(tabPageHeight)/2-110)+"px";
	var execColPanH = "100%";  //parseInt(tabPageHeight-58)+"px";
	var execGroupPanH = parseInt(tabPageHeight-58)+"px";
	var execColPanW = parseInt((tabPageWidth-250)/2);  ///动态列设置panel宽度
	execColPanLiW = execColPanW-40;				   ///动态列设置panel中Itm宽度
	
	var execProPanH = parseInt((tabPageHeight-85)/2)+"px";
	var execProPanW = parseInt((tabPageWidth-115)/4);
	
	$("#columnsAddSelAll").css("margin-top",needPadTop);
	$("#columnsDelSelAll").css("margin-top",needPadTop2);
	$("#execColAreaAll").css({width:execColPanW+"px","height":execColPanH});
	$("#execColAreaCheck").css({width:execColPanW+"px","height":execColPanH});
	$("#columnsSaveArea").css({width:"110px","height":execColPanH});
	$("#columnsChecSaveArea").css({width:"110px","height":execColPanH});
	
	$("#execProAreaDis").css({width:execProPanW+"px","height":execProPanH});
	$("#execProAreaPro").css({width:execProPanW+"px","height":execProPanH});
	$("#execProAreaCat").css({width:(execProPanW+80)+"px","height":execProPanH});
	$("#execProAreaStat").css({width:execProPanW+"px","height":execProPanH});
	$("#execProAreaPhi").css({width:execProPanW+"px","height":execProPanH});
	$("#execProAreaSpec").css({width:execProPanW+"px","height":execProPanH});
	$("#execProAreaRecLoc").css({width:(execProPanW*2+85)+"px","height":execProPanH});
	
	$("#groupAddSelAll").css("margin-top",needPadTop);
	$("#groupDelSelCheck").css("margin-top",needPadTop);
	$("#execGroupAreaAll").css({width:execColPanW+"px","height":execGroupPanH});
	$("#execGroupAreacheck").css({width:execColPanW+"px","height":execGroupPanH});
	$("#groupSaveAreaAll").css({width:"110px","height":execGroupPanH});
	$("#groupSaveAreaCheck").css({width:"110px","height":execGroupPanH});
	return;
}

function InitPanel(){
	$HUI.panel("#columnsPanel1",{
		fit:true,
		title:"全部项目",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#columnsPanel2",{
		fit:true,
		title:"显示项目",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelDis",{
		fit:true,
		title:"处置状态",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelPro",{
		fit:true,
		title:"优先级",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelCat",{
		fit:true,
		title:"医嘱分类",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelStat",{
		fit:true,
		title:"医嘱状态",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelPhi",{
		fit:true,
		title:"用药途径",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelSpec",{
		fit:true,
		title:"标本类型",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelRecLoc",{
		fit:true,
		title:"接收科室",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#groupPanelAll",{
		fit:true,
		title:"安全组",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#groupPanelCheck",{
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

function LoadList(methodName,areaId,execFormID){
	var hospID = $HUI.combogrid("#_HospList").getValue();
	$cm({
		ClassName:"web.DHCEMNurExecFormSet",
		MethodName:methodName,
		ExecFormID:execFormID,
		InHospID:hospID
	},function(jsonData){
		if($("#"+areaId).find(".listLiItmTwo").length){
			$("#"+areaId).find(".listLiItmTwo").remove();
		}

		for (key in jsonData){
			var listItmData=jsonData[key];
			var id="";
			if(key=="ExecDis") id="execProPanelDis";
			if(key=="ExecPro") id="execProPanelPro";
			if(key=="ExecCat") id="execProPanelCat";
			if(key=="ExecStat") id="execProPanelStat";
			if(key=="ExecPhi") id="execProPanelPhi";
			if(key=="ExecSpec") id="execProPanelSpec";
			if(key=="ExecRecLoc") id="execProPanelRecLoc";
			if(key=="AutGroupAll") id="groupPanelAll";
			if(key=="AutGroupCheck") id="groupPanelCheck";
			for (i in listItmData){
				itmData = listItmData[i];
				itmHtml = '<li class="listLiItmTwo '+(itmData.IsHas==1?"checkTwo":"")+'" data-id="'+itmData.value+'">'+itmData.text+'</li>';
				$("#"+id).append(itmHtml);
			}
		}
		
	});	
	return;
}

function LoadProList(){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		return;	
	}
	LoadList("JsonListPro","execProTab",rowsData.ID);
	return;
}

function LoadGroupList(){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		return;	
	}
	LoadList("JsonListGroup","execGroupTab",rowsData.ID);
	return;
}
function LoadEpstList(){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		return;	
	}
	
	$('#execPrintSetTable').datagrid("load",{
		"mID":rowsData.ID
	})
	return;
}

function InitCombobox(){
	
	
}

function InitMethod(){
	
	$("#queryBTN").on('click',ReloadMainTable);
	
	$("#columnsPanel1").on("click",".listLiItm",function(){
		var isCtrlKey = window.event.ctrlKey;
		if(!isCtrlKey){
			$(".listLiItm").not($(this)).removeClass("check");
			$(this).toggleClass("check");
		}else{
			if(!$("#columnsPanel1").find(".check").length){
				$("#columnsPanel2").find(".check").removeClass("check");			
			}
			$(this).toggleClass("check");
		}
	})
	
	$("#columnsPanel2").on("click",".listLiItm",function(){
		var isCtrlKey = window.event.ctrlKey;
		if(!isCtrlKey){
			$(".listLiItm").not($(this)).removeClass("check");
			$(this).toggleClass("check");
		}else{
			if(!$("#columnsPanel2").find(".check").length){
				$("#columnsPanel1").find(".check").removeClass("check");			
			}
			$(this).toggleClass("check");
		}
	})
	
	$("#execProPanelDis,#execProPanelPro,#execProPanelCat,#execProPanelStat,#execProPanelPhi,#execProPanelSpec,#execProPanelRecLoc,#execGroupAreaAll,#execGroupAreacheck").on("click",".listLiItmTwo",function(){
		var isCtrlKey = window.event.ctrlKey;
		var isShitKey = window.event.shiftKey;
		if(isShitKey){
			var thisIndex = $(this).index();
			var allItmDom = $(this).parent().find(".listLiItmTwo");
			if($(this).parent().find(".checkTwo").length){
				if(shiftBeginIndex=="") shiftBeginIndex = $(this).parent().find(".checkTwo").last().index();  ///设置起始坐标
			}else{  //没有选择元素,不配shift选中元素
				return;
			}
			$(this).parent().find(".listLiItmTwo").removeClass("checkTwo");
			
			var stIndex="",endIndex = "";
			if(shiftBeginIndex<thisIndex){
				stIndex	= shiftBeginIndex-1;
				endIndex = thisIndex;
			}else{
				stIndex	= thisIndex-1;
				endIndex = shiftBeginIndex;
			}
			for(i=stIndex;i<endIndex;i++){
				$(allItmDom[i]).addClass("checkTwo");	
			}
		}else{
			shiftBeginIndex = "";
			
			if(!isCtrlKey){
				$(this).parent().find(".listLiItmTwo").not($(this)).removeClass("checkTwo");
				$(this).toggleClass("checkTwo");
			}else{
				if(!$(this).parent().find(".checkTwo").length){
					$(this).parent().find(".checkTwo").removeClass("checkTwo");			
				}
				$(this).toggleClass("checkTwo");
			}
		}
	})
}

function columnsSave(){
	columnsOp("add");
}

function columnsDel(){
	columnsOp("del");
}

function columnsMoveUp(){
	columnsMoveOp("up");
}

function columnsMoveDown(){
	columnsMoveOp("down");
}

function groupSave(){
	GroupOp("add");
}
function groupDel(){
	GroupOp("del");
}
function columnsMoveOp(mode){
	var checkItmLen = $("#columnsPanel2").find(".check").length;
	if(checkItmLen==0){
		$.messager.alert("提示","未选中元素!","warning");
		return;
	}
	if(checkItmLen>1){
		$.messager.alert("提示","请选中一个要移动元素!","warning");
		return;
	}
	
	var checkDom = $("#columnsPanel2").find(".check")[0];
	if(mode=="up"){
		if(!$(checkDom).prev().hasClass("listLiItm")){
			$.messager.alert("提示","已经是在最前方!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).prev()[0].outerHTML;
		$(checkDom).after(prevDomHtml);
		$(checkDom).prev().remove();
	}
	if(mode=="down"){
		if(!$(checkDom).next().hasClass("listLiItm")){
			$.messager.alert("提示","已经是在最后方!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).next()[0].outerHTML;
		$(checkDom).before(prevDomHtml);
		$(checkDom).next().remove();
	}
	return;	
}


function columnsOp(mode){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中执行单!","warning");
		return;	
	}	
	var updFlag="";
	var mParArr=[];
	if(mode=="add"){
		if($("#columnsPanel1").find(".check").length==0){
			$.messager.alert("提示","未选中任何数据!","warning");
			return;	
		}
		
		$("#columnsPanel1").find(".check").each(function(){
			mParArr.push($(this).attr("data-id"));
		})
	}
	
	if(mode=="del"){
		if($("#columnsPanel2").find(".check").length==0){
			$.messager.alert("提示","未选中任何数据!","warning");
			return;	
		}
		$("#columnsPanel2").find(".listLiItm").each(function(){
			if(!$(this).hasClass("check")){
				mParArr.push($(this).attr("data-id"));	
			}
		})
		updFlag=1;	
	}
	
	if(mode=="order"){
		$("#columnsPanel2").find(".listLiItm").each(function(){
			mParArr.push($(this).attr("data-id"));	
		})
		updFlag=1;	
	}
	
	
	var mParams = "Column"+String.fromCharCode(2)+mParArr.join("#")
	
	var execFormID = rowsData.ID;
	$cm({
		ClassName:"web.DHCEMNurExecFormSet",
		MethodName:"SaveItm",
		dataType:"text",
		ExecFormID:execFormID,
		Params:mParams,
		UpdFlag:updFlag
	},function(ret){
		if(ret==0){
			LoadColumnsList();	
			$.messager.alert("提示","保存成功!","warning");
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});	
}


function GroupOp(mode){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中执行单!","warning");
		return;	
	}	
	var updFlag="";
	var mParArr=[];
	if(mode=="add"){
		$("#groupPanelAll").find(".checkTwo").each(function(){
			mParArr.push($(this).attr("data-id"));
		})
	}
	
	if(mode=="del"){
		$("#groupPanelCheck").find(".listLiItmTwo").each(function(){
			if(!$(this).hasClass("checkTwo")){
				mParArr.push($(this).attr("data-id"));	
			}
		})
		updFlag=1;	
	}
	
	var mParams = "ShowAutGroup"+String.fromCharCode(2)+mParArr.join("#")
	if(mParams==""){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;	
	}
	var execFormID = rowsData.ID;
	$cm({
		ClassName:"web.DHCEMNurExecFormSet",
		MethodName:"SaveItm",
		dataType:"text",
		ExecFormID:execFormID,
		Params:mParams,
		UpdFlag:updFlag
	},function(ret){
		if(ret==0){
			LoadList("JsonListGroup","execGroupTab",execFormID);
			$.messager.alert("提示","保存成功!","warning");
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});	
}

function columnsSaveOrder(){
	columnsOp("order")
}

function proSave(){
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中执行单!","warning");
		return;	
	}	
	var execFormID = rowsData.ID;
	
	var allSaveDataArr=[],allSaveData="";
	$(".execProTab").find(".ppDiv").each(function(){
		var itmSaveDataArr=[],itmSaveData="";	
		var itmAllLen = $(this).find(".checkTwo").length;
		var proSetCode = $(this).attr("data-code");
		for(var i=0;i<itmAllLen;i++){
			itmSaveDataArr.push($(this).find(".checkTwo")[i].getAttribute("data-id"))
		}
		itmSaveData = proSetCode+String.fromCharCode(2)+itmSaveDataArr.join("#");
		allSaveDataArr.push(itmSaveData);
	})
	
	allSaveData  = allSaveDataArr.join("!@!");
	
	$cm({
		ClassName:"web.DHCEMNurExecFormSet",
		MethodName:"SaveItms",
		dataType:"text",
		ExecFormID:execFormID,
		AllParams:allSaveData,
		UpdFlag:"1"
	},function(ret){
		if(ret==0){
			$.messager.alert("提示","保存成功!","warning");
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});	
}


function columnsAddSelAll(){
	$("#columnsPanel2").find(".check").removeClass("check");
	$("#columnsPanel1").find(".listLiItm").addClass("check");	
}

function groupAddSelAll(){
	$("#execGroupAreacheck").find(".checkTwo").removeClass("checkTwo");
	$("#execGroupAreaAll").find(".listLiItmTwo").addClass("checkTwo");	
}

function groupDelSelAll(){
	$("#execGroupAreaAll").find(".checkTwo").removeClass("checkTwo");
	$("#execGroupAreacheck").find(".listLiItmTwo").addClass("checkTwo");	
}

function columnsDelSelAll(){
	$("#columnsPanel1").find(".check").removeClass("check");
	$("#columnsPanel2").find(".listLiItm").addClass("check");	
}

function ReloadMainTable(){
	var params="";
	var code = $("#ExecFormCode").val();
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = code+"^"+hospID
	
	
	$HUI.datagrid('#main').load({
		Params:params
	})
	return ;
}

/// 界面元素监听事件
function InitWidListener(){
	
}

///初始化字典类型列表
function InitMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 医院
	var HospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			},onChange:function(newValue,oldValue){
				if(newValue==""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
					$(ed.target).val(""); 	
				}
			}
	
		}
	}
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'Code',title:'代码',width:100,editor:textEditor,align:'center'},
		{field:'Name',title:'名称',width:150,editor:textEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'HospDesc',title:'医院',width:200,editor:HospEditor,hidden:true,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		fitColumns:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        LoadColumnsList();
	        LoadProList();   ///加载属性配置界面
	        LoadGroupList(); ///加载执行安全组配置
	       	LoadEpstList();	 ///加载打印列设置
	        return;	        	
	    }
	};
	var code = $("#ExecFormCode").val();
	var hospID = $HUI.combogrid("#_HospList").getValue();
	
	var uniturl = $URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=QryExecOrder&Params="+code+"^"+hospID;
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Name=="")){
			$.messager.alert("提示","代码或描述不能为空!","warning"); 
			return false;
		}
		
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!","warning"); 
			return false;
		}
		
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Name +"^"+ rowsData[i].HospID
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMNurExecFormSet","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Name:'', HospID:HospID, HospDesc:HospID}
	});
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMNurExecFormSet","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

///初始化属性列表
function InitConsOrdList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 资源号别
	var ArciEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'ArciID'});
				$(ed.target).val(option.value);
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'Arci'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'Arci'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTOrdConfig&MethodName=ListArci";
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:false,align:'center'},
		{field:'ArciID',title:'ArciID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'Arci',title:'会诊医嘱',width:220,editor:ArciEditor,align:'center'},
		{field:'ArciNum',title:'数量',width:100,editor:textEditor,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editCRow != "")||(editCRow == "0")) { 
                $("#consOrd").datagrid('endEdit', editCRow); 
            } 
            $("#consOrd").datagrid('beginEdit', rowIndex); 
            editCRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTOrdConfig&MethodName=QryList&mID=0";
	new ListComponent('consOrd', columns, uniturl, option).Init();
}



///初始化属性列表
function InitGroupList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 科室编辑格
	var LocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvID'});
				$(ed.target).val("");
			}
		}
	}
	
	// 资源号别
	var PrvEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvID'});
				$(ed.target).val(option.value);
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///设置级联指针
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=jsonLocCare&LocID="+ LocID;
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'GroupID',title:'GroupID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'GroupDesc',title:'安全组',width:220,editor:groupEditor,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#detail").datagrid('endEdit', editPRow); 
            } 
            $("#detail").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTCareProv&MethodName=QryCareProv&mID=0";
	new ListComponent('detail', columns, uniturl, option).Init();
}


///初始化属性列表
function InitExecPrintSetTable(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 医嘱关联
	var OrdLinkEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL +"?ClassName=web.DHCEMNurExecFormSet&MethodName=JsonOrdLink",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#execPrintSetTable").datagrid('getEditor',{index:editBRow,field:'OrdLinkID'});
				$(ed.target).val(option.value);
			}
		}
	}
	
	
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'RowName',title:'列名',width:120,editor:textEditor,align:'center'},
		{field:'RowWidth',title:'列宽(mm)',width:120,editor:textEditor,align:'center'},
		{field:'OrdLinkID',title:'医嘱关联ID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'OrdLinkDesc',title:'医嘱关联',width:200,editor:OrdLinkEditor,align:'center'},
		{field:'APOrdNum',title:'操作',width:200,align:'center',formatter:cellStyler}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		pagination:false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editBRow != "")||(editBRow == "0")) { 
                $("#execPrintSetTable").datagrid('endEdit', editBRow); 
            } 
            $("#execPrintSetTable").datagrid('beginEdit', rowIndex); 
            editBRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=QryEpstList&mID=0";
	new ListComponent('execPrintSetTable', columns, uniturl, option).Init();
}


/// 保存编辑行
function saveEpstRow(){
	
	if(editBRow>="0"){
		$("#execPrintSetTable").datagrid('endEdit', editBRow);
	}
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","未选中执行单!","warning");
		return;	
	}	
	var execFormID = rowsData.ID;
	
	var $row = $("#execPrintSetTab").find('.datagrid-view2 > .datagrid-body').find('tr');
	
	var dataList = [],isValidOk=1;
	$row.each(function(i,obj){
		var rowName = getValueByField(obj,"RowName");
		var rowWidth = getValueByField(obj,"RowWidth");
		var ordLinkID = getValueByField(obj,"OrdLinkID");
		if((rowName=="")||(rowWidth=="")){
			$.messager.alert("提示","列名或宽度不能为空!","warning"); 
			isValidOk=0;
			return false;
		}
		if(isNaN(Number(ordLinkID))){
			$.messager.alert("提示","列宽度格式不正确!","warning"); 
			isValidOk=0;
			return false;
		}
		var tmp=rowName +"|"+ rowWidth +"|"+ ordLinkID;
		dataList.push(tmp);
	});
	
	if(!isValidOk){
		return ;	
	}
	
	var mListData="PrintSetList"+String.fromCharCode(2)+dataList.join("##");
	$cm({
		ClassName:"web.DHCEMNurExecFormSet",
		MethodName:"SaveItms",
		dataType:"text",
		ExecFormID:execFormID,
		AllParams:mListData,
		UpdFlag:"1"
	},function(ret){
		if(ret==0){
			$.messager.alert("提示","保存成功!","warning");
			LoadEpstList();
		}else{
			$.messager.alert("提示","错误,Code"+ret,"warning");
			return;	
		}
	});
}

/// 插入新行
function insertEpstRow(){
	
	if(editBRow>="0"){
		$("#execPrintSetTable").datagrid('endEdit', editBRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#execPrintSetTable").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#execPrintSetTable').datagrid('selectRow',0);
			$("#execPrintSetTable").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	var addIndex=$("#execPrintSetTab").find('.datagrid-view2 > .datagrid-body').find('tr').length;
	
	$("#execPrintSetTable").datagrid('insertRow', {
		index: addIndex, // 行数从0开始计算
		row: {RowName:'', RowWidth:'', OrdLinkID:'', OrdLinkDesc:''}
	});
	
	$("#execPrintSetTable").datagrid('beginEdit', addIndex);//开启编辑并传入要编辑的行
	editBRow=addIndex;
}

/// 删除选中行
function deleteEpstRow(){
	
	var rowsData = $("#execPrintSetTable").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTGroup","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#execPrintSetTable').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

function cellStyler(value,row,index){
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='icon icon-up l-btn-icon-left'>&nbsp;</span><span>上移</span></span>"  //hxy 2018-10-22 图标
	html=html+"</a>"
	html=html+"<a style='margin-left:10px' class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>" //hxy 加间距10
	html=html+"<span class='l-btn-left'><span class='icon icon-down l-btn-icon-left'>&nbsp;</span><span>下移</span></span>"  //hxy 2018-10-22 图标
	html=html+"</a>"
	html=html+"<a style='margin-left:10px' class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveCancel("+index+")'>" //hxy 加间距10
	html=html+"<span class='l-btn-left'><span class='icon icon-cancel l-btn-icon-left'>&nbsp;</span><span>移除</span></span>"  //hxy 2018-10-22 图标
	html=html+"</a>"
	return html;
}

function moveUp(index){move(true,index)}

function moveDown(index){move(false,index)}

function move(isUp,index) {
	var rows=$('#execPrintSetTable').datagrid('getData');

	if(!(isUp)&&(index==rows.length)){
		return;
	}
	var $view = $("#epst_tb").next(); //$("#execPrintSetTable").find('div.datagrid-view');
	
	var $row = $view.find('tr[datagrid-row-index=' + index + ']');		
	if (isUp) {
	    $row.each(function(){
		    var prev = $(this).prev();
		    prev.length && $(this).insertBefore(prev);
		});
	} else {
		$row.each(function(){
			var next = $(this).next();
			next.length && $(this).insertAfter(next);
		});
	}
}

function moveCancel(index){
	var $view = $("#epst_tb").next();
	var $row = $view.find('tr[datagrid-row-index=' + index + ']');
	$row.remove();
	saveEpstRow();		//移除自动调用保存方法
}

function getValueByField(obj,field){		
	 ret=""  
	 $(obj).find('td').each(function(j,o){
		 	if($(o).attr("field")==field){
				ret=$(o).find('div').html(); 	
			}
	 });
	 return ret;
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
