var PrjDetailApplyUrl = '../csp/herp.srm.srmprojcheckapplydetailexe.csp';

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


var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '����',
					iconCls: 'save',
					handler : function() {
					var rowObj = itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length; 
					
					if (len < 1) {
						Ext.Msg.show({
									title : 'ע��',
									msg : '�뵥��ѡ���Ӧ����Ŀ!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.WARNING
								});
						return;
					}
					
					var stateid = rowObj[0].get("ProjStatusID");		
                    var ResAudit = rowObj[0].get("ChkResult");	
					if((stateid == "2" )||((stateid=="3")&&(ResAudit=="2"))){srmProjectapplydetailAddFun();}
					else{
    					Ext.Msg.show({title:'����',msg:'�������ύ����������ӻ��޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    				 	return;
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
	//title: '��Ŀ�о���Ϣά��',iconCls: 'list',
			region : 'center',
			url : PrjDetailApplyUrl,	
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
						align : 'left',
						editable : false
						//type:PrjCNField

					}, {
            mtext:"��ͬ���� ",
            mcol:3,
            mwidth:360,
						id : 'Destination',
						header : '�о�Ŀ��',
						width : 120,
						editable : false,
            align : 'left',
						dataIndex : 'Destination',
						renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
                        }
						//type:PrjDestinationField
				}, {
						id : 'Content',
						header : '�о�����',
						width : 120,
						align : 'left',
            editable : false,
						dataIndex : 'Content',
						renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
                        }
						//type:PrjContentField
					},{
						id : 'Check',
						header : '����ָ��',
						width : 120,
						editable : false,
						align : 'left',	
						dataIndex : 'Check',
						renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
                        }
						//type:PrjCheckField
					},{
            mtext:"������",
            mcol:3,
            mwidth:360,
						id : 'ResDestination',
						header : '�о�Ŀ��',
						width : 120,
						editable : true,
						align : 'left',
						dataIndex : 'ResDestination',
						renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
                        }
						//type:PrjResDestinaField
						
					},{
						id : 'ResContent',
						header : '�о�����',
						width : 120,
						editable : true,
						align : 'left',
						dataIndex : 'ResContent',
						renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
                        }
						//type:PrjResContentField
					},{
						id : 'ResCheck',
						header : '����ָ��',
						width : 120,
						editable: true,
						align : 'left',
						//hidden:true,
						dataIndex : 'ResCheck',
						renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
                        }
						//type:PrjResCheckField
            
					}],
					tbar:[addButton],
					layout:"fit",
					//split : true,
					//collapsible : true,
					containerScroll : true,
					xtype : 'grid',	
					loadMask: true,
					trackMouseOver: true,
					stripeRows: true
		});


   if(window.CollectGarbage){
 window.setInterval("CollectGarbage();", 30000);
 }



