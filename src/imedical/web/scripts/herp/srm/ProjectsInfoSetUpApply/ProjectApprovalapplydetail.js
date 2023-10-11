var PrjApplyUrl = '../csp/herp.srm.srmprojapplydetailexe.csp';

var usercode = session['LOGON.USERCODE'];

// //////////////合同号//////////////////////
var PrjCNField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////合同研究目的/////////////
var PrjDestinationField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////合同研究内容/////////////
var PrjContentField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////合同考核指标/////////////
var PrjCheckField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////研究目的/////////////
var PrjResDestinaField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////研究内容/////////////
var PrjResContentField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////研究考核指标/////////////
var PrjResCheckField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

var searchbutton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	
	    var selectedRow = itemGrid.getSelectionModel().getSelections();
			var len = selectedRow.length;

	   		if((len < 1)){
		    Ext.Msg.show({title:'注意',msg:'请先选择项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
			else{
			mainrowid=selectedRow[0].data['rowid'];
			
			DetailGrid.load({params:{sortField:'',sortDir:'',start:0, limit:12,mainrowid:mainrowid}})
			}
	}
});

//////双层表头配置(来源于网络http://blog.csdn.net/enginetanmary/article/details/4329996)
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
						header : '项目合同编号',
						dataIndex : 'PrjCN',
						width : 120,
						align : 'right',
						editable:false,        
						hidden : false
						//type:PrjCNField

					}, {
            mtext:"合同内容 ",
            mcol:3,
            mwidth:360,
						id : 'Destination',
						header : '研究目标',
						width : 120,
						editable:false,
            align : 'right',
						dataIndex : 'Destination'
					  //type:PrjDestinationField
				}, {
						id : 'Content',
						header : '研究内容',
						width : 120,
						align : 'right',
            editable: false,
						dataIndex : 'Content'
						//type:PrjContentField
					},{
						id : 'Check',
						header : '考核指标',
						width : 120,
						editable: false,
						align : 'right',	
						dataIndex : 'Check'
						//type:PrjCheckField
					},{
            mtext:"完成情况",
            mcol:3,
            mwidth:360,
						id : 'ResDestination',
						header : '研究目标',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'ResDestination'
						//type:PrjResDestinaField
						
					},{
						id : 'ResContent',
						header : '研究内容',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'ResContent'
						//type:PrjResContentField
					},{
						id : 'ResCheck',
						header : '考核指标',
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
 
DetailGrid.btnAddHide();  //隐藏增加按钮
DetailGrid.btnSaveHide();  //隐藏保存按钮
DetailGrid.btnDeleteHide(); //隐藏删除按钮

DetailGrid.hiddenButton(1);


   if(window.CollectGarbage){
 window.setInterval("CollectGarbage();", 30000);
 }



