/**
 * @author Administrator
 */
var locdata = new Array();
var condata = new Array();
var persondata=new Array();
var nursedata=new Array();
var loc = session['LOGON.CTLOCID'];




cspRunServerMethod(getloc, 'addloc');
function addloc(a, b) {
	locdata.push({
				loc : a,
				locdes : b
			});
}
var storeloc = new Ext.data.JsonStore({
			data : locdata,
			fields : ['loc', 'locdes']
});
var locField = new Ext.form.ComboBox({
			id : 'locsys',
			hiddenName : 'loc1',
			store : storeloc,
			width : 150,
			fieldLabel : '科室',
			valueField : 'loc',
			displayField : 'locdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
});

var storeperson = new Ext.data.JsonStore({
			data : persondata,
			fields : ['id', 'desc']
});
var person = new Ext.form.ComboBox({
			id : 'personstr',
			hiddenName : 'personstr1',
			store :storeperson, 
			width : 100,
			fieldLabel : '患者',
			valueField : 'id',
			displayField : 'desc',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
});
	function addperson(a, b) {
	//alert(a+b);
	persondata.push({
				id : a,
				desc: b
			});
		}
var storenurse = new Ext.data.JsonStore({
			data : nursedata,
			fields : ['nurseid', 'nursedesc']
});
var nurse = new Ext.form.ComboBox({
			id : 'nursestr',
			hiddenName : 'nursestr1',
			store :storenurse, 
			width : 50,
			fieldLabel : '巡视人',
			valueField : 'nurseid',
			displayField : 'nursedesc',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
});

	function addnurse(a, b) {
	//alert(a+b);
	nursedata.push({
				nurseid : a,
				nursedesc: b
			});}

function BodyLoadHandler() {
	//alert("cc");	
	setsize("mygridpl", "gform", "mygrid");
	var grid = Ext.getCmp("mygrid");
	var but = Ext.getCmp("mygridbut1");
	but.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var tobar = grid.getTopToolbar();
	
		tobar.addItem('开始日期',{
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridstdate',
			value:(showNowDay())
		},'-','结束日期',{
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygridenddate',
			value:(showNowDay())
		},'-','科室', locField,'-','患者', person,'-','巡视人', nurse);

	
	
	
	//tobar.addItem('开始日期',{
	//		xtype:'datefield',
	//		format: 'Y-m-d',
	//		id:'mygridstdate',
	//		value:(showMonthFirstDay())
	//	},'-','结束日期',{
	//		xtype:'datefield',
	//		format: 'Y-m-d',
	//		id:'mygridenddate',
	//		value:(showMonthLastDay())
	//	},'-','科室', locField,'-','患者', person,'-','巡视人', nurse);
		
//		if (Ext.get("loc1").dom.value!="")
//	{
//		getlistdata(Ext.get("loc1").dom.value, );
//		
//	}
	tobar.addButton({
			//className: 'new-topic-button',
			text : "查询",
			handler : function() {
				searchFn();
			},
			id : 'btnSearch'
		});

	tobar.doLayout();
}
Ext.getCmp("locsys").setValue(session['LOGON.CTLOCID']);

var cmb = Ext.getCmp("personstr");
//debugger;
//cmb.on('specialkey', cmbkey);
cmb.on('focus', cmbkey);
function cmbkey(field, e) {
	//alert(111);
	//if (e.getKey() == Ext.EventObject.CLICK) {
		//var pp = field.lastQuery;
		getlistdata("", field);
		// alert(ret);
	}
function getlistdata(p, cmb) {
	//var GetPerson = document.getElementById('GetNurMedTourperson');
	// debugger;
	loc=Ext.getCmp("locsys").getValue();
	//alert(loc);
	 cspRunServerMethod(GetNurMedTourperson,loc,'addperson');
		cmb.store.loadData(persondata);
	}
