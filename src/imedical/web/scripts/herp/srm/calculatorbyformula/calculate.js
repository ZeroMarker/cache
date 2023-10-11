var data="";
var monthStore="";


function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};


//Ext.Ajax.timeout=90000000000000; ������������ȡ��
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'herp.srm.calculatorbyformulaexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue(),method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'���',
	width:120,
	listWidth : 250,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var calcuPanel = new Ext.form.FormPanel({
		title:'���м������',
		region:'north',
		frame:true,
		autoHeight : true,
		iconCls:'calc',
		items:[{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.0,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '�� ���м���---������� ��'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
					{width:60,xtype:'displayfield',value: '<p style="text-align:right;">���</p>'},
					cycleField,
                    { xtype : 'displayfield',width : 30},
					{width:30,xtype:'button',text: '�������',name: 'bc'
					,handler:function(){pointcalcu()},iconCls: 'calc'}
				]
			}]
});
pointcalcu = function(){
              var year = cycleField.getValue(); 
			  if (year=="")
			  {
			  Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
			  }
	    Ext.Ajax.request({
		url: 'herp.srm.calculatorbyformulaexe.csp?action=calu&year='+year,
		waitMsg:'������...',
		failure: function(result, request){
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
								else
								{
								Ext.Msg.show({title:'ע��',msg:'�����¼���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
			}
		},
		scope: this
	});
}


var projUrl='herp.srm.calculatorbyformulaexe.csp';
/////////////////���//////////////////

var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=getyear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
	method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '���',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/////////////////����//////////////////

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=getdept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
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
	//emptyText:'��ѡ�����...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{"select":function(combo,record,index){ 
			UserDs.removeAll();  
           	UserField.setValue('');
            UserDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=getdeptuser&deptdr='+DeptField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('UserField').getRawValue()),method:'POST'});
		    UserDs.load({params:{start:0,limit:10}});  
			        }}   
});
/////////////////������Ա//////////////////

var UserDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['userid','username'])
});


UserDs.on('beforeload', function(ds, o){
	var deptdr=DeptField.getValue();	
	if(!deptdr){
		Ext.Msg.show({title:'ע��',msg:'����ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
});

var UserField = new Ext.form.ComboBox({
	id: 'UserField',
	fieldLabel: '������Ա',
	width:120,
	listWidth : 250,
	allowBlank: true,
	store:UserDs,
	valueField: 'userid',
	displayField: 'username',
	triggerAction: 'all',
	//emptyText:'��ѡ�������Ա...',
	name: 'UserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	//tooltip: '��ѯ',
	iconCls: 'search',
	handler: function(){
	    
		var year = YearField.getValue();
		var deptdr = DeptField.getValue();
	    var userdr = UserField.getValue();
		if(year==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
		}
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    year: year,
		    deptdr: deptdr,
			userdr:userdr
		   }
	  })
  }
});
var itemGrid = new dhc.herp.Grid({
        title: '���м����ѯ�б�',
		iconCls: 'list',
        edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.calculatorexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            id:'usercode',
            header: '��������',
			      allowBlank: false,
			      width:100,
            dataIndex: 'usercode'
        },{
            id:'username',
            header: '����',
			      allowBlank: false,
			      width:100,
            dataIndex: 'username'
        },{
            id:'deptname',
            header: '��������',
			      allowBlank: false,
			      width:150,
            dataIndex: 'deptname'
        },{
            id:'achpoint',
            header: '���л񽱼���',
			      allowBlank: false,
			      width:120,
            dataIndex: 'achpoint',
			align:'right',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'prjpoint',
            header: '���������',
			      allowBlank: false,
			      width:120,
				  align:'right',
            dataIndex: 'prjpoint',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'paperpoint',
            header: '���ļ���',
			      allowBlank: false,
			      width:120,
				  align:'right',
            dataIndex: 'paperpoint',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'mpoint',
            header: '��������',
			      allowBlank: false,
			      width:120,
				  align:'right',
            dataIndex: 'mpoint',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'patentpoint',
            header: 'ר������',
			      allowBlank: false,
			      width:120,
				  align:'right',
            dataIndex: 'patentpoint',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'sumpoint',
            header: '�ܼ���',
			      allowBlank: false,
			      width:120,
				  align:'right',
            dataIndex: 'sumpoint',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        }],
		tbar :['','���','', YearField,'','����','', DeptField,'','������Ա','',UserField,'-',findButton]
});
  
    itemGrid.btnAddHide();     //�������Ӱ�ť
    itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť

