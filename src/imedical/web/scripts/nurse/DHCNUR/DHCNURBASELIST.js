/**
 * @author Administrator
 */ 

function BodyLoadHandler() { 
	setsize("mygridpl", "gform", "mygrid");
  var grid = Ext.getCmp("mygrid");
  var but = Ext.getCmp("mygridbut1");
  but.on('click', newbase);
  var but2 = Ext.getCmp("mygridbut2");
  but2.on('click', ModtsyConsult);
  grid.on('click', gridclick);
  grid.on('dblclick', griddblclick); 
  //var GetModel=document.getElementById('GetModel');
  //cspRunServerMethod(GetModel.value,"addGetModel"); 
  FindBase();
} 
function ModtsyConsult() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
  var arrstr = new Array();
	if (len < 1) {
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		 Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		//alert(myId);
		arrstr=myId.split("__")
	
		myIdstr=arrstr[0]+"||"+arrstr[1]
			//alert(myIdstr);
		//EpisodeID = rowObj[0].get("EpisodeId");
		//SpeciaMed = rowObj[0].get("SpeciaMed");
		//var Status = rowObj[0].get("Status");
		//alert(Status)
	}

	var arr = new Array();  
	
  addItemGetModel("Item1","Item1");
  addItemGetModel("Item2","Item2");
  addItemGetModel("Item3","Item3");
  addItemGetModel("Item4","Item4");
  addItemGetModel("Item5","Item5");
  addItemGetModel("Item6","Item6");
  addItemGetModel("Item7","Item7");
  addItemGetModel("Item8","Item8");
  addItemGetModel("Item9","Item9");
  addItemGetModel("Item10","Item10");
  addItemGetModel("Item11","Item11");
  addItemGetModel("Item12","Item12");
  addItemGetModel("Item13","Item13");
  addItemGetModel("Item14","Item14");
  addItemGetModel("Item15","Item15");
  addItemGetModel("Item16","Item16");
  addItemGetModel("Item17","Item17");
  addItemGetModel("Item18","Item18");
  addItemGetModel("Item19","Item19");
  addItemGetModel("Item20","Item20");
  addItemGetModel("Item21","Item21");
  addItemGetModel("Item22","Item22");
  addItemGetModel("Item23","Item23"); 
  addItemGetModel("Item24","Item24");
  addItemGetModel("Item25","Item25");
  addItemGetModel("Item26","Item26"); 
  addItemGetModel("Item27","Item27");
  addItemGetModel("Item28","Item28");
  addItemGetModel("Item29","Item29");
  addItemGetModel("Item30","Item30");
  addItemGetModel("Item31","Item31");
  addItemGetModel("Item32","Item32");
  addItemGetModel("Item33","Item33");
  addItemGetModel("Item34","Item34");
  addItemGetModel("Item35","Item35");
  addItemGetModel("Item36","Item36");
  addItemGetModel("Item37","Item37");
  addItemGetModel("Item38","Item38");
  addItemGetModel("Item39","Item39");
  addItemGetModel("Item40","Item40");
  addItemGetModel("Item41","Item41");
  addItemGetModel("Item42","Item42");
  addItemGetModel("Item43","Item43");
  addItemGetModel("Item44","Item44");
  addItemGetModel("Item45","Item45");
  addItemGetModel("Item46","Item46");
  addItemGetModel("Item47","Item47");
  addItemGetModel("Item48","Item48");
  addItemGetModel("Item49","Item49");
  addItemGetModel("Item50","Item50");
  addItemGetModel("Item51","Item51");
  addItemGetModel("Item52","Item52");
  addItemGetModel("Item53","Item53");
  addItemGetModel("Item54","Item54");
  addItemGetModel("Item55","Item55");
  addItemGetModel("Item56","Item56");
  addItemGetModel("Item57","Item57");
  addItemGetModel("Item58","Item58");
  addItemGetModel("Item59","Item59");
  addItemGetModel("Item60","Item60");
  addItemGetModel("Item61","Item61");
  addItemGetModel("Item62","Item62");
  addItemGetModel("Item63","Item63");
  addItemGetModel("Item64","Item64");
  addItemGetModel("Item65","Item65");
  addItemGetModel("Item66","Item66");
  addItemGetModel("Item67","Item67");
  addItemGetModel("Item68","Item68");
  addItemGetModel("Item69","Item69");
  addItemGetModel("Item70","Item70");
  addItemGetModel("Item71","Item71");
  addItemGetModel("Item72","Item72");
  addItemGetModel("Item73","Item73");
  addItemGetModel("Item74","Item74");
  addItemGetModel("Item75","Item75");
  addItemGetModel("Item76","Item76");
  addItemGetModel("Item77","Item77");
  addItemGetModel("Item78","Item78");
  addItemGetModel("Item79","Item79");
  addItemGetModel("Item80","Item80");
  addItemGetModel("Item81","Item81");
  addItemGetModel("Item82","Item82");
  addItemGetModel("Item83","Item83");
  addItemGetModel("Item84","Item84");
  addItemGetModel("Item85","Item85");
  addItemGetModel("Item86","Item86");
  addItemGetModel("Item87","Item87");
  addItemGetModel("Item88","Item88");
  addItemGetModel("Item89","Item89");
  addItemGetModel("Item90","Item90");
  addItemGetModel("Item91","Item91");
  addItemGetModel("Item92","Item92");
  addItemGetModel("Item93","Item93");
  addItemGetModel("Item94","Item94");
  addItemGetModel("Item95","Item95");
  addItemGetModel("Item96","Item96");
  addItemGetModel("Item97","Item97");
  addItemGetModel("Item98","Item98");
  addItemGetModel("Item99","Item99");
  addItemGetModel("Item100","Item100");
 
   
 	var GetModel=document.getElementById('GetModel');
  //cspRunServerMethod(GetModel.value,"addGetModel");

  //debugger;
	var a = cspRunServerMethod(pdata1, "", "DHCNURBASE", "", "");
	arr = eval(a);
  var window = new Ext.Window({
				title : '基数维护',
				width : 520,
				height : 645,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '保存',
							handler : function() {
								Save(window);
								//window.close();
							}
						}, {
							text : '取消',
							handler : function() {
								window.close();
							}
						}]
			}); 
  parr =""  
 inidata("BaseMould","RecTyp","web.DHCNSTFun:GetModelQuery","Parr$"+parr)
  
 inidata("BaseRpCode","RecTyp","web.DHCNSTFun:GetRpCodeQuery","Parr$"+parr)
 
 var BaseMouldItem=Ext.getCmp('BaseMouldItem'); 
 BaseMouldItem.store.loadData(Itemlocdata); 
 
 var Button1=Ext.getCmp('Button1'); 
 Button1.on('click',ButtonSJ);
 
 var Button2=Ext.getCmp('Button2');
 Button2.on('click', ButtonSJ) 
  
 var Button3=Ext.getCmp('Button3');
 Button3.on('click', ButtonSJ) 

 var Button4=Ext.getCmp('Button4');
 Button4.on('click', ButtonSJ) 

 var Button5=Ext.getCmp('Button5');
 Button5.on('click', ButtonSJ) 

 var Button6=Ext.getCmp('Button6');
 Button6.on('click', ButtonSJ) 

 var Button7=Ext.getCmp('Button7');
 Button7.on('click', ButtonSJ) 

 var Button8=Ext.getCmp('Button8');
 Button8.on('click', ButtonSJ) 

 var Button9=Ext.getCmp('Button9');
 Button9.on('click', ButtonSJ) 
 
 var Button10=Ext.getCmp('Button10');
 Button10.on('click', ButtonSJ) 

 var Button11=Ext.getCmp('Button11');
 Button11.on('click', ButtonSJ) 

 var Button12=Ext.getCmp('Button12');
 Button12.on('click', ButtonSJ)  
  
 var Button13=Ext.getCmp('Button13');
 Button13.on('click', ButtonSJ)  
  
 var Button14=Ext.getCmp('Button14');
 Button14.on('click', ButtonSJ) 

 var Button15=Ext.getCmp('Button15');
 Button15.on('click', ButtonSJ)  
  
 var Button16=Ext.getCmp('Button16');
 Button16.on('click', ButtonSJ) 
  
 var ButtonItem=Ext.getCmp('ButtonItem');
 ButtonItem.on('click', ButtonItemSJ) 

  
  	var BaseName= Ext.getCmp("BaseName");
	var BaseCode= Ext.getCmp("BaseCode");
	var BaseFun=Ext.getCmp("BaseFun");
	var BaseMould=Ext.getCmp("BaseMould");
	var BaseRpCode=Ext.getCmp("BaseRpCode");
	var BaseCondicStr=Ext.getCmp("BaseCondicStr");
	                     
  var GetBASEbyId= document.getElementById('GetBASEbyId').value;
	// debugger;
	//alert(GetReportbyid);
	
	var ret = cspRunServerMethod(GetBASEbyId,myIdstr);
    //alert(ret);
  var arr = ret.split("@"); 
  
 //alert(arr[0]);
