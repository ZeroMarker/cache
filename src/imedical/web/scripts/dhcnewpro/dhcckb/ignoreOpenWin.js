/// 管理规则配置(忽略列表)  2020/12/28
function OpenReviewWin(dataType,selItem)
{
	//alert(dataType+":"+selItem)
	//var selItem= "";
	if( selItem == null ){
		$.messager.alert('提示',"请选择要维护管理规则的项目！","info")
		return;
	}
	//var dataType = "";	// 类型
	//var selItem = "";	// 类型值
	if($('#ReviewWin').is(":visible")){return;}  			//窗体处在打开状态,退出
	
	if ("undefined"!==typeof websys_getMWToken){
		iframeurl = "<iframe id='reviewmanframe' scrolling='auto' frameborder='0' src='dhcckb.ignoremanage.csp"+"?dataType="+dataType+"&dataValue="+selItem+"&MWToken="+websys_getMWToken()+"' " +"style='width:100%; height:98%; display:block;'></iframe>"
	}else{
		iframeurl = "<iframe id='reviewmanframe' scrolling='auto' frameborder='0' src='dhcckb.ignoremanage.csp"+"?dataType="+dataType+"&dataValue="+selItem+"' " +"style='width:100%; height:98%; display:block;'></iframe>"
	}
	
	$('body').append('<div id="ReviewWin"></div>');
	var myWin = $HUI.dialog("#ReviewWin",{
        iconCls:'icon-w-save',
        title:'忽略配置',
        modal:true,
        width:1200,
        height:560,
        content:iframeurl,
        buttonAlign : 'center',
        buttons:[
        	/*{
            text:'保存',
            id:'save_btn',
           	 	handler:function(){
                	GrantAuthItem();                    
            	}
       		},*/
       		{
            text:'关闭',
            	handler:function(){                              
                	myWin.close(); 
            	}
        	}
        ]
    });
	$('#ReviewWin').dialog('center');
}
///项目授权
function GrantAuthItem(){
	
	//$("#diclog")[0].contentWindow.SaveManyDatas();	// 子页面日志
	$HUI.dialog('#ReviewWin').close();
}

