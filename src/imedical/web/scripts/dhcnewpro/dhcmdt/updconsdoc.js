/// Creator: qqa
/// CreateDate: 2019-04-28
//  Descript: MDT会诊修改实际会诊医生

var CstID = "";     /// 会诊ID
var DisGrpID = "";  /// 疑难病种ID
var editIndex=-1;
var editGrpRow = -1;
var editExpRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var LType = "CONSULT";  /// 会诊科室代码
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
$(function(){
	initParams();
	
	initDatagrid();
	
	InitLocGrpGrid();
	
	/// 初始化页面datagrid
	InitOuterExpGrid();
})

function initParams(){
	
	CstID = getParam("ID");     /// 会诊ID
	DisGrpID = getParam("DisGrpID");  /// 疑难病种ID
}

/// 初始化科室组列表
function InitLocGrpGrid(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("提示","请先确定专家科室！","warning");
					return;
				}
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///设置级联指针
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	// 科室编辑格
	var LocEditor={
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				///清空医生
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 清空职称
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				return true;
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
		
	// 医师编辑格
	var DocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			mode:'remote',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);

				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				//var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID;
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val();
				}
			}
		}
	}
	
	///  定义columns
     var columns=[[
		{field:'itmID',title:'ID',width:100,align:'center',hidden:true},
		{field:'LocID',title:'科室ID',width:100,hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:230,editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,editor:DocEditor},
		{field:'PrvTpID',title:'职称ID',width:100,hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:160,hidden:false,editor:PrvTpEditor},
		{field:'AcceptFlag',title:'接收',width:100,align:'center',formatter:
			function (value, row, index){
				if (value == 1){
					return '<font style="color:green;font-weight:bold;">是</font>';
				}else {
					return '<font style="color:red;font-weight:bold;">否</font>';
				}
			}
		},
		{field:'RefReason',title:'回复意见',width:530},
		{field:'IsConssignIn',title:'已经签到',width:120,align:'center',hidden:false,formatter:function(value){
			if(value==1) return "√";
			if(value!=1) return "";
		}},
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		title:'院内专家',
		fit:true,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
			
			if ((editIndex != -1)||(editIndex == 0)) { 
                $("#bmDocList").datagrid('endEdit', editIndex); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            var isConssignIn = rowData.IsConssignIn;
			if(isConssignIn==1){
				$.messager.alert('提示','已经签到，不能修改！');
				return;
			}
            
            $("#bmDocList").datagrid('beginEdit', rowIndex); 
			
            editIndex = rowIndex;          
        }
	};
	/// 就诊类型
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=ListDocList&ID="+CstID+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDocList', columns, uniturl, option).Init();
}

/// 清空
function Clear(FlagCode){
	
}

function initDatagrid(){
	
	
}

function addRow(){
	commonAddRow({'datagrid':'#bmDocList'})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#bmDocList");
}

function save(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
	var LocArr = [];
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+ item.itmID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var n = 0; n < rowData.length; n++){
		var item = rowData[n];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+ item.itmID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}	
			
	if ((memControlFlag == 1)&(LocArr.length < 3)){
		$.messager.alert("提示:","会诊专家组成员不允许少于3人！","warning");
		return;	
	}
	
	if (TmpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	/// 科室
	var makLocParams = ConsDetArr.join("@");
	if (makLocParams == ""){
		$.messager.alert("提示:","会诊科室不能为空！","warning");
		return;	
	}
	
	/// 外院专家
	var repExpArr = [];
	var LocExpArr = [];
	var OuterExpList = "";
	var rowData = $('#OuterExpList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone;
			LocExpArr.push(TmpData);
		    if ($.inArray(item.UserID, repExpArr) == -1){
				repExpArr.push(item.UserID);
			}else{
				TmpCarePrv = item.UserName;
			}
		}
	})
	if (TmpCarePrv != ""){
		$.messager.alert("提示","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	var makOuterExp = LocExpArr.join("@");	

	/// 保存
	runClassMethod("web.DHCMDTConsult","InsMakResss",{"CstID":CstID, "makLocParams":makLocParams, "makOuterExp":makOuterExp},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待安排状态，不允许进行安排操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","保存成功！","success",function(){
				TakClsWin(); /// 关闭
			});
		}
	},'',false)			
}

/// 关闭
function TakClsWin(){
	
	commonParentCloseWin();
}

function cancelLocGrp(){
	
	if ($("#bmDocList").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	var row =$("#bmDocList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('提示','已经签到，不能删除！');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#bmDocList').datagrid('load'); })
    }    
}); 
}

function cancel(){
	
	if ($("#bmDocList").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	var row =$("#bmDocList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('提示','已经签到，不能删除！');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#bmDocList').datagrid('load'); })
    }    
}); 
}

