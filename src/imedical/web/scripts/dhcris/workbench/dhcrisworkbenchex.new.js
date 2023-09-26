//dhcrisworkbenchex.new.js ,
    var UserRowID=session['LOGON.USERID'];
    // alert(UserRowID);
  	var CTLOCID=session['LOGON.CTLOCID'];
  	var Char0=String.fromCharCode(0);
  	var Char1=String.fromCharCode(1);
  	var Char2=String.fromCharCode(2);
  	var EpisodeID="" ;
  	var PatientID="" ;
	var lockRecDepId="";
	PrtAryData=new Array()
	
	//alert("new.js");
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

   //===========模块主页面===============================================
    var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : CarrierGrid ,
					renderTo : 'mainPanel'
				});
	  RefreshGridColSet(CarrierGrid,"DHCRisWorkBenchex");
	  InitLockData();
	  searchData();
	   Ext.getCmp('CardNo').focus(false,10);  ///光标定位
  //===========模块主页面===============================================


	

});


	var RisStatusStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetRisStatus&UserRowID="+UserRowID
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
		//baseParams:{LocId:'',Desc:''}
	});

	RisStatusStore.load();
	var RisStatus = new Ext.form.ComboBox({
		fieldLabel : '状态',
		mode:'local',
		id : 'RisStatus',
		name : 'RisStatus',
		store : RisStatusStore,
		width : 130,
		triggerAction :"all",
		valueField : 'RowId',
		displayField : 'Description'
	}); 






	/// 接收科室
	var RecDepStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetRecDep&UserRowID="+UserRowID
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
	});
	RecDepStore.load();
	RecDepStore.on("load", function(){
		if (lockRecDepId!="") Ext.getCmp('RecDep').setValue(lockRecDepId);
		else Ext.getCmp('RecDep').setValue(CTLOCID);
	});

	var RecDep = new Ext.form.ComboBox({
		fieldLabel : '接收科室',
		mode:'local',
		id : 'RecDep',
		name : 'RecDep',
		store : RecDepStore,
		valueField : 'RowId',
		listWidth:160,
		width:160,
		triggerAction :"all",
		displayField : 'Description'
	});
	
	var CardTypeStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetCardType"
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
	});
	
	CardTypeStore.load();
	CardTypeStore.on("load", function(){
		Ext.getCmp('CardType').setValue(CardTypeStore.getAt(0).get('RowId'));
	});

	var CardType = new Ext.form.ComboBox({
		fieldLabel : '卡类型',
		mode:'local',
		id : 'CardType',
		name : 'CardType',
		store : CardTypeStore,
		width : 80,
		valueField : 'RowId',
		triggerAction :"all",
		value: 0,
		displayField : 'Description'
	}); 
	
	var CardNo = new Ext.form.TextField({
    	id:'CardNo',
   	 	fieldLabel:'卡号',
   	 	enableKeyEvents : true,
		initEvents: function() {  
		   var keyPress = function(e){  
		       if (e.getKey() == e.ENTER && this.getValue().length > 0) {  
		       		CardNokeydown();
		       }  
		   };  
		    this.el.on("keypress", keyPress, this);  
		} ,
    	selectOnFocus:true
	});
	
	var PatientNo = new Ext.form.TextField({
    	id:'PatientNo',
   	 	fieldLabel:'登记号',
   	 	enableKeyEvents : true,
		initEvents: function() {  
		   var keyPress = function(e){  
		       if (e.getKey() == e.ENTER && this.getValue().length > 0) {  
		           searchData();
		       }  
		   };  
		    this.el.on("keypress", keyPress, this);  
		} ,
    	selectOnFocus:true
	});	
	


	var StartDate = new Ext.form.DateField({
		fieldLabel : '开始日期',
		id : 'StartDate',
		name : 'StartDate',
		//format : 'Y-m-d',		
		value : new Date()
	});
	
	var EndDate = new Ext.form.DateField({
		fieldLabel : '结束日期',
		id : 'EndDate',
		name : 'EndDate',
		//format : 'Y-m-d',
		value : new Date()
	});

	var LockFlag = new Ext.form.Checkbox({
		boxLabel : '锁定',
		id : 'LockFlag',
		name : 'LockFlag',
		checked : false,
		listeners : { 
			"check" : function(obj,ischecked){
				SetLockValue(ischecked);
			}}
	});

	var ReadCardBtn = new Ext.Button({
	    text:'读卡',
	    iconCls:'btn-ris-readcard',
	    handler:function(){
		    FunReadCard();
	    }
	});

	
var FunReadCard= function ()
{
	/*var CardType=Ext.getCmp("CardType").getValue()
    var myoptval=tkMakeServerCall('web.DHCRisCommFunctionNew','GetCardTypeDefault',CardType);
    
    var myrtn=DHCACC_GetAccInfo(CardType,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	*/
	var CardType=Ext.getCmp("CardType").getValue();
	//web.UDHCOPOtherLB.ReadCardTypeDefineListBroker  "DHCWeb_AddToListA","CardTypeDefine"
    var myoptval=tkMakeServerCall('web.DHCRisCommFunctionNew','GetCardTypeDefault',CardType);
	var myary=myoptval.split("^");
	var CardTypeRowId=myary[0];
	
    var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
    var CardSubInform=myrtn.split("^");
    var rtn=CardSubInform[0];
	//var CardNo=CardSubInform[1];
	/*
    switch (rtn){
	        case "0": //卡有效
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				FindPatDetail()
				break;
	        case "-201": 
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				FindPatDetail()
				break;
			case "-200": //卡无效
				alert("卡无效");
				PapmiNoObj=document.getElementById("PatNo");
    			PapmiNoObj.value="";
				break;
			default:
				break;
		}
	GSelectAdmRowid=""	
	*/
	//alert(rtn);
	switch (rtn)
	{
		case "0":
			Ext.getCmp("PatientNo").setValue(CardSubInform[5])
			Ext.getCmp("CardNo").setValue(CardSubInform[1])
			//PatientID=CardSubInform[4];
		    //GetPatientInfo();
			searchData();		
			break;
		case "-200":
			break;
		case "-201":
			Ext.getCmp("PatientNo").setValue(CardSubInform[5])
			Ext.getCmp("CardNo").setValue(CardSubInform[1])
			//PatientID=CardSubInform[4];
		    searchData();
		default:
	}
}	



var CardNokeydown= function()
{
	var CardNo = Ext.getCmp("CardNo").getValue();
	if ((CardNo=="")||(CardNo==Char0)) return "";
	CardNo=formatNo(CardNo);

	var len=CardNo.length;
	var CardType=Ext.getCmp("CardType").getValue()
    var myoptval=tkMakeServerCall('web.DHCRisCommFunctionNew','GetCardTypeDefault',CardType);
	//alert(myoptval);
	var typelen=myoptval.split("^")[17]
	//alert(typelen)
	if (len<typelen){
		for (var i=1;i<=(typelen-len);i++){
			CardNo="0"+CardNo;
		}
	}
	var regNo=tkMakeServerCall('web.DHCRisCommFunctionNew','GetRegNoByCardNo',CardType,CardNo);
	Ext.getCmp("CardNo").setValue(CardNo);
	Ext.getCmp("PatientNo").setValue(regNo);
	if (regNo=="")
	{
		CarrierGridDs.removeAll();
		return false;
	}
	searchData();
	return false;
}
			
var findBtn = new Ext.Button({
	id:'btnFind',
	cls:'btn-turn-on',
	iconCls:'btn-ris-find',
    text:'查询',
    //width:60,
    //height:30,
    handler:function(){
	    searchData();
    }
});

var ExportBtn = new Ext.Button({
    text:'导出',
    iconCls:'btn-ris-export',
    handler:function(){
	    ExportList_onclick();
    }
});



var GridColSetBT = new Ext.Button({
    text:'列设置',
    iconCls:'page_gear',
    handler:function(){
    	GridColSet(CarrierGrid,"DHCRisWorkBenchex");
    }
});	

var ClearBT = new Ext.Toolbar.Button({
    text:'清屏',
    iconCls:'btn-ris-clearscreen',
    handler:function(){
	    Ext.getCmp("LockFlag").setValue();
    	Ext.getCmp("CardNo").setValue();
    	Ext.getCmp("PatientNo").setValue();
    	Ext.getCmp("RecDep").setValue(CTLOCID);
    	Ext.getCmp("RisStatus").setValue();
    	Ext.getCmp("StartDate").setValue(new Date());
    	Ext.getCmp("EndDate").setValue(new Date());
    }
}); 





