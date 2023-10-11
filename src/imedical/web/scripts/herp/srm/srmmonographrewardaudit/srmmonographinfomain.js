///////////////////////////////////////////////////
var userdr=session['LOGON.USERID'];
var tmpData="";

var projUrl = '../csp/herp.srm.monographrewardauditexe.csp';

var itemGridUrl = '../csp/herp.srm.monographrewardapplyexe.csp';

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

///////////////////����/////////////////////////////  
var sTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var sTypeCombox = new Ext.form.ComboBox({
	                   id : 'sTypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : sTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
						  
/////////////������ʼʱ��ؼ�
var PSField = new Ext.form.DateField({
	id : 'PSField',
	//format : 'Y-m-d',
	width : 120,
	//allowBlank : false,
	emptyText : ''
});

var PEField = new Ext.form.DateField({
	id : 'PEField',
	//format : 'Y-m-d',
	width : 120,
	emptyText : ''
});

///////////////////ISBN��
var ISBNText = new Ext.form.TextField({
width :120,
selectOnFocus : true
});
///////////////////��������
var monogName = new Ext.form.TextField({
width :120,
selectOnFocus : true
});
//////////////////����
var userDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

userDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=userList',
					method : 'POST'
				});
	});

var userCombo = new Ext.form.ComboBox({
		fieldLabel : '���� ',
		store : userDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 120,
		listWidth : 260,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true
	});
/////////////////��˽��///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','�ȴ�����'],['2','��ͨ��'],['3','δͨ��']]
});

var AuditStateField = new Ext.form.ComboBox({
	id: 'AuditState',
	fieldLabel: '��˽��',
	width:120,
	listWidth : 120,
	allowBlank: true,
	store:AuditStateStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'��ѡ����˽��...',
	mode : 'local',
	name: 'AuditState',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
function srmFundSearch(){
    var startdate= PSField.getRawValue();
    if (startdate!=="")
    {
       //startdate=startdate.format ('Y-m-d');
    }
    //alert(startdate);
    var enddate = PEField.getRawValue();
    if (enddate!=="")
    {
       //enddate=enddate.format ('Y-m-d');
    }
    //alert(enddate);
    var editor  = userCombo.getValue();
    var isbn = ISBNText.getValue();
	var name = monogName.getValue(); 
    var auditstate = AuditStateField.getValue();
    var stype = sTypeCombox.getValue();
  	itemGrid.load({
	    params:{
	    start:0,
	    limit:25,
	    starttime:startdate,
	    endtime:enddate,
	    editor:editor,
	    isbn:isbn,
	    name:name,
	    auditstate:auditstate,
	    userdr:userdr,
		sType:stype
	   }
  });
}


var queryPanel = new Ext.FormPanel({
		autoHeight : true,
	region : 'north',
	frame : true,
	title : 'ר�����������Ϣ��ѯ',
	iconCls : 'search',
		defaults: {bodyStyle:'padding:5px'},
			items:[{
		    columnWidth:1,
		    xtype: 'panel',
			layout:"column",
			items: [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				sTypeCombox,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��������</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				monogName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����ʱ��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},		
				PSField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:center;">��</p>',
					width : 20			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PEField,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},		
				{
					xtype : 'button',
					text : '��ѯ',
					handler : function(b){srmFundSearch();},
					iconCls : 'search',
					width : 30
				}
			]
		}, 
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				userCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��˽��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				AuditStateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},				
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ISBN��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ISBNText
				]
		    }
		]
	
	});
	
	
/////////////////����ʱ��///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
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

	
	
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: 'ר�����������Ϣ��ѯ�б�',
			iconCls: 'list',
			url : 'herp.srm.monographrewardauditexe.csp',	
			/**listeners:{
				
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	               var record = grid.getStore().getAt(rowIndex);
	               // �����������õ�Ԫ�����༭�Ƿ����
	               if ((record.get('ChkResult') != '�ȴ�����') &&((columnIndex == 14)||(columnIndex == 13))) {    
	                      Ext.Msg.show({title:'ע��',msg:'����˻�δͨ��,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
	               } else 
	                      {
	                      return true;
	                      }
	        },        
	        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
	            var record = grid.getStore().getAt(rowIndex);
	            // �����������õ�Ԫ�����༭�Ƿ����
	        
	            if ((record.get('ChkResult') != '�ȴ�����') &&((columnIndex == 13)||(columnIndex == 14))) {          
	                   return false;
	            } else 
	                   {
	                   return true;
	                   }
	     	}},	**/		
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),    
        {
            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{
           id:'sType',
           header: '����',
           allowBlank: false,
           width:40,
           editable:false,
           dataIndex: 'sType'
      }, {
            id:'YearName', 
            header: '���',
            allowBlank: false,
            width:60,
			//hidden:true,
            editable:false,
            dataIndex: 'YearName'
       }, {
           id:'Type',
           header: '�������',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'Type'
      }, {
           id:'Name',
           header: '��������',
           allowBlank: false,
           width:180,
           editable:false,
           dataIndex: 'Name',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
      }, {
           id:'CompleteUnit',
           header: '�ڼ���ɵ�λ',
           allowBlank: false,
           width:120,
           editable:false,
		   hidden:true,
           dataIndex: 'CompleteUnit'
      },{
           id:'EditorName',
           header: '��������',
           allowBlank: false,
           width:80,
           editable:false,
           renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
           dataIndex: 'EditorName'
      }, {
           id:'PressName',
           header: '����������',
           allowBlank: false,
           width:120,
           editable:false,
           dataIndex: 'PressName',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
           id:'PressLevel',
           header: '�����缶��',
           allowBlank: false,
           width:100,
           editable:false,
           dataIndex: 'PressLevel',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'ISBN',
            header: 'ISBN��',
            allowBlank: false,
            width:120,
            editable:false,
            dataIndex: 'ISBN',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'TotalNum',
            header: '������(ǧ��)',
            allowBlank: false,
            width:100,
            align:'right',
            editable:false,
            dataIndex: 'TotalNum',
			
renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
       },  {
            id:'PubTime',
            header: '����ʱ��',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'PubTime'
       },  {
            id:'PublishFreq',
            header: '������',
            allowBlank: false,
            width:80,
            editable:false,
            align:'right',
            dataIndex: 'PublishFreq'
       },{
			id : 'RewardAmount',
			header : '����(Ԫ)',
			width : 80,
			align:'right',
			editable:true,
			allowblank:false,
			dataIndex : 'RewardAmount',
			
renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
		},{
						id : 'RewardDate',
						header : '����ʱ��',
						editable:true,
						width : 100,
						dataIndex : 'RewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
           id:'SubUserName',
           header: '������',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'SubUserName'
      },{
          id:'DeptName',
          header: '�����˿���',
          allowBlank: false,
          width:120,
        //  hidden:true,
          editable:false,
          dataIndex: 'DeptName',
		  renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },  {
            id:'SubDate',
            header: '����ʱ��',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'SubDate'
       },{
            id:'SysNo',
            header: 'ϵͳ��',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'SysNo'
       }, {
			id:'score',
			header:'����÷�',
			editable:true,
			width:120,
			hidden:true,
			dataIndex:'score'
		},{
			id:'Auditor',
			header:'�����',
			editable:false,
			width:60,
			align:'left',
			dataIndex:'Auditor'
		},{
			id:'CheckDeptName',
			header:'����˿���',
			editable:false,
			 hidden:true,
			width:120,
			align:'center',
			dataIndex:'CheckDeptName'
		},{
			id:'AuditDate',
			header:'���ʱ��',
			editable:false,
			width:80,
			align:'left',
			dataIndex:'AuditDate'
		},{
            id:'ChkResult', 
            header: '���״̬',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'ChkResult'
       },{
            id:'ChkProcDesc', 
            header: '��˽��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ChkProcDesc'
       },{
            id:'CheckDesc', 
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'CheckDesc'
       },{
            id:'EditorIDs', 
            header: '��������IDs',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'EditorIDs'
       },{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					}, {
            id:'DataStatus',
            header: '����״̬',
            allowBlank: false,
            width:120,
             hidden:true,
            editable:false,
            dataIndex: 'DataStatus'
       },{
						id : 'IsReward',
						header : '�Ƿ���',
						editable:false,
						hidden:true,
						//format:'Y-m-d',
						width : 60,
						dataIndex : 'IsReward'
					}
					
					
					
					]
  }
  
  
  
  );


