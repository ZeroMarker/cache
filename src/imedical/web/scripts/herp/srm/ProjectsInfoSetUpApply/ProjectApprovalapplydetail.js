var PrjApplyUrl = '../csp/herp.srm.srmprojapplydetailexe.csp';

var usercode = session['LOGON.USERCODE'];

// //////////////��ͬ��//////////////////////
var PrjCNField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////��ͬ�о�Ŀ��/////////////
var PrjDestinationField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////��ͬ�о�����/////////////
var PrjContentField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////��ͬ����ָ��/////////////
var PrjCheckField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////�о�Ŀ��/////////////
var PrjResDestinaField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////�о�����/////////////
var PrjResContentField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////�о�����ָ��/////////////
var PrjResCheckField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

var searchbutton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
	
	    var selectedRow = itemGrid.getSelectionModel().getSelections();
			var len = selectedRow.length;

	   		if((len < 1)){
		    Ext.Msg.show({title:'ע��',msg:'����ѡ����Ŀ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
			else{
			mainrowid=selectedRow[0].data['rowid'];
			
			DetailGrid.load({params:{sortField:'',sortDir:'',start:0, limit:12,mainrowid:mainrowid}})
			}
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
			region : 'center',
			url : PrjApplyUrl,	
      view : new MyGridView(viewConfig),	
      cm : colModel,
      //selModel:sm,
      readerModel:'remote',		
			fields : [          
			{ 		mtext:"     ",
            mcol:1,
            mwidth:'',
            id:'ID',
						header : 'ID',
						dataIndex : 'rowid',
						width : '',
						hidden : true
					},{
            mtext:"     ",
            mcol:1,
            mwidth:120,
						id : 'PrjCN',
						header : '��Ŀ��ͬ���',
						dataIndex : 'PrjCN',
						width : 120,
						align : 'right',
						editable:false,        
						hidden : false
						//type:PrjCNField

					}, {
            mtext:"��ͬ���� ",
            mcol:3,
            mwidth:360,
						id : 'Destination',
						header : '�о�Ŀ��',
						width : 120,
						editable:false,
            align : 'right',
						dataIndex : 'Destination'
					  //type:PrjDestinationField
				}, {
						id : 'Content',
						header : '�о�����',
						width : 120,
						align : 'right',
            editable: false,
						dataIndex : 'Content'
						//type:PrjContentField
					},{
						id : 'Check',
						header : '����ָ��',
						width : 120,
						editable: false,
						align : 'right',	
						dataIndex : 'Check'
						//type:PrjCheckField
					},{
            mtext:"������",
            mcol:3,
            mwidth:360,
						id : 'ResDestination',
						header : '�о�Ŀ��',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'ResDestination'
						//type:PrjResDestinaField
						
					},{
						id : 'ResContent',
						header : '�о�����',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'ResContent'
						//type:PrjResContentField
					},{
						id : 'ResCheck',
						header : '����ָ��',
						width : 120,
						editable:false,
						align : 'right',
						//hidden:true,
						dataIndex : 'ResCheck'
						//type:PrjResCheckField         
					}],
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
 
DetailGrid.btnAddHide();  //�������Ӱ�ť
DetailGrid.btnSaveHide();  //���ر��水ť
DetailGrid.btnDeleteHide(); //����ɾ����ť

DetailGrid.hiddenButton(1);


   if(window.CollectGarbage){
 window.setInterval("CollectGarbage();", 30000);
 }



