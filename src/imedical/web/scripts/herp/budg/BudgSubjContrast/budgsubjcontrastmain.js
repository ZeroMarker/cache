var userid = session['LOGON.USERID'];

//------------------------------------------查询条件---------------------------------------------//
//---------- 所属系统 ------------//
var SysCodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

SysCodeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgsubjcontrastexe.csp?action=syscode',
						method : 'POST'
					});
		});

var SysCodeCom = new Ext.form.ComboBox({
			id:'SysCodeCom',
			store : SysCodeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			width : 150,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//--------------- 表格中的所属系统列 -------------------//
var SysCodeDs1 = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

SysCodeDs1.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgsubjcontrastexe.csp?action=syscode',
						method : 'POST'
					});
		});
		
var SubjDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

SubjDs.on('beforeload', function(ds, o){
	var type=SysCodeCom1.getValue();	
	if(!type)
	{
		Ext.Msg.show({title:'注意',msg:'请先选择第一列所属系统',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	
});

var SysCodeCom1 = new Ext.form.ComboBox({
			id:'SubjDs',
			store : SysCodeDs1,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			width : 150,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
           	 "select":function(combo,record,index){
	            SubjDs.removeAll();     
				SubjCom.setValue('');
				SubjDs.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgsubjcontrastexe.csp?action=subjcode&syscode='+combo.value,method:'POST'})  
				SubjDs.load({params:{start:0,limit:10}});           					
				}
			}
		});
		
//--------------- 所属系统中的项目编码 ------------------//
var SubjCom = new Ext.form.ComboBox({
			id:'SubjCom',
			store : SubjDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			width : 200,
			listWidth : 290,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//-------------------- 预算系统中的预算项 -----------------------//	
var BudgDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BudgDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgsubjcontrastexe.csp?action=budgcode',
						method : 'POST'
					});
		});

var BudgCom = new Ext.form.ComboBox({
			id:'BudgCom',
			store : BudgDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			width : 200,
			listWidth : 290,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//-------------------- 核算执行部门类别 -----------------------//	
var DeptTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['id', 'name'])
		});

DeptTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgsubjcontrastexe.csp?action=depttype',
						method : 'POST'
					});
		});

var DeptTypeCom = new Ext.form.ComboBox({
			id:'DeptTypeCom',
			store : DeptTypeDs,
			displayField : 'name',
			valueField : 'id',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
//-------------------- 查询按钮 --------------------------//
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){

	    var SysCode=SysCodeCom.getValue();
	    
		itemGrid.load({params:{start:0, limit:25,syscode:SysCode}});

		//itemGrid.load({params:{start:0,limit:25,ParamValueCon:ParamValueCon,BusiModuleNameCon:BusiModuleNameCon,ProjCodeName:ProjCodeName,SubjCodeName:SubjCodeName}});
	}
});


var itemGrid = new dhc.herp.Grid({
        title: '预算项关系对照表',
        width: 400,
        region: 'center',
        url: 'herp.budg.budgsubjcontrastexe.csp',
		atLoad : false,
		tbar:['所属系统:',SysCodeCom,findButton],
        fields: [{
             header: 'ID',
             dataIndex: 'rowid',
			 editable:false,
             hidden: true
        }, {
            id:'syscode',
            header: '所属系统',
			allowBlank: false,
			width:120,
            dataIndex: 'syscode',
            type:SysCodeCom1            
         },{
            id:'SubjCode',
            header: '项目编码',
			width:150,
			editable:false,
            dataIndex: 'SubjCode',
            renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
					cellmeta.css="cellColor4";// 设置可编辑的单元格背景色
					return '<span style="color:black;cursor:hand;backgroundColor:gray">'+value+'</span>';
            }
         },{
            id:'SubjName',
            header: '项目名称',
			width:270,
            dataIndex: 'SubjName',
            type:SubjCom
         },{
            id:'DeptType',
            header: '核算执行部门类别',
			width:120,
            dataIndex: 'DeptType',
            type:DeptTypeCom
         },{
            id:'BudgCode',
            header: '预算项编码',
		    editable:false,
		    width:180,
            dataIndex: 'BudgCode',
            renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
					cellmeta.css="cellColor4";// 设置可编辑的单元格背景色
					return '<span style="color:black;cursor:hand;backgroundColor:gray">'+value+'</span>';
            }

        },{
            id:'BudgName',
            header: '预算项名称',
			width:270,
            dataIndex: 'BudgName',
            type:BudgCom
        }
        ]
    
    });

itemGrid.btnPrintHide();
itemGrid.btnResetHide();

itemGrid.load({params:{start:0, limit:25}});

