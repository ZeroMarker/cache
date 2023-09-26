/*!
 * Ext JS Library 3.3.0
 */
/**
 * @creator:yunhaibao
 * @createdate: 20161220
 * @description:��װҩƷ�������б�
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
		 * @parmas {HospID:1,StkGrpType:"G"} ֱ�Ӵ��ݲ��� 
		 */
		params:null,
		/**
		 * @doms {StkGrpRowId:"M_StkGrpType"} ���ݽ����д��ڵ�Ԫ��,beforequery�л�ȡ��idֵ��Ϊ���� 
		 */	
		doms:null,
		displayFields : [
			{title:"����",index:'InciCode',length:'100px'},
			{title:"����",index:"InciDesc",length:'200px'},
			{title:"���",index:"Spec",length:'100px'},
			{title:"����",index:"ManfName",length:'200px'},
			{title:"������",index:"NotUseFlag",hidden:true,length:'50px'},
			{title:"InciDr",index:"InciDr",hidden:true,length:'200px'},
			{title:"PFac",index:"PFac",hidden:true,length:'200px'},
			{title:"Manfdr",index:"Manfdr",hidden:true,length:'200px'},
			{title:"PuomDr",index:"PuomDr",hidden:true,length:'200px'},
			{title:"ͨ����",index:"GeneName",hidden:true,length:'200px'},
			{title:"����",index:"PhcFormDesc",hidden:true,length:'200px'},
			{title:"��Ʒ��",index:"GoodName",hidden:true,length:'200px'}
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
				this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
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
//ע��xtype��
Ext.reg('inciCombo',Ext.ux.InciComboGridBox);
