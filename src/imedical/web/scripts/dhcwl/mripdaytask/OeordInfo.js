(function() {
	Ext.ns("dhcwl.mripdaytask.OeordInfoCfg");
})();
// /描述: 医嘱对应设置界面
// /编写者： 陈乙
// /编写日期: 2015-02-14

dhcwl.mripdaytask.OeordInfoCfg = function() {
	var searchCondType="";
	var serviceUrl="dhcwl/mripdaytask/mripdaytaskoeordinfo.csp";
	var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getOrdInfoSet'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'OrdSetCODE'},
            	{name: 'OrdSetDesc'},
            	{name: 'AbolishDate'},
            	{name: 'OrdSetCreater'}
       		]
    	})
    });
    store.load({params:{start:0,limit:2000,onePage:1}});
    
    var storeDetail = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getOrdDetailSetting'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'DetRowId'},   //删除用
        		{name: 'ID'},
            	{name: 'ARCItmCode'},
            	{name: 'ARCItmDesc'}
       		]
    	})
    });   
    storeDetail.load({params:{start:0,limit:20000,onePage:1,mainId:1}});
	
    var selectedIds=[];
    var csm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			'rowselect': function(sm, row, rec) {
        		var rd=rec;   //sm.getSelected();
        		var ordId=rec.get("DetRowId");
        		addSelectedId(ordId);
        		//alert(selectedIds.join(","));
            },
            'rowdeselect':function(sm, row, rec){
            	
            	var ordId=rec.get("DetRowId"),len=selectedIds.length;
				for(var i=0;i<len;i++){
					if(selectedIds[i]==ordId){
						for(var j=i;j<len;j++){
							selectedIds[j]=selectedIds[j+1];
							//selectKpiObj[rec.get("kpiCode")]=rec.get("kpiName");
						}
						selectedIds.length=len-1;
						break;
					}
				}
				//alert(selectedIds.join(","));
			}
		}
	});
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 60, sortable: true, menuDisabled : true},
        {header:'CODE',dataIndex:'OrdSetCODE',sortable:true, width: 100, sortable: true, menuDisabled : true},
        {header:'描述',dataIndex:'OrdSetDesc', width: 220, sortable: true, menuDisabled : true},
        {header:'创建人',dataIndex:'OrdSetCreater', width: 100, sortable: true, menuDisabled : true},
        {header:'作废时间',dataIndex:'AbolishDate', width: 90, sortable: true, menuDisabled : true}
    ]);
    
	var columnModelDetail = new Ext.grid.ColumnModel([
        //new Ext.grid.RowNumberer(),
		csm,
        {header:'ID',dataIndex:'ID',width: 60, sortable: true, menuDisabled : true},
        {header:'CODE',dataIndex:'ARCItmCode', width: 100, sortable: true, menuDisabled : true},
        {header:'描述',dataIndex:'ARCItmDesc', width:320, sortable: true, menuDisabled : true},
        {header:'RowId',dataIndex:'DetRowId', width:50, sortable: true, menuDisabled : true}
    ]);
	
	var oeordInfoForm = new Ext.FormPanel({
		labelAlign : 'right',
		labelWidth : 50,
		bodyStyle : 'padding:5px',
		style : {
			"margin-right" : Ext.isIE6 ? (Ext.isStrict
					? "-10px"
					: "-13px") : "0"
		},
		
		layout : 'column',
		items:[
		{
			columnWidth : .5,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
									fieldLabel : 'ID',
									id : 'ID',
									xtype:'textfield',   //类型：文本框
									name: 'ID',
									disabled : true,
				anchor:'90%'				
			},{
									fieldLabel : 'CODE',
									name : 'OrdSetCode',
									xtype : 'textfield',
									id : 'OrdSetCode',
				anchor:'90%'				
			}]
		},{
			columnWidth : .5,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
									xtype : 'textfield',
									fieldLabel : '描述',
									name : 'OrdSetDesc',

									id : 'OrdSetDesc',
				anchor:'90%'						
			},{
									fieldLabel : '创建人',
									name : 'OrdSetCreateUser',
									id : 'OrdSetCreateUser',
				anchor:'90%'				
			}]
		}
		],
         //上工具栏
        tbar:new Ext.Toolbar([
         {text: '<span style="line-Height:1">新增</span>',
          icon: '../images/uiimages/edit_add.png',
          id:'ordsetadd_btn',
          handler:function(){
          	var OrdSetCode=Ext.get('OrdSetCode').getValue();
          	var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(OrdSetCode)||(reg2.test(OrdSetCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("OrdSetCode").focus();
                	return;
                }

           var OrdSetDesc=Ext.get('OrdSetDesc').getValue();
           if(!OrdSetCode||!OrdSetDesc){
                	alert("编码或描述不能为空！");
                	return;
                }
           var OrdSetCreateUser=Ext.get('OrdSetCreateUser').getValue();           
           paraValues='OrdSetCode='+OrdSetCode+'&OrdSetDesc='+OrdSetDesc+'&OrdSetCreateUser='+OrdSetCreateUser;               
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=saveOrdInfoSet&'+paraValues);
           store.load({params:{start:0,limit:20000,onePage:1}}); 
           var form=oeordInfoForm.getForm();
           form.setValues({ID:'',OrdSetCode:'',OrdSetDesc:'',OrdSetCreateUser:''});  //清空
          }
        },'-',
         {
		 text: '<span style="line-Height:1">作废</span>',
          icon: '../images/uiimages/cancel.png',
          id:'ordsetabolish_btn',
          handler:function(){	
    				var sm = oeordInfoGrid.getSelectionModel();
                	if(!sm){
                		Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                	
                    var choosedId=record.get('ID');
                    //alert(choosedId);
           			
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateOrdInfoSet&updateID='+choosedId);
           //store.load();
           store.load({params:{start:0,limit:20000,onePage:1}}); 
           var form=oeordInfoForm.getForm();
           form.setValues({ID:'',OrdSetCode:'',OrdSetDesc:'',OrdSetCreateUser:''});  //清空
           
          }
         	}
         ])
	});

	//左下
	var oeordInfoGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:480, 
        width:'100%',
        store: store,
        resizeAble:true,
        //autoHeight:true,
        //enableColumnResize :true,
        cm: columnModel,
        listeners :{
        	
        	'click':function(ele,event){
        		var sm=oeordInfoGrid.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var mainId=record.get("ID"); 
				storeDetail.load({params:{start:0,limit:20000,onePage:1,mainId:mainId}});
        	    }    
           }
        
    });
    //右下
        var oeordInfoSubGrid = new Ext.grid.GridPanel({
        id:'oeordInfoSubGrid',
        stripeRows:true,
        loadMask:true,
        height:530,  
        width:'100%',
        store: storeDetail,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModelDetail,
        sm: csm,
        listeners:{
        	'rowdblclick':function(ele,event){
				var selRec=oeordInfoSubGrid.getSelectionModel().getSelected();
				if (!selRec) {
					return;
				} 
				oeordInfoSubGrid.getStore().remove(selRec);
			}
        }
    });
    //右上
	var oeordInfoSubForm = new Ext.FormPanel({
		frame: true,
        height:580,
        width:'100%',
        
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        
        layout: 'table',
        items:oeordInfoSubGrid,
         tbar:new Ext.Toolbar(
          {
        	layout: 'hbox',
    		xtype : 'compositefield',
         	items:[
         '按条件搜索',
       	 	{
       	 		id:'searchCondType',
	        	width: 70,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'ARCItmID',   value: '医嘱项ID'},
	                	{name : 'ARCItmCode',  value: '代码'},
	                	{name : 'ARCItmDesc',  value: '描述'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				searchCondType=combo.getValue();//获取combo的选择值，作为弹出窗口函数入参。
	        			}
	        		}
       	 	},{
       	 		xtype: 'textfield',
	            width:180,
	            flex : 1,
	            id:'searcheContValue',
	            enableKeyEvents: true,
	            //name : 'searcheContValue',
	            allowBlank: true         
       	 	}
       	 	
         ,'-',
         ///////
         {text: '<span style="line-Height:1">新增</span>',	
          icon: '../images/uiimages/edit_add.png',
          id:'ordDetailadd_btn',
          handler:function(){
          	var searchContValue=Ext.get("searcheContValue").getValue();
          	var gridStore = oeordInfoSubGrid.getStore();
          	if(!searchCondType){
                			//alert("请选择搜索条件！");
          					Ext.Msg.show({title:'提示',msg:'请选择搜索条件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
             			}
          	//alert(searchCondType+"*"+searchContValue);
          	var codecfgSubGroupItem = new dhcwl.mripdaytask.OeordInfoDetailCfg(searchCondType,searchContValue,gridStore);
			codecfgSubGroupItem.showCodeCfgSubGroupItemWin();
          }
         },'-',
         {text: '<span style="line-Height:1">删除</span>',
          icon: '../images/uiimages/edit_remove.png',
          id:'ordDetaildelete_btn',
          handler:function(){
          				
          				
          				var sm = oeordInfoGrid.getSelectionModel();
						if(!sm){
                			Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
             			}
            			var record = sm.getSelected();
            			if(!record){
                			Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
               			}
               			var smDetail = oeordInfoSubGrid.getSelectionModel();
            			if(!smDetail){
                			//alert("请选择统计项明细！");
                			Ext.Msg.show({title:'提示',msg:'请选择统计项明细！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
             			}
            			var recordDetail = smDetail.getSelected();
            			if(!recordDetail){
            				Ext.Msg.show({title:'提示',msg:'请选择统计项明细！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
               			}	
               			
               			var abDate=record.get('AbolishDate');
               			if(abDate){
            				Ext.Msg.show({title:'提示',msg:'已作废，无法进行删除操作！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
               			}	
						//oeordInfoSubGrid.getStore().remove(recordDetail);
          				//删除后台
          	 			var mainId=record.get('ID');
            			//var detailId=recordDetail.get('ID');
               			//var detailRowId=recordDetail.get('DetRowId')
               			var detailRowId=selectedIds.join(",")
               			//alert(selectedIds.join(","));
            			var idStr=mainId+'#'+detailRowId
            			dhcwl.mkpi.Util.ajaxExc('dhcwl/mripdaytask/mripdaytaskoeordinfo.csp?action=DeleteOrdDetailSetting',{'idStr':idStr},
            			function(jsonData){
            				if (jsonData.success==true && jsonData.tip=="ok"){
            					oeordInfoSubGrid.getStore().reload({params:{start:0,limit:20,onePage:1,mainId:mainId}});
            					alert("删除成功！");
            				}else{
            					alert("删除失败！");
            				}
            			});
            			//dhcwl.mkpi.Util.ajaxExc('dhcwl/mripdaytask/mripdaytaskoeordinfo.csp?action=DeleteOrdDetailSetting',{'idStr':idStr});
            			//alert(mainId);
            			//var sm = oeordInfoSubGrid.getSelectionModel();
                		//var record = sm.getSelected();
                		//store.remove(record);   //移除统计项
            			oeordInfoSubGrid.getStore().reload({params:{start:0,limit:20,onePage:1,mainId:mainId}});
            			//storeDetail.load({params:{start:0,limit:20,onePage:1,mainId:mainId}});

            			
          }
         	},'-',
         {text: '<span style="line-Height:1">保存</span>',		
          icon: '../images/uiimages/filesave.png',
          id:'ordDetailsave_btn',
          handler:function(){
          				var sm = oeordInfoGrid.getSelectionModel();
            			if(!sm){
                			//alert("请选择统计项！");
                			Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
             			}
            			var record = sm.getSelected();
            			if(!record){
                			//alert("请选择统计项！");
                			Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
               			}
            		var choosedId=record.get('ID');
            		if(!choosedId){
            			//alert("请选择统计项！");
            			Ext.Msg.show({title:'提示',msg:'请选择统计项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
            		}
            		
            		var abDate=record.get('AbolishDate');
               			if(abDate){
            				Ext.Msg.show({title:'提示',msg:'已作废，无法进行保存操作！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			storeDetail.load({params:{start:0,limit:20000,onePage:1}});  //重新加载刷新
                			return;
               			}	
               			
          			var str = "Null";
					//遍历oeordInfoSubGrid列表
					oeordInfoSubGrid.store.each(function (record,rerultStr) {				
						var ID = record.data.ID;
						if(!choosedId){
            			//alert("请增加统计项明细！");
            			Ext.Msg.show({title:'提示',msg:'请增加统计项明细！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
            		}
						if (str=="Null")  
							str=choosedId+'^'+ID;
						else{
							str=str+'#'+choosedId+'^'+ID;
						}
					});
					if(str=="Null"){
            			//alert("无保存内容！");
            			Ext.Msg.show({title:'提示',msg:'无保存内容！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
            		}
            		//alert(str);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/mripdaytask/mripdaytaskoeordinfo.csp?action=SaveOrdDetailSetting',{'str':str},
						function(jsonData){
	            				if (jsonData.success==true && jsonData.tip=="ok"){
	            					oeordInfoSubGrid.getStore().reload({params:{start:0,limit:20,onePage:1,mainId:choosedId}});
	            					alert("保存成功！");
	            				}else{
	            					alert("保存失败！");
	            				}
						});
					//oeordInfoSubForm.refrese();
					//storeDetail.load({params:{start:0,limit:20000,onePage:1}});  //重新加载刷新
          }
            }
         ]
	})
	
	});
    
	var oeordInfoCfgPanel = new Ext.Panel({
		//labelWidth : 15, // label settings here cascade unless overridden
		frame : true,
		title : '医嘱对应设置',
		layout:'table',    //border 
    	layoutConfig: {columns:2},  //这是一个包含指定布局详细属性的对象 (与layout 配置值结合使用)：两列
    	//defaults: { width:300, height: 300},
        items: [
        	{
	        xtype:'fieldset',
	        title:'统计项',
            width:600,
            //collapsible: true,
            //autoWidth:true,
            layout:'anchor',
            
            autoHeight:true,
        	items:[{ 
        		//autoScroll:true,
            	items:oeordInfoForm
    		},{
            	autoScroll:true,
            	items:oeordInfoGrid  //codecfgsubgroupForm
    		}]
    		},
    		{
	        xtype:'fieldset',
	        title:'统计项对应医嘱明细',
            width:600,
            //collapsible: true,
            //autoWidth:true,
            layout:'form',
            autoHeight:true,
        	items:[{
            	autoScroll:true,
            	items:oeordInfoSubForm //
        	}]
    		}
        ]

	});

	function addSelectedId(id){
    	if(!id||id=="") return;
		for(var i=selectedIds.length-1;i>-1;i--){
			if(selectedIds[i]==id)
				return;
		}
		selectedIds.push(id);
    }
                
	this.getOeordInfoCfgPanel = function() {
		return oeordInfoCfgPanel;
	}
	
}
