
var admSchedule="";
var OeorditemID="";
var locRowid="";

var   winBook = new Ext.Window({
		//applyTo:'hello-win',
		//layout:'fit',
		title : '预约',
		layout:'border',
		width:1100,
		height:620,
		closeAction:'hide',
		//closeAction:'hide',
		plain: true,

		items: [
			centerView
		]
    });

function openBookWindow(admRowid,orderList,locDr)
{
	admSchedule=admRowid;
	OeorditemID=orderList;
	locRowid=locDr;
	
    
    winBook.show();
    if ( OeorditemID != "")
	 {
	  	var orderInfo = tkMakeServerCall("web.DHCRisBookAllResource","getOrderInfo",OeorditemID);
	  	//alert(orderInfo);
	  	var infoList = orderInfo.split("^");

		Ext.getCmp("patientID").setValue(infoList[0]);
	  	Ext.getCmp("patName").setValue(infoList[1]);
	  	Ext.getCmp("patSex").setValue(infoList[2]);
	  	Ext.getCmp("patAge").setValue( infoList[3]);
	  	Ext.getCmp("bookRes").setValue(infoList[5]);
	  	Ext.getCmp("bookDate").setValue(infoList[6]);
	  	Ext.getCmp("bookTime").setValue(infoList[7]);
	  	Ext.getCmp("orderDesc").setValue(infoList[4]);
	  	Ext.getCmp("bookSchduleRowid").setValue(infoList[8]);
	  	
	  	var attention=infoList[11];
	  	attention=attention.replace(/<br>/g,"\r\n");	  
	  	Ext.getCmp("attention").setValue(attention);
	  
	  	Ext.getCmp("ApplicationBill").setValue(infoList[13]+"\r\n"+infoList[14]);
	  	
	  	Ext.getCmp('btnSchedule').setDisabled(false);
		Ext.getCmp('btnCancelSch').setDisabled(false);
	  	
	  }
	  else
	  {
		Ext.getCmp("patientID").setValue("");
		Ext.getCmp("patName").setValue("");
		Ext.getCmp("patSex").setValue("");
		Ext.getCmp("patAge").setValue( "");
		Ext.getCmp("bookRes").setValue("");
		Ext.getCmp("bookDate").setValue("");
		Ext.getCmp("bookTime").setValue("");
		Ext.getCmp("orderDesc").setValue("");
		Ext.getCmp("bookSchduleRowid").setValue("");

		Ext.getCmp("attention").setValue("");

		Ext.getCmp("ApplicationBill").setValue("");
		Ext.getCmp('btnSchedule').setDisabled(true);
		Ext.getCmp('btnCancelSch').setDisabled(true);
	  }
	  
	  
	  var dateObj1 = Ext.getCmp("bookDate1");
	  dateObj1.setValue(new Date());
	  var dateObj2 = Ext.getCmp("bookDate2");
	  dateObj2.setValue(new Date().add(Date.DAY,1));

	  Ext.getCmp("week1").setValue(showWeek(dateObj1.getValue()));
	  Ext.getCmp("week2").setValue(showWeek(dateObj2.getValue()));
	  
	  
	  loadResSchduleStore();
	  
	  if ( locRowid!="")
	  {
		   resourceProxy.on('beforeload',function(objProxy,param){
					 	param.ClassName='web.DHCRisBookAllResource';
						param.QueryName='QueryResource';
						param.Arg1 = locRowid;
						param.ArgCnt = 1;	
 			});	
			resourceStore.load();
			
			docProxy.on('beforeload',function(objProxy,param){
					 	param.ClassName='web.DHCRisBookAllResource';
						param.QueryName='QueryDoc';
						param.Arg1 = locRowid;
						param.ArgCnt = 1;	
 			});	
			docStore.load()
			
		  
 			//imageGroupStore.load();
 		}
			
	  

}


/*
Ext.onReady(function(){
	
		var View =  new Ext.Viewport({
			id:'view',
			layout:'border',
			//layout:'form',
			items:[
				centerView
			]
			
		});
		
		
	  if ( OeorditemID != "")
	  {
	  	var orderInfo = tkMakeServerCall("web.DHCRisBookAllResource","getOrderInfo",OeorditemID);
	  	//alert(orderInfo);
	  	var infoList = orderInfo.split("^");

		Ext.getCmp("patientID").setValue(infoList[0]);
	  	Ext.getCmp("patName").setValue(infoList[1]);
	  	Ext.getCmp("patSex").setValue(infoList[2]);
	  	Ext.getCmp("patAge").setValue( infoList[3]);
	  	Ext.getCmp("bookRes").setValue(infoList[5]);
	  	Ext.getCmp("bookDate").setValue(infoList[6]);
	  	Ext.getCmp("bookTime").setValue(infoList[7]);
	  	Ext.getCmp("orderDesc").setValue(infoList[4]);
	  	Ext.getCmp("bookSchduleRowid").setValue(infoList[8]);
	  	
	  	Ext.getCmp("attention").setValue(infoList[11]);
	  
	  	Ext.getCmp("ApplicationBill").setValue(infoList[13]+"\r\n"+infoList[14]);
	  	
	  	//var BookTime = tkMakeServerCall("web.DHCRisTestPan","BookTime",OeorditemID);
	 	//Ext.getCmp("OeordTime").setValue(BookTime);	
	 	
	 	
	  }
	  else
	  {
	  		Ext.getCmp('btnSchedule').setDisabled(true);
			Ext.getCmp('btnCancelSch').setDisabled(true);
	  }
	  loadResSchduleStore();
	  
	  if ( locRowid!="")
	  {
		   resourceProxy.on('beforeload',function(objProxy,param){
					 	param.ClassName='web.DHCRisBookAllResource';
						param.QueryName='QueryResource';
						param.Arg1 = locRowid;
						param.ArgCnt = 1;	
 			});	
			resourceStore.load();
	  }
	  /*
	 // Ext.getCmp('btnSchedule').el.setStyle('background-image','-webkit-linear-gradient(top,red,yellow 40%,yellow 30%,red)');
		//背景色方式2
		Ext.getCmp('btnCancelSch').btnEl.setStyle('background-color',"yellow");
		//字体颜色
		//Ext.getCmp('btnBookIn').btnInnerEl.setStyle('color',"green");
		Ext.getCmp('btnBookIn').btnEl.setStyle('color',"green");
		Ext.getCmp('btnBookIn').btnEl.setStyle('font-size',"15px");
		* /
		
		//Ext.getCmp('btnSchedule').btnInnerEl.setStyle('color',"green");
		/*
		Ext.getCmp('btnSchedule').btnEl.setStyle('color',"red");
		Ext.getCmp('btnSchedule').btnEl.setStyle('font-size',"15px");
		Ext.getCmp('btnSchedule').btnEl.setStyle('width',"60px");
		* /
		//Ext.getCmp('btnSchedule').btnEl.setStyle('background-color',"red");
		//Ext.getCmp('btnSchedule').parent.btnEl.setStyle('background-color',"yellow");
		//Ext.fly('panelSchdule').parent().setStyle('background-color',"yellow"); 
		//Ext.fly('panelSchdule').setStyle('background-color',"yellow"); 
	});
*/	
//alert("main");