
var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var userdr=""
	}


var projUrl = 'herp.srm.SRMEnPaperPubRegexe.csp';

// ������ʼʱ��ؼ�
	var startDate = new Ext.form.DateField({
		  id:'startDate',
		  fieldLabel: '��ʼ����',
			width:200,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
	});
	var endDate = new Ext.form.DateField({
		  id:'endDate',
		  fieldLabel: '��������',
			width:200,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
	});
/////////////////��ʼʱ��////////////////////////////
var StartdDateField = new Ext.form.DateField({
		id : 'StartdDateField',
		//format : 'Y-m-d',
		fieldLabel:'��ʼ����',
		width : 120,
		editable:true,
		emptyText : '��ѡ��ʼ����...'
	});

/////////////////����ʱ��////////////////////////////
var EnddDateField = new Ext.form.DateField({
		id : 'EnddDateField',
		//format : 'Y-m-d',
		fieldLabel:'��������',
		width : 120,
		editable:true,
		emptyText : '��ѡ���������...'
	});
//md.formatDate(searchContractDate.getValue())


/////////////////����////////////////////////
var DeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '����',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});


/////////////////������Ŀ
var PaperName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PaperName',
                fieldLabel: '������Ŀ',
                blankText: '������������Ŀ'
            });


/////////////////�ڿ�����
var PeriodiNamDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

PeriodiNamDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('PeriodiNam').getRawValue()),method:'POST'});
});

var PeriodiNam = new Ext.form.ComboBox({
	id: 'PeriodiNam',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:PeriodiNamDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���ڿ�����...',
	name: 'PeriodiNam',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////��һ����
var FisAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

FisAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FisAuthor').getRawValue()),method:'POST'});
});

var FisAuthorField = new Ext.form.ComboBox({
	id: 'FisAuthor',
	fieldLabel: '��һ����',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:FisAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���һ����...',
	name: 'FisAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////ͨѶ����
var ComAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ComAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('ComAuthor').getRawValue()),method:'POST'});
});

