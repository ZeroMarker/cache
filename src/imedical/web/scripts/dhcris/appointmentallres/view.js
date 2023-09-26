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
    fieldLabel:'��Դ',
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
	fieldLabel : 'Ӱ����',
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
						fieldLabel:'��&nbsp;&nbsp;&nbsp;��',
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
						fieldLabel:'����ID',
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
						fieldLabel:'�Ա�',
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
						fieldLabel:'����',
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
					fieldLabel:'ԤԼ����',
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
					fieldLabel:'ԤԼʱ��',
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
					fieldLabel:'��Դ',
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
					fieldLabel:'�����Ŀ',
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
			fieldLabel:'ע������',
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
			fieldLabel:'��������',
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
					text:'��һҳ',
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
					text:'��һҳ',
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
					text:'ԤԼ',
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
					text:'ȡ��ԤԼ',
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
					text:'ˢ��',
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
					text:'��ӡԤԼ��',
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
	
	//1 �����  2 ���ʱ��
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
	title:'ԤԼ������Ϣ',
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
    fieldLabel:'ʱ��',  
    //width:100,
    width:90,
    format:'H:i',
    empty:'��ѡ��ʱ��',  
    minValue:'8:00 AM',  
    maxValue:'17:00 PM',  
    increment:20,  
    //renderTo: Ext.get('timeField'),
    invalidText:'���ڸ�ʽ��Ч����ѡ��ʱ���������Ч��ʽ��ʱ��'  
});  





 
var inpatientFiledset = new Ext.form.FieldSet({
	title:'סԺ����',
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
					fieldLabel:'סԺ��',
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
					fieldLabel:'סԺ��������',
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
					fieldLabel:'���ʱ��',
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
					text:'סԺԤԼ',
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
		alert("����ѡ����Դ!!");
		return;
	}
	var OeordTime=CTrim(Ext.getCmp("OeordTime").getValue());
	
	
	var inPatientId=Ext.getCmp("InpatientNo").getValue();
	var inPaitentName=Ext.getCmp("InpatientName").getValue();
	
	if ((inPatientId=="")||(inPaitentName==""))
	{
		alert("������סԺ�Żس���ѯ�����������ֹ�����!");
		return;
	}
	
	var isNeedOrderTime=tkMakeServerCall("web.DHCRisResourceApptSchudle","isNeedOrderTime",schduleDr);
	if ((isNeedOrderTime=="Y")&&(OeordTime==""))
	{
		alert("������������ʱ��!");
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
	else if (retList[0]=="-20000")  //�Ѿ���ԤԼ�ٴ˿���
	{
		alert(retList[1]);
		return;
	}
	else
	{
		alert("ԤԼʧ��! code="+bookRet);
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
			alert("����ѡ����Դ!!");
			return;
		}
		var imageGroup = "";// Ext.getCmp("imageGroupCmb").getValue();
	  /*if ( (imageGroup=="") || (imageGroup == undefined))
	  {
	  	alert("��ѡ��Ӱ����!!");
	  	return;
	  }*/
		var orderList=OeorditemID;
		
		var statusRet=tkMakeServerCall("web.DHCRisBookAllResource","getOrderStatus",orderList);
		if (statusRet=="R")
		{
			alert("�Ѿ��Ǽǣ�������ԤԼ!");
			return;
		}
		else if (statusRet=="B")
		{
			alert("�Ѿ�ԤԼ������ȡ��ԤԼ��ԤԼ!");
			return;
			
		}
		
		//�ж��Ƿ��г�ͻ
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
					var info=infoConfilct[0]+" ("+infoConfilct[1]+") �Ѿ�ԤԼ�� "+infoConfilct[3]+" "+infoConfilct[4];
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
				var ConflictFlag=confirm(hint+",\r\n�Ƿ����ԤԼ?");
			    if (ConflictFlag==false){return}
			}
		}
		
		//�ж��Ƿ���ڻ����ǰ��ҽ����
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
		    var ConflictFlag=confirm(hint+"\r\n�Ƿ����ԤԼ?");
		    if (ConflictFlag==false){return}
		}
		
		//�ж��Ƿ��Ѿ��ǼǺ�ԤԼ
		var LocId = "";
		var bookInfo=orderList+"^"+schduleDr+"^1^^"+locRowid+"^"+""+"^^"+session['LOGON.USERID']+"^^^"+OeordTime+"^"+imageGroup;
		//alert(bookInfo);
		//return;
		var bookRet=tkMakeServerCall("web.DHCRisResourceApptSchudle","Book",bookInfo);
		var bookRetArray=bookRet.split("^");
		if (bookRetArray[0]=="0")
		{
			alert("ԤԼ�ɹ�!");
			clickPrint();			
			winBook.hide();
			searchData();
		}
		else
		{
			//alert("ԤԼʧ��! ret="+bookRet);
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
			info="�Ѿ�ԤԼ,�����ظ�ԤԼ!";
			break;
		case "-11111":
			info="��ͬ����,������һ��ԤԼ!";
			break;
		case "-10055":
			info="��ʱ����Ѿ���ԤԼ��¼,����ԤԼ!";
			break;
		case "-400":
			info="��ʱ����Ѿ���ʱ���޷�ԤԼ!";
			break;
		case "-100":
			info="ԤԼ��������ѡ������ʱ���!";
			break;	
		case "-300":
			info="ԤԼ��������ѡ������ʱ���!";
			break;
		case "100":
			info="ԤԼû��ִ��,����ϵ����Ա!";
			break;
		default:
			info="ԤԼʧ��! ����ֵ="+errorList;
			
	}
	return info;
}


