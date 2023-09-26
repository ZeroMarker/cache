var unitsUrl = 'dhcpha.comment.systaskmanage.save.csp';
var CurrRowid="";
Ext.onReady(function() {

	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
　　　　　 //开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                xtype: 'datefield',
                //format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                //format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:new Date
            })

       
       var FindButton = new Ext.Button({
             width : 65,
             id:"FindBtn",
             text: '查询',
             iconCls:"page_find",
             listeners:{
                          "click":function(){   
                             
                              FindClick();
                              
                              }   
             }
             
             })
             
       var TaskUpdButton = new Ext.Button({
             width : 65,
             id:"AdviceUpdBtn",
             text: '启用/停用',
             iconCls:"page_active",
             listeners:{
                          "click":function(){   
                             
                              TaskUpdClick();
                              
                              }   
             }
             
             })
             



        

	
   var Taskgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'日期',dataIndex:'taskdate',width:90},
        {header:'时间',dataIndex:'tasktime',width:80},
        {header:'提交人',dataIndex:'taskuser',width:80},
        {header:'提交任务',dataIndex:'taskdesc',width:800},
        {header:'启用',dataIndex:'taskactive',width:50},
        {header:'生成单号',dataIndex:'pcntsno',width:120},
        {header:'rowid',dataIndex:'taskrowid',width:50}
            
          ]   
            
    
    });

 
    var Taskgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QuerySysTaskDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'taskdate',
            'tasktime',
            'taskuser',
            'taskdesc',
            'taskactive',
            'pcntsno',
            'taskrowid'
	    
		]),
		
		

        remoteSort: true
});

 var TaskgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:Taskgridds,
			pageSize:200,
			//显示右下角信息
			displayInfo:true,
			displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		        prevText:"上一页",
			nextText:"下一页",
			refreshText:"刷新",
			lastText:"最后页",
			firstText:"第一页",
			beforePageText:"当前页",
			afterPageText:"共{0}页",
    		        emptyMsg: "没有数据"
	});
 
 var Taskgrid = new Ext.grid.GridPanel({
   
        id:'Tasktbl',
        title:'系统任务管理器',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: Taskgridds,
        cm: Taskgridcm,
        enableColumnMove : false,
        stripeRows: true,

	      tbar:['开始日期',stdatef,'结束日期',enddatef,FindButton,TaskUpdButton],  
	      bbar:TaskgridcmPagingToolbar,
    
        trackMouseOver:'true'
        
        

        
    });
    

    
    
	
    ///view

	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [Taskgrid]

			});





///-----------------------Events----------------------




///增加

function AdviceAddClick()
{
                
                var advdesc=Ext.getCmp("AdviceDescTxt").getValue();
                
                if (advdesc==""){
                   Ext.Msg.show({title:'提示',msg:'请先录入描述!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                }              
	
	       ///数据库交互
	
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=AdviceAdd&AdviceDesc='+advdesc ,
	
		waitMsg:'删除中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryAdviceDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});
		

}

///获取界面item值
 function GetParStr()
 {
  	      sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        var listinputstr=sdate+"^"+edate ;
	  	    
	  	    var parstr=sdate+"^"+edate ;
	  	    
	  	    return parstr;
  }
  
 ///查找数据
 
function FindClick()
{
                Taskgridds.removeAll(); 
                
                var parstr=GetParStr();

				    		Taskgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QuerySysTaskDs'+'&ParStr='+parstr });
						
								Taskgridds.load({
								params:{start:0, limit:TaskgridcmPagingToolbar.pageSize},
								callback: function(r, options, success){
 
								         
								         if (success==false){
								                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
								                     }
								          }
								
								});
				
		
}




///启用事件

function TaskUpdClick()
{


         var row = Ext.getCmp("Tasktbl").getSelectionModel().getSelections();   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
	       
	       var taskrowid = row[0].data.taskrowid ;  //ID       

	
	       ///数据库交互
	    
					Ext.Ajax.request({
				
				        url:unitsUrl+'?action=UpdTask&taskrowid='+taskrowid ,
				
					waitMsg:'处理中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
				  	        if (jsonData.retvalue==0) {
				  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				  		       FindClick(); 
				  		}
				  		else{
				  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
				  		    
				  		}
					},
					
						scope: this
					});
		
		
            


}





   
   
   
   
  
	
	


});
