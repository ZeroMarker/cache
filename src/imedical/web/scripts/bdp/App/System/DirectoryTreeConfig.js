/// 名称: 目录树配置
/// 描述: 目录树配置
/// 编写者： 基础数据平台组 高姗姗
/// 编写日期: 2017-1-20
	var SAVE_URL_Config = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBConfig&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.RBConfig"
	var BindingRule="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DirectoryTreeConfig&pClassQuery=GetDataForCmb1";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBConfig&pClassMethod=OpenData";
	
	var pagesize_Config = Ext.BDP.FunLib.PageSize.Pop; 
       
	/**--------------------↓目录树配置部分---------------------------**/
	var table=new Ext.form.TextField({ 
		id:'hidden_table',
	    fieldLabel: 'table',
		hideLabel:'True',
		hidden : true,
		name: 'hidden_table'
	});
    var RuleStore=new Ext.data.JsonStore({
		url:BindingRule,
		autoLoad: true,
		root: 'data',
		totalProperty: 'total',
		idProperty: 'RowId',
		fields:['RowId','Desc'],
		remoteSort: true,
		sortInfo: {field: 'RowId', direction: 'ASC'}
	});
	var Rule = new Ext.BDP.Component.form.ComboBox({            	
		fieldLabel: "<span style='color:red;'>*</span>规则",
		blankText: '不能为空',
		allowBlank : false,
		loadByIdParam : 'rowid',
		name: 'Rule',
		id:'RuleF',
		width:180,
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RuleF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('RuleF'),
   		//disabled : Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDR'),
		hiddenName:'Rule',//不能与id相同
		forceSelection: true,
		//queryParam:"desc",
		triggerAction : 'all',
		selectOnFocus:false,
		typeAhead:true,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		minChars: 0,
		listWidth:250,
		valueField:'RowId',
		displayField:'Desc',
		store:RuleStore
    });    

    var WinFormConfig = new Ext.form.FormPanel({
		id : 'form-Config-save',
		split : true,
		frame : true,
		reader: new Ext.data.JsonReader({root:'data'},	          
		    [{ name: 'RESCTLOCDR', mapping:'RESCTLOCDR',type: 'string'},
		    { name: 'hidden_table', mapping:'hidden_table',type: 'string'}]
			),
		labelWidth:50,
		items : [Rule,table]
	});

	function getConfigPanel(){
		var winDirectoryTreeConfig = new Ext.Window({
				title:'',
				width:300,
	            height:130,
				layout:'fit',
				plain:true,//true则主体背景透明
				modal:true,
				frame:true,
				//autoScroll: true,
				collapsible:true,
				hideCollapseTool:true,
				titleCollapse: true,
				bodyStyle:'padding:3px',
				buttonAlign:'center',
				closeAction:'hide',
				items: WinFormConfig,
				buttons : [{
					text : '确定',
					iconCls : 'icon-ok',
					id:'save_btn_Config',
		   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_Config'),
					handler : function() {
						if(WinFormConfig.getForm().isValid()==false){
							 return;
						}
						var table=Ext.getCmp('hidden_table').getValue();
						var Rule=Ext.getCmp('RuleF').getValue();
						var saveflag =tkMakeServerCall("web.DHCBL.CT.DirectoryTreeConfig","SaveData",table,Rule);
						if(saveflag==1)
						{
							//Ext.Msg.show({ title : '提示', msg : '保存成功!', minWidth : 200, icon : Ext.Msg.INFO, buttons : Ext.Msg.OK });
							var FlagType=tkMakeServerCall("web.DHCBL.CT.DirectoryTreeConfig","OpenData",table);
							if (table=="User.CTLoc"){
			        			document.cookie = "CTLocFlagType="+FlagType;
							}else if (table=="User.SSUser"){
								document.cookie = "SSUserFlagType="+FlagType;
							}
			        		window.location.reload();
						}else{
							Ext.Msg.show({ title : '提示', msg : '保存失败!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
						}
					}
				}],
				listeners:{
					"show":function(){
					},
					"hide":function(){
					},
					"close":function(){
					}
				}
			});
	  	return winDirectoryTreeConfig;
	}
	
	/**--------------------↑目录树配置部分---------------------------**/	