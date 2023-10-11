/**
  *name:
  *author:Zhaoliguo
  *Date:2016-1-5
 */
 var userCode = session['LOGON.USERCODE'];
 var userName = session['LOGON.USERNAME'];
 var userID = session['LOGON.USERID'];
 
 //��û�ƺ�������  zhaoliguo 2016-1-7
 //var frm = dhcsys_getmenuform();  //���˵����÷�����websys.js��
 var frm = dhcsys_getsidemenuform(); //��˵����÷�����websys.js��
 var currBookName= frm.AcctBookName.value ; 
 var currBooID= frm.AcctBookID.value ; 

var TargetTypeTabUrl = '../csp/herp.acct.acctbookidexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ

var TargetTypeTabProxy= new Ext.data.HttpProxy({url:TargetTypeTabUrl + '?action=list&bookid='+currBooID});
var TargetTypeTabDs = new Ext.data.Store({
	proxy: TargetTypeTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'loginDesc'
		,'BookName',
		'Username',
		'LoginDate'

	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
TargetTypeTabDs.setDefaultSort('rowid', 'name');

//���ݿ�����ģ�� "rowid^BookName^Username^LoginDate"
var TargetTypeTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '<div style="text-align:center">��¼˵��</div>',
        dataIndex: 'loginDesc',
        width: 100,		  
        sortable: true
    },{
    	header: '<div style="text-align:center">�û�����<div>',
        dataIndex: 'Username',
        width: 100,		  
        sortable: true
    },{
    	header: '<div style="text-align:center">�������<div>',
        dataIndex: 'BookName',
        width: 200,
        sortable: true
    },{
    	header: '<div style="text-align:center">��¼ʱ��</div>',
        dataIndex: 'LoginDate',
        width: 200,
        sortable: true
    }
    
]);

//��ʼ��Ĭ��������
TargetTypeTabCm.defaultSortable = true;


//��ʼ�������ֶ�
var TargetTypeSearchField ='name';

