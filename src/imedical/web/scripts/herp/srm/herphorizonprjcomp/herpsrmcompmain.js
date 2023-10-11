var PrjCompletionUrl= 'herp.srm.horizonprjcompletionexe.csp';


///������Դ
var PrjSrcDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['prjtyperowid','prjtypename'])
});
PrjSrcDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:PrjCompletionUrl+'?action=GetPrjType&str='+encodeURIComponent(Ext.getCmp('PrjSrcField').getRawValue()),method:'POST'});
});
var PrjSrcField = new Ext.form.ComboBox({
	id: 'PrjSrcField',
	fieldLabel: '������Դ',
	width:150,
	listWidth :225,
	allowBlank: false,
	store: PrjSrcDs,
	valueField: 'prjtyperowid',
	displayField: 'prjtypename',
	triggerAction: 'all',
	emptyText:'��ѡ�������Դ...',
	name: 'PrjSrcField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

///���⸺����////////////////////////////////
var PrjHeaderDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['headerrowid','headername'])
});
PrjHeaderDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:PrjCompletionUrl+'?action=GetPrjHeader&str='+encodeURIComponent(Ext.getCmp('PrjHeaderField').getRawValue()),method:'POST'});
});
var PrjHeaderField = new Ext.form.ComboBox({
	id: 'PrjHeaderField',
	fieldLabel: '���⸺����',
	width:150,
	listWidth :225,
	allowBlank: false,
	store: PrjHeaderDs,
	valueField: 'headerrowid',
	displayField: 'headername',
	triggerAction: 'all',
	emptyText:'��ѡ����⸺����...',
	name: 'PrjHeaderField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
// ////////////����////////////////////////
var CalDeptDs = new Ext.data.Store({
	    autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['deptrowid', 'deptname'])
		});

CalDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
		  url:PrjCompletionUrl+'?action=GetDepts&str='+encodeURIComponent(Ext.getCmp('CalDeptField').getRawValue()),method:'POST'});
		});
var CalDeptField = new Ext.form.ComboBox({
	id: 'CalDeptField',
	fieldLabel: '����',
	width:100,
	listWidth : 225,
	allowBlank: false,
	store: CalDeptDs,
	valueField: 'deptrowid',
	displayField: 'deptname',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'CalDeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
///��ʼ����
var StartDateField = new Ext.form.DateField({
			id:'startdate',
			//format:'Y-m-d',
			fieldLabel:'��ʼ����',
			width:150,
			//disabled:false,
			editable:true,
			emptyText: '��ѡ��ʼ����...'
		});
		
var EndDateField = new Ext.form.DateField({
			id:'enddate',
			//format:'Y-m-d',
			fieldLabel:'��������',
			width:150,
			//disabled:false,
			editable:true,
			emptyText: '��ѡ���������...'
		});
		
var PrjNameField = new Ext.form.TextField({
			id:'PrjName',
			fieldLabel: '��������',
			allowBlank: false,
			width:150,
			listWidth : 150,
			//emptyText:'����д��������...',
			anchor: '90%'
			//selectOnFocus:'true'
		});
		
		
///��ѯ��ť		itemGrid.load(({params:{start:0, limit:25,Year:Year,Name:Name,DeptNM:DeptNM,Code:Code}}));
var QueryButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'find',
			
			handler : function() {
			var prjstartdate= StartDateField.getRawValue();
      var prjenddate= EndDateField.getRawValue();
			var deptname= CalDeptField.getValue();
			var prjsrc=PrjSrcField.getValue();
			var prjheader=PrjHeaderField.getValue();
			var prjname=PrjNameField.getValue();

		
			PrjCompletionGrid.load(({params:{PrjStDate:prjstartdate,PrjEndDate:prjenddate,SrmDeptDR:deptname,PrjTypeDR:prjsrc,PrjHeadDR:prjheader,PrjName:prjname,start:0,limit:25}}));
			}
		})
	///���ⰴť	
