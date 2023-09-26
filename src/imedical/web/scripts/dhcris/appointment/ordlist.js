/*
//接收科室
var recLocProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
}));

var recLocStore = new Ext.data.Store({
	proxy : recLocProxy,
	reader : new Ext.data.JsonReader({
		root:'record',
		totalProperty:'total',
		idProperty:'Group'
	},
	[
		{name:'LocDesc',mapping:'LocDesc'}
		,{name:'LocDr',mapping:'LocDr'}
		
	])
});


var recLocCmb = new Ext.form.ComboBox({
 	store:recLocStore,
 	displayField:'LocDesc',
 	//displayField:'LocDr',
 	//valueField:'LocDr',
 	valueField:'LocDesc',
    fieldLabel:'接收科室',
    typeAhead : true,
    forceSelection : true,
    anchor:'95%',
	triggerAction:'all',
	id:'recLocCmb',
	selectOnFocus : true,
	//forceSelection : true,
	//enable:false,
	listeners : {
            'beforequery':function(e){                 
                var combo = e.combo; 
                var selRow=combo.gridEditor.row;
                //alert(selRow);
                var arcItemdr=serviceOrderStore.getAt(selRow).data.arcItmDr;
                var orderDr=serviceOrderStore.getAt(selRow).data.oeOrdDr;
                //alert(orderDr);
                //alert(appointmentInfo.Session.user_locid);
			 	recLocProxy.on('beforeload',function(objProxy,param){
				 	param.ClassName='web.DHCRisResApptSchudleSystem';
					param.QueryName='QueryOrdRecLoc';
					param.Arg1 = orderDr;
					param.Arg2 = appointmentInfo.Session.user_locid;
					//alert(param.Arg1);
					param.ArgCnt = 2;	
			 	});
			
			 	recLocStore.load();
               
            },
            'select':function(e){
           	
            	var selRow=e.gridEditor.row;
                
            	var selRecLocDr=recLocStore.getAt(e.selectedIndex).data.LocDr;
                var locDr=serviceOrderStore.getAt(selRow).data.recLocDr;
                
				if ( locDr!=selRecLocDr)
				{
					//alert("start change rec loc");
					var orderDr=serviceOrderStore.getAt(selRow).data.oeOrdDr;					
					var ret = tkMakeServerCall("web.DHCDocOrderCommon","ChangeOrderRecDep",orderDr,selRecLocDr);
					if (ret=="0")
					{	
						//alert("1");					
						serviceOrderStore.getAt(selRow).data.recLocDr=selRecLocDr;
						//resourcePanel.removeAll();
						//serviceOrderStore.load();
						serviceOrderGrid.getSelectionModel().selectRow(selRow);
						initDateArray();
						addExamItem();
					}
					else
					{
						serviceOrderStore.getAt(selRow).data.recLocDr=locDr;
					}
				}
            }
         
        }
 });
 */
////////////

var serviceOrderStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	
//查询医嘱信息
serviceOrderStoreProxy.on('beforeload',serviceOrderProxyBeforeload);
	
//serviceOrderStore.on('load',serviceOrderStoreload);

function serviceOrderProxyBeforeload(objProxy,param){
	
	//alert(adm1);
	param.ClassName='web.DHCRisResApptSchudleSystem';
	param.QueryName='QuerySerOrder';
	param.Arg1 = admSchedule;
	param.Arg2 = '';
	param.Arg3 = '';  //Ext.getCmp("regNoFind").getValue();
	param.Arg4 = '' ;//Ext.getCmp("allEpisode").getValue();
	param.ArgCnt = 4;
};


var serviceOrderRecord=new Ext.data.Record.create([
		    {name:'isPrint',type: 'bool'},  //, value:false,mapping:''},  //,type: 'bool'
			//{name:'checked',mapping:''},//mapping:'checked'}
			{name:'hasOccupy',mapping:''},
			{name:'resourceInfo',mapping:''},
			{name:'checkboxId',mapping:''},
			{name:'rapidcheckboxId',mapping:''},
			{name:'oeOrdDr',mapping:'ExamOrder'},
			{name:'BillDesc',mapping:'BillDesc'},
			{name:'OrderName',mapping:'OrderName'},
			{name:'arcItmDr',mapping:'ArcItmId'},   //mapping:'',
			{name:'scheduleDr',mapping:'SchRowid'},
			{name:'appointFlag',mapping:'BookTypeFlag'},
			{name:'AppDocDesc',mapping:'AppDocDesc'},
			{name:'status',mapping:'Status'},
			{name:'orderDate',mapping:'datestr'},
			{name:'orderTime',mapping:'timestr'},
			{name:'bookRes',mapping:'BookRes'},
			{name:'bookDate',mapping:'BookDate'},
			{name:'bookTime',mapping:'BookTime'},
			{name:'recLoc',mapping:'LocDesc'},
			{name:'recLocDr',mapping:'RecLocDR'},
			{name:'BodyDr',mapping:'BodyDr'} ,
			{name:'BookNo',mapping:'BookNo'} ,
			{name:'StudyNo',mapping:'StudyNo'} ,
			{name:'AppNo',mapping:'AppNo'},
			{name:'BookTypeDesc',mapping:'BookTypeDesc'}
			//{name:'IsMydriasis',mapping:'IsMydriasis'},
			//{name:'SendReportTime',mapping:'SendReportTime'},
			//{name:'UseBookResInfo',mapping:'UseBookResInfo'},
		]);


var serviceOrderStore = new Ext.data.GroupingStore({   //new Ext.data.Store({
		proxy : serviceOrderStoreProxy,
		reader : new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty:'Group'
		},serviceOrderRecord)
		/*,
		groupField:'status',
		sortInfo:{field:'orderDate',direction:'ASC'},
		listeners:{
			'beforeload':function(){
				loading = new Ext.LoadMask(Ext.get(this.getEl()),{
	              msg : 'Loading...',
	              removeMask : true// 完成后移除
	            });            
	            loading.show();
			},
			'load':function(){
				loading.hide();
			}
		}
		*/
});
	


var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:false,checkOnly:true});
//var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
//var sm = new Ext.grid.CheckboxSelectionModel({
//  handleMouseDown:Ext.emtyFn
//  });



var checkColumnPrint = new Ext.grid.CheckColumn({
       header: '是否打印',
       dataIndex: 'isPrint',
       width: 70
    });


var colModel = new Ext.grid.ColumnModel({
			columns : [
			new Ext.grid.RowNumberer(),
			//{header:'选择',width:100,dataIndex:'checked'},
			//sm ,
			//checkColumnPrint,
			{header:'收费状态',width:80,dataIndex:'BillDesc'},
			{header:'医嘱名称',width:150,dataIndex:'OrderName'},
			{header:'预约方式',width:120,dataIndex:'BookTypeDesc'},
			{header:'申请医生',width:80,dataIndex:'AppDocDesc'},
			//{header:'可预约的最近日期',width:120,dataIndex:'UseBookResInfo'},
			{header:'状态',width:80,dataIndex:'status'},			
			{header:'预约日期',width:100,dataIndex:'bookDate',sortable:true},			
			{header:'预约时间',width:100,dataIndex:'bookTime',sortable:true//,
			//renderer:Ext.util.Format.dateRenderer('Y年m月d日'),
			//editor:new Ext.form.DateField({format:'Y年m月d日'})
			
			},
			{header:'预约资源',width:100,dataIndex:'bookRes',sortable:true},
			{
				header:'接收科室',width:200,dataIndex:'recLoc'
				//,type: recLocCmb
				//allowBlank : false,
				//editor:recLocCmb
			},
			//{header:'是否预占资源',width:100,dataIndex:'hasOccupy'},
			//{header:'预占资源信息',width:150,dataIndex:'resourceInfo'},
			//{header:'是否散瞳',width:80,dataIndex:'IsMydriasis'},
			//{header:'发报告时间',width:80,dataIndex:'SendReportTime'},
			
			{header:'医嘱日期',width:100,dataIndex:'orderDate',sortable:true},
			{header:'医嘱时间',width:80,dataIndex:'orderTime',sortable:true},
			
			
			
			{header:'检查项目rowid',width:80,dataIndex:'arcItmDr'},
			//{header:'checkboxId',width:80,dataIndex:'checkboxId'},
			//{header:'rapidcheckboxId',width:80,dataIndex:'rapidcheckboxId'},
			{header:'医嘱Rowid',width:70,dataIndex:'oeOrdDr'},
			{header:'scheduleDr',width:80,dataIndex:'scheduleDr'},
			{header:'BodyDr',width:80,dataIndex:'BodyDr'},
			{header:'预约号',width:80,dataIndex:'BookNo'},
			{header:'检查号',width:80,dataIndex:'StudyNo'},
			{header:'申请单号',width:80,dataIndex:'AppNo'}
				
			]
		});
