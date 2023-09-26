
var unitsUrl = 'dhcpha.comment.main.save.csp';
var comwidth=120;
var ruleformwd=800;
var findflag="1";

Ext.onReady(function() {

         Ext.QuickTips.init();// 浮动信息提示
	
	     Ext.Ajax.timeout = 900000;
        
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
             
     var SaveButton = new Ext.Button({
             width : 55,
             id:"SaveBtn",
             text: '分配点评任务',
             listeners:{   
                          "click":function(){  

                           SaveData();
                         
                              }   
                       } 
             })
    
	
  	
	
      var FindComStDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'FindComStDate',
                id: 'FindComStDate',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                width : 95,
                value:new Date
            })	
            
            
            
        var FindComEndDateField=new Ext.form.DateField ({
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'FindComEndDate',
	        id: 'FindComEndDate',
	        width : 95,
	        value:new Date
            })
	
   
	 

 
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'单号',dataIndex:'comno',width:120},
        {header:'日期',dataIndex:'comdate',width:100},
        {header:'时间',dataIndex:'comtime',width:100},
        {header:'制单人',dataIndex:'comcreator',width:80},
        {header:'类型',dataIndex:'comtype',width:60},
        {header:'方式',dataIndex:'comway',width:100},
        {header:'所抽处方总数量',dataIndex:'pnum',width:110},
        {header:'可分配处方数',dataIndex:'prenum',width:100},
        {header:'查询条件',dataIndex:'comtext',width:300,hidden:true},
        {header:'rowid',dataIndex:'comrowid',width:40,hidden:true} 
          
          ]   
      
    });
 
 
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
	    'comrowid',
	    'prenum',
	    'pnum'
	    
		]),

    remoteSort: true
});

///查抽取的点评单
var commentgrid = new Ext.grid.GridPanel({
        
        id:'commentgridtbl', 
        stripeRows: true,
        region:'center',
        width:ruleformwd,
        height:210,
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
			   
			  // return 'x-grid-record-green'; 
			   
			   }
		   } 
		    
	    }),
	   
        trackMouseOver:'true'
        

        
    });
   
 
    var Doctorgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryDoctorDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'docdesc',
            'docrowid',
            'presconum'
	    
		]),
	

        remoteSort: true
});
	  
 var Doctorgridcm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),  
  {
        header:"药师姓名",
        dataIndex:'docdesc',
        width:180,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'docdesc',
            allowBlank:false
        })
    },{
        header:"药师需要点评的处方数量",
        dataIndex:'presconum',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'presconum'
            })
        },{
        header:"药师序号",
        dataIndex:'doctorid',
        width:300,
        align:'left',
        sortable:true,
        hidden:true,
        editor: new Ext.form.TextField({
            id:'doctorid'
        })
    }
    
    ]);

 ///为药师分配点评任务
   var Doctorgrid = new Ext.grid.EditorGridPanel({
   
        id:'Doctortbl',
        region:'center',
        width:780,
        autoScroll:true, //自动生成滚动条
        enableHdMenu : false,
        trackMouseOver:true,//
        frame : true,
		height:250,
        ds: Doctorgridds,
        cm: Doctorgridcm,
        enableColumnMove : false ,
        stripeRows: true,
        clicksToEdit:1,

        trackMouseOver:'true'
        

        
    });
    
   
    var detailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
  
        {header:'分配点评人',dataIndex:'comuser',width:150},
        {header:'点评处方数量',dataIndex:'comnum',width:150}
        
          ]   
            
    
    });
 
  
    var detailgridds = new Ext.data.Store({	
	autoLoad: true,  
	proxy: new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryDetail',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            
            'comuser',
		    'comnum'
		   
		]),
    remoteSort: true
});



 
 var detailgrid = new Ext.grid.GridPanel({
        title:'点评任务分配明细',
        frame:true,
        id:'detailgridtbl',
        region:'center',
        stripeRows: true,
        autoScroll:true,
        enableHdMenu : false,
        height:300,
        width:200,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    
		    rowHeight: 25,
		     
		    scrollDelay: false
		   
	    }),
	    
        trackMouseOver:'true'
        

        
    });
    
  
    
     var OrdForm = new Ext.Panel({
                title:'查询点评单',
                labelWidth : 80,
				frame : true,
				height:300,
				autoScroll:true,
				width :ruleformwd,
				tbar:['开始日期:',FindComStDateField,"-",'截止日期:',FindComEndDateField,'-',FindCommentQueryButton],  //,"-",FindCommentDelButton
				//collapsible: true,
				items : [   commentgrid  ]
  
			});
			
			
  var AllotForm = new Ext.Panel({
      frame : true,
      autoScroll:true, //自动生成滚动条
      title:'分配点评任务',
      height : 320,
      tbar: [SaveButton],  //,'-',CancleButton
      width:ruleformwd,
      items : [  Doctorgrid	]

      
   })
			
   
    var QueryForm = new Ext.Panel({
      region : 'west',
      frame : true,
      width:ruleformwd, 
      items : [OrdForm,AllotForm]
      
   })
   
   

   var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,detailgrid] //,eastPanel

			});

    
    
    
    
    
    
    
    
