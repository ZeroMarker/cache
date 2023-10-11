var projUrl = '../csp/herp.acct.acctversinglecertifexe.csp';
var userdr = session['LOGON.USERID'];	
var Verifytext = new Ext.form.TextField({
			columnWidth : .1,
			width : 200,
			columnWidth : .12,
			emptyText: '请输入凭证编码......',
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
						title : '凭证录入',
						width :1020,
						height :500,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // 表示为渲染window body的背景为透明的背景
						//bodyStyle : 'padding:5px;',
						items : [myPanel ],
						buttonAlign : 'center',
						buttons : [{
								text : '关闭',
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
		text: '测试',
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
						title : '凭证录入',
						width :1020,
						height :500,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // 表示为渲染window body的背景为透明的背景
						//bodyStyle : 'padding:5px;',
						items : [myPanel ],
						buttonAlign : 'center',
						buttons : [{
								text : '关闭',
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
		text: '审 核',
    	tooltip: '',        
    	iconCls: '',
		handler: function(){
			
			  var vercode=Verifytext.getValue();
			  Ext.Ajax.request({
				  //url: '../csp/acct.html?acctno='+vercode,
					
					url:projUrl+'?action=audit'+'&vercode='+vercode+'&userdr='+userdr,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
			        success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if ((jsonData.success=='true'))
						{				
							if(jsonData.info=='Repuser')
							Ext.Msg.show({title:'注意',msg:'无权限审核!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='unsubmitted')
							Ext.Msg.show({title:'注意',msg:'未提交不能审核！',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='accounted')
							Ext.Msg.show({title:'注意',msg:'已记账不能审核！',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='again')
							{
				            	if (confirm("已审核单据确定重新审核？")) 
				            	{  
                                  verifyauditFun(vercode,userdr); 
                                } else {  
                                  alert("取消操作");  
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
		text: '凭证处理明细',
    	tooltip: '',        
    	iconCls: '',
		handler: function(){
			var vercode=Verifytext.getValue();
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			
			//alert(vercode);
			if (vercode==""){
				Ext.Msg.show({title:'注意',msg:'请选择凭证号!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
            header: '处理人',
			allowBlank: false,
			editable:false,
			width:80,
			update:true,
            dataIndex: 'Operator'
        },{
	        id:'OpDateTime',
            header: '处理时间',
			//hidden:false,
			width:90,
			editable:false,
            dataIndex: 'OpDateTime'
	    
        },{								
            id:'OpAct',
            header: '工作任务',
			width:90,
			hidden:false,
            dataIndex: 'OpAct'
        },{
            id:'OpResult',
            header: '处理结果',
			width:90,
			hidden:false,
            dataIndex: 'OpResult'
        },{
            id:'OpDesc',
            header: '处理意见',
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
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"

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
			tbar: ['凭证编码：','-',Verifytext,'-','-',VerifyButton,'-',VouProButton,'-',testButton],
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
