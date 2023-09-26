//patient info panel 1
//var EpisodeID=session['LOGON.EQISODEID'];

var resourceProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
}));

var resourceStore = new Ext.data.Store({
	proxy : resourceProxy,
	reader : new Ext.data.JsonReader({
		root:'record',
		totalProperty:'total',
		idProperty:'Group'
	},
	[
		{name:'ResourceDesc',mapping:'TResDesc'}
		,{name:'ResourceDr',mapping:'TRowid'}
		
	])
});


var resourceCmb = new Ext.form.ComboBox({
 	store:resourceStore,
 	displayField:'ResourceDesc',
 	valueField:'ResourceDr',
    fieldLabel:'资源',
    typeAhead : true,
    forceSelection : true,
    anchor:'100%',
	triggerAction:'all',
	id:'resourceCmb',
	selectOnFocus : true,
	listeners : {
			'select':function(){
				loadResSchduleStore();
			}
        }
 });
 
 
var imageGroupProxy = new Ext.data.HttpProxy( new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

imageGroupProxy.on('beforeload',function(objProxy,param){
					 	param.ClassName='web.DHCRisRegisterPatientDoEx';
						param.QueryName='QueryMedicalImageGroup';
						//param.Arg1 = locRowid;
						param.ArgCnt = 0;	
						//alert("1");
 });
 
var imageGroupStore = new Ext.data.Store({
	proxy: imageGroupProxy,
	reader : new Ext.data.JsonReader({
		root : 'record',
		totalProperty : 'total',
		idProperty : 'Group'
	},
	[
		{name:'GroupCode',mapping:'GroupCode'},
		{name:'GroupDesc',mapping:'GroupDesc'}
	])
});
 
 
var imageGroupCmb = new Ext.form.ComboBox({
	store : imageGroupStore,
	displayField : 'GroupDesc',
	valueField : 'GroupCode',
	fieldLabel : '影像组',
	typeAhead : true,
	forceSelection : true,
	anchor : '95%',
	triggerAction : 'all',
	id : 'imageGroupCmb',
	selectOnFocus : true
	//listeners : 
});


 
var panelPatInfo = new Ext.Panel({
		border:false,
		layout:'column',
		//height:50,
		items:[
			new Ext.Panel({
				width:160,
				layout:'form',
				border:false,
				labelWidth:60,
				labelAlign:'right',
				items:[
					{
						xtype:'displayfield',
						fieldLabel:'姓&nbsp;&nbsp;&nbsp;名',
						name:'patName',
						anchor:'95%',
						id:'patName',
						style:'color:blue;'
					}
				]
			}),
			new Ext.Panel({
				width:160,
				layout:'form',
				border:false,
				labelWidth:60,
				labelAlign:'right',
				items:[
					{
						xtype:'displayfield',
						fieldLabel:'患者ID',
						name:'patientID',
						anchor:'95%',
						id:'patientID',
						style:'color:blue;'
					}
				]
			}),
			new Ext.Panel({
				width:160,
				border:false,
				layout:'form',
				labelWidth:60,
				labelAlign:'right',
				items:[
					{
						xtype:'displayfield',
						fieldLabel:'性别',
						name:'patSex',
						id:'patSex',
						anchor:'95%'
					}				
				]
			}),
			new Ext.Panel({
				width:160,
				border:false,
				layout:'form',
				labelWidth:60,
				labelAlign:'right',
				items:[
					{
						xtype:'displayfield',
						fieldLabel:'年龄',
						name:'patAge',
						id:'patAge',
						anchor:'95%'
			
					}			
				]

			}),
		new Ext.Panel({
			width:160,
			layout:'form',
			border:false,
			labelWidth:60,
			labelAlign:'right',
			items:[
				{
					xtype:'displayfield',
					id:'bookSchduleRowid',
					fieldLabel:'schRowid',
					anchor:'100%',
					hidden:true,
					hideLabel:true
				}
			]
		}),
		new Ext.Panel({
			width:160,
			layout:'form',
			border:false,
			labelWidth:60,
			labelAlign:'right',
			items:[
				{
					xtype:'displayfield',
					id:'schduleRowidSel',
					fieldLabel:'schRowidSel',
					anchor:'100%',
					hidden:true,
					hideLabel:true
				}
			]
		})
			
		]
});

var panelSchedule = new Ext.Panel({
	border:false,
	layout:'column',
	items:[
		new Ext.Panel({
			//columnWidth:.25,
			width:160,
			layout:'form',
			border:false,
			labelAlign:'right',
			labelWidth:60,
			items:[
				{
					xtype:'textfield',
					id:'bookDate',
					fieldLabel:'预约日期',
					anchor:'100%'
				}
			]
		
		}),
		new Ext.Panel({
			width:160,
			layout:'form',
			border:false,
			labelWidth:60,
			labelAlign:'right',
			items:[
				{
					xtype:'textfield',
					id:'bookTime',
					fieldLabel:'预约时间',
					anchor:'100%'
				}
			]
		}),
		new Ext.Panel({
			width:160,
			layout:'form',
			border:false,
			labelWidth:60,
			labelAlign:'right',
			items:[
				{
					xtype:'textfield',
					id:'bookRes',
					fieldLabel:'资源',
					anchor:'100%'
				}
			]
		})
		/*,
		new Ext.Panel({
			width:160,
			layout:'form',
			border:false,
			labelWidth:60,
			labelAlign:'right',
			items:[
					//timeField
				//resourceCmb
        imageGroupCmb					 			
			]
		})
		*/
	]
});

var panelOrder = new Ext.Panel({
	border:false,
	layout:'column',
	items:[
		new Ext.Panel({
			border:false,
			layout:'form',
			width:700,
			labelWidth:60,
			labelAlign:'right',
			items:[
				{
					xtype:'textfield',
					id:'orderDesc',
					fieldLabel:'检查项目',
					anchor:'100%',
					readOnly:'true'
				}
			]
		})
	]
});


var panelAttention = new Ext.Panel({
	layout:'form',
	border:false,
	labelWidth:60,
	labelAlign:'right',
	width:700,
	items:[
		{
			xtype:'textarea',
			id:'attention',
			height:55,
			fieldLabel:'注意事项',
			anchor:'100%',
			readOnly:'true'
		}
	]
	
});
var BillAttention = new Ext.Panel({
	layout:'form',
	border:false,
	labelWidth:60,
	labelAlign:'right',
	width:700,
	items:[
		{
			xtype:'textarea',
			id:'ApplicationBill',
			height:50,
			fieldLabel:'申请内容',
			anchor:'100%',
			readOnly:'true'
		}
	]
	
});


var operatePanel = new Ext.Panel({
	 border:false,
	 layout:'column',
	 height:30,
	 items:[
	 	new Ext.Panel({
	 			border:false,
	 			width:50,
	 			items:[
	 				{
		 				xtype:'displayfield',
						fieldLabel:''
	 				}
	 			]
	 	}),
		new Ext.Panel({
			border:false,
			width:120,
			items:[
				{
					xtype:'button',
					id:'btnNext',
					text:'下一页',
					//cls:'risBtn',
					iconCls:'btn-ris-down',
					width:100,
					height:26
				}
			]	
		}),
		new Ext.Panel({
			border:false,
			width:120,
			items:[
				{
					xtype:'button',
					id:'btnPre',
					text:'上一页',
					//iconCls:'btn-ris-find',
					iconCls:'btn-ris-up',
					width:100,
					height:26
				}
			]
		}),
		new Ext.Panel({
			border:false,
			id:'panelSchdule',
			width:120,
			items:[
				{
					xtype:'button',
					id:'btnSchedule',
					text:'预约',
					cls:'btnBook',
					iconCls:'btn-ris-book',
					width:100,
					height:26
				}
			]
		}),
		new Ext.Panel({
			border:false,
			width:120,
			items:[
				{
					xtype:'button',
					id:'btnCancelSch',
					text:'取消预约',
					iconCls:'btn-ris-cancelbook',
					width:100,
					height:26
				}
			]
		}),
		
		new Ext.Panel({
			border:false,
			width:120,
			items:[
				{
					xtype:'button',
					id:'btnRefresh',
					text:'刷新',
					iconCls:'btn-ris-reload',
					width:100,
					height:26
				}
			]	
		}),
		new Ext.Panel({
			border:false,
			width:120,
			items:[
				{
					xtype:'button',
					id:'btnPrint',
					text:'打印预约单',
					iconCls:'btn-ris-print',
					width:100,
					height:26
				}
			]	
		})
	 ]
});



function loadResSchduleStore()
{
	resSchduleStore1.load();
	resSchduleStore2.load();
	
	//1 最大数  2 检查时间
    var bookType=tkMakeServerCall("web.DHCRisCodeTableAdd","GetBKUseFlagbyLoc",locRowid);
    
	//if (  (locRowid=="388")|| (locRowid=="389"))
	//alert("bookType="+bookType);
	if ( bookType=="2")
	{
		resListGrid1.getColumnModel().setHidden(3,true);
		resListGrid1.getColumnModel().setHidden(4,true);
		resListGrid2.getColumnModel().setHidden(3,true);
		resListGrid2.getColumnModel().setHidden(4,true);
		resListGrid1.getColumnModel().setHidden(5,false);
		resListGrid2.getColumnModel().setHidden(5,false);
	}
	else
	{
		resListGrid1.getColumnModel().setHidden(3,false);
		resListGrid1.getColumnModel().setHidden(4,false);
		resListGrid2.getColumnModel().setHidden(3,false);
		resListGrid2.getColumnModel().setHidden(4,false);
		resListGrid1.getColumnModel().setHidden(5,true);
		resListGrid2.getColumnModel().setHidden(5,true);
	}
}

function clickRefresh()
{
	var dateObj1 = Ext.getCmp("bookDate1");
	dateObj1.setValue(new Date());
	var dateObj2 = Ext.getCmp("bookDate2");
	dateObj2.setValue(new Date().add(Date.DAY,1));

	
	Ext.getCmp("week1").setValue(showWeek(dateObj1.getValue()));
	Ext.getCmp("week2").setValue(showWeek(dateObj2.getValue()));

	
	loadResSchduleStore();
}
function clickNext()
{
	var dateObj1 = Ext.getCmp("bookDate1");
	dateObj1.setValue(dateObj1.getValue().add(Date.DAY, 2));
	var dateObj2 = Ext.getCmp("bookDate2");
	dateObj2.setValue(dateObj2.getValue().add(Date.DAY, 2));

	
	Ext.getCmp("week1").setValue(showWeek(dateObj1.getValue()));
	Ext.getCmp("week2").setValue(showWeek(dateObj2.getValue()));

	loadResSchduleStore();
};

function clickPre()
{
	var dateObj1 = Ext.getCmp("bookDate1");
	dateObj1.setValue(dateObj1.getValue().add(Date.DAY, -2));
	var dateObj2 = Ext.getCmp("bookDate2");
	dateObj2.setValue(dateObj2.getValue().add(Date.DAY, -2));

	
	Ext.getCmp("week1").setValue(showWeek(dateObj1.getValue()));
	Ext.getCmp("week2").setValue(showWeek(dateObj2.getValue()));

	loadResSchduleStore();
};

var patInfoFieldSet = new Ext.form.FieldSet({
	title:'预约基本信息',
	autoScroll:true,
	width:760,
	height:230,
	items:[
		//panelPatInfo,
		//patRow1,
		panelPatInfo,
		panelSchedule,
		panelOrder,
		panelAttention,
		BillAttention

		
	]
	
});


var timeField=new Ext.form.TimeField({  
    fieldLabel:'时间',  
    //width:100,
    width:90,
    format:'H:i',
    empty:'请选择时间',  
    minValue:'8:00 AM',  
    maxValue:'17:00 PM',  
    increment:20,  
    //renderTo: Ext.get('timeField'),
    invalidText:'日期格式无效，请选择时间或输入有效格式的时间'  
});  





 
var inpatientFiledset = new Ext.form.FieldSet({
	title:'住院病人',
	autoScroll:true,
	width:265,
	height:230,
	//border:false,
	items:[
		new Ext.Panel({
			width:235,
			layout:'form',
			border:false,
			labelWidth:80,
			labelAlign:'right',
			items:[
				{
					xtype:'textfield',
					id:'InpatientNo',
					fieldLabel:'住院号',
					anchor:'100%',
					initEvents: function() {  
					   var keyPress = function(e){  
					       if (e.getKey() == e.ENTER && this.getValue().length > 0) {  
					           searchSYData();
					       }  
					   };  
					    this.el.on("keypress", keyPress, this);  
					} 
					
				}
			]
		}),
		new Ext.Panel({
			width:235,
			layout:'form',
			border:false,
			labelWidth:80,
			labelAlign:'right',
			items:[
				{
					xtype:'textfield',
					id:'InpatientName',
					fieldLabel:'住院患者姓名',
					anchor:'100%'
				}
			]
		}),
		new Ext.Panel({
			width:235,
			layout:'form',
			border:false,
			labelWidth:80,
			labelAlign:'right',
			items:[
				{
					xtype:'textfield',
					id:'OeordTime',
					fieldLabel:'检查时长',
					anchor:'100%'
				}
			]
		}),
		new Ext.Panel({
			width:235,
			layout:'form',
			border:false,
			labelWidth:80,
			labelAlign:'right',
			items:[
					//timeField
					resourceCmb
								
			]
		}),
		
		new Ext.Panel({
			border:false,
			width:200,
			layout:'column',
			//buttonAlign:'center',
			items:[
				{
					xtype:'panel',
					//id:'btnTest',
					//text:'test',
					height:50,
					width:50
				},
				{
					xtype:'button',
					id:'btnBookIn',
					text:'住院预约',
					width:80,
					margins:'10 0 0 0',
					cls:'btnBook',
					style:'color:red; '
				}
			]
		})
	
	]
	
});


Ext.getCmp('btnNext').on('click',clickNext);
Ext.getCmp('btnPre').on('click',clickPre);
Ext.getCmp('btnSchedule').on('click',clickBook);
Ext.getCmp('btnCancelSch').on('click',clickCancelBook);
Ext.getCmp('btnRefresh').on('click',clickRefresh);
Ext.getCmp('btnPrint').on('click',clickPrint);
Ext.getCmp('btnBookIn').on('click',clickBookIn);


function searchSYData()
{
	var inPatientNo=Ext.getCmp("InpatientNo").getValue();
	if ( inPatientNo!="")
	{
		var patientName="";
		var num=0;
		do 
		{
			patientName=tkMakeServerCall("web.DHCRisResourceApptSchudle","getHisPatInfoSY",inPatientNo);
			num=num+1;
			sleep(100);
		}
		while ((patientName=="")&&(num<10))
		//alert(num);
		Ext.getCmp("InpatientName").setValue(patientName);
	}
}

function sleep(ms)
{
	ms+=new Date().getTime();
	while (new Date()<ms){}
}
var panelInfo = new Ext.Panel({
	id:'infoPanel',
	baseCls:'x-plain',
	layout:'table',
	layoutConfig:{columns:2},
	
	//defaults:{frame:false,width:500,height:350},
	items:[
		{
			
			items:[patInfoFieldSet]
		},
		{
			//title:'item 2',
			//items:[inpatientFiledset]
		}
		
	]

});

var centerView = new Ext.FormPanel({
	
	title:"",
		//bodyStyle:'padding:10;',
		layout:"form",
		region:'center',
		frame:true,
		autoScroll:true,
		items:[
			//patInfoFieldSet,
			panelInfo,
			operatePanel,
			panelRes
			
		]
});

function CTrim(info)
{
	 return info.replace(/(^\s*)|(\s*$)/g,'');
}

//alert("view");
function clickBookIn()
{
	var schduleDr=Ext.getCmp("schduleRowidSel").getValue();
	//alert(schduleDr == undefined);
	if ( (schduleDr == "") || (schduleDr == undefined) )
	{
		alert("请先选择资源!!");
		return;
	}
	var OeordTime=CTrim(Ext.getCmp("OeordTime").getValue());
	
	
	var inPatientId=Ext.getCmp("InpatientNo").getValue();
	var inPaitentName=Ext.getCmp("InpatientName").getValue();
	
	if ((inPatientId=="")||(inPaitentName==""))
	{
		alert("请输入住院号回车查询出姓名，或手工输入!");
		return;
	}
	
	var isNeedOrderTime=tkMakeServerCall("web.DHCRisResourceApptSchudle","isNeedOrderTime",schduleDr);
	if ((isNeedOrderTime=="Y")&&(OeordTime==""))
	{
		alert("请输入检查所需时间!");
		return;
	}
	
	var bookInfo=schduleDr+"^"+OeordTime+"^"+session['LOGON.USERID']+"^"+inPatientId+"^"+inPaitentName;
	//alert(bookInfo);
	var bookRet=tkMakeServerCall("web.DHCRisResourceApptSchudle","BookInpatient",bookInfo);
	//alert(bookRet);
	var retList=bookRet.split("^");
	if (retList[0]=="0")
	{
		printInPatient(inPatientId,schduleDr);
		winBook.hide();
	}
	else if (retList[0]=="-20000")  //已经有预约再此科室
	{
		alert(retList[1]);
		return;
	}
	else
	{
		alert("预约失败! code="+bookRet);
	}
}



function clickBook()
{
		//alert( Ext.getCmp("schduleRowidSel").getValue());
		var OeordTime=Ext.getCmp("OeordTime").getValue();
		var schduleDr=Ext.getCmp("schduleRowidSel").getValue();
		//alert(schduleDr == undefined);
		if ( (schduleDr == "") || (schduleDr == undefined) )
		{
			alert("请先选择资源!!");
			return;
		}
		var imageGroup = "";// Ext.getCmp("imageGroupCmb").getValue();
	  /*if ( (imageGroup=="") || (imageGroup == undefined))
	  {
	  	alert("请选择影像组!!");
	  	return;
	  }*/
		var orderList=OeorditemID;
		
		var statusRet=tkMakeServerCall("web.DHCRisBookAllResource","getOrderStatus",orderList);
		if (statusRet=="R")
		{
			alert("已经登记，不允许预约!");
			return;
		}
		else if (statusRet=="B")
		{
			alert("已经预约，请先取消预约再预约!");
			return;
			
		}
		
		//判断是否有冲突
		var conflictInfo=tkMakeServerCall("web.DHCRisPlatBook","BookedConflict",orderList,schduleDr);
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
		
		//判断是否存在互斥和前置医嘱，
		var retConflict=tkMakeServerCall("web.DHCRisPlatRelationship","GetRelationShipByOrderItem",orderList,schduleDr);
		//alert(retConflict+"1");
		var conflictInfolist=retConflict.split("&&");
		var hint="";
		for (i=0;i<conflictInfolist.length ;i++ )
		{
			if ( conflictInfolist[i]!="")
			{
				var infoConfilct=conflictInfolist[i].split("^");
				if (infoConfilct[2]!="")
				{
					if (hint=="")
					{
						hint=infoConfilct[2];
					}
					else
					{
						hint=hint+"\r\n"+infoConfilct[2];
					}
				}
			}
		}
		if (hint!="")
		{
		    var ConflictFlag=confirm(hint+"\r\n是否继续预约?");
		    if (ConflictFlag==false){return}
		}
		
		//判断是否已经登记和预约
		var LocId = "";
		var bookInfo=orderList+"^"+schduleDr+"^1^^"+locRowid+"^"+""+"^^"+session['LOGON.USERID']+"^^^"+OeordTime+"^"+imageGroup;
		//alert(bookInfo);
		//return;
		var bookRet=tkMakeServerCall("web.DHCRisResourceApptSchudle","Book",bookInfo);
		var bookRetArray=bookRet.split("^");
		if (bookRetArray[0]=="0")
		{
			alert("预约成功!");
			clickPrint();			
			winBook.hide();
			searchData();
		}
		else
		{
			//alert("预约失败! ret="+bookRet);
			alert(getBookError(bookRet));
			return;
		}
}

function getBookError(error)
{
	var errorList=error.split("^");
	var info="";
	switch (errorList[0]) {
		case "-11112":
			info="已经预约,不能重复预约!";
			break;
		case "-11111":
			info="不同患者,不允许一起预约!";
			break;
		case "-10055":
			info="此时间点已经有预约记录,不能预约!";
			break;
		case "-400":
			info="此时间段已经过时，无法预约!";
			break;
		case "-100":
			info="预约已满，请选择其他时间段!";
			break;	
		case "-300":
			info="预约已满，请选择其他时间段!";
			break;
		case "100":
			info="预约没有执行,请联系管理员!";
			break;
		default:
			info="预约失败! 返回值="+errorList;
			
	}
	return info;
}


function CardBillClick(paadmdr,PatientID,OrderRowidBody)
{
	
	var EpisodeID=paadmdr;	//就诊号
	var PatientID=PatientID;//登记号
	
	//(web.DHCRisWorkBenchDoEx).getPatMasRowid("")
	var patMasRowid=tkMakeServerCall("web.DHCRisWorkBenchDoEx","getPatMasRowid",PatientID);	
	var orderList="";
	
	var OrderRowidBodyArray=OrderRowidBody.split("@");
	for (var i=0;i<OrderRowidBodyArray.length;i++)
	{
		var orderbody=OrderRowidBodyArray[i];
		var orderbodyArray=orderbody.split("$");
		if (orderbodyArray[0]!="")
		{
			if (orderList=="")
			{
				orderList=orderbodyArray[0];
			}
			else
			{
				orderList=orderList+"^"+orderbodyArray[0];
			}
		}
		
	}
	

	var groupDR=session['LOGON.GROUPID'];
	//var mode=tkMakeServerCall("web.udhcOPBillIF","GetCheckOutMode",groupDR);
	//alert("mode=="+mode)
	var mode=1	//zfb-add 2016.7.22
    if(mode==1){
    	var cardNO="";
    	var cardNO=tkMakeServerCall("web.UDHCJFBaseCommon","GetCardNoByRegNo",patMasRowid);	//zfb-add 2016.7.22
    	//alert("cardNO=="+cardNO)
    	var insType=""; //tkMakeServerCall("web.DHCRisWorkBenchDoEx","GetFeeType",EpisodeID)	//病人费别;;
    	//alert(insType);
    	var oeoriIDStr="";
    	var guser=session['LOGON.USERID'];
    	var groupDR=session['LOGON.GROUPID'];
    	var locDR=session['LOGON.CTLOCID'];
    	var hospDR=session['LOGON.HOSPID']; 
    	//alert(cardNO+"^"+patMasRowid+"^"+EpisodeID+"^"+insType+"^"+orderList+"^"+guser+"^"+groupDR+"^"+locDR+"^"+hospDR);
    	var rtn=checkOut(cardNO,patMasRowid,"",insType,orderList,guser,groupDR,locDR,hospDR);
    	//alert("卡消费返回="+rtn);
    	return;	
    }
}


function clickCancelBook()
{
	var OeordTime=Ext.getCmp("OeordTime").getValue();
	var schduleDr=Ext.getCmp("schduleRowidSel").getValue();
	var imageGroup = "";
	var orderList=OeorditemID;
	var statusRet=tkMakeServerCall("web.DHCRisBookAllResource","getOrderStatus",orderList);
	if (statusRet=="R")
	{
		alert("已经登记，不允许取消预约!");
		return;
	}
	if (statusRet=="")
	{
		alert("申请状态，不能取消预约!");
		return;
	}
	//var ret = tkMakeServerCall("web.DHCRisAppointmentDo","DeleteBookInfo",orderList);
	//var CancelBookInfo=orderList+"^"+schduleDr+"^1^^"+locRowid+"^"+""+"^^"+session['LOGON.USERID']+"^^^"+OeordTime+"^"+imageGroup;
	//alert(CancelBookInfo);
	var ret = tkMakeServerCall("web.DHCRisResourceApptSchudle","CancelBook",orderList,session['LOGON.USERID']);
	if (ret.split("^")[0]!="0")
	{
		alert("取消预约失败!ret="+ret);	
	}
	else
	{
		alert("取消预约成功!");
		Ext.getCmp("bookRes").setValue("");
	   Ext.getCmp("bookDate").setValue("");
	   Ext.getCmp("bookTime").setValue("");
	  Ext.getCmp("bookSchduleRowid").setValue("");
	  //2019/08/20自动关闭预约窗口，刷新工作列表
	  winBook.hide();
	  searchData();
	  var obj = opener.document.getElementById("btnFind");
			if (obj)
				obj.click();
	}
}
function clickPrint()
{
	
	try 
	{
		//alert(locRowid);
	      var orderList=OeorditemID;
	      //alert(orderList);
			var gPrintTemplate=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetLocBookedPrintTemplate",locRowid);
			    if (gPrintTemplate=="")     //"DHCRisApp" 
			    {
				   alert("请先配置打印模板!");
				   return;
			    }
			    DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
   				
   				//增加医院名称获取
				var hospitalDesc=tkMakeServerCall("web.DHCRisCommFunction","getHospitalDesc",locRowid);
	
		   		var bookInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBookedPrintByloc",orderList);
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
				 	  var addlist=Address.split(":");
				 	  if (addlist.length==2)
				 	  {
					 	  var Adress=Address.split(":")[0];
					 	  var RegAdd=Address.split(":")[1];
				 	  }
				 	  else
				 	  {
					 	  var Adress=Address;
					 	  var RegAdd="";
				 	  }
		
				 	  var oderInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetSmartPrint",orderList);
				 	  //alert(oderInfo)
				 	  
				 	  var strOrderName=oderInfo.split("^")[0];
				 	  var Memo=oderInfo.split("^")[1];
				 	  
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
			     
			    // var orderName =Items[24];   //医嘱名称
			     //orderName=changePrintInfo(orderName);

			     var appDoc = Items[21];     //申请医生
			    //  var Memo = Items[23]; 
			     //var printDate = GetCurrentDate();   //打印日期
			     var CardNo=Items[25]; 
			     
			     var MyPara="PatientName"+String.fromCharCode(2)+patientName;
				   //MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+"*"+OeItemID+"*";
				   MyPara=MyPara+"^RegNoL"+String.fromCharCode(2)+"*"+patientID+"*";
				   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+patientID;
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
				   //MyPara=MyPara+"^PrintDate"+String.fromCharCode(2)+printDate;
				   MyPara=MyPara+"^Memo"+String.fromCharCode(2)+Memo
		   			MyPara=MyPara+"^StarTime"+String.fromCharCode(2)+BookedTime
		   			MyPara=MyPara+"^Address"+String.fromCharCode(2)+Adress;
		   			MyPara=MyPara+"^RegAdd"+String.fromCharCode(2)+RegAdd;
		   			MyPara=MyPara+"^CardNo"+String.fromCharCode(2)+CardNo;
		   			MyPara=MyPara+"^HospitalDesc"+String.fromCharCode(2)+hospitalDesc;
		   		//alert(MyPara);
		   		var myobj=document.getElementById("ClsBillPrint");
		   		//DHCP_PrintFun(myobj,MyPara,"");
		   		//DHCP_XMLPrint(myobj,MyPara,"");
		   		DHCP_PrintFunHDLP("",MyPara,"");		
				
				/*
				DHCP_GetXMLConfig("InvPrintEncrypt","DHCRisReg_QPPZ");
				DHCP_PrintFun(myobj,MyPara,"");
				
				var regTemplate=tkMakeServerCall("web.DHCRisPatRegisterDoEx","GetLocPrintTemplate",locRowid);     //="DHCRisReg" // 
			    if (regTemplate!="")
			    {
				    MyPara=MyPara+"^Date"+String.fromCharCode(2)+BookedDate;
				    DHCP_GetXMLConfig("InvPrintEncrypt",regTemplate.split(":")[1]);
				    DHCP_PrintFun(myobj,MyPara,"");
				    DHCP_PrintFun(myobj,MyPara,"");
				    DHCP_PrintFun(myobj,MyPara,"");
			    }
				*/
			}
				//serviceOrderGrid.getStore().getAt(index).set('isPrint',false);
	}
		     
	
	catch(e) 
	{
		alert(e.message);
	}
        
}


