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
			fieldLabel : '标准模板',
			store : storenurse,
			width : 250,
      ///fieldLabel : '区',
			valueField : 'id',
			triggerAction: "all",
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

//关联护理模板
var arrayhlcode= new Array();
function addhlcode(a, b) {
	 arrayhlcode.push({
				idv : a,
				desc : b
			});
		}
var hlcodeStore = new Ext.data.JsonStore({
			data :arrayhlcode,
			fields : ['idv', 'desc']			
		});
var hlcode = new Ext.form.ComboBox({
			id : 'hlcode',
			store : hlcodeStore,
			width : 200,
			fieldLabel : '关联护理模板',
			valueField : 'idv',
			triggerAction: "all",
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
	if (len < 1) 
	{
		 //Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons:
		// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	} 
	else 
	{
		myId = rowObj[0].get("par");
	}
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNURPL_LINK", EpisodeID, "");   
    arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		if(arr[i].name=='LinkItemCode')
		{
			combo.x=arr[i].x
			combo.y=arr[i].y
			combo.width=arr[i].width
			arr[i]=combo;
			//alert(arr[i].width)
			//alert(arr[i].x)
		}
		
	}
   window1 = new Ext.Window({
				title : '质控维护',
				width : 500,
				height : 250,
					x:300,
				y:200,
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
								additm(window);
								window1.close();
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
var haval = new Hashtable(); //签名hashitable
function setvalue()
{   
	var getstr=tkMakeServerCall("Nur.DHCNurLinkAss","getVal",myId)
	var zkstr=getstr.split('^')
	haval = new Hashtable(); //签名hashitable
	sethashvalue(haval,zkstr);		
	var SJNameobj = Ext.getCmp("BZCode"); //模板
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		tkMakeServerCall("Nur.DHCNurLinkCode","GetLinkCode","addmain")
		SJNameobj.store.loadData(arraymain);
		SJNameobj.setValue(haval.items("EmrCode"))
		SJNameobj.on('select', findlinkitm);
		SJNameobj.disable()
	}
    var SJNameobj = Ext.getCmp("gd"); //戈登分类
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		tkMakeServerCall("Nur.DHCNurGordon","GetItmList","addmain")
		SJNameobj.store.loadData(arraymain);
		SJNameobj.on('select', findlink);
		SJNameobj.setValue(haval.items("AssCat"))
		arraysub = new Array();	
	    tkMakeServerCall("Nur.DHCNurAssess","GetASSItmList",haval.items("GDCode"),"addsub") //护理模板元素
	    var LinkItemCodeobj = Ext.getCmp("ItemName");
	    LinkItemCodeobj.store.loadData(arraysub);
	    LinkItemCodeobj.setValue(haval.items("AssId"));
	}
	arraysub = new Array();	
	tkMakeServerCall("NurEmr.BLSJSBInterface","GetCodeList",haval.items("EmrCode"),"",haval.items("EmrCode"),"addsub") //护理模板元素
	var LinkItemCodeobj = Ext.getCmp("LinkItemCode");
	LinkItemCodeobj.store.loadData(arraysub);	
	LinkItemCodeobj.setValue(haval.items("ItemCode"));
    LinkItemCodeobj.valueId=haval.items("ItemCode")
	checkselect("LinkItemCode",haval.items("ItemCode")) 
	LinkItemCodeobj.disable()
}

//var getlocward=document.getElementById('getlocward');
//cspRunServerMethod(getlocward.value,"addlocward");
function addlocward(a, b) {
	arrgridnurse.push({
				id : a,
				desc : b
			});
}
//patward.store.loadData(arrgridnurse);
function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout(); 
	//alert(EmrCode)

	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', newEvent);
	but1.setText("模板关联")
	but1.hide();
	//but1.setTitle("关联元素")
	var but = Ext.getCmp("mygridbut2");
	but.on('click', BTLINK);
	but.setText("表头选项关联")
	but.hide()
	//but.hide();
 
	var grid = Ext.getCmp('mygrid');
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
			if(grid.getColumnModel().getDataIndex(i) == 'par'){
				grid.getColumnModel().setHidden(i,true);
			}
	}
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem("-"); 
		tobar.addButton({
			className : 'new-topic-button',
			text : "模板关联",
			icon:'../images/uiimages/link-big.png',
			handler : newEvent,
			id : 'sourcesddd'
		});
		tobar.addItem("-"); 
		tobar.addButton({
			className : 'new-topic-button',
			text : "表头选项关联",
			icon:'../images/uiimages/reciprocity.png',
			handler : BTLINK,
			id : 'source2333'
		});
	tobar.addItem("-"); 
		tobar.addButton({
			className : 'new-topic-button',
			text : "模板维护",
			icon:'../images/uiimages/schedulesets.png',
			handler : source,
			id : 'source'
		});
	grid.on('rowdblclick',ModeList);
	tobar.addItem("-"); 
	tobar.addButton({
		className: 'new-topic-button',
		text: "戈登分类维护",
		icon:'../images/uiimages/pencil.png',
		handler: Main,
		id: 'mygridSchsjbz'
	});
	tobar.addItem("-"); 
	tobar.addButton({
		className: 'new-topic-button',
		text: "标准项目维护",
		icon:'../images/uiimages/register.png',
		handler: BZITEM,
		id: 'mygridSchsjDDDDDD'
	});
	tobar.addItem("-"); 
	tobar.addButton({
		className: 'new-topic-button',
		text: "护理诊断或疾病类型维护",
		handler: MainWH,
		icon:'../images/uiimages/RegNO.png',
		id: 'mygridSchsj'
	});
	tobar.addItem("-"); 
	tobar.addButton({
		className: 'new-topic-button',
		text: "护理结局维护",
		icon:'../images/uiimages/updatediag.png',
		handler: ItmWH,
		id: 'mygridSchITM'
	});
	tobar.addItem("-"); 
	tobar.addButton({
		className: 'new-topic-button',
		text: "护理措施维护",
		handler: ItmWHLink,
		icon:'../images/uiimages/updateinfo.png',
		id: 'mygridSchITMLink'
	});	
	tobar.addItem("-"); 	

  var tbar2=new Ext.Toolbar({	});	
  tbar2.addItem('模板',
		patward,'-');
  //tbar2.addItem('关联护理模板',hlcode)
	tbar2.addButton({
		className: 'new-topic-button',
		text: "查询",
		icon:'../images/uiimages/search.png',
		handler: find,
		id: 'mygridSch'
	});
  tbar2.addItem("-");
	tbar2.addButton({
		className: 'new-topic-button',
		text: "删除",
		icon:'../images/uiimages/edit_remove.png',
		handler: qddelete,
		id: 'delete'
	});
 tbar2.addItem("-"); 
	 tbar2.render(grid.tbar);  
    var bbar = grid.getBottomToolbar ();
	  bbar.hide();
	  var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
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
	dep.setValue(rowObj[0].get("SJCode"));
        var LinkHLCodeobj = Ext.getCmp("hlcode")
	    arrayhlcode = new Array();
	    tkMakeServerCall("NurEmr.EmrCodeLinkDic","GetLinkCode",rowObj[0].get("SJCode"),"addhlcode")
	    LinkHLCodeobj.store.loadData(arrayhlcode);
	    var hlcodeval=rowObj[0].get("LinkCode")

	    LinkHLCodeobj.setValue(hlcodeval);
	    //find()
	}}
   );
    var hlcodeobj = Ext.getCmp("hlcode");
    hlcodeobj.on('select',find)
    var maincode = Ext.getCmp("patward");
    arraymain = new Array();
	tkMakeServerCall("Nur.DHCNurLinkCode","GetLinkCode","addmain")
	maincode.store.loadData(arraymain);
	maincode.on('select', function(){      
	    find()
		});
 
    var bbar = grid.getBottomToolbar ();
	 // bbar.hide();
  //find();
