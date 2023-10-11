
var Url1 = 'herp.srm.PrjAppropriationdetailexe.csp';
//alert(Url1);
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
						url:Url1+'?action=submit&rowid2='+rowObj[i].get("RowID")+'&userdr='+encodeURIComponent(usercode),
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
								var message='提交失败!';
								if(jsonData.info=='请先保存后提交') message="请先保存后提交";
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

var FundSourcesStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '申请科学事业费支持'], ['2', '市财政其他专项资金拨款'], ['3', '单位自筹'], ['4', '国家、省专项拨款'], ['5', '银行贷款'], ['6', '其他']]
		});
var FundSourcesField = new Ext.form.ComboBox({
			fieldLabel : '项目经费来源',
			width : 100,
			listWidth : 120,
			selectOnFocus : true,
			store : FundSourcesStore,
			anchor : '90%',
			//valueNotFoundText : '',  //点击一下grid中单元格会造成单元格内容置空；
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var FundFormStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '支票'], ['2', '现金'], ['3', '其他']]
		});
var FundFormField = new Ext.form.ComboBox({
			fieldLabel : '经费形式',
			width : 100,
			listWidth : 120,
			selectOnFocus : true,
			store : FundFormStore,
			anchor : '90%',
			//valueNotFoundText : '',  //点击一下grid中单元格会造成单元格内容置空；
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
		
/*
var ArriveDateFields = new Ext.form.DateField({
		id : 'ArriveDateFields',
		format : 'Y-m-d',
		fieldLabel:'录入时间',
		width : 120,
		editable:true,
		allowBlank: false,
		emptyText : '请选择开始日期...'
	
		
		});
*/
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.PrjAppropriationdetailexe.csp?action=applyerList',
						method : 'POST'
					});
		});

var user1Combo = new Ext.form.ComboBox({
			fieldLabel : '接收人 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});



 function Todate(num) { 
 
            num = num + "";
            var date = "";
            var month = new Array();
            month["Jan"] = 1; month["Feb"] = 2; month["Mar"] = 3; month["Apr"] = 4; month["May"] = 5; month["Jan"] = 6;
            month["Jul"] = 7; month["Aug"] = 8; month["Sep"] = 9; month["Oct"] = 10; month["Nov"] = 11; month["Dec"] = 12;
            var week = new Array();
            week["Mon"] = "一"; week["Tue"] = "二"; week["Wed"] = "三"; week["Thu"] = "四"; week["Fri"] = "五"; week["Sat"] = "六"; week["Sun"] = "日";
            str = num.split(" ");
            date = str[5] + "-";
            date = date + month[str[1]] + "-" + str[2];
            return date;
        };
/**
  renderer: function(value,metaData,record,colIndex,store,view) {
            value = Ext.util.Format.date(value,'Y-m-d H:i:s');
               return (value==null||value=="")?"--":value;
        }
**/

	var arriveexpenditure = new Ext.form.TextField({
		id: 'arriveexpenditure',
		fieldLabel: '到位经费',
		width:200,
		//allowBlank: false,
		listWidth : 260,
		//regex:/[0-9]/,
		//regexText:"年度编码只能为数字",
		triggerAction: 'all',
		//emptyText:'年度编码只能为数字',
		regex: /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/,
		regexText : "只能填数字",
		name: 'arriveexpenditure',
		allowBlank: false,
		minChars: 1,
		pageSize: 10,
		editable:true
	});



var DetailGrid = new dhc.herp.Gridhss({
	 title: '项目到位经费明细信息列表',
		    iconCls: 'list',
			region : 'center',
			url : Url1,	
	       //view : new MyGridView(viewConfig),	
	        cm : colModel,
	        //selModel:sm,
	        readerModel:'remote',		
			fields :  [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
				        id:'RowID',
						header : '到位经费信息ID',
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
						id : 'arriveexpenditure',
						header : '到位经费(万元)',
						width : 100,
						//editable:false,
						align:'right',
						dataIndex : 'arriveexpenditure',
						type: arriveexpenditure,
						allowBlank: false,
						renderer: function(val)
         				{
	        				val=val.replace(/(^\s*)|(\s*$)/g, "");
	         				val=Ext.util.Format.number(val,'0.00');
	         				val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         				return val?val:'';
		 				}

					},{
						id : 'recipient',
						header : '接收人',
						width : 60,
						//editable:false,
						allowBlank: false,
						dataIndex : 'recipient',
						type: user1Combo
					},{
       					id:'ArriveDate',
        				header: '到位时间',
        				width:80,
						//tip:true,
						allowBlank: false,
        				dataIndex: 'ArriveDate',
        				type:'dateField'
					},{
       					id:'FundSources',
        				header: '项目经费来源',
        				width:120,
						//tip:true,
						allowBlank: false,
        				dataIndex: 'FundSources',
        				type: FundSourcesField,
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
		
    				},{
       					id:'FundForm',
        				header: '经费形式',
        				width:100,
						//tip:true,
						allowBlank: false,
        				dataIndex: 'FundForm',
        				type: FundFormField
    				},{
						id : 'midcheckFlag',
						header : '数据状态',
						width : 60,
						editable:false,
						dataIndex : 'midcheckFlag'

					},{
						id : 'midcheckState',
						header : '审核状态',
						width : 180,
						editable:false,
						dataIndex : 'midcheckState'

					},{
						id : 'midcheckopinion',
						header : '审批意见',
						width : 180,
						editable:false,
						//hidden:true,
						dataIndex : 'midcheckopinion'
           // type:grafundsField,//引用定义的数值文本框
					},{
						id : 'ApplyName',
						header : '录入人',
						editable:false,
						width : 60,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '录入时间',
						editable:false,
						width : 80,
						dataIndex :'MidDate'

					},{
						id : 'CheckName',
						header : '审核人',
						width : 120,
						hidden : true,
						editable:false,
						dataIndex : 'CheckName'

					},{
						id : 'CheckDate',
						header : '审核时间',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'CheckDate'

					},{
						id : 'desc',
						header : '备注说明',
						width : 180,
						//editable:false,
						allowBlank: true,
						dataIndex : 'desc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

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
 
		//DetailGrid.btnAddHide();  //隐藏增加按钮
		//DetailGrid.btnSaveHide();  //隐藏保存按钮
		//DetailGrid.btnResetHide();  //隐藏重置按钮
		//DetailGrid.btnDeleteHide(); //隐藏删除按钮
		// DetailGrid.btnPrintHide();  //隐藏打印按钮
		//DetailGrid.addButton('-');
		DetailGrid.addButton(RewardApplyButton);
       // DetailGrid.load({params:{start:0, limit:25}});


