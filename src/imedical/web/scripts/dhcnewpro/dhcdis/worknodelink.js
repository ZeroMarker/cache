
/** sufan 
  * 2018-04-09
  *
  * ҽ�������ά��
 */
var NodeDr=""  ;  // ��λId
/// �������tab�б�

var tabsObjArr = [
	//{"tabTitle":"����λ��","tabCsp":"dhcdis.worklocation.csp"},
	{"tabTitle":"��������","tabCsp":"dhcdis.worktype.csp"},
	{"tabTitle":"��λ��Ա","tabCsp":"dhcdis.workuser.csp"},
	{"tabTitle":"������","tabCsp":"dhcdis.nodelinksergro.csp"}
	];

function initPageDefault(){
	
	initDefaultInfo();	/// ��ʼ������Ĭ����Ϣ
	initNodeList();		/// ��ʼ������datagrid
	initButton();  		/// ��ʼ���¼�
}

/// ��ʼ������Ĭ����Ϣ
function initDefaultInfo(){
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

/// ��ʼ������datagrid
function initNodeList()
{
	
	// ����columns
	var columns=[[
		{field:"NodeCode",title:'��λ����',width:220,align:'center'},
		{field:"NodeDesc",title:'��λ����',width:220,align:'center'},
		{field:"NodeRowId",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  ����datagrid  
	var option = {
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			NodeDr = rowData.NodeRowId;
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,rowData.NodeRowId)}});
	    }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNode&MethodName=QueryDisNode";
	new ListComponent('nodelist', columns, uniturl, option).Init(); 
}
/// ��ʼ���¼�
function initButton(){

    $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,NodeDr)}});
		   }
	 });
	
	///  ��ѯ
	$('#find').bind("click",findNodeist);
	
		//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findNodeist(); //���ò�ѯ
        }
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findNodeist(); //���ò�ѯ
    }); 
}

/// ���ѡ�
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// �������
function createFrame(tabUrl, NodeDr){
	tabUrl = tabUrl.split("?")[0];
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?NodeDr='+ NodeDr +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

/// ��ѯ
function findNodeist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#nodelist').datagrid('load',{params:params}); 
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })