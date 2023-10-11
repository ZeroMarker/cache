//名称	dhcpe.ct.endangeritem.js
//功能	系统配置 - 职业病体检 - 危害因素 - 检查项目
//创建	2021-08-06
//创建人  zhongricheng
var tableName = "DHC_PE_EDItem";
var sessionStr = session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function(){
	
	InitCombobox();
	
	InitEDItemGrid();
	
	InitEDItemDetailGrid();
	
	//修改
	$("#update_btn").click(function() {
		BUpdate_click();
	});
	
	//新增
	$("#add_btn").click(function() {
		BAdd_click();
	});
	
    //删除
	//$("#del_btn").click(function() {
	//	BDel_click();
	//});
	
	/*
	// 科室授权
	$("#BRelateLoc").click(function() {
		BRelateLoc();
	});
	*/
	
    //清屏
	$("#BClear").click(function() {	
		BClear_click();
	});
	
 	//细项维护
 	$("#Detail_btn").click(function() {	
		BDetail_click();
	});
	
	//保存
	$("#saveDetail_btn").click(function() {
		BSaveDetail_Click();
	});
});

//修改
function BUpdate_click() {
	BSave_click("1");
}

//新增
function BAdd_click() {
	BSave_click("0");
}

function BSave_click(Type) {
	var Parref = $.trim(selectrow);
	if (Parref == "") {
		$.messager.alert("提示", "未获取到危害因素ID", "error");
		return false;
	}
	var ID = $("#ID").val();
	if (Type == "1") {
		if (ID == "") {
			$.messager.alert("提示", "请选择待修改的记录", "error");
			return false;
		}
	}
	
	if (Type == "0") {
		if (ID != "") {
			$.messager.alert("提示", "新增数据不能选中记录,请点击清屏后进行新增", "error");
			return false;
		}
	}
	
	var SetsFlag = "N";
	
	var ArcimDesc = $("#ArcimDesc").combogrid("getValue");
	if (ArcimDesc == undefined || ArcimDesc == "undefined") ArcimDesc = "";
	
	var SetsDesc = $("#SetsDesc").combogrid('getValue');
	if (SetsDesc == undefined || SetsDesc == "undefined") SetsDesc = "";
	
	if (ArcimDesc == "" && SetsDesc == "") {
		$.messager.alert("提示", "请选择检查项目或套餐", "error");
		return false;
	} else if (ArcimDesc != "" && SetsDesc != "") {
		$.messager.alert("提示", "检查项目或套餐不能都选择", "error");
		return false;
	} else if (ArcimDesc != "") {
		var ret = tkMakeServerCall("web.DHCPE.DHCPECommon", "IsArcItem", ArcimDesc);
		if (ret == "0") {
			$.messager.alert("提示","请选择检查项目","error");
			return false;
		}
	} else if (SetsDesc != "") {
		SetsFlag = "Y";
		ArcimDesc = SetsDesc;
		var ret = tkMakeServerCall("web.DHCPE.DHCPECommon", "IsSets", SetsDesc);
		if (ret == "0") {
			$.messager.alert("提示", "请选择套餐", "error");
			return false;
		}
	}
	
	var ExpInfo = $("#ExpInfo").val();
	var Remark = $("#Remark").val();
	var NeedFlag = $("#NeedFlag").checkbox('getValue')?"Y":"N";
	var Active = $("#Active").checkbox('getValue')?"Y":"N";
	var OMETypeDR = $("#OMEType").combogrid('getValue');
	if (OMETypeDR == undefined || OMETypeDR == "undefined") OMETypeDR = "";
	
	var Str = OMETypeDR + "^" + ArcimDesc + "^" + SetsFlag + "^" + NeedFlag + "^" + Active + "^" + ExpInfo + "^" + Remark + "^" + tableName;
	
	$.cm({
		ClassName:"web.DHCPE.CT.EndangerItem",
		MethodName:"SaveEndangerItem",
		Parref:Parref,
		ID:ID,
		InfoStr:Str,
		LocId:$("#LocList").combobox('getValue'),
		USERID:session["LOGON.USERID"]
	}, function(jsonData){
		if (jsonData.success == 0) {
			$.messager.alert("提示", jsonData.msg, "error");
		} else if (jsonData.code == "-1") {
			$.messager.alert("提示", jsonData.msg, "error");
		} else {
			if (Type=="1") $.messager.popover({msg:'修改成功！', type:'success', timeout:2000});
			if (Type=="0") $.messager.popover({msg:'新增成功！', type:'success', timeout:2000});
			BClear_click();
		}
	});
}

//删除
function BDel_click() {
	var ID = $("#ID").val();
	if (ID == "") {
		$.messager.alert("提示", "请选择待删除的记录", "info");
		return false;
	}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			$.m({
				ClassName:"web.DHCPE.CT.EndangerItem",
				MethodName:"DeleteEndangerItem",
				ID:ID
			}, function(ReturnValue) {
				if (ReturnValue.split("^")[0] == '-1') {
					$.messager.alert("提示","删除失败","error");  
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClear_click();
				}
			});	
		}
	});
}

