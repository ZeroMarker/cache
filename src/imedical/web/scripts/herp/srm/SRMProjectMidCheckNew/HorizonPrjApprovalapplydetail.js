//��Ŀ�м���Ϣ
//why
var aaaa = 'herp.srm.projectmidchecknewdetailexe.csp';
//alert(aaaa);
var usercode = session['LOGON.USERCODE'];


var RewardApplyButton  = new Ext.Toolbar.Button({
		text: '�ύ',  
        iconCls: 'pencil',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=DetailGrid.getSelectionModel().getSelections();
		//alert(rowObj);
		var rowObj1=itemGrid.getSelectionModel().getSelections();
		var state = rowObj1[0].get("rowid");
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("midcheckFlag")=="���ύ"){
				Ext.Msg.show({title:'ע��',msg:'���ύ�������ݲ������ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			//var firstAuthor=rowObj[j].get("FristAuthorName")+"��";
		 
		}
		
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:aaaa+'?action=submit&rowid2='+rowObj[i].get("RowID"),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DetailGrid.load({params:{start:0, limit:12,rowid:state}});								
							}else{
								var message='��Ŀ�м�����ʧ��!';
								if(jsonData.info=="RepInvoice") message="�����ظ�����";
								if(jsonData.info=="����Ա�ڿ�����Ա�в�����!") message="����Ա�ڿ�����Ա�в�����!";
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������ѡ��¼��?',handler);
    }
});


//////˫���ͷ����(��Դ������http://blog.csdn.net/enginetanmary/article/details/4329996)
MyGridView = Ext.extend(Ext.grid.GridView, {
            renderHeaders : function() {
                var cm = this.cm, ts = this.templates;
                var ct = ts.hcell, ct2 = ts.mhcell;
                var cb = [], sb = [], p = {}, mcb = [];
                for (var i = 0, len = cm.getColumnCount(); i < len; i++) {
                    p.id = cm.getColumnId(i);
                    p.value = cm.getColumnHeader(i) || "";
                    p.style = this.getColumnStyle(i, true);
                    if (cm.config[i].align == 'right') {
                        p.istyle = 'padding-right:16px';
                    }
                    cb[cb.length] = ct.apply(p);
                    if (cm.config[i].mtext)
                        mcb[mcb.length] = ct2.apply({
                                    value : cm.config[i].mtext,
                                    mcols : cm.config[i].mcol,
                                    mwidth : cm.config[i].mwidth
                                });
                }
                var s = ts.header.apply({
                            cells : cb.join(""),
                            tstyle : 'width:' + this.getTotalWidth() + ';',
                            mergecells : mcb.join("")
                        });
                return s;
            }
        });
viewConfig = {
    templates : {
        header : new Ext.Template(
                ' <table border="0" cellspacing="0" cellpadding="0" style="{tstyle} border-width:thin thin thin 10px;">',
                ' <thead> <tr class="x-grid3-hd-row">{mergecells} </tr>'
                        + ' <tr class="x-grid3-hd-row">{cells} </tr> </thead>',
                " </table>"),
        mhcell : new Ext.Template(
                ' <td class="x-grid3-header" colspan="{mcols}" style="width:{mwidth}px;"> <div align="center">{value}</div>',
                " </td>")
    }
};

var DetailGrid = new dhc.herp.Gridhss({
	title: '��Ŀ�м���ϸ��Ϣά��',iconCls: 'list',
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
					},{
						id : 'rowid',
						header : '������Ϣid',
						width : 200,
						hidden : true,
						dataIndex : 'rowid'

					},
					{
						id : 'Detail',
						header : '�м���Ϣ����',
						width : 250,
						allowBlank: false,
						//editable:false,
						dataIndex : 'Detail',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
							id:'upload',
							header: '����',
							//allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							//allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					} },{
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
						id : 'midcheckopinion',
						header : '�������',
						width : 120,
						editable:false,
						//hidden:true,
						dataIndex : 'midcheckopinion'
           // type:grafundsField,//���ö������ֵ�ı���
					},{
						id : 'ApplyName',
						header : '������',
						editable:false,
						width : 80,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '����ʱ��',
						editable:false,
						width : 80,
						dataIndex :'MidDate'

					},{
						id : 'CheckName',
						header : '�����',
						width : 80,
						editable:false,
						dataIndex : 'CheckName'

					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'CheckDate'

					} ],
					//tbar:['-'],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',	
					loadMask: true,
					trackMouseOver: true,
					stripeRows: true
	            
             
		});
 
		//DetailGrid.btnAddHide();  //�������Ӱ�ť
		//DetailGrid.btnSaveHide();  //���ر��水ť
		//DetailGrid.btnResetHide();  //�������ð�ť
		//DetailGrid.btnDeleteHide(); //����ɾ����ť
		//DetailGrid.btnPrintHide();  //���ش�ӡ��ť
		//DetailGrid.addButton('-');
		DetailGrid.addButton(RewardApplyButton);
       // DetailGrid.load({params:{start:0, limit:25}});

  uploadMainFun(DetailGrid ,'RowID','C007',5);
    downloadMainFun(DetailGrid ,'RowID','C007',6);


