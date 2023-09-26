
var findflag="1";
var LgGrpDesc=session['LOGON.GROUPDESC'];  //登陆安全组
FindCommentFun = function(findflag) {
	Ext.QuickTips.init();

	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	if (LgGrpDesc.indexOf('组长') > -1) {
		var logonflag='false';
	}else{
		var logonflag='true';
	}
	
   var FindCommentQueryButton = new Ext.Button({
             width : 55,
             id:"FindCommentQueryBtn",
             text: '查询',
             iconCls:"page_find",
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
             iconCls:"page_goto",
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
             iconCls:"page_delete",
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
               // width : 95,
                value:new Date
            })	
            
            
            
        var FindComEndDateField=new Ext.form.DateField ({
                //format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'FindComEndDate',
	        id: 'FindComEndDate',
	        //width : 95,
	        value:new Date
            })
	
 
	 var ResultData=[['仅有结果','1'],['仅无结果','2'],['仅合理','3'],['仅不合理','4'],['仅医生申诉','5']];
	 
	 
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
			url : unitsUrl
					+ '?action=QueryActiveWayDs&WayType='+findflag,
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
	
	
	//点评药师
	
	 var PhamaDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryPhamaDs',
			method : 'POST'
	
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'docrowid'},['docdesc','docrowid'])
				
	});
	

	var Phama = new Ext.form.ComboBox({
		store: PhamaDs,
		displayField:'docdesc',
		mode: 'local', 
		width : 95,
		id:'Phama',
		listWidth : 200,
		valueField : 'docrowid',
		emptyText:'选择点评药师...',
		fieldLabel: '点评药师'
	}); 


	var SubmitData=[['未点评','1'],['点评中','2'],['已提交','3']];

	var Submitstore = new Ext.data.SimpleStore({
		fields: ['subdesc', 'subid'],
		data : SubmitData
	});

	var SubmitCombo = new Ext.form.ComboBox({
		store: Submitstore,
		displayField:'subdesc',
		mode: 'local', 
		width : 75,
		emptyText:'',
		id:'SubmitComb',
		valueField : 'subid'
	});
 
	// add by myq 20150601 添加提交按钮        
	var SubmitButton = new Ext.Button({
		width : 55,
		id:"SubmitBtn",
		text: '提交',
		iconCls:"page_add",
		listeners:{   
			"click":function(){  
				SubmitCommnetData();
			}   
		} 
	})
             
	///add by myq 20150601 添加取消提交按钮        
	var CancleSubButton = new Ext.Button({
		width : 55,
		id:"CancleSubBtn",
		text: '取消提交',
		hidden : eval(logonflag) ,
		listeners:{   
			"click":function(){
				CancleSubCommnetData();
			}
		}
	})
             
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'单号',dataIndex:'comno',width:125},
        {header:'日期',dataIndex:'comdate',width:100},
        {header:'时间',dataIndex:'comtime',width:100},
        {header:'制单人',dataIndex:'comcreator',width:75},
        {header:'类型',dataIndex:'comtype',width:75},
        {header:'方式',dataIndex:'comway',width:125},
        {header:'查询条件',dataIndex:'comtext',width:400},
        {header:'rowid',dataIndex:'comrowid',width:40,hidden:true},
        {header:'点评状态',dataIndex:'pcntsubmit',width:80}  // add by myq 20150601  
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
   		'pcntsubmit'  // add by myq 20150601 
	    
		]),
		
		

    remoteSort: true
});


 
 var commentgrid = new Ext.grid.GridPanel({
        
        id:'commentgridtbl', 
        stripeRows: true,
        region:'center',
        width:200,
        height:600,
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
		   
		   
			   if (record.data.pcntsubmit == "已提交") {
			      return 'x-grid-record-pink'; 
			   }
		   
		   }
		    
		    
	    }),
	    
	tbar:['开始日期:',FindComStDateField,"-",'截止日期:',FindComEndDateField,'-','点评方式','-',ComBoWay,'结果','-',ResultCombo,'点评药师','-',Phama,'点评状态','-',SubmitCombo,FindCommentQueryButton,"-",FindCommentOKButton,"-",FindCommentDelButton,"-",SubmitButton,"-",CancleSubButton],  
        //bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
    
    
    commentgrid.on('rowdblclick',function(grid,rowIndex,e){
    	FindMainOrdData();
    })
    
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
	    })
    });   
    
    
	

    
  // define window and show it in desktop
  var FindCommentWindow = new Ext.Window({
    title: '查找点评单',
    width: document.body.clientWidth*0.9,
    height:document.body.clientHeight*0.9,
    minWidth:  document.body.clientWidth*0.3,
    minHeight:document.body.clientHeight*0.3,
    layout: 'border',
    plain:true,
    modal:true,
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
                //findflag="1" //门诊
                way=Ext.getCmp("waycomb").getValue(); 
                var submit=Ext.getCmp("SubmitComb").getValue();  //ad by myq 20150601   
                var phamaid=Ext.getCmp("Phama").getValue();  //药师  
                var retflag=Ext.getCmp("ResultComb").getValue();  //结果
                parstr=way+"^"+submit+"^"+phamaid+"^"+retflag //其它查询条件
                var LogonLocId;
                LogonLocId = session['LOGON.CTLOCID'];
				//commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCommentNo&StDate='+sdate+'&EndDate='+edate+'&ParStr='+parstr+'&FindFlag='+findflag});
				 commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCommentNo&StDate='+sdate+'&EndDate='+edate+'&ParStr='+parstr+'&FindFlag='+findflag+'&LogonLocId='+LogonLocId});
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

                   var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   

			       if (row.length == 0) {  
				      
				      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				      return;  
			       }  
				
			       var rowid = row[0].data.comrowid;
			       var comno= row[0].data.comno;
			       var comtext= row[0].data.comtext;
                   var maintitle="处方点评    当前点评单号:"+comno+"条件:"+comtext ;
                   var retflag=Ext.getCmp("ResultComb").getValue();
                   var phama=Ext.getCmp("Phama").getValue();
                   QueryCommontItm(rowid,maintitle,retflag,phama);
                   
                   FindCommentWindow.close();

}


///删除点评单

function  DelCommnetData()
    {
	    var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	    if (row.length == 0) {  
		      Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	    }  
	    Ext.MessageBox.confirm('注意', '确认要删除吗 ? ',ShowDelResult);
	
    }

///删除确认动作
function  ShowDelResult(btn)
 {
           if (btn=="no"){ return ;}
           var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")
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
          
          
/// add by myq 20150601
///提交点评单
function  SubmitCommnetData(){
    var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")
	if (row.length == 0) {  
		Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;  
	}  
    Ext.MessageBox.confirm('注意', '确认要提交吗 ? ',ShowSubmitResult);
}

///提交确认动作
function  ShowSubmitResult(btn){
	if (btn=="no"){ return ;}
	var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")
	var commontno = row[0].data.comno;

	///数据库交互提交
	Ext.Ajax.request({
		url:unitsUrl+'?action=SubmitCommentNo&CommontNo='+commontno,
		waitMsg:'提交中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success==0) {
				Ext.Msg.alert("提示", "提交成功！");
				FindCommentNo();
			}
			else if (jsonData.success==-2){
				Ext.Msg.alert("提示", "该点评单已经提交!");
				return;
			}
			else{
				Ext.Msg.alert("提示", "提交失败!返回值: "+jsonData.success);
				return;
			}
		},
		scope: this
	});  
} 


/// add by myq 20150601
///取消提交点评单
function  CancleSubCommnetData(){
	var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	if (row.length == 0) {  
		Ext.Msg.show({title:'提示',msg:'未选中记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;  
	}
    Ext.MessageBox.confirm('注意', '确认要取消提交吗 ? ',ShowCancleSubResult);
}

///取消确认动作
function  ShowCancleSubResult(btn){
	if (btn=="no"){ return ;}                        
	var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	var commontno = row[0].data.comno;
	///数据库交互提交
	Ext.Ajax.request({
		url:unitsUrl+'?action=CancleSubCommentNo&CommontNo='+commontno,
		waitMsg:'取消中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success==0) {
				Ext.Msg.alert("提示", "取消成功！");
				FindCommentNo();
			}
			else if (jsonData.success==-2){
				Ext.Msg.alert("提示", "该点评单尚未提交!");
				return;
			}
			else{
				Ext.Msg.alert("提示", "取消失败!返回值: "+jsonData.success);
				return;
			}
		},
	scope: this
	});

}   



};