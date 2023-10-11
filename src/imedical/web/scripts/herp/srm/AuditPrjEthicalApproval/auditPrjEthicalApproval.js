var userdr = session['LOGON.USERID'];   
 
var projUrl = 'herp.srm.auditPrjEthicalApprovalexe.csp';

///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
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
// ������ʼʱ��ؼ�
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
		//allowBlank : false,
		emptyText : ''
	});
	
////////////////��������
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});	
		
deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList'+'&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                        method:'POST'
					});
		});
		
var deptCombo = new Ext.form.ComboBox({
            id:'deptCombo',
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 /////////////////������Դ
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList'+'&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()),  
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
            id:'SubSourceCombo',
			fieldLabel : '������Դ',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

/////////////�����������
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '�ȴ�����'], ['1', 'ͨ��'], ['2', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�����������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

//////���⸺����
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()), 
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
            id:'userCombo',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
// ////////////��������
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});
		

/////////////////// ��ѯ��ť 
/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
		var startdate= PSField.getValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    var enddate= PEField.getValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var SubSource= SubSourceCombo.getValue();
	    var ResAudit  = ChkResultField.getValue();
	    var HeadDr= userCombo.getValue();
	    var PName = titleText.getValue();     
		var Type = TypeCombox.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    ApplyStart: startdate,
		    Applyend: enddate,
		    deptdr: dept,
		    SubSource: SubSource,
		    HeadDr: HeadDr,
		    PName: PName,
			Type:Type
		   }
	  });
  }
});
var AuditButton  = new Ext.Toolbar.Button({
		text: 'ͨ��',  
        iconCls:'option',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERID'];
		//alert(checker);
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("EthicalAuditState")=="ͨ��"||rowObj[j].get("EthicalAuditState")=="δͨ��")
		 {
			      Ext.Msg.show({title:'ע��',msg:'�������������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
								itemGrid.load({params:{start:0, limit:12,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
					iconCls : 'option',
					handler : function() {
						var usercheckdr   = session['LOGON.USERID'];	
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("EthicalAuditState")=="ͨ��"||rowObj[j].get("EthicalAuditState")=="δͨ��")
							 {
								      Ext.Msg.show({title:'ע��',msg:'�������������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						//noauditfun();
						 function handler(id){
						 	if(id=="yes"){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:projUrl+'?action=noaudit'+'&rowid='+rowObj[i].get("rowid")+'&usercheckdr='+usercheckdr,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
								itemGrid.load({params:{start:0, limit:12,usercheckdr:usercheckdr}});	
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else  {return;}
			}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
		}
  });
 var tbuttonbar = new Ext.Toolbar({   
        items: ['��������:',titleText,'-',findButton,AuditButton,NoAuditButton]   
 }); 
 
var itemGrid = new dhc.herp.Gridhss({
		    //title: '������������',
		    region : 'center',
		    viewConfig : {forceFit : false},
		    autoScroll:true,
		    url: projUrl,
		    atLoad : true, // �Ƿ��Զ�ˢ��
			fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '����ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '����',
						width : 120,
						editable:false,
						dataIndex : 'Type'
					},{
						id : 'PrjType',
						header : '��������',
						width : 120,
						editable:false,
						dataIndex : 'PrjType'
					},{
						id : 'YearCode',
						header : '���',
						width : 120,
						editable:false,
						dataIndex : 'YearCode'
					},{
						id : 'Dept',
						header : '����',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'Dept'
					},{
						id : 'Name',
						header : '��������',
						editable:false,
						width : 180,
						align: 'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						dataIndex : 'Name'
					},{
						id : 'Head',
						header : '��Ŀ������',
						editable:false,
						width : 120,
						hidden:true,
//						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//						           return '<span style="color:blue;cursor:hand">'+value+'</span>';
//						},
						dataIndex : 'Head'
					}, 
					{
						id : 'CompleteUnit',
						header : '��Ժ��ɵ�λ',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'CompleteUnit'
					}, {
						id : 'ParticipantsName',
						header : '���������Ա',
						width : 130,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>���������Ա</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ParticipantsName'
					},
					{
						id : 'Participants',
						header : '����μ���Ա',
						width : 180,
						editable:false,
						hidden:true,
//						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//						           return '<span style="color:blue;cursor:hand">'+value+'</span>';
//						},
						dataIndex : 'Participants'
					},{
						id : 'PTName',
						header : '������Դ',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'PTName'
					},{
						id : 'Department',
						header : '�����',
						width : 120,
						editable:false,
						dataIndex : 'Department'
					},{
						id : 'SubNo',
						header : '������',
						width : 120,
						editable:false,
						dataIndex : 'SubNo'
					},{
						id : 'RelyUnit',
						header : '�������е�λ',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RelyUnit'
					},{
						id : 'PrjCN',
						header : '��ͬ��',
						width : 120,
						editable:false,
						dataIndex : 'PrjCN'
					},{
						id : 'SEndDate',
						header : '��ֹ����',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'SEndDate'
					},{
						id : 'IsGovBuy',
						header : '�Ƿ�������Ŀ',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'IsGovBuy'
					},{
						id : 'FundOwn',
						header : 'ҽԺƥ�䣨��Ԫ��',
						width : 120,
						editable:false,
						dataIndex : 'FundOwn'
					},{
						id : 'FundMatched',
						header : '��λ���ѣ���Ԫ��',
						width :120,
						editable:false,
						dataIndex : 'FundMatched'
					},{
						id : 'EthicalAuditState',
						header : '��������״̬',
						width :120,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['EthicalAuditState']
						if (sf == "�ȴ����") {return '<span style="color:grey;cursor:hand">'+value+'</span>';} 
						if (sf == "ͨ��") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "δͨ��"){return '<span style="color:blue;cursor:hand">'+value+'</span>';}
						},
						dataIndex : 'EthicalAuditState'
					},{
						id : 'SubUser',
						header : '����������',
						width : 120,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '��������ʱ��',
						width : 120,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'ProjStatus',
						header : '��Ŀ״̬',
						width : 120,
						editable:false,
						dataIndex : 'ProjStatus'
					},{
						id : 'HeadDr',
						header : '������ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'HeadDr'
					},{
						id : 'ParticipantsIDs',
						header : '�μ���ԱID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'ParticipantsIDs'
					},{
						id : 'RelyUnitIDs',
						header : '�μ���ԱID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RelyUnitIDs'
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
						

					} }],
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					//viewConfig : {forceFit : true},
					tbar :['����:',TypeCombox,'-','��ʼʱ��:', PSField,'-','����ʱ��:',PEField,'-','��������:', deptCombo, '-', '������Դ:',SubSourceCombo,'���⸺����:',userCombo],
					listeners : { 'render': function(){ 
            tbuttonbar.render(this.tbar); 
        } 
     },
					height:230,
					trackMouseOver: true,
					stripeRows: true	
		});

  itemGrid.btnAddHide();  //�������Ӱ�ť
  itemGrid.btnSaveHide();  //���ر��水ť
  //itemGrid.btnResetHide();  //�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  // itemGrid.btnPrintHide();  //���ش�ӡ��ť
   
  itemGrid.load({params:{start:0, limit:12}});

    downloadMainFun(itemGrid,'rowid','P007',27);
/**
 itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];
        
	DetailGrid.load({params:{start:0, limit:12,rowid:rowid}});	
});
**/

///////////// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
//		if (columnIndex == 4) {
//			var records = itemGrid.getSelectionModel().getSelections();
//			var headdr = records[0].get("HeadDr");
//			HeadInfoList(headdr);
//		}
		var records = itemGrid.getSelectionModel().getSelections();
	    if (columnIndex == 6) {
	    
				var ProjectDR   = records[0].get("rowid");
				var RelyUnitsIDs = records[0].get("RelyUnitIDs");
				titleFun(ProjectDR,RelyUnitsIDs);
		}

		if(columnIndex == 9){

		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
	
});