BaseName.value=arr[0];
BaseCode.value=arr[1];
BaseFun.value=arr[2];
BaseCondicStr.value=arr[4];
var GetZTbyId= document.getElementById('GetZTbyId').value;
	// debugger;
	//alert(GetReportbyid);
	
	var ret = cspRunServerMethod(GetZTbyId,arrstr[0]);

	var arrzt = new Array();
	arrzt=ret.split("^");    
BaseRpCode.value=arrzt[2]+" "+arrzt[0]+" "+arrstr[0];
//BaseRpCode.readOnly=true;
BaseRpCode.editable=false;
var Getmbbymc= document.getElementById('Getmbbymc').value;
	// debugger;
	//alert(GetReportbyid);
var retmb = cspRunServerMethod(Getmbbymc,arr[3]);   
BaseMould.value=retmb;
 

	window.show();
}

function gridclick() {
	var grid = Ext.getCmp("mygrid");

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		Ext.Msg.alert('提示', "请先选择一条诊断记录!"); 
		return;
	} else {
		myId = rowObj[0].get("RowID");
		//EpisodeID = rowObj[0].get("EpisodeId");
	}
}

function griddblclick() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		// Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("RowID");
		//EpisodeID = rowObj[0].get("EpisodeId");
		//SpeciaMed = rowObj[0].get("SpeciaMed");
		/*
		 * for (i = 0; i < top.frames.length; i++) { alert(top.frames[i].name); }
		 */
		// var frm = top.frames[0].document.forms["fEPRMENU"];
		var win = top.frames['eprmenu'];
		if (win) {
			var frm = win.document.forms['fEPRMENU'];
		} else {
			var frm = top.document.forms['fEPRMENU'];
		}
		//frm.EpisodeID.value = EpisodeID;
		//frm.EpisodeID.value = EpisodeID;
				ModtsyConsult();
			
	}
}
function FindBase() { 
	condata = new Array(); 
	var GetBase=document.getElementById('GetBase');
  cspRunServerMethod(GetBase.value,"addbase");
 	var grid = Ext.getCmp("mygrid");
	grid.width = document.body.offsetWidth;
	grid.store.loadData(condata);  
} 
   
