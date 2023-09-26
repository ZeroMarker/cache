

FindCommentFun = function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

   var pageunitsUrl='dhcpha.comment.main.save.csp';
	
   var FindCommentQueryButton = new Ext.Button({
             width : 55,
             id:"FindCommentQueryBtn",
             text: '查询',
             listeners:{   
                          "click":function(){  
              
                           FindCommentNo();
                       
                           
                              }   
                       } 
             
             })		
	

	
	
    var FindCommentOKButton = new Ext.Button({
             width : 55,
             id:"FindCommentOKBtn",
             text: '确定',
             listeners:{   
                          "click":function(){  
                          //Ext.getCmp("txt_name").setValue("1111") 
                          

                          
                               FindMainOrdData();
                              
                           
                              }   
                       } 
             
             })	
             
             
     var FindCommentDelButton = new Ext.Button({
             width : 55,
             id:"FindCommentDelBtn",
             text: '删除',
             listeners:{   
                          "click":function(){  

                           DelCommnetData();
                         
                           
                              }   
                       } 
             
             })	
	
  	
	
      var FindComStDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                //format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'FindComStDate',
                id: 'FindComStDate',
                //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                width : 95,
                value:new Date
            })	
            
            
            
        var FindComEndDateField=new Ext.form.DateField ({
                //format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'FindComEndDate',
	        id: 'FindComEndDate',
	        width : 95,
	        value:new Date
            })
	
 
	 var ResultData=[['仅有结果','1'],['仅无结果','2'],['仅合理','3'],['仅不合理','4']];
	 
	 
	 var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data : ResultData
		});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField:'retdesc',
		mode: 'local', 
		width : 95,
		emptyText:'',
		id:'ResultComb',
		valueField : 'retid'
	});
	
	
	
	 ///点评方式
	
	 var ComBoWayDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : pageunitsUrl
					+ '?action=QueryActiveWayDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'wayrowid'},['waydesc','wayrowid'])
				
	});
	

	var ComBoWay = new Ext.form.ComboBox({
		store: ComBoWayDs,
		displayField:'waydesc',
		mode: 'local', 
		width : 95,
		id:'waycomb',
		emptyText:'',
		listWidth : 200,
		valueField : 'wayrowid',
		emptyText:'选择方式...',
		fieldLabel: '点评方式'
	}); 


  var sm = new Ext.grid.CheckboxSelectionModel(); 
   
  var commentgridcm = new Ext.grid.ColumnModel([sm,

        {header:'单号',dataIndex:'comno',width:100},
        {header:'日期',dataIndex:'comdate',width:80},
        {header:'时间',dataIndex:'comtime',width:60},
        {header:'制单人',dataIndex:'comcreator',width:60},
        {header:'类型',dataIndex:'comtype',width:60},
        {header:'方式',dataIndex:'comway',width:90},
        {header:'查询条件',dataIndex:'comtext',width:300},
        {header:'rowid',dataIndex:'comrowid',width:40}   
       
            
    
    ]);
 
 
    var commentgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comno',
            'comdate',
	    'comtime',
	    'comcreator',
	    'comtype',
	    'comway',
	    'comtext',
	    'comrowid'
	    
		]),
		
		

    remoteSort: true
});


 
 var commentgrid = new Ext.grid.GridPanel({
        
        id:'commentgridtbl', 
        stripeRows: true,
        region:'center',
        width:150,
        height:380,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentgridds,
        cm: commentgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		   getRowClass: function(record, index, rowParams, store) {  
		   
		   
			   if (record.data.flag > 0) {
			   
			  

			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    
	tbar:['开始日期:',FindComStDateField,"-",'截止日期:',FindComEndDateField,'-','点评方式','-',ComBoWay,'结果','-',ResultCombo,FindCommentQueryButton,"-",FindCommentOKButton],  
        //bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
    
    
   ////明细table 
    
 var commentitmgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'明细单子',dataIndex:'comno1',width:100},
        {header:'日期',dataIndex:'comdate1',width:80},
        {header:'时间',dataIndex:'comtime1',width:60},
        {header:'制单人',dataIndex:'comcreator1',width:60},
        {header:'类型',dataIndex:'comtype1',width:60},
        {header:'查询条件',dataIndex:'comtext1',width:300},
        {header:'rowid',dataIndex:'comrowid1',width:40}   
          ]   
            
    
    });
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comno1',
            'comdate1',
	    'comtime1',
	    'comcreator1',
	    'comtype1',
	    'comtex1t',
	    'comrowid1'
	    
		]),
		
		

    remoteSort: true
});




 
 var commentitmgrid = new Ext.grid.GridPanel({
        
        id:'commentgriditmtbl',
        stripeRows: true,
        region:'center',
        width:150,
        //height:290,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentitmgridds,
        cm: commentitmgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		   getRowClass: function(record, index, rowParams, store) {  
		   
		   
			   if (record.data.flag > 0) {
			   
			  

			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    

        trackMouseOver:'true'
        

        
    });   
    
    
	

    
  // define window and show it in desktop
  var FindCommentWindow = new Ext.Window({
    title: '查找点评单',
    width: 800,
    height:450,
    minWidth: 400,
    minHeight: 300,
    layout: 'border',
    plain:true,
    //modal:true,
    bodyStyle:'padding:5px;',
    items:  [  commentgrid]
   //commentitmgrid

    });

    FindCommentWindow.show();




///----------------Events----------------




///查询某段时间内的点评单

function FindCommentNo()
{
                commentgridds.removeAll();  
                sdate=Ext.getCmp("FindComStDate").getRawValue();       
                edate=Ext.getCmp("FindComEndDate").getRawValue();
                findflag="1" //门诊
                way=Ext.getCmp("waycomb").getValue();     
                parstr=way  //其它查询条件
                
		commentgridds.proxy = new Ext.data.HttpProxy({url: pageunitsUrl + '?action=FindCommentNo&StDate='+sdate+'&EndDate='+edate+'&ParStr='+parstr+'&FindFlag='+findflag});
		
		commentgridds.load({
		
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
}


///选取点评单,调出点评单内容


function FindMainOrdData()
{

                               var rows = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   

			       if (rows.length == 0) {  
				      
				      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				      return;  
			       }  
			        
			           var nostr="";
			           for (var i = 0; i < rows.length; i++) {
				            
				            var row = rows[i];
				            var comno= row.data.comno;
				            if (nostr==""){
				               nostr=comno;
				            }
				            else{
				               nostr=nostr+","+comno;
				            }
				           
				        }
                                
                                 var sdate=Ext.getCmp("FindComStDate").getRawValue();       
                                 var edate=Ext.getCmp("FindComEndDate").getRawValue();
                                 var retflag=Ext.getCmp("ResultComb").getValue();
                                 var str=sdate+"^"+edate+"^"+nostr+"^"+retflag;
                                 
                
				 FindCNTSData(str);
			    
                               
                                 FindCommentWindow.close();

}


///删除点评单

function  DelCommnetData()
    {
	   Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',ShowDelResult);
	
    }

///删除确认动作
function  ShowDelResult(btn)
 {
               if (btn=="no"){ return ;}
                                                     
	       var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
	
	       var commontno = row[0].data.comno;
	       
	       ///数据库交互删除
	    
		Ext.Ajax.request({
	
	        url:pageunitsUrl+'?action=DelCommentNo&CommontNo='+commontno,
	
		waitMsg:'删除中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.success==0) {
	  		       FindCommentNo();
	  		}
	  		else{
	  		       Ext.Msg.alert("提示", "删除失败!返回值: "+jsonData.success);
	  		    
	  		}
		},
		
			scope: this
		});
		  
    }
          
          
 
    
    
    
    




};