/*
//科室授权
function BRelateLoc() {
	var ID = $("#ID").val();
	if (ID == "") {
		$.messager.alert("提示", "请选择需要授权的记录", "info");
		return false;
	}
	
	var LocID = $("#LocList").combobox("getValue");
	OpenLocWin(tableName, ID, sessionStr, LocID, function(){ BClear_click(); });
}
*/

function BClear_click() {
	
	var HospID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$("#LocList").combobox('getValue'))
	
	$("#ID,#ExpInfo,#Remark,#ArcimID").val("");
	$(".hisui-checkbox").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	$HUI.validatebox("#Code,#Desc", { required: false});
	
	$("#EDItemGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.EndangerItem",
		QueryName:"SearchEndangerItem",
		Parref:$.trim(selectrow),
		LocID:$("#LocList").combobox('getValue'),
		HospID:HospID
	});
	
	loadEDItemDetaill("");	
}

function InitCombobox(){
	
	//科室
	var LocListObj = $("#LocList").combobox({
        panelHeight: "auto",
        //width: 358,
        url: $URL + '?ClassName=web.DHCPE.CT.DHCPEMappingLoc&QueryName=GetLocDataForCombo&ResultSetType=array&SessionStr=' + sessionStr,
        method: 'get',
        valueField: 'LocRowId',
        textField: 'LocDesc',
        editable: false,
        blurValidValue: true,
        onLoadSuccess: function(data) {
            $("#LocList").combobox('select', session['LOGON.CTLOCID']);
        },
        onChange: function(newValue, oldValue) {
			BClear_click();
			ArcimDescObj.clear();
			$('#ArcimDesc').combogrid('grid').datagrid('reload');	
		  	SetsDescObj.clear();
		  	$('#SetsDesc').combogrid('grid').datagrid('reload');	
		    
		}
    });
   
	//项目描述
	var ArcimDescObj =$HUI.combogrid("#ArcimDesc", {
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=StationOrderList",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Item = param.q;
			param.LocID = $("#LocList").combobox('getValue');
			param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$("#LocList").combobox('getValue'));
			
		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',hidden: true},
			{field:'STORD_ARCIM_Code',title:'编码',width:80},
			{field:'STORD_ARCIM_Desc',title:'名称',width:180},
			{field:'STORD_ARCIM_Price',title:'价格',width:100},
			{field:'TUOM',title:'单价',hidden: true},
			{field:'TLocDesc',title:'科室',width:100}		
		]]
	});
	
	var EndangeInfo=tkMakeServerCall("web.DHCPE.Endanger","GetOneEndangerInfo",$.trim(selectrow));
	var EndangerTypeID=EndangeInfo.split("^")[5];
	var EndangerTypeInfo=tkMakeServerCall("web.DHCPE.Endanger","GetOneEndangerTypeInfo",EndangerTypeID);
	var VIPType=EndangerTypeInfo.split("^")[3];


	//套餐描述
	var SetsDescObj = $HUI.combogrid("#SetsDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'OrderSetId',
		textField:'OrderSetDesc',
		onBeforeLoad:function(param){
			param.Set = param.q;
			param.Type = "ItemSet";
			param.LocID=$("#LocList").combobox('getValue');
			param.hospId=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$("#LocList").combobox('getValue'));
			param.VIPType=VIPType;
		},
		columns:[[
		    {field:'OrderSetId',title:'ID',hidden: true},
			{field:'OrderSetDesc',title:'名称',width:250},
			{field:'IsBreakable',title:'是否拆分',hidden: true},
			{field:'OrderSetPrice',title:'价格',width:100}
		]]
	});
		
	//检查种类
	var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'ID',
		textField:'OMET_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'OMET_Code',title:'代码',width:80},
			{field:'OMET_Desc',title:'描述',width:180},
			{field:'OMET_VIPLevel',title:'VIP等级',width:100}	
		]]
	});
}


function InitEDItemGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var HospID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID)
	
	$HUI.datagrid("#EDItemGrid",{
		url:$URL,
		border:false,
		striped:true,
		fit:true,
		fitColumns:false,
		autoRowHeight:false,
		pagination:true,  
		rownumbers:true,  
		pageSize:25,
		pageList:[25,50,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.EndangerItem",
			QueryName:"SearchEndangerItem",
			Parref:$.trim(selectrow),
			LocID:LocID,
			HospID:HospID
		},
		columns:[[
		    {field:'TID',title:'TID',hidden: true},
		    {field:'TArcimID',title:'TArcimID',hidden: true},
			{field:'TOMETypeDR',title:'TOMETypeDR',hidden: true},
			{field:'TArcimCode',width:120,title:'项目编码'},
			{field:'TArcimDesc',width:200,title:'项目描述'},
			{field:'TNeedFlag',width:60,title:'必选',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TSetsFlag',width:80,title:'是否套餐',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TOMEType',width:150,title:'检查种类'},
			{field:'TActive',width:60,title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TExpInfo',width:130,title:'扩展信息'},
			{field:'TRemark',width:100,title:'备注'}
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ID").val(rowData.TID);
			if (rowData.TSetsFlag == "是") {
				$("#SetsDesc").combogrid("grid").datagrid("reload",{"q":rowData.TArcimDesc});
				
				$("#SetsDesc").combogrid("setValue",rowData.TArcimID);
				$("#ArcimDesc").combogrid("setValue","");
			} else {
				$("#ArcimDesc").combogrid("grid").datagrid("reload",{"q":rowData.TArcimDesc});
				
				$("#ArcimDesc").combogrid("setValue",rowData.TArcimID);
				$("#SetsDesc").combogrid("setValue","");
			}
			
			$("#OMEType").combogrid("setValue",rowData.TOMETypeDR);
			$("#ExpInfo").val(rowData.TExpInfo);
			$("#Remark").val(rowData.TRemark);
			
			$("#Active").checkbox("setValue",rowData.TActive=="是"?true:false);
			$("#NeedFlag").checkbox("setValue",rowData.TNeedFlag=="是"?true:false);
			
			$("#EDItemDetailGrid").datagrid("loadData", {total:0, rows:[]});
			loadEDItemDetaill(rowData);
		}
	});
}

/*****************************************细项维护界面*************************/

function loadEDItemDetaill(rowData) {
	$("#EDItemDetailGrid").datagrid("load", {
		ClassName:"web.DHCPE.CT.EndangerItem",
		QueryName:"SearchEndangerItmDetail",
		Parref:rowData.TID,
		LocID:$("#LocList").combobox('getValue')
	});
	
	$("#ParRef").val(rowData.TID);
	$("#ParARCIMDR").val(rowData.TArcimID);
}

function InitEDItemDetailGrid(){
	$HUI.datagrid("#EDItemDetailGrid",{
		url:$URL,
		fit:true,
		border:false,
		striped:true,
		fitColumns:false,
		autoRowHeight:false,
		rownumbers:true,
		pagination:true,
		pageSize:25,
		pageList:[25,50,100,200],
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect:false,
		checkOnSelect:true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck:true,
		queryParams:{
			ClassName:"web.DHCPE.CT.EndangerItem",
			QueryName:"SearchEndangerItmDetail"
		},
		columns:[[
			{field:'Select', title:'选择', width:70, checkbox:true},
		    {field:'TID', title:'TID', hidden:true},
		    {field:'TODRowId', title:'TODRowId', hidden:true},
			{field:'TODCode', title:'细项编码', width:100},
			{field:'TODDesc', title:'细项描述', width:180}
			
			// TActive TExpInfo TRemark TUpdDate TUpdTime TUpdUser TUpdUserName
		]],
		onLoadSuccess:function(rowData) {
			$.each(rowData.rows, function(index, row) {
				if (row.TActive == "Y") {
					$("#EDItemDetailGrid").datagrid("checkRow", index);//如果数据行为已选中则选中改行
				}
			});
		}
	});
}

//保存
function BSaveDetail_Click() {
	var Parref = $("#ParRef").val();
	if (Parref == "") {
		$.messager.alert("提示", "请选择需要操作的项目", "info");
		return false;
	}
	
	var ErrInfo = "", SuccessNum = 0;
	
	var checkrows = $("#EDItemDetailGrid").datagrid("getChecked");  //获取的是数组，多行数据
	var rows = $("#EDItemDetailGrid").datagrid("getRows");  //获取的是数组，多行数据
	for (var i = 0; i < rows.length; i++) {
		var ID = rows[i].TID;
		var ODRowId = rows[i].TODRowId;
		var Active = "N";
		for (var j = 0; j < checkrows.length; j++) {
			if (checkrows[j].TID == ID) {
				Active = "Y";
				break;
			}
		}
		var ExpInfo = rows[i].TExpInfo;
		var Remark = rows[i].TRemark;
		
		var Str = ODRowId + "^" + Active + "^" + ExpInfo + "^" + Remark;
		
		var jsonData = $.cm({
			ClassName:"web.DHCPE.CT.EndangerItem",
			MethodName:"UpdEndangerItmDetail",
			Parref:Parref,
			ID:ID,
			InfoStr:Str,
			LocId:$("#LocList").combobox('getValue'),
			USERID:session["LOGON.USERID"]
		}, false);
		
		if (jsonData.success == 0) {
			ErrInfo = ErrInfo + jsonData.msg + "  ";
		} else if (jsonData.code == "-1") {
			ErrInfo = ErrInfo + jsonData.msg + "  ";
		} else {
			SuccessNum++;
		}
	}
	if (ErrInfo != "") {
		$.messager.alert("提示", "保存失败！" + ErrInfo, "error");
	} else {
		$.messager.popover({msg:'保存成功！', type:'success', timeout:2000});
	}
 }