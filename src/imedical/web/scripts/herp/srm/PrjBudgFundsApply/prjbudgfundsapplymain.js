var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
/* if (groupdesc==srmrdgroupdesc)
{  usercode=""
} */
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{  usercode=""
}	
var prjbudgfundsURL='herp.srm.prjbudgfundsapplyexe.csp';
	
//��ѯ���
var yearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:prjbudgfundsURL+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '���',
	width:120,
	listWidth : 260,
	//allowBlank: false,
	store: yearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//��Ŀ����  prjtypelist
var propertyStore = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


propertyStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:prjbudgfundsURL+'?action=prjtypelist&str='+encodeURIComponent(Ext.getCmp('propertycomb').getRawValue()),method:'POST'});
});

var propertycomb = new Ext.form.ComboBox({
	id: 'propertycomb',
	fieldLabel: '���',
	width:120,
	listWidth : 260,
	//allowBlank: false,
	store: propertyStore,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	//emptyText:'��ѡ����Ŀ����...',
	name: 'propertycomb',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////��Ŀ����////////////////
var ProjectName = new Ext.form.TextField({
			//columnWidth : .1,
			width : 120,
			//emptyText:'��Ŀ���ƻ����...',
			//columnWidth : .15,
			selectOnFocus : true
		});
		
var searchButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    //tooltip:'��ѯ',        
    iconCls: 'search',
	handler:function(){
	
	var year=yearField.getValue();
	var prjcode=ProjectName.getValue();
	var prjtype = propertycomb.getValue();  
	
	/* if (groupdesc==srmrdgroupdesc)
	{  usercode=""
	} */
	if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
	{  usercode=""
	}
	
	prjbudgfundsGrid.load(({params:{year:year,prjtype:prjtype,prjcode:prjcode,usercode:usercode,start:0, limit:25}}));
	}
});


var prjbudgfundsGrid = new dhc.herp.Gridlyfmain({
	title: '��Ŀ���ѱ�����Ϣ�б�',
			iconCls: 'list',
    region : 'north',
    url: prjbudgfundsURL,
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false,singleSelect:true}),
    {
        id:'rowid',
        header: '��ĿID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'yeardr',
        header: '���dr',
        dataIndex: 'yeardr',
        width:60,
		hidden:true,
		editable:false
    },{
        id:'year',
        header: '���',
        dataIndex: 'year',
        width:60,
		editable:false
    },{ 
        id:'code',
        header: '��Ŀ����',
        dataIndex: 'code',
        width:100,
		editable:false
    },{
        id:'name',
        header: '��Ŀ����',
        dataIndex: 'name',
        width:180,
        editable:false,
renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}		
    },{
        id:'deptdr',
        header: '���ο���',
        width:100,
		editable:false,
        dataIndex: 'deptdr',	
        hidden: true
    },{
        id:'deptname',
        header: '���ο���',
        dataIndex: 'deptname',
        width:120,
		//tip:true,
		editable:false,
		renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
    },{
        id:'headdr',
        header: '��Ŀ������ID',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'headdr',	
        hidden: true
    }, {
        id:'head',
        header: '��Ŀ������',
        width:80,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'head'
    },{
	    id:'subsourse',
    	header: '��Ŀ��Դ',
        dataIndex: 'subsourse',
        width: 180,		
        hidden:false,  
        editable:false
    },{
    	id:'grafunds',
        header: '��׼����(��Ԫ)',
        width:100,
	    editable:false,
	    xtype:'numbercolumn',
	    align:'right',
        dataIndex: 'grafunds',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
    	id:'fundown',
        header: '�Գ��ʽ�(��Ԫ)',
        width:80,
        align:'right',
		hidden:true,
        xtype:'numbercolumn',
	    allowBlank: true,
        dataIndex: 'fundown'
    },{
    	id:'fundgov',
        header: '��������(��Ԫ)',
        width:80,
		hidden:true,
	    align:'right',
	    allowBlank: true,
	    xtype:'numbercolumn',
        dataIndex: 'fundgov'
    },{
       id:'prjstatus',
       header: '��Ŀ״̬',
       width:100,
	   //hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: 'prjstatus'
  },{
       id:'prjstatusindex',
       header: '��Ŀ״̬id',
       width:100,
	   hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: '��Ŀ״̬id'
  },{
       id:'resaudit1',
       header: '���״̬',
       width:100,
	   hidden:true,  
	   allowBlank: true,
	   editable:false,
       dataIndex: 'resaudit1'
  },{           
       id:'sedate',
       header: '��ֹʱ��',
       allowBlank: false,
       width:150,
       editable:false,
       dataIndex: 'sedate'
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
		}],
	layout:"fit",
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	//loadMask : true,
	tbar:['','�������','',yearField,'','��Ŀ����','',propertycomb,'','��Ŀ����','',ProjectName,'-',searchButton],
    //atLoad : true, // �Ƿ��Զ�ˢ��
	height:300,
	trackMouseOver: true,
	stripeRows: true

});

/* if (groupdesc==srmrdgroupdesc)
{  usercode=""
} */
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{  usercode=""
}
	
prjbudgfundsGrid.load({	
	params:{start:0, limit:25,usercode:usercode}
});

var row="";

prjbudgfundsGrid.on('rowclick',function(grid,rowIndex,e){	
	row=rowIndex;
    var prjdr="";
	var selectedRow = prjbudgfundsGrid.getSelectionModel().getSelections();
	prjdr=selectedRow[0].data['rowid'];
	//alert(usercode);
	prjbudgfundsDetail.load({params:{start:0, limit:25,prjdr:prjdr,usercode:session['LOGON.USERCODE']}});	
});

//uploadMainFun(itemGrid,'rowid','P004',9);
downloadMainFun(prjbudgfundsGrid,'rowid','P007',19);