
var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];
var prjbudgfundsURL='herp.srm.prjbudgfundsapplyexe.csp';

var rnt="";

		
//Ԥ��������
var BIDNameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

BIDNameDs.on('beforeload', function(ds, o){
	var selectedRow = prjbudgfundsGrid.getSelectionModel().getSelections();
	var year=selectedRow[0].data['yeardr'];
	ds.proxy=new Ext.data.HttpProxy({
		url: prjbudgfundsURL+'?action=itemname&year='+year,method:'POST'});
		});
var BIDNameField = new Ext.form.ComboBox({
	id: 'BIDNameField',
	fieldLabel: '���ѿ�Ŀ����',
	width:120,
	listWidth : 260,
	store: BIDNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'���ѿ�Ŀ����...',
	name: 'BIDNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

///��Ŀ������Դ 
var FundsSourceDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '�����ѧ��ҵ��֧��'],['2', '�в�������ר���ʽ𲦿�'],['3', '��λ�Գ�'],['4', '���ҡ�ʡר���'],
		['5', '���д���'],['6', '����']]
	});		
		
var FundsSourceCombox = new Ext.form.ComboBox({
	                   id : 'FundsSourceCombox',
		           fieldLabel : '������Դ',
	                   width : 260,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : FundsSourceDs,			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           selectOnFocus : true,
		           forceSelection : true
});		

var AuditButton  = new Ext.Toolbar.Button({
		text : 'ͨ��',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//���岢��ʼ���ж���
		var rowObj=prjbudgfundsDetail.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		var CheckDesc= rowObj[0].get("checkdesc")
		
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("checkstate")!="�ȴ�����")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					Ext.Ajax.request({
					url:'herp.srm.prjbudgfundsauditexe.csp'+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&userdr='+checker,
					waitMsg:'�����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							prjbudgfundsDetail.load({params:{start:0,limit:12,usercode:checker}});
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


  var NoAuditButton = new Ext.Toolbar.Button({
					text : '��ͨ��',
					iconCls: 'pencil',
					handler : function() {
						var rowObj=prjbudgfundsDetail.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("checkstate")!="�ȴ�����")
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }else{noauditfun();}
						}
						
						
				   }
  });


var prjbudgfundsDetail = new dhc.herp.Gridlyf({
	title : '��Ŀ���ѱ��������ϸ��Ϣ�б�',
	iconCls : 'list',
    region : 'center',
    url: 'herp.srm.prjbudgfundsauditexe.csp',
    fields: [
       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '���о��ѱ���ID',
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'prjrowid',
        header: '��ĿID',
        dataIndex: 'prjrowid',
        width:90,
        allowBlank: true,
		hidden: true
    },{ 
        id:'itemdr',
        header: '���ѿ�Ŀdr',
        dataIndex: 'itemdr',
        width:80,
        editable:false,
		hidden:true
    },{ 
        id:'itemcode',
        header: '���ѿ�Ŀ����',
        dataIndex: 'itemcode',
        width:100,
        editable:false
    }, {
        id:'itemlevel',
        header: '���ѿ�Ŀ����',
        width:100,
        editable:false,
        dataIndex: 'itemlevel',
        hidden: true
		
    }, {
        id:'itemname',
        header: '���ѿ�Ŀ����',
        width:100,
		//tip:true,
		allowBlank: false,
        dataIndex: 'itemname',
		editable:false,
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
        type: BIDNameField
		
    },{
        id:'bidislast',
        header: '�Ƿ�ĩ��',
        width:100,
		//tip:true,
		allowBlank: true,
        dataIndex: 'bidislast',
        hidden: true
    },{
        id:'budgvalue',
        header: '���ƽ��(��Ԫ)',
        width:100,       
        align:'right',
		editable:false,
        //xtype:'numbercolumn',
        dataIndex: 'budgvalue',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
        id:'fundsourcedr',
        header: '������Դdr',
        width:140,
		allowBlank: true,
        dataIndex: 'fundsourcedr',
		editable:false,
		hidden:true
    },{
        id:'fundsource',
        header: '������Դ',
        width:180,
		allowBlank: true,
		editable:false,
        dataIndex: 'fundsource',
		type:FundsSourceCombox
    },{
    	id:'budgdesc',
        header: '����˵��',
        width:100,
		editable:false,
        dataIndex: 'budgdesc'
    },{
    	id:'bottomline',
        header: '���ռ��(%)',
        width:100,
        align:'right',
		editable:false,
        dataIndex: 'bottomline',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
    	id:'toppercent',
        header: '���ռ��(%)',
        width:100,
        align:'right',
		editable:false,
        dataIndex: 'toppercent',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
    	id:'subuser',
        header: '������',
        width:60,
		editable:false,
        dataIndex: 'subuser'
    },{
    	id:'subdate',
        header: '����ʱ��',
        width:80,
		editable:false,
        dataIndex: 'subdate'
    },{
    	id:'datastatus',
        header: '״̬',
		editable:false,
        width:60,
        dataIndex: 'datastatus'
    },{
    	id:'checkstate',
        header: '�������',
        width:100,
		editable:false,
        dataIndex: 'checkstate'
    },{
    	id:'checkdesc',
        header: '����˵��',
		editable:false,
        width:180,
        dataIndex: 'checkdesc'
    },{
    	id:'sysno',
        header: 'ϵͳ��',
		editable:false,
        width:80,
		hidden:true,
        dataIndex: 'sysno'
    },{
    	id:'isapproval',
        header: '�Ƿ���Ҫ������',
		editable:false,
        width:80,
		hidden:true,
        dataIndex: 'isapproval'
    }]		
});

prjbudgfundsDetail.hiddenButton(0)
prjbudgfundsDetail.hiddenButton(1);
prjbudgfundsDetail.hiddenButton(2);

prjbudgfundsDetail.addButton('-');
prjbudgfundsDetail.addButton(AuditButton);
prjbudgfundsDetail.addButton('-');
prjbudgfundsDetail.addButton(NoAuditButton);