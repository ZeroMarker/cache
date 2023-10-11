/**
 * @author oudejun
 */ 
var ret="";
var checkret="";
var comboret=""; 
var radioret=""; 
var RadioScore=0;
var CheckScore=0;
 
var arrgrid=new Array();
var ha = new Hashtable();

function eachItem2(item,index,length) {   
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   
			
      
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
      
    } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+item.id+"|"+item.getRawValue()+"^";   
      
    }  
     
   if (item.xtype=="radio") {  
   	    if (item.getValue()==true) radioret=radioret+item.id+"|"+item.boxLabel+"^";   
        else {radioret=radioret+item.id+"|"+""+"^";}
   	    //alert(radioret);
     }  
   
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
				//debugger;
       //alert("item.checked="+item.checked);
       if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";
       else {checkret=checkret+item.id+"|"+""+"^";}
       item.on('check',scoregroup,this)  
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem2, this);   
    }   
} 

function rowdblclickFn(grid, rowIndex, e) { 
    selections = grid.getSelectionModel().getSelections();
    var arr = new Array();
    EpisodeID=grid.store.getAt(rowIndex).get(grid.getColumnModel().getDataIndex(6));
    RowId=grid.store.getAt(rowIndex).get(grid.getColumnModel().getDataIndex(7));
    var lnk= "dhcnuremrcomm.csp?"+"&EmrCode=DHCNURANHUI25"+"&EpisodeID="+EpisodeID+"&DHCMoudDataRowId="+RowId;  
    //var StartDate = formatDate(Ext.getCmp("mygridstdate").getValue()); 
    //var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue()); 
    //var lnk= "dhcnuremrcomm.csp?"+"&EmrCode=DHCNURANHUI21;
    window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=860,height=700');
 }


function BodyLoadHandler() {
	  setsize("mygridpl", "gform", "mygrid");
    var grid = Ext.getCmp("mygrid");
    var but = Ext.getCmp("mygridbut1");
    but.on('click', newfourdan);  
    var but2 = Ext.getCmp("mygridbut2");
    but2.hide();
     
    grid.addListener('rowclick', rowClickFn);
    grid.addListener('rowdblclick', rowdblclickFn); 
    grid.addListener('rowcontextmenu', rightClickFn);

    
    var tobar = grid.getTopToolbar();

var PatInfo=document.getElementById('PatInfo');
	if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
			var tt=ret.split('^');
	  var ret2=tt[10];
	  var tt2=ret2.split('|');
	  var stdate=tt2[1];
	  //alert(stdate+"@"+(diffDate(new Date(), -2)))
	}
	else{
		var stdate=(diffDate(new Date(), -2))
		}
    tobar.addItem("-",{
				xtype : 'datefield',
				format : 'Y-m-d',
				id : 'mygridstdate',
				value : stdate   //(diffDate(new Date(), -2))
			}, {
				xtype : 'datefield',
				format : 'Y-m-d',
				id : 'mygridenddate',
				value : (diffDate(new Date(), 0))
			}); 
		 tobar.addButton({
				text : "查询",
				handler : FindSPLIST,
				id : 'butFind'
			}); 
	 	tobar.doLayout();
	  FindSPLIST(); 
 }  
  
function CancelRecord()
{
	var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要作废此条护理记录吗?',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){    
					var RowId= objRow[0].get("RowId");
					//alert(RowId);					
					if (objCancelRecord) {
						var a = cspRunServerMethod(objCancelRecord.value, RowId, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
						if (a!=0){
							alert(a);
							return;
						}else{
							FindSPLIST();
						}
					}
	            }    
	        },    
	       animEl: 'newbutton'   
	    });
	}
}

 
var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [   {
                id:'rMenu7',
                text : '作废',
                handler:CancelRecord
            }]
        });

function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
function rowClickFn(grid, rowIndex, e)  {
                //alert('你单击了' + rowIndex);
            }

  
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	REC.push(obj);
}

  
function FindSPLIST() {
	REC = new Array();
	var stdate = Ext.getCmp("mygridstdate");
	var enddate = Ext.getCmp("mygridenddate");  
	if ((stdate.value=="")||(enddate.value=="")) return;
	var parr =EpisodeID+"^"+stdate.value+"^"+enddate.value+"^DHCNURANHUI25^"+session['LOGON.CTLOCID']
	var GetQueryData = document.getElementById('GetQueryData');
  var grid = Ext.getCmp("mygrid");
  var a = cspRunServerMethod(GetQueryData.value, "web.DHCMGtestpge:DHCNURGDQuery", "Parr$" + parr, "AddRec");
  grid.store.loadData(REC);
}


