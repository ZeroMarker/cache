var userid = session['LOGON.USERID'];

//------------------------------------------查询条件---------------------------------------------//
////////////////// 查询条件系统业务模块 ///////////////////
var BusiModuleNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BusiModuleNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=busimodulenamelist',
						method : 'POST'
					});
		});

var BusiModuleNameCom = new Ext.form.ComboBox({
			id:'busimodulename',
			store : BusiModuleNameDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '业务模块名称',
			width : 180,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
////////////////// 查询条件余额方向 ///////////////////
var ParamValueCom1 = new Ext.form.ComboBox({	
			id:'ParamValueCom1',											
			fieldLabel: '余额方向',
			width:100,
			listWidth : 100,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '借方'], ['-1', '贷方']]
				}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '余额方向',
			selectOnFocus:'true'
});

///////////// 查询条件项目 //////////////////////
var ProjText = new Ext.form.TextField({
			fieldLabel: '',
			width:100,
			emptyText:'项目编码或名称',
			selectOnFocus:'true'
});

///////////// 查询条件科目 //////////////////////
var SubjText = new Ext.form.TextField({
			fieldLabel: '',
			width:100,
			emptyText:'科目编码或名称',
			selectOnFocus:'true'
});


//----------------------------------------表格中的下拉框---------------------------------------------//		
////////////////// 表格中系统业务模块 ///////////////////		
var BusiModuleNameDs1 = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BusiModuleNameDs1.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=busimodulenamelist',
						method : 'POST'
					});
		});

var BusiModuleNameCom1 = new Ext.form.ComboBox({
			id:'busimodulename1',
			store : BusiModuleNameDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '系统业务模块名称',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
            "select":function(combo,record,index){
	            AcctSubjDs.removeAll();     
				AcctSubjCom.setValue('');
				AcctSubjDs.proxy = new Ext.data.HttpProxy({url:'herp.acct.acctvouchinterfacemapexe.csp?action=acctsubjlist&BusiModuleCode='+combo.value,method:'POST'})  
				AcctSubjDs.load({params:{start:0,limit:10}});      					
			}
	   }	
		});


////////////////// 表格中会计部门分类 ///////////////////		
var AcctDeptTypeNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

AcctDeptTypeNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=acctdepttypelist',
						method : 'POST'
					});
		});

var AcctDeptTypeNameCom = new Ext.form.ComboBox({
			id:'AcctDeptTypeNameCom',
			store : AcctDeptTypeNameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '会计部门分类',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

////////////////// 表格中会计科目 ///////////////////

var AcctSubjDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name','IsCashFlow'])
});

AcctSubjDs.on('beforeload', function(ds, o){

    var code=BusiModuleNameCom1.getValue();	
	if(!code){
		Ext.Msg.show({title:'注意',msg:'请先选择业务模块号',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	
	//ds.proxy=new Ext.data.HttpProxy({
	
		//url:'herp.acct.acctvouchinterfacemapexe.csp?action=acctsubjlist',method:'POST'})
});	
 var AcctSubjCom = new Ext.form.ComboBox({
			id:'AcctSubjCom',
			store : AcctSubjDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '会计科目',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
			
		});
////////////////// 表格中预算科目 ///////////////////
var budgSubjDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

budgSubjDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=budgsubjlist',
						method : 'POST'
					});
		});
		
var BudgSubjCom = new Ext.form.ComboBox({
			id:'AcctSubjCom',
			store : budgSubjDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '预算科目',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

////////////////// 余额方向 ///////////////////
var ParamValueCom = new Ext.form.ComboBox({												
			fieldLabel: '余额方向',
			width:80,
			listWidth : 80,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '借方'], ['-1', '贷方']]
				}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			value : '1',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '选择...',
			selectOnFocus:'true'
});
////////////////// 自动生成凭证或者手动生成 ///////////////////
var IsAutoCom = new Ext.form.ComboBox({												
			fieldLabel: '是否自动',
			width:80,
			listWidth : 80,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '自动'], ['2', '手动']]
				}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			value : '1',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '选择...',
			selectOnFocus:'true'
});
///资金流向
var CashFlowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

CashFlowDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=CashFlowlist',
						method : 'POST'
					});
			
		});
	
	
 var CashFlowCom = new Ext.form.ComboBox({
			id:'CashFlowCom',
			store : CashFlowDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '资金流向',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
////////////////// 单位帐套 ///////////////////
var AcctBookDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

AcctBookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctvouchinterfacemapexe.csp?action=acctbooklist',
						method : 'POST'
					});
		});

