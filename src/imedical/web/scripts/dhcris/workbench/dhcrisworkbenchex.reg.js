//dhcrisworkbnechex.reg.js
///zzz  2016-05-22 

var SaveError='保存错误, '
//var UserRowID=''
var EpisodeID='' 
var LocDR=''
var BodyCode = '';
var gIsUpdate="0";
var	gUpdateNo="0";
var gbodyinfo="" ;
var GlobalObj = {
	LocDR : "",
	PaadmDR :"",
	OeorditemID : "",
	Device : "",
	DeviceDR : "",
	Room : "",
	RoomDR : "",
	EQGroup : "",
	EQGroupDR : "",
	ReqName : "",
	Name : "",
	DOB : "",
	Weight : "",
	IPNO : "",
	TELNO : "",
	RegDate : "",
	RegTime : "",
	GetIndex : "",
	MainDoc : "",
	MainDocDR : "",
	OptionDoc : "",
	OptionDocDR : "",
	NO : "",
	NoNumber : "",
	PatientType : "",
	InLoc : "",
	OPNO : "",
	BedCode : "",
	PrintName : "",
	TReqInputDate : "",
	GroupIndex : "",
	RoomIndex : "",
	Urgent : "",
	TReqStudyNo : "",	
	OrderDescReg : "",
	OrderRowidBodyList : "",
	RegNo:"",
	clearGlobal : function(){
		this.LocDR ="";
		this.PaadmDR ="";
		this.OeorditemID ="";
		this.Device ="";
		this.DeviceDR ="";
		this.Room ="";
		this.RoomDR ="";
		this.EQGroup ="";
		this.EQGroupDR ="";
		this.ReqName ="";
		this.Name ="";
		this.DOB ="";
		this.Weight ="";
		this.IPNO ="";
		this.TELNO ="";
		this.RegDate ="";
		this.RegTime ="";
		this.GetIndex ="";
		this.MainDoc ="";
		this.MainDocDR ="";
		this.OptionDoc ="";
		this.OptionDocDR ="";
		this.NO ="";
		this.NoNumber ="";
		this.PatientType ="";
		this.InLoc ="";
		this.OPNO ="";
		this.BedCode ="";
		this.PrintName ="";
		this.TReqInputDate ="";
		this.GroupIndex ="";
		this.RoomIndex ="";
		this.Urgent ="";
		this.TReqStudyNo ="";
		this.OrderDescReg="";
		this.OrderRowidBodyList="";
		this.RegNo="";
	}	
}
var TReqName = new Ext.form.TextField({
    	id:'TReqName',
   	 	fieldLabel:'姓名',
    	allowBlank:true,
   		//listWidth:150,
   		width:150,
    	anchor:'90%',
    	value:'',
    	disabled:true,
    	selectOnFocus:true
	});
	
	
var TRegNo = new Ext.form.TextField({
    	id:'TRegNo',
   	 	fieldLabel:'登记号',
    	allowBlank:true,
   		listWidth:150,
    	anchor:'90%',
    	value:'',
    	disabled:true,
    	selectOnFocus:true
	});
	
var TReqPY = new Ext.form.TextField({
    	id:'TReqPY',
    	fieldLabel:'拼音',
    	allowBlank:true,
    	listWidth:150,
    	disabled:true,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
	});
	
	
var TReqStudyNo = new Ext.form.TextField({
    	id:'TReqStudyNo',
    	fieldLabel:'检查号#',
    	allowBlank:true,
    	listWidth:150,
    	disabled:true,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
	});	
	
var TReqDOB = new Ext.form.TextField({
    	id:'TReqDOB',
    	fieldLabel:'生日',
    	allowBlank:true,
    	listWidth:150,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
	});	
	
var TReqWeight = new Ext.form.TextField({
    	id:'TReqWeight',
    	fieldLabel:'体重',
    	allowBlank:true,
    	listWidth:150,
    	anchor:'90%',
    	value:'',
    	disabled:true,
    	selectOnFocus:true
	});	
	
var TReqEQGroup = new Ext.form.TextField({
    	id:'TReqEQGroup',
    	fieldLabel:'检查室',
    	allowBlank:true,
    	listWidth:150,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
    	
	});	
	
var TReqRoom = new Ext.form.TextField({
    	id:'TReqRoom',
    	fieldLabel:'房间',
    	allowBlank:true,
    	listWidth:150,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
	});	
	
var TReqNO = new Ext.form.TextField({
    	id:'TReqNO',
    	fieldLabel:'编号#',
    	allowBlank:true,
    	listWidth:150,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
	});	
	
