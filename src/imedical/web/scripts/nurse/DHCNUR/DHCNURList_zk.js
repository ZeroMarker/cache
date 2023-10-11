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
var arrgrid = new Array();
var arrgridnurse = new Array();
var storenurse = new Ext.data.JsonStore({
			data :arrgridnurse,
			fields : ['desc', 'id']
		});
var storenurse1 = new Ext.data.JsonStore({
			data :[],
			fields : ['desc', 'id']
		});
var patward = new Ext.form.ComboBox({
			id : 'patward',
			//hiddenName : 'region1',
			fieldLabel : '质控病区',
			store : storenurse,
			width : 220,
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
			width : 300,
			fieldLabel : '模板',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});

var myId = "";
var window1=""
function ModeList() {
	//alert(window1)
	if (window1!="")
	{
		window1.close()
	}
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(len)
	if (len < 1) {
		 //Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} else {
		myId = rowObj[0].get("rw");
	}
	var arr = new Array();
	// 录入界面
	 var a = cspRunServerMethod(pdata1, "", "DHCNUR_ZK", EpisodeID, "");   
  arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		if(arr[i].name=='Loc')
		{
			combo.x=arr[i].x
			combo.y=arr[i].y
			combo.width=arr[i].width
			arr[i]=combo;
			//alert(arr[i].width)
			//alert(arr[i].x)
		}
		if(arr[i].name=='Zkitem')
		{
			combo4.x=arr[i].x
			combo4.y=arr[i].y
			combo4.width=arr[i].width
			arr[i]=combo4;
		}
		if(arr[i].name=='Nullitem')
		{
			combo5.x=arr[i].x
			combo5.y=arr[i].y
			combo5.width=arr[i].width
			arr[i]=combo5;
		}
			if(arr[i].name=='Changeitem')
		{
			combo6.x=arr[i].x
			combo6.y=arr[i].y
			combo6.width=arr[i].width
			arr[i]=combo6;
		}
			if(arr[i].name=='Ifself')
		{
			combo7.x=arr[i].x
			combo7.y=arr[i].y
			combo7.width=arr[i].width
			arr[i]=combo7;
		}		
			if(arr[i].name=='Demoitem')
		{
			combo8.x=arr[i].x
			combo8.y=arr[i].y
			combo8.width=arr[i].width
			arr[i]=combo8;
		}		
	}
   window1 = new Ext.Window({
				title : '质控维护',
				width : 880,
				height : 500,
				autoScroll : true,
				layout : 'absolute',
				maximizable:true,
				minimizable:true,
				constrain:true,
				plain:true,
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '保存',
							icon:'../images/uiimages/filesave.png',
							handler : function() {
								Save(window);
								//window.close();
							}
						}, {
							text : '关闭',
							icon:'../images/uiimages/cancel.png',
							handler : function() {
								window1.close();
							}
						}]
			});
		setvalue()
		window1.show();
		return
		
	
	
}
function setvalue()
{
	  var getzkVal=document.getElementById('getzkVal');
	  //alert(344)
		if (getzkVal)
		{
			var getstr=cspRunServerMethod(getzkVal.value,myId);
			var zkstr=getstr.split('^')
			//alert(zkstr)
			var Loc = Ext.getCmp("Loc");
	    if (Loc != null) 
	    {	
		    var getlocward=document.getElementById('getlocward');
		    cspRunServerMethod(getlocward.value,"addloc");
		    Loc.store.loadData(locdata);
	    }
	    //要质控的科室
	    var Dep = Ext.getCmp("Dep");
	    if (Dep != null) 
	    {	
		    Dep.store.loadData(locdata);
		    Dep.on('select', GetDepModelSet);
		    Dep.on('change', GetDepModelSet,this);
		    Dep.setValue(zkstr[0])
		    GetDepModelSet()
	    }
      var EmrCode = Ext.getCmp("EmrCode");
	    if (EmrCode != null) {	
	    EmrCode.disable()
		  var getemrcode=document.getElementById('getemrcode');
		  //alert(getemrcode)
		  if (getemrcode)
		  {   
		    EmrCode.on('select', finditms);
		    EmrCode.setValue(zkstr[1])
	      var Zkuser = Ext.getCmp("Zkuser");
	      var dep = Ext.getCmp("Dep");
	      var getitms = document.getElementById('getitms');
	      //alert(EmrCode.value)
	      //alert(getitms)
	      cspRunServerMethod(getitms.value,dep.value,myId,EmrCode.value,"addloc3");
	      Zkuser.store.loadData(locdata3);	
	      var Zkitem = Ext.getCmp("Zkitem");
	      Zkitem.store.loadData(locdata3);
	      //var Ifself = Ext.getCmp("Ifself"); //修改非默认项
	      //Ifself.store.loadData(locdata3);
	      //var Nullitem = Ext.getCmp("Nullitem");//为空非默认项
	      //Nullitem.store.loadData(locdata3);
	      var Demo = Ext.getCmp("Demo");
	      Demo.store.loadData(locdata3);
	      var Demoitem = Ext.getCmp("Demoitem");
	      Demoitem.store.loadData(locdata3);
	      var Changeitem = Ext.getCmp("Changeitem");
	      Changeitem.store.loadData(locdata3);					
	    }
	    var Type = Ext.getCmp("Type");
	    Type.setValue(zkstr[2])
	    var Zkuser = Ext.getCmp("Zkuser");
	    Zkuser.setValue(zkstr[3])
	    var Demo = Ext.getCmp("Demo");
	    Demo.setValue(zkstr[4])
	     var Mseqno = Ext.getCmp("Mseqno");
	    Mseqno.setValue(zkstr[23])
	    var Mnum = Ext.getCmp("Mnum");
	    Mnum.setValue(zkstr[24])
	    //Zkitem.value=zkstr[5]
	    //Zkitem.valueId=zkstr[5]
	    var Zkitem = Ext.getCmp("Zkitem")
	    Zkitem.valueId=zkstr[6]
	    Zkitem.setValue(zkstr[16])
	    checkselect("Zkitem",zkstr[6]) //签名关联项维护
	     var Ifnull = Ext.getCmp("Ifnull");
	    Ifnull.setValue(zkstr[7])
	    if (zkstr[7]=="Y")
	    { 
	      //HideUI("Nullitem")
	    }
      //Ifnull.on('change',Nullitemdisplay,this);
      
      var Ifchange=Ext.getCmp("Ifchange");      
      Ifchange.setValue(zkstr[9])
      if (zkstr[9]=="Y")
	    { 
      //HideUI("Ifself")
      }
     
      //Ifchange.on('change',Ifselfdisplay,this);
	    var Demo = Ext.getCmp("Demo");
	    Demo.setValue(zkstr[4])
	     var Changeitem = Ext.getCmp("Changeitem")
	     Changeitem.setValue(zkstr[18]) 
	    Changeitem.valueId=zkstr[11]
	    checkselect("Changeitem",zkstr[11]) //不允许修改项
	     var Sdate = Ext.getCmp("Sdate");
	    Sdate.setValue(zkstr[12])
	     var Stime = Ext.getCmp("Stime");
	    Stime.setValue(zkstr[13])
	     var ifall = Ext.getCmp("ifall");
	    ifall.setValue(zkstr[22])
	      var Scondition = Ext.getCmp("Scondition");
	    Scondition.setValue(zkstr[14])
	    var Loc = Ext.getCmp("Loc"); 
	    Loc.valueId=zkstr[15]	   
	    Loc.setValue(zkstr[20]) 
	    checkselect("Loc",zkstr[15]) //适用科室
	    //alert(zkstr[15])
	    //alert(zkstr[0])
	    if ((zkstr[15].indexOf(zkstr[0])==-1)&(zkstr[15]!=""))
	    {
	    	//Loc.disable()
	    }
	    
	    var Nullitem = Ext.getCmp("Nullitem"); //不允许为空维护
      var flag=addstore(zkstr[6],zkstr[16])  //更新store	              
	    Nullitem.store.loadData(locdata5);
	    Nullitem.valueId=zkstr[8]	    
	    Nullitem.setValue(zkstr[21])
	    checkselect("Nullitem",zkstr[8])
	    
	    var Ifself = Ext.getCmp("Ifself"); //允许别人修改
      var flag3=addstoreitm(zkstr[6],zkstr[16],"Ifself",locdata7)  //更新store	    
	    Ifself.store.loadData(locdata7);
	    Ifself.valueId=zkstr[10]	   
	    Ifself.setValue(zkstr[19]) 
	    checkselect("Ifself",zkstr[10])
	    
	     var Demoitem = Ext.getCmp("Demoitem"); //允许别人修改
      //var flag3=addstoreitm(zkstr[6],zkstr[16],"Demoitem",locdata7)  //更新store	    
	    // Ifself.store.loadData(locdata7);
	    Demoitem.setValue(zkstr[17])
	    Demoitem.valueId=zkstr[5]	    
	    checkselect("Demoitem",zkstr[5])
	  }
	}
}
//var getlocward=document.getElementById('getlocward');
//alert(getlocward)
tkMakeServerCall("web.DHCNuremrqc","getlocward","addlocward")
//cspRunServerMethod(getlocward.value,"addlocward");

