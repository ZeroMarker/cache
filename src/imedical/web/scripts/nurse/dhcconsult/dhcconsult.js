/**
 * @author Administrator
 */
var locdata=new Array();
var condata=new Array();
var arr=new Array();
//会诊查询
var a=cspRunServerMethod(pdata1,"","DHCCONSULTSCH","","");


arr=eval(a);
Ext.onReady(function() {
   new Ext.Viewport({
        layout: 'absolute',
        items:arr,
        renderTo: Ext.getBody()
    });

	var mydate=new Date();
	var stdate=Ext.getCmp("StDate");
	var enddate=Ext.getCmp("endDate");
	stdate.setValue(mydate.getDate());
	enddate.setValue(mydate.getDate()+3);
    var grid=Ext.getCmp('mygrid');
	grid.on('click',gridclick);
	grid.on('dblclick',griddblclick);
	var but=Ext.getCmp('_Button7');                  //查询
	but.on('click',FindAdmConsult);
	var but=Ext.getCmp('_Button6');                  //执行
	but.on('click',ChgConStatus2);
	var but=Ext.getCmp('_Button8');                  //撤销
	but.on('click',CancelConStatus);
	
	var but=Ext.getCmp("but2");
   // but.on('click',ModConsult);
	but.hide();
	var but=Ext.getCmp("but1");
   // but.on('click',ModConsult);
	but.hide();
	FindAdmConsult();
	
});
function griddblclick()
{
	 var grid=Ext.getCmp("mygrid");
  alert();
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myId = rowObj[0].get("RowID");
		EpisodeID=rowObj[0].get("EpisodeId");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}*/
		var frm = top.frames[0].document.forms["fEPRMENU"];
	  frm.EpisodeID.value=EpisodeID;
     ModConsult();
	}
}
function gridclick()
{
	 var grid=Ext.getCmp("mygrid");
  
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myId = rowObj[0].get("RowID");
		EpisodeID=rowObj[0].get("EpisodeId");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}*/
		var frm = top.frames[0].document.forms["fEPRMENU"];
	  frm.EpisodeID.value=EpisodeID;

	}
}
function FindAdmConsult()
{
	condata=new Array();
	var stdate=Ext.getCmp("StDate");
	var enddate=Ext.getCmp("endDate");
    cspRunServerMethod(GetListConsult,stdate.value,enddate.value,session['LOGON.CTLOCID'],"addconsult");
    var grid=Ext.getCmp("mygrid");
	//debugger;
    grid.store.loadData(condata);

}
var myId = "";



function ChgConStatus2()
{
	condata=new Array();
	var grid=Ext.getCmp("mygrid");
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myId = rowObj[0].get("RowID");
		EpisodeID=rowObj[0].get("EpisodeId");
		var ConDepID=rowObj[0].get("ConDepID");
		alert("ConDepID="+ConDepID)
		var ab="E"
		var we="Y"
		//alert(myId+"^"+ab+"^"+we+"^"+session['LOGON.USERID']+"^"+EpisodeID)
		//alert("@@@@@"+ChgConStatus)
		var ee=cspRunServerMethod(ChgConStatus,myId,ab,we,session['LOGON.USERID'],EpisodeID,ConDepID);
		//var ee=cspRunServerMethod(ChgConStatus,myId,ab,we,ConDepID,EpisodeID);
		alert(ee);
	}
	
	//debugger;
 //grid.store.loadData(condata);
 FindAdmConsult();
}



function CancelConStatus()
{
	alert(1);
	condata=new Array();
	var grid=Ext.getCmp("mygrid");
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myId = rowObj[0].get("RowID");
		EpisodeID=rowObj[0].get("EpisodeId");
		var ab="C"
		var we="N"
		var ee=cspRunServerMethod(ChgConStatus,myId,ab,we,session['LOGON.USERID'],EpisodeID);
		alert(ee);
	}
	
	//debugger;
 // grid.store.loadData(condata);
 FindAdmConsult();
}



function ModConsult()
{
   var grid=Ext.getCmp("mygrid");
  
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myId = rowObj[0].get("RowID");
		EpisodeID=rowObj[0].get("EpisodeId");
	}
 var arr=new Array();
 //录入界面
 var a=cspRunServerMethod(pdata1,"","DHCCONSULTPAT",EpisodeID,"");
 arr=eval(a);	
	var window = new Ext.Window({
		title: '会诊',
		width: 750,
		height: 650,
		autoScroll: true ,
		layout: 'absolute',
		//plain: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr,
		buttons: [{
			text: '保存',
			handler: function(){
				Save();
				window.close();
			}
		}, {
			text: '取消',
			handler: function(){
				window.close();
			}
		}]
	});
    var dep = Ext.getCmp("ConsultDep");
	if (dep!=null)	
	{
     cspRunServerMethod(getloc,'addloc');
     dep.store.loadData(locdata);
	}
  var ret=cspRunServerMethod(getSingleConsult,myId);
  var arr=ret.split("^");
  var dep= Ext.getCmp("ConsultDep");
  var appdate= Ext.getCmp("AppDate");
  var apptime= Ext.getCmp("AppTime");
  var typ= Ext.getCmp("ConType");
  var inout= Ext.getCmp("InOut");
  var destin= Ext.getCmp("ConDestination");
  var atti= Ext.getCmp("Attitude");
  dep.value=arr[5];
  appdate.value=arr[0];
  apptime.value=arr[1];
  typ.value=arr[4];
  atti.value=arr[2];
  destin.value=arr[3];
  inout.value=arr[7];
  window.show();

  
}
function addloc(a,b)
{
	locdata.push({
		id: a,
		desc: b
	});
}
function addconsult(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)
{
	condata.push({
		ConDep: a,
		ConDoc: b,
		Status: c,
		BedCode: d,
		PatDep: e,
		InOut: f,
		Diag: g,
		Destination: h,
		PatName: i,
		AppTime: j,
		AppDate: k,
		ConDate: l,
		ConTime: m,
		EpisodeId: n,
		RowID: o,
		Contyp:p,
		ConDepID:q
	});
}


function Save()
{
  var ret="";
  var dep= Ext.getCmp("ConsultDep").value;
  var appdate= Ext.getCmp("AppDate").value;
  var apptime= Ext.getCmp("AppTime").value;
  var typ= Ext.getCmp("ConType").value;
  var inout= Ext.getCmp("InOut").value;
    var atti= Ext.getCmp("Attitude").getRawValue();
 
  ret=ret+"Attitude|"+atti+"^";
 // ret=ret+"Status|E^";
  ret=ret+"ConsultDoc|"+session['LOGON.USERID']+"^";
  
  ret=ret+"id|"+myId;
  cspRunServerMethod(SaveCon,ret);
  FindAdmConsult();
 // alert(ret);
  
   
}
