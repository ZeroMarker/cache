///配液配伍审核界面JS
///Creator:LiangQiang
///CreatDate:2013-05-20
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;
var AppType="OPIVA";

function showBedResultWin(value)
{
	OpenBedResultWin(value);
}

function showWin(value)
{
	var index=value.indexOf("^");
        if  (index>=0) {
           var tmparr=value.split("^");
	   var dodis=tmparr[0];
	  
        }else{
           var dodis=value;
        }
	OpenShowStatusWin("",dodis);
}


function showPatInfoWin(value)
{
	var index=value.indexOf("^");
        if  (index>=0) {
           var tmparr=value.split("^");
	   var dodis=tmparr[0];
	  
        }else{
           var dodis=value;
        }
       
	OpenShowPatInfoWin(dodis);
}


Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.Ajax.timeout = 900000;



  	 //药房科室控件
	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
				
	});
	
	phlocInfo.on(
		'beforeload',
		function(ds, o){
		    var grpdr=session['LOGON.GROUPID'] ;
			ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		
		}
	);
	

 
	 
	 var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'药房科室',
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  width : 160,
				  listWidth:250,
				  emptyText:'选择药房科室...',
		          allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	

	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
  	   //刷新
    var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '查询',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindReqAdtDetail();
                              
                              }   
             }
             
             
   })
  



  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '审核通过',
             icon:"../scripts/dhcpha/img/update.png",
             listeners:{
                          "click":function(){   
                             
                               SaveAdtData();
                              
                              }   
             }
             
             
             })

    
             
	var RefuseButton = new Ext.Button({
		width : 65,
		id:"BedButton",
		text: '审核拒绝',
		icon:"../scripts/dhcpha/img/cancel.png",
		listeners:{
			"click":function(){   
				EditReason();
			}   
		}  
	})
    
    
var RevokeButton = new Ext.Button({
	width : 65,
	id:"RevokeBtn",
	text: '撤消',
	icon:'',
	listeners:{
		"click":function(){   
			ExeCanelAudit();
		}   
	}
})

