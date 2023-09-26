/// Descript: 检查医嘱维护
/// Creator : sufan
/// Date    : 2017-02-22
var editRow = ""; editTRow = "";
var tabsObjArr = [
	{"tabTitle":"医嘱子类","tabCsp":"dhcapp.arccatnew.csp"},
	{"tabTitle":"医嘱项","tabCsp":"dhcapp.arcitmmast.csp"},
	{"tabTitle":"其它项目","tabCsp":"dhcapp.catotheropt.csp"},
	{"tabTitle":"打印模板","tabCsp":"dhcapp.prttemp.csp"}
];
var ArcDr=""

/// 页面初始化函数
function initPageDefault(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Arccat",hospStr);
	hospComp.jdata.options.onSelect = function(){
		initItmlist();
		} 
	InitDefault();
	initItmlist();       	/// 初始页面DataGrid检查分类表
	//initItmcatlist();	 	///	初始页面DataGrid医嘱子类表	qunianpeng 2018/3/19 关联将医嘱子类提取成单独的js
	initButton();          ///  页面Button绑定事件	
}


/// 初始化界面默认信息
function InitDefault(){	
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

///检查分类 
function initItmlist(){
	
	var Hospeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			editable:false,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#arccatlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#arccatlist").datagrid('getEditor',{index:editRow,field:'hospdr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"catcode",title:'分类代码',width:150,editor:textEditor},
		{field:"catdesc",title:'分类描述',width:170,editor:textEditor},
		{field:"hospdesc",title:'医院',width:200}, //,editor:Hospeditor},
		{field:"hospdr",title:'医院ID',width:40,align:'center',hidden:'true'},//editor:textEditor},
		{field:"acrowid",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#arccatlist").datagrid('endEdit', editRow); 
            } 
            $("#arccatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        ArcDr=rowData.acrowid;
			//$('#itemlist').datagrid('reload',{ItmId: rowData.acrowid});
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,rowData.acrowid)}});
	    }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryArcCat&HospID="+HospID;
	new ListComponent('arccatlist', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	///  增加检查分类
	$('#insert').bind("click",insertItemRow);
	
	///  保存检查分类
	$('#save').bind("click",saveItemRow);
	
	///  删除检查分类
	$('#delete').bind("click",deleteItmRow);
	
	///  增加医嘱子类
	///$('#insertcat').bind("click",insertcatRow);	qunianpeng 2018/3/19 关联将医嘱子类提取成单独的js
	
	///  保存医嘱子类
	///$('#savecat').bind("click",savecatRow);
	
	///  删除医嘱子类
	///$('#deletecat').bind("click",deletecatRow);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findItmlist(); //调用查询
        }
    });
    
     // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findItmlist(); //调用查询
    });
    
        $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,ArcDr)}});
		 }
	});
}

/// 插入检查项目部位行
function insertItemRow(){

	if(editRow>="0"){
		$("#arccatlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#arccatlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {acrowid: '',catcode:'',catdesc: '',hospdesc:'',hospdr:''}
	});
    
	$("#arccatlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存检查项目部位
function saveItemRow(){
	
	if(editRow>="0"){
		$("#arccatlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#arccatlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if (rowsData[i].acrowid!=""){
			var index=$("#arccatlist").datagrid('getRowIndex',rowsData[i]);
			index=index+1;
		}else{
			var index=rowsData.length-i;
		}
		if(rowsData[i].catcode==""){
			$.messager.alert("提示","第"+index+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].catdesc==""){
			$.messager.alert("提示","第"+index+"行描述为空！"); 
			return false;
		}
		/*if(rowsData[i].hospdesc==""){
			$.messager.alert("提示","第"+index+"行医院为空！"); 
			return false;
		}*/
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var tmp=rowsData[i].acrowid +"^"+ rowsData[i].catcode +"^"+ rowsData[i].catdesc +"^"+ HospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPArcCat","SaveArcCat",{"params":params},function(jsonString){
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#arccatlist').datagrid('reload'); //重新加载
		var currTab =$('#tabs').tabs('getSelected'); 
		var iframe = $(currTab.panel('options').content);
		var src = iframe.attr('src');
		$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,"")}});
	});
}

/// 删除
function deleteItmRow(){
	
	var rowsData = $("#arccatlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelArcCat",{"params":rowsData.acrowid},function(jsonString){
					if (jsonString=="-5")
					{
						$.messager.alert('提示','该分类存在关联的医嘱子类，不能删除！','warning');
						}
					if ((jsonString=="-1")||(jsonString=="-2")||(jsonString=="-3")||(jsonString=="-4"))
					{
						$.messager.alert('提示','该分类正在使用，不能删除！','warning');
						}
					$('#arccatlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询
function findItmlist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#arccatlist').datagrid('load',{params:params,HospID:HospID}); 
}	 
////==========================================医嘱子类关联维护=========================
/// 初始化医嘱子类列表 qunianpeng 2018/3/19 关联将医嘱子类提取成单独的js
/*
function initItmcatlist()
{
	var Cateditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat",
			required:true,
			panelHeight:"280",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"CatDesc",title:'医嘱子类',width:300,align:'center',editor:Cateditor},
		{field:"CatDr",title:'子类ID',width:150,align:'center',hidden:'true',editor:textEditor},
		{field:"CatLinkID",title:'ItmID',width:150,align:'center',hidden:'true',editor:textEditor}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#itemlist").datagrid('endEdit', editRow); 
            } 
            $("#itemlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryCatLink";
	new ListComponent('itemlist', columns, uniturl, option).Init();
}
/// 插入医嘱子类
function insertcatRow()
{
	var rowsData = $("#arccatlist").datagrid('getSelected');
	if (rowsData==null)
	{
		$.messager.alert("提示","请先选择检查分类！"); 
		return false;
	}
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#itemlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {CatDesc: '',CatDr:'',CatLinkID: ''}
	});
    
	$("#itemlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

///保存检查项目部位
function savecatRow(){
	
	var rowsData = $("#arccatlist").datagrid('getSelected');
	var ItmId=rowsData.acrowid;
	var HospDr=rowsData.hospdr;
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#itemlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if ((rowsData.CatDr=="")||(rowsData[i].CatDesc==""))
		{
			$.messager.alert("提示","请选择医嘱子类!");
			return false;
		}
		var tmp=rowsData[i].CatLinkID +"^"+ ItmId +"^"+ rowsData[i].CatDesc +"^"+ rowsData[i].CatDr +"^"+ HospDr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPArcCat","Save",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！');
		}
		if (jsonString=="-11")
		{
			$.messager.alert('提示','该医嘱子类已关联其他分类，请重新选择！');
			}
		$('#itemlist').datagrid('reload'); //重新加载
	});
}
/// 删除
function deletecatRow(){
	
	var rowsData = $("#itemlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelCatLink",{"CatLinkId":rowsData.CatLinkID},function(jsonString){
					$('#itemlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
*/
/// 添加选项卡
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// 创建框架
function createFrame(tabUrl, itmmastid){
	tabUrl = tabUrl.split("?")[0];
	if ((tabUrl=="dhcapp.catotheropt.csp")||(tabUrl=="dhcapp.prttemp.csp")){
		var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?cat='+ itmmastid +'" style="width:100%;height:100%;"></iframe>';
	}else{
		var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?itmmastid='+ itmmastid +'" style="width:100%;height:100%;"></iframe>';
		}
	return content;
}
function GetSelHospId(){
	return $HUI.combogrid('#_HospList').getValue();
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
