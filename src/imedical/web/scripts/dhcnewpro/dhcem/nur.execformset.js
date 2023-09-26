/// author:    qqa
/// date:      2019-11-22
/// descript:  ���ﻤʿִ������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var editRow = ""; editDRow = ""; editPRow = "",editCRow="",editURow="";
var editARow="",editBRow="";
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
	
	//��ӡ������
	InitExecPrintSetTable();
}
///��Ժ������
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}

function InitPageDom(){
	
	///���ز��õ�tab
	tab_option = $('#tabArea').tabs('getTab',"ִ�а�ȫ������").panel('options').tab;  
	tab_option.hide();
	
	var tabPageWidth = $("#tabArea").width();
	var tabPageHeight = $("#tabArea").height();
	
	var needPadTop = (parseInt(tabPageHeight)/2-90)+"px";
	var needPadTop2 = (parseInt(tabPageHeight)/2-110)+"px";
	var execColPanH = "100%";  //parseInt(tabPageHeight-58)+"px";
	var execGroupPanH = parseInt(tabPageHeight-58)+"px";
	var execColPanW = parseInt((tabPageWidth-250)/2);  ///��̬������panel���
	execColPanLiW = execColPanW-40;				   ///��̬������panel��Itm���
	
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
		title:"ȫ����Ŀ",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#columnsPanel2",{
		fit:true,
		title:"��ʾ��Ŀ",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelDis",{
		fit:true,
		title:"����״̬",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelPro",{
		fit:true,
		title:"���ȼ�",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelCat",{
		fit:true,
		title:"ҽ������",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelStat",{
		fit:true,
		title:"ҽ��״̬",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelPhi",{
		fit:true,
		title:"��ҩ;��",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelSpec",{
		fit:true,
		title:"�걾����",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#execProPanelRecLoc",{
		fit:true,
		title:"���տ���",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#groupPanelAll",{
		fit:true,
		title:"��ȫ��",
		headerCls:'panel-header-card'
	})
	
	$HUI.panel("#groupPanelCheck",{
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
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		return;	
	}
	LoadList("JsonListPro","execProTab",rowsData.ID);
	return;
}

function LoadGroupList(){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		return;	
	}
	LoadList("JsonListGroup","execGroupTab",rowsData.ID);
	return;
}
function LoadEpstList(){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
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
				if(shiftBeginIndex=="") shiftBeginIndex = $(this).parent().find(".checkTwo").last().index();  ///������ʼ����
			}else{  //û��ѡ��Ԫ��,����shiftѡ��Ԫ��
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
		$.messager.alert("��ʾ","δѡ��Ԫ��!","warning");
		return;
	}
	if(checkItmLen>1){
		$.messager.alert("��ʾ","��ѡ��һ��Ҫ�ƶ�Ԫ��!","warning");
		return;
	}
	
	var checkDom = $("#columnsPanel2").find(".check")[0];
	if(mode=="up"){
		if(!$(checkDom).prev().hasClass("listLiItm")){
			$.messager.alert("��ʾ","�Ѿ�������ǰ��!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).prev()[0].outerHTML;
		$(checkDom).after(prevDomHtml);
		$(checkDom).prev().remove();
	}
	if(mode=="down"){
		if(!$(checkDom).next().hasClass("listLiItm")){
			$.messager.alert("��ʾ","�Ѿ��������!","warning");
			return;
		}
		var prevDomHtml = $(checkDom).next()[0].outerHTML;
		$(checkDom).before(prevDomHtml);
		$(checkDom).next().remove();
	}
	return;	
}


function columnsOp(mode){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ��ִ�е�!","warning");
		return;	
	}	
	var updFlag="";
	var mParArr=[];
	if(mode=="add"){
		if($("#columnsPanel1").find(".check").length==0){
			$.messager.alert("��ʾ","δѡ���κ�����!","warning");
			return;	
		}
		
		$("#columnsPanel1").find(".check").each(function(){
			mParArr.push($(this).attr("data-id"));
		})
	}
	
	if(mode=="del"){
		if($("#columnsPanel2").find(".check").length==0){
			$.messager.alert("��ʾ","δѡ���κ�����!","warning");
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
			$.messager.alert("��ʾ","����ɹ�!","warning");
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
			return;	
		}
	});	
}


function GroupOp(mode){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ��ִ�е�!","warning");
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
		$.messager.alert("��ʾ","û�д���������!","warning");
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
			$.messager.alert("��ʾ","����ɹ�!","warning");
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
			return;	
		}
	});	
}

function columnsSaveOrder(){
	columnsOp("order")
}

function proSave(){
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ��ִ�е�!","warning");
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
			$.messager.alert("��ʾ","����ɹ�!","warning");
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
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

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
}

