/**
 * Creator   : wk
 * Desc      : 统计项与统计内容维护
 **/


var statItemObj = $HUI.datagrid("#statItemGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		QueryName:'GetStatItem'
	},
	fitColumns:true,
	toolbar:'#statItemToobar',
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100], //设置分页可选展示条数
	
});

/*--统计项、内容新增--*/
$("#addButton").click(function(e){
	$("#addInforForm").form('reset');    //内容重置
	$("#itemType").combobox("setValue","S");
	$('#itemDim').combobox('enable');
	$('#exeCode').attr('disabled',false);
	$("#addDialog").show();
	$HUI.dialog("#addDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#addInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var dimValue,statType,code,desc,WLValue,exeCode,statFlag,itemType;
				dimValue = $("#itemDim").combobox("getValue");
				statType = $("#itemType").combobox("getValue");
				code = $("#code").val();
				desc = $("#desc").val();
				WLValue = $("#WLValue").combobox("getValue");
				exeCode = $("#exeCode").val();
				statFlag = $("#activeFlag").combobox("getValue");
				itemType = $("#itemStatType").combobox("getValue");
				if ((statType == "C")&&(dimValue != "")){
					myMsg("统计内容不能维护维度,请重新维护");
					return;
				}
				if ((WLValue == "")&&(exeCode == "")){
					myMsg("WL字段值和执行代码必须维护一个");
					return;
				}
				if ((WLValue != "")&&(exeCode != "")){
					myMsg("WL字段值和执行代码只能维护一个");
					return;
				}
				
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'AddStat',
					code:code,
					desc:desc,
					exeCode:exeCode,
					type:statType,
					WLValue:WLValue,
					dimID:dimValue,
					flag:statFlag,
					sort:itemType
				},function(e){
					$("#statItemGrid").datagrid("reload");
					myMsg(e);
					$HUI.dialog("#addDialog").close();
				})
				//alert(dimValue+"^"+statType+"^"+code+"^"+desc+"^"+WLValue+"^"+exeCode+"^"+statFlag+"^"+itemType);
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#addDialog").close();
			}
		}]
	})
})

/*--统计项、内容修改--*/
$("#modifyButton").click(function(e){
	var row = $("#statItemGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择修改的记录");
		return;
	}
	var ID = row.ID;
	var code = row.code;
	var desc = row.desc;
	var flag = row.flag;
	var typeFlag = row.typeFlag;
	$("#modifyCode").val(code);
	$("#modifyDesc").val(desc);
	$("#modifyActiveFlag").combobox("setValue",flag);
	$("#modifyItemType").combobox("setValue",typeFlag);
	$("#modifyInforForm").form('validate');
	$("#modifyDialog").show();
	$HUI.dialog("#modifyDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#modifyInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,desc,flag,typeFlag;
				code = $("#modifyCode").val();
				desc = $("#modifyDesc").val();
				flag = $("#modifyActiveFlag").combobox("getValue");
				if (flag == "是"){
					flag = "Y";
				}else if(flag == "否"){
					flag = "N";
				}
				typeFlag = $("#modifyItemType").combobox("getValue");
				if (typeFlag == "统计项"){
					typeFlag = "stat";
				}else if(typeFlag == "列表项"){
					typeFlag = "list";
				}
				//typeFlagValue = typeFlag == "统计项" ? "stat":"list";
				//alert(ID+"^"+code+"^"+desc+"^"+flagValue+"^"+typeFlagValue);
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'UpdateStatItem',
					ID:ID,
					code:code,
					desc:desc,
					flag:flag,
					itemType:typeFlag
				},function(text){
					myMsg(text);
					$("#statItemGrid").datagrid("reload");
					$HUI.dialog("#modifyDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#modifyDialog").close();
			}
		}]
	})
})

/*--维度数据--*/
var dimObj = $HUI.combobox("#itemDim",{
	url:$URL+"?ClassName=web.DHCWL.V1.CodeCFG.FunModule&QueryName=GetDimQuery&ResultSetType=array",
	valueField:'dimID',
	textField:'dimDesc',
	onHidePanel:function(){
		clearKeyWord(this);
	}
});

/*--WL字段值--*/
var WLValueObj = $HUI.combobox("#WLValue",{
	url:$URL+"?ClassName=web.DHCWL.V1.ComplexRpt.ComplexRptFun&QueryName=GetWLValue&ResultSetType=array",
	valueField:'serialNum',
	textField:'WLValue',
	onHidePanel:function(){
		clearKeyWord(this);
		var textField =  $("#WLValue").combobox("getText");
		if (textField == ""){
			$('#exeCode').attr('disabled',false);
		}
	},
	onSelect:function(record){
		if (record.WLValue == ""){
			$('#exeCode').attr('disabled',false);
		}else{
			$('#exeCode').val("");
			$('#exeCode').attr('disabled',true);
		}
	}
});


/*--统计项、内容新增类型选择--*/
$("#itemType").combobox({
	onSelect:function(record){
		if(record.value == "C"){
			$('#itemDim').combobox('clear');
			$('#itemDim').combobox('disable');
		}else{
			$('#itemDim').combobox('enable');
		}
	}
})



/*--统计项统计内容查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		statItemObj.load({ClassName:"web.DHCWL.V1.ComplexRpt.ComplexRptFun",QueryName:"GetStatItem",filterValue:value});
	}
})

/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}