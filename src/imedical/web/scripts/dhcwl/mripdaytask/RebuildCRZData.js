(function(){
	Ext.ns("dhcwl.mripdaytask.RebuildDataCfg");
})();
///描述: 		重做数据界面
///编写者：		陈乙
///编写日期: 	2015-02-13
//dhcwl.mripdaytask.BaseSetCfg=function(){

Ext.onReady(function() {
	
	///Tabs定义-start-//
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    margins:'3 3 3 0', 
	    activeTab: 0,
	    items:[{
	        title: '确定重做时间段',
	        height:650,
	        id:'list',    
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
	    } 
	    ]
	    ,
        listeners:{
        	'afterrender':function(th){
	        	
				var p = Ext.getCmp("TblTabPanel").getActiveTab();
    			var iframe = p.el.dom.getElementsByTagName("iframe")[0];   //获取第一个tab2
    			iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-召回和延时出院病人信息.raq' ;
        	}
        }
	});
	///Tabs定义-end-//
	
	var ReDateFieldFrom=new Ext.form.DateField ({
               
                xtype: 'datefield',
                width:150,
                format : 'Y-m-d',
                fieldLabel: '开始日期',
                name: 'startDate',
                id: 'startDate',
                invalidText:'无效日期格式',
                anchor : '90%',
                value:new Date().add(Date.DAY, -1)
    })	
    
    var ReDateFieldTo=new Ext.form.DateField ({
               
                xtype: 'datefield',
                width:150,
                format : 'Y-m-d',
                fieldLabel: '结束日期',
                name: 'endDate',
                id: 'endDate',
                disabled:true,
                invalidText:'无效日期格式',
                anchor : '90%',
                value:new Date().add(Date.DAY, -1)
                
    })	
    
            
    var baseSetCfgPanel =new Ext.FormPanel({
        frame:true,
        title: '出入转数据重做',
	    items:[{
        	tbar:new Ext.Toolbar({
        		layout: 'hbox',
    			xtype : 'compositefield',
         		items:[
         			'开始日期：',ReDateFieldFrom,'结束日期：',ReDateFieldTo,'-',
         			{text:'执行',
          			id:'ordDetailadd_btn',
          			handler:function(){
	          			var sDate=Ext.getCmp("startDate").getRawValue();       
     					var eDate=Ext.getCmp("endDate").getRawValue();
		          		Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能!!!'+'<br/>'+'确定要重生'+sDate+'到'+eDate+'区间的数据么？',function(btn){
		 				if(btn=='yes'){
		 					onCreateCRZDataHandle(sDate,eDate);
		 				}
	 			});
	
          			}
         		}]
        	})},
        	QueryTabs
        ]   
    });
    
    this.mainWin=new Ext.Viewport({
    	id:'dhcwl.maintainrebuildcrzdata',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        items: [baseSetCfgPanel]
    });
    

	//初始化设置
    function InitSet() {
	}
	
	var task_CheckDateState={
			run:CreatDateProcess,
			interval:2000
	};
	function CreatDateProcess(){
    	var url=encodeURI("dhcwl/mripdaytask/mripdaytaskcreatedata.csp");
    	dhcwl.mkpi.Util.ajaxExc(url,
    		{
    			action:'reCreatDataProcess',
    			dateFlag:crzDataFlag
    		},
    		function(jsonData){
    			if (jsonData.success==true){
    				Ext.MessageBox.updateProgress(jsonData.number,'生成进度');
    				//Ext.MessageBox.alert("提示框","这是个提示框");
    				if(jsonData.number==1){
    					Ext.TaskMgr.stop(task_CheckDateState);
    					Ext.MessageBox.alert("提示","生成成功");
    				}
    				if(jsonData.number==-1){
    					Ext.TaskMgr.stop(task_CheckDateState);
    					Ext.MessageBox.alert("提示","生成失败");
    				}
    				if(jsonData.number==-2){
    					Ext.TaskMgr.stop(task_CheckDateState);
    					Ext.MessageBox.alert("提示","重做函数报错:w ##class(DHCWL.MRIPDayTask.MRIPDayTaskReDataSever).ReCreateCRZData()");
    				}
    			}else{
    				Ext.TaskMgr.stop(task_CheckDateState);
					Ext.MessageBox.alert("提示","生成失败2");
    			}
    		},this);
    	
    }

    ///////////////////
    function onCreateCRZDataHandle(startDate,endDate){

		var url=encodeURI("dhcwl/mripdaytask/mripdaytaskcreatedata.csp");
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				action:'reCreatData',
				sDate:startDate,
				eDate:endDate
			},
			function(jsonData){
						crzDataFlag=jsonData.dataFlag;
						if(jsonData.success==true && jsonData.tip=="ok"){
									Ext.MessageBox.progress("请稍后");
									Ext.TaskMgr.start(task_CheckDateState);
	
						}else{
							Ext.Msg.alert("提示","操作失败！");
						}
			}
			,this
		);	 
	}	
    

    this.getBaseSetCfgPanel=function(){
    	return baseSetCfgPanel;
    }  
})

