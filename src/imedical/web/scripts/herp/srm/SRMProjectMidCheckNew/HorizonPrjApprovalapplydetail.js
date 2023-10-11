//项目中检信息
//why
var aaaa = 'herp.srm.projectmidchecknewdetailexe.csp';
//alert(aaaa);
var usercode = session['LOGON.USERCODE'];


var RewardApplyButton  = new Ext.Toolbar.Button({
		text: '提交',  
        iconCls: 'pencil',
        handler:function(){
		//定义并初始化行对象
		var rowObj=DetailGrid.getSelectionModel().getSelections();
		//alert(rowObj);
		var rowObj1=itemGrid.getSelectionModel().getSelections();
		var state = rowObj1[0].get("rowid");
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要申请的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("midcheckFlag")=="已提交"){
				Ext.Msg.show({title:'注意',msg:'已提交申请数据不能再提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			//var firstAuthor=rowObj[j].get("FristAuthorName")+"的";
		 
		}
		
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:aaaa+'?action=submit&rowid2='+rowObj[i].get("RowID"),
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DetailGrid.load({params:{start:0, limit:12,rowid:state}});								
							}else{
								var message='项目中检申请失败!';
								if(jsonData.info=="RepInvoice") message="不能重复申请";
								if(jsonData.info=="该人员在科研人员中不存在!") message="该人员在科研人员中不存在!";
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要申请所选记录吗?',handler);
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
	title: '项目中检明细信息维护',iconCls: 'list',
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
						header : '中检信息ID',
						dataIndex : 'RowID',
						hidden : true
					},{
						id : 'rowid',
						header : '课题信息id',
						width : 200,
						hidden : true,
						dataIndex : 'rowid'

					},
					{
						id : 'Detail',
						header : '中检信息内容',
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
							header: '附件',
							//allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'download',
							header: '下载',
							//allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					} },{
						id : 'midcheckFlag',
						header : '数据状态',
						width : 60,
						editable:false,
						dataIndex : 'midcheckFlag'

					},{
						id : 'midcheckState',
						header : '审核状态',
						width : 100,
						editable:false,
						dataIndex : 'midcheckState'

					},{
						id : 'midcheckopinion',
						header : '审批意见',
						width : 120,
						editable:false,
						//hidden:true,
						dataIndex : 'midcheckopinion'
           // type:grafundsField,//引用定义的数值文本框
					},{
						id : 'ApplyName',
						header : '申请人',
						editable:false,
						width : 80,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '申请时间',
						editable:false,
						width : 80,
						dataIndex :'MidDate'

					},{
						id : 'CheckName',
						header : '审核人',
						width : 80,
						editable:false,
						dataIndex : 'CheckName'

					},{
						id : 'CheckDate',
						header : '审核时间',
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
 
		//DetailGrid.btnAddHide();  //隐藏增加按钮
		//DetailGrid.btnSaveHide();  //隐藏保存按钮
		//DetailGrid.btnResetHide();  //隐藏重置按钮
		//DetailGrid.btnDeleteHide(); //隐藏删除按钮
		//DetailGrid.btnPrintHide();  //隐藏打印按钮
		//DetailGrid.addButton('-');
		DetailGrid.addButton(RewardApplyButton);
       // DetailGrid.load({params:{start:0, limit:25}});

  uploadMainFun(DetailGrid ,'RowID','C007',5);
    downloadMainFun(DetailGrid ,'RowID','C007',6);