//alert();
//debugger;
}
function zxquery()
{  
      var bzcode = Ext.getCmp("patward").getValue();	 
	  var param1 = Ext.getCmp("ADM").getValue(); //参数一
	  var param2 = Ext.getCmp("ID").getValue();
	  var param3 = bzcode
	  var param4 = ""
	  var param5 = Ext.getCmp("Colsplit").getValue(); //数据项
	  var param6 = Ext.getCmp("Keysplit").getValue();
	  //var itmid = Ext.getCmp("SourceText").getValue();
	   if ((param1==""))
	  {
	  	alert("Adm不能为空！")
	  	return
	  }	 
	  if ((bzcode==""))
	  {
	  	alert("标准模板不能为空！")
	  	return
	  }	 
	   if ((param5=="&")||(param6=="&"))
	  {
	  	alert("注意：在此处测试时分隔符不能包含&，直接调用方法时参数可以有&")
	  	return;
	  }
	 var arrname="NurEmr.DataSourceMethod:GetNurBGData"
	  var arrname=arrname.split(':')
	 var clsName=arrname[0]
	 var methodName=arrname[1]
	 var field1 = {};
	 var parr=param1+"!"+param2+"!"+param3+"!"+param4+"!"+param5+"!"+param6
     field1['parameter1'] = parr;
     //field1['parameter2'] = param2;
     //field1['parameter3'] = param3;
     //field1['parameter4'] = param4;
     //field1['parameter5'] = param5;
     //alert(Ext.encode(field1))
     var parameters=Ext.encode(field1)
	 var lnk=WebIp+"/dthealth/web/DWR.NurseEmrComm.cls?soap_method=Excute&clsName="+clsName+"&methodName="+methodName+"&parameters="+parameters
	 //alert(lnk)
	 var windtest=window.open(lnk,"htmtest",'left=20,top=10,toolbar=no,location=no,directories=no,resizable=yes,width=1200,height=600');
}
function zxmethod()
{       
	  var bzcode = Ext.getCmp("patward").getValue();	 
	  var param1 = Ext.getCmp("ADM").getValue(); //参数一
	  var param2 = Ext.getCmp("ID").getValue();
	  var param3 = Ext.getCmp("patward").getValue();
	  var param4=""	
	  var param5 = Ext.getCmp("Rowsplit").getValue();
	  var param6 = Ext.getCmp("Colsplit").getValue(); //数据项
	  var param7 = Ext.getCmp("Keysplit").getValue();
	  //var itmid = Ext.getCmp("SourceText").getValue();
	  if ((bzcode==""))
	  {
	  	alert("标准模板不能为空！")
	  	return
	  }	 
	  if ((param1==""))
	  {
	  	alert("Adm不能为空！")
	  	return
	  }	 
	  if ((param5=="&")||(param6=="&")||(param7=="&"))
	  {
	  	alert("注意：在此处测试时分隔符不能包含&，直接调用方法时参数可以有&")
	  	return;
	  }
	 var arrname="NurEmr.DataSourceMethod:GetHLBLData"
	 var arrname=arrname.split(':')
	 var clsName=arrname[0]
	 var methodName=arrname[1]
	 var field1 = {};
	 //var parr=param1+"!"+param2+"!"+param3+"!"+param4+"!"+param5
     field1['parameter1'] = param1;
     field1['parameter2'] = param2;
     field1['parameter3'] = param3;
     field1['parameter4'] = param4;
     field1['parameter5'] = param5;
     field1['parameter6'] = param6;
     field1['parameter7'] = param7;
     field1['parameter8'] = "false";
     //alert(Ext.encode(field1))
     var parameters=Ext.encode(field1)
	 var lnk=WebIp+"/dthealth/web/DWR.NurseEmrComm.cls?soap_method=Excute&clsName="+clsName+"&methodName="+methodName+"&parameters="+parameters
	 //alert(lnk)
	 var windtest=window.open(lnk,"htmtestmethod",'left=20,top=10,toolbar=no,location=no,directories=no,resizable=yes,width=1200,height=600');
}
//数据源维护
function source()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_BZCODE&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htmsource",'left=10,top=10,toolbar=no,location=no,directories=no,resizable=yes,width=1200,height=700');
}
var fwidth=window.screen.availWidth-10
var fheight=window.screen.availHeight-20
//戈登分类
function Main()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_GDWH&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htmmain",'left=10,top=100,toolbar=no,location=no,directories=no,resizable=no,width=800,height=500');
}