function addlocward(a, b) {
	arrgridnurse.push({
				id : a,
				desc : b
			});
}
patward.store.loadData(arrgridnurse);
function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	var gform=Ext.getCmp("gform");
	gform.setAutoScroll(false);
	//fm.doLayout(); 
	//alert(EmrCode)
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	but1.on('click', newEvent);
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	but.on('click', ModeList);
	//but.hide();
 
	var grid = Ext.getCmp('mygrid');
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'rw'){
				grid.getColumnModel().setHidden(i,true);
			}
	}
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	grid.on('rowdblclick',ModeList);
  tobar.addItem('质控病区',
		patward,'-' ,'事件',CCERR,'-');
		
	tobar.addButton({
		//className: 'new-topic-button',
		text: "增加",
		handler: newEvent,
		icon:'../images/uiimages/edit_add.png',
		id: 'addbut'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "删除",
		icon:'../images/uiimages/edit_remove.png',
		handler: qddelete,
		id: 'delete'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		text: "修改",
		handler: ModeList,
		icon:'../images/uiimages/pencil.png',
		id: 'editbut'
	});
	tobar.addItem("-");
	tobar.addButton({
		//className: 'new-topic-button',
		icon:'../images/uiimages/search.png',
		text: "查询",
		handler: find2,
		id: 'mygridSch'
	});
