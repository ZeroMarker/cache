


//显示瓶签状态界面窗口
OpenShowStatusWin = function(pogid,dodis) {
	
     Ext.QuickTips.init();
     
     
     var detailgridcm = new Ext.grid.ColumnModel({
  
     columns:[


        {header:'操作状态',dataIndex:'psName',width:100},
        {header:'操作日期',dataIndex:'psDate',width:150},
        {header:'操作人员',dataIndex:'psUser',width:100}
        
        
          ]   
            
    
    });
 
 
    var detailgridds = new Ext.data.Store({
    	autoLoad: true,
	url:unitsUrl+'?action=QueryPogStatusDs&pogid='+pogid+"&dodis="+dodis,
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'psName',
            'psUser',
            'psDate'
	    
		]),
		
		

    remoteSort: true
});



 
 var detailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'3 3 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove : false,
        trackMouseOver:'true'
        

        
    });
    
    
    
    
      	         
     ///状态界面窗口 
     var ShowStatusWindow = new Ext.Window({
	    title: '瓶签状态显示',
	    width: 600,
	    height:400,
	    minWidth: 400,
	    minHeight: 300,
	    layout: 'border',
	    plain:true,
	    modal:true,
	    bodyStyle:'padding:5px;',
	    items:  [detailgrid  ]




 
     });
    
     ShowStatusWindow.show();



}