/// 删除操作
function delGrpRow(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除行！','warning');
		return;
	}
	// 获取选中行的Index的值
	var rowIndex=$('#bmDocList').datagrid('getRowIndex',rowData);
    $('#bmDocList').datagrid('deleteRow',rowIndex);
    var rows = $('#bmDocList').datagrid("getRows");  //重新获取数据生成行号
    $('#bmDocList').datagrid("loadData", rows);
}

/// 删除操作
function delLocRow(){
	
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除行！','warning');
		return;
	}
	
	var itmID = rowData.itmID;
	
	$cm({
		"ClassName":"web.DHCMDTConsult",
		"MethodName":"DeletConsItm",
		"CstItmID":itmID,
		"dataType":"text"
	},function(ret){
		if(ret!=0){
			$.messager.alert('提示',ret,'warning');
			return;	
		}else{
			$("#bmDocList").datagrid("reload");	
		}
	})
	
}

function TakPreTime(){
	
	/// 全院科室列表 结束编辑
    if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
    /// 外院专家列表 结束编辑
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }
    
	save(); 
}

/// 初始化外院专家列表
function InitOuterExpGrid(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 编辑格
	var numbereditor={
		type: 'numberbox',//设置编辑格式
		options: {
			//required: true //设置编辑规则属性
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	/// 科室
	var LocEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCMDTDicItem&MethodName=jsonParDicItem&mCode=OutLoc&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'LocID',title:'科室ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'科室',width:200,align:'left',editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,align:'left',hidden:true,editor:texteditor},
		{field:'UserName',title:'医生',width:120,align:'left',editor:texteditor},
		{field:'TelPhone',title:'联系方式',width:100,align:'left',editor:numbereditor},
		{field:'PrvTpID',title:'职称ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'职称',width:160,align:'left',hidden:false,editor:PrvTpEditor}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		title:'外院专家',
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		border:true,
		bodyCls:'panel-header-gray',
	    onClickRow: function (rowIndex, rowData) {
			
			if (rowData.ID) return;
		
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            $("#OuterExpList").datagrid('beginEdit', rowIndex); 
			
            editExpRow = rowIndex;
            return;
		  
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpOutDet&mdtIDs="+CstID+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}

/// 插入空行
function insExpRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={ID:'', UserID:'', UserName:''};
	$("#OuterExpList").datagrid('appendRow',rowObj);
}

 /// 删除行
function delOutExpRow(rowIndex, id){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#OuterExpList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除行！','warning');
		return;
	}
	
	/// 保存
	runClassMethod("web.DHCMDTConsult","DeleteOuterExpert",{"ID":rowData.ID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","删除失败，失败原因:"+jsonString,"warning");
		}else{
			$('#OuterExpList').datagrid("reload");
		}
	},'',false)
	
	return;
	
	// 获取选中行的Index的值
	var rowIndex=$('#OuterExpList').datagrid('getRowIndex',rowData);
    $('#OuterExpList').datagrid('deleteRow',rowIndex);
    var rows = $('#OuterExpList').datagrid("getRows");  //重新获取数据生成行号
    $('#OuterExpList').datagrid("loadData", rows);
}

/**
 * 保存datagrid数据
 * @creater qqa:重写
 * @param className 类名称
 * @param methodName 方法名
 * @param gridid datagrid的id
 * @param handle 回调函数
 * @param 返回值类型
 * saveByDataGrid("web.DHCAPPPart","find","#datagrid",function(data){ alert() },"json")	 
 */
function saveByDataGrid(className,methodName,gridid,handle,datatype,parObj){

	if(!endEditing(gridid)){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var paramsObj={}
	paramsObj.Params = dataList.join("$$");
	paramsObj=$.extend(paramsObj,parObj);
	runClassMethod(className,methodName,paramsObj,handle,datatype);
}


/// 外院专家快捷方式
function shortcut_selOuterExp(){
	
	if (DisGrpID == "") {
		$.messager.alert("提示","疑难病种不能为空！","warning");
		return;
	}
	
	var Link = "dhcmdt.makresloc.csp?DisGrpID="+ DisGrpID +"&Type=E"+"&MWToken="+websys_getMWToken();
	mdtPopWin1(3, Link); /// 弹出MDT会诊处理窗口

}

/// 插入空行
function insRow(){
    var rowObj={itmID:'', LocID:'', LocDesc:'', UserID:'', UserName:'', PrvTpID:'', PrvTp:'', AcceptFlag:'', RefReason:'', IsConssignIn:''};
	$("#bmDocList").datagrid('appendRow',rowObj);
}


/// 删除操作
function delRow(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除！','warning');
		return;
	}
	
	var rowIndex=$('#bmDocList').datagrid('getRowIndex',rowData);
	if(!rowData.itmID){
		$('#bmDocList').datagrid('deleteRow',rowIndex);
		return;
	}
	
	$cm({
		"ClassName":"web.DHCMDTConsult",
		"MethodName":"DeletConsItm",
		"CstItmID":rowData.itmID,
		"dataType":"text"
	},function(ret){
		if(ret!=0){
			$.messager.alert('提示',ret,'warning');
			return;	
		}else{
			$("#bmDocList").datagrid("reload");	
		}
	})
}

/// 保存行
function saveRow(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }

	/// 人员重复检查
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	if (TmpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var LocArr=[]; isEmptyFlag=0;
	var rowData = $('#bmDocList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+"^"+item.itmID;
		    LocArr.push(TmpData);
		}
		if (item.UserID == "") isEmptyFlag = 1;
	}
	
	if (isEmptyFlag == 1){
		$.messager.alert("提示","专家不能为空！","warning");
		return;	
	}
	
	/// 外院人员重复检查
	var TmpExpCarePrv = ""; /// 专家
	var CareExpPrvArr = [];
	var rowData = $('#OuterExpList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// 人员重复检查
			var masIndex=item.LocID+","+item.PrvTpID+","+item.UserName;
			if ($.inArray(masIndex, CareExpPrvArr) != -1){
				TmpExpCarePrv = item.UserName;
			}
			CareExpPrvArr.push(masIndex);
		}
	}
	if (TmpExpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpExpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var LocExpArr=[]; isExpEmptyFlag=0;
	var rowData = $('#OuterExpList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone +"^"+ item.ID;
		    LocExpArr.push(TmpData);
		}
		if (item.UserName == "") isExpEmptyFlag = 1;
	}
	
	if (isExpEmptyFlag == 1){
		$.messager.alert("提示","外院专家姓名不能为空！","warning");
		return;	
	}
	
	
	/// 科室
	var mLocParams = LocArr.join("@");
	/// 外院科室
	var makOuterExp = LocExpArr.join("@");	
	
	if ((mLocParams == "")&&(makOuterExp=="")){
		$.messager.alert("提示","未检查到待增加记录！","warning");
		return;	
	}
	
	/// 保存
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":CstID, "mLocParams":mLocParams,"makOuterExp":makOuterExp},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","保存成功！","success",function(){
				$("#bmDocList").datagrid('reload');
				$("#OuterExpList").datagrid("reload");
			});
		}
	},'',false)
}

