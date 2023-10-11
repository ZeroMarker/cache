//ʵ���ϻ�õ���usercode
var userdr = session['LOGON.USERCODE'];    
var projUrl = 'herp.srm.enpaperrewardexe.csp';

Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];  
    Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "����",  
            minText: "��������С����֮ǰ",  
            maxText: "�������������֮��",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '���� (Control+Right)',  
            prevText: '���� (Control+Left)',  
            monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',  
            todayTip: "{0} (Spacebar)",  
            okText: "ȷ��",  
            cancelText: "ȡ��" 
        });  
    } 
    
var StartDateField = new Ext.form.DateField({
			fieldLabel: '��ʼʱ��',
			width:180,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

/////////////////����ʱ��///////////////////////		
var EndDateField = new Ext.form.DateField({
			fieldLabel: '����ʱ��',
			width:180,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,	
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

 ///��������
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
	    id:'deptCombo',
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,	
			allowblank:true,
			triggerAction : 'all',
			emptyText : '',
			name:'deptCombo',
			width : 120,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			editale:true
		});


// ///////////////////������Ŀ
var titleText = new Ext.form.TextField({
	width : 100,
	selectOnFocus : true
});

// ///////////////////�ڿ�����

var jnameTextDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


jnameTextDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.paperpublishregisterexe.csp'+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('jnameText').getRawValue()),method:'POST'});
});

var jnameText = new Ext.form.ComboBox({
	id: 'jnameText',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 240,
	allowBlank: true,
	store:jnameTextDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���ڿ�����...',
	name: 'jnameText',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////��һ����  
var FirstAuthorDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

FirstAuthorDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('FirstAuthorCombox').getRawValue()),
						method : 'POST'
					});
		});

var FirstAuthorCombox = new Ext.form.ComboBox({
	    id:'FirstAuthorCombox',
			fieldLabel : '��һ���� ',
			store : FirstAuthorDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			allowBlank:true,
			triggerAction : 'all',
			emptyText : '',
			name:'FirstAuthorCombox',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			editable:true
		});	
	
/////��һͨѶ���� 
var CorrAuthorDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

CorrAuthorDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('CorrAuthorCombox').getRawValue()),
						method : 'POST'
					});
		});

var CorrAuthorCombox = new Ext.form.ComboBox({
	    id:'CorrAuthorCombox',
			fieldLabel : '��һͨѶ���� ',
			store : CorrAuthorDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			allowblank:true,
			name:'CorrAuthorCombox',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

//�������
var costNumberField = new Ext.form.NumberField({
	id: 'costNumberField',
	fieldLabel: '�������',
	width:200,
	allowBlank: false,
	listWidth : 220,
	triggerAction: 'all',
	emptyText:'',
	name: 'costNumberField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

/////////////////// ��ѯ��ť 
function srmFundApply(){
	    var startdate = StartDateField.getValue();
	    var enddate = EndDateField.getValue();
	    var dept  = deptCombo.getValue();
	    var title = titleText.getValue(); 
	    var jname = jnameText.getRawValue();
	    var FristAuthor = FirstAuthorCombox.getValue();
	    var CorrAuthor = CorrAuthorCombox.getValue();
	    var usercode = userdr;
	    var data = startdate+"|"+enddate+"|"+dept+"|"+title+"|"+jname+"|"+FristAuthor+"|"+CorrAuthor+"|"+usercode;
		itemGrid.load({
		    params:{
		    data:data,
		    sortField:'',
		    sortDir:'',
		    start:0,
		    limit:25
		   }
	  });
  }


var queryPanel = new Ext.FormPanel({
			height:130,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					     {   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:120%">Ӣ�����Ľ�������</p></center>',
						columnWidth:1,
						height:'50'
					 }]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
				    {
							xtype:'displayfield',
							value:'��ʼʱ��:',
							columnWidth:.09
						},StartDateField,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'��',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'����ʱ��:',
							columnWidth:.09
						},EndDateField
						,{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'����:',
							columnWidth:.05
						},
						deptCombo,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'������Ŀ:',
							columnWidth:.09
						},titleText
						]},{
			    columnWidth:1,
			    xtype: 'panel',
				  layout:"column",
				 items: [
						{
							xtype:'displayfield',
							value:'�ڿ�����:',
							columnWidth:.09
						},
						jnameText,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},
						{
							xtype:'displayfield',
							value:'��һ����:',
							columnWidth:.09
						},
						FirstAuthorCombox,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'��һͨѶ����:',
							columnWidth:.12
						},CorrAuthorCombox,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						}
						,{
							xtype:'button',
							text: '��ѯ',
							handler:function(b){
								srmFundApply();
							},
							iconCls: 'find'
						}		
					]
			    }
			]
		});

