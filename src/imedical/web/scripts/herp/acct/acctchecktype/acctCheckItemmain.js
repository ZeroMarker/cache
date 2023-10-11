
var acctCheckItemUrl = '../csp/herp.acct.acctcheckitemexe.csp';

//�����������
var TypeNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

TypeNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url: acctCheckItemUrl+'?action=gettypename'});
		});

var TypeNameField = new Ext.form.ComboBox({
	id: 'TypeNameField',
	fieldLabel: '�����������',
	width:120,
	//listWidth : 245,
	// allowBlank: false,
	store: TypeNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'�����������...',
	name: 'TypeNameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});

var acctCheckItemGrid = new dhc.herp.Grid({
    title: '���������',
    region : 'east',
    width: 400,
    /**minSize : 300,
	  maxSize : 300,
	  height:300,
	  autoScroll:true,
	  collapsible:true,
	  border:true,
	  layoutConfig:{animate:true},
	  loadMask: true,
	  width : 400,
	  minSize : 350,
	  maxSize : 450,
	  height:225,
	  **/
    atLoad : true, // �Ƿ��Զ�ˢ��
    url: 'herp.acct.acctcheckitemexe.csp',
    fields: [
       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
    	  header: 'ID',
        id:'rowid',
        editable:false,
        dataIndex: 'rowid',
        hidden: true,
        print:false
    },{
    	  header: '�����������',
        id:'typename',
        dataIndex: 'typename',
        width:90,
        allowBlank: false,
		    type:TypeNameField
    },{ 
    	  header: '��Ŀ����',
        id:'itemcode',
        dataIndex: 'itemcode',
        width:150,
        allowBlank: false,
        editable:true,
		    hidden: false
    }, {
    	  header: '��Ŀ����',
        id:'itemname',
        width:90,
        editable:true,
        allowBlank: true,
        dataIndex: 'itemname'
    }],
	 viewConfig : {
		forceFit : true
	}
});










