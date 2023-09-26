///门诊配液配药申请JS
///Creator:LiangQiang
///CreatDate:2013-05-21
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;
var InputStr;

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



Ext.onReady(function() {

   Ext.QuickTips.init();// 浮动信息提示
   Ext.Ajax.timeout = 900000;

   
   
    //开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                
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
				  width : 120,
				  listWidth:250,
				  emptyText:'选择药房科室...',
		          allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	

	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
 	 //留观科室控件
	
	var EmAreaInfo = new Ext.data.Store({
		autoLoad: false,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['locdesc','rowId'])
				
	});
	
	EmAreaInfo.on(
		'beforeload',
		function(ds, o){
		    //var grpdr=session['LOGON.GROUPID'] ;
			//ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		
		}
	);
	
	 
	 
	 var EmAreaSelecter = new Ext.form.ComboBox({
				  id:'EmAreaSelecter',
				  fieldLabel:'留观室',
				  store: EmAreaInfo,
				  valueField:'rowId',
				  displayField:'locdesc',
				  width : 120,
				  listWidth:250,
				  emptyText:'选择留观科室...',
		          allowBlank: true,
				  name:'EmAreaSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	
	
  	   //刷新
   var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '查询',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindPatList("1");
                              
                              }   
             }
             
             
   })
  
   
   	   //读卡
   var  ReadCardButton = new Ext.Button({
             width : 70,
             id:"ReadCardBtn",
             text: '读卡',
             icon:"../scripts/dhcpha/img/menuopera.gif",
             listeners:{
                          "click":function(){   
                             
                                 BtnReadCardHandler();
                              
                              }   
             }
             
             
   })


  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '申请',
             icon:"../scripts/dhcpha/img/accept.png",
             listeners:{
                          "click":function(){   
                             
                              SaveRequest();
                              
                              }   
             }
             
             
             })
             

    
    var RevokeButton = new Ext.Button({
             width : 65,
             id:"RevokeBtn",
             text: '撤消',
             icon:"../scripts/dhcpha/img/cancel.png",
             listeners:{
                          "click":function(){   
                             
                              //DaTongPrescAnalyse();
                              
                              }   
             }
             
             
    })
    

        
    
   //已申请
   var OnlyReqChkbox=new Ext.form.Checkbox({
        
		boxLabel : '已申请',
		id : 'OnlyReqChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
    CardTypeStore = eval("(" + CardTypeArray + ')');
    
    var CardTypeDs= new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
				
			})
    
    var CardTypeComBo = new Ext.form.ComboBox({
			fieldLabel:'卡类型',
			width : 120,
			typeAhead : true,
			height : 100,
			//renderTo:'LocListDiv',
			triggerAction : 'all',
			store : CardTypeDs,
			mode : 'local',
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
		
    setDefaultCardType();
		
	//查找病人列表控件
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'patid',
	            'patname',
	            'patsex',
	            'patage',
	            'adm'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});

	  var patlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'登记号',dataIndex:'patid',width: 80,menuDisabled :'false'},
	        {header:'姓名',dataIndex:'patname',width: 60,menuDisabled :'false'},
	        {header:'性别',dataIndex:'patsex',width: 60,menuDisabled :'false'},
	        {header:'年龄',dataIndex:'patage',width: 60,menuDisabled :'false'},
	        {header:'adm',dataIndex:'adm',width: 60,menuDisabled :'false',hidden:true}
	        
	       
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
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	        bbar: patlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	
	    
		///就诊列表grid 单击行事件

	    patlistgrid.on('rowclick',function(grid,rowIndex,e){
	
	        var selectedRow = patlistst.data.items[rowIndex];
		    var RegNo = selectedRow.data["patid"];
            orddetailgridds.removeAll();
			FindOrdDetailData(RegNo);
	    }); 
	    
	    

   function packflagbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TPackz'+rowIndex+'" name="TPackz'+rowIndex+'"  value="'+re+'"  >';

   }  

   function selectbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';

   }
   
  
  function showUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
  }

    
  var sm = new Ext.grid.CheckboxSelectionModel();
  var orddetailgridcm = new Ext.grid.ColumnModel([

        {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        {header:'打包',width:40,menuDisabled:true,dataIndex:'packflag',renderer:packflagbox},
        {header:'用药日期',dataIndex:'orddate',width:120},
        {header:'处方号',dataIndex:'prescno',width:85,renderer:showUrl},
        {header:'药品名称',dataIndex:'incidesc',width:150},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:60},
        {header:'频次',dataIndex:'freq',width:40},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'用药疗程',dataIndex:'dura',width:60},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱备注',dataIndex:'remark',width:60},
        {header:'selectflag',dataIndex:'selectflag',hidden:true},
        {header:'申请人',dataIndex:'requser',width:60},
        {header:'申请日期',dataIndex:'reqdate',width:120},
        {header:'dsprowid',dataIndex:'dsprowid',width:60}
        

    
       ]);
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [

            'select',
            'packflag',
            'orddate',
            'prescno',
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
		    'requser',
		    'reqdate',
		    'dsprowid'
	    
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
 
 
 var orddetailgrid = new Ext.grid.EditorGridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'0 0 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        tbar:[OkButton],
        clicksToEdit: 1,
        //plugins: PackFlagChkColumn,
        trackMouseOver:'true',
		listeners : {
		     'afteredit' : function(e) {
		      //alert(e.record.data.packflag)
		      //alert(e.getTarget())
		     	//alert(e.field)
		     	

		     }
		}


        

        
    });
	
   orddetailgrid.on('cellclick',OrddetailGridCellClick) 
   
   
   orddetailgrid.on('headerclick', function(grid, columnIndex, e) { 
	
   	     
         if (columnIndex==0){
         	selectAllRows();
         };
     
	
	});
	
  
     //病人登记号查询工具

	
	var patientField=new Ext.form.TextField({
  
        width:120, 
        id:"patientTxt", 
        fieldLabel:"登记号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                FindPatInfo();
                            }
                        }
                    }
        })
        

   
     var datePanel = new Ext.Panel({
         frame : true,
         bbar:[RefreshButton,'-',ReadCardButton],
         labelWidth:80,
         buttonAlign:'center',
         items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : 1,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 } ]
	   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   stdatef ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   enddatef ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   EmAreaSelecter ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   patientField ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [ CardTypeComBo  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [ OnlyReqChkbox   ]
									 }]
					  }]

      
   })
    

         
     var westPanel = new Ext.Panel({  
         title: '配药申请',
         region:'west',
         collapsible: true,
         margins:'0 3 0 0',
         width:300,
         frame : true,
         layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
         },
	 items: [{         
	 	  flex: 3,
	 	  layout:'fit',
	 	  items:[datePanel]  
	 	 },{   
	 	  flex: 5 ,
	 	  layout:'fit',
	 	  items:[patlistgrid]    
	       }]  
     });   
   
    ////
    
     var centerPanel = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame : false,
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 1,
         	  layout:'border',
         	  items:[orddetailgrid]  
         	 }]

	    
	});
	
  

      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,centerPanel]

			});
			
  ///////  Event      ///////////////////////

    //设置默认科室
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
                PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
        }

	}
	
	//设置默认卡类型
	function setDefaultCardType()
	{
		if (CardTypeDs.getTotalCount() > 0){
                CardTypeComBo.setValue(CardTypeDs.getAt(0).data.value);
        }

	}
		
	//取卡类型
	function GetCardTypeRowId() 
	{
		var CardTypeRowId = "";
		var CardTypeValue = CardTypeComBo.getValue();
		
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			CardTypeRowId = CardTypeArr[0];
		}
		return CardTypeRowId;
    }
	//读卡
   function BtnReadCardHandler()
   {
		var CardTypeRowId = GetCardTypeRowId();
		var myoptval = CardTypeComBo.getValue();
		var myrtn;
		//if(CardTypeComBo.getRawValue()=="就诊卡"){
		//myrtn=DHCACC_GetAccInfo("","")
		//}
		//else{
		myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
		//}
		
		if (myrtn==-200){ //卡无效
				Ext.Msg.show({title:'错误',msg:'卡无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
		}
	
		var myary = myrtn.split("^");
		var rtn = myary[0];
		
		switch (rtn) {
		case "0":
			//卡有效
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			Ext.getCmp('patientTxt').setValue(PatientNo);
		    FindWardList();
			break;
		case "-200":
			//卡无效
			Ext.Msg.show({title:'错误',msg:'卡无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			break;
		case "-201":
			//现金
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
	        Ext.getCmp('patientTxt').setValue(PatientNo);
		    FindWardList();
			break;
		 default:
	 
	}
	
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
	
	
	///清屏
	function ClearWindow()
	{
			orddetailgridds.removeAll();
			patlistst.removeAll();
	
	}
	
	//查询病人信息
   function FindPatInfo()
	{
		 ClearWindow();
         var RegNo=Ext.getCmp('patientTxt').getValue();
         var RegNo=GetWholePatID(RegNo);
          
         waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据,请稍候..." }); 
	     waitMask.show();          
		 patlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetPatInfo&RegNo='+RegNo  });		
						patlistst.load({
						params:{start:0, limit:200},
						callback: function(r, options, success){
		 
				        waitMask.hide();
				        if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                              }else{
		                              	    if(r.length>0){ //判断是否有数据

                                                          Ext.getCmp("patlisttbl").getSelectionModel().selectRow(0);//选中第一行
                                                          //orddetailgrid.getView().focusRow(0);//获取焦点
	                                                      //var currow = patlistgrid.getSelectionModel().getSelected();
		                                                  //var prescno=currow.get("prescno") ;
                                                          //FindOrdDetailData(prescno); 
                                                    }
		                              }
						}
		     
		
		   });
		   
		   
		   
	}
	
	 //返回左边列表选择条件
	  function GetListInput()
	  {
	  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
	        patid=Ext.getCmp('patientTxt').getValue();
	        onlyreq=Ext.getCmp('OnlyReqChk').getValue();
	
	  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+onlyreq ;
	  	    
	  	    return listinputstr
	  }
	
	  //查询病人列表
	  function FindPatList(inputflag)
	  {
		  	
		  	if (inputflag==1){
		  	   FindPatInfo();
		  	}
		  	if (inputflag==2){
		  	   //FindPatInfo();
		  	}
	  	
	  }
	  
	 
	function FindOrdDetailData(RegNo)
	{
		
		        var input=GetListInput();
		        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据,请稍候..." }); 
	            waitMask.show();  
                orddetailgridds.removeAll();
                document.getElementById("TDSelectOrdItm").checked=false;
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindOrdDetailData&RegNo='+RegNo+"&Input="+input });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
				         
				         waitMask.hide();
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !'+r.message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }

				         
				
				});
		   
	}
	 
	
	
	//列单击事件
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {
    
           
        //var selectobj=document.getElementById("TSelectz"+rowIndex); 
        //alert(rowIndex)
        //alert(columnIndex)
        //alert(selectobj)
        
        //document.getElementById("staffnos"+2).checked=true; 
        
        if (columnIndex==0){

		  	  var newmoeori="";
		      var record = orddetailgrid.getStore().getAt(rowIndex);
		  	  var moeori =record.data.selectflag ;
		      
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
				  	     
				  	     if (newmoeori==moeori){
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
				  	     
				  	     if (newmoeori==moeori){
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
		   
          if (columnIndex==1){
              SetPackFlag(rowIndex)
          }
          
  }

  
  
  	//打包事件
  function SetPackFlag(rowIndex)
  {

      var newmoeori="";
      var record = orddetailgrid.getStore().getAt(rowIndex);
  	  var moeori =record.data.selectflag ;
      
      var view = orddetailgrid.getView();
      var store = orddetailgrid.getStore();
      
      if (document.getElementById("TPackz"+rowIndex).checked)
      {
      	   for (i=0;i<=view.getRows().length-1;i++)    //i=1
      	   {
		       if(document.getElementById("TPackz"+i).checked){       
		          //rsm.deselectRow(i)  
		       }
		       else
		       { 
		         var record = orddetailgrid.getStore().getAt(i);
		  	     var newmoeori =record.data.selectflag ; 
		  	     
		  	     if (newmoeori==moeori){
		  	     	 document.getElementById("TPackz"+i).checked=true;
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
		       if(document.getElementById("TPackz"+i).checked){       
		         var record = orddetailgrid.getStore().getAt(i);
		  	     var newmoeori =record.data.selectflag ;
		  	     
		  	     if (newmoeori==moeori){
		  	     	 document.getElementById("TPackz"+i).checked=false;
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
  	       var rows=view.getRows().length-1 ;
  	       if (rows==0) return;
	       for (i=0;i<=rows;i++)
      	   {
      	   	   if (cellselected){
      	   	   	  document.getElementById("TSelectz"+i).checked=true;
      	   	   }else{
      	   	   	  document.getElementById("TSelectz"+i).checked=false;
      	   	   }
      	   	   

       
           }
  	
  }
  
	  
  function SaveRequest()
  {
  	       
  	       var view = orddetailgrid.getView();
  	       var rows=view.getRows().length-1 ;
  	       if (rows==-1) return;
	       for (i=0;i<=rows;i++)
      	       {
      	       	   var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   if (cellselected){
      	   	   	  var record = orddetailgrid.getStore().getAt(i);
                          var dsprowid =record.data.dsprowid ;
                          if (document.getElementById("TPackz"+i).checked){
                          	packflag="Y" ;
                          }else{
                                packflag="N" ;
                          }
                         
                          SaveData(i,dsprowid,packflag);
      	   	   	 
      	   	   }
       
          	}

	        
	        var selectedRow = patlistgrid.getSelectionModel().getSelected(); 
		var RegNo = selectedRow.data["patid"];
		FindOrdDetailData(RegNo);
   }



 function SaveData(i,dsprowid,packflag)
 {
 	        ///数据库交互
	        var requesr=session['LOGON.USERID'] ;

	        var ret=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "SaveRequest",dsprowid,packflag,requesr);
	        if  (ret>0){
	        	 //orddetailgrid.getStore().removeAt(i); 
	        }
	        else{
	                 Ext.Msg.alert("提示", "保存失败!返回值: "+ret);
	        }
	
  } 








});