var AcctBookCom = new Ext.form.ComboBox({
			id:'AcctBookCom',
			store : AcctBookDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '单位帐套',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//////////////////// 查询按钮 //////////////////////
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var ParamValueCon=ParamValueCom1.getValue();
	    var BusiModuleNameCon=BusiModuleNameCom.getValue();
	    var ProjCodeName=ProjText.getValue();
	    var SubjCodeName=SubjText.getValue();
		
		itemGrid.load({params:{start:0,limit:25,ParamValueCon:ParamValueCon,BusiModuleNameCon:BusiModuleNameCon,ProjCodeName:ProjCodeName,SubjCodeName:SubjCodeName}});
	}
});
var saveButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler :function() {
						var recs=itemGrid.getStore().getModifiedRecords();//这个记录数会被保持到store下次load之前  
             			alert("被修改记录的个数"+recs.length)  
              
                	//后台得到整条记录          
       				 if(recs.length==0){  
            				return  
        			}else{  
        					for(var i=0;i<recs.length;i++){
	        					var rowid = recs[i].get("1601");
	        					var BusiModuleName = recs[i].get("2");
								var ItemCode = recs[i].get("3");
								var ItemName = recs[i].get("4");
								var AcctDeptTypeName = recs[i].get("5");
								var AcctSubjName = recs[i].get("6|12");
								var AcctSummary = recs[i].get("7");
								var AcctDirection = recs[i].get("8");
								var ZjlxID = recs[i].get("9:12");
								var IsAuto = recs[i].get("1");
								var AcctBookName = recs[i].get("1");
								var moneySource = recs[i].get("1");
								
	        					Ext.Ajax.request({
		        					url:'../csp/herp.acct.acctvouchinterfacemapexe.csp?action=edit&rowid='+rowid+'&BusiModuleName='+encodeURIComponent(BusiModuleName)+'&ItemCode='+encodeURIComponent(ItemCode)+'&ItemName='+encodeURIComponent(ItemName)+'&AcctDeptTypeName='+encodeURIComponent(AcctDeptTypeName)+'&AcctSubjName='+encodeURIComponent(AcctSubjName)+'&AcctSummary='+encodeURIComponent(AcctSummary)+'&AcctDirection='+encodeURIComponent(AcctDirection)+'&ZjlxID='+encodeURIComponent(ZjlxID)+'&IsAuto='+encodeURIComponent(IsAuto)+'&AcctBookName='+encodeURIComponent(AcctBookName)+'&moneySource='+encodeURIComponent(moneySource),
		        					waitMsg:'保存中...',
									failure: function(result, request){		
										Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									},
									success: function(result, request){
										var jsonData = Ext.util.JSON.decode( result.responseText );
										if (jsonData.success=='true'){				
											Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
											
											//itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
										}
										else
										{
											Ext.Msg.show({title:'错误',msg:'修改失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
						
									}
		        				});
	        				}
            				
        			}}		
				});
var printButton = new Ext.Toolbar.Button({
    text : '打印',
	tooltip : '点击打印',
	width : 70,
	height : 30,
	iconCls : 'option',
	handler : function() {
	var syscode=BusiModuleNameCom.getValue();
	if(syscode=="")
	{
		Ext.Msg.show({title : '注意',msg : '请先选择业务模块名称!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
		return ;
	}
	var fileName="{herp.acct.inter.VouchInterfaceMap.raq(code="+syscode+")}";
	DHCCPM_RQDirectPrint(fileName);

    }
});


var itemGrid = new dhc.herp.Grid({
        title: '凭证接口配置',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctvouchinterfacemapexe.csp',
				atLoad : false,
				tbar:[BusiModuleNameCom,'-',ProjText,'-',SubjText,'-',ParamValueCom1,'-',findButton],
        fields: [{
             header: 'ID',
             dataIndex: 'rowid',
						 edit:false,
             hidden: true
        }, {
            id:'BusiModuleName',
            header: '业务模块',
						allowBlank: false,
						width:120,
            dataIndex: 'BusiModuleName',
            type:BusiModuleNameCom1
        },{
            id:'ItemCode',
            header: '项目编码',
		    		allowBlank: false,
		    		width:120,
            dataIndex: 'ItemCode'
        },{
            id:'ItemName',
            header: '项目名称',
						allowBlank: false,
						width:180,
            dataIndex: 'ItemName'
        },{
            id:'AcctDeptTypeName',
            header: '执行部门',
						allowBlank: false,
						width:90,
            dataIndex: 'AcctDeptTypeName',
            type:AcctDeptTypeNameCom
        },{
            id:'AcctSubjName',
            header: '会计科目',
						width:250,
            dataIndex: 'AcctSubjName',
            type:AcctSubjCom
        },{
            id:'AcctSummary',
            header: '会计摘要',
						width:180,
            dataIndex: 'AcctSummary'
        },{
            id:'AcctDirection',
            header: '余额方向',
						allowBlank: false,
						width:80,
            dataIndex: 'AcctDirection',
            type:ParamValueCom
        },{
            id:'ZjlxID',
            header: '资金流向',
			allowBlank: true,
						width:250,
            dataIndex: 'ZjlxID',
            type:CashFlowCom
        },{
            id:'IsAuto',
            header: '是否自动',
						allowBlank: true,
						width:80,
            dataIndex: 'IsAuto',
            type:IsAutoCom
        },{
            id:'MoneySource',
            header: '资金来源',
						allowBlank: true,
						width:80,
            dataIndex: 'MoneySource'
        },{
            id:'AcctBookName',
            header: '单位帐套',
						allowBlank: true,
						width:70,
            dataIndex: 'AcctBookName',
            type:AcctBookCom
        }]
    
    });

itemGrid.btnPrintHide();
itemGrid.btnResetHide();
//itemGrid.addButton(printButton);
//itemGrid.addButton(saveButton);