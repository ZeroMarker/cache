/**
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});

grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('10')=='数据错误'){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
*/
var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}
var DHCNurCheckRecT102=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','DateEx','TimeEx','CPTEx','ArcimDR','ORW']});
var DHCNurLabRecT103=new Ext.data.JsonStore({data:[],fields:['StDateTime','ARCIMDes','LabEpisodeNo','testcode','LabDate','LabTime','LabCpt','RowId']});
var DHCPatOrdListT103=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','PriorDes','Meth','PHFreq','Dose','DoseUnit','OrdStat','Doctor','Oew','OrdSub','Sel','SeqNo']});

var grid;
var arrtim=new Array();
var GetQueryData = document.getElementById('GetQueryData1');
//alert(GetQueryData)
var a = cspRunServerMethod(GetQueryData.value, "web.DHCTHREEEX.GetTimePoint", "" , "AddTim");
var storetim = new Ext.data.JsonStore({
			data : arrtim,
			fields : ['idv', 'des']
		});
function AddTim(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrtim.push(obj);
	//debugger;
}
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0];
	//debugger;
}
var timField = new Ext.form.ComboBox({
			id : 'mygridttime',
			hiddenName : 'mygridttime1',
			store : storetim,
			width : 150,
			//editable:false,
			triggerAction:'all',
			fieldLabel : '固定时间',
			valueField : 'idv',
			displayField : 'des',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});
timField.on('select', function() {
			find();
		});
function BodyLoadHandler()
{
setsize("mygridpl","gform","mygrid");
 grid1=Ext.getCmp("mygrid");
var but1=Ext.getCmp("mygridbut1");
	but1.setText("全部保存");
	but1.on('click',saveAll);
	//but1.hide();
	//but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("选行保存");
	but.on('click',save);
	//but.hide();
	var gettime=document.getElementById('getTime');
	var timindex=cspRunServerMethod(gettime.value);
	var cmbtim=Ext.getCmp("mygridttime");
	cmbtim.setValue(timindex);
	Ext.override(Ext.Editor, {
			onSpecialKey : function(field, e) {
				var key = e.getKey();
				this.fireEvent('specialkey', field, e);
			}
		});
	Ext.override(Ext.grid.RowSelectionModel, {
			onEditorKey : function(F, E) {
				var C = E.getKey(), G, D = this.grid, B = D.activeEditor;
				var A = E.shiftKey;
				if (C == E.TAB) {
					E.stopEvent();
					B.completeEdit();
					if (A) {
						G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav,
								this);
					} else {
						G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav,
								this);
					}
				} else {
					if (C == E.ENTER) {
						E.stopEvent();
						// alert(B);
						B.completeEdit();
						if (this.moveEditorOnEnter !== false) {
							if (A) {
								// G = D.walkCells(B.row - 1, B.col, -1,
								// this.acceptsNav,this)
								G = D.walkCells(B.row, B.col - 1, -1,
										this.acceptsNav, this);
							} else {
								// G = D.walkCells(B.row + 1, B.col, 1,
								// this.acceptsNav,this)
								G = D.walkCells(B.row, B.col + 1, 1,
										this.acceptsNav, this);
							}
						}
					} else {
						if (C == E.ESC) {
							B.cancelEdit();
						}
					}
				}
				if (G) {
					D.startEditing(G[0], G[1]);
				}
			}
		});
    var sm2 = new Ext.grid.RowSelectionModel({   
        moveEditorOnEnter: true,   
        singleSelect: false,   
        listeners: {   
            //rowselect : function(sm, row, rec) {   
                //centerForm.getForm().loadRecord(rec);   
           // }   
        }   
  
    });
	grid=Ext.getCmp('mygrid');
  	//grid.setTitle(gethead());
  	var mydate=new Date();
  	var tobar=grid.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),0))
		}
      ,timField
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	  }

	);
 //tobar.addButton(
