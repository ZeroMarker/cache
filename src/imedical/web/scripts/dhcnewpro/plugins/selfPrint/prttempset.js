/**
 *��ӡģ��
**/
var formNameID="",HospDr="";
function initPageDefault(){
    InitHosp(); 	//��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
	initCombobx();
	initDatagrid();
	
}
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_PRTMain"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue();
		$("#reportType").combobox('setValue',""); 
		reloadAllItmTable(""); 
		var url='dhcapp.broker.csp?ClassName=web.DHCADVEXPFIELD&MethodName=getRepType&HospDr='+HospDr;
		$("#reportType").combobox('reload',url);  
		$("#dataframe")[0].contentWindow.queryPrtTempTable();
	}
	$("#_HospBtn").bind('click',function(){
		var rowData =$("#dataframe")[0].contentWindow.GetSelectData() ;
		if (!rowData){
			$.messager.alert("��ʾ","��ѡ��һ�У�")
			return false;
		}
		GenHospWin("DHC_PRTMain",rowData.MARowID);
	})
	
}
function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			formNameID = option.value;
			reloadAllItmTable(option.value);
	    }
	};
	
	var url = uniturl+"getRepType&HospDr="+HospDr;
	new ListCombobox("reportType",url,'',option).init();	
	
	$('#search').searchbox({
		searcher : function (value, name) {
			search($.trim(value));
		}
	});
	
	var option = {
		valueField:'value',
		textField:'text',
		editable:false,
		data:[
			{
				"value":1,
				"text":"�����¼�"
			},{
				"value":2,
				"text":"����ϵͳ"
			},
		],
		onSelect:function(option){
			reloadReportTypeCombobox(option.value);
	    }
	};
	
	new ListCombobox("printType","","",option).init();
	$("#printType").combobox("setValue",1);	
}

function reloadReportTypeCombobox(value){
	var url="";
	if(value==1) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=getRepType&HospDr="+HospDr;
	if(value==2) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=getRepTypeNew";
	$("#reportType").combobox({
		url:url	
	})
	$('#allItmTable').datagrid('loadData', { total: 0, rows: [] });
	return;
}

function initDatagrid(){
	
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:80,hidden:true},
		{field:'DicField',title:'DicField',width:120,hidden:true},
		{field:'DicDesc',title:'ȫ����',width:160}
	]];
	
	
	$HUI.datagrid('#allItmTable',{
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=QueryAllItmByFormID",
		fit:true,
		border:false,
		autoSizeColumn:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		showHeader:false,
		rownumbers : true,
		showPageList : false,
	    onClickRow: function (rowIndex, rowData) {
		    var moreItmFlag=$HUI.checkbox("#moreId").getValue()?1:0;
       		$("#dataframe")[0].contentWindow.setSelItmID(rowData.DicField,rowData.DicDesc,moreItmFlag);
        },
		onLoadSuccess:function(data){
			$('.pagination-page-list').hide();
            $('.pagination-info').hide();
		}
	})
	
	$('#allItmTable').datagrid('getPager').pagination({ showRefresh: false});  
}
//reload ���ϱ�
function reloadAllItmTable(value){
	var url="";
	var printType = $("#printType").combobox("getValue");	
	if(printType==1) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=QueryAllItmByFormID";
	if(printType==2) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=QueryAllItmByFormID";
	
	$("#allItmTable").datagrid({
		url:url,
		queryParams:{
			ForNameID:value,
			Input:''
		}
	})
}

function search(input)
{
	$("#allItmTable").datagrid('load',{
		ForNameID:formNameID,
		Input:input
	})
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