var serviceOrderGrid = new Ext.grid.EditorGridPanel({     //EditorGridPanel({  //GridPanel({
		id:'serviceOrderGrid',
		store:serviceOrderStore,
		//title:'医嘱列表',
		layout:"fit",
		//layout:'anchor',
		//height:312,
		//anchor:'95%',
		anchor: '100% 99%',
		sm:sm,
		//sm:checkColumnPrint,
		cm : colModel,
		//bodyStyle: 'background:#ffc; padding:10px;',
		style:'border: 1px solid #8db2e3;',
		//loadMask:true,
		clickToEdit:2,
		plugins: checkColumnPrint,
		clicksToEdit : 1,
		columns:[
		/*
			new Ext.grid.RowNumberer(),
			//{header:'选择',width:100,dataIndex:'checked'},
			//sm ,
			{header:'医嘱Rowid',width:70,dataIndex:'oeOrdDr'},
			{header:'医嘱名称',width:150,dataIndex:'OrderName'},
			{header:'医嘱日期',width:100,dataIndex:'orderDate',sortable:true},
			{header:'医嘱时间',width:0,dataIndex:'orderTime',sortable:true},
			{header:'状态',width:80,dataIndex:'status'},
			{header:'预约日期',width:100,dataIndex:'bookDate',sortable:true},
			{header:'预约时间',width:100,dataIndex:'bookTime',sortable:true},
			{header:'预约资源',width:100,dataIndex:'bookRes',sortable:true},
			{header:'是否预占资源',width:100,dataIndex:'hasOccupy'},
			{header:'预占资源信息',width:150,dataIndex:'resourceInfo'},
			{header:'检查项目rowid',width:80,dataIndex:'arcItmDr'
				,type: recLocCmb
			},
			{header:'checkboxId',width:80,dataIndex:'checkboxId'},
			{header:'rapidcheckboxId',width:80,dataIndex:'rapidcheckboxId'},
			{header:'scheduleDr',width:80,dataIndex:'scheduleDr'},
			{header:'预约标志',width:50,dataIndex:'appointFlag'}
			
			*/
		],
		tbar:[
			{
				width:300,
				 bodyStyle: 'background:#d4e1f2;border:0;',
         		xtype:'panel'  
			},
			{
				text:"",     //new Date().format('Y年m月d日 H时i分s秒'),//这样就可以
				xtype:'tbtext',
				id:'patInfo',
				width:330,
				//style:'color:#333333'
				style:'font-size:15px;'
				
			}
			/*,
			{
				xtype:'textfield',
				id:'regNoFind',
				width:150,
				fieldLabel:'登记号',
				//blankText:'请输入登记号',
				emptyText:'请输入登记号'
			},	
			{
				xtype:'panel',
				width:10,
				bodyStyle: 'background:#d4e1f2;border:0;'
			}	,
			{
				xtype:'button',
				id:'btnReadCard',
				text:'读卡查询',
				//anchor:'95%',
				width:60
			},
			{
				xtype:'panel',
				width:50,
				bodyStyle: 'background:#d4e1f2;border:0;'
			}	,
			{ 							
					xtype:'checkbox',
					id:'allEpisode',
					boxLabel:'全部就诊',
					width:60,
					style:'vertical-align:middle;',
					labelStyle:'vertical-align:middle;'			
			},
			{
				xtype:'panel',
				width:10,
				bodyStyle: 'background:#d4e1f2;border:0;'
			}	,
			{
				xtype:'button',
				id:'btnFindOrder',
				text:'查询',
				//anchor:'95%',
				width:60
			}*/
		],
		bbar:[
			{
				width:350,
				 bodyStyle: 'background:#d4e1f2;border:0;',
            	xtype:'panel'  
			},
			/*
			{
				xtype:'button',
				id:'btnIntelligentAppoint',
				text:'优化预约',
				//anchor:'95%',
				width:60
			},
			{
				width:50,
				 bodyStyle: 'background:#d4e1f2;border:0;',
            	xtype:'panel'  
			},
			{
				xtype:'button',
				id:'batnAppoint',
				text:'自动预约',
				//anchor:'95%',
				width:60
			},
			{
				width:50,
				 bodyStyle: 'background:#d4e1f2;border:0;',
            	xtype:'panel'  
			},*/
			{
				xtype:'button',
				id:'btnAppoint',
				text:'预约',
				//anchor:'95%',
				width:60
			},
			{
				width:50, 
				 bodyStyle: 'background:#d4e1f2;border:0;',
            	xtype:'panel'  
			},
			{
				xtype:'button',
				id:'btnCancelAppoint',
				text:'取消预约',
				//anchor:'95%',
				width:60
			},
			{
				width:50, 
				 bodyStyle: 'background:#d4e1f2;border:0;',
            	xtype:'panel'  
			},
			{
				xtype:'button',
				id:'btnRefresh',
				text:'刷新',
				//anchor:'95%',
				width:60
			},
			{
				width:50,
				 bodyStyle: 'background:#d4e1f2;border:0;',
            	xtype:'panel'  
			},
			{
				xtype:'button',
				id:'btnPrint',
				text:'打印预约单',
				//anchor:'95%',
				width:60
			}
		
		],
		items:[],
		listeners:{	
	         render:function(){
	         var hd_checker = this.getEl().select('div.x-grid3-hd-checker');
	         if (hd_checker.hasClass('x-grid3-hd-checker')) {  
	                hd_checker.removeClass('x-grid3-hd-checker'); // 去掉全选框 
	            } 
	         }         
		}
		/*,
		view: new Ext.grid.GroupingView({
        	groupTextTpl: '({[values.rs.length]}条记录:{[values.rs[0].data["status"]==""?"未发送申请单":values.rs[0].data["status"]]})'
    	})
		*/
});

//Ext.getCmp('btnCancelAppoint').setDisabled(true);

var pnButton = new Ext.Panel({
	//layout:'column'
	border:false,
	labelAlign:'center',
	bodyStyle: 'padding:10 20;',
	defaults:{margins:'0 10 0 0'},
	layout: {
                type:'hbox',
                padding:'5',
                pack:'center',
                align:'center'     
            },
	items:[
	/*
			{
				xtype:'button',
				id:'btnAppoint',
				text:'预约',
				//anchor:'95%',
				width:60
			},
			{
				xtype:'button',
				id:'btnCancelAppoint',
				text:'取消预约',
				//anchor:'95%',
				width:60
			},
			{
				width:200,
				border:false
			},
			{
				xtype:'button',
				id:'btnRefresh',
				text:'刷新',
				//anchor:'95%',
				width:60
			}
			*/
	]

});