var TReqTELNO = new Ext.form.TextField({
    	id:'TReqTELNO',
    	fieldLabel:'电话',
    	allowBlank:true,
    	listWidth:150,
    	anchor:'90%',
    	value:'',
    	disabled:true,
    	selectOnFocus:true
	});	
	
	
var TReqIPNO = new Ext.form.TextField({
    	id:'TReqIPNO',
    	fieldLabel:'住院号',
    	allowBlank:true,
    	listWidth:150,
    	disabled:true,
    	anchor:'90%',
    	value:'',
    	selectOnFocus:true
	});						

var TReportInfo = new Ext.form.Checkbox({
    	id:'TReportInfo',
   	 	fieldLabel:'报告',
    	allowBlank:false,
   		listWidth:150
	});
	
var TUrgent = new Ext.form.Checkbox({
    	id:'TUrgent',
   	 	fieldLabel:'加急',
    	allowBlank:true,
   		listWidth:50,
    	anchor:'90%'
	});	
	
var GetIndex = new Ext.form.TextField({
    	id:'GetIndex',
    	fieldLabel:'流水号',
    	allowBlank:true,
    	disabled:true,
    	//listWidth:50,
    	width:50,
    	//anchor:'30%',
    	value:'',
    	selectOnFocus:true
	});	
var GroupIndex = new Ext.form.TextField({
    	id:'GroupIndex',
    	//fieldLabel:'流水号',
    	allowBlank:true,
    	width:50,
    	//anchor:'30%',
    	value:''
    	//selectOnFocus:true
	});	
var RoomIndex = new Ext.form.TextField({
    	id:'RoomIndex',
    	//fieldLabel:'流水号',
    	allowBlank:true,
    	disabled:true,
    	width:50,
    	//anchor:'30%',
    	value:''
    	//selectOnFocus:true
	});		
/*var TBodyCode = new Ext.form.Checkbox({
    	id:'TBodyCode',
   	 	fieldLabel:'BodyCode',
    	allowBlank:true,
   		listWidth:50,
    	anchor:'90%'
	});	*/
var TBodyCode = new Ext.form.TextField({
    	id:'TBodyCode',
   	 	fieldLabel:'登记部位',
    	allowBlank:true,
   		listWidth:150,
    	anchor:'90%',
    	value:'',
    	disabled:true,
    	selectOnFocus:true
	});
	
	/*
	items:[
		{
			xtype:'textarea',
			id:'attention',
			height:50,
			fieldLabel:'注意事项',
			anchor:'100%'
		}
	]
	*/
	
var orderDescReg= new Ext.form.TextArea({
		id:'orderDescReg',
		fieldLabel:'检查项目',
		anchor:'100%'
		
		});
// GroupIndex
// RoomIndex

var DeviceStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetDevice",method:"POST"
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
		,baseParams:{LocDR:'',RoomDR:''}
	});

var TReqDevice = new Ext.form.ComboBox({
		fieldLabel : '登记设备',
		//width:150,
		anchor:'90%',
		mode: 'local',
		id : 'TReqDevice',
		name : 'TReqDevice',
		value:'',
		triggerAction :"all",
		store : DeviceStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc',
		listeners : {//选择一行后触发的事件 
        'select' : function() { 
        	var EQDR = TReqDevice.getValue();//得到valueField的值 
        	//var url = TReqDevice.getRawValue();//得到displayField的值  
      
        	var RegInfo=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","GetRegGroupRoom",EQDR)
        	var RoomDesc=RegInfo.split("@");
        	var Room=RoomDesc[1].split("^");
        	Ext.getCmp('TReqRoom').setRawValue(Room[0]) ;
        	 GlobalObj.RoomDR=Room[1];
        	//alert(GlobalObj.RoomDR);
        					}
		} 

});

var MainDocStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetMainDoc",method:"POST"
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
		,baseParams:{LocDR:''}
	});

var TReqMainDoc = new Ext.form.ComboBox({
		fieldLabel : '操作技师',
		anchor:'90%',
		mode: 'local',
		id : 'TReqMainDoc',
		name : 'TReqMainDoc',
		value:'',
		triggerAction :"all",
		store : MainDocStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc'
});

var TReqOptionDoc = new Ext.form.ComboBox({
		fieldLabel : '辅助技师',
		anchor:'90%',
		mode: 'local',
		id : 'TReqOptionDoc',
		name : 'TReqOptionDoc',
		store : MainDocStore,
		value:'',
		triggerAction :"all",
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc'
});

var TReqInputDate = new Ext.form.DateField({
		fieldLabel : '执行日期',
		id : 'TReqInputDate',
		name : 'TReqInputDate',
		value:'',
		anchor : '90%',
		format : 'Y-m-d',
		value : new Date()
	});