///----------------Events----------------


///处方列表grid 单击行事件

commentgrid.getSelectionModel().on('rowselect',function(grid,rowIndex,e){

        var selectedRow = commentgridds.data.items[rowIndex];
		var comrowid = selectedRow.data["comrowid"];
	
        FindData(comrowid)   
	  
	   Doctorgrid.store.reload(); //重新加载分配点评单界面
		
    });  

///查询某段时间内的点评单

function FindCommentNo()
{
                commentgridds.removeAll();  
                sdate=Ext.getCmp("FindComStDate").getRawValue();       
                edate=Ext.getCmp("FindComEndDate").getRawValue();
                findflag="" //门诊+住院 modified by myq 20160811
                
                
				commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryComNo&StDate='+sdate+'&EndDate='+edate+'&FindFlag='+findflag});
				
				commentgridds.load({
				
				callback: function(r, options, success){
		 
				         
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
				
				commentgridds.on('load',function(){
				if (commentgridds.getCount()>0){
				    commentgrid.getSelectionModel().selectFirstRow();
				    //commentgrid.getSelectionModel().selectRow(0);
					commentgrid.getView().focusRow(0);
				}
			});
				
}




///保存数据

function SaveData()
{
	
	 //获取所有的新记录 
        var mr=Doctorgrid.getStore().getCount();
        var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid") 
        if (row.length == 0)
        {
	        Ext.Msg.show({title:'错误',msg:'请先选择要分配的点评单!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	          return false;
	        }
        var prenum= row[0].data.prenum;  //取可分配点评的处方数
       
        var counter=0; 
        var rowid = row[0].data.comrowid; // 点评单的rowid
        var data="";
        for(var i=0;i<mr;i++){
	        var record = Doctorgrid.getStore().getAt(i);
            var docdesc = record.data.docdesc
            var docrowid = record.data.docrowid
            var presconum = record.data.presconum

                if ((presconum<0)||(presconum%1>0)){
	         var crow=parseFloat(i)+1;
	         Ext.Msg.show({title:'错误',msg:'第'+crow+'行分配数量不合法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	         return false;
	         }
	         
	         var allotprescnum=tkMakeServerCall("web.DHCSTCNTSALLOTUSER","GetAllotPrescNum",rowid,docrowid)   //取该点评已经分给某医师的处方数

	         if((docdesc!="")&&(presconum!="")){
		        var presconum = parseFloat(presconum);  //将数据转换成数字类型
	            var difnum=presconum-allotprescnum
		       
               // var dataRow = docdesc+"^"+docrowid+"^"+presconum ;
                var dataRow = docdesc+"^"+docrowid+"^"+difnum ;
                if(data==""){
                    data = dataRow;
                }else{
	                if (difnum<0){
		              data = dataRow+"*"+data;   
	                }
	                else{
		               data = data+"*"+dataRow;  
		                }
                   
                }
                
                
                
                var counter=counter+difnum   //分配处方总数
            }
          
        }
        
        
         
          if (counter>prenum){
	          Ext.Msg.show({title:'错误',msg:'输入的分配数量总和和与可分配处方数不符!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	          return false;
	          }     
      
        if(data==""){
	        Ext.Msg.show({title:'错误',msg:'没有修改或添加新数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            return false;
        }
           
        else{
            Ext.Ajax.request({
	            
	              url:unitsUrl+'?action=SaveAllot&Data='+data+'&Prenum='+prenum+'&Rowid='+rowid ,
	
		waitMsg:'保存中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},      
        
        success: function(result, request) {
         var jsonData = Ext.util.JSON.decode( result.responseText );
         if (jsonData.retvalue==0) {  
              Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
           }else{
             Ext.Msg.show({title:'error', msg:'保存失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR });
            
                    } 
                },    
                scope: this       
            }
            ); 
        } 
        
         
         Doctorgridds.reload() ;
         
         FindData(rowid)      //刷新点评分配明细记录
         
         FindCommentNo()       //刷新点评单查询记录
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
	
	        url:unitsUrl+'?action=DelCommentNo&CommontNo='+commontno,
	
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
    
    
 //查询点评明细
function FindData(Comrowid)  
{
          
                
              var Comrowid = parseFloat(Comrowid);
               
		detailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryDetail&Comrowid='+Comrowid });	
		detailgridds.load({
		callback: function(r, options, success){
 
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
		
}
    
   

});
                                                                                        