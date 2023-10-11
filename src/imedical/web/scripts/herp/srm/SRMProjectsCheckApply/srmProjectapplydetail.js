var PrjApplyUrl = '../csp/herp.srm.srmprojcheckapplydetailexe.csp';
////////////////  多表头  ///////////////////////
var row = [
 	{ header: '', colspan: 1, align: 'center' },  
    { header: '', colspan: 1, align: 'right' },//header表示父表头标题，colspan表示包含子列数目  
    { header: '合同内容', colspan: 3, align: 'center' },  
    { header: '完成情况', colspan: 3, align: 'center' }
   ];  
   
var group = new Ext.ux.grid.ColumnHeaderGroup({  
       rows: [row]  
   }); 
   
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
	emptyText : '',
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
			//tbar:['-',searchbutton],
			layout:"fit",
			split : true,
			collapsible : true,
			containerScroll : true,
			xtype : 'grid',	
			loadMask: true,
			trackMouseOver: true,
			stripeRows: true,
			//atLoad : true, // 是否自动刷新
			plugins: group,
		    //view : new MyGridView(viewConfig),	
			fields : [{
			//mtext:"     ",
            //mcol:1,
            //mwidth:'',
				        id:'ID',
						header : 'ID',
						dataIndex : 'rowid',
						width : '',
						hidden : true
			},{
            //mtext:"     ",
            //mcol:1,
           // mwidth:120,
						id : 'PrjCN',
						header : '项目合同编号',
						dataIndex : 'PrjCN',
						width : 120,
						align : 'right',
						editable:true,        
						hidden : false
						//type:PrjCNField

			},{
            //mtext:"合同内容 ",
           // mcol:3,
           // mwidth:360,
						id : 'Destination',
						header : '研究目标',
						width : 120,
						editable: false,
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
            //mtext:"完成情况",
            //mcol:3,
            //mwidth:360,
						id : 'ResDestination',
						header : '研究目标',
						width : 120,
						//editable: true,
						align : 'right',
						dataIndex : 'ResDestination'					
					},{
						id : 'ResContent',
						header : '研究内容',
						width : 120,
						//editable : false,
						align : 'right',
						dataIndex : 'ResContent'
					},{
						id : 'ResCheck',
						header : '考核指标',
						width : 120,
						//editable:false,
						align : 'right',
						dataIndex : 'ResCheck'
            
					}]
					
		});