/*	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "提交",
		handler: qdtj,
		id: 'SubmitFu'
	});*/
	/*
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "审核",
		handler: AuditFu,
		id: 'AuditFu'
	});
	tobar.addItem("-");
	tobar.addButton({
		className: 'new-topic-button',
		text: "退回",
		handler: RefundFu,
		id: 'RefundFu'
	});
	*/
	
	tobar.addItem("-");
   tobar.doLayout(); 
      grid.addListener('rowclick', function()
   { 
   	var grid = Ext.getCmp('mygrid');
   	var objRow=grid.getSelectionModel().getSelections();
	  if (objRow.length == 0) {
		return;
	 }
	 else
 {		
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var dep = Ext.getCmp("patward");
	//dep.setValue("246")
	dep.setValue(rowObj[0].get("dep"));
	}}
   );
	//inidata("patward","Desc","web.DHCNuremrqc.getlocward","Loc$");
   // inidata("CCERR","Desc","web.DHCNurblsjflwh:CRItem","");
    //patward.setValue(session['LOGON.CTLOCID']);
    //layoutset();
    patward.on('select', GetDepModel);
		patward.on('change', GetDepModel,this);
    grid.getBottomToolbar().hide();
  //find2();
//alert();
//debugger;
}
function GetDepModel()
{ 
	     locdata2 = new Array();
	    var CCERR = Ext.getCmp("CCERR");
	    var Dep = Ext.getCmp("patward");
	    //alert(Dep.value)
	    var getemrcode=document.getElementById('getemrcode');
	    cspRunServerMethod(getemrcode.value,Dep.value,"addloc2");
		  CCERR.store.loadData(locdata2);		     
		  //EmrCode.on('select', finditms);			
	}
