//dhc.ris.indication.js        

//所有用到的类方法定义
var  Info = {
	Session:{
		group_rowid:session['LOGON.GROUPID'],
		group_desc:session['LOGON.GROUPDESC'],
		user_rowid:session['LOGON.USERID'],
		user_name:session['LOGON.USERNAME']
	},
	URL:{
		GetMemo:"dhc.ris.fun.method.csp?act=Getindication"
	}	
};

var DescPanel = new Ext.Panel({
    layout:'form',
    border:false,
    labelWidth:1,
    labelAlign:'right',
    items:[
    {
        xtype:'textarea',
        id:'DescPanel',
        //fieldLabel:'',
        height:600,
        anchor:'98%',//,
        abelStyle: "text-align: top;"
    }]   
});




var AppShowPanel = new Ext.FormPanel({
        title:"适应症",
        //width:600,
        //bodyStyle: 'background:#ffc; padding:10px;',
        bodyStyle: 'padding:10;',
        layout:"form",
        region:'center',
        frame:true,
        autoScroll:true,
        collapsible:true,
        items:[
            DescPanel,
            new Ext.Panel({
                border:false,
                height:10
            })
        ]
    });
    
///alert(session['LOGON.CTLOCID']);
Ext.onReady(function(){
    var obj = new Object();
    
     obj.Viewport = new Ext.Viewport({
        id:'viewport',
        layout:'border',
        labelStyle: 'background:#ffc; padding:10px;',
        items:[
            AppShowPanel  
        ]
    });
   
   initInfo();
});
        

function initInfo()
{
	Ext.Ajax.request({
		url:Info.URL.GetMemo,
		params:{
			OEOrd:OEorditemID
			},
		
		method:'GET',
		success:function(response){
			var result=response.responseText;
			result=result.replace("\r\n","");
			//var item=result.split("^");
			if ( result!="")
			{
				Ext.getCmp('DescPanel').setValue(result);
			}
		},
		error:function(XMLHttpRequest,textStatus,errorThrown)
		{
		   alert(textStatus+"("+errorThrown+")");
		}
		
		
	});
}
