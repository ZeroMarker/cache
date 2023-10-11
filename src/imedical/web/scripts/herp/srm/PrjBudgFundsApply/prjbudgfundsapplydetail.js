
var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];

var prjbudgfundsURL='herp.srm.prjbudgfundsapplyexe.csp';

var rnt="";

var year=""
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
	editable:true ,
	listeners:{"expand":function(combo,record,index){ 
			/* alert("aaaa");
		    combo.load='2';	 */
	}}  
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

/////////////////�ύ��ť/////////////////////
var submitButton = new Ext.Toolbar.Button({
		id:'submitButton',
		text: '�ύ',
        //tooltip:'�ύ',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = prjbudgfundsDetail.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			var state = rowObj[0].get("datastatus");
			var tmprowid = rowObj[0].get("rowid");
			if (tmprowid==""){
				Ext.Msg.show({title:'ע��',msg:'���ȱ����������ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if(state == "δ�ύ"){
				var rowObj = prjbudgfundsDetail.getSelectionModel().getSelections();     // get the selected items
				var len = rowObj.length;
				if(len > 0)
				{  
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����', function(btn) 
					{
						if(btn == 'yes')
						{	
							if(rowObj[0].get("datastatus")!="���ύ"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: prjbudgfundsURL+'?action=submit&rowid='+rowObj[i].get("rowid")+'&userdr='+usercode+'&sysno='+rowObj[i].get("sysno"),
										waitMsg:'�ύ��...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
												Ext.MessageBox.alert('��ʾ', '�ύ���');
												prjbudgfundsDetail.load({params:{start:0, limit:25}});
											}
											else {
												var message = "�ύʧ��";
												Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
										scope: this
									});
								}
							}else{
								Ext.Msg.show({title:'����',msg:'��ѡ��������ύ���������ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								//return;
							}
						}
					});	
				}
				else
				{
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}    
			}
			else {Ext.Msg.show({title:'����',msg:'�������ύ���������ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
});


//////////////////////////�ж��Ƿ���Ҫ������///////////////////////////
/* Ext.Ajax.request({
	url:prjbudgfundsURL+'?action=GetIsApproval&sysno='+'P012',
	success: function(result, request){
		var jsonData = Ext.util.JSON.decode( result.responseText );				
		if (jsonData.success=='true'){				
			rnt = jsonData.info;
			if(rnt=="Y")
			{
				Ext.getCmp('submitButton').show();
				prjbudgfundsDetail.addButton('-');
				prjbudgfundsDetail.addButton(submitButton);
			}
			else{
				Ext.getCmp('submitButton').hide();
			}
		}
	},
	scope: this			
}); */
///////////////////////////////////////


var prjbudgfundsDetail = new dhc.herp.Gridlyf({
    title: '��Ŀ���ѱ�����ϸ��Ϣ�б�',
			iconCls: 'list',
    region : 'center',
    url: prjbudgfundsURL,
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
        editable:true,
        dataIndex: 'itemlevel',
        hidden: true
		
    }, {
        id:'itemname',
        header: '���ѿ�Ŀ����',
        width:100,
		//tip:true,
		allowBlank: false,
        dataIndex: 'itemname',
		/* renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		}, */
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
        //xtype:'numbercolumn',
        /*
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
		*/
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
		hidden:true
    },{
        id:'fundsource',
        header: '������Դ',
        width:180,
		allowBlank: true,
        dataIndex: 'fundsource',
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
		type:FundsSourceCombox
    },{
    	id:'budgdesc',
        header: '����˵��',
        width:100,
        /*
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
		*/
        dataIndex: 'budgdesc'
    },{
    	id:'bottomline',
        header: '���ռ��(%)',
        width:100,
		editable:false,
		align:'right',
        dataIndex: 'bottomline',
        renderer: function(val) 
		{
       		return Ext.util.Format.number(val,'0.00');
 		}
    },{
    	id:'toppercent',
        header: '���ռ��(%)',
        width:100,
		editable:false,
		align:'right',
        dataIndex: 'toppercent',
        renderer: function(val) 
		{
       		return Ext.util.Format.number(val,'0.00');
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
    	id:'checkresult',
        header: '�������',
        width:180,
		editable:false,
        dataIndex: 'checkresult'
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
    }/* ,{
    	id:'isapproval',
        header: '�Ƿ���Ҫ������',
		editable:false,
        width:80,
		hidden:true,
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				if(value=="Y")  //��Ҫ������
				{
					prjbudgfundsDetail.getColumnModel().setHidden(17,false);
					prjbudgfundsDetail.getColumnModel().setHidden(18,false);
					prjbudgfundsDetail.getColumnModel().setHidden(19,false);
					Ext.getCmp('submitButton').show();
				}
				else  //����Ҫ������
				{
					prjbudgfundsDetail.getColumnModel().setHidden(17,true);
					prjbudgfundsDetail.getColumnModel().setHidden(18,true);
					prjbudgfundsDetail.getColumnModel().setHidden(19,true);
					Ext.getCmp('submitButton').hide();
				}
		},
        dataIndex: 'isapproval'
    } */]		
});

/* if(rnt=="Y")
{
	alert("aaa");
	Ext.getCmp('submitButton').show();
	prjbudgfundsDetail.addButton('-');
	prjbudgfundsDetail.addButton(submitButton);
}else{
	Ext.getCmp('submitButton').hide();
} */

//prjbudgfundsDetail.addButton('-');
prjbudgfundsDetail.addButton(submitButton);