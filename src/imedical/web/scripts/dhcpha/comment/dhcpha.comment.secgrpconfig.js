var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth=160;

Ext.onReady(function() {

		Ext.QuickTips.init();// 浮动信息提示
        Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		///安全组
		
		var ComBoSecGrpDs = new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
						+ '?action=GetSecGrpDs',
				method : 'POST'
			}),
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'grpdr'},['grpdesc','grpdr'])
					
		});
	
		var ComBoSecGrp = new Ext.form.ComboBox({
			store: ComBoSecGrpDs,
			displayField:'grpdesc',
			mode: 'local', 
			width : comwidth,
			id:'SecGrpCmb',
			emptyText:'',
			listWidth : 350,
			valueField : 'grpdr',
			emptyText:'选择安全组...',
			fieldLabel: '安全组',
			allowBlank: false,
			valueNotFoundText:''
		}); 
		
		
		//修改权限
	   var UpdateFlagField=new Ext.form.Checkbox({
        
			boxLabel : '修改权限',
			id : 'UpdateFlagChk',
			inputValue : '1',
			checked : false
         })
	
	   
        var WayItmAddButton = new Ext.Button({
             width : 65,
             id:"WayItmAddBtn",
             text: '增加',
             iconCls:"page_add",
             listeners:{
                          "click":function(){   
                             
                              WayItmAddClick();
                              
                              }   
             }
             
             })
             
        var WayItmUpdButton = new Ext.Button({
             width : 65,
             id:"WayItmUpdBtn",
             text: '修改',
             iconCls:"page_edit",
             listeners:{
                          "click":function(){   
                             
                              WayItmUpdClick();
                              
                              }   
             }
             
        })           
       var WayUpdButton = new Ext.Button({
             width : 65,
             id:"WayUpdBtn",
             text: '修改',
             listeners:{
                          "click":function(){   
                             
                              WayUpdClick();
                              
                              }   
             }
             
             })
             

        var WayItmDelButton = new Ext.Button({
             width : 65,
             id:"WayItmDelBtn",
             text: '删除',
             iconCls:"page_delete",
             listeners:{
                          "click":function(){   
                             
                              WayItmDelClick();
                              
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
        
        
        

	
   var waygridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'代码',dataIndex:'waycode',width:60},
        {header:'方式',dataIndex:'waydesc',width:300},
        {header:'激活',dataIndex:'wayactive',width:100},
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
            'wayrowid'
	    
		]),
		
		

        remoteSort: true
});


 
 var waygrid = new Ext.grid.GridPanel({
   
        id:'waytbl',
        title:'点评方式安全组配置',
        region:'north',
        width:650,
        height:290,
        autoScroll:true,
        enableHdMenu : false,
        ds: waygridds,
        cm: waygridcm,
        enableColumnMove : false,
        stripeRows: true,
    
        trackMouseOver:'true'
        

        
    });
    
    
    waygrid.on('rowclick',function(grid,rowIndex,e){

               	var selectedRow = waygridds.data.items[rowIndex];
               	var wayid=selectedRow.data["wayrowid"];; 
				
				QueryWayItmDs(wayid);
				
		
    });  
    
    

    
    
   var wayitmgridcm = new Ext.grid.ColumnModel({
  
		  columns:[
		       
		        {header:'安全组',dataIndex:'secgrp',width:205},
		        {header:'修改权限',dataIndex:'updateflag',width:80},
		        {header:'rowid',dataIndex:'wayitmid',width:60,hidden:true}
		            
		          ]   
            
    
    });

 
    var wayitmgridds = new Ext.data.Store({
	//autoLoad: true,
	proxy : '',
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'secgrp',
            'updateflag',
            'wayitmid'
	    
		]),
		
		

        remoteSort: true
});
    
    
    
    
      var wayitmgrid = new Ext.grid.GridPanel({
   
        id:'wayitmtbl',
        title:'配置列表',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: wayitmgridds,
        cm: wayitmgridcm,
        enableColumnMove : false,
        stripeRows: true,
        tbar:["安全组",ComBoSecGrp,"&nbsp;&nbsp;",UpdateFlagField,WayItmAddButton,'-',WayItmUpdButton,'-',WayItmDelButton],
        trackMouseOver:'true'
        

        
    });   
    
    
	
    ///view

	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [waygrid,wayitmgrid]

			});





///-----------------------Events----------------------



///增加