function newfourdan() {
	//alert("11");	
	myId = "";
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNURANHUI25", EpisodeID, "");
  arr = eval(a);
  	var window = new Ext.Window({
				id: 'gform1',				
				title : '管道滑脱上报',
				width : 800,
				height : 650,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [ {
							text : '保存',
							handler : function() {
								Save(window);
								window.close(); 
								FindSPLIST();
							}
						},{
							text : '关闭',
							handler : function() {
								window.close();
							}
						}]
			});
    var mydate = new Date();
    setvalue();   
  PatScorevalue(); 
   
  var butSave=Ext.getCmp("butSave");
  butSave.hide(); 
  var butPrint=Ext.getCmp("butPrint");
  butPrint.hide();
  
  window.show(); 
}

function Save(window)
{
  ret="";
  checkret="";
  comboret=""; 
  id="";
  var SaveRec=document.getElementById('Save'); 
  var getid=document.getElementById("GetId");  
  EmrCode="DHCNURANHUI25";  
  //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
  var gform=Ext.getCmp("gform1");
  //alert(gform);  
  gform.items.each(eachItem2, this);  
  //alert(EmrCode)
  ret+"&"+checkret+"&"+comboret;
  //alert(checkret); 
  //alert(id); 
 if (id==""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 Ext.Msg.alert('提示', "已保存!");
 return;
}
else
{
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,id);
  if (Id!=="")
		{
        Ext.Msg.alert('提示', "已保存!");
        return;
    }
    else 
    {
        Ext.Msg.alert('提示', "保存失败!");
        return;
	  }  
 }
 //alert(NurRecId);

}


function scoregroup (obj)
{ 
	sum=0; 
 	var gform = Ext.getCmp("gform1");
  gform.items.each(eachItem2,this); 
  //alert(checkret);
  var a1=checkret.split('^');
  var arrayobj=new Array();
  sum=0;
  for(i=0;i<a1.length-1;i++)
  {
   var a2=a1[i].split('|');
   var a3=a2[1]; 
   var a7=0;
   //alert(a3);   
   if (a3.indexOf("分")!="-1")
   {
     var a4=a3.split('(');
     var a5=a4[1];
     var a6=a5.split('分');
     a7=parseInt(a6[0]);   
   } 
   sum=sum+a7; 
  } 
  //var Item39value=Ext.getCmp("Item39").getValue(); 
  //if (Item39value!="")
  //{
  //  sum=sum+parseInt(scoreFormat2(Item39value)); 
  //}
  //alert(Item39value); 
  //sum=sum+parseInt(scoreFormat2(Item39value)); 	 
  var sumscore = Ext.getCmp("Item13"); 
	CheckScore=sum;
	sumscore.setValue(sum+RadioScore);  
	checkret=""  
}

function scoreFormat2(value)
{
 var scorearry1=new Array(); 
 scorearry1=value.split("(");
 value= scorearry1[1];   	
 scorearry1=value.split("分");
 return value;
}
   
function PatScorevalue() 
{  
	  var Item2 = Ext.getCmp("Item15"); 
    Item2.on('specialkey',cmbkey); 
    var Item3 = Ext.getCmp("Item28"); 
    Item3.on('specialkey',cmbkey);
    var Item19 = Ext.getCmp("Item19"); 
    Item19.on('specialkey',cmbkey);
    var Item1 = Ext.getCmp("Item18"); 
    Item1.on('specialkey',cmbkey4);

	   
	  var Item8=Ext.getCmp("Item8"); 
    Item8.items.each(eachItem2,this); 
    var Item9=Ext.getCmp("Item9"); 
    Item9.items.each(eachItem2,this); 
    var Item10=Ext.getCmp("Item10"); 
    Item10.items.each(eachItem2,this);
 
   scoregroup2("Item11",4);
  
} 

