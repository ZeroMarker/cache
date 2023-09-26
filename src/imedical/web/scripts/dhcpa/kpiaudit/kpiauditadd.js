addSchemFun = function(dataStore,grid,pagingTool) {
var userID = session['LOGON.USERID'];
var KPIDs = new Ext.data.Store({
	proxy:KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});


var KPIIndex = new Ext.ux.form.LovCombo({
			id:'KPIIndex',
			fieldLabel: 'KPI指标',
			valueField: 'rowid',
			displayField:'name',
			emptyText:'请选择指标...',
			triggerAction:'all',
			allowBlank: false,
			width:213,
			listWidth : 213,
			store:KPIDs,
            minChars: 1,
			//pageSize: 10,
			//selectOnFocus:true,
			//forceSelection:'true',
			editable:false			
		});

   var userDs = new Ext.data.Store({
	proxy:"",
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
userDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:KPIAuditUrl+'?action=user&str='+encodeURIComponent(Ext.getCmp('user').getRawValue())});
});

var user = new Ext.form.ComboBox({
			id:'user',
			fieldLabel: '用户',
			valueField: 'rowid',
			displayField:'name',
			emptyText:'请选择用户...',
			triggerAction:'all',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store:userDs,
            minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true			
		});
	
	KPIDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:KPIAuditUrl+'?action=kpi&userCode='+Ext.getCmp('user').getValue()});
    });
	user.on("select",function(cmb,rec,id){

        var userID=Ext.getCmp('user').getValue();
		KPIDs.proxy=new Ext.data.HttpProxy({url:KPIAuditUrl+'?action=kpi&userCode='+userID});
		KPIDs.load({params:{str:userID}});
});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
    
            user,
	        KPIIndex		
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加用户KPI权限',
    width: 400,
    height:200,
    minWidth: 200,
    minHeight: 100,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		// check form value
      		
			var KPI = KPIIndex.getValue();
		    var userDr = user.getValue();
      		
			KPI = KPI.trim();
			userDr = userDr.trim();
      		
        	var data = KPI+'^'+userDr;

			if((userDr=="")&&(KPI=="")){
                Ext.Msg.show({title:'错误', msg:'添加的KPI或数据用户不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:270});
            }else if(userDr==""){
                Ext.Msg.show({title:'错误', msg:'添加的数据用户不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            }else if(KPI==""){
                Ext.Msg.show({title:'错误', msg:'添加的KPI指标不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:240});
            }
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: KPIAuditUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepKPI') message='KPI重复!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};