/**
* HISUI 床位卡配置配置-主js
*/
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
	 document.getElementsByTagName('head')[0].appendChild(script);
}
var PageLogicObj={
}
$(function(){
	InitHospList();
	InitEvent();
});
$(window).load(function() {
	$("#Loading").hide();
	InitEditWindow();
})
//window.addEventListener("resize",ResetDomSize);
function ResetDomSize() {
	var innerHeight=window.innerHeight;
	$("#BedChartItemPanel").css('height',innerHeight-60);
	$("#BedCard").css('height',270);
	$("#HoverCard").css('height',innerHeight-410);
}
function InitEvent(){
	$("#BDSave").click(SaveBedCardClick);
	$("#BDCancel").click(function(){
		$("#BedCardEditWin").window('close');
	});
	$("#BCSave").click(SaveHoverCardClick);
	$("#BCCancel").click(function(){
		$("#HoverCardEditWin").window('close');
	});
	$("#DCSave").click(SaveDetailCardClick);
	$("#DCCancel").click(function(){
		$("#DetailCardEditWin").window('close');
	});
	$("#Find").click(FindClick);
}
function FindClick(){
	$("#BedCardTable,#HoverCardTable,#DetailCardTable").datagrid("load");
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_BedChartItem");
	hospComp.jdata.options.onSelect = function(e,t){
		$.extend(PageLogicObj,{BC_SelRowId:"",HC_SelRowId:"",DC_SelRowId:""});
		$('#ward').combobox("setValue").combobox("reload");
		//$("#BedCardTable,#HoverCardTable,#DetailCardTable").datagrid("load");
		InitEditWindow();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitWard(); //Init();
	}
}
function Init(){
	ResetDomSize()
	InitBedCardTableGrid();
	InitHoverCardTableGrid();
	InitDetailCardTableGrid();
	//$("#BedCardTable,#HoverCardTable,#DetailCardTable").datagrid("load");
}
function InitBedCardTableGrid() {
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				var tableLength = $('#BedCardTable').datagrid('getRows').length;
				if (tableLength >= 6) {
					$.messager.popover({msg:'最多只能维护6条数据！',type:'info'});
					return false;
				}
				$("#BedCardEditWin").window('open');
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
				var row = $("#BedCardTable").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				ShowBedCardWin(row)
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteBedCard()
            }
        },{
            text: '翻译',
            iconCls: 'icon-translate-word',
            handler: function() {
	            Translate("BedCardTable","CF.NUR.NIS.BedChartItem","BCIItemDesc","BCIItemDesc")	
            }
        }];	
	var Columns=[[    
		{ field: 'BCICodeName',title:'基础数据项目',width:300},
		{ field: 'BCIItemDesc',title:'名称描述',width:300},
		{ field: 'BCIPositionRow',title:'显示位置',width:300},
    ]];
    $('#BedCardTable').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"RowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetBedCardItemList",
		onBeforeLoad:function(param){
			PageLogicObj.BC_SelRowId=""
			$('#BedCardTable').datagrid("unselectAll");
			param = $.extend(param,{
				hospId:$HUI.combogrid('#_HospList').getValue(),
				wardId:getSelWardId()
			});
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	})
}
function InitHoverCardTableGrid() {
	var ToolBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			$("#HoverCardEditWin").window('open');
		}
	},{
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#HoverCardTable").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
				return false;
			}
			ShowHoverCardWin(row)
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			DeleteHoverCard()
		}
	},{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
            Translate("HoverCardTable","CF.NUR.NIS.HoverCardData","HCDName","HCDItemDesc")	
        }
    }];	
	var Columns=[[    
		{ field: 'HCDSubgroup',title:'分组',width:200},
		{ field: 'HCDSerialId',title:'组内序号',width:200},
		{ field: 'HCDCodeName',title:'基础数据项目',width:300},
		{ field: 'HCDItemDesc',title:'名称描述',width:300},
	]];
	$('#HoverCardTable').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"RowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetHoverCardDataList",
		onBeforeLoad:function(param){
			PageLogicObj.HC_SelRowId=""
			$('#HoverCardTable').datagrid("unselectAll");
			param = $.extend(param,{
				hospId:$HUI.combogrid('#_HospList').getValue(),
				wardId:getSelWardId()
			});
		
		},
			onDblClickRow:function(rowIndex, rowData){
		}
})
}
function InitEditWindow() {
	$("#BedCardCode,#HoverCardCode").combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=getBedRequestItem&rows=99999",
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		onBeforeLoad:function(param){
			param.hospId=$HUI.combogrid('#_HospList').getValue()
			param.filter=1;
		},loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.total;i++){
				var obj=data.rows[i];
				obj.text=obj.name+"/"+obj.key;
				obj.id=obj.NBDRowId;
				newData.push(obj);
			}
			return newData;
		}
	})
	$('#DetailCardCode').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&rows=99999",
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		onBeforeLoad:function(param){
			param.searchName="";
			param.searchType=0;
			param.filter=1;
		},loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.total;i++){
				var obj=data.rows[i];
				obj.text=obj.NBDName+"/"+obj.NBDCode;
				obj.id=obj.RowID;
				newData.push(obj);
			}
			return newData;
		}
    });
	/*$('#HoverCardCode').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&rows=99999",
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		onBeforeLoad:function(param){
			param.searchName="";
			param.searchType=0;
			param.filter=1;
		},loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.total;i++){
				var obj=data.rows[i];
				obj.text=obj.NBDName+"/"+obj.NBDCode;
				obj.id=obj.RowID;
				newData.push(obj);
			}
			return newData;
		}
    });*/
    $("#DetailCardColumns").combobox({
		multiple:true,
		rowStyle:'checkbox',
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		data:[{"id":1,"text":"第一列"},{"id":2,"text":"第二列"},{"id":3,"text":"第三列"}],
		onLoadSuccess:function(){
			$("#DetailCardColumns").combobox("setValues","");
		}
    });
	$("#BedCardEditWin").window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetBedCardEditWinData()
	   }
	});
	$("#HoverCardEditWin").window({
		modal: true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true,
		onClose:function(){
			SetHoverCardEditWinData()
		}
	});
	$("#DetailCardEditWin").window({
		modal: true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true,
		onClose:function(){
			SetDetailCardEditWinData()
		}
	});
}
function ShowBedCardWin(row) {
	$("#BedCardEditWin").panel({title:"修改床位卡配置"});
	$("#BedCardCode").combobox("setValue",row.BCICodeDR);
	$("#BedCardDesc").val(row.BCIItemDesc);
	$("#BedCardPositionRow").numberbox("setValue",row.BCIPositionRow);
	PageLogicObj.BC_SelRowId=row.RowID;
	$("#BedCardEditWin").window('open');
}
function ShowHoverCardWin(row) {
	$("#HoverCardEditWin").panel({title:"修改床位卡悬浮内容配置"});
	$("#HoverCardSubgroup").numberbox("setValue",row.HCDSubgroup);
	$("#HoverCardSerialId").numberbox("setValue",row.HCDSerialId);
	$("#HoverCardCode").combobox("setValue",row.HCDCodeDR);
	$("#HoverCardName").val(row.HCDItemDesc);
	PageLogicObj.HC_SelRowId=row.RowID;
	$("#HoverCardEditWin").window('open');
}
function ShowDetailCardWin(row) {
	$("#DetailCardEditWin").panel({title:"修改床位卡悬浮内容配置"});
	$("#DetailCardRow").numberbox("setValue",row.DCDRow);
	$("#DetailCardColumns").combobox("setValues",row.DCDColumns.split("^"));
	$("#DetailCardCode").combobox("setValue",row.DCDCodeDR);
	$("#DetailCardName").val(row.DCDItemDesc);
	PageLogicObj.DC_SelRowId=row.RowID;
	$("#DetailCardEditWin").window('open');
}
function SetBedCardEditWinData() {
	$("#BedCardEditWin").panel({title:"新增床位卡配置"});
	PageLogicObj.BC_SelRowId="";
	$("#BedCardDesc").val("");
	$("#BedCardPositionRow").numberbox("setValue","");
	$("#BedCardCode").combobox("setValue","");
}
function SetHoverCardEditWinData() {
	$("#HoverCardEditWin").panel({title:"新增床位卡悬浮内容配置"});
	PageLogicObj.HC_SelRowId="";
	$("#HoverCardName").val("");
	$("#HoverCardSubgroup,#HoverCardSerialId").numberbox("setValue","");
	$("#HoverCardCode").combobox("setValue","");
}
function SetDetailCardEditWinData(){
	$("#DetailCardEditWin").panel({title:"新增床位卡患者详细信息配置"});
	PageLogicObj.DC_SelRowId="";
	$("#DetailCardRow").numberbox("setValue","");
	$("#DetailCardName").val("");
	$("#DetailCardColumns").combobox("setValues","");
	$("#DetailCardColumns,#DetailCardCode").combobox("setValue","");
}
function DeleteBedCard() {
	var selected = $("#BedCardTable").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
		return false;
	}
	var rowID=selected.RowID;
	var Msg="确定要删除此条基本数据吗？";
	$.messager.confirm('确认对话框', Msg, function(r){
		if (r) {
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				MethodName:"HandleBedCardItem",
				rowID:rowID,
				codeDr:'',
				desc:'',
				position:'',
				hospId:'',
				event:"DELETE"
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				//$("#NurseBasicDataList").datagrid("reload");
				var QueIndex=$('#BedCardTable').datagrid('getRowIndex',rowID);
				$('#BedCardTable').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
function DeleteHoverCard() {
	var selected = $("#HoverCardTable").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'请选择需要删除的记录',type:'error'});
		return false;
	}
	var rowID=selected.RowID;
	var Msg="确定要删除此条基本数据吗？";
	$.messager.confirm('确认对话框', Msg, function(r){
		if (r) {
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				MethodName:"HandleHoverCardData",
				rowID:rowID,
				subgroup:'',
				serialId:'',
				codeDr:'',
				name:'',
				hospId:$HUI.combogrid('#_HospList').getValue(),
				event:"DELETE"
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				//$("#NurseBasicDataList").datagrid("reload");
				var QueIndex=$('#HoverCardTable').datagrid('getRowIndex',rowID);
				$('#HoverCardTable').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
function SaveBedCardClick() {
	var arr=$('#BedCardTable').datagrid('getData');
	console.log(arr);
	var BCICode=$("#BedCardCode").combobox("getValue");
	if (!BCICode) {
		$.messager.popover({msg:'请选则基础数据项目',type:'error'});
		$('#BedCardCode').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#BedCardCode').combobox("getData"),"id",BCICode)<0){
		$.messager.popover({msg:'请在下拉框中选择基础数据项目',type:'error'});
		$('#BedCardCode').next('span').find('input').focus();
		return false;
	}
	var BCIDesc=$("#BedCardDesc").val();
	if (!BCIDesc) {
		$.messager.popover({msg:'请输入名称描述',type:'error'});
		$("#BedCardDesc").focus();
		return false;
	}
	var BCIPositionRow=$("#BedCardPositionRow").numberbox("getValue");
	if (!BCIPositionRow) {
		$.messager.popover({msg:'请输入显示位置',type:'error'});
		$("#BedCardPositionRow").focus();
		return false;
	}
	console.log(BCICode,BCIDesc,BCIPositionRow)
	var sc=$.m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"HandleBedCardItem",
		rowID:PageLogicObj.BC_SelRowId,
		codeDr:BCICode,
		desc:BCIDesc,
		position:BCIPositionRow,
		hospId:$HUI.combogrid('#_HospList').getValue(),
		wardId:getSelWardId(),
		event:"SAVE"
	},false)
	if (sc==="0"){
		$("#BedCardEditWin").window("close");
		$("#BedCardTable").datagrid("reload");
	}else{
		if (sc==="-1") {
			$.messager.alert("提示","保存失败!");
		}else{
			$.messager.alert("提示","保存失败,"+sc);
		}
		return false;
	}
}
function SaveHoverCardClick() {
	var HCDSubgroup=$("#HoverCardSubgroup").numberbox("getValue");
	if (!HCDSubgroup) {
		$.messager.popover({msg:'请输入分组',type:'error'});
		$("#HoverCardSubgroup").focus();
		return false;
	}
	var HCDSerialId=$("#HoverCardSerialId").numberbox("getValue");
	if (!HCDSerialId) {
		$.messager.popover({msg:'请输入组内序号',type:'error'});
		$("#HoverCardSerialId").focus();
		return false;
	}
	var HCDCode=$("#HoverCardCode").combobox("getValue");
	if (!HCDCode) {
		$.messager.popover({msg:'请选择基础数据项目',type:'error'});
		$('#HoverCardCode').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#HoverCardCode').combobox("getData"),"id",HCDCode)<0){
		$.messager.popover({msg:'请在下拉框中选择基础数据项目',type:'error'});
		$('#HoverCardCode').next('span').find('input').focus();
		return false;
	}
	var HCDName=$("#HoverCardName").val();
	if (!HCDName) {
		$.messager.popover({msg:'请输入名称描述',type:'error'});
		$("#HoverCardName").focus();
		return false;
	}
	console.log(HCDSubgroup,HCDSerialId,HCDCode,HCDName)
	var sc=$.m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"HandleHoverCardData",
		rowID:PageLogicObj.HC_SelRowId,
		subgroup:HCDSubgroup,
		serialId:HCDSerialId,
		codeDr:HCDCode,
		name:HCDName,
		hospId:$HUI.combogrid('#_HospList').getValue(),
		wardId:getSelWardId(),
		event:"SAVE"
	},false)
	if (sc==="0"){
		$("#HoverCardEditWin").window("close");
		$("#HoverCardTable").datagrid("reload");
	}else{
		if (sc==="-1") {
			$.messager.alert("提示","保存失败!");
		}else{
			$.messager.alert("提示","保存失败,"+sc);
		}
		return false;
	}
}

