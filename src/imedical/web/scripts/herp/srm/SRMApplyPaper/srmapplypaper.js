//var userdr = session['LOGON.USERID'];    
var username = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmapplypaperexe.csp';
var subusername = session['LOGON.USERCODE']; 

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var username=""
}
//�ɱ�������
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ var username=""
}

//userkdr="";
/**
Ext.Ajax.request({			        
     url: '../csp/herp.srm.srmapplypaperexe.csp?action=GetSRMUserID&usercode='+username,	
     method:'POST',
     async:false,
		 success: function(result, request){		 
	     var jsonData = Ext.util.JSON.decode( result.responseText );  	         
       userkdr = jsonData;   
       //userkdr=result.responseText;
       //alert(userkdr)
					         	
}
});   
**/
///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
// ������ʼʱ��ؼ�
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		fieldLabel:'��ʼ����',
		width : 120,
		editable:true
		//emptyText : '��ѡ��ʼ����...'
	});
	
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		fieldLabel:'��������',
		width : 120,
		editable:true
		//emptyText : '��ѡ���������...'
	});
		
		
 ///��������
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						//url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=deptList',method:'POST'
					});
		});
var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


// ///////////////////������Ŀ
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

// ///////////////////�ڿ�����
var JournalNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


JournalNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=JournalList&str='+encodeURIComponent(Ext.getCmp('JournalName').getRawValue()),method:'POST'});
});

var JournalName = new Ext.form.ComboBox({
	id: 'JournalName',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:JournalNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���ڿ�����...',
	name: 'JournalName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////��һ����  
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var user1Combo = new Ext.form.ComboBox({
			fieldLabel : '���� ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
///////////////////�����������
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '�ȴ�����'], ['1', 'ͨ��'], ['2', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�����������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

  var QueryButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			//tooltip : '��ѯ',
			iconCls : 'search',
			width : 30,
			handler : function() {
			
			var startdate= PSField.getRawValue();
		    var enddate = PEField.getRawValue();
		    var dept  = deptCombo.getValue();
		    var title = titleText.getRawValue(); 
		    var jname = JournalName.getRawValue();
		    var FristAuthor= user1Combo.getValue();
	        var ChkResult = ChkResultField.getValue();
			var type = TypeCombox.getValue();
	      //alert(userkdr)
	      itemGrid.load({
			    params:{
			    start:0,
			    limit:25,
			    SubDateStart:startdate,
			    SubDateEnd:enddate,
			    DeptDr:dept,
			    Title:title,
			    JName:jname,
			    FristAuthor:FristAuthor,
			    ChkResult:ChkResult,
			    username:username,
				Type:type
				   }
		  });			
}
})


var queryPanel = new Ext.FormPanel({
			autoHeight : true,
			title : '����Ͷ��������Ϣ��ѯ',
	iconCls : 'search',
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
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
					TypeCombox,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">������Ŀ</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					titleText,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��������</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PSField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:center;">��</p>',
						width : 20			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PEField,
					{
						xtype : 'displayfield',
						value : '',
						width : 30
					},
					QueryButton
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
				   
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
					deptCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">�ڿ�����</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					JournalName,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
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
					user1Combo	
				]
			}
			]
		});
