//===========================================================================================
// Author：      qunianpeng
// Date:		 2019-01-04
// Description:	 新版临床知识库-实体字典表
//===========================================================================================

var editRow = 0,editaddRow=0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var dicID="";						// 实体ID
var nodeArr=[];					
/// 页面初始化函数
function initPageDefault(){
	
	initDataList();		// 页面DataGrid初始化定义
	initattrGrid(); 	// 属性列表
	//initaddattrGrid();	// 附加属性
	initButton();		// 按钮响应事件初始化
	initCombobox();		// 初始化combobox
}

/// 页面DataGrid初始定义通用名
function initDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'Parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"知识类型",width:200,align:'left',hidden:true},
			{field:'DataType',title:"数据类型",width:200,align:'left',hidden:true},			
			{field:'Operating',title:'操作',width:380,align:'left',formatter:SetCellOperation,hidden:true}
			
		 ]]

	var option={	
		bordr:false,
		fit:true,	
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 	
 		   dicID=rowData.ID;
 		   var attr=dicID +"^"+ "LinkProp"
		   $("#attrlist").datagrid("load",{"params":attr});
		   switchMainSrc(dicID)
		   //var addattr=dicID +"^"+ extraAttr+"^"+"ExtraProp";
		   //$("#addattrlist").datagrid("load",{"params":addattr}); 
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#diclist").datagrid('endEdit', editRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            var editors = $('#diclist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#diclist").datagrid('endEdit', rowIndex);
                  });   
                  
            } 
            editRow = rowIndex; 
        }
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params="+"&drugType="+InitDrugType();
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){

	///<a href='#' onclick=\"showAuditListWin('"+a+"','"+a+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>集合</a>";
	/* var btnGroup="<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','list','"+rowData.DataType+"')\">集合</a>"; */
	var btnGroup="";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','prop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>属性</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>附加属性</a>";
	
	return btnGroup;
}

/// 属性和附加属性切换
function switchMainSrc(dicID){
	var linkUrl=""
	linkUrl = "dhcckb.addlinkattr.csp?parref="+dicID;	// 附加属性
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += '&MWToken='+websys_getMWToken(); 
	}
	$("#tabscont").attr("src", linkUrl);	

}

/// 按钮响应事件初始化
function initButton(){

	$("#insert").bind("click",insertRow);	// 增加新行
	
	$("#save").bind("click",saveEntyRow);		// 保存
	
	$("#delete").bind("click",deleteRow);	// 删除
	
	$("#find").bind("click",QueryDicList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});
	
	/// tabs 选项卡
	$("#tabs").tabs({
		onSelect:function(title){
		   	LoadattrList(title);
		}
	});
	
	///属性检索
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});
	
	///属性检索
	$('#dictreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			finddicTree(searcode);
		}
	});
	
	///实体
	$('#entityCode').searchbox({
	    searcher:function(value,name){
	   		QueryWinDicList();
	    }	   
	});
}

/// 初始化combobox
function initCombobox(){}

// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}


/// 保存编辑行
function saveEntyRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -98){
			$.messager.alert('提示','保存失败,代码重复！','warning');
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,描述重复！','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		InitPageInfo();		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

/// 删除数据
function deleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// 选中要删除的行
	
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要停用这些数据吗？", function (res) {	 // 提示是否删除
			if (res) {
				var StopDate=SetDateTime("date");
				var StopTime=SetDateTime("time");
				SetFlag="stop"        //停用数据标记
				DicName="DHC_CKBCommonDiction"
				dataid=rowsData.ID
				Operator=LgUserID
	  			runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":ClientIPAddress,"Type":'log'},function(getString){
					if (getString == 0){
						Result = "操作成功！";
					}else if(getString == -1){
						Result = "当前数据存在引用值,不允许停用";
					}else{
						Result = "操作失败！";	
					}
				},'text',false);
				$.messager.popover({msg: Result,type:'success',timeout: 1000});
				$('#diclist').datagrid('reload'); //重新加载
			}
		}); 
	}else{
		 $.messager.alert('提示','请选择要停用的项','warning');
		 return;
	}
	
	/*
	var delFlag=CheckDicLink(rowsData.ID)

	if (!delFlag){
		$.messager.alert('提示','存在子节点或者关联属性，请先删除子节点或关联属性','warning');
		return;
	}
	
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {				
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						
						$('#diclist').datagrid('reload'); //重新加载
					}else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
						 return;
					}					
				},"",false)
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
	*/
}

