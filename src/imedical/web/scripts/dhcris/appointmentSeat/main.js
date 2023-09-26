
Ext.override(Ext.grid.CheckboxSelectionModel, { 
handleMouseDown : function(g, rowIndex, e){  
	//alert("1");
    if(e.button !== 0 || this.isLocked())
    {   
        return;   
    }   
    var view = this.grid.getView();   
    if(e.shiftKey && !this.singleSelect && this.last !== false)
    {   
        var last = this.last;   
        this.selectRange(last, rowIndex, e.ctrlKey);   
        this.last = last; // reset the last   
        view.focusRow(rowIndex);   
    }
    else
    {   
        var isSelected = this.isSelected(rowIndex);   
    	if(isSelected)
    	{   
       		this.deselectRow(rowIndex);   
		}
		else if(!isSelected || this.getCount() > 1)
		{   
        	this.selectRow(rowIndex, true);   
        	view.focusRow(rowIndex);   
        }   
    }   
} 
});

//alert("Main-001");
//alert("adm="+adm)
//var frm = dhcsys_getmenuform();
//var admSchedule = frm.EpisodeID.value;  //'358' ;//'13';//frm.EpisodeID.value;//'67';//frm.EpisodeID.value;
//var admSchedule = adm;
//alert("admSchedule_JS="+admSchedule);

//alert(adm1);


Ext.onReady(function(){
	/*
	var datatest=[{id:1,
		name:'小王',
		email:'xiaowang@easyjf.com',
		sex:'男',
		bornDate:'1991-4-4'},
		{id:1,
		name:'小李',
		email:'xiaoli@easyjf.com',
		sex:'男',
		bornDate:'1992-5-6'},
		{id:1,
		name:'小兰',
		email:'xiaoxiao@easyjf.com',
		sex:'女',
		bornDate:'1993-3-7'}
	];
	
	var storetest=new Ext.data.JsonStore({
		data:datatest,
		fields:["id","name","sex","email",{name:"bornDate",type:"date",dateFormat:"Y-n-j"}]
	});
	*/
	//总框架
	
	var frm = dhcsys_getmenuform();
	if (admSchedule=="")
	{
		admSchedule=frm.EpisodeID.value;
	}
	/*
	if (admSchedule=="")
	{
	 	admSchedule="358";
	}
*/
	
	var Viewport = new Ext.Viewport({
		id:'viewport',
		layout:'border',
		//labelStyle: 'background:#ffc; padding:10px;',
		items:[
			orderListRegion,
			centerRegion,
			eastRegion
		]
	});
	
	initEvent();
	Ext.getCmp("startDate").setValue(new Date());
	Ext.getCmp("endDate").setValue(new Date().add(Date.DAY, 6));
	
	if (admSchedule!="")
	{
		var admInfo=tkMakeServerCall("web.DHCRisCommFunctionEx","GetPaadmInfo",admSchedule);
		
		var adminfoList=admInfo.split('^');

		var patInfo="患者信息 : &nbsp;"+adminfoList[1]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[0]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[4];
		//alert(Ext.getCmp("patInfo").text);
		Ext.getCmp("patInfo").setText(patInfo);
		
	}
	serviceOrderStore.load();
	/*
	var isShowPrint=tkMakeServerCall("web.DHCRisResApptSchudleSystem","getBookPrintFlag",session['LOGON.GROUPID']);
	
	if ( isShowPrint!="Y")
	{
		//Ext.getCmp("btnPrint").setDisabled(true);
	}
	*/
	document.onkeydown=documentKeyDown;
	/*
	var   win = new Ext.Window({
                //applyTo:'hello-win',
                //layout:'fit',
				layout:'border',
                width:1300,
                height:620,
                //closeAction:'hide',
                plain: true,

                items: [
                
                orderListRegion,
				centerRegion,
				eastRegion
                ]
    });
        
    serviceOrderStore.load();
    win.show(this);
    */
});


function documentKeyDown()
{
	var keycode;

    try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
    
    if(keycode==115) {
        clickReadcard();
    }
	
}


function initEvent(){
	/*
	//医嘱列表单击事件
	serviceOrderGrid.on('cellclick',clickOeOrdList);
	//查询按钮click事件
	Ext.getCmp('btnQuery').on('click',queryRefresh);
	//保存申请单事件
	Ext.getCmp('btnSave').on('click',saveApp);
	
	//发送申请单事件
	Ext.getCmp('btnSend').on('click',sendApp);

	//打印申请单事件
	Ext.getCmp('btnPrint').on('click',printApp);

	//医嘱相关事件
	
	//双击部位列表选择事件
	bodyList.on('dblclick', bodyListDbClick);
	//双击已选部位删除事件
	BodyPartSelList.on('dblclick',bodySelListDbClick);
	
	Ext.getCmp('btnQuery').on('click',queryApp);
	*/
}


function GetComputerName()
{
	var computerName;
	try
	{
	   var WshNetwork=new ActiveXObject("WScript.Network"); 
	   computerName=WshNetwork.ComputerName;
	   WshNetwork = null;
	}
	catch(e)
	{
	   computerName="Exception";
	}
	return computerName;
}

function getLocalIP()
{ 
	var oSetting = null; 
	var ip = null; 
	try
	{ 
		oSetting = new ActiveXObject("rcbdyctl.Setting"); 
		ip = oSetting.GetIPAddress; 
		//if (ip.length == 0)
		{ 
			//return "没有连接到Internet";
			//ip="";
		}
		oSetting = null; 
	}
	catch(e)
	{ 
		return ip; 
	}
	return ip; 
} 
