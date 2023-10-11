/**
 * @author Administrator
 */

function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
	//alert(EmrCode)
	var grid = Ext.getCmp('mygrid');
	var but = Ext.getCmp("mygridbut1");
	
	but.on('click', newEvent);
	//but1.hide();
	var but = Ext.getCmp("mygridbut2");
	//but.hide();
	
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	grid.on('rowdblclick',modccevent);
	tobar.addButton({
		className: 'new-topic-button',
		text: "新建",
		handler: newEvent,
		id: 'mygridnewEvent'
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "作废",
		handler: function(){setStatus("N")},
		id: 'mygridsetNStatus'
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "启用",
		handler: function(){setStatus("Y")},
		id: 'mygridsetYStatus'
	});
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	});
	
   tobar.doLayout(); 
   setTimeout("find()",0)

}

function setStatus(statusflag)
{
	var grid=Ext.getCmp('mygrid');
    var objsetStatus=document.getElementById('SetStatus');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	else
	{
		
		var RecStatus = objRow[0].get("Status");
		if(statusflag==RecStatus) 
		{
			alert("该记录状态与欲修改状态一致，不需要修改！");
			return;
		}
		var AlertMsg="";
		if(statusflag=="Y") AlertMsg="您确定要启用这条记录吗？";
		else AlertMsg="您确定要作废这条记录吗？";
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: AlertMsg,    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            var par = objRow[0].get("par");
				var a = cspRunServerMethod(objsetStatus.value,par,statusflag);
				find();
	            }
				else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	    });
	}
	//find();
}
function khszqdtj()
{
	var grid=Ext.getCmp('mygrid');
  var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要提交？提交后不可修改',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	            KSubmitFu();
	            
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	    });
	}
	//find();
}
function qddelete()
{
	  var grid=Ext.getCmp('mygrid');
  var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	var Status = objRow[0].get("Status");
	//if ((objRow.length != 0)&&(Status!="未上报")) { Ext.Msg.alert('提示', "已经上报不可以删除!"); return;}
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要删除这条记录吗?',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            //alert(3); 
	            delete1();
	            
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	    });
	}
	
	//find();
}
function delete1()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
	 var SetStatus=document.getElementById('delete1');
	 var par = objRow[0].get("par");
	
		var a = cspRunServerMethod(SetStatus.value,par);		
		find();
	}
	
	
	
	
	
	}
function layoutset()
{
	var GetLayoutItem=document.getElementById('GetLayoutItem');
	var ret=cspRunServerMethod(GetLayoutItem.value,session['LOGON.GROUPID'] ,EmrCode);
	//alert(session['LOGON.GROUPID']+EmrCode);
	var arr=ret.split("^");
	//alert(arr);
	
	for (var i=0;i<arr.length;i++)
	{
		var itm=arr[i];
		if (itm=="") continue;
		var itmarr=itm.split("|");
		var com=Ext.getCmp(itmarr[0]);
		com.disable();
	}

	//var com=Ext.getCmp("AuditFu");
	//com.disable();
}
function SetStatusFu(stat)
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
	    var SetStatus=document.getElementById('SetStatus');
		//var rw = objRow[0].get("rw");
		var id= objRow[0].get("par");
		//var id=rw+"||"+chl;
		var a = cspRunServerMethod(SetStatus.value,id,stat,session['LOGON.USERID'] );
		if (a=="")
		{find();}
	}

}
function SubmitFu()
{ //提交
   //alert();
   SetStatusFu('S1');
}
function KSubmitFu()
{ //提交
   //alert();
   SetStatusFu('S2');
}
function AuditFu()
{ //审核
  SetStatusFu('A');
}
function RefundFu()
{ //退回
	SetStatusFu('V');
}
function modccevent()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		var par = objRow[0].get("par");
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUR_LIFESIGNKBSNEW&NurRecId="+par;
	    var wind22=window.open(lnk,"htm",'left=10,top=5,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=600');
	}
	find();
}

function newEvent()
{
	
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUR_LIFESIGNKBSNEW&NurRecId=";
	var wind22=window.open(lnk,"htm",'left=10,top=5,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=600');
	find();
}

var REC=new Array();


