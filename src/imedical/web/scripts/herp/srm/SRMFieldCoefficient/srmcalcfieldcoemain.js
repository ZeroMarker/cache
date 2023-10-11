
var FieldCoefficientUrl='herp.srm.fieldcoefficientexe.csp';


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

///////////////////��/////////////////////////////  
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:FieldCoefficientUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '��',
	width:120,
	listWidth : 260,
	//allowBlank : false, 
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	//emptyText:'��ѡ��ʼʱ��...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//ϵͳģ���
var SysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModListField').getRawValue()),
						method : 'POST'
					});
		});
var SysModListField = new Ext.form.ComboBox({
            id:'SysModListField',
			name:'SysModListField',
			fieldLabel : 'ϵͳģ��',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : SysModListDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: '����',
	  width:120,
    //allowBlank: false,
    //emptyText:'����...',
    anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '����',
	  width:120,
    //allowBlank: false,
    //emptyText:'����...',
    anchor: '95%'
	});
//ϵͳģ���
var SysModDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModField').getRawValue()),
						method : 'POST'
					});
		});
var SysModField = new Ext.form.ComboBox({
            id:'SysModField',
			name:'SysModField',
			fieldLabel : 'ϵͳģ��',
			width : 150,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : SysModDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/**
//�Ƿ��������ֶι���
var IsComprehensiveDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var IsComprehensiveField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ��������ֶι���',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsComprehensiveDs,
			//anchor : '90%',
			value:'1', //Ĭ��ֵ
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
**/
//���㷽��
var CalcMethodDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����ϵ����'], ['2', '��ʽ��'], ['3', '�ȱȲ�����'], ['4', '�ǵȱȲ�����'], ['5', '�оٷ�']]
		});
var CalcMethodField = new Ext.form.ComboBox({
			fieldLabel : '���㷽��',
			width : 150,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : CalcMethodDs,
			//anchor : '90%',
			value:'1', //Ĭ��ֵ
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
/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'search',
	handler: function(){
	    var year = YearField.getValue();
		var sysno = SysModListField.getValue();
		var code = CodeField.getValue();
		var name = NameField.getValue();
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
			year:year,
			SysNO:sysno,
		    Code: code,
		    Name: name
		   }
	  })
  }
});

// ///////////////////////////////////////////
var addButton = new Ext.Toolbar.Button({
			text : '����',
			iconCls : 'edit_add',
			handler : function() {
				FieldCoefficientAddFun();
			}
		});

var editButton = new Ext.Toolbar.Button({
			text : '�޸�',
			//tooltip : '�޸�',
			iconCls : 'pencil',
			handler : function() {
				FieldCoefficientEditFun();
			}
		});

var delButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'edit_remove',
	handler : function() {
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";

		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ���ļ�¼!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
				if (btn == 'yes') {
					Ext.Ajax.request({
						url : FieldCoefficientUrl + '?action=del&rowid=' + tmpRowid,
						waitMsg : 'ɾ����...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								itemGrid.load({
											params : {
												start : 0,
												limit : 25
											}
										});
							} else {
								Ext.Msg.show({
											title : '����',
											msg : '����',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				}
			})
		}
	}
});
//���ư�ť
var CopyButton = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'�����������ݵ������',       
    id:'CopyButton', 
    iconCls:'copy',
	handler:function(){
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
						url:FieldCoefficientUrl+'?action=copy',
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'���Ƴɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25}});
							}else{
							    var err=jsonData.info;
								Ext.Msg.show({title:'����',msg:err,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{return;}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����������ݵ��������?',handler);
	}
});
var itemGrid = new dhc.herp.Grid({
        title: '�ֶ�ϵ��ά���б�',
		iconCls: 'list',
        width: 400,
        edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: FieldCoefficientUrl,	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
            hidden: true
        },{
            id:'Year',
            header: '���',
			width:80,
            dataIndex: 'Year'
			//type:YearField
        },{
            id:'SysNO',
            header: 'ϵͳģ��',
			width:120,
            dataIndex: 'SysNO'
			//type:SysModField
        },{
            id:'Code',
            header: '�ֶα���',
			width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '�ֶ�����',
			width:150,
            dataIndex: 'Name'
        },{
            id:'CalcMethod',
            header: '���㷽��',
			allowBlank: true,
			width:100,
			hidden:false,
            dataIndex: 'CalcMethod'
        },{
            id:'CoefficientType',
            header: 'ϵ������',
			editable:true,
			width:100,
            dataIndex: 'CoefficientType'
        },{
            id:'DefaultValue',
            header: 'Ĭ��ֵ',
			editable:true,
			width:100,
			align:'left',
            dataIndex: 'DefaultValue'
         
        },{
            id:'FourmulaDesc',
            header: '��ʽ����',
			editable:true,
			width:100,
            dataIndex: 'FourmulaDesc'
        },{
            id:'FieldValue',
            header: '�ֶζ�Ӧֵ',
			editable:true,
			width:180,
			align:'left',
            dataIndex: 'FieldValue'
        },{
            id:'FieldMinValue',
            header: '�ȱ���Сֵ',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'FieldMinValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'FieldMaxValue',
            header: '�ȱ����ֵ',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'FieldMaxValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'StepSize',
            header: '�ȱȲ���',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'StepSize',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'IntervalCoefficient',
            header: '�ȱ�ϵ��',
			editable:true,
			width:80,
			align:'right',
            dataIndex: 'IntervalCoefficient',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'MinValue',
            header: '�ǵȱ���Сֵ',
			editable:true,
			width:100,
			align:'right',
            dataIndex: 'MinValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'MaxValue',
            header: '�ǵȱ����ֵ',
			editable:true,
			width:100,
			align:'right',
            dataIndex: 'MaxValue',
			renderer: function(val) 
			{
       			var val = Ext.util.Format.number(val,'0.00');
				return format(val);
    		}
        },{
            id:'Coefficient',
            header: 'ϵ��',
			editable:true,
			width:180,
			align:'left',
            dataIndex: 'Coefficient'
        },{
            id:'CoefficientDesc',
            header: 'ϵ������',
			hidden:true,
			editable:true,
			width:180,
            dataIndex: 'CoefficientDesc'
        }],
        tbar :['','���','',YearField,'','ϵͳģ��','',SysModListField,'','�ֶα���','', CodeField,'','�ֶ�����','',NameField,'-',findButton,'-',addButton,'-',editButton,'-',delButton,'-',CopyButton]
});

   itemGrid.btnResetHide();  //�������ð�ť
   itemGrid.btnPrintHide();  //���ش�ӡ��ť
   itemGrid.btnAddHide();  //�������Ӱ�ť
   itemGrid.btnDeleteHide();  //����ɾ����ť
   itemGrid.btnSaveHide();  //�����޸İ�ť
   
  //itemGrid.load({	params:{start:0, limit:25}});
