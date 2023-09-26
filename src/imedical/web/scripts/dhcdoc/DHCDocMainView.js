/**
* @author: wanghc
* @date: 2012/3/1
* 主页面
* scripts/dhcdoc/DHCDocMainView.js
*/
var patientTreePanel,patientInfoPanel, loadingwin,pbar, longPointBar = 0, timeoutHandlerId ; //, patientTreePanelWidth = 210;
var patientCountInfoBar, patientQueryBar, patientQueryNameBar, patientQueryMedicalBar,patientQueryCardNoBar,patientQueryBedNoBar,patientQueryWardBar,patientQueryDisDayBar,patientQueryMainDocBar,patientQueryWardGroupBar,patientQuerySeeOrdBar;
var typeMenu;
var nowDate = new Date().format("Y-m-d");
/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html html片段
*/
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
function hideLoadingWinFun(){
	var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();
	if(p){	
		if(window.frames[p.frameName] && window.frames[p.frameName].document && window.frames[p.frameName].document.readyState == 'complete'){
			clearTimeout(timeoutHandlerId);
			pbar.reset();
			loadingwin.hide();			
			longPointBar = 0;
		}else{
			if (longPointBar==10){ 
				longPointBar = 0 
			}else{
				longPointBar += 2;
			}
			pbar.updateProgress(longPointBar/10, '加载中...', false);
			timeoutHandlerId = setTimeout(hideLoadingWinFun,200);			
		}
	}
}
function GetCurrentChartLink() {
	var obj=Ext.getCmp('DHCDocTabPanel');
	//alert(obj.getActiveTab().initialConfig.cls);
	return obj.getActiveTab().initialConfig.cls ;
}
function ChangeCharPage(e){
	var key = e.getCharCode();
	var pageIdx = parseInt(String.fromCharCode(key));
	if (e.altKey && Ext.isNumber(pageIdx)){		
		var obj = Ext.getCmp('DHCDocTabPanel');
		if (obj){		
			obj.setActiveTab(pageIdx-1); //tabpage 从0开始			
		}
	}
}
var DHCDocMainView =  {
	requestCSP : "dhcdoc.request.csp",
	baseCLS: "web.DHCDocMain",
	barInfoMethod: "GetPatientBaseInfo",
	PatientID: "",
	EpisodeID: "",
	mradm: "",
	typeMenuChangeFlag:1, //Flag---update FCount CCount,SCount
	typeDesc:typeCBJson[PatSearchDefCon][1], //typeCBJson[0][1],  //current Queryparam-P1 type Desc
	countInfoSelectedBtn:null,
	dischgTypeMenuChangeFlag :1,
	dischgTypeDesc:dischgTypeCBJson[0][1],
	dischgDaySelectedBtn:null

};
var refreshBar = function (){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		if (adm > 0 ){
			getChartItemsInfo(papmi,adm,frm.mradm.value);
			patientInfoPanel.load({
				url:'websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Banner',
				params:{PatientID:papmi,EpisodeID:adm},
				callback:function(html,p2){
					html.dom.style.height = "36px"; 
					html.dom.innerHTML = "<div id='PageContent'>"+document.getElementById("dPAPerson_Banner").innerHTML+"</div>" 
					var obj = document.getElementById("BANNERAdmCharge"); 
					if(obj){ if (obj.value<0) obj.style.color="red"; } 
					var sourceFlagObj = document.getElementById("REAAdmSourceFlag"); 
					if (sourceFlagObj && sourceFlagObj.value==1){ var obj1 = document.getElementById("BANNERPAADMAdmReason") 
					if (obj1){ obj1.style.color = "blue"; } } 
					//不换行 
					var tds = document.getElementById("fPAPerson_Banner").getElementsByTagName("TD"); 
					var len = tds.length; 
					for(var i=0; i<len; i++){ 
						tds[i].setAttribute("noWrap","noWrap"); 
					}

					/*html.dom.innerHTML = "<div id='PageContent'>"+document.getElementById("dPAPerson_Banner").innerHTML+"</div>"
					var obj = document.getElementById("BANNERAdmCharge");
					if(obj){
						if (obj.value<0) obj.style.color="red";
					}*/
				},
				scripts:false,
				timeout:300
			});
			/*
			var info = tkMakeServerCall(DHCDocMainView.baseCLS, DHCDocMainView.barInfoMethod, papmi, adm);
			var obj = Ext.decode(info);
			var tbTextObj ;
			for (var i in obj){
				if (obj.hasOwnProperty(i)){
					tbTextObj = Ext.getCmp(i);
					if(tbTextObj&& i == "baseIconProfile"){
						tbTextObj.update(reservedToHtml(obj[i]));
					}else if(tbTextObj) {
						tbTextObj.setText(obj[i]);
					}
				}
			}*/
		}
	}
};
//调用panel页面iframe中的xhrRefresh方法
var xhrRefresh = function(forceRefresh){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value; //DHCDocMainView.EpisodeID;
		if ((adm > 0) || (forceRefresh == true) ){
			var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();	
			var frame = window.frames[p.frameName];		
			if ( frame && "function" === typeof frame.xhrRefresh ){
				frame.xhrRefresh({papmi: papmi, adm: adm, mradm: mradm, forceRefresh: (forceRefresh || false)});				
			}
		}else{
			//alert("请选择病人");
		}
	}
};
var rewriteUrl = function(url, obj){
	var reg,flag, indexFlag = false;
	var indexFlag = (url.indexOf("?")==-1);
	if(indexFlag){
		url += "?";	
	}
	for (var i in obj){	
		if(obj.hasOwnProperty(i)){
			flag = false; 	//包含与否
			if(!indexFlag){	//url不包含?就不走replace
				reg =  new RegExp(i+"=","g");
				url = url.replace(reg, function(m1){
					flag = true;
					return i+"="+obj[i];
				});
			}
			if(!flag){
				url  +=   "&" + i + "=" + obj[i];
			}
		}
	}
	return url;	
}
//重新load整个页面,并加载数据
var hrefRefresh = function (forceRefresh){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value; //DHCDocMainView.EpisodeID;
		if (adm > 0){
			var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();	
			var iframe = p.el.dom.getElementsByTagName("iframe")[0];
			var iframesrc = iframe.src;
			//alert("papmi"+papmi);
			var url = rewriteUrl(p.src,{PatientID:papmi, EpisodeID:adm, mradm: mradm, copyOeoris:'', copyTo:''});			
			//alert(url);
			//为了下医嘱能重定向到自已页面
			if (p.initialConfig) {
				p.initialConfig.cls = url;	
			}else{
				p.initialConfig = {};
				p.initialConfig.cls = url;	
			}			
			if((forceRefresh==true)||(iframesrc.slice(iframesrc.indexOf("?")) != url.slice(url.indexOf("?")))) {				
				if(pbar) {loadingwin.show();	}				
				//pbar.wait({interval:200,text:'加载中...',increment:10});				
				iframe.src = url;				
				if(pbar) {setTimeout(hideLoadingWinFun,100);}
			}; 	//缓存刷新
		}else{
			//alert("请选择病人");
		}
	}	
}
var resetEprMenuForm = function(){
	setEprMenuForm("","","","");
}
var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
} 
function hideQueryBar (){
	patientQueryBar.hide();
	patientQueryNameBar.hide();
	patientQueryMedicalBar.hide();
	patientQueryWardBar.hide();
	patientQueryDisDayBar.hide();
	patientQuerySeeOrdBar.hide();
	patientQueryMainDocBar.hide();
	patientQueryWardGroupBar.hide();
	if(PAADMType && PAADMType=="I") patientQueryBedNoBar.hide();
	if(PAADMType && PAADMType=="O") patientQueryCardNoBar.hide();
	//patientTreePanel.setWidth(patientTreePanel.getWidth());
	Ext.getCmp("docmainviewport").syncSize(); 
	//Ext.getCmp('patientMainDocTF').setValue('');
	//Ext.getCmp('patientMainDocTF').setRawValue('');
}
function showQueryBar(){
	patientQueryBar.show();
	patientQueryNameBar.show();
	patientQueryMedicalBar.show();
	patientQueryWardBar.show();
	patientQueryDisDayBar.show();
	patientQuerySeeOrdBar.show();
	patientQueryMainDocBar.show();
	patientQueryWardGroupBar.show();
	if(PAADMType && PAADMType=="I") patientQueryBedNoBar.show();
	if(PAADMType && PAADMType=="O") patientQueryCardNoBar.show();	
	//patientTreePanel.setWidth(patientTreePanel.getWidth());
	Ext.getCmp("docmainviewport").syncSize();
}
var findPatientTree = function(e){
	var patientNo = Ext.getCmp('patientNoTF').getValue();
	var ruleNo="", len = regLength,patLen;
	for(var i=0;i<len;i++){ruleNo += '0' ;}
	if(patientNo!=""){
		patLen = patientNo.length;
		if(len-patLen>=0){
			patientNo = ruleNo.slice(0,len-patLen)+patientNo;
		}else{
			patientNo = patientNo.slice(patLen-len);
		}
		Ext.getCmp('patientNoTF').setValue(patientNo);
	}
	var store = patientTreePanel.store;
	//store.baseParams.P1 = -1;		//表示未选中->床号查询时用当前的范围
	store.baseParams.P2 = patientNo;
	store.baseParams.P3 = Ext.getCmp('patientNameTF').getValue();
	store.baseParams.P4 = Ext.getCmp('patientMedicalTF').getValue();
	store.baseParams.P6 = Ext.getCmp('patientCardNoTF').getValue();
	store.baseParams.P7 = Ext.getCmp("patientBedNoTF").getValue();
	store.baseParams.P8 = Ext.getCmp("patientWardTF").getValue();
	store.baseParams.P9 = Ext.getCmp("patientDisDayTF").getValue();
	store.baseParams.P11 = Ext.getCmp("patientMainDocTF").getValue();
	store.baseParams.P12 = Ext.getCmp("WardProGroupList").getValue();
	var HavedSeeOrdPat=document.getElementById("HavedSeeOrdPat").checked;
	if (HavedSeeOrdPat){
		HavedSeeOrdPat="on";
	}else{
		HavedSeeOrdPat="";
	}
	store.baseParams.P13 = HavedSeeOrdPat;
	if (e && e.illType){
		store.baseParams.P10 = e.illType;
	}else{
		store.baseParams.P10 = "";
	}
	DHCDocMainView.typeMenuChangeFlag = 0;
	store.load();	
}