// 翻译
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'请选择要翻译的数据！',type:'alert'});
	}		
}
function InitDetailCardTableGrid(){
	var ToolBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			$("#DetailCardColumns").combobox("setValues","");
			$("#DetailCardEditWin").window('open');
		}
	},{
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#DetailCardTable").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
				return false;
			}
			ShowDetailCardWin(row)
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			DeleteDetailCard()
		}
	},{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
            Translate("DetailCardTable","CF.NUR.NIS.DetailCardData","DCDName","DCDItemDesc")	
        }
    }];	
	var Columns=[[    
		{ field: 'DCDRow',title:'行',width:200},
		{ field: 'DCDColumns',title:'列',width:200,
			formatter: function(value,row,index){
				var columns="";
				var data=$("#DetailCardColumns").combobox("getData");
				for (var i=0;i<value.split("^").length;i++){
					if(value.split("^")[i]=="") continue;
					var index=$.hisui.indexOfArray(data,"id",value.split("^")[i]);
					if (index>=0){
						if (columns=="") columns=data[index]["text"];
						else  columns=columns+","+data[index]["text"];
					}
				}
				return columns;
			}
		},
		{ field: 'DCDCodeName',title:'基础数据项目',width:300},
		{ field: 'DCDItemDesc',title:'项目名称',width:300},
	]];
	$('#DetailCardTable').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"RowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetDetailCardDataList",
		onBeforeLoad:function(param){
			PageLogicObj.DC_SelRowId=""
			$('#DetailCardTable').datagrid("unselectAll");
			param = $.extend(param,{
				hospId:$HUI.combogrid('#_HospList').getValue(),
				wardId:getSelWardId()
			});
		
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	})
}
function DeleteDetailCard() {
	var selected = $("#DetailCardTable").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'请选择需要删除的记录',type:'error'});
		return false;
	}
	var rowID=selected.RowID;
	var Msg="确定要删除此条基本数据吗？";
	$.messager.confirm('确认对话框', Msg, function(r){
		if (r) {
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				MethodName:"HandleDetailCardData",
				rowID:rowID,
				subgroup:'',
				serialId:'',
				codeDr:'',
				name:'',
				hospId:$HUI.combogrid('#_HospList').getValue(),
				wardId:getSelWardId(),
				event:"DELETE"
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				var QueIndex=$('#DetailCardTable').datagrid('getRowIndex',rowID);
				$('#DetailCardTable').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
function SaveDetailCardClick() {
	var DetailCardRow=$("#DetailCardRow").numberbox("getValue");
	if (!DetailCardRow) {
		$.messager.popover({msg:'请输入行！',type:'error'});
		$("#DetailCardRow").focus();
		return false;
	}
	var DetailCardColumns=$("#DetailCardColumns").combobox("getValues");
	if (DetailCardColumns.length==0) {
		$.messager.popover({msg:'请选择列！',type:'error'});
		$("#DetailCardColumns").focus();
		return false;
	}
	var DCDCode=$("#DetailCardCode").combobox("getValue");
	if (!DCDCode) {
		$.messager.popover({msg:'请选择基础数据项目',type:'error'});
		$('#DetailCardCode').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#DetailCardCode').combobox("getData"),"id",DCDCode)<0){
		$.messager.popover({msg:'请在下拉框中选择基础数据项目',type:'error'});
		$('#DetailCardCode').next('span').find('input').focus();
		return false;
	}
	var DCDName=$("#DetailCardName").val();
	if (!DCDName) {
		$.messager.popover({msg:'请输入名称描述',type:'error'});
		$("#DetailCardName").focus();
		return false;
	}
	var sc=$.m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"HandleDetailCardData",
		rowID:PageLogicObj.DC_SelRowId,
		row:DetailCardRow,
		columns:DetailCardColumns.join("^"),
		codeDr:DCDCode,
		name:DCDName,
		hospId:$HUI.combogrid('#_HospList').getValue(),
		wardId:getSelWardId(),
		event:"SAVE"
	},false)
	if (sc==="0"){
		$("#DetailCardEditWin").window("close");
		$("#DetailCardTable").datagrid("reload");
	}else{
		if (sc==="-1") {
			$.messager.alert("提示","保存失败!");
		}else{
			$.messager.alert("提示","保存失败,"+sc);
		}
		return false;
	}
}
function InitWard(){
	$('#ward').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetallWardNew&rows=99999",
		width:220,
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'wardid',
		textField:'warddesc',
		onBeforeLoad:function(param){
			param.desc="";
			param.hospid=$HUI.combogrid('#_HospList').getValue();
			param.bizTable="Nur_IP_BedChartItem";
		},loadFilter:function(data){
			return data.rows;
		},
		filter: function(q, row){
			var pyjp = getPinyin(row["warddesc"]).toLowerCase();
			return (row["warddesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onSelect:function(rec){
			wardSelectHandle();
		},
		onChange:function(newValue,oldValue){
			if (!newValue){
				FindClick();
			}
		},
		onLoadSuccess:function(){
			Init();
		}
    });
}
function getSelWardId(){
	var wardId=$('#ward').combobox("getValue");
	if ($.hisui.indexOfArray($('#ward').combobox("getData"),"wardid",wardId)<0) wardId="";
	return wardId;
}
function wardSelectHandle(){
	var oldOk = $.messager.defaults.ok;
	var oldCancel = $.messager.defaults.cancel;
	var hospId=$HUI.combogrid('#_HospList').getValue();
	var wardId=getSelWardId();
	var wardDesc=$('#ward').combobox("getText");
	new Promise(function(resolve,rejected){
	   	var bedCardItemObj=$.cm({
			ClassName:"Nur.NIS.Service.Base.BedConfig",
			QueryName:"GetBedCardItemList",
			hospId:hospId,
			wardId:wardId
		},false)
		if (bedCardItemObj.total ==0){
			var bedHospCardItemObj=$.cm({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				QueryName:"GetBedCardItemList",
				hospId:hospId,
				wardId:""
			},false)
			if (bedHospCardItemObj.total>0) {
				$.messager.defaults.ok = "引用";
				$.messager.defaults.cancel = "取消";
				$.messager.confirm('床位卡数据引用',wardDesc+ ' 该病区床位卡无配置数据,是否引用全院数据？',function(r){    
				    if (r){  
				    	copyBedCardItem(wardId,hospId);
				    }
				    $("#BedCardTable").datagrid("load");
				    resolve();
				    /*要写在回调方法内,否则在旧版下可能不能回调方法*/
					$.messager.defaults.ok = oldOk;
					$.messager.defaults.cancel = oldCancel;  
				});
				return;  
			}
		}else{
			$("#BedCardTable").datagrid("load");
		}
		resolve();
	}).then(function(){
    	return new Promise(function(resolve,rejected){
	    	var bedHoverCardItemObj=$.cm({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				QueryName:"GetHoverCardDataList",
				hospId:hospId,
				wardId:wardId
			},false)
			if (bedHoverCardItemObj.total ==0){
				var bedHospHoverCardItemObj=$.cm({
					ClassName:"Nur.NIS.Service.Base.BedConfig",
					QueryName:"GetHoverCardDataList",
					hospId:hospId,
					wardId:""
				},false)
				if (bedHospHoverCardItemObj.total>0) {
					$.messager.defaults.ok = "引用";
					$.messager.defaults.cancel = "取消";
					$.messager.confirm('床位卡悬浮内容引用',wardDesc+ ' 该病区床位卡悬浮内容无配置数据,是否引用全院数据？',function(r){    
					    if (r){  
					    	copyHoverCardItem(wardId,hospId);
					    }
					    $("#HoverCardTable").datagrid("load");
					    resolve();
					    /*要写在回调方法内,否则在旧版下可能不能回调方法*/
						$.messager.defaults.ok = oldOk;
						$.messager.defaults.cancel = oldCancel;  
					});
					return;
				}
			}else{
				$("#HoverCardTable").datagrid("load");
			}
			resolve();
		})
	}).then(function(){
    	return new Promise(function(resolve,rejected){
	    	var bedDetailItemObj=$.cm({
				ClassName:"Nur.NIS.Service.Base.BedConfig",
				QueryName:"GetDetailCardDataList",
				hospId:hospId,
				wardId:wardId
			},false)
			if (bedDetailItemObj.total ==0){
				var bedHospDetailCardItemObj=$.cm({
					ClassName:"Nur.NIS.Service.Base.BedConfig",
					QueryName:"GetHoverCardDataList",
					hospId:hospId,
					wardId:""
				},false)
				if (bedHospDetailCardItemObj.total>0) {
					$.messager.defaults.ok = "引用";
					$.messager.defaults.cancel = "取消";
					$.messager.confirm('患者详细信息引用',wardDesc+ ' 该病区患者详细信息无配置数据,是否引用全院数据？',function(r){    
					    if (r){  
					    	copyDetailCardItem(wardId,hospId);
					    }  
					    $("#DetailCardTable").datagrid("load");
					    /*要写在回调方法内,否则在旧版下可能不能回调方法*/
						$.messager.defaults.ok = oldOk;
						$.messager.defaults.cancel = oldCancel;  
					});
					return;  
				}
			}else{
				$("#DetailCardTable").datagrid("load");
			}
		})
	})
}
function copyBedCardItem(wardId,hospId){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"CopyBedBedChartItem",
		toWardId:wardId,
		fromHospId:hospId
	},false)
}
function copyHoverCardItem(wardId,hospId){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"CopyHoverCardItem",
		toWardId:wardId,
		fromHospId:hospId
	},false)
}
function copyDetailCardItem(wardId,hospId){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"CopyDetailCardItem",
		toWardId:wardId,
		fromHospId:hospId
	},false)
}