var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var schemaselfURL='herp.budg.budgschemaselfexe.csp';
var deptyeardetailURL='herp.budg.adjustdeptyeardetailexe.csp';

// ////////////////////////////////////
var SchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

SchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxURL+'?action=itemtype&flag=1',
						method : 'POST'
					});
		});

var SchTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算项类别',
			store : SchTypeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


var searchbotton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	

	      	var selectedRow = itemGrid.getSelectionModel().getSelections();
			var len = selectedRow.length;

	    
	   		if((len < 1)){
		    Ext.Msg.show({title:'注意',msg:'请先选择方案！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
			else{
			SchemDr=selectedRow[0].data['rowid'];
			var year = yearCombo.getValue();
			var dcode = deptCombo.getValue();
			var schtype=SchTypeCombo.getValue();
			var adjustno=adjustnumber.getValue();
			
			if(year==""){
			var year = selectedRow[0].data['year'];
			}
			if(dcode==""){
			var dcode = selectedRow[0].data['deptDR'];
			}
			if(adjustno==""){
			var adjustno=selectedRow[0].data['AdjustNo'];
			}
			selfitemGrid.load({params:{start:0, limit:12,SchemDr:SchemDr,dept:dcode,adjustno:adjustno,type:schtype,byear : year,schtype:schtype}})
			}
	}
});

//////提交
var submit = new Ext.Toolbar.Button({
text: '提交',
    tooltip:'提交',        
    iconCls:'add',
    handler:function(){
	
        	    
	var selectedRow = itemGrid.getSelectionModel().getSelections();
        bsmDr=selectedRow[0].data['Code'];
        bsmId=selectedRow[0].data['rowid'];
        curstep=selectedRow[0].data['ChkStep'];
        deptcode = selectedRow[0].data['deptDR'];
	var selectidDetail=selfitemGrid.getStore().getModifiedRecords();
        for(i=0;i<selectidDetail.length;i++){
	        var selectedid = selectidDetail[i].get("rowid");
		var selectedplanvalue = selectidDetail[i].get("adjustbude");		 
	    	var uur3 = deptyeardetailURL+'?action=submit3&&rowid='+ selectedid+'&planvalueS='+selectedplanvalue;
	    	selfitemGrid.saveurl(uur3);
	    	}
	    var uur2 = deptyeardetailURL+'?action=submit2&&SchemDr='+ bsmId;
	    selfitemGrid.saveurl(uur2);
            var surl = deptyeardetailURL+'?action=submit&dept='+ deptcode+'&rowid='+ bsmId;
	    itemGrid.saveurl(surl)
	    selfitemGrid.load({params:{start:0, limit:25,Code:bsmDr}})
	    itemGrid.load(({params:{start:0, limit:25}}));       
}
	
	
});

//////计算
var calculate  = new Ext.Toolbar.Button({
	text: '计算',
	tooltip: '计算',
	iconCls: 'option',
	handler: function(){
			var selectedMainRow = itemGrid.getSelectionModel().getSelections(); 	
    		var len = selectedMainRow.length;
    		if(len <1){
		    Ext.Msg.show({title:'注意',msg:'请先选择方案名称！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	        }
    		var SchemDR = selectedMainRow[0].get("rowid");
    		var year = selectedMainRow[0].get("year");
    		var AdjustNo = selectedMainRow[0].get("AdjustNo");
    		var objdeptdr = selectedMainRow[0].get("deptDR");
			
		Ext.MessageBox.confirm('提示', '确定要计算吗', function(btn) {
		if (btn == 'yes') {
		var surl = schemaselfURL+'?action=calulate&year='+ year+'&objdeptdr='+objdeptdr+'&ChangeFlag=2&AdjustNo='+AdjustNo+'&SchemDR='+SchemDR;
		itemGrid.saveurl(surl)
			}
		});
	
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





var selfitemGrid = new dhc.herp.Gridhss({
			region : 'center',
			url : deptyeardetailURL,	
            //view : new MyGridView(viewConfig),			
			fields : [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
            //new Ext.grid.RowNumberer(),            
			{ 			mtext:" ",
                        mcol:1,
                        mwidth:1,
						header : 'ID',
						dataIndex : 'rowid',
						width : 60,
						hidden : true
					},{
                        mtext:"     ",
                        mcol:2,
                        mwidth:330,
						id : 'Code',
						header : '科目编码',
						dataIndex : 'Code',
						width : 110,
						editable:false,        
						hidden : false

					}, {
						id : 'Name', 
						header : '科目名称',
						width : 210,
						editable:false,
						dataIndex : 'Name'

				}, {
                        mtext:"预算调整 ",
                        mcol:4,
                        mwidth:480,
						id : 'startbudget',
						header : '期初预算',
						width : 120,
						editable:false,
                        align : 'right',
						dataIndex : 'startbudget'

				}, {
						id : 'thisadjust',
						header : '本次调整',
						width : 120,
						align : 'right',
                        editable: true,
						dataIndex : 'thisadjust'

					},{
						id : 'adjustrange',
						header : '调整幅度(%)',
						width : 120,
						editable: false,
						align : 'right',	
						dataIndex : 'adjustrange'
					}, {
						id : 'adjustbude',
						header : '调整后预算',
                        type:'columnnumber',
						width : 120,
						align : 'right',
						editable: false,
						dataIndex : 'adjustbude'

					}, {
                        mtext:"与上年执行比较",
                        mcol:3,
                        mwidth:360,
						id : 'lastyearexe',
						header : '上年执行',
						width : 120,
                        type:'columnnumber',
						editable : false,
						align : 'right',
						dataIndex : 'lastyearexe'
						
					},{
						id : 'difference',
						header : '差额',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'difference'
						
					},{
						id : 'diffratio',
						header : '差异率(%)',
						width : 120,
						editable:false,
						align : 'right',
						//hidden:true,
						dataIndex : 'diffratio'

					},{     
                        mtext:"  ",
                        mcol:4,
                        mwidth:380,
						id : 'CalFlag',
						header : '计算方法',
						width : 140,
						editable:false,
						dataIndex : 'CalFlag'

					},{
						id : 'CalDesc',
						header : '计算方法描述',
						width : 80,
						editable:false,
						dataIndex : 'CalDesc'

					},/*******{
						id : 'ChkDesc',
						header : '审批意见',
						width : 80,
						editable:false,
						dataIndex : 'ChkDesc'

					},**/{
						id : 'Chkstate',
						header : '审核状态',
						width : 80,
						editable:false,
						dataIndex : 'Chkstate'

					}],
					tbar:['预算项类别',SchTypeCombo,'-',searchbotton,'-',submit,'-',calculate,'-'],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',	
					loadMask: true,
					trackMouseOver: true,
					stripeRows: true
					

		});

 if(window.CollectGarbage){
	 window.setInterval("CollectGarbage();", 30000);
 }