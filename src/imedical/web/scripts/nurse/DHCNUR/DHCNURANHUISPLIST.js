/**
 * @author oudejun
 */ 
     
var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();

function eachItem1(item,index,length) {   
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
    
   
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
				//debugger;      
       //alert(item.xtype);        
       if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";
       else {checkret=checkret+item.id+"|"+""+"^";}
       item.on('check',scoregroup,this)  
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
} 

function rowdblclickFn(grid, rowIndex, e) { 
    selections = grid.getSelectionModel().getSelections();
    var arr = new Array();
    EpisodeID=grid.store.getAt(rowIndex).get(grid.getColumnModel().getDataIndex(6));
    RowId=grid.store.getAt(rowIndex).get(grid.getColumnModel().getDataIndex(7));
    var lnk= "dhcnuremrcomm.csp?"+"&EmrCode=DHCNURANHUI21"+"&EpisodeID="+EpisodeID+"&DHCMoudDataRowId="+RowId;  
    //var StartDate = formatDate(Ext.getCmp("mygridstdate").getValue()); 
    //var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue()); 
    //var lnk= "dhcnuremrcomm.csp?"+"&EmrCode=DHCNURANHUI21;
    window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=860,height=700');
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
		//var EpisodeID = objRow[0].get("EpisodeID");
		
		//alert(EpisodeID)
		
	  //alert(EpisodeID)
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURANHUI21&EpisodeID="+EpisodeID+"&NurRecId="+par ;//"&DtId="+DtId+"&ExamId="+ExamId
	  var widthValue=1000;
	var heightValue=900;
	if(heightValue>(window.screen.height-100)) heightValue=window.screen.height-100;
	if(widthValue>(window.screen.width-15)) widthValue=window.screen.width-15;
	var topValue=(window.screen.height-heightValue-100)/2;
	var leftValue=(window.screen.width-widthValue-15)/2;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,top='+topValue+',left='+leftValue+',width='+widthValue+',height='+heightValue);
	//window.open(lnk,"htm","'"+"toolbar=no,location=no,directories=no,resizable=yes,top="+topValue+",left="+leftValue+",width=1000,height="+THeight+"'");


	}

}
function BodyLoadHandler() {
	  setsize("mygridpl", "gform", "mygrid");
    var grid = Ext.getCmp("mygrid");
    var but = Ext.getCmp("mygridbut1");
    but.on('click', newEvent);  
    var but2 = Ext.getCmp("mygridbut2");
    but2.hide();
     
    grid.addListener('rowclick', rowClickFn);
    grid.addListener('rowdblclick', modccevent); 
    grid.addListener('rowcontextmenu', rightClickFn);

    
    var tobar = grid.getTopToolbar();
	grid.getBottomToolbar().hide()

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
    tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
	tobar.addItem("-");
		 tobar.addButton({
				text : "查询",
				handler : FindSPLIST,
				id : 'butFind'
			}); 
	 tobar.addButton({
		//className: 'new-topic-button',
		text: "作废",
		handler: CancelRecord,
		id: 'Cancel'
	});
	 tobar.addItem ("-")
		tobar.addButton({
		className: 'new-topic-button',
		text: "打印",
		handler: butPrintFn,
		id: 'butPrintFn'
	});	
	 	tobar.doLayout();
	  FindSPLIST(); 
 }  
 function butPrintFnold()
{
    var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();	
	var len = rowObj.length;
	if (len < 1) {
		alert("请选择需要打印的数据!")
		return;
	} else {
	id = rowObj[0].get("par")
	}
	if(id)
	{
			PrintComm.WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNurPrnMouldANHUI22";
			var subid=id
			PrintComm.MthArr="Nur.DHCMoudData:getVal&parr:"+subid+"!";
			PrintComm.PrintOut();	
		}
}
function butPrintFn()
{
    var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();	
	var len = rowObj.length;
	if (len < 1) {
		alert("请选择需要打印的数据!")
		return;
	} else {
	id = rowObj[0].get("par")
	}
	if(id)
	{
		
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp","DHCNURANHUI21","N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic","DHCNURANHUI21","N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic","DHCNURANHUI21","N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload","DHCNURANHUI21","N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages","DHCNURANHUI21","N");
		var WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
		var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId","DHCNURANHUI21",EpisodeID);
		if(NurRecId!=="") GetPGDId=NurRecId;
		var parr="@"+EpisodeID+"@"+"DHCNURANHUI21";
		var EmrType=3;  //1:混合单 2：记录单 3：评估单
		//var MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
		var MthArr="Nur.DHCMoudData:getVal$parr:"+id+"!";	
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+"DHCNURANHUI21"+"&EmrType="+EmrType+"&ItmName="+"DHCNurPrnMouldANHUI22"+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
		window.location.href=link;	
		}
}
function diffDate(val,addday){
	var year=val.getFullYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function CancelRecord()
{
	var grid=Ext.getCmp('mygrid');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条护理记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要作废此条记录吗!")
		if (flag) 
		{
			        var par=objRow[0].get("par");
					var a = tkMakeServerCall("web.DHCNurseRecordComm","CancelMoudRecord", par, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
					if (a!=0){
						alert(a);
						return;
					}else
					{
						FindSPLIST();
					}
		}
		
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
	//alert(str)
	arrgrid.push(obj);
	//debugger;
}


  
function FindSPLIST() {
	
  //var a = cspRunServerMethod(GetQueryData.value, "web.DHCMGtestpge:DHCNURSPQuery", "Parr$" + parr, "AddRec");
  //grid.store.loadData(REC);
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	arrgrid = new Array();
    MeasureRel = new Hashtable();
	var adm = EpisodeID;
	var loc=session['LOGON.CTLOCID'];
 	var IfCncelRec=Ext.getCmp("IfCancelRec").getValue();
	//var parr = "DHCNURANHUI21^"+adm+"^"+loc+"^"+StDate.value+"^"+Enddate.value;
	//alert(parr)
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurblsjflwh:MoudData2", "parr$" +parr,"AddRec");
    //mygrid.store.loadData(arrgrid);  
    var parr = "DHCNURANHUI21^"+adm+"^"+loc+"^"+"^"+"^"+IfCncelRec;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurblsjflwh:MoudDatabyadm", "parr$" +parr,"AddRec");
	//alert(a);	
    mygrid.store.loadData(arrgrid);   
}


var logonht=1;
var THeight=window.screen.height-100;     
function newEvent()
{
	// var CurrAdm=selections[rowIndex].get("Adm");
	//if (DtId=="")return;
	//var getcurExamId=document.getElementById('getcurExamId');
	//var ExamId=cspRunServerMethod(getcurExamId.value,SpId);
    // alert(ExamId);
	//alert(logonht)
	//alert(EpisodeID)
	
    if (logonht==1)
	{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURANHUI21&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	}
	
	if (logonht==0)
	{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURANHUI21&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	}
	//var topValue=(window.screen.height-THeight)/6;
	//var leftValue=(window.screen.width-1000)/2;
	var widthValue=1000;
	var heightValue=900;
	if(heightValue>(window.screen.height-100)) heightValue=window.screen.height-100;
	if(widthValue>(window.screen.width-15)) widthValue=window.screen.width-15;
	var topValue=(window.screen.height-heightValue-100)/2;
	var leftValue=(window.screen.width-widthValue-15)/2;
	window.open(lnk, "htm", 'toolbar=no,location=no,directories=no,resizable=yes,top='+topValue+',left='+leftValue+',width='+widthValue+',height='+heightValue);
	//window.open(lnk,"htm","'"+"toolbar=no,location=no,directories=no,resizable=yes,top="+topValue+",left="+leftValue+",width=1000,height="+THeight+"'");



}

function newfourdan() {
	//alert("11");	
	myId = "";
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNURANHUI21", EpisodeID, "");
  arr = eval(a);
  	var window = new Ext.Window({
				id: 'gform1',				
				title : '四评单',
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
  var Item2 = Ext.getCmp("Item42");
	Item2.on('specialkey',cmbkey); 
   
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
  EmrCode="DHCNURANHUI21";  
  //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
  var gform=Ext.getCmp("gform1");
  //alert(gform);  
  gform.items.each(eachItem1, this);  
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

function reloadtree(Code)
{
	window.parent.reloadtree2(Code,"多次");
}
function scoregroup (obj)
{
  /*checkret =""; 
  var sumscore = Ext.getCmp("Item40");
  var sum=sumscore.getValue();
  if (sum=="")  
  {
  	sum=0;
  }
  else
  {
    sum=parseInt(sum);
  }
   //if (obj.checked==true) checkret=checkret+obj.id+"|"+obj.boxLabel+"^";
  if (obj.checked==true)
  {     	    	
   	 value=scoreFormat2(obj.boxLabel);   	
   	 sum=sum+parseInt(value);   
  }
  else
  { 
     value=scoreFormat2(obj.boxLabel);    	 
     sum=sum-parseInt(value);
   } */
 	sum=0; 
 	//window.items.each(eachItem1,this);

 	var gform = Ext.getCmp("gform1"); 
 	//alert(window);  
 	gform.items.each(eachItem1,this);
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
  var Item39value=Ext.getCmp("Item39").getValue(); 
  if (Item39value!="")
  {
    sum=sum+parseInt(scoreFormat2(Item39value)); 
  }
  //alert(Item39value); 
  //sum=sum+parseInt(scoreFormat2(Item39value)); 	 
  //alert(sum);  
  var sumscore = Ext.getCmp("Item40"); 
	sumscore.setValue(sum);  
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
	var score1 = Ext.getCmp("Item43"); 
	score1.on('change',scoreAdd,this); 
  var score1 = Ext.getCmp("Item44"); 
	score1.on('change',scoreAdd,this); 
	var score1 = Ext.getCmp("Item45"); 
	score1.on('change',scoreAdd,this); 
	var score1 = Ext.getCmp("Item46"); 
	score1.on('change',scoreAdd,this); 
	var score1 = Ext.getCmp("Item47"); 
	score1.on('change',scoreAdd,this); 
	var score1 = Ext.getCmp("Item48"); 
	score1.on('change',scoreAdd,this);
 	var score1 = Ext.getCmp("Item49"); 
	score1.on('change',scoreAdd,this);
 	var score1 = Ext.getCmp("Item50"); 
	score1.on('change',scoreAdd,this);
  var score1 = Ext.getCmp("Item51"); 
	score1.on('change',scoreAdd,this);
  var score1 = Ext.getCmp("Item52"); 
	score1.on('change',scoreAdd,this);

	var score1 = Ext.getCmp("Item21");
	score1.on('change',scoreAdd1,this);
  var score1 = Ext.getCmp("Item22"); 
	score1.on('change',scoreAdd1,this);
  var score1 = Ext.getCmp("Item23"); 
	score1.on('change',scoreAdd1,this); 
  var score1 = Ext.getCmp("Item24"); 
	score1.on('change',scoreAdd1,this);
  var score1 = Ext.getCmp("Item25"); 
	score1.on('change',scoreAdd1,this);
  var score1 = Ext.getCmp("Item26"); 
	score1.on('change',scoreAdd1,this);

  var score1 = Ext.getCmp("Item28");
	score1.on('change',scoreAdd2,this);
  var score1 = Ext.getCmp("Item29"); 
	score1.on('change',scoreAdd2,this);
  var score1 = Ext.getCmp("Item60"); 
	score1.on('change',scoreAdd2,this); 
  var score1 = Ext.getCmp("Item30"); 
	score1.on('change',scoreAdd2,this);
  var score1 = Ext.getCmp("Item31"); 
	score1.on('change',scoreAdd2,this);
  var score1 = Ext.getCmp("Item32"); 
	score1.on('change',scoreAdd2,this);  
	
	//var scoregroup=Ext.getCmp("Item35_1");  
	//scoregroup.on('change',scoregroup);
  
   var Item35=Ext.getCmp("Item35"); 
   Item35.items.each(eachItem1,this); 
   var Item36=Ext.getCmp("Item36"); 
   Item36.items.each(eachItem1,this); 
   var Item37=Ext.getCmp("Item37"); 
   Item37.items.each(eachItem1,this); 
    //var gform=Ext.getCmp("gform"); 
    //gform.items.each(eachItem1,this); 


   var score1 = Ext.getCmp("Item39"); 
	 score1.on('change',scoreAdd3,this);  
	 
   //scoregroup.items.each(eachItem1,this);
   //var gform=Ext.getCmp("gform");
   //gform.items.each(eachItem1,this);

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

function scoreAdd(obj)
{
	 //var scorearry1=new Array(); 
	 var scorehj=0; 
	 var tmp=obj.getValue();
	 tmp=scoreFormat(tmp);
 
	 if (tmp==null)
	 {  
	    tmp="0";	
	 	
   }	 
	 switch (obj.getName()) 
	 {
	 	case 'Item43': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break; 
    case 'Item44': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break;
    case 'Item45': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break;
    case 'Item46': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break;
    case 'Item47': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break;
    case 'Item48': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break; 
    case 'Item49': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break; 
    case 'Item50': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break; 
    case 'Item51': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item52").getValue()));
           break; 
    case 'Item52': 
           scorehj=parseInt(tmp)+parseInt(scoreFormat(Ext.getCmp("Item44").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item45").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item46").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item47").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item48").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item49").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item50").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item51").getValue()))+parseInt(scoreFormat(Ext.getCmp("Item43").getValue()));
           break; 
	 } 
	 var amtsum = Ext.getCmp("Item53"); 
	 //tmp=parseInt(tmp)+parseInt(amtsum.getValue())	 
	 amtsum.setValue(scorehj);  
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
if (value.indexOf("分")!="-1")
{ 
 var scorearry1=new Array(); 
 scorearry1=value.split("(分");
 value=scorearry1[0]; 
  if (value.indexOf("  ")!="-1")
  { 
   scorearry1=value.split("  ");
   value=scorearry1[1]; 
  }  
 if (value==null)
 {
  value="0";
 }
}
else
{
	if (value=="") value="0";
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
	//alert(ExamId);
   var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);
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
				//var PatInfo = document.getElementById('PatInfo');
				//if (PatInfo) {
				//alert(12);
					//var ret = cspRunServerMethod(PatInfo.value, EpisodeID, EmrCode);
					//var tm = ret.split('^')
					//sethashvalue(ha, tm)
				}
			
	// debugger;
    	
  
    
	 var gform=Ext.getCmp("gform");
     gform.items.each(eachItem, this);  
	 //  alert(a);
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
	 	var patName = Ext.getCmp("Item1");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item2");
	 	sex.setValue(getValueByCode(tt[3]));
	 	var  regno= Ext.getCmp("Item6");
	 	regno.setValue(getValueByCode(tt[0]));
	 	//var age = Ext.getCmp("Item3");
	 	//age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item4");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item5");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	//var diag = Ext.getCmp("Item18");
	 	//diag.setValue(getValueByCode(tt[8]));
	 	//var admdate = Ext.getCmp("Item13");
	 	//admdate.setValue(getValueByCode(tt[10]));
	 	//var admtime = Ext.getCmp("Item14");
	 	//admtime.setValue(getValueByCode(tt[11]));
		//alert("dd");
	 	//var MedCareNo = Ext.getCmp("Item411");
	 	//MedCareNo.setValue(getValueByCode(tt[9])); 
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
    var ReportDate = Ext.getCmp("Item41");  //填表日期
	 	ReportDate.setValue(nowDate);
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