var AddButton = new Ext.Toolbar.Button({
					text : '����',
					iconCls: 'edit_add',
					handler : function() {
						 AddPaperfun();
				   }
  });
   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '�޸�',
		  iconCls: 'pencil',
		  handler : function() {
		  var rowObj=itemGrid.getSelectionModel().getSelections();
		  var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			var participantsids = rowObj[i].get("ParticipantsID");	
			//alert(state);
			if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" ) ){ 
				EditPaperfun(participantsids);}
			else {Ext.Msg.show({title:'����',msg:'�������ύ�������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
						 
	
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	        text : 'ɾ��',
		    iconCls: 'edit_remove',
		    handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			if(state == "δ�ύ" ){ delFun();}
			else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });
  
  var SubmitButton = new Ext.Toolbar.Button({
   	        text : '�ύ',
			iconCls: 'pencil',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			//////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P001',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
			
			
			
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");
				
			if(state == "δ�ύ" ){ SubmitPaperfun();}
			else {Ext.Msg.show({title:'����',msg:'�������ύ�������ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });	
  	 var PrintButton = new Ext.Toolbar.Button({
   	        text : '��ӡ',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��ӡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			//////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P001',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
			
			
			
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");
				
			if(state == "δ�ύ" ){ SubmitPaperfun();}
			else {Ext.Msg.show({title:'����',msg:'�������ύ�������ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });	
  exportexcel = function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var rowid = rowObj[0].get("rowid");
		ExportDataToExcel("","","",rowid);
	}
	
   printexcel = function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var rowid = rowObj[0].get("rowid");
		var flg=PrintDataToExcel("","","",rowid);
	}
var itemGrid = new dhc.herp.Grid({
		    title: '����Ͷ��������Ϣ�б�',
			iconCls: 'list',
		    region : 'center',
		    url: projUrl,
		    tbar:[AddButton,UpdateButton,DeleteButton,SubmitButton],
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // �����������õ�Ԫ�����༭�Ƿ���� 
		                 if ((record.get('AllAudit') =="0")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 
						if ((record.get('AllAudit') =="0") && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            }, 
			fields : [
			      new Ext.grid.CheckboxSelectionModel({
				      hidden : true,
				      editable:false
				      }),
				   {
						header : 'ѡ��',
						width:40,
						hidden : false,
						editable:false,
						align:'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
						    if(record.get('AllAudit')=="1"){
								return '<span style="color:blue;cursor:hand"><BLINK id="print" onclick=exportexcel();>��ӡ</BLINK></span>'+'<b> </b>';  
							}else{
								return '<span style="color:gray;cursor:hand"><BLINK id="print" >��ӡ</BLINK></span>'+'<b> </b>';  
							}
						}
					},{
						header : '�����ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '����',
						editable:false,
						width :40,
						dataIndex : 'Type'

					}, {
						id : 'Title',
						header : '��������',
						editable:false,
						width : 180,
						dataIndex : 'Title',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
						id : 'FristAuthorName',
						header : '��һ����(ͨѶ����)',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

						
					},{
						id : 'JName',
						header : '�ڿ�����',
						editable:false,
						width : 180,
						dataIndex : 'JName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
						id : 'PressName',
						header : '������',
						editable:false,
						width : 180,
						hidden:true,
						dataIndex : 'PressName'
					}, {
						id : 'ParticipantsName',
						header : '��������',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'ParticipantsName'

					}, {
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
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
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
						id : 'Content',
						header : '����',
						editable:false,
						width : 60,
						dataIndex : 'Content'
					},{
						id : 'IsMultiContribution',
						header : 'һ���Ͷ',
						width : 60,
						editable:false,
						dataIndex : 'IsMultiContribution'

					},{
						id : 'IsKeepSecret',
						header : '�漰����',
						width : 60,
						editable:false,
						dataIndex : 'IsKeepSecret'

					},{
						id : 'PrjName',
						header : '���л�������',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjName'

					},{
						id : 'PrjCN',
						header : '��ͬ��',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjCN'

					},{
						id : 'SubUserDR',
						header : '������ID',
						editable:false,
						width : 120,
						hidden: true,
						dataIndex : 'SubUserDR'
					},{
						id : 'SubUserName',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'SubUserName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'Dept',
						header : '�����˿���',
						width : 120,
						editable:false,
						dataIndex : 'Dept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}


					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '�ύ״̬',
						editable:false,
						width : 60,
						dataIndex : 'DataStatus'
					},{
						id : 'ChkResult',
						header : '�������',
						editable:false,
						width : 120,
						hidden: true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '����״̬',
						editable:false,
						width : 100,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '�������',
						width : 100,
						editable:false,
						dataIndex : 'Desc'
					},{
						id : 'ParticipantsID',
						header : '��������ID',
						width : 120,
						editable: false,
						hidden : true,
						dataIndex : 'ParticipantsID'
					}, {
						id : 'AllAudit',
						header : '�Ƿ�ȫ������ͨ��',
						width : 120,
						editable: false,
						hidden : true,
						dataIndex : 'AllAudit'
					},{
						header : '�������п��п���(Ժ��)',
						dataIndex : 'OutPrjName',
						hidden : true
					},{
						header : '����ID',
						dataIndex : 'TypeID',
						hidden : true
					},{
						header : '�������п��п���ID',
						dataIndex : 'PrjDR',
						hidden : true
					},{
						header : '�ڿ�ID',
						dataIndex : 'JNameID',
						hidden : true
					},{
						header : '��¼���ID',
						dataIndex : 'RecordTypeDR',
						hidden : true
					},{
						header : '���п���ID',
						dataIndex : 'PrjDR',
						hidden : true
					},{
						header : '��һ����ID',
						dataIndex : 'FristAuthorNameID',
						hidden : true
					},{
						header : '����ID',
						dataIndex : 'ContentID',
						hidden : true
					},{
						header : '�Ƿ�һ���ͶID',
						dataIndex : 'IsMultiContributionID',
						hidden : true
					},{
						header : '�Ƿ���ID',
						dataIndex : 'IsKeepSecretID',
						hidden : true
					}]					
		});
		
  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť

 itemGrid.load({params:{start:0, limit:12, username:username}});
 
	
	if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 AddButton.disable();//����Ϊ������
	  DeleteButton.disable();//����Ϊ������
	  SubmitButton.disable();//����Ϊ������

	
}
    if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	  AddButton.disable();//����Ϊ������
	  UpdateButton.disable();//����Ϊ������
	  DeleteButton.disable();//����Ϊ������
	  SubmitButton.disable();//����Ϊ������

	
	}
uploadMainFun(itemGrid,'rowid','P001',10);
downloadMainFun(itemGrid,'rowid','P001',11);