var cmb2 = Ext.getCmp("nursestr");
//debugger;
//cmb.on('specialkey', cmbkey);
cmb2.on('focus', cmbkey2);
function cmbkey2(field, e) {
	//alert(111);
	//if (e.getKey() == Ext.EventObject.CLICK) {
		//var pp = field.lastQuery;
		getlistdata2("", field);
		// alert(ret);
	}
function getlistdata2(p, cmb2) {
	//var GetPerson = document.getElementById('GetNurMedTourperson');
	// debugger;
	loc=Ext.getCmp("locsys").getValue();
	//alert(loc);
	 cspRunServerMethod(GetDoc,loc,'addnurse');
		cmb2.store.loadData(nursedata);
	}


function searchFn()
{
	var conloc = Ext.get("loc1").dom.value
	var stdate = Ext.getCmp("mygridstdate").value;
	var edate = Ext.getCmp("mygridenddate").value;
	var person = Ext.get("personstr1").dom.value;
	var nurse= Ext.get("nursestr1").dom.value;
	//alert(stdate+","+edate+","+conloc);
	condata = new Array();
  cspRunServerMethod(GetDHCNurMedTourRecordList,stdate,edate,conloc,person,nurse,"addconsult");
	var grid = Ext.getCmp("mygrid");
	grid.store.loadData(condata);
}
function addconsult(a, b, c, d, e,f,g,h,i,j,k,l,m,n,o,p) {
	//alert(a+b+c+d+e+f+g+h+i+j+k+l+m);
	condata.push({
		NurMedTourADMDR : a,
		NurMedTourPATBed : b,
		NurMedTourPATName : c,
		NurMedTourPATSex : d,
		NurMedTourDATE:e,
		NurMedTourTIME:f,
		NurMedTourItmMastDR:g,
		NurMedTourUSRDR:h,
		NurMedTourMedDeal:i,
		NurMedTourMedSituation:j,
		NurMedTourMedBarCodeDr:k,
		NurMedTourCTLOCDR:l,
		RowID:m,
		requestdate:n,
		requesttime:o,
		regon:p
		
	});
}
function printFn()
{
	var conloc = Ext.get("loc1").dom.value
	var stdate = Ext.getCmp("mygridstdate").value;
	var edate = Ext.getCmp("mygridenddate").value;
	var inout = Ext.get("InOutName").dom.value
	var inoutdesc="";
	if (inout=="I") inoutdesc="院内";
	if (inout=="O") inoutdesc="院外";
	//PrintComm.RHeadCaption=tm[1];
	PrintComm.LHeadCaption=stdate+"  至  "+edate+"   "+inoutdesc;
	//PrintComm.LFootCaption=tm[2];
	PrintComm.SetPreView("1");
	PrintComm.stPage=0;
	PrintComm.stRow=0;
	//PrintComm.previewPrint="1"; //是否弹出设置界面
	PrintComm.stprintpos=0;
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.ItmName = "DHCConsultStatPrn";
	PrintComm.ID = "";
	PrintComm.MultID = ""; 
	PrintComm.MthArr="";
	PrintComm.SetParrm(stdate+"!"+edate+"!"+inout+"!"+conloc);
	PrintComm.PrintOut();
}
function GetFirstDay()
{
    var s="";
    var myDate = new Date();
    var year = myDate.getYear();
    var month = myDate.getMonth();
    return(new Date(year,month,1));
}

function showMonthFirstDay() 
{ 
	var Nowdate=new Date(); 
	var MonthFirstDay=new Date(Nowdate.getYear(),Nowdate.getMonth(),1);
	return MonthFirstDay;
} 
function showMonthLastDay() 
{ 
	var Nowdate=new Date(); 
	var MonthNextFirstDay=new Date(Nowdate.getYear(),Nowdate.getMonth()+1,1); 
	var MonthLastDay=new Date(MonthNextFirstDay-86400000);
	return MonthLastDay;
}

function showNowDay() 
{ 
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
	return nowDate;
}