/// 判断是否有子节点或者关联属性
function CheckDicLink(dicID){
	
	var ret=true;
	runClassMethod("web.DHCCKBDiction","CheckDicLink",{"dicID":dicID},function(jsonString){
		if (jsonString == 0){						
				ret=false;
			}else{
				ret=true;
			}					
		},"",false);

	return ret;	
	
}
// 查询
function QueryDicList(){
	var params = $HUI.searchbox("#queryCode").getValue();
	
	$('#diclist').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params,
		drugType:InitDrugType()
	}); 
	
	dicID = ""; //重置选中项目
	$("#attrlist").datagrid("load",{});
	if ($("#tabscont")[0].contentWindow){
		$("#tabscont")[0].contentWindow.CatId = "";
		$("#tabscont")[0].contentWindow.serchAddattr();
	}

}

// 重置
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	$("#div-img").show();

}

/// 打开窗口切换（提供给子页面调用）
function OpenEditWin(linkUrl,title){

	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		maximized:true,
		maximizable:true,
		width:800,
		height:500
	});	

	$('#winmodel').html(linkUrl);
	$('#winmodel').window('open');

}
///属性列表
function initattrGrid()
{
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'code',title:'代码',width:50,hidden:true},
		{field:'desc',title:'描述',width:650}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,
		toolbar:[],
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {}	//双击选择行编辑
	};
	
	var params=dicID +"^"+ "LinkProp"

	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	new ListComponent('attrlist', columns, uniturl, option).Init();
}
///附加属性
function initaddattrGrid()
{
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var Attreditor={  
		type: 'combobox',	//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///设置级联指针
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'实体ID',width:100,editor:textEditor,hidden:true},
		{field:'DLAAttrCode',title:'属性id',width:150,editor:textEditor,hidden:true},
		{field:'DLAAttrCodeDesc',title:'附加属性',width:200,editor:textEditor},	
		{field:'DLAAttrDr',title:'属性值id',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'属性值描述',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'属性值描述',width:300,editor:textEditor},
		{field:'DLAResult',title:'备注',width:200,editor:textEditor,hidden:true}
	]];
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//单机击选择行编辑
           editaddRow=rowIndex;
        },
        onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           editaddRow=rowIndex;
           ShowAllData();
        }
	};
	
	var params=dicID +"^"+ extraAttr +"^"+"ExtraProp";
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}
function LoadattrList(title)
{  
	if (title == "属性"){ //hxy 2018-09-17 病人
		 var attr=dicID +"^"+ "LinkProp"
		 $("#attrlist").datagrid("load",{"params":attr});
	}else{
		 switchMainSrc(dicID)
	}
}
/// 数据集合（全集）
function ShowAllData(){

	var attrrow = $('#addattrlist').datagrid('getSelected');	// 获取选中的行  
	if ($g(attrrow) == ""){
		$.messager.alert('提示','请选择一个附件属性进行维护！','info');
		return;
	}
	$("#myWin").show();
	
	SetTabsInit();
      
    var myWin = $HUI.dialog("#myWin",{
        iconCls:'icon-write-order',
        resizable:true,
        title:'添加',
        modal:true,
        //left:400,
        //top:150,
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                SaveFunLib();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
	$('#myWin').dialog('center');
	$('#tabOther').tabs('select',0);  
	
	var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =(uniturl);
	$("#attrtree").tree('reload');
	
	
	$('#tabOther').tabs({
		onSelect:function(title){
			if (title == "属性"){
				var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;

				$("#attrtree").tree('options').url =(uniturl);
				$("#attrtree").tree('reload');
				
			}else if(title == "字典"){
				var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;

				$("#dictree").tree('options').url =(uniturl);
				$("#dictree").tree('reload');
				$("#entitygrid").datagrid("unselectAll");
				
			}else if (title == "实体"){			  	
				var extraAttrValue = "ModelFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";

				$("#entitygrid").datagrid('options').url =(uniturl);
				$("#entitygrid").datagrid('reload');
				$("#dicgrid").datagrid("unselectAll");	
				$("#attrtree").tree("unselectAll");	     
			}
		}
	});
}
/// 初始化tabs中的数据表格
function SetTabsInit(){

	var extraAttrValue = "AttrFlag" 	// knowledge-属性
	// 属性
	var myAttrTree = $HUI.tree("#attrtree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false     	//是否树展开折叠的动画效果		
	});
	
	var extraAttrValue = "DictionFlag" 	// knowledge-属性
	// 属性
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	var DicTree = $HUI.tree("#dictree",{
		url:uniturl, 
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,    			//是否树展开折叠的动画效果
		onClick:function(node, checked){
	    	
	    },
	    onLoadSuccess: function(node, data){
			if (node != null){
					$('#dictree').tree('expand', node.target);
			}
		}
			
	}); 
	
	// 字典
	var diccolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90]	
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('dicgrid', diccolumns, uniturl, option).Init();
  
    // 实体
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
		 ]]
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}
/// 保存
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	
	
	if (currTabTitle.indexOf("属性")!=-1){					// 选择属性
		var attrrow = $('#attrtree').tree('getSelected');	// 获取选中的行  
		selectID = $g(attrrow)==""?"":attrrow.id;
		selectDesc =  $g(attrrow)==""?"":attrrow.code;
		
	}else if(currTabTitle.indexOf("字典") != -1){				// 选择字典
	
		var dicrow =$('#dictree').tree('getSelected');	// 获取选中的行
		selectID = $g(dicrow)==""?"":dicrow.id;
		selectDesc =  $g(dicrow)==""?"":dicrow.code;
		
	}else if(currTabTitle.indexOf("实体") != -1){				// 选择实体
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // 获取选中的行  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('提示','请选择一个属性或字典或实体！','info');
		 return;	
	} 
	
	/// 附加属性界面赋值
	$('#addattrlist').datagrid('beginEdit', editaddRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
	$(attrDrObj.target).val(selectID);
	$('#addattrlist').datagrid('endEdit', editaddRow);
	saveRow();

	//$HUI.dialog("#myWin").close();
}

///保存
function saveRow()
{
	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$('#myWin').dialog('close');
				$("#addattrlist").datagrid('reload');
			}
					
		}
	)	
}
/// 删除
function DelLinkAttr(){
	var rowData = $('#addattrlist').datagrid('getSelected');	// 获取选中的行  
	if(rowData==null){
		$.messager.alert("提示","请选择附加属性！")
		return false;
	}
	removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
}

///检索属性树
function findattrTree(searcode)
{
	var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///属性清屏
function RefreshData()
{
	$HUI.searchbox("#attrtreecode").setValue("");
	var searcode=$HUI.searchbox("#attrtreecode").getValue();
	var extraAttrValue = "AttrFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///检索字典树
function finddicTree(searcode)
{
	var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
	if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	}
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
///属性清屏
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
	var extraAttrValue = "DictionFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
// 实体查询
function QueryWinDicList()
{
	var params = $HUI.searchbox("#entityCode").getValue();
	
	$('#entitygrid').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params
	}); 
}
///属性datagrid
function reloadPagedg()
{
	QueryDicList();
}

/// 药品类型
function InitDrugType(){
	
	var drugType = getParam("DrugType");	
	return drugType;

}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
