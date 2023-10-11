editFun = function(itemGrid,userid,data){
 var rowObj=itemGrid.getSelectionModel().getSelections();
var vouchcode = rowObj[0].get("VouchCode");
var date = rowObj[0].get("VouchDate");
var num	 = rowObj[0].get("num");
var tmptype	 = rowObj[0].get("typeId");
var typename = rowObj[0].get("typename");
var State	 = rowObj[0].get("State");
var IsDestroy= rowObj[0].get("IsDestroy");
var IsCancel = rowObj[0].get("IsCancel");
var PostDate = rowObj[0].get("PostDate");
var IsAcc = rowObj[0].get("IsAcc");
var IsDestroy = rowObj[0].get("IsDestroy");
var tmpSubjID="";
/////////////////////凭证号/////////////////////////
/*var VouchNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .12,
			emptyText: '',
			//disabled: true,
			value:vouchcode,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					typeid=VouchTypeCombo.getValue();;
					if (e.getKey() == Ext.EventObject.ENTER) {
					MakeDateField.focus();
						}
					}}

		});*/
/////////////凭证类型////////////
var VouchDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

VouchDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.acct.acctvouchexe.csp?action=getvouchno',method : 'POST'});
});

 VouchNo = new Ext.form.ComboBox({
	fieldLabel : '凭证号',
	store : VouchDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	value:typename,
	disabled:true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .12,
	selectOnFocus : true,
	listeners : {
					specialKey : function(field, e) {
					typeid=VouchTypeCombo.getValue();;
					if (e.getKey() == Ext.EventObject.ENTER) {
					MakeDateField.focus();
						}
					}}
});
/*VouchNo.on('select',function(combo,record, index){
var vouchno = VouchNo.getValue();
	addmainGrid.load({params:{start:0,limit:8,vouchno:vouchno}});
});*/

/////////////////////日期/////////////////////////		
 var MakeDateField = new Ext.form.DateField({
			fieldLabel: '日期',
			width:180,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			value:date,
			value: new Date(),
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(MakeDateField.getValue()!==""){
									attachfield.focus();
								}else{
									Handler = function(){MakeDateField.focus();};
									Ext.Msg.show({title:'错误',msg:'日期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									}
								}}
		});
/////////////////////附件/////////////////////////
 attachfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .05,
			disabled:true,
			selectOnFocus : true,
			value:num

		});		
/////////////凭证类型////////////
var VouchTypeDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

VouchTypeDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.acct.acctvouchexe.csp?action=getvouchtype',method : 'POST'});
});

 VouchTypeCombo = new Ext.form.ComboBox({
	fieldLabel : '凭证类型',
	store : VouchTypeDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	value:typename,
	disabled:true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true,
	listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(VouchTypeCombo.getValue()!==""){
									VouchNo.focus();
								}else{
									Handler = function(){VouchTypeCombo.focus();};
									Ext.Msg.show({title:'错误',msg:'凭证类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									}
								}}
});
VouchTypeCombo.on('select',function(combo, record, index){
			tmptype = combo.getValue();
		});


/////////////科目名称////////////
var SubNameDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

SubNameDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.acct.acctvouchexe.csp?action=getsubjname',method : 'POST'});
});
SubNameCombo = new Ext.form.ComboBox({
	fieldLabel : '科目名称',
	store : SubNameDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 150,
	listWidth : 250,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});
SubNameCombo.on('select',function(combo, record, index){
			tmpSubjID = combo.getValue();
		});

/////////////类别项名称////////////
var CheckItemDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

CheckItemDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.acct.acctvouchexe.csp?action=getcheckname',method : 'POST'});
});

CheckItemCombo = new Ext.form.ComboBox({
	fieldLabel : '类别项名称',
	store : CheckItemDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 150,
	listWidth : 250,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});

var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">记账凭证</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '凭证类别:',
					columnWidth : .1
				},VouchTypeCombo ,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '凭证号:',
					columnWidth : .1
				},VouchNo ,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '日期:',
					columnWidth : .1
				},MakeDateField,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .05
				}, {
					xtype : 'displayfield',
					value : '附件:',
					columnWidth : .04
				}, attachfield,{
					xtype : 'displayfield',
					value : '页',
					columnWidth : .02
				}

		]
	}]
});

/////////////////添加按钮////////////////////////////
var saveButton = new Ext.Toolbar.Button({
	text: '保存',
  	tooltip:'添加',        
  	iconCls: 'save',
	handler:function(){
	//VouchNo VouchTypeCombo  MakeDateField attachfield
	
	if(VouchNo.getValue()==""){
		Ext.Msg.show({title:'注意',msg:'凭证不能为空！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}		
	if(VouchTypeCombo.getValue()==""){
		Ext.Msg.show({title:'注意',msg:'凭证类别不能为空',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
			
	AddFun1();			//调用申请单据管理界面
	}
	
});
var tmpStore1 = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ''
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}),
			remoteSort : true
		});
		
///////////////科目辅助核算类表 //////////////////////////
var adddetailGrid = new dhc.herp.Gridvouchadddetail({
				width : 600,
				height : 120,
				region : 'south',
				url : 'herp.acct.acctvouchexe.csp',	
				store:tmpStore1,  			
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
						{
							header : '科目辅助核算类ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'SubjID',
							header : '科目ID',
							dataIndex : 'SubjID',
							width : 60,
							hidden : true
						},{
							id : 'TypeID',
							header : '核算类别ID',
							dataIndex : 'TypeID',
							width: 225,
							hidden : true
						},{
							id : 'typename',
							header : '核算类别',
							dataIndex : 'typename',
							width: 225,
							editable:false
						}]
			});

var addmainGrid = new dhc.herp.Gridvouchaddmain({
				width : 600,
				region : 'center',
				url : 'herp.acct.acctvouchexe.csp',
				//tbar : saveButton,
				forms : [],
				fields : [
				{//rowid^VouchID^SubjID^Summary^SubjCode^SubjName^AmtDebit^AmtCredit
							header : '凭证明细ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'VouchID',
							header : '主表ID',
							dataIndex : 'VouchID',
							hidden:true
						},{
							id : 'SubjID',
							header : '项目表ID',
							dataIndex : 'SubjID',
							hidden:true,
							type:SubNameCombo
						},{
							id : 'Summary',
							header : '摘要',
							dataIndex : 'Summary',
							editable:false,
							value:"冲销第n期第n号凭证",
							width : 120
						},{
							id : 'SubjName',
							header : '科目名称',
							dataIndex : 'SubjName',
							width : 150,
							editable:false,
							type:SubNameCombo
						},{
							id : 'AmtDebit',
							header : '借方金额',
							dataIndex : 'AmtDebit',
							align:'right',
							xtype:'numbercolumn',
							editable:false,
							width : 120
						},{
							id : 'AmtCredit',
							header : '贷方金额',
							dataIndex : 'AmtCredit',
							align:'right',
							xtype:'numbercolumn',
							editable:false,
							width : 120
						}],
						viewConfig : {forceFit : true}
});

if(((State=="")||(State=="0"))&&(IsDestroy!="是")&&(IsCancel!="是"))
{
addmainGrid.addButton(saveButton);
}
addmainGrid.load({params:{start:0,limit:8,vouchno:vouchcode}});

//单击单据状态 单击gird的单元格事件
addmainGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
               	
	var records = addmainGrid.getSelectionModel().getSelections();	
	var rowid  = records[0].get("rowid");
	var SubjID  = tmpSubjID;
	if(SubjID==""){
	var SubjID  = records[0].get("SubjID");
	}
	
	//adddetailGrid.load({params:{start:0,limit:25,SubjID:SubjID,vouchdetail:rowid}});

var schemRowId = "";
var schemName = "";


itemGrid.getStore().on('beforeload', function(ds, o){		
		showBonusDetail(adddetailGrid, 0, '');
		});

showBonusDetail(adddetailGrid, 0, '');
function showBonusDetail(grid, rowIndex, e) {
	Ext.Ajax.request({
		url : '../csp/herp.acct.acctvouchexe.csp?action=getTitleInfo&SubjID='+SubjID,
		waitMsg : '操作中...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '错误',
						msg : '请检查网络连接!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		},
		success : function(result, request) {
			//var jsonData=""
			var jsonData = Ext.util.JSON.decode(result.responseText);
			
			var cmItems = [];
			var cmConfig = {};
			// cmItems.push(sm);
			cmItems.push(new Ext.grid.RowNumberer());
			
		
			var cmConfig = {};
			var jsonHeadNum = jsonData.results;
			var jsonHeadList = jsonData.rows;
			var tmpDataMapping = [];

			for (var i = 0; i < jsonHeadList.length; i++) {
				
				cmConfig = {
					header : jsonHeadList[i].title,
					dataIndex : jsonHeadList[i].IndexName,
					width : 120,
					sortable : true,
					/*editor : CheckItemCombo,
					renderer: function(value){
                   	var record = CheckItemDs.getById(value);
		                   if(record)
		                   {
		                       return record.data.name;
		                   }
		                   else return value;
           			},*/
					align : 'left'
				};

				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// 提取奖金项数据
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping

			tmpStore1.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.acct.acctvouchexe.csp?action=getdata&SubjID='+SubjID+'&vouchdetail='+rowid,
				method : 'POST'
			})

			tmpStore1.reader = new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, tmpDataMapping);
					
			adddetailGrid.reconfigure(tmpStore1, tmpColumnModel);
			tmpStore1.load({
						params : {
							start : 0,
							limit : 25
						}
					});
		},
		scope : this
	});

}
});

	AddFun1=function() {
		var records=addmainGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = addmainGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
	    var datadd="";
	    /*var rowObj=adddetailGrid.getSelectionModel().getSelections();
	    var len = rowObj.length;
	    if(len >=1){
	    for(var i = 0; i < len; i++){
	    	var TypeID = rowObj[i].get("TypeID");		
			datadd=datadd+"^"+TypeID;
		}}*/
		Ext.each(records, function(r) {

		var rowObj=adddetailGrid.store.getModifiedRecords();
	    var ItemID = "";
	    var datadd="";
	    Ext.each(rowObj, function(r) {
		var o = {};
		var tmpstro =r.data['rowid'];
	    for (var f in r.getChanges()) {
					o[f] = r.data[f];
					datadd=datadd+"^"+r.data[f].toString();//+","+f
				}
	    });		
		//alert(datadd);
		
		
			var o = {};
			var tmpstro = "&rowidd=" + r.data['rowid']+"&rowidm="+r.data['VouchID'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < addmainGrid.fields.length; i++) {
				var indx = addmainGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = addmainGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
							var info = "[" + title + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}
				
			}
			// 数据完整性验证END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}
			var rowidd = r.data['rowid'];
			var SubjID1  = tmpSubjID;
			if (SubjID1==""){
			var SubjID1 = r.data['SubjID'];
			}
			var summary1 = r.data['Summary'];
			var amtDebit1 = r.data['AmtDebit'];
			var amtDebit1 = amtDebit1*(-1);
			var amtCredit1 = r.data['AmtCredit'];
			var amtCredit1 = amtCredit1*(-1);
			var datad = SubjID1+"|"+summary1+"|"+amtDebit1+"|"+amtCredit1;
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			//userid VouchNo MakeDateField attachfield VouchTypeCombo
			//VouchTypeID^vouchDate^vouchBillNum^operator^vouchno 
			
			var vouvhtype = tmptype;
			var vouchDate = MakeDateField.getValue().format('Y-m-d');
			var vouchBillNum = attachfield.getValue();
			var vouchno = VouchNo.getValue();
			var VouchSource='02';
			var datam = vouvhtype+"|"+vouchDate+"|"+vouchBillNum+"|"+userid+"|"+vouchno+"|"+VouchSource;
			var rowidm="";
			var recordType;
			//PostDate
			if(PostDate != null && vouchDate != null && vouchDate > PostDate){
                Ext.Msg.show({
                    title:'提示',
                    msg: '时间输入不正确（冲销日期不能大于记账日期日期）',
                    buttons: Ext.Msg.OK,
                    icon: Ext.Msg.ERROR
                });
                return;
            }
            if(IsAcc=='1'){
            	Ext.Msg.show({
                    title:'提示',
                    msg: '该凭证没有记账，不能冲销!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.Msg.ERROR
                });
                return;
            }
            if(IsDestroy=='是'){
            	Ext.Msg.show({
                    title:'提示',
                    msg: '该凭证已经被冲销，不能冲销！',
                    buttons: Ext.Msg.OK,
                    icon: Ext.Msg.ERROR
                });
                return;
            }
			recordType = "add";
		
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = addmainGrid.url + '?action=' + recordType + tmpstro.toString()+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
					+"&datadd="+encodeURIComponent(datadd)+ Ext.urlEncode(this.urlParam);
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						addmainGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							addmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addmainGrid.getTopToolbar().cursor)
											? 0
											: addmainGrid.getTopToolbar().cursor,
									limit : addmainGrid.pageSize,
									vouchno:vouchno
								}
							});
							adddetailGrid.load({params:{start:0,limit:25,SubjID:SubjID1,vouchdetail:rowidd}});
						}
					} else {
						if (jsonData.refresh == 'true') {
							addmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addmainGrid.getTopToolbar().cursor)
											? 0
											: addmainGrid.getTopToolbar().cursor,
									limit : addmainGrid.pageSize,
									vouchno:vouchno
								}
							});
							adddetailGrid.load({params:{start:0,limit:25,SubjID:SubjID1,vouchdetail:rowidd}});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的科目已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						addmainGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}

	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	 itemGrid.load({params:{start:0,limit:25,data:data}});
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,addmainGrid,adddetailGrid]
			});

	var tabPanel =  new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,addmainGrid,adddetailGrid]                                 //添加Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : '记账凭证',
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	window.show();	
}