var findDischgPatientTree = function(e){
	var store = dischgPatientPanel.store;
	//store.baseParams.P1 = -1;		//表示未选中->床号查询时用当前的范围
	if (e && e.dischgday){
		dischgPatientDayBar.items.each(function(item){
			if (item.dischgday){
				item.removeClass("x-btn-click");
			}
		});
		if ((DHCDocMainView.dischgDaySelectedBtn==null)||(DHCDocMainView.dischgDaySelectedBtn!=e)){
		    DHCDocMainView.dischgDaySelectedBtn = e;
			DHCDocMainView.dischgDaySelectedBtn.addClass('x-btn-click');
			store.baseParams.P4 = e.dischgday;
		}else if (e == DHCDocMainView.dischgDaySelectedBtn){
			DHCDocMainView.dischgDaySelectedBtn = null;
			//Ext.getCmp("dischgday7").addClass("x-btn-click");
			store.baseParams.P4 = "";
		}
	}else{
		//Ext.getCmp("dischgday7").addClass("x-btn-click");
		store.baseParams.P4 = "";
	}
	DHCDocMainView.dischgTypeMenuChangeFlag = 1;
	store.load();	
}

var isVaildUseDHCOE = function(p){
	var tp = Ext.getCmp('DHCDocTabPanel');
	var DHCOEPage=0;
	var frm = dhcsys_getmenuform();
	if(orderTabIndex>-1){
		DHCOEPage = (tp.getComponent(orderTabIndex)==p) ? 1:0;
	}
	if(frm.EpisodeID.value == 0){
		alert("请选中病人!");	//开医嘱前必须选中病人
		return false;	
	}
	if ((DHCOEPage==1) && frm.EpisodeID.value == 0 ){				
		alert("请选中病人再开医嘱!");	//开医嘱前必须选中病人	oeorder.oplistcustom.csp
		return false;
	}else{
		/*
		var baseIsEstDischObj=document.getElementById("baseIsEstDisch");
		if (baseIsEstDischObj.type=="hidden"){var baseIsEstDisch=baseIsEstDischObj.value;}else{var baseIsEstDisch=baseIsEstDischObj.innerText;}
		if((DHCOEPage==1)&&(baseIsEstDisch=="1")){
			alert("病人已医疗结算不能下医嘱!");
			return false;
		}
		*/
	}
	return true;
}
var gridPanelClick =  function (r,forceRefresh){
	var pid = r.data['PatientID'];
	var eid = r.data['EpisodeID'];
	var mid = r.data['mradm'];
	var Sex = r.data['PAPMISex'];
	var canGiveBirth = (Sex=="女")?1:0;
	if((true===forceRefresh) || (DHCDocMainView.EpisodeID != eid)){
		tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		DHCDocMainView.PatientID = pid;
		DHCDocMainView.EpisodeID = eid;
		DHCDocMainView.mradm = mid;
		setEprMenuForm(eid,pid,mid,canGiveBirth);
		refreshBar();
		var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();
		isVaildUseDHCOE(p)
		if (p.allRefresh === true){						
			hrefRefresh(forceRefresh);
		}else{
			xhrRefresh(forceRefresh);
		}
	}
}

