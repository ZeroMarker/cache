//��Ŀ�м���Ϣ
//why
var aaaa = 'herp.srm.projectmidchecknewdetailauditexe.csp';
//alert(aaaa);
var usercode = session['LOGON.USERCODE'];


var AuditButton  = new Ext.Toolbar.Button({
		text: 'ͨ��',  
        iconCls: 'pencil',
        handler:function(){
        var checker =session['LOGON.USERCODE'];
		//���岢��ʼ���ж���
		var rowObj=DetailGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("midcheckState")=="��ͨ��"||rowObj[j].get("midcheckState")=="��ͨ��")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.projectmidchecknewdetailauditexe.csp?action=audit&RowID='+rowObj[i].get("RowID")+'&checker='+checker,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DetailGrid.load({params:{start:0, limit:12}});	
								
							}else{
								Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
						var rowObj=DetailGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("midcheckState")=="��ͨ��"||rowObj[j].get("midcheckState")=="��ͨ��")
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
//  
// var tbuttonbar = new Ext.Toolbar({   
//        items: [
//        '-',AuditButton,NoAuditButton]   
// }); 
// 

 
var DetailGrid = new dhc.herp.Gridhss({
	title: '��Ŀ�м������ϸ��Ϣ�б�',iconCls: 'list',
			region : 'center',
			url : aaaa,	
      //view : new MyGridView(viewConfig),	
      cm : colModel,
      //selModel:sm,
      readerModel:'remote',		
			fields :  [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
				        id:'RowID',
						header : '�м���ϢID',
						dataIndex : 'RowID',
						hidden : true
					},
					{
						id : 'rowid',
						header : '������Ϣid',
						width : 200,
						hidden : true,
						dataIndex : 'rowid'

					},{
						id : 'Detail',
						header : '�м���Ϣ����',
						width : 180,
						editable:false,
						dataIndex : 'Detail',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'ApplyName',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '����ʱ��',
						editable:false,
						width : 80,
						dataIndex :'MidDate'

					}, {
						id : 'midcheckFlag',
						header : '����״̬',
						width : 60,
						editable:false,
						dataIndex : 'midcheckFlag'

					},{
						id : 'midcheckState',
						header : '���״̬',
						width : 100,
						editable:false,
						dataIndex : 'midcheckState'

					},{
						id : 'CheckName',
						header : '�����',
						width : 60,
						editable:false,
						dataIndex : 'CheckName'

					},
					{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'CheckDate'

					},{
						id : 'midcheckopinion',
						header : '�������',
						width : 100,
						editable:false,
						//hidden:true,
						dataIndex : 'midcheckopinion'
           // type:grafundsField,//���ö������ֵ�ı���
					},{
						id : 'RelyUnitIDs',
						header : '�μ���ԱID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RelyUnitIDs'
					}, {
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
						

					} }],
					tbar:[AuditButton,'-',NoAuditButton],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',	
					loadMask: true,
					trackMouseOver: true,
					stripeRows: true
//					listeners : { 'render': function(){ 
//            tbuttonbar.render(this.tbar); 
//        } 
//     }
		});
// DetailGrid.btnAddHide();  //�������Ӱ�ť
// DetailGrid.btnSaveHide();  //���ر��水ť
// DetailGrid.btnDeleteHide(); 

// DetailGrid.addButton('-');
//  DetailGrid.addButton(AuditButton);
//  DetailGrid.addButton('-');
//  DetailGrid.addButton(NoAuditButton);
//DetailGrid.load({params:{start:0, limit:25,rowid:rowid}});


   downloadMainFun(DetailGrid ,'RowID','C007',13);




