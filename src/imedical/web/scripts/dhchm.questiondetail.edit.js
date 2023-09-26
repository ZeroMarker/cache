/**
 * 调查问卷基本内容维护  dhchm.questiondetail.edit.js
 * @Author   wangguoying
 * @DateTime 2019-03-29
 */
 
 
$.extend($.fn.validatebox.defaults.rules, {
	checkQDCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.QuestionDetailSet',MethodName:'CheckQDCodeExist',Code:value};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '代码已存在'
	}
});
 
 
var detailDataGrid;
var optionDataGrid;
var init = function(){

	$("#PCode").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			findBtn_onclick();
		}
	});
	$("#PDesc").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			findBtn_onclick();
		}
	});

	detailDataGrid = $HUI.datagrid("#DetailList",{
		url:$URL,
		title:"",
		bodyCls:'panel-body-gray',
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"FindQDetail",
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				optionClear();
				var p = detailDataGrid.getPanel();
				p.find("#editIcon").linkbutton("enable",false);
				optionDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDOption",ParRef:rowData.QDID});
				if((rowData.QDType=="M")||(rowData.QDType=="S")){
					$("#LockDiv").hide();
					$("#OpParf").val(rowData.QDID);
					$("#OpParfType").val(rowData.QDType);
				} else{
					$("#LockDiv").show();
				}  
			}
		},
		onDblClickRow:function(index,row){
			detailEdit(row);														
		},	
		columns:[[
			{field:'QDID',hidden:true,sortable:'true'},
			{field:'QDOperation',width:50,title:'操作',align:'center',
				formatter:function(value,row,index){
					return "<a href='#' onclick='openDSetsWin(\""+row.QDID+"\",\""+row.QDType+"\")'>\
					<img style='padding-top:4px;' title='套餐关联度维护' alt='套餐关联度维护' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_link_pen.png' border=0/>\
					</a>";

				}
                        
			},
			{field:'QDCode',width:100,title:'编码'},
			{field:'QDDesc',width:200,title:'描述'},
			{field:'QDType',width:80,title:'类型',
				formatter:function(value,row,index){
					var dispalyTxt="";
					switch (value){
						case "T":
							dispalyTxt="说明型";
							break;
						case "N":
							dispalyTxt="数值型";
							break;
						case "D":
							dispalyTxt="日期型";
							break;
						case "S":
							dispalyTxt="单选型";
							break;
						case "M":
							dispalyTxt="多选型";
							break;
					}
					return dispalyTxt;
				}
			},
			{field:'QDUnit',width:60,title:'单位'},
			{field:'QDSex',width:60,title:'性别',
				formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='男';
               		}
                	if (value == 'F') {
                    	dispalyTxt='女';
               		}
               		if (value == 'N') {
                    	dispalyTxt='不限';
                	}
                	return dispalyTxt;
				}
			},
			{field:'QDLinkCode',width:60,title:'关联码'},
			{field:'QDElementNum',width:50,title:'列数'},
			{field:'QDActive',width:50,title:'激活',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDRequired',width:50,title:'必填',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDRemark',width:100,title:'备注'},
			{field:'QDNote',hidden:true,width:80,title:'提示'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true,
		toolbar:[
		{
			iconCls:'icon-add',
			text:'新增',
			handler:function(){
				detailClear();
				$("#DetailEditWin").window("open");
			}
		},{
			iconCls:'icon-edit',
			text:'编辑',
			disabled:true,
			id:'editIcon',
			handler:function(){
				var rows = detailDataGrid.getSelections();
				if (rows.length>1){
					$.messager.alert("提示","编辑模式不可多选","info");
				}else if (rows.length==1){
					detailEdit(rows[0]);
				}else{
					$.messager.alert("提示","请选择要编辑的数据","info");
				}
			}
		}]
	});
	optionDataGrid = $HUI.datagrid("#OptionList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"FindQDOption",
		},
		onSelect:function(rowIndex,rowData){
			$("#OpID").val(rowData.QDOID);
			$("#OpDesc").val(rowData.QDODesc);
			$("#OpSeq").val(rowData.QDOOrder);
			$("#OpSex").combobox("setValue",rowData.QDOSex);
			if(rowData.QDODefault=="true"){
				$("#OpDefault").checkbox("check");
			}else{
				$("#OpDefault").checkbox("uncheck");
			}
			if(rowData.QDONote=="true"){
				$("#OpNote").checkbox("check");
			}else{
				$("#OpNote").checkbox("uncheck");
			}
			if(rowData.QDOActive=="true"){
				$("#OpActive").checkbox("check");
			}else{
				$("#OpActive").checkbox("uncheck");
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QDOID',hidden:true,sortable:'true'},
			{field:'QDOOperation',width:'80',title:'操作',
				formatter:function(value,row,index){
					return "<a href='#' onclick='openDOLinkDWin(\""+row.QDOID+"\")'>\
					<img   title='关联问题维护' alt='关联问题维护' style='margin-left:8px;padding-top:4px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/adm_add.png' border=0/>\
					</a>\
					<a href='#' onclick='openDOSetsWin(\""+row.QDOID+"\")'>\
					<img   title='套餐关联度维护' alt='套餐关联度维护' style='margin-left:8px;padding-top:4px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_link_pen.png' border=0/>\
					</a>";

				}
			},
			{field:'QDODesc',width:'140',title:'描述'},
			{field:'QDOSex',width:'60',title:'性别',
				formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='男';
               		}
                	if (value == 'F') {
                    	dispalyTxt='女';
               		}
               		if (value == 'N') {
                    	dispalyTxt='不限';
                	}
                	return dispalyTxt;
				}
			},
			{field:'QDOOrder',width:'60',title:'序号'},
			{field:'QDODefault',width:'60',title:'默认',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDONote',width:'80',title:'允许备注',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDOActive',width:'60',title:'激活',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		pagination:true,
		pageSize:20,
		fit:true,
		displayMsg:"",
		rownumbers:true
	});
	setGridHeight();
}