var initComp = function(){
	if(typeof IsUseProgressBar != "undefined" && !IsUseProgressBar ){
	}else{
		pbar = new Ext.ProgressBar({id:'loadingpbar', width:300});
		loadingwin = new Ext.Window({
			id:'loadingwin',closable:false, modal:true, layout:'fit', width:400, height:37,
			items: pbar
		});	
	}
	patientInfoPanel = new Ext.Panel({
		region: 'north',
		split: false,
		height: "30px",
		bodyStyle:{borderWidth:'0px',paddingBottom:10,background:'#edf5ff'},
		/*
		bodyCfg: {cls:'x-panel-header'},
		bodyStyle:{padding:0,paddingBottom:10}, //来控制背景色
		*/
		//bodyCfg: {cls:'x-panel-footer'},
		html: '<div style="height:27px;background-color:#edf5ff;"><table><TBODY><TR><TD noWrap><STRONG>选中的病人信息</STRONG> <LABEL id=BANNERRegistrationNo name="BANNERRegistrationNo"></LABEL></TD></TR></TBODY></table></div>'
	});	
	var typeMenuItem = [];
	for (var i = 0; i < typeCBJson.length; i++) {
		typeMenuItem.push({selectId:typeCBJson[i][0],text:typeCBJson[i][1],
			handler:function(b,e){
				var store = patientTreePanel.store;
				var v = b.selectId;
				DHCDocMainView.typeMenuChangeFlag = 1;
				DHCDocMainView.typeDesc = b.text;
				//if(store.baseParams.P1 != v){									
					store.baseParams.P1 = v;
					store.baseParams.P2 = "";Ext.getCmp('patientNoTF').setValue("");
					store.baseParams.P3 = "";Ext.getCmp('patientNameTF').setValue("");
					store.baseParams.P4 = "";Ext.getCmp('patientMedicalTF').setValue("");
					store.baseParams.P6 = "";Ext.getCmp('patientCardNoTF').setValue("");
					store.baseParams.P7 = "";Ext.getCmp("patientBedNoTF").setValue("");
					store.baseParams.P8 = "";Ext.getCmp("patientWardTF").setValue("");
					store.baseParams.P9 = "";Ext.getCmp("patientDisDayTF").setValue("");
					store.baseParams.P11 = "";Ext.getCmp("patientMainDocTF").setValue("");
					store.baseParams.P12 = "";Ext.getCmp("WardProGroupList").setValue("");
					var HavedSeeOrdPat=document.getElementById("HavedSeeOrdPat").checked;
					if (HavedSeeOrdPat){
						HavedSeeOrdPat="on";
					}else{
						HavedSeeOrdPat="";
					}
					store.baseParams.P13 = HavedSeeOrdPat;
					store.baseParams.P10 = "";
					store.load();
					resetEprMenuForm();
				//}
			}
		});
	};
	var dischgTypeMenuItem = [];
	for (var i=0; i<dischgTypeCBJson.length ;i++){
		dischgTypeMenuItem.push({selectId:dischgTypeCBJson[i][0],text:dischgTypeCBJson[i][1],
			handler:function(b,e){
				var store = dischgPatientPanel.store;
				var v = b.selectId;
				DHCDocMainView.dischgTypeMenuChangeFlag = 1;
				DHCDocMainView.dischgTypeDesc = b.text;
				store.baseParams.P1 = v;
				store.load();
				resetEprMenuForm();
			}
		});
	}
	typeMenu = new Ext.menu.Menu({items:typeMenuItem});
	dischgTypeMenu = new Ext.menu.Menu({items:dischgTypeMenuItem});
	var tmpobj = {};
	tmpobj.fieldfun = function(id){
		var tmpFieldObj = {width:140,enableKeyEvents:true,trigger1Class: 'x-form-clear-trigger',trigger2Class: 'x-form-search-trigger',
		onTrigger1Click: function(e){this.setValue("");}, onTrigger2Click: findPatientTree,enableKeyEvents:true,listeners:{
			"keypress":function(t,e){if(e.getKey() == e.ENTER){findPatientTree(e);}}
		}};
		//if(id=="patientDisDayTF"){Ext.apply(tmpFieldObj,{value:30})}
		return new Ext.form.TwinTriggerField(Ext.apply({id:id},tmpFieldObj)) ;
	}
	tmpobj.illfun = function(code,text){
		var color = "color:"+IllTypeColor[code]+";";
		var bold = "font-weight:bold;";
		var size = "font-size:14px;";
		return [{illType:code,text:"<span style='"+color+bold+size+"'>"+text+":</span>",handler:findPatientTree},{id:code+"Count",xtype:"label",style:bold+size,text:0}];
	}
	tmpobj.disdayfun = function(day,text){
		var color = "color:green;";
		var bold = "font-weight:bold;";
		var size = "font-size:14px;";
		return [{dischgday:day,id:"dischgday"+day,text:"<span style='"+color+bold+size+"'>"+text+"</span>",handler:findDischgPatientTree}];
	}

	patientCountInfoBar     = new Ext.Toolbar({items:[{xtype:'tbspacer',width:5}, tmpobj.illfun("F","新入"), {xtype: 'tbspacer',width:15}, tmpobj.illfun("S","病重"),{xtype: 'tbspacer',width:15}, tmpobj.illfun("C","病危")]});
	patientQueryBar 		= new Ext.Toolbar({hidden:true,items: [{text:"登记号:",width:65}, tmpobj.fieldfun('patientNoTF') ] } );
	patientQueryNameBar 	= new Ext.Toolbar({hidden:true,items: [{text:"姓名:",width:65}, tmpobj.fieldfun('patientNameTF') ] } );
	patientQueryMedicalBar 	= new Ext.Toolbar({hidden:true,items: [{text:"病案号:",width:65}, tmpobj.fieldfun('patientMedicalTF') ] } );
	patientQueryCardNoBar 	= new Ext.Toolbar({hidden:true,items: [{text:"卡号:",width:65}, tmpobj.fieldfun('patientCardNoTF') ] } );
	patientQueryBedNoBar 	= new Ext.Toolbar({hidden:true,items: [{text:"床号:",width:65}, tmpobj.fieldfun('patientBedNoTF') ] } );
	dischgPatientDayBar     = new Ext.Toolbar({items:[{xtype:'tbspacer',width:18},tmpobj.disdayfun("7","7天"),{xtype:'tbspacer',width:8},tmpobj.disdayfun("14","14天"),{xtype:'tbspacer',width:8},tmpobj.disdayfun("21","21天"),{xtype:'tbspacer',width:8},tmpobj.disdayfun("30","30天")]});
	//2014-12-2 增加病区查询
	var combo = new Ext.form.ComboBox({
		id:'patientWardTF',
	    typeAhead: true,
	    width:140,
	    triggerAction: 'all',
	    lazyRender:true,
	    mode: 'local',
	    store: new Ext.data.ArrayStore({
	        fields: [ 'wardId', 'wardDesc' ],
	        data: WardJson //[[13, 'item1'], [15, 'item2']]
	    }),
	    trigger2Class: 'x-form-search-trigger',
	    valueField: 'wardId',
	    displayField: 'wardDesc',
	    enableKeyEvents:true,
	    listeners:{
			"keypress":function(t,e){if(e.getKey() == e.ENTER){findPatientTree(e);}},
			"select":function(t,r,index){findPatientTree();}
	    }
	});	
	patientQueryWardBar = new Ext.Toolbar({hidden:true,items: [{text:"病区:",width:65},combo ] } );
	//2017-06-24 增加管床医生查询
	var combo = new Ext.form.ComboBox({
		id:'patientMainDocTF',
	    typeAhead: true,
	    width:140,
	    triggerAction: 'all',
	    lazyRender:true,
	    mode: 'local',
	    store: new Ext.data.ArrayStore({
	        fields: [ 'DocId', 'DocDesc' ],
	        data: DocJson //[[13, 'item1'], [15, 'item2']]
	    }),
	    trigger2Class: 'x-form-search-trigger',
	    valueField: 'DocId',
	    displayField: 'DocDesc',
	    enableKeyEvents:true,
	    listeners:{
			"keypress":function(t,e){if(e.getKey() == e.ENTER){findPatientTree(e);}},
			"select":function(t,r,index){findPatientTree();}
	    }
	});
	//增加护士专业组查询
	var combo1 = new Ext.form.ComboBox({
		id:'WardProGroupList',
	    typeAhead: true,
	    width:140,
	    triggerAction: 'all',
	    lazyRender:true,
	    mode: 'local',
	    store: new Ext.data.ArrayStore({
	        fields: [ 'WardGroupId', 'WardGroupDesc' ],
	        data: WardGroupJson 
	    }),
	    trigger2Class: 'x-form-search-trigger',
	    valueField: 'WardGroupId',
	    displayField: 'WardGroupDesc',
	    enableKeyEvents:true,
	    listeners:{
			"keypress":function(t,e){if(e.getKey() == e.ENTER){findPatientTree(e);}},
			"select":function(t,r,index){findPatientTree();}
	    }
	});
    var tb=new Ext.form.Checkbox({ 
	    id : "HavedSeeOrdPat", 
	    listeners:{
		    "check":function(obj,ischecked){findPatientTree();}
		}
    });
		
	patientQueryMainDocBar = new Ext.Toolbar({hidden:true,items: [{text:"管床医生:",width:65},combo ] } );
	patientQueryDisDayBar = new Ext.Toolbar({hidden:true,items: [{text:"出院天数:",width:65}, tmpobj.fieldfun('patientDisDayTF') ] } );
	patientQueryWardGroupBar = new Ext.Toolbar({hidden:true,items: [{text:"专业组:",width:65},combo1 ] } );
	patientQuerySeeOrdBar=new Ext.Toolbar({hidden:true,items: [{text:"只查询有需处理医嘱患者",width:65},tb ] } );
	//,"&nbsp","-","&nbsp","未就诊:","<input id='RegQue' type='checkbox' checked='checked'/>"
	delete tmpobj.fieldfun;
	delete tmpobj.illfun;
	var tmp = false;
	if(typeof  PatListCollapseConfig != "undefined" && PatListCollapseConfig){
		tmp = true;
	}
	patientTreePanel = new dhcc.icare.MixGridPanel({
		region: 'west',
		title: typeCBJson[PatSearchDefCon][1],//typeCBJson[0][1],
		split: true,
		width:patientTreePanelWidth,
		collapsed : tmp,
		//animCollapse:false,
        //animate: false,
        collapseMode:'mini',
        //minSize:175,        
		hiddenCM:['PatientID','EpisodeID','mradm','PAAdmReasonCode','FinancialDischargeFlag','MedicalDischargeFlag','PAAdmReasonCode','StatusCode','PriorityCode','Called','RegDocDr'],
		listClassName: 'web.DHCDocMain',
		listQueryName: 'FindCurrentAdmProxy',
		pageSize: 20,
		tools:[
		/*{
			id:'gear',
			qtip:'配置基础数据',
			handler:function(event,toolEl,panel){
				
			}
		},*/{
			id:'refresh',
			qtip:'刷新',
			handler:function(event,toolEl,panel){
				patientTreePanel.store.load();
			}
		},{
			id:'down',
			qtip:'选择范围',
			handler: function(event,toolEl,panel){
				typeMenu.show(toolEl);
			}
		},{
		    id:'search',
		    qtip: '查询病人',		    
		    handler: function(event, toolEl, panel){
		        if(patientQueryBar.isVisible()) hideQueryBar();
				else showQueryBar();
		    }
		},{
		    id:'maximize',
		    qtip: '展开',
		    handler: function(event, toolEl, panel){
		       westPanel.setWidth(Ext.getCmp("docmainviewport").getWidth());
		       //patientTreePanel.setWidth(Ext.getCmp("docmainviewport").getWidth());
			   Ext.getCmp("docmainviewport").syncSize();
			   panel.tools['restore'].setVisible(true);
			   panel.tools['maximize'].setVisible(false);
		    }
		},{
			id:'restore',
		    qtip: '恢复',
		    hidden:true,
		    handler: function(event, toolEl, panel){
			   westPanel.setWidth(patientTreePanelWidth);
		       // patientTreePanel.setWidth(patientTreePanelWidth);
			   Ext.getCmp("docmainviewport").syncSize();
			   panel.tools['restore'].setVisible(false);
			   panel.tools['maximize'].setVisible(true);
		    }
		}],		
		tbar: patientCountInfoBar, //patientQueryBar,
		cmHandler:function(cms){
			for(var i = 0, len = cms.length; i < len; i++){		
				if(cms[i].dataIndex == "PAAdmBed"){				
					var bedcm = cms.splice(i,1);
					bedcm[0]["sortable"] = true;
					bedcm[0]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						 if (record.data["PAAdmBed"]=="已出院"){
							 metaData.style += "font-weight:600;color:red;";
						 }
						 return value;
					}					
					cms.splice(0,0,bedcm[0]);
				}
				if(cms[i].dataIndex == "PAAdmDate"){
					cms[i]["sortable"] = true;
					/*cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						 metaData.style="color:red;";
						 return value;
					}*/					
				}
				if(cms[i].dataIndex == "IconProfile"){		
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						return reservedToHtml(value);
					}
				}
			}
			return cms;
		},
		listeners:{
			'afterrender': function(t){ 
				t.store.baseParams.P1 = typeCBJson[PatSearchDefCon][0] //typeCBJson[0][0];
				//PAADMType菜单内的参数
				if("undefined"==typeof PAADMType)t.store.baseParams.P5 = "I";
				else t.store.baseParams.P5 = PAADMType;
				t.store.on("load",function(t, records, options){
					//resetEprMenuForm();
					if (DHCDocMainView.typeMenuChangeFlag){
						var total=t.getTotalCount();
						//patientTreePanel.setTitle(DHCDocMainView.typeDesc+ "<font color=red>"+t.getTotalCount()+"人"+"</font>")	
						Ext.Ajax.request({
						   url: DHCDocMainView.requestCSP,
						   success: function(res,opts){
							   var obj = Ext.decode(res.responseText);
							   Ext.getCmp("FCount").setText(obj.FCount); //BabyNum
							   Ext.getCmp("SCount").setText(obj.SCount);
							   Ext.getCmp("CCount").setText(obj.CCount);
							   var BabyNum=obj.BabyNum;
							   total=total-BabyNum;
							   if (+BabyNum==0){
								   patientTreePanel.setTitle(DHCDocMainView.typeDesc+ "<font color=red>"+total+"人"+"</font>")
							   }else{
								   patientTreePanel.setTitle(DHCDocMainView.typeDesc+ "<font color=red>"+total+"+"+BabyNum+"人"+"</font>")
							   }
							},
						   failure: function(res,opts){},
						   params: {act:"GetPatIllTypeCountInfo","SSUserLoginId":SSUserLoginId}
						});
					}
				})
				t.store.load();
			},
			'pagingToolbarRender': function(){
				//patientCountInfoBar.render(this.tbar);	
				patientQueryBar.render(this.tbar);									
				patientQueryNameBar.render(this.tbar);
				patientQueryMedicalBar.render(this.tbar);
				patientQueryCardNoBar.render(this.tbar);				
				patientQueryBedNoBar.render(this.tbar);
				if (LinkWardCount>0){ patientQueryWardBar.render(this.tbar);}
				if (DocCount>0){ patientQueryMainDocBar.render(this.tbar);}
				patientQueryWardGroupBar.render(this.tbar);
				patientQueryDisDayBar.render(this.tbar);
				patientQuerySeeOrdBar.render(this.tbar);
			}
		},
		columnModelFieldJson: patientTreeMetaDataJson		
	});	
	dischgPatientPanel = new dhcc.icare.MixGridPanel({
		title:"本科出院病人", 
		hiddenCM:['PatientID','EpisodeID','mradm','PAAdmReasonCode','FinancialDischargeFlag','MedicalDischargeFlag','PAAdmReasonCode','StatusCode','PriorityCode','Called','RegDocDr'],
		listClassName: 'web.DHCDocMain',
		listQueryName: 'FindDischgAdmProxy',
		pageSize: 20,
		tools:[{
			id:'refresh',
			qtip:'刷新',
			handler:function(event,toolEl,panel){
				panel.store.load();
			}
		},{
			id:'down',
			qtip:'选择范围',
			handler: function(event,toolEl,panel){
				dischgTypeMenu.show(toolEl);
			}
		},{
		    id:'maximize',
		    qtip: '展开',
		    handler: function(event, toolEl, panel){
		       westPanel.setWidth(Ext.getCmp("docmainviewport").getWidth());
			   Ext.getCmp("docmainviewport").syncSize();
			   panel.tools['restore'].setVisible(true);
			   panel.tools['maximize'].setVisible(false);
		    }
		},{
			id:'restore',
		    qtip: '恢复',
		    hidden:true,
		    handler: function(event, toolEl, panel){
		       westPanel.setWidth(patientTreePanelWidth);
			   Ext.getCmp("docmainviewport").syncSize();
			   panel.tools['restore'].setVisible(false);
			   panel.tools['maximize'].setVisible(true);
		    }
		}],	
		listeners:{
			'afterrender': function(t){ 
				t.store.baseParams.P1 = 0;
				t.store.baseParams.P2 = session['LOGON.CTLOCID'] ;
				t.store.baseParams.P3 = session['LOGON.USERID'] ;
				t.store.baseParams.P4 = "" ;
				t.store.on("load",function(s, records, options){
					if (DHCDocMainView.dischgTypeMenuChangeFlag){
					    dischgPatientPanel.setTitle(DHCDocMainView.dischgTypeDesc+"<font color=red>"+s.getTotalCount()+"人"+"</font>");
					}
					if (s.baseParams.P4==""){
						s.baseParams.P4 = 7;
					}
					Ext.getCmp("dischgday"+s.baseParams.P4).addClass("x-btn-click");
				})
				t.store.load();
			}
		},
		tbar: dischgPatientDayBar,
		columnModelFieldJson: dischgPatientMetaDataJson
	});

	westPanel = new Ext.Panel({
		region: 'west',
		layout:'accordion',
		split: true,
		width:patientTreePanelWidth,
		collapsed : tmp,
        collapseMode:'mini',
		layoutConfig:{
			hideCollapseTool:true,
			//titleCollapse: false
			//animate: true,
			activeOnTop: false
		},
		items:[patientTreePanel,dischgPatientPanel]
	});

	var tabPanel = new Ext.TabPanel({	
		activeTab:0,
		id: 'DHCDocTabPanel',
		enableTabScroll:true,
		minTabWidth: 115,
        tabWidth:135,
		region:'center',
		items:tabItemsJson,
		listeners:{"afterrender": function(tp){
			var frm = dhcsys_getmenuform();
			if(frm && frm.EpisodeID && frm.EpisodeID.value!=""){
				refreshBar();
				var p = tp.getActiveTab();
				isVaildUseDHCOE(p);
				if (p.allRefresh === true){						
					hrefRefresh(true);
				}else{
					//xhrRefresh(forceRefresh);  局部刷新让页面自己去做
				}
			}
		}}	
		//tbar内的item的id与后台一样
		/*tbar: [
			{xtype: 'tbtext',id:'baseIconProfile',text:''},	"-",			
	        '姓名:',{xtype: 'tbtext',id:'baseInfoName',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},"-",
	        '床号:',{xtype: 'tbtext',id:'baseInfoBedno',width:'70',text:'',style:'font-weight:bold;font-size:16px;'},"-",
	        '年龄:',{xtype: 'tbtext',id:'baseInfoAge',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},"-",
			'性别:',{xtype: 'tbtext',id:'baseInfoSex',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},"-",
	        '体重:',{xtype: 'tbtext',id:'baseInfoBodyWeight',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'住院号:',{xtype: 'tbtext',id:'baseInfoIPNo',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'保险类型:',{xtype: 'tbtext',id:'baseInfoInsu',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'入院日期:',{xtype: 'tbtext',id:'baseInfoIPDate',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			{xtype: 'tbtext',id:'baseIsEstDisch',text:'',hidden:true}
			
	    ]*/
	});	
	var viewport = new Ext.Viewport({
		id:'docmainviewport',
		layout:'border',
		items:[patientInfoPanel,westPanel,tabPanel]
		
	});
}
//items:[patientInfoPanel,tabPanel]
var initListener = function(){
	if(patientTreePanel){
		patientTreePanel.on("rowclick",function (t, index, e){
			var r = t.store.getAt(index);
			gridPanelClick(r,true);			
		});
		//双击为强制刷新
		patientTreePanel.on("rowdblclick",function(t,index,e){
			var r = t.store.getAt(index);
			gridPanelClick(r,true);
		});
		patientTreePanel.store.on("load",function(s, rs,op){
			var EpisodeID = "",index = -1;
			patientTreePanel.store.baseParams.P10 = "";			
		    //patientTreePanel.store.baseParams.P11 = "";
			if(rs.length>0){hideQueryBar();}
			s.each(function(r,i){
				if(r.data["ColorDesc"]!="") {
					patientTreePanel.getView().getRow(i).style.backgroundColor = r.data["ColorDesc"];
				}
			})
			var frm = dhcsys_getmenuform();
			if (frm) {
				EpisodeID = frm.EpisodeID.value ;				
				if( (EpisodeID != "") && (EpisodeID != 0) ){
					Ext.each(rs,function(r,i){if(r.data["EpisodeID"]==EpisodeID){index = i;return i;}});
					if(index>=0){
						patientTreePanel.getSelectionModel().selectRow(index);
						//当发送事件时医嘱列表可能没有煊染完成,医嘱列表第一次加载时去判断病人并查询					
						//patientTreePanel.fireEvent("rowdblclick",patientTreePanel,index,{});
					}
				}
			}			
					
		});		
	}
	if(dischgPatientPanel){
		dischgPatientPanel.on("rowclick",function (t, index, e){
			var r = t.store.getAt(index);
			gridPanelClick(r,true);			
		});
		//双击为强制刷新
		dischgPatientPanel.on("rowdblclick",function(t,index,e){
			var r = t.store.getAt(index);
			gridPanelClick(r,true);
		});
		dischgPatientPanel.store.on("load",function(s, rs,op){
			var EpisodeID = "",index = -1;
			if(rs.length>0){hideQueryBar();}
			s.each(function(r,i){
				if(r.data["ColorDesc"]!="") {
					dischgPatientPanel.getView().getRow(i).style.backgroundColor = r.data["ColorDesc"];
				}
			});		
		});		
	}

	var obj = Ext.getCmp('DHCDocTabPanel');
	if (obj){
		obj.on("beforetabchange",function (tp,p,cPanel){
			if (typeof(cPanel) == 'undefined' || typeof(cPanel.frameName) == 'undefined') return true;
			var frm = dhcsys_getmenuform();
			var frame = window.frames[cPanel.frameName];		
			if ( frame ){
				var chartOnBlur = "";
				if ("function" === typeof frame.chartOnBlur){
					chartOnBlur = frame.chartOnBlur; 
				}else if (frame.contentWindow && "function" === typeof frame.contentWindow.chartOnBlur){
					chartOnBlur = frame.contentWindow.chartOnBlur;
				}
				if(chartOnBlur) {
					//如果返回非true,不切换Chart
					if (!chartOnBlur()){return false;};	
			    }			
			}	
			//--------------			
			if (typeof(p) == 'undefined' || typeof(p.frameName) == 'undefined') return true;
			var newTabframe = window.frames[p.frameName];		
			if ( newTabframe ){
				var chartOnFocus = "";
				if ("function" === typeof newTabframe.chartOnFocus){
					chartOnFocus = newTabframe.chartOnFocus; 
				}else if (newTabframe.contentWindow && "function" === typeof newTabframe.contentWindow.chartOnFocus){
					chartOnFocus = newTabframe.contentWindow.chartOnFocus;
				}
				if(chartOnFocus) {
					var papmi="",adm="",mradm="";
					if (frm) {
						papmi = frm.PatientID.value;
						adm = frm.EpisodeID.value; 
						mradm = frm.mradm.value; 
					}
				    chartOnFocus({papmi: papmi, adm: adm, mradm: mradm});	
				}			
			}
			if(isVaildUseDHCOE(p)){
				if(pbar) {setTimeout(hideLoadingWinFun,100);}
				if(!p.html) {p.html = '<iframe id="'+ p.frameName +'" name="'+ p.frameName +'" src="'+ p.src +'" width=100% height=100% ></iframe>';}				
			}else{
				return false;
			}
			return true;					
						
		})
		obj.on("tabchange",function(tp,p){
			//解病人锁
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
			var frm = dhcsys_getmenuform();
			if(p.allRefresh === true){			
				if ( frm.EpisodeID.value > 0){
					hrefRefresh(true);
				}
			}else{
				xhrRefresh(true);
			}
		})
	}
	Ext.EventManager.on(Ext.getBody(),'keydown',ChangeCharPage)
};
function viewportRenderer(){
	Ext.getCmp("docmainviewport").syncSize();
}
//通过cspname类型chart配置取chart的color与数量
var getChartItemsInfo = function(PatientId,EpisodeId,mradm){
	Ext.Ajax.request({
	   url: "ext.websys.datatrans.csp",
	   success: function(res,opts){
		   var rtn = res.responseText.replace(/\r\n/g,"");
		   if (rtn!=""){	  
				var obj = Ext.decode(rtn);
				if (obj){
					var tabs = Ext.getCmp('DHCDocTabPanel');
					var len = tabs.items.length;
					for(var i=0; i<len; i++){
						var tabsItemEl = tabs.getTabEl(i);
						// 清除特殊样式
						if(tabsItemEl.className.indexOf("x-tab-strip-active")>-1) {
							tabsItemEl.className = "x-tab-strip-active";
						}else{
							tabsItemEl.className = "";
						}
						tabs.getItem(i).setTitle(tabItemsJson[i]["title"]);
						if (obj[i]){
							var itemStyleObj = obj[i];
							// 设置样式
							if (itemStyleObj["className"]) Ext.fly(tabsItemEl).addClass(itemStyleObj.className);
							if (itemStyleObj["count"]) tabs.getItem(i).setTitle(itemStyleObj.tabTitle+'('+itemStyleObj.count+')');
						}
					}
				}
		   }
		},
	   failure: function(res,opts){},
	   params: {
		   pClassName:"epr.Chart",
		   pClassMethod:"GetPatChartInfo",
		   ChartBookID:ChartBookID,
		   PatientId:PatientId,
		   EpisodeId:EpisodeId,
		   mradm:mradm
		}
	});
}
var init = function(){	
	Ext.QuickTips.init();
	//resetEprMenuForm();
	initComp();
	initListener();
	//$("#PatientView").click(PatientViewClick)
};
function getConfigUrl(userid,groupid,locid){
	return {url:"oeorder.oplistcustom.config.hui.csp",width:700,height:520,title:'诊疗配置'};
}
Ext.onReady(init);