function changePrintInfo(info)
{
	
	var info1=ignoreSpaces(info);
	info1=info1.replace(/\r|\n/g,"");
	info1=info1.substring(0,15)+"\\r\\n"+info1.substring(15,30);
	return info1;
}



function ignoreSpaces(string) 
{
  var temp = "";
  string = '' + string;
  splitstring = string.split(" "); //双引号之间是个空格?
  for(i = 0; i < splitstring.length; i++)
  {
	 temp += splitstring[i];
  }
  return temp
}




function printInPatient(patientId,ResScheduleID)
{
	//alert(patientId+"^"+ResScheduleID);
	try 
	{
		var gPrintTemplate=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetLocBookedPrintTemplate",locRowid);
		if (gPrintTemplate=="")     //"DHCRisApp" 
		{
			alert("请先配置打印模板!");
			return;
		}
		gPrintTemplate=gPrintTemplate+"_ZY";
		//alert(gPrintTemplate);
		DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
		//patientID_"^"_patName_"^"_bookDate_"^"_bookStime_"^"_bookEtime_"^"_bookNum_"^"_ResourceDesc_"^"_EQAddress_"^"_LocDesc_"^"_LocAddress
		var bookInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBookInfoInpatient",patientId,ResScheduleID);
	    //alert(bookInfo);
		if(bookInfo!="")
		{
			//Find=1;
			Items=bookInfo.split("^");
			var ResourceDesc=Items[6];      //预约资源    
			var BookedDate=Items[2];        //预约日期
			var BookedTime=Items[3];        //预约时间
			var BookEndTime=Items[4];
			var recLoc=Items[8];           //接收科室
			var IndexBook=Items[5];         //预约流水号
			var Address=Items[7];    //物理地址
			if (Address.split(":").length==2)
			{
				var Adress=Address.split(":")[0];
				var RegAdd=Address.split(":")[1];
			}
			else
			{
				var Adress=Address;
				var RegAdd="";
			}
			var patientID = Items[0];   //登记号
			var medicareNo= "";    //病案号
			var patientName = Items[1]; //姓名
			var sex = "";         //性别
			var age = "";         //年龄
			
			var MyPara="PatientName"+String.fromCharCode(2)+patientName;
			//MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+"*"+OeItemID+"*";
			MyPara=MyPara+"^RegNoL"+String.fromCharCode(2)+"*"+patientID+"*";
			MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+patientID;
			MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate
			MyPara=MyPara+"^Bookedtime"+String.fromCharCode(2)+BookedTime+"-"+BookEndTime;
			MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+recLoc;
			//MyPara=MyPara+"^OrderDate"+String.fromCharCode(2)+strItmDate;
			MyPara=MyPara+"^index"+String.fromCharCode(2)+IndexBook;
			//MyPara=MyPara+"^OrderName"+String.fromCharCode(2)+strOrderName;
			MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+ResourceDesc;

			//MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+medicareNo;
			//MyPara=MyPara+"^Age"+String.fromCharCode(2)+age;
			//MyPara=MyPara+"^Sex"+String.fromCharCode(2)+sex;
			//MyPara=MyPara+"^WardName"+String.fromCharCode(2)+ward;
			//MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+bedNo;				   
			//MyPara=MyPara+"^IdCard"+String.fromCharCode(2)+idCard;
			//MyPara=MyPara+"^TeleNo"+String.fromCharCode(2)+teleNo;
			//MyPara=MyPara+"^AppLoc"+String.fromCharCode(2)+appLoc;

			//MyPara=MyPara+"^AppDoc"+String.fromCharCode(2)+appDoc;

			MyPara=MyPara+"^StarTime"+String.fromCharCode(2)+BookedTime
			MyPara=MyPara+"^Address"+String.fromCharCode(2)+Adress;
			MyPara=MyPara+"^RegAdd"+String.fromCharCode(2)+RegAdd;
			//alert(MyPara);
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,MyPara,"");
		}
		
	}
	catch(e) 
	{
		alert(e.message);
	}
        
}