var RegBtn = new Ext.Button({
    text:'登记',
    width:50,
    //height:50,
    iconCls:'btn-ris-register',
    handler:function(){
	  	//alert(CarrierGrid);
	  	//console.log(CarrierGrid);
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			
	    	var LocDR="";
  			var PaadmDR="";
  			var orderList="";
  			var patientId="";
  			var orderArray={};
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	  			var LocDRGet=row.get('RecLocId');
	  			
	  			var patientIdGet=row.get('Tregno');
	  			if ( patientId=="")
	  			{
	  				patientId=patientIdGet;
	  			}
	  			else
	  			{
	  				if (patientId!=patientIdGet)
	  				{
	  					alert("不同病人不能一起登记!");
	  					return;
	  				}
	  			}
	  			if (LocDR =="")
	  			{
	  				LocDR=LocDRGet;
	  			}
	  			else
	  			{
	  				if (LocDR!=LocDRGet)
	  				{
	  					alert("接收科室不同，不允许一起登记!");
	  					return;
	  				}
	  			}
	  			
	      	PaadmDR=row.get('Tpaadmdr');
	      	
	      	var studyNo=row.get('TStudyNo');
	      	if(studyNo!="")
	      	{
		      	alert("已登记的记录不需要再登记 !");
		      	return false;
	      	}
	      	var OeorditemID=row.get('TOeorditemdr');
	      	var bodyCode=row.get('BodyCode');
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
				//alert(orderBodyList);
				RegRisEx(CarrierGrid,LocDR,PaadmDR,orderBodyList,"","");
				return;
  		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});	



var RegCSBtn = new Ext.Button({
    text:'超声扣费登记',
    width:100,
    cls:'orderbtn',
    //height:50,
    handler:function(){
	  	//alert(CarrierGrid);
	  	//console.log(CarrierGrid);
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			
	    	var LocDR="";
  			var PaadmDR="";
  			var orderList="";
  			var patientId="";
  			var orderArray={};
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	  			var LocDRGet=row.get('RecLocId');
	  			if ((LocDRGet!="402")&&(LocDRGet!="438")&&(LocDRGet!="458")&&(LocDRGet!="565")&&(LocDRGet!="3458"))
	  			{
		  			alert("非超声科，不允许此操作!");
		  			return;
	  			}
	  			var patientIdGet=row.get('Tregno');
	  			if ( patientId=="")
	  			{
	  				patientId=patientIdGet;
	  			}
	  			else
	  			{
	  				if (patientId!=patientIdGet)
	  				{
	  					alert("不同病人不能一起登记!");
	  					return;
	  				}
	  			}
	  			if (LocDR =="")
	  			{
	  				LocDR=LocDRGet;
	  			}
	  			else
	  			{
	  				if (LocDR!=LocDRGet)
	  				{
	  					alert("接收科室不同，不允许一起登记!");
	  					return;
	  				}
	  			}
	  			
	      	PaadmDR=row.get('Tpaadmdr');
	      	
	      	var studyNo=row.get('TStudyNo');
	      	if(studyNo!="")
	      	{
		      	alert("已登记的记录不需要再登记 !");
		      	return false;
	      	}
	      	var OeorditemID=row.get('TOeorditemdr');
	      	var bodyCode=row.get('BodyCode');
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
  			
  			var isCharge=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","isChargeOrderList",orderBodyList);
			if (isCharge=="N")
			{
			 	var patMasRowid=tkMakeServerCall("web.DHCRisWorkBenchDoEx","getPatMasRowid",patientId);
				var OrderRowidBodyArray=orderBodyList.split("@");
	
				var orderList="";
	
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
				
				var mode=1;	//zfb-add 2016.7.22
		    	var cardNO="";
		    	var cardNO=tkMakeServerCall("web.UDHCJFBaseCommon","GetCardNoByRegNo",patMasRowid);	//zfb-add 2016.7.22
		    	
		    	var insType=tkMakeServerCall("web.DHCRisWorkBenchDoEx","GetFeeType",PaadmDR)	//病人费别;;
		    	//alert(insType);
		    	var oeoriIDStr="";
		    	var guser=session['LOGON.USERID'];
		    	var groupDR=session['LOGON.GROUPID'];
		    	//var locDR=session['LOGON.CTLOCID'];
		    	var hospDR=session['LOGON.HOSPID']; 
		    	//alert(cardNO+"^"+patMasRowid+"^"+EpisodeID+"^"+insType+"^"+orderList+"^"+guser+"^"+groupDR+"^"+LocDR+"^"+hospDR);
		    	var rtn=checkOut(cardNO,patMasRowid,"",insType,orderList,guser,groupDR,LocDR,hospDR);
			}
  			
  			var regInfo=orderBodyList+"^"+""+"^"+""+"^"+""+"^"+session['LOGON.USERID']+"^"+""+"^"+""+"^"+""+"^"+""+"^"+LocDR;
	 
   			var ret = tkMakeServerCall("web.DHCRisRegisterPatientDoEx","register",regInfo);
   			if (ret=="-10001")
			 {
				alert('病人未交费不能登记!');
				return false;
			 }
	 
			 if (ret=="-10002")
		     {
				 alert('不同就诊不能一起登记!');
				 return false;
			 }
			 if (ret=="-10003")
			 {
				 alert('病人已出院不能登记!');
				 return false;
			 }
			 if (ret=="-10004")
			 {
				alert('病人欠费不能登记!');
				return false;
			 }
			 if (ret=="-10005")
			 {
				 //向集成平台发送消息失败
				 alert('检查号重复不能登记!');
				 return false;                             
			 }
			 if (ret=="-10006")
			 {
				 //向集成平台发送消息失败
				 alert("选中项目存在停止医嘱不能登记!");
				 return false;                             
			 }
			 else if (ret!="0")
		     {
					alert("SQLCODE=:"+ret);
					return false;
		     }
		     else
		     {
		     	alert('登记成功!');
		     	OrditemSelected();
		     	printRegInfo();
		     }
				//RegRisEx(CarrierGrid,LocDR,PaadmDR,orderBodyList,"","");
			return;
  		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});


var RegPrintBtn = new Ext.Button({
    text:'补打登记条',
    width:100,
    iconCls:'btn-ris-print',
    //cls:'orderbtn',
    //height:50,
    handler:function(){
	  	//alert(CarrierGrid);
	  	//console.log(CarrierGrid);
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			
	    	var LocDR="";
  			var PaadmDR="";
  			var orderList="";
  			var patientId="";
  			var studyNo="";
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	  			var LocDRGet=row.get('RecLocId');
	  			
	  			
	      		if (LocDR =="")
	  			{
	  				LocDR=LocDRGet;
	  			}
	  			else
	  			{
	  				if (LocDR!=LocDRGet)
	  				{
	  					alert("接收科室不同!");
	  					return;
	  				}
	  			}
		      	var studyNoGet=row.get('TStudyNo');
		      	if(studyNoGet=="")
		      	{
			      	alert("请先登记 !");
			      	return false;
		      	}
		      	if (studyNo =="")
	  			{
	  				studyNo=studyNoGet;
	  			}
	  			else
	  			{
	  				if (studyNo!=studyNoGet)
	  				{
	  					alert("没有同时登记，不能一起打印!");
	  					return;
	  				}
	  			}
	      	
  			}
  			
  			
		   	printRegInfo();
  		}
    }
});



function printRegInfo()
{
	
	try 
	{
		var GetRegNo="";
		var GetRecLocDR="";

		var OEOrdStr="",BodyCodeStr="" ;
		var studyNo="";
		var gsm = CarrierGrid.getSelectionModel();
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	        var row = rows[0];
	      	GetRegNo=row.get('Tregno');
	      	GetRecLocDR=row.get('RecLocId');
	      	studyNo=row.get('TStudyNo');
	    
	    }
		if (studyNo=="")
		{
			return;
		}
		var gPrintTemplate=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","GetLocPrintTemplate",GetRecLocDR);     //="DHCRisReg" // 
		if (gPrintTemplate=="")
		{
			alert("请先配置打印模板!");
			return;
		}
		

		DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);

		var PrintData=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","GetRegBillDataNew",studyNo);
		//alert(PrintData);
		if (PrintData!="")
		{

			           var Item=PrintData.split("^");
                       var StudyNo=Item[0];
                       var PatientID=Item[1];
                       var PatientName=Item[2];
                       var Sex=Item[3];
                       var Age=Item[4];
                       var RecLoc=Item[5];
                       //var OrdItemName=Item[6];
                       var IndexType=Item[6];
                       var GetIndex=Item[7];
                       var EQDesc=Item[8];
                       var Room=Item[9];
                       var GroupDesc=Item[10];
                       var Patienttype=Item[11];
                       var INPNO=Item[12];
                       var OPNO=Item[13];
                       var InLocName=Item[14];
                       var BedCode=Item[15];
                       var DeviceDR=Item[16];
                       var No=Item[17];
                       var RegDate=Item[18];
                       var RegTime=Item[19];
			     	   var CardNo=Item[24];
			     	   var OrdItemName=Item[25]
			var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
			MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
			MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
			MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
			MyPara=MyPara+"^MRI"+String.fromCharCode(2)+No;
			MyPara=MyPara+"^Date"+String.fromCharCode(2)+RegDate;
			MyPara=MyPara+"^StudyNo"+String.fromCharCode(2)+StudyNo;
			MyPara=MyPara+"^Time"+String.fromCharCode(2)+RegTime;

			MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+RecLoc;
			MyPara=MyPara+"^ItemName"+String.fromCharCode(2)+OrdItemName;
			MyPara=MyPara+"^Room"+String.fromCharCode(2)+Room;
			MyPara=MyPara+"^RoomIndex"+String.fromCharCode(2)+GetIndex;
			MyPara=MyPara+"^CardNo"+String.fromCharCode(2)+CardNo;
			//MyPara=MyPara+"^LStudyNo"+String.fromCharCode(2)+LStudyNo;


			
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFunHDLP("",MyPara,"");
					

		}

	}
	
	catch(e) 
	{
		alert(e.message);
	}
        
}