function scoregroup2(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 var score1 = Ext.getCmp(Itemstr+"_"+count);
   score1.on('check',scoreAdd,this);
  }
}

 
function scoreAdd3(obj)
{ 
  var gform = Ext.getCmp("gform1");
  gform.items.each(eachItem1,this);
  var a1=checkret.split('^');
  var arrayobj=new Array();
  sum=0;
  for(i=0;i<a1.length-1;i++)
  {
   var a2=a1[i].split('|');
   var a3=a2[1]; 
   var a7=0;
   if (a3.indexOf("分")!="-1")
   {
     var a4=a3.split('(');
     var a5=a4[1];
     var a6=a5.split('分');
     a7=parseInt(a6[0]);   
   } 
   sum=sum+a7; 
  } 
  var Item39value=Ext.getCmp("Item39").getValue(); 
  if (Item39value!="")
  {
    sum=sum+parseInt(scoreFormat2(Item39value)); 
  }
	var sumscore = Ext.getCmp("Item40"); 
	sumscore.setValue(sum);
	checkret="" 
} 

function GetItemHashScore()
{
	GetScoreGroup("Item11",4);
} 

function GetScoreGroup(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 var scoreobj = Ext.getCmp(Itemstr+"_"+count);
	 var scoreflag=scoreobj.getValue();
	 if (scoreflag==true)
	 {
	   var scoreid=scoreobj.getId();  
	   var scorefen=scoreobj.boxLabel;
	   ha.add(Itemstr,scoreFormat(scorefen));
	  }
  }
}


function scoreAdd(obj)
{ 
	var flag=obj.getValue();
	var HJScore = Ext.getCmp("Item13"); 
  GetItemHashScore();
  if (flag==true)
	{
	 var scoreid=obj.getId();  
	 var scorefen=obj.boxLabel; 
	 if (scoreid.indexOf("Item11")!="-1")
   { 
    	ha.remove("Item11"); 
		  ha.add("Item11",scoreFormat(scorefen));
   }
   if (ha.items("Item11")!="")
   { 
    	RadioScore = parseInt(ha.items("Item11")) ;
   }  
  }
  HJScore.setValue(RadioScore+CheckScore);
} 

function scoreAdd1(obj)
{
	 //var scorearry1=new Array(); 
	 var scorehj1=0;
	 var tmp=obj.getValue();
	 tmp=scoreFormat(tmp);
 
	 if (tmp==null)
	 {  
	    tmp="0";	
	 	
   }	 
	 switch (obj.getName()) 
	 {
	 	case 'Item21': 
           scorehj1=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item22").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item23").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item24").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item25").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item26").getValue()));
           break; 
   	case 'Item22': 
           scorehj1=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item21").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item23").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item24").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item25").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item26").getValue()));
           break; 
    case 'Item23': 
           scorehj1=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item21").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item22").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item24").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item25").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item26").getValue()));
           break;
	  case 'Item24': 
           scorehj1=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item21").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item22").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item23").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item25").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item26").getValue()));
           break; 
    case 'Item25': 
           scorehj1=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item21").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item22").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item23").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item24").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item26").getValue()));
           break; 
    case 'Item26': 
           scorehj1=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item21").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item22").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item23").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item24").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item25").getValue()));
           break;
	 } 
	 var amtsum1 = Ext.getCmp("Item27"); 
	 amtsum1.setValue(scorehj1);
	 if(scorehj1<=17)
	 {
	 	Ext.Msg.alert('提示', "评分<=17分,请转至压疮高危患者追踪记录单,每周定期评估!");
	 	}
	 }

function scoreAdd2(obj)
{
	 //var scorearry1=new Array(); 
	 var scorehj2=0;
	 var tmp=obj.getValue();
	 tmp=scoreFormat(tmp);
 
	 if (tmp==null)
	 {  
	    tmp="0";	
	 	
   }	 
	 switch (obj.getName()) 
	 {
	 	case 'Item28': 
           scorehj2=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item29").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item60").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item30").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item31").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item32").getValue()));
           break; 
   	case 'Item29': 
           scorehj2=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item28").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item60").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item30").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item31").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item32").getValue()));
           break; 
    case 'Item60': 
           scorehj2=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item28").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item29").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item30").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item31").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item32").getValue()));
           break;
   case 'Item30': 
           scorehj2=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item28").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item29").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item31").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item60").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item32").getValue()));
           break; 
	  case 'Item31': 
           scorehj2=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item28").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item29").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item30").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item60").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item32").getValue()));
           break; 
    case 'Item32': 
           scorehj2=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item28").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item29").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item30").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item60").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item31").getValue()));
           break; 
	 } 
	 var amtsum2 = Ext.getCmp("Item34"); 
	 amtsum2.setValue(scorehj2);
	 if(scorehj2>=45)
	 {
	 	Ext.Msg.alert('提示', "评分>45分,请转至跌倒坠床高危患者追踪记录单,每周定期评估!"); return;
	 	} 
}