var orderListRegion = new Ext.FormPanel({
	//title:"医嘱列表",
	region:'north',
	height:315,
	layout: 'anchor',
	//collapsible:true,
	//split:true,
	frame:false,
	autoScroll:true,
	items:[
		serviceOrderGrid  //,
		//pnButton
	]
});

//Ext.getCmp('batnAppoint').on('click',bookappointClick);
Ext.getCmp('btnAppoint').on('click',appointClick);
Ext.getCmp('btnCancelAppoint').on('click',cancelAppointClick);
Ext.getCmp('btnRefresh').on('click',refreshClick);

Ext.getCmp('btnPrint').on('click',clickPrint);

//Ext.getCmp('btnIntelligentAppoint').on('click',intelligentAppoint);

//Ext.getCmp('btnReadCard').on('click',clickReadcard);

//Ext.getCmp('btnFindOrder').on('click',clickFindOrder);

serviceOrderGrid.on('cellclick', clickOrderListCell);

serviceOrderGrid.on('rowclick', clickOrderList);
//serviceOrderGrid.on('rowdblclick', dbClickOrderList);


function clickFindOrder()
{
		if (Ext.getCmp('regNoFind').getValue()!="")
		{
			var admInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","getPatientInfo",Ext.getCmp('regNoFind').getValue());
		
			var adminfoList=admInfo.split('^');
			if (adminfoList.length>=3)
			{
				var patInfo="患者信息 : &nbsp;"+adminfoList[1]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[0]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[2];
				//alert(Ext.getCmp("patInfo").text);
				//alert(patInfo);
				Ext.getCmp("patInfo").setText(patInfo);
			}
			admSchedule="";
			resourcePanel.removeAll();
			serviceOrderStore.load();
		}
		else
		{
			admSchedule="";
			Ext.getCmp("patInfo").setText("");
			alert("请先输入登记号!!!");
			resourcePanel.removeAll();
			serviceOrderStore.load();
			
		}
}



//读京医通卡  nk new add
function ReadJYTCard_OnClick(){
    var ReadJYTCardInfo=GetPersonInfo();
    //alert("qqqq+"+ReadJYTCardInfo)
    var myArr=ReadJYTCardInfo.split("^");
    if (myArr[0]!="Y"){alert(myArr[3]);return;}      //读京医通卡失败
    var JYTCardNo=myArr[4];
    var obj=document.getElementById("CardNo");
    if(obj)obj.value=JYTCardNo;
    var CardNo=DHCC_GetElementData("CardNo");
    //alert(CardNo)
    //CardNo=FormatCardNo();
    if (CardNo=="") return;
    var obj=document.getElementById("CardNo");
    //alert(m_SelectCardTypeDR)
    //alert(CardNo)
    var myrtn=DHCACC_GetAccInfo(4,CardNo,"0","PatInfo");
    //alert(myrtn)
    var myary=myrtn.split("^");
    alert(myary);
    var rtn=myary[0];
    switch (rtn){
        case "-200": //卡无效
            alert("卡无效");
            //document.getElementById('RegNo').value=""
            break;
        default:
            //document.getElementById('RegNo').value=myary[5]
            //document.getElementById('CardNo').value=CardNo
            //alert(myary[5])
            //return Find_click()
            //GetPatientInfo();
            //FindClickHandler(); 
            break;
    }
    
}


function clickReadcard()
{
	//Ext.getCmp('regNoFind').setValue('0000000043');
	
	var defaultCardType="";
	var m_SelectCardTypeDR="";
	var CardTypeStore = eval("(" + CardTypeArray + ')');
	var defaultCardType;
	
	for (var i = 0; i < CardTypeStore.length; i++) {
		if (CardTypeStore[i][0] == "注册医疗卡") {
			defaultCardType = CardTypeStore[i][1];
			m_SelectCardTypeDR=defaultCardType.split("^")[0];
		}	
	}
	
	//var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,defaultCardType);
	
	var rtn="-200",ErrorMsg="";
	var patInfo=JYDReadYBCard();
	
    var ybCardInfo=patInfo.split("^");
    if(ybCardInfo[0]==0){
      var CardNo=ybCardInfo[3];
      var m_SelectCardTypeDR=2;
      var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR, CardNo, "","PatInfo");
      var myary=String(myrtn).split("^");
      rtn=myary[0];
    }else{
      var ReadJYTCardInfo=GetPersonInfo();
      var myArr=ReadJYTCardInfo.split("^");
      if (myArr[0]!="Y") {
	    rtn="-200";
    	ErrorMsg=myArr[3];
      }else{
    	var JYTCardNo=myArr[4];
    	var CardNo=JYTCardNo;
	  	var myrtn=DHCACC_GetAccInfo(4,CardNo,"","PatInfo");
	    var myary=myrtn.split("^");
	    var rtn=myary[0];
      }
    }
   if (rtn=="-200") {
	  //var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	  var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,defaultCardType);
	  //alert(CardInform);
	  var myary=String(CardInform).split("^");
	  var CardNo=myary[1];
	  var rtn=myary[0];
	  if (rtn==-1) rtn="-200";
	}
  //if (ErrorMsg!="") ErrorMsg=ErrorMsg;
  switch (rtn){
      case "-200":
          if(ErrorMsg=="") {alert("请确认已插好卡");}
          else {alert(ErrorMsg);}
          break;
      default:
      	  //DHCC_SetElementData("PatientNo",myary[5]);
          //DHCC_SetElementData("CardNo",CardNo);
		  	Ext.getCmp('regNoFind').setValue(myary[5]);
          break;
  }
     
	
	//更新患者信息
	
	if (Ext.getCmp('regNoFind').getValue()!="")
	{
		var admInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","getPatientInfo",Ext.getCmp('regNoFind').getValue());
	
		var adminfoList=admInfo.split('^');
		if (adminfoList.length>=3)
		{
			var patInfo="患者信息 : &nbsp;"+adminfoList[1]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[0]+" &nbsp;&nbsp;&nbsp;&nbsp;  "+adminfoList[2];
			//alert(Ext.getCmp("patInfo").text);
			//alert(patInfo);
			Ext.getCmp("patInfo").setText(patInfo);
		}
	}
	else
		Ext.getCmp("patInfo").setText("");

	admSchedule="";
	resourcePanel.removeAll();
	serviceOrderStore.load();
}

//var g_arcItmDr='10277||1';
function clickOrderList(grid, rowIndex, columnIndex, e) 
{
	//alert("clickOrderList");
	//var recLoc=serviceOrderStore.getAt(rowIndex).data.recLoc;
	//alert(recLoc);
	
	
	//initDateArray();
	//addExamItem();	
	
/*	
	switch(selRecord[0].data.appointFlag )
	{
		case '':
		case 'B':
			initDateArray();
	    	modalityStore.load();
	    	break;
	    case 'A':
			//调用自动预约方法
	    	resourcePanel.removeAll();
	    	//已经预占资源，退出
	    	if (selRecord[0].data.hasOccupy == "Y")
			{
				//alert("1");
				return;
			}
			Ext.Ajax.request({
				url:appointmentInfo.URL.AutoSchedule,
				params:{
					paadmDr:adm,
					arcItmDr:selRecord[0].data.arcItmDr,
					arcItmDesc:selRecord[0].data.OrderName,
					oeOrdDr:selRecord[0].data.oeOrdDr,
					modDr:''
				},
				method:'GET',
				success:function(response,options){
					var result=response.responseText;
					result=result.replace("\r\n","");
					//alert(result);
					//成功则插入列表
					switch(result)
					{
						case "-0001":
						case "-0002":
						case "-0003":
						case "-0004":
						case "-0005":
							alert("自动预约失败！code="+result);
							//Ext.getCmp(options.params.arcItmDr).setValue(false);
							break;
						default:
							var ret = result.split("^");
							if( ret.length == 5)
							{
								//修改列表信息，增加单选框
								var info=ret[4]+" : "+ret[2]+" "+ret[1];
								var index = serviceOrderGrid.getStore().find("oeOrdDr",options.params.oeOrdDr);
								if ( index >= 0)
								{
									serviceOrderGrid.getStore().getAt(index).set("hasOccupy","Y");
									serviceOrderGrid.getStore().getAt(index).set('resourceInfo',info);
									//serviceOrderGrid.getStore().getAt(index).set('checkboxId',options.params.id);
									serviceOrderGrid.getStore().getAt(index).set('scheduleDr',ret[0]);
								}
								/*var checkboxPanel = new Ext.Panel({
							    	bodyStyle:'padding:0,0,20,20;',
							    	items:[]    	
							    });
						    	
							    var checkboxItem = new Ext.form.Checkbox({
									boxLabel: examItemStore.getAt(i).get('desc')+"  "+"自动预约",
									name: arcItmDr+"^"+flag,
									id:arcItmDr,
									checked:( (examListView.store.find('arcItmDr',arcItmDr) >= 0)?true:false),
									//disabled :true,
									inputValue:arcItmDr
								});
								checkboxItem.on('check',checkAutoScheduleItem);
						    	//checkGroup.on('expand',expandExamItem);
							    //Ext.getCmp(arcItmDr).on()
						    	resourcePanel.add(checkboxPanel);
						    	checkboxPanel.add(checkboxItem);
						    	resourcePanel.doLayout();
						    	*   /
							}
							else
							{
								//失败则提示并自动取消选择
								alert("没有预约资源！code="+result);
								//jsSet = true;
								//Ext.getCmp(options.params.arcItmDr).setValue(false);
							}				
					}
					
					
				}
			});
		    	
		    initDateArray();
	    	modalityStore.load();
	    	//自动预约
	    	break;
	    case 'N':
	    	alert('此检查不需要预约!');
	    	break;
	    default:
	    	break;			
	}
*/
}


function clickOrderListCell(grid, rowIndex, columnIndex, e)
{
	//var record = grid.getStore().getAt(rowIndex);   //Get the Record
    //var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
    //var data = record.get('TOeorditemdr');
	if (columnIndex==0)
	{
		//initOrdList(rowIndex);
		return;
	}
		
	if ( sm.isSelected(rowIndex) )
    	sm.deselectRow(rowIndex);
    else
    	sm.selectRow(rowIndex,true);
    	
    initOrdList(rowIndex);
    
    var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	//判断唯一选择一条记录
	if (  selRecord==null  ||selRecord.length < 1)
	{
		resourcePanel.removeAll();
		selScheduleId="";
		return;
	}
	
    initDateArray();
	addExamItem();
}


function initOrdList(rowIndex)
{	
	//alert(ordRowid);
	var studyNo = serviceOrderGrid.store.getAt(rowIndex).get('StudyNo');
	var bookNo = serviceOrderGrid.store.getAt(rowIndex).get('BookNo');
	var recLocRowid = serviceOrderGrid.store.getAt(rowIndex).get('recLocDr');
	var bookType = serviceOrderGrid.store.getAt(rowIndex).get('BookTypeDesc');
	
	
	//根据标志位判断是否允许分部位预约登记
	var orderItemRowid = serviceOrderGrid.store.getAt(rowIndex).get('oeOrdDr');
	var bodyDr=serviceOrderGrid.store.getAt(rowIndex).get('BodyDr');
	var divideFlag="";
	if (bodyDr!="")
	{
		divideFlag= tkMakeServerCall("web.DHCRisCommFunctionEx","getDivideFlag",orderItemRowid);
	}
	
	var allAutoBook="";
	if (divideFlag=="N")
	{
		//不允许分部位登记，查找医嘱rowid相同，部位不同的是否都是自动预约
		for (i=0;i<serviceOrderGrid.store.getCount();i++)
		{
			var queryListRecord = serviceOrderGrid.store.getAt(i);

			var orderRowidGet=queryListRecord.get('oeOrdDr');
			var bodyDrGet=queryListRecord.get('BodyDr');
			var bookTypeGet=queryListRecord.get('BookTypeDesc');
			if (orderRowidGet==orderItemRowid)
			{
				if (bookTypeGet!="自动预约")
				{
					allAutoBook="N";
				}
			}
			
		}
	}
	
	//alert(sm.isSelected(rowIndex));
	if ( sm.isSelected(rowIndex))  
	{
		//alert("1");	
		if (allAutoBook=="N")
		{
			sm.deselectRow(rowIndex);
			alert("不能分部位预约!");
			return;
		}
		if ( bookType != "自动预约")
		{
			//alert(bookType);
			sm.deselectRow(rowIndex);
			return;
		}
		for (i=0;i<serviceOrderGrid.store.getCount();i++)
		{
			var queryListRecord = serviceOrderGrid.store.getAt(i);
			
			var studyNoGet=queryListRecord.get('StudyNo');
			var bookNoGet=queryListRecord.get('BookNo');
			var recLocRowidGet=queryListRecord.get('recLocDr');
			var bookTypeDescGet=queryListRecord.get('BookTypeDesc');
			var orderItemRowidGet=queryListRecord.get('oeOrdDr');
			
				if ( recLocRowidGet!=recLocRowid)  //不同接收科室不能一起选中
				{
					sm.deselectRow(i);
					continue;
				}
				else
				{
					if (studyNo=="")     //勾选的记录没有登记
					{
						//判断是否预约
						if(bookNo=="")   //勾选的记录没有预约
						{
							//轮询记录已经预约或登记，则不能选择
							if (studyNoGet!="" || bookNoGet!="")
							{
								sm.deselectRow(i);
							}
							else  
							{							
								//sm.selectRow(i,true);
								//只自动勾选医嘱rowid相同的
								if (orderItemRowid==orderItemRowidGet)
								{
									sm.selectRow(i,true);
								}
								
							}
						}
						else   //勾选的记录已经预约
						{
							if ( (bookNo == bookNoGet)&&(studyNoGet==""))  //只有预约且预约号相同一起勾选
								sm.selectRow(i,true);
							else
								sm.deselectRow(i);
						}
				
					}
					else   //勾选的记录已经登记
					{
						if ( studyNoGet == studyNo)
							sm.selectRow(i,true);
						else
							sm.deselectRow(i);
					}

				}
				
				if ( bookTypeDescGet != "自动预约")
				{
					sm.deselectRow(i);
					continue;
				}
					
		}
	}
	else
	{
		//不允许分开登记的，一起取消选择
		if(divideFlag=="N")
		{
			for (i=0;i<serviceOrderGrid.store.getCount();i++)
			{
				var queryListRecord = serviceOrderGrid.store.getAt(i);

				var orderRowidGet=queryListRecord.get('oeOrdDr');
				if (orderRowidGet==orderItemRowid)
				{
					sm.deselectRow(i);
				}	
			}
		}
	}
	
}


function refreshClick()
{
	resourcePanel.removeAll();
	serviceOrderStore.load();
}