var ComAuthorField = new Ext.form.ComboBox({
	id: 'ComAuthor',
	fieldLabel: '��һͨѶ����',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:ComAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���һͨѶ����...',
	name: 'ComAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{

	var startTime= startDate.getValue();
	if (startTime!=="")
    {
       //startTime=startTime.format ('Y-m-d');
    }
	var endTime  = endDate.getValue();
	if (endTime!=="")
    {
       //endTime=endTime.format ('Y-m-d');
    }
        var Dept      = DeptField.getValue();
        var PaperNames= PaperName.getValue();
        var PeriodiNams= PeriodiNam.getRawValue();  
        var FisAuthor = FisAuthorField.getValue();
        var ComAuthor = ComAuthorField.getValue();
        var date = startTime+"|"+endTime+"|"+Dept+"|"+PaperNames+"|"+PeriodiNams+"|"+FisAuthor+"|"+ComAuthor+"|"+userdr 

        itemGrid.load({params:{date:date,sortField:'',sortDir:'',start:0,limit:25}});      
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 130,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:100%">���ı����뽱������</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '����ʱ��:',
				columnWidth : .09
				},startDate,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype:'displayfield',
				value:'��:',
				columnWidth:.03
				},endDate,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '����:',
				columnWidth : .09
				},DeptField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '������Ŀ:',
				columnWidth : .09
				},PaperName,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '�ڿ�����:',
				columnWidth : .09
				},PeriodiNam,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '��һ����:',
				columnWidth : .09
				},FisAuthorField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '��һͨѶ����:',
				columnWidth : .12
				},ComAuthorField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.06
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '��ѯ',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,	
			//atLoad:true,        
			fields : [
			new Ext.grid.CheckboxSelectionModel(
			{    hidden : true,
				editable:false
				
				}
			
			),
			    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RecordType',
						header : '�ڿ�����',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RecordType'
					},{
						id : 'JourLevel',
						header : '�ڿ�����',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'JourLevel'
					},{
						id : 'JName',
						header : ' �ڿ�����',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'JName'
					},{
						id : 'PaperType',
						header : '������� ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'PaperType'
					},{
						id : 'Title',
						header : '������Ŀ ',
						width : 180,
						editable:false,
						allowBlank : false,   
					  renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},           
						dataIndex : 'Title'
					},{
						id : 'CompleteUnit',
						header : '�ڼ���ɵ�λ ',
						width : 120,
						editable:false,
						allowBlank : false,                
						dataIndex : 'CompleteUnit'
					},{
						id : 'RegInfo',
						header : ' �����ҳ',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'RegInfo'
					},{
						id : 'PubYear',
						header : '��',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'PubYear'
					},{
						id : 'Roll',
						header : '��',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Roll'
					},{
						id : 'Period',
						header : '��',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Period'
					},{
						id : 'StartPage',
						header : '��ʼҳ',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'StartPage'
					},{
						id : 'EndPage',
						header : '����ҳ',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'EndPage'
					},{
						id : 'FristAuthor',
						header : ' ��һ����',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'left',
						dataIndex : 'FristAuthor'
					}, {
						id : 'FristAuthorRange',
						header : '��һ��������',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorRange'
					},{
						id : 'FristAuthorDept',
						header : ' ��һ���߿���',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorDept'
					}, {
						id : 'FristAuthorComp',
						header : '��һ���ߵ�λ',
						width : 120,
						align:'right',
						editable:false,
						hidden:true,
						dataIndex : 'FristAuthorComp'
					},{
						id : 'CorrAuthor',
						header : '��һͨѶ����',
						editable:false,
						width : 120,
						dataIndex : 'CorrAuthor'
					},{
						id : 'CorrAuthorRange',
						header : 'ͨѶ��������',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorRange'
					},{
						id : 'CorrAuthorDept',
						header : '��һͨѶ������',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorDept'
					},{
						id : 'CorrAuthorComp',
						header : 'ͨѶ���ߵ�λ',
						editable:false,
						width : 120,
						hidden:true,
						align:'right',
						dataIndex : 'CorrAuthorComp'
					},{
						id : 'AllAuthorInfo',
						header : '��������',
						editable:false,
						width : 120,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex : 'AllAuthorInfo'
					},{
						id : 'AllCorrAuthorInfo',
						header : '����ͨѶ����',
						editable:false,
						width : 120,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex : 'AllCorrAuthorInfo'
					},{
						id : 'IF',
						header : 'Ӱ������',
						hidden:false,
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'IF'
					},{
						id : 'InvoiceCode',
						header : '��Ʊ���� ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceCode'
					},{
						id : 'InvoiceNo',
						header : '��Ʊ���� ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceNo'
					},{
						id : 'PageCharge',
						header : '�����',
						editable:false,
						width : 80,
						dataIndex : 'PageCharge'
					},{
						id : 'UnitMoney',
						header : '���ҵ�λ',
						editable:false,
						width : 80,
						dataIndex : 'UnitMoney'
					},{
						id : 'Ratio',
						header : '��������',
						editable:false,
						//hidden:true,
						width : 80,
						dataIndex : 'Ratio'
					},{
						id : 'REAmount',
						header : 'ʵ�������',
						editable:false,
						width : 80,
						dataIndex : 'REAmount'
					},{
						id : 'RewardAmount',
						header : '�������(Ԫ)',
						editable:false,
						width : 120,
						dataIndex : 'RewardAmount'
					},{
						id : 'SubUser',
						header : '������',
						editable:false,
						width : 120,
						dataIndex : 'SubUser'
					},{
						id : 'DeptName',
						header : '�����˿���',
						editable:false,
						width : 120,
						dataIndex : 'DeptName'
					},{
						id : 'SubDate',
						header : '����ʱ��',
						hidden:false,
						editable:false,
						width : 120,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '�ύ״̬',
						editable:false,
						hidden:false,
						width : 120,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckState',
						header : '����״̬',
						editable:false,
						width : 120,
						dataIndex : 'CheckState'
					},{
						id : 'Desc',
						header : '�������',
						editable:false,
						width : 180,
						dataIndex : 'Desc'
					},{
						id : 'AuthorsInfo',
						header : '��������',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'AuthorsInfo'
					},{
						id : 'CorrAuthorsInfo',
						header : 'ͨѶ��������',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CorrAuthorsInfo'
					}, {
							id:'upload',
							header: 'ԭ��',
							allowBlank: false,
							width:50,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					}, {
							id:'upload1',
							header: '��¼֤��',
							allowBlank: false,
							width:70,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
								//alert(itemGrid1);
							return '<span style="color:blue"><u>����</u></span>';
							//return '<span style="color:gray;cursor:hand">���</span>';
					    } 
					},{
							id:'ESICited',
							header: '�Ƿ�ESI�߱���',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'ESICited'
					}] 

		});
		
