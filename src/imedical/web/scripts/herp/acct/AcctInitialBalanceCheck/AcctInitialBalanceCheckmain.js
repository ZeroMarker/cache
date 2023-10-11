
    var UserId=session['LOGON.USERID'];
	//alert(UserId);
	
	var AcctBookID=IsExistAcctBook();
     //var AcctBookID=GetAcctBookID();

 Ext.Ajax.request({
						url:'herp.acct.acctinitialbalancecheckexe.csp?action=ifInit&&UserId='+UserId,
		
						success: function(result, request){							
							var jsonData = Ext.util.JSON.decode(result.responseText);
							//alert(jsonData.info);
							if (jsonData.info=='1'){
							    
								InitButton.disable();
							}else{
								InitButton.enable();
							}
						}
					});
					
	var SubjNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",  
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['subjId','subjCode','subjName','subjCodeName'])
});

SubjNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.acct.acctinitialbalancecheckexe.csp?action=GetCashSubj&AcctBookID='+AcctBookID,
	method:'POST'});
});

var SubjName = new Ext.form.ComboBox({
	id: 'SubjName',
	fieldLabel: '���п�Ŀ',
	width:200,
	listWidth : 220,
	allowBlank: true,
	store: SubjNameDs,
	valueField: 'subjCode',
	displayField: 'subjName',
	triggerAction: 'all',
	emptyText:'��Ŀ�ֵ���ĩ�����п�Ŀ',
	name: 'SubjName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
   
   var InitButton = new Ext.Toolbar.Button({
   	    text : '��ʼ��',
	    iconCls : 'datainit',
		width:55,
		handler : function() {
			  
			  function init(id){
			    if(id=="yes"){
				       //  var lista=document.getElementById("maintop").getElementsByTagName("a");
					    Ext.Ajax.request({
						url:'herp.acct.acctinitialbalancecheckexe.csp?action=Init&&UserId='+UserId,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){							
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��ʼ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								
							}else{
								Ext.Msg.show({title:'����',msg:'��ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			    }else{
			    	return;
			     }
		    }
		   Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ����?',init);
		}		
  });
  
  
    var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text : 'ͳ��',
					tooltip : '���ͳ��',
					iconCls : 'calculate',
					
					handler : function() {
						
						ShowReport();
					}
	}); 

	function ShowReport(){
		 
		var subjCode=Ext.getCmp("SubjName").getValue();

		 p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.InitialBalanceChecklist.raq&subjectcode='+subjCode+'&userid='+UserId
           //alert(p_URL);
			var reportFrame=document.getElementById("frameReport");
                          reportFrame.src=p_URL;
		//alert(p_URL);
	}
		var reportPanel=new Ext.Panel({
		autoScroll:true,
		region:'center',
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/herp/acct/images/logon_bg.jpg" />'


    })
	
	    var ListTab = new Ext.form.FormPanel({
			id : 'ListTab',
			title:'��ʼ���˶Ա�',
			iconCls:'find',
		    region: 'north',
		    height: 80,
		    frame: true,
		   defaults: {
			bodyStyle: 'padding:5px '
		  },
			//autoScroll : true,
			//bodyStyle : 'padding:5px;',
			items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '���п�Ŀ',
						style: 'line-height:15px;',
						width: 70
					}, SubjName, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 15
					},OkBT, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 15
					},InitButton
				]
			}]
			//tbar : ['���п�Ŀ:',SubjName,'-',OkBT,'-',InitButton]

	});
	
	/*
    var ListTab = new Ext.form.FormPanel({
			id : 'ListTab',
			labelWidth : 60,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			items : [{
						xtype : 'panel',
						title : '��ѯ����',					
						items : [SubjName]
					}],
			tbar : [OkBT,'-',InitButton]

	});
*/


