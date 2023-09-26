


//显示瓶签状态界面窗口
OpenFindNoWin = function(Input) {
	
	
     Ext.QuickTips.init();
     
     
     var OkButton = new Ext.Button({
             width : 65,
             id:"OkBtn",
             text: '确定',
             tooltip:'选择并确定',
             icon:"../scripts/dhcpha/img/update.png",
             listeners:{
                          "click":function(){   
                             
                              GetNoValue();
                              
                              
                              }   
             }
             
             
     })

     function selectbox(re,params,record,rowIndex){

    	return '<input type="checkbox" id="TSelz'+rowIndex+'" name="TSelz'+rowIndex+'"  value="'+re+'"  >';

     } 
     
     var detailgridcm = new Ext.grid.ColumnModel({
  
     columns:[

        {header:'<input type="checkbox" id="TDSelectNo" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        
        {header:'瓶签单号',dataIndex:'pogno',width:100},
        {header:'打印人',dataIndex:'poguser',width:60},
        {header:'打印日期',dataIndex:'pogdate',width:150}
        
        
        
          ]   
            
    
    });
 
 
    var detailgridds = new Ext.data.Store({
    	autoLoad: true,
	url:unitsUrl+'?action=FindLabelNoDs&Input='+Input,
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'pogno',
            'poguser',
            'pogdate'
	    
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
        trackMouseOver:'true',
        tbar:[OkButton]
        

        
    });
    
    
    detailgrid.on('headerclick', function(grid, columnIndex, e) { 
	
   	     
         if (columnIndex==0){
         	selectAllRows();
         };
     
	
	});
    
      	         
     ///窗口 
     var FindLabelNoWindow = new Ext.Window({
	    title: '瓶签单号',
	    width: 600,
	    height:400,
	    minWidth: 400,
	    minHeight: 300,
	    layout: 'border',
	    plain:true,
	    modal:true,
	    closeAction: 'close', 
	    bodyStyle:'padding:5px;',
	    items:  [detailgrid  ]




 
     });
    
     FindLabelNoWindow.show();





  //全选/全销事件
  function selectAllRows()
  {
  	       var cellselected=document.getElementById("TDSelectNo").checked ;
  	       var view = detailgrid.getView();
  	       var rows=view.getRows().length ;
  	       if (rows==0) return;
  	      
	       for (i=0;i<=rows-1;i++)
	       {
	       	           
	      	   	   if (cellselected){
	      	   	   	  document.getElementById("TSelz"+i).checked=true;
	      	   	   }else{
	      	   	   	  document.getElementById("TSelz"+i).checked=false;
	      	   	   }

	       
	       }
  	
  }
  
  
  //获取所选单号
  function GetNoValue()
  {
  	       var str="";
  	       var view = detailgrid.getView();
  	       var rows=view.getRows().length-1 ;
  	       if (rows==-1) return;
  	       var h=0
	       for (i=0;i<=rows;i++)
      	       {
      	       	   var cellselected=document.getElementById("TSelz"+i).checked
      	   	   if (!(cellselected))  continue;
   	   	   var record = detailgrid.getStore().getAt(i);
                   var pogno =record.data.pogno ;
                   if (str==""){
                   	str=pogno ;
                   }else{
                        str=str+","+pogno;
                   }
                   
               }
               
               Ext.getCmp('PrintNoTxt').setValue(str);
               FindLabelNoWindow.close();
  }
  
  
  
  

}