
var unitsUrl = 'dhcpha.comment.query.save.csp';
var idTmr="";
var comwidth=120;

Ext.onReady(function() {

     Ext.QuickTips.init();// 浮动信息提示
	 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;        
	 Ext.Ajax.timeout = 900000;
             
	 var ResultData=[['仅合格','1'],['仅不合格','2'],['仅有结果','4'],['全部','3']];
	 
	 
	 var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data : ResultData
		});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField:'retdesc',
		mode: 'local', 
		width : comwidth,
		id:'ResultCmb',
		emptyText:'',
		valueField : 'retid',
		emptyText:'选择点评结果...',
		fieldLabel: '点评结果'
	});


	
  var StDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                width : comwidth,
                value:new Date
            })	
            
            
            
  var EndDateField=new Ext.form.DateField ({
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        width : comwidth,
	        value:new Date
            })
            
   var FindButton = new Ext.Button({
             width : 65,
             id:"FindButton",
             text: '统计',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{   
                          "click":function(){   
                             
                              FindCNTSData();
                              
                              }   
                       } 
             
             }) 
             
    var ExportButton = new Ext.Button({
             width : 65,
             id:"ExportButton",
             text: '导出Excel',
             icon:"../scripts/dhcpha/img/save.gif",
             listeners:{   
                          "click":function(){   
                             
                              ExportNTSData();
                              
                              }   
                       } 
             
             })   
        
        
     
             
             
              var QueryForm = new Ext.FormPanel({
                                labelWidth : 80,
				region : 'north',
				title:'住院合理用药指标统计',
				frame : true,
				height:140,
				tbar:[FindButton,'-',ExportButton],
				items : [{
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   StDateField  ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   EndDateField  ]
									    
										
								        },{
								        
								                labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [     ]
								        }  
								        
								        
								        
								        
				                                 ]
								   
								   
								   
								   
					},{
					
					
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [     ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [    ]
									    
										
								        },{
								                labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   ]	    
										
								        }
								        	
								        
								   ]
					
					    }
					

					
					
					
					]

			});				
			
 



			
			       
    
   ////明细table 
 var nm = new Ext.grid.RowNumberer();   
 var commentitmgridcm = new Ext.grid.ColumnModel([nm,

        {header:'科室',dataIndex:'loc',width:120},
        {header:'人均用药品种数',dataIndex:'drugnum',width:100},
        {header:'人均药费',dataIndex:'drugamt',width:100},
        {header:'抗菌药百分率',dataIndex:'antdrug',width:100},
        {header:'注射药百分率',dataIndex:'zsdrug',width:100},
        {header:'基本药物占百分率',dataIndex:'basdrug',width:100}

    
    ]);
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
        'loc',
	    'drugnum',
	    'drugamt',
	    'antdrug',
	    'zsdrug',
	    'basdrug'
		]),
		
		

    remoteSort: true
});


 var commentitmgridPagingToolbar = new Ext.PagingToolbar({	
			store:commentitmgridds,
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
		    scrollDelay: false
		    
		    
	    }),
	    
        bbar: commentitmgridPagingToolbar,
        trackMouseOver:'true'
        

        
    });  
    
   
       ///框架定义
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,commentitmgrid]

			});
 
function FindCNTSData()
{
	
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
	        waitMask.show();

                ClearWindow();
                 
                sdate=Ext.getCmp("startdt").getRawValue();       
                edate=Ext.getCmp("enddt").getRawValue();
               

                QueryStr=sdate+"^"+edate ;
                
		commentitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindIPRationalUseData&QueryStr='+QueryStr});

		commentitmgridds.load({
						
		params:{start:0, limit:commentitmgridPagingToolbar.pageSize}, 
		
		callback: function(r, options, success){
 
		         waitMask.hide() ;
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});

                
     
		
		


}


function ClearWindow()
{
   commentitmgridds.removeAll();
 
}
 


function ExportNTSData()
{
            sdate=Ext.getCmp("startdt").getRawValue();       
            edate=Ext.getCmp("enddt").getRawValue();
           
            QueryStr=sdate+"^"+edate;
            
			var expwin=new Ext.Window({
			title: '导出excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSIPRationalUse" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSIPRationalUse.raq&QueryStr=' + QueryStr + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();
	
}











});
                                                                                        