var arrgrid=new Array();
function find()
{
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	arrgrid=new Array();
	var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
	var SerchStatus="";
	if(IfCancelRec) SerchStatus="N";
	else SerchStatus="Y";
	//alert(SerchStatus)
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurLifeSignRelated:GetLifeSignRelated", "parr$"+SerchStatus,"AddRec");
	
   mygrid.store.loadData(arrgrid);   
}


function AddRec(str)
{
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}


/*function(record,rowIndex,rowParams,store)
 {   
                    //禁用数据显示红色   
 if(record.data.pstate!=0)
 { 
    return 'x-grid-record-red';   
 }
 else
 { 
   return '';   
  }   
                       
} //end for getRowClass  

*/
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };

function MultiFun()
{
	var GetMulti=document.getElementById('GetMulti');
	var getcheckform=document.getElementById('getcheckform');	
	var ret= cspRunServerMethod(GetMulti.value, "DHCNUR6");
    var grid=Ext.getCmp('mygrid');
    var tt=ret.split('^');
	var ab="";
	for (i=0;i<tt.length;i++)
	{
		if (tt[i]=="") continue;
		//debugger;
		var dd=grid.getSelectionModel().getSelections()[0].get(tt[i]); 
		if (dd==undefined)dd=""
		if (dd!="") ab=ab+dd+"^"+tt[i]+"!";
		else ab=ab+"^"+tt[i]+"!";
	}
	var tabstr=cspRunServerMethod(getcheckform.value, "DHCNUR6",ab);
	var tabarr=tabstr.split('!');
		var tbitm=new Array();
		for (i = 0; i < tabarr.length; i++) 
		{
			if (tabarr[i] == "") 
				continue;
			var itmm = tabarr[i].split('^');
			tbitm.push({
				xtype: 'panel',
				id: itmm[0],
				title: itmm[1],
				//height: 1000,
				layout: 'absolute',
				//frame:false,
				//palin:false,
				closable: false,
				items: eval(itmm[2])
			
			})
				//alert(itmm[2]);
		}
	var subttab=new Ext.TabPanel({
	    activeTab : 0,//
        autoTabs: true,
        resizeTabs:true, 
        //height:200,
      //  width:300,
        enableTabScroll:true,
 	   items:tbitm
     });
	 
	var window = new Ext.Window({
		title: '多选',
		width: 450,
		height: 480,
		id:'mulForm',
		autoScroll: true,
		layout: 'fit',
		plain: true,
		frame:true,
		items: subttab ,  
		buttons:[{id:'mulselbut',text:'保存',handler:SaveMulCheck}]
	});
	
   window.show();

 
}
var checkret="";

function SaveMulCheck()
{
  checkret="";
  var gform=Ext.getCmp("mulForm");
  gform.items.each(eachItem, this);  
	var aa=checkret.split('^');
	var ht = new Hashtable();
	//debugger;
	for (i = 0; i < aa.length; i++) {
		if (aa[i] == "") 
			continue;
		var itm = aa[i].split('|');
		var aitm = itm[0].split('_');
		if (ht.contains(aitm[0])) {
		  var val=ht.items(aitm[0])
		  ht.remove(aitm[0]);
		  var dd=val+";"+itm[1];
		  ht.add(aitm[0],dd);
		}
		else {
		ht.add(aitm[0], itm[1])
	    }		
	}
	var mygrid=Ext.getCmp('mygrid');
	 for(var i in ht.keys())
	 {
	  var key =ht.keys()[i];
      var restr = ht.items(key);
	   mygrid.getSelectionModel().getSelections()[0].set(key,restr); 
	 }
	alert(checkret);

}
function add(a1, a2){
	attenitm.push({
		xtype:'panel',
		id: a1,
		title: a2,
		region:'center',
		height:1000,
		layout:'fit',
		closable:true,
		items:[]
	})
}
function multiSel(ret)
{
		var grid1=Ext.getCmp('multigrid');
		var code=grid1.getSelectionModel().getSelections()[0].get("itm3"); 
        var itname=grid1.getSelectionModel().getSelections()[0].get("itm4"); 
	    var getcheckform=document.getElementById('getcheckform');
		alert(itname+"!!"+code)
		var ret=cspRunServerMethod(getcheckform.value, "DHCNUR6",itname,code,"");	
		var CareDate=grid.getSelectionModel().getSelections()[0].get("CareDate"); 
		var aa=new Array();
		aa=eval(aa);
    /*
		debugger;
		for(var i=0;i<items.length;i++){ 

            panl.remove(items[i]); 

          } 
    
       panl.doLayout();
		panl.add(new Ext.form.Checkbox({    
                    id:"addboxModule",                
                    name:"userModule",
                    boxLabel : 'moduleName' 
                   }));*/

		panl.doLayout();
		debugger;
		
 
}
function addMulitm(ret)
{
	var grid1=Ext.getCmp('multigrid');
  	var Plant = Ext.data.Record.create([
	{name:'itm1'},
	{name:'itm2'},
	{name:'itm3'},
	{name:'itm4'}
      ]);
	var itm=ret.split('^');
	for (i = 0; i < itm.length; i++) {
		if (itm[i]=="") continue;
		var aa=itm[i].split('!');
		var count = grid1.store.getCount();
		var r = new Plant({
			itm1: aa[0],
			itm2: "",
			itm3:aa[1],
			itm4:aa[2]
		});
		grid1.store.commitChanges();
		grid1.store.insert(count, r);
	}
   return;
   }
