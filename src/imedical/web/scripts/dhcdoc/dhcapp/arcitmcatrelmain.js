/// zhouxin
/// 2016-04-11
/// ҽ���������ά��
var cat="" //����catȫ�ֱ���
/// �������tab�б�
var tabsObjArr = [
	{"tabTitle":"������Ŀ","tabCsp":"dhcapp.catotheropt.csp"},
	{"tabTitle":"��ӡģ��","tabCsp":"dhcapp.prttemp.csp"},
	///{"tabTitle":"��λ","tabCsp":"dhcapp.catlinkpart.csp"},
	///{"tabTitle":"�໤����","tabCsp":"dhcpha.clinical.pharcaremonlevel.csp"},
	];

$(function(){
	///��ʼ�����水ť�¼�
	InitWidListener();
})

$(function(){
//��������һ���س��¼�
$('#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //queryAdrPatImpoInfo(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
           commonQuery(); //���ò�ѯ 
                    
        }
    });

// ���Ұ�ť�󶨵����¼�
$('#find').bind('click',function(event){
         commonQuery(); //���ò�ѯ
    })
    
//���ð�ť�󶨵����¼�
$('#reset').bind('click',function(event){
		$('#desc').val("");
		commonQuery(); //���ò�ѯ
	})		
	
})
///��ѯ
function commonQuery()
{
	//alert(params)
	$('#datagrid').datagrid('load',{
			desc:$.trim($('input[name="desc"]').val())
		
		})
	
	//$.messager.alert("��ʾ","��ѯû��Ӧ111������")
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
    //tab�¼�
    $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,cat)}});
		    }
		    });
}
///get iframe from frames 
function getTabWindow() {
	var curTabWin = null;
	var curTab = $('#tabs').tabs('getSelected');
	if (curTab && curTab.find('iframe').length > 0) {
		curTabWin = curTab.find('iframe')[0].contentWindow;
	}
	return curTabWin;
}
$(function(){
    ///huaxiaoying 2016-05-17 ���ƹ���
    $("#copy").on('click', function() {    
		var row = $("#datagrid").datagrid('getSelected'); 
	    if (row==null) {
		    $.messager.alert("��ʾ","��ѡһ��������!");
		    return;
		    }
		$('#detail').dialog('open');
		$('#detail').dialog('move',{
				left:280,
				top:180
			});
	    $('#detailgrid').datagrid({  
	    	
	    	url:LINK_CSP+'?ClassName=web.DHCAPPCommonUtil&MethodName=QueryArcCatList',
	    	    method:'get',
	    	    fit:true,
	    	    loadMsg:'����������.....',
	    	    pagination:true,
	    	    fitColumns:true,
	    	    rownumbers:true,
	    	    //onClickRow:detailonClickRow,
	    	    onDblClickRow:onDblClickRow,
	    	    columns:[[ 
			            {field:'ACCatCode',title:'����',width:100},
			            {field:'ACCatDesc',title:'����',width:120},
			            {field:'ID',title:'id',hidden:true,width:50}
	    	  	        ]]
	    	  	
		    });   
 	}); //���ƹ���END
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
	
   
})

///���ƹ��ܵ���
function onDblClickRow(rowIndex, rowData){
	$.messager.confirm('ȷ��','��ȷ�Ͻ��Ը���Ϊģ����',function(r){    
    if (r){
	    var currRow =$('#detailgrid').datagrid('getSelected'); 
	    if(rowData.ID==cat){
		$.messager.alert("��ʾ","��ͬ!���ø��ƣ�");
		return;
		}else{
	         runClassMethod(
	 				"web.DHCAPPCatLinkPart",
	 				"SaveCopy",
	 				{
		 				'CatRowIdTwo':rowData.ID,
	 				    'CatRowId':cat
	 				 },
	 				 function(data){
		 				 
		 				  })
		 				   
	        $('#detail').window('close');
			getTabWindow().reloadTreeGrid();//����ˢ��
	        }
    }
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
function createFrame(tabUrl, cat){
	tabUrl = tabUrl.split("?")[0];
	if(typeof websys_writeMWToken=='function') tabUrl=websys_writeMWToken(tabUrl);
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?cat='+ cat +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

function onClickRow(rowIndex, rowData){
	cat=rowData.ID;//�õ�catֵ
	var currTab =$('#tabs').tabs('getSelected'); 
	var iframe = $(currTab.panel('options').content);
	var src = iframe.attr('src');
	$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,rowData.ID)}});
}