/**
 * 问卷内容查询按钮点击事件
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function findBtn_onclick(){
	var PCode=$("#PCode").val();
	var PDesc=$("#PDesc").val();
	var PActive=$("#PActive").checkbox("getValue");
	detailDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDetail",Code:PCode,Desc:PDesc,Active:PActive});
}
/**
 * 问卷内容清屏按钮点击事件
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function clearBtn_onclick(){
	$("#PCode").val("");
	$("#PDesc").val("");
}

/**
 * 编辑文件卷基本内容
 * @param    {[object]}    rowObj [选中行数据]
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function detailEdit(rowObj){
	$("#DID").val(rowObj.QDID);
	$("#DDesc").val(rowObj.QDDesc);
	$("#DCode").val(rowObj.QDCode);
	$("#DType").combobox("setValue",rowObj.QDType);
	$("#DUnit").val(rowObj.QDUnit);
	$("#DSex").combobox("setValue",rowObj.QDSex);
	$("#DLinkCode").val(rowObj.QDLinkCode);
	$("#DColNum").val(rowObj.QDElementNum);
	if(rowObj.QDActive=="true"){
		$("#DActive").checkbox("check");
	}else{
		$("#DActive").checkbox("uncheck");
	}
	if(rowObj.QDRequired=="true"){
		$("#DRequired").checkbox("check");
	}else{
		$("#DRequired").checkbox("uncheck");
	}
	$("#DRemark").val(rowObj.QDRemark);
	$("#DetailEditWin").window("open");
}

/**
 * 问卷内容保存按钮点击事件
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function detailSave(){
	var QDID=$("#DID").val();
	var QDDesc=$("#DDesc").val();
	var QDCode=$("#DCode").val();
	var QDType=$("#DType").combobox("getValue");
	var QDUnit=$("#DUnit").val();
	var QDSex=$("#DSex").combobox("getValue");
	var QDLinkCode=$("#DLinkCode").val();
	var QDColNum=$("#DColNum").val();
	var QDActive="N";
	var QDRequired="N";
	if($("#DActive").checkbox("getValue")){
		QDActive="Y";
	}
	if($("#DRequired").checkbox("getValue")){
		QDRequired="Y";
	}
	var QDRemark=$("#DRemark").val();
	if(QDCode==""){
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	if((QDID=="")&&(!$("#DCode").validatebox("isValid"))){
		$.messager.alert("提示","编码已存在","info");
		return false;
	}
	if(QDDesc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var property = 'QDCode^QDDesc^QDType^QDUnit^QDSex^QDLinkCode^QDElementNum^QDActive^QDRequired^QDRemark';
	var valList = QDCode+"^"+QDDesc+"^"+QDType+"^"+QDUnit+"^"+QDSex+"^"+QDLinkCode+"^"+QDColNum+"^"+QDActive+"^"+QDRequired+"^"+QDRemark;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDSave",QDID,valList,property);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("错误","保存失败："+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");
        	detailClear();
            $("#DetailEditWin").window("close");
            detailDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDetail",Code:QDCode});
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}
/**
 * 选项保存
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function optionSave()
{
	var QDOParRef=$("#OpParf").val();
	var OpParfType=$("#OpParfType").val();
	var OpID=$("#OpID").val();
	if((QDOParRef=="")||(OpID=="")){
		$.messager.alert("提示","请先选中要保存的数据行","info");
		return false;
	}
	var QDODesc=$("#OpDesc").val();
	if(QDODesc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var QDOOrder=$("#OpSeq").val();
	var QDOSex=$("#OpSex").combobox("getValue")
	var QDODefault="N";
	if($("#OpDefault").checkbox("getValue")){
		QDODefault="Y";
	}
	var QDONote="N";
	if($("#OpNote").checkbox("getValue")){
		QDONote="Y";
	}
	var QDOActive="N";
	if($("#OpActive").checkbox("getValue")){
		QDOActive="Y";
	}
	var property = 'QDOActive^QDODefault^QDODesc^QDOOrder^QDOParRef^QDOSex^QDONote';
	var valList=QDOActive+"^"+QDODefault+"^"+QDODesc+"^"+QDOOrder+"^"+QDOParRef+"^"+QDOSex+"^"+QDONote;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOSave",OpID,valList,property,OpParfType,QDODefault,QDOParRef);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("错误","保存失败："+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");
        	optionClear();
            optionDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDOption",ParRef:QDOParRef});
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}

/**
 * 问卷内容窗口清空
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function detailClear(){
	$("#OpParf").val("");
	$("#DID").val("");
	$("#DDesc").val("");
	$("#DCode").val("");
	$("#DType").combobox("setValue","T");
	$("#DUnit").val("");
	$("#DSex").combobox("setValue","N");
	$("#DLinkCode").val("");
	$("#DColNum").val("");
	$("#DActive").checkbox("setValue",false);
	$("#DRequired").checkbox("setValue",false);
	$("#DRemark").val("");
}

/**
 * 选项维护清空
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function optionClear(){
	//$("#OpParf").val("");
	//$("#OpParfType").val("");
	$("#OpID").val("");
	$("#OpDesc").val("");
	$("#OpSeq").val("");
	$("#OpSex").combobox("setValue","");
	$("#OpDefault").checkbox("uncheck");
	$("#OpNote").checkbox("uncheck");
	$("#OpActive").checkbox("uncheck");
}

/**
 * 设置DataGrid高度
 * @Author   wangguoying
 * @DateTime 2019-03-29
 */
function setGridHeight()
{
	$("#GridDiv").height($("#ContentDiv").height()-51);
	$("#DetailList").datagrid("resize");
	$("#OpGridDiv").height($("#OptionDiv").height()-171);	
	$("#OptionList").datagrid("resize");
}

/**
 * 打开问题关联维护窗口
 * @param    {[String]}    OID [选项ID]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
var openDOLinkDWin = function(OID){
	if($("#OpParfType").val()=="M"){
		$.messager.alert("提示","非单选型问题不能维护关联关系","info");
		return false;
	}
	//window.open("dhchm.dolinkdetail.edit.csp?OID="+OID);
	$HUI.window("#DOLinkDetailWin",{
		title:"关联问题维护",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:500,
		height:400,
		content:'<iframe src="dhchm.dolinkdetail.edit.csp?OID='+OID+'" width="100%" height="100%" frameborder="0" ></iframe>'
	}).center();
};
/**
 * 打开问题关联套餐维护窗口
 * @param    {[String]}    DID [问题ID]
 *  * @param    {[String]}    DType [问题类型]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
var openDSetsWin = function(DID,DType){
	if((DType=="M")||(DType=="S")){
		$.messager.alert("提示","选择型问题请在右侧选项页面维护","info");
		return false;
	}
	$HUI.window("#DLOrdSetsWin",{
		title:"关联套餐维护",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:600,
		height:500,
		content:'<iframe src="dhchm.queslinkordersets.csp?DID='+DID+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
};
/**
 * 打开选项关联套餐维护窗口
 * @param    {[String]}    OID [选项ID]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
var openDOSetsWin = function(OID){
	$HUI.window("#DLOrdSetsWin",{
		title:"关联套餐维护",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:600,
		height:500,
		content:'<iframe src="dhchm.optionlinkordersets.csp?OID='+OID+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
};

$(init);