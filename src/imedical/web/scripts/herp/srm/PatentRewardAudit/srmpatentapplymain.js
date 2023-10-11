
var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmpatentrewardauditexe.csp';
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
			fieldLabel: '��Ȩ����',
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
			fieldLabel: '��Ȩ����',
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
	url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
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
	url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
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


/////////////////ר����///////////////////
var PatentNumber = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentNumber',
                fieldLabel: 'ר����',
                blankText: 'ר����'
            });
/////////////////ר������///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: 'ר������',
                blankText: 'ר������'
            });



/////////////////ר��������///////////////////////////
var InventorsDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


InventorsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardapplyexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorss').getRawValue()),
	method:'POST'});
});

var InventorsField = new Ext.form.ComboBox({
	id: 'Inventorss',
	fieldLabel: 'ר��������',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:InventorsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��������...',
	name: 'Inventorss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
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
        var PatentNum = PatentNumber.getValue();
        var Name = PatentName.getValue();
        var Inventors = InventorsField.getValue();
        var auditstate = AuditStateField.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,PatentNum:PatentNum,Name:Name,Inventors:Inventors,auditstate:auditstate,usercode:usercode}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	title : 'ר�����������Ϣ��ѯ',
	iconCls : 'search',

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
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
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
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
					value : '<p style="text-align:right;">��Ȩ����</p>',
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
					width : 70			
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
					value : '<p style="text-align:right;">ר����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentNumber,
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
					value : '<p style="text-align:right;">ר��������</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				InventorsField
				]
	}]
	
});



/////////////////����ʱ��///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
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
////////////////////��������/////////////////////////////

var RatioStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['0','0'],['0.5','50%'],['1','100%']]
});

var RatioCombox = new Ext.form.ComboBox({
	id: 'RatioCombox',
	fieldLabel: '��������',
	width:120,
	//anchor: '95%',
	listWidth : 80,
	allowBlank: true,
	store:RatioStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	mode : 'local',
	name: 'RatioCombox',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: 'ר�����������Ϣ��ѯ�б�',
			iconCls: 'list',
			url : 'herp.srm.srmpatentrewardauditexe.csp',
			///// �����������õ�Ԫ�����༭�Ƿ����
			listeners:{
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	               var record = grid.getStore().getAt(rowIndex);
	               if ((record.get('ChkResult') != '�ȴ�����') &&(columnIndex == 17)) {    
	                      Ext.Msg.show({title:'ע��',msg:'���������,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
	               }else{
		               /**
	                   if((record.get('ChkResult') == 'ͨ��')&&(record.get('IsReward')=='�ѽ���')&&((columnIndex==23)||(columnIndex==24)))
					   {
					   Ext.Msg.show({title:'ע��',msg:'���������,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
					   }
					   else{
					   return true;
					   }**/
	               }
	        }},				
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
						id:'CertificateNo',
						header:'֤���',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CertificateNo'

					},{
						id:'PatentType',
						header:'ר�����',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PatentType'
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

					}, {
						id:'Inventors',
						header:'������IDs',
						width:120,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Inventors'
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
						id:'PatentNum',
						header:'ר����',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentNum'

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
						id:'AnnDate',
						header:'��Ȩ��������',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnDate'

					},{
						id:'AnnUnit',
						header:'������λ',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnit'

					},{
						id:'AnnUnitList',
						header:'������λ',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnitList'

					},{
						id:'CompleteUnit',
						header:'�ڼ���ɵ�λ',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CompleteUnit'

					},{
						id:'VCAmount',
						header:'���뱨��(Ԫ)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'VCAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }			
					},{
						id:'unitMoney',
						header:'���ҵ�λ',
						editable:false,
						width:60,
						align:'left',
						editable:false,
						dataIndex:'unitMoney'
					},{
						id:'Ratio',
						header:'��������',
						editable:true,
						width:80,
						align:'right',
						dataIndex:'Ratio',
						type:RatioCombox
					},{
						id:'REAmount',
						header:'ʵ�ʱ���(Ԫ)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'REAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id:'InvoiceCode',
						header:'��������',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceCode'
					},{
						id:'InvoiceNo',
						header:'������',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceNo'
					},{
						id : 'IsReward',
						header : '�Ƿ���',
						width : 120,
						editable:false,
						hidden:true,
						allowblank:false,
						dataIndex : 'IsReward'
					},{
						id : 'RewardAmount',
						header : '����(Ԫ)',
						width : 80,
						editable:true,
						allowblank:false,
						align:'right',
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
						width : 80,
						dataIndex : 'RewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
						id:'score',
						header:'����÷�',
						width:120,
						editable:true,
						align:'left',
						hidden:true,
						dataIndex:'score'
					},{
						id:'SubUser',
						header:'������',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'DeptDr',
						header:'�����˿���',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'DeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'����ʱ��',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'AuditStatus',
						header:'���״̬',
						width:150,
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
						width:150,
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
					}, {
							id:'IsLastStep',
							header: '�Ƿ����һ��',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'IsLastStep'
						}
					]
		});


var AuditButton = new Ext.Toolbar.Button({
	text: '�������ͨ��',  
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
		      Ext.Msg.show({title:'ע��',msg:'���ݱ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 
	    var tmpIsLastStep=rowObj[j].get("IsLastStep");
		 //if((rowObj[j].get("Ratio")=="")&&(rowObj[j].get("ChkProcDesc").indexOf("���д�����")>-1)){
		if((rowObj[j].get("Ratio")=="")&&(tmpIsLastStep=="Y")){
			Ext.Msg.show({title:'ע��',msg:'����д��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
								Ext.Msg.show({title:'ע��',msg:'������˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
							}else{
							Ext.Msg.show({title:'����',msg:'�������ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		      Ext.Msg.show({title:'ע��',msg:'���ݱ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else
						{noauditfun();}
					}
					
					
			   }
});
var RewardAuditButton = new Ext.Toolbar.Button({
    id:'RewardAudit',
	text: '�������',  
    iconCls: 'pencil',
    handler:function(){
	//���岢��ʼ���ж���
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	    /* var state=rowObj[j].get("ChkResult");
		//alert(state);
	    if(state!="ͨ��"){
	      Ext.getCmp('RewardAudit').disable();//����Ϊ������
	       return;
	   } */
	   

	   if(rowObj[j].get("IsReward")!='δ����')
		{
		    Ext.Msg.show({title:'ע��',msg:'�������ѽ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
		}

		 if(rowObj[j].get("RewardAmount")==""){
			Ext.Msg.show({title:'ע��',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(rowObj[j].get("RewardDate")==""){
			Ext.Msg.show({title:'ע��',msg:'����ʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
						url:projUrl+'?action=rewardaudit&rowid='+rowObj[i].get("rowid")+'&rewardamount='+RewardAmount+'&RewardDate='+RewardDate,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'������˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
							}else{
							    var ErrMSG="";
							    ErrMSG=jsonData.info;
							    Ext.Msg.show({title:'����',msg:ErrMSG,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//��ϸ��Ϣ
	if (columnIndex == 6) {
		PatentDetail(itemGrid);
	}
	//��������
	if (columnIndex == 9) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("Inventors");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
	var records = itemGrid.getSelectionModel().getSelections();
	var state = records[0].get("ChkResult");
	//alert(state);
	if(state!="ͨ��")
	{
	  Ext.getCmp('RewardAudit').disable();//����Ϊ������
	  return;
	}
	else{
	  Ext.getCmp('RewardAudit').enable();//����Ϊ����
	  return;
	}
}); 

//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'rowid','P005',36);