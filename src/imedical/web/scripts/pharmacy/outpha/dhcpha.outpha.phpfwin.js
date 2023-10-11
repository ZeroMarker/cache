/**
 * 模块:    门诊药房
 * 子模块:  药房配发窗口关联
 * 编写日期:2017-11-23
 * 编写人:  yunhaibao
 */
var HospId=session['LOGON.HOSPID'];
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
$(function(){
	InitHospCombo();
	InitDict();	
	InitGrid();
	$("#btnClear").on('click',ClearHandler);
	$("#btnAdd").on('click',AddHandler);
	$("#btnDelete").on('click',DeleteHandler);
	$("#btnSearch").on('click',SearchHandler);
});

function InitDict(){
	var options={
		width:'auto',
		editable:false ,
		panelWidth:'auto',
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+"&HospId="+HospId,
		onSelect:function(selData){  
			var selLocId=selData.RowId;
			/// 级联-配药窗口
			var secOptions={
				editable:false ,
				width:'auto',
				panelWidth:'auto',
				url:commonOutPhaUrl+'?action=GetPYWinList&gLocId='+selLocId,	
			};
			$("#cmbPyWin").dhcphaEasyUICombo(secOptions);	
			/// 级联-发药窗口
			var secOptions={
				editable:false ,
				ClassName:"web.DHCOutPhCode",
				QueryName:"GetFyWinDict",
				StrParams:selLocId		
			}
			$("#cmbFyWin").dhcstcomboeu(secOptions);	
		}  
	}
	$('#cmbPhLoc').dhcphaEasyUICombo(options);		 
}

function InitGrid(){
	var gridColumns=[[
		{field:'TLocDesc',title:$g("药房名称"),width:250},
		{field:'TPyWinDesc',title:$g("配药窗口"),width:250},
		{field:'TFyWinDesc',title:$g("发药窗口"),width:250},
		{field:'TPhlid',title:$g("门诊药房ID"),width:200,hidden:true},
		{field:'TPyWinID',title:$g("配药窗口ID"),width:200,hidden:true},
		{field:'TPhwid',title:$g("发药窗口ID"),width:200,hidden:true},
		{field:'TLocId',title:$g("科室ID"),width:200,hidden:true}
	]];
	
	var options={
		ClassName:'web.DHCOutPhCode',
		QueryName:'FindPhPYWinSub',
     	queryParams:{
			StrParams:""+"|@|"+HospId
		},
		fitColumns:true,
        columns:gridColumns,
        singleSelect:true,
        striped:true,
        toolbar:"#btnbar"  
	}
	$('#grid-pfwin').dhcstgrideu(options);	
}

function SearchHandler(){
	var locId=$("#cmbPhLoc").combobox('getValue');
	$('#grid-pfwin').datagrid({
     	queryParams:{
			StrParams:locId+"|@|"+HospId
		}
	});
}
function AddHandler(){
	var locId=$("#cmbPhLoc").combobox('getValue');
	if(locId==""){
		$.messager.alert($g("提示"),$g("药房名称不能为空!"),"warning");
		return;
	}
	var fyWinId=$("#cmbFyWin").combobox('getValue');
	if(fyWinId==""){
		$.messager.alert($g("提示"),$g("发药窗口不能为空!"),"warning");
		return;
	}
	var pyWinId=$("#cmbPyWin").combobox('getValue');
	if(pyWinId==""){
		$.messager.alert($g("提示"),$g("配药窗口不能为空!"),"warning");
		return;
	}
	var saveRet=tkMakeServerCall("web.DHCOutPhCode","insertPhPyFyWin",locId,fyWinId,pyWinId);
	if(saveRet==0){
		$.messager.alert($g("成功提示"),$g("增加成功!"),"info");
		$("#grid-pfwin").datagrid('reload');
	}else if(saveRet==-1){
		$.messager.alert($g("提示"),$g("您选择的发药窗口已经关联!"),"warning");
	}else{
		$.messager.alert($g("错误提示"),$g("增加失败,错误代码:")+saveRet,"error");
	}
}

function ClearHandler(){
	$("#cmbPhLoc").combobox('setValue',"");
	$("#cmbPyWin").combobox('setValue',"");
	$("#cmbFyWin").combobox('setValue',"");
	$("#cmbPyWin").combobox('loadData', {});
	$("#cmbFyWin").combobox('loadData', {});
	$('#grid-pfwin').datagrid({
     	queryParams:{
			StrParams:""+"|@|"+HospId
		}
	});
}

function DeleteHandler(){
	var seletcted = $("#grid-pfwin").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert($g("提示"),$g("请先选中需删除的记录!"),"warning");
		return;
	}
	$.messager.confirm($g("提示"),$g("您确认删除吗？"),function(r){
		if(r){
			var pfWinId=seletcted.TPyWinID;
			var delRet=tkMakeServerCall("web.DHCOutPhCode","DeletePyFyWin",pfWinId);
			if(delRet==0){
				$.messager.alert($g("成功提示"),$g("删除成功!"),"info");
				$("#grid-pfwin").datagrid('reload');
			}else{
				$.messager.alert($g("错误提示"),$g("删除失败,错误代码:")+delRet,"error");
			}
		}
	});
}

function InitHospCombo(){
	var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'PHA-OP-PreDispWin'}); //加载医院
	if (typeof genHospObj === 'object') {
		//增加选择事件
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#cmbPhLoc').combobox('loadData',[]);
				$('#cmbPhLoc').combobox('options').url=commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+'&HospId='+HospId;
				$('#cmbPhLoc').combobox('reload');
				$('#cmbPyWin').combobox('loadData',[]);	
				$('#cmbFyWin').combobox('loadData',[]);	
				ClearHandler();				
			}
		};
	}
}