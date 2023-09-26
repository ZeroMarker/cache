/**
 * 健康管理师维护  dhchm.dhchmdoctor.js
 * @Author   wangguoying
 * @DateTime 2019-06-18
 */


var HDDataGrid=$HUI.datagrid("#HDList",{
		url:$URL,
		title:"",
		bodyCls:'panel-body-gray',
		queryParams:{
			ClassName:"web.DHCHM.BaseDataSet",
			QueryName:"GetDoctor",
		},
		onSelect:function(rowIndex,rowData){
			$("#HDID").val(rowData.ID);
			$("#Doctor").combogrid("setValue",rowData.DCode);
			$("#DocDesc").val(rowData.DDesc);
			$("#DocType").combobox("setValue",rowData.Dtype);
			if(rowData.DActive=="Y"){
				$("#DActive").checkbox("check");
			}else{
				$("#DActive").checkbox("uncheck");
			}
			
		},
		onDblClickRow:function(index,row){
																	
		},	
		columns:[[
			{field:'ID',hidden:true,sortable:'true'},
			{field:'DCode',width:'200',title:'编码'},
			{field:'DShort',width:'250',title:'用户名'},
			{field:'DDesc',width:'320',title:'健康管理师名称'},
			{field:'Dtype',width:'200',title:'人员类型'},
			{field:'DActive',width:'150',title:'激活',align:"center",
			formatter:function(value,row,index){
					var checked=value=="Y"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
			}}
		]],
		singleSelect:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});

function find_click(){
	var Doctor=$("#Doctor").combogrid("getValue");
	var DocType=$("#DocType").combobox("getValue");
	var DActive="N";
	if($("#DActive").checkbox("getValue")){
		DActive="Y";
	}
	HDDataGrid.load({ClassName:"web.DHCHM.BaseDataSet",QueryName:"GetDoctor",Code:Doctor,Type:DocType,Active:DActive});
}

function init(){
	setLayoutSize();
}
function setLayoutSize(){
	var dHeight=$(document).height();
	$("#TabDiv").height(dHeight-160);
	$("#HDList").datagrid("resize");
	$("#HDList").datagrid('getPanel').css("border-radius",0)// 去掉表格圆角样式
}


function clean_click(){
	$("#HDID").val("");
	$("#Doctor").combogrid("setValue","");
	$("#DocDesc").val("");
	$("#DocType").combobox("setValue","");
	$("#DActive").checkbox("uncheck");
}
/**
 * 保存
 * @Author   wangguoying
 * @DateTime 2019-06-18
 */
function save_click(){
	var HDID=$("#HDID").val();
	var Doctor=$("#Doctor").combogrid("getValue");
	var DocDesc=$("#DocDesc").val();
	var DocType=$("#DocType").combobox("getValue");
	var DActive="N";
	if($("#DActive").checkbox("getValue")){
		DActive="Y";
	}
	if(Doctor==""||Doctor==undefined){
		$.messager.alert("提示","医生不能为空","info");
		return false;
	}
	if(DocType==""||DocType==undefined){
		$.messager.alert("提示","人员类型不能为空","info");
		return false;
	}
	var property = "DActive^DCode^DDesc^DRemark^Dtype";
	var valList = DActive+"^"+Doctor+"^"+DocDesc+"^^"+DocType;
	try{
		var ret=tkMakeServerCall("web.DHCHM.BaseDataSet","DoctorSave",HDID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");      	
            HDDataGrid.load({ClassName:"web.DHCHM.BaseDataSet",QueryName:"GetDoctor"});
            clean_click();
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	} 
}
$(init);