/**
* @author songchunli
* HISUI 措施分类配置主js
* InterventionsType.js
*/
var PageLogicObj={
	iframeflag:"0", //2758853【护理计划配置】业务界面整合  是否是iframe 界面  1：是； 0：否

}
$(function(){
	//2758853【护理计划配置】业务界面整合
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe 界面
		InitEvent();  //需求3144838
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();  // 正常界面
		InitEvent();			
	}
});
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabInterventionsTypeList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabInterventionsTypeList").datagrid("reload");
		}
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_InterventionType");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabInterventionsTypeList").datagrid("load");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitQuestionListDataGrid();
}
function InitQuestionListDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				var Len=$("#tabInterventionsTypeList").datagrid("getRows").length;
				$("#tabInterventionsTypeList").datagrid("insertRow",{
					index: Len,
					row: {
						id:""
					}
				});
				$("#tabInterventionsTypeList").datagrid("beginEdit", Len);
				var Editors=$('#tabInterventionsTypeList').datagrid("getEditors",Len);
				$(Editors[0].target).focus();
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            SaveInterventionsType();
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
	            var selected = $("#tabInterventionsTypeList").datagrid("getSelected");
	            if (!selected) {
					$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
					return false;
				}
				var rowID=selected.id;
				if (rowID) {
					var Msg="确定要删除此条措施分类吗？";
					Msg += '</br><sapn style="opacity:0.65;">此措施分类删除后，将不会带出该分类下的所有护理措施！</sapn>';
					$.messager.confirm('提示', Msg, function(r){
						if (r) {
							DeleteQuestionGoal(rowID);
						}
					});
				}else{
					var tr = $(".datagrid-row-selected");
					var index=parseInt(tr.attr('datagrid-row-index'));
					$('#tabInterventionsTypeList').datagrid('deleteRow', index);
				}
            }
        }];
	var Columns=[[    
		{ field: 'longNameEN',title:'措施类型英文',width:150,
			editor:{
				type:'text'
			}
		},
		{ field: 'shortNameEN',title:'英文简写',width:200,
			editor:{
				type:'text'
			}
		},
		{ field: 'shortNameCN',title:'措施类型中文',width:250,wordBreak:"break-all",
			editor:{
				type:'text'
			}
		}/*,
		{ field: 'Action', title: '操作',
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteRow(this)'><img src='../scripts/dhcpha/jQuery/themes/icons/cancel.png' border=0/></a>";
				return d;
			}
		}*/
    ]];
	$('#tabInterventionsTypeList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindInterventionType",
		onBeforeLoad:function(param){
			$('#tabInterventionsTypeList').datagrid("unselectAll");
			//param = $.extend(param,{nameCN:$("#SearchDesc").val(),hospDR:$HUI.combogrid('#_HospList').getValue()});
			param = $.extend(param,{nameCN:$("#SearchDesc").val(),hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onDblClickRow:function(rowIndex, rowData){
			$("#tabInterventionsTypeList").datagrid("beginEdit", rowIndex);
			var Editors=$('#tabInterventionsTypeList').datagrid("getEditors",rowIndex);
			$(Editors[0].target).focus();
		}
	})
}
/*function DeleteRow(target){
	var Msg="确定要删除此条措施分类吗？";
		Msg += '</br><sapn style="opacity:0.65;">此措施分类删除后，将不会带出该分类下的所有护理措施！.</sapn>';
	$.messager.confirm('确认对话框', Msg, function(r){
		if (r) {
			var tr = $(target).closest('tr.datagrid-row');
			var index=parseInt(tr.attr('datagrid-row-index'));
			var rows=$('#tabInterventionsTypeList').datagrid('getRows'); //tabQuestionList
			var rowID=rows[index].id;
			if (rowID) {
				DeleteQuestionGoal(rowID);
			}else{
				$('#tabInterventionsTypeList').datagrid('deleteRow', index);
			}
		}
	});
}*/
function DeleteQuestionGoal(rowID){
	var rtn=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"DeleteInterventionType",
		rowID:rowID,
		userID:session['LOGON.USERID']
	},false)
	if (rtn !=0) {
		$.messager.popover({msg:'删除失败！',type:'error'});
		return false;
	}else{
		var QueIndex=$('#tabInterventionsTypeList').datagrid('getRowIndex',rowID);
		$('#tabInterventionsTypeList').datagrid('deleteRow', QueIndex);
	}
}
// 批量措施分类
function SaveInterventionsType(){
	var dataArray=new Array();
	var rows=$("#tabInterventionsTypeList").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var rowID=rows[i].id;
		if (!rowID) rowID="";
		var Editors=$('#tabInterventionsTypeList').datagrid("getEditors",i);
		if (Editors.length >0){
			var longNameEN=$(Editors[0].target).val();
			if (!longNameEN) {
				$.messager.popover({msg:'请输入措施类型英文!',type:'error'});
				$(Editors[0].target).focus()
				return false;
			}else if ((longNameEN.length <1)||(longNameEN.length >50)||(!longNameEN.match(/^[a-zA-Z]{1,50}$/))) {
				$.messager.popover({msg:'措施类型英文为1~50个英文字母！',type:'error'});
				$(Editors[0].target).focus()
				return false;
			}
			var shortNameEN=$(Editors[1].target).val();
			if (!shortNameEN) {
				$.messager.popover({msg:'请输入英文简写！',type:'error'});
				$(Editors[1].target).focus()
				return false;
			}else if ((shortNameEN.length <1)||(shortNameEN.length >50)||(!shortNameEN.match(/^[A-Z]{1,50}$/))) {
				$.messager.popover({msg:'英文简写为1~50个大写英文字母！',type:'error'});
				$(Editors[1].target).focus()
				return false;
			}
			var shortNameCN=$(Editors[2].target).val();
			if (!shortNameCN) {
				$.messager.popover({msg:'请输入措施类型中文！',type:'error'});
				$(Editors[2].target).focus()
				return false;
			}else if ((shortNameCN.length <1)||(shortNameCN.length >50)) {
				$.messager.popover({msg:'措施类型中文的长度为1~50个字符！',type:'error'});
				$(Editors[2].target).focus()
				return false;
			}
			dataArray.push([
				session['LOGON.CTLOCID'],
				session['LOGON.USERID'],
				rowID,
				longNameEN,
				shortNameEN,
				shortNameCN
			]);
		}
	}
	if (dataArray.length ==0){
		$.messager.popover({msg:'没有需要保存的数据！',type:'error'});
		return false;
	}
	var sc=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"BatchSaveInterventionType",
		dataArrays:JSON.stringify(dataArray),
		//hospitalDR:$HUI.combogrid('#_HospList').getValue()
		hospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},false)
	if (sc ==0){
		$("#tabInterventionsTypeList").datagrid("reload");
	}else{
		$.messager.alert("提示","保存失败!");
		return false;
	}
}
