/**
* HISUI 床位右键配置主js
*/
var PageLogicObj={
	BedChartMenuType:[{"id":"0","text":"打印"},{"id":"1","text":"弹窗"},{"id":"2","text":"其他"}],
	BedChartMenuArea:[{"id":"0","text":"床位图"},{"id":"5","text":"产房床位图"},{"id":"1","text":"婴儿床位图"},{"id":"2","text":"等候区"},{"id":"3","text":"转出区"},{"id":"4","text":"出院区"}],
	WardJson:"", //所有病区json
	GroupJson:"" //安全组json
}
$(function(){ 
	InitHospList();
	InitEvent();
});
$(window).load(function() {
	$("#Loading").hide();
	InitWardJson();
	InitGroupJson();
	InitEditWindow();
	InitBedChartMenuEditWin();
})
function InitEvent(){
   $("#BSave").click(SaveBedChartMenuClick);
   $("#BCancel").click(function(){
	   $("#BedChartMenuEditWin").window('close');
   });
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_BedChartMenu");
	hospComp.jdata.options.onSelect = function(e,t){
		$.extend(PageLogicObj,{SelRowId:""});
		InitWardJson();
		InitGroupJson();
		$("#BedChartMenuList").datagrid("load");
		InitBedChartMenuEditWin();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// 初始化
	// InitWardJson();
	InitBedChartMenuDataGrid();
}
function InitWardJson(){
	PageLogicObj.WardJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardNew",
		desc:"",
		hospid:$HUI.combogrid('#_HospList').getValue(),
		bizTable:"Nur_IP_BedChartMenu",
		rows:99999
	},false)
}
function InitGroupJson(){
	PageLogicObj.GroupJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		QueryName:"GetGroupItem",
		hospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false)
}
function InitBedChartMenuDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				$("#BedChartMenuEditWin").window('open');
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
				var row = $("#BedChartMenuList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				ShowBedChartMenuEditWin(row);
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteBedChartMenuData();
            }
        },{
	        text: '翻译',
	        iconCls: 'icon-translate-word',
	        handler: function() {
	            Translate("BedChartMenuList","CF.NUR.NIS.BedChartMenu","BCMMenuName","BCMMenuName")	
	        }
	    }];
	var frozenColumns=[[
		{ field: 'BCMSubgroup',title:'分组',width:50},
		{ field: 'BCMSerialId',title:'序号',width:50},
		{ field: 'BCMMenuName',title:'菜单名称',width:200},
	]]
