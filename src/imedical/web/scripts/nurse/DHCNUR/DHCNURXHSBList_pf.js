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
var usertype=0;
var PatInfo=document.getElementById('gettype');
if (PatInfo) {
   //alert(session['LOGON.USERCODE'])
   usertype=cspRunServerMethod(PatInfo.value,session['LOGON.USERCODE']);
   //alert(usertype)		
	}
 
var arrgrid = new Array();
var storenurse = new Ext.data.JsonStore({
			data :[],
			fields : ['desc', 'id']
		});
var storenurse1 = new Ext.data.JsonStore({
			data :[],
			fields : ['desc', 'id']
		});
var patward = new Ext.form.ComboBox({
			id : 'patward',
			//hiddenName : 'region1',
			store : storenurse,
			width : 200,
//			fieldLabel : '区',
			valueField : 'id',
			displayField : 'desc',
			value:"",
			allowBlank : true,
			mode : 'local'
		});
	var CCERR = new Ext.form.ComboBox({
			id : 'CCERR',
			//hiddenName : 'region1',
			store : storenurse1,
			width : 150,
			fieldLabel : '事件',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});


function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
	//alert(EmrCode)
	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', newEvent);
	var but = Ext.getCmp("mygridbut2");
	but.hide();

	var grid = Ext.getCmp('mygrid');
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	grid.on('rowdblclick',modccevent);
//tobar.addItem('病区',
		//patward,'-' ,'事件',CCERR,'-');
	
	tobar.addItem({
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridstdate',
		value: (diffDate(new Date(), -7))
	}, {
		xtype: 'datefield',
		//format: 'Y-m-d',
		id: 'mygridenddate',
		value: diffDate(new Date(), 1)
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "上报",
		handler: qdtj,
		id: 'SubmitFu'
	});
tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "作废",
		handler: qddelete,
		id: 'delete'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "撤销作废",
		handler: cxdelete,
		id: 'cdelete'
	});
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
   tobar.doLayout(); 
	//inidata("patward","Desc","web.DHCNurblsjflwh:GetWard","Loc$W");
   // inidata("CCERR","Desc","web.DHCNurblsjflwh:CRItem","");
    patward.setValue(session['LOGON.CTLOCID']);
   
    layoutset();	
	if (usertype=="")
	 {	
	    	
	    	inidata("patward","Desc","web.DHCNurblsjflwh:GetWard","Loc$W");
	    	var butsave=Ext.getCmp("KSubmitFu");
		    if(butsave)  butsave.hide();		   
		  
    }
setTimeout("find()",0)
}
function if7d()
{ 
	//var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	 var getuser=0;
	var adm = EpisodeID;
	var ward=Ext.getCmp("patward");
	var CCEV=Ext.getCmp("CCERR");
	var StDate = Ext.getCmp("mygridstdate");
	var Enddate = Ext.getCmp("mygridenddate");
	var loc=session['LOGON.CTLOCID'];
	var parr = "DHCNURXHSB_pf^"+adm+"^"+"^"+StDate.value+"^"+Enddate.value;
  var getuser=document.getElementById('getuser');
  
  if (getuser) {
   //alert(session['LOGON.USERCODE'])
   var getuser=cspRunServerMethod(getuser.value,parr);
   //alert(getuser)
    if (getuser!=""){alert("提示：以下人员需填压疮追踪表"+getuser)}		
	}
	
	}