//表头关联
function BTLINK()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_BTLINK&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"BTLINK",'left=10,top=100,toolbar=no,location=no,directories=no,resizable=no,width=800,height=500');
}
//护理诊断维护
function MainWH()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_DIAG&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htmmainlink",'left=1,top=1,toolbar=no,location=no,directories=no,resizable=no,width='+fwidth+',height='+fheight+'');
}
//标准元素维护
function BZITEM()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_BZITEM&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htmmainlink33",'left=10,top=100,toolbar=no,location=no,directories=no,resizable=no,width=1200,height=600');
}
//护理结局维护
	function ItmWH()
{ 
	
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_HLJJ&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 var wind22455=window.open(lnk,"htmyuans",'left=1,top=1,toolbar=no,location=no,directories=no,resizable=no,width='+fwidth+',height='+fheight+'');		
	}
	//护理措施维护
	function ItmWHLink()
{ 
	
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURPL_HLCS&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 var wind22455=window.open(lnk,"htmyuanslinks",'left=1,top=1,toolbar=no,location=no,directories=no,resizable=no,width='+fwidth+',height='+fheight+'');			
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

function modl()
{
	var SJName = Ext.getCmp("BZCode").lastSelectionText;  //标准模板名称
	var SJCode = Ext.getCmp("BZCode").value;  //标准模板ID
	var LinkItemName=Ext.getCmp("LinkItemCode").lastSelectionText; //关联元素名称
	var LinkItemCode = Ext.getCmp("LinkItemCode").valueId; //关联元素code
	var ItemCode = Ext.getCmp("ItemName").value;             //标准元素code
	var ItemName = Ext.getCmp("ItemName").lastSelectionText; //标准元素名称	
      ret=""
			ret = ret + "SJName|" + SJName + "^";
			ret = ret + "SJCode|" + SJCode + "^";
			ret = ret + "ItemCode|" + ItemCode + "^";
			ret = ret + "ItemName|" + ItemName + "^";
			ret = ret + "LinkItemCode|" + LinkItemCode + "^";
			ret = ret + "LinkItemName|" + LinkItemName + "^";
			//alert(ret)
		//	alert(myId)
			tkMakeServerCall("NurEmr.BLSJSBInterface","Save",ret,myId)
		 //根据事件加载元素
	   var ItemNameobj = Ext.getCmp("ItemName")
	   ItemNameobj.setValue("")
	   arraysub = new Array();
		 tkMakeServerCall("NurEmr.BLSJSBInterface","getSubcode",SJCode,"1","addsub")  //筛选
		 ItemNameobj.store.loadData(arraysub);
		 //多选
		 var EmrCode = Ext.getCmp("LinkCode");
	   var sjcode = Ext.getCmp("BZCode").getValue();
	   var getitms = document.getElementById('getitms');
	   locdata3 = new Array();
	   cspRunServerMethod(getitms.value,sjcode,"1","","addloc3");
	   var LinkItemCode = Ext.getCmp("LinkItemCode");   
	   LinkItemCode.store.loadData(locdata3);
	   LinkItemCode.setValue("")
	   window.close
			find()
}
function Save()
{
 	//var EmrCode = Ext.getCmp("EmrCode").value;
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
	            var par = objRow[0].get("par");
	            tkMakeServerCall("Nur.DHCNurLinkAss","QtDelete",par)
	            find()
	            
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
		name:'LinkItemCode',
		id:'LinkItemCode',
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
                selectedlinkitm=""
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                        if (selectedlinkitm=="")
                        {
                           selectedlinkitm=rc.get('id')
                        }else{
                        	 selectedlinkitm=selectedlinkitm+","+rc.get('id')
                        }
                        
                    }                  
                });
                // alert(selectedlinkitm)
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
	//质控关联项
	var onezkitemdesc="";
	var descseqno=0;

