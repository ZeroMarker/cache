


//��ʾƿǩ״̬���洰��
OpenShowStatusWin = function(pogid,dodis) {
	
     Ext.QuickTips.init();
     
     
     var detailgridcm = new Ext.grid.ColumnModel({
  
     columns:[


        {header:'����״̬',dataIndex:'psName',width:100},
        {header:'��������',dataIndex:'psDate',width:150},
        {header:'������Ա',dataIndex:'psUser',width:100}
        
        
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
    
    
    
    
      	         
     ///״̬���洰�� 
     var ShowStatusWindow = new Ext.Window({
	    title: 'ƿǩ״̬��ʾ',
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