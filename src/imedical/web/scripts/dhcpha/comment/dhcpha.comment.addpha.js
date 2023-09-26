///点评药师维护JS
///Creator:MYQ
///CreatDate:2013-11-28

var unitsUrl = 'dhcpha.comment.main.save.csp';
var comwidth=120;
var ruleformwd=650;

Ext.onReady(function() {

         Ext.QuickTips.init();// 浮动信息提示
	
	     Ext.Ajax.timeout = 900000;
         Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
        
        ///医生
	
	 var ComBoDocDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetPhaDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'doctordr'},['docname','doctordr'])
				
	});
	
	
	var PhamaCombo = new Ext.form.ComboBox({
		store: ComBoDocDs,
		displayField:'docname',
		mode: 'local', 
		width : comwidth,
		id:'PhamaCmb',
		emptyText:'',
		valueField : 'doctordr',
		emptyText:'请选择药师...'
	   //fieldLabel: '药师姓名'
	});

	 var PhaAddButton = new Ext.Button({
             width : 65,
             id:"PhaAddBtn",
             text: '增加',
             iconCls:"page_add",
             listeners:{
                          "click":function(){   
                             
                              PhamaAddClick();
                              
                              }   
             }
             
             })
             
             
             

        var DocDelButton = new Ext.Button({
             width : 65,
             id:"DocDelBtn",
             text: '删除',
             iconCls:"page_delete",
             listeners:{
                          "click":function(){   
                             
                              PhamaDelClick();
                              
                              }   
             }
             
             })
             
             
             	
   var Phamagridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'药师姓名',dataIndex:'docdesc',width:220},
        {header:'点评药师序号',dataIndex:'docrowid',width:100},
        {header:'药师id',dataIndex:'docdescdr',width:100,hidden:true}
            
          ]   
            
    
    });

 
    var Phamagridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryPhamaDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'docdesc',
            'docrowid',
            'docdescdr'
	    
		]),
		
		

        remoteSort: true
});
	
	
   var Phamagrid = new Ext.grid.GridPanel({
   
        id:'Phamatbl',
        title:'分配点评药师权限',
        region:'center',
        //width:ruleformwd,
        autoScroll:true, //自动生成滚动条
        enableHdMenu : false,
        frame : true,
        autoHeight:true,
        autoWidth:true,
        ds: Phamagridds,
        cm: Phamagridcm,
        enableColumnMove : false,
        stripeRows: true,

	tbar:['药师姓名',PhamaCombo,' ',PhaAddButton,'-',DocDelButton],  
    
        trackMouseOver:'true'
        

        
    });
    
       Phamagrid.on('rowclick',function(grid,rowIndex,e){

               	var selectedRow = Phamagridds.data.items[rowIndex];
               	var docdesc=selectedRow.data["docdesc"];
               	var doctordr=selectedRow.data["docdescdr"];
                //Ext.getCmp("PhamaCmb").setRawValue(docdesc);
                //Ext.getCmp("PhamaCmb").setValue(doctordr);
			
       });
       			
	

	 var QueryForm = new Ext.Panel({
      region : 'center',
      frame : true, 
      items : [Phamagrid]
      
   })
 
     var port = new Ext.Viewport({

				layout : 'fit',

				items : [QueryForm]

			});

 


		 
  
//增加点评药师
function PhamaAddClick()
{
	
	var docdesc=Ext.getCmp("PhamaCmb").getValue();
                if (docdesc==""){
                   Ext.Msg.show({title:'提示',msg:'请先选择药师!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                }             
	 
	       ///数据库交互
	
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=PhamaAdd&DocDesc='+docdesc ,
	
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			
	  	    if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'提示',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryPhamaDs();
	  		}
	  		else if (jsonData.retvalue==100) {
	  		       Ext.Msg.alert("提示", "该药师已经存在,不能重复添加!"); //不能重复添加药师
	  		}else if (jsonData.retvalue==-10) {
	  		       Ext.Msg.alert("提示", "该药师不存在,不能添加!"); //不能添加药师
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "添加失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		      
			scope: this
		});
		
}

//删除点评药师
function PhamaDelClick()
{
	
	 var row = Ext.getCmp("Phamatbl").getSelectionModel().getSelections();   
	
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
               
               
               var row = Ext.getCmp("Phamatbl").getSelectionModel().getSelections(); 
	       var docrowid = row[0].data.docrowid;         

	       ///数据库交互删除
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=PhamaDel&PhamaID='+docrowid ,
	
		waitMsg:'删除中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryPhamaDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "删除失败!返回值: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});       
                          
   }
   

 ///查找数据
function QueryPhamaDs()
{
               Phamagridds.removeAll(); 
                
    		Phamagridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryPhamaDs' });
		
		Phamagridds.load({
		
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
		
}


});
                                                                                        