var Rec=new Array();
function find2()
{	
  var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	Rec=new Array();
	var CCERR = Ext.getCmp("CCERR");
	var Dep = Ext.getCmp("patward");
	var parr=Dep.value+"^"+CCERR.value
	//alert(parr)
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNUREMRQC:CRItem", "parr$"+parr, "AddRecfind");
  //alert(a);
  grid.store.loadData(Rec);   
}
var myId=""
function Save()
{
 	var EmrCode = Ext.getCmp("EmrCode").value;
 	var EmrCodede = Ext.getCmp("EmrCode").lastSelectionText;
	var Type = Ext.getCmp("Type").getValue();
	var Zkuser = Ext.getCmp("Zkuser").value;
	var Zkuserdesc = Ext.getCmp("Zkuser").lastSelectionText;
	var Demo = Ext.getCmp("Demo").value;
	var Demodesc=Ext.getCmp("Demo").lastSelectionText;
	var Demoitem = Ext.getCmp("Demoitem").valueId;
	var Demoitemdesc = Ext.getCmp("Demoitem").value;
	var Zkitem = Ext.getCmp("Zkitem").valueId;
  var Zkitemdesc ="";
	if (descseqno==1)
	{
	   Zkitemdesc=onezkitemdesc;
	}
	else
	{
		 Zkitemdesc = Ext.getCmp("Zkitem").getValue();
	}
	//debugger
	var Ifnull = Ext.getCmp("Ifnull").value; 
	var Nullitem = Ext.getCmp("Nullitem").valueId;
	var Nullitemdesc = Ext.getCmp("Nullitem").value;
	var Ifchange = Ext.getCmp("Ifchange").getValue();
	var Changeitem = Ext.getCmp("Changeitem").valueId;
	var Changeitemdesc = Ext.getCmp("Changeitem").value;
	var Ifself = Ext.getCmp("Ifself").valueId;
	var Ifselfdesc = Ext.getCmp("Ifself").value;
	var Sdate = Ext.getCmp("Sdate").value;
	var Stime = Ext.getCmp("Stime").getValue();
	var Scondition = "";
	var Loc = Ext.getCmp("Loc").valueId;
	var Locdesc = Ext.getCmp("Loc").value;
	var Dep = Ext.getCmp("Dep").value;
	var Depdesc = Ext.getCmp("Dep").lastSelectionText;
	var ifall2= Ext.getCmp("ifall").value; 
	var Mseqno= Ext.getCmp("Mseqno").value; 
	var Mnum= Ext.getCmp("Mnum").value; 
	//alert(descseqno)
	//alert(onezkitemdesc)
	if (ifall2=="")
	{
		ifall2="Y" //如果为空默认全院通用
	}
	if (ifall2=="Y")
	{
		//Loc="" //如果全院通用，关联科室为空
		//Locdesc=""
	}
	if (Loc!="")
	{
		ifall2="N" //如果关联科室不为空，非全院通用
		if (Loc.indexOf(Dep)==-1)
		{
			Loc=Loc+","+Dep
		}
	}
	
	//alert(Loc)
	    ret=""
			ret = ret + "EmrCode|" + EmrCode + "^";
			ret = ret + "EmrCodeDesc|" + EmrCodede + "^";
			ret = ret + "Type|" + Type + "^";
			ret = ret + "Zkuser|" + Zkuser + "^";
			ret = ret + "Zkuserdesc|" + Zkuserdesc + "^";
			ret = ret + "Zkitem|" + Zkitem + "^";
			ret = ret + "Zkitemdesc|" + Zkitemdesc + "^";
			ret = ret + "Ifnull|" + Ifnull + "^";
			ret = ret + "Nullitem|" + Nullitem + "^";
			ret = ret + "Nullitemdesc|" + Nullitemdesc + "^";
			ret = ret + "Ifchange|" + Ifchange + "^";
			ret = ret + "Changeitem|" + Changeitem + "^";
			ret = ret + "Changeitemdesc|" + Changeitemdesc + "^";
			ret = ret + "Ifself|" + Ifself + "^";
			ret = ret + "Ifselfdesc|" + Ifselfdesc + "^";
			ret = ret + "Sdate|" + Sdate+"^";
			ret = ret + "Stime|" + Stime + "^";
			ret = ret + "Id|" + myId+"^";		
			ret = ret + "Zkloc|" + Dep+"^";	
			ret = ret + "Demo|" + Demo+"^";
			ret = ret + "Demoitem|" + Demoitem+"^";
			ret = ret + "Demoitemdesc|" + Demoitemdesc+"^";
			ret = ret + "LinkDep|" + Loc+"^";		
			ret = ret + "LinkDepdesc|" + Locdesc+"^";				
			ret = ret + "Scondition|" + Scondition+"^";
			ret = ret + "ifall|" + ifall2+"^";
			ret = ret + "Demodesc|" + Demodesc+"^";
			ret = ret + "Mseqno|" + Mseqno+"^";
			ret = ret + "Mnum|" + Mnum+"^";
			//alert(ret)
			//alert(Dep)
			if ((Dep=="")||(EmrCode=="")||(Type==""))
			{
				alert("科室模板类型不能为空")
				return
				
			}
			var len=Loc.split('^').length
			//alert(len)
			if ((Loc.indexOf(Dep)==-1)&(myId!="")&(len>1))
			{
				alert("适用或关联科室项中不能取消("+Depdesc+")的选择!")
				return
				}
			//alert(ret)
			//return
		var Saveobj=document.getElementById('Save');
		if (Saveobj)
		{
			var flag=cspRunServerMethod(Saveobj.value, ret,myId);
		}
		//alert(flag)
		if (flag==0)
		{
			//alert("保存成功")
			if (myId=="")
			{
			find2();
      window1.close();
      
      }
			else
				{
					 qdgb()
				}
		}
		else
		{
				alert(flag)
		}
  //alert(flag);
}
function qdgb()
{
	       Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '保存成功! 您要关闭该页面吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	            window1.close();  //关闭子窗口  
	            //find2();
	            
	            }
					    else
	            {   //alert(33)
	            	setvalue()
	            }
	            
	        },    
	       animEl: 'newbutton'   
	       });
	
	
}
function qddelete()
{
	  var grid=Ext.getCmp('mygrid');
var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
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
	 var par = objRow[0].get("rw");
	 /* var Status = objRow[0].get("Status");
    if (Status=="核实") 
		{var Status="V"}
		if (Status=="提交") 
		{var Status="S"}
		if (Status=="审核") 
		{var Status="A"}
	  if (Status!=="V")
	  {
	   Ext.Msg.alert('提示', "已提交或审核不可删除!")
	  
	  return;
	  }*/
		var a = cspRunServerMethod(SetStatus.value,par);		
		find2();
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
   SetStatusFu('S');
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
		var EpisodeID = objRow[0].get("EpisodeID");
		
		//alert(EpisodeID)
		
	
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURRecordxhn1&EpisodeID="+EpisodeID+"&NurRecId="+par ;//"&DtId="+DtId+"&ExamId="+ExamId
	    window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=1040,height=800');

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
	 //alert(arrgrid)
	// debugger;
     cmb.store.loadData(arrgrid);
	}

}
//适用科室
  var locdata = new Array();
	var store=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo={
		name:'Loc',
		id:'Loc',
		tabIndex:'0',
		x:x1,
		y:y1,
		height:121,

		width:152,
		xtype:'combo',
		store:store,
		editable:true,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	/*
	//模板选择
	var locdata2 = new Array();
	var store2=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo2={
		name:'模板',
		id:'EmrCode',
		tabIndex:'0',
		x:84,
		y:31,
		height:21,
		width:152,
		xtype:'combo',
		store:store2,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	*/
	//质控关联项
	var onezkitemdesc="";
	var descseqno=0;
	var locdata4 = new Array();  
	var store4=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo4={
		name:'模板',
		id:'Zkitem',
		tabIndex:'0',
		x:84,
		y:131,
		height:21,
		width:252,
		xtype:'combo',
		store:store4,
		displayField:'desc',
		valueField:'id',
		editable:false,
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
            	  //alert(this.value+index)
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                descseqno=0;
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                        descseqno=descseqno+1;
                    }
                });
               // alert(str)
                onezkitemdesc=str;
                
                this.setValue(str.join());
                this.value=str.join();
                //this.value=strvalue.join();
                this.valueId= strvalue.join();
              	//alert(this.value)				              
                this.fireEvent('select', this, record, index);      
                 var Nullitem = Ext.getCmp("Nullitem"); //不允许为空维护
                 var flag=addstore(this.value,str.join())  //更新store	              
	               Nullitem.store.loadData(locdata5);
	               checkselect("Nullitem",flag)
	               
	               //var Changeitem = Ext.getCmp("Changeitem"); //不允许修改项维护         
                 //var flag6=addstoreitm(this.value,str.join(),"Changeitem",locdata6)  //更新store	             
	               //Changeitem.store.loadData(locdata6);
	               //checkselect("Changeitem",flag6)
	               
	                var Ifself = Ext.getCmp("Ifself"); //只允许本人修改项维护	          
                 var flag7=addstoreitm(this.value,str.join(),"Ifself",locdata7)  //更新store	             
	               Ifself.store.loadData(locdata7);
	               checkselect("Ifself",flag7)
	              
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	
	//不为空项维护
	var locdata5 = new Array();  
	var store5=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo5={
		name:'模板',
		id:'Nullitem',
		tabIndex:'0',
		x:84,
		y:200,
		height:21,
		width:252,
		xtype:'combo',
		store:store5,
		editable:false,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                	//alert(rc.get('check'))
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	
	//不允许修改项维护
	var locdata6= new Array();  
	var store6=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo6={
		name:'不允许修改项维护',
		id:'Changeitem',
		tabIndex:'0',
		x:84,
		y:270,
		height:21,
		width:252,
		xtype:'combo',
		store:store6,
		displayField:'desc',
		valueField:'id',
		editable:false,
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	
	//只允许本人修改项维护
	var locdata7= new Array();  
	var store7=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo7={
		name:'只允许本人修改项维护',
		id:'Ifself',
		tabIndex:'0',
		x:84,
		y:320,
		height:21,
		width:252,
		xtype:'combo',
		store:store7,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		editable:false,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
	
 //超级用户关联签名
	var locdata8= new Array();  
	var store8=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo8={
		name:'只允许本人修改项维护',
		id:'Demoitem',
		tabIndex:'0',
		x:84,
		y:320,
		height:21,
		width:252,
		xtype:'combo',
		editable:false,
		store:store8,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
var logonht=1;
var x1=0,y1=500;
var x2=0,y2=0;
var x3=0,y3=0;
var x4=0,y4=0;
function newEvent()
{	 
	myId = "";
	var arr = new Array();
  var a = cspRunServerMethod(pdata1, "", "DHCNUR_ZK", EpisodeID, "");   
  arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		if(arr[i].name=='Loc')
		{
			combo.x=arr[i].x
			combo.y=arr[i].y
			combo.width=arr[i].width
			arr[i]=combo;
			//alert(arr[i].width)
			//alert(arr[i].x)
		}
		if(arr[i].name=='Zkitem')
		{
			combo4.x=arr[i].x
			combo4.y=arr[i].y
			combo4.width=arr[i].width
			arr[i]=combo4;
		}
		if(arr[i].name=='Nullitem')
		{
			combo5.x=arr[i].x
			combo5.y=arr[i].y
			combo5.width=arr[i].width
			arr[i]=combo5;
		}
			if(arr[i].name=='Changeitem')
		{
			combo6.x=arr[i].x
			combo6.y=arr[i].y
			combo6.width=arr[i].width
			arr[i]=combo6;
		}
			if(arr[i].name=='Ifself')
		{
			combo7.x=arr[i].x
			combo7.y=arr[i].y
			combo7.width=arr[i].width
			arr[i]=combo7;
		}		
			if(arr[i].name=='Demoitem')
		{
			combo8.x=arr[i].x
			combo8.y=arr[i].y
			combo8.width=arr[i].width
			arr[i]=combo8;
		}		
	}
	 window1 = new Ext.Window({
				title : '质控维护',
				width : 880,
				height : 500,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '保存',
							icon:'../images/uiimages/filesave.png',
							handler : function() {
								Save(window);
								//window.close();
							}
						}, {
							text : '关闭',
							icon:'../images/uiimages/cancel.png',
							handler : function() {
								window1.close();
							}
						}]
			});
				
	
	var Loc = Ext.getCmp("Loc");
	if (Loc != null) 
	{	
		//cspRunServerMethod(GetLocNew,"DOCTOR","addloc");
		//var getlocward=document.getElementById('getlocward');
		//cspRunServerMethod(getlocward.value,"addloc");
		tkMakeServerCall("web.DHCNuremrqc","getlocward","addloc")
		Loc.store.loadData(locdata);
		//dep.on('select', findperson);
	}
	//要质控的科室
	var Dep = Ext.getCmp("Dep");
	if (Dep != null) 
	{	//var getlocward=document.getElementById('getlocward');
		//cspRunServerMethod(getlocward.value,"addloc");
		Dep.store.loadData(locdata);
		Dep.on('select', GetDepModelSet);
		Dep.on('change', GetDepModelSet,this);
	}
  var EmrCode = Ext.getCmp("EmrCode");
	if (EmrCode != null) {	
		var getemrcode=document.getElementById('getemrcode');
		//alert(getemrcode)
		if (getemrcode)
		{
		  //cspRunServerMethod(getemrcode.value,"","addloc2");
		  //EmrCode.store.loadData(locdata2);		     
		  EmrCode.on('select', finditms);					
	  }
	}	
	//EmrCode.setValue("消化内科表格护理单1")
	/*
	var instr="DHCNURRECORDXHN1"
	Ext.getCmp("EmrCode").value=(instr);  
  var Zkuser = Ext.getCmp("Zkuser");
	var getitms = document.getElementById('getitms');
	cspRunServerMethod(getitms.value,"DHCNURRECORDXHN1","addloc3");
	Zkuser.store.loadData(locdata3);	
	var Zkitem = Ext.getCmp("Zkitem");
	Zkitem.store.loadData(locdata3);
	Zkuser.value="Item100"
	Zkitem.value="Item1001222,Item101,Item102,Item103"
	Zkitem.valueId="Item100,Item101,Item102,Item103"
	checkselect("Zkitem","Item100,Item101,Item103")
	
	  var Nullitem = Ext.getCmp("Nullitem"); //不允许为空维护
    var flag=addstore("Item100,Item101,Item102,Item103","Item100,Item101,Item102,Item103","Nullitem",locdata5)  //更新store	   
    //var flag6=addstoreitm(this.value,str.join(),"Changeitem",locdata6)  //更新store
    //alert(flag)           
	  Nullitem.store.loadData(locdata5);
	  Nullitem.value="Item100ddd,Item103"
	  Nullitem.valueId="Item100,Item103"
	  checkselect("Nullitem","Item100,Item103")
	//EmrCode.store.loadData(locdata2);
	
	*/
	 var Type=Ext.getCmp("Type");
   Type.setValue("User")
    var Dep=Ext.getCmp("Dep");
    var patward=Ext.getCmp("patward");
    var CCERR=Ext.getCmp("CCERR");
    if (patward.value!="")
    {
     Dep.setValue(patward.value)
     GetDepModelSet()
    }
     if (CCERR.value!="")
    {
     //Dep.setValue(patward.value)
     //GetDepModelSet()
    }
    var Ifnull=Ext.getCmp("Ifnull");
    Ifnull.setValue("Y")
    //HideUI("Nullitem")
    //Ifnull.on('change',Nullitemdisplay,this);
    var Ifchange=Ext.getCmp("Ifchange");
   Ifchange.setValue("Y")
   var ifall=Ext.getCmp("ifall");
    ifall.setValue("Y")
   //HideUI("Ifself")
   //Ifchange.on('change',Ifselfdisplay,this);
   
   
	window1.show();
}
function Ifselfdisplay(obj)
{ 
	 var tmp=obj.getValue(); //当前值
	//var NAME=obj.getName();
	 if (tmp=="N")
	 {
	 	var dd=	Ext.getCmp("Ifself")
	 	dd.setVisible(true) 
	 // dd.removeAttribute("disabled");
	 //	Ext.getCmp("Ifself").removeAttr("disabled");
	 }
	  if (tmp=="Y")
	 {
	 	var dd=	Ext.getCmp("Ifself")
	 	dd.setVisible(false) 
	 }
	}
function Nullitemdisplay(obj)
{ 
	 var tmp=obj.getValue(); //当前值
	//var NAME=obj.getName();
	 if (tmp=="N")
	 {
	 	var dd=	Ext.getCmp("Nullitem")
	  dd.setVisible(true) 
	 }
	 if (tmp=="Y")
	 {
	 	var dd=	Ext.getCmp("Nullitem")
	  dd.setVisible(false) 
	 }
	}
function HideUI(itm)
{
    //var ui =Ext.getCmp(itm);
    Ext.getCmp(itm).setVisible(false)
}
function displayHideUI(itm)
{
    //var ui =Ext.getCmp(itm);
    //alert(ui)
    Ext.getCmp(itm).setVisible(true) //=true;
}
var locdata2 = new Array();
function GetDepModelSet()
{ 
	     locdata2 = new Array();
	    var EmrCode = Ext.getCmp("EmrCode");
	    var Dep = Ext.getCmp("Dep");
	    //alert(Dep.value)
	    //var getemrcode=document.getElementById('getemrcode');
	    //cspRunServerMethod(getemrcode.value,Dep.value,"addloc2");
	    
	    tkMakeServerCall("web.DHCNuremrqc","GetDepModelSet",Dep.value,"addloc2")
		  EmrCode.store.loadData(locdata2);		     
		  //EmrCode.on('select', finditms);			
	}
function addloc(a, b) {
	//alert(a)
	locdata.push({
				id : a,
				desc : b
			});
}

function addloc2(a, b) {
	//alert(a)
	locdata2.push({
				id : a,
				desc : b
			});
}
//关联项
locdata3 = new Array();
function addloc3(a, b) {
	//alert(a)
	locdata3.push({
				id : a,
				desc : b
			});
}
//不允许为空维护
function addloc5(a, b) {
	//alert(a)
	locdata5.push({
				id : a,
				desc : b
			});
}
function finditms(p, record, index) {
	//alert(combo.value+"^"+record+"^"+index);
	var EmrCode = Ext.getCmp("EmrCode");
	var Zkuser = Ext.getCmp("Zkuser");
	var dep = Ext.getCmp("Dep");
	var getitms = document.getElementById('getitms');
	//alert(myId)
	locdata3 = new Array();
	//cspRunServerMethod(getitms.value,dep.value,myId,EmrCode.value,"addloc3");
	tkMakeServerCall("web.DHCNuremrqc","GetCodeList",dep.value,myId,EmrCode.value,"addloc3")
	Zkuser.store.loadData(locdata3);	
	var Zkitem = Ext.getCmp("Zkitem");
	Zkitem.store.loadData(locdata3);
	var Demo = Ext.getCmp("Demo");
	Demo.store.loadData(locdata3);
	var Demoitem = Ext.getCmp("Demoitem");
	Demoitem.store.loadData(locdata3);
	var Changeitem = Ext.getCmp("Changeitem");
	Changeitem.store.loadData(locdata3);
	//var Ifnull = Ext.getCmp("Ifnull");
	//Ifnull.on('change',scoreAdd,this);
	//Zkitem.on('change',scoreAdd,this);
	
}
function addstore(a, b) {
	 var aa=a.split(",");	
	 var bb=b.split(",");
	 var flag=0

	 var Nullitem=Ext.getCmp("Nullitem");
	 var Nullitemold = Nullitem.valueId; //不允许为空维护 :值
	
	  for (j=0;j<locdata5.length;j++) //locdata5缓存中是否都能在新的aa中找到？找不到则删除
   {  
   	 var ixistval=locdata5[j].id
   	 var ixflag=0
   	 for (i=0;i<aa.length;i++)
	   {	
	   	if (aa[i]==ixistval)  
	   	{ixflag=1} 		 
	   }
	   //alert(ixflag)
	   if (ixflag==0)
	   {
	   	locdata5.splice(j,j+1); 
	   	j=j-1
	   }	 
	 }
	    Nullitem.store.loadData(locdata5);
   	  var obj=Ext.getCmp("Nullitem");
	    obj.store.each(function(rc){   		
   		var id1=rc.get('id')     	   	               
      });
	 
	//alert(locdata5.length)
	   for (i=0;i<aa.length;i++) //aa中元素能否在locdata5缓存中找到？找不到则增加
	   {	   
	   	 var ixflag=0
   	   for (j=0;j<locdata5.length;j++)
	     {	
	     	var ixistval=locdata5[j].id
	   	  if (aa[i]==ixistval)  
	   	  {ixflag=1} 		 
	     }
	     //	alert(ixflag)  
	     if (ixflag==0)	
	     {	 		     
	 	    addloc5(aa[i],bb[i])	 
	 	   }	 
	   }
	    var Nullitem=Ext.getCmp("Nullitem");
	    var Nullitemnew = Nullitem.valueId; //不允许为空维护 :值
	    //alert(Nullitemnew)
  // locdata5.splice(0,locdata5.length); 
 
	 return Nullitemnew
	
}
function addstoreitm(a, b,itm,storeitm) {
	 var aa=a.split(",");	
	 var bb=b.split(",");
	 var flag=0
   //alert(storeitm)
	 var Nullitem=Ext.getCmp(itm);
	 var Nullitemold = Nullitem.valueId; //不允许为空维护 :值
	
	  for (j=0;j<storeitm.length;j++) //locdata5缓存中是否都能在新的aa中找到？找不到则删除
   {  
   	 var ixistval=storeitm[j].id
   	 var ixflag=0
   	 for (i=0;i<aa.length;i++)
	   {	
	   	if (aa[i]==ixistval)  
	   	{ixflag=1} 		 
	   }
	   //alert(ixflag)
	   if (ixflag==0)
	   {
	   	storeitm.splice(j,j+1); 
	   	j=j-1
	   }	 
	 }
	    Nullitem.store.loadData(storeitm);
   	  var obj=Ext.getCmp(itm);
	    obj.store.each(function(rc){   		
   		var id1=rc.get('id')     	   	               
      });
	 
	//alert(locdata5.length)
	   for (i=0;i<aa.length;i++) //aa中元素能否在locdata5缓存中找到？找不到则增加
	   {	   
	   	 var ixflag=0
   	   for (j=0;j<storeitm.length;j++)
	     {	
	     	var ixistval=storeitm[j].id
	   	  if (aa[i]==ixistval)  
	   	  {ixflag=1} 		 
	     }
	     //	alert(ixflag)  
	     if (ixflag==0)	
	     {	 		     
	 	    addlocstore(aa[i],bb[i],storeitm)	 
	 	   }	 
	   }
	    var Nullitem=Ext.getCmp(itm);
	    var Nullitemnew = Nullitem.valueId; //不允许为空维护 :值
	    //alert(Nullitemnew)
  // locdata5.splice(0,locdata5.length); 
 
	 return Nullitemnew
	
}
//不允许为空维护
function addlocstore(a, b,storeitm) {
	//alert(a)
	storeitm.push({
				id : a,
				desc : b
			});
}
function scoreAdd(obj)
{ 
	 var scorehj=0;
	 var tmp=obj.getValue(); //当前值
	 var idsss=obj.getName();
	 	var Zkitem=Ext.getCmp("Zkitem");
	 var glitm2 = Zkitem.valueId;
	 var descs=Zkitem.value
	 var Nullitem = Ext.getCmp("Nullitem"); //不允许为空维护
	 var Changeitem = Ext.getCmp("Changeitem"); //不允许修改项维护
	 var Ifself = Ext.getCmp("Ifself"); //只允许本人修改项维护
	 var flag=""
	 var flag=addstore(glitm2,descs)  //更新store
	 alert(flag)
	
	    Nullitem.store.loadData(locdata5);
	   // Changeitem.store.loadData(locdata5);
	   // Ifself.store.loadData(locdata5);
	 
	 //Nullitem.setValue="Item100"
	 //alert(33)
	 checkselect("Nullitem",flag)
                
	}
function checkselect(itm,instr)
{ 
	 var obj=Ext.getCmp(itm);
	 var str=[];//页面显示的值
	 var strvalue=[];//传入后台的值
	 str.push(instr);
	 strvalue.push(instr);
     var aa=instr.split(",");	
     obj.store.each(function(rc){
   	 var ixflag=0
   	 var id1=rc.get('id')
   	 for (i=0;i<aa.length;i++)
	{	
	   if (aa[i]==id1)  
	   {ixflag=1} 		 
	}
   	 if (ixflag==1)
   	 {
   	     rc.set('check',!rc.get('check'));  	 
   	 }               
    });
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
function find()
{
	//var StDate = Ext.getCmp("mygridstdate");
	//var Enddate = Ext.getCmp("mygridenddate");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr ="DHCNURPF^"+EpisodeID;
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


	//alert(StDate.vlaue);
	var parr = "DHCNURRecordxhn1^"+adm+"^"+loc+"^"+StDate.value+"^"+Enddate.value;
 // alert(parr);
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurblsjflwh:NurseData", "parr$" +parr,"AddRec");
	//alert(a);
  mygrid.store.loadData(arrgrid);   

}


function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(str);
	//var obj = eval('(' + str + ')');
	//alert(str);
	//obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function AddRecfind(str)
{
	//var a=new Object(eval(str));
	//alert(str);
	//var obj = eval('(' + str + ')');
	//alert(str);
	//obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	var obj = eval('(' + str + ')');
	Rec.push(obj);
	//debugger;
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

