/*
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
var arrgrid2 = new Array();

//alert(GetQueryData)


function AddTim(str)
{
	//var a=new Object(eval(str));
	///alert(str)
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	
	arrgrid2.push(obj);
	//debugger;
}
var arrgrid = new Array();
if (usertype=="大科护士长")
{  
	 var GetQueryData = document.getElementById('GetQueryData1');
	 var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNURLocData:GetKNurseLoc", "parr$"+session['LOGON.USERCODE'] , "AddTim");
   var storenurse = new Ext.data.JsonStore({
			data : arrgrid2,
			fields : ['desc','id']
		});
}
else {
      var storenurse = new Ext.data.JsonStore({
			data :[],
			fields : ['desc', 'id']
		  });
	  }
if (usertype=="护理部")
{
	var modeldata=[['M','每月'],['J','每季度'],['B','每半年'],['Y','每年']];
}
else
	{
  var modeldata=[['M','每月'],['J','每季度'],['B','每半年'],['Y','每年']];
}
var storenurse11 = new Ext.data.SimpleStore({
			
			fields : ['id', 'desc'],
			data :modeldata
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
			width : 120,
			fieldLabel : '事件',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
  var SJStatus = new Ext.form.ComboBox({
			id : 'SJStatus',
			//hiddenName : 'region1',
			store : storenurse11,
			width : 60,
			fieldLabel : '统计类型',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});

patward.on('select', function() {
			//find();
		});
		SJStatus.on('select', function() {
			//find();
		});
		CCERR.on('select', function() {
			//find();
		});
		
function find()
{ 
	REC = new Array();
  var StartDate = formatDate(Ext.getCmp("mygridstdate").getValue()); 
  var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue());  
  var Reportid= Ext.getCmp("SJStatus").getValue();
  if(Reportid=="")
	{
    Ext.Msg.alert('提示', "请选择统计类型后再查询数据!");
    return;
  }
   var flag=MonthStartJudge(StartDate);
  if (flag!=0)
  {
    Ext.Msg.alert('提示', "所选开始日期不是月初请重新选择日期初始化数据!");
    return;
  }  
  var flag=MonthEndJudge(EndDate);
  if (flag!=0)
  {
    Ext.Msg.alert('提示', "所选结束日期不是月末请重新选择日期初始化数据!");
    return;
  }  
  var parr =StartDate+"^"+EndDate+"^"+Reportid; 
  //alert(parr);
  if ((StartDate=="")||(EndDate=="")) return; 
  var GetQueryData = document.getElementById('GetQueryData');
  var mygrid = Ext.getCmp("mygrid");
  //debugger;
  //var a = cspRunServerMethod(GetQueryData.value, "web.DHCNSTFun:DHCNurDHCNURStatistics", "Parr$" + parr, "AddRec");
  var a = cspRunServerMethod(GetQueryData.value, "web.DHCNURSBTJ:DHCNurDHCNURQuery", "Parr$" + parr, "AddRec");
  // alert(a)
    if (a==0)
 {
  //alert("请先初始化数据再查询")
 // return
 }
   mygrid.store.loadData(REC);
  var store = mygrid.store;
	for(var i=0;i<store.getCount();i++)
	{	var locid=store.getAt(i).get("locid");	
		
		 if (locid=="")
    { 
    	    mygrid.getView().getCell(i,0).style.backgroundColor="#1e90ff"	    	
    }
  }
}
function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
 //alert(233)
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	but1.on('click', newEvent);
	
	var but = Ext.getCmp("mygridbut2");
	but.hide();

	var grid = Ext.getCmp('mygrid');
	grid.getBottomToolbar().hide();
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	//grid.on('rowdblclick',modccevent);
	tobar.addItem('统计类型',SJStatus,'-');
	tobar.addItem({
		xtype: 'datefield',
		format: 'Y-m-d',
		id: 'mygridstdate',
		value: diffDate(new Date(),0)
	}, {
		xtype: 'datefield',
		format: 'Y-m-d',
		id: 'mygridenddate',
		value: diffDate(new Date(),1)
	});
tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "初始化数据",
		handler: cshsj,
		id: 'cshsj'
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "导出",
		handler: expExcel,
		id: 'mygridSch2'
	});
   tobar.doLayout(); 
   var mygridstdate = Ext.getCmp('mygridstdate');
	  mygridstdate.on('select', function() {
			//find();
		});
		var mygridenddate = Ext.getCmp('mygridenddate');
		mygridenddate.on('select', function() {
			//find();
		});
    inidata("CCERR","Desc","web.DHCNurblsjflwh:CRItem","");
  
     //alert(session['LOGON.GROUPID'])
    if (session['LOGON.GROUPID']!=50)
    {   //patward.setValue(session['LOGON.CTLOCID']);
    	  //patward.disable()
    }
    layoutset();
   
	grid.getBottomToolbar().hide()
		//find()  
		//setTimeout("find()",0)
	
}
function expExcel() 
{ 
	var xls = new ActiveXObject ("Excel.Application"); 
	 
	xls.visible =true;  //设置excel为可见 
	var xlBook = xls.Workbooks.Add; 
	var xlSheet = xlBook.Worksheets(1); 
	
	var grid = Ext.getCmp('mygrid');
	var cm = grid.getColumnModel(); 
	var colCount = cm.getColumnCount(); 
	var temp_obj = []; 
	
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{ 
			temp_obj.push(i); 
		} 
	} 
  var StartDate = formatDate(Ext.getCmp("mygridstdate").getValue()); 
  var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue());  
  var Reportid= Ext.getCmp("SJStatus").getValue();
  if (Reportid=="M")  Reportid="月报"
  if (Reportid=="J")  Reportid="季报"
  if (Reportid=="B")  Reportid="半年报"
  if (Reportid=="Y")  Reportid="年报"
  //alert(StartDate)
   //alert(EndDate)
   // alert(Reportid)
	xlSheet.Cells(1,4).Value =StartDate; 
	xlSheet.Cells(1,5).Value ="--------"; 
	xlSheet.Cells(1,6).Value =EndDate; 
	xlSheet.Cells(1,3).Value ="日期范围：";
	xlSheet.Cells(1,1).Value ="护理不良事件上报统计报表  类型:"; 
	xlSheet.Cells(1,2).Value =Reportid; 
	for(i=1;i <=(temp_obj.length-3);i++){ 
		//显示列的列标题 
		xlSheet.Cells(2,i).Value = cm.getColumnHeader(temp_obj[i - 1]); 
	} 
	var store = grid.getStore(); 
	var recordCount = store.getCount(); 
	var view = grid.getView(); 
	for(i=1;i <=recordCount;i++){ 
		for(j=1;j <=(temp_obj.length-3);j++){ 
			//EXCEL数据从第二行开始,故row = i + 1; 
			xlSheet.Cells(i + 2,j).Value = view.getCell(i - 1,temp_obj[j - 1]).innerText; 
		} 
	} 
	xlSheet.Columns.AutoFit; 
	xls.ActiveWindow.Zoom = 75 
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
    xls=null; 
    xlBook=null; 
    xlSheet=null; 
}
function MonthEndJudge(EntrDate)
{
  var tm=EntrDate.split("-");
  var thisYear=tm[0];
  var thisMonth=tm[1];
  var thisDay=tm[2]; 
  var allMonth=[31,28,31,30,31,30,31,31,30,31,30,31]; 
  var allMonth2=[31,29,31,30,31,30,31,31,30,31,30,31]; 
  var retrunflag=0;
  
  if ((thisYear%400==0)||((thisYear%4==0)&&(thisYear%100!=0)))  
  {
    var day=allMonth2[thisMonth-1];
    if (thisDay!=day)
    { 
     	retrunflag=1;    
    }  
  }
  else
  { 
   	var day=allMonth[thisMonth-1]; 
   	if (thisDay!=day)
    { 
     	retrunflag=1;    
    }   
  }
  return  retrunflag;
}

function MonthStartJudge(EntrDate)
{ 
  var tm=EntrDate.split("-");
  var thisYear=tm[0];
  var thisMonth=tm[1];
  var thisDay=tm[2];
  var returnflag=0;
  if (thisDay!=1)
  { 
   	returnflag =1;
  } 
  return returnflag;
}   
function cshsj()
{
  REC = new Array();
  var StartDate = formatDate(Ext.getCmp("mygridstdate").getValue()); 
  var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue());
  var tjtype= Ext.getCmp("SJStatus").getValue();
  if(tjtype=="")
	{
    Ext.Msg.alert('提示', "请选择统计类型后再初始化数据!");
    return;
  }
  var flag=MonthStartJudge(StartDate);
  if (flag!=0)
  {
    Ext.Msg.alert('提示', "所选开始日期不是月初请重新选择日期初始化数据!");
    return;
  }  
  var flag=MonthEndJudge(EndDate);
  if (flag!=0)
  {
    Ext.Msg.alert('提示', "所选结束日期不是月末请重新选择日期初始化数据!");
    return;
  }  
  var parr =StartDate+"^"+EndDate+"^"+tjtype;
  if ((StartDate=="")||(EndDate=="")) return; 
  var JudgeReport = document.getElementById('JudgeReport'); 
  var retId=cspRunServerMethod(JudgeReport.value, parr);  
  //alert(parr)
  //alert(retId)
  if (retId!="")
  {
     Ext.Msg.confirm('系统提示','该月报表已经存在您确定要重新生成数据吗？',
      function(btn){
        if(btn=='yes')
        {
         			var DelReport = document.getElementById('DelReport');	
         			//alert(retId)
         			var ret=cspRunServerMethod(DelReport.value, retId);       			
         			//alert(ret)
         			if(ret=="0")
         			{
                Ext.Msg.alert('提示', "删除报表成功!"); 
              
                var SaveReport = document.getElementById('SaveReport'); 
                var ret=cspRunServerMethod(SaveReport.value, parr);  
                //alert(ret)
                if(ret=="0")
	              {
                 Ext.Msg.alert('提示', "初始化数据完成!");
                 setTimeout("find()",0)
                 return;
                }             
                else
                {  
                 Ext.Msg.alert('提示', "初始化数据失败!");
                 return;
                }  
                window.close();
                
              }         			
           		else
         			{
                Ext.Msg.alert('提示', "删除报表失败,请联系系统管理员!"); 
                return;
         			}			
        }else{
           return;
        }
        
      },this);         
    } 
  else
  {
  //alert(3)
  var SaveReport = document.getElementById('SaveReport'); 
  var ret=cspRunServerMethod(SaveReport.value, parr);  
  if(ret=="0")
	{
    Ext.Msg.alert('提示', "初始化数据完成!");
    setTimeout("find()",0)
    return;
  }
  else
  { 
    Ext.Msg.alert('提示', "初始化数据失败!");
    return;
  }  
  window.close();
  //var mygrid = Ext.getCmp("mygrid");
  //debugger;
  //var a = cspRunServerMethod(GetQueryData.value, "web.DHCNSTFun:DHCNurDHCNURStatistics", "Parr$" + parr, "AddRec");
  //mygrid.store.loadData(REC); 
  }
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
	       msg: '你确定要删除这条记录吗?删除后不可恢复',    
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
	 //alert(par)
		var a = cspRunServerMethod(SetStatus.value,par);		
		find();
	}	
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
function KSubmitFu()
{ //提交
   //alert();
   SetStatusFu('S2');
}
function qdtj()
{
	  var grid=Ext.getCmp('mygrid');
var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	 var par = objRow[0].get("par");
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要提交？提交后不可修改',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            //alert(3); 
	            SetStatusFu('S1',par);
	            
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	    });
	}
	//find();
}
function layoutset()
{
	var GetLayoutItem=document.getElementById('GetLayoutItem');
	//alert(GetLayoutItem);
	var ret=cspRunServerMethod(GetLayoutItem.value,session['LOGON.GROUPID'] ,EmrCode);
	var arr=ret.split("^");
	for (var i=0;i<arr.length;i++)
	{
		var itm=arr[i];
		//alert(itm);
		if (itm=="") continue;
		var itmarr=itm.split("|");
		var com=Ext.getCmp(itmarr[0]);
		com.disable();
	}
}
function SetStatusFu(stat,par)
{
	//var grid=Ext.getCmp("mygrid");
	//var objRow=grid.getSelectionModel().getSelections();
	
	//if (objRow.length == 0) {
	//	return;
	//}
	//else {
	
	  var SetStatus=document.getElementById('SetStatus');
		//var rw = objRow[0].get("rw");
		//var chl = objRow[0].get("chl");
		//var par = objRow[0].get("par");
		//var id=rw+"||"+chl;
		//alert(par);
		var a = cspRunServerMethod(SetStatus.value,par,stat,session['LOGON.USERID'] );
		//alert(a)
		find()
//	}

}
function SubmitFu()
{ //提交
   SetStatusFu('S1');
}
function AuditFu()
{ //审核
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
  var par = objRow[0].get("par");
	var Status = objRow[0].get("Status");
	var Value = objRow[0].get("value");
	var code = objRow[0].get("code");
	if (Status=="未上报") 
	{var Status="V"}
	if (Status=="已上报") 
	{var Status="S1"}
	if (Status=="评价中") 
	{var Status="S2"}
	if (Status=="已审核") 
	{var Status="A"}
	if (objRow.length == 0) {
		Ext.Msg.alert('提示:',"请选择一条记录再审核")
		return;
	}
	else 
	{	
		if ((Status!=="S2")&&(code!="DHCNURXHSB_dulou"))
		{
		//Ext.Msg.alert('提示:',"只有\"评价中\"的记录才能审核")
		//return;				
		}
	
	  
	}
	if (((Value.indexOf("B")==-1)||(Value.indexOf("K")==-1))&&(code!="DHCNURXHSB_dulou")&&(code!="DHCNURXHSB_ssfy"))
	{  //alert(1)
		 if (Value.indexOf("B")==-1)
		{var str="病区护士长"}
		if (Value.indexOf("K")==-1)
		{var str="大科护士长"}
		if ((Value.indexOf("B")==-1)&&((Value.indexOf("K")==-1)))
		{var str="病区护士长和大科护士长"}
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '您确定要审核吗?'+str+'还未填写追踪意见',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            SetStatusFu('A',par);
		          find()          
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	  });
	return;
	}
	//alert(2)
	if ((Value.indexOf("H")==-1))
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '您确定要审核吗？护理部追踪验证还未填写',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            SetStatusFu('A',par);
		          find()          
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	  });
	  return;
	}
//alert(par)
 SetStatusFu('A',par)
 find()  
 
}
function RefundFu()
{ //撤销审核
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
  var Status = objRow[0].get("Status");
  var par = objRow[0].get("par");
	if (Status=="未上报") 
	{var Status="V"}
	if (Status=="已上报") 
	{var Status="S1"}
	if (Status=="评价中") 
	{var Status="S2"}
	if (Status=="已审核") 
	{var Status="A"}
	if (objRow.length == 0) 
	{
		Ext.Msg.alert('提示:',"请选择一条记录再审核")
		return;
	}
	else 
	{	
		if (Status!=="A")
		{
		//Ext.Msg.alert('提示:',"只有\"已审核\"的记录才能要撤销审核")
		//return;				
		}
	  SetStatusFu('S2',par);
		find()
	}
	
}
function tuihui()
{ //退回
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
  var Status = objRow[0].get("Status");
  var par = objRow[0].get("par");
	if (Status=="未上报") 
	{var Status="V"}
	if (Status=="已上报") 
	{var Status="S1"}
	if (Status=="评价中") 
	{var Status="S2"}
	if (Status=="已审核") 
	{var Status="A"}
	//alert(status)
	//alert(par)
	if (objRow.length == 0) 
	{
		Ext.Msg.alert('提示:',"请选择一条记录再审核")
		return;
	}
	else 
	{	
		if (Status=="A")
		{
		Ext.Msg.alert('提示:',"已经审核不能退回，请先撤销审核再退回")
		return;				
		}
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '您确定要退回吗?',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            SetStatusFu('V',par);
		          find()          
	            }
					        else
	            {     find();    	}
	            
	        },    
	       animEl: 'newbutton'   
	  });
	  //SetStatusFu('V',par);
		//find()
	}
	
}
function modccevent()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		 return;
	}
	  var id=objRow[0].get("par")
	  var Status = objRow[0].get("Status");
	  var emrcode=objRow[0].get("code")
	  var usercode=objRow[0].get("usercode")
	    var EpisodeID=objRow[0].get("EpisodeID")
	  if (Status=="未上报") 
		{var Status="V"}
		if (Status=="已上报") 
		{var Status="S1"}
		if (Status=="评价中") 
		{var Status="S2"}
		if (Status=="已审核") 
		{var Status="A"}
		  var lnk= "DHCNurEmrComm.csp?"+"&EmrCode="+emrcode+"&NurRecId="+id +"&Status="+Status+"&Usercode="+usercode+"&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	    window.open(lnk,"htm",'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=860,height=700');
}
function inidata(cmbname,desc,quer,parr)
{
	var cmb=Ext.getCmp(cmbname);
	var querymth=document.getElementById('GetQueryCombox');
	if (cmb!=null)	
	{
 	 arrgrid=new Array();
	 var a = cspRunServerMethod(querymth.value, quer, parr , "AddRec",desc);
	 //alert(arrgrid)
	// debugger;
     cmb.store.loadData(arrgrid);
	}

}

function newEvent()
{
	// var CurrAdm=selections[rowIndex].get("Adm");
	//if (DtId=="")return;
	//var getcurExamId=document.getElementById('getcurExamId');
	//var ExamId=cspRunServerMethod(getcurExamId.value,SpId);
    // alert(ExamId);
	var lnk= "dhcnuremrcomm.csp?"+"&EmrCode=DHCNURykdYWSH&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=860,height=700');



}

var REC=new Array();

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



function AddRec(str)
{
  //alert(str)
	var obj = eval('(' + str + ')');
	REC.push(obj);
}






//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
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
		//alert("ddd");
		//debugger;
		var a=cspRunServerMethod(GetPrnSet.value,"DHCNUR6",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
		if (a=="") return;
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNUR6^"+session['LOGON.CTLOCID']);
		var tm=a.split("^");
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		PrintComm.TitleStr=ret;
		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		var aa=tm[1].split("&");
		//PrintComm.stPage=aa[0];
		//if (aa.length>1) PrintComm.stRow=aa[1];
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB);
		PrintComm.ItmName = "DHCNurPrnMould6"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNUR6";
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="")PrintComm.LabHead=LabHead;
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintComm.PrintOut();
		var SavePrnSet=document.getElementById('SavePrnSet');
		//debugger;
		var CareDateTim=PrintComm.CareDateTim;
		if (CareDateTim=="") return ;
		var pages=PrintComm.pages;
		var stRow=PrintComm.stRow;
		//debugger;
		var stprintpos=PrintComm.stPrintPos;
		//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNUR6"+","+session['LOGON.USERID']+","+PrintComm.PrnFlag);
		//PrnFlag==1说明是打印预览
		if (PrintComm.PrnFlag==1) return;
		//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
		if (pages<aa[0]) return;
		var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNUR6",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
		//find();
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