function addbase(a,b,c,d,e,f)
{ 
	condata.push({ 
		RowID:a,
		BaseCode:b,
		BaseName:c,
		BaseFun:d,
		BaseMould:e,
		BaseExpress:f   
  });
}

	var Itemlocdata = new Array();  
  function addItemGetModel(a,b) {
	 Itemlocdata.push({
			id : a,
			desc :b			
	});
  }


function newbase() 
{ 
	myId = "";
	var arr = new Array();  
	
  addItemGetModel("Item1","Item1");
  addItemGetModel("Item2","Item2");
  addItemGetModel("Item3","Item3");
  addItemGetModel("Item4","Item4");
  addItemGetModel("Item5","Item5");
  addItemGetModel("Item6","Item6");
  addItemGetModel("Item7","Item7");
  addItemGetModel("Item8","Item8");
  addItemGetModel("Item9","Item9");
  addItemGetModel("Item10","Item10");
  addItemGetModel("Item11","Item11");
  addItemGetModel("Item12","Item12");
  addItemGetModel("Item13","Item13");
  addItemGetModel("Item14","Item14");
  addItemGetModel("Item15","Item15");
  addItemGetModel("Item16","Item16");
  addItemGetModel("Item17","Item17");
  addItemGetModel("Item18","Item18");
  addItemGetModel("Item19","Item19");
  addItemGetModel("Item20","Item20");
  addItemGetModel("Item21","Item21");
  addItemGetModel("Item22","Item22");
  addItemGetModel("Item23","Item23"); 
  addItemGetModel("Item24","Item24");
  addItemGetModel("Item25","Item25");
  addItemGetModel("Item26","Item26"); 
  addItemGetModel("Item27","Item27");
  addItemGetModel("Item28","Item28");
  addItemGetModel("Item29","Item29");
  addItemGetModel("Item30","Item30");
  addItemGetModel("Item31","Item31");
  addItemGetModel("Item32","Item32");
  addItemGetModel("Item33","Item33");
  addItemGetModel("Item34","Item34");
  addItemGetModel("Item35","Item35");
  addItemGetModel("Item36","Item36");
  addItemGetModel("Item37","Item37");
  addItemGetModel("Item38","Item38");
  addItemGetModel("Item39","Item39");
  addItemGetModel("Item40","Item40");
  addItemGetModel("Item41","Item41");
  addItemGetModel("Item42","Item42");
  addItemGetModel("Item43","Item43");
  addItemGetModel("Item44","Item44");
  addItemGetModel("Item45","Item45");
  addItemGetModel("Item46","Item46");
  addItemGetModel("Item47","Item47");
  addItemGetModel("Item48","Item48");
  addItemGetModel("Item49","Item49");
  addItemGetModel("Item50","Item50");
  addItemGetModel("Item51","Item51");
  addItemGetModel("Item52","Item52");
  addItemGetModel("Item53","Item53");
  addItemGetModel("Item54","Item54");
  addItemGetModel("Item55","Item55");
  addItemGetModel("Item56","Item56");
  addItemGetModel("Item57","Item57");
  addItemGetModel("Item58","Item58");
  addItemGetModel("Item59","Item59");
  addItemGetModel("Item60","Item60");
  addItemGetModel("Item61","Item61");
  addItemGetModel("Item62","Item62");
  addItemGetModel("Item63","Item63");
  addItemGetModel("Item64","Item64");
  addItemGetModel("Item65","Item65");
  addItemGetModel("Item66","Item66");
  addItemGetModel("Item67","Item67");
  addItemGetModel("Item68","Item68");
  addItemGetModel("Item69","Item69");
  addItemGetModel("Item70","Item70");
  addItemGetModel("Item71","Item71");
  addItemGetModel("Item72","Item72");
  addItemGetModel("Item73","Item73");
  addItemGetModel("Item74","Item74");
  addItemGetModel("Item75","Item75");
  addItemGetModel("Item76","Item76");
  addItemGetModel("Item77","Item77");
  addItemGetModel("Item78","Item78");
  addItemGetModel("Item79","Item79");
  addItemGetModel("Item80","Item80");
  addItemGetModel("Item81","Item81");
  addItemGetModel("Item82","Item82");
  addItemGetModel("Item83","Item83");
  addItemGetModel("Item84","Item84");
  addItemGetModel("Item85","Item85");
  addItemGetModel("Item86","Item86");
  addItemGetModel("Item87","Item87");
  addItemGetModel("Item88","Item88");
  addItemGetModel("Item89","Item89");
  addItemGetModel("Item90","Item90");
  addItemGetModel("Item91","Item91");
  addItemGetModel("Item92","Item92");
  addItemGetModel("Item93","Item93");
  addItemGetModel("Item94","Item94");
  addItemGetModel("Item95","Item95");
  addItemGetModel("Item96","Item96");
  addItemGetModel("Item97","Item97");
  addItemGetModel("Item98","Item98");
  addItemGetModel("Item99","Item99");
  addItemGetModel("Item100","Item100");
 
   
 	var GetModel=document.getElementById('GetModel');
  //cspRunServerMethod(GetModel.value,"addGetModel");

  //debugger;
	var a = cspRunServerMethod(pdata1, "", "DHCNURBASE", "", "");
	arr = eval(a);
  var window = new Ext.Window({
				title : '基数维护',
				width : 520,
				height : 645,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '保存',
							handler : function() {
								Save(window);
								//window.close();
							}
						}, {
							text : '取消',
							handler : function() {
								window.close();
							}
						}]
			}); 
  parr =""  
 inidata("BaseMould","RecTyp","web.DHCNSTFun:GetModelQuery","Parr$"+parr)
  
 inidata("BaseRpCode","RecTyp","web.DHCNSTFun:GetRpCodeQuery","Parr$"+parr)
 
 var BaseMouldItem=Ext.getCmp('BaseMouldItem'); 
 BaseMouldItem.store.loadData(Itemlocdata); 
 
 var Button1=Ext.getCmp('Button1'); 
 Button1.on('click',ButtonSJ);
 
 var Button2=Ext.getCmp('Button2');
 Button2.on('click', ButtonSJ) 
  
 var Button3=Ext.getCmp('Button3');
 Button3.on('click', ButtonSJ) 

 var Button4=Ext.getCmp('Button4');
 Button4.on('click', ButtonSJ) 

 var Button5=Ext.getCmp('Button5');
 Button5.on('click', ButtonSJ) 

 var Button6=Ext.getCmp('Button6');
 Button6.on('click', ButtonSJ) 

 var Button7=Ext.getCmp('Button7');
 Button7.on('click', ButtonSJ) 

 var Button8=Ext.getCmp('Button8');
 Button8.on('click', ButtonSJ) 

 var Button9=Ext.getCmp('Button9');
 Button9.on('click', ButtonSJ) 
 
 var Button10=Ext.getCmp('Button10');
 Button10.on('click', ButtonSJ) 

 var Button11=Ext.getCmp('Button11');
 Button11.on('click', ButtonSJ) 

 var Button12=Ext.getCmp('Button12');
 Button12.on('click', ButtonSJ)  
  
 var Button13=Ext.getCmp('Button13');
 Button13.on('click', ButtonSJ)  
  
 var Button14=Ext.getCmp('Button14');
 Button14.on('click', ButtonSJ) 

 var Button15=Ext.getCmp('Button15');
 Button15.on('click', ButtonSJ)  
  
 var Button16=Ext.getCmp('Button16');
 Button16.on('click', ButtonSJ) 
  
 var ButtonItem=Ext.getCmp('ButtonItem');
 ButtonItem.on('click', ButtonItemSJ) 

  
 window.show();
}  