var itemGrid = new dhc.herp.Grid({
		    //title: '������������',
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // �Ƿ��Զ�ˢ��
			fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '������Ϣ��ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RecordType',
						header : '��������',
						editable:false,
						width : 120,
						dataIndex : 'RecordType'  
					},{
						id : 'RewardAmountStd',
						header : '��׼�������',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'RewardAmountStd'  
					},{
						id : 'DeptDr',
						header : '����',
						width : 120,
						editable:false,
						dataIndex : 'DeptDr'
					},{
						id : 'Title',
						header : '������Ŀ',
						editable:false,
						width : 180,
						dataIndex : 'Title'
					}, {
						id : 'JName',
						header : '�ڿ�����',
						editable:false,
						width : 120,
						dataIndex : 'JName'
					},{
						id : 'PType',
						header : '�������ڿ�',
						width : 120,
						editable:false,
						dataIndex : 'PType'
					},{
						id : 'RegInfo',
						header : '�����ҳ',
						width : 150,
						editable:false,
						dataIndex : 'RegInfo'
					},  {
						id : 'FristAuthor',
						header : '��һ����',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthor'						
					},{
						id : 'FristAuthorComp',
						header : '��һ���ߵ�λ',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorComp'						
					},{
						id : 'FristAuthorRange',
						header : '��һ��������',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorRange'						
					},{
						id : 'CorrAuthor',
						header : '��һͨѶ����',
						width : 120,
						editable : false,
						dataIndex : 'CorrAuthor'			
					},{
						id : 'CorrAuthorComp',
						header : '��һͨѶ���ߵ�λ',
						width : 120,
						editable : false,
						dataIndex : 'CorrAuthorComp'						
					},{
						id : 'CorrAuthorRange',
						header : '��һͨѶ��������',
						width : 120,
						editable : false,
						dataIndex : 'CorrAuthorRange'						
					},{
						id : 'IF',
						header : 'Ӱ������',
						width : 120,
						editable : false,
						dataIndex : 'IF'						
					},{
						id : 'PageCharge',
						header : '�����',
						width : 120,
						editable:true,
						allowblank:false,
						dataIndex : 'PageCharge'
					},{
						id : 'RewardAmount',
						header : '����',
						width : 120,
						editable:true,
						allowblank:false,
						dataIndex : 'RewardAmount'
					},{
						id : 'SubUser',
						header : '������',
						width : 120,
						editable:false,
						allowblank:false,
						dataIndex : 'SubUser'
					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 120,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '����״̬',
						width : 120,
						editable:false,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckState',
						header : '�������',
						editable:false,
						width : 120,
						hidden:false,
						dataIndex : 'CheckState'
					},{
						id : 'CheckDesc',
						header : '�������',
						width : 150,
						editable:false,
						dataIndex : 'CheckDesc'
					}]					
		});

var RewardApplyButton  = new Ext.Toolbar.Button({
		text: '��������',  
        iconCls:'option',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("DataStatus")=="���ύ"){
				Ext.Msg.show({title:'ע��',msg:'���ύ�������ݲ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if(rowObj[j].get("RewardAmount")==0){
				Ext.Msg.show({title:'ע��',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			//var firstAuthor=rowObj[j].get("FristAuthorName")+"��";
		 var RewardAmountStd=rowObj[j].get("RewardAmountStd");
		 if(rowObj[j].get("RewardAmount")>RewardAmountStd)
		 {
		 	var recordtype=rowObj[j].get("RecordType");
		 	Ext.Msg.show({title:'ע��',msg:recordtype+'�Ľ������ܳ���'+RewardAmountStd,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		 }
		 /**
		  if(rowObj[j].get("RecordType")=="SCI"&&((rowObj[j].get("RewardAmount")>10000)||(rowObj[j].get("RewardAmount")<0)))
		 {
			      Ext.Msg.show({title:'ע��',msg:'SCI���Ľ������ܳ���10000Ԫ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }else if(rowObj[j].get("RecordType")=="�����ڿ�"&&((rowObj[j].get("RewardAmount")!=500)||(rowObj[j].get("RewardAmount")<0))){
			 Ext.Msg.show({title:'ע��',msg:'�����ڿ����Ľ������Ϊ500Ԫ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
		 }else if(rowObj[j].get("RecordType")=="�Ǻ����ڿ�"&&((rowObj[j].get("RewardAmount")>0)||(rowObj[j].get("RewardAmount")<0))){
			 Ext.Msg.show({title:'ע��',msg:'�Ǻ����ڿ����Ľ������Ϊ0Ԫ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
		 }
		 **/
		}
		
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=submit&&rowid='+rowObj[i].get("rowid")+'&rewardamount='+rowObj[i].get("RewardAmount")+'&userdr='+userdr,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12,data:data}});								
							}else{
								var message='���Ľ�������ʧ��!';
								if(jsonData.info=="RepInvoice") message="�����ظ�����";
								if(jsonData.info=="����Ա�ڿ�����Ա�в�����!") message="����Ա�ڿ�����Ա�в�����!";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������ѡ��¼��?',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(RewardApplyButton);
//  itemGrid.addButton('-');
//  itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  
  var data="|||||||"+userdr;
  itemGrid.load({params:{start:0, limit:12, data:data}});