function appointClick()
{
	var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	//判断唯一选择一条记录
	if (  selRecord==null  ||selRecord.length < 1)
	{
		alert("请选择医嘱!");
		return;
	}
	
	var scheduleDr="";
	var arcItmDrList="";
	var orderArray={};
	var recLoc="";
	var status="";
	var shcduleDate="";
	var shcduleTime="";
	var shcduleIdOld="";
	for ( var i =0 ; i<selRecord.length; i++)
	{
  		
		if ( selRecord[i].data.status == "登记")
		{
			//alert("1");
			alert("已经登记,不能预约!");
			retrun;
		}
		
		if ( selRecord[i].data.status == "预约")
		{
			status="预约";
			shcduleDate=selRecord[i].data.bookDate;
			shcduleTime=selRecord[i].data.bookTime;
			shcduleIdOld=selRecord[i].data.scheduleDr;
		}	
		recLoc=selRecord[i].data.recLocDr;
		scheduleDr=selRecord[i].data.scheduleDr;
		
	    var arcItmDr = selRecord[i].data.arcItmDr;
	    if (arcItmDrList=="")
	    {
		    arcItmDrList=arcItmDr;
	    }
	    else
	    {
		    arcItmDrList=arcItmDrList+"@"+arcItmDr;
	    }
			
  		var OeorditemID=selRecord[i].data.oeOrdDr;
  		
	    var bodyCode=selRecord[i].data.BodyDr;
	    if ( orderArray[OeorditemID] == null)
	    {
	      orderArray[OeorditemID]=bodyCode;
	    }
	    else
	    {
	       orderArray[OeorditemID]=orderArray[OeorditemID]+","+bodyCode;
	    }
	}  	
	  	
	var orderBodyList="";
	for(var key in orderArray)
	{  
		//alert(key+"$"+orderArray[key]);
		var orderlist;
		if(orderArray[key]!="")
		{
			orderlist=key+"$"+orderArray[key];
		}
		else
		{
			orderlist=key;
		}
		if (orderBodyList=="")
		{
			orderBodyList=orderlist;
		}
		else
		{
			orderBodyList=orderBodyList+"@"+orderlist;
		}
		
		
	}
	
	//var oeordDr=selRecord[0].data.oeOrdDr;
	//var index = serviceOrderGrid.store.find('oeOrdDr',oeordDr);
	//alert(index);
	//return;
	
	/*
	var isBook = tkMakeServerCall("web.DHCRisResourceApptSchudle","isBookFromDoc",orderBodyList);
	if (isBook=="N")
	{
		alert("不允许诊间预约!");
		return;
	}
	*/
	
	if (scheduleDr=="")
	{
		alert("请选择资源!");
		return;
	}
	
	if ( status == "预约")
	{
		return;
		/*
		//alert("请先取消预约!");
		var infoHint="此医嘱已经预约到"+shcduleDate+" "+shcduleTime+",是否修改预约?";
		var r=confirm(infoHint);
		if (r == true)
		{
			//alert("转预约!");
			//var infoParam=oeOrdDr+"^"+scheduleDr+"^"+admSchedule+"^"+appointmentInfo.Session.user_rowid+"^"+appointmentInfo.Local.IpAddr;;
			var infoParam=orderBodyList+"^"+scheduleDr+"^"+"2"+"^"+ recLoc +"^"+appointmentInfo.Session.user_rowid+"^"+appointmentInfo.Local.IpAddr;
			
			var ret = tkMakeServerCall("web.DHCRisResApptSchudleSystem","ChangeBooked",infoParam);
			//alert(ret);
			if (ret==0)
			{
				alert("转预约成功!");
				changeScheduleInfo(oeOrdDr);
				
			}
			else
			{
				alert("预约失败! ret="+ret);
			}
		
		retrun;
		}
		*/
	}
	//var arcItmDr=serviceOrderGrid.getStore().getAt(index).get('arcItmDr');
	//判断是否有冲突
	var conflictInfo=tkMakeServerCall("web.DHCRisPlatBook","BookedConflict",orderBodyList,scheduleDr);
	//alert(conflictInfo);
	if (conflictInfo!="")
	{
		var conflictInfolist=conflictInfo.split("@");
		
		var hint="";
		for (var i=0;i<conflictInfolist.length ;i++ )
		{
			if ( conflictInfolist[i]!="")
			{
				var infoConfilct=conflictInfolist[i].split("^");
				
				//strOrderName_"^"_$zd(ordDate,3)_"^"_locDesc_"^"_strBookDate_"^"_strBookTime_"^"_resourceDesc
				var info=infoConfilct[0]+" ("+infoConfilct[1]+") 已经预约到 "+infoConfilct[3]+" "+infoConfilct[4];
				if (hint=="")
				{
					hint=info;
				}
				else
				{
					hint=hint+";\r\n"+info;
				}
				
			}
		}
		if (hint!="")
		{
			var ConflictFlag=confirm(hint+",\r\n是否继续预约?");
		    if (ConflictFlag==false){return}
		}
	}
	
	var infoParam=orderBodyList+"^"+scheduleDr+"^"+"2"+"^"+ recLoc +"^"+appointmentInfo.Session.user_rowid+"^"+appointmentInfo.Local.IpAddr;
	//appointmentInfo.Session.user_rowid;
	//alert(infoParam);
	var ret = tkMakeServerCall("web.DHCRisResApptSchudleSystem","Book",infoParam);
	//alert(ret);
	if (ret.split('^')[0]==0)
	{
		alert("预约成功!");
		changeScheduleInfo();
		var schCheckBox=Ext.getCmp(arcItmDrList+"^"+orderBodyList+"^"+scheduleDr);
		if ( schCheckBox)
		{		
			schCheckBox.disable();
			var divBox=schCheckBox.positionEl;
			divBox.removeClass('x-item-disabled');
			divBox.addClass('my-chechbox-disabled');

		}
		selScheduleId="";
		//printBookInfo(oeordDr)
		//serviceOrderStore.load();
		//resourcePanel.removeAll();
		clickPrint();
	}
	else
	{
		alert("预约失败! ret="+ret);
	}

	//刷新列表
	//serviceOrderStore.load();
}


function cancelAppointClick()
{
	//alert('取消预约');
	var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	//判断唯一选择一条记录
	if (  selRecord==null  ||selRecord.length < 1)
	{
		alert("请先选择医嘱!");
		return;
	}
	//判断状态是否为预约
	if ( selRecord[0].data.status != "预约" )
	{
		alert("不允许取消预约");
		return;
	}
	
	var selInfo=getSelInfo();
	var infoList=selInfo[0];
	var orderbodyList="";
	if (infoList!="")
	{
		var arrayInfo=infoList.split("^");
		orderbodyList=arrayInfo[1];
	}
	//var oeOrdDr=selRecord[0].data.oeOrdDr;
	//var index = serviceOrderGrid.getStore().find("oeOrdDr",oeOrdDr);
	if (orderbodyList=="")
	{
		return;
	}
	//var ret = tkMakeServerCall("web.DHCRisResApptSchudleSystem","CancelBooked",oeOrdDr,appointmentInfo.Session.user_rowid,appointmentInfo.Local.IpAddr);
	//  web.DHCRisResourceApptSchudle
	var ret = tkMakeServerCall("web.DHCRisResourceApptSchudle","CancelBook",orderbodyList,appointmentInfo.Session.user_rowid,appointmentInfo.Local.IpAddr);
	if (ret==0)
	{
		alert("取消预约成功!");
		
		changeScheduleInfo();
		
		var oldCheckBox=Ext.getCmp(infoList);
		if ( oldCheckBox)
		{
			var divBox=oldCheckBox.positionEl;
			divBox.removeClass('my-chechbox-disabled');
			divBox.addClass('x-item-disabled');
			oldCheckBox.enable();
			jsSet=true;		
			oldCheckBox.setValue(false);
			
		}
	}
	else
	{
		alert("取消预约失败! ret="+ret);
	}

}


