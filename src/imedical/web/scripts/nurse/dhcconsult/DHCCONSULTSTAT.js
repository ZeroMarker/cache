/**
 * @author Administrator
 */
var locdata = new Array();
var condata = new Array();
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
			anchor : '100%',
			listeners: {
				focus: {
					fn: function (e) {
						e.expand();
						this.doQuery(this.allQuery, true);
					},
					buffer: 200
				},
				beforequery: function (e) {
					var combo = e.combo;
					var me = this;
					if (!e.forceAll) {
						var input = e.query;
						var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
							var text = getPinyin(record.get('locdes'));
							return regExp.test(text) | regExp.test(record.data[me.displayField]);
						});
						combo.expand();
						combo.select(0, true);
						return false;
					}
				}
			}
});
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	var grid = Ext.getCmp("mygrid");

	var but = Ext.getCmp("mygridbut1");
	but.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var tobar = grid.getTopToolbar();
	tobar.addItem('开始日期',{
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridstdate',
			value:(showMonthFirstDay())
		},'-','结束日期',{
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridenddate',
			value:(showMonthLastDay())
		},'-','院内院外',{
			xtype:'combo',
			store: new Ext.data.SimpleStore({
				fields: ['valueInOut', 'descpInOut'],
				data :[['I','院内'],['O','院外']]
				}),
			fieldLabel: '院内院外',
			loadingText:'正在加载...',
			displayField:'descpInOut', 	//隐藏的数据
			valueField:'valueInOut', 	//显示的数据
			mode:'local', 				//读取本地数据(remote表示远程数据)
			triggerAction:'all',
			id:'InOutID',
			hiddenName:'InOutName',
			editable:true, 				//是否可以编辑,同时此属性也支持输入搜索功能
			width:70
		},'-','科室', locField,'-');
	tobar.addButton({
			//className: 'new-topic-button',
			text : "查询",
			handler : function() {
				searchFn();
			},
			icon:'../images/uiimages/search.png',
			id : 'btnSearch'
		});
	tobar.addItem('-');
	tobar.addButton({
			//className: 'new-topic-button',
			text : "打印",
			handler : function(){
				printFn();
			},
			icon:'../images/uiimages/print.png',
			id : 'btnPrint'
		});
	grid.setTitle("会诊统计");
	tobar.doLayout();
	grid.getBottomToolbar().hide();
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'ConMoney'){
			grid.getColumnModel().setHidden(i,true);
		}
	}
	Ext.EventManager.onWindowResize(function(){ 
	var fheight=document.body.offsetHeight;
	var fwidth=document.body.offsetWidth;
	var fm=Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth);
    setsize("mygridpl", "gform", "mygrid");
});

}

function searchFn()
{
	var conloc = Ext.get("loc1").dom.value
	var stdate = Ext.getCmp("mygridstdate").value;
	var edate = Ext.getCmp("mygridenddate").value;
	var inout = Ext.get("InOutName").dom.value
	//alert(stdate+","+edate+","+inout+","+conloc);
	condata = new Array();
	cspRunServerMethod(GetConsultStat,stdate,edate,inout,conloc,"addconsult");
	var grid = Ext.getCmp("mygrid");
	grid.store.loadData(condata);
}
function addconsult(a, b, c, d, e) {
	condata.push({
		ConDep : a,
		DocGrade : b,
		ConsultDoc : c,
		ConNum : d,
		ConMoney : e
	});
}
function printFnold()
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
	PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	PrintComm.ItmName = "DHCConsultStatPrn";
	PrintComm.ID = "";
	PrintComm.MultID = ""; 
	PrintComm.MthArr="";
	PrintComm.SetParrm(stdate+"!"+edate+"!"+inout+"!"+conloc);
	PrintComm.PrintOut();
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
	var LHeadCaption=stdate+"  至  "+edate+"   "+inoutdesc;
	tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","LHeadCaption",EmrCode,LHeadCaption);
	var prncode="DHCConsultStatPrn";
	var parr=stdate+"!"+edate+"!"+inout+"!"+conloc;
	var WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	//表格打印没有病人信息会报错，所以取一个就诊号使用，实际不打印病人相关数据
	var Adm=tkMakeServerCall("web.DHCMGtestpge","GetAdmId");
	var EmrType=2;  //1:混合单 2：记录单 3：评估单
	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+Adm+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&Parrm="+parr+"&PrnLoc="+"&PrnBed="+"&LabHead="+"&curhead="+"&WebUrl="+WebUrl;
	//alert(link)
	window.location.href=link;
}
function GetFirstDay()
{
    var s="";
    var myDate = new Date();
    var year = myDate.getFullYear();
    var month = myDate.getMonth();
    return(new Date(year,month,1));
}

function showMonthFirstDay() 
{ 
	var Nowdate=new Date(); 
	var MonthFirstDay=new Date(Nowdate.getFullYear(),Nowdate.getMonth(),1);
	return MonthFirstDay;
} 
function showMonthLastDay() 
{ 
	var Nowdate=new Date(); 
	var MonthNextFirstDay=new Date(Nowdate.getFullYear(),Nowdate.getMonth()+1,1); 
	var MonthLastDay=new Date(MonthNextFirstDay-86400000);
	return MonthLastDay;
}