var Info=new Ext.form.Label({
    	text:'请根据进度修改相应需求状态,再保存. ',
		align:'right',
		cls: 'classDiv2'
})	

var ItmPanel = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		autoScroll:true,
		frame : true,
		defaults:{style:'padding:0px,0px,0px,0px',border:false},
		items :[{
				layout : 'column',
				xtype:'fieldset',
				style:'padding:0px,0px,0px,0px',
				defaults:{border:false},
				items : [{
						xtype:'fieldset',
						columnWidth : 0.33,
						//items:[TReqName,TReqDOB,TReqDevice,,TReqMainDoc,TReqInputDate,TReportInfo]
						items:[TRegNo,TReqDOB,TReqDevice,TReqMainDoc,{xtype:'compositefield',fieldLabel:'流水号',items:[RoomIndex]}]
					},{
						xtype:'fieldset',
						columnWidth : 0.33,
						//items:[TReqPY,TReqWeight,TReqRoom,TReqOptionDoc,TReqNO,TUrgent]
						items:[TReqName,TReqWeight,TReqRoom,TReqOptionDoc,TUrgent]
					},{
						xtype:'fieldset',
						columnWidth : 0.33,
						//items:[TReqIPNO,TReqTELNO,TReqStudyNo,TReqEQGroup,{xtype:'compositefield',fieldLabel:'流水号',items:[GetIndex,GroupIndex,RoomIndex]},TBodyCode]
						items:[TReqPY,TReqTELNO,TReqStudyNo,TReqIPNO]
					},{
						xtype:'fieldset',
						columnWidth:0.95,
						items:[orderDescReg]
					}]
			}]
});

function AllowRegister(OrditemRowid)
{
	var IsCanReg=IsCanRegFun.value;
	var ret=cspRunServerMethod(IsCanReg,OrditemRowid);
	return ret;
}

//function Reg_click(gridobj)
function Reg_click()
{
	var OEOrdItemID ="";
  	var paadmdr="",paadmtype="";
  	var num=0;
  	var LastRegNo="";
  	var ReportInfo="";
  	var GroupIndex,RoomIndex;
    var HISRegNo="";
    var LastRecLocDR="";
	
		var regEQ=Ext.getCmp('TReqDevice').getValue();
		if (regEQ=="")
		{
			var Ans=confirm('没有选择设备，是否继续登记?')
			if (Ans==false) {return false;}
		}


		var No=Ext.getCmp('TReqNO').getValue();
   	var EQGroupDR=""; //Ext.getCmp('TReqName').getValue();
    	
  	var locdr=GlobalObj.LocDR ;
  	var paadmdr=  GlobalObj.PaadmDR ; 
  	var weight=Ext.getCmp('TReqWeight').getValue();
  	var RegDate= "" ; //GlobalObj.RegDate; 
  	var RegTime= "" ;  GlobalObj.RegTime; 
  	var GetIndex = "";Ext.getCmp('GetIndex').getValue(); 
	
		var EQDR=Ext.getCmp('TReqDevice').getValue();
	
		var RoomDR=GlobalObj.RoomDR;//Ext.getCmp('TReqRoom').getValue();
		var MainDocDR=Ext.getCmp('TReqMainDoc').getValue();
		var AssiantDocDR=Ext.getCmp('TReqOptionDoc').getValue();
	
		var INPNO = Ext.getCmp('TReqIPNO').getValue();
		var TelNo = Ext.getCmp('TReqTELNO').getValue();
		var userid = session['LOGON.USERID'];
		var StudyNo = ""; //Ext.getCmp('TReqStudyNo').getValue();
	
		var orderBodyList = GlobalObj.OrderRowidBodyList ; //GlobalObj.OeorditemID; 
	
		var Nodr=""
		
	  //是否加急 
	  var UrgentFlag=Ext.getCmp('TUrgent').getValue(); 
    if (UrgentFlag)
	  {
	     UrgentFlag="Y";
	  }
	  else 
	  {
		 UrgentFlag="N";
	  }
	/*	
	var isCharge=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","isChargeOrderList",orderBodyList);
	if (isCharge=="N")
	{
	 	CardBillClickReg(paadmdr,GlobalObj.RegNo);    //卡消费
	}
	*/
	  //var regInfo=AssiantDocDR+"^"+MainDocDR+"^"+""+"^"+orderBodyList+"^"+""+"^"+EQDR+"^"+locdr+"^"+userid+"^"+""+"^"+""+"^"+RoomDR+"^"+EQGroupDR+"^"+""+"^"+""+"^"+INPNO+"^"+TelNo+"^"+weight+"^"+""+"^"+""+"^"+""+"^"+""+"^"+UrgentFlag; //+"^"+SetGetFilmDate+"^"+Enhance+"^"+Duration;;
	  var regInfo=orderBodyList+"^"+EQDR+"^"+RoomDR+"^"+EQGroupDR+"^"+userid+"^"+AssiantDocDR+"^"+MainDocDR+"^"+TelNo+"^"+weight+"^"+locdr+"^"+UrgentFlag;
	 
   	var ret = tkMakeServerCall("web.DHCRisRegisterPatientDoEx","register",regInfo);
   	//alert(ret);
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
			alert('未收费不能登记!');
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
		 if (ret=="-10007")
		 {
			alert('已经登记,不能重复登记!');
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
	     	//winReg.opener.searchData();
	     	//window.top.searchData();
	     	//window.parent.searchData();
	     	//window.opener.document.getElementById("btnFind").click();
	     	//searchData();
	     	
	     }
		
	  	OrditemSelected();
	  	//searchData();
	  	//打印申请单
	  	//var appbillNoList=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","getAppBillNo",orderBodyList);
	  	//alert(appbillNoList);
	  	
	  	//printbill(appbillNoList);
	  	winReg.hide();
	    RegPrint_click();

}



function printbill(arItemIdList){
	
	//var arItemIdList="9";
	//alert(arItemIdList)
	var repIDArray=arItemIdList.split("^");
	for (var i=0;i<repIDArray.length;i++)
	{
		var repID=repIDArray[i];
		//alert(repID+i);
		runClassMethod(
   			"web.DHCAPPPrintCom",
   			 "getData",
   			 {   //'RepID':22,
	   			 'RepID':repID
	   		 },function(data){
		   		 
		   		 var reptype=data.PACatDesc
		   		 if(reptype=="CT"){
		   		 
			   		 printCT(data);
			   	 }else if(reptype=="CS"){
			   	 
				   	 printCS(data);
				 }else if(reptype=="HC"){
					 
					 printHC(data);
				 }else if(reptype=="WJ"){
						 
					 printWJ(data);
				 }else if(reptype=="XD"){
							 
					 printXD(data);
				 }
		   		 
		   		 
		   		             },"json")
	}
	      
}  

function OrditemSelected()
{
	/*
    var n=0;
    var InitRegFunction=InitRegParam.value;
   	var Info=cspRunServerMethod(InitRegFunction,strMutiOrditemRowid,BodyCodeStr);
   	if (Info!="")
   	{
   	   var Item=Info.split("^");
   	   MutiStudyNo=Item[0]; 
   	   Ext.getCmp('TReqStudyNo').setValue(MutiStudyNo.split("@")[0]) ;
   	   Ext.getCmp('GetIndex').setValue(Item[1]) ;
   	   GlobalObj.GetIndex=Item[1]
       GlobalObj.GroupIndex=Item[2];
	   GlobalObj.RoomIndex=Item[3];
   	}
  */ 	
   	//var ArrayStudyNo=MutiStudyNo.split("@");
   	var gsm = Ext.getCmp('CarrierGrid').getSelectionModel();
    var rows = gsm.getSelections();//根据选择列获取到所有的行
    //var urgengFlag="N";
  	if (rows.length > 0) {
	  	var GetRegNo="";
	    var GetRecLocDR=""
	    var SelCount=0;
	    var IsAppReg=true;
		var OEOrdStr="",BodyCodeStr="" 
	    for (var i = 0; i < rows.length; i++) {
	        var row = rows[i];
	      	GetRegNo=row.get('Tregno');
	      	GetRecLocDR=row.get('RecLocId');
		     PatientStatusCode=row.get('TOEORIItemStatus');		     
		     RegisterStatus=row.get('TPatientStatus');
		     var InOrdtemRoiwd=row.get('TOeorditemdr');		     
		     var BodyCode=row.get('BodyCode');//StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_MainDoc_"^"_AssDoc_"^"_RoomDesc_"^"_RoomDr_"^"_EQDescdr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_ssuserdr_"^"_MainDocDr_"^"_assDocDr_"^"_BodyInfo_"^"_Num_"^"_$g(ReportInfo)_"^"_$g(strRegDate4)_"^"_Urgentflag_"^"_GroupIndex_"^"_RoomIndex_"^"_RegDoc_"^"_IndexTypeDR_"^"_IndexTypeDesc
		     //alert(regInfo);
		     var regInfo=tkMakeServerCall("web.DHCRisCommFunctionEx","GetRegInfo",InOrdtemRoiwd,BodyCode)
		     //alert(regInfo);
		     var infoArray=regInfo.split("^");
		     Ext.getCmp('TReqStudyNo').setValue(infoArray[0]);
		     GlobalObj.TReqStudyNo=infoArray[0];
		     Ext.getCmp('GetIndex').setValue(infoArray[3]);  //22 roomindex
		     Ext.getCmp('RoomIndex').setValue(infoArray[22]);
		     //Ext.getCmp('AccUsePrice').setValue(infoArray[27]);
		     //Ext.getCmp('BilledDesc').setValue(infoArray[28]);
		     row.set("TPatientStatus","登记");
		     row.set("TStudyNo",infoArray[0]);
		     row.set("TstrRegDate",infoArray[1]);
		     row.set("TstrRegTime",infoArray[2]);
		     row.set("TRegRoom",infoArray[7]);
		     row.set("TRegEQ",infoArray[4]);
		     row.set("AccUsePrice",infoArray[26]);
		     row.set("BilledDesc",infoArray[27]);
		     //urgengFlag=infoArray[20];
		     row.set("UrgentFlag",infoArray[20]);
		     
		     if (infoArray[20]=="Y")
		     {
			 	var store = CarrierGrid.getStore();
				var dataIndex = store.indexOf(row);
				CarrierGrid.getView().getRow(dataIndex).style.backgroundColor='#E6D1E3';
			     //row.style.backgroundColor="#FF0";			     
		     } 
		     
		     else 
		     {
			    // 2019-08-21 章怀钊 
			    var store = CarrierGrid.getStore();
				var dataIndex = store.indexOf(row);
				CarrierGrid.getView().getRow(dataIndex).style.backgroundColor='#FFFFFF';
				
			     }
	    }
  	}
    
    //var 
}