function printBookInfo()
{
	try 
	{
		//var Find=0;
		var TemplatePath=tkMakeServerCall("web.DHCRisCommFunction","GetPath");
		//TemplatePath="e:/DtHealth/app/dthis/med/Results/Template/";
		var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCRisWardTR1.xls";
	    var CellRows ;
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    var Count=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var wsh = new ActiveXObject("WScript.shell");
	    reg=wsh.RegRead("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows\\Device");
	    if (reg!="")
	    {
		     var PrintInfo=reg.split(",");
		     PrintName=PrintInfo[0]; 
		}
		
	    /*
 	    var j=0,k="",LastRow=0,l=0;
 	    if (Count!=0)
 	    {
	 	    var s=Count%4
	 	    var LastRow=Count-s
	 	}
        */
		var j=0;
		var i=0;
		//alert("A-001")
		var length=serviceOrderGrid.getStore().getCount();
		//alert(length);
		for (var  index=0;index<length;index=index+1)
		{
			if (serviceOrderGrid.getStore().getAt(index).get('isPrint')==true)
			{
				//alert(serviceOrderGrid.getStore().getAt(index).get('oeOrdDr'));
				//web.DHCRisWardQuery.RequestPrintData
				var oeOrdDr=serviceOrderGrid.getStore().getAt(index).get('oeOrdDr');
				var bookInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","GetBookedPrintData",oeOrdDr);
				///alert(bookInfo);
				if(bookInfo!="")
				{
					  //Find=1;
					  Items=bookInfo.split("^");
				 	  var OeItemID=oeOrdDr; 
				 	  var ResourceDesc=Items[2]
				 	  var BookedDate=Items[3];
				 	  var BookedTime=Items[4];
				 	  //var PrintFlag=Items[21];
				 	  //var MeothodDesc=Items[22];
				 	  //var RecLocDR=Items[23];
				 	  var LocName=Items[5];
				 	  var strItmDate=Items[10]+"  "+Items[11];
				 	  var IndexBook=Items[9];
				 	  
				 	  var oderInfo=tkMakeServerCall("web.DHCRisWardQuery","RequestPrintData",oeOrdDr);
				 	  //alert(oderInfo)
				 	  var PrintItem=oderInfo.split("^");
				 	  if (j==0)
	 	              {
		 	             j=j+1;
		 	          }else
		 	          {
			 	         j=j+11;
			 	      }
			 	      if(IndexBook=="")
			 	      {
				 	     var IndexBook=BookedTime 
				 	   }
                      //alert(xlsheet);
			 	      WriteExcelCell(xlsheet,j,PrintItem,BookedDate,IndexBook,LocName,strItmDate,OeItemID,ResourceDesc);
			 	      i=i+1;
			 	      if((i%1)==0)
			 	      {
				 	     j=0;
				 	     //xlsheet.printout;
				 	     xlsheet.printout(1,100,1,false,PrintName);
				 	     ///xlBook.Close
			 	      }
					
				}
				serviceOrderGrid.getStore().getAt(index).set('isPrint',false);
			}
		}
        
		//if (Find==0) return
		
 	    var len=i%1;
        if (len=="1")
        {
	        ClearExcelCell(xlsheet,12);
	        //ClearExcelCell(xlsheet,23);
	        //ClearExcelCell(xlsheet,34);
	    }else if(len=="2")
	    {
		    
		    ClearExcelCell(xlsheet,23);
	        ClearExcelCell(xlsheet,34) ;
		}else if (len=="3")
	    {
	        ClearExcelCell(xlsheet,34);
		}
		if (len!=0)
		{
			xlsheet.printout(1,100,1,false,PrintName);
		}
		
		xlBook.Close (savechanges=false);
		xlApp.Quit(); 
	    xlApp=null;
	    xlsheet=null;
	    var idTmr = window.setInterval("Cleanup();",1000);
        
	}
	catch(e) 
	{
		alert(e.message);
	}
        
}



function WriteExcelCell(xlsheet,j,PrintItem,BookedDate,IndexBook,LocName,strItmDate,OeItemID,ResourceDesc)
{
	 //SetExcelCell(xlsheet,j+2);
	//alert(xlsheet);
	//alert(j);
	
	xlsheet.cells(j+2,1).value="北京同仁医院检查申请单(预约单)"+"   "+IndexBook;
     
     //alert("2");
     //SetExcelCell(xlsheet,j+3);
     xlsheet.cells(j+3,1).value="登记号";
     xlsheet.cells(j+3,2).value=PrintItem[0];
     xlsheet.cells(j+3,3).value="病案号";
     xlsheet.cells(j+3,4).value=PrintItem[1];
     xlsheet.cells(j+3,5).value="姓名";
     xlsheet.cells(j+3,6).value=PrintItem[2];
     xlsheet.cells(j+3,7).value="性别";
     xlsheet.cells(j+3,8).value=PrintItem[3];
     xlsheet.cells(j+3,9).value="年龄";
     xlsheet.cells(j+3,10).value=PrintItem[4];
     
     var pattype=PrintItem[18]
     if (pattype=="I")
        {
	        xlsheet.cells(j+4,1).value="病区";
            xlsheet.cells(j+4,2).value=PrintItem[6];
	        xlsheet.cells(j+4,5).value="床号";
	        xlsheet.cells(j+4,6).value=PrintItem[5]; 
	        }
	        else{
		        xlsheet.cells(j+4,1).value="身份证号";
            xlsheet.cells(j+4,2).value=PrintItem[15];
	        xlsheet.cells(j+4,5).value="电话号";
	        xlsheet.cells(j+4,6).value=PrintItem[14];        
		        }
     //SetExcelCell(xlsheet,j+4);
     
     xlsheet.cells(j+4,3).value="申请科室";
     xlsheet.cells(j+4,4).value=PrintItem[9];
     
     xlsheet.cells(j+4,8).value=OeItemID;
     
     
     //SetExcelCell(xlsheet,j+5);
     xlsheet.cells(j+5,1).value="临床所见";
     xlsheet.cells(j+5,2).value=PrintItem[10];
     
     //SetExcelCell(xlsheet,j+6);
     xlsheet.cells(j+6,1).value="检查目的";
     xlsheet.cells(j+6,2).value=PrintItem[11];
     
     //SetExcelCell(xlsheet,j+7);
     xlsheet.cells(j+7,1).value="诊断";
     xlsheet.cells(j+7,2).value=PrintItem[12];
     
     //SetExcelCell(xlsheet,j+8);
     xlsheet.cells(j+8,1).value="医嘱";
     xlsheet.cells(j+8,2).value=PrintItem[7];
     xlsheet.cells(j+8,6).value="医嘱日期   "+strItmDate;
     
     //SetExcelCell(xlsheet,j+9);
     xlsheet.cells(j+9,1).value="预约日期";
     xlsheet.cells(j+9,2).value=BookedDate+"   "+IndexBook+"   "+ResourceDesc ;//PrintItem[0]
     xlsheet.cells(j+9,6).value="接收科室   "+LocName;
     
     //SetExcelCell(xlsheet,j+10);
     xlsheet.cells(j+10,1).value="申请医生";
     xlsheet.cells(j+10,2).value=PrintItem[8];
     xlsheet.cells(j+10,4).value="打印日期";
     xlsheet.cells(j+10,6).value=GetCurrentDate();
}


function GetCurrentDate()
{
	var d, s="";         
    d = new Date(); 
    var sDay="",sMonth="",sYear="";
    sDay = d.getDate();		
    if(sDay < 10)
    sDay = "0"+sDay;
    
    sMonth = d.getMonth()+1;		
    if(sMonth < 10)
    sMonth = "0"+sMonth;
    
    sYear  = d.getYear();	
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    	
    s=sYear +"-"+sMonth+"-"+sDay+"    "+sHoure+":"+sMintues ;
    
    return s;

}

