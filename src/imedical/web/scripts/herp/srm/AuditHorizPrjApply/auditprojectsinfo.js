var userdr = session['LOGON.USERID'];   
 
var projUrl = 'herp.srm.audithorzprjApplyexe.csp';

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
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
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
	    //var ResAudit  = ChkResultField.getValue();
	    var ResAudit  = "";
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
		    ResAudit:ResAudit,
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
		 if(rowObj[j].get("ChkResult")=="1"||rowObj[j].get("ChkResult")=="2")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.audithorzprjApplyexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
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
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("ChkResult")=="1"||rowObj[j].get("ChkResult")=="2")
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
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
						width : 80,
						editable:false,
						dataIndex : 'Type'
					},{
						id : 'YearCode',
						header : '���',
						width : 60,
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
						hidden:true,
						width : 120,
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
						width : 100,
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
						width : 100,
						editable:false,
						hidden:true,
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
						hidden:true,
						dataIndex : 'PrjCN'
					},{
						id : 'StartDate',
						header : '��ʼ����',
						width :120,
						editable:false,
						dataIndex : 'StartDate',
                        hidden:true
					},{
						id : 'EndDate',
						header : '��������',
						width :120,
						editable:false,
						dataIndex : 'EndDate',
                        hidden:true
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
						id : 'AppFund',
						header : '���뾭�ѣ���Ԫ��',
						width :120,
						editable:false,
						dataIndex : 'AppFund'
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
						id : 'AlertPercent',
						header : '������',
						width :80,
						editable:false,
						dataIndex : 'AlertPercent'
					},{
						id : 'MonographNum',
						header : '����ר��',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'MonographNum'
					},{
						id : 'PaperNum',
						header : '��������',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'PaperNum'
					},{
						id : 'PatentNum',
						header : 'ר��',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'PatentNum'
					},{
						id : 'InvInCustomStanNum',
						header : '�����ƶ�������׼',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'InvInCustomStanNum'
					},{
						id : 'TrainNum',
						header : '�����˲�',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'TrainNum'
					},{
						id : 'HoldTrainNum',
						header : '�ٰ���ѵ��',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'HoldTrainNum'
					},{
						id : 'InTrainingNum',
						header : '������ѵ��',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'InTrainingNum'
					},{
						id : 'IsEthicalApproval',
						header : '�Ƿ���������',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'IsEthicalApproval'
					},{
						id : 'SubUser',
						header : '����������',
						width : 100,
						editable:false,
						dataIndex : 'SubUser'
					},{
						id : 'SubDate',
						header : '��������ʱ��',
						width : 100,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'Remark',
						header : '��ע',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'Remark'
					},{
						id : 'ProjStatus',
						header : '��Ŀ״̬',
						width : 80,
						editable:false,
						dataIndex : 'ProjStatus'
					},{
						id : 'DataStatuslist',
						header : '����״̬',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'DataStatuslist'
					},{
						id : 'ChkResult',
						header : '��˽��',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '���д����״̬',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ChkResult']
						if (sf == "0") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "1") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "2"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						width : 120,
						dataIndex : 'ChkResultlist'
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
					tbar :['����:',TypeCombox,'-','��ʼʱ��:', PSField,'-','����ʱ��:',PEField,'-','��������:', deptCombo, '-', '������Դ:',SubSourceCombo,'-','���⸺����:',userCombo],
					listeners : { 'render': function(){ 
            tbuttonbar.render(this.tbar); 
        } 
     },
					//height:230,
					trackMouseOver: true,
					stripeRows: true	
		});

  itemGrid.btnAddHide();  //�������Ӱ�ť
  itemGrid.btnSaveHide();  //���ر��水ť
  //itemGrid.btnResetHide();  //�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  // itemGrid.btnPrintHide();  //���ش�ӡ��ť
   
  itemGrid.load({params:{start:0, limit:12}});
   downloadMainFun(itemGrid,'rowid','P007',41);

 itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var rowid=selectedRow[0].data['rowid'];
  var participantsdrs = selectedRow[0].get("ParticipantsIDs");
  var header = selectedRow[0].get("HeadDr");
  var allparticipants = header+','+participantsdrs;
	DetailGrid.load({params:{start:0, limit:25,rowid:rowid}});	
	ParticipantsInfoGrid.load({params:{start:0,limit:25,participantsdrs:allparticipants}});
	PrjItemInfoGrid.load({params:{start:0,limit:25,PrjDR:rowid}});
});


// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	var records = itemGrid.getSelectionModel().getSelections();
    if (columnIndex == 5) {
    
			var ProjectDR   = records[0].get("rowid");
			var RelyUnitsIDs = records[0].get("RelyUnitIDs");
			titleFun(ProjectDR,RelyUnitsIDs);
	}

	if(columnIndex == 8){
		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		//alert(ParticipantsIDs);
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
});

