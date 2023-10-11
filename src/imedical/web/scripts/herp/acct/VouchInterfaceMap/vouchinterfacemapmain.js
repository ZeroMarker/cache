var userid = session['LOGON.USERID'];

//------------------------------------------��ѯ����---------------------------------------------//
////////////////// ��ѯ����ϵͳҵ��ģ�� ///////////////////
var BusiModuleNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BusiModuleNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=busimodulenamelist',
						method : 'POST'
					});
		});

var BusiModuleNameCom = new Ext.form.ComboBox({
			id:'busimodulename',
			store : BusiModuleNameDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'ҵ��ģ������',
			width : 180,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
////////////////// ��ѯ�������� ///////////////////
var ParamValueCom1 = new Ext.form.ComboBox({	
			id:'ParamValueCom1',											
			fieldLabel: '����',
			width:100,
			listWidth : 100,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '�跽'], ['-1', '����']]
				}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '����',
			selectOnFocus:'true'
});

///////////// ��ѯ������Ŀ //////////////////////
var ProjText = new Ext.form.TextField({
			fieldLabel: '',
			width:100,
			emptyText:'��Ŀ���������',
			selectOnFocus:'true'
});

///////////// ��ѯ������Ŀ //////////////////////
var SubjText = new Ext.form.TextField({
			fieldLabel: '',
			width:100,
			emptyText:'��Ŀ���������',
			selectOnFocus:'true'
});


//----------------------------------------����е�������---------------------------------------------//		
////////////////// �����ϵͳҵ��ģ�� ///////////////////		
var BusiModuleNameDs1 = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BusiModuleNameDs1.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=busimodulenamelist',
						method : 'POST'
					});
		});

var BusiModuleNameCom1 = new Ext.form.ComboBox({
			id:'busimodulename1',
			store : BusiModuleNameDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'ϵͳҵ��ģ������',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
            "select":function(combo,record,index){
	            AcctSubjDs.removeAll();     
				AcctSubjCom.setValue('');
				AcctSubjDs.proxy = new Ext.data.HttpProxy({url:'herp.acct.acctvouchinterfacemapexe.csp?action=acctsubjlist&BusiModuleCode='+combo.value,method:'POST'})  
				AcctSubjDs.load({params:{start:0,limit:10}});      					
			}
	   }	
		});


////////////////// ����л�Ʋ��ŷ��� ///////////////////		
var AcctDeptTypeNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

AcctDeptTypeNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=acctdepttypelist',
						method : 'POST'
					});
		});

var AcctDeptTypeNameCom = new Ext.form.ComboBox({
			id:'AcctDeptTypeNameCom',
			store : AcctDeptTypeNameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��Ʋ��ŷ���',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

////////////////// ����л�ƿ�Ŀ ///////////////////

var AcctSubjDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name','IsCashFlow'])
});

AcctSubjDs.on('beforeload', function(ds, o){

    var code=BusiModuleNameCom1.getValue();	
	if(!code){
		Ext.Msg.show({title:'ע��',msg:'����ѡ��ҵ��ģ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	
	//ds.proxy=new Ext.data.HttpProxy({
	
		//url:'herp.acct.acctvouchinterfacemapexe.csp?action=acctsubjlist',method:'POST'})
});	
 var AcctSubjCom = new Ext.form.ComboBox({
			id:'AcctSubjCom',
			store : AcctSubjDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ƿ�Ŀ',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
			
		});
////////////////// �����Ԥ���Ŀ ///////////////////
var budgSubjDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

budgSubjDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=budgsubjlist',
						method : 'POST'
					});
		});
		
var BudgSubjCom = new Ext.form.ComboBox({
			id:'AcctSubjCom',
			store : budgSubjDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'Ԥ���Ŀ',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

////////////////// ���� ///////////////////
var ParamValueCom = new Ext.form.ComboBox({												
			fieldLabel: '����',
			width:80,
			listWidth : 80,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '�跽'], ['-1', '����']]
				}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			value : '1',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'ѡ��...',
			selectOnFocus:'true'
});
////////////////// �Զ�����ƾ֤�����ֶ����� ///////////////////
var IsAutoCom = new Ext.form.ComboBox({												
			fieldLabel: '�Ƿ��Զ�',
			width:80,
			listWidth : 80,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '�Զ�'], ['2', '�ֶ�']]
				}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			value : '1',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'ѡ��...',
			selectOnFocus:'true'
});
///�ʽ�����
var CashFlowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

CashFlowDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=CashFlowlist',
						method : 'POST'
					});
			
		});
	
	
 var CashFlowCom = new Ext.form.ComboBox({
			id:'CashFlowCom',
			store : CashFlowDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '�ʽ�����',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
////////////////// ��λ���� ///////////////////
var AcctBookDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

AcctBookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=acctbooklist',
						method : 'POST'
					});
		});