function GetBookedInfoNew()
{
		//if (GlobalObj.OeorditemID=="") return;	
		//var GetBookedInfoFunction=GetBookedInfo.value;
    //var RegInfo=cspRunServerMethod(GetBookedInfoFunction,GlobalObj.OeorditemID);
    
    //alert(GlobalObj.OrderRowidBodyList);
    var RegInfo=tkMakeServerCall("web.DHCRisBookParam","GetBookedInfo",GlobalObj.OrderRowidBodyList);
  	var tem1=RegInfo.split("^");
   	if (tem1[13]!="")
  	{
	  	Ext.getCmp('TReqDevice').setValue(tem1[13]) ;
	  	Ext.getCmp('TReqDevice').setRawValue(tem1[6]) ;
	  	Ext.getCmp('TReqRoom').setValue(tem1[12]);
	  	Ext.getCmp('TReqEQGroup').setValue(tem1[10]);
	  	
		  GlobalObj.Device=tem1[6];
			GlobalObj.DeviceDR=tem1[13];
			GlobalObj.Room=tem1[12];
			GlobalObj.RoomDR=tem1[11];
			GlobalObj.EQGroup=tem1[10];
			GlobalObj.EQGroupDR=tem1[9];
  	} 	
}


function GetSelRegInfoNew()
{
		var Pinyin;
		//var oeorditemrowid=GlobalObj.OeorditemID ;
		//var paadmdr=GlobalObj.PaadmDR ;
    //var RegInfo=cspRunServerMethod(GetSelRegInfo.value,oeorditemrowid,paadmdr,gbodyinfo);
    
    
    //web.DHCRisCommFunctionEx).getOrderItemInfo("")
    //RegNo_"^"_Name_"^"_PinYin_"^"_strDOB_"^"_SexDesc_"^"_patienttype_"^"_IPNO_"^"_Telphone_"^"_orderBodyListDesc
    var RegInfo=tkMakeServerCall("web.DHCRisCommFunctionEx","getOrderItemInfo",GlobalObj.OrderRowidBodyList);
    
   	var tem1=RegInfo.split("^");

	var weight="";
		if (tem1[10]!="")
		{
			weight=tem1[10]+"Kg";
		}
		Ext.getCmp('TRegNo').setValue(tem1[0]);
		Ext.getCmp('TReqName').setValue(tem1[1]);
		Ext.getCmp('TReqPY').setValue(tem1[2]);
		Ext.getCmp('TReqDOB').setValue(tem1[3]);
		Ext.getCmp('TReqWeight').setValue(weight);
		Ext.getCmp('TReqIPNO').setValue(tem1[6]);
		Ext.getCmp('TReqTELNO').setValue(tem1[7]);
		Ext.getCmp('orderDescReg').setValue(tem1[8]);
		if (tem1[9] == "Y")
		{
			Ext.getCmp('TUrgent').setValue("true");
		}
		
		GlobalObj.RegNo=tem1[0];
		GlobalObj.ReqName=tem1[1];
		GlobalObj.Name=tem1[2];
		GlobalObj.DOB=tem1[3];
		GlobalObj.Weight=weight;
		GlobalObj.IPNO=tem1[6];
		GlobalObj.TELNO=tem1[7];
		GlobalObj.OrderDescReg=tem1[8];
	/*
	GlobalObj.RegDate=tem1[5];
	GlobalObj.RegTime=tem1[6];
	GlobalObj.GetIndex=tem1[7];
	Ext.getCmp('GetIndex').setValue(tem1[7]);
	if (tem1[8]!="")
	{
		Ext.getCmp('TReqDevice').setValue(tem1[9]) ;
	  	Ext.getCmp('TReqDevice').setRawValue(tem1[8]) ;

	  	Ext.getCmp('TReqRoom').setValue(tem1[14]);
	  	Ext.getCmp('TReqEQGroup').setValue(tem1[16]);
	  	
	  	GlobalObj.Device=tem1[8];
		GlobalObj.DeviceDR=tem1[9];
		GlobalObj.Room=tem1[14];;
		GlobalObj.RoomDR=tem1[15];
		GlobalObj.EQGroup=tem1[16];
		GlobalObj.EQGroupDR=tem1[17];
		var PrintTemplate=cspRunServerMethod(GetPrintTemplate.value,tem1[9]);
		if (PrintTemplate!="") gPrintTemplate=PrintTemplate;

	}	
	Ext.getCmp('TReqMainDoc').setValue(tem1[10]);
	Ext.getCmp('TReqOptionDoc').setValue(tem1[12]);
	Ext.getCmp('TReqNO').setValue(tem1[18]);

	GlobalObj.MainDoc=tem1[10];
	GlobalObj.MainDocDR=tem1[11];
	GlobalObj.OptionDoc=tem1[12];
	GlobalObj.OptionDocDR=tem1[13];
	GlobalObj.NO=tem1[18];
	
	if (tem1[21]=="Y")
	{
		Ext.getCmp('TReportInfo').setValue(true)
	}
	else
	{
	     Ext.getCmp('TReportInfo').setValue(false)
	}

	GlobalObj.PatientType=tem1[22];
	GlobalObj.InLoc=tem1[23];
	GlobalObj.OPNO=tem1[24];
	GlobalObj.BedCode=tem1[25];
	GlobalObj.PrintName=tem1[26];
	
 	var bodyinfo1=tem1[19];
 	var Nums=tem1[20];
 	var tem2=bodyinfo1.split("~");
	if(tem1[27]!="")
	{
		Ext.getCmp('TReqInputDate').setValue(tem1[27])
		GlobalObj.TReqInputDate=tem1[27];
	}
	GlobalObj.GroupIndex=tem1[28];
	GlobalObj.RoomIndex=tem1[29];
	
	var UgentObj=Ext.getCmp('TUrgent')
	if (UgentObj)
	{
		if (tem1[30]=="Y")
		{
			UgentObj.setValue(true)
		}
		else
		{
			UgentObj.setValue(false)
		}
		GlobalObj.UgentObj=tem1[30];	
	}
	Ext.getCmp('TReqStudyNo').setValue(tem1[31]);
	GlobalObj.TReqStudyNo=tem1[31];	
	*/
}