function ButtonItemSJ(obj) 
{ 
	var BaseCondicStr=Ext.getCmp('BaseCondicStr'); 
	var tempstr=BaseCondicStr.getValue();
	var BaseMouldItem=Ext.getCmp('BaseMouldItem'); 
	var BaseMouldItemStr=BaseMouldItem.getValue(); 
	if(BaseMouldItemStr!="")
	{
    tempstr =tempstr +BaseMouldItemStr;
    BaseCondicStr.setValue(tempstr);
  } 
  else
  {
      Ext.Msg.alert('提示', "请选择元素后再添加!");
      return;
  }
}

function ButtonSJ(obj) 
{
  var BaseCondicStr=Ext.getCmp('BaseCondicStr'); 
	var tempstr=BaseCondicStr.getValue();	
	var str=obj.text;
	tempstr =tempstr +str.replace(" ","");	
	BaseCondicStr.setValue(tempstr);
} 



function inidata(cmbname,desc,quer,parr)
{
	var cmb=Ext.getCmp(cmbname);
	var querymth=document.getElementById('GetQueryCombox');
	if (cmb!=null)	
	{
 	 arrgrid=new Array();
	 var a = cspRunServerMethod(querymth.value, quer, parr , "AddRec",desc);
   cmb.store.loadData(arrgrid);
	}

}