///保存专家
function saveLoc(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
   
	/// 人员重复检查
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// 人员重复检查
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	if (TmpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var LocArr=[]; isEmptyFlag=0;
	var rowData = $('#bmDocList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+"^"+item.itmID;
		    LocArr.push(TmpData);
		}
		if (item.UserID == "") isEmptyFlag = 1;
	}
	
	if (isEmptyFlag == 1){
		$.messager.alert("提示","专家不能为空！","warning");
		return;	
	}
	
	/// 科室
	var mLocParams = LocArr.join("@");

	if (mLocParams == ""){
		$.messager.alert("提示","未检查到待增加记录！","warning");
		return;	
	}
	
	/// 保存
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":CstID, "mLocParams":mLocParams,"makOuterExp":""},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","保存成功！","success",function(){
				$("#bmDocList").datagrid('reload');
			});
		}
	},'',false)
}

///保存外院专家
function saveOuterLoc(){
	
	if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }
	
	/// 外院人员重复检查
	var TmpExpCarePrv = ""; /// 专家
	var CareExpPrvArr = [];
	var rowData = $('#OuterExpList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// 人员重复检查
			var masIndex=item.LocID+","+item.PrvTpID+","+item.UserName;
			if ($.inArray(masIndex, CareExpPrvArr) != -1){
				TmpExpCarePrv = item.UserName;
			}
			CareExpPrvArr.push(masIndex);
		}
	}
	if (TmpExpCarePrv != ""){
		$.messager.alert("提示:","会诊专家："+ TmpExpCarePrv +"，重复添加！","warning");
		return;	
	}
	
	var LocExpArr=[]; isExpEmptyFlag=0;
	var rowData = $('#OuterExpList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone +"^"+ item.ID;
		    LocExpArr.push(TmpData);
		}
		if (item.UserName == "") isExpEmptyFlag = 1;
	}
	
	if (isExpEmptyFlag == 1){
		$.messager.alert("提示","外院专家姓名不能为空！","warning");
		return;	
	}
	
	/// 外院科室
	var makOuterExp = LocExpArr.join("@");	
	
	if (makOuterExp == ""){
		$.messager.alert("提示","未检查到待增加记录！","warning");
		return;	
	}
	
	/// 保存
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":CstID, "mLocParams":"","makOuterExp":makOuterExp},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示","保存成功！","success",function(){
				$("#OuterExpList").datagrid("reload");
			});
		}
	},'',false)
}