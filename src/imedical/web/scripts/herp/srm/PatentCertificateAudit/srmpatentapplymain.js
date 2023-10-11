
var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmpatentcertificateauditexe.csp';
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



/////////////////��Ȩ����///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: 'ר����������',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
var EndDateField = new Ext.form.DateField({
			fieldLabel: 'ר����������',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
/////////////////����///////////////////////
var DeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentcertificateapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////ר��Ȩ��///////////////////
var PatenteeDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentcertificateapplyexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
	method:'POST'});
});

var PatenteeField = new Ext.form.ComboBox({
	id: 'Patentees',
	fieldLabel: 'ר��Ȩ��',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��Ȩ��...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////ר������///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: 'ר������',
                blankText: 'ר������'
            });

/////////////////////ר�����/////////////////////////////					
var ufPatentTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����ר��'], ['2', 'ʵ������ר��'], ['3', '������ר��']]
	});
	var ufPatentTypeField = new Ext.form.ComboBox({
	    id : 'ufPatentTypeField',
		fieldLabel : 'ר�����',
		width : 120,
		listWidth : 120,
		store : ufPatentTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true
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
/////////////////////�Ƿ����/////////////////////////////					
var IsApprovedDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['Y', '��'], ['N', '��']]
	});
var IsApprovedCombo = new Ext.form.ComboBox({
	    id : 'IsApprovedCombo',
		fieldLabel : '�Ƿ����',
		width : 120,
		listWidth : 120,
		store : IsApprovedDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true
	});	
/////////////////����ʱ��///////////////////////
var ApprovedDateField = new Ext.form.DateField({
	        id: 'ApprovedDateField',
			fieldLabel: '����ʱ��',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{			
	    var startdate= StartDateField.getRawValue()
		if(startdate!=""){
			//startdate.format("Y-m-d");
		};
		var enddate= EndDateField.getRawValue()
		if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	    var DeptDr  = DeptField.getValue();
        var Patentee = PatenteeField.getValue();
        
        var Name = PatentName.getValue();
        var PatentType = ufPatentTypeField.getValue();
        var auditstate = AuditStateField.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,Name:Name,auditstate:auditstate,usercode:usercode,PatentType:PatentType}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	title : 'ר��Ժ��֤�������Ϣ��ѯ',
	iconCls : 'search',
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				/* {
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				}, */
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ר��Ȩ��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PatenteeField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ר������</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentName,
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
				StartDateField,
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
				EndDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},		
				{
					xtype : 'button',
					text : '��ѯ',
					handler : function(b){SearchFun();},
					iconCls : 'search',
					width : 30
				}
				]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ר������</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ufPatentTypeField,
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
				AuditStateField
				]
	}]
	
});




var itemGrid = new dhc.herp.Grid({
	title: 'ר��Ժ��֤�������Ϣ��ѯ�б�',
			iconCls: 'list',
			region : 'center',
			url : projUrl,
			///// �����������õ�Ԫ�����༭�Ƿ����
			
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'YearDr',
						header:'��� ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearDr'

					},{
						id:'PatentType',
						header:'ר�����',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PatentTypeList'
					},{
						id:'Name',
						header:'ר������',
						width:180,
						editable:false,
						align:'left',
						/*
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						*/
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+data+'</span>';;
						},
						dataIndex:'Name'
					}, {
						id:'Patentee',
						header:'ר��Ȩ��',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Patentee',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'InventorsID',
						header:'������IDs',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'InventorsID'
					},{
						id:'InventorInfos',
						header:'������',
						width:80,
						editable:false,
						align:'left',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex:'InventorInfos'
					},{
						id:'IsApproved',
						header:'�Ƿ����',
						width:60,
						editable:true,
						align:'left',
						dataIndex:'IsApproved',
						type:IsApprovedCombo
					},{
						id:'ApprovedDate',
						header:'��������',
						width:80,
						editable:true,
						align:'left',
						dataIndex:'ApprovedDate',
						type:ApprovedDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
					},{
						id:'AppDate',
						header:'ר����������',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AppDate'

					},{
						id:'SubUser',
						header:'������',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDept',
						header:'�����˿���',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'SubDept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'�Ǽ�ʱ��',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'AuditStatus',
						header:'���״̬',
						width:120,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'AuditStatus'
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
						width:120,
						hidden:true,
						align:'left',
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
						header:'���״̬',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'ChkResult'
					},{
						id:'ChkProcDesc',
						header:'��˽��',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ChkProcDesc'
					},{
						id:'Desc',
						header:'������',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'Desc'
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
							id:'Phone',
							header: '�绰����',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'Phone'
						},{
							id:'Email',
							header: '�ʼ�',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'Email'
						},{
							id:'IsApprovedID',
							header: '�Ƿ������־',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'IsApprovedID'
						}
					
					
					
					]
		});


var AuditButton = new Ext.Toolbar.Button({
	text: 'ͨ��',  
    iconCls: 'pencil',
    handler:function(){
	//���岢��ʼ���ж���
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
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
						url:projUrl+'?action=audit&rowid='+rowObj[i].get("rowid")+'&usercode='+usercode+'&ratio='+rowObj[i].get("Ratio"),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ר��Ժ��֤����˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����ѡ��¼��?��˺����޸�',handler);
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
	       }else
						{noauditfun();}
					}
					
					
			   }
});
 var ApprovedAuditButton  = new Ext.Toolbar.Button({
		text: '�Ƿ����',  
        id:'ApprovedAuditButton', 
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
			var rowid=rowObj[j].get("rowid");
		    
		 	
		   var aaa=rowObj[j].get("ChkProcDesc");
		    if((aaa.indexOf("�ȴ�����")>0)||(aaa.indexOf("��ͨ��")>0))
		    {
			     Ext.Msg.show({title:'ע��',msg:'����δ���ͨ������ȷ���Ƿ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
			var IsApprovedID = rowObj[j].get("IsApprovedID"); 
			if(IsApprovedID!="")
		    {
			     Ext.Msg.show({title:'ע��',msg:'��ȷ���Ƿ�����������ٴθ��ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
			
			if(rowObj[j].get("IsApproved")==""){
			     Ext.Msg.show({title:'ע��',msg:'����д�Ƿ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    } 
		    var ApprovedDate=rowObj[j].get("ApprovedDate");
			if((IsApprovedCombo.getValue()=="Y")&(ApprovedDateField.getValue()==""))
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					  var IsApproved = IsApprovedCombo.getValue();   
					     var ApprovedDate=ApprovedDateField.getValue();
					      if(rowObj[i].isModified("ApprovedDate")){ 
						  var ApprovedDate=ApprovedDate.format('Y-m-d');
						  } 
					  var rowid=rowObj[i].get("rowid")
					  Ext.Ajax.request({
						url:projUrl+'?action=approvedaudit&rowid='+rowid+'&isapproved='+IsApproved+'&date='+ApprovedDate,
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
	itemGrid.addButton(ApprovedAuditButton);
	

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//��ϸ��Ϣ
	var records = itemGrid.getSelectionModel().getSelections();
	if (columnIndex == 5) {
		PatentDetail(itemGrid);
	}
	if (columnIndex == 8) {
		var authorinfo = records[0].get("InventorsID");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
	// var IsApproved=records[0].get("IsApproved");
	var IsApproved = IsApprovedCombo.getRawValue();
	if (IsApproved=="��")
	{
		ApprovedDateField.disable();
	}
	if (IsApproved=="��")
	{
		ApprovedDateField.enable();
	} 
}); 

//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'rowid','SRMpatentapply001,SRMpatentapply002,SRMpatentapply003,SRMpatentapply004,SRMpatentapply005',22);