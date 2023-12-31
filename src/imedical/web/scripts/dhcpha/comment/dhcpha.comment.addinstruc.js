var unitsUrl = 'dhcpha.comment.main.save.csp';

Ext.onReady(function() {

	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	
   var phcinstgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'用法',dataIndex:'instdesc',width:300},
		{header:'剂型',dataIndex:'formdesc',width:200},
        {header:'rowid',dataIndex:'instrowid',width:40,hidden:true}
            
          ]   
            
    
    });

 
    var phcinstgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryInstDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'instdesc',
			'formdesc',
            'instrowid'
	    
		]),
		
		

        remoteSort: true
});


 
 var phcinstgrid = new Ext.grid.GridPanel({
   
        id:'phcinsttbl',
        region:'center',
        width:250,
        autoScroll:true,
        enableHdMenu : false,
        ds: phcinstgridds,
        cm: phcinstgridcm,
        enableColumnMove : false,
        stripeRows: true,
		tbar:['-','双击删除'],
		title:'已维护记录',  
        trackMouseOver:'true'
        

        
    });
    
    
    
    ///////点评注射剂Grid
    
    
    
    var instgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'用法',dataIndex:'instdesc',width:300},
        {header:'rowid',dataIndex:'instrowid',width:40,hidden:true}
            
          ]   
            
    
    });

 
    var instgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryPhcInstDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'instdesc',
            'instrowid'
	    
		]),
		
		

        remoteSort: true
});


	///////剂型Grid
	 
    var phcformgridcm = new Ext.grid.ColumnModel({
		columns:[
			{header:'剂型',dataIndex:'phcformdesc',width:300},
			{header:'rowid',dataIndex:'phcformRid',width:40,hidden:true}   
         ]   
    });

 
    var phcformgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryPhcform',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'phcformdesc',
            'phcformRid'
	    
		]),

        remoteSort: true
	});


	var inst;//用法grid
	var phcform;//剂型grid
	
	var panel=new Ext.Panel({
		title:'注射剂用法和剂型维护',
		width:350,
		autoScroll:true,	
		tbar:new Ext.TabPanel({
			activeTab:0,
			items:[inst=new Ext.grid.GridPanel({
				title:'用法',
				layout:'fit',
				ds: instgridds,
				cm: instgridcm,
				enableColumnMove : false,
				stripeRows: true,
				height:500
	
							
			}),phcform=new Ext.grid.GridPanel({
				title:'剂型',
				layout:'fit',
				ds: phcformgridds,
				cm: phcformgridcm,
				enableColumnMove : false,
				stripeRows: true,
				height:500
				
				})
			]
						
		})
	});
	

/*
 var instgrid = new Ext.grid.GridPanel({
   
        id:'insttbl',
        title:'注射剂用法维护',
        region:'west',
        width:350,
        autoScroll:true,
        enableHdMenu : false,
        ds: instgridds,
        cm: instgridcm,
        enableColumnMove : false,
        stripeRows: true,

	tbar:['双击增加'],  
    
        trackMouseOver:'true'
        

        
    });
    
    */
    
	///双击grid去除原因事件 ,用法
	inst.on('rowdblclick',function(grid,rowIndex,e){			
            var selectedRow = instgridds.data.items[rowIndex];
			var instdesc = selectedRow.data["instdesc"];
            var instrowid = selectedRow.data["instrowid"];
            InsertToCtrlGrid(instrowid);	
    });  

	///双击grid去除事件，剂型
	phcform.on('rowdblclick',function(grid,rowIndex,e){

			var selectedRow = phcformgridds.data.items[rowIndex];
			var phcformdesc = selectedRow.data["phcformdesc"];
            var phcformRid = selectedRow.data["phcformRid"];
            InsertToPhcformGrid(phcformRid);
			
    });  


	
    ///view

	var por = new Ext.Viewport({
				layout : 'border', // 使用border布局
				items : [
					phcinstgrid,
					{
					region:'west',
					width:350,
					layout:'fit',
					items:panel}
				]
			});





///-----------------------Events----------------------





///双击grid去除原因事件   
 

/*
instgrid.on('rowdblclick',function(grid,rowIndex,e){

               	var selectedRow = instgridds.data.items[rowIndex];
		var instdesc = selectedRow.data["instdesc"];
                var instrowid = selectedRow.data["instrowid"];
                InsertToCtrlGrid(instrowid);
		
		
    }); */



 ///数据库交互
function InsertToCtrlGrid(instrowid)
{
             	                 
	      
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=AddInst&instrowid='+instrowid ,
	
		waitMsg:'处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       //Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryInstDs();
	  		}
			else if (jsonData.retvalue==-2) {
	  		        Ext.Msg.alert("提示", "保存失败!已按剂型维护,请按剂型维护");
			}else if (jsonData.retvalue==-3) {
					Ext.Msg.alert("提示", "已存在相同记录!");
			}
	  		else{
	  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});
         
}


///数据库交互,选择剂型之后，双击插入
	function InsertToPhcformGrid(phcformRid)
	{
   
		Ext.Ajax.request({
	
			url:unitsUrl+'?action=AddForm&phcformRid='+phcformRid ,	
			waitMsg:'处理中...',
			failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       //Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryInstDs();
	  			}
				else if (jsonData.retvalue==-2) {
	  		        Ext.Msg.alert("提示", "保存失败!已按用法维护,请按用法维护");
	  		        //QueryInstDs();
	  			}else if (jsonData.retvalue==-3) {
					Ext.Msg.alert("提示", "已存在相同记录!");
				}
	  			else{
	  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
	  		    
	  			}
			},
		
			scope: this
		});    
	}

  
  
 ///查找数据
 
function QueryInstDs()
{

                phcinstgridds.removeAll(); 
                
    		phcinstgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryInstDs' });
		
		phcinstgridds.load({
		
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
		
}


phcinstgrid.on('rowdblclick',function(grid,rowIndex,e){

               	var selectedRow = phcinstgridds.data.items[rowIndex];
		var instrowid = selectedRow.data["instrowid"];
                DelCtrlClick(instrowid);
		
		
    });  
    
    
    

///修改原因的事件

function DelCtrlClick(instrowid)
{

  
	       Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',DelClickResult);



}





///删除确认动作
 function  DelClickResult(btn)
 {
               if (btn=="no"){ return ;}
               
               
               var row = Ext.getCmp("phcinsttbl").getSelectionModel().getSelections(); 
	       var instrowid = row[0].data.instrowid;  //ID 
	            

	       ///数据库交互删除
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=DelInst&instrowid='+instrowid ,
	
		waitMsg:'删除中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       //Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryInstDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "删除失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});       
  }
});