//	{
			//className: 'new-topic-button',
	//		text: "全部保存",
	//		handler:saveAll,
	//		id:'butsaveAll'
	//	  }
	 // );
	 tobar.doLayout(); 
		if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();
 		var obj=Ext.getCmp("PrintBut");
 		if (obj) obj.hide();
  		var obj=Ext.getCmp("XPrintSet");
 		if (obj) obj.hide();	
 		var obj=Ext.getCmp("butsaveAll");
 		if (obj) obj.hide();	
 		var obj=Ext.getCmp("butsave");
 		if (obj) obj.hide();	
 		var obj=Ext.getCmp("mygridSchXC");
 		if (obj) obj.hide();	
 		var obj=Ext.getCmp("needPrintBut");
 		if (obj) obj.hide();	
 		grid.addListener('rowcontextmenu', rightClickDocFn);	
 	}
 	else
 	{
		grid.addListener('rowcontextmenu', rightClickFn);
		grid.addListener('rowclick', rowClickFn);
		grid.on('beforeedit', beforeEditFn);
		//grid.on('afteredit', afterEditFn);
 	}

Ext.QuickTips.init();//注意，提示初始化必须要有
grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
               girdcount=girdcount+1;
          });
       //scope:this
       });
var dteStdate=Ext.getCmp("mygridstdate");
dteStdate.on("select",function(){
	     find();
	});
if (timindex!="") 
	find(); 
	 
}
var REC=new Array();

function printAllPatientData()
{
		//PrintComm.TitleStr=ret;
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var parr =session['LOGON.CTLOCID']+"!"+"!"+StDate+"!"+StTime;
	PrintComm.TitleStr="";
    PrintComm.SetPreView("1");
    PrintComm.PrnLoc=session['LOGON.CTLOCID'];
    PrintComm.stPage = 0;
    PrintComm.stRow = 0;
    PrintComm.previewPrint="1"; //是否弹出设置界面
    PrintComm.stprintpos = 0;
    PrintComm.SetConnectStr(CacheDB);
    PrintComm.ParrDel="!";
    PrintComm.ItmName = "DHCNURTEMMoudlePrn";//
    PrintComm.ID = "";
    PrintComm.MultID = "";
	PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls"
    PrintComm.SetParrm(parr);
    PrintComm.PrintOut();
}
function SchXCprint()
{
	  var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	  var StTime = Ext.getCmp("mygridttime").lastSelectionText;
  	var Getward=document.getElementById('getward');
  	//alert(Getward);
		var ward=cspRunServerMethod(Getward.value,session['LOGON.CTLOCID']);
		var ret="^ward@"+ward+"^date@"+StDate+"^time@"+StTime;
		PrintComm.TitleStr=ret;
	  PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
		var adm=EpisodeID;
	  //var StDate= Ext.getCmp("mygridstdate");
	  //var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	  // var StTime = Ext.getCmp("mygridttime");//.lastSelectionText;
	  // var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	   // var Enddate= Ext.getCmp("mygridenddate");
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB);
		PrintComm.ItmName = "DHCNurPrnMouldXHtem"; //338155!2010-07-13!0:00!!
		PrintComm.ParrDel="!";
		//debugger;
		//var parr=adm+"^"+StDate.value+"^"+Enddate.value;
		var parr=session['LOGON.CTLOCID']+"!!"+StDate+"!"+StTime;
		//var parr="adm:"+85+"^b:"+""+"^c:"+"";
		//alert(parr);
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		//if(LabHead!="")PrintComm.LabHead=LabHead;
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintComm.PrintOut();
	
	}