/*//����������
var TargetTypeFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'code',
			checked: false ,
			group: 'TargetTypeFilter',
			checkHandler: onTargetTypeItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'name',
			checked: true,
			group: 'TargetTypeFilter',
			checkHandler: onTargetTypeItemCheck 
		})
	]}
});

//����������Ӧ����
function onTargetTypeItemCheck (item, checked){
	if(checked) {
		TargetTypeSearchField = item.value;
		TargetTypeFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var TargetTypeSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			TargetTypeTabDs.proxy = new Ext.data.HttpProxy({url:  TargetTypeTabUrl + '?action=list'});
			TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				TargetTypeTabDs.proxy = new Ext.data.HttpProxy({
				url: TargetTypeTabUrl + '?action=list&searchField=' + TargetTypeSearchField + '&searchValue=' + this.getValue()});
	        	TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
	    	}
	}
});

*/
//��Ӱ�ť
var loginButton = new Ext.Button({
	text: '���׵�¼',
    tooltip:'���׵�¼',        
    iconCls:'add',
	handler:function(){
		
		

		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '�û�����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:userName,
			// emptyText:userName,
			//disabled:true,
			readOnly:true,
			// anchor: '90%',
			selectOnFocus:'false', 
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'����',msg:'�û�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '��������',
			allowBlank: false,
			width:150,
			listWidth : 180,
			emptyText:'',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		
		// ----------��������------------------------------

		var acctbookDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		acctbookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.acct.acctbookidexe.csp?action=getAcctBook&start=0&limit=25',
				method : 'POST'
			})
		});

		var acctbookField = new Ext.form.ComboBox({
					id : 'acctbookField',
					fieldLabel : '�������',
					width : 180,
					listWidth : 230,
					allowBlank : false,
					store : acctbookDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'acctbookField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});


		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			frame: true,
			labelWidth: 70,
			labelAlign: 'right',
			items: [
				
				cField,
				acctbookField
			]
		});
	
			//������ zlg1
	
		formPanel.on('afterlayout', function(panel, layout){
			
			Ext.Ajax.request({
			url: '../csp/herp.acct.acctbookidexe.csp?action=getBookID&userID='+userID,
			waitMsg:'������...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode(result.responseText );
				if(jsonData.success=='true'){
					var CurBookInfo= jsonData.info; 
					var CurBookID=CurBookInfo.split("^")[0];
					var CurBookCode=CurBookInfo.split("^")[1];
					var CurBookName=CurBookInfo.split("^")[2];
					
					cField.setValue(userCode);
					acctbookField.setValue(CurBookID);
					acctbookField.setRawValue(CurBookName);
					
				}		
			},
			scope: this
			});
			
			// getCurAcctBook(userID)
			//n1Field.setValue(rowObj[0].get("name"));	
		});
		
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'ȷ ��',
			// cls:'x-btn-text',
			iconCls:'submit',
			minWidth: 75
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
					
			var code = cField.getValue();
			var bookid = acctbookField.getValue();
			var bookName = acctbookField.getRawValue();
			bookid = trim(bookid);
			if(code==""){
				Ext.Msg.show({title:'����',msg:'�û�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(bookid==""){
				Ext.Msg.show({title:'����',msg:'���ײ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			//��ӻ�ƺ�������ȫ�ֱ��� zhaoliguo 2016-1-7
			//var frm = dhcsys_getmenuform();
			//frm.AcctBookID=bookid
			var frm =dhcsys_getsidemenuform(); 
			frm.AcctBookID.value=bookid
			frm.AcctBookName.value=bookName
			
			//encodeURI zlg4
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctbookidexe.csp?action=add&useid='+code+'&bookid='+bookid),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){nField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){nField.focus();}
						Ext.Msg.show({title:'ע��',msg:'��¼�ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						var frm = dhcsys_getsidemenuform(); //��˵����÷�����websys.js��
						var currBookName= frm.AcctBookName.value ; 
						var currBooID= frm.AcctBookID.value ; 
						//alert(currBooID)
						
						TargetTypeTabDs.load({params:{
						 start:0, 
						 limit:5,
						 bookid:currBooID
						}});
						addwin.close();
					}
					else
							{
								var message="";
								if(jsonData.info=='RepCode') message='����ı����Ѿ�����!';
								if(jsonData.info=='RepName') message='����������Ѿ�����!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			
		}
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '����ѡ��',
			width: 320,
			height:180,
			minWidth: 290, 
			minHeight: 150,
			// closable:false,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:20px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton
			]
		});
	
		//������ʾ
		addwin.show();

	}
});


//��ѯˢ�°�ť
var FindButton = new Ext.Toolbar.Button({
	text: 'ˢ��',
    tooltip:'ˢ��',        
    iconCls:'reload',
	handler:function(){

	//alert(GetAcctBookID());
	//AddAcctBook();
	
	var frm = dhcsys_getsidemenuform(); //��˵����÷�����websys.js��
	var currBookName= frm.AcctBookName.value ; 
	var currBooID= frm.AcctBookID.value ; 

						
	TargetTypeTabDs.load({params:{
						 start:0, 
						 limit:5,
						 bookid:currBooID
						}});
	}
});





//��ҳ������
var TargetTypeTabPagingToolbar = new Ext.PagingToolbar({
    store: TargetTypeTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼"
	//buttons: ['-',TargetTypeFilterItem,'-',TargetTypeSearchBox]
	
	
});


//���
var TargetTypeTab = new Ext.grid.EditorGridPanel({
	title: '�û�������׵�¼����',
	iconCls:'maintain',
	region: 'center',
	store: TargetTypeTabDs,
	cm: TargetTypeTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['-',loginButton,'-',FindButton],
	bbar:TargetTypeTabPagingToolbar
});
TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
if(currBookName==""){
	
	currBookName="δ��¼"
}
//TargetTypeTab.title="��ǰ������Ϣ��"+"�û���"+userName+"��,���ס�"+currBookName+"��"