/////////////////��Ӱ�ť////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '���',
        tooltip:'���',        
        iconCls:'add',
	handler:function(){
	AddFun();			
	}
	
});

/////////////////�޸İ�ť//////////////////
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
        tooltip:'�޸�',        
        iconCls:'option',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		if(rowObj.length<1){
		 Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 return;
		}
		var state = rowObj[0].get("DataStatus");
		var AuthorInfoID = rowObj[0].get("AuthorsInfo");
		var CorrAuthorInfoID = rowObj[0].get("CorrAuthorsInfo");
		
		
		
		if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )){EditFun(AuthorInfoID,CorrAuthorInfoID);}
		else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
			
	}
	
});

////////////////ɾ����ť/////////////////////
var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var state = rowObj[0].get("DataStatus");
		if(state == "δ�ύ" ){delFun();}
		else {Ext.Msg.show({title:'����',msg:'�������ύ��������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
	}	
});

/////////////////�ύ��ť/////////////////////
var submitButton = new Ext.Toolbar.Button({
		text: '�ύ',
        tooltip:'�ύ',        
        iconCls:'option',
		handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			//////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P00201',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�ԭ�ĸ���!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
		
			var state = rowObj[0].get("DataStatus");
		if(state == "δ�ύ"){submitFun();}
		else {Ext.Msg.show({title:'����',msg:'�������ύ���������ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
	
});
  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);
  //itemGrid.addButton('-');
  //itemGrid.addButton(upLaodButton);

  
    itemGrid.btnAddHide();     //�������Ӱ�ť
    itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť

itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


var date = "|||||||"+userdr;
itemGrid.load({params:{date:date,sortField:'', sortDir:'',start:0,limit:25}});      


// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ������Ŀ
	if (columnIndex == 7) {
		PaperDetail(itemGrid);
	}
	//��������
	if (columnIndex == 23) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("AuthorsInfo");
//		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
//		authorinfo=authorinfo+','+corrauthorinfo;
    var title = records[0].get("Title");
		AuthorInfoList(title,authorinfo);
	}
	if (columnIndex == 24) {
		var records = itemGrid.getSelectionModel().getSelections();
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		//alert(authorinfo);
		var title = records[0].get("Title");
		CorrAuthorInfoList(title,corrauthorinfo);
	}
	
		
	
});

if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addButton.disable();//����Ϊ������
	  delButton.disable();//����Ϊ������
	  submitButton.disable();//����Ϊ������
	  
	
	}
uploadMainFun(itemGrid,'rowid','P00201',41);//ԭ���ϴ�
uploadMainFun(itemGrid,'rowid','P00202',42);//��¼֤���ϴ�
downloadMainFun(itemGrid,'rowid','P00201,P00202',43);//����ԭ�ĺ���¼֤��
