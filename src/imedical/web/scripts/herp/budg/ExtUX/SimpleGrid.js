// /����: StkGrpComboBox.js
// /����: ��װGrid
// /��д�ߣ�zhangdongmei
// /��д����: 2012.04.10

 
	Ext.ns('Ext.ux');
	Ext.ux.SimpleGrid=Ext.extend(Ext.grid.EditorGridPanel,{
 		el:'',
		url:'', 
		mehod:'post',
		showRowNum:false,
		selMode:'no', //no����ѡ���,��ѡmulti����ѡsingle
		defaultCmConfig:{
			width: 100,
			sortable: true
		},
 		loadMask:{
  msg:'���ڼ�������,���Ժ�...'
 },
 baseParams:{},
 columns:[], 
 pageBar:null, 
    initComponent : function(){    
     var cmConfig=new Array();
  var objArray=new Array();
  if(this.showRowNum)
   cmConfig.push(new Ext.grid.RowNumberer());
  var sm=null;
  if(this.selMode){
   if(this.selMode=='single')
    sm=new Ext.grid.CheckboxSelectionModel({singleSelect:true});
   else if(this.selMode=='multi')
    sm=new Ext.grid.CheckboxSelectionModel();
   else if(this.selMode=='no')
    sm=null;
   else
    throw new Error("selMode�������ó���!");    
   if(sm!=null)
    cmConfig.push(sm);
  }  
  //��������
  var clData=this.columns;
  for(var i=0;i<clData.length;i++){
   var item=clData[i];
   var objItem={name:item.name,type:item.type};  
   objArray[i]=objItem;
   Ext.apply(item,{dataIndex:item.name});
   cmConfig.push(item);
  }
  var cm= new Ext.grid.ColumnModel({
         columns:cmConfig
     });
     if(this.defaultCmConfig)
      Ext.apply(cm,this.defaultCmConfig);
  Ext.apply(this,{cm:cm});
  if(sm)
   Ext.apply(this,{selModel:sm});
  var obj=Ext.data.Record.create(objArray);
  var store=new Ext.data.GroupingStore({
    baseParams:this.baseParams,
          proxy : new Ext.data.HttpProxy({
     url :this.url,  
     method:this.mehod
    }), 
          reader:new Ext.data.JsonReader({ 
              totalProperty:'sum', 
  root:'items'
          },obj)
  });  
  Ext.apply(this,{store:store}); 
  if(this.pageBar){
   var pb=new Ext.PagingToolbar({ 
    store:store,
    pageSize : this.pageBar.pageSize,
    displayInfo : true,
    displayMsg : '��ʾ�� {0} ���� {1} ����¼��һ�� {2} ��', 
emptyMsg : "û�м�¼"
   });
   Ext.apply(this,{bbar:pb});
  }
  Ext.ux.SimpleGrid.superclass.initComponent.call(this);
  this.addEvents("afterRender");
},
afterRender:function(){
 Ext.ux.SimpleGrid.superclass.afterRender.call(this);
 if (this.selMode == 'single') {
Ext.select('div.x-grid3-hd-checker').removeClass('x-grid3-hd-checker');
this.store.on('load', function() {
 Ext.select("div[class=x-grid3-row-checker]").each(function(x) {
x.addClass('x-grid3-row-radioBtn');
 });
});
this.getView().on('rowupdated', function() {
 Ext.select("div[class=x-grid3-row-checker]").each(function(x) {
  x.addClass('x-grid3-row-radioBtn');
     });
    });
  }
    }
	});
	Ext.reg('sg',Ext.ux.SimpleGrid); 
