///////////////////////////////////////////////////
var userdr = session['LOGON.USERID'];
//alert(userdr);
var usercode=session['LOGON.USERCODE'];
var tmpData="";

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var userdr=""
	}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ var userdr=""
	}


var itemGridUrl = '../csp/herp.srm.monographrewardapplyexe.csp';

///////////////////����/////////////////////////////  
var sTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var sTypeCombox = new Ext.form.ComboBox({
	                   id : 'sTypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : sTypeDs,
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
						  
//������ʼʱ��ؼ�
var PSField = new Ext.form.DateField({
	id : 'PSField',
	//format : 'Y-m-d',
	width : 120
	//allowBlank : false,
	//emptyText : ''
});
var PEField = new Ext.form.DateField({
	id : 'PEField',
	//format : 'Y-m-d',
	width : 120
	//emptyText : ''
	
});
/////////////////////��������
var monoName = new Ext.form.TextField({
width :120,
selectOnFocus : true
});
/////////////////////ISBN��
var ISBNText = new Ext.form.TextField({
width :120,
selectOnFocus : true
});

/////����
var userDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

userDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=userList',
					method : 'POST'
				});
	});

var userCombo = new Ext.form.ComboBox({
		fieldLabel : '�������� ',
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
	
function srmFundSearch(){
    var startdate= PSField.getRawValue();
    if (startdate!=="")
    {
       //startdate=startdate.format ('Y-m-d');
    }
    var enddate = PEField.getRawValue();
    if (enddate!=="")
    {
       //enddate=enddate.format ('Y-m-d');
    }
    var editor  = userCombo.getValue();
    var isbn = ISBNText.getValue(); 
	var name = monoName.getValue(); 
    var sType = sTypeCombox.getValue();
  	itemGrid.load({
	    params:{
	    start:0,
	    limit:25,
	    starttime:startdate,
	    endtime:enddate,
	    editor:editor,
	    name:name,
	    isbn:isbn,
	    userdr:userdr,
		sType:sType
	   }
  });
}


var queryPanel = new Ext.FormPanel({
		autoHeight : true,
	region : 'north',
	frame : true,
	title : 'ר������������Ϣ��ѯ',
	iconCls : 'search',
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
				sTypeCombox,
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
				monoName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����ʱ��</p>',
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
				{
					xtype : 'button',
					text : '��ѯ',
					handler : function(b){srmFundSearch();},
					iconCls : 'search',
					width : 30
				}
			]
		}, 
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
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
				userCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ISBN��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ISBNText
				]
		    }
		]
	});