// 
	var Columns=[[ 
		{ field: 'BCMTypeDesc',title:'菜单类型',width:80},
		{ field: 'BCMMenuUrl',title:'链接/CSP',width:200},   
		{ field: 'BCMPara',title:'菜单参数',width:200},
		{ field: 'BCMBabyPara',title:'婴儿菜单参数',width:200},
		{ field: 'BCMIconUrl',title:'图标',width:200},
		{ field: 'BCMFormwork',title:'打印调用模板',width:200},
		//{ field: 'BCMExpression',title:'打印方法',width:200},
		{ field: 'BCMWinTop',title:'弹窗上边距',width:80},
		{ field: 'BCMWinLeft',title:'弹窗左边距',width:80},
		{ field: 'BCMWinWidth',title:'弹窗宽度',width:80},
		{ field: 'BCMWinHeight',title:'弹窗高度',width:80},
		{ field: 'BCMArea',title:'调用区域',width:200,
			formatter: function(BCMArea,row,index){
				var value="";
				var BCMAreaArr=BCMArea.split("@")
				if ((BCMAreaArr)&&(BCMAreaArr.length >0)) {
					for (var i=0;i<BCMAreaArr.length;i++){
						var index=$.hisui.indexOfArray(PageLogicObj.BedChartMenuArea,"id",BCMAreaArr[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.BedChartMenuArea[index].text;
							else  value=PageLogicObj.BedChartMenuArea[index].text;
						}
					}
				}
				return value;
			}
		},
		{ field: 'BCMWard',title:'病区',width:200,
			formatter: function(BCMWard,row,index){
				var value="";
				var BCMWardArr=BCMWard.split("@")
				if ((BCMWardArr)&&(BCMWardArr.length >0)) {
					for (var i=0;i<BCMWardArr.length;i++){
						if (BCMWardArr[i] =="") continue;
						var index=$.hisui.indexOfArray(PageLogicObj.WardJson.rows,"wardid",BCMWardArr[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.WardJson.rows[index].warddesc;
							else  value=PageLogicObj.WardJson.rows[index].warddesc;
						}
					}
				}
				return value;
			}
		},
		{ field: 'BCMGroup',title:'安全组',width:200,
			formatter: function(BCMGroup,row,index){ 
				var value="";
				var BCMGroupArr=BCMGroup.split("@")
				if ((BCMGroupArr)&&(BCMGroupArr.length >0)) {
					for (var i=0;i<BCMGroupArr.length;i++){
						if (BCMGroupArr[i] =="") continue;
						var index=$.hisui.indexOfArray(PageLogicObj.GroupJson.rows,"ID",BCMGroupArr[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.GroupJson.rows[index].Group;
							else  value=PageLogicObj.GroupJson.rows[index].Group;
						}
					}
				}
				return value;
			}
		},
		{ field: 'BCMActive', title: '状态',width:70,
			styler: function(value,row,index){
				if (value !="N"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			},
			formatter: function(value,row,index){
				if (value !="N"){
					return "启用";
				}else{
					return "停用";
				}
			}
		}
    ]];
	$('#BedChartMenuList').datagrid({  
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
		frozenColumns :frozenColumns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetBedChartMenuList",
		onBeforeLoad:function(param){
			PageLogicObj.SelRowId="";
			param = $.extend(param,{hospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowBedChartMenuEditWin(rowData);
		}
	})
}
function InitEditWindow() {
	$("#BedChartMenuEditWin").window({
		modal: true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true,
		onClose:function(){
			SetBedChartMenuEditWinData();
		}
	 });
}
function InitBedChartMenuEditWin() {
	$('#Formwork').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetXMLFomworkList&rows=99999",
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		onBeforeLoad:function(param){
			param.hospId=$HUI.combogrid('#_HospList').getValue();
			param.type="Pat";
		},loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.total;i++){
				var obj=data.rows[i];
				obj.text=obj.SPSName+"/"+obj.SPSCode;
				obj.id=obj.RowID;
				newData.push(obj);
			}
			return newData;
		}
    });
	$("#Type").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		method:'local',
		editable:false,
		data:PageLogicObj.BedChartMenuType,
		onSelect:function(rec){
			/*if (rec.id==0){
				$("#forbidRepeatPrint").checkbox("enable")
			}else{
				$("#forbidRepeatPrint").checkbox("uncheck").checkbox("disable");
			}*/
		}
	});
	$("#Area").combobox({
		valueField:'id',
		textField:'text',
		multiple:true,
		method:'local',
		data:PageLogicObj.BedChartMenuArea
	})
	$("#Ward").combobox({
		mode: "local",
		valueField:'wardid',
		textField:'warddesc',
		mode: "local",
		multiple:true,
		data:PageLogicObj.WardJson.rows
	});
	$("#Group").combobox({
		mode: "local",
		valueField:'ID',
		textField:'Group',
		mode: "local",
		multiple:true,
		data:PageLogicObj.GroupJson.rows
	});
}
function ShowBedChartMenuEditWin(row) {
	$("#BedChartMenuEditWin").panel({title:"修改床位右键配置"});
	$("#Subgroup").val(row.BCMSubgroup);
	$("#SerialId").val(row.BCMSerialId);
	$("#MenuName").val(row.BCMMenuName);
	$("#MenuUrl").val(row.BCMMenuUrl);
	$("#Para").val(row.BCMPara);
	$("#BabyPara").val(row.BCMBabyPara);
	$("#IconUrl").val(row.BCMIconUrl);
	var typeIndex=$.hisui.indexOfArray(PageLogicObj.BedChartMenuType,"text",row.BCMTypeDesc); 
	$("#Type").combobox("select",typeIndex);
	//$("#Formwork").val(row.BCMFormwork);
	$("#Formwork").combobox("setValue",row.BCMFormworkID);
	//$("#Expression").val(row.BCMExpression);
	var BCMArea=row.BCMArea;
	if (!BCMArea) {
		BCMArea=[];
	}else{
		BCMArea=BCMArea.split("@");
	}
	$("#Area").combobox("setValues",BCMArea);
	var BCMWard=row.BCMWard;
	if (!BCMWard) {
		BCMWard=[];
	}else{
		BCMWard=row.BCMWard.split("@");
	}
	var BCMGroup=row.BCMGroup;
	if (!BCMGroup) {
		BCMGroup=[];
	}else{
		BCMGroup=row.BCMGroup.split("@");
	}
	
	$("#WinTop").val(row.BCMWinTop);
	$("#WinLeft").val(row.BCMWinLeft);
	$("#WinWidth").val(row.BCMWinWidth);
	$("#WinHeight").val(row.BCMWinHeight);
	$("#Ward").combobox("setValues",BCMWard);
	$("#Group").combobox("setValues",BCMGroup);
	$("#isActive").checkbox("setValue",row.BCMActive=="N"?false:true);
	//$("#forbidRepeatPrint").checkbox("setValue",row.BCMForbidRepeatPrint=="Y"?true:false);
	PageLogicObj.SelRowId=row.RowID;
	$("#BedChartMenuEditWin").window('open');
}
function SetBedChartMenuEditWinData() {
	$("#BedChartMenuEditWin").panel({title:"新增床位右键配置"});
	PageLogicObj.SelRowId="";
	$("#Subgroup,#SerialId").numberbox("setValue","");
	$("#MenuName,#MenuUrl,#Para,#BabyPara,#IconUrl,#Formwork,#Expression,#WinTop,#WinLeft,#WinWidth,#WinHeight").val("");
	$("#Type").combobox("setValue","");
	$("#Area").combobox("setValues",[]);
	$("#Ward,#Group").combobox("setValues",[]);
	$("#isActive").checkbox("check")
}
function DeleteBedChartMenuData() {
	var selected = $("#BedChartMenuList").datagrid("getSelected");
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
				MethodName:"HandleBedChartMenu",
				rowID:rowID,
				subgroup:'',
				serialId:'',
				name:'',
				url:'',
				para:'',
				babyPara:'',
				icon:'',
				type:'',
				formwork:'',
				expression:'',
				area:'',
				top:'',
				left:'',
				width:'',
				height:'',
				ward:'',
				hospId:'',
				event:"DELETE"
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				//$("#NurseBasicDataList").datagrid("reload");
				var QueIndex=$('#BedChartMenuList').datagrid('getRowIndex',rowID);
				$('#BedChartMenuList').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
function SaveBedChartMenuClick() {
	var BCMSubgroup=$("#Subgroup").val();
	if (!BCMSubgroup) {
		$.messager.popover({msg:'请输入分组！',type:'error'});
		$("#Subgroup").focus();
		return false;
	}
	var BCMSerialId=$("#SerialId").val();
	if (!BCMSerialId) {
		$.messager.popover({msg:'请输入序号！',type:'error'});
		$("#SerialId").focus();
		return false;
	}
	var BCMMenuName=$("#MenuName").val();
	if (!BCMMenuName) {
		$.messager.popover({msg:'菜单名称！',type:'error'});
		$("#MenuName").focus();
		return false;
	}
	// 链接CSP
	var BCMMenuUrl=$("#MenuUrl").val();
	// 菜单参数
	var BCMPara=$("#Para").val();
	// 婴儿菜单参数
	var BCMBabyPara=$("#BabyPara").val();
	// 图标url
	var BCMIconUrl=$("#IconUrl").val();
	// 菜单类型
	var BCMType=$("#Type").combobox("getValue");
	if (!BCMType) {
		$.messager.popover({msg:'请选择菜单类型！',type:'error'});
		$('#Type').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#Type').combobox("getData"),"id",BCMType)<0){
		$.messager.popover({msg:'请在下拉框中选择菜单类型！',type:'error'});
		$('#Type').next('span').find('input').focus();
		return false;
	}
	var BCMFormwork=$("#Formwork").combobox("getValue");
	var BCMExpression="" //$("#Expression").val();
	var BCMArea=$("#Area").combobox("getValues");
	if (BCMArea.length === 0) {
		$.messager.popover({msg:'请选择调用区域！',type:'error'});
		$('#Area').next('span').find('input').focus()
		return false;
	}
	var BCMWard=$("#Ward").combobox("getValues");
	var BCMWinTop=$("#WinTop").val();
	var BCMWinLeft=$("#WinLeft").val();
	var BCMWinWidth=$("#WinWidth").val();
	var BCMWinHeight=$("#WinHeight").val();
	var BCMGroup=$("#Group").combobox("getValues");
	//var BCMForbidRepeatPrint=$("#forbidRepeatPrint").checkbox("getValue")?"Y":"N"
	var sc=$.m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"HandleBedChartMenu",
		rowID:PageLogicObj.SelRowId,
		subgroup:BCMSubgroup,
		serialId:BCMSerialId,
		name:BCMMenuName,
		url:BCMMenuUrl,
		para:BCMPara,
		babyPara:BCMBabyPara,
		icon:BCMIconUrl,
		type:BCMType,
		formwork:BCMFormwork,
		expression:BCMExpression,
		area:BCMArea.join("@"),
		top:BCMWinTop,
		left:BCMWinLeft,
		width:BCMWinWidth,
		height:BCMWinHeight,
		ward:BCMWard.join("@"),
		hospId:$HUI.combogrid('#_HospList').getValue(),		
		event:"SAVE",
		group:BCMGroup.join("@"),
		active:$("#isActive").checkbox("getValue")?"Y":"N"
		//forbidRepeatPrint:BCMForbidRepeatPrint
	},false)
	if (sc==="0"){
		$("#BedChartMenuEditWin").window("close");
		$("#BedChartMenuList").datagrid("reload");
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