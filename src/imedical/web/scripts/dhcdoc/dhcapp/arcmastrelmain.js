
/// bianshuai
/// 2016-04-11
/// 医嘱项关联维护
var ArcDr=""
/// 定义界面tab列表
var tabsObjArr = [
	{"tabTitle":"检查注意事项","tabCsp":"dhcapp.arcnote.csp"},
	{"tabTitle":"其他项目","tabCsp":"dhcapp.arcotheropt.csp"},
	{"tabTitle":"后处理方法","tabCsp":"dhcapp.arclinkdisp.csp"},
	{"tabTitle":"体位","tabCsp":"dhcapp.arclinkpos.csp"},
	{"tabTitle":"打折系数","tabCsp":"dhcapp.arcdiscnew.csp"},
	//{"tabTitle":"多部位及申请单","tabCsp":"dhcapp.arcadd.csp"},
	{"tabTitle":"医嘱部位关联","tabCsp":"dhcapp.arclinktarnew.csp"}
 ];

$(function(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Arcmastrelmain",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat&HospID="+HospID;
		var arcItemCatCombobox = new ListCombobox("arcitemcat",uniturl,'');
		arcItemCatCombobox.init();
		$("#arcitemdesc").val(""); 
		queryArcItem();
	} 
	/// 初始化界面默认信息
	InitDefault();
	
	///初始化咨询信息列表
	InitDetList();
	
	///初始化界面按钮事件
	InitWidListener();
})

/// 初始化界面默认信息
function InitDefault(){
	
	/**
	 * 医嘱子类
	 */
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat&HospID="+HospID;
	var arcItemCatCombobox = new ListCombobox("arcitemcat",uniturl,'');
	arcItemCatCombobox.init();
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

/// 界面元素监听事件
function InitWidListener(){

	$("a:contains('查询')").bind("click",queryArcItem);
	$("#arcitemdesc").bind('keypress',function(event){
        if(event.keyCode == "13"){
            queryArcItem();
        }
    });
    $("#tabs").tabs({
	    onSelect:function(title,index){
		    tabSelect();
		}
	});
}
function tabSelect(){
	var currTab =$('#tabs').tabs('getSelected'); 
	var iframe = $(currTab.panel('options').content);
	var src = iframe.attr('src');
	$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,ArcDr)}});
}
///初始化病人列表
function InitDetList(){
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'arcimid',title:'arcimid',width:100,hidden:true},
		{field:'arcitmcode',title:'代码',width:100},
		{field:'arcitmdesc',title:'描述',width:240}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        ArcDr=rowData.arcimid;
	        tabSelect();
	    },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
		/*	if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);				
			}
		*/    //qunianpeng  2016-07-15	
		}
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=QueryArcItemList&HospID="+HospID;
	var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	dgMainListComponent.Init();
}

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
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?itmmastid='+ itmmastid +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

/// 查询医嘱项ID
function queryArcItem(){
	ArcDr="";
	var arcitemdesc = $("#arcitemdesc").val();  ///医嘱项名称
	var arcitemcat = $("#arcitemcat").combobox("getValue");
	if (arcitemcat==undefined){
		var arcitemcat="";
	}
	var params = arcitemdesc +"^"+ arcitemcat;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#dgMainList').datagrid("load",{"params":params,"HospID":HospID});
	tabSelect();
}