var CheckButton = new Ext.Toolbar.Button({
	text: '����',
	tooltip: '��Ŀ����',
	iconCls: 'add',
	handler: function(){
		//���岢��ʼ���ж���
		var rowObj=PrjCompletionGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�������Ŀ��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			checkfun=function(id){
				if(id=="yes")
				{
					for(var i=0;i<len;i++){
						var rowid = rowObj[i].get("rowid");
						
						Ext.Ajax.request({
							url:PrjCompletionUrl+'?action=Check&RowID='+rowid,
							waitMsg:'������...',
							failure: function(result, request){
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
									Ext.Msg.show({title:'ע��',msg:'�ѽ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}else{
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								PrjCompletionGrid.load("","","","","","",0,25);
							}//,scope: this						
						});
					}
				}
				else{return;}
			};
			Ext.MessageBox.confirm('��ʾ','ȷ����ѡ�е���Ŀ��¼������',checkfun);
		}				
	}
});


///��ѯ����Panel
var PrjCompletionPanel = new Ext.FormPanel({
	height : 150,
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
			value : '<center><p style="font-weight:bold;font-size:150%">��Ŀ����</p></center>',
			columnWidth : 1,
			height : '50'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		    {
					xtype : 'displayfield',
					value : '��Ŀ��ֹʱ��:',
					columnWidth : 0.15
				}, StartDateField,
				{	xtype:'displayfield',
					value:'',
					columnWidth:0.01
				},
				{
					xtype : 'displayfield',
					value : ' �� ',
					columnWidth : 0.03
				}, EndDateField,{
					xtype : 'displayfield',
					value : '',
					columnWidth : 0.08
				},{
					xtype : 'displayfield',
					value : '����:',
					columnWidth : 0.07
				}, CalDeptField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : 0.08
				}, {
					xtype : 'displayfield',
					value : '������Դ:',
					columnWidth : 0.12
				},PrjSrcField
			]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '���⸺����:',
					columnWidth : .11
				}, PrjHeaderField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .06
				},{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .09
				}, PrjNameField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .08
				},QueryButton,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				},CheckButton
				]
		}	
	]	
	});
	

///PrjCompletionGrid
///rowid^deptname^prjname^prjheader^prjparticipant^prjsource^prjrelyunit^prjapplyfund^prjgrafund^prjno^prjauditdate^prjstartdate^prjenddate^prjremark
var PrjCompletionGrid = new dhc.herp.Grid({
    //title: '��Ŀ����',
    //width:400,
    // edit:false, //�Ƿ�ɱ༭
    //readerModel:'local',
    region: 'center',
    xtype:'grid',
    atLoad : true, // �Ƿ��Զ�ˢ��
   // autoScroll : true,
    loadMask: true,
    url: PrjCompletionUrl,
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        hidden: true,
        dataIndex: 'rowid'
        
    },{
        id:'deptname',
        header: '����',
        dataIndex: 'deptname',
        width:100,
        update:true,
		    editable:false,
		    hidden: false
    },{ 
        id:'prjname',
        header: '��������',
        dataIndex: 'prjname',
        width:100,
        update:true,
		    editable:false,
		    hidden: false
    }, {
        id:'prjheader',
        header: '��Ŀ������',
		    width:100,
		    editable:false,
        dataIndex: 'prjheader'
    }, {
        id:'prjparticipant',
        header: '����μ���Ա',
        width:150,
        editable:true,
        dataIndex: 'prjparticipant',
        allowBlank: true,
        hidden: false
    }, {
        id:'prjsource',
        header: '������Դ',
        width:120,
		    allowBlank: true,
		    editable:false,
        dataIndex: 'prjsource',
        hidden: false
    }, {
        id:'prjrelyunit',
        header: '�������е�λ',
        width:180,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjrelyunit',
        hidden: false
    },{
        id:'prjapplyfund',
        header: '���뾭�ѣ���Ԫ��',
        width:120,
        align:'right',
        xtype:'numbercolumn',
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjapplyfund',
        hidden: false
    },{
        id:'prjgrafund',
        header: '��׼���ѣ���Ԫ��',
        width:120,
        align:'right',
        xtype:'numbercolumn',
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjgrafund',
        hidden: false
    },{
        id:'prjno',
        header: '������',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjno',
        hidden: false
    },{
        id:'prjauditdate',
        header: '�����´�ʱ��',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjauditdate',
        hidden: false
    },{
        id:'prjstartdate',
        header: '��ʼʱ��',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjstartdate',
        hidden: false
    },{
        id:'prjenddate',
        header: '��ֹʱ��',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjenddate',
        hidden: false
    },{
        id:'prjremark',
        header: '��ע',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjremark',
        hidden: false
    },{
        id:'prjcompreport',
        header: '���ⱨ��',
        width:500,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjcompreport',
        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:purple;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
        hidden: false
    }
	]
//, viewConfig : {forceFit : true}
});
/**
//����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 
	var records = itemGrid.getSelectionModel().getSelections();
	var detailID = records[0].get("rowid")
	
	// ά������
	if(detailID!=""){
	if (columnIndex == 7) {
//		var records = itemGrid.getSelectionModel().getSelections();
//		var detailID = records[0].get("rowid")

		// ά������ҳ��
		DetailFun(detailID);
	}
}
})
**/
PrjCompletionGrid.btnAddHide();  //�������Ӱ�ť
PrjCompletionGrid.btnSaveHide();  //���ر��水ť
PrjCompletionGrid.btnResetHide();  //�������ð�ť
PrjCompletionGrid.btnDeleteHide(); //����ɾ����ť
PrjCompletionGrid.btnPrintHide();  //���ش�ӡ��ť


PrjCompletionGrid.on('cellclick', function(g, rowIndex, columnIndex, e){
	  
	    if (columnIndex == 16) {
			var records = PrjCompletionGrid.getSelectionModel().getSelections();
			var PrjInfoRowID   = records[0].get("rowid");
			alert(PrjInfoRowID)
	}
});