var itemGrid =new dhc.herp.Grid({
			region : 'center',
			title: 'ר������������Ϣ��ѯ�б�',
			iconCls: 'list',
			url : 'herp.srm.monographrewardapplyexe.csp',					
			fields :[
        new Ext.grid.CheckboxSelectionModel({
	        hidden:true,
	        editable:false
	        }),      
        {
            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
           id:'sType',
           header: '����',
           allowBlank: false,
           width:40,
           editable:false,
           dataIndex: 'sType'
      },{
            id:'YearName', 
            header: '���',
            allowBlank: false,
            width:60,
			//hidden:true,
            editable:false,
            dataIndex: 'YearName'
       },{
           id:'Type',
           header: '�������',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'Type'
      },{
           id:'Name',
           header: '��������',
           allowBlank: false,
           width:180,
           editable:false,
           dataIndex: 'Name',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
           id:'CompleteUnit',
           header: '�ڼ���ɵ�λ',
           allowBlank: false,
           width:120,
           editable:false,
		   hidden:true,
           dataIndex: 'CompleteUnit'
      },{
           id:'EditorName',
           header: '��������',
           allowBlank: false,
           width:80,
           editable:false,
           renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
           dataIndex: 'EditorName'
      },{
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
		}, {
            id:'DataStatus',
            header: '����״̬',
            allowBlank: false,
            width:60,
            editable:false,
            dataIndex: 'DataStatus'
       },{
            id:'ChkResult', 
            header: '��˽��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ChkResult'
       },{
            id:'CheckDesc', 
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'CheckDesc'
       },  {
			     id:'EditorIDs',         
			     header:'��������IDs',
			     width:120,
			     editable:false,
			     hidden:true,
			     align:'center',
			     dataIndex:'EditorIDs'
		},{
           id:'PressName',
           header: '����������',
           allowBlank: false,
           width:120,
           editable:false,
           dataIndex: 'PressName',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
           id:'PressLevel',
           header: '�����缶��',
           allowBlank: false,
           width:100,
           editable:false,
           dataIndex: 'PressLevel',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
            id:'ISBN',
            header: 'ISBN��',
            allowBlank: false,
            width:120,
            editable:false,
            dataIndex: 'ISBN',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'TotalNum',
            header: '������(ǧ��)',
            allowBlank: false,
            width:100,
            align:'right',
            editable:false,
            dataIndex: 'TotalNum',
            renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
       },  {
            id:'PubTime',
            header: '����ʱ��',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'PubTime'
       },{
            id:'PublishFreq',
            header: '������',
            allowBlank: false,
            width:80,
            editable:false,
            align:'right',
            dataIndex: 'PublishFreq'
       },{
           id:'SubUserName',
           header: '������',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'SubUserName'
       }, {
          id:'DeptName',
          header: '�����˿���',
          allowBlank: false,
          width:120,
          editable:false,
          dataIndex: 'DeptName',
		  renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
            id:'SubDate',
            header: '����ʱ��',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'SubDate'
       }, {
            id:'SysNo',
            header: 'ϵͳ��',
            allowBlank: false,
            width:120,
            hidden:true,
            editable:false,
            dataIndex: 'SysNo'
       },{
			      id : 'RewardAmount',
			      header : '����(Ԫ)',
			      width : 80,
			      align:'right',
			      editable:false,
			      allowblank:false,
				  
			      renderer : function(val,cellmeta, record,rowIndex, columnIndex, store) { 
				  val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
			      var sf = record.data['RewardAmount']
			      if (sf !== "") {
				    return '<span style="color:red;cursor:hand">'+val+'</span>';
			      }},
			      dataIndex : 'RewardAmount'
		},{
			      id:'score',
			      header:'����÷�',
			      editable:false,
			      width:120,
			      align:'center',
			      hidden:true,
			      renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
			        var sf = record.data['score']
			        if (sf !== "") {
				      return '<span style="color:red;cursor:hand">'+value+'</span>';
			      }},
			      dataIndex:'score'
		},{
            id:'YearID', 
            header: '���ID',
            allowBlank: false,
            width:180,
			hidden:true,
            editable:false,
            dataIndex: 'YearID'
       },{
			id : 'PrjName',
			header : '���л�������',
			width : 120,
			editable:false,
			hidden : true,
			dataIndex : 'PrjName'
		},{
			header : '�������п��п���(Ժ��)',
			dataIndex : 'OutPrjName',
			hidden : true
		}]
			    
});
var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '���',
					iconCls: 'edit_add',
					handler : function() {
						srmmonographAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls: 'pencil',
					handler : function() {
					var rowObj = itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length; 
					if(len < 1)
					{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						var state = rowObj[0].get("DataStatus");	
						var editorids = rowObj[0].get("EditorIDs");	
						if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )){srmMonographEditFun(editorids);
					    }				
						else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
					}
});
var submitButton = new Ext.Toolbar.Button({
	text : '�ύ',
	//tooltip : '�ύ',
	iconCls: 'pencil',
	handler : function() {
		    var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");
				
				
				
				
		//////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P004',
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
	
							
				if(state == "δ�ύ" ){srmMonographSubmitFun();
			    }				
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			//tooltip : 'ɾ��',
			iconCls: 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫɾ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
				    for(var i = 0; i < len; i++){
				    var state = rowObj[i].get("DataStatus");	
				    if(state == "���ύ" ){
					      Ext.Msg.show({title:'ע��',msg:'���ύ��¼�޷�ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					       return;
				    }
				}
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
						if (btn == 'yes') {
						    for(var i = 0; i < len; i++){
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid='+rowObj[i].get("rowid"),
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
														limit : 25,
														userdr:userdr
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
						}
					});
				
				}
			}
});


  
	/**
	 * �˴�Ӧ��Ƴ��û�ֻ���ύ�Լ�����Ʒ*/
	srmMonographSubmitFun=function(){
		
     var usercode=session['LOGON.USERCODE'];
	//���岢��ʼ���ж���
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	 for(var j= 0; j < len; j++){
		 if(rowObj[j].get("DataStatus")=="���ύ")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���ύ��¼�޷��ٴ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		//�˶δ��������ж��û�ֻ���ύ�Լ��Ĵ��� �˴���Ҫ�޸�
//		 if(rowObj[j].get("EditorDr")!=session['LOGON.USERID'])
//		 {
//			      Ext.Msg.show({title:'ע��',msg:'�û�ֻ���ύ�Լ���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//			       return;
//		 }
		}
    
	function handler(id){
		if(id=="yes"){	
			for(var i = 0; i < len; i++){
				    Ext.Ajax.request({
					url:'herp.srm.monographrewardapplyexe.csp?action=submit&&rowid='+rowObj[i].get("rowid")+'&usercode='+usercode,
					waitMsg:'�ύ��...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){				
						//alert(result.responseText);
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:25,userdr:userdr}});	
							
						}else{
							var message='�ύʧ��!';
							//if(jsonData.info=="RepName") message="�����ظ�";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ�ύ��ѡ��¼��?',handler);
	}
	
  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
	

  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//��������
	if (columnIndex == 8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("EditorIDs");
		var title = records[0].get("Name"); 
		BookAuthorInfoList(title,authorinfo);
	}
	
		
	
	
});
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addButton.disable();//����Ϊ������
	  delButton.disable();//����Ϊ������
	  submitButton.disable();//����Ϊ������
	  
	
	}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	 addButton.disable();//����Ϊ������
	 editButton.disable();
	  delButton.disable();//����Ϊ������
	  submitButton.disable();//����Ϊ������
	  
	
	}


uploadMainFun(itemGrid,'rowid','P004',9);
downloadMainFun(itemGrid,'rowid','P004',10);