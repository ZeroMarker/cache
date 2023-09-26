///配液复核主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;


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
                             
                                 FindReCheckPatInfo();
                              
                              }   
             }
             
             
   })
  



  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '复核',
             icon:"../scripts/dhcpha/img/update.png",
             listeners:{
                          "click":function(){   
                             
                              RecCheck();
                              
                              }   
             }
             
             
             })

    
             
   var PrtButton = new Ext.Button({
             width : 65,
             id:"PrtButton",
             text: '打印',
             iconCls:'page_print',
             listeners:{
                          "click":function(){   

                              PrintReceipt();
                              
                              }   
             }
             
             
   })
    

    
   //已接收
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
    

 
    
         ///医嘱明细数据table
  function selectbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';

   } 

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        
        {header:'登记号',dataIndex:'patid',width:90},
        {header:'姓名',dataIndex:'patname',width:90},
        {header:'用药日期',dataIndex:'orddate',width:130},
        {header:'处方号',dataIndex:'prescno',width:100},
        {header:'处方号hide',dataIndex:'prescnoT',width:110,hidden:true},
        {header:'药品名称',dataIndex:'incidesc',width:200},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:80},
        {header:'频次',dataIndex:'freq',width:70},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'用药疗程',dataIndex:'dura',width:60},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱备注',dataIndex:'remark',width:120},
        {header:'rowid',dataIndex:'orditm',hidden:true},
        {header:'dsprowid',dataIndex:'dsprowid',hidden:true},
        {header:'pogid',dataIndex:'pogid',width:120},
        {header:'打包状态',dataIndex:'packflag',width:60}
        
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
		    'orditm',
		    'selectflag',
		    'dsprowid',
		    'pogid',
		    'packflag'
	    
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
        trackMouseOver:'true',
		viewConfig:{
		//forceFit:true,
		enableRowBody : true,
		getRowClass :function(record,rowIndex,rowParams,store) {
	        var cls="";
	        if(record.data.packflag=="Y"){
                cls = 'x-grid-record-lightgreen';}
            return cls;
            }
		}  
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
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:new Date
            })
    
  
     
        
        
     //病人登记号查询工具

	
	var patientField=new Ext.form.TextField({
  
        width:160, 
        id:"patientTxt", 
        fieldLabel:"登记号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                //FindOrdDetailData();
                                FindReCheckPatInfo();
                            }
                        }
                    }
        })
        

   
     var DatePanel = new Ext.Panel({
     	 title:'配液复核',
         frame : true,
         margins:'1 0 0 0', 
         bbar:[RefreshButton,"-",OkButton,'-',PrtButton],
         labelWidth:80,
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
								items : [   ]
						        },{
						        labelAlign : 'right',
								columnWidth : .4,
								layout : "form",
								items : [   ]
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
										columnWidth : .4,
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

			
	function FindOrdDetailData()
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
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindOrdDetailData&RegNo='+RegNo+"&Input="+input });		
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
			

	function RecCheck()
	{
		var view = orddetailgrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
		var user=session['LOGON.USERID'] ;
		var h=0;  //选择标志
		var m=0;
		var dspstr="";printno="";
		for (i=0;i<=rows;i++)
		   {
		   	   var cellselected=document.getElementById("TSelectz"+i).checked
		       if (!(cellselected))  continue;
			   h=h+1;
			   var record = orddetailgrid.getStore().getAt(i);
		       var prescno =record.data.prescno;
		       var dsprowid =record.data.dsprowid;
		       var selectflag =record.data.selectflag ;
		       if (selectflag!=""){
					var pogid =record.data.pogid;
					var ret=tkMakeServerCall("web.DHCSTPIVAOUTRECHECK", "SavePivaReCheck",pogid,user);
					if(ret=="-99"){alert("复核人员未在药房维护！");}
					if(ret=="-13"){alert(prescno+"已复核，不能重复复核！");}
					if(ret=="-1"){alert("下一状态非复核状态！");}
					if(ret=="-14"){alert("保存PIVA失败！");}
		       }
		  }	
     
		 FindReCheckPatInfo(); //处理完之后重新检索 
	}

	function FindReCheckPatInfo()
	{
        document.getElementById("TDSelectOrdItm").checked=false
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
		ClearDocument();
		orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindReCheckPatInfo&RegNo='+RegNo+"&Input="+input });		
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

	//清除
	function ClearDocument()
	{
		orddetailgridds.removeAll();
		

	}
	
    	//列单击事件
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {

        if (columnIndex==0){

					  	  var newmoeori="";
					      var record = orddetailgrid.getStore().getAt(rowIndex);
					  	  var moeori =record.data.selectflag ;
					      var mprescnoT =record.data.prescnoT ;
						 
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
							  	     var newprescnoT =record.data.prescnoT ;
							  	     
							  	     if ((newmoeori==moeori)||(newprescnoT==mprescnoT)){
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
							       if(document.getElementById("TSelectz"+i).checked){       
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.selectflag ;
							  	     var newprescnoT =record.data.prescnoT ;
							  	     
							  	     if ((newmoeori==moeori)||(newprescnoT==mprescnoT)){
							  	     	 document.getElementById("TSelectz"+i).checked=false;
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
  
  function PrintReceipt()
  {
	  	//1、准备打印数据
		var view = orddetailgrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
		var pogidstr="";tmppig="";cnt=0;
		for(var i=0;i<=rows;i++)
		{
			if (!(document.getElementById("TSelectz"+i).checked)) 
			{ continue;}
			var record = orddetailgrid.getStore().getAt(i);
			var pogid =record.data.pogid;
			if(tmppig!=pogid){
				if(pogidstr==""){pogidstr=pogid;}
				else{pogidstr=pogidstr+"^"+pogid;}
				tmppig=pogid;
				cnt++;
			}
		}
		if (cnt==0)	{Ext.Msg.show({title:'注意',msg:'请选中数据 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});;return;}	
		//2、Excel
		var prtpath=GetPrintPath();
		var Template=prtpath+"DHCST_PIVAOUT_PRTRECEIPT.xlsx";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
		var h=0;
		var startNo=2;
		
		//3、打印
		xlsheet.Cells(1, 1).Value ="输液室接收清单";
		xlsheet.Cells(2, 1).Value =""//
        var tmparr=pogidstr.split("^")
		for (i=0;i<cnt;i++)
		{
			var pogid=tmparr[i];
			var pogistr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintDetail",pogid);
			var tmparritm=pogistr.split("||");
			var cntitm=tmparritm.length;
			for (k=0;k<cntitm;k++)
			{
				h=h+1;
				var tmparrdata=tmparritm[k].split("^");
				var patno=tmparrdata[1];
				var patname=tmparrdata[0];
				var orddate=tmparrdata[2];
				var drugname=tmparrdata[3];
				var dosage=tmparrdata[4];
				var doctor=tmparrdata[5];
				var freq=tmparrdata[6];
				var prescno=tmparrdata[7];
				var qty=tmparrdata[8];

				if (k==0)
				{                      	  	
					mergcell(xlsheet,startNo+h,1,8) 
					xlsheet.Cells(startNo+h, 1).Value ="登记号:"+patno+" 姓名:"+patname+" 处方号:"+prescno+" 用药时间:"+orddate+" 医生:"+doctor; 
					h=h+1;
					xlsheet.Cells(startNo+h, 1).Value ="药品名称"; 
					xlsheet.Cells(startNo+h, 2).Value ="频次"; 
					xlsheet.Cells(startNo+h, 3).Value ="剂量"; 
					xlsheet.Cells(startNo+h, 4).Value ="数量"; 
					setBottomLine(xlsheet,startNo+h,1,8);
					h=h+1;
				}

				xlsheet.Cells(startNo+h, 1).Value =drugname; 
				xlsheet.Cells(startNo+h, 2).Value =freq; 
				xlsheet.Cells(startNo+h, 3).Value =dosage; 
				xlsheet.Cells(startNo+h, 4).Value =qty; 

			}

			h=h+1;//空两行进行下一组

		}

		xlsheet.printout();
		SetNothing(xlApp,xlBook,xlsheet);
	

  }	
	});