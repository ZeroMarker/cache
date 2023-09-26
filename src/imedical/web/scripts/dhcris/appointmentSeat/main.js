
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
		name:'С��',
		email:'xiaowang@easyjf.com',
		sex:'��',
		bornDate:'1991-4-4'},
		{id:1,
		name:'С��',
		email:'xiaoli@easyjf.com',
		sex:'��',
		bornDate:'1992-5-6'},
		{id:1,
		name:'С��',
		email:'xiaoxiao@easyjf.com',
		sex:'Ů',
		bornDate:'1993-3-7'}
	];
	
	var storetest=new Ext.data.JsonStore({
		data:datatest,
		fields:["id","name","sex","email",{name:"bornDate",type:"date",dateFormat:"Y-n-j"}]
	});
	*/
	//�ܿ��
	
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

		var patInfo="������Ϣ : &nbsp;"+adminfoList[1]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[0]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[4];
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
	//ҽ���б����¼�
	serviceOrderGrid.on('cellclick',clickOeOrdList);
	//��ѯ��ťclick�¼�
	Ext.getCmp('btnQuery').on('click',queryRefresh);
	//�������뵥�¼�
	Ext.getCmp('btnSave').on('click',saveApp);
	
	//�������뵥�¼�
	Ext.getCmp('btnSend').on('click',sendApp);

	//��ӡ���뵥�¼�
	Ext.getCmp('btnPrint').on('click',printApp);

	//ҽ������¼�
	
	//˫����λ�б�ѡ���¼�
	bodyList.on('dblclick', bodyListDbClick);
	//˫����ѡ��λɾ���¼�
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
			//return "û�����ӵ�Internet";
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
