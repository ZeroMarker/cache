/// �����������(�����б�)  2020/12/28
function OpenReviewWin(dataType,selItem)
{
	//alert(dataType+":"+selItem)
	//var selItem= "";
	if( selItem == null ){
		$.messager.alert('��ʾ',"��ѡ��Ҫά������������Ŀ��","info")
		return;
	}
	//var dataType = "";	// ����
	//var selItem = "";	// ����ֵ
	if($('#ReviewWin').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	
	if ("undefined"!==typeof websys_getMWToken){
		iframeurl = "<iframe id='reviewmanframe' scrolling='auto' frameborder='0' src='dhcckb.ignoremanage.csp"+"?dataType="+dataType+"&dataValue="+selItem+"&MWToken="+websys_getMWToken()+"' " +"style='width:100%; height:98%; display:block;'></iframe>"
	}else{
		iframeurl = "<iframe id='reviewmanframe' scrolling='auto' frameborder='0' src='dhcckb.ignoremanage.csp"+"?dataType="+dataType+"&dataValue="+selItem+"' " +"style='width:100%; height:98%; display:block;'></iframe>"
	}
	
	$('body').append('<div id="ReviewWin"></div>');
	var myWin = $HUI.dialog("#ReviewWin",{
        iconCls:'icon-w-save',
        title:'��������',
        modal:true,
        width:1200,
        height:560,
        content:iframeurl,
        buttonAlign : 'center',
        buttons:[
        	/*{
            text:'����',
            id:'save_btn',
           	 	handler:function(){
                	GrantAuthItem();                    
            	}
       		},*/
       		{
            text:'�ر�',
            	handler:function(){                              
                	myWin.close(); 
            	}
        	}
        ]
    });
	$('#ReviewWin').dialog('center');
}
///��Ŀ��Ȩ
function GrantAuthItem(){
	
	//$("#diclog")[0].contentWindow.SaveManyDatas();	// ��ҳ����־
	$HUI.dialog('#ReviewWin').close();
}