function addprnset(par)
{
	var a=par.split("^");
	//alert(a);
	a[4]=getDate(a[4]);
	if (a[6]!="")a[6]=getDate(a[6]);
	REC.push({patname:a[0],
	       bedcode:a[1],
	       pagno:a[2],
	       prnpos:a[3],
	       stdate:a[4],
	       sttime:a[5],
	       edate:a[6],
	       etime:a[7],
	       rectyp:a[8],
	       rw:a[9],
	       EpisodeID:a[10]
		   })
}
function afterEditFn(e)
{
		//alert(e.grid+","+e.record+","+e.field+","+e.value+","+e.originalValue+","+e.row+","+e.column);
		var errflag=0;
		var curfield=e.field;
		var curvalue=e.value;
		if ((curfield=='Item1')||(curfield=='Item22')) {
			if (isNaN(curvalue)){
				if ((curvalue!="")&&(curvalue.split(".").length>2)) {
					alert("体温输入格式不对,包括多个点!");
					errflag=1;		
				}
				else {
					alert("体温值请录入数字!");
					errflag=1;
				}
			}
			else {
				if ((curvalue!="")&&((curvalue < 34)||(curvalue > 43))) {
					alert("体温值小于34或大于43!");
					errflag=1;
				}
			}
		}
		if ((curfield=='Item7')||((curfield=='Item13'))) {
			if (isNaN(curvalue)){
				alert("脉搏值或心率请录入数字!");
				errflag=1;
			}
			else {
				if ((curvalue!="")&&((curvalue < 20)||(curvalue > 200))) {
					alert("脉搏或心率值小于20或大于200!");
					errflag=1;
				}
			}
		}
		if (errflag==1) {
			grid.startEditing(e.row, e.column);
			return;
		}
		var str=curfield+"|"+curvalue;
		var currecord=e.record;
		EpisodeID=currecord.get("Adm");
		var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
		var StTime = Ext.getCmp("mygridttime").lastSelectionText;
    if ((StTime=="")||(StTime==undefined)) return;
		var RecSave=document.getElementById('RecSave');
		//alert(str+","+session['LOGON.USERID']+","+"DHCNUR6"+","+session['LOGON.GROUPDESC']+","+StDate+","+StTime);
		var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],StDate,StTime);
		if (a!="0")
		{
			alert(a);
			grid.startEditing(e.row, e.column);
			return;		
		}
		find();
}
  function Needprn()
{
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurNeedPrn";//"&DtId="+DtId+"&ExamId="+ExamId
	window.open(lnk,"htm",'toolbar=no,location=no,directories=yes,resizable=yes,width=610,height=570,left=200,top=90');
}
function addtitCon(tobar,lab)
{
	var but1=Ext.getCmp(lab+"but1");
	but1.hide();
	var but2=Ext.getCmp(lab+"but2");
	but2.hide();
	
	tobar.addItem(
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:lab+'stdate',
			value:(diffDate(new Date(),-1))
		},
	    {
			xtype:'datefield',
			format: 'Y-m-d',
			id:lab+'enddate',
			value:new Date()
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		//handler:find,
		id:lab+'Sch'
	  }

	);
}
function SchXC()
{
	REC = new Array();
	var adm = EpisodeID;
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr =session['LOGON.CTLOCID']+"^^"+StDate+"^"+StTime;
	if ((StTime=="")||(StTime==undefined)) return;
	//alert(StDate+"--"+StTime);
	//debugger;
	// debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurNeedMeasureTempPat:GetNeedMeaserPat", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
function find(){
	
	REC = new Array();
	var adm = EpisodeID;
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = Ext.getCmp("mygridttime").lastSelectionText;
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr =session['LOGON.CTLOCID']+"^"+adm+"^"+StDate+"^"+StTime;
	if ((StTime=="")||(StTime==undefined)) return;
	//alert(StDate+"--"+StTime);
	//debugger;
	// debugger;
	//alert(parr);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurRecComm:GetAllPatient", "Parr$" + parr, "AddRec");
	//哌alert(a);
	mygrid.store.loadData(REC);
}

function FailChange(val)
{
	if (val>0)
	{
	return '<span style="color:red">' + val + '</span>';
	}
	return val
}

function IntensiveSch()
{
	
}

function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(1);
	//alert(str)
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	//alert(obj);
	REC.push(obj);
	//debugger;
}

function save33()
{ //alert(22)
  var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var curDat=GetDateStr(0);
		if (curDat!=StDate)
		{
			var confirmFlag=window.confirm("您选择的日期不是今天,确认要保存数据吗?")
	    if (confirmFlag==false) return;
		}
  var StTime = Ext.getCmp("mygridttime").lastSelectionText;
  //alert(StTime)
  if ((StTime=="")||(StTime==undefined)) return;
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		alert(len)
		for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}		
	var grid1=Ext.getCmp('mygrid');
	var rwIndex=grid1.getSelectionModel().last;
	var CaseMeasureID="CaseMeasureID|";
	var RecSave=document.getElementById('RecSave2');
	alert(list.length)
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);				
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			alert(p)
			if (p=="") continue;
			
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p==DisplaySumOutName)&&(obj[p].indexOf("出液量")!= -1))
			{
				flag="1";
			} 
			if (aa == "") 
			{
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		if ((str!="")&&(flag=="0"))
		{
			if (str.indexOf("CareDate")==-1)
			{
				//str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
				//debugger;
			}
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
			str=str+"DiagnosDr|"+DiagnosDr;
			str=str+"^"+CaseMeasureID;
			str=str+"CareDate|"+curDat+"^CareTime|"+StTime;
			alert(str);
			return
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURXH_YTCRL",session['LOGON.GROUPDESC']);
			alert(a)
			if (a!="0")
			{
				alert(a);
				return;
			}
		}
	}
	find();
}  