function Measure1()
{
  selections = grid.getSelectionModel().getSelections();
 	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 450,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
 var mydate=new Date();
 var butord=Ext.getCmp('_Button5');
 butord.on=('click',OrdSch1);
 window.show();
}
function InOutNod()
{ //小结
    
	var SaveOutIn=document.getElementById('SaveOutIn');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先点'统计'按钮!"); return; }
	else
	{
	  var countstr=""; //合计项
	  var countcls=ICountCls+"&"+OCountCls;
	  var tt=countcls.split('&');
	  for (i=0;i<tt.length;i++)
	  {
	  	if (tt[i]=="") continue;
		countstr=countstr+tt[i]+"|"+objRow[0].get(tt[i])+"^";
	  }
	  var CareDate=objRow[0].get("CareDate");
	  var CareTime=objRow[0].get("CareTime");
	  var inamount=objRow[0].get(DisplaySumInAmount);
	  var OutQtAmount=objRow[0].get(DisplaySumOutAmount);
	  var InPart=objRow[0].get(PartInAmount);
	  var OutPart=objRow[0].get(PartOutAmount);
	  //var StatTime=objRow[0].get("Item1");
	  //var StatHours=objRow[0].get("Item2");
	  var CaseMeasure=objRow[0].get("CaseMeasure");
	  var CaseMeasureArr=CaseMeasure.split(" ");
	  if (CaseMeasureArr.length>1)
	  {
	  	var StatTime=CaseMeasureArr[0];
	  	var StatHours=CaseMeasureArr[1];
	  }
	  else
	  {
	  	var StatTime="";
	  	var StatHours="";
	  }
		var str=countstr+"^SumInAmount|"+inamount+"^SumOutAmount|"+OutQtAmount+"^CareDate|"+formatDate(CareDate)+"^CareTime|"+CareTime+"^Typ|Nod^"+"InPart|"+InPart+"^OutPart|"+OutPart+"^StatTime|"+StatTime+"^StatHours|"+StatHours;
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
  		var selModel=diaggrid.getSelectionModel();
  		if (selModel.hasSelection()) {   
  			var objDiagRow = selModel.getSelections();		  			
				DiagnosDr=objDiagRow[0].get("rw");
			}
			else {
				DiagnosDr="";	
			}
		}
		else {
			DiagnosDr="";
		}
		str=str+"^DiagnosDr|"+DiagnosDr;
		//alert(str);
		var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6");
		find();
	}
}
function InOutSum()
{
	var SaveOutIn=document.getElementById('SaveOutIn');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先点'统计'按钮!"); return; }
	else
	{
	  var countstr=""; //合计项
	  var countcls=ICountCls+"&"+OCountCls;
	  var tt=countcls.split('&');
	  for (i=0;i<tt.length;i++)
	  {
	  	if (tt[i]=="") continue;
		countstr=countstr+tt[i]+"|"+objRow[0].get(tt[i])+"^";
	  }
      var CareDate=objRow[0].get("CareDate"); 
	  var CareTime=objRow[0].get("CareTime");
	  var inamount=objRow[0].get(DisplaySumInAmount);
	  var OutQtAmount=objRow[0].get(DisplaySumOutAmount);
	  var InPart=objRow[0].get(PartInAmount);
	  var OutPart=objRow[0].get(PartOutAmount);
		//var StatTime=objRow[0].get("Item1");
	  //var StatHours=objRow[0].get("Item2");
	  var CaseMeasure=objRow[0].get("CaseMeasure");
	  var CaseMeasureArr=CaseMeasure.split(" ");
	  if (CaseMeasureArr.length>1)
	  {
	  	var StatTime=CaseMeasureArr[0];
	  	var StatHours=CaseMeasureArr[1];
	  }
	  else
	  {
	  	var StatTime="";
	  	var StatHours="";
	  }
		var str=countstr+"^SumInAmount|"+inamount+"^SumOutAmount|"+OutQtAmount+"^CareDate|"+formatDate(CareDate)+"^CareTime|"+CareTime+"^Typ|Sum^"+"InPart|"+InPart+"^OutPart|"+OutPart+"^StatTime|"+StatTime+"^StatHours|"+StatHours;
		//alert(str);
		var diaggrid = Ext.getCmp('diaggrid');
		if (diaggrid) {
  		var selModel=diaggrid.getSelectionModel();
  		if (selModel.hasSelection()) {   
  			var objDiagRow = selModel.getSelections();		  			
				DiagnosDr=objDiagRow[0].get("rw");
			}
			else {
				DiagnosDr="";	
			}
		}
		else {
			DiagnosDr="";
		}
		str=str+"^DiagnosDr|"+DiagnosDr;
		//alert(str);
		var a=cspRunServerMethod(SaveOutIn.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6");
		find();
 }
}
function OrdSch1(){
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 550,
		height: 550,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame: true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var butin=Ext.getCmp('ordgridbut1');
  butin.text="确定";
 	//debugger;
  butin.on('click',SureIn);
  window.show();

}
function OrdSch()
{         
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		width: 450,
		height: 550,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var mydate=new Date();

	var	grid1=Ext.getCmp("ordgrid");
	tobar=grid1.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'ordgridstdate',
			value:(diffDate(new Date(),-1))
		},
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'ordgridenddate',
			value:new Date()
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		//handler:find,
		id:'ordgridSch'
	  }

	);

	var butin=Ext.getCmp('ordgridbut2');
	butin.hide();
	var butin=Ext.getCmp('ordgridbut1');
	butin.text="确定";
	//debugger;
	butin.on('click',SureIn);
	var butschord=Ext.getCmp('ordgridSch');
	butschord.on('click',SchOrd);
	window.show();
}
var condata=new Array();
function add(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o)
{ //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel,SeqNo
 	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		PriorDes: d,
		Meth: e,
		PHFreq: f,
		Dose: g,
		DoseUnit: h,
		PhQtyOrd: i,
		OrdStat: j,
		Doctor: k,
		Oew: l,
		OrdSub: m,
		SeqNo: o
	});
}


function printNurRec()
{
		var GetPrnSet=document.getElementById('GetPrnSet');
		var GetHead=document.getElementById('GetPatInfo');
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		
		var stdate=Ext.getCmp("mygridstdate").value //tm[2];
		var stim="" //tm[3];
		var edate=Ext.getCmp("mygridenddate").value //tm[4];
		var etim="" //tm[5];
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		PrintComm.TitleStr=ret;
		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		
		//PrintComm.stPage=aa[0];
		//if (aa.length>1) PrintComm.stRow=aa[1];
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB);
		PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
		PrintComm.ItmName = "DHCNURMouldPrn_YCYBB"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=session['LOGON.CTLOCID']+"!"+stdate+"!"+edate+"!"+"!"+"!";
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintComm.PrintOut();
		
}

function eachItem(item,index,length) {   
	if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem, this);   
    }   
}   

function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}



