///配液瓶签界面JS
///Creator:LiangQiang
///CreatDate:2013-05-29
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;

//弹出瓶签状态信息
function showWin(value)
{
	OpenShowStatusWin("",value);
}

//弹出病人基本信息
function showPatInfoWin(value)
{
	OpenShowPatInfoWin(value);
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
             iconCls:'page_query',
             //icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindReqPrtDetail();
                              
                              }   
             }
             
             
   })
  



  var PrtButton = new Ext.Button({
             width : 90,
             id:"PrtButton",
             text: '打印[F8]',
             tooltip:'F8快捷键',
             iconCls:'page_print',
             //icon:"../scripts/dhcpha/img/printer.png",
             listeners:{
                          "click":function(){   
                            
                              SavePrtData();

                              }   
             }
             
             
             })
             
    var map = new Ext.KeyMap(Ext.getDoc(), [{
    key: 119,
    fn:function(){SavePrtData();},
    scope: this
    }]
    );   
   //自动刷新打印
   var AutoPrtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '自动刷新打印',
		id : 'AutoPrtChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						if (Ext.getCmp("AutoPrtChk").getValue())
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
    return "<a href='javascript:showWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
  }

  function showPatInfoUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showPatInfoWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
  }

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        
        {header:'登记号',dataIndex:'patid',width:80,renderer:showPatInfoUrl},
        {header:'姓名',dataIndex:'patname',width:60},
        {header:'用药日期',dataIndex:'orddate',width:130},
        {header:'处方号',dataIndex:'prescno',width:100,renderer:showUrl},
        {header:'处方号hide',dataIndex:'prescnoT',width:100,hidden:true},
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
        {header:'selectflag',dataIndex:'selectflag',hidden:true},
        {header:'dsprowid',dataIndex:'dsprowid',hidden:true},
        {header:'打包',dataIndex:'packflag',width:60},
        {header:'接收状态',dataIndex:'omflag',width:60}  //原来此列叫自备药,yunhaibao20151224
        
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
		    'selectflag',
		    'dsprowid',
		    'packflag',
	    	'omflag'
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
		forceFit:true,
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
                                FindReqPrtDetail();
                            }
                        }
                    }
        })
        

   
     var DatePanel = new Ext.Panel({
     	 title:'配液瓶签',
         frame : true,
         margins:'1 0 0 0', 
         bbar:[RefreshButton,"-",PrtButton],
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
								items : [ AutoPrtChkbox  ]
								
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
		
	///////////////////////以下是Events//////////////////
		
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

	  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid ;
	  	    
	  	    return listinputstr
	  }		

			
	function FindReqPrtDetail()
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
                ClearDocument();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindReqPrtDetail&RegNo='+RegNo+"&Input="+input });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
				         
				         waitMask.hide();
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				                     else{
						               
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
					      var mprescno =record.data.prescnoT ;
						 
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
							  	     
							  	     if ((newmoeori==moeori)||(newprescno==mprescno)){
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
							  	     var newprescno =record.data.prescnoT ;
							  	     
							  	     if ((newmoeori==moeori)||(newprescno==mprescno)){
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
  
///保存瓶签  
function SavePrtData()
{
	var pogidstr="" ;
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
		var selectflag =record.data.selectflag;
		var dsprowid =record.data.dsprowid;
		if (selectflag!=""){
			if (h==1)
			{	
				var dspstr="";
			}else{
				m=m+1;
				var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "SavePrtLabelData",printno,dspstr,user,m)
				if (ret.indexOf("^")>=0){
					var tmparr=ret.split("^");
					var rowid=tmparr[0];
					var printno=tmparr[1];
					//组织打印ID串
					if (pogidstr==""){
						pogidstr=rowid ;
					}else{
						pogidstr=pogidstr+"^"+rowid ;
						}
				}
				var dspstr="" ; 
				}
		}   

		if (dspstr==""){
			dspstr=dsprowid ;
		}else{
			dspstr=dspstr+","+dsprowid ;
		}                     
	}

	if (dspstr!="") {
		m=m+1;
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "SavePrtLabelData",printno,dspstr,user,m)
		if (ret.indexOf("^")>=0){
			var tmparr=ret.split("^");
			var rowid=tmparr[0];
			var printno=tmparr[1];
			//组织打印ID串
			if (pogidstr==""){
				pogidstr=rowid ;
			}else{
				pogidstr=pogidstr+"^"+rowid ;
			}
		}
	}
	///打印
	if (pogidstr!=""){PrintClick(pogidstr)};
	///刷新
	FindReqPrtDetail(); 
}	

//保存数据
function SaveData(dspstr,user)
{
	var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "SavePrtLabelData",printno,dspstr,user);
	return ret;
}
   