function qdtj()
{
	var grid=Ext.getCmp('mygrid');
    var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	
	if (objRow.length == 0) { alert("请先选择一条护理记录!"); return; }
	else
	{
		var Status = objRow[0].get("Status");
		if ((objRow.length != 0)&&(Status.indexOf("已作废")>-1)) { alert("该记录已经作废,不能再上报!"); return;}
		if ((objRow.length != 0)&&(Status.indexOf("审核")>-1)) { alert("该记录已经审核,不能再上报!"); return;}
		if (Status=="评价中") 
		{
		  alert("已经上报过!")
		  return;
		}
		var flag = confirm("你确定要上报？上报后不可修改?")
		if (flag) 
		{			
	         SubmitFu();
	         find()
	    }     
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
		var flag = confirm("你确定要提交？提交后不可修改?")
		if (flag) 
		{			
	        KSubmitFu();	 
	    }          	          
	}
}
function qddelete()
{
	
	  var grid=Ext.getCmp('mygrid');
     var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	var Status = objRow[0].get("Status");
	if ((objRow.length != 0)&&(Status.indexOf("已作废")>-1)) { alert("已经作废过了!"); return;}
	/*if (((objRow.length != 0)&&(Status!="未上报"))||((objRow.length != 0)&&(Status!="已退回"))) { Ext.Msg.alert('提示', "已经上报不可以作废!"); return;}
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		var flag = confirm("你确定要作废?")
		if (flag) 
		{
                delete1();
				find()
		}	
	}*/
	if((objRow.length != 0)&&((Status=="未上报")||(Status=="已退回")))
	{
		var flag = confirm("你确定要作废?")
		if (flag) 
		{
                delete1();
				find()
		}	
	}
else{ Ext.Msg.alert('提示', "已经上报不可以作废!"); return;}
	//if ((objRow.length != 0)&&((Status!="未上报")||(Status!="已退回"))) { alert("已经上报了!"); return;}
	if (objRow.length == 0) { alert( "请先选择一条护理记录!"); return; }
	//find();
}
function delete1()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else 
		{
	 var SetStatus=document.getElementById('delete1');
	 var par = objRow[0].get("par");
	 var Status = objRow[0].get("Status");
	 var parr=par+"^"+session['LOGON.USERID']	
	 var a = cspRunServerMethod(SetStatus.value,parr);		
		//alert(a)
		find();
	 
	
	}	
}
function cxdelete()
{
	
	  var grid=Ext.getCmp('mygrid');
     var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	var Status = objRow[0].get("Status");
	//alert(Status)
	//alert(Status.indexOf("已作废"))
	if (Status.indexOf("已作废")<0) { alert("该记录不可撤销作废!"); return;}
	if(Status.indexOf("已作废")==0)
	{
		var flag = confirm("你确定要撤销作废此条记录吗!")
		if (flag) 
		{		
	      var par = objRow[0].get("par");
		  //alert(par)
	      var parr=par+"^"+session['LOGON.USERID'];	
          var abc=tkMakeServerCall("Nur.DHCNurSBData","cxdelete",parr);
		  if(abc!=""){
			  alert("撤销作废成功!");
		  }
	    }
	}
	find();
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
	 var id=objRow[0].get("rw")+"||"+objRow[0].get("chl");
	if (objRow.length == 0) {
		return;
	}
	else {
   
		var par = objRow[0].get("par");
		var Status = objRow[0].get("Status");
		//alert(Status)
		
		if (Status=="未上报") 
		{var Status="V"}
		if (Status=="已退回") 
		{var Status="V2"}
		if (Status=="已上报") 
		{var Status="S1"}
		if (Status=="评价中") 
		{var Status="S2"}
		if (Status=="已审核") 
		{var Status="A"}
		if (Status=="已作废") 
		{var Status="C"}
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURXHSB_pf&EpisodeID="+EpisodeID+"&NurRecId="+par+"&Status="+Status  ;//"&DtId="+DtId+"&ExamId="+ExamId
	    window.open(lnk,"htm",'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=860,height=700');

	}

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
var logonht=1;
var wind22;
function newEvent()
{
	
    if (logonht==1)
	{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURXHSB_pf&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	}
	
	if (logonht==0)
	{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURXHSB_pf&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	}
	 wind22=window.open(lnk,"htm",'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=700');
}
var REC=new Array();
function find()
{
	//var StDate = Ext.getCmp("mygridstdate");
	//var Enddate = Ext.getCmp("mygridenddate");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr ="DHCNURXHSB_pf^"+EpisodeID;
	arrgrid=new Array();
	//alert(EpisodeID);
	//alert(parr);
		arrgrid = new Array();
    MeasureRel = new Hashtable();
    //REC = new Array();
	var adm = EpisodeID;
	var ward=Ext.getCmp("patward");
	var CCEV=Ext.getCmp("CCERR");
	var StDate = Ext.getCmp("mygridstdate");
	var Enddate = Ext.getCmp("mygridenddate");
	var loc=session['LOGON.CTLOCID'];
  var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();

	//alert(StDate.vlaue);
	var parr = "DHCNURXHSB_pf^"+adm+"^"+loc+"^"+StDate.value+"^"+Enddate.value+"^"+IfCancelRec;
  //	alert(parr);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurblsjflwh:MoudData", "parr$" +parr,"AddRec");
	//alert(a);
  mygrid.store.loadData(arrgrid);   
   var store = mygrid.store;
	for(var i=0;i<store.getCount();i++)
	{	var EmrDate=store.getAt(i).get("EmrDate");	
		var par=store.getAt(i).get("par");
		var Name=store.getAt(i).get("Item1");
    var Status=store.getAt(i).get("Status");	
    var date=store.getAt(i).get("date");	
    var Value=store.getAt(i).get("value");	
   
   	if (Status=="未上报") 
		{var Status="V"}
		if (Status=="已退回") 
		{var Status="V2"}
		if (Status=="已上报") 
		{var Status="S1"}
		if (Status=="评价中") 
		{var Status="S2"}
		if (Status=="已审核") 
		{var Status="A"}
		 if ((date>6)&&(Status=="S2"))
    { 
    	if ((usertype=="")||(usertype=="护士长")||(usertype=="科护士长"))
    	{  if (Value.indexOf("B")==-1)
    	   {
    	    mygrid.getView().getCell(i,12).style.backgroundColor="#FF0000"	    	
    	   }
    	   if (Value.indexOf("B")!=-1)
    	   {
    	    mygrid.getView().getCell(i,15).style.backgroundColor="#CCFFFF"
    	    //break;	    	
    	   }
    	   if (Value.indexOf("K")!=-1)
    	   {
    	    mygrid.getView().getCell(i,15).style.backgroundColor="#66CCFF"	    	
    	   }
    	   if ((Value.indexOf("B")!=-1)&&(Value.indexOf("K")==-1))
    	   {
    	     mygrid.getView().getCell(i,15).style.backgroundColor="#6699CC"	    	
    	   }
    	    if ((Value.indexOf("B")!=-1)&&(Value.indexOf("K")==-1)&&(Value.indexOf("H")==-1))
    	   {
    	     mygrid.getView().getCell(i,15).style.backgroundColor="#6600FF"	    	
    	   }
     }
    	if (usertype=="科护士长")
    	{   if ((Value.indexOf("B")==-1)||(Value.indexOf("K")==-1))
    		{
    			mygrid.getView().getCell(i,12).style.backgroundColor="ff4500"
    		}
    	}
    	
    }
		if ((Status=="S1")||(Status=="S2"))
		{ 
			 var parr=par+"^"+session['LOGON.USERID']+"^"+session['LOGON.USERCODE']
			
		   var AuditSetStatus=document.getElementById('AuditSetStatus');  
		   
       var flag=cspRunServerMethod(AuditSetStatus.value,parr);  
       //alert(flag)
      if (flag==1)
       {
      	Ext.Msg.alert('提示:',"\""+Name+"\""+'      今日开始填压疮追踪表')
       }
		
		}
		//alert(Status)
		if(Status=="V")
		{ var mygrid=Ext.getCmp('mygrid');
			mygrid.getView().getCell(i,14).style.backgroundColor="#FFCCFF"
		}
		if(Status=="V2")
		{ var mygrid=Ext.getCmp('mygrid');
			mygrid.getView().getCell(i,14).style.backgroundColor="#FFCCFF"
		}
	 if(Status=="S1")
		{ var mygrid=Ext.getCmp('mygrid');
			mygrid.getView().getCell(i,14).style.backgroundColor="FFCC66"
		}
		 if(Status=="S2")
		{ var mygrid=Ext.getCmp('mygrid');
			mygrid.getView().getCell(i,14).style.backgroundColor="ff4500"
		}
		 if(Status=="A")
		{ var mygrid=Ext.getCmp('mygrid');
			mygrid.getView().getCell(i,14).style.backgroundColor="1e90ff"
		}
		
	}
	//if7d();
	// window.self.find();	 
}
function AddRec(str)
{
	str=str.replace(/\t+/g,"").replace(/\n+/g,"").replace(/\r+/g,"").replace(/\s+/g,"");//去除所有空格
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
}
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
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