var logonht=1;
var x1=0,y1=500;
var x2=0,y2=0;
var x3=0,y3=0;
var x4=0,y4=0;
function newEvent()
{	 
	myId = "";
	var arr = new Array();
	//var DHCNURPL_INT136=new Ext.data.JsonStore({data:[],fields:['ItmName','ItmCode','ItmFlag','par','rw']});
    var a = cspRunServerMethod(pdata1, "", "DHCNURPL_LINK", EpisodeID, "");   
    arr = eval(a);
	for(var i = 0;i<arr.length;i++)
	{
		if(arr[i].name=='LinkItemCode')
		{
			combo.x=arr[i].x
			combo.y=arr[i].y
			combo.width=arr[i].width
			arr[i]=combo;			
		}
	}
	 window1 = new Ext.Window({
				title : '模板关联元素',
				width : 500,
				height : 250,
				x:50,
				y:120,
				autoScroll : true,
				layout : 'absolute',
				// plain: true,
				// modal: true,
				// bodyStyle: 'padding:5px;',
				// /buttonAlign: 'center',
				items : arr,
				buttons : [{
							text : '增加',
							icon:'../images/uiimages/edit_add.png',
							handler : function() {
								additm(window);
								//window.close();
							}
						}, {
							text : '修改',
							icon:'../images/uiimages/pencil.png',
							handler : function() {
								Save(window);
								//window.close();
							}
						}, {
							text : '取消',
							icon:'../images/uiimages/cancel.png',
							handler : function() {
								window1.close();
							}
						}]
			});
	var SJNameobj = Ext.getCmp("BZCode"); //修改
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		tkMakeServerCall("Nur.DHCNurLinkCode","GetLinkCode","addmain")
		SJNameobj.store.loadData(arraymain);
		SJNameobj.on('select', findlinkitm);
	}
    var SJNameobj = Ext.getCmp("gd"); //戈登分类
	if (SJNameobj != null) 
	{	
		arraymain = new Array();
		tkMakeServerCall("Nur.DHCNurGordon","GetItmList","addmain")
		SJNameobj.store.loadData(arraymain);
		SJNameobj.on('select', findlink);
	}
	window1.show();
	var maincodeobj = Ext.getCmp("patward");
	var BZCodeobj = Ext.getCmp("BZCode");
	if (maincodeobj.getValue()!="")
	{
	   BZCodeobj.setValue(maincodeobj.getValue());
    }
}
var myId=""
var selectedbzitm="" //x
var selectedlinkitm="" //guanlian yuan su
function additm()
{
	var EmrNameval = Ext.getCmp("BZCode").lastSelectionText;  //模板名称
	var EmrCodeval = Ext.getCmp("BZCode").value;              //模板ID
	var ItemNameVal=Ext.getCmp("LinkItemCode").lastSelectionText; //元素名称
	var ItemCodeVal = Ext.getCmp("LinkItemCode").valueId;   //元素code
    var AssIdVal = Ext.getCmp("ItemName").getValue() //标准元素表id
    var gdval = Ext.getCmp("gd").getValue() //标准元素表id

	if (ItemNameVal=="")
	{
		alert("标准元素不能为空！")
		 return
	}
	if (EmrCodeval=="")
	{
		 alert("模板不能为空")
		 return		
	}
	if (LinkItemCode=="")
	{
		 alert("元素不能为空")
		 return		
	}
            ret=""
			ret = ret + "EmrName|" + EmrNameval + "^";
			ret = ret + "EmrCode|" + EmrCodeval + "^";
			ret = ret + "ItemName|" + ItemNameVal + "^";
			ret = ret + "ItemCode|"  +ItemCodeVal+ "^";
			ret = ret + "AssId|" + AssIdVal + "^";
			ret = ret + "Cate|" + gdval + "^";
		//alert(ret)
		//	alert(myId)
	   tkMakeServerCall("Nur.DHCNurLinkAss","Save",ret,myId)
	   myId=""
	   find()
	   var sjcode = Ext.getCmp("BZCode").getValue();
	  arraysub = new Array();	
	  tkMakeServerCall("Nur.DHCNurLinkAss","GetCodeList",sjcode,"",sjcode,"addsub") //护理模板元素
	  var LinkItemCodeobj = Ext.getCmp("LinkItemCode");
	  LinkItemCodeobj.store.loadData(arraysub);	
	  Ext.getCmp("LinkItemCode").setValue("")
      Ext.getCmp("ItemName").setValue("")
	   var SJNameobj = Ext.getCmp("gd"); //戈登分类
	   SJNameobj.setValue("")
	   //alert(myId)
	   return
}
function setname(p, record, index) {
	
	  var LinkItemCode = Ext.getCmp("LinkItemCode");
		var bzcodename = Ext.getCmp("ItemName").lastSelectionText;
		var ItemName = Ext.getCmp("ItemName");
		selectedbzitm=ItemName.getValue()
	
}
//查询标准模板关联护理模板
function findlinkcode(p, record, index) {
	
	  var SJNameobj = Ext.getCmp("BZCode").getValue();
	  var LinkHLCodeobj = Ext.getCmp("LinkHLCode")
	  arraysub = new Array();
	  tkMakeServerCall("NurEmr.EmrCodeLinkDic","GetLinkCode",SJNameobj,"addsub")
	  LinkHLCodeobj.store.loadData(arraysub);
	
}
//查询护理模板元素
function findlink(p, record, index) {
	var sjcode = Ext.getCmp("gd").getValue();
	//var LinkHLCodeval = Ext.getCmp("LinkHLCode").value;
	arraysub = new Array();	
	tkMakeServerCall("Nur.DHCNurAssess","GetASSItmList",sjcode,"addsub") //护理模板元素
	var LinkItemCodeobj = Ext.getCmp("ItemName");
	LinkItemCodeobj.store.loadData(arraysub);	

}
//查询护理模板元素
function findlinkitm(p, record, index) {
	var sjcode = Ext.getCmp("BZCode").getValue();
	arraysub = new Array();	
	//alert(sjcode)
	tkMakeServerCall("Nur.DHCNurLinkAss","GetCodeList",sjcode,"",sjcode,"addsub") //护理模板元素
	var LinkItemCodeobj = Ext.getCmp("LinkItemCode");
	LinkItemCodeobj.store.loadData(arraysub);	
}