///��ʼ���ֵ������б�
function InitMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ҽԺ
	var HospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
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
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Name',title:'����',width:150,editor:textEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,hidden:true,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		fitColumns:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        LoadColumnsList();
	        LoadProList();   ///�����������ý���
	        LoadGroupList(); ///����ִ�а�ȫ������
	       	LoadEpstList();	 ///���ش�ӡ������
	        return;	        	
	    }
	};
	var code = $("#ExecFormCode").val();
	var hospID = $HUI.combogrid("#_HospList").getValue();
	
	var uniturl = $URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=QryExecOrder&Params="+code+"^"+hospID;
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Name=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","warning"); 
			return false;
		}
		
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!","warning"); 
			return false;
		}
		
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Name +"^"+ rowsData[i].HospID
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMNurExecFormSet","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Name:'', HospID:HospID, HospDesc:HospID}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMNurExecFormSet","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

///��ʼ�������б�
function InitConsOrdList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ��Դ�ű�
	var ArciEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
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
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:false,align:'center'},
		{field:'ArciID',title:'ArciID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'Arci',title:'����ҽ��',width:220,editor:ArciEditor,align:'center'},
		{field:'ArciNum',title:'����',width:100,editor:textEditor,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
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



///��ʼ�������б�
function InitGroupList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ���ұ༭��
	var LocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
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
	
	// ��Դ�ű�
	var PrvEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
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
				///���ü���ָ��
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=jsonLocCare&LocID="+ LocID;
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'GroupID',title:'GroupID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'GroupDesc',title:'��ȫ��',width:220,editor:groupEditor,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
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


///��ʼ�������б�
function InitExecPrintSetTable(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ҽ������
	var OrdLinkEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
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
	 * ����columns
	 */
	var columns=[[
		{field:'RowName',title:'����',width:120,editor:textEditor,align:'center'},
		{field:'RowWidth',title:'�п�(mm)',width:120,editor:textEditor,align:'center'},
		{field:'OrdLinkID',title:'ҽ������ID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'OrdLinkDesc',title:'ҽ������',width:200,editor:OrdLinkEditor,align:'center'},
		{field:'APOrdNum',title:'����',width:200,align:'center',formatter:cellStyler}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		pagination:false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
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


/// ����༭��
function saveEpstRow(){
	
	if(editBRow>="0"){
		$("#execPrintSetTable").datagrid('endEdit', editBRow);
	}
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","δѡ��ִ�е�!","warning");
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
			$.messager.alert("��ʾ","�������Ȳ���Ϊ��!","warning"); 
			isValidOk=0;
			return false;
		}
		if(isNaN(Number(ordLinkID))){
			$.messager.alert("��ʾ","�п�ȸ�ʽ����ȷ!","warning"); 
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
			$.messager.alert("��ʾ","����ɹ�!","warning");
			LoadEpstList();
		}else{
			$.messager.alert("��ʾ","����,Code"+ret,"warning");
			return;	
		}
	});
}

/// ��������
function insertEpstRow(){
	
	if(editBRow>="0"){
		$("#execPrintSetTable").datagrid('endEdit', editBRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#execPrintSetTable").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#execPrintSetTable').datagrid('selectRow',0);
			$("#execPrintSetTable").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	var addIndex=$("#execPrintSetTab").find('.datagrid-view2 > .datagrid-body').find('tr').length;
	
	$("#execPrintSetTable").datagrid('insertRow', {
		index: addIndex, // ������0��ʼ����
		row: {RowName:'', RowWidth:'', OrdLinkID:'', OrdLinkDesc:''}
	});
	
	$("#execPrintSetTable").datagrid('beginEdit', addIndex);//�����༭������Ҫ�༭����
	editBRow=addIndex;
}

/// ɾ��ѡ����
function deleteEpstRow(){
	
	var rowsData = $("#execPrintSetTable").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTGroup","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#execPrintSetTable').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function cellStyler(value,row,index){
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='icon icon-up l-btn-icon-left'>&nbsp;</span><span>����</span></span>"  //hxy 2018-10-22 ͼ��
	html=html+"</a>"
	html=html+"<a style='margin-left:10px' class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>" //hxy �Ӽ��10
	html=html+"<span class='l-btn-left'><span class='icon icon-down l-btn-icon-left'>&nbsp;</span><span>����</span></span>"  //hxy 2018-10-22 ͼ��
	html=html+"</a>"
	html=html+"<a style='margin-left:10px' class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveCancel("+index+")'>" //hxy �Ӽ��10
	html=html+"<span class='l-btn-left'><span class='icon icon-cancel l-btn-icon-left'>&nbsp;</span><span>�Ƴ�</span></span>"  //hxy 2018-10-22 ͼ��
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
	saveEpstRow();		//�Ƴ��Զ����ñ��淽��
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


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
