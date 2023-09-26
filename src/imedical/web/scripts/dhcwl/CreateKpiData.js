(function(){
	Ext.ns("dhcwl.mkpi.CreateKpiData");
})();

var outReCreateData=0;
var task_CheckDateState={
			run:CreatDateProcess,
			interval:5000
	};
	
 function CreatDateProcess(){
 	var url=encodeURI("dhcwl/kpi/kpiservice.csp");
 	dhcwl.mkpi.Util.ajaxExc(url,
 		{
 			action:'getCreateDataPlan',
 			kpiDataFlag:kpiDataFlag
 		},
 		function(jsonData){
 			if (jsonData.success==true){
 				Ext.MessageBox.updateProgress(jsonData.number,'生成进度');
 				if(jsonData.number==1){
 					Ext.TaskMgr.stop(task_CheckDateState);
 					Ext.MessageBox.alert("提示","生成成功");
 				}
 				if(jsonData.number==-1){
 					Ext.TaskMgr.stop(task_CheckDateState);
 					Ext.MessageBox.alert("提示","生成失败,请到指标日志--任务错误日志查看具体错误");
 				}
 			}else{
 				Ext.TaskMgr.stop(task_CheckDateState);
					Ext.MessageBox.alert("提示","生成失败,请到指标日志--任务错误日志查看具体错误");
 			}
 		},this);
 	
 }
  //在模块或报表生成，重生，删除操作时，用于输入开始日期和结束日期的页面
dhcwl.mkpi.CreateKpiData=function(){
	var outThis=this;
	var parentPanel=null;
	var hadChecked=0;
    var form = new Ext.FormPanel({  
      labelAlign : 'top',  
      frame : true,  
      bodyStyle : 'padding:5px 5px 0',  
      layout : 'form',  
      items: [  
        {  
            xtype: 'datefield',
            fieldLabel: '开始时间',
            name : 'beginDate',  
            //format:'Y-m-d',
            editable:false, 
            anchor : '95%',
			format:GetWebsysDateFormat()
        }, {  
            xtype : 'datefield',  
            fieldLabel : '结束时间',  
            name : 'endDate',
            //format:'Y-m-d',
            editable:false,             
            anchor : '95%',
			format:GetWebsysDateFormat()
        }
      ],  
      buttonAlign: 'center',  
      buttons : [  
        {  
          //text : '确定',  
          text: '<span style="line-Height:1">确定</span>',
          icon: '../images/uiimages/ok.png',
          handler : function() {
        	 var seleModel=chkGrid.getSelectionModel();
     		 if(!seleModel){
     			 alert("请选择一行！");
             		return;
     		 } 
     		if(seleModel.getCount()<1){
        		alert("请选择一行！");
        		return;                		
        	}
     		 var record = seleModel.getSelections();
             if(!record){
                 alert("请选择一行！");
             	 return;
              }
             var beginDate = form.getForm().findField('beginDate').getRawValue();  
  			 var endDate = form.getForm().findField('endDate').getRawValue(); 
  			 if (beginDate=="" || endDate=="") {
  				 Ext.MessageBox.alert("提示","请选择时间段！");
  				 return;
  			 }	
             var kpiID="";
             var kpiIDs="";
             var selectKpiID="";
             for(var i=0;i<=record.length-1;i++){
             	kpiID=record[i].get("ID");
             	if (selectKpiID!=kpiID){
             		selectKpiID=kpiID;
             		if (kpiIDs!="") kpiIDs=kpiIDs+",";
             		kpiIDs=kpiIDs+kpiID;
             	}
             }
             //dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpiservice.csp?action=createMkpiData&kpiIDs='+kpiIDs+"&beginDate="+beginDate+"&endDate="+endDate);
             var url=encodeURI("dhcwl/kpi/kpiservice.csp");
  	    	 dhcwl.mkpi.Util.ajaxExc(url,
  	 	    	 {
  	 	    		action:'createMkpiData',
  	 	    		kpiIDs:kpiIDs,
  	 	    		beginDate:beginDate,
  	 	    		endDate:endDate,
  	 	    		reFlag:outReCreateData
  	 	    	},
  	 	    	function(jsonData){
  	 	    		win.hide(this);    
  	 				win.destroy();
  	 	    		if (jsonData.success==true&& jsonData.tip=="ok"){
  	 	    			kpiDataFlag=jsonData.dataFlag
  	 	    			Ext.MessageBox.progress("请稍后");
						Ext.TaskMgr.start(task_CheckDateState);
  	 	    		}else{
  	 	    			Ext.TaskMgr.stop(task_CheckDateState);
  	 					Ext.MessageBox.alert("提示","生成失败,请到指标日志--任务错误日志查看具体错误");
  	 	    		}
  	 	    	},this);
          }
        }, {  
          //text : '取消', 
          text: '<span style="line-Height:1">取消</span>',
          icon: '../images/uiimages/undo.png',
          handler : function() {
          	win.hide(this);    
			win.destroy();
          }  
        }  
      ]  
    });  
    
    var sm = new Ext.grid.CheckboxSelectionModel();	
	var chkStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:"dhcwl/kpi/kpiservice.csp?action=getKpiByID"}), 
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'kpiCode'},
            	{name: 'kpiName'}
       		]
    	})
    });
	
	var chkColumns =  [
		new Ext.grid.RowNumberer(),
		sm,
	    {header: "指标ID", width: 60, sortable: true, dataIndex: 'ID',menuDisabled : true},
	    {header: "指标编码", width: 110, dataIndex: 'kpiCode',menuDisabled : true},
	    {header: "指标名称", width: 120, dataIndex: 'kpiName',menuDisabled : true}    
	    ];

	var chkGrid = new Ext.grid.GridPanel({
		iconCls: 'icon-grid',
		height: 175,
		anchor : '99%' ,
		store: chkStore,
		columns : chkColumns,
		sm:sm
	});
  
    var chkCheckGroup = {
    	id:"chkCheckGroup1",
        xtype: 'fieldset',
        title: '请核对以下将要任务的指标',
        autoHeight: true,
        layout: 'form',
        collapsed: false,   // initially collapse the group
        //collapsible: true,
        bodyStyle: 'padding:0 0px 0;',
        frame:false,
        items: [chkGrid]
    }

    var win = new Ext.Window({  
      title : '该功能将改变指标数据,请仔细确认后操作！！',  
      closable : false,  
      modal : true,  
      //modal为True表示为当window显示时对其后面的一切内容进行遮罩，  
      //false表示为限制对其它UI元素的语法（默认为 false）。  
      width : 440,  
      resizable : false,  
      plain : true,  
      //Plain为True表示为渲染window body的背景为透明的背景，这样看来window body与边框元素（framing elements）融为一体，  
      //false表示为加入浅色的背景，使得在视觉上body元素与外围边框清晰地分辨出来（默认为false）。  
      layout : 'form',  
      items : [chkCheckGroup,form]  
    });  

    this.getStore=function(){
    	return chkStore;
    }
    this.setParentPanel=function(parentP){
    	parentPanel=parentP;
    }
    this.show=function(strSelKpiIDs,reCreateData){
    	outReCreateData=reCreateData;
    	chkGrid.getStore().removeAll();
    	chkStore.proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getKpiByID&strSelKpiIDs='+strSelKpiIDs));
    	chkStore.load();
    	win.show(this);
    }
    this.getCheckGrid=function(){
    	return chkGrid;
    }

} 