function GetNo()
{
  var oeorditemrowid=GlobalObj.OeorditemID ;
  var locdr=GlobalObj.LocDR ;
  var EQGroupDesc=GlobalObj.EQGroup ;
  var GetNOFunction=GetNoFun.value;
  var NoInfo=cspRunServerMethod(GetNOFunction,oeorditemrowid,EQGroupDesc,locdr);
  var NOItem=NoInfo.split("^");
  
  Ext.getCmp('TReqNO').setValue(NOItem[0]+NOItem[1])
  GlobalObj.NO=NOItem[0]+NOItem[1];
  GlobalObj.NoNumber=NOItem[1];
  if (NOItem[2]=="1")
  {
   	gUpdateNo="1";
  }
  else
  {
   	gUpdateNo="0";
  }
}


function GetLastSelInfo()
{
	var locdr=GlobalObj.LocDR ;
    var GetFunction=GetSession.value;
	var Info=cspRunServerMethod(GetFunction,locdr);
	var Item=Info.split("^");
	if ((GlobalObj.DeviceDR=="")&&(Info!=""))
	{
		if (Item[1]!="")
		{
			GlobalObj.DeviceDR=Item[1];
			var GetEQPrintTemplateFun=GetPrintTemplate.value;
			var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,Item[1]);
			if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
			Ext.getCmp('TReqDevice').setValue(Item[0])
			GlobalObj.Device=Item[0];
	  		Ext.getCmp('TReqRoom').setValue(Item[4]);
	  		Ext.getCmp('TReqEQGroup').setValue(Item[2]);

	    	GlobalObj.EQGroup=Item[2];
	    	GlobalObj.EQGroupDR=Item[3];
	    	GlobalObj.Room=Item[4];
			GlobalObj.RoomDR=Item[5];
		}
		document.getElementById("MainDoc").value=Item[6];
		document.getElementById("MainDocDR").value=Item[7];
		document.getElementById("OptionDoc").value=Item[8];
		document.getElementById("OptionDocDR").value=Item[9];
		
		Ext.getCmp('TReqMainDoc').setValue(Item[6]);
		Ext.getCmp('TReqOptionDoc').setValue(Item[8]);

		GlobalObj.MainDoc=Item[6];
		GlobalObj.MainDocDR=Item[7];
		GlobalObj.OptionDoc=Item[8];
		GlobalObj.OptionDocDR=Item[9];
		var oeorditemrowid=GlobalObj.OeorditemID;
	}
}
//get location register print template
function GetLocRegTemplate()
{
   var locdr=GlobalObj.LocDR;
   var GetRegTempFunction=GetLocPrintTemp.value;
   gPrintTemplate=cspRunServerMethod(GetRegTempFunction,locdr);	
}

