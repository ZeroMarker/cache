
Ext.onReady(function(){
	Ext.QuickTips.init();
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	var groupId =session['LOGON.GROUPID'];
	var menu = new Ext.menu.Menu({
		id: 'mainMenu',
		items: []
	});
	
	var objService = ExtTool.StaticServerObject("DHCMed.SS.MyPortlets");
	var objPortlet = objService.GeMyportletsByGroup(groupId);
	
	var arryTmp = objPortlet.split("<$C1>");
	for(var intRow = 0; intRow < arryTmp.length; intRow ++)
	{
		var myPortlet = arryTmp[intRow];
		if(myPortlet == "") continue;
		var arryField = myPortlet.split("^");
		//var myPorId=arryField[0];
		var pId = arryField[0];
		var pName = arryField[1];
		var ProIsShow = arryField[2];
		var check=false;
		if(ProIsShow=="1")
		{
			check=true;
		}
		var menuItem=new Ext.menu.CheckItem({
			itemId:pId,
			text:pName,
			checked : check,
			listeners: {
				'checkchange': function(e,checked){
					return;
					var a=Ext.getCmp("portalCol1").items.length;
					var b=Ext.getCmp("portalCol2").items.length;
					var c=Ext.getCmp("portalCol3").items.length;
					var min=a<(b<c?b:c)?a:(b<c?b:c)
					var column=0;
					var portalCol="";
					if(min==a) { 
						column=0;
						portalCol=Ext.getCmp("portalCol1");
					} else if(min==b) { 
						column=1;
						portalCol=Ext.getCmp("portalCol2");
					} else {
						column=2;
						portalCol=Ext.getCmp("portalCol3");
					}
					
					var tmp=groupId+"^"+e.itemId+"^";
					if(checked) {
						tmp+="1"+"^"+column+"^"+min;
					} else {
						tmp+="0^^";
						var portlet=Ext.getCmp("portlet_"+e.itemId);
						portlet.ownerCt.remove(portlet, true);
						GetAllPor();
					}
					
					try{
						var NewID=objService.UpdateByIndex(tmp);
						if(NewID<0) {
							ExtTool.alert("提示","保存失败！");
							return;
						}
						if(checked){
							var portlets = objService.MaGetPortlets(groupId);
							var portletsArray = Ext.decode(portlets);
							var columns;
							if (portletsArray[column]) columns=portletsArray[column];
							portalCol.removeAll();
							portalCol.add(columns);
							portalCol.doLayout();
						}
					}catch(err){
						ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
					}
				}
			}
		});
		menu.addItem(menuItem);
		menu.doLayout();
	}
	
	var portlets = objService.MaGetPortlets(groupId);
	var portletsArray = Ext.decode(portlets);
	var columns1,columns2,columns3;
	if (portletsArray[0]) columns1=portletsArray[0];
	if (portletsArray[1]) columns2=portletsArray[1];
	if (portletsArray[2]) columns3=portletsArray[2];
	
    var viewport = new Ext.Viewport({
        layout:'border',
        items:[
			{
				xtype:'portal',
				region:'center',
				margins:'5 5 5 0',
				autoScroll : true,
				/*tbar: [
					'->',
					{
						icon: '../scripts/dhcmed/img/manager.gif',
						text: '配置',
						menu : menu
					}
				],*/
				items:[
					{
						columnWidth:.33,
						id : 'portalCol1',
						style:'padding:10px 0 10px 10px',
						items:columns1
					},{
						columnWidth:.33,
						id : 'portalCol2',
						style:'padding:10px 0 10px 10px',
						items:columns2
					},{
						columnWidth:.33,
						id : 'portalCol3',
						style:'padding:10px 0 10px 10px',
						items:columns3
					}
				]
				,listeners: {
					'drop': function(){
						GetAllPor();
					}
				}
				,proviteConfig : function(panel){
					menu.get(panel.id.split("_")[1]).setChecked(false); //closePortlet(panel);            	
				}
				,maximizeConfig:function(panel){
					window.parent.add(panel);  //"tabPanel"
				}
			}
		]
    });
	
	var GetAllPor=function()
	{
		for(var i=0;i<3;i++){
			var porArry=Ext.getCmp("portalCol"+(i+1)).items;
			for(var j=0;j<porArry.length;j++){
				var porId=porArry.items[j].id.split("_");
				var tmp=groupId+"^"+porId[1]+"^"+"1"+"^"+i+"^"+j;
				try {
					var NewID=objService.UpdateByIndex(tmp);
					if(NewID<0) {
						ExtTool.alert("提示","保存失败！");
						return;
					}
				} catch(err) {
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
			}
		}
	}
})