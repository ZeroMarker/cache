/*!
 * Ext JS Library 3.3.0
 */
/**
 * @creator:yunhaibao
 * @createdate: 20161220
 * @description:封装药品的下拉列表
 */ 
Ext.ns('Ext.ux');
Ext.ux.InciComboGridBox=Ext.extend(
	Ext.ux.GridComboBox,
	{
		displayField : 'InciDesc',
	    valueField : 'InciDesc', 
	    triggerAction : 'all',   
	    allowBlank : false,   
	    forceSelection : false,   
	    mode : 'remote',
		selectOnFocus : true,
	    itemSelector: '.x-combo-list-item',
	    listWidth : 615, //'auto',
	    autoHeight:false,
		maxHeight : 250,
		//valueNotFoundText:'',
		pageSize : 50,
		minChars :1,
		queryDelay :1,
		hideTrigger:true,
		/**
		 * @parmas {HospID:1,StkGrpType:"G"} 直接传递参数 
		 */
		params:null,
		/**
		 * @doms {StkGrpRowId:"M_StkGrpType"} 传递界面中存在的元素,beforequery中获取该id值作为参数 
		 */	
		doms:null,
		displayFields : [
			{title:"代码",index:'InciCode',length:'100px'},
			{title:"名称",index:"InciDesc",length:'200px'},
			{title:"规格",index:"Spec",length:'100px'},
			{title:"厂家",index:"ManfName",length:'200px'},
			{title:"不可用",index:"NotUseFlag",hidden:true,length:'50px'},
			{title:"InciDr",index:"InciDr",hidden:true,length:'200px'},
			{title:"PFac",index:"PFac",hidden:true,length:'200px'},
			{title:"Manfdr",index:"Manfdr",hidden:true,length:'200px'},
			{title:"PuomDr",index:"PuomDr",hidden:true,length:'200px'},
			{title:"通用名",index:"GeneName",hidden:true,length:'200px'},
			{title:"剂型",index:"PhcFormDesc",hidden:true,length:'200px'},
			{title:"商品名",index:"GoodName",hidden:true,length:'200px'}
		],  
		initComponent:function(){
			var myUrl='dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog';
			this.store=new Ext.data.JsonStore({
				autoDestroy:true,
				url:myUrl,
				storeId:'InciComboGridBoxStore',
				idProperty:'RowId',
				root:'rows',
				totalProperty:'results',
				fields:['InciDesc','InciCode','Spec','ManfName','InciDr','PFac','Manfdr','PuomDr','NotUseFlag','GeneName','PhcFormDesc','GoodName']
			});
			this.on('beforequery',function(e){				
				var filter=this.getRawValue();
				this.store.removeAll();    //load之前remove原记录，否则容易出错
				this.store.setBaseParam("Input",filter);
				for(var param in this.params){
					var value=this.params[param];
					this.store.setBaseParam(param,value);
				}
				for (var dom in this.doms){
					var value=Ext.getCmp(this.doms[dom]).getValue();
					this.store.setBaseParam(dom,value);
				}
				this.store.load({params:{start:0,limit:100}});
				
			});
			Ext.ux.InciComboGridBox.superclass.initComponent.call(this);
		}
	}
)
//注册xtype的
Ext.reg('inciCombo',Ext.ux.InciComboGridBox);
