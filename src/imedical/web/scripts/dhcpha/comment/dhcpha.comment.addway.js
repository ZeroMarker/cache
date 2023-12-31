var unitsUrl = 'dhcpha.comment.addway.save.csp';

Ext.onReady(function() {

	Ext.QuickTips.init();// 浮动信息提示
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;


        var WayAddButton = new Ext.Button({
             width : 65,
             id:"WayAddBtn",
             text: '增加',
             iconCls:"page_add",
             listeners:{
                          "click":function(){   
                             
                              WayAddClick();
                              
                              }   
             }
             
             })
             
             
       var WayUpdButton = new Ext.Button({
             width : 65,
             id:"WayUpdBtn",
             text: '修改',
             iconCls:"page_modify",
             listeners:{
                          "click":function(){   
                             
                              WayUpdClick();
                              
                              }   
             }
             
             })
             

        var AdviceDelButton = new Ext.Button({
             width : 65,
             id:"AdviceDelBtn",
             text: '删除',
             iconCls:"page_delete",
             listeners:{
                          "click":function(){   
                             
                              AdviceDelClick();
                              
                              }   
             }
             
             })



       var WayCodeField=new Ext.form.TextField({
  
	        width : 60, 
	        id:"WayCodeTxt",         
	        fieldLabel:"代码" 
        })
        
        
        var WayDescField=new Ext.form.TextField({
  
	        width : 300, 
	        id:"WayDescTxt",         
	        fieldLabel:"方式" 
        })
        
        
        
        
        var WayActiveField=new Ext.form.Checkbox({
        
		boxLabel : '激活',
		id : 'WayActive',
		inputValue : '1',
		checked : false
         })
        
        
     var ReSaveField=new Ext.form.Checkbox({     
			boxLabel : '重复抽取',
			id : 'ReSaveFlag',
			inputValue : '1',
			checked : false
				})   

	
   var waygridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'代码',dataIndex:'waycode',width:90},
        {header:'方式',dataIndex:'waydesc',width:330},
        {header:'激活',dataIndex:'wayactive',width:90},
        {header:'重复抽取',dataIndex:'resaveflag',width:80},
        {header:'rowid',dataIndex:'wayrowid',width:40,hidden:true}
            
          ]   
            
    
    });

 
    var waygridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryWayDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'waycode',
            'waydesc',
            'wayactive',
			'resaveflag',
            'wayrowid'
	    
		]),
		
		

        remoteSort: true
});


 
 var waygrid = new Ext.grid.GridPanel({
   
        id:'waytbl',
        title:'点评方式维护',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: waygridds,
        cm: waygridcm,
        enableColumnMove : false,
        stripeRows: true,
		tbar:['代码',WayCodeField,'方式',WayDescField,'&nbsp;&nbsp;',WayActiveField,'&nbsp;&nbsp;',ReSaveField,'&nbsp;&nbsp;',WayAddButton,'-',WayUpdButton],  
        trackMouseOver:'true' 
    });
    
    
    waygrid.on('rowclick',function(grid,rowIndex,e){
       	var selectedRow = waygridds.data.items[rowIndex];
       	var waycode=selectedRow.data["waycode"];; 
       	var waydesc = selectedRow.data["waydesc"];
		var wayactive = selectedRow.data["wayactive"];
		Ext.getCmp("WayCodeTxt").setValue(waycode);
		Ext.getCmp("WayDescTxt").setValue(waydesc);
		if (wayactive=='Y'){
			Ext.getCmp("WayActive").setValue('1');
		}
		if (wayactive!='Y'){
			Ext.getCmp("WayActive").setValue('0');
		}
		
		var resaveflag = selectedRow.data["resaveflag"];
		if (resaveflag=='Y'){
			Ext.getCmp("ReSaveFlag").setValue('1');
		}
		if (resaveflag!='Y'){
			Ext.getCmp("ReSaveFlag").setValue('0');
		}
		
		
    });  
    
    
    
	
    ///view

	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [waygrid]

			});





///-----------------------Events----------------------




///增加

function WayAddClick()
{
                var waycode=Ext.getCmp("WayCodeTxt").getValue();
                
                if (waycode==""){
                   Ext.Msg.show({title:'提示',msg:'请先录入代码!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                } 
                
                var waydesc=Ext.getCmp("WayDescTxt").getValue();
                
                if (waydesc==""){
                   Ext.Msg.show({title:'提示',msg:'请先录入方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                } 
                
                var wayactive=Ext.getCmp("WayActive").getValue();  
                if (wayactive){
                   var wayactive="Y";
                }
                else
                {
                   var wayactive="N";
                }
                
                var resaveflag=Ext.getCmp("ReSaveFlag").getValue();  
                if (resaveflag){
                   var resaveflag="Y";
                }
                else
                {
                   var resaveflag="N";
                }
    
					var otherstr=resaveflag
    
	
	       ///数据库交互
	
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=AddWay&WayDesc='+waydesc + '&WayActive='+wayactive+ '&WayCode='+waycode+ '&OtherStr='+otherstr ,
	
		waitMsg:'删除中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryWayDs();
	  		}
	  		else{

				   if (jsonData.retvalue=="-99")
				   {
					   Ext.Msg.alert("提示", "代码或者名称重复，不能添加！");
				   }else{
					   Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
				   }
	  		       
	  		    
	  		}
		},
		
			scope: this
		});
		

}
  
  
 ///查找数据
 
function QueryWayDs()
{
                waygridds.removeAll(); 
                
    		waygridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryWayDs' });
		
		waygridds.load({
		
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
		
}




///修改事件

function WayUpdClick()
{


               var row = Ext.getCmp("waytbl").getSelectionModel().getSelections();   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
	       
	       var WayID = row[0].data.wayrowid;  //原因ID   
	       var WayCode=Ext.getCmp("WayCodeTxt").getValue();    
               var WayDesc=Ext.getCmp("WayDescTxt").getValue();    //描述
               var WayActive=Ext.getCmp("WayActive").getValue(); 
               if (WayActive){
                   WayActive="Y";
               }else{
                   WayActive="N";
               }
               
               
               if (WayDesc=="") {
                   Ext.Msg.show({title:'提示',msg:'请先录入方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
               }
               
               var resaveflag=Ext.getCmp("ReSaveFlag").getValue();  
                if (resaveflag){
                   var resaveflag="Y";
                }
                else
                {
                   var resaveflag="N";
                }
    
					var otherstr=resaveflag
                
	
	       ///数据库交互
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=UpdWay&WayDesc='+WayDesc+'&WayActive='+WayActive+'&WayID='+WayID+'&WayCode='+WayCode+ '&OtherStr='+otherstr ,
	
		waitMsg:'处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryWayDs();
	  		}
	  		else if (jsonData.retvalue==-101){
	  		       Ext.Msg.alert("提示", "点评方式代码或者描述与其他点评方式重复,不能修改！");
	  		    	
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});
		
		
            


}




///修改原因的事件

function AdviceDelClick()
{

               var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
  
	       Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',DelClickResult);



}





///删除确认动作
 function  DelClickResult(btn)
 {
               if (btn=="no"){ return ;}
               
               
               var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections(); 
	       var advrowid = row[0].data.advrowid;  //原因ID       

	       ///数据库交互删除
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=AdviceDel&AdviceID='+advrowid ,
	
		waitMsg:'删除中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryAdviceDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "删除失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});       
               

               
               
               
   }
   
   
   
   
   
  
	
	


});