function ClearExcelCell(xlsheet,j)
{
	 //SetExcelCell(xlsheet,j+2);
     xlsheet.Cells(j+2,1).value="";
     xlsheet.Rows(j+2).RowHeight = 0;
     //SetExcelCell(xlsheet,j+3);
     xlsheet.Rows(j+3).RowHeight = 0;
     /*xlsheet.cells(j+3,1)=""
     xlsheet.cells(j+3,2)="";
     xlsheet.cells(j+3,3)=""
     xlsheet.cells(j+3,4)="";
     xlsheet.cells(j+3,5)="";;
     xlsheet.cells(j+3,6)="";;
     xlsheet.cells(j+3,7)="";
     xlsheet.cells(j+3,8)="";
     xlsheet.cells(j+3,9)="";
     xlsheet.cells(j+3,10)="";*/
     
     //SetExcelCell(xlsheet,j+4);
     xlsheet.Rows(j+4).RowHeight = 0;
     /*xlsheet.cells(j+4,1)="";
     xlsheet.cells(j+4,2)="";
     xlsheet.cells(j+4,3)="";
     xlsheet.cells(j+4,4)="";
     xlsheet.cells(j+4,5)="";
     xlsheet.cells(j+4,6)=""; */
     
     //SetExcelCell(xlsheet,j+5);
     xlsheet.Rows(j+5).RowHeight = 0;
     //xlsheet.cells(j+5,1)="";
     //xlsheet.cells(j+5,2)="";
     
     //SetExcelCell(xlsheet,j+6);
     xlsheet.Rows(j+6).RowHeight = 0;
     //xlsheet.cells(j+6,1)="";
     //xlsheet.cells(j+6,2)="";
     
     //SetExcelCell(xlsheet,j+7);
     xlsheet.Rows(j+7).RowHeight = 0;
     /*xlsheet.cells(j+7,1)="";
     xlsheet.cells(j+7,2)="";*/
     
     //SetExcelCell(xlsheet,j+8);
     xlsheet.Rows(j+8).RowHeight = 0;
     /*xlsheet.cells(j+8,1)="";
     xlsheet.cells(j+8,2)="";*/
     
     //SetExcelCell(xlsheet,j+9);
     xlsheet.Rows(j+9).RowHeight = 0;
     /*xlsheet.cells(j+9,1)="";
     xlsheet.cells(j+9,2)="";*/
     
     //SetExcelCell(xlsheet,j+10);
     xlsheet.Rows(j+10).RowHeight = 0;
     /*xlsheet.cells(j+10,1)="";
     xlsheet.cells(j+10,2)="";
     xlsheet.cells(j+10,4)="";
     xlsheet.cells(j+10,6)="";*/
}
function bookappointClick()
{

	var j=0;
    var i=0;
	//alert("A-001")
	var length=serviceOrderGrid.getStore().getCount();
	//alert(length);
	for (var  index=0;index<length;index=index+1)
	   {
		//alert(index)
		if(serviceOrderGrid.getStore().getAt(index).get('oeOrdDr'))
		{
		  var Status=serviceOrderGrid.getStore().getAt(index).get('status');
			 if (Status!="预约")
			    {
			    var oeOrdDr=serviceOrderGrid.getStore().getAt(index).get('oeOrdDr');
			    //alert(oeOrdDr)
			 if (oeOrdDr!="")
	              {
		                var oeorditemdr=oeOrdDr.split("||");
		                      ordrowid=oeorditemdr[0];
		                       itmsub=oeorditemdr[1];  
	               }
			   var orderInfo=tkMakeServerCall("web.DHCRisCommFunctionEx","GetOeorditminfo",ordrowid,itmsub)
			   if (orderInfo!="")
	              {
		                var ServerGroupDR=orderInfo.split("^");
		                     RecLocDr=ServerGroupDR[18];
		                      ServerGroupDR=ServerGroupDR[35];
	               }
	           //alert(ServerGroupDR)
	           //alert(RecLocDr)
	           var UseBookResInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","GetBookUseRes","","",ServerGroupDR,RecLocDr,oeOrdDr,"","")
	           //alert(UseBookResInfo)
	           /*if (UseBookResInfo=="")
	              {
		            alert("没有可预约资源资源!");
		            return;
	               }*/
	           if (UseBookResInfo!="")
	              {
		                var BookInfo=UseBookResInfo.split("^");
		                      scheduleDr=BookInfo[0]; 
	               
	                 var arcItmDr=serviceOrderGrid.getStore().getAt(index).get('arcItmDr');
	               //alert(arcItmDr) 
	                 var infoParam=oeOrdDr+"^"+scheduleDr+"^"+admSchedule+"^"+appointmentInfo.Session.user_rowid+"^"+appointmentInfo.Local.IpAddr;    //appointmentInfo.Local.IpAddr;
                     //alert(infoParam)
                     var ret = tkMakeServerCall("web.DHCRisResApptSchudleSystem","InsertBookedData",infoParam);
	                  //alert(ret);
	                if (ret.split('^')[0]==0)
	                 {
		                //alert("预约成功!");
		               changeScheduleInfo(oeOrdDr);
		               var schCheckBox=Ext.getCmp(arcItmDr+"^"+oeOrdDr+"^"+scheduleDr);
		            if ( schCheckBox)
		               {		
			             schCheckBox.disable();
			             var divBox=schCheckBox.positionEl;
			               divBox.removeClass('x-item-disabled');
			             divBox.addClass('my-chechbox-disabled');

		                 }
		                     //selScheduleId="";
		                    //printBookInfo(oeordDr)
		                    //serviceOrderStore.load();
		                   //resourcePanel.removeAll();
	                  }
	                } //alert(index)
                }
		}
    }	//刷新列表
    resourcePanel.removeAll();
    findNoAppointList();
//serviceOrderStore.load();
}


function intelligentAppoint()
{
	var orderlist="" ;  //(医嘱rowid@日期^医嘱rowid@日期........)
	var length=serviceOrderGrid.getStore().getCount();

	for (var  index=0;index<length;index=index+1)
	{	
		
	  	var Status=serviceOrderGrid.getStore().getAt(index).get('status');
		if (Status!="预约")
	    {
	     	var oeOrdDr=serviceOrderGrid.getStore().getAt(index).get('oeOrdDr');
	     	//var dateTime = serviceOrderGrid.getStore().getAt(index).get('UseBookResInfo');
	     	//var date = dateTime.split(" ")[0];
	     	if (orderlist == "")
	     	{
		     	//orderlist = oeOrdDr+"@"+date;
		     	orderlist = oeOrdDr;
	     	}
	     	else
	     	{
		     	//orderlist = orderlist+"^"+oeOrdDr+"@"+date;
		     	orderlist = orderlist+"@"+oeOrdDr;
	     	}
	    }
		
	}
	var info = orderlist+"^"+appointmentInfo.Session.user_rowid+"^"+appointmentInfo.Local.IpAddr; 
	var orderRet = tkMakeServerCall("web.DHCRisResApptSchudleSystem","AutoBooked",orderlist,appointmentInfo.Session.user_rowid,appointmentInfo.Local.IpAddr);
	resourcePanel.removeAll();
	
	var orders=orderRet.split("^");
	var lenght=orders.length;
	for (var index=0;index<lenght;index++)
	{
		//alert(orders[index]);
		var row = serviceOrderGrid.getStore().find("oeOrdDr",orders[index]);
		if ( row >= 0)
		{
			var bookInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","getBookInfo",orders[index]);
			var bookInfoList=bookInfo.split("^");
			serviceOrderGrid.getStore().getAt(row).set('isPrint',true);
			serviceOrderGrid.getStore().getAt(row).set('status','预约');
			serviceOrderGrid.getStore().getAt(row).set('bookRes',bookInfoList[4]);
			serviceOrderGrid.getStore().getAt(row).set('bookDate',bookInfoList[1]);
			serviceOrderGrid.getStore().getAt(row).set('bookTime',bookInfoList[2]);
			serviceOrderGrid.getStore().getAt(row).set('scheduleDr',bookInfoList[0]);
		}
	}
	resourcePanel.removeAll();
	findNoAppointList();
	
}

