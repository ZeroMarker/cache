var projUrl = '../csp/herp.acct.acctversinglecertifexe.csp';
var userdr = session['LOGON.USERID'];	
var Verifytext = new Ext.form.TextField({
			columnWidth : .1,
			width : 200,
			columnWidth : .12,
			emptyText: '������ƾ֤����......',
			//disabled: true,
			selectOnFocus : true,
			listeners : {
				
					specialKey : function(field, e) {
					vercode=Verifytext.getValue();
				/*
					if (e.getKey() == Ext.EventObject.ENTER) {
						//alert(vercode);
					 Ext.Ajax.request({

					//url: '../csp/herp.acct.acctversinglecertifexe.csp?action=listd'+'&start='+0+'&limit='+25+'&VouchID='+vercode,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var code = jsonData.info;
							Verifytext.setValue(code);
					
						}
					},
					scope: this
					});
					//VerifyButton.focus();						
						}
					} 
					*/
			
			 //alert(vercode);
			//url: '../csp/acct.html?acctno='+vercode,
			var myPanel = new Ext.Panel({
			layout : 'fit',
			//scrolling="auto"
			html : '<iframe src="acct.html?acctno=vercode"  width="100%"  height="100%" ></iframe>',
			frame : true
			});
			var win = new Ext.Window({
						title : 'ƾ֤¼��',
						width :1020,
						height :500,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel ],
						buttonAlign : 'center',
						buttons : [{
								text : '�ر�',
								type : 'button',
								handler : function() {
									win .close();
									}
								}]
					});
					win.show();
					}
		}
});
		
var testButton = new Ext.Toolbar.Button({
		text: '����',
    	tooltip: '',        
    	iconCls: '',
		handler: function(){
			
			var vercode=Verifytext.getValue();
			 //alert(vercode);
			//url: '../csp/acct.html?acctno='+vercode,
			var myPanel = new Ext.Panel({
			layout : 'fit',
			//scrolling="auto"
			html : '<iframe src="acct.html?acctno=vercode"  width="100%"  height="100%" ></iframe>',
			frame : true
			});
			var win = new Ext.Window({
						title : 'ƾ֤¼��',
						width :1020,
						height :500,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel ],
						buttonAlign : 'center',
						buttons : [{
								text : '�ر�',
								type : 'button',
								handler : function() {
									win .close();
									}
								}]
					});
					win.show();

		}
});
		
//var vercode=Verifytext.getValue();		
var VerifyButton = new Ext.Toolbar.Button({
		text: '�� ��',
    	tooltip: '',        
    	iconCls: '',
		handler: function(){
			
			  var vercode=Verifytext.getValue();
			  Ext.Ajax.request({
				  //url: '../csp/acct.html?acctno='+vercode,
					
					url:projUrl+'?action=audit'+'&vercode='+vercode+'&userdr='+userdr,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
			        success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if ((jsonData.success=='true'))
						{				
							if(jsonData.info=='Repuser')
							Ext.Msg.show({title:'ע��',msg:'��Ȩ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='unsubmitted')
							Ext.Msg.show({title:'ע��',msg:'δ�ύ������ˣ�',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='accounted')
							Ext.Msg.show({title:'ע��',msg:'�Ѽ��˲�����ˣ�',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='again')
							{
				            	if (confirm("����˵���ȷ��������ˣ�")) 
				            	{  
                                  verifyauditFun(vercode,userdr); 
                                } else {  
                                  alert("ȡ������");  
                                  }  
							}
							//itemMain.load({params:{start:0, limit:12,userdr:userdr}});
							//itemDetail.load({params:{start:0, limit:12,vercode:"",ChkResult:"",view:"",statusid:""}});
						    if(jsonData.info=='go')
				 			verifyauditFun(vercode,userdr);     
						}
					},
					scope: this
			        });				      
		}			
});

var VouProButton = new Ext.Toolbar.Button({
		text: 'ƾ֤������ϸ',
    	tooltip: '',        
    	iconCls: '',
		handler: function(){
			var vercode=Verifytext.getValue();
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			
			//alert(vercode);
			if (vercode==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ƾ֤��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			   }
			else
			   {	
			   											
				 	VouchProgressFun(vercode);   
				 	//url:projUrl+'?action=listd'+'&start='+0+'&limit='+25+'&vercode='+vercode;  						      
			   }			 
	}                 
});

var itemGridProxy= new Ext.data.HttpProxy({url:projUrl + '?action=listd'});
var itemGridDs = new Ext.data.Store({
			proxy : itemGridProxy,
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['AcctVouchOpLogID','Operator','OpDateTime','OpAct','OpResult','OpDesc']),
					remoteSort: true
		});

var itemGridCm = new Ext.grid.ColumnModel([
		    
		new Ext.grid.RowNumberer(),
        {    id:'AcctVouchOpLogID',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'AcctVouchOpLogID'
        },{
            id:'Operator',
            header: '������',
			allowBlank: false,
			editable:false,
			width:80,
			update:true,
            dataIndex: 'Operator'
        },{
	        id:'OpDateTime',
            header: '����ʱ��',
			//hidden:false,
			width:90,
			editable:false,
            dataIndex: 'OpDateTime'
	    
        },{								
            id:'OpAct',
            header: '��������',
			width:90,
			hidden:false,
            dataIndex: 'OpAct'
        },{
            id:'OpResult',
            header: '������',
			width:90,
			hidden:false,
            dataIndex: 'OpResult'
        },{
            id:'OpDesc',
            header: '�������',
			width:140,
			editable:false,
            dataIndex: 'OpDesc'
        }]
);

var AuditPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"

})


var itemGrid = new Ext.grid.GridPanel({
			//title: '',
	        region: 'center',
            width: 550,
	        minSize: 350,
	        maxSize: 450,
	        split: true,
	        collapsible: true,
	        containerScroll: true,
	        xtype: 'grid',
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			viewConfig: {forceFit:true},
			tbar: ['ƾ֤���룺','-',Verifytext,'-','-',VerifyButton,'-',VouProButton,'-',testButton],
			bbar:AuditPagingToolbar
});

 itemGridDs.load({	
			params:{start:0, limit:AuditPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){
	
	if (rowIndex !=='0')
	{ 
	//alert (rowIndex);
	//personGrid.getSelectionModel().getSelections()
	//var selectedRow = itemGridDs.data.items[rowIndex];
	//alert(itemGridDs.data.items);
    //rowid = selectedRow.data['rowid'];
    //itemID=rowid;
	}
	/*
	if(columnIndex=='12'){
         
	var records = itemGrid.getSelectionModel().getSelections();   
    var VouchID = records[0].get("vercode");
	VouchProgressFun(VouchID);
	}
   */

});   

itemGrid.load({params:{start:0,limit:25}});