var winPreViewAppBill;
var preViewAppBillBtn = new Ext.Button({
    text:'预览申请单',
    iconCls:'btn-ris-prview',
    width:100,
    height:50,
    handler:function(){
	  	var link="";
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			
	    	var LocDR="";
  			var appbillNo="";
  			
	  		for(var i=0;i<rows.length;i++)
	  		{
		  		var row=rows[i];
		  		var appbillNoGet= row.get('AppBillNo');
		  		if (appbillNo=="")
		  		{
			  		appbillNo=appbillNoGet;
		  		}
	  		}
	  		if(appbillNo=="")
	  		{
		  		alert("没有申请单!");
		  		return;
	  		}	
			
			lnk="dhcapp.reportreqpreview.csp?arExaReqNo="+appbillNo;
			if (winPreViewAppBill != null)
			{
				winPreViewAppBill.close();
			}
			winPreViewAppBill = open(lnk,"","scrollbars=no,resizable=no,top=30,left=100,width=1100,height=600");
  		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});	


var PrintAppBillBtn = new Ext.Button({
    text:'打印申请单',
    iconCls:'btn-ris-print',
    handler:function(){
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	  	var row = rows[rows.length-1];
	      	OEorditemID=row.get('TOeorditemdr');
	    var value=tkMakeServerCall('web.DHCRisApplicationBill','GetAppShape',OEorditemID);
  		var Item=value.split("^");
   		if (Item[1]!="")
	  	{
		   gPrintTemp=Item[1];
		   gHtmlTemp=Item[3];
	  	   DHCP_GetXMLConfigZZ(gPrintTemp);
	  	}


		var PrintContent=tkMakeServerCall('web.DHCRisCommFunctionEx','GetPrintAppBillContent',OEorditemID);
		if (PrintContent=="")
		{
			alert("没有发送申请单不能打印!");
			return
		}
 		DHCP_PrintFunZZ(PrintContent,"");
		
  		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});	


function isEmpty(obj)
{

    for(var name in obj)
    {
	    alert(name);
        return false;
    }
    return true;
};

var UnRegBtn = new Ext.Button({
    text:'取消登记',
    iconCls:'btn-ris-unregister',
    handler:function(){
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	        var row = rows[rows.length-1];
	        var orderArray={};
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	      	PaadmDR=row.get('Tpaadmdr');
	      	OeorditemID=row.get('TOeorditemdr');
			var OeorditemID=row.get('TOeorditemdr');
	      	var bodyCode=row.get('BodyCode');
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
  			//alert(orderBodyList);
	      	PatineStudyNo=row.get('TStudyNo');
	      	
	      	var TPatientStatus = row.get("TPatientStatus")
	      	
	      	if (TPatientStatus!="登记") {
		      	alert("该记录未登记，不允许取消登记 !");
		      	return false;
		      	}
   		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisUnRegisterPatient&EpisodeID="+PaadmDR+"&OEOrdItemID="+orderBodyList+"&PatineStudyNo="+PatineStudyNo;
   		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=950,height=300,left=200,top=200')  
   		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});	
 
 


function addToList(list,item,splitflag)
{
	if(!arguments[2])
	{
		splitflag="@";
	}
	if (item=="")
		return list;
	if (list=="")
		list=item;
	else
	{
		var listArray=list.split(splitflag);
		var isExist="N";
		for  (var i=0;i<listArray.length;i++)
		{
			if (listArray[i] == item)
			{
				isExist="Y";
				break;
			}
		}
		if (isExist=="N")
			list=list+splitflag+item;
		
	}
	return list;
}


var bookWin;
var AppBtn = new Ext.Button({
    text:'预约',
    cls : 'btnBook',
    iconCls:'btn-ris-book',
    handler:function(){
	    var lnk="";
	    /*
	    var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			var LocDR="";
  			var PaadmDR="";
  			var orderList="";
  			var patientId="";
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	  			LocDR=row.get('RecLocId');
	      	PaadmDR=row.get('Tpaadmdr');
	      	var OeorditemID=row.get('TOeorditemdr');
	      	orderList=addToList(orderList,OeorditemID);
	      	
	  		}
	      //var bodyCode = row.get("BodyCode")
	      //var TPatientStatus = row.get("TPatientStatus")
	      lnk="dhc.ris.appointment.allres.csp?EpisodeID="+PaadmDR+"&OeorditemID="+orderList+"&LocId="+LocDR;
	      //alert(lnk);
	      //return;	
	      */
	    var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			
	    	var LocDR="";
  			var PaadmDR="";
  			var orderList="";
  			var patientId="";
  			var orderArray={};
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	  			var LocDRGet=row.get('RecLocId');
	  			
	  			var patientIdGet=row.get('Tregno');
	  			if ( patientId=="")
	  			{
	  				patientId=patientIdGet;
	  			}
	  			else
	  			{
	  				if (patientId!=patientIdGet)
	  				{
	  					alert("不同病人不能一起预约!");
	  					return;
	  				}
	  			}
	  			if (LocDR =="")
	  			{
	  				LocDR=LocDRGet;
	  			}
	  			else
	  			{
	  				if (LocDR!=LocDRGet)
	  				{
	  					alert("接收科室不同，不允许一起预约!");
	  					return;
	  				}
	  			}
	  			
	      	PaadmDR=row.get('Tpaadmdr');

	      	var OeorditemID=row.get('TOeorditemdr');
	      	var bodyCode=row.get('BodyCode');
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
  					//orderlist=key;
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
  			//lnk="dhc.ris.appointment.allres.csp?EpisodeID="+PaadmDR+"&OeorditemID="+orderBodyList+"&LocId="+LocDR;
  			//lnk="dhc.ris.appoint.selectseat.csp?EpisodeID="+PaadmDR+"&OeorditemID="+orderBodyList+"&LocId="+LocDR;
  			
  			// 增加医嘱关系判断
  			
			var retConflict=tkMakeServerCall("web.DHCRisPlatRelationship","GetRelationShipFromOrdelist",orderBodyList);
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
			
  			openBookWindow(PaadmDR,orderBodyList,LocDR);
  		}else{
			//alert("请先选择一条记录!")
			//return ;
			//lnk="dhc.ris.appointment.allres.csp?EpisodeID="+""+"&OeorditemID="+""+"&LocId="+Ext.getCmp("RecDep").getValue();
  			//lnk="dhc.ris.appoint.selectseat.csp?EpisodeID="+""+"&OeorditemID="+""+"&LocId="+Ext.getCmp("RecDep").getValue();
  			openBookWindow("","",Ext.getCmp("RecDep").getValue());
  		}
    	
    	//bookWin = open(lnk,"","scrollbars=no,resizable=no,location=no,top=30,left=100,width=1100,height=600");
    	//alert(bookWin);
    	
    	/*
    	//if ((bookWin == null)||(Object.keys(bookWin).length==0))
    	//if ( (bookWin == null) || (isEmpty(bookWin)) )
    	//getIEVersion();
    	//alert(navigator.userAgent);
    	//if ((bookWin == null)||(Object.keys(bookWin).length==0))
		{	
			//console.log(bookWin);
			if (bookWin != null)
			{
				bookWin.close();
			}
			bookWin = open(lnk,"","scrollbars=no,resizable=no,location=no,top=30,left=100,width=1100,height=600");
		}
		//else
		{
			///bookWin.location.href=lnk;
			//bookWin.parent.focus();
		}
		*/
		
    }
});	



var UnbookBtn = new Ext.Button({
    text:'取消预约',
    cls:'btnBook',
    iconCls:'btn-ris-cancelbook',
    handler:function(){
	    /*
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	        var row = rows[rows.length-1];
	      	PaadmDR=row.get('Tpaadmdr');
	      	OeorditemID=row.get('TOeorditemdr');
	      	var TPatientStatus = row.get("TPatientStatus")
	      	if (TPatientStatus!="预约") {
		      	alert("该记录未预约，不允许取消预约 !");
		      	return false;
		      	}
   		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisCancelBooked&EpisodeID="+PaadmDR+"&OEOrdItemID="+OeorditemID;
   		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=650,height=300,left=300,top=200')    		
   		}else{
			alert("请先选择一条记录!")
			return ;
  		}
  		*/
  		
  		var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
  			
	    	var LocDR="";
  			var PaadmDR="";
  			var orderList="";
  			var patientId="";
  			var orderArray={};
	  		for(var i=0;i<rows.length;i++)
	  		{
	  			var row=rows[i];
	  			
				  var TPatientStatus = row.get("TPatientStatus")
				if (TPatientStatus == "登记"){
					alert("已经登记，不允许取消预约!");
		      		return ;
				}
				///2019/09/18修复提示错误
				if (TPatientStatus!="预约") {
					alert("该记录未预约，不允许取消预约 !");
					return ;
				}
	  			var LocDRGet=row.get('RecLocId');
	  			
	  			var patientIdGet=row.get('Tregno');
	  			if ( patientId=="")
	  			{
	  				patientId=patientIdGet;
	  			}
	  			else
	  			{
	  				if (patientId!=patientIdGet)
	  				{
	  					alert("请选择同一病人!");
	  					return;
	  				}
	  			}
	  			
	  			
		      	PaadmDR=row.get('Tpaadmdr');

		      	var OeorditemID=row.get('TOeorditemdr');
		      	var bodyCode=row.get('BodyCode');
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
  			//lnk="dhc.ris.appointment.allres.csp?EpisodeID="+PaadmDR+"&OeorditemID="+orderBodyList+"&LocId="+LocDR;
  			var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisCancelBooked&EpisodeID="+PaadmDR+"&OEOrdItemID="+orderBodyList;
   			window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=950,height=300,left=200,top=200')    		
  		}
  		else
  		{
	  		alert("请先选择一条记录!")
			return ;
  		}
    }
});	


function updateBookData()
{
	    var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
    	for (i=0;i<rows.length;i++)
    	{
    		//alert(rows[i]);
    		 var row = rows[rows.length-1];
    		 alert(row.get('TOeorditemdr'));
    		 //row.set('TstrAccessionNum','123');
    		 var scheduleInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","GetBookedPrintData",oeOrdDr);
				 var scheduleInfoArray=scheduleInfo.split("^");
					
				 if (scheduleInfoArray.length>5)
				 {
				 	  row.set('TAppointDate',scheduleInfoArray[3]);
				 	  row.set('TAppointstTime',scheduleInfoArray[4]);
				 	  row.set('TPatientStatus','预约'); 	  
				 	  row.set('TBookedRes',scheduleInfoArray[2]);
				 }
    	}
    	
}




var RejectAppBillBtn = new Ext.Button({
    text:'拒绝申请',
    handler:function(){
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	        var row = rows[rows.length-1];
	      	PaadmDR=row.get('Tpaadmdr');
	      	OeorditemID=row.get('TOeorditemdr');
	      	var TPatientStatus = row.get("TPatientStatus")
	      	if (TPatientStatus!="正在申请") {
		      	alert("记录状态不是正在申请，不允许拒绝申请 !");
		      	return false;
		      	}
   		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRejectAppBill&EpisodeID="+PaadmDR+"&OEOrdItemID="+OeorditemID;
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=650,height=300,left=300,top=200')
   		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});	



var DHCRisBookedItemBtn = new Ext.Button({
    text:'预约列表',
    iconCls:'btn-ris-list',
    handler:function(){
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	        var row = rows[rows.length-1];
	      	PaadmDR=row.get('Tpaadmdr');
	        var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookedItem&EpsodeId="+PaadmDR;
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1150,height=500,left=50,top=100')


  		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});	

var QueryFeeBtn = new Ext.Button({
    text:'费用明细',
    handler:function(){
    	var gsm = CarrierGrid.getSelectionModel();//获取选择列 
    	var rows = gsm.getSelections();//根据选择列获取到所有的行
  		if (rows.length > 0) {
	        var row = rows[rows.length-1];
	      	PaadmDR=row.get('Tpaadmdr');
	    var locid=session['LOGON.CTLOCID'];
    	var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryFee"+"&paadmdr="+PaadmDR+"&LocOEORDITEM=on"+"&LocID="+locid;    
    	var mynewlink=open(link,"DHCRisQueryFee","scrollbars=yes,resizable=yes,width=700,height=400,left=300,top=200");

  		}else{
			alert("请先选择一条记录!")
			return ;
  		}
    }
});			
var tb = new Ext.Toolbar({
		id : 'tb',
		items : [
			'日期: ',StartDate,' 至 ',EndDate,'-',' 接收科室:',RecDep, '-', ' 状态:',RisStatus,'-','卡类型:',CardType,' 卡号:',CardNo,ReadCardBtn,'-' ,' 登记号:',PatientNo  //,'-',LockFlag
		]
	});

var tbar1 = new Ext.Toolbar({
	cls:'btn-turn-on',
	items:[ 
	 //findBtn, '-', ClearBT, '-', RegBtn, '-', AppBtn, '-', UnRegBtn, '-', UnbookBtn, '-',RejectAppBillBtn,'-',DHCRisBookedItemBtn,'-',ExportBtn,'-',QueryFeeBtn,'-',PrintAppBillBtn,'->', GridColSetBT
	 	findBtn, '-', ClearBT, '-', RegBtn, '-', AppBtn, '-', UnRegBtn, '-', UnbookBtn,'-',DHCRisBookedItemBtn,'-',ExportBtn,'-',preViewAppBillBtn,'-',RegPrintBtn  //,'-',QueryFeeBtn,'-',preViewAppBillBtn,'-',RegCSBtn,'-',RegCSRegPrintBtn   //,'->', GridColSetBT
	]
}); 
   
   

//配置数据源
var CarrierGridUrl = 'dhcrisworkbenchex.new.config.csp';
var CarrierGridProxy= new Ext.data.HttpProxy({url:CarrierGridUrl+'?actiontype=query&start=0&limit=999',method:"POST"});

var CarrierGridDs = new Ext.data.Store({
    proxy:CarrierGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
		{name:'Tregno'},{name:'TName'},{name:'TSex'},{name:'TAge'},{name:'TDob'},{name:'TDiagonse'},{name:'TStudyNo'}
		,{name:'TstrOrderName'},{name:'TDoctor'},{name:'TstrAccessionNum'},{name:'TstrDate'},{name:'TstrTime'},{name:'TAppointDate'}
		,{name:'TAppointstTime'},{name:'TBookedDuration'},{name:'TstrRegDate'},{name:'TstrRegTime'},{name:'TReportDoc'}
		,{name:'TReportVerifyDoc'},{name:'TPatientStatus'},{name:'Tpaadmdr'},{name:'TOeorditemdr'},{name:'TLocName'}
		,{name:'Tprice'},{name:'TOEORIItemStatus'},{name:'TBillStatus'},{name:'TPatientType'},{name:'TNum'},{name:'TPerprice'}
		,{name:'TIndex'},{name:'TRegEQ'},{name:'TBookedRes'},{name:'Tifbed'},{name:'TReportStatus'},{name:'TMainDoc'}
		,{name:'TAssDoc'},{name:'TRegRoom'},{name:'TEQroupDesc'},{name:'TWardDesc'},{name:'TNo'},{name:'TRequired'}
		,{name:'THopeTime'},{name:'TOrdStatus'},{name:'TPatMasDR'},{name:'TBodyPart'},{name:'TWeight'},{name:'TTelNo'}
		,{name:'TIPNO'},{name:'TSentFilm'},{name:'TBedCode'},{name:'TSendPrint'},{name:'HasImage'},{name:'RecLocId'}
		,{name:'RecLoc'},{name:'AutoInputFee'},{name:'EndInputFee'},{name:'Detail'},{name:'RejectAppReason'},{name:'BilledDesc'}
		,{name:'PinYin'},{name:'ToDayOeItem'},{name:'CostRecords'},{name:'AppDate'},{name:'UrgentFlag'},{name:'TRegDoc'}
		,{name:'TEpissubtype'},{name:'SGroupDesc'},{name:'SGroupDR'},{name:'AppointUser'},{name:'AppBillView'},{name:'AdmReason'}
		,{name:'ExterBK'},{name:'BodyCode'},{name:'AppBillNo'},{name:'BKStudyNo'},{name:'AccUsePrice'},{name:'GetResultFlag'}

    ]),
	baseParams:{
		Params:''
	}
   // pruneModifiedRecords:true
    
});



var mysm = new Ext.grid.CheckboxSelectionModel({singleSelect:false,checkOnly:true});

var nm = new Ext.grid.RowNumberer();
var CarrierGridCm = new Ext.grid.ColumnModel([
				//mysm,
				nm,
				{
					header : "检查状态",
					dataIndex : 'TPatientStatus',
					width : 80,
					align : 'left',
					sortable : true
				},
				{
					header : "登记号",
					dataIndex : 'Tregno',
					align : 'left',
					sortable : true
				}, {
					header : "姓名",
					dataIndex : 'TName',
					width : 80,
					align : 'left',
					sortable : true
				},
				 {
					header : "性别",
					dataIndex : 'TSex',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : "年龄",
					dataIndex : 'TAge',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : '医嘱',
					dataIndex : 'TstrOrderName',
					width : 200,
					align : 'left',
					sortable : true
				},
				 
				{
					header : "是否交费",
					dataIndex : 'BilledDesc',
					width : 80,
					align : 'left',
					//hidden : true,
					sortable : true
				},
				{
					header : "卡余额",
					dataIndex : 'AccUsePrice',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				},/* {
					header : "关联号",
					dataIndex : 'TstrAccessionNum',
					width : 150,
					align : 'left',
					sortable : true
				}, */{
					header : "预约日期",
					dataIndex : 'TAppointDate',
					width : 100,
					align : 'left',
					sortable : false
				},{					
					header : "预约时间",
					dataIndex : 'TAppointstTime',
					width : 80,
					align : 'left',
					sortable : false
				},{
					header : "登记日期",
					dataIndex : 'TstrRegDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "登记时间",
					dataIndex : 'TstrRegTime',
					width : 80,
					align : 'left',
					sortable : true
				},/* {
					header : "报告医生",
					dataIndex : 'TReportDoc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "审核医生",
					dataIndex : 'TReportVerifyDoc',
					width : 100,
					align : 'left',
					sortable : true
				}, */
				{
					header : "OEORIItemStatus",
					dataIndex : 'TOEORIItemStatus',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "入院科室",
					dataIndex : 'TLocName',
					width : 130,
					align : 'left',
					sortable : true
				}, {
					header : '医嘱日期',
					dataIndex : 'TstrDate',
					width :100,
					align : 'left',
					sortable : true
				}, {
					header : '医嘱时间',
					dataIndex : 'TstrTime',
					width : 80,
					align : 'left',
					sortable : false
				},
				 {
					header : "费用",
					dataIndex : 'Tprice',
					width : 80,
					align : 'left',
					sortable : true
				},
				 {
					header : '检查号',
					dataIndex : 'TStudyNo',
					width : 150,
					align : 'left',
					sortable : true
				}, {
						header : "三方报告",
					dataIndex : 'GetResultFlag',
					width : 80,
					align : 'left',
					sortable : true,
					hidden:true
					
					
					}, {
					header : "收费状态",
					dataIndex : 'TBillStatus',
					width : 100,
					align : 'left',
					hidden: true,
					sortable : true
				}, {
					header : "出生日期",
					dataIndex : 'TDob',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "申请医生",
					dataIndex : 'TDoctor',
					width : 100,
					align : 'left',
					sortable : true
				}/*, {
					header : "临床诊断",
					dataIndex : 'TDiagonse',
					width : 100,
					align : 'left',
					sortable : true
				}*/, {
					header : "病人类型",
					dataIndex : 'TPatientType',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "数量",
					dataIndex : 'TNum',
					width : 50,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "单价",
					dataIndex : 'TPerprice',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "登记序号",
					dataIndex : 'TIndex',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "登记设备",
					dataIndex : 'TRegEQ',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "预约资源",
					dataIndex : 'TBookedRes',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "备注信息",
					dataIndex : 'TNotes',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "tpapatmasdr",
					dataIndex : 'TPatMasDR',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "预约时间长度",
					dataIndex : 'TBookedDuration',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "部位",
					dataIndex : 'TBodyPart',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "操作技师",
					dataIndex : 'TMainDoc',
					width : 100,
					hidden : true,
					align : 'left',
					sortable : true
				}, {
					header : "辅助技师",
					dataIndex : 'TAssDoc',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "检查室",
					dataIndex : 'TEQroupDesc',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "房间",
					dataIndex : 'TRegRoom',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "体重",
					dataIndex : 'TWeight',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "电话",
					dataIndex : 'TTelNo',
					width : 110,
					align : 'left',
					sortable : true
				}, {
					header : "住院号",
					dataIndex : 'TIPNO',
					width : 100,
					align : 'left',
					sortable : true
				}/*, {
					header : "发片状态",
					dataIndex : 'TSentFilm',
					width : 100,
					align : 'left',
					sortable : true
				}*/, {
					header : "病区",
					dataIndex : 'TWardDesc',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "床位",
					dataIndex : 'TBedCode',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "打印",
					dataIndex : 'TSendPrint',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "报告状态",
					dataIndex : 'TReportStatus',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "是否有图",
					dataIndex : 'HasImage',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "RecLocId",
					dataIndex : 'RecLocId',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "执行科室",
					dataIndex : 'RecLoc',
					width : 160,
					align : 'left',
					hidden : false,
					sortable : true
				}, {
					header : "划价标识",
					dataIndex : 'AutoInputFee',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "已另划价",
					dataIndex : 'EndInputFee',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}/*, {
					header : "医嘱费用明细",
					dataIndex : 'Detail',
					width : 100,
					align : 'left',
     				renderer: function (value, meta, record) {  
     							var OEOrdItemID=record.get("OEOrdItemID")   							
				     			//return '<a href="#" onclick="ItemDetailLink()" >明细</a>';
				     		},
					sortable : true
				}, {
					header : "拒绝原因",
					dataIndex : 'RejectAppReason',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}*/,  {
					header : "拼音",
					dataIndex : 'PinYin',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}/*, {
					header : "当天医嘱",
					dataIndex : 'ToDayOeItem',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "费用补录",
					dataIndex : 'CostRecords',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}*/, {
					header : "申请日期",
					dataIndex : 'AppDate',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "加急",
					dataIndex : 'UrgentFlag',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "登记医生",
					dataIndex : 'TRegDoc',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}/*, {
					header : "特需",
					dataIndex : 'TEpissubtype',
					width : 100,
					align : 'left',
					sortable : true
				}*/, {
					header : "服务组",
					dataIndex : 'SGroupDesc',
					width : 100,
					align : 'left',
					hidden : false,
					sortable : true
				}, {
					header : "SGroupDR",
					dataIndex : 'SGroupDR',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "预约操作员",
					dataIndex : 'AppointUser',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "医嘱状态",
					dataIndex : 'TOEORIItemStatus',
					width : 100,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "BodyCode",
					dataIndex : 'BodyCode',
					width : 80,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "申请单号",
					dataIndex : 'AppBillNo',
					width : 80,
					align : 'left',
					hidden : false,
					sortable : true
				},{
					header : "OEOrdItemID",
					dataIndex : 'TOeorditemdr',
					width : 80,
					align : 'left',
					hidden: true,
					sortable : false
				}, {
					header : 'EpisodeID',
					dataIndex : 'Tpaadmdr',
					width : 80,
					align : 'left',
					hidden: true,
					sortable : false
				},{
					header : "预约号",
					dataIndex : 'BKStudyNo',
					width : 80,
					align : 'left',
					hidden : false,
					sortable : true
				}
				
]);
//初始化默认排序功能
CarrierGridCm.defaultSortable = true;



//分页工具栏
var CarrierPagingToolbar = new Ext.PagingToolbar({
    store : CarrierGridDs,
	pageSize : 25,
	displayInfo : true,
	displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
	emptyMsg : "No results to display",
	prevText : "上一页",
	nextText : "下一页",
	refreshText : "刷新",
	lastText : "最后页",
	firstText : "第一页",
	beforePageText : "当前页",
	afterPageText : "共{0}页",
	emptyMsg : "没有数据"
	
	/*   // 增加按钮
	,items:[
            '-', {
            pressed: false,
            enableToggle:true,
            text: '显示全部',
            toggleHandler: function(btn, pressed){
                var view = self.main.getView();
                if(pressed)
                {
                    store.reload({params:{start:0,limit:-1}});
                }
                else
                {
                    store.reload({params:{start:0,limit:20}});
                }
                view.refresh();
            }
        }]
        */
});



var sm = new Ext.grid.RowSelectionModel({singleSelect:true});
		
//表格
var CarrierGrid = new Ext.grid.GridPanel({
	id:'CarrierGrid',
	region:'center',
	cm:CarrierGridCm,
    store:CarrierGridDs,
    //trackMouseOver:true,
    //height:690,
   // stripeRows:true,
    sm:mysm,
    tbar : tb,
    listeners : { 
       'render': function(){ 
            tbar1.render(CarrierGrid.tbar); 
            
	         var hd_checker = this.getEl().select('div.x-grid3-hd-checker');
	         //console.log(hd_checker);
	         if (hd_checker.hasClass('x-grid3-hd-checker')) {  
	                hd_checker.removeClass('x-grid3-hd-checker'); // 去掉全选框 
	            } 
	        }
	       
	        
	        
     } ,
     /*
     viewConfig:{
	     getRowClass : function(record,rowIndex,rowParams,store){
                  if(record.data.UrgentFlag == 'Y' ){ 
                           return 'x-grid-record-red';
                  }
                  
                  if (mysm.isSelected(rowIndex)){
	                  return 'x-grid-record-checked';
                  }
	               
                 
            }
     },*/
    //loadMask:true,
    bbar:CarrierPagingToolbar
});



CarrierGrid.addListener('rowclick', rowclickFn);

CarrierGrid.on('cellclick',function cellclick(grid, rowIndex, columnIndex, e) {

	var record = grid.getStore().getAt(rowIndex);   //Get the Record
    //var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
    var data = record.get('TOeorditemdr');
	if (columnIndex==0)
	{
		initOrdList(rowIndex,data)
		return;
	}
		
	if ( mysm.isSelected(rowIndex) )
    	mysm.deselectRow(rowIndex);
    else
    	mysm.selectRow(rowIndex,true);
    	
    initOrdList(rowIndex,data);
    //Ext.MessageBox.alert('show','当前选中的数据是'+data);
});


function initOrdList(rowIndex,ordRowid)
{	
	//alert(ordRowid);
	var studyNo = CarrierGrid.store.getAt(rowIndex).get('TStudyNo');
	//alert(studyNo);
	var patientId = CarrierGrid.store.getAt(rowIndex).get('Tregno');
	var bookNo = CarrierGrid.store.getAt(rowIndex).get('BKStudyNo');
	var recLocRowid = CarrierGrid.store.getAt(rowIndex).get('RecLocId');
	var appbillNo = CarrierGrid.store.getAt(rowIndex).get('AppBillNo');
	var serviceGroupList = CarrierGrid.store.getAt(rowIndex).get('SGroupDR');
	var orderStatus = CarrierGrid.store.getAt(rowIndex).get("TOEORIItemStatus");
	
	//alert(orderStatus);
	if ( orderStatus=="RJ")
	{
		mysm.deselectRow(rowIndex);
		return;
	}
	
	//根据标志位判断是否允许分部位预约登记
	var orderItemRowid = CarrierGrid.store.getAt(rowIndex).get('TOeorditemdr');
	var divideFlag= tkMakeServerCall("web.DHCRisCommFunctionEx","getDivideFlag",orderItemRowid);

	if ( mysm.isSelected(rowIndex))  
	{
		for (i=0;i<CarrierGrid.store.getCount();i++)
		{
			var queryListRecord = CarrierGrid.store.getAt(i);
			/*
			if ( queryListRecord.get('TOeorditemdr') != ordRowid)
			{
					mysm.deselectRow(i);
					continue;
			}
			*/
			var studyNoGet=queryListRecord.get('TStudyNo');
			var patientIdGet=queryListRecord.get('Tregno');
			var bookNoGet=queryListRecord.get('BKStudyNo');
			var recLocRowidGet=queryListRecord.get('RecLocId');
			var appbillNoGet = queryListRecord.get('AppBillNo');
			
			var orderItemRowidGet = queryListRecord.get('TOeorditemdr'); 
			
			var orderStatusGet = queryListRecord.get("TOEORIItemStatus");
			
			var serviceGroupListGet = queryListRecord.get('SGroupDR');

			if ( orderStatusGet=="RJ")
			{
				mysm.deselectRow(i);
				continue;
			}
			
			// 不允许分开登记预约的，同时都选中
			if ( (orderItemRowidGet==orderItemRowid) && (divideFlag=="N"))
			{
				mysm.selectRow(i,true);
				continue;
			}
			
			
			if ( recLocRowidGet!=recLocRowid)  //不同接收科室不能一起选中
			{
				mysm.deselectRow(i);
				continue;
			}
			
			if (studyNo=="")     //勾选的记录没有登记
			{
				//判断是否预约
				if(bookNo=="")   //勾选的记录没有预约
				{
					//轮询记录已经预约或登记，则不能选择
					if (studyNoGet!="" || bookNoGet!="")
					{
							mysm.deselectRow(i);
					}
					else  
					{				

						if ( patientIdGet == patientId)
						{
							//正在申请状态，增加服务组判断
							if (serviceGroupList == "")
							{
								mysm.selectRow(i,true);
							}
							else
							{
								var sameGroupList=getSameItem(serviceGroupList,serviceGroupListGet);
								if (sameGroupList!="")
								{
									mysm.selectRow(i,true);
									serviceGroupList=sameGroupList;
								}
								else
								{
									mysm.deselectRow(i);
								}
							}
						}		
						else
						{
							mysm.deselectRow(i);
						}

					}
				}
				else   //勾选的记录已经预约
				{
					//轮询记录登记，则不能选择
					if (studyNoGet!="")
					{
						mysm.deselectRow(i);
					}
					
					if ( bookNo == bookNoGet)
						mysm.selectRow(i,true);
					else
						mysm.deselectRow(i);
				}
			
			}
			else   //勾选的记录已经登记
			{
				if ( studyNoGet == studyNo)
					mysm.selectRow(i,true);
				else
					mysm.deselectRow(i);
			}			
		}
	}
	else
	{
		for (i=0;i<CarrierGrid.store.getCount();i++)
		{
			var queryListRecord = CarrierGrid.store.getAt(i);
			var orderItemRowidGet = queryListRecord.get('TOeorditemdr'); 
				
			// 不允许分开登记预约的，同时都勾选没
			if ( (orderItemRowidGet==orderItemRowid) && (divideFlag=="N"))
			{
				mysm.deselectRow(i);
				continue;
			}
			
		}
	}
	
}

function getSameItem(groupOne,groupTwo)
{
	var three=[];
	var one = groupOne.split(',');
	var two = groupTwo.split(',');
	three = one.intersect(two);
	
	var retGroup="";
	for (j=0;j<three.length;j++)
	{
	    if (retGroup==""){
	        retGroup=three[j];
	    }else{
	        retGroup=retGroup+","+three[j];
	    }
	}
	return retGroup;
}

Array.prototype.intersect = function(b)
{
	var flip = {};
	var res = [];
	for(var i =0; i< b.length; i++)
	{
		flip[b[i]] = i;
	}
	for (var i = 0; i<this.length; i++)
	{
		if ( flip[this[i]] != undefined)
			res.push(this[i]);
	}
	return res;
	
}



function InitLockData()
{
	/// ------锁定信息-----
  	var lockCardNo="",lockPatientNo="",lockStartDate="",lockEndDate="",lockRecDep="",lockRisStatus=""
	var LockValue=tkMakeServerCall('web.DHCRisCommFunctionNew','GetLockValue',UserRowID);
	var lock=LockValue.split("^")[0];
	if (lock){
		EpisodeID=LockValue.split("^")[1];
		PatientID=LockValue.split("^")[2];
		lockCardNo=LockValue.split("^")[3];
		lockPatientNo=LockValue.split("^")[4];
		lockStartDate=LockValue.split("^")[5];
		lockEndDate=LockValue.split("^")[6];
		lockRecDep=LockValue.split("^")[7];
		lockRisStatus=LockValue.split("^")[8];
		
		if (lockRisStatus!=""){
			Ext.getCmp('RisStatus').setValue(lockRisStatus.split("&")[0]);
			Ext.getCmp('RisStatus').setRawValue(lockRisStatus.split("&")[1]);
		}
		if (lockRecDep!="") {
			lockRecDepId=lockRecDep.split("&")[0];
			Ext.getCmp('RecDep').setValue(lockRecDep.split("&")[0]);
			Ext.getCmp('RecDep').setRawValue(lockRecDep.split("&")[1]);
		}
		if ((lockCardNo!="")&&(lockCardNo!='undefined')){
			Ext.getCmp("CardNo").setValue(lockCardNo);
		}
		if ((lockPatientNo!="")&&(lockPatientNo!='undefined')){
			Ext.getCmp("PatientNo").setValue(lockPatientNo);
		}
	
		if (lockStartDate!=""){
			Ext.getCmp("StartDate").setValue(lockStartDate);
		}

		if (lockEndDate!=""){
			Ext.getCmp("EndDate").setValue(lockEndDate);
		}
		
		Ext.getCmp("LockFlag").setValue(lock) ;
	}
}



function searchData(){	
	
	var typeDR = "" ;		// 病人类型 
	var PatientNo = formatRegNo(Ext.getCmp("PatientNo").getValue()); 	//登记号
	Ext.getCmp("PatientNo").setValue(PatientNo);
	
	var StudyNo = "";    	//检查号
	var LocDr = Ext.getCmp("RecDep").getValue();		//科室ID
	var StatusCode = Ext.getCmp("RisStatus").getValue();	//状态Id
	var ReportDoc = "";		//报告医生
	var VerifyDoc = "";	// 审核医生
	var Name = ""; 			// 姓名
	var ResourceDR = "";	//预约资源rowid
	var RegEQDR = "" ;  	// 登记资源rowid 
	var RoomDR = "" ; 		// 房间
	var InPatientNo = "" ; 	// 住院号
	var IsFindbyDate = "false" ; 		// 日期的勾选框 CheckDate
	var IsAppointmentOrder = "" ;		// ckAppointment 需要预约的勾选框
	var IsBedOrder = "" ;		//ckbedOrder 床旁医嘱
	var EQGroupDR = "" ;	//检查组rowid
	var No = "" ;			//编号
	var IsSetFilm = "false" ; 		//ckSentFilm 已发片
	var Islock = "false" ; 			// Lock 锁定
	var IsNotLoc = "N" ;    	// ChkNotLoc 不显示本科病人
	var QueryByRegDate = "N" ; 		// ckRegDate 登记日期
	var Resource = "" ;		// Resource 
	var EQGroup = "" ;
	var Room = "" ;
	var Status = Ext.getCmp("RisStatus").getRawValue();
	var Patienttype = "" ;
	var RegDevice = "" ;
	var IsUItem = "N" ;
	var IsCostRecords = "N" ;
	var AppLocID = "";
	
	//var StartDate = Ext.getCmp("StartDate").getValue();
	var StartDate = Ext.getCmp("StartDate").getRawValue();
	//alert(StartDate);
	/*
	if (StartDate!=""){
		StartDate = StartDate.format('Y-m-d').toString();
	}
	*/
	//var EndDate = Ext.getCmp("EndDate").getValue();
	var EndDate = Ext.getCmp("EndDate").getRawValue();
	/*
	if (EndDate!=""){
		EndDate = EndDate.format('Y-m-d').toString();
	}
	*/
	var BookedType=1 ;   //默认
	
	//SetLockValue(Ext.getCmp("LockFlag").getValue()); 
	
	var Condition1=typeDR+"^"+PatientNo+"^"+StudyNo+"^"+LocDr+"^"+StatusCode+"^"+ReportDoc+"^"+VerifyDoc+"^"+Name+"^"+ResourceDR;
	var Condition2=RegEQDR+"^"+RoomDR+"^"+InPatientNo+"^"+IsFindbyDate+"^"+IsAppointmentOrder+"^"+IsBedOrder+"^"+EQGroupDR+"^^"+No
		+"^"+IsSetFilm+"^"+Islock+"^"+IsNotLoc+"^"+QueryByRegDate;
	var Condition3=Resource+"^"+EQGroup+"^"+Room+"^"+Status+"^"+Patienttype+"^"+RegDevice+"^"+StartDate+"^"+EndDate+"^"+IsUItem+"^"+IsCostRecords+"^"+AppLocID;

 	var strCondition=Condition1+"^"+Condition2+"^"+Condition3;
	
	//var strParam=strCondition+Char2+formatDate(StartDate,0)+Char2+formatDate(EndDate,0)+Char2+BookedTeyp;
	var strParam=strCondition+Char2+StartDate+Char2+EndDate+Char2+BookedType;

	CarrierGridDs.setBaseParam("Params",strParam);
	CarrierGridDs.removeAll();
	var pageSize=CarrierPagingToolbar.pageSize;
	CarrierGridDs.load({params:{start:0,limit:pageSize}});
}


function formatDate(Date,i){
//var formatDate = function (Date){
	var retDate=tkMakeServerCall('web.DHCRisCommFunctionNew','formatDate',Date,i);
	return retDate;
}




function formatRegNo(regNo){
//var formatRegNo = function (regNo){
	if ((regNo=="")||(regNo==Char0)) return "";
	regNo=formatNo(regNo);
	var len=regNo.length;
	if (len<10){
		for (var i=1;i<=(10-len);i++){
			regNo="0"+regNo;
		}
	}
	return regNo;
}


function formatNo(No){
//var formatNo =function (No){
	var reg=new RegExp(Char0,"g"); 
	No=No.replace(reg,"") 
	reg=new RegExp(Char1,"g"); 
	No=No.replace(reg,"") 
	return No;
}


function SetLockValue(ischecked){
	/*
	//var SetLockValue = function(ischecked){
	if(ischecked){
		 var CardNo=Ext.getCmp("CardNo").getValue();
		 var PatientNo=Ext.getCmp("PatientNo").getValue();
		 var StartDate=Ext.getCmp("StartDate").getValue();
		 if (StartDate!=""){StartDate = StartDate.format('Y-m-d').toString();	}	
		 var EndDate=Ext.getCmp("EndDate").getValue();
		 if (EndDate!=""){EndDate = EndDate.format('Y-m-d').toString();}	
		 var CardType=Ext.getCmp("CardType").getValue();
		 var RecDep=Ext.getCmp("RecDep").getValue();
		 var RecDepDesc=Ext.getCmp("RecDep").getRawValue();
		 RecDep=RecDep+"&"+RecDepDesc ;
		 var RisStatus=Ext.getCmp("RisStatus").getValue();
		 var RisStatusDesc=Ext.getCmp("RisStatus").getRawValue();
		 RisStatus=RisStatus+"&"+RisStatusDesc ;
		 var LockValue=ischecked+"^"+EpisodeID+"^"+PatientID+"^"+CardNo+"^"+PatientNo+"^"+StartDate+"^"+EndDate+"^"+RecDep+"^"+RisStatus;
		 var ret=tkMakeServerCall('web.DHCRisCommFunctionNew','SetLockValue',LockValue,UserRowID);
	 }else{
		 var LockValue=ischecked+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+"";
		 var ret=tkMakeServerCall('web.DHCRisCommFunctionNew','SetLockValue',LockValue,UserRowID);
	 }
	 */
}




function ExportList_onclick()
{
	
	grid2excel(CarrierGrid,{IE11IsLowIE:false,filename:'检查列表导出',allPage:true,callback:function(success,data){
		if(success){
			alert("导出成功");
		}else{
			alert("导出失败");
		}
		
	}});
	/*
	var typeDR = "" ;		// 病人类型 
	var PatientNo = formatRegNo(Ext.getCmp("PatientNo").getValue()); 	//登记号
	Ext.getCmp("PatientNo").setValue(PatientNo);
	
	var StudyNo = "";    	//检查号
	var LocDr = Ext.getCmp("RecDep").getValue();		//科室ID
	var StatusCode = Ext.getCmp("RisStatus").getValue();	//状态Id
	var ReportDoc = "";		//报告医生
	var VerifyDoc = "";	// 审核医生
	var Name = ""; 			// 姓名
	var ResourceDR = "";	//预约资源rowid
	var RegEQDR = "" ;  	// 登记资源rowid 
	var RoomDR = "" ; 		// 房间
	var InPatientNo = "" ; 	// 住院号
	var IsFindbyDate = "false" ; 		// 日期的勾选框 CheckDate
	var IsAppointmentOrder = "" ;		// ckAppointment 需要预约的勾选框
	var IsBedOrder = "" ;		//ckbedOrder 床旁医嘱
	var EQGroupDR = "" ;	//检查组rowid
	var No = "" ;			//编号
	var IsSetFilm = "false" ; 		//ckSentFilm 已发片
	var Islock = "false" ; 			// Lock 锁定
	var IsNotLoc = "N" ;    	// ChkNotLoc 不显示本科病人
	var QueryByRegDate = "N" ; 		// ckRegDate 登记日期
	var Resource = "" ;		// Resource 
	var EQGroup = "" ;
	var Room = "" ;
	var Status = Ext.getCmp("RisStatus").getRawValue();
	var Patienttype = "" ;
	var RegDevice = "" ;
	var IsUItem = "N" ;
	var IsCostRecords = "N" ;
	var AppLocID = "";
	
	
	var StartDate = Ext.getCmp("StartDate").getRawValue();
	
	var EndDate = Ext.getCmp("EndDate").getRawValue();
	
	var BookedType=1 ;   //默认
	
	
	
	var Condition1=typeDR+"^"+PatientNo+"^"+StudyNo+"^"+LocDr+"^"+StatusCode+"^"+ReportDoc+"^"+VerifyDoc+"^"+Name+"^"+ResourceDR;
	var Condition2=RegEQDR+"^"+RoomDR+"^"+InPatientNo+"^"+IsFindbyDate+"^"+IsAppointmentOrder+"^"+IsBedOrder+"^"+EQGroupDR+"^^"+No
		+"^"+IsSetFilm+"^"+Islock+"^"+IsNotLoc+"^"+QueryByRegDate;
	var Condition3=Resource+"^"+EQGroup+"^"+Room+"^"+Status+"^"+Patienttype+"^"+RegDevice+"^"+StartDate+"^"+EndDate+"^"+IsUItem+"^"+IsCostRecords+"^"+AppLocID;

 	var strCondition=Condition1+"^"+Condition2+"^"+Condition3;


	var rtn = tkMakeServerCall("websys.Query","ToExcel","exportExamList","web.DHCRisWorkBenchDoEx","QueryExamItem",strCondition,StartDate,EndDate,BookedType);
	
	location.href = rtn;
	
	*/
	
	
	
	/*
	try 
	{
		var xlApp,xlsheet,xlBook
		var TemplatePath=tkMakeServerCall('web.DHCRisCommFunction','GetPath');
	    var Template=TemplatePath+"DHCRisWorklistExport.xls";
	    var CellRows ;
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    var j=0;
	   
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	   
	    //alert("1");
	    var UserID=session['LOGON.USERID'];
	    //alert("2");
	    var Nums=tkMakeServerCall('web.DHCRisWorkBenchDoEx','GetPrintCount',UserID);
 	    //alert("3");
 	    if (Nums==0)
 	    {
	 	    alert("请查询记录后在导出!");
	 	    return ;
	 	}
        
	 	for (var i=1;i<=Nums;i++)
	 	{
	        var PrintData=tkMakeServerCall('web.DHCRisWorkBenchDoEx','SetPrintData',UserID,i);
 	        if (PrintData!="")
 	        {
	 	        j=j+1
	 	        var tmpary=PrintData.split("^");
	 	        
    	 	   
    	 	      var RegNo=tmpary[0];
    	 	      var Name=tmpary[1];
    	 	      var Sex=tmpary[2];
    	 	      var Age=tmpary[3];
    	 	      var DOB=tmpary[4];
    	 	      var IDCDesc=tmpary[5];
    	 	      var StudyNo=tmpary[6];
    	 	      var OrderName=tmpary[7];
    	 	      var requestdoc=tmpary[8];
    	 	      var AccessionNum=tmpary[9];
    	 	      var OEIDate=tmpary[10];
    	 	      var OEITime=tmpary[11];
    	 	      var RppDate=tmpary[12];
    	 	      var RppTime=tmpary[13];
    	 	      var BookedDuration=tmpary[14];
    	 	      var RegDate=tmpary[15];
    	 	      var RegTime=tmpary[16];
    	 	      var RptDocName=tmpary[17];
    	 	      var VerifyDocName=tmpary[18];
    	 	      var PatientStatus=tmpary[19];
    	 	      var LocName=tmpary[22];
    	 	      var TotalPrice=tmpary[23];
    	 	      var billed=tmpary[25];
    	 	      var typedesc=tmpary[26];
    	 	      var Num=tmpary[27];
    	 	      var price=tmpary[28];
    	 	      var Index=tmpary[29];
    	 	      var EQDesc=tmpary[30];
    	 	      var ResDesc=tmpary[31];
    	 	      var ifbed=tmpary[32];
    	 	      var ReportStatus=tmpary[33];
    	 	      var MainDoc=tmpary[34];
    	 	      var AssDoc=tmpary[35];
    	 	      var RoomDesc=tmpary[36];
    	 	      var EQGroupDesc=tmpary[37];
    	 	      var WardName=tmpary[38];
    	 	      var OldNo=tmpary[39];
    	 	      var Required=tmpary[40];
    	 	      var XDate=tmpary[41];
    	 	      var BodyDesc=tmpary[44];
    	 	      var Weight=tmpary[45];
    	 	      var TelNo=tmpary[46];
    	 	      var IPNo=tmpary[47];
    	 	      var FileSent=tmpary[48];
    	 	      var BedNo=tmpary[49];
    	 	      var ReportSend=tmpary[50];
    	 	      var HaveImage=tmpary[51];
    	 	      var RecLoc=tmpary[53];
    	 	      var AutoInputFee=tmpary[54];
    	 	      var EndInputFee=tmpary[55];
    	 	      var Detail=tmpary[56];
    	 	      var BilledDesc=tmpary[58];
    	 	      var PinYin=tmpary[59];
    	 	      var CostRecords=tmpary[61];
    	 	      var AppDate=tmpary[62];
    	 	      var Urgentflag=tmpary[63];
    	 	      var RegDoc=tmpary[64];
    	 	      var Epissubtype=tmpary[65];
    	 	      var SGroupDesc=tmpary[66];
    	 	      
    	 	      
    	 	      xlsheet.cells(j+3,1)=Name;
			 	  xlsheet.cells(j+3,2)=Sex;
			 	  xlsheet.cells(j+3,3)=Age;
			 	  xlsheet.cells(j+3,4)=DOB;
			 	  xlsheet.cells(j+3,5)=IDCDesc;
			 	  xlsheet.cells(j+3,6)=StudyNo;
			 	  xlsheet.cells(j+3,7)=OrderName;
			 	  xlsheet.cells(j+3,8)=requestdoc; 
			 	  xlsheet.cells(j+3,9)=AccessionNum; 
			 	  xlsheet.cells(j+3,10)=OEIDate;
			 	  xlsheet.cells(j+3,11)=OEITime;
			 	  xlsheet.cells(j+3,12)=RppDate;
			 	  xlsheet.cells(j+3,13)=RppTime;
			 	  xlsheet.cells(j+3,14)=BookedDuration; 
			 	  xlsheet.cells(j+3,15)=RegDate
			 	  xlsheet.cells(j+3,16)=RegTime;
			 	  xlsheet.cells(j+3,17)=RptDocName;
			 	  xlsheet.cells(j+3,18)=VerifyDocName;
			 	  xlsheet.cells(j+3,19)=PatientStatus;
			 	  xlsheet.cells(j+3,20)=LocName;
			 	  xlsheet.cells(j+3,21)=TotalPrice;
			 	  xlsheet.cells(j+3,22)=billed;
			 	  xlsheet.cells(j+3,23)=typedesc; 
			 	  xlsheet.cells(j+3,24)=Num; 
    	 	      xlsheet.cells(j+3,25)=price;
			 	  xlsheet.cells(j+3,26)=Index;
			 	  xlsheet.cells(j+3,27)=EQDesc;
			 	  xlsheet.cells(j+3,28)=ResDesc;
			 	  xlsheet.cells(j+3,29)=ifbed;
			 	  xlsheet.cells(j+3,30)=ReportStatus;
			 	  xlsheet.cells(j+3,31)=MainDoc;
			 	  xlsheet.cells(j+3,32)=AssDoc; 
			 	  xlsheet.cells(j+3,33)=RoomDesc; 
			 	  
     			
    	 	      xlsheet.cells(j+3,34)=WardName; 
    	 	      xlsheet.cells(j+3,35)=OldNo; 
    	 	      xlsheet.cells(j+3,36)=Required; 
    	 	      //xlsheet.cells(j+3,38)=XDate; 
    	 	      xlsheet.cells(j+3,37)=BodyDesc; 
    	 	      xlsheet.cells(j+3,38)=Weight; 
    	 	      xlsheet.cells(j+3,39)=TelNo; 
    	 	      xlsheet.cells(j+3,40)=IPNo; 
    	 	      xlsheet.cells(j+3,41)=FileSent; 
    	 	      xlsheet.cells(j+3,42)=BedNo; 
    	 	      //xlsheet.cells(j+3,45)=ReportSend; 
    	 	      //xlsheet.cells(j+3,46)=HaveImage; 
    	 	      xlsheet.cells(j+3,43)=RecLoc; 
    	 	      xlsheet.cells(j+3,44)=AutoInputFee; 
    	 	      xlsheet.cells(j+3,45)=EndInputFee; 
    	 	      xlsheet.cells(j+3,46)=Detail; 
    	 	      xlsheet.cells(j+3,47)=BilledDesc; 
    	 	      xlsheet.cells(j+3,48)=PinYin; 
    	 	      xlsheet.cells(j+3,49)=CostRecords; 
    	 	      xlsheet.cells(j+3,50)=AppDate; 
    	 	      xlsheet.cells(j+3,51)=Urgentflag; 
    	 	      xlsheet.cells(j+3,52)=RegDoc; 
    	 	      xlsheet.cells(j+3,53)=Epissubtype; 
    	 	      xlsheet.cells(j+3,54)=SGroupDesc; 
	 	    }
		}
	 	
 	   
      
        var fname = xlApp.Application.GetSaveAsFilename("save.xls", "Excel Spreadsheets (*.xls), *.xls");
		if (fname!="false") 
		{
		   xlsheet.SaveAs(fname);
	    }
		xlBook.Close (savechanges=false);
        xlApp=null;
        xlsheet=null;
        
	}
	catch(e) 
	{
		alert(e.message);
	}
	*/
}


function rowclickFn(grid, rowindex, e){
     grid.getSelectionModel().each(function(rec){
     		var OEorditemID=rec.get("OEOrdItemID")
          		SelectedOrdItemRowid=OEorditemID;
     		var regno=rec.get("Tregno");
   			var name=rec.get("TName");  
    		var paadmdr=rec.get("Tpaadmdr");
    		   	EpisodeID=paadmdr;
    		var RegIndex=rec.get("TIndex");
    		var ipno=rec.get("TIPNO");
    		var TPatMasDR=rec.get("TPatMasDR");
				PatientID=TPatMasDR	
    		var regDate=rec.get("TRegDate");
    		//var bodyCode = rec.get("BodyCode")
    		PatientStatusCode=rec.get("OEORIItemStatus");
    		Selected=true;
     });
     	var frm =dhcsys_getmenuform();
		if (frm) 
		{
			frm.EpisodeID.value=EpisodeID;
			frm.PatientID.value=PatientID;
			//frm.BodyCode.value = bodyCode;
		}
}


function DHCP_PrintFunZZ(inpara,inlist){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
			
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);
		PObj=new ActiveXObject("DHCOPPrint.ClsBillPrint");	
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
			
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}

function DHCP_GetXMLConfigZZ(PFlag){
	////
	/////InvPrintEncrypt
	try{		
		PrtAryData.length=0
		//var obj=document.getElementById("InvPrintEncrypt");
		//var encmeth=obj.value;
		//var PrtConfig=cspRunServerMethod(encmeth,"DHCP_RecConStr",PFlag);
		var PrtConfig=tkMakeServerCall("web.DHCXMLIO","ReadXML","DHCP_RecConStr",PFlag)
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}
/*
function changeRowBackgroundColor()
{
	 CarrierGrid.
	grid.getView().getRow(girdcount).style.backgroundColor='#FFFF00';
}*/

 CarrierGrid.getStore().on('load',function(s,records){
        var girdcount=0;
        s.each(function(r)
        {
            if(r.get('UrgentFlag')=='Y')
            {
                CarrierGrid.getView().getRow(girdcount).style.backgroundColor='#E6D1E3';
            }
            girdcount=girdcount+1;
        });
    });