function InitComboStore()
{
	MainDocStore.setBaseParam("LocDR",GlobalObj.LocDR);
	MainDocStore.removeAll();
	MainDocStore.load({params:{start:0,limit:25}});
	
	DeviceStore.setBaseParam("LocDR",GlobalObj.LocDR);
	DeviceStore.setBaseParam("RoomDR",'');
	DeviceStore.removeAll();
	DeviceStore.load({params:{start:0,limit:25}});
}

function InitDocument()
{
	InitComboStore();
	GetBookedInfoNew();
	GetSelRegInfoNew();
	//GetNo(); 
	GetLastSelInfo() ;
	GetLocRegTemplate();
}

var winReg = new Ext.Window({
			title : '登记',
			width : 850,
			height : 350,
			autoScroll : true,
			layout : 'absolute',
			items:ItmPanel,
			closeAction:'hide',
			modal :'true',
			buttons : [{
				text : '登记',
				handler : function() {
					//Reg_click(gridobj);
					Reg_click();
				}
			},{
				text : '打印',
				handler : function() {
					RegPrint_click();
				}
			}]
});

function InitWindows(gridobj)
{

	winReg.show();
	/*
	 win.on("beforedestroy",function(){
      alert("关闭窗体");

     });
     */
     /*
    win.on('close',function(){
	    alert("1");
	    searchData();
		    
	});
	*/
}

function clearInterface()
{
		Ext.getCmp('TReqNO').setValue("");
		Ext.getCmp('TReqStudyNo').setValue("");
		 
		Ext.getCmp('GetIndex').setValue("");  
		Ext.getCmp('RoomIndex').setValue("");
   		Ext.getCmp('TReqName').setValue("");     		
  		Ext.getCmp('TReqWeight').setValue("");  
  		
		Ext.getCmp('TReqDevice').setValue("");  	
		Ext.getCmp('TReqRoom').setValue("");  
		Ext.getCmp('TReqMainDoc').setValue("");  
		Ext.getCmp('TReqOptionDoc').setValue("");  
	
		Ext.getCmp('TReqIPNO').setValue("");  
		Ext.getCmp('TReqTELNO').setValue("");  
		Ext.getCmp('TUrgent').setValue(false);
}