function WayItmAddClick()
{
		        
		       var waytblrow = Ext.getCmp("waytbl").getSelectionModel().getSelections(); 
		      

		       if (!(waytblrow)){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'提示',msg:'未选点评方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       			}
       			
       			if (waytblrow==0){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'提示',msg:'未选点评方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       			}
       			
		       
	            var wayrowid = waytblrow[0].data.wayrowid;  //点评方式ID  
	            
		       
                var grpdr=Ext.getCmp("SecGrpCmb").getValue();
                 var grpdesc=Ext.getCmp("SecGrpCmb").getRawValue();
                if (trim(grpdesc)==""){
	               grpdr="";
	            }
                
                if (grpdr==""){
                   Ext.Msg.show({title:'提示',msg:'请先选择安全组!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                } 
                var updateflag=Ext.getCmp("UpdateFlagChk").getValue();  
                if (updateflag){
                   var updateflag="Y";
                }
                else
                {
                   var updateflag="N";
                }
                
                var Input=updateflag ;
      
	
	       		///数据库交互
	
				Ext.Ajax.request({
			
			        url:unitsUrl+'?action=AddWayItm&WayID='+wayrowid + '&GrpDr='+grpdr+ '&Input='+updateflag,
			
					waitMsg:'删除中...',
					failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
			  	        if (jsonData.retvalue==0) {
			  		       Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		       QueryWayItmDs(wayrowid);
			  		}
			  		 else if (jsonData.retvalue==-2) {
			  		       Ext.Msg.alert("提示", "该安全组已授权,不能重复添加! ");
			  		    
			  		}else if (jsonData.retvalue==-100) {
			  		       Ext.Msg.alert("提示", "不存在此安全组,不能添加!");
			  		    
			  		}
			  		else  {
			  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
			  		    
			  		}
				},
				
					scope: this
				});
		

}
  
  
 ///查找数据
 
function QueryWayItmDs(wayid)
{
	            Ext.getCmp("SecGrpCmb").setValue('');

                wayitmgridds.removeAll(); 
                
    			wayitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryWayItmDs&WayID='+wayid });
		
				wayitmgridds.load({
		
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
                
	
	       ///数据库交互
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=UpdWay&WayDesc='+WayDesc+'&WayActive='+WayActive+'&WayID='+WayID+'&WayCode='+WayCode ,
	
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
	  		else{
	  		       Ext.Msg.alert("提示", "保存失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});
		
		
            


}




///修改原因的事件

function WayItmDelClick()
{

           var row = Ext.getCmp("wayitmtbl").getSelectionModel().getSelections();   
	
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
               
               
               var row = Ext.getCmp("wayitmtbl").getSelectionModel().getSelections(); 
	           var wayitmid = row[0].data.wayitmid;  //ID       

			       ///数据库交互删除
			    
				Ext.Ajax.request({
			
			        url:unitsUrl+'?action=DelWayItmData&WayItmId='+wayitmid ,
			
				waitMsg:'删除中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
			  	        if (jsonData.retvalue==0) {
			  		       Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		       QueryWayItmDs(wayitmid);
			  		}
			  		else{
			  		       Ext.Msg.alert("提示", "删除失败!返回值: "+jsonData.retinfo);
			  		    
			  		}
				},
				
					scope: this
				});       
		               

               
               
               
   }
///修改权限

function WayItmUpdClick()
{   
               var waytblrow = Ext.getCmp("waytbl").getSelectionModel().getSelections(); 
		       if (!(waytblrow)){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'提示',msg:'未选点评方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       		   }
       		   if (waytblrow==0){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'提示',msg:'未选点评方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       		   }
		       var row = Ext.getCmp("wayitmtbl").getSelectionModel().getSelections(); 
		       if (row.length == 0) {  
			      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			      return;  
		       }  
		       var wayrowid=waytblrow[0].data.wayrowid;
		       var wayitmid = row[0].data.wayitmid;  //ID  
		       var update = row[0].data.updateflag;
		       var secgrp=row[0].data.secgrp;
		       var grpdr=Ext.getCmp("SecGrpCmb").getValue();
               var grpdesc=Ext.getCmp("SecGrpCmb").getRawValue();
               var updateflag=Ext.getCmp("UpdateFlagChk").getValue(); 
               if (updateflag){
                   var updateflag="Y";
               }
               else
               {
                   var updateflag="N";
               }

               if ((grpdesc=="")&&(updateflag==update)){
                   Ext.Msg.show({title:'提示',msg:'数据未发生改变!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
               }
               var Input=updateflag ;
	       	   ///数据库交互
			   Ext.Ajax.request({
			
			        url:unitsUrl+'?action=UpdWayItm&WayID='+wayitmid + '&SecGrp='+secgrp+ '&GrpDr='+grpdr+ '&Input='+updateflag,
					waitMsg:'修改中...',
					failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					     var jsonData = Ext.util.JSON.decode( result.responseText );
			  	         if (jsonData.retvalue==0) {
			  		        Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		        QueryWayItmDs(wayrowid);
			  		     }
			  		     else if (jsonData.retvalue==-2) {
			  		        Ext.Msg.show({title:'提示',msg:'已存在相同安全组!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		        return;
			  		     }
			  		     else  {
			  		        Ext.Msg.alert("提示", "修改失败!返回值: "+jsonData.retinfo);
			  		     }
				},
				
					scope: this
				});
}
});