function scoreFormat(value)
{
	if (value.indexOf("(")!="-1")
  {
  	var scorearry=new Array();
  	scorearry=value.split("(");
  	value=scorearry[1];  
  	scorearry=value.split("分");
    value=scorearry[0]; 
  }
  return value;
}

function setVal2(itm,val)
{
	    if (val=="") return ;
	   	var tt=val.split('!');
		//alert(tt);
	 	var cm=Ext.getCmp(itm);
		person=new Array();
		addperson(tt[1],tt[0]);
		cm.store.loadData(person);
		cm.setValue(tt[0]);
		 
}  
  
function cmbkey(field, e)
{
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		getlistdata(pp,field);
	//	alert(ret);
		
	}
}
var person=new Array();
function getlistdata(p,cmb)
{
	var GetPerson =document.getElementById('GetPerson');
	//debugger;
    var ret=cspRunServerMethod(GetPerson.value,p);
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addperson(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}
function addperson(a,b)
{
	person.push(
	{
		desc:a,
		id:b
	}
	);
}


function setvalue()
{
  var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
    
    if (id != "") {
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, id);
   	var tm = ret.split('^')
    //alert(tm);
		sethashvalue(ha, tm);
				
			}
			else {
				getPatInfo();
				return;
				} 
		 var gform=Ext.getCmp("gform");
     gform.items.each(eachItem, this);  
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) 
		{
			//alert(key);
			var flag=ifflag(key );
			if (flag==true)
			{
				if (ha.contains(key)) setVal2(key ,ha.items(key));
				//debugger;
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			itm.setValue(getval(ha.items(key)));
			
	    }else{
			var aa=key.split('_');
			if(ha.contains(aa[0]))
			{
			  setcheckvalue(key,ha.items(aa[0]));
			}
		}
    }

 }
  
function getPatInfo()
{
  //return ;
	var PatInfo=document.getElementById('PatInfo');
	if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
		//alert(ret);
	 	var tt=ret.split('^');
	 	var patName = Ext.getCmp("Item3");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item4");
	 	sex.setValue(getValueByCode(tt[3]));
	 	var  regno= Ext.getCmp("Item6");
	 	regno.setValue(getValueByCode(tt[0]));
	 	var age = Ext.getCmp("Item5");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.setValue(getValueByCode(tt[5])); 
	 	
    var myDate=new Date();
	 	var Month=myDate.getMonth()+1;
	 	var MDate=myDate.getDate();
	 	if ((((myDate.getDate()).toString()).length)==1)  //修改日期日头格式
	 	{
	 		var MDate="0"+(myDate.getDate()).toString();
	 	}
	 	if ((((myDate.getMonth()+1).toString()).length)==1)  //修改日期月份格式
	 	{
	 		var Month="0"+(myDate.getMonth()+1).toString();
	 	}
	 	var nowDate=myDate.getYear()+"-"+Month+"-"+MDate;
	 	
	 	var PJDate = Ext.getCmp("Item27");   //填报日期 
	 	var FSDate = Ext.getCmp("Item17");   //填报日期
    FSDate.setValue(nowDate);
    PJDate.setValue(nowDate);
	 		}
}

function getValueByCode(tempStr)
{
	var retStr=tempStr;
	var strArr = tempStr.split("|");
	if (strArr.length>1) 
	{
		retStr=strArr[1];
	}
	return retStr;
}
 
var onedoc=new Array();
function getlistdata4(p,cmb)
{
	var GetPerson =document.getElementById('GetDBPerson');
	//debugger;
    var ret=cspRunServerMethod(GetPerson.value,p);
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addonedoc(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(onedoc);
	}
}

function addonedoc(a,b)
{
	onedoc.push(
	{
		desc:a,
		id:b
	}
	);
}


function cmbkey4(field, e)
{
	
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		getlistdata4(pp,field);
	//	alert(ret);
		
	}
} 