function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}

function Save(window) {
   var ret = "";
   var id=""; 
   var BaseCodeobj=document.getElementById('BaseCode'); 
   var BaseCode=BaseCodeobj.value 
   var BaseNameobj=document.getElementById('BaseName'); 
   var BaseName = BaseNameobj.value; 
   var BaseFunobj=document.getElementById('BaseFun');
   var BaseFun=BaseFunobj.value; 
   var BaseMouldobj=document.getElementById('BaseMould');
   var BaseMould =BaseMouldobj.value;
   var tm=BaseMould.split(' ') 
   BaseMould=tm[0]   
   var BaseRpCodeobj=document.getElementById('BaseRpCode');
   var BaseRpCode =BaseRpCodeobj.value;
   var tm=BaseRpCode.split(' ') 
   var RecParref=tm[2] 
   var BaseCondicStrobj=document.getElementById('BaseCondicStr');
   var BaseCondicStr =BaseCondicStrobj.value;
   id=myId;
   ret = ret + "baseCode$C(15)" + BaseCode + "$C(10)"+"baseName$C(15)"+BaseName+"$C(10)"+"baseFun$C(15)"+BaseFun+"$C(10)"+"baseMould$C(15)"+BaseMould+"$C(10)"+"RecParref$C(15)"+RecParref+"$C(10)"+"baseCondicStr$C(15)"+BaseCondicStr+"$C(10)"+"id$C(15)"+id+"$C(10)"; 
   //alert(ret);
   //debugger
   var SaveSub=document.getElementById('SaveSub');
   //alert(SaveSub.value)
   cspRunServerMethod(SaveSub.value, ret);    
   window.close();
   FindBase();
}

/*
 
 } 
 
 
 var locdata = new Array();  
 function addGetModel(a,b) {
	locdata.push({
			id : a,
			desc :b			
	});
}

 

*/