function save()
{
		var store = grid.store;
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount(); 
		var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
		var curDat=GetDateStr(0);
		if (StDate=="")
		{
		alert("请选择日期再保存")
		return
		}
		if (curDat!=StDate)
		{
			var confirmFlag=window.confirm("您选择的日期不是今天,确认要保存数据吗?")
	    if (confirmFlag==false) return;
		}
		var StTime = Ext.getCmp("mygridttime").lastSelectionText;
    		
    	if ((StTime=="")||(StTime==undefined))
    	{
    	 alert("请选择时间再保存")
    	 return;
    	 }
		var list = [];
		var rowObj = grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			for (var r = 0;r < len; r++) {
			list.push(rowObj[r].data);
	    }
		//for (var i = 0; i < store.getCount(); i++) {
		//	list.push(store.getAt(i).data);
			//	debugger;
		//}
    var RecSave=document.getElementById('RecSave2');
    //alert(RecSave)
		for (var i = 0; i < list.length; i++) {
		  var flagexist=""
		  var obj=list[i];
		  var str="";
		  var CareDate="";
		  var CareTime="";
		  var flag="0";
			for (var p in obj) {
				var aa = formatDate(obj[p]);	
				//alert(aa);			
				if (p=="Adm") EpisodeID=obj[p];
				//alert(p);
				if (p=='CareTime') CareTime=obj[p];
				if (p=="") continue;
			
				if (aa == "") 
				{
						str = str + p + "|" + DBC2SBC(obj[p]) + '^';
						if ((p=="Item1")||(p=="Item2")||(p=="Item3")||(p=="Item4")||(p=="Item21")||(p=="Item27")||(p=="Item29")||(p=="Item31")||(p=="Item33")||(p=="Item24")||(p=="Item16")||(p=="CaseMeasure")||(p=="rw")||(p=="par"))
						{
						 if (obj[p]!="")
						 {
						  flagexist=flagexist+obj[p]
						 }
						}
				}
				else
				{
				  	str = str + p + "|" + aa + '^';	
				}
			}
			
			if ((str!="")&&(flag=="0"))
			{
				if (str.indexOf("CareDate")==-1)
				{
						str=str+"CareDate|"+StDate+"^CareTime|"+StTime;
					//debugger;
				}
			  // alert(EpisodeID);
			 // alert(str);
			 //alert(flagexist)
			if (flagexist!="")
			{
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURXH_YTCRL",session['LOGON.GROUPDESC']);
			}
			//alert(a)
				//{
				//	alert(a);
				//	return;
				//}
			}
		}
find();
} 
function saveAll()
{
		var store = grid.store;
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount(); 
		var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
		var curDat=GetDateStr(0);
	if (StDate=="")
		{
		alert("请选择日期再保存")
		return
		}
		if (curDat!=StDate)
		{
			var confirmFlag=window.confirm("您选择的日期不是今天,确认要保存数据吗?")
	    if (confirmFlag==false) return;
		}
		var StTime = Ext.getCmp("mygridttime").lastSelectionText;
		  	
    	if ((StTime=="")||(StTime==undefined))
    	{
    	 alert("请选择时间再保存")
    	 return;
    	 }
		var list = [];
		//var rowObj = grid.getSelectionModel().getSelections();
			//var len = rowObj.length;
		//	for (var r = 0;r < len; r++) {
			//list.push(rowObj[r].data);
	   // }
		for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
			//	debugger;
		}
    var RecSave=document.getElementById('RecSave2');
    //alert(RecSave)
		for (var i = 0; i < list.length; i++) {
		  var flagexist=""
		  var obj=list[i];
		  var str="";
		  var CareDate="";
		  var CareTime="";
		  var flag="0";
			for (var p in obj) {
				var aa = formatDate(obj[p]);	
				//alert(aa);			
				if (p=="Adm") EpisodeID=obj[p];
				//alert(p);
				if (p=='CareTime') CareTime=obj[p];
				if (p=="") continue;
			
				if (aa == "") 
				{
						str = str + p + "|" + DBC2SBC(obj[p]) + '^';
						if ((p=="Item1")||(p=="Item2")||(p=="Item3")||(p=="Item4")||(p=="Item21")||(p=="Item27")||(p=="Item29")||(p=="Item31")||(p=="Item33")||(p=="Item24")||(p=="Item16")||(p=="CaseMeasure")||(p=="rw")||(p=="par"))
						{
						 if (obj[p]!="")
						 {
						  flagexist=flagexist+obj[p]
						 }
						}
				}
				else
				{
				  	str = str + p + "|" + aa + '^';	
				}
			}
			
			if ((str!="")&&(flag=="0"))
			{
				if (str.indexOf("CareDate")==-1)
				{
						str=str+"CareDate|"+StDate+"^CareTime|"+StTime;
					//debugger;
				}
			  // alert(EpisodeID);
			 // alert(str);
			//alert(flagexist)
			if (flagexist!="")
			{
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURXH_YTCRL",session['LOGON.GROUPDESC']);
			}
			//alert(a)
				//{
				//	alert(a);
				//	return;
				//}
			}
		}
find();
} 
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function gridclick()
{
	 var grid=Ext.getCmp("mygrid");
  
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		//Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		EpisodeID=rowObj[0].get("Adm");
		/*for (i = 0; i < top.frames.length; i++) {
			alert(top.frames[i].name);
		}*/
		var frm = top.frames[0].document.forms["fEPRMENU"];
		//var frm = top.document.forms["fEPRMENU"];
	  if (frm) frm.EpisodeID.value=EpisodeID;
    // ModConsult();
	}
}
function diffDate(val,addday){
	var year=val.getFullYear();
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
var rightClickDoc = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [  {
                    id:'rMenu4',
                    text : '预览',
                    handler:temppreview
                }]
            });
var rightClick = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [ 
                {
                id:'rMenu1',
                text : '医嘱',
                handler:OrdSch
                },{
                    id:'rMenu5',
                    text : '出入量数据明细',
                    handler:PatDataDetail
                },	{
                    id:'rMenu4',
                    text : '预览体温单',
                    handler:temppreview
                }]
            });
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
function rightClickDocFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClickDoc.showAt(e.getXY());
            }
function rowClickFn(grid, rowIndex, e)  {
                //alert('你单击了' + rowIndex);
            }

function add11(a1, a2){
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
function IOItem()
{         
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURQTIOITEM";
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=760,height=500');
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
function SureIn()
 {
	var grid = Ext.getCmp('ordgrid');
	var mygrid=Ext.getCmp('mygrid');
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	/*var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/
	var num=0;
	var des2=""
	var ml2=0;
	var selModel = grid.getSelectionModel();   
  if (selModel.hasSelection()) 
  {   
				var selections = selModel.getSelections();		
			 	var caredate,caretime;
			 	var Meth=""
				Ext.each(selections, function(item) 
				{
					var des=item.data.ARCIMDesc;
					des=des.replace("_____","");
					var ml=item.data.Dose;
					var Dose=item.data.Dose;
					//alert(ml)
					var unit=item.data.DoseUnit;
					if ((unit!="ml")&&(unit!="ML")) ml=0;
					var seqno=item.data.SeqNo;
						
					var rowIndex = grid.store.indexOf(item);
					//alert(rowIndex)
					var subdes=store.getAt(rowIndex).data.ARCIMDesc;
					subdes=subdes.replace("_____","");
					if (Meth=="")
					{Meth=store.getAt(rowIndex).data.Meth;}
					var subml=store.getAt(rowIndex).data.Dose;
					var subunit=store.getAt(rowIndex).data.DoseUnit;
					if (subunit!="ml") subml=0;
					var subseqno=store.getAt(rowIndex).data.SeqNo;
					//alert(subml)
					if (unit!="")
					{
					subdes=subdes+" "+Dose+"("+unit+")"
					}
					else
					{
					subdes=subdes
					}
					if (des2=="") 
					{des2=subdes}
					else
					{
					des2=des2+"&"+subdes
					}
					ml2=eval(ml2)+eval(ml);	
					//alert(ml2)		
					num++;		
        }  )
  }        if (Meth!="")
					{
					  Meth=Meth.split("-")
					  //alert(Meth)
					  Meth=Meth[1]
					
					}
     	      ml2=ml2+"";
     	     // alert(ml2)
     	      var objRow=mygrid.getSelectionModel().getSelections();
     	      //alert(objRow.length )
						if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择某行!"); return; }
						else
						{
								objRow[0].set("Item1", des2);
								objRow[0].set("Item2", ml2);
								objRow[0].set("Item5", Meth);
						}
				
   
 }
function SchOrd()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("ordgridstdate");
	var Enddate= Ext.getCmp("ordgridenddate");
	var GetQueryData=document.getElementById('GetQueryData2');
	var ordgrid=Ext.getCmp("ordgrid");
	var parr=adm+"^"+StDate.value+"^"+Enddate.value; 
	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNUREMR:GetPatOrd","parr$"+parr,"add");
	// grid.width=document.body.offsetWidth;
	ordgrid.store.loadData(condata);
}
function Schlab()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("LabGridstdate");
	var Enddate= Ext.getCmp("LabGridenddate");
	var GetQueryData=document.getElementById('GetQueryData1');
	var ordgrid=Ext.getCmp("LabGrid");
  //var parr=adm+"^"+StDate.value+"^"+Enddate.value;
	//alert(adm);
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurJYRESULT:GetLabNo","Adm$"+adm,"AddLab");
  // grid.width=document.body.offsetWidth;
  ordgrid.store.loadData(condata);   
}
function AddLab(a,b,c,d,e,f,g,h)
{
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
		condata.push({
			ARCIMDes:a,
			LabEpisodeNo:b,
			StDateTime:c,
			RowId:d,
			testcode:e,
			LabCpt:f,
			LabDate:g,
			LabTime:h
		});
}
function AddCheck(a,b,c,d,e,f,g,h)
{
	//OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR
		condata.push({
			OrdDate:a,
			OrdTime:b,
			ARCIMDesc:c,
			ORW:d,
			DateEx:e,
			TimeEx:f ,
			CPTEx:g,
			ArcimDR:h
		});
}
function SchCheck()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("CheckGridstdate");
	var Enddate= Ext.getCmp("CheckGridenddate");
	var GetQueryData=document.getElementById('GetQueryData1');
	var ordgrid=Ext.getCmp("CheckGrid");
    var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurJYRESULT:GetOrdRadia","parr$"+parr,"AddCheck");
   // grid.width=document.body.offsetWidth;
    
    ordgrid.store.loadData(condata);   
}

function OrdSch11()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm"); 
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUROUTREG"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=760,height=500');
 

}
function temppreview()
{         
		var rowObj = grid1.getSelectionModel().getSelections();
		if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
		var Adm=rowObj[0].get("Adm"); 
		TempShow(Adm);
		find();
	// var CurrAdm=selections[rowIndex].get("Adm");
	///var lnk= "DHCNurTempature.csp?"+"&EpisodeID="+Adm;
	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,status=yes,resizable=no,width=860,height=800');
 

}
function QtEvent()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");  
	// var CurrAdm=selections[rowIndex].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURQTDATA"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=460,height=300');
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

//document.body.onload=BodyLoadHandler;
 //date.on('change', function(){alert(1);});



function printNurRec()
{
		  var GetPrnSet=document.getElementById('GetPrnSet');
			var GetHead=document.getElementById('GetHead');
		  var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		  var hh=ret.split("^");
	    //debugger;
			var a=cspRunServerMethod(GetPrnSet.value,"DHCNUR6",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
			if (a=="") return;
			var GetLableRec=document.getElementById('GetLableRec');
			var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNUR6^"+session['LOGON.CTLOCID']);
			var tm=a.split("^");
			var stdate=tm[2];
			var stim=tm[3];
			var edate=tm[4];
			var etim=tm[5];
			PrintComm.RHeadCaption=hh[1];
			PrintComm.LHeadCaption=hh[0];
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			PrintComm.LFootCaption=hh[2];
			PrintComm.SetPreView("1");
			var aa=tm[1].split("&");
			PrintComm.stPage=aa[0];
			if (aa.length>1) PrintComm.stRow=aa[1];
			PrintComm.stprintpos=tm[0];
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.ItmName = "DHCNurPrnMould6";  //338155!2010-07-13!0:00!!
			//debugger;
			var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNUR6";
			PrintComm.ID = "";
			PrintComm.MultID = ""; 
			//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
			PrintComm.LabHead=LabHead;			
			PrintComm.SetParrm(parr);  // ="EpisodeId" ;  //"p1:0^p2:"
			PrintComm.PrintOut();
			var SavePrnSet=document.getElementById('SavePrnSet');
			//debugger;
			var CareDateTim=PrintComm.CareDateTim;
			if (CareDateTim=="") return ;
			var pages=PrintComm.Pages;
			var stRow=PrintComm.stRow;
			//debugger;
			var stprintpos=PrintComm.stPrintPos;			
			//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNUR6"+","+session['LOGON.USERID']);
			//暂时判断坐标为0里,说明是打印预览
			if (PrintComm.PrnFlag==1) return;
			var a=cspRunServerMethod(SavePrnSet.value,pages+"|"+stRow,CareDateTim,stprintpos,EpisodeID,"DHCNUR6",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
			//alert(a);			
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

function beforeEditFn(e){
	grid.rowIndex = e.row;   //得到当前的行
	grid.columnIndex = e.column;	//得到当前的列
}
var storespechar = new Array();
function SepcialChar() {
	var grid2 = new Ext.grid.GridPanel({
		id : 'mygridspecchar',
		name : 'mygridspecchar',
		title : '',
		stripeRows : true,
		height : 250,
		width : 120,
		tbar : [{
					id : 'insertBtn',
					handler:insertSpecChar,
					text : '插入'
				},'-',{
					id : 'replaceBtn',
					handler:replaceSpecChar,
					text : '替换'
				}],
		store : new Ext.data.JsonStore({
					data : [],
					fields : ['desc', 'rw']
				}),
		colModel : new Ext.grid.ColumnModel({
			columns : [{
						header : '特珠字符',
						dataIndex : 'desc',
						width : 110
					}, {
						header : 'rw',
						dataIndex : 'rw',
						width : 0
					}],
			rows : [],
			defaultSortable : true
		}),
		enableColumnMove : false,
		viewConfig : {
			forceFit : false
		}
	});
	storespechar = new Array();
	var GetQueryData = document.getElementById('GetQueryData1');
	var parr="";
	var a = cspRunServerMethod(GetQueryData.value,"User.DHCTEMPSPECIALCHAR:CRItem", "", "AddSpecChar");
	grid2.store.loadData(storespechar);
	var window = new Ext.Window({
		title: '特殊字符',
		width: 138,
		height: 285,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items : grid2,
		listeners:{'close':function(){
			if (Ext.getCmp('mygrid').rowIndex>0) Ext.getCmp('mygrid').startEditing(Ext.getCmp('mygrid').rowIndex , Ext.getCmp('mygrid').columnIndex);
		}}
	});
	window.show();
}
function AddSpecChar(str)
{
	var obj = eval('(' + str + ')');
	storespechar.push(obj);
}

function SpecCharFn(flag) 
{
		var grid = Ext.getCmp('mygridspecchar');
		//弹出界面中Grid
    var selModel = grid.getSelectionModel();   
    if (selModel.hasSelection()) {  
			var selections = selModel.getSelections();
			var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
			if (rowIndex<0) return;
			var specchardesc=grid.store.getAt(rowIndex).data.desc;
			var mygrid=Ext.getCmp('mygrid');
			if (mygrid.getSelectionModel().hasSelection()){
			}
			else {
				Ext.Msg.alert('提示', "请先选择要插入的位置!");
				return;
			}
			var oldStr=mygrid.store.getAt(mygrid.rowIndex).get(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex));
			if (oldStr) {
				if (flag=="I") {
					specchardesc=oldStr+specchardesc;
				}
			}
			mygrid.store.getAt(mygrid.rowIndex).set(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex),specchardesc);
			mygrid.startEditing(mygrid.rowIndex , mygrid.columnIndex);
	}
}
function insertSpecChar() 
{
	SpecCharFn("I"); 
}
function replaceSpecChar()
{
	SpecCharFn("R");
}
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
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

function PatDataDetail()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURXH_YTCRL"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=1200,height=600,left=50,top=90');
} 
function GetDateStr(AddDayCount) {
    var dd = new Date();
    dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期
    var y = dd.getFullYear();
    var m = dd.getMonth()+1;//获取当前月份的日期
    var d = dd.getDate();
    if (m<10) m="0"+m;
    if (d<10) d="0"+d;
    return y+"-"+m+"-"+d;
}

function makepic()
{
		var rowObj = grid1.getSelectionModel().getSelections();
		if (rowObj.length == 0) { Ext.Msg.alert('ÌáÊ¾ ', "ÇëÑ¡Ôñ Ò»Ìõ¼ÇÂ¼ !"); return; }
		var Adm=rowObj[0].get("Adm"); 
		MakeTempPic(Adm);
		//find();
}