//自动打印
function AutoPrintLabel()
{
	var input=GetListInput();
	ClearDocument();
	var user=session['LOGON.USERID'] ;   
	var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL","AutoFindPrtLabelData",input,user);	

	if (ret!="")
	{
		PrintClick(ret);
	}


}
	
var task_RealTimeMointor = {
	run : AutoPrintLabel  ,//执行任务时执行的函数
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
  
//清除
function ClearDocument()
{
	orddetailgridds.removeAll();
	document.getElementById("TDSelectOrdItm").checked=false;  

}
    
   //操作打印
  function PrintClick(pogstr)
  {

	 var tmparr=pogstr.split("^");
         var cnt=tmparr.length;
         for (i=0;i<cnt;i++){
         	var pogid=tmparr[i];
         	PrintLabel(pogid);  //打印瓶签
             
         }
         
         //打印清单
         var startNo=2;
         var prtpath=GetPrintPath();
   	     var Template=prtpath+"DHCST_PIVAOUT_PRTDETAIL.xls";
         var xlApp = new ActiveXObject("Excel.Application");		
         var xlBook = xlApp.Workbooks.Add(Template);
         var xlsheet = xlBook.ActiveSheet ;
         xlsheet.Cells(1, 1).Value ="配药清单";
         xlsheet.Cells(2, 1).Value =""//
         var h=0;
         
         var cnt=tmparr.length;
         for (i=0;i<cnt;i++){
         	var pogid=tmparr[i];
         	var pogistr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintDetail",pogid)
       		var tmparritm=pogistr.split("||");
       		var cntitm=tmparritm.length;
       		for (k=0;k<cntitm;k++){
       			
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
                       	  
                       	  if (k==0){                      	  	
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
  
  //打印瓶签
  function PrintLabel(pogid)
  {
  	
  	var Bar=new ActiveXObject("PIVAOutPrint.PIVALabel");
	if (!Bar) return ;
  	var pogstr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPog",pogid)
	if (pogstr==""){
		alert("取瓶签病人数据发生错误");
		return ;
	}
	var pogistr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPogItm",pogid)
	if (pogistr==""){
		alert("取瓶签药品数据发生错误");
		return ;
	}
	var stype="" ;
	
	Bar.Device="PIVA";
	Bar.PageWidth=130;
	Bar.PageHeight=160;
	Bar.HeadFontSize=12;
	Bar.FontSize=10;
	Bar.Title="输液单";
	Bar.HeadType=stype;
	Bar.IfPrintBar="true";
	Bar.BarFontSize=25;
	Bar.BarTop=60;
	Bar.BarLeftMarg=5;
	Bar.PageSpaceItm=2;	
	Bar.ItmFontSize=10;
	Bar.ItmCharNums=30; //药名每行显示的字符数
	Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
	Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
	Bar.PageItmStr=pogistr;	// 打印标签药品信息
	Bar.PageLeftMargine=1;
	Bar.PageSpace = 1;
	Bar.BarWidth=24;
	Bar.BarHeight=8;
	Bar.PrintDPage();
	return true;
  		
  }
  			
});