var DTButton = new Ext.Button({
	width : 65,
	id:"DTBtn",
	text: '大通处方分析',
	iconCls : 'page_menudic',
	listeners:{
		"click":function(){   
			DaTongPrescAnalyse();
		}   
	}
})
    
   /* 
    var ListLogButton = new Ext.Button({
             width : 65,
             id:"ListLogBtn",
             text: '查看日志',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              //ListLogBtnClick();
                              
                              }   
             }
             
             
             })
             */
    
   //已审核
   var OnlyAdtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '已审核',
		id : 'OnlyAdtChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
   //自动刷新
   var AutoFindChkbox=new Ext.form.Checkbox({
        
		boxLabel : '自动刷新',
		id : 'AutoFindChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						if (Ext.getCmp("AutoFindChk").getValue())
						{
							StartAutoLoad();
						}
					        else{
					       
					               StopAutoLoad();
	
						}
	
					}
		}
    })
 
    //查找病人列表控件
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'druguse',
	            'patid',
	            'patname',
	            'patsex',
	            'patage',
	            'path',
	            'patw',
	            'billtype',
	            'prescno',
		    	'patloc',
		    	'diag',
		    	'adm',
		    	'orditem'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	
	  var patlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'登记号',dataIndex:'patid',width: 90,menuDisabled :'false'},
	        {header:'姓名',dataIndex:'patname',width: 60,menuDisabled :'false'},
	        {header:'性别',dataIndex:'patsex',width: 60,menuDisabled :'false'},
	        {header:'年龄',dataIndex:'patage',width: 60,menuDisabled :'false'},
	        {header:'身高',dataIndex:'path',width: 60,menuDisabled :'false'},
	        {header:'体重',dataIndex:'patw',width: 60,menuDisabled :'false'},
	        {header:'费别',dataIndex:'billtype',width: 90,menuDisabled :'false'},
	        {header:'就诊科室',dataIndex:'patloc',width: 90,menuDisabled :'false'},
	        {header:'诊断',dataIndex:'diag',width: 400,menuDisabled :'false'},
	        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'}
	        
	       
	       ]);
	    
	 var patlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:patlistst,
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
	  
	  var patlistgrid = new Ext.grid.GridPanel({
	        id:'patlisttbl',
		region:'center',
                margins:'3 3 3 3', 
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	       // bbar: patlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	    
	///就诊列表grid 单击行事件

	    

    
         ///医嘱明细数据table
  function selectbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';

   } 
  
  
  function showUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showWin(\""+record.get("dodis")+"\")'/>"+value+"</a>";
  }


  function showPatInfoUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showPatInfoWin(\""+record.get("dodis")+"\")'/>"+value+"</a>";
  }
  
   function bedbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TBedz'+rowIndex+'" name="TBedz'+rowIndex+'"  value="'+re+'"  >';

   } 
   
   
  function showBedUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showBedResultWin(\""+record.get("orditm")+"\")'/>"+value+"</a>";
  }
  
  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        {header:'不合理',width:45,menuDisabled:true,dataIndex:'packflag',renderer:bedbox,hidden:true},
        {header:'登记号',dataIndex:'patid',width:90,renderer:showPatInfoUrl},
        {header:'姓名',dataIndex:'patname',width:60},
        {header:'用药日期',dataIndex:'orddate',width:130},
        {header:'处方号',dataIndex:'prescno',width:100,renderer:showUrl},
        {header:'处方号hide',dataIndex:'prescnoT',width:85,hidden:true},
        {header:'药品名称',dataIndex:'incidesc',width:200},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:80},
        {header:'频次',dataIndex:'freq',width:60},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'用药疗程',dataIndex:'dura',width:60},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱备注',dataIndex:'remark',width:120},
        {header:'审核人',dataIndex:'adtuser',width:60},
        {header:'审核时间',dataIndex:'adtdate',width:130},
        {header:'审核结果',dataIndex:'result',width:60,renderer:showBedUrl},
        {header:'selectflag',dataIndex:'selectflag',hidden:true},
        {header:'orditm',dataIndex:'orditm',hidden:true},
        {header:'dodis',dataIndex:'dodis',width:120},
        {header:'dodisstr',dataIndex:'dodisstr',width:120}
        
        
        
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'select',
            'patid',
            'patname',
            'orddate',
            'prescno',
            'prescnoT',
            'incidesc',
            'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'dura',
		    'form',
		    'doctor',
		    'remark',
		    'adtuser',
		    'adtdate',
		    'result',
		    'selectflag',
		    'orditm',
		    'dodis',
		    'dodisstr'
	    
		]),
		
		

    remoteSort: true
});

     
 var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:orddetailgridds,
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
 
 
 var orddetailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'3 3 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        bbar:orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
	

   orddetailgrid.on('cellclick',OrddetailGridCellClick) 
   
   
   orddetailgrid.on('headerclick', function(grid, columnIndex, e) { 
	
   	     
         if (columnIndex==0){
         	selectAllRows();
         };
     
	
	});
	
	
 
 //开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:GetPIVAStDate()
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:GetPIVAEndDate()
            })
    
  
     
        
        
     //病人登记号查询工具

	
	var patientField=new Ext.form.TextField({
  
        width:160, 
        id:"patientTxt", 
        fieldLabel:"登记号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                FindReqAdtDetail();
                            }
                        }
                    }
        })
        

   
     var DatePanel = new Ext.Panel({
     	 title:'配伍审核',
         frame : true,
         margins:'1 0 0 0', 
         bbar:[RefreshButton,"-",OkButton,'-',RefuseButton,'-',DTButton],
         labelWidth:100,
         region:'center',
          items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 }, {
							    labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  stdatef   ]
							    
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  AutoFindChkbox ]
								
						        } ]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [  patientField  ]
									 },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  enddatef ]
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  OnlyAdtChkbox ]
								
						        }
						        
						        ]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 }]
					  }
					
					
					]

      
   })
    
    ////
    
     var centerform = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'1 0 0 0', 
	    frame : false,
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 2,
         	  layout:'border',
         	  items:[DatePanel]  
         	 },{           
         	  flex: 8,
         	  layout:'border',
         	  items:[orddetailgrid]  
         	 }]
		

	    
	});
	


      var port = new Ext.Viewport({

				layout : 'border',
				items : [centerform]

			});

			
	///////////////////////Event//////////////////
			
			
		
			
			
			
	 //设置默认科室
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
                PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
        }

	}
			
			
		 //返回左边列表选择条件
	  function GetListInput()
	  {
	  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
	        patid=Ext.getCmp('patientTxt').getValue();
	        onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
	
	  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+onlyadt ;
	  	    
	  	    return listinputstr
	  }		

			
	function FindReqAdtDetail()
	{
		var RegNo=Ext.getCmp('patientTxt').getValue();
		var RegNo=GetWholePatID(RegNo);
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'注意',msg:'开始日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'注意',msg:'结束日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'注意',msg:'科室不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		var input=GetListInput();
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据,请稍候..." }); 
        waitMask.show();  
        orddetailgridds.removeAll();
        document.getElementById("TDSelectOrdItm").checked=false;
		orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindReqAdtDetail&RegNo='+RegNo+"&Input="+input });		
		orddetailgridds.load({
		params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
		callback: function(r, options, success){
		         
		         waitMask.hide();
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }

		         
		
		});
		   
	}		
			
			
   ///补0病人登记号
   function GetWholePatID(RegNo)
	{    
	     if (RegNo=="") {
	        return RegNo;
	     }
	     
	     var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
	   	            
	     var plen=RegNo.length;
	 	 if (plen>patLen){
	 		Ext.Msg.show({title:'错误',msg:'输入登记号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	return;
	 	 }
	 	 
 		 for (i=1;i<=patLen-plen;i++)
	  	 {
		 	 RegNo="0"+RegNo;  
	     }
	    
	 	 Ext.getCmp('patientTxt').setValue(RegNo);
	 	
	 	 return RegNo;
	
	}		
			

  	//列单击事件
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {

        if (columnIndex==0){

		  	  var newmoeori="";
		      var record = orddetailgrid.getStore().getAt(rowIndex);
		  	  var moeori =record.data.selectflag ;
		  	  var tmpprescno =record.data.prescnoT ;
		      
		      var view = orddetailgrid.getView();
		      var store = orddetailgrid.getStore();
		      
		      if (document.getElementById("TSelectz"+rowIndex).checked)
		      {
		      	   for (i=0;i<=view.getRows().length-1;i++)
		      	   {
				       if(document.getElementById("TSelectz"+i).checked){       
				          //rsm.deselectRow(i)  
				       }
				       else
				       { 
				         var record = orddetailgrid.getStore().getAt(i);
				  	     var newmoeori =record.data.selectflag ;
				  	     var newprescno =record.data.prescnoT ; 

				  	     
				  	     if ((newmoeori==moeori)||(newprescno==tmpprescno)){
				  	     	 document.getElementById("TSelectz"+i).checked=true;
				  	     }
				  	     else
				  	     {
				  	     	if (i>rowIndex) break;
				  	     }
				       	
				
				       }
		       
		           }
		
		      }else{
		      	   for (i=0;i<=view.getRows().length-1;i++)
		      	   {
				       document.getElementById("TBedz"+rowIndex).checked=false;
				       if(document.getElementById("TSelectz"+i).checked){       
				         var record = orddetailgrid.getStore().getAt(i);
				  	     var newmoeori =record.data.selectflag ;
				  	     var newprescno =record.data.prescnoT ;
				  	     if ((newmoeori==moeori)||(newprescno==tmpprescno)){
				  	     	 document.getElementById("TSelectz"+i).checked=false;
				  	     	 document.getElementById("TBedz"+i).checked=false;
				  	     	 
				  	     }
				  	     else
				  	     {
				  	     	if (i>rowIndex) break;
				  	     }
				       }
				       else
				       { 
		
				       }
		       
		           }
		      	   
		      }
			
		   }
       if (columnIndex==1){
              setUnReasonableflag(rowIndex)
          }
          
  }

 ///设置不合理选择
  function setUnReasonableflag(rowIndex)
  {
	  var newmoeori="";
      var record = orddetailgrid.getStore().getAt(rowIndex);
  	  var moeori =record.data.selectflag ;
  	   var newprescno =record.data.prescnoT ; 
      
      var view = orddetailgrid.getView();
      var store = orddetailgrid.getStore();
      if(document.getElementById("TSelectz"+rowIndex).checked==false)
      {	    Ext.Msg.show({title:'错误',msg:'请先选择，再点不合理!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	document.getElementById("TBedz"+rowIndex).checked=false;
	 	 	return;
	   }
      
      if (document.getElementById("TBedz"+rowIndex).checked)
      {
      	   for (i=0;i<=view.getRows().length-1;i++)    //i=1
      	   {
		       if(document.getElementById("TBedz"+i).checked){       
		          //rsm.deselectRow(i)  
		       }
		       else
		       { 
		         var record = orddetailgrid.getStore().getAt(i);
		  	     var newmoeori =record.data.selectflag ; 
		  	      var newmprescno =record.data.prescnoT ; 
		  	      
		  	     if (newmoeori==moeori){
		  	     	 document.getElementById("TBedz"+i).checked=true;
		  	     }
		  	     else
		  	     {
		  	     	if (i>rowIndex) break;
		  	     }
		       	
		
		       }
       
           }

      }else{
      	   
      	   for (i=0;i<=view.getRows().length-1;i++)
      	   {
		       if(document.getElementById("TBedz"+i).checked){       
		         var record = orddetailgrid.getStore().getAt(i);
		  	     var newmoeori =record.data.selectflag ;
		  	     var newmprescno =record.data.prescnoT ;
		  	     
		  	     if (newmoeori==moeori){
		  	     	 document.getElementById("TBedz"+i).checked=false;
		  	     }
		  	     else
		  	     {
		  	     	if (i>rowIndex) break;
		  	     }
		       }
		       else
		       { 

		       }
       
           }
      	   
      }

  }
  
 
  
  //全选/全销事件
  function selectAllRows()
  {
  	       var cellselected=document.getElementById("TDSelectOrdItm").checked ;
  	       var view = orddetailgrid.getView();
  	       var rows=view.getRows().length ;
  	       if (rows==0) return;
	       for (i=0;i<=rows-1;i++)
      	   {
      	   	   if (cellselected){
      	   	   	  document.getElementById("TSelectz"+i).checked=true;
      	   	   }else{
      	   	   	  document.getElementById("TSelectz"+i).checked=false;
      	   	   }
      	   	   

       
           }
  	
  }
  
 
 
  ///保存审核通过
  function SaveAdtData()
  {
  	       var Auditflag="Y";
       	   var view = orddetailgrid.getView();
  	       var rows=view.getRows().length-1 ;
  	       if (rows==-1) return;
           var rets=CheckSelect();
           if(rets==0) return;
  	      if(CheckDataBeforeSave()==true){
	       for (i=0;i<=rows;i++)
      	       {
      	       	   var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	   if (cellselected){
      	   	   	     	  var record = orddetailgrid.getStore().getAt(i);
                          var prescno =record.data.prescno ;
                          var orditm =record.data.orditm ;
                          if (prescno!=""){
                          	    var adtuser=session['LOGON.USERID'] ;
                          	    var input=Auditflag+","+adtuser+","+orditm+","+session['LOGON.CTLOCID']+","+AppType;
	                            var ret=tkMakeServerCall("web.DHCSTPIVAOUTAUDIT","SaveResult","",input);
                          }
      	   	   }
       
          	}
          	 FindReqAdtDetail(); 
  	      }
                
	       
   }
   	 
	 function CheckSelect()
	 {          
	     var view = orddetailgrid.getView();
  	       var rows=view.getRows().length ;
  	       var retflag=0
	 	       for (i=0;i<=rows-1;i++)
      	       { 
      	        var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	if (cellselected){
                    retflag=1
      	   	   	}
      	      if (retflag==1)
      	       {break;}
      	      }
	  return retflag
	 }	
 function CheckDataBeforeSave()
 {
           var view = orddetailgrid.getView();
  	       var rows=view.getRows().length ;
  	       var retflag=0
	 	       for (i=0;i<=rows-1;i++)
      	       { 
      	        var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	if (cellselected){
	      	      var record = orddetailgrid.getStore().getAt(i);
                  var resulted =record.data.result;
                  
                 if((resulted!="")&&(resulted!="有日志")){
	                 var retflag=1
	      	       Ext.Msg.show({title:'错误',msg:'已审核数据不能重复审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	       return false;
      	           }
      	   	   	}
      	   	   if (retflag==1)
      	       {break;}
      	      }

	return true;  	  
	 
 }  
   
   
   var task_RealTimeMointor = {
		run : FindReqAdtDetail  ,//执行任务时执行的函数
		interval : 20000 
		//任务间隔，毫秒为单位，这里是10秒
   }
   
   //开启自动	
   function StartAutoLoad()
   {		
		 Ext.TaskMgr.start(task_RealTimeMointor);
	 
   }
   
   //关闭自动
   function StopAutoLoad()
   {
	         Ext.TaskMgr.stop(task_RealTimeMointor);
	         
    }          
    
	 ///不合格
	function EditReason()
	{
       
	       var totalnum =orddetailgrid.getStore().getCount() ;
		   if (totalnum==0){
			    return;
			 }
        
	       var orditmstr=GetBedOrdItmStr() ;
          if (orditmstr==""){return;}
	       var waycode =InPhaWay;
	       var retstr=showModalDialog('DHCST.PIVAOUT.SELREASON.csp?orditmstr='+orditmstr+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
        
 
	       if (!(retstr)){
	          return;
	        }
        
	        if (retstr==""){
	          return;
	        }
        
	        retarr=retstr.split("@");
 
	        var ret="N";
		var reasondr=retarr[0];
		//var advicetxt=retarr[2];
		//var factxt=retarr[1];
		//var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;

		var input=ret+","+User+","+orditmstr+","+session['LOGON.CTLOCID']+","+AppType;
	
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTAUDIT", "SaveResult",reasondr,input);
        FindReqAdtDetail();

	}

	 ///获取已打不合理标记的医嘱ID串
	 function GetBedOrdItmStr()
	 {
	 	   var view = orddetailgrid.getView();
		   var store = orddetailgrid.getStore();			      
		   var ret="";	
		   if (CheckDataBeforeSave()==true)	{		 
	      	   for (i=0;i<=view.getRows().length-1;i++)
	      	   {           
			       //if(document.getElementById("TBedz"+i).checked){      //yunhaibao20151109,屏蔽不合理后改用下边那句
			       if(document.getElementById("TSelectz"+i).checked){ 
			        var record = orddetailgrid.getStore().getAt(i);
				    var orditm =record.data.orditm ; 
				    if (ret==""){
				    	ret=orditm;
				    }else{
				        ret=ret+"^"+orditm;
				    }
			    
			    
			       }
		      
		     }
		  }
		  return ret
	 }
	 
	///大通处方分析
	function DaTongPrescAnalyse()
	{
		Ext.Msg.alert("提示","暂时不开放,需要第三方提供接口");
	}
	
	///撤销审核
	function ExeCanelAudit()
	{
		Ext.Msg.alert("提示","已经打签不能撤销审核");
	}	
});