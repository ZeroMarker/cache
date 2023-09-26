(function(){
	Ext.ns("dhcwl.codecfg.CodeCfgItmGroup");
})();
Ext.onReady(function() {

//dhcwl.codecfg.CodeCfgItmGroup=function(){
	var serviceUrl="dhcwl/codecfg/codecfgservice.csp";
	var outThis=this
	var choicegrpId=""
	var strPara=""
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    	    {
    			text:'增加项目明细',
    			handler:function(cmp,event){
    				if(!choicegrpId){
                	   alert("请选择项目大组！");
                		return;
                	}
    				dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=initItemGrpLogGlobal'
						,null,function(jsonData){
							if(!jsonData){
								Ext.Msg.show({title:'错误',msg:"初始化数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
							if(jsonData.success){
								if (jsonData.tip=="ok") {
									var codecfgItmGroupDetails = new dhcwl.codecfg.CodeCfgItmGroupDetails(choicegrpId,storeSubGrp);
									codecfgItmGroupDetails.showCodeCfgItmGroupDetailsWin();
							}else{
									Ext.Msg.alert("提示","同一个时刻只能有一个用户维护明细，请稍后操作！");
									return;
								}
							}else{
								Ext.Msg.show({title:'错误',msg:"初始化数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
						},outThis);                	
                    //var mKpiCode="RegLocOpNums"
                    //var kpiWinKpiLoginInfoCfg = new dhcwl.mkpi.KpiWinKpiLoginInfoCfg(mKpiCode);
					//kpiWinKpiLoginInfoCfg.showKpiLoginInfoCfgWin();
    			}
    		}
    	]
	})
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true},
        {header:'维度类型',dataIndex:'ItemGrpDimDr', width: 100, sortable: true,menuDisabled : true},
        {header:'大组编码',dataIndex:'ItemGrpCode', width: 100, sortable: true,menuDisabled : true},
        {header:'大组描述',dataIndex:'ItemGrpDesc', width: 160, sortable: true,menuDisabled : true},
        {header:'创建人',dataIndex:'ItemGrpCreateUse', width: 100, sortable: true,menuDisabled : true}
    ]);
	
	var store = new Ext.data.Store({
        //proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch&session=GRP&className=DHCWL.CodeCfg.Group'}),
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearchGrp&className=DHCWL.CodeCfg.ItemGroup'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'ItemGrpCode'},
            	{name: 'ItemGrpDesc'},
            	{name: 'ItemGrpCreateUse'},
            	{name: 'ItemGrpDimDr'}
       		]
    	})
    });
    store.load()
	
    var codecfggroupGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: store,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=codecfggroupForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
        listeners :{
        	'click':function(ele,event){
        		var sm=codecfggroupGrid.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var grpId=record.get("ID"); 
                if(!grpId) {
                	grpId="";
                	choicegrpId=grpId;
                	return;
                }
                choicegrpId=grpId;
                //alert(choicegrpId);                
				storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-GrpItem&grpId='+grpId));
				//if (storeSubGrp.reader.totalProperty.totalNums=1){
				//	Ext.Msg.show({title:'提示',msg:"该组未维护子分类，请维护！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                //		return;				
				//} 
				storeSubGrp.load();
    			codecfgsubgroupGrid.show();
        	    },
            'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
         }
        
         /*
         ,
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: new Ext.Toolbar([
        ])
        */

    });
	
	/*var codecfgdimCombo=new Ext.form.ComboBox({
		width : 140,
		editable:false,
		fieldLabel : '维度类型',
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择维度分类',
		name : 'codecfgdimCombo',
		id:  'ItemGrpDimDr',
		displayField : 'cfgdimName',
		valueField : 'cfgdimCode',
		tpl:'<tpl for=".">' +   
            '<div class="x-combo-list-item" style="height:18px;">' +   
            '{cfgdimName}' +   
        '</div>'+   
        '</tpl>',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/codecfg/codecfgservice.csp?action=getCodeCfgDimCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'cfgdimCode'},{name:'cfgdimName'}])
		}),
		listeners :{
			'select':function(combox){
				codecfgdimCombo.setValue(combox.getRawValue());
			}
		}
	});*/
	
	var codecfgdimCombo={
		id : 'ItemGrpDimDr',
		name:'codecfgdimCombo',
		disabled : false,
		xtype : 'bdpcombo',
		width:170,
		fieldLabel : '维度类型',
		queryParam : "desc",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		pageSize : 10,
		listWidth : 250,
		valueField : 'cfgdimCode',
		displayField : 'cfgdimName',
		store : new Ext.data.JsonStore({
			url : 'dhcwl/codecfg/codecfgservice.csp?action=getCodeCfgDimCombo',
			root : 'root',
			totalProperty : 'totalNum',
			idProperty : 'ID',
			fields : ['cfgdimCode', 'cfgdimName']
		})
	};
    
	var codecfggroupForm = new Ext.FormPanel({
        height: 100,
        width:600,
        labelAlign: 'right',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        frame : true,
		bodyStyle:'padding:5px',
		labelWidth : 60,
        
		items : [{
			layout : 'column',
			items : [
			{ 
				columnWidth : .45,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 170
				},
				items : [{
					fieldLabel : 'ID',
					xtype:'textfield',
					name: 'ID',
					//id: 'ID',
					disabled:true
				},{
					fieldLabel : '大组编码',
					xtype:'textfield',
					name: 'ItemGrpCode',
					id: 'ItemGrpCode'
				},{
					fieldLabel : '创建人',
					name: 'ItemGrpCreateUse',
					id: 'ItemGrpCreateUse',
					xtype:'textfield'
				}]
			},{ 
				columnWidth : .45,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 170
				},
				items : [codecfgdimCombo,{
					fieldLabel : '大组描述',
					name: 'ItemGrpDesc',
					id: 'ItemGrpDesc',
					xtype:'textfield'
				}]
			}]
		}],
		
		
         //,{buttons:
         tbar:new Ext.Toolbar([
         {//text:'新增',
          text: '<span style="line-Height:1">新增</span>',
		  icon: '../images/uiimages/edit_add.png',
          id:'grpadd_btn',
          handler:function(){
          var form=codecfggroupForm.getForm();
          var values=form.getValues(false);
          var GrpCode=Ext.get('ItemGrpCode').getValue();
          var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                //var reg2=/^\d/;
                //if(reg.test(GrpCode)||(reg2.test(GrpCode))){
                	//alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
				if(reg.test(GrpCode)){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符！");
                	Ext.get("ItemGrpCode").focus();
                	return;
                }
           var GrpCode=Ext.get('ItemGrpCode').getValue();
           var GrpDesc=Ext.get('ItemGrpDesc').getValue();
           //var GrpDimDr=Ext.getCmp('ItemGrpDimDr').getValue();     //codecfgdimCombo.getValue();
		   var GrpDimDr=Ext.getCmp('ItemGrpDimDr').getRawValue();
           //alert (GrpDimDr)
           if(!GrpCode||!GrpDesc||!GrpDimDr){   
                	alert("类别类型、编码或名称不能为空！");
                	return;
                }
           var GrpCreateUse=Ext.get('ItemGrpCreateUse').getValue();           
           paraValues='GrpCode='+GrpCode+'&GrpDesc='+GrpDesc+'&GrpCreateUse='+GrpCreateUse+'&GrpDimDr='+GrpDimDr;
           //alert(paraValues);                
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addItemgrp&'+paraValues);
           store.load();
           codecfggroupGrid.show();     
          }
         },'-',
         {//text:'保存',
          //text: '<span style="line-Height:1">保存</span>',
		  //icon: '../images/uiimages/filesave.png',
		  text: '<span style="line-Height:1">更新</span>',
		  icon: '../images/uiimages/update.png',
          id:'grpupdata_btn',
         	 handler:function(){
         	 	var form=codecfggroupForm.getForm();
                var values=form.getValues(false);
         	 	var sm = codecfggroupGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要更新的行！");
               		return;}
         	 	Ext.Msg.confirm('信息', '确定要更新？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID")
                        var GrpCode=Ext.get('ItemGrpCode').getValue();
                        var GrpDesc=Ext.get('ItemGrpDesc').getValue();
              			var GrpCreateUse=Ext.get('ItemGrpCreateUse').getValue();
              			var GrpDimDr=Ext.getCmp('ItemGrpDimDr').getValue();    //Ext.getCmp('ItemGrpDimDr').getValue();
                		if(!GrpCode||!GrpDesc){
                			alert("类别编码或名称不能为空！");
                			return;
                		}
                		//alert(GrpDimDr)
                		paraValues='ID='+ID+'&GrpCode='+GrpCode+'&GrpDesc='+GrpDesc+'&GrpCreateUse='+GrpCreateUse+'&GrpDimDr='+GrpDimDr;
                        //alert(paraValues)
                        store.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateItemgrp&'+paraValues);
                		store.load();
                        //codecfggroupGrid.show();
                		//this.refresh();
                		//dhcwl_codecfg_showKpiWin.refreshCombo();
                		}
                	});
         	 }
         
         },'-',
         {//text:'删除',
          text: '<span style="line-Height:1">删除</span>',
		  icon: '../images/uiimages/edit_remove.png',
          id:'grpdel_btn',
             handler: function(){
            	var sm = codecfggroupGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行！");
               		return;}
                Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        //store.remove(record);
                		//dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteItemgrp&ID='+ID);
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteItemgrp&ID='+ID,null,
						function(jsonData){
							if (jsonData.success==true && jsonData.tip=="ok"){
								store.remove(record);
								Ext.Msg.alert("提示",jsonData.tip);
								storeSubGrp.removeAll();
								codecfgsubgroupGrid.show();
								var form=codecfggroupForm.getForm();
								form.setValues({ID:'',ItemGrpCode:'',ItemGrpDesc:'',ItemGrpCreateUse:'',codecfgdimCombo:''});
							}else {
								Ext.Msg.alert("提示",jsonData.tip);
							}
						},this);
                		/*storeSubGrp.removeAll();
            			codecfgsubgroupGrid.show();
            			var form=codecfggroupForm.getForm();
            	        form.setValues({ID:'',ItemGrpCode:'',ItemGrpDesc:'',ItemGrpCreateUse:'',codecfgdimCombo:''});*/
                		//storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-subGrp&grpId='+choicegrpId));
                		//storeSubGrp.load();
                		//var form=codecfgsubgroupForm.getForm();
                        //form.setValues({ID:'',SGrpCode:'',SGrpDesc:''});
                        //var form=codecfggroupForm.getForm();
                        //form.setValues({ID:'',ItemGrpCode:'',ItemGrpDesc:'',ItemGrpCreateUse:'',codecfgtypeCombo:''});
                		//dhcwl_codecfg_showKpiWin.refreshCombo();
                		}
                	});
                }
         
         },'-',
         {//text:'清空',
          text: '<span style="line-Height:1">清空</span>',
		  icon: '../images/uiimages/clearscreen.png',
          id:'grpclear_btn',
          handler: function() {
          var form=codecfggroupForm.getForm();
          form.setValues({ID:'',ItemGrpCode:'',ItemGrpDesc:'',ItemGrpCreateUse:'',codecfgdimCombo:''});
          }
         },'-',
         {//text:'查找',
          text: '<span style="line-Height:1">查询</span>',
		  icon: '../images/uiimages/search.png',
          id:'grpsearch_btn',
         	 handler: function() {
                var GrpCode=Ext.get('ItemGrpCode').getValue();
                var GrpDesc=Ext.get('ItemGrpDesc').getValue();
                var GrpCreateUse=Ext.get('ItemGrpCreateUse').getValue();
                //var GrpDimDr=codecfgdimCombo.getRawValue();
				//var GrpDimDr=Ext.getCmp('ItemGrpDimDr').getValue();
				var GrpDimDr=Ext.getCmp('ItemGrpDimDr').getRawValue();
                paraValues='ItemGrpCode='+GrpCode+'&ItemGrpDesc='+GrpDesc+'&ItemGrpCreateUse='+GrpCreateUse+'&ItemGrpDimDr='+GrpDimDr;
                store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearchItemGrp&className=DHCWL.CodeCfg.ItemGroup&"+paraValues+"&start=0&limit=21&onePage=1"));
            	store.load();
    			codecfggroupGrid.show();
    			}
         },'-',{
			 //text:'导出大组信息',
			 text: '<span style="line-Height:1">导出</span>',
			 icon: '../images/uiimages/redo.png',
			 handler:function(){
				var excelObj=new dhcwl.mkpi.util.Excel();
				excelObj.setTitle("统计大组导出");
				excelObj.setHead(['大组编码','大组描述','创建时间','创建人','维度类型','明细ID','明细描述','明细排序值']);
				excelObj.setServerUrl(serviceUrl+'?action=exportGrp');
				excelObj.exportExcel();
			 }
			 
		 },'-',{
			 //text:'日志查看',
			 text: '<span style="line-Height:1">日志查看</span>',
			 icon: '../images/uiimages/search.png',
			 handler:function(){
				 var codecfgLogObj = new dhcwl.codecfg.CodeCfgLog();
				 codecfgLogObj.show();
			 }
		 }
         
         ])
	});
	
    var selectedKpiIds=[];
	var csm = new Ext.grid.CheckboxSelectionModel();     //新建复选框的对象，使用的时候直接写  'csm' 
    var columnModelSubGrp = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),csm,
        {header:'ID',dataIndex:'ID',width: 30, sortable: true,menuDisabled : true},
        {header:'描述',dataIndex:'itemDesc',sortable:true,  width: 160, sortable: true,menuDisabled : true},
        {header:'排序',dataIndex:'ItmGrpDetSort',sortable:true,  width: 160, sortable: true,menuDisabled : true}
    ]);
    columnModelSubGrp.defaultSortable = true;
    var storeSubGrp = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=list-GrpItem'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'itemDesc'},
            	{name: 'ItmGrpDetSort',type : 'int'}    //设置type排序是按数字排
       		]
    	})
    });
    
    storeSubGrp.setDefaultSort('ItmGrpDetSort', 'asc');    
    storeSubGrp.load()
    var codecfgsubgroupGrid = new Ext.grid.GridPanel({
        id:'subgroupGrid',
        stripeRows:true,
        loadMask:true,
        height:450, 
        //width:300,
        store: storeSubGrp,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModelSubGrp,
        sm:csm,   //new Ext.grid.RowSelectionModel(),
        enableDragDrop: true,   //拖动排序用的属性
        dropConfig: {           //拖动排序用的属性
            appendOnly:true  
        }, 
        ddGroup: 'GridDD'
        

         /*
          ,    tbar:new Ext.Toolbar([
         {text:'删除'},'-',
         {text:'查找'},'-',
         {text:'更新排序'}
         
         ])   ,
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: new Ext.Toolbar([
        ])
        */
    });
    
   
    
	var codecfgsubgroupForm = new Ext.FormPanel({
		frame: true,
        height: 150,
        width:600,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        //layoutConfig: {columns:4},
        //,{buttons:
         tbar:new Ext.Toolbar([
         {//text:'删除',
          id:'del_btn',
          text: '<span style="line-Height:1">删除</span>',
		  icon: '../images/uiimages/edit_remove.png',
          handler:function(){
          if(!choicegrpId||choicegrpId==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要删除的大组！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
 
          var selectItemPara="";
		  var rowObj=codecfgsubgroupGrid.getSelectionModel().getSelections();
		  var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择要删除的项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }else{
			var idStr="";
				for(var i=0;i<len;i++){
					storeSubGrp.remove(rowObj[i]);
					ItemId=rowObj[i].get("ID");
					if(idStr==""){
						idStr=ItemId;
					}else{
						idStr=idStr+"-"+ItemId
					}
						
				}
			selectItemPara=idStr;
			}		
           paraValues='GrpId='+choicegrpId+'&selectItemPara='+selectItemPara;
           //alert(paraValues);                
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delitem&'+paraValues);
           ItemPara();
		   //alert(strPara);
		  // dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updategrpDeleteitemSort&strPara='+strPara+'&grpId='+choicegrpId);
           //storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-GrpItem&grpId='+choicegrpId));
           //storeSubGrp.reload();  
           
           dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=updategrpDeleteitemSort&strPara='+strPara+'&grpId='+choicegrpId
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"删除失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-GrpItem&grpId='+choicegrpId));
	                			storeSubGrp.reload(); 
	                		}else{
								Ext.Msg.alert("提示","删除失败了！");
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);
          }
         },/*'-',
         {text:'查找'},*/'-',
         {//text:'更新排序',
          text: '<span style="line-Height:1">更新排序</span>',
		  icon: '../images/uiimages/update.png',
          id:'upsort_btn',
         	 handler: function() {
                if(!choicegrpId||choicegrpId==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要更新的大组再对项目进行拖动排序更新！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            	ItemPara();
				//alert(strPara);
				dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updategrpitemSort&strPara='+strPara+'&grpId='+choicegrpId);
                storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-GrpItem&grpId='+choicegrpId));
                storeSubGrp.load();
                //codecfggroupGrid.show();



                //var SGrpCode=Ext.get('SGrpCode').getValue();
                //var SGrpDesc=Ext.get('SGrpDesc').getValue();
                //paraValues='SGrpCode='+SGrpCode+'&SGrpDesc='+SGrpDesc;
                //storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearch&className=DHCWL.CodeCfg.SubGroup&"+paraValues+"&start=0&limit=21&onePage=1"));
            	//storeSubGrp.load();
    			//codecfgsubgroupGrid.show();
    			}
         }
         
         ])
	
	})
	function ItemPara(){
		var idStr="";    //strPara="",
        //var len=storeSubGrp.getTotalCount();
        var len=codecfgsubgroupGrid.getStore().getCount();   //grid行数
        //alert(len);
        var idStr="";
		for(var i=0;i<len;i++){
			ItemId=storeSubGrp.getAt(i).get('ID');
			if(idStr==""){
				idStr=ItemId+"*"+(i+1);
				}else{
					idStr=idStr+"-"+ItemId+"*"+(i+1)
					}		
				}
		strPara=idStr;
		//alert(strPara);
	
	}
    var codecfggroupPanel =new Ext.Panel ({ //Viewport({
    	//title:'项目分组维护',
    	layout:'table',    //border 
    	autoScroll:true,
    	layoutConfig: {columns:2},
    	//defaults: { width:300, height: 300},
        items: [{ 
        	autoScroll:true,
            items:codecfggroupForm
    	},{
            autoScroll:true,
            items:codecfgsubgroupForm //codecfggroupGrid
        },{
            autoScroll:true,
            //width:500,
            //height:500,
            items:codecfggroupGrid  //codecfgsubgroupForm
    	},{
            autoScroll:true,
            //width:500,
            //height:500,
            items:codecfgsubgroupGrid
        }],
        listeners:{
    		"resize":function(win,width,height){
    			//unchoiceGrid.setHeight(height-150);
    			codecfggroupGrid.setHeight(height-150);
    			codecfgsubgroupGrid.setHeight(height-150);
    			//unchoiceGrid.setWidth(width-choiceGrid1.width-choiceGrid1.width);
    			//unchoiceGrid.setHeight(height-50);
    		}
    	}
    });
    
    var codecfggroupPanel =new Ext.Panel ({ //Viewport({
    	//title:'项目分组维护',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:0.9,
			layout:"fit",
            items:[
			{
				//border :false,
				layout: {
					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					//border :false,
					flex:1,
					layout:"fit",
					items:codecfggroupForm
				},{
					//border :false,
					flex:1,
					layout:"fit",
					items:codecfgsubgroupForm					
				}]
			}]
    	},{
			border :false,
			flex:3,
			layout:"fit",
            items:[{
				border :false,
				layout: {

					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					flex:1,
					layout:"fit",
					items:codecfggroupGrid
				},{
					flex:1,
					layout:"fit",
					items:codecfgsubgroupGrid					
				}]
			}]
        }]
    });
    
    this.mainWin=new Ext.Viewport({
    	id:'maintainCodeCfgGroup',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        //width:1000,
        //heitht:800,
        items: [codecfggroupPanel]
    });
    
     //拖动排序的代码  
  // alert(codecfgsubgroupGrid.getView().scroller.dom);
   
    var ddrow = new Ext.dd.DropTarget(codecfgsubgroupGrid.getView().scroller.dom, {
        ddGroup : 'GridDD',
        copy    : false,//拖动是否带复制属性
        notifyDrop : function(dd, e, data) { //对应的函数处理拖放事件
            // 选中了多少行
            var rows = data.selections;
            // 拖动到第几行
            var index = dd.getDragData(e).rowIndex;
            if (typeof(index) == "undefined") {
                return;
            }
            // 修改store
            for(i = 0; i < rows.length; i++) {
                var rowData = rows[i];
                if(!this.copy) storeSubGrp.remove(rowData);
                storeSubGrp.insert(index, rowData);
            }
        codecfgsubgroupGrid.getView().refresh();//刷新序号
        //拖动完成排序重排
        //Ext.getCmp('codecfgsubgroupGrid').getView().addListener('drop',function(node,data,model){
         //  alert(storeSubGrp.totalCount)
         //  var store=Ext.getCmp('codecfgsubgroupGrid').storeSubGrp;
         //  for(i=0;i<store.totalCount;i++){
         //  storeSubGrp.getAt(i),set('SGrpSort',i+1);
         //  storeSubGrp.commitChanges();
          // }
        //});
        }

    }); 
    
   /*var ddrow = new Ext.dd.DropTarget(codecfgsubgroupGrid.getEl(), { 
        ddGroup: 'gridDD', 
        copy    : false, 
        notifyDrop : function(dd, e, data){ 
            //选择行 
            var rows = codecfgsubgroupGrid.getSelectionModel().getSelections(); 
            //选择行数 
            var count = rows.length; 
            //拖动到几行 
            var dropIndex = dd.getDragData(e).rowIndex; 
            var array=[]; 
            for(var i=0;i<count;i++){ 
                var index = dropIndex+i; 
                array.push(index); 
            } 
            codecfgsubgroupGrid.getStore().remove(codecfgsubgroupGrid.getStore().getById(data.selections[0].Id)); 
            codecfgsubgroupGrid.getStore().insert(dropIndex,data.selections);  
            codecfgsubgroupGrid.getSelectionModel().selectRows(array);  
            codecfgsubgroupGrid.getView().refresh();    
        } 
    }); */



   /*     
   var drogAndDrap = new Ext.dd.DropTarget(codecfgsubgroupGrid.container, { 
        ddGroup : 'GridDD',  
        copy    : false,  
        notifyDrop : function(dd, e, data) {  
            var rows = data.selections;  
            var index = dd.getDragData(e).rowIndex;  
            if (typeof(index) == "undefined") {  
                return;  
            }  
            //确定正序还是倒序  
            
            var mark = true;  
            gridIndex = storeSubGrp.indexOf(rows[0]);  
            if(index<gridIndex) mark = false;  
              
            for(i = 0; i < rows.length; i++) {  
             var rowData;  
                if(mark){  
                    rowData = rows[i];  
                 }else{  
                    rowData = rows[rows.length-i-1];  
                }  
                if(!this.copy)   
                    storeSubGrp.remove(rowData);  
                storeSubGrp.insert(index, rowData);  
            }  
            var sm = Ext.getCmp('subgroupGrid').getSelectionModel();  
            sm.clearSelections();  
            codecfgsubgroupGrid.getView().refresh();//刷新序号    
            //拖动结束后的处理逻辑  
            updateIndex();          
        }  
    }); 
    */

    this.getcodecfggroupPanel=function(){
    	return codecfggroupPanel;
    }
})