var AuditButton  = new Ext.Toolbar.Button({
	text: '�������ͨ��',  
    id:'auditButton', 
    iconCls: 'pencil',
    handler:function(){
		
	//���岢��ʼ���ж���
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	var checker = session['LOGON.USERCODE'];
	
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
    for(var j= 0; j < len; j++){
	    
	 if(rowObj[j].get("ChkResult")!='�ȴ�����')
	 {
		      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
		
	}
	function handler(id){
		if(id=="yes"){
			
			
			for(var i = 0; i < len; i++){
				    Ext.Ajax.request({
				    url:projUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
					waitMsg:'�����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
							
						}else{
							Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
}
});


var NoAuditButton = new Ext.Toolbar.Button({
				text : '��ͨ��',
				iconCls: 'pencil',
				handler : function() {
					var rowObj=itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					for(var j= 0; j < len; j++){
						 if(rowObj[j].get("ChkResult")!='�ȴ�����')
						 {
							      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							       return;
						 }else{noauditfun();}
					}
					
					
			   }
});

 var RewardAuditButton  = new Ext.Toolbar.Button({
		text: '�������',  
        id:'RewardAuditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
	
		
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		
     for(var j= 0; j < len; j++){
	     
	         
	         var RewardState= rowObj[j].get("IsReward") 
		     if(rowObj[j].get("IsReward")=="�ѽ���")
		     { 
			      Ext.Msg.show({title:'ע��',msg:'�ѽ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		     }
		    
		     
		      var RewardAmount = rowObj[j].get("RewardAmount")  
		 	  if(rowObj[j].get("RewardAmount")==""){
			     Ext.Msg.show({title:'ע��',msg:'����д�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
		    
		    
		       var RewardDate=rowObj[j].get("RewardDate");
				 if(RewardDate=="")
				 {
								     Ext.Msg.show({title:'ע��',msg:'��ѡ����ʱ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								     return;
				 }
		    
		      var aaa=rowObj[j].get("ChkProcDesc");
		      if((aaa.indexOf("�ȴ�����")>0)||(aaa.indexOf("��ͨ��")>0))
		      {
			     Ext.Msg.show({title:'ע��',msg:'����δ��˲��ܷ��Ž���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		      }
		    		 
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					  var RewardAmount = rowObj[i].get("RewardAmount");  
					  var RewardDate=rowObj[i].get("RewardDate"); 
					  if(rowObj[i].isModified("RewardDate")){
						 
						  var RewardDate=RewardDate.format('Y-m-d');
						  
						  } 
					  
					      
					  Ext.Ajax.request({
						url:projUrl+'?action=rewardaudit&&rowid='+rowObj[i].get("rowid")+'&RewardAmount='+RewardAmount+'&checker='+checker+'&RewardDate='+RewardDate,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
});




itemGrid.addButton('-');
itemGrid.addButton(AuditButton);
itemGrid.addButton('-');
itemGrid.addButton(NoAuditButton);
itemGrid.addButton('-');
itemGrid.addButton(RewardAuditButton);

itemGrid.btnResetHide(); 	//�������ð�ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
itemGrid.btnAddHide(); 	//������Ӱ�ť
itemGrid.btnSaveHide(); 	//���ر��水ť
itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//��������
	if (columnIndex == 8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("EditorIDs");
		var title = records[0].get("Name");
		BookAuthorInfoList(title,authorinfo);
	}
	
var records = itemGrid.getSelectionModel().getSelections();
	var state = records[0].get("ChkResult");
	
	if(state!="ͨ��")
	{
	  RewardAuditButton.disable();//����Ϊ������
	  return;
	}else{
	   RewardAuditButton.enable();//����Ϊ����
	  return;
	}
	
	
});

//uploadMainFun(itemGrid,'rowid','P004',24);
downloadMainFun(itemGrid,'rowid','P004',29);	