function RegRisEx(gridobj,DepID,EpisodeID,OEID,BodyCode,TBodyPartStr)
 {
	 clearInterface();
	 GlobalObj.clearGlobal();
	 GlobalObj.LocDR=DepID;
	 GlobalObj.PaadmDR=EpisodeID;
	 //GlobalObj.OeorditemID=OEID;
	 //GlobalObj.BodyCode=BodyCode;
	 GlobalObj.OrderRowidBodyList=OEID;
	 InitWindows(gridobj);
	 InitDocument();
	 //TBodyCode.setValue(TBodyPartStr);
	 //gbodyinfo=BodyCode ;
	
	/*winReg.on('close',function(){
	    alert("1");
	    searchData();
		    
	});
	*/
	/*
	var url = 'dhcrisworkbenchex.new.config.csp?actiontype=GetRegPatInfo&PaadmDR='+PaadmDR;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		
		success : function(result, request) {
			var jsonData = result.responseText;
			if (jsonData != '') {
				
				GetBookedInfo()
				GetSelRegInfo();
				//SetData(jsonData);
				
			} else {
				Msg.info("error", "查询错误:"+jsonData.info);
			}
		},
		scope : this
	});	
	*/

}
function CardBillClickReg(paadmdr,PatientID){
	
		var EpisodeID=paadmdr;	//就诊号
	var PatientID=PatientID;//登记号
	
	//(web.DHCRisWorkBenchDoEx).getPatMasRowid("")
	var patMasRowid=tkMakeServerCall("web.DHCRisWorkBenchDoEx","getPatMasRowid",PatientID);
	var OrderRowidBodyArray=GlobalObj.OrderRowidBodyList.split("@");
	
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
	
	//alert(EpisodeID);
	//alert(PatientID);
	//if (EpisodeID=="") {alert("警告","缺少患者信息");return;}
	var groupDR=session['LOGON.GROUPID'];
	//var mode=tkMakeServerCall("web.udhcOPBillIF","GetCheckOutMode",groupDR);
	//alert("mode=="+mode)
	var mode=1	//zfb-add 2016.7.22
    if(mode==1){
    	var cardNO="";
    	var cardNO=tkMakeServerCall("web.UDHCJFBaseCommon","GetCardNoByRegNo",patMasRowid);	//zfb-add 2016.7.22
    	//alert("cardNO=="+cardNO)
    	var insType=tkMakeServerCall("web.DHCRisWorkBenchDoEx","GetFeeType",EpisodeID)	//病人费别;;
    	//alert(insType);
    	var oeoriIDStr="";
    	var guser=session['LOGON.USERID'];
    	var groupDR=session['LOGON.GROUPID'];
    	var locDR=session['LOGON.CTLOCID'];
    	var hospDR=session['LOGON.HOSPID']; 
    	//alert(cardNO+"^"+patMasRowid+"^"+EpisodeID+"^"+insType+"^"+orderList+"^"+guser+"^"+groupDR+"^"+GlobalObj.LocDR+"^"+hospDR);
    	var rtn=checkOut(cardNO,patMasRowid,"",insType,orderList,guser,groupDR,GlobalObj.LocDR,hospDR);
    	//alert("卡消费返回="+rtn);
    	return;	
    }
}	
function RegPrint_click()
{
	
	try 
	{
				//alert(GlobalObj.TReqStudyNo);
				
				//alert(GlobalObj.LocDR)
				
				var gPrintTemplate=tkMakeServerCall("web.DHCRisPatRegisterDoEx","GetLocPrintTemplate",GlobalObj.LocDR);     //="DHCRisReg" // 
			    if (gPrintTemplate=="")
			    {
				    
				   //alert("请先配置打印模板!");
				   return;
			    }
			    //alert(gPrintTemplate);
			    var PatStudyNo=GlobalObj.TReqStudyNo;
			    if(PatStudyNo==""){
				    return;
				    }
			    DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
          
				//var oeOrdDr=serviceOrderGrid.getStore().getAt(index).get('oeOrdDr');
				//alert(GlobalObj.OeorditemID)
				var PrintData=tkMakeServerCall("web.DHCRisRegisterPatientDoEx","GetRegBillDataNew",PatStudyNo);
			
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
			     	   var OrdItemName=Item[25];
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

			var bookInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBookedPrintByloc",GlobalObj.OrderRowidBodyList);
				//alert(bookInfo);
			if(bookInfo!="")
			{
				Items=bookInfo.split("^");
		 	 // var OeItemID=oeOrdDr; 
		 	  var ResourceDesc=Items[2];      //预约资源    
		 	  var BookedDate=Items[3];        //预约日期
		 	  var BookedTime=Items[4];        //预约时间
		 	  var BookEndTime=Items[5];
		 	  var IndexBook=Items[9];         //预约流水号
		 	  var Address=Items[12];          //物理地址
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
				
			  MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate;
			  MyPara=MyPara+"^Bookedtime"+String.fromCharCode(2)+BookedTime+"-"+BookEndTime;
			  MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+ResourceDesc;
			  MyPara=MyPara+"^StarTime"+String.fromCharCode(2)+BookedTime;
			  MyPara=MyPara+"^index"+String.fromCharCode(2)+IndexBook;
			  MyPara=MyPara+"^Address"+String.fromCharCode(2)+Adress;
		   	  MyPara=MyPara+"^RegAdd"+String.fromCharCode(2)+RegAdd;
				
			}
			
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFunHDLP("",MyPara,"");	
		   		
					
        }

	}
	
	catch(e) 
	{
		alert(e.message);
	}
        
}

