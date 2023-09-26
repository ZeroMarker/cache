(function() {
	Ext.ns("dhcwl.mripdaytask.DisConditionCfg");
})();
// /描述: 出院情况对应设置界面
// /编写者： 陈乙
// /编写日期: 2015-02-14
dhcwl.mripdaytask.DisConditionCfg = function() {
    //定义指标的存储模型
    var disstore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/mripdaytask/mripdaytaskdiscondiciont.csp?action=GetDisCondicionts'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'ID'},
            	{name: 'Desc'},
            	{name: 'DescSet'}
            
       		]
    	})
    });
 
    var disCondiciontSetCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		frame:true,
		enableKeyEvents:true,
		selectOnFocus:true,
		name : 'disCondiciontSetCombo',
		displayField : 'condiciontDisp',
		valueField : 'condiciontValue',
		store : new Ext.data.JsonStore({
			fields : ['condiciontDisp', 'condiciontValue'],
			data : [{
				condiciontDisp : '治愈人数',
				condiciontValue : '治愈人数'
			},{
				condiciontDisp : '好转人数',
				condiciontValue : '好转人数'
			},{
				condiciontDisp : '未愈人数',
				condiciontValue : '未愈人数'
			},{
				condiciontDisp : '死亡人数',
				condiciontValue : '死亡人数'
			},{
				condiciontDisp : '其他人数',
				condiciontValue : '其他人数'
			}
			]})	
	});

	var columnModel = new Ext.grid.ColumnModel(
	{
	 columns: [
		//new Ext.grid.RowNumberer(),csm,
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, menuDisabled : true
        },{header:'出院情况明细',dataIndex:'Desc', width: 350, sortable: true, menuDisabled : true
        },{
            header: '出院情况归组选择',
            dataIndex: 'DescSet',
            width: 350,
            //css : 'background: #FF0000;',   //背景颜色
            css:'color:#436EEE;',
            editor:new Ext.grid.GridEditor(disCondiciontSetCombo), 
            menuDisabled : true,
            sortable: true
        }
        
    ]});
    
//var ConditionGrid = new Ext.grid.GridPanel({
var ConditionGrid = new Ext.grid.EditorGridPanel({
        id:"dhcwl.mripdaytask.DisConditionCfg.disTables",
        resizeAble:true,
        height:600,
        width:1200,
        //layout:'center',
        autoScroll : true,
        clicksToEdit: true,
        store: disstore,
        cm: columnModel,
        tbar: [{
            text: '<span style="line-Height:1">保存</span>',		
            icon: '../images/uiimages/filesave.png',
            handler : function(){			
					var str = "Null";
					//遍历列表
					ConditionGrid.store.each(function (record,rerultStr) {				
						var ID = record.data.ID;
						var Desc = record.data.Desc;
						var DescSet = record.data.DescSet;
						if (str=="Null")  
							str=ID+'^'+Desc+'^'+DescSet;
						else{
							str=str+'|'+ID+'^'+Desc+'^'+DescSet;
						}
					});
					//alert(str);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/mripdaytask/mripdaytaskdiscondiciont.csp?action=SaveDisCondicionts',{'str':str});
					disstore.load({params:{start:0,limit:20000,onePage:1}});  //重新加载
            }
        }]
    }); 
    
	var disConditionCfgPanel = new Ext.Panel({
		//labelWidth : 15, // label settings here cascade unless overridden
		frame : true,
		title : '出院情况对应设置',
		layout:'fit',
		items : ConditionGrid

	});
	disstore.load({params:{start:0,limit:20000,onePage:1}});
	//disstore.load({params:{start:0,limit:10000,onePage:100}});
	this.getDisConditionCfgPanel = function() {
		return disConditionCfgPanel;
	}

}