function findNoAppointList()
{
	var alertInfo="" ;  
	var length=serviceOrderGrid.getStore().getCount();

	for (var  index=0;index<length;index=index+1)
	{	
		
	  	var Status=serviceOrderGrid.getStore().getAt(index).get('status');
		if (Status!="预约")
		{
			var orderDesc = serviceOrderGrid.getStore().getAt(index).get('OrderName');
			if (alertInfo == "")
			{
				alertInfo = "["+orderDesc+"] 未预约成功";
			}
			else
			{
				alertInfo = alertInfo + "\r\n["+orderDesc+"] 未预约成功";
			}
		}
	}
	
	if ( alertInfo == "")
	{
		alertInfo = "预约成功!";
	}
	alert(alertInfo);
}


function clickPrint()
{
	var selInfo=getSelInfo();
	var infoArray=selInfo[0].split("^");
	//alert(infoArray);
	var orderBodyList=infoArray[1];
	var LocId=selInfo[2];
	if (orderBodyList=="")
	{
		alert("请先选择医嘱!");
		return;
	}
	if (selInfo[1]!="预约")
	{
		alert("状态不对,不能打印!");
		return;
	}
	//alert(orderBodyList);
	
   // alert(LocId);
	var gPrintTemplate=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetLocBookedPrintTemplate",LocId);    //"DHCRisApp"
			    //alert(gPrintTemplate);
			   // var templateList=gPrintTemplate.split(".");
			    //gPrintTemplate=templateList[0]+"_ZJ."+templateList[1];
			    //alert(gPrintTemplate);
			    //gPrintTemplate=gPrintTemplate+"_ZJ";
			    //alert(gPrintTemplate);
			    if (gPrintTemplate=="")
			    {
				   alert("请先配置打印模板!");
				   return;
			    }
			    //增加医院名称获取
				var hospitalDesc=tkMakeServerCall("web.DHCRisCommFunction","getHospitalDesc",LocId);
			    //alert(gPrintTemplate);
			    DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
   
				//var oeOrdDr=serviceOrderGrid.getStore().getAt(index).get('oeOrdDr');
				//alert(orderBodyList);
				var bookInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBookedPrintByloc",orderBodyList);
				//alert(bookInfo);
				if(bookInfo!="")
				{
					  //Find=1;
					  Items=bookInfo.split("^");
				 	 // var OeItemID=oeOrdDr; 
				 	  var ResourceDesc=Items[2];      //预约资源    
				 	  var BookedDate=Items[3];        //预约日期
				 	  var BookedTime=Items[4];        //预约时间
				 	  var BookEndTime=Items[5];
				 	  //var PrintFlag=Items[21];
				 	  //var MeothodDesc=Items[22];
				 	  //var RecLocDR=Items[23];
				 	  var recLoc=Items[6];           //接收科室
				 	  var strItmDate=Items[10]+"  "+Items[11];   //医嘱日期
				 	  var IndexBook=Items[9];         //预约流水号
				 	  var Address=Items[12];    //物理地址
				 	  var Adress=Address.split(":")[0];
				 	  var RegAdd=Address.split(":")[1];
				 	  //var oderInfo=tkMakeServerCall("web.DHCRisWardQuery","RequestPrintData",oeOrdDr);
				 	 
				 	 // var PrintItem=oderInfo.split("^");
				 	 
				 	 
				 	 var oderInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBigPrint",orderBodyList);
				  //alert(oderInfo);
				 	  var strOrderName=oderInfo.split("^")[0];
				 	  var GetMemo=oderInfo.split("^")[1];
			      var patientID = Items[13];   //登记号
			      var medicareNo= Items[14];    //病案号
			     	var patientName = Items[15]; //姓名
			     	var sex = Items[16];         //性别
			      var age = Items[17];         //年龄
			     
			     	var pattype=Items[18];
			     	//if (pattype=="I")
			      {
		          var ward = Items[19];    //病区
			        var bedNo = Items[18];   //床号
				    }
		        //else
		        {
							var idCard = Items[15];    //身份证号
							var teleNo = Items[14];    //电话号      
			      }
			     //SetExcelCell(xlsheet,j+4);
			    
			     var appLoc = Items[22];    //申请科室
			    
			    // var patientNow = PrintItem[23];  //临床所见
			    
			     //var purpose = PrintItem[24];     //检查目的

			     //var diagnose = PrintItem[25];     //诊断
			     
			     //var orderName =Items[24];   //医嘱名称

			     var appDoc = Items[21];     //申请医生
			     // var Memo = Items[23]; 
			     var printDate = GetCurrentDate();   //打印日期
			     var CardNo=Items[25]; 
			     
			     var MyPara="PatientName"+String.fromCharCode(2)+patientName;
				   //MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+"*"+OeItemID+"*";
				   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+patientID;
				   MyPara=MyPara+"^RegNoL"+String.fromCharCode(2)+"*"+patientID+"*";
				   MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate
				   MyPara=MyPara+"^Bookedtime"+String.fromCharCode(2)+BookedTime+"-"+BookEndTime;
				   MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+recLoc;
				   MyPara=MyPara+"^OrderDate"+String.fromCharCode(2)+strItmDate;
				   MyPara=MyPara+"^index"+String.fromCharCode(2)+IndexBook;
				   MyPara=MyPara+"^OrderName"+String.fromCharCode(2)+strOrderName;
				   MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+ResourceDesc;
				   
				   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+medicareNo;
				   MyPara=MyPara+"^Age"+String.fromCharCode(2)+age;
				   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+sex;
				   MyPara=MyPara+"^WardName"+String.fromCharCode(2)+ward;
				   MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+bedNo;				   
				   MyPara=MyPara+"^IdCard"+String.fromCharCode(2)+idCard;
				   MyPara=MyPara+"^TeleNo"+String.fromCharCode(2)+teleNo;
				   MyPara=MyPara+"^AppLoc"+String.fromCharCode(2)+appLoc;
				   //MyPara=MyPara+"^PatientNow"+String.fromCharCode(2)+patientNow;
				  // MyPara=MyPara+"^Purpose"+String.fromCharCode(2)+purpose;
				  // MyPara=MyPara+"^Diagnose"+String.fromCharCode(2)+diagnose;
				   MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+appDoc;
				   MyPara=MyPara+"^PrintDate"+String.fromCharCode(2)+printDate;
				   MyPara=MyPara+"^Memo"+String.fromCharCode(2)+GetMemo;
		   			MyPara=MyPara+"^StarTime"+String.fromCharCode(2)+BookedTime;
		   			MyPara=MyPara+"^Address"+String.fromCharCode(2)+Adress;
		   			MyPara=MyPara+"^RegAdd"+String.fromCharCode(2)+RegAdd;
		   			MyPara=MyPara+"^CardNo"+String.fromCharCode(2)+CardNo;
		   			MyPara=MyPara+"^HospitalDesc"+String.fromCharCode(2)+hospitalDesc;
		   		//alert(MyPara);
		   		var myobj=document.getElementById("ClsBillPrint");
		   		//DHCP_PrintFun(myobj,MyPara,"");
		   		DHCP_XMLPrint("",MyPara,"");		
					
				}
     
}

