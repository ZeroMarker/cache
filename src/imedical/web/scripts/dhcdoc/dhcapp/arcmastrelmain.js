
/// bianshuai
/// 2016-04-11
/// ҽ�������ά��
var ArcDr=""
/// �������tab�б�
var tabsObjArr = [
	{"tabTitle":"���ע������","tabCsp":"dhcapp.arcnote.csp"},
	{"tabTitle":"������Ŀ","tabCsp":"dhcapp.arcotheropt.csp"},
	{"tabTitle":"������","tabCsp":"dhcapp.arclinkdisp.csp"},
	{"tabTitle":"��λ","tabCsp":"dhcapp.arclinkpos.csp"},
	{"tabTitle":"����ϵ��","tabCsp":"dhcapp.arcdiscnew.csp"},
	//{"tabTitle":"�ಿλ�����뵥","tabCsp":"dhcapp.arcadd.csp"},
	{"tabTitle":"ҽ����λ����","tabCsp":"dhcapp.arclinktarnew.csp"}
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
	/// ��ʼ������Ĭ����Ϣ
	InitDefault();
	
	///��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	///��ʼ�����水ť�¼�
	InitWidListener();
})

/// ��ʼ������Ĭ����Ϣ
function InitDefault(){
	
	/**
	 * ҽ������
	 */
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat&HospID="+HospID;
	var arcItemCatCombobox = new ListCombobox("arcitemcat",uniturl,'');
	arcItemCatCombobox.init();
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("a:contains('��ѯ')").bind("click",queryArcItem);
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
///��ʼ�������б�
function InitDetList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'arcimid',title:'arcimid',width:100,hidden:true},
		{field:'arcitmcode',title:'����',width:100},
		{field:'arcitmdesc',title:'����',width:240}
	]];
	
	/**
	 * ����datagrid
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

/// ���ѡ�
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// �������
function createFrame(tabUrl, itmmastid){
	tabUrl = tabUrl.split("?")[0];
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?itmmastid='+ itmmastid +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

/// ��ѯҽ����ID
function queryArcItem(){
	ArcDr="";
	var arcitemdesc = $("#arcitemdesc").val();  ///ҽ��������
	var arcitemcat = $("#arcitemcat").combobox("getValue");
	if (arcitemcat==undefined){
		var arcitemcat="";
	}
	var params = arcitemdesc +"^"+ arcitemcat;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#dgMainList').datagrid("load",{"params":params,"HospID":HospID});
	tabSelect();
}
