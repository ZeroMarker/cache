/// Creator: qqa
/// CreateDate: 2019-04-28
//  Descript: MDT会诊修改实际会诊医生

var CstID = "";     /// 会诊ID
var DisGrpID = "";  /// 疑难病种ID
var editIndex=-1;
var editGrpRow = -1;
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("提示","请先确定专家科室！","warning");
					return;
				}
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///设置级联指针
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				///清空医生
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 清空职称
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
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
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);

				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID;
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
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
		{field:'IsConssignIn',title:'已经签到',width:120,align:'center',hidden:true,formatter:function(value){
			if(value==1) return "√";
			if(value!=1) return "";
		}},
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		title:'组内科室',
		fit:true,
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
			
			if ((editIndex != -1)||(editIndex == 0)) { 
                $("#mainList").datagrid('endEdit', editIndex); 
            }
            
            if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            $("#LocGrpList").datagrid('beginEdit', rowIndex); 
			
            editGrpRow = rowIndex;          
        }
	};
	/// 就诊类型
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=I";
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}

// 添加科室
function AddLocWin(){
    
    if (TakGrpLocModel == 1){
	   	/// 插入空行
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
   }else{
	   var Link = "dhcmdt.makresloc.csp?DisGrpID="+DisGrpID;
	   mdtPopWin1(2, Link); /// 弹出MDT会诊处理窗口
   }
}

/// 弹出MDT会诊处理窗口
function mdtPopWin1(WidthFlag, Link){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};
	$("#mdtFrames").attr("src",Link);
	if(WidthFlag == 2){
		new WindowUX('会诊专家组', 'mdtWin', 880, 480, option).Init();
	}
}

/// 清空
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// 组内科室
		$("#LocGrpList").datagrid("reload",{"QueFlg":'','ID':''});
	}else{
		/// 院内科室
		$("#mainList").datagrid("reload",{"QueFlg":'','ID':''});
		
	}
}

function initDatagrid(){
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var HosTypeArr = [{"value":"I","text":'组内'}, {"value":"O","text":'院内'}];
	//设置其为可编辑
	var HosEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
				
				/// 清空职称
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				$(ed.target).val("");
				
				///清空医生
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				///清空科室
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocID'});
				$(ed.target).val("");
			}
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
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
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocID'});
				$(ed.target).val(option.value);

				///设置级联指针
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				/// 清空职称
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				$(ed.target).val("");
				
			},
			onShowPanel:function(){
				/// 组内
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocDesc'});
				var unitUrl = "";
				if (HosID == "I"){
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
				}else{
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID;
				}
				//var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
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
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				/// 组内
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				var GrpID = HosID=="I"?DisGrpID:"";
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID;
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'itmID',title:'ID',width:100,editor:texteditor,hidden:true},
		{field:'HosID',title:'HosID',width:100,editor:texteditor,hidden:true},
		{field:'HosType',title:'院内院外',width:110,editor:HosEditor,hidden:true},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,hidden:true},
		{field:'LocDesc',title:'科室',width:230,editor:LocEditor},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor},
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,hidden:false},
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
		{field:'IsConssignIn',title:'已经签到',width:120,align:'center',hidden:true,formatter:function(value){
			if(value==1) return "√";
			if(value!=1) return "";
		}},
		
	]];
	
		///  定义datagrid
	var option = {
		//showHeader:false,
		fit:true,
		title:'院内科室',
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		onDblClickRow: function (rowIndex, rowData) {
		
            if ((editIndex != -1)||(editIndex == 0)) { 
                $("#mainList").datagrid('endEdit', editIndex); 
            }
            $("#mainList").datagrid('beginEdit', rowIndex); 
			
            editIndex = rowIndex;
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
        }
	};
	
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=O";
	new ListComponent('mainList', columns, uniturl, option).Init();
}

function addRow(){
	commonAddRow({'datagrid':'#mainList'})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#mainList");
}

function save(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#mainList").datagrid('endEdit', editIndex); 
    }
	var LocArr = [];
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// 专家
	var CarePrvArr = [];
	var rowData = $('#LocGrpList').datagrid('getRows');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^";
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
	var rowData = $('#mainList').datagrid('getRows');
	for (var n = 0; n < rowData.length; n++){
		var item = rowData[n];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^";
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

	/// 保存
	runClassMethod("web.DHCMDTConsult","InsMakResss",{"CstID":CstID, "makLocParams":makLocParams},function(jsonString){
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

function saves(){
	var LocArr = [];
	var ConsDetArr=[];
	var rowsData = $("#mainList").datagrid('getRows');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	for(var i=0;i<rowsData.length;i++){
		if ($.inArray(rowsData[i].LocID,LocArr) == -1){
			LocArr.push(item.LocID);
		}
	} 
	saveByDataGrid("web.DHCMDTConsult","SaveItms","#mainList",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#mainList").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#mainList").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		},"",{CstID:CstID});				
}

/// 关闭
function TakClsWin(){
	
	commonParentCloseWin();
}

function cancelLocGrp(){
	
	if ($("#LocGrpList").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	var row =$("#LocGrpList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('提示','已经签到，不能删除！');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#LocGrpList').datagrid('load'); })
    }    
}); 
}

function cancel(){
	
	if ($("#mainList").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	var row =$("#mainList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('提示','已经签到，不能删除！');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#mainList').datagrid('load'); })
    }    
}); 
}

/// 删除操作
function delRow(){
	
	/// 结束编辑
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#mainList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#mainList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除行！','warning');
		return;
	}
	// 获取选中行的Index的值
	var rowIndex=$('#mainList').datagrid('getRowIndex',rowData);
    $('#mainList').datagrid('deleteRow',rowIndex);
    var rows = $('#mainList').datagrid("getRows");  //重新获取数据生成行号
    $('#mainList').datagrid("loadData", rows);
}

/// 删除操作
function delLocRow(){
	
	var rowData = $('#LocGrpList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示','请先选择待删除行！','warning');
		return;
	}
	// 获取选中行的Index的值
	var rowIndex=$('#LocGrpList').datagrid('getRowIndex',rowData);
    $('#LocGrpList').datagrid('deleteRow',rowIndex);
}

function TakPreTime(){
	
	/// 全院科室列表 结束编辑
    if ((editIndex != -1)||(editIndex == 0)) { 
        $("#mainList").datagrid('endEdit', editIndex); 
    }
    
    /// 组内科室列表 结束编辑
    if ((editGrpRow != -1)||(editGrpRow == 0)) { 
        $("#LocGrpList").datagrid('endEdit', editGrpRow); 
    }
    
	save(); 
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