function findsjitms(p, record, index) {
	var SJNameobj = Ext.getCmp("BZCode").getValue();
	var ItemNameobj = Ext.getCmp("ItemName")
	arraysub = new Array();
	tkMakeServerCall("NurEmr.BLSJSBInterface","getSubcode",SJNameobj,"1","addsub")
	ItemNameobj.store.loadData(arraysub);
}
//选择模板后查询模板所有元素
function finditms(p, record, index) {
	var sjcode = Ext.getCmp("BZCode").getValue();
	var getitms = document.getElementById('getitms');
	locdata3 = new Array();
	cspRunServerMethod(getitms.value,sjcode,"","","addloc3");
	var LinkItemCode = Ext.getCmp("LinkItemCode");
	LinkItemCode.store.loadData(locdata3);	
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
	    var getemrcode=document.getElementById('getemrcode');
	    cspRunServerMethod(getemrcode.value,Dep.value,"addloc2");
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
var arraymain = new Array();
function addmain(a, b) {
	//alert(a)
	arraymain.push({
				id : a,
				desc : b
			});
}
var arraysub= new Array();
function addsub(a, b) {
	//alert(a)
	arraysub.push({
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
	 Nullitem.store.loadData(locdata5);
	 checkselect("Nullitem",flag)
                
	}
function checkselect(itm,instr)
{ 
	 var obj=Ext.getCmp(itm);
	 var str=[];//页面显示的值
	 var strvalue=[];//传入后台的值
	 str.push(instr);
	 strvalue.push(instr);
	// alert(itm)
	// alert(instr)
	 //var str="Item100"
	 //obj.setValue(str.join());
	 //obj.value=strvalue.join();
   //obj.valueId= strvalue.join();
   var aa=instr.split(",");	
   obj.store.each(function(rc){
   		 var ixflag=0
   		 var id1=rc.get('id')
   		
   		// alert(id1)
   	   for (i=0;i<aa.length;i++)
	     {	
	   	   if (aa[i]==id1)  
	   	   {ixflag=1} 		 
	     }
	    // alert(ixflag)
   	   if (ixflag==1)
   	   {
   	     rc.set('check',!rc.get('check'));
   	     //obj.setValue(str.join());
	       //obj.value=strvalue.join();
         //obj.valueId= strvalue.join();
         //obj.fireEvent('select', obj, record, index);
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

	//var GetQueryData = document.getElementById('GetQueryData');
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
	var loc=session['LOGON.CTLOCID'];
  var maincode = Ext.getCmp("patward").getValue();
  //var hlcodeval = Ext.getCmp("hlcode").getValue();

	//alert(StDate.vlaue);
	var parr =maincode+ "^"+"^"+"^"+"^";
	//alert(parr)
	  var mygrid = Ext.getCmp("mygrid");
   mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
   });    
   //mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
   mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
    //alert(parr);
	//var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurLinkAss.CRItem", "parr$" +parr,"AddRec");
	//alert(a);
    //mygrid.store.loadData(arrgrid);   

}


function AddRec(str)
{

	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function AddRecfind(str)
{
	var obj = eval('(' + str + ')');
	Rec.push(obj);
	//debugger;
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


var checkret="";

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