function CardBillClick(paadmdr,PatientID,OrderRowidBody)
{
	
	var EpisodeID=paadmdr;	//�����
	var PatientID=PatientID;//�ǼǺ�
	
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
    	var insType=""; //tkMakeServerCall("web.DHCRisWorkBenchDoEx","GetFeeType",EpisodeID)	//���˷ѱ�;;
    	//alert(insType);
    	var oeoriIDStr="";
    	var guser=session['LOGON.USERID'];
    	var groupDR=session['LOGON.GROUPID'];
    	var locDR=session['LOGON.CTLOCID'];
    	var hospDR=session['LOGON.HOSPID']; 
    	//alert(cardNO+"^"+patMasRowid+"^"+EpisodeID+"^"+insType+"^"+orderList+"^"+guser+"^"+groupDR+"^"+locDR+"^"+hospDR);
    	var rtn=checkOut(cardNO,patMasRowid,"",insType,orderList,guser,groupDR,locDR,hospDR);
    	//alert("�����ѷ���="+rtn);
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
		alert("�Ѿ��Ǽǣ�������ȡ��ԤԼ!");
		return;
	}
	if (statusRet=="")
	{
		alert("����״̬������ȡ��ԤԼ!");
		return;
	}
	//var ret = tkMakeServerCall("web.DHCRisAppointmentDo","DeleteBookInfo",orderList);
	//var CancelBookInfo=orderList+"^"+schduleDr+"^1^^"+locRowid+"^"+""+"^^"+session['LOGON.USERID']+"^^^"+OeordTime+"^"+imageGroup;
	//alert(CancelBookInfo);
	var ret = tkMakeServerCall("web.DHCRisResourceApptSchudle","CancelBook",orderList,session['LOGON.USERID']);
	if (ret.split("^")[0]!="0")
	{
		alert("ȡ��ԤԼʧ��!ret="+ret);	
	}
	else
	{
		alert("ȡ��ԤԼ�ɹ�!");
		Ext.getCmp("bookRes").setValue("");
	   Ext.getCmp("bookDate").setValue("");
	   Ext.getCmp("bookTime").setValue("");
	  Ext.getCmp("bookSchduleRowid").setValue("");
	  //2019/08/20�Զ��ر�ԤԼ���ڣ�ˢ�¹����б�
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
				   alert("�������ô�ӡģ��!");
				   return;
			    }
			    DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
   				
   				//����ҽԺ���ƻ�ȡ
				var hospitalDesc=tkMakeServerCall("web.DHCRisCommFunction","getHospitalDesc",locRowid);
	
		   		var bookInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBookedPrintByloc",orderList);
				//alert(bookInfo);
				if(bookInfo!="")
				{
					  //Find=1;
					  Items=bookInfo.split("^");
				 	 // var OeItemID=oeOrdDr; 
				 	  var ResourceDesc=Items[2];      //ԤԼ��Դ    
				 	  var BookedDate=Items[3];        //ԤԼ����
				 	  var BookedTime=Items[4];        //ԤԼʱ��
				 	  var BookEndTime=Items[5];
				 	  //var PrintFlag=Items[21];
				 	  //var MeothodDesc=Items[22];
				 	  //var RecLocDR=Items[23];
				 	  var recLoc=Items[6];           //���տ���
				 	  var strItmDate=Items[10]+"  "+Items[11];   //ҽ������
				 	  var IndexBook=Items[9];         //ԤԼ��ˮ��
				 	  var Address=Items[12];    //�����ַ
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
				 	  
			      var patientID = Items[13];   //�ǼǺ�
			      var medicareNo= Items[14];    //������
			     	var patientName = Items[15]; //����
			     	var sex = Items[16];         //�Ա�
			      var age = Items[17];         //����
			     
			     	var pattype=Items[18];
			     	//if (pattype=="I")
			      {
		          var ward = Items[19];    //����
			        var bedNo = Items[18];   //����
				    }
		        //else
		        {
							var idCard = Items[15];    //���֤��
							var teleNo = Items[14];    //�绰��      
			      }
			     //SetExcelCell(xlsheet,j+4);
			    
			     var appLoc = Items[22];    //�������
			    
			    // var patientNow = PrintItem[23];  //�ٴ�����
			    
			     //var purpose = PrintItem[24];     //���Ŀ��

			     //var diagnose = PrintItem[25];     //���
			     
			    // var orderName =Items[24];   //ҽ������
			     //orderName=changePrintInfo(orderName);

			     var appDoc = Items[21];     //����ҽ��
			    //  var Memo = Items[23]; 
			     //var printDate = GetCurrentDate();   //��ӡ����
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
  splitstring = string.split(" "); //˫����֮���Ǹ��ո�?
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
			alert("�������ô�ӡģ��!");
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
			var ResourceDesc=Items[6];      //ԤԼ��Դ    
			var BookedDate=Items[2];        //ԤԼ����
			var BookedTime=Items[3];        //ԤԼʱ��
			var BookEndTime=Items[4];
			var recLoc=Items[8];           //���տ���
			var IndexBook=Items[5];         //ԤԼ��ˮ��
			var Address=Items[7];    //�����ַ
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
			var patientID = Items[0];   //�ǼǺ�
			var medicareNo= "";    //������
			var patientName = Items[1]; //����
			var sex = "";         //�Ա�
			var age = "";         //����
			
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