var AcctBookCom = new Ext.form.ComboBox({
			id:'AcctBookCom',
			store : AcctBookDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��λ����',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//////////////////// ��ѯ��ť //////////////////////
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	    var ParamValueCon=ParamValueCom1.getValue();
	    var BusiModuleNameCon=BusiModuleNameCom.getValue();
	    var ProjCodeName=ProjText.getValue();
	    var SubjCodeName=SubjText.getValue();
		
		itemGrid.load({params:{start:0,limit:25,ParamValueCon:ParamValueCon,BusiModuleNameCon:BusiModuleNameCon,ProjCodeName:ProjCodeName,SubjCodeName:SubjCodeName}});
	}
});
var saveButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler :function() {
						var recs=itemGrid.getStore().getModifiedRecords();//�����¼���ᱻ���ֵ�store�´�load֮ǰ  
             			alert("���޸ļ�¼�ĸ���"+recs.length)  
              
                	//��̨�õ�������¼          
       				 if(recs.length==0){  
            				return  
        			}else{  
        					for(var i=0;i<recs.length;i++){
	        					var rowid = recs[i].get("1601");
	        					var BusiModuleName = recs[i].get("2");
								var ItemCode = recs[i].get("3");
								var ItemName = recs[i].get("4");
								var AcctDeptTypeName = recs[i].get("5");
								var AcctSubjName = recs[i].get("6|12");
								var AcctSummary = recs[i].get("7");
								var AcctDirection = recs[i].get("8");
								var ZjlxID = recs[i].get("9:12");
								var IsAuto = recs[i].get("1");
								var AcctBookName = recs[i].get("1");
								var moneySource = recs[i].get("1");
								
	        					Ext.Ajax.request({
		        					url:'../csp/herp.acct.acctvouchinterfacemapexe.csp?action=edit&rowid='+rowid+'&BusiModuleName='+encodeURIComponent(BusiModuleName)+'&ItemCode='+encodeURIComponent(ItemCode)+'&ItemName='+encodeURIComponent(ItemName)+'&AcctDeptTypeName='+encodeURIComponent(AcctDeptTypeName)+'&AcctSubjName='+encodeURIComponent(AcctSubjName)+'&AcctSummary='+encodeURIComponent(AcctSummary)+'&AcctDirection='+encodeURIComponent(AcctDirection)+'&ZjlxID='+encodeURIComponent(ZjlxID)+'&IsAuto='+encodeURIComponent(IsAuto)+'&AcctBookName='+encodeURIComponent(AcctBookName)+'&moneySource='+encodeURIComponent(moneySource),
		        					waitMsg:'������...',
									failure: function(result, request){		
										Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									},
									success: function(result, request){
										var jsonData = Ext.util.JSON.decode( result.responseText );
										if (jsonData.success=='true'){				
											Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
											
											//itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
										}
										else
										{
											Ext.Msg.show({title:'����',msg:'�޸�ʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
						
									}
		        				});
	        				}
            				
        			}}		
				});
var printButton = new Ext.Toolbar.Button({
    text : '��ӡ',
	tooltip : '�����ӡ',
	width : 70,
	height : 30,
	iconCls : 'option',
	handler : function() {
	var syscode=BusiModuleNameCom.getValue();
	if(syscode=="")
	{
		Ext.Msg.show({title : 'ע��',msg : '����ѡ��ҵ��ģ������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
		return ;
	}
	var fileName="{herp.acct.inter.VouchInterfaceMap.raq(code="+syscode+")}";
	DHCCPM_RQDirectPrint(fileName);

    }
});


var itemGrid = new dhc.herp.Grid({
        title: 'ƾ֤�ӿ�����',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctvouchinterfacemapexe.csp',
				atLoad : false,
				tbar:[BusiModuleNameCom,'-',ProjText,'-',SubjText,'-',ParamValueCom1,'-',findButton],
        fields: [{
             header: 'ID',
             dataIndex: 'rowid',
						 edit:false,
             hidden: true
        }, {
            id:'BusiModuleName',
            header: 'ҵ��ģ��',
						allowBlank: false,
						width:120,
            dataIndex: 'BusiModuleName',
            type:BusiModuleNameCom1
        },{
            id:'ItemCode',
            header: '��Ŀ����',
		    		allowBlank: false,
		    		width:120,
            dataIndex: 'ItemCode'
        },{
            id:'ItemName',
            header: '��Ŀ����',
						allowBlank: false,
						width:180,
            dataIndex: 'ItemName'
        },{
            id:'AcctDeptTypeName',
            header: 'ִ�в���',
						allowBlank: false,
						width:90,
            dataIndex: 'AcctDeptTypeName',
            type:AcctDeptTypeNameCom
        },{
            id:'AcctSubjName',
            header: '��ƿ�Ŀ',
						width:250,
            dataIndex: 'AcctSubjName',
            type:AcctSubjCom
        },{
            id:'AcctSummary',
            header: '���ժҪ',
						width:180,
            dataIndex: 'AcctSummary'
        },{
            id:'AcctDirection',
            header: '����',
						allowBlank: false,
						width:80,
            dataIndex: 'AcctDirection',
            type:ParamValueCom
        },{
            id:'ZjlxID',
            header: '�ʽ�����',
			allowBlank: true,
						width:250,
            dataIndex: 'ZjlxID',
            type:CashFlowCom
        },{
            id:'IsAuto',
            header: '�Ƿ��Զ�',
						allowBlank: true,
						width:80,
            dataIndex: 'IsAuto',
            type:IsAutoCom
        },{
            id:'MoneySource',
            header: '�ʽ���Դ',
						allowBlank: true,
						width:80,
            dataIndex: 'MoneySource'
        },{
            id:'AcctBookName',
            header: '��λ����',
						allowBlank: true,
						width:70,
            dataIndex: 'AcctBookName',
            type:AcctBookCom
        }]
    
    });

itemGrid.btnPrintHide();
itemGrid.btnResetHide();
//itemGrid.addButton(printButton);
//itemGrid.addButton(saveButton);